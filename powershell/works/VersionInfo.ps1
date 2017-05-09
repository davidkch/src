# one-liner

Get-ChildItem -Filter *.dll -Recurse |
    ForEach-Object {
        try {
            $_ | Add-Member NoteProperty FileVersion ($_.VersionInfo.FileVersion)
            $_ | Add-Member NoteProperty AssemblyVersion (
                [Reflection.Assembly]::LoadFile($_.FullName).GetName().Version
            )
        } catch {}
        $_
    } |
    Select-Object Name,FileVersion,AssemblyVersion
# other one liner
<#
#Here is a pretty one liner:
Get-ChildItem -Filter *.dll -Recurse | Select-Object -ExpandProperty VersionInfo


#In short for PowerShell version 2:
ls -fi *.dll -r | % { $_.versioninfo }


#In short for PowerShell version 3 as suggested by tamasf:
ls *.dll -r | % versioninfo

#>