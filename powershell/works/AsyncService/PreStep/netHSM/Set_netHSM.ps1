#######################  
<#  
.SYNOPSIS  
 Currently no actions required to be taken.
.DESCRIPTION  
 Currently no actions required to be taken.
.EXAMPLE  
.\Set_Appseg.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
)

Function Set_netHSM
{
    try
    {
        Write-Output "No change or action required at this time!"
    }
    Catch [system.exception]
    {
	write-output "ERROR: " $_.exception.message
    }
    Finally
    {
        Write-Output "Set_netHSM.ps1 Executed Successfully"
    }
}

Set_netHSM