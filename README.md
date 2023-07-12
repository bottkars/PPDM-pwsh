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
Get-Help 
```
## VMware Protection

## Kubernetes Protection
Examples for Kubernetes Onboarding, Protection and restores
[Kubernetes Protection](./Demos/05.%20kubernetes_protection_example.md)
## Agent Protection
Examples for Managing Agent Based Protection and Restores  
[FSAgent Agent](./Demos/02.1%20Asset%20Restore%20FLR%20client%20Side.md)  
[MSSQL Agent](./Demos/03.%20Asset%20Restore%20MSSQL%20Powershell.md)  
## Asset Managemnt
Examples for managing Assets  
[Asset Management](./Demos/04.%20Asset%20Management.md)


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
