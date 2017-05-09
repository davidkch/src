<#  
.SYNOPSIS  
 Generic script to delete files and folders from virtual drive.

.DESCRIPTION  
 Generic script to delete files and folders from virtual drive.

.EXAMPLE  
.\deleteAll.ps1 <drive letter> 

                <drive letter> - just one letter that you want to assign to PSDrive (Ex: S )
#>  


param (
    [string] $drive = $(throw "Pass the drive letter: Ex: S")
)
 
Function DeleteAll 
{
    try
    {
        $filedrive = $drive + ":"

        foreach ($item in Get-ChildItem $filedrive -Force -Recurse -ReadOnly)
        {
           attrib $item.FullName -R 
        }

        # delete all files and folders from PSDrive
        Remove-Item $filedrive -Force -Recurse

    }
    catch
    {
        write-host $_.exception.message
    }
} 

DeleteAll $drive 


