#######################  
<#  
.SYNOPSIS  
 Verifies if a website exists
.DESCRIPTION  
 Verifies if a website exists
.EXAMPLE  
.\Get_UpdateWebsiteBindings.ps1 -Website POEDS
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    $Website = (throw "Please pass the website name.")
)

Function Get_UpdateWebsiteBindings
{
  try
  {
     write-output "Website: $Website" 
             
     $output = Invoke-Expression "$Env:windir\system32\inetsrv\appcmd.exe list site '$Website'"

     #write-output "Result:  $output" 
     
     if($output -match "$Website")
     {
       Write-Output "Website exists!  Continuing configuration process..."
     }
     else
     {
       throw "Website does not exist!  Exiting process..." 
     }
  }
  Catch [system.exception]
  {
	write-output $_.exception.message 
  }
  Finally
  {
	Write-Output "Get_UpdateWebsiteBindings.ps1 Executed Successfully" 
  }
}

Get_UpdateWebsiteBindings  -Website $Website