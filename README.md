# PPDM-pwsh
![ppdm19 6](https://user-images.githubusercontent.com/8255007/97328230-186df900-1876-11eb-8ad4-4feed5dac316.gif)

## :heart: Powershell Modules for Dell PowerProtect DataManager API :heart:


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
this uses a user password/authentication to retrieve the token. The login can be interactive or wit a Credentials PSobject.  
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
[FSAgent Agent](./Demos/02.1%20Asset%20Restore%20FLR%20client%20Side.md)  
[MSSQL Agent](./Demos/03.%20Asset%20Restore%20MSSQL%20Powershell.md)   
[Create Centralized MSSQL Protection Policy](./Demos/07.%20Create%20Centralized_SQL.md)  
[Create Self Service MSSQL Policy](./Demos/08.%20Create_SelfService_SQL.md)

## Asset Managemnt
Examples for managing Assets  
[Asset Management](./Demos/04.%20Asset%20Management.md)

## Restore Plans
[Example Script getting Assets protected in restore Plan](./example_scripts/get_assets_protected_in_restore_plan.ps1)  

# Inventory Examples
## Managing / Adding Protection Storage
[Example Script adding a DataDomain](./example_scripts/connect-ddve.ps1)

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
