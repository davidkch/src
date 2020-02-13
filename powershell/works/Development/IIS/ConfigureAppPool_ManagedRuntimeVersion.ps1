#######################  
<#  
.SYNOPSIS  
Generic script to set the property ManagedRuntimeVersion of the specified app pool.
.DESCRIPTION  
 This property is the version number of the .NET Framework that is used by the application pool.
.EXAMPLE  
.\ConfigureAppPool_WindowsAuthentication.ps1 -APPPOOL MyAppPoolName -ManagedRuntimeVersion v4.0
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
    $APPPOOL= $(throw "Please pass the App Pool name."),
    $ManagedRuntimeVersion = $(throw "Please pass Managed Runtime Version.")
)

$LogFile = "ConfigureAppPool_ManagedRuntimeVersion.log"
$WinDir = $env:windir
    
Function ConfigureAppPool_ManagedRuntimeVersion
{
    try
    {
        "Setting app pool `"$APPPOOL`" Managed Runtime Version property to 4.0..." | Out-File $LogFile
        write-output "$windir\system32\inetsrv\appcmd.exe set apppool /apppool.name:$APPPOOL /managedRuntimeVersion:$ManagedRuntimeVersion" | Out-File $LogFile -Append
        write-host "$windir\system32\inetsrv\appcmd.exe set apppool /apppool.name:$APPPOOL /managedRuntimeVersion:$ManagedRuntimeVersion"
        & $WinDir\system32\inetsrv\appcmd.exe set apppool /apppool.name:$APPPOOL /managedRuntimeVersion:$ManagedRuntimeVersion  #v4.0
        "Configured successfully!" | Out-File $LogFile -Append
    }
	Catch [system.exception]
	{
		write-output $_.exception.message  Out-File $LogFile -Append
		write-host $_.exception.message
	}
    Finally
    {
        "Completed Successfully!" | Out-File $LogFile -Append
    }
}

ConfigureAppPool_ManagedRuntimeVersion -APPPOOL $APPPOOL -ManagedRuntimeVersion $ManagedRuntimeVersion