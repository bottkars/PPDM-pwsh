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
CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           Add-PPDMAssetSource                                19.14.0.20 PPDM-pwsh
Alias           Disable-PPDMProxy                                  19.14.0.20 PPDM-pwsh
Alias           Get-PPDMAssetSource                                19.14.0.20 PPDM-pwsh
Alias           Get-PPDMFLRfiles                                   19.14.0.20 PPDM-pwsh
Alias           Get-PPDMk8sclusters                                19.14.0.20 PPDM-pwsh
Alias           Get-PPDMk8spvcmappings                             19.14.0.20 PPDM-pwsh
Alias           Get-PPDMProxy                                      19.14.0.20 PPDM-pwsh
Alias           Get-PPDMStorageMetrics                             19.14.0.20 PPDM-pwsh
Alias           Get-PPDMVPE                                        19.14.0.20 PPDM-pwsh
Alias           New-PPDMProxy                                      19.14.0.20 PPDM-pwsh
Alias           Remove-PPDMAssetSource                             19.14.0.20 PPDM-pwsh
Alias           Remove-PPDMProxy                                   19.14.0.20 PPDM-pwsh
Alias           Request-PPDMJobLog                                 19.14.0.20 PPDM-pwsh
Alias           Restore-PPDMDDB_MSSQL                              19.14.0.20 PPDM-pwsh
Alias           Restore-PPDMFLR                                    19.14.0.20 PPDM-pwsh
Alias           Restore-PPDMVMAsset                                19.14.0.20 PPDM-pwsh
Alias           Save-PPDMJobLog                                    19.14.0.20 PPDM-pwsh
Alias           Set-PPDMAsset                                      19.14.0.20 PPDM-pwsh
Alias           Set-PPDMAssetSource                                19.14.0.20 PPDM-pwsh
Alias           Set-PPDMFLRbrowsescope                             19.14.0.20 PPDM-pwsh
Alias           Start-PPDMPLC                                      19.14.0.20 PPDM-pwsh
Alias           Start-PPDMPLCStage                                 19.14.0.20 PPDM-pwsh
Alias           Start-PPDMProtectionStage                          19.14.0.20 PPDM-pwsh
Alias           Unregister-PPDMAssetFromPoliy                      19.14.0.20 PPDM-pwsh
Function        Add-PPDMcertificates                               19.14.0.20 PPDM-pwsh
Function        Add-PPDMinventory_sources                          19.14.0.20 PPDM-pwsh
Function        Add-PPDMProtection_policy_assignment               19.14.0.20 PPDM-pwsh
Function        Approve-PPDMcertificates                           19.14.0.20 PPDM-pwsh
Function        Approve-PPDMEula                                   19.14.0.20 PPDM-pwsh
Function        Connect-PPDMapiEndpoint                            19.14.0.20 PPDM-pwsh
Function        Disable-PPDMprotectionEngineProxy                  19.14.0.20 PPDM-pwsh
Function        Disconnect-PPDMsession                             19.14.0.20 PPDM-pwsh
Function        Get-PPDMactivities                                 19.14.0.20 PPDM-pwsh
Function        Get-PPDMactivity_metrics                           19.14.0.20 PPDM-pwsh
Function        Get-PPDMagents_list                                19.14.0.20 PPDM-pwsh
Function        Get-PPDMagent_registration_status                  19.14.0.20 PPDM-pwsh
Function        Get-PPDMalerts                                     19.14.0.20 PPDM-pwsh
Function        Get-PPDMassetcopies                                19.14.0.20 PPDM-pwsh
Function        Get-PPDMassets                                     19.14.0.20 PPDM-pwsh
Function        Get-PPDMaudit_logs                                 19.14.0.20 PPDM-pwsh
Function        Get-PPDMcertificates                               19.14.0.20 PPDM-pwsh
Function        Get-PPDMcloud_dr_accounts                          19.14.0.20 PPDM-pwsh
Function        Get-PPDMcloud_dr_data_targets                      19.14.0.20 PPDM-pwsh
Function        Get-PPDMcloud_dr_server_configuration              19.14.0.20 PPDM-pwsh
Function        Get-PPDMcloud_dr_server_deployment                 19.14.0.20 PPDM-pwsh
Function        Get-PPDMcloud_dr_server_version                    19.14.0.20 PPDM-pwsh
Function        Get-PPDMcloud_dr_sessions                          19.14.0.20 PPDM-pwsh
Function        Get-PPDMcloud_dr_storage_containers                19.14.0.20 PPDM-pwsh
Function        Get-PPDMcloud_dr_vcenters                          19.14.0.20 PPDM-pwsh
Function        Get-PPDMcommon_settings                            19.14.0.20 PPDM-pwsh
Function        Get-PPDMcomponents                                 19.14.0.20 PPDM-pwsh
Function        Get-PPDMconfigstatus                               19.14.0.20 PPDM-pwsh
Function        Get-PPDMconfigurations                             19.14.0.20 PPDM-pwsh
Function        Get-PPDMcopies                                     19.14.0.20 PPDM-pwsh
Function        Get-PPDMcopy_map                                   19.14.0.20 PPDM-pwsh
Function        Get-PPDMcredentials                                19.14.0.20 PPDM-pwsh
Function        Get-PPDMdatacomponents                             19.14.0.20 PPDM-pwsh
Function        Get-PPDMdatadomain_cloud_units                     19.14.0.20 PPDM-pwsh
Function        Get-PPDMdatadomain_ddboost_encryption_settings     19.14.0.20 PPDM-pwsh
Function        Get-PPDMdatadomain_mtrees                          19.14.0.20 PPDM-pwsh
Function        Get-PPDMdata_targets                               19.14.0.20 PPDM-pwsh
Function        Get-PPDMdiscoveries                                19.14.0.20 PPDM-pwsh
Function        Get-PPDMdisks                                      19.14.0.20 PPDM-pwsh
Function        Get-PPDMflr_filelisting                            19.14.0.20 PPDM-pwsh
Function        Get-PPDMflr_sessions                               19.14.0.20 PPDM-pwsh
Function        Get-PPDMFSAgentFLRBrowselist                       19.14.0.20 PPDM-pwsh
Function        Get-PPDMhosts                                      19.14.0.20 PPDM-pwsh
Function        Get-PPDMinventory_sources                          19.14.0.20 PPDM-pwsh
Function        Get-PPDMkubernetes_clusters                        19.14.0.20 PPDM-pwsh
Function        Get-PPDMlatest_copies                              19.14.0.20 PPDM-pwsh
Function        Get-PPDMlicenses                                   19.14.0.20 PPDM-pwsh
Function        Get-PPDMlocations                                  19.14.0.20 PPDM-pwsh
Function        Get-PPDMnodes                                      19.14.0.20 PPDM-pwsh
Function        Get-PPDMpasswordpolicies                           19.14.0.20 PPDM-pwsh
Function        Get-PPDMprotectionEngineProxies                    19.14.0.20 PPDM-pwsh
Function        Get-PPDMprotection_details                         19.14.0.20 PPDM-pwsh
Function        Get-PPDMprotection_engines                         19.14.0.20 PPDM-pwsh
Function        Get-PPDMprotection_policies                        19.14.0.20 PPDM-pwsh
Function        Get-PPDMprotection_rules                           19.14.0.20 PPDM-pwsh
Function        Get-PPDMprotection_storage_metrics                 19.14.0.20 PPDM-pwsh
Function        Get-PPDMpvc_storage_class_mappings                 19.14.0.20 PPDM-pwsh
Function        Get-PPDMRestored_copies                            19.14.0.20 PPDM-pwsh
Function        Get-PPDMrestore_plans                              19.14.0.20 PPDM-pwsh
Function        Get-PPDMroles                                      19.14.0.20 PPDM-pwsh
Function        Get-PPDMrules                                      19.14.0.20 PPDM-pwsh
Function        Get-PPDMserver_disaster_recovery_backups           19.14.0.20 PPDM-pwsh
Function        Get-PPDMserver_disaster_recovery_configurations    19.14.0.20 PPDM-pwsh
Function        Get-PPDMserver_disaster_recovery_hosts             19.14.0.20 PPDM-pwsh
Function        Get-PPDMserver_disaster_recovery_status            19.14.0.20 PPDM-pwsh
Function        Get-PPDMsmtp                                       19.14.0.20 PPDM-pwsh
Function        Get-PPDMstorage_systems                            19.14.0.20 PPDM-pwsh
Function        Get-PPDMstorage_system_metrics                     19.14.0.20 PPDM-pwsh
Function        Get-PPDMTELEMETRY_SETTING                          19.14.0.20 PPDM-pwsh
Function        Get-PPDMTimezones                                  19.14.0.20 PPDM-pwsh
Function        Get-PPDMupgrade_packages                           19.14.0.20 PPDM-pwsh
Function        Get-PPDMusers                                      19.14.0.20 PPDM-pwsh
Function        Get-PPDMuser_groups                                19.14.0.20 PPDM-pwsh
Function        Get-PPDMvcenterDatastores                          19.14.0.20 PPDM-pwsh
Function        Get-PPDMWebException                               19.14.0.20 PPDM-pwsh
Function        Invoke-PPDMapirequest                              19.14.0.20 PPDM-pwsh
Function        New-PPDMBackupSchedule                             19.14.0.20 PPDM-pwsh
Function        New-PPDMcredentials                                19.14.0.20 PPDM-pwsh
Function        New-PPDMDatabaseBackupSchedule                     19.14.0.20 PPDM-pwsh
Function        New-PPDMExchangeBackupPolicy                       19.14.0.20 PPDM-pwsh
Function        New-PPDMFSBackupPolicy                             19.14.0.20 PPDM-pwsh
Function        New-PPDMK8SBackupPolicy                            19.14.0.20 PPDM-pwsh
Function        New-PPDMlocations                                  19.14.0.20 PPDM-pwsh
Function        New-PPDMProtectionEngineProxy                      19.14.0.20 PPDM-pwsh
Function        New-PPDMRestored_copies                            19.14.0.20 PPDM-pwsh
Function        New-PPDMserver_disaster_recovery_backups           19.14.0.20 PPDM-pwsh
Function        New-PPDMsmtp                                       19.14.0.20 PPDM-pwsh
Function        New-PPDMSQLBackupPolicy                            19.14.0.20 PPDM-pwsh
Function        New-PPDMusers                                      19.14.0.20 PPDM-pwsh
Function        New-PPDMVMBackupPolicy                             19.14.0.20 PPDM-pwsh
Function        Remove-PPDMcdrs                                    19.14.0.20 PPDM-pwsh
Function        Remove-PPDMcertificates                            19.14.0.20 PPDM-pwsh
Function        Remove-PPDMcomponents                              19.14.0.20 PPDM-pwsh
Function        Remove-PPDMcopies                                  19.14.0.20 PPDM-pwsh
Function        Remove-PPDMcredentials                             19.14.0.20 PPDM-pwsh
Function        Remove-PPDMflr_sessions                            19.14.0.20 PPDM-pwsh
Function        Remove-PPDMinventory_sources                       19.14.0.20 PPDM-pwsh
Function        Remove-PPDMlocations                               19.14.0.20 PPDM-pwsh
Function        Remove-PPDMProtectionEngineProxy                   19.14.0.20 PPDM-pwsh
Function        Remove-PPDMprotection_policies                     19.14.0.20 PPDM-pwsh
Function        Remove-PPDMProtection_policy_assignment            19.14.0.20 PPDM-pwsh
Function        Remove-PPDMprotection_rules                        19.14.0.20 PPDM-pwsh
Function        Remove-PPDMserver_disaster_recovery_backups        19.14.0.20 PPDM-pwsh
Function        Remove-PPDMsmtp                                    19.14.0.20 PPDM-pwsh
Function        Remove-PPDMstorage_systems                         19.14.0.20 PPDM-pwsh
Function        Remove-PPDMupgrade                                 19.14.0.20 PPDM-pwsh
Function        Request-PPDMActivityLog                            19.14.0.20 PPDM-pwsh
Function        Restart-PPDMactivities                             19.14.0.20 PPDM-pwsh
Function        Restore-PPDMFileFLR_copies                         19.14.0.20 PPDM-pwsh
Function        Restore-PPDMflr_sessions                           19.14.0.20 PPDM-pwsh
Function        Restore-PPDMK8Scopies                              19.14.0.20 PPDM-pwsh
Function        Restore-PPDMMSSQL_copies                           19.14.0.20 PPDM-pwsh
Function        Restore-PPDMVMcopies                               19.14.0.20 PPDM-pwsh
Function        Save-PPDMActivityLog                               19.14.0.20 PPDM-pwsh
Function        Set-PPDMalerts_acknowledgement                     19.14.0.20 PPDM-pwsh
Function        Set-PPDMassets                                     19.14.0.20 PPDM-pwsh
Function        Set-PPDMcertificates                               19.14.0.20 PPDM-pwsh
Function        Set-PPDMcloud_dr_accounts                          19.14.0.20 PPDM-pwsh
Function        Set-PPDMcomponents                                 19.14.0.20 PPDM-pwsh
Function        Set-PPDMconfigurations                             19.14.0.20 PPDM-pwsh
Function        Set-PPDMdiscoveries                                19.14.0.20 PPDM-pwsh
Function        Set-PPDMflr_sessions                               19.14.0.20 PPDM-pwsh
Function        Set-PPDMinventory_sources                          19.14.0.20 PPDM-pwsh
Function        Set-PPDMLicenses                                   19.14.0.20 PPDM-pwsh
Function        Set-PPDMnodes                                      19.14.0.20 PPDM-pwsh
Function        Set-PPDMpasswordpolicies                           19.14.0.20 PPDM-pwsh
Function        Set-PPDMprotection_rules                           19.14.0.20 PPDM-pwsh
Function        Set-PPDMserver_disaster_recovery_configurations    19.14.0.20 PPDM-pwsh
Function        Set-PPDMsmtp                                       19.14.0.20 PPDM-pwsh
Function        Set-PPDMstorage_systems                            19.14.0.20 PPDM-pwsh
Function        Start-PPDMasset_backups                            19.14.0.20 PPDM-pwsh
Function        Start-PPDMdiscoveries                              19.14.0.20 PPDM-pwsh
Function        Start-PPDMflr_sessions                             19.14.0.20 PPDM-pwsh
Function        Start-PPDMprotection                               19.14.0.20 PPDM-pwsh
Function        Start-PPDMprotection_policies                      19.14.0.20 PPDM-pwsh
Function        Stop-PPDMactivities                                19.14.0.20 PPDM-pwsh
Function        Stop-PPDMupgrade                                   19.14.0.20 PPDM-pwsh
Function        Stop-PPDMupgradePrecheck                           19.14.0.20 PPDM-pwsh
Function        Unblock-PPDMSSLCerts                               19.14.0.20 PPDM-pwsh
Function        Update-PPDMaudit_logs                              19.14.0.20 PPDM-pwsh
Function        Update-PPDMcertificates                            19.14.0.20 PPDM-pwsh
Function        Update-PPDMcredentials                             19.14.0.20 PPDM-pwsh
Function        Update-PPDMserver_disaster_recovery_backups        19.14.0.20 PPDM-pwsh
Function        Update-PPDMToken                                   19.14.0.20 PPDM-pwsh
Function        Wait-PPDMApplianceFresh                            19.14.0.20 PPDM-pwsh
```
