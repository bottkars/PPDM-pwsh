

$PLAN_NAME="TESPLAN"
$RESTORE_PLAN=Get-PPDMrestore_plans -filter "name eq `"$PLAN_NAME`""
$AssetState=@()
foreach ($restoreGroup in $RESTORE_PLAN.restoreGroups)
{
    
    foreach ($id in $restoreGroup.assetSelector.assetIds) {
        $AssetState += Get-PPDMassets -id $id | Select-Object name,id,protectionStatus,lastAvailableCopyTime,@{Name= 'RecoverGroup'; Expression = {$restoreGroup.Name}},@{Name= 'RecoverPlan'; Expression = {$RESTORE_PLAN.Name}}
    }   

}

$AssetState | ft


