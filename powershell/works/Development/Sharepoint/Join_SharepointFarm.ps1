<#
.SYNOPSIS
Generic script to Join the sharepoint farm.
.DESCRIPTION
Generic script to Join the farm n the sharepoint site.
.EXAMPLE
.\Join_SharepointFarm.ps1 -DatabaseServerName $DBServer -ConfigDatabaseName $DBName

Version History
v1.0 - balas - Initial Release
#>

[CmdletBinding()]
param (
		[string]$DBServerName = $(throw,"Enter the database server name"),
		[string]$DBName = $(throw,"Enter the configuration database name"),
		[string]$Passphrase = $(throw,"Enter value for Passphrase")
	  )

$LogFIle="Join_SharepointFarm.log"

Function Join_SharepointFarm
{
	try
	{
		$ScriptDir = Get-Location -PSProvider FileSystem		
		$ModuleTargetDir = "$env:windir\System32\WindowsPowerShell\v1.0\Modules"
		$ModuleSourceDir = $ScriptDir.Path + "\SPModule\SPModule.misc"
		Write-Host "Copying SPModule.misc files from $ModuleSourceDir to $ModuleTargetDir" | Out-File $LogFIle -Append 
		# Copy the SPModule.misc folder to the powershell modules folder.
		Copy-Item $ModuleSourceDir $ModuleTargetDir -recurse -force

		$ModuleSourceDir = $ScriptDir.Path + "\SPModule\SPModule.setup"
		Write-Host "Copying SPModule.setup files from $ModuleSourceDir to $ModuleTargetDir" | Out-File $LogFIle -Append
		# Copy the SPModule.setup folder to the powershell modules folder.
		Copy-Item $ModuleSourceDir $ModuleTargetDir -recurse -force
		Import-Module SPModule.misc
		Import-Module SPModule.setup

		$FarmPassphrase = (ConvertTo-SecureString $Passphrase -AsPlainText -force) 

		#call the sub-function
		Join-SharePointFarm -DatabaseServer $DBServerName -ConfigurationDatabaseName $DBName -Passphrase $FarmPassphrase | Out-File $LogFIle -Append

	}
	Catch [System.Exception]
	{
		Write-Host $_.Exception.message
		Write-Output $_.Exception.message | Out-File $LogFIle -Append
	}
	Finally
	{
		Write-Host "Farm has been joined to the sharepoint site!"
		Write-Output "Farm has been joined to the sharepoint site!" | Out-File $LogFIle -Append
	}
}

#call the function

Join_SharepointFarm -DBServerName $DBServerName -DBName $DBName








