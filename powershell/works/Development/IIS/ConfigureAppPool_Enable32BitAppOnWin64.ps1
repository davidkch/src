#######################  
<#  
.SYNOPSIS  
Alters the "enable32BitAppOnWin64" property for the specified application pool
.DESCRIPTION  
The Enable32BitAppOnWin64 property indicates whether IIS creates 32-bit worker processes or 64-bit worker processes on 64-bit Windows. 
This property is only relevant on 64-bit Windows with IIS running in Worker Process Isolation mode. 
.EXAMPLE  
.\ConfigureAppPool_Enable32BitAppOnWin64.ps1 -APPPOOL MyAppPoolName -Enable32BitAppOnWin64 true
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
    $APPPOOL= $(throw "Please pass the App Pool name."),
    $Enable32BitAppOnWin64 = $(throw "Please pass true/false to enable/disable 32-bit mode on 64-bit system")
)

$LogFile = "ConfigureAppPool_Enable32BitAppOnWin64.log"
$WinDir = $env:windir

Function ConfigureAppPool_Enable32BitAppOnWin64
{
    try
    {
        "Setting app pool `"$APPPOOL`" Enable32BitAppOnWin64 property to $Enable32BitAppOnWin64..." | Out-File $LogFile
        write-output "$windir\system32\inetsrv\appcmd.exe set apppool /apppool.name:$APPPOOL /enable32BitAppOnWin64:$Enable32BitAppOnWin64" | Out-File $LogFile -Append
        write-host "$windir\system32\inetsrv\appcmd.exe set apppool /apppool.name:$APPPOOL /enable32BitAppOnWin64:$Enable32BitAppOnWin64"
        & $WinDir\system32\inetsrv\appcmd.exe set apppool /apppool.name:$APPPOOL /enable32BitAppOnWin64:$Enable32BitAppOnWin64  | Out-File $LogFile -Append
        "Configured successfully!" | Out-File $LogFile -Append
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

ConfigureAppPool_Enable32BitAppOnWin64 -APPPOOL $APPPOOL -Enable32BitAppOnWin64 $Enable32BitAppOnWin64