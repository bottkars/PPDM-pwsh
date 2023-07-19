function Get-PPDMuser_groups {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id
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
            }
            default {
                $URI = "/$myself"
            }
        }        
        try {
            $Response += Invoke-PPDMapirequest -uri $URI -Method $METHOD -Body "$body"
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
                write-output $response | convertfrom-json
            }
            default {
                write-output ($response | convertfrom-json).content
            } 
        }   
    }
}

function Get-PPDMusers {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id
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
            }
            default {
                $URI = "/$myself"
            }
        }        
        try {
            $Response += Invoke-PPDMapirequest -uri $URI -Method $METHOD -Body "$body"
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
                write-output $response | convertfrom-json
            }
            default {
                write-output ($response | convertfrom-json).content
            } 
        }   
    }
}

function Get-PPDMroles {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id
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
            }
            default {
                $URI = "/$myself"
            }
        }        
        try {
            $Response += Invoke-PPDMapirequest -uri $URI -Method $METHOD -Body "$body"
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
                write-output $response | convertfrom-json
            }
            default {
                write-output ($response | convertfrom-json).content
            } 
        }   
    }
}




function New-PPDMusers {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byName', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('Admin',
            'Export and Recovery Admin',
            'User')]
        [string]$roleName,
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [alias('Id')][string]$roleId,        
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'byName', ValueFromPipelineByPropertyName = $true)]
        [string]$firstName,
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'byName', ValueFromPipelineByPropertyName = $true)]
        [string]$lastName,
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'byName', ValueFromPipelineByPropertyName = $true)]
        [string]$emailAddress,
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'byName', ValueFromPipelineByPropertyName = $true)]
        [switch]$forcePasswordChange,
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'byName', ValueFromPipelineByPropertyName = $true)]
        [System.Management.Automation.PSCredential]$Credentials,
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

            'byName' {
                $roleId = (Get-PPDMroles | where name -eq $roleName).id
            }
        }
        $URI = "/$myself"
        if (!$($Credentials)) {
            $username = Read-Host -Prompt "Please Enter New username"
            $SecurePassword = Read-Host -Prompt "Enter Password for user $username" -AsSecureString
            $Credentials = New-Object System.Management.Automation.PSCredential($username, $Securepassword)
        }
        $password = $Credentials.GetNetworkCredential().password
        $username = $Credentials.GetNetworkCredential().UserName
        $Body = @{
            'roleId'              = $roleId
            'firstName'           = $firstName
            'lastName'            = $lastName
            'username'            = $username
            'emailAddress'        = $emailAddress
            'forcePasswordChange' = $forcePasswordChange.IsPresent
            'password'            = $password
        } | ConvertTo-Json

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


# /api/v2/policies/password
function Get-PPDMpasswordpolicies {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = "policies/password"
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id"
            }
            default {
                $URI = "/$myself"
            }
        }        
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
                write-output $response | convertfrom-json
            }
            default {
                write-output $response 
            } 
        }   
    }
}



# regex_wrong: ^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$#@$!%*?& ^'/:,\\\]\[()+-\.~<>"={|}`;_])[A-Za-z\d$#@$/!%*?& ^':,\\\]\[()+-\.~<>"={|}`;_]{9,}$


function Set-PPDMpasswordpolicies {
    [CmdletBinding()]
    param(
        [int]$maxAgeInDays,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "PUT"
        $Myself = "policies/password"
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {

            default {
                $URI = "/$myself"
            }
        }   
        $body = Get-PPDMpasswordpolicies
        if ($maxAgeInDays) {
            $body.maxAge = "P$($maxAgeInDays)D"
        }
        $body = $body| convertto-json
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
                write-output $response | convertfrom-json
            }
            default {
                write-output $response 
            } 
        }   
    }
}