#######################  
<#  
.SYNOPSIS  
 Script that removes all specified accounts from user group on the machine
.DESCRIPTION  
 Script that removes all specified accounts from user group on the machine
.EXAMPLE  
.\Get_RemoveAccountsFromDriveRoot.ps1 -ItemListReq ",(MyUser1,MyGroup1),(MyUser2,MyGroup2)"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
$ItemListReq = (throw "Pass account name to remove from drive root.")
)

Function Get_RemoveAccountsFromDriveRoot
{
  try
  {             
     Write-Output ""
     Write-Output "Getting current drives user accounts from drive..."
     
     $drives = gwmi win32_logicaldisk -filter "drivetype=3" 
     foreach ($d in $drives)
     {
	    $drive = $d.DeviceID + "/"
        foreach ($itemReq in $ItemListReq)
        {
          Write-Output "Drive: $drive"
          Write-Output "itemReq: $itemReq"
	      $accountFound = icacls $drive /findSID $itemReq | select-string -pattern "SID Found"
          if ( $accountFound -ne $null )
          {
            Write-Output "Everyone, Authenticated Users, and/or Guest accounts are not removed from the root of all drives."
	    exit
          }
        }
     }  
  }
  Catch [system.exception]
  {
	write-output "ERROR: " $_.exception.message
    return $true    
  }
  Finally
  {
	Write-Output "Get_RemoveAccountsFromDriveRoot.ps1 Executed Successfully"
  }
}

Get_RemoveAccountsFromDriveRoot -ItemListReq $ItemListReq