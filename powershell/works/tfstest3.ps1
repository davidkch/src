[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Client")
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Client")

#you will need change $serverName and $teamProject for your build definition located
$serverName="https://hbivstf.redmond.corp.microsoft.com:8443/tfs/MPSIT"
$teamProject="RnP_HBI"

$tfs = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer($serverName)
$buildserver = $tfs.GetService([Microsoft.TeamFoundation.Build.Client.IBuildServer])

$buildServer.QueryBuildDefinitions("$teamProject") | foreach {

        $howOld = ((Get-Date) - $_.Workspace.LastModifiedDate.Date)
        if ($howOld.Days -lt 7)
        {
            Write-Host `n
            Write-Host "Build Definition Name : " $_.Name -ForegroundColor Cyan
            Write-Host "DateCreated           : " $_.DateCreated  -ForegroundColor Cyan
            Write-Host "LastModifiedBy        : " $_.Workspace.LastModifiedBy  -ForegroundColor Cyan
            Write-Host "LastModifiedDate      : " $_.Workspace.LastModifiedDate  -ForegroundColor Cyan

        }
        else
        {
            Write-Host `n
            Write-Host "Build Definition Name : " $_.Name
            Write-Host "DateCreated           : " $_.DateCreated
            Write-Host "LastModifiedBy        : " $_.Workspace.LastModifiedBy
            Write-Host "LastModifiedDate      : " $_.Workspace.LastModifiedDate
        }

}