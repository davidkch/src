
param(
	[Parameter(Mandatory=$true)]
	[string]$pathToVerify,
	[string]$signToolPath
) 

if  ($signToolPath -eq "" ){
	$signToolPath = "C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Bin\signtool.exe"}

if (!(Test-Path  $signToolPath -pathType Leaf)){
	Write-Host $signToolPath doesnt exist! -ForegroundColor Red
	Exit -1
}

$files = gci $pathToVerify -Recurse -Include *.exe,*.dll
Write-Host ""
Write-Host ""
Write-Host "Total file(s) found:" $files.Count
Write-Host ""

$signedFiles = 0
$unsignedFiles = 0

foreach ($file in $files) {

	$args = "verify /pa "  + $file.FullName 
	$p = Start-Process $signToolPath -ArgumentList $args -wait -WindowStyle Hidden -PassThru

	if ( $p.ExitCode -ne 0){
   		Write-Host $file.FullName is not signed -ForegroundColor Red
		$unsignedFiles = $unsignedFiles + 1
		}
		else{
			Write-Host $file.FullName ... is signed -ForegroundColor Green
			$signedFiles = $signedFiles + 1
		}		
}

Write-Host ""
Write-Host ""
Write-Host "Scanning completed."
Write-Host ""
Write-Host "Total signed files:" $signedFiles -ForegroundColor Green
Write-Host ""
Write-Host "Total unsigned files:" $unsignedFiles -ForegroundColor Red
Write-Host ""