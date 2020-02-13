#######################  
<#  
.SYNOPSIS  
 Create local user group
.DESCRIPTION  
 Create local user group
.EXAMPLE  
.\Set_CreateLocalGroups.ps1 -GroupDetails @("TestGroup1", "Test1")
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    $GroupDetails = (throw "Please pass local user group details.")
)

######PROPERTIES######

Function Set_CreateLocalGroups
{
      try
      {
	$ExecutionDirectory = Get-Location

	$Job = Start-Job -ScriptBlock {
	 $LogFile = "{1}" -f $args;
	 $GroupDetails = $args[2]
	 $GroupName = $GroupDetails[0]
	 Write-Output "GROUP: $GroupName"
	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\CreateLocalGroup.ps1 -GroupDetails $GroupDetails               #Call specified script with parameters, if any
        if($Error.Count -gt 0)                                    #Check for errors
        {         	  
	  throw "Set_CreateLocalGroups.ps1 FAILED!" 
        }
        else { Write-Output "Set_CreateLocalGroups.ps1 SUCCEEDED!" }
       } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$LogFile", $GroupDetails

       $ret = Receive-Job $job -Wait -AutoRemoveJob
      }
	Catch [system.exception]
	{
		write-output "ERROR:" $Error
	}
	Finally
	{
		Write-Output "Set_CreateLocalGroups.ps1 Executed Successfully"
	}
}

Set_CreateLocalGroups -GroupName $GroupName