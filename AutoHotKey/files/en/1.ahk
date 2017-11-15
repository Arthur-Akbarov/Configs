; reminder ^ Ctrl, ! Alt, + Shift, # Win, >^ RightCtrl, <! LeftAlt, ` escape character

; *********************************************************************
; *                  start of the auto-execute section                *
; *********************************************************************

#NoEnv          ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn           ; Enables warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force        ; Forced replacement older instance of this script with newer one.
#NoTrayIcon

email =
If FileExist("settings.ini")
    IniRead, email, settings.ini, Section1, email
; MsgBox, , DEBUG, email = "%email%"

workEmail =
If FileExist("settings.ini")
    IniRead, workEmail, settings.ini, Section1, workEmail
; MsgBox, , DEBUG, workEmail = "%workEmail%"

; *********************************************************************
; *                  end of the auto-execute section                  *
; *********************************************************************

; Win+End to suspend all scripts, Win+Home to rise back, Ctrl+Win+End to close
~#Home::        Suspend, Off
~#End::         Suspend, On
~^#End::        ExitApp

NumLock::       Return
!NumLock::      Return
+NumLock::      Return
^NumLock::      Return

CapsLock::      LButton
^+CapsLock::    CapsLock

; against accidental pressing insert key, especially with a full-size keyboard
Insert::        Return

!+A::           Send, %email%
!+W::           Send, %workEmail%
!+K::           Send, autohotkey

^#A::           WinSet, AlwaysOnTop, Toggle, A

#S::            WinRestore, A
#A::            WinMaximize, A
#W::            WinMinimize, A
#Q::            WinClose, A

#+S::           Run, ..\nircmd-x64\nircmd.exe speak text ~$ClipBoard$
#+A::           Run, ..\nircmd-x64\nircmd.exe win center alltop

>^NumPad4::     Run, ..\nircmd-x64\nircmd.exe changebrightness -12
>^NumPad5::     Run, ..\nircmd-x64\nircmd.exe changebrightness +4

#+Right::       Run, ..\nircmd-x64\nircmd.exe changebrightness +4
#+Left::        Run, ..\nircmd-x64\nircmd.exe changebrightness -12

#^+Right::      Run, ..\nircmd-x64\nircmd.exe setbrightness 100
#^+Left::       Run, ..\nircmd-x64\nircmd.exe setbrightness 0

; Win+Esc to turn off the monitor
#Esc::          SendMessage, 0x112, 0xF170, 2, , Program Manager

!WheelUp::      SoundSet, +1
!WheelDown::    SoundSet, -1

#+Up::          SoundSet, +1
#+Down::        SoundSet, -1

>^NumPad1::     SoundSet, -3
>^NumPad2::     SoundSet, +3

#^+Up::         SoundSet, 0, , mute
#^+Down::       SoundSet, 1, , mute

>^NumPad3::     SoundSet, 0, , mute
>^NumPadDot::   SoundSet, 1, , mute

>^NumPadEnter:: Run, calc.exe
PrintScreen::   Run, SnippingTool.exe

; Ctrl+; to add semicolon to the end of the line
^`;::           Send, {End}`;

^'::            WrapWith("'", "'")

; not Google Chrome
#IfWinNotActive ahk_class Chrome_WidgetWin_1
^2::
#If
^"::
^@::            WrapWith("""", """")

; not Google Chrome
#IfWinNotActive ahk_class Chrome_WidgetWin_1
^5::
#If
^%::            WrapWith("%", "%")

; not Google Chrome
#IfWinNotActive ahk_class Chrome_WidgetWin_1
^0::
^9::
#If
^(::
^)::            WrapWith("(", ")")

; *********************************************************************
; *                     functions and subroutines                     *
; *********************************************************************

WrapWith(left, right) {
    local ClipSaved := ClipBoardAll
    Send, ^{SC02E}               ; Ctrl+C
    Send, %left%^{SC02F}%right%  ; Ctrl+V
    Sleep, 50
    ClipBoard := ClipSaved
    ClipSaved =  ; free memory
}
