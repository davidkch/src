#######################  
<#  
.SYNOPSIS  
 Generic script to create a scheduled task to deploy to an environment using an octopus file.
.DESCRIPTION  
 Generic script to create a scheduled task to deploy to an environment using an octopus file.
.EXAMPLE  
.\ScheduleOctopusRun.ps1 -AdminUserName Bill -AdminUserPass ComplexPass
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
	[string]$AdminUserName = $(throw "Pass the AdminUserName")
  , [string]$AdminUserPass = $(throw "Pass the AdminUserPass")
)

Function ScheduleOctopusRun
{
	try
	{
		Write-Host "Scheduling to Run Octopus in 2 minutes..."

		[string]$domainName = ([ADSI]'').name

		$strTime = (Get-Date).AddMinutes(2).ToString("HH:mm")
	
		$scriptsPath = "schtasks /Create /RU " + $domainName + "\"+ $AdminUserName +" /RP '" + $AdminUserPass + "' /TN RTRRTR /TR " + $octopusRunFileNameFull + " /ST " + $strTime + " /SC ONCE"
	
		iex $scriptsPath
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

ScheduleOctopusRun -AdminUserName $AdminUserName -AdminUserPass $AdminUserPass


