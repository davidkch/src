   <#   
.SYNOPSIS   
	Function to connect an RDP session without the password prompt
    
.DESCRIPTION 
	This function provides the functionality to start an RDP session without having to type in the password
	
.PARAMETER ComputerName
    This can be a single computername or an array of computers to which RDP session will be opened

.PARAMETER User
    The user name that will be used to authenticate

.PARAMETER Password
    The Password that will be used to authenticate

.EXAMPLE   
	 .\ConnectTestAgent.ps1
    
Description 
-----------     
This command dot sources the script to ensure the Connect-Mstsc function is available in your current PowerShell session

.EXAMPLE   
	.\ConnectTestAgent.ps1 server01 "Domain\Username"

Description 
-----------     
A remote desktop session to server01 will be created using the credentials of contoso\jaapbrasser

.EXAMPLE   
	.\ConnectTestAgent.ps1 server01,server02 "Domain\Username"

Description 
-----------     
Two RDP session to server01 and server02 will be created using the credentials of domain\xyz
#> 
   
   
   
   
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [Alias("CN")]
            [string[]]$ComputerName        
    )

    process {

	## Converting Encoded bgcoebld Password to Decoded ##

	$string2Decode = "RVNJVEJsZFRlYW1AMmsxNCE="
	$bytes2Decode  = [System.Convert]::FromBase64String($string2Decode);
	$decoded = [System.Text.Encoding]::UTF8.GetString($bytes2Decode); 

	## Script for Remote Destop Session ##

        foreach ($Computer in $ComputerName) {
            $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
            $Process = New-Object System.Diagnostics.Process

            $ProcessInfo.FileName = "$($env:SystemRoot)\system32\cmdkey.exe"
            $ProcessInfo.Arguments = "/generic:TERMSRV/$Computer /user:Redmond\bgcoebld /pass:$decoded"
            $Process.StartInfo = $ProcessInfo
            $Process.Start()

            $ProcessInfo.FileName = "$($env:SystemRoot)\system32\mstsc.exe"
            $ProcessInfo.Arguments = "/v $Computer"
            $Process.StartInfo = $ProcessInfo
            $Process.Start()
           
           # To delete the credentials run 
           # cmdkey /delete:TERMSRV/$Computer
        }
    }
