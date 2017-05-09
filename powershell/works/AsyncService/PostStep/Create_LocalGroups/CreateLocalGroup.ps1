#######################  
<#  
.SYNOPSIS  
Creates a new user group on the local machine.
.DESCRIPTION  
Creates a new user group on the local machine.
.EXAMPLE  
.\CreateLocalGroup.ps1 -GroupDetails @("TestGroup1", "Test1")
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  


param(
[string[]]$GroupDetails = $(throw "Pass the User Group Details")
)

######PROPERTIES######
$LogFile = "CreateLocalGroup.log"

Function CreateLocalGroup
{
	try
	{
			$GroupName = $GroupDetails[0]
			$Comment = $GroupDetails[1]

            Write-Output "GroupName: $GroupName"  | Out-File $LogFile -Append
            Write-Output "Comment: $Comment"  | Out-File $LogFile -Append

			NET LocalGroup $GroupName /ADD /COMMENT:"$Comment" | Out-File $LogFile -Append
	}
	Catch [system.exception]
	{
		write-output "ERROR: " $Error | Out-File $LogFile -Append
	}
	Finally
	{
		Write-Output "CreateLocalGroup.ps1 Executed Successfully" | Out-File $LogFile -Append
	}
}

CreateLocalGroup -GroupDetails $GroupDetails