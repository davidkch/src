#######################  
<#  
.SYNOPSIS  
 Generic script to execute a specified executable.
.DESCRIPTION  
 Generic script to execute a specified executable.
.EXAMPLE  
.\ExecuteCustomCommand.ps1 -ExePath "D:\Folder\MyExecutable.exe"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param([string]$ExePath = $(throw "Pass the Exe path and name"))

Function ExecuteCustomCommand
{
	$LogFile = "RunExecutable.log"
	try
	{
		"Executing file:  $ExePath" | Out-File $LogFile
		& "$ExePath"
		"Finished executing file:  $ExePath" | Out-File $LogFile -Append
	}
	Catch [system.exception]
	{
		write-output $_.exception.message | Out-File $LogFile -Append
		write-host $_.exception.message
	}
	Finally
	{
		"Executed Successfully" | Out-File $LogFile -Append
	}
}

ExecuteCustomCommand -ExePath $ExePath