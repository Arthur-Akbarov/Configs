#NoEnv          ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn           ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force        ; Replace older instance of this script with newer one

; ^ Ctrl, ! Alt, + Shift, # Win

;Run %A_ScriptDir%\2.ahk 

RegRead, OutputVar, HKEY_CLASSES_ROOT, http\shell\open\command
StringReplace, OutputVar, OutputVar, "
SplitPath, OutputVar, , OutDir, , OutNameNoExt, OutDrive
browser = %OutDir%\%OutNameNoExt%.exe

NumLock::     Return
^NumLock::    Return
!NumLock::    Return
+NumLock::    Return

CapsLock::    MouseClick Left
^CapsLock::   Return
!CapsLock::   Edit %A_ScriptFullPath%
+CapsLock::   Return

Insert::      Return

#+S::         Run nircmd-x64\nircmd.exe speak text ~$clipboard$
#+A::         Run nircmd-x64\nircmd.exe win center alltop

#Esc::        Run nircmd-x64\nircmd.exe monitor off

#WheelUp::    Run nircmd-x64\nircmd.exe changesysvolume 4000
#WheelDown::  Run nircmd-x64\nircmd.exe changesysvolume -4000

#+Up::        Run nircmd-x64\nircmd.exe changesysvolume 4000
#+Down::      Run nircmd-x64\nircmd.exe changesysvolume -4000

>^NumPad1::   Run nircmd-x64\nircmd.exe changesysvolume -4000
>^NumPad2::   Run nircmd-x64\nircmd.exe changesysvolume 4000

#^+Up::       Run nircmd-x64\nircmd.exe mutesysvolume 0
#^+Down::     Run nircmd-x64\nircmd.exe mutesysvolume 1

>^NumPad5::   Run nircmd-x64\nircmd.exe mutesysvolume 0
>^NumPad4::   Run nircmd-x64\nircmd.exe mutesysvolume 1

#+Right::     Run nircmd-x64\nircmd.exe changebrightness +4
#+left::      Run nircmd-x64\nircmd.exe changebrightness -12

#^+Right::    Run nircmd-x64\nircmd.exe setbrightness 100
#^+left::     Run nircmd-x64\nircmd.exe setbrightness 0

!+A::   Send arthur.akbarov@yandex.ru

^#A::   WinSet, AlwaysOnTop, toggle, A

#S::    WinRestore, A
#A::    WinMaximize, A
#W::    WinMinimize, A
#Q::    WinClose, A

; Ctrl+Win+F to force set active windows full screen and borderless
^#F::
        WinSet, Style, -0xC40000, A
        WinMove, A, , 0, 0, 1292, 770
Return

^'::
        prevClipboard = %clipboard%
        Send ^{SC02e}
        Send '^{SC02f}'
        Sleep 50
        clipboard = %prevClipboard%
Return

^@::
^"::
        prevClipboard = %clipboard%
        Send ^{SC02e}
        Send "^{SC02f}"
        Sleep 50
        clipboard = %prevClipboard%
Return

^%::
        prevClipboard = %clipboard%
        Send ^{SC02e}
        Send `%^{SC02f}`%
        Sleep 50
        clipboard = %prevClipboard%
Return

^(::
^)::
        prevClipboard = %clipboard%
        Send ^{SC02e}
        Send (^{SC02f})
        Sleep 50
        clipboard = %prevClipboard%
Return

; Win+C to open cmd in current directory
#C::
        if WinActive("ahk_group Explorer") {
            dir = %A_Desktop%
            WinHWND := WinActive()
            For win in ComObjCreate("Shell.Application").Windows
                If (win.HWND = WinHWND) {
                    dir := SubStr(win.LocationURL, 9) ; remove "file:///"
                    dir := RegExReplace(dir, "%20", " ")
                    Break
                }
            Run, cmd, % dir
        } else 
            Run, cmd, D:\Workspace
Return

#G::
        BlockInput, on
        prevClipboard = %clipboard%
        clipboard =
        Send ^{SC02e}
        BlockInput, off
        ClipWait, 2
        if ErrorLevel = 0
        {
            searchQuery = %clipboard%
            Gosub GoogleSearch
        }
        clipboard = %prevClipboard%
Return

GoogleSearch:
        StringReplace, searchQuery, searchQuery, `r`n, %A_Space%, All
        Loop
        {
            noExtraSpaces = 1
            StringLeft, leftMost, searchQuery, 1
            IfInString, leftMost, %A_Space%
            {
                StringTrimLeft, searchQuery, searchQuery, 1
                noExtraSpaces=0
            }

            StringRight, rightMost, searchQuery, 1
            IfInString, rightMost, %A_Space%
            {
                StringTrimRight, searchQuery, searchQuery, 1
                noExtraSpaces=0
            }

            If (noExtraSpaces = 1)
                Break
        }

        StringReplace, searchQuery, searchQuery, \, `%5C, All
        StringReplace, searchQuery, searchQuery, %A_Space%, +, All
        StringReplace, searchQuery, searchQuery, `%, `%25, All

        IfInString, searchQuery, .
        {
            IfInString, searchQuery, +
                Run http://www.google.com/search?q=%searchQuery%
            Else
                Run %searchQuery%
        }
        Else
            Run http://www.google.com/search?q=%searchQuery%
Return


;
; program sensitive
;


; Google Chrome
#IfWinActive ahk_class Chrome_WidgetWin_1
; Alt+C to reopen active page from google cache
!C::
        Send !{SC020}
        Sleep 50
        BlockInput, on
        prevClipboard = %clipboard%
        clipboard =
        Send ^{SC02e}
        BlockInput, off
        ClipWait, 2
        if ErrorLevel = 0
        {
            ; Send ^{SC02f}
            ; Sleep 100
            ; Send {Enter}
            Send ^w
            searchQuery = http://webcache.googleusercontent.com/search?q=cache:%clipboard%
            Gosub GoogleSearch
        }
        clipboard = %prevClipboard%
Return


; Windows Photo Viewer
#IfWinActive ahk_class Photo_Lightweight_Viewer
WheelUp::       Send {left}
WheelDown::     Send {Right}


; cmd
#IfWinActive ahk_class ConsoleWindowClass
^+C::       Send {Enter}
^V::        Send %clipboard%
!F4::       WinClose A
MButton::   Send {Enter}
PgUp::      Send {WheelUp 10}
PgDn::      Send {WheelDown 10}


; MinGW
#IfWinActive ahk_class mintty
^+C::       Send {Ctrl}{Insert}
^V::        Send %clipboard%


; save and update script in notepad
#IfWinActive ahk_class Notepad
^+S::
        IfWinActive, %A_ScriptName%
        {
            Send ^S
            ToolTip Script is updating
            Sleep 700
            Reload
        }
Return


; save and update script in Sublime Text 3
#IfWinActive ahk_class PX_WINDOW_CLASS
^+S::      Gosub SaveAndReload


; save and update script in Notepad++
#IfWinActive ahk_class Notepad++
^+S::       Gosub SaveAndReload

SaveAndReload:
        WinGetActiveTitle, title
        IfInString, title, %A_ScriptFullPath%
        {
            Send ^s
            ToolTip Script is updating
            Sleep 700
            Reload
        }
Return
