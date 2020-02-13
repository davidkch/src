#######################  
<#  
.SYNOPSIS  
 Generic script to restore a database from a backup.
.DESCRIPTION  
 Generic script to restore a database from a backup, specified by the user.
.EXAMPLE  
.\RestoreDB.ps1 -BackupFileName MyFileBackup.bak -DatabaseName MyDatabaseName -DataFilePath D:\DATA
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
		 [string]$BackupFileName = $(throw "Pass the BackupFileName")
		,[string]$DatabaseName = $(throw "Pass the DatabaseName")
		,[string]$DataFilePath = $(throw "Pass the DataFilePath")
	 )

Function RestoreDB
{
	try
	{
		$backupPath = $installDir.tostring() + $BackupFileName

		[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
		$srvr = new-object ("Microsoft.SqlServer.Management.Smo.Server") 'localhost'

		$db = $srvr.Databases["Master"]

		$SQLScript= "RESTORE DATABASE [$DatabaseName] FROM  DISK = N'"+ $backupPath +"' WITH  FILE = 1,  MOVE N'$DatabaseName' TO N'$DataFilePath\$DatabaseName.mdf',  MOVE N'$DatabaseName_log' TO N'$DataFilePath\$DatabaseName_1.ldf',  NOUNLOAD,  STATS = 10"

		$db.ExecuteNonQuery($SQLScript)
	}
	Catch [system.exception]
	{
		write-host $_.exception.message
	}
	Finally
	{
		"Executed Successfully"
	}
}

RestoreDB -BackupFileName $BackupFileName -DatabaseName $DatabaseName -DataFilePath $DataFilePath