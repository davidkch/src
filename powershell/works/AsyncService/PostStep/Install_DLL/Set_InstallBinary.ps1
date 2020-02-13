#######################  
<#  
.SYNOPSIS  
 Installs specified binaries to machine
.DESCRIPTION  
 Installs specified binaries to machine
.EXAMPLE  
.\Set_InstallBinary.ps1 -CertFilePath C:\Cert.pfx
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    $BinaryPath = (throw "Please pass path and name of DLL you wish to install.")
)

Function Set_InstallBinary
{
    try
    {
      $ExecutionDirectory = Get-Location

      $Job = Start-Job -ScriptBlock {
	 $BinaryPath = "{1}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\InstallBinary.ps1 -DLL_Installed "$BinaryPath"            #Call specified script with parameters, if any

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
    Catch [system.exception]
    {
      write-output "ERROR: " $_.exception.message 
    }
    Finally
    {
	Write-Output "Set_InstallBinary.ps1 Executed Successfully" 
    }
}

Set_InstallBinary -BinaryPath $BinaryPath