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

; Win+End to suspend all scripts, Win+Home to rise back, Ctrl+Win+End to close
~#Home::        Suspend, Off
~#End::         Suspend, On
~^#End::        ExitApp

; Win+G to search selected text in google
#G::
        ClipSaved := ClipBoardAll
        ClipBoard =
        Send, ^{SC02e}
        ClipWait, 0.2
        If ErrorLevel = 0
        {
            searchQuery = %ClipBoard%
            Gosub, GoogleSearch
        }
        ClipBoard := ClipSaved
        ClipSaved =  ; free memory
Return


; Google Chrome
#IfWinActive ahk_class Chrome_WidgetWin_1
; Alt+C to reopen active page from google cache
!C::
        Send, !{SC020}
        Sleep, 50
        ClipSaved := ClipBoardAll
        ClipBoard =
        Send, ^{SC02e}
        ClipWait, 0.2
        If ErrorLevel = 0
        {
            Send, ^w
            searchQuery = http://webcache.googleusercontent.com/search?q=cache:%ClipBoard%
            Gosub, GoogleSearch
        }
        ClipBoard := ClipSaved
        ClipSaved =  ; free memory
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
            IfInString, searchQuery, +
                Run, http://www.google.com/search?q=%searchQuery%
            Else
                Run, %searchQuery%
        Else
            Run, http://www.google.com/search?q=%searchQuery%
Return
