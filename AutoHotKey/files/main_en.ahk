; reminder ^ Ctrl, ! Alt, + Shift, # Win, >^ RightCtrl, <! LeftAlt, ` escape character

;*********************************************************************
;*                  start of the auto-execute section                *
;*********************************************************************

#NoEnv          ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn           ; Enables warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force        ; Forced replacement older instance of this script with newer one.

GroupAdd, Editors, ahk_class PX_WINDOW_CLASS  ; Sublime Text 3
GroupAdd, Editors, ahk_class Notepad++        ; Notepad++

; run all scripts in appropriate folder
lang := SubStr(A_ScriptName, 6, 2)
Loop %A_ScriptDir%\%lang%\*.ahk
    Run, %A_LoopFileFullPath%

RegRead, command, HKCR, AutoHotkeyScript\Shell\Edit\Command
StringReplace, command, command, "
SplitPath, command, , dir, , name, drive
If dir
    name = %dir%\%name%
ahkEditor = %name%.exe
;MsgBox, , DEBUG, ahkEditor = "%ahkEditor%"

;*********************************************************************
;*                  end of the auto-execute section                  *
;*********************************************************************

; Win+End to suspend all scripts, Win+Home to rise back, Ctrl+Win+End to close
~#Home::        Suspend, Off
~#End::         Suspend, On
~^#End::        ExitApp

; Ctrl+Win+L to log off
^#L::Shutdown, 0

; RightCtrl+NumPad7 to edit all scripts
>^NumPad7::
        Run, %ahkEditor% %A_ScriptFullPath%
        Loop %A_ScriptDir%\%lang%\*.ahk
            Run, %ahkEditor% %A_LoopFileFullPath%
Return

; RightCtrl+NumPad8 to reload all scripts
>^NumPad8::     Reload

; Ctrl+Shift+S to save current and update all scripts while working with anyone
#IfWinActive ahk_class Notepad                ; in notepad.exe
^+S::
        IfWinActive, %A_ScriptName%
            Gosub, SaveAndReload
Return

#IfWinActive ahk_group Editors                ; in Sublime Text 3 and Notepad++
^+S::
        WinGetActiveTitle, title
        IfInString, title, %A_ScriptDir%
            Gosub, SaveAndReload
Return


;*********************************************************************
;*                     functions and subroutines                     *
;*********************************************************************

SaveAndReload:
        Send, ^{SC01f}
        ToolTip, Scripts are updating
        Sleep, 500
        Reload
Return
