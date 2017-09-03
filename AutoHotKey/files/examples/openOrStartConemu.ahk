; invoke ConEmu hotkey error tooltip
; Alt+` to open ConEmu or start if it is running
!`::
        DetectHiddenWindows, On
        WinGet, id, list, ahk_class VirtualConsoleClass
        If id
        {
            wID := id1
            WinGet, pname, , ahk_id %wID%
            ControlSend, , ^``, ahk_id %wID%
        }
        Else
        {
            Run, %conemu% -Dir "D:\Workspace" -run {Shells::cmd},,, pid
            WinWait, ahk_pid %pid%
            WinActivate, ahk_pid %pid%
         }
Return
