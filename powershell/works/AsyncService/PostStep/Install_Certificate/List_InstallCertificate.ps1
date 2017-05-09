#######################  
<#  
.SYNOPSIS  
 Verifies a certificate file exist and renames them as specified.
.DESCRIPTION  
 Verifies a certificate file exist and renames them as specified.
.EXAMPLE  
.\List_LocalGroups.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

######PROPERTIES######
$CertList=
@(
  ,('fileSig_poeds_dev_soft.pfx', "qwe")
)

Function List_InstallCertificate
{
    try
    {
     $ExecutionDirectory = Get-Location

     for($i=0; $i -lt $CertList.Count; $i++)
     {
      $FilePath = $CertList[$i][0]
      $Password = $CertList[$i][1]

      ######Validate######
      $Job = Start-Job -ScriptBlock {
	 $FilePath = "{1}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Get_InstallCertificate.ps1 -FilePath "$FilePath"              #Call specified script with parameters, if any

      if($Error.Count -gt 0)                                    #Check for errors
      {         	
	throw "Get_InstallCertificate.ps1 FAILED!"
      }
      else { Write-Output "Get_InstallCertificate.ps1 SUCCEEDED!" }
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
	 $Password = "{2}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Set_InstallCertificate.ps1 -FilePath "$FilePath" -Password "$Password"              #Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Set_InstallCertificate.ps1 FAILED!"
         }
         else { Write-Output "Set_InstallCertificate.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$FilePath", "$Password"

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
       Write-Output "List_InstallCertificate Executed Successfully"
    }
}

List_InstallCertificate