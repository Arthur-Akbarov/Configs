; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               MultiMonitor
; -----------------------------------------------------------------------------
; Prefix:             mm_
; Version:            1.5
; Date:               2008-05-23
; Author:             Elmar Sonnenschein, Jack Tissen, Michael Telgkamp
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_MultiMonitor:
	Prefix = mm
	%Prefix%_ScriptName    = MultiMonitor
	%Prefix%_ScriptVersion = 1.5
	%Prefix%_Author        = Elmar Sonnenschein, Jack Tissen, Michael Telgkamp
	RequireExtensions      =

	CustomHotkey_MultiMonitor =
	Hotkey_MultiMonitor       =
	HotkeyPrefix_MultiMonitor =

	HideSettings               = 0
	EnableTray_MultiMonitor   =
	DisableIfCompiled_MultiMonitor =

	IconFile_On_MultiMonitor = %A_WinDir%\system32\shell32.dll
	IconPos_On_MultiMonitor = 19

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %mm_ScriptName% - Tastenkürzel zum Verschieben von Fenstern auf andere Monitore
		Description                   = Erlaubt die Definition von Tastenkürzeln, um Fenster auf verschiedene Monitore zu verschieben

		lng_mm_MonKey = Fenster auf Monitor
		lng_mm_NextMon = Fenster auf nächsten Monitor
		lng_mm_PrevMon = Fenster auf vorherigen Monitor

		; Für GUI-Elemente sind auch automatische Tooltips möglich
		; tooltip_NAMEDESGUIELEMENTS   = Text
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %mm_ScriptName% - Shortcut to move windows to other monitors
		Description                   = Allows to define shortcuts that move windows to the available monitors

		lng_mm_MonKey  = Move window to monitor
		lng_mm_NextMon = Move window to next monitor
		lng_mm_PrevMon = Move window to previous monitor
	}

	; Aus der INI-Datei auslesen
	IniRead, mm_maxMonitors, %ConfigFile%, %mm_ScriptName%, maxMonitors, %NumOfMonitors%
	if ( NumOfMonitors > mm_maxMonitors )
	{
		IniWrite, %mm_maxMonitors%, %ConfigFile%, %mm_ScriptName%, maxMonitors
		mm_maxMonitors := NumOfMonitors
	}
	Loop, %mm_maxMonitors%
	{
		sKeyname = mm_Mon%A_Index%
		sIniname = Monitor%A_Index%
		sHotkey  = ; #+%A_Index%
		rMonitorFunction = mm_Monitor
		func_HotkeyRead( sKeyname, ConfigFile, mm_ScriptName, sIniname, rMonitorFunction, sHotkey, "$" )
		sHotkey =
	}
	func_HotkeyRead( "mm_NextMon", ConfigFile, mm_ScriptName, "NextMonitor", "mm_NextMonitor", "", "$" )
	func_HotkeyRead( "mm_PrevMon", ConfigFile, mm_ScriptName, "PrevMonitor", "mm_PrevMonitor", "", "$" )

Return

SettingsGui_MultiMonitor:
	Loop, %mm_maxMonitors%
	{
		sKeyname = mm_Mon%A_Index%
		lng_mm_thisMonKey := lng_mm_MonKey " " A_Index
		func_HotkeyAddGuiControl( lng_mm_thisMonKey, sKeyname, "xs+10 y+3 W200" )
		lng_mm_thisMonKey =
	}
	func_HotkeyAddGuiControl( lng_mm_NextMon, "mm_NextMon", "xs+10 y+3 W200" )
	func_HotkeyAddGuiControl( lng_mm_PrevMon, "mm_PrevMon", "xs+10 y+3 W200" )
Return

; wird aufgerufen, wenn im Konfigurationsdialog OK oder Übernehmen angeklickt wird
SaveSettings_MultiMonitor:
	IniWrite, %mm_maxMonitors%, %ConfigFile%, %mm_ScriptName%, maxMonitors
	Loop, %mm_maxMonitors%
	{
		sKeyname = mm_Mon%A_Index%
		sIniname = Monitor%A_Index%
		func_HotkeyWrite( sKeyname, ConfigFile, mm_ScriptName, sIniname )
	}
	func_HotkeyWrite( "mm_NextMon", ConfigFile, mm_ScriptName, "NextMonitor" )
	func_HotkeyWrite( "mm_PrevMon", ConfigFile, mm_ScriptName, "PrevMonitor" )
Return

; Wird aufgerufen, wenn Einstellungen über das 'Pfeil'-Menü hinzugefügt werden, ist nur notwendig wenn AddSettings_MultiMonitor = 1
AddSettings_MultiMonitor:
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_MultiMonitor:
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_MultiMonitor:
	Loop, %mm_maxMonitors%
	{
		sKeyname = mm_Mon%A_Index%
		func_HotkeyEnable(sKeyname)
	}
	func_HotkeyEnable("mm_NextMon")
	func_HotkeyEnable("mm_PrevMon")
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern der Einstellungen aufgerufen
DoDisable_MultiMonitor:
	Loop, %mm_maxMonitors%
	{
		sKeyname = mm_Mon%A_Index%
		func_HotkeyDisable(sKeyname)
	}
	func_HotkeyDisable("mm_NextMon")
	func_HotkeyDisable("mm_PrevMon")
Return

; wird aufgerufen, wenn der Anwender die Erweiterung auf die Standard-Einstellungen zurücksetzt
DefaultSettings_MultiMonitor:
Return

; wird aufgerufen, wenn ac'tivAid beendet oder neu geladen wird.
OnExitAndReload_MultiMonitor:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

mm_Monitor:
	;Get the last Hotkey
	PreHk = %A_ThisHotkey%
	;Remove the $ on beginning
	StringRight, PreHk, PreHk, StrLen(PreHK)-1
	;Get the Monitor Number from the Hotkey
	AktMon = 0
	Loop, %NumOfMonitors%
		If Hotkey_mm_Mon%A_Index% = %PreHk%
		{
			AktMon = %A_Index%
			break
		}
	;Move Window if Hotkey found
	If AktMon <> 0
		mm_moveToMonitor(AktMon)
Return

mm_NextMonitor:
	nNextMonitor := func_GetMonitorNumber("ActiveWindow") + 1
	if (nNextMonitor > NumOfMonitors)
		nNextMonitor = 1
	mm_moveToMonitor(nNextMonitor)
Return

mm_PrevMonitor:
	nPrevMonitor := func_GetMonitorNumber("ActiveWindow") - 1
	if (nPrevMonitor < 1)
		nPrevMonitor = %NumOfMonitors%
	mm_moveToMonitor(nPrevMonitor)
Return

; Function to switch a window to a destination monitor
mm_moveToMonitor(nDstMonitor)
{
	;GetSource Monitor
	nSrcMonitor := func_GetMonitorNumber("ActiveWindow")
	;Is Window Min/Maximized
	WinGet, IsMinMax, MinMax, A
	;If Window Minimized, restore First, then Ask again
	if IsMinMax = -1
	{
		WinRestore, A
		WinGet, IsMinMax, MinMax, A
	}
	;If Maximized, restore first
	if IsMinMax
		WinRestore, A
	;Get position on current monitor
	WinGetPos, nNewX, nNewY, , , A
	;Get relative Pos
	nRelX := (nNewX - Monitor%nSrcMonitor%Left) / Monitor%nSrcMonitor%Width
	nRelY := (nNewY - Monitor%nSrcMonitor%Top) / Monitor%nSrcMonitor%Height
	;Set new pos on dest Monitor
	nNewX := Round(Monitor%nDstMonitor%Width * nRelX) + Monitor%nDstMonitor%Left
	nNewY := Round(Monitor%nDstMonitor%Height * nRelY) + Monitor%nDstMonitor%Top
	;Move Window to the new Position

	WinMove, A,, %nNewX%, %nNewY%

	;If it was Maximized, maximize again
	if IsMinMax
		WinMaximize, A
}
