
function Get-PPDMactivities {
    [CmdletBinding(ConfirmImpact = 'Low',
        HelpUri = 'https://developer.dellemc.com/data-protection/powerprotect/data-manager/tutorials/monitor-activities')]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'query', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $false, ParameterSetName = 'query', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'predefined', ValueFromPipelineByPropertyName = $true)]        
        $query,
        [Parameter(Mandatory = $true, ParameterSetName = 'query', ValueFromPipelineByPropertyName = $true)]
        $Filter,  
        [Parameter(Mandatory = $false, ParameterSetName = 'predefined', ValueFromPipelineByPropertyName = $true)]
        $days = 1,
        [Parameter(Mandatory = $true, ParameterSetName = 'predefined', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('PROTECT_OK', 'PROTECT_FAILED', 'SYSTEM_FAILED', 'SYSTEM_OK', 'CLOUD_PROTECT_OK', 'CLOUD_PROTECT_FAILED')]
        $PredefinedFilter,                         
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [alias('taskid')]$id
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
                }
                $filterstring = [System.Web.HTTPUtility]::UrlEncode($filterstring)
                $filterstring = "filter=$filterstring"
                
                if ($query) {
                    $query = "q=$query" 
                    $URI = "/$($myself)?$filterstring&$query"         
                }
                else {
                    $URI = "/$($myself)?$filterstring"
                }    
            }
            'query' {
                $filterstring = [System.Web.HTTPUtility]::UrlEncode($Filter)
                $filterstring = "filter=$filterstring"
                if ($query) {
                    $query = "q=$query" 
                    $URI = "/$($myself)?$filterstring&$query"
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
        $days = 1
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
            'default' {
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
