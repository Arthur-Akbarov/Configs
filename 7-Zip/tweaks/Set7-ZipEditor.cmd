:: Set7-ZipEditor.cmd
:: set program as file editor in 7-Zip
:: usage example
:: Set7-ZipEditor.cmd Notepad++\notepad++.exe
@echo off

set program=%ProgramFiles%\%*
if exist "%program%" goto :regedit 2>nul

set program=%ProgramFiles(x86)%\%*
if exist "%program%" goto :regedit 2>nul

echo Program "%*" couldn't be found.
goto :eof

:regedit
reg add "HKCU\Software\7-Zip\FM" /v "Editor" /d "%program%" /f
