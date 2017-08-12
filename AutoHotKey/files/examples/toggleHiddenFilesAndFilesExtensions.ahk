; This is part of my AutoHotKey [1] script that allows me to toggle hidden files
; with Ctrl+Alt+H and file extensions with Ctrl+Alt+E.

; It's tested in Windows 7 and should work in Windows Vista too, but I'm not
; sure about anything older than that. If not, see the original scripts on How-
; To Geek for some extra code that I removed.

; Sources:
; - http://www.howtogeek.com/howto/keyboard-ninja/keyboard-ninja-toggle-hidden-files-with-a-shortcut-key-in-windows/
; - http://www.howtogeek.com/howto/windows-vista/keyboard-ninja-toggle-file-extension-display-with-a-shortcut-key-in-windows/

; [1]: http://www.autohotkey.com/


; Only run when Windows Explorer is active
#IfWinActive ahk_class CabinetWClass

; Ctrl+Alt+H - Toggle hidden files
^!h::
    RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden
    If HiddenFiles_Status = 2
        RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
    Else
        RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2
    Send, {F5}
    Return

; Ctrl+Alt+E - Toggle extensions
^!e::
    RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt
    If HiddenFiles_Status = 1
        RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 0
    Else
        RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 1
    Send, {F5}
    Return

#IfWinActive
