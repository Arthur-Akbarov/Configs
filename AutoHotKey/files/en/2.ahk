; reminder ^ Ctrl, ! Alt, + Shift, # Win, >^ RightCtrl, <! LeftAlt, ` escape character

; *********************************************************************
; *                  start of the auto-execute section                *
; *********************************************************************

#NoEnv          ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn           ; Enables warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force        ; Forced replacement older instance of this script with newer one.
#NoTrayIcon

GroupAdd, Console, ahk_class ConsoleWindowClass  ; cmd
GroupAdd, Console, ahk_class VirtualConsoleClass ; Conemu
GroupAdd, Console, ahk_class mintty              ; Git Bash
GroupAdd, Console, ahk_class PuTTY

; *********************************************************************
; *                  end of the auto-execute section                  *
; *********************************************************************

; Win+End to suspend all scripts, Win+Home to rise back, Ctrl+Win+End to close
~#Home::        Suspend, Off
~#End::         Suspend, On
~^#End::        ExitApp


; Windows Photo Viewer
#IfWinActive ahk_class Photo_Lightweight_Viewer
J::             Send, {Left}
L::             Send, {Right}
; it is necessary to implement this feature in scrollInactiveWindow.ahk, if last is used
WheelUp::       Send, {Left}
WheelDown::     Send, {Right}


; Console group
#IfWinActive ahk_group Console
^+C::           Send, {Enter}           ; Send, {Ctrl}{Insert}
^V::            Send, {Raw}%ClipBoard%  ; without {Row} plus sign '+' will be missed
!F4::           WinClose, A
^MButton::      Send, {Enter}
PgUp::          Send, {WheelUp 10}
PgDn::          Send, {WheelDown 10}


; R Workspace
#IfWinActive ahk_class Rgui Workspace
MButton::      Send, {Enter}


; Open/Save Dialog Box
#IfWinActive ahk_class #32770
; MiddleClick to display context menu of currently opened folders with opportunity to navigate by click
MButton::
    WinGet, winId, ID, A
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

; *********************************************************************
; *                     functions and subroutines                     *
; *********************************************************************

Navigate:
    If !A_ThisMenuItem
        Return
    WinActivate, ahk_id %winId%
    Send, !{SC03F}  ; Alt+D
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
