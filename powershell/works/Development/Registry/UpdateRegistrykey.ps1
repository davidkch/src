#######################  
<#  
.SYNOPSIS  
 Generic script to add/alter a specified registry key with a specified type.
.DESCRIPTION  
 Generic script to add/alter a specified registry key with a specified type.
.EXAMPLE 
.\UpdateRegistryKey.ps1 -Key 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion' -Name MyKeyName -Value 1 -Type Binary
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
		[String]$Key = $(throw "Pass the Key Path"), 
		[String]$Name = $(throw "Pass the Name of the Key"),
		[String]$Value = $(throw "Pass the Value to be Added"),
		[String]$Type = $(throw "Pass Key Type")
)

Function TestKeyPresence
{
	$ErrorActionPreference = "SilentlyContinue"
	Get-ItemProperty $Key $Name |Out-Null
	if($? -eq $false)
	{
		return 1
	}
		else
	{
		return 0
	}
}

Function UpdateRegistryKey
{
	try
	{
		#Different types of registry keys:  String, Binary, DWORD, QWORD, MultiString, ExpandString
		$LogFile = "UpdateRegistry.log"

		$KeyPresent=TestKeyPresence
		if($KeyPresent -eq 1) #if key itself is not present
		{
			New-ItemProperty -Path $Key -Name "$Name" -Value $Value -PropertyType $Type
			write-output "Create the key $Key$Name with value $Value" | Out-File $LogFile -Append
			write-host "Create the key $Key$Name with value $Value"
		}
		else
		{
			Set-ItemProperty -Path $Key -Name "$Name" -Value $Value
			write-output "Updated key $Key$Name successfully" | Out-File $LogFile -Append
			write-host "Updated key $Key$Name successfully"
		}
	}
	Catch [system.exception]
	{
		write-host $_.exception.message | Out-File $LogFile -Append
	}
	Finally
	{
		"Executed Successfully" | Out-File $LogFile -Append
	}

}

UpdateRegistryKey -Key $Key -Name $Name -Value $Value -Type $Type