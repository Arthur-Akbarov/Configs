@echo open Sublime Text 3 configs folder in Windows
@echo off

:init
    set dir=%AppData%\Sublime Text 3\Packages\User

    if exist "%dir%" (
        start /max explorer "%dir%"
        exit /b
    )

    echo Folder "%dir%" can't be found.
    choice /m "Create it"
    if %ErrorLevel% == 1 (
        mkdir "%dir%"
        if ErrorLevel 1 (
            echo Can't create folder "%dir%".
            set pause=1
        ) else (
            start /max explorer "%dir%"
        )
    )

    if "%pause%" == 1 (
        echo %CmdCmdLine% | find /i "%~0" >nul
        if not ErrorLevel 1 pause
    )
exit /b
