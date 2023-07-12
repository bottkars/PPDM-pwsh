### storage
# /api/v2/data-targets

function Get-PPDMdata_targets {
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
# Storage Targets
# /api/v2/storage-systems
function Get-PPDMstorage_systems {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'Type', ValueFromPipelineByPropertyName = $true)]
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
    [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    [string]$ID,
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
      'byID' {
        $URI = "/$myself/$ID"
      }
      default {
        $URI = "/$myself"
      }
      'TYPE' {
        $URI = "/$myself"
        if ($filter) {
          $filter = 'type eq "' + $type + '" and ' + $filter 
        }
        else {
          $filter = 'type eq "' + $type + '"'
        }
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
      write-verbose $filter
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

# Storage Targets
# /api/v2/storage-systems
function Set-PPDMstorage_systems {
  [CmdletBinding()]
  param(

    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [Array]$Storage_Configuration,        
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
    $body = $Storage_Configuration | convertto-json -Depth 10
    switch ($PsCmdlet.ParameterSetName) {
      default {
        $URI = "/$myself/$($Storage_Configuration.id)"            
      }
    }
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
      default {
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