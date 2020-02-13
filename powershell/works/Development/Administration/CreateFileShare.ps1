#######################  
<#  
.SYNOPSIS  
 Generic script to create a new file share.
.DESCRIPTION  
 Generic script to create a new file share.
.EXAMPLE  
.\CreateFileShare.ps1 -ShareName MyShare -SharePath "C:\MyShare" -ServiceAccount Y -AccessLevel Full -Remark "Share description"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#> 

param(
	[string]$ShareName = $(throw "Pass the ShareName")
   ,[string]$SharePath = $(throw "Pass the SharePath")
   ,[string]$ServiceAccount = $(throw "Pass the ServiceAccount")
   ,[string]$AccessLevel = $(throw "Pass the AccessLevel")
   ,[string]$Remark = $(throw "Pass remark.  Description of share.")
)

$LogFile = "CreateFileShare.log"

Function CreateFileShare
{
	try
	{	
		$UserAlias = "$ServiceAccount"
		$eone = "$AccessLevel"

		write-output "ShareName:  $ShareName" | Out-File $LogFile
		write-output "ServiceAccount:  $ServiceAccount" | Out-File $LogFile -Append
		write-output "AccessLevel:  $AccessLevel" | Out-File $LogFile -Append

		# Testing if folder exist, if not creating folder.
		IF (!(Test-Path "$SharePath")) {New-Item "$Sharepath" -type Directory} 
	
		#Providing permission at folder security level
		$FolderPermission = Get-Acl $SharePath

		$AddPermission = New-Object System.Security.AccessControl.FileSystemAccessRule($UserAlias,"FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
		$FolderPermission.AddAccessRule($AddPermission)
		Set-Acl $SharePath $FolderPermission

		# Creating Share and providing folder sharing access
		$CreateShare = "net share `"$ShareName`"=`"$SharePath`" /GRANT:`"$UserAlias`",$eone /UNLIMITED /REMARK:`"$Remark`""
	
		cmd.exe /c $CreateShare
        write-output "Share $CreateShare" | Out-File $LogFile -Append
	}
	Catch [system.exception]
	{
		write-host $_.exception.message | out-file $LogFile -Append
	}
	Finally
	{
		"Executed Successfully" | out-file $LogFile -Append
	}
}

CreateFileShare -ShareName $ShareName -SharePath $SharePath -ServiceAccount $ServiceAccount -AccessLevel $AccessLevel -Remark $Remark

