@echo off
SETLOCAL enableextensions enabledelayedexpansion

set notepad="%ProgramFiles%\Notepad++\notepad++.exe" 
if exist %notepad% goto :setEditor

set notepad="%ProgramFiles(x86)%\Notepad++\notepad++.exe"
if exist %notepad% goto :setEditor

goto :skipEditor

:setEditor
doskey ed=%notepad% $*
doskey alias=%notepad% %DoskeyDir%files\cmdrc.cmd

:skipEditor
doskey ..=cd ../
doskey path=%DoskeyDir%files\splitPath.cmd
doskey ls=dir $*
doskey l=dir /B $*
doskey clear=cls

doskey s=cd        D:\Workspace\studit\src
doskey b=start  /d D:\Workspace\studit\src                            run-backend.cmd
doskey m=start  /d D:\Workspace\studit\src\main-service               run-main-service.cmd
doskey d=start  /d D:\Workspace\studit\src\data-service               run-data-service.cmd
doskey f=start  /d D:\Workspace\studit\webroot                        npm start
doskey db=start /d D:\Workspace\studit\src\data-service\schema cmd /k init

doskey n=psql -d studit -c "select id, tags, substring(title from 1 for 20) title, created from public.news" 1$GD:\1.txt ^& "C:\Program Files\Notepad++\notepad++.exe" D:\1.txt
