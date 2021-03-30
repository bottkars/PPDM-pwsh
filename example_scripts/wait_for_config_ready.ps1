

$ID=(Get-PPDMconfigurations).id

while ((Get-PPDMconfigstatus -id $ID).status -ne "SUCCESS" ) {
    Write-Host " Waiting for Appliance to reach status Success, currently at $((Get-PPDMconfigstatus -id $ID).percentageCompleted)% "
    start-sleep  20
} 

Write-Host    "Appliance Configured Successfully"