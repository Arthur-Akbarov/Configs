@echo push current Sublime Text 3 configs to local configs repo
@echo off

set dir=%AppData%\Sublime Text 3\Packages\User

set name=Preferences.sublime-settings
set file=%dir%\%name%
CALL :copy "%file%" files\

set name=Default (Windows).sublime-keymap
set file=%dir%\%name%
CALL :copy "%file%" files\

pause
EXIT /B %ErrorLevel%


:copy
if exist %1 (
	copy %1 %2 1>nul
	if ErrorLevel == 0 (
		echo File %1 copied successfully.
	) else (
		echo Can't copy file %1 to %2.
	)
) else (
	echo File %1 can't be found.
)
EXIT /B 0
