; reminder ^ Ctrl, ! Alt, + Shift, # Win, >^ RightCtrl, <! LeftAlt, ` escape character

;*********************************************************************
;*                  start of the auto-execute section                *
;*********************************************************************

#NoEnv          ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn           ; Enables warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force        ; Forced replacement older instance of this script with newer one.
#NoTrayIcon

GroupAdd, Explorer, ahk_class CabinetWClass  ; Standard Windows Explorer window
GroupAdd, Explorer, ahk_class #32770         ; Open/Save Dialog Box
GroupAdd, Explorer, ahk_class Progman        ; Desktop
GroupAdd, Explorer, ahk_class ExploreWClass
GroupAdd, Explorer, ahk_class WorkerW

RegRead, conemu, HKCU, Software\ConEmu, DefTerm-ConEmuExe

;*********************************************************************
;*                  end of the auto-execute section                  *
;*********************************************************************

; Win+End to suspend all scripts, Win+Home to rise back, Ctrl+Win+End to close
~#Home::        Suspend, Off
~#End::         Suspend, On
~^#End::        ExitApp

; Win+C to open ConEmu or cmd in current directory
#C::
        If WinActive("ahk_group Explorer")
        {
            dir := GetCurrentDirPath()
            If !dir
                dir = %A_Desktop%
        }
        Else
            dir = D:\Workspace

        If conemu
            Run, %conemu% -Dir "%dir%" -run {Shells::cmd}
        Else
            Run, cmd, % dir
Return


; Explorer group
#IfWinActive ahk_group Explorer
; Alt+D to put the cursor into the address bar
!D::
        ControlFocus, ToolbarWindow322
        Send, {Space}
Return

; Ctrl+S to set list view
^S::
        MouseGetPos, x, y, winid, ctrlid,2
        ControlGet, listview, Hwnd, , , ahk_id %ctrlid%
        Loop
        {
            listview := DllCall("GetParent", "UInt", listview)
            If listview = 0
                Break
            WM_COMMAND = 0x111
            ODM_VIEW_LIST = 0x702b
            SendMessage, WM_COMMAND, ODM_VIEW_LIST, 0, , ahk_id %listview%
        }
Return

; Ctrl+D to set detail view
^D::
        MouseGetPos, x, y, winid, ctrlid,2
        ControlGet, listview, Hwnd, , , ahk_id %ctrlid%
        Loop
        {
            listview := DllCall("GetParent", "UInt", listview)
            If listview = 0
                Break
            WM_COMMAND = 0x111
            ODM_VIEW_DETAIL = 0x702c
            SendMessage, WM_COMMAND, ODM_VIEW_DETAIL, 0, , ahk_id %listview%
        }
Return

; Ctrl+E to set icons view
^E::
        MouseGetPos, x, y, winid, ctrlid,2
        ControlGet, listview, Hwnd, , , ahk_id %ctrlid%
        Loop
        {
            listview := DllCall("GetParent", "UInt", listview)
            If listview = 0
                Break
            WM_COMMAND = 0x111
            FVM_EXTRALARGE = 0x704d
            SendMessage, WM_COMMAND, FVM_EXTRALARGE, 0, , ahk_id %listview%
        }
Return

; Alt+C to copy paths of selected files or current folder if none selected
!C::
        ; try to copy paths of selected files
        Clipboard =
        Send, ^{SC02e}
        ClipWait, 0.2
        
        ; copy current folder path if none selected
        If ErrorLevel
            ClipBoard := GetCurrentDirPath()
        
        ; wrap every path in quotes
        StringReplace, Clipboard, Clipboard, `r`n, `" `", All
        Clipboard = "%Clipboard%"
Return


;*********************************************************************
;*                     functions and subroutines                     *
;*********************************************************************

; require cp-1251 encoding to remove Russian prefix "(^Адрес: )"
GetCurrentDirPath() {
        WinHWND := WinActive()
            For win in ComObjCreate("Shell.Application").Windows
                If (win.HWND = WinHWND) {
                    result := SubStr(win.LocationURL, 9)  ; remove "file:///"
                    result := RegExReplace(result, "%20", " ")
                    Return result
                }
}
