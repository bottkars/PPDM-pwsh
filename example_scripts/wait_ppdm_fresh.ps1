$env:PPDM_URL = "https://ppdm-demo.home.labbuildr.com"
Write-Host " Waiting for $env:PPDM_URL to become ready for configuration"

do {
    Try {     
        $req = Invoke-WebRequest -Uri "$env:PPDM_URL/#/fresh" -SkipCertificateCheck -ErrorAction Stop 
    }
    Catch {
        $message = $_.exception.message
        Write-Warning $message
    }
    Finally {
        If ($req.statuscode) {
            Write-Host $req.statuscode
        }
    }
    start-sleep  20
} until ($req.statuscode -eq 200)