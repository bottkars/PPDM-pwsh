# agents-list
<#
function Get-PPDMagents_list {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$ID,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = ""

    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
   
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
            apiport          = 443 
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
                write-output $response
            } 
        }   
    }
}

#>
#/api/v2/agent-registration-status
<#
.SYNOPSIS
Get status and list of Agents
.DESCRIPTION
Used for List and Update of Agents
.EXAMPLE
Get-PPDMagent_registration_status -updateState NOT_SUPPORTED

agent                  : @{id=d8a93b5b-d353-4e27-82f4-d16c9fdf13d1; version=19.13; address=10.0.230.13;
                         preferredAddress=; port=7000; plugins=System.Object[]; certificateSigningRequest=******;
                         createdTime=28/06/2023 06:52:27; registeredTime=28/06/2023 07:24:17}
status                 : REGISTERED
inventorySourceId      : 24343f1e-09b0-4850-9c05-3c320da5c603
hostname               : sqlsinglenode.dpslab.home.labbuildr.com
hostId                 : ba9bcb41-6c6c-435c-8468-39af78f21ddd
throttlingConfig       : @{backupMaxCpuPercentage=100}
applications           : {@{name=Microsoft Application SQL Agent; version=19.13.0.55.Build.55;
                         packageId=30ceb7a5-77b3-5237-90b3-3854db08f9a4; packageVersion=19.14; type=MSSQL}}
updateVersionAvailable : {}
updateState            : NOT_SUPPORTED
os                     : WINDOWS
updateStateDescription : PowerProtect Data Manager UI does not support the update of an agent with an ItemPoint
                         configuration. Try to manually update the agent from the host.
#>
function Get-PPDMagent_registration_status {
    [CmdletBinding()]
    [Alias('Get-PPDMagents')]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$ID,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $filter,
        [ValidateSet('AVAILABLE',
            'SCHEDULED',
            'IN_PROGRESS',
            'UP_TO_DATE',
            'NOT_SUPPORTED'
        )]
        [string]$updateState,
        [ValidateSet('Microsoft Application SQL Agent',
            'Microsoft Application Exchange Agent',
            'File System Agent',
            'Oracle RMAN Agent',
            'SAP HANA Agent')]
        [string]$type,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $pageSize, 
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $page, 
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
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
                $URI = "/$myself/$ID"
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
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            apiport          = 8443  
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
        } 
        if ($updateState) {
            if ($filter) {
                $filter = 'updateState eq "' + $updateState + '" and ' + $filter 
            }
            else {
                $filter = 'updateState eq "' + $updateState + '"'
            }
        } 
        if ($type) {
            if ($filter) {
                $filter = 'applications.name eq "' + $type + '" and ' + $filter 
            }
            else {
                $filter = 'applications.name eq "' + $type + '"'
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
Removes Update Sessipn from PPDM
.EXAMPLE
# from Pipeline
Get-PPDMagents_update_sessions -state COMPLETED | Remove-PPDMagents_update_sessions
Fri, 14 Jul 2023 12:30:09 GMT
Fri, 14 Jul 2023 12:30:09 GMT
Fri, 14 Jul 2023 12:30:09 GMT
Fri, 14 Jul 2023 12:30:09 GMT
Fri, 14 Jul 2023 12:30:09 GMT
Fri, 14 Jul 2023 12:30:10 GMT
Fri, 14 Jul 2023 12:30:10 GMT
Fri, 14 Jul 2023 12:30:10 GMT
Fri, 14 Jul 2023 12:30:10 GMT
.EXAMPLE
# By ID
Remove-PPDMagents_update_sessions -id 54ce0375-0917-4703-881d-2d74341677d9
Fri, 14 Jul 2023 12:30:09 GMT
#>
function Remove-PPDMagents_update_sessions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
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

        }   
        $Parameters = @{
            RequestMethod    = 'WEB'
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
                write-host $response.Headers.Date
            }

        }   
    }
}


function Get-PPDMagents_update_sessions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $filter,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet(        
            'COMPLETED',
            'IN_PROGRESS',
            'SCHEDULED'
        )]
        [string[]]$state,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $pageSize, 
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $page, 
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
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
                if ($state) {
                    $URI = "/$myself/filter"
                }
                else {
                    $URI = "/$myself"
                }
                
            }
        }          
        if ($state) {
            $body.Add('state', $state -join (','))
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
.EXAMPLE
#Run a precheck
Set-PPDMagents_update_sessions -hostid 8c1b3ae0-fef7-4b36-b492-3bcbf796fced -precheckOnly -Name Test
id           : 8fe450b4-59ee-4bd0-9e85-7d024900a1dc
name         : test
precheckOnly : True
hosts        : {@{id=8c1b3ae0-fef7-4b36-b492-3bcbf796fced; appServerTypes=System.Object[]}}
state        : IN_PROGRESS
.EXAMPLE
Set-PPDMagents_update_sessions -hostid 8c1b3ae0-fef7-4b36-b492-3bcbf796fced  -Name test

id           : 8fe450b4-59ee-4bd0-9e85-7d024900a1dc
name         : test
precheckOnly : False
hosts        : {@{id=8c1b3ae0-fef7-4b36-b492-3bcbf796fced; appServerTypes=System.Object[]}}
state        : SCHEDULED

Get-PPDMagents_update_sessions -id 8fe450b4-59ee-4bd0-9e85-7d024900a1dc

id           : 8fe450b4-59ee-4bd0-9e85-7d024900a1dc
name         : test
precheckOnly : False
hosts        : {@{id=8c1b3ae0-fef7-4b36-b492-3bcbf796fced; appServerTypes=System.Object[]}}
state        : IN_PROGRESS
Get-PPDMagents_update_sessions -id 8fe450b4-59ee-4bd0-9e85-7d024900a1dc

id           : 8fe450b4-59ee-4bd0-9e85-7d024900a1dc
name         : test
precheckOnly : False
hosts        : {@{id=8c1b3ae0-fef7-4b36-b492-3bcbf796fced; appServerTypes=System.Object[]}}
state        : COMPLETED
#>
function Set-PPDMagents_update_sessions {
    [CmdletBinding()]
    param(

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$hostid,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('MSSQL',
            'ORACLE',
            'FS',
            'SAP_HANA_DATABASE_SYSTEM',
            'STORAGEGROUP',
            'MICROSOFT_EXCHANGE_DATABASE_SYSTEM')]
        [Alias('appServerTypes')][string[]]$type,
        [String]$Name = "now",
        [switch]$precheckOnly,
        [DateTime]$scheduledAt,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"  
    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
   
    }     
    Process {
        $updatehost = @{}
        $updatehost.Add('appServerTypes', $type)
        $updatehost.Add('id', $hostid)
        $updatehost.Add('privileged', $true)
        $body = @{}
        $body.Add('hosts', @())
        $body.hosts += $updatehost

        $body.Add('precheckOnly', $precheckOnly.IsPresent)
        $body.Add('name', $Name)
        #if ($scheduledAt) {
            $body.Add('scheduledAt', $(Get-DAte $scheduledAt -Format yyyy-MM-ddTHH:mm:ssZ))

        #}
        $Uri = $Myself

        $body = $body | ConvertTo-Json -Depth 7

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
