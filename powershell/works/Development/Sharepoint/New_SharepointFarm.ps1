<#
.SYNOPSIS
Generic script to create new sharepoint farm.
.DESCRIPTION
Generic script to create new sharepoint farm.
.EXAMPLE
.\New_SharepointFarm.ps1 -DBAccountName $DBAccountName -DatabaseServerName $DBServer -FarmName $FarmName

Version History
v1.0 - balas - Initial Release
#>

Param(
		[string]$DBAccountName = $(throw,"Enter the database account name"),
		[string]$DBServerName = $(throw,"Enter the database server name"),
		[string]$FarmName = $(throw,"Enter the sharepoint site farm name"),
		[string]$DBAccountPassword = $(throw,"Enter password for database account")
     )

$LogFIle="New_SharepointFarm.log"

Function New_SharepointFarm
{

	try
	{
		$ScriptDir = Get-Location -PSProvider FileSystem
		$ModuleTargetDir = "$env:windir\System32\WindowsPowerShell\v1.0\Modules"
		$ModuleSourceDir = $ScriptDir.Path + "\SPModule\SPModule.misc"
		
		Write-Host "Copying SPModule.misc from $ModuleSourceDir to $ModuleTargetDir" | Out-File $LogFIle -Append 
		# Copy the SPModule.misc folder to the powershell modules folder.
		Copy-Item $ModuleSourceDir $ModuleTargetDir -recurse -force

		$ModuleSourceDir = $ScriptDir.Path + "\SPModule\SPModule.setup"
		Write-Host "Copying SPModule.setup from $ModuleSourceDir to $ModuleTargetDir" | Out-File $LogFIle -Append 
		# Copy the SPModule.setup folder to the powershell modules folder.
		Copy-Item $ModuleSourceDir $ModuleTargetDir -recurse -force

		Import-Module SPModule.misc
		Import-Module SPModule.setup

		$secpasswd = ConvertTo-SecureString "$DBAccountPassword" -AsPlainText -Force
        $mycreds = New-Object System.Management.Automation.PSCredential ("$DBAccountName", $secpasswd)
		
		New-SharePointFarm –DatabaseAccessAccount $mycreds –DatabaseServer $DBServerName –FarmName $FarmName | Out-File $LogFIle -Append

	}
	Catch [System.Exception]
	{
		Write-Host $_.Exception.message
		Write-Output $_.Exception.message | Out-File $LogFIle -Append
	}
	Finally
	{
		Write-Host "New Farm has been created to the sharepoint site!"
		Write-Output "New Farm has been created to the sharepoint site!" | Out-File $LogFIle -Append
	}
}

#call the function

New_SharepointFarm -DBAccountName $DBAccountName -DBServerName $DBServerName -FarmName $FarmName








