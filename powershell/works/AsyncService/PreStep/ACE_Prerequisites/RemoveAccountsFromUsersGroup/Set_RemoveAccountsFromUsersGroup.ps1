#######################  
<#  
.SYNOPSIS  
 Script that removes all specified accounts from user group on the machine
.DESCRIPTION  
 Script that removes all specified accounts from user group on the machine
.EXAMPLE  
.\Set_RemoveAccountsFromUsersGroup.ps1 -ItemListReq ",(MyUser1,MyGroup1),(MyUser2,MyGroup2)"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
$ItemListReq = (throw "Pass list of account aliases to remove from user group.")
)

Function Set_RemoveAccountsFromUsersGroup
{
   try
   {
	Write-Output ""
        Write-Output "Removing specified accounts from Users groups..."
	Write-Output "ItemListReq:  $ItemListReq"

        for($i=0; $i -lt $ItemListReq.Count; $i++)
        {
         $userAccount = $ItemListReq[$i][0]
         $userGroup = $ItemListReq[$i][1]

         write-Output "User Account:  $userAccount"
         write-Output "User Group:  $userGroup"
        
         $computer = [ADSI]("WinNT://" + $env:COMPUTERNAME + ",computer")
         $Group = $computer.psbase.children.find("$userGroup")
         $members= $Group.psbase.invoke("Members") | %{$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}

         if ($members -contains $userAccount)
         {
             $output = $Group.Remove("WinNT://" + $userAccount)
             Write-Output $output
	     Write-Output "Removed '$userAccount' from '$userGroup' user group."
         }
        }
    }
    Catch [system.exception]
    {
       write-output $_.exception.message
    }
    Finally
    {
       Write-Output "Set_RemoveAccountsFromUsersGroup.ps1 Executed Successfully"
  }
}

Set_RemoveAccountsFromUsersGroup -ItemListReq $ItemListReq