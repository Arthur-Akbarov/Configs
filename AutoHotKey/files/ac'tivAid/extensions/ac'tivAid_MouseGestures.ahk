; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               MouseGestures
; -----------------------------------------------------------------------------
; Prefix:             ges_
; Version:            0.1
; Date:               2008-06-16
; Author:             David Hilberath
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_MouseGestures:
	Prefix = ges
	%Prefix%_ScriptName    = MouseGestures
	%Prefix%_ScriptVersion = 0.1
	%Prefix%_Author        = David Hilberath

	CustomHotkey_MouseGestures = 0
	IconFile_On_MouseGestures  = %A_WinDir%\system32\main.cpl
	IconPos_On_MouseGestures   = 1

	RegisterAdditionalSetting("ges","enableTrayTip",1)

	if gdiP_enabled = 1
		RegisterAdditionalSetting("ges","drawOnScreen",1)
	else
		ges_drawnOnScreen := 0

	;RegisterAdditionalSetting("ges","operaKeys",0)
	CreateGuiID("MouseGestures")
	CreateGuiID("MouseGesturesPen")

	gosub, LoadSettings_MouseGestures
	gosub, LanguageCreation_MouseGestures
Return

LanguageCreation_MouseGestures:
	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %ges_ScriptName% - Mausgesten
		Description                   = Erlaubt bestimmte Aktionen bei bestimmten Mausgesten durchzuführen.

		lng_ges_recSymbol             = Symbol erkannt
		lng_ges_enableTrayTip         = Balloontip anzeigen
		lng_ges_gestureKey            = Gestentaste
		lng_ges_operaKeys             = Im Explorer "Rechtsklick-Linksklick" wie in Opera
		lng_ges_desc                  = Beschreibung
		lng_ges_gesture               = Geste
		lng_ges_action                = Aktion
		lng_ges_action_para           = Parameter
		lng_ges_Edit                  = Bearbeiten
		lng_ges_lineTolerance         = Strich Toleranz
		lng_ges_symbolTolerance       = Symbol Toleranz
		lng_ges_action_gestureKey     = %lng_ges_gestureKey%
		lng_ges_drawOnScreen          = Gesten auf den Bildschirm mitzeichnen
		lng_ges_line                  = Kante
		lng_ges_knot                  = Knoten
		lng_ges_TransparencyShort     = Trans.
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %ges_ScriptName% - Mousegestures
		Description                   = Allows to control windows with mouse gestures

		lng_ges_recSymbol             = Recognized symbol
		lng_ges_enableTrayTip         = Show balloon tips in tray
		lng_ges_gestureKey            = Gesture key
		lng_ges_operaKeys             = Use "Rightclick-Leftclick" in Explorer as in Opera
		lng_ges_desc                  = Description
		lng_ges_gesture               = Gesture
		lng_ges_action                = Action
		lng_ges_action_para           = Parameter
		lng_ges_Edit                  = Edit
		lng_ges_lineTolerance         = Line tolerance
		lng_ges_symbolTolerance       = Symbol tolerance
		lng_ges_action_gestureKey     = %lng_ges_gestureKey%
		lng_ges_drawOnScreen          = Draw gestures on screen
		lng_ges_line                  = Line
		lng_ges_knot                  = Knot
		lng_ges_TransparencyShort     = Trans.
	}
Return

SettingsGui_MouseGestures:
	; Gui, Add, Edit, xs+10 y+5 gsub_CheckIfSettingsChanged vges_var, %lng_ges_text%

	func_HotkeyAddGuiControl( lng_ges_gestureKey, "ges_GestureKey", "xs+10 ys+17 w90" )

	Gui, Add, Text, w85 Xs+10 Y+10 vges_Text1, %lng_ges_lineTolerance%:
	Gui, Add, Slider, AltSubmit yp-2 h20 gges_sub_CheckIfSettingsChanged X+5 vges_lineTSlider w313 Range2-40, %ges_lineTolerance%
	Gui, Add, Text, w30 x+5 yp+2 vges_lineTSlider_text,

	Gui, Add, Text, w85 Xs+10 Y+10 vges_Text2, %lng_ges_symbolTolerance%:
	Gui, Add, Slider, AltSubmit yp-2 h20 gges_sub_CheckIfSettingsChanged X+5 vges_symbolTSlider w313 Range2-40, %ges_symbolTolerance%
	Gui, Add, Text, w30 x+5 yp+2 vges_symbolTSlider_text,


	Gui, Add, ListView, Hwndges_LVHwnd Count%ges_numGestures% AltSubmit -Multi -LV0x10 Grid xs+10 y+10 h190 w550 vges_ListView gges_sub_ListView, %lng_ges_desc%|%lng_ges_gesture%|%lng_ges_action%|action|num|%lng_ges_action_para%
	Gui, Add, Button, -Wrap xs+205 ys+290 w25 h16 gges_sub_AddGesture, +
	Gui, Add, Button, -Wrap x+5 h16 w25 gges_sub_DelGesture, %MinusString%
	Gui, Add, Button, -Wrap x+5 h16 w135 gges_sub_EditGesture, %lng_ges_Edit%

	Gui, Add, Text, xs+450 ys+17 w40, %lng_ges_line%
	Gui, Add, ListView, x+20 yp-3 H20 W50 ReadOnly +0x4000 +0x2000 +Background%ges_kantenColor% vges_kantenColor_Box lv0x800000 0x4 -TabStop gChooseColorButton AltSubmit

	Gui, Add, Text, xs+450 y+10 w40, %lng_ges_knot%
	Gui, Add, ListView, x+20 yp-3 H20 W50 ReadOnly +0x4000 +0x2000 +Background%ges_knotenColor% vges_knotenColor_Box lv0x800000 0x4 -TabStop gChooseColorButton AltSubmit

	Gui, Add, Text, xs+450 y+10 w50, %lng_ges_TransparencyShort%
	Gui, Add, Slider, AltSubmit yp-3 h20 gges_sub_CheckIfSettingsChanged x+5 vges_transSlider w60 Range25-255, %ges_trans%

	Gui, Add, Edit, w0 h0 Hidden vges_knotenColor, %ges_knotenColor%
	Gui, Add, Edit, w0 h0 Hidden vges_kantenColor, %ges_kantenColor%

	Gui, ListView, ges_ListView
	LV_ModifyCol(1,110)
	LV_ModifyCol(2,120)
	LV_ModifyCol(3,200)
	LV_ModifyCol(4,0)
	LV_ModifyCol(5,0)
	LV_ModifyCol(6,100)

	GuiControl, -Redraw, ges_ListView

	Loop, %ges_numGestures%
	{
		ges_tmp_Action := ges_gestureCmd%A_Index%
		ges_tmp_desc := ActionDesc%ges_tmp_Action%

		StringReplace, ges_tmp_humanGesture, ges_gesture%A_index%,|,° ->%A_Space%,All
		ges_tmp_humanGesture = %ges_tmp_humanGesture%°

		LV_Add("", ges_gestureDesc%A_index%, ges_tmp_humanGesture, ges_tmp_desc,ges_tmp_Action,A_Index, ges_gesturePara%A_index%)
	}
	GuiControl, +Redraw, ges_ListView

	ges_EditTitle = %lng_ges_Edit%
	gosub, ges_sub_CheckIfSettingsChanged
Return


LoadSettings_MouseGestures:
	func_HotkeyRead("ges_GestureKey", ConfigFile, ges_ScriptName, "GestureHotkey", "", "MButton")
	IniRead, ges_StringGestureKey, %ConfigFile%, %ges_ScriptName%, GestureHotkey, MButton
	IniRead, ges_lineTolerance, %ConfigFile%, %ges_ScriptName%, LineTolerance,40
	IniRead, ges_symbolTolerance, %ConfigFile%, %ges_ScriptName%, SymbolTolerance,25
	IniRead, ges_numGestures, %ConfigFile%, %ges_ScriptName%, NumGestures,0
	IniRead, ges_kantenColor, %ConfigFile%, %ges_ScriptName%, KantenColor,FF0000
	IniRead, ges_knotenColor, %ConfigFile%, %ges_ScriptName%, KnotenColor,0000FF
	IniRead, ges_trans, %ConfigFile%, %ges_ScriptName%, Transparency,55

	ges_trans_Hex := FormatHexNumber(ges_trans,2)

	ges_kante = 0x%ges_trans_Hex%%ges_kantenColor%
	ges_knoten = 0x%ges_trans_Hex%%ges_knotenColor%

	Loop, %ges_numGestures%
	{
		IniRead, ges_gesture%A_index%, %ConfigFile%, %ges_ScriptName%, Gesture%A_Index%, %A_Space%
		IniRead, ges_gestureDesc%A_index%, %ConfigFile%, %ges_ScriptName%, GestureDesc%A_Index%, %A_Space%
		IniRead, ges_gestureCmd%A_index%, %ConfigFile%, %ges_ScriptName%, GestureCmd%A_Index%, %A_Space%
		IniRead, ges_gesturePara%A_index%, %ConfigFile%, %ges_ScriptName%, GesturePara%A_Index%, %A_Space%
	}
Return

SaveSettings_MouseGestures:
	Gui, %GuiID_activAid%:Default

	if ges_lineTSlider_tmp != %ges_lineTolerance%
		ges_lineTolerance := ges_lineTSlider_tmp

	if ges_symbolTSlider_tmp != %ges_symbolTolerance%
		ges_symbolTolerance := ges_symbolTSlider_tmp

	if ges_transSlider_tmp != %ges_trans%
	{
		ges_trans := ges_transSlider_tmp
		ges_trans_Hex := FormatHexNumber(ges_transSlider_tmp,2)
	}

	func_HotkeyWrite( "ges_GestureKey", ConfigFile , ges_ScriptName, "GestureHotkey" )
	IniRead, ges_StringGestureKey, %ConfigFile%, %ges_ScriptName%, GestureHotkey, MButton
	IniWrite, %ges_lineTolerance%, %ConfigFile%, %ges_ScriptName%, LineTolerance
	IniWrite, %ges_symbolTolerance%, %ConfigFile%, %ges_ScriptName%, SymbolTolerance
	IniWrite, %ges_numGestures%, %ConfigFile%, %ges_ScriptName%, NumGestures
	IniWrite, %ges_kantenColor%, %ConfigFile%, %ges_ScriptName%, KantenColor
	IniWrite, %ges_knotenColor%, %ConfigFile%, %ges_ScriptName%, KnotenColor
	IniWrite, %ges_trans%, %ConfigFile%, %ges_ScriptName%, Transparency



	Loop, %ges_numGestures%
	{
		Gui, ListView, ges_ListView
		LV_GetText(ges_tmp_desc, A_Index, 1)
		LV_GetText(ges_tmp_gesture, A_Index, 2)
		LV_GetText(ges_tmp_action, A_Index, 4)
		LV_GetText(ges_tmp_para, A_Index, 6)

		StringReplace, ges_tmp_gesture, ges_tmp_gesture,%A_Space%->%A_Space%,|,All
		StringReplace, ges_tmp_gesture, ges_tmp_gesture,°,,All

		ges_gestureDesc%A_Index% := ges_tmp_desc
		ges_gesture%A_Index% := ges_tmp_gesture
		ges_gestureCmd%A_Index% := ges_tmp_action
		ges_gesturePara%A_Index% := ges_tmp_para

		IniWrite,%ges_tmp_gesture%, %ConfigFile%, %ges_ScriptName%, Gesture%A_Index%
		IniWrite,%ges_tmp_desc%, %ConfigFile%, %ges_ScriptName%, GestureDesc%A_Index%
		IniWrite,%ges_tmp_action%, %ConfigFile%, %ges_ScriptName%, GestureCmd%A_Index%
		IniWrite,%ges_tmp_para%, %ConfigFile%, %ges_ScriptName%, GesturePara%A_Index%
	}
Return

AddSettings_MouseGestures:
Return

CancelSettings_MouseGestures:
Return

DoEnable_MouseGestures:
	; func_HotkeyEnable("ges_HOTKEYNAME")
	ges_hotkeyDown := 0

	registerHoldAction("GestureKey",lng_ges_action_gestureKey,"ges_startAction","ges_endAction")
	SetTimer, ges_checkGestureKey, 100
return

DoDisable_MouseGestures:
	; func_HotkeyDisable("ges_HOTKEYNAME")
	ges_hotkeyDown := 0

	if ges_drawOnScreen = 1
		gosub, ges_cleanUp

	unRegisterHoldAction("GestureKey")
	SetTimer, ges_checkGestureKey, Off
Return

DefaultSettings_MouseGestures:
Return

OnExitAndReload_MouseGestures:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_MouseGestures:
	; Hier kommen die Befehle hin, welche bei Win+F5 ausgeführt werden
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------
ges_cleanUp:
	Gdip_DeleteBrush(ges_Brush)
	Gdip_DeletePen(ges_Pen)

	SelectObject(ges_hdc, ges_obm)
	DeleteObject(ges_hbm)
	DeleteDC(ges_hdc)
	Gdip_DeleteGraphics(ges_G)

	GuiDefault("MouseGesturesPen")
	Gui, Destroy
return

ges_createPenGui:
	ges_Width := A_ScreenWidth
	ges_Height := A_ScreenHeight

	ges_hwnd := GuiDefault("MouseGesturesPen","-Caption +E0x80020 +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs")
	Gui, Show, NA

	ges_hbm := CreateDIBSection(ges_Width, ges_Height)
	ges_hdc := CreateCompatibleDC()                          ; Get a device context compatible with the screen
	ges_obm := SelectObject(ges_hdc, ges_hbm)                ; Select the bitmap into the device context
	ges_G := Gdip_GraphicsFromHDC(ges_hdc)                   ; Get a pointer to the graphics of the bitmap, for use with drawing functions
	Gdip_SetSmoothingMode(ges_G, 4)                          ; Set the smoothing mode to antialias = 4 to make shapes appear smoother (only used for vector drawing and filling)

	ges_Brush := Gdip_BrushCreateSolid(ges_knoten)
	ges_Pen := Gdip_CreatePen(ges_kante, 4)
return


ges_startAction:
	SetTimer, ges_checkGestureKey, Off
	ges_hotkeyDown := 1
	gosub, ges_startDetection
return

ges_endAction:
	SetTimer, ges_checkGestureKey, 100
	ges_hotkeyDown := 0
	gosub, ges_endDetection
return

ges_checkGestureKey:
	ges_hotkeyDown := GetKeyState(ges_StringGestureKey,"P")

	if (ges_hotkeyDown > 0 && ges_prevHotkeyDown = 0)
		gosub, ges_startDetection

	if (ges_hotkeyDown = 0 && ges_prevHotkeyDown > 0)
		gosub, ges_endDetection

	ges_prevHotkeyDown := ges_hotkeyDown
return

ges_detectMotion:
	if ges_hotkeyDown = 1
	{
		CoordMode, Mouse, Screen
		MouseGetPos, ges_tmp_x, ges_tmp_y

		if (ges_tmp_x != ges_prev_x || ges_tmp_y != ges_prev_y)
		{
			ges_tmp_degree := ges_getAngle(ges_tmp_x,ges_tmp_y,ges_prev_x,ges_prev_y)
			ges_difference := round(ges_diffAngles(ges_tmp_degree,ges_prev_degree))

			if ges_drawOnScreen = 1
				Gdip_DrawLine(ges_G, ges_Pen, ges_tmp_x, ges_tmp_y, ges_prev_x, ges_prev_y)

			if (ges_difference > ges_lineTolerance || ges_first = 1)
			{
				ges_first := 0
				ges_degList = %ges_degList%%ges_tmp_degree%|

				if ges_drawOnScreen = 1
					Gdip_FillRectangle(ges_G, ges_Brush, ges_prev_x-2, ges_prev_y-2, 5, 5)
			}

			if ges_drawOnScreen = 1
				UpdateLayeredWindow(ges_hwnd, ges_hdc, 0, 0, ges_Width, ges_Height)
		}

		ges_prev_degree := ges_tmp_degree
		ges_prev_x := ges_tmp_x
		ges_prev_y := ges_tmp_y
	}
return

ges_createGestureImage(gesture,w=128,h=128,bgColor="FFFFFFFF")
{
	Global ges_knoten, ges_kante, SettingsDir

	pBitmap := Gdip_CreateBitmap(w, h)

	G := Gdip_GraphicsFromImage(pBitmap)
	Gdip_SetSmoothingMode(G, 4)

	pBrush := Gdip_BrushCreateSolid(ges_knoten)
	pPen := Gdip_CreatePen(ges_kante, 2)

	whiteBrush := Gdip_BrushCreateSolid("0x" bgColor)
	Gdip_FillRectangle(G,whiteBrush,-4,-4,w+4,h+4)
	Gdip_DeleteBrush(whiteBrush)

	lineLength := 20
	padding := 5

	x1 := 0
	y1 := 0
	xLast := x1
	yLast := y1
	xMaxMinus := 0
	yMaxMinus := 0

	;text = 1: (%xLast%|%yLast%)`n

	Loop, parse, gesture, -
	{
		num := A_Index+1

		x%num% := xLast + round(cos(deg2rad(A_LoopField))*lineLength,0)
		y%num% := yLast + round(sin(deg2rad(A_LoopField))*lineLength,0)
		deg%num% := A_LoopField

		xLast := x%num%
		yLast := y%num%

		if xLast < %xMaxMinus%
			xMaxMinus := xLast

		if yLast < %yMaxMinus%
			yMaxMinus := yLast
	}

	Loop, %num%
	{
		x%A_Index% += -xMaxMinus
		y%A_Index% += -yMaxMinus

		if x%A_Index% > %xMaxPlus%
			xMaxPlus := x%A_Index%

		if y%A_Index% > %yMaxPlus%
			yMaxPlus := y%A_Index%

		text := text  A_Index ": (" x%A_Index% "|" y%A_Index% ")`n"
	}

	if yMaxPlus = 0
		yMaxPlus = 1

	ar := aspectRatio(xMaxPlus,yMaxPlus,w-(2*padding),h-(2*padding))
	StringSplit, ratio, ar, x

	xScale := ratio1 / xMaxPlus
	yScale := ratio2 / yMaxPlus
	xDiff := round((w-ratio1)/2,0)
	yDiff := round((h-ratio2)/2,0)


	Loop, %num%
	{
		x := Round(x%A_Index% * xScale,0)+xDiff
		y := Round(y%A_Index% * yScale,0)+yDiff
		deg := deg%A_Index%


		If A_Index > 1
		{
			Gdip_DrawLine(G, pPen, prevX, h-prevY, x, h-y)

			ges_drawArrow(G, pPen, deg,(prevX+x)/2 -2, h-((prevY+y)/2) -2)


/*
			if deg < 180
				deg := 270-deg
			else
				deg := 90-deg

			Gdip_FillPie(g, pBrush, (prevX+x)/2 -2, h-((prevY+y)/2) -2, 30, 30, -deg-20, 40)
*/



		}

		If A_Index = 2
		{
			Gdip_FillRectangle(G, pBrush, prevX-2, h-(prevY+2), 4, 4)

		}

		prevX := x
		prevY := y

		;text := text  A_Index ": (" x%A_Index% "|" y%A_Index% ")`n"
	}

	FileDelete, % SettingsDir "\Gestures\" gesture ".png"

	Gdip_SaveBitmapToFile(pBitmap, SettingsDir "\Gestures\" gesture ".png")
	Gdip_DisposeImage(pBitmap)
	Gdip_DeleteGraphics(G)

	;msgbox % text
}

ges_drawArrow(G,pPen,direction,x,y,degreeDiff=15,arrowLength=10)
{
	x += 2
	y += 2

	direction := 180 - direction

	xDiff := x + round(cos(deg2rad(direction+degreeDiff))*arrowLength,0)
	yDiff := y + round(sin(deg2rad(direction+degreeDiff))*arrowLength,0)
	Gdip_DrawLine(G, pPen, x, y, xDiff, yDiff)

	xDiff := x + round(cos(deg2rad(direction-degreeDiff))*arrowLength,0)
	yDiff := y + round(sin(deg2rad(direction-degreeDiff))*arrowLength,0)
	Gdip_DrawLine(G, pPen, x, y, xDiff, yDiff)
}

deg2rad(val)
{
	return val*4*atan(1)/180
}

ges_startDetection:
	ges_prev_degree := 0
	ges_first = 1
	ges_degList =

	CoordMode, Mouse, Screen
	MouseGetPos, ges_prev_x, ges_prev_y

	if ges_drawOnScreen = 1
		gosub, ges_createPenGui

	SetTimer, ges_detectMotion, 100
return

ges_endDetection:
	if ges_drawOnScreen = 1
		gosub, ges_cleanUp

	SetTimer, ges_detectMotion, Off

	;compare to symbols
	StringTrimRight, ges_degList, ges_degList, 1
	StringSplit, ges_degArray, ges_degList, |
	ges_lineNum := ges_degArray0

	Loop, %ges_numGestures%
	{
		ges_tmp_gesture := ges_gesture%A_Index%

		StringSplit, ges_tmpArray, ges_tmp_gesture, |
		ges_tmpLineNum := ges_tmpArray0

		if ges_tmpLineNum = %ges_lineNum%
		{
			ges_found := 1
			Loop, %ges_tmpLineNum%
			{
				ges_tmpDiff := ges_diffAngles(ges_degArray%A_Index%,ges_tmpArray%A_Index%)
				if ges_tmpDiff > %ges_symbolTolerance%
				{
					ges_found := 0
					break
				}
			}

			if ges_found = 1
			{
				ges_tmp_desc := ges_gestureDesc%A_Index%
				ges_tmp_cmd := ges_gestureCmd%A_Index%
				ges_tmp_para := ges_gesturePara%A_Index%

				if ges_enableTrayTip = 1
					BalloonTip(ges_ScriptName, lng_ges_recSymbol ":`n" ges_tmp_desc, "Info", 0, -1, 3)

				performAction(ges_tmp_cmd,ges_tmp_para)
				break
			}
		}
	}
return

ges_sub_CheckIfSettingsChanged:
	GuiControlGet, ges_lineTSlider_tmp,,ges_lineTSlider
	GuiControl,,ges_lineTSlider_text, %ges_lineTSlider_tmp%°

	GuiControlGet, ges_symbolTSlider_tmp,,ges_symbolTSlider
	GuiControl,,ges_symbolTSlider_text, %ges_symbolTSlider_tmp%°

	GuiControlGet, ges_transSlider_tmp,,ges_transSlider

	func_SettingsChanged("MouseGestures")
return

ges_sub_ListView:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, ges_ListView
	StringCaseSense, On
	If A_GuiEvent = s
		GuiControl, +Redraw, ges_ListView

	If A_GuiEvent in I,E,F,f,M,S,s
		Return

	ges_lastRow := ges_LVrow
	ges_LVrow := LV_GetNext()

	If A_GuiEvent in Normal,D,d
	{
		GuiControlGet, ges_temp, FocusV
		if ges_temp <> ges_ListView
			GuiControl, Focus, ges_ListView
		Return
	}

	StringCaseSense, Off

	LV_GetText(ges_RowText, ges_LVrow, 1)

	ges_EventInfo =
	If A_GuiEvent = K
		ges_EventInfo = %A_EventInfo%

	If ( A_GuiEvent = "A" OR A_GuiEvent = "DoubleClick" OR uh_EventInfo = 32 )
		Goto, ges_sub_EditGesture

	If ges_EventInfo = 46
		Goto, ges_sub_DelGesture
	If ges_EventInfo = 45
		Goto, ges_sub_AddGesture
return

ges_sub_addGesture:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, ges_ListView

	ges_numGestures++
	LV_Add("Select", "","","","",ges_numGestures,"")
	ges_LVrow := LV_GetNext()
	ges_EditTitle = %lng_ges_Add%

	Gosub, ges_sub_EditGesture
return

ges_sub_editGesture:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, ges_ListView

	if (ges_LVrow = 0 OR ges_LVrow = "")
		Goto, ges_sub_addGesture

	If ges_GUI = 3
		Return

	ges_GUI = 3

	LV_GetText(ges_ed_desc, ges_LVrow, 1)
	LV_GetText(ges_ed_gesture, ges_LVrow, 2)
	LV_GetText(ges_ed_actionDesc, ges_LVrow, 3)
	LV_GetText(ges_ed_action, ges_LVrow, 4)
	LV_GetText(ges_ed_num, ges_LVrow, 5)
	LV_GetText(ges_ed_para, ges_LVrow, 6)

	ges_actionList := ActionsDesc

	if ges_ed_actionDesc !=
		StringReplace, ges_actionList, ges_actionList, %ges_ed_actionDesc%, %ges_ed_actionDesc%|

	StringReplace, ges_ed_gesture, ges_ed_gesture,%A_Space%->%A_Space%,-,All
	StringReplace, ges_ed_gesture, ges_ed_gesture,°,,All



	Gui, %GuiID_activAid%:+Disabled
	GuiDefault("MouseGestures", "-MaximizeBox +Owner" GuiID_activAid)
	Gosub, GuiDefaultFont

	Gui, Add, Text, x10 y+7 w90, %lng_ges_desc%:
	Gui, Add, Edit, x+5 R1 yp-3 W200  vges_ed_desc, % ges_ed_desc

	Gui, Add, Text, x10 y+7 w90, %lng_ges_gesture%:
	Gui, Add, Edit, x+5 R1 yp-3 W200  vges_ed_gesture, % ges_ed_gesture

	Gui, Add, Text, x10 y+7 w90, %lng_ges_action%:
	Gui, Add, DropDownList, x+5 R20 yp-3 W200 vges_ed_actionDesc, % ges_actionList

	Gui, Add, Text, x10 y+7 w90, %lng_ges_action_para%:
	Gui, Add, Edit, x+5 R1 yp-3 W200 vges_ed_para, % ges_ed_para

	Gui, Add, Button, -Wrap y+10 x85 w100 Default gges_sub_OK, &OK
	Gui, Add, Button, -Wrap x+10 w100 gMouseGesturesGuiClose, %lng_Cancel%

	if gdiP_enabled = 1
	{
		IfNotExist, %SettingsDir%\Gestures
			FileCreateDir, %SettingsDir%\Gestures

		ges_createGestureImage(ges_ed_gesture)
		Gui, Add, Picture, y4 x+20 w128 h128 Border, %SettingsDir%\Gestures\%ges_ed_gesture%.png
	}

	Gui, Show, AutoSize, %ges_EditTitle%
return

MouseGesturesGuiEscape:
MouseGesturesGuiClose:
	If GetKey = Escape
	{
		GetKey =
		Return
	}
	Gui, %GuiID_activAid%:-Disabled
	Gui, Submit
	Gui, Destroy
	Gui, %GuiID_activAid%:Default
	Gui, ListView, ges_ListView

	ges_GUI =

	If ges_EditTitle = %lng_ges_Add%
	{
		LV_Delete( ges_LVrow )
		ges_numGestures--
	}
	ges_EditTitle = %lng_ges_Edit%

	ges_SettingsChanged =
return

ges_sub_delGesture:
	Critical

	If ges_numGestures = 0
		Return

	Gui, %GuiID_activAid%:Default
	Gui, ListView, ges_ListView

	ges_LVrow := LV_GetNext()
	LV_GetText(ges_Num, ges_LVrow, 5)

	LV_Delete( ges_LVrow )
	LV_Modify( ges_LVrow, "Select")

	ges_delRows := ges_numGestures - ges_Num

	GuiControl, -Redraw, ges_ListView
	Loop, %ges_delRows%
	{
		ges_nextRow := ges_Num + A_Index
		ges_thisRow := ges_nextRow - 1
		ges_gesture%ges_thisRow% := ges_gesture%ges_nextRow%
		ges_gestureDesc%ges_thisRow% := ges_gestureDesc%ges_nextRow%
		ges_gestureCmd%ges_thisRow% := ges_gestureCmd%ges_nextRow%
		ges_gesturePara%ges_thisRow% := ges_gesturePara%ges_nextRow%

		LV_Modify( ges_LVrow+A_Index-1,"Col5", ges_thisRow)
	}
	GuiControl, +Redraw, ges_ListView
	ges_numGestures--

	func_SettingsChanged( "MouseGestures" )
return

ges_sub_OK:
	Gui, %GuiID_activAid%:-Disabled
	Gui, Submit
	Gui, Destroy
	Gui, %GuiID_activAid%:Default
	Gui, ListView, ges_ListView

	ges_GUI =

	If ges_ed_desc =
		ges_ed_desc := ges_ed_actionDesc

	ges_ed_actDescArray := func_StrClean(ges_ed_actionDesc)
	ges_ed_tmpAct := ActionNameByDesc%ges_ed_actDescArray%

	StringReplace, ges_tmp_humanGesture, ges_ed_gesture,-,° ->%A_Space%,All
	ges_tmp_humanGesture = %ges_tmp_humanGesture%°

	LV_Modify( ges_LVrow,"" , ges_ed_desc, ges_tmp_humanGesture, ges_ed_actionDesc,ges_ed_tmpAct,ges_ed_Num,ges_ed_Para)

	ges_EditTitle = %lng_ges_Edit%
	func_SettingsChanged( "MouseGestures" )

	LV_Modify( ges_LVrow, "Vis" )
return

ges_diffAngles(ang1,ang2)
{
	result := abs(ang1 - ang2)

	if result > 180
		result := 360 - result

	return result
}

ges_phytagoras(x1,y1,x2,y2)
{
	;Distance Formula
	;Result = Sqrt((X2 - X1)² + (Y2 + Y1)²)

	XResult = %X2%
	XResult -= %X1%
	If XResult < 0
		XResult *= -1
	Transform, XResult, Pow, %XResult%, 2

	YResult = %Y2%
	YResult -= %Y1%
	If YResult < 0
		YResult *= -1
	Transform, YResult, Pow, %YResult%, 2

	Result = %XResult%
	Result += %YResult%
	Transform, Result, Pow, %Result%, 0.5

	return Result
}

ges_getAngle(x1,y1,x2,y2)
{
	;Angle Detection
	distance := ges_phytagoras(x1,y1,x2,y2)

	;Sine = (opp/hyp) OR IN OTHER WORDS
	;Sine = ((Y2-Y1)/Result)

	;1: (Y2-Y1) -> has to be positive
	Sine = %y2%.0
	Sine -= %y1%

	;Cosine = (adj/hyp) OR IN OTHER WORDS
	;Cosine = ((X2-X1)/Result)

	;1: (X2-X1) -> has to be positive
	Cosine = %x2%.0
	Cosine -= %x1%

	Sine /= %distance%
	Cosine /= %distance%

	;Convert values to degrees (on counter-clockwise)

	If Sine > 0
	{
		;0-90
		If Cosine >= 0
		{
			Transform, Result, ASin, %Sine%
			Result *= 57.29578
			Result -= 180
			Result *= -1
			return Result
		}

		;90-180
		If Cosine <= 0
		{
			Transform, Result, ACos, %Cosine%
			Result *= 57.29578
			Result -= 180
			Result *= -1
			return Result
		}
	}

	If Sine < 0
	{
		;180-270
		If Cosine <= 0
		{
			Transform, Result, ACos, %Cosine%
			Result *= 57.29578
			Result += 180
			return Result
		}

		;270-360
		If Cosine >= 0
		{
			Transform, Result, ACos, %Cosine%
			Result *= 57.29578
			Result += 180
			return Result
		}
	}

	If Sine = 0
	{
		;0
		If Cosine <= 0
		{
			Result = 0.000000
			return Result
		}

		;180
		If Cosine >= 0
		{
			Result = 180.000000
			return Result
		}
	}
}
