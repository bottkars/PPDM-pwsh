#    /api/v2/certificates
# /api/v2/certificates?host=<host>&port=<port>&type=Host
function Get-PPDMcertificates {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$ID,
        [Parameter(Mandatory = $true, ParameterSetName = 'byHOST', ValueFromPipelineByPropertyName = $true)]
        [string]$newhost,
        [Parameter(Mandatory = $false, ParameterSetName = 'byHOST', ValueFromPipelineByPropertyName = $true)]
        [string]$Port=443,        
        [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        [switch]$list,
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
                $URI = "/$myself/$ID"
            }
            'byHost' {
                    $URI = "/$($myself)?host=$newhost&port=$port&type=Host"
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
            apiport          = 8443 
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
            'byHost' {
                write-output $response
            }            
            default {
                write-output $response.content
            } 
        }   
    }
}



function Update-PPDMcertificates {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [array]$Certificate,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "PUT"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(11) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {

            default {
                $URI = "/$myself/$($Certificate.id)"
                $body=$Certificate | ConvertTo-Json
            }
        }  
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            apiport          = 8443 
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

function Approve-PPDMcertificates {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipeline = $true)]
        [PSCustomObject]$Certificate,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "PUT"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(12) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {

            default {
                $URI = "/$myself/$($Certificate.id)"
                $Certificate.state="ACCEPTED"
                $body=$Certificate | ConvertTo-Json
                Write-Verbose ($body | Out-String)
            }
        }  
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            apiport          = 8443 
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

function Remove-PPDMcertificates {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$ID,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "DELETE"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(11) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        $URI = "/$myself/$ID"
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            apiport          = 8443 
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

<#
.Synopsis
Add ROOT Certificate Chain to PPDM for a given Host
.Description
Allows to add ROOT Chain for Clustered Host / Kubernetes Clusters in HA
.Parameter CertificateChain
Base64 encoded Certificate Chain
.Parameter fqdn
the hostname / ip of the host
.Parameter Port 
the Port Number for the host
.Parameter Type
The type of Certificate, currently ROOT only
.Example
Add-PPDMcertificates -Certificate "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM2akNDQWRLZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeU1Ea3hOVEV6TWpRd01Wb1hEVE15TURreE1qRXpNamt3TVZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTVlrCkVhenZ2ZGltQ2VzTjV6eTNmZ2Ewem9CK0xKV0w3eTMwZmYwQ1dMalgrYmo5Z1EwdU9jNGVyTWVoaTdZdXViUVIKK3kvYXNQZDR6MWplMzMzVHJYUFBhMStyRkNHaklkNHdja3plS0tDM1JRMEF4OWhsNnB0NFJCODUyUTNmaldBQgpFcm1CY0FXN0VNSkVIT0FXVGtOUXdMUUhiZUtEZDhSc0Yxd3daQmxqV1JzejV0Z2RiQlVkNFpIT2xkKy8wK2l0CnM2Z2FxOVdPNGxFZG1DRWYwUjZsN2FQNFhXR1lJdWZmZ2FhMUNFK0VSODA4UjFVV2RYWmxjRU9qMWZsWlhOQWwKWXNLTFlxTVZFcWE1aXpNS1o4UUwyYmFFeU5HZnJCM0lISkN4aDI1RWZFcFdsN2V3VjdrbisrRTNOcE5rYk8xSwpDWml5OXZYZ2hIQW9ESS9ZLzg4Q0F3RUFBYU5GTUVNd0RnWURWUjBQQVFIL0JBUURBZ0trTUJJR0ExVWRFd0VCCi93UUlNQVlCQWY4Q0FRQXdIUVlEVlIwT0JCWUVGQjZKQ0RmaVRHYjQ1djdFczNiZ3lMeUNYeTJtTUEwR0NTcUcKU0liM0RRRUJDd1VBQTRJQkFRQzNDbjFOSkhCNVdDTDFSNkxwM21tL1FGN2RrZWo0SnMxZVB6dEh3RXBsOTFjcwprR3lLcjA0dVlQOHFoclRKU2tvWm5jZmtxUUt3OGtveGl4RTV0VEFWMVBGRDc2RHNyZitKb1RCTVZWTEUzQmpXCkZkM0U4b1MrMDlQQkJJaEh1K2NOZU5hUEdSTzlQN0FDMjlFSU5hVkwrdHRpK2xsSWJ3dkNDRU1CY0d5STYyb3gKR1ZSVmlvTnlNNXc5N3BBRDNqZ0dvaXFJL24rS3dPMjBEcXdJY0JzT296c08xdWM3R0twb21NaUZJaEdCTEFOWAozR3QyNXREV2pZUWhORmF5clAwR0NocVdBcVpOTXA0cHdoR1UxeFp3OXVJbC9VQ2JqSjdzRlNFOTJkQU10WGwrCm1aUytZSVVyZnpQeE91YkNZRC9Gc3pDaytuaDdIcU1QK0RBZjl0ZEEKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=" -fqdn 10.55.188.20 -Port 6443 -type ROOT

id             : MTAuNTUuMTg4LjIwOjY0NDM6cm9vdA==
host           : 10.55.188.20
port           : 6443
notValidBefore : Thu Sep 15 06:24:01 PDT 2022
notValidAfter  : Sun Sep 12 06:29:01 PDT 2032
fingerprint    : 4779D507ED496189E0F00EA681339B401A7ACC8E
subjectName    : CN=kubernetes
issuerName     : CN=kubernetes
state          : ACCEPTED
type           : ROOT
#>
function Add-PPDMcertificates {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Cetificate')][string]$CertificateChain,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$fqdn,
        [Parameter(Mandatory = $true,  ValueFromPipelineByPropertyName = $true)]
        [string]$Port,        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('ROOT')]$type,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {

            default {
                $URI = "/$myself"
            }

        } 
            $body = @{
            host = $fqdn
            port = $port
            type = $type
            certificateChain = $CertificateChain
        }  | ConvertTo-Json  
        write-verbose ($body | Out-String)
  
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            apiport          = 8443 
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

