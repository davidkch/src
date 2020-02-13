#######################  
<#  
.SYNOPSIS  
Generic script to set the property ManagedRuntimeVersion of the specified app pool.
.DESCRIPTION  
Sets a value that indicates the pipeline mode of managed applications in the current application pool. 
.EXAMPLE  
.\ConfigureAppPool_IdentityType.ps1 -APPPOOL MyAppPoolName -IdentityType NetworkService
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
    [string]$APPPOOL= $(throw "Please pass the App Pool name."),
    [string]$IdentityType = $(throw "Please pass process model Identity Type.")
)

$LogFile = "ConfigureAppPool_IdentityType.log"
$WinDir = $env:windir

Function ConfigureAppPool_IdentityType
{
    try
    {       
        "Setting app pool `"$APPPOOL`" Identity Type property to NetworkService..." | Out-File $LogFile
        write-output "$windir\system32\inetsrv\appcmd.exe set config /section:applicationPools /[Name='$APPPOOL'].processModel.identityType:$IdentityType" | Out-File $LogFile -Append
        write-host "$windir\system32\inetsrv\appcmd.exe set config /section:applicationPools /[Name='$APPPOOL'].processModel.identityType:$IdentityType"
        & $WinDir\system32\inetsrv\appcmd.exe set config /section:applicationPools /[Name='$APPPOOL'].processModel.identityType:$IdentityType | Out-File $LogFile -Append
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

ConfigureAppPool_IdentityType -APPPOOL $APPPOOL -IdentityType $IdentityType