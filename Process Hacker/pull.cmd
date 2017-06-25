@echo off
rem pull Process Hacker config

set dir=%AppData%\Process Hacker 2
set name=settings.xml
set file=%dir%\%name%

if not exist "%file%" (
	echo File "%file%" can't be found.
	pause & goto :eof
)

copy "%file%" files\
pause
