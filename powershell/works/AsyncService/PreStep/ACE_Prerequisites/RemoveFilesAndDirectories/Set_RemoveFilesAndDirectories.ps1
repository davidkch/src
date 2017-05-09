#######################  
<#  
.SYNOPSIS  
 Script that removes all specified files/folders on the machine
.DESCRIPTION  
 Script that removes all specified files/folders on the machine
.EXAMPLE  
.\Set_RemoveFilesAndDirectories.ps1 -ItemListReq C:\TestFolder\
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
$ItemListReq = (throw "Pass name of files/folders to keep.")
)

Function Set_RemoveFilesAndDirectories
{
    try
    {
       Write-Output ""
       Write-Output "Removing specified files and directories..."
        
       foreach ($itemReq in $ItemListReq)
       {
         #If item exists, remove it
         if ( Test-Path $itemReq )
         { 
             Write-Output "Removing item... $itemReq"
             remove-item $itemReq -recurse
         }
       }

       Write-Output "All specified files/folders were removed and/or do not exist."
    }
    Catch [system.exception]
    {
       write-output "ERROR: " $_.exception.message
    }
    Finally
    {
       Write-Output "Set_RemoveFilesAndDirectories.ps1 Executed Successfully"
   }
}

Set_RemoveFilesAndDirectories -ItemListReq $ItemListReq