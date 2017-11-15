; getPathOfActiveProgram

; easy way
#NumPad3::
    WinGet, path, ProcessPath, A
    MsgBox, % path
Return

; hard way
#NumPad2::
    pid = 0
    WinGet, hWnd,, A
    DllCall("GetWindowThreadProcessId", "UInt", hWnd, "UInt *", pid)
    hProcess := DllCall("OpenProcess",  "UInt", 0x400 | 0x10, "Int", False, "UInt", pid)
    PathLength = 260*2
    VarSetCapacity(FilePath, PathLength, 0)
    DllCall("Psapi.dll\GetModuleFileNameExW", "UInt", hProcess, "Int", 0
            , "Str", FilePath, "UInt", PathLength)
    DllCall("CloseHandle", "UInt", hProcess)
    MsgBox, % FilePath
Return
