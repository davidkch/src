<#
.SYNOPSIS
Generic script to enable auto start option for application pools at server level
.DESCRIPTION
Generic script to enable auto start option for application pools at server level
.EXAMPLE
.\ConfigureServer_AppPoolAutoStart.ps1
Sets 'start automatically' value to 'true' for application pool default settings at server level.

Version History  
v1.0   - ESIT Build Team - Initial Release
#>

$LogFile="ConfigureServer_AppPoolAutoStart.log"

Function ConfigureServer_AppPoolAutoStart
{
     Try
     {
          Import-Module WebAdministration
          $computername=(Get-Childitem env:computername).Value
          $Apppoolsettings = [adsi]"IIS://$computername/W3SVC/AppPools"
          if(($Apppoolsettings.AppPoolAutoStart) -eq $true)
          { 
                [System.Console]::WriteLine("--------------------------------------------------------")
                "--------------------------------------------------------" | Out-File $LogFile -Append
                "Application pools auto start option at server level is already enabled!" | Out-File $LogFile -Append
                [System.Console]::WriteLine("Application pools auto start option at server level is already enabled!")
                [System.Console]::WriteLine("--------------------------------------------------------")
                "--------------------------------------------------------" | Out-File $LogFile -Append
          }
          else
          {
                [System.Console]::WriteLine("--------------------------------------------------------")
                "--------------------------------------------------------" | Out-File $LogFile -Append
                "Enabling auto start option for application pools at server level." | Out-File $LogFile -Append
                [System.Console]::WriteLine("Enabling auto start option for application pools at server level.")
                [System.Console]::WriteLine("--------------------------------------------------------")
                "--------------------------------------------------------" | Out-File $LogFile -Append
                Set-ItemProperty "IIS:\" -Name "applicationPoolDefaults.autostart" -Value $true
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

ConfigureServer_AppPoolAutoStart