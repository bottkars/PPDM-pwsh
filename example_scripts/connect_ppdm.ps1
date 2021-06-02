# Admin Password for fresh install is admin
$API=Connect-PPDMapiEndpoint -PPDM_API_URI https://ppdmazs1.local.cloudapp.azurestack.external -trustCert -force
$Eula=Approve-PPDMEula
$timezone=(Get-PPDMTimezones | Where-Object id -match Berlin).id
$SecurePassword = Read-Host -Prompt "Enter new Password for user 'admin'" -AsSecureString
Set-PPDMconfigurations -NTPservers 192.168.1.44 -Timezone $timezone -admin_Password $SecurePassword
Get-PPDMconfigurations | Get-PPDMconfigstatus

$ID=(Get-PPDMconfigurations).id

while ((Get-PPDMconfigstatus -id $ID).status -ne "SUCCESS" ) {
    Write-Host " Waiting for Appliance to reach status Success, currently at $((Get-PPDMconfigstatus -id $ID).percentageCompleted)% "
    start-sleep  20
} 

Write-Host    "Appliance Configured Successfully"