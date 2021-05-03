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
<#
{
  "description": "The model representing the protection policy.",
  "properties": {
    "assetType": {
      "description": "The asset type that the protection policy protects. Valid values are the following:\n- VMAX_STORAGE_GROUP\n- VMWARE_VIRTUAL_MACHINE\n- ORACLE_DATABASE\n- MICROSOFT_SQL_DATABASE\n- FILE_SYSTEM\n- KUBERNETES\n- SAP_HANA_DATABASE\n- MICROSOFT_EXCHANGE_DATABASE",
      "enum": [
        "VMAX_STORAGE_GROUP",
        "VMWARE_VIRTUAL_MACHINE",
        "ORACLE_DATABASE",
        "MICROSOFT_SQL_DATABASE",
        "FILE_SYSTEM",
        "KUBERNETES",
        "SAP_HANA_DATABASE",
        "MICROSOFT_EXCHANGE_DATABASE"
      ],
      "type": "string",
      "x-ppdm-filter": "true",
      "x-ppdm-sort": "true"
    },
    "complianceInterval": {
      "description": "Compliance interval. For example, \"PT6H\" for 6 hours.",
      "type": "string",
      "x-ppdm-filter": "true",
      "x-ppdm-sort": "true"
    },
    "createdAt": {
      "description": "When the protection policy was created.",
      "format": "date-time",
      "type": "string",
      "x-ppdm-filter": "true",
      "x-ppdm-sort": "true"
    },
    "credentials": {
      "description": "Protection policy credential information.",
      "type": "object",
      "properties": {
        "id": {
          "description": "UUID of credential.",
          "type": "string"
        },
        "type": {
          "description": "Connection type.",
          "enum": [
            "OS",
            "VCENTER",
            "DBUSER",
            "DB_WALLET",
            "RMAN",
            "RMAN_WALLET",
            "DB",
            "SAPHANA_DB_USER",
            "SAPHANA_SYSTEMDB_USER"
          ],
          "type": "string"
        }
      }
    },
    "dataConsistency": {
      "description": "Data consistency selection on the protection policy. Valid values are the following:\n- CRASH_CONSISTENT\n- APPLICATION_CONSISTENT",
      "enum": [
        "CRASH_CONSISTENT",
        "APPLICATION_CONSISTENT"
      ],
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "description": {
      "description": "An optional description for the protection policy.",
      "type": "string",
      "x-ppdm-filter": "true",
      "x-ppdm-sort": "true"
    },
    "details": {
      "description": "Protection policy details information.",
      "type": "object",
      "properties": {
        "oracle": {
          "description": "Oracle related information on protection policy.",
          "type": "object",
          "properties": {
            "dbConnection": {
              "type": "object",
              "properties": {
                "tnsAdmin": {
                  "type": "string"
                },
                "tnsName": {
                  "type": "string"
                }
              }
            },
            "rmanConnection": {
              "type": "object",
              "properties": {
                "credentialId": {
                  "type": "string"
                },
                "tnsAdmin": {
                  "type": "string"
                },
                "tnsName": {
                  "type": "string"
                },
                "type": {
                  "enum": [
                    "OS",
                    "VCENTER",
                    "DBUSER",
                    "DB_WALLET",
                    "RMAN",
                    "RMAN_WALLET",
                    "DB",
                    "SAPHANA_DB_USER",
                    "SAPHANA_SYSTEMDB_USER"
                  ],
                  "type": "string"
                }
              }
            }
          }
        },
        "vm": {
          "description": "VM related information on protection policy.",
          "type": "object",
          "properties": {
            "metadataIndexingEnabled": {
              "description": "Enable or disable VM backup metadata indexing feature.",
              "type": "boolean"
            },
            "protectionEngine": {
              "description": "Protection engine type. Valid values are the following:\n- VMDIRECT\n-HYPERVISORDIRECT",
              "enum": [
                "VMDIRECT",
                "HYPERVISORDIRECT"
              ],
              "type": "string"
            }
          }
        }
      }
    },
    "enabled": {
      "description": "Indicates whether the protection policy is enabled or disabled.",
      "type": "boolean",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "encrypted": {
      "description": "VMware backup encryption setting.",
      "type": "boolean",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "filterIds": {
      "description": "IDs of exclusion filters that are associated with the protection policy.",
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "forceFull": {
      "description": "Deprecated.",
      "type": "boolean",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "id": {
      "description": "UUID of the protection policy.",
      "type": "string",
      "x-ppdm-filter": "true",
      "x-ppdm-sort": "true"
    },
    "name": {
      "description": "User customized name for the protection policy.",
      "maxLength": 150,
      "minLength": 1,
      "type": "string",
      "x-ppdm-filter": "true",
      "x-ppdm-sort": "true"
    },
    "passive": {
      "description": "Indicates whether the protection policy is passive or not.",
      "type": "boolean",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "priority": {
      "description": "Priority of the protection policy.",
      "exclusiveMinimum": false,
      "format": "int32",
      "minimum": 1,
      "type": "integer",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "slaId": {
      "description": "ID of associated service level agreement.",
      "type": "string",
      "x-ppdm-filter": "true",
      "x-ppdm-sort": "true"
    },
    "stages": {
      "type": "array",
      "items": {
        "description": "Protection policy stages information.",
        "required": [
          "id",
          "type",
          "passive"
        ],
        "type": "object",
        "properties": {
          "attributes": {
            "description": "Protection policy stage attributes.",
            "type": "object",
            "properties": {
              "cloudTier": {
                "description": "Cloud tier confiuration for the stage.",
                "type": "object",
                "properties": {
                  "cloudUnit": {
                    "description": "Cloud unit where the tier location is for cloud tier.",
                    "type": "object",
                    "properties": {
                      "id": {
                        "description": "Cloud unit ID.",
                        "type": "string"
                      },
                      "name": {
                        "description": "Cloud unit name.",
                        "type": "string"
                      }
                    }
                  },
                  "tierAfter": {
                    "description": "Time configuration when the cloud tier happens for the stage.",
                    "type": "object",
                    "properties": {
                      "interval": {
                        "description": "Time inverval used with unit.",
                        "format": "int32",
                        "type": "integer"
                      },
                      "unit": {
                        "description": "Time unit. Valid values are the following:\n- YEAR\n- MONTH\n- WEEK\n- DAY",
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
              },
              "exchange": {
                "description": "Exchange configuration for the stage.",
                "type": "object",
                "properties": {
                  "consistencyCheck": {
                    "description": "The Exchange consistency check for the database and transaction log files. Default is NONE. Supported enum:\n- NONE\n- ALL\n- LOGS_ONLY\n- DATABASE_ONLY",
                    "enum": [
                      "NONE",
                      "ALL",
                      "LOGS_ONLY",
                      "DATABASE_ONLY"
                    ],
                    "type": "string"
                  },
                  "troubleShootingOption": {
                    "description": "The troubleshooting option that is associated with this Exchange stage. For example: debugEnabled=true.",
                    "type": "string"
                  }
                }
              },
              "fileSystem": {
                "description": "File system configuration for the stage.",
                "type": "object",
                "properties": {
                  "troubleShootingOption": {
                    "description": "The troubleshooting option that is associated with this file system stage. For example: debugEnabled=true.",
                    "type": "string"
                  }
                }
              },
              "mssql": {
                "description": "Microsoft SQL (MSSQL) configuration for the stage.",
                "type": "object",
                "properties": {
                  "autoPromote": {
                    "description": "The backup auto promote option associated with this MSSQL stage.",
                    "type": "boolean"
                  },
                  "backUpExpirationDays": {
                    "description": "The backup expiration days associated with this MSSQL stage.",
                    "format": "int32",
                    "type": "integer"
                  },
                  "excludeSystemDatabase": {
                    "description": "The exclude system database associated with this MSSQL stage.",
                    "type": "boolean"
                  },
                  "parallelism": {
                    "description": "The parallel streams associated with this MSSQL stage.",
                    "format": "int32",
                    "type": "integer"
                  },
                  "troubleShootingOption": {
                    "description": "The troubleshooting option associated with this MSSQL stage. For example: debugEnabled=true.",
                    "type": "string"
                  }
                }
              },
              "oracle": {
                "description": "Oracle configuration for the stage.",
                "type": "object",
                "properties": {
                  "archiveLogDeletionDays": {
                    "description": "The archive log deletion days for this Oracle stage.",
                    "format": "int32",
                    "type": "integer"
                  },
                  "parallelism": {
                    "description": "The parallel streams that are associated with this Oracle stage.",
                    "format": "int32",
                    "type": "integer"
                  },
                  "troubleShootingOption": {
                    "description": "The troubleshooting option that is associated with this Oracle stage. For example: debugEnabled=true.",
                    "type": "string"
                  }
                }
              },
              "protection": {
                "description": "Dedicated configuration for protection stage only.",
                "type": "object",
                "properties": {
                  "backupMode": {
                    "enum": [
                      "FSS",
                      "VSS"
                    ],
                    "type": "string"
                  },
                  "forceFullRules": {
                    "description": "Force full conditions. Valid values are following:\n- VSO_NODE_FAILURE",
                    "type": "array",
                    "uniqueItems": true,
                    "items": {
                      "enum": [
                        "VSO_NODE_FAILURE"
                      ],
                      "type": "string"
                    }
                  }
                }
              },
              "sapHana": {
                "description": "SAP HANA configuration for the stage.",
                "type": "object",
                "properties": {
                  "troubleShootingOption": {
                    "description": "The troubleshooting option that is associated with this SAP HANA stage. For example: debugEnabled=true.",
                    "type": "string"
                  }
                }
              },
              "vm": {
                "description": "VM configuration for the stage.",
                "type": "object",
                "properties": {
                  "appConsistentProtection": {
                    "description": "The application-consistent protection associated with this virtual machine stage.",
                    "type": "boolean"
                  },
                  "dataMoverType": {
                    "enum": [
                      "INHERIT_FROM_POLICY",
                      "SDM",
                      "VADP"
                    ],
                    "type": "string",
                    "x-ppdm-filter": true,
                    "x-ppdm-sort": true
                  },
                  "disableQuiescing": {
                    "description": "Indicate whether to turn off the quiescing snapshot for VM backups, the default value is false. This option is available only for the primary backup stage of VM Crash Consistent policy.",
                    "type": "boolean"
                  },
                  "excludeSwapFiles": {
                    "description": "The exclude swap files setting associated with this virtual machine stage.",
                    "type": "boolean"
                  }
                }
              },
              "vmax": {
                "description": "VMax configuration for the stage.",
                "type": "object",
                "properties": {
                  "postSnapshotFileName": {
                    "description": "The postSnapshotFileName of Vmax.",
                    "type": "string"
                  },
                  "preSnapshotFileName": {
                    "description": "The preSnapshotFileName of Vmax.",
                    "type": "string"
                  }
                }
              }
            }
          },
          "id": {
            "description": "UUID of stage in protection policy.",
            "type": "string"
          },
          "operations": {
            "type": "array",
            "uniqueItems": true,
            "items": {
              "description": "Protection policy stage operation configuration.",
              "type": "object",
              "properties": {
                "backupType": {
                  "description": "Operation type. Valid values are the following:\n- FULL\n- DIFFERENTIAL\n- LOG\n- INCREMENTAL\n- CUMULATIVE\n- SYNTHETIC_FULL",
                  "enum": [
                    "FULL",
                    "DIFFERENTIAL",
                    "LOG",
                    "INCREMENTAL",
                    "CUMULATIVE",
                    "SYNTHETIC_FULL"
                  ],
                  "type": "string"
                },
                "schedule": {
                  "type": "object",
                  "properties": {
                    "dayOfMonth": {
                      "format": "int32",
                      "type": "integer"
                    },
                    "duration": {
                      "type": "string"
                    },
                    "frequency": {
                      "enum": [
                        "MINUTELY",
                        "HOURLY",
                        "DAILY",
                        "WEEKLY",
                        "MONTHLY",
                        "YEARLY"
                      ],
                      "type": "string"
                    },
                    "genericDay": {
                      "enum": [
                        "FIRST",
                        "LAST"
                      ],
                      "type": "string"
                    },
                    "interval": {
                      "format": "int32",
                      "type": "integer"
                    },
                    "month": {
                      "enum": [
                        "JANUARY",
                        "FEBRUARY",
                        "MARCH",
                        "APRIL",
                        "MAY",
                        "JUNE",
                        "JULY",
                        "AUGUST",
                        "SEPTEMBER",
                        "OCTOBER",
                        "NOVEMBER",
                        "DECEMBER"
                      ],
                      "type": "string"
                    },
                    "startTime": {
                      "format": "date-time",
                      "type": "string"
                    },
                    "weekDays": {
                      "type": "array",
                      "uniqueItems": true,
                      "items": {
                        "enum": [
                          "SUNDAY",
                          "MONDAY",
                          "TUESDAY",
                          "WEDNESDAY",
                          "THURSDAY",
                          "FRIDAY",
                          "SATURDAY"
                        ],
                        "type": "string"
                      }
                    },
                    "weekOfMonth": {
                      "type": "integer"
                    }
                  }
                },
                "type": {
                  "description": "Operation type. Valid values are the following:\n- FULL\n- DIFFERENTIAL\n- LOG\n- INCREMENTAL\n- CUMULATIVE\n- AUTO_FULL",
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
            }
          },
          "options": {
            "description": "Free-form policy stage options in JSON",
            "type": "object",
            "properties": {
              "promotionType": {
                "description": "SQL pass thru Option: \nRepresents the backup promotion type when backupLevel is LOG/DIFF_INCR . \n\"ALL\": \tPromote any database that is not eligible for LOG/DIFF backup to a FULL backup. \n\n\"NONE\": \tSkip any database that is not eligible for LOG/DIFF backup.\n\n\"NONE_WITH_WARNINGS\": \tSkip any database that is not eligible for LOG/DIFF backup but provide user a warning.  Warning is provided in the return value.\n\nDefault behavior for SQL AppAgent if promotionType is not supplied is to use \"ALL\"",
                "enum": [
                  "ALL",
                  "NONE",
                  "NONE_WITH_WARNINGS"
                ],
                "type": "string"
              },
              "skipSimpleDatabase": {
                "description": "SQL pass thru option:\nThe backup promotion behavior for database in SIMPLE recovery model when backupLevel is LOG.\n\nfalse: \tPromote  backup to FULL for database in SIMPLE recovery model if backupLevel specified is LOG.\n\ntrue: \tSkip backup of database in SIMPLE recovery model if backupLevel specified is LOG.\n",
                "type": "boolean"
              }
            }
          },
          "passive": {
            "type": "boolean",
            "x-ppdm-deprecated": true
          },
          "retention": {
            "description": "Protection policy copy retention.",
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
              "storageSystemRetentionLock": {
                "description": "Enable or disable storage system retention lock.",
                "type": "boolean"
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
          },
          "slaId": {
            "description": "ID of associated service level agreement.",
            "type": "string"
          },
          "sourceStageId": {
            "description": "Id of Source Stage",
            "type": "string"
          },
          "target": {
            "description": "Data target storage system information for the stage.",
            "required": [
              "storageSystemId"
            ],
            "type": "object",
            "properties": {
              "dataTargetId": {
                "description": "UUID of data target location in storage system.",
                "type": "string"
              },
              "hardCapacityQuotaLevel": {
                "description": "Hard capacity quota level.",
                "format": "int64",
                "type": "integer",
                "x-ppdm-deprecated": true
              },
              "hardStreamQuotaLevel": {
                "description": "Hard stream quota level.",
                "format": "int64",
                "type": "integer",
                "x-ppdm-deprecated": true
              },
              "preferredInterface": {
                "description": "Preferred connection interface of the storage system. For example: IP address.",
                "type": "string"
              },
              "softCapacityQuotaLevel": {
                "description": "Soft capacity quota level.",
                "format": "int64",
                "type": "integer",
                "x-ppdm-deprecated": true
              },
              "softStreamQuotaLevel": {
                "description": "Soft stream quota level.",
                "format": "int64",
                "type": "integer",
                "x-ppdm-deprecated": true
              },
              "storageSystemId": {
                "description": "UUID of storage system.",
                "type": "string"
              }
            }
          },
          "type": {
            "description": "Type of stage. Valid values are the following:\n- PRIMARY\n- PROTECTION\n- PROMOTION\n- REPLICATION\n- CLOUD_TIER\n- CDR",
            "enum": [
              "PRIMARY",
              "PROTECTION",
              "PROMOTION",
              "REPLICATION",
              "CLOUD_TIER",
              "CDR"
            ],
            "type": "string"
          }
        }
      }
    },
    "summary": {
      "description": "Protection policy summary statistics.",
      "type": "object",
      "properties": {
        "lastExecutionStatus": {
          "description": "The last execution status for the protection policy.\n- SUCCEEDED\n- FAILED\n- CANCELLED\n- COMPLETED_WITH_EXCEPTIONS\n- IDLE",
          "enum": [
            "SUCCEEDED",
            "FAILED",
            "CANCELLED",
            "COMPLETED_WITH_EXCEPTIONS",
            "IDLE"
          ],
          "type": "string"
        },
        "numberOfAssets": {
          "description": "Number of assets included in the protection policy.",
          "format": "int64",
          "readOnly": true,
          "type": "integer"
        },
        "numberOfJobFailures": {
          "description": "Number of job failures for the protection policy in the last 24 hours.",
          "format": "int64",
          "readOnly": true,
          "type": "integer"
        },
        "numberOfSlaFailures": {
          "description": "Number of service level agreement compliance failures for the protection policy in the last 24 hours.",
          "format": "int64",
          "readOnly": true,
          "type": "integer"
        },
        "numberOfSlaSuccess": {
          "description": "Number of service level agreement compliance successes for the protection policy in the last 24 hours.",
          "format": "int64",
          "readOnly": true,
          "type": "integer"
        },
        "totalAssetCapacity": {
          "description": "Total capacity of assets included in the protection policy.",
          "format": "double",
          "type": "number"
        },
        "totalAssetProtectionCapacity": {
          "description": "Total protection capacity of assets included in the protection policy.",
          "format": "double",
          "type": "number"
        }
      }
    },
    "targetStorageProvisionStrategy": {
      "description": "To indicate if this protection policy is greenfield or brownfield, possible values:\n- USE_CONFIGURED  - Means mark as brownfield.\n- AUTO_PROVISION  - Means mark as greenfield. (default value)",
      "enum": [
        "AUTO_PROVISION",
        "USE_CONFIGURED"
      ],
      "type": "string",
      "x-ppdm-filter": "true",
      "x-ppdm-sort": "true"
    },
    "type": {
      "description": "The protection policy type. Valid values are the following:\n- ACTIVE\n- EXCLUDED",
      "enum": [
        "ACTIVE",
        "EXCLUDED"
      ],
      "type": "string",
      "x-ppdm-filter": "true",
      "x-ppdm-sort": "true"
    },
    "updatedAt": {
      "description": "When the protection policy was updated.",
      "format": "date-time",
      "type": "string",
      "x-ppdm-filter": "true",
      "x-ppdm-sort": "true"
    }
  },
  "required": [
    "id",
    "name",
    "assetType",
    "type",
    "enabled",
    "priority",
    "encrypted"
  ],
  "type": "object"
}


#>



<#
.SYNOPSIS
Creates a Primary Backup Policy for Virtual Machines.

Primary Backup Copy can be hourly, daily, weekly, monthly

Full CLones can be weekly or monthly
.Example
Create a weekly Copy Backup every Monday and Thursday

New-PPDMVMPrimaryBackupPolicy -Name $(Get-Random) -StorageSystemID ed9a3cd6-7e69-4332-a299-aaf258e23328 -RetentionUnit DAY -RetentionInterval 5 -enabled -startime 18:00  -weekly -CreateCopyDays MONDAY,THURSDAY

id                             : 6e06ecbd-78a6-49e7-b403-0e5540e13c70
name                           : 489680489
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
summary                        : @{numberOfAssets=0; totalAssetCapacity=0; totalAssetProtectionCapacity=0; numberOfJobFailures=0; numberOfSlaFailures=0; numberOfSlaSuccess=0; lastExecutionStatus=IDLE}
stages                         : {@{id=15d1f564-c001-4e50-9693-c52076f7cfeb; type=PROTECTION; passive=False; retention=; target=; attributes=; operations=System.Object[]}}
filterIds                      :
createdAt                      : 30.04.2021 17:47:06
updatedAt                      : 30.04.2021 17:47:06
slaId                          :
_links                         : @{self=}

.Example
Create a Monthly Copy Backup every 4th Friday, Clone every 12 Days

New-PPDMVMPrimaryBackupPolicy -Name $(Get-Random) -StorageSystemID ed9a3cd6-7e69-4332-a299-aaf258e23328 -RetentionUnit WEEK -RetentionInterval 7 -startime 18:00   -monthly_day_of_week_w_full_monthly -CreateFull_Every_DayofMonth 12 -CreateCopyDayofWeek FRIDAY -CreateCopyWeekofMonth 4

id                             : dd2dcc43-f039-46b8-8d6c-3f4b5836990b
name                           : 1474727548
description                    :
assetType                      : VMWARE_VIRTUAL_MACHINE
type                           : ACTIVE
targetStorageProvisionStrategy : AUTO_PROVISION
enabled                        : False
passive                        : False
forceFull                      : False
priority                       : 1
credentials                    :
encrypted                      : False
dataConsistency                : CRASH_CONSISTENT
complianceInterval             :
details                        : @{vm=}
summary                        : @{numberOfAssets=0; totalAssetCapacity=0; totalAssetProtectionCapacity=0; numberOfJobFailures=0; numberOfSlaFailures=0; numberOfSlaSuccess=0; lastExecutionStatus=IDLE}
stages                         : {@{id=4f6ac65b-3555-4fbd-b1c8-306ef2801a14; type=PROTECTION; passive=False; retention=; target=; attributes=; operations=System.Object[]}}
filterIds                      :
createdAt                      : 30.04.2021 17:39:53
updatedAt                      : 30.04.2021 17:39:53
slaId                          :
_links                         : @{self=}


#>
function New-PPDMVMPrimaryBackupPolicy {
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
    [ValidateLength(1, 150)][string]$Name,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'hourly_')]                        
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'hourly_w_full_weekly')] 
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'hourly_w_full_monthly')]  
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'daily_')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'daily_w_full_weekly')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'daily_w_full_monthly')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'weekly_')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'weekly_w_full_weekly')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_w_full_monthly')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_w_full_monthly')]
    [ValidateLength(1, 150)][string]$StorageSystemID,

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
    [string][ValidateSet('FSS', 'VSS')]$backupMode = 'VSS',
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
    [switch]$excludeSwapFiles,
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
    [switch]$disableQuiescing,    
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
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'weekly_w_full_monthly')]                   
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlyday_w_full_monthly')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'monthlydayofweek_w_full_monthly')]
    [switch]$enabled,
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
    [DateTime]$startime = "8:00PM",
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
    [DateTime]$endtime = "8:00AM",
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
    [switch]$encrypted, 
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
    [string]$Description = '' ,
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
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
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
    $apiver = "/api/v2",
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
    [switch]$noop           
  )
  begin {
    $Response = @()
    $METHOD = "POST"
  }     
  Process {

    $URI = "/protection-policies"
  
    $operations = @()
    $copyoperation = @{
      'schedule' = @{
        'duration'  = "PT$(($starttime - $endtime).Hours)H"
        'startTime' = $(Get-DAte $starttime -Format yyyy-MM-ddThh:mm:ss.000Z)
      }            
    }
    $copyoperation.Add('backupType', 'SYNTHETIC_FULL')         

    $fulloperation = @{
      'backupType' = 'FULL'
      'schedule'   = @{
        'duration'  = "PT$(($starttime - $endtime).Hours)H"
        'startTime' = $(Get-DAte $starttime -Format yyyy-MM-ddThh:mm:ss.000Z)
      }            
    }        
    switch (($($PSCmdlet.ParameterSetName) -split "_")[0]) {
      'hourly' {
        $copyoperation.schedule.Add('frequency', 'HOURLY')
        $copyoperation.schedule.Add('interval', $CreateCopyIntervalHrs)
        $operations += $copyoperation                         
      }
      'daily' {
        $copyoperation.schedule.Add('frequency', 'DAILY')
        $operations += $copyoperation                    
      } 
      'weekly' {
        $copyoperation.schedule.Add('frequency', 'WEEKLY')
        $copyoperation.schedule.Add('weekDays', @($CreateCopyDays))
        $operations += $copyoperation                    
      }
      'monthlyday' {
        $copyoperation.schedule.Add('frequency', 'MONTHLY')
        $copyoperation.schedule.Add('dayOfMonth', $CreateCopydayofMonth)
        $operations += $copyoperation 
      }
              
      'monthlydayofweek' {
        $copyoperation.schedule.Add('frequency', 'MONTHLY')
        $copyoperation.schedule.Add('weekDays', @($CreateCopyDayofWeek))
        If ($CreateCopyWeekofMonth) {
          $copyoperation.schedule.Add('weekOfMonth', $CreateCopyWeekofMonth)    
        }
        else {
          $copyoperation.schedule.Add('genericDay', 'LAST')    
        }
        $operations += $copyoperation 
      }                      
    }



    switch (($($PSCmdlet.ParameterSetName) -split "_w")[1]) {

      'full_weekly' {
        $copyoperation.Add('backupType', 'SYNTHETIC_FULL')         
        $operations += $copyoperation                
        $fulloperation.schedule.Add('frequency', 'WEEKLY')
        $fulloperation.schedule.Add('weekDays', @($CreateFull_Every_DayofWeek))
        $operations += $fulloperation
                
      }
      'full_monthly' {
        $copyoperation.Add('backupType', 'SYNTHETIC_FULL')         
        $operations += $copyoperation   
        $fulloperation.schedule.Add('frequency', 'MONTHLY')
        $fulloperation.schedule.Add('dayOfMonth', $CreateFull_Every_DayofMonth)
        $operations += $fulloperation
      }            
    } 
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
          'retention'  = @{
            'interval' = $RetentionInterval
            'unit'     = $RetentionUnit
          }
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




function New-PPDMprotection_policies {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $True, ValueFromPipeline = $false)]
    [ValidateLength(1, 150)][string]$Name,
    [Parameter(Mandatory = $True, ValueFromPipeline = $false)]
    [ValidateLength(1, 150)][string]$StorageSystemID,        
    [Parameter(Mandatory = $True, ValueFromPipeline = $false)]
    [ValidateSet('VMAX_STORAGE_GROUP',
      'VMWARE_VIRTUAL_MACHINE',
      'ORACLE_DATABASE',
      'MICROSOFT_SQL_DATABASE',
      'FILE_SYSTEM',
      'KUBERNETES',
      'SAP_HANA_DATABASE',
      'MICROSOFT_EXCHANGE_DATABASE'
    )]
    $assetType,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
    [ValidateSet('CRASH_CONSISTENT',
      'APPLICATION_CONSISTENT' )]
    $dataConsistency = 'CRASH_CONSISTENT',
    [Parameter(Mandatory = $true, ValueFromPipeline = $false)]
    [switch]$enabled,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
    [DateTime]$startime = "8:00PM",
    [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
    [DateTime]$endtime = "6:00AM",
    [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
    [switch]$passive,  
    [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
    [switch]$encrypted, 
    [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
    [switch]$forceFull,
    [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
    [string]$Description = '' ,
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
    Write-Verbose "Casting Time"
    $RunTime = $startime - $endtime     

    switch ($assetType) {
      'VMWARE_VIRTUAL_MACHINE' {
        $Body = [ordered]@{ 
          'name'            = $Name
          'assetType'       = $assetType
          'type'            = 'ACTIVE'
          'dataConsistency' = $dataConsistency
          'enabled'         = $enabled.IsPresent
          'description'     = $Description
          'encrypted'       = $encrypted.IsPresent
          'priority'        = 1
          'passive'         = $passive.IsPresent
          'forceFull'       = $forceFull.IsPresent
          'details'         = @{
            'vm' = @{
              'protectionEngine' = 'VMDIRECT'
            }
          }
          'stages'          = @(
            @{
              'id'         = (New-Guid).Guid   
              'type'       = 'PROTECTION'
              'passive'    = $passive.IsPresent
              'target'     = @{
                'storageSystemId' = $StorageSystemID
              }
              'operations' = @(
                @{
                  'backupType' = 'SYNTHETIC_FULL'
                  'schedule'   = @{
                    'frequency'  = 'monthly_'
                    'duration'   = "PT$(($starttime - $endtime).Hours)H"
                    'dayOfMonth' = 1
                    'startTime'  = $(Get-DAte $starttime -Format yyyy-MM-ddThh:mm:ss.000Z)
                  }
                }
              )
              'retention'  = @{
                'interval' = 1
                'unit'     = 'MONTH'
              }
            }
          ) 
        } | convertto-json -Depth 7
      }
      default {
        write-host "Not jet implemented"
        return
      }
    }
        
    write-verbose ($body | out-string)
    $Parameters = @{
      body             = $body 
      Uri              = "/$Myself"
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
      default {
        write-output ($response | convertfrom-json)
      } 
    }   
  }
}


<#
"schedule": {
    "type": "object",
    "properties": {
      "dayOfMonth": {
        "format": "int32",
        "type": "integer"
      },
      "duration": {
        "type": "string"
      },
      "frequency": {
        "enum": [
          "MINUTELY",
          "HOURLY",
          "DAILY",
          "WEEKLY",
          "MONTHLY",
          "YEARLY"
        ],
        "type": "string"
      },
      "genericDay": {
        "enum": [
          "FIRST",
          "LAST"
        ],
        "type": "string"
      },
      "interval": {
        "format": "int32",
        "type": "integer"
      },
      "month": {
        "enum": [
          "JANUARY",
          "FEBRUARY",
          "MARCH",
          "APRIL",
          "MAY",
          "JUNE",
          "JULY",
          "AUGUST",
          "SEPTEMBER",
          "OCTOBER",
          "NOVEMBER",
          "DECEMBER"
        ],
        "type": "string"
      },
      "startTime": {
        "format": "date-time",
        "type": "string"
      },
      "weekDays": {
        "type": "array",
        "uniqueItems": true,
        "items": {
          "enum": [
            "SUNDAY",
            "MONDAY",
            "TUESDAY",
            "WEDNESDAY",
            "THURSDAY",
            "FRIDAY",
            "SATURDAY"
          ],
          "type": "string"
        }
      },
      "weekOfMonth": {
        "type": "integer"
      }
    }
  },
  "type": {
    "description": "Operation type. Valid values are the following:\n- FULL\n- DIFFERENTIAL\n- LOG\n- INCREMENTAL\n- CUMULATIVE\n- AUTO_FULL",
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
}
}#>


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



function Remove-PPDMProtection_policy_assignment {
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

    $URI = "/protection-policies/$ID/asset-unassignments"
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

