#######################  
<#  
.SYNOPSIS  
 Generic script to add/remove permissions to specified a folder.
.DESCRIPTION  
 Generic script to add/remove permissions to specified a folder.
.EXAMPLE  
.\ManageFolderPermission -Function Grant -TargetDir_Path D:\MyFolder -TargetAccount BGCOEBLD -Permissions F
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
	  [String]$Function = $(throw "Pass the Function"),
	  [String]$TargetDir_Path = $(throw "Pass the Target Directory Path"),
	  [String]$TargetAccount = $(throw "Pass the Target Account"),
	  [String]$Permissions
)

$LogFile="ManageFolderPermission.log"

Function ManageFolderPermission
{
	try
	{
		switch($Function)
		{
			"Remove"
			{
				write-output "icacls.exe $TargetDir_Path /inheritance:d /remove:g $TargetAccount" | Out-File $LogFile
				icacls.exe $TargetDir_Path /inheritance:d /remove:g $TargetAccount
			}
			"Grant"
			{
				if(!$Permissions -eq "")
				{
					write-output "icacls.exe $TargetDir_Path /inheritance:d /grant $TargetAccount`:$Permissions" | Out-File $LogFile
					icacls.exe "$TargetDir_Path" /inheritance:d /grant $TargetAccount`:$Permissions
				}
				else
				{
					write-output "Please provide permissions parameter." | Out-File $LogFile
					write-host "Please provide permissions parameter." 
				}
			}
			"Deny"
			{
				if(!$Permissions -eq "")
				{
					write-output "icacls.exe $TargetDir_Path /inheritance:d /deny $TargetAccount`:$Permissions" | Out-File $LogFile
					icacls.exe "$TargetDir_Path" /inheritance:d /deny $TargetAccount`:$Permissions
				}
				else
				{
					write-output "Please provide permissions parameter." | Out-File $LogFile
					write-host "Please provide permissions parameter."
				}
			}
			default{
				throw "Please provide proper Function parameter:  Grant, Remove, or Deny" | Out-File $LogFile
			}
		}
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

ManageFolderPermission -Function $Function -TargetDir_Path $TargetDir_Path -TargetAccount $TargetAccount -Permissions $Permissions