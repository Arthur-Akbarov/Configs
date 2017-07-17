@echo pull and apply Light Alloy config from local configs repo
@echo off

set dir=%LocalAppData%\LightAlloy
set name=LA.xml
set file=%dir%\%name%

if not exist "%dir%" (
	mkdir "%dir%"
	if ErrorLevel 1 (
		echo Can't create folder "%dir%".
		pause & goto :eof
	)
)

copy "files\%name%" "%file%"
pause
