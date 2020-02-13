#######################  
<#  
.SYNOPSIS  
 Generic script to restart the specified applicatin pool.
.DESCRIPTION  
 Generic script to restart the specified applicatin pool.
.EXAMPLE  
.\RestartIISAppPool.ps1 -IISPoolList "MyAppPool1,MyAppPool2"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
	[string[]]$IISPoolList = $(throw "Pass the IISPoolList as common saparated if more than one pool to be set")
)

$LogFile = "RestartIISAppPool.log"

Function RestartIISAppPool
{
	try
	{
		$IISBox = "$env:computername"
		$s = new-pssession -computer $IISBox

		"IISPoolList = $IISPoolList" | Out-File $LogFile

		"Importing Module WebAdministration..." | Out-File $LogFile -Append
		invoke-command $s {Import-Module WebAdministration}

		foreach ($elem in $IISPoolList)
		{
			invoke-command $s {Restart-WebItem iis:\apppools\$elem} | Out-File $LogFile -Append
		}
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

RestartIISAppPool -IISPoolList $IISPoolList
