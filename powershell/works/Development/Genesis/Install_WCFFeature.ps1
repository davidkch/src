#######################  
<#  
.SYNOPSIS  
Generic script for the activation of WCF Feature Activation
.DESCRIPTION  
Enabling the feature of WCF Activation
.EXAMPLE  
.\Install_WCFFeature.ps1 
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

$LogFile = "Install_WCFFeature.log"

Function Install_WCFFeature
{
	try
	{
        [System.Console]::WriteLine("Importing ServerManager Module")
        "Importing ServerManager Module" | Out-File $LogFile -Append
		try
		{
			Import-Module Servermanager
		}

		catch
		{
    	    [System.Console]::WriteLine("File Already Imported or it doesnot exists")
            "File Already Imported or it doesnot exists" | Out-File $LogFile -Append
		}
        [System.Console]::WriteLine("--------------------------------------------------------")
        "--------------------------------------------------------" | Out-File $LogFile -Append
		[System.Console]::WriteLine("Installing WCF Activation Feature...")
        "Installing WCF Activation Feature..." | Out-File $LogFile -Append
		Add-WindowsFeature NET-Win-CFAC
		[System.Console]::WriteLine("Completed Installing WCF Activation Feature")
        "Completed Installing WCF Activation Feature" | Out-File $LogFile -Append
        [System.Console]::WriteLine("--------------------------------------------------------")
        "--------------------------------------------------------" | Out-File $LogFile -Append

        [System.Console]::WriteLine("--------------------------------------------------------")
        "--------------------------------------------------------" | Out-File $LogFile -Append
		[System.Console]::WriteLine("Installing Role Services(Web Server > Performance > Dynamic Content Compression)")
        "Installing Role Services(Web Server > Performance > Dynamic Content Compression)" | Out-File $LogFile -Append
		Add-WindowsFeature Web-Dyn-Compression
        [System.Console]::WriteLine("Completed Installing Role Service (Web Server > Performance > Dynamic Content Compression)")
        "Completed Installing Role Service (Web Server > Performance > Dynamic Content Compression)" | Out-File $LogFile -Append
        [System.Console]::WriteLine("--------------------------------------------------------")
        "--------------------------------------------------------" | Out-File $LogFile -Append
	}
	Catch [system.exception]
	{
		write-output $_.Exception.message | Out-File $LogFile -Append
		write-host $_.Exception.message
	}
	Finally
	{
		"Executed Successfully!" | Out-File $LogFile -Append
	}
}

Install_WCFFeature
