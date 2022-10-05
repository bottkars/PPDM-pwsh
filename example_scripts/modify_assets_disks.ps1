
$Assets = Get-PPDMassets -filter 'type eq "VMWARE_VIRTUAL_MACHINE" and details.vm.disks.label lk "Hard disk 3" and protectionStatus eq "PROTECTED"'
foreach ($asset in $Assets) {
    $disks = $asset.details.vm.disks | Sort-Object label
    write-host "We have $($disks.count)"
    for ($i = 3; $i -lt $disks.count ; $i++) { 
        write-host " Excluding  $($disks[$i].label)"
        $disks[$i].excluded = "True" 
    }
    $asset.details.vm.disks = $disks
    write-host "sending Patch request"
    Set-PPDMasset -id $($asset.id) -configobject $asset
#    Invoke-PPDMapirequest -Method Patch -uri assets/$($asset.id) -Body ($asset | ConvertTo-Json -Depth 7) 
}