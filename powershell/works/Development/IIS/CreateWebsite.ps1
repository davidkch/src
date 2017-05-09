<#
.SYNOPSIS
Generic script to create a website in IIS.
.DESCRIPTION
Generic script to create a website in IIS.
.EXAMPLE
.\CreateWebsite.ps1 -WebsiteName "Default Web Site" -IPAddress * -Port 8080 -Physicalpath "D:\test" -AppPoolName "DefaultApplicationPool" -SSLSettings "Enable" -SSLClientcertificatetype "Require" -WindowsAuthentication "Enable" -BasicAuthentication "Enable" -AnonymousAuthentication "Enable" -ManagedRuntimeVersion "V4.0" -ManagedPipelineMode "Classic" -ApppoolIdentitytype "Built-in" -Builtintype "NetworkService" -SSLPort 443 -SSLCertificateName "Samplecertificate" -SSLCertificatepath "D:\test\samplecertificate.pfx" -SSLCertificatePassword 123 -HostHeader "Default"

Use below combinations for website settings:
1)$SSLSettings- Value should be either 'Enable' or 'Disable'.
If you want enable SSL settings then provide value for $SSLClientcertificatetype either "Require","Accept" or "Ignore".
2)If you want add SSL binding,
-Provide $SSLPort,$SSLCertificateName if certificate is already installed on Localmachine(personal).
-Provide $SSLPort,$SSLCertificateName,$SSLCertificatepath,$SSLCertificatePassword if certificate does not installed on Localmachine(personal).

Use below combinations for application pool settings:
1)$AppPoolIdentitytype value should be either 'Built-in' or 'Custom'
-If $AppPoolIdentitytype="Built-in" then provide $AppPoolIdentitytype value either "LocalService","LocalSystem","NetworkService" or "ApplicationPoolIdentity"
-If $AppPoolIdentitytype="Custom" then provide $Domain,$Username,$Password parameters.

Version History  
v1.0   - ESIT Build Team - Initial Release
#>

param([String]$WebsiteName=$(throw "pass Website name"),
      [String]$IPAddress=$(throw "pass IP address"),
      [String]$Port=$(thorw "pass Port number"),
      [String]$Physicalpath=$(throw "pass physical path for the website"),
      [String]$WindowsAuthentication,
      [String]$BasicAuthentication,
      [String]$AnonymousAuthentication,
      [String]$AppPoolName=$(throw "pass Application pool name"),
      [String]$ManagedRuntimeVersion="V2.0",
      [String]$ManagedPipelineMode="Integrated",
      [String]$AppPoolIdentitytype="Built-in",
      [String]$Builtintype="ApplicationPoolIdentity",
      [String]$Domain,
      [String]$Username,
      [String]$Password,
      [String]$SSLSettings,
      [String]$SSLClientcertificatetype,
      [String]$SSLPort,
      [String]$SSLCertificatepath,
      [String]$SSLCertificateName,
      [String]$SSLCertificatePassword,
      [String]$HostHeader
    )

$LogFile="CreateWebsite.log"

Function CreateWebsite
{
     Try
     {
           if($WindowsAuthentication -and ("Enable","Disable" -NotContains $WindowsAuthentication))
           {
                Throw "Invalid value for 'WindowsAuthentication'. Pass either 'Enable' or 'Disable'."
           }
            if($BasicAuthentication -and ("Enable","Disable" -NotContains $BasicAuthentication))
           {
                Throw "Invalid value for 'BasicAuthentication'. Pass either 'Enable' or 'Disable'."
           }
            if($AnonymousAuthentication -and ("Enable","Disable" -NotContains $AnonymousAuthentication))
           {
                Throw "Invalid value for 'AnonymousAuthentication'. Pass either 'Enable' or 'Disable'."
           }
           if($SSLClientcertificatetype -and ("Require","Accept","Ignore" -NotContains $SSLClientcertificatetype))
           {
                Throw "Invalid value for 'SSLClientcertificatetype'. Pass either 'Require','Accept' or ,Ignore for SSL settings."
           }
           if($AppPoolIdentitytype -and ("Built-in","Custom" -notcontains $AppPoolIdentitytype))
           {
                Thorw "Invalid value for 'AppPoolIdentitytype'. Pass either 'Built-in or Custom for setting application pool identity."
           }
           if($SSLSettings -and ("Enable","Disable" -notcontains $SSLSettings))
           {
                 Throw "Invalid value for 'SSLSettings'. Pass either 'Enable' or 'Disable'."
           }
           Import-Module WebAdministration
           if(Test-path "IIS:\Sites\$WebsiteName")
           {
                 [System.Console]::WriteLine("--------------------------------------------------------------")
                 "------------------------------------------------------------------------" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("Website '$WebsiteName' already exists!")
                 "Website '$WebsiteName' already exists!" | Out-File $LogFile -Append
                  [System.Console]::WriteLine("--------------------------------------------------------------")
                 "------------------------------------------------------------------------" | Out-File $LogFile -Append
           }
           else
           {
              if(Test-Path "$Physicalpath")
              {
                if(Test-Path "IIS:\AppPools\$AppPoolName")
                {
                     [System.Console]::WriteLine("--------------------------------------------------------------")
                     "------------------------------------------------------------------------" | Out-File $LogFile -Append
                     "Creating '$WebsiteName' Website and mapping it with existing application pool '$AppPoolName'" | Out-File $LogFile -Append
                     [System.Console]::WriteLine("Creating '$WebsiteName' Website and mapping it with existing application pool '$AppPoolName'")
                     [System.Console]::WriteLine("--------------------------------------------------------------")
                     "------------------------------------------------------------------------" | Out-File $LogFile -Append
                      Websitecreation
                     
                }
                else
                {
                   [System.Console]::WriteLine("------------------------------------------------------------------")
                   "----------------------------------------------------------------------" | Out-File $LogFile -Append
                   "Creating '$WebsiteName' website and mapping it with new application pool '$AppPoolName'" | Out-File $LogFile -Append
                   [System.Console]::WriteLine("Creating '$WebsiteName' website and mapping it with new application pool '$AppPoolName'")
                   [System.Console]::WriteLine("------------------------------------------------------------------")
                   "----------------------------------------------------------------------" | Out-File $LogFile -Append
                    CreateAppPool
                    [System.Console]::WriteLine("------------------------------------------------------------------")
                   "----------------------------------------------------------------------" | Out-File $LogFile -Append
                   "Creating '$WebsiteName' website in IIS." | Out-File $LogFile -Append
                   [System.Console]::WriteLine("Creating '$WebsiteName' website in IIS.")
                   [System.Console]::WriteLine("------------------------------------------------------------------")
                   "----------------------------------------------------------------------" | Out-File $LogFile -Append
                    Websitecreation
                }
              }
              else
              {
                  [System.Console]::WriteLine("------------------------------------------------------------------")
                  "----------------------------------------------------------------------" | Out-File $LogFile -Append
                  "Physical path '$Physicalpath' does not exists!" | Out-File $LogFile -Append
                  [System.Console]::WriteLine("Physical path '$Physicalpath' does not exists!")
                  [System.Console]::WriteLine("------------------------------------------------------------------")
                  "----------------------------------------------------------------------" | Out-File $LogFile -Append
              }
           }
     }
     Catch
     {
           [System.Exception]
           Write-Output $_.Exception.Message | Out-File $LogFile -Append
           Write-Host $_.Exceptiion.Message
     }
     Finally 
     {
           "Execution Completed!" | Out-File $LogFile -Append
           [System.Console]::WriteLine("Execution Completed!")
     }
} 
 
Function Websitecreation
{
     Try
     {
             New-Website -Name "$WebsiteName" -Port "$Port" -IPAddress "$IPAddress" -PhysicalPath "$Physicalpath" -ApplicationPool "$AppPoolName" -HostHeader "$HostHeader"
             if($WindowsAuthentication -or $BasicAuthentication -or $AnonymousAuthentication)
             {
                   AuthenticationFunction
             }
             If($SSLSettings -eq  "Enable")
             {
                   if($SSLClientcertificatetype)
                   {
                        SSLSettingsFunction
                   }
                   elseif(!$SSLClientcertificatetype)
                   {
                        Throw "Pass 'SSLClientcertificatetype' parameter for enabling SSL settings."
                   }
             }
             elseif($SSLSettings -eq "Disable")
             {
                   [System.Console]::WriteLine("--------------------------------------------------------")
                   "--------------------------------------------------------" | Out-File $LogFile -Append
                   "Disabling ssl settings." | Out-File $LogFile -Append
                   [System.Console]::WriteLine("Disabling ssl settings.")
                   [System.Console]::WriteLine("--------------------------------------------------------")
                   "--------------------------------------------------------" | Out-File $LogFile -Append
                   Set-WebConfiguration -Value "None" -Filter "system.webserver/security/access" -Location "$WebsiteName"       
             }

             if($SSLPort)
             {
                   $allCerts = Get-ChildItem cert:\LocalMachine\My
                   foreach ($cert in $allCerts) { 
                   if ($cert.SubjectName.Name -match "$SSLCertificateName") { 
                       $cloudCert = $cert 
                       } 
                   }
                   if($cloudCert)
                   {
                         [System.Console]::WriteLine("--------------------------------------------------------------")
                         "------------------------------------------------------------------------" | Out-File $LogFile -Append
                         "Certificate '$SSLCertificateName' already exists in mmc. Hence mapping it with $WebsiteName website." | Out-File $LogFile -Append
                         [System.Console]::WriteLine("Certificate '$SSLCertificateName' already exists in mmc. Hence binding it with $WebsiteName website.")
                         [System.Console]::WriteLine("--------------------------------------------------------------")
                         "------------------------------------------------------------------------" | Out-File $LogFile -Append
                         New-WebBinding -Name "$WebsiteName" -IP $IPAddress -Port $SSLPort -Protocol https
                         $certObj = Get-Item $cloudCert.PSPath
                         New-Item IIS:SslBindings\0.0.0.0!$SSLPort -value $certObj
                    }
                   else
                   {
                          if(Test-Path "$SSLCertificatepath")
                          {
                                  [System.Console]::WriteLine("--------------------------------------------------------------")
                                  "------------------------------------------------------------------------" | Out-File $LogFile -Append
                                  "Importing '$SSLCertificateName' certificate and binding with $WebsiteName website." | Out-File $LogFile -Append
                                  [System.Console]::WriteLine("Importing '$SSLCertificateName' certificate and binding with $WebsiteName website.")
                                  [System.Console]::WriteLine("--------------------------------------------------------------")
                                  "------------------------------------------------------------------------" | Out-File $LogFile -Append
                                  $pfxcert = new-object system.security.cryptography.x509certificates.x509certificate2
                                  $pfxcert.Import("$SSLCertificatepath", "$SSLCertificatePassword", [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]"UserKeySet")
                                  $store = new-object system.security.cryptography.X509Certificates.X509Store -argumentlist "My", LocalMachine
                                  $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]"ReadWrite")
                                  $store.Add($pfxcert)
                                  $allCerts = Get-ChildItem cert:\LocalMachine\My
                                  foreach ($cert in $allCerts) { 
                                  if ($cert.SubjectName.Name -match "$SSLCertificateName") { 
                                        $cloudCert = $cert 
                                        } 
                                  }
                                  New-WebBinding -Name "$WebsiteName" -IP $IPAddress -Port $SSLPort -Protocol https
                                  $certObj = Get-Item $cloudCert.PSPath
                                  New-Item IIS:SslBindings\0.0.0.0!$SSLPort -value $certObj
                            }
                            else
                            {
                                    "Certificate path '$SSLCertificatepath' does not exists!" | Out-File $LogFile -Append
                                    [System.Console]::WriteLine("Certificate path '$SSLCertificatepath' does not exists!")
                            }
                     }
             }
           
     }
      Catch
     {
           [System.Exception]
           Write-Output $_.Exception.Message | Out-File $LogFile -Append
           Write-Host $_.Exceptiion.Message
     }
     Finally 
     {
           "Creation of the website Completed!" | Out-File $LogFile -Append
           [System.Console]::WriteLine("Creation of the website Completed!")
     }
}

Function CreateAppPool
{
      Try
      {
              If($ManagedPipelineMode -and ("Classic","Integrated" -NotContains $ManagedPipelineMode))
              {
                   Throw "'$ManagedPipelineMode' is not a valid value for Managed Pipeline Mode! Please use 'Classic' or 'Integrated'"
              }
              If($ManagedRuntimeVersion -and ("v2.0","v4.0" -NotContains $ManagedRuntimeVersion))
              {
                   Throw "'$ManagedRuntimeVersion' is not a valid value for Managed runtime version! Please use 'v2.0' or 'v4.0'"
              }
              if($AppPoolIdentitytype -eq "Built-in")
              {
                  If("LocalService","LocalSystem","NetworkService","ApplicationPoolIdentity" -NotContains $Builtintype) 
                  { 
                        Throw "'$Builtintype' is not a valid application pool built-in identity type! Please use 'LocalService','LocalSystem','NetworkService','ApplicationPoolIdentity'" 
                  }
              }
              if($AppPoolIdentitytype -eq "Custom")
              {
                 if(!$Domain -or !$Username -or !$Password)
                 {
                      Throw "Pass 'Domain','Username' and 'Password' parameters for setting applicationpool identity as custom account."
                 }
                 elseif($Domain -and $Username -and $Password)
                 {
                      $Testcredentials=ValidateUserCredentials
                      if($Testcredentials.IsValid -eq "False")
                      {   
                          Throw "User credentials are not correct. Please check the values provided."
                      }
                 }
              }
              [System.Console]::WriteLine("--------------------------------------------------------")
              "--------------------------------------------------------" | Out-File $LogFile -Append
              "Creating application pool '$AppPoolName' in IIS" | Out-File $Logfile -Append
              [System.Console]::WriteLine("Creating application pool '$AppPoolName' in IIS")
              [System.Console]::WriteLine("--------------------------------------------------------")
              "--------------------------------------------------------" | Out-File $LogFile -Append
              New-WebAppPool -Name $AppPoolName
              $AppPoolsettings=Get-Item "IIS:\AppPools\$AppPoolName"
              $AppPoolsettings.managedPipelineMode="$ManagedPipelineMode"
              $AppPoolsettings.managedRuntimeVersion="$ManagedRuntimeVersion"
              $AppPoolsettings | Set-Item
              if($AppPoolIdentitytype -eq "Built-in")
              {
                      $AppPoolsettings.processModel.identityType="$Builtintype"
                      $AppPoolsettings | Set-Item
              }
              elseif($AppPoolIdentitytype -eq "Custom")
              {
                      $Username=$Domain+"\"+$Username
                      $AppPoolsettings.processModel.userName="$Username"
                      $AppPoolsettings.processModel.password="$Password"
                      $AppPoolsettings.processModel.identityType="SpecificUser"
                      $AppPoolsettings | Set-Item
              }
      }
      Catch
      {
           [System.Exception]
           Write-Output $_.Exception.Message | Out-File $LogFile -Append
           Write-Host $_.Exceptiion.Message
      }
      Finally
      {
           "Application pool creation finished." | Out-File $LogFile -Append
           [System.Console]::WriteLine("Application pool creation finished.")
      }
}

Function AuthenticationFunction
{
      Try
      {
            if($WindowsAuthentication -eq 'Enable')
            {
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                       "Enabling windows authentication for '$WebsiteName' website." | Out-File $LogFile -Append
                       [System.Console]::WriteLine("Enabling windows authentication for '$WebsiteName' website.")
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                        Set-WebConfigurationProperty -Filter /system.webServer/security/authentication/windowsAuthentication -Name enabled -Value true -PSPath IIS:\ -Location "$WebsiteName"
             }
             elseif($WindowsAuthentication -eq 'Disable')
             {
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                       "Disabling windows authentication for '$WebsiteName' website." | Out-File $LogFile -Append
                       [System.Console]::WriteLine("Disabling windows authentication for '$WebsiteName' website.")
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                        Set-WebConfigurationProperty -Filter /system.webServer/security/authentication/windowsAuthentication -Name enabled -Value false -PSPath IIS:\ -Location "$WebsiteName"
             }
             if($BasicAuthentication -eq 'Enable')
             {
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                       "Enabling basic authentication for '$WebsiteName' website." | Out-File $LogFile -Append
                       [System.Console]::WriteLine("Enabling basic authentication for '$WebsiteName' website.")
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                        Set-WebConfigurationProperty -Filter /system.webServer/security/authentication/basicAuthentication -Name enabled -Value true -PSPath IIS:\ -Location "$WebsiteName"
              }
              elseif($BasicAuthentication -eq 'Disable')
              {
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                       "Disabling basic authentication for '$WebsiteName' website." | Out-File $LogFile -Append
                       [System.Console]::WriteLine("Disabling basic authentication for '$WebsiteName' website.")
                       [System.Console]::WriteLine("--------------------------------------------------------")
                        "--------------------------------------------------------" | Out-File $LogFile -Append
                        Set-WebConfigurationProperty -Filter /system.webServer/security/authentication/basicAuthentication -Name enabled -Value false -PSPath IIS:\ -Location "$WebsiteName"
              }
              if($AnonymousAuthentication -eq 'Enable')
              {
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                       "Enabling Anonymous authentication for '$WebsiteName' website." | Out-File $LogFile -Append
                       [System.Console]::WriteLine("Enabling Anonymous authentication for '$WebsiteName' website.")
                       [System.Console]::WriteLine("--------------------------------------------------------")
                        "--------------------------------------------------------" | Out-File $LogFile -Append
                        Set-WebConfigurationProperty -Filter /system.webServer/security/authentication/anonymousAuthentication -Name enabled -Value true -PSPath IIS:\ -Location "$WebsiteName"
              }
              elseif($AnonymousAuthentication -eq 'Disable')
              {
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                       "Disabling Anonymous authentication for '$WebsiteName' website." | Out-File $LogFile -Append
                       [System.Console]::WriteLine("Disabling Anonymous authentication for '$WebsiteName' website.")
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                       Set-WebConfigurationProperty -Filter /system.webServer/security/authentication/anonymousAuthentication -Name enabled -Value false -PSPath IIS:\ -Location "$WebsiteName"
              }
      }
      Catch
      {
           [System.Exception]
           Write-Output $_.Exception.Message | Out-File $LogFile -Append
           Write-Host $_.Exceptiion.Message
      }
      Finally
      {
           "Authentication settings have been set for '$WebsiteName' website." | Out-File $LogFile -Append
           [System.Console]::WriteLine("Authentication settings have been set for '$WebsiteName' website.")
      }
}

Function SSLSettingsFunction
{
     Try
     {
          $Clientcert=$SSLClientcertificatetype.ToUpper()
          if("REQUIRE","ACCEPT","IGNORE" -Contains $Clientcert)
          {
                   [System.Console]::WriteLine("--------------------------------------------------------")
                    "--------------------------------------------------------" | Out-File $LogFile -Append
                   "Enabling the ssl settings by selecting '$SSLClientcertificatetype' for client certificates." | Out-File $LogFile -Append
                   [System.Console]::WriteLine("Enabling the ssl settings by selecting '$SSLClientcertificatetype' for client certificates.")
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
                 [System.Console]::WriteLine("Invalid option '$SSLClientcertificatetype'. Please pass any one of the 3 values 'Accept','Require' or 'Ignore' for ClientcertificateType parameter.")
                 "Invalid option '$SSLClientcertificatetype'. Please pass any one of the 3 values 'Accept','Require' or 'Ignore' for ClientcertificateType parameter." | Out-File $LogFile -Append
                 [System.Console]::WriteLine("--------------------------------------------------------")
                 "--------------------------------------------------------" | Out-File $LogFile -Append
          }
         
     }
    Catch
      {
           [System.Exception]
           Write-Output $_.Exception.Message | Out-File $LogFile -Append
           Write-Host $_.Exceptiion.Message
      }
      Finally
      {
           "SSL settings have been set for '$WebsiteName' website." | Out-File $LogFile -Append
           [System.Console]::WriteLine("SSL settings have been set for '$WebsiteName' website.")
      }
}

Function ValidateUserCredentials
{
    Try
    {
         Add-Type -AssemblyName System.DirectoryServices.AccountManagement
	     $ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain
	     $pc = New-Object System.DirectoryServices.AccountManagement.PrincipalContext($ct, $Domain)
	     New-Object PSObject -Property @{
		 UserName = $Username;
		 IsValid = $pc.ValidateCredentials($Username, $Password,"Negotiate").ToString()
         }
        
    }
    Catch
    {
         [System.Exception]
         Write-Output $_.Exception.Message | Out-File $LogFile -Append
         Write-Host $_.Exceptiion.Message
    }
    Finally
    {
         "User credentials validation finished." | Out-File $LogFile -Append
         [System.Console]::WriteLine("User credentials validation finished.")
    }
    
}

CreateWebsite -WebsiteName $WebsiteName -IPAddress $IPAddress -Port $Port -Physicalpath $Physicalpath -AppPoolName $AppPoolName -SSLSettings $SSLSettings -WindowsAuthentication $WindowsAuthentication -BasicAuthentication $BasicAuthentication -AnonymousAuthentication $AnonymousAuthentication -ManagedRuntimeVersion $ManagedRuntimeVersion -ManagedPipelineMode $ManagedPipelineMode -AppPoolIdentitytype $AppPoolIdentitytype -Builtintype $Builtintype -Username $Username -Password $Password -SSLClientcertificatetype $SSLClientcertificatetype -SSLPort $SSLPort -SSLCertificatepath $SSLCertificatepath -SSLCertificateName $SSLCertificateName -SSLCertificatePassword $SSLCertificatePassword -HostHeader $HostHeader -Domain $Domain