$ServerName = "G1310730101"
$SourcesDirectory = "c:\tempConfig"
$WCFConfig = "C:\PKITA\WEB\PublicWCF"

#(Get-Content $SourcesDirectory\src\app\Client\PKITA.Client.UI\app.config) | Foreach-Object {$_ -replace "<add key=`"WebServer`" value=`".*`"`/>", "<add key=`"WebServer`" value=$ServerName`/>"} | Set-Content $SourcesDirectory\src\app\Client\PKITA.Client.UI\app.config

##(Get-Content $SourcesDirectory\appClient.config) | Foreach-Object {$_ -replace "<add key=`"WebServer`" value=`".*`"`/>", "<add key=`"WebServer`" value=`"$ServerName`"`/>"} | Set-Content $SourcesDirectory\appClient.config
##(Get-Content $SourcesDirectory\appAdmin.config) | Foreach-Object {$_ -replace "<add key=`"CertStagingShare`" value=`".*`"`/>", "<add key=`"CertStagingShare`" value=`"\\$ServerName\CertificateStaging\`"`/>"} | Set-Content $SourcesDirectory\appAdmin.config
##(Get-Content $SourcesDirectory\appAdmin.config) | Foreach-Object {$_ -replace "<add key=`"CRLStagingShare`" value=`".*`"`/>", "<add key=`"CRLStagingShare`" value=`"\\$ServerName\CRLStaging\`"`/>"} | Set-Content $SourcesDirectory\appAdmin.config
##(Get-Content $SourcesDirectory\appAdmin.config) | Foreach-Object {$_ -replace "<add key=`"PrivateServiceServers`" value=`".*`"`/>", "<add key=`"PrivateServiceServers`" value=`"$ServerName`"`/>"} | Set-Content $SourcesDirectory\appAdmin.config

#<add key="CertStagingShare" value="\\pkitadevaocfs01\CertificateStaging\"/>
#<add key="CRLStagingShare" value="\\pkitadevaocfs01\CRLStaging\"/>


if(Test-Path -Path $WCFConfig)
{
    (Get-Content $WCFConfig\web.config) | Foreach-Object {$_ -replace "<security mode=`".*`">", "<security mode=`"None`">"} | Set-Content $WCFConfig\web.config
    (Get-Content $WCFConfig\web.config) | Foreach-Object {$_ -replace "<transport clientCredentialType=`".*`"`/>", ""} | Set-Content $WCFConfig\web.config

    (Get-Content $WCFConfig\web.config) | Foreach-Object {$_ -replace "<clientCredentials>", ""} | Set-Content $WCFConfig\web.config
    (Get-Content $WCFConfig\web.config) | Foreach-Object {$_ -replace "<clientCertificate storeLocation=`".*`" storeName=`".*`" x509FindType=`".*`" findValue=`".*`"`/>", ""} | Set-Content $WCFConfig\web.config
    (Get-Content $WCFConfig\web.config) | Foreach-Object {$_ -replace "<serviceCertificate>", ""} | Set-Content $WCFConfig\web.config
    (Get-Content $WCFConfig\web.config) | Foreach-Object {$_ -replace "<authentication certificateValidationMode=`".*`" trustedStoreLocation=`".*`" revocationMode=`".*`"`/>", ""} | Set-Content $WCFConfig\web.config
    (Get-Content $WCFConfig\web.config) | Foreach-Object {$_ -replace "<`/serviceCertificate>", ""} | Set-Content $WCFConfig\web.config
    (Get-Content $WCFConfig\web.config) | Foreach-Object {$_ -replace "<`/clientCredentials>", ""} | Set-Content $WCFConfig\web.config
}
#<security mode="Transport">
<#
<security mode="Transport">
            <transport clientCredentialType="Certificate"/>
          </security>


          <clientCredentials>
            <clientCertificate storeLocation="LocalMachine" storeName="My" x509FindType="FindByThumbprint" findValue="6E 90 97 62 8C DD 56 80 9C B3 A5 16 DB 05 84 54 AB 9D 64 A0 "/>
            <serviceCertificate>
              <authentication certificateValidationMode="PeerTrust" trustedStoreLocation="LocalMachine" revocationMode="NoCheck"/>
            </serviceCertificate>
          </clientCredentials>

 #>