#######################  
<#  
.SYNOPSIS  
 Install .NET Framework 1.1
.DESCRIPTION  
 Silent installation of .NET Framework 1.1
.EXAMPLE  
.\Install_DotNet11.ps1 C:\MyFolder
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
[string]$FileDir = $(throw "Pass the file diretory name")
)

$LogFile = ".\Install_DotNet11.log"

function Install_DotNet11()
{
    try
    {
        Write-output "FileDir: $FileDir" | Out-File $LogFile
        Write-output "LogFile: $LogFile" | Out-File $LogFile -Append

        $package = Get-ChildItem -Path "$FileDir\dotnetfx.exe"
        (Get-WMIObject -List | Where-Object {$_.Name -eq "Win32_Product"}).Install($package.ToString(), "", $true) | Out-File $LogFile
	   
    }
	Catch [system.exception]
	{
		write-output $_.exception.message | Out-File $LogFile -Append
		write-host $_.exception.message
	}
	Finally
	{
		"Executed Successfully" | Out-File $LogFile -Append
	}
}

Install_DotNet11 -FileDir $FileDir