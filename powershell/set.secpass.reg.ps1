
<#
    .SYNOPSIS
    
    Invoke-Command -ComputerName (Get-Content .\Servers.txt) -FilePath .\set.secpass.reg.ps1 -ArgumentList MPSITBldTeam@2k12

    $computers = (Get-Content .\Servers.txt)

    Invoke-Command -ComputerName $computers -FilePath .\set.secpass.reg.ps1 -ArgumentList MPSITBldTeam@2k12
#>

param([string]$password)

$secpass = convertto-securestring $password -asplaintext -force
$pwentry = convertfrom-securestring $secpass

Set-Service WinRM -startuptype Automatic
Start-Service WinRM
WinRM quickconfig -quiet -force

sleep 5

# schtasks /CREATE /TN 'Enable Remoting' /SC WEEKLY /RL HIGHEST /RU redmond\bgcoebld /RP $password /TR "powershell -noprofile -command Enable-PsRemoting -Force" /F 
# schtasks /RUN /S $computers /U redmond\bgcoebld /P $password /I /TN 'Enable Remoting'

schtasks /CREATE /TN 'Enable Remoting' /SC WEEKLY /RL HIGHEST /RU "NT AUTHORITY\SYSTEM" /TR "powershell -noprofile -command Enable-PsRemoting -Force" /F 
schtasks /RUN /I /TN 'Enable Remoting'

sleep 5

schtasks /DELETE /TN 'Enable Remoting' /F

New-Item HKCU:\secpass -Force

if (!((Get-ItemProperty hkcu:\secpass).name))
{
    New-ItemProperty HKCU:\secpass -name pw -propertytype String -value $pwentry
}
else
{
  Set-ItemProperty -path "HKCU:\secpass" -name "pw" -value $pwentry
}

