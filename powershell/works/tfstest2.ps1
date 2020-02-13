param(
         [Parameter(Mandatory=$true)]
         [string] $buildDefinitionName=$(throw "Pass build definition name like 'TB_SCA_Sprint_Enhanced'")
 )

[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Client")
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Client")

#you will need change $serverName and $teamProject for your build definition located
$serverName="https://hbivstf.redmond.corp.microsoft.com:8443/tfs/MPSIT"
$teamProject="RnP_HBI"

$tfs = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer($serverName)
$buildserver = $tfs.GetService([Microsoft.TeamFoundation.Build.Client.IBuildServer])

$buildServer.QueryBuildDefinitions("$teamProject") | foreach {
    if ($_.Name -eq "$buildDefinitionName")
    { 
        Write-Output `n
        Write-Output ("Build Definition Name : " + $_.Name)
        Write-Output ("DateCreated           : " + $_.DateCreated)
        Write-Output ("LastModifiedBy        : " + $_.Workspace.LastModifiedBy)
        Write-Output ("LastModifiedDate      : " + $_.Workspace.LastModifiedDate)

    }
}