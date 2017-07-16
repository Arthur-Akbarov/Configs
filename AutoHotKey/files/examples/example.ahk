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

; get default browser path into var 'browser'
RegRead, OutputVar, HKEY_CLASSES_ROOT, http\shell\open\command
StringReplace, OutputVar, OutputVar, "
SplitPath, OutputVar, , OutDir, , OutNameNoExt, OutDrive
browser = %OutDir%\%OutNameNoExt%.exe

;*********************************************************************
;*                  end of the auto-execute section                  *
;*********************************************************************

; spell check or substitution by whole word
::achievment::achievement
::btw::by the way

; * for instant substitution
:*:acheiv::achiev

; Win+I to open url in default browser
#I::            Run, http://www.google.com/

; Alt+CapsLock to edit this script with default ahk editor
!CapsLock::     Edit, %A_ScriptFullPath%

#NumPad2::      MsgBox %A_ScriptFullPath%
#NumPad5::      Reload
#Numpad9::      ExitApp

; Ctrl+J
^J::
        MsgBox Wow!
        MsgBox this is
        Run, Notepad.exe
        winactivate, Untitled - Notepad
        WinWaitActive, Untitled - Notepad
        Send, 7 lines{!}{enter}
        Sendinput, inside the ctrl{+}j hotkey
Return

; Ctrl+Win+F to set active window full screen and borderless
^#F::
        WinSet, Style, -0xC40000, A
        WinMove, A, , 0, 0, 1292, 770
Return

; Win+NumPad1 to get info about active window
#NumPad1::
        WinGet, aId, ID, A                  ; get active window id
        WinGetClass, aClass, A              ; get active class
        WinGetTitle, aTitle, A              ; get active window title
        WinGetActiveTitle, aTitle2
        MsgBox %aId% `n%aClass% `n%aTitle% `n%aTitle2%
Return
