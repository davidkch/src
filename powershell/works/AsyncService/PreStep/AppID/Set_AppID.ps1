#######################  
<#  
.SYNOPSIS  
 Creates a new registry key.
.DESCRIPTION  
 Creates a new registry key.  Assumes it does not exist.
.EXAMPLE  
.\Set_AppID.ps1 -Path "HKEY:\MyReg" -Name "MyKey" -Value "MyValue" -PropertyType "DWORD"
Version History  
v1.0   - ESIT Build Team - Initial Release  
#>

param(
  $Path = $(throw "Please pass registry path."),
  $Name = $(throw "Please pass the name of the registry item."),
  $Value = $(throw "Please pass the value of the registry item."),
  $PropertyType = $(throw "Please pass the value of the registry item.")
)

Function Set_AppID
{
	try
	{
        Write-Output ""
        Write-Output "Configuring AppID..."
	Write-Output "PATH: $Path"
	Write-Output "NAME: $Name"
	Write-Output "VALUE: $value"
	Write-Output "PROPERTY TYPE: $PropertyType"

        New-Item -Path $Path -force
        New-ItemProperty -Path $Path -Name "$Name" -Value $Value -PropertyType "$PropertyType" -ErrorAction "Stop"

        <#
        .\ManageRegistryKey.ps1 -Path $Path -Name "$Name" -Value $Value -PropertyType "$PropertyType" -ErrorAction "Stop"
        $result = $output | Select-Object -last 1
        if($result) { return $true }
        #>
    }
	Catch [system.exception]
	{
		write-output "ERROR: " $_.exception.message
	}
	Finally
	{
		Write-Output "Set_AppID.ps1 Executed Successfully"
	}
}

Set_AppID -Path $Path -Name $Name -Value $Value -PropertyType $PropertyType