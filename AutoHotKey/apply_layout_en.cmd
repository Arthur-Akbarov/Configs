rem add AHK script with en layout shortcut to user autorun and apply now
@echo off

set dir=%AppData%\Microsoft\Windows\Start Menu\Programs\Startup
set name=layout_en.ahk
set file=%dir%\%name%.lnk

cscript make_shortcut.vbs "%file%" "%CD%\files\%name%"
start "" "%file%"
pause

