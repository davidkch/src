<#
.SYNOPSIS  
 Wrapper script for Async Service component
.DESCRIPTION  
 Wrapper script for Async Service component
.EXAMPLE  
.\AsyncService_Wrapper.ps1
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

<#Powershell build-in variables
$ErrorActionPreference = 'SilentlyContinue', 'Continue', 'Stop', 'Inquire'
#>

$ErrorActionPreference = 'SilentlyContinue'       #Supresses errors at the current execution level.  This will not effect script execution, due to that fact that we're using jobs to execute scripts.

<#Custom variables#>
$CurrentMachine = $Env:ComputerName
$RootDirectory = Get-Location
$LogFile = "$RootDirectory\Async_Wrapper.log"
$StepList = [ordered]@{}

#######Environmental specific properties#######
$IP="1.2.3.4"
$FQDN="poedsSSIRDev.parttest.extranettest.microsoft.com"							#(FQDN based on environment and region. IR, SG, or PR)
$DEPLOYMENTMODE="MT"																#(can be LEGACY, FE, MT, or IM)  
$CONFIGDBSERVERNAME="$CurrentMachine`.parttest.extranettest.microsoft.com"			#(must be a server with POEDS_Configuration database installed on it)
$ALTCONFIGDBSERVERNAME="$CurrentMachine`.parttest.extranettest.microsoft.com"		#(must be the mirror server of POEDS_Configuration database)
$ELLOGDBSERVERNAME="$CurrentMachine`.parttest.extranettest.microsoft.com"			#(must be server name where ELLOGGING DB is installed)
$ALTELLOGDBSERVERNAME="$CurrentMachine`.parttest.extranettest.microsoft.com"		#(must be mirror server name where ELLOGGING DB is installed)

#######Pre-req specific properties#######
$AppSeg_ServerList="$CurrentMachine"

#######CORE MSI Properties#######
$TARGETDIR="D:\POEDS\rootWeb"
$INSTALLDIR="D:\POEDS\AsyncService"
$WEBSITE="POEDS"
$HTTPPORT="81"
$TCPPORT="14575"
$APPPOOL="POEDSAsyncService"
$VDIR="ASyncService"
$LOGFOLDER="D:\\POEDS\\Log"
$LOGFOLDERCREATE="D:\POEDS\Log"
$WEBLOGS="D:\WebLogs"
$ERRORDIR="D:\LOG\AS\ERROR"
$DATADIR="D:\LOG\AS\DATA"
$XSLTDIR="D:\POEDS\XSLT"
$XSDDIR="D:\POEDS\XSD"
$LOCALGROUPSLK="SLKAsyncServiceUsers"
$LOCALGROUPPOELOAD="POEDSPOELoadUsers"
$LOCALGROUPPOEPPOS="POEDSPOEPPOSUsers"
$LOCALGROUPPOEDS="POEDSAsyncServiceUsers"
$LOCALGROUPIBB="IBBAsyncServiceUsers"
$LOCALGROUPPING="POEDSPingUsersAS"

Function AsyncService_Wrapper
{
	try
	{
		########LOAD SNAPINS########
		#AddStep -StepName "" -Header "" -Footer "" -File "" -ExecutionDirectory "" -ParameterList @{} -StepList $StepList

		#-------------------------- PRE-STEPS --------------------------------#
		AddStep -StepName "ACE_RemoveAccountsFromUsersGroup" -Header "PreStep - 1 ACE_Prerequisites\RemoveAccountsFromUsersGroup Starts...." -Footer "PreStep - 1 ACE_Prerequisites\RemoveAccountsFromUsersGroup Ends...." -File "List_RemoveAccountsFromUsersGroup.ps1" -ExecutionDirectory "$RootDirectory\PreStep\ACE_Prerequisites\RemoveAccountsFromUsersGroup" -ParameterList @{}
		AddStep -StepName "ACE_RemoveFilesAndDirectories" -Header "PreStep - 2 ACE_Prerequisites\RemoveFilesAndDirectories Starts...." -Footer "PreStep - 2 ACE_Prerequisites\RemoveFilesAndDirectories Ends...." -File "List_RemoveFilesAndDirectories.ps1" -ExecutionDirectory "$RootDirectory\PreStep\ACE_Prerequisites\RemoveFilesAndDirectories" -ParameterList @{  }
#		AddStep -StepName "ACE_LSPNTLMv2Setting" -Header "PreStep - 3 ACE_Prerequisites\LSPNTLMv2Setting Starts...." -Footer "PreStep - 3 ACE_Prerequisites\LSPNTLMv2Setting Ends...." -File "List_LSPNTLMv2Setting.ps1" -ExecutionDirectory "$RootDirectory\PreStep\ACE_Prerequisites\LSPNTLMv2Setting" -ParameterList @{  }
		AddStep -StepName "ACE_RemoveAccountsFromDriveRoot" -Header "PreStep - 4 ACE_Prerequisites\RemoveAccountsFromDriveRoot Starts...." -Footer "PreStep - 4 ACE_Prerequisites\RemoveAccountsFromDriveRoot Ends...." -File "List_RemoveAccountsFromDriveRoot.ps1" -ExecutionDirectory "$RootDirectory\PreStep\ACE_Prerequisites\RemoveAccountsFromDriveRoot" -ParameterList @{  }
		AddStep -StepName "ACE_RemoveSharesFromSystemDrive" -Header "PreStep - 5 ACE_Prerequisites\RemoveSharesFromSystemDrive Starts...." -Footer "PreStep - 5 ACE_Prerequisites\RemoveSharesFromSystemDrive Ends...." -File "List_RemoveSharesFromSystemDrive.ps1" -ExecutionDirectory "$RootDirectory\PreStep\ACE_Prerequisites\RemoveSharesFromSystemDrive" -ParameterList @{  }
		AddStep -StepName "ACE_Services" -Header "PreStep - 6 ACE_Prerequisites\Services Starts...." -Footer "PreStep - 6 ACE_Prerequisites\Services Ends...." -File "List_Services.ps1" -ExecutionDirectory "$RootDirectory\PreStep\ACE_Prerequisites\Services" -ParameterList @{  }
		AddStep -StepName "ACE_TSEncryptionLevelSetting" -Header "PreStep - 7 ACE_Prerequisites\TSEncryptionLevelSetting Starts...." -Footer "PreStep - 7 ACE_Prerequisites\TSEncryptionLevelSetting Ends...." -File "List_TSEncryptionLevelSetting.ps1" -ExecutionDirectory "$RootDirectory\PreStep\ACE_Prerequisites\TSEncryptionLevelSetting" -ParameterList @{  }
		AddStep -StepName "ACE_TSIdleUserSetting" -Header "PreStep - 8 ACE_Prerequisites\TSIdleUserSetting Starts...." -Footer "PreStep - 8 ACE_Prerequisites\TSIdleUserSetting Ends...." -File "List_TSIdleUserSetting.ps1" -ExecutionDirectory "$RootDirectory\PreStep\ACE_Prerequisites\TSIdleUserSetting" -ParameterList @{  }
		AddStep -StepName "Appseg" -Header "PreStep - 9 Appseg Starts...." -Footer "PreStep - 9 Appseg Ends...." -File "List_Appseg.ps1" -ExecutionDirectory "$RootDirectory\PreStep\Appseg" -ParameterList @{ "ServerList" = "$AppSeg_ServerList" }
#		AddStep -StepName "netHSM" -Header "PreStep - 10 netHSM Starts...." -Footer "PreStep - 10 netHSM Ends...." -File "List_netHSM.ps1" -ExecutionDirectory "$RootDirectory\PreStep\netHSM" -ParameterList @{  }
		AddStep -StepName "AppID" -Header "PreStep - 11 AppID Starts...." -Footer "PreStep - 11 AppID Ends...." -File "List_AppID.ps1" -ExecutionDirectory "$RootDirectory\PreStep\AppID" -ParameterList @{  }
		#-------------------------- PRE-STEPS --------------------------------#
		RunAllSteps
		$StepList = [ordered]@{}

		#-------------------------- CORE-STEPS STARTED --------------------------------#
		Write-Host "##########CoreStep - 1 Core Starts....##########" -ForegroundColor "Cyan"
		Write-Output "##########CoreStep - 1 Core Starts....##########" | out-File $LogFile -Append
		.\Execute_MSI.ps1 -InstallType "Install" -FilePath "$RootDirectory\Core\AsyncService.msi" -Params @{ "TARGETDIR"="$TARGETDIR"; "INSTALLDIR"="$INSTALLDIR"; "WEBSITE"="$WEBSITE"; "IP"="$IP"; "HTTPPORT"="$HTTPPORT"; "TCPPORT"="$TCPPORT"; "FQDN"="$FQDN"; "APPPOOL"="$APPPOOL"; "VDIR"="$VDIR"; "DEPLOYMENTMODE"="$DEPLOYMENTMODE"; "LOGFOLDER"="$LOGFOLDER"; "LOGFOLDERCREATE"="$LOGFOLDERCREATE"; "CONFIGDBSERVERNAME"="$CONFIGDBSERVERNAME"; "ALTCONFIGDBSERVERNAME"="$ALTCONFIGDBSERVERNAME"; "ELLOGDBSERVERNAME"="$ELLOGDBSERVERNAME"; "ALTELLOGDBSERVERNAME"="$ALTELLOGDBSERVERNAME"; "WEBLOGS"="$WEBLOGS"; "ERRORDIR"="$ERRORDIR"; "DATADIR"="$DATADIR"; "XSLTDIR"="$XSLTDIR"; "XSDDIR"="$XSDDIR"; "LOCALGROUPSLK"="$LOCALGROUPSLK"; "LOCALGROUPPOELOAD"="$LOCALGROUPPOELOAD"; "LOCALGROUPPOEPPOS"="$LOCALGROUPPOEPPOS"; "LOCALGROUPPOEDS"="$LOCALGROUPPOEDS"; "LOCALGROUPIBB"="$LOCALGROUPIBB"; "LOCALGROUPPING"="$LOCALGROUPPING"; "SIGNCERTPATH"="$SIGNCERTPATH"; "SIGNCERTPASS"="$SIGNCERTPASS"; "SIGNCERTPATHSLK"="$SIGNCERTPATHSLK" } | Out-File $LogFile -Append
		Write-Output "**********CoreStep - 1 Core Ends....**********" | Out-File $LogFile -Append
		Write-Host "**********CoreStep - 1 Core Ends....**********" -ForegroundColor "Cyan"
		#-------------------------- CORE-STEPS COMPLETED --------------------------------#

		#-------------------------- POST-STEPS --------------------------------#
		AddStep -StepName "Create_LocalGroups" -Header "PostStep - 1 PostStep\Create_LocalGroups Starts...." -Footer "PostStep - 1 PostStep\Create_LocalGroups Ends...." -File "List_CreateLocalGroups.ps1" -ExecutionDirectory "$RootDirectory\PostStep\Create_LocalGroups" -ParameterList @{  }
		AddStep -StepName "Create_Shares" -Header "PostStep - 2 PostStep\Create_Shares Starts...." -Footer "PostStep - 2 PostStep\Create_Shares Ends...." -File "List_CreateShares.ps1" -ExecutionDirectory "$RootDirectory\PostStep\Create_Shares" -ParameterList @{  }
		AddStep -StepName "UpdateFileFolderPermissions" -Header "PostStep - 3 PostStep\Update_FileFolderPermissions Starts...." -Footer "PostStep - 3 PostStep\Update_FileFolderPermissions Ends...." -File "List_UpdateFileFolderPermissions.ps1" -ExecutionDirectory "$RootDirectory\PostStep\Update_FileFolderPermissions" -ParameterList @{  }
		AddStep -StepName "Install_Certificate" -Header "PostStep - 4 PostStep\Install_Certificate Starts...." -Footer "PostStep - 4 PostStep\Install_Certificate Ends...." -File "List_InstallCertificate.ps1" -ExecutionDirectory "$RootDirectory\PostStep\Install_Certificate" -ParameterList @{  }
		AddStep -StepName "Install_CertificateToStore" -Header "PostStep - 5 PostStep\Install_CertificateToStore Starts...." -Footer "PostStep - 5 PostStep\Install_CertificateToStore Ends...." -File "List_InstallCertificateToStore.ps1" -ExecutionDirectory "$RootDirectory\PostStep\Install_CertificateToStore" -ParameterList @{  }
		AddStep -StepName "Rename_Files" -Header "PostStep - 6 PostStep\Rename_Files Starts...." -Footer "PostStep - 6 PostStep\Rename_Files Ends...." -File "List_RenameFiles.ps1" -ExecutionDirectory "$RootDirectory\PostStep\Rename_Files" -ParameterList @{  }
		AddStep -StepName "Install_DLL" -Header "PostStep - 7 PostStep\Install_DLL Starts...." -Footer "PostStep - 7 PostStep\Install_DLL Ends...." -File "List_InstallBinary.ps1" -ExecutionDirectory "$RootDirectory\PostStep\Install_DLL" -ParameterList @{  }
		AddStep -StepName "Update_WebsiteBindings" -Header "PostStep - 8 PostStep\Update_WebsiteBindings Starts...." -Footer "PostStep - 8 PostStep\Update_WebsiteBindings Ends...." -File "List_UpdateWebsiteBindings.ps1" -ExecutionDirectory "$RootDirectory\PostStep\Update_WebsiteBindings" -ParameterList @{ "IP" = "$IP";  "FQDN" = "$FQDN"; "DeploymentMode" = "$DeploymentMode" }
		#-------------------------- POST-STEPS --------------------------# 
		RunAllSteps
		$StepList = [ordered]@{}
	}
	Catch [system.Exception]
	{
		Write-Host "Errors have been encountered during execution.  Please check log file $LogFile for errors." -ForegroundColor "Red"            
		Write-Output $_.exception.message | Out-File $LogFile -Append
	}
	Finally
	{
		Write-Output "AsyncService_Wrapper.ps1 Executed Successfully...." | Out-File $LogFile -Append
	}
}

Function RunAllSteps
{
  foreach($Step in $StepList)
  {
   foreach($StepValues in $Step.Values)
   {
     #Individual step values.
     $Header = $StepValues["Header"]
     $Footer = $StepValues["Footer"]
     $ExecutionDirectory = $StepValues["ExecutionDirectory"]
     $File = $StepValues["File"]
     $ParameterList = $StepValues["ParameterList"]

     $Result = Execute_Step -Header "$Header" -Footer "$Footer" -File "$File" -ExecutionDirectory "$ExecutionDirectory" -ParameterList $ParameterList
     Write-host $Result
   }
  }
}

Function Execute_Step
{
 param(
 $Header = $(throw "Please pass the Header."),
 $Footer = $(throw "Please pass the Footer."),
 $File = $(throw "Please pass the name of the script to be executed."),
 $ExecutionDirectory = $(throw "Please pass the directory where the script is located."),
 $ParameterList = $(throw "Please pass the script parameters.")
 )

    $SortedParams = ""

	foreach($ParameterName in $ParameterList.Keys)
    {
	$ParameterValue=$ParameterList["$ParameterName"]
	$SortedParams += "-$ParameterName `"$ParameterValue`" "
    }

	Write-Host "########## $Header ##########" -foreground "Cyan"
	Write-Output "########## $Header ##########" | Out-File $LogFile -Append

    $Job = Start-Job -ScriptBlock { 
	 $Header = "{3}" -f $args;            
	 $LogFile = "{4}" -f $args;
	 Invoke-Expression ("Set-Location `"{0}`"" -f $args);          #Sets the location of the script to be called
	 Invoke-Expression (".\{1} {2}" -f $args);                 #Call specified script with parameters, if any
	 if($Error.Count -gt 0)                                    #Check for errors
	 {         	  
          foreach($Err in $Error)                                  #Print each error 
	  { 
		Write-Output "ERROR: " $Err | Out-File $LogFile -Append
	  }   
	  throw "STEP FAILED: $Header"
	 }
	 else
	 {
		Write-Host "STEP SUCCEEDED: $Header" -ForegroundColor "Green"
		Write-Output "STEP SUCCEEDED: $Header" | Out-File $LogFile -Append
	 }
    } -Name "ExecuteScripts" -ErrorVariable ScriptErrors -ErrorAction Stop -ArgumentList "$ExecutionDirectory", "$File", "$SortedParams", "$Header", "$LogFile"

    $ret = Receive-Job $job -Wait -AutoRemoveJob

    foreach($out in $ret)
    {
      Write-Output $out | Out-File $LogFile -Append
    }

    if($job.State -ieq 'Failed')
    { 
	Write-Host "STEP FAILED: $Header" -ForegroundColor "Red"
	Write-Output "STEP FAILED:  $Header" | Out-File $LogFile -Append
    }
 
	Write-Output "********** $Footer **********" | Out-File $LogFile -Append
	Write-Output "" | Out-File $LogFile -Append
	write-host "********** $Footer **********" -foreground "Cyan"
	write-host ""
    if($job.State -ieq 'Failed')
    { throw "Errors have been encountered during execution.  Please check log file $LogFile for errors." }
}

Function AddStep
{
 param(
   $StepName = $(throw "Please pass a unique Step Name."),
   $Header = $(throw "Please pass the Header."),
   $Footer = $(throw "Please pass the Footer."),
   $File = $(throw "Please pass the File name."),
   $ExecutionDirectory = $(throw "Please pass the path of the file."),
   $ParameterList = $(throw "Please pass the ParameterList.")
 )
 Write-Output "Adding Step `"$StepName`" to list of steps..." | Out-File $LogFile -Append

 $StepValuesList = [ordered]@{}
 $StepValuesList.Add("Header", "$Header");
 $StepValuesList.Add("ExecutionDirectory", "$ExecutionDirectory");
 $StepValuesList.Add("File", "$File");
 $StepValuesList.Add("ParameterList", $ParameterList);
 $StepValuesList.Add("Footer", "$Footer");
 $StepList.Add("$StepName", $StepValuesList);
}

AsyncService_Wrapper