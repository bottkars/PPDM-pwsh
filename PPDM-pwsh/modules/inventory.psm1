# /api/v2/inventory-sources
function Get-PPDMinventory_sources {
    [CmdletBinding()]
    [Alias('Get-PPDMAssetSource')]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('DATADOMAINMANAGEMENTCENTER',
            'DDSYSTEM',
            'VCENTER',
            'EXTERNALDATADOMAIN',
            'KUBERNETES'        
        )]
        $Type,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $filter, 
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $pageSize, 
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $page, 
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [hashtable]$body = @{orderby = 'createdAt DESC' },
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]                
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
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
        if ($pagesize) {
            $body.add('pageSize', $pagesize)
        }
        if ($page) {
            $body.add('page', $page)
        }  
        $Parameters = @{
            RequestMethod    = 'REST'
            body             = $body
            Uri              = $URI
            Method           = $Method
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
        }
        if ($type) {
            if ($filter) {
                $filter = 'type eq "' + $type + '" and ' + $filter 
            }
            else {
                $filter = 'type eq "' + $type + '"'
            }
        }
        if ($filter) {
            write-verbose ($filter | Out-String)
            $parameters.Add('filter', $filter)
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
                if ($response.page) {
                    write-host ($response.page | out-string)
                }
            } 
        }   
    }
}


function Get-PPDMinfrastructure_nodes {
    [CmdletBinding()]
    [Alias('Get-PPDMAssetNodes')]
    param(
        [Parameter(Mandatory = $TRUE, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $TRUE, ParameterSetName = 'Children', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $TRUE, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $TRUE, ParameterSetName = 'ALL', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $TRUE, ParameterSetName = 'Children', ValueFromPipelineByPropertyName = $true)]

        [ValidateSet('MICROSOFT_SQL_DATABASE_VIEW',
            'FILE_SYSTEM_VIEW',
            'VMWARE_VIRTUAL_MACHINE_HOST_VIEW',
            'VMWARE_VIRTUAL_MACHINE_FOLDER_VIEW',
            'ORACLE_DATA_GUARD_VIEW'      
        )]
        $Type,
        [Parameter(Mandatory = $TRUE, ParameterSetName = 'Children', ValueFromPipelineByPropertyName = $true)]
        [switch]$children,       
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $filter, 
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $pageSize, 
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $page, 
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [hashtable]$body = @{orderby = 'createdAt DESC' },
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]                
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
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
            'children' {
                $URI = "/$myself/$id/children"
            }            
            default {
                $URI = "/$myself"
            }
        }          
        if ($type) {
            $body.Add('hierarchyType', $TYPE)  
        }
        if ($pagesize) {
            $body.add('pageSize', $pagesize)
        }
        if ($page) {
            $body.add('page', $page)
        }   
        $Parameters = @{
            RequestMethod    = 'REST'
            body             = $body
            Uri              = $URI
            Method           = $Method
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
        }

        if ($filter) {
            write-verbose ($filter | Out-String)
            $parameters.Add('filter', $filter)
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
                if ($response.page) {
                    write-host ($response.page | out-string)
                }
            } 
        }   
    }
}




function Set-PPDMinventory_sources {
    [CmdletBinding()]
    [Alias('Set-PPDMAssetSource')]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        $id,
        $configobject
    )
    begin {
        $Response = @()
        $METHOD = "PUT"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            default {
                $URI = "/$myself/$id"
            }
        }   
        $body = $configobject | ConvertTo-json -Depth 7     
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
            default {
                write-output ($response)
            } 
        }   
    }
}

<#
.Synopsis
Adds Inventory Components
.Description
Adds Inventory Sources of Types 'DATADOMAINMANAGEMENTCENTER''DDSYSTEM''VCENTER''EXTERNALDATADOMAIN''KUBERNETES' GENERIC_NAS
.Example
Add Vanilla Kubernetes Inventory

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

.Example
Add TANZU_GUEST_CLUSTER Kubernetes Inventory
# create vSphere inventory ( if not already added )
Get-PPDMcertificates -newhost vcenter-01.xiolab.lab.emc.com | Approve-PPDMcertificates
$Securestring=ConvertTo-SecureString -AsPlainText -String "Password123!" -Force
$username="Administrator@vsphere.local"
$Credentials = New-Object System.Management.Automation.PSCredential($username, $Securestring)
$newvspherecreds=New-PPDMcredentials -name vsphere -type VCENTER -credentials $Credentials
$vcenter = Add-PPDMinventory_sources -Hostname vcenter-01.xiolab.lab.emc.com -Type VCENTER -ID $newvspherecreds.id -Name vcenter-01 -port 443 -isHostingvCenter -isAssetSource

# create the k8s inventory
$token="eyJhbGciOiJSUzI1NiIsImtpZCI6Ii1aX1RVMHludjR6ZTlrV1dFU2c1dWV2NHk4eHFwOGoyLXdWdFBLMHNhS0UifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJwcGRtLWFkbWluLXRva2VuLXAyempqIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6InBwZG0tYWRtaW4iLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI0M2QyNGUyMS05N2E0LTRmM2UtOTE0ZS0yYjhhY2I3NDEwM2UiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06cHBkbS1hZG1pbiJ9.KETUg5EpLQtE8AqoZQEDQXPp6ZlC40Yx6a2Ub9Fpn1WqzgJ5Pj6SaV7FkLKAw371wz4zIwhURLuyARRqgx4y703FmJZpoi1BUrr0ry3qj5zp8UzdzBY455e8AOpqV66BFKzYlNSbqFbazMJjv-fL_sF8QI7RCZM74uKe-iPNM1OU0Zsn27Mqzh85gT_5umceULIFYAh4Hc_sFHrSYmt4enT7yF0HeIwTviQwgch-LZeUQUTJdTqmlUKc31qD47i0oGSj8mnEWx9erlaWx89vOyweua6_Vx3boNEeLCdClsvkuKkBd5KLW-UqriKrvh0Evnid7EyGjXI-Qrfta4Aw5g"
$Securestring=ConvertTo-SecureString -AsPlainText -String $token -Force
$username="limitedadmin"
$Credentials = New-Object System.Management.Automation.PSCredential($username, $Securestring)
$newk8screds=New-PPDMcredentials -name tkg02 -type KUBERNETES -authmethod TOKEN -credentials $Credentials
Get-PPDMcertificates -newhost 10.55.188.3 -Port 6443 | Approve-PPDMcertificates
Add-PPDMinventory_sources -Type KUBERNETES -Hostname 10.55.188.3 -K8S_TYPE TANZU_GUEST_CLUSTER  -Name tkg02 -ID $newk8screds.id -VCENTER_ID $vcenter.id -port 6443
#>
function Add-PPDMinventory_sources {
    [CmdletBinding()]
    [Alias('Add-PPDMAssetSource')]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [alias('fqdn')]$Hostname, 
        [Parameter(Mandatory = $true, ParameterSetName = 'GENERIC_NAS', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('CIFS', 'NFS')]$Protocol, 
        [Parameter(Mandatory = $true, ParameterSetName = 'GENERIC_NAS', ValueFromPipelineByPropertyName = $true)]
        [string[]]$address,                    
        [Parameter(Mandatory = $true, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet(
            # Inventory Type as on of 'DATADOMAINMANAGEMENTCENTER''DDSYSTEM''VCENTER''EXTERNALDATADOMAIN''KUBERNETES'
            'DATADOMAINMANAGEMENTCENTER',
            'DDSYSTEM',
            'VCENTER',
            'EXTERNALDATADOMAIN',
            'KUBERNETES'
        )]$Type, 
        [Parameter(Mandatory = $false, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet(
            # K8S Type as on of 'TANZU_GUEST_CLUSTER' 'VANILLA_ON_VSPHERE' 'NON_VSPHERE'
            'TANZU_GUEST_CLUSTER',
            'VANILLA_ON_VSPHERE',
            'NON_VSPHERE'
        )]$K8S_TYPE,
        [Parameter(Mandatory = $false, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        # Required VCENTER ID if 'TANZU_GUEST_CLUSTER'
        $VCENTER_ID,
        [Parameter(Mandatory = $true, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        $Name,        
        [Parameter(Mandatory = $true, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'GENERIC_NAS', ValueFromPipelineByPropertyName = $true)]
        [alias('secretID')]$ID, 
        [Parameter(Mandatory = $false, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'GENERIC_NAS', ValueFromPipelineByPropertyName = $true)]
        $port,
        [Parameter(Mandatory = $false, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [switch]$isHostingvCenter,  
        [Parameter(Mandatory = $false, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [switch]$isAssetSource,  
        [Parameter(Mandatory = $false, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [switch]$vSphereUiIntegration,                       
        [Parameter(Mandatory = $false, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'GENERIC_NAS', ValueFromPipelineByPropertyName = $true)]
        [switch]$ssl,
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
                } 
                if ( $TYPE -eq "VCENTER" ) {
                    $body.Add('details', @{})
                    $body.details.Add('vCenter', @{})
                    write-verbose "$VCENTER selected"
                    $body.details.vCenter.Add('vSphereUiIntegration', $vSphereUiIntegration.IsPresent )
                    $body.details.vCenter.Add('assetSource', $isAssetSource.isPresent )
                    $body.details.vCenter.Add('hosting', $isHostingvCenter.ispresent )
                }
                if ( $K8S_TYPE ) { 
                    $body.Add('details', @{})
                    $body.details.Add('k8s', @{})
                    write-verbose "$K8S_TYPE selected"
                    if ($K8S_TYPE -eq "TANZU_GUEST_CLUSTER") {                        
                        if ($VCENTER_ID) {
                            $body.details.k8s.Add('vCenterId', $VCENTER_ID )
                        }
                        else {
                            write-host "Tanzu Guest Clusters need vCenter ID to be set"
                            break                        
                        }
                    }    
                    $body.details.k8s.Add('distributionType', $K8S_TYPE )
                }                
                $body.Add('ssl', $ssl.isPresent )                
                $body = $body | ConvertTo-Json
            }
            'GENERIC_NAS' {
                $URI = "/$($myself)-batch"
                $body = @{}
                $body.Add('requests', @())    

                # this goes to foreach
                $request = @{}
                $request.Add('id', '1')
                $requestbody = @{
                    name        = $address
                    type        = 'GENERICNASMANAGEMENTSERVER'
                    address     = $address -replace ":"
                    port        = $port
                    credentials = @{
                        id = $ID
                 
                    }
                }
                $request.Add('body', $requestbody)
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
    [Alias('Remove-PPDMAssetSource')]
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



function Get-PPDMvcenterDatastores {
    [CmdletBinding()]
    param(

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        # Moref Cluster ID , e.g. "ClusterComputeResource:domain-c1006, can be retived via '(Get-PPDMhosts -hosttype ESX_CLUSTER -filter 'name eq "<clustername>"').details.esxcluster.clusterMoref'
        $clusterMOREF,        
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )
    begin {
        $Response = @()
        $METHOD = "GET"
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {

            default {
                $URI = "vcenter/$id/data-stores/$clusterMoref"
            }
        }        
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
                write-output $response.datastores
            } 
        }   
    }
}
