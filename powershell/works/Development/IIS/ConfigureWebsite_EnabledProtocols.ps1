#######################  
<#  
.SYNOPSIS  
 Generic script to set enabled protocols property of specified website virtual directory
.DESCRIPTION  
 Generic script to set enabled protocols property of specified website virtual directory
.EXAMPLE  
.\ConfigureWebsite_EnabledProtocols.ps1 -Website MyWebsiteName -Vdir MyVirDirName -ProtocolList "http,net.pipe,net.tcp" 
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
        [string]$Website = $(throw "Please pass website name."),
        [string]$Vdir = $(throw "Please pass virtual directory name."),
        [string]$ProtocolList = $(throw "Please pass the protocols you wish to enable for this binding.  Seperated by ','.")
)

$LogFile = "ConfigureWebsite_EnabledProtocols.log"
$WinDir = $env:Windir

Function ConfigureWebsite_EnabledProtocols
{
 try
 {
  #Setting "EnabledProtocols" field for virtual directory
  write-output "Assigning enabled protocols..." | Out-File $LogFile
  & $WinDir\system32\inetsrv\appcmd.exe set app "$WebSite/$Vdir" /enabledProtocols:"$ProtocolList" | Out-File $LogFile -Append
 }
 Catch [system.exception]
 {
  write-output $_.exception.message | Out-File $LogFile -Append
  write-host $_.exception.message
 }
 Finally
 {
  "Completed Successfully!" | Out-File $LogFile -Append
 }
}

ConfigureWebsite_EnabledProtocols -Website $Website -Vdir $Vdir -ProtocolList $ProtocolList