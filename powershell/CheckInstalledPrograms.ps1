<#  
.SYNOPSIS  
 Generic script to check the installed programs on a machine.

.DESCRIPTION  
 Generic script to check the installed programs on a machine.

.EXAMPLE  
.\CheckInstalledPrograms.ps1 <computername>

Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
	[string] $computer = $(throw "Pass the computername")
)

Function CheckInstalledPrograms
{
	$credential = Get-Credential

	try
	{
		## Check if machine is reachable
		$machinePath = "\\" + $computer + "\C$"
		
		if (![System.IO.Directory]::Exists($machinePath)) 
		{
			$errorMessage = "Machine is not accessible: $computer" 
			throw $errorMessage
		}

	}
	Catch [system.exception]
	{
		write-host $_.exception.message
	}
	Invoke-Command -ComputerName $computer -Credential $credential -ScriptBlock { "","\WOW6432Node"|%{gci "HKLM:\SOFTWARE$_\Microsoft\Windows\CurrentVersion\Uninstall"}|gp|?{$_.DisplayName.Length -gt 0}|sort -Prop DisplayName -Uniq|ft -Prop DisplayName,Publisher,DisplayVersion  -Autosize}
}

CheckInstalledPrograms $computer