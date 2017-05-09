# configSource="Config


(Get-Content 'C:\Temp\Web.Config') | ForEach-Object { $_ -replace "configSource=`"Config", "configSource=`"bin\Web" } | Set-Content C:\Temp\Web.Config  -Force

# the line replaced to fortify
# powershell -Command "& {(Get-Content '%srcrce%\Web.Config') | ForEach-Object { $_ -replace \"configSource=\`\"Config\", \"configSource=`\"bin\Web\" } | Set-Content %source%\Web.Config  -Force"}

# working line in batchfile
# powershell -Command "& {(Get-Content 'C:\Temp\Web.Config') | ForEach-Object { $_ -replace \"configSource=\`\"Config\", \"configSource=`\"bin\Web\" } | Set-Content C:\Temp\Web.ConfigC3  -Force"}
