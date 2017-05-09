echo off

SET WebSite=%1
SET Vdir=%2
SET TCPPort=%3
SET IP=%4
SET HTTPPORT=%5
SET APPPOOL=%6
SET WEBLOG=%7
SET DEPLOYMENTMODE=%8
SET FQDN=%9


%windir%\system32\inetsrv\appcmd.exe set config /section:applicationpools /[Name='POEDSAPPPool'].managedPipelineMode:Integrated

%windir%\system32\inetsrv\appcmd.exe set config /section:applicationpools /[Name='%APPPOOL%'].managedPipelineMode:Integrated
%windir%\system32\inetsrv\appcmd.exe set apppool /apppool.name:POEDSAPPPool /managedRuntimeVersion:v4.0
%windir%\system32\inetsrv\appcmd.exe set apppool /apppool.name:%APPPOOL% /managedRuntimeVersion:v4.0
%windir%\system32\inetsrv\appcmd.exe set apppool /apppool.name:%APPPOOL% /startMode:AlwaysRunning

%windir%\system32\inetsrv\appcmd.exe set apppool /apppool.name:POEDSAPPPool /enable32BitAppOnWin64:false
%windir%\system32\inetsrv\appcmd.exe set apppool /apppool.name:%APPPOOL% /enable32BitAppOnWin64:false

REM **************************************************************************************************
REM Enable IIS extended protection
%windir%\system32\inetsrv\appcmd.exe set config %WebSite% -section:system.webServer/security/authentication/windowsAuthentication /extendedProtection.tokenChecking:"Allow" /extendedProtection.flags:"None" /commit:apphost
%windir%\system32\inetsrv\appcmd.exe set config %WebSite%/%Vdir% -section:system.webServer/security/authentication/windowsAuthentication /extendedProtection.tokenChecking:"Allow" /extendedProtection.flags:"None" /commit:apphost


IF %DEPLOYMENTMODE% EQU LEGACY (
%windir%\system32\inetsrv\appcmd.exe set site %WebSite% /+bindings.[protocol='net.tcp',bindingInformation='%TCPPort%:%FQDN%']
%windir%\system32\inetsrv\appcmd.exe set site %WebSite% /+bindings.[protocol='net.pipe',bindingInformation='*']
%windir%\system32\inetsrv\appcmd.exe set app %WebSite%/%Vdir% /enabledProtocols:net.tcp,net.pipe
)

IF %DEPLOYMENTMODE% EQU FE (
%windir%\system32\inetsrv\appcmd.exe set site %WebSite% /+bindings.[protocol='net.pipe',bindingInformation='*']
%windir%\system32\inetsrv\appcmd.exe set app %WebSite%/%Vdir% /enabledProtocols:net.pipe
)

IF %DEPLOYMENTMODE% EQU MT (
%windir%\system32\inetsrv\appcmd.exe set site %WebSite% /+bindings.[protocol='net.tcp',bindingInformation='%TCPPort%:%FQDN%']
%windir%\system32\inetsrv\appcmd.exe set app %WebSite%/%Vdir% /enabledProtocols:net.tcp
)

IF %DEPLOYMENTMODE% EQU IM (
%windir%\system32\inetsrv\appcmd.exe set site %WebSite% /+bindings.[protocol='net.tcp',bindingInformation='%TCPPort%:%FQDN%']
%windir%\system32\inetsrv\appcmd.exe set app %WebSite%/%Vdir% /enabledProtocols:net.tcp
)

%windir%\system32\inetsrv\appcmd.exe set config /section:sites /siteDefaults.logFile.directory:%WEBLOG%
%windir%\system32\inetsrv\appcmd.exe set app %WebSite%/%Vdir% /serviceAutoStartEnabled:true

