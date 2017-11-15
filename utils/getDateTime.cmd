:: get date similar to iso 8601 format
@echo off

for /f "tokens=1-6" %%G in ('wmic path Win32_LocalTime get Day^,Hour^,Minute^,Month^,Second^,Year ^| more +1') do (
    set yyyy=%%L
    set mm=00%%J
    set dd=00%%G
    set hour=00%%H
    set min=00%%I
    set sec=00%%K
    goto next
)
:next

:: pad digits with leading zeros
set mm=%mm:~-2%
set dd=%dd:~-2%
set hour=%hour:~-2%
set min=%min:~-2%
set sec=%sec:~-2%

set datetime=%yyyy%-%mm%-%dd% %hour%-%min%-%sec%
echo %datetime%
