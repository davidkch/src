<#
.SYNOPSIS
Generic script to kill the connections\transactions of database.
.DESCRIPTION
Generic script to kill the connections\transactions of database.
.EXAMPLE
.\KillSessions_DB.ps1 -ServerName "mpsitbld-c01-12" -DatabaseName "TestDB"
Version History  
v1.0   - ESIT Build Team - Initial Release
#>

Param(
         [String]$ServerName=$(Throw "pass server name."),
         [String]$DatabaseName=$(Throw "pass database name.")
)

$LogFile="KillSessions_DB.log"

Function KillSessions_DB
{
     Try
     {
          [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
          $SQlSvr1 = New-Object Microsoft.SqlServer.Management.Smo.Server "$ServerName"
          $CheckDB=$SQlSvr1.Databases | where {$_.name -eq "$DatabaseName"}
          if($CheckDB.Name)
          {
                "-----------------------------------------------------" | Out-File $LogFile -Append
                [System.Console]::WriteLine("-----------------------------------------------------")
                "Killing sessions of database '$DatabaseName'" | Out-File $LogFile -Append
                [System.Console]::WriteLine("Killing sessions of database '$DatabaseName'")
                "-----------------------------------------------------" | Out-File $LogFile -Append
                [System.Console]::WriteLine("-----------------------------------------------------")
                $SQlSvr1.KillAllprocesses("$DatabaseName")
          }
          else
          {
                "Database '$DatabaseName' does not exists!" | Out-File $LogFile -Append
                [System.Console]::WriteLine("Database '$DatabaseName' does not exists!")
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

KillSessions_DB -ServerName $ServerName -DatabaseName $DatabaseName