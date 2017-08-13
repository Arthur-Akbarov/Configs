; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               RemapKeys
; -----------------------------------------------------------------------------
; Prefix:             rmp_
; Version:            0.5
; Date:               2008-05-23
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_RemapKeys:
	Prefix = rmp
	%Prefix%_ScriptName    = RemapKeys
	%Prefix%_ScriptVersion = 0.5
	%Prefix%_Author        = Wolfgang Reszel, Michael Telgkamp
	IconFile_On_RemapKeys  = %A_WinDir%\system32\main.cpl
	IconPos_On_RemapKeys   = 8

	HideSettings = 0                             ; Wenn 1, dann bekommt die Erweiterung keinen Eintrag im Konfigurationsdialog

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %rmp_ScriptName% - Feststellen neu belegen / Windows simulieren
		Description                   = Bietet die Möglichkeit, die Feststellen-Taste (CapsLock) neu zu belegen und die Windows-Taste zu simulieren.
		lng_rmp_RemapCapsLock         = Neue Belegung der Feststelltaste (CapsLock):
		lng_rmp_CapsStatus            = Großschreibmodus zurücksetzen
		lng_rmp_ResetNumLock          = NumLock zurücksetzen
		lng_rmp_SimWin                = Windows-Taste simulieren
		lng_rmp_SimWinHold            = nur, wenn die Taste länger gehalten wird
		lng_rmp_HotkeyButtonMsg       = Simulierte Windows-Taste erkannt,`nbitte loslassen und die zusätzlichen Tasten drücken.
		lng_rmp_NumpadPoint           = Komma auf Ziffernblock durch einen Punkt ersetzen
		lng_rmp_RemapInsert           = Neue Belegung der Einfg-Taste (Ins):
		lng_rmp_RemapNumLock          = Neue Belegung der Num-Taste (NumLock):
		lng_rmp_RemapScrollLock       = Neue Belegung der Rollen-Taste (ScrollLock):
		lng_rmp_DisableCapsX          = Ungewolltes aktivieren der Feststelltaste verhindern. (Deaktiviert neue Belegung der Feststelltaste)
		lng_rmp_NoShiftAtCapsLock     = Im Großschreibmodus werden Buchstaben mit der Umschalt-Taste nicht mehr klein geschrieben
		tooltip_rmp_ResetNumLock      = Aus = NumLock wird nicht verändert`nAktiviert = Der Ziffernblock wird bei jedem Start eingeschaltet`nGrau/Grün = Der Ziffernblock wird bei jedem Start ausgeschaltet
	}
	Else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorharcln)
	{
		MenuName                      = %rmp_ScriptName% - Remap the CapsLock key / simulate windows-key
		Description                   = Allows to remap the CapsLock key or to simulate the windows-key.
		lng_rmp_RemapCapsLock         = Remap CapsLock to:
		lng_rmp_CapsStatus            = Reset CapsLock state
		lng_rmp_ResetNumLock          = Reset NumLock state
		lng_rmp_SimWin                = Simulate windows-key
		lng_rmp_SimWinHold            = only if held for a second
		lng_rmp_HotkeyButtonMsg       = windows-key detected,`nplease release and press additional keys.
		lng_rmp_NumpadPoint           = Replace numpad-comma with a dot
		lng_rmp_RemapInsert           = Remap Ins to:
		lng_rmp_RemapNumLock          = Remap NumLock to:
		lng_rmp_RemapScrollLock       = Remap ScrollLock to:
		lng_rmp_DisableCapsX          = Avoid unintentional enabling of CapsLock. (Deaktivates remapping of CapsLock)
		lng_rmp_NoShiftAtCapsLock     = Shift does not produce lower case letters in CapsLock mode
		tooltip_rmp_ResetNumLock      = Off = Don't change NumLock state`nOn = Reset NumLock state at every start to ON`nGray/Green = Reset NumLock state at every start to OFF
	}
	IniRead, rmp_RemapCapsLock, %ConfigFile%, %rmp_ScriptName%, RemapCapsLockTo, {CapsLock}
	IniRead, rmp_CapsStatus, %ConfigFile%, %rmp_ScriptName%, CapsLockStatus, 1
	IniRead, rmp_ResetNumLock, %ConfigFile%, %rmp_ScriptName%, ResetNumLock, 0
	IniRead, rmp_RemapInsert, %ConfigFile%, %rmp_ScriptName%, RemapInsertTo, {Ins}
	IniRead, rmp_RemapNumLock, %ConfigFile%, %rmp_ScriptName%, RemapNumLock, {NumLock}
	IniRead, rmp_RemapScrollLock, %ConfigFile%, %rmp_ScriptName%, RemapScrollLock, {ScrollLock}
	func_HotkeyRead( "rmp_SimWin",     ConfigFile, rmp_ScriptName, "SimulateWinKey","rmp_sub_SimWin",   "", "$*" )
	IniRead, rmp_SimWinHold, %ConfigFile%, %rmp_ScriptName%, SimulateWinKeyOnHold, 1
	IniRead, rmp_NumpadPoint, %ConfigFile%, %rmp_ScriptName%, NumpadPoint, 0
	IniRead, rmp_CapsLockX, %ConfigFile%, %rmp_ScriptName%, CapsLockX, 0
	IniRead, rmp_NoShiftAtCapsLock, %ConfigFile%, %rmp_ScriptName%, NoShiftAtCapsLock, 0
Return

SettingsGui_RemapKeys:
	Gui +Delimiter`n
	StringReplace, rmp_RemapKeys, InputEscapeKeysAndDevices, }}, RemapK}, A
	StringReplace, rmp_RemapKeys, rmp_RemapKeys, }, }`n, A
	StringReplace, rmp_RemapKeys, rmp_RemapKeys, RemapK}, }}, A

	rmp_RemapKeys = `n{CapsLock}`n{Shift}`n{LWin}`n{RWin}`n{Alt}`n{Ctrl}`n%rmp_RemapKeys%{LWin}`n{RWin}`n{LShift}`n{RShift}`n{LAlt}`n{RAlt}`n{LCtrl}`n{RCtrl}

	If Lng = 07
		rmp_Wd = 220
	Else
		rmp_Wd = 110

	Gui, Add, Text, xs+10 y+8 w%rmp_Wd%, %lng_rmp_RemapCapsLock%
	Gui, Add, ComboBox, x+5 yp-4 gsub_CheckIfSettingsChanged vrmp_RemapCapsLock, %rmp_RemapKeys%
	IfNotInstring, rmp_RemapKeys, %rmp_RemapCapsLock%
		GuiControl, , rmp_RemapInsert, %rmp_RemapCapsLock%
	GuiControl, ChooseString, rmp_RemapCapsLock, %rmp_RemapCapsLock%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged x+10 yp+4 vrmp_CapsStatus Checked%rmp_CapsStatus%, %lng_rmp_CapsStatus%

	Gui, Add, Text, xs+10 y+11 w%rmp_Wd%, %lng_rmp_RemapInsert%
	Gui, Add, ComboBox, x+5 yp-4 gsub_CheckIfSettingsChanged vrmp_RemapInsert, %rmp_RemapKeys%
	IfNotInstring, rmp_RemapKeys, %rmp_RemapInsert%
		GuiControl, , rmp_RemapInsert, %rmp_RemapInsert%
	GuiControl, ChooseString, rmp_RemapInsert, %rmp_RemapInsert%

	Gui, Add, Text, xs+10 y+8 w%rmp_Wd%, %lng_rmp_RemapNumLock%
	Gui, Add, ComboBox, x+5 yp-4 gsub_CheckIfSettingsChanged vrmp_RemapNumLock, %rmp_RemapKeys%
	IfNotInstring, rmp_RemapKeys, %rmp_RemapNumLock%
		GuiControl, , rmp_RemapInsert, %rmp_RemapNumLock%
	GuiControl, ChooseString, rmp_RemapNumLock, %rmp_RemapNumLock%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged x+10 yp+4 Check3 vrmp_ResetNumLock Checked%rmp_ResetNumLock%, %lng_rmp_ResetNumLock%

	Gui, Add, Text, xs+10 y+11 w%rmp_Wd%, %lng_rmp_RemapScrollLock%
	Gui, Add, ComboBox, x+5 yp-4 gsub_CheckIfSettingsChanged vrmp_RemapScrollLock, %rmp_RemapKeys%
	IfNotInstring, rmp_RemapKeys, %rmp_RemapScrollLock%
		GuiControl, , rmp_RemapInsert, %rmp_RemapScrollLock%
	GuiControl, ChooseString, rmp_RemapScrollLock, %rmp_RemapScrollLock%

	Gui, Add, Text, y+15 xs+10, %lng_rmp_SimWin%:
	func_HotkeyAddGuiControl( "", "rmp_SimWin", "x+5 YP-3 W130", 2 )
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged x+10 yp+3 vrmp_SimWinHold Checked%rmp_SimWinHold%, %lng_rmp_SimWinHold%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+10 y+15 vrmp_NumpadPoint Checked%rmp_NumpadPoint%, %lng_rmp_NumpadPoint%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+10 y+15 vrmp_CapsLockX Checked%rmp_CapsLockX%, %lng_rmp_DisableCapsX%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+10 y+15 vrmp_NoShiftAtCapsLock Checked%rmp_NoShiftAtCapsLock%, %lng_rmp_NoShiftAtCapsLock%
	Gui +Delimiter|
Return

; wird aufgerufen, wenn im Konfigurationsdialog OK oder Übernehmen angeklickt wird
SaveSettings_RemapKeys:
	If rmp_CapsState = D
		Send, {CapsLock}
	func_HotkeyWrite( "rmp_SimWin", ConfigFile, rmp_ScriptName, "SimulateWinKey")
	IniWrite, %rmp_RemapCapsLock%, %ConfigFile%, %rmp_ScriptName%, RemapCapsLockTo
	IniWrite, %rmp_CapsStatus%, %ConfigFile%, %rmp_ScriptName%, CapsLockStatus
	IniWrite, %rmp_ResetNumLock%, %ConfigFile%, %rmp_ScriptName%, ResetNumLock
	IniWrite, %rmp_RemapInsert%, %ConfigFile%, %rmp_ScriptName%, RemapInsertTo
	IniWrite, %rmp_RemapNumLock%, %ConfigFile%, %rmp_ScriptName%, RemapNumLock
	IniWrite, %rmp_RemapScrollLock%, %ConfigFile%, %rmp_ScriptName%, RemapScrollLock
	IniWrite, %rmp_SimWinHold%, %ConfigFile%, %rmp_ScriptName%, SimulateWinKeyOnHold
	IniWrite, %rmp_NumpadPoint%, %ConfigFile%, %rmp_ScriptName%, NumpadPoint
	IniWrite, %rmp_CapsLockX%, %ConfigFile%, %rmp_ScriptName%, CapsLockX
	IniWrite, %rmp_NoShiftAtCapsLock%, %ConfigFile%, %rmp_ScriptName%, NoShiftAtCapsLock
Return

; Wird aufgerufen, wenn Einstellungen über das 'Pfeil'-Menü hinzugefügt werden, ist nur notwendig wenn AddSettings_RemapKeys = 1
AddSettings_RemapKeys:
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_RemapKeys:
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_RemapKeys:
	If rmp_CapsStatus = 1
		SetCapsLockState,OFF
	If rmp_ResetNumLock = 1
		SetNumLockState, On
	Else If rmp_ResetNumLock = -1
		SetNumLockState, Off

	If Enable_KeyState = 1
	{
		GetKeyState, ks_prevCapsLock  , CapsLock  , T
		GetKeyState, ks_prevScrollLock, ScrollLock, T
		GetKeyState, ks_prevNumLock   , NumLock   , T
		If ks_SoundForInsert = 1
			GetKeyState, ks_prevInsert    , Insert    , T
		ks_prevSuspended := 0
	}

	If rmp_CapsLockX = 0
	{
		Hotkey, $*CapsLock, rmp_sub_CapsLockX, Off
		Hotkey, $*CapsLock Up, rmp_sub_CapsLockXUp, Off
		If rmp_RemapCapsLock = {CapsLock}
		{
		  Hotkey, $*CapsLock, rmp_sub_CapsLock, Off
		  Hotkey, $*CapsLock Up, rmp_sub_CapsLockUp, Off
		}
		Else
		{
		  Hotkey, $*CapsLock, rmp_sub_CapsLock, On
		  Hotkey, $*CapsLock Up, rmp_sub_CapsLockUp, On
		}
	}
	Else
	{
		Hotkey, CapsLock, rmp_sub_CapsLockX, On
		Hotkey, $*CapsLock Up, rmp_sub_CapsLockXUp, On
	}
	If rmp_RemapInsert = {Ins}
	{
		Hotkey, $*Ins, rmp_sub_Insert, Off
		Hotkey, $*Ins Up, rmp_sub_InsertUp, Off
	}
	Else
	{
		Hotkey, $*Ins, rmp_sub_Insert, On
		Hotkey, $*Ins Up, rmp_sub_InsertUp, On
	}
	If rmp_RemapNumLock = {NumLock}
	{
		Hotkey, $*NumLock, rmp_sub_NumLock, Off
		Hotkey, $*NumLock Up, rmp_sub_NumLockUp, Off
	}
	Else
	{
		Hotkey, $*NumLock, rmp_sub_NumLock, On
		Hotkey, $*NumLock Up, rmp_sub_NumLockUp, On
	}
	If rmp_RemapScrollLock = {ScrollLock}
	{
		Hotkey, $*ScrollLock, rmp_sub_ScrollLock, Off
		Hotkey, $*ScrollLock Up, rmp_sub_ScrollLockUp, Off
	}
	Else
	{
		Hotkey, $*ScrollLock, rmp_sub_ScrollLock, On
		Hotkey, $*ScrollLock Up, rmp_sub_ScrollLockUp, On
	}
	func_HotkeyEnable( "rmp_SimWin" )
	If rmp_NumpadPoint = 1
	{
		Hotkey, NumpadDot, rmp_sub_NumpadPoint, On
		Hotkey, NumpadDot Up, rmp_sub_NumpadPointUp, On
	}
	If rmp_NoShiftAtCapsLock = 1
	{
		Hotkey, $~Shift, rmp_sub_NoShiftAtCapsLock, On
		Hotkey, $~Shift Up, rmp_sub_NoShiftAtCapsLockUp, On
	}

	GetKeyState, rmp_CapsState, CapsLock, T
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern der Einstellungen aufgerufen
DoDisable_RemapKeys:
	Hotkey, $*CapsLock, rmp_sub_CapsLockX, Off
	Hotkey, $*CapsLock Up, rmp_sub_CapsLockXUp, Off
	Hotkey, $*CapsLock, rmp_sub_CapsLock, Off
	Hotkey, $*CapsLock Up, rmp_sub_CapsLockUp, Off
	Hotkey, $*Ins, rmp_sub_Insert, Off
	Hotkey, $*Ins Up, rmp_sub_InsertUp, Off
	Hotkey, $*NumLock, rmp_sub_NumLock, Off
	Hotkey, $*NumLock Up, rmp_sub_NumLockUp, Off
	Hotkey, $*ScrollLock, rmp_sub_ScrollLock, Off
	Hotkey, $*ScrollLock Up, rmp_sub_ScrollLockUp, Off
	func_HotkeyDisable( "rmp_SimWin" )
	Hotkey, NumpadDot, rmp_sub_NumpadPoint, Off
	Hotkey, NumpadDot Up, rmp_sub_NumpadPointUp, Off
	Hotkey, $~Shift, rmp_sub_NoShiftAtCapsLock, Off
	Hotkey, $~Shift Up, rmp_sub_NoShiftAtCapsLockUp, Off
Return

; wird aufgerufen, wenn der Anwender die Erweiterung auf die Standard-Einstellungen zurücksetzt
DefaultSettings_RemapKeys:
Return

; wird aufgerufen, wenn ac'tivAid beendet oder neu geladen wird.
OnExitAndReload_RemapKeys:
Return

Update_RemapKeys:
	IniRead, SimWin, %ConfigFile%, WindowsControl, SimulateWinKey
	IniRead, SimWinHold, %ConfigFile%, WindowsControl, SimulateWinKeyOnHold
	If SimWin <> ERROR
	{
		IniWrite, %SimWin%, %ConfigFile%, RemapKeys, SimulateWinKey
		IniWrite, %SimWinHold%, %ConfigFile%, RemapKeys, SimulateWinKeyOnHold
		IniDelete, %ConfigFile%, WindowsControl, SimulateWinKey
		IniDelete, %ConfigFile%, WindowsControl, SimulateWinKeyOnHold
	}
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

rmp_sub_CapsLockX:
	rmp_CapsLockXInput =
	If rmp_CapsLockX =
		Return
	Send {Shift DOWN}
	Input, rmp_CapsLockXInput, C V I L1
Return
rmp_sub_CapsLockXUp:
	If rmp_CapsLockX =
		Return
	If rmp_CapsLockXInput =
	{
		GetKeyState, rmp_state, CapsLock, T
		if rmp_state = D
			SetCapsLockState,Off
		else
			SetCapsLockState,On
	}
	Send {Shift UP}
Return

rmp_sub_NoShiftAtCapsLock:
	GetKeyState, rmp_CapsStateShift, CapsLock, T
	SetCapsLockState, Off
Return

rmp_sub_NoShiftAtCapsLockUp:
	If rmp_CapsStateShift = D
		SetCapsLockState, On
Return

rmp_sub_CapsLock:
	If rmp_RemapCapsLock =
		Return
	SetKeyDelay -1
	StringReplace, rmp_RemapCapsLockTmp, rmp_RemapCapsLock, }, %A_Space%Down}, A
	StringReplace, rmp_RemapCapsLockTmp, rmp_RemapCapsLockTmp, %A_Space%Down}%A_Space%Down}, }%A_Space%Down}, A
	SendEvent, {Blind}%rmp_RemapCapsLockTmp%
Return

rmp_sub_CapsLockUp:
	If rmp_RemapCapsLock =
		Return
	SetKeyDelay -1
	StringReplace, rmp_RemapCapsLockTmp, rmp_RemapCapsLock, }, %A_Space%Up}, A
	StringReplace, rmp_RemapCapsLockTmp, rmp_RemapCapsLockTmp, %A_Space%Up}%A_Space%Up}, }%A_Space%Up}, A
	SendEvent, {Blind}%rmp_RemapCapsLockTmp%
Return

rmp_sub_Insert:
	If rmp_RemapInsert =
		Return
	SetKeyDelay -1
	StringReplace, rmp_RemapInsertTmp, rmp_RemapInsert, }, %A_Space%Down}, A
	StringReplace, rmp_RemapInsertTmp, rmp_RemapInsertTmp, %A_Space%Down}%A_Space%Down}, }%A_Space%Down}, A
	SendEvent, {Blind}%rmp_RemapInsertTmp%
Return

rmp_sub_InsertUp:
	If rmp_RemapInsert =
		Return
	SetKeyDelay -1
	StringReplace, rmp_RemapInsertTmp, rmp_RemapInsert, }, %A_Space%Up}, A
	StringReplace, rmp_RemapInsertTmp, rmp_RemapInsertTmp, %A_Space%Up}%A_Space%Up}, }%A_Space%Up}, A
	SendEvent, {Blind}%rmp_RemapInsertTmp%
Return

rmp_sub_NumLock:
	If rmp_RemapNumLock =
		Return
	SetKeyDelay -1
	StringReplace, rmp_RemapNumLockTmp, rmp_RemapNumLock, }, %A_Space%Down}, A
	StringReplace, rmp_RemapNumLockTmp, rmp_RemapNumLockTmp, %A_Space%Down}%A_Space%Down}, }%A_Space%Down}, A
	SendEvent, {Blind}%rmp_RemapNumLockTmp%
Return

rmp_sub_NumLockUp:
	If rmp_RemapNumLock =
		Return
	SetKeyDelay -1
	StringReplace, rmp_RemapNumLockTmp, rmp_RemapNumLock, }, %A_Space%Up}, A
	StringReplace, rmp_RemapNumLockTmp, rmp_RemapNumLockTmp, %A_Space%Up}%A_Space%Up}, }%A_Space%Up}, A
	SendEvent, {Blind}%rmp_RemapNumLockTmp%
Return

rmp_sub_ScrollLock:
	If rmp_RemapScrollLock =
		Return
	SetKeyDelay -1
	StringReplace, rmp_RemapScrollLockTmp, rmp_RemapScrollLock, }, %A_Space%Down}, A
	StringReplace, rmp_RemapScrollLockTmp, rmp_RemapScrollLockTmp, %A_Space%Down}%A_Space%Down}, }%A_Space%Down}, A
	SendEvent, {Blind}%rmp_RemapScrollLockTmp%
Return

rmp_sub_ScrollLockUp:
	If rmp_RemapScrollLock =
		Return
	SetKeyDelay -1
	StringReplace, rmp_RemapScrollLockTmp, rmp_RemapScrollLock, }, %A_Space%Up}, A
	StringReplace, rmp_RemapScrollLockTmp, rmp_RemapScrollLockTmp, %A_Space%Up}%A_Space%Up}, }%A_Space%Up}, A
	SendEvent, {Blind}%rmp_RemapScrollLockTmp%
Return

rmp_sub_NumpadPoint:
	SetKeyDelay -1
	SendEvent, {Blind}{. Down}
Return

rmp_sub_NumpadPointUp:
	SetKeyDelay -1
	SendEvent, {Blind}{. Up}
Return

rmp_sub_SimWin:
	StringReplace, rmp_THKplain, A_ThisHotkey, $,
	StringReplace, rmp_THKplain, rmp_THKplain, *,
	StringReplace, rmp_THKplain, rmp_THKplain, ~,
	StringLower, rmp_THKplain, rmp_THKplain
	If rmp_SimWinHold = 1
	{
		KeyWait, %rmp_THKplain%, T0.2
		GetKeyState, rmp_SimWinState, %rmp_THKplain%,p
		If rmp_SimWinState = D
		{
			tooltip,WIN
			SendEvent, {Blind}{LWin Down}%rmp_AppendToWin%
			KeyWait, %rmp_THKplain%
			If A_ThisHotkey <> $*%Hotkey_rmp_SimWin%
				SendEvent, {Blind}{SC07E}
			SendEvent, {Blind}{LWin Up}
			tooltip
		}
		Else
		{
			SendEvent, {Blind}{%rmp_THKplain% Down}
			SendEvent, {Blind}{%rmp_THKplain% Up}
		}
	}
	Else
	{
		tooltip,WIN
		SetKeyDelay, 0
		SendEvent, {Blind}{LWin Down}%rmp_AppendToWin%
		KeyWait, %rmp_THKplain%
		If A_ThisHotkey <> $*%Hotkey_rmp_SimWin%
			SendEvent, {Blind}{SC07E}
		SendEvent, {Blind}{LWin Up}
		tooltip
	}
Return
