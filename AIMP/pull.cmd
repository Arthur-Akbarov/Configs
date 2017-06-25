@echo off
rem pull AIMP config

set dir=%AppData%\AIMP
set name=AIMP.ini
set file=%dir%\%name%

if not exist "%file%" (
	echo File "%file%" can't be found.
	pause & goto :eof
)

copy "%file%" files\
pause
