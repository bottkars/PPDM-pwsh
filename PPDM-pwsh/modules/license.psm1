<#
.Synopsis
Get all Licenses
.Description
Retrieves licenses that are available on the system.
PowerProtect Data Manager licenses include status details such as capacity usage, license Type, license status.
Type can be CAPACITY, SOCKET, APPLIANCE.

.Example
Get License

Get-PPDMlicenses      


id             : c56709ec-0982-4eac-89c5-948e17fe931e
swid           : xxxx
activationDate : 25.05.2021 15:37:12
type           : SOCKET
status         : VALID
key            : <?xml version="1.0" encoding="UTF-8"?>
                 <!--Copyright (c) 2010-2016 EMC Inc. All Rights Reserved.--><EMCLicense version="1.0">
                     <ActivationInfo>
                         <ActivationId>xxxx</ActivationId>
                         <ActivationDate>Mar 08, 2019 01:56:26 PM</ActivationDate>
                         <ActivatedBy>xxx</ActivatedBy>
                        ...

.Example
Get License by ID

Get-PPDMlicenses -id  c56709ec-0982-4eac-89c5-948e17fe931e     


id             : c56709ec-0982-4eac-89c5-948e17fe931e
swid           : xxxx
activationDate : 25.05.2021 15:37:12
type           : SOCKET
status         : VALID
key            : <?xml version="1.0" encoding="UTF-8"?>
                 <!--Copyright (c) 2010-2016 EMC Inc. All Rights Reserved.--><EMCLicense version="1.0">
                     <ActivationInfo>
                         <ActivationId>xxxx</ActivationId>
                         <ActivationDate>Mar 08, 2019 01:56:26 PM</ActivationDate>
                         <ActivatedBy>xxx</ActivatedBy>
                        ...

#>
function Get-PPDMlicenses {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    $id,
    [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]    
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
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
      Uri              = $URI
      Method           = $Method
      PPDM_API_BaseUri = $PPDM_API_BaseUri
      apiver           = $apiver
      Verbose          = $PSBoundParameters['Verbose'] -eq $true
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
<#
.Synopsis
Creates a new license.
.Description
Creates a new license.
A license xml file is passed in a key field.

.Example
Update a License by id:
$id = (Get-PPDMlicenses).id
$newkey=(Get-Content 'C:\Users\Karsten_Bott\Downloads\PPDM_3508081_08-Mar-2019_exp_eval.xml' | Out-String )
Set-PPDMLicenses -LicenseKey $newkey -id $id        


id             : c56709ec-0982-4eac-89c5-948e17fe931e
swid           : xxxxxxxxxxx
activationDate : 25.05.2021 15:37:12
type           : SOCKET
status         : VALID
key            : <?xml version="1.0" encoding="UTF-8"?>
                 <!--Copyright (c) 2010-2016 EMC Inc. All Rights Reserved.--><EMCLicense version="1.0">
                     <ActivationInfo>
                         <ActivationId>xxxx</ActivationId>
                         <ActivationDate>Mar 08, 2019 01:56:26 PM</ActivationDate>
                         <ActivatedBy>xxxx</ActivatedBy>
                         <ActivationType>ACTIVATE</ActivationType>
                         ...
#>
function Set-PPDMLicenses {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)] 
    [ValidateLength(1, 99999)][string]$LicenseKey,
    [Parameter(Mandatory = $true, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    $id,
    [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]    
    $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
    [Parameter(Mandatory = $false, ParameterSetName = 'all', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'byID', ValueFromPipelineByPropertyName = $true)]
    $apiver = "/api/v2", 
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'all')]
    [Parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = 'byId')]
    <# noop Parameter will simulate the command only #> 
    [switch]$noop                  
  )
  begin {
    $Response = @()
    $METHOD = "POST"
    $Myself = ($MyInvocation.MyCommand.Name.Substring(8) -replace "_", "-").ToLower()
   
  }     
  Process {
    switch ($PsCmdlet.ParameterSetName) {
      'byID' {
        $URI = "/$myself/$id"
        $METHOD = 'PUT'

      }
      default {
        $URI = "/$myself"
      }
    } 
    $Body = [ordered]@{
      'key' = $LicenseKey } | ConvertTo-Json    
    $Parameters = @{
      body = $body
      RequestMethod    = 'REST'
      Uri              = $URI
      Method           = $Method
      PPDM_API_BaseUri = $PPDM_API_BaseUri
      apiver           = $apiver
      Verbose          = $PSBoundParameters['Verbose'] -eq $true
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

