#######################  
<#  
.SYNOPSIS  
 Generic script to get current directory where this script exists.
.DESCRIPTION  
 Generic script to get current directory where this script exists.
.EXAMPLE  
.\GetCurrentDirectory.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#> 

$LogFile = "GetCurrentDirectory.ps1"

Function GetCurrentDirectory
{
	try
	{
        $currentDir = Get-Location | Out-File $LogFile
	}
	Catch [system.exception]
	{
		write-host $_.exception.message
	}
	Finally
	{
		"Executed Successfully"
	}
}

GetCurrentDirectory

