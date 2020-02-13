#######################  
<#  
.SYNOPSIS  
 Generic script to verify if a service exists and if it is enabled/disabled
.DESCRIPTION  
 Generic script to verify if a service exists and if it is enabled/disabled
.EXAMPLE  
.\Get_Services.ps1 -ServiceName MyServiceName -StateFlag disabled
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
$ServiceName = (throw "Pass name of service to verify."),
$StateFlag = (throw "Pass state enabled/disabled.")
)

Function Get_Services
{
  try
  {        
    Write-Output "Searching for service $ServiceName..."
    $service = Get-Service $ServiceName -ErrorAction SilentlyContinue
    $Error.Clear()

    if(!$service)
    {
     Write-Output "$ServiceName service is not installed on this computer."

     if($StateFlag -ine "disabled")
     {
      throw "ERROR:  Service $ServiceName must be installed to take this action:  $StateFlag"
     }
    }
    else
    {
      Write-Output "$ServiceName service found."
        
      $startType = Get-WmiObject -Query "Select StartMode From Win32_Service Where Name='$($ServiceName)'"  
   
      if ($startType.StartMode -ine "$StateFlag")
      {  
        Write-Output "$ServiceName service is not $StateFlag."
      }  
      else
      {
        Write-Output "$ServiceName service is already $StateFlag."
      }
    }
  }
  Catch [system.exception]
  {
	write-output $_.exception.message
  }
  Finally
  {
	Write-Output "Get_Services.ps1 Executed Successfully"
  }
}

Get_Services -ServiceName $ServiceName -StateFlag $StateFlag