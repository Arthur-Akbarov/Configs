; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               ActiveGoto
; -----------------------------------------------------------------------------
; Prefix:             acg_
; Version:            0.1
; Date:               2008-07-06
; Author:             David Hilberath, Rajat
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; Based on Rajat's Active Goto:
; http://www.autohotkey.com/forum/topic11998.html
;
; When you're working on a big script (say having 400-500 or maybe a couple of
; thousand lines) then what do you hate most? If you're like me then you hate
; scrolling from one part of the script to another the most... to counter that
; I'd made the bookmark script which remembered line contents so the bookmarks
; always worked (here). Though the advantage it had was that only the sections
; I wanted were bookmarked, the problem problem was that I still had to create
; those bookmarks. I didn't like that much either.
;
; Whatever the current script in your fav editor is, its instantly scanned and
; All Sections (including hotkey sections) and All Functions are presented as
; a sorted list of searchable bookmarks!

; Its set for TextPad but you can change it to whatever editor you like, it has
; just 2 requirements:
; - Editor must have a Goto Line cmd
; - Editor window's title shows file path
; Except Notepad probably every editor has those!

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_ActiveGoto:
	Prefix = acg
	%Prefix%_ScriptName    = ActiveGoto
	%Prefix%_ScriptVersion = 0.1
	%Prefix%_Author        = David Hilberath, Rajat

	CustomHotkey_ActiveGoto = 0
	IconFile_On_ActiveGoto  = %A_WinDir%\system32\shell32.dll
	IconPos_On_ActiveGoto   = 172

	gosub, LoadSettings_ActiveGoto
	gosub, LanguageCreation_ActiveGoto
	gosub, acg_createGui

	RegisterAdditionalSetting("acg", "ASort", 0)
	RegisterAdditionalSetting("acg", "ScriptCheck", 1)
Return

LanguageCreation_ActiveGoto:
	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %acg_ScriptName% - Unterstützt das Editieren von Autohotkey Scripts
		Description                   = Scannt und indiziert Sektionen, Hotkeys und Funktionen eines AHK Scripts.

		lng_acg_ShowGUI					= ActiveGoto zeigen
		lng_acg_LastSection				= Zum letzten Abschnitt springen
		lng_acg_editorSettings			= Editorspezifische Einstellungen
		lng_acg_GotoKey					= Goto-Hotkey

		lng_acg_TitleStart				= Titel Beginn
		lng_acg_TitleEnd					= Titel Ende

		lng_acg_ScriptCheck				= Überprüfen ob aktuell geöffnete Datei ein AHK Script ist
		lng_acg_ASort						= Sektionsliste alphabetisch sortieren
		lng_acg_GotoWin					= Goto-Window Class
		lng_acg_EditorExe					= Executable
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %acg_ScriptName% - Supports editing of Autohotkey script
		Description                   = Scans and indexes sections, hotkeys and functions of an Autohotkeyscript

		lng_acg_ShowGUI					= Show ActiveGoto
		lng_acg_LastSection				= Jump to last section
		lng_acg_editorSettings			= Configure Editor
		lng_acg_GotoKey					= Goto-Hotkey

		lng_acg_TitleStart				= Title Start
		lng_acg_TitleEnd					= Title End

		lng_acg_ScriptCheck				= Check if the currently open file is a .ahk file
		lng_acg_ASort						= Sort section list alphabetically
		lng_acg_GotoWin					= Goto-Window Class
		lng_acg_EditorExe					= Executable
	}
Return

SettingsGui_ActiveGoto:
	func_HotkeyAddGuiControl(lng_acg_ShowGUI, "acg_HK_ShowGUI", "xs+10 y+10 w160" )
	func_HotkeyAddGuiControl(lng_acg_LastSection, "acg_HK_LastSection", "xs+10 y+10 w160" )

	Gui, Add, Groupbox, xs+10 y+20 w540 h195, %lng_acg_editorSettings%
	func_HotkeyAddGuiControl(lng_acg_GotoKey, "acg_GotoKey", "xs+20 yp+23 w150")

	Gui, Add, Text, xs+20 y+10 w150, %lng_acg_EditorExe%:
	Gui, Add, Edit, x+5 yp-2 gsub_CheckIfSettingsChanged vacg_EditorExe w300, %acg_EditorExe%

	Gui, Add, Text, xs+20 y+10 w150, %lng_acg_GotoWin%:
	Gui, Add, Edit, x+5 yp-2 gsub_CheckIfSettingsChanged vacg_GotoWin w300, %acg_GotoWin%

	Gui, Add, Text, xs+20 y+10 w150, %lng_acg_TitleStart%:
	Gui, Add, Edit, x+5 yp-2 gsub_CheckIfSettingsChanged vacg_TitleStart w300, %acg_TitleStart%

	Gui, Add, Text, xs+20 y+10 w150, %lng_acg_TitleEnd%:
	Gui, Add, Edit, x+5 yp-2 gsub_CheckIfSettingsChanged vacg_TitleEnd w300, %acg_TitleEnd%
Return

SaveSettings_ActiveGoto:
	;Editorsettings
	IniWrite, %acg_TitleStart%, %ConfigFile%, %acg_ScriptName%, TitleStart
	IniWrite, %acg_TitleEnd%, %ConfigFile%, %acg_ScriptName%, TitleEnd
	IniWrite, %acg_EditorExe%, %ConfigFile%, %acg_ScriptName%, EditorExe

	;Go To Settings (Name of GoTo window and Editor's related key)
	IniWrite, %acg_GotoWin%, %ConfigFile%, %acg_ScriptName%, GotoWindowClass, ahk_class #32770
	func_HotkeyWrite( "acg_GotoKey", ConfigFile, acg_ScriptName, "GotoKey")

	;Hotkeys for showing GUI and going to last section
	func_HotkeyWrite( "acg_HK_ShowGUI", ConfigFile, acg_ScriptName, "ShowGUIKey")
	func_HotkeyWrite( "acg_HK_LastSection", ConfigFile, acg_ScriptName, "LastSectionKey")
Return

LoadSettings_ActiveGoto:
	;Editorsettings
	IniRead, acg_TitleStart, %ConfigFile%, %acg_ScriptName%, TitleStart, TextPad - [
	IniRead, acg_TitleEnd, %ConfigFile%, %acg_ScriptName%, TitleEnd, ]
	IniRead, acg_EditorExe, %ConfigFile%, %acg_ScriptName%, EditorExe, textpad.exe

	;Go To Settings (Name of GoTo window and Editor's related key)
	IniRead, acg_GotoWin, %ConfigFile%, %acg_ScriptName%, GotoWindowClass, ahk_class #32770
	func_HotkeyRead( "acg_GotoKey", ConfigFile, acg_ScriptName, "GotoKey", "acg_nix", "^g" )

	;Hotkeys for showing GUI and going to last section
	func_HotkeyRead( "acg_HK_ShowGUI", ConfigFile, acg_ScriptName, "ShowGUIKey", "acg_showMainWindow", "^Tab")
	func_HotkeyRead( "acg_HK_LastSection", ConfigFile, acg_ScriptName, "LastSectionKey", "acg_lastSection", "#Left")^
Return

acg_nix:
return

AddSettings_ActiveGoto:
Return

CancelSettings_ActiveGoto:
Return

DoEnable_ActiveGoto:
	func_HotkeyEnable("acg_HK_ShowGui")
	func_HotkeyEnable("acg_HK_LastSection")
	registerEvent("activeWindow","acg_CheckEditorWindow")
	registerEvent("redrawWindow","acg_CheckEditorWindow")
Return

DoDisable_ActiveGoto:
	func_HotkeyDisable("acg_HK_ShowGui")
	func_HotkeyDisable("acg_HK_LastSection")
	unRegisterEvent("activeWindow","acg_CheckEditorWindow")
	unRegisterEvent("redrawWindow","acg_CheckEditorWindow")
Return

DefaultSettings_ActiveGoto:
Return

OnExitAndReload_ActiveGoto:
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------
acg_createGui:
	CreateGuiID("ActiveGoto_MainWindow")
	GuiDefault("ActiveGoto_MainWindow")

	Gui, +AlwaysOnTop -Caption +Border +ToolWindow
	;Gui, Add, Edit, x6 y6 w200 h20 vacg_Search gacg_Search AltSubmit,
	Gui, Add, ListBox, x6 y+6 w200 h440 vacg_SelItem gacg_MSelect,
	Gui, Add, Button, x-10 y-10 w1 h1 gacg_Select Default,
Return

ActiveGoto_MainWindowGuiEscape:
	GuiDefault("ActiveGoto_MainWindow")
	acg_guiShown = 0
	Gui, Hide
	WinActivate, ahk_id %acg_editorId%
return

acg_showMainWindow:
	GuiDefault("ActiveGoto_MainWindow")

	if acg_guiShown = 1
	{
		acg_guiShown = 0
		Gui, Hide
		WinActivate, ahk_id %event_activeWindow_ahkId%
	}
	else
	{
		if event_activeWindow = %acg_EditorExe%
		{
			acg_guiShown = 1

			WinGetPos, acg_x, acg_y, acg_w, acg_h, ahk_id %acg_editorId%

			acg_wC_x := acg_x + (acg_w / 2) - 106
			acg_wC_y := acg_y + (acg_h / 2) - 225

			Gui, Show, w212 h450 x%acg_wC_x% y%acg_wC_y%
		}
	}
Return

acg_MSelect:
	GuiDefault("ActiveGoto_MainWindow")
	IfNotEqual, A_GuiControlEvent, DoubleClick, Return

acg_Select:
	;selects the search text
	GuiDefault("ActiveGoto_MainWindow")
	Gui, Submit, NoHide

	Loop, %acg_Count%
	{
		IfEqual, acg_Text%A_Index%, %acg_SelItem%
		{
			acg_LastLine = %acg_GotoLine%
			acg_GotoLine := acg_Pos%A_Index%

			WinActivate, ahk_id %acg_editorId%
			WinWaitActive, ahk_id %acg_editorId%

			Send, %Hotkey_acg_GotoKey%
			WinWaitActive, %acg_GotoWin%
			Send, %acg_GotoLine%{Enter}

			IfEqual, acg_LastLine,
				acg_LastLine = %acg_GotoLine%

			GuiDefault("ActiveGoto_MainWindow")
			acg_guiShown = 0
			Gui, Hide

			Break
		}
	}
Return

acg_CheckEditorWindow:
	if event_activeWindow = %acg_EditorExe%
	{
		acg_editorId := event_activeWindow_ahkId
		WinGetTitle, acg_editorTitle, ahk_id %acg_editorId%

		StringLen, acg_StartLen, acg_TitleStart
		StringLen, acg_EndLen, acg_TitleEnd

		StringTrimLeft, acg_FileName, acg_editorTitle, %acg_StartLen%
		StringTrimRight, acg_FileName, acg_FileName, %acg_EndLen%

		StringRight, acg_Test, acg_FileName, 1
		IfEqual, acg_Test, *
		{
			StringTrimRight, acg_FileName, acg_FileName, 1
			return
		}
		else
		{
			IfNotInString, acg_FileName, .ahk
				Return

			IfNotEqual, acg_FileName, %acg_LastFileName%
			{
				Gosub, acg_GenerateBM
				acg_LastFileName = %acg_FileName%
			}
		}
	}
return

acg_GenerateBM:
	;Msgbox, You are currently editing:`n%acg_FileName%
	FileRead, acg_FileData, %acg_FileName%
	SplitPath, acg_FileName,,, acg_FileType

	acg_List =
	acg_PosList =
	acg_Count =
	Loop, Parse, acg_FileData, `n, `r
	{
		acg_SectionLine =
		acg_CurrLine = %A_LoopField%
		acg_CurrLine = %acg_CurrLine%
		acg_CurrLineN = %A_Index%

		IfEqual, acg_FileType, ahk
		{
			;commented line
			StringLeft, acg_Check, acg_CurrLine, 1
			IfEqual, acg_Check, `;, Continue

			;removing same line comment
			StringGetPos, acg_Check, acg_CurrLine, `;
			acg_Error = %ErrorLevel%
			StringLeft, acg_Check, acg_CurrLine, %acg_Check%
			StringRight, acg_Check2, acg_Check, 1
			IfNotEqual, acg_Check2, ``
			IfNotEqual, acg_Error, 1
			{
				acg_Check = %acg_Check%
				acg_CurrLine = %acg_Check%
			}


			;function line
			IfInString, acg_CurrLine, `(
			IfInString, acg_CurrLine, `)
			{
				;non OTB function
				IfNotInString, acg_CurrLine, `{
				{
					FileReadLine, acg_CheckF, %acg_FileName%, % A_Index + 1
					acg_CheckF = %acg_CheckF%
					IfNotEqual, acg_CheckF, `{
						Continue
				}

				;OTB function
				IfInString, acg_CurrLine, `{
				{
					StringRight, acg_CheckF, acg_CurrLine, 1
					IfNotEqual, acg_CheckF, `{
						Continue
				}

				StringGetPos, acg_CPos, acg_CurrLine, `(
				StringLeft, acg_CurrLine, acg_CurrLine, %acg_CPos%
				acg_CurrLine = %acg_CurrLine%`(`)
				acg_SectionLine = Y
			}

			;hotkey/hotstring line
			IfInString, acg_CurrLine, `:`:
			{
				StringGetPos, acg_CPos, acg_CurrLine, `:`:

				;hotstring line
				IfEqual, acg_CPos, 0
				{
					StringTrimLeft, acg_CurrLine, acg_CurrLine, 2
					StringGetPos, acg_CPos, acg_CurrLine, `:`:
					StringLeft, acg_CurrLine, acg_CurrLine, %acg_CPos%
					acg_CurrLine = `:`:%acg_CurrLine%`:`:
				}
				;hotkey line
				Else
				{
					acg_CPos += 2
					StringLeft, acg_CurrLine, acg_CurrLine, %acg_CPos%
				}
				acg_SectionLine = Y
			}

			IfNotInString, acg_CurrLine, `:`:
			{
				IfInString, acg_CurrLine, `,, Continue
				IfInString, acg_CurrLine, %A_Space%, Continue
				IfInString, acg_CurrLine, %A_Tab%, Continue
			}

			StringRight, acg_Check2, acg_CurrLine, 1
			StringRight, acg_Check3, acg_CurrLine, 2
			StringLeft, acg_Check3, acg_Check3, 1

			IfEqual, acg_Check2, `:
			IfNotEqual, acg_Check3, ``
				acg_SectionLine = Y
		}


		IfEqual, acg_SectionLine, Y
		{
			acg_Count ++
			acg_Text%acg_Count% = %acg_CurrLine%
			acg_Pos%acg_Count% = %acg_CurrLineN%
			acg_List = %acg_List%|%acg_CurrLine%
			acg_PosList = %acg_PosList%|%acg_CurrLineN%
		}
	}

	StringTrimLeft, acg_List, acg_List, 1
	IfEqual, acg_ASort, 1
		Sort, acg_List, D|

	;update list only if there is a change in sections, and not if the change is
	;only in the position of the sections
	acg_CheckList1 = %acg_List%
	acg_CheckList2 = %acg_LastList%

	Sort, acg_CheckList1, D|
	Sort, acg_CheckList2, D|

	;only update list if the sections have changed
	GuiDefault("ActiveGoto_MainWindow")
	GuiControl,, acg_SelItem, |
	GuiControl,, acg_SelItem, %acg_List%
Return

acg_lastSection:
	IfEqual, acg_LastLine,, Return

	Gosub, acg_GenerateBM

	WinActivate, ahk_id %acg_editorId%
	WinWaitActive, ahk_id %acg_editorId%
	Send, %Hotkey_acg_GotoKey%
	WinWaitActive, %acg_GotoWin%
	Send, %acg_LastLine%{Enter}
	acg_Swp = %acg_LastLine%
	acg_LastLine = %acg_GotoLine%
	acg_GotoLine = %acg_Swp%
return
