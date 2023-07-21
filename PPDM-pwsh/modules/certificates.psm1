<#
.SYNOPSIS
Get the external, internal  hosts, agent and root CA TLS certificates that are stored in the trust store and have the state ACCEPTED
.EXAMPLE
Get-PPDMcertificates -type internal

id             : Y3VzdG9t
host           : custom
port           :
notValidBefore : Thu Jul 13 10:05:29 CEST 2023
notValidAfter  : Wed Oct 11 10:05:28 CEST 2023
fingerprint    : 817DBC5F143F30CFFD9E05B201310FBC7B0471AA
subjectName    : CN=ppdm.home.labbuildr.com
issuerName     : CN=R3, O=Let's Encrypt, C=US
state          : ACCEPTED
type           : HOST
verify         : False
.EXAMPLE
Get-PPDMcertificates -type external

id             : dGtnaS5wa3MuaG9tZS5sYWJidWlsZHIuY29tOjg0NDM6aG9zdA==
host           : tkgi.pks.home.labbuildr.com
port           : 8443
notValidBefore : Thu Mar 02 17:21:16 CET 2023
notValidAfter  : Tue Mar 02 17:21:16 CET 2027
fingerprint    : 673D87DFA1BCF339571FDDA637BB68BC51805616
subjectName    : O=system:masters, CN=tkgi.pks.home.labbuildr.com
issuerName     : O=VMware, OU=TKGI, CN=CA
state          : ACCEPTED
type           : HOST
verify         : False

id             : ZGR2ZWF6czEubG9jYWwuY2xvdWRhcHAuYXp1cmVzdGFjay5leHRlcm5hbDozMDA5Omhvc3Q=
host           : ddveazs1.local.cloudapp.azurestack.external
port           : 3009
notValidBefore : Tue Jul 20 07:06:18 CEST 2021
notValidAfter  : Fri Jul 19 14:06:18 CEST 2024
fingerprint    : ACEC3DA18EABB4582ADCB264CE40E780565249D6
subjectName    : CN=ddveazs1.azsdps.labbuildr.com, O=Valued DataDomain customer, ST=CA, C=US
issuerName     : CN=ddveazs1.azsdps.labbuildr.com, O=Valued Datadomain Customer, L=Santa Clara, ST=CA, C=US
state          : ACCEPTED
type           : HOST
verify         : False

#>
function Get-PPDMcertificates {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$ID,
        [Parameter(Mandatory = $true, ParameterSetName = 'byHOST', ValueFromPipelineByPropertyName = $true)]
        [string]$newhost,
        [Parameter(Mandatory = $false, ParameterSetName = 'byHOST', ValueFromPipelineByPropertyName = $true)]
        [string]$Port = 443,        
        [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        [switch]$list,
        [Parameter(Mandatory = $true, ParameterSetName = 'Type', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('agent', 'root', 'external', 'internal' )][string]$type,
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
            'byHost' {
                $URI = "/$($myself)?host=$newhost&port=$port&type=Host"
            }
            'TYPE' {
                $URI = "/$($myself)/$type"
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
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {

            default {
                $URI = "/$myself/$($Certificate.id)"
                $body = $Certificate | ConvertTo-Json
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
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {

            default {
                $URI = "/$myself/$($Certificate.id)"
                $Certificate.state = "ACCEPTED"
                $body = $Certificate | ConvertTo-Json
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
   
    }     
    Process {
        $URI = "/$myself/$ID"
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'WEB'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            apiport          = 8443 
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
            # ResponseHeadersVariable = 'HeaderResponse'

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
                write-output $response.Headers.Date
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
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
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
            host             = $fqdn
            port             = $port
            type             = $type
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

