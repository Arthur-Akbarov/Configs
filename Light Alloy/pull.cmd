@echo off
rem pull Light Alloy config

set dir=%LocalAppData%\LightAlloy
set name=LA.xml
set file=%dir%\%name%

if not exist "%file%" (
	echo File "%file%" can't be found.
	pause & goto :eof
)

copy "%file%" files\
pause
