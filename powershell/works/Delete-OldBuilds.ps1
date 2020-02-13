<#  
.SYNOPSIS  
 This script is for deleting old builds (more than 10 days old) in the release or TeamBuild folder 

.DESCRIPTION  
 This script is for deleting old builds (more than 10 days old) in the release or TeamBuild folder 
 it expecting release\<branch>\<project>\<build> folder structure
 log file will create in release folder

.EXAMPLE  
.\Delete-OldBuilds.ps1 f:\release
.\Delete-OldBuilds.ps1 d:\TeamBuild

#>  


param(
    ## parent folder to delete
    [Parameter(Mandatory = $true)]
    $releaseFolder
)

$timestamp = Get-Date -Format o | foreach {$_ -replace ":", "."}
$tempstamp = Get-Random

$LogFile ="$releaseFolder\deleteLog_$timestamp.txt"
Write-Output $null | Out-File -Encoding utf8 $LogFile

$tempFolder = "$env:TEMP\DeleteTemp_$tempstamp"

Function Delete-OldBuilds
{
    try
    {
        Set-Location $releaseFolder

        New-Item -Path $tempFolder -Type Directory

        $branchFolders = Get-ChildItem $releaseFolder -Directory
        $projectFolders = Get-ChildItem $branchFolders.FullName -Directory
        $buildFolders = Get-ChildItem $projectFolders.FullName -Directory

        # remove old log file
        if (Test-Path $releaseFolder\deleteLog_*.txt -PathType Leaf)
        {
            Remove-Item  $releaseFolder\deleteLog_*.txt -Force
        }
        
        foreach ($build in $buildFolders)
        {
            $howOld = ((Get-Date) - $build.CreationTime).Days
            if ($howOld -gt 10 -and $build.PsISContainer -eq $True)
            {
                #$build.Delete() | Out-File -Encoding utf8 $LogFile
                # using robocopy /mir for dealing with long path
                robocopy $tempFolder $build.FullName /MIR /R:10 /LOG+:$LogFile 
                Remove-Item $build.FullName -Force
            }        
        }

        Remove-Item $tempFolder -Force
       
    }
    catch
    {
        write-host $_.exception.message
        Write-Output $_.exception.message | Out-File -Encoding utf8 -Append $LogFile
    }

}

Delete-OldBuilds $releaseFolder
