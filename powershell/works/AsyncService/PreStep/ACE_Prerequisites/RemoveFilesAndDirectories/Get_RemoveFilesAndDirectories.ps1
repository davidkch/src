#######################  
<#  
.SYNOPSIS  
 Script that removes all specified files/folders on the machine
.DESCRIPTION  
 Script that removes all specified files/folders on the machine
.EXAMPLE  
.\Get_RemoveFilesAndDirectories.ps1 -ItemListReq C:\TestFolder\
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
$ItemListReq = (throw "Pass list of file/folders to remove.")
)

Function Get_RemoveFilesAndDirectories
{
  try
  {     
     Write-Output ""
     Write-Output "Searching for specified File/Directory..."

     foreach ($itemReq in $ItemListReq)
     {
        if ( Test-Path $itemReq )
        {
           Write-Output "Specified file or directory found:  $itemReq"
        }
        else
        {
           Write-Output "Specified file or directory not found:  $itemReq"
        }
     }
  }
  Catch [system.exception]
  {
	write-output "ERROR: " $_.exception.message
  }
  Finally
  {
	Write-Output "Get_RemoveFilesAndDirectories.ps1 Executed Successfully"
  }
}

Get_RemoveFilesAndDirectories -ItemListReq $ItemListReq