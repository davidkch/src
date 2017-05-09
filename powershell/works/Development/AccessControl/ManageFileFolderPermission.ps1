#######################  
<#  
.SYNOPSIS  
 Generic script to add/remove permissions to specified a folder.
.DESCRIPTION  
 Generic script to add/remove permissions to specified a folder.
.EXAMPLE  
.\ManageFileFolderPermission.ps1 -Function "Grant" -TargetItem "C:\MyFolder" -InheritenceLevel "d" -TargetAccount "BGCOEBLD" -Permissions '(OI)(CI)(WD,AD,WA,WEA)'
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
	  [String]$Function = $(throw "Pass the Function"),
	  [String]$TargetItem = $(throw "Pass the Target File/Directory, with fully qualified path"),
      [String]$InheritenceLevel = $(throw "Pass the inheritence level."),
	  [String]$TargetAccount = $(throw "Pass the Target Account"),
	  [String]$Permissions
)

$LogFile="ManageFileFolderPermission.log"

Function ManageFileFolderPermission
{
	try
	{
        $Command = "icacls $TargetItem /inheritance:$InheritenceLevel "

		switch($Function)
		{
			"Remove"
			{
				$Command += "/remove:g $TargetAccount"
			}
			"Grant"
			{
				if(!$Permissions -eq "")
				{
					$Command += "/grant '$TargetAccount`:$Permissions'"
				}
				else
				{
					write-output "Please provide permissions parameter." | Out-File $LogFile
                    exit -1
				}
			}
			"Deny"
			{
				if(!$Permissions -eq "")
				{
					$Command +=  "/deny '$TargetAccount`:$Permissions'"
				}
				else
				{
					write-output "Please provide permissions parameter." | Out-File $LogFile
					exit -1
				}
			}
			default{
				throw "Please provide proper Function parameter:  Grant, Remove, or Deny" | Out-File $LogFile
			}
		}

        write-output "$Command" | Out-File $LogFile
		Invoke-Expression $Command
	}
	Catch [system.exception]
	{
		#write-output $Error | Out-File $LogFile -Append
        write-host $Error | Out-File $LogFile -Append
        $Error.Clear()
	}
	Finally
	{
		"ManageFileFolderPermission.ps1 Executed Successfully" | Out-File $LogFile -Append
	}
}

ManageFileFolderPermission -Function $Function -TargetItem $TargetItem -TargetAccount $TargetAccount -Permissions $Permissions