#######################  
<#  
.SYNOPSIS  
 Do Regestry update for auto application discovery tool
.DESCRIPTION  
 Do Regestry update for auto application discovery tool
.EXAMPLE  
.\List_AppID.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

######PROPERTIES######
$Path = "HKLM:\SOFTWARE\MicrosoftIT\CI\Application\APP-7364"

$RegProperties=
@(
 ("$Path", "ITAppName", "Proof Of Eligibility Distribution System (POEDS)", "String"),
 ("$Path", "ITAppVersion", "3.2", "String"),
 ("$Path", "ApplicationID", "APP-7364", "String"),
 ("$Path", "IDSource", "1", "String"),
 ("$Path", "UpdatedBy", "1", "Binary")
)

Function List_AppID
{
    try
    {
      $ExecutionDirectory = Get-Location
     for($i=0; $i -lt $RegProperties.Count; $i++)
     {
      $Path = $RegProperties[$i][0]
      $Name = $RegProperties[$i][1]
      $Value = $RegProperties[$i][2]
      $PropertyType = $RegProperties[$i][3]

      ######Validate######
      $Job = Start-Job -ScriptBlock {
	 $Path = "{1}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Get_AppID.ps1 -Path "$Path"              		#Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Get_AppID.ps1 FAILED!"
         }
         else { Write-Output "Get_AppID.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$Path"

      $ret = Receive-Job $job -Wait -AutoRemoveJob

      foreach($out in $ret)
      {
        Write-Output $out
      }

      if($job.State -ieq 'Failed')
      { exit -1 } 


      ######Change######
      $Job = Start-Job -ScriptBlock {
	 $Path = "{1}" -f $args;
         $Name = "{2}" -f $args;
         $Value = "{3}" -f $args;
         $PropertyType = "{4}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Set_AppID.ps1 -Path "$Path" -Name "$Name" -Value "$Value" -PropertyType "$PropertyType"              #Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
            throw "Set_AppID.ps1 FAILED!"
         }
         else { Write-Output "Set_AppID.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$Path", "$Name", "$Value", "$PropertyType"

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
      Write-Output "ERROR: " $_.exception.message
    }
    Finally
    {
      Write-Output "List_AppID.ps1 Executed Successfully"
    }
}

List_AppID 