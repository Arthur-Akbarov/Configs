@ECHO OFF
TITLE ����������� ���������������� ������
XCOPY "%USERPROFILE%\��� ���������\��� ������" D:\����� /S /I /Q /H /K /O /Y
XCOPY "%USERPROFILE%\��� ���������\��� �������" D:\���� /S /I /Q /H /K /O /Y
XCOPY "%USERPROFILE%\��� ���������\��� �����������" D:\����� /S /I /Q /H /K /O /Y
MD D:\�����
MD D:\����
MD D:\�����
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "My Music" /t REG_SZ /d D:\����� /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "My Pictures" /t REG_SZ /d D:\���� /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "My Video" /t REG_SZ /d D:\����� /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Music" /t REG_EXPAND_SZ /d D:\����� /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Pictures" /t REG_EXPAND_SZ /d D:\���� /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Video" /t REG_EXPAND_SZ /d D:\����� /f
RD /S /Q "%USERPROFILE%\��� ���������\��� ������"
RD /S /Q "%USERPROFILE%\��� ���������\��� �������"
RD /S /Q "%USERPROFILE%\��� ���������\��� �����������"
XCOPY "%USERPROFILE%\������� ����" "D:\������� ����" /S /I /Q /H /K /O /Y
XCOPY "%USERPROFILE%\��� ���������" "D:\��� ���������" /S /I /Q /H /K /O /Y
MD "D:\������� ����"
MD "D:\��� ���������"
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Desktop /t REG_SZ /d "D:\������� ����" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Desktop /t REG_EXPAND_SZ /d "D:\������� ����" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Personal /t REG_SZ /d "D:\��� ���������" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Personal /t REG_EXPAND_SZ /d "D:\��� ���������" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DocFolderPaths" /v %USERNAME% /t REG_SZ /d "D:\��� ���������" /f
RD /S /Q "%USERPROFILE%\������� ����"
RD /S /Q "%USERPROFILE%\��� ���������"
PAUSE