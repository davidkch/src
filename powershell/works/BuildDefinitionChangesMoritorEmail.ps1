$logLimit = (Get-Date).AddDays(-30)
#$logPath = "$env:TEMP"
$logPath = "E:\BuildDefinitionMonitor\Logs"

$timestamp = Get-Date -Format o | foreach {$_ -replace ":", "."}

$LogFile ="$logPath\BuildDefinitionChangeLog_$timestamp.txt"
$FullLogFile ="$logPath\BuildDefinitionChangeLogFull_$timestamp.txt"
#Write-Output $null | Out-File -Encoding utf8 $LogFile

[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Client")
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Client")

#you will need change $serverName and $teamProject for your build definition located
$serverName="https://hbivstf.redmond.corp.microsoft.com:8443/tfs/MPSIT"
$teamProject="RnP_HBI"

$tfs = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer($serverName)
$buildserver = $tfs.GetService([Microsoft.TeamFoundation.Build.Client.IBuildServer])

$changeFlag = $false

set-executionpolicy -scope Currentuser unrestricted
$reg=Get-ItemProperty hkcu:\secpassHBI
$pass = convertto-securestring $reg.pw
$credential = new-object System.Management.Automation.PSCredential("bgbldhbi@microsoft.com", $pass)

$buildServer.QueryBuildDefinitions("$teamProject") | foreach {

        #$howOld = ((Get-Date) - $_.Workspace.LastModifiedDate.Date)

        Write-Output $_ | Out-File $FullLogFile -Append

        # check changed build definition 
        $hoursPast = New-TimeSpan -Start ($_.Workspace.LastModifiedDate.DateTime)

        if ($hoursPast.TotalHours -le 2)
        {
            Write-Host `n  
            Write-Host "Build Definition Name : " $_.Name -ForegroundColor Cyan 
            Write-Host "DateCreated           : " $_.DateCreated -ForegroundColor Cyan  
            Write-Host "LastModifiedBy        : " $_.Workspace.LastModifiedBy -ForegroundColor Cyan  
            Write-Host "LastModifiedDate      : " $_.Workspace.LastModifiedDate -ForegroundColor Cyan  
            
            Write-Output `n  | Out-File $LogFile -Append
            Write-Output ("Build Definition Name : " + $_.Name) | Out-File $LogFile -Append
            Write-OutPut ("DateCreated           : " + $_.DateCreated) | Out-File $LogFile -Append
            Write-OutPut ("LastModifiedBy        : " + $_.Workspace.LastModifiedBy) | Out-File $LogFile -Append
            Write-OutPut ("LastModifiedDate      : " + $_.Workspace.LastModifiedDate) | Out-File $LogFile -Append
            
            $changeFlag = $true

        }
        else
        {
            Write-Host `n  
            Write-Host "Build Definition Name : " $_.Name 
            Write-Host "DateCreated           : " $_.DateCreated  
            Write-Host "LastModifiedBy        : " $_.Workspace.LastModifiedBy  
            Write-Host "LastModifiedDate      : " $_.Workspace.LastModifiedDate  

            Write-Output `n  | Out-File $LogFile -Append
            Write-Output ("Build Definition Name : " + $_.Name) | Out-File $LogFile -Append
            Write-OutPut ("DateCreated           : " + $_.DateCreated) | Out-File $LogFile -Append
            Write-OutPut ("LastModifiedBy        : " + $_.Workspace.LastModifiedBy) | Out-File $LogFile -Append
            Write-OutPut ("LastModifiedDate      : " + $_.Workspace.LastModifiedDate) | Out-File $LogFile -Append
        }

        #delete old log files
        Get-Item $logPath\BuildDefinitionChangeLog*.txt |  Where-Object { $_.CreationTime -lt $logLimit } | Remove-Item -Force

}

if ($changeFlag)
{
    Send-MailMessage -smtpServer smtp.office365.com -Credential $credential -UseSsl -From "bgbldhbi@microsoft.com" -to "bghbibld@microsoft.com", "v-yoc@microsoft.com" -subject "Build Definition(s) modified" -Body "Recently build definition(s) has been modified! Please check log file $LogFile at ESITBLDHBI-1" -Priority High -Port 587
}