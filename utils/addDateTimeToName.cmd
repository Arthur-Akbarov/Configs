:: add datetime to input file name before extension
@echo off

for %%f in (%1) do (
    set name=%%~nf
    set ext=%%~xf
)

for /f "tokens=* usebackq" %%f in (`%~dp0getDateTime.cmd`) do (
    set date=%%f
)

echo %name% (%date%)%ext%
