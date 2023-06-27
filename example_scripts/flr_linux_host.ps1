
$RestoreFromHost = "nqh66pb6tgsw2.home.labbuildr.com"

$RestoreToHost = "nqh66pb6tgsw2.home.labbuildr.com"




connect-pPDMapiEndpoint -trustCert -PPDM_API_BaseURI ppdmavs01.edub.csc
$RestoreFromHost = "WhqNQLqCLJ2yw.edub.csc"
$RestoreToHost = "bM10k2Mjn53aO.edub.csc"

### Get all linux Hosts with FLR Agent
$linuxfilter ='attributes.appHost.appServerTypes eq "FS" and not (lastDiscoveryStatus eq "DELETED") and details.appHost.os lk "linux" and details.appHost.phase eq "NONE"'
Get-PPDMhosts -filter $linuxfilter
$RestoreHostFilter ='attributes.appHost.appServerTypes eq "FS" and not (lastDiscoveryStatus eq "DELETED") and details.appHost.os lk "linux" and details.appHost.phase eq "NONE"and hostname eq "' + $RestoreToHost + '"'
$RestoreToHost = Get-PPDMhosts -filter $RestoreHostFilter

$RestoreAssetFilter = 'type eq "FILE_SYSTEM" and protectionStatus eq "PROTECTED" and details.fileSystem.hostName eq  "' + $RestoreFromHost + '"'
$RestoreAssets=Get-PPDMAssets -Filter $RestoreAssetFilter


write-host "Selecting Asset-copy for $RestoreFromHost"
$RestoreAssetCopy = $RestoreAssets | Get-PPDMassetcopies -filter 'state eq "IDLE"' | Select-Object -First 1
$RestoredCopy=New-PPDMRestored_copies -ids $RestoreAssetCopy.id -assetName $RestoreAssetCopy.assetName -Hostid $RestoreToHost.id

do {
Start-Sleep -Seconds 10    
$MountedCopy=$RestoredCopy | Get-PPDMRestored_copies
}
until ($MountedCopy.status -eq "SUCCESS") 


$Browselist=Get-PPDMFSAgentFLRBrowselist -HostID $RestoreToHost.id -BackupTransactionID $RestoreAssetCopy.backupTransactionId -Hostpath /home/bottk -mountURL $MountedCopy.restoredCopiesDetails.targetFileSystemInfo.mountUrl -RestoreAssetHostname $RestoreFromHost


Restore-PPDMFileFLR_copies -restore-ppdmflrfil  

$JsonBody='
{
    "description": "FLR Mount of  /",
    "copyIds": [
      "5e50b8eb-06e1-5e03-8d87-839d612d81fc"
    ],
    "restoreType": "TO_MOUNT",
    "restoredCopiesDetails": {
      "targetFileSystemInfo": {
        "location": "/"
      }
    }
  }
'

Invoke-PPDMapirequest -uri /restored-copies -Method POST -RequestMethod Rest -Body $JsonBody
$Jsonbody = '{"mountUrl":"/FSAgent/FLR/v1/1687844279/opt/dpsapps/fsagent/tmp/FBB/whqnqlqclj2yw.edub.csc/1687834814/home/bottk","hostId":"8593932f-46b5-464a-85c2-1c7a1c6a95a1"}'

Invoke-PPDMapirequest -uri /adm/browse-path -Method POST -RequestMethod Rest -Body $JsonBody

/FSAgent/FLR/v1/1687852388/opt/dpsapps/fsagent/tmp/FBB/WhqNQLqCLJ2yw.edub.csc/1687834814/home/bottk"
/FSAgent/FLR/v1/1687852146/opt/dpsapps/fsagent/tmp/FBB/whqnqlqclj2yw.edub.csc/1687834814/home/bottk
$Jsonbody='

{
    "description": "File Level Restore of /",
    "copyIds": [
      "5e50b8eb-06e1-5e03-8d87-839d612d81fc"
    ],
    "restoreType": "TO_FLR",  # To_MOUNT
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




$FLR_Session = Start-PPDMflr_sessions -targetVmAssetId $AssetCopy.assetId -copyId $AssetCopy.id -credentials $credentials

# Get-PPDMflr_sessions -id $FLR_Session.flrSessionId -retries 5 -timeout 30 


write-host "waiting for Mount of $($AssetCopy.id)"

do {
    $activity = $flr_session | Get-PPDMactivities 
}
until ($activity.state = "COMPLETED")

# Set-PPDMFLRbrowsescope -directory /home/bottk -id $FLR_Session.flrSessionId

# Get-PPDMFLRfiles -id $FLR_Session.flrSessionId
write-Host "Starting Restore"
$restoretask = restore-PPDMFLR -id $FLR_Session.flrSessionId -FilePaths /home/bottk/wget-log.2, /home/bottk/tmp1

$restoretask | Get-PPDMactivities

$restoretask = restore-PPDMFLR -id $FLR_Session.flrSessionId -FilePaths /home/bottk/wget-log.2, /home/bottk/tmp1 -targetdirectory /home/bottk/restore1