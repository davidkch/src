#######################  
<#  
.SYNOPSIS  
 Adds a cert file to a store
.DESCRIPTION  
 Adds a cert file to a store
.EXAMPLE  
.\Set_InstallCertificateToStore.ps1 -FilePath C:\Cert.cer -StoreName "MY"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    $FilePath = (throw "Please pass File Path"),
    $StoreName = (throw "Please pass store name")
)

Function Set_InstallCertificateToStore
{
    try
    {
      $ExecutionDirectory = Get-Location

      Write-Output ""
      Write-Output "Installing specified certificate(s)" 
      Write-Output "CERT: $FilePath"
      Write-Output "Store: $StoreName"

      $Job = Start-Job -ScriptBlock {
	 $FilePath = "{1}" -f $args;
	 $StoreName = "{2}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\InstallCertificateToStore.ps1 -FilePath "$FilePath" -StoreName "$StoreName"             #Call specified script with parameters, if any

        if($Error.Count -gt 0)                                    #Check for errors
        {         	
	  throw "InstallCertificateToStore.ps1 FAILED!"
        }
        else { Write-Output "InstallCertificateToStore.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$FilePath", "$StoreName"

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
		Write-Output "Set_InstallCertificateToStore.ps1 Executed Successfully" 
	}
}

Set_InstallCertificateToStore -FilePath $FilePath -StoreName $StoreName