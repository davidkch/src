$source = "c:\Program Files (x86)"
$dest = "c:\temp" 
$LogFile ="c:\logs\publish.log"
#$excludefile = ".\excludefilelist.txt"

# create fresh logfile
# Write-Output $null > $LogFile
 Write-Output $null | Out-File -Encoding utf8 $LogFile

# create hashtable as key=source and value=destinations (use comma "," for multiple destination)
# if you using powershell version lower than 3.0 remove [ordered] from hashtable creation
$Publishfiles = 
[ordered]@{
    "$source\Wix Toolset v3.6\bin\*.bar" = "$dest\Wix\bin, $dest\exe";
    "$source\Canon\*" = "$dest\canon"

 }

 # enumerate each source and destinations in hashtable
 foreach ($item in $Publishfiles.GetEnumerator() )
 {
    # create an array with $item.Value so we can find if there are multiple destination locations
    $DestArray = @($item.Value -split ",")
    #$DestArray.Count
    
    if ($DestArray.Count -gt 1)
    {
        # array count is greater than 1 so there are multiple destinations
        foreach ($element in $DestArray)
        {    
            # write source and destination to console
            Write-Host "copy " $item.Key $element.ToString().Trim() 

            # write header in the logfile
            -join ("Source: ", $item.Key, "  Destination: ", $element.ToString().Trim()) | Out-File -Encoding utf8 -Append $LogFile

            # copy files - key is the source location and element is the destination location
            # Invoke-Expression -command 'xcopy $item.Key $element.ToString().Trim() /y /e /v /i /exclude:excludefilelist.txt' >> $LogFile
            Invoke-Expression -command 'xcopy $item.Key $element.ToString().Trim() /y /e /v /f /r /i' | Out-File -Encoding utf8 -Append $LogFile
 #       if($?)
        $LASTEXITCODE
        if ($LASTEXITCODE)
        {
            throw "error occured duint copy files"
        }

        }
    }
    else
    {
        # write source and destination to console
        Write-Host "copy " $item.Key $item.Value 
        
        # write header in the logfile
        -join ("Source: ", $item.Key, "  Destination: ", $item.Value) | Out-File -Encoding utf8 -Append $LogFile

        # copy files - key is the source location and value is the destination location
        # Invoke-Expression -command 'xcopy $item.Key $item.Value /y /e /v /i /exclude:excludefilelist.txt' >> $LogFile
       Invoke-Expression -command 'xcopy $item.Key $item.Value /y /e /v /f /r /i' | Out-File -Encoding utf8 -Append $LogFile
       #Write-Error
       if($?)
       {
        throw ("error occured")
       }

       #Write-Output "errorlevel" $errorlevel
    }

    $logcontent = Get-Content $LogFile | Out-String
    $IsSuccess = $logcontent.Contains("0 File(s) copied")
    #$IsSuccess = $logcontent -match "0 File(s) copied"
    If($isSuccess)
    {
        throw ("no source file(s)")
    } 
    
    # delete temporary array
    $DestArray = $null
 }