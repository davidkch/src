<#
.SYNOPSIS
Generic script to create new sharepoint site.
.DESCRIPTION
Generic script to create new sharepoint site.
.EXAMPLE
.\New_SharepointSite.ps1 -DBAccountName $DBAccountName -DatabaseServerName $DBServer -FarmName $FarmName

Version History
v1.0 - balas - Initial Release
#>

Param(
		[string]$WebApplicationURL = $(throw,"Enter the web application URL"),
		[string]$WebApplicationName = $(throw,"Enter the web application name"),
		[string]$ContentDatabase = $(throw,"Enter the content database name"),
		[string]$ApplicationPoolDisplayName = $(throw," Enter the application pool display name"),
		[string]$ApplicationPoolIdentity = $(throw,"Enter the application pool identity"),
		[string]$ApplicationPoolPassword = $(throw,"Enter the application pool password")
	)

$LogFIle="New_SharepointSite.log"	
$AppPoolStatus = $False

Function New_SharepointSite
{

	Write-Output "Adding the powershell Snapins..." | Out-File $LogFIle -Append
	Try
	{
		$ver = $host | select version 
		if ($ver.Version.Major -gt 1)  {$Host.Runspace.ThreadOptions = "ReuseThread"} 
		Add-PsSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue 
		Import-Module WebAdministration -ErrorAction SilentlyContinue 
	}
	catch [System.Exception]
	{
		Write-Output "Error in loading the sharepoint snapins..." | Out-File $LogFIle -Append
		Write-Output $_.Exception.message | Out-File $LogFIle -Append	
	}
	Finally
	{
		Write-Output "Successfully loaded the sharepoint snapins..." | Out-File $LogFIle -Append
	}
	
	Try
	{
		if(get-spwebapplication $WebApplicationURL -ErrorAction SilentlyContinue) 
		{ 
		    Write-Host "Aborting: Web Application $WebApplicationURL Already Exists" -ForegroundColor Red 
		    sleep 5 
		} 
		else 
		{ 
			if(Get-SPServiceApplicationPool $ApplicationPoolDisplayName -ErrorAction SilentlyContinue) 
    		{ 
        		Set-Variable -Name AppPoolStatus -Value "IsSharePoint" -scope "script" 
    		} 
    		else 
    		{ 
        		if((Test-Path IIS:\AppPools\$ApplicationPoolDisplayName).tostring() -eq "True") 
        		{ 
           			Set-Variable -Name AppPoolStatus -Value "IsNotSharePoint" -scope "script" 
        		} 
    		} 
			
			if($AppPoolStatus -eq "IsNotSharePoint") 
		    { 
		        Write-Host "Aborting: Application Pool $ApplicationPoolDisplayName already exists on the server and is not a SharePoint Application Pool" -ForegroundColor Red 
		    } 
		    elseif($AppPoolStatus -eq "IsSharePoint") 
		    { 
		        if($WebApplicationURL.StartsWith("http://")) 
		        { 
		            $HostHeader = $WebApplicationURL.Substring(7) 
		            $HTTPPort = "80" 
		        } 
		        elseif($WebApplicationURL.StartsWith("https://")) 
		        { 
		            $HostHeader = $WebApplicationURL.Substring(8) 
		            $HTTPPort = "443" 
		        } 
				
				Set-Variable -Name AppPool -Value (Get-SPServiceApplicationPool $ApplicationPoolDisplayName) -scope "script" 
         
		        $WebApp = New-SPWebApplication -ApplicationPool $ApplicationPoolDisplayName -Name $WebApplicationName -url $WebApplicationURL -port $HTTPPort -DatabaseName $ContentDatabase -HostHeader $hostHeader 
				$WebApp.update() 
				
				} 
    		else 
    		{ 
         
		        if(get-spmanagedaccount $ApplicationPoolIdentity) 
		        { 
		            Set-Variable -Name AppPoolManagedAccount -Value (Get-SPManagedAccount $ApplicationPoolIdentity | select username) -scope "Script" 
		            Set-Variable -Name AppPool -Value (New-SPServiceApplicationPool -Name $ApplicationPoolDisplayName -Account $ApplicationPoolIdentity) -scope "Script" 
		        } 
		        else 
		        { 
		            $AppPoolCredentials = New-Object System.Management.Automation.PSCredential $ApplicationPoolIdentity, (ConvertTo-SecureString $ApplicationPoolPassword -AsPlainText -Force) 
		            Set-Variable -Name AppPoolManagedAccount -Value (New-SPManagedAccount -Credential $AppPoolCredentials) -scope "Script" 
		             
		            Set-Variable -Name AppPool -Value (New-SPServiceApplicationPool -Name $ApplicationPoolDisplayName -Account (get-spmanagedaccount $ApplicationPoolIdentity)) -scope "Script" 
		             
		        } 
		        if($WebApplicationURL.StartsWith("http://")) 
		        { 
		            $HostHeader = $WebApplicationURL.Substring(7) 
		            $HTTPPort = "80" 
		        } 
		        elseif($WebApplicationURL.StartsWith("https://")) 
		        { 
		            $HostHeader = $WebApplicationURL.Substring(8) 
		            $HTTPPort = "443" 
		        } 
         
	        	$WebApp = New-SPWebApplication -ApplicationPool $AppPool.Name -ApplicationPoolAccount $AppPoolManagedAccount.Username -Name $WebApplicationName -url $WebApplicationURL -port $HTTPPort -DatabaseName $ContentDatabase -HostHeader $hostHeader 

				$WebApp.update() 

			}

			}
	}
	catch [System.Exception]
	{
		Write-Output "Error in creating the sharepoint site..." | Out-File $LogFIle -Append
		Write-Output $_.Exception.message | Out-File $LogFIle -Append	
	}
	Finally
	{
		Write-Output "Successfully created the sharepoint site..." | Out-File $LogFIle -Append
	}
	
}

New_SharepointSite -WebApplicationURL $WebApplicationURL -WebApplicationName $WebApplicationName -ContentDatabase $ContentDatabase -ApplicationPoolDisplayName $ApplicationPoolDisplayName -ApplicationPoolIdentity $ApplicationPoolIdentity -ApplicationPoolPassword $ApplicationPoolPassword