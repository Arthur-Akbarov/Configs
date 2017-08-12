; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               LimitMouse
; -----------------------------------------------------------------------------
; Prefix:             lm_
; Version:            1.2.1
; Date:               2007-12-21
; Author:             Jack Tissen, Michael Telgkamp
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_LimitMouse:
	Prefix = lm
	%Prefix%_ScriptName    = LimitMouse
	%Prefix%_ScriptVersion = 1.2.1
	%Prefix%_Author        = Jack Tissen, Michael Telgkamp
	IconFile_On_LimitMouse  = %A_WinDir%\system32\rcimlby.exe
	IconPos_On_LimitMouse   = 1

	CustomHotkey_LimitMouse = 0
	Hotkey_LimitMouse       =
	HotkeyPrefix_LimitMouse =

	IconFile_On_  = %A_WinDir%\system32\main.cpl
	IconPos_On_  = 13

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %lm_ScriptName% - Begrenzen der Maus
		Description                   = Maus auf aktuellen Bildschirm oder einem Fenster begrenzen.

		lng_lm_LimitMonLbl            = Maus auf aktuellen Bildschirm begrenzen
		lng_lm_LimitWinLbl            = Maus auf das aktive Fenster begrenzen
		lng_lm_LimitCliLbl            = Maus auf den Arbeitsbereich des aktiven Fensters begrenzen
		lng_lm_LimitOffLbl            = Begrenzung ausschalten
		lng_lm_LimitOff               = Begrenzung ausgeschaltet
		lng_lm_ToggleMode             = Die Begrenzung wird bei erneutem Betätigen der Tastaturkürzel wieder ausgeschaltet
		lng_lm_LimitedToMonitor       = Begrenzung auf Monitor
		lng_lm_LimitedToWindow        = Begrenzung auf Fenster
		lng_lm_LimitedToClient        = Begrenzung auf Arbeitsbereich
		lng_lm_LimitMethod            = Systemroutine für die Begrenzung verwenden (ClipCursor)
		lng_lm_TempLimit              = Temporär horizontal/vertikal begrenzen
		lng_lm_Threshold              = Schwellenwert (Pixel)
		lng_lm_LimitHorizontally      = Horizontal begrenzt
		lng_lm_LimitVertically        = Vertical begrenzt
		lng_lm_AutoLimitToMonitor     = Beim Start von ac'tivAid automatisch auf Hauptmonitor beschränken
		lng_lm_LimitToPrimaryMonitor  = Begrenzung auf Hauptmonitor
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %lm_ScriptName% - Limit Mouse
		Description                   = Limit mouse to windows or monitors

		lng_lm_LimitMonLbl            = Limit mouse to active monitor
		lng_lm_LimitWinLbl            = Limit mouse to active window
		lng_lm_LimitCliLbl            = Limit mouse to client area of active window
		lng_lm_LimitOffLbl            = Turn off limit
		lng_lm_LimitOff               = Disabled
		lng_lm_ToggleMode             = The hotkeys toggles LimitMouse
		lng_lm_LimitedToMonitor       = Enabled on monitor
		lng_lm_LimitedToWindow        = Enabled on window
		lng_lm_LimitedToClient        = Enabled on client area
		lng_lm_LimitMethod            = Use system routine to limit the mouse (ClipCursor)
		lng_lm_TempLimit              = Limit mouse temporary horizontally/vertically
		lng_lm_Threshold              = Threshold (Pixel)
		lng_lm_LimitHorizontally      = Limit horizontally
		lng_lm_LimitVertically        = Limit vertically
		lng_lm_AutoLimitToMonitor     = Automatically limit to primary montior when ac'tivAid starts
		lng_lm_LimitToPrimaryMonitor  = Enabled on primary monitor
	}
	func_HotkeyRead( "lm_LimitMon", ConfigFile, lm_ScriptName, "Hotkey_LimitMon", "lm_sub_HK_LimitMon", "" )
	func_HotkeyRead( "lm_LimitWin", ConfigFile, lm_ScriptName, "Hotkey_LimitWin", "lm_sub_HK_LimitWin", "" )
	func_HotkeyRead( "lm_LimitCli", ConfigFile, lm_ScriptName, "Hotkey_LimitCli", "lm_sub_HK_LimitCli", "" )
	func_HotkeyRead( "lm_LimitOff", ConfigFile, lm_ScriptName, "Hotkey_LimitOff", "lm_sub_HK_LimitOff", "" )
	IniRead, lm_DoToggle, %ConfigFile%, %lm_ScriptName%, ToggleMode, 1
	IniRead, lm_LimitMethod, %ConfigFile%, %lm_ScriptName%, LimitMethod, 1
	IniRead, Hotkey_lm_TempLimit, %ConfigFile%, %lm_ScriptName%, Key_TempLimit, %A_Space%
	IniRead, lm_TempLimitThreshold, %ConfigFile%, %lm_ScriptName%, TempLimitThreshold, 5
	IniRead, lm_AutoLimitToMonitor, %ConfigFile%, %lm_ScriptName%, AutoLimitToMonitor, 0

	Hotkey_lm_TempLimit_new := Hotkey_lm_TempLimit

	lm_LimitMode = Off
	lm_LimitMonNr = -1
	VarSetCapacity(lm_Rect, 16)
	VarSetCapacity(lm_TempRect, 16)
Return

SettingsGui_LimitMouse:
	func_HotkeyAddGuiControl(lng_lm_LimitMonLbl, "lm_LimitMon", "xs+10 y+10 w210")
	func_HotkeyAddGuiControl(lng_lm_LimitWinLbl, "lm_LimitWin", "xs+10 y+10 w210")
	func_HotkeyAddGuiControl(lng_lm_LimitCliLbl, "lm_LimitCli", "xs+10 y+10 w210")
	func_HotkeyAddGuiControl(lng_lm_LimitOffLbl, "lm_LimitOff", "xs+10 y+18 w210")
	func_HotkeyAddGuiControl(lng_lm_TempLimit, "lm_TempLimit", "xs+10 y+10 w210", 2,"w140")
	Gui, Add, Text, x+5 yp+3, %lng_lm_Threshold%:
	Gui, Add, Edit, -Wrap R1 W50 x+5 yp-3 gsub_CheckIfSettingsChanged
	Gui, Add, UpDown, vlm_TempLimitThreshold gsub_CheckIfSettingsChanged, %lm_TempLimitThreshold%

	Gui, Add, CheckBox, -Wrap xs+10 y+20 vlm_DoToggle gsub_CheckIfSettingsChanged Checked%lm_DoToggle%, %lng_lm_ToggleMode%
	Gui, Add, CheckBox, -Wrap xs+10 y+10 vlm_LimitMethod gsub_CheckIfSettingsChanged Checked%lm_LimitMethod%, %lng_lm_LimitMethod%
	Gui, Add, CheckBox, -Wrap xs+10 y+10 vlm_AutoLimitToMonitor gsub_CheckIfSettingsChanged Checked%lm_AutoLimitToMonitor%, %lng_lm_AutoLimitToMonitor%
Return

SaveSettings_LimitMouse:
	func_HotkeyWrite("lm_LimitMon", ConfigFile, lm_ScriptName, "Hotkey_LimitMon")
	func_HotkeyWrite("lm_LimitWin", ConfigFile, lm_ScriptName, "Hotkey_LimitWin")
	func_HotkeyWrite("lm_LimitCli", ConfigFile, lm_ScriptName, "Hotkey_LimitCli")
	func_HotkeyWrite("lm_LimitOff", ConfigFile, lm_ScriptName, "Hotkey_LimitOff")
	IniWrite, %lm_DoToggle%, %ConfigFile%, %lm_ScriptName%, ToggleMode
	IniWrite, %lm_LimitMethod%, %ConfigFile%, %lm_ScriptName%, LimitMethod
	Hotkey_lm_TempLimit := Hotkey_lm_TempLimit_new
	IniWrite, %Hotkey_lm_TempLimit%, %ConfigFile%, %lm_ScriptName%, Key_TempLimit
	IniWrite, %lm_AutoLimitToMonitor%, %ConfigFile%, %lm_ScriptName%, AutoLimitToMonitor
Return

AddSettings_LimitMouse:
Return

CancelSettings_LimitMouse:
Return

DoEnable_LimitMouse:
	func_HotkeyEnable("lm_LimitMon")
	func_HotkeyEnable("lm_LimitWin")
	func_HotkeyEnable("lm_LimitCli")
	func_HotkeyEnable("lm_LimitOff")
	If (lm_LimitMode = "Mon" OR lm_LimitMode = "Win" OR lm_LimitMode = "Cli")
		SetTimer, lm_sub_WatchMouseMove, 10

	If Hotkey_lm_TempLimit <>
	{
		lm_Key1 =
		lm_Key2 =
		lm_Key3 =
		lm_Key := Hotkey_lm_TempLimit
		StringReplace, lm_Key, lm_Key, #!L, LWin LAlt L
		StringReplace, lm_Key, lm_Key, #!R, RWin RAlt R
		StringReplace, lm_Key, lm_Key, !#L, LWin LAlt L
		StringReplace, lm_Key, lm_Key, !#R, RWin RAlt R
		StringReplace, lm_Key, lm_Key, !L, LAlt L
		StringReplace, lm_Key, lm_Key, !R, RAlt R
		StringReplace, lm_Key, lm_Key, #L, LWin L
		StringReplace, lm_Key, lm_Key, #R, RWin R
		StringSplit, lm_Key, lm_Key, %A_Space%
		SetTimer, lm_tim_TempLimit, 20
	}

	RegisterAction("lm_LimitMon", lng_lm_LimitMonLbl, "lm_sub_HK_LimitMon")
	RegisterAction("lm_LimitWin", lng_lm_LimitWinLbl, "lm_sub_HK_LimitWin")
	RegisterAction("lm_LimitCli", lng_lm_LimitWinLbl, "lm_sub_HK_LimitCli")
	RegisterAction("lm_LimitOff", lng_lm_LimitOffLbl, "lm_sub_HK_LimitOff")

	If lm_AutoLimitToMonitor = 1
	{
		SetTimer, sub_AutoLimitToMonitor, -1000
	}
Return

sub_AutoLimitToMonitor:
	lm_LimitMonNr := ""
	lm_LimitMode = Mon
	SetTimer, lm_sub_WatchMouseMove, 10
Return

DoDisable_LimitMouse:
	func_HotkeyDisable("lm_LimitMon")
	func_HotkeyDisable("lm_LimitWin")
	func_HotkeyDisable("lm_LimitCli")
	func_HotkeyDisable("lm_LimitOff")
	lm_NoBalloonTip = 1
	Gosub lm_sub_HK_LimitOff
	lm_NoBalloonTip =
	SetTimer, lm_tim_TempLimit, Off

	unRegisterAction("lm_LimitMon")
	unRegisterAction("lm_LimitWin")
	unRegisterAction("lm_LimitCli")
	unRegisterAction("lm_LimitOff")
Return

DefaultSettings_LimitMouse:
Return
OnExitAndReload_LimitMouse:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

lm_sub_HK_LimitMon:
	;ToggleMode?
	if (lm_DoToggle And lm_LimitMode = "Mon")
	{
		Gosub lm_sub_HK_LimitOff
		Return
	}

	;Get active Monitor
	lm_LimitMonNr := func_GetMonitorNumber("Mouse")
	lm_LimitMode = Mon
	BalloonTip(lm_ScriptName, lng_lm_LimitedToMonitor ": " lm_LimitMonNr, "Info", 0, -1, 5)
	SetTimer, lm_sub_WatchMouseMove, 10
Return

lm_sub_HK_LimitWin:
	;ToggleMode?
	if (lm_DoToggle And lm_LimitMode = "Win")
	{
		Gosub lm_sub_HK_LimitOff
		Return
	}

	lm_LimitMode = Win
	WinGetTitle, lm_Txt, A
	WinGet, lm_WinID, ID, A
	BalloonTip(lm_ScriptName, lng_lm_LimitedToWindow ": " lm_Txt, "Info", 0, -1, 5)
	SetTimer, lm_sub_WatchMouseMove, 10
Return

lm_sub_HK_LimitCli:
	;ToggleMode?
	if (lm_DoToggle And lm_LimitMode = "Cli")
	{
		Gosub lm_sub_HK_LimitOff
		Return
	}

	lm_LimitMode = Cli
	WinGetTitle, lm_Txt, A
	WinGet, lm_WinID, ID, A
	BalloonTip(lm_ScriptName, lng_lm_LimitedToClient ": " lm_Txt, "Info", 0, -1, 5)
	SetTimer, lm_sub_WatchMouseMove, 10
Return

lm_sub_HK_LimitOff:
	If lm_LimitMode = Off
		Return

	lm_LimitMode = Off
	SetTimer, lm_sub_WatchMouseMove, Off
	lm_Rect := ""
	DllCall("ClipCursor", Int, 0)
	lm_ClippingOn =
	If lm_NoBalloonTip =
		BalloonTip(lm_ScriptName, lng_lm_LimitOff, "Info", 0, -1, 5)
	lm_LastMinX := ""
	lm_LastMinY := ""
	lm_LastMaxX := ""
	lm_LastMaxY := ""
Return

lm_sub_WatchMouseMove:
	If lm_LimitMode = Mon
	{
		;Get direct, it may change
		lm_MinX := Monitor%lm_LimitMonNr%Left
		lm_MinY := Monitor%lm_LimitMonNr%Top
		lm_MaxX := Monitor%lm_LimitMonNr%Right
		lm_MaxY := Monitor%lm_LimitMonNr%Bottom
	}
	Else If lm_LimitMode = Win
	{
		WinGetPos, lm_X, lm_Y, lm_W, lm_H, ahk_id %lm_WinID%
		lm_MinX := lm_X
		lm_MinY := lm_Y
		lm_MaxX := lm_X+lm_W
		lm_MaxY := lm_Y+lm_H
	}
	Else If lm_LimitMode = Cli
	{
		WinGet, hWnd, ID, A
		VarSetCapacity(rt, 16, 0)
		DllCall("GetClientRect" , "Uint", hWnd, "Uint", &rt)
		DllCall("ClientToScreen", "Uint", hWnd, "Uint", &rt)
		lm_MinX := NumGet(rt, 0, "int")
		lm_MinY := NumGet(rt, 4, "int")
		lm_MaxX := lm_MinX + NumGet(rt, 8)
		lm_MaxY := lm_MinY + NumGet(rt,12)
	}
	Else
	{
		SetTimer, lm_sub_WatchMouseMove, Off
		BalloonTip(lm_ScriptName, lng_lm_LimitOff, "Info", 0, -1, 5)
		lm_LastMinX := ""
		lm_LastMinY := ""
		lm_LastMaxX := ""
		lm_LastMaxY := ""
		Return
	}

	If lm_LimitMethod = 1
	{
		WinGet, lm_ActWinID, ID, A
		WinGetPos, lm_ActX, lm_ActY, lm_ActW, lm_ActH, A
		If (lm_LastWinID <> lm_ActWinID OR lm_ActX <> lm_LastX OR lm_ActY <> lm_LastY OR lm_ActW <> lm_LastW OR lm_ActH <> lm_LastH)
			lm_SetClip = 1
		If (lm_MinX = lm_LastMinX AND lm_MinY = lm_LastMinY AND lm_MaxX = lm_LastMaxX AND lm_MaxY = lm_LastMaxY)
		{
			If (lm_SetClip > 0 AND !GetKeyState("LButton") AND cr_Button <> "D")
			{
				NumPut(lm_MinX, lm_Rect, 0)  ; The first integer in the structure is "rect.left".
				NumPut(lm_MinY, lm_Rect, 4) ; The second integer in the structure is "rect.top".
				NumPut(lm_MaxX, lm_Rect, 8)  ; The third integer in the structure is "rect.right".
				NumPut(lm_MaxY, lm_Rect, 12) ; The fourth integer in the structure is "rect.bottom".
				DllCall("ClipCursor", Str, lm_Rect)
				lm_ClippingOn = 1
				lm_SetClip++
				If lm_SetClip = 3
					lm_SetClip =
			}
		}
		Else If lm_SetClip =
		{
			DllCall("ClipCursor", Str, 0)
			lm_SetClip = 1
			lm_ClippingOn =
		}
		lm_LastMinX := lm_MinX
		lm_LastMinY := lm_MinY
		lm_LastMaxX := lm_MaxX
		lm_LastMaxY := lm_MaxY
		lm_LastX := lm_ActX
		lm_LastY := lm_ActY
		lm_LastW := lm_ActW
		lm_LastH := lm_ActH
		lm_LastWinID := lm_ActWinID
	}
	Else
	{
		CoordMode, Mouse, Screen
		MouseGetPos, lm_PosX, lm_PosY
		If (lm_PosX < lm_MinX)
			MouseMove(lm_MinX, lm_PosY)
		If (lm_PosX > lm_MaxX-1)
			MouseMove(lm_MaxX-1, lm_PosY)
		If (lm_PosY < lm_MinY)
			MouseMove(lm_PosX, lm_MinY)
		If (lm_PosY > lm_MaxY-1)
			MouseMove(lm_PosX, lm_MaxY-1)
	}
Return

lm_tim_TempLimit:
	CoordMode, Mouse, Screen
	If (GetKeyState(lm_Key1) AND (GetKeyState(lm_Key2) OR lm_Key2 = "") AND (GetKeyState(lm_Key3) OR lm_Key3 = ""))
	{
		If lm_TempLimitStarted =
		{
			MouseGetPos, lm_TempLimitStartX, lm_TempLimitStartY
			lm_TempLimitStarted = 1
		}
		MouseGetPos, lm_TempLimitX, lm_TempLimitY

		; Horizontal
		If (Abs(lm_TempLimitStartX-lm_TempLimitX) > Abs(lm_TempLimitStartY-lm_TempLimitY) AND Abs(lm_TempLimitStartX-lm_TempLimitX) >= lm_TempLimitThreshold )
		{
			If lm_LimitMethod = 1
			{
				If lm_TempLimitClip <> h
				{
					lm_TempRect := ""
					DllCall("ClipCursor", Int, 0 )
					NumPut(MonitorAreaLeft, lm_TempRect, 0)  ; The first integer in the structure is "rect.left".
					NumPut(lm_TempLimitStartY, lm_TempRect, 4) ; The second integer in the structure is "rect.top".
					NumPut(MonitorAreaRight, lm_TempRect, 8)  ; The third integer in the structure is "rect.right".
					NumPut(lm_TempLimitStartY+1, lm_TempRect, 12) ; The fourth integer in the structure is "rect.bottom".
					DllCall("ClipCursor", Str, lm_TempRect)
					lm_TempLimitClip = h
				}
			}
			Else
				If (lm_TempLimitY <> lm_TempLimitStartY)
					MouseMove(lm_TempLimitX, lm_TempLimitStartY)
			Tooltip, %lng_lm_LimitHorizontally%,,,7
		}
		; Vertical
		Else If (Abs(lm_TempLimitStartX-lm_TempLimitX) < Abs(lm_TempLimitStartY-lm_TempLimitY) AND Abs(lm_TempLimitStartY-lm_TempLimitY) >= lm_TempLimitThreshold )
		{
			If lm_LimitMethod = 1
			{
				If lm_TempLimitClip <> v
				{
					lm_TempRect := ""
					DllCall("ClipCursor", Int, 0 )
					NumPut(lm_TempLimitStartX, lm_TempRect, 0)  ; The first integer in the structure is "rect.left".
					NumPut(MonitorAreaTop, lm_TempRect, 4) ; The second integer in the structure is "rect.top".
					NumPut(lm_TempLimitStartX+1, lm_TempRect, 8)  ; The third integer in the structure is "rect.right".
					NumPut(MonitorAreaBottom, lm_TempRect, 12) ; The fourth integer in the structure is "rect.bottom".
					DllCall("ClipCursor", Str, lm_TempRect)
					lm_TempLimitClip = v
				}
			}
			Else
				If (lm_TempLimitX <> lm_TempLimitStartX)
					MouseMove(lm_TempLimitStartX, lm_TempLimitY)
			Tooltip, %lng_lm_LimitVertically%,,,7
		}
		Else
			Gosub lm_sub_TempLimitOff
	}
	Else
	{
		lm_TempLimitStarted =
		Gosub lm_sub_TempLimitOff
	}
Return

lm_sub_TempLimitOff:
	If lm_LimitMethod = 1
	{
		If lm_TempLimitClip <>
		{
			If lm_ClippingOn = 1
			{
				lm_TempRect := ""
				lm_Temp := ""
				NumPut(lm_MinX, lm_Rect, 0)  ; The first integer in the structure is "rect.left".
				NumPut(lm_MinY, lm_Rect, 4) ; The second integer in the structure is "rect.top".
				NumPut(lm_MaxX, lm_Rect, 8)  ; The third integer in the structure is "rect.right".
				NumPut(lm_MaxY, lm_Rect, 12) ; The fourth integer in the structure is "rect.bottom".
				DllCall("ClipCursor", Str, lm_Rect)
			}
			Else
			{
				lm_TempRect := ""
				DllCall("ClipCursor", Int, 0)
			}
			lm_TempLimitClip =
		}
	}
	Tooltip, ,,,7
Return
