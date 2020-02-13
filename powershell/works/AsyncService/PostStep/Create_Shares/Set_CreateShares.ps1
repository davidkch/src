#######################  
<#  
.SYNOPSIS  
 Creates a file share
.DESCRIPTION  
 Creates a file share
.EXAMPLE  
.\Set_CreateShares.ps1  -ShareName "MyShare" -SharePath "C:\TestShare\Blah" -ServiceAccount TestAccountName -AccessLevel Full -Remark "My Description"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    $ShareName = (throw "Please pass share name."),
    $SharePath = (throw "Please pass share folder path."),
    $ServiceAccount = (throw "Please pass account alias to associate share permissions."),
    $AccessLevel = (throw "Please pass AccessLevel."),
	$Remark = (throw "Please pass remark.  Description of share.")
)

Function Set_CreateShares
{
   try
   {
        Write-Output "Creating specified share..."
	Write-Output "ShareName:  $ShareName"
        #$output = .\CreateFileShare.ps1 -ShareName $ShareName -SharePath $SharePath -ServiceAccount $ServiceAccount -AccessLevel $AccessLevel -Remark $Remark
        $output = Invoke-Expression ("net share $ShareName=$SharePath `"/GRANT:$ServiceAccount,$AccessLevel`" /UNLIMITED /REMARK:`"$Remark`"")
	Write-Output $output
    }
    Catch [system.exception]
    {
        write-output "ERROR: " $_.exception.message
    }
    Finally
    {
      Write-Output "Set_CreateShares.ps1 Executed Successfully"
    }
}

Set_CreateShares -ShareName $ShareName -SharePath $SharePath -ServiceAccount $ServiceAccount -AccessLevel $AccessLevel -Remark $Remark