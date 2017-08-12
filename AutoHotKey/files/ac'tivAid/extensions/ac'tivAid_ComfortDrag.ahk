; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               ComfortDrag
; -----------------------------------------------------------------------------
; Prefix:             cd_
; Version:            1.2
; Date:               2007-11-09
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_ComfortDrag:
	Prefix = cd
	%Prefix%_ScriptName    = ComfortDrag
	%Prefix%_ScriptVersion = 1.2
	%Prefix%_Author        = Wolfgang Reszel

	IconFile_On_ComfortDrag = %A_WinDir%\system32\shell32.dll
	IconPos_On_ComfortDrag = 148

	CreateGuiID("ComfortDragWhileDragging")

	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                        = %cd_ScriptName% - Fensterwechsel bei Drag&&Drop
		Description                     = Interaktives Wechseln und Verstecken von Fenstern während einer Drag&&Drop-Aktion.
		lng_cd_MenuGestures             = Web-Browser nur über die Titelleiste mit der rechte Maustaste versteckbar
		lng_cd_TempDesk                 = kurzfristiger Desktop
		lng_cd_ExcludeApps              = Folgende Anwendungen für eine 'Drag'-Aktion ignorieren ('Droppen' ist weiterhin möglich)
		lng_cd_MoveSteps                = Animationsgeschwindigkeit des kurzfristigen Desktops (1=Schnell, 40=Langsam)`nFür langsame PCs sind Einstellungen größer 1 nicht empfehlenswert.
		lng_cd_MoveStepsOut             = beim Rausfliegen
		lng_cd_MoveStepsIn              = beim Reinfliegen
		lng_cd_activateTargetWindow     = Zielfenster einer Drag&&Drop-Aktion immer in den Vordergrund holen
		lng_cd_FullScreenFix            = Problem mit festhängenden maximierten Fenstern umgehen
		lng_cd_HideOnlyOnDragging       = Fenster verstecken mit linker und rechter Maustaste nur bei Drag&&Drop-Aktionen
		tooltip_cd_FullScreenFix        = Aus = es wird versucht, maximierte Fenster einfach zu verschieben`nAktiviert = maximierte Fenster werden vor dem Verschieben in normale Fenster umgewandelt`nGrau/Grün = wie oben, jedoch werden die normalen Fenstermaße überschrieben, um Flackern zu verhindern
		tooltip_cd_activateTargetWindow = ... kann auch temporär bei einer Drag&Drop-Aktion`ndurch halten der Feststelltaste erreicht werden
		tooltip_cd_onTempDesk           = Ähnlich Win+D werden alle Fenster ausgeblendet.`nAlle Fenster werden an die Bildschirmränder verschoben und können`ndurch Klicken auf einer der beiden transparenten Balken wieder eingeblendet werden.
		tooltip_cd_HideOnlyOnDragging   = Durch Halten der linken Maustaste und  zusätzliches Klicken der`nrechten Maustaste kann das aktive Fenster kurzzeitig ausgeblendet werden.`nAus Kompatibilitätsgründen kann es erforderlich sein, diese Funktion zu nur für Drag&Drop-Aktionen zu aktivieren.
		tooltip_cd_onGestures           = Durch Halten der linken Maustaste und dem zusätzlichen Klicken der`nrechten Maustaste kann das aktive Fenster kurzzeitig ausgeblendet werden.`nEinige Web-Browser (z.B. Opera) haben diese Kombination ebenfalls mit einer Funktion belegt.`nDurch Aktivieren dieser Option wird die Kombination nur noch auf der Titelleiste eines Browser-Fensters abgefragt.
		tooltip_cd_ExcludeApps_Box_tmp  = Bei einigen Anwendungen wird eine Drag&Drop-Aktion fälschlicherweise erkannt, während man z.B. Text markiert.`nDas macht sich bemerkbar, wenn plötzlich das unten liegen Fenster aktiviert wird.`nAlle Anwendungen in dieser Liste werden von ComfortDrag ignoriert.
	}
	Else        ; = other languages (english)
	{
		MenuName                    = %cd_ScriptName% - window-switching while drag&&drop
		Description                 = Switching and hiding windows while drag && drop operations.
		lng_cd_MenuGestures         = web browsers only hideable from the title-bar with the right mouse-button
		lng_cd_TempDesk             = temporary desktop
		lng_cd_ExcludeApps          = Exclude the following applications from drag-actions (dropping is furthermore possible)
		lng_cd_MoveSteps            = animation speed of temporary Desktop (1=fast, 40=slow)`nOn slow PC's it's not recommended to set above 1.
		lng_cd_MoveStepsOut         = flying out
		lng_cd_MoveStepsIn          = flying in
		lng_cd_activateTargetWindow = always activate destination window
		lng_cd_FullScreenFix        = resolve problems with maximized windows
		lng_cd_HideOnlyOnDragging   = hide windows with left and right mousebutton only at drag&&drop operations
		tooltip_cd_FullScreenFix    = off = just trying to move a maximized window`nactive = simulating maximized windows by resizing`nalternate = like active, but to avoid flickering, the normal window-size will be overwritten
	}

	IniRead, cd_onGestures, %ConfigFile%, %cd_ScriptName%, GestureApplications, 1

	; Variable ExcludeApps aus der INI einlesen
	IniRead, cd_ExcludeApps, %ConfigFile%, %cd_ScriptName%, ExcludeApps, Illustrator.exe,Photoshop.exe,InDesign.exe,AcroRd32.exe,Opera.exe,med.exe,EmEditor.exe,Firefox.exe,Excel.exe
	StringReplace, cd_ExcludeApps, cd_ExcludeApps, |, `,, All

	IniRead, cd_onTempDesk, %ConfigFile%, %cd_ScriptName%, TemporaryDesktop, 1
	IniRead, cd_FullScreenFix, %ConfigFile%, %cd_ScriptName%, AlternateMaxWinHandling, 0
	IniRead, cd_HideOnlyOnDragging, %ConfigFile%, %cd_ScriptName%, HideWithRBOnlyOnDragging, 0

	func_HotkeyRead( "cd_TempDesk" , ConfigFile, cd_ScriptName, "Hotkey_TempDesk", "cd_main_ComfortDrag_TempDesk", "F10" )
	func_HotkeyDisable( "cd_TempDesk" )

	IniRead, cd_MoveStepsOut, %ConfigFile%, %cd_ScriptName%, MoveStepsOut_TempDesk, 1
	IniRead, cd_MoveStepsIn, %ConfigFile%, %cd_ScriptName%, MoveStepsIn_TempDesk, 1
	IniRead, cd_activateTargetWindow, %ConfigFile%, %cd_ScriptName%, activateTargetWindow, 0
	IniRead, cd_DontMaximize, %ConfigFile%, %cd_ScriptName%, DontMaximize, 0

	Gesture_Exclusions = OperaWindowClass,MozillaWindowClass,Internet Explorer_Server
	Gesture_ExtendedExclusions = TMyListBox,SysHeader32
Return

SettingsGui_ComfortDrag:
	Gui, Add, CheckBox, XS+10 YP+13 gsub_CheckIfSettingsChanged vcd_activateTargetWindow -Wrap Checked%cd_activateTargetWindow%, %lng_cd_activateTargetWindow%
	Gui, Add, CheckBox, XS+10 Y+3 gsub_CheckIfSettingsChanged vcd_onGestures -Wrap Checked%cd_onGestures%, %lng_cd_MenuGestures%
	Gui, Add, CheckBox, XS+10 Y+3 gsub_CheckIfSettingsChanged vcd_HideOnlyOnDragging -Wrap Checked%cd_HideOnlyOnDragging%, %lng_cd_HideOnlyOnDragging%
	Gui, Add, Text, XS+10 Y+8, %lng_cd_ExcludeApps%:
	StringReplace, cd_ExcludeApps_Box, cd_ExcludeApps , `, , | , a
	Gui, Add, ListBox, Y+5 vcd_ExcludeApps_Box_tmp W200 R8, %cd_ExcludeApps_Box%
	Gui, Add, Button, -Wrap x+5 w20 vcd_Add_ExcludeApps_Box gsub_ListBox_addApp, +
	Gui, Add, Button, -Wrap y+5 w20 vcd_Remove_ExcludeApps_Box gsub_ListBox_remove, %MinusString%

	Gui, Add, CheckBox, XS+10 Y+70 gsub_CheckIfSettingsChanged vcd_onTempDesk -Wrap Checked%cd_onTempDesk%, %lng_cd_TempDesk%
	func_HotkeyAddGuiControl( lng_Hotkey, "cd_TempDesk", "x+20" )

	Gui, Add, Text, xs+10 y+8, %lng_cd_MoveSteps%:
	Gui, Add, Text, y+8, %lng_cd_MoveStepsOut%:
	Gui, Add, Dropdownlist, gsub_CheckIfSettingsChanged x+5 yp-3 w50 vcd_MoveStepsOut, 1|2|3|4|5|6|7|8|9|10|15|20|25|30|35|40
	Gui, Add, Text, x+10 yp+3, %lng_cd_MoveStepsIn%:
	Gui, Add, Dropdownlist, gsub_CheckIfSettingsChanged x+5 yp-3 w50 vcd_MoveStepsIn, 1|2|3|4|5|6|7|8|9|10|15|20|25|30|35|40
	Gui, Add, Checkbox, x+75 yp-3 w190 R2 Check3 gsub_CheckIfSettingsChanged vcd_FullScreenFix Checked%cd_FullScreenFix%, %lng_cd_FullScreenFix%
	GuiControl, ChooseString, cd_MoveStepsOut, %cd_MoveStepsOut%
	GuiControl, ChooseString, cd_MoveStepsIn, %cd_MoveStepsIn%
Return

SaveSettings_ComfortDrag:
	IniWrite, %cd_activateTargetWindow%, %ConfigFile%, %cd_ScriptName%, activateTargetWindow
	IniWrite, %cd_onGestures%, %ConfigFile%, %cd_ScriptName%, GestureApplications
	IniWrite, %cd_onTempDesk%, %ConfigFile%, %cd_ScriptName%, TemporaryDesktop
	If (func_StrLeft(cd_ExcludeApps_Box,1) = "|")
		StringTrimleft, cd_ExcludeApps_Box, cd_ExcludeApps_Box, 1
	StringReplace, cd_ExcludeApps, cd_ExcludeApps_Box, | , `, , a
	IniWrite, %cd_ExcludeApps%, %ConfigFile%, %cd_ScriptName%, ExcludeApps
	IniWrite, %cd_MoveStepsOut%, %ConfigFile%, %cd_ScriptName%, MoveStepsOut_TempDesk
	IniWrite, %cd_MoveStepsIn%, %ConfigFile%, %cd_ScriptName%, MoveStepsIn_TempDesk
	func_HotkeyWrite( "cd_TempDesk", ConfigFile, cd_ScriptName, "Hotkey_TempDesk" )
	IniWrite, %cd_FullScreenFix%, %ConfigFile%, %cd_ScriptName%, AlternateMaxWinHandling
	IniWrite, %cd_HideOnlyOnDragging%, %ConfigFile%, %cd_ScriptName%, HideWithRBOnlyOnDragging
Return

CancelSettings_ComfortDrag:
Return

DoEnable_ComfortDrag:
	If Enable_ComfortDrag = 1
	{
		Settimer, cd_tim_LButtonWatch, 10

		If cd_onTempDesk = 1
			func_HotkeyEnable( "cd_TempDesk" )
		RegisterHook( "MButton", "ComfortDrag" )
		RegisterHook( "RButton", "ComfortDrag" )
	}
Return

DoDisable_ComfortDrag:
	func_HotkeyDisable( "cd_TempDesk" )
	Settimer, cd_tim_LButtonWatch, Off
	UnRegisterHook( "MButton", "ComfortDrag" )
	UnRegisterHook( "RButton", "ComfortDrag" )
Return

DefaultSettings_ComfortDrag:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =============================================================cd==
; -----------------------------------------------------------------------------

RButton_ComfortDrag:
	If cd_EnableRButton = 1
	{
		If (StrokeIt = 1 AND cd_StrokeItDisable = "")
		{
			cd_StrokeItDisable = 1
			SendMessage, 0x9c44, 0x010064, 0, , ahk_class StrokeIt
			SendMessage, 0x405, 1, 0x204, , ahk_class StrokeIt
			SendMessage, 0x405, 1, 0x205, , ahk_class StrokeIt
		}
		Gosub, cd_main_ComfortDrag_RButton
		RButton_send = no
	}
Return

MButton_ComfortDrag:
	GetKeyState,cd_LButtonstate,LButton, P
	If (cd_LButtonstate = "D" AND Enable_ComfortDrag = 1)
	{
		Gosub, cd_sub_ShowWindow
		MButton_send = no
	}
Return

#IfWinExist, ComfortDragWhileDragging
~ESC::Gosub, cd_main_ComfortDrag_ESC
$PgUp::Gosub, cd_main_ComfortDrag_RButton
$PgDn::Gosub, MButton_ComfortDrag
$Space::Gosub, cd_sub_actImmediately
#IfWinExist

; -----------------------------------------------------------------------------
; === Subroutines =========================================================cd==
; -----------------------------------------------------------------------------

cd_tim_LButtonWatch:
	GetKeyState,cd_LBstateP,LButton

	if ( cd_LBstateP = "D" AND cd_LastLBstateP = "U" )
	{
		Gosub, cd_main_ComfortDrag_LButton
	}
	if ( cd_LBstateP = "U" AND cd_LastLBstateP = "D" )
	{
		Gosub, cd_main_ComfortDrag_LButtonUp
	}

	cd_LastLBstateP = %cd_LBstateP%

	WinGet, cd_bwWinID, ID, A
	If (cd_bwWinID <> "" AND TempDeskWindows = "" AND cd_WinBeforeTD="")
	{
		IfInString, TempDeskWindowsToMaximize, %cd_bwWinID%|
		{
			StringReplace, TempDeskWindowsToMaximize, TempDeskWindowsToMaximize, %cd_bwWinID%|,
			If cd_FullScreenFix = 1
				WinMove, ahk_id %cd_bwWinID%,, % TempDeskWindowX2[%cd_bwWinID%], % TempDeskWindowY2[%cd_bwWinID%], % TempDeskWindowW2[%cd_bwWinID%], % TempDeskWindowH2[%cd_bwWinID%]
			If cd_DontMaximize = 0
				WinMaximize, ahk_id %cd_bwWinID%
			IniWrite, %TempDeskWindowsToMaximize%, %ConfigFile%, TemporaryDesktop, WindowsToMaximize
		}
	}
Return

; linke Maustaste gedrückt
cd_main_ComfortDrag_LButton:
	cd_activeWindowHasChanged =
	cd_MouseStartCursor =
	cd_EnableRButton = 1

	WinGet, cd_activeStartWinID, ID, A

	CoordMode,Mouse,Screen
	MouseGetPos, cd_MouseStartDragX, cd_MouseStartDragY, cd_MouseStartWinID, cd_MouseStartControl
	WinGetPos, cd_WinStartX, cd_WinStartY,,, ahk_id %cd_MouseStartWinID%

	WinGetTitle, cd_MouseStartWinName, ahk_id %cd_MouseStartWinID%
	WinGet, cd_MouseStartProcName, ProcessName, ahk_id %cd_MouseStartWinID%

	If cd_ExcludeApps <>
		If cd_MouseStartProcName in %cd_ExcludeApps%
			Return

	If cd_MouseStartControl contains %Gesture_ExtendedExclusions%
		Return

	SetTimer, cd_tim_whileDragging, 50

	Gosub, DoEnable_MButton
Return

; linke Maustaste losgelassen
cd_main_ComfortDrag_LButtonUP:
	SetTimer, cd_tim_whileDragging, OFF
	SetTimer, cd_tim_ShowTree, Off
	Gosub, cd_sub_WhileDraggingWindowOff
	cd_EnableRButton = 0

	CoordMode,Mouse,Screen
	MouseGetPos, cd_actMouseX, cd_actMouseY, cd_actWinID

	Gosub, DoEnable_MButton

	If cd_temporaryTreeID <>
	{
		If (cd_HTMouseWinControl <> "SysTreeView321")
		{
			PostMessage, 0x111, 41525, 0, , ahk_id %cd_temporaryTreeID%
			cd_STMouseStartWinID =
			cd_hideTreeTimer =
			cd_temporaryTreeID =
		}
	}

	GetKeyState, cd_CapsLockStateL, CapsLock, L
	GetKeyState, cd_CapsLockState, CapsLock, P

	If cd_CapsLockStateL = D
		Send,{CapsLock}

	MouseGetPos,,,cd_activateWinID
	;Sleep, 600
	WinGet,cd_activateID,ID,A
	WinGetClass,cd_activateClass, A

	MouseGetPos,,,cd_tmpWinID
	WinGetTitle, cd_tmpTitle, ahk_id %cd_tmpWinID%

	If ((cd_CapsLockState = "D" OR (cd_activateTargetWindow = 1 AND cd_DraggingActive <> "") OR cd_activateClass = "#32770") AND cd_activeWindowHasChanged = "yes" AND !InStr(cd_tmpTitle,"TMPDSKaid") )
	{
		If cd_activateClass = #32770
			cd_activateWinID = %cd_activateID%
		Else
			IfWinNotActive, ahk_id %cd_activateWinID%
				WinActivate, ahk_id %cd_activateWinID%

		WinGet, cd_ExStyle, ExStyle, ahk_id %cd_activateWinID%

		If (cd_ExStyle & 0x8) ; 0x8 = WS_EX_TOPMOST.
			cd_actStartWin_AOT = yes
		Else
			cd_actStartWin_AOT = no

		If cd_actStartWin_AOT = no
			WinSet, AlwaysOnTop, On, ahk_id %cd_activateWinID%

		cd_activeStartWinID = %cd_activateWinID%
	}
	Else
		cd_activateWinID =

	IfNotInString, cd_TmpTitle, TMPDSKaid
	{
		If HiddenWindows <>
		{
			Gosub, cd_sub_RestoreHiddenWindows
		}
		If cd_activeWindowHasChanged = yes
		{
			SetTimer, cd_tim_activateUnderMouse, OFF
			cd_activateUnderMouseTimer = off
			IfWinNotActive, ahk_id %cd_activeStartWinID%
			  WinActivate, ahk_id %cd_activeStartWinID%
		}

		If ((cd_CapsLockState = "D" OR cd_activateTargetWindow = 1) AND cd_activeWindowHasChanged = "yes")
		{
			If cd_actStartWin_AOT = no
				WinSet, AlwaysOnTop, Off, ahk_id %cd_activateWinID%

			IfWinNotActive, ahk_id %cd_activateWinID%
				WinActivate, ahk_id %cd_activateWinID%
		}
	}

	If TempDeskWindows <>
	{
		IfInString, cd_TmpTitle, TMPDSKaid
		{
			Gosub, cd_sub_RestoreTempDeskWindows
;         WinSet, Redraw,, ahk_class Progman
		}
		If cd_activeWindowHasChanged = yes
		{
			Gosub, cd_sub_RestoreTempDeskWindows
;         WinSet, Redraw,, ahk_class Progman
		}
	}

	cd_activeWindowHasChanged = ; no
	cd_DragStartWinID =
	cd_DraggingActive =
Return

; während eine Operation ESC gedrückt
cd_main_ComfortDrag_ESC:
	cd_DraggingActive =
	SetTimer, cd_tim_ShowTree, Off
	SetTimer, cd_tim_whileDragging, Off
	Gosub, cd_sub_WhileDraggingWindowOff
	SetTimer, cd_tim_activateUnderMouse, Off

	If cd_temporaryTreeID <>
	{
		If (cd_HTMouseWinControl <> "SysTreeView321")
		{
			PostMessage, 0x111, 41525, 0, , ahk_id %cd_temporaryTreeID%
			cd_STMouseStartWinID =
			cd_hideTreeTimer =
			cd_temporaryTreeID =
		}

	}

	If HiddenWindows <>
	{
		GetKeyState, cd_CapsLockState, CapsLock, P

		If cd_CapsLockState = D
		{
			Send,{CapsLock}
			MouseGetPos,,, cd_activeStartWinID
			WinActivate, ahk_id %cd_activeStartWinID%
		}
		Gosub, cd_sub_RestoreHiddenWindows
	}
	If TempDeskWindows <>
	{
		Gosub, cd_sub_RestoreTempDeskWindows
	}

	If cd_activeWindowHasChanged = yes
	{
		WinGetTitle, test, ahk_id %cd_activeStartWinID%
		cd_activateUnderMouseTimer = off
		WinActivate, ahk_id %cd_activeStartWinID%
		WinSet, Redraw,, ahk_id %cd_activeStartWinID%
	}

	If cd_DragStartWinID <>
	{
		WinHide, ahk_class Progman
		WinShow, ahk_class Progman
	}
	cd_DragStartWinID =

	Send,{LButton Up}
Return

; Timer der so lange ausgeführt wird, wie die linke Maustaste gerdückt ist
cd_tim_whileDragging:
	CoordMode,Mouse,Screen
	MouseGetPos, cd_actMouseX, cd_actMouseY, cd_actWinID

	If ( cd_lastMouseX = cd_actMouseX AND cd_lastMouseY = cd_actMouseY )
		Return

	cd_lastMouseX = %cd_actMouseX%
	cd_lastMouseY = %cd_actMouseY%
	cd_diffX := cd_MouseStartDragX - cd_actMouseX
	cd_diffY := cd_MouseStartDragY - cd_actMouseY
	Transform, cd_diffX, abs, %cd_diffX%
	Transform, cd_diffY, abs, %cd_diffY%
	If ( (cd_diffY < 5 AND cd_diffX < 5) OR cd_MouseStartControl = "")
		Return

	If ( cd_MouseStartCursor = "" OR (cd_actWinID = cd_DragStartWinID AND cd_MouseStartCursor = "Arrow") )
	{
		cd_MouseStartCursor = %A_Cursor%
		cd_DragStartWinID = %cd_actWinID%

		SetTimer, cd_tim_whileDragging, 500
		Gosub, cd_sub_WhileDraggingWindowOn
	}

	cd_DraggingActive = 1
	;sleep, 250

	; Dragging beginnt (Maus hat sich mehr als 5 Pixel bewegt)
	If ( cd_MouseStartCursor = "IBeam" )
	{
		SetTimer, cd_tim_activateUnderMouse, Off
		cd_activateUnderMouseTimer = off
		Return
	}

	; Vista-Teak
	IfWinExist, ahk_class SysDragImage
		cd_MouseStartCursor = VistaDragImage

	If cd_MouseStartCursor In Unknown,No,VistaDragImage
	{
		GetKeyState,cd_LButtonstate,LButton

		If cd_LButtonstate = D
		{
			WinGet, cd_activeWinID, ID, A
			MouseGetPos,cd_MouseX,,cd_MouseWinID
			WinGetTitle, cd_MouseWinTitle, ahk_id %cd_MouseWinID%
			WinGetClass, cd_MouseWinClass, ahk_id %cd_MouseWinID%

			If ( (cd_MouseX = WorkAreaLeft OR cd_MouseX = WorkAreaRight - 1 ) AND TempDeskWindows = "")
			{
				If cd_ExcludeApps <>
					If cd_MouseStartProcName contains %cd_ExcludeApps%
						Return

				If (cd_TempDeskTimer = "")
				{
					SetTimer, cd_tim_activateUnderMouse, Off
					SetTimer, cd_tim_activateTempDesk, 480
					cd_TempDeskTimer = on
					cd_activateUnderMouseTimer = off
					cd_LastWin = TMPDSKaid
				}
			}
			Else
			{
				If cd_TempDeskTimer = on
					SetTimer, cd_tim_activateTempDesk, Off

				If (cd_activeWinID <> cd_MouseWinID)
				{
					cd_makeActiveWinID = %cd_MouseWinID%

					If cd_MouseWinClass not in Shell_TrayWnd,Progman,WorkerW,BaseBar,SideBar_AppBarWindow,SideBar_HTMLHostWindow,SideBar_AppBarBullet,BasicWindow
					{
						If ( cd_activateUnderMouseTimer <> "on" )
						{
							cd_activateUnderMouseTimer = on
							MouseGetPos, cd_startMouseX , cd_startMouseY
							SetTimer, cd_tim_activateUnderMouse, 480
						}
					}
					IfNotInstring, cd_MouseStartControl, TMPDSKaid
						cd_LastWin =
				}
				Else
				{
					If cd_temporaryTreeID =
						SetTimer, cd_tim_ShowTree, 450
				}
			}
		}
	}
Return

; Fenster unter der Maus aktivieren
cd_tim_activateUnderMouse:
	SetTimer, cd_tim_activateTempDesk, off
	cd_TempDeskTimer =

	CoordMode,Mouse,Screen
	MouseGetPos,,,cd_MouseStartWinID
	MouseGetPos, cd_endMouseX , cd_endMouseY
	cd_diffX := cd_startMouseX - cd_endMouseX
	cd_diffY := cd_startMouseY - cd_endMouseY
	Transform, cd_diffX, abs, %cd_diffX%
	Transform, cd_diffY, abs, %cd_diffY%

	If ( (cd_diffY < 5 AND cd_diffX < 5) )
	{
		If cd_makeActiveWinID = %cd_MouseStartWinID%
		{
			IfInString, cd_MouseWinTitle, TMPDSKaid
			{
				if cd_LastWin <> TMPDSKaid
				{
;               Run, nomousy.exe -h
					Gosub, cd_sub_RestoreTempDeskWindows
;               Run, nomousy.exe
					WinHide, ahk_class Progman
					WinShow, ahk_class Progman
				}
			}
			Else
			{
				cd_onlyHiddenWin =
				WinActivate, ahk_id %cd_makeActiveWinID%
				cd_activatedWindowsList = %cd_activatedWindowsList%%cd_makeActiveWinID%|
				cd_activeWindowHasChanged = yes
				WinGetClass, cd_WinClass, ahk_id %cd_makeActiveWinID%

				If cd_WinClass in CabinetWClass,ExploreWClass
					SetTimer, cd_tim_ShowTree, 450
			}
		}
	}

	SetTimer, cd_tim_activateUnderMouse, Off
	cd_activateUnderMouseTimer = off
Return

cd_tim_activateTempDesk:
	SetTimer, cd_tim_activateUnderMouse, Off
	SetTimer, cd_tim_activateTempDesk, Off
	cd_activeWindowHasChanged = yes
	Gosub, cd_main_ComfortDrag_TempDesk
	cd_TempDeskTimer =
Return

cd_sub_actImmediately:
	MouseGetPos,,,cd_makeActiveWinID
	cd_onlyHiddenWin =
	WinActivate, ahk_id %cd_makeActiveWinID%
	cd_activatedWindowsList = %cd_activatedWindowsList%%cd_makeActiveWinID%|
	cd_activeWindowHasChanged = yes
	SetTimer, cd_tim_activateUnderMouse, Off
	cd_activateUnderMouseTimer = off
Return

; Ordnerleiste einblenden
cd_tim_ShowTree:
	CoordMode, Mouse, RELATIVE

	If cd_temporaryTreeID <>
	{
		MouseGetPos, cd_MouseX,,cd_STMouseWinID,cd_STMouseWinControl
		If ((cd_STMouseWinID <> cd_temporaryTreeID OR cd_STMouseWinControl <> "SysTreeView321") and (cd_MouseX > 10 or cd_MouseX < 0))
		{
			If cd_hideTreeTimer <> on
			{
				SetTimer, cd_tim_HideTree, 400
				cd_hideTreeTimer = on
			}
		}

		Return
	}
	MouseGetPos, cd_MouseX,, cd_STMouseWinID
	WinGet, cd_STactiveWinID, ID, A
	WinGetClass, cd_WinClass, ahk_id %cd_STactiveWinID%

	If cd_STactiveWinID = %cd_STMouseWinID%
	{
		If cd_WinClass in CabinetWClass,ExploreWClass
		{
			If cd_MouseX < 10
			{
				ControlGet, cd_TreeVis, Visible,, SysTreeView321, ahk_id %cd_STactiveWinID%

				If cd_TreeVis < 1
				{
					SendMessage, 0x111, 41525, 0, , ahk_id %cd_STactiveWinID%

					cd_temporaryTreeID = %cd_STactiveWinID%
				}
				Else If cd_temporaryTreeID <>
				{
					MouseGetPos, cd_MouseX,,cd_STMouseWinID,cd_STMouseWinControl

					If ((cd_STMouseWinID <> cd_temporaryTreeID OR cd_STMouseWinControl <> "SysTreeView321") and (cd_MouseX > 10 or cd_MouseX < 0))
						SetTimer, cd_tim_HideTree, 400
				}
			}
		}
	}
Return

; Ordnerleiste wieder verstecken
cd_tim_HideTree:
	CoordMode, Mouse, RELATIVE
	MouseGetPos, cd_MouseX,,cd_HTMouseWinID,cd_HTMouseWinControl

	If ((cd_HTMouseWinID <> cd_temporaryTreeID OR cd_HTMouseWinControl <> "SysTreeView321") and (cd_MouseX > 10 or cd_MouseX < 0))
	{
		SendMessage, 0x111, 41525, 0, , ahk_id %cd_temporaryTreeID%

		SetTimer, cd_tim_HideTree, Off
		cd_STMouseStartWinID =
		cd_hideTreeTimer =
		cd_temporaryTreeID =
	}
Return

; zusätzlich rechte Maustaste gedrückt
cd_main_ComfortDrag_RButton:
	If Enable_ComfortDrag = 1
		Gosub, cd_sub_HideWindow
Return

; mit rechts angeklicktes Fenster verstecken
cd_sub_HideWindow:
	If (cd_HideOnlyOnDragging = 1 AND cd_DraggingActive = "")
		Return

	SetTitlematchmode, 2

	MouseGetPos, , , cd_actID, cd_actClass

	If (cd_onGestures = 1 AND cd_DraggingActive = "")
	{
		If cd_actClass contains %Gesture_Exclusions%
		{
			If ( cd_actID = cd_MouseStartWinID AND HiddenWindows = "" AND cd_activeWindowHasChanged ="") ; AND StrokeIt <> 1)
			{
				Click down right
				KeyWait, RButton
				Click up right
				Return
			}
		}
	}
	Else If (cd_onGestures = 1)
	{
		If cd_actClass contains %Gesture_ExtendedExclusions%
		{
			If ( cd_actID = cd_MouseStartWinID AND HiddenWindows = "" AND cd_activeWindowHasChanged ="") ; AND StrokeIt <> 1)
			{
				Click down right
				KeyWait, RButton
				Click up right
				Return
			}
		}
	}

	If (HiddenWindows = "" AND cd_activeWindowHasChanged = "")
		cd_onlyHiddenWin = yes

	MouseGetPos,,,cd_HWMouseWinID
	WinGetClass,cd_actClass, ahk_id %cd_HWMouseWinID%

	If cd_actClass not in Progman,Shell_TrayWnd,WorkerW,BaseBar,SideBar_AppBarWindow,SideBar_HTMLHostWindow,SideBar_AppBarBullet,BasicWindow
	{
		StringReplace, HiddenWindows, HiddenWindows, %cd_actID%|,
		HiddenWindows = %cd_actID%|%HiddenWindows%

		IniWrite, %HiddenWindows%, %ConfigFile%, HiddenWindows, WindowList

		PostMessage,0x0112,0x0000f020,0x00f40390,,ahk_id %cd_actID%
		WinMinimize, ahk_id %cd_actID%

		If cd_DragStartWinID <>
		{
			WinHide, ahk_class Progman
			WinShow, ahk_class Progman
		}
	}
	cd_activeWindowHasChanged = yes
Return

; zuletzt verstecktes Fenster wiederholen oder zwischen zwei übereinander liegenden Fenstern wechseln
cd_sub_ShowWindow:
	MouseGetPos,,,cd_SWMouseWinID
	WinGet,cd_SWactiveWinID,ID,A

	If HiddenWindows <>
	{
		StringGetPos,cd_NextWinPos,HiddenWindows,|

		StringLeft, cd_Temp, HiddenWindows, %cd_NextWinPos%
		If cd_Temp =
			cd_Temp = %HiddenWindows%
		StringReplace, cd_Temp, cd_Temp, |,, a

		WinRestore, ahk_id %cd_Temp%

		If cd_Temp = cd_activeStartWinID
			WinActivate, ahk_id %cd_Temp%

		StringReplace, HiddenWindows, HiddenWindows, %cd_Temp%|,
		IniWrite, %HiddenWindows%, %ConfigFile%, HiddenWindows, WindowList

	}
	Else If A_Cursor <> IBeam
	{
		If ( cd_SWactiveWinID = cd_SWMouseWinID and cd_allWindowsRestored = "" )
		{
			Gosub, cd_sub_WindowBehind

			If cd_FoundID
			{
				WinActivate, ahk_id %cd_FoundID%
				cd_activeStartWinID = %cd_FoundID%
			}
		}
		Else
		{
			If cd_allWindowsRestored =
			{
				WinActivate, ahk_id %cd_SWMouseWinID%
			}
			Else
			{
				WinActivate, ahk_id %cd_activeStartWinID%
				cd_allWindowsRestored =
			}
		}
	}

	cd_activeWindowHasChanged = yes

	MButton_send = no
Return

; kurzfristiger Desktop
cd_main_ComfortDrag_TempDesk:
	DetectHiddenWindows, Off

;   If Debug = 1
;      tooltip, cd_main_ComfortDrag_TempDesk:`nzuletzt erkanntes Hotkey: %A_ThisHotkey%`n`nDieser Hinweis verschwindet`, wenn Debug in der ac'tivAid.ini auf 0 gesetzt wird.

	If cd_NoTempDesk = 1
		Return
	If Enable_ComfortDrag = 1
	If cd_onTempDesk = 1
	{
		If cd_DraggingActive = 1
		{
			WinSet, Redraw,, ahk_class Progman
		}
		StringReplace, cd_LastHotkey, A_ThisHotkey, $,

		If TempDeskWindows =
		{
			SetTimer, cd_tim_activateUnderMouse, Off
			cd_activateUnderMouseTimer = off

			CoordMode, Mouse, Screen
			MouseGetPos, cd_MouseX, cd_MouseY, testID

			DetectHiddenWindows, Off
			WinGet, cd_List, List,,, Program Manager ; Lister alle sichtbaren Fenster außer Desktop

			cd_FirstWindowFound := False

			;Gosub, sub_temporarySuspend

			TempDeskWindows =
			cd_FirstMax =
			WinGet, cd_WinBeforeTD, ID, A

			;FileDelete, ErrorLog.txt
			Loop, %cd_MoveStepsOut%
			{
				cd_MoveCount := A_Index

				Loop %cd_List%  ; Alle sichtbaren Fenster durchgehen
				{
					cd_Index := A_Index

					cd_ID := cd_List%cd_Index%
					WinGetClass, cd_class, ahk_id %cd_ID%

					If cd_class Not In Progman,Shell_TrayWnd,WorkerW,BaseBar,SideBar_AppBarWindow,SideBar_HTMLHostWindow,SideBar_AppBarBullet,BasicWindow
					{
						WinGetPos, cd_ListX, cd_ListY,cd_ListW,cd_ListH, ahk_id %cd_ID%
						WinGet, cd_ListMax, MinMax, ahk_id %cd_ID%

						If (cd_ListMax = 1 AND cd_FullScreenFix <> 0)
						{
							WinRestore, ahk_id %cd_ID%
							WinGetPos, cd_2ListX, cd_2ListY,cd_2ListW,cd_2ListH, ahk_id %cd_ID%

							StringReplace, TempDeskWindowsToMaximize, TempDeskWindowsToMaximize, %cd_ID%|,,
							TempDeskWindowsToMaximize = %TempDeskWindowsToMaximize%%cd_ID%|
							If cd_FirstMax =
								cd_FirstMax = %cd_Index%
						}
						If cd_MoveCount <> 1
						{
							cd_ListX := TempDeskWindowX[%cd_ID%]
							cd_ListY := TempDeskWindowY[%cd_ID%]
						}
						If (cd_MoveCount = 1 AND cd_Index <= cd_FirstMax)
							WinSet, Top,, ahk_id %cd_ID%

						If (cd_ListX = -32000 OR cd_ListY = -32000 OR cd_ListMax = -1)
							continue

						If (cd_ListX-WorkAreaLeft > WorkAreaRight-(cd_ListX+cd_ListW))
							WinMove, ahk_id %cd_ID%,,% cd_ListX+((WorkAreaRight-cd_ListX-20)/(cd_MoveStepsOut) * (cd_MoveCount)),%cd_ListY%,%cd_ListW%,%cd_ListH%
						Else
							WinMove, ahk_id %cd_ID%,,% cd_ListX+((WorkAreaLeft+20-cd_ListW-cd_ListX)/(cd_MoveStepsOut) * (cd_MoveCount)),%cd_ListY%,%cd_ListW%,%cd_ListH%

						If cd_MoveCount = 1
						{
							;FileAppend, %cd_class%`n, ErrorLog.txt

							TempDeskWindows := TempDeskWindows cd_ID "|"
							TempDeskWindowsRwd := cd_ID "|" TempDeskWindows
							TempDeskWindowX[%cd_ID%] := cd_ListX
							TempDeskWindowY[%cd_ID%] := cd_ListY
							TempDeskWindowMax[%cd_ID%] := cd_ListMax
							TempDeskWindowX2[%cd_ID%] := cd_2ListX
							TempDeskWindowY2[%cd_ID%] := cd_2ListY
							TempDeskWindowH2[%cd_ID%] := cd_2ListH
							TempDeskWindowW2[%cd_ID%] := cd_2ListW
						}
					}
				}
			}

			WorkAreaRight := WorkAreaRight-20
			SplashImage,6:,B X%WorkAreaLeft% Y%WorkAreaTop% W20 H%WorkAreaHeight% CW000000,,,TMPDSKaid1
;         WinMove, TMPDSKaid1,, %WorkAreaLeft%
			WinSet,Transparent,128,TMPDSKaid1
			SplashImage,7:,B X%WorkAreaRight% Y%WorkAreaTop% W20 H%WorkAreaHeight% CW000000,,,TMPDSKaid2
;         WinMove, TMPDSKaid2,, %WorkAreaRight%
			WinSet,Transparent,128,TMPDSKaid2

			WorkAreaRight := WorkAreaRight+20
			IniWrite, %TempDeskWindows%, %ConfigFile%, TemporaryDesktop, Windows
			IniWrite, %TempDeskWindowsToMaximize%, %ConfigFile%, TemporaryDesktop, WindowsToMaximize
			Loop, Parse , TempDeskWindows, |
			{
				IniWrite, % TempDeskWindowX[%A_LoopField%], %ConfigFile%, TemporaryDesktop, WindowPosX%A_LoopField%
				IniWrite, % TempDeskWindowY[%A_LoopField%], %ConfigFile%, TemporaryDesktop, WindowPosY%A_LoopField%
				IniWrite, % TempDeskWindowMax[%A_LoopField%], %ConfigFile%, TemporaryDesktop, WindowMax%A_LoopField%
			}
			WinActivate, ahk_class Progman
;         WinSet, Redraw,, ahk_class Progman
			WinGet, cd_lastTDwinID, ID, A
			;Gosub, sub_temporarySuspend
			SetTimer, cd_tim_TempDeskWatcher, 100
		}
		Else
		{
			Gosub, cd_sub_RestoreTempDeskWindows
;         WinSet, Redraw,, ahk_class Progman
		}
		If cd_DraggingActive = 1
		{
			WinSet, Redraw,, ahk_class Progman
			WinActivate, ahk_class Progman
			Send, {F5}
		}
	}
Return

; Fenster für kurzfristigen Desktop wiederherstellen
cd_sub_RestoreTempDeskWindows:
	SetTimer, cd_tim_TempDeskWatcher, Off
	DetectHiddenWindows, On
	SplashImage,6:Off
	SplashImage,7:Off
	Sleep,10

	;Gosub, sub_temporarySuspend

	If TempDeskWindows <>
	{
		TempDeskWindowsNew = %TempDeskWindows%
		Loop, % cd_MoveStepsIn
		{
			cd_MoveCount := cd_MoveStepsIn-A_Index
			Loop, Parse, TempDeskWindows, |
			{
				If (cd_MoveCount = cd_MoveStepsIn-1 AND cd_FullScreenFix = 1)
					WinRestore, ahk_id %A_LoopField%

				cd_ListX := TempDeskWindowX[%A_LoopField%]
				cd_ListY := TempDeskWindowY[%A_LoopField%]
				cd_ListMax := TempDeskWindowMax[%A_LoopField%]
				If (A_LoopField = "" OR cd_ListMax = -1 OR cd_ListX = -32000 OR cd_ListY = -32000)
					continue
				WinGetPos,,,cd_ListW,, ahk_id %A_LoopField%


				;If (cd_ListX + cd_XAdd  > WorkAreaRight-cd_ListX-cd_ListW)
				If cd_ListX-WorkAreaLeft > WorkAreaRight-(cd_ListX+cd_ListW)
					WinMove, ahk_id %A_LoopField%,,% cd_ListX+((WorkAreaRight-cd_ListX-20)/(cd_MoveStepsIn) * (cd_MoveCount))
				Else
					WinMove, ahk_id %A_LoopField%,,% cd_ListX+((WorkAreaLeft+20-cd_ListW-cd_ListX)/(cd_MoveStepsIn) * (cd_MoveCount))

				If cd_MoveCount = 0
				{
					StringReplace,TempDeskWindowsNew,TempDeskWindowsNew,%A_LoopField%|,
					TempDeskWindowX[%A_LoopField%] =
					TempDeskWindowY[%A_LoopField%] =
					TempDeskWindowMax[%A_LoopField%] =
					IniDelete, %ConfigFile%, TemporaryDesktop, WindowPosX%A_LoopField%
					IniDelete, %ConfigFile%, TemporaryDesktop, WindowPosY%A_LoopField%
					IniDelete, %ConfigFile%, TemporaryDesktop, WindowMax%A_LoopField%
				}


				If (cd_ListMax = 1 AND cd_MoveCount = 0 )
				{
					StringReplace, TempDeskWindowsToMaximize, TempDeskWindowsToMaximize, %A_LoopField%|,,
					TempDeskWindowsToMaximize = %TempDeskWindowsToMaximize%%A_LoopField%|
				}

			}
		}

		TempDeskWindows = %TempDeskWindowsNew%
		IniWrite, %TempDeskWindows%, %ConfigFile%, TemporaryDesktop, Windows
	}

	If (cd_WinBeforeTD <> "" AND cd_activeWindowHasChanged = "")
	{
		WinGetClass, cd_WinActive, A
		If cd_WinActive = Progman
			WinActivate, ahk_id %cd_WinBeforeTD%
		IfInString, TempDeskWindowsToMaximize, %cd_WinBeforeTD%|
		{
			StringReplace, TempDeskWindowsToMaximize, TempDeskWindowsToMaximize, %cd_WinBeforeTD%|,,
			If cd_FullScreenFix = 1
				WinMove, ahk_id %cd_WinBeforeTD%,, % TempDeskWindowX2[%cd_WinBeforeTD%], % TempDeskWindowY2[%cd_WinBeforeTD%], % TempDeskWindowW2[%cd_WinBeforeTD%], % TempDeskWindowH2[%cd_WinBeforeTD%]
			If cd_DontMaximize = 0
				WinMaximize, ahk_id %cd_WinBeforeTD%
		}
	}
	IniWrite, %TempDeskWindowsToMaximize%, %ConfigFile%, TemporaryDesktop, WindowsToMaximize

	cd_WinBeforeTD =

	;Gosub, sub_temporarySuspend
Return

cd_tim_TempDeskWatcher:
	WinGet, cd_TDwinID, ID, A
	if cd_TDwinID = %cd_lastTDwinID%
		return

	cd_lastTDwinID = %cd_TDwinID%

	IfInString, TempDeskWindows, %cd_TDwinID%|
		cd_Temp = %cd_TDwinID%
	Else
		cd_Temp =

	cd_ListX := TempDeskWindowX[%cd_Temp%]
	cd_ListY := TempDeskWindowY[%cd_Temp%]
	cd_ListMax := TempDeskWindowMax[%cd_Temp%]
	WinGetPos,,,cd_ListW,, ahk_id %cd_Temp%

	MouseGetPos,,,cd_tmpWinID
	WinGetTitle, cd_tmpTitle, ahk_id %cd_tmpWinID%

	If (cd_Temp = "" OR cd_ListX = "" OR cd_ListMax = -1 OR cd_ListX = -32000 OR cd_ListY = -32000 OR InStr(cd_tmpTitle,"TMPDSKaid"))
		return

	Gosub, sub_temporarySuspend

	Loop, % cd_MoveStepsIn
	{
		cd_MoveCount := cd_MoveStepsIn-A_Index

		If (cd_ListX > WorkAreaRight-cd_ListX-cd_ListW)
			WinMove, ahk_id %cd_temp%,,% cd_ListX+((WorkAreaRight-cd_ListX-20)/(cd_MoveStepsIn) * (cd_MoveCount))
		Else
			WinMove, ahk_id %cd_temp%,,% cd_ListX+((WorkAreaLeft+20-cd_ListW-cd_ListX)/(cd_MoveStepsIn) * (cd_MoveCount))

		If (cd_ListMax = 1 AND cd_MoveCount = 0)
		{
			If cd_FullScreenFix = 1
				WinMove, ahk_id %cd_temp%,, % TempDeskWindowX2[%cd_temp%], % TempDeskWindowY2[%cd_temp%], % TempDeskWindowW2[%cd_temp%], % TempDeskWindowH2[%cd_temp%]
			If cd_DontMaximize = 0
				WinMaximize, ahk_id %cd_temp%
		}

	}
	StringReplace,TempDeskWindows,TempDeskWindows,%cd_temp%|,
	TempDeskWindowX[%cd_temp%] =
	TempDeskWindowY[%cd_temp%] =
	TempDeskWindowMax[%cd_temp%] =
	IniDelete, %ConfigFile%, TemporaryDesktop, WindowPosX%cd_temp%
	IniDelete, %ConfigFile%, TemporaryDesktop, WindowPosY%cd_temp%
	IniDelete, %ConfigFile%, TemporaryDesktop, WindowMax%cd_temp%
	IniWrite, %TempDeskWindows%, %ConfigFile%, TemporaryDesktop, Windows

	cd_WinBeforeTD = %cd_Temp%
	cd_List%cd_TempIndex% =

	If TempDeskWindows =
		Gosub, cd_sub_RestoreTempDeskWindows

	Gosub, sub_temporarySuspend
Return

; Einzeln versteckte Fenster wiederherstellen
cd_sub_RestoreHiddenWindows:
	If HiddenWindows <>
	{
		Loop, Parse, HiddenWindows, |
		{
			If A_LoopField =
				continue

			WinRestore, ahk_id %A_LoopField%
			StringReplace, HiddenWindows, HiddenWindows, %A_LoopField%|
		}

		IniWrite, %HiddenWindows%, %ConfigFile%, HiddenWindows, WindowList
		IfWinNotActive, ahk_id %cd_activeStartWinID%
			WinActivate, ahk_id %cd_activeStartWinID%
	}
Return

; Unterroutine, um zwischen zwei verdeckten Fenstern zu wechseln.
cd_sub_WindowBehind:
	CoordMode, Mouse
	MouseGetPos, cd_MouseX, cd_MouseY
	WinGet, cd_List, List,,, Program Manager

	cd_FirstWindowFound := False
	cd_FoundID =

	Loop %cd_List%
	{
		cd_ID := cd_List%A_Index%
		WinGetPos, cd_WinX, cd_WinY, cd_WinW, cd_WinH, ahk_id %cd_ID%

		If (cd_MouseX > cd_WinX and cd_MouseY > cd_WinY and cd_MouseX < cd_WinX+cd_WinW and cd_MouseY < cd_WinY+cd_WinH)
		{
			If cd_FirstWindowFound
			{
				cd_FoundID := cd_ID
				Break
			}
			Else
				cd_FirstWindowFound := True
		}
	}
Return

cd_sub_WhileDraggingWindowOn:
	DetectHiddenWindows, On
	IfWinExist, ComfortDragWhileDragging
		Return
	Gui, %GuiID_ComfortDragWhileDragging%:+Owner +ToolWindow
	Gui, %GuiID_ComfortDragWhileDragging%:Show, x-2000 NA NoActivate, ComfortDragWhileDragging
Return

cd_sub_WhileDraggingWindowOff:
	Gui, %GuiID_ComfortDragWhileDragging%:Destroy
	If cd_StrokeItDisable = 1
	{
		cd_StrokeItDisable =
		DetectHiddenWindows, On
		SendMessage, 0x9c44, 0x010064, 0, , ahk_class StrokeIt
		SendMessage, 0x405, 1, 0x204, , ahk_class StrokeIt
		SendMessage, 0x405, 1, 0x205, , ahk_class StrokeIt
	}
Return
