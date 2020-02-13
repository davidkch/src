#######################  
<#  
.SYNOPSIS  
 Script that removes all specified files/folders on the machine
.DESCRIPTION  
 Script that removes all specified files/folders on the machine
.EXAMPLE  
.\List_RemoveFilesAndDirectories.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

######PROPERTIES######
$ItemListReq=
(
"c:\inetpub\mailroot",
"c:\inetpub\wwwroot\*",
"c:\program files\online services",
"c:\windows\help\iishelp\iis",
"c:\windows\system32\inetsrv\iisadmpwd",
"c:\windows\system32\inetsrv\metaback\*"
)

Function List_RemoveFilesAndDirectories
{
   try
   {
      $ExecutionDirectory = Get-Location

      ######Validate######
      $Job = Start-Job -ScriptBlock {
	 $ItemListReq = $args[1];

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Get_RemoveFilesAndDirectories.ps1 -ItemListReq $ItemListReq             		#Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Get_RemoveFilesAndDirectories.ps1 FAILED!"
         }
         else { Write-Output "Get_RemoveFilesAndDirectories.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", $ItemListReq

      $ret = Receive-Job $job -Wait -AutoRemoveJob

      foreach($out in $ret)
      {
        Write-Output $out
      }

      if($job.State -ieq 'Failed')
      { exit -1 } 


      ######Change######
      $Job = Start-Job -ScriptBlock {
	 $ItemListReq = $args[1];

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Set_RemoveFilesAndDirectories.ps1 -ItemListReq $ItemListReq             		#Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Set_RemoveFilesAndDirectories.ps1 FAILED!"
         }
         else { Write-Output "Set_RemoveFilesAndDirectories.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", $ItemListReq

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
      Write-Output "List_RemoveFilesAndDirectories.ps1 Executed Successfully"
    }
}

List_RemoveFilesAndDirectories