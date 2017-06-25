@ECHO OFF
TITLE Перемещение пользовательских данных
XCOPY "%USERPROFILE%\Мои документы\Моя музыка" D:\Аудио /S /I /Q /H /K /O /Y
XCOPY "%USERPROFILE%\Мои документы\Мои рисунки" D:\Фото /S /I /Q /H /K /O /Y
XCOPY "%USERPROFILE%\Мои документы\Мои видеозаписи" D:\Видео /S /I /Q /H /K /O /Y
MD D:\Аудио
MD D:\Фото
MD D:\Видео
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "My Music" /t REG_SZ /d D:\Аудио /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "My Pictures" /t REG_SZ /d D:\Фото /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "My Video" /t REG_SZ /d D:\Видео /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Music" /t REG_EXPAND_SZ /d D:\Аудио /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Pictures" /t REG_EXPAND_SZ /d D:\Фото /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Video" /t REG_EXPAND_SZ /d D:\Видео /f
RD /S /Q "%USERPROFILE%\Мои документы\Моя музыка"
RD /S /Q "%USERPROFILE%\Мои документы\Мои рисунки"
RD /S /Q "%USERPROFILE%\Мои документы\Мои видеозаписи"
XCOPY "%USERPROFILE%\Рабочий стол" "D:\Рабочий стол" /S /I /Q /H /K /O /Y
XCOPY "%USERPROFILE%\Мои документы" "D:\Мои документы" /S /I /Q /H /K /O /Y
MD "D:\Рабочий стол"
MD "D:\Мои документы"
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Desktop /t REG_SZ /d "D:\Рабочий стол" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Desktop /t REG_EXPAND_SZ /d "D:\Рабочий стол" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Personal /t REG_SZ /d "D:\Мои документы" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Personal /t REG_EXPAND_SZ /d "D:\Мои документы" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DocFolderPaths" /v %USERNAME% /t REG_SZ /d "D:\Мои документы" /f
RD /S /Q "%USERPROFILE%\Рабочий стол"
RD /S /Q "%USERPROFILE%\Мои документы"
PAUSE