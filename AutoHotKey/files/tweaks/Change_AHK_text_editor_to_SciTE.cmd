rem set AHK text editor to SciTE4AutoHotkey
@echo off

IF EXIST "%ProgramFiles%\AutoHotkey\SciTE\SciTE.exe" (
    reg add "HKEY_CLASSES_ROOT\AutoHotkeyScript\Shell\Edit\Command" ^
        /v "" ^
        /d "C:\Program Files\AutoHotkey\SciTE\SciTE.exe %1"
    goto :eof
)

IF EXIST "%ProgramFiles(x86)%\AutoHotkey\SciTE\SciTE.exe" (
    reg add "HKEY_CLASSES_ROOT\AutoHotkeyScript\Shell\Edit\Command" ^
        /v "" ^
        /d "C:\Program Files (x86)\AutoHotkey\SciTE\SciTE.exe %1"
    goto :eof
)

echo SciTE4AutoHotkey wasn't found
