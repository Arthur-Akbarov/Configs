@echo pull ^(apply^) hosts file config from this local repo
@echo off
setlocal EnableDelayedExpansion

:init
    set dir=%SystemRoot%\System32\drivers\etc
    set name=hosts
    set file=%dir%\%name%

    copy "files\%name%" "%file%" > nul
    if ErrorLevel 1 (
        echo It works only with disabled UAC.
        echo You may copy hosts manually.
        call :manuallyCopy
    )

    if "%pause%" == 1 (
        echo %CmdCmdLine% | find /i "%~0" > nul
        if not ErrorLevel 1 pause
    )
exit /b

:manuallyCopy
    if not exist "%dir%" (
        echo Folder "%dir%" can't be found.
        choice /m "Create it"
        if !ErrorLevel! == 2 (
            exit /b
        )
        if !ErrorLevel! == 1 (
            mkdir "%dir%"
            if ErrorLevel 1 (
                echo Can't create folder "%dir%".
                set pause=1
                exit /b
            )
        )
    )

    choice /m "Open %dir%"
    if %ErrorLevel% == 1 (
        explorer "%dir%"
    )
exit /b
