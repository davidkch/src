#######################  
<#  
.SYNOPSIS  
 Generic script to install a certificate to the local machine.
.DESCRIPTION  
 Generic script to install a certificate to the local machine.
.EXAMPLE  
.\InstallCertificate.ps1 -FILEPATH C:\MyCert.pfx -PASSWORD MyComplexPass
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
		[string]$FILEPATH = $(throw "Pass the File Path"),
		[string]$PASSWORD = $(throw "Pass the Password")
)

$LogFile = "InstallCertificate.log"

Function InstallCertificate
{
	try
	{
		"certUtil -p $PASSWORD -importPFX $FILEPATH" | Out-File $LogFile
		write-host "certUtil -p $PASSWORD -importPFX $FILEPATH"
		certUtil -p $PASSWORD -importPFX $FILEPATH
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

InstallCertificate -FILEPATH $FILEPATH -PASSWORD $PASSWORD