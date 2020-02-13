#######################  
<#  
.SYNOPSIS  
 Verifies specified servers can be contacted from local machine.
.DESCRIPTION  
 Verifies specified servers can be contacted from local machine.
.EXAMPLE  
.\List_UpdateFileFolderPermissions.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

######PROPERTIES######
param(
)

Function List_netHSM
{
    try
    {      
      $ExecutionDirectory = Get-Location

      ######Validate######
      $Job = Start-Job -ScriptBlock {

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Get_netHSM.ps1		            		#Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Get_netHSM.ps1 FAILED!"
         }
         else { Write-Output "Get_netHSM.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory"

      $ret = Receive-Job $job -Wait -AutoRemoveJob

      foreach($out in $ret)
      {
        Write-Output $out
      }

      if($job.State -ieq 'Failed')
      { exit -1 } 

      ######Change######
      $Job = Start-Job -ScriptBlock {
	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Set_netHSM.ps1 		              		#Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Set_netHSM.ps1 FAILED!"
         }
         else { Write-Output "Set_netHSM.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory"

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
      write-output "ERROR: " $_.exception.message
    }
    Finally
    {
      Write-Output "List_netHSM.ps1 Executed Successfully"
    }
}

List_netHSM