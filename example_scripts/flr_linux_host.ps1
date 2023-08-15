


$RestoreFromHost = "ESSFqESc8r1dX.home.labbuildr.com"

$RestoreToHost_Name = "ESSFqESc8r1dX.home.labbuildr.com"




Connect-PPDMsystem -trustCert -PPDM_API_BaseURI ppdmavs01.edub.csc
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
$RestoredCopy = New-PPDMRestored_copies -copyobject $RestoreAssetCopy -Hostid $RestoreToHost.id
do {
  Start-Sleep -Seconds 10
  Write-Host -NoNewline "."    
  $MountedCopy = $RestoredCopy | Get-PPDMRestored_copies
}
until ($MountedCopy.status -eq "SUCCESS") 

# Get the Base Browse list, e.g Mountrrot Directory for FLR, wich is .basepath, as well ass the volumes, as .sources
$Parameters = @{
  HostID              = $RestoreToHost.id
  mountURL            = $MountedCopy.restoredCopiesDetails.targetFileSystemInfo.mountUrl
  BackupTransactionID = $RestoreAssetCopy.backupTransactionId
}
$BaseBrowselist = Get-PPDMFSAgentFLRBrowselist @Parameters
$BaseBrowselist

# Browse the Volumes for Content, retrieving a Browselist .Path as the base for to restored Directories 

$Parameters = @{
  HostID              = $RestoreToHost.id
  mountURL             = "$($BaseBrowselist.basePath)/$($Browselist.sources[0])"
  BackupTransactionID = $RestoreAssetCopy.backupTransactionId
}
$Browselist = Get-PPDMFSAgentFLRBrowselist @Parameters
$Browselist


$Parameters = @{
  CopyObject           = $RestoreAssetCopy
  HostID               = $RestoreToHost.id 
  RestoreLocation      = "/tmp"
  RetainFolderHierachy = $true
  conflictStrategy     = "TO_ALTERNATE" 
  RestoreSources       = @("$($Browselist.path)/home/bottk", "$($Browselist.path)/root")
  CustomDescription    = "Restore from Powershell"
  Verbose              = $false
}

$Restore = Restore-PPDMFileFLR_copies @Parameters
$Restore | Get-PPDMactivities

