$certName=$args[0]
$websiteName=$args[1]

#$certName="DSTestWeb"
#$websiteName="DSWeb"

$cert = (Get-ChildItem cert:\LocalMachine\my | Where-Object {$_.Subject -ilike "*$certName*"})
$thumbPrint=$cert.Thumbprint

$guid = [guid]::NewGuid()
$appid=$guid.Guid

c:\windows\system32\inetsrv\appcmd.exe set site $websiteName /+"bindings.[protocol='https',bindingInformation='*:443:$websiteName']"

netsh http add sslcert ipport=0.0.0.0:443 certhash=$thumbPrint appid="{$appid}"