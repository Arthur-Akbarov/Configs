; getBrowserPathFromRegisrty

; using SplitPath
RegRead, command, HKCR, http\shell\open\command
StringReplace, command, command, "
SplitPath, command, , dir, , name, drive
If dir
    name = %dir%\%name%
browser = %name%.exe
MsgBox, , DEBUG, browser = "%browser%"


; using CutUnquotedExe
RegRead, command, HKCR, http\shell\open\command
browser := CutUnquotedExe(command)
MsgBox, , DEBUG, browser = "%browser%"

CutUnquotedExe(command) {
    local pos = InStr(command, ".exe")

    If !pos
        Return

    If (SubStr(command, 1, 1) = """")
        Return SubStr(command, 2, pos + 2)

    Return SubStr(command, 1, pos + 3)
}
