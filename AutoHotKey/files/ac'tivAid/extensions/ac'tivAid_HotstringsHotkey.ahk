; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               HotstringsHotkey
; -----------------------------------------------------------------------------
; Prefix:             hh_
; Version:            0.3.1
; Date:               2007-06-07
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_HotstringsHotkey:
	Prefix = hh
	%Prefix%_ScriptName    = HotstringsHotkey
	%Prefix%_ScriptVersion = 0.3.1
	%Prefix%_Author        = Wolfgang Reszel
	RequireExtensions      = Hotstrings

	CustomHotkey_HotstringsHotkey =               ; automatisches benutzerdefinierbares Tastaturkürzel? (1 = ja)
	Hotkey_HotstringsHotkey       =               ; Standard-Hotkey
	HotkeyPrefix_HotstringsHotkey =               ; Präfix, welches vor immer vor dem Tastaturkürzel gesetzt wird

	HideSettings = 0                             ; Wenn 1, dann bekommt die Erweiterung keinen Eintrag im Konfigurationsdialog
	EnableTray_HotstringsHotkey   =               ; Soll eine Erweiterung nicht im Tray-Menü aufgeführt werden, muss der Wert 0 betragen

	DisableIfCompiled_HotstringsHotkey = 1        ; Wenn 1, lässt sich die Erweiterung in kompilierter Form nicht de-/aktivieren
	DontPackAndGo_HotstringsHotkey     = 1

	IconFile_On_HotStringsHotkey = %A_WinDir%\system32\shell32.dll
	IconPos_On_HotStringsHotkey  = 134

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %hh_ScriptName% - HotString aus Auswahl erstellen
		Description                   = Mittels eines Tastaturkürzels ist es möglich, ausgewählten Text automatisch als HotString definieren zu lassen.
		lng_hh_Disabled               = Es kann kein HotString hinzugefügt werden, da HotStrings.ini manuell mit einem Text-Editor gepflegt wird.
		lng_hh_Hotkey1                = Auswahl = Textbaustein
		lng_hh_Hotkey2                = Auswahl = Abkürzung
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %hh_ScriptName% - Create HotString from selection
		Description                   = Creates a new HotString with the selected text
		lng_hh_Disabled               = Cannot add new a HotString because HotStrings.ini seems to be administered with a text-editor.
		lng_hh_Hotkey1                = Selection = Text
		lng_hh_Hotkey2                = Selection = Abbreviation
	}
	func_HotkeyRead( "hh_Hotkey1", ConfigFile , hh_ScriptName, "Hotkey_HotstringsHotkey", "hh_sub_Hotkey1", "#+h" )
	func_HotkeyRead( "hh_Hotkey2", ConfigFile , hh_ScriptName, "Hotkey_HotstringsHotkey2", "hh_sub_Hotkey2", "#!h" )
Return

SettingsGui_HotstringsHotkey:
	func_HotkeyAddGuiControl( lng_hh_Hotkey1, "hh_Hotkey1", "xs+10 y+5 w150" )
	func_HotkeyAddGuiControl( lng_hh_Hotkey2, "hh_Hotkey2", "xs+10 y+7 w150" )
Return

SaveSettings_HotstringsHotkey:
	func_HotkeyWrite( "hh_Hotkey1", ConfigFile , hh_ScriptName, "Hotkey_HotstringsHotkey" )
	func_HotkeyWrite( "hh_Hotkey2", ConfigFile , hh_ScriptName, "Hotkey_HotstringsHotkey2" )
Return

AddSettings_HotstringsHotkey:
Return

CancelSettings_HotstringsHotkey:
Return

DoEnable_HotstringsHotkey:
	func_HotkeyEnable("hh_Hotkey1")
	func_HotkeyEnable("hh_Hotkey2")
Return

DoDisable_HotstringsHotkey:
	func_HotkeyDisable("hh_Hotkey1")
	func_HotkeyDisable("hh_Hotkey2")
Return

DefaultSettings_HotstringsHotkey:
Return

OnExitAndReload_HotstringsHotkey:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

hh_sub_Hotkey1:
	If MainGUiVisible <>
		Gosub, activAidGuiClose

	func_GetSelection(1,0,2)
	hh_Selection := Selection

	SimpleMainGUI = HotStrings
	Gosub, sub_MainGUI
	If hs_DisableEditing = 1
	{
		BalloonTip( hh_ScriptName, lng_hh_Disabled, "Info",0,1)
		Return
	}
	hs_NoStore := 1
	Gosub, hs_sub_ListBox_add
	GuiControl,,hs_HotstringText,%hh_Selection%
Return

hh_sub_Hotkey2:
	If MainGUiVisible <>
		Gosub, activAidGuiClose

	func_GetSelection(1,0,2)
	hh_Selection := Selection

	SimpleMainGUI = HotStrings
	Gosub, sub_MainGUI
	If hs_DisableEditing = 1
	{
		BalloonTip( hh_ScriptName, lng_hh_Disabled, "Info",0,1)
		Return
	}
	hs_NoStore := 1
	Gosub, hs_sub_ListBox_add
	hs_NoFocus = 1
	hh_Selection := RegExReplace( hh_Selection, "\r|\n", "" )
	GuiControl,,hs_HotstringName,%hh_Selection%
	GuiControl, Focus, hs_HotstringText
Return
