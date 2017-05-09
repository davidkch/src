<#
.SYNOPSIS
Generic script to install windows service.
.DESCRIPTION
Generic script to install windows service.
.EXAMPLE
.\InstallWindowsService.ps1 -ServiceName "InvoiceGeneratorService" -ExecutablePath "D:\Test\Microsoft.IT.RelationshipManagement.Invoice.Generate.Main.exe" -ServiceDisaplayName "InvoiceGeneratorService" -Description "InvoiceGeneratorService" -StartupType "Automatic"
It installs 'InvoiceGeneratorService' windows service in services(local), Sets the log on as "Local System" account.

.EXAMPLE
.\InstallWindowsService.ps1 -ServiceName "InvoiceGeneratorService" -ExecutablePath "D:\Test\Microsoft.IT.RelationshipManagement.Invoice.Generate.Main.exe" -ServiceDisaplayName "InvoiceGeneratorService" -Description "InvoiceGeneratorService" -StartupType "Automatic" -LogOnAccount "Custom" -Domain "Redmond" -UserName "bgcoebld" -Password "Password"
It installs 'InvoiceGeneratorService' windows service in services(local), sets the log on as "Redmond\bgcoebld" account.

Version History  
v1.0   - ESIT Build Team - Initial Release
#>

param(
        [String]$ServiceName=$(throw "pass servicename"),
        [String]$ExecutablePath=$(throw "pass service .exe path"),
        [String]$ServiceDisaplayName=$(throw "pass display name for service"),
        [String]$Description=$(throw "pass description for windows service"),
        [String]$StartupType="Automatic",
        [String]$LogOnAccount="LocalSystem",
        [String]$Domain,[String]$UserName,[String]$Password
)

$LogFile="InstallWindowsService.log"


Function InstallWindowsService
{
     Try
     {
          if($StartupType -and ("Automatic","Disabled","Manual" -notcontains $StartupType))
          {
               Throw "Invalid value '$StartupType' for StartupType parameter. Pass either of the 3 values 'Automatic','Disabled' or 'Manual'"
          }
          if("LocalSystem","Custom" -notcontains $LogOnAccount)
          {
               Throw "Invalid value '$LogOnAccount' for LogOnAccount parameter. Pass either 'LocalSystem' or 'Custom' for setting the logon account of windows service"
          }
          $CheckService=(Get-Service -Name "$ServiceName" -ErrorAction SilentlyContinue)
          if(Test-Path $ExecutablePath)
          {
             if($CheckService)
             {
               "windows service '$ServiceName' already installed." | Out-File $LogFile -Append
               [System.Console]::WriteLine("windows service '$ServiceName' already installed.")
             }
             else
             {
               if($LogOnAccount -eq "Custom")
               {
                  if(!$Domain -or !$UserName -or !$Password)
                  {
                      Throw "pass 'Domain','UserName' and 'Password' parameters for setting up custom account as logon for windows service."
                  }
                  if($Domain -or $UserName -or $Password)
                  {
                       $Testcredentials=ValidateUserCredentials
                       if($Testcredentials.IsValid -eq "False")
                       {   
                           Throw "User credentials are not correct. Please check the values provided."
                       }
                  }
               }
               "Installing windows service '$ServiceName'" | Out-File $LogFile -Append
               [System.Console]::WriteLine("Installing windows service '$ServiceName'")
               New-Service -Name "$ServiceName" -BinaryPathName "$ExecutablePath" -DisplayName "$ServiceDisaplayName" -Description "$Description" -StartupType $StartupType
               Start-Service -Name "$ServiceName" -ErrorAction SilentlyContinue
               if($LogOnAccount -eq "Custom")
               {
                  $UserName=$Domain+"\"+ $UserName
               }
               $svc=Get-WmiObject win32_service | where {$_.name -eq "$ServiceName"}
               Stop-Service -Name '$ServiceName' -ErrorAction SilentlyContinue
               $Svc.Change($Null, $Null, $Null, $Null, $Null, $Null, "$UserName", "$Password")
               Start-Service -Name '$ServiceName' -ErrorAction SilentlyContinue
            }
          }
          else
          {
              "Physical path '$ExecutablePath' does not exists!" | Out-File $LogFile -Append
              [System.Console]::WriteLine("Physical path '$ExecutablePath' does not exists!")
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

Function ValidateUserCredentials
{
    Try
    {
         Add-Type -AssemblyName System.DirectoryServices.AccountManagement
	     $ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain
	     $pc = New-Object System.DirectoryServices.AccountManagement.PrincipalContext($ct, $Domain)
	     New-Object PSObject -Property @{
		 UserName = $UserName;
		 IsValid = $pc.ValidateCredentials($UserName, $Password,"Negotiate").ToString()
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



InstallWindowsService -ServiceName $ServiceName -ExecutablePath $ExecutablePath -ServiceDisaplayName $ServiceDisaplayName -Description $Description -StartupType $StartupType -Domain $Domain -UserName $UserName -Password $Password -LogOnAccount $LogOnAccount