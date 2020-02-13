#######################  
<#  
.SYNOPSIS  
 Generic script to update registry key related to encryption level
.DESCRIPTION  
 Generic script to update registry key related to encryption level
.EXAMPLE  
.\Set_TSEncryptionLevelSetting.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
$expectedEncryptionLevel = $(throw "Pass expected encryption level.")
)

Function Set_TSEncryptionLevelSetting
{
	try
	{
           Write-Output "Editing registry: Set-ItemProperty -Path `"HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp`" -Name `"MinEncryptionLevel`" -Value `"$expectedEncryptionLevel`""
           Write-Output Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "MinEncryptionLevel" -Value $expectedEncryptionLevel
    	}
	Catch [system.exception]
	{
	   write-output "ERROR: " $_.exception.message
	}
	Finally
	{
	   Write-Output "Set_TSEncryptionLevelSetting.ps1 Executed Successfully"
	}
}

Set_TSEncryptionLevelSetting -expectedEncryptionLevel $expectedEncryptionLevel