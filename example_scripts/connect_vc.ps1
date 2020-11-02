# Set the Basic Parameter
$env:GOVC_URL="vcsa1.home.labbuildr.com"                # replace ith your vCenter
$env:GOVC_INSECURE="true"                               # allow untrusted certs
$env:GOVC_DATASTORE="vsanDatastore"                     # set the default Datastore 
$ovapath="$HOME/Downloads/dellemc-ppdm-sw-19.6.0-3.ova" # the Path to your OVA File
$env:GOVC_FOLDER='/home_dc/vm/labbuildr_vms'            # the vm Folder in your vCenter where the Machine can be found
$env:GOVC_VM='ppdm_demo'                                # the vm Name
$env:GOVC_HOST='e200-n4.home.labbuildr.com'             # The target ESXi Host or ClusterNodefor Deployment
$env:GOVC_RESOURCE_POOL='mgmt_vms'                      # The Optional Resource Pool

# read Password
$username = Read-Host -Prompt "Please Enter Virtual Center Username default (Administrator@vsphere.local)"
If(-not($username)){$username = "Administrator@vsphere.local"}
$SecurePassword = Read-Host -Prompt "Enter Password for user $username" -AsSecureString
$Credentials = New-Object System.Management.Automation.PSCredential($username, $Securepassword)
#Set Username and Password in environment
$env:GOVC_USERNAME=$($Credentials.GetNetworkCredential().username)
$env:GOVC_PASSWORD=$($Credentials.GetNetworkCredential().password)
govc about

