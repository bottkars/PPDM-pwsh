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

"@ -ErrorAction SilentlyContinue

    [System.Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName TrustAllCertsPolicy -ErrorAction SilentlyContinue



}
function Connect-PPDMapiEndpoint {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'Credential', ValueFromPipelineByPropertyName = $true)]
        [pscredential]$PPDM_API_Credentials = $Global:PPDM_API_Credentials,
        # [Parameter(Mandatory = $true, ParameterSetName = 'User')]
        #[switch]$user,
        #        [Parameter(Mandatory = $false, ParameterSetName = 'client', ValueFromPipelineByPropertyName = $true)]
        # [pscredential]$PPDM_API_ClientCredentials = $Global:PPDM_API_ClientCredentials,
        #        [Parameter(Mandatory = $True, ParameterSetName = 'Client')]
        #        [switch]$Client,
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string][alias('PPDM_API_URI')]
        $PPDM_API_BaseURI = $GLOBAL:PPDM_API_BaseUri,
        [switch]$trustCert,
        #        [Parameter(Mandatory = $True, ParameterSetName = 'SSO')]
        #        [switch]$SSO,
        #        [Parameter(Mandatory = $false, ParameterSetName = 'SSO')]
        #        [string]$SSOToken,
        [switch]$force
    )
    Begin {
        if ($trustCert.IsPresent) {
            if ($($PSVersionTable.PSVersion.Major) -ge 6) {
                $global:SkipCertificateCheck = $TRUE
            }
            else {
                
                Unblock-PPDMSSLCerts    
            }
            
        }  
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
        $PPDM_API_BaseURI=$PPDM_API_BaseURI -replace "HTTPS://",""
        $PPDM_API_BaseURI=$PPDM_API_BaseURI -replace "HTTP://",""
        $Global:PPDM_API_BaseUri = "HTTPS://$($PPDM_API_BaseURI)"
        $Global:PPDM_API_PORT = "8443"
        Write-Verbose $Global:PPDM_API_BaseUri
        switch ($PsCmdlet.ParameterSetName) {
            'SSO' {
                if (!$SSOToken) {
                    $SSOToken = Read-Host -prompt "Please enter your Temporary Code from $($PPDM_API_BaseUri):8443/passcode"
                    $body = "grant_type=password&passcode=$SSOToken"
                }
            }
            default    {
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
            'Credential'
            {
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
                    -UseBasicParsing -Uri "$($Global:PPDM_API_BaseUri):$($Global:PPDM_API_PORT)/api/v2/login" 
            }   
            else {
                $Response = Invoke-RestMethod `
                    -Method POST -Headers $headers -Body $body `
                    -UseBasicParsing -Uri "$($Global:PPDM_API_BaseUri):$($Global:PPDM_API_PORT)/api/v2/login"
            }
        }
        catch {
            Get-PPDMWebException -ExceptionMessage $_
            switch ($PsCmdlet.ParameterSetName) {
                'Credential' {
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
            default {
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
            Uri             = "$($Global:PPDM_API_BaseUri):$($Global:PPDM_API_PORT)$apiver/token"
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
        $apiport = "$($Global:PPDM_API_PORT)",        
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        $PPDM_API_BaseUri = $($Global:PPDM_API_BaseUri),
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        [ValidateSet('Rest', 'Web')]$RequestMethod,        
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        $Body,
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        $Filter,
        [Parameter(Mandatory = $true, ParameterSetName = 'infile')]
        $InFile
    )
    $uri = "$($Global:PPDM_API_BaseUri):$apiport$apiver$uri"
    if ($Global:PPDM_API_Headers) {
        $Headers = $Global:PPDM_API_Headers
        Write-Verbose ($Headers | Out-String)
        Write-Verbose "==> Calling $uri"
        $Parameters = @{
            UseBasicParsing = $true 
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
                if ($filter) {
                    $filterstring = [System.Web.HTTPUtility]::UrlEncode($filter)
                    $filterstring = "filter=$filterstring"
                    Write-Verbose $filterstring | Out-String
                    $uri = "$($uri)?$filterstring"
                    Write-Verbose $uri
                }

            }
        }
        $Parameters.Add('URI', $uri)
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
        Write-Warning "PPDM_API_Headers are not present. Did you connect to PPDM_API  using connect-PPDMAPIendpoint ? "
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
    Remove-Variable PPDM_API_PORT -Scope Global -ErrorAction SilentlyContinue

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
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
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
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('FULL', 'SYNTHETIC_FULL', 'DIFFERNTIAL', 'GEN0', 'LOG', 'INCREMENTAL', 'CUMULATIVE', 'AUTO_FULL')]
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
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
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

#{start: "/inventory-sources/69c8ac3a-3eca-55f1-a2e0-347e63a90540", level: "DataCopies"}
#level: "DataCopies"
#start: "/inventory-sources/69c8ac3a-3eca-55f1-a2e0-347e63a90540"
function Start-PPDMdiscoveries {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$id,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('DataCopies')]
        [string]$level,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('inventory-sources', 'hosts', 'storage-systems')]
        [string]$start,      
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(10) -replace "_", "-").ToLower()   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            default {
                $URI = "/$myself"
                $Body = [ordered]@{
                    'id'    = $id
                    'start' = "/$start/$id"
                    'level' = "$level"
                } | ConvertTo-Json
            }
        } 
        Write-Verbose ($Body | Out-String)
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
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
                write-output ($response.content | convertfrom-json)
            } 
        }   
    }
}

#######
# protection-policies
#######



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
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
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
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
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
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
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
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
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
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
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
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
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
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
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
        [ValidateCount(1,2)][ValidateScript( { $_ -match [IPAddress]$_ })]
        [string[]]$NTPservers,
        [String]$Timezone = 'Europe/Berlin - Central European Time',
        [Parameter(Mandatory = $true)]
 #       [ValidatePattern('^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{9,}$')]
        [securestring][alias('admin_password')]$Password,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $admin_oldpassword = '@ppAdm1n'
        $root_oldpassword = 'changeme'
        $support_oldpassword = '$upp0rt!'        
        $lockbox_oldpassphrase = 'Ch@ngeme1'
        $admin_password = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
        if (!$PSBoundParameters.ContainsKey('root_Password')) { $root_Password = $admin_password }
        if (!$PSBoundParameters.ContainsKey('support_Password')) { $support_Password = $admin_password }
        if (!$PSBoundParameters.ContainsKey('lockbox_Passphrase')) { $lockbox_Passphrase = $admin_password }
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
        $Configurations | Add-Member -NotePropertyName applicationUserPassword -NotePropertyValue $admin_password -Force
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
                write-verbose ($body | out-string)

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
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
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


function Approve-PPDMEula {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "PATCH"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {

        $body = @{
            accepted = "true"
        } | convertto-json 
        $Parameters = @{
            body             = $body 
            Uri              = '/eulas/PPDM'
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
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

            default {
                write-output $response
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
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
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


function Get-PPDMTimezones {
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
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
   
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
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
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

# 	


# Start CDR Configuration
# {"operation":"start"}

function Wait-PPDMApplianceFresh {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$URI,
        [switch]$trustCert
    )

    Begin {
        $Parameters = @{
            UseBasicParsing = $true 
            Uri             = "$Uri/#/fresh"
            Method          = "GET"
            ContentType     = "application/json"
        }
        if ($trustCert.IsPresent) {
            if ($($PSVersionTable.PSVersion.Major) -ge 6) {
                $Parameters.Add('SkipCertificateCheck', $True)
            }
            else {
                Unblock-PPDMSSLCerts    
            }
        }
    }

    Process {
        do {
            Try {     
                $req = Invoke-WebRequest @Parameters
            }
            Catch {
                $message = $_.exception.message
                Write-Warning $message
                start-sleep  20
            }
            Finally {
                If ($req.statuscode) {
                    Write-Host $req.statuscode
                }
            }
        } until ($req.statuscode -eq "200")    
        
    }
    End {
        Write-Host "Appliance $URI is ready for configuration now"
    }
}