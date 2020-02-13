<#
.SYNOPSIS
Generic script to copy .dtsx package to integration services of SQL.
.DESCRIPTION
Generic script to copy .dtsx package to integration services of SQL.
.EXAMPLE
.\CopyDTSX_SSIS.ps1 -DestinationFolder "SSISPackages" -FilePath "D:\test" -FileName "MigrateDownloadedContentItems.dtsx" -DTUtilPath "C:\Program Files\Microsoft SQL Server\100\DTS\Binn"
Version History  
v1.0   - ESIT Build Team - Initial Release
#>

Param(
          [String]$DestinationFolder=$(Throw "pass destination folder"),
          [String]$FilePath=$(Throw "pass .dtsx file path."),
          [String]$FileName=$(Throw "pass .dtsx file name."),
          [String]$DTUtilPath=$(Throw "pass dtutil.exe path")
)

$LogFile="CopyDTSX_SSIS.log"

Function CopyDTSX_SSIS
{
     Try
     {
         if(Test-Path "$DTUtilPath\dtutil.exe")
         {
            if(Test-Path "$FilePath\$FileName")
            {
                  write-host "Set-Location $DTUtilPath"
                  Set-Location "$DTUtilPath"
                  .\dtutil.exe "/FExists SQL;\$DestinationFolder"
                  if($LASTEXITCODE -eq $true)
                  {
                       .\dtutil.exe "/FCreate SQL;\;$DestinationFolder"
                  }
                 "--------------------------------------------------------------" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("--------------------------------------------------------------")
                 "Copying '$FilePath\$FileName' package to SQL integration services." | Out-File $LogFile -Append
                 [System.Console]::WriteLine("Copying '$FilePath\$FileName' package to SQL integration services.")
                 "--------------------------------------------------------------" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("--------------------------------------------------------------")
                 $File=$FileName.split('.')[0]
                 $Fullpath="$FilePath"+'\'+"$FileName"
                 .\dtutil.exe "/FILE $Fullpath /COPY SQL;\$DestinationFolder\$File /QUIET"
            }
            else
            {
                  "File '$FilePath\$FileName' does not exists!" | Out-File $LogFile -Append
                  [System.Console]::WriteLine("File '$FilePath\$FileName' does not exists!") 
            }
         }
         else
         {
              "The path for dtutil.exe '$DTUtilPath' does not exists!" | Out-File $LogFile -Append
              [System.Console]::WriteLine("The path for dtutil.exe '$DTUtilPath' does not exists!")
         }
     }
     Catch
     {
         [System.Exception]
         Write-Output $_.Exception.Message | Out-File $LogFile -Append
         Write-Host $_.Exception.Message
     }
     Finally
     {
         "Execution completed!" | Out-File $LogFile -Append
         [System.Console]::WriteLine("Execution completed!")
     }
}

CopyDTSX_SSIS -DestinationFolder $DestinationFolder -FilePath $FilePath -FileName $FileName -DTUtilPath $DTUtilPath