
; is haystack contain any element of needle
InStrGrp(haystack, needle)
{
        needles := StrSplit(needle, "|")

        Loop, % needles.Length()
            If InStr(haystack, needles[A_Index])
                Return true

        Return false
}

ExpandEnvironmentVariables(src)
{
        VarSetCapacity(dest, 2000)
        DllCall("ExpandEnvironmentStrings", "str", src, "str", editor, int, 128, "Cdecl int")
        Return dest
}