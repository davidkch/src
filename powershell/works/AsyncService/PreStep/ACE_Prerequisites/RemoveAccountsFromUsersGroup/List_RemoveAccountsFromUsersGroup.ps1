#######################  
<#  
.SYNOPSIS  
 Script that removes all specified accounts from user group on the machine
.DESCRIPTION  
 Script that removes all specified accounts from user group on the machine
.EXAMPLE  
.\List_RemoveAccountsFromUsersGroup.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

######PROPERTIES######
$ItemListReq=
@(
 ,("Authenticated Users", "Users")
)

Function List_RemoveAccountsFromUsersGroup
{
  try
  {
      $ExecutionDirectory = Get-Location

      ######Validate######
      $Job = Start-Job -ScriptBlock {
	 $ItemListReq = $args[1];

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Get_RemoveAccountsFromUsersGroup.ps1 -ItemListReq $ItemListReq             		#Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Get_RemoveAccountsFromUsersGroup.ps1 FAILED!"
         }
         else { Write-Output "Get_RemoveAccountsFromUsersGroup.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", $ItemListReq

      $ret = Receive-Job $job -Wait -AutoRemoveJob

      foreach($out in $ret)
      {
        Write-Output $out
      }

      if($job.State -ieq 'Failed')
      { exit -1 } 


      ######Change######
      $Job = Start-Job -ScriptBlock {
	 $ItemListReq = $args[1];

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Set_RemoveAccountsFromUsersGroup.ps1 -ItemListReq $ItemListReq              		#Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Set_RemoveAccountsFromUsersGroup.ps1 FAILED!"
         }
         else { Write-Output "Set_RemoveAccountsFromUsersGroup.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", $ItemListReq

      $ret = Receive-Job $job -Wait -AutoRemoveJob

      foreach($out in $ret)
      {
        Write-Output $out
      }

      if($job.State -ieq 'Failed')
      { exit -1 } 
    }
    Catch [system.exception]
    {
       write-output $_.exception.message
       return $true
    }
    Finally
    {
       "List_RemoveAccountsFromUsersGroup.ps1 Executed Successfully"
    }
}

List_RemoveAccountsFromUsersGroup