#######################  
<#  
.SYNOPSIS  
 Generic script to update registry key related to idle user settings
.DESCRIPTION  
 Generic script to update registry key related to idle user settings
.EXAMPLE  
.\Set_TSIdleUserSetting.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
$expectedfInheritMaxIdleTime = $(throw "Pass expectedfInheritMaxIdleTime."),
$expectedMaxIdleTime = $(throw "Pass expectedMaxIdleTime."),
$fInheritMaxIdleTime = $(throw "Pass fInheritMaxIdleTime."),
$maxIdleTime = $(throw "Pass maxIdleTime.")
)

Function Set_TSIdleUserSetting
{
	try
	{
        Write-Output "Editing registry: Path=HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp Name=fInheritMaxIdleTime Value=$expectedfInheritMaxIdleTime"
        Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "fInheritMaxIdleTime" -Value $expectedfInheritMaxIdleTime

        Write-Output "Editing registry: Path=HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp Name=MaxIdleTime Value=$expectedMaxIdleTime"
        Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "MaxIdleTime" -Value $expectedMaxIdleTime
    }
	Catch [system.exception]
	{
		write-output "ERROR: " $_.exception.message
	}
	Finally
	{
		Write-Output "Set_TSIdleUserSetting.ps1 Executed Successfully"
	}
}

Set_TSIdleUserSetting -expectedEncryptionLevel $expectedEncryptionLevel -expectedMaxIdleTime $expectedMaxIdleTime -fInheritMaxIdleTime $fInheritMaxIdleTime -maxIdleTime $maxIdleTime