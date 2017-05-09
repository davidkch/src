#######################  
<#  
.SYNOPSIS  
 Script that verifies the registry value for LmCompatibilityLevel matches specified value or returns true if the key does not exist.
.DESCRIPTION  
 Script that verifies the registry value for LmCompatibilityLevel matches specified value or returns true if the key does not exist.
.EXAMPLE  
.\Get_LSPNTLMv2Setting.ps1 -Value 5
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
$Value = (throw "Pass value of compatibility level.")
)

Function Get_LSPNTLMv2Setting
{
  try
  {             
     Write-Output "Verifying LM compatibility level..."
     
     $lmCompatibilityLevel = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LmCompatibilityLevel" -ErrorAction SilentlyContinue
     if ( ! $lmCompatibilityLevel )
     {
        throw "LmCompatibilityLevel registry key is not present on this computer."
     }
     else
     {
        $actualLmCompatibilityLevel = $lmCompatibilityLevel.LmCompatibilityLevel

        if ($actualLmCompatibilityLevel -ne $value)
        {  
            Write-Output "Local Security Policy is not set to support only NTLMv2.  Continuing...."
        }  
     }   
  }
  Catch [system.exception]
  {
	write-output "ERROR: " $_.exception.message  
  }
  Finally
  {
	Write-Output "Get_LSPNTLMv2Setting.ps1 Executed Successfully"
  }
}

Get_LSPNTLMv2Setting -Value $Value