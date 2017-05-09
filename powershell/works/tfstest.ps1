param(
         [Parameter(Mandatory=$true)]
         [string] $buildDefinitionName=$(throw "Pass one team project name like 'TB_SCA_Sprint_Enhanced'")
 )

[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Client")
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Client")
#[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.VersionControl.Client")
#[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Workflow")

$serverName="https://hbivstf.redmond.corp.microsoft.com:8443/tfs/MPSIT"
$tfs = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer($serverName)
$buildserver = $tfs.GetService([Microsoft.TeamFoundation.Build.Client.IBuildServer])
#$versionControl = $tfs.GetService([Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer]) 

#$buildDefs = $buildServer.QueryBuildDefinitions("RnP_HBI") 

#$buildDef = $buildServer.QueryBuildDefinitions("RnP_HBI") | Where-Object {($_.Name -like "$buildDefinitionName" )}

#Select-String $buildDef 

$buildServer.QueryBuildDefinitions("RnP_HBI") | foreach {
    if ($_.Name -eq "$buildDefinitionName")
    { 
        Write-Host -Separator `n 
        Write-Output ("Build Definition Name: " + $_.Name)
        Write-Output ("LastModifiedBy: " + $_.Workspace.LastModifiedBy)
        Write-Output ("LastModifiedDate: " + $_.Workspace.LastModifiedDate)

    }
} 

<#
$buildServer.QueryBuildDefinitions("RnP_HBI") | foreach {
    if ($_.Name.Contains("SLK"))
    { 
        Write-Output $_.Name
        #Write-Output $_.Name.LastCre

    }
}
#>