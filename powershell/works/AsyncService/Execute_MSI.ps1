<#  
.SYNOPSIS  
 Installs specified MSI with parameters
.DESCRIPTION  
 Installs specified MSI with parameters
.EXAMPLE  
.\Execute_MSI.ps1 -InstallType "Install" -FilePath "C:\MyFolder\MyMSI.msi" -Params @{ "Param1"="Value1"; "Param2"="Value2" }
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
    [String]$InstallType = $(throw "Please pass install type."),
    [String]$FilePath = $(throw "Please pass FilePath."),
    [Hashtable]$Params = $(throw "Please pass the params.")
)

######PROPERTIES######
<#EMPTY#>


Function Execute_MSI
{
	try
    {
        foreach($Name in $Params.Keys)
        {
	    $Value=$Params["$Name"]
            $SortedParams += "$Name`=`"$Value`" "
        }

        switch($InstallType.ToLower())
        {
            "install"
            { 
                Write-Output "Installing MSI..." 
                Write-Output "COMMAND: "
		        Write-Output "Start-Process `"msiexec`" -ArgumentList `"/i $FilePath $SortedParams /qn /l* Install.log`""
		        $Result = (Start-Process "msiexec" -ArgumentList "/i $FilePath $SortedParams /qn /l* Install.log" -Wait -PassThru).ExitCode
		        ValidateInstallation -Result $Result
            }
            
            "uninstall"
            { 
                Write-Output "Uninstalling MSI..." 
		        Write-Output "COMMAND: "
		        Write-Output "Start-Process `"msiexec`" -ArgumentList `"/x $FilePath $SortedParams /qn /l* Uninstall.log`""
                $Result = (Start-Process "msiexec" -ArgumentList "/x $FilePath $SortedParams /qn /l* Uninstall.log" -Wait -PassThru).ExitCode
		        ValidateInstallation -Result $Result
            }

            default:
            { Write-Output "ERROR:  Incorrect install type specified.  Exiting..."; exit -1 }
        }
    }
    Catch [system.exception]
    {
       Write-Output "ERROR: "
       Write-Output $Error
       $Error.Clear()
    }
    Finally
    {
       Write-Output "Execute_MSI.ps1 Executed Successfully"
    }
}

Function ValidateInstallation
{
param(
   $Result = $(throw "Please pass the result.")
)
    if($Result -ne 0)
    {
       Write-Output "MSI failed to install.  Please check logfile for errors."
       throw "MSI exited with code $Result"
    }
    else
    {
	Write-Host "MSI INSTALLATION:  SUCCEEDED" -ForegroundColor "Green"
	Write-Output "MSI INSTALLATION:  SUCCEEDED"
    }
}

Execute_MSI