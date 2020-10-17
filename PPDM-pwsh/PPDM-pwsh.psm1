function Unblock-PPDMSSLCerts {

    Add-Type -TypeDefinition @"

	    using System.Net;

	    using System.Security.Cryptography.X509Certificates;

	    public class TrustAllCertsPolicy : ICertificatePolicy {

	        public bool CheckValidationResult(

	            ServicePoint srvPoint, X509Certificate certificate,

	            WebRequest request, int certificateProblem) {

	            return true;

	        }

	    }

"@

    [System.Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName TrustAllCertsPolicy



}
function Connect-PPDMapiEndpoint {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'User', ValueFromPipelineByPropertyName = $true)]
        [pscredential]$PPDM_API_Credentials = $Global:PPDM_API_Credentials,
        [Parameter(Mandatory = $true, ParameterSetName = 'User')]
        [switch]$user,
        #        [Parameter(Mandatory = $false, ParameterSetName = 'client', ValueFromPipelineByPropertyName = $true)]
        [pscredential]$PPDM_API_ClientCredentials = $Global:PPDM_API_ClientCredentials,
        #        [Parameter(Mandatory = $True, ParameterSetName = 'Client')]
        #        [switch]$Client,
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string]
        $PPDM_API_URI = $Global:PPDM_API_BaseUri,
        [switch]$trustCert,
        #        [Parameter(Mandatory = $True, ParameterSetName = 'SSO')]
        #        [switch]$SSO,
        #        [Parameter(Mandatory = $false, ParameterSetName = 'SSO')]
        #        [string]$SSOToken,
        [switch]$force
    )
    Begin {
        if ($trustCert.IsPresent) {
            if ($PSVersiontable.PSVersion -ge 6.0) {
                $global:SkipCertificateCheck = $TRUE
            }
            else {
                Unblock-PPDMSSLCerts    
            }
            
        }  
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
        if ($force.IsPresent) {
            write-verbose "Removing old Scope"
            Remove-Variable PPDM_API_BaseUri -Scope Global -ErrorAction SilentlyContinue
            Remove-Variable PPDM_API_Headers -Scope Global -ErrorAction SilentlyContinue
            Remove-Variable PPDM_API_ClientCredentials -Scope Global -ErrorAction SilentlyContinue
            Remove-Variable PPDM_API_Credentials -Scope Global -ErrorAction SilentlyContinue
            Remove-Variable PPDM_Scope -Scope Global -ErrorAction SilentlyContinue
            Remove-Variable PPDM_Refresh_token -Scope Global -ErrorAction SilentlyContinue
        }
        #        $client_encoded = [System.Text.Encoding]::UTF8.GetBytes($clientid)
        #        $client_base64 = [System.Convert]::ToBase64String($client_encoded)
        $headers = @{
            'content-type' = "application/json"
        }          
    }
    Process {
        $Global:PPDM_API_BaseUri = "$($PPDM_API_URI):8443"
        Write-Verbose $Global:PPDM_API_BaseUri
        switch ($PsCmdlet.ParameterSetName) {
            'SSO' {
                if (!$SSOToken) {
                    $SSOToken = Read-Host -prompt "Please enter your Temporary Code from $($PPDM_API_BaseUri):8443/passcode"
                    $body = "grant_type=password&passcode=$SSOToken"
                }
            }
            'USER' {
                if (!$($Global:PPDM_API_Credentials)) {
                    $username = Read-Host -Prompt "Please Enter PPDM username"
                    $SecurePassword = Read-Host -Prompt "Password for user $username" -AsSecureString
                    $PPDM_API_Credentials = New-Object System.Management.Automation.PSCredential($username, $Securepassword)
                }
                $password = $($PPDM_API_Credentials.GetNetworkCredential()).password
                $Body = @{
                    'username' = $($PPDM_API_Credentials.username)
                    'password' = $password
                }
   
            }
            <#           'CLIENT' {
                if (!$PPDM_API_ClientCredentials) {
                    $client_id = Read-Host -Prompt "Please Enter PKS PPDM_API_anager Client"
                    $client_secret = Read-Host -Prompt "Secret for $client_id" -AsSecureString
                    $PPDM_API_ClientCredentials = New-Object System.Management.Automation.PSCredential($client_id, $client_secret)
                
                }
                $clientid = "$([System.Web.HttpUtility]::UrlEncode($PPDM_API_ClientCredentials.username))" # :$([System.Web.HttpUtility]::UrlEncode(($PPDM_API_ClientCredentials.GetNetworkCredential()).password))"
                $Body = @{
                    'grant_type'    = "client_credentials"
                    'client_id'     = $([System.Web.HttpUtility]::UrlEncode($PPDM_API_ClientCredentials.username))
                    'token_format'  = "opaque"
                    'client_secret' = $([System.Web.HttpUtility]::UrlEncode(($PPDM_API_ClientCredentials.GetNetworkCredential()).password))
                } 
                $headers = @{'content-type' = "application/x-www-form-urlencoded;charset=utf-8"
                    'Accept'                = "application/json"

                }
            }#>
        }    
        Write-Verbose ($body | Out-String)
        Write-Verbose ( $headers | Out-String ) 
        $body = $body | ConvertTo-Json
        try {  
            if ($Global:SkipCertificateCheck) {            
                $Response = Invoke-RestMethod -SkipCertificateCheck `
                    -Method POST -Headers $headers -Body $body `
                    -UseBasicParsing -Uri "$($Global:PPDM_API_BaseUri)/api/v2/login" 
            }   
            else {
                $Response = Invoke-RestMethod `
                    -Method POST -Headers $headers -Body $body `
                    -UseBasicParsing -Uri "$($Global:PPDM_API_BaseUri)/api/v2/login"
            }
        }
        catch {
            Get-PPDMWebException -ExceptionMessage $_
            switch ($PsCmdlet.ParameterSetName) {
                'USER' {
                    Remove-Variable PPDM_API_Credentials
                } 
                'CLIENT' {
                    Remove-Variable PPDM_API_ClientCredentials
                } 
            }
            Break
        }
        #>
    }
    End {
        switch ($PsCmdlet.ParameterSetName) {
            'Client' {
                $Global:PPDM_API_ClientCredentials = $PPDM_API_ClientCredentials
            }
            'User' {
                $Global:PPDM_API_Credentials = $PPDM_API_Credentials
            }
        }
        
        $Global:PPDM_API_Headers = @{
            'Authorization' = "Bearer $($Response.access_token)"
        }
        $Global:PPDM_Refresh_token = $Response.Refresh_token
        $Global:PPDM_Scope = $Response.Scope
        Write-Host "Connected to $PPDM_API_BASEURI with Scope $($Response.Scope)"
        Write-Output $Response
    }
}


function Update-PPDMToken {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )

    begin { 
        $METHOD = "POST"
        $Body = @{
            'grant_type'    = "refresh_token"
            'refresh_token' = "$($Global:PPDM_Refresh_token)"
            'scope'         = $Global:PPDM_Scope
        } | convertto-json
    }
    process {
        $Parameters = @{
            UseBasicParsing = $true 
            Uri             = "$($Global:PPDM_API_BaseUri)$apiver/token"
            Method          = $Method
            Headers         = $Global:PPDM_API_Headers
            ContentType     = "application/json"
            Body            = $Body
        }           
        if ($Global:SkipCertificateCheck) { 
            $Parameters.Add('SkipCertificateCheck', $true) 
        }   
        try {     
            $Response = Invoke-RestMethod @Parameters

        }
        catch {
            Get-PPDMWebException -ExceptionMessage $_
            Break
        }
    } 
    End {

        $Global:PPDM_API_Headers = @{
            'Authorization' = "Bearer $($Response.access_token)"
        }
        $Global:PPDM_Refresh_token = $Response.Refresh_token
        $Global:PPDM_Scope = $Response.Scope
        Write-Host "Connected to $PPDM_API_BASEURI with $($Response.Scope)"
        Write-Output $Response
    }
}






function Invoke-PPDMapirequest {
    [CmdletBinding(HelpUri = "")]
    #[OutputType([int])]
    Param
    (
        [Parameter(Mandatory = $true, ParameterSetName = 'default')]
        [Parameter(Mandatory = $true, ParameterSetName = 'infile')]
        $uri,
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $true, ParameterSetName = 'infile')]
        [ValidateSet('Get', 'Delete', 'Put', 'Post', 'Patch')]
        $Method,
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $true, ParameterSetName = 'infile')]
        $Query,
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        $ContentType = 'application/json', 
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        $apiver = "/api/v2",
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        $PPDM_API_BaseUri = $($Global:PPDM_API_BaseUri),
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        [ValidateSet('Rest', 'Web')]$RequestMethod,        
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        $Body,
        [Parameter(Mandatory = $true, ParameterSetName = 'infile')]
        $InFile
    )
    $uri = "$($Global:PPDM_API_BaseUri)$apiver$uri"
    if ($Global:PPDM_API_Headers) {
        $Headers = $Global:PPDM_API_Headers
        Write-Verbose ($Headers | Out-String)
        Write-Verbose "==> Calling $uri"
        $Parameters = @{
            UseBasicParsing = $true 
            Uri             = $Uri
            Method          = $Method
            Headers         = $Headers
            ContentType     = $ContentType
        }
        switch ($PsCmdlet.ParameterSetName) {    
            'infile' {
                $Parameters.Add('InFile', $InFile) 
            }
            default {
                if ($Body) {
                    $Parameters.Add('body', "$body")
                }
                if ($query) {
                    $Parameters.Add('body', $query)
                    Write-Verbose $Query | Out-String
                }

            }
        }
        if ($Global:SkipCertificateCheck) {
            $Parameters.Add('SkipCertificateCheck', $True)
        }
        Write-Verbose ( $Parameters | Out-String )    
        try {
            switch ($RequestMethod) {
                'Web' {
                    $Result = Invoke-WebRequest @Parameters
                }
                'Rest' {
                    
                    $Result = Invoke-RestMethod @Parameters
                }
                default {
                    $Result = Invoke-WebRequest @Parameters
                }
            }
            
        }
        catch {
            # Write-Warning $_.Exception.Message
            Get-PPDMWebException -ExceptionMessage $_
            Break
        }
    }
    else {
        Write-Warning "PPDM_API_Headers are not present. Did you connect to PPDM_API  using connect-PPDMAPI ? "
        break
    }
    
    Write-Output $Result
}

# /v1/clusters/{clusterName}/binds/{userName}







# DELETE /api/v0/sessions
function Disconnect-PPDMsession {
    [CmdletBinding()]
    param(
    )
 
    $METHOD = "POST"
    $URI = "$($Global:PPDM_API_BaseUri)/api/v2/logout"
    $Parameters = @{
        Uri         = $Uri
        Method      = $Method
        Headers     = $Global:PPDM_API_Headers
        ErrorAction = "SilentlyContinue"
    }

    if ($Global:SkipCertificateCheck) {
        $Parameters.Add('SkipCertificateCheck', $True)
    }
    Invoke-RestMethod @Parameters
    Write-Verbose "Unsetting Parameters"
    Remove-Variable PPDM_API_BaseUri -Scope Global -ErrorAction SilentlyContinue
    Remove-Variable PPDM_API_Headers -Scope Global -ErrorAction SilentlyContinue
    Remove-Variable PPDM_API_ClientCredentials -Scope Global -ErrorAction SilentlyContinue
    Remove-Variable PPDM_API_Credentials -Scope Global -ErrorAction SilentlyContinue
    Remove-Variable PPDM_Scope -Scope Global -ErrorAction SilentlyContinue
    Remove-Variable PPDM_Refresh_token -Scope Global -ErrorAction SilentlyContinue


}


# /api/v2/assets
function Get-PPDMassets {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id
    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "/").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id"
            }
            default {
                $URI = "/$myself"
            }
        }        
        try {
            $Response += Invoke-PPDMapirequest -uri $URI -Method $METHOD -Body "$body"
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response | convertfrom-json
            }
            default {
                write-output ($response | convertfrom-json).content
            } 
        }   
    }
}
function Get-PPDMinventory_sources {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id
    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id"
            }
            default {
                $URI = "/$myself"
            }
        }        
        try {
            $Response += Invoke-PPDMapirequest -uri $URI -Method $METHOD -Body "$body"
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response | convertfrom-json
            }
            default {
                write-output ($response | convertfrom-json).content
            } 
        }   
    }
}

function Get-PPDMactivities {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'query', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $false, ParameterSetName = 'query', ValueFromPipelineByPropertyName = $true)]
        $query,
        [Parameter(Mandatory = $false, ParameterSetName = 'query', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('RUNNING')]
        $Filter,                 
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [alias('taskid')]$id
    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "/").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'query' {
                Switch ($Filter) {
                    'Running' {
                                
                        $filterstring = 'filter=parentId%20eq%20null%20and%20classType%20in%20(%22JOB%22%2C%20%22JOB_GROUP%22)%20and%20state%20in%20(%22RUNNING%22%2C%20%22QUEUED%22%2C%20%22PENDING_CANCELLATION%22)'
                    }
                    default {
                        $filterstring = ""
                    }
                }
                if ($query) { $query = "q=$query" }  
                $URI = "/$($myself)?$filterstring&$query"
            }
            'byID' {
                $URI = "/$myself/$id"
            }
            default {
                $URI = "/$myself"
            }
        }        
        try {
            $Response += Invoke-PPDMapirequest -uri $URI -Method $METHOD  -apiver $apiver -PPDM_API_BaseUri $PPDM_API_BaseUri
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response | convertfrom-json
            }
            default {
                write-output ($response | convertfrom-json).content
            } 
        }   
    }
}
#/api/v2/protection-engines
function Get-PPDMprotection_engines {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id"
            }
            default {
                $URI = "/$myself"
            }
        }  
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
        }      
        try {
            $Response += Invoke-PPDMapirequest @Parameters
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response | convertfrom-json
            }
            default {
                write-output ($response | convertfrom-json).content
            } 
        }   
    }
}

# /api/v2/asset-backups
function Start-PPDMasset_backups {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string][alias('id')]$AssetID,
        $BackupType = 'FULL'
    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(10) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself"
            }
            default {
                $URI = "/$myself"
            }
        }    
        $Body = [ordered]@{
            'assetId'    = $AssetID
            'backupType' = $BackupType
        } | convertto-json -compress
        write-verbose ($body | out-string)
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
        }           
        try {
            $Response += Invoke-PPDMapirequest @Parameters
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response | convertfrom-json
            }
            default {
                write-output ($response | convertfrom-json).content
            } 
        }   
    }
}


################
#Discoveries
################
# /api/v2/discoveries
function Get-PPDMdiscoveries {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {

            default {
                $URI = "/$myself"
            }
        }        
        try {
            $Response += Invoke-PPDMapirequest -uri $URI -Method $METHOD -Body "$body" -apiver $apiver -PPDM_API_BaseUri $PPDM_API_BaseUri
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response | convertfrom-json
            }
            default {
                write-output ($response | convertfrom-json).content
            } 
        }   
    }
}

function Start-PPDMdiscoveries {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$id,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$level,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$start        
    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(10) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            default {
                $URI = "/$myself"
                $Body = [ordered]@{
                    'id'    = $id
                    'start' = $start
                    'level' = $level
                } | ConvertTo-Json
            }
        } 
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
        }       
        try {
            $Response += Invoke-PPDMapirequest @Parameters
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response | convertfrom-json
            }
            default {
                write-output ($response | convertfrom-json).content
            } 
        }   
    }
}

#######
# protection-policies
#######



function Get-PPDMprotection_policies {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id"
            }
            default {
                $URI = "/$myself"
            }
        }        
        try {
            $Response += Invoke-PPDMapirequest -uri $URI -Method $METHOD -Body "$body" -apiver $apiver -PPDM_API_BaseUri $PPDM_API_BaseUri
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response | convertfrom-json
            }
            default {
                write-output ($response | convertfrom-json).content
            } 
        }   
    }
}

function Start-PPDMprotection_policies {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string][alias('id')]$PolicyID,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false)]
        [ValidateSet('FULL', 'GEN0', 'DIFFERENTIAL', 'LOG', 'INCREMENTAL', 'CUMULATIVE', 'AUTO_FULL')]
        $BackupType = 'FULL',
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false)]
        [ValidateSet('DAY', 'WEEK', 'MONTH', 'YEAR' )]
        $RetentionUnit = 'DAY',
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false)]
        [Int32]$RetentionInterval = '7'        

    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(10) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself"
            }
            default {
                $URI = "/$myself"
            }
        }    
        $Body = [ordered]@{
            'assetIds'                          = $AssetIDs
            'backupType'                        = $BackupType
            'disableProtectionPolicyProcessing' = false
            'retention'                         = @{
                'interval' = $RetentionInterval
                'unit'     = $RetentionUnit
            }
        } | convertto-json -compress
        write-verbose ($body | out-string)
        $Parameters = @{
            body             = $body 
            Uri              = "/$Myself/$PolicyID/backups"
            Method           = $Method
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
        }           
        try {
            $Response += Invoke-PPDMapirequest @Parameters
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response | convertfrom-json
            }
            default {
                write-output ($response | convertfrom-json).content
            } 
        }   
    }
}



###########################
###### Appliance Management
# Appliance content is delivered via hal-json and thus shall be triggered my restmethod
###########################
# /common-settings

function Get-PPDMcommon_settings {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$id,        
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id"
            }
            default {
                $URI = "/$myself"
            }
        }  
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
        }      
        try {
            $Response += Invoke-PPDMapirequest @Parameters
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response
            }
            default {
                write-output $response.content
            } 
        }   
    }
}

function Get-PPDMcomponents {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$id,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id"
            }
            default {
                $URI = "/$myself"
            }
        }  
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
        }      
        try {
            $Response += Invoke-PPDMapirequest @Parameters
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response 
            }
            default {
                write-output $response.content 
            } 
        }   
    }
}


function Get-PPDMconfigurations {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$id,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id"
            }
            default {
                $URI = "/$myself"
            }
        }  
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
        }      
        try {
            $Response += Invoke-PPDMapirequest @Parameters
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response 
            }
            default {
                write-output $response.content 
            } 
        }   
    }
}

# /api/v2/configurations/{configurationId}/config-status
function Get-PPDMconfigstatus {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$id,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = 'configurations'
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id/config-status"
            }
            default {
                $URI = "/$myself"
            }
        }  
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
        }      
        try {
            $Response += Invoke-PPDMapirequest @Parameters
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response 
            }
            default {
                write-output $response.content 
            } 
        }   
    }
}


function Get-PPDMnodes {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$Nodeid,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$Nodeid"
            }
            default {
                $URI = "/$myself"
            }
        }  
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
        }      
        try {
            $Response += Invoke-PPDMapirequest @Parameters
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response 
            }
            default {
                write-output $response.content 
            } 
        }   
    }
}


function Set-PPDMnodes {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$Nodeid,
        [Parameter(Mandatory = $True, ParameterSetName = 'byID')]
        [ValidateSet('MAINTENANCE', 'RESTORE', 'QUIESCE', 'OPERATIONAL')]
        [string]$status,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "PUT"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$Nodeid"
            }
            default {
                $URI = "/$myself"
            }
        } 
        $body = @{
            id     = $NodeID
            status = $status
        } | convertto-json 
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
        }      
        try {
            $Response += Invoke-PPDMapirequest @Parameters
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response 
            }
            default {
                write-output $response.content 
            } 
        }   
    }
}

#/api/v2/disks
function Get-PPDMdisks {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$id,
        [switch]$PartitionDetails,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id"
            }
            default {
                $URI = "/$myself"
            }
        }  
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
        }      
        try {
            $Response += Invoke-PPDMapirequest @Parameters
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {
        if ($PartitionDetails.ispresent) {
            $Parameters = @{
                Property        = '*'
                ExcludeProperty = ("name", "totalSize", "availableSize", "partitions", "_links")
                ExpandProperty  = 'partitions'
            }    
        }
        else {
            $Parameters = @{
                Property = '*'
            } 
        }

        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response | Select-Object @Parameters
            }
            default {
                write-output $response.content | Select-Object @Parameters
            } 
        }   
    }
}

#### initial Config

function Set-PPDMconfigurations {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateCount(1, 2)][ValidateScript( { $_ -match [IPAddress]$_ })]
        [string[]]$NTPservers,
        [String]$Timezone = 'Europe/Berlin - Central European Time',
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{9,}$')]
        [String]$admin_Password,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $admin_oldpassword = '@ppAdm1n'
        $root_oldpassword = 'changeme'
        $support_oldpassword = '$upp0rt!'        
        $lockbox_oldpassphrase = 'Ch@ngeme1'

        if (!$PSBoundParameters.ContainsKey('root_Password')) { $root_Password = $Admin_Password }
        if (!$PSBoundParameters.ContainsKey('support_Password')) { $support_Password = $Admin_Password }
        if (!$PSBoundParameters.ContainsKey('lockbox_Passphrase')) { $lockbox_Passphrase = $Admin_Password }
        $Response = @()
        $METHOD = "PUT"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id"
            }
            default {
                $URI = "/$myself"
            }
        }  
        Write-Host "Getting Powerprotect initial Configuration"
        try {
            $Configurations = Get-PPDMConfigurations
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($Configurations | Out-String)
        ## Check  appliance status
        Write-Host "Checking Node Status"
        try {
            $Node = Invoke-PPDMapirequest -uri "/nodes/$($configurations.NodeID)" -Method Get -RequestMethod Rest
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        if ($($Node.status) -ne "PENDING") {
            Write-Warning "Node $($configurations.NodeID) in Node Status $($Node.status), cannot Continue"
            Break
        }
        write-host "Node $($Node.Id) is in Status $($Node.status) and has Version $($Node.Version)"
        Write-Verbose "Building Desired State"
        $Configurations = $Configurations  | Select-Object -ExcludeProperty _links
        foreach ($user in ('root', 'admin', 'support')) {
            write-host "setting user Configuration for $user"   
            $Configurations.osUsers | where userName -eq $user | Add-Member -NotePropertyName password -NotePropertyValue (get-variable ${user}_oldpassword).value -Force
            $Configurations.osUsers | where userName -eq $user | Add-Member -NotePropertyName newPassword -NotePropertyValue (get-variable ${user}_password).value -Force
        }
        write-host "setting user Configuration for ApplicationUser"
        $Configurations | Add-Member -NotePropertyName applicationUserPassword -NotePropertyValue $admin_Password -Force
        write-host "setting Lockbox"
        $Configurations.lockbox | Add-Member -NotePropertyName passphrase -NotePropertyValue $lockbox_oldpassphrase -Force
        $Configurations.lockbox | Add-Member -NotePropertyName newPassphrase -NotePropertyValue $lockbox_passphrase -Force
        write-Host "Setting Timezone"
        $Configurations.timeZone = $Timezone
        $Configurations.ntpServers = $ntpservers 
        write-verbose ($Configurations | convertto-json | out-string) 
        $body = $configurations | convertto-json -depth 5 -compress 
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response 
            }
            default {
                write-verbose $body

                $Parameters = @{
                    body             = "$body" 
                    Uri              = "$Uri/$($Configurations.ID)"
                    Method           = $Method
                    RequestMethod    = "Rest"
                    ContentType      = 'application/json'
                    PPDM_API_BaseUri = $PPDM_API_BaseUri
                    apiver           = $apiver
                } 
                write-verbose ( $Parameters | out-String) 
                Write-Host "Applying Appliance Configuration"     
                try {
                    $Response += Invoke-PPDMapirequest @Parameters
                }
                catch {
                    Get-PPDMWebException  -ExceptionMessage $_
                    break
                }
            } 
        }   
    }

    end { 
        write-output $Response
    }    
} 


# /api/v2/cloud-dr-accounts


function Set-PPDMcomponents {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$id,
        [Parameter(Mandatory = $True, ParameterSetName = 'byID')]
        [ValidateSet('DOWN', 'UP')]
        [string]$status,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id/management"
            }
            default {
                $URI = "/$myself"
            }
        } 
        $body = @{
            operation = "start"
        } | convertto-json 
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
        }      
        try {
            $Response += Invoke-PPDMapirequest @Parameters
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response 
            }
            default {
                write-output $response.content 
            } 
        }   
    }
}



function Get-PPDMTELEMETRY_SETTING {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$ID,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "GET"
        # $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
        $Myself = "common-settings/TELEMETRY_SETTING"
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$ID"
            }
            default {
                $URI = "/$myself"
            }
        }  
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
        }      
        try {
            $Response += Invoke-PPDMapirequest @Parameters
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response 
            }
            default {
                write-output $response
            } 
        }   
    }
}


# 	


# Start CDR Configuration
# {"operation":"start"}