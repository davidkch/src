#######################  
<#  
.SYNOPSIS  
 Update existing binding information for a website
.DESCRIPTION  
 Update existing binding information for a website
.EXAMPLE  
.\Set_UpdateWebsiteBindings.ps1 -Website POEDS -VirDir AsyncService -TcpPort 12345 -IP '12.34.56.78' -HTTPPort 81 -AppPool POEDSAsyncService -WebLogs D:\WebLogs -DeploymentMode MT -FQDN "myfqdn.microsoft.com"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    $Website = (throw "Please pass the website name."),
    $VirDir = (throw "Please pass the virtual directory name."),
    $TcpPort = (throw "Please pass the TcpPort number."),
    $IP = (throw "Please pass the IP address of the website."),
    $HTTPPort = (throw "Please pass the HTTPPort of the website."),
    $AppPool = (throw "Please pass the AppPool name of the website."),
    $WebLogs = (throw "Please pass the directory for weblogs."),
    $DeploymentMode = (throw "Please pass the Deployment Mode."),
    $FQDN = (throw "Please pass fully qualified domain name for website (FQDN).")
)

Function Set_UpdateWebsiteBindings
{
	try
	{
        Write-Output "Updating bindings for specified website..."
        Write-Output "AppPool:  $AppPool"
        Write-Output "WebSite:  $WebSite"
        Write-Output "VirDir:  $VirDir"
        Write-Output "TCPPort:  $TCPPort"
        Write-Output "FQDN:  $FQDN"

        $output = & $Env:windir\system32\inetsrv\appcmd.exe set config /section:applicationpools /"[Name='POEDSAPPPool'].managedPipelineMode:Integrated"
	Write-Output $output 

        $output = & $Env:windir\system32\inetsrv\appcmd.exe set config /section:applicationpools /"[Name='$AppPool'].managedPipelineMode:Integrated"
	Write-Output $output 

        $output = & $Env:windir\system32\inetsrv\appcmd.exe set apppool /apppool.name:POEDSAPPPool /managedRuntimeVersion:v4.0
	Write-Output $output 

        $output = & $Env:windir\system32\inetsrv\appcmd.exe set apppool /apppool.name:$AppPool /managedRuntimeVersion:v4.0
	Write-Output $output 

        $output = & $Env:windir\system32\inetsrv\appcmd.exe set apppool /apppool.name:$AppPool /startMode:AlwaysRunning
	Write-Output $output 

        $output = & $Env:windir\system32\inetsrv\appcmd.exe set apppool /apppool.name:POEDSAPPPool /enable32BitAppOnWin64:false
	Write-Output $output 

        $output = & $Env:windir\system32\inetsrv\appcmd.exe set apppool /apppool.name:$AppPool /enable32BitAppOnWin64:false
	Write-Output $output 

        #**************************************************************************************************
        #Enable IIS extended protection

        $output = & $Env:windir\system32\inetsrv\appcmd.exe set config "$WebSite" -section:system.webServer/security/authentication/windowsAuthentication /extendedProtection.tokenChecking:"Allow" /extendedProtection.flags:"None" /commit:apphost
	Write-Output $output         

	$output = & $Env:windir\system32\inetsrv\appcmd.exe set config "$WebSite/$VirDir" -section:system.webServer/security/authentication/windowsAuthentication /extendedProtection.tokenChecking:"Allow" /extendedProtection.flags:"None" /commit:apphost
	Write-Output $output 

        Switch($DeploymentMode)
        {
          "LEGACY"
          { 
            $output = & $Env:windir\system32\inetsrv\appcmd.exe set site "$WebSite" /+"bindings.[protocol='net.tcp',bindingInformation='$TCPPort`:$FQDN']"
	    Write-Output $output 

            $output = & $Env:windir\system32\inetsrv\appcmd.exe set site "$WebSite" /+"bindings.[protocol='net.pipe',bindingInformation='*']"
	    Write-Output $output 

            $output = & $Env:windir\system32\inetsrv\appcmd.exe set app "$WebSite/$VirDir" /enabledProtocols:net.tcp,net.pipe
	    Write-Output $output 
          }

          "FE"
          {
            $output = & $Env:windir\system32\inetsrv\appcmd.exe set site "$WebSite" /+"bindings.[protocol='net.pipe',bindingInformation='*']"
	    Write-Output $output 

            $output = & $Env:windir\system32\inetsrv\appcmd.exe set app "$WebSite/$VirDir" /enabledProtocols:net.pipe
	    Write-Output $output 
          }

          "MT"
          {
	    $output = & $Env:windir\system32\inetsrv\appcmd.exe set site "$WebSite" /+"bindings.[protocol='net.tcp',bindingInformation='$TCPPort`:$FQDN']"            
	    Write-Output $output  

	    $output = & $Env:windir\system32\inetsrv\appcmd.exe set app "$WebSite/$VirDir" /enabledProtocols:net.tcp
	    Write-Output $output 
          }

          "IM"
          {
            $output = & $Env:windir\system32\inetsrv\appcmd.exe set site "$WebSite" /+"bindings.[protocol='net.tcp',bindingInformation='$TCPPort`:$FQDN']"
            Write-Output $output  

	    $output = & $Env:windir\system32\inetsrv\appcmd.exe set app "$WebSite/$VirDir" /enabledProtocols:net.tcp
	    Write-Output $output  
          }
        }

        $output = & $Env:windir\system32\inetsrv\appcmd.exe set config /section:sites /siteDefaults.logFile.directory:$WebLogs"
	Write-Output $output  

        $output = & $Env:windir\system32\inetsrv\appcmd.exe set app $WebSite/$VirDir /serviceAutoStartEnabled:true"
	Write-Output $output  

        ######FUTURE USE######
        #$output = .\ManageFolderPermission.ps1
        #Write-Output $output 
    }
	Catch [system.exception]
	{
		write-output "ERROR: " $_.exception.message 
	}
	Finally
	{
		Write-Output "Set_UpdateWebsiteBindings.ps1 Executed Successfully" 
	}
}

Set_UpdateWebsiteBindings  -Website $Website -VirDir $VirDir -TcpPort $TCPPort -IP $IP -HTTPPort $HTTPPort -AppPool $AppPool -WebLogs $WebLogs -DeploymentMode $DeploymentMode -FQDN $FQDN