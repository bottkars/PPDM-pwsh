# /api/v2/inventory-sources
function Get-PPDMinventory_sources {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id
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
            }
            default {
                $URI = "/$myself"
            }
        }        
        try {
            $Response += Invoke-PPDMapirequest -uri $URI -Method $METHOD -Body "$body"
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




# /api/v2/inventory-sources
function Add-PPDMinventory_sources {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [alias('fqdn')]$Hostname, 
        [Parameter(Mandatory = $true, ParameterSetName = 'GENERIC_NAS', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('CIFS', 'NFS')]$Protocol, 
        [Parameter(Mandatory = $true, ParameterSetName = 'GENERIC_NAS', ValueFromPipelineByPropertyName = $true)]
        [string[]]$address,                    
        [Parameter(Mandatory = $true, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('DATADOMAINMANAGEMENTCENTER',
            #        'SMISPROVIDER',
            'DDSYSTEM',
            #        'VMAXSYSTEM',
            #        'XTREMEIOMANAGEMENTSERVER',
            #        'RECOVERPOINT',
            #        'HOST_OS',        
            #        'SQLGROUPS',
            #        'ORACLEGROUP',
            #        'DEFAULTAPPGROUP',
            'VCENTER',
            'EXTERNALDATADOMAIN',
            #        'POWERPROTECTSYSTEM',
            #        'CDR',
            'KUBERNETES'
        )]$Type, 
        [Parameter(Mandatory = $true, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        $Name,        
        [Parameter(Mandatory = $true, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'GENERIC_NAS', ValueFromPipelineByPropertyName = $true)]
        [alias('secretID')]$ID, 
        [Parameter(Mandatory = $false, ParameterSetName = 'Host', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'GENERIC_NAS', ValueFromPipelineByPropertyName = $true)]
        $port,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"

    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'Host' {
                $URI = "/$myself"
                $body = @{

                    name        = $Name
                    type        = $Type
                    address     = $Hostname
                    port        = $port
                    credentials = @{
                        id = $ID
                    }
                } | ConvertTo-Json
            }
            'GENERIC_NAS' {
                $URI = "/$($myself)-batch"
                $body = @{}
                $body.Add('requests',@())    

                # this goes to foreach
                $request = @{}
                $request.Add('id','1')
                $requestbody = @{
                    name        = $address
                    type        = 'GENERICNASMANAGEMENTSERVER'
                    address     = $address -replace ":"
                    port        = $port
                    credentials = @{
                        id = $ID
                    }
                }
                $request.Add('body',$requestbody)
                $body.requests += $request
                
                $body = $body | ConvertTo-Json -Depth 6
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


function Remove-PPDMinventory_sources {
    [CmdletBinding()]
    param(
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2",
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        $id
    )
    begin {
        $Response = @()
        $METHOD = "DELETE"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(11) -replace "_", "-").ToLower()
        # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {

        $URI = "/$myself/$id"
        $Parameters = @{
            #            body             = $body 
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
                write-output $response | convertfrom-json
            }
            default {
                write-output ($response | convertfrom-json).content
            } 
        }   
    }
}



