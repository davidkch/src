#######################  
<#  
.SYNOPSIS  
 Verifies a file exists
.DESCRIPTION  
 Verifies a file exists
.EXAMPLE  
.\Get_InstallDLL.ps1 -BinaryPath "C:\MyDLL.dll"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    $BinaryPath = (throw "Please pass path and name of DLL you wish to verify.")
)

Function Get_InstallBinary
{
  try
  {             
     Write-Output "Verifying if binary exists..." 
     Write-Output "Binary:  $BinaryPath"

     if(Test-Path "$BinaryPath")
     {  
       Write-Output "File exists!  Continuing process..." 
     }
     else
     {
       throw "File $BinaryPath does not exist!  Exiting process..." 
     }
  }
  Catch [system.exception]
  {
	write-output "ERROR: " $_.exception.message 
  }
  Finally
  {
	Write-Output "Get_InstallBinary.ps1 Executed Successfully" 
  }
}

Get_InstallBinary -BinaryPath $BinaryPath