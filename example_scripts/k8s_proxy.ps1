## Deploy a Kubernetes Proxy on a ESX Host
$NetworkMoref=((Get-PPDMhosts -hosttype ESX_CLUSTER -filter 'name eq "K8-TEST"').details.esxcluster.networks | where name -eq MGMT-v328).moref
$HostMoref=(Get-PPDMhosts -hosttype ESX_HOST -filter 'name eq "esxgy85.xiolab.lab.emc.com"' ).details.esxhost.hostMoref
$VCenterID=(Get-PPDMinventory_sources -Type VCENTER -filter 'name eq "vcenter-01"').id
$DatastoreMoref=(Get-PPDMvcenterDatastores -id $VCenterID -clusterMOREF $clusterMoref | where name -match vsanDatastore).moref
$VPE=(Get-PPDMprotection_engines -Type VPE).ID

New-PPDMProxy -VPE $VPE `
    -ProtectionType Kubernetes `
    -fqdn ppdm-vproxy02.xiolab.lab.emc.com `
    -IPAddress 10.55.28.42 `
    -gateway 10.55.28.1 `
    -netmask 255.255.255.0 `
    -PrimaryDNS 10.55.234.250  `
    -vCenterID $VCenterID `
    -HostMoref $HostMoref `
    -DatastoreMoref $DatastoreMoref `
    -NetworkMoref $NetworkMoref