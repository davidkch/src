#######################  
<#  
.SYNOPSIS  
 Generic script to rename a specific file.
.DESCRIPTION  
 Generic script to rename a specific file.
.EXAMPLE  
.\RenameFile.ps1 -FilePath C:\ -OldFileName FileName.log -NewFileName ChangedName.txt
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
    [string] $FilePath = (throw "Please pass File Path"),
    [string] $OldFileName = (throw "Please pass Existing File name"),
    [string] $NewFileName = (throw "Please pass new FileName")
)

$LogFile = "RenameFile.log"

Function RenameFile
{
 try
 {
  if(Test-Path -isvalid "$FilePath\$OldFileName")
  {
   write-output "Renaming file..." | Out-File $LogFile
   Rename-Item -path "$FilePath\$OldFileName" -newname "$NewFileName" | Out-File $LogFile -Append
  }
  else
  {
   throw "File does not exist!" | Out-File $LogFile -Append
  }
 }
 Catch [system.exception]
 {
  write-output $_.exception.message | Out-File $LogFile -Append
  write-host $_.exception.message
 }
 Finally
 {
  "Completed Successfully" | Out-File $LogFile -Append
 }
}

RenameFile -FilePath $FilePath -OldFileName $OldFileName -NewFileName $NewFileName