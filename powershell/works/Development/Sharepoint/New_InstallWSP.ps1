<#
.SYNOPSIS
Generic script to Install WSP solution into the sharepoint site.
.
.DESCRIPTION
Generic script to Install WSP solution into the sharepoint site.

Version History
v1.0 - v-swpap - Initial Release

.EXAMPLE  
.\New_InstallWSP.ps1 -solutionGUID "ae13fe48-2344-49b0-9847-89c4aa632552" -WebApplicationURL "http://bgcoebld-tk-08:12217/" -WSPPath "D:\test\MS.IT.Fulfillment.Common.wsp"
#>

	Param(
		[string]$solutionGUID = $(throw,"Enter the Solution GUID for sharepoint application"),
		[string]$WebApplicationURL = $(throw,"Enter the web application URL"),
		[string]$WSPPath = $(throw,"Enter path of the .wsp file")
	     )

$LogFile="New_InstallWSP.log"	

Function New_InstallWSP
{	
	
  Try
	{
		[System.Console]::WriteLine("solutionGUID: $solutionGUID")
        "solutionGUID: $solutionGUID" | Out-File $LogFile -Append
        [System.Console]::WriteLine("WebApplicationURL: $WebApplicationURL")
        "WebApplicationURL: $WebApplicationURL" | Out-File $LogFile -Append
        [System.Console]::WriteLine("WSPPath: $WSPPath")
        "WSPPath: $WSPPath" | Out-File $LogFile -Append
		$solutionFile = Get-ChildItem "$WSPPath"
		[System.Console]::WriteLine("solutionFile: $solutionFile")
        "solutionFile: $solutionFile" | Out-File $LogFile -Append
		$solutionFileName = $solutionFile.Name
		$solutionFilePath = $solutionFile.FullName
        [System.Console]::WriteLine("solutionFilePath: $solutionFilePath")
        "solutionFilePath: $solutionFilePath" | Out-File $LogFile -Append
		#
		# check And Update if exists
		#

		$deploystatus = (Get-SPSolution | where-object {$_.Name -eq $solutionFileName})

		if($deploystatus -ne $null)
		{
             [System.Console]::WriteLine("-----------------------------------------------------")
             "-----------------------------------------------------" | Out-File $LogFile -Append
		     [System.Console]::WriteLine("Updating solution package")
             "Updating solution package" | Out-File $LogFIle -Append
             [System.Console]::WriteLine("-----------------------------------------------------")
             "-----------------------------------------------------" | Out-File $LogFile -Append
		     Update-SPSolution –Identity $solutionFileName -LiteralPath $solutionFilePath –GACDeployment | Out-File $LogFile -Append
             [System.Console]::WriteLine("-----------------------------------------------------")
             "-----------------------------------------------------" | Out-File $LogFile -Append
		     [System.Console]::WriteLine("Successfully Updated solution package")
             "Successfully Updated solution package" | Out-File $LogFIle -Append
             [System.Console]::WriteLine("-----------------------------------------------------")
             "-----------------------------------------------------" | Out-File $LogFile -Append
		}
	    else
		{

		     #
		     # Add solution package
		     #

		     $solution = (Get-SPSolution | where-object {$_.Id -eq $solutionGUID})
		     if ($solution -eq $null) 
             {
             [System.Console]::WriteLine("-----------------------------------------------------")
             "-----------------------------------------------------" | Out-File $LogFile -Append
		     [System.Console]::WriteLine("Adding solution package")
             "Adding solution package" | Out-File $LogFile -Append
             [System.Console]::WriteLine("-----------------------------------------------------")
             "-----------------------------------------------------" | Out-File $LogFile -Append
		     Add-SPSolution $solutionFile.FullName | Out-File $LogFile -Append
             [System.Console]::WriteLine("-----------------------------------------------------")
             "-----------------------------------------------------" | Out-File $LogFile -Append
		     [System.Console]::WriteLine("Successfully Added solution package")
             "Successfully Added solution package" | Out-File $LogFile -Append
             [System.Console]::WriteLine("-----------------------------------------------------")
             "-----------------------------------------------------" | Out-File $LogFile -Append
		     }

		     #
		     # Deploy solution package
		     #
		     $solution = (Get-SPSolution -Identity $solutionGUID)
		     if($solution.deployed -ne $true)
		     {
                 [System.Console]::WriteLine("-----------------------------------------------------")
                 "-----------------------------------------------------" | Out-File $LogFile -Append
		         [System.Console]::WriteLine("Deploying solution package")
                 "Deploying solution package" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("-----------------------------------------------------")
                 "-----------------------------------------------------" | Out-File $LogFile -Append
		         Install-SPSolution -Identity $solutionFileName -WebApplication $WebApplicationURL -GACDeployment -force | Out-File $LogFile -Append
                 [System.Console]::WriteLine("-----------------------------------------------------")
                 "-----------------------------------------------------" | Out-File $LogFile -Append
		         [System.Console]::WriteLine("Successfully Deployed solution package")
                 "Successfully Deployed solution package" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("-----------------------------------------------------")
                 "-----------------------------------------------------" | Out-File $LogFile -Append

		         stsadm -o execadmsvcjobs

		         $deploystatus = (Get-SPSolution | where-object {$_.Name -eq $solutionFileName})
        
                 #
                 # Restart services
                 #
                 [System.Console]::WriteLine("-----------------------------------------------------")
                 "-----------------------------------------------------" | Out-File $LogFile -Append
                 [System.Console]::WriteLine("Restarting Services-")
                 "Restarting Services-" | Out-File $LogFile -Append
                 iisreset | Out-File $LogFile -Append
		}
	}	

}
   catch [System.Exception]
   {
	 Write-Output "Error in creating the sharepoint site..." | Out-File $LogFile -Append
	 Write-Output $_.Exception.message | Out-File $LogFIle -Append	
   }
   Finally
   {
     Write-Output "Successfully Installed WSP solution to sharepoint site..." | Out-File $LogFile -Append
   }
}


#call the function

New_InstallWSP -solutionGUID $solutionGUID -WebApplicationURL $WebApplicationURL -WSPPath $WSPPath