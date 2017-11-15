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

GroupAdd, Explorer, ahk_class CabinetWClass  ; Explorer
GroupAdd, Explorer, ahk_class ExploreWClass  ; Explorer before Vista
GroupAdd, Explorer, ahk_class #32770         ; Open/Save Dialog Box
GroupAdd, Explorer, ahk_class WorkerW        ; Desktop after Win+D
GroupAdd, Explorer, ahk_class Progman        ; Desktop after mouse click
GroupAdd, Explorer, ahk_class Button         ; Desktop after minimize window

; *********************************************************************
; *                  end of the auto-execute section                  *
; *********************************************************************

; Win+End to suspend all scripts, Win+Home to rise back, Ctrl+Win+End to close
~#Home::        Suspend, Off
~#End::         Suspend, On
~^#End::        ExitApp


; Explorer group
#IfWinActive ahk_group Explorer
; standard Explorer shortcuts https://technet.microsoft.com/en-us/library/ee851673.aspx
; Alt+Down to navigate into folder
!Down::         Send, {Enter}

; RightAlt+Up redirect to LeftAlt+Up because of accidental problem
>!Up::          Send, <!{Up}

; Alt+Wheel to navigate into and up folder
!WheelUp::      Send, !{Up}
!WheelDown::    Send, {Enter}

; Shift+Wheel for multiple selection
+WheelUp::      Send, +{Up}
+WheelDown::    Send, +{Down}

; Alt+D to put the cursor into the address bar
!D::
    ControlFocus, ToolbarWindow322
    Send, {Space}
Return

; Ctrl+S to set list view
^S::
    MouseGetPos, x, y, winid, ctrlid, 2
    ControlGet, listview, Hwnd, , , ahk_id %ctrlid%
    Loop
    {
        listview := DllCall("GetParent", "UInt", listview)
        If (listview = 0)
            Break
        WM_COMMAND = 0x111
        ODM_VIEW_LIST = 0x702b
        SendMessage, WM_COMMAND, ODM_VIEW_LIST, 0, , ahk_id %listview%
    }
Return

; Ctrl+D to set detail view
^D::
    MouseGetPos, x, y, winid, ctrlid, 2
    ControlGet, listview, Hwnd, , , ahk_id %ctrlid%
    Loop
    {
        listview := DllCall("GetParent", "UInt", listview)
        If (listview = 0)
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
        If (listview = 0)
            Break
        WM_COMMAND = 0x111
        FVM_EXTRALARGE = 0x704d
        SendMessage, WM_COMMAND, FVM_EXTRALARGE, 0, , ahk_id %listview%
    }
Return
