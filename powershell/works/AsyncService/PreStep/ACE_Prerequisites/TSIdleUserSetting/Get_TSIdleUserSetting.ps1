#######################  
<#  
.SYNOPSIS  
 Script to verify if current key value matches required key value
.DESCRIPTION  
 Script to verify if current key value matches required key value
.EXAMPLE  
.\Get_TSIdleUserSetting.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
$expectedfInheritMaxIdleTime = $(throw "Pass expectedfInheritMaxIdleTime."),
$expectedMaxIdleTime = $(throw "Pass expectedfInheritMaxIdleTime."),
$fInheritMaxIdleTime = $(throw "Pass fInheritMaxIdleTime."),
$maxIdleTime = $(throw "Pass maxIdleTime.")
)

Function Get_TSIdleUserSetting
{
  try
  {    
    $actualfInheritMaxIdleTime = $fInheritMaxIdleTime
    $actualMaxIdleTime = $maxIdleTime

    #Verify if keys exist and exit if not
    if ( ! $fInheritMaxIdleTime )
    {
      throw "fInheritMaxIdleTime registry key is not present on this computer."
    }
    elseif ( ! $maxIdleTime )
    {
      throw "MaxIdleTime registry key is not present on this computer."
    }

    if (($actualfInheritMaxIdleTime -ne $expectedfInheritMaxIdleTime) -or ($actualMaxIdleTime -ne $expectedMaxIdleTime))
    {  
       Write-output "Terminal Services is not set to expire after 30 Minutes.  Continuing...."
    }

    if (($actualfInheritMaxIdleTime -eq $expectedfInheritMaxIdleTime) -and ($actualMaxIdleTime -eq $expectedMaxIdleTime))
    {
       Write-Output "Terminal Services are already set.  Continuing...."
    }
  }
  Catch [system.exception]
  {
	write-output "ERROR: " $_.exception.message
  }
  Finally
  {
	Write-Output "Get_TSIdleUserSetting.ps1 Executed Successfully"
  }
}

Get_TSIdleUserSetting -expectedfInheritMaxIdleTime $expectedfInheritMaxIdleTime -expectedMaxIdleTime $expectedMaxIdleTime -fInheritMaxIdleTime $fInheritMaxIdleTime -maxIdleTime $maxIdleTime