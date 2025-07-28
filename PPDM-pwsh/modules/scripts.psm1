#POST /api/v3/scripts
#GET /api/v3/scripts
#GET /api/v3/script-summaries 
#GET /api/v3/scripts/{id}
#GET /api/v3/script-summaries/{id}
#PATCH /api/v3/scripts/{id}
#DELETE /api/v3/scripts/{id}
#POST /api/v3/script-contexts
#GET /api/v3/script-contexts
#GET /api/v3/script-contexts/{id}
#PATCH /api/v3/script-contexts/{id}
#DELETE /api/v3/script-contexts/{id}
<#
.SYNOPSIS
Sdet a backup Script
.DESCRIPTION
Used for Pre, Post and Backup Scripts
.EXAMPLE
set-ppdMscripts -scriptfile .\example_scripts\s3_backup_rclone.sh -scriptname "OBJECT_RCLONE" -Verbose -Type BACKUP  -AssetSubType GENERIC_RCLONE -OSType LINUX
set-ppdMscripts -scriptfile .\example_scripts\s3_backup_aws_sync.sh -scriptname "OBJECT_AWS" -Verbose -Type BACKUP  -AssetSubType GENERIC_S3 -OSType LINUX
#>
function Set-PPDMscripts {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'from_file' )]
        [System.IO.FileInfo]$scriptfile,   
        [Parameter(Mandatory = $true, ParameterSetName = 'from_file' )]
        [ValidateSet(
            'BACKUP'
        )]
        $Type,  
        [Parameter(Mandatory = $true, ParameterSetName = 'from_file' )]  
        [ValidateSet(
            'GENERIC_POSTGRES',
            'GENERIC_MYSQL',
            'GENERIC_S3',
            'GENERIC_RCLONE',
            'GENERIC_PAAS_DATABASE',
            'GENERIC_MONGO_DATABASE',
            'GENERIC_REDIS_DATABASE',
            'GENERIC_MARIA_DATABASE'
        )]
        $AssetSubType,  
        [Parameter(Mandatory = $true, ParameterSetName = 'from_file' )]  
        [ValidateSet(
            'WINDOWS',
            'LINUX'
        )]
        $OSType,                    
        [Parameter(Mandatory = $true, ParameterSetName = 'from_file' )]
        [string]$scriptname, 
        [Parameter(Mandatory = $false, ParameterSetName = 'from_file' )]
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ParameterSetName = 'from_file' )]
        $apiver = "/api/v3"

    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = 'scripts'
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            default {
                $URI = "/$myself"
            }
        } 
        $content = Get-Content $scriptfile -raw
       # if ($OSType = "LINUX") {
       #     $content = $content -replace "`n", "\n"
       # }

        

        $body = @{
            name             = $scriptname
            type             = $TYPE
            osType           = $OSTYPE
            description      = ""
            content          = $content
            systemPredefined = $false
            purpose          = "BACKUP"
            extendedData     = @{
                type     = "ASSET"
                subTypes = @(
                    $AssetSubType
                )
            }
        }
        switch ($AssetSubType) {
        "GENERIC_S3" {
            $parameters       = @(
                @{
                    type        = "STRING"
                    value       = "MY_BUCKET"
                    displayName = "BUCKET"
                    alias       = "-b"
                }
                @{
                    type        = "STRING"
                    value       = "/"
                    displayName = "PREFIX"
                    alias       = "-p"                    
                }
                @{
                    type        = "STRING"
                    value       = "awsprofile"
                    displayName = "CLOUD_PROFILE"
                    alias       = "-c"                    
                } 
                @{
                    type        = "STRING"
                    value       = "https://endpoint:9000"
                    displayName = "ENDPOINT_URL"
                    alias       = "-e"                    
                }                   
                @{
                    type        = "STRING"
                    value       = "4"
                    displayName = "STREAMS"
                    alias       = "-s"                    
                }
                @{
                    type        = "STRING"
                    value       = "3"
                    displayName = "Incremental Max Age in Days"
                    alias       = "-i"                    
                } 
                @{
                    type        = "STRING"
                    value       = "9999"
                    displayName = "Full Max Age in Days"
                    alias       = "-f"                    
                } 
                                                  
            )
            $body.extendedData.subTypes[0]="GENERIC_PAAS_DATABASE"
        } 
        "GENERIC_RCLONE" {
            $parameters       = @(
                @{
                    type        = "STRING"
                    value       = "MY_BUCKET"
                    displayName = "BUCKET"
                    alias       = "-b"
                }
                @{
                    type        = "STRING"
                    value       = "''"
                    displayName = "PREFIX"
                    alias       = "-p"                    
                }
                @{
                    type        = "STRING"
                    value       = "rclone"
                    displayName = "CLOUD_PROFILE"
                    alias       = "-c"                    
                }   
                @{
                    type        = "STRING"
                    value       = "4"
                    displayName = "STREAMS"
                    alias       = "-s"                    
                }
                @{
                    type        = "STRING"
                    value       = "off"
                    displayName = "Incremental Max Age ms|s|m|h|d|w|M|y (default off)"
                    alias       = "-i"                    
                } 
                @{
                    type        = "STRING"
                    value       = "off"
                    displayName = "Full Max Age ms|s|m|h|d|w|M|y (default off)"
                    alias       = "-f"                    
                }
                                @{
                    type        = "BOOLEAN"
                    value       = "false"
                    displayName = "Versioning"
                    alias       = "-v"                    
                }                                                        
            )
            $body.extendedData.subTypes[0]="GENERIC_PAAS_DATABASE"
        }        
        "GENERIC_POSTGRES" {
            $parameters       = @(
                @{
                    type        = "STRING"
                    value       = "5432"
                    displayName = "port"
                    alias       = "-p"
                }
                @{
                    type        = "STRING"
                    value       = "/var/lib/pgsql/wal_path"
                    displayName = "wal_path"
                    alias       = "-w"                    
                }
            )
        }
    }
        
        $body.add('parameters',$parameters)
        $body = $body | convertto-json 
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'REST'
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
                Write-Host $Response
                write-host $response.Headers.Date
                Write-Host "Script has been set"
            } 
        }   
    }
}



<#
SYNOPSIS
#>

function Update-PPDMscripts {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]        
        [Parameter(Mandatory = $true, ParameterSetName = 'from_file' )]
        [ValidateSet(
            'BACKUP'
        )]
        $Type, 
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]           
        [Parameter(Mandatory = $true, ParameterSetName = 'from_file' )]  
        [ValidateSet(
            'GENERIC_POSTGRES',
            'GENERIC_MYSQL'
        )]
        $AssetSubType,                 
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]        
        [Parameter(Mandatory = $true, ParameterSetName = 'from_file' )]
        [System.IO.FileInfo]$scriptfile,  
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'from_file' )]
        [string]$scriptname, 
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'from_file' )]
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'from_file' )]
        $apiver = "/api/v3"

    )
    begin {
        $Response = @()
        $METHOD = "PATCH"
        $Myself = 'scripts'
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            default {
                $URI = "/$myself"
            }
            'byID' {
                $URI = "/$myself/$id"
                $body = @{}  

            }
        } 
        $content = (Get-Content $scriptfile | Out-String )

        $body = @{
            name             = $scriptname
            type             = $TYPE
            osType           = "LINUX"
            description      = ""
            content          = $content
            systemPredefined = $false
            parameters       = @(
                @{
                    type        = "STRING"
                    value       = "5432"
                    displayName = "port"
                    alias       = "-p"
                }
                @{
                    type        = "STRING"
                    value       = "/var/lib/pgsql/wal_path"
                    displayName = "wal_path"
                    alias       = "-w"                    
                }
            )
            purpose          = "BACKUP"
            extendedData     = @{
                type     = "ASSET"
                subTypes = @(
                    "GENERIC_POSTGRES"
                )
            }
        } | convertto-json 
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'REST'
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
                Write-Host $Response
                write-host $response.Headers.Date
                Write-Host "Script has been set"
            } 
        }   
    }
}

function Get-PPDMscripts {
    [CmdletBinding()]
    param(

        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        $filter,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet(
            ''
        )]
        $Type,        
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        $pageSize, 
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        $page, 
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        [hashtable]$body = @{orderby = 'createdAt DESC' },
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]                
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $apiver = "/api/v3"
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


function Get-PPDMscript_contexts {
    [CmdletBinding()]
    param(

        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        $filter,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet(
            ''
        )]
        $Type,        
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        $pageSize, 
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        $page, 
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        [hashtable]$body = @{orderby = 'createdAt DESC' },
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]                
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $apiver = "/api/v3"
    )

    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = 'script-contexts'
   
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

function Get-PPDMscript_summaries {
    [CmdletBinding()]
    param(

        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        $filter,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet(
            ''
        )]
        $Type,        
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        $pageSize, 
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        $page, 
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        [hashtable]$body = @{orderby = 'createdAt DESC' },
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]                
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $apiver = "/api/v3"
    )

    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = 'script-contexts'
   
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


function Remove-PPDMscripts {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        $apiver = "/api/v3"

    )
    begin {
        $Response = @()
        $METHOD = "DELETE"
        $Myself = 'scripts'
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            default {
                $URI = "/$myself"
            }
            'byID' {
                $URI = "/$myself/$id"

            }
        } 

        $Parameters = @{
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'REST'
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
                Write-Host $Response
                write-host $response.Headers.Date
                Write-Host "Script has been deleted"
            } 
        }   
    }
}