$API=Connect-PPDMapiEndpoint -PPDM_API_URI https://ppdm-demo.home.labbuildr.com -trustCert -force 
Approve-PPDMEula
$timezone=(Get-PPDMTimezones | Where-Object id -match Berlin).id
Set-PPDMconfigurations -NTPservers 139.162.149.127 -Timezone $timezone -admin_Password 'Password123!'
Get-PPDMconfigurations | Get-PPDMconfigstatus
