#######################  
<#  
.SYNOPSIS  
 Verifies if a website and the bindings exist, then updates them as specified.
.DESCRIPTION  
 Verifies if a website and the bindings exist, then updates them as specified.
.EXAMPLE  
.\List_UpdateWebsiteBindings.ps1 -IP "10.251.210.53" -DeploymentMode "MT" -FQDN "poedsSSIRDev.parttest.extranettest.microsoft.com"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
  $IP = (throw "Please pass the IP address to assign to the binding."),
  $DeploymentMode = (throw "Please pass the deployment mode.  Possibilities are:  LEGACY/FE/MT/IM."),
  $FQDN = (throw "Please pass fully qualified domain name for website (FQDN).")
)

######PROPERTIES######
$BindingList=
@(
  ,("POEDS", 'ASyncService', "14575", "$IP", "81", "POEDSAsyncService", "D:\WebLogs", "$DeploymentMode", "$FQDN")
)

Function List_UpdateWebsiteBindings
{
    try
    {
     $ExecutionDirectory = Get-Location

     for($i=0; $i -lt $BindingList.Count; $i++)
     {
      $Website = $BindingList[$i][0]
      $VirDir = $BindingList[$i][1]
      $TCPPort = $BindingList[$i][2]
      $IP = $BindingList[$i][3]
      $HTTPPort = $BindingList[$i][4]
      $AppPool = $BindingList[$i][5]
      $WebLogs = $BindingList[$i][6]
      $DeploymentMode = $BindingList[$i][7]
      $FQDN = $BindingList[$i][8]

      ######Validate######
      $Job = Start-Job -ScriptBlock {
	 $Website = "{1}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Get_UpdateWebsiteBindings.ps1 -Website "$Website"            #Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Get_UpdateWebsiteBindings.ps1 FAILED!"
         }
         else { Write-Output "Get_UpdateWebsiteBindings.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$Website"

      $ret = Receive-Job $job -Wait -AutoRemoveJob

      foreach($out in $ret)
      {
        Write-Output $out
      }

      if($job.State -ieq 'Failed')
      { exit -1 } 


      ######Change######
      $Job = Start-Job -ScriptBlock {
      $Website = "{1}" -f $args;
      $VirDir = "{2}" -f $args;
      $TCPPort = "{3}" -f $args;
      $IP = "{4}" -f $args;
      $HTTPPort = "{5}" -f $args;
      $AppPool = "{6}" -f $args;
      $WebLogs = "{7}" -f $args;
      $DeploymentMode = "{8}" -f $args;
      $FQDN = "{9}" -f $args;

      Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
      .\Set_UpdateWebsiteBindings.ps1 -Website "$Website" -VirDir "$VirDir" -TcpPort "$TCPPort" -IP "$IP" -HTTPPort "$HTTPPort" -AppPool "$AppPool" -WebLogs "$WebLogs" -DeploymentMode "$DeploymentMode" -FQDN "$FQDN"            #Call specified script with parameters, if any

      if($Error.Count -gt 0)                                    #Check for errors
      {         	
        throw "Set_UpdateWebsiteBindings.ps1 FAILED!"
      }
      else { Write-Output "Set_UpdateWebsiteBindings.ps1 SUCCEEDED!" }
     } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$Website", "$VirDir", "$TCPPort", "$IP", "$HTTPPort", "$AppPool", "$WebLogs", "$DeploymentMode", "$FQDN"

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
     return $true
   }
   Finally
   {
     Write-Output "List_UpdateWebsiteBindings.ps1 Executed Successfully"
   }
}

List_UpdateWebsiteBindings -IP $IP -DeploymentMode $DeploymentMode -FQDN $FQDN