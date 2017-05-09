<#
.SYNOPSIS
Generic script to run ExecuteTestRunner
.DESCRIPTION
Generic script to run ExecuteTestRunner
.EXAMPLE
.\ExecuteTestRunner.ps1 -SourcesDirectory "D:\TB\Project\Branch\Sources" -DestinationPath "\\BuildMachineName\Release\Project\Branch"

.EXAMPLE
#>

param(
          [String]$SourcesDirectory=$(throw "Pass: Sources directory.  Root location of bits to drop")
         ,[String]$DestinationPath=$(throw "Pass : Destination (UNC) path")
		 ,[string]$VirtualDrive = $(throw "Provide Virtual drive Path in case of Long Path Issues")
	     ,[string]$BuildType = $(throw "Provides BuildType i.e. Basic or Enhanced")
        
     )
function ExecuteTestRunner
{
	try
	{
		Write-Output "Executing Unittest using Vstest-Start"

		$VSTestExe = "C:\Program Files (x86)\Microsoft Visual Studio 11.0\Common7\IDE\CommonExtensions\Microsoft\TestWindow\vstest.console.exe"

		get-childitem $SourcesDirectory -recurse |
			where-object {$_.FullName -like "*\bin\*.UnitTest.dll"} |
			foreach-object { & $VSTestExe $_.FullName /EnableCodeCoverage /InIsolation /Logger:trx }

		Write-Output "Executing Unittest using Vstest-End"

		Write-Output "Copying TestResults to Drop\Logs\UnitTest-Start"
		Robocopy.exe .\TestResults $SourcesDirectory\TestResults\UnitTest\TestResults /E /NS /NP /R:10
		Write-Output "Copying TestResults to Drop\Logs\UnitTest-End"

	}
	catch [system.exception]
	{
		Write-OutPut $_.exception.message
	}
    finally
    {
       Write-OutPut "Completed Successfully!" updated
    }
}

Write-OutPut "ExecuteTestRunner Function implementation"
ExecuteTestRunner -SourcesDirectory $SourcesDirectory -DestinationPath $DestinationPath -VirtualDrive $VirtualDrive -BuildType $BuildType
    