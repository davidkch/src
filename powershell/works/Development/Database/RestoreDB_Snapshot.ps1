<#
.SYNOPSIS
Generic script to restore the database with the snapshot created for it.
.DESCRIPTION
Generic script to restore the database with the snapshot created for it.
.EXAMPLE
.\RestoreDB_Snapshot.ps1 -ServerName "Cwsgranular_DB" -DatabaseName "Configuration" -DBSnapshotName "Configuration_snapshot_11202012"
Version History  
v1.0   - ESIT Build Team - Initial Release
#>

Param(
         [String]$ServerName=$(Throw "pass server name."),
         [String]$DatabaseName=$(Throw "pass database name."),
         [String]$DBSnapshotName=$(Throw "pass database snapshot name.")
)

$LogFile="RestoreDB_Snapshot.log"

Function RestoreDB_Snapshot
{
     Try
     {
          [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
          $srvr = new-object ("Microsoft.SqlServer.Management.Smo.Server") "$ServerName"
          $CheckDB=$srvr.Databases | where {$_.name -eq "$DatabaseName"}
          if($CheckDB.Name)
          {
              "------------------------------------------------------------------" | Out-File $LogFile -Append
              [System.Console]::WriteLine("------------------------------------------------------------------")
              "Restoring '$DatabaseName' database by '$DBSnapshotName' snapshot." | Out-File $LogFile -Append
              [System.Console]::WriteLine("Restoring '$DatabaseName' database by '$DBSnapshotName' snapshot.")

              $db = $srvr.Databases["Master"]
              $SQLScript= "RESTORE DATABASE $DatabaseName FROM DATABASE_SNAPSHOT = '$DBSnapshotName'"
              $db.ExecuteNonQuery($SQLScript) | Out-File $LogFile -Append

              "------------------------------------------------------------------" | Out-File $LogFile -Append
              [System.Console]::WriteLine("------------------------------------------------------------------")
              "Restoration finished." | Out-File $LogFile -Append
              [System.Console]::WriteLine("Restoration finished.")
          }
          else
          {
               "Database '$DBSnapshotName' does not exists!" | Out-File $LogFile -Append
               [System.Console]::WriteLine("Database '$DBSnapshotName' does not exists!")
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

RestoreDB_Snapshot -ServerName $ServerName -DatabaseName $DatabaseName -DBSnapshotName $DBSnapshotName