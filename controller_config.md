$asset_source=Get-PPDMAssetSource -Type KUBERNETES -filter 'name eq "barak-tkg"'
$controller_config=@{}
$controller_config.add('type',"CONTROLLER_CONFIG")
$controller_config.add('key',"k8s.ppdm.autoenable.cbt")
$controller_config.add('value',"false")


$asset_source.details.k8s.configurations += $controller_config
Set-PPDMAssetSource -id $asset_source.id -configobject $asset_source




# removing
# .Invoke() on a script block, you always get a [System.Collections.ObjectModel.Collection[psobject]] instance (even if it contains only 1 object).


$asset_source.details.k8s.configurations = { $asset_source.details.k8s.configurations }.Invoke()


$asset_source.details.k8s.configurations = $asset_source.details.k8s.configurations | where key -ne "k8s.ppdm.autoenable.cbt"


### logs for activities, api/v2/log-exports
body {"filterType":"ACTIVITY_ID","filterValue":"bebe5d40-555d-40b7-a509-fed6b8587d96"}
get
https://drminf4ppdm4.dri.lab.dell.com/passthrough/api/v2/log-exports/bebe5d40-555d-40b7-a509-fed6b8587d96/file