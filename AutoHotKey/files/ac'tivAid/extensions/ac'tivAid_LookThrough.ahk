; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               LookThrough
; -----------------------------------------------------------------------------
; Prefix:             look_
; Version:            0.3
; Date:               2007-11-09
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_LookThrough:
	Prefix = look
	%Prefix%_ScriptName    = LookThrough
	%Prefix%_ScriptVersion = 0.3
	%Prefix%_Author        = Wolfgang Reszel
	RequireExtensions      =
	AddSettings_LookThrough =
	ConfigFile_LookThrough = ; %SettingsDir%\datei.ini

	CustomHotkey_LookThrough = 1          ; automatisches benutzerdefinierbares Tastaturkürzel? (1 = ja)
	Hotkey_LookThrough       = F9         ; Standard-Hotkey
	HotkeyPrefix_LookThrough =            ; Präfix, welches vor immer vor dem Tastaturkürzel gesetzt wird
																; in diesem Fall sorgt es dafür, dass das Tastaturkürzel durchgeschleift wird.

	HideSettings = 0                             ; Wenn 1, dann bekommt die Erweiterung keinen Eintrag im Konfigurationsdialog
	EnableTray_LookThrough   =            ; Soll eine Erweiterung nicht im Tray-Menü aufgeführt werden, muss der Wert 0 betragen

	DisableIfCompiled_LookThrough =       ; Wenn 1, lässt sich die Erweiterung in kompilierter Form nicht de-/aktivieren

	IconFile_On_LookThrough = %A_WinDir%\system32\shell32.dll
	IconPos_On_LookThrough = 172

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %look_ScriptName% - Blick auf den Desktop
		Description                   = Über ein Tastaturkürzels wird ein Loch in alle Anwendungsfenster 'gebohrt', um durch sie hindurch auf den Desktop zu schauen.
		lng_look_ToggleMode           = Modus:
		lng_look_ToggleMode1          = Temporär, beim Gedrückt-halten des Tastaturkürzels (nur ohne Strg/Shift/Win/Alt möglich)
		lng_look_ToggleMode2          = Tastaturkürzel schaltet LookThrough an und beim erneuten Betätigen wieder aus
		lng_look_Center               = Ausschnitt immer am Mauspfeil zentrieren
		lng_look_SlowRefreshing       = Ausschnitt erst verschieben, wenn die Maus stehen bleibt (ressourcensparend)
		lng_look_OnlyActiveWindow     = Nur das aktive Fenster 'durchbohren'
		lng_look_Size                 = Größe des Lochs (in Pixel):
		lng_look_Radius               = Ecken abrunden (in `%):
		lng_look_DontAlwaysRefrehsWindowList = Nachträglich erscheinende Fenster/Menüs werden nicht 'durchlöchert'
		lng_look_ExcludeClasses       = Fenster-Klassen, welche nicht 'durchlöchert' werden sollen:
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %look_ScriptName% - Look onto the desktop
		Description                   = Punches a hole into application windows to look through them onto the desktop.
		lng_look_ToggleMode           = Mode:
		lng_look_ToggleMode1          = Temporary while holding down the hotkey (only possible without Ctrl/Shift/Win/Alt)
		lng_look_ToggleMode2          = The hotkey toggles LookThrough
		lng_look_Center               = Center cutout to the mouse cursor
		lng_look_SlowRefreshing       = Move cutout only if the mouse does not move (save resources)
		lng_look_OnlyActiveWindow     = Look only through the active window
		lng_look_Size                 = Hole size (in pixel):
		lng_look_Radius               = Round corners (in `%):
		lng_look_DontAlwaysRefrehsWindowList = Don't punch holes in windows which are created later
	}

	IniRead, look_ToggleMode, %ConfigFile%, LookThrough, ToggleMode, 1
	IniRead, look_Center, %ConfigFile%, LookThrough, CenterToMouse, 0
	IniRead, look_SlowRefreshing, %ConfigFile%, LookThrough, SlowRefreshing, 0
	IniRead, look_OnlyActiveWindow, %ConfigFile%, LookThrough, OnlyActiveWindow, 0
	IniRead, look_Width, %ConfigFile%, LookThrough, HoleSize, 200
	IniRead, look_DontAlwaysRefrehsWindowList, %ConfigFile%, LookThrough, DontAlwaysRefrehsWindowList, 0

	IniRead, look_ExcludeClasses, %ConfigFile%, LookThrough, ExcludeClasses, BaseBar
	IniRead, look_Radius, %ConfigFile%, LookThrough, HoleRadius, 20

Return

SettingsGui_LookThrough:
	Gui, Add, Text, xs+10 y+5 , %lng_look_ToggleMode%
	Gui, Add, Radio, -Wrap xs+10 y+5 gsub_CheckIfSettingsChanged vlook_ToggleMode1, %lng_look_ToggleMode1%
	Gui, Add, Radio, -Wrap xs+10 y+5 gsub_CheckIfSettingsChanged vlook_ToggleMode2, %lng_look_ToggleMode2%
	GuiControl, , look_ToggleMode%look_ToggleMode%, 1
	Gui, Add, CheckBox, -Wrap xs+10 y+5 gsub_CheckIfSettingsChanged vlook_Center Checked%look_Center%, %lng_look_Center%
	Gui, Add, CheckBox, -Wrap xs+10 y+5 gsub_CheckIfSettingsChanged vlook_SlowRefreshing Checked%look_SlowRefreshing%, %lng_look_SlowRefreshing%
	Gui, Add, CheckBox, -Wrap xs+10 y+5 gsub_CheckIfSettingsChanged vlook_OnlyActiveWindow Checked%look_OnlyActiveWindow%, %lng_look_OnlyActiveWindow%
	Gui, Add, Text, xs+10 y+9 , %lng_look_Size%
	Gui, Add, Edit, x+5 yp-3 gsub_CheckIfSettingsChanged vlook_Width w40, %look_Width%
	Gui, Add, Text, x+10 yp+3 , %lng_look_Radius%
	Gui, Add, Slider, x+5 yp-7 gsub_CheckIfSettingsChanged vlook_Radius Range0-100 TickInterval10 ToolTip, %look_Radius%
	Gui, Add, CheckBox, -Wrap xs+10 y+8 gsub_CheckIfSettingsChanged vlook_DontAlwaysRefrehsWindowList Checked%look_DontAlwaysRefrehsWindowList%, %lng_look_DontAlwaysRefrehsWindowList%

	Gui, Add, Text, xs+10 y+10, %lng_look_ExcludeClasses%
	StringReplace, look_ExcludeClasses_tmp, look_ExcludeClasses, `,, `n, A
	Gui, Add, Edit, y+5 w460 R4 vlook_ExcludeClasses_tmp gsub_CheckIfSettingsChanged, %look_ExcludeClasses_tmp%
	Gui, Add, Button, -Wrap x+5 w20 h21 vlook_Add_ExcludeClasses glook_sub_addApp, +
Return

look_sub_addApp:
	GuiControlGet, look_ExcludeClasses_Tmp,,look_ExcludeClasses_tmp
	StringReplace, look_VarApp, A_GuiControl, Add_,
	WinSet,Bottom,, %ScriptTitle%
	SplashImage,,b1 cwFFFF80 FS9 WS700, %lng_AddApps%
	Gui,+Disabled
	Input,look_GetKey,,{Enter}{ESC}
	StringReplace,look_GetKey,ErrorLevel,Endkey:
	SplashImage, Off
	Gui,-Disabled
	WinGetClass, look_GetName, A
	look_GetName = %look_GetName%
	If look_Getkey = Enter
	{
		IfNotInstring, look_ExcludeClasses_Tmp, %look_GetName%
		{
			look_ExcludeClasses_Tmp = %look_ExcludeClasses_Tmp%`n%look_GetName%
			StringReplace, look_ExcludeClasses_Tmp, look_ExcludeClasses_Tmp, `n`n, `n, A
			StringReplace, look_ExcludeClasses_Tmp, look_ExcludeClasses_Tmp, `n`n, `n, A
			If (func_StrLeft(look_ExcludeClasses_Tmp,1) = "`n")
				StringTrimLeft, look_ExcludeClasses_Tmp, look_ExcludeClasses_Tmp, 1
			If (func_StrRight(look_ExcludeClasses_Tmp,1) = "`n")
				StringTrimRight, look_ExcludeClasses_Tmp, look_ExcludeClasses_Tmp, 1
			GuiControl,,%look_VarApp%_tmp, %look_ExcludeClasses_Tmp%
		}
	}
	Gui,Show
	WinSet, Top, , %ScriptTitle%
	func_SettingsChanged("LookThrough")
Return

; wird aufgerufen, wenn im Konfigurationsdialog OK oder Übernehmen angeklickt wird
SaveSettings_LookThrough:
	look_ToggleMode = 0
	Loop, 2
		look_ToggleMode := look_ToggleMode + A_Index * look_ToggleMode%A_Index%
	IniWrite, %look_ToggleMode%, %ConfigFile%, LookThrough, ToggleMode
	IniWrite, %look_Center%, %ConfigFile%, LookThrough, CenterToMouse
	IniWrite, %look_SlowRefreshing%, %ConfigFile%, LookThrough, SlowRefreshing
	IniWrite, %look_OnlyActiveWindow%, %ConfigFile%, LookThrough, OnlyActiveWindow
	IniWrite, %look_Width%, %ConfigFile%, LookThrough, HoleSize
	IniWrite, %look_DontAlwaysRefrehsWindowList%, %ConfigFile%, LookThrough, DontAlwaysRefrehsWindowList
	IniWrite, %look_Radius%, %ConfigFile%, LookThrough, HoleRadius

	StringReplace, look_ExcludeClasses, look_ExcludeClasses_tmp, `n, `,, A
	IniWrite, %look_ExcludeClasses%, %ConfigFile%, LookThrough, ExcludeClasses
Return

; Wird aufgerufen, wenn Einstellungen über das 'Pfeil'-Menü hinzugefügt werden, ist nur notwendig wenn AddSettings_LookThrough = 1
AddSettings_LookThrough:
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_LookThrough:
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_LookThrough:
	; func_HotkeyEnable("look_HOTKEYNAME")
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern der Einstellungen aufgerufen
DoDisable_LookThrough:
	look_BreakLoop = 1
	DetectHiddenWindows, Off
	SetWindelay, -1
	Loop, %look_List%
	{
		WinGetClass, look_Class, % "ahk_id " look_List%A_Index%
		If look_Class in Shell_TrayWnd,Progman,WorkerW,%look_ExcludeClasses%
			continue
		WinGetPos, look_winX, look_winY, look_winW, look_winH, % "ahk_id " look_List%A_Index%
		look_lastID := look_List%A_Index%
		Gosub, look_RestoreWindowRgn
	}
	look_regionX :=
	look_regionY :=
Return

; wird aufgerufen, wenn der Anwender die Erweiterung auf die Standard-Einstellungen zurücksetzt
DefaultSettings_LookThrough:
	Gosub, DoDisable_LookThrough
Return

; wird aufgerufen, wenn ac'tivAid beendet oder neu geladen wird.
OnExitAndReload_LookThrough:
	Loop, %look_List%
	{
		WinGetClass, look_Class, % "ahk_id " look_List%A_Index%
		If look_Class in Shell_TrayWnd,Progman,WorkerW,%look_ExcludeClasses%
			continue
		WinGetPos, look_winX, look_winY, look_winW, look_winH, % "ahk_id " look_List%A_Index%
		look_lastID := look_List%A_Index%
		Gosub, look_RestoreWindowRgn
	}
	look_regionX :=
	look_regionY :=
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_LookThrough:
	; Disable Aero
	hModule := DllCall("LoadLibrary", "str", "dwmapi.dll")
	DllCall("dwmapi\DwmEnableComposition", "uint", 0)
	DetectHiddenWindows, Off
	look_BreakLoop =
	SetWindelay, -1
	WinGet, look_List, List
	look_width2 := look_width/2
	StringReplace, look_ThisHotkey, A_Thishotkey, $
	If look_ToggleMode = 1
	{
		SetTimer, look_tim_LookThrough, % 5 * look_SlowRefreshing * 10 + 10
		KeyWait, %look_ThisHotkey%
		look_BreakLoop = 1
		SetTimer, look_tim_LookThrough, Off
		WinGet, look_List, List
		If look_OnlyActiveWindow = 1
		{
			WinGetClass, look_Class, A
			If look_Class not in Shell_TrayWnd,Progman,WorkerW,%look_ExcludeClasses%
			{
				WinGet, look_lastID, ID, a
				Gosub, look_RestoreWindowRgn
			}
		}
		Else
		{
			Loop, %look_List%
			{
				look_Index := look_List-A_Index+1
				WinGetClass, look_Class, % "ahk_id " look_List%look_Index%
				If look_Class in Shell_TrayWnd,Progman,WorkerW,%look_ExcludeClasses%
					continue
				look_lastID := look_List%look_Index%
				Gosub, look_RestoreWindowRgn
			}
		}
		look_lastMouseX =
		look_lastMouseY =
		look_regionX =
		look_regionY =
		look_Timer = 0
	}
	Else
	{
		If look_Timer = 1
		{
			look_BreakLoop = 1
			SetTimer, look_tim_LookThrough, Off
			look_Timer = 0
			If look_OnlyActiveWindow = 1
			{
				WinGetClass, look_Class, A
				If look_Class not in Shell_TrayWnd,Progman,WorkerW,%look_ExcludeClasses%
				{
					WinGet, look_lastID, ID, a
					Gosub, look_RestoreWindowRgn
				}
			}
			Else
			{
				Loop, %look_List%
				{
					look_Index := look_List-A_Index+1
					WinGetClass, look_Class, % "ahk_id " look_List%look_Index%
					If look_Class in Shell_TrayWnd,Progman,WorkerW,%look_ExcludeClasses%
						continue

					look_lastID := look_List%look_Index%
					Gosub, look_RestoreWindowRgn
				}
			}
			look_lastMouseX =
			look_lastMouseY =
			look_regionX =
			look_regionY =
		}
		Else
			SetTimer, look_tim_LookThrough, % 5 * look_SlowRefreshing * 10 + 10
	}
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

look_tim_LookThrough:
	DetectHiddenWindows, Off
	look_Timer = 1
	CoordMode, Mouse, Screen
	WinGet, look_ID, ID, A
	MouseGetPos, look_mouseX, look_mouseY
	If (look_MouseX = look_lastMouseX AND look_MouseY = look_lastMouseY AND look_ID = look_lastID)
		Return
	If look_SlowRefreshing = 1
	{
		If (look_MouseX <> look_lastSlowMouseX OR look_MouseY <> look_lastSlowMouseY)
		{
			look_lastSlowMouseX = %look_MouseX%
			look_lastSlowMouseY = %look_MouseY%
			Return
		}
	}

	look_lastMouseX = %look_MouseX%
	look_lastMouseY = %look_MouseY%

	look_X := look_MouseX - look_width2/2
	look_Y := look_MouseY - look_width2/2

	If ( (look_MouseX < look_regionX OR look_MouseX > look_regionX+look_width2 OR look_MouseY < look_regionY OR look_MouseY > look_regionY+look_width2) OR look_Center = 1 OR look_ID <> look_lastID )
	{
		If (look_regionX = "" OR look_Center = 1)
		{
			look_MoveX := look_MouseX
			look_MoveY := look_MouseY
		}
		Else
		{
			If (look_MouseX < look_regionX)
				look_MoveX := look_X+look_width2
			If (look_MouseX > look_regionX+look_width2)
				look_MoveX := look_X
			If (look_Mousey < look_regionY)
				look_MoveY := look_Y+look_width2
			If (look_MouseY > look_regionY+look_width2)
				look_MoveY := look_Y
		}

		If look_OnlyActiveWindow = 1
		{

			If (look_ID <> look_lastID)
			{
				Gosub, look_RestoreWindowRgn
			}

			WinGetClass, look_Class, A
			If look_Class not in Shell_TrayWnd,Progman,WorkerW,%look_ExcludeClasses%
			{
				WinGetPos, look_winX, look_winY, look_winW, look_winH, ahk_id %look_ID%
				look_X := look_MoveX - look_winX - look_width/2
				look_Y := look_MoveY - look_winY - look_width/2
				look_W := look_X + look_width
				look_H := look_Y + look_width

				If look_Region%look_ID% =
				{
					look_Region%look_ID% := DllCall( "CreateRectRgn", "int", 0, "int", 0, "int", look_winW, "int", look_winH)
					look_RegionType%look_ID% := DllCall( "GetWindowRgn", "uint", look_ID, "uint", look_Region%look_ID%  )
				}

				look_HoleRgn := DllCall( "CreateRoundRectRgn", "int", look_X, "int", look_Y, "int", look_W, "int", look_H, "int", look_Width*look_Radius/100, "int", look_Width*look_Radius/100 )
				look_NewRgn := DllCall( "CreateRectRgn", "int", 0, "int", 0, "int", look_winW, "int", look_winH )

				If look_RegionType%look_ID% > 0
					DllCall( "CombineRgn", "uint", look_NewRgn, "uint", look_Region%look_ID% , "uint", look_HoleRgn, "int", 4 )
				Else
					DllCall( "CombineRgn", "uint", look_NewRgn, "uint", look_NewRgn , "uint", look_HoleRgn, "int", 4 )

				DllCall( "SetWindowRgn", "uint", look_ID, "uint", look_NewRgn, "uint", true )
;            DllCall( "DeleteObject", "uint", look_NewRgn )
;            DllCall( "DeleteObject", "uint", look_HoleRgn )
			}
		}
		Else
		{
			If look_DontAlwaysRefrehsWindowList = 0
				WinGet, look_List, List
			look_LoopRunning = 1
			Loop, %look_List%
			{
				If look_BreakLoop = 1
					break
				look_loopID := look_List%A_Index%
				WinGetClass, look_Class, ahk_id %look_loopID%
				If look_Class in Shell_TrayWnd,Progman,WorkerW,tooltips_class32,%look_ExcludeClasses%
					continue
				WinGet, look_Max, MinMax, ahk_id %look_loopID%
				If look_Max = -1
					continue
				WinGetPos, look_winX, look_winY, look_winW, look_winH, ahk_id %look_loopID%

				look_X := look_MoveX - look_winX - look_width/2
				look_Y := look_MoveY - look_winY - look_width/2
				look_W := look_X + look_width
				look_H := look_Y + look_width

				If look_Region%look_loopID% =
				{
					look_Region%look_loopID% := DllCall( "CreateRectRgn", "int", 0, "int", 0, "int", look_winW, "int", look_winH )
					look_RegionType%look_loopID% := DllCall( "GetWindowRgn", "uint", look_loopID, "uint", look_Region%look_loopID%  )
				}

				look_HoleRgn := DllCall( "CreateRoundRectRgn", "int", look_X, "int", look_Y, "int", look_W, "int", look_H, "int", look_Width*look_Radius/100, "int", look_Width*look_Radius/100 )
				look_NewRgn := DllCall( "CreateRectRgn", "int", 0, "int", 0, "int", look_winW, "int", look_winH )

				If look_RegionType%look_loopID% > 0
					DllCall( "CombineRgn", "uint", look_NewRgn, "uint", look_Region%look_loopID% , "uint", look_HoleRgn, "int", 4 )
				Else
					DllCall( "CombineRgn", "uint", look_NewRgn, "uint", look_NewRgn , "uint", look_HoleRgn, "int", 4 )

				DllCall( "SetWindowRgn", "uint", look_loopID, "uint", look_NewRgn, "uint", true )
;            DllCall( "DeleteObject", "uint", look_NewRgn )
;            DllCall( "DeleteObject", "uint", look_HoleRgn )
			}
			look_LoopRunning =
		}

		look_regionX := look_MoveX - look_width2/2
		look_regionY := look_MoveY - look_width2/2
		look_lastID = %look_ID%
	}
	look_BreakLoop =
Return

look_RestoreWindowRgn:
	WinGetClass, look_Class, ahk_id %look_lastID%
	WinGet, look_Pid, PID, ahk_id %look_lastID%
	If look_Region%look_lastID% <>
	{
		If (look_RegionType%look_lastID% = 0 OR (look_Class = "AutoHotkeyGUI" AND look_PID = activAidPID) )
			WinSet, Region,, ahk_id %look_lastID%
		Else
			DllCall( "SetWindowRgn", "uint", look_lastID, "uint", look_Region%look_lastID%, "uint", true )
		look_RegionType%look_lastID% =
		look_Region%look_lastID% =
	}
	; reanable Aero
	DllCall("dwmapi\DwmEnableComposition", "uint", 1)
Return
