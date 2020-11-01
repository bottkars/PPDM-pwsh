$ovapath="$HOME/Downloads/dellemc-ppdm-sw-19.6.0-3.ova"
$env:GOVC_FOLDER='/home_dc/vm/labbuildr_vms'
$env:GOVC_VM='ppdm_demo'
$env:GOVC_DATASTORE='vsanDatastore'
$env:GOVC_HOST='/home_dc/host/home_cluster/e200-n4.home.labbuildr.com'
write-Host "Reading OVA Spec"
$SPEC=govc import.spec $ovapath| ConvertFrom-Json -Depth 7
$SPEC.DiskProvisioning="thin"
# IP Address for your new PPDM 
$SPEC.PropertyMapping[0].Key='vami.ip0.brs'
$SPEC.PropertyMapping[0].Value='100.250.1.123'
# Default Gateway
$SPEC.PropertyMapping[1].Key='vami.gateway.brs'
$SPEC.PropertyMapping[1].Value = "100.250.1.1" 
# Subnet Masek               
$SPEC.PropertyMapping[2].Key = "vami.netmask0.brs"
$SPEC.PropertyMapping[2].Value = "255.255.255.0" 
# DNS Servers
$SPEC.PropertyMapping[3].Key = "vami.DNS.brs"
$SPEC.PropertyMapping[3].Value = "192.168.1.44" 
# you FQDN, make sure it is resolvable from above DNS
$SPEC.PropertyMapping[4].Key = "vami.fqdn.brs"
$SPEC.PropertyMapping[4].Value = "ppdmdemo.home.labbuidr.com"    


$SPEC | ConvertTo-Json | Set-Content -Path spec.json
Write-Host "Importing OVA, this will take a while ..."
govc import.ova -name $env:GOVC_VM -options="./spec.json" $ovapath 
govc vm.network.change -net=VLAN250 ethernet-0
# $CPU=govc vm.change -c=0
Write-Host "Powering on vm $env:GOVC_VM"
govc vm.power -on $env:GOVC_VM


$API=Connect-PPDMapiEndpoint -PPDM_API_URI https://ppdm-demo.home.labbuildr.com -user -trustCert -force -Verbose
Approve-PPDMEula
# Get-PPDMTimezones | where id -match Berlin
Set-PPDMconfigurations -NTPservers 139.162.149.127 -Timezone "Europe/Berlin" -admin_Password 'Password123!'
Get-PPDMconfigurations | Get-PPDMconfigstatus
