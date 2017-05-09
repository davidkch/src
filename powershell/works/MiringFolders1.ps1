<#  
.SYNOPSIS  
 Generic script to delete given folder 

.DESCRIPTION  
 Generic script to delete given folder ,all sub folders and files. It doesn't necessarily to create a virtual drive in order to solve the longpath problems.

.EXAMPLE  
.\MiringForders.ps1 d:\TeamBuild\Scan\ScanNDFortiey

#>  


param(
    ## top folder to delete
    [Parameter(Mandatory = $true)]
    $FoldersToDelete
)

$LogFile ="c:\logs\deleteFolders.log"

Function MiringFolders
{
    try
    {
        $tempFolder = New-Item -Path C:\Delete_Temp -Type Directory

        robocopy $tempFolder $FoldersToDelete /MIR /R:10 /LOG:$LogFile 

        Remove-Item $tempFolder -Force

        Remove-Item $FoldersToDelete -Force
    }
    catch
    {
        write-host $_.exception.message
        Write-Output $_.exception.message | Out-File -Encoding utf8 -Append $LogFile
    }

}

MiringFolders $FoldersToDelete
