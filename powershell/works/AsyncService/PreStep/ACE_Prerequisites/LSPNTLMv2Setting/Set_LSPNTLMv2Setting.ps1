#######################  
<#  
.SYNOPSIS  
 Script that updates the registry value for LmCompatibilityLevel (if exists).
.DESCRIPTION  
 Script that updates the registry value for LmCompatibilityLevel (if exists).
.EXAMPLE  
.\Set_LSPNTLMv2Setting.ps1 -Value 5
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
$Value = (throw "Pass value of compatibility level.")
)

Function Set_LSPNTLMv2Setting
{
   try
   {
        Write-Output "Editing registry: Path=HKLM:\SYSTEM\CurrentControlSet\Control\Lsa Name=LmCompatibilityLevel Value=$Value"
        Write-Output Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LmCompatibilityLevel" -Value $Value -Type DWORD
   }
   Catch [system.exception]
   {
      write-output "ERROR: " $_.exception.message
   }
   Finally
   {
      Write-Output "Set_LSPNTLMv2Setting.ps1 Executed Successfully"
   }
}

Set_LSPNTLMv2Setting -Value $Value