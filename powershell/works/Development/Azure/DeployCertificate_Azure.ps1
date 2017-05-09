<#
.SYNOPSIS
Generic script to deploy certificates to azure portal.
.DESCRIPTION
Generic script to deploy certificates to azure portal.
.EXAMPLE
.\DeployCertificate_Azure.ps1 -Servicename "dslinkgendev" -CertificatePath "D:\powershell\dslgsdev01.pfx" -CertificatePassword "123"
This will upload 'dslgsdev01.pfx' certificate to 'dslinkgendev' service in azure portal

.EXAMPLE
.\DeployCertificate_Azure.ps1 -Servicename "dslinkgendev" -CertificatePath "D:\powershell\dslgsdev01.cer"
This will upload 'dslgsdev01.cer' certificate to 'dslinkgendev' service in azure portal

Version History  
v1.0   - ESIT Build Team - Initial Release
#>

param(
         [String]$Servicename=$(throw "Pass servicename"),
         [String]$CertificatePath=$(throw "Pass physical path of the certificate"),
         [String]$CertificatePassword
)

$LogFile="DeployCertificate_Azure.log"

Function DeployCertificate_Azure
{
      Try
      {  
           [System.Console]::WriteLine("Servicename: $Servicename")
           [System.Console]::WriteLine("CertificatePath: $CertificatePath")
           "Servicename: $Servicename" | Out-File $LogFile -Append
           "CertificatePath: $CertificatePath" | Out-File $LogFile -Append
           $Certificateexten=Get-ChildItem "$CertificatePath"
           try
           {
               Import-Module Azure
               if($? -eq $false)
               {
                   $exitcode=1
                   exit $exitcode
               }
           }
           catch
           {
               Write-Host "File Already Imported or it doesnot exists"
           }
           if(Test-Path "$CertificatePath")
           {
               if($Certificateexten.Extension -eq ".pfx")
               {
                    if($CertificatePassword -eq $null)
                    {
                        Throw "Pass password for .pfx certificate($Certificateexten.Name) to upload it to azure portal"
                    }
                    else
                    {
                        [System.Console]::WriteLine("--------------------------------------------------------------------------")
                        "--------------------------------------------------------------------------" | Out-File $LogFile -Append
                        [System.Console]::WriteLine("uploading '$Certificateexten' certificate to azure")
                        "uploading '$Certificateexten' certificate to azure" | Out-File $LogFile -Append
                        Add-AzureCertificate -serviceName "$Servicename" -certToDeploy "$CertificatePath" -password "$CertificatePassword"
                        [System.Console]::WriteLine("--------------------------------------------------------------------------")
                        "--------------------------------------------------------------------------" | Out-File $LogFile -Append
                    }
                }
                elseif($Certificateexten.Extension -eq ".cer")
                {
                    [System.Console]::WriteLine("--------------------------------------------------------------------------")
                    "--------------------------------------------------------------------------" | Out-File $LogFile -Append
                    [System.Console]::WriteLine("uploading '$Certificateexten' certificate to azure")
                    "uploading '$Certificateexten' certificate to azure" | Out-File $LogFile -Append
                    Add-AzureCertificate -serviceName "$Servicename" -certToDeploy "$CertificatePath"
                    [System.Console]::WriteLine("--------------------------------------------------------------------------")
                    "--------------------------------------------------------------------------" | Out-File $LogFile -Append
                }
                else
                {
                    [System.Console]::WriteLine("Invalid certificate type '$Certificateexten.Extension'")
                    "Invalid certificate type '$Certificateexten.Extension'" | Out-File $LogFile -Append
                }
           }
           else
           {
                [System.Console]::WriteLine("certificatepath '$CertificatePath' does not exists.")
                "certificatepath '$CertificatePath' does not exists." | Out-File $LogFile -Append
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

DeployCertificate_Azure -Servicename $Servicename -CertificatePath $CertificatePath -CertificatePassword $CertificatePassword