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

RegRead, subl, HKCU, Software\Classes\Applications\sublime_text.exe\shell\open\command
subl := CutUnquotedExe(subl)

RegRead, notepad, HKCU, Software\Classes\Applications\notepad++.exe\shell\open\command
notepad := CutUnquotedExe(notepad)

txtEditor := GetDefaultAppForExt("txt")
;MsgBox, , DEBUG, txtEditor = "%txtEditor%"

;*********************************************************************
;*                  end of the auto-execute section                  *
;*********************************************************************

; Win+End to suspend all scripts, Win+Home to rise back, Ctrl+Win+End to close
~#Home::        Suspend, Off
~#End::         Suspend, On
~^#End::        ExitApp


; Explorer group
#IfWinActive ahk_group Explorer
!Down::         Send, {Enter}
!Right::        Send, {Enter}

!WheelUp::      Send, !{Up}
!WheelDown::    Send, {Enter}

+WheelUp::      Send, +{Up}
+WheelDown::    Send, +{Down}

; https://gist.github.com/davejamesmiller/1965432
; Ctrl+Alt+N to create new file and open files with certain extensions
^!N::
        path := GetCurrentDirPath()
        SetWorkingDir, %path%
        If ErrorLevel
            Return

        InputBox, UserInput, New File (example: foo.txt), , , 400, 100
        If ErrorLevel
            Return

        FileAppend, , %UserInput%
        If ErrorLevel
            Return

        pos = -1
        StringGetPos, pos, UserInput, `., R
        If (pos != -1 && pos != 0)
        {
            ext := SubStr(UserInput, pos + 2, StrLen(UserInput) - pos - 1)
            arr := ["txt", "ahk", "cmd", "go", "java", "reg"]
            If !HasVal(arr, ext)
                Return
        }

        ;MsgBox, , Debug, %txtEditor% "%path%\%UserInput%"
        Run, %txtEditor% "%path%\%UserInput%"
Return

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

; Win+E to expand and open selected path in explorer or open MyComputer in error
#IfWinNotActive ahk_class CabinetWClass
#E::
        ClipSaved := ClipBoardAll
        ClipBoard =
        Send, ^{SC02e}
        ClipWait, 0.2
        If ErrorLevel
            Run, explorer =, ,max
        Else
        {
            ClipBoard := ExpandEnvironmentVariables(ClipBoard)

            IfExist %ClipBoard%
                Run, explorer /select`, %ClipBoard%, , max
            Else
                Run, explorer =, ,max
        }
        ClipBoard := ClipSaved
        ClipSaved =  ; free memory
Return
; for debug purpose C:\Windows\System32\drivers\etc\hosts    %AppData%\Microsoft


;*********************************************************************
;*                     functions and subroutines                     *
;*********************************************************************

; require cp-1251 encoding to remove Russian prefix "(^Адрес: )"
GetCurrentDirPath() {
        WinGetText, text, A
        StringSplit, pathArray, text, `r`n
        Return RegExReplace(pathArray1, "(^(Adress|Адрес): )", "")
}

OpenSelectedFilesBy(editor) {
        local ClipSaved

        ClipSaved := ClipBoardAll
        ClipBoard =
        Send, ^{SC02e}
        ClipWait, 0.2
        If ErrorLevel = 0
        {
            StringReplace, Clipboard, Clipboard, `r`n, `" `", All
            Run, %editor% `"%ClipBoard%`", , , pid
        }
        ClipBoard := ClipSaved
        ClipSaved =  ; free memory
}

; https://autohotkey.com/board/topic/54927-regread-associated-program-for-a-file-extension/#post_id_344863
GetDefaultAppForExt(ext) {
        local type, act, command, exePath

        userApp := GetUserChoiceAppForExt(ext)
        If userApp
            command := userApp
        Else
        {
            ;MsgBox, , DEBUG, get default settings

            RegRead, type, HKCR, .%ext%
            If ErrorLevel
                Return
            ;MsgBox, , DEBUG, type = %type%

            RegRead, act, HKCR, %type%\shell
            If !act
                act = open

            RegRead, command, HKCR, %type%\shell\%act%\command
            If ErrorLevel
                Return
        }
        ;MsgBox, , DEBUG, command = %command%

        exePath := ExpandEnvironmentVariables(CutUnquotedExe(command))
        ;MsgBox, , DEBUG, clipped exePath = %exePath%

        IfExist, %exePath%
            Return exePath
}

GetUserChoiceAppForExt(ext) {
        local type, ClassesEntry, act, command

        ;MsgBox, , DEBUG, get user overridden settings

        RegRead, type, HKCU, Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.%ext%\UserChoice, Progid
        If ErrorLevel
            Return
        ;MsgBox, , DEBUG, type = %type%

        RegRead, ClassesEntry, HKCU, Software\Classes\%type%
        If !ErrorLevel
            type := ClassesEntry
        ;MsgBox, , DEBUG, ClassesEntry = %ClassesEntry%

        RegRead, act, HKCU, Software\Classes\%type%\shell
        If ErrorLevel
            act = open

        RegRead, command, HKCU, Software\Classes\%type%\shell\%act%\command
            Return command
}

CutUnquotedExe(command) {
        local pos = InStr(command, ".exe")

        If !pos
            Return

        If SubStr(command, 1, 1) = """"
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
