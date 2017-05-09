#######################  
<#  
.SYNOPSIS  
 Generic script to copy file/folder to a destination.
.DESCRIPTION  
 Generic script to copy file/folder to a destination.
.EXAMPLE  
FOLDERS:
.\RoboCopy.ps1 -Source "D:\Source" -Destination "D:\Destination"
FILES:
.\RoboCopy.ps1 -Source "D:\Source" -Destination "D:\Destination" -Files "*.*"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
	[string]$Source = $(throw "Pass the Source")
   ,[string]$Destination = $(throw "Pass the Destination")
   ,[string]$Files = ""
)

$LogFile = "RoboCopy.log"

Function RoboCopy
{
	try
	{
		$RESOURCESPATH = "$Source"
		$TARGETDIR = "$Destination"

        if(($Files -eq $null) -or ($Files.Trim() -eq ""))
        {
            $robocmd = "RoboCopy.exe `"$RESOURCESPATH`" `"$TARGETDIR`" /E"
        }
        else
        {
		    $robocmd = "RoboCopy.exe `"$RESOURCESPATH`" `"$TARGETDIR`" `"$Files`""
        }

        write-output "RESOURCEPATH: $RESOURCESPATH" | Out-File $LogFile
        write-output "TARGETDIR: $TARGETDIR" | Out-File $LogFile -Append
		Invoke-Expression -command $robocmd | Out-File $LogFile -Append
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

RoboCopy -Source $Source -Destination $Destination -Files $Files

