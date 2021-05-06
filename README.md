# PPDM-pwsh
![ppdm19 6](https://user-images.githubusercontent.com/8255007/97328230-186df900-1876-11eb-8ad4-4feed5dac316.gif)

## :heart: Powershell Modules for DellEMC PowerProtect DataManager API :heart:


:sunrise: This is a Pre-Release Version :sunrise:



## installing the Module

the module should be installed from [PSgallery](https://www.powershellgallery.com/packages/PPDM-pwsh/)
```Powershell
Install-Module -Name PPDM-pwsh	
```

:stuck_out_tongue: Install the Pre-Release Version:
```Powershell
Install-Module PPDM-pwsh -AllowPrerelease -MinimumVersion 19.8
```

We need to initially load the Module and connect to the API Endpoint:
### Loading the Module
```Powershell
ipmo .\PPDM-pwsh -Force
Connect-PPDMapiEndpoint -PPDM_API_URI https://<your ppdm server> -user -trustCert -Verbose
```
this uses a user password authentication. the token is saved as a Global Variable.
You also can use a secure Credentials string to connect. Credentials will be stored in Session ofr easy reconnect

## :stuck_out_tongue: Backups ! :stuck_out_tongue:

### Get configured Protection Policies
```Powershell
 Get-PPDMprotection_policies | ft
```
![image](https://user-images.githubusercontent.com/8255007/97300880-4e4fb500-1857-11eb-9632-c1c7c4b07157.png)


### Start a Protection Policy (ad-Hoc Backup) by an ID
```Powershell
Start-PPDMprotection_policies -PolicyID <ID>
```

### Start Protection Policy based on Pipeline Query
this starts the Policy that matches the name Exchange and is not Self Service
```Powershell
Get-PPDMprotection_policies | where { ($_.name -match "Exchange") -and ($_.passive -eq $False) } | Start-PPDMprotection_policies
```

### :star: Query the Queued activity
```Powershell
Get-PPDMactivities -days 1 -PredefinedFilter QUEUED
```
![image](https://user-images.githubusercontent.com/8255007/97305950-0d0ed380-185e-11eb-9340-a4bc607082e9.png)

### :star: Query Finished Successfull Activities, query for "Manual" in name
```Powershell
Get-PPDMactivities -days 1 -PredefinedFilter PROTECT_OK -query Manual | ft
```

![image](https://user-images.githubusercontent.com/8255007/97305737-d0db7300-185d-11eb-868e-a74d6999ea5d.png)



## working with assets

### getting all assets
```Powershell
Get-PPDMassets | ft
```
### getting specific asset(s)
now we want to see a specific asset
```Powershell
Get-PPDMassets | where name -eq dcnode
``` 
And finally view the Storage and Replica Locations .....

### Get a map of PPDM Copies per Asset ID
```Powershell
(Get-PPDMassets | where name -eq dcnode | Get-PPDMcopy_map).storagelocations
```

## Some other Commands
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

# :new: :star: Protection Policy Creation


##
Create a Centralized Exchange Backup Policy
In order to create a Primary Backup for Exchange, we fisrt need to create a Schdule locally
Schedules for Primary Backup set the Time / Window for Synthetic Fulls, and Optionally
the Time For FULLS 

```Powershell
$schedule=New-PPDMBackupSchedule -hourly_w_full_weekly -CreateCopyIntervalHrs 2 -CreateFull_Every_DayofWeek SUNDAY -RetentionUnit DAY -RetentionInterval 7 
```
this Translates into a Primary PPDM Backup Schedule as follows:

![image](https://github.com/bottkars/bottkars.github.io/raw/master/images/PPDM_NEW_SCHEDULE.png)

Now we can set the Backup Policy with Above Schedule, and control Exchange Specific Feature
```Powershell
New-PPDMExchangeBackupPolicy -Schedule $sched -StorageSystemID ed9a3cd6-7e69-4332-a299-aaf258e23328 -consistencyCheck LOGS_ONLY -enabled -encrypted -Name CI_EX_CLI_CENTRAL2
```

# :star: :star: :star:Monitor activities

## get activity Metrics

```Powershell
Get-PPDMactivity_metrics
```
this gets all metrics of the actual day, us -days parameters for extended list

## :bomb: get failed activities
Things can fail, i want to know !
```Powershell
Get-PPDMactivities  -query Kubernetes -days 14 -PredefinedFilter PROTECT_FAILED | Select-Object name, id -ExpandProperty result
```
### Custom Filters
From above, we can see that predefined query filters are used.
PowerProtect comes with it´s own query filters, see more 
from 
```Powershell
Get-Help Get-PPDMactivities -Online
```
You can use your own Filters:


```Powershell
# get a date stamp from -1 week ( Adjust to you duration)
$myDate=(get-date).AddDays(-7)
$usedate=get-date $myDate -Format yyyy-MM-ddThh:mm:ssZ

# all protection Jobs last week
$FILTER='startTime ge "'+$usedate+'" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CLOUD_TIER","EXPORT_REUSE","PROTECT","REPLICATE","RESTORE","CLOUD_PROTECT")'
Get-PPDMactivities -Filter $FILTER  | Select-Object * -ExpandProperty result | ft 

# all failed last week
$FILTER='startTime ge "'+$usedate+'" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CLOUD_TIER","EXPORT_REUSE","PROTECT","REPLICATE","RESTORE","CLOUD_PROTECT") and result.status eq "FAILED"'
Get-PPDMactivities -Filter $FILTER  | Select-Object * -ExpandProperty result | ft 

# Protect SUCCEEDED
$FILTER='result.status in  ("OK","OK_WITH_ERRORS") and startTime ge "'+$usedate+'" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("PROTECT")'
Get-PPDMactivities -Filter $FILTER  | Select-Object * -ExpandProperty result | ft 


# filter for failed system jobs
$FILTER='startTime ge "'+$usedate+'" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CONSOLE","CONFIG","CLOUD_DR","CLOUD_COPY_RECOVER","DELETE","DISASTER_RECOVERY","DISCOVER","MANAGE","NOTIFY","SYSTEM","VALIDATE") and result.status eq "FAILED"'

# filter for Successfull system:
$FILTER='startTime ge "'+$usedate+'" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CONSOLE","CONFIG","CLOUD_DR","CLOUD_COPY_RECOVER","DELETE","DISASTER_RECOVERY","DISCOVER","MANAGE","NOTIFY","SYSTEM","VALIDATE") and result.status eq "OK"'
```





