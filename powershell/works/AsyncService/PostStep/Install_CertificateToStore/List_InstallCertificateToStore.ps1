#######################  
<#  
.SYNOPSIS  
 Verifies a certificate file exist and adds it to the specified store.
.DESCRIPTION  
 Verifies a certificate file exist and adds it to the specified store.
.EXAMPLE  
.\List_InstallCertificateToStore.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

######PROPERTIES######
#If the file is located anywhere other than the same directory as the scripts, specify the directory with the file name.
$CertList=
@(
  ,('ptoolsuat.cer', "MY")
)

Function List_InstallCertificateToStore
{
    try
    {
     $ExecutionDirectory = Get-Location

     for($i=0; $i -lt $CertList.Count; $i++)
     {
      $FilePath = $CertList[$i][0]
      $StoreName = $CertList[$i][1]

      ######Validate######
      $Job = Start-Job -ScriptBlock {
	 $FilePath = "{1}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Get_InstallCertificateToStore.ps1 -FilePath "$FilePath"              #Call specified script with parameters, if any

      if($Error.Count -gt 0)                                    #Check for errors
      {         	
	throw "Get_InstallCertificateToStore.ps1 FAILED!"
      }
      else { Write-Output "Get_InstallCertificateToStore.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$FilePath"

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
	 $StoreName = "{2}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Set_InstallCertificateToStore.ps1 -FilePath "$FilePath" -StoreName "$StoreName"              #Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Set_InstallCertificateToStore.ps1 FAILED!"
         }
         else { Write-Output "Set_InstallCertificateToStore.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$FilePath", "$StoreName"

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
      Write-Output "List_InstallCertificateToStore.ps1 Executed Successfully"
    }
}

List_InstallCertificateToStore