; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               CalculAid
; -----------------------------------------------------------------------------
; Prefix:             clq_
; Version:            0.4
; Date:               2007-11-22
; Author:             Eric Werner
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
;
; Öffnet mit einer markierten Zahl den Taschenrechner
; und fügt eine errechnete Zahl auf Wunsch ein.
;
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_CalculAid:
	Prefix = clq
	%Prefix%_ScriptName    = CalculAid
	%Prefix%_ScriptVersion = 0.4
	%Prefix%_Author        = Eric Werner
	CustomHotkey_CalculAid = 1    ; automatisches   benutzerdefinierbares Tastaturkürzel? (1 = ja)
	Hotkey_CalculAid       = ^!r  ; Standard-Hotkey
	HideSettings = 0              ; Wenn 1, dann bekommt die Erweiterung keinen Eintrag im Konfigurationsdialog
	EnableTray_CalculAid =        ; Soll eine Erweiterung nicht im Tray-Menü aufgeführt werden, muss der Wert   0 betragen

	IconFile_On_CalculAid = %A_WinDir%\system32\Calc.exe
	IconPos_On_CalculAid = 1

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407,  0807, 0c07 ...)
	{
	  ; Name des Menüeintrags im Tray-Menü
		MenuName                        = %clq_ScriptName% - Ausgewählte Zahl im Taschenrechner bearbeiten
		Description                     = Öffnet den Taschenrechner mit einer markierten Zahl, um diese dort zu bearbeiten.
		lng_clq_SwitchGroupChar         = Zifferntrennzeichen umkehren (von 1,000.00 zu 1.000,00 oder umgekehrt)
		lng_clq_SwitchGroupCharTip      = Wenn man z.B. eingestellt hat, Komma soll ein Punkt sein`nund man ist aber gerade auf einer deutschen Website...
		lng_clq_PlaceAtCursor           = Neuen Taschenrechner an Mauszeigerposition platzieren
		lng_clq_AlwaysOnTop             = Neuen Taschenrechner immer im Vordergrund halten
		lng_clq_NumberGroupingToggleTip = Zifferngruppierung umgeschaltet
		lng_clq_SwitchGroupCharONTip    = Zifferntrennzeichen umkehren : AN
		lng_clq_SwitchGroupCharOFFTip   = Zifferntrennzeichen umkehren : AUS
		lng_clq_ExtraCloseKeys          = -  Rechner schließen
		lng_clq_EscCloseTip             = Um den Rechner besonders schnell loszuwerden.`nAber: Esc ist auch der Standard-Hotkey um den kompletten Rechenweg zu löschen!
		lng_clq_CtrlWClose              = Strg + w
		lng_clq_CtrlWCloseTip           = Strg + w ist ein Standard-Hotkey zum Fenster schließen`nund besser erreichbar als z.B. Alt+F4.
		lng_clq_DelToC                  = "Entf"-Taste  -  löscht gesamten Rechenweg (C)
		lng_clq_DelToCTip               = Normaler Weise löscht "Entf" nur die aktuelle Zahl (CE).
		lng_clq_Placement               = Anordnung:
		lng_clq_ExtraKeys               = Zusätzliche Hotkeys im Rechner:
		lng_clq_TabSwitch               = Tab  -  normale / wissenschaftliche Ansicht
		lng_clq_ToggleNumberGrouping    = G  -  Zifferngruppierung An/Aus
		lng_clq_ToggleSwitchGroupChar   = Strg+G  -  Zifferntrennzeichen umkehren An/Aus
		lng_clq_CtrlReturn              = Strg+Enter  -  Ergebnis abschicken
	}
	else     ; =   Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
	  MenuName = %clq_ScriptName% - Edit a selected number in the calculator.
	  Description = Opens up the calculator with a selected   number to edit it.
	  lng_clq_SwitchGroupChar = switch numbergrouping characters (from 1,000.00 to 1.000,0 or vice versa)
	  lng_clq_SwitchGroupCharTip = If you for example set comma for a dot`nand you are occasionally on a website where its the opposite way...
	  lng_clq_PlaceAtCursor = Place new calculator at cursor position
	  lng_clq_AlwaysOnTop = Make new calculator Always On Top
	  lng_clq_NumberGroupingToggleTip = numbergrouping toggled
	  lng_clq_SwitchGroupCharONTip = switch numbergrouping characters : ON
	  lng_clq_SwitchGroupCharOFFTip = switch numbergrouping characters : OFF
	  lng_clq_ExtraCloseKeys = -  close the calculator
	  lng_clq_EscCloseTip = To get rid of the calculator the fastest way.`nBut: Esc is the standard Hotkey for clearing the whole calculation as well!
	  lng_clq_CtrlWClose = Ctrl + w
	  lng_clq_CtrlWCloseTip = Ctrl + w is a standard Hotkey for closing documents.`nIts more accessible than Alt+F4 für instace.
	  lng_clq_DelToC = "Del" key  -  deletes the whole calculation (C)
	  lng_clq_DelToCTip = Usually "Del" deletes only the currently entered value, not all (CE)
	  lng_clq_Placement = placement:
	  lng_clq_ExtraKeys = extra hotkeys in the calculator:
	  lng_clq_TabSwitch = Tab  -  simple / scientific view
	  lng_clq_ToggleNumberGrouping = G  -  turn numbergrouping On/Off
	  lng_clq_ToggleSwitchGroupChar = Ctrl+G  -  turn switch numbergrouping characters On/Off
	  lng_clq_CtrlReturn = Ctrl+Enter  -  submit conclusion
	}

	; Settings holen
	IniRead, clq_SwitchGroupChar, %ConfigFile%, CalculAid, SwitchGroupChar, 0
	IniRead, clq_PlaceAtCursor, %ConfigFile%, CalculAid, PlaceAtCursor, 0
	IniRead, clq_AlwaysOnTop, %ConfigFile%, CalculAid, AlwaysOnTop, 0
	IniRead, clq_EscClose, %ConfigFile%, CalculAid, EscClose, 0
	IniRead, clq_CtrlWClose, %ConfigFile%, CalculAid, CtrlWClose, 1
	IniRead, clq_DelToC, %ConfigFile%, CalculAid, DelToC, 0

	tooltip_clq_SwitchGroupChar = %lng_clq_SwitchGroupCharTip%
	tooltip_clq_EscClose = %lng_clq_EscCloseTip%
	tooltip_clq_CtrlWClose = %lng_clq_CtrlWCloseTip%
	tooltip_clq_DelToC = %lng_clq_DelToCTip%

	func_HotkeyRead( "clq_EscClose", ConfigFile , CalculAid, "Escape", "clq_sub_CloseCalc", "Esc", "$", "ahk_class SciCalc" )
	func_HotkeyRead( "clq_CtrlWClose", ConfigFile , CalculAid, "^w", "clq_sub_CloseCalc", "^w", "$", "ahk_class SciCalc" )
	func_HotkeyRead( "clq_CtrlReturn", ConfigFile , CalculAid, "CtrlReturn", "clq_sub_CtrlReturn", "^Return", "$", "ahk_class SciCalc" )
	func_HotkeyRead( "clq_Tab", ConfigFile , CalculAid, "Tab", "clq_sub_Tab", "Tab", "$", "ahk_class SciCalc" )
	func_HotkeyRead( "clq_ToggleGrouping", ConfigFile , CalculAid, "g", "clq_sub_ToggleGrouping", "g", "$", "ahk_class SciCalc" )
	func_HotkeyRead( "clq_ToggleGroupingConvert", ConfigFile , CalculAid, "^g", "clq_sub_ToggleGroupingConvert", "^g", "$", "ahk_class SciCalc" )
	func_HotkeyRead( "clq_SwitchWhenPaste", ConfigFile , CalculAid, "^v", "clq_sub_SwitchWhenPaste", "^v", "$", "ahk_class SciCalc" )
	func_HotkeyRead( "clq_DelToC", ConfigFile , CalculAid, "Delete", "clq_sub_DelToC", "Delete", "$", "ahk_class SciCalc" )
Return

SettingsGui_CalculAid:
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+20 y+8 vclq_SwitchGroupChar Checked%clq_SwitchGroupChar%, %lng_clq_SwitchGroupChar%
	Gui, Add, GroupBox, xs+10 yp+20 w550 h65, %lng_clq_Placement%
		Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xp+10 yp+20 vclq_PlaceAtCursor Checked%clq_PlaceAtCursor%, %lng_clq_PlaceAtCursor%
		Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xp yp+20 vclq_AlwaysOnTop Checked%clq_AlwaysOnTop%, %lng_clq_AlwaysOnTop%
	Gui, Add, GroupBox, xs+10 yp+30 w550 h110, %lng_clq_ExtraKeys%
		Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+20 yp+20 vclq_EscClose Checked%clq_EscClose%, Escape (Esc)
		Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xp yp+20 vclq_CtrlWClose Checked%clq_CtrlWClose%, %lng_clq_CtrlWClose%
		Gui, Add, Text, -Wrap xp+100 yp-10, %lng_clq_ExtraCloseKeys%
		Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+20 yp+35 vclq_DelToC Checked%clq_DelToC%, %lng_clq_DelToC%
		Gui, Add, Text, -Wrap xs+290 yp-45, %lng_clq_CtrlReturn%
		Gui, Add, Text, -Wrap xp yp+20, %lng_clq_TabSwitch%
		Gui, Add, Text, -Wrap xp yp+20, %lng_clq_ToggleNumberGrouping%
		Gui, Add, Text, -Wrap xp yp+20, %lng_clq_ToggleSwitchGroupChar%
Return

; wird aufgerufen, wenn im Konfigurationsdialog OK oder  Übernehmen angeklickt wird
SaveSettings_CalculAid:
	IniWrite, %clq_SwitchGroupChar%, %ConfigFile%, CalculAid, SwitchGroupChar
	IniWrite, %clq_PlaceAtCursor%, %ConfigFile%, CalculAid, PlaceAtCursor
	IniWrite, %clq_AlwaysOnTop%, %ConfigFile%, CalculAid, AlwaysOnTop
	IniWrite, %clq_EscClose%, %ConfigFile%, CalculAid, EscClose
	IniWrite, %clq_CtrlWClose%, %ConfigFile%, CalculAid, CtrlWClose
	IniWrite, %clq_DelToC%, %ConfigFile%, CalculAid, DelToC
Return

; Wird aufgerufen, wenn Einstellungen über das 'Pfeil'-Menü hinzugefügt werden,  ist   nur   notwendig wenn AddSettings_CalculAid = 1
AddSettings_CalculAid:
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_CalculAid:
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_CalculAid:
	If clq_EscClose
		func_HotkeyEnable("clq_EscClose")
	If clq_CtrlWClose
		func_HotkeyEnable("clq_CtrlWClose")
	If clq_DelToC
		func_HotkeyEnable("clq_DelToC")
	func_HotkeyEnable("clq_CtrlReturn")
	func_HotkeyEnable("clq_Tab")
	func_HotkeyEnable("clq_ToggleGrouping")
	func_HotkeyEnable("clq_ToggleGroupingConvert")
	func_HotkeyEnable("clq_SwitchWhenPaste")
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern  der   Einstellungen aufgerufen
DoDisable_CalculAid:
	If clq_EscClose
		func_HotkeyDisable("clq_EscClose")
	If clq_CtrlWClose
		func_HotkeyDisable("clq_CtrlWClose")
	If clq_DelToC
		func_HotkeyDisable("clq_DelToC")
	func_HotkeyDisable("clq_CtrlReturn")
	func_HotkeyDisable("clq_Tab")
	func_HotkeyDisable("clq_ToggleGrouping")
	func_HotkeyDisable("clq_ToggleGroupingConvert")
	func_HotkeyDisable("clq_SwitchWhenPaste")
Return

; wird aufgerufen, wenn der   Anwender die Erweiterung auf die Standard-Einstellungen  zurücksetzt
DefaultSettings_CalculAid:
Return

; wird aufgerufen, wenn ac'tivAid beendet oder neu geladen wird.
OnExitAndReload_CalculAid:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_CalculAid:
	func_GetSelection()

	RegExMatch(Selection, "[0-9.,+/*=-]+", clq_numbersOnly)
	; calc.exe starten wenn NUR Zahlen ausgewählt sind 12321+123=
	If ((clq_numbersOnly = Selection) && (clq_numbersOnly <> ""))
	{
		If clq_SwitchGroupChar
		{
			StringReplace, clq_numbersOnly, clq_numbersOnly, ., K, All
			StringReplace, clq_numbersOnly, clq_numbersOnly, `,, ., All
			StringReplace, clq_numbersOnly, clq_numbersOnly, K, `,, All
		}

		clq_tmpClipBoard := ClipBoardAll
		ClipBoard = %clq_numbersOnly%

		Run, calc.exe,, UseErrorLevel, clq_CalcPID
		If ErrorLevel =   ERROR
			func_GetErrorMessage( A_LastError, ScriptTitle, """Calc.exe""`n")
		Else
		{
			WinWait  ahk_pid  %clq_CalcPID%
			IfWinNotActive,   ahk_pid  %clq_CalcPID%
			{
				WinActivate, ahk_pid %clq_CalcPID%
				WinWaitActive, ahk_pid %clq_CalcPID%
			}

			If (aa_osversionnumber >= aa_osversionnumber_vista)
				Send ^v
			Else
				SendPlay ^v
		}
		Sleep, 50
		ClipBoard := clq_tmpClipBoard
	}
	Else ; ansonsten nur so den rechner öffnen
		Run, calc.exe,, UseErrorLevel, clq_CalcPID

	If clq_PlaceAtCursor
	{
		WinWait  ahk_pid %clq_CalcPID%
		CoordMode, Mouse, Screen
		MouseGetPos, clq_mousex, clq_mousey
		;position the windowtitle under the cursor so one can move it instantly:
		WinMove, (clq_mousex - 30), (clq_mousey - 10)
	}

	If clq_AlwaysOnTop
	{
		WinWait, ahk_pid %clq_CalcPID%
		WinSet, AlwaysOnTop, On
	}
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------
;close calculator on Esc
clq_sub_CloseCalc:
	Send !{F4}
Return

;close calculator and send conclusion
clq_sub_CtrlReturn:
	func_GetSelection()
	Send, !{F4}
	WinWaitClose, ahk_id %clq_CalcPID%
	Send %Selection%
Return

;switch calculator from simple to scientific without loosing currently entered value
clq_sub_Tab:
	clq_tmpClipBoard := ClipBoardAll
	func_GetSelection()

	WinGet, clq_WindowID, ID, A
	WinGetPos,,, clq_Width,, A
	If (clq_Width < 300*(SystemDPI/96))
	{
		Send {Alt}{Right}{Down 2}{Enter}

		WinWait,ahk_pid %clq_CalcPID%, MC,1
	}
	Else
	{
		Send {Alt}{Right}{Down}{Enter}
		WinWait,ahk_pid %clq_CalcPID%, MC,1
	}

	;seems impossible to get this sane through IfWinNotActive, WinActivate... so just a sleep:
	Send %Selection%
	Sleep, 100
	ClipBoard := clq_tmpClipBoard
Return

clq_sub_ToggleGrouping:
	Send {Alt}{Right}{Up 2}{Enter}
	Tooltip, %lng_clq_NumberGroupingToggleTip%
	sleep, 1000
	Tooltip
Return

clq_sub_ToggleGroupingConvert:
	If clq_SwitchGroupChar
	{
		clq_SwitchGroupChar := 0
		IniWrite, 0, %ConfigFile%, CalculAid, SwitchGroupChar
		Tooltip, %lng_clq_SwitchGroupCharOFFTip%
	}
	Else
	{
		clq_SwitchGroupChar := 1
		IniWrite, 1, %ConfigFile%, CalculAid, SwitchGroupChar
		Tooltip, %lng_clq_SwitchGroupCharONTip%
	}
	GuiControl,, clq_SwitchGroupChar, %clq_SwitchGroupChar%
	sleep, 1500
	Tooltip
Return

clq_sub_SwitchWhenPaste:
	If clq_SwitchGroupChar
	{
		clq_tmpClipBoard := ClipBoard
		StringReplace, clq_tmpClipBoard, clq_tmpClipBoard, ., K, All
		StringReplace, clq_tmpClipBoard, clq_tmpClipBoard, `,, ., All
		StringReplace, clq_tmpClipBoard, clq_tmpClipBoard, K, `,, All
		SendPlay {Delete}%clq_tmpClipBoard%
	}
	Else
		SendPlay ^v
Return

clq_sub_DelToC:
	Send {Esc}
Return
