rem push current VLC config to local configs repo
@echo off

set dir=%AppData%\vlc
set name=vlcrc
set file=%dir%\%name%

if not exist "%file%" (
	echo File "%file%" can't be found.
	pause & goto :eof
)

copy "%file%" files\
pause
