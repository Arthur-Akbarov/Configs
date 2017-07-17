@echo push current Process Hacker config to local configs repo
@echo off

set dir=%AppData%\Process Hacker 2
set name=settings.xml
set file=%dir%\%name%

if not exist "%file%" (
	echo File "%file%" can't be found.
	pause & goto :eof
)

copy "%file%" files\
pause
