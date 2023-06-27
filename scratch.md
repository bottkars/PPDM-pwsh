

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