winrm delete winrm/config/Listener?Address=*+Transport=HTTPS
$CERT=New-SelfSignedCertificate -Subject "mcl-mc760-n04.edub.csc" -TextExtension @("2.5.29.17={text}IPAddress=10.204.118.234&IPAddress=10.204.118.242&DNS=mcl-mc760-cls.edub.csc") -CertStoreLocation "cert:\LocalMachine\My" -Type SSLServerAuthentication
New-Item -Path WSMan:\localhost\Listener\ -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint -Force



