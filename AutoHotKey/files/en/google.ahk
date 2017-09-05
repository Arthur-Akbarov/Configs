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

;*********************************************************************
;*                  end of the auto-execute section                  *
;*********************************************************************

; Win+End to suspend all scripts, Win+Home to rise back, Ctrl+Win+End to close
~#Home::        Suspend, Off
~#End::         Suspend, On
~^#End::        ExitApp

;Win+T to translate selected text by Google Translate
#T::
        ClipSaved := ClipBoardAll
        ClipBoard =
        Send, ^{SC02e}
        ClipWait, 0.2
        If ErrorLevel = 0
            Run, https://translate.google.ru/#en/ru/%ClipBoard%
        ClipBoard := ClipSaved
        ClipSaved =  ; free memory
Return

; Win+G to search selected text in google
#G::
        ClipSaved := ClipBoardAll
        ClipBoard =
        Send, ^{SC02e}
        ClipWait, 0.2
        If ErrorLevel = 0
            GoogleSearch(ClipBoard)
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
            Run, http://webcache.googleusercontent.com/search?q=cache:%ClipBoard%
        }
        ClipBoard := ClipSaved
        ClipSaved =  ; free memory
Return


;*********************************************************************
;*                     functions and subroutines                     *
;*********************************************************************

GoogleSearch(searchQuery) {
        searchQuery := Trim(searchQuery)

        If InStr(searchQuery, "http://") = 1
        || InStr(searchQuery, "https://") = 1
        {
            Run, %searchQuery%
            Return
        }

        If !InStr(searchQuery, " ")
        && InStr(searchQuery, ".")
        {
            Run, http://%searchQuery%
            Return
        }

        searchQuery := RegExReplace(searchQuery, "\s+", " ")
        Run, http://www.google.com/search?q=%searchQuery%
}
; for debug purpose https://ya.ru
