#######################  
<#  
.SYNOPSIS  
 Script that verifies the registry value for LmCompatibilityLevel matches specified value and updates it if existing value does not match.  If no key, returns true.
.DESCRIPTION  
 Script that verifies the registry value for LmCompatibilityLevel matches specified value and updates it if existing value does not match.  If no key, returns true.
.EXAMPLE  
.\List_LSPNTLMv2Setting.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

######PROPERTIES######
$Value=5

Function List_LSPNTLMv2Setting
{
   try
   {
      $ExecutionDirectory = Get-Location

      ######Validate######
      $Job = Start-Job -ScriptBlock {
	 $Value = "{1}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Get_LSPNTLMv2Setting.ps1 -Value "$Value"             		#Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Get_LSPNTLMv2Setting.ps1 FAILED!"
         }
         else { Write-Output "Get_LSPNTLMv2Setting.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$Value"

      $ret = Receive-Job $job -Wait -AutoRemoveJob

      foreach($out in $ret)
      {
        Write-Output $out
      }

      if($job.State -ieq 'Failed')
      { exit -1 } 


      ######Change######
      $Job = Start-Job -ScriptBlock {
	 $Value = "{1}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Set_LSPNTLMv2Setting.ps1 -Value "$Value"             		#Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Set_LSPNTLMv2Setting.ps1 FAILED!"
         }
         else { Write-Output "Set_LSPNTLMv2Setting.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$Value"

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
       write-Output "ERROR: " $_.exception.message
    }
    Finally
    {
       Write-Output "List_LSPNTLMv2Setting.ps1 Executed Successfully"
    }
}

List_LSPNTLMv2Setting