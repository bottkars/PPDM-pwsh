#/api/v2/kubernetes-clusters 
#
#
function Get-PPDMkubernetes_clusters {
    [CmdletBinding()]
    [Alias('Get-PPDMk8sclusters')]
    param(
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
            default {
                write-output $response.content
            } 
        }   
    }
}

<#
.Synopsis
Get PVC Mappings vor a Volume
.Description
Retrieve PVC Mappings for a PVC Copy
.Example
$Cluster = Get-PPDMk8sclusters | where name -match ocs1
$COPY=Get-PPDMassets -filter 'type eq "KUBERNETES" and name eq "openshift-image-registry" and protectionStatus eq "PROTECTED"'  | Get-PPDMassetcopies | Select-Object -First 1
Get-PPDMk8spvcmappings -ID $Cluster.id -copyID $COPY.id

pvcName                storageClasses
-------                --------------
image-registry-storage {thin-csi, thin-csi-immediate}
#>
function Get-PPDMpvc_storage_class_mappings {
    [CmdletBinding()]
    [Alias('Get-PPDMk8spvcmappings')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$ID,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$copyID,        
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
            default {
                $URI = "/kubernetes-clusters/$id/$Myself"
            }
        }
        $Body = @{copyId=$copyId } # | convertto-json
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

#/api/v2/kubernetes-clusters/<cluster-id>/pvc-storage-class-mappings?copyId={copyId}
#https://ppdm.home.labbuildr.com/passthrough/api/v2/kubernetes-clusters/041115e8-b2b2-47cc-9b9d-df2362975978/pvc-storage-class-mappings?copyId=2d443c1c-ed3e-5572-b588-c054146c17c8