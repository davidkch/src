#######################  
<#  
.SYNOPSIS  
 Generic script to set windows authentication extended protection for the specified website.
.DESCRIPTION  
 This property is the version number of the .NET Framework that is used by the application pool.
.EXAMPLE  
.\ConfigureWebsite_Authentication.ps1 -Website MyWebsiteName
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
    $Website = $(throw "Please pass name of website.")
)

$LogFile = "ConfigureWebsite_Authentication.log"
$WinDir = $env:windir

Function ConfigureWebsite_Authentication
{
    try
    {       
        "Configuring windows authentication for website '$Website'..." | Out-File $LogFile
        write-output "$windir\system32\inetsrv\appcmd.exe set config $Website -section:system.webServer/security/authentication/windowsAuthentication /extendedProtection.tokenChecking:`"Allow`" /extendedProtection.flags:`"None`" /commit:apphost" | Out-File $LogFile -Append
        write-host "$windir\system32\inetsrv\appcmd.exe set config $WebSite -section:system.webServer/security/authentication/windowsAuthentication /extendedProtection.tokenChecking:`"Allow`" /extendedProtection.flags:`"None`" /commit:apphost"
        & $WinDir\system32\inetsrv\appcmd.exe set config $WebSite -section:system.webServer/security/authentication/windowsAuthentication /extendedProtection.tokenChecking:"Allow" /extendedProtection.flags:"None" /commit:apphost | Out-File $LogFile -Append
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

ConfigureWebsite_Authentication -Website $Website