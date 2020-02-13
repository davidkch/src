#######################  
<#  
.SYNOPSIS  
 Script to verify if current key value matches required key value
.DESCRIPTION  
 Script to verify if current key value matches required key value
.EXAMPLE  
.\Get_TSEncryptionLevelSetting.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
$expectedEncryptionLevel = $(throw "Pass expected encryption level."),
$actualEncryptionLevel = $(throw "Pass actual encryption level.")
)

Function Get_TSEncryptionLevelSetting
{
  try
  {    
    if ($actualEncryptionLevel -ne $expectedEncryptionLevel)
    {  
      Write-Output "Terminal Services is not set to high encryption level.  Continuing...."
    }  
    else
    {
      Write-Output "Encryption level matches expected level.  Continuing...."
    }
  }
  Catch [system.exception]
  {
	write-output "ERROR: " $_.exception.message
  }
  Finally
  {
	Write-Output "Get_TSEncryptionLevelSetting.ps1 Executed Successfully"
  }
}

Get_TSEncryptionLevelSetting -expectedEncryptionLevel $expectedEncryptionLevel -actualEncryptionLevel $actualEncryptionLevel