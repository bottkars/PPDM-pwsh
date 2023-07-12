<#
.Synopsis
Get all Protection Policies from PPDM
.Description
Retrieve al Protection Policies
- supports PPDM Filters
- Supports Policies by Type
- supports asset assignments

.Example
Get all Protection Policies as table format 
Get-PPDMprotection_policies | ft
id                                   name                          description                         assetType                   type   targetStorageProvisionStrategy
--                                   ----                          -----------                         ---------                   ----   ------------------
13ca2528-171f-4628-9063-b35aa9d265c5 Silver_SPBM                   This Policy does DDVE Cloud Tier    VMWARE_VIRTUAL_MACHINE      ACTIVE AUTO_PROVISION
200fb9c7-22a8-406b-b495-b6d6457de034 GOLD_SPBM                                                         VMWARE_VIRTUAL_MACHINE      ACTIVE AUTO_PROVISION
a374a075-4b9f-4ea8-bfc7-3700bea23314 GOLD_SPBM_NOTOOLS                                                 VMWARE_VIRTUAL_MACHINE      ACTIVE AUTO_PROVISION
ef4d7868-0786-4968-88b2-4da913c2f905 GOLD_SPBM_APP_AWARE                                               VMWARE_VIRTUAL_MACHINE      ACTIVE AUTO_PROVISION
23a74ead-6f91-4c49-844a-1f903a39ad70 Centralized_SQL                                                   MICROSOFT_SQL_DATABASE      ACTIVE AUTO_PROVISION
0b1c9b16-0775-4f5a-b613-9a0b75ca6aa6 Gold_Kubernetes                                                   KUBERNETES                  ACTIVE AUTO_PROVISION
a8d0fa51-b334-47ef-9c00-23499bfef896 SQL_APP_DIRECT                This Policy uses Application Direct MICROSOFT_SQL_DATABASE      ACTIVE AUTO_PROVISION
ead5f20a-efd6-42bc-a353-985121f62ed2 Gold_VMware                                                       VMWARE_VIRTUAL_MACHINE      ACTIVE AUTO_PROVISION
38d3acbc-8b41-477b-a5ab-6a85c74bfa9f Exchange Silver                                                   MICROSOFT_EXCHANGE_DATABASE ACTIVE AUTO_PROVISION
4f8ee8f7-68ef-4c09-8789-17301e82be3a Kube Backup Platform Services                                     KUBERNETES                  ACTIVE AUTO_PROVISION
e890a685-9fe9-4f9e-b91f-cfd61e7b131e Exchange Silver SelfService                                       MICROSOFT_EXCHANGE_DATABASE ACTIVE AUTO_PROVISION
aa9665ac-9a25-44db-a3e1-cbf0e698c971 CI_EX_CLI_CENTRAL2                                                MICROSOFT_EXCHANGE_DATABASE ACTIVE AUTO_PROVISION
.Example
Get all vmware assets assigned
Get-PPDMprotection_policies -type VMWARE_VIRTUAL_MACHINE -asset_assignments | ft

id                                   name              description assetType              type     category               targetStorageProvisionStrategy enabled passive forc
                                                                                                                                                                         eFul
                                                                                                                                                                            l
--                                   ----              ----------- ---------              ----     --------               ------------------------------ ------- ------- ----
3e38a236-24f3-4b90-a09d-71867a1b2081 PPDM                          VMWARE_VIRTUAL_MACHINE ACTIVE   CENTRALIZED_PROTECTION AUTO_PROVISION                   False   False …lse
aad3c5b2-bb17-4426-82a0-56addf1c72b2 Exclusions_VM_SPB             VMWARE_VIRTUAL_MACHINE EXCLUDED EXCLUSION              AUTO_PROVISION                    True   False
abf4f09e-9249-4bc6-8daf-cbcbd470ccc1 Exclusions                    VMWARE_VIRTUAL_MACHINE EXCLUDED EXCLUSION              AUTO_PROVISION                    True   False
9bc6b090-0826-4fe6-8f4a-53b57f135b9f win_test                      VMWARE_VIRTUAL_MACHINE ACTIVE   CENTRALIZED_PROTECTION AUTO_PROVISION                    True   False …lse
62095aab-ccf6-4d23-8563-63f61c86bf47 VM_TAG_BASED_AA               VMWARE_VIRTUAL_MACHINE ACTIVE   CENTRALIZED_PROTECTION AUTO_PROVISION                    True   False …lse
56c5ae63-df2c-44e2-96b8-039e348de3de LINUX_IMAGE                   VMWARE_VIRTUAL_MACHINE ACTIVE   CENTRALIZED_PROTECTION AUTO_PROVISION                    True   False …lse
.Example
Get Protection Policy with ID
Get-PPDMprotection_policies -id a374a075-4b9f-4ea8-bfc7-3700bea23314

id                             : a374a075-4b9f-4ea8-bfc7-3700bea23314
name                           : GOLD_SPBM_NOTOOLS
description                    :
assetType                      : VMWARE_VIRTUAL_MACHINE
type                           : ACTIVE
targetStorageProvisionStrategy : AUTO_PROVISION
enabled                        : True
passive                        : False
forceFull                      : False
priority                       : 1
credentials                    :
encrypted                      : False
dataConsistency                : CRASH_CONSISTENT
complianceInterval             :
details                        : @{vm=}
summary                        : @{numberOfAssets=1; totalAssetCapacity=8589934592; totalAssetProtectionCapacity=2341732352; numberOfJobFailures=0;
                                 numberOfSlaFailures=0; numberOfSlaSuccess=0; lastExecutionStatus=SUCCEEDED}
stages                         : {@{id=2e07bd54-7fc1-7dea-0ec7-c827e41faec2; type=CDR; passive=False; retention=; target=;
                                 sourceStageId=4dd98961-1e1b-29a2-8712-c37ce8c1ec69; attributes=; operations=System.Object[]},
                                 @{id=4dd98961-1e1b-29a2-8712-c37ce8c1ec69; type=PROTECTION; passive=False; retention=; target=; attributes=;
                                 operations=System.Object[]}}
filterIds                      : {}
createdAt                      : 08.02.2021 12:03:48
updatedAt                      : 08.02.2021 12:17:50
slaId                          :
_links                         : @{self=}

.Example
Use Filter to match a name
Get-PPDMprotection_policies -filter 'name lk "%NOTOOLS%"' | Select-Object id,name,assetType

id                                   name              assetType
--                                   ----              ---------
a374a075-4b9f-4ea8-bfc7-3700bea23314 GOLD_SPBM_NOTOOLS VMWARE_VIRTUAL_MACHINE

.Example
Use Pagination to retrieve only 5 Results
Get-PPDMprotection_policies  -body @{pageSize=5} -filter 'name lk "%GOLD%"'

.Example
Use Pagination and filter t retrieve 
Get-PPDMprotection_policies  -body @{pageSize=2} -filter 'name lk "%GOLD%"' | Select-Object id,name,assetType

id                                   name              assetType
--                                   ----              ---------
200fb9c7-22a8-406b-b495-b6d6457de034 GOLD_SPBM         VMWARE_VIRTUAL_MACHINE
a374a075-4b9f-4ea8-bfc7-3700bea23314 GOLD_SPBM_NOTOOLS VMWARE_VIRTUAL_MACHINE
.EXAMPLE

Get-PPDMprotection_policies -type FILE_SYSTEM -asset_assignments

id                             : 553a0d10-7075-41fa-a645-08262f6addd8
name                           : fs_demo
description                    :
assetType                      : FILE_SYSTEM
type                           : ACTIVE
category                       : CENTRALIZED_PROTECTION
targetStorageProvisionStrategy : AUTO_PROVISION
enabled                        : True
passive                        : False
forceFull                      : False
priority                       : 1
credentials                    :
encrypted                      : False
dataConsistency                : CRASH_CONSISTENT
complianceInterval             :
details                        :
summary                        : @{numberOfAssets=1; totalAssetCapacity=105086115840; totalAssetProtectionCapacity=47862742004; numberOfJobFailures=0;
                                 numberOfSlaFailures=0; numberOfSlaSuccess=0; lastExecutionStatus=SUCCEEDED}
stages                         : {@{id=03cbb135-bdde-f70a-81e7-4dc3f079826b; type=PROTECTION; passive=False; retention=; extendedRetentions=System.Object[]; target=;
                                 attributes=; operations=System.Object[]; options=}}
filterIds                      : {}
createdAt                      : 27.10.2022 12:09:53
updatedAt                      : 27.10.2022 12:10:12
slaId                          :
_links                         : @{self=}

#>
function Get-PPDMprotection_policies {
  [CmdletBinding()]
  param(    
    [Parameter(Mandatory = $true, ParameterSetName = 'type', ValueFromPipelineByPropertyName = $true)]
    [ValidateSet(
      'VMAX_STORAGE_GROUP',
      'VMWARE_VIRTUAL_MACHINE',
      'ORACLE_DATABASE',
      'MICROSOFT_SQL_DATABASE',
      'FILE_SYSTEM',
      'KUBERNETES',
      'MICROSOFT_EXCHANGE_DATABASE',
      'SAP_HANA_DATABASE',
      'NAS_SHARE',
      'POWERSTORE_BLOCK'
    )]$type,
    
    [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    $id,
    [Parameter(Mandatory = $false, ParameterSetName = 'type', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [switch]$asset_assignments,
    [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    $filter,
    [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'type', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]  
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'type', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    $apiver = "/api/v2",
    [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'type', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    $body = @{pageSize = 200 }   
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
        if ($asset_assignments.IsPresent) {
          $URI = "$URI/asset-assignments"
        }    
      }
      default {
        $URI = "/$myself"
      }
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
      $parameters.Add('filter', $filter)
    }
    if ($type) {
      $parameters.Add('filter', "assetType eq `"$type`"")
    }    
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
        if ( $asset_assignments.IsPresent ) {
          write-output $response.content
        }
        else {
          write-output $response
        }            
      }
      default {
        write-output $response.content
      } 
    }   
  }
}

<#
.Synopsis
New API Edpoint to start a Protection Policy includig asset list
.Description
Starting a Policy requires Stage and Policy ID.
CMDlet Supports the Input of a Policy Object including. See Example
.Example
$Policy = Get-PPDMprotection_policies  -body @{pageSize=1} -filter 'name eq "GOLD_SPBM_NOTOOLS"'
Start-PPDMprotection -PolicyObject $Policy
Thu, 06 May 2021 09:11:11 GMT
#>
function Start-PPDMprotection {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'byPolicyObject')]
    [psobject]$PolicyObject,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byPolicyObject')]
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byIDS')]
    [string[]][alias('Assets')]$AssetIDs,  
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byIDS')]
    [string][alias('id')]$PolicyID,
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byIDS')]
    [string][alias('stage')]$StageID,    
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'byIDS')]
    [ValidateSet("FULL",
      "DIFFERENTIAL",
      "LOG",
      "INCREMENTAL",
      "CUMULATIVE",
      "AUTO_FULL",
      "SYNTHETIC_FULL",
      "GEN0")]
    $BackupType = 'FULL',
    [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'byPolicyObject')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'byIDS')]
    [ValidateSet('DAY', 'WEEK', 'MONTH', 'YEAR' )]
    $RetentionUnit = 'DAY',
    [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'byPolicyObject')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'byIDS')]
    [Int32]$RetentionInterval = '7',        
    [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'byPolicyObject')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'byIDS')]
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'byPolicyObject')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'byIDS')]
    $apiver = "/api/v2",
    [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'byPolicyObject')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'byIDS')]
    [switch]$noop
  )
  begin {
    $Response = @()
    $METHOD = "POST"
    # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
 
  }     
  Process {
    switch ($PsCmdlet.ParameterSetName) {
      default {
      }
      'byPolicyObject' {
        $StageID = ($PolicyObject.stages | Where-Object type -eq PROTECTION).id
        $BackupType = ($PolicyObject.stages | Where-Object type -eq PROTECTION).operations.backupType
        $PolicyID = $PolicyObject.id
      }

    }    
    $Body = [ordered]@{
      'assetIds' = $AssetIDs
      'stages'   = @(
        @{
          'id'        = $StageID  
          'operation' = @{
            'backupType' = $BackupType
          }  
          'retention' = @{
            'interval' = $RetentionInterval
            'unit'     = $RetentionUnit
          }
        } )
    } | convertto-json -Depth 3
    write-verbose ($body | out-string)
    Write-Verbose $PolicyID
    $Parameters = @{
      RequestMethod           = 'Rest'
      body                    = $body 
      Uri                     = "protection-policies/$PolicyID/protections"
      Method                  = $Method
      PPDM_API_BaseUri        = $PPDM_API_BaseUri
      apiver                  = $apiver
      Verbose                 = $PSBoundParameters['Verbose'] -eq $true
      ResponseHeadersVariable = 'HeaderResponse'
    }
    Write-Verbose ($Parameters | Out-String)
    if (!$noop.ispresent) {        
      try {
        $Response += Invoke-PPDMapirequest @Parameters
      }
      catch {
        Get-PPDMWebException  -ExceptionMessage $_
        break
      }
      write-verbose ($response | Out-String)
    }
  } 
  end {  
    if (!$noop.IsPresent) {

      switch ($PsCmdlet.ParameterSetName) {
        default {
          write-output $response.Date
        } 
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
    [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
    [ValidateSet('FULL', 'GEN0', 'DIFFERENTIAL', 'LOG', 'INCREMENTAL', 'CUMULATIVE', 'AUTO_FULL')]
    $BackupType = 'FULL',
    [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
    [ValidateSet('DAY', 'WEEK', 'MONTH', 'YEAR' )]
    $RetentionUnit = 'DAY',
    [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
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
      'disableProtectionPolicyProcessing' = 'false'
      'retention'                         = @{
        'interval' = $RetentionInterval
        'unit'     = $RetentionUnit
      }
    } | convertto-json -compress
    write-verbose ($body | out-string)
    $Parameters = @{
      body                    = $body 
      Uri                     = "/$Myself/$PolicyID/backups"
      Method                  = $Method
      PPDM_API_BaseUri        = $PPDM_API_BaseUri
      apiver                  = $apiver
      RequestMethod           = "REST"
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



function Remove-PPDMprotection_policies {
  [CmdletBinding()]
  param(
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    $apiver = "/api/v2",
    [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
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
        write-output $response 
      }
      default {
        write-output $response.date
      } 
    }   
  }
}

<#
.Synopsis
Remove Asset(s) from a Protection Policy
.Description
Unassign assets from a Policy
.Example
Remove all Assets from a Specific vCenter from a specific Protection Policy
$Policy = Get-PPDMprotection_policies -filter { assetType eq "VMWARE_VIRTUAL_MACHINE" and name eq "<your policy name>" }
# List the Asset Assignments:
$Policy | Get-PPDMprotection_policies -asset_assignments -filter {details.vm.inventorySourceName eq "<your vcenter name>"}
$Policy | Get-PPDMprotection_policies -asset_assignments -filter {details.vm.inventorySourceName eq "<your vcenter name>"} | Remove-PPDMProtection_policy_assignment
#>

function Remove-PPDMProtection_policy_assignment {
  [CmdletBinding()]
  [Alias('Unregister-PPDMAssetFromPoliy')]
  param(
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    [alias('id')][string[]]$AssetID, 
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    [alias('PLC')]$protectionPolicyId, 
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    $apiver = "/api/v2"

  )
  begin {
    $Response = @()
    $METHOD = "POST"
  }     
  Process {

    $URI = "/protection-policies/$protectionPolicyId/asset-unassignments"
    if ($AssetID.Count -eq 1) {
      $body = "[`"$AssetID`"]"
    }
    else {
      $body = @(
        @($AssetID)
      ) | ConvertTo-Json -Depth 3
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

function Add-PPDMProtection_policy_assignment {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    [alias('fqdn')][string[]]$AssetID, 
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    [alias('PLC')]$ID, 
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    $apiver = "/api/v2"

  )
  begin {
    $Response = @()
    $METHOD = "POST"
  }     
  Process {

    $URI = "/protection-policies/$ID/asset-assignments"
    if ($AssetID.Count -eq 1) {
      $body = "[`"$AssetID`"]"
    }
    else {
      $body = @(
        @($AssetID)
      ) | ConvertTo-Json -Depth 3
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






function New-PPDMBackupSchedule {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'hourly_')]                        
    [switch]$hourly,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'hourly_w_full_weekly')] 
    [switch]$hourly_w_full_weekly,  
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'hourly_w_full_monthly')]
    [switch]$hourly_w_full_monthly,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'daily_')]
    [switch]$daily,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'daily_w_full_weekly')]
    [switch]$daily_w_full_weekly,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'daily_w_full_monthly')]
    [switch]$daily_w_full_monthly,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'weekly_')]
    [switch]$weekly,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'weekly_w_full_weekly')]
    [switch]$weekly_w_full_weekly,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'weekly_w_full_monthly')]                   
    [switch]$weekly_w_full_monthly,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_')]
    [switch]$monthly_day,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [switch]$monthly_day_of_week,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_w_full_monthly')]
    [switch]$monthly_day_w_full_monthly,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_w_full_monthly')]
    [switch]$monthly_day_of_week_w_full_monthly,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'hourly_')]        
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'hourly_w_full_weekly')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'hourly_w_full_monthly')] 
    [int][ValidateRange(1, 22)]$CreateCopyIntervalHrs, 
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'daily_w_full_weekly')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'weekly_w_full_weekly')]                      
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'hourly_w_full_weekly')]
    [String][ValidateSet("SUNDAY",
      "MONDAY",
      "TUESDAY",
      "WEDNESDAY",
      "THURSDAY",
      "FRIDAY",
      "SATURDAY")]$CreateFull_Every_DayofWeek,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'daily_w_full_monthly')]            
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'weekly_w_full_monthly')]                   
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'hourly_w_full_monthly')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_w_full_monthly')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_w_full_monthly')]
    [int][ValidateRange(1, 28)]$CreateFull_Every_DayofMonth,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_w_full_monthly')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_')]
    [int][ValidateRange(1, 28)]$CreateCopydayofMonth,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_w_full_monthly')]        
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [String][ValidateSet("SUNDAY",
      "MONDAY",
      "TUESDAY",
      "WEDNESDAY",
      "THURSDAY",
      "FRIDAY",
      "SATURDAY")]$CreateCopyDayofWeek,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_w_full_monthly')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [int][ValidateRange(1, 4)]$CreateCopyWeekofMonth,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'weekly_')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'weekly_w_full_weekly')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'weekly_w_full_monthly')]        
    [String[]][ValidateSet("SUNDAY",
      "MONDAY",
      "TUESDAY",
      "WEDNESDAY",
      "THURSDAY",
      "FRIDAY",
      "SATURDAY")]$CreateCopyDays,  
      
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'hourly_')]                        
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'hourly_w_full_weekly')] 
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'hourly_w_full_monthly')]  
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'daily_')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'daily_w_full_weekly')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'daily_w_full_monthly')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'weekly_')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'weekly_w_full_weekly')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'weekly_w_full_monthly')]                   
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_w_full_monthly')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_w_full_monthly')]
    [ValidateSet("YEAR",
      "MONTH",
      "WEEK",
      "DAY")]
    [string]$RetentionUnit,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'hourly_')]                        
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'hourly_w_full_weekly')] 
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'hourly_w_full_monthly')]  
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'daily_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'daily_w_full_weekly')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'daily_w_full_monthly')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'weekly_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'weekly_w_full_weekly')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'weekly_w_full_monthly')]                   
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_w_full_monthly')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_w_full_monthly')]
    [ValidateRange(1, 2555)][int]$RetentionInterval,    
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'hourly_')]                        
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'hourly_w_full_weekly')] 
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'hourly_w_full_monthly')]  
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'daily_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'daily_w_full_weekly')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'daily_w_full_monthly')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'weekly_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'weekly_w_full_weekly')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'weekly_w_full_monthly')]                   
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_w_full_monthly')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_w_full_monthly')]
    [DateTime][Alias('startime')]$starttime = "8:00PM",
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'hourly_')]                        
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'hourly_w_full_weekly')] 
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'hourly_w_full_monthly')]  
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'daily_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'daily_w_full_weekly')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'daily_w_full_monthly')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'weekly_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'weekly_w_full_weekly')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'weekly_w_full_monthly')]                   
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_w_full_monthly')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_w_full_monthly')]
    [DateTime]$endtime = "6:00AM"


    
  )
  begin {

  }     
  Process {
    $PTHours = ($starttime - $endtime).Hours
    $schedule = @{}
    $retention = @{
      'interval' = $RetentionInterval
      'unit'     = $RetentionUnit
    }
    $copySchedule = @{
      'duration'  = "PT$($PTHours)H"
      'startTime' = $(Get-Date $starttime -Format yyyy-MM-ddThh:mm:ss.000Z)
    }                  

    $fullSchedule = @{
      'duration'  = "PT$($PTHours)H"
      'startTime' = $(Get-DAte $starttime -Format yyyy-MM-ddThh:mm:ss.000Z)
    }            
    switch (($($PSCmdlet.ParameterSetName) -split "_")[0]) {
      'hourly' {
        $copyschedule.Add('frequency', 'HOURLY')
        $copyschedule.Add('interval', $CreateCopyIntervalHrs)
      }
      'daily' {
        $copyschedule.Add('frequency', 'DAILY')
      } 
      'weekly' {
        $copyschedule.Add('frequency', 'WEEKLY')
        $copyschedule.Add('weekDays', @($CreateCopyDays))
      }
      'monthlyday' {
        $copyschedule.Add('frequency', 'MONTHLY')
        $copyschedule.Add('dayOfMonth', $CreateCopydayofMonth)
      }
              
      'monthlydayofweek' {
        $copyschedule.Add('frequency', 'MONTHLY')
        $copyschedule.Add('weekDays', @($CreateCopyDayofWeek))
        If ($CreateCopyWeekofMonth) {
          $copyschedule.Add('weekOfMonth', $CreateCopyWeekofMonth)    
        }
        else {
          $copyschedule.Add('genericDay', 'LAST')    
        }
      }                      
    }


    


    switch (($($PSCmdlet.ParameterSetName) -split "_w_")[1]) {

      'full_weekly' {
        $fullschedule.Add('frequency', 'WEEKLY')
        $fullschedule.Add('weekDays', @($CreateFull_Every_DayofWeek))
                
      }
      'full_monthly' {
        $fullschedule.Add('frequency', 'MONTHLY')
        $fullschedule.Add('dayOfMonth', $CreateFull_Every_DayofMonth)
      }            
    } 

    $Schedule.Add('FullSchedule', $fullSchedule)
    $Schedule.Add('CopySchedule', $copySchedule)
    $schedule.Add('Retention', $retention)
  } 
  end {    
    switch ($PsCmdlet.ParameterSetName) {
      default {
        write-output $Schedule
      } 
    }   
  }
}


function New-PPDMDatabaseBackupSchedule {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'hourly_')]                        
    [switch]$hourly,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'daily_')]
    [switch]$daily,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'weekly_')]
    [switch]$weekly,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_')]
    [switch]$monthly_day,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [switch]$monthly_day_of_week,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'hourly_')]        
    [int][ValidateRange(1, 22)]$CreateCopyIntervalHrs, 
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_')]
    [int][ValidateRange(1, 28)]$CreateCopydayofMonth,   
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [String][ValidateSet("SUNDAY",
      "MONDAY",
      "TUESDAY",
      "WEDNESDAY",
      "THURSDAY",
      "FRIDAY",
      "SATURDAY")]$CreateCopyDayofWeek,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [int][ValidateRange(1, 4)]$CreateCopyWeekofMonth,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'weekly_')]  
    [String[]][ValidateSet("SUNDAY",
      "MONDAY",
      "TUESDAY",
      "WEDNESDAY",
      "THURSDAY",
      "FRIDAY",
      "SATURDAY")]$CreateCopyDays,  
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'hourly_')]                        
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'daily_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'weekly_')]               
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [ValidateSet("MINUTELY",
      "HOURLY")]
    [string]$LogBackupUnit,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'hourly_')]                        
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'daily_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'weekly_')]               
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [int]$LogBackupInterval,      
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'hourly_')]                        
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'daily_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'weekly_')]               
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [ValidateSet("MINUTELY",
      "HOURLY")]
    [string]$DifferentialBackupUnit,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'hourly_')]                        
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'daily_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'weekly_')]               
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [int]$DifferentialBackupInterval,      
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'hourly_')]                        
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'daily_')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'weekly_')]               
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [ValidateSet("YEAR",
      "MONTH",
      "WEEK",
      "DAY")]
    [string]$RetentionUnit,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'hourly_')]                        
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'daily_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'weekly_')]               
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [ValidateRange(1, 2555)][int]$RetentionInterval,    
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'hourly_')]                        
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'daily_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'weekly_')]              
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [DateTime][Alias('startime')]$starttime = "8:00PM",
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'hourly_')]                        
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'daily_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'weekly_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [DateTime]$endtime = "6:00AM"


    
  )
  begin {

  }     
  Process {
    $PTHours = ($starttime - $endtime).Hours
    $schedule = @{}
    $retention = @{
      'interval' = $RetentionInterval
      'unit'     = $RetentionUnit
    }
    $copySchedule = @{
      'duration'  = "PT$($PTHours)H"
      'startTime' = $(Get-Date $starttime -Format yyyy-MM-ddThh:mm:ss.000Z)
    }  
    switch (($($PSCmdlet.ParameterSetName) -split "_")[0]) {
      'hourly' {
        $copyschedule.Add('frequency', 'HOURLY')
        $copyschedule.Add('interval', $CreateCopyIntervalHrs)
      }
      'daily' {
        $copyschedule.Add('frequency', 'DAILY')
      } 
      'weekly' {
        $copyschedule.Add('frequency', 'WEEKLY')
        $copyschedule.Add('weekDays', @($CreateCopyDays))
      }
      'monthlyday' {
        $copyschedule.Add('frequency', 'MONTHLY')
        $copyschedule.Add('dayOfMonth', $CreateCopydayofMonth)
      }
              
      'monthlydayofweek' {
        $copyschedule.Add('frequency', 'MONTHLY')
        $copyschedule.Add('weekDays', @($CreateCopyDayofWeek))
        If ($CreateCopyWeekofMonth) {
          $copyschedule.Add('weekOfMonth', $CreateCopyWeekofMonth)    
        }
        else {
          $copyschedule.Add('genericDay', 'LAST')    
        }
      }                      
    }
    $Schedule.Add('copySchedule', $copySchedule) 
    
    $schedule.Add('retention', $retention)
    if ($LogBackupInterval) {
      $LogSchedule = @{
        "backupType" = "LOG" 
      }

      
      $LogSchedule.Add('schedule', @{})
      $LogSchedule.schedule.Add('interval', $LogBackupInterval)
      $LogSchedule.schedule.Add('frequency', $LogBackupUnit)
      $LogSchedule.schedule.Add('logEnabled', $True)
      $LogSchedule.schedule.Add('duration' , "PT$($PTHours)H")
      $LogSchedule.schedule.Add('startTime', $(Get-DAte $starttime -Format yyyy-MM-ddThh:mm:ss.000Z))
      $Schedule.Add('logSchedule', $logSchedule)   
    } 
    if ($DifferentialBackupInterval) {
      $DifferentialSchedule = @{
        'backupType' = 'DIFFERENTIAL' 
      }
      $DifferentialSchedule.Add('schedule', @{})
      $DifferentialSchedule.schedule.Add('frequency', $DifferentialBackupUnit)
      $DifferentialSchedule.schedule.Add('interval', $DifferentialBackupInterval)
      $DifferentialSchedule.schedule.Add('diffEnabled', $true)
      $DifferentialSchedule.schedule.Add('duration', "PT$($PTHours)H")
      $DifferentialSchedule.schedule.Add('startTime', $(Get-DAte $starttime -Format yyyy-MM-ddThh:mm:ss.000Z))

      
      $Schedule.Add('differentialSchedule', $DifferentialSchedule)    
    }         

  } 
  end {    
    switch ($PsCmdlet.ParameterSetName) {
      default {
        write-output $Schedule
      } 
    }   
  }
}


function New-PPDMVMBackupPolicy {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [psobject]$Schedule,    
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [ValidateLength(1, 150)][string]$Name,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [ValidateLength(1, 150)][string]$StorageSystemID,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [string][ValidateSet('FSS', 'VSS')]$backupMode = 'VSS',
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [switch]$excludeSwapFiles,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [switch]$disableQuiescing,    
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [switch]$enabled,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [switch]$encrypted, 
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [string]$Description = '' ,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    $apiver = "/api/v2",
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [switch]$noop           
  )
  begin {
    $Response = @()
    $METHOD = "POST"
  }     
  Process {

    $URI = "/protection-policies"
  
    $operations = @()
    $copyoperation = @{}
    $copyoperation.Add('schedule', $Schedule.CopySchedule)
    $copyoperation.Add('backupType', 'SYNTHETIC_FULL')         

    $fulloperation = @{}
    $fulloperation.Add('schedule', $Schedule.FullSchedule)
    $fulloperation.Add('backupType', 'FULL')         
      
    $operations += $copyoperation 
    $operations += $fulloperation 

    $Body = [ordered]@{ 
      'name'            = $Name
      'assetType'       = 'VMWARE_VIRTUAL_MACHINE'
      'type'            = 'ACTIVE'
      'dataConsistency' = 'CRASH_CONSISTENT'
      'enabled'         = $enabled.IsPresent
      'description'     = $Description
      'encrypted'       = $encrypted.IsPresent
      'priority'        = 1
      'passive'         = $false
      'forceFull'       = $false
      'details'         = @{
        'vm' = @{
          'protectionEngine' = 'VMDIRECT'
        }
      }
      'stages'          = @(
        @{
          'id'         = (New-Guid).Guid   
          'type'       = 'PROTECTION'
          'passive'    = $false
          'attributes' = @{
            'vm'         = @{
              'excludeSwapFiles' = $excludeSwapFiles.IsPresent
              'disableQuiescing' = $disableQuiescing.IsPresent
            }
            'protection' = @{
              'backupMode' = $backupMode
            }
          }                     
          'target'     = @{
            'storageSystemId' = $StorageSystemID
          }
          'operations' = $operations
          'retention'  = $Schedule.Retention
        }
      ) 
    } | convertto-json -Depth 7


        
    write-verbose ($body | out-string)
    $Parameters = @{
      body             = $body 
      Uri              = $URI
      Method           = $Method
      PPDM_API_BaseUri = $PPDM_API_BaseUri
      apiver           = $apiver
      Verbose          = $PSBoundParameters['Verbose'] -eq $true
    } 
    if (!$noop.IsPresent) {      
      try {
        $Response += Invoke-PPDMapirequest @Parameters
      }
      catch {
        Get-PPDMWebException  -ExceptionMessage $_
        break
      }
      write-verbose ($response | Out-String)
    } 
  } 
  end {    
    switch ($PsCmdlet.ParameterSetName) {
      default {
        write-output ($response | convertfrom-json)
      } 
    }   
  }
}
<#
.Synopsis
Creates a K8S Backup Policy
.Description
K8S Backup Policy is a Syntetic Full and Requires a copy only schedule ( hourly, daily, weekly or monthly )

.Example
This example Creates a K8S Protection Policy with an 2 - hourly schedule,
and than adds  
$Storage_system=Get-PPDMstorage_systems | where type -match DATA_DOMAIN_SYSTEM
$Schedule=New-PPDMBackupSchedule -hourly -CreateCopyIntervalHrs 2 -RetentionUnit DAY -RetentionInterval 7
$Policy=New-PPDMK8SBackupPolicy -Schedule $Schedule -StorageSystemID $Storage_system.id -enabled -encrypted -Name CI_K8S_CLI
$AssetID=(Get-PPDMassets | where { $_.name -match "mongo" -and $_.subtype -eq "K8S_NAMESPACE"}).id
Add-PPDMProtection_policy_assignment -AssetID $AssetID -id $Policy.id
Runthe Protection via policy:
Start-PPDMprotection -PolicyObject $Policy -AssetIDs  $Asset.id

or via asset backup (will be deprectaed)
Start-PPDMasset_backups -AssetID $AssetID -BackupType AUTO_FULL
#>
function New-PPDMK8SBackupPolicy {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [psobject]$Schedule,    
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [ValidateLength(1, 150)][string]$Name,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [ValidateLength(1, 150)][string]$StorageSystemID,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [string][ValidateSet('FSS', 'VSS')]$backupMode = 'VSS',
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [switch]$excludeSwapFiles,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [switch]$disableQuiescing,    
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [switch]$enabled,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [switch]$encrypted, 
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [string]$Description = '' ,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    $apiver = "/api/v2",
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'Set1')]
    [switch]$noop           
  )
  begin {
    $Response = @()
    $METHOD = "POST"
  }     
  Process {

    $URI = "/protection-policies"
  
    $operations = @()
    $copyoperation = @{}
    $copyoperation.Add('schedule', $Schedule.CopySchedule)
    $copyoperation.Add('backupType', 'SYNTHETIC_FULL')         


    $operations += $copyoperation 

    $Body = [ordered]@{ 
      'name'            = $Name
      'assetType'       = 'KUBERNETES'
      'type'            = 'ACTIVE'
      'dataConsistency' = 'CRASH_CONSISTENT'
      'enabled'         = $enabled.IsPresent
      'description'     = $Description
      'encrypted'       = $encrypted.IsPresent
      'priority'        = 1
      'passive'         = $false
      'forceFull'       = $false
      'details'         = @{
        'vm' = @{
          'protectionEngine' = 'VMDIRECT'
        }
      }
      'stages'          = @(
        @{
          'id'         = (New-Guid).Guid   
          'type'       = 'PROTECTION'
          'passive'    = $false
          'attributes' = @{}                     
          'target'     = @{
            'storageSystemId' = $StorageSystemID
          }
          'operations' = $operations
          'retention'  = $Schedule.Retention
        }
      ) 
    } | convertto-json -Depth 7


        
    write-verbose ($body | out-string)
    $Parameters = @{
      body             = $body 
      Uri              = $URI
      Method           = $Method
      PPDM_API_BaseUri = $PPDM_API_BaseUri
      apiver           = $apiver
      Verbose          = $PSBoundParameters['Verbose'] -eq $true
    } 
    if (!$noop.IsPresent) {      
      try {
        $Response += Invoke-PPDMapirequest @Parameters
      }
      catch {
        Get-PPDMWebException  -ExceptionMessage $_
        break
      }
      write-verbose ($response | Out-String)
    } 
  } 
  end {    
    switch ($PsCmdlet.ParameterSetName) {
      default {
        write-output ($response | convertfrom-json)
      } 
    }   
  }
}



function New-PPDMFSBackupPolicy {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [psobject]$Schedule,    
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    [ValidateLength(1, 150)][string]$Name,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    [ValidateLength(1, 150)][string]$StorageSystemID,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    [switch]$enabled,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    [switch]$encrypted, 
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    [string]$Description = '' ,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [string[]]$FilterIDS,    
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    $apiver = "/api/v2",
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [switch]$TroubleshootingDebug,
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'selfservice')]
    [ValidateSet("YEAR",
      "MONTH",
      "WEEK",
      "DAY")]
    [string]$RetentionUnit,
    [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'selfservice')]
    [ValidateRange(1, 2555)][int]$RetentionInterval,    
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    [switch]$noop                  
  )
  begin {
    $Response = @()
    $METHOD = "POST"
  }     
  Process {

    $URI = "/protection-policies"
  
    switch ($pscmdlet.ParameterSetName ) {
      'centralized' { 
        $operations = @()

        $copyoperation = @{}
        $copyoperation.Add('schedule', $Schedule.CopySchedule)
        $copyoperation.Add('backupType', 'SYNTHETIC_FULL')         
    
        $fulloperation = @{}
        $fulloperation.Add('schedule', $Schedule.FullSchedule)
        $fulloperation.Add('backupType', 'FULL')         
          
        $operations += $copyoperation 
        $operations += $fulloperation 
        [switch]$passive = $false

      }
      Default {
        [switch]$passive = $true
        $schedule = @{}
        $schedule.add('Retention', @{})
        $schedule.Retention.add('interval', $RetentionInterval)
        $schedule.Retention.add('unit', $RetentionUnit)

      }
    }

    $Body = [ordered]@{ 
      'name'            = $Name
      'assetType'       = 'FILE_SYSTEM'
      'type'            = 'ACTIVE'
      'dataConsistency' = 'CRASH_CONSISTENT'
      'filterIds'       = $FilterIDS
      'enabled'         = $enabled.IsPresent
      'description'     = $Description
      'encrypted'       = $encrypted.IsPresent
      'priority'        = 1
      'passive'         = $passive.IsPresent
      'forceFull'       = $false
      'details'         = ''
      'stages'          = @(
        @{
          'id'         = (New-Guid).Guid   
          'type'       = 'PROTECTION'
          'passive'    = $passive.IsPresent
          'attributes' = @{
            'filesytem' = @{
              'troubleShootingOption' = "debugEnabled=$($TroubleshootingDebug.IsPresent)"
            }
          }                     
          'target'     = @{
            'storageSystemId' = $StorageSystemID
          }
          'operations' = $operations
          'retention'  = $Schedule.Retention
        }
      ) 
    } | convertto-json -Depth 7


        
    write-verbose ($body | out-string)
    $Parameters = @{
      body             = $body 
      Uri              = $URI
      Method           = $Method
      PPDM_API_BaseUri = $PPDM_API_BaseUri
      apiver           = $apiver
      Verbose          = $PSBoundParameters['Verbose'] -eq $true
    } 
    if (!$noop.IsPresent) {      
      try {
        $Response += Invoke-PPDMapirequest @Parameters
      }
      catch {
        Get-PPDMWebException  -ExceptionMessage $_
        break
      }
      write-verbose ($response | Out-String)
    } 
  } 
  end {    
    switch ($PsCmdlet.ParameterSetName) {
      default {
        write-output ($response | convertfrom-json)
      } 
    }   
  }
}





function New-PPDMSQLBackupPolicy {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [psobject]$Schedule,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [string]$dbcredentialsID,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    [ValidateLength(1, 150)][string]$Name,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    [ValidateLength(1, 150)][string]$StorageSystemID,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    [switch]$enabled,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    [switch]$encrypted, 
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    [string]$Description = '' ,  
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    $apiver = "/api/v2",
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [switch]$TroubleshootingDebug,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [switch]$excludeSystemDatabase,
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'selfservice')]
    [ValidateSet("YEAR",
      "MONTH",
      "WEEK",
      "DAY")]
    [string]$RetentionUnit,
    [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'selfservice')]
    [ValidateRange(1, 2555)][int]$RetentionInterval,    
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    [switch]$noop                  
  )
  begin {
    $Response = @()
    $METHOD = "POST"
  }     
  Process {

    $URI = "/protection-policies"
  
    switch ($pscmdlet.ParameterSetName ) {
      'centralized' { 
        $operations = @()

        $copyoperation = @{}
        $copyoperation.Add('schedule', $Schedule.CopySchedule)
        $copyoperation.Add('backupType', 'FULL')         


     
          
        $operations += $copyoperation 
        $mssql_options = @{
          'troubleShootingOption' = "debugEnabled=$($TroubleshootingDebug.IsPresent)"
          'excludeSystemDatabase' = $excludeSystemDatabase.IsPresent
        }
        $mssql_credentials = @{
          'id'   = $dbcredentialsID
          'type' = 'OS'
        }
        if ($schedule.differentialSchedule) {
          $operations += $schedule.differentialSchedule   

        }

        if ($schedule.logSchedule) {
          $operations += $schedule.logSchedule   
        }

        [switch]$passive = $false

      }
      Default {
        [switch]$passive = $true
        $mssql_options = @{}
        $schedule = @{}
        $schedule.add('Retention', @{})
        $schedule.Retention.add('interval', $RetentionInterval)
        $schedule.Retention.add('unit', $RetentionUnit)

      }
    }

    $Body = [ordered]@{ 
      'name'            = $Name
      'assetType'       = 'MICROSOFT_SQL_DATABASE'
      'credentials'     = $mssql_credentials
      'type'            = 'ACTIVE'
      'dataConsistency' = 'APPLICATION_CONSISTENT'
      'enabled'         = $enabled.IsPresent
      'description'     = $Description
      'encrypted'       = $encrypted.IsPresent
      'filterIds'       = @()
      'priority'        = 1
      'passive'         = $passive.IsPresent
      'forceFull'       = $false
      'details'         = $details
      'stages'          = @(
        @{
          'id'         = (New-Guid).Guid   
          'type'       = 'PROTECTION'
          'passive'    = $passive.IsPresent
          'attributes' = @{
            'mssql' = $mssql_options
          }                     
          'target'     = @{
            'storageSystemId' = $StorageSystemID
          }
          'operations' = $operations
          'options'    = @{
            "skipSimpleDatabase" = $true
            "promotionType"      = "ALL"
          }
          'retention'  = $Schedule.Retention
        }
      ) 
    } | convertto-json -Depth 7


        
    write-verbose ($body | out-string)
    $Parameters = @{
      body             = $body 
      Uri              = $URI
      Method           = $Method
      PPDM_API_BaseUri = $PPDM_API_BaseUri
      apiver           = $apiver
      Verbose          = $PSBoundParameters['Verbose'] -eq $true
    } 
    if (!$noop.IsPresent) {      
      try {
        $Response += Invoke-PPDMapirequest @Parameters
      }
      catch {
        Get-PPDMWebException  -ExceptionMessage $_
        break
      }
      write-verbose ($response | Out-String)
    } 
  } 
  end {    
    switch ($PsCmdlet.ParameterSetName) {
      default {
        write-output ($response | convertfrom-json)
      } 
    }   
  }
}
<#
.Synopsis
Creates an Centralized or Self Service Primary Backup Policy
.Description
Parametersets are Used to define Centralized or Self-Service Policies
For Centralized Backups, a Schedule Object creted with  must be Provided

.Example
PS /home/bottk/workspace/PPDM-pwsh> schedule=New-PPDMBackupSchedule -hourly_w_full_weekly -CreateCopyIntervalHrs 2 -CreateFull_Every_DayofWeek SUNDAY -RetentionUnit DAY -RetentionInterval 7 
PS /home/bottk/workspace/PPDM-pwsh> New-PPDMExchangeBackupPolicy -Schedule $sched -StorageSystemID ed9a3cd6-7e69-4332-a299-aaf258e23328 -consistencyCheck LOGS_ONLY -enabled -encrypted -Name CI_EX_CLI_CENTRAL2         
                                                                                                                                                                 id                             : 3e709bac-a575-4660-b4a0-80b61bc3c832                                                                                            name                           : CI_EX_CLI_CENTRAL2                                                                                                              description                    :                                                                                                                                 
assetType                      : MICROSOFT_EXCHANGE_DATABASE
type                           : ACTIVE
targetStorageProvisionStrategy : AUTO_PROVISION
enabled                        : True
passive                        : False
forceFull                      : False
priority                       : 1
credentials                    : 
encrypted                      : True
dataConsistency                : APPLICATION_CONSISTENT
complianceInterval             : 
details                        : 
summary                        : @{numberOfAssets=0; totalAssetCapacity=0; totalAssetProtectionCapacity=0; numberOfJobFailures=0; numberOfSlaFailures=0; 
                                 numberOfSlaSuccess=0; lastExecutionStatus=IDLE}
stages                         : {@{id=dc394753-3f1a-4d7d-a3dc-610ef803a55e; type=PROTECTION; passive=False; retention=; target=; attributes=; 
                                 operations=System.Object[]}}
filterIds                      : {}
createdAt                      : 05.05.2021 05:03:39
updatedAt                      : 05.05.2021 05:03:39
slaId                          : 
_links                         : @{self=}

#>
function New-PPDMExchangeBackupPolicy {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [psobject]$Schedule,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    [ValidateLength(1, 150)][string]$Name,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    [ValidateLength(1, 150)][string]$StorageSystemID,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    [switch]$enabled,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    [switch]$encrypted, 
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    [string]$Description = '' ,  
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    $apiver = "/api/v2",
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [switch]$TroubleshootingDebug,

    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [string][ValidateSet("NONE",
      "ALL",
      "LOGS_ONLY",
      "DATABASE_ONLY")]$consistencyCheck,
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'selfservice')]
    [ValidateSet("YEAR",
      "MONTH",
      "WEEK",
      "DAY")]
    [string]$RetentionUnit,
    [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'selfservice')]
    [ValidateRange(1, 2555)][int]$RetentionInterval,    
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'selfservice')]
    [switch]$noop                  
  )
  begin {
    $Response = @()
    $METHOD = "POST"
  }     
  Process {

    $URI = "/protection-policies"
  
    switch ($pscmdlet.ParameterSetName ) {
      'centralized' { 
        $operations = @()

        $copyoperation = @{}
        $copyoperation.Add('schedule', $Schedule.CopySchedule)
        $copyoperation.Add('backupType', 'SYNTHETIC_FULL')         
        $copyoperation.Add('type', 'AUTO_FULL')         


        $fulloperation = @{}
        $fulloperation.Add('schedule', $Schedule.FullSchedule)
        $fulloperation.Add('backupType', 'FULL')         
        $fulloperation.Add('type', 'GEN0')         
          
        $operations += $copyoperation 
        $operations += $fulloperation 

        $exchange_options = @{
          'troubleShootingOption' = "debugEnabled=$($TroubleshootingDebug.IsPresent)"
          'consistencyCheck'      = $consistencyCheck
        }


        [switch]$passive = $false

      }
      Default {
        [switch]$passive = $true
        $exchange_options = @{}
        $schedule = @{}
        $schedule.add('Retention', @{})
        $schedule.Retention.add('interval', $RetentionInterval)
        $schedule.Retention.add('unit', $RetentionUnit)

      }
    }

    $Body = [ordered]@{ 
      'name'            = $Name
      'assetType'       = 'MICROSOFT_EXCHANGE_DATABASE'
      'credentials'     = $exchange_credentials
      'type'            = 'ACTIVE'
      'dataConsistency' = 'APPLICATION_CONSISTENT'
      'enabled'         = $enabled.IsPresent
      'description'     = $Description
      'encrypted'       = $encrypted.IsPresent
      'filterIds'       = @()
      'priority'        = 1
      'passive'         = $passive.IsPresent
      'forceFull'       = $false
      'details'         = $details
      'stages'          = @(
        @{
          'id'         = (New-Guid).Guid   
          'type'       = 'PROTECTION'
          'passive'    = $passive.IsPresent
          'attributes' = @{
            'exchange' = $exchange_options
          }                     
          'target'     = @{
            'storageSystemId' = $StorageSystemID
          }
          'operations' = $operations
          'retention'  = $Schedule.Retention
        }
      ) 
    } | convertto-json -Depth 7


        
    write-verbose ($body | out-string)
    $Parameters = @{
      body             = $body 
      Uri              = $URI
      Method           = $Method
      PPDM_API_BaseUri = $PPDM_API_BaseUri
      apiver           = $apiver
      Verbose          = $PSBoundParameters['Verbose'] -eq $true
    } 
    if (!$noop.IsPresent) {      
      try {
        $Response += Invoke-PPDMapirequest @Parameters
      }
      catch {
        Get-PPDMWebException  -ExceptionMessage $_
        break
      }
      write-verbose ($response | Out-String)
    } 
  } 
  end {    
    switch ($PsCmdlet.ParameterSetName) {
      default {
        write-output ($response | convertfrom-json)
      } 
    }   
  }
}

