#######################  
<#  
.SYNOPSIS  
 Verifies if a share exists
.DESCRIPTION  
 Verifies if a share exists
.EXAMPLE  
.\Get_RenameFile.ps1 -SharePath C:\MyShare
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    $SharePath = (throw "Please pass share path/name.")
)

Function Get_CreateShares
{
  try
  {             
     Write-Output "Verifying if share(s) exist..."
     Write-Output "Share:  $SharePath"

     if(Test-Path "$SharePath")
     {  
       Write-Output "Share path:  $SharePath"
       Write-Output "Share exists!  Recreating directory..."
       Remove-Item "$SharePath" -Force -Recurse
       New-Item -type Directory "$SharePath"
     }
     else
     {
       Write-Output "Share path:  $SharePath"
       Write-Output "Share does not exist! Creating directory..."
       New-Item -type Directory "$SharePath"
     }
  }
  Catch [system.exception]
  {
	write-output "ERROR: " $_.exception.message
  }
  Finally
  {
	Write-Output "Get_CreaseShares.ps1 Executed Successfully"
  }
}

Get_CreateShares -SharePath $SharePath