; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               ExplorerShrinker
; -----------------------------------------------------------------------------
; Prefix:             esh_
; Version:            0.3
; Date:               2007-06-07
; Author:             Dirk Schwarzmann, Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
;
; Nach einer Idee von halweg (deutsches AutoHotkey-Forum)
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_ExplorerShrinker:
	Prefix = esh
	%Prefix%_ScriptName    = ExplorerShrinker
	%Prefix%_ScriptVersion = 0.3
	%Prefix%_ScriptTitle   = %esh_ScriptName% v%esh_ScriptVersion%
	%Prefix%_Author        = Dirk Schwarzmann, Wolfgang Reszel
	RequireExtensions      =
	AddSettings_ExplorerShrinker =
	ConfigFile_ExplorerShrinker =

	CustomHotkey_ExplorerShrinker     = 1
	Hotkey_ExplorerShrinker           = ^NUMPADSUB
	HotkeyPrefix_ExplorerShrinker     = ~

	HotkeyClasses_ExplorerShrinker    = ahk_class ExploreWClass,ahk_class CabinetWClass

	HideSettings = 0
	EnableTray_ExplorerShrinker       =

	DisableIfCompiled_ExplorerShrinker =

	IconFile_On_ExplorerShrinker = %A_WinDir%\system32\shell32.dll
	IconPos_On_ExplorerShrinker = 97

	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %esh_ScriptName% - Explorerfenster mit optimaler Größe
		Description                   = Skaliert Explorerfenster auf die optimale Größe (kein unnötiger Freiraum). Funktioniert nur unter Windows XP.

		lng_esh_changeHeight            = Auch Höhe anpassen
		lng_esh_mayReposition           = Fenster verschieben, wenn nötig
		lng_esh_minimalHeight           = Mindesthöhe (Pixel):
		lng_esh_xMouseMode              = X-Maus Modus
		lng_esh_AdjustColumns           = Spaltenbreiten in der Detail-Ansicht automatisch optimieren (wie über Strg+ZiffernblockPlus)

		tooltip_esh_changeHeight        = Das Fenster wird nicht nur in der Breite, sondern auch in der Höhe an den Inhalt angepasst.`nDas Fenster kann also sehr flach werden, andererseits aber nicht höher als der Bildschirm.
		tooltip_esh_minimalHeight       = Wenn keine Dateien im Verzeichnis liegen, wäre der Anzeigebereich unsichtbar (weil er Null Pixel Höhe hat).`nHiermit erzwingen Sie einen sichtbaren Bereich in beliebiger Größe.
		tooltip_esh_mayReposition       = Wenn das Fenster nach der Größenänderung rechts oder unten aus dem Bild ragt, wird es soweit verschoben, bis es vollständig sichtbar ist.
		tooltip_esh_xMouseMode          = Je nachdem, über welchem Bereich die Maus steht, erhält automatisch die Ordner- oder Dateiansicht den Fokus.`nDamit muss man nicht mehr in den Bereich klicken (und evtl. Dateimarkierungen verlieren) wenn man scrollen will.
		tooltip_esh_AdjustColumns       = Vor der Anpassung der Fenstergröße werden alle Spalten der Detail-Ansicht auf die optimale Breite gesetzt.
	}
	Else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %esh_ScriptName% - Shrink explorer windows
		Description                   = Scales the explorer window to the optimal size (no needless space). Only works on Windows XP

		lng_esh_changeHeight         = Also change height
		lng_esh_mayReposition        = Reposition window if necessary
		lng_esh_minimalHeight        = Minimum height (pixel):
		lng_esh_xMouseMode           = X-Mouse mode
		lng_esh_AdjustColumns        = Automatically adjust column widths (like Ctrl+NumPlus)

		tooltip_esh_changeHeight     = The window can also be resized vertically to fit the content´s size.`nWhile the window height can become very small, it cannot grow bigger than the height of the desktop screen.
		tooltip_esh_minimalHeight    = If there are no files in a directory, the view area would be invisible (because of a height of zero pixels).`nWith this option you can force a minimal view area height.
		tooltip_esh_mayReposition    = If the window runs out of the screen after being resized, it can be repositioned to full visibility.
		tooltip_esh_xMouseMode       = The focus is given to the file list or directory list area if the mouse is hovering over it.`nNo need to click into the area (useful for scrolling without loosing selection of items)
	}

	IniRead, esh_changeHeight, %ConfigFile%, ExplorerShrinker, ChangeHeight, 1 ; #MOD
	IniRead, esh_mayReposition, %ConfigFile%, ExplorerShrinker, RepositionWindow, 1 ; #MOD
	IniRead, esh_minimalHeight, %ConfigFile%, ExplorerShrinker, MinimumHeight, 35
	IniRead, esh_xMouseMode, %ConfigFile%, ExplorerShrinker, xMouseMode, 0
	IniRead, esh_AdjustColumns, %ConfigFile%, ExplorerShrinker, AdjustColumns, 0
Return

SettingsGui_ExplorerShrinker:
	Gui, Add, CheckBox, -Wrap gesh_sub_CheckboxHeightSettings xs+10 y+10 vesh_changeHeight Checked%esh_changeHeight%, %lng_esh_changeHeight%

	Gui, Add, Text, xp+140, %lng_esh_minimalHeight%
	Gui, Add, Edit, x+5 yp-3 R1 w40 vesh_minimalHeight Limit0 gsub_CheckIfSettingsChanged, %esh_minimalHeight%
	Gui, Add, UpDown, Range0-1000, %esh_minimalHeight%

	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+10 y+5 vesh_mayReposition Checked%esh_mayReposition%, %lng_esh_mayReposition%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+10 y+5 vesh_AdjustColumns Checked%esh_AdjustColumns%, %lng_esh_AdjustColumns%

	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+10 y+20 vesh_xMouseMode Checked%esh_xMouseMode%, %lng_esh_xMouseMode%

	Gosub, esh_sub_CheckboxHeightSettings
Return

SaveSettings_ExplorerShrinker:
	IniWrite, %esh_changeHeight%, %ConfigFile%, ExplorerShrinker, ChangeHeight
	IniWrite, %esh_mayReposition%, %ConfigFile%, ExplorerShrinker, RepositionWindow
	IniWrite, %esh_minimalHeight%, %ConfigFile%, ExplorerShrinker, MinimumHeight
	IniWrite, %esh_xMouseMode%, %ConfigFile%, ExplorerShrinker, xMouseMode
	IniWrite, %esh_AdjustColumns%, %ConfigFile%, ExplorerShrinker, AdjustColumns
Return

AddSettings_ExplorerShrinker:
Return

CancelSettings_ExplorerShrinker:
Return

DoEnable_ExplorerShrinker:
	If (esh_xMouseMode = 1)
	{
		SetTimer, esh_sub_focusControl, 100
	}
	else
	{
		SetTimer, esh_sub_focusControl, Off
	}
Return

DoDisable_ExplorerShrinker:
	SetTimer, esh_sub_focusControl, Off
Return

DefaultSettings_ExplorerShrinker:
	esh_changeHeight := 0
	esh_mayReposition := 0
	esh_minimalHeight := 35
	esh_xMouseMode := 0

	Gosub, esh_sub_CheckboxHeightSettings
Return

OnExitAndReload_ExplorerShrinker:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

sub_Hotkey_ExplorerShrinker:
	Gosub, esh_main_ExplorerShrinker
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

esh_sub_CheckboxHeightSettings:
	Gosub, sub_CheckIfSettingsChanged
	GuiControlGet, esh_changeHeight_tmp, , esh_changeHeight
	If esh_changeHeight_tmp = 1
	{
		GuiControl,Enable, esh_minimalHeight
		GuiControl,Enable, %lng_esh_minimalHeight%
	}
	Else
	{
		GuiControl,Disable, esh_minimalHeight
		GuiControl,Disable, %lng_esh_minimalHeight%
	}
Return

; Hier wird das Explorerfenster verändert
esh_main_ExplorerShrinker:
	; Wirkt nur auf Windows Explorer
	WinGet, esh_windowID, ID, A
	WinGetClass, esh_windowType, ahk_id %esh_windowID%
	WinGet, esh_MinMax, MinMax, ahk_id %esh_windowID%
	If esh_MinMax = 1
		WinRestore, ahk_id %esh_windowID%

;  ControlGet, esh_numCol, LIST, COUNT COL, SysListView321, ahk_id %esh_windowID% ; Anzahl Spalten
;  SendMessage, 0x1000+29, 0, 0, SysListView321, ahk_id %esh_windowID%
;  tooltip, %esh_numCol% %ErrorLevel%
	esh_ControllClass =
	If esh_windowType in CabinetWClass,ExploreWClass,#32770
	{
		esh_ControlClass = SysListView321
		esh_AddWidth = 0
	}
	If esh_windowType in WinRarWindow
	{
		esh_ControlClass = SysListView321
		esh_AddWidth = 2
	}

	If esh_ControlClass =
	{
		Return
	}
	else
	{
		esh_func_GetViewRect_Explorer(esh_windowID,esh_ControlClass)

		; Teste, ob die Detailansicht eingeschaltet ist
		; 0 LV_VIEW_ICON
		; 1 LV_VIEW_DETAILS
		; 2 LV_VIEW_SMALLICON
		; 3 LV_VIEW_LIST
		; 4 LV_VIEW_TILE
		SendMessage, 4239, 0, 0, %esh_ControlClass%, A   ; 4239 is LVM_GETVIEW
		esh_LV_VIEW = %ErrorLevel%
	}

	; Fenstergröße und Position ermitteln:
	WinGetPos, esh_winXPos, esh_winYPos, esh_winWidth, esh_winHeight, ahk_id %esh_windowID%
	esh_winXposOld   = %esh_winXpos% ; #MOD
	esh_winYposOld = %esh_winYpos% ; #MOD
	esh_winWidthOld = %esh_winWidth% ; #MOD
	esh_winHeightOld = %esh_winHeight% ; #MOD


	; Aktuelle Größe der gesamten sichtbaren(!) Liste ermitteln:
	ControlGetPos, , , esh_listWidth, esh_listHeight, %esh_ControlClass%, ahk_id %esh_windowID%

	;tooltip, %esh_x1% %esh_y1% %esh_x2% %esh_y2%`n%esh_listWidth% %esh_ListHeight% %esh_LV_VIEW%

	If (esh_LV_VIEW = 1) ; LV_VIEW_DETAILS
	{
		; ======================================
		; Breiten ermitteln
		; ======================================

		; Anzahl der Datei-Spalten ermitteln:
		ControlGet, esh_numCol, LIST, COUNT COL, %esh_ControlClass%, ahk_id %esh_windowID% ; Anzahl Spalten

		; Jetzt Spaltenbreiten optimieren
		If esh_AdjustColumns = 1
			ControlSend, SysListView321, ^{NUMPADADD}, ahk_id %esh_windowID%   ; #MOD

		; Neue Breite aller Datei-Spalten ermitteln:
		esh_sumColWidth = 0
		Loop, %esh_numCol% ; Addiere alle Spaltenbreiten
		{
			esh_currCol := A_INDEX - 1
			SendMessage, 0x1000+29, esh_currCol, 0, %esh_ControlClass%, ahk_id %esh_windowID%  ; LVM_GETCOLUMNWIDTH
			esh_sumColWidth += ErrorLevel +1 ; #MOD
		}

		; Differenz bilden. Um diese muss das Explorerfenster verändert werden
		esh_winWidth -= (esh_listWidth - esh_sumColWidth) - esh_AddWidth

		; ======================================
		; Höhen ermitteln
		; ======================================

		; Höhe des Spaltenkopfes ermitteln (via LVM_GETHEADER)
		SendMessage, 0x1000+31, 0, 0, %esh_ControlClass%, ahk_id %esh_windowID%
		WinGetPos, , , , esh_rowHeaderHeight_DetailList, ahk_id %ErrorLevel%
		WinGet, wclass, Style, ahk_id %ErrorLevel%

		; Höhe der Zeilen ermitteln:
		esh_rowHeight_DetailList := func_GetLVRowHeight( "ahk_id " esh_windowID, esh_ControlClass)

		; Anzahl Zeilen der Liste ermitteln:
		ControlGet, esh_numRow, LIST, COUNT, %esh_ControlClass%, ahk_id %esh_windowID%

		; Berechne daraus die Höhe der Gesamtliste:
		esh_sumRowHeight := esh_numRow * esh_rowHeight_DetailList + BorderHeight ; #MOD
		If (esh_sumRowHeight < esh_minimalHeight)
		{
			esh_sumRowHeight := esh_minimalHeight
		}
		esh_sumRowHeight += esh_rowHeaderHeight_DetailList
	}
	Else if esh_LV_VIEW <> 3
	{
		SysGet, esh_scrollbarWidth, 2
		esh_winWidth := esh_winWidth - (esh_listWidth - esh_x2) + esh_scrollbarWidth + esh_x1 + BorderHeight
		esh_sumRowHeight := esh_y2 + esh_scrollbarWidth + esh_y1
	}
	Else
	{
		Return
		;SysGet, esh_scrollbarWidth, 2
		;esh_winWidth := esh_winWidth - (esh_listWidth - esh_x2) + esh_scrollbarWidth + BorderHeight
		;esh_sumRowHeight := esh_y2 + esh_scrollbarWidth
	}


	If (esh_changeHeight = 1)
	{
		; Größe des aktuellen Desktops holen. Aktuell ist der Desktop (=Monitor),
		; auf dem der Explorer liegt
		esh_CurrMonitor := func_GetMonitorNumber("A")
		esh_desktopWidth := WorkArea%esh_CurrMonitor%Width
		esh_desktopHeight := WorkArea%esh_CurrMonitor%Height
		esh_desktopLeft := WorkArea%esh_CurrMonitor%Left
		esh_desktopTop := WorkArea%esh_CurrMonitor%Top

		; Differenz bilden. Um diese muss das Explorerfenster verändert werden
		esh_winHeight -= (esh_listHeight - esh_sumRowHeight)

		; Maximale Größe begrenzen
		If (esh_winHeight > esh_desktopHeight)
		{
			esh_winHeight := esh_desktopHeight
			SysGet, esh_scrollbarWidth, 2       ; 2 ist SM_CXVSCROLL, Breite der senkrechten Scrollbar #MOD
			esh_winWidth := esh_winWidth + esh_scrollbarWidth ;- BorderHeight/2 + esh_AddWidth ; #MOD
		}
	}

	; ======================================
	; Fenster verändern
	; ======================================

	; Verschiebe das Fenster, wenn es aus dem Screen ragt
	If (esh_mayReposition = 1)
	{
		If ((esh_winXPos + esh_winWidth) > esh_desktopWidth)
		{
			esh_winXPos := esh_desktopWidth - esh_winWidth
		}
		If ((esh_winYPos + esh_winHeight) > esh_desktopHeight)
		{
			esh_winYPos := esh_desktopHeight - esh_winHeight
		}
		If (esh_winYPos < esh_desktopTop)
			esh_winYPos := esh_desktopTop
		If (esh_winXPos < esh_desktopLeft)
			esh_winXPos := esh_desktopLeft
	}

	; Fenstergröße anpassen
	If ( esh_winXPos = esh_winXPosOld AND esh_winYPos = esh_winYPosOld AND esh_winWidth = esh_winWidthOld AND esh_winHeightOld )
	{
		WinMove, ahk_id %esh_windowID%, , esh_winXPos%esh_windowID%, esh_winYPos%esh_windowID%, esh_winWidth%esh_windowID%, esh_winHeight%esh_windowID%
	}
	Else
	{
		WinMove, ahk_id %esh_windowID%, , esh_winXPos, esh_winYPos, esh_winWidth, esh_winHeight
		esh_winXpos%esh_windowID%   = %esh_winXposOld% ; #MOD
		esh_winYpos%esh_windowID% = %esh_winYposOld% ; #MOD
		esh_winWidth%esh_windowID% = %esh_winWidthOld% ; #MOD
		esh_winHeight%esh_windowID% = %esh_winHeightOld% ; #MOD

		; Berücksichtige einen evtl. waagerechten Scrollbalken.
		; Weil dieser erst _nach_ dem Resize bekannt ist, muss ggf. nochmal resized werden
		If esh_func_IsHorizontalScrollbar(esh_windowID)
		{
			SysGet, esh_scrollbarWidth, 2       ; 2 ist SM_CYVSCROLL, Breite der senkrechten Scrollbar
			esh_winWidth += esh_scrollbarWidth
			if esh_winWidth > esh_desktopWidth
				esh_winWidth := esh_desktopWidth
			WinMove, ahk_id %esh_windowID%, , , , esh_winWidth
		}
	}
Return

esh_func_GetViewRect_Explorer( explorer_ID, Class ) {
	global esh_x1,esh_y1,esh_x2,esh_y2

	WinGet, pid_target, PID, ahk_id %explorer_ID%

	hp_explorer := DllCall( "OpenProcess"
										, "uint", 0x18 ; PROCESS_VM_OPERATION|PROCESS_VM_READ
										, "int", false
										, "uint", pid_target )

	remote_buffer := DllCall( "VirtualAllocEx"
										, "uint", hp_explorer
										, "uint", 0
										, "uint", 0x1000
										, "uint", 0x1000 ; MEM_COMMIT
										, "uint", 0x4 ) ; PAGE_READWRITE

	; LVM_GETVIEWRECT
	;   LVIR_BOUNDS
	SendMessage, 0x1000+34, 0, remote_buffer, %Class%, ahk_id %explorer_ID%

	VarSetCapacity( rect, 16, 0 )
	result := DllCall( "ReadProcessMemory"
								, "uint", hp_explorer
								, "uint", remote_buffer
								, "uint", &rect
								, "uint", 16
								, "uint", 0 )

	result := DllCall( "VirtualFreeEx"
								, "uint", hp_explorer
								, "uint", remote_buffer
								, "uint", 0
								, "uint", 0x8000 ) ; MEM_RELEASE

	result := DllCall( "CloseHandle", "uint", hp_explorer )

	esh_x1 := esh_func_GetUInt(rect, 0)
	esh_y1 := esh_func_GetUInt(rect, 1)
	esh_x2 := esh_func_GetUInt(rect, 2)
	esh_y2 := esh_func_GetUInt(rect, 3)

	Return
}

esh_func_GetUInt( ByRef @struct, _offset=0 ) {
	local addr
	addr := &@struct + _offset * 4
	Return *addr + (*(addr + 1) << 8) +  (*(addr + 2) << 16) + (*(addr + 3) << 24)
}

esh_func_IsHorizontalScrollbar( explorer_ID ) {
	ControlGet, Control_Style, Style, , SysListView321, ahk_id %explorer_ID%

	If (Control_Style & 0x100000)  ; 0x100000 is WS_HSCROLL
		Return 1
	Else
		Return 0
}

esh_func_IsVerticalScrollbar( explorer_ID ) {
	ControlGet, Control_Style, Style, , SysListView321, ahk_id %explorer_ID%

	If (Control_Style & 0x200000)  ; 0x200000 is WS_VSCROLL
		Return 1
	Else
		Return 0
}

esh_sub_focusControl:
	; Wirkt nur auf Windows Explorer
	WinGet, esh_windowID, ID, A
	WinGetClass, esh_windowType, ahk_id %esh_windowID%
	If (esh_windowType != "CabinetWClass" AND esh_windowType != "ExploreWClass")
	{
		; Kein Explorer? Dann war´s das
		Return
	}

	MouseGetPos, , , , esh_controlElem

	If (esh_controlElem = "SysTreeView321" AND oldFocus <> "SysTreeView321")
	{
		ControlFocus, %esh_controlElem%, ahk_id %esh_windowID%
		oldFocus := "SysTreeView321"
	}
	If (esh_controlElem = "SysListView321" AND oldFocus <> "SysListView321")
	{
		ControlFocus, %esh_controlElem%, ahk_id %esh_windowID%
		oldFocus := "SysListView321"
	}
Return

GetChildHWND( ParentHWND, ChildClassNN ) {
	WinGetPos, ParentX, ParentY,,, ahk_id %ParentHWND%
	if ParentX =
		return  ; Parent window not found (possibly due to DetectHiddenWindows).
	ControlGetPos, ChildX, ChildY,,, %ChildClassNN%, ahk_id %ParentHWND%
	if ChildX =
		return  ; Child window not found, so return a blank value.
	; Convert child coordinates -- which are relative to its parent's upper left
	; corner -- to absolute/screen coordinates for use with WindowFromPoint().
	; The following intentionally passes too many args to the function because
	; each arg is 32-bit, which allows the function to automatically combine
	; them into one 64-bit arg (namely the POINT structure):
	return DllCall("WindowFromPoint", "int", ChildX + ParentX, "int", ChildY + ParentY)
}

WatchScrollBar:
	VarSetCapacity(Str1, 16)
	ActiveWindow := WinExist("A")
	if not ActiveWindow  ; No active window.
		return
	; Display the vertical or horizontal scroll bar's position in a ToolTip:
	ChildHWND := GetChildHWND(ActiveWindow, "SysListView321")
	DllCall("GetScrollInfo", "UInt", ChildHWND, "Int", 1, "Int", &Str1, "Int", Str2, "Int", Str3, "Int", Str4)  ;  Last param is 1 for SB_VERT, 0 for SB_HORZ.
	ToolTip % ExtractInteger (Str1) "`t" ExtractInteger(Str2) "`t" ExtractInteger(Str3) "`t" ExtractInteger(Str4)
return
