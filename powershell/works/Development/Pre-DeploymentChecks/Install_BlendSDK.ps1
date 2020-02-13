#######################  
<#  
.SYNOPSIS  
 Install Blend SDK MSI.
.DESCRIPTION  
 Silent installation of Microsoft Blend SDK from from specified path.
.EXAMPLE  
.\Install_BlendSDK.ps1 C:\MyFolder C:\MySoftware\Folder
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
[string]$FileDir = $(throw "Pass the file diretory name"),
[string]$InstallDir = $(throw "Pass the group name")
)

$LogFile = ".\Install_BlendSDK.log"
$MSI_Log = "BlendSDK_MSI.log"

function Install_BlendSDK()
{
    try
    {
        Write-output "FileDir: $FileDir" | Out-File $LogFile
        Write-output "InstallDir: $InstallDir" | Out-File $LogFile -Append
        Write-output "LogFile: $LogFile" | Out-File $LogFile -Append
        
        write-output "(Start-Process -FilePath msiexec -ArgumentList /i, $FileDir\BlendSLSDK_en.msi, /qn, TARGETDIR=`"$InstallDir`", /l*, .\$MSI_Log).ExitCode | Out-File $LogFile -Append" | Out-File $LogFile -Append
        write-output (Start-Process -FilePath msiexec -ArgumentList /i, $FileDir\BlendSLSDK_en.msi, /qn, TARGETDIR="$InstallDir", /l*, .\$MSI_Log).ExitCode | Out-File $LogFile -Append
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

Install_BlendSDK -FileDir $FileDir -InstallDir $InstallDir