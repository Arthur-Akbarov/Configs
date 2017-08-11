@echo push current qBittorrent config to local configs repo
@echo off

set dir=%AppData%\qBittorrent
set name=qBittorrent.ini
set file=%dir%\%name%

if not exist "%file%" (
	echo File "%file%" can't be found.
	pause & goto :eof
)

copy "%file%" files\
pause
