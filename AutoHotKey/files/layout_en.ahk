#NoEnv          ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn           ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

NumLock::     return
^NumLock::    return
!NumLock::    return
+NumLock::    return

CapsLock::    return
^CapsLock::   return
!CapsLock::   return
+CapsLock::   return

Insert::      return

#+S::         Run nircmd-x64\nircmd.exe speak text ~$clipboard$
#+A::         Run nircmd-x64\nircmd.exe win cEnter alltop

#Esc::        Run nircmd-x64\nircmd.exe monitor off

#WheelUp::    Run nircmd-x64\nircmd.exe changesysvolume 4000
#WheelDown::  Run nircmd-x64\nircmd.exe changesysvolume -4000

#+Up::        Run nircmd-x64\nircmd.exe changesysvolume 4000
#+Down::      Run nircmd-x64\nircmd.exe changesysvolume -4000

#^+Up::       Run nircmd-x64\nircmd.exe mutesysvolume 0
#^+Down::     Run nircmd-x64\nircmd.exe mutesysvolume 1

#+Right::     Run nircmd-x64\nircmd.exe changebrightness +4
#+left::      Run nircmd-x64\nircmd.exe changebrightness -12

#^+Right::    Run nircmd-x64\nircmd.exe setbrightness 100
#^+left::     Run nircmd-x64\nircmd.exe setbrightness 0

!+A::         Send, arthur.akbarov@yandex.ru

; does not work with non-latin layout
; https://autohotkey.com/board/topic/75964-bug-copypasting-when-keyboard-layout-is-non-latin/
#G::
        clipboardOld=%clipboard%
        Send ^C
        Clipwait
        Run https://www.google.com/search?q=%clipboard%
        clipboard=%clipboardOld%
return

^(::
^)::
        Send, {Ctrl Down}c{Ctrl Up}
        Send, ({Ctrl Down}v{Ctrl Up})
return

#S::    WinRestore,A
#A::    WinMaximize,A
#W::    WinMinimize,A
#Q::    WinClose,A

;
; program sensitive
;

; triggered not only on youtube video but during closing tab
; #IfWinActive ahk_class Chrome_WidgetWin_1
; MButton::
;         Send F
;         Send {MButton}
; #IfWinActive


; windows photo viewer
#IfWinActive ahk_class Photo_Lightweight_Viewer
WheelUp::     Send {left}
WheelDown::   Send {Right}
#IfWinActive


; explorer
#IfWinActive ahk_exe explorer.exe
!Down::       Send {Enter}
!Right::      Send {Enter}

CapsLock & WheelUp::     Send {Up}
CapsLock & WheelDown::   Send {Down}

!WheelUp::    Send !{Up}
!WheelDown::  Send {Enter}

+WheelUp::    Send +{Up}
+WheelDown::  Send +{Down}

MButton::     Send {Enter}
#IfWinActive


; should be in the auto-execute section
; GroupAdd, Explorer, ahk_class CabinetWClass
; GroupAdd, Explorer, ahk_class ExploreWClass
; GroupAdd, Explorer, ahk_class Progman
; GroupAdd, Explorer, ahk_class WorkerW


#IfWinActive ahk_class CabinetWClass
#C::
        WinHWND := WinActive()
        For win in ComObjCreate("Shell.Application").Windows
            If (win.HWND = WinHWND) {
                dir := SubStr(win.LocationURL, 9) ; remove "file:///"
                dir := RegExReplace(dir, "%20", " ")
                Break
            }
        Run, cmd, % dir ? dir : A_Desktop
return
; https://gist.github.com/davejamesmiller/1965432
; Ctrl+Alt+N to create and open new file in explorer
^!N::
        WinGetText, text, A
        StringSplit, pathArray, text, `r`n
        fullPath = %pathArray1%
        fullPath := RegExReplace(fullPath, "(^Address: )", "")
        fullPath := RegExReplace(fullPath, "(^Адрес: )", "")

        SetWorkingDir, %fullPath%

        if ErrorLevel
            return

        InputBox, UserInput, New File (example: foo.txt), , , 400, 100

        If ErrorLevel
            return

        FileAppend, , %UserInput%
        ; Run %UserInput%
return
#IfWinActive


; cmd
#IfWinActive ahk_class ConsoleWindowClass
^+C::         Send {Enter}
^M::          Send %clipboard%
!F4::         WinClose,A
MButton::     Send {Enter}
PgUp::        Send {WheelUp 10}
PgDn::        Send {WheelDown 10}
#IfWinActive


; MinGW
#IfWinActive  ahk_class mintty
^+C::         Send {Ctrl}{Insert}
^V::          Send %clipboard%
#IfWinActive


; save and update script
; work only with default text editor - notepad
^+S::
IfWinActive, %A_ScriptName%
{
        Send, ^S
        ToolTip, Script is updating
        Sleep, 700
        Reload
}
return
