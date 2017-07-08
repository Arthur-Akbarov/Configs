rem push Light Alloy config to local configs repo
@echo off

set dir=%LocalAppData%\LightAlloy
set name=LA.xml
set file=%dir%\%name%

if not exist "%file%" (
	echo File "%file%" can't be found.
	pause & goto :eof
)

copy "%file%" files\
pause
