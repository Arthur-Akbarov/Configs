@echo push current Process Hacker config to local configs repo
@echo off

set dir=%AppData%\Process Hacker 2

set name=settings.xml
set file=%dir%\%name%
call :copy "%file%" files\

pause
exit /b %ErrorLevel%


:copy
if exist %1 (
	copy %1 %2 1>NUL
	if ErrorLevel == 0 (
		echo File %1 copied successfully.
	) else (
		echo Can't copy file %1 to %2.
	)
) else (
	echo File %1 can't be found.
)
exit /b 0
