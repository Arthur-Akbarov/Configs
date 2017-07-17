rem set AHK text editor to Notepad++
@echo off

IF EXIST "%ProgramFiles%\Notepad++\notepad++.exe" (
    reg add "HKEY_CLASSES_ROOT\AutoHotkeyScript\Shell\Edit\Command" ^
        /v "" ^
        /d "C:\Program Files\Notepad++\notepad++.exe %1"
    goto :eof
)

IF EXIST "%ProgramFiles(x86)%\Notepad++\notepad++.exe" (
    reg add "HKEY_CLASSES_ROOT\AutoHotkeyScript\Shell\Edit\Command" ^
        /v "" ^
        /d "C:\Program Files (x86)\Notepad++\notepad++.exe %1"
    goto :eof
)

echo Notepad++ wasn't found
