#######################  
<#  
.SYNOPSIS  
 Generic script to set specified website to automatically start
.DESCRIPTION  
 Generic script to set specified website to automatically start
.EXAMPLE  
.\ConfigureWebsite_AutoStart.ps1 -Website MyWebsiteName -Vdir MyVirDirName -AutoStartEnabled true
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
        [string]$AutoStartEnabled = $(throw "Please pass auto start value.  Expects true/false value."),
        [string]$Website = $(throw "Please pass website name.")
)

$LogFile = "ConfigureAppPool_AutoStart.log"
$WinDir = $env:Windir

Function ConfigureAppPool_AutoStart
{
 try
 {
  #Setting auto-start property of virtual directory
  write-output "Setting property AutoStartEnabled..." | Out-File $LogFile
  & $WinDir\system32\inetsrv\appcmd.exe set site "$WebSite" /serverAutoStart:$AutoStartEnabled
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

ConfigureAppPool_AutoStart -Website $Website -Vdir $Vdir -AutoStartEnabled $AutoStartEnabled