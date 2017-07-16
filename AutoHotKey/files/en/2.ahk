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
;GroupAdd, Explorer, ahk_class #32770        ; Open/Save Dialog Box
GroupAdd, Explorer, ahk_class Progman        ; Desktop
GroupAdd, Explorer, ahk_class ExploreWClass
GroupAdd, Explorer, ahk_class WorkerW

;*********************************************************************
;*                  end of the auto-execute section                  *
;*********************************************************************

~#Home::        Suspend, Off
~#End::         Suspend, On


; Win+C to open cmd in current directory
#C::
        If WinActive("ahk_group Explorer")
        {
            dir = %A_Desktop%
            WinHWND := WinActive()
            For win in ComObjCreate("Shell.Application").Windows
                If (win.HWND = WinHWND) {
                    dir := SubStr(win.LocationURL, 9) ; remove "file:///"
                    dir := RegExReplace(dir, "%20", " ")
                    Break
                }
            Run, cmd, % dir
        }
        Else 
            Run, cmd, D:\Workspace
Return


; Explorer group
#IfWinActive ahk_group Explorer
!Down::         Send, {Enter}
!Right::        Send, {Enter}

!WheelUp::      Send, !{Up}
!WheelDown::    Send, {Enter}

+WheelUp::      Send, +{Up}
+WheelDown::    Send, +{Down}

; Alt+D to put the cursor into the address bar 
!D::
        ControlFocus, ToolbarWindow322
        Send, {Space}
Return

; Shift+N to open selected file with Notepad++
+N::
        ClipSaved := ClipBoardAll
        ClipBoard =
        Send, ^{SC02e}
        ClipWait, 0.2
        If ErrorLevel = 0
            Run, "%A_ProgramFiles%\Notepad++\notepad++.exe" `"%ClipBoard%`"
        ClipBoard := ClipSaved
        ClipSaved =  ; free memory
Return

; Shift+S open selected file with Sublime Text 3
;+S::
;        ClipSaved := ClipBoardAll
;        ClipBoard =
;        Send, ^{SC02e}
;        ClipWait, 0.2
;        If ErrorLevel = 0
;            Run, "%A_ProgramFiles%\Sublime Text 3\sublime_text.exe" `"%ClipBoard%`"
;        ClipBoard := ClipSaved
;        ClipSaved =   ; free memory
;Return

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

; Shift+C to copy paths of selected files
+C::
        Send, ^{SC02e}
        Sleep, 50
        Clipboard := Clipboard
Return

; Shift+x to copy path of current dir
+X::
        Gosub, GetCurrentPath
        ClipBoard = % fullPath
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

; require ASCI format to remove russian prefix "(^Адрес: )"
GetCurrentPath:
        WinGetText, text, A
        StringSplit, pathArray, text, `r`n
        fullPath = %pathArray1%
        fullPath := RegExReplace(fullPath, "(^Address: )", "")
        fullPath := RegExReplace(fullPath, "(^Адрес: )", "")
Return
