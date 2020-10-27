
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
        try {
            $Response += Invoke-PPDMapirequest -uri $URI -Method $METHOD -Body "$body" -apiver $apiver -PPDM_API_BaseUri $PPDM_API_BaseUri
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
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false)]
        [ValidateSet('FULL', 'GEN0', 'DIFFERENTIAL', 'LOG', 'INCREMENTAL', 'CUMULATIVE', 'AUTO_FULL')]
        $BackupType = 'FULL',
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false)]
        [ValidateSet('DAY', 'WEEK', 'MONTH', 'YEAR' )]
        $RetentionUnit = 'DAY',
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false)]
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
            'disableProtectionPolicyProcessing' = false
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
                write-output ($response | convertfrom-json).content
            } 
        }   
    }
}


