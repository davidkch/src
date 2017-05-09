<#
.SYNOPSIS
Generic script to deploy .cspkg package on to azure.
.DESCRIPTION
Generic script to deploy .cspkg package on to azure.
.EXAMPLE
.\DeployPackage_Azure.ps1 -PackageLocation "D:\test\DSLinkGen.cspkg" -CloudConfigLocation "D:\test\ServiceConfiguration.cscfg" -DeploymentSlot "Staging" -SubScriptionName "Distribution Services Preprod" -StorageAccount "dsdevlinkgenstore" -Servicename "dsdevlinkgen" -Label "LinkGen Test Build" -PublishSettingsFile "D:\powershell\POCAIS-Distribution Services Preprod-Silver Lining Dev-1-16-2013-credentials.publishsettings"
This will do the new deployment with deploymentname "LinkGen Test Build"

.EXAMPLE
.\DeployPackage_Azure.ps1 -PackageLocation "D:\test\DSLinkGen.cspkg" -CloudConfigLocation "D:\test\ServiceConfiguration.cscfg" -DeploymentSlot "Staging" -SubScriptionName "Distribution Services Preprod" -StorageAccount "dsdevlinkgenstore" -Servicename "dsdevlinkgen" -Label "LinkGen Test Build" -PublishSettingsFile "D:\powershell\POCAIS-Distribution Services Preprod-Silver Lining Dev-1-16-2013-credentials.publishsettings" -RoleName "All"
This will do an upgradation on existing deployment "LinkGen Test Build" for all the roles

Version History  
v1.0   - ESIT Build Team - Initial Release
#>

param(
         [String]$PackageLocation=$(throw "Pass physical path of the .cspkg package file"),
         [String]$CloudConfigLocation=$(throw "Pass physical path of the .cscfg file"),
         [String]$DeploymentSlot=$(throw "Pass deployment slot. This value should be either 'Staging' or 'Production'"),
         [String]$SubScriptionName=$(throw "Pass deployment subscriptionname"),
         [String]$StorageAccount=$(throw "Pass deployment storageaccount"),
         [String]$Servicename=$(throw "Pass deployment servicename"),
         [String]$Label=$(throw "Pass deployment label name"),
         [String]$PublishSettingsFile=$(throw "Pass physical path of .publishsettingsfile"),
         [String]$RoleName="All"
)

$LogFile="DeployPackage_Azure.log"

Function DeployPackage_Azure
{
      Try
      {  
           [System.Console]::WriteLine("PackageLocation: $PackageLocation")
           [System.Console]::WriteLine("CloudConfigLocation: $CloudConfigLocation")
           [System.Console]::WriteLine("DeploymentSlot: $DeploymentSlot")
           [System.Console]::WriteLine("SubScriptionName: $SubScriptionName")
           [System.Console]::WriteLine("StorageAccount: $StorageAccount")
           [System.Console]::WriteLine("Servicename: $Servicename")
           [System.Console]::WriteLine("Label: $Label")
           [System.Console]::WriteLine("PublishSettingsFile: $PublishSettingsFile")
           [System.Console]::WriteLine("RoleName: $RoleName")
           "PackageLocation: $PackageLocation" | Out-File $LogFile -Append
           "CloudConfigLocation: $CloudConfigLocation" | Out-File $LogFile -Append
           "DeploymentSlot: $DeploymentSlot" | Out-File $LogFile -Append
           "SubScriptionName: $SubScriptionName" | Out-File $LogFile -Append
           "StorageAccount: $StorageAccount" | Out-File $LogFile -Append
           "Servicename: $Servicename" | Out-File $LogFile -Append
           "Label: $Label" | Out-File $LogFile -Append
           "PublishSettingsFile: $PublishSettingsFile" | Out-File $LogFile -Append
           "RoleName: $RoleName" | Out-File $LogFile -Append
          if((Test-Path $PackageLocation) -and (Test-Path $CloudConfigLocation) -and (Test-Path $PublishSettingsFile))
          {
               try
               {
               Import-Module Azure
               if($? -eq $false)
                 {
                   $exitcode=1
                   exit $exitcode
                 }
               }
               catch
               {
                   Write-Host "File Already Imported or it doesnot exists"
               }
               Import-AzurePublishSettingsFile -PublishSettingsFile $PublishSettingsFile
               Set-AzureSubscription –NoDefaultSubscription
               Set-AzureSubscription $SubScriptionName -CurrentStorageAccount $StorageAccount
               Select-AzureSubscription –SubscriptionName $SubScriptionName
           
              $Result=Get-AzureDeployment -ServiceName $Servicename -Slot $DeploymentSlot
              Start-Sleep -s 5

              if(((Get-Variable Result).Value) -eq $null)
              {
                 $ErrorActionPreference="Stop"
                 [System.Console]::WriteLine("---------------------------------------------------------------------------------------------")
                 "---------------------------------------------------------------------------------------------" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("Package Doesnot exist in the Portal for the slot $DeploymentSlot..... Processing a new upload")
                 "Package Doesnot exist in the Portal for the slot $DeploymentSlot..... Processing a new upload" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("$(Get-Date –f $timeStampFormat) - Deployment Started: In progress")
                 "$(Get-Date –f $timeStampFormat) - Deployment Started: In progress" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("---------------------------------------------------------------------------------------------")
                 "---------------------------------------------------------------------------------------------" | Out-File $LogFile -Append
                 # perform New-Deployment
                 $setdeployment = New-AzureDeployment -Slot $DeploymentSlot -Package $PackageLocation -Configuration $CloudConfigLocation -label $Label -ServiceName $Servicename
                 if($? -ne $true)
                 {
                     $exitcode=1
                     exit $exitcode
                 }
                 else
                 {
                    $exitcode=0
                    $completeDeployment = Get-AzureDeployment -ServiceName $Servicename -Slot $DeploymentSlot
                    $completeDeploymentID = $completeDeployment.deploymentid
                    [System.Console]::WriteLine("---------------------------------------------------------------------------------------------")
                    "---------------------------------------------------------------------------------------------" | Out-File $LogFile -Append
                    [System.Console]::WriteLine("Deployment Successful")
                    "Deployment Successful" | Out-File $LogFile -Append
                    [System.Console]::WriteLine("$(Get-Date –f $timeStampFormat) - New Deployment: Complete, Deployment ID: $completeDeploymentID")
                    "$(Get-Date –f $timeStampFormat) - New Deployment: Complete, Deployment ID: $completeDeploymentID" | Out-File $LogFile -Append
                    [System.Console]::WriteLine("---------------------------------------------------------------------------------------------")
                    "---------------------------------------------------------------------------------------------" | Out-File $LogFile -Append
                 }
               }
               else
               {
                 $ErrorActionPreference="Stop"
                 [System.Console]::WriteLine("------------------------------------------------------------------------------------------")
                 "---------------------------------------------------------------------------------------------" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("Package exists.. processing to update the package..")
                 "Package exists.. processing to update the package.." | Out-File $LogFile -Append
                 [System.Console]::WriteLine("$(Get-Date –f $timeStampFormat) - Upgrading Deployment: In progress")
                 "$(Get-Date –f $timeStampFormat) - Upgrading Deployment: In progress" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("------------------------------------------------------------------------------------------")
                 "---------------------------------------------------------------------------------------------" | Out-File $LogFile -Append
                 # Perform Update-Deployment
                 if($RoleName -eq "All")
                 {
                       [System.Console]::WriteLine("RoleName is set to $RoleName")
                       "RoleName is set to $RoleName" | Out-File $LogFile -Append
                       $setdeployment = Set-AzureDeployment -Upgrade -Slot $DeploymentSlot -Package $PackageLocation -Configuration $CloudConfigLocation -label $Label -ServiceName $Servicename -Force
                       if($? -ne $true)
                       {
                            $exitcode=1
                            [System.Console]::Writeline("Unable to Upgrade Please check the logs for error....")
                            "Unable to Upgrade Please check the logs for error...." | Out-File $LogFile -Append
                            exit $exitcode
                       }
                       else
                       {
                            $exitcode=0
                            $completeDeployment = Get-AzureDeployment -ServiceName $serviceName -Slot $DeploymentSlot
                            $completeDeploymentID = $completeDeployment.deploymentid
                            [System.Console]::WriteLine("------------------------------------------------------------------------------------------")
                            "---------------------------------------------------------------------------------------------" | Out-File $LogFile -Append
                            [System.Console]::WriteLine("Completed Upgrading the Deployment")
                            "Completed Upgrading the Deployment" | Out-File $LogFile -Append
                            [System.Console]::WriteLine("$(Get-Date –f $timeStampFormat) - Upgrading Deployment: Complete, Deployment ID: $completeDeploymentID")
                            "$(Get-Date –f $timeStampFormat) - Upgrading Deployment: Complete, Deployment ID: $completeDeploymentID" | Out-File $LogFile -Append
                            [System.Console]::WriteLine("------------------------------------------------------------------------------------------")
                            "---------------------------------------------------------------------------------------------" | Out-File $LogFile -Append
                       }
                  }
                  else
                  {
                       [System.Console]::WriteLine("RoleName is set to $RoleName")
                       $setdeployment = Set-AzureDeployment -Upgrade -Slot $DeploymentSlot -Package $PackageLocation -Configuration $CloudConfigLocation -label $Label -ServiceName $Servicename -RoleName $RoleName -Force
                       if($? -ne $true)
                       {
                            $exitcode=1
                            [System.Console]::Writeline("Unable to Upgrade Please check the logs for error....")
                            "Unable to Upgrade Please check the logs for error...." | Out-File $LogFile -Append
                            exit $exitcode
                       }
                       else
                       {
                            $exitcode=0
                            $completeDeployment = Get-AzureDeployment -ServiceName $serviceName -Slot $DeploymentSlot
                            $completeDeploymentID = $completeDeployment.deploymentid
                            [System.Console]::WriteLine("Completed Upgrading the Deployment")
                            [System.Console]::WriteLine("------------------------------------------------------------------------------------------")
                            "------------------------------------------------------------------------------------------" | Out-File $LogFile -Append
                            [System.Console]::WriteLine("$(Get-Date –f $timeStampFormat) - Upgrading Deployment: Complete, Deployment ID: $completeDeploymentID")
                            "$(Get-Date –f $timeStampFormat) - Upgrading Deployment: Complete, Deployment ID: $completeDeploymentID" | Out-File $LogFile -Append
                            [System.Console]::WriteLine("------------------------------------------------------------------------------------------")
                            "------------------------------------------------------------------------------------------" | Out-File $LogFile -Append
                       }
                  }
               }
 
              [System.Console]::WriteLine("Done with the Deployment.....")
              "Done with the Deployment....." | Out-File $LogFile -Append
          }
          else
          {
              "Please check path of the Packagefile '$PackageLocation' and configurationfile '$CloudConfigLocation' & publishsettingsfile '$PublishSettingsFile'. Either of the file does not exists!"
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

DeployPackage_Azure -PackageLocation $PackageLocation -CloudConfigLocation $CloudConfigLocation -DeploymentSlot $DeploymentSlot -SubScriptionName $SubScriptionName -StorageAccount $StorageAccount -Servicename $Servicename -Label $Label -PublishSettingsFile $PublishSettingsFile -RoleName $RoleName