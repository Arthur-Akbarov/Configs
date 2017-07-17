@echo add cmd aliases file to registry
@echo off

reg add "HKEY_CURRENT_USER\Environment" ^
        /v "DoskeyDir" ^
        /d "%~dp0

reg add "HKEY_CURRENT_USER\Software\Microsoft\Command Processor" ^
        /v "AutoRun" ^
        /d "%~dp0\files\cmdrc.cmd" ^
        /f
