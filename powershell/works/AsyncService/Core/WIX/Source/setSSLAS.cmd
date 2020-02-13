ECHO OFF
ECHO Script is to setup certificate

IF [%1]==[] GOTO MISSING_EXIT
IF [%2]==[] GOTO MISSING_EXIT
IF [%3]==[] GOTO MISSING_EXIT

SET pfxfile=%1
SET pfxpass=%2
SET certfile=%3

certUtil -p %2 -importPFX %pfxfile% 
certUtil -addstore "MY" %certfile% 


GOTO EXIT

:MISSING_EXIT
echo Imput parameter(s) are missing
echo Usage: setSSL [.pfx file path] [.pfx file password] [.p7b file path]
echo Example setSSL D:\romantr\FS.pfx qwe D:\romantr\FS.p7b

:EXIT
echo Script completed successfully.





