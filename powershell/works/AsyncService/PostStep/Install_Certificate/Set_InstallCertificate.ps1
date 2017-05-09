#######################  
<#  
.SYNOPSIS  
 Renames a given list of files
.DESCRIPTION  
 Renames a given list of files
.EXAMPLE  
.\Set_InstallCertificate.ps1 -CertFilePath C:\Cert.pfx -Password "3kjv8kjf#"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    $FilePath = (throw "Please pass File Path"),
    $Password = (throw "Please pass Existing File name")
)

Function Set_InstallCertificate
{
  try
  {
      $ExecutionDirectory = Get-Location

      Write-Output ""
      Write-Output "Installing specified certificate(s)" 

      $Job = Start-Job -ScriptBlock {
	 $FilePath = "{1}" -f $args;
	 $Password = "{2}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\InstallCertificate.ps1 -FilePath "$FilePath" -Password "$Password"             #Call specified script with parameters, if any

      if($Error.Count -gt 0)                                    #Check for errors
      {         	
	throw "InstallCertificate.ps1 FAILED!"
      }
      else { Write-Output "InstallCertificate.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$FilePath", "$Password"

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
    Write-Output "Set_InstallCertificate.ps1 Executed Successfully" 
  }
}

Set_InstallCertificate -FilePath $FilePath -Password $Password