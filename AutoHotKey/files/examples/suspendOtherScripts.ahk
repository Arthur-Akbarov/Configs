;*********************************************************************
;*                  start of the auto-execute section                *
;*********************************************************************

Process, Exist
myPid := ErrorLevel
DetectHiddenWindows, On

;*********************************************************************
;*                  end of the auto-execute section                  *
;*********************************************************************

; Ctrl+Win+End to suspend all other scripts
^#End::
        ;myPid := DllCall("GetCurrentProcessId")
        myId := WinExist("ahk_pid " . myPid)
        WinGet, id, list, ahk_class AutoHotkey
        Loop, %id%
        {
            nextId := id%A_Index%
            If (nextId <> myId)
                PostMessage, 0x111, 65404,,, ahk_id %nextId%
        }
Return
