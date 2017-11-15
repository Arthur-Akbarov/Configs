@echo remove ad placeholders in Skype
@echo close Skype in advance
@echo off
:: sources
:: http://www.winhelponline.com/blog/block-skype-ads-windows/
:: https://stackoverflow.com/questions/17054275/changing-tag-data-in-an-xml-file-using-windows-batch-file
:: https://gist.github.com/joielechong/d0042338fd3132013aec4ee56045e558

setlocal EnableDelayedExpansion

(for /F "delims=" %%a in (%AppData%\Skype\arthur.akbarov\config.xml) do (
   set "line=%%a"
   set "newLine=!line:<AdvertPlaceholder>=!"
   if "!newLine!" neq "!line!" (
      set "newLine=<AdvertPlaceholder>0</AdvertPlaceholder>"
   )
   echo !newLine!
)) > %AppData%\Skype\arthur.akbarov\config2.xml

echo 127.0.0.1 apps.skype.com>>C:\Windows\System32\drivers\etc\hosts

start C:\Windows\System32\drivers\etc\hosts
start %AppData%\Skype\arthur.akbarov\config2.xml
