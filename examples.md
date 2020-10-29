

$API=Connect-PPDMapiEndpoint -PPDM_API_URI https://ppdm.home.labbuildr.com -user -trustCert
Get-PPDMprotection_policies | ft
Get-PPDMprotection_policies | where name -match kube


(Get-PPDMprotection_policies | where name -match kube | Get-PPDMprotection_policies -asset_assignments).details.k8s

Get-PPDMprotection_policies | where name -match kube | Start-PPDMprotection_policies

Get-PPDMactivities -PredefinedFilter QUEUED -days 1 | ft

Get-PPDMactivities -PredefinedFilter RUNNING -days 1 | ft

Get-PPDMactivities -id