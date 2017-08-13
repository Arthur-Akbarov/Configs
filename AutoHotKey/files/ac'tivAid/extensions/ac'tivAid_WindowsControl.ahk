; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               WindowsControl
; -----------------------------------------------------------------------------
; Prefix:             wc_
; Version:            1.2
; Date:               2008-05-23
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_WindowsControl:
	Prefix = wc
	%Prefix%_ScriptName    = WindowsControl
	%Prefix%_ScriptVersion = 1.2
	%Prefix%_Author        = Wolfgang Reszel, Jack Tissen

	IconFile_On_WindowsControl = %A_WinDir%\system32\shell32.dll
	IconPos_On_WindowsControl = 170

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %wc_ScriptName% - Fensterfunktionen
		Description                   = Bietet Tastaturkürzel für Minimieren, Maximieren und Schließen.
		lng_wc_Min_Max                = Fenster minimieren/maximieren
		lng_wc_MaxLeft                = Fenster auf linke Hälfte maximieren
		lng_wc_MaxRight               = Fenster auf rechte Hälfte maximieren
		lng_wc_MaxTop                 = Fenster auf obere Hälfte maximieren
		lng_wc_MaxBottom              = Fenster auf untere Hälfte maximieren
		lng_wc_MaxHeight              = Fensterhöhe maximieren
		lng_wc_MaxWidth               = Fensterbreite maximieren
		lng_wc_Close1                 = Fenster
		lng_wc_Close2                 = Programm schließen
		lng_wc_Kill                   = Programm direkt beenden/abschießen `n(Achtung: evtl. Datenverlust)
		lng_wc_AOT                    = Fenster im Vordergrund halten
		lng_wc_WindowTransparency     = Fenster transparent setzen
		lng_wc_TransValue             = Transparenz:
		lng_wc_CantClose              = Die Anwendung kann nicht geschlossen werden,`nda sie evtl. noch auf Benutzereingaben wartet.`n`nWenn Sie diese Meldung ignorieren, `ngehen alle nicht gespeicherten Daten verloren.
		lng_wc_ResizeFixedWindows     = Auch Fenster mit fester Größe skalieren
		lng_wc_TransWithClickThrough  = 'Fenster transparent setzen' erzeugt Fenster, durch welche man hindurchklicken kann
		lng_wc_MinimizeToTitlebar     = Auf Titelleiste minimieren
		lng_wc_AOTModifyTitle         = 'Fenster im Vordergrund halten' verändert den Fenstertitel
		lng_wc_Center                 = Fenster zentrieren
	}
	else        ; = other languages (english)
	{
		MenuName                      = %wc_ScriptName% - window-management
		Description                   = Provides hotkeys for minimize, maximize and close.
		lng_wc_Min_Max                = Minimize/maximize window
		lng_wc_MaxLeft                = Maximize window on left
		lng_wc_MaxRight               = Mmaximize window on right
		lng_wc_MaxTop                 = Maximize window on top
		lng_wc_MaxBottom              = Maximize window on bottom
		lng_wc_MaxHeight              = Maximize window height
		lng_wc_MaxWidth               = Maximize window width
		lng_wc_Close1                 = Close window
		lng_wc_Close2                 = Program
		lng_wc_Kill                   = Kill program`n(Attention: data my be lost)
		lng_wc_AOT                    = Window always on top
		lng_wc_WindowTransparency     = Make window transparent
		lng_wc_TransValue             = Transparency:
		lng_wc_CantClose              = The application can't be closed. Maybe it waits for user-interaction.`n`nIf you ignore this message alls unsaved data will be lost!
		lng_wc_ResizeFixedWindows     = Also scale windows with fixed size
		lng_wc_TransWithClickThrough  = 'Make window transparent' creates click-through windows
		lng_wc_MinimizeToTitlebar     = Minimize to title bar
		lng_wc_AOTModifyTitle         = 'Window always on top' modifies the window title
		lng_wc_Center                 = Center window
	}
	If CustomLanguage <>
		gosub, CustomLanguage

	func_HotkeyRead( "wc_Min",        ConfigFile, wc_ScriptName, "Minimize",        "wc_sub_Min",      "#Space", "$" )
	func_HotkeyRead( "wc_Max",        ConfigFile, wc_ScriptName, "Maximize",        "wc_sub_Max",      "^#!Space", "$" )
	func_HotkeyRead( "wc_Center",     ConfigFile, wc_ScriptName, "Center",          "wc_sub_Center",   "^#!c", "$" )
	func_HotkeyRead( "wc_MaxLeft",    ConfigFile, wc_ScriptName, "MaximizeLeft",    "wc_sub_MaxLeft",  "^#!Left", "$" )
	func_HotkeyRead( "wc_MaxRight",   ConfigFile, wc_ScriptName, "MaximizeRight",   "wc_sub_MaxRight", "^#!Right", "$" )
	func_HotkeyRead( "wc_MaxTop",     ConfigFile, wc_ScriptName, "MaximizeTop",     "wc_sub_MaxTop",   "^#!Up", "$" )
	func_HotkeyRead( "wc_MaxBottom",  ConfigFile, wc_ScriptName, "MaximizeBottom",  "wc_sub_MaxBottom","^#!Down", "$" )
	func_HotkeyRead( "wc_MaxHeight",  ConfigFile, wc_ScriptName, "MaximizeHeight",  "wc_sub_MaxHeight","#h", "$" )
	func_HotkeyRead( "wc_MaxWidth",   ConfigFile, wc_ScriptName, "MaximizeWidth",   "wc_sub_MaxWidth", "#b", "$" )
	func_HotkeyRead( "wc_Close",      ConfigFile, wc_ScriptName, "Close",           "wc_sub_Close",    "#x", "$" )
	func_HotkeyRead( "wc_Kill",       ConfigFile, wc_ScriptName, "Kill",            "wc_sub_Kill",     "#+Delete", "$" )
	func_HotkeyRead( "wc_AOT",        ConfigFile, wc_ScriptName, "AlwaysOnTop",     "wc_sub_AOT",      "#+Home", "$" )
	func_HotkeyRead( "wc_Trans",      ConfigFile, wc_ScriptName, "Transparent",     "wc_sub_Trans",    "^#!t", "$" )
	func_HotkeyRead( "wc_MinToTitle", ConfigFile, wc_ScriptName, "MinimizeToTitle", "wc_sub_MinToTitle", "", "$" )
	IniRead, wc_TransVal, %ConfigFile%, %wc_ScriptName%, TransparenceValue, 200
	RegisterAdditionalSetting( "wc", "ResizeFixedWindows", 0 )
	RegisterAdditionalSetting( "wc", "TransWithClickThrough", 0 )
	RegisterAdditionalSetting( "wc", "AOTModifyTitle", 0 )
	IniRead, wc_CloseApp, %ConfigFile%, %wc_ScriptName%, CloseWholeApp, 1
Return

SettingsGui_WindowsControl:
	func_HotkeyAddGuiControl( lng_wc_Min_Max, "wc_Min",         "xs+10 y+4 W200", "", "W148" )
	func_HotkeyAddGuiControl( "", "wc_Max",                     "x+4 W148" )
	func_HotkeyAddGuiControl( lng_wc_Center, "wc_Center",       "xs+10 y+3 W200" )
	func_HotkeyAddGuiControl( lng_wc_MinimizeToTitlebar, "wc_MinToTitle", "xs+10 y+3 W200" )
	func_HotkeyAddGuiControl( lng_wc_MaxLeft, "wc_MaxLeft",     "xs+10 y+3 W200" )
	func_HotkeyAddGuiControl( lng_wc_MaxRight, "wc_MaxRight",   "xs+10 y+3 W200" )
	func_HotkeyAddGuiControl( lng_wc_MaxTop, "wc_MaxTop",       "xs+10 y+3 W200" )
	func_HotkeyAddGuiControl( lng_wc_MaxBottom, "wc_MaxBottom", "xs+10 y+3 W200" )
	func_HotkeyAddGuiControl( lng_wc_MaxHeight, "wc_MaxHeight", "xs+10 y+3 W200" )
	func_HotkeyAddGuiControl( lng_wc_MaxWidth, "wc_MaxWidth",   "xs+10 y+3 W200" )
	Gui, Add, Radio, -Wrap xs+10 y+4 gsub_CheckIfSettingsChanged vwc_CloseApp1, %lng_wc_Close1%
	Gui, Add, Radio, -Wrap x+5 gsub_CheckIfSettingsChanged vwc_CloseApp2, %lng_wc_Close2%
	GuiControl, , wc_CloseApp%wc_CloseApp%, 1
	func_HotkeyAddGuiControl( "", "wc_Close",         "xs+215 yp-4 w300" )
	func_HotkeyAddGuiControl( lng_wc_AOT, "wc_AOT",             "xs+10 y+3 W200" )
	func_HotkeyAddGuiControl( lng_wc_WindowTransparency, "wc_Trans","xs+10 y+3 W200" )
	Gui, Add, Edit, x+5 Number Limit3 w47 vwc_TransVal gsub_CheckIfSettingsChanged, %wc_TransVal%
	Gui, Add, UpDown, Range0-255, %wc_TransVal%
	func_HotkeyAddGuiControl( lng_wc_Kill, "wc_Kill",           "xs+10 y+2 W200" )
Return

SaveSettings_WindowsControl:
	Loop, 2
	{
		If wc_CloseApp%A_Index% = 1
			wc_CloseApp := A_Index
	}

	func_HotkeyWrite( "wc_Min", ConfigFile, wc_ScriptName, "Minimize")
	func_HotkeyWrite( "wc_Max", ConfigFile, wc_ScriptName, "Maximize")
	func_HotkeyWrite( "wc_MaxLeft", ConfigFile, wc_ScriptName, "MaximizeLeft")
	func_HotkeyWrite( "wc_MaxRight", ConfigFile, wc_ScriptName, "MaximizeRight")
	func_HotkeyWrite( "wc_MaxTop", ConfigFile, wc_ScriptName, "MaximizeTop")
	func_HotkeyWrite( "wc_MaxBottom", ConfigFile, wc_ScriptName, "MaximizeBottom")
	func_HotkeyWrite( "wc_MaxHeight", ConfigFile, wc_ScriptName, "MaximizeHeight")
	func_HotkeyWrite( "wc_MaxWidth", ConfigFile, wc_ScriptName, "MaximizeWidth")
	func_HotkeyWrite( "wc_Close", ConfigFile, wc_ScriptName, "Close")
	func_HotkeyWrite( "wc_Kill", ConfigFile, wc_ScriptName, "Kill")
	func_HotkeyWrite( "wc_AOT", ConfigFile, wc_ScriptName, "AlwaysOnTop")
	func_HotkeyWrite( "wc_Trans", ConfigFile, wc_ScriptName, "Transparent")
	func_HotkeyWrite( "wc_MinToTitle", ConfigFile, wc_ScriptName, "MinimizeToTitle")
	func_HotkeyWrite( "wc_Center", ConfigFile, wc_ScriptName, "Center")
	IniWrite, %wc_TransVal%, %ConfigFile%, %wc_ScriptName%, TransparenceValue
	IniWrite, %wc_CloseApp%, %ConfigFile%, %wc_ScriptName%, CloseWholeApp
Return

CancelSettings_WindowsControl:
Return

DoEnable_WindowsControl:
	func_HotkeyEnable( "wc_Min" )
	func_HotkeyEnable( "wc_Max" )
	func_HotkeyEnable( "wc_Center" )
	func_HotkeyEnable( "wc_MaxLeft" )
	func_HotkeyEnable( "wc_MaxRight" )
	func_HotkeyEnable( "wc_MaxTop" )
	func_HotkeyEnable( "wc_MaxBottom" )
	func_HotkeyEnable( "wc_MaxHeight" )
	func_HotkeyEnable( "wc_MaxWidth" )
	func_HotkeyEnable( "wc_Close" )
	func_HotkeyEnable( "wc_Kill" )
	func_HotkeyEnable( "wc_AOT" )
	func_HotkeyEnable( "wc_Trans" )
	func_HotkeyEnable( "wc_MinToTitle" )
Return

DoDisable_WindowsControl:
	func_HotkeyDisable( "wc_Min" )
	func_HotkeyDisable( "wc_Max" )
	func_HotkeyDisable( "wc_Center" )
	func_HotkeyDisable( "wc_MaxLeft" )
	func_HotkeyDisable( "wc_MaxRight" )
	func_HotkeyDisable( "wc_MaxTop" )
	func_HotkeyDisable( "wc_MaxBottom" )
	func_HotkeyDisable( "wc_MaxHeight" )
	func_HotkeyDisable( "wc_MaxWidth" )
	func_HotkeyDisable( "wc_Close" )
	func_HotkeyDisable( "wc_Kill" )
	func_HotkeyDisable( "wc_AOT" )
	func_HotkeyDisable( "wc_Trans" )
	func_HotkeyDisable( "wc_MinToTitle" )
Return

DefaultSettings_WindowsControl:
Return

OnExitAndReload_WindowsControl:
	Loop, Parse, wc_MinToTitleIDs, |
	{
		If (wc_MinToTitleWindowHeight%A_LoopField% <> "" AND wc_MinToTitleWindowWidth%A_LoopField% <> "")
		{
			If wc_MinToTitleWindowMax%A_LoopField% = 1
				WinMaximize, ahk_id %A_LoopField%
			Else
			{
				WinMove, ahk_id %A_LoopField%, , , , wc_MinToTitleWindowWidth%A_LoopField%, wc_MinToTitleWindowHeight%A_LoopField%
				; Speicherwerte zuruecksetzen
				wc_MinToTitleWindowHeight%A_LoopField% =
				wc_MinToTitleWindowWidth%A_LoopField%  =
				StringReplace, wc_MinToTitleIDs, wc_MinToTitleIDs, %A_LoopField%|,, A
			}
		}
	}
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

wc_sub_Min:
	Gosub, wc_sub_MouseHotkey
	If func_IsWindowInIgnoreList?()
		Return
	WinGet, wc_ID, ID, A
	WinSet, Bottom,, ahk_id %wc_ID%
	;WinMinimize, ahk_id %wc_ID%
	PostMessage,0x0112,0x0000f020,0x00f40390,,ahk_id %wc_ID%
Return

wc_sub_Max:
	Gosub, wc_sub_MouseHotkey
	WinGet, wc_Style, Style, A
	If ((!(wc_Style & 0x40000) AND wc_ResizeFixedWindows = 0) AND cr_Resizeable <> 1)
		Return
	WinGet, wc_MinMax, MinMax, A
	If wc_MinMax = 1
		WinRestore, A
	Else
	{
		WinMaximize, A
		wc_Monitor := func_GetMonitorNumber("A")
		WinMove, A,, WorkArea%wc_Monitor%Left, WorkArea%wc_Monitor%Top, WorkArea%wc_Monitor%Width, WorkArea%wc_Monitor%Height
	}
Return

wc_sub_Center:
	Gosub, wc_sub_MouseHotkey
	If func_IsWindowInIgnoreList?()
		Return
	wc_Monitor := func_GetMonitorNumber("A")
	; ID, Groesse und Position des aktuellen Fensters
	WinGet, wc_WindowID, ID, A
	WinGetPos, wc_X, wc_Y, wc_Width, wc_Height, A
	WinGet, wc_Max, MinMax, A
	
	; Maximiert? Mache nichts
	If (wc_X <> WorkArea%wc_Monitor%Left OR wc_Y <> WorkArea%wc_Monitor%Top OR wc_Width <> WorkArea%wc_Monitor%Width OR wc_Height <> WorkArea%wc_Monitor%Height)
	{
		wc_newX := WorkArea%wc_Monitor%Left + Floor(WorkArea%wc_Monitor%Width/2 - wc_Width/2)
		wc_newY := WorkArea%wc_Monitor%Top + Floor(WorkArea%wc_Monitor%Height/2 - wc_Height/2)
		
		WinMove, A,, wc_newX, wc_newY
	}
Return

wc_sub_MaxLeft:
	Gosub, wc_sub_MouseHotkey
	WinGet, wc_Style, Style, A
	If ((!(wc_Style & 0x40000) AND wc_ResizeFixedWindows = 0) AND cr_Resizeable <> 1)
		Return
	wc_Monitor := func_GetMonitorNumber("A")
	; ID, Groesse und Position des aktuellen Fensters
	WinGet, wc_WindowID, ID, A
	WinGetPos, wc_X, wc_Y, wc_Width, wc_Height, A
	WinGet, wc_Max, MinMax, A

	If (wc_X <> WorkArea%wc_Monitor%Left OR wc_Y <> WorkArea%wc_Monitor%Top OR wc_Width <> Floor(WorkArea%wc_Monitor%Width/2) OR wc_Height <> WorkArea%wc_Monitor%Height )
	{
		If (wc_Height = Floor(WorkArea%wc_Monitor%Height/2) AND (wc_Width = WorkArea%wc_Monitor%Width OR (wc_Width = Floor(WorkArea%wc_Monitor%Width/2) AND wc_X = Floor(WorkArea%wc_Monitor%Width/2) ) ) )
		{
			wc_newH := wc_Height
			wc_newY := wc_Y
			wc_Store = 0
		}
		Else
		{
			wc_newH := WorkArea%wc_Monitor%Height
			wc_newY := WorkArea%wc_Monitor%Top
			wc_Store = 1
		}

		If wc_Max = 1
			WinRestore, A
		WinMove, A,, % WorkArea%wc_Monitor%Left, %wc_newY%, % Floor(WorkArea%wc_Monitor%Width/2), %wc_newH%

		; Fensterwerte fuer spaeter speichern
		If ((wc_lastW%wc_WindowID% <> wc_Width OR wc_lastH%wc_WindowID% <> wc_Height) AND wc_Store = 1)
		{
			wc_WindowX%wc_WindowID%      = %wc_X%
			wc_WindowWidth%wc_WindowID%  = %wc_Width%
			wc_WindowY%wc_WindowID%      = %wc_Y%
			wc_WindowHeight%wc_WindowID% = %wc_Height%
			wc_WindowMax%wc_WindowID%    = %wc_Max%

		}
		wc_lastW%wc_WindowID% := Floor(WorkArea%wc_Monitor%Width/2)
		wc_lastH%wc_WindowID% := wc_newH
	}
	Else If (wc_WindowHeight%wc_WindowID% <> "" AND wc_WindowWidth%wc_WindowID% <> "")
	{
		If wc_WindowMax%wc_WindowID% = 1
			WinMaximize, A
		Else
		{
			WinMove, A, , wc_WindowX%wc_WindowID%, wc_WindowY%wc_WindowID%, wc_WindowWidth%wc_WindowID%, wc_WindowHeight%wc_WindowID%
			; Speicherwerte zuruecksetzen
			wc_WindowHeight%wc_WindowID% =
			wc_WindowY%wc_WindowID%      =
			wc_WindowWidth%wc_WindowID%  =
			wc_WindowX%wc_WindowID%      =
		}
	}
Return

wc_sub_MaxRight:
	Gosub, wc_sub_MouseHotkey
	WinGet, wc_Style, Style, A
	If ((!(wc_Style & 0x40000) AND wc_ResizeFixedWindows = 0) AND cr_Resizeable <> 1)
		Return
	wc_Monitor := func_GetMonitorNumber("A")
	; ID, Groesse und Position des aktuellen Fensters
	WinGet, wc_WindowID, ID, A
	WinGetPos, wc_X, wc_Y, wc_Width, wc_Height, A
	WinGet, wc_Max, MinMax, A

	If (wc_X <> WorkArea%wc_Monitor%Left + Floor(WorkArea%wc_Monitor%Width/2) OR wc_Y <> WorkArea%wc_Monitor%Top OR wc_Width <> Floor(WorkArea%wc_Monitor%Width/2) OR wc_Height <> WorkArea%wc_Monitor%Height )
	{
		If (wc_Height = Floor(WorkArea%wc_Monitor%Height/2) AND (wc_Width = WorkArea%wc_Monitor%Width OR (wc_Width = Floor(WorkArea%wc_Monitor%Width/2) AND wc_X = WorkArea%wc_Monitor%Left ) ) )
		{
			wc_newH := wc_Height
			wc_newY := wc_Y
			wc_Store = 0
		}
		Else
		{
			wc_newH := WorkArea%wc_Monitor%Height
			wc_newY := WorkArea%wc_Monitor%Top
			wc_Store = 1
		}

		If wc_Max = 1
			WinRestore, A

		WinMove, A,, % WorkArea%wc_Monitor%Left + Floor(WorkArea%wc_Monitor%Width/2),  %wc_newY%, % Floor(WorkArea%wc_Monitor%Width/2), %wc_newH%
		Sleep,50
		WinGetPos,,,wc_NewWidth,,A
		If (wc_NewWidth <> Floor(WorkArea%wc_Monitor%Width/2) )
			WinMove, A,, % WorkArea%wc_Monitor%Width-wc_NewWidth
		; Fensterwerte fuer spaeter speichern
		If ((wc_lastW%wc_WindowID% <> wc_Width OR wc_lastH%wc_WindowID% <> wc_Height) AND wc_Store = 1)
		{
			wc_WindowX%wc_WindowID%      = %wc_X%
			wc_WindowWidth%wc_WindowID%  = %wc_Width%
			wc_WindowY%wc_WindowID%      = %wc_Y%
			wc_WindowHeight%wc_WindowID% = %wc_Height%
			wc_WindowMax%wc_WindowID%    = %wc_Max%
		}
		wc_lastW%wc_WindowID% := Floor(WorkArea%wc_Monitor%Width/2)
		wc_lastH%wc_WindowID% := wc_newH
	}
	Else If (wc_WindowHeight%wc_WindowID% <> "" AND wc_WindowWidth%wc_WindowID% <> "")
	{
		If wc_WindowMax%wc_WindowID% = 1
			WinMaximize, A
		Else
		{
			WinMove, A, , wc_WindowX%wc_WindowID%, wc_WindowY%wc_WindowID%, wc_WindowWidth%wc_WindowID%, wc_WindowHeight%wc_WindowID%
			; Speicherwerte zuruecksetzen
			wc_WindowHeight%wc_WindowID% =
			wc_WindowY%wc_WindowID%      =
			wc_WindowWidth%wc_WindowID%  =
			wc_WindowX%wc_WindowID%      =
		}
	}
Return

wc_sub_MaxTop:
	Gosub, wc_sub_MouseHotkey
	WinGet, wc_Style, Style, A
	If ((!(wc_Style & 0x40000) AND wc_ResizeFixedWindows = 0) AND cr_Resizeable <> 1)
		Return
	wc_Monitor := func_GetMonitorNumber("A")
	; ID, Groesse und Position des aktuellen Fensters
	WinGet, wc_WindowID, ID, A
	WinGetPos, wc_X, wc_Y, wc_Width, wc_Height, A
	WinGet, wc_Max, MinMax, A
	If (wc_X <> WorkArea%wc_Monitor%Left OR wc_Y <> WorkArea%wc_Monitor%Top OR wc_Width <> WorkArea%wc_Monitor%Width OR wc_Height <> Floor(WorkArea%wc_Monitor%Height/2) )
	{
		If (wc_Width = Floor(WorkArea%wc_Monitor%Width/2) AND (wc_Height = WorkArea%wc_Monitor%Height OR (wc_Height = Floor(WorkArea%wc_Monitor%Height/2) AND wc_Y = Floor(WorkArea%wc_Monitor%Height/2) ) ) )
		{
			wc_newW := wc_Width
			wc_newX := wc_X
			wc_Store = 0
		}
		Else
		{
			wc_newW := WorkArea%wc_Monitor%Width
			wc_newX := WorkArea%wc_Monitor%Left
			wc_Store = 1
		}

		If wc_Max = 1
			WinRestore, A
		WinMove, A,, %wc_newX%, % WorkArea%wc_Monitor%Top, %wc_newW%, % Floor(WorkArea%wc_Monitor%Height/2)
		; Fensterwerte fuer spaeter speichern
		If ( (wc_lastW%wc_WindowID% <> wc_Width OR wc_lastH%wc_WindowID% <> wc_Height) AND wc_Store = 1)
		{
			wc_WindowX%wc_WindowID%      = %wc_X%
			wc_WindowWidth%wc_WindowID%  = %wc_Width%
			wc_WindowY%wc_WindowID%      = %wc_Y%
			wc_WindowHeight%wc_WindowID% = %wc_Height%
			wc_WindowMax%wc_WindowID%    = %wc_Max%
		}
		wc_lastW%wc_WindowID% := wc_newW
		wc_lastH%wc_WindowID% := Floor(WorkArea%wc_Monitor%Height/2)
	}
	Else If (wc_WindowHeight%wc_WindowID% <> "" AND wc_WindowWidth%wc_WindowID% <> "")
	{
		If wc_WindowMax%wc_WindowID% = 1
			WinMaximize, A
		Else
		{
			WinMove, A, , wc_WindowX%wc_WindowID%, wc_WindowY%wc_WindowID%, wc_WindowWidth%wc_WindowID%, wc_WindowHeight%wc_WindowID%
			; Speicherwerte zuruecksetzen
			wc_WindowHeight%wc_WindowID% =
			wc_WindowY%wc_WindowID%      =
			wc_WindowWidth%wc_WindowID%  =
			wc_WindowX%wc_WindowID%      =
		}
	}
Return

wc_sub_MaxBottom:
	Gosub, wc_sub_MouseHotkey
	WinGet, wc_Style, Style, A
	If ((!(wc_Style & 0x40000) AND wc_ResizeFixedWindows = 0) AND cr_Resizeable <> 1)
		Return
	wc_Monitor := func_GetMonitorNumber("A")
	; ID, Groesse und Position des aktuellen Fensters
	WinGet, wc_WindowID, ID, A
	WinGetPos, wc_X, wc_Y, wc_Width, wc_Height, A
	WinGet, wc_Max, MinMax, A

	If (wc_X <> WorkArea%wc_Monitor%Left OR wc_Y <> WorkArea%wc_Monitor%Top + Floor(WorkArea%wc_Monitor%Height/2) OR wc_Width <> WorkArea%wc_Monitor%Width OR wc_Height <> Floor(WorkArea%wc_Monitor%Height/2) )
	{
		If (wc_Width = Floor(WorkArea%wc_Monitor%Width/2) AND (wc_Height = WorkArea%wc_Monitor%Height OR (wc_Height = Floor(WorkArea%wc_Monitor%Height/2) AND wc_Y = WorkArea%wc_Monitor%Top ) ) )
		{
			wc_newW := wc_Width
			wc_newX := wc_X
			wc_Store = 0
		}
		Else
		{
			wc_newW := WorkArea%wc_Monitor%Width
			wc_newX := WorkArea%wc_Monitor%Left
			wc_Store = 1
		}

		If wc_Max = 1
			WinRestore, A
		WinMove, A,, %wc_newX%, % WorkArea%wc_Monitor%Top + Floor(WorkArea%wc_Monitor%Height/2), %wc_newW%, % Floor(WorkArea%wc_Monitor%Height/2)
		Sleep,50
		WinGetPos,,,,wc_NewHeight,A
		If (wc_NewHeight <> Floor(WorkArea%wc_Monitor%Height/2) )
			WinMove, A,,, % WorkArea%wc_Monitor%Height-wc_NewHeight

		; Fensterwerte fuer spaeter speichern
		If (wc_lastW%wc_WindowID% <> wc_Width OR wc_lastH%wc_WindowID% <> wc_Height)
		{
			wc_WindowX%wc_WindowID%      = %wc_X%
			wc_WindowWidth%wc_WindowID%  = %wc_Width%
			wc_WindowY%wc_WindowID%      = %wc_Y%
			wc_WindowHeight%wc_WindowID% = %wc_Height%
			wc_WindowMax%wc_WindowID%    = %wc_Max%
		}
		wc_lastW%wc_WindowID% := wc_newW
		wc_lastH%wc_WindowID% := Floor(WorkArea%wc_Monitor%Height/2)
	}
	Else If (wc_WindowHeight%wc_WindowID% <> "" AND wc_WindowWidth%wc_WindowID% <> "")
	{
		If wc_WindowMax%wc_WindowID% = 1
			WinMaximize, A
		Else
		{
			WinMove, A, , wc_WindowX%wc_WindowID%, wc_WindowY%wc_WindowID%, wc_WindowWidth%wc_WindowID%, wc_WindowHeight%wc_WindowID%
			; Speicherwerte zuruecksetzen
			wc_WindowHeight%wc_WindowID% =
			wc_WindowY%wc_WindowID%      =
			wc_WindowWidth%wc_WindowID%  =
			wc_WindowX%wc_WindowID%      =
		}
	}
Return

wc_sub_MaxHeight:
	Gosub, wc_sub_MouseHotkey
	WinGet, wc_Style, Style, A
	If ((!(wc_Style & 0x40000) AND wc_ResizeFixedWindows = 0) AND cr_Resizeable <> 1)
		Return
	; Aktiven Monitor ermitteln
	wc_Monitor := func_GetMonitorNumber("A")
	; ID, Groesse und Position des aktuellen Fensters
	WinGet, wc_WindowID, ID, A
	WinGetPos, wc_X, wc_Y, wc_Width, wc_Height, A
	WinGet, wc_Max, MinMax, A
	; wenn Fensterhoehe <> Bildschirmhoehe dann maximieren
	If ( wc_Height <> WorkArea%wc_Monitor%Height )
	{
		; Fenster maximieren
		WinMove, A,, %wc_X%, WorkArea%wc_Monitor%Top, %wc_Width%, % WorkArea%wc_Monitor%Height
		; Fensterwerte fuer spaeter speichern
		If (wc_lastW%wc_WindowID% <> wc_Width OR wc_lastH%wc_WindowID% <> wc_Height)
		{
			wc_WindowX%wc_WindowID%      = %wc_X%
			wc_WindowWidth%wc_WindowID%  = %wc_Width%
			wc_WindowY%wc_WindowID%      = %wc_Y%
			wc_WindowHeight%wc_WindowID% = %wc_Height%
			wc_WindowMax%wc_WindowID%    = %wc_Max%
		}
		wc_lastW%wc_WindowID% := wc_Width
		wc_lastH%wc_WindowID% := WorkArea%wc_Monitor%Height
	}
	Else If (wc_WindowHeight%wc_WindowID% <> "" AND wc_WindowWidth%wc_WindowID% <> "")
	{
		If wc_WindowMax%wc_WindowID% = 1
			WinMaximize, A
		Else
		{
			WinMove, A, , wc_WindowX%wc_WindowID%, wc_WindowY%wc_WindowID%, wc_WindowWidth%wc_WindowID%, wc_WindowHeight%wc_WindowID%
			; Speicherwerte zuruecksetzen
			wc_WindowHeight%wc_WindowID% =
			wc_WindowY%wc_WindowID%      =
			wc_WindowWidth%wc_WindowID%  =
			wc_WindowX%wc_WindowID%      =
		}
	}
Return

wc_sub_MaxWidth:
	Gosub, wc_sub_MouseHotkey
	WinGet, wc_Style, Style, A
	If ((!(wc_Style & 0x40000) AND wc_ResizeFixedWindows = 0) AND cr_Resizeable <> 1)
		Return
	; Aktiven Monitor ermitteln
	wc_Monitor := func_GetMonitorNumber("A")
	; ID, Groesse und Position des aktuellen Fensters
	WinGet, wc_WindowID, ID, A
	WinGetPos, wc_X, wc_Y, wc_Width, wc_Height, A
	WinGet, wc_Max, MinMax, A
	; wenn Fensterbreite <> Bildschirmbreite dann maximieren
	If ( wc_Width <> WorkArea%wc_Monitor%Width )
	{
		; Fenster maximieren
		WinMove, A,, WorkArea%wc_Monitor%Left, %wc_Y%, % WorkArea%wc_Monitor%Width, %wc_Height%
		; Fensterwerte fuer spaeter speichern
		If (wc_lastW%wc_WindowID% <> wc_Width OR wc_lastH%wc_WindowID% <> wc_Height)
		{
			wc_WindowX%wc_WindowID%      = %wc_X%
			wc_WindowWidth%wc_WindowID%  = %wc_Width%
			wc_WindowY%wc_WindowID%      = %wc_Y%
			wc_WindowHeight%wc_WindowID% = %wc_Height%
			wc_WindowMax%wc_WindowID%    = %wc_Max%
		}
		wc_lastW%wc_WindowID% := WorkArea%wc_Monitor%Width
		wc_lastH%wc_WindowID% := wc_Height
	}
	Else If (wc_WindowHeight%wc_WindowID% <> "" AND wc_WindowWidth%wc_WindowID% <> "")
	{
		If wc_WindowMax%wc_WindowID% = 1
			WinMaximize, A
		Else
		{
			WinMove, A, , wc_WindowX%wc_WindowID%, wc_WindowY%wc_WindowID%, wc_WindowWidth%wc_WindowID%, wc_WindowHeight%wc_WindowID%
			; Speicherwerte zuruecksetzen
			wc_WindowHeight%wc_WindowID% =
			wc_WindowY%wc_WindowID%      =
			wc_WindowWidth%wc_WindowID%  =
			wc_WindowX%wc_WindowID%      =
		}
	}
Return

wc_sub_MinToTitle:
	Gosub, wc_sub_MouseHotkey
;   WinGet, wc_Style, Style, A
;   If ((!(wc_Style & 0x40000) AND wc_ResizeFixedWindows = 0) AND cr_Resizeable <> 1)
;      Return
	; Aktiven Monitor ermitteln
	wc_Monitor := func_GetMonitorNumber("A")
	; ID, Groesse und Position des aktuellen Fensters
	WinGet, wc_WindowID, ID, A
	WinGetPos, wc_X, wc_Y, wc_Width, wc_Height, A
	WinGet, wc_Max, MinMax, A
	If wc_Max = 1
		WinRestore, A
	; wenn Fensterhoehe <> Bildschirmhoehe dann maximieren
	If ( wc_Height > wc_MinToTitlelastH%wc_WindowID% )
	{
		; Fenster maximieren
		WinMove, A,, %wc_X%, %wc_Y%, %wc_Width%, % CaptionHeight+BorderHeight
		WinGetPos, , , , wc_NewHeight, A
		; Fensterwerte fuer spaeter speichern
		If (wc_MinToTitlelastW%wc_WindowID% <> wc_Width OR wc_MinToTitlelastH%wc_WindowID% <> wc_Height)
		{
			wc_MinToTitleWindowWidth%wc_WindowID%  = %wc_Width%
			wc_MinToTitleWindowHeight%wc_WindowID% = %wc_Height%
			wc_MinToTitleWindowMax%wc_WindowID%    = %wc_Max%
		}
		wc_MinToTitlelastW%wc_WindowID% := wc_Width
		wc_MinToTitlelastH%wc_WindowID% := wc_NewHeight
		wc_MinToTitleIDs = %wc_MinToTitleIDs%%wc_WindowID%|
	}
	Else If (wc_MinToTitleWindowHeight%wc_WindowID% <> "" AND wc_MinToTitleWindowWidth%wc_WindowID% <> "")
	{
		If wc_MinToTitleWindowMax%wc_WindowID% = 1
			WinMaximize, A
		Else
		{
			WinMove, A, , , , wc_MinToTitleWindowWidth%wc_WindowID%, wc_MinToTitleWindowHeight%wc_WindowID%
			; Speicherwerte zuruecksetzen
			wc_MinToTitleWindowHeight%wc_WindowID% =
			wc_MinToTitleWindowWidth%wc_WindowID%  =
			StringReplace, wc_MinToTitleIDs, wc_MinToTitleIDs, %wc_WindowID%|,, A
		}
	}
Return

wc_sub_Close:
	;DetectHiddenwindows, On
	Gosub, wc_sub_MouseHotkey
	If wc_CloseApp <> 2
	{
		IfWinActive, ahk_class Progman
			Return

		WinClose, A
	}
	Else
	{
		WinGet, wc_PID, PID, A
		WinGet, wc_List, List, ahk_pid %wc_PID%
		Loop, %wc_List%
		{
			WinGetClass, wc_Class, % "ahk_id " wc_List%A_Index%
			If wc_Class in Shell_TrayWnd,Progman
				continue
			WinClose, % "ahk_id " wc_List%A_Index%
		}
		Loop
		{
			Loop, %wc_List%
			{
				WinGetClass, wc_Class, % "ahk_id " wc_List%A_Index%
				If wc_Class in Shell_TrayWnd,Progman
					continue
				IfWinExist, % "ahk_id " wc_List%A_Index%
				{
					WinWaitClose, % "ahk_id " wc_List%A_Index%,, 5
;               If ErrorLevel = 1
;                  WinClose, % "ahk_id " wc_List%A_Index%
				}
			}
			Sleep, 1000
			Process, Exist, %wc_PID%
			If (Errorlevel <> 0 AND ErrorLevel <> "")
			{
				WinGetClass, wc_Class, ahk_pid %wc_PID%
				If wc_Class in Shell_TrayWnd,Progman
					Return
				WinWaitClose, ahk_pid %wc_PID%,,3
				If ErrorLevel = 1
				{
					MsgBox, 18, %wc_ScriptName% %ErrorLevel% ! ,%lng_wc_CantClose%
					IfMsgBox, Abort
						Return
					IfMsgBox, Ignore
					{
						Process, Close, %wc_PID%
						Return
					}
				}
				Else
					Return
			}
			Else
				Return
		}
	}
Return

wc_sub_Kill:
	Gosub, wc_sub_MouseHotkey
	WinKill, A
Return

wc_sub_AOT:
	Gosub, wc_sub_MouseHotkey
	WinGetTitle, wc_WinTitle, A
	WinGet, wc_ExStyle, ExStyle, A
	WinGetClass, wc_WinClass, A
	If wc_WinClass in Shell_TrayWnd,Progman
		Return

	if (wc_ExStyle & 0x8)
	{
		WinSet, AlwaysOnTop, Off, A
		If wc_AOTModifyTitle = 1
		{
			IfInString, wc_WinTitle, /¯\
				StringTrimLeft, wc_WinTitle, wc_WinTitle, 5
			WinSet, ExStyle, -0x20000, A
		}
	}
	Else
	{
		WinSet, AlwaysOnTop, On, A
		If wc_AOTModifyTitle = 1
		{
			IfNotInString, wc_WinTitle, /¯\
				wc_WinTitle = /¯\  %wc_WinTitle%
			WinSet, ExStyle, +0x20000, A
		}
	}
	WinSetTitle, A,, %wc_WinTitle%
return

wc_sub_Trans:
	Gosub, wc_sub_MouseHotkey
	WinGet, wc_WindowID, ID, A
	WinGet, wc_Transparent, Transparent, A
	WinGetClass, wc_WinClass, A
	If wc_WinClass in Shell_TrayWnd,Progman
		Return

	if (wc_Transparent = "" AND wc_Transparent%wc_WindowID% = "")
	{
		WinSet, Transparent, %wc_TransVal%, A
		wc_Transparent%wc_WindowID% = %wc_TransVal%
		If wc_TransWithClickThrough = 1
			WinSet, ExStyle, +0x20, A ; ClickThrough
	}
	Else
	{
		WinSet, Transparent, 255, A
		WinSet, Transparent, Off, A
		wc_Transparent%wc_WindowID% =
		If wc_TransWithClickThrough = 1
			WinSet, ExStyle, -0x20, A ; ClickThrough
	}
return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

wc_sub_MouseHotkey:
	If A_ThisHotkey contains MButton,LButton,RButton,XButton1,XButton2
	{
		MouseGetPos,,,wc_MouseID
		IfWinNotactive, ahk_id %wc_MouseID%
		{
			WinActivate, ahk_id %wc_MouseID%
			WinWaitActive, ahk_id %wc_MouseID%
		}
	}
Return
