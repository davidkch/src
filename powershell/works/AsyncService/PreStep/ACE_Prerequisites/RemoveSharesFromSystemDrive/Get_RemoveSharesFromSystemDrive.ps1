#######################  
<#  
.SYNOPSIS  
 Script that removes all shares on the machine except the ones specified
.DESCRIPTION  
 Script that removes all shares on the machine except the ones specified
.EXAMPLE  
.\Get_RemoveSharesFromSystemDrive.ps1 -ServiceName MyServiceName -StateFlag disabled
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
$KeepShares = (throw "Pass name of share to keep."),
$Shares = (throw "Pass list of current shares.")
)

Function Get_RemoveSharesFromSystemDrive
{
  try
  {        
	Write-Output ""

        if ( $Shares -eq $null )
        {
            Write-Output "No shares exist."
        }
        
        foreach ($share in $Shares)
        {
            Write-Output "SHARE EXISTS: $share"

            if ($KeepShares -notcontains $share.Name)
            {
                $HelpText = "Windows shares which must be removed from system drive:  " + $share.Name
                Write-Output $HelpText
            }
        }
  }
  Catch [system.exception]
  {
	write-output $_.exception.message
  }
  Finally
  {
	Write-Output "Get_RemoveSharesFromSystemDrive.ps1 Executed Successfully"
  }
}

Get_RemoveSharesFromSystemDrive -KeepShares $KeepShares -Shares $Shares