@echo push current Skype config to local configs repo
@echo off

set dir=%AppData%\Skype\arthur.akbarov
set name=config.xml
set file=%dir%\%name%

if not exist "%file%" (
	echo File "%file%" can't be found.
	pause & goto :eof
)

copy "%file%" files\
pause
