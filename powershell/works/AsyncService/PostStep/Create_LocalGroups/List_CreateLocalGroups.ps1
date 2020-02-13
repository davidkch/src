#######################  
<#  
.SYNOPSIS  
 Verifies user group(s) does not already exist and creates them if it does not.
.DESCRIPTION  
 Verifies user group(s) does not already exist and creates them if it does not.
.EXAMPLE  
.\List_CreateLocalGroups.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

######PROPERTIES######
$GroupList=
@(
  ,("POEDSAsyncServiceUsers", "")
  ,("SLKAsyncServiceUsers", "")
  ,("POEDSPOELoadUsers", "")
  ,("POEDSPingUsersAS", "")
  ,("IBBAsyncServiceUsers", "")
)

$ExecutionDirectory = Get-Location

Function List_CreateLocalGroups
{
  try
  {
    foreach($GroupDetails in $GroupList)
    {
      ######Validate######
      $Job = Start-Job -ScriptBlock {
	 $LogFile = "{1}" -f $args;
	 $GroupName = $args[2][0];
	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Get_CreateLocalGroups.ps1 -GroupName "$GroupName"              #Call specified script with parameters, if any

      if($Error.Count -gt 0)                                    #Check for errors
      {         	
	throw "Get_CreateLocalGroups.ps1 FAILED!"
      }
      else { Write-Output "Get_CreateLocalGroups.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$LogFile", $GroupDetails

      $ret = Receive-Job $job -Wait -AutoRemoveJob

      foreach($out in $ret)
      {
        Write-Output $out
      }

      if($job.State -ieq 'Failed')
      { exit -1 } 


      ######Change######
      $Job = Start-Job -ScriptBlock {
	 $LogFile = "{1}" -f $args;
	 $GroupDetails = $args[2]
	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Set_CreateLocalGroups.ps1 -GroupDetails $GroupDetails               #Call specified script with parameters, if any
        if($Error.Count -gt 0)                                    #Check for errors
        {          	  
	  throw "Get_CreateLocalGroups.ps1 FAILED!"
        }
        else { Write-Output "Set_CreateLocalGroups.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$LogFile", $GroupDetails

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
    write-output "ERROR: " $Error
  }
  Finally
  {
   Write-Output "List_CreateLocalGroups.ps1 Executed Successfully"
  }
}

List_CreateLocalGroups