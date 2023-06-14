# Customize next lines
$PLCNAME="test4"
$PrimaryStorageSystemID="aa0b484c-8f1e-4749-99c1-91f3611ab3b1"
$PrimaryPreferredInterface="100.250.1.110"
$PrimaryPreferredInterfaceID="ethV0"
$Repl1StorageSystemID="aa0b484c-8f1e-4749-99c1-91f3611ab3b1"
$Repl1PreferredInterface="100.250.1.110"
$Repl1PreferredInterfaceID="ethV0"
# end customize

$Policy=get-content .\demo.json | ConvertFrom-Json
$Policy.name=$PLCNAME
$Policy.stages[0].id=(New-Guid).Guid
$Policy.stages[1].id=(New-Guid).Guid
$Policy.stages[1].sourceStageId=$Policy.stages[0].id
$policy.stages[0].operations[0].id=(New-Guid).Guid
$policy.stages[0].operations[1].id=(New-Guid).Guid
$Policy.stages[0].extendedRetentions[0].selector.operationId=$policy.stages[0].operations[0].id
$Policy.stages[0].extendedRetentions[1].selector.operationId=$policy.stages[0].operations[1].id
$Policy.stages[1].extendedRetentions[0].selector.tags[0]="OperationId||$($policy.stages[0].operations[0].id)"
$Policy.stages[1].extendedRetentions[1].selector.tags[0]="OperationId||$($policy.stages[0].operations[1].id)"
$policy.stages[0].target.storageSystemId=$PrimaryStorageSystemID
$policy.stages[0].target.preferredInterface=$PrimaryPreferredInterface
$policy.stages[0].target.preferredInterfaceId=$PrimaryPreferredInterfaceID
$policy.stages[1].target.storageSystemId=$Repl1StorageSystemID
$policy.stages[1].target.preferredInterface=$Repl1PreferredInterface
$policy.stages[1].target.preferredInterfaceId=$Repl1PreferredInterfaceID

Invoke-PPDMapirequest -Method Post -uri protection-policies -Body ($Policy | ConvertTo-Json -Depth 7) -ContentType "application/json" -RequestMethod Rest