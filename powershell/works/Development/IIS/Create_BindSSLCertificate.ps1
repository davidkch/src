<#
.SYNOPSIS
Generic script to create SSL certificate and binding it to website in IIS.
.DESCRIPTION
Generic script to create SSL certificate and binding it to website in IIS.
.EXAMPLE
.\Create_BindSSLCertificate.ps1 -CertificateName "samplecertificate" -Password "123" -WebsiteName "Default Web Site" -IP * -SSLPort 443
Creates "samplecertificate.pfx" certificate and binds it with "Default Web Site" website.
Version History  
v1.0   - ESIT Build Team - Initial Release
#>

param(
          [String]$CertificateName=$(throw "pass certificate name."),
          [String]$Password,
          [String]$WebsiteName=$(throw "pass website name."),
          [String]$IP=$(throw "pass IP for SSL binding."),
          [String]$SSLPort=$(thorw "pass port for SSL binding.")
)

$LogFile="Create_BindSSLCertificate.log"

Function Create_BindSSLCertificate
{
      Try
      {  
            Import-Module WebAdministration
            #checking if certificate already exists in mmc.
            $allCerts = Get-ChildItem cert:\LocalMachine\My
            foreach ($cert in $allCerts) { 
            if ($cert.SubjectName.Name -match "$CertificateName") { 
                  $cloudCert = $cert 
                 } 
            }
            if($cloudCert)
            {
                "---------------------------------------------------------------------------" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("---------------------------------------------------------------------------")
                 "certificate '$CertificateName' already exists in mmc. Hence binding it with '$WebsiteName' website." | Out-File $LogFile -Append
                 [System.Console]::WriteLine("certificate '$CertificateName' already exists in mmc. Hence binding it with '$WebsiteName' website.")
                  "---------------------------------------------------------------------------" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("---------------------------------------------------------------------------")
                 BindSSL
            }
            else
            {
                 if(!$Password)
                 {
                      Throw "Pass password for exporting .pfx certificate"
                 }
                 "---------------------------------------------------------------------------" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("---------------------------------------------------------------------------")
                 "creating '$CertificateName' certificate." | Out-File $LogFile -Append
                 [System.Console]::WriteLine("creating '$CertificateName' certificate.")
                 makecert.exe -n "CN=$CertificateName,O=Organization,OU=Org Unit,L=San Diego,S=CA,C=US" -pe -ss "My" -sr "LocalMachine" -sky exchange -m 96 -a sha1 -len 2048 -r "$CertificateName.cer"
                 certutil.exe -f -addstore Root "$CertificateName.cer"
                 certutil.exe -privatekey -exportpfx -p "$Password" "$CertificateName" "$CertificateName.pfx"
                 certutil.exe -f -p "$Password" -importPFX "$CertificateName.pfx"
                 "Certificate creation completed!" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("Certificate creation completed!")
                 "---------------------------------------------------------------------------" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("---------------------------------------------------------------------------")
                 "---------------------------------------------------------------------------" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("---------------------------------------------------------------------------")
                 "Creating SSL bindings for '$WebsiteName' website." | Out-File $LogFile -Append
                 [System.Console]::WriteLine("Creating SSL bindings for '$WebsiteName' website.")
                 "---------------------------------------------------------------------------" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("---------------------------------------------------------------------------")
                 $allCerts = Get-ChildItem cert:\LocalMachine\My
                 foreach ($cert in $allCerts) { 
                 if ($cert.SubjectName.Name -match "$CertificateName") { 
                     $cloudCert = $cert 
                     } 
                 }
                 BindSSL
            }
     }
      Catch
      {
           [System.Exception]
           Write-Output $_.Exception.Message | Out-File $LogFile -Append
           Write-Host $_.Exception.Message
      }
      Finally
      {
           "Execution completed!" | Out-File $LogFile -Append
           [System.Console]::WriteLine("Execution completed!")
      }
}

Function BindSSL
{
     if(Test-Path "IIS:\Sites\$WebsiteName")
     {
            "---------------------------------------------------------------------------" | Out-File $LogFile -Append
            [System.Console]::WriteLine("---------------------------------------------------------------------------")
            "creating SSL binding for '$WebsiteName' website." | Out-File $LogFile -Append
            [System.Console]::WriteLine("creating SSL binding for '$WebsiteName' website.")
            "---------------------------------------------------------------------------" | Out-File $LogFile -Append
            [System.Console]::WriteLine("---------------------------------------------------------------------------")
            New-WebBinding -Name "$WebsiteName" -IP $IP -Port $SSLPort -Protocol https
            $certObj = Get-Item $cloudCert.PSPath
            New-Item IIS:SslBindings\0.0.0.0!$SSLPort -value $certObj
      }
      else
      {
            "---------------------------------------------------------------------------" | Out-File $LogFile -Append
            [System.Console]::WriteLine("---------------------------------------------------------------------------")
            "website '$WebsiteName' does not exist!" | Out-File $LogFile -Append
            [System.Console]::WriteLine("website '$WebsiteName' does not exists!")
            "---------------------------------------------------------------------------" | Out-File $LogFile -Append
            [System.Console]::WriteLine("---------------------------------------------------------------------------")
      }
}

Create_BindSSLCertificate -CertificateName $CertificateName -Password $Password -WebsiteName $WebsiteName -IP $IP -SSLPort $SSLPort
