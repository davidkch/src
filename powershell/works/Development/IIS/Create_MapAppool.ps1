<#
.SYNOPSIS
Generic script to Create an Application pool and mapping it to an existing website in IIS
.DESCRIPTION
Generic script to Create an Application pool and mapping it to an existing website in IIS
.EXAMPLE
.\Create_MapAppool.ps1 -ApppoolName "Defaultapplicatinpool" -WebsiteName "Default Web Site" -ManagedRuntimeVersion "v4.0" -ManagedPipelineMode "Classic" -AppPoolIdentitytype "Custom" -UserName "bgcoebld" -Password "password" -Domain "redmond" -VirtualDirectory "samplevdir"
creates "Defaultapplicatinpool" with ManagedRuntimeVersion(v4.0),ManagedPipelineMode(classic) and sets application pool identity as customaccount(redmond\bgcoebld) and maps it with "Default Web Site\samplevdir" virtual directory.

"ManagedRuntimeVersion" value should be either "V2.0" or "V4.0"
"ManagedPipelineMode" value should be either "Classic" or "Integrated"
"AppPoolIdentitytype" value should be either "Built-in" or "Custom"
.EXAMPLE
.\Create_MapAppool.ps1 -ApppoolName "Defaultapplicatinpool" -WebsiteName "Default Web Site" -ManagedRuntimeVersion "v4.0" -ManagedPipelineMode "Classic" -AppPoolIdentitytype "Built-in" -Builtintype "NetworkService"
creates "Defaultapplicatinpool" with ManagedRuntimeVersion(v4.0),ManagedPipelineMode(classic) and sets application pool identity as built-in account(NetworkService) and maps it with "Default Web Site" website.

Version History  
v1.0   - ESIT Build Team - Initial Release
#>

param(
         [String]$ApppoolName=$(throw "pass Application pool name"),
         [String]$WebsiteName=$(throw "pass Website name"),
         [String]$ManagedRuntimeVersion=$(throw "pass .Net Framework version for application pool"),
         [String]$ManagedPipelineMode=$(throw "pass managed pipelinemode for application pool"),
         [String]$AppPoolIdentitytype=$(throw "pass either 'Built-in' or 'Custom' for setting application pool identity." ),
         [String]$Builtintype="ApplicationPoolIdentity",[String]$UserName,[String]$Password,[String]$Domain,[String]$VirtualDirectory
     )

$LogFile="Create_MapAppool.log"

function Create_MapAppool
{
         Try
         {
                 Import-Module WebAdministration
                 If("Classic","Integrated" -NotContains $ManagedPipelineMode)
                 {
                      Throw "'$ManagedPipelineMode' is not a valid value for Managed Pipeline Mode! Please use 'Classic' or 'Integrated'"
                 }
				 If("Built-in","Custom" -NotContains $AppPoolIdentitytype)
                 {
                      Throw "'$AppPoolIdentitytype' is not a valid value for AppPoolIdentitytype! Please use 'Built-in' or 'Custom'"
                 }
                 If("v2.0","v4.0" -NotContains $managedRuntimeVersion)
                 {
                      Throw "'$managedRuntimeVersion' is not a valid value for Managed runtime version! Please use 'v2.0' or 'v4.0'"
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
                    if(!$UserName -or !$Password -or !$Domain)
                    {
                        Throw "Pass UserName,Password,Domain parameters for setting application pool identity as custom account."
                    }
                    elseif($UserName -and $Password -and $Domain)
                    {
                        $Testcredentials=ValidateUserCredentials
                       if($Testcredentials.IsValid -eq "False")
                       {   
                            Throw "User credentials are not correct. Please check the values provided."
                       }
                    }
                 }
                 if($VirtualDirectory)
                 {
                      $WebsiteName=$WebsiteName+"/"+$VirtualDirectory
                 }
                 if((Test-Path "IIS:\AppPools\$ApppoolName") -and (Test-Path "IIS:\Sites\$WebsiteName"))
                 {
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                       "application pool and website already exists! Hence mapping '$ApppoolName' application pool with '$WebsiteName' website." | Out-File $LogFile -Append
                       [System.Console]::WriteLine("application pool and website already exists! Hence mapping '$ApppoolName' application pool with '$WebsiteName' website.")
                       [System.Console]::WriteLine("--------------------------------------------------------")
                       "--------------------------------------------------------" | Out-File $LogFile -Append
                        Set-ItemProperty "IIS:\Sites\$WebsiteName" ApplicationPool "$ApppoolName"
                 }
                 elseif(!(Test-Path "IIS:\AppPools\$ApppoolName") -and (Test-Path "IIS:\Sites\$WebsiteName"))
                 {
                        [System.Console]::WriteLine("--------------------------------------------------------")
                        "--------------------------------------------------------" | Out-File $LogFile -Append
                       "Creating application pool '$ApppoolName' in IIS" | Out-File $Logfile -Append
                        [System.Console]::WriteLine("Creating application pool '$ApppoolName' in IIS")
                        [System.Console]::WriteLine("--------------------------------------------------------")
                        "--------------------------------------------------------" | Out-File $LogFile -Append
                        New-WebAppPool -Name $ApppoolName
                        $apppoolsettings=Get-Item "IIS:\AppPools\$ApppoolName"
                        $apppoolsettings.managedPipelineMode="$ManagedPipelineMode"
                        $apppoolsettings.managedRuntimeVersion="$ManagedRuntimeVersion"
                        $apppoolsettings | Set-Item
                        if($AppPoolIdentitytype -eq "Built-in")
                        {
                            $apppoolsettings.processModel.identityType="$Builtintype"
                            $apppoolsettings | Set-Item
                        }
                        elseif($AppPoolIdentitytype -eq "Custom")
                        {
                            $UserName=$Domain+"\"+$UserName
                            $apppoolsettings.processModel.userName="$UserName"
                            $apppoolsettings.processModel.password="$Password"
                            $apppoolsettings.processModel.identityType="SpecificUser"
                            $apppoolsettings | Set-Item
                        }
                        [System.Console]::WriteLine("-----------------------------------------------------------------------------")
                        "-----------------------------------------------------------------------------" | Out-File $LogFile -Append
                        "Mapping application pool '$ApppoolName' with '$WebsiteName' website." | Out-File $Logfile -Append
                        [System.Console]::WriteLine("Mapping application pool '$ApppoolName' with '$WebsiteName' website.")
                        [System.Console]::WriteLine("-----------------------------------------------------------------------------")
                        "-----------------------------------------------------------------------------" | Out-File $LogFile -Append
                        Set-ItemProperty "IIS:\Sites\$WebsiteName" ApplicationPool "$ApppoolName"
                   }
                   elseif((Test-Path "IIS:\AppPools\$ApppoolName") -and !(Test-Path "IIS:\Sites\$WebsiteName"))
                   {
                         [System.Console]::WriteLine("--------------------------------------------------------")
                         "--------------------------------------------------------" | Out-File $LogFile -Append
                         "website/virtualdirectory '$WebsiteName' does not exists!" | Out-File $LogFile -Append
                         [System.Console]::WriteLine("website/virtualdirectory '$WebsiteName' does not exists!")
                         [System.Console]::WriteLine("--------------------------------------------------------")
                         "--------------------------------------------------------" | Out-File $LogFile -Append
                   }
                   else
                   {
                          [System.Console]::WriteLine("--------------------------------------------------------")
                          "--------------------------------------------------------" | Out-File $LogFile -Append
                          "'$WebsiteName' does not exists!" | Out-File $LogFile -Append
                          [System.Console]::WriteLine("'$WebsiteName' does not exists!")
                          [System.Console]::WriteLine("--------------------------------------------------------")
                          "--------------------------------------------------------" | Out-File $LogFile -Append
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
           [System.Console]::WriteLine("Execution Completed!")
           "Execution Completed!" | Out-File $Logfile -Append
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

Create_MapAppool -ApppoolName $ApppoolName -WebsiteName $WebsiteName -ManagedRuntimeVersion $ManagedRuntimeVersion -ManagedPipelineMode $ManagedPipelineMode -AppPoolIdentitytype $AppPoolIdentitytype -Builtintype $Builtintype -UserName $UserName -Password $Password -Domain $Domain -VirtualDirectory $VirtualDirectory