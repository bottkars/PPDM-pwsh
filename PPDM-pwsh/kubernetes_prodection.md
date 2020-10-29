# Example Backup of Kubernets Protection Policies

In this Use Case, we have one Protection Policy for Kubernetes.
To get a Protection Policy for Kubernetes using powersherll, type

```Powershell
Get-PPDMprotection_policies | where assetType -eq Kubernetes
```



you could ALSO scope the where-obcext to the name Parameter, in my Case i match to find *Kube Backup Platform Services*


```Powershell
Get-PPDMprotection_policies | where name -Match "Platform Services"
```

The return object in both cases could be one or multiple objects, so you might identify the correct id

As the modules support Pipelining based on Pareameters, we can simply  start the backup for the Policy by 
```Powershell
Get-PPDMprotection_policies | where name -Match "Platform Services" | Start-PPDMprotection_policies
```
The Protection Policy will then fist be Queued. We can check with the command:
```Powershell
Get-PPDMactivities -PredefinedFilter QUEUED
```

![image](https://user-images.githubusercontent.com/8255007/97600368-446db380-1a09-11eb-9c1a-a7055ada9e19.png)

With the ID from Aboye, you could also query the activity:
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
Powershell 
![image](https://user-images.githubusercontent.com/8255007/97603502-ca3f2e00-1a0c-11eb-8c85-f4f85eb43deb.png)
