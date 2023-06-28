


$RestoreFromHost = "sqlsinglenode.dpslab.home.labbuildr.com"

$RestoreToHost_Name = "sqlsinglenode.dpslab.home.labbuildr.com"

$AppServerName = "MSSQLDPSLAB"
$DataBaseName = "AdventureWorks2019"

connect-pPDMapiEndpoint -trustCert -PPDM_API_BaseURI ppdmavs01.edub.csc
$RestoreFromHost = "WhqNQLqCLJ2yw.edub.csc"
$RestoreToHost_Name = "bM10k2Mjn53aO.edub.csc"



### Get all linux Hosts with FLR Agent
$Appfilter = 'attributes.appHost.appServerTypes eq "MSSQL" and not (lastDiscoveryStatus eq "DELETED") and details.appHost.os lk "WINDOWS" and details.appHost.phase eq "NONE"'
Get-PPDMhosts -filter $AppFilter
$RestoreHostFilter = 'attributes.appHost.appServerTypes eq "MSSQL" and not (lastDiscoveryStatus eq "DELETED") and details.appHost.os lk "WINDOWS" and details.appHost.phase eq "NONE" and hostname eq "' + $RestoreToHost_Name + '"'
$RestoreToHost = Get-PPDMhosts -filter $RestoreHostFilter

$RestoreAssetFilter = 'type eq "MICROSOFT_SQL_DATABASE" and protectionStatus eq "PROTECTED" and details.database.clusterName eq "' + $RestoreFromHost + '"' + ' and details.database.appServerName eq "' + $AppServerName + '"'
$RestoreAssetFilter = 'protectionStatus eq "PROTECTED" and details.fileSystem.hostName eq  "' + $RestoreFromHost + '"'

$RestoreAssets = Get-PPDMAssets -Filter $RestoreAssetFilter
$RestoreAssets = $RestoreAssets | Where-Object name -Match $DataBaseName



write-host "Selecting Asset-copy for $DataBaseName"
$myDate = (get-date).AddDays(-1)
$usedate = get-date $myDate -Format yyyy-MM-ddThh:mm:ssZ
$RANGE_FILTER = 'startTime ge "' + $usedate + '"state eq "IDLE"'
$RestoreAssets | Get-PPDMassetcopies -filter $RANGE_FILTER
$RestoreAssetCopy = $RestoreAssets | Get-PPDMassetcopies -filter $RANGE_FILTER | Select-Object -First 1







$Parameters = @{
  HostID               = $RestoreToHost.id 
  appServerId          = $RestoreAssets.details.database.appServerId
  ids                  = $RestoreAssetCopy.id
  assetName            = $RestoreAssetCopy.assetName
  enableDebug          = $false
  disconnectDatabaseUsers = $true
  restoreType          = "TO_ALTERNATE" 
  CustomDescription    = "Restore from Powershell"
  Verbose              = $false
}

$Restore = Restore-PPDMMSSQL_copies @Parameters

