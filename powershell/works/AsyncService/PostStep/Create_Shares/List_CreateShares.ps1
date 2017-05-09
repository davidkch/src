#######################  
<#  
.SYNOPSIS  
 Verifies a certificate file exist and renames them as specified.
.DESCRIPTION  
 Verifies a certificate file exist and renames them as specified.
.EXAMPLE  
.\List_CreateShares.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

######PROPERTIES######
$ShareParamList=
@(
  ,("ASDATA", "D:\LOG\AS\DATA", "IBBAsyncServiceUsers" , "FULL", "IBB Pickup share")
  ,("ASERROR", "D:\LOG\AS\ERROR", "IBBAsyncServiceUsers", "FULL", "IBB ERROR")
)

Function List_CreateShares
{
    try
    {
     $ExecutionDirectory = Get-Location

     for($i=0; $i -lt $ShareParamList.Count; $i++)
     {
      $ShareName = $ShareParamList[$i][0]
      $SharePath = $ShareParamList[$i][1]
      $ServiceAccount = $ShareParamList[$i][2]
      $AccessLevel = $ShareParamList[$i][3]
      $Remark = $ShareParamList[$i][4]

      Write-Output ""
      Write-Output "###SETTING UP SHARE:  $ShareName###"
      Write-Output "SHARE NAME: $ShareName"
      Write-Output "SHARE PATH: $SharePath"
      Write-Output "SERVICE ACCOUNT: $ServiceAccount"
      Write-Output "ACCESS LEVEL: $AccessLevel"
      Write-Output "REMARK: $Remark"
      Write-Output ""

      ######Validate######
      Write-Output "verifying directory `"$SharePath`" exists..."
      $Job = Start-Job -ScriptBlock {
	 $LogFile = "{1}" -f $args;
	 $SharePath = "{2}" -f $args;
	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Get_CreateShares.ps1 -SharePath "$SharePath"              #Call specified script with parameters, if any

      if($Error.Count -gt 0)                                    #Check for errors
      {         	
	throw "Get_CreateShares.ps1 FAILED!"
      }
      else { Write-Output "Get_CreateShares.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$LogFile", "$SharePath"

      $ret = Receive-Job $job -Wait -AutoRemoveJob

      foreach($out in $ret)
      {
        Write-Output $out
      }

      if($job.State -ieq 'Failed')
      { exit -1 } 

      ######Change######
      Write-Output "Creating share for $SharePath..."
      $Job = Start-Job -ScriptBlock {
	 $LogFile = "{1}" -f $args;
	 $ShareName = "{2}" -f $args;
	 $SharePath = "{3}" -f $args;
	 $ServiceAccount = "{4}" -f $args;
	 $AccessLevel = "{5}" -f $args;
	 $Remark = "{6}" -f $args;
	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\Set_CreateShares.ps1 -ShareName $ShareName -SharePath $SharePath -ServiceAccount $ServiceAccount -AccessLevel $AccessLevel -Remark $Remark              #Call specified script with parameters, if any
        if($Error.Count -gt 0)                                    #Check for errors
        {          	  
	  throw "Set_CreateShares.ps1 FAILED!"
        }
        else { Write-Output "Set_CreateShares.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$LogFile", $ShareName, $SharePath, $ServiceAccount, $AccessLevel, $Remark

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
	   return $true
	}
	Finally
	{
	   Write-Output "List_CreateShares.ps1 Executed Successfully"
	}
}

List_CreateShares