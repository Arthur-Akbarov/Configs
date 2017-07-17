@echo pull and apply Sublime Text 3 configs from local configs repo
@echo off

set dir=%AppData%\Sublime Text 3\Packages\User
set name=Preferences.sublime-settings
set file=%dir%\%name%

if not exist "%dir%" (
	mkdir "%dir%"
	if ErrorLevel 1 (
		echo Can't create folder "%dir%".
		pause & goto :eof
	)
)

copy "files\%name%" "%file%"


set name=Default (Windows).sublime-keymap
set file=%dir%\%name%

copy "files\%name%" "%file%"
pause
