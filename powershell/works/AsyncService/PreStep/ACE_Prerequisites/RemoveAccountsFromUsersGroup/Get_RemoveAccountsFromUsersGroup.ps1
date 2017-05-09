#######################  
<#  
.SYNOPSIS  
 Script that removes all specified accounts from user group on the machine
.DESCRIPTION  
 Script that removes all specified accounts from user group on the machine
.EXAMPLE  
.\Get_RemoveAccountsFromUsersGroup.ps1 -ItemListReq ",(MyUser1,MyGroup1),(MyUser2,MyGroup2)"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
$ItemListReq = (throw "Pass name of user group to verify.")
)
Function Get_RemoveAccountsFromUsersGroup
{
  try
  {      
     Write-Output ""       
     Write-Output "Verifying specified users are no longer part of specified user groups..."
     write-output "ItemListReq:  $ItemListReq"

     for($i=0; $i -lt $ItemListReq.Count; $i++)
     {
       $userAccount = $ItemListReq[$i][0]
       $userGroup = $ItemListReq[$i][1]

       write-Output "User Account:  $userAccount"
       write-Output "User Group:  $userGroup"
        
       $computer = [ADSI]("WinNT://" + $env:COMPUTERNAME + ",computer")
       $Group = $computer.psbase.children.find("$userGroup")
       $members= $Group.psbase.invoke("Members") | %{$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}
       $name = "$userAccount"

       foreach ($itemReq in $ItemListReq)
       {
         if ($members -contains $name)
         {
           Write-Output = "User account `"$name`" is in the `"$userGroup`" group."
         }
         else
         {
           Write-Output "User account `"$name`" does not exist in the `"$userGroup`" group."
         }
       }
     }
  }
  Catch [system.exception]
  {
	write-output $_.exception.message
  }
  Finally
  {
	Write-Output "Get_RemoveAccountsFromUsersGroup.ps1 Executed Successfully"
  }
}

Get_RemoveAccountsFromUsersGroup -ItemListReq $ItemListReq