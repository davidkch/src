
$computer=$args[0]
     
if (($computer -eq "/?") -or ($computer -eq "-h") -or ($computer -lt 1))
{
   write-host "usage: checkInstalledPrograms.ps1 <computer name>
}  
else  
{ 
   $credential = Get-Credential
}

   Invoke-Command -Computername $computer -Credential $credential -ScriptBlock { "","\WOW6432Node"|%{gci "HKLM:\SOFTWARE$_\Microsoft\Windows\CurrentVersion\Uninstall"}|gp|?{$_.DisplayName.Length -gt 0}|sort -Prop DisplayName -Uniq|ft -Prop DisplayName,Publisher,DisplayVersion -AutoSize }

