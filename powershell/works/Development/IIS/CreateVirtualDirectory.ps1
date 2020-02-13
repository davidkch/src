<#
.SYNOPSIS
Generic script to Create virtual directory under existing website
.DESCRIPTION
Generic script to Create virtual directory under existing website
.EXAMPLE
.\CreateVirtualDirectory.ps1 -WebsiteName "Default Web Site" -VDirName "SampleVDir" -AppPool "DefaultAppPool" -PhysicalPath "D:\test"
Creates "SampleVDir" virtual directory under "Default Web Site" website and maps with existing application pool 'DefaultAppPool'.

.EXAMPLE
.\CreateVirtualDirectory.ps1 -WebsiteName "Default Web Site" -VDirName "SampleVDir" -AppPool "DefaultAppPool" -PhysicalPath "D:\test" -ManagedPipelineMode "classic" -ManagedRuntimeVersion "v4.0" -AppPoolIdentitytype "Built-in" -Builtintype "NetworkService"
Creates "SampleVDir" virtual directory under "Default Web Site" website. It will create new application pool 'DefaultAppPool' and maps it with virtual directory.

.EXAMPLE
.\CreateVirtualDirectory.ps1 -WebsiteName "Default Web Site" -VDirName "SampleVDir" -AppPool "DefaultAppPool" -PhysicalPath "D:\test" -ManagedPipelineMode "classic" -ManagedRuntimeVersion "v4.0" -AppPoolIdentitytype "Custom" -Username "bgcoebld" -Password "password" -Domain "redmond"
Creates "SampleVDir" virtual directory under "Default Web Site" website. It will create new application pool 'DefaultAppPool' and maps it with virtual directory.

Version History  
v1.0   - ESIT Build Team - Initial Release
#>

param(
        [String]$VDirName=$(throw "pass virtual directory name."),
        [String]$PhysicalPath=$(throw "pass physical path for mapping virtual directory."),
        [String]$WebsiteName=$(throw "pass existing website name under which you want to create virtual directory."),
        [String]$AppPool=$(throw "pass existing application pool name."),
        [String]$ManagedPipelineMode="Integrated",
        [String]$ManagedRuntimeVersion="V4.0",
        [String]$AppPoolIdentitytype="Built-in",
        [String]$Builtintype="ApplicationPoolIdentity",
        [String]$Username,
        [String]$Password,
        [String]$Domain
     )

$LogFile="CreateVirtualDirectory.log"     
     
Function CreateVirtualDirectory
{
     Try
     {
              if($ManagedPipelineMode -and ("Classic","Integrated" -NotContains $ManagedPipelineMode))
              {
                   Throw "'$ManagedPipelineMode' is not a valid value for Managed Pipeline Mode! Please use 'Classic' or 'Integrated'"
              }
              if($ManagedRuntimeVersion -and ("v2.0","v4.0" -NotContains $ManagedRuntimeVersion))
              {
                   Throw "'$ManagedRuntimeVersion' is not a valid value for Managed runtime version! Please use 'v2.0' or 'v4.0'"
              }
              if($AppPoolIdentitytype -eq "Built-in")
              {
                  if("LocalService","LocalSystem","NetworkService","ApplicationPoolIdentity" -NotContains $Builtintype) 
                  { 
                        Throw "'$Builtintype' is not a valid application pool built-in identity type! Please use 'LocalService','LocalSystem','NetworkService','ApplicationPoolIdentity'" 
                  }
              }
              elseif($AppPoolIdentitytype -eq "Custom")
              {
                  if(!$Username -or !$Password -or !$Domain)
                  {
                       Throw "Pass Username,Password,Domain parameters for setting application pool identity as custom account."
                  }
                  elseif($Username -and $Password -and $Domain)
                  {
                       $Testcredentials=ValidateUserCredentials
                       if($Testcredentials.IsValid -eq "False")
                       {   
                            Throw "User credentials are not correct. Please check the values provided."
                       }
                  }
              }
          if($AppPoolIdentitytype -and ("Built-in","Custom" -notcontains $AppPoolIdentitytype))
          {
               Throw "Invalid value for 'AppPoolIdentitytype'. Pass either 'Built-in or Custom for setting application pool identity."
          }
          Import-Module WebAdministration
          $Checkwebsite=Get-Website | where {$_.Name -eq "$WebsiteName"}
          if($Checkwebsite)
          {
             if(Test-Path "IIS:\Sites\$WebsiteName\$VDirName")
             {
                 [System.Console]::WriteLine("--------------------------------------------------------")
                 "--------------------------------------------------------" | Out-File $LogFile -Append
                 "Virtual directory '$VDirName' already exists!" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("Virtual directory '$VDirName' already exists!")
                 [System.Console]::WriteLine("--------------------------------------------------------")
                 "--------------------------------------------------------" | Out-File $LogFile -Append
             }   
             else
             {
                 if(Test-Path "IIS:\AppPools\$AppPool")
                 {
                    if(Test-Path "$PhysicalPath")
                    {
                       [System.Console]::WriteLine("----------------------------------------------------------------------------------------------------")
                       "----------------------------------------------------------------------------------------------------" | Out-File $LogFile -Append
                       "Creating virtual directory '$VDirName' under '$WebsiteName' website and mapping it with existing application pool '$AppPool'" | Out-File $LogFile -Append
                       [System.Console]::WriteLine("Creating virtual directory '$VDirName' under '$WebsiteName' website and mapping it with existing application pool '$AppPool'")
                       [System.Console]::WriteLine("----------------------------------------------------------------------------------------------------")
                       "----------------------------------------------------------------------------------------------------" | Out-File $LogFile -Append
                       New-WebApplication -Site "$WebsiteName" -Name "$VDirName" -PhysicalPath "$PhysicalPath" -ApplicationPool "$AppPool"
                    }
                    else
                    {
                         "physical path '$PhysicalPath' does not exists!" | Out-File $LogFile -Append
                         [System.Console]::WriteLine("physical path '$PhysicalPath' does not exists!")
                    }
                 }
                 else
                 {
                    if(Test-Path "$PhysicalPath")
                    {
                       [System.Console]::WriteLine("----------------------------------------------------------------------------------------------------")
                       "----------------------------------------------------------------------------------------------------" | Out-File $LogFile -Append
                       "Creating virtual directory '$VDirName' under '$WebsiteName' website and mapping it with new application pool '$AppPool'" | Out-File $LogFile -Append
                       [System.Console]::WriteLine("Creating virtual directory '$VDirName' under '$WebsiteName' website and mapping it with new application pool '$AppPool'")
                       [System.Console]::WriteLine("----------------------------------------------------------------------------------------------------")
                       "----------------------------------------------------------------------------------------------------" | Out-File $LogFile -Append
                       CreateAppPool
                       New-WebApplication -Site "$WebsiteName" -Name "$VDirName" -PhysicalPath "$PhysicalPath" -ApplicationPool "$AppPool"
                    }
                    else
                    {
                         "physical path '$PhysicalPath' does not exists!" | Out-File $LogFile -Append
                         [System.Console]::WriteLine("physical path '$PhysicalPath' does not exists!")
                    }

                 }
             }    
          
          }
          else
          {
                [System.Console]::WriteLine("--------------------------------------------------------")
                "--------------------------------------------------------" | Out-File $LogFile -Append
                "Website '$WebsiteName' does not exists." | Out-File $LogFile -Append
                [System.Console]::WriteLine("Website '$WebsiteName' does not exists.")
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
          "Execution Completed!" | Out-File $LogFile -Append
           [System.Console]::WriteLine("Execution Completed!")
     }
} 

Function CreateAppPool
{
      Try
      {
              [System.Console]::WriteLine("--------------------------------------------------------")
              "--------------------------------------------------------" | Out-File $LogFile -Append
              "Creating application pool '$AppPool' in IIS" | Out-File $Logfile -Append
              [System.Console]::WriteLine("Creating application pool '$AppPool' in IIS")
              [System.Console]::WriteLine("--------------------------------------------------------")
              "--------------------------------------------------------" | Out-File $LogFile -Append
              New-WebAppPool -Name $AppPool
              $AppPoolsettings=Get-Item "IIS:\AppPools\$AppPool"
              $AppPoolsettings.managedPipelineMode="$ManagedPipelineMode"
              $AppPoolsettings.managedRuntimeVersion="$ManagedRuntimeVersion"
              $AppPoolsettings | Set-Item
              if($AppPoolIdentitytype -eq "Built-in")
              {
                      $AppPoolsettings.processModel.identityType="$Builtintype"
                      $AppPoolsettings | Set-Item
              }
              elseif($AppPoolIdentitytype -eq "Custom")
              {
                      $UserName=$Domain+"\"+$UserName
                      $AppPoolsettings.processModel.userName="$Username"
                      $AppPoolsettings.processModel.password="$Password"
                      $AppPoolsettings.processModel.identityType="SpecificUser"
                      $AppPoolsettings | Set-Item
              }
      }
       Catch
      {
           [System.Exception]
           Write-Output $_.Exception.Message | Out-File $LogFile -Append
           Write-Host $_.Exceptiion.Message
      }
      Finally
      {
           "Application pool creation finished." | Out-File $LogFile -Append
           [System.Console]::WriteLine("Application pool creation finished.")
      }
}

Function ValidateUserCredentials
{
    Try
    {
         Add-Type -AssemblyName System.DirectoryServices.AccountManagement
	     $ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain
	     $pc = New-Object System.DirectoryServices.AccountManagement.PrincipalContext($ct, $Domain)
	     New-Object PSObject -Property @{
		 UserName = $Username;
		 IsValid = $pc.ValidateCredentials($Username, $Password,"Negotiate").ToString()
         }
        
    }
    Catch
    {
         [System.Exception]
         Write-Output $_.Exception.Message | Out-File $LogFile -Append
         Write-Host $_.Exceptiion.Message
    }
    Finally
    {
         "User credentials validation finished." | Out-File $LogFile -Append
         [System.Console]::WriteLine("User credentials validation finished.")
    }
    
}

CreateVirtualDirectory -WebsiteName $WebsiteName -VDirName $VDirName -PhysicalPath $PhysicalPath -AppPool $AppPool -ManagedPipelineMode $ManagedPipelineMode -ManagedRuntimeVersion $ManagedRuntimeVersion -AppPoolIdentitytype $AppPoolIdentitytype -Builtintype $Builtintype -Username $Username -Password $Password
