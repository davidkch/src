#######################  
<#  
.SYNOPSIS  
 Assigns specified permissions to specified folder/file
.DESCRIPTION  
 Assigns specified permissions to specified folder/file
.EXAMPLE  
.\Set_UpdateFileFolderPermissions.ps1 -Function "grant" -ItemPath 'C:\Folder\File.txt' -TargetAccount "MyAccountName" -Permissions '(RD,X,R)'
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    $Function = (throw "Please pass the "),
    $ItemPath = (throw "Please pass file/folder path w/name."),
    $TargetAccount = (throw "Please pass account you wish to give permissions to."),
    $Permissions = (throw "Please pass set of permissions you wish to give the item.")
)

Function Set_UpdateFileFolderPermissions
{
   try
   {
     $ExecutionDirectory = Get-Location

     Write-Output ""
     Write-Output "Updating permissions for specified file/folder..."
     Write-Output "Function:  $Function"
     Write-Output "ItemPath:  $ItemPath"
     Write-Output "TargetAccount:  $TargetAccount"
     Write-Output "Permissions:  $Permissions"

     $Job = Start-Job -ScriptBlock {
	$Function = "{1}" -f $args;
	$ItemPath = "{2}" -f $args; 
	$TargetAccount = "{3}" -f $args; 
	$Permissions = "{4}" -f $args; 

	Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	.\ManageFolderPermission.ps1 -Function $Function -TargetDir_Path "$ItemPath" -TargetAccount $TargetAccount -Permissions "$Permissions"              #Call specified script with parameters, if any

        if($Error.Count -gt 0)                                    #Check for errors
        {         	
	  throw "ManageFolderPermission.ps1 FAILED!"
        }
        else { Write-Output "ManageFolderPermission.ps1 SUCCEEDED!" }
     } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$Function", "$ItemPath", "$TargetAccount", "$Permissions"

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
    Write-Output "Set_UpdateFileFolderPermissions.ps1 Executed Successfully"
  }
}

Set_UpdateFileFolderPermissions -Function $Function -ItemPath $ItemPath -TargetAccount $TargetAccount -Permissions $Permissions