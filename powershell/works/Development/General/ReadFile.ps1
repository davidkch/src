#######################  
<#  
.SYNOPSIS  
 Generic script to place contents of text file into a local powreshell variable.
.DESCRIPTION  
 Generic script to place contents of text file into a local powreshell variable.
.EXAMPLE  
.\ReadFile.ps1 -Path D:\Folder -FileName MyFile.txt
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
	[string]$Path = $(throw "Pass the Path")
   ,[string]$FileName = $(throw "Pass the FileName")
)

Function ReadFile
{
	try
	{
		$FileContent = Get-Content $Path\$FileName
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

ReadFile -Path $Path -FileName $FileName

