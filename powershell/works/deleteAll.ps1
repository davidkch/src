<#  
.SYNOPSIS  
 Generic script to delete files and folders from virtual drive.

.DESCRIPTION  
 Generic script to delete files and folders from virtual drive.

.EXAMPLE  
.\deleteAll.ps1 <drive letter> <assigned root directory>

$drive - just one letter that you want to assign to PSDrive (Ex: S )
$root  - top folder that you want assign to the PSDrive (Ex: d:\TB\Scan\ScanNDFortify\12345 )

#>  


param (
    [string] $drive = $(throw "Pass the drive letter: Ex: S"),
    [string] $root = $(throw "Pass the root folder: Ex: d:\TB\scan\12345")
)

 
Function DeleteAll 
{

    try
    {
        # create a PSDrive with give drive letter and root folder
        New-PSDrive -Name $drive -PSProvider FileSystem -Root $root  | Out-Null

        $filedrive = $drive + ":"

        # looping recursively and remove all readonly attribute
        foreach ($item in Get-ChildItem $filedrive -Force -Recurse -ReadOnly)
        {
           attrib $item.FullName -R 
        }

        # delete all files and folders from PSDrive
        Remove-Item $filedrive -Force -Recurse

        # remove PSDrive 
        # Remove-PSDrive -Name $drive
    }
    catch
    {
        write-host $_.exception.message
    }

} 

DeleteAll $drive $root


