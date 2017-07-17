@echo push current ConEmu config to local configs repo
@echo off

set dir=%AppData%
set name=ConEmu.xml
set file=%dir%\%name%

if not exist "%file%" (
	echo File "%file%" can't be found.
	pause & goto :eof
)

copy "%file%" files\
pause
