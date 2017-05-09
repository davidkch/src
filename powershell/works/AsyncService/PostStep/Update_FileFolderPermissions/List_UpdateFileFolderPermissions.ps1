#######################  
<#  
.SYNOPSIS  
 Verifies files/folders exist and assigns them permissions as specified.
.DESCRIPTION  
 Verifies files/folders exist and assigns them permissions as specified.
.EXAMPLE  
.\List_UpdateFileFolderPermissions.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

######PROPERTIES######
$ItemList=
@(
  ,('D:\POEDS\AsyncService\SalesOrderWorkflowAdapter.svc', "grant", "IBBAsyncServiceUsers", '(RD,X,R)')
  ,('D:\POEDS\AsyncService\SlkCallbackService.svc', "grant", "SLKAsyncServiceUsers", '(RD,X,R)')
  ,('D:\POEDS\AsyncService\DownstreamMessageAdapter.svc', "grant", "POEDSAsyncServiceUsers", '(RD,X,R)')
  ,('D:\POEDS\AsyncService\AsyncPingAdapter.svc', "grant", "POEDSAsyncServiceUsers", '(RD,X,R)')
  ,('D:\POEDS\AsyncService\AsyncPingAdapter.svc', "grant", "POEDSPingUsersAS", '(RD,X,R)')
  ,('D:\LOG\AS\DATA', "grant", "IBBAsyncServiceUsers", '(OI)(CI)F')
  ,('D:\LOG\AS\ERROR', "grant", "IBBAsyncServiceUsers", '(OI)(CI)F')
  ,('D:\POEDS\AsyncService', "deny", "IIS_IUSRS", '(OI)(CI)(WD,AD,WA,WEA)')
  ,('D:\POEDS\rootWeb', "deny", "IIS_IUSRS", '(OI)(CI)(WD,AD,WA,WEA)')
)

Function List_UpdateFileFolderPermissions
{
    try
    {
     $ExecutionDirectory = Get-Location

     for($i=0; $i -lt $ItemList.Count; $i++)
     {
      $ItemPath = $ItemList[$i][0]
      $Function = $ItemList[$i][1]
      $TargetAccount = $ItemList[$i][2]
      $Permissions = $ItemList[$i][3]

      #######Validate#######
      $Job = Start-Job -ScriptBlock {
	 $LogFile = "{1}" -f $args;
	 $ItemPath = "{2}" -f $args;
	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Get_UpdateFileFolderPermissions.ps1 -ItemPath "$ItemPath"              #Call specified script with parameters, if any

      if($Error.Count -gt 0)                                    #Check for errors
      {         	
	throw "Get_UpdateFileFolderPermissions.ps1 FAILED!"
      }
      else { Write-Output "Get_UpdateFileFolderPermissions.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$LogFile", "$ItemPath"

      $ret = Receive-Job $job -Wait -AutoRemoveJob

      foreach($out in $ret)
      {
        Write-Output $out
      }

      if($job.State -ieq 'Failed')
      { exit -1 } 


      #######Change#######
      $Job = Start-Job -ScriptBlock {
	 $LogFile = "{1}" -f $args;
	 $Function = "{2}" -f $args;
	 $ItemPath = "{3}" -f $args;
	 $TargetAccount = "{4}" -f $args;
	 $Permissions = "{5}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Set_UpdateFileFolderPermissions.ps1 -Function $Function -ItemPath "$ItemPath" -TargetAccount "$TargetAccount" -Permissions "$Permissions"            #Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "Set_UpdateFileFolderPermissions.ps1 FAILED!"
         }
         else { Write-Output "Set_UpdateFileFolderPermissions.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$LogFile", "$Function", "$ItemPath", "$TargetAccount", "$Permissions"

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
      Write-Output "List_UpdateFileFolderPermissions.ps1 Executed Successfully"
    }
}

List_UpdateFileFolderPermissions