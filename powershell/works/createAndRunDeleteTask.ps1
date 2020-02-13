<#
.SYNOPSIS
    Create a scheduled task that running Delete-OldBuilds.ps1 to the servers listed in a .CSV file

.Description
    The .CSV file should have contains  server, releaseFolder fields like below
    This script requires Delete-OldBuilds.ps1 and serverList.csv file along with this scipt.
    You can selectively run SCHTASKS when you commented out other SCHTASKS below (create/run/delete)
    
    Ex for serverList.csv
    ---------------------

    server, releaseFolder
    hbi-8, d:\teambuild
    hbi-4, d:\teambuild
    tk-06, f:\release

.EXAMPLE
    .\creatAndRunDeleteTask.ps1 <serverList.csv>
#>

param(
    ## The credential to use when connecting
   $serversList = $(throw "Pass the .CSV file name that has a target server list")
)

$credential = Get-Credential 

$domainName = "redmond"
$username = $credential.UserName
$password = $credential.GetNetworkCredential().Password 

$LogFile = ".\ScheduleTaskLog.txt"
Write-Output $null | Out-File -Encoding utf8 $LogFile

function createAndRunDeleteTask
{

    Try
    {
        $servers = Import-Csv .\serverlist.csv 

        foreach ($server in $servers)
        {
            $serverName = $server[0].server
            $releaseFolder = $server[0].releaseFolder 
            
            robocopy . \\$serverName\$releaseFolder delete-OldBuilds.ps1 /R:10 /IS /NP /NS /LOG+:$LogFile
            SCHTASKS /Create /S $serverName /U $domainName\$username /P "$password" /RU SYSTEM /SC WEEKLY /F /TN "delete_Old_Builds" /TR "powershell -noprofile -file $releaseFolder\delete-oldbuilds.ps1 $releaseFolder" | Out-File -Encoding utf8 -Append $LogFile
            Start-Sleep -Seconds 5
            SCHTASKS /RUN /S $serverName /U $domainName\$username /P "$password" /TN "delete_Old_Builds" | Out-File -Encoding utf8 -Append $LogFile
            Start-Sleep -Seconds 60
            SCHTASKS /Delete /S $serverName /U $domainName\$username /P "$password" /TN "delete_Old_Builds" /F | Out-File -Encoding utf8 -Append $LogFile

        }

    }
    Catch
    {
        write-host $_.exception.message
        Write-Output $_.exception.message | Out-File -Encoding utf8 -Append $LogFile
    }

}

createAndRunDeleteTask $serversList
