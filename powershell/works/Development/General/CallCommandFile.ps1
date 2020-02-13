#######################  
<#  
.SYNOPSIS  
 Generic script to execute a command from command line.
.DESCRIPTION  
 Generic script to execute a command from command line.
.EXAMPLE  
.\CallCommandFile.ps1 -CommandString "ECHO TESTING"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
	[string]$CommandString = $(throw "Pass the CommandString with required parameters list ")
)

$LogFile = "CallCommandFile.log"

Function CallCommandFile
{
	try
	{
		cmd.exe /c $CommandString | Out-File $LogFile
	}
	Catch [system.exception]
	{
        write-output $_.exception.message | Out-File $LogFile -Append
		write-host $_.exception.message
	}
	Finally
	{
		"Executed Successfully"
	}
}

CallCommandFile -CommandString $CommandString

