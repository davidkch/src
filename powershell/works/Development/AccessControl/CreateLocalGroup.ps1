#######################  
<#  
.SYNOPSIS  
Creates a new user group on the local machine.
.DESCRIPTION  
Creates a new user group on the local machine.
.EXAMPLE  
.\CreateLocalGroup.ps1 -GroupDetails @(("TestGroup1", "Test1"), ("TestGroup2", "Test2"))
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  


param(
[string[][]]$GroupDetails = $(throw "Pass the User Group Details")
)

$LogFile = "CreateLocalGroup.log"

Function CreateLocalGroup
{
	try
	{
		for($i=0; $i -lt $GroupDetails.Count; $i++)
		{
			$GroupName = $GroupDetails[$i][0]
			$Comment = $GroupDetails[$i][1]

            Write-Output "GroupName: $GroupName"  | Out-File $LogFile -Append
            Write-Output "Comment: $Comment"  | Out-File $LogFile -Append

			NET LocalGroup $GroupName /ADD /COMMENT:"$Comment" | Out-File $LogFile -Append
			write-output "The user group $GroupName has been added in the server." | Out-File $LogFile -Append
		}
	}
	Catch [system.exception]
	{
		write-output "ERROR: " $_.exception.message | Out-File $LogFile -Append
	}
	Finally
	{
		Write-Output "CreateLocalGroup.ps1 Executed Successfully" | Out-File $LogFile -Append
	}
}

CreateLocalGroup -GroupName $GroupName