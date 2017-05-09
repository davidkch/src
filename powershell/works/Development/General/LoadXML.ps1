#######################  
<#  
.SYNOPSIS  
 Generic script to load an XML file from the directory the script is being executed into a Powershell XML object.
.DESCRIPTION  
 Generic script to load an XML file from the directory the script is being executed into a Powershell XML object.
.EXAMPLE  
.\LoadXML.ps1 -ConfigFileName MyFileName.xml
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
	[string]$ConfigFileName = $(throw "Pass the ConfigFileName")
)

Function LoadXML
{
	try
	{
		$curentDir = Get-Location

		if($ConfigFileName.Contains("\"))
		{
			 $configurationFileNameFull = $ConfigFileName
		}
		else
		{
			 $configurationFileNameFull = "$curentDir\$ConfigFileName"
		}
 
		if (![System.IO.File]::Exists($configurationFileNameFull))  
		{  
			$errorMessage = "Config file does not exists. " + $configurationFileNameFull
			throw $errorMessage
		} 
 
		[System.Xml.XmlDocument] $xd = new-object System.Xml.XmlDocument

		$xd.load($configurationFileNameFull)
	}
	Catch [system.exception]
	{
		write-host $_.exception.message
	}
	Finally
	{
		"Executed Successfully"
	}
}

LoadXML -ConfigFileName $ConfigFileName
