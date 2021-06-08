# /api/v2/inventory-sources
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


<#
.Synopsis
Adds Inventory Components
.Description

.Example
Add Kubernetes Inventory

Create Kubernetes Credentials
$tokenfile="\\nasug.home.labbuildr.com\minio\aks\aksazs1\ppdmk8stoken-20210606.653.18+UTC.json"
$Securestring=ConvertTo-SecureString -AsPlainText -String "$(Get-Content $tokenfile -Encoding utf8)" -Force
$username="limitedadmin"
$Credentials = New-Object System.Management.Automation.PSCredential($username, $Securestring)
$newcreds=New-PPDMcredentials -name aksazs1 -type KUBERNETES -authmethod TOKEN -credentials $Credentials

Add the Certificate
$myHost="aksazs1.local.cloudapp.azurestack.external"
Get-PPDMcertificates -newhost $myHost -Port 443 | Approve-PPDMcertificates

Add the inventory
Add-PPDMinventory_sources -Type KUBERNETES -Hostname $myHost -Name aksazs1 -ID $newcreds.id -port 443

id                  : deacf2c9-9c15-4749-8fb3-619a76ce2bb1
name                : aksazs1
version             :
type                : KUBERNETES
lastDiscovered      :
lastDiscoveryResult : @{status=UNKNOWN; summaries=System.Object[]}
lastDiscoveryTaskId :
address             : aksazs1.local.cloudapp.azurestack.external
port                : 443
credentials         : @{id=c9f25735-352a-4ff3-acbd-d16663804d99}
details             :
local               : False
vendor              :
_links              : @{self=; storageSystems=; credentials=}
#>
function Add-PPDMinventory_sources {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [alias('fqdn')]$Hostname, 
        [Parameter(Mandatory = $true, ParameterSetName = 'GENERIC_NAS', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('CIFS', 'NFS')]$Protocol, 
        [Parameter(Mandatory = $true, ParameterSetName = 'GENERIC_NAS', ValueFromPipelineByPropertyName = $true)]
        [string[]]$address,                    
        [Parameter(Mandatory = $true, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('DATADOMAINMANAGEMENTCENTER',
            #        'SMISPROVIDER',
            'DDSYSTEM',
            #        'VMAXSYSTEM',
            #        'XTREMEIOMANAGEMENTSERVER',
            #        'RECOVERPOINT',
            #        'HOST_OS',        
            #        'SQLGROUPS',
            #        'ORACLEGROUP',
            #        'DEFAULTAPPGROUP',
            'VCENTER',
            'EXTERNALDATADOMAIN',
            #        'POWERPROTECTSYSTEM',
            #        'CDR',
            'KUBERNETES'
        )]$Type, 
        [Parameter(Mandatory = $true, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        $Name,        
        [Parameter(Mandatory = $true, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'GENERIC_NAS', ValueFromPipelineByPropertyName = $true)]
        [alias('secretID')]$ID, 
        [Parameter(Mandatory = $false, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'GENERIC_NAS', ValueFromPipelineByPropertyName = $true)]
        $port,
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
            'Host' {
                $URI = "/$myself"
                $body = @{

                    name        = $Name
                    type        = $Type
                    address     = $Hostname
                    port        = $port
                    credentials = @{
                        id = $ID
                    }
                } | ConvertTo-Json
            }
            'GENERIC_NAS' {
                $URI = "/$($myself)-batch"
                $body = @{}
                $body.Add('requests',@())    

                # this goes to foreach
                $request = @{}
                $request.Add('id','1')
                $requestbody = @{
                    name        = $address
                    type        = 'GENERICNASMANAGEMENTSERVER'
                    address     = $address -replace ":"
                    port        = $port
                    credentials = @{
                        id = $ID
                 
                    }
                }
                $request.Add('body',$requestbody)
                $body.requests += $request
                
                $body = $body | ConvertTo-Json -Depth 6
            }                 
            default {
                $URI = "/$myself"
            }
        }  
        Write-Verbose ($body | Out-String)  
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
            'Host' {
                write-output $response 
            }
            default {
                write-output ($response )
            } 
        }   
    }
}


function Remove-PPDMinventory_sources {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        $id
    )
    begin {
        $Response = @()
        $METHOD = "DELETE"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(11) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {

        $URI = "/$myself/$id"
        $Parameters = @{
            #            body             = $body 
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
                write-output $response | convertfrom-json
            }
            default {
                write-output ($response | convertfrom-json).content
            } 
        }   
    }
}



