$computer = "bgcoebld-hbi-4"
$credential = Get-Credential

Invoke-Command -ComputerName $computer -Credential $credential -ScriptBlock { "","\WOW6432Node"|%{gci "HKLM:\SOFTWARE$_\Microsoft\Windows\CurrentVersion\Uninstall"}|gp|?{$_.DisplayName.Length -gt 0}|sort -Prop DisplayName -Uniq|ft -Prop DisplayName,Publisher,DisplayVersion -AutoSize }
