#######################  
<#  
.SYNOPSIS  
 Verifies specified servers can be contacted from local machine.
.DESCRIPTION  
 Verifies specified servers can be contacted from local machine.
.EXAMPLE  
.\List_AppSeg.ps1 -ServerList "Server1,Server2"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

######PROPERTIES######
param(
 $ServerList = (throw "Please pass ItemList.  List of servers.")
)

Function List_AppSeg
{
    try
    {
      $ExecutionDirectory = Get-Location

      ######Validate######
      $Job = Start-Job -ScriptBlock {
	 $ServerList = "{1}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Get_AppSeg.ps1 -ServerList $ServerList              		#Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Get_AppSeg.ps1 FAILED!"
         }
         else { Write-Output "Get_AppSeg.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$ServerList"

      $ret = Receive-Job $job -Wait -AutoRemoveJob

      foreach($out in $ret)
      {
        Write-Output $out
      }

      if($job.State -ieq 'Failed')
      { exit -1 } 


      ######Change######
      $Job = Start-Job -ScriptBlock {
	 $Path = "{1}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Set_AppSeg.ps1 -ServerList "$ServerList"              		#Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Set_AppSeg.ps1 FAILED!"
         }
         else { Write-Output "Set_AppSeg.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$ServerList"

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
       Write-Output "List_AppSeg.ps1 Executed Successfully"
    }
}

List_AppSeg -ServerList $ServerList