@echo pull hosts file
@echo off

set dir=%SystemRoot%\System32\drivers\etc
set name=hosts
set file=%dir%\%name%

if exist "%file%" copy "%file%" files\ & goto :eof
echo File "%file%" can't be found.
pause
