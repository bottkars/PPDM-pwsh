```Powershell
$env:GOVC_URL="vcsa1.home.labbuildr.com"    # replace ith your vCenter
$env:GOVC_INSECURE="true"                   # allow untrusted certs
$env:GOVC_DATASTORE="vsanDatastore"         # set the default Datastore 

$username = Read-Host -Prompt "Please Enter Virtual Center Username"
$SecurePassword = Read-Host -Prompt "Enter Password for user $username" -AsSecureString
$Credentials = New-Object System.Management.Automation.PSCredential($username, $Securepassword)


$env:GOVC_USERNAME=$($Credentials.GetNetworkCredential().username)
$env:GOVC_PASSWORD=$($Credentials.GetNetworkCredential().password)
govc ls
```