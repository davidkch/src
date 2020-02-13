#######################  
<#  
.SYNOPSIS  
Generic script to set the property managedPipelineMode of the specified app pool.
.DESCRIPTION  
 Sets a value that indicates the pipeline mode of managed applications in the current application pool.
.EXAMPLE  
.\ConfigureAppPool_WindowsAuthentication.ps1 -APPPOOL MyAppPoolName -ManagedPipelineMode Integrated
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
    [string]$APPPOOL= $(throw "Please pass the App Pool name."),
    [string]$ManagedPipelineMode = $(throw "Please pass Managed Pipeline Mode.")
)

$LogFile = "ConfigureAppPool_ManagedPipelineMode.log"
$WinDir = $env:windir

Function ConfigureAppPool_ManagedPipelineMode
{
    try
    {
        "Setting app pool `"$APPPOOL`" Managed Pipeline Mode property to Integrated..." | Out-File $LogFile
        write-output "$windir\system32\inetsrv\appcmd.exe set config /section:applicationpools /[Name='$APPPOOL'].managedPipelineMode:$ManagedPipelineMode" | Out-File $LogFile -Append
        write-host "$windir\system32\inetsrv\appcmd.exe set config /section:applicationpools /[Name='$APPPOOL'].managedPipelineMode:$ManagedPipelineMode"
        & $WinDir\system32\inetsrv\appcmd.exe set config /section:applicationpools /[Name='$APPPOOL'].managedPipelineMode:$ManagedPipelineMode | Out-File $LogFile -Append
    }
	Catch [system.exception]
	{
		write-output $_.exception.message | Out-File $LogFile -Append
		write-host $_.exception.message
	}
    Finally
    {
        "Completed Successfully!" 
    }
}

ConfigureAppPool_ManagedPipelineMode -APPPOOL $APPPOOL -ManagedPipelineMode $ManagedPipelineMode