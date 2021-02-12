function Get-PPDMprotection_policies {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [switch]$asset_assignments,
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
                if ($asset_assignments.IsPresent) {
                    $URI = "$URI/asset-assignments"
                }    
            }
            default {
                $URI = "/$myself"
            }
        } 
        $Parameters = @{
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
            'byID' {
                if ( $asset_assignments.IsPresent ) {
                    write-output ($response | convertfrom-json).content
                }
                else {
                    write-output $response | convertfrom-json
                }            
            }
            default {
                write-output ($response | convertfrom-json).content
            } 
        }   
    }
}

function Start-PPDMprotection_policies {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string][alias('id')]$PolicyID,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidateSet('FULL', 'GEN0', 'DIFFERENTIAL', 'LOG', 'INCREMENTAL', 'CUMULATIVE', 'AUTO_FULL')]
        $BackupType = 'FULL',
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidateSet('DAY', 'WEEK', 'MONTH', 'YEAR' )]
        $RetentionUnit = 'DAY',
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [Int32]$RetentionInterval = '7'        

    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(10) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself"
            }
            default {
                $URI = "/$myself"
            }
        }    
        $Body = [ordered]@{
            'assetIds'                          = $AssetIDs
            'backupType'                        = $BackupType
            'disableProtectionPolicyProcessing' = 'false'
            'retention'                         = @{
                'interval' = $RetentionInterval
                'unit'     = $RetentionUnit
            }
        } | convertto-json -compress
        write-verbose ($body | out-string)
        $Parameters = @{
            body             = $body 
            Uri              = "/$Myself/$PolicyID/backups"
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
                write-output ($response | convertfrom-json)
            } 
        }   
    }
}
##

##

function New-PPDMprotection_policies {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True, ValueFromPipeline = $false)]
        [ValidateLength(1, 150)][string]$Name,
        [Parameter(Mandatory = $True, ValueFromPipeline = $false)]
        [ValidateSet('VMAX_STORAGE_GROUP',
            'VMWARE_VIRTUAL_MACHINE',
            'ORACLE_DATABASE',
            'MICROSOFT_SQL_DATABASE',
            'FILE_SYSTEM',
            'KUBERNETES',
            'SAP_HANA_DATABASE',
            'MICROSOFT_EXCHANGE_DATABASE'
        )]
        $assetType,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidateSet('CRASH_CONSISTENT',
            'APPLICATION_CONSISTENT' )]
        $dataConsistency = 'CRASH_CONSISTENT',
        [Parameter(Mandatory = $true, ValueFromPipeline = $false)]
        [switch]$enabled,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [DateTime]$startime = "8:00 PM",
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [DateTime]$endtime = "6:00 AM",
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [switch]$passive,  
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [switch]$encrypted, 
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [switch]$forceFull,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [string]$Description = '' ,
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
            default {
                $URI = "/$myself"
            }

        }
        Write-Verbose "Casting Time"
        [DateTIme]$RunTime = $startime - $endtime     
        $Body = [ordered]@{ 
            'name' = $Name
            'assetType' = $assetType
            'type' = 'ACTIVE'
            'dataConsistency' = $dataConsistency
            'enabled' = $enabled.IsPresent
            'description' = $Description
            'encrypted' = $encrypted.IsPresent
            'priority' = 1
            'passive' = $passive.IsPresent
            'forceFull' = $forceFull.IsPresent
            'details' = @{
                'vm' = @{
                    'protectionEngine' = 'VMDIRECT'
                }
            }
            'stages' = @(
                @{
                    'id'            = (New-Guid).Guid   
                    'type'          = 'PROTECTION'
                    'passive'       = $passive.IsPresent
                    'target'        = @{
                        'storageSystemId' = 'ed9a3cd6-7e69-4332-a299-aaf258e23328'
                    }
                    'operations'    = @(
                        @{
                            'backupType' = 'SYNTHETIC_FULL'
                            'schedule'   = @{
                                'frequency'  = 'MONTHLY'
                                'duration'   = 'PT10H'
                                'dayOfMonth' = 1
                            }
                        }
                    )
                    'retention'     = @{
                        'interval' = 1
                        'unit'     = 'MONTH'
                    }
                }
            ) 
        }| convertto-json -Depth 7
            write-verbose ($body | out-string)
            $Parameters = @{
                body = $body 
                Uri = "/$Myself"
                Method = $Method
                PPDM_API_BaseUri = $PPDM_API_BaseUri
                apiver = $apiver
                Verbose = $PSBoundParameters['Verbose'] -eq $true
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
                    write-output ($response | convertfrom-json)
                } 
            }   
        }
    }

