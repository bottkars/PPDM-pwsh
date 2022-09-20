
function Get-PPDMactivities {
    [CmdletBinding(ConfirmImpact = 'Low',
        HelpUri = 'https://developer.dellemc.com/data-protection/powerprotect/data-manager/tutorials/monitor-activities')]
    [Alias('Get-PPDMJob')]
    param(
 #       [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'query', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'predefined', ValueFromPipelineByPropertyName = $true)]        
        $query,
        [Parameter(Mandatory = $true, ParameterSetName = 'query', ValueFromPipelineByPropertyName = $true)]
        $Filter,  
        [Parameter(Mandatory = $false, ParameterSetName = 'predefined', ValueFromPipelineByPropertyName = $true)]
        $days = 1,
        [Parameter(Mandatory = $true, ParameterSetName = 'predefined', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('RUNNING','QUEUED','PROTECT_OK', 'PROTECT_FAILED', 'SYSTEM_FAILED', 'SYSTEM_OK', 'CLOUD_PROTECT_OK', 'CLOUD_PROTECT_FAILED')]
        $PredefinedFilter,                         
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [alias('taskid')]$id,
        [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
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
                }
                $filterstring = [System.Web.HTTPUtility]::UrlEncode($filterstring)
                $filterstring = "filter=$filterstring"
                
                if ($query) {
                    $query = "q=$query" 
                    $URI = "/$($myself)?pageSize=25&page=1&orderby=createTime%20DESC&$filterstring&$query"         
                }
                else {
                    $URI = "/$($myself)?pageSize=25&page=1&orderby=createTime%20DESC&$filterstring"
                }    
            }
            'query' {
                $filterstring = [System.Web.HTTPUtility]::UrlEncode($Filter)
                $filterstring = "filter=$filterstring"
                if ($query) {
                    $query = "q=$query" 
                    $URI = "/$($myself)?pageSize=25&page=1&orderby=startTime%20DESC&$filterstring&$query"
                }
                else {
                    $URI = "/$($myself)?$filterstring"
                }    
            }
            'byID' {
                $URI = "/$myself/$id"
            }
            default {
                $URI = "/$myself"
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
            'byID' {
                write-output $response | convertfrom-json
            }
            default {
                write-output ($response | convertfrom-json).content
            } 
        }   
    }
}

# /api/v2/activity-metrics


function Get-PPDMactivity_metrics {
    [CmdletBinding(ConfirmImpact = 'Low',
        HelpUri = 'https://developer.dellemc.com/data-protection/powerprotect/data-manager/api/monitoring/getallactivitymetrics')]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        $days = "1"
    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
   
    }     
    Process {
        $myDate = (get-date).AddDays(-$days)
        $timespan = get-date $myDate -Format yyyy-MM-ddThh:mm:ssZ
        $filter = 'parentId eq null and classType in ("JOB", "JOB_GROUP") and createTime gt "' + $timespan + '" and category in ("CLOUD_TIER","EXPORT_REUSE","PROTECT","REPLICATE","RESTORE","CLOUD_PROTECT")'
        $filter = [System.Web.HTTPUtility]::UrlEncode($filter) 
        switch ($PsCmdlet.ParameterSetName) {
            default {
                $URI = "/$($myself)?filter=$filter"
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
            'byID' {
                write-output $response | convertfrom-json
            }
            default {
                write-output ($response | convertfrom-json).aggregation
            } 
        }   
    }
}


#/api/v2/activities/{id}/retry
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
            filterType = "ACTIVITY_ID"
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
            ContentType     = "application/json"
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