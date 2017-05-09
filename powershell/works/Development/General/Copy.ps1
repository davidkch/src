#######################  
<#  
.SYNOPSIS  
 Generic script to copy a file to a specified location.
.DESCRIPTION  
 Generic script to copy a file to a specified location.
.EXAMPLE  
.\Copy.ps1 -Source D:\Source\Test.txt -Destination D:\Destination\Test.txt
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
	[string]$Source = $(throw "Pass the Source")
	,[string]$Destination = $(throw "Pass the Destination")
)

$LogFile = "Copy.log"

Function Copy
{
	try
	{
		Copy-Item $Source -Recurse $Destination | Out-File $LogFile
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

Copy -Source $Source -Destination $Destination