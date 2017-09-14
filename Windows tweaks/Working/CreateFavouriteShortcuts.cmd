@echo create several shortcuts to user programs with shortcut keys
@echo off

set dir=%AppData%\Microsoft\Windows\Start Menu\Programs

set name=Downloads
set shortcut=%dir%\%name%.lnk
set src=%UserProfile%\%name%

cscript ..\..\utils\make_shortcut.vbs "%shortcut%" "%src%" "Ctrl+Alt+D" 3 >NUL
:: next statement does not work because cscript does not return errorlevel
:: && echo shortcut to %name% created successfully


set name=Configs
set shortcut=%dir%\%name%.lnk
cd ..\..\
set src=%cd%
cd %~dp0

cscript ..\..\utils\make_shortcut.vbs "%shortcut%" "%src%" "Ctrl+Alt+C" 3 >NUL


set name=YandexDisk
set shortcut=%dir%\%name%.lnk
set YDsrc=D:\%name%
set src=YDsrc

cscript ..\..\utils\make_shortcut.vbs "%shortcut%" "%src%" "Ctrl+Alt+W" 3 >NUL


set name=links
set shortcut=%dir%\%name%.lnk
set src=%YDsrc%\links

cscript ..\..\utils\make_shortcut.vbs "%shortcut%" "%src%" "Ctrl+Alt+K" 3 >NUL
pause
