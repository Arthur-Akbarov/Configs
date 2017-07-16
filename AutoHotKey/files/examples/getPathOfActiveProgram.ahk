; easy way to get path of active window program
#NumPad3::
        WinGet, Path, ProcessPath, A
        MsgBox, %Path%
Return

; hard way to get path of active window program
#NumPad2::
    PID = 0
    WinGet, hWnd,, A
    DllCall("GetWindowThreadProcessId", "UInt", hWnd, "UInt *", PID)
    hProcess := DllCall("OpenProcess",  "UInt", 0x400 | 0x10, "Int", False
                                     ,  "UInt", PID)
    PathLength = 260*2
    VarSetCapacity(FilePath, PathLength, 0)
    DllCall("Psapi.dll\GetModuleFileNameExW", "UInt", hProcess, "Int", 0
                                 , "Str", FilePath, "UInt", PathLength)
    DllCall("CloseHandle", "UInt", hProcess)
    MsgBox, %FilePath%
Return