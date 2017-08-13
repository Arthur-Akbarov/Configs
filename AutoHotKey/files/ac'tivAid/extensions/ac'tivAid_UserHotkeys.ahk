; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               UserHotkeys
; -----------------------------------------------------------------------------
; Prefix:             uh_
; Version:            2.3
; Date:               2008-05-23
; Author:             Wolfgang Reszel
; Bugfixing:          Stephan Noy
; Additions:          Robert Deimel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_UserHotkeys:
	Prefix = uh
	%Prefix%_ScriptName     = UserHotkeys
	%Prefix%_ScriptVersion  = 2.3
	%Prefix%_Author         = Wolfgang Reszel, Stephan Noy, Robert Deimel
	AddSettings_UserHotkeys = 1
	IconFile_On_UserHotkeys  = %A_WinDir%\system32\main.cpl
	IconPos_On_UserHotkeys   = 8

	CreateGuiID("UserHotkeys")

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %uh_ScriptName% - Benutzerdefinierte Tastaturkürzel
		Description                   = Frei belegbare Tastaturkürzel. Sie lassen sich mit Programmen, Skripten, Verzeichnissen, URLs und einigen Spezialbefehlen, wie die Ausgabe von Text, belegen.
		lng_uh_FileTypes              = *.exe; *.cmd; *.bat; *.ahk; *.vbs; *.hlp; *.chm; *.txt; *.htm; *.html; *.txt; *.doc; *.xls; *.ppt; *.sxw; *.sxc; *.odt; *.ott; *.ods; *.ots; *.odp; *.otp
		lng_uh_Edit                   = Tastaturkürzel bearbeiten
		lng_uh_Add                    = Tastaturkürzel hinzufügen
		lng_uh_CMEdit                 = &Bearbeiten`t(Doppelklick/Leertaste)
		lng_uh_CMAdd                  = &Hinzufügen`t(Einfg)
		lng_uh_CMDuplicate            = &Duplizieren`t(Strg+D)
		lng_uh_CMDelete               = &Löschen`t(Entf)
		lng_uh_CMtop                  = An den &Anfang der Liste schieben`t(Alt+Pos1)
		lng_uh_CMbottom               = An das &Ende der Liste schieben`t(Alt+Ende)
		lng_uh_CMup                   = Eine Zeile nach &oben schieben`t(Alt+Cursor hoch)
		lng_uh_CMdown                 = Eine Zeile nach u&nten schieben`t(Alt+Cursor runter)
		lng_uh_Legend                 = Spezialbefehl einfügen
		lng_uh_Category               = Kategorie
		lng_uh_Command                = Befehl/Beschreibung
		lng_uh_Description            = Beschreibung
		lng_uh_CategoryHotkey         = Kürzel für Kategorie-Menü
		lng_uh_Application            := "Programm: "
		lng_uh_OnlyOneApplication     = Nur für folgende Programme (ein oder mehrere Fenstertitel mit Komma getrennt ODER ahk_class FensterKlasse)`nAls Sonderfall gibt es noch "ExplorerAndDialogs", welches alle Explorer-Fenster und Dateidialoge einschließt:
		lng_uh_ClipSave               = Zwischenablage für <PasteFile> in Datei speichern
		lng_uh_running                = wird ausgeführt
		lng_uh_runningError           = kann nicht ausgeführt werden.
		lng_uh_BalloonTips            = Sprechblasenhinweise
		lng_uh_Cat_Applications       = Anwendungen
		lng_uh_Cat_Snippets           = Textbausteine
		lng_uh_Cmd_Send               = TEXT
		lng_uh_Cmd_SendRaw            = reiner TEXT
		lng_uh_Cmd_Reload             = ac'tivAid neu laden
		lng_uh_Cmd_ListHotkeys        = alle AHK-Tastaturkürzel auflisten
		lng_uh_Cmd_ListLines          = die zuletzt ausgeführten AHK-Befehle auflisten
		lng_uh_Cmd_ListVars           = alle AHK-Variablen auflisten
		lng_uh_Cmd_ExitApp            = ac'tivAid beenden
		lng_uh_Cmd_KeyHistory         = die zuletzt gedrückten Tasten auflisten
		lng_uh_Cmd_ChDir              = Verzeichniswechsel
		lng_uh_Cmd_getControl         = Name des Fensterelements unter der Maus
		lng_uh_Cmd_getColour          = Farbe des Pixels unter der Maus
		lng_uh_Cmd_getControlText     = Text unter der Maus
		lng_uh_Cmd_SingleInstance     = Ein-/Ausblenden
		lng_uh_Cmd_SingleInstanceClose= Starten/Beenden
		lng_uh_Cmd_AOT                = Immer vorne
		lng_uh_Cmd_Min                = Minimiert
		lng_uh_Cmd_Max                = Maximiert
		lng_uh_Cmd_Hide               = Versteckt
		lng_uh_Cmd_CategoryMenu       = Kategorie-Menü anzeigen
		lng_uh_Cmd_PasteFile          = PasteFile
		lng_uh_Cmd_CategoryLaunchAll  = Alle Kategorie-Befehle ausführen

		lng_uh_Desc_Calc              = Taschenrechner
		lng_uh_Desc_Control           = Systemsteuerung

		tooltip_uh_BalloonTip         = Aus = Es werden keine Sprechblasenhinweise angezeigt`nAktiviert = Es werden nur Fehler angezeigt`nGrau/Grün = Es werden Fehler und auch das ausgeführte Programm angezeigt
	}
	else        ; = other languages (english)
	{
		MenuName                      = %uh_ScriptName% - user-definable hotkeys
		Description                   = Assign hotkeys to programs, scripts, folders, urls and some special commands, like the typing text or getting the colour under the mouse.
		lng_uh_FileTypes              = Programs/scripts (*.exe; *.cmd; *.bat; *.ahk; *.vbs)
		lng_uh_Edit                   = Edit hotkey
		lng_uh_Add                    = Add hotkey
		lng_uh_CMEdit                 = &Edit`t(Double-click/Space)
		lng_uh_CMAdd                  = &Add`t(Ins)
		lng_uh_CMDuplicate            = &Duplicate`t(Ctrl+D)
		lng_uh_CMDelete               = &Delete`t(Del)
		lng_uh_CMtop                  = Move to the &top of the list`t(Alt+Home)
		lng_uh_CMbottom               = Move to the &bottom of the list`t(Alt+End)
		lng_uh_CMup                   = Move one line &up`t(Alt+Cursor up)
		lng_uh_CMdown                 = Move one line dow&n`t(Alt+Cursor down)
		lng_uh_Legend                 = Insert special command
		lng_uh_Category               = Category
		lng_uh_Command                = Command/Description
		lng_uh_Description            = Description
		lng_uh_CategoryHotkey         = Hotkey for category-menu
		lng_uh_Application            := "App: "
		lng_uh_OnlyOneApplication     = Only for the following applications (one or more window titles, comma-separated OR ahk_class WindowClass):
		lng_uh_ClipSave               = Save clipboard as file for <PasteFile>
		lng_uh_running                = is being executed
		lng_uh_runningError           = couldn't be executed.
		lng_uh_BalloonTips            = BalloonTips
		lng_uh_Cat_Applications       = Application
		lng_uh_Cat_Snippets           = Snippets
		lng_uh_Cmd_Send               = Send text
		lng_uh_Cmd_SendRaw            = Send raw text
		lng_uh_Cmd_Reload             = reload ac'tivAid
		lng_uh_Cmd_ListHotkeys        = list all AHK-hotkeys
		lng_uh_Cmd_ListLines          = list last executed AHK-commands
		lng_uh_Cmd_ListVars           = list all AHK-variables
		lng_uh_Cmd_ExitApp            = quit ac'tivAid
		lng_uh_Cmd_KeyHistory         = list key-history
		lng_uh_Cmd_ChDir              = Change directory
		lng_uh_Cmd_getControl         = Control-name under the mouse-pointer
		lng_uh_Cmd_getColour          = Pixel-colour under the mouse-pointer
		lng_uh_Cmd_getControlText     = Text under the mouse-pointer
		lng_uh_Cmd_SingleInstance     = Show/hide a program
		lng_uh_Cmd_SingleInstanceClose= Start/quit a program
		lng_uh_Cmd_AOT                = Always on top
		lng_uh_Cmd_Min                = minimised
		lng_uh_Cmd_Max                = maximised
		lng_uh_Cmd_Hide               = hidden
		lng_uh_Cmd_CategoryMenu       = show category-menu
		lng_uh_Cmd_PasteFile          = PasteFile
		lng_uh_Cmd_CategoryLaunchAll  = Launch all category-commands

		lng_uh_Desc_Calc              = Calculator
		lng_uh_Desc_Control           = Control panel

		tooltip_uh_BalloonTip         = Off = No BalloonTips`nActive = Show errors`nGrey/Green = Shows errors and the executed program
	}
	If CustomLanguage <>
		gosub, CustomLanguage

	IniRead, uh_NumHotkeys, %ConfigFile%, %uh_ScriptName%, NumberOfHotkeys, 3
	IniRead, uh_Sort, %ConfigFile%, %uh_ScriptName%, SortCol, %A_Space%
	IniRead, uh_BalloonTip, %ConfigFile%, %uh_ScriptName%, ShowBalloonTip, 1
	IniRead, uh_BalloonTimeOut, %ConfigFile%, %uh_ScriptName%, BalloonTimeOut, 10
	IniRead, uh_AOTModifyTitle, %ConfigFile%, %uh_ScriptName%, AOTModifyTitle, 0

	StringLeft, uh_SortCol, uh_Sort, 1
	StringTrimLeft, uh_SortDir, uh_Sort, 1
	uh_SortCol%uh_SortCol% = %uh_SortDir%

	Loop, %uh_NumHotkeys%
	{
		IniRead, uh_Path%A_Index%, %ConfigFile%, %uh_ScriptName%, Path%A_Index%
		IniRead, uh_Category%A_Index%, %ConfigFile%, %uh_ScriptName%, Category%A_Index%
		IniRead, uh_App%A_Index%, %ConfigFile%, %uh_ScriptName%, Application%A_Index%
		IniRead, uh_Description%A_Index%, %ConfigFile%, %uh_ScriptName%, Description%A_Index%
		IniRead, uh_ProcID, %ConfigFile%, %uh_ScriptName%, GroupProcessID%A_Index%
		IniRead, uh_GroupProcs, %ConfigFile%, %uh_ScriptName%, GroupProcesses%A_Index%

		If (uh_ProcID <> "ERROR" AND uh_GroupProcs <> "ERROR")
		{
			uh_ProcID%A_Index% = %uh_ProcID%
			Loop, Parse, uh_GroupProcs, |
			{
				If A_LoopField =
					continue
				GroupAdd, %uh_ProcID%, ahk_id %A_LoopField%
			}
		}

		If uh_App%A_Index% = ERROR
			uh_App%A_Index% =
		If uh_Category%A_Index% = ERROR
			uh_Category%A_Index% =
		If uh_Description%A_Index% = ERROR
			uh_Description%A_Index% =
		if (A_Index = 1 and uh_Path%A_Index% = "ERROR")
		{
			uh_Path%A_Index% = Control
			uh_DefHotkey = $#c
			uh_Description%A_Index% = %lng_uh_Desc_Control%
		}
		if (A_Index = 2 and uh_Path%A_Index% = "ERROR")
		{
			uh_Path%A_Index% = <getControl>
			uh_DefHotkey = $^#+c
		}
		if (A_Index = 3 and uh_Path%A_Index% = "ERROR")
		{
			uh_Path%A_Index% = <getColour><RGB>
			uh_DefHotkey = $#.
		}
		if uh_Path%A_Index% = ERROR
			uh_Path%A_Index% =

		If uh_Path%A_Index% <> ""
		{
			If uh_Path%A_Index% contains <AltTab,AltTab>
			{
				StringReplace, uh_Temp, uh_Path%A_Index%, <,,All
				StringReplace, uh_Temp, uh_Temp, >,,All
				func_HotkeyRead( "uh_Hotkey" A_Index, ConfigFile, uh_ScriptName, "Hotkey" A_Index, uh_Temp, uh_DefHotkey, "" )
				uh_Description := uh_Description%A_Index%
				If uh_Description =
					uh_Description := uh_func_ShortenPath(uh_Temp)
				registerAction("UserHotkey_" A_Index, uh_Description, "uh_sub_Action_UserHotkey", uh_Temp)
			}
			Else
			{
				func_HotkeyRead( "uh_Hotkey" A_Index, ConfigFile, uh_ScriptName, "Hotkey" A_Index, "sub_Hotkey_UserHotkey", uh_DefHotkey, "$" )
				uh_Description := uh_Description%A_Index%
				If uh_Description =
					uh_Description := uh_func_ShortenPath(uh_Path%A_Index%)
				registerAction("UserHotkey_" A_Index, uh_Description, "uh_sub_Action_UserHotkey", uh_Path%A_Index%)
			}
		}
		uh_DefHotkey =
	}

	uh_NumHotkeys_new = %uh_NumHotkeys%
	uh_SpecialCommands = <PasteFile>,<Send>,<SendRaw>,<Send Delay:50>,<SendPlay>,<ControlSend>,<ControlClick>,<Reload>,<ListHotkeys>,<ListLines>,<ListVars>,<ExitApp>,<KeyHistory>,<ChDir>,<getControl>,<getColour>,<getControlText>,<Single>,<SingleInstance>,<SingleInstanceClose>,<SingleInstanceKill>,<AOT>,<Min>,<Max>,<Hide>,<CategoryMenu>,<CategoryLaunchAll>,<AltTab>,<ShiftAltTab>,<AltTabAndMenu>,<AltTabMenuDismiss>,<WorkingDir`:"...">,<PostMessage>,<WheelUp>,<WheelDown>,<MouseMoveTo>,<MouseMoveBy>,<activAid>,<ShowExtensionMenu>,<Config>,<OnShutDown>,<PerformAction>
	uh_LegendItems= %uh_SpecialCommands%,`%Selection`%,`%SelectionURL`%,`%SelectionPaste`%,`%SelectionURLPaste`%
	Loop
	{
		If Extension[%A_Index%] =
			break
		Menu, uh_SpecialCommandsExtensionMenu, Add, % "<ShowExtensionMenu>" Extension[%A_Index%], uh_sub_InsertSpecialCmd
		Menu, uh_ConfigExtensions, Add, % "<Config>" Extension[%A_Index%], uh_sub_InsertSpecialCmd
	}

	Loop, parse, Actions, |
	{
		If A_LoopField =
			break

		uh_MenuActionDescription := ActionDesc%A_LoopField%

		Menu, uh_SpecialCommandsActionsMenu, Add, % uh_MenuActionDescription, uh_sub_InsertAction
	}

	Loop, Parse, uh_LegendItems, `,
	{
		If A_LoopField = <ShowExtensionMenu>
			Menu, uh_SpecialCommands, Add, %A_LoopField%, :uh_SpecialCommandsExtensionMenu
		Else
		If A_LoopField = <PerformAction>
			Menu, uh_SpecialCommands, Add, %A_LoopField%, :uh_SpecialCommandsActionsMenu
		Else
		If A_LoopField = <Config>
			Menu, uh_SpecialCommands, Add, %A_LoopField%, :uh_ConfigExtensions
		Else
			Menu, uh_SpecialCommands, Add, %A_LoopField%, uh_sub_InsertSpecialCmd
	}

	uh_AlphaNums := "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"
Return

uh_sub_Action_UserHotkey:
	uh_ThisPath := ActionPara%LastAction%
	gosub, sub_Hotkey_UserHotkey
return

GuiContextMenu_UserHotkeys:
	If A_GuiControl = uh_ListView
		Gosub, uh_sub_ContextMenu
	Else
		GuiContextMenu =
Return

SettingsGui_UserHotkeys:
	uh_Categories = |
	uh_Apps =
	Gui, Add, Text, xs+10 y+2 w50, %lng_uh_Category%:
	Gui, Add, DropDownList, x+5 yp-3 w160 vuh_CategoryFilter guh_sub_CategoryFilter, %uh_Categories%

	Gui, Add, Text, xs+235 yp+3 w130 Hidden, %lng_uh_CategoryHotkey%:
	func_HotkeyAddGuiControl( "", "uh_CatHotkey", "X+5 YP-3 w190 Hidden guh_sub_CatHotkey")

	Gui, Add, ListView, Hwnduh_LVHwnd Count%uh_NumHotkeys% AltSubmit -Multi -LV0x10 Grid xs+10 y+5 h245 w550 vuh_ListView guh_sub_ListView, Hk|%lng_Hotkey%|%lng_uh_Command%|%lng_uh_Category%|Cmd|#|App

	GuiControl, -Redraw, uh_ListView
	Loop, %uh_NumHotkeys%
	{
		If A_IsCompiled = 1
			StringReplace, uh_Path%A_Index%, uh_Path%A_Index%, .ahk, .exe

		uh_Path%A_Index%_new := uh_Path%A_Index%
		uh_Category%A_Index%_new := uh_Category%A_Index%
		uh_App%A_Index%_new := uh_App%A_Index%
		If uh_Description%A_Index% =
			uh_Description%A_Index%_new := uh_func_ShortenPath(uh_Path%A_Index%)
		Else
			uh_Description%A_Index%_new := uh_Description%A_Index%

		LV_Add("", Hotkey_uh_Hotkey%A_Index%_new, func_HotkeyDecompose(Hotkey_uh_Hotkey%A_Index%_new,0,0), uh_Description%A_Index%_new, uh_Category%A_Index%_new, uh_Path%A_Index%_new, A_Index, uh_App%A_Index%_new)

		Hotkey_ExtensionText[uh_Hotkey%A_Index%] := uh_Path%A_Index%_new

		If uh_Category%A_Index%_new <>
		{
			IfNotInstring, uh_Category%A_Index%_new, % lng_uh_Application
			{
				StringReplace, uh_Categories, uh_Categories, % uh_Category%A_Index%_new "|", , All
				uh_Categories := uh_Categories uh_Category%A_Index%_new "|"
			}
		}

		If uh_App%A_Index%_new <>
		{
			StringReplace, uh_Apps, uh_Apps, % lng_uh_Application uh_App%A_Index%_new "|", , All
			uh_Apps := uh_Apps lng_uh_Application uh_App%A_Index%_new "|"
			func_CreateListOfHotkeys( Hotkey_uh_Hotkey%A_Index%_new, uh_Description%A_Index%_new, "UserHotkeys", "sub_Hotkey_UserHotkey", uh_App%A_Index%_new )
		}
		Else
			func_CreateListOfHotkeys( Hotkey_uh_Hotkey%A_Index%_new, uh_Description%A_Index%_new, "UserHotkeys", "sub_Hotkey_UserHotkey" )
	}

	LV_ModifyCol(1,0)
	LV_ModifyCol(2,150)
	LV_ModifyCol(3,280)
	LV_ModifyCol(4,99)
	LV_ModifyCol(5,0)
	LV_ModifyCol(6,0)
	LV_ModifyCol(7,0)
	LV_Modify(1, "Focus")
	GuiControl, +Redraw, uh_ListView

	Gui, Add, Button, -Wrap xs+365 ys+290 w25 h15 guh_sub_AddHotkey, +
	Gui, Add, Button, -Wrap x+5 h15 w25 guh_sub_DelHotkey, %MinusString%
	Gui, Add, Button, -Wrap x+5 h15 w135 guh_sub_EditHotkey, %lng_uh_Edit%

	GuiControl, , uh_CategoryFilter, |%uh_Categories%%uh_Apps%
	GuiControl, Choose, uh_CategoryFilter, 1

	uh_EditTitle = %lng_uh_Edit%

	Gui, Add, CheckBox, gsub_CheckIfSettingsChanged vuh_BalloonTip Check3 xs+220 ys+290 -Wrap Checked%uh_BalloonTip%, %lng_uh_BalloonTips%
Return

uh_sub_CategoryFilter:
	Critical
	Gui, %GuiID_activAid%:Default
	Gui, ListView, uh_ListView

	GuiControlGet, uh_CategoryFilter
	uh_CategoryFilterOrg = %uh_CategoryFilter%
	StringReplace, uh_CategoryFilter, uh_CategoryFilter, %lng_uh_Application%,,

	If uh_CategoryFilter =
	{
		GuiControl, Hide, %lng_uh_CategoryHotkey%:
		GuiControl, Hide, Hotkey_uh_CatHotkey
	}
	Else
	{
		GuiControl, Show, %lng_uh_CategoryHotkey%:
		GuiControl, Show, Hotkey_uh_CatHotkey
		GuiControl,, Hotkey_uh_CatHotkey,
		uh_CatHotkeyNum =
	}

	GuiControl, -Redraw, uh_ListView
	LV_Delete()
	Loop, %uh_numHotkeys_new%
	{
		If (uh_Category%A_Index%_new = uh_CategoryFilterOrg OR uh_Category%A_Index%_new = uh_CategoryFilter OR uh_CategoryFilter = "" OR uh_App%A_Index%_new = uh_CategoryFilter)
		{
			If uh_Description%A_Index%_new =
				uh_Description%A_Index%_new := uh_func_LocalizedCommand(uh_Path%A_Index%_new)

			If ((uh_Path%A_Index%_new <> "<CategoryMenu>" AND uh_Path%A_Index%_new <> "<CategoryMenu> ") OR uh_CategoryFilter = "")
				LV_Add("", Hotkey_uh_Hotkey%A_Index%_new, func_HotkeyDecompose(Hotkey_uh_Hotkey%A_Index%_new,0,0), uh_Description%A_Index%_new, uh_Category%A_Index%_new, uh_Path%A_Index%_new, A_Index, uh_App%A_Index%_new)
			Else
			{
				uh_CatHotkeyNum := A_Index
				GuiControl,, Hotkey_uh_CatHotkey, % func_HotkeyDecompose(Hotkey_uh_Hotkey%A_Index%_new)
			}
		}
	}

	LV_ModifyCol(1,0)
	LV_ModifyCol(2,150)
	LV_ModifyCol(3,280)
	LV_ModifyCol(4,99)
	LV_ModifyCol(5,0)
	LV_ModifyCol(6,0)
	LV_ModifyCol(7,0)

	If (uh_LVrow > LV_GetCount())
	{
		;LV_ModifyCol(uh_SortCol, uh_SortCol%uh_SortCol%)
		LV_Modify(1, "Select")
	}
	Else
	{
		LV_Modify(uh_LVrow, "Select")
		LV_Modify( uh_LVrow, "Vis" )
	}

	GuiControl, +Redraw, uh_ListView
Return

uh_sub_CatHotkey:
	Gosub, sub_HotkeyButton
	If uh_CatHotkeyNum =
	{
		uh_NumHotKeys_new++
		uh_CatHotkeyNum = %uh_NumHotKeys_new%
		uh_Category%uh_CatHotkeyNum%_new = %uh_CategoryFilterOrg%
		uh_Path%uh_CatHotkeyNum%_new = <CategoryMenu>
	}
	Hotkey_uh_Hotkey%uh_CatHotkeyNum%_new := Hotkey_uh_CatHotkey_new
Return

uh_sub_ListView:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, uh_ListView
	StringCaseSense, On
	If A_GuiEvent = s
		GuiControl, +Redraw, uh_ListView

	If A_GuiEvent in I,E,F,f,M,S,s
		Return

	MouseGetPos,, uh_MouseY
	If (uh_DragY AND uh_MouseY > uh_DragY+2 AND A_GuiEvent = "D")
	{
		uh_StartDragY = %uh_DragY%
		uh_StartRow := LV_GetNext(0)
		SetTimer, uh_tim_Dragging,20
	}
	If (uh_DragY AND uh_MouseY < uh_DragY-2 AND A_GuiEvent = "D")
	{
		uh_StartDragY = %uh_DragY%
		uh_StartRow := LV_GetNext(0)
		SetTimer, uh_tim_Dragging,20
	}

	uh_DragY =
	If A_GuiEvent = C
	{
		uh_DragY = %uh_MouseY%
		Return
	}

	uh_lastRow := uh_LVrow
	uh_LVrow := LV_GetNext()

	If A_GuiEvent in Normal,D,d
	{
		GuiControlGet, uh_temp, FocusV
		if uh_temp <> uh_ListView
			GuiControl, Focus, uh_ListView
		Return
	}

	StringCaseSense, Off

	LV_GetText(uh_RowText, uh_LVrow, 5)

	uh_EventInfo =
	If A_GuiEvent = K
	{
		GetKeyState, uh_CtrlState, Ctrl, P
		uh_EventInfo = %A_EventInfo%
		If uh_CtrlState = D
			uh_EventInfo += 1000
		GetKeyState, uh_AltState, Alt, P
		If uh_AltState = D
			uh_EventInfo += 5000
	}

	If ( A_GuiEvent = "A" OR A_GuiEvent = "DoubleClick" OR uh_EventInfo = 32 )
		Goto, uh_sub_EditHotkey

	If uh_EventInfo = 46
		Goto, uh_sub_DelHotkey
	If uh_EventInfo = 45
		Goto, uh_sub_AddHotkey
	If uh_EventInfo = 5038 ; Alt+Up
		Goto, uh_sub_MoveUp
	If uh_EventInfo = 5040 ; Alt+Down
		Goto, uh_sub_MoveDown
	If uh_EventInfo = 5036 ; Alt+Home
		Goto, uh_sub_MoveTop
	If uh_EventInfo = 5035 ; Alt+End
		Goto, uh_sub_MoveBottom
	If uh_EventInfo = 1068 ; Ctrl+D
		Goto, uh_sub_DuplicateHotkey

	If A_GuiEvent = ColClick
	{
		If uh_SortCol%A_EventInfo% <> Sort
			uh_SortCol%A_EventInfo% = Sort
		Else
			uh_SortCol%A_EventInfo% = SortDesc

		LV_ModifyCol(A_EventInfo, uh_SortCol%A_EventInfo%)

		uh_Sort := A_EventInfo uh_SortCol%A_EventInfo%
		uh_SortCol := A_EventInfo

		func_SettingsChanged( "UserHotkeys" )
	}
Return

uh_tim_Dragging:
	If (!GetKeyState("LButton"))
	{
		SetTimer, uh_tim_Dragging, Off
;      ToolTip
		Return
	}
	Critical
	Gui, %GuiID_activAid%:Default
	Gui, ListView, uh_ListView

	uh_RowHeight := func_GetLVRowHeight("ahk_id " uh_LVHwnd,"")
	MouseGetPos,, uh_MouseY
	uh_DragRow := Round(uh_StartRow-(uh_StartDragY-uh_MouseY)/uh_RowHeight)
	uh_FirstRow := LV_GetNext(0)
	uh_MoveCount := Abs(uh_DragRow-uh_FirstRow)

	uh_DontVis = 1
	If (uh_DragRow-uh_FirstRow < 0 AND uh_FirstRow > 1)
		Loop, %uh_MoveCount%
			Gosub, uh_sub_MoveUp
	If (uh_DragRow-uh_FirstRow > 0 AND uh_FirstRow+LV_GetCount("Selected")-1 < LV_GetCount())
		Loop, %uh_MoveCount%
			Gosub, uh_sub_MoveDown
	uh_DontVis =

;   ToolTip, %uh_StartRow%:%uh_FirstRow% -> %uh_DragRow% = %uh_MoveCount%
Return


uh_sub_MoveUp:
	Critical
	Gui, %GuiID_activAid%:Default
	Gui, ListView, uh_ListView
	uh_LVrow1 := LV_GetNext()
	uh_LVrow2 := uh_LVrow1-1
	If uh_LVrow1 > 1
	{
		Gosub, uh_sub_ExchangeRows
		func_SettingsChanged( "UserHotkeys" )
		uh_LVRow := uh_LVrow2
		If uh_DontVis = 1
			LV_Modify( uh_LVrow, "Select Focus" )
		Else
			LV_Modify( uh_LVrow, "Select Focus Vis" )
		uh_lastRow := uh_LVrow
	}

Return

uh_sub_MoveDown:
	Critical
	Gui, %GuiID_activAid%:Default
	Gui, ListView, uh_ListView
	uh_LVrow1 := LV_GetNext()
	uh_LVrow2 := uh_LVrow1+1
	If (uh_LVrow1 < LV_GetCount())
	{
		Gosub, uh_sub_ExchangeRows
		func_SettingsChanged( "UserHotkeys" )
		uh_LVRow := uh_LVrow2
		If uh_DontVis = 1
			LV_Modify( uh_LVrow, "Select Focus" )
		Else
			LV_Modify( uh_LVrow, "Select Focus Vis" )
		uh_lastRow := uh_LVrow
	}
Return

uh_sub_MoveTop:
	Critical
	Gui, %GuiID_activAid%:Default
	Gui, ListView, uh_ListView
	Loop, % LV_GetNext()-1
	{
		uh_LVrow1 := LV_GetNext()-A_Index+1
		uh_LVrow2 := uh_LVrow1-1
		If uh_LVrow1 > 1
			Gosub, uh_sub_ExchangeRows
		If A_Index = 1
			func_SettingsChanged( "UserHotkeys" )
	}
	uh_LVRow := 1
	LV_Modify( uh_LVrow, "Select Focus Vis" )
Return

uh_sub_MoveBottom:
	Critical
	Gui, %GuiID_activAid%:Default
	Gui, ListView, uh_ListView
	Loop, % LV_GetCount()-LV_GetNext()
	{
		uh_LVrow1 := LV_GetNext()+A_Index-1
		uh_LVrow2 := uh_LVrow1+1
		If (uh_LVrow1 < LV_GetCount())
			Gosub, uh_sub_ExchangeRows
		If A_Index = 1
			func_SettingsChanged( "UserHotkeys" )
	}
	uh_LVRow := LV_GetCount()
	LV_Modify( uh_LVrow, "Select Focus Vis" )
Return

uh_sub_ExchangeRows:
	LV_GetText(uh_thisRow, uh_LVrow1, 6)
	LV_GetText(uh_nextRow, uh_LVrow2, 6)
	Hotkey_uh_Hotkey_tmp := Hotkey_uh_Hotkey%uh_thisRow%_new
	HotkeyClasses_uh_Hotkey_tmp := HotkeyClasses_uh_Hotkey%uh_thisRow%_new
	uh_Path_tmp := uh_Path%uh_thisRow%_new
	uh_Description_tmp := uh_Description%uh_thisRow%_new
	uh_Category_tmp := uh_Category%uh_thisRow%_new
	uh_App_tmp := uh_App%uh_thisRow%_new
	uh_ProcID_tmp := uh_ProcID%uh_thisRow%_new

	Hotkey_uh_Hotkey%uh_thisRow%_new := Hotkey_uh_Hotkey%uh_nextRow%_new
	HotkeyClasses_uh_Hotkey%uh_thisRow%_new := HotkeyClasses_uh_Hotkey%uh_nextRow%_new
	uh_Path%uh_thisRow%_new := uh_Path%uh_nextRow%_new
	uh_Description%uh_thisRow%_new := uh_Description%uh_nextRow%_new
	uh_Category%uh_thisRow%_new := uh_Category%uh_nextRow%_new
	uh_App%uh_thisRow%_new := uh_App%uh_nextRow%_new
	uh_ProcID%uh_thisRow%_new := uh_ProcID%uh_nextRow%_new

	Hotkey_uh_Hotkey%uh_nextRow%_new := Hotkey_uh_Hotkey_tmp
	HotkeyClasses_uh_Hotkey%uh_nextRow%_new := HotkeyClasses_uh_Hotkey_tmp
	uh_Path%uh_nextRow%_new := uh_Path_tmp
	uh_Description%uh_nextRow%_new := uh_Description_tmp
	uh_Category%uh_nextRow%_new := uh_Category_tmp
	uh_App%uh_nextRow%_new := uh_App_tmp
	uh_ProcID%uh_nextRow%_new := uh_ProcID_tmp

	LV_Modify( uh_LVrow1,"", Hotkey_uh_Hotkey%uh_thisRow%_new, func_HotkeyDecompose(Hotkey_uh_Hotkey%uh_thisRow%_new,0,0), uh_Description%uh_thisRow%_new, uh_Category%uh_thisRow%_new, uh_Path%uh_thisRow%_new, uh_thisRow, uh_App%uh_thisRow%_new)
	LV_Modify( uh_LVrow2,"", Hotkey_uh_Hotkey%uh_nextRow%_new, func_HotkeyDecompose(Hotkey_uh_Hotkey%uh_nextRow%_new,0,0), uh_Description%uh_nextRow%_new, uh_Category%uh_nextRow%_new, uh_Path%uh_nextRow%_new, uh_nextRow, uh_App%uh_nextRow%_new)
Return

uh_sub_DelHotkey:
	Critical

	If uh_NumHotKeys_new = 0
		Return

	Gui, %GuiID_activAid%:Default
	Gui, ListView, uh_ListView

	uh_LVrow := LV_GetNext()
	LV_GetText(uh_Num, uh_LVrow, 6)

	func_HotkeyDisable( "uh_Hotkey" uh_LVrow )
	LV_Delete( uh_LVrow )
	LV_Modify( uh_LVrow, "Select")

	StringReplace, Hotkey_AllNewHotkeys, Hotkey_AllNewHotkeys, % "«<" Hotkey_uh_Hotkey%uh_LVrow%_new " >»",, A

	uh_delRows := uh_NumHotKeys_new - uh_Num
	GuiControl, -Redraw, uh_ListView
	Loop, %uh_delRows%
	{
		uh_nextRow := uh_Num + A_Index
		Uh_thisRow := uh_nextRow - 1
		Hotkey_uh_Hotkey%uh_thisRow%_new := Hotkey_uh_Hotkey%uh_nextRow%_new
		HotkeyClasses_uh_Hotkey%uh_thisRow%_new := HotkeyClasses_uh_Hotkey%uh_nextRow%_new
		uh_Path%uh_thisRow%_new := uh_Path%uh_nextRow%_new
		uh_Description%uh_thisRow%_new := uh_Description%uh_nextRow%_new
		uh_Category%uh_thisRow%_new := uh_Category%uh_nextRow%_new
		uh_App%uh_thisRow%_new := uh_App%uh_nextRow%_new
		uh_ProcID%uh_thisRow%_new := uh_ProcID%uh_nextRow%_new
		LV_Modify( uh_LVrow+A_Index-1,"Col6", uh_thisRow)
	}
	GuiControl, +Redraw, uh_ListView
	uh_NumHotkeys_new--

	Gosub, uh_sub_RefreshCategories

	func_SettingsChanged( "UserHotkeys" )
Return

uh_sub_RefreshCategories:
	uh_Categories = |
	uh_Apps = |
	Loop, %uh_NumHotkeys_new%
	{
		If uh_Category%A_Index%_new <>
		{
			IfNotInstring, uh_Category%A_Index%_new, % lng_uh_Application
			{
				StringReplace, uh_Categories, uh_Categories, % uh_Category%A_Index%_new "|", , All
				uh_Categories := uh_Categories uh_Category%A_Index%_new "|"
			}
		}
		If uh_App%A_Index%_new <>
		{
			StringReplace, uh_Apps, uh_Apps, % lng_uh_Application uh_App%A_Index%_new "|", , All
			uh_Apps := uh_Apps lng_uh_Application uh_App%A_Index%_new "|"
		}
	}
	GuiControl, , uh_CategoryFilter, |%uh_Categories%%uh_Apps%
	GuiControl, Choose, uh_CategoryFilter, 1
	GuiControl, ChooseString, uh_CategoryFilter, %uh_CategoryFilter%
Return

uh_sub_AddHotkey:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, uh_ListView
	GuiControlGet, uh_CategoryFilter
	If uh_CategoryFilter <>
	{
		IfNotInString, uh_CategoryFilter, %lng_uh_Application%
		{
			StringReplace, uh_Categories, uh_Categories, % uh_CategoryFilter "|", , All
			uh_Categories := uh_Categories uh_CategoryFilter "|"
			uh_CategoryFilterTmp = %uh_CategoryFilter%
		}
		Else
		{
			StringReplace, uh_AppTmp, uh_CategoryFilter, %lng_uh_Application%, , All
			uh_CategoryFilterTmp =
		}
	}

	uh_NumHotkeys_new++
	LV_Add("Select", "","","",uh_CategoryFilterTmp,"",uh_NumHotKeys_new)
	uh_LVrow := LV_GetNext()
	uh_EditTitle = %lng_uh_Add%
	Hotkey_uh_Hotkey%uh_NumHotkeys_new%_Sub = sub_Hotkey_UserHotkey
	HotkeyClasses_uh_Hotkey%uh_NumHotkeys_new% = ,
	Gosub, uh_sub_EditHotkey
Return

uh_sub_DuplicateHotkey:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, uh_ListView

	if (uh_LVrow = 0 OR uh_LVrow = "")
		Return

	LV_GetText(Hotkey_uh_Hotkey, uh_LVrow, 1)
	LV_GetText(uh_Description, uh_LVrow, 3)
	LV_GetText(uh_Category, uh_LVrow, 4)
	LV_GetText(uh_Path, uh_LVrow, 5)
	LV_GetText(uh_Num, uh_LVrow, 6)
	LV_GetText(uh_App, uh_LVrow, 7)

	uh_NumHotkeys_new++
	LV_Add("Select", "", "", uh_Description, uh_Category, uh_Path, uh_NumHotkeys_new, uh_App)
	uh_LVrow := LV_GetNext()
	uh_EditTitle = %lng_uh_Add%
	Hotkey_uh_Hotkey%uh_NumHotkeys_new%_Sub = sub_Hotkey_UserHotkey
	HotkeyClasses_uh_Hotkey%uh_NumHotkeys_new% = ,
	Gosub, uh_sub_EditHotkey
Return

uh_sub_EditHotkey:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, uh_ListView

	if (uh_LVrow = 0 OR uh_LVrow = "")
		Goto, uh_sub_AddHotkey

	If uh_GUI = 3
		Return

	uh_GUI = 3

	LV_GetText(Hotkey_uh_Hotkey, uh_LVrow, 1)
	LV_GetText(uh_Description, uh_LVrow, 3)
	LV_GetText(uh_Category, uh_LVrow, 4)
	LV_GetText(uh_Path, uh_LVrow, 5)
	LV_GetText(uh_Num, uh_LVrow, 6)
	LV_GetText(uh_App, uh_LVrow, 7)
	Hotkey_uh_Hotkey_new = %Hotkey_uh_Hotkey%
	HotkeyClasses_uh_Hotkey = ,

	If (uh_AppTmp <> "" AND uh_App = "")
		uh_App = %uh_AppTmp%

	StringReplace, uh_AppsTmp, uh_Apps, %lng_uh_Application%,, A

	Gui, %GuiID_activAid%:+Disabled
	GuiDefault("UserHotkeys", "-MaximizeBox +Owner" GuiID_activAid)
	Gosub, GuiDefaultFont

	;Hotkey_uh_Hotkey%uh_LVrow% := Hotkey_uh_Hotkey%uh_LVrow%_new
	func_HotkeyAddGuiControl( lng_Hotkey, "uh_Hotkey", "y+10 w80" )
	If (uh_Description = uh_func_ShortenPath(uh_Path))
		uh_Description =
	Gui, Add, Text, x10 y+7 w80, %lng_uh_Description%:
	Gui, Add, Edit, x+5 R1 yp-3 W200 Hwnduh_DescriptionHwnd vuh_Description, % uh_Description
	SendMessage, 208, 0, RegisterCallback("EditWordBreakProc"), , ahk_id %uh_DescriptionHwnd%
	Gui, Add, Text, x+25 yp+3 w50, %lng_uh_Category%:
	Gui, Add, ComboBox, x+5 yp-3 W180 vuh_Category, %uh_Categories%
	GuiControl, ChooseString, uh_Category, %uh_Category%
	Gui, Add, Text, x10 y+7 w80, %lng_Command%:
	Gui, Add, Edit, x+5 yp-3 W460 h20 R3 -WantReturn Hwnduh_PathHwnd vuh_Path, % uh_Path
	SendMessage, 208, 0, RegisterCallback("EditWordBreakProc"), , ahk_id %uh_PathHwnd%
	Gui, Add, Button, -Wrap x+5 h20 W21 vuh_Button guh_sub_Browse, ...
	Gui, Add, Button, -Wrap h18 guh_sub_SpecialCmdMenu x95 y+30, %lng_uh_Legend%
	Gui, Add, Button, -Wrap X+5 h18 w20 vCH_UserHotkeys gsub_ContextHelp, ?
	Gui, Add, Button, xs+295 w250 yp h18 guh_sub_ClipSave, %lng_uh_ClipSave%

	Gui, Add, Text, x95 y+15, %lng_uh_OnlyOneApplication%
	Gui, Add, ComboBox, y+5 w460 vuh_App, %uh_AppsTmp%
	Gui, Add, Button, -Wrap x+5 w20 h21 vuh_Add_App guh_sub_addApp, +

	GuiControl, ChooseString, uh_App, % uh_App
	Gui, Add, Button, -Wrap y+10 x200 w100 Default guh_sub_OK, &OK
	Gui, Add, Button, -Wrap x+10 w100 gUserHotkeysGuiClose, %lng_Cancel%
	Gui, Show, w600 AutoSize, %uh_EditTitle%

	uh_AppTmp =
Return

uh_sub_SpecialCmdMenu:
	Menu, uh_SpecialCommands, Show
Return

UserHotkeysGuiContextMenu:
uh_sub_InsertSpecialCmd:
	GuiControl, %GuiID_UserHotkeys%:Focus, uh_Path
	SendRaw, %A_ThisMenuItem%
Return

uh_sub_InsertAction:
	uh_EscapedDesc := func_StrClean(A_ThisMenuItem)
	uh_ActionName := ActionNameByDesc%uh_EscapedDesc%

	GuiControl, %GuiID_UserHotkeys%:Focus, uh_Path
	SendRaw, <PerformAction>%uh_ActionName%
Return

uh_sub_OK:
	Gui, %GuiID_activAid%:-Disabled
	Gui, Submit
	Gui, Destroy
	Gui, %GuiID_activAid%:Default
	Gui, ListView, uh_ListView

	uh_GUI =

	If uh_Description =
		uh_Description := uh_func_ShortenPath(uh_Path)

	Loop, Parse, uh_SpecialCommands, `,
		StringReplace, uh_Path, uh_Path, <%A_LoopField%>%A_Space%, <%A_LoopField%>

	LV_Modify( uh_LVrow,"" , Hotkey_uh_Hotkey_new, func_HotkeyDecompose(Hotkey_uh_Hotkey_new,0,0), uh_Description, uh_Category, uh_Path,uh_Num, uh_App )

	Hotkey_uh_Hotkey%uh_Num%_new := Hotkey_uh_Hotkey_new
	uh_Description%uh_Num%_new := uh_Description
	uh_Category%uh_Num%_new := uh_Category
	uh_Path%uh_Num%_new := uh_Path
	uh_App%uh_Num%_new := uh_App

	uh_ProcID%uh_Num% =
	IniDelete, %ConfigFile%, %uh_ScriptName%, GroupProcessID%uh_Num%
	IniDelete, %ConfigFile%, %uh_ScriptName%, GroupProcesses%uh_Num%

	If uh_Category <>
	{
		StringReplace, uh_Categories, uh_Categories, % uh_Category "|", , All
		uh_Categories := uh_Categories uh_Category "|"
	}
	If uh_App <>
	{
		StringReplace, uh_Apps, uh_Apps, % lng_uh_Application uh_App "|", , All
		uh_Apps := uh_Apps lng_uh_Application uh_App "|"
	}
	GuiControl, , uh_CategoryFilter, |%uh_Categories%%uh_Apps%
	If uh_Category =
		GuiControl, Choose, uh_CategoryFilter, 1
	Else
		GuiControl, ChooseString, uh_CategoryFilter, %uh_CategoryFilter%

	uh_EditTitle = %lng_uh_Edit%
	func_SettingsChanged( "UserHotkeys" )

	LV_Modify( uh_LVrow, "Vis" )

	If uh_SettingsChanged = 1
	{
		Gosub, uh_sub_CategoryFilter
		uh_SettingsChanged =
	}
Return

UserHotkeysGuiClose:
UserHotkeysGuiEscape:
	If GetKey = Escape
	{
		GetKey =
		Return
	}
	Gui, %GuiID_activAid%:-Disabled
	Gui, Submit
	Gui, Destroy
	Gui, %GuiID_activAid%:Default
	Gui, ListView, uh_ListView

	uh_GUI =

	Hotkey_uh_Hotkey%uh_Num%_new := Hotkey_uh_Hotkey%uh_Num%

	StringReplace, Hotkey_AllNewHotkeys, Hotkey_AllNewHotkeys, % "«<" Hotkey_uh_Hotkey_new " >»",, A

	If uh_EditTitle = %lng_uh_Add%
	{
		LV_Delete( uh_LVrow )
		uh_NumHotkeys_new--
	}
	uh_EditTitle = %lng_uh_Edit%

	uh_SettingsChanged =
Return

uh_sub_ContextMenu:
	If GuiContextMenu_UserHotkeys =
	{
		GuiContextMenu_UserHotkeys = visible
		Menu, uh_ContextMenu, Add, %lng_uh_CMEdit% , uh_sub_EditHotkey
		Menu, uh_ContextMenu, Add, %lng_uh_CMAdd% , uh_sub_AddHotkey
		Menu, uh_ContextMenu, Add, %lng_uh_CMDuplicate% , uh_sub_DuplicateHotkey
		Menu, uh_ContextMenu, Add, %lng_uh_CMDelete% , uh_sub_DelHotkey
		Menu, uh_ContextMenu, Add
		Menu, uh_ContextMenu, Add, %lng_uh_CMtop% , uh_sub_MoveTop
		Menu, uh_ContextMenu, Add, %lng_uh_CMup% , uh_sub_MoveUp
		Menu, uh_ContextMenu, Add, %lng_uh_CMdown% , uh_sub_MoveDown
		Menu, uh_ContextMenu, Add, %lng_uh_CMbottom% , uh_sub_MoveBottom
	}
	Menu, uh_ContextMenu, Show
	Menu, uh_ContextMenu, DeleteAll
	GuiContextMenu_UserHotkeys =
Return

uh_sub_Browse:
	Gui +OwnDialogs
	;StringReplace, uh_Control, A_GuiControl,
	;GuiControlGet, uh_Control,%GuiID_UserHotkeys%:,uh_Path ;%uh_Control%

	GuiControlGet, uh_DefaultPath,%GuiID_UserHotkeys%:,uh_Path
	uh_PathOnly = %uh_DefaultPath%
	uh_PathOrg = %uh_DefaultPath%

	IfNotExist, %uh_DefaultPath%
	{
		uh_DefaultPath1 =
		IfInString, uh_DefaultPath, <
		{
			StringGetPos, uh_tmpPos, uh_DefaultPath, >, R
			StringLeft, uh_DefaultPath1, uh_DefaultPath, % uh_tmpPos + 1
			StringMid, uh_DefaultPath, uh_DefaultPath, % uh_tmpPos+2
		}
		Loop
		{
			StringGetPos, uh_PathBeginVars, uh_DefaultPath, %A_Space%, R%A_Index%
			If ErrorLevel = 1
			{
				break
			}
			StringLeft, uh_PathOnly, uh_DefaultPath, %uh_PathBeginVars%
			If (InStr(FileExist(uh_PathOnly), "D") = 0 AND FileExist(uh_PathOnly))
			{
				StringMid, uh_Parameters, uh_Path, % uh_PathBeginVars+1
				break
			}
			uh_PathOnly = %uh_DefaultPath%
		}
	}


	SplitPath, uh_PathOnly, uh_DefaultFile, uh_DefaultPath

	if uh_DefaultPath =
	{
		IfExist, %uh_DefaultFile%
			uh_DefaultPath = %A_ScriptDir%\%uh_DefaultFile%
		Else IfExist, extensions\UserHotkeys-scripts\%uh_DefaultFile%
			uh_DefaultPath = extensions\UserHotkeys-scripts\%uh_DefaultFile%
		Else
			uh_DefaultPath = %uh_DefaultPath%\%uh_DefaultFile%
	}
	Else
		uh_DefaultPath = %uh_DefaultPath%\%uh_DefaultFile%

	IfNotExist, %uh_DefaultPath%
		uh_DefaultPath = extensions\UserHotkeys-scripts\

	If uh_PathOrg contains <Single>,<SingleInstance>,<SingleInstanceClose>,<SingleInstanceKill>
		FileSelectFile, uh_Control,, %uh_DefaultPath%, %uh_ScriptName%, *.exe
	Else
		FileSelectFile, uh_Control,, %uh_DefaultPath%, %uh_ScriptName%, %lng_uh_FileTypes%
	If Errorlevel = 0
	{
		StringReplace, uh_Control, uh_Control, %A_Scriptdir%\,
		StringReplace, uh_Control, uh_Control, extensions\userhotkeys-scripts\,
		StringSplit, uh_ControlTmp, uh_Control, %A_Space%
		uh_AddQuotes =
		Loop, Parse, PATHEXT, `;
		{
			IfExist, %uh_ControlTmp1%%A_LoopField%
				uh_AddQuotes = %A_Quote%
		}
		GuiControl,%GuiID_UserHotkeys%:,uh_Path, %uh_AddQuotes%%uh_DefaultPath1%%uh_Control%%uh_AddQuotes%
	}
Return

SaveSettings_UserHotkeys:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, uh_ListView
	uh_LastCategoryFilter = %uh_CategoryFilter%
	If uh_CategoryFilter <>
	{
		uh_CategoryFilter =
		GuiControl, Choose, uh_CategoryFilter, 1
		Gosub, uh_sub_CategoryFilter
	}
	IniDelete, %ConfigFile%, %uh_ScriptName%
	uh_NumHotkeys := LV_GetCount()
	IniWrite, %uh_NumHotkeys%, %ConfigFile%, %uh_ScriptName%, NumberOfHotkeys
	IniWrite, %uh_Sort%, %ConfigFile%, %uh_ScriptName%, SortCol
	IniWrite, %uh_BalloonTip%, %ConfigFile%, %uh_ScriptName%, ShowBalloonTip
	IniWrite, %uh_BalloonTimeOut%, %ConfigFile%, %uh_ScriptName%, BalloonTimeOut
	IniWrite, %uh_AOTModifyTitle%, %ConfigFile%, %uh_ScriptName%, AOTModifyTitle
	GuiControl, -Redraw, uh_ListView
	Loop, %uh_NumHotkeys%
	{
		LV_GetText(Hotkey_uh_Hotkey%A_Index%_new, A_Index, 1)
		LV_GetText(uh_Description%A_Index%, A_Index, 3)
		LV_GetText(uh_Category%A_Index%, A_Index, 4)
		LV_GetText(uh_Path%A_Index%, A_Index, 5)
		LV_GetText(uh_App%A_Index%, A_Index, 7)
		If (uh_Description%A_Index% = uh_func_LocalizedCommand(uh_Path%A_Index%))
			uh_Description%A_Index% =
		IniWrite,------------------------------------, %ConfigFile%, %uh_ScriptName%, --------------------------%A_Index%---

		uh_Path%A_Index% := RegExReplace( uh_Path%A_Index%, "`r`n|`n", "``n" )
		If uh_Path%A_Index% contains <AltTab,AltTab>
		{
			StringReplace, uh_Temp, uh_Path%A_Index%, <,,All
			StringReplace, uh_Temp, uh_Temp, >,,All
			func_HotkeyWrite( "uh_Hotkey" A_Index, ConfigFile, uh_ScriptName, "Hotkey" A_Index, uh_Temp, "$" )
		}
		Else
			func_HotkeyWrite( "uh_Hotkey" A_Index, ConfigFile, uh_ScriptName, "Hotkey" A_Index, "sub_Hotkey_UserHotkey", "$" )

		IniWrite, % A_Quote uh_Path%A_Index% A_Quote, %ConfigFile%, %uh_ScriptName%, Path%A_Index%
		IniWrite, % uh_Description%A_Index%, %ConfigFile%, %uh_ScriptName%, Description%A_Index%
		IniWrite, % uh_Category%A_Index%, %ConfigFile%, %uh_ScriptName%, Category%A_Index%
		IniWrite, % uh_App%A_Index%, %ConfigFile%, %uh_ScriptName%, Application%A_Index%
		LV_Modify( A_Index,"Col6", A_Index)
		uh_Description%A_Index%_new := uh_Description%A_Index%
		uh_Category%A_Index%_new := uh_Category%A_Index%
		uh_Path%A_Index%_new := uh_Path%A_Index%
		uh_App%A_Index%_new := uh_App%A_Index%
		uh_Description := uh_Description%A_Index%
		If uh_Description =
			uh_Description := uh_func_ShortenPath(uh_Path%A_Index%)
		registerAction("UserHotkey_" A_Index, uh_Description, "uh_sub_Action_UserHotkey", uh_Path%A_Index%)
	}
	GuiControl, +Redraw, uh_ListView
	IfExist, settings/Clipboards
		Gosub, uh_sub_CleanUpClipSaves

	If uh_LastCategoryFilter <>
	{
		uh_CategoryFilter = %uh_LastCategoryFilter%
		GuiControl, ChooseString, uh_CategoryFilter, %uh_CategoryFilter%
		Gosub, uh_sub_CategoryFilter
	}
Return

AddSettings_UserHotkeys:
	GuiDefault("activAid")
	Gui, ListView, uh_ListView
	If AddFreshSettings = 1
	{
		uh_NumHotkeys_new = 0
		LV_Delete()
	}

	uh_FirstError =
	Loop
	{
		IniRead, uh_PathTmp, %AddFile%, %uh_ScriptName%, Path%A_Index%

		If (uh_PathTmp = "ERROR" AND uh_FirstError = "")
			continue
		If uh_PathTmp = ERROR
			break

		uh_FirstError = 1
		IniRead, uh_HotkeyTmp, %AddFile%, %uh_ScriptName%, Hotkey%A_Index%
		IniRead, uh_DescriptionTmp, %AddFile%, %uh_ScriptName%, Description%A_Index%
		IniRead, uh_CategoryTmp, %AddFile%, %uh_ScriptName%, Category%A_Index%
		IniRead, uh_AppTmp, %AddFile%, %uh_ScriptName%, Application%A_Index%

		uh_Duplicates = 0
		Loop, %uh_NumHotkeys_new%
		{
			If (uh_HotkeyTmp = Hotkey_uh_Hotkey%A_Index%_new)
			{
				uh_Duplicates++
				break
			}
		}
		If uh_Duplicates = 0
		{
			uh_NumHotkeys_new++
			Hotkey_uh_Hotkey%uh_NumHotkeys_new%_new = %uh_HotkeyTmp%
			uh_Path%uh_NumHotkeys_new%_new = %uh_PathTmp%
			If uh_DescriptionTmp =
				uh_Description%uh_NumHotkeys_new%_new := uh_func_LocalizedCommand(uh_Path%uh_NumHotkeys_new%_new)
			Else
				uh_Description%uh_NumHotkeys_new%_new := uh_DescriptionTmp

			uh_Category%uh_NumHotkeys_new%_new := uh_CategoryTmp
			uh_App%uh_NumHotkeys_new%_new := uh_AppTmp

			LV_Add("", Hotkey_uh_Hotkey%uh_NumHotkeys_new%_new, func_HotkeyDecompose(Hotkey_uh_Hotkey%uh_NumHotkeys_new%_new,0,0), uh_Description%uh_NumHotkeys_new%_new, uh_Category%uh_NumHotkeys_new%_new, uh_Path%uh_NumHotkeys_new%_new, uh_NumHotkeys_new, uh_App%uh_NumHotkeys_new%_new)
		}
	}
	func_SettingsChanged( "UserHotkeys" )
	Gosub, uh_sub_RefreshCategories
Return

CancelSettings_UserHotkeys:
	Loop, %uh_NumHotkeys%
	{
		Hotkey_uh_Hotkey%A_Index%_new := Hotkey_uh_Hotkey%A_Index%
		uh_Path%A_Index%_new := uh_Path%A_Index%
		uh_Description%A_Index%_new := uh_Description%A_Index%
	}
	uh_NumHotkeys_new = %uh_NumHotkeys%
	IfExist, settings/Clipboards
		Gosub, uh_sub_CleanUpClipSaves
Return

DoEnable_UserHotkeys:
	Loop, %uh_NumHotkeys%
	{
		func_HotkeyEnable( "uh_Hotkey" A_Index )
	}
Return

DoDisable_UserHotkeys:
	Loop, %uh_NumHotkeys%
	{
		func_HotkeyDisable( "uh_Hotkey" A_Index )
	}
Return

DefaultSettings_UserHotkeys:
Return

SettingsChanged_UserHotkeys:
	uh_SettingsChanged = 1
	If uh_GUI =
	{
		Gosub, uh_sub_CategoryFilter
		uh_SettingsChanged =
	}
Return

OnShutDown_UserHotkeys:
	Loop, %uh_NumHotkeys%
	{
		If (InStr(uh_Path%A_Index%, "<OnShutDown>"))
		{
			uh_ThisPath := uh_Path%A_Index%
			uh_ThisApp := uh_App%A_Index%
			uh_ThisDescription := uh_Description%A_Index%
			uh_ThisHotkey := Hotkey_uh_Hotkey%A_Index%
			uh_OnShutdown = 1
			Gosub, sub_Hotkey_UserHotkey
			uh_OnShutdown =
		}
	}
Return

CheckShutDown_UserHotkeys:
	Loop, %uh_NumHotkeys%
	{
		If (InStr(uh_Path%A_Index%, "<OnShutDown>"))
			Result = 1
	}
Return


; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

sub_Hotkey_UserHotkey:
	Critical
	Setkeydelay, 0
	WinGet, uh_activeID, ID, A
	If uh_ThisPath =
	{
		If activAid_ThisHotkey <>
			uh_ThisHotkey := activAid_ThisHotkey

		uh_Path := func_HotkeyGetVar("uh_Hotkey",uh_NumHotkeys,"uh_Path",uh_ThisHotkey,"$")
		uh_Description := func_HotkeyGetVar("uh_Hotkey",uh_NumHotkeys,"uh_Description",uh_ThisHotkey,"$")
		uh_App := func_HotkeyGetVar("uh_Hotkey",uh_NumHotkeys,"uh_App",uh_ThisHotkey,"$")
	}
	Else
	{
		uh_Path = %uh_ThisPath%
		uh_App = %uh_ThisApp%
		uh_Description = %uh_ThisDescription%
	}
	If activAid_ThisHotkey =
		uh_A_ThisHotkey := func_prepareHotkeyForSend(A_ThisHotkey)
	Else
		uh_A_ThisHotkey := func_prepareHotkeyForSend(activAid_ThisHotkey)

	uh_HotkeyNumber := func_HotkeyGetNumber("uh_Hotkey",uh_NumHotkeys,"$", uh_ThisHotkey )
	uh_DescriptionOrPath = %uh_Description%
	if uh_Description =
		uh_DescriptionOrPath = %uh_Path%
	uh_Category := func_HotkeyGetVar("uh_Hotkey",uh_NumHotkeys,"uh_Category",uh_ThisHotkey,"$")
	uh_CategoryOrg = %uh_Category%
	StringReplace, uh_Category, uh_Category, %lng_uh_Application%,,

	uh_ThisDescription =
	uh_ThisHotkey =
	uh_ThisPath =
	uh_ThisApp =
	uh_Error = 0
	uh_LastError =

	If (func_StrLeft(uh_App, 5) = "[not]")
	{
		uh_NotApp = 1
		StringTrimLeft, uh_App, uh_App, 5
	}
	Else
		uh_NotApp = 0

	uh_WorkingDir =
	IfInString, uh_Path, <WorkingDir`:"
	{
		StringGetPos, uh_tmpPosBeg, uh_Path, <WorkingDir`:`"
		StringGetPos, uh_tmpPosEnd, uh_Path, ">,, %uh_tmpPosBeg%
		StringMid, uh_WorkingDir, uh_Path, % uh_tmpPosBeg+14, % uh_tmpPosEnd-uh_tmpPosBeg-13
		StringReplace, uh_Path, uh_Path, <WorkingDir`:"%uh_WorkingDir%">
	}

	If uh_App contains ahk_class,ahk_id,ahk_pid,ahk_group
	{
		IfInString, uh_Path, <ControlSend>
		{
			DetectHiddenWindows, On
			IfWinNotExist, %uh_App%
			{
				Send, %uh_A_Thishotkey%
				Return
			}
			DetectHiddenWindows, Off
		}
		Else IfInString, uh_Path, <ControlClick>
		{
			DetectHiddenWindows, On
			IfWinNotExist, %uh_App%
			{
				Send, %uh_A_Thishotkey%
				Return
			}
			DetectHiddenWindows, Off
		}
		Else
		{
			IfWinNotActive, %uh_App%
			{
				Send,%uh_A_Thishotkey%
				Return
			}
		}
	}
	Else If uh_App = ExplorerAndDialogs
	{
		WinGetClass, uh_activeClass, A
		If uh_activeClass not contains %ChangeDirClasses%
		{
			Send, %uh_A_Thishotkey%
			Return
		}
	}
	Else If uh_App <>
	{
		IfInString, uh_Path, <ControlSend>
			DetectHiddenWindows, On
		IfInString, uh_Path, <ControlClick>
			DetectHiddenWindows, On

		WinGetTitle, uh_Title, A
		If uh_NotApp = 0
		{
			If uh_title not Contains %uh_App%
			{
				Send, %uh_A_Thishotkey%
				Return
			}
		}
		Else
		{
			If uh_title Contains %uh_App%
			{
				Send, %uh_A_Thishotkey%
				Return
			}
		}
		IfInString, uh_Path, <ControlSend>
			DetectHiddenWindows, Off
		IfInString, uh_Path, <ControlClick>
			DetectHiddenWindows, Off
	}

	If A_IsCompiled = 1
	{
		StringReplace, uh_Path_tmp, uh_Path, .ahk, .exe
		IfExist, %uh_Path_tmp%
			uh_Path = %uh_Path_tmp%
	}

	IfInString, uh_Path, <AOT>
	{
		StringReplace, uh_Path, uh_Path, <AOT>,
		uh_AOT = 1
	}
	Else
		uh_AOT = 0

	IfInString, uh_Path, <NoBalloonTip>
	{
		StringReplace, uh_Path, uh_Path, <NoBalloonTip>,
		uh_NoBalloonTip = 1
	}
	Else
		uh_NoBalloonTip = 0

	uh_RunParameter =
	IfInString, uh_Path, <Min>
	{
		StringReplace, uh_Path, uh_Path, <Min>,
		uh_RunParameter = Min
	}
	IfInString, uh_Path, <Max>
	{
		StringReplace, uh_Path, uh_Path, <Max>,
		uh_RunParameter = Max
	}
	IfInString, uh_Path, <hidden>
	{
		StringReplace, uh_Path, uh_Path, <hidden>,
		uh_RunParameter = Hide
	}
	IfInString, uh_Path, <Hide>
	{
		StringReplace, uh_Path, uh_Path, <Hide>,
		uh_RunParameter = Hide
	}

	IfInString, uh_Path, `%Selection`%
	{
		func_GetSelection()
	}
	IfInString, uh_Path, `%SelectionURL`%
	{
		func_GetSelection()
		SelectionURL := func_UrlEncode(Selection)
	}
	IfInString, uh_Path, `%
		Gosub, sub_GetAllEnv

	IfInString, uh_Path, `%SelectionPaste`%
	{
		func_GetSelection(1,1)
		uh_RestoreSelection = 1
		Sleep, 30
		StringReplace, uh_Path, uh_Path, `%SelectionPaste`%, ^v, A
	}
	IfInString, uh_Path, `%SelectionURLPaste`%
	{
		func_GetSelection(1,1)
		Clipboard := func_UrlEncode(Clipboard)
		uh_RestoreSelection = 1
		Sleep, 30
		StringReplace, uh_Path, uh_Path, `%SelectionURLPaste`%, ^v, A
	}


	StringReplace, uh_Path, uh_Path, <OnShutDown>, , A

	RegExMatch( uh_Path, "i)<[a-z]+ Delay:([0-9-]+)>", uh_Match)
	uh_Path := RegExReplace( uh_Path, "i)<([a-z]+) Delay:[0-9-]+>", "<$1>")

	If uh_Match1 <>
	{
		SetKeyDelay, %uh_Match1%
		SendMode, Event
	}

	IfInString, uh_Path, <Send>
		Selection := func_EscapeForSend(Selection,0)

	Transform, uh_Path, Deref, %uh_Path%

	uh_PathOnly = %uh_Path%
	uh_Parameters =

	IfNotExist, extensions\userhotkeys-scripts\%uh_Path%
	IfNotExist, %uh_Path%
	{
		Loop
		{
			StringGetPos, uh_PathBeginVars, uh_Path, %A_Space%, R%A_Index%
			If ErrorLevel = 1
			{
				break
			}
			StringLeft, uh_PathOnly, uh_Path, %uh_PathBeginVars%
			If (InStr(FileExist(uh_PathOnly), "D") = 0 AND (FileExist(uh_PathOnly) OR FileExist("extensions\userhotkeys-scripts\" uh_PathOnly) OR FileExist(A_ScriptDir "\extensions\userhotkeys-scripts\" uh_PathOnly)) )
			{
				StringMid, uh_Parameters, uh_Path, % uh_PathBeginVars+1
				break
			}
			uh_PathOnly = %uh_Path%
		}
	}

	uh_AddAHKPath =
	If (!InStr(uh_PathOnly,"A_AHKPath") AND func_StrRight(uh_PathOnly,4)=".ahk")
	{
		uh_AddAHKPath := A_AHKPath " "
		If (!InStr(uh_Path, """"))
			uh_Quote = "
	} ; " This is only to satisfy UltraEdit´s syntax highlighting...

	StringGetPos, uh_PathBeginVars, uh_PathOnly, >
	StringLeft, uh_PathTag, uh_PathOnly, % uh_PathBeginVars + 1
	If StrLen(uh_PathTag) > 3
		StringReplace, uh_PathWithoutTag, uh_pathOnly, %uh_PathTag%,

	If uh_PathTag Not in %uh_SpecialCommands%
	{
		SplitPath, uh_Path, uh_OutFileName, , uh_OutExtension, uh_OutNameNoExt
		if uh_Description <>
			uh_OutNameNoExt = %uh_Description%
		If (uh_BalloonTip = -1 AND uh_NoBalloonTip = 0)
			BalloonTip( uh_ScriptName, A_Quote uh_OutNameNoExt A_Quote " " lng_uh_running, "Info" , 0, 0, uh_BalloonTimeOut)

		If uh_OutExtension = lnk
		{
			FileGetShortcut, %uh_Path%, uh_ShortcutPath
			IfNotExist, %uh_ShortcutPath%
			{
				If (uh_BalloonTip <> 0 AND uh_NoBalloonTip = 0)
					BalloonTip( uh_ScriptName, A_Quote uh_OutNameNoExt A_Quote " " lng_uh_runningError "`n`n" uh_Path, "Error" , 0, 0, uh_BalloonTimeOut)
			}
		}

		If uh_ProcID%uh_HotkeyNumber% <>
		{
			IniDelete, %ConfigFile%, %uh_ScriptName%, GroupProcessID%uh_HotkeyNumber%
			IniDelete, %ConfigFile%, %uh_ScriptName%, GroupProcesses%uh_HotkeyNumber%
			IniDelete, %ConfigFile%, %uh_ScriptName%, GroupProcessName%uh_HotkeyNumber%
			uh_ProcID%uh_HotkeyNumber% =
			uh_ProcName%uh_HotkeyNumber% =
		}
		IfExist, %A_ScriptDir%\extensions\userhotkeys-scripts\%uh_PathOnly%
			uh_PathOnly = %A_ScriptDir%\extensions\userhotkeys-scripts\%uh_PathOnly%
		Else IfExist, extensions\userhotkeys-scripts\%uh_PathOnly%
			uh_PathOnly =  extensions\userhotkeys-scripts\%uh_PathOnly%

		If uh_WorkingDir =
			SplitPath, uh_PathOnly,,uh_WorkingDir
		IfNotExist, %uh_WorkingDir%
			uh_WorkingDir =
		If uh_OnShutdown = 1
			RunWait, %uh_AddAHKPath%%uh_Quote%%uh_PathOnly%%uh_Quote%%uh_Parameters%, %uh_WorkingDir%, UseErrorlevel %uh_RunParameter%, uh_ProcID%uh_HotkeyNumber%
		Else
			Run, %uh_AddAHKPath%%uh_Quote%%uh_PathOnly%%uh_Quote%%uh_Parameters%, %uh_WorkingDir%, UseErrorlevel %uh_RunParameter%, uh_ProcID%uh_HotkeyNumber%
		If ErrorLevel = ERROR
		{
			uh_LastError = %A_LastError%
			uh_Error = 1
		}

		If uh_ProcID%uh_HotkeyNumber% <>
		{
			IfWinNotActive, % "ahk_pid " uh_ProcID%uh_HotkeyNumber%
				WinWaitActive, % "ahk_pid " uh_ProcID%uh_HotkeyNumber%,,1
			IfWinNotActive, % "ahk_pid " uh_ProcID%uh_HotkeyNumber%
				WinActivate, % "ahk_pid " uh_ProcID%uh_HotkeyNumber%
		}
	}
	If uh_PathTag = <PostMessage>
	{
		Loop, 8
			uh_PathWithoutTag%A_Index% =
		StringSplit, uh_PathWithoutTag, uh_PathWithoutTag, `,
		PostMessage, %uh_PathWithoutTag1%, %uh_PathWithoutTag2%, %uh_PathWithoutTag3%, %uh_PathWithoutTag4%, %uh_PathWithoutTag5%, %uh_PathWithoutTag6%, %uh_PathWithoutTag7%, %uh_PathWithoutTag8%
	}
	If uh_PathTag = <send>
	{
		uh_Error = 0
		If uh_LaunchingAll <>
		{
			uh_LaunchingAll++
			uh_SendCache = %uh_SendCache%%uh_PathWithoutTag%
		}
		Else
			Send, %uh_PathWithoutTag%
	}
	If uh_PathTag = <sendplay>
	{
		uh_Error = 0
		If uh_LaunchingAll <>
		{
			uh_LaunchingAll++
			uh_SendCache = %uh_SendCache%%uh_PathWithoutTag%
		}
		Else
			SendPlay, %uh_PathWithoutTag%
	}
	If uh_PathTag = <sendraw>
	{
		uh_Error = 0
		If uh_LaunchingAll <>
		{
			uh_LaunchingAll++
			Loop, Parse, uh_PathWithoutTag
				uh_SendCache = %uh_SendCache%{%A_LoopField%}
		}
		Else
			SendRaw, %uh_PathWithoutTag%
	}
	If uh_PathTag = <reload>
	{
		uh_Error = 0
		Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
		Gosub, Reload
	}
	If uh_PathTag = <listhotkeys>
	{
		uh_Error = 0
		ListHotkeys
	}
	If uh_PathTag = <listlines>
	{
		uh_Error = 0
		ListLines
	}
	If uh_PathTag = <listvars>
	{
		uh_Error = 0
		ListVars
	}
	If uh_PathTag = <exitapp>
	{
		uh_Error = 0
		ExitApp
	}
	If uh_PathTag = <keyhistory>
	{
		uh_Error = 0
		KeyHistory
	}
	If uh_PathTag = <PerformAction>
	{
		uh_Error = 0
		StringSplit, uh_Parameters, uh_PathWithoutTag, `,

		performAction(uh_Parameters1,uh_parameters2)
	}
	If uh_PathTag = <MouseMoveTo>
	{
		CoordMode, Mouse, Screen
		StringSplit, uh_Parameters, uh_PathWithoutTag, `,
		MouseMove(uh_Parameters1,uh_Parameters2)
	}
	If uh_PathTag = <MouseMoveBy>
	{
		CoordMode, Mouse, Screen
		StringSplit, uh_Parameters, uh_PathWithoutTag, `,
		MouseMove(uh_Parameters1,uh_Parameters2,0,"R")
	}
	If uh_PathTag = <activAid>
	{
		If (IsLabel(uh_PathWithoutTag))
			Gosub, %uh_PathWithoutTag%
		Return
	}
	If uh_PathTag = <Config>
	{
		If MainGuiVisible <>
			Gosub, activAidGuiClose
		If (uh_PathWithoutTag <> "activAid" AND Enable_%uh_PathWithoutTag% <> "")
			SimpleMainGUI = %uh_PathWithoutTag%
		Gosub, sub_MainGUI
		Return
	}

	If uh_PathTag = <getControl>
	{
		uh_Error = 0
		MouseGetPos, , , uh_WinID, uh_ControlClass
		Clipboard = %uh_ControlClass%
		ToolTip, %uh_ControlClass%
		Sleep, 800
		ToolTip
	}
	If uh_PathTag = <PasteFile>
	{
		NoOnClipboardChange = 1
		uh_Temp = %ClipBoardAll%
		ClipBoard =
		FileRead, Clipboard, %uh_PathWithoutTag%
		ClipWait,1
		If ( StrLen(Clipboard)=0 OR (StrLen(ClipBoard)=1 AND Asc(Clipboard)=13) )
		{
			FileRead, Clipboard, *c %uh_PathWithoutTag%
			ClipWait,1
		}
		SendEvent, ^v
		Sleep,100
		ClipBoard = %uh_Temp%
		NoOnClipboardChange = 0
		Return
	}
	If (uh_PathTag = "<getColour>" OR uh_PathTag = "<getColor>")
	{
		uh_Error = 0
		CoordMode, Mouse, Screen
		CoordMode, Pixel, Screen
		MouseGetPos, uh_MouseX , uh_MouseY
		PixelGetColor, uh_Colour, %uh_MouseX%, %uh_MouseY%, RGB
		StringTrimLeft, uh_Colour, uh_Colour, 2
		IfInString, uh_PathWithoutTag, <RGB>
		{
			uh_Color = %uh_Colour%
			StringReplace, uh_Colour, uh_PathWithoutTag, <RGB>, %uh_Color%, A
		}
		Else
			uh_Colour := uh_PathWithoutTag uh_Colour
		ToolTip, %uh_Colour%
		Clipboard = %uh_Colour%
		Sleep, 800
		ToolTip
	}
	If uh_PathTag = <getControlText>
	{
		uh_Error = 0
		CoordMode, Mouse, Screen
		MouseGetPos, uh_MouseX , uh_MouseY, uh_gWin, uh_gControl
		ControlGetText, uh_getText, %uh_gControl%, ahk_id %uh_gWin%

		If uh_gControl =
			WinGetTitle, uh_getText, ahk_id %uh_gWin%
		Else If uh_getText =
		{
			If uh_gControl contains SysListView,ListBox,ComboBox
			{
				ControlGet, uh_getText, List, Selected, %uh_gControl%, ahk_id %uh_gWin%
				If (uh_getText = uh_lastGetText)
					ControlGet, uh_getText, List, , %uh_gControl%, ahk_id %uh_gWin%
			}
			Else
			{
				ControlGet,uh_parentHwnd,Hwnd,,%uh_gControl%, ahk_id %uh_gWin%
				Loop, 10
				{
				  uh_parentHwnd:=DllCall("GetParent","UInt",uh_parentHwnd)
				  If uh_parentHwnd=0
					 Break
				  ControlGetText, uh_getText, , ahk_id %uh_parentHwnd%
				  If uh_getText <>
					 Break
				}
			}
		}
		uh_lastGetText := uh_getText
		uh_getText = %uh_PathWithoutTag%%uh_getText%
		Clipboard = %uh_getText%
		ToolTip, %uh_getText%
		Sleep, 800
		ToolTip
	}
	If uh_PathTag = <ShowExtensionMenu>
	{
		WinGet, WinIDbeforeContextMenu, ID, A
		Menu, SubContextMenu, UseErrorLevel
		Menu, SubContextMenu%uh_PathWithoutTag%#, Show
		If (ErrorLevel = 1 AND Enable_%uh_PathWithoutTag% = 1)
		{
			DontShowMainGUI = 1
			SimpleMainGUI = %uh_PathWithoutTag%
			Gosub, sub_MainGUI
			Menu, SubContextMenu%uh_PathWithoutTag%#, Show
			SimpleMainGUI =
		}
		Return
	}
	If (uh_PathTag = "<SingleInstance>" OR uh_PathTag = "<Single>")
	{
;      Critical, On
;      BlockInput, On
		uh_Error = 0
		StringReplace, uh_PathOnly,uh_PathOnly,<SingleInstance>,
		StringReplace, uh_PathOnly,uh_PathOnly,<Single>,
		IfExist, extensions\userhotkeys-scripts\%uh_PathOnly%
			uh_PathOnly = extensions\userhotkeys-scripts\%uh_PathWithoutTag%
		Else IfExist, extensions\userhotkeys-scripts\%uh_PathOnly%
			uh_PathOnly =  extensions\userhotkeys-scripts\%uh_PathWithoutTag%
		Else
			uh_PathOnly = %uh_PathWithoutTag%

		WinGet, uh_tmpProc, ProcessName, % "ahk_group " uh_ProcID%uh_HotkeyNumber%
		If (uh_tmpProc <> "" AND uh_tmpProc = uh_ProcName%uh_HotkeyNumber%)
		{
			WinGetTitle, test, % "ahk_group " uh_ProcID%uh_HotkeyNumber%
			IfWinNotActive, % "ahk_group " uh_ProcID%uh_HotkeyNumber%
			{
				If uh_RunParameter = Max
					WinMaximize, % "ahk_group " uh_ProcID%uh_HotkeyNumber%
				Else
					WinRestore, % "ahk_group " uh_ProcID%uh_HotkeyNumber%

				WinWaitActive, % "ahk_pid" uh_ProcID%uh_HotkeyNumber%,,1
				IfWinNotActive, % "ahk_group " uh_ProcID%uh_HotkeyNumber%
				{
					WinActivate, % "ahk_group " uh_ProcID%uh_HotkeyNumber%
					WinSet, Top, , % "ahk_group " uh_ProcID%uh_HotkeyNumber%
				}
			}
			Else
			{
				If uh_PathTag = <SingleInstance>
					PostMessage,0x0112,0x0000f020,0x00f40390,,% "ahk_group " uh_ProcID%uh_HotkeyNumber%
					;WinMinimize, % "ahk_group " uh_ProcID%uh_HotkeyNumber%
			}
		}
		Else
		{
			IniDelete, %ConfigFile%, %uh_ScriptName%, GroupProcessID%uh_HotkeyNumber%
			IniDelete, %ConfigFile%, %uh_ScriptName%, GroupProcesses%uh_HotkeyNumber%
			IniDelete, %ConfigFile%, %uh_ScriptName%, GroupProcessName%uh_HotkeyNumber%
			uh_PID =
			SplitPath, uh_PathOnly, uh_OutFileName, , uh_OutExtension, uh_OutNameNoExt
			if uh_Description <>
				uh_OutNameNoExt = %uh_Description%
			If (uh_BalloonTip = -1 AND uh_NoBalloonTip = 0)
				BalloonTip( uh_ScriptName, A_Quote uh_OutNameNoExt A_Quote " " lng_uh_running , "Info", 0, 0, uh_BalloonTimeOut)

			If uh_OutExtension = lnk
			{
				FileGetShortcut, %uh_Path%, uh_ShortcutPath
				IfNotExist, %uh_ShortcutPath%
				{
					If (uh_BalloonTip <> 0 AND uh_NoBalloonTip = 0)
						BalloonTip( uh_ScriptName, A_Quote uh_OutNameNoExt A_Quote " " lng_uh_runningError "`n`n" uh_Path, "Error" , 0, 0, uh_BalloonTimeOut)
;               Critical, Off
;               BlockInput, Off
					Goto, uh_Return
				}
			}

			Gosub, uh_sub_InitialWinList

			If uh_WorkingDir =
				SplitPath, uh_PathOnly,,uh_WorkingDir
			IfNotExist, %uh_WorkingDir%
				uh_WorkingDir =

			If uh_OnShutdown = 1
				RunWait, %uh_AddAHKPath%%uh_Quote%%uh_PathOnly%%uh_Quote%%uh_Parameters%, %uh_WorkingDir%, UseErrorLevel %uh_RunParameter%, uh_PID
			Else
				Run, %uh_AddAHKPath%%uh_Quote%%uh_PathOnly%%uh_Quote%%uh_Parameters%, %uh_WorkingDir%, UseErrorLevel %uh_RunParameter%, uh_PID

			If ErrorLevel = ERROR
			{
				If (uh_BalloonTip <> 0 AND uh_NoBalloonTip = 0)
					func_GetErrorMessage( A_LastError, uh_ScriptName, A_Quote uh_OutNameNoExt A_Quote " " lng_uh_runningError "`n`n" )
;            Critical, Off
;            BlockInput, Off
				Goto, uh_Return
			}

;         Sleep, 200
;         WinGet, uh_InitialID, ID, A

			Loop, 20
			{
				Gosub, uh_sub_GetNewWindows
				If uh_FreshWindows <>
				{
					Break
				}
				Sleep,200
			}

;         If uh_FreshWindows =
;         {
;            uh_FreshWindows = %uh_InitialID%
;         }

			Loop, Parse, uh_FreshWindows, |
			{
				If A_LoopField =
					continue
				WinGet, uh_PID, PID, ahk_id %A_LoopField%
				WinGet, uh_ProcName, ProcessName, ahk_id %A_LoopField%
				WinGetTitle, uh_Title, ahk_id %A_LoopField%
				IfWinNotActive, ahk_id %A_LoopField%
				{
					WinActivate, ahk_id %A_LoopField%
					WinSet, Top, , ahk_id %A_LoopField%
				}
				;tooltip, %uh_ProcName%`n%uh_Title%

				If uh_PID <>
				{
					uh_ProcName := func_StrLeft( func_Hex(uh_ProcName), 200)
					uh_ProcID%uh_HotkeyNumber% = g%uh_PID%%uh_ProcName%
					IniWrite, % uh_ProcID%uh_HotkeyNumber%, %ConfigFile%, %uh_ScriptName%, GroupProcessID%uh_HotkeyNumber%
					WinGet, uh_ProcName%uh_HotkeyNumber%, ProcessName, ahk_pid %uh_PID%
					IniWrite, % uh_ProcName%uh_HotkeyNumber%, %ConfigFile%, %uh_ScriptName%, GroupProcessName%uh_HotkeyNumber%
					WinGet, uh_WinList, List, ahk_pid %uh_PID%
					uh_GroupProcs =
					loop, %uh_WinList%
					{
						uh_wid := uh_WinList%A_Index%
						GroupAdd, g%uh_PID%%uh_ProcName%, ahk_id %uh_wid%
						uh_GroupProcs = %uh_GroupProcs%%uh_wid%|
					}
	;            tooltip, %uh_Title%--%uh_ProcName%`n%uh_PID%`n%uh_Title%`n%uh_GroupProcs%
					IniWrite, %uh_GroupProcs%, %ConfigFile%, %uh_ScriptName%, GroupProcesses%uh_HotkeyNumber%
				}
			 }
		}
;      Critical, Off
;      BlockInput, Off
	}
	If (uh_PathTag = "<SingleInstanceClose>" OR uh_PathTag = "<SingleInstanceKill>")
	{
;      BlockInput, On
;      Critical, On
		uh_Error = 0
		StringReplace, uh_PathOnly,uh_PathOnly,<SingleInstanceClose>,
		StringReplace, uh_PathOnly,uh_PathOnly,<SingleInstanceKill>,
		IfExist, extensions\userhotkeys-scripts\%uh_PathOnly%
			uh_PathOnly = extensions\userhotkeys-scripts\%uh_PathWithoutTag%
		Else IfExist, extensions\userhotkeys-scripts\%uh_PathOnly%
			uh_PathOnly =  extensions\userhotkeys-scripts\%uh_PathWithoutTag%
		Else
			uh_PathOnly = %uh_PathWithoutTag%

		WinGet, uh_tmpProc, ProcessName, % "ahk_group " uh_ProcID%uh_HotkeyNumber%
;      tooltip, % uh_tmpProc " - " uh_ProcName%uh_HotkeyNumber% " - " uh_HotkeyNumber " - " uh_ProcID%uh_HotkeyNumber% " - " A_Thishotkey
		If (uh_tmpProc <> "" AND uh_tmpProc = uh_ProcName%uh_HotkeyNumber%)
		{
			IfWinNotActive, % "ahk_group " uh_ProcID%uh_HotkeyNumber%
			{
				If uh_RunParameter = Max
					WinMaximize, % "ahk_group " uh_ProcID%uh_HotkeyNumber%
				Else
					WinRestore, % "ahk_group " uh_ProcID%uh_HotkeyNumber%

				IfWinNotActive, % "ahk_group " uh_ProcID%uh_HotkeyNumber%
				{
					WinActivate, % "ahk_group " uh_ProcID%uh_HotkeyNumber%
					WinSet, Top, , % "ahk_group " uh_ProcID%uh_HotkeyNumber%
				}
			}
			Else
			{
				If uh_PathTag = <SingleInstanceKill>
				{
					WinGet, uh_ProcessName, ProcessName, % "ahk_group " uh_ProcID%uh_HotkeyNumber%
					WinKill, % "ahk_group " uh_ProcID%uh_HotkeyNumber%
					WinWaitClose, % "ahk_group " uh_ProcID%uh_HotkeyNumber%, , .5
					If ErrorLevel = 1
						Process, Close, %uh_ProcessName%
				}
				Else
				{
					PostMessage, 0x112, 0xF060,,, % "ahk_group " uh_ProcID%uh_HotkeyNumber%
					;GroupClose, % uh_ProcID%uh_HotkeyNumber%, A
				}

				IniDelete, %ConfigFile%, %uh_ScriptName%, GroupProcessID%uh_HotkeyNumber%
				IniDelete, %ConfigFile%, %uh_ScriptName%, GroupProcesses%uh_HotkeyNumber%
				IniDelete, %ConfigFile%, %uh_ScriptName%, GroupProcessName%uh_HotkeyNumber%
				uh_ProcID%uh_HotkeyNumber% =
				uh_ProcName%uh_HotkeyNumber% =
			}
		}
		Else
		{
			IniDelete, %ConfigFile%, %uh_ScriptName%, GroupProcessID%uh_HotkeyNumber%
			IniDelete, %ConfigFile%, %uh_ScriptName%, GroupProcesses%uh_HotkeyNumber%
			IniDelete, %ConfigFile%, %uh_ScriptName%, GroupProcessName%uh_HotkeyNumber%
			uh_PID =
			uh_ProcID%uh_HotkeyNumber% =
			uh_ProcName%uh_HotkeyNumber% =
			SplitPath, uh_PathOnly, uh_OutFileName, , uh_OutExtension, uh_OutNameNoExt
			if uh_Description <>
				uh_OutNameNoExt = %uh_Description%
			If (uh_BalloonTip = -1 AND uh_NoBalloonTip = 0)
				BalloonTip( uh_ScriptName, A_Quote uh_OutNameNoExt A_Quote " " lng_uh_running, "Info" , 0, 0, uh_BalloonTimeOut)

			If uh_OutExtension = lnk
			{
				FileGetShortcut, %uh_Path%, uh_ShortcutPath
				IfNotExist, %uh_ShortcutPath%
				{
					If (uh_BalloonTip <> 0 AND uh_NoBalloonTip = 0)
						BalloonTip( uh_ScriptName, A_Quote uh_OutNameNoExt A_Quote " " lng_uh_runningError "`n`n" uh_Path, "Error" , 0, 0, uh_BalloonTimeOut)
;               Critical, Off
;               BlockInput, Off
					Goto, uh_Return
				}
			}

			Gosub, uh_sub_InitialWinList

			If uh_WorkingDir =
				SplitPath, uh_PathOnly,,uh_WorkingDir
			IfNotExist, %uh_WorkingDir%
				uh_WorkingDir =

			If uh_OnShutdown = 1
				RunWait, %uh_AddAHKPath%%uh_Quote%%uh_PathOnly%%uh_Quote%%uh_Parameters%, %uh_WorkingDir%, UseErrorLevel %uh_RunParameter%, uh_PID
			Else
				Run, %uh_AddAHKPath%%uh_Quote%%uh_PathOnly%%uh_Quote%%uh_Parameters%, %uh_WorkingDir%, UseErrorLevel %uh_RunParameter%, uh_PID

			If ErrorLevel = ERROR
			{
				If (uh_BalloonTip <> 0 AND uh_NoBalloonTip = 0)
					func_GetErrorMessage( A_LastError, uh_ScriptName, A_Quote uh_OutNameNoExt A_Quote " " lng_uh_runningError "`n`n" )
;            Critical, Off
;            BlockInput, Off
				Goto, uh_Return
			}

;         Sleep, 200
;         WinGet, uh_InitialID, ID, A

			Loop, 20
			{
				Gosub, uh_sub_GetNewWindows
				If uh_FreshWindows <>
				{
					Break
				}
				Sleep,200
			}

;         If uh_FreshWindows =
;         {
;            uh_FreshWindows = %uh_InitialID%
;         }

			Loop, Parse, uh_FreshWindows, |
			{
				If A_LoopField =
					continue
				WinGet, uh_PID, PID, ahk_id %A_LoopField%
				WinGet, uh_ProcName, ProcessName, ahk_id %A_LoopField%
				WinGetTitle, uh_Title, ahk_id %A_LoopField%
				IfWinNotActive, ahk_id %A_LoopField%
				{
					WinActivate, ahk_id %A_LoopField%
					WinSet, Top, , ahk_id %A_LoopField%
				}
				;tooltip, %uh_ProcName%`n%uh_Title%

				If uh_PID <>
				{
					uh_ProcName := func_StrLeft( func_Hex(uh_ProcName), 200)
					uh_ProcID%uh_HotkeyNumber% = g%uh_PID%%uh_ProcName%
					IniWrite, % uh_ProcID%uh_HotkeyNumber%, %ConfigFile%, %uh_ScriptName%, GroupProcessID%uh_HotkeyNumber%
					WinGet, uh_ProcName%uh_HotkeyNumber%, ProcessName, ahk_pid %uh_PID%
					IniWrite, % uh_ProcName%uh_HotkeyNumber%, %ConfigFile%, %uh_ScriptName%, GroupProcessName%uh_HotkeyNumber%
					WinGet, uh_WinList, List, ahk_pid %uh_PID%
					uh_GroupProcs =
					loop, %uh_WinList%
					{
						uh_wid := uh_WinList%A_Index%
						GroupAdd, g%uh_PID%%uh_ProcName%, ahk_id %uh_wid%
						uh_GroupProcs = %uh_GroupProcs%%uh_wid%|
					}
	;            tooltip, %uh_Title%--%uh_ProcName%`n%uh_PID%`n%uh_Title%`n%uh_GroupProcs%
					IniWrite, %uh_GroupProcs%, %ConfigFile%, %uh_ScriptName%, GroupProcesses%uh_HotkeyNumber%
				}
			 }
		}
;      Critical, Off
;      BlockInput, Off
	}
	If uh_PathTag = <chdir>
	{
		uh_Error = 0
		func_ChangeDir(uh_PathWithoutTag,-1,0)
	}
	If uh_PathTag = <ControlSend>
	{
		DetectHiddenWindows, On
		IfWinExist, %uh_App%
		{
			uh_temp1 =
			uh_temp2 =
			uh_temp3 =
			StringSplit, uh_temp, uh_PathWithoutTag, `,
			if uh_temp2 =
			{
				ControlSend, ahk_parent,%uh_temp1%,%uh_App%
			}
			Else
				ControlSend, %uh_temp1%,%uh_temp2%,%uh_App%
		}
		Else
		{
			Send,%uh_A_Thishotkey%
			Goto, uh_Return
		}

		DetectHiddenWindows, Off
		uh_Error =
	}
	If uh_PathTag = <ControlClick>
	{
		DetectHiddenWindows, On
		IfWinExist, %uh_App%
		{
			uh_temp1 =
			uh_temp2 =
			uh_temp3 =
			uh_temp4 =
			StringSplit, uh_temp, uh_PathWithoutTag, `,
			ControlClick, %uh_PathWithoutTag%,%uh_App%,,%uh_temp2%,%uh_temp3%,%uh_temp4%
		}
		Else
		{
			Send,%uh_A_Thishotkey%
			Goto, uh_Return
		}

		DetectHiddenWindows, Off
		uh_Error =
	}
	If uh_AOT = 1
	{
	  WinGet, uh_ExStyle, ExStyle, % "ahk_group " uh_ProcID%uh_HotkeyNumber%

	  if not (uh_ExStyle & 0x8)
	  {
		 WinGetTitle, uh_WinTitle, % "ahk_group " uh_ProcID%uh_HotkeyNumber%

		 WinSet, AlwaysOnTop, On, % "ahk_group " uh_ProcID%uh_HotkeyNumber%
		 If uh_AOTModifyTitle = 1
		 {
			 IfNotInString, uh_WinTitle, /¯\
				uh_WinTitle = /¯\  %uh_WinTitle%
			 WinSet, ExStyle, +0x20000, % "ahk_group " uh_ProcID%uh_HotkeyNumber%
			 WinSetTitle, % "ahk_group " uh_ProcID%uh_HotkeyNumber%,, %uh_WinTitle%
		 }
	  }
	}

	If uh_PathTag = <CategoryMenu>
	{
		Critical, Off
		uh_Error = 0
		If (uh_Category <> uh_CategoryOrg)
		{
			WinGetTitle, uh_Title, A
			If uh_title not Contains %uh_Category%
				Goto, uh_Return
		}

		uh_CreatedCategories =
		uh_CatIndex =
		If uh_Category =
		{
			uh_CategoryOverview = 1
			uh_CatIndex := func_Hex("!")
			Menu, % func_Hex("!"), Add, [ UserHotkeys ], uh_sub_CategoryMenu
			Menu, % func_Hex("!"), Add
		}
		Else
		{
			uh_CategoryOverview = 0
			Menu, % func_Hex(uh_Category "!"), Add, % "[ " uh_CategoryOrg " ]", uh_sub_CategoryMenu
			Menu, % func_Hex(uh_Category "!"), Add
		}
		uh_Index%uh_CatIndex% = 1
		Loop, %uh_NumHotkeys%
		{
			If uh_CategoryOverview = 1
				uh_Category := uh_Category%A_Index%
			uh_CatIndex := func_Hex(uh_Category "!")
			If ( !InStr( uh_CreatedCategories, "|" uh_Category "!|") AND uh_Category <> "")
			{
				uh_Index%uh_CatIndex% = 1
			}
			If ((uh_Category%A_Index% = uh_Category OR uh_App%A_Index% = uh_Category) AND uh_Path <> uh_Path%A_Index%)
			{
				If (uh_Path%A_Index% = "" AND Hotkey_uh_Hotkey%A_Index%_new = "")
				{
					Menu, % func_Hex(uh_Category "!"), Add
				}
				Else
				{
					StringMid, uh_AlphaNum, uh_AlphaNums, uh_Index%uh_CatIndex%, 1
					uh_Index%uh_CatIndex%++
					If Hotkey_uh_Hotkey%A_Index%_new =
						uh_AddMenuHotkey =
					Else
						uh_AddMenuHotkey := "`t (" func_HotkeyDecompose(Hotkey_uh_Hotkey%A_Index%_new,1) ")"

					If uh_Description%A_Index% =
						Menu, % func_Hex(uh_Category "!"), Add, % "&" uh_AlphaNum " - " uh_func_ShortenPath(uh_Path%A_Index%) uh_AddMenuHotkey, uh_sub_CategoryMenu
					Else
						Menu, % func_Hex(uh_Category "!"), Add, % "&" uh_AlphaNum " - " uh_Description%A_Index%  uh_AddMenuHotkey, uh_sub_CategoryMenu
				}
			}
			If ( !InStr( uh_CreatedCategories, "|" uh_Category "!|") AND uh_Path <> "" AND uh_Path <> uh_Path%A_Index% AND uh_Category <> "")
			{
				uh_CatIndex := func_Hex("!")
				StringMid, uh_AlphaNum, uh_AlphaNums, uh_Index%uh_CatIndex%, 1
				uh_Index%uh_CatIndex%++
				Menu, % func_Hex( "!"), Add, % "&" uh_AlphaNum " - " uh_Category, % ":" func_Hex(uh_Category "!")
				uh_CreatedCategories = %uh_CreatedCategories%|%uh_Category%!|
			}
		}
		Menu, % func_Hex(uh_Category "!"), Show
		Loop, Parse, uh_CreatedCategories, |
		{
			StringTrimRight, uh_Category, A_LoopField, 1
			Menu, % func_Hex(uh_Category "!"), DeleteAll
		}
		Menu, % func_Hex("!"), DeleteAll
	}

	If uh_PathTag = <CategoryLaunchAll>
	{
		uh_Error = 0
		If (uh_Category <> uh_CategoryOrg)
		{
			WinGetTitle, uh_Title, A
			If uh_title not Contains %uh_Category%
				Goto, uh_Return
		}

		SetTimer, uh_sub_CategoryLaunchAll, 10
	}

	If uh_PathTag = <WheelUp>
	{
		RegRead, uh_MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
		MouseClick, WheelUp
	}

	If uh_PathTag = <WheelDown>
	{
		RegRead, uh_MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
		MouseClick, WheelDown
	}

	If uh_Error = 1
		If (uh_BalloonTip <> 0 AND uh_NoBalloonTip = 0)
		{
			If uh_LastError =
				BalloonTip( uh_ScriptName, A_Quote uh_OutNameNoExt A_Quote " " lng_uh_runningError "`n`n" uh_Path, "Error" , 0, 0, uh_BalloonTimeOut)
			Else
				func_GetErrorMessage( uh_LastError, uh_ScriptName, A_Quote uh_OutNameNoExt A_Quote " " lng_uh_runningError "`n`n" )
		}

	Goto, uh_Return
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

uh_Return:
	if uh_RestoreSelection <>
	{
		Sleep, 50
		Clipboard = %SavedClipboard%
		uh_RestoreSelection =
	}
Return

uh_sub_CategoryLaunchAll:
	SetTimer, uh_sub_CategoryLaunchAll, Off
	If uh_AllLaunched = 1
		uh_AllLaunched = 2
	Else
		uh_AllLaunched = 1

	uh_SendCache =
	uh_LaunchingAll = 1
	Loop, %uh_NumHotkeys%
	{
		If uh_AllLaunched = 1
			uh_Index = %A_Index%
		Else
			uh_Index := uh_NumHotkeys - A_Index +1

		If ((uh_Category%uh_Index% = uh_Category OR uh_App%uh_Index% = uh_Category) AND uh_Path <> uh_Path%uh_Index% AND !InStr(uh_Path%uh_Index%, "<CategoryMenu>") AND !InStr(uh_Path%uh_Index%, "<CategoryLaunchAll>"))
		{
			uh_ThisPath := uh_Path%uh_Index%
			uh_ThisApp := uh_App%uh_Index%
			uh_ThisDescription := uh_Description%uh_Index%
			uh_ThisHotkey := Hotkey_uh_Hotkey%uh_Index%
			Gosub, sub_Hotkey_UserHotkey
			;Msgbox, % uh_Path%uh_Index% "`n" uh_SendCache{}|][\
		}
	}
	If uh_LaunchingAll > 1
		Send, %uh_SendCache%
	uh_SendCache =
	uh_LaunchingAll =
Return

uh_sub_CategoryMenu:
	Menu, %A_ThisMenu%, DeleteAll
	Loop, %uh_NumHotkeys%
	{
		StringTrimLeft, uh_ThisMenuItem, A_ThisMenuItem, 5
		If Hotkey_uh_Hotkey%A_Index%_new =
			uh_ThisMenuHotkey =
		Else
			uh_ThisMenuHotkey := "`t (" func_HotkeyDecompose(Hotkey_uh_Hotkey%A_Index%_new,1) ")"

		If ((uh_func_LocalizedCommand(uh_Path%A_Index%) uh_ThisMenuHotkey = uh_ThisMenuItem OR uh_Description%A_Index% uh_ThisMenuHotkey = uh_ThisMenuItem) AND func_Hex(uh_Category%A_Index% "!") = A_ThisMenu )
		{
			uh_ThisHotkey := Hotkey_uh_Hotkey%A_Index%
			uh_ThisPath := uh_Path%A_Index%
			gosub, sub_Hotkey_UserHotkey
			break
		}
	}
Return

uh_func_LocalizedCommand( String ) {
	global
	Loop, Parse, uh_SpecialCommands, `,
	{
		uh_tmpCommand := func_StrTranslate( A_LoopField , "<>:.? " A_Quote , "")
		If lng_uh_Cmd_%uh_tmpCommand% <>
			StringReplace, String, String, %A_LoopField%, % "<" lng_uh_Cmd_%uh_tmpCommand% "> "
		IfNotInstring, String, <
			Break
	}
	Return, %String%
}

uh_sub_ClipSave:
	IfNotExist, settings/Clipboards
		FileCreateDir, settings/Clipboards
	Loop
	{
		uh_ClipFileName = settings/Clipboards/UH_ClipSave%A_Index%.dat
		IfNotExist, %uh_ClipFileName%
			break
	}
	FileAppend, %ClipBoardAll%, %uh_ClipFileName%
	GuiControl,,uh_Path, <PasteFile>%uh_ClipFileName%
Return

uh_sub_CleanUpClipSaves:
	Loop, settings/Clipboards/UH_*.*
	{
		uh_FileName = %A_LoopFileName%
		uh_DeleteFile = 1
		Loop, %uh_NumHotkeys%
		{
			IfInString, uh_Path%A_Index%, <PasteFile>settings/Clipboards/%uh_FileName%
				uh_DeleteFile = 0
		}
		If uh_DeleteFile = 1
			FileDelete, settings/Clipboards/%A_LoopFileName%
	}
Return

uh_sub_addApp:
	StringReplace, uh_VarApp, A_GuiControl, Add_,
	WinSet,Bottom,, %ScriptTitle%
	SplashImage,,b1 cwFFFF80 FS9 WS700, %lng_AddApps%
	Gui,+Disabled
	Input,uh_GetKey,,{Enter}{ESC}
	StringReplace,uh_GetKey,ErrorLevel,Endkey:
	SplashImage, Off
	Gui,-Disabled
	WinGetClass, uh_GetName, A
	If uh_Getkey = Enter
	{
		IfNotInstring, %uh_VarApp%, %uh_GetName%
		{
			GuiControl,,%uh_VarApp%, ahk_class %uh_GetName%
			GuiControl,ChooseString, %uh_VarApp%, ahk_class %uh_GetName%
			%uh_VarApp% := %uh_VarApp% "|" uh_GetName
			StringReplace,%uh_VarApp%,%uh_VarApp%,||,|,a
		}
	}
	Gui,Show
	WinSet, Top, , %ScriptTitle%
Return

uh_func_ShortenPath( Path ) {
	StringGetPos, uh_tmpPosBeg, Path, <WorkingDir`:`"
	StringGetPos, uh_tmpPosEnd, Path, ">,, %uh_tmpPosBeg%
	StringMid, uh_Temp, Path, % uh_tmpPosBeg+14, % uh_tmpPosEnd-uh_tmpPosBeg-13
	StringReplace, Path, Path, <WorkingDir`:"%uh_Temp%">

	StringGetPos, uh_Temp, Path, >, R
	StringLeft, uh_Temp1, Path, % uh_Temp+1
	StringMid, uh_Temp2, Path, % uh_Temp+2
	SplitPath, uh_Temp2, uh_Temp3
	If (uh_Temp3 <> uh_Temp2 AND !InStr(uh_Temp1,"<Send") AND uh_Temp3 <> "" )
		Return % uh_func_LocalizedCommand(uh_Temp1) "...\" uh_Temp3
	Else
		Return % uh_func_LocalizedCommand(uh_Temp1) uh_Temp2
}

uh_sub_InitialWinList:
	DetectHiddenWindows, On
	WinGet, uh_InitialWinList , List
	uh_InitalWindows = |
	Loop, %uh_InitialWinList%
		uh_InitalWindows := uh_InitalWindows uh_InitialWinList%A_Index% "|"
Return

uh_sub_GetNewWindows:
	DetectHiddenWindows, Off
	WinGet, uh_NewWinList , List
	uh_NewWindows = |
	Loop, %uh_NewWinList%
		uh_NewWindows := uh_NewWindows uh_NewWinList%A_Index% "|"

	uh_FreshWindows =
	Loop, %uh_NewWinList%
	{
		IfNotInString, uh_InitalWindows, % "|" uh_NewWinList%A_Index% "|"
		{
			WinGetTitle, uh_GetTitle, % "ahk_id " uh_NewWinList%A_Index%
			WinGetClass, uh_GetClass, % "ahk_id " uh_NewWinList%A_Index%
			If (uh_GetTitle <> "" AND uh_GetTitle <> "")
				uh_FreshWindows := uh_FreshWindows uh_NewWinList%A_Index% "|"
		}
	}
Return
