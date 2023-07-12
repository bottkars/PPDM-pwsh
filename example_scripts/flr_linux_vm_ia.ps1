connect-pPDMapiEndpoint -trustCert -PPDM_API_BaseURI ppdm-daily.home.labbuildr.com
$RestoreClient = "openhab2"
$username = Read-Host -Prompt "Please Enter Restore Clients Username"
$SecurePassword = Read-Host -Prompt "Enter Password for user $username" -AsSecureString
$Credentials = New-Object System.Management.Automation.PSCredential($username, $Securepassword)

$Filter = 'name eq "' + $RestoreClient + '"'
write-host "Selecting Asset-copy for $RestoreClient"
$AssetCopy = Get-PPDMassets -filter $FILTER | Get-PPDMassetcopies -filter 'state eq "IDLE"' | Select-Object -First 1
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