az vm image list --all --publisher dellemc --offer ppdm_0_0_1 -o table
az vm image terms accept --urn dellemc:ppdm_0_0_1:powerprotect-data-manager-19-11-0-14:19.11.0

az vm create --resource-group test \
 --name test-001 \
 --image dellemc:ppdm_0_0_1:powerprotect-data-manager-19-11-0-14:19.11.0 \
 --plan-name powerprotect-data-manager-19-11-0-14 \
 --public-ip-address "" \
 --subnet /subscriptions/76f913f8-62e0-4634-ad6f-c030d34514a5/resourceGroups/tfdemo/providers/Microsoft.Network/virtualNetworks/tfdemo-virtual-network/subnets/tfdemo-aks-subnet \
 --plan-product ppdm_0_0_1 \
 --plan-publisher dellemc \
 --size Standard_D8s_v3 