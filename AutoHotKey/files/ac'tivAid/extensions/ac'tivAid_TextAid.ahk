; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               TextAid
; -----------------------------------------------------------------------------
; Prefix:             ta_
; Version:            0.8.1
; Date:               2008-05-23
; Author:             Michael Telgkamp
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
;
; Auswahl in Groß/Klein umwandeln (Idee von Armin Mutscheller)
; Markierte Zeilen um Text ergänzen FS#978
; Zeilenumbrüche nach X Zeichen
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_TextAid:
	Prefix = ta
	%Prefix%_ScriptName    = TextAid
	%Prefix%_ScriptVersion = 0.8.1
	%Prefix%_Author        = Michael Telgkamp

	 IconFile_On_TextAid = %A_WinDir%\system32\shell32.dll
	 IconPos_On_TextAid = 134

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		; Name des Menüeintrags im Tray-Menü
		MenuName                      = %ta_ScriptName% - Spezielle Textfunktionen
		; Beschreibung für den Erweiterungsmanager und den Konfigurationsdialog
		Description                   = Bietet die Möglichkeit, verschiedene Funktionen auf markierte Texte anzuwenden.`nGroß-/Kleinschreibung ändern - Schrägstrichrichtung ändern - Text bei einer bestimmten Zeichenzahl umbrechen
		lng_ta_UpperLower             = Umwandlung der Groß- und Kleinschreibung der Auswahl
		lng_ta_SelectionTo            = ; Auswahl ändern in
		lng_ta_ToLower                = kleinbuchstaben
		lng_ta_ToUpper                = GROSSBUCHSTABEN
		lng_ta_ToTitle                = Erster Groß
		lng_ta_ToCamel                = CamelCase
		lng_ta_XplCamel               = Camel Case trennen
		lng_ta_ToggleCase             = uMKEHREN

		lng_ta_RE                     = regulärer Ausdruck
		lng_ta_REHotkey               = RegEx
		lng_ta_REPattern              = Suchmuster
		lng_ta_REReplace              = Ersetzung

		lng_ta_SwitchFlip             = Tauschen
		lng_ta_Switch                 = Buchstaben
		lng_ta_Flip                   = Schrägstrichrichtung
		lng_ta_PPText                 = Text zu jeder Zeile hinzufügen
		lng_ta_PPChar                 = Text mit Zeichen umschließen
		lng_ta_inputBeginChar         = Bitte Zeichen eingeben, welches den Text umschließen soll`n(Abbrechen mit ESC)
		lng_ta_inputBeginString       = Bitte Text eingeben, der am Anfang jeder Zeile eingefügt wird`n
		lng_ta_inputEndString         = Bitte Text eingeben, der am Ende jeder Zeile eingefügt wird`n
		lng_ta_inputConfirm           = (Bestätigen mit Enter, Abbrechen mit ESC)`n
		lng_ta_FormatText             = Textformatierungen
		lng_ta_Reformat               = Text neu formatieren
		lng_ta_KeepLinebreaks1        = Mehrfachzeilenumbrüche nicht entfernen
		lng_ta_KeepLinebreaks2        = Alle Zeilenumbrüche beibehalten
		lng_ta_RespectQuotation       = E-Mail-Zitate berücksichtigen (> am Zeilenanfang)
		lng_ta_RespectLists1          = Listen berücksichtigen (* oder - am Zeilenanfang)
		lng_ta_RespectLists2          = Listen und Aufzählungen berücksichtigen (*, - oder 1., 2., ... am Zeilenanfang)
		lng_ta_replaceDoubleEmptyLines= Mehrere Leerzeilen zu einer Leerzeile zusammenfassen
		lng_ta_AutoIndent1            = Einrückung von der ersten Zeile der Auswahl übernehmen
		lng_ta_AutoIndent2            = Einrückung von der ersten Zeile der Auswahl als Absatzeinrückung verwenden
		lng_ta_FormatList             = Liste formatieren
		lng_ta_LineLength             = Zeilenlänge
		lng_ta_SelectAfterwards       = Text nach Umwandlung erneut auswählen
		lng_ta_EditInEditor           = Text mit einem Texteditor bearbeiten
		lng_ta_Editor                 = Texteditor
		lng_ta_FileTypeEXE            = Programme (*.exe)
		lng_ta_Pasting                = Der Text im Ausgangsfenster wird aktualisiert ...
		lng_ta_SourceClosed           = Das Ausgangsfenster wurde geschlossen.`nDie Verbindung zum Editor wird aufgehoben.
		lng_ta_EditorClosed           = Der Editor wurde geschlossen.`nDie Verbindung zum Ausgangsfenster wird aufgehoben.
		lng_ta_InfoScreens1           = %lng_ta_EditInEditor%: Hinweisfenster anzeigen
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %ta_ScriptName% - Special text operations
		Description                   = Allows to apply different functions to the selected text.`nChange capitalisation - flip slashes - insert linebreaks after a specific number of characters
		lng_ta_UpperLower             = Upper and lower case transformations of selection
		lng_ta_SelectionTo            = ; Transform selection to
		lng_ta_ToLower                = lower case
		lng_ta_ToUpper                = UPPER CASE
		lng_ta_ToTitle                = Word Case
		lng_ta_ToCamel                = CamelCase
		lng_ta_XplCamel               = explode Camel Case
		lng_ta_ToggleCase             = tOGGLE cASE

		lng_ta_RE                     = regular Expression
		lng_ta_REHotkey               = RegEx
		lng_ta_REPattern              = Pattern
		lng_ta_REReplace              = Replacement

		lng_ta_SwitchFlip             = Switch/Flip
		lng_ta_Switch                 = Characters
		lng_ta_Flip                   = Flip slashes
		lng_ta_PPText                 = Add Text to every line
		lng_ta_PPChar                 = Enclose text with character
		lng_ta_inputBeginChar         = Please enter a character to enclose the text`n(Abort with ESC)
		lng_ta_inputBeginString       = Please enter text to be inserted at the beginning`n
		lng_ta_inputEndString         = Please enter text to be inserted at the end`n
		lng_ta_inputConfirm           = (Confirm with Enter, abort with ESC)`n
		lng_ta_FormatText             = Reformat selection
		lng_ta_Reformat               = Reformat text
		lng_ta_keepLinebreaks1        = Keep multiple linebreaks
		lng_ta_keepLinebreaks2        = Keep all linebreaks
		lng_ta_RespectQuotation       = Respect e-mail quotations (lines beginning with >)
		lng_ta_RespectLists1          = Respect lists (lines beginning with - or *)
		lng_ta_RespectLists2          = Respect lists and numbered lists (lines beginning with -, * or 1., 2. ...)
		lng_ta_replaceDoubleEmptyLines= Replace many empty lines with on emtpy line
		lng_ta_AutoIndent             = Take indentation from the first line of the selection
		lng_ta_FormatList             = Format List
		lng_ta_LineLength             = Line length
		lng_ta_SelectAfterwards       = Select text afterwards
		lng_ta_EditInEditor           = Edit text with an external text editor
		lng_ta_Editor                 = Text editor
		lng_ta_FileTypeEXE            = Programs (*.exe)
		lng_ta_Pasting                = Updating the text in the source window ...
		lng_ta_SourceClosed           = The source window has been closed.`nThe connection to the editor is broken.
		lng_ta_EditorClosed           = The editor has been closed.`nThe connection to the source window is broken.
		lng_ta_InfoScreens1           = %lng_ta_EditInEditor%: Show info window
	}

	func_HotkeyRead( "ta_Hotkey_ToLower", ConfigFile , ta_ScriptName, "Hotkey_ToLower", "ta_sub_Hotkey_ToLower", "^#l", "$" )
	func_HotkeyRead( "ta_Hotkey_ToUpper", ConfigFile , ta_ScriptName, "Hotkey_ToUpper", "ta_sub_Hotkey_ToUpper", "^#u", "$" )
	func_HotkeyRead( "ta_Hotkey_ToTitle", ConfigFile , ta_ScriptName, "Hotkey_ToTitle", "ta_sub_Hotkey_ToTitle", "^#w", "$" )
	func_HotkeyRead( "ta_Hotkey_ToCamel", ConfigFile , ta_ScriptName, "Hotkey_ToCamel", "ta_sub_Hotkey_ToCamel", "", "$" )
	func_HotkeyRead( "ta_Hotkey_XplCamel", ConfigFile , ta_ScriptName, "Hotkey_XplCamel", "ta_sub_Hotkey_XplCamel", "", "$" )
	func_HotkeyRead( "ta_Hotkey_Switch", ConfigFile , ta_ScriptName, "Hotkey_Switch", "ta_sub_Hotkey_Switch", "^#s", "$" )
	func_HotkeyRead( "ta_Hotkey_Flip", ConfigFile , ta_ScriptName, "Hotkey_Flip", "ta_sub_Hotkey_Flip", "", "$" )
	func_HotkeyRead( "ta_Hotkey_PPText", ConfigFile , ta_ScriptName, "Hotkey_PPText", "ta_sub_Hotkey_PPText", "", "$" )
	func_HotkeyRead( "ta_Hotkey_PPChar", ConfigFile , ta_ScriptName, "Hotkey_PPChar", "ta_sub_Hotkey_PPChar", "", "$" )
	func_HotkeyRead( "ta_Hotkey_Reformat", ConfigFile , ta_ScriptName, "Hotkey_Reformat", "ta_sub_Hotkey_Reformat", "", "$" )
	func_HotkeyRead( "ta_Hotkey_ToggleCase", ConfigFile , ta_ScriptName, "Hotkey_ToggleCase", "ta_sub_Hotkey_ToggleCase", "", "$" )
	func_HotkeyRead( "ta_Hotkey_EditInEditor", ConfigFile , ta_ScriptName, "Hotkey_EditInEditor", "ta_sub_Hotkey_EditInEditor", "^!+e", "$" )
	func_HotkeyRead( "ta_Hotkey_FormatList", ConfigFile , ta_ScriptName, "Hotkey_FormatList", "ta_sub_Hotkey_FormatList", "", "$" )

	func_HotkeyRead( "ta_Hotkey_RE", ConfigFile , ta_ScriptName, "Hotkey_RE", "ta_sub_Hotkey_RE", "^#r", "$" )
	IniRead, ta_REPattern, %ConfigFile%, %ta_ScriptName%, RegEx_Pattern, ([^A-Za-z0-9])
	IniRead, ta_REReplace, %ConfigFile%, %ta_ScriptName%, RegEx_Replace,
	if(ta_REReplace == "ERROR")
		ta_REReplace := ""

	IniRead, ta_LineLength, %ConfigFile%, %ta_ScriptName%, LineLength, 80
	IniRead, ta_Editor, %ConfigFile%, %ta_ScriptName%, Editor, notepad.exe
	IniRead, ta_ControlSendApps, %ConfigFile%, %ta_ScriptName%, ControlSendApps, Mozilla,Safari,IEFrame
	IniRead, ta_AlternativePasteApps, %ConfigFile%, %ta_ScriptName%, AlternativePasteApps, Mozilla
	IniRead, ta_TabWidth, %ConfigFile%, %ta_ScriptName%, TabWidth, 4
	RegisterAdditionalSetting( "ta", "KeepLinebreaks1", 1, "SeparateMenu:ta_Reformat" )
	RegisterAdditionalSetting( "ta", "KeepLinebreaks2", 0, "SeparateMenu:ta_Reformat" )
	RegisterAdditionalSetting( "ta", "RespectLists1", 1, "SeparateMenu:ta_Reformat" )
	RegisterAdditionalSetting( "ta", "RespectLists2", 0, "SeparateMenu:ta_Reformat" )
	RegisterAdditionalSetting( "ta", "RespectQuotation", 1, "SeparateMenu:ta_Reformat" )
	RegisterAdditionalSetting( "ta", "replaceDoubleEmptyLines", 1, "SeparateMenu:ta_Reformat" )
	RegisterAdditionalSetting( "ta", "AutoIndent1", 0, "SeparateMenu:ta_Reformat" )
	RegisterAdditionalSetting( "ta", "AutoIndent2", 0, "SeparateMenu:ta_Reformat" )
	RegisterAdditionalSetting( "ta", "SelectAfterwards", 1 )
	RegisterAdditionalSetting( "ta", "InfoScreens1", 1 )

;   IniRead, ta_TmpMap, %ConfigFile%, %ta_ScriptName%, EditorMapping1
;   If ta_TmpMap = ERROR
;   {
;      IniWrite, ixplore.exe, %ConfigFile%, %ta_ScriptName%, EditorMapping1
;      IniWrite, .html, %ConfigFile%, %ta_ScriptName%, EditorMappingExtension1
;      IniWrite, firefox.exe, %ConfigFile%, %ta_ScriptName%, EditorMapping2
;      IniWrite, .html, %ConfigFile%, %ta_ScriptName%, EditorMappingExtension2
;      IniWrite, opera.exe, %ConfigFile%, %ta_ScriptName%, EditorMapping3
;      IniWrite, .html, %ConfigFile%, %ta_ScriptName%, EditorMappingExtension3
;   }
;
;   Loop
;   {
;      IniRead, ta_TmpMap, %ConfigFile%, %ta_ScriptName%, EditorMapping%A_Index%, %A_Space%
;      IniRead, ta_TmpExt, %ConfigFile%, %ta_ScriptName%, EditorMappingExtension%A_Index%, %A_Space%
;      If ta_TmpMap =
;         break
;      ta_TmpMap := func_Hex(ta_TmpMap)
;      If (func_StrLeft(ta_TmpExt,1) <> ".")
;         ta_TmpExt = .%ta_TmpExt%
;      ta_EditorMapping[%ta_TmpMap%] = %ta_TmpExt%
;   }

	ta_AutoIndentPara10 = Auto
	ta_AutoIndentPara01 = AutoParagraph
Return

SettingsGui_TextAid:
	Gui +Delimiter`n

	Gui, Add, GroupBox, xs+10 yp+7 w550 h77, %lng_ta_UpperLower%
	func_HotkeyAddGuiControl( lng_ta_SelectionTo " " lng_ta_ToLower, "ta_Hotkey_ToLower", "xs+20 yp+16 w90 -Wrap", "", "w150")
	func_HotkeyAddGuiControl( lng_ta_SelectionTo " " lng_ta_ToUpper, "ta_Hotkey_ToUpper", "x+10 yp+3 w120 -Wrap", "", "w150")
	func_HotkeyAddGuiControl( lng_ta_SelectionTo " " lng_ta_ToTitle, "ta_Hotkey_ToTitle", "xs+20 yp+23 w90 -Wrap", "", "w150")
	func_HotkeyAddGuiControl( lng_ta_SelectionTo " " lng_ta_ToggleCase, "ta_Hotkey_ToggleCase", "x+10 yp+3 w120 -Wrap", "", "w150")
	func_HotkeyAddGuiControl( lng_ta_SelectionTo " " lng_ta_ToCamel, "ta_Hotkey_ToCamel", "xs+20 yp+23 w90 -Wrap", "", "w150")
	func_HotkeyAddGuiControl( lng_ta_SelectionTo " " lng_ta_XplCamel, "ta_Hotkey_XplCamel", "x+10 yp+3 w120 -Wrap", "", "w150")

	Gui, Add, GroupBox, xs+10 y+7 w550 h35, %lng_ta_RE%
	func_HotkeyAddGuiControl( lng_ta_REHotkey, "ta_Hotkey_RE", "xs+20 yp+15 w90 -Wrap", "", "w150")
	Gui, Add, Text,       x+10 yp+1, %lng_ta_REPattern%
		Gui, Add, Edit,     x+3  yp-3 -Wrap r1 w80 gsub_CheckIfSettingsChanged vta_REPattern, %ta_REPattern%
	Gui, Add, Text,       x+5  yp+3, %lng_ta_REReplace%
		Gui, Add, Edit,     x+3  yp-3 -Wrap r1 w80 gsub_CheckIfSettingsChanged vta_REReplace, %ta_REReplace%

	Gui, Add, GroupBox, xs+10 y+7 w550 h35, %lng_ta_SwitchFlip%
	func_HotkeyAddGuiControl( lng_ta_Switch, "ta_Hotkey_Switch", "xs+20 yp+15 w90 -Wrap", "", "w150")
	func_HotkeyAddGuiControl( lng_ta_Flip, "ta_Hotkey_Flip", "x+10 yp+3 w120 -Wrap", "", "w150")

	Gui, Add, GroupBox, xs+10 y+7 w550 h75, %lng_ta_FormatText%
	func_HotkeyAddGuiControl( lng_ta_PPText, "ta_Hotkey_PPText", "xs+20 yp+16 w150 -Wrap", "", "w250")
	func_HotkeyAddGuiControl( lng_ta_PPChar, "ta_Hotkey_PPChar", "xs+20 yp+23 w150 -Wrap", "", "w250")
	func_HotkeyAddGuiControl( lng_ta_Reformat, "ta_Hotkey_Reformat", "xs+20 yp+23 w150 -Wrap", "", "w220")
	Gui, Add, Text,       x+10 yp+3, %lng_ta_LineLength%
		Gui, Add, Edit,     x+5  yp-3 Number -Wrap r1 w35 gsub_CheckIfSettingsChanged vta_LineLength, %ta_LineLength%

	SeparateAdditionalSettingsButton("ta_Reformat")

	;func_HotkeyAddGuiControl( lng_ta_FormatList, "ta_Hotkey_FormatList", "xs+20 yp+25 w150 -Wrap", "", "w150")

	Gui, Add, GroupBox, xs+10 y+7 w550 h36, %lng_ta_EditInEditor%
	func_HotkeyAddGuiControl( lng_Hotkey, "ta_Hotkey_EditInEditor", "xs+20 yp+16 w80 -Wrap", "", "w180")
	Gui, Add, Text, x+10 yp+3, %lng_ta_Editor%:
	Gui, Add, Edit, x+5 yp-3 gsub_CheckIfSettingsChanged R1 vta_Editor w180, %ta_Editor%
	Gui, Add, Button, x+2 h20 w20 gta_sub_SelectEditor, ...

	Gui +Delimiter|
Return

ta_sub_SelectEditor:
	 Gui, +OwnDialogs
	 ta_Suspended = %A_IsSuspended%
	 If ta_Suspended = 0
			Suspend, On

	 FileSelectFile, ta_Editor_tmp,, %A_Programfiles%, %lng_ta_Editor%, %lng_ta_FileTypeEXE%
	 If ErrorLevel = 0
			GuiControl,, ta_Editor, %ta_Editor_tmp%

	 If ta_Suspended = 0
			Suspend, Off
Return


; wird aufgerufen, wenn im Konfigurationsdialog OK oder Übernehmen angeklickt wird
SaveSettings_TextAid:
	func_HotkeyWrite( "ta_Hotkey_ToLower", ConfigFile , ta_ScriptName, "Hotkey_ToLower" )
	func_HotkeyWrite( "ta_Hotkey_ToUpper", ConfigFile , ta_ScriptName, "Hotkey_ToUpper" )
	func_HotkeyWrite( "ta_Hotkey_ToTitle", ConfigFile , ta_ScriptName, "Hotkey_ToTitle" )
	func_HotkeyWrite( "ta_Hotkey_ToCamel", ConfigFile , ta_ScriptName, "Hotkey_ToCamel" )
	func_HotkeyWrite( "ta_Hotkey_XplCamel", ConfigFile , ta_ScriptName, "Hotkey_XplCamel" )
	func_HotkeyWrite( "ta_Hotkey_Switch", ConfigFile , ta_ScriptName, "Hotkey_Switch" )
	func_HotkeyWrite( "ta_Hotkey_Flip", ConfigFile , ta_ScriptName, "Hotkey_Flip" )
	func_HotkeyWrite( "ta_Hotkey_PPText", ConfigFile , ta_ScriptName, "Hotkey_PPText" )
	func_HotkeyWrite( "ta_Hotkey_PPChar", ConfigFile , ta_ScriptName, "Hotkey_PPChar" )
	func_HotkeyWrite( "ta_Hotkey_PPChar", ConfigFile , ta_ScriptName, "Hotkey_PPChar" )
	func_HotkeyWrite( "ta_Hotkey_Reformat", ConfigFile , ta_ScriptName, "Hotkey_Reformat" )
	func_HotkeyWrite( "ta_Hotkey_ToggleCase", ConfigFile , ta_ScriptName, "Hotkey_ToggleCase" )
	func_HotkeyWrite( "ta_Hotkey_EditInEditor", ConfigFile , ta_ScriptName, "Hotkey_EditInEditor" )
	;func_HotkeyWrite( "ta_Hotkey_FormatList", ConfigFile , ta_ScriptName, "Hotkey_FormatList" )

	func_HotkeyWrite( "ta_Hotkey_RE", ConfigFile , ta_ScriptName, "Hotkey_RE" )
	IniWrite, "%ta_REPattern%", %ConfigFile%, %ta_ScriptName%, RegEx_Pattern
	IniWrite, "%ta_REReplace%", %ConfigFile%, %ta_ScriptName%, RegEx_Replace

	IniWrite, %ta_LineLength%, %ConfigFile%, %ta_ScriptName%, LineLength
	IniWrite, %ta_Editor%, %ConfigFile%, %ta_ScriptName%, Editor
	IniWrite, %ta_ControlSendApps%, %ConfigFile%, %ta_ScriptName%, ControlSendApps
	IniWrite, %ta_AlternativePasteApps%, %ConfigFile%, %ta_ScriptName%, AlternativePasteApps
	IniWrite, %ta_TabWidth%, %ConfigFile%, %ta_ScriptName%, TabWidth
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_TextAid:
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_TextAid:
	ta_respectLists := ta_respectLists1*1+ta_respectLists2*2
	ta_keepLineBreaks := ta_keepLineBreaks1*1+ta_keepLineBreaks2*2

	func_HotkeyEnable("ta_Hotkey_ToLower")
	func_HotkeyEnable("ta_Hotkey_ToUpper")
	func_HotkeyEnable("ta_Hotkey_ToTitle")
	func_HotkeyEnable("ta_Hotkey_ToCamel")
	func_HotkeyEnable("ta_Hotkey_XplCamel")
	func_HotkeyEnable("ta_Hotkey_Switch")
	func_HotkeyEnable("ta_Hotkey_Flip")
	func_HotkeyEnable("ta_Hotkey_PPText")
	func_HotkeyEnable("ta_Hotkey_PPChar")
	func_HotkeyEnable("ta_Hotkey_Reformat")
	func_HotkeyEnable("ta_Hotkey_ToggleCase")
	func_HotkeyEnable("ta_Hotkey_EditInEditor")
	;func_HotkeyEnable("ta_Hotkey_FormatList")
	func_HotkeyEnable("ta_Hotkey_RE")

;  ta_EncloseInputKeys =
;  Loop, Parse, ta_EncloseChars, `,
;  {
;     Hotkey, % "$" func_StrLeft(A_LoopField,1), sub_EncloseKey%A_Index%
;     sub_EncloseLeft%A_Index% := func_StrLeft(A_LoopField, StrLen(A_LoopField)/2 )
;     sub_EncloseRight%A_Index% := func_StrRight(A_LoopField, StrLen(A_LoopField)/2 )
;  }
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern der Einstellungen aufgerufen
DoDisable_TextAid:
	func_Hotkeydisable("ta_Hotkey_ToLower")
	func_Hotkeydisable("ta_Hotkey_ToUpper")
	func_Hotkeydisable("ta_Hotkey_ToTitle")
	func_Hotkeydisable("ta_Hotkey_ToCamel")
	func_Hotkeydisable("ta_Hotkey_XplCamel")
	func_Hotkeydisable("ta_Hotkey_Switch")
	func_Hotkeydisable("ta_Hotkey_Flip")
	func_Hotkeydisable("ta_Hotkey_PPText")
	func_Hotkeydisable("ta_Hotkey_Reformat")
	func_Hotkeydisable("ta_Hotkey_ToggleCase")
	func_Hotkeydisable("ta_Hotkey_EditInEditor")
	;func_Hotkeydisable("ta_Hotkey_FormatList")
	func_Hotkeydisable("ta_Hotkey_RE")
Return

; wird aufgerufen, wenn der Anwender die Erweiterung auf die Standard-Einstellungen zurücksetzt
DefaultSettings_TextAid:
	IniDelete, %ConfigFile%, %ta_ScriptName%
Return

; wird aufgerufen, wenn ac'tivAid beendet oder neu geladen wird.
OnExitAndReload_TextAid:
Return

Update_TextAid:
Return
; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------
ta_sub_Hotkey_ToLower:
	func_GetSelection()
	StringLower,ta_Selection,Selection
	Gosub,ta_sub_send_ta_Selection
Return
ta_sub_Hotkey_ToUpper:
	func_GetSelection()
	StringUpper,ta_Selection,Selection
	Gosub,ta_sub_send_ta_Selection
Return
ta_sub_Hotkey_ToTitle:
	func_GetSelection()
	StringUpper,ta_Selection,Selection,T
	Gosub,ta_sub_send_ta_Selection
Return
ta_sub_Hotkey_ToCamel:
	func_GetSelection()
	StringUpper,ta_Selection,Selection,T
	ta_Selection := RegExReplace(ta_Selection,"\s")
	Gosub,ta_sub_send_ta_Selection
Return
ta_sub_Hotkey_ToggleCase:
	func_GetSelection()
	StringCaseSense, On
	ta_Selection =
	Loop, Parse, Selection
	{
		StringLower, ta_LowerField, A_LoopField
		If ta_LowerField = %A_LoopField% ; lowercase
			StringUpper, ta_LoopField, A_LoopField
		Else
			ta_LoopField = %ta_LowerField%
		ta_Selection = %ta_Selection%%ta_LoopField%
	}
	Gosub,ta_sub_send_ta_Selection
Return
ta_sub_Hotkey_XplCamel:
	func_GetSelection()
	ta_Selection := RegExReplace(Selection,"(\S)([A-Z])","$1 $2")
	ta_Selection = %ta_Selection%
	Gosub,ta_sub_send_ta_Selection
Return

ta_sub_Hotkey_RE:
	func_GetSelection()
	ta_Selection := RegExReplace(Selection,ta_REPattern,ta_REReplace)
	ta_Selection = %ta_Selection%
	Gosub,ta_sub_send_ta_Selection
Return

ta_sub_Hotkey_EditInEditor:
	 If ta_InfoScreens1 = 1
			InfoScreen(ta_ScriptName,lng_ta_EditInEditor " ...",255,1,"$2","000000",9, 290,"",1000,"C11")

	 WinGet, ta_WinID, ID, A
	 WinGet, ta_WinName, ProcessName, A
	 ControlGetFocus, ta_WinFocus, A
	 SetKeyDelay, 10, 10
	 Send, {Ctrl down}a{Ctrl up}
	 func_GetSelection(1,0,1)
	 ta_TmpExt = .txt
	 If (InStr(Selection,"<html") OR InStr(Selection,"<b>") OR InStr(Selection,"<div") OR InStr(Selection,"<span"))
			ta_TmpExt = .html
	 If (InStr(Selection,"<?xml") )
			ta_TmpExt = .xml
	 If (InStr(Selection,"/xhtml") )
			ta_TmpExt = .xhtml

;   ta_WinNameHex := func_Hex(ta_WinName)
;   ta_TmpExt := ta_EditorMapping[%ta_WinNameHex%]
	 Loop
	 {
			ta_SessionName%ta_WinID% = %A_Temp%\TextAid_%ta_WinName%_%ta_WinID%_%A_Index%.tmp%ta_TmpExt%
			IfNotExist, % ta_SessionName%ta_WinID%
				 Break
	 }
	 FileAppend, %Selection%, % ta_SessionName%ta_WinID%

	 Run, % func_Deref(ta_Editor) " """ ta_SessionName%ta_WinID% """",, UseErrorLevel, ta_EditorPID
	 If ErrorLevel = ERROR
	 {
			func_GetErrorMessage( A_LastError, ta_ScriptName, func_Deref(ta_Editor) " """ ta_SessionName%ta_WinID% """`n`n" )
			ta_func_RemoveEditorSession(ta_WinID)
	 }
	 Else
	 {
			WinWaitActive, ahk_pid %ta_EditorPID%,,2
			If ErrorLevel = 1
			{
				 ta_func_RemoveEditorSession(ta_WinID)
				 WinClose, ahk_pid %ta_EditorPID%,,2
			}
			Else
			{
				 ta_EditorSessions = %ta_EditorSessions%%ta_WinID%|
				 ta_SessionControl%ta_WinID% = %ta_WinFocus%
				 FileGetTime, ta_SessionTime%ta_WinID%, % ta_SessionName%ta_WinID%, M
				 WinGet, ta_EditorID%ta_WinID%, ID, ahk_pid %ta_EditorPID%
				 WinGetClass, ta_SessionClass%ta_WinID%, ahk_id %ta_WinID%
				 SetTimer, ta_tim_EditorSessions, 50
			}
	 }
Return

ta_tim_EditorSessions:
	 Loop, Parse, ta_EditorSessions, |
	 {
			If A_LoopField =
				 continue
			IfWinNotExist, ahk_id %A_LoopField%
			{
				 ta_func_RemoveEditorSession(A_LoopField)
				 If ta_InfoScreens1 = 1
						InfoScreen(ta_ScriptName,lng_ta_SourceClosed,255,3,"$2","000000",9, 290,"",1000,"C11")
				 Continue
			}
			FileGetTime, ta_SessionTime, % ta_SessionName%A_LoopField%, M
			If (ta_SessionTime <> ta_SessionTime%A_LoopField%)
			{
				 ta_Clipboard := ClipboardAll
				 FileRead, ta_Text, % ta_SessionName%A_LoopField%
				 Clipboard := ta_Text
				 If ta_InfoScreens1 = 1
						InfoScreen(ta_ScriptName,lng_ta_Pasting,255,1,"$2","000000",9, 250,"",1000,"C11")
				 SetKeyDelay, 10, 10
				 If ta_SessionClass%A_LoopField% not contains %ta_ControlSendApps%
				 {
						IfWinNotActive, ahk_id %A_LoopField%
						{
							 WinActivate, ahk_id %A_LoopField%
							 WinWaitActive, ahk_id %A_LoopField%
						}
						ControlFocus, % ta_SessionControl%A_LoopField%, ahk_id %A_LoopField%
						Send, {Ctrl down}^a{Ctrl up}
						If ta_SessionClass%A_LoopField% contains %ta_AlternativePasteApps%
							 Send, {Shift down}+{Ins}{Shift up}{Ctrl down}{Home}{Ctrl up}
						Else
							 Send, {Ctrl down}^v{Home}{Ctrl up}
				 }
				 Else
				 {
						ControlSend,% ta_SessionControl%A_LoopField%, {Ctrl down}^a{Ctrl up}, ahk_id %A_LoopField%
						Sleep,10
						If ta_SessionClass%A_LoopField% contains %ta_AlternativePasteApps%
							 ControlSend,% ta_SessionControl%A_LoopField%, {Shift down}{Ins}{Shift up}{Ctrl down}{Home}{Ctrl up}, ahk_id %A_LoopField%
						Else
							 ControlSend,% ta_SessionControl%A_LoopField%, {Ctrl down}^v{Home}{Ctrl up}, ahk_id %A_LoopField%
				 }
				 Sleep,100
				 Clipboard := ta_Clipboard
				 ta_SessionTime%A_LoopField% := ta_SessionTime
				 If ta_SessionControl%A_LoopField% not contains %ta_AlternativeSendApps%
						WinActivate, % "ahk_id " ta_EditorID%A_LoopField%
			}
			IfWinNotExist, % "ahk_id " ta_EditorID%A_LoopField%
			{
				 ta_func_RemoveEditorSession(A_LoopField)
				 If ta_InfoScreens1 = 1
						InfoScreen(ta_ScriptName,lng_ta_EditorClosed,255,3,"$2","000000",9, 290,"",1000,"C11")
			}
	 }
	 If ta_EditorSessions =
			SetTimer, ta_tim_EditorSessions, Off
Return

ta_func_RemoveEditorSession(WinID)
{
	 Global
	 StringReplace, ta_EditorSessions, ta_EditorSessions, %WinID%|,,A
	 FileDelete, % ta_SessionName%WinID%
	 ta_SessionName%WinID% =
	 ta_SessionClass%WinID% =
	 ta_SessionTime%WinID% =
	 ta_SessionControl%WinID% =
	 ta_EditorID%WinID% =
}

ta_sub_Hotkey_Switch:
	Send {shift up}{left}{shift down}{right 2}{shift up}
	func_GetSelection()
	ta_Selection := SubStr(Selection,0)SubStr(Selection,1,1)
	ta_IgnoreSelectAfterwards = 1
	Gosub,ta_sub_send_ta_Selection
	ta_IgnoreSelectAfterwards =
	Send {left}
Return

ta_sub_Hotkey_Flip:
	func_GetSelection()
	IfInString, Selection, /
	{
		StringReplace, ta_Selection, Selection, /, \, All
	}
	else
	IfInString, Selection, \
	{
		StringReplace, ta_Selection, Selection, \, /, All
	}
	else
	{
		ta_Selection := Selection
	}
	Gosub,ta_sub_send_ta_Selection
Return

ta_sub_Hotkey_PPChar:
	Critical
	func_GetSelection()
	ta_Selection := Selection
	lng_ta_inputString := lng_ta_inputBeginChar
	Gosub,ta_sub_GetInsertChar
	If (func_StrLeft(ta_Selection,1) = ta_inputString AND func_StrRight(ta_Selection,1) = ta_inputString)
		 ta_Selection := func_StrTrimChars(ta_Selection,ta_inputString)
	Else
		 ta_Selection := ta_inputString ta_Selection ta_inputString
	Gosub,ta_sub_send_ta_Selection
	Tooltip
Return

ta_sub_Hotkey_PPText:
	Critical
	func_GetSelection()
	ta_Selection := Selection
	lng_ta_inputString := lng_ta_inputBeginString lng_ta_inputConfirm
	Gosub,ta_sub_GetInsertString
	if (ta_Endkey = "Endkey:Enter")
	{
		ta_Selection := RegExReplace(ta_Selection,"(\R+)","$1" ta_inputString)
		ta_Selection := ta_inputString ta_Selection
	}
	if (ta_Endkey = "Endkey:Escape")
	{
		Tooltip
		Return
	}
	lng_ta_inputString := lng_ta_inputEndString lng_ta_inputConfirm
	Gosub,ta_sub_GetInsertString
	if (ta_Endkey = "Endkey:Enter")
	{
		ta_Selection := RegExReplace(ta_Selection,"(\R+)",ta_inputString "$1")
		ta_Selection := ta_Selection ta_inputString
		Gosub,ta_sub_send_ta_Selection
	}
	Tooltip
Return

ta_sub_Hotkey_Reformat:
	ta_Selection := ta_func_SetTextLineLength(func_GetSelection(),ta_LineLength, ta_AutoIndentPara%ta_AutoIndent1%%ta_AutoIndent2%, ta_keepLinebreaks, ta_replaceDoubleEmptyLines, ta_respectQuotation, ta_respectLists)
	If (ta_respectLists)
		ta_Selection := ta_func_SetTextLineLength(ta_Selection, ta_LineLength, ta_AutoIndentPara%ta_AutoIndent1%%ta_AutoIndent2%, ta_keepLinebreaks, ta_replaceDoubleEmptyLines, ta_respectQuotation, ta_respectLists)
	Gosub,ta_sub_send_ta_Selection
Return

ta_sub_Hotkey_FormatList:
	ta_newText =
	ta_Selection := func_GetSelection()
	StringSplit,ta_TempListEntry,ta_Selection,-
	Loop %ta_TempListEntry0% {
		if(ta_TempListEntry%A_Index% <> "")
		{
			ta_ThisListEntry := ta_TempListEntry%A_Index%
			AutoTrim, On
			ta_ThisListEntry = %ta_ThisListEntry%
			ta_ThisListEntry := " -" SubStr(ta_func_SetTextLineLength(ta_ThisListEntry,ta_LineLength, "   "),3)
			ta_newText := ta_newText "`n" ta_ThisListEntry
		}
	}
	ta_Selection = %ta_newText%
	Gosub,ta_sub_send_ta_Selection
Return

; -----------------------------------------------------------------------------
; === Functions ===============================================================
; -----------------------------------------------------------------------------

ta_func_SetTextLineLength( Text, LineLength, LineIndent = "", keepLinebreaks = 1, replaceDoubleEmptyLines = False, respectQuotation = false, respectLists = 0 ) {
	 Global A_SpaceLine,ta_TabWidth
	 AutoTrim, Off

	 Text := RegExReplace(Text,"\t", func_StrLeft(A_SpaceLine,ta_TabWidth)) ; Tabulator durch Leerzeichen ersetzen

	 If LineIndent = AutoParagraph
	 {
			RegExMatch(Text,"^[ \t\xA0]+",ParagraphIndent)
			LineIndent =
	 }
	 Else If LineIndent = Auto
	 {
			RegExMatch(Text,"^[ \t\xA0]+",LineIndent)
	 }
	 LineLength := LineLength - StrLen(LineIndent)
	 If LineLength < 1
			LineLength := 9999999999999999999999
	 Text := RegExReplace(Text,"([\w\xC0-\xFF])[-][ \t\xA0]*\R[ \t\xA0]*([a-z\xC0-\xDE])","$1$2") ; Getrennte Wörter zusammenführen
	 Text := RegExReplace(Text,"([\w\xC0-\xFF])([+/-])[ \t\xA0]*\R[ \t\xA0]*([\w\xC0-\xFF])","$1$2$3") ; Mit Zeichen verbundene Wörter zusammenführen
	 Text := RegExReplace(Text,"(^|\R)[ \t\xA0]+(\R)","$1$2") ; Leerzeilen säubern
	 If keepLinebreaks <> 2
			Text := RegExReplace(Text,"(^|\R)[ \t\xA0]+","$1") ; Leerzeichen am Zeilenanfang entfernen

	 If(respectQuotation)
			OptinalChars = >
	 If(respectLists=2)
			OptinalChars = %OptinalChars%1-9
	 If(respectLists)
			OptinalChars = %OptinalChars%\*-

	 If keepLinebreaks = 1
		 Text := RegExReplace(Text,"([^\r\n])\R([^\r\n" OptinalChars "])","$1 $2") ; nur einfache Zeilenumbrüche entfernen
	 Else If keepLinebreaks = 0
		 Text := RegExReplace(Text,"\R"," ") ; Zeilenumbrüche entfernen

	 ; Zitatzeilen Zussammenfassen
	 If (respectQuotation)
	 {
			Loop
			{
				 NewText := RegExReplace(Text,"(^|(?:^|\R)[^\r\n>]+)(?:(^|\R)(>[> ]+)([^\r\n>]+))(?:\R>[> ]+([^\r\n>]+))","$1$2$3$4 $5")
				 If (ErrorLevel <> 0 OR NewText = Text)
						break
				 Text := NewText
			}
	 }

	 If ParagraphIndent <>
	 {
			StringReplace, ParagraphIndentToken, ParagraphIndent, %A_Space%, %A_Tab%, A
			Text := ParagraphIndentToken . RegExReplace(Text,"(\R\R+)","$1" ParagraphIndentToken) ; Absatzeinrückung vorbereiten
	 }

	 Text := RegExReplace(Text,"([^ \xA0\r\n])[ \xA0][ \xA0]+([^ \xA0])","$1 $2") ; Doppelte Leerzeichen entfernen
	 Text := RegExReplace(Text,"([^ \xA0\r\n])[ \xA0][ \xA0]+([^ \xA0])","$1 $2") ; Doppelte Leerzeichen entfernen

	 If (StrLen(Text) <= LineLength)
	 {
			Result :=  LineIndent Text
			Return Result
	 }

	 Pos = 1
	 Loop
	 {
			Error := RegExMatch(Text,"m)[\w\xC0-\xFF\t\(\)\[\]\{\}'"",\.:;\?!#0-9]+[^\w\xC0-\xFF \r\n]*(?:[ \xA0]+|\R)?|[^\w\xC0-\xFF ]+(?:[ \xA0]+|\R)|[^\w\xC0-\xFF \r\n]+",Word,Pos)
			Pos := Pos+StrLen(Word)
			If (StrLen(Word) > LineLength) ; Überlange Zeilen
			{
				 Word := RegExReplace(Word,"([\w\xC0-\xFF]{" LineLength-1 "})[\w\xC0-\xFF]","$1-$2") ; extrem langes Wort trennen
				 If (keepLinebreaks)
				 {
						Word := RegExReplace(Word,"([^\r\n]{2," LineLength "})","$1`r`n")
						Line := Line "`r`n" Word
						Result := Result LineIndent Line
						Line =
						continue
				 }
				 Else
				 {
						Word := RegExReplace(Word,"([^\r\n]{" LineLength "})","$1`r`n")
						Line := Line "`r`n" Word
						If (RegExMatch(Line,"\R"))
						{
							 Result := Result LineIndent Line
							 RegExMatch(Line,"D).*\R(.*)$",NextLine)
							 StringTrimRight, Result, Result, % StrLen(NextLine1)
							 Line := NextLine1
							 Word =
						}
				 }
			}
			If (StrLen(Line)+StrLen(Word) <= LineLength) ; Zeile ergänzen, wenn noch nicht voll
			{
				 Line := Line Word
				 If (RegExMatch(Line,"\R"))
				 {
						Result := Result LineIndent Line
						RegExMatch(Line,"D).*\R(.*)$",NextLine)
						StringTrimRight, Result, Result, % StrLen(NextLine1)
						Line := NextLine1
				 }
			}
			Else ; Neue Zeile beginnen
			{
				 If(respectLists)
				 {
						RegExMatch(Line,"^[*-] +",ListBegin)
						If (ListBegin = "" AND respectLists = 2)
							 RegExMatch(Line,"^[1-9][0-9\w\.]*[0-9\w]*[.)] +|",ListBegin)
						If ListBegin =
							 RegExMatch(Line,"^  +",ListBegin)
				 }
				 If(respectQuotation)
						RegExMatch(Line,"^>[ >]+",CiteBegin)
				 If ListBegin <>
				 {
						ListBegin := func_StrLeft(A_SpaceLine, StrLen(ListBegin))
				 }
				 If(respectLists AND RegExMatch(Line,"^[1-9]") AND ListBegin = "") ; Falsches Aufzählungsformat
				 {
						RegExMatch(Result,"sD)(?:^|\R)([^\r\n]*)\R$",Match)
						If (StrLen(Match1)>0)
						{
							 StringTrimRight, Result, Result, % StrLen(Match1)
							 Line := Match1 Line
						}
				 }
				 If (InStr(Word,"`r`n") AND keepLinebreaks = 2)
						Result := Result LineIndent Line
				 Else
						Result := Result LineIndent Line "`r`n"
				 Line := ListBegin CiteBegin Word
			}

			If Error = 0 ; Kein weiteres Word gefunden
			{
				 Result := Result LineIndent Line "`r`n"
				 Break
			}
	 }
	 If (replaceDoubleEmptyLines)
			Result := RegExReplace(Result,"\R\R+","`r`n`r`n") ; Doppelte Leerzeilen Entfernen

	 Result := RegExReplace(Result,"sDU)^(.*)\R$","$1") ; Zeilenumbruch am Ende entfrenen

	 StringReplace, Result, Result, %A_Tab%, %A_Space%, A ; Absatzeinrückung anwenden

	 Return Result
}

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------
ta_sub_Send_ta_Selection:
	NoOnClipboardChange = 1
	ca_ClipSaved := ClipboardAll   ; Save the clipboard.
	Clipboard = %ta_Selection%
	If (aa_osversionnumber >= aa_osversionnumber_vista)
		Send ^v
	Else
		SendPlay ^v
	If (ta_SelectAfterwards = 1 AND ta_IgnoreSelectAfterwards = "")
	{
		 StringReplace,ta_tmp,ta_Selection,`n,,UseErrorLevel
		 ta_breaklinecount := ErrorLevel
		 ta_tmp =
		 ta_Len := StrLen(ta_Selection) - ta_breaklinecount
		 If (aa_osversionnumber >= aa_osversionnumber_vista)
		 {
			 Send {Left %ta_Len%}{Shift Down}{Right %ta_Len%}{Shift Up}
		 }
		 Else
			 SendPlay {Left %ta_Len%}{Shift Down}{Right %ta_Len%}{Shift Up}
	}

	Sleep, 50
	Clipboard := ca_ClipSaved   ; Restore the original clipboard.
	ca_ClipSaved =   ; Free the memory.
	 NoOnClipboardChange =
Return

ta_sub_GetInsertChar:
	ta_inputString =
	tooltip,%lng_ta_inputString%%ta_inputString%,% A_CaretX,% A_CaretY+20
	Input, ta_I_Key, * M L1,{Escape},
	ta_Endkey = %ErrorLevel%
	If ( ta_Endkey = "Endkey:Escape" )
		 Return
	ta_inputString := ta_inputString ta_I_Key
Return

ta_sub_GetInsertString:
	ta_inputString =
	Loop,
	{
		tooltip,%lng_ta_inputString%%ta_inputString%,% A_CaretX,% A_CaretY+20
		Input, ta_I_Key, * M L1,{BS}{Escape}{Enter},
		ta_Endkey = %ErrorLevel%
		If ( ta_Endkey = "Endkey:Enter" OR ta_Endkey = "Endkey:Escape" )
			break
		If ta_Endkey = Endkey:Backspace
			StringTrimRight, ta_inputString, ta_inputString, 1
		Else
		{
			ta_inputString := ta_inputString ta_I_Key
		}
	}
Return
