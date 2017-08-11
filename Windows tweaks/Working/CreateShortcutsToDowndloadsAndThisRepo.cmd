@echo create several shortcuts to user programs with shortcut keys
@echo off

set dir=%AppData%\Microsoft\Windows\Start Menu\Programs
set name=Downloads
set file=%dir%\%name%.lnk
set dest=%UserProfile%\%name%

cscript ..\..\utils\make_shortcut.vbs "%file%" "%dest%" "Ctrl+Alt+D" 3 >NUL


set dir=%AppData%\Microsoft\Windows\Start Menu\Programs
set name=Configs
set file=%dir%\%name%.lnk

cd ..\..\
set dest=%cd%
cd %~dp0

cscript ..\..\utils\make_shortcut.vbs "%file%" "%dest%" "Ctrl+Alt+C" 3 >NUL
pause
