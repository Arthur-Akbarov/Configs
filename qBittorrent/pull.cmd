@echo pull and apply qBittorrent config from local configs repo
@echo off

set dir=%AppData%\qBittorrent
set name=qBittorrent.ini
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
