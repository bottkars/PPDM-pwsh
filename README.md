# PPDM-pwsh

Powershell Prototype for DellEMC PowerProtect DataManager  API
```


### examles
```Powershell
ipmo .\PPDM-pwsh -Force
Connect-PPDMapiEndpoint -PPDM_API_URI https://ppdm.home.labbuildr.com -user -trustCert -Verbose
```

```Powershell
Start-PPDMprotection_policies -PolicyID 4f8ee8f7-68ef-4c09-8789-17301e82be3a -Verbose
Get-PPDMassets | ft
Get-PPDMactivities  | ft
Get-PPDMactivities  -query Kubernetes -Verbose | ft
```

```Powershell
Get-PPDMinventory_sources | ft
Get-PPDMprotection_policies | ft
Start-PPDMprotection_policies -PolicyID 4f8ee8f7-68ef-4c09-8789-17301e82be3a
Get-PPDMactivities -Filter RUNNING | ft
Get-PPDMactivities  -query Kubernetes -Filter RUNNING | ft
Get-PPDMprotection_policies | ft
 (Get-PPDMprotection_policies -id 200fb9c7-22a8-406b-b495-b6d6457de034).stages | ft
```
# storage
```powershell
Get-PPDMstorage_systems
Get-PPDMdatadomain_cloud_units -storageSystemId ed9a3cd6-7e69-4332-a299-aaf258e23328
```


# Get a map of PPDM COpies per Asset ID
```Powershell
(Get-PPDMcopy_map -id 64639e28-97ab-5c97-879d-52641074abde).storageLocations
```
# Monitor activities

```Powershell
## get a date stamp from -1 week ( Adjust to you duration)
$myDate=(get-date).AddDays(-7)
$usedate=get-date $myDate -Format yyyy-MM-ddThh:mm:ssZ

# all protection Jobs last week
$FILTER='startTime ge "'+$usedate+'" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CLOUD_TIER","EXPORT_REUSE","PROTECT","REPLICATE","RESTORE","CLOUD_PROTECT")'
Get-PPDMactivities -Filter $FILTER  | Select-Object * -ExpandProperty result | ft 

# all failed last week
$FILTER='startTime ge "'+$usedate+'" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CLOUD_TIER","EXPORT_REUSE","PROTECT","REPLICATE","RESTORE","CLOUD_PROTECT") and result.status eq "FAILED"'
Get-PPDMactivities -Filter $FILTER  | Select-Object * -ExpandProperty result | ft 

## Protect SUCCEEDED
$FILTER='result.status in  ("OK","OK_WITH_ERRORS") and startTime ge "'+$usedate+'" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("PROTECT")'
Get-PPDMactivities -Filter $FILTER  | Select-Object * -ExpandProperty result | ft 
```

# filter for failed system jobs
```Powershell
$FILTER='startTime ge "'+$usedate+'" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CONSOLE","CONFIG","CLOUD_DR","CLOUD_COPY_RECOVER","DELETE","DISASTER_RECOVERY","DISCOVER","MANAGE","NOTIFY","SYSTEM","VALIDATE") and result.status eq "FAILED"'
```
 # filter for Successfull system:

```Powershell
$FILTER='startTime ge "'+$usedate+'" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CONSOLE","CONFIG","CLOUD_DR","CLOUD_COPY_RECOVER","DELETE","DISASTER_RECOVERY","DISCOVER","MANAGE","NOTIFY","SYSTEM","VALIDATE") and result.status eq "OK"'
```





