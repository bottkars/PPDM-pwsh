function Get-PPDMreport_nodes {
    [CmdletBinding()]
    param(

        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ParameterSetName = 'ALL', ValueFromPipelineByPropertyName = $true)]
        $filter,
        #       [ValidateSet()]
        #       [Alias('AssetType')][string]$type,
        [Parameter(Mandatory = $false, ParameterSetName = 'ALL', ValueFromPipelineByPropertyName = $true)]
        $pageSize, 
        [Parameter(Mandatory = $false, ParameterSetName = 'ALL', ValueFromPipelineByPropertyName = $true)]
        $page, 
        [Parameter(Mandatory = $false, ParameterSetName = 'ALL', ValueFromPipelineByPropertyName = $true)]
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

function Get-PPDMreport_schedules {
    [CmdletBinding()]
    param(

        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ParameterSetName = 'ALL', ValueFromPipelineByPropertyName = $true)]
        $filter,
        #       [ValidateSet()]
        #       [Alias('AssetType')][string]$type,
        [Parameter(Mandatory = $false, ParameterSetName = 'ALL', ValueFromPipelineByPropertyName = $true)]
        $pageSize, 
        [Parameter(Mandatory = $false, ParameterSetName = 'ALL', ValueFromPipelineByPropertyName = $true)]
        $page, 
        [Parameter(Mandatory = $false, ParameterSetName = 'ALL', ValueFromPipelineByPropertyName = $true)]
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

<#
.SYNOPSIS
Deploy a Reporting Node
# Get the vCenter Inventory Source
$InventorySource=Get-PPDMinventory_sources -Type VCENTER -filter 'name lk "vcsa1%"'

## By CLuster

# Gert ESX Clustzer Moref

(Get-PPDMhosts -filter "inventorySourceId eq `"$($InventorySource.id)`"  and name eq `"home_cluster`"").details.esxcluster
New-PPDMreport_nodes -inventorySourceId $InventorySource.id -fqdn reporting.home.labbuildr.com -IPAddress 100.250.1.126 -gateway 100.250.1.1 -netmask 255.255.255.0 -dnsServers 192.168.1.44 -ClusterMoref domain-c7 -DatastoreMoref  datastore-544 -NetworkMoref dvportgroup-1503

id                : cf8ee6b0-1985-4f63-998d-56ba5c8d187f
hostName          : reporting.home.labbuildr.com
inventorySourceId : 69c8ac3a-3eca-55f1-a2e0-347e63a90540
deploymentConfig  : @{vmName=reporting.home.labbuildr.com; networks=System.Object[]; ovafile=; location=}
instanceUuid      :
status            : @{aliases=System.Object[]; version=; deployedTime=; lastCheckedTime=; powerState=; deployed=False; nodeStats=; nodeStatusDetail=;
                    hostedComputeResource=; vcenterName=vcsa1.home.labbuildr.com}
activityId        : dbf42199-bce3-40d1-8b19-eb04a9d7326d

#>
function New-PPDMreport_nodes {
    [CmdletBinding()]
    param(
     
        [Parameter(Mandatory = $true, ParameterSetName = 'byCluster', ValueFromPipelineByPropertyName = $true)]  
        $fqdn,
        [Parameter(Mandatory = $true, ParameterSetName = 'byCluster', ValueFromPipelineByPropertyName = $true)]  
        [ipaddress]$IPAddress,        
        [Parameter(Mandatory = $true, ParameterSetName = 'byHost', ValueFromPipelineByPropertyName = $true)]        
        [Parameter(Mandatory = $true, ParameterSetName = 'byCluster', ValueFromPipelineByPropertyName = $true)]  
        [ipaddress]$gateway,
        [Parameter(Mandatory = $true, ParameterSetName = 'byHost', ValueFromPipelineByPropertyName = $true)]        
        [Parameter(Mandatory = $true, ParameterSetName = 'byCluster', ValueFromPipelineByPropertyName = $true)]  
        [ipaddress]$netmask,
        [Parameter(Mandatory = $true, ParameterSetName = 'byHost', ValueFromPipelineByPropertyName = $true)]        
        [Parameter(Mandatory = $true, ParameterSetName = 'byCluster', ValueFromPipelineByPropertyName = $true)]  
        [ipaddress[]]$dnsServers,
        [Parameter(Mandatory = $true, ParameterSetName = 'byHost', ValueFromPipelineByPropertyName = $true)]        
        [string]$HostMoref, 
        [Parameter(Mandatory = $true, ParameterSetName = 'byCluster', ValueFromPipelineByPropertyName = $true)]        
        [string]$ClusterMoref, 
        [Parameter(Mandatory = $true, ParameterSetName = 'byHost', ValueFromPipelineByPropertyName = $true)]  
        [Parameter(Mandatory = $true, ParameterSetName = 'byCluster', ValueFromPipelineByPropertyName = $true)]  
        [string]$DatastoreMoref,                           
        [Parameter(Mandatory = $true, ParameterSetName = 'byHost', ValueFromPipelineByPropertyName = $true)]        
        [Parameter(Mandatory = $true, ParameterSetName = 'byCluster', ValueFromPipelineByPropertyName = $true)]  
        [string]$NetworkMoref, 
        [switch]$noop,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )

    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()

    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            default {
                $URI = "/$myself"
            }
        }
        $body = [ordered]@{
            inventorySourceId = $inventorySourceId
            deploymentConfig  = [ordered]@{
                networks = @(
                    [ordered]@{
                        networkMoref    = $NetworkMoref
                        dnsServers      = @( $dnsServers.IPAddressToString)
                        fqdn            = $fqdn
                        gateway         = $gateway.IPAddressToString
                        ipAddress       = @($IPAddress.IPAddressToString)
                        ipAddressFamily = "IPV4"
                        netMask         = $NetMask.IPAddressToString
                    }
                )

                location = [ordered] @{
                    hostMoref      = $HostMoref -replace 'HostSystem:'
                    clusterMoref   = $ClusterMoref -replace 'ClusterComputeResource:'
                    datastoreMoref = $DatastoreMoref -replace 'Datastore:'
                }
            }    
        } | convertto-json -depth 4
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
        if (!$noop) {     
            try {
                $Response += Invoke-PPDMapirequest @Parameters
            }
            catch {
                Get-PPDMWebException  -ExceptionMessage $_
                break
            }
            write-verbose ($response | Out-String)
        }
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {

            default {
                write-output $response
            } 
        }   
    }

}


function New-PPDMJobStatusSummaryReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'DURATION', ValueFromPipelineByPropertyName = $true)]        
        [string]$ReportName,     
        [Parameter(Mandatory = $true, ParameterSetName = 'DURATION', ValueFromPipelineByPropertyName = $true)]        
        [ValidateSet(
            'Backup',
            'Restore',
            'Replicate' )]
        [string]$jobType,  
        [Parameter(Mandatory = $true, ParameterSetName = 'DURATION', ValueFromPipelineByPropertyName = $true)]        
        [ValidateSet(
            'VMAX_STORAGE_GROUP',
            'VMWARE_VIRTUAL_MACHINE',
            'ORACLE_DATABASE',
            'MICROSOFT_SQL_DATABASE',
            'FILE_SYSTEM',
            'KUBERNETES',
            'MICROSOFT_EXCHANGE_DATABASE',
            'SAP_HANA_DATABASE',
            'NAS_SHARE',
            'CLOUD_NATIVE_ENTITY',
            'POWERSTORE_BLOCK',
            'CLOUD_DIRECTOR_VAPP',
            'DR')]
        [Alias('Type')][string[]]$assetType,     
        [Parameter(Mandatory = $true, ParameterSetName = 'DURATION', ValueFromPipelineByPropertyName = $true)]        
        [ValidateSet(
            'Successful',
            'Partially Successful',
            'Failed',
            'Cancelled & Skipped' )]
        [string]$JobStatus,
        [Parameter(Mandatory = $true, ParameterSetName = 'DURATION', ValueFromPipelineByPropertyName = $true)]        
        [ValidateSet('LAST_7_DAYS')][string]$Duration,
        [switch]$noop,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )

    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = "/report-schedules"

    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            default {
                $URI = "/$myself"
            }
        }
        switch ($PsCmdlet.ParameterSetName) {
            'LASTDAYS' {
                $startDate = (Get-Date).AddDays( - $($LastDays))
                $endtime = (Get-date (Get-Date -format g) -UFormat %s)
                $starttime = (Get-date (Get-Date $StartDate -format g) -UFormat %s)
            }
        }
        switch ($jobType) {
            'Backup' { $JobID = "80476948-80f8-11ed-a1eb-0242ac120002" }
            'Restore' { $JobID = "95189508-81e9-11ed-a1eb-0242ac120002" }
            'Replicate' { $JobID = "9641432b-71c2-4cca-9f60-76c0942ba0c3" }
        }


        $filter = 'status in ("' + ($Status -join '","') + '")' 
        $filter = "startTime gt $starttime and endTime lt $endtime and " + $filter
        $filter = 'assetType in ("' + ($assetType -join '","') + '") and ' + $filter


        $body = [ordered]@{
            reportTemplateId  = "$JobID"
            enabled           = $false
            filters           = @(
                @{
                    displayValue = $assetType -Join ","
                    name         = "Asset Type"
                    value        = $assetType -Join ","
                }
                @{
                    displayValue = $JobStatus -Join ","
                    name         = "Job Status"
                    value        = $JobStatus -Join ","
                }
                @{
                    displayValue = "ALL"
                    name         = "Asset Scope"
                    value        = "ALL"
                }
                @{
                    displayValue = $jobType
                    name         = "Job Type"
                    value        = $jobType
                }
                @{
                    displayValue = "$Duration"
                    name         = "Duration"
                    value        = "$Duration"
                }

            )
            reportCategory    = "Job Activities"
            reportDescription = "Displays a summary of asset jobs, organized by completion status."
            reportName        = "$ReportName"
        } | convertto-json -depth 4
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
        if (!$noop) {     
            try {
                $Response += Invoke-PPDMapirequest @Parameters
            }
            catch {
                Get-PPDMWebException  -ExceptionMessage $_
                break
            }
            write-verbose ($response | Out-String)
        }
    } 
    end {    
        switch ($PsCmdlet.ParameterSetName) {

            default {
                write-output $response
            } 
        }   
    }

}

function Request-PPDMreport {
    [CmdletBinding()]
    param(

        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [PSObject]$ReportSchedule,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]    
        [switch]$noop,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]                
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $apiver = "/api/v2"
    )

    begin {
        $Response = @()
        $METHOD = "POST"
        $URI = "reports"
   
    }     
    Process {
        switch ($ReportSchedule.reportTemplateId) {
            '80476948-80f8-11ed-a1eb-0242ac120002' {
                Write-Verbose "Detected Job Activity Report Schedule"

                $Jobtype =  ($ReportSchedule.filters | Where-Object name -match "Job Type").Value
                $JobStatus = ($ReportSchedule.filters | Where-Object name -match "Job Status").Value
                $JobStatusFilter='("' + $JobStatus.Replace(",",'","') + '")'
                $AssetScope = ($ReportSchedule.filters | Where-Object name -match "Asset Scope")
                $AssetType =  ($ReportSchedule.filters | Where-Object name -match "Asset Type").Value
                $AssetTypeFilter='("' + $AssetType.Replace(",",'","') + '")'
                $Duration=($ReportSchedule.filters | Where-Object name -match "Duration").Value

                switch ($Duration)
                {
                    "LAST_7_DAYS"
                    {
                        Write-Verbose "Got 7 Days"
                    }
                    default {
                        Write-Verbose "Not jet in"
                        return
                    }
                }
                Switch ($AssetScope.displayValue){
                    "ALL"
                    {
                    $filter="assetType in $AssetTypeFilter and startTime gt 1692230400 and endTime lt 1692792522 and status in $JobStatusFilter"      

                    }
                    default {
                    $AssetName = '("' + $AssetScope.value.Replace(",",'","') + '")'    
                    $filter="assetType in $AssetTypeFilter and assetName in $AssetName and startTime gt 1692230400 and endTime lt 1692792522 and status in $JobStatusFilter"      
                    Write-Verbose $filter
                    }
                }
            }
            default {
                write-warning "$($ReportSchedule.reportTemplateId) Not jet implemented"
                return
            }
        }  
        $Body=@{
            filter = $filter
            reportTemplateId = $ReportSchedule.reportTemplateId
        } | ConvertTo-Json
        Write-Verbose ($Body  | Out-String)
        $Parameters = @{
            RequestMethod    = 'REST'
            body             = $body
            Uri              = $URI
            Method           = $Method
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
        }

        if (!$noop.IsPresent) {
            try {
                $Response += Invoke-PPDMapirequest @Parameters
            }
            catch {
                Get-PPDMWebException  -ExceptionMessage $_
                break
            }
            write-verbose ($response | Out-String)
        }
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

