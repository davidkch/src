#######################  
<#  
.SYNOPSIS  
 Verifies if a local user group exists.
.DESCRIPTION  
 Verifies if a local user group exists.
.EXAMPLE  
.\Get_CreateLocalGroups.ps1 -GroupName "MyGroup"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    $GroupName = $(throw "Please pass local user group name.")
)

######PROPERTIES######

Function Get_CreateLocalGroups
{
  try
  {             
      Write-Output "Verifying if local user group $GroupName exists..." 
      Write-Output "Group name:  $GroupName" 

    $server="."
    $computer = [ADSI]"WinNT://$server,computer"

    $Result = $computer.psbase.children | where { $_.psbase.schemaClassName -eq 'group' } | foreach { write-output $_.name }

    if($result -match $GroupName) { Write-output "User group exists!  Removing user group..."; net localgroup "$Groupname" /delete; }
    else { Write-Output "User does not exist!  Continuing process..." }
  }
  Catch [system.exception]
  {
	write-output "ERROR:" $Error
  }
  Finally
  {
	Write-Output "Get_CreateLocalGroups.ps1 Executed Successfully" 
  }
}

Get_CreateLocalGroups -$GroupName $GroupName