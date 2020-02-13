<#
.SYNOPSIS
Generic script to enable or disable SSL settings in IIS for website or virtual directory
.DESCRIPTION
Generic script to enable or disable SSL settings in IIS for website or virtual directory
.EXAMPLE
.\ConfigureWebsite_SSLSettings.ps1 -WebsiteName "Default Web Site" -Option 1 -Clientcertificatetype "Require" -VdirName "SampleVdir"
"Clientcertificatetype" could be one of the value: 'Require','Accept' or 'Ignore'.
"Option" value is either 1 or 0, i.e 1-enable,0-disable SSL settings.

.EXAMPLE
.\ConfigureWebsite_SSLSettings.ps1 -WebsiteName "Default Web Site" -Option 0
Disable SSL settings for "Default Web Site".

.EXAMPLE
.\ConfigureWebsite_SSLSettings.ps1 -WebsiteName "Default Web Site" -Option 1 -Clientcertificatetype "Accept"
Enable SSL settings for "Default Web Site" with client certificate type "accept".

Version History  
v1.0   - ESIT Build Team - Initial Release
#>

param(
         [String]$WebsiteName=$(throw "pass website name"),
         [Boolean]$Option=$(throw "Pass '1' or '0' to enable and disable the ssl settings"),
         [String]$Clientcertificatetype,[String]$VdirName #OPTIONAL
)

$LogFile="ConfigureWebsite_SSLSettings.log"

Function ConfigureWebsite_SSLSettings
{
      Try
      {  
           Import-Module WebAdministration
           if($VdirName)
           {
               $WebsiteName=$WebsiteName+"/"+$VdirName
           }
           $checkwebsite=Test-Path "IIS:\Sites\$WebsiteName"
           
           if($checkwebsite)
           {  
               if($Option -eq $true)
               {
                    $Clientcert=$Clientcertificatetype.ToUpper()
                    if("REQUIRE","ACCEPT","IGNORE" -Contains $Clientcert)
                    {
                         [System.Console]::WriteLine("--------------------------------------------------------")
                         "--------------------------------------------------------" | Out-File $LogFile -Append
                        "Enabling the ssl settings by selecting '$Clientcertificatetype' for client certificates." | Out-File $LogFile -Append
                         [System.Console]::WriteLine("Enabling the ssl settings by selecting '$Clientcertificatetype' for client certificates.")
                         [System.Console]::WriteLine("--------------------------------------------------------")
                         "--------------------------------------------------------" | Out-File $LogFile -Append
                         Switch($Clientcert)
                         {
                             "REQUIRE" {Set-WebConfiguration -Value "Ssl,SslRequireCert" -Filter "system.webserver/security/access" -Location "$WebsiteName"}
                             "ACCEPT" {Set-WebConfiguration -Value "Ssl,SslNegotiateCert" -Filter "system.webserver/security/access" -Location "$WebsiteName"}
                             "IGNORE" {Set-WebConfiguration -Value "Ssl,None" -Filter "system.webserver/security/access" -Location "$WebsiteName"}
                         } 
                    }
                     else
                    {
                      [System.Console]::WriteLine("--------------------------------------------------------")
                      "--------------------------------------------------------" | Out-File $LogFile -Append
                      [System.Console]::WriteLine("Invalid option '$Clientcertificatetype'. Please pass any one of the 3 values 'Accept','Require' or 'Ignore' for ClientcertificateType parameter.")
                      "Invalid option '$Clientcertificatetype'. Please pass any one of the 3 values 'Accept','Require' or 'Ignore' for ClientcertificateType parameter." | Out-File $LogFile -Append
                      [System.Console]::WriteLine("--------------------------------------------------------")
                      "--------------------------------------------------------" | Out-File $LogFile -Append
                    }
               }
               else
               {
                   [System.Console]::WriteLine("--------------------------------------------------------")
                   "--------------------------------------------------------" | Out-File $LogFile -Append
                   "Disabling ssl settings." | Out-File $LogFile -Append
                   [System.Console]::WriteLine("Disabling ssl settings.")
                   [System.Console]::WriteLine("--------------------------------------------------------")
                   "--------------------------------------------------------" | Out-File $LogFile -Append
                   Set-WebConfiguration -Value "None" -Filter "system.webserver/security/access" -Location "$WebsiteName"
               }
          }
          else
          {
               [System.Console]::WriteLine("--------------------------------------------------------")
               "--------------------------------------------------------" | Out-File $LogFile -Append
               "website/virtualdirectory '$WebsiteName' does not exists!" | Out-File $LogFile -Append
               [System.Console]::WriteLine("website/virtualdirectory '$WebsiteName' does not exists!")
               [System.Console]::WriteLine("--------------------------------------------------------")
               "--------------------------------------------------------" | Out-File $LogFile -Append
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

ConfigureWebsite_SSLSettings -WebsiteName $WebsiteName -Option $Option -Clientcertificatetype $Clientcertificatetype -VdirName $VdirName 