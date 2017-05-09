#######################  
<#  
.SYNOPSIS  
 Verifies if a registry key exists and removes it if it does.
.DESCRIPTION  
 Verifies if a registry key exists and removes it if it does.
.EXAMPLE  
.\Get_AppID.ps1 -Path "HKEY:\MyReg" -Key "MyKey"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    $Path = $(throw "Please pass ItemList.  List of servers.")
)

Function Get_AppID
{
  try
  {            
    Write-Output ""
    Write-Output "Validating existance of registry key..."
    Write-Output "PATH: $Path"

    # dropping existing regestry item and re-create it.
    if((Test-Path -Path "$Path") -eq $true)
    {
        Remove-Item -Path "$Path" -force
    }
  }
  Catch [system.exception]
  {
	write-output "ERROR: " $_.exception.message
  }
  Finally
  {
	Write-Output "Get_AppID.ps1 Executed Successfully"
  }
}

Get_AppID -Path $Path