#######################  
<#  
.SYNOPSIS  
 Script that removes all shares on the machine except the ones specified
.DESCRIPTION  
 Script that removes all shares on the machine except the ones specified
.EXAMPLE  
.\List_RemoveSharesFromSystemDrive.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

######PROPERTIES######
$KeepShares = "PA_POEDS_SLK_DEV"
$Shares = gwmi Win32_Share | Where-Object {($_.Name -notlike "*$") -and ($_.Path -like "C:\*")}

Function List_RemoveSharesFromSystemDrive
{
   try
   {
    $ExecutionDirectory = Get-Location 

    if($Shares.Name.Count -gt 0)
    {	
      ######Validate######
      $Job = Start-Job -ScriptBlock {
        $KeepShares = $args[1];
        $Shares = $args[2];

        Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
        .\Get_RemoveSharesFromSystemDrive.ps1 -KeepShares $KeepShares -Shares $Shares             		#Call specified script with parameters, if any

        if($Error.Count -gt 0)                                    #Check for errors
        {         	
	  throw "Get_RemoveAccountsFromDriveRoot.ps1 FAILED!"
        }
        else { Write-Output "Get_RemoveAccountsFromDriveRoot.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", $KeepShares, $Shares

      $ret = Receive-Job $job -Wait -AutoRemoveJob

      foreach($out in $ret)
      {
        Write-Output $out
      }

      if($job.State -ieq 'Failed')
      { exit -1 } 


      ######Change######
      $Job = Start-Job -ScriptBlock {
         $KeepShares = $args[1];
         $Shares = $args[2];

         Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
         .\Set_RemoveSharesFromSystemDrive.ps1 -KeepShares $KeepShares -Shares $Shares             		#Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	     throw "Set_RemoveAccountsFromDriveRoot.ps1 FAILED!"
         }
         else { Write-Output "Set_RemoveAccountsFromDriveRoot.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", $KeepShares, $Shares

      $ret = Receive-Job $job -Wait -AutoRemoveJob

      foreach($out in $ret)
      {
         Write-Output $out
      }

      if($job.State -ieq 'Failed')
      { exit -1 } 
    }
   }
   Catch [system.exception]
   {
       write-output "ERROR: " $_.exception.message
   }
   Finally
   {
       Write-Output "List_RemoveSharesFromSystemDrive.ps1 Executed Successfully"
   }
}

List_RemoveSharesFromSystemDrive