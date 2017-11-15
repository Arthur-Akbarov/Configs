@echo pull and apply Skype config from local configs repo
@echo off

set dir=%AppData%\Skype\arthur.akbarov
set name=config.xml
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
