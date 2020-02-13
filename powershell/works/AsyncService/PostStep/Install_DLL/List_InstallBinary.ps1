#######################  
<#  
.SYNOPSIS  
 Verifies a certificate file exist and renames them as specified.
.DESCRIPTION  
 Verifies a certificate file exist and renames them as specified.
.EXAMPLE  
.\List_InstallBinary.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

######PROPERTIES######
$BinaryList=
@(
  ,("D:\POEDS\AsyncService\bin\POEDSInstrumentation.dll")
)

Function List_InstallBinary
{
    try
    {
     $ExecutionDirectory = Get-Location

     foreach($BinaryPath in $BinaryList)
     {
      ######Validate######
      $Job = Start-Job -ScriptBlock {
	 $BinaryPath = "{1}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Get_InstallBinary.ps1 -BinaryPath "$BinaryPath"            #Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Get_InstallBinary.ps1 FAILED!"
         }
         else { Write-Output "Get_InstallBinary.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$BinaryPath"

      $ret = Receive-Job $job -Wait -AutoRemoveJob

      foreach($out in $ret)
      {
        Write-Output $out
      }

      if($job.State -ieq 'Failed')
      { exit -1 } 


      ######Change######
      $Job = Start-Job -ScriptBlock {
	 $BinaryPath = "{1}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Set_InstallBinary.ps1 -BinaryPath "$BinaryPath"            #Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Set_InstallBinary.ps1 FAILED!"
         }
         else { Write-Output "Set_InstallBinary.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$BinaryPath"

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
       Write-Output "List_InstallBinary.ps1 Executed Successfully"
    }
}

List_InstallBinary