#######################  
<#  
.SYNOPSIS  
 Generic script to place quotes around a string provided by user.
.DESCRIPTION  
 Generic script to place quotes around a string provided by user.
.EXAMPLE  
.\AppendQuotes.ps1 -StringValue "Hello World!"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
	[string]$StringValue = $(throw "Pass the StringValue")
)

Function AppendQuotes
{
	try
	{
		$StringValueOut = '`"' + '$StringValue' + '`"'
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

AppendQuotes -StringValue $StringValue




