; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               Calendar
; -----------------------------------------------------------------------------
; Prefix:             cal
; Version:            0.9.1
; Date:               2008-02-01
; Author:             Dirk Schwarzmann, RobOtter-Software, www.dirk-schwarzmann.de
;                     Michael Telgkamp
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_Calendar:

	; * Das verwendete eindeutige Präfix ohne Unterstrich
	Prefix = cal
	%Prefix%_ScriptName    = Calendar
	%Prefix%_ScriptVersion = 0.9.1
	%Prefix%_Author        = Dirk Schwarzmann, Michael Telgkamp

	HideSettings = 0                             ; Wenn 1, dann bekommt die Erweiterung keinen Eintrag im Konfigurationsdialog
	EnableTray_Calendar   =            ; Soll eine Erweiterung nicht im Tray-Menü aufgeführt werden, muss der Wert 0 betragen

	DisableIfCompiled_Calendar =       ; Wenn 1, lässt sich die Erweiterung in kompilierter Form nicht de-/aktivieren

	CreateGuiID("Calendar")
	CreateGuiID("TimeCalc")

	IconFile_On_Calendar = %A_WinDir%\system32\timedate.cpl
	IconPos_On_Calendar = 1

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		; Name des Menüeintrags im Tray-Menü
		MenuName                      = %cal_ScriptName% - Monatsübersichten und Tagesberechnung
		Description                   = Schnelle Jahres- und Monatsübersicht in verschiedenen Größen.`nTagesrechner: Wieviel Tage sind es bis zum nächsten Ersten, welches Datum haben wir in 120 Tagen, ...

		lng_cal_hk_master             = Master-Hotkey
		lng_cal_hk_timeCalc           = Tagesrechner
		lng_cal_hk_12months           = Kalender: 1 Jahr
		lng_cal_hk_6months            = Kalender: 6 Monate
		lng_cal_hk_3months            = Kalender: 3 Monate

		lng_cal_secondHK_showWindow   = Tastenübersicht für zweite Stufe anzeigen
		lng_cal_secondHK_timeout      = Timeout für zweite Stufe

		lng_cal_view_format           = Anzeigeformat (Spalten / Zeilen):
		lng_cal_vf_12months           = 1 Jahr
		lng_cal_vf_6months            = 6 Monate
		lng_cal_vf_3months            = 3 Monate

		lng_cal_font_format           = Anzeigeschrift
		lng_cal_font_size             = Schriftgröße
		lng_cal_font_weight           = Fett

		lng_cal_Transparency          = Transparenz

		lng_cal_tc_Header             = Tagesrechner
		lng_cal_tc_fixed              = Ergebnis
		lng_cal_tc_startDate          = Anfangsdatum
		lng_cal_tc_diffDays           = Tage dazwischen
		lng_cal_tc_endDate            = Enddatum

		lng_cal_winTitle_tc           = Tagesrechner
		lng_cal_winTitle_cal          = Kalender

		lng_cal_CopyToClipBoard1      = Datums-Button kopiert das Datum zusätzlich in die Zwischenablage
		lng_cal_CopyToClipBoard2      = Datums-Button kopiert das Datum nur in die Zwischenablage
		lng_cal_CloseNoFocus          = Kalender schließen, wenn ein anderes Fenster aktiviert wird
		lng_cal_AlwaysOnTop           = Kalender ist immer sichtbar
		lng_cal_showMonthCentered     = Dreimonatsansicht: aktueller Monat in der Mitte
		lng_cal_stepByOneMonth        = Monats- statt seitenweise scrollen
		lng_cal_showTcInCalView       = Zeige Tagesrechner in Kalender

		lng_cal_resetWindowPositions  = Fensterpositionen zurücksetzen

		; Für GUI-Elemente sind auch automatische Tooltips möglich
		tooltip_cal_vf_12m_group      = Sehr hohe und schmale Anzeige - geeignet für Bildschirme mit hoher Auflösung
		tooltip_cal_vf_6m_group       = Sehr hohe und schmale Anzeige - geeignet für Bildschirme mit hoher Auflösung
		tooltip_cal_vf_3m_group       = Hohe und schmale Anzeige
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %cal_ScriptName% - Monthly overview and day calculation
		Description                   = Quick overview for months and years.`nAlso a date calculator: How many days until next Friday, which date is in 120 days, ...

		lng_cal_hk_master             = Master-Hotkey
		lng_cal_hk_timeCalc           = Day calculator
		lng_cal_hk_12months           = Calendar: 1 year
		lng_cal_hk_6months            = Calendar: 6 months
		lng_cal_hk_3months            = Calendar: 3 months

		lng_cal_secondHK_showWindow   = Show key bindings for second level
		lng_cal_secondHK_timeout      = Timeout for second level

		lng_cal_view_format           = Viewing format (columns / rows):
		lng_cal_vf_12months           = 1 year
		lng_cal_vf_6months            = 6 months
		lng_cal_vf_3months            = 3 months

		lng_cal_font_format           = Viewing font
		lng_cal_font_size             = Font size
		lng_cal_font_weight           = Bold

		lng_cal_Transparency          = Transparency

		lng_cal_tc_Header             = Day calculator
		lng_cal_tc_fixed              = Result
		lng_cal_tc_startDate          = Start date
		lng_cal_tc_diffDays           = Days between
		lng_cal_tc_endDate            = End date

		lng_cal_winTitle_tc           = Day calculator
		lng_cal_winTitle_cal          = Calendar

		lng_cal_CopyToClipBoard1      = Date button copies the date also into the clipboard
		lng_cal_CopyToClipBoard2      = Date button copies the date only into the clipboard
		lng_cal_CloseNoFocus          = Close window if it gets inactive
		lng_cal_AlwaysOnTop           = Window is always visible
		lng_cal_showMonthCentered     = Show current month centered
		lng_cal_stepByOneMonth        = Scroll by one month
		lng_cal_showTcInCalView       = Show day calculator in calendar

		lng_cal_resetWindowPositions  = Reset window positions

		tooltip_cal_vf_12m_group      = Very low and wide view - useful for high resolution screens
		tooltip_cal_vf_6m_group       = Very tall and slim view - useful for high resolution screens
		tooltip_cal_vf_3m_group       = A tall and slim view

	}

	func_HotkeyRead( "cal_Hotkey_master",   ConfigFile , cal_ScriptName, "Hotkey_master", "cal_Hotkey_master", "", "$" )
	func_HotkeyRead( "cal_Hotkey_timeCalc", ConfigFile , cal_ScriptName, "Hotkey_timeCalc", "cal_Hotkey_timeCalc", "", "$", "Hotkey_cal_Hotkey_master" )
	func_HotkeyRead( "cal_Hotkey_12months", ConfigFile , cal_ScriptName, "Hotkey_12months", "cal_Hotkey_12months", "", "$", "Hotkey_cal_Hotkey_master" )
	func_HotkeyRead( "cal_Hotkey_6months",  ConfigFile , cal_ScriptName, "Hotkey_6months",  "cal_Hotkey_6months", "", "$", "Hotkey_cal_Hotkey_master" )
	func_HotkeyRead( "cal_Hotkey_3months",  ConfigFile , cal_ScriptName, "Hotkey_3months",  "cal_Hotkey_3months", "", "$", "Hotkey_cal_Hotkey_master" )

;   If Hotkey_cal_Hotkey_master <>
;   {
;      If Hotkey_cal_Hotkey_timeCalc <>
;         StringReplace, Hotkey_AllHotkeys_tmp, Hotkey_AllHotkeys_tmp, «<%Hotkey_cal_Hotkey_timeCalc% >»,
;      If Hotkey_cal_Hotkey_12months <>
;         StringReplace, Hotkey_AllHotkeys_tmp, Hotkey_AllHotkeys_tmp, «<%Hotkey_cal_Hotkey_12months% >»,
;      If Hotkey_cal_Hotkey_6months<>
;         StringReplace, Hotkey_AllHotkeys_tmp, Hotkey_AllHotkeys_tmp, «<%Hotkey_cal_Hotkey_6months% >»,
;      If Hotkey_cal_Hotkey_3months<>
;         StringReplace, Hotkey_AllHotkeys_tmp, Hotkey_AllHotkeys_tmp, «<%Hotkey_cal_Hotkey_3months% >»,
;   }

	IniRead, cal_vf_12m_group,        %ConfigFile%, %cal_ScriptName%, ViewType_12months, 4
	IniRead, cal_vf_6m_group,         %ConfigFile%, %cal_ScriptName%, ViewType_6months,  3
	IniRead, cal_vf_3m_group,         %ConfigFile%, %cal_ScriptName%, ViewType_3months,  2

	IniRead, cal_guiPos_TC_X,         %ConfigFile%, %cal_ScriptName%, ViewPosX_TimeCalc,  %WorkAreaLeft%
	IniRead, cal_guiPos_TC_Y,         %ConfigFile%, %cal_ScriptName%, ViewPosY_TimeCalc,  %WorkAreaTop%

	IniRead, cal_guiPos_12m_X,        %ConfigFile%, %cal_ScriptName%, ViewPosX_12months,  %WorkAreaLeft%
	IniRead, cal_guiPos_12m_Y,        %ConfigFile%, %cal_ScriptName%, ViewPosY_12months,  %WorkAreaTop%
	IniRead, cal_guiPos_6m_X,         %ConfigFile%, %cal_ScriptName%, ViewPosX_6months,   %WorkAreaLeft%
	IniRead, cal_guiPos_6m_Y,         %ConfigFile%, %cal_ScriptName%, ViewPosY_6months,   %WorkAreaTop%
	IniRead, cal_guiPos_3m_X,         %ConfigFile%, %cal_ScriptName%, ViewPosX_3months,   %WorkAreaLeft%
	IniRead, cal_guiPos_3m_Y,         %ConfigFile%, %cal_ScriptName%, ViewPosY_3months,   %WorkAreaTop%

	IniRead, cal_tc_groupIndex,       %ConfigFile%, %cal_ScriptName%, TimeCalcFixedField, 1

	IniRead, cal_secondHK_timeout,    %ConfigFile%, %cal_ScriptName%, SecondHotkey_Timeout, 1
	IniRead, cal_secondHK_showWindow, %ConfigFile%, %cal_ScriptName%, SecondHotkey_ShowHelpWindow, 1

	cal_TimeCalcViewOpen = 0
	cal_CalenderViewOpen = 0

	cal_CalenderBtnOptsHorizontal = w170 h24
	cal_CalenderDdlOptsHorizontal = w168 x+5 yp+1
	cal_CalenderBtnOptsVertical   = w170 h24
	cal_CalenderDdlOptsVertical   = w168 xs+1 y+5

	IniRead, cal_dateFormatIndex,     %ConfigFile%, %cal_ScriptName%, DateFormatIndex, 1
	IniRead, cal_dateFormatList,      %ConfigFile%, %cal_ScriptName%, DateFormatList, d.M.yyyy|dd.MM.yyyy|dd.MM.yy|dddd, dd. MMMM yyyy|yyyy-MM-dd|yy-MM-dd|MM/dd/yy|MM/dd/yyyy
	StringSplit, cal_dateFormat_, cal_dateFormatList, |

	cal_FontSize1 = 8
	cal_FontSize2 = 9
	cal_FontSize3 = 10
	cal_FontSize4 = 11
	cal_FontSize5 = 12
	cal_FontSize6 = 14
	cal_FontSize7 = 16
	cal_FontSize8 = 18
	cal_FontSize9 = 20
	cal_FontSize10 = 24
	cal_FontSize11 = 28
	cal_FontSize12 = 36

	; Build the string representation for the drop down list
	cal_FontSizes = %cal_FontSize1%
	Loop, 11 {
		 cal_idx := A_Index + 1
		 cal_FSize := cal_FontSize%cal_idx%
		 cal_FontSizes = %cal_FontSizes%|%cal_FSize%
	}

	IniRead, cal_FontSizeIdx_12m,        %ConfigFile%, %cal_ScriptName%, FontSizeIndex_12months, 1
	IniRead, cal_FontWeight_12m,         %ConfigFile%, %cal_ScriptName%, FontWeight_12months, 0
	IniRead, cal_FontSizeIdx_6m,         %ConfigFile%, %cal_ScriptName%, FontSizeIndex_6months, 1
	IniRead, cal_FontWeight_6m,          %ConfigFile%, %cal_ScriptName%, FontWeight_6months, 0
	IniRead, cal_FontSizeIdx_3m,         %ConfigFile%, %cal_ScriptName%, FontSizeIndex_3months, 1
	IniRead, cal_FontWeight_3m,          %ConfigFile%, %cal_ScriptName%, FontWeight_3months, 0

	IniRead, cal_Transparency,           %ConfigFile%, %cal_ScriptName%, WindowTransparency, 255

	RegisterAdditionalSetting("cal", "CopyToClipBoard1", 0)
	RegisterAdditionalSetting("cal", "CopyToClipBoard2", 0)
	RegisterAdditionalSetting("cal", "AlwaysOnTop", 0)
	RegisterAdditionalSetting("cal", "CloseNoFocus", 0)
	RegisterAdditionalSetting("cal", "showMonthCentered", 0)
	RegisterAdditionalSetting("cal", "stepByOneMonth", 0)
	RegisterAdditionalSetting("cal", "showTcInCalView", 0)
Return

SettingsGui_Calendar:
	func_HotkeyAddGuiControl( lng_Hotkey " " lng_cal_hk_master,   "cal_Hotkey_master",   "xs+10 y+10 w180" )
	Gui, Add, Edit, xs+40 y+2 w35 Center Number Limit2 vcal_secondHK_timeout gsub_CheckIfSettingsChanged
	Gui, Add, UpDown, Range1-10 gsub_CheckIfSettingsChanged vcal_secondHK_timeout_ud, %cal_secondHK_timeout%
	Gui, Add, Text, x+5 yp+3, %lng_cal_secondHK_timeout%
	Gui, Add, Checkbox, x+30 Checked%cal_secondHK_showWindow% gsub_CheckIfSettingsChanged vcal_secondHK_showWindow, %lng_cal_secondHK_showWindow%

	func_HotkeyAddGuiControl( lng_Hotkey " " lng_cal_hk_timeCalc, "cal_Hotkey_timeCalc", "xs+10 y+10 w180" )
	func_HotkeyAddGuiControl( lng_Hotkey " " lng_cal_hk_12months, "cal_Hotkey_12months", "xs+10 y+10 w180" )
	func_HotkeyAddGuiControl( lng_Hotkey " " lng_cal_hk_6months,  "cal_Hotkey_6months",  "xs+10 y+10 w180" )
	func_HotkeyAddGuiControl( lng_Hotkey " " lng_cal_hk_3months,  "cal_Hotkey_3months",  "xs+10 y+10 w180" )

	cal_vf12m_1 = 0
	cal_vf12m_2 = 0
	cal_vf12m_3 = 0
	cal_vf12m_4 = 0
	cal_vf12m_%cal_vf_12m_group% = 1
	cal_vf6m_1 = 0
	cal_vf6m_2 = 0
	cal_vf6m_3 = 0
	cal_vf6m_4 = 0
	cal_vf6m_%cal_vf_6m_group% = 1
	cal_vf3m_1 = 0
	cal_vf3m_2 = 0
	cal_vf3m_%cal_vf_3m_group% = 1

	Gui, Font, wBold
	Gui, Add, Text, xs+10 y+10, %lng_cal_view_format%
	Gui, Add, Text, xs+270 yp, %lng_cal_font_format%
	Gui, Font, wNorm
	Gui, Add, Text, xs+10 y+5 w50, %lng_cal_vf_12months%:
	Gui, Add, Radio, x+10 Checked%cal_vf12m_1% gsub_CheckIfSettingsChanged vcal_vf_12m_group, 2x6
	Gui, Add, Radio, x+10 Checked%cal_vf12m_2% gsub_CheckIfSettingsChanged, 6x2
	Gui, Add, Radio, x+10 Checked%cal_vf12m_3% gsub_CheckIfSettingsChanged, 3x4
	Gui, Add, Radio, x+10 Checked%cal_vf12m_4% gsub_CheckIfSettingsChanged, 4x3

	Gui, Add, Text, xs+270 yp, %lng_cal_font_size%
	Gui, Font, s%FontSize6%,
	Gui, Add, DropDownList, x+5 yp-3 w50 AltSubmit Choose%cal_FontSizeIdx_12m% gsub_CheckIfSettingsChanged vcal_FontSizeIdx_12m, %cal_FontSizes%
	Gosub, GuiDefaultFont
	Gui, Add, CheckBox, x+15 yp+3 w135 Checked%cal_FontWeight_12m% gsub_CheckIfSettingsChanged vcal_FontWeight_12m, %lng_cal_font_weight%

	Gui, Add, Text, xs+10 y+5 w50, %lng_cal_vf_6months%:
	Gui, Add, Radio, x+10 Checked%cal_vf6m_1% gsub_CheckIfSettingsChanged vcal_vf_6m_group, 1x6
	Gui, Add, Radio, x+10 Checked%cal_vf6m_2% gsub_CheckIfSettingsChanged, 6x1
	Gui, Add, Radio, x+10 Checked%cal_vf6m_3% gsub_CheckIfSettingsChanged, 3x2
	Gui, Add, Radio, x+10 Checked%cal_vf6m_4% gsub_CheckIfSettingsChanged, 2x3

	Gui, Add, Text, xs+270 yp, %lng_cal_font_size%
	Gui, Font, s%FontSize6%,
	Gui, Add, DropDownList, x+5 yp-3 w50 AltSubmit Choose%cal_FontSizeIdx_6m% gsub_CheckIfSettingsChanged vcal_FontSizeIdx_6m, %cal_FontSizes%
	Gosub, GuiDefaultFont
	Gui, Add, CheckBox, x+15 yp+3 w135 Checked%cal_FontWeight_6m% gsub_CheckIfSettingsChanged vcal_FontWeight_6m, %lng_cal_font_weight%

	Gui, Add, Text, xs+10 y+5 w50, %lng_cal_vf_3months%:
	Gui, Add, Radio, x+10 Checked%cal_vf3m_1% gsub_CheckIfSettingsChanged vcal_vf_3m_group, 1x3
	Gui, Add, Radio, x+10 Checked%cal_vf3m_2% gsub_CheckIfSettingsChanged, 3x1

	Gui, Add, Text, xs+270 yp, %lng_cal_font_size%
	Gui, Font, s%FontSize6%,
	Gui, Add, DropDownList, x+5 yp-3 w50 AltSubmit Choose%cal_FontSizeIdx_3m% gsub_CheckIfSettingsChanged vcal_FontSizeIdx_3m, %cal_FontSizes%
	Gosub, GuiDefaultFont
	Gui, Add, CheckBox, x+15 yp+3 w135 Checked%cal_FontWeight_3m% gsub_CheckIfSettingsChanged vcal_FontWeight_3m, %lng_cal_font_weight%

	Gui, Add, Text, xs+10 y+10 w50, %lng_cal_Transparency%
	Gui, Add, Slider, x+0 yp-5 w256 h30 vcal_Transparency Range0-255 AltSubmit TickInterval8 ToolTip Line8 gsub_CheckIfSettingsChanged, %cal_Transparency%
	Gui, Add, Button, xs+360 yp+10 w200 h20 -Wrap gResetWindows_Calendar, %lng_cal_resetWindowPositions%
Return

; wird aufgerufen, wenn im Konfigurationsdialog OK oder Übernehmen angeklickt wird
SaveSettings_Calendar:
	func_HotkeyWrite( "cal_Hotkey_master",   ConfigFile , cal_ScriptName, "Hotkey_master" )
	func_HotkeyWrite( "cal_Hotkey_timeCalc", ConfigFile , cal_ScriptName, "Hotkey_timeCalc" )
	func_HotkeyWrite( "cal_Hotkey_12months", ConfigFile , cal_ScriptName, "Hotkey_12months" )
	func_HotkeyWrite( "cal_Hotkey_6months",  ConfigFile , cal_ScriptName, "Hotkey_6months" )
	func_HotkeyWrite( "cal_Hotkey_3months",  ConfigFile , cal_ScriptName, "Hotkey_3months" )

	IniWrite, %cal_vf_12m_group%,        %ConfigFile%, %cal_ScriptName%, ViewType_12months
	IniWrite, %cal_vf_6m_group%,         %ConfigFile%, %cal_ScriptName%, ViewType_6months
	IniWrite, %cal_vf_3m_group%,         %ConfigFile%, %cal_ScriptName%, ViewType_3months

	IniWrite, %cal_secondHK_timeout%,    %ConfigFile%, %cal_ScriptName%, SecondHotkey_Timeout
	IniWrite, %cal_secondHK_showWindow%, %ConfigFile%, %cal_ScriptName%, SecondHotkey_ShowHelpWindow

	IniWrite, %cal_FontSizeIdx_12m%,     %ConfigFile%, %cal_ScriptName%, FontSizeIndex_12months
	IniWrite, %cal_FontWeight_12m%,      %ConfigFile%, %cal_ScriptName%, FontWeight_12months
	IniWrite, %cal_FontSizeIdx_6m%,      %ConfigFile%, %cal_ScriptName%, FontSizeIndex_6months
	IniWrite, %cal_FontWeight_6m%,       %ConfigFile%, %cal_ScriptName%, FontWeight_6months
	IniWrite, %cal_FontSizeIdx_3m%,      %ConfigFile%, %cal_ScriptName%, FontSizeIndex_3months
	IniWrite, %cal_FontWeight_3m%,       %ConfigFile%, %cal_ScriptName%, FontWeight_3months

	IniWrite, %cal_Transparency%,        %ConfigFile%, %cal_ScriptName%, WindowTransparency
Return

ResetWindows_Calendar:
	IniDelete, %ConfigFile%, %cal_ScriptName%, ViewPosX_TimeCalc
	IniDelete, %ConfigFile%, %cal_ScriptName%, ViewPosY_TimeCalc
	IniDelete, %ConfigFile%, %cal_ScriptName%, ViewPosX_12months
	IniDelete, %ConfigFile%, %cal_ScriptName%, ViewPosY_12months
	IniDelete, %ConfigFile%, %cal_ScriptName%, ViewPosX_6months
	IniDelete, %ConfigFile%, %cal_ScriptName%, ViewPosY_6months
	IniDelete, %ConfigFile%, %cal_ScriptName%, ViewPosX_3months
	IniDelete, %ConfigFile%, %cal_ScriptName%, ViewPosY_3months

	cal_guiPos_TC_X = %WorkAreaLeft%
	cal_guiPos_TC_Y = %WorkAreaTop%

	cal_guiPos_12m_X = %WorkAreaLeft%
	cal_guiPos_12m_Y = %WorkAreaTop%
	cal_guiPos_6m_X = %WorkAreaLeft%
	cal_guiPos_6m_Y = %WorkAreaTop%
	cal_guiPos_3m_X = %WorkAreaLeft%
	cal_guiPos_3m_Y = %WorkAreaTop%
Return

; Wird aufgerufen, wenn Einstellungen über das 'Pfeil'-Menü hinzugefügt werden, ist nur notwendig wenn AddSettings_Calendar = 1
AddSettings_Calendar:
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_Calendar:
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_Calendar:
	func_HotkeyEnable("cal_Hotkey_master")
	If Hotkey_cal_Hotkey_master =
	{
		func_HotkeyEnable("cal_Hotkey_timeCalc")
		func_HotkeyEnable("cal_Hotkey_12months")
		func_HotkeyEnable("cal_Hotkey_6months")
		func_HotkeyEnable("cal_Hotkey_3months")
	}
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern der Einstellungen aufgerufen
DoDisable_Calendar:
	func_HotkeyDisable("cal_Hotkey_master")
	If Hotkey_cal_Hotkey_master !=
	{
		func_HotkeyDisable("cal_Hotkey_timeCalc")
		func_HotkeyDisable("cal_Hotkey_12months")
		func_HotkeyDisable("cal_Hotkey_6months")
		func_HotkeyDisable("cal_Hotkey_3months")
	}
Return

; wird aufgerufen, wenn der Anwender die Erweiterung auf die Standard-Einstellungen zurücksetzt
DefaultSettings_Calendar:
Return

; wird aufgerufen, wenn ac'tivAid beendet oder neu geladen wird.
OnExitAndReload_Calendar:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel

cal_Hotkey_master:
	cal_matchKeys = ,
	cal_si_subtext =

	If Hotkey_cal_Hotkey_12months !=
	{
		cal_matchKeys = %cal_matchKeys%%Hotkey_cal_Hotkey_12months%,
		cal_si_subtext = %cal_si_subtext%`n%Hotkey_cal_Hotkey_12months% - %lng_cal_hk_12months%`n
	}
	If Hotkey_cal_Hotkey_6months !=
	{
		cal_matchKeys = %cal_matchKeys%%Hotkey_cal_Hotkey_6months%,
		cal_si_subtext = %cal_si_subtext%`n%Hotkey_cal_Hotkey_6months% - %lng_cal_hk_6months%`n
	}
	If Hotkey_cal_Hotkey_3months !=
	{
		cal_matchKeys = %cal_matchKeys%%Hotkey_cal_Hotkey_3months%,
		cal_si_subtext = %cal_si_subtext%`n%Hotkey_cal_Hotkey_3months% - %lng_cal_hk_3months%`n
	}
	If Hotkey_cal_Hotkey_timeCalc !=
	{
		cal_matchKeys = %cal_matchKeys%%Hotkey_cal_Hotkey_timeCalc%,
		cal_si_subtext = %cal_si_subtext%`n%Hotkey_cal_Hotkey_timeCalc% - %lng_cal_hk_timeCalc%`n
	}

	If (cal_secondHK_showWindow = 1) {
		cal_si_maintext = %lng_cal_winTitle_cal%`n__________________________________

		Suspend, On
		SplashImage, ,C01 CWeeeeee b1 FS9 WS700 WM600 ZY7 W160, %cal_si_subtext%, %cal_si_maintext%
		Input, selectorKey, L1 T%cal_secondHK_timeout%, ,%cal_matchKeys%
		SplashImage, Off
		Suspend, Off
	} Else {
		Input, selectorKey, L1 T%cal_secondHK_timeout%, ,%cal_matchKeys%
	}

	If (ERRORLEVEL = "Match") {
		If (selectorKey = Hotkey_cal_Hotkey_12months)
			Gosub, cal_Hotkey_12months
		If (selectorKey = Hotkey_cal_Hotkey_6months)
			Gosub, cal_Hotkey_6months
		If (selectorKey = Hotkey_cal_Hotkey_3months)
			Gosub, cal_Hotkey_3months
		If (selectorKey = Hotkey_cal_Hotkey_timeCalc)
			Gosub, cal_Hotkey_timeCalc
	}
	SplashImage, Off
Return

cal_sub_NOP:
Return

; Calls the time calculator
cal_Hotkey_timeCalc:
	If (cal_TimeCalcViewOpen = 0) {
		cal_TimeCalcViewOpen = 1
		cal_tc_renderVertical = 0
		cal_TimeCalcViewPos = X%cal_guiPos_tc_X% Y%cal_guiPos_tc_Y%
		Gosub, cal_sub_GUI_TimeCalc
	} Else {
		Gosub, TimeCalcGuiClose
	}
Return

; Calls the calender overview (12 months)
cal_Hotkey_12months:
	If (cal_CalenderViewOpen != 1) {
		Gosub, CalendarGuiClose
		cal_CalenderViewOpen = 1
		If (cal_vf_12m_group = 1) {
			cal_tc_renderVertical = 0
			cal_CalenderBtnOpts = %cal_CalenderBtnOptsHorizontal%
			cal_CalenderDdlOpts = %cal_CalenderDdlOptsHorizontal%
			cal_CalendarViewOpts = R6 W-2
		}
		Else If (cal_vf_12m_group = 2) {
			cal_tc_renderVertical = 0
			cal_CalenderBtnOpts = %cal_CalenderBtnOptsHorizontal%
			cal_CalenderDdlOpts = %cal_CalenderDdlOptsHorizontal%
			cal_CalendarViewOpts = R2 W-6
		}
		Else If (cal_vf_12m_group = 3) {
			cal_tc_renderVertical = 0
			cal_CalenderBtnOpts = %cal_CalenderBtnOptsHorizontal%
			cal_CalenderDdlOpts = %cal_CalenderDdlOptsHorizontal%
			cal_CalendarViewOpts = R4 W-3
		}
		Else If (cal_vf_12m_group = 4) {
			cal_tc_renderVertical = 0
			cal_CalenderBtnOpts = %cal_CalenderBtnOptsHorizontal%
			cal_CalenderDdlOpts = %cal_CalenderDdlOptsHorizontal%
			cal_CalendarViewOpts = R3 W-4
		}

		cal_CalendarViewPos = X%cal_guiPos_12m_X% Y%cal_guiPos_12m_Y%
		cal_FontSizeIdx    = %cal_FontSizeIdx_12m%
		cal_FontWeight = %cal_FontWeight_12m%

		Gosub, cal_sub_GUI_Calendar
	} Else {
		Gosub, CalendarGuiClose
	}
Return

; Calls the calender overview (6 months)
cal_Hotkey_6months:
	If (cal_CalenderViewOpen != 2) {
		Gosub, CalendarGuiClose
		cal_CalenderViewOpen = 2
		If (cal_vf_6m_group = 1) {
			cal_tc_renderVertical = 1
			cal_CalenderBtnOpts = %cal_CalenderBtnOptsVertical%
			cal_CalenderDdlOpts = %cal_CalenderDdlOptsVertical%
			cal_CalendarViewOpts = R6 W-1
		}
		Else If (cal_vf_6m_group = 2) {
			cal_tc_renderVertical = 0
			cal_CalenderBtnOpts = %cal_CalenderBtnOptsHorizontal%
			cal_CalenderDdlOpts = %cal_CalenderDdlOptsHorizontal%
			cal_CalendarViewOpts = R1 W-6
		}
		Else If (cal_vf_6m_group = 3) {
			cal_tc_renderVertical = 0
			cal_CalenderBtnOpts = %cal_CalenderBtnOptsHorizontal%
			cal_CalenderDdlOpts = %cal_CalenderDdlOptsHorizontal%
			cal_CalendarViewOpts = R2 W-3
		}
		Else If (cal_vf_6m_group = 4) {
			cal_tc_renderVertical = 0
			cal_CalenderBtnOpts = %cal_CalenderBtnOptsHorizontal%
			cal_CalenderDdlOpts = %cal_CalenderDdlOptsHorizontal%
			cal_CalendarViewOpts = R3 W-2
		}

		cal_CalendarViewPos = X%cal_guiPos_6m_X% Y%cal_guiPos_6m_Y%
		cal_FontSizeIdx    = %cal_FontSizeIdx_6m%
		cal_FontWeight = %cal_FontWeight_6m%

		Gosub, cal_sub_GUI_Calendar
	} Else {
		Gosub, CalendarGuiClose
	}
Return

; Calls the calender overview (3 months)
cal_Hotkey_3months:
	If (cal_CalenderViewOpen != 3) {
		Gosub, CalendarGuiClose
		cal_CalenderViewOpen = 3
		If (cal_vf_3m_group = 1) {
			cal_tc_renderVertical = 1
			cal_CalenderBtnOpts = %cal_CalenderBtnOptsVertical%
			cal_CalenderDdlOpts = %cal_CalenderDdlOptsVertical%
			cal_CalendarViewOpts = R3 W-1
		}
		Else If (cal_vf_3m_group = 2) {
			cal_tc_renderVertical = 0
			cal_CalenderBtnOpts = %cal_CalenderBtnOptsHorizontal%
			cal_CalenderDdlOpts = %cal_CalenderDdlOptsHorizontal%
			cal_CalendarViewOpts = R1 W-3
		}

		cal_CalendarViewPos = X%cal_guiPos_3m_X% Y%cal_guiPos_3m_Y%
		cal_FontSizeIdx    = %cal_FontSizeIdx_3m%
		cal_FontWeight = %cal_FontWeight_3m%

		If (cal_showMonthCentered = 1) {
			cal_showDate := A_MM - 1
			If cal_showDate = 0
					cal_showDate := 12
				Else If cal_showDate < 10
					cal_showDate := "0" . cal_showDate

				cal_showDate := A_YYYY . cal_showDate . "010000"
		}
		Else
		{
			cal_showDate =
		}

		Gosub, cal_sub_GUI_Calendar
	} Else {
		Gosub, CalendarGuiClose
	}
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

; Rendering of the time calculator view
cal_sub_GUI_TimeCalc:
	GuiDefault("TimeCalc")
	Gui, -Resize
	; We need this dummy to correctly set the controls following (because they are
	; positioned with respect to their parent control)
	Gui, Add, Text, x+-5 y-15,
	Gosub, cal_sub_GUI_TimeCalc_Inline

	Gui, Show, AutoSize Restore %cal_TimeCalcViewPos%, %lng_cal_winTitle_tc%
	WinGet, cal_TC_GUI_ID, ID, A

	If cal_AlwaysOnTop = 1
		WinSet, AlwaysOnTop, On, ahk_id %cal_TC_GUI_ID%
	WinSet, Transparent, %cal_Transparency%, ahk_id %cal_TC_GUI_ID%

	If cal_CloseNoFocus = 1
	{
		WinWaitNotActive, ahk_id %cal_TC_GUI_ID%
		If cal_TC_GUI_ID <>
			Gosub, TimeCalcGuiClose
	}
Return

; Rendering of the calendar view
cal_sub_GUI_Calendar:
	GuiDefault("Calendar")
	Gui, -Resize
	; Font settings for the month control
	cal_FontOptions = wNorm
	If cal_FontWeight = 1
		cal_FontOptions = wBold
	cal_FSize := cal_FontSize%cal_FontSizeIdx%
	cal_FontOptions = %cal_FontOptions% s%cal_FSize%
	Gui, Font, %cal_FontOptions%,
	Gui, Add, MonthCal, AltSubmit 4 %cal_CalendarViewOpts% vcal_CalendarView gcal_sub_Cal_MouseEvent, %cal_showDate%
	GuiControl, , cal_CalendarView, %A_NOW%
	; Switch back to default font settings
	Gui, Font
	Gui, Add, Button, %cal_CalenderBtnOpts% vcal_CalenderDateSubmitBtn gcal_sub_submitDate
	Gui, Add, DropDownList, %cal_CalenderDdlOpts% AltSubmit Choose%cal_dateFormatIndex% vcal_CalenderDateFormatDdl gcal_sub_dateListChanged, %cal_DateFormatList%
	Gosub, cal_sub_dateListChanged

	; Add the time calculator if desired
	If (cal_showTcInCalView = 1)
		Gosub, cal_sub_GUI_TimeCalc_Inline

	Gui, Show, AutoSize Restore %cal_CalendarViewPos%, %lng_cal_winTitle_cal%
	WinGet, cal_Cal_GUI_ID, ID, A

	If cal_AlwaysOnTop = 1
		WinSet, AlwaysOnTop, On, ahk_id %cal_Cal_GUI_ID%
	WinSet, Transparent, %cal_Transparency%, ahk_id %cal_Cal_GUI_ID%

	; Jump only one month when hitting the scroll buttons
	If cal_stepByOneMonth = 1
	{
		ControlGet, cal_CalendarViewHWND, HWND, , SysMonthCal321, AHK_ID %cal_Cal_GUI_ID%
		SendMessage, 0x1014, 1, 0, , AHK_ID %cal_CalendarViewHWND%  ; 0x1014 is MCM_SETMONTHDELTA
	}

	; On hitting ENTER, set the default behavior to submit the date
	; Set the focus on the date button
	ControlFocus, cal_CalenderDateSubmitBtn
	; Work-around needed: step to the next control and back
	Send, {Tab}+{Tab}

	If cal_CloseNoFocus = 1
	{
		WinWaitNotActive, ahk_id %cal_Cal_GUI_ID%
		If cal_Cal_GUI_ID <>
			Gosub, CalendarGuiClose
	}
Return

; The event is fired everytime the user clicks on a new date
cal_sub_Cal_MouseEvent:
	If (A_GuiControlEvent != "Normal") {
		Gosub, cal_sub_UpdateDate
	}
;  MsgBox, A_GuiControlEvent: %A_GuiControlEvent%`nA_GuiControl: %A_GuiControl%`nValue: %cal_CalendarView%
Return

; Whenever the selected date or the date format changes, refresh settings and controls
cal_sub_UpdateDate:
	GuiControlGet, cal_dateString, , cal_CalendarView
	FormatTime, cal_dateString, %cal_dateString%, % cal_dateFormat_%cal_dateFormatIndex%
	GuiControl, , cal_CalenderDateSubmitBtn, %cal_dateString%
Return

; The user selected another date format
cal_sub_dateListChanged:
	GuiControlGet, cal_dateFormatIndex, , cal_CalenderDateFormatDdl
	IniWrite, %cal_dateFormatIndex%, %ConfigFile%, %cal_ScriptName%, DateFormatIndex
	Gosub, cal_sub_UpdateDate
Return

; Rendering of the time calculator
; At the moment, no settings are stored - the rendering comes up with hard coded
; default values
cal_sub_GUI_TimeCalc_Inline:
	If (cal_tc_renderVertical) {
		Gui, Add, GroupBox, y+10 w168 h160 Section vcal_tc_groupbox, %lng_cal_tc_Header%

		Gui, Add, Text, xs+10 ys+20, %lng_cal_tc_startDate%
		Gui, Add, DateTime, y+5 w90 vcal_tc_startDate gcal_sub_tc_startDate
		Gui, Add, Radio, x+5 yp+4 vcal_tc_group_1 gcal_sub_tc_group_1, %lng_cal_tc_fixed%

		Gui, Add, Text, xs+10 y+10, %lng_cal_tc_diffDays%
		Gui, Add, Edit, y+5 w90 vcal_tc_diffDays gcal_sub_tc_diffDays Limit7
		Gui, Add, UpDown, vcal_tc_diffDays_ud Range-100000-100000, 0
		Gui, Add, Radio, x+5 yp+4 vcal_tc_group_2 gcal_sub_tc_group_2, %lng_cal_tc_fixed%

		Gui, Add, Text, xs+10 y+10, %lng_cal_tc_endDate%
		Gui, Add, DateTime, y+5 w90 vcal_tc_endDate gcal_sub_tc_endDate
		Gui, Add, Radio, x+5 yp+4 vcal_tc_group_3 gcal_sub_tc_group_3, %lng_cal_tc_fixed%
	} Else {
		Gui, Add, GroupBox, xs+5 y+10 w330 h90 Section, %lng_cal_tc_Header%

		Gui, Add, Text, xs+10 ys+20 vcal_tc_txt1, %lng_cal_tc_startDate%
		cal_func_CenterGuiControl("cal_tc_txt1", 90)
		Gui, Add, DateTime, y+5 w90 vcal_tc_startDate gcal_sub_tc_startDate
		Gui, Add, Radio, y+5 vcal_tc_group_1 gcal_sub_tc_group_1, %lng_cal_tc_fixed%
		cal_func_CenterGuiControl("cal_tc_group_1", 90)

		Gui, Add, Text, xs+120 ys+20 vcal_tc_txt2, %lng_cal_tc_diffDays%
		cal_func_CenterGuiControl("cal_tc_txt2", 90)
		Gui, Add, Edit, y+5 w90 vcal_tc_diffDays gcal_sub_tc_diffDays Limit7
		Gui, Add, UpDown, vcal_tc_diffDays_ud Range-100000-100000, 0
		Gui, Add, Radio, y+5 vcal_tc_group_2 gcal_sub_tc_group_2, %lng_cal_tc_fixed%
		cal_func_CenterGuiControl("cal_tc_group_2", 90)

		Gui, Add, Text, xs+230 ys+20 vcal_tc_txt3, %lng_cal_tc_endDate%
		cal_func_CenterGuiControl("cal_tc_txt3", 90)
		Gui, Add, DateTime, y+5 w90 vcal_tc_endDate gcal_sub_tc_endDate
		Gui, Add, Radio, y+5 vcal_tc_group_3 gcal_sub_tc_group_3, %lng_cal_tc_fixed%
		cal_func_CenterGuiControl("cal_tc_group_3", 90)
	}

	; Set the state of the radio buttons and enable/disable the associated control(s)
	Gosub, cal_sub_tc_group_%cal_tc_groupIndex%
Return

; Is performed when the user changes the start date field
cal_sub_tc_startDate:
	GuiControlGet, cal_startDate, , cal_tc_startDate
	FormatTime, cal_startDate, %cal_startDate%, yyyyMMdd

	; If the diffDays are the result, calculate it
	If (cal_tc_group_2 = 1) {
		GuiControlGet, cal_endDate, , cal_tc_endDate
		FormatTime, cal_endDate, %cal_endDate%, yyyyMMdd
		cal_endDate -= cal_startDate, Days
		GuiControl, , cal_tc_diffDays, %cal_endDate%
	} Else
	; If the end date is the result, calculate it
	If (cal_tc_group_3 = 1) {
		GuiControlGet, cal_diffDays, , cal_tc_diffDays
		cal_startDate += %cal_diffDays%, Days
		GuiControl, , cal_tc_endDate, %cal_startDate%
	}
Return

; Is performed when the user changes the days difference
cal_sub_tc_diffDays:
	GuiControlGet, cal_diffDays, , cal_tc_diffDays
	; Workaround for number higher than 999:
	StringReplace, cal_diffDays, cal_diffDays, ., , All
	StringReplace, cal_diffDays, cal_diffDays, `,, , All

	; If the start date is the result, calculate it
	If (cal_tc_group_1 = 1) {
		GuiControlGet, cal_endDate, , cal_tc_endDate
		FormatTime, cal_endDate, %cal_endDate%, yyyyMMdd
		cal_endDate += -cal_diffDays, Days
		GuiControl, , cal_tc_startDate, %cal_endDate%
	} Else
	; If the end date the result, calculate it
	If (cal_tc_group_3 = 1) {
		GuiControlGet, cal_startDate, , cal_tc_startDate
		FormatTime, cal_startDate, %cal_startDate%, yyyyMMdd
		cal_startDate += cal_diffDays, Days
		GuiControl, , cal_tc_endDate, %cal_startDate%
	}
Return

; Is performed when the user changes the end date field
cal_sub_tc_endDate:
	GuiControlGet, cal_endDate, , cal_tc_endDate
	FormatTime, cal_endDate, %cal_endDate%, yyyyMMdd

	; If the diffDays are the result, calculate it
	If (cal_tc_group_2 = 1) {
		GuiControlGet, cal_startDate, , cal_tc_startDate
		FormatTime, cal_startDate, %cal_startDate%, yyyyMMdd
		cal_endDate -= cal_startDate, Days
		GuiControl, , cal_tc_diffDays, %cal_endDate%
	} Else
	; If the start date is the result, calculate it
	If (cal_tc_group_1 = 1) {
		GuiControlGet, cal_diffDays, , cal_tc_diffDays
		cal_diffDays := -cal_diffDays
		cal_endDate += %cal_diffDays%, Days
		GuiControl, , cal_tc_startDate, %cal_endDate%
	}
Return

; Making the start date fixed, releasing the other(s)
cal_sub_tc_group_1:
	GuiControlGet, cal_tc_group_1, , cal_tc_group_1
	GuiControl, Disable, cal_tc_startDate
	GuiControl, Enable, cal_tc_diffDays
	GuiControl, Enable, cal_tc_diffDays_ud
	GuiControl, Enable, cal_tc_endDate
	cal_tc_group_1 = 1
	cal_tc_group_2 = 0
	cal_tc_group_3 = 0
	GuiControl, , cal_tc_group_1, %cal_tc_group_1%
	GuiControl, , cal_tc_group_2, %cal_tc_group_2%
	GuiControl, , cal_tc_group_3, %cal_tc_group_3%
	cal_tc_groupIndex = 1
Return

; Making the days difference fixed, releasing the other(s)
cal_sub_tc_group_2:
	GuiControlGet, cal_tc_group_2, , cal_tc_group_2
	GuiControl, Enable, cal_tc_startDate
	GuiControl, Disable, cal_tc_diffDays
	GuiControl, Disable, cal_tc_diffDays_ud
	GuiControl, Enable, cal_tc_endDate
	cal_tc_group_1 = 0
	cal_tc_group_2 = 1
	cal_tc_group_3 = 0
	GuiControl, , cal_tc_group_1, %cal_tc_group_1%
	GuiControl, , cal_tc_group_2, %cal_tc_group_2%
	GuiControl, , cal_tc_group_3, %cal_tc_group_3%
	cal_tc_groupIndex = 2
Return

; Making the end date fixed, releasing the other(s)
cal_sub_tc_group_3:
	GuiControlGet, cal_tc_group_3, , cal_tc_group_3
	GuiControl, Enable, cal_tc_startDate
	GuiControl, Enable, cal_tc_diffDays
	GuiControl, Enable, cal_tc_diffDays_ud
	GuiControl, Disable, cal_tc_endDate
	cal_tc_group_1 = 0
	cal_tc_group_2 = 0
	cal_tc_group_3 = 1
	GuiControl, , cal_tc_group_1, %cal_tc_group_1%
	GuiControl, , cal_tc_group_2, %cal_tc_group_2%
	GuiControl, , cal_tc_group_3, %cal_tc_group_3%
	cal_tc_groupIndex = 3
Return

; Paste the selected date into the last active application
cal_sub_submitDate:
	If cal_CloseNoFocus = 1
		Gosub, CalendarGuiClose
	Else
		SendInput, !{Tab} ; Switch to last active window

	If (cal_CopyToClipBoard1 = 1 OR cal_CopyToClipBoard2 = 1)
		Clipboard = %cal_dateString%
	If cal_CopyToClipBoard2 = 0
		SendRaw, %cal_dateString%
Return

; Safely close the calendar window and store its position
CalendarGuiClose:
CalendarGuiEscape:
	; Save the current calculation setting, no matter if the day calculator
	; is shown in the calendar view
	IniWrite, %cal_tc_groupIndex%,  %ConfigFile%, %cal_ScriptName%, TimeCalcFixedField

	; Get the GUI´s position
	WinGet, cal_MinMax, MinMax, ahk_id %cal_Cal_GUI_ID%
	If cal_MinMax <> -1
	{
		WinGetPos, cal_posX, cal_posY, , , ahk_id %cal_Cal_GUI_ID%
		; Save the current GUI position
		If (cal_posX) If (cal_posY) {
			If (cal_CalenderViewOpen = 1) {
				IniWrite, %cal_posX%,  %ConfigFile%, %cal_ScriptName%, ViewPosX_12months
				IniWrite, %cal_posY%,  %ConfigFile%, %cal_ScriptName%, ViewPosY_12months
				cal_guiPos_12m_X = %cal_posX%
				cal_guiPos_12m_Y = %cal_posY%
			} Else If (cal_CalenderViewOpen = 2) {
				IniWrite, %cal_posX%,  %ConfigFile%, %cal_ScriptName%, ViewPosX_6months
				IniWrite, %cal_posY%,  %ConfigFile%, %cal_ScriptName%, ViewPosY_6months
				cal_guiPos_6m_X = %cal_posX%
				cal_guiPos_6m_Y = %cal_posY%
			} Else If (cal_CalenderViewOpen = 3) {
				IniWrite, %cal_posX%,  %ConfigFile%, %cal_ScriptName%, ViewPosX_3months
				IniWrite, %cal_posY%,  %ConfigFile%, %cal_ScriptName%, ViewPosY_3months
				cal_guiPos_3m_X = %cal_posX%
				cal_guiPos_3m_Y = %cal_posY%
			}
		}
	}

	GuiDefault("Calendar")
	Gui, Destroy
	cal_CalenderViewOpen = 0
Return

; Safely close the time calculator window and store its position
TimeCalcGuiClose:
TimeCalcGuiEscape:
	; Save the current calculation setting
	IniWrite, %cal_tc_groupIndex%,  %ConfigFile%, %cal_ScriptName%, TimeCalcFixedField

	; Get the GUI´s position
	WinGetPos, cal_posX, cal_posY, , , ahk_id %cal_TC_GUI_ID%
	; Save the current GUI position
	If (cal_posX) If (cal_posY) {
		If (cal_TimeCalcViewOpen = 1) {
			IniWrite, %cal_posX%,  %ConfigFile%, %cal_ScriptName%, ViewPosX_TimeCalc
			IniWrite, %cal_posY%,  %ConfigFile%, %cal_ScriptName%, ViewPosY_TimeCalc
			cal_guiPos_TC_X = %cal_posX%
			cal_guiPos_TC_Y = %cal_posY%
		}
	}

	GuiDefault("TimeCalc")
	Gui, Destroy
	cal_TimeCalcViewOpen = 0
Return

; -----------------------------------------------------------------------------
; === Functions ===============================================================
; -----------------------------------------------------------------------------

; EyeCandy: center a control within the given width
; This is needed for combined controls like radio buttons with text, since just
; stating the keyword "Center" in the Gui, Add, ... command only centers the text
; but not the radio button itself...
cal_func_CenterGuiControl(myGuiCtrl, myWidth) {
	GuiControlGet, cal_tmp, Pos, %myGuiCtrl%
	cal_tmpx += (myWidth - cal_tmpw) / 2
	GuiControl, MoveDraw, %myGuiCtrl%, x%cal_tmpx%
	Return
}
