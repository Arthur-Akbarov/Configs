#NoEnv          ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn           ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ^ Ctrl, ! Alt, + Shift, # Windows

GroupAdd, Explorer, ahk_class CabinetWClass
GroupAdd, Explorer, ahk_class ExploreWClass
GroupAdd, Explorer, ahk_class Progman
GroupAdd, Explorer, ahk_class WorkerW

RegRead, OutputVar, HKEY_CLASSES_ROOT, http\shell\open\command
StringReplace, OutputVar, OutputVar, "
SplitPath, OutputVar, , OutDir, , OutNameNoExt, OutDrive
browser = %OutDir%\%OutNameNoExt%.exe
Return

NumLock::     Return
^NumLock::    Return
!NumLock::    Return
+NumLock::    Return

CapsLock::    Reload
^CapsLock::   Return
!CapsLock::   Return
+CapsLock::   Return

Insert::      Return

#+Ы::         Run nircmd-x64\nircmd.exe speak text ~$clipboard$
#+Ф::         Run nircmd-x64\nircmd.exe win center alltop

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

!+Ф::         Send arthur.akbarov@yandex.ru

; Ctrl+Win+F to force set active windows full screen and borderless
^#А::
        WinSet, Style, -0xC40000, A
        WinMove, A, , 0, 0, 1680, 1050
Return

#П::
        BlockInput, on
        prevClipboard = %clipboard%
        clipboard =
        Send ^{SC02e}
        BlockInput, off
        ClipWait, 2
        if ErrorLevel = 0
        {
            searchQuery = %clipboard%
            Gosub GoogleSearch
        }
        clipboard = %prevClipboard%
Return

GoogleSearch:
        StringReplace, searchQuery, searchQuery, `r`n, %A_Space%, All
        Loop
        {
            noExtraSpaces = 1
            StringLeft, leftMost, searchQuery, 1
            IfInString, leftMost, %A_Space%
            {
                StringTrimLeft, searchQuery, searchQuery, 1
                noExtraSpaces=0
            }

            StringRight, rightMost, searchQuery, 1
            IfInString, rightMost, %A_Space%
            {
                StringTrimRight, searchQuery, searchQuery, 1
                noExtraSpaces=0
            }

            If (noExtraSpaces = 1)
                Break
        }

        StringReplace, searchQuery, searchQuery, \, `%5C, All
        StringReplace, searchQuery, searchQuery, %A_Space%, +, All
        StringReplace, searchQuery, searchQuery, `%, `%25, All

        IfInString, searchQuery, .
        {
            IfInString, searchQuery, +
                Run http://www.google.com/search?q=%searchQuery%
            Else
                Run %searchQuery%
        }
        Else
            Run http://www.google.com/search?q=%searchQuery%
Return

^'::
        prevClipboard = %clipboard%
        clipboard =
        Send ^{SC02e}
        Send '^{SC02f}'
        Sleep 50
        clipboard = %prevClipboard%
Return

^@::
^"::
        prevClipboard = %clipboard%
        clipboard =
        Send ^{SC02e}
        Send "^{SC02f}"
        Sleep 50
        clipboard = %prevClipboard%
Return

^%::
        prevClipboard = %clipboard%
        clipboard =
        Send ^{SC02e}
        Send `%^{SC02f}`%
        Sleep 50
        clipboard = %prevClipboard%
Return

^(::
^)::
        prevClipboard = %clipboard%
        clipboard =
        Send ^{SC02e}
        Send (^{SC02f})
        Sleep 50
        clipboard = %prevClipboard%
Return

#Ы::    WinRestore A
#Ф::    WinMaximize A
#Ц::    WinMinimize A
#Й::    WinClose A

#NumPad9::      ExitApp


;
; program sensitive
;


; Windows Photo Viewer
#IfWinActive ahk_class Photo_Lightweight_Viewer
WheelUp::       Send {left}
WheelDown::     Send {Right}


; Explorer
#IfWinActive ahk_group Explorer
!Down::         Send {Enter}
!Right::        Send {Enter}

CapsLock & WheelUp::    Send {Up}
CapsLock & WheelDown::  Send {Down}

!WheelUp::      Send !{Up}
!WheelDown::    Send {Enter}

+WheelUp::      Send +{Up}
+WheelDown::    Send +{Down}

MButton::       Send {Enter}

!В::
    ControlFocus, ToolbarWindow322
    send {space}
Return

; Win+C to open cmd in current directory in explorer
#С::
    dir = %A_Desktop%
    WinHWND := WinActive()
    For win in ComObjCreate("Shell.Application").Windows
        If (win.HWND = WinHWND) {
            dir := SubStr(win.LocationURL, 9) ; remove "file:///"
            dir := RegExReplace(dir, "%20", " ")
            Break
        }
    Run, cmd, % dir
Return

; https://gist.github.com/davejamesmiller/1965432
; Ctrl+Alt+N to create and open new file in explorer
^!Т::
        WinGetText, text, A
        StringSplit, pathArray, text, `r`n
        fullPath = %pathArray1%
        fullPath := RegExReplace(fullPath, "(^Address: )", "")
        fullPath := RegExReplace(fullPath, "(^Адрес: )", "")

        SetWorkingDir, %fullPath%

        if ErrorLevel
            Return

        InputBox, UserInput, New File (example: foo.txt), , , 400, 100

        If ErrorLevel
            Return

        FileAppend, , %UserInput%
        ; Run %UserInput%
Return

; set list view
^Ы::
        MouseGetPos, x, y, winid, ctrlid,2
        ControlGet, listview, Hwnd, , , ahk_id %ctrlid%
        Loop
        {
            listview := DllCall("GetParent", "UInt", listview)
            If listview = 0
                Break
            WM_COMMAND = 0x111
            ODM_VIEW_LIST = 0x702b
            SendMessage, WM_COMMAND, ODM_VIEW_LIST, 0, , ahk_id %listview%
        }
Return

; set detail view
^В::
        MouseGetPos, x, y, winid, ctrlid,2
        ControlGet, listview, Hwnd, , , ahk_id %ctrlid%
        Loop
        {
            listview := DllCall("GetParent", "UInt", listview)
            If listview = 0
                Break
            WM_COMMAND = 0x111
            ODM_VIEW_DETAIL = 0x702c
            SendMessage, WM_COMMAND, ODM_VIEW_DETAIL, 0, , ahk_id %listview%
        }
Return

; set icons view
^У::
        MouseGetPos, x, y, winid, ctrlid,2
        ControlGet, listview, Hwnd, , , ahk_id %ctrlid%
        Loop
        {
            listview := DllCall("GetParent", "UInt", listview)
            If listview = 0
                Break
            WM_COMMAND = 0x111
            ODM_VIEW_ICONS = 0x702a
            SendMessage, WM_COMMAND, ODM_VIEW_ICONS, 0, , ahk_id %listview%
        }
Return


; cmd
#IfWinActive ahk_class ConsoleWindowClass
^+С::       Send {Enter}
^М::        Send %clipboard%
!F4::       WinClose A
MButton::   Send {Enter}
PgUp::      Send {WheelUp 10}
PgDn::      Send {WheelDown 10}


; MinGW
#IfWinActive ahk_class mintty
^+С::       Send {Ctrl}{Insert}
^М::        Send %clipboard%


; save and update script in notepad
#IfWinActive ahk_class Notepad
^+Ы::
        IfWinActive, %A_ScriptName%
        {
            Send ^S
            ToolTip Script is updating
            Sleep 700
            Reload
        }
Return


; save and update script in Sublime Text 3
#IfWinActive ahk_class PX_WINDOW_CLASS
^+Ы::      Gosub SaveAndReload
Return


; save and update script in Notepad++
#IfWinActive ahk_class Notepad++
^+Ы::       Gosub SaveAndReload


SaveAndReload:
        WinGetActiveTitle, title
        IfInString, title, %A_ScriptFullPath%
        {
            Send ^s
            ToolTip Script is updating
            Sleep 700
            Reload
        }
Return
#IfWinActive

#NoEnv          ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn           ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force        ; Replace older instance of this script with newer one

; ^ Ctrl, ! Alt, + Shift, # Win

GroupAdd, Explorer, ahk_class CabinetWClass
GroupAdd, Explorer, ahk_class ExploreWClass
GroupAdd, Explorer, ahk_class Progman
GroupAdd, Explorer, ahk_class WorkerW

RegRead, OutputVar, HKEY_CLASSES_ROOT, http\shell\open\command
StringReplace, OutputVar, OutputVar, "
SplitPath, OutputVar, , OutDir, , OutNameNoExt, OutDrive
browser = %OutDir%\%OutNameNoExt%.exe

NumLock::     Return
^NumLock::    Return
!NumLock::    Return
+NumLock::    Return

CapsLock::    MouseClick Left
^CapsLock::   Return
!CapsLock::   Return
+CapsLock::   Return

Insert::      Return

#+Ы::         Run nircmd-x64\nircmd.exe speak text ~$clipboard$
#+Ф::         Run nircmd-x64\nircmd.exe win center alltop

#Esc::        Run nircmd-x64\nircmd.exe monitor off

#WheelUp::    Run nircmd-x64\nircmd.exe changesysvolume 4000
#WheelDown::  Run nircmd-x64\nircmd.exe changesysvolume -4000

#+Up::        Run nircmd-x64\nircmd.exe changesysvolume 4000
#+Down::      Run nircmd-x64\nircmd.exe changesysvolume -4000

>^NumPad1::   Run nircmd-x64\nircmd.exe changesysvolume -4000
>^NumPad2::   Run nircmd-x64\nircmd.exe changesysvolume 4000

#^+Up::       Run nircmd-x64\nircmd.exe mutesysvolume 0
#^+Down::     Run nircmd-x64\nircmd.exe mutesysvolume 1

>^NumPad5::   Run nircmd-x64\nircmd.exe mutesysvolume 0
>^NumPad4::   Run nircmd-x64\nircmd.exe mutesysvolume 1

#+Right::     Run nircmd-x64\nircmd.exe changebrightness +4
#+left::      Run nircmd-x64\nircmd.exe changebrightness -12

#^+Right::    Run nircmd-x64\nircmd.exe setbrightness 100
#^+left::     Run nircmd-x64\nircmd.exe setbrightness 0

!+Ф::   Send arthur.akbarov@yandex.ru

^#Ф::   WinSet, AlwaysOnTop, toggle, A

#Ы::    WinRestore, A
#Ф::    WinMaximize, A
#Ц::    WinMinimize, A
#Й::    WinClose, A

; Ctrl+Win+F to force set active windows full screen and borderless
^#А::
        WinSet, Style, -0xC40000, A
        WinMove, A, , 0, 0, 1292, 770
Return

#П::
        BlockInput, on
        prevClipboard = %clipboard%
        clipboard =
        Send ^{SC02e}
        BlockInput, off
        ClipWait, 2
        if ErrorLevel = 0
        {
            searchQuery = %clipboard%
            Gosub GoogleSearch
        }
        clipboard = %prevClipboard%
Return

GoogleSearch:
        StringReplace, searchQuery, searchQuery, `r`n, %A_Space%, All
        Loop
        {
            noExtraSpaces = 1
            StringLeft, leftMost, searchQuery, 1
            IfInString, leftMost, %A_Space%
            {
                StringTrimLeft, searchQuery, searchQuery, 1
                noExtraSpaces=0
            }

            StringRight, rightMost, searchQuery, 1
            IfInString, rightMost, %A_Space%
            {
                StringTrimRight, searchQuery, searchQuery, 1
                noExtraSpaces=0
            }

            If (noExtraSpaces = 1)
                Break
        }

        StringReplace, searchQuery, searchQuery, \, `%5C, All
        StringReplace, searchQuery, searchQuery, %A_Space%, +, All
        StringReplace, searchQuery, searchQuery, `%, `%25, All

        IfInString, searchQuery, .
        {
            IfInString, searchQuery, +
                Run http://www.google.com/search?q=%searchQuery%
            Else
                Run %searchQuery%
        }
        Else
            Run http://www.google.com/search?q=%searchQuery%
Return

^'::
        prevClipboard = %clipboard%
        Send ^{SC02e}
        Send '^{SC02f}'
        Sleep 50
        clipboard = %prevClipboard%
Return

^@::
^"::
        prevClipboard = %clipboard%
        Send ^{SC02e}
        Send "^{SC02f}"
        Sleep 50
        clipboard = %prevClipboard%
Return

^%::
        prevClipboard = %clipboard%
        Send ^{SC02e}
        Send `%^{SC02f}`%
        Sleep 50
        clipboard = %prevClipboard%
Return

^(::
^)::
        prevClipboard = %clipboard%
        Send ^{SC02e}
        Send (^{SC02f})
        Sleep 50
        clipboard = %prevClipboard%
Return


; Win+C to open cmd in current directory
#С::
        if WinActive("ahk_group Explorer") {
            dir = %A_Desktop%
            WinHWND := WinActive()
            For win in ComObjCreate("Shell.Application").Windows
                If (win.HWND = WinHWND) {
                    dir := SubStr(win.LocationURL, 9) ; remove "file:///"
                    dir := RegExReplace(dir, "%20", " ")
                    Break
                }
            Run, cmd, % dir
        } else 
            Run, cmd, D:\Workspace
Return


;
; program sensitive
;


; Windows Photo Viewer
#IfWinActive ahk_class Photo_Lightweight_Viewer
WheelUp::       Send {left}
WheelDown::     Send {Right}


; Explorer
#IfWinActive ahk_group Explorer
!Down::         Send {Enter}
!Right::        Send {Enter}

CapsLock & WheelUp::    Send {Up}
CapsLock & WheelDown::  Send {Down}

CapsLock & RButton::    MouseClick Right
CapsLock & LButton::    Send {Down}

!WheelUp::      Send !{Up}
!WheelDown::    Send {Enter}

+WheelUp::      Send +{Up}
+WheelDown::    Send +{Down}

MButton::       Send {Enter}

!В::
        ControlFocus, ToolbarWindow322
        send {Space}
Return

; copy selected files as path
+С::
        Send ^{SC02e}
        Sleep 50
        Clipboard := Clipboard
Return

; open selected file with NotePad++
+Т::
        prevClipboard = %clipboard%
        clipboard =
        Send ^{SC02e}
        ClipWait
        Run "%A_ProgramFiles%\Notepad++\notepad++.exe" `"%clipboard%`"
        clipboard = %prevClipboard%
Return

; open selected file with Sublime Text 3
+Ы::
        prevClipboard = %clipboard%
        clipboard =
        Send ^{SC02e}
        ClipWait
        Run "%A_ProgramFiles%\Sublime Text 3\sublime_text.exe" `"%clipboard%`"
        clipboard = %prevClipboard%
Return

; https://gist.github.com/davejamesmiller/1965432
; Ctrl+Alt+N to create and open new file in explorer
^!Т::
        WinGetText, text, A
        StringSplit, pathArray, text, `r`n
        fullPath = %pathArray1%
        fullPath := RegExReplace(fullPath, "(^Address: )", "")
        fullPath := RegExReplace(fullPath, "(^Адрес: )", "")

        SetWorkingDir, %fullPath%

        if ErrorLevel
            Return

        InputBox, UserInput, New File (example: foo.txt), , , 400, 100

        If ErrorLevel
            Return

        FileAppend, , %UserInput%
        ; Run %UserInput%
Return

; set list view
^Ы::
        MouseGetPos, x, y, winid, ctrlid,2
        ControlGet, listview, Hwnd, , , ahk_id %ctrlid%
        Loop
        {
            listview := DllCall("GetParent", "UInt", listview)
            If listview = 0
                Break
            WM_COMMAND = 0x111
            ODM_VIEW_LIST = 0x702b
            SendMessage, WM_COMMAND, ODM_VIEW_LIST, 0, , ahk_id %listview%
        }
Return

; set detail view
^В::
        MouseGetPos, x, y, winid, ctrlid,2
        ControlGet, listview, Hwnd, , , ahk_id %ctrlid%
        Loop
        {
            listview := DllCall("GetParent", "UInt", listview)
            If listview = 0
                Break
            WM_COMMAND = 0x111
            ODM_VIEW_DETAIL = 0x702c
            SendMessage, WM_COMMAND, ODM_VIEW_DETAIL, 0, , ahk_id %listview%
        }
Return

; set icons view
^У::
        MouseGetPos, x, y, winid, ctrlid,2
        ControlGet, listview, Hwnd, , , ahk_id %ctrlid%
        Loop
        {
            listview := DllCall("GetParent", "UInt", listview)
            If listview = 0
                Break
            WM_COMMAND = 0x111
            ODM_VIEW_ICONS = 0x702a
            SendMessage, WM_COMMAND, ODM_VIEW_ICONS, 0, , ahk_id %listview%
        }
Return


; Google Chrome
#IfWinActive ahk_class Chrome_WidgetWin_1
; Alt+C to reopen active page from google cache
!С::
        Send !{SC020}
        Sleep 50
        BlockInput, on
        prevClipboard = %clipboard%
        clipboard =
        Send ^{SC02e}
        BlockInput, off
        ClipWait, 2
        if ErrorLevel = 0
        {
            ; Send ^{SC02f}
            ; Sleep 100
            ; Send {Enter}
            Send ^w
            searchQuery = http://webcache.googleusercontent.com/search?q=cache:%clipboard%
            Gosub GoogleSearch
        }
        clipboard = %prevClipboard%
Return


; cmd
#IfWinActive ahk_class ConsoleWindowClass
^+С::       Send {Enter}
^М::        Send %clipboard%
!F4::       WinClose A
MButton::   Send {Enter}
PgUp::      Send {WheelUp 10}
PgDn::      Send {WheelDown 10}


; MinGW
#IfWinActive ahk_class mintty
^+С::       Send {Ctrl}{Insert}
^М::        Send %clipboard%


; save and update script in notepad
#IfWinActive ahk_class Notepad
^+Ы::
        IfWinActive, %A_ScriptName%
        {
            Send ^S
            ToolTip Script is updating
            Sleep 700
            Reload
        }
Return


; save and update script in Sublime Text 3
#IfWinActive ahk_class PX_WINDOW_CLASS
^+Ы::      Gosub SaveAndReload
Return


; save and update script in Notepad++
#IfWinActive ahk_class Notepad++
^+Ы::       Gosub SaveAndReload


SaveAndReload:
        WinGetActiveTitle, title
        IfInString, title, %A_ScriptFullPath%
        {
            Send ^s
            ToolTip Script is updating
            Sleep 700
            Reload
        }
Return
#IfWinActive

#NoEnv          ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn           ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force        ; Replace older instance of this script with newer one

; ^ Ctrl, ! Alt, + Shift, # Win

GroupAdd, Explorer, ahk_class CabinetWClass
GroupAdd, Explorer, ahk_class ExploreWClass
GroupAdd, Explorer, ahk_class Progman
GroupAdd, Explorer, ahk_class WorkerW

RegRead, OutputVar, HKEY_CLASSES_ROOT, http\shell\open\command
StringReplace, OutputVar, OutputVar, "
SplitPath, OutputVar, , OutDir, , OutNameNoExt, OutDrive
browser = %OutDir%\%OutNameNoExt%.exe

NumLock::     Return
^NumLock::    Return
!NumLock::    Return
+NumLock::    Return

CapsLock::    MouseClick Left
^CapsLock::   Return
!CapsLock::   Return
+CapsLock::   Return

Insert::      Return

#+Ы::         Run nircmd-x64\nircmd.exe speak text ~$clipboard$
#+Ф::         Run nircmd-x64\nircmd.exe win center alltop

#Esc::        Run nircmd-x64\nircmd.exe monitor off

#WheelUp::    Run nircmd-x64\nircmd.exe changesysvolume 4000
#WheelDown::  Run nircmd-x64\nircmd.exe changesysvolume -4000

#+Up::        Run nircmd-x64\nircmd.exe changesysvolume 4000
#+Down::      Run nircmd-x64\nircmd.exe changesysvolume -4000

>^NumPad1::   Run nircmd-x64\nircmd.exe changesysvolume -4000
>^NumPad2::   Run nircmd-x64\nircmd.exe changesysvolume 4000

#^+Up::       Run nircmd-x64\nircmd.exe mutesysvolume 0
#^+Down::     Run nircmd-x64\nircmd.exe mutesysvolume 1

>^NumPad5::   Run nircmd-x64\nircmd.exe mutesysvolume 0
>^NumPad4::   Run nircmd-x64\nircmd.exe mutesysvolume 1

#+Right::     Run nircmd-x64\nircmd.exe changebrightness +4
#+left::      Run nircmd-x64\nircmd.exe changebrightness -12

#^+Right::    Run nircmd-x64\nircmd.exe setbrightness 100
#^+left::     Run nircmd-x64\nircmd.exe setbrightness 0

!+Ф::   Send arthur.akbarov@yandex.ru

^#Ф::   WinSet, AlwaysOnTop, toggle, A

#Ы::    WinRestore, A
#Ф::    WinMaximize, A
#Ц::    WinMinimize, A
#Й::    WinClose, A

; Ctrl+Win+F to force set active windows full screen and borderless
^#А::
        WinSet, Style, -0xC40000, A
        WinMove, A, , 0, 0, 1292, 770
Return

#П::
        BlockInput, on
        prevClipboard = %clipboard%
        clipboard =
        Send ^{SC02e}
        BlockInput, off
        ClipWait, 2
        if ErrorLevel = 0
        {
            searchQuery = %clipboard%
            Gosub GoogleSearch
        }
        clipboard = %prevClipboard%
Return

GoogleSearch:
        StringReplace, searchQuery, searchQuery, `r`n, %A_Space%, All
        Loop
        {
            noExtraSpaces = 1
            StringLeft, leftMost, searchQuery, 1
            IfInString, leftMost, %A_Space%
            {
                StringTrimLeft, searchQuery, searchQuery, 1
                noExtraSpaces=0
            }

            StringRight, rightMost, searchQuery, 1
            IfInString, rightMost, %A_Space%
            {
                StringTrimRight, searchQuery, searchQuery, 1
                noExtraSpaces=0
            }

            If (noExtraSpaces = 1)
                Break
        }

        StringReplace, searchQuery, searchQuery, \, `%5C, All
        StringReplace, searchQuery, searchQuery, %A_Space%, +, All
        StringReplace, searchQuery, searchQuery, `%, `%25, All

        IfInString, searchQuery, .
        {
            IfInString, searchQuery, +
                Run http://www.google.com/search?q=%searchQuery%
            Else
                Run %searchQuery%
        }
        Else
            Run http://www.google.com/search?q=%searchQuery%
Return

^'::
        prevClipboard = %clipboard%
        Send ^{SC02e}
        Send '^{SC02f}'
        Sleep 50
        clipboard = %prevClipboard%
Return

^@::
^"::
        prevClipboard = %clipboard%
        Send ^{SC02e}
        Send "^{SC02f}"
        Sleep 50
        clipboard = %prevClipboard%
Return

^%::
        prevClipboard = %clipboard%
        Send ^{SC02e}
        Send `%^{SC02f}`%
        Sleep 50
        clipboard = %prevClipboard%
Return

^(::
^)::
        prevClipboard = %clipboard%
        Send ^{SC02e}
        Send (^{SC02f})
        Sleep 50
        clipboard = %prevClipboard%
Return


; Win+C to open cmd in current directory
#С::
        if WinActive("ahk_group Explorer") {
            dir = %A_Desktop%
            WinHWND := WinActive()
            For win in ComObjCreate("Shell.Application").Windows
                If (win.HWND = WinHWND) {
                    dir := SubStr(win.LocationURL, 9) ; remove "file:///"
                    dir := RegExReplace(dir, "%20", " ")
                    Break
                }
            Run, cmd, % dir
        } else 
            Run, cmd, D:\Workspace
Return


;
; program sensitive
;


; Windows Photo Viewer
#IfWinActive ahk_class Photo_Lightweight_Viewer
WheelUp::       Send {left}
WheelDown::     Send {Right}


; Explorer
#IfWinActive ahk_group Explorer
!Down::         Send {Enter}
!Right::        Send {Enter}

CapsLock & WheelUp::    Send {Up}
CapsLock & WheelDown::  Send {Down}

CapsLock & RButton::    MouseClick Right
CapsLock & LButton::    Send {Down}

!WheelUp::      Send !{Up}
!WheelDown::    Send {Enter}

+WheelUp::      Send +{Up}
+WheelDown::    Send +{Down}

MButton::       Send {Enter}

!В::
        ControlFocus, ToolbarWindow322
        send {Space}
Return

; copy selected files as path
+С::
        Send ^{SC02e}
        Sleep 50
        Clipboard := Clipboard
Return

; open selected file with NotePad++
+Т::
        prevClipboard = %clipboard%
        clipboard =
        Send ^{SC02e}
        ClipWait
        Run "%A_ProgramFiles%\Notepad++\notepad++.exe" `"%clipboard%`"
        clipboard = %prevClipboard%
Return

; open selected file with Sublime Text 3
+Ы::
        prevClipboard = %clipboard%
        clipboard =
        Send ^{SC02e}
        ClipWait
        Run "%A_ProgramFiles%\Sublime Text 3\sublime_text.exe" `"%clipboard%`"
        clipboard = %prevClipboard%
Return

; https://gist.github.com/davejamesmiller/1965432
; Ctrl+Alt+N to create and open new file in explorer
^!Т::
        WinGetText, text, A
        StringSplit, pathArray, text, `r`n
        fullPath = %pathArray1%
        fullPath := RegExReplace(fullPath, "(^Address: )", "")
        fullPath := RegExReplace(fullPath, "(^Адрес: )", "")

        SetWorkingDir, %fullPath%

        if ErrorLevel
            Return

        InputBox, UserInput, New File (example: foo.txt), , , 400, 100

        If ErrorLevel
            Return

        FileAppend, , %UserInput%
        ; Run %UserInput%
Return

; set list view
^Ы::
        MouseGetPos, x, y, winid, ctrlid,2
        ControlGet, listview, Hwnd, , , ahk_id %ctrlid%
        Loop
        {
            listview := DllCall("GetParent", "UInt", listview)
            If listview = 0
                Break
            WM_COMMAND = 0x111
            ODM_VIEW_LIST = 0x702b
            SendMessage, WM_COMMAND, ODM_VIEW_LIST, 0, , ahk_id %listview%
        }
Return

; set detail view
^В::
        MouseGetPos, x, y, winid, ctrlid,2
        ControlGet, listview, Hwnd, , , ahk_id %ctrlid%
        Loop
        {
            listview := DllCall("GetParent", "UInt", listview)
            If listview = 0
                Break
            WM_COMMAND = 0x111
            ODM_VIEW_DETAIL = 0x702c
            SendMessage, WM_COMMAND, ODM_VIEW_DETAIL, 0, , ahk_id %listview%
        }
Return

; set icons view
^У::
        MouseGetPos, x, y, winid, ctrlid,2
        ControlGet, listview, Hwnd, , , ahk_id %ctrlid%
        Loop
        {
            listview := DllCall("GetParent", "UInt", listview)
            If listview = 0
                Break
            WM_COMMAND = 0x111
            ODM_VIEW_ICONS = 0x702a
            SendMessage, WM_COMMAND, ODM_VIEW_ICONS, 0, , ahk_id %listview%
        }
Return


; Google Chrome
#IfWinActive ahk_class Chrome_WidgetWin_1
; Alt+C to reopen active page from google cache
!С::
        Send !{SC020}
        Sleep 50
        BlockInput, on
        prevClipboard = %clipboard%
        clipboard =
        Send ^{SC02e}
        BlockInput, off
        ClipWait, 2
        if ErrorLevel = 0
        {
            ; Send ^{SC02f}
            ; Sleep 100
            ; Send {Enter}
            Send ^w
            searchQuery = http://webcache.googleusercontent.com/search?q=cache:%clipboard%
            Gosub GoogleSearch
        }
        clipboard = %prevClipboard%
Return


; cmd
#IfWinActive ahk_class ConsoleWindowClass
^+С::       Send {Enter}
^М::        Send %clipboard%
!F4::       WinClose A
MButton::   Send {Enter}
PgUp::      Send {WheelUp 10}
PgDn::      Send {WheelDown 10}


; MinGW
#IfWinActive ahk_class mintty
^+С::       Send {Ctrl}{Insert}
^М::        Send %clipboard%


; save and update script in notepad
#IfWinActive ahk_class Notepad
^+Ы::
        IfWinActive, %A_ScriptName%
        {
            Send ^S
            ToolTip Script is updating
            Sleep 700
            Reload
        }
Return


; save and update script in Sublime Text 3
#IfWinActive ahk_class PX_WINDOW_CLASS
^+Ы::      Gosub SaveAndReload
Return


; save and update script in Notepad++
#IfWinActive ahk_class Notepad++
^+Ы::       Gosub SaveAndReload


SaveAndReload:
        WinGetActiveTitle, title
        IfInString, title, %A_ScriptFullPath%
        {
            Send ^s
            ToolTip Script is updating
            Sleep 700
            Reload
        }
Return
#IfWinActive

