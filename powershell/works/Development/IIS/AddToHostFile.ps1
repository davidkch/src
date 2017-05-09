#######################  
<#  
.SYNOPSIS  
Appends an IP address and server name to the system hosts file
.DESCRIPTION  
Appends an IP address and server name to the system hosts file
.EXAMPLE  
.\AddToHostFile.ps1 -HostFilePath "C:\Windows\System32\drivers\etc" -HostFileName Hosts -IPAddress 127.0.0.1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
		[String]$HostFilePath = $(throw "Pass the HostFileName - Provide full path of this file (C:\Windows\System32\drivers\etc)")
	   ,[String]$HostFileName = $(throw "Pass the HostFileName - (Hosts)")
	   ,[String]$IPAddress = $(throw "Pass the IPAddress")
       ,[string]$MappingServerName = $(throw "Pass the MappingServerName")
)

$LogFile = "AddToHostFile.log"

Function AddToHostFile
{
	try
	{
		write-output "Adding IP address: $IPAddress" | Out-File $LogFile -Append
        write-output "File: $HostFileName" | Out-File $LogFile -Append
        Add-Content $HostFilePath\$HostFileName "$IPAddress $MappingServerName"
	}
	Catch [system.exception]
	{
		write-output $_.exception.message | Out-File $LogFile -Append
		write-host $_.exception.message
	}
	Finally
	{
		"Executed Successfully!" | Out-File $LogFile -Append
	}
}

AddToHostFile -HostFilePath $HostFilePath -HostFileName $HostFileName -IPAddress $IPAddress -MappingServerName $MappingServerName

