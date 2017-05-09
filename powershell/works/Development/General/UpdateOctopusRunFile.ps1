#######################  
<#  
.SYNOPSIS  
 Generic script to replace a given string with a given string value.
.DESCRIPTION  
 Generic script to replace a given string with a given string value.  Run.cmd file is what is updated.
.EXAMPLE  
.\UpdateOctopusRunFile.ps1 -ReplaceStringKey  $ReplaceStringKey  -ReplaceStringValue  $ReplaceStringValue
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
	[string]$ReplaceStringKey = $(throw "Pass the ReplaceStringKey")
  , [string]$ReplaceStringValue = $(throw "Pass the ReplaceStringValue")
)

Function UpdateOctopusRunFile
{
	try
	{
		$octopusRunFileNameFull = $installDir.tostring() + "\run.cmd" 

		$string1 = $ReplaceStringKey

		$string2 = $ReplaceStringValue

		# to support a special characters in the password we need to use $_.replace

		(Get-Content $octopusRunFileNameFull) | Foreach-Object {$_.replace($string1, $string2)} | Set-Content $octopusRunFileNameFull	
	}
	Catch [system.exception]
	{
		write-host $_.exception.message
	}
	Finally
	{
		"Executed Successfully"
	}
)

UpdateOctopusRunFile -ReplaceStringKey  $ReplaceStringKey  -ReplaceStringValue  $ReplaceStringValue


