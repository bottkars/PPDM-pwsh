function Get-PPDMWhitelist {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'automatic', ValueFromPipelineByPropertyName = $true)]
        [switch]$automatic,
        [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $false)]
        $filter,
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $false)]
        $pageSize, 
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $false)]
        $page, 
        [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $false)]
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
            'automatic' {
                $URI = "/$myself/automatic"
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
            'automatic' {
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



function Update-PPDMWhitelist {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'IP', ValueFromPipelineByPropertyName = $true)]
        $ip,        
        [Parameter(Mandatory = $true, ParameterSetName = 'IP', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ParameterSetName = 'IP', ValueFromPipelineByPropertyName = $true)]
        $DaysToExpire,
        [Parameter(Mandatory = $true, ParameterSetName = 'IP', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('APPROVED', 'REJECTED', 'UNDEFINED', 'AUTOMATIC')]$state,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]                
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $apiver = "/api/v2"
    )

    begin {
        $Response = @()
        $METHOD = "PATCH"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(11) -replace "_", "-").ToLower()
    }     
    Process {
        $URI = "$myself/$id"
        $myDate = (get-date).AddDays($DaysToExpire)
        $usedate = get-date $myDate -Format yyyy-MM-ddThh:mm:ss.ffffZ
        $body = @{}         
        $body.Add('expiresAt', $usedate )       
        $body.Add('state', $state)
        $body.Add('ip', $IP)
        Write-Verbose $URI
        $body = $body | convertto-json -Depth 7
        Write-Verbose $Body | Out-String
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
                if ($response.page) {
                    write-host ($response.page | out-string)
                }
            } 
        }   
    }
}


function Set-PPDMWhitelist {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'automatic', ValueFromPipelineByPropertyName = $true)]
        [switch]$automatic,
        [Parameter(Mandatory = $true, ParameterSetName = 'IP', ValueFromPipelineByPropertyName = $true)]
        $IP,
        [Parameter(Mandatory = $false, ParameterSetName = 'IP', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $false, ParameterSetName = 'automatic', ValueFromPipelineByPropertyName = $true)]
        $DaysToExpire = 1,
        [Parameter(Mandatory = $true, ParameterSetName = 'IP', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('APPROVED', 'REJECTED', 'UNDEFINED', 'AUTOMATIC')]$state,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]                
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $apiver = "/api/v2"
    )

    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
    }     
    Process {
        $myDate = (get-date).AddDays($DaysToExpire)
        $usedate = get-date $myDate -Format yyyy-MM-ddThh:mm:ssZ
        $body = @{}         
        $body.Add('expiresAt', $usedate )       
        switch ($PsCmdlet.ParameterSetName) {
            'automatic' {
                $URI = "/$myself/automatic"
                $body.Add('state', 'AUTOMATIC')
                $body.Add('ip', '0.0.0.0')
                
            }        
            default {
                $URI = "/$myself"
                $body.Add('state', $state)
                $body.Add('ip', $IP)
            }
        }  
        $body = $body | convertto-json -Depth 7
        Write-Verbose $Body | Out-String
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
                if ($response.page) {
                    write-host ($response.page | out-string)
                }
            } 
        }   
    }
}


function Remove-PPDMWhitelist {
    [CmdletBinding()]
    param(

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]                
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $apiver = "/api/v2"
    )

    begin {
        $Response = @()
        $METHOD = "DELETE"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(11) -replace "_", "-").ToLower()
   
    }     
    Process {

        $URI = "/$myself/$id"
        $body = @{} 
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

        write-output $response.Headers.Date
        if ($response.page) {
            write-host ($response.page | out-string)
        }
 
    }
}