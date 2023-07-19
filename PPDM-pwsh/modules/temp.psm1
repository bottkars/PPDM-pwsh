function New-PPDMORACLEBackupPolicy {
    [CmdletBinding()]
    param(

      [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
      [psobject]$Schedule,
      [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
      [string]$dbCID,

      [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'centralized')]
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
        { $_ -eq 'centralized' <# -or $_ -eq 'applicationDirect'#> } { 
          $operations = @()
          $copyoperation = @{}
          $copyoperation.Add('schedule', $Schedule.CopySchedule)
          $copyoperation.Add('backupType', 'FULL')         
          $operations += $copyoperation 
          $ora_credentials = @{
            'id'   = $dbCID
            'type' = 'OS'
          }
          if ($schedule.differentialSchedule) {
            $operations += $schedule.differentialSchedule   
          }
          if ($schedule.logSchedule) {
            $operations += $schedule.logSchedule   
          }
          [switch]$passive = $false
          $Stages = @{}
          $stages.Add('id', (New-Guid).Guid) 
          $stages.Add('type', 'PROTECTION')
          $stages.Add('passive', $passive.IsPresent)
          $stages.Add('attributes', @{})
          $Stages.attributes.Add('protection', @{})
          $Stages.attributes.protection.Add('backupMechanism', 'SBT')
          $Stages.attributes.Add('oracle', @{})
          $Stages.attributes.oracle.Add('troubleShootingOption', 'debugEnabled=false')
          $Stages.Add('target', @{})
          $Stages.Target.Add('storageSystemId', $StorageSystemID)
          $Stages.Add('operations' , $operations)
          $Stages.Add('retention'  , $Schedule.Retention)
        }
        'selfservice' { # to be implementzed
          [switch]$passive = $true
          $mssql_options = @{}
          $schedule = @{}
          $schedule.add('Retention', @{})
          $schedule.Retention.add('interval', $RetentionInterval)
          $schedule.Retention.add('unit', $RetentionUnit)
          $stages = @{
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
        }
      }
      if ($applicationDirect.IsPresent) {

  
      }
      else {
        $AssetType = 'ORACLE_DATABASE'
        $details = @{}
        $details.Add('oracle', @{}) 
        $details.oracle.dbConnection.Add('tnsName', '') 
        $details.oracle.dbConnection.Add('tnsAdmin', '') 
      }
      $Body = [ordered]@{
        'assetType'       = $AssetType
        'name'            = $Name
        'credentials'     = $ora_credentials
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
        'stages'          = @($stages)
         
      } 

      $Body = $Body  | convertto-json -Depth 7
  
  
          
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
  