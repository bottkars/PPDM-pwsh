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
      RequestMethod           = 'Rest'
      body                    = $body 
      Uri                     = "/restored-copies/"
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
  


function Restore-PPDMVMcopies {
  [CmdletBinding()]
  [Alias('Restore-PPDMVMAsset')]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'byCopyObjecttoProduction')]
    #      [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'byCopyObjecttoExisting')]  
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
    #      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoAlternate')]
    #      [switch]$TO_ALTERNATE,  
    #      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoExisting')]
    #      [switch]$TO_EXISTING,
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoProduction')]
    [switch]$TO_PRODUCTION, 
    #      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoExisting')]         
    #      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $false, ParameterSetName = 'byCopyObjecttoAlternate')]
    #     $namespace,
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoProduction')]
    #      [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoExisting')]
    #      [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'byCopyObjecttoAlternate')]
    [switch]$enableCompressedRestore,        
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
        }
      }
    }
    switch ($PsCmdlet.ParameterSetName) {
      'byCopyObjecttoExisting' {
        $body.Add('restoreType', "TO_EXISTING")
        $body.Add('description', "Restore Namespace to existing $description")
      }
      'byCopyObjecttoAlternate' {
        $body.Add('restoreType', "TO_ALTERNATE")
        $body.Add('description', "Restore Namespace to new $description")
      }
      'byCopyObjecttoProduction' {
        $body.Add('restoreType', "TO_PRODUCTION")
        $body.Add('description', "Restore VM $($Asset.Name) with ID $($copyobject.id) from $($copyobject.createTime) to original production storage $description")
      }            
    }
      
      
    $body = $body | convertto-json -Depth 5
    write-verbose ($body | out-string)
    $Parameters = @{
      RequestMethod           = 'Rest'
      body                    = $body 
      Uri                     = "/restored-copies/"
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
