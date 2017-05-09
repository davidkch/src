#######################  
<#  
.SYNOPSIS  
 Generic script to set default location of logging for all websites
.DESCRIPTION  
 Generic script to set default location of logging for all websites
.EXAMPLE  
.\ConfigureAppPool_LogDir.ps1 -WebLogs D:\
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
        [string]$WebLogs = $(throw "Please pass auto start value.  Expects true/false value.")
)

$LogFile = "ConfigureAppPool_LogDir.log"
$WinDir = $env:Windir

Function ConfigureAppPool_LogDir
{
 try
 {
  write-output "Setting directory for all website log files..." | Out-File $LogFile
  #Directory is set for location for event logs
  & $WinDir\system32\inetsrv\appcmd.exe set config /section:sites /siteDefaults.logFile.directory:$WebLogs | Out-File $LogFile -Append
 }
 Catch [system.exception]
 {
  write-output $_.exception.message | Out-File $LogFile -Append
  write-host $_.exception.message
 }
 Finally
 {
  "Completed Successfully!" | Out-File $LogFile -Append
 }
}

ConfigureAppPool_LogDir -WebLogs $WebLogs

