#######################  
<#  
.SYNOPSIS  
 Renames a given list of files
.DESCRIPTION  
 Renames a given list of files
.EXAMPLE  
.\Set_RenameFile.ps1 -FilePath C:\ -OldFileName FileName.log -NewFileName ChangedName.txt
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    $FilePath = (throw "Please pass File Path"),
    $OldFileName = (throw "Please pass Existing File name"),
    $NewFileName = (throw "Please pass new FileName")
)

Function Set_RenameFile
{
    try
    {
      $ExecutionDirectory = Get-Location

      Write-Output ""
      Write-Output "Renaming specified file(s)"
      Write-Output "File path: $FilePath"
      Write-Output "Old File Name: $OldFileName"
      Write-Output "New File Name: $NewFileName" 

      $Job = Start-Job -ScriptBlock {
	 $FilePath = "{1}" -f $args;
	 $OldFileName = "{2}" -f $args;
	 $NewFileName = "{3}" -f $args;

	 Invoke-Expression ("Set-Location {0}" -f $args);          	       #Sets the location of the script to be called
	 .\RenameFile.ps1 -FilePath "$FilePath" -OldFileName "$OldFileName" -NewFileName "$NewFileName"           #Call specified script with parameters, if any

         if($Error.Count -gt 0)                                    #Check for errors
         {         	
	   throw "RenameFiles.ps1 FAILED!"
         }
         else { Write-Output "RenameFiles.ps1 SUCCEEDED!" }
      } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ArgumentList "$ExecutionDirectory", "$FilePath", "$OldFileName", "$NewFileName"

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
	Write-Output "Set_RenameFiles.ps1 Executed Successfully" 
    }
}

Set_RenameFile -FilePath $FilePath -OldFileName $OldFileName -NewFileName $NewFileName