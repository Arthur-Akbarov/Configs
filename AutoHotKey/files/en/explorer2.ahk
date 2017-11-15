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

workspace =
If FileExist("settings.ini")
    IniRead, workspace, settings.ini, Section1, workspace
; MsgBox, , DEBUG, workspace = "%workspace%"

RegRead, conemu, HKLM, SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\ConEmu64.exe
; MsgBox, , DEBUG, conemu = "%conemu%"

RegRead, subl, HKCU, Software\Classes\Applications\sublime_text.exe\shell\open\command
subl := CutUnquotedExe(subl)
; MsgBox, , DEBUG, subl = "%subl%"

RegRead, notepad, HKCU, Software\Classes\Applications\notepad++.exe\shell\open\command
notepad := CutUnquotedExe(notepad)
; MsgBox, , DEBUG, notepad = "%notepad%"

txtEditor := GetDefaultAppForExt("txt")
; MsgBox, , DEBUG, txtEditor = "%txtEditor%"

; *********************************************************************
; *                  end of the auto-execute section                  *
; *********************************************************************

; Win+End to suspend all scripts, Win+Home to rise back, Ctrl+Win+End to close
~#Home::        Suspend, Off
~#End::         Suspend, On
~^#End::        ExitApp

; Win+I to get info about active window
#I::
    WinGet, id, ID, A
    WinGetClass, class, A
    WinGetTitle, title, A
    dir := GetCurrentDirPath()
    WinGetText, text, A
    MsgBox, id = "%id%"`nclass = "%class%"`ntitle = "%title%"`ndir = "%dir%"`ntext:`n%text%
Return

; Win+C to open cmd in current directory or ConEmu if installed
#C::
    If WinActive("ahk_group Explorer")
        dir := GetCurrentDirPath()
    Else
        dir := workspace

    If !dir
        dir := A_Desktop

    If conemu
        Run, %conemu% -Dir "%dir%" -run {Shells::cmd}
    Else
        Run, cmd, % dir
Return


; Explorer group
#IfWinActive ahk_group Explorer
; Alt+E to open selected files with your txt editor
!E::
    If txtEditor
        OpenSelectedFilesBy(txtEditor)
Return

; Alt+N to open selected files with Notepad++
!N::
    If notepad
        OpenSelectedFilesBy(notepad)
Return

; Alt+S to open selected files with Sublime Text 3
!S::
    If subl
        OpenSelectedFilesBy(subl)
Return

; Alt+C to copy paths of selected files or current folder path if no files are selected
; hold Shift to wrap each path in quotes
!C::
+!C::
    ; try to copy paths of selected files
    Clipboard =
    Send, ^{SC02E}  ; Ctrl+C
    ClipWait, 0.2

    ; copy current folder path if none selected
    If ErrorLevel
        ClipBoard := GetCurrentDirPath()

    GetKeyState, state, Shift
    If (state = "D")  ; D for Down
    {
        ; join paths by space and wrap each in quotes
        StringReplace, Clipboard, Clipboard, `r`n, " ", All
        Clipboard = "%Clipboard%"
    }
    Else
    {
        ; join paths by space
        StringReplace, Clipboard, Clipboard, `r`n, %A_Space%, All
        Clipboard := Clipboard
    }
Return

; https://gist.github.com/davejamesmiller/1965432
; Ctrl+Alt+N to create new file and open files with certain extensions, including none
^!N::
    path := GetCurrentDirPath()
    ; MsgBox, , DEBUG, path = "%path%"

    SetWorkingDir, %path%
    If ErrorLevel
        Return

    InputBox, UserInput, New File (example: foo.txt), , , 400, 100
    If ErrorLevel
        Return

    FileAppend, , %UserInput%
    If ErrorLevel
        Return

    ; open at once the newly created file in Open/Save Dialog Box
    If WinActive("ahk_class #32770")
    {
        ControlFocus, Edit1, A
        Send, %UserInput%
        Sleep, 100
        Send, {Enter}
        Return
    }

    pos = -1
    StringGetPos, pos, UserInput, `., R
    If (pos != -1 && pos != 0)
    {
        ext := SubStr(UserInput, pos + 2, StrLen(UserInput) - pos - 1)
        arr := ["txt", "ahk", "cmd", "go", "java", "reg"]
        If !HasVal(arr, ext)
            Return
    }

    ; MsgBox, , DEBUG, %txtEditor% "%path%\%UserInput%"
    Run, %txtEditor% "%path%\%UserInput%"
Return


; Win+E from not Explorer window to expand and open (selected path or MyComputer in error)
#IfWinNotActive ahk_group Explorer
#E::
    ClipSaved := ClipBoardAll
    ClipBoard =
    Send, ^{SC02E}  ; Ctrl+C
    ClipWait, 0.2
    If ErrorLevel
        Run, explorer =, , Max
    Else
    {
        ClipBoard := ExpandEnvironmentVariables(ClipBoard)

        IfExist %ClipBoard%
            Run, explorer /select`, %ClipBoard%, , Max
        Else
            Run, explorer =, , Max
    }
    ClipBoard := ClipSaved
    ClipSaved =  ; free memory
Return
; for debug purpose C:\Windows\System32\drivers\etc\hosts    %AppData%\Microsoft

; *********************************************************************
; *                     functions and subroutines                     *
; *********************************************************************

GetCurrentDirPath() {
    local path

    WinGetText, text, A
    ; MsgBox, , DEBUG, % text

    infoArray := StrSplit(text , "`r`n")

    ; occasionally such odd behavior
    If (infoArray.MaxIndex() = 2)
    && (infoArray[1] = "FolderView")
        Return A_Desktop

    WinGetClass, class, A
    ; MsgBox, , DEBUG, class = "%class%"

    If (class = "WorkerW")
    || (class = "Progman")
    || (class = "Button")
        Return A_Desktop

    If (class = "#32770")  ; Open/Save Dialog Box
    {
        path := infoArray[infoArray.MaxIndex() - 1]
        ; MsgBox, , DEBUG, path = "%path%"

        ; ".{5}" stands for Russian "Адрес" in cp1251 encoding
        path := RegExReplace(path, "^(Address|.{5}): ")

        ; ".{7} .{4}" stands for Russian "Рабочий стол" in cp1251 encoding
        path := RegExReplace(path, "^(Desktop|.{7} .{4})$", A_Desktop)

        ; MsgBox, , DEBUG, regexed path = "%path%"
        Return path
    }

    path := infoArray[1]
    ; MsgBox, , DEBUG, path = "%path%"

    ; ".{5}" stands for Russian "Адрес" in cp1251 encoding
    path := RegExReplace(path, "^(Address|.{5}): ")

    ; MsgBox, , DEBUG, regexed path = "%path%"
    Return path
}

OpenSelectedFilesBy(editor) {
    local ClipSaved

    ClipSaved := ClipBoardAll
    ClipBoard =
    Send, ^{SC02E}  ; Ctrl+C
    ClipWait, 0.2
    If !ErrorLevel
    {
        StringReplace, Clipboard, Clipboard, `r`n, " ", All
        Run, %editor% `"%ClipBoard%`"
    }
    ClipBoard := ClipSaved
    ClipSaved =  ; free memory
}

; https://autohotkey.com/board/topic/54927-regread-associated-program-for-a-file-extension/#post_id_344863
GetDefaultAppForExt(extension) {
    local type, act, command, exePath

    userApp := GetUserChoiceAppForExt(extension)
    If userApp
        command := userApp
    Else
    {
        ; MsgBox, , DEBUG, get default settings

        RegRead, type, HKCR, .%extension%
        If ErrorLevel
            Return
        ; MsgBox, , DEBUG, type = "%type%"

        RegRead, act, HKCR, %type%\shell
        If !act
            act = open

        RegRead, command, HKCR, %type%\shell\%act%\command
        If ErrorLevel
            Return
    }
    ; MsgBox, , DEBUG, command = "%command%"

    exePath := ExpandEnvironmentVariables(CutUnquotedExe(command))
    ; MsgBox, , DEBUG, clipped exePath = "%exePath%"

    IfExist, %exePath%
        Return exePath
}

GetUserChoiceAppForExt(extension) {
    local type, classesEntry, act, command

    ; MsgBox, , DEBUG, get user overridden settings

    RegRead, type, HKCU, Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.%extension%\UserChoice, Progid
    If ErrorLevel
        Return
    ; MsgBox, , DEBUG, type = "%type%"

    RegRead, classesEntry, HKCU, Software\Classes\%type%
    If !ErrorLevel
        type := classesEntry
    ; MsgBox, , DEBUG, classesEntry = "%classesEntry%"

    RegRead, act, HKCU, Software\Classes\%type%\shell
    If ErrorLevel
        act = open

    RegRead, command, HKCU, Software\Classes\%type%\shell\%act%\command
        Return command
}

; duplicated in google.ahk
CutUnquotedExe(command) {
    local pos = InStr(command, ".exe")

    If !pos
        Return

    If (SubStr(command, 1, 1) = """")
        Return SubStr(command, 2, pos + 2)

    Return SubStr(command, 1, pos + 3)
}

ExpandEnvironmentVariables(src) {
    local dest

    VarSetCapacity(dest, 2000)
    DllCall("ExpandEnvironmentStrings", "str", src, "str", dest, int, 128, "Cdecl int")
    Return dest
}

; https://autohotkey.com/boards/viewtopic.php?p=109617&sid=a057c8ab901a3ab88f6304b71729c892#p109617
HasVal(haystack, needle) {
    local index, value

    For index, value in haystack
        If (value = needle)
            Return index

    If !IsObject(haystack)
        Throw Exception("Bad haystack!", -1, haystack)
}
