#######################  
<#  
.SYNOPSIS  
 Generic script to set extended protection property for a website and virtual directory.
.DESCRIPTION  
 "Extended protection" enhances the existing Windows authentication functionality in order to 
# mitigate authentication relay or "man in the middle" attacks.
.EXAMPLE  
.\ConfigureWebsite_ExtendedProtection.ps1 -Website MyWebsiteName -Vdir MyVirDirName
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
        [string]$Website = $(throw "Please pass website name."),
        [string]$Vdir = $(throw "Please pass virtual directory name.")
)

$LogFile = "ConfigureWebsite_ExtendedProtection.log"
$WinDir = $env:Windir

Function ConfigureWebsite_ExtendedProtection
{
 try
 {
  write-output "Configuring IIS for extended protection..." | Out-File $LogFile
  #Setting extended protection property to website
  & $WinDir\system32\inetsrv\appcmd.exe set config $WebSite -section:system.webServer/security/authentication/windowsAuthentication /extendedProtection.tokenChecking:"Allow" /extendedProtection.flags:"None" /commit:apphost | Out-File $LogFile -Append
  #Setting extended protection property to virtual directory
  & $WinDir\system32\inetsrv\appcmd.exe set config $WebSite/$Vdir -section:system.webServer/security/authentication/windowsAuthentication /extendedProtection.tokenChecking:"Allow" /extendedProtection.flags:"None" /commit:apphost | Out-File $LogFile -Append
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

ConfigureWebsite_ExtendedProtection -Website $Website -Vdir $Vdir

