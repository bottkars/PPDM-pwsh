## This Demo Runs a restore ov an Individual VM

### Connect to PPDM API in AVS:
```Powershell
$connection=connect-PPDMapiEndpoint -trustCert -PPDM_API_BaseURI ppdmavs01.edub.csc
$RestoreVM = "server2022_3"
```
![image](https://github.com/bottkars/PPDM-pwsh/assets/8255007/858888b6-294f-4a77-a3a4-2cdfd674d16d)
```Powershell
$Asset = Get-PPDMassets -filter 'type eq "VMWARE_VIRTUAL_MACHINE" and protectionStatus eq "PROTECTED" and name eq "server2022_3"'
$copyobject = $asset | Get-PPDMassetcopies | select-object -first 1
```
![image](https://github.com/bottkars/PPDM-pwsh/assets/8255007/d0352567-8ac2-4498-973f-01c1aec1ed2d)

## Restore the VM
```Powershell
Restore-PPDMVMAsset -CopyObject $copyobject -recoverConfig -TO_PRODUCTION -Description "Restore from Powershell" 
```

![image](https://github.com/bottkars/PPDM-pwsh/assets/8255007/6e29107e-2d1f-401d-ab92-174cd0d768b7)
![image](https://github.com/bottkars/PPDM-pwsh/assets/8255007/3a5d35c7-a562-436a-9c96-59b2f6013e4b)