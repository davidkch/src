#######################  
<#  
.SYNOPSIS  
 Script that removes all shares on the machine except the ones specified
.DESCRIPTION  
 Script that removes all shares on the machine except the ones specified
.EXAMPLE  
.\Set_RemoveSharesFromSystemDrive.ps1 -KeepShares ShareName -Shares ShareObject
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
$KeepShares = (throw "Pass name of share to keep."),
$Shares = (throw "Pass list of current shares.")
)

Function Set_RemoveSharesFromSystemDrive
{
   try
   {
      Write-Output "Keep shares:  $KeepShares"
      Write-Output "All shares:  $Shares"
      Write-Output "Removing shares from system drive..."
          
      foreach ($share in $Shares)
      {
         $sharename = $share.Name

         if ($KeepShares -notcontains $sharename)
         {
             Write-Output "Removing share... $sharename"
             net share $sharename /Y /DELETE
         }
      }
   }
   Catch [system.exception]
   {
      write-output "ERROR: " $_.exception.message
   }
   Finally
   {
      Write-Output "Set_RemoveSharesFromSystemDrive.ps1 Executed Successfully"
   }
}

Set_RemoveSharesFromSystemDrive -KeepShares $KeepShares -Shares $Shares