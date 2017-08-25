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

RegRead, notepad, HKLM, Software\Notepad++
If notepad
    notepad = %notepad%\notepad++.exe

txtEditor := GetDefaultAppForExt("txt")

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

        If !InStr(UserInput, ".")

        pos =
        StringGetPos, pos, UserInput, `., R
        If (pos != -1) {
            ext := SubStr(UserInput, pos + 2, StrLen(UserInput) - pos - 1)
            arr := ["txt", "ahk", "cmd", "go", "java"]
            If HasVal(arr, ext)
                Run, %txtEditor% %path%\%UserInput%
        }
        Else
            Run, %txtEditor% %path%\%UserInput%
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
        ClipSaved := ClipBoardAll
        ClipBoard =
        Send, ^{SC02e}
        ClipWait, 0.2
        If ErrorLevel = 0
        {
            StringReplace, Clipboard, Clipboard, `r`n, `" `", All
            Run, %editor% `"%ClipBoard%`", , , pid
            WinActivate, ahk_pid %pid%
        }
        ClipBoard := ClipSaved
        ClipSaved =  ; free memory
}

; https://autohotkey.com/board/topic/54927-regread-associated-program-for-a-file-extension/#post_id_344863
GetDefaultAppForExt(ext) {
        local pos

        RegRead, type, HKCU, Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.%ext%\UserChoice, Progid
        If ErrorLevel
        {
            ; default setting
            RegRead, type, HKCR, .%ext%
            RegRead, act , HKCR, %type%\shell
            If ErrorLevel
                act = open
            RegRead, cmd , HKCR, %type%\shell\%act%\command
        }
        Else {
            ; current user has overridden default setting
            RegRead, act, HKCU, Software\Classes\%type%\shell
            If ErrorLevel
                act = open
            RegRead, cmd, HKCU, Software\Classes\%type%\shell\%act%\command
        }

        pos := InStr(cmd, ".exe""")
        If pos
            cmd := SubStr(cmd, 1, pos + 4)
        Else
            cmd := SubStr(cmd, 1, InStr(cmd, ".exe") + 3)

        Return cmd
}

; https://autohotkey.com/boards/viewtopic.php?p=109617&sid=a057c8ab901a3ab88f6304b71729c892#p109617
HasVal(haystack, needle) {
    For index, value in haystack
        If (value = needle)
            Return index

    If !(IsObject(haystack))
        Throw Exception("Bad haystack!", -1, haystack)

    Return 0
}
