; not working with ahk_class #32770 - Open/Save Dialog Box
GetCurrentDirPath() {
        WinHWND := WinActive()
        For win in ComObjCreate("Shell.Application").Windows
            If (win.HWND = WinHWND)
            {
                result := SubStr(win.LocationURL, 9)  ; remove "file:///"
                result := RegExReplace(result, "%20", " ")
                Return result
            }
}

; require cp-1251 encoding to remove Russian prefix "Адрес: "
GetCurrentDirPath() {
        local path

        WinGetText, text, A
        ; MsgBox, , Debug, % text

        infoArray := StrSplit(text , "`r`n")

        WinGetClass, class, A
        ; MsgBox, , Debug, % class

        If (class = "WorkerW")
            Return A_Desktop

        If (class = "#32770")
            path := infoArray[infoArray.MaxIndex() - 1]
        Else
            path := infoArray[1]

        ; MsgBox, , Debug, % path
        Return RegExReplace(path, "(Address|Адрес): ")
}
