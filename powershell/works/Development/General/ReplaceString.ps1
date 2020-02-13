#######################  
<#  
.SYNOPSIS  
 Generic script to replace a specific value within a string.
.DESCRIPTION  
 Generic script to replace a specific value within a string.
.EXAMPLE  
.\ReplaceString.ps1 -File "C:\MyFile.txt" -OldValue placeholder  -NewValue string
-OR-
If replacing variables in a file such as $(var) is required, enter the value like this:
.\ReplaceString.ps1 -File "C:\MyFile.txt" -OldValue "\$\(string\)" -NewValue "replace"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
	[string]$File = $(throw "Pass the File, including path")
   ,[string]$OldValue = $(throw "Pass the OldValue")
   ,[string]$NewValue = $(throw "Pass the NewValue")
)

Function ReplaceString
{
	try
	{
		$content=Get-Content -path $File
		$content=$content -replace $OldValue, $NewValue > $File;
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

ReplaceString -File $File -OldValue $OldValue -NewValue $NewValue