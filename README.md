# PPDM-pwsh

Powershell Prototype for DellEMC PowerProtect DataManager  API
```


### examles
Connect-PPDMapiEndpoint -PPDM_API_URI https://ppdm.home.labbuildr.com -user -trustCert -Verbose
Start-PPDMprotection_policies -PolicyID 4f8ee8f7-68ef-4c09-8789-17301e82be3a -Verbose
Get-PPDMassets | ft
Get-PPDMactivities  | ft
Get-PPDMactivities  -query Kubernetes -Verbose | ft



Get-PPDMinventory_sources | ft
Get-PPDMprotection_policies | ft
Start-PPDMprotection_policies -PolicyID 4f8ee8f7-68ef-4c09-8789-17301e82be3a
Get-PPDMactivities -Filter RUNNING | ft
Get-PPDMactivities  -query Kubernetes -Filter RUNNING | ft
