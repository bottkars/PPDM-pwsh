Function Get-PPDMWebException {
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        [System.Management.Automation.ErrorRecord]$ExceptionMessage
    )
    $type = $MyInvocation.MyCommand.Name -replace "Get-", "" -replace "WebException", ""
        
    switch -Wildcard ($ExceptionMessage.FullyQualifiedErrorId) {
        "*System.UriFormatException,Microsoft.PowerShell.Commands.Invoke*Command*" {
            Write-Host -ForegroundColor Magenta "$($ExceptionMessage.Exception.Message)"
            write-Host "Most likely you are not connected to Operations Manager"
            write-Host "please use Connect-PCFopsmman to connect"
        }
            
        "*WebCmdletWebResponseException,Microsoft.PowerShell.Commands.Invoke*Command*" {
            switch -Wildcard ($ExceptionMessage.Exception) {
                "*SSL/TLS secure channel*" {
                    Write-Host -ForegroundColor Magenta $ExceptionMessage
                    Write-Host -ForegroundColor White "SSL/TLS secure channel error indicates untrusted certificates. Connect using -trustCert Option !"

                }
                    
                "*400*" {
                    Write-Host -ForegroundColor Magenta $ExceptionMessage
                    Write-Host -ForegroundColor White "400 Bad Request Badly formed URI, parameters, headers, or body content. Essentially a request syntax error or object not found
						Possible wrong password on Session based Authentication"
                }
                "*401*" {
                    Write-Host -ForegroundColor Magenta $ExceptionMessage
                    Write-Host -ForegroundColor White "Session expired or wrong User/Password ?"
                }

                "*403*" {
                    Write-Host -ForegroundColor Magenta $ExceptionMessage
                    Write-Host -ForegroundColor White "403 Forbidden Not allowed "
                }
                "*404*" {
                    Write-Host -ForegroundColor Magenta $ExceptionMessage
                    Write-Host -ForegroundColor White "404 Not Found Resource doesn't exist - either an invalid type name for instances list (GET, POST) or an invalid ID for a specific instance (GET, POST /action)"
                }
                "*405*" {
                    Write-Host -ForegroundColor Magenta $ExceptionMessage
                    Write-Host -ForegroundColor White "405 Method Not Allowed This code will be returned if you try to use a method that is not documented as a supported method."
                }
                "*406*" {
                    Write-Host -ForegroundColor Magenta $ExceptionMessage
                    Write-Host -ForegroundColor White "406 Not Acceptable Accept headers do not meet requirements (for example, output format, version,language)
"
                }
                "*409*" {
                    Write-Host -ForegroundColor Magenta $ExceptionMessage
                    Write-Host -ForegroundColor White "409 Conflict The request could not be completed due to a conflict with the current state of the resource.
This code is only allowed in situations where it is expected that the usermight be able to resolve the conflict and resubmit the request.
The response body SHOULD include enough information for the user to correct the issue."
                }
                "*422*" {
                    Write-Host -ForegroundColor Magenta $ExceptionMessage
                    Write-Host -ForegroundColor White "422 Unprocessable Entity
Semantically invalid content on a POST, which could be a range error, inconsistent properties, or something similar"
                }
                "*428*" {
                    Write-Host -ForegroundColor Magenta $ExceptionMessage
                    Write-Host -ForegroundColor White "Most likely this signals an unconfigured API or unapproved Certificates"
                }
                "*500*" {
                    Write-Host -ForegroundColor Magenta $ExceptionMessage
                    Write-Host -ForegroundColor White "500 Internal Server Error
This code is returned for internal errors -
Possible Cause: API Server is not ready
"
                }
                "*501*" {
                    Write-Host -ForegroundColor Magenta $ExceptionMessage
                    Write-Host -ForegroundColor White "501 Not Implemented Not currently used"
                }
                "*502*" {
                    Write-Host -ForegroundColor Magenta $ExceptionMessage
                    Write-Host -ForegroundColor White "502 Bad Gateway:
                This indicates PDM not running correctly or Awaiting Decryption Passphrase"
                }                
                "*503*" {
                    Write-Host -ForegroundColor Magenta $ExceptionMessage
                    Write-Host -ForegroundColor White "503 Service Unavailable"
                }
                "*SSL/TLS*" {
                    Write-Host -ForegroundColor White "You are using an untrusted Connection (i.E. Selfsigned Certificates) to PDM
Please connect using 'Connect-PPDMapiEndpoint -PPDM_API_URI [uri] -trustCert' "
                }   
                default {
                    Write-Host -ForegroundColor White "general web error"
                    $_ | fl *
                }                 
            }

        }
        default {
            Write-Host -Foregroundcolor White "$($ExceptionMessage.ToString())"
#            Write-Host -ForegroundColor Cyan "error not yet declared or no specific returncode"
#            Write-host -Foregroundcolor Gray "Exception caught at '$($ExceptionMessage.InvocationInfo.InvocationName) '
#Calling Position: $($ExceptionMessage.InvocationInfo.PositionMessage)
#$($ExceptionMessage.FullyQualifiedErrorId)"
        }
    }
}
