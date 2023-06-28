

$Jsonbody='

{
    "description": "File Level Restore of /",
    "copyIds": [
      "5e50b8eb-06e1-5e03-8d87-839d612d81fc"
    ],
    "restoreType": "TO_FLR",
    "restoredCopiesDetails": {
      "targetFileSystemInfo": {
        "hostId": "ed5365a5-5573-4f8c-ae07-33462e3e8be4",
        "location": "/tmp",
        "conflictStrategy": "OVERWRITE",
        "sources": [
          "/opt/dpsapps/fsagent/tmp/FBB/whqnqlqclj2yw.edub.csc/1687779768/home/bottk/ksh_2020.0.0-5_amd64.deb"
        ]
      }
    },
    "options": {
      "restoreLocation": "ALTERNATE",
      "retainFolderHierarchy": false
    }
  }
'


hosts
orderby: name ASC
filter: attributes.appHost.appServerTypes eq "FS" and 'not (lastDiscoveryStatus eq "DELETED")' and details.appHost.os lk "linux" and details.appHost.phase eq "NONE"

hostId
: 
"8593932f-46b5-464a-85c2-1c7a1c6a95a1"
mountUrl
: 
"/FSAgent/FLR/v1/1687844279/opt/dpsapps/fsagent/tmp/FBB/whqnqlqclj2yw.edub.csc/1687834814/home/bottk"



location in ("LOCAL", "LOCAL_RECALLED") and storageSystemId eq "aa0b484c-8f1e-4749-99c1-91f3611ab3b1" and replicatedCopy eq false and not state in ("DELETED", "SOFT_DELETED") and copyType in ("FULL", "DIFFERENTIAL", "INCREMENTAL", "INCR_0", "INCR_1_CUMULATIVE", "INCR_1_DIFFERENTIAL", "CUMULATIVE_INCR", "DIFF_INCR")

orderby: createTime DESC




{
  "restoreType": "TO_ALTERNATE",
  "description": "Restore to original database",
  "copyIds": [
    "0eb5bc5d-c691-569e-a97f-785407c36f18"
  ],
  "restoredCopiesDetails": {
    "targetDatabaseInfo": {
      "hostId": "ba9bcb41-6c6c-435c-8468-39af78f21ddd",
      "applicationSystemId": "5b6c2b8d-82cc-5c51-8b15-6541d5a0b88a",
      "assetName": "AdventureWorks2019"
    }
  },
  "options": {
    "forceDatabaseOverwrite": true,
    "enableDebug": false,
    "recoveryState": "RECOVERY",
    "performTailLogBackup": false,
    "enableCompressedRestore": false,
    "disconnectDatabaseUsers": false,
    "fileRelocationOptions": {
      "type": "ORIGINAL_LOCATION"
    }
  }
}