<#
.SYNOPSIS
Generic script to enable required dll's for ISAPI and CGI properties
.DESCRIPTION
Generic script to enable required dll's for ISAPI and CGI properties
.EXAMPLE
.\ConfigureServer_IsapiCgiRestrictions.ps1 -ISAPIPath "C:\Windows\Microsoft.NET\Framework\v4.0.30319\aspnet_isapi.dll" -Description "ASP.NET v4.0.30319"
Enables "C:\Windows\Microsoft.NET\Framework\v4.0.30319\aspnet_isapi.dll" for ISAPI and CGI properties

Version History  
v1.0   - ESIT Build Team - Initial Release
#>

param(
        [String]$ISAPIPath=$(throw "pass required .dll path for ISAPI and CGI properties"),
        [String]$Description=$(throw "pass description") 
)

$Logfile="ConfigureServer_IsapiCgiRestrictions.log"

Function ConfigureServer_IsapiCgiRestrictions
{
     Try
     {
          Import-Module WebAdministration
          $checkifenabled=Get-WebConfiguration system.webServer/security/isapiCgiRestriction/* 'IIS:\' | where {$_.path -eq "$ISAPIPath"}
          if($checkifenabled)
          { 
                  if((Test-path $checkifenabled.path) -and ($checkifenabled.allowed -eq $true))
                  {
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                       "'$ISAPIPath' already exists in ISAPI CGI Restrictions" | Out-File $Logfile -Append
                       [System.Console]::WriteLine("'$ISAPIPath' already exists in ISAPI CGI Restrictions")
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                  }
                  elseif((Test-path $checkifenabled.path) -and ($checkifenabled.allowed -eq $false))
                  {
                        [System.Console]::WriteLine("--------------------------------------------------------")
                        "--------------------------------------------------------" | Out-File $LogFile -Append
                        "Enabling '$ISAPIPath' for ISAPI and CGI properties" | Out-File $LogFile -Append
                        [System.Console]::WriteLine("Enabling '$ISAPIPath' for ISAPI and CGI properties")
                        [System.Console]::WriteLine("--------------------------------------------------------")
                        "--------------------------------------------------------" | Out-File $LogFile -Append
                         set-webconfiguration "/system.webServer/security/isapiCgiRestriction/add[@path='$ISAPIPath']/@allowed" -value "True" -PSPath:IIS:\
                  }
          }
          else
          { 
              [System.Console]::WriteLine("--------------------------------------------------------")
              "--------------------------------------------------------" | Out-File $LogFile -Append
              "Enabling '$ISAPIPath' for ISAPI and CGI properties" | Out-File $LogFile -Append
              [System.Console]::WriteLine("Enabling '$ISAPIPath' for ISAPI and CGI properties")
              [System.Console]::WriteLine("--------------------------------------------------------")
              "--------------------------------------------------------" | Out-File $LogFile -Append
               Add-WebConfiguration /system.webServer/security/isapiCgiRestriction "IIS:\" -Value @{path="$ISAPIPath"}
               set-webconfiguration "/system.webServer/security/isapiCgiRestriction/add[@path='$ISAPIPath']/@allowed" -value "True" -PSPath:IIS:\
               set-webconfiguration "/system.webServer/security/isapiCgiRestriction/add[@path='$ISAPIPath']/@groupid" -value "$Description" -PSPath:IIS:\
               set-webconfiguration "/system.webServer/security/isapiCgiRestriction/add[@path='$ISAPIPath']/@description" -value "$Description" -PSPath:IIS:\         
          }
          
          
     }
     Catch
     {
           [System.Exception]
           Write-Output $_.Exception.Message | Out-File $Logfile -Append
           Write-Host $_.Exception.Message
     }
     Finally
     {
           "Completed Successfully!" | Out-File $Logfile -Append
     }
}

ConfigureServer_IsapiCgiRestrictions -ISAPIPath $ISAPIPath -Description $Description