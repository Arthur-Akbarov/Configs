@echo pull and apply hosts file config from local configs repo
@echo off

set dir=%SystemRoot%\System32\drivers\etc
set name=hosts
set file=%dir%\%name%

copy "files\%name%" "%file%" 12>nul
if %ErrorLevel% == 0 (
	goto :eof
)

echo It works only with disabled UAC.
echo You may copy hosts manually.

setlocal EnableDelayedExpansion
if not exist "%dir%" (
	echo Folder "%dir%" can't be found.
	choice /m "Create it"
	if !ErrorLevel! == 2 (
		goto :eof
	)
	if !ErrorLevel! == 1 (
		mkdir "%dir%"
		if ErrorLevel 1 (
			echo Can't create folder "%dir%".
			pause & goto :eof
		)
	)
)

choice /m "Open %dir%"
if %ErrorLevel% == 1 (
	explorer "%dir%"
)
