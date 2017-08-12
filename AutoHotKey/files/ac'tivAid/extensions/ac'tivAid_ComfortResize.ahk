; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:							 ComfortResize
; -----------------------------------------------------------------------------
; Prefix:						 cr_
; Version:						1.0.1
; Date:							 2007-11-28
; Author:						 Bernd Schandl, Wolfgang Reszel
; Copyright:					2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_ComfortResize:
	Prefix = cr
	%Prefix%_ScriptName		= ComfortResize
	%Prefix%_ScriptVersion = 1.0.1
	%Prefix%_Author				= Bernd Schandl, Wolfgang Reszel, Michael Telgkamp

	RequireExtensions					=
	AddSettings_ComfortResize	=
	ConfigFile_ComfortResize	 =

	CustomHotkey_ComfortResize =						; Benutzerdefiniertes Hotkey
	Hotkey_ComfortResize			 =						; Standard-Hotkey
	HotkeyPrefix_ComfortResize =						; Präfix

	HideSettings										= 0
	EnableTray_ComfortResize				= 1
	DisableIfCompiled_ComfortResize = 0

	CreateGuiID("ComfortResize")

	IconFile_On_ComfortResize = %A_WinDir%\system32\shell32.dll
	IconPos_On_ComfortResize	= 99

	If Lng = 07	; = Deutsch
	{
		MenuName						= %cr_ScriptName% - Komfortables Ändern der Fenstergröße
		Description				 = Die Größe eines Fensters kann mit Win und der rechten Maustaste komfortabel verändert werden. Vier Standardgrößen (640x480, 800x600 ...) sind direkt über Tastaturkürzel erreichbar.
		lng_cr_custom			 = Fenstergröße
		lng_cr_Raster			 = Raster für Verschieben/Skalieren mit zusätzlicher Umschalt-Taste
		lng_cr_AlwaysUseRaster = Raster immer verwenden
		lng_cr_SubTaskbar	 = – Taskleiste
		lng_cr_Position		 = Position
		lng_cr_Size				 = Größe
		lng_cr_AlwaysMove	 = Größenänderung nur bei aktiven Fenstern zulassen, nicht aktive Fenster immer verschieben
		lng_cr_ShowPosition = Fenstergröße und -position anzeigen
		lng_cr_SlowMovement = Langsamere Reaktionszeit (verhindert 'Schlieren' beim Verschieben oder Skalieren)
		lng_cr_Magnetic		 = Am Bildschirmrand einrasten (Verschieben/Skalieren außerhalb des Desktops nicht möglich)
		lng_cr_ResizeFixed	= Auch Fenster mit fester Größe skalieren
		lng_cr_ToolTip			= Ganze Zahlen oder Brüche möglich`n(z.B. 1/2 = Hälfte des Bildschirms bzw. Arbeitsbereichs)
		lng_cr_TbToolTip		= Diese Option berücksichtigt die`nTaskleiste beim Ändern der Größe.
		lng_cr_MouseKey		 = ComfortResize über folgendes Kürzel aufrufen:
		lng_cr_MouseKeys		= Win + Linke Maustaste|Win + Mittlere Maustaste|Win + Rechte Maustaste|Alt + Linke Maustaste|Alt + Mittlere Maustaste|Alt + Rechte Maustaste|Mittlere Maustaste|Rechte Maustaste|Rechte und Linke Maustaste
		lng_cr_ExcludeWindows = Programme ausschließen
		lng_cr_DisableClasses = ComfortResize in folgenden Fenster-/Element- klassen ignorieren (* = Platzhalter; Programme verhalten sich wie bei deaktiviertem ComfortResize)
		lng_cr_AlternativeRButtonLButton = Alternatives Verhalten für 'Rechte und Linke Maustaste'

	}
	else				; = Alternativ-Sprache
	{
		MenuName						= %cr_ScriptName% - Resizing windows comfortably
		Description				 = Change the size of a window using Win and right mouse button. Four standard sizes (640x480, 800x600 ...) are directly accessible via hotkeys.
		lng_cr_custom			 = Window size
		lng_cr_Raster			 = Grid for moving/scaling with additional shift-key
		lng_cr_AlwaysUseRaster = always use grid
		lng_cr_SubTaskbar	 = – taskbar
		lng_cr_Position		 = Position
		lng_cr_Size				 = Size
		lng_cr_AlwaysMove	 = Resize only active windows, inactive windows will always be moved
		lng_cr_ShowPosition = Show window size and position
		lng_cr_SlowMovement = Slow window-movement to avoid 'ghost-windows'
		lng_cr_Magnetic		 = Limit on screen-borders (moving/scaling outside the desktop not possible)
		lng_cr_ResizeFixed	= Also scale windows with fixed size
		lng_cr_ToolTip			= Integer or fractions`n(e.g. 1/2 = the half of the screen)
		lng_cr_TbToolTip		= This option resizes in respect of the taskbar.
		lng_cr_MouseKey		 = Combination to call ComfortResize:
		lng_cr_MouseKeys		= Win + Left Mouse button|Win + Middle Mouse button|Win + Right Mouse button|Alt + Left Mouse button|Alt + Middle Mouse button|Alt + Right Mouse button|Middle Mouse button|Right Mouse button|Right and Left Mouse button
		lng_cr_ExcludeWindows = Exclude programs
		lng_cr_DisableClasses = Disable ComfortResize in the following controls or window classes (* = wild-card)
		lng_cr_AlternativeRButtonLButton = Alternative behaviour for 'Right and Left Mouse button'
	}
	tooltip_cr_rasterX	= %lng_cr_ToolTip%
	tooltip_cr_rasterY	= %lng_cr_ToolTip%
	loop, 6 {
		tooltip_cr_custom%A_Index%h = %lng_cr_ToolTip%
		tooltip_cr_custom%A_Index%w = %lng_cr_ToolTip%
		tooltip_cr_minusTaskbar%A_Index% = %lng_cr_TbToolTip%
	}

	RegisterAdditionalSetting("cr","AlternativeRButtonLButton",0)

	cr_MouseKey1 = #*LButton
	cr_MouseKey2 = #*MButton
	cr_MouseKey3 = #*RButton
	cr_MouseKey4 = !*LButton
	cr_MouseKey5 = !*MButton
	cr_MouseKey6 = !*RButton
	cr_MouseKey7 = Hook_MButton
	cr_MouseKey8 = Hook_RButton
	If cr_AlternativeRButtonLButton = 1
		cr_MouseKey9 = Hook_RButton
	Else
		cr_MouseKey9 = RButton & LButton

	cr_CurDownCenter = %IDC_SIZENS%
	cr_CurUpCenter = %IDC_SIZENS%
	cr_CurCenterLeft = %IDC_SIZEWE%
	cr_CurCenterRight = %IDC_SIZEWE%
	cr_CurUpRight = %IDC_SIZENESW%
	cr_CurDownLeft = %IDC_SIZENESW%
	cr_CurDownRight = %IDC_SIZENWSE%
	cr_CurUpLeft = %IDC_SIZENWSE%
	cr_CurCenterCenter = %IDC_SIZEALL%

	WM_ENTERSIZEMOVE = 0x231
	WM_EXITSIZEMOVE = 0x232

	; Hotkeys fuer horizonatales und vertikales Maximieren
	func_HotkeyRead( "cr_custom1", ConfigFile , cr_ScriptName, "Custom1Hotkey", "cr_sub_Custom1", "#!Numpad4", "$" )
	func_HotkeyRead( "cr_custom2", ConfigFile , cr_ScriptName, "Custom2Hotkey", "cr_sub_Custom2", "#!Numpad5", "$" )
	func_HotkeyRead( "cr_640x480", ConfigFile , cr_ScriptName, "Hotkey640x480", "cr_sub_640x480", "#!Numpad6", "$" )
	func_HotkeyRead( "cr_800x600", ConfigFile , cr_ScriptName, "Hotkey800x600", "cr_sub_800x600", "#!Numpad8", "$" )
	func_HotkeyRead( "cr_1024x768", ConfigFile , cr_ScriptName, "Hotkey1024x768", "cr_sub_1024x768", "#!Numpad1", "$" )
	func_HotkeyRead( "cr_1280x1024", ConfigFile , cr_ScriptName, "Hotkey1280x1024", "cr_sub_1280x1024", "#!Numpad2", "$" )
	IniRead, cr_AlwaysMoveNonActive, %ConfigFile%, %cr_ScriptName%, AlwaysMoveNonActive, 1
	IniRead, cr_ShowPosition, %ConfigFile%, %cr_ScriptName%, ShowPosition, 1
	IniRead, cr_SlowMovement, %ConfigFile%, %cr_ScriptName%, SlowMovement, 0
	IniRead, cr_MagneticBorders, %ConfigFile%, %cr_ScriptName%, MagneticBorders, 1
	IniRead, cr_ResizeFixedWindows, %ConfigFile%, %cr_ScriptName%, ResizeFixedWindows, 0
	IniRead, cr_MouseKey, %ConfigFile%, %cr_ScriptName%, MouseKey, 3
	IniRead, cr_Custom1w, %ConfigFile%, %cr_ScriptName%, Custom1w, 1/4
	IniRead, cr_Custom1h, %ConfigFile%, %cr_ScriptName%, Custom1h, 1/1
	IniRead, cr_minusTaskbar1, %ConfigFile%, %cr_ScriptName%, CustomMinusTaskbar1, 0
	IniRead, cr_Custom2w, %ConfigFile%, %cr_ScriptName%, Custom2w, 1/1
	IniRead, cr_Custom2h, %ConfigFile%, %cr_ScriptName%, Custom2h, 1/3
	IniRead, cr_minusTaskbar2, %ConfigFile%, %cr_ScriptName%, CustomMinusTaskbar2, 0
	IniRead, cr_Custom3w, %ConfigFile%, %cr_ScriptName%, Custom3w, 640
	IniRead, cr_Custom3h, %ConfigFile%, %cr_ScriptName%, Custom3h, 480
	IniRead, cr_minusTaskbar3, %ConfigFile%, %cr_ScriptName%, CustomMinusTaskbar3, 1
	IniRead, cr_Custom4w, %ConfigFile%, %cr_ScriptName%, Custom4w, 800
	IniRead, cr_Custom4h, %ConfigFile%, %cr_ScriptName%, Custom4h, 600
	IniRead, cr_minusTaskbar4, %ConfigFile%, %cr_ScriptName%, CustomMinusTaskbar4, 1
	IniRead, cr_Custom5w, %ConfigFile%, %cr_ScriptName%, Custom5w, 1024
	IniRead, cr_Custom5h, %ConfigFile%, %cr_ScriptName%, Custom5h, 768
	IniRead, cr_minusTaskbar5, %ConfigFile%, %cr_ScriptName%, CustomMinusTaskbar5, 1
	IniRead, cr_Custom6w, %ConfigFile%, %cr_ScriptName%, Custom6w, 1280
	IniRead, cr_Custom6h, %ConfigFile%, %cr_ScriptName%, Custom6h, 1024
	IniRead, cr_minusTaskbar6, %ConfigFile%, %cr_ScriptName%, CustomMinusTaskbar6, 1

	IniRead, cr_RasterX, %ConfigFile%, %cr_ScriptName%, RasterX, 1/4
	IniRead, cr_RasterY, %ConfigFile%, %cr_ScriptName%, RasterY, 1/9
	IniRead, cr_RasterAlways, %ConfigFile%, %cr_ScriptName%, AlwaysUseRaster, 0

	IniRead, cr_DisableClasses, %ConfigFile%, %cr_ScriptName%, DisableClasses, %A_Space%

	If ( InStr(cr_MouseKey%cr_MouseKey%, "Hook_") )
	{
		StringReplace, cr_Extend, cr_MouseKey%cr_MouseKey%, Hook_
		If Enable_ComfortResize =
			RegisterHook( cr_Extend, "ComfortResize" )
	}
	Else
	{
		Hotkey_Extensions_tmp := Hotkey_Extensions "ComfortResize$|"
		Hotkey_Extension_tmp[ComfortResize$] := cr_MouseKey%cr_MouseKey%
		Hotkey_AllHotkeys := Hotkey_AllHotkeys "«<" cr_MouseKey%cr_MouseKey% " >»"
	}
Return

SettingsGui_ComfortResize:
	func_CreateListOfHotkeys( cr_MouseKey%cr_MouseKey%, ExtensionMenuName[ComfortResize] , cr_ScriptName )

	StringReplace, cr_DisableClasses_tmp, cr_DisableClasses, `,,`n,A

	Gui, Add, Text, xs+10 y+5, %lng_cr_MouseKey%:
	Gui, Add, DropDownList, -Wrap gsub_CheckIfSettingsChanged x+5 yp-4 w200 AltSubmit vcr_MouseKey_tmp, %lng_cr_MouseKeys%
	GuiControl,Choose, cr_MouseKey_tmp, %cr_MouseKey%

	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+10 y+3 vcr_AlwaysMoveNonActive Checked%cr_AlwaysMoveNonActive%, %lng_cr_AlwaysMove%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+10 y+5 vcr_SlowMovement Checked%cr_SlowMovement%, %lng_cr_SlowMovement%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+10 y+5 vcr_MagneticBorders Checked%cr_MagneticBorders%, %lng_cr_Magnetic%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+10 y+5 vcr_ShowPosition Checked%cr_ShowPosition%, %lng_cr_ShowPosition%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged x+10 vcr_ResizeFixedWindows Checked%cr_ResizeFixedWindows%, %lng_cr_ResizeFixed%
	Gui, Add, Text, xs+10 y+7, %lng_cr_Raster%:
	Gui, Add, Edit, x+5 yp-2 w40 h18 gsub_CheckIfSettingsChanged vcr_RasterX, %cr_RasterX%
	Gui, Add, Text, x+5, x
	Gui, Add, Edit, x+5 w40 h18 gsub_CheckIfSettingsChanged vcr_RasterY, %cr_RasterY%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged x+5 yp+2 vcr_RasterAlways Checked%cr_RasterAlways%, %lng_cr_AlwaysUseRaster%

	func_HotkeyAddGuiControl( lng_cr_Custom " 1", "cr_custom1", "xs+10 y+20 w80", "", "x+5 yp-4 w270" )
	Gui, Add, Edit, x+5 w50 h20 gsub_CheckIfSettingsChanged vcr_Custom1w, %cr_Custom1w%
	Gui, Add, Text, x+5, x
	Gui, Add, Edit, x+5 w50 h20 gsub_CheckIfSettingsChanged vcr_Custom1h, %cr_Custom1h%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged x+5 yp+4 vcr_minusTaskbar1 Checked%cr_minusTaskbar1%, %lng_cr_SubTaskbar%

	func_HotkeyAddGuiControl( lng_cr_Custom " 2", "cr_custom2", "xs+10 y+10 w80", "", "x+5 yp-4 w270" )
	Gui, Add, Edit, x+5 w50 h20 gsub_CheckIfSettingsChanged vcr_Custom2w, %cr_Custom2w%
	Gui, Add, Text, x+5, x
	Gui, Add, Edit, x+5 w50 h20 gsub_CheckIfSettingsChanged vcr_Custom2h, %cr_Custom2h%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged x+5 yp+4 vcr_minusTaskbar2 Checked%cr_minusTaskbar2%, %lng_cr_SubTaskbar%

	func_HotkeyAddGuiControl( lng_cr_Custom " 3", "cr_640x480", "xs+10 y+10 w80", "", "x+5 yp-4 w270" )
	Gui, Add, Edit, x+5 w50 h20 gsub_CheckIfSettingsChanged vcr_Custom3w, %cr_Custom3w%
	Gui, Add, Text, x+5, x
	Gui, Add, Edit, x+5 w50 h20 gsub_CheckIfSettingsChanged vcr_Custom3h, %cr_Custom3h%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged x+5 yp+4 vcr_minusTaskbar3 Checked%cr_minusTaskbar3%, %lng_cr_SubTaskbar%

	func_HotkeyAddGuiControl( lng_cr_Custom " 4", "cr_800x600", "xs+10 y+10 w80", "", "x+5 yp-4 w270" )
	Gui, Add, Edit, x+5 w50 h20 gsub_CheckIfSettingsChanged vcr_Custom4w, %cr_Custom4w%
	Gui, Add, Text, x+5, x
	Gui, Add, Edit, x+5 w50 h20 gsub_CheckIfSettingsChanged vcr_Custom4h, %cr_Custom4h%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged x+5 yp+4 vcr_minusTaskbar4 Checked%cr_minusTaskbar4%, %lng_cr_SubTaskbar%

	func_HotkeyAddGuiControl( lng_cr_Custom " 5", "cr_1024x768", "xs+10 y+10 w80", "", "x+5 yp-4 w270" )
	Gui, Add, Edit, x+5 w50 h20 gsub_CheckIfSettingsChanged vcr_Custom5w, %cr_Custom5w%
	Gui, Add, Text, x+5, x
	Gui, Add, Edit, x+5 w50 h20 gsub_CheckIfSettingsChanged vcr_Custom5h, %cr_Custom5h%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged x+5 yp+4 vcr_minusTaskbar5 Checked%cr_minusTaskbar5%, %lng_cr_SubTaskbar%

	func_HotkeyAddGuiControl( lng_cr_Custom " 6", "cr_1280x1024", "xs+10 y+10 w80", "", "x+5 yp-4 w270" )
	Gui, Add, Edit, x+5 w50 h20 gsub_CheckIfSettingsChanged vcr_Custom6w, %cr_Custom6w%
	Gui, Add, Text, x+5, x
	Gui, Add, Edit, x+5 w50 h20 gsub_CheckIfSettingsChanged vcr_Custom6h, %cr_Custom6h%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged x+5 yp+4 vcr_minusTaskbar6 Checked%cr_minusTaskbar6%, %lng_cr_SubTaskbar%

	Gui, Add, Button, xs+260 w170 ys+290 h16 gcr_sub_ExcludeWindows, %lng_cr_ExcludeWindows% ...
Return

cr_sub_ExcludeWindows:
	Gui, %GuiID_activAid%:+Disabled
	GuiDefault("ComfortResize", "+Owner" GuiID_activAid)
	Gosub, GuiDefaultFont

	Gui, Add, Text, w230, %lng_cr_DisableClasses%:
	Gui, Add, Edit, y+5 W200 R10 vcr_DisableClasses_tmp, %cr_DisableClasses_tmp%
	Gui, Add, Button, x+10 yp+0 W21 gcr_sub_GetDisableClass, +

	Gui, Add, Button, -Wrap y+130 x45 W80 Default gcr_sub_ExcludeWindowsOK, %lng_OK%
	Gui, Add, Button, -Wrap X+5 W80 gComfortResizeGuiClose, %lng_cancel%

	Gui, Show, , %lng_cr_ExcludeWindows%

	Send,^{End}{Space}{BS}
Return

ComfortResizeGuiClose:
ComfortResizeGuiEscape:
	Gui, %GuiID_activAid%:-Disabled
	Gui, Destroy
Return

cr_sub_ExcludeWindowsOK:
	Gui, Submit, Nohide
	Gosub, ComfortResizeGuiClose
	func_SettingsChanged( cr_ScriptName )
Return

SaveSettings_ComfortResize:
	func_HotkeyWrite( "cr_640x480", ConfigFile , cr_ScriptName, "Hotkey640x480" )
	func_HotkeyWrite( "cr_800x600", ConfigFile , cr_ScriptName, "Hotkey800x600" )
	func_HotkeyWrite( "cr_1024x768", ConfigFile , cr_ScriptName, "Hotkey1024x768" )
	func_HotkeyWrite( "cr_1280x1024", ConfigFile , cr_ScriptName, "Hotkey1280x1024" )
	func_HotkeyWrite( "cr_custom1", ConfigFile , cr_ScriptName, "Custom1Hotkey" )
	func_HotkeyWrite( "cr_custom2", ConfigFile , cr_ScriptName, "Custom2Hotkey" )
	IniWrite, %cr_AlwaysMoveNonActive%, %ConfigFile%, %cr_ScriptName%, AlwaysMoveNonActive
	IniWrite, %cr_ShowPosition%, %ConfigFile%, %cr_ScriptName%, ShowPosition
	IniWrite, %cr_SlowMovement%, %ConfigFile%, %cr_ScriptName%, SlowMovement
	IniWrite, %cr_MagneticBorders%, %ConfigFile%, %cr_ScriptName%, MagneticBorders
	IniWrite, %cr_ResizeFixedWindows%, %ConfigFile%, %cr_ScriptName%, ResizeFixedWindows
	IniWrite, %cr_MouseKey_tmp%, %ConfigFile%, %cr_ScriptName%, MouseKey
	IniWrite, %cr_Custom1w%, %ConfigFile%, %cr_ScriptName%, Custom1w
	IniWrite, %cr_Custom1h%, %ConfigFile%, %cr_ScriptName%, Custom1h
	IniWrite, %cr_minusTaskbar1%, %ConfigFile%, %cr_ScriptName%, CustomMinusTaskbar1
	IniWrite, %cr_Custom2w%, %ConfigFile%, %cr_ScriptName%, Custom2w
	IniWrite, %cr_Custom2h%, %ConfigFile%, %cr_ScriptName%, Custom2h
	IniWrite, %cr_minusTaskbar2%, %ConfigFile%, %cr_ScriptName%, CustomMinusTaskbar2
	IniWrite, %cr_Custom3w%, %ConfigFile%, %cr_ScriptName%, Custom3w
	IniWrite, %cr_Custom3h%, %ConfigFile%, %cr_ScriptName%, Custom3h
	IniWrite, %cr_minusTaskbar3%, %ConfigFile%, %cr_ScriptName%, CustomMinusTaskbar3
	IniWrite, %cr_Custom4w%, %ConfigFile%, %cr_ScriptName%, Custom4w
	IniWrite, %cr_Custom4h%, %ConfigFile%, %cr_ScriptName%, Custom4h
	IniWrite, %cr_minusTaskbar4%, %ConfigFile%, %cr_ScriptName%, CustomMinusTaskbar4
	IniWrite, %cr_Custom5w%, %ConfigFile%, %cr_ScriptName%, Custom5w
	IniWrite, %cr_Custom5h%, %ConfigFile%, %cr_ScriptName%, Custom5h
	IniWrite, %cr_minusTaskbar5%, %ConfigFile%, %cr_ScriptName%, CustomMinusTaskbar5
	IniWrite, %cr_Custom6w%, %ConfigFile%, %cr_ScriptName%, Custom6w
	IniWrite, %cr_Custom6h%, %ConfigFile%, %cr_ScriptName%, Custom6h
	IniWrite, %cr_minusTaskbar6%, %ConfigFile%, %cr_ScriptName%, CustomMinusTaskbar6
	IniWrite, %cr_RasterX%, %ConfigFile%, %cr_ScriptName%, RasterX
	IniWrite, %cr_RasterY%, %ConfigFile%, %cr_ScriptName%, RasterY
	IniWrite, %cr_RasterAlways%, %ConfigFile%, %cr_ScriptName%, AlwaysUseRaster

	StringReplace, cr_DisableClasses, cr_DisableClasses_tmp, `n,`,,A
	IniWrite, %cr_DisableClasses%, %ConfigFile%, %cr_ScriptName%, DisableClasses

	StringReplace, Hotkey_AllHotkeys, Hotkey_AllHotkeys, % "«<" cr_MouseKey%cr_MouseKey% " >»"
	If ( !InStr(cr_MouseKey%cr_MouseKey%, "Hook_") )
		Hotkey, % "$" cr_MouseKey%cr_MouseKey%, Off

	cr_MouseKey = %cr_MouseKey_tmp%

	StringReplace, Hotkey_Extensions_tmp, Hotkey_Extensions_tmp, ComfortResize$|
	StringReplace, Hotkey_Extensions, Hotkey_Extensions, ComfortResize$|
	UnRegisterHook( "MButton", "ComfortResize" )
	UnRegisterHook( "RButton", "ComfortResize" )

	If ( InStr(cr_MouseKey%cr_MouseKey%, "Hook_") )
	{
		StringReplace, cr_Extend, cr_MouseKey%cr_MouseKey%, Hook_
		RegisterHook( cr_Extend, "ComfortResize" )
	}
	Else
	{
		Hotkey_Extensions_tmp := Hotkey_Extensions "ComfortResize$|"
		Hotkey_Extension_tmp[ComfortResize$] := cr_MouseKey%cr_MouseKey%
		Hotkey_AllHotkeys := Hotkey_AllHotkeys "«<" cr_MouseKey%cr_MouseKey% " >»"
	}
Return

AddSettings_ComfortResize:
Return

CancelSettings_ComfortResize:
Return

DoEnable_ComfortResize:
	func_HotkeyEnable("cr_640x480")
	func_HotkeyEnable("cr_800x600")
	func_HotkeyEnable("cr_1024x768")
	func_HotkeyEnable("cr_1280x1024")
	func_HotkeyEnable("cr_custom1")
	func_HotkeyEnable("cr_custom2")
	If ( InStr(cr_MouseKey%cr_MouseKey%, "Hook_") )
	{
		UnRegisterHook( "MButton", "ComfortResize" )
		UnRegisterHook( "RButton", "ComfortResize" )
		StringReplace, cr_Extend, cr_MouseKey%cr_MouseKey%, Hook_
		RegisterHook( cr_Extend, "ComfortResize" )
	}
	Else If ( InStr(cr_MouseKey%cr_MouseKey%, " & ") )
		Hotkey, % cr_MouseKey%cr_MouseKey%, RButton_ComfortResize, On
	Else
		Hotkey, % "$" cr_MouseKey%cr_MouseKey%, RButton_ComfortResize, On
Return

DoDisable_ComfortResize:
	func_HotkeyDisable("cr_640x480")
	func_HotkeyDisable("cr_800x600")
	func_HotkeyDisable("cr_1024x768")
	func_HotkeyDisable("cr_1280x1024")
	func_HotkeyDisable("cr_custom1")
	func_HotkeyDisable("cr_custom2")
	If ( InStr(cr_MouseKey%cr_MouseKey%, "Hook_") )
	{
		UnRegisterHook( "MButton", "ComfortResize" )
		UnRegisterHook( "RButton", "ComfortResize" )
	}
	Else If ( InStr(cr_MouseKey%cr_MouseKey%, " & ") )
		Hotkey, % cr_MouseKey%cr_MouseKey%, RButton_ComfortResize, Off
	Else
		Hotkey, % "$" cr_MouseKey%cr_MouseKey%, RButton_ComfortResize, Off
Return

DefaultSettings_ComfortResize:
Return

Update_ComfortResize:
	IniRead, NoWinkey, %ConfigFile%, ComfortResize, NoWinkey
	If NoWinkey = 1
	{
		IniWrite, 8, %ConfigFile%, ComfortResize, MouseKey
	}
	IniDelete, %ConfigFile%, ComfortResize, NoWinkey
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

RButton_ComfortResize:
MButton_ComfortResize:
	MouseGetPos, cr_actMouseX, cr_actMouseY,cr_actWin
	WinGetClass, cr_actClass, ahk_id %cr_actWin%
	If func_IsWindowInIgnoreList?()
		Return
	WinGetTitle, cr_actWinTitle, ahk_id %cr_actWin%
	If cr_actWinTitle in aadScreenShots
		Return
	Loop, Parse, cr_DisableClasses, `,
	{
		If (func_WildcardMatch( cr_actWinTitle, A_LoopField, 0) OR func_WildcardMatch( cr_actClass, A_LoopField, 0) )
		{
			Return
		}
	}

	cr_diffX := cr_lastMouseX - cr_actMouseX
	cr_diffY := cr_lastMouseY - cr_actMouseY
	Transform, cr_diffX, abs, %cr_diffX%
	Transform, cr_diffY, abs, %cr_diffY%
	If ( (cr_diffY < 5 AND cr_diffX < 5) )
	{
		If (A_Priorhotkey = A_Thishotkey AND A_TickCount-cr_ClickTime < 400)
		{
			cr_DoubleClick = 1
		}
		Else
		{
			cr_DoubleClick = 0
		}
	}
	Else
		cr_DoubleClick = 0

	cr_ClickTime = %A_TickCount%
	cr_lastMouseX = %cr_actMouseX%
	cr_lastMouseY = %cr_actMouseY%

	cr_Cursor = %A_Cursor%

	Gosub, cr_sub_ResizeInteractivally

	; Mauspfeil zurücksetzen
	If cr_Cursor = IBEAM
		DllCall("SetSystemCursor", "Uint", cr_hCurs, "Int", IDC_IBEAM)
	Else
		DllCall("SetSystemCursor", "Uint", cr_hCurs, "Int", IDC_ARROW)
	cr_hCurs =
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------
cr_sub_640x480:
	cr_newW = %cr_custom3w%
	cr_newH = %cr_custom3h%
	cr_minusTaskbar = %cr_minusTaskbar3%
	Gosub, cr_sub_Resize
Return

cr_sub_800x600:
	cr_newW = %cr_custom4w%
	cr_newH = %cr_custom4h%
	cr_minusTaskbar = %cr_minusTaskbar4%
	Gosub, cr_sub_Resize
Return

cr_sub_1024x768:
	cr_newW = %cr_custom5w%
	cr_newH = %cr_custom5h%
	cr_minusTaskbar = %cr_minusTaskbar5%
	Gosub, cr_sub_Resize
Return

cr_sub_1280x1024:
	cr_newW = %cr_custom6w%
	cr_newH = %cr_custom6h%
	cr_minusTaskbar = %cr_minusTaskbar6%
	Gosub, cr_sub_Resize
Return

cr_sub_custom1:
	cr_newW = %cr_custom1w%
	cr_newH = %cr_custom1h%
	cr_minusTaskbar = %cr_minusTaskbar1%
	Gosub, cr_sub_Resize
Return

cr_sub_custom2:
	cr_newW = %cr_custom2w%
	cr_newH = %cr_custom2h%
	cr_minusTaskbar = %cr_minusTaskbar2%
	Gosub, cr_sub_Resize
Return

cr_sub_Resize:
	cr_Monitor := func_GetMonitorNumber("A")
	If cr_newH = *
		cr_newH := WorkArea%cr_Monitor%Height
	If cr_newW = *
		cr_newW := WorkArea%cr_Monitor%Width

	StringReplace, cr_NewW, cr_NewW, `:, /
	StringReplace, cr_NewH, cr_NewH, `:, /
	IfInString cr_NewW, /
	{
		StringSplit, cr_NewW, cr_NewW, /
		cr_NewW := Round(Monitor%cr_Monitor%Width*cr_NewW1/cr_NewW2)
	}
	IfInString cr_newH, /
	{
		StringSplit, cr_newH, cr_newH, /
		cr_newH := Round(Monitor%cr_Monitor%Height*cr_newH1/cr_newH2)
	}

	;tooltip, % cr_newH "`n" WorkArea%cr_Monitor%Height "`n" cr_newH1 "/" cr_newH2

	If cr_minusTaskbar = 1
	{
		cr_subW := Monitor%cr_Monitor%Width	- WorkArea%cr_Monitor%Width
		cr_newW := cr_newW - cr_subW
		cr_subH := Monitor%cr_Monitor%Height - WorkArea%cr_Monitor%Height
		cr_newH := cr_newH - cr_subH
	}

	; ID, Groesse und Position des aktuellen Fensters
	WinGet, cr_WindowID, ID, A
	WinGetPos, cr_X, cr_Y, cr_Width, cr_Height, A
	cr_newX = %cr_X%
	cr_newY = %cr_Y%
	WinGet,cr_Win,MinMax,ahk_id %cr_WindowID%
	WinGetClass, cr_actClass, ahk_id %cr_WindowID%
	if (cr_actClass = "Putty")
		SendMessage WM_ENTERSIZEMOVE, , , , ahk_id %cr_WindowID%
	If (cr_Win = 1)
	{
		If cr_ResizeFixedWindows = 1
		{
			WinMove, ahk_id %cr_WindowID%,, %cr_WinX1%, %cr_WinY1%, %cr_WinW%, %cr_WinH%
			WinRestore, ahk_id %cr_WindowID%
			WinMove, ahk_id %cr_WindowID%,, %cr_WinX1%, %cr_WinY1%, %cr_WinW%, %cr_WinH%
		}
		Else
			Return
	}
	If cr_MagneticBorders = 1
	{
		If cr_minusTaskbar = 1
		{
			if (cr_newX + cr_newW > WorkArea%cr_Monitor%Right)
				cr_newX := WorkArea%cr_Monitor%Right - cr_newW
			if (cr_newX < WorkArea%cr_Monitor%Left)
			{
				cr_newX := WorkArea%cr_Monitor%Left
			}
			if (cr_newY + cr_newH > WorkArea%cr_Monitor%Bottom)
				cr_newY := WorkArea%cr_Monitor%Bottom - cr_newH
			if (cr_newY < WorkArea%cr_Monitor%Top)
			{
				cr_newY := WorkArea%cr_Monitor%Top
			}
		}
		Else
		{
			if (cr_newX + cr_newW > Monitor%cr_Monitor%Right)
				cr_newX := Monitor%cr_Monitor%Right - cr_newW
			if (cr_newX < Monitor%cr_Monitor%Left)
			{
				cr_newX := Monitor%cr_Monitor%Left
			}
			if (cr_newY + cr_newH > Monitor%cr_Monitor%Bottom)
				cr_newY := Monitor%cr_Monitor%Bottom - cr_newH
			if (cr_newY < Monitor%cr_Monitor%Top)
			{
				cr_newY := Monitor%cr_Monitor%Top
			}
		}

	}

	WinGet, cr_Style, Style, ahk_id %cr_WindowID%
	If (!(cr_Style & 0x40000) AND cr_ResizeFixedWindows = 0)
		Return

	If (cr_Width <> cr_newW OR cr_Height <> cr_newH)
	{
		WinRestore, A
		WinMove, A,, %cr_newX%, %cr_newY%, %cr_newW%, %cr_newH%
		; Fensterwerte fuer spaeter speichern
		cr_WindowX%cr_WindowID%			= %cr_X%
		cr_WindowWidth%cr_WindowID%	= %cr_Width%
		cr_WindowY%cr_WindowID%			= %cr_Y%
		cr_WindowHeight%cr_WindowID% = %cr_Height%
		cr_WindowMax%cr_WindowID%		= %cr_Win%

		If cr_ShowPosition = 1
		{
			CoordMode, ToolTip, Screen
			cr_Tooltip = %lng_cr_Size% (%cr_newW%x%cr_newH%)
			Tooltip, %cr_Tooltip%, %cr_newX%, %cr_newY%
			SetTimer, cr_tim_ToopTipOff, 2000
		}
	}
	Else If (cr_WindowHeight%cr_WindowID% <> "" AND cr_WindowWidth%cr_WindowID% <> "")
	{
		ToolTip
		WinMove, A, , cr_WindowX%cr_WindowID%, cr_WindowY%cr_WindowID%, cr_WindowWidth%cr_WindowID%, cr_WindowHeight%cr_WindowID%
		If cr_WindowMax%cr_WindowID% = 1
			WinMaximize, A
		; Speicherwerte zuruecksetzen
		cr_WindowHeight%cr_WindowID% =
		cr_WindowY%cr_WindowID%			=
		cr_WindowMax%cr_WindowID%		=
		cr_WindowWidth%cr_WindowID%	=
		cr_WindowX%cr_WindowID%			=
	}
	Else
	{
		CoordMode, ToolTip, Screen
		cr_Tooltip = %lng_cr_Size% (%cr_newW%x%cr_newH%)
		Tooltip, %cr_Tooltip%, %cr_newX%, %cr_newY%
		SetTimer, cr_tim_ToopTipOff, 2000
	}
	if (cr_actClass = "Putty")
		SendMessage WM_EXITSIZEMOVE , , , , ahk_id %cr_WindowID%
Return

cr_tim_ToopTipOff:
	SetTimer, cr_tim_ToopTipOff, Off
	ToolTip
Return

cr_sub_ResizeInteractivally:
	WinGet, cr_WindowID, ID, A
	if (cr_actClass = "Putty")
		SendMessage WM_ENTERSIZEMOVE, , , , ahk_id %cr_WindowID%
	SetBatchLines,2000
	; Mausposition relativ zum Bildschirm bekommen
	CoordMode,Mouse
	; Mausposition und ID des darunterliegenden Fensters ermitteln
	MouseGetPos,cr_X1,cr_Y1,cr_id
	; Postion und Groesse des Fensters ermitteln
	WinGetPos,cr_WinX1,cr_WinY1,cr_WinW,cr_WinH,ahk_id %cr_id%
	; Fensterregion ermitteln. Die neuen Regionen ergeben sich als
	; Horizontal x Vertikal = (left,center,right)x(up,center,down)
	If (cr_X1 < cr_WinX1 + cr_WinW / 4)
	 cr_WinHor = left
	Else If (cr_X1 < cr_WinX1 + 3 * cr_WinW / 4)
	 cr_WinHor = center
	Else
	 cr_WinHor = right
	If (cr_Y1 < cr_WinY1 + cr_WinH / 4)
		cr_WinVer = up
	Else If (cr_Y1 < cr_WinY1 + 3 * cr_WinH / 4)
		cr_WinVer = center
	Else
		cr_WinVer = down
	; Fenster-Style ermitteln
	WinGet, cr_Style, Style, ahk_id %cr_id%
	If ( (!(cr_Style & 0x40000) AND cr_ResizeFixedWindows = 0) OR cr_AlwaysMoveNonActive = 1 AND !WinActive("ahk_id" cr_id))
	{
		cr_Resizeable = 0
		cr_WinHor = center
		cr_WinVer = center
	}
	Else
		cr_Resizeable = 1

	cr_DistanceX := 0
	cr_DistanceY := 0
	; Schleife, solange Mausbutton gedrueckt
	Loop
	{
		GetKeyState, cr_Button, RButton, P
		IfInString, A_ThisHotkey, MButton
			GetKeyState, cr_Button, MButton, P
		IfInString, A_ThisHotkey, LButton
			GetKeyState, cr_Button, LButton, P

		GetKeyState, cr_LButton, LButton, P

		; Solange der Knopf gedrückt ist
		If cr_Button = D
		{
			If cr_MouseKey = 9
			{
				If cr_LButton <> D
					continue
			}

		; aktuelle Mausposition bestimmen
		MouseGetPos,cr_X2,cr_Y2
		cr_X3 = %cr_X2%
		cr_Y3 = %cr_Y2%
		; aktuelle Fenstergroesse und -position bestimmen
		WinGetPos,cr_WinX1,cr_WinY1,cr_WinW,cr_WinH,ahk_id %cr_id%
		cr_WinX2 := cr_WinX1+cr_WinW
		cr_WinY2 := cr_WinY1+cr_WinH

		; Raster
		GetKeyState, cr_ShiftState, Shift, P
		GetKeyState, cr_CtrlState, Ctrl, P
		If ( (cr_ShiftState = "D" AND cr_RasterAlways = 0) OR (cr_ShiftState = "U" AND cr_RasterAlways = 1) )
		{
			cr_Monitor := func_GetMonitorNumber("A")

			cr_RasterXtmp = %cr_RasterX%
			cr_RasterYtmp = %cr_RasterY%
			StringReplace, cr_RasterXtmp, cr_RasterXtmp, `:, /
			StringReplace, cr_RasterYtmp, cr_RasterYtmp, `:, /
			IfInString cr_RasterXtmp, /
			{
				StringSplit, cr_RasterXtmp, cr_RasterXtmp, /
				cr_RasterXtmp := Round(WorkArea%cr_Monitor%Width*cr_RasterXtmp1/cr_RasterXtmp2)
			}
			IfInString cr_RasterYtmp, /
			{
				StringSplit, cr_RasterYtmp, cr_RasterYtmp, /
				cr_RasterYtmp := Round(WorkArea%cr_Monitor%Height*cr_RasterYtmp1/cr_RasterYtmp2)
			}

			cr_X2 := Round(cr_X2/cr_RasterXtmp)*cr_RasterXtmp
			cr_Y2 := Round(cr_Y2/cr_RasterYtmp)*cr_RasterYtmp
		}

		; Verschiebung der Maus innerhalb dieser Schleife ermitteln
		cr_OffsetX := cr_X3 - cr_X1
		cr_OffsetY := cr_Y3 - cr_Y1

		cr_DistanceX := cr_DistanceX + cr_OffsetX
		cr_DistanceY := cr_DistanceY + cr_OffsetY

		If (Abs(cr_DistanceX) < 4 AND Abs(cr_DistanceY) < 4 AND cr_DoubleClick = 0)
		{
			cr_X1 := cr_X3
			cr_Y1 := cr_Y3
			continue
		}

		; Mauspfeil anpassen
		If cr_hCurs =
		{
			cr_hCurs := DllCall("LoadCursor","UInt",NULL, "Int", cr_Cur%cr_WinVer%%cr_WinHor%)
			If cr_Cursor = IBEAM
				DllCall("SetSystemCursor", "Uint", cr_hCurs, "Int", IDC_IBEAM)
			Else
				DllCall("SetSystemCursor", "Uint", cr_hCurs, "Int", IDC_ARROW)
		}

		; Wenn das Fenster maximiert ist
		WinGet,cr_Win,MinMax,ahk_id %cr_id%
		If (cr_Win = 1 AND cr_DoubleClick = 0)
		{
			If cr_ResizeFixedWindows = 1
				WinRestore, ahk_id %cr_id%
			Else
				Return
		}

		; Abhaengig von der Fensterregion reagieren
		; In der Mitte wird das Fenster verschoben
		If ( (cr_WinHor = "center" and cr_WinVer = "center") OR (cr_AlwaysMoveNonActive = 1 AND !WinActive("ahk_id" cr_id)) )
		{
			If (cr_DoubleClick = 1 AND Enable_WindowsControl = 1 AND cr_Resizeable = 1 )
			{
				Gosub, wc_sub_Max%A_EmptyVar%
				cr_Resizeable = 0
				Return
			}
			cr_WinX1 += cr_OffsetX
			cr_WinY1 += cr_OffsetY
			If ( (cr_MagneticBorders = 1 AND cr_CtrlState = "U") OR (cr_MagneticBorders = 0 AND cr_CtrlState = "D") )
			{
				if (cr_WinX1 + cr_WinW > WorkAreaRight)
					cr_WinX1 := WorkAreaRight-cr_WinW
				if (cr_WinX1 < WorkAreaLeft)
					cr_WinX1 := WorkAreaLeft
				if (cr_WinY1 + cr_WinH > WorkAreaBottom)
					cr_WinY1 := WorkAreaBottom-cr_WinH
				if (cr_WinY1 < WorkAreaTop)
					cr_WinY1 := WorkAreaTop
			}
		}
		; Ansonsten wird die Groesse veraendert
		Else
		{
			; Wenn das Fenster maximiert ist
			WinGet,cr_Win,MinMax,ahk_id %cr_id%
			If (cr_Win = 1 AND cr_DoubleClick = 0)
			{
				If cr_ResizeFixedWindows = 1
					WinRestore, ahk_id %cr_id%
				Else
					Return
			}

			If ( cr_WinHor = "left" AND cr_Resizeable = 1 )
			{
			 If (cr_DoubleClick = 1 AND Enable_WindowsControl = 1)
			 {
				 Gosub, wc_sub_MaxWidth%A_EmptyVar%
				 cr_Resizeable = 0
				 Return
			 }
			 cr_WinX1 += cr_OffsetX
			 cr_WinW	-= cr_OffsetX
			}
			Else If ( cr_WinHor = "right"	AND cr_Resizeable = 1 )
			{
			 If (cr_DoubleClick = 1 AND Enable_WindowsControl = 1)
				 Goto, wc_sub_MaxWidth%A_EmptyVar%
			 cr_WinW	+= cr_OffsetX
			}
			If ( cr_WinVer = "up" AND cr_Resizeable = 1 )
			{
			 If (cr_DoubleClick = 1 AND Enable_WindowsControl = 1)
			 {
				 Gosub, wc_sub_MaxHeight%A_EmptyVar%
				 cr_Resizeable = 0
				 Return
			 }
			 cr_WinY1 += cr_OffsetY
			 cr_WinH	-= cr_OffsetY
			}
			Else If ( cr_WinVer = "down" AND cr_Resizeable = 1 )
			{
			 If (cr_DoubleClick = 1 AND Enable_WindowsControl = 1)
			 {
				 Gosub, wc_sub_MaxHeight%A_EmptyVar%
				 cr_Resizeable = 0
				 Return
			 }
			 cr_WinH	+= cr_OffsetY
			}

			; Magnetische Bildschirmränder
			If ( (cr_MagneticBorders = 1 AND cr_CtrlState = "U") OR (cr_MagneticBorders = 0 AND cr_CtrlState = "D") )
			{
				if (cr_WinX1 + cr_WinW > WorkAreaRight)
					cr_WinW := WorkAreaRight - cr_WinX1
				if (cr_WinX1 < WorkAreaLeft)
				{
					cr_WinW := (cr_WinX1-WorkAreaLeft) + cr_WinW
					cr_WinX1 := WorkAreaLeft
				}
				if (cr_WinY1 + cr_WinH > WorkAreaBottom)
					cr_WinH := WorkAreaBottom - cr_WinY1
				if (cr_WinY1 < WorkAreaTop)
				{
					cr_WinH := (cr_WinY1-WorkAreaTop) + cr_WinH
					cr_WinY1 := WorkAreaTop
				}
			}
		}

		; Raster
		If ( (cr_ShiftState = "D" AND cr_RasterAlways = 0) OR (cr_ShiftState = "U" AND cr_RasterAlways = 1) )
		{
			cr_WinX1 := Round(cr_WinX1/cr_RasterXtmp)*cr_RasterXtmp
			cr_WinY1 := Round(cr_WinY1/cr_RasterYtmp)*cr_RasterYtmp
			If cr_Resizeable = 1
			{
				cr_WinW := Round(cr_WinW/cr_RasterXtmp)*cr_RasterXtmp
				cr_WinH := Round(cr_WinH/cr_RasterYtmp)*cr_RasterYtmp
			}
		}

		; Bei Stillstand Fenster neu zeichen, wodurch "Schlieren" entfernt werden
		If (cr_LastX <> cr_WinX1 OR cr_LastY <> cr_WinY1 OR cr_LastW <> cr_WinW OR cr_LastH <> cr_WinH)
		{
			; Zeichenverzoegerung je nach Voreinstellung
			If cr_SlowMovement = 1
				SetWinDelay,30
			Else
				SetWinDelay,-1
		}
		Else
			SetWindelay, 5

		; Die gerade ermittelten Werte werden jetzt aufs Fenster angewendet
		WinMove,ahk_id %cr_id%,,%cr_WinX1%,%cr_WinY1%,%cr_WinW%,%cr_WinH%

		; Mausposition für diese Schleife uebernehmen
		cr_X1 := cr_X2
		cr_Y1 := cr_Y2
		; Tooltip aktualisieren
		If ( !(cr_AlwaysMoveNonActive = 1 AND !WinActive("ahk_id" cr_id)) AND cr_ShowPosition = 1 )
		{
			cr_Tooltip = %lng_cr_Position% (%cr_WinX1%, %cr_WinY1%)`n%lng_cr_Size% (%cr_WinW%, %cr_WinH%) %Style% %ExStyle%
			Tooltip, %cr_Tooltip%
		}
		cr_LastX = %cr_WinX1%
		cr_LastY = %cr_WinY1%
		cr_LastW = %cr_WinW%
		cr_LastH = %cr_WinH%

	 }
	 ; Wenn der Mausbutton losgelassen wurde, Tooltip loeschen und abbrechen
	 Else
	 {
		cr_LastX =
		cr_LastY =
		cr_LastW =
		cr_LastH =
		Tooltip
		If (Abs(cr_DistanceX) < 4 AND Abs(cr_DistanceY) < 4)
		{
			IfInString, A_ThisHotkey, MButton
				MButton_send = yes
			IfInString, A_ThisHotkey, RButton
			{
				RButton_send = yes
				RButton_tip = yes
			}
			If (!WinActive("ahk_id" cr_id))
				WinActivate, ahk_id %cr_id%
		}
		Else
		{
			RButton_send = no
			IfInString, A_ThisHotkey, MButton
				MButton_send = no
		}
		Break
		}
		Sleep, 10
	} ; Loop Ende
	if (cr_actClass = "Putty")
		SendMessage WM_EXITSIZEMOVE , , , , ahk_id %cr_WindowID%
Return

cr_sub_GetDisableClass:
	Gui, %GuiID_activAid%:Cancel
	Gui, %GuiID_ComfortResize%:Cancel
	SplashImage,,b1 cwFFFF80 FS9 WS700 w400, %lng_getClassMsg%
	SetTimer, cr_tim_GetClass, 10
	Input,cr_GetKey,L1 *,{Enter}{ESC}
	SetTimer, cr_tim_GetClass, Off
	SplashImage, Off
	ToolTip
	Gui, %GuiID_activAid%:Show
	Gui, %GuiID_ComfortResize%:Show
	If ErrorLevel <> Endkey:Enter
		Return

	GuiControlGet, cr_DisableClasses_tmp, %GuiID_ComfortResize%:, cr_DisableClasses_tmp
	StringReplace, cr_DisableClasses_tmp, cr_DisableClasses_tmp, `n, %A_Tab%, All
	AutoTrim, On
	cr_DisableClasses_tmp = %cr_DisableClasses_tmp%%A_Tab%%cr_GetClass%
	AutoTrim, Off
	StringReplace, cr_DisableClasses_tmp, cr_DisableClasses_tmp, %A_Tab%%A_Tab%, %A_Tab%, All
	StringReplace, cr_DisableClasses_tmp, cr_DisableClasses_tmp, %A_Tab%, `n, All
	GuiControl,%GuiID_ComfortResize%:,cr_DisableClasses_tmp, %cr_DisableClasses_tmp%
	GuiControl,%GuiID_ComfortResize%:Focus,cr_DisableClasses_tmp

	Send,^{End}{Space}{BS}
	cr_ClassList =
Return

cr_tim_GetClass:
	MouseGetPos,,,cr_getId,cr_getClass
	WinGetClass, cr_getClass, ahk_id %cr_getId%
	If cr_getClass =
		WinGetClass,cr_getClass,A
	ToolTip, %cr_getClass%
Return
