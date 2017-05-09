#######################  
<#  
.SYNOPSIS  
 Generic script to check if server is accessible.
.DESCRIPTION  
 Generic script to check if server is accessible by checking existance of drive path.
.EXAMPLE  
.\CheckDBServerAccess.ps1 -TargetServerName MyServerName -Drive D:\
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
	[string]$TargetServerName = $(throw "Pass the DatabaseName")
   ,[string]$Drive =  $(throw "Pass the Drive")
)

Function CheckDBServerAccess
{
	try
	{
		write-host "Checking if server is reachable..."
		$serverPath = "\\" + $TargetServerName + "\$Drive$"
 
		for ($i=1; $i -le 100; $i++)
		{
			if ($i -eq 99)
			{
				$errorMessage = "Server is not accessible: $targetServerName" 
				throw $errorMessage
			}
		
			Write-Host "Attempt  $i to connect to the server $targetServerName"
		
			if ([System.IO.Directory]::Exists($serverPath)) 
			{
				write-host "Server $targetServerName is validated: OK. "
				return
			}

			write-host "Server is not accessible. Wait (60 sec) for next try..."
			TIMEOUT 60
		}
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

CheckDBServerAccess -TargetServerName $TargetServerName -Drive $Drive
