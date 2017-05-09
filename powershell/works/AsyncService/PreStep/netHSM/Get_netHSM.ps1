#######################  
<#  
.SYNOPSIS  
 Verifies if a file/folder exists
.DESCRIPTION  
 Verifies if a file/folder exists
.EXAMPLE  
.\Get_netHSM.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
)
    
Function Get_netHSM
{
  try
  {             
     Write-Output "Checking for a netHSM response..."
     $serials =@()

     if(!(Test-Path "Env:NFAST_HOME"))
     {
      throw "netHSM does not exist!  Please install this software."
     }

     $netHSMPath = Get-ChildItem Env:NFAST_HOME
     $netHSMbinPath = $netHSMPath.Value + "\bin"
     $netHSMvalid = $false

     CD $netHSMbinPath
     .\enquiry.exe 2>&1 | foreach-object {if($_.ToString().StartsWith(" serial number")){$serials += $_.ToString()}}

     foreach($serial in $serials)
     {
       $netHSMvalid = $true
       $serial = $serial.Replace("serial number", "").Replace(" ", "")
       if($serial.Contains("unknownunknown") -or $serial -eq "")
       {
	$netHSMvalid = $false
       }
     }

     if(!$netHSMvalid)
     {
        throw "Host is having a problem communicating to netHSM. "
     }
  }
  Catch [system.exception]
  {
	write-output "ERROR: " $_.exception.message
  }
  Finally
  {
	Write-Output "Get_netHSM.ps1 Executed Successfully"
  }
}

Get_netHSM