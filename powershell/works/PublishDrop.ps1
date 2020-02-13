<#
.SYNOPSIS
Generic script to run PublishDrop
.DESCRIPTION
Generic script to run PublishDrop
.EXAMPLE
.\PublishDrop.ps1 -SourcesDirectory "D:\TB\Project\Branch\Sources" -DestinationPath "\\BuildMachineName\Release\Project\Branch"

.EXAMPLE

Version History  
v1.0   - ESIT Build Team - Initial Release
v1.1   - revised by v-yoc
#>

param(
         [String]$SourcesDirectory=$(throw "pass: Sources directory.  Root location of bits to drop"),
         [String]$DestinationPath=$(throw "Pass : Destination (UNC) path")
)

$LogFile = "$SourcesDirectory\Logs\PublishDrop.log"
$SourceList = "$SourcesDirectory\Logs\PublishDrop_source.log"

Write-Output $null > $LogFile
Write-Output $null > $SourceList

function PublishDrop
{
    Try
    {   
		 Get-ChildItem -path "$SourcesDirectory" -recurse >> $SourceList

		 $Publishfiles =
		 @{
			"$SourcesDirectory\Src\CompiledOutput\Release\AnyCPU\*.*" = "$DestinationPath\CompiledOutput\Release\AnyCPU";
			"$SourcesDirectory\Src\CompiledOutput\Release\x86\*.*" = "$DestinationPath\Installers\WebServices\AFFPAdminService"

		 }
		 
		 foreach ($item in $Publishfiles.GetEnumerator())
		 {
			$DestArray = ($item.Value -split ",")
            
            if ($DestArray.Count -gt 1)
            {
                foreach ($element in $DestArray)
                {
                    Invoke-Expression -Command 'xcopy $item.Key $element.ToString().Trim() /y /e /v /i' >> $LogFile
                }

            }
            else
            {
                Invoke-Expression -Command 'xcopy $item.Key $element.Value /y /e /v /i' >> $LogFile
                
            }

            $DestArray = $null
		}

	}
	Catch
	{
		[System.Exception]
		Write-Output $_.Exception.Message >> $LogFile
	}
	Finally
	{  
		Write-Output "Execution Completed!" >> $LogFile
	}
}

PublishDrop -SourcesDirectory $SourcesDirectory -DestinationPath $DestinationPath