; reminder ^ Ctrl, ! Alt, + Shift, # Win, >^ RightCtrl, <! LeftAlt, ` escape character

; cannot control touchpad sensitivity

/*
Limited Support, Documentation And Changelog: http://www.autohotkey.com/forum/viewtopic.php?t=83794

File structure

Settings
    -ahk script setting
    -save settings
    -reverse scroll settings
    -defaults method settings
    -app method settings
    -method counters
    -static system variables

External app settings retrieval

Suspend Hotkey
    -ScrollLock

Setup HotKeys
    -WinKey + [Ctrl + Shift +]WheelUp
    -WinKey + [Ctrl + Shift +]WheelDown
    -WinKey + [Ctrl + Shift +]WheelRight
    -WinKey + [Ctrl + Shift +]WheelLeft

Main HotKeys
    -WheelUp
    -WheelDown
    -WheelRight
    -WheelLeft

Subs for the main hotkeys
    -Set_Method
    -Get_SBar_Info

Subs for the setup hotkeys
    -TApp_Method_Settings
    -SAVEtoFILE
*/

; *********************************************************************
; *                  start of the auto-execute section                *
; *********************************************************************

#NoEnv          ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn           ; Enables warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force        ; Forced replacement older instance of this script with newer one.
#NoTrayIcon

; SetScrollLockState, off
CoordMode, Mouse, Screen
#InstallMouseHook
#UseHook
Critical

#MaxHotkeysPerInterval 500

useExternalAppSettings = 1
extSAVEfilename = "ScrollTrekAppSettings.ini"
SAVEdelay = -2000

vReverse = 0
hReverse = 0
sReverse = 0  ; use reverse settings above when using setting hotkeys too

vDefaultMethod = 1
hDefaultMethod = 1
fDefaultMethod = 1

/*
[AppMethodSettings]
*/
AppSettings_vMethod =
AppSettings_hMethod =
AppSettings_fMethod =
/*
[Rest of Script]
*/

vMethodCount = 7
hMethodCount = 7
fMethodCount = 2

WM_MOUSEWHEEL = 0x20A
WM_MOUSEHWHEEL = 0x20E
WM_HSCROLL = 0x114
WM_VSCROLL = 0x115
EM_LINESCROLL = 0xB6
WM_LBUTTONDOWN = 0x201
WM_LBUTTONUP = 0x202
WM_KEYDOWN = 0x0100
WM_KEYUP = 0x0101
VK_LEFT = 0x25
VK_UP = 0x26
VK_RIGHT = 0x27
VK_DOWN = 0x28

If useExternalAppSettings
{
    iniRead, AppSettings_vMethod, %extSAVEfilename%, AppMethodSettings, AppSettings_vMethod, %AppSettings_vMethod%
    iniRead, AppSettings_hMethod, %extSAVEfilename%, AppMethodSettings, AppSettings_hMethod, %AppSettings_hMethod%
    iniRead, AppSettings_fMethod, %extSAVEfilename%, AppMethodSettings, AppSettings_fMethod, %AppSettings_fMethod%
    StringReplace, AppSettings_vMethod, AppSettings_vMethod, ERROR, , All
    StringReplace, AppSettings_hMethod, AppSettings_hMethod, ERROR, , All
    StringReplace, AppSettings_fMethod, AppSettings_fMethod, ERROR, , All
    Gosub, SAVEtoFILE
}

; ********************************************************************
;                   end of the auto-execute section                  *
; ********************************************************************

; Win+End to suspend all scripts, Win+Home to rise back, Ctrl+Win+End to close
~#Home::        Suspend, Off
~#End::         Suspend, On
~^#End::        ExitApp

#^+WheelUp::
    axis = v

    If (sReverse = 0) OR (%axis%Reverse = 0)
        direction = 1
    Else
        direction = -1

    SettingDeph = 2
    Gosub, TApp_Method_Settings
Return

#^+WheelDown::
    axis = v

    If (sReverse = 0) OR (%axis%Reverse = 0)
        direction = -1
    Else
        direction = 1

    SettingDeph = 2
    Gosub, TApp_Method_Settings
Return

; #^+WheelRight::
; axis = h
; If (sReverse = 0) OR (%axis%Reverse = 0)
;   direction = 1
; Else
;   direction = -1
; SettingDeph = 2
; Gosub, TApp_Method_Settings
; Return

; #^+WheelLeft::
; axis = h
; If (sReverse = 0) OR (%axis%Reverse = 0)
;   direction = -1
; Else
;   direction = 1
; SettingDeph = 2
; Gosub, TApp_Method_Settings
; Return

#^WheelUp::
    axis = v

    If (sReverse = 0) OR (%axis%Reverse = 0)
        direction = 1
    Else
        direction = -1

    SettingDeph = 1
    Gosub, TApp_Method_Settings
Return

#^WheelDown::
    axis = v

    If (sReverse = 0) OR (%axis%Reverse = 0)
        direction = -1
    Else
        direction = 1

    SettingDeph = 1
    Gosub, TApp_Method_Settings
Return

; #^WheelRight::
; axis = h
; If (sReverse = 0) OR (%axis%Reverse = 0)
;   direction = 1
; Else
;   direction = -1
; SettingDeph = 1
; Gosub, TApp_Method_Settings
; Return

; #^WheelLeft::
; axis = h
; If (sReverse = 0) OR (%axis%Reverse = 0)
;   direction = -1
; Else
;   direction = 1
; SettingDeph = 1
; Gosub, TApp_Method_Settings
; Return

#WheelUp::
    axis = v

    If (sReverse = 0) OR (%axis%Reverse = 0)
        direction = 1
    Else
        direction = -1

    SettingDeph = 0
    Gosub, TApp_Method_Settings
Return

#WheelDown::
    axis = v

    If (sReverse = 0) OR (%axis%Reverse = 0)
        direction = -1
    Else
        direction = 1

    SettingDeph = 0
    Gosub, TApp_Method_Settings
Return

; #WheelRight::
; axis = h
; If (sReverse = 0) OR (%axis%Reverse = 0)
;   direction = 1
; Else
;   direction = -1
; SettingDeph = 0
; Gosub, TApp_Method_Settings
; Return

; #WheelLeft::
; axis = h
; If (sReverse = 0) OR (%axis%Reverse = 0)
;   direction = -1
; Else
;   direction = 1
; SettingDeph = 0
; Gosub, TApp_Method_Settings
; Return

#+WheelUp::
    axis = f

    If (sReverse = 0) OR (vReverse = 0)
        direction = 1
    Else
        direction = -1

    SettingDeph = 0
    Gosub, TApp_Method_Settings
Return

#+WheelDown::
    axis = f

    If (sReverse = 0) OR (vReverse = 0)
        direction = -1
    Else
        direction = 1

    SettingDeph = 0
    Gosub, TApp_Method_Settings
Return

; Send, , {Left}, ahk_id %TWinID%
WheelUp::
    MouseGetPos, mX, mY, TWinID, TCon
    Sleep, 5
    WinGetClass, class, ahk_id %TWinID%
    If (class = "Photo_Lightweight_Viewer")
    {
        WinGet, active_id, ID, A
        If (active_id = TWinID)
            Send, {Left}
        Return
    }

    If (TWinID <> exWin4v) OR (TCon <> exCon4v)
    {
        axis = v
        Gosub, Set_Method
    }
    If %axis%Reverse
        goto, ScrollDown

ScrollUp:
    If (vMethod = "Off")
        Click, WheelUp
    Else If (vMethod = 1)
        PostMessage, WM_MOUSEWHEEL, 120 << 16, (mY << 16) | (mX & 0xFFFF), %TCon%, ahk_id%TWinID%
    Else If (vMethod = 2)
        ControlClick, %TCon%, ahk_id%TWinID%, , WheelUp, 1, NA
    Else If (vMethod = 3)
        PostMessage, WM_VSCROLL, 0, 0, %TCon%, ahk_id%TWinID%
    Else If (vMethod = 4)
        PostMessage, EM_LINESCROLL, 0, -1, %TCon%, ahk_id%TWinID%
    Else If (vMethod = 5) OR (vMethod = 6)
    {
        If (mX <> exMx) OR (mY <> exMy)
        {
            axis = v
            Gosub, Get_SBar_Info
        }
        PostMessage, WM_LBUTTONDOWN, , (5 << 16) | 5, %VBarC%, ahk_id%TWinID%
        PostMessage, WM_LBUTTONUP, , (5 << 16) | 5, %VBarC%, ahk_id%TWinID%
    }
    Else If (vMethod = 7)
    {
        PostMessage, WM_KEYDOWN, VK_UP, , %TCon%, ahk_id%TWinID%
        PostMessage, WM_KEYUP, VK_UP, , %TCon%, ahk_id%TWinID%
    }
Return

WheelDown::
    MouseGetPos, mX, mY, TWinID, TCon

    Sleep, 5

    WinGetClass, class, ahk_id %TWinID%
    If (class = "Photo_Lightweight_Viewer")
    {
        WinGet, active_id, ID, A
        If (active_id = TWinID)
            Send, {Right}
        Return
    }

    If (TWinID <> exWin4v) OR (TCon <> exCon4v)
    {
        axis = v
        Gosub, Set_Method
    }
    If %axis%Reverse
        goto, ScrollUp

ScrollDown:
    If (vMethod = "Off")
        Click, WheelDown
    Else If (vMethod = 1)
        PostMessage, WM_MOUSEWHEEL, -120 << 16, (mY << 16) | (mX & 0xFFFF), %TCon%, ahk_id%TWinID%
    Else If (vMethod = 2)
        ControlClick, %TCon%, ahk_id%TWinID%, , WheelDown, 1, NA
    Else If (vMethod = 3)
        PostMessage, WM_VSCROLL, 1, 0, %TCon%, ahk_id%TWinID%
    Else If (vMethod = 4)
        PostMessage, EM_LINESCROLL, 0, 1, %TCon%, ahk_id%TWinID%
    Else If (vMethod = 5) OR (vMethod = 6)
    {
        If (mX <> exMx) OR (mY <> exMy)
        {
            axis = v
            Gosub, Get_SBar_Info
        }
        PostMessage, WM_LBUTTONDOWN, , ((VBarH - 5) << 16) | 5, %VBarC%, ahk_id%TWinID%
        PostMessage, WM_LBUTTONUP, , ((VBarH - 5) << 16) | 5, %VBarC%, ahk_id%TWinID%
    }
    Else If (vMethod = 7)
    {
        PostMessage, WM_KEYDOWN, VK_DOWN, , %TCon%, ahk_id%TWinID%
        PostMessage, WM_KEYUP, VK_DOWN, , %TCon%, ahk_id%TWinID%
    }
Return

; WheelLeft::
; MouseGetPos, mX, mY, TWinID, TCon
; If (TWinID <> exWin4h) OR (TCon <> exCon4h)
;   {
;   axis = h
;   Gosub, Set_Method
;   }
; If %axis%Reverse
;   goto, ScrollRight
; ScrollLeft:
; If (hMethod = "Off")
;   Click, WheelLeft
; Else If (hMethod = 1)
;   PostMessage, WM_MOUSEHWHEEL, -120 << 16, (mY << 16) | (mX & 0xFFFF), %TCon%, ahk_id%TWinID%
; Else If (hMethod = 2)
;   ControlClick, %TCon%, ahk_id%TWinID%, , WheelLeft, 1, NA
; Else If (hMethod = 3)
;   PostMessage, WM_HSCROLL, 0, 0, %TCon%, ahk_id%TWinID%
; Else If (hMethod = 4)
;   PostMessage, EM_LINESCROLL, -1, 0, %TCon%, ahk_id%TWinID%
; Else If (hMethod = 5) OR (hMethod = 6)
;   {
;   If (mX <> exMx) OR (mY <> exMy)
;       {
;       axis = h
;       Gosub, Get_SBar_Info
;       }
;   PostMessage, WM_LBUTTONDOWN, , (5 << 16) | 5, %HBarC%, ahk_id%TWinID%
;   PostMessage, WM_LBUTTONUP, , (5 << 16) | 5, %HBarC%, ahk_id%TWinID%
;   }
; Else If (hMethod = 7)
;   {
;   PostMessage, WM_KEYDOWN, VK_LEFT, , %TCon%, ahk_id%TWinID%
;   PostMessage, WM_KEYUP, VK_LEFT, , %TCon%, ahk_id%TWinID%
;   }
; Return

; WheelRight::
; MouseGetPos, mX, mY, TWinID, TCon
; If (TWinID <> exWin4h) OR (TCon <> exCon4h)
;   {
;   axis = h
;   Gosub, Set_Method
;   }
; If %axis%Reverse
;   goto, ScrollLeft
; ScrollRight:
; If (hMethod = "Off")
;   Click, WheelRight
; Else If (hMethod = 1)
;   PostMessage, WM_MOUSEHWHEEL, 120 << 16, (mY << 16) | (mX & 0xFFFF), %TCon%, ahk_id%TWinID%
; Else If (hMethod = 2)
;   ControlClick, %TCon%, ahk_id%TWinID%, , WheelRight, 1, NA
; Else If (hMethod = 3)
;   PostMessage, WM_HSCROLL, 1, 0, %TCon%, ahk_id%TWinID%
; Else If (hMethod = 4)
;   PostMessage, EM_LINESCROLL, 1, 0, %TCon%, ahk_id%TWinID%
; Else If (hMethod = 5) OR (hMethod = 6)
;   {
;   If (mX <> exMx) OR (mY <> exMy)
;       {
;       axis = h
;       Gosub, Get_SBar_Info
;       }
;   PostMessage, WM_LBUTTONDOWN, , (5 << 16) | (HBarW - 5), %HBarC%, ahk_id%TWinID%
;   PostMessage, WM_LBUTTONUP, , (5 << 16) | (HBarW - 5), %HBarC%, ahk_id%TWinID%
;   }
; Else If (hMethod = 7)
;   {
;   PostMessage, WM_KEYDOWN, VK_RIGHT, , %TCon%, ahk_id%TWinID%
;   PostMessage, WM_KEYUP, VK_RIGHT, , %TCon%, ahk_id%TWinID%
;   }
; Return

Set_Method:
    %axis%Method := %axis%DefaultMethod
    fMethod := fDefaultMethod
    TConC =
    TConN =
    AppString =
    AppString_method =
    AppString_exceptions =
    ConCString =
    ConCString_method =
    ConCString_exceptions =
    ConNString =
    ConNString_method =

    If (TCon <> "")
        RegExMatch(TCon, "(?P<C>.*\D)(?P<N>\d+)$", TCon)

    WinGet, TApp, ProcessName, ahk_id%TWinID%

    If (TApp <> "") And InStr(AppSettings_%axis%Method, "{" . TApp)
    {
        RegExMatch(AppSettings_%axis%Method, "i)\{" . TApp . "(\((?P<_method>[^\)]*)\))?(?P<_exceptions>[^\}]*)\}", AppString)

        If (AppString_method <> "")
            %axis%Method = AppString_method

        If InStr(AppSettings_%axis%Method, "{<" . TConC)
        {
            RegExMatch(AppSettings_%axis%Method, "i)\{\<" . TConC . "(\((?P<_method>[^\)]*)\))?\>\}", ConCString)

            If (ConCString_method <> "")
                %axis%Method := ConCString_method
            Else
                %axis%Method := %axis%DefaultMethod
        }

        If InStr(AppString_Exceptions, "<" . TConC)
        {
            RegExMatch(AppString_Exceptions, "i)\<" . TConC . "(\((?P<_method>[^\)]*)\))?(?P<_exceptions>[^\>]*)\>", ConCString)

            If (ConCString_method <> "")
                %axis%Method := ConCString_method

            If InStr(ConCString_Exceptions, "[" . TConN)
            {
                RegExMatch(ConCString_Exceptions, "i)\[" . TConN . "\((?P<_method>[^\)]*)\)\]", ConNString)

                If (ConNString_method <> "")
                    %axis%Method := ConNString_method
            }
        }
    }
    Else If (TCon <> "") And InStr(AppSettings_%axis%Method, "{<" . TConC)
    {
        RegExMatch(AppSettings_%axis%Method, "i)\{\<" . TConC . "(\((?P<_method>[^\)]*)\))?\>\}", ConCString)

        If (ConCString_method <> "")
            %axis%Method := ConCString_method
    }


    If (%axis%Method = 5)
    {
        look4 := "ScrollBar"
        Gosub, Get_SBar_Info
    }
    Else If (%axis%Method = 6)
    {
        look4 := "NetUIHWND"
        Gosub, Get_SBar_Info
    }

    If (TApp <> "") And InStr(AppSettings_fMethod, "{" . TApp)
    {
        RegExMatch(AppSettings_fMethod, "i)\{" . TApp . "(\((?P<_method>[^\)]*)\))?(?P<_exceptions>[^\}]*)\}", AppFocus)

        If (AppFocus_method <> "")
            fMethod := AppFocus_method
    }

    If (fMethod = 1)
        PostMessage, 0x0006, 2, , %TCon%, ahk_id%TWinID%
    Else
        If (fMethod = 2)
        {
            PostMessage, 0x0006, 2, , %TCon%, ahk_id%TWinID%
            PostMessage, WM_LBUTTONDOWN, , , %TCon%, ahk_id%TWinID%
            PostMessage, WM_LBUTTONUP, , , %TCon%, ahk_id%TWinID%
        }

    exWin4%axis% := exTWinID := TWinID
    exCon4%axis% := exTCon := TCon
Return

Get_SBar_Info:
    %axis%BarC =
    exMx := mX
    exMy := mY

    If (look4 = "ScrollBar") And InStr(TCon, look4)
    {
        ControlGetPos, SBarX, SBarY, SBarW, SBarH, %TCon%, ahk_id%TWinID%
        If (axis = v)
        And (SBarW < 20)
        And (SBarH > SBarW)
        {
            VBarC := TCon
            VBarX := SBarX
            VBarY := SBarY
            VBarW := SBarW
            VBarH := SBarH
            Return
        }
        Else
            If (axis = h)
            And (SBarH < 20)
            And (SBarW > SBarH)
            {
                HBarC := TCon
                HBarX := SBarX
                HBarY := SBarY
                HBarW := SBarW
                HBarH := SBarH
                Return
            }
            Else
            {
                TSBarH := SBarH
                TSBarW := SBarW
            }
    }
    Else
    {
        TSBarH = 0
        TSBarW = 0
    }

    WinGetPos, TWinIDX, TWinIDY, , , ahk_id%TWinID%
    WinGet, TWinIDConList, ControlList, ahk_id%TWinID%

    Loop, Parse, TWinIDConList, `n
    {
        If !InStr(A_LoopField, look4)
            Return

        ControlGet, vis, Visible, , %A_LoopField%, ahk_id%TWinID%

        If (vis != 1)
            Return

        ControlGetPos, SBarX, SBarY, SBarW, SBarH, %A_LoopField%, ahk_id%TWinID%

        If (axis = v)
        And (SBarW < 20)
        And (SBarH > SBarW)
        And (mX < (TWinIDX + SBarX + SBarW))
        And (mY < (TWinIDY + SBarY + SBarH + TSBarH))
            If (VBarC = "")
            OR (SBarX < VBarX)
            OR ((TWinIDY + VBarY) > (TWinIDY + SBarY + SBarH))
            {
                VBarC := A_LoopField
                VBarX := SBarX
                VBarY := SBarY
                VBarW := SBarW
                VBarH := SBarH
            }
            Else If (axis = h)
            And (SBarH < 20)
            And (SBarW > SBarH)
            And (mY < (TWinIDY + SBarY + SBarH))
            And (mX < (TWinIDX + SBarX + SBarW + TSBarW))
                If (HBarC = "")
                OR (SBarY < HBarY)
                OR ((TWinIDX + HBarX) > (TWinIDX + SBarX + SBarW))
                {
                    HBarC := A_LoopField
                    HBarX := SBarX
                    HBarY := SBarY
                    HBarW := SBarW
                    HBarH := SBarH
                }
    }
Return


TApp_Method_Settings:
    MouseGetPos, , , TWinID, TCon
    WinGet, TApp, ProcessName, ahk_id%TWinID%

    If (TApp = "")
        Return

    If (TCon = "") And (SettingDeph > 0)
        Return

    RegExMatch(TCon, "(?P<C>.*\D)(?P<N>\d+)$", TCon)

    TApp_%axis%Method_ex := %axis%DefaultMethod
    TApp_%axis%Method_new =
    AppString =
    AppString_method =
    AppString_exceptions =
    ConCString =
    ConCString_method =
    ConCString_exceptions =
    ConNString =
    ConNString_method =

    If InStr(AppSettings_%axis%Method, "{" . TApp)
    {
        RegExMatch(AppSettings_%axis%Method, "i)\{" . TApp . "(\((?P<_method>[^\)]*)\))?(?P<_exceptions>[^\}]*)\}", AppString)
        StringReplace, AppSettings_%axis%Method, AppSettings_%axis%Method, %AppString%, , All

        If (AppString_method = "")
            AppString_method := %axis%DefaultMethod

        TApp_%axis%Method_ex := AppString_method

        If (SettingDeph > 0)
        And (AppString_exceptions <> "")
        And InStr(AppString_exceptions,  "<" . TConC)
        {
            RegExMatch(AppString_Exceptions, "i)\<" . TConC . "(\((?P<_method>[^\)]*)\))?(?P<_exceptions>[^\>]*)\>", ConCString)
            StringReplace, AppString_exceptions, AppString_exceptions, %ConCString%, , All

            If (ConCString_method = "")
                ConCString_method := AppString_method

            TApp_%axis%Method_ex := ConCString_method


            If (SettingDeph > 1)
            And (ConCString_exceptions <> "")
            And InStr(ConCString_exceptions, "[" . TConN)
            {
                RegExMatch(ConCString_Exceptions, "i)\[" . TConN . "\((?P<_method>[^\)]*)\)\]", ConNString)
                StringReplace, ConCString_exceptions, ConCString_exceptions, %ConNString%, , All

                If (ConNString_method = "")
                    ConNString_method := ConCString_method

                TApp_%axis%Method_ex := ConNString_method
            }
        }
    }

    ToolTip % TApp_%axis%Method_ex

    If (TApp_%axis%Method_ex = 1) And (direction = -1)
        TApp_%axis%Method_new = "Off"
    Else If (TApp_%axis%Method_ex = %axis%MethodCount) And (direction = 1)
        TApp_%axis%Method_new = "Off"
    Else If (TApp_%axis%Method_ex = "Off")
    {
        If (direction = 1)
            TApp_%axis%Method_new = 1
        Else If (direction = -1)
            TApp_%axis%Method_new := %axis%MethodCount
    }
    Else
        TApp_%axis%Method_new := TApp_%axis%Method_ex + direction

    If (SettingDeph = 2)
        ConNString_method := TApp_%axis%Method_new
    Else If (SettingDeph = 1)
        ConCString_method := TApp_%axis%Method_new
    Else
        AppString_method := TApp_%axis%Method_new


    If (SettingDeph > 1) And (ConNString_method <> ConCString_method)
        ConCString_exceptions := ConCString_exceptions . "[" . TConN . "(" . ConNString_method . ")]"

    If (SettingDeph > 0)
    {
        If (ConCString_method <> AppString_method)
            AppString_exceptions := AppString_exceptions . "<" . TConC . "(" . ConCString_method . ")" . ConCString_exceptions . ">"
        Else If (ConCString_exceptions <> "")
            AppString_exceptions := AppString_exceptions . "<" . TConC . ConCString_exceptions . ">"
    }

    If (AppString_method <> %axis%DefaultMethod)
        AppSettings_%axis%Method := AppSettings_%axis%Method . "{" . TApp . "(" . AppString_method . ")" . AppString_exceptions . "}"
    Else If (AppString_exceptions <> "")
        AppSettings_%axis%Method := AppSettings_%axis%Method . "{" . TApp . AppString_exceptions . "}"

    ToolTip, % TApp_%axis%Method_new

    exWin4%axis% =
    exCon4%axis% =

    setTimer, SAVEtoFILE, %SAVEdelay%
Return

SAVEtoFILE:
    iniWrite, %AppSettings_vMethod%, %A_ScriptName%, AppMethodSettings, AppSettings_vMethod
    iniWrite, %AppSettings_hMethod%, %A_ScriptName%, AppMethodSettings, AppSettings_hMethod
    iniWrite, %AppSettings_fMethod%, %A_ScriptName%, AppMethodSettings, AppSettings_fMethod
    If useExternalAppSettings
    {
        iniWrite, %AppSettings_vMethod%, %extSAVEfilename%, AppMethodSettings, AppSettings_vMethod
        iniWrite, %AppSettings_hMethod%, %extSAVEfilename%, AppMethodSettings, AppSettings_hMethod
        iniWrite, %AppSettings_fMethod%, %extSAVEfilename%, AppMethodSettings, AppSettings_fMethod
    }
    ToolTip
Return
