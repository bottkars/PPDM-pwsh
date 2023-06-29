


$RestoreFromHost = "nqh66pb6tgsw2.home.labbuildr.com"

$RestoreToHost_Name = "nqh66pb6tgsw2.home.labbuildr.com"




connect-pPDMapiEndpoint -trustCert -PPDM_API_BaseURI ppdmavs01.edub.csc
$RestoreFromHost = "WhqNQLqCLJ2yw.edub.csc"
$RestoreToHost_Name = "bM10k2Mjn53aO.edub.csc"



### Get all linux Hosts with FLR Agent
$linuxfilter = 'attributes.appHost.appServerTypes eq "FS" and not (lastDiscoveryStatus eq "DELETED") and details.appHost.os lk "linux" and details.appHost.phase eq "NONE"'
Get-PPDMhosts -filter $linuxfilter
$RestoreHostFilter = 'attributes.appHost.appServerTypes eq "FS" and not (lastDiscoveryStatus eq "DELETED") and details.appHost.os lk "linux" and details.appHost.phase eq "NONE"and hostname eq "' + $RestoreToHost_Name + '"'
$RestoreToHost = Get-PPDMhosts -filter $RestoreHostFilter

$RestoreAssetFilter = 'type eq "FILE_SYSTEM" and protectionStatus eq "PROTECTED" and details.fileSystem.hostName eq  "' + $RestoreFromHost + '"'
$RestoreAssets = Get-PPDMAssets -Filter $RestoreAssetFilter


write-host "Selecting Asset-copy for $RestoreFromHost"
$myDate = (get-date).AddDays(-1)
$usedate = get-date $myDate -Format yyyy-MM-ddThh:mm:ssZ
$RANGE_FILTER = 'startTime ge "' + $usedate + '"state eq "IDLE"'
$RestoreAssets | Get-PPDMassetcopies -filter $RANGE_FILTER
$RestoreAssetCopy = $RestoreAssets | Get-PPDMassetcopies -filter $RANGE_FILTER | Select-Object -First 1
$RestoredCopy = New-PPDMRestored_copies -ids $RestoreAssetCopy.id -assetName $RestoreAssetCopy.assetName -Hostid $RestoreToHost.id

do {
  Start-Sleep -Seconds 10    
  $MountedCopy = $RestoredCopy | Get-PPDMRestored_copies
}
until ($MountedCopy.status -eq "SUCCESS") 

$Parameters = @{
  HostID               = $RestoreToHost.id
  BackupTransactionID  = $RestoreAssetCopy.backupTransactionId
  Hostpath             = "/home/bottk"
  mountURL             = $MountedCopy.restoredCopiesDetails.targetFileSystemInfo.mountUrl
  RestoreAssetHostname = $RestoreFromHost
}
$Browselist = Get-PPDMFSAgentFLRBrowselist @Parameters
$Browselist.files


$Parameters = @{
  CopyObject           = $RestoreAssetCopy
  HostID               = $RestoreToHost.id 
  #BackupTransactionID  = $RestoreAssetCopy.backupTransactionId
  #ids                  = $RestoreAssetCopy.id
  RestoreAssetHostname = $RestoreFromHost
  #assetName            = $RestoreAssetCopy.assetName
  RestoreLocation      = "/tmp"
  RetainFolderHierachy = $true
  conflictStrategy     = "TO_ALTERNATE" 
  RestoreSources       = "/home/bottk, /root"
  CustomDescription    = "Restore from Powershell"
  Verbose              = $false
}

$Restore = Restore-PPDMFileFLR_copies @Parameters

