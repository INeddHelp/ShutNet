@echo off
setlocal EnableDelayedExpansion

for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr "IPv4"') do (
  set IPs=!IPs! %%a
)

set IPs=%IPs:~1%
set IPs=%IPs:~0,-1%

for %%i in (%IPs%) do (
  REM wevtutil cl "Microsoft-Windows-NetworkProfile/Operational" /r /u %%i\%USERNAME% /p %PASSWORD:*%=%% /s %%i
  REM wevtutil cl "System" /r /u %%i\%USERNAME% /p %PASSWORD:*%=%% /s %%i
  shutdown -i -s -m \\%%i -t 0
)

