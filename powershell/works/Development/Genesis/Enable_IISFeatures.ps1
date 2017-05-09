#######################  
<#  
.SYNOPSIS  
Generic script to enable IIS Features
.DESCRIPTION  
Registring .Net with IIS,Register .Net 4.0 WCF and WF components, Adding user to IIS_IUSERS group & Enabling IIS features
.EXAMPLE  
.\Enable_IISFeatures.ps1 -IISFeatures "IIS-Security;IIS-BasicAuthentication;IIS-ClientCertificateMappingAuthentication" -Userdomain "redmond" -Username "bgcoebld" 

Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
         [String]$IISFeatures=$(throw "Pass IIS feature name"),
         [String]$Userdomain=$(throw "Pass user domain"),
         [String]$Username=$(throw "Pass user name for adding it in IIS_IUSRS localgroup")
)

$LogFile = "Enable_IISFeatures.log"

Function Enable_IISFeatures
{
	try
	{
	     [System.Console]::WriteLine("IISFeatures: $IISFeatures")
         [System.Console]::WriteLine("Userdomain: $Userdomain")
         [System.Console]::WriteLine("Username: $Username")
         "IISFeatures: $IISFeatures" | Out-File $LogFile -Append
         "Userdomain: $Userdomain" | Out-File $LogFile -Append
         "Username: $Username" | Out-File $LogFile -Append
		 [System.Console]::WriteLine("--------------------------------------------------------")
        "--------------------------------------------------------" | Out-File $LogFile -Append
		[System.Console]::WriteLine("Registering .Net with IIS..")
        "Registering .Net with IIS.." | Out-File $LogFile -Append
		C:\Windows\Microsoft.NET\Framework64\v4.0.30319\aspnet_regiis.exe -i | Out-File $LogFile -Append
		[System.Console]::WriteLine("Registering .Net with IIS --Done")
        "Registering .Net with IIS --Done" | Out-File $LogFile -Append
        [System.Console]::WriteLine("--------------------------------------------------------")
        "--------------------------------------------------------" | Out-File $LogFile -Append

        [System.Console]::WriteLine("--------------------------------------------------------")
        "--------------------------------------------------------" | Out-File $LogFile -Append
		[System.Console]::WriteLine("Register .Net 4.0 WCF and WF Components")
        "Register .Net 4.0 WCF and WF Components" | Out-File $LogFile -Append
		C:\Windows\Microsoft.NET\Framework64\v4.0.30319\ServiceModelReg.exe -ia |Out-File $LogFile -Append
		[System.Console]::WriteLine("Register .Net 4.0 WCF and WF Components --Done")
        "Register .Net 4.0 WCF and WF Components --Done" | Out-File $LogFile -Append
        [System.Console]::WriteLine("--------------------------------------------------------")
        "--------------------------------------------------------" | Out-File $LogFile -Append

        [System.Console]::WriteLine("--------------------------------------------------------")
        "--------------------------------------------------------" | Out-File $LogFile -Append
		[System.Console]::WriteLine("Adding User '$Username' to IIS_IUSRS")
        "Adding User '$Username' to IIS_IUSRS" | Out-File $LogFile -Append
        Add-LocalUser -Userdomain $Userdomain -Username $Username
		[System.Console]::WriteLine("Done Adding User..")
        "Done Adding User.." | Out-File $LogFile -Append
        [System.Console]::WriteLine("--------------------------------------------------------")
        "--------------------------------------------------------" | Out-File $LogFile -Append
        
        [System.Console]::WriteLine("--------------------------------------------------------")
        "--------------------------------------------------------" | Out-File $LogFile -Append
		[System.Console]::WriteLine("Enabling IIS features '$IISFeatures'")
        "Enabling IIS features '$IISFeatures'" | Out-File $LogFile -Append
        $GetIISFeature=$IISFeatures.Split(";")
        foreach($y in $GetIISFeature)
        {
           & DISM.exe /online /enable-feature /featurename:$y | Out-File $LogFile -Append
        }
		[System.Console]::WriteLine("Done enalbing IIS features..")
        "Done enalbing IIS features.." | Out-File $LogFile -Append
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

function Add-LocalUser{
     Param(
        $computer=$env:computername,
        $group='IIS_IUSRS'
    )
        ([ADSI]"WinNT://$computer/$Group,group").psbase.Invoke("Add",([ADSI]"WinNT://$Userdomain/$Username").path)
}


Enable_IISFeatures -IISFeatures $IISFeatures -Userdomain $Userdomain -Username $Username
