# PPDM-pwsh

## :heart: THE Powershell Modules for Dell PowerProtect DataManager API :heart:


:sunrise: This is the 19.14 Vesrion :sunrise:



## installing the Module and connecting to PPDM

the module should be installed from [PSgallery](https://www.powershellgallery.com/packages/PPDM-pwsh/)
```Powershell
Install-Module -Name PPDM-pwsh	-MinimumVersion 19.14.20
```
connect to the API Endpoint:

```Powershell
ipmo .\PPDM-pwsh -Force
Connect-PPDMapiEndpoint -PPDM_API_URI https://<your ppdm server> -trustCert
```
this will do an interactive password/authentication to retrieve the token. The login can alos be done via a PSCredential object.  
The token is saved as a Global Variable.

# Workload Examples

This section gives Some Examples for Workloads. Most of the Examples are also available from the Inline Help, e.g. 
```Pwsh
get-help New-PPDMProtectionEngineProxy -Examples 
```
## VMware Protection
Example for vMware Based Protections, Policies   
[VM Restore from CLI](./Demos/01.%20VM%20Restore%20from%20CLI.md)    
[VM Instant Access Restore LINUX VM](./example_scripts/flr_linux_vm_ia.ps1)  
[Example Script Custom Restore Text](./example_scripts/restore_custom.ps1)  
[Example script to exclude Disks from VM Asset](./example_scripts/modify_assets_disks.ps1)
[Create AppAware MSSQL Protection using Transparent Snapshots](./Demos/06.%20Create%20APP_AWARE%20SQL.md)  

## Kubernetes Protection
Examples for Kubernetes Onboarding, Protection and restores  
[Kubernetes Protection](./Demos/05.%20kubernetes_protection_example.md)  
[Example script to exclude PVC with Storage certain Classes](./example_scripts/modify_pvc_exludes_by_storageclass.ps1)  

## Agent Protection
Examples for Managing Agent Based Protection and Policies  
[FSAgent Agent](./Demos/02.%20Asset%20Restore%20FLR%20Powershell.md)  
[MSSQL Agent](./Demos/03.%20Asset%20Restore%20MSSQL%20Powershell.md)   
[Create Centralized MSSQL Protection Policy](./Demos/07.%20Create%20Centralized_SQL.md)  
[Create Self Service MSSQL Policy](./Demos/08.%20Create_SelfService_SQL.md)
[Manage Agent Updates](./Demos/99.%20Agent%20Upgrades.md)  

# Management Examples

## Asset Management
Examples for managing Assets  
[Asset Management](./Demos/04.%20Asset%20Management.md)
[Manage AppHosts Preferred IP/Comms Assignment](./Demos/99.%20appHosts.md)

## Manage Common Settings
There are Common Appliance Settings that can be retreive and modified
[View and Modify Common Settings](./Demos/99.%20CommonSettings.md)
## Restore Plans
[Example Script getting Assets protected in restore Plan](./example_scripts/get_assets_protected_in_restore_plan.ps1)  

# Inventory Examples
## Managing / Adding Protection Storage
[Example Script adding a DataDomain](./example_scripts/connect-ddve.ps1)  
The Storage_Systems API has some festures for Capacity Reports // NFS Shares described here   
[Examles for Managing Storage and Capacity](./Demos/10.%20storage.md)  

## Managing vProxies
[Add a Kubernetes Proxy](./example_scripts/k8s_proxy.ps1)  
[Add a vSphereProxy with NBD](./example_scripts/vproxy_nbd.ps1)  

# PPDM Deployment
[Example Script to wait for Appliance Fresh Install State](./example_scripts/wait_ppdm_fresh.ps1)  
[Example Script to start PPDM Initial Configuration](./example_scripts/configure_ppdm.ps1)  
[Example Script to wait for Appliance Configured](./example_scripts/wait_for_config_ready.ps1)   


# Missing and API ? No worries, keep Prototyping

We implemented an Request Wrapper for PPDM API requeststhat utilizes all header ane endpoint variables
```Powershell
NAME
    Invoke-PPDMapirequest

SYNTAX
    Invoke-PPDMapirequest -OutFile <Object> [-uri <Object>] [-Method {Get | Delete | Put | Post | Patch}] [-Query <Object>] [-ContentType <Object>]
    [-ResponseHeadersVariable <Object>] [-apiver <Object>] [-retries <int>] [-timeout <int>] [-apiport <Object>] [-PPDM_API_BaseUri <Object>] [-RequestMethod {Rest | Web}]
    [<CommonParameters>]

    Invoke-PPDMapirequest -uri <Object> -Method {Get | Delete | Put | Post | Patch} -Query <Object> -InFile <Object> [-ContentType <Object>] [-ResponseHeadersVariable
    <Object>] [-apiver <Object>] [-retries <int>] [-timeout <int>] [-apiport <Object>] [-PPDM_API_BaseUri <Object>] [-RequestMethod {Rest | Web}] [<CommonParameters>]

    Invoke-PPDMapirequest -uri <Object> [-Method {Get | Delete | Put | Post | Patch}] [-Query <Object>] [-ContentType <Object>] [-ResponseHeadersVariable <Object>] [-apiver
    <Object>] [-retries <int>] [-timeout <int>] [-apiport <Object>] [-PPDM_API_BaseUri <Object>] [-RequestMethod {Rest | Web}] [-Body <Object>] [-Filter <Object>]
    [<CommonParameters>]
```
Thus, you only need to specify the relative 
```Powershell
Invoke-PPDMapirequest -Method Get -uri /copy-metrics
```
Note, this will utilize a WebRequest per default and thus return a Json Document, including Response Headers, to be converted

One can utilize the RestMethod via
```Powershell
Invoke-PPDMapirequest -Method Get -RequestMethod Rest -uri /copy-metrics
```
This will return only content and page as PSobjects, for Headers a Hedervariable must be requested (only need for some POST request )



# Currently exported Funtions
```Powershell
Add-PPDMAssetSource
Disable-PPDMProxy
Get-PPDMagents
Get-PPDMAssetSource
Get-PPDMFLRfiles
Get-PPDMk8sclusters
Get-PPDMk8spvcmappings
Get-PPDMProxy
Get-PPDMServiceStatus
Get-PPDMStorageMetrics
Get-PPDMVPE
New-PPDMProxy
Remove-PPDMAssetSource
Remove-PPDMProxy
Request-PPDMJobLog
Restore-PPDMDDB_MSSQL
Restore-PPDMFLR
Restore-PPDMVMAsset
Save-PPDMJobLog
Set-PPDMAsset
Set-PPDMAssetSource
Set-PPDMFLRbrowsescope
Start-PPDMPLC
Start-PPDMPLCStage
Start-PPDMProtectionStage
Unregister-PPDMAssetFromPoliy
Add-PPDMcertificates
Add-PPDMinventory_sources
Add-PPDMProtection_policy_assignment
Approve-PPDMcertificates
Approve-PPDMEula
Connect-PPDMapiEndpoint
Disable-PPDMprotectionEngineProxy
Disconnect-PPDMsession
Get-PPDMactivities
Get-PPDMactivity_metrics
Get-PPDMagents_update_sessions
Get-PPDMagent_registration_status
Get-PPDMalerts
Get-PPDMassetcopies
Get-PPDMassets
Get-PPDMasset_protection_metrics
Get-PPDMaudit_logs
Get-PPDMcertificates
Get-PPDMcloud_dr_accounts
Get-PPDMcloud_dr_data_targets
Get-PPDMcloud_dr_server_configuration
Get-PPDMcloud_dr_server_deployment
Get-PPDMcloud_dr_server_version
Get-PPDMcloud_dr_sessions
Get-PPDMcloud_dr_storage_containers
Get-PPDMcloud_dr_vcenters
Get-PPDMcommon_settings
Get-PPDMcomponents
Get-PPDMconfigstatus
Get-PPDMconfigurations
Get-PPDMcopies
Get-PPDMcopy_map
Get-PPDMcredentials
Get-PPDMdatacomponents
Get-PPDMdatadomain_cloud_units
Get-PPDMdatadomain_ddboost_encryption_settings
Get-PPDMdatadomain_mtrees
Get-PPDMdata_targets
Get-PPDMdiscoveries
Get-PPDMdisks
Get-PPDMflr_filelisting
Get-PPDMflr_sessions
Get-PPDMFSAgentFLRBrowselist
Get-PPDMhosts
Get-PPDMinventory_sources
Get-PPDMkubernetes_clusters
Get-PPDMlatest_copies
Get-PPDMlicenses
Get-PPDMlocations
Get-PPDMnodes
Get-PPDMpasswordpolicies
Get-PPDMprotectionEngineProxies
Get-PPDMprotection_details
Get-PPDMprotection_engines
Get-PPDMprotection_groups
Get-PPDMprotection_policies
Get-PPDMprotection_rules
Get-PPDMprotection_storage_metrics
Get-PPDMpvc_storage_class_mappings
Get-PPDMRestored_copies
Get-PPDMrestore_plans
Get-PPDMroles
Get-PPDMrules
Get-PPDMserver_disaster_recovery_backups
Get-PPDMserver_disaster_recovery_configurations
Get-PPDMserver_disaster_recovery_hosts
Get-PPDMserver_disaster_recovery_status
Get-PPDMsmtp
Get-PPDMstorage_systems
Get-PPDMstorage_system_metrics
Get-PPDMTELEMETRY_SETTING
Get-PPDMTimezones
Get-PPDMupgrade_packages
Get-PPDMusers
Get-PPDMuser_groups
Get-PPDMvcenterDatastores
Get-PPDMWebException
Get-PPDMwhitelist
Invoke-PPDMapirequest
New-PPDMBackupSchedule
New-PPDMcredentials
New-PPDMDatabaseBackupSchedule
New-PPDMExchangeBackupPolicy
New-PPDMFSBackupPolicy
New-PPDMK8SBackupPolicy
New-PPDMlocations
New-PPDMProtectionEngineProxy
New-PPDMRestored_copies
New-PPDMserver_disaster_recovery_backups
New-PPDMsmtp
New-PPDMSQLBackupPolicy
New-PPDMusers
New-PPDMVMBackupPolicy
Remove-PPDMagents_update_sessions
Remove-PPDMcdrs
Remove-PPDMcertificates
Remove-PPDMcomponents
Remove-PPDMcopies
Remove-PPDMcredentials
Remove-PPDMflr_sessions
Remove-PPDMinventory_sources
Remove-PPDMlocations
Remove-PPDMProtectionEngineProxy
Remove-PPDMprotection_policies
Remove-PPDMProtection_policy_assignment
Remove-PPDMprotection_rules
Remove-PPDMserver_disaster_recovery_backups
Remove-PPDMsmtp
Remove-PPDMstorage_systems
Remove-PPDMupgrade
Request-PPDMActivityLog
Restart-PPDMactivities
Restore-PPDMFileFLR_copies
Restore-PPDMflr_sessions
Restore-PPDMK8Scopies
Restore-PPDMMSSQL_copies
Restore-PPDMVMcopies
Save-PPDMActivityLog
Set-PPDMagents_update_sessions
Set-PPDMalerts_acknowledgement
Set-PPDMapp_hosts
Set-PPDMassets
Set-PPDMcertificates
Set-PPDMcloud_dr_accounts
Set-PPDMcommon_settings
Set-PPDMcomponents
Set-PPDMconfigurations
Set-PPDMdiscoveries
Set-PPDMflr_sessions
Set-PPDMinventory_sources
Set-PPDMLicenses
Set-PPDMnodes
Set-PPDMpasswordpolicies
Set-PPDMprotection_rules
Set-PPDMserver_disaster_recovery_configurations
Set-PPDMsmtp
Set-PPDMstorage_systems
Start-PPDMasset_backups
Start-PPDMdiscoveries
Start-PPDMflr_sessions
Start-PPDMprotection
Start-PPDMprotection_policies
Stop-PPDMactivities
Stop-PPDMupgrade
Stop-PPDMupgradePrecheck
Unblock-PPDMSSLCerts
Update-PPDMaudit_logs
Update-PPDMcertificates
Update-PPDMcredentials
Update-PPDMserver_disaster_recovery_backups
Update-PPDMToken
Wait-PPDMApplianceFresh
```
