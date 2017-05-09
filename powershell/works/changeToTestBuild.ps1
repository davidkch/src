#this script need to run as an account that has admin previlage for the team project
#you will need change $serverName and $teamProject for your build definition located
$serverName="https://hbivstf.redmond.corp.microsoft.com:8443/tfs/MPSIT"
$teamProject="RnP_HBI"

[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Client")
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Client")

$tfs = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer($serverName)
$buildserver = $tfs.GetService([Microsoft.TeamFoundation.Build.Client.IBuildServer])

#if you want to run against one or just couple of build definitions change to $buildDefinitions as array like below line
#$buildDefinitions = @("TB_SCA_Sprint_Basic", "TB_CLM_Sprint_Basic")

$buildDefinitions = $buildserver.QueryBuildDefinitions($teamProject).Name

foreach ($buildDefinition in $buildDefinitions)
{
    $buildDetail = $buildServer.CreateBuildDetailSpec($teamProject, $buildDefinition)

    $builds = $buildServer.QueryBuilds($buildDetail).Builds 
    $buildCount = $builds.Count

    for ($i = 0; $i -lt $buildCount; $i++)
    {

        if ((($builds.Get($i).RequestedBy -notlike "*Project Collection Service Accounts") -and ($builds.Get($i).RequestedBy -notlike "*BGE HBI Build Account")) -and ($builds.Get($i).Quality -eq $null) )
        {
            Write-Host `n
            Write-Host "Build Number:  " $builds.Get($i).BuildNumber
            Write-Host "RequestdBy:    " $builds.Get($i).RequestedBy
            Write-Host "Build Quality: " $builds.Get($i).Quality

            $builds.Get($i).Quality = "TestBuild"
        }
    }

    $buildserver.SaveBuilds($builds)

}