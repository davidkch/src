#######################  
<#  
.SYNOPSIS  
 Generic script to create a new directory.
.DESCRIPTION  
 Generic script to create a new directory.
.EXAMPLE  
.\CreateDirectory.ps1 -DirectoryName D:\Test
Version History  
v1.0   - ESIT Build Team - Initial Release  
#> 

param(
	[string]$DirectoryName = $(throw "Pass the DirectoryName")
)

$LogFile = "CreateDirectory.log"

Function CreateDirectory
{
	try
	{
		# Create new directory 
		New-Item $DirectoryName -type directory -force | Out-File $LogFile
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

CreateDirectory -DirectoryName $DirectoryName


