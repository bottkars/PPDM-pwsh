

$RestoreFromHost = "sqlsinglenode.dpslab.home.labbuildr.com"
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

