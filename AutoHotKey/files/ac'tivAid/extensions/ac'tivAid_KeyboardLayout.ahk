; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               KeyboardLayout
; -----------------------------------------------------------------------------
; Prefix:             kl_
; Version:            0.1
; Date:               2008-01-10
; Author:             Wolfgang Reszel, wOxxOm
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
;                     Based on the script by wOxxOm
;                     http://www.autohotkey.com/forum/topic27029.html
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_KeyboardLayout:
	Prefix = kl
	%Prefix%_ScriptName    = KeyboardLayout
	%Prefix%_ScriptVersion = 0.1
	%Prefix%_Author        = Wolfgang Reszel, wOxxOm

	CustomHotkey_KeyboardLayout = 1
	HotkeyPrefix_KeyboardLayout = $

	IconFile_On_KeyboardLayout = %A_WinDir%\system32\main.cpl
	IconPos_On_KeyboardLayout = 8

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %kl_ScriptName% - Tastaturlayout wechseln
		Description                   = Ermöglicht es, ein beliebiges Tastaturkürzel mit dem Eingabegebietsschemawechsel zu belegen
		lng_kl_NoBalloonTips          = Sprechblasenhinweise deaktivieren
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %kl_ScriptName% - Kurzbeschreibung
		Description                   = Allows to assign a hotkey to switch the keyboard layout
		lng_kl_NoBalloonTips          = No BalloonTips
	}

	RegisterAdditionalSetting("kl", "NoBalloonTips", 0)
Return

SettingsGui_KeyboardLayout:
Return

SaveSettings_KeyboardLayout:
Return

AddSettings_KeyboardLayout:
Return
CancelSettings_KeyboardLayout:
Return

DoEnable_KeyboardLayout:
Return

DoDisable_KeyboardLayout:
Return

DefaultSettings_KeyboardLayout:
Return
OnExitAndReload_KeyboardLayout:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_KeyboardLayout:
	kl_HKL:=DllCall("GetKeyboardLayout", "uint",GetThreadOfWindow(), "uint")

	kl_HKLnum:=DllCall("GetKeyboardLayoutList","uint",0,"uint",0)

	VarSetCapacity( kl_HKLlist, kl_HKLnum*4, 0 )
	DllCall("GetKeyboardLayoutList","uint",kl_HKLnum,"uint",&kl_HKLlist)
	loop,%kl_HKLnum%
	{
		If( NumGet( kl_HKLlist, (A_Index-1)*4 ) = kl_HKL )
		{
			kl_HKL:=NumGet( kl_HKLlist, mod(A_Index,kl_HKLnum)*4 )
			break
		}
	}
	ControlGetFocus,kl_ctl,A
	SendMessage,0x50,0,kl_HKL,%kl_ctl%,A ;WM_INPUTLANGCHANGEREQUEST

	kl_LOCALE_SLANGUAGE=0x2
	kl_LOCALE_SCOUNTRY=0x6
	VarSetCapacity( kl_sKbd, 260, 0 )
	VarSetCapacity( kl_sCountry, 260, 0 )
	VarSetCapacity( kl_sLayoutID, 260, 0 )
	SetFormat, Integer, Hex
	DllCall("GetLocaleInfoA","uint",kl_HKL>>16,"uint",kl_LOCALE_SLANGUAGE, "str",kl_sKbd, "uint",260)
	DllCall("GetLocaleInfoA","uint",kl_HKL & 0xFFFF,"uint",kl_LOCALE_SCOUNTRY, "str",kl_sCountry, "uint",260)

	IfWinActive, ahk_pid %activAidPID%
		kl_activAidHKL := kl_HKL
	Else
		kl_activAidHKL:=DllCall("GetKeyboardLayout", "uint",activAidPID, "uint")
	SendMessage,0x50,0,kl_HKL,,ahk_pid %activAidPID% ;WM_INPUTLANGCHANGEREQUEST
	DllCall("GetKeyboardLayoutName", "str",kl_sLayoutID)
	SendMessage,0x50,0,kl_activAidHKL,,ahk_pid %activAidPID% ;WM_INPUTLANGCHANGEREQUEST
	RegRead, kl_sLayoutName, HKLM, SYSTEM\CurrentControlSet\Control\Keyboard Layouts\%kl_sLayoutID%, Layout Text

	If kl_NoBalloonTips = 0
		BalloonTip( kl_ScriptName " " kl_ScriptVersion, kl_sLayoutName , "Info", 0, -1, 2 )
	SetFormat, Integer, d
Return
