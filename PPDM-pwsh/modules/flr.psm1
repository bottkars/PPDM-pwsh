#      data: 
#        copyId: 178050da-5cf8-5732-ae28-5cac05229d7b
#       targetVmAssetId: 2def57c4-2278-57cf-b0a0-b0a716c1791b
#        targetUser: root
#        targetPassword: lola2605
#       removeAgent: false
#        elevateUser: false


function Start-PPDMflr_sessions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$targetVmAssetId,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$copyId,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [pscredential]$credentials,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [switch]$removeAgent,    
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [switch]$elevateUser,        
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(10) -replace "_", "-").ToLower()   
    }     
    Process {
        if (!$($Credentials)) {
            $username = Read-Host -Prompt "Please a username for Host Connection to FLR CLient"
            $SecurePassword = Read-Host -Prompt "Enter Password for user $username" -AsSecureString
            $Credentials = New-Object System.Management.Automation.PSCredential($username, $Securepassword)
        }
        switch ($PsCmdlet.ParameterSetName) {
            default {
                $URI = "/$myself"
                $Body = [ordered]@{
                    'copyId'          = $copyId
                    'targetVmAssetId' = $targetVmAssetId
                    'targetUser'      = $($Credentials.GetNetworkCredential()).username
                    'targetPassword'  = $($Credentials.GetNetworkCredential()).password
                    'removeAgent'     = $removeAgent.IsPresent
                    'elevateUser'     = $elevateUser.IsPresent                
                } | ConvertTo-Json
            }
        } 
        Write-Verbose ($Body | Out-String)
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
            RequestMethod    = 'Rest'
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

function Remove-PPDMflr_sessions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [alias('flrSessionId')]$id,  
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $apiver = "/api/v2",
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [hashtable]$body = @{pageSize = 200 }  
    )
    begin {
        $Response = @()
        $METHOD = "DELETE"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(11) -replace "_", "-").ToLower()
   
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
            RequestMethod    = 'REST'
            body             = $body
            Uri              = $URI
            Method           = $Method
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
            retries          = $retries
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

function Get-PPDMflr_sessions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [alias('flrSessionId')]$id,
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [int]$retries = 1,
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [int]$timeout = 1,        
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $apiver = "/api/v2",
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [switch]$files,        
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [hashtable]$body = @{pageSize = 200 }  
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
        if ($files.IsPresent) {
            $URI = "$URI/files"
        } 
        $Parameters = @{
            RequestMethod    = 'REST'
            body             = $body
            Uri              = $URI
            Method           = $Method
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
            retries          = $retries
            timeout          = $timeout
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
        if ($files.IsPresent) {
            write-output $response.content
        }             
        else {
            write-output $response
                
        } 
    }   
}


function Get-PPDMflr_filelisting {
    [CmdletBinding()]
    [Alias('Get-PPDMFLRfiles')]

    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [alias('flrSessionId')]$id,
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $apiver = "/api/v2",      
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [hashtable]$body = @{pageSize = 200 }  
    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = "flr-sessions"
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id/files"
            }
            default {
                $URI = "/$myself/$id/files"
            }
        } 
        if ($files.IsPresent) {
            $URI = "$URI/files"
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

        write-output $response.content

    }   
}


function Set-PPDMflr_sessions {
    [CmdletBinding()]
    [Alias('Set-PPDMFLRbrowsescope')]

    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [alias('flrSessionId')]$id,
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $apiver = "/api/v2",
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [switch]$browseDestination,
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$directory,                 
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [hashtable]$body = @{pageSize = 200 }  
    )
    begin {
        $Response = @()
        $METHOD = "PUT"
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
        if ($browseDestination) {
            $body.Add('browseDest', $browseDestination.IsPresent)
        } 
        if ($directory) {
            $body.Add('directory', $directory)
        } 

        $body = $body | ConvertTo-Json
        Write-Verbose ($body | out-string)
        $Parameters = @{
            RequestMethod    = 'REST'
            body             = $body
            Uri              = $URI
            Method           = $Method
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
        if ($files.IsPresent) {
            write-output $response.content
        }             
        else {
            write-output $response
                
        } 
    }   
}


function Restore-PPDMflr_sessions {
    [CmdletBinding()]
    [Alias('Restore-PPDMFLR')]

    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [alias('flrSessionId')]$id,
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string[]]$FilePaths,
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $apiver = "/api/v2",
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [switch]$keepExisting,
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [switch]$restoreToOriginalPath,        
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$targetdirectory = "/tmp",                 
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [hashtable]$body = @{pageSize = 200 }  
    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(12) -replace "_", "-").ToLower()
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id/tasks"
            }
            default {
                $URI = "/$myself"
            }
        }         
        if ($keepExisting) {
            $body.Add('overwriteExisting', $false)
        } 
        if ($restoreToOriginalPath.IsPresent) {
            $body.Add('restoreToOriginalPath', $true)
        }
        else { $body.Add('targetDirectory', $targetDirectory) }
            
        $body.Add('filePaths', $FilePaths)

        $body = $body | ConvertTo-Json
        Write-Verbose ($body | out-string)
        $Parameters = @{
            RequestMethod    = 'REST'
            body             = $body
            Uri              = $URI
            Method           = $Method
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
        if ($files.IsPresent) {
            write-output $response.content
        }             
        else {
            write-output $response
                
        } 
    }   
}


<#
filter: 
objectType eq "FS" and 
name lk "file*" 
and type lk "%*.txt%" 
and updatedAt ge "2023-07-07T13:38:20Z" 
and itemType eq "file" 
and createdAt ge "2023-08-06T13:38:13Z" 
and size ge 1000000 
and size le 200000000 
and copyEndDate eq null 
and sourceServer lk "%win*%" 
and assetId eq "434ba5f0-3c5d-5bba-aba3-1d26684fcabe"
#>


function Get-PPDMfile_instances {
    [CmdletBinding()]
    param(


        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        [Alias('filename')]$name,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        [Alias('filepath')]$location,        
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        [switch]$filesonly,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        $filetype,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]        
        $minsize,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]        
        [ValidateSet('KB', 'MB', 'GB', 'TB')]$minsizeUnit = "KB",
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]        
        $maxsize,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]        
        [ValidateSet('KB', 'MB', 'GB', 'TB')]$maxsizeUnit = "KB",
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]        
        [datetime]$CreatedAtStart,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]        
        [datetime]$CreatedAtEnd,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]        
        [datetime]$modifiedAtStart,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]        
        [datetime]$modifiedAtEnd,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]        
        [datetime]$BackupAtStart,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]        
        [datetime]$BackupAtEnd,  
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]        
        [string]$SourceServer,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]        
        [string]$AssetID,                             
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
            default {
                $URI = "/$myself"
            }
        }  
        $Filter = 'objectType eq "FS"'
        if ($name) {
            $filter = $filter + ' and name lk "' + $name + '"' 
        }
        if ($filetype) {
            $filter = $filter + ' and name lk "%' + $filetype + '%"' 
        }

        if ($modifiedAtStart) {
            if ($modifiedAtEnd) {
                $Filter = $filter + ' and updatedAt ge "' + $(get-date $modifiedAtStart -Format yyyy-MM-ddT00:00:00Z) + '" and updatedAt le "' + $(get-date $modifiedAtEnd -Format yyyy-MM-ddT23:59:59Z) + '"'
            }
            else {
                $Filter = $filter + ' and updatedAt ge "' + $(get-date $modifiedAtStart -Format yyyy-MM-ddThh:mm:ssZ) + '"'
            }

        }

        if ($CreatedAtStart) {
            if ($CreatedAtEnd) {
                $Filter = $filter + ' and updatedAt ge "' + $(get-date $CreatedAtStart -Format yyyy-MM-ddT00:00:00Z) + '" and updatedAt le "' + $(get-date $CreatedAtEnd -Format yyyy-MM-ddT23:59:59Z) + '"'
            }
            else {
                $Filter = $filter + ' and updatedAt ge "' + $(get-date $CreatedAtStart -Format yyyy-MM-ddThh:mm:ssZ) + '"'
            }

        }

        if ($BackupAtStart) {
            if ($BackupAtEnd) {
                $Filter = $filter + ' and (( copyEndDate gt "' + (get-date $BackupAtStart -Format yyyy-MM-ddT00:00:00Z) + '" and copyEndDate le "' + (get-date $BackupAtEnd -Format yyyy-MM-ddT23:59:59Z) + '") or ( copyStartDate le "' + (get-date $BackupAtEnd -Format yyyy-MM-ddT23:59:59Z) + '" and ( copyEndDate eq null or copyEndDate gt "' + (get-date $BackupAtEnd -Format yyyy-MM-ddT23:59:59Z) + '" )))'
            }
            else {
                $Filter = $filter + ' and (( copyEndDate gt "' + (get-date $BackupAtStart -Format yyyy-MM-ddT00:00:00Z) + '" and copyEndDate le "' + (get-date $BackupAtStart -Format yyyy-MM-ddT23:59:59Z) + '") or ( copyStartDate le "' + (get-date $BackupAtStart -Format yyyy-MM-ddT23:59:59Z) + '" and ( copyEndDate eq null or copyEndDate gt "' + (get-date $BackupAtStart -Format yyyy-MM-ddT23:59:59Z) + '" )))'
            }

        }


        if ($filesonly.IsPresent) {
            $filter = $filter + ' and itemType lk "file"'
        }
        if ($minsize) {
            $filter = $filter + ' and size ge ' + ($minsize * "1$minsizeunit")  
        } 
        if ($maxsize) {
            $filter = $filter + ' and size ge ' + ($maxsize * "1$maxsizeunit") 
        }   
        if ($SourceServer) {
            $filter = $filter + ' and sourceServer lk "%' + $SourceServer + '%"' 
        }   
        if ($location) {
            $filter = $filter + ' and location lk "%' + $location + '%"' 
        }             
        if ($AssetID) {
            $filter = $filter + ' and assetId eq "' + $AssetID + '"'
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



function Request-PPDMfile_backups {
    [CmdletBinding()]
    param(

        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipeline = $true)]
        [psobject]$fileinstance,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]     
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $apiver = "/api/v2"
    )

    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(12) -replace "_", "-").ToLower()
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            default {
                $URI = "/file-instances/file-backups?backupInfo=latest"
            }
        }  
#        $fileinstance = $fileinstance | select-object 
        $body = @{'fileInstances' = @($fileinstance) } | ConvertTo-Json
  
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
