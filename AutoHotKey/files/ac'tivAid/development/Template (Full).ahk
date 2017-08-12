; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               NAMEDERERWEITERUNG
; -----------------------------------------------------------------------------
; Prefix:             NDE!_
; Version:            0.1
; Date:               2007-01-16
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_NAMEDERERWEITERUNG:

	; Folgende drei Variablen sind wichtig, damit die Erweiterung von ac'tivAid erkannt wird.
	; Die Variablennamen dürfen nicht verändert werden und dürfen keine Kommentare dahinter gesetzt werden.

	; * Das verwendete eindeutige Präfix ohne Unterstrich
	Prefix = NDE!
	; * Der Name der Erweiterung ohne Leerzeichen und Sonderzeichen
	%Prefix%_ScriptName    = NAMEDERERWEITERUNG
	; * Die Version der Erweiterung
	%Prefix%_ScriptVersion = 0.1
	; Der Autor der Erweiterung
	%Prefix%_Author        = Wolfgang Reszel
	; Erweiterungen, welche für diese Erweiterung installiert sein müssen (kommasepariert, ohne Leerzeichen)
	RequireExtensions      =
	; Wenn 1, dann gibt's im 'Pfeil'-Menü einen Eintrag, dass Einstellungen hinzugeladen werden können
	AddSettings_NAMEDERERWEITERUNG =
	; Wenn eine eigene Konfigurations-Datei statt ac'tivAid.ini verwendet wird, muss hier der relative Pfad angegeben werden
	ConfigFile_NAMEDERERWEITERUNG = ; %SettingsDir%\datei.ini

	; Durch setzen der folgenden drei Variablen, kümmert sich ac'tivAid automatisch um ein Tastaturkürzel
	; für die Erweiterung und fügt auch automatisch ein Tastaturkürzel-Schaltfläche zum Konfigurationsdialog hinzu

	; automatisches benutzerdefinierbares Tastaturkürzel? (1 = ja)
	CustomHotkey_NAMEDERERWEITERUNG =
	; Standard-Hotkey
	Hotkey_NAMEDERERWEITERUNG       =
	; Präfix, welches vor immer vor dem Tastaturkürzel gesetzt wird. In diesem
	; Fall sorgt es dafür, dass das Tastaturkürzel durchgeschleift wird.
	HotkeyPrefix_NAMEDERERWEITERUNG =

	; Wenn 1, dann bekommt die Erweiterung keinen Eintrag im Konfigurationsdialog
	HideSettings = 0
	; Soll eine Erweiterung nicht im Tray-Menü aufgeführt werden, muss der Wert 0 betragen
	EnableTray_NAMEDERERWEITERUNG   =

	DisableIfCompiled_NAMEDERERWEITERUNG =       ; Wenn 1, lässt sich die Erweiterung in kompilierter Form nicht de-/aktivieren

	; freie GUI-ID in %GuiID_NAMEDERERWEITERUNG% ablegen und Close/Escape-Label
	; registrieren (z.B. NAMEDERERWEITERUNGGuiClose statt 5GuiClose)
	; CreateGuiID("NAMEDERERWEITERUNG")

	; Zugriff auf die GUI-ID vor dem Aufbau der Gui über:
	; GuiDefault("NAMEDERERWEITERUNG")

	IconFile_On_NAMEDERERWEITERUNG  =
	IconPos_On_NAMEDERERWEITERUNG   =
	IconFile_Off_NAMEDERERWEITERUNG =
	IconPos_Off_NAMEDERERWEITERUNG  =

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		; Name des Menüeintrags im Tray-Menü
		MenuName                      = %NDE!_ScriptName% - Kurzbeschreibung
		; Beschreibung für den Erweiterungsmanager und den Konfigurationsdialog
		Description                   = Kurze Beschreibung, was die Erweiterung so kann
		; Es gilt zu beachten, dass die Erweiterung selber später nicht auf MenuName und Description zugreifen kann,
		; das sie später die Werte der zuletzt geladenen Erweiterung enthalten. Die Variablen werden von ac'tivAid aber
		; automatisch in ExtensionMenuName[%NDE!_ScriptName%] und ExtensionDescription[%NDE!_ScriptName%] gespeichert

		; hier folgen nun alle weiteren sprachspezifischen Textvariablen
		; es empfiehlt sich folgende Form:
		; lng_NDE!_VariablenName        = Text

		; Für GUI-Elemente sind auch automatische Tooltips möglich
		; tooltip_NAMEDESGUIELEMENTS   = Text
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %NDE!_ScriptName% - Kurzbeschreibung
		Description                   = Kurze Beschreibung, was die Erweiterung so kann

		; ....
	}

	; Hier folgt nun z.B. das Einlesen der Konfigurationswerte aus der INI-Datei

	; zusätzliches Hotkey aus der INI-Datei einlesen
	; Syntax: HotkeyRead ( Name des Tastaturkürzels, INI-Datei, INI-Sektion, INI-Variable, Subroutine des Tastaturkürzels, Standard-Kürzel)
	; func_HotkeyRead( "NDE!_HOTKEYNAME", ConfigFile , NDE!_ScriptName, "INI-Variable", "NDE!_sub_UNTERROUTINE", "DEFAULTWERT" )

	; Die zusätzlichen Unterordner aus der INI-Datei auslesen
	; IniRead, NDE!_VARIABLE, %ConfigFile%, %NDE!_ScriptName%, INI-Variable, DEFAULTWERT
Return

; Die folgende Routine enthält alle Befehle, welche dazu nötig sind den Konfigurationsdialog zu ergänzen
; Das erste GUI-Element sollte immer mit "XS+10 Y+5" positioniert werden, wobei der Y-Wert ggf.
; auch angepasster werden kann.
SettingsGui_NAMEDERERWEITERUNG:
	; Schaltfläche für Abfrage eines Tastaturkürzels hinzufügen
	; func_HotkeyAddGuiControl( lng_NDE!_TEXT, "NDE!_HOTKEYNAME", "xs+10 y+10 w160" )
	; Eigene Schaltflächen sollten in den Optionen auch sub_CheckIfSettingsChanged
	; aufrufen, damit ac'tivAid erkennt, dass Änderungen vorgenommen wurden.
	; z.B.: Gui, Add, Edit, xs+10 y+5 gsub_CheckIfSettingsChanged vNDE!_var, %lng_NDE!_text%
Return

; wird aufgerufen, wenn im Konfigurationsdialog OK oder Übernehmen angeklickt wird
SaveSettings_NAMEDERERWEITERUNG:
	; Syntax: HotkeyWrite ( Name des Tastaturkürzels, INI-Datei, Sektion, INI-Variable [, Subroutine des Tastaturkürzels] )
	; func_HotkeyWrite( "NDE!_HOTKEYNAME", ConfigFile , NDE!_ScriptName, "INI-Variable" )
	; IniWrite, %NDE!_VARIABLE%, %ConfigFile%, INI-Sektion, INI-Variable

	; Wenn es nötig ist, dass ac'tivAid nach dem Speichern der Einstellungen neu geladen werden muss, kann man Reload auf 1 setzen
	; Reload = 1
Return

; Wird aufgerufen, wenn Einstellungen über das 'Pfeil'-Menü hinzugefügt werden, ist nur notwendig wenn AddSettings_NAMEDERERWEITERUNG = 1
AddSettings_NAMEDERERWEITERUNG:
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_NAMEDERERWEITERUNG:
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_NAMEDERERWEITERUNG:
	; func_HotkeyEnable("NDE!_HOTKEYNAME")
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern der Einstellungen aufgerufen
DoDisable_NAMEDERERWEITERUNG:
	; func_HotkeyDisable("NDE!_HOTKEYNAME")
Return

; wird aufgerufen, wenn der Anwender die Erweiterung auf die Standard-Einstellungen zurücksetzt
DefaultSettings_NAMEDERERWEITERUNG:
Return

; wird aufgerufen, wenn ac'tivAid beendet oder neu geladen wird.
OnExitAndReload_NAMEDERERWEITERUNG:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
; sub_Hotkey_NAMEDERERWEITERUNG:
;    Gosub, NDE!_main_NAMEDERERWEITERUNG
; Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

; NDE!_sub_UNTERROUTINE
; Return
