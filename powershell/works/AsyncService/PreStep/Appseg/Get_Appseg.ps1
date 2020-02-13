#######################  
<#  
.SYNOPSIS  
 Verifies if a file/folder exists
.DESCRIPTION  
 Verifies if a file/folder exists
.EXAMPLE  
.\Get_Appseg.ps1 -ServerList "Server1,Server2"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    $ServerList = (throw "Please pass ItemList.  List of servers.")
)
    
Function Get_Appseg
{
  try
  {             
    Write-Output "Validating AppSeg..."
    Write-Output "Server List:  $ServerList"
    
    foreach ($ServerName in $ServerList.Split(',').Trim()) 
    {
     $serverPath = "\\" + $ServerName + "\c$"
     if (!(Test-Path "$serverPath"))  
     {  
       throw "Server is not accessible:  $ServerName"
     } 
     else 
     {
        Write-Output "Server $ServerName is validated: OK."
     }
   }
  }
  Catch [system.exception]
  {
	write-output "ERROR: " $_.exception.message
  }
  Finally
  {
	Write-Output "Get_Appseg.ps1 Executed Successfully"
  }
}

Get_Appseg -ServerList $ServerList