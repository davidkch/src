#######################  
<#  
.SYNOPSIS  
 Generic script to kill a specified process with a specific name.
.DESCRIPTION  
 Generic script to kill a specified process with a specific name.
.EXAMPLE  
.\KillProcess.ps1 -ProcessName MyProcess
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    $ProcessName = $(throw "Please pass process name.")
)

$LogFile = "KillProcess.log"

Function KillProcess
{
    try
    {    
        write-output "powershell -Version 2.0 -NoProfile -NonInteractive -InputFormat None -ExecutionPolicy Bypass -Command `"(Get-Process $ProcessName).kill()`"" | Out-File $LogFile
        write-host "powershell -Version 2.0 -NoProfile -NonInteractive -InputFormat None -ExecutionPolicy Bypass -Command `"(Get-Process $ProcessName).kill()`""
        (Get-Process $ProcessName).kill()
    }
	Catch [system.exception]
	{
		write-output $_.exception.message | Out-File $LogFile -Append
		write-host $_.exception.message
	}
    Finally
    {
        "Completed Successfully!" | Out-File $LogFile -Append
    }
}

KillProcess -ProcessName $ProcessName