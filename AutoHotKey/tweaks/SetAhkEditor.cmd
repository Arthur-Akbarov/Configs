:: SetAhkEditor.cmd
:: set program as AHK text editor
:: usage example
:: SetAhkEditor.cmd Notepad++\notepad++.exe
@echo off

set program=%ProgramFiles%\%*
if exist "%program%" goto :regedit 2>nul

set program=%ProgramFiles(x86)%\%*
if exist "%program%" goto :regedit 2>nul

echo Program "%*" couldn't be found.
goto :eof

:regedit
reg add "HKCR\AutoHotkeyScript\Shell\Edit\Command" /d "%program% %%1" /f
