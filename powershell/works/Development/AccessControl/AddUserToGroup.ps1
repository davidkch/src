#######################  
<#  
.SYNOPSIS  
 Generic script to add users to a user group on any accessible remote server.
.DESCRIPTION  
 Generic script to add users to a user group on any accessible remote server.
.EXAMPLE  
.\AddUserToGroup.ps1 -Group MyUserGroupName -AdminUserName Bill
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param (
		[string] $Group = $(throw "Pass the Group"),
		[string] $AdminUserName = $(throw "Pass the AdminUserName")
      )
      
$LogFile = "AddUserToGroup.log"

Function AddUserToGroup
{      
    try
	{   
		$ComputerName = "$env:computername"
		"Computer Name: $ComputerName" | Out-File $LogFile
		Write-host "Computer Name:" $ComputerName

		[string]$DomainName = ([ADSI]'').name
		"Domain Name: $DomainName" | Out-File $LogFile -Append
		Write-host "Domain Name: $DomainName"

		([ADSI]"WinNT://$ComputerName/$Group,group").Add("WinNT://$DomainName/$AdminUserName")
	}
	Catch [system.exception]
	{
		write-host $_.exception.message | Out-File $LogFile -Append
	}
	Finally
	{
		"Executed Successfully" | Out-File $LogFile -Append
	}
}    
    
AddUserToGroup -Group $Group -AdminUserName $AdminUserName