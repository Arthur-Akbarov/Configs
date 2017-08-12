; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               ReadingRuler
; -----------------------------------------------------------------------------
; Prefix:             rr_
; Version:            1.2
; Date:               2008-05-23
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_ReadingRuler:
	Prefix = rr
	%Prefix%_ScriptName    = ReadingRuler
	%Prefix%_ScriptVersion = 1.2
	%Prefix%_Author        = Wolfgang Reszel, Michael Telgkamp, Dirk Schwarzmann

	CustomHotkey_ReadingRuler = 1    ; Benutzerdefiniertes Hotkey
	Hotkey_ReadingRuler       = #+   ; Standard-Hotkey
	HotkeyPrefix_ReadingRuler =      ; 'Durchgeschleiftes' Hotkey

	IconFile_On_ReadingRuler = %A_WinDir%\system32\shell32.dll
	IconPos_On_ReadingRuler = 160

	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %rr_ScriptName% - Leselineal
		Description                   = Zeigt ein Leselineal oder Fadenkreuz an, welches der Maus folgt. Erleichtert das Lesen am Bildschirm.
		lng_rr_HoriLine               = Waagerechte Linie
		lng_rr_VertLine               = Senkrechte Linie
		lng_rr_Color                  = Linienfarbe und -stärke
		lng_rr_Tooltip                = Informationsanzeige
		lng_rr_Red                    = Rot:
		lng_rr_Green                  = Grün:
		lng_rr_Blue                   = Blau:
		lng_rr_Coord                  = Koordinaten anzeigen:
		lng_rr_CoordNoOpt             = keine
		lng_rr_CoordOpt2              = nur aktuelle Position
		lng_rr_CoordOpt3              = mit Distanz von der Position, wo ReadingRuler aufgerufen wurde
		lng_rr_ShowStart              = Startposition anzeigen
		lng_rr_LineThickness          = Linienstärke
		lng_rr_ShowMouseWinClass      = Fensterklasse unter dem Mauspfeil anzeigen (inkl. HWND)
		lng_rr_ShowMouseClass         = Elementklasse unter dem Mauspfeil anzeigen (inkl. HWND)
		lng_rr_ShowWindowClass        = Fensterklasse des aktiven Fensters anzeigen
		lng_rr_Transparency           = Transparenz
		lng_rr_Offset                 = Versatz
		lng_rr_Hole                   = Lochgröße
		lng_rr_ShowHexColor           = Farbwerte unter dem Mauszeiger anzeigen
		lng_rr_ActiveWindow           = Aktives Fenster:`t`t
		lng_rr_MouseControl           = Element unter Maus:`t
		lng_rr_MouseWinControl        = Fenster unter Maus:`t
		lng_rr_ColorTip               = Farbe:`t
		tooltip_rr_ShowStart          = Grün/Grau = Nur Startposition anzeigen
		lng_rr_ShowMouseClassContent  = Inhalt des Elements unter der Maus anzeigen
		lng_rr_ShowMouseClassStyles   = Fensterstile unter der Maus anzeigen
		lng_rr_ShowMouseClassTransparency = Fenstertransparenz unter der Maus anzeigen
		lng_rr_ShowMouseClassProcess  = Prozessname unter der Maus anzeigen
	}
	Else        ; = other languages (english)
	{
		MenuName                      = %rr_ScriptName% - ruler that helps reading
		Description                   = Shows a horizontal line or a crosshair to help you reading texts on screen
		lng_rr_HoriLine               = Horizontal Line
		lng_rr_VertLine               = Vertical Line
		lng_rr_Color                  = Line-colour and thickness
		lng_rr_Tooltip                = Info-display
		lng_rr_Red                    = Red:
		lng_rr_Green                  = Green:
		lng_rr_Blue                   = Blue:
		lng_rr_Coord                  = Show coordinates:
		lng_rr_CoordNoOpt             = none
		lng_rr_CoordOpt2              = only current position
		lng_rr_CoordOpt3              = distance from where ReadingRuler was activated
		lng_rr_ShowStart              = Show starting point
		lng_rr_LineThickness          = Line thickness
		lng_rr_ShowMouseWinClass      = Show class of the window under the mouse (incl. HWND)
		lng_rr_ShowMouseClass         = Show class of the control under the mouse (incl. HWND)
		lng_rr_ShowWindowClass        = Show window class of the active window
		lng_rr_Transparency           = Transparency
		lng_rr_Offset                 = Offset
		lng_rr_Hole                   = Hole size
		lng_rr_ShowHexColor           = Show color values at mouse-position
		lng_rr_ActiveWindow           = Active window:`t`t
		lng_rr_MouseControl           = Control at mouse:`t
		lng_rr_MouseWinControl        = Window at mouse:`t
		lng_rr_ColorTip               = Color:`t
		tooltip_rr_ShowStart          = green/grey = Only show starting point
		lng_rr_ShowMouseClassContent  = Show content of the control under the mouse
		lng_rr_ShowMouseClassStyles   = Show window styles under the mouse
		lng_rr_ShowMouseClassTransparency = Show transparency under the mouse
		lng_rr_ShowMouseClassProcess  = Show process name under the mouse
	}
	If CustomLanguage <>
		gosub, CustomLanguage

	IniRead, rr_HoriLine, %ConfigFile%, %rr_ScriptName%, HorizontalLine, 1
	IniRead, rr_VertLine,  %ConfigFile%, %rr_ScriptName%, VerticalLine, 0
	IniRead, rr_ColHex, %ConfigFile%, %rr_ScriptName%, CrosshairColor, cc9900
	IniRead, rr_CoordMode, %ConfigFile%, %rr_ScriptName%, ShowCoordinates, 1
	IniRead, rr_ShowStart, %ConfigFile%, %rr_ScriptName%, ShowStartingPoint, 0
	IniRead, rr_LineWidth, %ConfigFile%, %rr_ScriptName%, LineWidth, 1
	IniRead, rr_Transparency, %ConfigFile%, %rr_ScriptName%, Transparency, 255
	IniRead, rr_ShowMouseClass, %ConfigFile%, %rr_ScriptName%, ShowMouseClass, 0
	IniRead, rr_ShowMouseWinClass, %ConfigFile%, %rr_ScriptName%, ShowMouseWindowClass, 0
	IniRead, rr_ShowWindowClass, %ConfigFile%, %rr_ScriptName%, ShowWindowClass, 0
	IniRead, rr_ShowHexColor, %ConfigFile%, %rr_ScriptName%, ShowHexColor, 0

	IniRead, rr_OffsetX, %ConfigFile%, %rr_ScriptName%, OffsetX, 0
	IniRead, rr_OffsetY, %ConfigFile%, %rr_ScriptName%, OffsetY, 0
	IniRead, rr_HoleSize, %ConfigFile%, %rr_ScriptName%, HoleSize, 8

	RegisterAdditionalSetting( "rr", "ShowMouseClassStyles", 0 )
	RegisterAdditionalSetting( "rr", "ShowMouseClassTransparency", 0)
	RegisterAdditionalSetting( "rr", "ShowMouseClassProcess", 0)
	RegisterAdditionalSetting( "rr", "ShowMouseClassContent", 0 )

	If (rr_LineWidth < 0 AND rr_LineWidth > 5)
		rr_LineWidth = 1

	rr_Ruler = Off
Return

SettingsGui_ReadingRuler:
	rr_GuiDrawn =
	rr_LastRuler =
	rr_TransparencyTmp := 100-rr_Transparency/255*100

	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged XS+10 Y+5 Checked%rr_HoriLine% vrr_HoriLine, %lng_rr_HoriLine%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged X+5 Checked%rr_VertLine% vrr_VertLine, %lng_rr_VertLine%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged X+30 Check3 Checked%rr_ShowStart% vrr_ShowStart, %lng_rr_ShowStart%
	Gui, Add, GroupBox, xs+10 ys+60 w180 h210, %lng_rr_Color%

	Gui, Font,S%FontSize20%, Wingdings
	Gui, Add, Text, xs+60 Backgroundtrans yp+20 vrr_ShowColor2, n
	Gui, Add, Text, x+-4 Backgroundtrans vrr_ShowColor, n
	Gui, Font,S%FontSize%, Courier New
	Gui, Add, Edit, x+5 yp+4 w55 vrr_ColHex Limit6 grr_sub_EditColor, %rr_ColHex%

	Gui, Font
	Gui, Font, S%FontSize%

	Gui, Add, Text, XS+20 y+8 w30, %lng_rr_Red%
	Gui, Add, Slider, x+5 yp-5 w130 h30 vrr_ColR Range0-255 AltSubmit TickInterval16 ToolTip Line8 grr_sub_Color, %rr_ColR%
	Gui, Add, Text, XS+20 y+6 w30, %lng_rr_Green%
	Gui, Add, Slider, x+5 yp-5 w130 h30 vrr_ColG Range0-255 AltSubmit TickInterval16 ToolTip Line8 grr_sub_Color, %rr_ColG%
	Gui, Add, Text, XS+20 y+6 w30, %lng_rr_Blue%
	Gui, Add, Slider, x+5 yp-5 w130 h30 vrr_ColB Range0-255 AltSubmit TickInterval16 ToolTip Line8 grr_sub_Color, %rr_ColB%
	Gui, Add, Text, xs+20 y+6 w55, %lng_rr_Transparency%:
	Gui, Add, Slider, x+0 yp-5 w100 h30 vrr_TransparencyTmp Range0-99 AltSubmit TickInterval10 ToolTip Line10 grr_sub_Color, %rr_TransparencyTmp%

	Gui, Add, Text, xs+20 y+13, %lng_rr_LineThickness%:
	Gui, Add, Edit, x+5 yp-3 R1 w35 vrr_LineWidth Limit1 gsub_CheckIfSettingsChanged, %rr_LineWidth%
	Gui, Add, UpDown, Range1-5, %rr_LineWidth%

	Gui, Add, GroupBox, xs+200 ys+60 w340 h180, %lng_rr_Tooltip%
	Gui, Add, Text, xp+10 yp+20, %lng_rr_Coord%
	lng_rr_CoordOpt1 = rr_CoordMode
	Gui, Add, Radio, -Wrap vrr_CoordMode y+5 gsub_CheckIfSettingsChanged, %lng_rr_CoordNoOpt%
	Gui, Add, Radio, -Wrap y+5 gsub_CheckIfSettingsChanged, %lng_rr_CoordOpt2%
	Gui, Add, Radio, -Wrap y+5 gsub_CheckIfSettingsChanged, %lng_rr_CoordOpt3%
	GuiControl,,% lng_rr_CoordOpt%rr_CoordMode%, 1
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged y+20 Checked%rr_ShowWindowClass% vrr_ShowWindowClass, %lng_rr_ShowWindowClass%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged y+5 Checked%rr_ShowMouseWinClass% vrr_ShowMouseWinClass, %lng_rr_ShowMouseWinClass%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged y+5 Checked%rr_ShowMouseClass% vrr_ShowMouseClass, %lng_rr_ShowMouseClass%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged y+5 Checked%rr_ShowHexColor% vrr_ShowHexColor, %lng_rr_ShowHexColor%
	Gosub, rr_sub_EditColor
	Gui, Font
	Gui, Font, S%FontSize%
	Gui, Add, Text, xs+200 ys+250, X-%lng_rr_Offset%:
	Gui, Add, Edit, x+5 yp-3 R1 w35 vrr_OffsetX Limit3 gsub_CheckIfSettingsChanged, %rr_OffsetX%
	Gui, Add, Text, x+10 yp+3, Y-%lng_rr_Offset%:
	Gui, Add, Edit, x+5 yp-3 R1 w35 vrr_OffsetY Limit3 gsub_CheckIfSettingsChanged, %rr_OffsetY%
	Gui, Add, Text, x+10 yp+3, %lng_rr_Hole%:
	Gui, Add, Edit, x+5 yp-3 R1 w25 vrr_HoleSize Limit2 gsub_CheckIfSettingsChanged, %rr_HoleSize%
Return

rr_sub_EditColor:
	Critical
	GuiControlGet, rr_ColHexEdit,,rr_ColHex
	GuiControlGet, rr_ColTrans,,rr_TransparencyTmp
	StringMid, rr_ColRHex, rr_ColHexEdit, 1, 2
	StringMid, rr_ColGHex, rr_ColHexEdit, 3, 2
	StringMid, rr_ColBHex, rr_ColHexEdit, 5, 2
	StringReplace, rr_ColRHex, rr_ColRHex, 0x,
	StringReplace, rr_ColGHex, rr_ColGHex, 0x,
	StringReplace, rr_ColBHex, rr_ColBHex, 0x,

	rr_ColRHex = 0x%rr_ColRHex%
	rr_ColGHex = 0x%rr_ColGHex%
	rr_ColBHex = 0x%rr_ColBHex%
	rr_ColRHex2 := rr_ColRHex
	rr_ColGHex2 := rr_ColGHex
	rr_ColBHex2 := rr_ColBHex
	GuiControl,,rr_ColR,%rr_ColRHex%
	GuiControl,,rr_ColG,%rr_ColGHex%
	GuiControl,,rr_ColB,%rr_ColBHex%

	StringReplace, rr_ColRHex, rr_ColRHex, 0x, 0
	StringReplace, rr_ColGHex, rr_ColGHex, 0x, 0
	StringReplace, rr_ColBHex, rr_ColBHex, 0x, 0
	StringRight, rr_ColRHex, rr_ColRHex, 2
	StringRight, rr_ColGHex, rr_ColGHex, 2
	StringRight, rr_ColBHex, rr_ColBHex, 2

	PixelGetColor, rr_WinCol, 378, 37 , RGB
	StringMid, rr_WinColRHex, rr_WinCol, 3, 2
	StringMid, rr_WinColGHex, rr_WinCol, 5, 2
	StringMid, rr_WinColBHex, rr_WinCol, 7, 2
	rr_WinColRHex = 0x%rr_WinColRHex%
	rr_WinColGHex = 0x%rr_WinColGHex%
	rr_WinColBHex = 0x%rr_WinColBHex%

	SetFormat, Integer, H
	rr_ColRHex2 := Round( (rr_WinColRHex*rr_ColTrans/100) + (rr_ColRHex2*(100-rr_ColTrans)/100) )
	rr_ColGHex2 := Round( (rr_WinColGHex*rr_ColTrans/100) + (rr_ColGHex2*(100-rr_ColTrans)/100) )
	rr_ColBHex2 := Round( (rr_WinColBHex*rr_ColTrans/100) + (rr_ColBHex2*(100-rr_ColTrans)/100) )

	StringReplace, rr_ColRHex2, rr_ColRHex2, 0x, 0
	StringReplace, rr_ColGHex2, rr_ColGHex2, 0x, 0
	StringReplace, rr_ColBHex2, rr_ColBHex2, 0x, 0
	StringRight, rr_ColRHex2, rr_ColRHex2, 2
	StringRight, rr_ColGHex2, rr_ColGHex2, 2
	StringRight, rr_ColBHex2, rr_ColBHex2, 2

	Gui, Font, c%rr_ColRHex2%%rr_ColGHex2%%rr_ColBHex2% S20 , Wingdings
	GuiControl, Font, rr_ShowColor
	Gui, Font, c%rr_ColRHex%%rr_ColGHex%%rr_ColBHex% S20 , Wingdings
	GuiControl, Font, rr_ShowColor2
	SetFormat, Integer, D

	If rr_GuiDrawn > 1
		func_SettingsChanged( "ReadingRuler" )
	Else
		rr_GuiDrawn++
Return

rr_sub_Color:
	Critical
	SetFormat, Integer, H
	GuiControlGet, rr_ColTrans,,rr_TransparencyTmp
	GuiControlGet, rr_ColRHex,, rr_ColR
	GuiControlGet, rr_ColGHex,, rr_ColG
	GuiControlGet, rr_ColBHex,, rr_ColB
	rr_ColRHex2 := rr_ColRHex
	rr_ColGHex2 := rr_ColGHex
	rr_ColBHex2 := rr_ColBHex
	StringReplace, rr_ColRHex, rr_ColRHex, 0x, 0
	StringReplace, rr_ColGHex, rr_ColGHex, 0x, 0
	StringReplace, rr_ColBHex, rr_ColBHex, 0x, 0
	StringRight, rr_ColRHex, rr_ColRHex, 2
	StringRight, rr_ColGHex, rr_ColGHex, 2
	StringRight, rr_ColBHex, rr_ColBHex, 2

	PixelGetColor, rr_WinCol, 378, 37 , RGB
	StringMid, rr_WinColRHex, rr_WinCol, 3, 2
	StringMid, rr_WinColGHex, rr_WinCol, 5, 2
	StringMid, rr_WinColBHex, rr_WinCol, 7, 2
	rr_WinColRHex = 0x%rr_WinColRHex%
	rr_WinColGHex = 0x%rr_WinColGHex%
	rr_WinColBHex = 0x%rr_WinColBHex%

	rr_ColRHex2 := Round( (rr_WinColRHex*rr_ColTrans/100) + (rr_ColRHex2*(100-rr_ColTrans)/100) )
	rr_ColGHex2 := Round( (rr_WinColGHex*rr_ColTrans/100) + (rr_ColGHex2*(100-rr_ColTrans)/100) )
	rr_ColBHex2 := Round( (rr_WinColBHex*rr_ColTrans/100) + (rr_ColBHex2*(100-rr_ColTrans)/100) )

	StringReplace, rr_ColRHex2, rr_ColRHex2, 0x, 0
	StringReplace, rr_ColGHex2, rr_ColGHex2, 0x, 0
	StringReplace, rr_ColBHex2, rr_ColBHex2, 0x, 0
	StringRight, rr_ColRHex2, rr_ColRHex2, 2
	StringRight, rr_ColGHex2, rr_ColGHex2, 2
	StringRight, rr_ColBHex2, rr_ColBHex2, 2

	GuiControl, , rr_ColHex, %rr_ColRHex%%rr_ColGHex%%rr_ColBHex%
	Gui, Font, c%rr_ColRHex2%%rr_ColGHex2%%rr_ColBHex2% S20 , Wingdings
	GuiControl, Font, rr_ShowColor
	Gui, Font, c%rr_ColRHex%%rr_ColGHex%%rr_ColBHex% S20 , Wingdings
	GuiControl, Font, rr_ShowColor2
	SetFormat, Integer, D
	If A_IsSuspended <> 1
		func_SettingsChanged( "ReadingRuler" )
Return

SaveSettings_ReadingRuler:
	rr_Transparency := 255-rr_TransparencyTmp/100*255

	IniWrite, %rr_HoriLine%, %ConfigFile%, %rr_ScriptName%, HorizontalLine
	IniWrite, %rr_VertLine%, %ConfigFile%, %rr_ScriptName%, VerticalLine
	IniWrite, %rr_ColHex%, %ConfigFile%, %rr_ScriptName%, CrosshairColor
	IniWrite, %rr_CoordMode%, %ConfigFile%, %rr_ScriptName%, ShowCoordinates
	IniWrite, %rr_ShowStart%, %ConfigFile%, %rr_ScriptName%, ShowStartingPoint
	IniWrite, %rr_LineWidth%, %ConfigFile%, %rr_ScriptName%, LineWidth
	IniWrite, %rr_ShowMouseClass%, %ConfigFile%, %rr_ScriptName%, ShowMouseClass
	IniWrite, %rr_ShowMouseWinClass%, %ConfigFile%, %rr_ScriptName%, ShowMouseWindowClass
	IniWrite, %rr_ShowWindowClass%, %ConfigFile%, %rr_ScriptName%, ShowWindowClass
	IniWrite, %rr_Transparency%, %ConfigFile%, %rr_ScriptName%, Transparency
	IniWrite, %rr_OffsetX%, %ConfigFile%, %rr_ScriptName%, OffsetX
	IniWrite, %rr_OffsetY%, %ConfigFile%, %rr_ScriptName%, OffsetY
	IniWrite, %rr_HoleSize%, %ConfigFile%, %rr_ScriptName%, HoleSize
	IniWrite, %rr_ShowHexColor%, %ConfigFile%, %rr_ScriptName%, ShowHexColor
	IniWrite, %rr_ShowMouseClassContent%, %ConfigFile%, %rr_ScriptName%, MouseClassContent
Return

CancelSettings_ReadingRuler:
Return

DoEnable_ReadingRuler:
	If rr_LastRuler = On
	{
		rr_Ruler = Off
		Gosub, sub_Hotkey_ReadingRuler
	}
Return

DoDisable_ReadingRuler:
	rr_LastRuler = %rr_Ruler%
	If (rr_Ruler = "On")
		Gosub, sub_Hotkey_ReadingRuler
Return

DefaultSettings_ReadingRuler:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

sub_Hotkey_ReadingRuler:
	; Wenn Lineal aus, dann einschalten
	If rr_Ruler = Off
	{
		rr_Ruler = First
		SetTimer, rr_tim_Ruler, 2
		Coordmode, Mouse, Screen            ; Mauskoordinaten beziehen sich auf den gesamten Bildschirm
		MouseGetPos,rr_StartX, rr_StartY    ; Startkoordinaten
		rr_StartX += %rr_OffsetX%
		rr_StartY += %rr_OffsetY%
	}
	Else ; Sonst wieder ausschalten
	{
		SetTimer,rr_tim_Ruler,Off
		rr_Ruler = Off
		If rr_HoriLine = 1
			Splashimage,3:Off
		If rr_VertLine = 1
			Splashimage,4:Off
		If rr_ShowStart <> 0
		{
			If rr_HoriLine = 1
				Splashimage,5:Off
			If rr_VertLine = 1
				Splashimage,6:Off
		}
		rr_RulerX =
		rr_LastRulerX =
		rr_RulerY =
		rr_LastRulerY =
		ToolTip,,,,4
	}
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

rr_tim_Ruler:
	rr_counter = 0

	rr_ClickThrough = +0x80020
	SetWindelay,2
	Coordmode, Mouse, Screen    ; Mauskoordinaten beziehen sich auf den gesamten Bildschirm
	Coordmode, Tooltip, Screen
	MouseGetPos,rr_RulerX, rr_RulerY        ; Y-Koordinate der Maus
	rr_RulerY := rr_RulerY+rr_OffsetY
	rr_RulerX := rr_RulerX+rr_OffsetX
	if rr_Ruler = First              ; Beim ersten Aufruf
	{
		;Feste Startopsition zeichnen
		If rr_ShowStart <> 0
		{
			If rr_HoriLine = 1
			{
				Splashimage,5:, B H%rr_LineWidth% W%MonitorAreaWidth% X%MonitorAreaLeft% Y%rr_StartY% CW%rr_ColHex%,,,ScreenRulerSY
				WinSet, Transparent, %rr_Transparency%, ScreenRulerSY
				WinMove, ScreenRulerSY,,,,%MonitorAreaWidth%
				WinSet, ExStyle, %rr_ClickThrough%, ScreenRulerSY
			}
			If rr_VertLine = 1
			{
				Splashimage,6:, B H%MonitorAreaHeight% W%rr_LineWidth% X%rr_StartX% Y%MonitorAreaTop% CW%rr_ColHex%,,,ScreenRulerSX
				WinSet, Transparent, %rr_Transparency%, ScreenRulerSX
				WinMove, ScreenRulerSX,,,,,%MonitorAreaHeight%
				WinSet, ExStyle, %rr_ClickThrough%, ScreenRulerSX
			}
		}

		; Bewegliche Linie klein erzeugen
		If (rr_HoriLine = 1 AND rr_ShowStart <> -1)
		{
			Splashimage,3:, B H%rr_LineWidth% W0 X0 Y0 CW%rr_ColHex%,,,ScreenRulerY
			WinSet, Transparent, %rr_Transparency%, ScreenRulerY
			WinSet, ExStyle, %rr_ClickThrough%, ScreenRulerY
		}
		If (rr_VertLine = 1 AND rr_ShowStart <> -1)
		{
			Splashimage,4:, B H0 W%rr_LineWidth% X0 Y0 CW%rr_ColHex%,,,ScreenRulerX
			WinSet, Transparent, %rr_Transparency%, ScreenRulerX
			WinSet, ExStyle, %rr_ClickThrough%, ScreenRulerX
		}
		rr_Ruler = On                  ; Linie gilt nun als aktiviert
	}
	If (rr_RulerX <> rr_LastRulerX OR rr_RulerY <> rr_LastRulerY)
	{
		If (rr_RulerY <> rr_LastRulerY AND rr_HoriLine = 1)
			WinMove, ScreenRulerY,,%MonitorAreaLeft%, %rr_RulerY%, %MonitorAreaWidth%
		If (rr_VertLine = 1 AND rr_RulerX <> rr_LastRulerX)
			WinMove, ScreenRulerX,, %rr_RulerX%,%MonitorAreaTop%,,%MonitorAreaHeight%
		rr_RulerX1 := rr_RulerX-MonitorAreaLeft+1-rr_HoleSize/2
		rr_RulerX2 := rr_RulerX-MonitorAreaLeft+1+rr_HoleSize/2
		rr_RulerY1 := rr_RulerY-MonitorAreaTop+1-rr_HoleSize/2
		rr_RulerY2 := rr_RulerY-MonitorAreaTop+1+rr_HoleSize/2
		If (rr_RulerX <> rr_LastRulerX AND rr_HoriLine = 1)
			WinSet, Region,0-0 %MonitorAreaWidth%-0 %MonitorAreaWidth%-%rr_LineWidth% 0-%rr_LineWidth% 0-0  %rr_RulerX1%-0 %rr_RulerX2%-0 %rr_RulerX2%-%rr_LineWidth% %rr_RulerX1%-%rr_LineWidth% %rr_RulerX1%-0,ScreenRulerY
		If (rr_RulerY <> rr_LastRulerY AND rr_VertLine = 1)
			WinSet, Region,0-0 0-%MonitorAreaHeight% %rr_LineWidth%-%MonitorAreaHeight% %rr_LineWidth%-0 0-0  0-%rr_RulerY1% 0-%rr_RulerY2% %rr_LineWidth%-%rr_RulerY2% %rr_LineWidth%-%rr_RulerY1% 0-%rr_RulerY1%,ScreenRulerX
		WinSet, Top,, ScreenRulerX
		WinSet, Top,, ScreenRulerY
		WinSet, Top,, ScreenRulerSX
		WinSet, Top,, ScreenRulerSY
	}

	rr_ToolTipAdd =
	rr_RulerX := func_StrRight("     " rr_RulerX, 5)
	rr_RulerY := func_StrRight("     " rr_RulerY, 5)
	If rr_CoordMode = 2
		rr_ToolTipAdd := rr_ToolTipAdd "`n  X: " func_StrRight("     " rr_RulerX, 6) "`t|   Y: " func_StrRight("     " rr_RulerY, 6)
	If rr_CoordMode = 3
		rr_ToolTipAdd := rr_ToolTipAdd "`n  X: " func_StrRight("     " rr_RulerX, 6) "`t|   Y: " func_StrRight("     " rr_RulerY, 6) "`ndX: " func_StrRight("     " rr_RulerX-rr_StartX, 6) "`t| dY: " func_StrRight("     " rr_RulerY-rr_StartY, 6)
	If rr_ShowHexColor = 1
	{
		CoordMode, Pixel, Screen
		MouseGetPos,rr_tmpX,rr_tmpY
		PixelGetColor,rr_HexCol,%rr_tmpX%,%rr_tmpY%,RGB
		StringMid, rr_ColR, rr_HexCol, 3, 2
		StringMid, rr_ColG, rr_HexCol, 5, 2
		StringMid, rr_ColB, rr_HexCol, 7, 2
		rr_ColR := "0x" rr_ColR
		rr_ColG := "0x" rr_ColG
		rr_ColB := "0x" rr_ColB
		rr_ColR := rr_ColR+0
		rr_ColG := rr_ColG+0
		rr_ColB := rr_ColB+0
		rr_ColLong := rr_ColR+(rr_ColG<<8)+((rr_ColB<<8)<<8)
		rr_ToolTipAdd = %rr_ToolTipAdd%`n%lng_rr_ColorTip%%rr_HexCol% (%rr_ColR%, %rr_ColG%, %rr_ColB%) = [%rr_ColLong%]
	}

	If rr_ShowWindowClass = 1
	{
		WinGetClass, rr_ActiveWindowClass, A
		WinGet, rr_ActiveWindowID, ID, A
		WinGet, rr_ActiveWindowPID, PID, A
		rr_ToolTipAdd = %rr_ToolTipAdd%`n%lng_rr_ActiveWindow%%rr_ActiveWindowClass% (ID: %rr_ActiveWindowID%, PID: %rr_ActiveWindowPID%)
	}
	If rr_ShowMouseWinClass = 1
	{
		MouseGetPos,,,rr_MouseWindowID
		WinGetClass, rr_MouseWindowClass, ahk_id %rr_MouseWindowID%
		ControlGet, rr_MouseWindowHWND, HWND,,, ahk_id %rr_MouseWindowID%
		rr_ToolTipAdd = %rr_ToolTipAdd%`n%lng_rr_MouseWinControl%%rr_MouseWindowClass% (HWND: %rr_MouseWindowHWND%)
	}
	If rr_ShowMouseClass = 1
	{
		MouseGetPos,,,rr_MouseWindowID, rr_MouseControlClass
		MouseGetPos,,,,rr_MouseControlHWND, 2
		rr_ToolTipAdd = %rr_ToolTipAdd%`n%lng_rr_MouseControl%%rr_MouseControlClass% (HWND: %rr_MouseControlHWND%)
	}
	If rr_ShowMouseClassStyles = 1
	{
		MouseGetPos,,,rr_MouseWindowID, rr_MouseControlClass
		WinGet, rr_MouseWinStyle, Style, ahk_id %rr_MouseWindowID%
		WinGet, rr_MouseWinExStyle, ExStyle, ahk_id %rr_MouseWindowID%
		rr_ToolTipAdd = %rr_ToolTipAdd%`nStyle:%rr_MouseWinStyle%`tExStyle:%rr_MouseWinExStyle%
	}
	If rr_ShowMouseClassTransparency = 1
	{
		MouseGetPos,,,rr_MouseWindowID, rr_MouseControlClass
		WinGet, rr_MouseClassTransparency, Transparent, ahk_id %rr_MouseWindowID%
		If rr_MouseClassTransparency =
			rr_MouseClassTransparency = Off
		rr_ToolTipAdd = %rr_ToolTipAdd%`nTrans: %rr_MouseClassTransparency%
	}
	If rr_ShowMouseClassProcess = 1
	{
		MouseGetPos,,,rr_MouseWindowID, rr_MouseControlClass
		WinGet, rr_MouseClassProcess, ProcessName, ahk_id %rr_MouseWindowID%
		rr_ToolTipAdd = %rr_ToolTipAdd%`nProcess: %rr_MouseClassProcess%
	}
	If rr_ShowMouseClassContent = 1
	{
		MouseGetPos,,,rr_MouseWindowID, rr_MouseControlClass
		ControlGetText, rr_MouseControlText, %rr_MouseControlClass% ,ahk_id %rr_MouseWindowID%
		rr_ToolTipAdd = %rr_ToolTipAdd%`n`n%rr_MouseControlText%
	}

	StringTrimLeft, rr_ToolTipAdd, rr_ToolTipAdd, 1

	If (rr_Ruler = "On" AND (rr_ToolTipAdd <> rr_LastToolTip OR rr_RulerX <> rr_LastRulerX OR rr_RulerY <> rr_LastRulerY))
	{
		; Position und Größe des ToolTips
		WinGetPos, rr_ttX, rr_ttY, rr_ttW, rr_ttH, ahk_class tooltips_class32

		; Setze die Position des ToolTips abhängig von der Mausposition
		; zweiter Teil ist notwendig beim MultiMonitor Betrieb mit zwei Monitorn untereinander
		If (rr_RulerY > MonitorAreaBottom - rr_ttH - 15 OR (rr_RulerY > WorkAreaPrimaryBottom - rr_ttH - 15 AND rr_RulerY < WorkAreaPrimaryBottom)) {
			rr_RulerPosY := rr_RulerY - rr_ttH - 15
		} Else {
			rr_RulerPosY := rr_RulerY + 15
		}
		rr_RulerPosX := rr_RulerX + 15
		ToolTip, %rr_ToolTipAdd%, %rr_RulerPosX%, %rr_RulerPosY%, 4
		rr_LastToolTip = %rr_ToolTipAdd%
	}

	rr_LastRulerX = %rr_RulerX%
	rr_LastRulerY = %rr_RulerY%
return

#IfWinExist, ScreenRulerS
~Ctrl::
	If rr_Ruler <> First
	{
		If (A_PriorHotkey <> "~Ctrl" or A_TimeSincePriorHotkey > 400)
		{
			 KeyWait, Ctrl
			 Return
		}
		rr_tempX := rr_StartX
		rr_tempY := rr_StartY
		rr_StartX := rr_RulerX
		rr_StartY := rr_RulerY
		rr_RulerX := rr_tempX
		rr_RulerY := rr_tempY
		rr_LastRulerX =
		rr_LastRulerY =
		rr_Ruler = First
	}
Return

~ESC::
	If (A_PriorHotkey <> "~ESC" or A_TimeSincePriorHotkey > 400)
	{
		 KeyWait, ESC
		 Return
	}
	Gosub, sub_Hotkey_ReadingRuler
Return

#IfWinExist
