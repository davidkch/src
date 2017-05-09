#######################  
<#  
.SYNOPSIS  
 Generic script to update registry key related to idle user settings
.DESCRIPTION  
 Generic script to update registry key related to idle user settings
.EXAMPLE  
.\List_TSIdleUserSetting.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

#######PROPERTIES#######
$expectedfInheritMaxIdleTime = 0
$expectedMaxIdleTime = 1800000

Function List_TSIdleUserSetting
{
    try
    {
      $ExecutionDirectory = Get-Location
      $fInheritMaxIdleTime = Get-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "fInheritMaxIdleTime" -ErrorAction SilentlyContinue
      $maxIdleTime = Get-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "MaxIdleTime" -ErrorAction SilentlyContinue

      [string]$fInheritMaxIdleTime = ($fInheritMaxIdleTime | Select-Object "fInheritMaxIdleTime" )
      $fInheritMaxIdleTime = $fInheritMaxIdleTime.Split('@', '=', '{', '}')[3]

      [string]$maxIdleTime = ($maxIdleTime | Select-Object "maxIdleTime" )
      $maxIdleTime = $maxIdleTime.Split('@', '=', '{', '}')[3]

      write-output "fInheritMaxIdleTime: " $fInheritMaxIdleTime
      write-output "maxIdleTime: " $maxIdleTime


      ######Validate######
      $Job = Start-Job -ScriptBlock {
          $expectedfInheritMaxIdleTime = "{1}" -f $args;
          $expectedMaxIdleTime = "{2}" -f $args;
          $fInheritMaxIdleTime = "{3}" -f $args;
          $maxIdleTime = "{4}" -f $args;

	  Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	  .\Get_TSIdleUserSetting.ps1 -expectedfInheritMaxIdleTime "$expectedfInheritMaxIdleTime" -expectedMaxIdleTime "$expectedMaxIdleTime" -fInheritMaxIdleTime "$fInheritMaxIdleTime" -maxIdleTime "$maxIdleTime"             		#Call specified script with parameters, if any

          if($Error.Count -gt 0)                                    #Check for errors
          {         	
	    throw "Get_TSIdleUserSetting.ps1 FAILED!"
          }
          else { Write-Output "Get_TSIdleUserSetting.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$expectedfInheritMaxIdleTime", "$expectedMaxIdleTime", "$fInheritMaxIdleTime", "$maxIdleTime"

      $ret = Receive-Job $job -Wait -AutoRemoveJob

      foreach($out in $ret)
      {
        Write-Output $out
      }

      if($job.State -ieq 'Failed')
      { exit -1 } 


      ######Change######
      $Job = Start-Job -ScriptBlock {
          $expectedfInheritMaxIdleTime = "{1}" -f $args;
          $expectedMaxIdleTime = "{2}" -f $args;
          $fInheritMaxIdleTime = "{3}" -f $args;
          $maxIdleTime = "{4}" -f $args;

	  Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	  .\Set_TSIdleUserSetting.ps1 -expectedfInheritMaxIdleTime "$expectedfInheritMaxIdleTime" -expectedMaxIdleTime "$expectedMaxIdleTime" -fInheritMaxIdleTime "$fInheritMaxIdleTime" -maxIdleTime "$maxIdleTime"             		#Call specified script with parameters, if any

          if($Error.Count -gt 0)                                    #Check for errors
          {         	
	    throw "Set_TSIdleUserSetting.ps1 FAILED!"
          }
          else { Write-Output "Set_TSIdleUserSetting.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$expectedfInheritMaxIdleTime", "$expectedMaxIdleTime", "$fInheritMaxIdleTime", "$maxIdleTime"

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
       Write-Output "List_TSIdleUserSetting.ps1 Executed Successfully"
    }
}

List_TSIdleUserSetting