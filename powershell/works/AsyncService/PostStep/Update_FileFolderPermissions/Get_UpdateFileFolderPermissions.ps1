#######################  
<#  
.SYNOPSIS  
 Verifies if a file/folder exists
.DESCRIPTION  
 Verifies if a file/folder exists
.EXAMPLE  
.\Get_UpdateFileFolderPermissions.ps1 -
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    $ItemPath = (throw "Please pass file/folder path w/name.")
)

Function Get_UpdateFileFolderPermissions
{
  try
  {             
     Write-Output ""
     if(Test-Path "$ItemPath" -PathType Container)
     { 
       Write-Output "Verifying if folder exists..."
       Write-Output "Folder:  $ItemPath"
        
       if(Test-Path "$ItemPath")
       { Write-Output "Directory exists!  Continuing process..." }
       else
       { throw "ERROR:  Directory does not exist!  Exiting process..." }
     }
     elseif(Test-Path "$ItemPath" -PathType Leaf)
     {
       Write-Output "Verifying if file exists..."
       Write-Output "File:  $ItemPath"
        
       if(Test-Path "$ItemPath")
       { Write-Output "File exists!  Continuing process..." }
       else
       { throw "ERROR:  File does not exist!  Exiting process..." }
     }
     else
     { 
	Write-Output "Item specified:  $ItemPath"
	throw "ERROR:  Item not found!  Please verify the path/name is correct." 
     }
  }
  Catch [system.exception]
  {
    write-output "ERROR: " $_.exception.message
  }
  Finally
  {
	Write-Output "Get_UpdateFileFolderPermissions.ps1 Executed Successfully"
  }
}

Get_UpdateFileFolderPermissions -ItemPath $ItemPath