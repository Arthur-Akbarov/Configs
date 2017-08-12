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

EnvGet, drive, SystemDrive

subl =
IfExist %drive%\Program Files\Sublime Text 3\sublime_text.exe
    subl = %drive%\Program Files\Sublime Text 3\sublime_text.exe
Else
    IfExist %drive%\Program Files (x86)\Sublime Text 3\sublime_text.exe
        subl = %drive%\Program Files (x86)\Sublime Text 3\sublime_text.exe

notepad =
IfExist %drive%\Program Files\Notepad++\notepad++.exe
    notepad = %drive%\Program Files\Notepad++\notepad++.exe
Else
    IfExist %drive%\Program Files (x86)\Notepad++\notepad++.exe
        notepad = %drive%\Program Files (x86)\Notepad++\notepad++.exe

conemu =
IfExist %drive%\Program Files\ConEmu\ConEmu64.exe
    conemu = %drive%\Program Files\ConEmu\ConEmu64.exe
Else
    IfExist %drive%\Program Files (x86)\ConEmu\ConEmu.exe
        conemu = %drive%\Program Files (x86)\ConEmu\ConEmu.exe
    Else
        IfExist %drive%\Program Files\ConEmu\ConEmu.exe
            conemu = %drive%\Program Files\ConEmu\ConEmu.exe
;*********************************************************************
;*                  end of the auto-execute section                  *
;*********************************************************************

; Win+End to suspend all scripts, Win+Home to rise back, Ctrl+Win+End to close
~#Home::        Suspend, Off
~#End::         Suspend, On
~^#End::        ExitApp


; Win+C to open conemu or cmd in current directory
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
        }
        Else
            dir = D:\Workspace

        If conemu
            Run, %conemu% -Dir "%dir%" -run {Shells::cmd}
        Else
            Run, cmd, % dir
Return


#IfWinActive ahk_group Explorer
!Down::         Send, {Enter}
!Right::        Send, {Enter}

!WheelUp::      Send, !{Up}
!WheelDown::    Send, {Enter}

+WheelUp::      Send, +{Up}
+WheelDown::    Send, +{Down}

; Alt+N to open selected file with Notepad++
!N::
        If notepad
        {
            ClipSaved := ClipBoardAll
            ClipBoard =
            Send, ^{SC02e}
            ClipWait, 0.2
            If ErrorLevel = 0
            {
                Run, %notepad% `"%ClipBoard%`"
                WinWait ahk_class Notepad++
            }
            ClipBoard := ClipSaved
            ClipSaved =  ; free memory
        }
Return

; Alt+S open selected file with Sublime Text 3
!S::
        If subl
        {
            ClipSaved := ClipBoardAll
            ClipBoard =
            Send, ^{SC02e}
            ClipWait, 0.2
            If ErrorLevel = 0
                Run, %subl% `"%ClipBoard%`"
            ClipBoard := ClipSaved
            ClipSaved =  ; free memory
        }
Return
