; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               WebSearchOnMButton
; -----------------------------------------------------------------------------
; Prefix:             wom_
; Version:            0.2
; Date:               2006-06-20
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_WebSearchOnMButton:
	Prefix = wom
	%Prefix%_ScriptName    = WebSearchOnMButton
	%Prefix%_ScriptVersion = 0.2
	%Prefix%_Author        = Wolfgang Reszel

	RequireExtensions = WebSearch,MouseClip

	IconFile_On_WebSearchOnMButton = %A_WinDir%\system32\shell32.dll
	IconPos_On_WebSearchOnMButton = 15

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %wom_ScriptName% - MouseClip ruft WebSearch auf
		Description                   = Führt WebSearch aus, wenn mittels MouseClip (mittlere Maustaste) ein Text markiert wird.
	}
	else        ; = other languages (english)
	{
		MenuName                      = %wom_ScriptName% - WebSearch with MouseClip
		Description                   = Calls WebSearch after selecting a text with MouseClip (middle mouse-button).
	}
	If CustomLanguage <>
		gosub, CustomLanguage
Return

SettingsGui_WebSearchOnMButton:
Return

SaveSettings_WebSearchOnMButton:
Return

CancelSettings_WebSearchOnMButton:
Return

DoEnable_WebSearchOnMButton:
	RegisterHook( "MButton", "WebSearchOnMButton" )
Return

DoDisable_WebSearchOnMButton:
	UnRegisterHook( "MButton", "WebSearchOnMButton" )
Return

DefaultSettings_WebSearchOnMButton:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

MButton_WebSearchOnMButton:
	Critical
	If Enable_MouseClip = 1
	{
		mc_NoPaste = yes
		Gosub, wom_main_WebSearchOnMButton
	}
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

wom_main_WebSearchOnMButton:
	Critical
	If Enable_WebSearchOnMButton = 1
	{
		If MButton_send <> no2
			ws_FromClipboard = 1
		Gosub, ws_main_WebSearch
		ws_FromClipboard =
		MButton_send = no
	}
Return
