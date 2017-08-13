; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               ScreenLoupe
; -----------------------------------------------------------------------------
; Prefix:             lup_
; Version:            0.4.2
; Date:               2007-06-07
; Author:             Wolfgang Reszel
;                     Basiert auf dem Skript ScreenMagnifier von Holomind
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_ScreenLoupe:
	Prefix = lup
	%Prefix%_ScriptName    = ScreenLoupe
	%Prefix%_ScriptVersion = 0.4.2
	%Prefix%_Author        = Michael Telgkamp, Wolfgang Reszel

	IconFile_On_ScreenLoupe = %A_WinDir%\system32\shell32.dll
	IconPos_On_ScreenLoupe = 23

	CreateGuiID("ScreenLoupe")  ; nächste freie GUI-ID in %GuiID_ScreenLoupe% ablegen und Close/Escape-Label

	; Sprachabhängige Variablen
	If Lng = 07 ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName           = %lup_ScriptName% - Bildschirmlupe
		Description        = Vergrößert den Bildschirminhalt am Mauspfeil ähnlich einer Lupe. (Basiert auf ScreenMagnifier von Holomind/ivanw)
		lng_lup_ZoomOnOff  = Lupe aktivieren/deaktivieren
		lng_lup_ZoomIn     = Vergrößern
		lng_lup_ZoomOut    = Verkleinern
		lng_lup_MoveOnOff  = Lupe fixieren (Maus/Monitor)
		lng_lup_Width      = Breite und Höhe der Lupe
		lng_lup_delay      = Erneuerungsverzögerung
		lng_lup_antialias  = Treppeneffektglättung
		lng_lup_ToolTip    = Ganze Zahlen oder Brüche möglich`n(z.B. 1/2 = Hälfte des Bildschirms bzw. Arbeitsbereichs)
		tooltip_lup_Width  = %lng_Lup_ToolTip%
		tooltip_lup_Height = %lng_Lup_ToolTip%
	}
	else ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName           = %lup_ScriptName% - screen loupe
		Description        = Magnify the screen at the mouse cursor position. (Based on ScreenMagnifier by Holomind/ivanw)
		lng_lup_ZoomOnOff  = Activate/deactivate loupe
		lng_lup_ZoomIn     = Zoom in
		lng_lup_ZoomOut    = Zoom out
		lng_lup_MoveOnOff  = Fix loupe (mouse/monitor)
		lng_lup_Width      = Width and height of the loupe:
		lng_lup_delay      = Repaint delay
		lng_lup_antialias  = Antialiasing
		lng_cr_ToolTip     = Integer or fractions`n(e.g. 1/2 = the half of the screen)
		tooltip_lup_Width  = %lng_Lup_ToolTip%
		tooltip_lup_Height = %lng_Lup_ToolTip%
	}

	func_HotkeyRead( "lup_ZoomOnOff", ConfigFile , lup_ScriptName, "ZoomOnOffHotkey", "lup_sub_ZoomOnOff", "^+NumpadMult" )
	func_HotkeyRead( "lup_ZoomIn", ConfigFile , lup_ScriptName, "ZoomInHotkey", "lup_sub_ZoomIn", "^+NumpadAdd" )
	func_HotkeyRead( "lup_ZoomOut", ConfigFile , lup_ScriptName, "ZoomOutHotkey", "lup_sub_ZoomOut", "^+NumpadSub" )
	func_HotkeyRead( "lup_MoveOnOff", ConfigFile , lup_ScriptName, "MoveOnOffHotkey", "lup_sub_MoveOnOff", "" )

	IniRead, lup_Width, %ConfigFile%, %lup_ScriptName%, Width, 300
	IniRead, lup_Height, %ConfigFile%, %lup_ScriptName%, Height, 200
	IniRead, lup_Zoom, %ConfigFile%, %lup_ScriptName%, Zoom, 2
	IniRead, lup_follow, %ConfigFile%, %lup_ScriptName%, follow, 1
	IniRead, lup_delay, %ConfigFile%, %lup_ScriptName%, repaintdelay, 10
	IniRead, lup_antialias, %ConfigFile%, %lup_ScriptName%, antialias, 0
Return

SettingsGui_ScreenLoupe:
	func_HotkeyAddGuiControl( lng_lup_ZoomOnOff, "lup_ZoomOnOff", "xs+10 y+10 w160" )
	func_HotkeyAddGuiControl( lng_lup_ZoomIn, "lup_ZoomIn", "xs+10 y+10 w160" )
	func_HotkeyAddGuiControl( lng_lup_ZoomOut, "lup_ZoomOut", "xs+10 y+10 w160" )
	func_HotkeyAddGuiControl( lng_lup_MoveOnOff, "lup_MoveOnOff", "xs+10 y+10 w160" )

	Gui, Add, Text, xs+10 y+10 w160, %lng_lup_Width%:
	Gui, Add, Edit, x+5 yp-3 w40 gsub_CheckIfSettingsChanged vlup_Width, %lup_Width%
	Gui, Add, Text, x+5 yp+3, x
	Gui, Add, Edit, x+5 yp-3 w40 gsub_CheckIfSettingsChanged vlup_Height, %lup_Height%
	Gui, Add, Text, xs+10 y+10 w160, %lng_lup_delay%:
	Gui, Add, Edit, x+5 yp-3 w40 gsub_CheckIfSettingsChanged vlup_delay, %lup_delay%
	Gui, Add, Text, x+5 yp+3, ms
	Gui, Add, Text, xs+10 y+10 w160, %lng_lup_antialias%:
	Gui, Add, Checkbox, x+5 yp+0 gsub_CheckIfSettingsChanged vlup_antialias checked%lup_antialias%
Return

; wird aufgerufen, wenn im Konfigurationsdialog OK oder Übernehmen angeklickt wird
SaveSettings_ScreenLoupe:
	func_HotkeyWrite( "lup_ZoomOnOff", ConfigFile , lup_ScriptName, "ZoomOnOffHotkey" )
	func_HotkeyWrite( "lup_ZoomIn", ConfigFile , lup_ScriptName, "ZoomInHotkey" )
	func_HotkeyWrite( "lup_ZoomOut", ConfigFile , lup_ScriptName, "ZoomOutHotkey" )
	func_HotkeyWrite( "lup_MoveOnOff", ConfigFile , lup_ScriptName, "MoveOnOffHotkey" )

	IniWrite, %lup_Width%, %ConfigFile%, %lup_ScriptName%, Width
	IniWrite, %lup_Height%, %ConfigFile%, %lup_ScriptName%, Height
	IniWrite, %lup_delay%, %ConfigFile%, %lup_ScriptName%, repaintdelay
	IniWrite, %lup_antialias%, %ConfigFile%, %lup_ScriptName%, antialias
Return

; Wird aufgerufen, wenn Einstellungen über das 'Pfeil'-Menü hinzugefügt werden, ist nur notwendig wenn AddSettings_ScreenLoupe = 1
AddSettings_ScreenLoupe:
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_ScreenLoupe:
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_ScreenLoupe:
	func_HotkeyEnable("lup_ZoomIn")
	func_HotkeyEnable("lup_ZoomOut")
	func_HotkeyEnable("lup_ZoomOnOff")
	func_HotkeyEnable("lup_MoveOnOff")

	registerHoldAction("ZoomOnOff",lng_lup_ZoomOnOff,"lup_sub_ZoomOnOff","lup_sub_ZoomOnOff")
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern der Einstellungen aufgerufen
DoDisable_ScreenLoupe:
	func_HotkeyDisable("lup_ZoomIn")
	func_HotkeyDisable("lup_ZoomOut")
	func_HotkeyDisable("lup_ZoomOnOff")
	func_HotkeyDisable("lup_MoveOnOff")
	Gosub, ScreenLoupeGuiClose
Return

; wird aufgerufen, wenn der Anwender die Erweiterung auf die Standard-Einstellungen zurücksetzt
DefaultSettings_ScreenLoupe:
Return

; wird aufgerufen, wenn ac'tivAid beendet oder neu geladen wird.
OnExitAndReload_ScreenLoupe:
	Gosub, ScreenLoupeGuiClose
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

lup_sub_ZoomOnOff:
	Gui, %GuiID_ScreenLoupe%:+LastFoundExist
	IfWinExist
	{
		Gosub, ScreenLoupeGuiClose
	}
	Else
	{
		StringReplace, lup_Width, lup_Width, `:, /
		IfInString lup_Width, /
		{
			StringSplit, lup_Width, lup_Width, /
			lup_ww := (Monitor%lup_Monitor%Width*lup_Width1/lup_Width2)
		}
		Else
			lup_ww := lup_Width
		StringReplace, lup_Height, lup_Height, `:, /
		IfInString lup_Height, /
		{
			StringSplit, lup_Height, lup_Height, /
			lup_wh := (Monitor%lup_Monitor%Height*lup_Height1/lup_Height2)
		}
		Else
			lup_wh := lup_Height
		lup_wwi :=lup_ww
		lup_whi :=lup_wh
		lup_ww -= 6
		lup_wh -= 24
		lup_mx := 0
		lup_my := 0
		Gui, %GuiID_ScreenLoupe%:+AlwaysOnTop +Owner -Resize -ToolWindow +E0x00000020
		Gui, %GuiID_ScreenLoupe%:Show, NoActivate W%lup_ww% H%lup_wh% X-1000 Y-1000, MagWindow ; start offscreen

		WinSet, Transparent , 254, MagWindow
		Gui, %GuiID_ScreenLoupe%:-Caption
		Gui, %GuiID_ScreenLoupe%:+Border

		WinGet, PrintSourceID, id
		lup_hdd_frame := DllCall("GetDC", UInt, PrintSourceID)

		WinGet, PrintScreenID, id, MagWindow
		lup_hdc_frame := DllCall("GetDC", UInt, PrintScreenID)
		if(lup_antialias != 0)
			DllCall("gdi32.dll\SetStretchBltMode", "uint", lup_hdc_frame, "int", 4*lup_antialias)
		; Disable Aero
		hModule := DllCall("LoadLibrary", "str", "dwmapi.dll")
		DllCall("dwmapi\DwmEnableComposition", "uint", 0)

		Gosub, lup_tim_Repaint
	}
Return

lup_sub_ZoomIn:
	Gui, %GuiID_ScreenLoupe%:+LastFoundExist
	IfWinExist
	{
		If (lup_zoom < 31)
			lup_zoom *= 1.1892071150027210667174999705605
		lup_Zx := lup_Rx/lup_zoom
		lup_Zy := lup_Ry/lup_zoom
		IniWrite, %lup_Zoom%, %ConfigFile%, %lup_ScriptName%, Zoom
	}
	Else
		Gosub, lup_sub_ZoomOnOff
Return

lup_sub_ZoomOut:
	Gui, %GuiID_ScreenLoupe%:+LastFoundExist
	IfWinExist
	{
		lup_zoom /= 1.1892071150027210667174999705605
		lup_Zx := lup_Rx/lup_zoom
		lup_Zy := lup_Ry/lup_zoom
		IniWrite, %lup_Zoom%, %ConfigFile%, %lup_ScriptName%, Zoom
	}
	Else
		Gosub, lup_sub_ZoomOnOff
Return

lup_sub_MoveOnOff:
	Gui, %GuiID_ScreenLoupe%:+LastFoundExist
	IfWinNotExist
		Gosub, lup_sub_ZoomOnOff
	if(lup_follow=1)
		Gui, %GuiID_ScreenLoupe%:+Resize -E0x00000020
	else
		Gui, %GuiID_ScreenLoupe%:-Resize +E0x00000020
	lup_follow:=1-lup_follow
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

lup_tim_Repaint:
	CoordMode, Mouse, Screen
	MouseGetPos, lup_mx, lup_my
	WinGetPos, lup_wx, lup_wy, lup_ww, lup_wh, MagWindow

	DllCall( "gdi32.dll\StretchBlt"
		, UInt, lup_hdc_frame
		, Int , 2 ; nXOriginDest
		, Int , 2 ; nYOriginDest
		, Int , lup_ww-6 ; nWidthDest
		, Int , lup_wh-6 ; nHeightDest
		, UInt, lup_hdd_frame ; hdcSrc
		, Int , lup_mx - (lup_ww / 2 / lup_zoom) ; nXOriginSrc
		, Int , lup_my - (lup_wh / 2 / lup_zoom) ; nYOriginSrc
		, Int , lup_ww / lup_zoom ; nWidthSrc
		, Int , lup_wh / lup_zoom ; nHeightSrc
		, UInt, 0xCC0020) ; dwRop (raster operation)

	if(lup_follow == 1)
		WinMove, MagWindow, ,lup_mx-lup_ww/2, lup_my-lup_wh/2, %lup_ww%, %lup_wh%

		SetTimer, lup_tim_Repaint, %lup_delay%
Return

ScreenLoupeGuiClose:
ScreenLoupeGuiEscape:
	SetTimer, lup_tim_Repaint, Off
	lup_follow:=1
	If GuiID_ScreenLoupe =
		Return
	Gui, %GuiID_ScreenLoupe%:+LastFoundExist
	IfWinExist
	{
		if(lup_wwi!=lup_ww)
			IniWrite, %lup_ww%, %ConfigFile%, %lup_ScriptName%, Width
		if(lup_whi!=lup_wh)
			IniWrite, %lup_wh%, %ConfigFile%, %lup_ScriptName%, Height
		lup_wwi:=lup_ww
		lup_whi:=lup_wh
		DllCall("gdi32.dll\DeleteDC", UInt, lup_hdc_frame )
		DllCall("gdi32.dll\DeleteDC", UInt, lup_hdd_frame )
		
		; re-enable Aero
		DllCall("dwmapi\DwmEnableComposition", "uint", 1)
		Gui, %GuiID_ScreenLoupe%:Destroy
	}
Return
