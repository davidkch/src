#######################  
<#  
.SYNOPSIS  
 Generic script to enable/disable a list of services
.DESCRIPTION  
 Generic script to enable/disable a list of services
.EXAMPLE  
.\Set_Services.ps1 -ServiceName MyServiceName -StateFlag enabled
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
$ServiceName = (throw "Pass name of service to set."),
$StateFlag = (throw "Pass state enabled/disabled.")
)

Function Set_Services
{
   try
   {
      write-output "StateFlag:  $StateFlag"

      $service = Get-Service $ServiceName -ErrorAction SilentlyContinue
      $Error.Clear()

      if($service)
      {
         if ($StateFlag -ieq "disabled")
         {
             #DISABLE Service
   	     write-output "Disabling service $ServiceName..."
             Set-service -Name $ServiceName -StartupType "Disabled" | foreach {$_.Stop()}
         }
         else
         {
             #ENABLE Service
             Write-output "Enabling service $ServiceName..."
             Set-service -Name $ServiceName -StartupType "Automatic" | foreach {$_.Start()}
         }
      }
      else
      {
	 Write-Output "Service $ServiceName is not installed.  Continuing..."
      }
    }
    Catch [system.exception]
    {
       write-output "ERROR: " $_.exception.message
    }
    Finally
    {
	Write-Output "Set_Services.ps1 Executed Successfully"
    }
}

Set_Services -ServiceName $ServiceName -StateFlag $StateFlag