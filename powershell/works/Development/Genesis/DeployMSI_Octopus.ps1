<#
.SYNOPSIS
Generic script for deploying .msi through Octopus.
.DESCRIPTION
Generic script for deploying .msi through Octopus.
.EXAMPLE
.\DeployMSI_Octopus.ps1 -AdminPassword "password" -Configurationfilepath "D:\powershell\BAE.Config.xml" -Option "Install"
This will install components published on BAE.Config.xml file through octopus.

.EXAMPLE
.\DeployMSI_Octopus.ps1 -AdminPassword "password" -Configurationfilepath "D:\powershell\BAE.Config.xml" -Option "UnInstall"
This will uninstall components published on BAE.Config.xml file through octopus.

Version History  
v1.0   - ESIT Build Team - Initial Release
#>

param(
         [String]$AdminPassword=$(throw "Pass password for the current user. Must be an administrator on all target servers."),
         [String]$Configurationfilepath=$(throw "Pass physicalpath for octopus configuation file(ex.BAE.config.xml)"),
         [String]$Option="Install"
)

$LogFile="DeployMSI_Octopus.log"

Function DeployMSI_Octopus
{
      Try
      {  
	       [System.Console]::WriteLine("Configurationfilepath: $Configurationfilepath")
           [System.Console]::WriteLine("Option: $Option")
           "Configurationfilepath: $Configurationfilepath" | Out-File $LogFile -Append
           "Option: $Option" | Out-File $LogFile -Append
           if("Install","UnInstall" -Notcontains $Option)
           {
                [System.Console]::WriteLine("--------------------------------------------------------")
                 "--------------------------------------------------------" | Out-File $LogFile -Append
                [System.Console]::WriteLine("Invalid value '$Option'! pass either 'Install' or 'UnInstall' for Option parameter")
                "Invalid value '$Option'! pass either 'Install' or 'UnInstall' for Option parameter" | Out-File $LogFile -Append
                [System.Console]::WriteLine("--------------------------------------------------------")
                 "--------------------------------------------------------" | Out-File $LogFile -Append
           }
           if($env:PROCESSOR_ARCHITECTURE -eq "AMD64")
           {
                if(Test-Path "C:\Program Files\Microsoft Octopus")
                {
                     if(Test-Path "$Configurationfilepath")
                     {
                         if($Option -eq "Install")
                         {
                             [System.Console]::WriteLine("--------------------------------------------------------")
                             "--------------------------------------------------------" | Out-File $LogFile -Append
                             [System.Console]::WriteLine("Installation of the components started..")
                             "Installation of the components started.." | Out-File $LogFile -Append
                             [System.Console]::WriteLine("--------------------------------------------------------")
                             "--------------------------------------------------------" | Out-File $LogFile -Append
                             $exe="C:\Program Files\Microsoft Octopus\octopuscli.exe"
                             &$exe -adminPassword "$AdminPassword" -config "$Configurationfilepath" -install | Out-File $LogFile -Append
                             [System.Console]::WriteLine("--------------------------------------------------------")
                             "--------------------------------------------------------" | Out-File $LogFile -Append
                             [System.Console]::WriteLine("Installation of the components finished..")
                             "Installation of the components finished.." | Out-File $LogFile -Append
                             [System.Console]::WriteLine("--------------------------------------------------------")
                             "--------------------------------------------------------" | Out-File $LogFile -Append
                         }
                         elseif($Option -eq "UnInstall")
                         {
                              [System.Console]::WriteLine("--------------------------------------------------------")
                             "--------------------------------------------------------" | Out-File $LogFile -Append
                             [System.Console]::WriteLine("UnInstallation of the components started..")
                             "UnInstallation of the components started.." | Out-File $LogFile -Append
                             [System.Console]::WriteLine("--------------------------------------------------------")
                             "--------------------------------------------------------" | Out-File $LogFile -Append
                              $exe="C:\Program Files\Microsoft Octopus\octopuscli.exe"
                             &$exe -adminPassword "$AdminPassword" -config "$Configurationfilepath" -Uninstall | Out-File $LogFile -Append
                             [System.Console]::WriteLine("--------------------------------------------------------")
                             "--------------------------------------------------------" | Out-File $LogFile -Append
                             [System.Console]::WriteLine("UnInstallation of the components finished..")
                             "UnInstallation of the components finished.." | Out-File $LogFile -Append
                             [System.Console]::WriteLine("--------------------------------------------------------")
                             "--------------------------------------------------------" | Out-File $LogFile -Append
                         }
                     }
                     else
                     {
                           [System.Console]::WriteLine("--------------------------------------------------------")
                           "--------------------------------------------------------" | Out-File $LogFile -Append
                           [System.Console]::WriteLine("Configuration file '$Configurationfilepath' does not exists!")
                           "Configuration file '$Configurationfilepath' does not exists!" | Out-File $LogFile -Append
                           [System.Console]::WriteLine("--------------------------------------------------------")
                           "--------------------------------------------------------" | Out-File $LogFile -Append
                     }
                }
                else
                {
                     [System.Console]::WriteLine("--------------------------------------------------------")
                     "--------------------------------------------------------" | Out-File $LogFile -Append
                     [System.Console]::WriteLine("Octopus does not installed. Please install 64bit octopus and try with the installtion.")
                     "Octopus does not installed. Please install 64bit octopus and try with the installtion." | Out-File $LogFile -Append
                     [System.Console]::WriteLine("--------------------------------------------------------")
                     "--------------------------------------------------------" | Out-File $LogFile -Append
                }
           }
           elseif($env:PROCESSOR_ARCHITECTURE -eq "x86")
           { 
                if(Test-Path "C:\Program Files (x86)\Microsoft Octopus")
                {
                     if(Test-Path "$Configurationfilepath")
                     {
                          if($Option -eq "Install")
                         {
                             [System.Console]::WriteLine("--------------------------------------------------------")
                             "--------------------------------------------------------" | Out-File $LogFile -Append
                             [System.Console]::WriteLine("Installation of the components started..")
                             "Installation of the components started.." | Out-File $LogFile -Append
                             [System.Console]::WriteLine("--------------------------------------------------------")
                             "--------------------------------------------------------" | Out-File $LogFile -Append
                             $exe="C:\Program Files (x86)\Microsoft Octopus\octopuscli.exe" 
                             &$exe -adminPassword "$AdminPassword" -config "$Configurationfilepath" -install | Out-File $LogFile -Append
                              [System.Console]::WriteLine("--------------------------------------------------------")
                             "--------------------------------------------------------" | Out-File $LogFile -Append
                             [System.Console]::WriteLine("Installation of the components finished..")
                             "Installation of the components finished.." | Out-File $LogFile -Append
                             [System.Console]::WriteLine("--------------------------------------------------------")
                             "--------------------------------------------------------" | Out-File $LogFile -Append
                         }
                         elseif($Option -eq "UnInstall")
                         {
                             [System.Console]::WriteLine("--------------------------------------------------------")
                             "--------------------------------------------------------" | Out-File $LogFile -Append
                             [System.Console]::WriteLine("UnInstallation of the components started..")
                             "UnInstallation of the components started.." | Out-File $LogFile -Append
                             [System.Console]::WriteLine("--------------------------------------------------------")
                             "--------------------------------------------------------" | Out-File $LogFile -Append
                             $exe="C:\Program Files (x86)\Microsoft Octopus\octopuscli.exe" 
                             &$exe -adminPassword "$AdminPassword" -config "$Configurationfilepath" -Uninstall | Out-File $LogFile -Append
                              [System.Console]::WriteLine("--------------------------------------------------------")
                             "--------------------------------------------------------" | Out-File $LogFile -Append
                             [System.Console]::WriteLine("UnInstallation of the components finished..")
                             "UnInstallation of the components finished.." | Out-File $LogFile -Append
                             [System.Console]::WriteLine("--------------------------------------------------------")
                             "--------------------------------------------------------" | Out-File $LogFile -Append
                         }
                     }
                     else
                     {
                           [System.Console]::WriteLine("--------------------------------------------------------")
                           "--------------------------------------------------------" | Out-File $LogFile -Append
                           [System.Console]::WriteLine("Configuration file '$Configurationfilepath' does not exists!")
                           "Configuration file '$Configurationfilepath' does not exists!" | Out-File $LogFile -Append
                           [System.Console]::WriteLine("--------------------------------------------------------")
                           "--------------------------------------------------------" | Out-File $LogFile -Append
                     }
                }
                else
                {
                     [System.Console]::WriteLine("--------------------------------------------------------")
                     "--------------------------------------------------------" | Out-File $LogFile -Append
                     [System.Console]::WriteLine("Octopus does not installed. Please install 32bit octopus and try with the installtion.")
                     "Octopus does not installed. Please install 32bit octopus and try with the installtion." | Out-File $LogFile -Append
                     [System.Console]::WriteLine("--------------------------------------------------------")
                     "--------------------------------------------------------" | Out-File $LogFile -Append
                }
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

DeployMSI_Octopus -AdminPassword $AdminPassword -Configurationfilepath $Configurationfilepath -Option $Option