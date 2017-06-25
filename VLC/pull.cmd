@echo off
rem pull VLC config

set dir=%AppData%\vlc
set name=vlcrc
set file=%dir%\%name%

if not exist "%file%" (
	echo File "%file%" can't be found.
	pause & goto :eof
)

copy "%file%" files\
pause
