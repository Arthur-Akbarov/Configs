:: SetUnknownFileEditor.cmd
:: set program as default program for any unknown file types
:: usage example
:: SetUnknownFileEditor.cmd Notepad++\notepad++.exe
@echo off

set program=%ProgramFiles%\%*
if exist "%program%" goto :regedit 2>nul

set program=%ProgramFiles(x86)%\%*
if exist "%program%" goto :regedit 2>nul

echo Program "%*" couldn't be found.
goto :eof

:regedit
reg delete "HKEY_CLASSES_ROOT\Unknown\shell\openas" /f 2>nul
reg add "HKEY_CLASSES_ROOT\Unknown\shell\openas\command" /d "%program% %%1" /f
