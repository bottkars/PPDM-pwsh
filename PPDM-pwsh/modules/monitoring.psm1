
function Get-PPDMprotection_details {
    [CmdletBinding()]
    param(
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
.Synopsis
Gets PPDM Alerts

.Description
Retrieve PPDM Alerts, IDs, States 

.Example

Get-PPDMalerts -filter {acknowledgement.acknowledgeState eq "UNACKNOWLEDGED"}| Set-PPDMalerts_acknowledgement -acknowledgeState ACKNOWLEDGED
.EXAMPLE
Get-PPDMalerts -filter {acknowledgement.acknowledgeState eq "UNACKNOWLEDGED"} -body {pagesize=100}
.EXAMPLE
Get-PPDMalerts -filter {acknowledgement.acknowledgeState eq "UNACKNOWLEDGED"} -body {pagesize=100}| Set-PPDMalerts_acknowledgement -acknowledgeState ACKNOWLEDGED
#>
function Get-PPDMalerts {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        [hashtable]$body = @{pageSize = 200 },
        [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        $filter,
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
            $Parameters.Add('q', $query)
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

#/api/v2/system-health-issues
function Set-PPDMalerts_acknowledgement {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet("ACKNOWLEDGED", "UNACKNOWLEDGED")]
        $acknowledgeState = "ACKNOWLEDGED"       
    )
    begin {
        $Response = @()
        $METHOD = "PUT"
        $Myself = "alerts"
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$id/acknowledgement"
            }
            default {
                $URI = "/$myself/$id/acknowledgement"
            }
        } 
        
        
        $Body = [ordered]@{ 
            'acknowledgement' = @{
                'acknowledgeState' = $acknowledgeState
            }
            'id'              = $id
        } | convertto-json -Depth 7
        write-verbose ($body | out-string)
        $Parameters = @{
            body             = $body 
            Uri              = "$URI"
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



function Get-PPDMaudit_logs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $filter,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $orderby, 
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $pageSize, 
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $page,              
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
            Uri              = "$URI"
            RequestMethod    = "REST"
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


function Update-PPDMaudit_logs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$ID,
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        [string]$Note,        
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "PUT"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(11) -replace "_", "-").ToLower()
   
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            default {
                $URI = "/$myself/$ID/notes"
            }

        } 
        $body = @{
            'id'       = $id
            'userNote' = @{
                'note'     = $note
                'username' = $Global:PPDM_API_Credentials.UserName
            }
        } | convertto-json
        write-verbose ( $body | out-string)
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
                write-output $response
            } 
        }   
    }
}
