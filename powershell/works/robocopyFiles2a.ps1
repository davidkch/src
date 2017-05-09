$source = "c:\Program Files (x86)"
$dest = "c:\temp" 
$LogFile ="c:\logs\publish.log"

# create hashtable as key=source and value=destinations (use comma "," for adding extra robocopy option to the value for this particualr file(s))
# if you using powershell version lower than 3.0 remove [ordered] from hashtable creation
$Publishfiles = 
[ordered]@{
    "$source\Wix Toolset v3.6\bin" = "$dest\Wix\bin, *.exe";
    "$source\Canon" = "$dest\canon, *.*";
    "$source\Toshiba\pcdiag" = "$dest\toshiba\pcdiag, *.dll, /XD zh-CN";
    "c:\Program Files\Oracle" = "$dest\Oracle, *.jar *.txt, /XD ""JavaFX 2.1 runtime"" /XF javafx-mx.jar" #last line don't need ";"
 }

 Write-Output $null | Out-File -Encoding utf8 $LogFile

 # enumerate each source and destinations in hashtable
 foreach ($item in $Publishfiles.GetEnumerator() )
 {
    # seperate destination folder and file(s). Also find out if it has extra option for robocopy
    $DestinationAndFiles = @($item.Value -split ",")
    
    if ($DestinationAndFiles.Count -eq 3) #this one has extra robocopy options
    {          

        robocopy $item.Key $DestinationAndFiles[0].ToString().Split() $DestinationAndFiles[1].ToString().Split() $DestinationAndFiles[2].ToString().Split() /E /R:10 /NS /NP /LOG+:$LogFile
    }
    else #this one is just source, dest and file(s)
    {
        robocopy $item.Key $DestinationAndFiles[0].ToString().Split() $DestinationAndFiles[1].ToString().Split() /E /R:10 /NS /NP /LOG+:$LogFile
    }
    
    # delete temporary array
    $DestinationAndFiles = $null
 }