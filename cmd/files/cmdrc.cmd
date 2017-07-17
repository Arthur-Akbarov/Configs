@echo off
SETLOCAL enableextensions enabledelayedexpansion

set a="%ProgramFiles%\Notepad++\notepad++.exe" 
if exist %a% goto :setEditor

set a="%ProgramFiles(x86)%\Notepad++\notepad++.exe"
if exist %a% goto :setEditor

goto :skipEditor

:setEditor
doskey ed=%a% $*
doskey alias=%a% %DoskeyDir%files\cmdrc.cmd

:skipEditor
doskey ..=cd ../
doskey path=%DoskeyDir%files\splitPath.cmd
doskey ls=dir $*
doskey l=dir /B $*
doskey clear=cls

doskey s=cd        D:\Workspace\studit\src
doskey b=start  /d D:\Workspace\studit\src                            run_backend
doskey m=start  /d D:\Workspace\studit\src\main-service               run_studit_back
doskey a=start  /d D:\Workspace\studit\src\auth-service               run_studit_auth
doskey f=start  /d D:\Workspace\studit\webroot                        npm start
doskey db=start /d D:\Workspace\studit\src\main-service\schema cmd /k init
