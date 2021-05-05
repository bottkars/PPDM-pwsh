function Get-PPDMprotection_policies {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    $id,
    [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [switch]$asset_assignments,
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
        if ($asset_assignments.IsPresent) {
          $URI = "$URI/asset-assignments"
        }    
      }
      default {
        $URI = "/$myself"
      }
    } 
    $Parameters = @{
      body             = $body 
      Uri              = $URI
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
        if ( $asset_assignments.IsPresent ) {
          write-output ($response | convertfrom-json).content
        }
        else {
          write-output $response | convertfrom-json
        }            
      }
      default {
        write-output ($response | convertfrom-json).content
      } 
    }   
  }
}
# /api/v2/protection-policies/{id}/asset-assignments

# post/api/v2/protection-policies/{id}/protections
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
      $PolicyID = $Policy.id
    }

    }    
    $Body = [ordered]@{
      'assetIds' = $AssetIDs
      'stages'   = @(
        @{
        'id'         = $StageID  
        'operation' = @{
          'backupType' = $BackupType
        }  
        'retention'  = @{
          'interval' = $RetentionInterval
          'unit'     = $RetentionUnit
        }
      } )
    } | convertto-json -Depth 3
    write-verbose ($body | out-string)
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

<# {
  "description": "Manual protection at the protection policy level.",
  "properties": {
    "assetIds": {
      "description": "The list of asset IDs for manual backup.\nIf the asset ID list is not empty, the listed assets for manual backup come from the same protection policy (the one that is specified).\nIf the asset list is null or empty, the manual backup occurs for all assets in the specified protection policy.",
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "stages": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string"
          },
          "operation": {
            "description": "operation which include backup type info for adhoc protection",
            "type": "object",
            "properties": {
              "backupType": {
                "description": "Detailed backup type for adhoc protection",
                "enum": [
                  "FULL",
                  "DIFFERENTIAL",
                  "LOG",
                  "INCREMENTAL",
                  "CUMULATIVE",
                  "AUTO_FULL",
                  "SYNTHETIC_FULL",
                  "GEN0"
                ],
                "type": "string"
              }
            }
          },
          "retention": {
            "description": "Protection policy copy retention time.",
            "required": [
              "interval",
              "unit"
            ],
            "type": "object",
            "properties": {
              "interval": {
                "description": "Retention interval. Used with unit.",
                "format": "int32",
                "minimum": 1,
                "type": "integer"
              },
              "unit": {
                "description": "Retention interval unit. Valid values are the following:\n- DAY\n- WEEK\n- MONTH\n- YEAR",
                "enum": [
                  "YEAR",
                  "MONTH",
                  "WEEK",
                  "DAY"
                ],
                "type": "string"
              }
            }
          }
        }
      }
    }
  },
  "type": "object"
}
#>
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
      body             = $body 
      Uri              = "/$Myself/$PolicyID/backups"
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
        write-output ($response | convertfrom-json)
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



function Remove-PPDMProtection_policy_assignment {
  [CmdletBinding()]
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

