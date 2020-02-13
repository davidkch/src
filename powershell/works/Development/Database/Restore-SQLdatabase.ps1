<#
.SYNOPSIS
Generic script to restore the database from the .bak file.
.DESCRIPTION
Generic script to restore the database from the .bak file.
.EXAMPLE
.\Restore-SQLdatabase.ps1 -SQLServer mpsitbld-c01-12 -SQLDatabase "TestDB" -BakfilePath "D:\test\db\TEST.Bak" -TrustedConnection $true
Restores 'TestDB' database from 'TEST.Bak' file with Windows Authentication.

.\Restore-SQLdatabase.ps1 -SQLServer mpsitbld-c01-12 -SQLDatabase "TestDB" -BakfilePath "D:\test\db\TEST.Bak" -TrustedConnection $false -SQLusername "Redmond\bgcoebld" -SQLpassword "password"
Restores 'TestDB' database from 'TEST.Bak' file with SQL Server Authentication.

Version History  
v1.0   - ESIT Build Team - Initial Release
#>

Param(  
         [string]$SQLServer=$(Throw "pass sql servername."),
         [string]$SQLDatabase=$(Throw "pass database name."),
         [string]$BakfilePath=$(Throw "pass .bak file path"),
         [Boolean]$TrustedConnection=$(Throw "pass either $true or $false."),
         [string]$SQLusername,
         [string]$SQLpassword
)

$LogFile="Restore-SQLdatabase.log"

Function Restore-SQLdatabase
{
  Try
  {
      ## Performing error checking ##
      if ($BakfilePath -notlike "*.bak")
      {
         write-warning "the file extension should be .bak"
         break
      }

      if ($TrustedConnection -eq $false)
      {
          if($SQLUsername -eq "")
          {
              write-warning "The SQL Username variable must be defined, if 'TrustedConnection' is false. Use '-SQLusername' to define username."
              break
          }
          if($SQLPassword -eq "")
          {
              write-warning "The SQL Password variable must be defined, if 'TrustedConnection' is false. Use '-SQLPassword' to define username."
              break
          }
      }

      if(!(test-path $BakfilePath))
      {
          write-warning "Could not find the backup file, closing"
          break
      }

      $SQLConn = New-Object System.Data.SQLClient.SQLConnection

      #checks for a trusted SQL connection
      if($TrustedConnection -eq $false)
      {
            #Using an SQL account for login
            $SQLConn.ConnectionString = "Data Source=$SQLServer;User ID=$SQLusername;password=$SQLpassword;Initial Catalog=master;Integrated Security=True;Trusted_Connection=True;"
      }
      Else
      {
            #Using a trusted connection
            $SQLConn.ConnectionString = "Server=$SQLServer; Trusted_Connection=True"
      }
      "--------------------------------------------------------" | Out-File $LogFile -Append
      [System.Console]::WriteLine("--------------------------------------------------------")
      "Attempting to connect to the Specified SQL server:" | Out-File $LogFile -Append
      write-host "Attempting to connect to the Specified SQL server: " -nonewline -foregroundcolor yellow
      try{
            $SQLConn.Open()
            write-host "Success" -foregroundcolor Green
            "Success" | Out-File $LogFile -Append
         }
      catch{
             write-host "Failed!" -foregroundcolor Red
             Write-warning "An exception was caught while attempting to open the SQL connection, please confirm the login details are correct and try again."
             Break
            }
      "--------------------------------------------------------" | Out-File $LogFile -Append
      [System.Console]::WriteLine("--------------------------------------------------------")

       $SQLCmd = New-Object System.Data.SQLClient.SQLCommand
       $SQLcmd = $SQLconn.CreateCommand()
       $sqlcmd.commandtimeout=0
       $SQLcmd.CommandText="ALTER DATABASE $SQLDatabase SET SINGLE_USER WITH ROLLBACK IMMEDIATE RESTORE DATABASE $SQLDatabase FROM DISK = '$BakfilePath' WITH REPLACE"
       $starttime = Get-date
       try{
               $SQLcmd.Executenonquery() | out-null
               $result="Success"
               "Database restoration finished!" | Out-File $LogFile -Append
               [System.Console]::WriteLine("Database restoration finished!")
          }
       catch{
               write-warning "An Exception was caught while restoring the database!"
               write-warning "$_"
               write-warning "attempting to recover the database"
               $SQLcmd.CommandText="ALTER DATABASE $SQLDatabase SET MULTI_USER"
               $SQLcmd.Executenonquery() | out-null
               $result="Failed"
            }
       finally{
               $SQLconn.close()
               $timetaken=[math]::round(((get-date) - $starttime).totalseconds,0)
               $report=new-object PSObject -Property @{
               SQLServer=$SQLserver;
               Database=$sqlDatabase;
               Result=$result;
               Timetaken="$timetaken Seconds";}
              }
       Return $Report
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

Restore-SQLdatabase -SQLServer $SQLServer -SQLDatabase $SQLDatabase -BakfilePath $BakfilePath -TrustedConnection $TrustedConnection -SQLusername $SQLusername -SQLpassword $SQLpassword
