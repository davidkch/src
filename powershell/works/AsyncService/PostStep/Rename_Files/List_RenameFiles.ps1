#######################  
<#  
.SYNOPSIS  
 Verifies a list of files exist and renames them as specified.
.DESCRIPTION  
 Verifies a list of files exist and renames them as specified.
.EXAMPLE  
.\List_LocalGroups.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

######PROPERTIES######
$RenameFileList=
@(
  ,("D:\POEDS\AsyncService", "Web.Async.ship.config", "Web.config")
  ,("D:\POEDS\AsyncService", "AsynService.Logging.Configuration.ship.config", "AsynService.Logging.Configuration.config")
  ,("D:\POEDS\AsyncService", "AsynService.Diagnostics.Configuration.ship.config", "AsynService.Diagnostics.Configuration.config")
)

Function List_RenameFiles
{
    try
    {
     $ExecutionDirectory = Get-Location

     #Validate
     for($i=0; $i -lt $RenameFileList.Count; $i++)
     {
      $FilePath = $RenameFileList[$i][0]
      $OldFileName = $RenameFileList[$i][1]
      $NewFileName = $RenameFileList[$i][2]

      ######Validate######
      $Job = Start-Job -ScriptBlock {
	 $FilePath = "{1}" -f $args;
	 $OldFileName = "{2}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Get_RenameFiles.ps1 -FilePath "$FilePath" -OldFileName "$OldFileName"           #Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Get_RenameFiles.ps1 FAILED!"
         }
         else { Write-Output "Get_RenameFiles.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$FilePath", "$OldFileName"

      $ret = Receive-Job $job -Wait -AutoRemoveJob

      foreach($out in $ret)
      {
        Write-Output $out
      }

      if($job.State -ieq 'Failed')
      { exit -1 } 


      ######Change######
      $Job = Start-Job -ScriptBlock {
	 $FilePath = "{1}" -f $args;
	 $OldFileName = "{2}" -f $args;
	 $NewFileName = "{3}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Set_RenameFiles.ps1 -FilePath "$FilePath" -OldFileName "$OldFileName" -NewFileName "$NewFileName"           #Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Set_RenameFiles.ps1 FAILED!"
         }
         else { Write-Output "Set_RenameFiles.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$FilePath", "$OldFileName", "$NewFileName"

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
      Write-Output "List_RenameFiles.ps1 Executed Successfully" 
    }
}

List_RenameFiles