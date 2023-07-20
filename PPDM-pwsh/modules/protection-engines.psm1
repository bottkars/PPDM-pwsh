

#/api/v2/protection-engines
function Get-PPDMprotection_engines {
    [CmdletBinding()]
    [Alias('Get-PPDMVPE')]

    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false,  ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('VPE')]
        $Type,
        [Parameter(Mandatory = $false,  ValueFromPipelineByPropertyName = $true)]
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
            Uri              = $Uri
            Method           = $Method
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
        }
        if ($type) {
            if ($filter){
            $filter = 'type eq "' + $type + '" and ' + $filter 
            }
            else {
                $filter = 'type eq "' + $type + '"'
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
            } 
        }   
    }
}




<#
  .SYNOPSIS


  .DESCRIPTION


  .EXAMPLE
    $VPE=(Get-PPDMVPE -Type VPE).ID
    (Get-PPDMProxy -filter 'Config.HostName eq "ppdm-vproxy02.xiolab.lab.emc.com"' -VPE $VPE)
#>
function Get-PPDMprotectionEngineProxies {
    [CmdletBinding()]
    [Alias('Get-PPDMProxy')]
    param(
        [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        $VPE,        
        [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
        $id,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        $filter,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )
    begin {
        $Response = @()
        $METHOD = "GET"
        $Myself = "protection-engines"
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'byID' {
                $URI = "/$myself/$vpe/proxies/$id"
            }
            default {
                $URI = "/$myself/$vpe/proxies"
            }
        }  
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            Method           = $Method
            PPDM_API_BaseUri = $PPDM_API_BaseUri
            apiver           = $apiver
            Verbose          = $PSBoundParameters['Verbose'] -eq $true
            RequestMethod    = 'Rest'

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
            } 
        }   
    }
}


#/api/v2/protection-engines
<#
  .SYNOPSIS


  .DESCRIPTION
   Disables a Protection Proxy 

  .EXAMPLE
    $VPE=(Get-PPDMVPE -Type VPE).ID
    $ProxyID = (Get-PPDMProxy -filter 'Config.HostName eq "ppdm-vproxy02.xiolab.lab.emc.com"' -VPE $VPE).id
#>
function Disable-PPDMprotectionEngineProxy {
    [CmdletBinding()]
    [Alias('Disable-PPDMProxy')]
    param(
        [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        $VPE,        
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        $id,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )
    begin {
        $Response = @()
        $METHOD = "PUT"
        $Myself = "protection-engines"
    }     
    Process {
        write-verbose "Reading configuration"
        $configuration = (get-PPDMProtectionEngineProxies -VPE $vpe -id $id)
        if ($configuration)
            {
                $configuration.config.Disabled = $true
            }
            else
            {
                write-Host "could not bread configuration for VPE $VPE Proxy $ID"
            }
        switch ($PsCmdlet.ParameterSetName) {

            default {
                $URI = "/$myself/$vpe/proxies/$id"
            }
        } 
        $body = $configuration | convertto-json -depth 7 
        $Parameters = @{
            body             = $body 
            Uri              = $Uri
            RequestMethod    = 'Rest'
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
                write-output $response
            }
            default {
                write-output $response
            } 
        }   
    }
}

<#
  .SYNOPSIS


  .DESCRIPTION


  .PARAMETER NetworkMoref
    can be retrieved with 
$NetworkMoref=((Get-PPDMhosts -hosttype ESX_CLUSTER -filter 'name eq "K8-TEST"').details.esxcluster.networks | where name -eq MGMT-v328).moref

  .PARAMETER ClusterMoref
    can be retrieved with 
$ClusterMoref=(Get-PPDMhosts -hosttype ESX_CLUSTER -filter 'name eq "K8-TEST"').details.esxcluster.clusterMoref
  .PARAMETER HostMoref
    can be retrieved with     
$HostMoref=(Get-PPDMhosts -hosttype ESX_HOST -filter 'name eq "esxgy85.xiolab.lab.emc.com"' ).details.esxhost.hostMoref
  .PARAMETER DatastoreMoref
    can be retrieved with
$VCenterID=(Get-PPDMinventory_sources -Type VCENTER -filter 'name eq "vcenter-01"').id
$DatastoreMoref=(Get-PPDMvcenterDatastores -id $VCenterID -clusterMOREF $clusterMoref | where name -match vsanDatastore).moref
  .PARAMETER VPE
    the internal Proxy
    can be retrieved with
$VPE=(Get-PPDMprotection_engines -Type VPE).ID
  .EXAMPLE
Deploy a Kubernetes Proxy on a ESX Host  
$NetworkMoref=((Get-PPDMhosts -hosttype ESX_CLUSTER -filter 'name eq "K8-TEST"').details.esxcluster.networks | where name -eq MGMT-v328).moref
$HostMoref=(Get-PPDMhosts -hosttype ESX_HOST -filter 'name eq "esxgy85.xiolab.lab.emc.com"' ).details.esxhost.hostMoref
$VCenterID=(Get-PPDMinventory_sources -Type VCENTER -filter 'name eq "vcenter-01"').id
$DatastoreMoref=(Get-PPDMvcenterDatastores -id $VCenterID -clusterMOREF $clusterMoref | where name -match vsanDatastore).moref
$VPE=(Get-PPDMprotection_engines -Type VPE).ID

New-PPDMProxy -VPE $VPE `
    -ProtectionType Kubernetes `
    -fqdn ppdm-vproxy02.xiolab.lab.emc.com `
    -IPAddress 10.55.28.42 `
    -gateway 10.55.28.1 `
    -netmask 255.255.255.0 `
    -PrimaryDNS 10.55.234.250  `
    -vCenterID $VCenterID `
    -HostMoref $HostMoref `
    -DatastoreMoref $DatastoreMoref `
    -NetworkMoref $NetworkMoref

.EXAMPLE
Deploy a Kubernetes Proxy in a vSphere Cluster 
$NetworkMoref=((Get-PPDMhosts -hosttype ESX_CLUSTER -filter 'name eq "K8-TEST"').details.esxcluster.networks | where name -eq MGMT-v328).moref
$ClusterMoref=(Get-PPDMhosts -hosttype ESX_CLUSTER -filter 'name eq "K8-TEST"').details.esxcluster.clusterMoref
$VCenterID=(Get-PPDMinventory_sources -Type VCENTER -filter 'name eq "vcenter-01"').id
$DatastoreMoref=(Get-PPDMvcenterDatastores -id $VCenterID -clusterMOREF $clusterMoref | where name -match vsanDatastore).moref
$VPE=(Get-PPDMprotection_engines -Type VPE).ID

New-PPDMProxy -VPE $VPE `
    -ProtectionType Kubernetes `
    -fqdn ppdm-vproxy02.xiolab.lab.emc.com `
    -IPAddress 10.55.28.42 `
    -gateway 10.55.28.1 `
    -netmask 255.255.255.0 `
    -PrimaryDNS 10.55.234.250  `
    -vCenterID $VCenterID `
    -ClusterMoref $ClusterMoref `
    -DatastoreMoref $DatastoreMoref `
    -NetworkMoref $NetworkMoref

 .EXAMPLE
Deploy a VM Proxy in a vSphere Cluster with NBD Transport
$NetworkMoref=((Get-PPDMhosts -hosttype ESX_CLUSTER -filter 'name eq "K8-TEST"').details.esxcluster.networks | where name -eq MGMT-v328).moref
$ClusterMoref=(Get-PPDMhosts -hosttype ESX_CLUSTER -filter 'name eq "K8-TEST"').details.esxcluster.clusterMoref
$VCenterID=(Get-PPDMinventory_sources -Type VCENTER -filter 'name eq "vcenter-01"').id
$DatastoreMoref=(Get-PPDMvcenterDatastores -id $VCenterID -clusterMOREF $clusterMoref | where name -match vsanDatastore).moref
$VPE=(Get-PPDMprotection_engines -Type VPE).ID

New-PPDMProxy -VPE $VPE `
    -ProtectionType VM `
    -TransportMode NbdOnly `
    -fqdn ppdm-vproxy02.xiolab.lab.emc.com `
    -IPAddress 10.55.28.42 `
    -gateway 10.55.28.1 `
    -netmask 255.255.255.0 `
    -PrimaryDNS 10.55.234.250  `
    -vCenterID $VCenterID `
    -ClusterMoref $ClusterMoref `
    -DatastoreMoref $DatastoreMoref `
    -NetworkMoref $NetworkMoref   

#>
function New-PPDMProtectionEngineProxy {
    [CmdletBinding()]
    [Alias('New-PPDMProxy')]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'byHost', ValueFromPipelineByPropertyName = $true)]        
        [Parameter(Mandatory = $true, ParameterSetName = 'byCluster', ValueFromPipelineByPropertyName = $true)]        
        $VPE,        
        [Parameter(Mandatory = $true, ParameterSetName = 'byHost', ValueFromPipelineByPropertyName = $true)]        
        [Parameter(Mandatory = $true, ParameterSetName = 'byCluster', ValueFromPipelineByPropertyName = $true)]  
        [ValidateSet('Kubernetes','VM')]
        [string]$ProtectionType,
        [Parameter(Mandatory = $false, ParameterSetName = 'byHost', ValueFromPipelineByPropertyName = $true)]        
        [Parameter(Mandatory = $false, ParameterSetName = 'byCluster', ValueFromPipelineByPropertyName = $true)]  
        [ValidateSet('HotaddPreferred','HotaddOnly','NbdOnly')]
        [string]$TransportMode = 'HotaddPreferred',
        [Parameter(Mandatory = $true, ParameterSetName = 'byHost', ValueFromPipelineByPropertyName = $true)]        
        [Parameter(Mandatory = $true, ParameterSetName = 'byCluster', ValueFromPipelineByPropertyName = $true)]  
        $fqdn,
        [Parameter(Mandatory = $true, ParameterSetName = 'byHost', ValueFromPipelineByPropertyName = $true)]        
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
        [ipaddress]$PrimaryDNS,
        [Parameter(Mandatory = $true, ParameterSetName = 'byHost', ValueFromPipelineByPropertyName = $true)]        
        [Parameter(Mandatory = $true, ParameterSetName = 'byCluster', ValueFromPipelineByPropertyName = $true)]  
        [string]$vCenterID, 
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
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )

    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = "protection-engines"
    }     
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            default {
                $URI = "/$myself/$vpe/proxies"
            }
        }
        
        

        $body = [ordered]@{
            Config = [ordered]@{
                ProxyType = 'External' 
                Port = 9090
                DeployProxy = $true
                AdvancedOptions = [ordered]@{
                    TransportSessions = [ordered]@{
                        Mode = $TransportMode
                        UserDefined = $true
                    }
                }
                SupportedProtectionTypes = @(
                    $ProtectionType
                )    
                ProxyDeploymentConfig = [ordered]@{
                    Location =[ordered] @{
                        HostMoref = $HostMoref -replace 'HostSystem:'
                        ClusterMoref =  $ClusterMoref -replace 'ClusterComputeResource:'
                        DatastoreMoref = $DatastoreMoref -replace 'Datastore:'
                        NetworkMoref = $NetworkMoref
                    }
                    Fqdn = $fqdn
                    IpAddress = $IPAddress.IPAddressToString
                    NetMask = $NetMask.IPAddressToString
                    Gateway = $Gateway.IPAddressToString
                    PrimaryDns = $PrimaryDns.IPAddressToString
                    Dns = $PrimaryDns.IPAddressToString
                    IPProtocol = 'IPv4'
                }    
                VimServerRef = @{
                    Type = 'ObjectId'
                    ObjectID = $vCenterID
                }
                HostName = $fqdn
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

<#
  .SYNOPSIS


  .DESCRIPTION
   Remove a Protection Proxy 

  .EXAMPLE
    $VPE=(Get-PPDMVPE -Type VPE).ID
    $ProxyID = (Get-PPDMProxy -filter 'Config.HostName eq "ppdm-vproxy02.xiolab.lab.emc.com"' -VPE $VPE).id
    Disable-PPDMProxy -VPE $VPE -id $ProxyID
    Remove-PPDMProxy -VPE $VPE -id $ProxyID
#>
function Remove-PPDMProtectionEngineProxy {
    [CmdletBinding()]
    [Alias('Remove-PPDMProxy')]
    param(
      $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
      $apiver = "/api/v2",
      [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
      $VPE,       
      [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
      $id
    )
    begin {
      $Response = @()
      $METHOD = "DELETE"
      $Myself = "protection-engines"
      # $response = Invoke-WebRequest -Method $Method -Uri $Global:PPDM_API_BaseUri/api/v0/$Myself -Headers $Global:PPDM_API_Headers
   
    }     
    Process {
  
      $URI = "/$myself/$vpe/proxies/$id"
      $Parameters = @{
        #            body             = $body 
        Uri                     = $Uri
        Method                  = $Method
        RequestMethod           = 'Rest'
        PPDM_API_BaseUri        = $PPDM_API_BaseUri
        apiver                  = $apiver
        Verbose                 = $PSBoundParameters['Verbose'] -eq $true
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
        default {
          # write-output $response.Date
        } 
      }   
    }
  }