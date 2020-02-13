#######################  
<#  
.SYNOPSIS  
Generic script to xcopy folders&subfolders of specified physical path to an existing website
.DESCRIPTION  
Generic script to xcopy folders&subfolders of specified physical path to an existing website
.EXAMPLE  
.\ConfigureWebsite_XcopyContent.ps1 -WebsiteName "Default Web Site" -Physicalpath "D:\test"
Xcopies "D:\test" folders&subfolders to physical location of "Default Web Site".

Version History  
v1.0   - ESIT Build Team - Initial Release  
#> 

param(
        [string]$WebsiteName = $(throw "pass name of the existing Website."),
        [string]$Physicalpath = $(throw "pass Physicalpath.")
)

$LogFile = "ConfigureWebsite_XcopyContent.log"

function ConfigureWebsite_XcopyContent
{
       try
       {
                Import-Module Webadministration
                $IISPATH="IIS:\Sites\$WebsiteName"
                if((Test-Path -Path "$physicalpath") -and (Test-Path $IISPATH))
                {
                     $Destinationpath=(Get-Website | Where {$_.Name -eq "$WebsiteName"}).physicalpath
                     [System.Console]::WriteLine("--------------------------------------------------------")
                     "--------------------------------------------------------" | Out-File $LogFile -Append
                     "copying folders and subfolders from sourcepath '$physicalpath' to the physical path of '$WebsiteName' website" | Out-File $LogFile -Append
                     [System.Console]::WriteLine("copying folders and subfolders from sourcepath '$physicalpath' to the physical path of '$WebsiteName' website")
                     [System.Console]::WriteLine("--------------------------------------------------------")
                     "--------------------------------------------------------" | Out-File $LogFile -Append
                     Copy-Item "$Physicalpath\*" -Destination "$Destinationpath" -Recurse
                     
                }
                elseif((Test-Path -Path "$physicalpath") -or (Test-Path $IISPATH))
                {
                      [System.Console]::WriteLine("--------------------------------------------------------")
                      "--------------------------------------------------------" | Out-File $LogFile -Append
                      "Please correct either of the values physical path '$physicalpath',website name '$WebsiteName' as one of the value does not exists." | Out-File $LogFile -Append
                      [System.Console]::WriteLine("Please correct either of the values physical path '$physicalpath',website name '$WebsiteName' as one of the value does not exists.")
                      [System.Console]::WriteLine("--------------------------------------------------------")
                      "--------------------------------------------------------" | Out-File $LogFile -Append
                }
                else
                {
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                       "physical path '$physicalpath','$WebsiteName' website does not exists!" | Out-File $LogFile -Append
                       [System.Console]::WriteLine("physical path '$physicalpath','$WebsiteName' website does not exists!")
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                }
        
       } 
       catch
       {
               [System.Exception]
               Write-Output $_.Exception.Message | Out-File $LogFile -Append
               Write-Host $_.Exception.Message
       }
       Finally
       {
              [System.Console]::WriteLine("Completed Successfully!")
               "Completed Successfully!" | Out-File $LogFile -Append
       }
}

ConfigureWebsite_XcopyContent -WebsiteName $WebsiteName -Physicalpath $Physicalpath

