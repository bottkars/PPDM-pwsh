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
    [Alias('Connect-PPDMsystem')]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'Credential', ValueFromPipelineByPropertyName = $true)]
        [Alias('credential')][pscredential]$PPDM_API_Credentials = $Global:PPDM_API_Credentials,
        # [Parameter(Mandatory = $true, ParameterSetName = 'User')]
        #[switch]$user,
        #        [Parameter(Mandatory = $false, ParameterSetName = 'client', ValueFromPipelineByPropertyName = $true)]
        # [pscredential]$PPDM_API_ClientCredentials = $Global:PPDM_API_ClientCredentials,
        #        [Parameter(Mandatory = $True, ParameterSetName = 'Client')]
        #        [switch]$Client,
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string][alias('FQDN')]
        $PPDM_API_BaseURI = $GLOBAL:PPDM_API_BaseUri,
        [switch]$trustCert,
        #        [Parameter(Mandatory = $True, ParameterSetName = 'SSO')]
        #        [switch]$SSO,
        #        [Parameter(Mandatory = $false, ParameterSetName = 'SSO')]
        #        [string]$SSOToken,
        [switch]$force
    )
    Begin {
        if ($($PSVersionTable.PSVersion.Major) -le 5) {
            Write-Verbose "Setting TLS1.2"    
            [Net.ServicePointManager]::SecurityProtocol =
            [Net.ServicePointManager]::SecurityProtocol -bor
            [Net.SecurityProtocolType]::Tls12
        }
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
        $PPDM_API_BaseURI = $PPDM_API_BaseURI -replace "HTTPS://", ""
        $PPDM_API_BaseURI = $PPDM_API_BaseURI -replace "HTTP://", ""
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
            default {
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
            'Credential' {
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

        $Global:PPDM_API_Token = $Response.access_token
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
            'scope'         = $($Global:PPDM_Scope)
        } | convertto-json
    }
    process {
        $Parameters = @{
            UseBasicParsing = $true 
            body            = $body 
            Headers         = @{
                "Authorization" = "Bearer $($Global:PPDM_Refresh_token)" 
            }
            Uri             = "$($Global:PPDM_API_BaseUri):$($Global:PPDM_API_PORT)$apiver/token"
            Method          = $Method
            Verbose         = $PSBoundParameters['Verbose'] -eq $true
            ContentType     = "application/json"
        }
        if ($Global:SkipCertificateCheck) {
            $Parameters.Add('SkipCertificateCheck', $True)
        }
        Write-Verbose ($Body | Out-String)
        Write-Verbose ($Parameters | Out-String)           
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
        $Global:PPDM_API_Token = $Response.access_token
        $Global:PPDM_Scope = $Response.Scope
        #  $Global:PPDM_Refresh_token = $Response.Refresh_token
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
        [Parameter(Mandatory = $false, ParameterSetName = 'outfile')]
        $uri,
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'outfile')]
        [Parameter(Mandatory = $true, ParameterSetName = 'infile')]
        [ValidateSet('Get', 'Delete', 'Put', 'Post', 'Patch')]
        $Method,
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'outfile')]
        [Parameter(Mandatory = $true, ParameterSetName = 'infile')]
        $Query,
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'outfile')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        $ContentType = 'application/json', 
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'outfile')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        $ResponseHeadersVariable,     
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'outfile')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        $apiver = "/api/v2",
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'outfile')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        [int]$retries = 0,
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'outfile')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        [int]$timeout = 0,        
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'outfile')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        $apiport = "$($Global:PPDM_API_PORT)",        
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'outfile')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        $PPDM_API_BaseUri = $($Global:PPDM_API_BaseUri),
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'outfile')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        [ValidateSet('Rest', 'Web')]$RequestMethod,        
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        $Body = @{},
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [switch]$ChangeUserPassword,
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        $Filter,
        [Parameter(Mandatory = $true, ParameterSetName = 'infile')]
        $InFile,
        [Parameter(Mandatory = $true, ParameterSetName = 'outfile')]
        $OutFile        
    )
    $apiver = $apiver.trimstart('/')
    $apiver = $apiver.trimend('/')
    $uri = $uri.trimstart('/')
    $uri = $uri.trimend('/')

    $uri = "$($Global:PPDM_API_BaseUri):$apiport/$apiver/$uri"
    if ((($Global:PPDM_API_Headers) -and ($Global:PPDM_API_Token) -and ($Global:PPDM_Refresh_token)) -or ($ChangeUserPassword.ispresent)) {
        # checking token
        Write-Verbose "Checking Token"
        if (!$ChangeUserPassword.IsPresent) {
            $refreshDate = (Get-Date -Date "01-01-1970") + ([System.TimeSpan]::FromSeconds(((Show-PPDMJWTtoken -token $Global:PPDM_Refresh_token).exp)))
            $TokenDate = (Get-Date -Date "01-01-1970") + ([System.TimeSpan]::FromSeconds(((Show-PPDMJWTtoken -token $Global:PPDM_API_Token).exp)))
            $TokenDate = $TokenDate.ToLocalTime()
            $refreshDate = $refreshDate.ToLocalTime()
            if ($TokenDate -lt (get-date)) {
                Write-Warning "Auth Token with timestamp $TokenDate has expired, will try to refresh"
                if ($refreshDate -lt (get-date)) {
                    Write-Warning "Refresh Token Expired, please re-authenticate with PPDM"
                    return
                }
                else {
                    Write-Verbose "Refreshing Token using Refresh Token"
                    Update-PPDMToken 6>$null | out-null
                }
          
            }
            $Headers = $Global:PPDM_API_Headers
            Write-Verbose ($Headers | Out-String)  
        }

        Write-Verbose "==> Calling $uri"
        $Parameters = @{
            UseBasicParsing = $true 
            Method          = $Method
            ContentType     = $ContentType
            Verbose         = $PSBoundParameters['Verbose'] -eq $true
        }
        if ($Headers) { 
            $Parameters.Add('Headers', $Headers)
        }
        write-verbose ($PsCmdlet.ParameterSetName)
        switch ($PsCmdlet.ParameterSetName) {    
            'infile' {
                $Parameters.Add('InFile', $InFile) 
            }
            'outfile' {
                write-verbose "Adding outfile $outfile"
                $Parameters.Add('OutFile', $outfile) 
            }            
            default {
                if ($Body) {
                    $Parameters.Add('body', $body)
                    Write-Verbose ($Body | Out-String)
                }
                if ($query) {
                    $Parameters.Add('body', $query)
                    Write-Verbose ($Query | Out-String)
                }
                if ($filter) {
                    # $filterstring = [System.Web.HTTPUtility]::UrlEncode($filter)
                    # $filterstring = "filter=$filterstring"
                    write-verbose ($filter | Out-String)
                    $body.add('filter', $Filter) 
                    # $uri = "$($uri)?$filterstring"
                    # Write-Verbose $uri
                }
                if ($ResponseHeadersVariable) {
                    $Parameters.Add('ResponseHeadersVariable', 'HeadersResponse')
                }
            }
        }
        $Parameters.Add('URI', $uri)
        if ($Global:SkipCertificateCheck) {
            $Parameters.Add('SkipCertificateCheck', $True)
        }
        Write-Verbose ( $Parameters | Out-String )    
        do {
            $has_error = 0    
            Write-Verbose $RequestMethod
            try {
                switch ($RequestMethod) {
                    'Web' {
                        $Result = Invoke-WebRequest @Parameters #| ConvertFrom-Json -Depth 7
                    }
                    'Rest' {
                    
                        $Result = Invoke-RestMethod @Parameters
                    }
                    default {
                        $Result = Invoke-WebRequest @Parameters # | ConvertFrom-Json -Depth 7
                    }
                }
            }
            catch {
                # Write-Warning $_.Exception.Message
                Get-PPDMWebException -ExceptionMessage $_
                $has_error = 1
                $retries--
                write-Warning "Retries $Retries timout $Timeout"
                if ($retries -gt 0) { sleep $timeout }   
                else {
                    Break  
                }
            
            }            
        }
        while (($retries -ge 0) -and ($has_error -gt 0))
    }
    else {
        Write-Warning "PPDM_API_Headers,PPDM_API_Token or PPDM_refresh_token are not present. Please re-connect using connect-PPDMsystem"
        break
    }
    if ($ResponseHeadersVariable) {
        Write-Output $HeadersResponse 
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
    Remove-Variable PPDM_API_Token -Scope Global -ErrorAction SilentlyContinue
}





<#
.Synopsis
Starts a Backup of an Asset
.Description
Starts a Backup of an Asset giving Asset ID and Backup type
.Example
Start-PPDMasset_backups -AssetID $Asset.id -BackupType AUTO_FULL
#>
function Start-PPDMasset_backups {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string][alias('id')]$AssetID,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('FULL', 'SYNTHETIC_FULL', 'DIFFERNTIAL', 'GEN0', 'LOG', 'INCREMENTAL', 'CUMULATIVE', 'AUTO_FULL')]
        $BackupType = 'FULL'
    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(10) -replace "_", "-").ToLower()
   
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
            RequestMethod    = 'REST'
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
        # write-verbose ($response | Out-String)
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


function Show-PPDMJWTtoken {
 
    [cmdletbinding()]
    param([Parameter(Mandatory = $true)][string]$token)
    if (!$token.Contains(".") -or !$token.StartsWith("eyJ")) { Write-Error "Invalid token" -ErrorAction Stop }
    #Header
    $tokenheader = $token.Split(".")[0].Replace('-', '+').Replace('_', '/')
    #Fix padding as needed, keep adding "=" until string length modulus 4 reaches 0
    while ($tokenheader.Length % 4) { $tokenheader += "=" }
    #Payload
    $tokenPayload = $token.Split(".")[1].Replace('-', '+').Replace('_', '/')
    #Fix padding as needed, keep adding "=" until string length modulus 4 reaches 0
    while ($tokenPayload.Length % 4) { $tokenPayload += "=" }
    $tokenByteArray = [System.Convert]::FromBase64String($tokenPayload)
    $tokenArray = [System.Text.Encoding]::ASCII.GetString($tokenByteArray)
    $tokobj = $tokenArray | ConvertFrom-Json
    return $tokobj
}


#######
# protection-policies
#######



###########################
###### Appliance Management
# Appliance content is delivered via hal-json and thus shall be triggered my restmethod
###########################
# /common-settings



function Approve-PPDMEula {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "PATCH"
    }     
    Process {

        $body = @{
            accepted = "true"
        } | convertto-json 
        $Parameters = @{
            body             = $body 
            Uri              = '/eulas/data-manager'
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


function Get-PPDMEula {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "GET"
    }     
    Process {

        $body = @{
            accepted = "true"
        } | convertto-json 
        $Parameters = @{
            body             = $body 
            Uri              = '/eulas/data-manager'
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


# 	

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