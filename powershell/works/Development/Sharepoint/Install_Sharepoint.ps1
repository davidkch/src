<#
.SYNOPSIS
Generic script to install sharepoint 2010 installation.
.DESCRIPTION
Generic script to install the sharepoint 2010 installation.
.EXAMPLE
.\Install_Sharepoint.ps1 -ProductKey $ProductKey -SetupFolderPath $SetupFolderPath

Version History
v1.0 - balas - Initial Release
#>

param (
		[string]$ProductKey = $(throw,"Enter the product key"),
		[string]$SetupFolderPath = $(throw,"Enter the setup files folder path including the setup.exe")
	  )
$LogFile="Install_Sharepoint.log"

Function Install_Sharepoint
{
	try
	{
		$ProductKey=$ProductKey.trim()
		$scriptDir = Get-Location -PSProvider FileSystem
		$moduleTargetDir = "$env:windir\System32\WindowsPowerShell\v1.0\Modules"
		$moduleSourceDir = $scriptDir.Path + "\SPModule\SPModule.misc"

		Write-Host "Copying SPModule.misc from $moduleSourceDir to $moduleTargetDir" | Out-File $LogFIle -Append
		# Copy the SPModule.misc folder to the powershell modules folder.
		Copy-Item $moduleSourceDir $moduleTargetDir -recurse -force

		$moduleSourceDir = $scriptDir.Path + "\SPModule\SPModule.setup"
		Write-Host "Copying SPModule.setup from $moduleSourceDir to $moduleTargetDir" | Out-File $LogFIle -Append
		# Copy the SPModule.setup folder to the powershell modules folder.
		Copy-Item $moduleSourceDir $moduleTargetDir -recurse -force

		Import-Module SPModule.misc
		Import-Module SPModule.setup

		#$sharepointscriptDir = $scriptDir.Path +"\SharePoint_Server_2010_SP1\setup.exe"
		Install-SharePoint -SetupExePath $SetupFolderPath -PIDKey $ProductKey

	}
	catch [System.Exception]
	{
		Write-Host $_.Exception.message
		Write-Output $_.Exception.message | Out-File $LogFile -Append
	}
	Finally
	{
		Write-Host "Sharepoint installation successfully completed!"
		Write-Output "Sharepoint installation successfully completed!" | Out-File $LogFile -Append
	}
}

#call the function

Install_Sharepoint -ProductKey $ProductKey -SetupFolderPath $SetupFolderPath











