@echo off
setlocal EnableExtensions EnableDelayedExpansion

set editor="%ProgramFiles%\Sublime Text 3\sublime_text.exe"
if exist %editor% goto :setEditor

set editor="%ProgramFiles(x86)%\Sublime Text 3\sublime_text.exe"
if exist %editor% goto :setEditor

set editor="%ProgramFiles%\Notepad++\notepad++.exe"
if exist %editor% goto :setEditor

set editor="%ProgramFiles(x86)%\Notepad++\notepad++.exe"
if exist %editor% goto :setEditor

goto :skipEditor

:setEditor
doskey ed=%editor% $*
doskey alias=%editor% %DoskeyDir%files\cmdrc.cmd

:skipEditor
doskey ..=cd ../
doskey path=%DoskeyDir%files\splitPath.cmd
doskey ls=dir $*
doskey l=dir /b $*
doskey clear=cls
doskey mv=move $*
doskey cp=copy $*
doskey pwd=cd
