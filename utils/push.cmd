:: push (save) your current configs to this local repo
:: %1 - context folder containing files\ folder and trailing with slash
@echo off
setlocal EnableDelayedExpansion

:init
    set context=%~1
    set context=%context:~0,-1%

    for %%i in ("%context%") do (
        set program=%%~ni
        echo push ^(save^) your current !program! configs to this local repo
    )

    for /f "tokens=* usebackq" %%i in (`%~dp0getDateTime.cmd`) do (
        set datetime=%%i
    )

    call :checkFiles
    if not ErrorLevel 1 call :main

    if "%pause%" == 1 (
        echo %CmdCmdLine% | find /i "%~0" >nul
        if not ErrorLevel 1 pause
    )
exit /b

:checkFiles
    if not exist "%context%\files\" (
        echo Folder "%context%\files\" can't be found.
        set pause=1
        exit /b 1
    )

    if not exist "%context%\list.txt" (
        echo File "%context%\list.txt" can't be found.
        set pause=1
        exit /b 1
    )
exit /b

:main
    for /f "tokens=*" %%i in ('type "%context%\list.txt" ^| findstr /r /v /c:"^<" /c:"^[ 	]*$"') do (
        call set file=%%~i
        if exist "!file!" (
            rem echo [DEBUG] COPY FROM "!file!"
            rem echo [DEBUG]        TO "files\%%~ni (%datetime%)%%~xi"
            copy "!file!" "files\%%~ni (%datetime%)%%~xi" > nul
            if not ErrorLevel 1 (
                echo File "!file!" copied successfully.
            ) else (
                echo Can't copy file "!file!" to "files\%%~ni (%datetime%)%%~xi".
                set pause=1
            )
        ) else (
            echo File "!file!" can't be found.
            set pause=1
        )
    )
exit /b
