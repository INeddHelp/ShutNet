@echo off
setlocal EnableDelayedExpansion

echo. > Ips.txt

for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr "IPv4"') do (
  set IPs=!IPs! %%a
)

set IPs=%IPs:~1%
set IPs=%IPs:~0,-1%

for %%i in (%IPs%) do (
 echo %%i >> Ips.txt
)

type Ips.txt
shutdown -i

 REM wevtutil cl "Microsoft-Windows-NetworkProfile/Operational" /r /u %%i\%USERNAME% /p %PASSWORD:*%=%% /s %%i
 REM wevtutil cl "System" /r /u %%i\%USERNAME% /p %PASSWORD:*%=%% /s %%i