# server-disaster-recovery-backups
#/api/v2/server-disaster-recovery-configurations
#backupsEnabled: true
#id: "{{ sdr_configuration_id }}"
#repositoryHost: "{{ lookup('env','TF_VAR_ddve_hostname') }}.{{ lookup('env','TF_VAR_env_name') }}.{{ lookup('env','TF_VAR_dns_suffix') }}"
#repositoryPath: "/data/col1/powerprotect"
#type: DD
function Get-PPDMserver_disaster_recovery_configurations {
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
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
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
#backupsEnabled: true
#id: "{{ sdr_configuration_id }}"
#repositoryHost: "{{ lookup('env','TF_VAR_ddve_hostname') }}.{{ lookup('env','TF_VAR_env_name') }}.{{ lookup('env','TF_VAR_dns_suffix') }}"
#repositoryPath: "/data/col1/powerprotect"
#type: DD
function Set-PPDMserver_disaster_recovery_configurations {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [alias('address', 'fqdn')]$repositoryHost,
        [Parameter(Mandatory = $true, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        $repositoryPath,
        [Parameter(Mandatory = $false, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('DD'
        )]$Type="DD", 
        [Parameter(Mandatory = $true, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        $ID, 
        [Parameter(Mandatory = $true, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [switch]$backupsEnabled,
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
            'Host' {
                $URI = "/$myself/$ID"
                $body = @{
                    backupsEnabled  = $backupsEnabled.IsPresent
                    id              = $ID
                    repositoryHost  = $repositoryHost
                    repositoryPath  = $repositoryPath
                    type            = $Type
                } | ConvertTo-Json


            }    
            default {
                $URI = "/$myself"
            }
        }  
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
            'Host' {
                write-output $response 
            }
            default {
                write-output ($response )
            } 
        }   
    }
}
