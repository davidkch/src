#######################  
<#  
.SYNOPSIS  
 Generic script to add current user (user executing script) to the db as a database owner
.DESCRIPTION  
 Generic script to add current user (user executing script) to the db as a database owner
.EXAMPLE  
.\AddCurrentUserToDB.ps1 -DatabaseName MyDatabase
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
		[string]$DatabaseName = $(throw "Pass the DatabaseName")
	 )

$LogFile = "AddCurrentUserToDB.log"

Function AddCurrentUserToDB
{
	try
	{
		#======================================
		# Deploy Restore database
		#======================================

		$currentUser =  [Security.Principal.WindowsIdentity]::GetCurrent().Name
		write-output "Contest user account:  $currentUser" | Out-File $LogFile

		Write-output "Add current user to the $DatabaseName db as db_owner role ..." | Out-File $LogFile -Append
		$db = $srvr.Databases["$DatabaseName"]

		if ($LASTEXITCODE -eq 1)
		{
			$SQLScript= "IF NOT EXISTS (SELECT * FROM master.sys.syslogins WHERE [Name]= N'" + $currentUser + "') BEGIN  CREATE LOGIN [$currentUser] FROM WINDOWS WITH DEFAULT_DATABASE=[$DatabaseName], DEFAULT_LANGUAGE=[us_english]; END"
		}
		else
		{
			$SQLScript= "IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'" + $currentUser + "') BEGIN DROP USER [$currentUser] END; CREATE USER [$currentUser] FOR LOGIN [" + $currentUser + "];EXEC sp_addrolemember N'db_owner', N'$currentUser';"
		}
        write-output "Executing command: $SQLScript" | Out-File $LogFile -Append
		$db.ExecuteNonQuery($SQLScript) | Out-File $LogFile -Append
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

AddCurrentUserToDB -DatabaseName $DatabaseName




