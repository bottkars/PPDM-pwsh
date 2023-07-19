### storage
# /api/v2/data-targets

function Get-PPDMdata_targets {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [string]$ID,
    [Parameter(Mandatory = $false, ParameterSetName = 'TYPE', ValueFromPipelineByPropertyName = $true)]
    [ValidateSet(
      'DDV_DISK_POOL',
      'DDV_DISK_DEVICE_GROUP',
      'DDV_DISK_SERVICE',
      'DD_MTREE',
      'STORAGE_ARRAY',
      'DD_STORAGE_UNIT',
      'CDR_CONTAINER')][string]$subtype,
    [string]$filter,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    $pageSize, 
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    $page,              
    [hashtable]$body = @{orderby = 'createdAt DESC' },
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
    if ($pagesize) {
      $body.add('pageSize', $pagesize)
    }
    if ($page) {
      $body.add('page', $page)
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
    if ($subtype) {
      if ($filter) {
        $filter = 'subtype eq "' + $subtype + '" and ' + $filter 
      }
      else {
        $filter = 'subtype eq "' + $subtype + '"'
      }
    }        
    if ($filter) {
      $parameters.Add('filter', $filter) 
    }
    Write-Verbose ($body | Out-String)   
    Write-Verbose ($Parameters | Out-String)     
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
# Storage Targets
# /api/v2/storage-systems
<#
.SYNOPSIS
Get Information on Connected Storage Systems
.EXAMPLE
get-ppdmstorage_systems -Type DATA_DOMAIN_SYSTEM -Filter {name eq "ddve.home.labbuildr.com"}

id                        : aa0b484c-8f1e-4749-99c1-91f3611ab3b1
name                      : ddve.home.labbuildr.com
description               :
type                      : DATA_DOMAIN_SYSTEM
local                     : False
locationId                :
ddLocationId              :
capacityUtilization       : 42,9608800444966
lastDiscoveryStatus       : DETECTED
lastDiscovered            : 12/07/2023 15:07:21
readiness                 : READY
replicationEncryptionMode : DISABLED
retentionLockModes        : {COMPLIANCE, GOVERNANCE}
parentId                  :
details                   : @{vmax=; xio=; dataDomain=}
unsupportedFeatures       :
createdAt                 : 15/06/2022 12:41:10
updatedAt                 : 12/07/2023 15:07:29
_embedded                 : @{inventorySource=}
lastDiscoveryAt           : 12/07/2023 15:07:29
lastDiscoveryResult       : @{messageID=ADS0005; status=OK; error=com.emc.brs.common.exceptions.DiscoveryActorException: Unauthorized: Unable to process the authentication request for PowerProtect DD Management Console
                            ddve.home.labbuildr.com. Error: Unauthorized: Unable to process the authentication request for PowerProtect DD Management Console ddve.home.labbuildr.com. HTTP response: HTTP/1.1 401
                            Unauthorized..; remediation=Check the connection between PowerProtect Data Manager and the protection storage system. Verify that the provided credentials are valid. Start a manual discovery to
                            discover the protection storage system, or wait for PowerProtect Data Manager to perform the next scheduled discovery. If the issue persists, contact Dell Customer Support.;
                            summaries=System.Object[]}
lastDiscoveryTaskId       : bc907269-a59b-4ae3-9752-2a4b902be69a
operatingSystem           :
purpose                   :
_links                    : @{self=; inventorySource=}
.EXAMPLE
get-ppdmstorage_systems -ID aa0b484c-8f1e-4749-99c1-91f3611ab3b1 -Livecapacities

type                : COMBINED
totalPhysicalUsed   : 590489321472
totalPhysicalSize   : 1374327668736
compressionFactor   : 39,0808009544374
totalLogicalUsed    : 23076795638168
totalLogicalSize    : 53709826068047
percentUsed         : 42,9656867794189
reductionPercentage : 97,4411988097023
capacityStatus      : GOOD
totalLicensedSize   : 48000000000000
licensedUtilization : 1,2301860864

type                : CLOUD
totalPhysicalUsed   : 0
totalPhysicalSize   : 0
compressionFactor   : 0
totalLogicalUsed    : 0
totalLogicalSize    : 0
percentUsed         : 0
reductionPercentage : 0
capacityStatus      : GOOD
totalLicensedSize   : 32000000000000
licensedUtilization : 0

type                : ACTIVE
totalPhysicalUsed   : 590489321472
totalPhysicalSize   : 1374327668736
compressionFactor   : 39,0808009544374
totalLogicalUsed    : 23076795638168
totalLogicalSize    : 53709826068047
percentUsed         : 42,9656867794189
reductionPercentage : 97,4411988097023
capacityStatus      : GOOD
totalLicensedSize   : 16000000000000
licensedUtilization : 3,6905582592
.EXAMPLE
Get-PPDMstorage_systems -Type DATA_DOMAIN_SYSTEM -Filter {name eq "ddve.home.labbuildr.com"} | Get-PPDMstorage_systems -nfsexports
# Gest the NFS Exports
exportId           : %2Fdata
storageArrayId     : aa0b484c-8f1e-4749-99c1-91f3611ab3b1
path               : /data
mtreeName          : -
numberOfClients    : 1
nfsv3Mounts        : 28233
activeNfsv3Clients : 0
activeNfsv4Clients : 0
clients            : {@{address=192.168.1.236; options=sec=sys,rw,no_root_squash,no_all_squash,secure,version=3}}

exportId           : %2Fdata%2Fcol1%2FDEMO_FOR_RECOVER_PLANS-ppdm-demo-ac245%2FPLCTLP-74a931e0-5ff6-4eac-94e9-1e30bcb282f3%2FRestores%2Fb704722c-d915-46ce-a6ec-3099919536f8%2F501b6968-1720-3794-a7d2-9ac505e80ffc%2F1686126813
                     620762066%2F1686119022%2FvProxy-ppdm-demo.home.labbuildr.com-1ad75544-1854-4dd3-a889-ec97a02bc752
storageArrayId     : aa0b484c-8f1e-4749-99c1-91f3611ab3b1
path               : /data/col1/DEMO_FOR_RECOVER_PLANS-ppdm-demo-ac245/PLCTLP-74a931e0-5ff6-4eac-94e9-1e30bcb282f3/Restores/b704722c-d915-46ce-a6ec-3099919536f8/501b6968-1720-3794-a7d2-9ac505e80ffc/1686126813620762066/168611
                     9022/vProxy-ppdm-demo.home.labbuildr.com-1ad75544-1854-4dd3-a889-ec97a02bc752
mtreeName          : /data/col1/DEMO_FOR_RECOVER_PLANS-ppdm-demo-ac245
numberOfClients    : 14
nfsv3Mounts        : 1
activeNfsv3Clients : 1
activeNfsv4Clients : 0
clients            : {@{address=10.0.0.12; options=sec=sys,rw,no_root_squash,no_all_squash,secure,version=3:4}, @{address=100.250.1.84; options=sec=sys,rw,no_root_squash,no_all_squash,secure,version=3:4},
                     @{address=100.250.1.123; options=sec=sys,rw,no_root_squash,no_all_squash,secure,version=3:4}, @{address=172.16.100.81; options=sec=sys,rw,no_root_squash,no_all_squash,secure,version=3:4}…}

exportId           : %2Fdata%2Fcol1%2Fctdemo
storageArrayId     : aa0b484c-8f1e-4749-99c1-91f3611ab3b1
path               : /data/col1/ctdemo
mtreeName          : /data/col1/ctdemo
numberOfClients    : 10
nfsv3Mounts        : 0
activeNfsv3Clients : 0
activeNfsv4Clients : 0
clients            : {@{address=10.240.1.175; options=sec=sys,rw,no_root_squash,no_all_squash,secure,version=3}, @{address=10.240.1.196; options=sec=sys,rw,no_root_squash,no_all_squash,secure,version=3},
                     @{address=10.240.1.197; options=sec=sys,rw,no_root_squash,no_all_squash,secure,version=3}, @{address=172.17.62.115; options=sec=sys,rw,no_root_squash,no_all_squash,secure,version=3}…}

exportId           : %2Fdata%2Fcol1%2Focp_etcd
storageArrayId     : aa0b484c-8f1e-4749-99c1-91f3611ab3b1
path               : /data/col1/ocp_etcd
mtreeName          : /data/col1/ocp_etcd
numberOfClients    : 1
nfsv3Mounts        : 0
activeNfsv3Clients : 0
activeNfsv4Clients : 0
clients            : {@{address=10.240.1.1/24; options=sec=sys,rw,no_root_squash,no_all_squash,secure,version=4}}

exportId           : %2Fdata%2Fcol1%2Fpowerprotect
storageArrayId     : aa0b484c-8f1e-4749-99c1-91f3611ab3b1
path               : /data/col1/powerprotect
mtreeName          : /data/col1/powerprotect
numberOfClients    : 23
nfsv3Mounts        : 0
activeNfsv3Clients : 0
activeNfsv4Clients : 0
clients            : {@{address=10.240.1.136; options=sec=sys,rw,no_root_squash,no_all_squash,secure,version=3:4}, @{address=10.240.1.162; options=sec=sys,rw,no_root_squash,no_all_squash,secure,version=3:4},
                     @{address=10.240.1.226; options=sec=sys,rw,no_root_squash,no_all_squash,secure,version=3:4}, @{address=10.240.1.234; options=sec=sys,rw,no_root_squash,no_all_squash,secure,version=3:4}…}

exportId           : %2Fdata%2Fcol1%2Fvault_updates
storageArrayId     : aa0b484c-8f1e-4749-99c1-91f3611ab3b1
path               : /data/col1/vault_updates
mtreeName          : /data/col1/vault_updates
numberOfClients    : 2
nfsv3Mounts        : 0
activeNfsv3Clients : 0
activeNfsv4Clients : 0
clients            : {@{address=192.168.1.60/32; options=sec=sys,rw,root_squash,no_all_squash,secure,version=3:4}, @{address=192.168.1.203/32; options=sec=sys,rw,no_root_squash,no_all_squash,secure,version=3:4}}

exportId           : %2Fddvar
storageArrayId     : aa0b484c-8f1e-4749-99c1-91f3611ab3b1
path               : /ddvar
mtreeName          : -
numberOfClients    : 0
nfsv3Mounts        : 0
activeNfsv3Clients : 0
activeNfsv4Clients : 0
clients            : {}

#>
function Get-PPDMstorage_systems {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $false, ParameterSetName = 'Type', ValueFromPipelineByPropertyName = $true)]
    [ValidateSet(
      'VMAX_STORAGE_SYSTEM',
      'DATA_DOMAIN_SYSTEM',
      'CDR_REGION_SYSTEM',
      'GENERIC_NAS_APPLIANCE',
      'POWER_STORE_APPLIANCE',
      'UNITY_APPLIANCE',
      'DATA_DOMAIN_APPLIANCE_POOL',
      'POWER_SCALE_APPLIANCE'
    )]$Type, 
    [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'nfsexports', ValueFromPipelineByPropertyName = $true)]     
    [Parameter(Mandatory = $true, ParameterSetName = 'livecapacity', ValueFromPipelineByPropertyName = $true)]     
    [string]$ID,
    [Parameter(Mandatory = $true, ParameterSetName = 'livecapacity', ValueFromPipelineByPropertyName = $true)]     
    [switch]$Livecapacities, 
    [Parameter(Mandatory = $true, ParameterSetName = 'nfsexports', ValueFromPipelineByPropertyName = $true)]     
    [switch]$nfsexports,    
    [string]$Filter,
    [hashtable]$body = @{pageSize = 200 },
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
      'livecapacity' { $URI = "/$myself/$ID/capacities" }
      'nfsexports' { $URI = "/$myself/$ID/nfs-exports" }
      'byID' {
        $URI = "/$myself/$ID"
      }
      default {
        $URI = "/$myself"
      }
      'TYPE' {
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
      'livecapacity' { write-output $response.capacities }

      default {
        write-output $response.content 
      } 
    }   
  }
}


function Get-PPDMstorage_system_metrics {
  [CmdletBinding()]
  [Alias('Get-PPDMStorageMetrics')]
  param(
    [string]$Filter,
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
    $Parameters = @{
      body             = $body 
      Uri              = $Uri
      Method           = $Method
      RequestMethod    = 'Rest'
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
        write-output $response.capacityStatusSummary
      } 
    }   
  }
}
function Remove-PPDMstorage_systems {
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

###

function Remove-PPDMdatadomain_storage_units {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [string]$ID,
    [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [pscredential]$SecurityOfficerCredentials,
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    $apiver = "/api/v2"

  )
  begin {
    $Response = @()
    $METHOD = "DELETE"
    $Myself = ($MyInvocation.MyCommand.Name.Substring(11) -replace "_", "-").ToLower()
  }     
  Process {
    Write-Host "Checking if we need SecurityOfficer Credentials for Storage Unit with ID: $ID"
    if ((Get-PPDMdatadomain_storage_units -id $id).retentionLock.mode -eq "Compliance" ) {
      if (!$($SecurityOfficerCredentials)) {
        $username = Read-Host -Prompt "Please Enter PowerProtect SecurityOfficer Username"
        $SecurePassword = Read-Host -Prompt "Password for SecurityOfficer $username" -AsSecureString
        $SecurityOfficerCredentials = New-Object System.Management.Automation.PSCredential($username, $Securepassword)
      }
      $password = $($SecurityOfficerCredentials.GetNetworkCredential()).password
      $Body = @{
        'securityOfficerUsername' = $username
        'securityOfficerPassword' = $password
      } 
      $body = $Body | ConvertTo-Json
    }
    else {
      Write-Host "No SO Credtials required"
    }
    Write-Host "deleting SU $ID"
    switch ($PsCmdlet.ParameterSetName) {
      'byID' {
        $URI = "/$myself/$ID"
      }
    }  
    $Parameters = @{
      body                    = $body 
      Uri                     = $Uri
      Method                  = $Method
      RequestMethod           = 'Rest'
      PPDM_API_BaseUri        = $PPDM_API_BaseUri
      apiver                  = $apiver
      Verbose                 = $PSBoundParameters['Verbose'] -eq $true
      ResponseHeadersVariable = 'HeaderResponse'
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
        write-output $response.date 
      }
      default {
        write-output $response.date
      } 
    }   
  }
}

# Storage Targets
# /api/v2/storage-systems
function Set-PPDMstorage_systems {
  [CmdletBinding()]
  param(

    [Parameter(Mandatory = $true, ParameterSetName = 'Configurations', ValueFromPipeline = $true)]
    [Array]$Storage_Configuration,    
    [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'nfsexports', ValueFromPipelineByPropertyName = $true)] 
    [Parameter(Mandatory = $true, ParameterSetName = 'deletenfsexports', ValueFromPipelineByPropertyName = $true)] 
    $id,
    [Parameter(Mandatory = $true, ParameterSetName = 'nfsexports', ValueFromPipelineByPropertyName = $true)] 
    [string[]]$Clients,
    [Parameter(Mandatory = $true, ParameterSetName = 'nfsexports', ValueFromPipelineByPropertyName = $true)] 
    [Parameter(Mandatory = $true, ParameterSetName = 'deletenfsexports', ValueFromPipelineByPropertyName = $true)] 
    [string]$Path, 
    [Parameter(Mandatory = $true, ParameterSetName = 'nfsexports', ValueFromPipelineByPropertyName = $true)] 
    [switch]$nfsexports,
    [Parameter(Mandatory = $true, ParameterSetName = 'deletenfsexports', ValueFromPipelineByPropertyName = $true)] 
    [switch]$deletenfsexports,              
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
      'Configurations' {
        $URI = "/$myself/$($Storage_Configuration.id)"            
        $body = $Storage_Configuration 
      }
      'nfsexports' {
        $URI = "/$myself/$ID/nfs-exports"
        $Method = "Post"
        $body = @{}
        $body.Add('clients', $Clients)
        $body.Add('path', $Path)
      }
      'deletenfsexports' {
        $URI = "/$myself/$ID/nfs-exports-deletion"
        $Method = "Post"
        $body = @{}
        $body.Add('path', $Path)
      }      
    }
    $body = $body | convertto-json -Depth 10 
    write-verbose ($body | Out-String)  
    $Parameters = @{
      body             = $body 
      Uri              = $Uri
      Method           = $Method
      RequestMethod    = 'Rest'
      PPDM_API_BaseUri = $PPDM_API_BaseUri
      apiver           = $apiver
      ContentType      = "application/json"
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
      'Confiurations' {
        write-output $response
      } 
      'nfsexports' {
        write-output $response
      }
      'deletenfsexports' {
        write-output $response
      }      
    }   
  }
}


<#
{
  "description": "Information of the storage system.",
  "properties": {
    "_embedded": {
      "readOnly": true,
      "type": "object",
      "properties": {
        "inventorySource": {
          "readOnly": true,
          "type": "object",
          "properties": {
            "id": {
              "type": "string"
            },
            "name": {
              "type": "string"
            }
          }
        },
        "location": {
          "readOnly": true,
          "type": "object",
          "properties": {
            "id": {
              "type": "string"
            },
            "name": {
              "type": "string"
            }
          }
        }
      }
    },
    "capacityUtilization": {
      "description": "Capacity utilization of the storage system.",
      "format": "double",
      "type": "number",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "createdAt": {
      "description": "Create time of the storage system.",
      "format": "date-time",
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "ddLocationId": {
      "description": "UUID of location for the Data Domain storage system.",
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "details": {
      "description": "Details of the storage system.",
      "type": "object",
      "properties": {
        "dataDomain": {
          "description": "Details of the Data Domain.",
          "type": "object",
          "properties": {
            "capacityQuotasSupported": {
              "description": "Indicates if capacity quota is supported.",
              "type": "boolean",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "cloudEnabled": {
              "description": "Whether Cloud is enabled or not on the Data Domain system.",
              "type": "boolean",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "cloudTierLicensed": {
              "description": "Data Domain Cloud Tier License.",
              "type": "boolean",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "compressionFactor": {
              "description": "Compression factor of the Data Domain.\n- Example: 1.44E-4",
              "format": "double",
              "type": "number",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "ddboostLicensed": {
              "description": "Data Domain DDBoost License.",
              "type": "boolean",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "encryptionLicensed": {
              "description": "Data Domain Encryption License.",
              "type": "boolean",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "model": {
              "description": "Model of the Data Domain.\n- Example: DD VE Version 4.0",
              "type": "string",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "percentUsed": {
              "description": "Percent of capacity used for the Data Domain.",
              "format": "double",
              "type": "number",
              "x-ppdm-filter": false,
              "x-ppdm-sort": false
            },
            "preferredInterfaces": {
              "type": "array",
              "uniqueItems": true,
              "items": {
                "type": "object",
                "properties": {
                  "networkAddress": {
                    "type": "string"
                  },
                  "networkLabel": {
                    "type": "string"
                  },
                  "networkName": {
                    "type": "string"
                  },
                  "speed": {
                    "format": "double",
                    "type": "number"
                  }
                }
              }
            },
            "preferredNetworkSupported": {
              "description": "Indicates if preferred network interface is supported.",
              "type": "boolean",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "replicationEncryptionEnabled": {
              "description": "Encryption of replication for the Data Domain. True for enabling the encryption and false for disabling the encryption.",
              "type": "boolean",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "replicationLicensed": {
              "description": "Data Domain Replication License.",
              "type": "boolean",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "retentionLockComplianceLicensed": {
              "description": "Data Domain Retention Lock Compliance License.",
              "type": "boolean",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "retentionLockGovernanceLicensed": {
              "description": "Data Domain Retention Lock Governance License.",
              "type": "boolean",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "retentionLockSupported": {
              "description": "Indicates if retention lock is supported.",
              "type": "boolean",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "serialNumber": {
              "description": "Serial number of the Data Domain.",
              "type": "string",
              "x-ppdm-filter": false,
              "x-ppdm-sort": false
            },
            "streamQuotasSupported": {
              "description": "Indicates if stream quota is supported.",
              "type": "boolean",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "totalSize": {
              "description": "The total capacity in bytes of the Data Domain.",
              "format": "double",
              "type": "number",
              "x-ppdm-filter": false,
              "x-ppdm-sort": false
            },
            "totalUsed": {
              "description": "The total used capacity in bytes of the Data Domain.",
              "format": "double",
              "type": "number",
              "x-ppdm-filter": false,
              "x-ppdm-sort": false
            },
            "vdiskEnabled": {
              "description": "Whether vDisk service is enabled or not on the Data Domain system.",
              "type": "boolean",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "version": {
              "description": "Version of the Data Domain.\n- Example: Data Domain OS 6.2.0.10-615548",
              "type": "string",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            }
          }
        },
        "recoverPoint": {
          "description": "Details of the recover point.",
          "type": "object",
          "properties": {
            "protectedSpace": {
              "description": "Protected space of RecoverPoint.",
              "format": "double",
              "type": "number",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "serialNumber": {
              "description": "Serial number of RecoverPoint.",
              "type": "string",
              "x-ppdm-filter": false,
              "x-ppdm-sort": false
            },
            "totalCapacityManaged": {
              "description": "Total capacity managed for RecoverPoint.",
              "format": "double",
              "type": "number",
              "x-ppdm-filter": false,
              "x-ppdm-sort": false
            },
            "version": {
              "description": "Version of RecoverPoint.",
              "type": "string",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            }
          }
        },
        "vmax": {
          "description": "Details of the VMAX.",
          "type": "object",
          "properties": {
            "cacheSize": {
              "description": "The total size in bytes of the cache in the VMAX.",
              "format": "int32",
              "type": "integer",
              "x-ppdm-filter": false,
              "x-ppdm-sort": false
            },
            "model": {
              "description": "Model of the VMAX.",
              "type": "string",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "serialNumber": {
              "description": "Serial number of the VMAX.",
              "type": "string",
              "x-ppdm-filter": false,
              "x-ppdm-sort": false
            },
            "totalSize": {
              "description": "The total capacity in bytes of the VMAX.",
              "format": "double",
              "type": "number",
              "x-ppdm-filter": false,
              "x-ppdm-sort": false
            },
            "totalUsed": {
              "description": "The total used capacity in bytes of the VMAX.",
              "format": "double",
              "type": "number",
              "x-ppdm-filter": false,
              "x-ppdm-sort": false
            }
          }
        },
        "xio": {
          "description": "Details of the XtremIO.",
          "type": "object",
          "properties": {
            "serialNumber": {
              "description": "Serial number of the XtremIO.",
              "type": "string",
              "x-ppdm-filter": false,
              "x-ppdm-sort": false
            },
            "totalSize": {
              "description": "The total capacity in bytes of the XtremIO.",
              "format": "double",
              "type": "number",
              "x-ppdm-filter": false,
              "x-ppdm-sort": false
            },
            "totalUsed": {
              "description": "The used capacity in bytes of the XtremIO.",
              "format": "double",
              "type": "number",
              "x-ppdm-filter": false,
              "x-ppdm-sort": false
            },
            "version": {
              "description": "Version of XtremIO.",
              "type": "string",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            }
          }
        }
      }
    },
    "id": {
      "description": "UUID of the storage system in Elasticsearch. It can be used on GET or API, taking UUID in path.",
      "format": "string",
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "lastDiscovered": {
      "description": "Last discovery starts time of the storage system.",
      "format": "date-time",
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "lastDiscoveryAt": {
      "description": "Last discovery end time of the storage system.",
      "format": "date-time",
      "readOnly": true,
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "lastDiscoveryResult": {
      "description": "Result of the discovery activity.",
      "type": "object",
      "properties": {
        "error": {
          "description": "Error description for the discovery task.",
          "type": "string"
        },
        "messageID": {
          "description": "UUID of the message for the discovery task.",
          "type": "string"
        },
        "remediation": {
          "description": "Remediation for the discovery task.",
          "type": "string"
        },
        "status": {
          "description": "Status of the discovery task. Valid values are following:\n- OK\n- CANCELED\n- FAILED\n- OK_WITH_ERRORS.",
          "enum": [
            "OK",
            "CANCELED",
            "FAILED",
            "OK_WITH_ERRORS",
            "UNKNOWN"
          ],
          "type": "string",
          "x-ppdm-filter": true,
          "x-ppdm-sort": true
        },
        "summaries": {
          "description": "Summaries of the discovery task.",
          "type": "array",
          "x-ppdm-filter": true,
          "x-ppdm-sort": true,
          "items": {
            "type": "string"
          }
        }
      }
    },
    "lastDiscoveryStatus": {
      "description": "Status of the last discovery for the storage system. Valid values are following:\n- NEW\n- DETECTED\n- NOT_DETECTED\n- DELETED",
      "enum": [
        "NEW",
        "DETECTED",
        "NOT_DETECTED",
        "DELETED"
      ],
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "lastDiscoveryTaskId": {
      "description": "Last discovery task UUID of the storage system.",
      "format": "string",
      "readOnly": true,
      "type": "string"
    },
    "local": {
      "description": "Location of the storage system. True for internal storage system and false for external storage system.",
      "type": "boolean",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "locationId": {
      "description": "UUID of location for the storage system.",
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "name": {
      "description": "Name of the storage system. It can be used to show on UI page.",
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "operatingSystem": {
      "type": "object",
      "properties": {
        "name": {
          "type": "string"
        },
        "version": {
          "type": "string"
        }
      }
    },
    "type": {
      "description": "Type of the storage system. Valid values are the following:\n- VMAX_STORAGE_SYSTEM\n- XTREMIO_STORAGE_SYSTEM\n- RECOVERPOINT_SYSTEM\n- DATA_DOMAIN_SYSTEM\n- CDR_REGION_SYSTEM\n- POWER_PROTECT_SYSTEM\n- GENERICNASAPPLIANCE",
      "enum": [
        "VMAX_STORAGE_SYSTEM",
        "XTREMIO_STORAGE_SYSTEM",
        "RECOVERPOINT_SYSTEM",
        "DATA_DOMAIN_SYSTEM",
        "CDR_REGION_SYSTEM",
        "POWER_PROTECT_SYSTEM",
        "GENERICNASAPPLIANCE"
        
      ],
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "updatedAt": {
      "description": "Update time of the storage system.",
      "format": "date-time",
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    }
  },
  "type": "object"
}
#>





# mtrees
# /api/v2/datadomain-mtrees

function Get-PPDMdatadomain_mtrees {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [string]$ID,
    [ValidateSet('DDSTORAGEUNIT'        
    )]
    $Type,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    $filter,  
    [hashtable]$body = @{pageSize = 200 },  
   
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
      } 
    }   
  }
}

# /api/v2/datadomain-storage-units/{dataTargetId}
<#
.SYNOPSIS
Provides a data target ID to get information about the storage unit such as name, retention lock status, and PowerProtect DD storage system
.EXAMPLE
Get-PPDMdata_targets -subtype DD_STORAGE_UNIT | where name -eq MMDECENTRAL-ppdm-4ea1e | Get-PPDMdatadomain_storage_units

storageArrayId    : aa0b484c-8f1e-4749-99c1-91f3611ab3b1
credentialId      : 8a8e8036-b833-4499-b9d4-5c6333220806
storageUnit       : @{name=MMDECENTRAL-ppdm-4ea1e; tenantUnit=00000000-0000-4000-a000-000000000000; hardLimit=; softLimit=; combinedStreamSoftLimit=; combinedStreamHardLimit=; nativeId=; nativeUri=}
retentionLock     : @{enable=False}
dataTargetId      : 72cd6779-86ed-4405-a053-c9f7adc62bbb
dataAccessIp      :
networkInterfaces :

#>
function Get-PPDMdatadomain_storage_units {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $True, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [Alias('dataTargetID')][string]$ID,
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
        $Uri = "/$myself/$ID"
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




function New-PPDMdatadomain_storage_units {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $True, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [Alias('credentialID')][string]$adminuserid,
    [Parameter(Mandatory = $True, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [Alias('DDID')][string]$StorageID, 
    [Parameter(Mandatory = $True, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [Alias('Name')][string]$StorageUnitName,        
    [Parameter(Mandatory = $False, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [ValidateSet('COMPLIANCE', 'GOVERNANCE')]$RetentionLockMode,

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
      default {
        $Uri = "/$myself"
      }
    }  
    $body = @{}
    $body.Add('credentialId', $adminuserid)
    $body.Add('storageArrayId', $StorageID)
    $body.Add('storageUnit', @{})
    $Body.storageUnit.Add('name', $StorageUnitName)
    if ($RetentionLockMode) {
      $body.Add('retentionLock', @{})
      $body.retentionLock.Add('enabled', $true)
      $body.retentionLock.Add('mode', $RetentionLockMode)
    }

    $Body = $Body | ConvertTo-Json -depth 4
    write-verbose ($body | Out-String)	
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


function New-PPDMdatadomain_mtrees {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [pscredential]$SecurityOfficerCredentials,
    [Parameter(Mandatory = $True, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [ValidateSet('DDSTORAGEUNIT')][string]$Type,
    [Parameter(Mandatory = $True, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [Alias('DDID')][string]$StorageID, 
    [Parameter(Mandatory = $True, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [Alias('Name')][string]$StorageUnitName,        
    [Parameter(Mandatory = $False, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [ValidateSet('COMPLIANCE', 'GOVERNANCE')]$RetentionLockMode,

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
      default {
        $Uri = "/$myself"
      }
    }  
    $body = @{}
    $body.Add('type', $type)
    $body.Add('name', $StorageUnitName)
    $body.Add('storageSystem', @{})
    $Body.storageSystem.Add('id', $StorageID)
    if ($RetentionLockMode) {
      $body.Add('retentionLockMode', $RetentionLockMode)
      $body.Add('retentionLockSatus', $ENABLED)
    }
    If ($RetentionLockMode -eq "GOVERNANCE") {
      if (!$($SecurityOfficerCredentials)) {
        $username = Read-Host -Prompt "Please Enter PowerProtect SecurityOfficer Username"
        $SecurePassword = Read-Host -Prompt "Password for SecurityOfficer $username" -AsSecureString
        $SecurityOfficerCredentials = New-Object System.Management.Automation.PSCredential($username, $Securepassword)
      }
      $password = $($SecurityOfficerCredentials.GetNetworkCredential()).password
      $Body.add('securityOfficerUsername', $username)
      $Body.Add('securityOfficerPassword', $password)
    }
 
    $Body = $Body | ConvertTo-Json -depth 4
    write-verbose ($body | Out-String)	
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




####
# api/v2/datadomain-cloud-units/{storageSystemId}



function Get-PPDMdatadomain_cloud_units {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    [alias('Id')][string]$storageSystemId,
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
        $URI = "/$myself/$storageSystemId"
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

###### 
# api/v2/datadomain-ddboost-encryption-settings
function Get-PPDMdatadomain_ddboost_encryption_settings {
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



##
function Get-PPDMprotection_storage_metrics {
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
        write-output $response.systemsBySpaceUtilization
      } 
    }   
  }
}


