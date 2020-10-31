# Set the Basic Parameter
$env:GOVC_URL="vcsa1.home.labbuildr.com"    # replace ith your vCenter
$env:GOVC_INSECURE="true"                   # allow untrusted certs
$env:GOVC_DATASTORE="vsanDatastore"         # set the default Datastore 
# read Password
$username = Read-Host -Prompt "Please Enter Virtual Center Username default (Administrator@vsphere.local)"
If(-not($username)){$username = "Administrator@vsphere.local"}
$SecurePassword = Read-Host -Prompt "Enter Password for user $username" -AsSecureString
$Credentials = New-Object System.Management.Automation.PSCredential($username, $Securepassword)
#Set Username and Password in environment
$env:GOVC_USERNAME=$($Credentials.GetNetworkCredential().username)
$env:GOVC_PASSWORD=$($Credentials.GetNetworkCredential().password)
govc about

## Importing the Specifications:
