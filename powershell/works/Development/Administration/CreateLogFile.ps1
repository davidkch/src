#######################  
<#  
.SYNOPSIS  
 Generic script to create a new log file.
.DESCRIPTION  
 Generic script to create a new log file.
.EXAMPLE  
.\CreateLogFile.ps1 -LogFileName MyLog.log
-OR-
.\CreateLogFile.ps1 -LogFileName C:\MyLog.log
Version History  
v1.0   - ESIT Build Team - Initial Release  
#> 

param(
	    [string]$LogFileName = $(throw "Pass the LogFileName")
	 )

Function CreateLogFile
{
	try
	{
        $currentDir = Get-Location
 
		if(-not $LogFileName.Contains("\"))
		{
			 $LogFileName = "$currentDir\\$LogFileName"
		} 

		#New-Item -Path $LogFileName -Force -Type File  -ErrorAction "Stop"
        write-host $currentDir
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

CreateLogFile -LogFileName $LogFileName

