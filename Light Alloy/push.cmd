@echo push Light Alloy config to local configs repo
@echo off

set dir=%LocalAppData%\LightAlloy

set name=LA.xml
set file=%dir%\%name%
CALL :copy "%file%" files\

pause
EXIT /B %ErrorLevel%


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
EXIT /B 0
