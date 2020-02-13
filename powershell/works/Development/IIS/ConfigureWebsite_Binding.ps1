#######################  
<#  
.SYNOPSIS  
 Generic script to create/remove bindings for a specified website
.DESCRIPTION  
 Generic script to create/remove bindings for a specified website
.EXAMPLE  
.\ConfigureWebsite_Binding.ps1 Add My_WebsiteName "80" "*" "https"
.\ConfigureWebsite_Binding.ps1 Add My_WebsiteName "80,443" "*,MyFQDN.microsoft.com" "https,net.pipe"

.\ConfigureWebsite_Binding.ps1 Remove My_WebsiteName "80" "*" "https"
.\ConfigureWebsite_Binding.ps1 Remove My_WebsiteName "80,443" "*,MyFQDN.microsoft.com" "https,net.pipe"

Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
        [string]$Action = $(throw "Please pass name of action you wish to take."),
        [string]$Website = $(throw "Please pass website name."),
        [string]$Port = $(throw "Please pass TCP port number."),
        [string]$FQDNList = $(throw "Please pass IP address (https) or fully qualified domain name (net.tcp)."),
        [string]$ProtocolList = $(throw "Please pass the protocols you wish to enable for this binding.  Seperated by ','.")
)

$LogFile = "ConfigureWebsite_Binding.log"
#$WinDir = $env:Windir

Function ConfigureWebsite_Binding
{
 try
 {
  $PortNumber = $Port.Split(',')
  $Protocol = $ProtocolList.Split(',')
  $FQDN = $FQDNList.Split(',')
  $i=0

  write-output "Port: $Port" | Out-File $LogFile
  write-output "ProtocolList: $ProtocolList" | Out-File $LogFile -Append
  write-output "FQDNList: $FQDNList" | Out-File $LogFile -Append

  if($PortNumber.Count,$FQDNList.Count -eq $Protocol.Count)
  {
   switch("$Action")
   {
    "Add"
    {
     while($i -lt $PortNumber.Count)
     {
      [string]$BindingInfo = $PortNumber[$i] + ":" + $FQDN[$i]
      write-output "BindingInfo: " $BindingInfo | Out-File $LogFile -Append

      if(($Protocol[$i] -eq "http") -or ($Protocol[$i] -eq "https"))
      {
        "Adding $($Protocol[$i]) binding..." | Out-File $LogFile -Append
        New-WebBinding -Name "$Website" -protocol $Protocol[$i] -Port $PortNumber[$i] -IPAddress $FQDN[$i] | Out-File $LogFile -Append
      }
      elseif(($Protocol[$i] -eq "net.tcp") -or ($Protocol[$i] -eq "net.pipe"))
      {
        "Adding $($Protocol[$i]) binding..." | Out-File $LogFile -Append
        New-ItemProperty IIS`:\Sites\"$Website" –name bindings –value @{protocol=$Protocol[$i];bindingInformation="$BindingInfo"} | Out-File $LogFile -Append
      }
      else
      {
        throw "ERROR:  Protocol entered not supported by this script.  Supported protocols:  http, https, net.tcp, net.pipe"
      }

      write-host "Binding created successfully!" | Out-File $LogFile -Append
      $i++
     }
    }
    "Remove"
    {
     while($i -lt $PortNumber.Count)
     {
      [string]$BindingInfo = $PortNumber[$i] + ":" + $FQDN[$i]
      write-output "BindingInfo: " $BindingInfo | Out-File $LogFile -Append
      write-output "Protocol: " $Protocol[$i] | Out-File $LogFile -Append

      if(($Protocol[$i] -eq "http") -or ($Protocol[$i] -eq "https"))
      {
        write-output "Removing $($Protocol[$i]) binding..." | Out-File $LogFile -Append
        Remove-WebBinding -Name "$Website" -protocol $Protocol[$i] -Port $PortNumber[$i] -IPAddress $FQDN[$i] | Out-File $LogFile -Append
      }
      elseif(($Protocol[$i] -eq "net.tcp") -or ($Protocol[$i] -eq "net.pipe"))
      {
        write-output "Removing $($Protocol[$i]) binding..." | Out-File $LogFile -Append
        Remove-ItemProperty IIS`:\Sites\"$Website" –name bindings -AtElement @{protocol=$Protocol[$i];bindingInformation="$BindingInfo"} | Out-File $LogFile -Append
      }
      else
      {
        throw "ERROR:  Protocol entered not supported by this script.  Supported protocols:  http, https, net.tcp, net.pipe"
      }

      write-host "Binding removed successfully!" | Out-File $LogFile -Append
      $i++
     }
    }
   }
  }
  else
  {
   write-output "Ports/FQDN/Protocols count does not match.  Please enter a matching number of protocols and port numbers. Ex:  -port `"80,443`" -ProtocolList `"http,net.tcp`"" | Out-File $LogFile -Append
   write-host "Ports/FQDN/Protocols count does not match.  Please enter a matching number of protocols and port numbers. Ex:  -port `"80,443`" -ProtocolList `"http,net.tcp`""
  }
 }
 Catch [exception]
 {
   write-output $_.exception.message | Out-File $LogFile -Append
   write-host $_.exception.message
 }
 Finally
 {
  "Completed Successfully!" | Out-File $LogFile -Append
 }
}
 
ConfigureWebsite_Binding -Action $Action -Website $Website -Vdir $Vdir -Port $Port -AppPool $AppPool -FQDNList $FQDNList -ProtocolList $ProtocolList