# This Chapter explains some Usescases for Activities Management


## Get all Failed Activitis
```Powershell
Get-PPDMactivities -PredefinedFilter PROTECT_FAILED
```
## Get All Failed Activities last Day

```Powershell
Get-PPDMactivities -PredefinedFilter PROTECT_FAILED -days 1 
```
## Get All Failed Activities last Day that are retryable
```Powershell
Get-PPDMactivities -PredefinedFilter PROTECT_FAILED -days 1 | where { $_.actions.retryable -eq $True }
```

## Restart  All Failed Activities last Day taht are Restartable
```Powershell
Get-PPDMactivities -PredefinedFilter PROTECT_FAILED -days 1 | where { $_.actions.retryable -eq $True } | Restart-PPDMactivities
```
## Restart Failed Kubernetes Activities
```Powershell
Get-PPDMactivities -days 11 -PredefinedFilter PROTECT_FAILED -query Kubernetes   | where { $_.actions.retryable -eq $True } | Restart-PPDMactivities
```