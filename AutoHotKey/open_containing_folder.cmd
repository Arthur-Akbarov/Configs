@echo open user autorun folder
@echo off

set dir=%AppData%\Microsoft\Windows\Start Menu\Programs\Startup

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
