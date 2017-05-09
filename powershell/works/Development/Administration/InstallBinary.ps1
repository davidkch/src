#######################  
<#  
.SYNOPSIS  
 Generic script to execute installer components in specific DLLs.
.DESCRIPTION  
 The Installer tool is a command-line utility that allows you to install and uninstall server resources by executing the installer components in specified assemblies.
.EXAMPLE  
.\InstallBinary.ps1 -DLL_Installed MyDLL.dll
Version History  
v1.0   - ESIT Build Team - Initial Release  
#> 

param(
        [string]$DLL_Installed = $(throw "Please pass the list of DLLs to install.")
)

$LogFile = "InstallBinary.log"
$FrameworkPath = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319"

Function InstallBinary
{
 try
 {
  write-output "Installing DLL..." | Out-File $LogFile
  & $FrameworkPath\installUtil.exe "$DLL_Installed" | Out-File $LogFile -Append
 }
 Catch [system.exception]
 {
  write-output $_.exception.message | Out-File $LogFile -Append
  write-host $_.exception.message
 }
 Finally
 {
  Write-Output "Completed Successfully!" | Out-File $LogFile -Append
 }
}

InstallBinary -DLL_Installed $DLL_Installed