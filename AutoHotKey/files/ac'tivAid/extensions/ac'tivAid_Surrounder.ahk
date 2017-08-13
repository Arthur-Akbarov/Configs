	; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:              Surrounder
; -----------------------------------------------------------------------------
; Prefix:            srd_
; Version:           0.5
; Date:              2008-04-07
; Author:            Eric Werner
; Copyright:         2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; Kontext-sensitives Umklammerungszeichen-Setzen für Anführungszeichen,
; Klammern und allerlei mehr.
; Ohne, daß man neue Hotkeys lernt ganz einfach auf den gängien Tasten ", (
; oder } ...

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_Surrounder:
	Prefix = srd
	%Prefix%_ScriptName     = Surrounder
	%Prefix%_ScriptVersion  = 0.5
	%Prefix%_Author         = Eric Werner

	CustomHotkey_Surrounder = 0
	IconFile_On_Surrounder = %A_WinDir%\system32\shell32.dll
	IconPos_On_Surrounder = 134

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                   = %srd_ScriptName% - Markierungssensitives Umklammerunszeichen einfügen
		Description                = Fügt typische Umklammerungszeichen wie Anführungszeichen oder Klammern kontextsensitiv um markierten Text herum ein.
		lng_srd_checksText         = aktivieren für:
		lng_srd_bracketsText       = Klammern
		lng_srd_singleCharText     = Einzelzeichen
		lng_srd_addSingleChar      = Drücken Sie die Taste oder die Tastenkombination für das Zeichen, das Sie der Liste hinzufügen möchten (Esc = Abbruch).
		lng_srd_subSingleChar      = Drücken Sie die Taste oder die Tastenkombination für das Zeichen, das Sie aus Liste entfernen möchten (Esc = Abbruch).
		lng_srd_addCharErrorSimple = Einfache Buchstaben und Zahlen können nicht in die Liste aufgenommen werden!
		lng_srd_addCharErrorExists = Das Zeichen ist bereits in der Liste!
		lng_srd_addCharErrorSpecial= Für Klammerzeichen sowie `% und `` (Autohotkey-Steuerzeichen) gibt es separate Optionen!
		lng_srd_ParenthesesCheck   = (runde Klammern)
		lng_srd_SquareBracketCheck = [eckige Klammern]
		lng_srd_CurlyBracketCheck  = {geschweifte Klammern}
		lng_srd_PercentCheck       = `%Prozentzeichen`%
		lng_srd_BackTickCheck      = ``Backtick``
		lng_srd_AngleBracketCheck  = <spitze Klammer>
		lng_srd_AngleCloseTagCheck = > umschließt Auswahl mit </close tag>
		lng_srd_SelectAfterwards   = Markierung wiederherstellen
		lng_srd_englishKeyboard    = Englische Tastatur
		lng_srd_activate           = Aktiviere
		lng_srd_deactivate         = Deaktiviere
		lng_srd_IgnoreClasses      = Surrounder in folgenden Fenstern:
		lng_srd_ToggleSurrounding  = Umklammerung an/ausschalten
		lng_srd_SpecialQuotation   = „spezielle Anführungszeichen”
	}
	else       ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                   = %srd_ScriptName% - Selection-sensitive insertion of surrounding characters
		Description                = Inserts typical surrounding-characters context sensitive: if somethings selected: around the selection
		lng_srd_checksText         = enable for:
		lng_srd_bracketsText       = brackets
		lng_srd_singleCharText     = single characters
		lng_srd_addSingleChar      = Press the key or key-combination of the character you want to add to the list (Esc = cancel).
		lng_srd_subSingleChar      = Press the key or key-combination of the character you want to substract from the list (Esc = cancel).
		lng_srd_addCharErrorSimple = Simple letters and numbers cannot be taken into the list!
		lng_srd_addCharErrorExists = The character is already in the list!
		lng_srd_addCharErrorSpecial= There are extra options for bracket-characters and `% and `` (special Autohotkey characters)!
		lng_srd_ParenthesesCheck   = (parentheses)
		lng_srd_SquareBracketCheck = [brackets]
		lng_srd_CurlyBracketCheck  = {curly brackets}
		lng_srd_PercentCheck       = `%percent sign`%
		lng_srd_BackTickCheck      = ``backtick``
		lng_srd_AngleBracketCheck  = <angle bracket>
		lng_srd_AngleCloseTagCheck = use > does </close tag> on selection
		lng_srd_SelectAfterwards   = restore selection
		lng_srd_englishKeyboard    = english keyboard
		lng_srd_activate           = Activate
		lng_srd_deactivate         = Deactivate
		lng_srd_IgnoreClasses      = Surrounder in following windows:
		lng_srd_ToggleSurrounding  = toggle surrounding
		lng_srd_SpecialQuotation   = „use special quotation marks”
	}

	IniRead, srd_ParenthesesCheck, %ConfigFile%, Surrounder, ParenthesesCheck, 1
	IniRead, srd_SquareBracketCheck, %ConfigFile%, Surrounder, SquareBracketCheck, 1
	IniRead, srd_CurlyBracketCheck, %ConfigFile%, Surrounder, CurlyBracketCheck, 1
	IniRead, srd_PercentCheck, %ConfigFile%, Surrounder, PercentCheck, 0
	IniRead, srd_BackTickCheck, %ConfigFile%, Surrounder, BackTickCheck, 0
	IniRead, srd_AngleBracketCheck, %ConfigFile%, Surrounder, AngleBracketCheck, 0
	IniRead, srd_AngleCloseTagCheck, %ConfigFile%, Surrounder, AngleCloseTagCheck, 0
	IniRead, srd_SelectAfterwards, %ConfigFile%, Surrounder, SelectAfterwards, 1
	IniRead, srd_englishKeyboard, %ConfigFile%, Surrounder, EnglishKeyboard, 0
	IniRead, srd_IgnoreClasses, %ConfigFile%, Surrounder, IgnoreClasses, PuTTY,ConsoleWindowClass,ytWindow
	IniRead, srd_singleCharList, %ConfigFile%, Surrounder, singleCharList,"' ;"
	IniRead, srd_DeactivateInClasses, %ConfigFile%, Surrounder, DeactivateInClasses, 2
	IniRead, srd_ToggleSurrounding, %ConfigFile%, Surrounder, ToggleSurrounding, 1
	IniRead, srd_SpecialQuotation, %ConfigFile%, Surrounder, SpecialQuotation, 0

	Gosub, srd_prepareClassesGroup
Return

; -----------------------------------------------------------------------------
; === GUI =====================================================================
; -----------------------------------------------------------------------------

SettingsGui_Surrounder:
	Gui, Add, GroupBox, xs+15 y+5 w250 h120, %lng_srd_bracketsText%
		Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xp+10 yp+20 vsrd_ParenthesesCheck Checked%srd_ParenthesesCheck%, %lng_srd_ParenthesesCheck%
		Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged vsrd_SquareBracketCheck Checked%srd_SquareBracketCheck%, %lng_srd_SquareBracketCheck%
		Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged vsrd_CurlyBracketCheck Checked%srd_CurlyBracketCheck%, %lng_srd_CurlyBracketCheck%
		Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged vsrd_AngleBracketCheck Checked%srd_AngleBracketCheck%, %lng_srd_AngleBracketCheck%
			Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xp+10 y+5 vsrd_AngleCloseTagCheck Checked%srd_AngleCloseTagCheck%, %lng_srd_AngleCloseTagCheck%

	Gui, Add, GroupBox, xs+15 y+20 w250 h120, %lng_srd_singleCharText%
		Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xp+10 yp+20 vsrd_PercentCheck Checked%srd_PercentCheck%, %lng_srd_PercentCheck%
		Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged vsrd_BackTickCheck Checked%srd_BackTickCheck%, %lng_srd_BackTickCheck%
		Gui, Font, s11, Verdana
		Gui, Add, Edit, y+5 w180 vsrd_singleCharList Readonly, %srd_singleCharList%
		Gui, Font
		Gui, Add, Button, x+5 w20 h25 gsrd_sub_GetSingleChar_Add, +
		Gui, Add, Button, x+5 w20 h25 gsrd_sub_GetSingleChar_Sub, -
			Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+25 y+7 vsrd_SpecialQuotation Checked%srd_SpecialQuotation%, %lng_srd_SpecialQuotation%


	Gui, Add, GroupBox, xs+275 ys+15 w280 h200
	Gui, Add, DropDownList, xp+10 yp+15 w85 AltSubmit gsub_CheckIfSettingsChanged vsrd_DeactivateInClassesDDL, %lng_srd_activate%|%lng_srd_deactivate%
	GuiControl, Choose, srd_DeactivateInClassesDDL, %srd_DeactivateInClasses%
	Gui, Add, Text,x+3 yp+5, %lng_srd_IgnoreClasses%

	Gui, Add, Button, xp-90 yp+25 w20 h21 vsrd_Add_IgnoreClasses gsrd_sub_addApp, +
	Gui, Add, Button, w20 h21 vsrd_Sub_IgnoreClasses gsrd_sub_subApp, -

	; create srd_IgnoreClasses_Tmp - becomes the main list on next save
	srd_IgnoreClasses_Tmp := srd_IgnoreClasses
	Gui +Delimiter`,
	Gui, Add, ListBox, x+5 yp-28 w235 R11 vsrd_IgnoreClassesListBox,%srd_IgnoreClasses_Tmp%
	Gui +Delimiter|

	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+285 ys+225 vsrd_SelectAfterwards Checked%srd_SelectAfterwards%, %lng_srd_SelectAfterwards%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged vsrd_englishKeyboard Checked%srd_englishKeyboard%, %lng_srd_englishKeyboard%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged vsrd_ToggleSurrounding Checked%srd_ToggleSurrounding%, %lng_srd_ToggleSurrounding%
Return

SaveSettings_Surrounder:
	IniWrite, %srd_ParenthesesCheck%, %ConfigFile%, Surrounder, ParenthesesCheck
	IniWrite, %srd_SquareBracketCheck%, %ConfigFile%, Surrounder, SquareBracketCheck
	IniWrite, %srd_CurlyBracketCheck%, %ConfigFile%, Surrounder, CurlyBracketCheck
	IniWrite, %srd_AngleBracketCheck%, %ConfigFile%, Surrounder, AngleBracketCheck
	IniWrite, %srd_AngleCloseTagCheck%, %ConfigFile%, Surrounder, AngleCloseTagCheck
	IniWrite, %srd_PercentCheck%, %ConfigFile%, Surrounder, PercentCheck
	IniWrite, %srd_BackTickCheck%, %ConfigFile%, Surrounder, BackTickCheck
	IniWrite, %srd_SelectAfterwards%, %ConfigFile%, Surrounder, SelectAfterwards
	IniWrite, %srd_englishKeyboard%, %ConfigFile%, Surrounder, EnglishKeyboard
	IniWrite, %srd_singleCharList%, %ConfigFile%, Surrounder, singleCharList
	IniWrite, %srd_ToggleSurrounding%, %ConfigFile%, Surrounder, ToggleSurrounding
	IniWrite, %srd_SpecialQuotation%, %ConfigFile%, Surrounder, SpecialQuotation

	; put all changes to the main ignore-list:
	srd_IgnoreClasses := srd_IgnoreClasses_Tmp
	IniWrite, %srd_IgnoreClasses%, %ConfigFile%, Surrounder, IgnoreClasses

	; define the exclude mode, how to deal with the given classes:
	GuiControlGet, srd_DeactivateInClasses,, srd_DeactivateInClassesDDL
	IniWrite, %srd_DeactivateInClasses%, %ConfigFile%, Surrounder, DeactivateInClasses
	Gosub, srd_prepareClassesGroup
Return

AddSettings_Surrounder:
Return
CancelSettings_Surrounder:
Return

DoEnable_Surrounder:
	;single keys
	StringLen, srd_Len, srd_singleCharList
	Loop, %srd_Len%
	{
		srd_thisChar := SubStr(srd_singleCharList,A_Index,1)
		Hotkey, %srd_IncludeExcludeMode%, ahk_group srd_ClassesGroup
		Hotkey, $%srd_thisChar%, srd_singleChar, On, T2
	}
	; remember the current list as OLD list
	srd_old_singleCharList := srd_singleCharList

	if (srd_PercentCheck)
	{
		Hotkey, %srd_IncludeExcludeMode%, ahk_group srd_ClassesGroup
		Hotkey, $+5, srd_percent, On, T2
	}

	if (srd_BackTickCheck)
	{
		; added ´ on Shift+` or you're not able to write it at all.
		Hotkey, %srd_IncludeExcludeMode%, ahk_group srd_ClassesGroup
		Hotkey, $SC00D, srd_backTick, On, T2
		Hotkey, $+SC00D, srd_backTickback, On, T2
	}

	;bracket/left and right keys
	if (srd_ParenthesesCheck)
	{
		Hotkey, %srd_IncludeExcludeMode%, ahk_group srd_ClassesGroup
		Hotkey, $(, srd_lParenthesis, On, T2
		Hotkey, $), srd_rParenthesis, On, T2
	}

	;for english keyboards: don't use AltGr:
	if (srd_englishKeyboard)
	{
		if (srd_SquareBracketCheck)
		{
			Hotkey, %srd_IncludeExcludeMode%, ahk_group srd_ClassesGroup
			Hotkey, $[, srd_lSquareBracket, On, T2
			Hotkey, $], srd_rSquareBracket, On, T2
		}
		if (srd_CurlyBracketCheck)
		{
			Hotkey, %srd_IncludeExcludeMode%, ahk_group srd_ClassesGroup
			Hotkey, ${, srd_lCurlyBracket, On, T2
			Hotkey, $}, srd_rCurlyBracket, On, T2
		}
	}
	else
	{
		if (srd_SquareBracketCheck)
		{
			Hotkey, %srd_IncludeExcludeMode%, ahk_group srd_ClassesGroup
			Hotkey, $<^>!8, srd_lSquareBracket, On, T2
			Hotkey, $!^8,   srd_lSquareBracket, On, T2
			Hotkey, $<^>!9, srd_rSquareBracket, On, T2
			Hotkey, $!^9,   srd_rSquareBracket, On, T2
		}
		if (srd_CurlyBracketCheck)
		{
			Hotkey, %srd_IncludeExcludeMode%, ahk_group srd_ClassesGroup
			Hotkey, $<^>!7, srd_lCurlyBracket, On, T2
			Hotkey, $<^>!0, srd_rCurlyBracket, On, T2
			Hotkey, $^!7,   srd_rCurlyBracket, On, T2
			Hotkey, $^!0,   srd_rCurlyBracket, On, T2
		}
	}

	if (srd_AngleBracketCheck)
	{
		Hotkey, %srd_IncludeExcludeMode%, ahk_group srd_ClassesGroup
		Hotkey, $<, srd_lAngleBracket, On, T2
		Hotkey, $>, srd_rAngleBracket, On, T2
	}
Return

DoDisable_Surrounder:
	;single keys
	;disable the OLD list not the current one
	StringLen, srd_Len, srd_old_singleCharList
	Loop, %srd_Len%
	{
		srd_thisChar := SubStr(srd_old_singleCharList,A_Index,1)
		Hotkey, %srd_IncludeExcludeMode%, ahk_group srd_ClassesGroup
		Hotkey, %srd_thisChar%, srd_singleChar, Off
	}

	if (srd_PercentCheck)
	{
		Hotkey, %srd_IncludeExcludeMode%, ahk_group srd_ClassesGroup
		Hotkey, $+5, srd_percent, On, T2
	}

	if (srd_BackTickCheck)
	{
		Hotkey, %srd_IncludeExcludeMode%, ahk_group srd_ClassesGroup
		Hotkey, $SC00D, srd_backTick, Off
	}

	;left and right keys
	if (srd_ParenthesesCheck)
	{
		Hotkey, %srd_IncludeExcludeMode%, ahk_group srd_ClassesGroup
		Hotkey, $(, srd_lParenthesis, Off
		Hotkey, $), srd_rParenthesis, Off
	}

	;for english keyboards: don't use AltGr:
	if (srd_englishKeyboard)
	{
		if (srd_SquareBracketCheck)
		{
			Hotkey, %srd_IncludeExcludeMode%, ahk_group srd_ClassesGroup
			Hotkey, $[, srd_lSquareBracket, Off
			Hotkey, $], srd_rSquareBracket, Off
		}
		if (srd_CurlyBracketCheck)
		{
			Hotkey, %srd_IncludeExcludeMode%, ahk_group srd_ClassesGroup
			Hotkey, ${, srd_lCurlyBracket, Off
			Hotkey, $}, srd_rCurlyBracket, Off
		}
	}
	else
	{
		if (srd_SquareBracketCheck)
		{
			Hotkey, %srd_IncludeExcludeMode%, ahk_group srd_ClassesGroup
			Hotkey, $<^>!8, srd_lSquareBracket, Off
			Hotkey, $<^>!9, srd_rSquareBracket, Off
			Hotkey, $^!8,   srd_lSquareBracket, Off
			Hotkey, $^!9,   srd_rSquareBracket, Off
		}
		if (srd_CurlyBracketCheck)
		{
			Hotkey, %srd_IncludeExcludeMode%, ahk_group srd_ClassesGroup
			Hotkey, $<^>!7, srd_lCurlyBracket, Off
			Hotkey, $<^>!0, srd_rCurlyBracket, Off
			Hotkey, $^!7,   srd_lCurlyBracket, Off
			Hotkey, $^!0,   srd_rCurlyBracket, Off
		}
	}

	if (srd_AngleBracketCheck)
	{
		Hotkey, %srd_IncludeExcludeMode%, ahk_group srd_ClassesGroup
		Hotkey, $<, srd_lAngleBracket, Off
		Hotkey, $>, srd_rAngleBracket, Off
	}
Return

DefaultSettings_Surrounder:
Return
OnExitAndReload_Surrounder:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

;single keys
srd_singleChar:
	StringTrimLeft, srd_thisChar, A_ThisHotkey, 1
	func_GetSelection(1, 0, 0.05)
	srd_quoteSign = " ;"
	If ((srd_SpecialQuotation) AND (srd_thisChar = srd_quoteSign) AND (Selection != ""))
		srd_DecidePasteMode(Selection,"„",srd_SelectAfterwards,srd_ToggleSurrounding,1,"”")
	Else
		srd_DecidePasteMode(Selection,srd_thisChar,srd_SelectAfterwards,srd_ToggleSurrounding)
Return

srd_backTick:
	func_GetSelection(1, 0, 0.05)
	srd_thisChar = ``
	srd_DecidePasteMode(Selection,srd_thisChar,srd_SelectAfterwards,srd_ToggleSurrounding)
Return

srd_backTickback:
	func_GetSelection(1, 0, 0.05)
	srd_thisChar = ´
	srd_DecidePasteMode(Selection,srd_thisChar,srd_SelectAfterwards,srd_ToggleSurrounding)
Return

srd_percent:
	func_GetSelection(1, 0, 0.05)
	srd_DecidePasteMode(Selection,"%",srd_SelectAfterwards,srd_ToggleSurrounding)
Return

;left and right keys
srd_lParenthesis:
	func_GetSelection(1, 0, 0.05)
	srd_DecidePasteMode(Selection,"(",srd_SelectAfterwards,srd_ToggleSurrounding,1,")")
Return

srd_rParenthesis:
	func_GetSelection(1, 0, 0.05)
	srd_DecidePasteMode(Selection,")",srd_SelectAfterwards,srd_ToggleSurrounding,-1,"(")
Return

srd_lSquareBracket:
	func_GetSelection(1, 0, 0.05)
	srd_DecidePasteMode(Selection,"[",srd_SelectAfterwards,srd_ToggleSurrounding,1,"]")
Return

srd_rSquareBracket:
	func_GetSelection(1, 0, 0.05)
	srd_DecidePasteMode(Selection,"]",srd_SelectAfterwards,srd_ToggleSurrounding,-1,"[")
Return

srd_lCurlyBracket:
	func_GetSelection(1, 0, 0.05)
	srd_thisChar = {
	srd_thisOtherChar = }
	srd_DecidePasteMode(Selection,srd_thisChar,srd_SelectAfterwards,srd_ToggleSurrounding,1,srd_thisOtherChar)
Return

srd_rCurlyBracket:
	func_GetSelection(1, 0, 0.05)
	srd_thisChar = }
	srd_thisOtherChar = {
	srd_DecidePasteMode(Selection,srd_thisChar,srd_SelectAfterwards,srd_ToggleSurrounding,-1,srd_thisOtherChar)
Return

srd_lAngleBracket:
	func_GetSelection(1, 0, 0.05)
	srd_DecidePasteMode(Selection,"<",srd_SelectAfterwards,srd_ToggleSurrounding,1,">")
Return

srd_rAngleBracket:
	func_GetSelection(1, 0, 0.05)
	If (srd_AngleCloseTagCheck)
		srd_DecidePasteMode(Selection,">",srd_SelectAfterwards,srd_ToggleSurrounding,-1,"</")
	Else
		srd_DecidePasteMode(Selection,">",srd_SelectAfterwards,srd_ToggleSurrounding,-1,"<")
Return

; -----------------------------------------------------------------------------
; === Function(s) =============================================================
; -----------------------------------------------------------------------------

; prints the characters single or around a selection IF theres a selection
srd_DecidePasteMode(Selection, Char, srd_SelectAfterwards, srd_ToggleSurrounding, OpenClose=0, OtherChar=" ", indent=0)
{
	Global aa_osversionnumber, aa_osversionnumber_vista
	If (Selection != "")
	{
		srd_ClipSaved := ClipboardAll ; Save the clipboard.
		Clipboard =  ; Empty the clipboard.

		If (srd_ToggleSurrounding)
		{
			StringLen, srd_OtherCharLen, OtherChar
			StringLeft , srd_Left,  Selection, %srd_OtherCharLen%
			StringRight, srd_Right, Selection, 1

			If ((OpenClose = 1 AND srd_Left = Char AND srd_Right = OtherChar) OR (OpenClose = -1 AND srd_Left = OtherChar AND srd_Right = Char) OR (OpenClose = 0 AND srd_Left = Char AND srd_Right = Char))
			{  ; if first and last letter are the surrounding-characters: remove them
				StringTrimLeft, Selection, Selection, %srd_OtherCharLen%
				StringTrimRight, Selection, Selection, 1
				srd_SurroundingRemoved = 1
			}
		}

		If (!srd_SurroundingRemoved)
		{
			If (OpenClose == 1)
				Selection = %Char%%Selection%%OtherChar%
			Else If (OpenClose == -1)
				Selection = %OtherChar%%Selection%%Char%
			Else
				Selection = %Char%%Selection%%Char%
		}
		Clipboard := Selection
		ClipWait, 1.0

		If (aa_osversionnumber >= aa_osversionnumber_vista)
			Send, ^v
		Else
			SendPlay, ^v

		Sleep, 10
		Clipboard := srd_ClipSaved ; Restore the original clipboard.
		srd_ClipSaved =   ; Free the memory.

		If srd_SelectAfterwards
		{
			; snaky stolen from textAid:
			StringReplace,srd_tmp,Selection,`n,,UseErrorLevel
			srd_breaklinecount := ErrorLevel
			srd_tmp =
			srd_Len := StrLen(Selection) - srd_breaklinecount
			If (aa_osversionnumber >= aa_osversionnumber_vista)
				Send {Left %srd_Len%}{Shift Down}{Right %srd_Len%}{Shift Up}
			Else
				SendPlay {Left %srd_Len%}{Shift Down}{Right %srd_Len%}{Shift Up}
		}
	}
	Else ; just the single key
	{
		; workaround for coding apps that automatically do stuff on that keys:
		If ((Char == "}") && (!srd_englishKeyboard))
			Send, ^!0
		Else If ((Char == "{") && (!srd_englishKeyboard))
			Send, ^!7
		Else If ((Char == "[") && (!srd_englishKeyboard))
			Send, ^!8
		Else If ((Char == "]") && (!srd_englishKeyboard))
			Send, ^!9
		Else If (Char == "``")
			Send, {ASC 096}
		Else If (Char == "´")
			Send, {ASC 0180}
		Else
			Send, %Char%
	}
}

; gets a character to put into the single characer list
srd_sub_GetSingleChar_Add:
	Gosub DoDisable_Surrounder
	SplashImage,,b1 cwFFFF80 FS9 WS700, %lng_srd_addSingleChar%
	Input, srd_Input_Key, * M L1,{Escape},
	srd_Endkey = %ErrorLevel%
	SplashImage, Off
	Gosub DoEnable_Surrounder

	If ( srd_Endkey = "Endkey:Escape" )
		Return

	; is normal letter : break up
	RegExMatch(srd_Input_Key,"[a-z,A-Z,0-9]", srd_ForbiddenLetters)
	If (srd_ForbiddenLetters)
	{
		MsgBox,, Error!,%lng_srd_addCharErrorSimple%
		Return
	}
	; is already optianal letter : break up
	srd_optionChars = ```%()[]{}<>
	IfInString, srd_optionChars, %srd_Input_Key%
	{
		MsgBox,, Error!,%lng_srd_addCharErrorSpecial%
		Return
	}
	; is already in the list : break up
	IfInString, srd_singleCharList, %srd_Input_Key%
	{
		MsgBox,, Error!,%lng_srd_addCharErrorExists%
		Return
	}

	srd_singleCharList = %srd_singleCharList%%srd_Input_Key%
	GuiControl,, srd_singleCharList, %srd_singleCharList%
	func_SettingsChanged("Surrounder")
Return

; gets a character to take FROM the single characer list
srd_sub_GetSingleChar_Sub:
	Gosub DoDisable_Surrounder
	SplashImage,,b1 cwFFFF80 FS9 WS700, %lng_srd_subSingleChar%
	Input, srd_Input_Key, * M L1,{Escape},
	srd_Endkey = %ErrorLevel%
	SplashImage, Off
	Gosub DoEnable_Surrounder

	If ( srd_Endkey = "Endkey:Escape" )
		Return

	StringLen, srd_Len, srd_singleCharList
	srd_new_singleCharList =
	Loop, %srd_Len%
	{
		srd_thisChar := SubStr(srd_singleCharList,A_Index,1)

		if (srd_Input_Key != srd_thisChar)
			srd_new_singleCharList = %srd_new_singleCharList%%srd_thisChar%
	}

	srd_singleCharList := srd_new_singleCharList
	GuiControl,, srd_singleCharList, %srd_singleCharList%
	func_SettingsChanged("Surrounder")
Return

; collects exclude window-classes
; waits for the user to select a window and hit enter
srd_sub_addApp:
	WinSet,Bottom,, %ScriptTitle%
	SplashImage,,b1 cwFFFF80 FS9 WS700, %lng_AddApps%
	Gui,+Disabled
	Input,srd_GetKey,,{Enter}{ESC}
	StringReplace,srd_GetKey,ErrorLevel,Endkey:
	SplashImage, Off
	Gui,-Disabled
	WinGetClass, srd_GetName, A

	If srd_Getkey = Enter
	{
		IfNotInstring, srd_IgnoreClasses_Tmp, %srd_GetName%
		{
			If (srd_IgnoreClasses_Tmp != "")
				srd_IgnoreClasses_Tmp := srd_IgnoreClasses_Tmp "," srd_GetName
			Else
				srd_IgnoreClasses_Tmp := srd_GetName

			Gui +Delimiter`,
			GuiControl,, srd_IgnoreClassesListBox,,%srd_IgnoreClasses_Tmp%
			Gui +Delimiter|
		}
	}
	Gui,Show
	WinSet, Top, , %ScriptTitle%
	func_SettingsChanged("Surrounder")
Return

; takes the selected item from the ignore list
srd_sub_subApp:
	GuiControlGet, srd_selItem,, srd_IgnoreClassesListBox
	StringSplit, srd_IgnoreClasses_List, srd_IgnoreClasses_Tmp,`,
	srd_IgnoreClasses_Tmp =
	Loop, %srd_IgnoreClasses_List0%
	{
		srd_thisItem := srd_IgnoreClasses_List%A_Index%
		If (srd_thisItem != srd_selItem)
		{
			If (srd_IgnoreClasses_Tmp != "")
				srd_IgnoreClasses_Tmp := srd_IgnoreClasses_Tmp "," srd_thisItem
			Else
				srd_IgnoreClasses_Tmp := srd_thisItem
		}
		Else
		{
			func_SettingsChanged("Surrounder")
			Reload = 1
		}
	}
	Gui +Delimiter`,
	GuiControl,, srd_IgnoreClassesListBox,,%srd_IgnoreClasses_Tmp%
	Gui +Delimiter|
Return

srd_prepareClassesGroup:
	; put all classes into an ahk_group:
	Loop, parse, srd_IgnoreClasses, `,
		GroupAdd, srd_ClassesGroup, ahk_class %A_LoopField%

	If (srd_DeactivateInClasses == 2)
		srd_IncludeExcludeMode = IfWinNotActive
	Else
		srd_IncludeExcludeMode = IfWinActive
Return
