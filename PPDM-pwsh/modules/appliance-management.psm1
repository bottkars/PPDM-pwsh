
function Get-PPDMTimezones {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$ID,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
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
                $URI = "/$myself/$ID"
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
                write-output $response 
            }
            default {
                write-output $response.content
            } 
        }   
    }
}



function Get-PPDMcomponents {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$id,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
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
                write-output $response 
            }
            default {
                write-output $response.content 
            } 
        }   
    }
}


function Get-PPDMconfigurations {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$id,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
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
                write-output $response 
            }
            default {
                write-output $response.content 
            } 
        }   
    }
}

# /api/v2/configurations/{configurationId}/config-status
function Get-PPDMconfigstatus {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$id,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = 'configurations'
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id/config-status"
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
                write-output $response 
            }
            default {
                write-output $response.content 
            } 
        }   
    }
}


function Get-PPDMnodes {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$Nodeid,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$Nodeid"
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
                write-output $response 
            }
            default {
                write-output $response.content 
            } 
        }   
    }
}


function Set-PPDMnodes {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$Nodeid,
        [Parameter(Mandatory = $True, ParameterSetName = 'byID')]
        [ValidateSet('MAINTENANCE', 'RESTORE', 'QUIESCE', 'OPERATIONAL')]
        [string]$status,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "PUT"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$Nodeid"
            }
            default {
                $URI = "/$myself"
            }
        } 
        $body = @{
            id     = $NodeID
            status = $status
        } | convertto-json 
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
                write-output $response.content 
            } 
        }   
    }
}

#/api/v2/disks
function Get-PPDMdisks {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$id,
        [switch]$PartitionDetails,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
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
        if ($PartitionDetails.ispresent) {
            $Parameters = @{
                Property        = '*'
                ExcludeProperty = ("name", "totalSize", "availableSize", "partitions", "_links")
                ExpandProperty  = 'partitions'
            }    
        }
        else {
            $Parameters = @{
                Property = '*'
            } 
        }

        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response | Select-Object @Parameters
            }
            default {
                write-output $response.content | Select-Object @Parameters
            } 
        }   
    }
}

#### initial Config

function Set-PPDMconfigurations {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateCount(1,2)][ValidateScript( { $_ -match [IPAddress]$_ })]
        [string[]]$NTPservers,
        [String]$Timezone = 'Europe/Berlin - Central European Time',
        [Parameter(Mandatory = $true)]
 #       [ValidatePattern('^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{9,}$')]
        [securestring][alias('admin_password')]$Password,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $admin_oldpassword = '@ppAdm1n'
        $root_oldpassword = 'changeme'
        $support_oldpassword = '$upp0rt!'        
        $lockbox_oldpassphrase = 'Ch@ngeme1'
        $admin_password = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
        if (!$PSBoundParameters.ContainsKey('root_Password')) { $root_Password = $admin_password }
        if (!$PSBoundParameters.ContainsKey('support_Password')) { $support_Password = $admin_password }
        if (!$PSBoundParameters.ContainsKey('lockbox_Passphrase')) { $lockbox_Passphrase = $admin_password }
        $Response = @()
        $METHOD = "PUT"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
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
        Write-Host "Getting Powerprotect initial Configuration"
        try {
            $Configurations = Get-PPDMConfigurations
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        write-verbose ($Configurations | Out-String)
        ## Check  appliance status
        Write-Host "Checking Node Status"
        try {
            $Node = Invoke-PPDMapirequest -uri "/nodes/$($configurations.NodeID)" -Method Get -RequestMethod Rest
        }
        catch {
            Get-PPDMWebException  -ExceptionMessage $_
            break
        }
        if ($($Node.status) -ne "PENDING") {
            Write-Warning "Node $($configurations.NodeID) in Node Status $($Node.status), cannot Continue"
            Break
        }
        write-host "Node $($Node.Id) is in Status $($Node.status) and has Version $($Node.Version)"
        Write-Verbose "Building Desired State"
        $Configurations = $Configurations  | Select-Object -ExcludeProperty _links
        foreach ($user in ('root', 'admin', 'support')) {
            write-host "setting user Configuration for $user"   
            $Configurations.osUsers | where userName -eq $user | Add-Member -NotePropertyName password -NotePropertyValue (get-variable ${user}_oldpassword).value -Force
            $Configurations.osUsers | where userName -eq $user | Add-Member -NotePropertyName newPassword -NotePropertyValue (get-variable ${user}_password).value -Force
        }
        write-host "setting user Configuration for ApplicationUser"
        $Configurations | Add-Member -NotePropertyName applicationUserPassword -NotePropertyValue $admin_password -Force
        write-host "setting Lockbox"
        $Configurations.lockbox | Add-Member -NotePropertyName passphrase -NotePropertyValue $lockbox_oldpassphrase -Force
        $Configurations.lockbox | Add-Member -NotePropertyName newPassphrase -NotePropertyValue $lockbox_passphrase -Force
        write-Host "Setting Timezone"
        $Configurations.timeZone = $Timezone
        $Configurations.ntpServers = $ntpservers 
        write-verbose ($Configurations | convertto-json | out-string) 
        $body = $configurations | convertto-json -depth 5 -compress 
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                write-output $response 
            }
            default {
                write-verbose ($body | out-string)

                $Parameters = @{
                    body             = "$body" 
                    Uri              = "$Uri/$($Configurations.ID)"
                    Method           = $Method
                    RequestMethod    = "Rest"
                    ContentType      = 'application/json'
                    PPDM_API_BaseUri = $PPDM_API_BaseUri
                    apiver           = $apiver
                } 
                write-verbose ( $Parameters | out-String) 
                Write-Host "Applying Appliance Configuration"     
                try {
                    $Response += Invoke-PPDMapirequest @Parameters
                }
                catch {
                    Get-PPDMWebException  -ExceptionMessage $_
                    break
                }
            } 
        }   
    }

    end { 
        write-output $Response
    }    
} 


# /api/v2/cloud-dr-accounts


function Set-PPDMcomponents {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$id,
        [Parameter(Mandatory = $True, ParameterSetName = 'byID')]
        [ValidateSet('DOWN', 'UP')]
        [string]$status,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id/management"
            }
            default {
                $URI = "/$myself"
            }
        } 
        $body = @{
            operation = "start"
        } | convertto-json 
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
                write-output $response.content 
            } 
        }   
    }
}


function Get-PPDMsmtp {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$id,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
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
                write-output $response 
            }
            default {
                write-output $response.content
            } 
        }   
    }
}


function New-PPDMsmtp {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true,  ParameterSetName = 'withoutuser', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true,  ParameterSetName = 'withuser',  ValueFromPipelineByPropertyName = $true)]
        [string]$mailServer,
        [Parameter(Mandatory = $true,  ParameterSetName = 'withoutuser', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true,  ParameterSetName = 'withuser',  ValueFromPipelineByPropertyName = $true)]
        [string]$mailFrom,
        [Parameter(Mandatory = $true,  ParameterSetName = 'withuser',  ValueFromPipelineByPropertyName = $true)]
        [string]$username,
        [Parameter(Mandatory = $true,  ParameterSetName = 'withuser',  ValueFromPipelineByPropertyName = $true)]
        [securestring]$password,                            
        [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [int32]$port,        
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
        $body = @{
            mailServer = $mailServer
            mailFrom = $mailFrom
            port= $port

        }
        switch ($PsCmdlet.ParameterSetName){
            'withuser' {
            $body.Add('username',$username)
            $body.Add('password',[System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)))
            }
        }
        $body=$body | ConvertTo-Json
        Write-Verbose ($body | Out-String)
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



function Set-PPDMsmtp {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true,  ParameterSetName = 'withoutuser', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true,  ParameterSetName = 'withuser',  ValueFromPipelineByPropertyName = $true)]
        [string]$ID,        
        [Parameter(Mandatory = $true,  ParameterSetName = 'withoutuser', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true,  ParameterSetName = 'withuser',  ValueFromPipelineByPropertyName = $true)]
        [string]$mailServer,
        [Parameter(Mandatory = $true,  ParameterSetName = 'withoutuser', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true,  ParameterSetName = 'withuser',  ValueFromPipelineByPropertyName = $true)]
        [string]$mailFrom,
        [Parameter(Mandatory = $true,  ParameterSetName = 'withuser',  ValueFromPipelineByPropertyName = $true)]
        [string]$username,
        [Parameter(Mandatory = $true,  ParameterSetName = 'withuser',  ValueFromPipelineByPropertyName = $true)]
        [securestring]$password,                            
        [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [int32]$port,        
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )
    begin {
        $Response = @()
        $METHOD = "PUT"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            default {
                $URI = "/$myself/$ID"
            }
        }  
        $body = @{
            id = $ID
            mailServer = $mailServer
            mailFrom = $mailFrom
            port= $port
        }
        switch ($PsCmdlet.ParameterSetName){
            'withuser' {
            $body.Add('username',$username)
            $body.Add('password',[System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)))
            }
        }
        $body=$body | ConvertTo-Json
        Write-Verbose ($body | Out-String)
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


function Remove-PPDMsmtp {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$id,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "DELETE"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(11) -replace "_", "-").ToLower()   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {

            default {
                $URI = "/$myself/$id"
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
            default {
                write-output $response
            } 
        }   
    }
}
<#

{
  "description": "SMTP",
  "properties": {
    "id": {
      "type": "string"
    },
    "mailFrom": {
      "type": "string"
    },
    "mailServer": {
      "type": "string"
    },
    "password": {
      "type": "string"
    },
    "port": {
      "format": "int32",
      "type": "integer"
    },
    "username": {
      "type": "string"
    }
  },
  "required": [
    "id",
    "mailServer"
  ],
  "type": "object"
}
#>