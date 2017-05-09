<#
.SYNOPSIS
Generic script to configure authentication settings for websites and virtual directories
.DESCRIPTION
Generic script to configure authentication settings for websites and virtual directories
.EXAMPLE
.\ConfigureWebsite_Authentications.ps1 -WebsiteName "Default Web Site" -WindowsAuthentication "enable" -BasicAuthentication "enable" -AnonymousAuthentication "enable" -VDirName "Samplevdir"
Enables windows,basic and anonymous authentications for "Sample virtual directory".

.EXAMPLE
.\ConfigureWebsite_Authentications.ps1 -WebsiteName "Default Web Site" -WindowsAuthentication "enable" -BasicAuthentication "enable" -AnonymousAuthentication "enable"
Enables windows,basic and anonymous authentications for "Default Web Site" website.

Version History  
v1.0   - ESIT Build Team - Initial Release
#>

param(
          [String]$WebsiteName=$(throw "pass existing website name."),
          [String]$WindowsAuthentication,[String]$BasicAuthentication,[String]$AnonymousAuthentication,[String]$VDirName #optional
)

$LogFile="ConfigureWebsite_Authentications.log"

Function ConfigureWebsite_Authentications
{
     Try
     {
           Import-Module WebAdministration
           if($WindowsAuthentication -and ("Enable","Disable" -Notcontains $WindowsAuthentication))
           {
                [System.Console]::WriteLine("--------------------------------------------------------")
                 "--------------------------------------------------------" | Out-File $LogFile -Append
                [System.Console]::WriteLine("Invalid value '$WindowsAuthentication'! pass either 'Enable' or 'Disable' for WindowsAuthentication parameter")
                "Invalid value '$WindowsAuthentication'! pass either 'Enable' or 'Disable' for WindowsAuthentication parameter" | Out-File $LogFile -Append
                [System.Console]::WriteLine("--------------------------------------------------------")
                 "--------------------------------------------------------" | Out-File $LogFile -Append
           }
           if($BasicAuthentication -and ("Enable","Disable" -Notcontains $BasicAuthentication))
           {
                [System.Console]::WriteLine("--------------------------------------------------------")
                 "--------------------------------------------------------" | Out-File $LogFile -Append
                [System.Console]::WriteLine("Invalid value '$BasicAuthentication'! pass either 'Enable' or 'Disable' for BasicAuthentication parameter")
                "Invalid value '$BasicAuthentication'! pass either 'Enable' or 'Disable' for BasicAuthentication parameter" | Out-File $LogFile -Append
                [System.Console]::WriteLine("--------------------------------------------------------")
                 "--------------------------------------------------------" | Out-File $LogFile -Append
           }
           if($AnonymousAuthentication -and ("Enable","Disable" -Notcontains $AnonymousAuthentication))
           {
                [System.Console]::WriteLine("--------------------------------------------------------")
                "--------------------------------------------------------" | Out-File $LogFile -Append
                [System.Console]::WriteLine("Invalid value '$AnonymousAuthentication'! pass either 'Enable' or 'Disable' for AnonymousAuthentication parameter")
                "Invalid value '$AnonymousAuthentication'! pass either 'Enable' or 'Disable' for AnonymousAuthentication parameter" | Out-File $LogFile -Append
                [System.Console]::WriteLine("--------------------------------------------------------")
                "--------------------------------------------------------" | Out-File $LogFile -Append
           }
           if($VDirName)
           {
                $WebsiteName=$WebsiteName+"/"+$VDirName
           }
           if(Test-Path "IIS:\Sites\$WebsiteName")
           {
                if($WindowsAuthentication -eq 'Enable')
                {
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                       "Enabling windows authentication for '$WebsiteName' website." | Out-File $LogFile -Append
                       [System.Console]::WriteLine("Enabling windows authentication for '$WebsiteName' website.")
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                        Set-WebConfigurationProperty -Filter /system.webServer/security/authentication/windowsAuthentication -Name enabled -Value true -PSPath IIS:\ -Location "$WebsiteName"
                }
                elseif($WindowsAuthentication -eq 'Disable')
                {
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                       "Disabling windows authentication for '$WebsiteName' website." | Out-File $LogFile -Append
                       [System.Console]::WriteLine("Disabling windows authentication for '$WebsiteName' website.")
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                        Set-WebConfigurationProperty -Filter /system.webServer/security/authentication/windowsAuthentication -Name enabled -Value false -PSPath IIS:\ -Location "$WebsiteName"
                }
                if($BasicAuthentication -eq 'Enable')
                {
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                       "Enabling basic authentication for '$WebsiteName' website." | Out-File $LogFile -Append
                       [System.Console]::WriteLine("Enabling basic authentication for '$WebsiteName' website.")
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                        Set-WebConfigurationProperty -Filter /system.webServer/security/authentication/basicAuthentication -Name enabled -Value true -PSPath IIS:\ -Location "$WebsiteName"
                }
                elseif($BasicAuthentication -eq 'Disable')
                {
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                       "Disabling basic authentication for '$WebsiteName' website." | Out-File $LogFile -Append
                       [System.Console]::WriteLine("Disabling basic authentication for '$WebsiteName' website.")
                       [System.Console]::WriteLine("--------------------------------------------------------")
                        "--------------------------------------------------------" | Out-File $LogFile -Append
                        Set-WebConfigurationProperty -Filter /system.webServer/security/authentication/basicAuthentication -Name enabled -Value false -PSPath IIS:\ -Location "$WebsiteName"
                }
                if($AnonymousAuthentication -eq 'Enable')
                {
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                       "Enabling Anonymous authentication for '$WebsiteName' website." | Out-File $LogFile -Append
                       [System.Console]::WriteLine("Enabling Anonymous authentication for '$WebsiteName' website.")
                       [System.Console]::WriteLine("--------------------------------------------------------")
                        "--------------------------------------------------------" | Out-File $LogFile -Append
                        Set-WebConfigurationProperty -Filter /system.webServer/security/authentication/anonymousAuthentication -Name enabled -Value true -PSPath IIS:\ -Location "$WebsiteName"
                }
                elseif($AnonymousAuthentication -eq 'Disable')
                {
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                       "Disabling Anonymous authentication for '$WebsiteName' website." | Out-File $LogFile -Append
                       [System.Console]::WriteLine("Disabling Anonymous authentication for '$WebsiteName' website.")
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                        Set-WebConfigurationProperty -Filter /system.webServer/security/authentication/anonymousAuthentication -Name enabled -Value false -PSPath IIS:\ -Location "$WebsiteName"
                }
           }
           else
           {
               [System.Console]::WriteLine("--------------------------------------------------------")
               "--------------------------------------------------------" | Out-File $LogFile -Append
               "website/virtualdirectory '$WebsiteName' does not exists!" | Out-File $LogFile -Append
               [System.Console]::WriteLine("website/virtualdirectory '$WebsiteName' does not exists!")
               [System.Console]::WriteLine("--------------------------------------------------------")
               "--------------------------------------------------------" | Out-File $LogFile -Append
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

ConfigureWebsite_Authentications -WebsiteName $WebsiteName -WindowsAuthentication $WindowsAuthentication -BasicAuthentication $BasicAuthentication -AnonymousAuthentication $AnonymousAuthentication -VDirName $VDirName