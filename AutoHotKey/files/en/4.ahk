; reminder ^ Ctrl, ! Alt, + Shift, # Win, >^ RightCtrl, <! LeftAlt, ` escape character

;*********************************************************************
;*                  start of the auto-execute section                *
;*********************************************************************

#NoEnv          ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn           ; Enables warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force        ; Forced replacement older instance of this script with newer one.
#NoTrayIcon

;*********************************************************************
;*                  end of the auto-execute section                  *
;*********************************************************************

~#Home::        Suspend, Off
~#End::         Suspend, On

; Win+E to open selected path in explorer and MyComputer in error
#E::
        ClipSaved := ClipBoardAll
        ClipBoard =
        Send, ^{SC02e}
        ClipWait, 0.2
        If ErrorLevel
            Run, explorer =, ,max
        Else
            ;Run, cmd /C If exist %ClipBoard% (start /max explorer /select`, %ClipBoard% ) else (start /max explorer =), , hide
            IfExist %ClipBoard%
                Run, explorer /select`, %ClipBoard%, , max
            Else 
                Run, explorer =, ,max
        ClipBoard := ClipSaved
        ClipSaved =  ; free memory
Return
; for debug purpose C:\Windows\System32\drivers\etc\hosts


; Windows Photo Viewer
#IfWinActive ahk_class Photo_Lightweight_Viewer
WheelUp::       Send, {Left}
WheelDown::     Send, {Right}


; cmd
#IfWinActive ahk_class ConsoleWindowClass
^+C::           Send, {Enter}
^V::            Send, {Raw}%ClipBoard%  ; whithout {Row} plus sign will be missed
!F4::           WinClose, A
MButton::       Send, {Enter}
PgUp::          Send, {WheelUp 10}
PgDn::          Send, {WheelDown 10}


; MinGW
#IfWinActive ahk_class mintty
^+C::           Send, {Ctrl}{Insert}
^V::            Send, {Raw}%ClipBoard%  ; whithout {Row} plus sign will be missed


; Open/Save Dialog Box
#IfWinActive ahk_class #32770
; Ctrl+MouseMiddleButton to display menu with opened explorer windows
^MButton::
        WinGet, winId, ID, a
        WinGetClass, f_class, a
        For pwb in ComObjCreate("Shell.Application").Windows
            If InStr(pwb.FullName, "explorer.exe") && InStr(pwb.LocationURL, "file:///")
            {
                Menu, CurrentLocations, Add, % pwb.document.folder.self.path, Navigate
                Menu, CurrentLocations, Icon, % pwb.document.folder.self.path, %A_WinDir%\system32\imageres.dll, 4
            }
        Menu, CurrentLocations, UseErrorLevel
        Menu, CurrentLocations, Show
        If ErrorLevel
        {
            ToolTip, No folders open
            SetTimer, RemoveToolTip, 1000
        }
        Menu, CurrentLocations, Delete
Return

Navigate:
        If A_ThisMenuItem =
            Return
        WinActivate, ahk_id %winId%
        Send, !{d}
        Sleep, 50
        ControlGetFocus, addressBar, A
        ControlSetText, %addressBar%, %A_ThisMenuItem%, A
        ControlSend, %addressBar%, {Enter}, A
        ControlFocus, Edit1, A
Return

RemoveToolTip:
        SetTimer, RemoveToolTip, Off
        ToolTip
Return
