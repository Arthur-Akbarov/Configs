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

GroupAdd, Explorer, ahk_class CabinetWClass  ; Standart Windows Explorer window
GroupAdd, Explorer, ahk_class #32770         ; Open/Save Dialog Box
GroupAdd, Explorer, ahk_class Progman        ; Desktop
GroupAdd, Explorer, ahk_class ExploreWClass
GroupAdd, Explorer, ahk_class WorkerW

;*********************************************************************
;*                  end of the auto-execute section                  *
;*********************************************************************

; Win+End to suspend all scripts, Win+Home to rise back, Ctrl+Win+End to close
~#Home::        Suspend, Off
~#End::         Suspend, On
~^#End::        ExitApp


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
            ODM_VIEW_ICONS = 0x702a
            SendMessage, WM_COMMAND, ODM_VIEW_ICONS, 0, , ahk_id %listview%
        }
Return

; Alt+C to copy paths of selected files or current folder if no selected
!C::
        Clipboard =
        Send, ^{SC02e}
        ClipWait, 0.2
        If ErrorLevel
        {
            Gosub, GetCurrentPath
            ClipBoard = % fullPath
        }
        Else
            Clipboard := Clipboard
Return

; https://gist.github.com/davejamesmiller/1965432
; Ctrl+Alt+N to create and open new file in explorer
^!N::
        Gosub, GetCurrentPath
        SetWorkingDir, %fullPath%

        If ErrorLevel
            Return

        InputBox, UserInput, New File (example: foo.txt), , , 400, 100

        If ErrorLevel
            Return

        FileAppend, , %UserInput%
        ; Run, %UserInput%
Return

; require ASCI format to remove russian prefix "(^јдрес: )"
GetCurrentPath:
        WinGetText, text, A
        StringSplit, pathArray, text, `r`n
        fullPath = %pathArray1%
        fullPath := RegExReplace(fullPath, "(^Address: )", "")
        fullPath := RegExReplace(fullPath, "(^јдрес: )", "")
Return
