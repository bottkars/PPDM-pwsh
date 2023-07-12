function Get-PPDMprotection_details {
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

<#
.Synopsis
Gets PPDM Alerts

.Description
Retrieve PPDM Alerts, IDś, State as 

.Example

Get-PPDMalerts | where acknowledgement -match UNACKNOWLEDGED | Set-PPDMalerts_acknowledgement -acknowledgeState ACKNOWLEDGED
.EXAMPLE
Get-PPDMalerts -filter {acknowledgement.acknowledgeState eq "UNACKNOWLEDGED"} -body {pagesize=1000}
.EXAMPLE
Get-PPDMalerts -filter {acknowledgement.acknowledgeState eq "UNACKNOWLEDGED"} -body {pagesize=1000}| Set-PPDMalerts_acknowledgement -acknowledgeState ACKNOWLEDGED
#>
function Get-PPDMalerts {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ParameterSetName = 'default', ValueFromPipelineByPropertyName = $true)]
        $body = @{pageSize = 200 },
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
            } 
        }   
    }
}


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
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
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
        [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        $filter,
        [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        $orderby, 
        [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        $pageSize, 
        [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        $page,              
        $body = @{orderby='createdAt DESC'},
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
                write-output $response | convertfrom-json
            }
            default {
                write-output ($response | convertfrom-json).content
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
        $body=@{
            'id' = $id
            'userNote' = @{
                'note' = $note
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
