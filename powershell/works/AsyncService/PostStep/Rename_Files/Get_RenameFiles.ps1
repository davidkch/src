#######################  
<#  
.SYNOPSIS  
 Verifies a file exists
.DESCRIPTION  
 Verifies a file exists
.EXAMPLE  
.\Get_RenameFile.ps1 -FilePath C:\ -OldFileName FileName.log
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    $FilePath = (throw "Please pass File Path"),
    $OldFileName = (throw "Please pass Existing File name")
)

Function Get_RenameFile
{
  try
  {             
     Write-Output ""
     Write-Output "Verifying if file(s) exist..."

     if(Test-Path "$FilePath\$OldFileName")
     {  
       Write-Output "File to rename:  $FilePath\$OldFileName" 
       Write-Output "File exists!  Continuing renaming process..." 
     }
     else
     {
       Write-Output "File to rename:  $FilePath\$OldFileName" 
       throw "File $OldFileName does not exist!  Exiting renaming process..." 
     }
  }
  Catch [system.exception]
  {
	write-output "ERROR: " $_.exception.message
  }
  Finally
  {
	Write-Output "Get_RenameFiles.ps1 Executed Successfully" 
  }
}

Get_RenameFile -FilePath $FilePath -OldFileName $OldFileName -NewFileName $NewFileName