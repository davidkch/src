#######################  
<#  
.SYNOPSIS  
 Generic script to set both windows authentication and anonymous authentication for the specified virtual directory.
.DESCRIPTION  
 Generic script to set both windows authentication and anonymous authentication for the specified virtual directory.
.EXAMPLE  
.\SetIISAuthentication.ps1 -Website MyWebsiteName -VirDir MyVirDirName -EnableWinAuth True -AnonymousAuth False
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>  

param(
    [string[]]$EnableWinAuth = $(throw "Pass the EnableWinAuth True / False")
   ,[string[]]$AnonymousAuth = $(throw "Pass the AnonymousAuth True / False")
)

$systemroot = $env:SystemRoot

Function SetIISAuthentication
{
	# If windows auth is true, anonymous auth must be false, and vice versa
	$APPCMD="$systemroot\system32\inetsrv\APPCMD"
	& $APPCMD Set Config "$WebSite/$Vdir" /section:windowsAuthentication /enabled:$EnableWinAuth /commit:apphost
	& $APPCMD Set Config "$WebSite/$Vdir" /section:AnonymousAuthentication /enabled:$AnonymousAuth /commit:apphost
}

SetIISAuthentication -EnableWinAuth $EnableWinAuth -AnonymousAuth $AnonymousAuth