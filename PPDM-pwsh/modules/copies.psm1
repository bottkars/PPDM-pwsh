<#
        Asset type and (subtype) mapping:

        - VMAX_STORAGE_GROUP (VMAXSTORAGEGROUP)

        - POWERSTORE_BLOCK (POWERSTORE_VOLUMEGROUP, POWERSTORE_VOLUME)

        - MICROSOFT_SQL_DATABASE (MSSQL)

        - ORACLE_DATABASE (ORACLE_CDB, ORACLE_NON_CDB, ORACLE_PDB)

        - VMWARE_VIRTUAL_MACHINE (VIRTUALMACHINE)

        - FILE_SYSTEM (NTFS, ReFS, CSVFS, ext3, ext4, xfs, btrfs, FS_DR, JFS, JFS2)

        - KUBERNETES (K8S_NAMESPACE, K8S_POD, K8S_PERSISTENT_VOLUME, K8S_PERSISTENT_VOLUME_CLAIM)

        - SAP_HANA_DATABASE (SAPHANA_SYSTEM, SAPHANA_TENANT)

        - MICROSOFT_EXCHANGE_DATABASE (EXCHANGE_MAILBOX, EXCHANGE_PUBLIC_FOLDER)

        - NAS_SHARE (UNITY_NFS, UNITY_CIFS, POWERSTORE_NFS, POWERSTORE_CIFS, POWERSCALE_NFS, POWERSCALE_CIFS, NFS_GENERIC, CIFS_GENERIC)'
#>
<#
.SYNOPSIS
Get PPDM Copies from Query
.EXAMPLE
 get-ppdmcopies -Type K8S_NAMESPACE -Verbose -body @{pageSize=1000}
#>
function Get-PPDMcopies {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $TRUE, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ParameterSetName = 'TYPE', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet(          
            'VMAXSTORAGEGROUP',
            'VIRTUALMACHINE',
            'ORACLE_CDB', 'ORACLE_NON_CDB', 'ORACLE_PDB',
            'MSSQL',
            'NTFS', 'ReFS', 'CSVFS', 'ext3', 'ext4', 'xfs', 'btrfs', 'FS_DR', 'JFS', 'JFS2',
            'K8S_NAMESPACE', 'K8S_POD', 'K8S_PERSISTENT_VOLUME', 'K8S_PERSISTENT_VOLUME_CLAIM',
            'EXCHANGE_MAILBOX', 'EXCHANGE_PUBLIC_FOLDER',
            'SAPHANA_SYSTEM', 'SAPHANA_TENANT',
            'UNITY_NFS', 'UNITY_CIFS', 'POWERSTORE_NFS', 'POWERSTORE_CIFS', 'POWERSCALE_NFS', 'POWERSCALE_CIFS', 'NFS_GENERIC', 'CIFS_GENERIC',
            'CLOUD_NATIVE_ENTITY',
            'POWERSTORE_VOLUMEGROUP', 'POWERSTORE_VOLUME',
            'CLOUD_DIRECTOR_VAPP'
        )]$Type,
        [Parameter(Mandatory = $false, ParameterSetName = 'TYPE', ValueFromPipelineByPropertyName = $true)]
        $filter,  
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $pageSize, 
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $page, 
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [hashtable]$body = @{orderby = 'createdAt DESC' },
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
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
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
        }
        if ($type) {
            if ($filter) {
                $filter = 'assetSubtype eq "' + $type + '" and ' + $filter 
            }
            else {
                $filter = 'assetSubtype eq "' + $type + '"'
            }
        }
        if ($filter) {
            write-verbose ($filter | Out-String)
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


function Get-PPDMlatest_copies {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')][string[]]$assetID,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $filter,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )
    begin {
        $body = @{}
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
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
            $filter = 'assetId in ("' + ($assetID -join '","') + '")' + $filter 
        }
        else {
            $filter = 'assetId in ("' + ($assetID -join '","') + '")'
        }
        if ($filter) {
            write-verbose ($filter | Out-String)
            $Parameters.Add('filter', $filter)
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
                write-output $response.content 
            } 
        }   
    }
}



function Remove-PPDMcopies {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'removeConfigurationOnly', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $true, ParameterSetName = 'removeConfigurationOnly')]
        [switch]$removeConfigurationOnly
    )
    begin {
        $Response = @()
        $METHOD = "Delete"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(11) -replace "_", "-").ToLower()
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id"
            }
            'removeConfigurationOnly' {
                $URI = "/$myself/$id"
                $body = @{removeConfigurationOnly = "true" }  
            }
        }     
        
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
            'byID' {
                write-output $response
            }
            default {
                write-output $response
            } 
        }   
    }
}




function Get-PPDMlatest_copies_old {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
        $id,        
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
   
    }     
    Process {
        $URI = "/$myself"
        $filter = 'assetId in ("' + $id + '")'
        $Parameters = @{
            filter           = $filter
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            apiport          = 8443 
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
                write-output $response.content
            } 
        }   
    }
}





function Get-PPDMcopies_query {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $filter,  
        #        [hashtable]$body = @{pageSize = 200 },  
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
   
    }     
    Process {
        $body = @{}
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                #
                $URI = "/$myself/$id"
            }
            default {
                $URI = "/$myself"
            }
        }  
        if ($filter) {
            $body.Add('filter', $filter)
        } 
        $body = $body | ConvertTo-Json          
        $Parameters = @{
            #          body             = $body 
            Uri              = $Uri
            Method           = $Method
            RequestMethod    = 'Rest'
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
            # ResponseHeadersVariable = 'HeaderResponse'
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