<#
.SYNOPSIS
Generic script to add user as system administrator on SQL server.
.DESCRIPTION
Generic script to add user as system administrator on SQL server.
.EXAMPLE
.\AddUser_SYSAdmin.ps1 -ServerName "mpsitbld-c01-04" -Domain "redmond" -UserName "bgcoebld"
Version History  
v1.0   - ESIT Build Team - Initial Release
#>

Param(
        [String]$ServerName=$(Throw "pass servername"),
        [String]$Domain=$(Throw "pass user domain"),
        [String]$UserName=$(Throw "pass user name.")
)

$LogFile="AddUser_SYSAdmin.log"
Function AddUser_SYSAdmin
{
     Try
     {
           [System.Console]::WriteLine("ServerName: $ServerName")
           [System.Console]::WriteLine("Domain: $Domain")
           [System.Console]::WriteLine("UserName: $UserName")
           "ServerName: $ServerName" | Out-File $LogFile
           "Domain: $Domain" | Out-File $LogFile -Append
           "UserName: $UserName" | Out-File $LogFile -Append
           "----------------------------------------------------------------------" | Out-File $LogFile -Append
           [System.Console]::WriteLine("----------------------------------------------------------------------")
           "Adding '$Domain\$UserName' user as system administrator on sql server." | Out-File $LogFile -Append
           [System.Console]::WriteLine("Adding '$Domain\$UserName' user as system administrator on sql server.")
           "----------------------------------------------------------------------" | Out-File $LogFile -Append
           [System.Console]::WriteLine("----------------------------------------------------------------------")
		   $cn = new-object system.data.SqlClient.SqlConnection("Data Source='$ServerName';Integrated Security=SSPI;Initial Catalog='Master'");
		   $cn.Open()
		   $q = "EXEC master..sp_addsrvrolemember @loginame = N'$Domain\$UserName', @rolename = N'sysadmin'"
		   $cmd = new-object "System.Data.SqlClient.SqlCommand" ($q, $cn)
		   $cmd.ExecuteNonQuery() | out-null
		   $cn.Close()
            "----------------------------------------------------------------------" | Out-File $LogFile -Append
           [System.Console]::WriteLine("----------------------------------------------------------------------")
           "Completed adding '$Domain\$UserName' as system admin on sql server." | Out-File $LogFile -Append
           [System.Console]::WriteLine("Completed adding '$Domain\$UserName' as system admin on sql server.")
           "----------------------------------------------------------------------" | Out-File $LogFile -Append
           [System.Console]::WriteLine("----------------------------------------------------------------------")
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

AddUser_SYSAdmin -ServerName $ServerName -Domain $Domain -UserName $UserName