@echo pull and apply qBittorrent config from local configs repo
@echo off

set dir=%AppData%\qBittorrent
call :checkDir "%dir%"

set name=qBittorrent.ini
set file=%dir%\%name%
CALL :copy "files\%name%" "%file%"

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

:checkDir
if not exist %1 (
	mkdir %1
	if ErrorLevel 1 (
		echo Can't create folder %1.
		pause & goto :eof
	)
)
EXIT /B 0
