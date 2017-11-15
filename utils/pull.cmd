:: pull (apply) last configs from this local repo
:: %1 - context folder containing files\ folder and trailing with slash
@echo off
setlocal EnableDelayedExpansion

:init
    set context=%~1
    set context=%context:~0,-1%

    for %%i in ("%context%") do (
        set program=%%~ni
        echo pull ^(apply^) last !program! configs from this local repo
    )

    set /a dirLength = 0

    for /f "tokens=*" %%i in ('type "%context%\list.txt" ^| findstr /r /v /c:"^<" /c:"^[ 	]*$"') do (
        call set file=%%~i
        for /f "tokens=*" %%j in ("!file!") do (
            set dir=%%~dpj
        )
        call :assureDirExist "!dir!"
        if not ErrorLevel 1 (
            set name=%%~ni
            set ext=%%~xi
            call :copyLastRevision
        )
    )

    if "%pause%" == 1 (
        echo %CmdCmdLine% | find /i "%~0" >nul
        if not ErrorLevel 1 pause
    )
exit /b

:assureDirExist
    rem echo [DEBUG] assureDirExist "%~1"
    if not exist "%~1" (
        mkdir "%~1"
        if ErrorLevel 1 (
            set /a lastDirIndex = !dirLength! - 1
            for /l %%j in (0, 1, !lastDirIndex!) do (
                rem echo [DEBUG] dir[%%j/!dirLength!] = "!dir[%%j]!"
                if "!dir[%%j]!" == "%~1" exit /b 1
            )
            echo Can't create folder "%~1".
            set dir[!dirLength!]=%~1
            set /a dirLength += 1
            set pause=1
            exit /b 1
        )
    )
exit /b

:copyLastRevision
    rem echo [DEBUG] copyLastRevision "%context%\files"
    for /f "tokens=*" %%j in ('dir /b /o-n "%context%\files\%name% (????-??-?? ??-??-??)*%ext%"') do (
        rem echo [DEBUG] COPY FROM "%context%\files\%%j"
        rem echo [DEBUG]        TO "%file%"
        copy "%context%\files\%%j" "%file%" > nul
        if not ErrorLevel 1 (
            echo File "%context%\files\%%j" copied successfully.
        ) else (
            echo Can't copy file "%context%\files\%%j" to "%file%".
            set pause=1
        )
        exit /b
    )
    echo File "%context%\files\%name% (????-??-?? ??-??-??)*%ext%" can't be found.
    set pause=1
exit /b
