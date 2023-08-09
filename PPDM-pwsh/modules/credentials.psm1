# /api/v2/credentials
<#
.SYNOPSIS
'Retrieves all **Credentials** in PowerProtect Data Manager. **Credentials** contains username and password or token. The password is securely stored in the lockbox of PowerProtect Data Manager.
his endpoint supports execution by the following roles: Administrator, User, Backup Administrator, Restore Administrator'
#>
function Get-PPDMcredentials {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$ID,
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Alias('consumerlist')][switch]$usage,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        $filter,
        [ValidateSet(
            'DATADOMAIN',
            'POWERPROTECT',
            'DBUSER',
            'OS',
            'RMAN',
            'STANDARD',
            'VCENTER',
            'KUBERNETES',
            'SMISSERVER',
            'CDR',
            'SAPHANA_DB_USER',
            'SAPHANA_SYSTEMDB_USER',
            'DDBOOST',
            'NAS',
            'CLOUD_SNAPSHOT_MANAGER',
            'CLOUD_DIRECTOR'
        )]
        [Alias('AssetType')][string]$type,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        $pageSize, 
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        $page, 
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        [hashtable]$body = @{orderby = 'createdAt DESC' },
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]                
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $apiver = "/api/v2"    
    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id"
                $body = @{}  

            }
            default {
                $URI = "/$myself"
            }
        }  
        if ($pagesize) {
            $body.add('pageSize', $pagesize)
        }
        if ($page) {
            $body.add('page', $page)
        }   
        $Parameters = @{
            RequestMethod    = 'REST'
            body             = $body
            Uri              = $URI
            Method           = $Method
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
        }
        if ($type) {
            if ($filter) {
                $filter = 'type eq "' + $type + '" and ' + $filter 
            }
            else {
                $filter = 'type eq "' + $type + '"'
            }
        }        
        if ($filter) {
            $parameters.Add('filter', $filter)
        }       
        try {
            $Response += Invoke-PPDMapirequest @Parameters
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response 
            }
            default {
                write-output $response.content
                if ($response.page) {
                    write-host ($response.page | out-string)
                }
            } 
        }   
    }
}
# https://developer.dellemc.com/data-protection/powerprotect/data-manager/api/credentials-management/createcredential
# POST /api/v2/credentials

<#
.Synopsis
Creates a **Credential** in PowerProtect Data Manager. **Credential** contains username and password. The password is securely stored in the lockbox of PowerProtect Data Manager.
This endpoint supports execution by the following roles: Administrator
.Description

When Connecting to Data Sources, Storage and Invetories, certain Credential Types need to be passed.
This can be Tokens, Keys, Credential or other

.Example
Create a Data Domain user interactive:

New-PPDMcredentials -name ddve3 -type DATADOMAIN
Please Enter New username: sysad3
Enter Password for user sysad3: ************

id       : c3ddda66-fa4d-48f8-b233-5217a90dbf37
name     : ddve3
username : sysad3
password :
type     : DATADOMAIN
method   :
secretId : ac9553ce-cb3f-419d-883d-240577dff127
internal : False
_links   : @{self=}

.Example
Create Credetials Programmatically
$SecurePassword=ConvertTo-SecureString "PlainPassword" -AsPlainText -Force
$username="limitedadmin"
$Credentials = New-Object System.Management.Automation.PSCredential($username, $Securepassword)


New-PPDMcredentials -name datadomain3 -type DATADOMAIN -credentials $Credentials

id       : a89df348-1c00-4424-8a54-b6e0329bea6a
name     : datadomain3
username : sysadmin
password :
type     : DATADOMAIN
method   :
secretId : 9397c905-5d46-4e2b-80ae-d782b4fb98ab
internal : False
.Example
Create Kubernetes Credentials
$tokenfile="\\nasug.home.labbuildr.com\minio\aks\aksazs1\ppdmk8stoken-20210606.653.18+UTC.json"
$Securestring=ConvertTo-SecureString -AsPlainText -String "$(Get-Content $tokenfile -Encoding utf8)" -Force
$username="limitedadmin"
$Credentials = New-Object System.Management.Automation.PSCredential($username, $Securestring)
$newcreds=New-PPDMcredentials -name aksazs1 -type KUBERNETES -authmethod TOKEN -credentials $Credentials
#>
function New-PPDMcredentials {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$name,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet(
            'DATADOMAIN',
            'POWERPROTECT',
            'DBUSER',
            'OS',
            'RMAN',
            'STANDARD',
            'VCENTER',
            'KUBERNETES',
            'SMISSERVER',
            'CDR',
            'SAPHANA_DB_USER',
            'SAPHANA_SYSTEMDB_USER',
            'DDBOOST',
            'NAS',
            'CLOUD_SNAPSHOT_MANAGER',
            'CLOUD_DIRECTOR'
        )]
        [string]$type,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [pscredential]$credentials,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('BASIC', 'CONFIG', 'TOKEN', 'USER_KEY')]
        [string]$authmethod,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {

            default {
                $URI = "/$myself"
            }
        }
        if (!$($Credentials)) {
            $username = Read-Host -Prompt "Please Enter New username"
            $SecurePassword = Read-Host -Prompt "Enter Password for user $username" -AsSecureString
            $Credentials = New-Object System.Management.Automation.PSCredential($username, $Securepassword)
        }
        $Body = @{
            'type'     = $type
            'name'     = $name
            'username' = $($Credentials.username)
            'password' = $($Credentials.GetNetworkCredential()).password

        }
        
        if ($authmethod) {
            $Body.Add('method', $authmethod)
        }
        
        $body = $Body | ConvertTo-Json
        write-verbose ($body | out-string )
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
        }      
        try {
            $Response += Invoke-PPDMapirequest @Parameters
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response 
            }
            default {
                write-output $response
            } 
        }   
    }
}


#DELETE /api/v2/credentials/{id}   
<#
.SYNOPSIS
Deletes a **Credential** by ID from PowerProtect Data Manager. The deleted **Credential** is removed from PowerProtect Data Manager.
#>
function Remove-PPDMcredentials {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$ID,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "DELETE"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(11) -replace "_", "-").ToLower()
   
    }     
    Process {
        
        $URI = "/$myself/$ID"
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
        }      
        try {
            $Response += Invoke-PPDMapirequest @Parameters
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        write-output $response
    }   
}



function Update-PPDMcredentials {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        $update,

        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "PUT"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(11) -replace "_", "-").ToLower()
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {

            default {
                $URI = "/$myself/$($update.id)"
            }
        }


        $body = $update | ConvertTo-Json
        write-verbose ($body | out-string )
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
        }      
        try {
            $Response += Invoke-PPDMapirequest @Parameters
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($response | Out-String)
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {
            default {
                write-output $response
            } 
        }   
    }
}