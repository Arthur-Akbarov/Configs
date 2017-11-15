@echo push ^(save^) current hosts file config to this local repo
@echo off

:init
    set dir=%SystemRoot%\System32\drivers\etc
    set name=hosts
    set file=%dir%\%name%

    call :copy "%file%" files\

    if "%pause%" == 1 (
        echo %CmdCmdLine% | find /i "%~0" > nul
        if not ErrorLevel 1 pause
    )
exit /b

:copy
    if exist %1 (
        copy %1 %2 > nul
        if not ErrorLevel 1 (
            echo File %1 copied successfully.
        ) else (
            echo Can't copy file %1 to %2.
            set pause=1
        )
    ) else (
        echo File %1 can't be found.
    )
exit /b
