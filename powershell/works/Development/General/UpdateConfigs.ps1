<#
.SYNOPSIS
Generic script to update configuration files.
.DESCRIPTION
Generic script to update configuration files.
.EXAMPLE
.\UpdateConfigs.ps1 -ConfigFilePath "D:\test\web.config" -IsSinglenode 1 -Configpath "/configuration/system.serviceModel/behaviors/endpointBehaviors/behavior" -SinglenodeValuetoupdate "DefaultEndPointBehavior"
This will update below 'EndPointBehavior' value to 'DefaultEndPointBehavior'.
"<behavior>EndPointBehavior</behavior>"

EXAMPLE
.\UpdateConfigs.ps1 -ConfigFilePath "D:\test\web.config" -IsSinglenode 1 -Configpath "/configuration/appSettings/add[@key='behavior']/@value" -SinglenodeValuetoupdate "DefaultEndPointBehavior"
This will update a specific node with a key name (for when there are multiple identical nodes with different names) with the specified value.

.EXAMPLE
.\UpdateConfigs.ps1 -ConfigFilePath "D:\test\web.config" -IsSinglenode 0 -Configpath "/configuration/system.serviceModel/behaviors/serviceBehaviors/behavior" -AttributekeyName "name" -AttributekeyValue "ServiceBehavior" -AttibutenodetoUpdate "name" -AttributenodeValue "DefaultServiceBehavior"
This will update below 'ServiceBehavior' value to 'DefaultServiceBehavior'.
"<add key="behavior" value="DefaultEndPointBehavior" />"

.EXAMPLE
.\UpdateConfigs.ps1 -ConfigFilePath "D:\test\web.config" -IsSinglenode 0 -Configpath "/configuration/system.serviceModel/behaviors/serviceBehaviors/behavior/serviceCredentials/clientCertificate/authentication" -AttributekeyName "certificateValidationMode" -AttributekeyValue "ChainTrust" -AttibutenodetoUpdate "revocationMode" -AttributenodeValue "check"
This will update below 'revocationMode' value to 'check'.
"<authentication certificateValidationMode="ChainTrust" revocationMode="NoCheck" />"

Version History  
v1.0   - ESIT Build Team - Initial Release
#>

param( 
         [String]$ConfigFilePath=$(throw "pass configuration file path."),
         [String]$Configpath=$(throw "pass configuration path."),
         [String]$AttributekeyName,[String]$AttributekeyValue,[String]$AttibutenodetoUpdate,[String]$AttributenodeValue,
         [Boolean]$IsSinglenode=$(throw "pass 1 to update single node value in configuration file."),
         [String]$SinglenodeValuetoupdate
)

$LogFile="UpdateConfigs.log"

Function UpdateConfigs
{
     Try
     {
        if(Test-Path "$ConfigFilePath")
        {
          if($IsSinglenode)
           {
               if($SinglenodeValuetoupdate)
               {
                  SinglenodeUpdate
               }
               else
               {   
                    "-------------------------------------------------------------------------" | Out-File $LogFile -Append
                    [System.Console]::WriteLine("-------------------------------------------------------------------------")
                    "pass 'SinglenodeValuetoupdate' parameter to update single node value in '$ConfigFilePath' configuration file." | Out-File $LogFile -Append
                    [System.Console]::WriteLine("pass 'SinglenodeValuetoupdate' parameter to update single node value in '$ConfigFilePath' configuration file.")
                    "-------------------------------------------------------------------------" | Out-File $LogFile -Append
                    [System.Console]::WriteLine("-------------------------------------------------------------------------")
               }
           }
           else
           {
               if($AttributekeyName -and $AttributekeyValue -and $AttibutenodetoUpdate -and $AttributenodeValue -and $Configpath)
               {
                    KeyvalueUpdate
               }
               else
               {
                    "-------------------------------------------------------------------------" | Out-File $LogFile -Append
                    [System.Console]::WriteLine("-------------------------------------------------------------------------")
                    "pass 'AttributekeyName','AttributekeyValue','AttibutenodetoUpdate' and 'AttributenodeValue' parameters for updating '$ConfigFilePath' configuration file." | Out-File $LogFile -Append
                    [System.Console]::WriteLine("pass 'AttributekeyName','AttributekeyValue','AttibutenodetoUpdate' and 'AttributenodeValue' parameters for updating '$ConfigFilePath' configuration file.")
                    "-------------------------------------------------------------------------" | Out-File $LogFile -Append
                    [System.Console]::WriteLine("-------------------------------------------------------------------------")
               }
           }
        }
        else
        {
             "File '$ConfigFilePath' does not exists!" | Out-File $LogFile -Append
             [System.Console]::WriteLine("File '$ConfigFilePath' does not exists!")
        }
       
     }
     Catch
     {
          [System.Exception]
          Write-Output $_.Exception.Message | Out-File $LogFile -Append
          Write-Host $_.Exception.Message
     }
     Finally
     {
          "Exection Completed!" | Out-File $LogFile -Append
          [System.Console]::WriteLine("Exection Completed!")
     }
}


Function SinglenodeUpdate
{
     Try
      {
         $xml=New-Object XML 
         $xml.Load("$ConfigFilePath")
         $node=$xml.SelectSingleNode("$Configpath")
         if($node)
         {
             $node.InnerXml="$SinglenodeValuetoupdate"
             $xml.Save("$ConfigFilePath")
            
         }
         else
         {
             Throw "configpath '$Configpath' does not exists in the file!"
         }
         
          "-------------------------------------------------------------------------" | Out-File $LogFile -Append
         [System.Console]::WriteLine("-------------------------------------------------------------------------")
         "Updated single node with '$SinglenodeValuetoupdate'" | Out-File $LogFile -Append
         [System.Console]::WriteLine("Updated single node with '$SinglenodeValuetoupdate'" )
          "-------------------------------------------------------------------------" | Out-File $LogFile -Append
         [System.Console]::WriteLine("-------------------------------------------------------------------------")
     }
     Catch
     {
          [System.Exception]
          Write-Output $_.Exception.Message | Out-File $LogFile -Append
          Write-Host $_.Exception.Message
     }
     Finally
     {
          "-------------------------------------------------------------------------" | Out-File $LogFile -Append
          [System.Console]::WriteLine("-------------------------------------------------------------------------")
          "'SinglenodeUpdate' funtion execution completed!" | Out-File $LogFile -Append
          [System.Console]::WriteLine("'SinglenodeUpdate' funtion execution completed!")
          "-------------------------------------------------------------------------" | Out-File $LogFile -Append
          [System.Console]::WriteLine("-------------------------------------------------------------------------")
     }
}


Function KeyvalueUpdate
{
 Try
     {
         $xml=New-Object XML 
         $xml.Load("$ConfigFilePath")
         $node=$xml.SelectSingleNode("$Configpath")
         if($node)
         {
             if($node.$AttributekeyName)
             {
               if($node.$AttributekeyName -eq "$AttributekeyValue")
               {
                  $node.$AttibutenodetoUpdate="$AttributenodeValue"
               }
               else
               {
                   Throw "'$AttributekeyName' does not having '$AttributekeyValue' value"
               }
             }
             else
             {
                  Throw "'$AttributekeyName' does not exists in configpath '$Configpath'"
             }
         }
         else
         {
             Throw "configpath '$Configpath' does not exists in the file!"
         }
         $xml.Save("$ConfigFilePath")
         "-------------------------------------------------------------------------" | Out-File $LogFile -Append
         [System.Console]::WriteLine("-------------------------------------------------------------------------")
         "Updated value of '$AttibutenodetoUpdate' with '$AttributenodeValue'" | Out-File $LogFile -Append
         [System.Console]::WriteLine("Updated value of '$AttibutenodetoUpdate' with '$AttributenodeValue'" )
          "-------------------------------------------------------------------------" | Out-File $LogFile -Append
         [System.Console]::WriteLine("-------------------------------------------------------------------------")
         
     }
     Catch
     {
          [System.Exception]
          Write-Output $_.Exception.Message | Out-File $LogFile -Append
          Write-Host $_.Exception.Message
     }
     Finally
     {
          "-------------------------------------------------------------------------" | Out-File $LogFile -Append
          [System.Console]::WriteLine("-------------------------------------------------------------------------")
          "'KeyvalueUpdate' funtion execution completed!" | Out-File $LogFile -Append
          [System.Console]::WriteLine("'KeyvalueUpdate' funtion execution completed!")
           "-------------------------------------------------------------------------" | Out-File $LogFile -Append
          [System.Console]::WriteLine("-------------------------------------------------------------------------")
     }
}

UpdateConfigs -ConfigFilePath $ConfigFilePath -IsSinglenode $IsSinglenode -Configpath $Configpath -AttributekeyName $AttributekeyName -AttributekeyValue $AttributekeyValue -AttibutenodetoUpdate $AttibutenodetoUpdate -AttributenodeValue $AttributenodeValue -SinglenodeValuetoupdate $SinglenodeValuetoupdate