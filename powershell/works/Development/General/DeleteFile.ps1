#######################  
<#  
.SYNOPSIS  
 Generic script to delete a specific file.
.DESCRIPTION  
 Generic script to delete a specific file.
.EXAMPLE  
.\DeleteFile.ps1 -FilePath C:\ -FileName FileName.txt
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
    [string] $FilePath = (throw "Please pass File Path"),
    [string] $FileName = (throw "Please pass File name")
)

$LogFile = "DeleteFile.log"

Function DeleteFile
{
 try
 {
  if(Test-Path -isvalid "$FilePath\$FileName")
  {
   write-output "Deleting file..." | Out-File $LogFile
   Remove-Item -path "$FilePath\$FileName" | Out-File $LogFile -Append
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

DeleteFile -FilePath $FilePath -FileName $FileName