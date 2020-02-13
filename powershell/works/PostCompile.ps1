#######################  
<#  
.SYNOPSIS  
Update PostCompile.ps1 with task cmds/statements required to execute post CoreCompile Target
.DESCRIPTION  
Update PostCompile.ps1 with task cmds/statements required to execute post CoreCompile  Target
.EXAMPLE  
.\PostCompile.ps1 
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
		#Write-OutPut "Override Params here"
		[string]$BinariesDirectory = $(throw "Provide the path upto Compiledoutput - Provide full path of this file ((Drive):\TeamBuild\(Project)\(Branch)\Sources\Compiledoutput\)"),
		[string]$SourcesDirectory = $(throw "Provide the path upto sources directory- Provide full path of this file ((Drive):\TeamBuild\(Project)\(Branch)\Sources\)")
	)

$LogFile = "$SourcesDirectory\Logs\PostCompile_robocopy.log"
$SourceList = "$SourcesDirectory\Logs\PostCompile_source.log"

function PostCompile
{
	try
	{
        [string]$EntLib = "C:\Program Files (x86)\Microsoft Enterprise Library 5.0\Bin"
		[string]$SQLPackage = "C:\Program Files (x86)\Microsoft SQL Server\110\DAC\bin"
		#[string]$BuildCoreRootDir = "$SourcesDirectory..\BuildScripts"

		#Invoke-Expression "robocopy '$EntLib' '$SourcesDirectory\src\CompiledOutput\AffpService\Release\AnyCPU' Microsoft.Practices.*.dll /NP /R:10 /LOG:$LogFile"
		#Invoke-Expression "robocopy '$EntLib' '$SourcesDirectory\src\CompiledOutput\AffpUiService\Release\AnyCPU' Microsoft.Practices.*.dll /NP /R:10 /LOG+:$LogFile"
		#Invoke-Expression "robocopy '$EntLib' '$SourcesDirectory\src\CompiledOutput\AffpNotificationService\Release\AnyCPU' Microsoft.Practices.Unity*.dll /NP /R:10 /LOG+:$LogFile"

		# Invoke-Expression "robocopy '$EntLib' '$BinariesDirectory\Release\AnyCPU\Affp_All' Microsoft.Practices.*.dll Microsoft.Practices.Unity*.dll /NP /R:10 /LOG+:$LogFile"

		#Invoke-Expression "robocopy $SourcesDirectory\BuildScripts\Tools  $SourcesDirectory\..\ 35MSSharedLib1024.snk /R:10 /LOG+: $LogFile"

		Get-ChildItem -path "$SourcesDirectory" -recurse > $SourceList
		
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
PostCompile $BinariesDirectory $SourcesDirectory
    