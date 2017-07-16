#NoEnv          ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn           ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ^ Ctrl, ! Alt, + Shift, # Windows

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

; should be in the auto-execute section
; GroupAdd, Explorer, ahk_class CabinetWClass
; GroupAdd, Explorer, ahk_class ExploreWClass
; GroupAdd, Explorer, ahk_class Progman
; GroupAdd, Explorer, ahk_class WorkerW

; explorer
;#IfWinActive ahk_exe explorer.exe
#IfWinActive ahk_class CabinetWClass
!Down::       Send {Enter}
!Right::      Send {Enter}

CapsLock & WheelUp::     Send {Up}
CapsLock & WheelDown::   Send {Down}

!WheelUp::    Send !{Up}
!WheelDown::  Send {Enter}

+WheelUp::    Send +{Up}
+WheelDown::  Send +{Down}

MButton::     Send {Enter}

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



^1::
^h::
^t::
        WinGet, Win_pid, PID, A
        PostMessage, 0x111, 28717,0,, ahk_pid %Win_pid%      ;"Thumbnails" (h) (t)
return

^2::
^s::
        WinGet, Win_pid, PID, A
        PostMessage, 0x111, 28718,0,, ahk_pid %Win_pid%      ;"Tiles" (s)
return

^3::
^n::
^i::
^m::
        WinGet, Win_pid, PID, A
        PostMessage, 0x111, 28713,0,, ahk_pid %Win_pid%      ;"Icons" (n) (i) (m = Medium icon view)
return

^4::
^l::
        WinGet, Win_pid, PID, A
        PostMessage, 0x111, 28715,0,, ahk_pid %Win_pid%      ;"List" (l)
return

^d::
        MouseGetPos,x,y,winid,ctrlid,2
        ControlGet,listview,Hwnd,,,ahk_id %ctrlid%
        Loop
        {
            listview:=DllCall("GetParent","UInt",listview)
            If listview=0
                Break
            SendMessage,0x111,0x702c,0,,ahk_id %listview%
        }
return

*F5::
MouseGetPos,x,y,winid,ctrlid,2
Sleep,0
WM_COMMAND=0x111
ODM_VIEW_ICONS =0x7029
ODM_VIEW_LIST  =0x702b
ODM_VIEW_DETAIL=0x702c
ODM_VIEW_THUMBS=0x702d
ODM_VIEW_TILES =0x702e
views=%ODM_VIEW_ICONS%,%ODM_VIEW_LIST%,%ODM_VIEW_DETAIL%,%ODM_VIEW_THUMBS%,%ODM_VIEW_TILES%
StringSplit,view_,views,`,
view+=1
If view>5
  view=1
changeview:=view_%view%
MsgBox %views%, %view%, %changeview%
ControlGet,listview,Hwnd,,,ahk_id %ctrlid%
parent:=listview
Loop
{
  parent:=DllCall("GetParent","UInt",parent)
  If parent=0
    Break
  SendMessage,%WM_COMMAND%,%changeview%,0,,ahk_id %parent%
}
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
