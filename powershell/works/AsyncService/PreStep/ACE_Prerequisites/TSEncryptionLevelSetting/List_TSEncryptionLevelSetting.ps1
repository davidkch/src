#######################  
<#  
.SYNOPSIS  
 Script to update registry key related to encryption level
.DESCRIPTION  
 Script to update registry key related to encryption level
.EXAMPLE  
.\List_TSEncryptionLevelSetting.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

#########PROPERTIES#########
$expectedEncryptionLevel = 3

Function List_TSEncryptionLevelSetting
{
  try
  {
       $ExecutionDirectory = Get-Location

       #Ensure registry key exists first
       $encryptionLevel = Get-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "MinEncryptionLevel" -ErrorAction SilentlyContinue
       $actualEncryptionLevel = $encryptionLevel.MinEncryptionLevel
    
       if ( ! $encryptionLevel )
       {
         Write-Output "MinEncryptionLevel registry key is not present on this computer."
         return $true
       }
       else
       {
          ######Validate######
          $Job = Start-Job -ScriptBlock {
            $KeepShares = $args[1];
            $Shares = $args[2];

            Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
            .\Get_TSEncryptionLevelSetting.ps1 -expectedEncryptionLevel $expectedEncryptionLevel -actualEncryptionLevel $actualEncryptionLevel     		#Call specified script with parameters, if any

            if($Error.Count -gt 0)                                    #Check for errors
            {         	
               throw "Get_TSEncryptionLevelSetting.ps1 FAILED!"
            }
            else { Write-Output "Get_TSEncryptionLevelSetting.ps1 SUCCEEDED!" }
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
            .\Set_TSEncryptionLevelSetting.ps1 -expectedEncryptionLevel $expectedEncryptionLevel          		#Call specified script with parameters, if any

            if($Error.Count -gt 0)                                    #Check for errors
            {         	
               throw "Set_TSEncryptionLevelSetting.ps1 FAILED!"
            }
            else { Write-Output "Set_TSEncryptionLevelSetting.ps1 SUCCEEDED!" }
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
       Write-Output "List_TSEncryptionLevelSetting.ps1 Executed Successfully"
    }
}

List_TSEncryptionLevelSetting