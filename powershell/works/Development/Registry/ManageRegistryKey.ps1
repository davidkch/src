#######################  
<#  
.SYNOPSIS  
 Generic script to create a specified registry key.
.DESCRIPTION  
 Generic script to create a specified registry key.
.EXAMPLE  
.\ManageRegistryKey.ps1 -Source 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion' -RegistryKey MyKeyName -KeyValue Value1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
    [string]$Source = $(throw "Pass the Source")
  , [string]$RegistryKey = $(throw "Pass the RegistryKey")
  , [string]$KeyValue = $(throw "Pass the KeyValue")
)

$LogFile="ManageRegistryKey.log"

Function ManageRegistryKey
{
	try
	{
	   "Creating '$RegistryKey' registry key with keyvalue '$KeyValue'." | Out-File $LogFile -Append
		New-Item -Path $Source\$RegistryKey -Value "$KeyValue" | Out-File $LogFile -Append
	   "Registry key '$RegistryKey' successfully created" | Out-File $LogFile -Append
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

ManageRegistryKey -Source $Source -RegistryKey $RegistryKey -KeyValue $KeyValue