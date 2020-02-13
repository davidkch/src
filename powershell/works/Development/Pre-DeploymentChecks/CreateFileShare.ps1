#######################  
<#  
.SYNOPSIS  
 Generic script to create a new file share.
.DESCRIPTION  
 Generic script to create a new file share.
.EXAMPLE  
.\CreateFileShare.ps1 -ShareName MyShare -ServiceAccount Y -AccessLevel FULL
Version History  
v1.0   - ESIT Build Team - Initial Release  
#> 

param(
    [string]$ShareDirectory = $(throw "Pass local directory of share")
   ,[string]$ServiceAccount = $(throw "Pass the ServiceAccount")
   ,[string]$AccessLevel = $(throw "Pass the AccessLevel")  #Can be 1 of 3:  READ, CHANGE, FULL
)

$LogFile = "CreateFileShare.log"

Function CreateFileShare
{
	try
	{	
        write-output "ShareDirectory:  $ShareDirectory" | Out-File $LogFile
		write-output "ServiceAccount:  $ServiceAccount" | Out-File $LogFile -Append
		write-output "AccessLevel:  $AccessLevel" | Out-File $LogFile -Append

        # Testing if folder exist, if not creating folder.
		IF (!(Test-Path $ShareDirectory)) {New-Item $ShareDirectory -type Directory} 
        ELSE 
        { 
            write-output "Directory already exists!" | Out-File $LogFile -Append
        }
        $DirCount = $ShareDirectory.Split('\').Count
        $ShareName = $ShareDirectory.Split('\')[$DirCount - 1]  #Gets the last directory of the whole path to find the name

		#Providing permission at folder security level
		$FolderPermission = Get-Acl $ShareDirectory

        # Creating Share and providing folder sharing access
		$CreateShare = '"' + "net share " + $ShareName + "=" + $ShareDirectory

        foreach($UserGroup in $ServiceAccount.Split(';'))
        {
            write-host "Usergroup:  $UserGroup"
            $CreateShare += " /GRANT:" +'"' + $UserGroup + ",$AccessLevel" + '"'
            write-host "CreateShare: $CreateShare"
        }

        Set-Acl $ShareDirectory $FolderPermission

        $CreateShare += ' /UNLIMITED /REMARK:' +'"' + $ShareName + '"'
        write-host "COMMAND:  $CreateShare"
		cmd.exe /c $CreateShare
	}
	Catch [system.exception]
	{
		write-output $_.exception.message | Out-File $LogFile -Append
		write-host $_.exception.message
	}
	Finally
	{
		"Executed Successfully"
	}
}

CreateFileShare -ShareDirectory $ShareDirectory -ServiceAccount $ServiceAccount -AccessLevel $AccessLevel

