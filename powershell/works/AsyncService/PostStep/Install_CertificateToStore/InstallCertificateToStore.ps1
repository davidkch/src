#######################  
<#  
.SYNOPSIS  
 Generic script to add a certificate to a specified store
.DESCRIPTION  
 Generic script to add a certificate to a specified store
.EXAMPLE  
.\InstallCertificateToStore.ps1 -FILEPATH C:\MyCert.cer -STORENAME Name
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
		[string]$FILEPATH = $(throw "Pass the File Path"),
		[string]$STORENAME = $(throw "Pass the Store Name")
)

$LogFile = "InstallCertificateToStore.log"

Function InstallCertificateToStore
{
	try
	{
		write-output "certUtil -p $PASSWORD -importPFX $FILEPATH" | Out-File $LogFile -Append
		write-host "certUtil -addstore `"$STORENAME`" `"$FILEPATH`""
		certUtil -addstore "$STORENAME" "$FILEPATH"
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

InstallCertificateToStore -FILEPATH $FILEPATH -StoreName $StoreName