#######################  
<#  
.SYNOPSIS  
 Verifies a file exists
.DESCRIPTION  
 Verifies a file exists
.EXAMPLE  
.\Get_RenameFile.ps1 -FilePath C:\ -OldFileName FileName.log -NewFileName ChangedName.txt
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    $FilePath = (throw "Please pass File Path")
)

Function Get_InstallCertificate
{
  try
  {             
     Write-Output ""
     Write-Output "Verifying if certificate file(s) exist..." 

     if(Test-Path "$FilePath")
     {  
       Write-Output "Certificate file path:  $FilePath" 
       Write-Output "File exists!  Continuing process..." 
     }
     else
     {
       Write-Output "Certificate file path:  $FilePath" 
       throw "File does not exist!  Exiting process..." 
     }
  }
  Catch [system.exception]
  {
	write-output "ERROR: " $_.exception.message 
  }
  Finally
  {
	Write-Output "Get_InstallCertificate.ps1 Executed Successfully" 
  }
}

Get_InstallCertificate -FilePath $FilePath