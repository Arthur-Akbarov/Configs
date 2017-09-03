@echo off

rem delete default Sublime Text 3 context menu item
reg delete "HKEY_CLASSES_ROOT\*\shell\Open with Sublime Text" /f

set subl=%ProgramFiles%\Sublime Text 3\sublime_text.exe
if exist "%subl%" goto :regedit 2>nul

set subl=%ProgramFiles(x86)%\Sublime Text 3\sublime_text.exe
if exist "%subl%" goto :regedit 2>nul

echo Sublime Text 3 couldn't be found.
goto :eof

:regedit
rem add Sublime Text 3 for all file types
reg add "HKEY_CLASSES_ROOT\*\shell\Open with Sublime Text 3"                                      /d "Open &with Sublime Text 3" /f
reg add "HKEY_CLASSES_ROOT\*\shell\Open with Sublime Text 3"                            /v "Icon" /d "%subl%,0"                  /f
reg add "HKEY_CLASSES_ROOT\*\shell\Open with Sublime Text 3\command"                    /v ""     /d "%subl%     \"%%1\""        /f

rem add Sublime Text 3 for folders
reg add "HKEY_CLASSES_ROOT\Directory\shell\Open with Sublime Text 3"                              /d "Open &with Sublime Text 3" /f
reg add "HKEY_CLASSES_ROOT\Directory\shell\Open with Sublime Text 3"                    /v "Icon" /d "%subl%,0"                  /f
reg add "HKEY_CLASSES_ROOT\Directory\shell\Open with Sublime Text 3\command"                      /d "%subl%     \"%%1\""        /f

rem add Sublime Text 3 for folder background
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\Open with Sublime Text 3"                   /d "Open &with Sublime Text 3" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\Open with Sublime Text 3"         /v "Icon" /d "%subl%,0"                  /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\Open with Sublime Text 3\command"           /d "%subl%     \"%%v\""        /f
