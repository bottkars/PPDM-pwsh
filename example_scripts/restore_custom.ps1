$API=Connect-PPDMapiEndpoint -PPDM_API_BaseURI https://ppdm.home.labbuildr.com -trustCert
$Asset = Get-PPDMassets -filter 'type eq "VMWARE_VIRTUAL_MACHINE" and protectionStatus eq "PROTECTED" and name eq "ppdm-demo"'
$copyobject = $asset | Get-PPDMassetcopies
Restore-PPDMVMAsset -CopyObject $copyobject -recoverConfig -TO_PRODUCTION -Description "Ticket ID: 07f" -noop -Verbose