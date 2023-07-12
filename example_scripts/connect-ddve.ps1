# If this is the First DD added to PPDM, it will be automatically configured with SysDR
$DDVE_HOST="ddveazs1.azsdps.labbuildr.com"

Get-PPDMcertificates -newhost $DDVE_HOST -Port 3009 | Approve-PPDMcertificates
New-PPDMcredentials -name sysadmin -type DATADOMAIN | Add-PPDMinventory_sources -Hostname $DDVE_HOST -Type EXTERNALDATADOMAIN -Name $DDVE_HOST -port 3009 
