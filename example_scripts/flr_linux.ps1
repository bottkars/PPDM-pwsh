

$AssetCopy=Get-PPDMassets -filter 'name eq "openhab2"' | Get-PPDMassetcopies -filter 'state eq "IDLE"' | Select-Object -First 1
$FLR_Session=Start-PPDMflr_sessions -targetVmAssetId $AssetCopy.assetId -copyId $AssetCopy.id -Verbose
Get-PPDMflr_sessions -id $FLR_Session.flrSessionId -retries 5 -timeout 30