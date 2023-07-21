################
#Discoveries
################
# /api/v2/discoveries
function Get-PPDMdiscoveries {
    [CmdletBinding()]
    param(
        #    discoveries by id not yet in api
        #    [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        #    $id,        
        # [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        # $id,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        # [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $filter,
        #       [ValidateSet()]
        #       [Alias('AssetType')][string]$type,
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



function Set-PPDMdiscoveries {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        $id, 
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('HOURLY', 'DAILY', 'MINUTES')]
        $type,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(0, 23)][int]$startHour,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(0, 60)][int]$startMinute, 
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(0, 23)][int]$hourlyFrequency, 
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(0, 60)][int]$minutesFrequency,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [switch]$Enabled,
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
                $URI = "/$myself/$id"
            }
        }
        $discovery = Get-PPDMdiscoveries | Where-Object { $_.id -match "$id" }

        $body = [ordered]@{
            id       = $ID
            start    = $discovery.start
            level    = $discovery.level
            schedule = [ordered]@{
                enabled          = $Enabled.IsPresent.ToString().ToLower()
                type             = $TYPE
                startHour        = $startHour
                startMinute      = $startMinute
                hourlyFrequency  = $hourlyFrequency
                minutesFrequency = $minutesFrequency
            }
        }   | convertto-json      
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
                write-output $response._embedded
            } 
        }   
    }
}








#{start: "/inventory-sources/69c8ac3a-3eca-55f1-a2e0-347e63a90540", level: "DataCopies"}
#level: "DataCopies"
#start: "/inventory-sources/69c8ac3a-3eca-55f1-a2e0-347e63a90540"
function Start-PPDMdiscoveries {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$id,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('DataCopies')]
        [string]$level,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('inventory-sources', 'hosts', 'storage-systems')]
        [string]$start,      
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(10) -replace "_", "-").ToLower()   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            default {
                $URI = "/$myself"
                $Body = [ordered]@{
                    'id'    = $id
                    'start' = "/$start/$id"
                    'level' = "$level"
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
                write-output ($response.content | convertfrom-json)
            } 
        }   
    }
}
