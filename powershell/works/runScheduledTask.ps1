SCHTASKS /Create /S davidch-pc /U DavidCh-PC\davidch /P "Tiger322!" /RU davidch /RP "Tiger322!" /SC MINUTE /TN NOTE /TR c:\windows\system32\notepad.exe /ST 14:00

SCHTASKS /Create /S davidch-pc /U DavidCh-PC\davidch /P "Tiger322!" /RU SYSTEM /SC MINUTE /TN NOTE /TR c:\windows\system32\notepad.exe /ST 14:00

schtasks /RUN /S davidch-pc /U DavidCh-PC\davidch /P "Tiger322!" /TN NOTE 

schtasks /CREATE /TN 'Enable Remoting' /SC WEEKLY /RL HIGHEST /RU SYSTEM /RP "*" /TR "powershell -noprofile -command Get-Process -Force" /F | Out-String
schtasks /RUN /S davidch-pc /U davidch /P Tiger322! /TN 'Enable Remoting' | Out-String

SCHTASKS /Create /S ABC /U user /P password /RU runasuser /RP runaspassword /SC WEEKLY /TN report /TR notepad.exe


SCHTASKS /Create /S ABC /U domain\user /P password /SC MINUTE
                 /MO 5 /TN logtracker 
                 /TR c:\windows\system32\notepad.exe /ST 18:30
                 /RU runasuser /RP


                 schtasks /DELETE /TN 'Enable Remoting' /F | Out-String


SCHTASKS /Create /S davidch-pc /U DavidCh-PC\davidch /P "Tiger322!" /RU SYSTEM /SC MINUTE /TN "NOTE" /TR c:\windows\system32\notepad.exe
schtasks /RUN /S davidch-pc /U DavidCh-PC\davidch /P "Tiger322!" /TN "NOTE"  
SCHTASKS /Delete /S davidch-pc /U DavidCh-PC\davidch /P "Tiger322!" /TN "NOTE" /F


SCHTASKS /Create /S davidch-pc /U DavidCh-PC\davidch /P "Tiger322!" /RU SYSTEM /SC WEEKLY /F /TN "delete_Old_Builds" /TR "powershell -noprofile -file c:\temp1\delete-oldbuilds.ps1 c:\temp1" 
schtasks /RUN /S davidch-pc /U DavidCh-PC\davidch /P "Tiger322!" /TN "delete_Old_Builds" 
SCHTASKS /Delete /S davidch-pc /U DavidCh-PC\davidch /P "Tiger322!" /TN "delete_Old_Builds" /F


SCHTASKS /Create /S davidch-pc /U DavidCh-PC\davidch /P "Tiger322!" /RU SYSTEM /SC MINUTE /TN "CAL" /TR c:\windows\system32\calc.exe
schtasks /RUN /S davidch-pc /U DavidCh-PC\davidch /P "Tiger322!" /TN "CAL"  
SCHTASKS /Delete /S davidch-pc /U DavidCh-PC\davidch /P "Tiger322!" /TN "CAL" /F


copy-item C:\Powershell\works\Delete-OldBuilds.ps1 -destination \\davidch-pc\c$\temp1 

$computer = "davidch-pc"
$credential = Get-Credential
Invoke-Command -ComputerName "davidch-pc" -Credential Get-Credential -ScriptBlock {copy-item \\yongch-h2\C$\Powershell\works\Delete-OldBuilds.ps1 -destination C:\temp1} 

Invoke-Command -Computername davidch-pc -FilePath C:\powershell\works\Delete-OldBuilds.ps1 -ArgumentList temp1 -Cred davidch
robocopy C:\Powershell\works \\davidch-pc\c$\temp1 delete-oldbuilds.ps1 
