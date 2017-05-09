#######################  
<#  
.SYNOPSIS  
 Generic script to add users to a local user group.
.DESCRIPTION  
 Generic script to add users to a local user group.
.EXAMPLE  
.\AddLocalUsersToGroup.ps1 -AccountName Bill;Alice -GroupName MyUserGroupName
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
[string]$AccountName = $(throw "Pass the Account Name"),
[string]$GroupName = $(throw "Pass the Group Name")
)

$LogFile = "AddLocalUsersToGroup.log"

Function AddLocalUsersToGroup
{
	try
	{
		$LogFile = "AddLocalUsersToGroup.log"
		$AccountName = $AccountName.split(";")
		for($i=0; $i -lt $accountname.length ; $i++)
		{
			$acc=$accountname[$i]
			NET LocalGroup $groupname $acc /ADD
			write-output "The account `"$acc`" has been added to the Group `"$groupname`" in the server." | Out-File $LogFile
		}

		return $false
	}
	Catch [system.exception]
	{
		write-output $_.exception.message | Out-File $LogFile -Append
		return $true
	}
	Finally
	{
		Write-Output "AddLocalUsersToGroup.ps1 Executed Successfully" | Out-File $LogFile -Append
	}
}

AddLocalUsersToGroup -AccountName $AccountName -GroupName $GroupName