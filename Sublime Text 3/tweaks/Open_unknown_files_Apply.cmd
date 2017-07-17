@echo off
SET st3Path=%ProgramFiles%\Sublime Text 3\sublime_text.exe

reg delete "HKEY_CLASSES_ROOT\Unknown\shell\openas" /f
reg add "HKEY_CLASSES_ROOT\Unknown\shell\openas\command" /t REG_EXPAND_SZ /v "" /d "%st3Path% \"%%1\"" /f
