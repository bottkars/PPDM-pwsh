$exludeBus=(1)
$ExcludeUnit=(1,2)
$Filter='details.vm.disks.busNumber ge 1 and details.vm.disks.unitNumber in ("' + ($ExcludeUnit -join '","') + '") and protectionStatus in ("PROTECTED","UNPROTECTED")'
Write-Host $Filter
$Assets = Get-PPDMassets -type VMWARE_VIRTUAL_MACHINE -filter $filter 6> $null
$assets | Format-Table
$Assets.foreach( {
    $BusObjects= $_.details.vm.disks | Where-Object type -eq "SCSI" | Sort-Object -Unique busNumber | Select-Object busNumber
    write-host "We have $($BusObjects.count) Scsi Busses detected"
    $disks = $_.details.vm.disks | Sort-Object label    
    Write-Host "Disks before exlusion rule:"
    write-host ($disks |  Format-Table | out-string)
    write-host "We have $($disks.count) Harddisks detected"
    $disks_bus1 = $disks | Where-Object busNumber -eq 0
    $disks_bus0 = $disks | Where-Object busNumber -eq 1
    write-host "We have $($disks_bus1.count) Harddisks at bus1 detected"
    write-host "We have $($disks_bus0.count) Harddisks at bus1 detected"
    $disks.foreach({
        if ( $_.busNumber -in $ExludeBus) {
            write-host "Detected disk Bus $($_.busNumber) Unit $($_.UnitNumber) at Exluded Bus"
            if ( $_.unitNumber -in $ExcludeUnit) {
                Write-Host -ForegroundColor Magenta "Detecting Exclude Unit disk Bus $($_.busNumber) Unit $($_.UnitNumber)"
                $_.excluded=$True
            }
        }

    })
    #for ($i = 3; $i -lt $disks.count ; $i++) { 
    #    write-host "Excluding  $($disks[$i].label)"
    #    $disks[$i].excluded = "True" 
    #}
    $disks.refresh
    Write-Host "Disks after exlusion rule:"
    write-host ($disks |  Format-Table | out-string)
    #$_.details.vm.disks = $disks
    #write-host "sending Patch request"
    #Set-PPDMasset -id $($_.id) -configobject $asset | ft
})