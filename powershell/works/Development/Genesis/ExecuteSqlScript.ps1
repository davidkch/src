<#
.SYNOPSIS
Generic script to execute any .sql file in the powershell script
.DESCRIPTION
Generic script to execute any .sql file from the powershell script.
.EXAMPLE
.\ExecuteSqlScript.ps1 -FileName $FileName -SQLServerName $SQLServerName -DBName $DBName

Version History
v1.0 - balas - Initial Release
#>

param (
		[string]$FileName = $(throw,"Input the SQL file name with full path"),
		[string]$SQLServerName = $(throw,"Input the SQL Server Name"),
		[string]$DBName = $(throw,"Input the Database Name")
	  )
	  
$LogFile="ExecuteSqlScript.log"

Function ExecuteSqlScript
{
	try
	{
	     [System.Console]::WriteLine("FileName: $FileName")
         [System.Console]::WriteLine("SQLServerName: $SQLServerName")
         [System.Console]::WriteLine("DBName: $DBName")
         "FileName: $FileName" | Out-File $LogFile -Append
         "SQLServerName: $SQLServerName" | Out-File $LogFile -Append
         "DBName: $DBName" | Out-File $LogFile -Append
		#Adding the SQL snap-ins for SQL 2010
		"----------------------------------------------" | Out-File $LogFile -Append
		"Adding SQL 2010 Snap-ins" | Out-File $LogFile -Append		
		Add-PSSnapin SqlServerCmdletSnapin100
		Add-PSSnapin SqlServerProviderSnapin100
		"SQL 2010 Snap-ins added successfully.." | Out-File $LogFile -Append
		
		# SQL snapins for SQL 2012
		"Adding SQL 2012 Snap-ins" | Out-File $LogFile -Append				
		Add-PSSnapin SqlServerCmdletSnapin110
		Add-PSSnapin SqlServerProviderSnapin110
		"SQL 2012 Snap-ins added successfully.." | Out-File $LogFile -Append
		#use the sqlcmd to execute the .sql file
		"Executing the SQL file on '$SQLServerName' and '$DBName' database" | Out-File $LogFile -Append
		Invoke-Sqlcmd -InputFile $FileName -ServerInstance $SQLServerName -Database $DBName
	
	}
	Catch [System.Exception]
	{
		Write-Host $_.Exception.message
		Write-Output $_.Exception.message | Out-File $LogFile -Append
	}
	Finally
	{
		Write-Host "SQL Script executed successfully!"
		Write-Output "SQL Script executed successfully!" | Out-File $LogFile -Append
	}
}

#Call the function

ExecuteSqlScript -FileName $FileName -SQLServerName $SQLServerName -DBName $DBName


