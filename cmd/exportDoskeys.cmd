@echo add cmd aliases file to registry
@echo off

:: %~dp0 should be without quotes to use %DoskeyDir% as prefix in other scripts
reg add "HKCU\Environment" ^
        /v "DoskeyDir" ^
        /d %~dp0

reg add "HKCU\Software\Microsoft\Command Processor" ^
        /v "AutoRun" ^
        /d """%~dp0files\cmdrc.cmd""" ^
        /f
