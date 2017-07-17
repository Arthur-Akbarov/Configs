rem set AHK text editor to Sublime Text 3
@echo off

IF EXIST "%ProgramFiles%\Sublime Text 3\sublime_text.exe" (
    reg add "HKEY_CLASSES_ROOT\AutoHotkeyScript\Shell\Edit\Command" ^
        /v "" ^
        /d "C:\Program Files\Sublime Text 3\sublime_text.exe %1"
    goto :eof
)

IF EXIST "%ProgramFiles(x86)%\Sublime Text 3\sublime_text.exe" (
    reg add "HKEY_CLASSES_ROOT\AutoHotkeyScript\Shell\Edit\Command" ^
        /v "" ^
        /d "C:\Program Files (x86)\Sublime Text 3\sublime_text.exe %1"
    goto :eof
)

echo Sublime Text 3 wasn't found
