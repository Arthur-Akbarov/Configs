@echo push current Notepad++ config to local configs repo
@echo off

set dir=%AppData%\Notepad++
set name=shortcuts.xml
set file=%dir%\%name%

if not exist "%file%" (
	echo File "%file%" can't be found.
	pause & goto :eof
)

copy "%file%" files\
pause
