<#  
.SYNOPSIS  
 Generic script to create snapshot of a database.
.DESCRIPTION  
 Generic script to create snapshot database on a specified server.
.EXAMPLE  
.\CreateDBSnapshot.ps1 -ServerName balas001 -DatabaseName TestDB -SnapshotName TestDB_SS
Version History  
v1.0   - balas - Initial Release  
#>  

param(

		[string]$ServerName = $(throw "Input the Server Name"),
		[string]$DatabaseName = $(throw "Input the Database Name"),
		[string]$SnapshotName = $(throw "Input the Snapshot Name")
	)

Function CreateDBSnapshot
{
	try
	{
		#Load all SQL necesssary assemblies
		#this is a common section in all SQL scripts
		[Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMo") | Out-Null
		[Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMoExtended") | Out-Null
		[Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMoEnum") | Out-Null
		[Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null            

		#Get the server and database objects
		$server = New-Object Microsoft.SqlServer.Management.Smo.Server($ServerName)
		$database = $server.Databases[$DatabaseName]            

		#Define a snapshot database and give the same name as the base databse
		$snapshot = New-Object ("Microsoft.SqlServer.Management.Smo.Database") ($ServerName,$SnapshotName)
		$snapshot.DatabaseSnapshotBaseName=$database.Name            

		#Add all filegroups from the base database to snapshot
		foreach ($filegroup in $database.FileGroups) {
		 $newfg = New-Object ("Microsoft.SqlServer.Management.Smo.FileGroup") ($snapshot,$filegroup.Name)
		 $snapshot.FileGroups.Add($newfg)
		}            

		#Add all datafiles from each filegroup of the base database to snapshot with a new datafile name
		#.ss as the datafile extension for the snapshot file
		#By default, the snapshot files will reside in the same folder as base DB data files
		foreach ($filegroup in $database.FileGroups) {
		 foreach ($datafile in $filegroup.Files) {
		  $newDataFile = New-Object ("Microsoft.SqlServer.Management.Smo.DataFile") ($snapshot.FileGroups[$filegroup.Name],$datafile.Name,"$($database.PrimaryFilePath)\$($datafile.Name).ss")
		  $newDataFile.FileName
		  $snapshot.FileGroups[$filegroup.Name].Files.Add($newDataFile)
		 }
		}            

		#Create the snapshot		
		$snapshot.Create()
	}
	Catch [System.Exception]
	{
		Write-Host $_.exception.message
	}
	Finally
	{
		"Snapshot created successfully!"
	}
}

# Call the function to get it execute when user call the .ps1 file
CreateDBSnapshot -ServerName $ServerName -DatabaseName $DatabaseName -SnapshotName $SnapshotName