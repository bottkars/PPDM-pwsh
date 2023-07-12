az vm image list --all --publisher dellemc --offer ppdm_0_0_1 -o table
az vm image terms accept --urn dellemc:ppdm_0_0_1:powerprotect-data-manager-19-11-0-14:19.11.0

az vm create --resource-group test \
 --name test-001 \
 --image dellemc:ppdm_0_0_1:powerprotect-data-manager-19-11-0-14:19.11.0 \
 --plan-name powerprotect-data-manager-19-11-0-14 \
 --public-ip-address "" \
 --subnet /subscriptions/<subscription id>/resourceGroups/<rg>/providers/Microsoft.Network/virtualNetworks/<vnet>/subnets/<subnet> \
 --plan-product ppdm_0_0_1 \
 --plan-publisher dellemc \
 --size Standard_D8s_v3 