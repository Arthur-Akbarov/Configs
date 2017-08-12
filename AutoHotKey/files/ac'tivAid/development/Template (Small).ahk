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

; Kurze Erweiterungs-Vorlage, welche darauf vorbereitet ist dass man
; ein eigenes Skript (sub_Hotkey_NAMEDERERWEITERUNG) ganz leicht auf Win+F5
; legen kann

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_NAMEDERERWEITERUNG:
	Prefix = NDE!
	%Prefix%_ScriptName    = NAMEDERERWEITERUNG
	%Prefix%_ScriptVersion = 0.1
	%Prefix%_Author        = Wolfgang Reszel

	CustomHotkey_NAMEDERERWEITERUNG = 1
	Hotkey_NAMEDERERWEITERUNG       = #F5
	HotkeyPrefix_NAMEDERERWEITERUNG =
	IconFile_On_NAMEDERERWEITERUNG  =
	IconPos_On_NAMEDERERWEITERUNG   =
	IconFile_Off_NAMEDERERWEITERUNG =
	IconPos_Off_NAMEDERERWEITERUNG  =

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %NDE!_ScriptName% - Kurzbeschreibung
		Description                   = Kurze Beschreibung, was die Erweiterung so kann
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %NDE!_ScriptName% - Kurzbeschreibung
		Description                   = Kurze Beschreibung, was die Erweiterung so kann
	}

	; IniRead, NDE!_VARIABLE, %ConfigFile%, %NDE!_ScriptName%, INI-Variable, DEFAULTWERT
Return

SettingsGui_NAMEDERERWEITERUNG:
	; func_HotkeyAddGuiControl( lng_NDE!_TEXT, "NDE!_HOTKEYNAME", "xs+10 y+10 w160" )
	; Gui, Add, Edit, xs+10 y+5 gsub_CheckIfSettingsChanged vNDE!_var, %lng_NDE!_text%
Return

SaveSettings_NAMEDERERWEITERUNG:
	; Syntax: HotkeyWrite ( Name des Tastaturkürzels, INI-Datei, Sektion, INI-Variable [, Subroutine des Tastaturkürzels] )
	; func_HotkeyWrite( "NDE!_HOTKEYNAME", ConfigFile , NDE!_ScriptName, "INI-Variable" )
	; IniWrite, %NDE!_VARIABLE%, %ConfigFile%, INI-Sektion, INI-Variable
Return

AddSettings_NAMEDERERWEITERUNG:
Return
CancelSettings_NAMEDERERWEITERUNG:
Return

DoEnable_NAMEDERERWEITERUNG:
	; func_HotkeyEnable("NDE!_HOTKEYNAME")
Return

DoDisable_NAMEDERERWEITERUNG:
	; func_HotkeyDisable("NDE!_HOTKEYNAME")
Return

DefaultSettings_NAMEDERERWEITERUNG:
Return
OnExitAndReload_NAMEDERERWEITERUNG:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_NAMEDERERWEITERUNG:
	; Hier kommen die Befehle hin, welche bei Win+F5 ausgeführt werden
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

