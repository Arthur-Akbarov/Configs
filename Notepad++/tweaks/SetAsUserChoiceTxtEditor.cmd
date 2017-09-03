@echo set Notepad++ as UserChoice .txt editor
@echo off

set notepad=%ProgramFiles%\Notepad++\notepad++.exe
if exist "%notepad%" goto :setEditor

set notepad=%ProgramFiles(x86)%\Notepad++\notepad++.exe
if exist "%notepad%" (goto :setEditor) else (goto :notFound )

:setEditor
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.txt\UserChoice" /t REG_SZ /v "Progid" /d "Applications\notepad++.exe" /f
reg add "HKCU\Software\Classes\Applications\notepad++.exe\shell\open\command" /t REG_SZ /v "" /d "%notepad% %%1" /f
echo set succefully & goto :eof

:notFound
echo Notepad++ couldn't be found.
pause
