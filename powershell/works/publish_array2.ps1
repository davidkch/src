$source = "c:\Program Files (x86)"
$dest = "c:\temp" 

$LogFile ="c:\logs\publish.log"
 Write-Output $null | Out-File -Encoding utf8 $LogFile
$publishFiles= @(
    ("$source\Wix Toolset v3.6\bin", "$dest\Wix\bin", "*.exe"),
    ("$source\Wix Toolset v3.6\bin", "$dest\Wix\dll", "*.dll", "/XD SDK /XF WixUtilExtension.dll"),
    ("$source\Canon", "$dest\canon\exe", "*.exe"),
    ("$source\Canon", "$dest\canon\dll")
)



for($rowcount = 0; $rowcount -lt $publishFiles.Count; $rowcount++)
{
    $command = $null
   # for ($colcount = 0; $colcount -lt $arrayColumns; $colcount++)
    for ($colcount = 0; $colcount -lt $publishFiles[$rowcount].Length; $colcount++)
    {
        $colcount
        $item = $publishFiles[$rowcount][$colcount]
        $element = $item.ToString().Split()
        #if ($colcount -lt $publishFiles[$rowcount].Length-1)
        if ($colcount -lt 2) # only first 2 argument need to quote around
        {
            $command += "`"$element`" " #need extra space
        }
        else
        {
            $command += "$element " # need extra space
        }

    }
   # Write-Host $command[0] $command[1] $command[2]  
   Write-Host $command
   robocopy $command /E /R:10 /NS /NP  
}


