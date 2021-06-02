$DDVE_HOST="ddveazs1.azsdps.labbuildr.com"

Get-PPDMcertificates -newhost $DDVE_HOST -Port 3009 | Approve-PPDMcertificates
New-PPDMcredentials -name sysadmin -type DATADOMAIN | Add-PPDMinventory_sources -Hostname $DDVE_HOST -Type EXTERNALDATADOMAIN -Name $DDVE_HOST -port 3009 
Get-PPDMserver_disaster_recovery_configurations | Set-PPDMserver_disaster_recovery_configurations -repositoryHost $DDVE_HOST -repositoryPath /data/col1/ppdmazs1 -Type DD -backupsEnabled