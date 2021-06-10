# Kubernetes Examples

## Demo Walktrough for POPUP Sesssion
### installing ppdm-pwsh

```powershell
install-module ppdm-pwsh -AllowPrerelease
Import-Module PPDM-pwsh
```
see available Commands
```Powershell
Get-command -Module ppdm-pwsh
```

### connecting to API Endpoint
```Powershell
$PPDM_API_URI="https://ppdmazs1.local.cloudapp.azurestack.external"
$API=Connect-PPDMapiEndpoint -PPDM_API_URI $PPDM_API_URI -trustCert
```
### Show some assets and Inventory Sources
Move around some Basic Commands, explain Pipelining
```
Get-PPDMconfigurations
Get-PPDMconfigurations | Get-PPDMconfigstatus
Get-PPDMassets
Get-PPDMinventory_sources
```


### creating a Kubernetes Protection Policy
explaining inline Helps
```Powershell
get-help New-PPDMK8SBackupPolicy
get-help New-PPDMK8SBackupPolicy -Examples
get-help Add-PPDMinventory_sources -Examples
```

### Creating a new Credential from a service account token

in k9s all, show  secret.
Note, in my env, secrets rotate and get published top an S3 Bucket

```Powershell
$aks_cluster="aksazs1"
$tokenfile=(Get-Item \\nasug.home.labbuildr.com\minio\aks\$aks_cluster\ppdmk8stoken* | Sort-Object -Descending -Property LastWriteTime  | Select-Object -First 1).FullName
$Securestring=ConvertTo-SecureString -AsPlainText -String "$(Get-Content $tokenfile -Encoding utf8)" -Force
$username="limitedadmin"
$Credentials = New-Object System.Management.Automation.PSCredential($username, $Securestring)
$newcreds=New-PPDMcredentials -name $aks_cluster -type KUBERNETES -authmethod TOKEN -credentials $Credentials
$newcreds
```
### Approve the Certifikates for the K8S Cluster

```Powershell
$myHost="$aks_cluster.local.cloudapp.azurestack.external"
Get-PPDMcertificates -newhost $myHost -Port 443 | Approve-PPDMcertificates
```

### Add K8S Cluster as inventory Source
```Powershell
Add-PPDMinventory_sources -Type KUBERNETES -Hostname $myHost -Name $aks_cluster -ID $newcreds.id -port 443
```
oh, yes, we have a K8S Endpoint :-)
```Powershell
Get-PPDMkubernetes_clusters -Verbose
```
### Create the Protection Policy
```Powershell
get-help New-PPDMK8SBackupPolicy -Examples
$Storage_system=Get-PPDMstorage_systems | where type -match DATA_DOMAIN_SYSTEM
$Storage_system
$Schedule=New-PPDMBackupSchedule -hourly -CreateCopyIntervalHrs 2 -RetentionUnit DAY -RetentionInterval 7
$Schedule | Convertto-Json -Depth 6
$Policy=New-PPDMK8SBackupPolicy -Schedule $Schedule -StorageSystemID $Storage_system.id -enabled -encrypted -Name CI_K8S_CLI
```
### Assign Assets to PLC

```Powershell
Get-PPDMassets | ft
Get-PPDMassets | where { $_.name -match "wordpress" }
$AssetID=(Get-PPDMassets | where { $_.name -match "wordpress" -and $_.subtype -eq "K8S_NAMESPACE"}).id
$AssetID
Add-PPDMProtection_policy_assignment -AssetID $AssetID -id $Policy.id
```
### Start the Protection of an asset
```Powershell
get-help Start-PPDMprotection
Start-PPDMprotection -PolicyObject $Policy -AssetIDs  $Asset.id
Get-PPDMactivities -PredefinedFilter QUEUED
```

Happy ? Happy !!!

## Lets do a Restore !!!
We have multiple ways to restore a k8s Application / Namespace
In the First Example, we restore to a new , Vanilla AKS Cluster

we use 
```Powershell
$aks_cluster="aksazs2"
```
and start the registration from above

once the cluster is registerd, prepare you restore

```Powershell
$targetInventorySourceID=(Get-PPDMkubernetes_clusters | where name -Match $aks_cluster).id
$myDate=(get-date).AddHours(-2)
$usedate=get-date $myDate -Format yyyy-MM-ddThh:mm:ssZ
$filter= 'endTime ge "'+$usedate+'"'
$Asset=(Get-PPDMassets | where { $_.name -eq "wordpress" -and $_.subtype -eq "K8S_NAMESPACE"})
$copy=Get-PPDMassetcopies -AssetID $Asset.id -filter $filter | Select-Object -First 1
```
That should give you a valid copy
Restore to the New Cluster:
```Powershell
Restore-PPDMK8Scopies -CopyObject $copy -includeClusterResources -TO_ALTERNATE -namespace wordpress -targetInventorySourceId $targetInventorySourceID 
```






## Example Backup with Kubernetes Protection Policies
![image](https://user-images.githubusercontent.com/8255007/97606694-5ef75b00-1a10-11eb-87fd-4926dd327082.png)

In this Use Case, we have one Protection Policy for Kubernetes.
To get a Protection Policy for Kubernetes using powersherll, type

```Powershell
Get-PPDMprotection_policies | where assetType -eq Kubernetes
```



you could ALSO scope the where-object to the name Parameter, in my Case i match to find *Kube Backup Platform Services*


```Powershell
Get-PPDMprotection_policies | where name -Match "Platform Services"
```

The return object in both cases could be one or multiple objects, so you might identify the correct id

As the modules support Pipelining based on Pareameters, we can simply  start the backup for the Policy by 
```Powershell
Get-PPDMprotection_policies | where name -Match "Platform Services" | Start-PPDMprotection_policies
```
Or, symply start non-empty K8S Policies:
```Powershell
Get-PPDMprotection_policies | where { $_.assetType -eq "Kubernetes" -and $_.summary.numberOfAssets -gt 0 } | Start-PPDMprotection_policies
```

The Protection Policy will then fist be Queued. We can check with the command:
```Powershell
Get-PPDMactivities -PredefinedFilter QUEUED
```

![image](https://user-images.githubusercontent.com/8255007/97600368-446db380-1a09-11eb-9c1a-a7055ada9e19.png)

With the ID from Above, you could also query the activity:
```Powershell
Get-PPDMactivities -id 2ce49319-0cf5-49e9-a20f-5c50f4d4ed89
```

![image](https://user-images.githubusercontent.com/8255007/97601290-50a64080-1a0a-11eb-919e-ee4c9a7bc125.png)

in this case, we detect a failed activity.

we can, of course, use Get-PPDMactivities to detect Failed an Retryable Protections
```Powershell
Get-PPDMactivities -PredefinedFilter PROTECT_FAILED -days 1|  where { $_.actions.retryable -eq "True" }
```

![image](https://user-images.githubusercontent.com/8255007/97602795-06be5a00-1a0c-11eb-8a81-580c016b81b4.png)

to just retry the operation, we would use Restart-PPDMactivities and give any retryable Activity to it:
```Powershell
Get-PPDMactivities -PredefinedFilter PROTECT_FAILED -days 1|  where { $_.actions.retryable -eq "True" } | Restart-PPDMactivities
```

![image](https://user-images.githubusercontent.com/8255007/97603118-63ba1000-1a0c-11eb-931a-782af23da9e7.png)


and very a running avtivity by either suing the new activity is, or scope a query to running:
```Powershell
Get-PPDMactivities -PredefinedFilter RUNNING
```
![image](https://user-images.githubusercontent.com/8255007/97603502-ca3f2e00-1a0c-11eb-8c85-f4f85eb43deb.png)


i can now scope the activities "finder" to find the First Object on teh Succeded Policies and veryfy it is the same

```Powershell
Get-PPDMactivities -PredefinedFilter PROTECT_OK -days 1 | Select-Object -First 1
```


![image](https://user-images.githubusercontent.com/8255007/97605261-b7c5f400-1a0e-11eb-9465-7ef3b0d0a93f.png)
