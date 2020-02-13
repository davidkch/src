<#  
.SYNOPSIS  
 Generic script that delete more than 10 days old builds from project folders 

.DESCRIPTION  
 Generic script that delete more than 10 days old builds from project folders 
 It check projects in release folder then enumerate builds in project folders and delete them if the build folder older than 10 days

.EXAMPLE  
.\Delete-OldFolders.ps1 f:\release

#>  


param(
    ## parent folder to delete
    [Parameter(Mandatory = $true)]
    $TargetReleaseFolder
)

$LogFile =".\deleteOldFolders.log"
Write-Output $null | Out-File -Encoding utf8 $LogFile
$tempFolder = "C:\DeleteOld_Temp"

Function Delete-OldFolders
{
    try
    {
        Set-Location $TargetReleaseFolder

        if (Test-Path $tempFolder)
        {
           # New-Item -Path C:\DeleteOld_Temp -Type Directory
        }

        $ProjectFolders = Get-ChildItem $TargetReleaseFolder -Directory
        


        #foreach ($builds in $ProjectFolders)
        #{
            #Set-Location $project

            #$BuildFloders = Get-ChildItem $project -Directory


            foreach ($build in $ProjectFolders)
            {
                if (Test-Path $build)
                {
                    $howOld = ((Get-Date) - $build.CreationTime).Days
                    if ($howOld -gt 10 -and $build.PsISContainer -eq $True)
                    {
                        #$folder.Delete() | Out-File -Encoding utf8 $LogFile
                        # using robocopy /mir for long path
                        Write-Host $build.FullName
                        #robocopy $tempFolder $build.FullName /MIR /R:10 /LOG+:$LogFile 
                        #Remove-Item $build.FullName -Force
                    }
                }
            }
        #}

        Remove-Item $tempFolder -Force
       
    }
    catch
    {
        write-host $_.exception.message
        Write-Output $_.exception.message | Out-File -Encoding utf8 -Append $LogFile
    }

}

Delete-OldFolders $TargetReleaseFolder
