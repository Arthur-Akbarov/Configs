@echo open Notepad++ config folder in Windows
@echo off

set dir=%AppData%\Notepad++

if exist "%dir%" start /max explorer "%dir%" & goto :eof

echo Folder "%dir%" can't be found.
choice /m "Create it"
if %ErrorLevel% == 1 (
	mkdir "%dir%"
	if ErrorLevel 1 (
		echo Can't create folder "%dir%".
		pause & goto :eof
	)
	start /max explorer "%dir%"
)
