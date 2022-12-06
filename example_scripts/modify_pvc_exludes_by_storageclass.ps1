$Cluster = Get-PPDMk8sclusters | where name -match tkgi
$StorageClass = "nfs-csi" # "default-thin"
$Filter = 'subtype eq "K8S_PERSISTENT_VOLUME_CLAIM" and details.k8s.inventorySourceId eq "' + $Cluster.ID + '" and details.k8s.persistentVolumeClaim.storageClassName eq "' + $StorageClass + '" and details.k8s.persistentVolumeClaim.excluded eq "FALSE"'
$assets = Get-PPDMassets -filter $Filter
$assets | Format-Table
foreach ($asset in $Assets) {
    write-host "We have $($asset.id) set to excluded = $($asset.details.k8s.persistentVolumeClaim.excluded)"
    write-host "Setting $($asset.id) set to excluded = True"
    $asset.details.k8s.persistentVolumeClaim.excluded = "True"
    write-host "sending Patch request"
    Set-PPDMasset -id $($asset.id) -configobject $asset | ft
}