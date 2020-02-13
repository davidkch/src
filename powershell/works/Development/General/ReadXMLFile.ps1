#######################  
<#  
.SYNOPSIS  
 Generic script to place text contents of file into a local powreshell object.
.DESCRIPTION  
 Generic script to place text contents of file into a local powreshell object.
.EXAMPLE  
.\ReadXMLFile.ps1 -Path D:\Folder -FileName MyFile.txt
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
	[string]$Path = $(throw "Pass the Path")
   ,[string]$FileName = $(throw "Pass the FileName")
)

Function ReadXMLFile
{	
	try
	{
		[xml] $list = Get-Content "$Path\$FileName"
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

ReadXMLFile -Path $Path -FileName $FileName
