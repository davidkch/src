#######################  
<#  
.SYNOPSIS  
 Script that provides a list of services to enable/disable
.DESCRIPTION  
 Script that provides a list of services to enable/disable
.EXAMPLE  
.\List_Services.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

$servicesListReq =
    @(
      ("aspnet_state", "disabled"),
      ("spooler", "disabled"),
      ("tapisrv", "disabled"),
      ("alerter", "disabled"),
      ("ftp", "disabled"),
      ("telnet", "disabled"),
      ("wireless", "disabled")
    )

Function List_Services
{
  try
  {
    $ExecutionDirectory = Get-Location
    $servicesToDisable = @()

    write-Output "Number of services specified:  " $servicesListReq.Count

    for ($i = 0; $i -lt $servicesListReq.Count; $i++)
    {
      $name = $servicesListReq[$i][0]
      $stateFlag = $servicesListReq[$i][1]
       
      Write-Output ""
      write-Output "Name: $name"
      write-Output "StateFlag: $stateFlag"

      ######Validate######
      $Job = Start-Job -ScriptBlock {
        $name = $args[1];
        $stateFlag = $args[2];

        Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
        .\Get_Services.ps1 -ServiceName "$name" -StateFlag "$stateFlag"            		#Call specified script with parameters, if any
	
        if($Error.Count -gt 0)                                    #Check for errors
        {         	
	  throw "Get_Services.ps1 FAILED!"
        }
        else { Write-Output "Get_Services.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$name", "$stateFlag"

      $ret = Receive-Job $job -Wait -AutoRemoveJob

      foreach($out in $ret)
      {
        Write-Output $out
      }

      if($job.State -ieq 'Failed')
      { exit -1 } 


      ######Change######
      $Job = Start-Job -ScriptBlock {
        $name = $args[1];
        $stateFlag = $args[2];

        Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
        .\Set_Services.ps1 -ServiceName "$name" -StateFlag "$stateFlag"            		#Call specified script with parameters, if any

        if($Error.Count -gt 0)                                    #Check for errors
        {         	
	  throw "Set_Services.ps1 FAILED!"
        }
        else { Write-Output "Set_Services.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$name", "$stateFlag"

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
       Write-Output "List_Services.ps1 Executed Successfully"
    }
}

List_Services