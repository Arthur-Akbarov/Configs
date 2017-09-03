@echo pull and apply Process Hacker config from local configs repo
@echo off

set dir=%AppData%\Process Hacker 2
call :checkDir "%dir%"

set name=settings.xml
set file=%dir%\%name%
call :copy "files\%name%" "%file%"

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

:checkDir
if not exist %1 (
	mkdir %1
	if ErrorLevel 1 (
		echo Can't create folder %1.
		pause & goto :eof
	)
)
exit /b 0
