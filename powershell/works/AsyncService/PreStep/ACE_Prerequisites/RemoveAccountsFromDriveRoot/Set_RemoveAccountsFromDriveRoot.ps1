#######################  
<#  
.SYNOPSIS  
 Script that removes all specified accounts from user group on the machine
.DESCRIPTION  
 Script that removes all specified accounts from user group on the machine
.EXAMPLE  
.\Set_RemoveAccountsFromDriveRoot.ps1 -ItemListReq ",(MyUser1,MyGroup1),(MyUser2,MyGroup2)"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
$ItemListReq = (throw "Pass account name to remove from drive root.")
)

Function Set_RemoveAccountsFromDriveRoot
{
    try
    {
	Write-Output ""
        Write-Output "Removing accounts from root of all drives"

        $drives = gwmi win32_logicaldisk -filter "drivetype=3" 
        foreach ($d in $drives)
        {
          $drive = $d.DeviceID + "/"
          foreach ($itemReq in $ItemListReq)
    	  {
             Write-Output "Drive: $drive"
             Write-Output "Account:  $itemReq"
             Write-Output icacls $drive /remove:g $itemReq
          }
        }
    }
    Catch [system.exception]
    {
	write-output "ERROR: " $_.exception.message
    }
    Finally
    {
	Write-Output "Set_RemoveAccountsFromDriveRoot.ps1 Executed Successfully"
    }
}

Set_RemoveAccountsFromDriveRoot -ItemListReq $ItemListReq