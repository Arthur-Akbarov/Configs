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

#+Ы::
#+S::         Run nircmd-x64\nircmd.exe speak text ~$clipboard$
#+Ф::
#+A::         Run nircmd-x64\nircmd.exe win center alltop

#Esc::        Run nircmd-x64\nircmd.exe monitor off

#WheelUp::    Run nircmd-x64\nircmd.exe changesysvolume 4000
#WheelDown::  Run nircmd-x64\nircmd.exe changesysvolume -4000

#+up::        Run nircmd-x64\nircmd.exe changesysvolume 4000
#+down::      Run nircmd-x64\nircmd.exe changesysvolume -4000

#^+up::       Run nircmd-x64\nircmd.exe mutesysvolume 0
#^+down::     Run nircmd-x64\nircmd.exe mutesysvolume 1

#+right::     Run nircmd-x64\nircmd.exe changebrightness +4
#+left::      Run nircmd-x64\nircmd.exe changebrightness -12

#^+right::    Run nircmd-x64\nircmd.exe setbrightness 100
#^+left::     Run nircmd-x64\nircmd.exe setbrightness 0

!+ф::
!+a::         Send, arthur.akbarov@yandex.ru

; does not work with non-Latin layout
; https://autohotkey.com/board/topic/75964-bug-copypasting-when-keyboard-layout-is-non-latin/
#п::
#g::
        clipboardOld=%clipboard%
        Send ^c
        Clipwait
        Run https://www.google.com/search?q=%clipboard%
        clipboard=%clipboardOld%
return

^(::
^)::
        Send, {ctrl down}c{ctrl up}
        Send, ({ctrl down}v{ctrl up})
return

#ы::
#s::    WinRestore,A
#ф::
#a::    WinMaximize,A
#ц::
#w::    WinMinimize,A
#й::
#q::    WinClose,A


;
; program sensitive
;

; работает не только на видео youtube, но и всякий раз при закрытии вкладки и т.п.
; #IfWinActive ahk_class Chrome_WidgetWin_1
; MButton::
;         Send f
;         Send {MButton}
; #IfWinActive


; windows photo viewer
#IfWinActive ahk_class Photo_Lightweight_Viewer
WheelUp::     Send {left}
WheelDown::   Send {right}
#IfWinActive


; explorer
#IfWinActive ahk_exe explorer.exe
!down::       Send {enter}
!right::      Send {enter}

CapsLock & WheelUp::     Send {up}
CapsLock & WheelDown::   Send {down}

!WheelUp::    Send !{up}
!WheelDown::  Send {enter}

+WheelUp::    Send +{up}
+WheelDown::  Send +{down}

MButton::     Send {enter}
#IfWinActive


; should be in the auto-execute section
; GroupAdd, Explorer, ahk_class CabinetWClass
; GroupAdd, Explorer, ahk_class ExploreWClass
; GroupAdd, Explorer, ahk_class Progman
; GroupAdd, Explorer, ahk_class WorkerW


; https://gist.github.com/davejamesmiller/1965432
; ctrl+alt+n to create and open new file in explorer
#IfWinActive ahk_class CabinetWClass
^!т::
^!n::
        WinGetText, text, A

        StringSplit, pathArray, text, `r`n
        fullPath = %pathArray1%
        fullPath := RegExReplace(fullPath, "(^Address: )", "")

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
^+С::
^+C::         Send {enter}
^М::
^V::          Send %clipboard%
!f4::         WinClose,A
MButton::     Send {enter}
PgUp::        send {WheelUp 10}
PgDn::        send {WheelDown 10}
#IfWinActive


; save and update script, doesn't work in sublime text
^+ы::
^+s::
IfWinActive, %A_ScriptName%
{
        Send, ^s
        ToolTip, Scr ipt is updating
        Sleep, 700
        Reload
}
return
