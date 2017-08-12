; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               PasteSerial
; -----------------------------------------------------------------------------
; Prefix:             ps
; Version:            0.1
; Date:               2007-01-18
; Author:             Alexander Taubenkorb
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_PasteSerial:

	Prefix = ps
	%Prefix%_ScriptName    = PasteSerial
	%Prefix%_ScriptVersion = 0.1
	%Prefix%_Author        = Alexander Taubenkorb
	CustomHotkey_PasteSerial = 1           ; automatisches benutzerdefinierbares Tastaturk�rzel? (1 = ja)
	Hotkey_PasteSerial       = #P          ; Standard-Hotkey

	HideSettings = 0                             ; Wenn 1, dann bekommt die Erweiterung keinen Eintrag im Konfigurationsdialog
	IconFile_On_PasteSerial  = %A_WinDir%\system32\shell32.dll
	IconPos_On_PasteSerial   = 134

	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %ps_ScriptName% - Einf�gen von Seriennummern
		Description                   = Seriennummern aus Zwischenablage ohne Bindestriche in Dialogfelder einf�gen
		lng_ps_UseTabs                = Bindestriche durch Tabulatoren ersetzen
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %ps_ScriptName% - Paste serials
		Description                   = Paste serials from clipboard without dashes into a dialog
		lng_ps_UseTabs                = Replaces dashes with tabs
	}

	IniRead, ps_UseTabs, %ConfigFile%, PasteSerial, UseTabs, 0
Return

SettingsGui_PasteSerial:
	Gui, Add, CheckBox, xs+10 y+10 -Wrap gsub_CheckIfSettingsChanged vps_UseTabs Checked%ps_UseTabs%, %lng_ps_UseTabs%
Return

; wird aufgerufen, wenn im Konfigurationsdialog OK oder �bernehmen angeklickt wird
SaveSettings_PasteSerial:
	IniWrite, %ps_UseTabs%, %ConfigFile%, PasteSerial, UseTabs
Return

; Wird aufgerufen, wenn Einstellungen �ber das 'Pfeil'-Men� hinzugef�gt werden, ist nur notwendig wenn AddSettings_PasteSerial = 1
AddSettings_PasteSerial:
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_PasteSerial:
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_PasteSerial:
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern der Einstellungen aufgerufen
DoDisable_PasteSerial:
Return

; wird aufgerufen, wenn der Anwender die Erweiterung auf die Standard-Einstellungen zur�cksetzt
DefaultSettings_PasteSerial:
Return

; wird aufgerufen, wenn ac'tivAid beendet oder neu geladen wird.
OnExitAndReload_PasteSerial:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine f�r das automatische Tastaturk�rzel
sub_Hotkey_PasteSerial:
	ps_serial = %clipboard%
	StringSplit, ps_serial_array, ps_serial, `-
	Loop, %ps_serial_array0%
	{
		 ps_current_part := ps_serial_array%a_index%
		 Send %ps_current_part%
		 If ps_UseTabs = 1
			 Send, %A_Tab%
	}
Return
