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
		[string]$BinariesDirectory = $(throw "Provide the path upto Compiledoutput - Provide full path of this file ((Drive):\TeamBuild\(Project)\(Branch)\Build Number\Sources\Compiledoutput\)"),
		[string]$SourcesDirectory = $(throw "Provide the path upto sources directory- Provide full path of this file ((Drive):\TeamBuild\(Project)\(Branch)\Biuld Number\Sources\)")
	)

$LogFile = "$SourcesDirectory\Logs\Compile\PostCompile_copy.log"

$ProgramFilesx86 = ${env:ProgramFiles(x86)}
$MSbuild = "$ProgramFilesx86\MSBuild\12.0\Bin\MSBuild.exe"

$SQLPackage = "C:\Program Files (x86)\Microsoft SQL Server\120\DAC\bin"
$DatabaseFolder = "$SourcesDirectory\Src\Database\SPK.Database"
$DatabaseFolderStaging = "$SourcesDirectory\Src_Staging\Database\SPK.Database"

Write-Output $null | Out-File -Encoding utf8 $LogFile
function PostCompile
{
	try
	{
	        # Use Variables.ps1 for Global variables
           .$SourcesDirectory"\Tools\Variables.ps1"

        (Get-Content $DatabaseFolder\SPKPrivate\SPKPrivate.sqlproj) | Foreach-Object {$_ -replace '\s*<Build\sInclude=\"dbo\\Functions\\PKConfig_GetSignoffs\.sql\"\s*/>', "<!--<Build Include=`"dbo\Functions\PKConfig_GetSignoffs.sql`" `/>-->"} | Set-Content $DatabaseFolder\SPKPrivate\SPKPrivate.sqlproj -Encoding UTF8
        (Get-Content $DatabaseFolder\SPKPrivate\SPKPrivate.sqlproj) | Foreach-Object {$_ -replace '\s*<Build\sInclude=\"dbo\\Functions\\PKConfig_GetRequestCompleteStatus\.sql\"\s*/>', "<!--<Build Include=`"dbo\Functions\PKConfig_GetRequestCompleteStatus.sql`" `/>-->"} | Set-Content $DatabaseFolder\SPKPrivate\SPKPrivate.sqlproj -Encoding UTF8

        Start-Sleep -s 3

        (Get-Content $DatabaseFolderStaging\SPKPrivate\SPKPrivate.sqlproj) | Foreach-Object {$_ -replace '\s*<Build\sInclude=\"dbo\\Functions\\PKConfig_GetSignoffs\.sql\"\s*/>', "<!--<Build Include=`"dbo\Functions\PKConfig_GetSignoffs.sql`" `/>-->"} | Set-Content $DatabaseFolderStaging\SPKPrivate\SPKPrivate.sqlproj -Encoding UTF8
        (Get-Content $DatabaseFolderStaging\SPKPrivate\SPKPrivate.sqlproj) | Foreach-Object {$_ -replace '\s*<Build\sInclude=\"dbo\\Functions\\PKConfig_GetRequestCompleteStatus\.sql\"\s*/>', "<!--<Build Include=`"dbo\Functions\PKConfig_GetRequestCompleteStatus.sql`" `/>-->"} | Set-Content $DatabaseFolderStaging\SPKPrivate\SPKPrivate.sqlproj -Encoding UTF8

        & $MSbuild "$DatabaseFolder\SLK.Database.sln" /m /clp:Summary /v:m /t:rebuild /p:configuration=release /p:RunCodeAnalysis=false /p:Platform="Mixed Platforms"
        $BuildError1=$LASTEXITCODE
        & $MSbuild "$DatabaseFolderStaging\SLK.Database.sln" /m /clp:Summary /v:m /t:rebuild /p:configuration=release /p:RunCodeAnalysis=false /p:Platform="Mixed Platforms"
        $BuildError2=$LASTEXITCODE

        Set-Location $SQLPackage

        # $dacpacFiles = @(get-childitem $DatabaseFolder -Recurse | Where-Object {($_.FullName -like "*\bin\Release\*.dacpac")})
        $dacpacFiles = @(get-childitem $DatabaseFolder -Recurse | Where-Object {($_.FullName -like "*\bin\Release\*.dacpac") -and ($_.FullName -notlike "*\bin\Release\PublicLog.dacpac") -and ($_.FullName -notmatch "SPKPrivateConfig.dacpac") -and ($_.FullName -notmatch "SPKPublicConfig.dacpac")})
        $dacpacFilesStage = @(get-childitem $DatabaseFolderStaging -Recurse | Where-Object {($_.FullName -like "*\bin\Release\*.dacpac")})

        # incremental scripts
        foreach ($dacpacFile in $dacpacFiles)
        {
            $dacpacFullName = $dacpacFile.FullName
            $dacpacBaseName = $dacpacFile.BaseName

			if($dacpacFullName -match "BlackNetConfig.dacpac")
			{
				$variableString = "/Variables:SrvName=CP1DV1SLKAPP23 /Variables:VcUrl=net.tcp://CP1PD1SLKAPP24:8523/VCControllerSvc /Variables:VCReceiverName=LogSdlAck /Variables:VCSenderName=LogSdlReceive "		
			}
			elseif($dacpacFullName -match "BlackNetLog.dacpac")
			{
				$variableString =""
			}
			elseif($dacpacFullName -match "PrivateLog.dacpac")
			{
				$variableString ="/Variables:BlackNetLogPullApp11ServerName=CP1DV1SLKAPP11 /Variables:BlackNetLogPullApp12ServerName=CP1DV1SLKAPP12 /Variables:VCControllerUrl=net.tcp://CP1PD1SLKAPP15:8523/VCControllerSvc /Variables:VCReceiverName=LogSdlReceive /Variables:VCSenderName=LogSdlAck "
			}
			elseif($dacpacFullName -match "SPKPrivate.dacpac")
			{
				$variableString ="/Variables:SPKPrivateConfig=SPKPrivateConfig /Variables:ENV=Dev"
			}
			elseif($dacpacFullName -match "SPKPublic.dacpac")
			{
				$variableString ="/Variables:SPKPublicConfig=SPKPublicConfig /Variables:ENV=Dev"
			}
            else
            {
                $variableString ="/Variables:ENV=Dev"
            }
                        
            if ((compare-object -referenceobject $(get-content $dacpacFullName) -differenceobject $(get-content "$DatabaseFolderStaging\$dacpacBaseName\bin\Release\$dacpacBaseName.dacpac")) -ne $null)
            {
                Write-Output ".\sqlpackage /a:Script /of:True /sf:$dacpacFullName /tf:$DatabaseFolderStaging\$dacpacBaseName\bin\Release\$dacpacBaseName.dacpac /op:$DatabaseFolder\$dacpacBaseName\bin\Release\$dacpacBaseName'_Incremental_Install.sql' /p:IgnoreSemicolonBetweenStatements=false /p:BlockonPossibleDataloss=False /p:AllowIncompatiblePlatform=True /Variables:ENV=Dev /tdn:$dacpacBaseName"
                  Invoke-Expression $(".\sqlpackage /a:Script /of:True /sf:$dacpacFullName /tf:$DatabaseFolderStaging\$dacpacBaseName\bin\Release\$dacpacBaseName.dacpac /op:$DatabaseFolder\$dacpacBaseName\bin\Release\$dacpacBaseName'_Incremental_Install.sql' /p:IgnoreSemicolonBetweenStatements=false /p:BlockonPossibleDataloss=False /p:AllowIncompatiblePlatform=True /p:CommentOutSetVarDeclarations=True "+ $variableString +" /tdn:$dacpacBaseName")
            }

        }
		robocopy "$SourcesDirectory\Src\Install\Installers\PSScripts\Profile" "$SourcesDirectory\Src\Database\SPK.Database" empty.dacpac /R:10 /NS /NP

		#Full build scripts for new DB's as part of Spri = nt 5 {BlackNetConfig, BlackNetLog, PrivateLog}
		$fullBuildDacpacFiles = @(get-childitem $DatabaseFolder -Recurse | Where-Object {($_.FullName -like "*\bin\Release\*.dacpac")} | Where-Object {($_.FullName -match "BlackNetConfig.dacpac") -or ($_.FullName -match "BlackNetLog.dacpac") -or ($_.FullName -match "PrivateLog.dacpac") -or ($_.FullName -match "PublicLog.dacpac")} )
		foreach($fullBuildDacpacFile in $fullBuildDacpacFiles)
		{
			$fullBuildDacpacFullName = $fullBuildDacpacFile.FullName
			$fullBuildDacpacBaseName = $fullBuildDacpacFile.BaseName	
			$targetScriptName = "$dacpacBaseName" + "_full.sql"		
			if($fullBuildDacpacFullName -match "BlackNetConfig.dacpac")
			{
				$variableString = "/Variables:SrvName=CP1DV1SLKAPP23 /Variables:VcUrl=net.tcp://CP1PD1SLKAPP24:8523/VCControllerSvc /Variables:VCReceiverName=LogSdlAck /Variables:VCSenderName=LogSdlReceive "	
				$CreateNewFlag = "/p:CreateNewDatabase=True "			
			}
			if($fullBuildDacpacFullName -match "BlackNetLog.dacpac")
			{
				$variableString =""
				$CreateNewFlag = "/p:CreateNewDatabase=False "
			}
			if($fullBuildDacpacFullName -match "PrivateLog.dacpac")
			{
				$variableString ="/Variables:BlackNetLogPullApp11ServerName=CP1DV1SLKAPP11 /Variables:BlackNetLogPullApp12ServerName=CP1DV1SLKAPP12 /Variables:VCControllerUrl=net.tcp://CP1PD1SLKAPP15:8523/VCControllerSvc /Variables:VCReceiverName=LogSdlReceive /Variables:VCSenderName=LogSdlAck "
				$CreateNewFlag = "/p:CreateNewDatabase=False "	
			}
			if($fullBuildDacpacFullName -match "PublicLog.dacpac")
			{
				$variableString =""
				$CreateNewFlag = "/p:CreateNewDatabase=False "	
			}
			Write-Output $(".\sqlpackage /a:Script /of:True /Sourcefile:$fullBuildDacpacFullName /TargetFile:$DatabaseFolder\Empty.dacpac /op:$DatabaseFolder\$fullBuildDacpacBaseName\bin\Release\$fullBuildDacpacBaseName'_full.sql' /p:IgnoreSemicolonBetweenStatements=false /p:BlockonPossibleDataloss=False /p:AllowIncompatiblePlatform=True  /p:CommentOutSetVarDeclarations=True "+$CreateNewFlag+ $variableString +" /tdn:$fullBuildDacpacBaseName")           
		    Invoke-Expression $(".\sqlpackage /a:Script /of:True /Sourcefile:$fullBuildDacpacFullName /TargetFile:$DatabaseFolder\Empty.dacpac /op:$DatabaseFolder\$fullBuildDacpacBaseName\bin\Release\$fullBuildDacpacBaseName'_full.sql' /p:IgnoreSemicolonBetweenStatements=false /p:BlockonPossibleDataloss=False /p:AllowIncompatiblePlatform=True /p:CommentOutSetVarDeclarations=True "+$CreateNewFlag+ $variableString +" /tdn:$fullBuildDacpacBaseName")
		}


        # rollback scripts
        foreach ($dacpacFileStage in $dacpacFilesStage)
        {
            $dacpacFullNameStage = $dacpacFileStage.FullName
            $dacpacBaseNameStage = $dacpacFileStage.BaseName
 
            if($dacpacFullNameStage -match "BlackNetConfig.dacpac")
			{
				$variableString = "/Variables:SrvName=CP1DV1SLKAPP23 /Variables:VcUrl=net.tcp://CP1PD1SLKAPP24:8523/VCControllerSvc /Variables:VCReceiverName=LogSdlAck /Variables:VCSenderName=LogSdlReceive "		
			}
			elseif($dacpacFullNameStage -match "BlackNetLog.dacpac")
			{
				$variableString =""
			}
			elseif($dacpacFullNameStage -match "PrivateLog.dacpac")
			{
				$variableString ="/Variables:BlackNetLogPullApp11ServerName=CP1DV1SLKAPP11 /Variables:BlackNetLogPullApp12ServerName=CP1DV1SLKAPP12 /Variables:VCControllerUrl=net.tcp://CP1PD1SLKAPP15:8523/VCControllerSvc /Variables:VCReceiverName=LogSdlReceive /Variables:VCSenderName=LogSdlAck "
			}
            else
            {
                $variableString ="/Variables:ENV=Dev"
            }
                                   
            if ((compare-object -referenceobject $(get-content $dacpacFullNameStage) -differenceobject $(get-content "$DatabaseFolder\$dacpacBaseNameStage\bin\Release\$dacpacBaseNameStage.dacpac")) -ne $null)
            {               
                Write-Output ".\sqlpackage /a:Script /of:True /sf:$dacpacFullNameStage /tf:$DatabaseFolder\$dacpacBaseNameStage\bin\Release\$dacpacBaseNameStage.dacpac /op:$DatabaseFolder\$dacpacBaseNameStage\bin\Release\$dacpacBaseNameStage'_Rollback_Install.sql' /p:IgnoreSemicolonBetweenStatements=false /p:BlockonPossibleDataloss=False /p:AllowIncompatiblePlatform=True /Variables:ENV=Dev /tdn:$dacpacBaseNameStage"
                Invoke-Expression $(".\sqlpackage /a:Script /of:True /sf:$dacpacFullNameStage /tf:$DatabaseFolder\$dacpacBaseNameStage\bin\Release\$dacpacBaseNameStage.dacpac /op:$DatabaseFolder\$dacpacBaseNameStage\bin\Release\$dacpacBaseNameStage'_Rollback_Install.sql' /p:IgnoreSemicolonBetweenStatements=false /p:BlockonPossibleDataloss=False /p:AllowIncompatiblePlatform=True /p:CommentOutSetVarDeclarations=True "+ $variableString +" /tdn:$dacpacBaseNameStage")
            }

        }
	}
	Catch
	{
		[System.Exception]
		Write-Output $_.Exception.Message | Out-File -Encoding utf8 -Append $LogFile
	}
	Finally
	{  
	
        $logcontent = Get-Content $LogFile | Out-String    

		if ($logcontent.Contains("0x0000"))
		{
			throw ("Failure in copying files from $SourcesDirectory to $BinariesDirectory") | Out-File -Encoding utf8 -Append $LogFile
		}
        else
        {
            if ($BuildError1) { throw "Msbuild failed on SLK.Database.sln - log file is at $LogsDirectory" }
            if ($BuildError2) { throw "Msbuild failed on Staging SLK.Database.sln - log file is at $LogsDirectory" }

		    Write-Output "Execution Completed!" 
        }
    }

}

write-output "PostCompile Function implementation" | Out-File -Encoding utf8 -Append $LogFile  
PostCompile $BinariesDirectory $SourcesDirectory