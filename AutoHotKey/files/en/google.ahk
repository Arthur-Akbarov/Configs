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

RegRead, chrome, HKLM, SOFTWARE\Classes\ChromeHTML\shell\open\command
chrome := CutUnquotedExe(chrome)
; MsgBox, , DEBUG, chrome = "%chrome%"

; *********************************************************************
; *                  end of the auto-execute section                  *
; *********************************************************************

; Win+End to suspend all scripts, Win+Home to rise back, Ctrl+Win+End to close
~#Home::        Suspend, Off
~#End::         Suspend, On
~^#End::        ExitApp

; Win+T to translate selected text by Google Translate
; hold Shift to use Chrome incognito mode
#T::
+#T::
    ClipSaved := ClipBoardAll
    ClipBoard =
    Send, ^{SC02E}  ; Ctrl+C
    ClipWait, 0.2

    If RegExMatch(ClipBoard, "[a-zA-z]")
        OpenUrl("https://translate.google.ru/#en/ru/" . ClipBoard)
    Else
        OpenUrl("https://translate.google.ru/#ru/en/" . ClipBoard)

    ClipBoard := ClipSaved
    ClipSaved =  ; free memory
Return

; Win+G to search selected text in Google
; hold Shift to use Chrome incognito mode
#G::
+#G::
    ClipSaved := ClipBoardAll
    ClipBoard =
    Send, ^{SC02E}  ; Ctrl+C
    ClipWait, 0.2

    If !ErrorLevel
        GoogleSearch(ClipBoard)
    Else
        OpenUrl("https://google.ru")

    ClipBoard := ClipSaved
    ClipSaved =  ; free memory
Return


; Google Chrome
#IfWinActive ahk_class Chrome_WidgetWin_1
; Alt+C to reopen active page from Google cache, hold Shift to use Chrome incognito mode
!C::
+!C::
    Send, !{SC020}  ; Alt+D
    Sleep, 50
    ClipSaved := ClipBoardAll
    ClipBoard =
    Send, ^{SC02E}  ; Ctrl+C
    ClipWait, 0.2
    If !ErrorLevel
    {
        Send, ^{SC011}  ; Ctrl+W
        OpenUrl("http://webcache.googleusercontent.com/search?q=cache:" . ClipBoard)
    }
    ClipBoard := ClipSaved
    ClipSaved =  ; free memory
Return

; *********************************************************************
; *                     functions and subroutines                     *
; *********************************************************************

GoogleSearch(searchQuery) {
    local url

    searchQuery := Trim(searchQuery)
    searchQuery := StrReplace(searchQuery, "#", "%23")

    If (InStr(searchQuery, "http://") = 1)
    || (InStr(searchQuery, "https://") = 1)
        Return OpenUrl(searchQuery)

    If !InStr(searchQuery, " ")
    && !InStr(searchQuery, "(")
    && !InStr(searchQuery, ")")
    && InStr(searchQuery, ".")
        Return OpenUrl("http://" . searchQuery)

    searchQuery := RegExReplace(searchQuery, "\s+", " ")
    searchQuery := StrReplace(searchQuery, """", """""""")

    OpenUrl("http://www.google.com/search?q=" . searchQuery)
}
; for debug purpose https://ya.ru

OpenUrl(url) {
    global chrome

    ; MsgBox, , DEBUG, url = "%url%"
    ; Return

    If !chrome
    {
         Run, "%url%"
         Return
    }

    GetKeyState, state, Shift
    If (state = "D")
        Run, %chrome% --incognito "%url%", , Max
    Else
        Run, %chrome% "%url%", , Max
}

; duplicated in explorer2.ahk
CutUnquotedExe(command) {
    local pos = InStr(command, ".exe")

    If !pos
        Return

    If (SubStr(command, 1, 1) = """")
        Return SubStr(command, 2, pos + 2)

    Return SubStr(command, 1, pos + 3)
}
