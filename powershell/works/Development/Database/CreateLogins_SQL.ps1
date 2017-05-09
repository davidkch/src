<#
.SYNOPSIS
Generic script to create logins on the database.
.DESCRIPTION
Generic script to create logins on the database.
.EXAMPLE
.\CreateLogins_SQL.ps1 -ServerName "mpsitbld-c01-12" -DatabaseName "TestDB" -Domain "Redmond" -UserName "bgcoebld" -Password "password" -Rolename "db_datawriter;db_datareader"
Version History  
v1.0   - ESIT Build Team - Initial Release
#>

Param(
        [String]$ServerName=$(Throw "pass server name."),
        [String]$DatabaseName=$(Throw "pass database name."),
        [String]$Domain=$(Throw "pass domain name"),
        [String]$UserName=$(Throw "pass user/login name."),
        [String]$Password=$(Throw "pass password."),
        [String]$Rolename=$(Throw "pass role name.")
)

$LogFile="CreateLogins_SQL.log"
$Rolenames=$Rolename.Split(';')
Function CreateLogins_SQL
{
     Try
     {
          [System.Reflection.Assembly]::LoadWithPartialName( 'Microsoft.SqlServer.SMO') | out-null
          $s = new-object ('Microsoft.SqlServer.Management.Smo.Server') "$ServerName"
          $User="$Domain"+'\'+"$UserName"
          $log = $s.Logins | where {$_.Name -eq $User}
          if($log.Name -eq "$User")
          {

               "login '$UserName' already exists!" | Out-File $LogFile -Append
               [System.Console]::WriteLine("login '$UserName' already exists!")
          }
          else
          {
                "----------------------------------------------------------------------" | Out-File $LogFile -Append
                [System.Console]::WriteLine("----------------------------------------------------------------------")
                "Creating sql login for '$UserName' user." | Out-File $LogFile -Append
                [System.Console]::WriteLine("Creating sql login for '$UserName' user.")
                "----------------------------------------------------------------------" | Out-File $LogFile -Append
                [System.Console]::WriteLine("----------------------------------------------------------------------")
                $login = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $ServerName,$User
                $login.LoginType = "WindowsUser"
                $login.Create("$Password")
          }
          $db=$s.Databases | where {$_.Name -eq "$DatabaseName"}
          if($db.Name)
          {
             $usr=$db.users | where {$_.Login -eq "$User"}
             if ($usr -eq $null) {
		         "--------------------------------------------------------------" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("--------------------------------------------------------------")
                 "Creating login on '$DatabaseName' database." | Out-File $LogFile -Append
                 [System.Console]::WriteLine("Creating login on '$DatabaseName' database.")
                 "--------------------------------------------------------------" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("--------------------------------------------------------------")
                 $usr = New-Object ('Microsoft.SqlServer.Management.Smo.User') ($db, $User)
		         $usr.Login = $User
		         $usr.Create()
              }
             if ($usr.IsMember("$Rolename") -ne $True) {
		      "--------------------------------------------------------------" | Out-File $LogFile -Append
              [System.Console]::WriteLine("--------------------------------------------------------------")
              "Adding role '$Rolename' to '$DatabaseName' database." | Out-File $LogFile -Append
              [System.Console]::WriteLine("Adding role '$Rolename' to '$DatabaseName' database.")
              "--------------------------------------------------------------" | Out-File $LogFile -Append
              [System.Console]::WriteLine("--------------------------------------------------------------")
		      $cn = new-object system.data.SqlClient.SqlConnection("Data Source='$ServerName';Integrated Security=SSPI;Initial Catalog='$DatabaseName'");
		      $cn.Open()
		      $q = "EXEC sp_addrolemember @rolename = N'$Rolename', @membername = N'$User'"
		      $cmd = new-object "System.Data.SqlClient.SqlCommand" ($q, $cn)
		      $cmd.ExecuteNonQuery() | out-null
		      $cn.Close()
		   }

          }
          else
          {
               "Database '$DatabaseName' does not exists!" | Out-File $LogFile -Append
               [System.Console]::WriteLine("Database '$DatabaseName' does not exists!")
                break;
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

foreach($Role in $Rolenames)
{
$Rolename=$Role
CreateLogins_SQL -ServerName $ServerName -DatabaseName $DatabaseName -Domain $Domain -UserName $UserName -Password $Password -Rolename $Rolename
}