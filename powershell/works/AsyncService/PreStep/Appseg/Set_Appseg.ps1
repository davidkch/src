#######################  
<#  
.SYNOPSIS  
 Currently no actions required to be taken.
.DESCRIPTION  
 Currently no actions required to be taken.
.EXAMPLE  
.\Set_Appseg.ps1 -ServerList "Server1;Server2"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
  $ServerList = (throw "Please pass ServerList.  List of servers.")
)

Function Set_Appseg
{
    try
    {
        Write-Output "Currently no actions required to set with!"
    }
    Catch [system.exception]
    {
	write-output "ERROR: " $_.exception.message
    }
    Finally
    {
	Write-Output "Set_Appseg.ps1 Executed Successfully"
    }
}

Set_Appseg -ServerList $ServerList