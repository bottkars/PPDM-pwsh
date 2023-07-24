function Get-PPDMService_Level_Agreements {
    [CmdletBinding()]
    [Alias('Get-PPDMSLAs')]
    param(

        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
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


<#
.SYNOPSIS
Creates a new Service Level Agreement
.EXAMPLE
New-PPDMBackupService_Level_Agreements -NAME PLATINUM -RecoverPointObjective -RecoverPointUnit HOURS -RecoverPointInterval 24 -DeletionCompliance -ComplianceWindow -ComplianceWindowCopyType ALL

id                     : c61a0e42-5327-4705-bb04-d5a1315e8fe2
name                   : PLATINUM
stageType              : PROTECTION
enabled                : True
serviceLevelObjectives : {@{definitionId=d0836fdb-dd9f-4b6a-b4c0-d99f503515f1; name=Recovery Point; stageType=PROTECTION; inUse=True; valuesList=System.Object[]},
                         @{definitionId=0c6d6f3e-5c33-432c-8603-83be349fc46a; name=Compliance Window; stageType=PROTECTION; inUse=True; valuesList=System.Object[]},
                         @{definitionId=f351f47a-7835-4351-a7fe-7c9103834ef2; name=Deletion Compliance; stageType=PROTECTION; inUse=True; valuesList=System.Object[]}}
createdAt              : 24/07/2023 12:46:49
updatedAt              : 24/07/2023 12:46:49
summary                :
_links                 : @{self=}
#>
function New-PPDMBackupService_Level_Agreements {
    [CmdletBinding()]
    [Alias('New-PPDMBackupSLA')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]  
        $NAME,
        [Parameter(Mandatory = $false, ParameterSetName = 'RPO', ValueFromPipelineByPropertyName = $true)]
        [Switch]$RecoverPointObjective,
        [Parameter(Mandatory = $false, ParameterSetName = 'RPO', ValueFromPipelineByPropertyName = $true)]
        [int64]$RecoverPointInterval,
        [Parameter(Mandatory = $false, ParameterSetName = 'RPO', ValueFromPipelineByPropertyName = $true)]
        [VAlidateSet('MINUTES', 'HOURS', 'DAYS', 'WEEKS', 'MONTHS', 'YEARS')]
        $RecoverPointUnit,




        [Parameter(Mandatory = $false, ParameterSetName = 'RPO', ValueFromPipelineByPropertyName = $true)]
        [Switch]$ComplianceWindow,       
        [Parameter(Mandatory = $false, ParameterSetName = 'RPO', ValueFromPipelineByPropertyName = $true)]
        [VAlidateSet('ALL', 'FULL', 'CUMULATIVE', 'DIFFERENTIAL', 'INCREMENTAL', 'LOG')]
        [String]$ComplianceWindowCopyType="ALL",   
        [Parameter(Mandatory = $false, ParameterSetName = 'RPO', ValueFromPipelineByPropertyName = $true)]
        [DateTime][Alias('startime')]$ComplianceWindowstarttime = "8:00PM",
        [Parameter(Mandatory = $false, ParameterSetName = 'RPO', ValueFromPipelineByPropertyName = $true)]        
        [DateTime]$ComplianceWindowendtime = "6:00AM",

        [Parameter(Mandatory = $false, ParameterSetName = 'RPO', ValueFromPipelineByPropertyName = $true)]
        [Switch]$DeletionCompliance,

        [Parameter(Mandatory = $false, ParameterSetName = 'RPO', ValueFromPipelineByPropertyName = $true)]
        [Switch]$RetentionTimeObjective,
        [Parameter(Mandatory = $false, ParameterSetName = 'RPO', ValueFromPipelineByPropertyName = $true)]
        [int64]$RetentionTimeInterval,
        [Parameter(Mandatory = $false, ParameterSetName = 'RPO', ValueFromPipelineByPropertyName = $true)]
        [VAlidateSet('MINUTES', 'HOURS', 'DAYS', 'WEEKS', 'MONTHS', 'YEARS')]
        $RetentionTimeUnit,
        [Parameter(Mandatory = $false, ParameterSetName = 'RPO', ValueFromPipelineByPropertyName = $true)]
        [Switch]$RetentionLock,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]                
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $apiver = "/api/v2"
    )

    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(14) -replace "_", "-").ToLower()
   
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

        $Body = [ordered]@{}
        $body.Add('enabled', $true)
        $body.Add('name', $Name)
        $Body.Add('serviceLevelObjectives', @())
        if ($RecoverPointObjective.IsPresent) {
            if ((!$RecoverPointInterval) -or (!$RecoverPointUnit)) {
                Write-Warning "RecoverPointInterval and RecoverPointUnit must be specified"
                return 
            }
            $StageType = [ordered]@{}
            $StageType.Add('definitionId', "d0836fdb-dd9f-4b6a-b4c0-d99f503515f1")            
            $StageType.Add('inUse', $true)
            $StageType.Add('name', 'Recovery Point')
            $StageType.Add('stageType', 'PROTECTION')
            $StageType.Add('valuesList', @())
            $ValuesList = [ordered]@{}
            $ValuesList.Add('name', 'INTERVAL')
            $ValuesList.Add('valueCardinality', "SINGLE")
            $ValuesList.Add('typedValues', @())
            $typedValues = @{}
            $typedValues.Add('dataType', 'STRING')
            switch ($RecoverPointUnit) {
                'MINUTES' {
                    $typedValues.Add('value', "PT$($RecoverPointInterval)M")
                }
                'HOURS' {
                    $typedValues.Add('value', "PT$($RecoverPointInterval)H")
                }
                'DAYS' {
                    $typedValues.Add('value', "P$($RecoverPointInterval)D")
                }  
                'WEEKS' {
                    $typedValues.Add('value', "P$($RecoverPointInterval)W")
                }
                'MONTHS' {
                    $typedValues.Add('value', "P$($RecoverPointInterval)M")
                } 
                'YEARS' {   
                    If ($RecoverPointInterval -gt 2) { 
                        Write-Warning "RTO must be Maximium 2 $RecoverPointUnit"
                        return 
                    }
                    $typedValues.Add('value', "P$($RecoverPointInterval)Y")
                }                                                  
            }
            $ValuesList.typedValues += $typedValues
            $StageType.valuesList += $ValuesList
            $Body.serviceLevelObjectives += $StageType

        }

        If ($ComplianceWindow.IsPresent) {
            $PTHours = ($ComplianceWindowstarttime - $ComplianceWindowendtime).Hours
            $StageType = [ordered]@{}
            $StageType.Add('definitionId', "0c6d6f3e-5c33-432c-8603-83be349fc46a")            
            $StageType.Add('inUse', $true)
            $StageType.Add('name', 'Compliance Window')
            $StageType.Add('stageType', 'PROTECTION')
            $StageType.Add('valuesList', @())
            $ValuesList = [ordered]@{}
            $ValuesList.Add('name', 'START_TIME')
            $ValuesList.Add('copyType', $ComplianceWindowCopyType)
            $ValuesList.Add('valueCardinality', "SINGLE")
            $ValuesList.Add('typedValues', @())
            $typedValues = @{}
            $typedValues.Add('dataType', 'TIMESTAMP')
            $typedValues.Add('value', "$(Get-Date $ComplianceWindowstarttime -Format yyyy-MM-ddThh:mm:ss.000Z)")
            $ValuesList.typedValues += $typedValues
            $StageType.valuesList += $ValuesList
            $ValuesList = [ordered]@{}
            $ValuesList.Add('name', 'DURATION')
            $ValuesList.Add('copyType', $ComplianceWindowCopyType)
            $ValuesList.Add('valueCardinality', "SINGLE")
            $ValuesList.Add('typedValues', @())
            $typedValues = @{}
            $typedValues.Add('dataType', 'STRING')
            $typedValues.Add('value', "PT$($PTHours)H")
            $ValuesList.typedValues += $typedValues
            $StageType.valuesList += $ValuesList
            $Body.serviceLevelObjectives += $StageType

            
        }




        If ($DeletionCompliance.IsPresent) {
            $StageType = [ordered]@{}
            $StageType.Add('definitionId', "f351f47a-7835-4351-a7fe-7c9103834ef2")            
            $StageType.Add('inUse', $true)
            $StageType.Add('name', 'Deletion Compliance')
            $StageType.Add('stageType', 'PROTECTION')
            $StageType.Add('valuesList', @())
            $ValuesList = [ordered]@{}
            $ValuesList.Add('name', 'VERIFY_DELETED')
            $ValuesList.Add('valueCardinality', "SINGLE")
            $ValuesList.Add('typedValues', @())
            $typedValues = @{}
            $typedValues.Add('dataType', 'BOOLEAN')
            $typedValues.Add('value', "true")
            $ValuesList.typedValues += $typedValues
            $StageType.valuesList += $ValuesList
            $Body.serviceLevelObjectives += $StageType
        }   
        
        if ($RetentionTimeObjective.IsPresent) {
            if ((!$RetentionTimeInterval) -or (!$RetentionTimeUnit)) {
                Write-Warning "RetentionTimeInterval and RetentionTimeUnit must be specified"
                return 
            }
            $StageType = [ordered]@{}
            $StageType.Add('definitionId', "967b3294-86ac-4810-b9a2-116001a59f56")            
            $StageType.Add('inUse', $true)
            $StageType.Add('name', 'Retention Lock')
            $StageType.Add('stageType', 'PROTECTION')
            $StageType.Add('valuesList', @())
            $ValuesList = [ordered]@{}
            $ValuesList.Add('name', 'RETENTION_TIME')
            $ValuesList.Add('valueCardinality', "SINGLE")
            $ValuesList.Add('typedValues', @())
            $typedValues = @{}
            $typedValues.Add('dataType', 'STRING')
            switch ($RetentionTimeUnit) {
                'MINUTES' {
                    $typedValues.Add('value', "PT$($RetentionTimeInterval)M")
                }
                'HOURS' {
                    $typedValues.Add('value', "PT$($RetentionTimeInterval)H")
                }
                'DAYS' {
                    $typedValues.Add('value', "P$($RetentionTimeInterval)D")
                }  
                'WEEKS' {
                    $typedValues.Add('value', "P$($RetentionTimeInterval)W")
                }
                'MONTHS' {
                    $typedValues.Add('value', "P$($RetentionTimeInterval)M")
                } 
                'YEARS' {   
                    If ($RetentionTimeInterval -gt 70) { 
                        Write-Warning "RetentionTime must be Maximium 70 $RetentionTimeUnit"
                        return 
                    }
                    $typedValues.Add('value', "P$($RetentionTimeInterval)Y")
                }                                                  
            }
            $ValuesList.typedValues += $typedValues
            $StageType.valuesList += $ValuesList
            $ValuesList = [ordered]@{}
            $ValuesList.Add('name', 'RETENTION_LOCK')
            $ValuesList.Add('valueCardinality', "SINGLE")
            $ValuesList.Add('typedValues', @())
            $typedValues = @{}
            $typedValues.Add('dataType', 'BOOLEAN')
            $typedValues.Add('value', $RetentionLock.IsPresent)
            $ValuesList.typedValues += $typedValues
            $StageType.valuesList += $ValuesList
            $Body.serviceLevelObjectives += $StageType
        }        
        $Body.Add('stageType', 'PROTECTION')
        $Body = $Body | convertto-json -Depth 7
        Write-Verbose ($Body | Out-String)
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
        switch ($PsCmdlet.ParameterSetName) {

            default {
                write-output $response
            } 
        }   
    }
}