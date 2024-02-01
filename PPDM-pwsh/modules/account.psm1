function Set-PPDMuserpassword {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [securestring]$newPassword,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [System.Management.Automation.PSCredential]$Credentials,
        $PPDM_API_BaseUri = $Global:PPDM_API_BaseUri,
        $apiver = "/api/v2"
    )
    begin {
        $Response = @()
        $METHOD = "POST"
        $Myself = "account/change-password"
    }     
    Process {

        $URI = "/$myself"
        if (!$($Credentials)) {
            $username = Read-Host -Prompt "Please Enter PPDM Username"
            $SecurePassword = Read-Host -Prompt "Enter current Password for user $username" -AsSecureString
            $Credentials = New-Object System.Management.Automation.PSCredential($username, $Securepassword)
        }
        $password = $Credentials.GetNetworkCredential().password
        $username = $Credentials.GetNetworkCredential().UserName

        if (!($newPassword)) {
            $newPassword = Read-Host -Prompt "Please enter new Password for user $username" -AsSecureString

        }

        $Body = @{
            'username'    = $username
            'newPassword' = $newPassword | ConvertFrom-SecureString -AsPlainText
            'password'    = $password
        } | ConvertTo-Json

        write-verbose ($body | out-string )
        $Parameters = @{
            body               = $body 
            Uri                = $Uri
            Method             = $Method
            RequestMethod      = 'Rest'
            PPDM_API_BaseUri   = $PPDM_API_BaseUri
            apiver             = $apiver
            Verbose            = $PSBoundParameters['Verbose'] -eq $true
            ChangeUserPassword = $true
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
