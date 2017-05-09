param(
$Drive=(throw "Pass DRIVE LETTER")
)

$fileDrive = $Drive + ":"
Invoke-Expression "subst $fileDrive C:\Temp"

New-Item "$fileDrive\Test1.txt" -ItemType "File"
New-Item "$fileDrive\TestDir" -ItemType "Directory"
New-Item "$fileDrive\TestDir\Test2.txt" -ItemType "File"
New-Item "$fileDrive\Test3.txt" -ItemType "File"
New-Item "$fileDrive\Test4.txt" -ItemType "File"

$fileDrive = $fileDrive + "\"

$ContentsList = Get-ChildItem $fileDrive -Recurse -Name -File

foreach($PathFile in $ContentsList)
{
 #Invoke-Expression -Command "attrib R `"$fileDrive$PathFile`""
 write-host "attrib -R $fileDrive$PathFile"
 #Invoke-Expression -Command "attrib -R `"$fileDrive$PathFile`""
}

Remove-Item "$fileDrive*" -Recurse

$fileDrive = $Drive + ":"
Invoke-Expression "subst $fileDrive /D"

