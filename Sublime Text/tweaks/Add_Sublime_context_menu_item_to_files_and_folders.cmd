@echo off

rem delete default ST context menu item
reg delete "HKEY_CLASSES_ROOT\*\shell\Open with Sublime Text" /f

SET st_path=%ProgramFiles%\Sublime Text 3\sublime_text.exe

rem add ST for all file types
reg add "HKEY_CLASSES_ROOT\*\shell\Open with Sublime Text 3"                           /t REG_SZ        /v ""     /d "Open &with Sublime Text 3" /f
reg add "HKEY_CLASSES_ROOT\*\shell\Open with Sublime Text 3"                           /t REG_EXPAND_SZ /v "Icon" /d "%st_path%,0"               /f
reg add "HKEY_CLASSES_ROOT\*\shell\Open with Sublime Text 3\command"                   /t REG_SZ        /v ""     /d "%st_path%     \"%%1\""     /f

rem add ST for folders
reg add "HKEY_CLASSES_ROOT\Directory\shell\Open with Sublime Text 3"                    /t REG_SZ        /v ""     /d "Open &with Sublime Text 3" /f
reg add "HKEY_CLASSES_ROOT\Directory\shell\Open with Sublime Text 3"                    /t REG_EXPAND_SZ /v "Icon" /d "%st_path%,0"               /f
reg add "HKEY_CLASSES_ROOT\Directory\shell\Open with Sublime Text 3\command"            /t REG_SZ        /v ""     /d "%st_path%     \"%%1\""     /f

rem add ST for current folder
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\Open with Sublime Text 3"         /t REG_SZ        /v ""     /d "Open &with Sublime Text 3" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\Open with Sublime Text 3"         /t REG_EXPAND_SZ /v "Icon" /d "%st_path%,0"               /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\Open with Sublime Text 3\command" /t REG_SZ        /v ""     /d "%st_path%     \"%%v\""     /f
