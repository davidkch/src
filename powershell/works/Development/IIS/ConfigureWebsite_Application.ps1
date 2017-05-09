#######################  
<#  
.SYNOPSIS  
 Generic script to create a empty website, add an application to the website, create an application pool, and assign the application pool to the application and website.
.DESCRIPTION  
 Generic script to create a empty website, add an application to the website, create an application pool, and assign the application pool to the application and website.
.EXAMPLE  
.\SetIISAuthentication.ps1 -Website MyWebsiteName -VirDir MyVirDirName -AppPoolName MyAppPoolName -UserName Bill -UserPassword MyComplexPass -Port 80 -PhysicalPath C:\inetpub\wwwroot\MyNewVirDir
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
    [string[]]$Website = $(throw "Pass the Website name")
   ,[string[]]$VirDir = $(throw "Pass the Virtual Directory name")
   ,[string[]]$AppPoolName = $(throw "Pass the AppPoolName")
   ,[string[]]$UserName = $(throw "Pass the UserName")
   ,[string[]]$UserPassword = $(throw "Pass the UserPassword")
   ,[string[]]$Port = $(throw "Pass the Port")
   ,[string[]]$PhysicalPath = $(throw "Pass the PhysicalPath")
)

$LogFile = "ConfigureWebsite_Application.log"
$systemroot = $env:SystemRoot

Function ConfigureWebsite_Application
{
	try
	{
		$APPCMD="$systemroot\system32\inetsrv\APPCMD"

		#Creates a new app pool
		& $APPCMD set config  -section:system.applicationHost/applicationPools /+"[name='$AppPoolName']" /commit:apphost 
		
		#Configures an app pool
		& $APPCMD set config /section:applicationPools /[Name='$AppPoolName'].processModel.identityType:SpecificUser /[Name='$AppPoolName '].processModel.userName:$UserName /[name='$AppPoolName '].processModel.password:$UserPassword
		
		#Creates a new website
		& $APPCMD add site /name:"$Website" /physicalPath:"$PhysicalPath" /bindings:"http/*:$Port\:"

		#Sets an existing application pool to the website
		& $APPCMD set app "$Website/" /applicationPool:$AppPoolName

		#Adds applicationn to existing website
		& $APPCMD add app /site.name:"$Website" /path:/$VirDir /physicalPath:$PhysicalPath

		#Sets an app pool to the new application
		& $APPCMD set app /app.name:"$Website/$VirDir" /applicationPool:$AppPoolName
	}
	Catch [system.exception]
	{
	    write-output $_.exception.message | Out-File $LogFile -Append
		write-host $_.exception.message
	}
	Finally
	{
		"Executed Successfully"
	}
}

ConfigureWebsite_Application -Website $Website -VirDir $VirDir -AppPoolName $AppPoolName -UserName $UserName -UserPassword $UserPassword -Port $Port -PhysicalPath $PhysicalPath

