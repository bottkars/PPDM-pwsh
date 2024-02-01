<#
{
  "description": "Restored copies REST model.",
  "properties": {
    "activityId": {
      "description": "The activity ID for the restore activity. Activity could be Task, Job, or JobGroup.",
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "completionTime": {
      "description": "Restoration completion time.",
      "format": "date-time",
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "copyId": {
      "description": "ID of copy to be restored.",
      "type": "string",
      "x-ppdm-deprecated": true,
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "copyIds": {
      "description": "IDs of copy to be restored.",
      "type": "array",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true,
      "items": {
        "type": "string"
      }
    },
    "description": {
      "description": "Description of particular restored copy.",
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "expirationTime": {
      "description": "When the restore is expired, VMDM service involves the restore session to remove (cleanup) its NAS datastore and resource.",
      "format": "date-time",
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "id": {
      "description": "UUID of particular restored copy.",
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "options": {
      "description": "Agent free-form JSON key pair options.\n",
      "type": "object",
      "properties": {
        "allowOverwrite": {
          "description": "Indicate the strategy recovery will use to handle conflict of the contents in the destination NAS Server/Folder. the value must be either 'false' or 'true",
          "type": "string"
        },
        "disconnectDatabaseUsers": {
          "description": "Microsoft SQL Server requires that there are no database user connections when starting a database restore.\nThis option will automatically disconnect any active database users prior to restoring the database.\n- false: do not disconnect active database users from database prior to starting a database restore.\n- true: disconnect active database users prior to starting a database restore.",
          "type": "boolean"
        },
        "enableCompressedRestore": {
          "description": "DD Boost compressed restore improves backup read performance by using data compression techniques.\nThis option enables DD Boost compressed restore to improve DD Boost backup read performance.\n\nWhen set to false, the application agent does not enable DD Boost compressed restore.\n\nWhen set to true, the application agent enables DD Boost compressed restore.",
          "type": "boolean"
        },
        "enableDebug": {
          "description": "SQL Pass thru field:\nindicates if debug log should be enabled for the agent or not.",
          "type": "boolean"
        },
        "fileRelocationOptions": {
          "description": "SQL Pass thru field:\nDefines the file relocation options for restore",
          "type": "object",
          "properties": {
            "targetDataFileLocation": {
              "description": "The target file path where all database data files will be relocated during the restore which should have a valid file system path when  fileRelocationType is \"CUSTOM_LOCATION\".",
              "type": "string"
            },
            "targetLogFileLocation": {
              "description": "The target file path where all database log files will be relocated during the restore which should have a validate file system path when fileRelocationType is \"CUSTOM_LOCATION\"",
              "type": "string"
            },
            "type": {
              "description": "ORIGINAL_LOCATION:\tThis indicates that the database is being restored to the original location\nDEFAULT_LOCATION:\tIndicates the user is restoring the database to an alternate location and has specified to restore the database to the default data and log file paths of the target instance specified.\nCUSTOM_LOCATION:\tIndicates the user is restoring the database to an alternate location and has specified to restore the database to the default data and log file paths specified.",
              "enum": [
                "ORIGINAL_LOCATION",
                "DEFAULT_LOCATION",
                "CUSTOM_LOCATION"
              ],
              "type": "string"
            }
          }
        },
        "forceDatabaseOverwrite": {
          "description": "SQL Pass thru field:\nindicates the database should be overwritten by the restore, which specifies the \"FORCE\" flag for T-SQL RESTORE statement.",
          "type": "boolean"
        },
        "performTailLogBackup": {
          "description": "SQL Pass thru field:\nindicates if tail log backup should be performed.\n",
          "type": "boolean"
        },
        "recoveryState": {
          "description": "SQL Pass thru field.\nIf not specified, application assumes default is \"RECOVERY\".",
          "enum": [
            "RECOVERY",
            "NO_RECOVERY"
          ],
          "type": "string"
        },
        "restoreOriginalMachineConfig": {
          "description": "The field for Cloud DR restore , that marks if set originar MAC id of restored VM",
          "type": "boolean"
        },
        "stopAtTime": {
          "description": "SQL Pass thru field:\n\nThe time when SQL should stop rolling forward transactions for the TLOG backup being restored.",
          "type": "string"
        },
        "vcenterId": {
          "description": "The vcenter ID for Cloud DR restore.",
          "type": "string"
        }
      }
    },
    "restoreEntireBackupTransaction": {
      "description": "Restore all copies that have the same backup transaction ID (backupTransactionId).",
      "type": "boolean"
    },
    "restoreType": {
      "description": "Restore operation type of particular restored copy.",
      "enum": [
        "INSTANT_ACCESS",
        "IR_TO_PRODUCTION",
        "IR_TO_ALTERNATE",
        "TO_PRODUCTION",
        "TO_ALTERNATE",
        "TO_EXISTING",
        "DIRECT_TO_ESX",
        "TO_CLOUD",
        "TO_EXPORT",
        "TO_FLR",
        "TO_MOUNT"
      ],
      "type": "string"
    },
    "restoredCopiesDetails": {
      "description": "Restored copies details.",
      "type": "object",
      "x-ppdm-filter": false,
      "x-ppdm-sort": false,
      "properties": {
        "targetCloudInfo": {
          "type": "object",
          "properties": {
            "drType": {
              "type": "string"
            },
            "networkId": {
              "type": "string"
            },
            "securityGroupIds": {
              "type": "array",
              "items": {
                "type": "string"
              }
            }
          }
        },
        "targetDatabaseInfo": {
          "description": "The container for database-specific attributes.",
          "type": "object",
          "properties": {
            "applicationSystemId": {
              "type": "string"
            },
            "assetName": {
              "type": "string"
            },
            "hostId": {
              "type": "string"
            }
          }
        },
        "targetFileSystemInfo": {
          "required": [
            "location"
          ],
          "type": "object",
          "properties": {
            "conflictStrategy": {
              "description": "Indicate the strategy recovery will use to handle conflict of the contents in the destination directory.",
              "enum": [
                "OVERWRITE",
                "TO_ALTERNATE"
              ],
              "type": "string"
            },
            "hostId": {
              "type": "string"
            },
            "location": {
              "type": "string"
            },
            "mountUrl": {
              "type": "string"
            },
            "sources": {
              "type": "array",
              "items": {
                "type": "string"
              }
            }
          }
        },
        "targetK8sInfo": {
          "description": "The container for Kubernetes-specific attributes.",
          "type": "object",
          "x-ppdm-filter": false,
          "x-ppdm-sort": false,
          "properties": {
            "namespace": {
              "description": "The alternate namespace name for Restore to New.\n\nNote: If restoreType==TO_PRODUCTION (Restore to Original), the value of this field is ignored.",
              "type": "string",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "overwritePersistentVolumeClaim": {
              "description": "Boolean to indicate if persistent volume claim contents should be overwritten if they exist.\n\nIf it is true, existing persistent volume claim contents are overwritten.",
              "type": "boolean",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "persistentVolumeClaims": {
              "description": "List of persistent volume claims to be restored. Each entry in the list is the asset name pointing to a Kubernetes persistent volume claim asset.",
              "type": "array",
              "x-ppdm-filter": false,
              "x-ppdm-sort": false,
              "items": {
                "type": "object",
                "properties": {
                  "alternateStorageClass": {
                    "description": "The alternate storage class to be used.",
                    "type": "string"
                  },
                  "name": {
                    "description": "The name of the persistent volume claim.",
                    "type": "string",
                    "x-ppdm-filter": true,
                    "x-ppdm-sort": true
                  }
                }
              }
            },
            "skipNamespaceResources": {
              "description": "Boolean to indicate whether namespace resources will be restored.\n\nIf it is true, it means to not restore namespace resources.",
              "type": "boolean",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            },
            "targetInventorySourceId": {
              "description": "The target cluster inventory source id where the restore will  begin.",
              "type": "string",
              "x-ppdm-filter": true,
              "x-ppdm-sort": true
            }
          }
        },
        "targetNasInfo": {
          "description": "NAS specific patameters for restore copies",
          "type": "object",
          "properties": {
            "assetId": {
              "description": "Asset Id of the destination NAS share in case of restore to alternate",
              "type": "string"
            },
            "sources": {
              "description": "Sources selected files/folders for file-level recovery",
              "type": "array",
              "items": {
                "description": "Selected sources for file level restore for NAS",
                "type": "object",
                "properties": {
                  "path": {
                    "description": "File/folder path for file-level recovery",
                    "type": "string"
                  },
                  "pathHash": {
                    "description": "Hash of the full path of the file / folder. the hash can be got by search index.",
                    "type": "string"
                  },
                  "sliceSsid": {
                    "description": "SSID of file/folder for file-level recovery, the field can be got by search index.",
                    "type": "string"
                  },
                  "type": {
                    "description": "Type of sources selected files/folder for file-level recovery. Enum: FOLDER, FILE",
                    "enum": [
                      "FOLDER",
                      "FILE"
                    ],
                    "type": "string"
                  }
                }
              }
            }
          }
        },
        "targetStorageInfo": {
          "type": "object",
          "properties": {
            "groupName": {
              "type": "string"
            },
            "targetDetails": {
              "description": "the target details",
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "restoredAssetId": {
                    "type": "string"
                  },
                  "storageGroupName": {
                    "type": "string"
                  },
                  "storageSystemId": {
                    "type": "string"
                  }
                }
              }
            },
            "targetHostId": {
              "type": "string"
            }
          }
        },
        "targetVmInfo": {
          "required": [
            "inventorySourceId",
            "vmName",
            "dataCenterMoref",
            "clusterMoref",
            "hostMoref",
            "dataStoreMoref"
          ],
          "type": "object",
          "properties": {
            "clusterMoref": {
              "type": "string"
            },
            "credentials": {
              "type": "object",
              "properties": {
                "adminCredentialId": {
                  "type": "string"
                },
                "userCredentialId": {
                  "type": "string"
                }
              }
            },
            "dataCenterMoref": {
              "type": "string"
            },
            "dataStoreMoref": {
              "type": "string"
            },
            "deleteBackingFile": {
              "type": "boolean"
            },
            "disks": {
              "type": "array",
              "uniqueItems": true,
              "items": {
                "type": "object",
                "properties": {
                  "datastore": {
                    "type": "string"
                  },
                  "label": {
                    "type": "string"
                  },
                  "provisioningType": {
                    "enum": [
                      "THICK",
                      "THICK_LAZY",
                      "THICK_EAGER",
                      "THIN"
                    ],
                    "type": "string"
                  }
                }
              }
            },
            "esxHost": {
              "required": [
                "hostName",
                "userName",
                "userPassword"
              ],
              "type": "object",
              "properties": {
                "hostName": {
                  "type": "string"
                },
                "userName": {
                  "type": "string"
                },
                "userPassword": {
                  "type": "string"
                }
              }
            },
            "folderMoref": {
              "type": "string"
            },
            "hostMoref": {
              "type": "string"
            },
            "inventorySourceId": {
              "type": "string"
            },
            "recoverConfig": {
              "type": "boolean"
            },
            "resourcePoolMoref": {
              "type": "string"
            },
            "restoredVmAsset": {
              "type": "object",
              "properties": {
                "assetRef": {
                  "type": "string"
                },
                "vmRef": {
                  "type": "string"
                }
              }
            },
            "spbmRestoreDirective": {
              "enum": [
                "OFF",
                "FROM_COPY"
              ],
              "type": "string"
            },
            "tagRestoreDirective": {
              "enum": [
                "OFF",
                "FROM_COPY"
              ],
              "type": "string"
            },
            "vmName": {
              "type": "string"
            },
            "vmPowerOn": {
              "type": "boolean"
            },
            "vmReconnectNic": {
              "type": "boolean"
            }
          }
        }
      }
    },
    "startTime": {
      "description": "Restoration start time.",
      "format": "date-time",
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "state": {
      "description": "State of particular restored copy.",
      "enum": [
        "WAITING",
        "RUNNING",
        "STOPPING",
        "COMPLETED",
        "MOUNTED"
      ],
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    },
    "status": {
      "description": "Status of particular restored copy.",
      "enum": [
        "UNKNOWN",
        "SUCCESS",
        "PARTIALSUCCESS",
        "PARTIALCANCELLED",
        "CANCELLED",
        "FAILED",
        "VMOTIONED",
        "DELETED"
      ],
      "type": "string",
      "x-ppdm-filter": true,
      "x-ppdm-sort": true
    }
  },
  "required": [
    "description",
    "restoreType"
  ],
  "type": "object"
}

#>


<#
{
	"restoreType": "TO_ALTERNATE",
	"copyIds": [
		"cb05bf3f-e4bd-50cb-898a-b145a71244e6"
	],
	"description": "Restore namespace to New: Restoring copy to new namespace \"wp6\"",
	"restoredCopiesDetails": {
		"targetK8sInfo": {
			"namespace": "wp6",
			"skipNamespaceResources": false,
			"targetInventorySourceId": "e845a131-c111-4ec1-b1ec-d03f0e3bbcb3",
			"persistentVolumeClaims": [
				{
					"name": "data-wordpress1-mariadb-0"
				},
				{
					"name": "wordpress1"
				}
			],
			"overwritePersistentVolumeClaim": true
		}
	},
	"options": {
		"includeClusterResources": false
	}
}
#>
<#
.SYNOPSIS
Gets Control File for Oracle Incremental merge Backups
.EXAMPLE
#>


function Get-PPDMOIMspfile {
  [CmdletBinding()]
  param(

    [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    $id,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]                
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    $apiver = "/api/v2"
  )

  begin {
    $Response = @()
    $METHOD = "GET"
    $Myself = "oracle-control-sp-file-info"
 
  }     
  Process {
    switch ($PsCmdlet.ParameterSetName) {
      default {
        $URI = "/$myself/$id"
        $body = @{}  

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

<#
.Synopsis
Restores K8s Namespaces and Objects
.Description
Restores K8S Namespaces, PVC´s and Cluster Scoped Resources to New, Alternate or Production
.Example
Restore to Production
$myDate=(get-date).AddHours(-2)
$usedate=get-date $myDate -Format yyyy-MM-ddThh:mm:ssZ
$filter= 'endTime ge "'+$usedate+'"'
$Asset=(Get-PPDMassets | where { $_.name -eq "demo" -and $_.subtype -eq "K8S_NAMESPACE"})
$copy=Get-PPDMassetcopies -AssetID $Asset.id -filter $filter |Select-Object -First 1
Restore-PPDMK8Scopies -CopyObject $copy -includeClusterResources -TO_PRODUCTION  -targetInventorySourceId $Asset.details.k8s.inventorySourceId  -overwritePersistentVolumeClaim

.Example
Restore to alternate new Namespace
$myDate=(get-date).AddHours(-2)
$usedate=get-date $myDate -Format yyyy-MM-ddThh:mm:ssZ
$filter= 'endTime ge "'+$usedate+'"'
$Asset=(Get-PPDMassets | where { $_.name -eq "demo" -and $_.subtype -eq "K8S_NAMESPACE"})
$copy=Get-PPDMassetcopies -AssetID $Asset.id -filter $filter |Select-Object -First 1
Restore-PPDMK8Scopies -CopyObject $copy -includeClusterResources -TO_ALTERNATE -namespace wp8 -targetInventorySourceId $Asset.details.k8s.inventorySourceId

.Example
Restore to existing Namespace
$myDate=(get-date).AddHours(-2)
$usedate=get-date $myDate -Format yyyy-MM-ddThh:mm:ssZ
$filter= 'endTime ge "'+$usedate+'"'
$Asset=(Get-PPDMassets | where { $_.name -eq "wordpress" -and $_.subtype -eq "K8S_NAMESPACE"})
$copy=Get-PPDMassetcopies -AssetID $Asset.id -filter $filter |Select-Object -First 1
Restore-PPDMK8Scopies -CopyObject $copy -includeClusterResources -TO_EXISTING -namespace demo -targetInventorySourceId $Asset.details.k8s.inventorySourceId  -skipNamespaceResources -overwritePersistentVolumeClaim


.Example
Restore to alternate new Namespace in new Cluster
$aks_cluster="aksazs2"
$targetInventorySourceID=(Get-PPDMkubernetes_clusters | where name -Match $aks_cluster).id
$myDate=(get-date).AddHours(-4)
$usedate=get-date $myDate -Format yyyy-MM-ddThh:mm:ssZ
$filter= 'endTime ge "'+$usedate+'"'
$Asset=(Get-PPDMassets | where { $_.name -eq "wordpress" -and $_.subtype -eq "K8S_NAMESPACE"})
$copy=Get-PPDMassetcopies -AssetID $Asset.id -filter $filter | Select-Object -First 1
Restore-PPDMK8Scopies -CopyObject $copy -includeClusterResources -TO_ALTERNATE -namespace wordpress -targetInventorySourceId $targetInventorySourceID -noop
#>
function Restore-PPDMK8Scopies {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'byCopyObjecttoProduction')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'byCopyObjecttoExisting')]  
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'byCopyObjecttoAlternate')]
    [psobject]$CopyObject, 
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoProduction')]
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoExisting')]  
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoAlternate')]
    [string]$targetInventorySourceId,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoProduction')]
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoAlternate')]
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoExisting')]
    [switch]$includeClusterResources,
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoAlternate')]
    [switch]$TO_ALTERNATE,  
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoExisting')]
    [switch]$TO_EXISTING,
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoProduction')]
    [switch]$TO_PRODUCTION, 
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoExisting')]         
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $false, ParameterSetName = 'byCopyObjecttoAlternate')]
    $namespace,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoProduction')]
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoExisting')]
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoAlternate')]
    [switch]$overwritePersistentVolumeClaim,        
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoProduction')]
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoExisting')]
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoAlternate')]
    [switch]$skipNamespaceResources,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoProduction')]
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoExisting')]
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoAlternate')]
    $apiver = "/api/v2",
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoProduction')]
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoExisting')]
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoAlternate')]
    <# noop Parameter will simulate the command only #> 
    [switch]$noop
  )
  begin {
    $Response = @()
    $METHOD = "POST"
   
  }     
  Process {
    switch ($PsCmdlet.ParameterSetName) {
      default {
        $persistantVolumeClaims = $CopyObject.details.k8sBackup.persistentVolumeClaims | Where-Object { $_.excluded -eq $false } |  Select-Object name
      }
  
    }    
    $Body = [ordered]@{
      'copyIds'               = @( $CopyObject.id )
      'options'               = @{
        'includeClusterResources' = $includeClusterResources.IsPresent
      }
      'restoredCopiesDetails' = @{
        'targetK8sInfo' = @{
          'overwritePersistentVolumeClaim' = $overwritePersistentVolumeClaim.IsPresent
          'persistentVolumeClaims'         = $persistantVolumeClaims
          'skipNamespaceResources'         = $skipNamespaceResources.IsPresent
          'targetInventorySourceId'        = $targetInventorySourceId
        }
      }
    }
    switch ($PsCmdlet.ParameterSetName) {
      'byCopyObjecttoExisting' {
        $body.Add('restoreType', "TO_EXISTING")
        $body.Add('description', "Restore Namespace to existing $Namespace")
        $body.restoredCopiesDetails.targetK8sInfo.Add('namespace', $namespace)
      }
      'byCopyObjecttoAlternate' {
        $body.Add('restoreType', "TO_ALTERNATE")
        $body.Add('description', "Restore Namespace to new $Namespace")
        $body.restoredCopiesDetails.targetK8sInfo.Add('namespace', $namespace)
      }
      'byCopyObjecttoProduction' {
        $body.Add('restoreType', "TO_PRODUCTION")
        $body.Add('description', "Restore Namespace to Production")
        $body.restoredCopiesDetails.targetK8sInfo.Add('namespace', "")
      }            
    }
        
        
    $body = $body | convertto-json -Depth 5
    write-verbose ($body | out-string)
    $Parameters = @{
      RequestMethod    = 'Web'
      body             = $body 
      Uri              = "/restored-copies/"
      Method           = $Method
      PPDM_API_BaseUri = $PPDM_API_BaseUri
      apiver           = $apiver
      Verbose          = $PSBoundParameters['Verbose'] -eq $true
      # ResponseHeadersVariable = 'HeaderResponse'
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
          write-host $response.Headers.Date
        } 
      }   
    }
  }
}
  

<#
.SYNOPSIS

Adds a file name extension to a supplied name.

.DESCRIPTION

Restores a VMware VM From Copy back to Production
.EXAMPLE 
# Restore a VM to Production.
$RestoreVM = "server2022_3"
$Asset = Get-PPDMassets -filter 'type eq "VMWARE_VIRTUAL_MACHINE" and protectionStatus eq "PROTECTED" and name eq "server2022_3"'
$copyobject = $asset | Get-PPDMassetcopies | select-object -first 1
# Restore the VM
Restore-PPDMVMAsset -CopyObject $copyobject -recoverConfig -TO_PRODUCTION -Description "Restore from Powershell" 
.PARAMETER CopyObject
Specifies the restored_copies object

#>
function Restore-PPDMVMcopies {
  [CmdletBinding()]
  [Alias('Restore-PPDMVMAsset')]
  param(
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoProduction')]
    [switch]$TO_PRODUCTION,    
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byInstantAccess')]
    [switch]$INSTANT_ACCESS,
    #      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoAlternate')]
    #      [switch]$TO_ALTERNATE,  
    #      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoExisting')]
    #      [switch]$TO_EXISTING, 
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'byCopyObjecttoProduction')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'byInstantAccess')]  
    #      [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'byCopyObjecttoAlternate')]
    [psobject]$CopyObject,
    #      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoProduction')]
    #     [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoExisting')]  
    #      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoAlternate')]
    #      [string]$targetInventorySourceId,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoProduction')]
    #      [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoAlternate')]
    #      [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoExisting')]
    [switch]$recoverConfig,

    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byInstantAccess')]
    [string]$NewVMName,    
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byInstantAccess')]
    $InventorySourceId,
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byInstantAccess')]
    $dataCenterMoref,
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byInstantAccess')]
    $hostMoref,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byInstantAccess')]
    [switch]$vmPowerOn,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byInstantAccess')]
    [switch]$vmReconnectNic,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoProduction')]
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byInstantAccess')]
    #      [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoAlternate')]
    [switch]$enableCompressedRestore,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoProduction')]
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byInstantAccess')]
    #      [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoAlternate')]
    [switch]$restoreBiosUuid,           
    #      [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoProduction')]
    #      [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoExisting')]
    #      [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoAlternate')]
    #      [switch]$skipNamespaceResources,
    [string]$Description,
    $apiver = "/api/v2",
    [switch]$noop

  )
  begin {
    $Response = @()
    $METHOD = "POST"
 
  }     
  Process {
    switch ($PsCmdlet.ParameterSetName) {
      default {
        $Asset = Get-PPDMassets -id $CopyObject.assetId 
      }

    }    
    $Body = [ordered]@{
      'copyIds'               = @( $CopyObject.id )
      'options'               = @{
        'enableCompressedRestore' = $enableCompressedRestore.IsPresent
      }
      'restoredCopiesDetails' = @{
        'targetVmInfo' = @{
          'tagRestoreDirective'  = "OFF"
          'spbmRestoreDirective' = "FROM_COPY"
          'recoverConfig'        = $recoverConfig.isPresent
          'restoreBiosUuid'      = $restoreBiosUuid.isPresent
        }
      }
    }
    switch ($PsCmdlet.ParameterSetName) {
      'byCopyObjecttoExisting' {
        $body.Add('restoreType', "TO_EXISTING")
        $body.Add('description', "Restore VM to existing $description")
      }
      'byCopyObjecttoAlternate' {
        $body.Add('restoreType', "TO_ALTERNATE")
        $body.Add('description', "Restore VM to new $description")
      }
      'byCopyObjecttoProduction' {
        $body.Add('restoreType', "TO_PRODUCTION")
        $body.Add('description', "Restore VM $($Asset.Name) with ID $($copyobject.id) from $($copyobject.createTime) to original production storage $description")
      }  
      'byInstantAccess' {
        $body.Add('restoreType', "INSTANT_ACCESS")
        $body.Add('description', "Restore VM $($Asset.Name) with ID $($copyobject.id) from $($copyobject.createTime) Using Instant Access to $HostMoref")
        $body.restoredCopiesDetails.targetVmInfo.spbmRestoreDirective = "OFF"
        $body.restoredCopiesDetails.targetVmInfo.Add('inventorySourceId', $InventorySourceId)
        $body.restoredCopiesDetails.targetVmInfo.Add('vmName', $NewVMName)
        $body.restoredCopiesDetails.targetVmInfo.Add('dataCenterMoref', ($dataCenterMoref -split ":")[-1])
        $body.restoredCopiesDetails.targetVmInfo.Add('hostMoref', ($hostMoref -split ":")[-1])
        $body.restoredCopiesDetails.targetVmInfo.Add('vmPowerOn', $vmPowerOn.IsPresent)
        $body.restoredCopiesDetails.targetVmInfo.Add('vmReconnectNic', $vmReconnectNic.IsPresent)
        $body.restoredCopiesDetails.targetVmInfo.Remove('restoreBiosUuid')
      }
    }
      
    $body = $body | convertto-json -Depth 5
    write-verbose ($body | out-string)
    $Parameters = @{
      RequestMethod    = 'Web'
      body             = $body 
      Uri              = "/restored-copies/"
      Method           = $Method
      PPDM_API_BaseUri = $PPDM_API_BaseUri
      apiver           = $apiver
      Verbose          = $PSBoundParameters['Verbose'] -eq $true
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
          write-host $response.Headers.Date
        } 
      }   
    }
  }
}

<#
.Synopsis
Gets Information about a retored_copies object
.Description
Centralized Restore generate restore_copies objects with an activity and restore / mount status
.Example
Get all restored Copies
Get-PPDMRestored_copies
.Example
Get Restored Copy Status of a Restore
$Restore | Get-PPDMRestored_copies
#>
function Get-PPDMRestored_copies {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    $id,
    [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
    $filter,
    #       [ValidateSet()]
    #       [Alias('AssetType')][string]$type,
    [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
    $pageSize, 
    [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
    $page, 
    [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
    [hashtable]$body = @{orderby = 'createdAt DESC' },
    [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
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
        $body = @{}  

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






function New-PPDMRestored_copies {
  [CmdletBinding()]
  [Alias('Mount-PPDMFLRCopy')]
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'SameHost', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'TargetHost', ValueFromPipelineByPropertyName = $true)]    
    [alias('assetObject')][psobject]$copyobject,
    #    [Parameter(Mandatory = $true, ParameterSetName = 'SameHost', ValueFromPipelineByPropertyName = $true)]
    #    [Parameter(Mandatory = $true, ParameterSetName = 'TargetHost', ValueFromPipelineByPropertyName = $true)]
    #    [Alias('name')]$assetName,
    [Parameter(Mandatory = $true, ParameterSetName = 'TargetHost', ValueFromPipelineByPropertyName = $true)]
    [Alias('TargetHost')]$hostID,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [string]$CustomDescription,  
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    $apiver = "/api/v2"           
  )
  begin {
    $Response = @()
    $METHOD = "POST"
    $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
    # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
    $URI = "/$myself"
  }     
  Process {
    switch ($PsCmdlet.ParameterSetName) {
      default {
        $AssetName = $copyobject.assetName
        [string[]]$ids = $copyobject.id        
      }
    } 
    $body = @{}
    if ($CustomDescription) {
      $body.Add('description', "FLR Mount of $AssetName, $CustomDescription")  
    }
    else {
      $body.Add('description', "FLR Mount of $AssetName")
    }
    $body.Add('copyIds', $IDs)
    $body.Add('restoreType', "TO_MOUNT")
    $body.Add('restoredCopiesDetails', @{})
    $body.restoredCopiesDetails.Add('targetFileSystemInfo', @{})
    switch ($PsCmdlet.ParameterSetName) {
      'TargetHost' {
        write-verbose "Mounting to Target Host" 
        $body.restoredCopiesDetails.targetFileSystemInfo.Add('hostId', $hostID) 
      }
      default {}
    }
    $body.restoredCopiesDetails.targetFileSystemInfo.Add('location', $assetName) 
    $body = $body | ConvertTo-Json
    write-verbose ($body | out-string )


    $Parameters = @{
      RequestMethod    = 'REST'
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
        write-output $response 
      }
      default {
        write-output $response 
      } 
    }   
  }
}

<#
.Synopsis
Restores fsagent based Backups
.Description
Centralized Restore of FSagent Backups to Same or different Host
.Example
Restore to Production
### Get all linux Hosts with FLR Agent
## We do this with Specifying a Filter
$linuxfilter = 'attributes.appHost.appServerTypes eq "FS" and not (lastDiscoveryStatus eq "DELETED") and details.appHost.os lk "linux" and details.appHost.phase eq "NONE"'
### Read our Restore Host
$RestoreHostFilter = 'attributes.appHost.appServerTypes eq "FS" and not (lastDiscoveryStatus eq "DELETED") and details.appHost.os lk "linux" and details.appHost.phase eq "NONE"and hostname eq "' + $RestoreToHost_Name + '"'
$RestoreToHost = Get-PPDMhosts -filter $RestoreHostFilter
$RestoreToHost
### Read the Asset to restore to identify the Asset Copies
$RestoreAssetFilter = 'type eq "FILE_SYSTEM" and protectionStatus eq "PROTECTED" and details.fileSystem.hostName eq  "' + $RestoreFromHost + '"'
$RestoreAssets = Get-PPDMAssets -Filter $RestoreAssetFilter
$RestoreAssets
$RestoreAssets | Get-PPDMcopy_map
### Selecting and mounting the Asset Copy to Restore 
$RestoreAssetCopy = $RestoreAssets | Get-PPDMassetcopies -filter 'state eq "IDLE"' | Select-Object -First 1
$RestoredCopy = New-PPDMRestored_copies -Copyobject $RestoreAssetCopy -Hostid $RestoreToHost.id -CustomDescription "Mount from Powershell"
do {
  Start-Sleep -Seconds 10    
  $MountedCopy = $RestoredCopy | Get-PPDMRestored_copies
}
until ($MountedCopy.status -eq "SUCCESS") 

# Optionally, do a Browsing

$Parameters = @{
  HostID               = $RestoreToHost.id
  Hostpath             = "/home/bottk"
  mountURL             = $MountedCopy.restoredCopiesDetails.targetFileSystemInfo.mountUrl
  RestoreAssetHostname = $RestoreFromHost
}
$Browselist = Get-PPDMFSAgentFLRBrowselist @Parameters
$Browselist.files
## Run the Restore
$Parameters = @{
  CopyObject           = $RestoreAssetCopy
  HostID               = $RestoreToHost.id 
  RestoreAssetHostname = $RestoreFromHost
  RestoreLocation      = "/tmp"
  RetainFolderHierachy = $true
  conflictStrategy     = "TO_ALTERNATE" 
  RestoreSources       = "/home/bottk, /root"
  CustomDescription    = "Restore from Powershell"
  Verbose              = $false
}
$Restore = Restore-PPDMFileFLR_copies @Parameters
$Restore | Get-PPDMActivities
$Restore | Get-PPDMRestored_copies
#>
function Restore-PPDMFileFLR_copies {
  [CmdletBinding()]
  [Alias('Restore-PPDMFromFFileAgent')]
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [alias('assetObject')][psobject]$copyobject,
    [Parameter(Mandatory = $true, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [string]$HostID,
    #[Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    # [Alias('name')]$assetName,
    [Parameter(Mandatory = $true, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [Alias('location')]$RestoreLocation,    
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [switch]$RetainFolderHierachy,  
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [ValidateSet('TO_ALTERNATE', 'OVERWRITE')][string]$conflictStrategy = "TO_ALTERNATE",
    [Parameter(Mandatory = $true, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [string[]]$RestoreSources, 
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [string]$CustomDescription,     
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [ValidateSet('LINUX', 'WINDOWS')][string]$HostOS,   
    #  [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    #  [Alias('sources','FileList')][string[]]$RestoreSources,     
    
    [switch]$noop,
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    $apiver = "/api/v2"           
  )
  begin {
    $Response = @()
    $METHOD = "POST"
    $URI = "/restored-copies/"
  }     
  Process {
    switch ($PsCmdlet.ParameterSetName) {
      'byCopyObjecttoProduction' {
        $AssetName = $copyobject.assetName
        [string[]]$ids = $copyobject.id
      }
      default {
        
      }
    } 
    $body = @{}

    if ($CustomDescription) {
      $body.Add('description', "File Level Restore of $AssetName, $CustomDescription")  
    }
    else {
      $body.Add('description', "File Level Restore of $AssetName")
    }
    $body.Add('copyIds', $IDs)
    $body.Add('restoreType', "TO_FLR")
    $body.Add('options', @{})
    $body.options.Add('restoreLocation', 'ALTERNATE')
    $body.Options.Add('retainFolderHierarchy', $RetainFolderHierachy.IsPresent)
    $body.Add('restoredCopiesDetails', @{})
    $body.restoredCopiesDetails.Add('targetFileSystemInfo', @{})
    $body.restoredCopiesDetails.targetFileSystemInfo.Add('conflictStrategy', $conflictStrategy)
    $body.restoredCopiesDetails.targetFileSystemInfo.Add('location', "$RestoreLocation") 
    $body.restoredCopiesDetails.targetFileSystemInfo.Add('hostId', "$HostID")
    $body.restoredCopiesDetails.targetFileSystemInfo.Add('sources', $RestoreSources)
    $body = $body | ConvertTo-Json -Depth 7
    write-verbose ($body | out-string )
    $Parameters = @{
      RequestMethod    = 'REST'
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
.Synopsis
Restores MSAPPSAgent based SQL Database Backups
.Description
Centralized Restore of MSAPPSAgent based SQL Database Backups to Same or different Host
.Example
# Set SQ Hostname(s) , Instance and Database
RestoreFromHost = "sqlsinglenode.dpslab.home.labbuildr.com"
$RestoreToHost_Name = "sqlsinglenode.dpslab.home.labbuildr.com"
$AppServerName = "MSSQLDPSLAB"
$DataBaseName = "AdventureWorks2019"

### Get all Windows Hosts with MSSQL Apps

$Appfilter = 'attributes.appHost.appServerTypes eq "MSSQL" and not (lastDiscoveryStatus eq "DELETED") and details.appHost.os lk "WINDOWS" and details.appHost.phase eq "NONE"'
Get-PPDMhosts -filter $AppFilter

### Read our Restore Host

$RestoreHostFilter = 'attributes.appHost.appServerTypes eq "MSSQL" and not (lastDiscoveryStatus eq "DELETED") and details.appHost.os lk "WINDOWS" and details.appHost.phase eq "NONE" and hostname eq "' + $RestoreToHost_Name + '"'
$RestoreToHost = Get-PPDMhosts -filter $RestoreHostFilter
$RestoreToHost

### Read the Asset to restore to identify the Asset Copies

$RestoreAssetFilter = 'type eq "MICROSOFT_SQL_DATABASE" and protectionStatus eq "PROTECTED" and details.database.clusterName eq "' + $RestoreFromHost + '"' + ' and details.database.appServerName eq "' + $AppServerName + '"'
$RestoreAssets = Get-PPDMAssets -Filter $RestoreAssetFilter
$RestoreAssets = $RestoreAssets | Where-Object name -Match $DataBaseName
# Optionally, look at the CopyMap
# $Copymap=$RestoreAssets | Get-PPDMcopy_map

### Selecting the Asset Copy to Restore 
write-host "Selecting Asset-copy for $DataBaseName"
$myDate = (get-date).AddDays(-2)
$usedate = get-date $myDate -Format yyyy-MM-ddThh:mm:ssZ
$RANGE_FILTER = 'startTime ge "' + $usedate + '"state eq "IDLE"'
# $RestoreAssets | Get-PPDMassetcopies -filter $RANGE_FILTER
$RestoreAssetCopy = $RestoreAssets | Get-PPDMassetcopies -filter $RANGE_FILTER | Select-Object -First 1

### Run the Restore :-)  
```Powershell
$Parameters = @{
  HostID                  = $RestoreToHost.id 
  appServerId             = $RestoreAssets.details.database.appServerId
  copyObject              = $RestoreAssetCopy
  enableDebug             = $false
  disconnectDatabaseUsers = $true
  restoreType             = "TO_ALTERNATE" 
  CustomDescription       = "Restore from Powershell"
  Verbose                 = $false
}
$Restore = Restore-PPDMMSSQL_copies @Parameters

### Monitor the Restore
$Restore | Get-PPDMRestored_copies
$Restore | Get-PPDMactivities
#>
function Restore-PPDMMSSQL_copies {
  [CmdletBinding()]
  [Alias('Restore-PPDMDDB_MSSQL')]
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [alias('assetObject')][psobject]$copyobject,    
    [Parameter(Mandatory = $true, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [string]$HostID,
    [Parameter(Mandatory = $true, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [string]$appServerID,    
    # [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    # [Alias('copyIds', 'Id')][string[]]$ids,
    # [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    # [Alias('name')]$assetName,
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [switch]$enableDebug,  
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [switch]$performTailLogBackup,  
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [switch]$enableCompressedRestore,   
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [switch]$disconnectDatabaseUsers, 
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [ValidateSet('ORIGINAL_LOCATION')]
    [string]$fileRelocationOptions = "ORIGINAL_LOCATION",            
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [ValidateSet('TO_ALTERNATE')]
    [string]$restoreType = "TO_ALTERNATE",
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [ValidateSet('RESTORE_TO_PRIMARY', 'RESTORE_TO_ALL')]
    [string]$aagRestoreType,
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [string]$CustomDescription,      
    #  [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    #  [Alias('sources','FileList')][string[]]$RestoreSources,     
    
    [switch]$noop,
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    $apiver = "/api/v2"           
  )
  begin {
    $Response = @()
    $METHOD = "POST"
    # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
    $URI = "/restored-copies/"
  }     
  Process {
    switch ($PsCmdlet.ParameterSetName) {
      'byCopyObjecttoProduction' {
        $AssetName = $copyobject.assetName
        [string[]]$ids = $copyobject.id
      }
      default {
        
      }
    }  
    $body = @{}
    if ($CustomDescription) {
      $body.Add('description', "Restore to original database $AssetName, $CustomDescription")  
    }
    else {
      $body.Add('description', "Restore to original database $AssetName")
    }
    $body.Add('copyIds', $IDs)
    $body.Add('restoreType', $restoreType)

    $body.Add('restoredCopiesDetails', @{})
    $body.restoredCopiesDetails.Add('targetDatabaseInfo', @{})
    $body.restoredCopiesDetails.targetDatabaseInfo.Add('applicationSystemId', $appServerID)
    $body.restoredCopiesDetails.targetDatabaseInfo.Add('hostId', "$HostID")
    $body.restoredCopiesDetails.targetDatabaseInfo.Add('assetName', $assetName)
    if ($aagRestoreType) {
      $body.restoredCopiesDetails.targetDatabaseInfo.Add('restoreOptions', @{})
      $body.restoredCopiesDetails.targetDatabaseInfo.restoreOptions.Add('aagRestoreType', $aagRestoreType)
    }
    $body.Add('options', @{})
    $body.options.Add('forceDatabaseOverwrite', $true)
    $body.options.Add('enableDebug', $enableDebug.IsPresent) 
    $body.options.Add('recoveryState', "RECOVERY") 
    $body.options.Add('performTailLogBackup', $performTailLogBackup.isPresent) 
    $body.options.Add('enableCompressedRestore', $enableCompressedRestore.IsPresent) 
    $body.options.Add('disconnectDatabaseUsers', $disconnectDatabaseUsers.IsPresent) 
    $body.options.Add('fileRelocationOptions', @{})

    switch ($fileRelocationOptions) {
      'ORIGINAL_LOCATION' {
        $body.options.fileRelocationOptions.Add('type', $fileRelocationOptions)
      }
    }
    $body = $body | ConvertTo-Json -Depth 7
    write-verbose ($body | out-string )


    $Parameters = @{
      RequestMethod    = 'REST'
      body             = $body
      Uri              = $URI
      Method           = $Method
      PPDM_API_BaseUri = $PPDM_API_BaseUri
      apiver           = $apiver
      Verbose          = $PSBoundParameters['Verbose'] -eq $true
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
.SYNOPSIS
Browses the FLR Mount. Identifies the Mounted Copy Locationon the Host
.EXAMPLE
$BMRHost=Get-PPDMhosts -type APP_HOST -filter 'name lk "win-01.demo.local"'
$BMRRestoreAssetCopy=$BMRAssets | Get-PPDMlatest_Copies
$BMRRestoredCopy = New-PPDMRestored_copies -copyobject $BMRRestoreAssetCopy  -Hostid $BMRHost.id
do {
  Start-Sleep -Seconds 10
  $MountedCopy = $BMRRestoredCopy | Get-PPDMRestored_copies
}
until ($MountedCopy.status -eq "SUCCESS") 
$Parameters = @{
    HostID               = $BMRHost.id
    BackupTransactionID  = $BMRRestoreAssetCopy.backupTransactionId
    mountURL             = $MountedCopy.restoredCopiesDetails.targetFileSystemInfo.mountUrl
}
$Browselist = Get-PPDMFSAgentFLRBrowselist @Parameters
$Browselist.files

#>
function Get-PPDMFSAgentFLRBrowselist {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$HostID,
    [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
    $BackupTransactionID,
    [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
    $mountURL,    
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    $apiver = "/api/v2"
  )
  begin {
    $Response = @()
    $METHOD = "POST"
    # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
    $URI = "/adm/browse-path"

  }     
  Process {
    switch ($PsCmdlet.ParameterSetName) {
      default {
      }
    }
    $Body = @{}
    $Body.Add('hostId', $HostID)
    $Body.Add('mountUrl', $mountURL)

    $Body = $Body | ConvertTo-Json
    Write-Verbose ( $body | out-string )
    $Parameters = @{
      RequestMethod    = 'REST'
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

      default {
        write-output $response | convertfrom-json
      } 
    }   
  }
}





<#
.SYNOPSIS
Restores an Oracle Database
.EXAMPLE
#>

function Restore-PPDMOracle_copies {
  [CmdletBinding()]
  [Alias('Restore-PPDMDDB_MSSQL')]
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [alias('assetCopyObject')][psobject]$copyobject, 
    [Parameter(Mandatory = $true, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [PSobject]$OraCredObject, 
    [Parameter(Mandatory = $true, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [string]$HostID,
    [Parameter(Mandatory = $true, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [string]$appServerID,    
    # [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    # [Alias('copyIds', 'Id')][string[]]$ids,
    # [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    # [Alias('name')]$assetName,
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [switch]$enableDebug,  
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [switch]$crossCheckBackup,  
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [switch]$enableCompressedRestore,   
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [switch]$dryRun, 
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [ValidateSet('ORIGINAL_LOCATION')]
    [string]$fileRelocationOptions = "ORIGINAL_LOCATION",            
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [ValidateSet('TO_PRODUCTION')]
    [string]$restoreType = "TO_PRODUCTION",
    [Parameter(Mandatory = $false, ParameterSetName = 'byCopyObjecttoProduction', ValueFromPipelineByPropertyName = $true)]
    [string]$CustomDescription,      
    #  [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    #  [Alias('sources','FileList')][string[]]$RestoreSources,     
    
    [switch]$noop,
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    $apiver = "/api/v2"           
  )
  begin {
    $Response = @()
    $METHOD = "POST"
    # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
    $URI = "/restored-copies/"
  }     
  Process {
    switch ($PsCmdlet.ParameterSetName) {
      'byCopyObjecttoProduction' {
        $AssetName = $copyobject.assetName
        $AssetId = $copyobject.assetId
        $dataTargetId = $copyobject.dataTargetIds
      }
      default {
     
      }
    }  
    $body = @{}
    $body.Add('dryRun', $dryRun.IsPresent)
    if ($CustomDescription) {
      $body.Add('description', "Restore Oracle Database to original database $AssetName, $CustomDescription")  
    }
    else {
      $body.Add('description', "Restore Oracle Database to original database $AssetName")
    }
    $body.Add('restoreType', $restoreType)
    $body.Add('restoredCopiesDetails', @{})
    $body.restoredCopiesDetails.Add('targetOracleDatabaseInfo', @{})
    $body.restoredCopiesDetails.targetOracleDatabaseInfo.Add('applicationSystemId', $appServerID)
    $body.restoredCopiesDetails.targetOracleDatabaseInfo.Add('hostId', "$HostID")
    $body.restoredCopiesDetails.targetOracleDatabaseInfo.Add('restoreCategory', 'RESTORE_DB')
    $body.restoredCopiesDetails.targetOracleDatabaseInfo.Add('assetId', $assetId)
    $body.restoredCopiesDetails.targetOracleDatabaseInfo.Add('dataTargetId', $dataTargetId[0])
    $body.restoredCopiesDetails.targetOracleDatabaseInfo.Add('parallelism', 4)
    $body.restoredCopiesDetails.targetOracleDatabaseInfo.Add('targetConnectionInfos', @(
        @{
          'credsId'        = $OraCredObject.id
          'connectionType' = $OraCredObject.Type
        }
    
      ))
    
    $body.Add('options', @{})
    $body.options.Add('enableDebug', $enableDebug.IsPresent) 
    $body.options.Add('crossCheckBackup', $crossCheckBackup.isPresent) 
    $body.options.Add('enableCompressedRestore', $enableCompressedRestore.IsPresent) 
    $body.options.Add('restoreSubCategory', 'CURRENT_TIME')
    $body.options.Add('pitInfo', @{})
    $body.options.pitInfo.Add('targetTime', (Get-date (Get-Date -format g) -UFormat %s))
    $body = $body | ConvertTo-Json -Depth 7
    write-verbose ($body | out-string )


    $Parameters = @{
      RequestMethod    = 'REST'
      body             = $body
      Uri              = $URI
      Method           = $Method
      PPDM_API_BaseUri = $PPDM_API_BaseUri
      apiver           = $apiver
      Verbose          = $PSBoundParameters['Verbose'] -eq $true
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



function Restore-PPDMOracle_OIM_copies {
  [CmdletBinding()]
  [Alias('Restore-PPDMDDB_MSSQL')]
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'byInstantAccess', ValueFromPipelineByPropertyName = $true)]
    [alias('assetCopyObject')][psobject]$copyobject, 
    [Parameter(Mandatory = $true, ParameterSetName = 'byInstantAccess', ValueFromPipelineByPropertyName = $true)]
    [PSobject]$OraCredObject, 
    [Parameter(Mandatory = $true, ParameterSetName = 'byInstantAccess', ValueFromPipelineByPropertyName = $true)]
    [string]$HostID,
    [Parameter(Mandatory = $true, ParameterSetName = 'byInstantAccess', ValueFromPipelineByPropertyName = $true)]
    [string]$appServerID,    
    [Parameter(Mandatory = $true, ParameterSetName = 'byInstantAccess', ValueFromPipelineByPropertyName = $true)]
    [string]$targetSid,  
    [Parameter(Mandatory = $true, ParameterSetName = 'byInstantAccess', ValueFromPipelineByPropertyName = $true)]
    [string]$targetInstallLocation,     
    [Parameter(Mandatory = $false, ParameterSetName = 'byInstantAccess', ValueFromPipelineByPropertyName = $true)]
    [switch]$enableDebug,  
    [Parameter(Mandatory = $false, ParameterSetName = 'byInstantAccess', ValueFromPipelineByPropertyName = $true)]
    [switch]$crossCheckBackup,  
    [Parameter(Mandatory = $false, ParameterSetName = 'byInstantAccess', ValueFromPipelineByPropertyName = $true)]
    [switch]$enableCompressedRestore,   
    [Parameter(Mandatory = $false, ParameterSetName = 'byInstantAccess', ValueFromPipelineByPropertyName = $true)]
    [switch]$dryRun, 
    [Parameter(Mandatory = $false, ParameterSetName = 'byInstantAccess', ValueFromPipelineByPropertyName = $true)]
    [ValidateSet('ORIGINAL_LOCATION')]
    [string]$fileRelocationOptions = "ORIGINAL_LOCATION",            
    [Parameter(Mandatory = $false, ParameterSetName = 'byInstantAccess', ValueFromPipelineByPropertyName = $true)]
    [ValidateSet('TO_PRODUCTION')]
    [string]$restoreType = "TO_PRODUCTION",
    [Parameter(Mandatory = $false, ParameterSetName = 'byInstantAccess', ValueFromPipelineByPropertyName = $true)]
    [ValidateSet('INSTANT_ACCESS_RECOVERY')]
    [string]$restoreCategory = "INSTANT_ACCESS_RECOVERY",
    [Parameter(Mandatory = $false, ParameterSetName = 'byInstantAccess', ValueFromPipelineByPropertyName = $true)]
    [string]$CustomDescription,      
    #  [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    #  [Alias('sources','FileList')][string[]]$RestoreSources,     
    
    [switch]$noop,
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    $apiver = "/api/v2"           
  )
  begin {
    $Response = @()
    $METHOD = "POST"
    # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
    $URI = "/restored-copies/"
  }     
  Process {
    switch ($PsCmdlet.ParameterSetName) {
      'byInstantAccess' {
        $AssetName = $copyobject.assetName
        $AssetId = $copyobject.assetId
        $dataTargetId = $copyobject.dataTargetIds
      }
      default {
     
      }
    }  
    $body = @{
      'copyIds' = @( $CopyObject.id )
    }
    $body.Add('dryRun', $dryRun.IsPresent)
    if ($CustomDescription) {
      $body.restoredCopiesDetails.targetOracleDatabaseInfo.Add('restoreCategory', $restoreType)
      $body.Add('description', "Restore Oracle OIM Database $restoretype $AssetName, $CustomDescription")  
    }
    else {
      $body.Add('description', "Restore Oracle OIM database $restoretype $AssetName")
    }

    $body.Add('restoreType', $restoreType)
    $body.Add('restoredCopiesDetails', @{})
    $body.restoredCopiesDetails.Add('targetOracleDatabaseInfo', @{})
    $body.restoredCopiesDetails.targetOracleDatabaseInfo.Add('assetName', $targetSid)
    $body.restoredCopiesDetails.targetOracleDatabaseInfo.Add('applicationSystemId', $null)
    $body.restoredCopiesDetails.targetOracleDatabaseInfo.Add('hostId', "$HostID")
    $body.restoredCopiesDetails.targetOracleDatabaseInfo.Add('restoreCategory', $restoreCategory)
    $body.restoredCopiesDetails.targetOracleDatabaseInfo.Add('assetId', $assetId)
    $body.restoredCopiesDetails.targetOracleDatabaseInfo.Add('dataTargetId', $dataTargetId[0])
    $body.restoredCopiesDetails.targetOracleDatabaseInfo.Add('parallelism', 4)
    $body.restoredCopiesDetails.targetOracleDatabaseInfo.Add('targetConnectionInfos', @(
        @{
          'credsId'        = $OraCredObject.id
          'connectionType' = $OraCredObject.Type
        }
        $body.restoredCopiesDetails.targetOracleDatabaseInfo.Add('restoreProtocol', "NFS")
        $body.restoredCopiesDetails.targetOracleDatabaseInfo.Add('nfsShare', @{})
    
      ))
    write-verbose "Reading SP File"  
    $spfile = Get-PPDMOIMspfile -id $copyobject.id
    $body.Add('options', @{
        "targetSid"               = $targetSid
        "targetInstallLocation"   = $targetInstallLocation
        "fileRelocationOptions"   = @{
          "type"                          = $fileRelocationOptions
          "targetControlFiles"            = $null
          "targetArchLogFileLocations"    = $null
          "targetDataFileLocation"        = $null
          "targetFRAFileLocation"         = $null
          "targetRedoLogFileLocations"    = $null
          "targetRootLevelFolderLocation" = $null
        }
        "openDatabase"            = $true
        "changeDbId"              = $false
        "enableDebug"             = $enableDebug.IsPresent
        "enableCompressedRestore" = $enableCompressedRestore.IsPresent
        "restoreSubCategory"      = "BACKUP_TIME"
        "pitInfo"                 = @{
          "targetTime" = (Get-Date $copyobject.createTime -UFormat %s)
        }
        "restoreSpFile"           = $true
        "controlSpFileBackupData" = $spfile.oracleControlSpFileInfo
        "advanceSpFileParameters" = @()
        "crossCheckBackup"        = $crossCheckBackup.isPresent
        "enableAutoCleanup"       = $false  
      }
    )
    $body = $body | ConvertTo-Json -Depth 7
    write-verbose ($body | out-string )


    $Parameters = @{
      RequestMethod    = 'REST'
      body             = $body
      Uri              = $URI
      Method           = $Method
      PPDM_API_BaseUri = $PPDM_API_BaseUri
      apiver           = $apiver
      Verbose          = $PSBoundParameters['Verbose'] -eq $true
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

function Remove-PPDMrestored_copies {
  [CmdletBinding()]
  param(

    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    $id,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]                
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    $apiver = "/api/v2"
  )

  begin {
    $Response = @()
    $METHOD = "POST"
    $Myself = ($MyInvocation.MyCommand.Name.Substring(11) -replace "_", "-").ToLower()
 
  }     
  Process {
    switch ($PsCmdlet.ParameterSetName) {

      default {
        $URI = "/$myself/$id/remove"
        $body = @{}                
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



