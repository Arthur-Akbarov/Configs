; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               HotStrings
; -----------------------------------------------------------------------------
; Prefix:             hs_
; Version:            1.41
; Date:               2008-05-23
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

#IfWinActive
#IfWinExist
#Include *i settings\Hotstrings.ini
#IfWinActive
#IfWinExist

init_HotStrings:
	Prefix = hs
	%Prefix%_ScriptName          = HotStrings
	%Prefix%_ScriptVersion       = 1.41
	%Prefix%_Author              = Wolfgang Reszel
	ConfigFile_Hotstrings        = settings\Hotstrings.ini
	AddSettings_Hotstrings       = 1
	DisableIfCompiled_Hotstrings = 1

	IconFile_On_HotStrings = %A_WinDir%\system32\shell32.dll
	IconPos_On_HotStrings  = 134

	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %hs_ScriptName% - Automatische Textbausteine
		Description                   = Ersetzt eingegebene Abkürzungen automatisch mit Textbausteinen.
		DescriptionEXE                = Ersetzt eingegebene Abkürzungen automatisch mit Textbausteinen. (In der EXE-Version von ac'tivAid ist HotStrings nicht konfigurierbar.)
		DescriptionSelf               = Ersetzt eingegebene Abkürzungen automatisch mit Textbausteinen. (Nicht konfigurierbar, da die Hotstrings.ini Kommentare enthält. Die Datei wird anscheinend mit einem Texteditor gepflegt.)
		lng_hs_Name                   = Abkürzung/Kürzel
		lng_hs_OptionDirect           = Direkt ersetzen (sonst bei Leerzeichen, Enter ...)
		lng_hs_OptionOmitEnd          = Zeichen, welches die Ersetzung aufruft ignorieren
		lng_hs_OptionInside           = Ersetzung auch innerhalb von Wörtern
		lng_hs_OptionRaw              = Text so ausgeben, wie er eingegeben wurde (keine Steuerzeichen möglich)
		lng_hs_OptionAutoBS           = Abkürzung/Kürzel nicht durch Textbaustein ersetzen, sondern ergänzen
		lng_hs_OptionSendPlay         = SendPlay-Modus
		lng_hs_OptionAutoEscape       = !, +, ^, und # in Alt, Shift, Strg und Windows umsetzen
		lng_hs_OptionCase             = Klein-/Großschreibung der Abkürzung
		lng_hs_OptionCase1            = beachten
		lng_hs_OptionCase2            = ignorieren
		lng_hs_OptionCase3            = ignorieren und nicht umsetzen
		lng_hs_New                    = (neu)
		lng_hs_Duplicate              = Doppelter Eintrag bei HotStrings
		lng_hs_TextMode1              = Textbaustein
		lng_hs_TextMode2              = AutoHotkey-Befehle
		lng_hs_SyntaxCheck            = HotString auf Fehler überprüfen
		lng_hs_NoErrors               = Keine Syntax-Fehler gefunden!
		lng_hs_Only                   = Nur
		lng_hs_Not                    = Nicht
		lng_hs_Application            = für Programm (Fenstertitel)
		lng_hs_AllApps                = Alle Programme
		lng_hs_ClipSave               = Zwischenablage in Datei speichern
		tooltip_hs_HotstringOption_Direct= Die Ersetzung durch den Textbaustein erfolgt direkt `nnach der Eingabe des letzten Zeichens des Kürzels.`nNützlich für eigene Ersetzungszeichen (ahk#, mfg# ...)
		tooltip_hs_HotstringOption_OmitEnd= Das Zeichen, auf das der Textbaustein eingefügt wird, `nwird nicht mit ausgegeben. Nützlich wenn z.B. hinter `ndem Textbaustein direkt weitergeschrieben werden soll.
		tooltip_hs_HotstringOption_Inside= Eine Abkürzung wird auch dann erkannt, `nwenn sie innerhalb eines Wortes steht.
		tooltip_hs_HotstringOption_AutoBS= Die Abkürzung wird nicht durch den Textbaustein ersetzt, `nsondern der Textbaustein hinter die eingegebene `nAbkürzung eingefügt.
		tooltip_hs_HotstringOption_Raw  = Der Textbaustein wird genau wie hier eingetragen ausgegeben, `nSteuerbefehle wie {Enter}, {Left}, {Home}, ^, # etc. werden `nnicht durch die entsprechenden Tastatureingaben ersetzt.
		tooltip_hs_HotstringOption_AutoEscape= Mit dieser Option werden die Zeichen !, +, ^, und # wie von AutoHotkey `ngewohnt als Steuerzeichen für Alt, Shift, Strg und Windows umgesetzt.`n1+1 steht dann z.B. für 1 gefolgt von Shift+1.
		tooltip_hs_HotstringOption_Case1= Die Abkürzung wird nur erkannt und durch den Textbaustein`nersetzt, wenn sie exakt in ihrer definierten Schreibweise eingegeben wurde.
		tooltip_hs_HotstringOption_Case2= Die Abkürzung wird unabhängig von ihrer Schreibweise erkannt.`nWird die Abkürzung allerdings komplett in Großbuchstaben`ngeschrieben, wird ebenfalls der Textbaustein komplett in `nGroßbuchstaben ausgegeben.
		tooltip_hs_HotstringOption_Case3= Die Abkürzung wird unabhängig von ihrer Schreibweise erkannt.`nDer Textbaustein wird immer so ausgegeben, wie er hier eingetragen wurde.
		tooltip_hs_HotstringApp         = Die Abkürzung wird nur in dem angegebenen Programm durch den Textbaustein ersetzt.
		tooltip_hs_HotstringOption_SendPlay= Alternative Ausgabemethode, welche z. B. die Kompatibilität zu Spielen erhöht.
	}
	Else        ; = other languages (english)
	{
		MenuName                      = %hs_ScriptName% - automatic text replacement
		Description                   = Replaces typed abbreviations automatically with text.
		DescriptionEXE                = Replaces typed abbreviations automatically with text. (Not configurable in the exe-version of ac'tivAid)
		DescriptionSelf               = Replaces typed abbreviations automatically with text. (Not configurable because Hotstrings.ini contains comments. It assumes that the file will be administered with a text-editor.)
		lng_hs_Name                   = Abbreviation
		lng_hs_OptionDirect           = replace immediately (otherwise after Space, Enter ...)
		lng_hs_OptionOmitEnd          = ignore the character which causes the replacement
		lng_hs_OptionInside           = replace inside words
		lng_hs_OptionRaw              = output control-commands like {Enter}{Left} as plain text
		lng_hs_OptionAutoBS           = don't replace abbreviation but append the text
		lng_hs_OptionSendPlay         = SendPlay mode
		lng_hs_OptionAutoEscape       = substitute !, +, ^, and # with Alt, Shift, Ctrl or Windows
		lng_hs_OptionCase             = case sensitivity
		lng_hs_OptionCase1            = yes
		lng_hs_OptionCase2            = ignore case
		lng_hs_OptionCase3            = ignore case and don't transpose case
		lng_hs_New                    = (new)
		lng_hs_Duplicate              = duplicate entry at HotStrings
		lng_hs_TextMode1              = Text
		lng_hs_TextMode2              = AutoHotkey-commands
		lng_hs_SyntaxCheck            = syntax-check HotString
		lng_hs_NoErrors               = No syntax-errors found!
		lng_hs_Only                   = Only
		lng_hs_Not                    = Not
		lng_hs_Application            = for this Appl. (window title)
		lng_hs_AllApps                = All applications
		lng_hs_ClipSave               = Save clipboard as file
		tooltip_hs_HotstringOption_Direct= The replacement occurs directly after the last keystroke of the abbreviation.`nUseful if you want a special replacement letter (sy. or sy# ...)
		tooltip_hs_HotstringOption_OmitEnd= The character that causes the insertion will not be written.`nFor example if a space triggers the replacement and`nyou want to type right after the text.
		tooltip_hs_HotstringOption_Inside= The abbreviation will be recognised even if you're typing within a word.
		tooltip_hs_HotstringOption_AutoBS= The abbreviation will not be overwritten but amended by the text.
		tooltip_hs_HotstringOption_Raw  = The text will be inserted just like its written here.`nCommands like {Enter}, ^, # ... will be written`ninstead of executing keystrokes.
		tooltip_hs_HotstringOption_AutoEscape= Characters like !, +, ^, and # will invoke usual Autohotkey keystrokes`nlike Alt, Shift, Ctrl and Windows key.`nFor example "1+1" will result in "1 Shift+1".
		tooltip_hs_HotstringOption_Case1= The replacement only occurs when the case is exactly as in the abbreviation.
		tooltip_hs_HotstringOption_Case2= The replacement occurs no matter what case`nbut the case of the abbreviation affects the replacement.
		tooltip_hs_HotstringOption_Case3= The replacement occurs as given no matter what case.
		tooltip_hs_HotstringApp         = The replacement only occurs in a window with the given title or ahk_class.
		tooltip_hs_HotstringOption_SendPlay= Alternate method to send the keystrokes.`nMay improve compatiblity in games for instance.
	}

	hs_Defaults = `:*C1`:ahk#`:`:AutoHotkey`n`:*`:se#`:`:Stephan Ehrmann`n`:O`:mfg`:`:Mit freundlichen Grüßen``r``rIhre c't-Redaktion+{Home} `; don't escape modifiers`n`:*`:wr#`:`:Wolfgang Reszel`n`:*`:sg#`:`:Sehr geehrte Damen und Herren{Left 17}+{Right 17} `; don't escape modifiers`n:*:morgen#::`n   Morgen = `%A_Now`%`n   EnvAdd`, Morgen`, 1`, Days`n   FormatTime`, Morgen`, `%Morgen`%`, dd.MM.yyyy`n   Send`, `%Morgen`%`nReturn

	hs_CheckChars = (`",`{ ;}"n++ syntaxhighlightfix
	
	If CustomLanguage <>
		gosub, CustomLanguage

	If Enable_Hotstrings <> 1
		hs_FilenameAdd = .disabled

	If A_IsCompiled <> 1
	{
		IfNotExist, %ConfigFile_Hotstrings%
			IfNotExist, %ConfigFile_Hotstrings%.disabled
				FileAppend, %hs_Defaults%, %ConfigFile_Hotstrings%%hs_FilenameAdd%
	}
	Else If Enable_Hotstrings = 1
	{
		ConfigFile_Hotstrings        = settings\Hotstrings_exe.ini
		IfNotExist, settings\Hotstrings.ini
			FileInstall, settings\Hotstrings.ini, settings/hotstrings_exe.ini, 1
		Description = %DescriptionEXE%
	}

	FileReadLine, hs_ReadLine, %ConfigFile_Hotstrings%%hs_FilenameAdd%, 1
	If (func_StrLeft(hs_ReadLine,1) = "`;")
		Description = %DescriptionSelf%
Return

SettingsGui_HotStrings:
	func_AddMessage(0x100, "hs_sub_OnMessage_Keys")
	AutoTrim, Off
	IniRead, hs_Selected, %ConfigFile%, %hs_ScriptName%, Selected, 1
	hs_Hotstrings = 0
	hs_MultiLineHotstrings = 0
	hs_Apps =
	hs_NotApps =
	hs_ExternalFile =
	hs_External =
	hs_HotstringFiles = %ConfigFile_Hotstrings%%hs_FilenameAdd%`n
	hs_HotstringIncludes =
	Loop
	{
		StringGetPos, hs_Pos, hs_HotstringFiles, `n
		If ErrorLevel
			Break
		hs_actHotstringFile := func_StrLeft(hs_HotstringFiles, hs_Pos)
		StringTrimLeft, hs_HotstringFiles, hs_HotstringFiles, % hs_Pos+1
		If hs_actHotstringFile =
			Break

		If A_Index > 1
		{
			SplitPath, hs_actHotstringFile, hs_ExternalFile,,,,hs_ExternalDrive
			If hs_ExternalDrive =
				hs_ExternalFile = %hs_actHotstringFile%
			Else
				hs_ExternalFile := hs_ExternalDrive "\...\" hs_ExternalFile
		}

		Loop, Read, %hs_actHotstringFile%
		{
			AutoTrim,On
			hs_LoopReadLine = %A_LoopReadLine%
			AutoTrim,Off

			If (hs_LoopReadLine = "" OR func_StrLeft(hs_LoopReadLine,2) = ";*" OR func_StrLeft(hs_LoopReadLine,2) = ";;" OR func_StrLeft(hs_LoopReadLine,2) = ";!" OR func_StrLeft(hs_LoopReadLine,2) = ";-" OR func_StrLeft(hs_LoopReadLine,2) = ";=" OR func_StrLeft(hs_LoopReadLine,3) = "; -" OR func_StrLeft(hs_LoopReadLine,3) = "; =" )
				continue
			hs_Hotstrings++
			hs_HotstringExternal[%hs_Hotstrings%] = %hs_ExternalFile%

			If (func_StrLeft(hs_LoopReadLine,1) = "`;")
			{
				If (hs_BeginComment = "" AND hs_Hotstrings > 1)
				{
					hs_HotstringName[%hs_Hotstrings%] = %A_Space%
					hs_Hotstrings++
				}
				If hs_BeginComment = 1
					hs_Hotstrings--
				AutoTrim,On
				StringTrimLeft, hs_LoopReadLine, hs_LoopReadLine, 1
				hs_LoopReadLine = %hs_LoopReadLine%
				If hs_HotstringName[%hs_Hotstrings%] =
				{
					hs_HotstringName[%hs_Hotstrings%] = —— %hs_LoopReadLine% ———————————————————————————————————
					If A_OSversion = WIN_NT4
						StringReplace, hs_HotstringName[%hs_Hotstrings%], hs_HotstringName[%hs_Hotstrings%], —, --, All
					hs_UndoHotstringName[%hs_Hotstrings%] := hs_HotstringName[%hs_Hotstrings%]
				}
				hs_HotstringText[%hs_Hotstrings%] := hs_HotstringText[%hs_Hotstrings%] hs_LoopReadLine "`r"
				hs_UndoHotstringText[%hs_Hotstrings%] := hs_HotstringText[%hs_Hotstrings%]
				AutoTrim,Off
				If hs_actHotstringFile = %ConfigFile_Hotstrings%
					hs_DisableEditing = 1
				hs_BeginComment = 1
				hs_HotstringExternal[%hs_Hotstrings%] = %hs_ExternalFile%
				continue
			}
			If (func_StrLeft(hs_LoopReadLine,8) = "#Include")
			{
				hs_ExtFile = %A_LoopReadLine%
				hs_HotstringIncludes = %hs_HotstringIncludes%%A_LoopReadLine%`n
				StringReplace, hs_ExtFile, hs_ExtFile, #Include
				StringReplace, hs_ExtFile, hs_ExtFile, *i
				AutoTrim, On
				hs_ExtFile = %hs_ExtFile%
				AutoTrim, Off
				hs_HotstringFiles = %hs_HotstringFiles%%hs_ExtFile%`n
				hs_HotStrings--
				continue
			}
			hs_BeginComment =
			hs_Hotstring4 =
			If (hs_LoopReadLine = "#IfWinActive," OR hs_LoopReadLine = "#IfWinActive")
			{
				hs_AppTmp =
				hs_AppModeTmp = 1
				hs_HotStrings--
				continue
			}
			IfInstring, hs_LoopReadLine, #IfWinActive
			{
				AutoTrim, On
				StringReplace, hs_AppTmp, hs_LoopReadLine, #IfWinActive,
				StringReplace, hs_AppTmp, hs_AppTmp, `, ,
				hs_AppTmp = %hs_AppTmp%
				If hs_AppTmp <>
					hs_Apps := hs_Apps "|" hs_AppTmp " "
				AutoTrim, Off
				hs_AppModeTmp = 1
				hs_HotStrings--
				continue
			}
			IfInstring, hs_LoopReadLine, #IfWinNotActive
			{
				AutoTrim, On
				StringReplace, hs_AppTmp, hs_LoopReadLine, #IfWinNotActive,
				StringReplace, hs_AppTmp, hs_AppTmp, `, ,
				hs_AppTmp = %hs_AppTmp%
				If hs_AppTmp <>
					hs_NotApps := hs_NotApps "|" hs_AppTmp " "

				AutoTrim, Off
				hs_HotStrings--
				hs_AppModeTmp = 2
				continue
			}
			hs_HotstringApp[%hs_Hotstrings%] = %hs_AppTmp%
			hs_HotstringExternal[%hs_Hotstrings%] = %hs_ExternalFile%
			hs_UndoHotstringExternal[%hs_Hotstrings%] = %hs_ExternalFile%
			hs_HotstringAppMode[%hs_Hotstrings%] = %hs_AppModeTmp%
			hs_UndoHotstringApp[%hs_Hotstrings%] = %hs_AppTmp%
			hs_UndoHotstringAppMode[%hs_Hotstrings%] = %hs_AppModeTmp%
			If hs_MultiLineHotstrings = 0
			{
				;separate HotString parts into hs_Hotstring-array:
				hs_getHotstringParts(hs_LoopReadLine)

				hs_HotstringOptions[%hs_Hotstrings%] = %hs_Hotstring1%
				AutoTrim, On
				hs_HotstringName[%hs_Hotstrings%] = %hs_Hotstring2%
				AutoTrim, Off
				hs_HotstringText[%hs_Hotstrings%] = %hs_Hotstring3%
				If hs_HotstringText[%hs_Hotstrings%] =
					hs_MultiLineHotstrings = 1

				hs_TextMode[%hs_HotStrings%] = 1
				hs_UndoTextMode[%hs_HotStrings%] = 1

				If hs_Hotstring4 contains don't escape modifiers
					hs_HotstringESC[%hs_Hotstrings%] = 1
				Else
					hs_HotstringESC[%hs_Hotstrings%] = 0
				hs_UndoHotstringOptions[%hs_Hotstrings%] = %hs_Hotstring1%
				hs_UndoHotstringName[%hs_Hotstrings%] = %hs_Hotstring2%
				hs_UndoHotstringText[%hs_Hotstrings%] = %hs_Hotstring3%
				hs_UndoHotstringESC[%hs_Hotstrings%] := hs_HotstringESC[%A_Index%]
			}
			Else
			{
				hs_HotStrings--
				AutoTrim, On
				hs_LoopReadLine = %A_LoopReadLine%
				If hs_LoopReadLine = Return
				{
					hs_MultiLineHotstrings = 0
					continue
				}
				hs_HotstringESC[%hs_Hotstrings%] = 1
				If hs_HotstringText[%hs_Hotstrings%] <>
					hs_HotstringText[%hs_Hotstrings%] := hs_HotstringText[%hs_Hotstrings%] "__NewLine__"
				hs_HotstringText[%hs_Hotstrings%] := hs_HotstringText[%hs_Hotstrings%] hs_LoopReadLine
				hs_UndoHotstringText[%hs_Hotstrings%] := hs_HotstringText[%hs_Hotstrings%]
				hs_TextMode[%hs_Hotstrings%] = 2
				hs_UndoTextMode[%hs_HotStrings%] = 2
				AutoTrim, Off
			}
		}
	}

	hs_HotstringBox =
	Loop, %hs_Hotstrings%
	{
		If (hs_HotstringApp[%A_Index%] = "" OR hs_HotstringAppMode[%A_Index%] = 2)
			hs_HotstringBox := hs_HotstringBox hs_HotstringName[%A_Index%] " |"

		If hs_TextMode[%A_Index%] = 2
			hs_AddNewLine = __NewLine__
		Else
			hs_AddNewLine =

		If (func_StrLeft(hs_HotstringName[%A_Index%],3) = "—— " )
			hs_HotStringText := "——————— ——————  —————   ————    ———     ——      —"
		Else
			hs_HotStringText := hs_HotstringText[%A_Index%]

		if (hs_HotstringApp[%A_Index%] <> "" AND hs_HotstringAppMode[%A_Index%] = 1)
			func_CreateListOfHotkeys( "Hotstring::" hs_HotstringOptions[%A_Index%] ":" hs_HotstringName[%A_Index%], hs_HotstringText hs_AddNewLine, "HotStrings","", lng_hs_Only " " hs_HotstringApp[%A_Index%] )
		Else if (hs_HotstringApp[%A_Index%] <> "" AND hs_HotstringAppMode[%A_Index%] = 2)
			func_CreateListOfHotkeys( "Hotstring::" hs_HotstringOptions[%A_Index%] ":" hs_HotstringName[%A_Index%], hs_HotstringText hs_AddNewLine, "HotStrings","", lng_hs_Not " " hs_HotstringApp[%A_Index%] )
		Else
			func_CreateListOfHotkeys( "Hotstring::" hs_HotstringOptions[%A_Index%] ":" hs_HotstringName[%A_Index%], hs_HotstringText hs_AddNewLine, "HotStrings" )
	}

	If (A_IsCompiled = 1 OR hs_DisableEditing = 1)
		hs_Disabled = Disabled
	Else
		hs_Disabled =

	Sort, hs_Apps, D| U
	hs_Apps = %lng_hs_AllApps%%hs_Apps%

	Sort, hs_NotApps, D| U
	hs_NotApps = %hs_NotApps%

	Gui, Add, DropDownList, xs+10 y+3 W150 vhs_AppFilter ghs_sub_SelectApp, %hs_Apps%
	GuiControl, ChooseString, hs_AppFilter, %lng_hs_AllApps%

	Gui, Add, ListBox, xs+10 y+5 R16 W150 AltSubmit vhs_HotstringBox ghs_sub_Select, %hs_HotstringBox%
	Gui, Add, Text, x+10 yp-23 %hs_Disabled%, %lng_hs_Name%:
	Gui, Add, Edit, Limit30 x+5 ghs_sub_Store yp-3 W295 vhs_HotstringName %hs_Disabled%,
	Gui, Add, Radio, y+7 xs+170 vhs_TextMode1 ghs_sub_Store -Wrap %hs_Disabled%, %lng_hs_TextMode1%
	Gui, Add, Radio, x+10 vhs_TextMode2 ghs_sub_Store -Wrap %hs_Disabled%, %lng_hs_TextMode2%:
	Gui, Add, Checkbox, x+80 ghs_sub_Store vhs_HotstringOption_SendPlay -Wrap %hs_Disabled%, %lng_hs_OptionSendPlay%
	Gui, Add, Edit, y+2 xs+170 ghs_sub_Store vhs_HotstringText R4 W390 %hs_Disabled%,
	Gui, Add, Checkbox, y+3 ghs_sub_Store vhs_HotstringOption_Direct -Wrap %hs_Disabled%,%lng_hs_OptionDirect%
	Gui, Add, Checkbox, y+3 ghs_sub_Store vhs_HotstringOption_OmitEnd -Wrap %hs_Disabled%,%lng_hs_OptionOmitEnd%
	Gui, Add, Checkbox, y+3 ghs_sub_Store vhs_HotstringOption_Inside -Wrap %hs_Disabled%,%lng_hs_OptionInside%
	Gui, Add, Checkbox, y+3 ghs_sub_Store vhs_HotstringOption_AutoBS -Wrap %hs_Disabled%,%lng_hs_OptionAutoBS%
	Gui, Add, Checkbox, y+3 ghs_sub_Store vhs_HotstringOption_Raw -Wrap %hs_Disabled%,%lng_hs_OptionRaw%
	Gui, Add, Checkbox, y+3 ghs_sub_Store vhs_HotstringOption_AutoEscape -Wrap %hs_Disabled%,%lng_hs_OptionAutoEscape%
	Gui, Add, Text, y+9 %hs_Disabled%, %lng_hs_OptionCase%:
	Gui, Add, Radio, y+3 ghs_sub_Store vhs_HotstringOption_Case1 -Wrap %hs_Disabled%,%lng_hs_OptionCase1%
	Gui, Add, Radio, x+5 ghs_sub_Store vhs_HotstringOption_Case2 -Wrap %hs_Disabled%,%lng_hs_OptionCase2%
	Gui, Add, Radio, x+5 ghs_sub_Store vhs_HotstringOption_Case3 -Wrap %hs_Disabled%,%lng_hs_OptionCase3%
	Gui, Add, Text, y+12
	Gui, Add, Radio, xs+170 yp %hs_Disabled% -Wrap ghs_sub_Store vhs_HotstringAppMode1, %lng_hs_Only%
	Gui, Add, Radio, x+1 %hs_Disabled% -Wrap ghs_sub_Store vhs_HotstringAppMode2, %lng_hs_Not%
	Gui, Add, Text, x+1 %hs_Disabled%, %lng_hs_Application%:
	Gui, Add, Edit, x+5 ghs_sub_Store yp-3 W175 vhs_HotstringApp %hs_Disabled%,

	Gui, Add, Button, -Wrap xs+10 ys+255 w25 ghs_sub_ListBox_add vhs_sub_ListBox_add %hs_Disabled%, +
	Gui, Add, Button, -Wrap x+5 w25 vhs_Remove_HotstringBox ghs_sub_ListBox_remove %hs_Disabled%, %MinusString%

	Gui, Add, Button, -Wrap xs+515 ys+122 ghs_sub_Undo vhs_sub_Undo w45 h15 %hs_Disabled%, Undo

	Gui, Add, Button, xs+390 w180 ys+290 %hs_Disabled% h15 vhs_sub_ClipSave ghs_sub_ClipSave, %lng_hs_ClipSave%

	Gui, Add, Button, -Wrap xs+312 ys+312 w165 Hidden vhs_SyntaxCheck ghs_sub_SyntaxCheck %hs_Disabled%, %lng_hs_SyntaxCheck%

	hs_GuiElements = %lng_hs_Name%:,##hs_HotstringName,hs_TextMode1,hs_TextMode2,hs_HotstringOption_SendPlay,##hs_HotstringText,hs_HotstringOption_Direct,hs_HotstringOption_OmitEnd,hs_HotstringOption_Inside,hs_HotstringOption_AutoBS,hs_HotstringOption_Raw,hs_HotstringOption_AutoEscape,%lng_hs_OptionCase%:,hs_HotstringOption_Case1,hs_HotstringOption_Case2,hs_HotstringOption_Case3,hs_HotstringAppMode1,hs_HotstringAppMode2,%lng_hs_Application%:,##hs_HotstringApp,hs_sub_Undo,hs_sub_ClipSave,hs_SyntaxCheck
	hs_IsSyntaxChecked =
	hs_SelectedRow =

	If (hs_Selected > hs_Hotstrings OR hs_Selected < 1)
		hs_Selected = 1
	SetTimer, hs_sub_SelectAfterGuiBuild, -10
	AutoTrim, On
Return

hs_sub_SelectAfterGuiBuild:
	GuiControl,Choose, hs_HotstringBox, %hs_Selected%
	hs_lastHotstringExternal = 0
	If DontShowMainGUI =
		Gosub, hs_sub_Select
	GuiControl, %GuiID_activAid%:Focus, OptionsListBox
Return

AddSettings_HotStrings:
	If AddFreshSettings = 1
		hs_HotStrings = 0

	AddResult = 0
	hs_AppTmp =
	hs_AppMode =
	Loop, Read, %AddFile%
	{
		If (A_LoopReadLine = "" AND A_Index = 1)
			continue
		IfInstring, A_LoopReadLine, `; [Hot
			continue
		IfInstring, A_LoopReadLine, #IfWinActive
		{
			AutoTrim, On
			StringReplace, hs_AppTmp, A_LoopReadLine, #IfWinActive,
			StringReplace, hs_AppTmp, hs_AppTmp, `, ,
			hs_AppTmp = %hs_AppTmp%
			AutoTrim, Off
			If hs_AppTmp <>
			{
				StringReplace, hs_Apps, hs_Apps, "|" hs_AppTmp " ",, A
				hs_Apps := hs_Apps "|" hs_AppTmp " "
			}
			hs_AppModeTmp = 1
			continue
		}
		IfInstring, A_LoopReadLine, #IfWinNotActive
		{
			AutoTrim, On
			StringReplace, hs_AppTmp, A_LoopReadLine, #IfWinNotActive,
			StringReplace, hs_AppTmp, hs_AppTmp, `, ,
			hs_AppTmp = %hs_AppTmp%
			AutoTrim, Off
			If hs_AppTmp <>
			{
				StringReplace, hs_NotApps, hs_NotApps, "|" hs_AppTmp " ",, A
				hs_NotApps := hs_NotApps "|" hs_AppTmp " "
			}
			hs_AppModeTmp = 2
			continue
		}
		hs_Hotstring4 =
		StringReplace, hs_Hotstring, A_LoopReadLine, :,
		StringReplace, hs_Hotstring, hs_Hotstring, :, ‡
		StringReplace, hs_Hotstring, hs_Hotstring, :`:, ‡
		StringReplace, hs_Hotstring, hs_Hotstring, % " `; " , ‡
		StringSplit, hs_Hotstring, hs_Hotstring, ‡
		hs_HotstringOptionsTmp = %hs_Hotstring1%
		AutoTrim, On
		hs_HotstringNameTmp = %hs_Hotstring2%
		AutoTrim, Off
		hs_HotstringTextTmp = %hs_Hotstring3%
		If hs_Hotstring4 contains don't escape modifiers
			hs_HotstringESCTmp = 1
		Else
			hs_HotstringESCTmp = 0

		hs_Duplicates = 0

		hs_Line2 :=  ":" hs_HotstringNameTmp ":`:"

		Loop, %hs_Hotstrings%
		{
			hs_Line1 :=  ":" hs_HotstringName[%A_Index%] ":`:"
;         hs_Line1 :=  ":" hs_HotstringOptions[%A_Index%] ":" hs_HotstringName[%A_Index%] ":`:"
;         hs_Line2 :=  ":" hs_HotstringOptionsTmp ":" hs_HotstringNameTmp ":`:"
			If (hs_Line1 = hs_Line2)
			{
				hs_Duplicates++
				break
			}
		}
		If hs_Duplicates = 0
		{
			hs_Hotstrings++
			hs_HotstringApp[%hs_Hotstrings%] = %hs_AppTmp%
			hs_HotstringAppMode[%hs_Hotstrings%] = %hs_AppModeTmp%
			hs_HotstringOptions[%hs_Hotstrings%] = %hs_HotstringOptionsTmp%
			hs_HotstringName[%hs_Hotstrings%] = %hs_HotstringNameTmp%
			hs_HotstringText[%hs_Hotstrings%] = %hs_HotstringTextTmp%
			hs_HotstringESC[%hs_Hotstrings%] := hs_HotstringESCTmp
			hs_UndoHotstringApp[%hs_Hotstrings%] = %hs_AppTmp%
			hs_UndoHotstringAppMode[%hs_Hotstrings%] = %hs_AppModeTmp%
			hs_UndoHotstringOptions[%hs_Hotstrings%] = %hs_HotstringOptionsTmp%
			hs_UndoHotstringName[%hs_Hotstrings%] = %hs_HotstringNameTmp%
			hs_UndoHotstringText[%hs_Hotstrings%] = %hs_HotstringTextTmp%
			hs_UndoHotstringESC[%hs_Hotstrings%] := hs_HotstringESCTmp
		}
	}

	Gosub, hs_sub_Refresh
	func_SettingsChanged("Hotstrings")
	;Gosub, hs_sub_Store
Return

hs_sub_SelectApp:
	GuiControlGet, hs_AppFilter
	StringReplace, hs_AppFilter, hs_AppFilter, %lng_hs_AllApps%
	AutoTrim, On
	hs_AppFilter = %hs_AppFilter%
	hs_HotstringBox = |
	Loop, %hs_Hotstrings%
	{
		If (hs_HotstringApp[%A_Index%] = hs_AppFilter AND hs_HotStringAppMode[%A_Index%] = 1 AND hs_AppFilter <> "" )
		{
			hs_HotstringBox := hs_HotstringBox hs_HotstringName[%A_Index%] " |"
		}
		Else If (hs_AppFilter = "" AND (hs_HotstringApp[%A_Index%] = "" OR hs_HotStringAppMode[%A_Index%] = 2) )
			hs_HotstringBox := hs_HotstringBox hs_HotstringName[%A_Index%] " |"

	}
	GuiControl,,hs_HotStringBox, %hs_HotstringBox%
	GuiControl,Choose,hs_HotStringBox, 1
	Gosub, hs_sub_Select
Return

hs_sub_Select:
	Critical
	AutoTrim, Off
	If hs_Store = 1
		return

	hs_NoStore = 2

	hs_LastSelectedRow = %hs_SelectedRow%

	GuiControlGet, hs_SelectedRow,, hs_HotstringBox

	If hs_SelectedRow =
	{
		GuiControl,,hs_HotstringText,
		GuiControl,,hs_HotstringName,
		GuiControl,,hs_HotstringApp,
		GuiControl,,hs_HotstringOption_Direct,0
		GuiControl,,hs_HotstringOption_AutoBS,0
		GuiControl,,hs_HotstringOption_Sendplay,0
		GuiControl,,hs_HotstringOption_OmitEnd,0
		GuiControl,,hs_HotstringOption_Inside,0
		GuiControl,,hs_HotstringOption_Raw,0
		GuiControl,,hs_HotstringOption_Case1,0
		GuiControl,,hs_HotstringOption_Case2,0
		GuiControl,,hs_HotstringOption_Case3,0
		GuiControl,,hs_HotstringAppMode1,0
		GuiControl,,hs_HotstringAppMode2,0
		GuiControl,,hs_HotstringOption_AutoEscape,0
		Return
	}

	If hs_SelectedRow <> %hs_LastSelectedRow%
		hs_IsSyntaxChecked = 1

	AutoTrim, On
	if hs_AppFilter = %lng_hs_AllApps%
		hs_AppFilter =

	hs_AppFilter = %hs_AppFilter%
	AutoTrim, Off

	hs_FoundSel = 0
	Loop, %hs_Hotstrings%
	{
		hs_AppTmp := hs_HotstringApp[%A_Index%]
		If hs_HotstringAppMode[%A_Index%] = 2
			hs_AppTmp =

		If hs_AppTmp = %hs_AppFilter%
		{
			hs_FoundSel++
			If hs_FoundSel = %hs_SelectedRow%
			{
				hs_Selected = %A_Index%
				break
			}
		}
	}


	If ( hs_Disabled = "" AND hs_HotstringExternal[%hs_Selected%] <> hs_lastHotstringExternal )
	{
		Loop, Parse, hs_GuiElements, `,
		{
			If hs_HotstringExternal[%hs_Selected%] <>
			{
				IfInString, A_LoopField, ##
				{
					StringTrimLeft, hs_LoopField, A_LoopField, 2
					GuiControl,+Readonly,%hs_LoopField%
				}
				Else
					GuiControl,Disable,%A_LoopField%
			}
			Else
			{
				IfInString, A_LoopField, ##
				{
					StringTrimLeft, hs_LoopField, A_LoopField, 2
					GuiControl,-Readonly,%hs_LoopField%
				}
				Else
					GuiControl,Enable,%A_LoopField%
			}
		}
	}
	hs_lastHotstringExternal := hs_HotstringExternal[%hs_Selected%]
	If hs_HotstringExternal[%hs_Selected%] <>
		hs_External := "  « " hs_HotstringExternal[%hs_Selected%] " »"
	Else
		hs_External =


	hs_TextMode := hs_TextMode[%hs_selected%]
	GuiControl,,hs_TextMode%hs_TextMode%, 1
	GuiControlGet,hs_TextMode2,,,

	hs_HotstringText := hs_HotstringText[%hs_Selected%]
	If hs_TextMode <> 2
	{
		StringReplace, hs_HotstringText, hs_HotstringText,``n,`r`n, All
		StringReplace, hs_HotstringText, hs_HotstringText, ``r, `r`n, All
	}
	StringReplace, hs_HotstringText, hs_HotstringText,__NewLine__,`r`n, All
	StringReplace, hs_HotstringText, hs_HotstringText, ``t, %A_Tab%, All
	StringReplace, hs_HotstringText, hs_HotstringText, ```;, `;, All
	StringReplace, hs_HotstringText, hs_HotstringText, ```:, `:, All

	If hs_HotstringESC[%hs_Selected%] = 0
	{
		StringReplace, hs_HotstringText, hs_HotstringText, {!}, !, All
		StringReplace, hs_HotstringText, hs_HotstringText, {^}, ^, All
		StringReplace, hs_HotstringText, hs_HotstringText, {+}, +, All
		StringReplace, hs_HotstringText, hs_HotstringText, {#}, #, All
	}
	StringReplace, hs_HotstringText, hs_HotstringText,````,``, All

	GuiControl,,hs_HotstringText, %hs_HotstringText%
	GuiControl,,hs_HotstringName, % hs_HotstringName[%hs_Selected%] hs_External
	GuiControl,,hs_HotstringApp, % hs_HotstringApp[%hs_Selected%]
	hs_OptionDirect = 0
	hs_OptionAutoBS = 0
	hs_OptionSendplay = 0
	hs_OptionInside = 0
	hs_OptionOmitEnd = 0
	hs_OptionRaw = 0
	hs_OptionCase1 = 0
	hs_OptionCase2 = 0
	hs_OptionCase3 = 0
	hs_HotstringOptions := hs_HotstringOptions[%hs_Selected%]
	IfInString, hs_HotstringOptions, *
		hs_OptionDirect = 1
	IfInString, hs_HotstringOptions, ?
		hs_OptionInside = 1
	IfInString, hs_HotstringOptions, B0
		hs_OptionAutoBS = 1
	IfInString, hs_HotstringOptions, O
		hs_OptionOmitEnd = 1
	IfInString, hs_HotstringOptions, R
		hs_OptionRaw = 1
	IfInString, hs_HotstringOptions, SP
		hs_OptionSendplay = 1

	IfInString, hs_HotstringOptions, C1
	{
		hs_OptionCase3 = 1
		StringReplace, hs_HotstringOptions, hs_HotstringOptions, C1,
	}
	IfInString, hs_HotstringOptions, C0
	{
		hs_OptionCase2 = 1
		StringReplace, hs_HotstringOptions, hs_HotstringOptions, C0,
	}
	IfInString, hs_HotstringOptions, C
		hs_OptionCase1 = 1

	If (hs_OptionCase1 = 0 AND hs_OptionCase2 = 0 AND hs_OptionCase3 = 0 )
		hs_OptionCase2 = 1

	hs_AppMode1 = 0
	hs_AppMode2 = 0
	If hs_HotstringAppMode[%hs_Selected%] = 2
		hs_AppMode2 = 1
	Else
		hs_AppMode1 = 1

	If (hs_Disabled <> "Disabled" AND hs_HotstringExternal[%hs_Selected%] = "")
	{
		If hs_TextMode = 2
		{
			hs_LastTextMode2 = %hs_TextMode2%
			hs_LastHotStringText = %hs_HotStringText%

			GuiControl, Disable, hs_HotstringOption_Raw
			GuiControl, Disable, hs_HotstringOption_AutoEscape
			If hs_IsSyntaxChecked = 1
			{
				GuiControl, Enable,hs_AppFilter
				GuiControl, Enable,hs_HotstringBox
				If hs_Duplicates < 1
				{
					GuiControl, Hide,hs_SyntaxCheck
					GuiControl, Enable,MainGuiOK
;               GuiControl, Enable,MainGuiApply
					GuiControl, Show,MainGuiApply
				}
				GuiControl, Enable, OptionsListBox
			}
			Else
			{
				GuiControl, Disable,MainGuiApply
				GuiControl, Hide,MainGuiApply
				GuiControl, Disable,hs_AppFilter
				GuiControl, Disable,hs_HotstringBox
				GuiControl, Disable,MainGuiOK
				GuiControl, Disable, OptionsListBox
				GuiControl, Show,hs_SyntaxCheck
			}
		}
		Else
		{
			GuiControl, Enable,hs_AppFilter
			GuiControl, Enable,hs_HotstringBox
			If hs_Duplicates < 1
			{
				GuiControl, Hide,hs_SyntaxCheck
				GuiControl, Enable,MainGuiOK
;            GuiControl, Enable,MainGuiApply
				GuiControl, Show,MainGuiApply
			}
			GuiControl, Enable, OptionsListBox

			GuiControl, Enable, hs_HotstringOption_Raw
			GuiControl, Enable, hs_HotstringOption_AutoEscape
			GuiControl, Hide, hs_SyntaxCheck
		}
	}
	GuiControl,,hs_HotstringOption_Direct, %hs_OptionDirect%
	GuiControl,,hs_HotstringOption_AutoBS, %hs_OptionAutoBS%
	GuiControl,,hs_HotstringOption_Sendplay, %hs_OptionSendplay%
	GuiControl,,hs_HotstringOption_OmitEnd, %hs_OptionOmitEnd%
	GuiControl,,hs_HotstringOption_Inside, %hs_OptionInside%
	GuiControl,,hs_HotstringOption_Raw, %hs_OptionRaw%
	GuiControl,,hs_HotstringOption_Case1, %hs_OptionCase1%
	GuiControl,,hs_HotstringOption_Case2, %hs_OptionCase2%
	GuiControl,,hs_HotstringOption_Case3, %hs_OptionCase3%
	GuiControl,,hs_HotstringAppMode1, %hs_AppMode1%
	GuiControl,,hs_HotstringAppMode2, %hs_AppMode2%
	GuiControl,,hs_HotstringOption_AutoEscape, % (hs_HotstringESC[%hs_Selected%]=1) ? 1 : 0
	If (hs_Disabled <> "Disabled" AND hs_HotstringExternal[%hs_Selected%] = "")
	{
		If hs_NoFocus =
		{
			GuiControl,Focus,hs_HotStringName
			Send,+{End}
		}
		hs_NoFocus =
	}
	AutoTrim, On
Return

hs_sub_Store:
	Critical
	If hs_NoStore > 0
	{
		hs_NoStore--
		Return
	}

	Gosub, sub_CheckIfSettingsChanged
	AutoTrim, On
	GuiControlGet,hs_HotstringName,,,
	hs_HotStringName = %hs_HotStringName%
	If hs_HotStringName =
		hs_HotStringName := " "
	AutoTrim, Off
	GuiControlGet,hs_HotstringText,,,
	GuiControlGet,hs_HotstringApp,,,
	GuiControlGet,hs_HotstringAppMode1,,,
	GuiControlGet,hs_HotstringAppMode2,,,
	GuiControlGet,hs_HotstringOption_Direct,,,
	GuiControlGet,hs_HotstringOption_AutoBS,,,
	GuiControlGet,hs_HotstringOption_SendPlay,,,
	GuiControlGet,hs_HotstringOption_OmitEnd,,,
	GuiControlGet,hs_HotstringOption_Inside,,,
	GuiControlGet,hs_HotstringOption_Raw,,,
	GuiControlGet,hs_HotstringOption_Case1,,,
	GuiControlGet,hs_HotstringOption_Case2,,,
	GuiControlGet,hs_HotstringOption_Case3,,,
	GuiControlGet,hs_HotstringOption_AutoEscape,,,
	GuiControlGet,hs_TextMode2,,,

	If hs_TextMode2 = 1
	{
		GuiControl, Disable, hs_HotstringOption_Raw
		GuiControl, Disable, hs_HotstringOption_AutoEscape
		hs_HotstringOption_AutoEscape = 1
		hs_HotstringOption_Raw = 0
		GuiControl,, hs_HotstringOption_AutoEscape, %hs_HotstringOption_AutoEscape%

		;tooltip, %hs_IsSyntaxChecked% %hs_TextMode2% <> %hs_LastTextMode2% OR %hs_HotStringText% <> %hs_LastHotStringText%,,,2

		If ((hs_TextMode2 <> hs_LastTextMode2 OR hs_HotStringText <> hs_LastHotStringText) and hs_IsSyntaxChecked < 2 )
		{
			;tooltip, %hs_IsSyntaxChecked% %hs_TextMode2% <> %hs_LastTextMode2% OR %hs_HotStringText% <> %hs_LastHotStringText%,,,2
			hs_IsSyntaxChecked =
		}

		If hs_IsSyntaxChecked > 0
		{
			GuiControl, Enable,hs_AppFilter
			GuiControl, Enable,hs_HotstringBox
			If hs_Duplicates < 1
			{
				GuiControl, Enable,MainGuiOK
				GuiControl, Enable,MainGuiApply
				GuiControl, Show,MainGuiApply
				GuiControl, Hide,hs_SyntaxCheck
			}
			GuiControl, Enable, OptionsListBox
			If (hs_HotStringText <> hs_LastHotStringText)
				hs_IsSyntaxChecked = 1
		}
		Else
		{
			GuiControl, Show,hs_SyntaxCheck
			GuiControl, Disable,hs_AppFilter
			GuiControl, Disable,hs_HotstringBox
			GuiControl, Disable,MainGuiOK
			GuiControl, Disable,MainGuiApply
			GuiControl, Hide,MainGuiApply
			GuiControl, Disable, OptionsListBox
		}

	}
	Else
	{
		GuiControl, Enable,hs_AppFilter
		GuiControl, Enable,hs_HotstringBox
		If hs_Duplicates < 1
		{
			GuiControl, Enable,MainGuiOK
			GuiControl, Enable,MainGuiApply
			GuiControl, Show,MainGuiApply
			GuiControl, Hide,hs_SyntaxCheck
		}
		GuiControl, Enable, OptionsListBox

		GuiControl, Enable, hs_HotstringOption_Raw
		GuiControl, Enable, hs_HotstringOption_AutoEscape
	}

	hs_LastTextMode2 = %hs_TextMode2%
	hs_LastHotStringText = %hs_HotStringText%

	if hs_HotstringName =
		hs_HotstringName = |

	If hs_TextMode2 <> 1
		StringReplace, hs_HotstringText, hs_HotstringText, ``, ````, All
	StringReplace, hs_HotstringText, hs_HotstringText, ``!, __altsym__, All
	StringReplace, hs_HotstringText, hs_HotstringText, ``^, __ctrlsym__, All
	StringReplace, hs_HotstringText, hs_HotstringText, ``+, __shiftsym__, All
	StringReplace, hs_HotstringText, hs_HotstringText, ``#, __winsym__, All
	StringReplace, hs_HotstringText, hs_HotstringText, `r`n, __NewLine__, All
	StringReplace, hs_HotstringText, hs_HotstringText, `n, __NewLine__, All
	StringReplace, hs_HotstringText, hs_HotstringText, %A_Tab%, ``t, All
	StringReplace, hs_HotstringText, hs_HotstringText, `;, ```;, All
	StringReplace, hs_HotstringText, hs_HotstringText, `:, ```:, All

	If (func_StrRight( hs_HotstringText, 11) = "__NewLine__")
		StringTrimRight, hs_HotstringText,hs_HotstringText, 11

	If hs_HotstringOption_AutoEscape = 0
	{
		StringReplace, hs_HotstringText, hs_HotstringText, !, {!}, All
		StringReplace, hs_HotstringText, hs_HotstringText, ^, {^}, All
		StringReplace, hs_HotstringText, hs_HotstringText, +, {+}, All
		StringReplace, hs_HotstringText, hs_HotstringText, #, {#}, All
	}
	StringReplace, hs_HotstringText, hs_HotstringText, __altsym__, ``!, All
	StringReplace, hs_HotstringText, hs_HotstringText, __ctrlsym__, ``^, All
	StringReplace, hs_HotstringText, hs_HotstringText, __shiftsym__, ``+, All
	StringReplace, hs_HotstringText, hs_HotstringText, __winsym__, ``#, All

	hs_HotstringName[%hs_Selected%] := hs_HotstringName
	hs_HotstringApp[%hs_Selected%] := hs_HotstringApp

	hs_HotstringAppMode[%hs_Selected%] := hs_HotStringAppMode1 * 1 + hs_HotStringAppMode2 * 2

	If hs_HotStringAppMode2 = 1
		hs_HotStringApp =

	hs_HotstringText[%hs_Selected%] := hs_HotstringText
	hs_HotstringESC[%hs_Selected%] := hs_HotstringOption_AutoEscape
	If hs_TextMode2 = 1
		hs_TextMode[%hs_Selected%] := 2
	Else
		hs_TextMode[%hs_Selected%] := 1

	hs_HotstringOptions[%hs_Selected%] =

	If hs_HotstringOption_Direct = 1
		hs_HotstringOptions[%hs_Selected%] := hs_HotstringOptions[%hs_Selected%] "*"
	If hs_HotstringOption_Inside = 1
		hs_HotstringOptions[%hs_Selected%] := hs_HotstringOptions[%hs_Selected%] "?"
	If hs_HotstringOption_AutoBS = 1
		hs_HotstringOptions[%hs_Selected%] := hs_HotstringOptions[%hs_Selected%] "B0"
	If hs_HotstringOption_SendPlay = 1
		hs_HotstringOptions[%hs_Selected%] := hs_HotstringOptions[%hs_Selected%] "SP"
	If hs_HotstringOption_OmitEnd = 1
		hs_HotstringOptions[%hs_Selected%] := hs_HotstringOptions[%hs_Selected%] "O"
	If hs_HotstringOption_Raw = 1
		hs_HotstringOptions[%hs_Selected%] := hs_HotstringOptions[%hs_Selected%] "R"
	If hs_HotstringOption_Case3 = 1
		hs_HotstringOptions[%hs_Selected%] := hs_HotstringOptions[%hs_Selected%] "C1"
	If hs_HotstringOption_Case2 = 1
		hs_HotstringOptions[%hs_Selected%] := hs_HotstringOptions[%hs_Selected%] ""
	If hs_HotstringOption_Case1 = 1
		hs_HotstringOptions[%hs_Selected%] := hs_HotstringOptions[%hs_Selected%] "C"

	AutoTrim, On

	hs_AppFilter = %hs_HotStringApp%

	Gosub, hs_sub_Refresh
Return

hs_sub_Refresh:
	AutoTrim, On

	if hs_AppFilter = %lng_hs_AllApps%
		hs_AppFilter =

	hs_AppFilter = %hs_AppFilter%

	AutoTrim, Off

	hs_HotstringBox = |
	hs_Apps =
	hs_NotApps =
	hs_Duplicates = 0
	Loop, %hs_Hotstrings%
	{
		hs_AppTmp := hs_HotstringApp[%A_Index%]

		If hs_AppTmp <>
			If hs_HotstringAppMode[%A_Index%] = 2
				hs_NotApps := hs_NotApps "|" hs_AppTmp " "
			Else
				hs_Apps := hs_Apps "|" hs_AppTmp " "

		If hs_HotstringAppMode[%A_Index%] = 2
			hs_AppTmp =

		If hs_AppTmp = %hs_AppFilter%
			hs_HotstringBox := hs_HotstringBox hs_HotstringName[%A_Index%] " |"

		hs_Index1 := A_Index
		hs_Line1 :=  ":" hs_HotstringOptions[%hs_Index1%] ":" hs_HotstringName[%hs_Index1%] ":`:" hs_HotstringApp[%hs_Index1%] hs_HotstringAppMode[%hs_Index1%]
		Loop, %hs_HotStrings%
		{
			hs_Line2 :=  ":" hs_HotstringOptions[%A_Index%] ":" hs_HotstringName[%A_Index%] ":`:" hs_HotstringApp[%A_Index%] hs_HotstringAppMode[%A_Index%]
			If (InStr(hs_Line1,hs_Line2,1) AND hs_Index1 <> A_Index)
			{
				hs_Duplicates++
			}
		}
	}
	Sort, hs_Apps, D| U
	Sort, hs_NotApps, D| U
	;Sort, hs_HotStringBox, D|

	hs_Apps = |%lng_hs_AllApps%%hs_Apps%

	if (hs_AppFilter = "" OR !InStr(hs_Apps, hs_AppFilter) )
		hs_AppFilter := lng_hs_AllApps
	Else
		hs_AppFilter := hs_AppFilter " "

	GuiControl,, hs_AppFilter, %hs_Apps%
	GuiControl,ChooseString, hs_AppFilter, % hs_AppFilter

	StringTrimLeft, hs_Apps, hs_Apps, 1

	Coordmode, ToolTip, Relative
	if hs_Duplicates > 0
	{
		GuiControl, Disable, MainGuiOK
		GuiControl, Disable, MainGuiApply
		ToolTip, %lng_hs_Duplicate%, 400, 155,7
	}
	Else If hs_IsSyntaxChecked = 1
	{
		GuiControl, Enable, MainGuiOK
		GuiControl, Enable, MainGuiApply
		ToolTip, ,,,7
	}

	GuiControl,, hs_HotstringBox, %hs_HotstringBox%

	AutoTrim, On
	if hs_AppFilter = %lng_hs_AllApps%
		hs_AppFilter =

	hs_AppFilter = %hs_AppFilter%
	AutoTrim, Off

	hs_FoundSel = 0

	If (hs_Selected < 1 OR hs_LastAppFilter <> hs_AppFilter)
	{
		Loop, %hs_Hotstrings%
		{
			hs_AppTmp := hs_HotstringApp[%A_Index%]
			If hs_HotstringAppMode[%A_Index%] = 2
				hs_AppTmp =

			If hs_AppTmp = %hs_AppFilter%
			{
				hs_FoundSel++
				If (hs_HotstringOptions[%A_Index%] ":" hs_HotstringName[%A_Index%] = hs_HotstringOptions[%hs_Selected%] ":" hs_HotstringName[%hs_Selected%])
				{
					hs_SelectedRow = %hs_FoundSel%
					break
				}
			}
		}

	}
	GuiControl,Choose,hs_HotstringBox, %hs_SelectedRow%

	hs_LastAppFilter = %hs_AppFilter%

	AutoTrim, On
Return

hs_sub_SyntaxCheck:
	If hs_HotstringText not contains If%A_Space%,Send,SendRaw,IfWin,WinGet,MsgBox,Loop,Run,ToolTip,%hs_CheckChars%
	{
		StringReplace, hs_HotstringText, hs_HotstringText, __NewLine__, % "`nSend, {Enter}", All
		hs_HotstringText := "Send, " hs_HotstringText
		StringReplace, hs_HotstringText, hs_HotstringText, __NewLine__, % "`n", All
		GuiControl, , hs_HotStringText, %hs_HotStringText%
	}
	Else
		StringReplace, hs_HotstringText, hs_HotstringText, __NewLine__, % "`n   ", All

	FileAppend, #Singleinstance Off`n#NoTrayIcon`nExitApp`n, syntaxcheck.tmp
	FileAppend, #Include HotStrings_SyntaxCheck.tmp`n, syntaxcheck.tmp
	FileAppend, %hs_HotStringText%, HotStrings_SyntaxCheck.tmp
	FileAppend, `nReturn`n#Include %A_Scriptfullpath%, HotStrings_SyntaxCheck.tmp
	hs_IsSyntaxChecked = 0
	RunWait, %A_AhkPath% "%A_ScriptFullPath%"
	If ErrorLevel = 0
	{
		ToolTip, %lng_hs_NoErrors%
		sleep 500
		ToolTip
		hs_IsSyntaxChecked = 2
		hs_LastHotStringText = %hs_HotStringText%
	}
	FileDelete, HotStrings_SyntaxCheck.tmp
	FileDelete, syntaxcheck.tmp
	Gosub, hs_sub_Store
Return

hs_sub_ListBox_remove:
	AutoTrim, Off
	Gosub, hs_sub_Store

	GuiControlGet,hs_SelectedPrev,, hs_HotstringBox

	Loop, %hs_Hotstrings%
	{
		If A_Index < %hs_Selected%
			continue
		hs_Index := A_Index + 1
		hs_HotstringName[%A_Index%] := hs_HotstringName[%hs_Index%]
		hs_HotstringApp[%A_Index%] := hs_HotstringApp[%hs_Index%]
		hs_HotstringAppMode[%A_Index%] := hs_HotstringAppMode[%hs_Index%]
		hs_HotstringText[%A_Index%] := hs_HotstringText[%hs_Index%]
		hs_HotstringOptions[%A_Index%] := hs_HotstringOptions[%hs_Index%]
		hs_HotstringESC[%A_Index%] := hs_HotstringESC[%hs_Index%]
		hs_HotstringExternal[%A_Index%] := hs_HotstringExternal[%hs_Index%]
		hs_TextMode[%A_Index%] := hs_TextMode[%hs_Index%]
	}

	hs_Hotstrings--

	If hs_Hotstrings < 1
		hs_Hotstrings = 1

	hs_Selected--
	If hs_Selected < 1
		hs_Selected = 1

	GuiControl, Choose, hs_HotStringBox, %hs_Selected%

	Gosub, hs_sub_Refresh
	Gosub, hs_sub_Select
Return

hs_sub_ListBox_add:
	AutoTrim, Off
	If (hs_HotstringExternal[%hs_Selected%] = "" AND hs_HotStringBox <> "")
		Gosub, hs_sub_Store
	hs_Hotstrings++
	hs_HotstringName[%hs_Hotstrings%] = %lng_hs_New%
	;hs_UndoHotstringName[%hs_Hotstrings%] = %lng_hs_New%
	If hs_AppFilter = %lng_hs_AllApps%
		hs_HotstringApp[%hs_Hotstrings%] =
	Else
		hs_HotstringApp[%hs_Hotstrings%] = %hs_AppFilter%
	hs_HotstringText[%hs_Hotstrings%] =
	hs_HotstringOptions[%hs_Hotstrings%] =
	hs_HotstringExternal[%hs_Hotstrings%] =
	hs_HotstringESC[%hs_Hotstrings%] = 0
	hs_TextMode[%hs_HotStrings%] = 1
	hs_NoStore = 1
	hs_Selected = %hs_HotStrings%
	If hs_HotStringBox =
		GuiControl,,hs_HotstringBox, |%lng_hs_New%
	Else
		GuiControl,,hs_HotstringBox,% lng_hs_New
	GuiControl,ChooseString,hs_HotstringBox, %lng_hs_New%
	Gosub, hs_sub_Select
	hs_NoStore = 0
	AutoTrim, On
Return

hs_sub_Undo:
	AutoTrim, Off
	hs_HotstringOptions[%hs_Selected%] := hs_UndoHotstringOptions[%hs_Selected%]
	hs_HotstringName[%hs_Selected%] := hs_UndoHotstringName[%hs_Selected%]
	hs_HotstringText[%hs_Selected%] := hs_UndoHotstringText[%hs_Selected%]
	hs_HotstringESC[%hs_Selected%] := hs_UndoHotstringESC[%hs_Selected%]
	hs_HotstringApp[%hs_Selected%] := hs_UndoHotstringApp[%hs_Selected%]
	hs_HotstringExternal[%hs_Selected%] := hs_UndoHotstringExternal[%hs_Selected%]
	hs_TextMode[%hs_Selected%] := hs_UndoTextMode[%hs_Selected%]
	hs_NoStore = 1
	Gosub, hs_sub_Refresh
	Gosub, hs_sub_Select
	hs_NoStore = 0
	AutoTrim, On
Return

SaveSettings_HotStrings:
	Gosub, hs_sub_Refresh
	func_RemoveMessage(0x100, "hs_sub_OnMessage_Keys")
	If hs_DisableEditing = 1
		Return
	AutoTrim, Off
	Gosub, hs_sub_SortHotstring
	hs_AllHotStrings =

	Loop, Parse, hs_NotApps, |
	{
		AutoTrim, On
		hs_App = %A_LoopField%
		AutoTrim, Off
		If hs_App =
			continue

		If hs_App = %lng_hs_AllApps%
			hs_App =

		hs_AllHotStrings = %hs_AllHotStrings%#IfWinNotActive,%hs_App%`n
		hs_AppMode = 2

		Gosub, SaveSettings_HotStrings_WriteIni
	}
	IfInString, hs_Apps, %lng_hs_AllApps%|
	{
		StringReplace, hs_Apps, hs_Apps, %lng_hs_AllApps%|
		hs_Apps = %hs_Apps%|%lng_hs_AllApps%
	}
	Loop, Parse, hs_Apps, |
	{
		AutoTrim, On
		hs_App = %A_LoopField%
		AutoTrim, Off
		If hs_App =
			continue

		If hs_App = %lng_hs_AllApps%
			hs_App =

		hs_AllHotStrings = %hs_AllHotStrings%#IfWinActive,%hs_App%`n
		hs_AppMode = 1

		Gosub, SaveSettings_HotStrings_WriteIni
	}
	hs_AllHotStrings = %hs_AllHotStrings%#IfWinActive,`n
	hs_AllHotStrings = %hs_HotstringIncludes%%hs_AllHotStrings%
	FileCopy, %ConfigFile_Hotstrings%.disabled, %ConfigFile_Hotstrings%.bak, 1
	FileAppend, %hs_AllHotStrings% , %ConfigFile_Hotstrings%.tmp

	FileRead, hs_F1, %ConfigFile_Hotstrings%.disabled
	FileRead, hs_F2, %ConfigFile_Hotstrings%.tmp

	FileMove, %ConfigFile_Hotstrings%.tmp, %ConfigFile_Hotstrings%.disabled, 1
	AutoTrim, On

	IfExist, settings/Clipboards
		Gosub, hs_sub_CleanUpClipSaves

	If hs_F1 <> %hs_F2%
	{
		Reload = 1
	}
	IniWrite, %hs_Selected%, %ConfigFile%, %hs_ScriptName%, Selected
Return


SavePosition_HotStrings:
	IniWrite, %hs_Selected%, %ConfigFile%, %hs_ScriptName%, Selected
Return

SaveSettings_HotStrings_WriteIni:
	Loop, %hs_Hotstrings%
	{
		If (hs_HotstringName[%A_Index%] = "" OR hs_HotstringName[%A_Index%] = " " OR hs_HotstringText[%A_Index%]="" OR hs_HotstringApp[%A_Index%] <> hs_App OR (hs_HotstringAppMode[%A_Index%] <> 2 AND hs_AppMode = 2) OR (hs_HotstringAppMode[%A_Index%] = 2 AND hs_AppMode = 1) OR hs_HotstringExternal[%A_Index%] <> "")
			continue
		If (func_StrRight(hs_HotstringText[%A_Index%],1) = " ")
		{
			StringTrimRight, hs_HotstringText[%A_Index%], hs_HotstringText[%A_Index%], 1
			hs_HotstringText[%A_Index%] :=  hs_HotstringText[%A_Index%] "{Space}"
		}
		If hs_HotstringESC[%A_Index%] = 1
			hs_LineESC := " `; don't escape modifiers"
		Else
			hs_LineESC =

		If hs_TextMode[%A_Index%] = 2
		{
			If hs_HotstringText[%A_Index%] not contains If%A_Space%,Send,SendRaw,IfWin,WinGet,MsgBox,Loop,Run,ToolTip,%hs_CheckChars%
			{
				hs_HotstringText[%A_Index%] := "Send, " hs_HotstringText[%A_Index%]
				StringReplace, hs_HotstringText[%A_Index%], hs_HotstringText[%A_Index%], __NewLine__, % "`n   ", All
			}
			Else
			{
				StringReplace, hs_HotstringText[%A_Index%], hs_HotstringText[%A_Index%], ```;, `;, All
				StringReplace, hs_HotstringText[%A_Index%], hs_HotstringText[%A_Index%], __NewLine__, % "`n   ", All
			}
			hs_HotstringText[%A_Index%] := "`n   " hs_HotstringText[%A_Index%] "`nReturn"
			hs_Line :=  ":" hs_HotstringOptions[%A_Index%] ":" hs_HotstringName[%A_Index%] ":`:" hs_HotstringText[%A_Index%] "`n"
		}
		Else
		{
			StringReplace, hs_HotstringText[%A_Index%], hs_HotstringText[%A_Index%], __NewLine__, ``r, All
			hs_Line :=  ":" hs_HotstringOptions[%A_Index%] ":" hs_HotstringName[%A_Index%] ":`:" hs_HotstringText[%A_Index%] hs_LineESC "`n"
		}
		hs_AllHotStrings = %hs_AllHotStrings%%hs_Line%
		hs_UndoHotstringText[%A_Index%] := hs_HotstringText[%A_Index%]
	}
Return

CancelSettings_HotStrings:
	IniWrite, %hs_Selected%, %ConfigFile%, %hs_ScriptName%, Selected

	IfExist, settings/Clipboards
		Gosub, hs_sub_CleanUpClipSaves
	func_RemoveMessage(0x100, "hs_sub_OnMessage_Keys")
	ToolTip,,,,7
Return

DoEnable_HotStrings:
	If TemporaryMenuSuspend = 1
		Return
	IfNotExist, %ConfigFile_Hotstrings%.disabled
		return

	Reload = 1
	FileMove, %ConfigFile_Hotstrings%.disabled, %ConfigFile_Hotstrings%,1
Return

DoDisable_HotStrings:
	If TemporaryMenuSuspend = 1
		Return

	IfNotExist, %ConfigFile_Hotstrings%
		return

	Reload = 1
	FileMove, %ConfigFile_Hotstrings%, %ConfigFile_Hotstrings%.disabled,1
Return

DefaultSettings_HotStrings:
	FileDelete, %ConfigFile_Hotstrings%
	FileDelete, %ConfigFile_Hotstrings%.disabled
	FileAppend, %hs_Defaults%, %ConfigFile_Hotstrings%%hs_FilenameAdd%
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

hs_sub_SortHotstring:
	hs_SortList =
	Loop, %hs_Hotstrings%
	{
		hs_SortList :=  hs_SortList hs_HotstringName[%A_Index%] "`t" hs_HotstringOptions[%A_Index%] "`t" hs_HotstringText[%A_Index%] "`t" hs_HotstringESC[%A_Index%] "`t" hs_TextMode[%A_Index%] "`t" hs_HotstringApp[%A_Index%] "`t" hs_HotstringAppMode[%A_Index%] "`t" hs_HotstringExternal[%A_Index%] "`n"
	}
	Sort, hs_SortList
	Loop, Parse, hs_SortList, `n
	{
		StringSplit, hs_Split, A_LoopField, %A_Tab%
		hs_HotstringName[%A_Index%] = %hs_Split1%
		hs_HotstringOptions[%A_Index%] = %hs_Split2%
		hs_HotstringText[%A_Index%] = %hs_Split3%
		hs_HotstringESC[%A_Index%] = %hs_Split4%
		hs_TextMode[%A_Index%] = %hs_Split5%
		hs_HotstringApp[%A_Index%] = %hs_Split6%
		hs_HotstringAppMode[%A_Index%] = %hs_Split7%
		hs_HotstringExternal[%A_Index%] = %hs_Split8%
	}
Return

hs_sub_OnMessage_Keys:
	If (A_GuiControl <> "hs_HotstringName")
		return
	hs_Key = %#wParam%

	GetKeyState, hs_CtrlState, Ctrl
	If hs_CtrlState = D
		hs_Key := hs_Key + 1000
	GetKeyState, hs_ShiftState, Shift
	If hs_ShiftState = D
		hs_Key := hs_Key + 2000
	GetKeyState, hs_AltState, Alt
	If hs_AltState = D
		hs_Key := hs_Key + 4000

;   tooltip,% hs_Key

	if (hs_Key = 38 AND hs_Selected > 1)
	{
		GuiControl, Focus, hs_HotstringBox
		Send, {Up}
	}
	if (hs_Key = 40 AND hs_Selected < hs_HotStrings)
	{
		GuiControl, Focus, hs_HotstringBox
		Send, {Down}
	}
	if ( (hs_Key = 1035 OR hs_Key = 1040) AND hs_Selected < hs_HotStrings )
	{
		GuiControl, Focus, hs_HotstringBox
		Send, {End}
	}
	if ( (hs_Key = 1036 OR hs_Key = 1038) AND hs_Selected > 1 )
	{
		GuiControl, Focus, hs_HotstringBox
		Send, {Home}
	}
Return

hs_sub_ClipSave:
	IfNotExist, settings/Clipboards
		FileCreateDir, settings/Clipboards
	Loop
	{
		hs_ClipFileName = settings/Clipboards/HS_ClipSave%A_Index%.dat
		IfNotExist, %hs_ClipFileName%
			break
	}
	FileAppend, %ClipBoardAll%, %hs_ClipFileName%
	GuiControl,,hs_HotstringText, hs_Temp = `%ClipBoardAll`%`nFileRead, Clipboard, *c %hs_ClipFileName%`nSend, ^v`nSleep, 100`nClipBoard = `%hs_Temp`%
	GuiControl,,hs_TextMode2, 1
	Gosub, hs_sub_Store
Return

hs_sub_CleanUpClipSaves:
	Loop, settings/Clipboards/HS_*.*
	{
		hs_FileName = %A_LoopFileName%
		hs_DeleteFile = 1
		Loop, %hs_hotStrings%
		{
			IfInString, hs_UndoHotStringText[%A_Index%], FileRead, Clipboard, *c settings/Clipboards/%hs_FileName%
				hs_DeleteFile = 0
		}
		If hs_DeleteFile = 1
			FileDelete, settings/Clipboards/%A_LoopFileName%
	}
Return

; more solid solition to split the parts of a HotString-string
; only depends on Autohotkeys HotString delimiters
hs_getHotstringParts(byref s)
{
	Global hs_Hotstring1,hs_Hotstring2,hs_Hotstring3,hs_Hotstring4
	
	; get pos of first non-escaped " ;" for comments
	pC := InStr(s, " `;" , false, 0)
	hs_Hotstring4 =
	if pC
	{
		hs_Hotstring4 := SubStr(s, pC + 2)
		; cut away comments: because they could potentially contain anything
		s := SubStr(s, 1, pC - 1)
	}

	; get pos of second ":" after Hotstring options
	p1 := InStr(s, ":" , false, 2)
	hs_Hotstring1 := SubStr(s, 2, p1 - 2)
	
	; get position of last "::" which separates shortcut and replacement
	; we can do so because "::" in the replacement would always be escapes like `:`:
	p2 := InStr(s, "::" , false, 0)
	hs_Hotstring2 := SubStr(s, p1 + 1, p2 - p1 - 1)

	hs_Hotstring3 := SubStr(s, p2 + 2)
}