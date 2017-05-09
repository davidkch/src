
set-executionpolicy -scope Currentuser unrestricted


$CodeSignFolder = "D:\T\PKITA\Sprints-BldTest\20140924.093646\Sources\src\CodeSignFiles\PKITA.AdminUI"
$SubmissionScript = "D:\T\PKITA\Sprints-BldTest\20140924.093646\Sources\Tools\CodeSignSubmissionScript.ps1"
$reg=Get-ItemProperty hkcu:\secpass
$pass = convertto-securestring $reg.pw
$cred = new-object System.Management.Automation.PSCredential("redmond\bgcoebld", $pass)

Invoke-Command -ComputerName localhost -Credential $cred -Authentication Credssp -FilePath $SubmissionScript -ArgumentList @("$CodeSignFolder",'*.exe', '', '', '2', 'codesign.gtm.microsoft.com', '9556', 'https://codesign.gtm.microsoft.com')

