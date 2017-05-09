#######################  
<#  
.SYNOPSIS  
Update PreCompile.ps1 with task cmds/statements execute pre CoreCompile Target
.DESCRIPTION  
Update PreCompile.ps1 with task cmds/statements execute pre CoreCompile  Target
.EXAMPLE  
.\PostCompile.ps1 
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
		#Write-OutPut "Override Params here"
		[string]$BinariesDirectory = $(throw "Provide the path upto Compiledoutput - Provide full path of this file ((Drive):\TeamBuild\(Project)\(Branch)\Sources\Compiledoutput\)"),
		[string]$SourcesDirectory = $(throw "Provide the path upto sources directory- Provide full path of this file ((Drive):\TeamBuild\(Project)\(Branch)\Sources\")
		)

$LogFile = "$SourcesDirectory\Logs\PreCompile.log"
$SourcesList = "$SourcesDirectory\Logs\PreCompile_source.log"
$VS10IDE = $Env:VS100COMNTOOLS + "..\IDE"
$env:Path = "$VS10IDE;" + $env:Path

Write-Output $null > $LogFile
Write-Output $null > $SourcesList

function PreCompile
{
	try
	{
		Get-ChildItem -path "$SourcesDirectory" -recurse >> $SourceList
		# Invoke-Expression "robocopy $SourcesDirectory\BuildScripts\Tools  $SourcesDirectory\..\ 35MSSharedLib1024.snk /R:10 /LOG: $LogFile"
		Invoke-Expression "attrib -r /S $SourcesDirectory\*.*" >> $LogFile
		Invoke-Expression "DevEnv.com $SourcesDirectory\SCA\Fitness\Src\App\ScaleAndSecure.sln /Build `"Release|AnyCPU`"" >> $LogFile
		Invoke-Expression "DevEnv.com $SourcesDirectory\SCA\Fitness\DecryptVerify\src\DecryptVerify\DecryptVerify.sln /Build `"Release|AnyCPU`"" >> $LogFile
	}
	Catch [system.exception]
	{
        write-host  $_.exception.message
		write-output  $_.exception.message >> $LogFile
	}
    Finally
    {
       write-output "Completed Successfully!" >> $LogFile 
    }
}

write-output "PreCompile Function implementation" >> $LogFile 
PreCompile $BinariesDirectory $SourcesDirectory
    