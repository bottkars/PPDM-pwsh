<#
.SYNOPSIS
Activity Monitoring
.DESCRIPTION
The first 3 Predefined Filters represent the Job View from the UI : PROTECTION_JOBS, ASSET_JOBS, SYSTEM_JOBS
The Function supports Pagination with -page and -pagesize
.EXAMPLE
# This outputs the SYSTEM JOBS of the last2 24hrs similar to UI Job View
Get-PPDMactivities -PredefinedFilter SYSTEM_JOBS
id                      : dba6095b-e95e-4c48-a304-7ae3ce5ef809
name                    : Manual Discovery for inventory source tkgi.pks.home.labbuildr.com
category                : DISCOVER
classType               : JOB_GROUP
source                  : @{type=DATA_MANAGER}
createTime              : 19/07/2023 20:04:30
updateTime              : 19/07/2023 20:05:25
startTime               : 19/07/2023 20:04:30
endTime                 : 19/07/2023 20:05:25
duration                : 44080
averageDuration         : 44080
averageBytesTransferred : 0
progress                : 100
owner                   : @{name=DISCOVERY; ownerResource=}
state                   : COMPLETED
result                  : @{status=OK; summaries=System.Object[]}
hasLogs                 : False
hasChildren             : True
actions                 : @{cancelable=False; retryable=False}
stateSummaries          : @{total=1; queued=0; running=0; pendingCancellation=0; completed=1; ok=1; okWithErrors=0; canceled=0; failed=0; unknown=0; skipped=0; criticalEvent=0}
displayId               : 137F8ADB
_links                  : @{self=}


size number totalPages totalElements
---- ------ ---------- -------------
 100      1          2           159

.EXAMPLE
# This outputs the Asset JOBS of the last2 24hrs similar to UI Job View
 Get-PPDMactivities -PredefinedFilter ASSET_JOBS
groupByOptions        : {VIRTUAL_DATACENTER, VM_GUEST_OS, VMWARE_CLUSTER, ESX_HOST…}
extendedData          : @{keyValues=System.Object[]}
id                    : 2df277d0-198b-4a6f-b5bd-fd87be4ccdb4
name                  : Protecting VM - sqlsinglenode2
category              : PROTECT
subcategory           : SYNTHETIC_FULL
parentId              : 963221ec-f61d-406e-9d7a-97148fc383b2
classType             : JOB
source                : @{type=DATA_MANAGER}
scheduleInfo          : @{type=DAILY; description=Every day; nextScheduledTime=20/07/2023 18:00:00}
createTime            : 19/07/2023 18:00:01
updateTime            : 19/07/2023 18:04:32
startTime             : 19/07/2023 18:02:05
endTime               : 19/07/2023 18:04:32
nextScheduledTime     : 20/07/2023 18:00:00
duration              : 147565
progress              : 100
owner                 : @{name=workflow}
state                 : COMPLETED
result                : @{status=OK; summaries=System.Object[]; bytesTransferred=819986432}
hasLogs               : False
hasChildren           : True
actions               : @{cancelable=False; retryable=False}
protectionPolicy      : @{id=62095aab-ccf6-4d23-8563-63f61c86bf47; name=VM_TAG_BASED_AA; type=VMWARE_VIRTUAL_MACHINE}
asset                 : @{id=43d16419-d9c4-54ab-9995-0d25bb93a8fb; name=sqlsinglenode2; type=VMWARE_VIRTUAL_MACHINE}
initiatedType         : SCHEDULED
activityInitiatedType : SCHEDULED
storageSystem         : @{id=aa0b484c-8f1e-4749-99c1-91f3611ab3b1; name=ddve.home.labbuildr.com}
inventorySource       : @{id=69c8ac3a-3eca-55f1-a2e0-347e63a90540; name=vcsa1.home.labbuildr.com; type=VCENTER}
stats                 : @{numberOfAssets=1; numberOfProtectedAssets=1; bytesTransferredThroughput=5359388; bytesTransferredThroughputUnitOfTime=second; assetSizeInBytes=608811614208; preCompBytes=819986432; postCompBytes=298365110; bytesTransferred=819986432; dedupeRatio=2,74826514400427; reductionPercentage=63,6134089106489; storageCompStats=}
_links                : @{self=}


size number totalPages totalElements
---- ------ ---------- -------------
  43      1          1            43

.EXAMPLE
Get-PPDMactivities -PredefinedFilter PROTECTION_JOBS
id                      : 3340d0ec-5631-4fee-8c60-4ce970a2f46e
name                    : Manual Discovery for inventory source tkgi.pks.home.labbuildr.com
category                : DISCOVER
classType               : JOB_GROUP
source                  : @{type=DATA_MANAGER}
createTime              : 20/07/2023 05:14:45
updateTime              : 20/07/2023 05:15:55
startTime               : 20/07/2023 05:14:45
endTime                 : 20/07/2023 05:15:55
duration                : 44042
averageDuration         : 44042
averageBytesTransferred : 0
progress                : 100
owner                   : @{name=DISCOVERY; ownerResource=}
state                   : COMPLETED
result                  : @{status=OK; summaries=System.Object[]}
hasLogs                 : False
hasChildren             : True
actions                 : @{cancelable=False; retryable=False}
stateSummaries          : @{total=1; queued=0; running=0; pendingCancellation=0; completed=1; ok=1; okWithErrors=0; canceled=0; failed=0; unknown=0; skipped=0; criticalEvent=0}
displayId               : 781B6668
_links                  : @{self=}


size number totalPages totalElements
---- ------ ---------- -------------
 100      1          7           680
.EXAMPLE
## Get all Failed Activitis
Get-PPDMactivities -PredefinedFilter PROTECT_FAILED
.EXAMPLE
## Get All Failed Activities last Day
Get-PPDMactivities -PredefinedFilter PROTECT_FAILED -days 1 
.EXAMPLE
## Get All Failed Activities last Day that are retryable
Get-PPDMactivities -PredefinedFilter PROTECT_FAILED -days 1 | where { $_.actions.retryable -eq $True }
.EXAMPLE
## Restart  All Failed Activities last Day taht are Restartable
Get-PPDMactivities -PredefinedFilter PROTECT_FAILED -days 1 | where { $_.actions.retryable -eq $True } | Restart-PPDMactivities
.EXAMPLE
# all protection Jobs last week
# get a date stamp from -1 week ( Adjust to you duration)
$myDate=(get-date).AddDays(-7)
$usedate=get-date $myDate -Format yyyy-MM-ddThh:mm:ssZ
$FILTER='startTime ge "'+$usedate+'" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CLOUD_TIER","EXPORT_REUSE","PROTECT","REPLICATE","RESTORE","CLOUD_PROTECT")'
Get-PPDMactivities -Filter $FILTER  | Select-Object * -ExpandProperty result | ft 
.EXAMPLE
# all failed last week
# get a date stamp from -1 week ( Adjust to you duration)
$myDate=(get-date).AddDays(-7)
$usedate=get-date $myDate -Format yyyy-MM-ddThh:mm:ssZ
FILTER='startTime ge "'+$usedate+'" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CLOUD_TIER","EXPORT_REUSE","PROTECT","REPLICATE","RESTORE","CLOUD_PROTECT") and result.status eq "FAILED"'
Get-PPDMactivities -Filter $FILTER  | Select-Object * -ExpandProperty result | ft 
.EXAMPLE
# Protect SUCCEEDED
# get a date stamp from -1 week ( Adjust to you duration)
$myDate=(get-date).AddDays(-7)
$usedate=get-date $myDate -Format yyyy-MM-ddThh:mm:ssZ$FILTER='result.status in  ("OK","OK_WITH_ERRORS") and startTime ge "'+$usedate+'" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("PROTECT")'
Get-PPDMactivities -Filter $FILTER  | Select-Object * -ExpandProperty result | ft 
.EXAMPLE
# filter for failed system jobs
# get a date stamp from -1 week ( Adjust to you duration)
$myDate=(get-date).AddDays(-7)
$usedate=get-date $myDate -Format yyyy-MM-ddThh:mm:ssZ
$FILTER='startTime ge "'+$usedate+'" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CONSOLE","CONFIG","CLOUD_DR","CLOUD_COPY_RECOVER","DELETE","DISASTER_RECOVERY","DISCOVER","MANAGE","NOTIFY","SYSTEM","VALIDATE") and result.status eq "FAILED"'
.EXAMPLE
# filter for Successfull system:
# get a date stamp from -1 week ( Adjust to you duration)
$myDate=(get-date).AddDays(-7)
$usedate=get-date $myDate -Format yyyy-MM-ddThh:mm:ssZ$FILTER='startTime ge "'+$usedate+'" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CONSOLE","CONFIG","CLOUD_DR","CLOUD_COPY_RECOVER","DELETE","DISASTER_RECOVERY","DISCOVER","MANAGE","NOTIFY","SYSTEM","VALIDATE") and result.status eq "OK"'
#>

function Get-PPDMactivities {
    [CmdletBinding(ConfirmImpact = 'Low',
        HelpUri = 'https://developer.dell.com/apis/4378/versions/19.13.0/docs/tasks/monitor-activities.md')]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'predefined', ValueFromPipelineByPropertyName = $true)]
        $days = 1,
        [Parameter(Mandatory = $TRUE, ParameterSetName = 'predefined', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('PROTECTION_JOBS', 'ASSET_JOBS', 'SYSTEM_JOBS', 'RUNNING', 'QUEUED', 'PROTECT_OK', 'PROTECT_FAILED', 'SYSTEM_FAILED', 'SYSTEM_OK', 'CLOUD_PROTECT_OK', 'CLOUD_PROTECT_FAILED')]
        $PredefinedFilter,  
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [alias('taskid', 'id')]$activityId,

        [Parameter(Mandatory = $false, ParameterSetName = 'predefined', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        $filter,
        [Parameter(Mandatory = $false, ParameterSetName = 'predefined', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        $query,
        [Parameter(Mandatory = $false, ParameterSetName = 'predefined', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        $pageSize, 
        [Parameter(Mandatory = $false, ParameterSetName = 'predefined', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        $page, 
        [Parameter(Mandatory = $false, ParameterSetName = 'predefined', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        [hashtable]$body = @{orderby = 'createdAt DESC' },
        [Parameter(Mandatory = $false, ParameterSetName = 'predefined', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ParameterSetName = 'predefined', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        $apiver = "/api/v2"
    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "/").ToLower()
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'predefined' {
                $myDate = (get-date).AddDays(-$days)
                $timespan = get-date $myDate -Format yyyy-MM-ddThh:mm:ssZ

                switch ($PredefinedFilter) {
                    'PROTECT_OK' {
                        $filterstring = 'result.status in ("OK","OK_WITH_ERRORS") and startTime ge "' + $timespan + '" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("PROTECT")'
                    }
                    'PROTECT_FAILED' {
                        $filterstring = 'result.status in ("FAILED") and startTime ge "' + $timespan + '" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("PROTECT")'
                    }
                    'SYSTEM_FAILED' {
                        $filterstring = 'startTime ge "' + $timespan + '" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CONSOLE","CONFIG","CLOUD_DR","CLOUD_COPY_RECOVER","DELETE","DISASTER_RECOVERY","DISCOVER","MANAGE","NOTIFY","SYSTEM","VALIDATE") and result.status eq "FAILED"'                    
                    }
                    'SYSTEM_OK' {
                        $filterstring = 'startTime ge "' + $timespan + '" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CONSOLE","CONFIG","CLOUD_DR","CLOUD_COPY_RECOVER","DELETE","DISASTER_RECOVERY","DISCOVER","MANAGE","NOTIFY","SYSTEM","VALIDATE") and result.status eq "OK"'
                    }
                    'CLOUD_PROTECT_OK' {
                        $filterstring = 'startTime ge "' + $timespan + '" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CLOUD_PROTECT") and result.status eq "OK"'
                    }

                    'CLOUD_PROTECT_FAILED' {
                        $filterstring = 'startTime ge "' + $timespan + '" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CLOUD_PROTECT") and result.status eq "FAILED"'
                    }
                    'QUEUED' {
                        $filterstring = 'createTime gt "' + $timespan + '" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CLOUD_TIER","EXPORT_REUSE","PROTECT","REPLICATE","RESTORE","CLOUD_PROTECT") and state eq "QUEUED"'
                    }
                    'RUNNING' {
                        $filterstring = 'createTime gt "' + $timespan + '" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CLOUD_TIER","EXPORT_REUSE","PROTECT","REPLICATE","RESTORE","CLOUD_PROTECT") and state eq "RUNNING"'
                    }
                    'SYSTEM_JOBS' {
                        $filterstring = 'createTime gt "' + $timespan + '" and parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("HOST_CONFIGURATION","CLOUD_COPY_RECOVER","CLOUD_DR","CONFIG","DELETE","DISASTER_RECOVERY","DISCOVER","MANAGE","NOTIFY","SYSTEM","VALIDATE")'
                    }
                    'ASSET_JOBS' {
                        $filterstring = 'createTime gt "' + $timespan + '" and classType eq "JOB" and asset.id ne null"'
                    }
                    'PROTECTION_JOBS' {
                        $filterstring = 'createTime gt "' + $timespan + '" parentId eq null and classType in ("JOB", "JOB_GROUP") and category in ("CLOUD_PROTECT","CLOUD_TIER","EXPORT_REUSE","INDEX","INSTANT_ACCESS_ATTACH","INSTANT_ACCESS_DELETE_SESSION","INSTANT_ACCESS_DETACH","PROTECT","REPLICATE","RESTORE")'
                    }
                }

                if ($filter) {
                    $filter = "$filterstring and $filter"
                }
                else {
                    $filter = $filterstring
                }  
                $URI = "/$myself"
            }

            'byID' {
                $URI = "/$myself/$activityId"
            }
            default {
                $URI = "/$myself/$activityId"
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
        if ($filter) {
            $parameters.Add('filter', $filter)
        }
        if ($query) {
            $Parameters.body.Add('q', $query)
        }    
        Write-Verbose ($Parameters | Out-String)       
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





# GET /api/v2/activity-categories
function Get-PPDMactivity_categories {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        $filter,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        $apiver = "/api/v2",
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
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
                $body = @{}  

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
            } 
        }   
    }
}

# /api/v2/activity-metrics
function Get-PPDMactivity_metrics {
    [CmdletBinding(ConfirmImpact = 'Low',
        HelpUri = 'https://developer.dellemc.com/data-protection/powerprotect/data-manager/api/monitoring/getallactivitymetrics')]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        [switch]$states,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
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
            default {
                if ($States.IsPresent) {
                   write-output $response.statusesAndStates 
                }
                else {
                    $response.aggregation
                }
            } 
        }   
    }
}


#/api/v2/activities/{id}/cancel
function Stop-PPDMactivities {
    [CmdletBinding(ConfirmImpact = 'Low',
        HelpUri = 'https://developer.dellemc.com/data-protection/powerprotect/data-manager/api/monitoring/getallactivitymetrics')]
    param(
        [Parameter(Mandatory = $True, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        $Id,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(9) -replace "_", "-").ToLower()
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            default {
                $URI = "/$myself/$id/cancel"
            }
        }        
        try {
            $Response += Invoke-PPDMapirequest -uri $URI -Method $METHOD  -apiver $apiver -PPDM_API_BaseUri $PPDM_API_BaseUri -Verbose:($PSBoundParameters['Verbose'] -eq $true)
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
                write-output $response.content 
            } 
        }   
    }
}




#/api/v2/activities/{id}/retry
<#
.SYNOPSIS
This commands restarts failed activities by id. id can come frome pipeline
.EXAMPLE
# restart failed activities 
Get-PPDMactivities -PredefinedFilter PROTECT_FAILED -days 1 | where { $_.actions.retryable -eq $True } | Restart-PPDMactivities
#>
function Restart-PPDMactivities {
    [CmdletBinding(ConfirmImpact = 'Low',
        HelpUri = 'https://developer.dellemc.com/data-protection/powerprotect/data-manager/api/monitoring/getallactivitymetrics')]
    param(
        [Parameter(Mandatory = $True, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        $Id,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
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
                $URI = "/$myself/$id/retry"
            }
        }        
        try {
            $Response += Invoke-PPDMapirequest -uri $URI -Method $METHOD  -apiver $apiver -PPDM_API_BaseUri $PPDM_API_BaseUri -Verbose:($PSBoundParameters['Verbose'] -eq $true)
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
                write-output $response.content 
            } 
        }   
    }
}




function Request-PPDMActivityLog {
    [CmdletBinding()]
    [Alias('Request-PPDMJobLog')]
    param(
        [Parameter(Mandatory = $True, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        $Id,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = 'log-exports'
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            default {
                $URI = "/$myself"
            }
        }
        $body = @{
            filterType  = "ACTIVITY_ID"
            filterValue = $ID
        } | ConvertTo-Json
        write-verbose ($body | Out-String)  
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            ContentType      = "application/json"
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
.Synopsis
Saves logs for a given activity
.Description
Download the logfilöe for an activity thta was previously requestet

.Example
# get a list of failed activities the last day
Get-PPDMactivities -PredefinedFilter PROTECT_FAILED -days 1 | ft
name                                                            id
----                                                            --
Manually Protecting Kubernetes - test - PROTECTION - Full 71725a9e-3e76-4ccd-8945-099fad7cdbdc
Protecting Kubernetes - Test-ppdm - PROTECTION - Synthetic Full 82eb1e50-7a35-418d-aba0-f8875932310a
Protecting Kubernetes - Test-ppdm - PROTECTION - Synthetic Full dad021ce-90b5-4a9c-8398-57102aecdefa
# use id 71725a9e-3e76-4ccd-8945-099fad7cdbdc and request logs
Request-PPDMActivityLog -id 71725a9e-3e76-4ccd-8945-099fad7cdbdc

id
--
b70a83f9-b55d-4836-944a-ffeaf7ef2782
# a new job is create with above it, 


Get-PPDMactivities -id b70a83f9-b55d-4836-944a-ffeaf7ef2782

id                      : b70a83f9-b55d-4836-944a-ffeaf7ef2782
name                    : Creating Log Bundle for specific job A6FA6E48: Manually Protecting Kubernetes - test - PROTECTION - Full
category                : SYSTEM
subcategory             : LOG_EXPORT
classType               : JOB_GROUP
source                  : @{type=DATA_MANAGER}
createTime              : 16.09.2022 10:19:56
updateTime              : 16.09.2022 10:20:14
startTime               : 16.09.2022 10:19:56
endTime                 : 16.09.2022 10:20:14
duration                : 17486
averageDuration         : 0
averageBytesTransferred : 0
progress                : 100
owner                   : @{name=LogManager}
state                   : COMPLETED
result                  : @{status=OK; summaries=System.Object[]}
hasLogs                 : False
hasChildren             : True
actions                 : @{cancelable=False; retryable=False}
stateSummaries          : @{total=1; queued=0; running=0; pendingCancellation=0; completed=1; ok=1; okWithErrors=0; canceled=0; failed=0; unknown=0; skipped=0; criticalEvent=0}
displayId               : BF2CD53F
_links                  : @{self=}

### once the job shoes completed, download the logs with the id of the failed activity

Save-PPDMActivityLog -id 71725a9e-3e76-4ccd-8945-099fad7cdbdc -FileName $log.zip


.Example
Get all Assets using Pagination
Get-PPDMassets -body @{pageSize=10;page=2}
#>

function Save-PPDMActivityLog {
    [CmdletBinding()]
    [Alias('Save-PPDMJobLog')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        $FileName,        
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = "log-exports"
   
    }     
    Process {
        $URI = "/$myself/$id/file"
        $Parameters = @{
            RequestMethod    = 'REST'
            Uri              = $URI
            Method           = $Method
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
            OutFile          = $Filename   
        }
        write-verbose ($Parameters | Out-String)  
    
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