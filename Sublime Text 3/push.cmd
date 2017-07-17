@echo push current Sublime Text 3 configs to local configs repo
@echo off

set dir=%AppData%\Sublime Text 3\Packages\User
set name=Preferences.sublime-settings
set file=%dir%\%name%

if not exist "%file%" (
	echo File "%file%" can't be found.
) else (copy "%file%" files\)


set dir=%AppData%\Sublime Text 3\Packages\User
set name=Default (Windows).sublime-keymap
set file=%dir%\%name%

if not exist "%file%" (
	echo File "%file%" can't be found.
	pause & goto :eof
)

copy "%file%" files\
pause
