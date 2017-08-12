; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               ExplorerHotkeys
; -----------------------------------------------------------------------------
; Prefix:             eh_
; Version:            0.6
; Date:               2008-05-05
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_ExplorerHotkeys:
	Prefix = eh
	%Prefix%_ScriptName    = ExplorerHotkeys
	%Prefix%_ScriptVersion = 0.6
	%Prefix%_Author        = Wolfgang Reszel
	RequireExtensions      =

	CustomHotkey_ExplorerHotkeys =            ; automatisches benutzerdefinierbares Tastaturkürzel? (1 = ja)
	Hotkey_ExplorerHotkeys       =            ; Standard-Hotkey
	HotkeyPrefix_ExplorerHotkeys =            ; Präfix, welches vor immer vor dem Tastaturkürzel gesetzt wird
	HideSettings = 0                             ; Wenn 1, dann bekommt die Erweiterung keinen Eintrag im Konfigurationsdialog
	EnableTray_ExplorerHotkeys   =            ; Soll eine Erweiterung nicht im Tray-Menü aufgeführt werden, muss der Wert 0 betragen
	IconFile_On_ExplorerHotkeys  = %A_WinDir%\system32\shell32.dll
	IconPos_On_ExplorerHotkeys   = 20

	DisableIfCompiled_ExplorerHotkeys =       ; Wenn 1, lässt sich die Erweiterung in kompilierter Form nicht de-/aktivieren

	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName              = %eh_ScriptName% - Tastaturkürzel für den Explorer
		Description           = Erweitert den Explorer um weitere Tastaturkürzel.
		lng_eh_ViewLargeIcons = Symbol-Ansicht
		lng_eh_ViewList       = Listen-Ansicht
		lng_eh_ViewDetails    = Detail-Ansicht
		lng_eh_ViewThumbnails = Miniatur-Ansicht
		lng_eh_ViewTile       = gekachelte Ansicht
		lng_eh_ViewFilmstrip  = Filmstreifen-Ansicht
		lng_eh_ToggleHiddenFiles = Versteckte Dateien ein-/ausblenden
		lng_eh_ToggleExtensions = Erweiterungen ein-/ausblenden
		lng_eh_MouseWheel     = Shift+Mausrad für Vorwärts/Rückwärts verwenden
		lng_eh_FolderView     = Ordnerleiste ein-/ausblenden
		lng_eh_FolderUp       = Verzeichnisebene hoch
		lng_eh_FolderDown     = Ordner wechseln/Datei öffnen
		lng_eh_DuplicateWin   = Explorer-Fenster duplizieren
		lng_eh_DuplicateFile  = Dateien duplizieren
		lng_eh_Format         = Format
		lng_eh_FindAsYouType  = Dateiliste durchsuchen
		lng_eh_Find           = Suchen:
		lng_eh_CompatibleFolderUp = Kompatibilitätsmodus für 'Verzeichnisebene hoch'
		tooltip_eh_DupFileFormat = Format des neuen Dateinamens:`n\F = Dateiname`n\N = Nummer
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName              = %eh_ScriptName% - Hotkeys for Explorer
		Description           = Enhances the Explorer with additional hotkeys.
		lng_eh_ViewLargeIcons = Symbol view
		lng_eh_ViewList       = List view
		lng_eh_ViewDetails    = Detail view
		lng_eh_ViewThumbnails = Thumbnail view
		lng_eh_ViewTile       = Tile view
		lng_eh_ViewFilmstrip  = Filmstrip view
		lng_eh_ToggleHiddenFiles = Toggle hidden files
		lng_eh_ToggleExtensions = Toggle file extensions
		lng_eh_MouseWheel     = Shift+Mousewheel to call forward/backward
		lng_eh_FolderView     = Toggle folders
		lng_eh_FolderUp       = One folder up
		lng_eh_FolderDown     = Open folder/file
		lng_eh_DuplicateWin   = Duplicate explorer window
		lng_eh_DuplicateFile  = Duplicate files
		lng_eh_Format         = Format
		lng_eh_Find           = Find:
		lng_eh_FindAsYouType  = Find as you type
		lng_eh_CompatibleFolderUp = Use compatibility mode for 'One folder up'
	}

	eh_Classes =  ahk_class #32770,ahk_class ExploreWClass,ahk_class CabinetWClass,ahk_class bosa_sdm,ahk_class IEFrame
	eh_ExplorerClasses = ahk_class ExploreWClass,ahk_class CabinetWClass,ahk_class IEFrame
	eh_ChangeDirClasses = ahk_class #32770,ahk_class ExploreWClass,ahk_class CabinetWClass,ahk_class Afx:400000:0,ahk_class FileZilla Main Window,ahk_class bosa_sdm,ahk_class TTOTAL_CMD,ahk_class SC11MainFrame,ahk_class SC10MainFrame,ahk_class WinRarWindow,ahk_class IEFrame

	func_HotkeyRead( "eh_ViewThumbnails", ConfigFile , eh_ScriptName, "ViewThumbnails", "eh_sub_ViewThumbnails", "^+1", "$", eh_Classes )
	func_HotkeyRead( "eh_ViewTile", ConfigFile , eh_ScriptName, "ViewTile", "eh_sub_ViewTile", "^+2", "$", eh_Classes )
	func_HotkeyRead( "eh_ViewLargeIcons", ConfigFile , eh_ScriptName, "ViewLargeIcons", "eh_sub_ViewLargeIcons", "^+3", "$", eh_Classes )
	func_HotkeyRead( "eh_ViewList", ConfigFile , eh_ScriptName, "ViewList", "eh_sub_ViewList", "^+4", "$", eh_Classes )
	func_HotkeyRead( "eh_ViewDetails", ConfigFile , eh_ScriptName, "ViewDetails", "eh_sub_ViewDetails", "^+5", "$", eh_Classes )
	func_HotkeyRead( "eh_ViewFilmstrip", ConfigFile , eh_ScriptName, "ViewFilmstrip", "eh_sub_ViewFilmstrip", "^+6", "$", eh_Classes )
	func_HotkeyRead( "eh_WheelUp", ConfigFile , eh_ScriptName, "WheelUpHotkey", "eh_sub_WheelUp", "+WheelUp", "$", eh_Classes )
	func_HotkeyRead( "eh_WheelDown", ConfigFile , eh_ScriptName, "WheelDownHotkey", "eh_sub_WheelDown", "+WheelDown", "$", eh_Classes )
	func_HotkeyRead( "eh_FolderView", ConfigFile , eh_ScriptName, "FolderView", "eh_sub_FolderView", "^o", "$", eh_ExplorerClasses )
	func_HotkeyRead( "eh_FolderUp", ConfigFile , eh_ScriptName, "FolderUp", "eh_sub_FolderUp", "!up", "$", eh_Classes )
	func_HotkeyRead( "eh_FolderDown", ConfigFile , eh_ScriptName, "FolderDown", "eh_sub_FolderDown", "!down", "$", eh_Classes )
	func_HotkeyRead( "eh_DuplicateWin", ConfigFile , eh_ScriptName, "DuplicateWindow", "eh_sub_DuplicateWin", "^d", "$", eh_ExplorerClasses )
	func_HotkeyRead( "eh_DuplicateFile", ConfigFile , eh_ScriptName, "DuplicateFile", "eh_sub_DuplicateFile", "^+d", "$", eh_ExplorerClasses )
	func_HotkeyRead( "eh_FindAsYouType", ConfigFile , eh_ScriptName, "FindAsYouTypeHotkey", "eh_sub_FindAsYouType", "F3", "$", eh_Classes )
	func_HotkeyRead( "eh_ToggleHiddenFiles", ConfigFile , eh_ScriptName, "ToggleHiddenFiles", "eh_sub_ToggleHiddenFiles", "^+h", "$", eh_Classes )
	func_HotkeyRead( "eh_ToggleExtensions", ConfigFile , eh_ScriptName, "ToggleExtensions", "eh_sub_ToggleExtensions", "^+e", "$", eh_Classes )

	IniRead, eh_MouseWheel, %ConfigFile%, %eh_ScriptName%, ShiftMouseWheel, 0
	IniRead, eh_DupFileFormat, %ConfigFile%, %eh_ScriptName%, DuplicateFileFormat, \F (\N)

	eh_EscapeKeys =
	( LTrim Join
		{PrintScreen}{ScrollLock}{Pause}{PgUp}{PgDn}{Home}{End}{Ins}{Del}{BackSpace}
		{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{F13}{F14}{F15}{F16}{F17}{F18}{F19}{F20}{F21}{F22}{F23}{F24}{F25}{F26}{F27}{F28}{F29}{F30}
		{Space}{Left}{Right}{Up}{Down}{NumPadEnter}
		{AppsKey}{Esc}{Tab}{Enter}{CtrlBreak}{Help}{Sleep}
		{Browser_Back}{Browser_Forward}{Browser_Refresh}{Browser_Stop}{Browser_Search}{Browser_Favorites}{Browser_Home}
		{Volume_Mute}{Volume_Down}{Volume_Up}{Media_Next}{Media_Prev}{Media_Stop}{Media_Play_Pause}{Launch_Mail}{Launch_Media}{Launch_App1}{Launch_App2}
		{NumpadDel}{NumpadIns}{NumpadClear}{NumpadUp}{NumpadDown}{NumpadLeft}{NumpadRight}{NumpadHome}{NumpadEnd}{NumpadPgUp}{NumpadPgDn}
	)
	RegisterAdditionalSetting("eh","CompatibleFolderUp",0)
Return

SettingsGui_ExplorerHotkeys:
	func_HotkeyAddGuiControl( lng_eh_ViewThumbnails, "eh_ViewThumbnails", "xs+10 y+3 w200","","h18" )
	func_HotkeyAddGuiControl( lng_eh_ViewTile, "eh_ViewTile", "xs+10 y+3 w200","","h18" )
	func_HotkeyAddGuiControl( lng_eh_ViewLargeIcons, "eh_ViewLargeIcons", "xs+10 y+3 w200","","h18" )
	func_HotkeyAddGuiControl( lng_eh_ViewList, "eh_ViewList", "xs+10 y+3 w200","","h18" )
	func_HotkeyAddGuiControl( lng_eh_ViewDetails, "eh_ViewDetails", "xs+10 y+3 w200","","h18" )
	func_HotkeyAddGuiControl( lng_eh_ViewFilmstrip, "eh_ViewFilmstrip", "xs+10 y+3 w200","","h18" )
	func_HotkeyAddGuiControl( lng_eh_ToggleHiddenFiles, "eh_ToggleHiddenFiles", "xs+10 y+3 w200","","h18" )
	func_HotkeyAddGuiControl( lng_eh_ToggleExtensions, "eh_ToggleExtensions", "xs+10 y+3 w200","","h18" )
	func_HotkeyAddGuiControl( lng_eh_FolderView, "eh_FolderView", "xs+10 y+3 w200","","h18" )
	func_HotkeyAddGuiControl( lng_eh_FolderUp, "eh_FolderUp", "xs+10 y+3 w200","","h18" )
	func_HotkeyAddGuiControl( lng_eh_FolderDown, "eh_FolderDown", "xs+10 y+3 w200","","h18" )
	func_HotkeyAddGuiControl( lng_eh_DuplicateWin, "eh_DuplicateWin", "xs+10 y+3 w200","","h18" )
	func_HotkeyAddGuiControl( lng_eh_FindAsYouType, "eh_FindAsYouType", "xs+10 y+3 w200","","h18")
	func_HotkeyAddGuiControl( lng_eh_DuplicateFile, "eh_DuplicateFile", "xs+10 y+3 w200","","w200" )
	Gui, Add, Text, x+5 yp+3, %lng_eh_Format%:
	Gui, Add, Edit, x+5 yp-3 r1 -wrap w100 gsub_CheckIfSettingsChanged veh_DupFileFormat, % eh_DupFileFormat
	Gui, Add, CheckBox, xs+10 y+2 -Wrap gsub_CheckIfSettingsChanged veh_MouseWheel Checked%eh_MouseWheel%, %lng_eh_MouseWheel%
Return

SaveSettings_ExplorerHotkeys:
	func_HotkeyWrite( "eh_ViewLargeIcons", ConfigFile , eh_ScriptName, "ViewLargeIcons" )
	func_HotkeyWrite( "eh_ViewList", ConfigFile , eh_ScriptName, "ViewList" )
	func_HotkeyWrite( "eh_ViewDetails", ConfigFile , eh_ScriptName, "ViewDetails" )
	func_HotkeyWrite( "eh_ViewThumbnails", ConfigFile , eh_ScriptName, "ViewThumbnails" )
	func_HotkeyWrite( "eh_ViewTile", ConfigFile , eh_ScriptName, "ViewTile" )
	func_HotkeyWrite( "eh_ViewFilmstrip", ConfigFile , eh_ScriptName, "ViewFilmstrip" )
	func_HotkeyWrite( "eh_FolderView", ConfigFile , eh_ScriptName, "FolderView" )
	func_HotkeyWrite( "eh_FolderUp", ConfigFile , eh_ScriptName, "FolderUp" )
	func_HotkeyWrite( "eh_FolderDown", ConfigFile , eh_ScriptName, "FolderDown" )
	func_HotkeyWrite( "eh_DuplicateWin", ConfigFile , eh_ScriptName, "DuplicateWindow" )
	func_HotkeyWrite( "eh_DuplicateFile", ConfigFile , eh_ScriptName, "DuplicateFile" )
	func_HotkeyWrite( "eh_FindAsYouType", ConfigFile , eh_ScriptName, "FindAsYouTypeHotkey" )
	func_HotkeyWrite( "eh_ToggleHiddenFiles", ConfigFile , eh_ScriptName, "ToggleHiddenFiles" )
	func_HotkeyWrite( "eh_ToggleExtensions", ConfigFile , eh_ScriptName, "ToggleExtensions" )

	If (!InStr(eh_DupFileFormat,"\f") OR !InStr(eh_DupFileFormat,"\n"))
		eh_DupFileFormat = \F (\N)

	If eh_MouseWheel = 1
	{
		Hotkey_eh_WheelUp_new = +WheelUp
		Hotkey_eh_WheelDown_new = +WheelDown
	}
	Else
	{
		Hotkey_eh_WheelUp_new =
		Hotkey_eh_WheelDown_new =
		Hotkey_eh_WheelUp_del = 1
		Hotkey_eh_WheelDown_del = 1
	}
	func_HotkeyWrite( "eh_WheelUp", ConfigFile , eh_ScriptName, "WheelUpHotkey" )
	func_HotkeyWrite( "eh_WheelDown", ConfigFile , eh_ScriptName, "WheelDownHotkey" )

	IniWrite, %eh_MouseWheel%, %ConfigFile%, %eh_ScriptName%, ShiftMouseWheel
	IniWrite, %eh_DupFileFormat%, %ConfigFile%, %eh_ScriptName%, DuplicateFileFormat
Return

AddSettings_ExplorerHotkeys:
Return

CancelSettings_ExplorerHotkeys:
Return

DoEnable_ExplorerHotkeys:
	func_HotkeyEnable("eh_ViewLargeIcons")
	func_HotkeyEnable("eh_ViewList")
	func_HotkeyEnable("eh_ViewDetails")
	func_HotkeyEnable("eh_ViewThumbnails")
	func_HotkeyEnable("eh_ViewTile")
	func_HotkeyEnable("eh_ViewFilmstrip")
	func_HotkeyEnable("eh_FolderView")
	func_HotkeyEnable("eh_FolderUp")
	func_HotkeyEnable("eh_FolderDown")
	func_HotkeyEnable("eh_DuplicateWin")
	func_HotkeyEnable("eh_DuplicateFile")
	func_HotkeyEnable("eh_FindAsYouType")
	func_HotkeyEnable("eh_ToggleHiddenFiles")
	func_HotkeyEnable("eh_ToggleExtensions")
	If eh_MouseWheel = 1
	{
		func_HotkeyEnable("eh_WheelUp")
		func_HotkeyEnable("eh_WheelDown")
	}
Return

DoDisable_ExplorerHotkeys:
	func_HotkeyDisable("eh_ViewLargeIcons")
	func_HotkeyDisable("eh_ViewList")
	func_HotkeyDisable("eh_ViewDetails")
	func_HotkeyDisable("eh_ViewThumbnails")
	func_HotkeyDisable("eh_ViewTile")
	func_HotkeyDisable("eh_ViewFilmstrip")
	func_HotkeyDisable("eh_FolderView")
	func_HotkeyDisable("eh_FolderUp")
	func_HotkeyDisable("eh_FolderDown")
	func_HotkeyDisable("eh_WheelUp")
	func_HotkeyDisable("eh_WheelDown")
	func_HotkeyDisable("eh_DuplicateWin")
	func_HotkeyDisable("eh_DuplicateFile")
	func_HotkeyDisable("eh_FindAsYouType")
	func_HotkeyDisable("eh_ToggleHiddenFiles")
	func_HotkeyDisable("eh_ToggleExtensions")
Return

DefaultSettings_ExplorerHotkeys:
Return

OnExitAndReload_ExplorerHotkeys:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

eh_sub_ViewLargeIcons:
	WinGet, eh_activeID, ID, A
	eh_SHELLDLL_DefView := eh_func_FindWindowEx( eh_activeID, 0, "SHELLDLL_DefView", 0 )
	If eh_SHELLDLL_DefView > 0
		PostMessage, 0x111, 28713,,, ahk_id %eh_SHELLDLL_DefView% ; Large Icons
Return

eh_sub_ViewList:
	WinGet, eh_activeID, ID, A
	eh_SHELLDLL_DefView := eh_func_FindWindowEx( eh_activeID, 0, "SHELLDLL_DefView", 0 )
	If eh_SHELLDLL_DefView > 0
		PostMessage, 0x111, 28715,,, ahk_id %eh_SHELLDLL_DefView% ; List
Return

eh_sub_ViewDetails:
	WinGet, eh_activeID, ID, A
	eh_SHELLDLL_DefView := eh_func_FindWindowEx( eh_activeID, 0, "SHELLDLL_DefView", 0 )
	If eh_SHELLDLL_DefView > 0
		PostMessage, 0x111, 28716,,, ahk_id %eh_SHELLDLL_DefView% ; Details
Return

eh_sub_ViewThumbnails:
	WinGet, eh_activeID, ID, A
	eh_SHELLDLL_DefView := eh_func_FindWindowEx( eh_activeID, 0, "SHELLDLL_DefView", 0 )
	If eh_SHELLDLL_DefView > 0
	{
		If ( GetKeyState("Shift") )
		{
			SendMessage, 0x111, 28715,,, ahk_id %eh_SHELLDLL_DefView% ; List
			SendMessage, 0x111, 28717,,, ahk_id %eh_SHELLDLL_DefView% ; Thumbnails
			SendMessage, 0x111, 28715,,, ahk_id %eh_SHELLDLL_DefView% ; List
		}
		SendMessage, 0x111, 28717,,, ahk_id %eh_SHELLDLL_DefView% ; Thumbnails
	}
Return

eh_sub_ViewTile:
	WinGet, eh_activeID, ID, A
	eh_SHELLDLL_DefView := eh_func_FindWindowEx( eh_activeID, 0, "SHELLDLL_DefView", 0 )
	If eh_SHELLDLL_DefView > 0
		PostMessage, 0x111, 28718,,, ahk_id %eh_SHELLDLL_DefView% ; Tiles
Return

eh_sub_ViewFilmstrip:
	WinGet, eh_activeID, ID, A
	eh_SHELLDLL_DefView := eh_func_FindWindowEx( eh_activeID, 0, "SHELLDLL_DefView", 0 )
	If eh_SHELLDLL_DefView > 0
	{
		If ( GetKeyState("Shift") )
		{
			SendMessage, 0x111, 28715,,, ahk_id %eh_SHELLDLL_DefView% ; List
			SendMessage, 0x111, 28719,,, ahk_id %eh_SHELLDLL_DefView% ; Filmstrip
			SendMessage, 0x111, 28715,,, ahk_id %eh_SHELLDLL_DefView% ; List
		}
		SendMessage, 0x111, 28719,,, ahk_id %eh_SHELLDLL_DefView% ; Filmstrip
	}
Return

eh_sub_FolderView:
	WinGet, eh_activeID, ID, A
	eh_SHELLDLL_DefView := eh_func_FindWindowEx( eh_activeID, 0, "SHELLDLL_DefView", 0 )
	If eh_SHELLDLL_DefView > 0
		PostMessage, 0x111, 41525,,, ahk_id %eh_activeID%
Return

eh_sub_ToggleHiddenFiles:
	RegRead, eh_HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden
	If eh_HiddenFiles_Status = 2
		RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
	Else
		RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2
	WinGetClass, eh_Class,A
	If (eh_Class = "#32770" OR (aa_osversionnumber >= aa_osversionnumber_vista))
		send, {F5}
	Else
		PostMessage, 0x111, 28931,,, A
Return

eh_sub_ToggleExtensions:
	RegRead, eh_HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt
	If eh_HiddenFiles_Status = 1
		RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 0
	Else
		RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 1
	WinGetClass, eh_Class,A
	If (eh_Class = "#32770" OR (aa_osversionnumber >= aa_osversionnumber_vista))
		send, {F5}
	Else
		PostMessage, 0x111, 28931,,, A
Return

eh_sub_FolderDown:
	Send, {Enter}
	Send, {Space}
Return

eh_sub_FolderUp:
	eh_Name =
	WinGetClass, eh_activeClass, A
	WinGet, eh_activeID, ID, A
	ControlFocus, SysListView321, ahk_id %eh_activeID%
	Sleep,50
	If eh_activeClass in #32770,bosa_sdm
	{
		ControlGet, eh_Name,Choice,,ComboBox1, ahk_id %eh_activeID%
		PostMessage, 0x111, 40967,,, ahk_id %eh_activeID%
	}
	Else
	{
		eh_Folder := func_GetDir(eh_activeID)
		;SendEvent, {Backspace}
		SplitPath, eh_Folder, eh_Name, eh_ParentFolder
		If (eh_Folder = eh_ParentFolder OR InStr(eh_Folder,"::{") OR func_StrRight(eh_Folder,2) = ":\" OR eh_CompatibleFolderUp = 0)
			Send, {Backspace}
		Else
			func_ChangeDir( eh_ParentFolder )
	}
	Loop
	{
		Sleep, 20
		ControlGet, eh_Selected,List, , SysListView321, ahk_id %eh_activeID%
		If eh_Selected <>
			break
	}
	If eh_Name <>
	func_SelectInExplorer(eh_Name)
Return

eh_sub_DuplicateWin:
	WinGet, eh_activeID, ID, A
	WinGet, eh_MinMax, MinMax, A
	eh_Folder := func_GetDir(eh_activeID)
	WinGetPos, eh_X , eh_Y , eh_Width, eh_Height, ahk_id %eh_activeID%
	ControlGet, eh_TreeVis, Visible,, SysTreeView321, ahk_id %eh_activeID%

	IfInString, eh_Folder, ::{
	{
		StringTrimLeft, eh_DirName, eh_Folder, 2
		RegRead, eh_DirName, HKCR, CLSID\%eh_DirName%
	}
	Else
		SplitPath, eh_Folder, eh_DirName
	Run, explorer.exe /n`,%eh_Folder%
	WinWaitNotActive, ahk_id %eh_activeID%
	WinWaitActive, %eh_DirName%,,1
	If ErrorLevel = 0
	{
		If eh_MinMax <> 1
			WinMove, A,, % eh_x+20, % eh_y+20, %eh_Width%, %eh_Height%
		Else
			WinMaximize, A
		If eh_TreeVis > 0
			SendMessage, 0x111, 41525, 0, , A
	}
Return

eh_sub_DuplicateFile:
	func_GetSelection(1,0,10)
	eh_Selection = %Selection%
	eh_NumFiles = 1
	Loop, Parse, eh_Selection, `n, `r
	{
		If A_LoopField =
			continue
		SplitPath, A_LoopField, , eh_Dir, eh_Ext, eh_Name
		If eh_Ext <>
			eh_Ext = .%eh_Ext%
		Loop
		{
			eh_Counter := A_Index+1
			StringReplace, eh_NewName, eh_DupFileFormat, \f, %eh_Name%
			StringReplace, eh_NewName, eh_NewName, \n, %eh_Counter%
			eh_NewFile = %eh_Dir%\%eh_NewName%%eh_Ext%
			IfNotExist, %eh_NewFile%
			{
				If ( InStr(FileExist(A_LoopField),"D") )
					FileCopyDir, %A_LoopField%, %eh_NewFile%
				Else
					FileCopy, %A_LoopField%, %eh_NewFile%
				break
			}
		}
		If eh_NumFiles = 1
		{
			eh_SelectFile = %eh_NewName%%eh_Ext%
		}
		eh_NumFiles++
	}
	SendMessage, 0x111, 41504,,, A ; Aktualisieren
	func_SelectInExplorer(eh_SelectFile)   ; Ordner auswählen (durch Eingabe des Namens)
Return

eh_sub_WheelUp:
	WinGetClass, eh_activeClass, A
	If eh_activeClass in #32770,bosa_sdm
		PostMessage, 0x111, 40961,,, ahk_class %eh_activeClass%
	Else
		Send, {Browser_forward}
Return

eh_sub_WheelDown:
	WinGetClass, eh_activeClass, A
	If eh_activeClass in #32770,bosa_sdm
		PostMessage, 0x111, 40971,,, ahk_class %eh_activeClass%
	Else
		Send, {Browser_back}
Return

eh_sub_FindAsYouType:
	Thread, interrupt, 0
	CoordMode, ToolTip, Relative
	WinGet, eh_activeID, ID, A
	ControlGet, eh_List, List, Col1, SysListView321, A
	ControlFocus, SysListView321, A
	func_HotkeyDisable("eh_FindAsYouType")

	eh_AllKeys =
	eh_LastFound =
	tooltip, %lng_eh_Find%, %A_CaretX%, %A_CaretY%, 2
	Loop
	{
		ControlGetFocus, eh_Focus, A
		If eh_Focus not in SysListView321
			Break
		Input, eh_Key, * T3 L1, %eh_EscapeKeys%
		StringReplace, eh_Endkey, ErrorLevel, Endkey:
		If eh_Endkey = TimeOut
		{
			If eh_AllKeys <>
				eh_LastAllKeys = %eh_AllKeys%
			eh_AllKeys =
			eh_LastFound =
			eh_TimeOutCount =
			ToolTip, %lng_eh_Find%, %A_CaretX%, %A_CaretY%, 2
			continue
		}
		Else If eh_Key <>
		{
			eh_TimeOutCount =
			SetTimer, eh_tim_SelectInExplorer, Off
			Break = 1
		}
		Else If eh_Endkey = Delete
		{
			eh_LastAllKeys = %eh_AllKeys%
			eh_AllKeys =
			eh_LastFound =
			ToolTip, %lng_eh_Find%, %A_CaretX%, %A_CaretY%, 2
			continue
		}
		Else If eh_Endkey = Backspace
		{
			eh_Endkey = Max
			StringTrimRight, eh_AllKeys, eh_AllKeys, 1
			eh_LastFound =
		}
		Else If eh_Endkey in Escape
			Break
		Else If eh_Endkey in F3
		{
			eh_LastFound++
			If eh_LastAllKeys <>
				eh_AllKeys = %eh_LastAllKeys%
		}
		Else If eh_Endkey not in Max,TimeOut,F3
		{
			Send, {%eh_Endkey%}
			Break
		}
		eh_AllKeys = %eh_AllKeys%%eh_Key%
		If eh_AllKeys <>
			eh_LastAllKeys = %eh_AllKeys%
		tooltip, %lng_eh_Find% %eh_AllKeys%, %A_CaretX%, %A_CaretY%, 2
		eh_PriorFound = %eh_LastFound%
		SetTimer, eh_tim_PrepareSelectInExplorer, 1
	}
	SetTimer, eh_tim_SelectInExplorer, Off
	tooltip,, , , 2
	func_HotkeyEnable("eh_FindAsYouType")
Return

eh_tim_PrepareSelectInExplorer:
	SetTimer, eh_tim_PrepareSelectInExplorer, Off
	eh_NotFound = 1
	Loop, Parse, eh_List, `n, `r
	{
		If (InStr(A_LoopField, eh_AllKeys) AND A_Index >= eh_LastFound)
		{
			eh_LastFound = %A_Index%
			eh_LoopField = %A_LoopField%
			SetTimer, eh_tim_SelectInExplorer, 200
			eh_NotFound =
			Break
		}
	}
	If eh_NotFound = 1
	{
		eh_LastFound =
		Send,{Home}
		Loop, Parse, eh_List, `n, `r
		{
			If (InStr(A_LoopField, eh_AllKeys) AND A_Index > eh_LastFound)
			{
				eh_LastFound = %A_Index%
				eh_LoopField = %A_LoopField%
				SetTimer, eh_tim_SelectInExplorer, 200
				Break
			}
		}
	}
Return

eh_tim_SelectInExplorer:
	Thread, interrupt, 0
	SetTimer, eh_tim_SelectInExplorer, Off
	func_SelectInExplorer(eh_LoopField, "ahk_id " eh_activeID )
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

eh_func_FindWindowEx( p_hw_parent, p_hw_child, p_class, p_title ) {
	if ( p_title = 0 )
		type_title = uint
	else
		type_title = str

	return, DllCall( "FindWindowEx"
						, "uint", p_hw_parent
						, "uint", p_hw_child
						, "str", p_class
						, type_title, p_title )
}
