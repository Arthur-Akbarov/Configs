; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               QuickChangeDir
; -----------------------------------------------------------------------------
; Prefix:             qc_
; Version:            1.5
; Date:               2008-05-23
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_QuickChangeDir:
	; Programmname und Version
	Prefix           = qc
	%Prefix%_ScriptName    = QuickChangeDir
	%Prefix%_ScriptVersion = 1.5
	%Prefix%_Author        = Wolfgang Reszel
	%Prefix%_Titel = %qc_ScriptName% v%qc_ScriptVersion%

	CustomHotkey_QuickChangeDir = 1    ; Benutzerdefiniertes Hotkey
	Hotkey_QuickChangeDir       = #-   ; Standard-Hotkey
	HotkeyPrefix_QuickChangeDir =
	ConfigFile_QuickChangeDir   = settings\QuickChangeDir.ini

	qc_RequiredIndexVersion = 1.5

	IconFile_On_QuickChangeDir = %A_WinDir%\system32\shell32.dll
	IconPos_On_QuickChangeDir = 46

	SubMenu = QuickChangeDir_Menu

	; Name der Index-Dateien
	IniRead, qc_HiddenOnUnix, %ConfigFile_QuickChangeDir%, Config, HiddenOnUnix, 0

	If qc_HiddenOnUnix = 1
	{
		qc_IndexFile = .QCD_Index_
		qc_IndexFileRoot = .QCD_Index
	}
	Else
	{
		qc_IndexFile = QCD_Index_
		qc_IndexFileRoot = QCD_Index
	}

	qc_selectedDrives = %qc_PathsToIndex%

	CreateGuiID("QuickChangeDirSchedule")
	CreateGuiID("QuickChangeDir")
	CreateGuiID("QuickChangeDirResults")

	if Lng = 07  ; = Deutsch (0407, 04807, 0c07 ...)
	{
		MenuName                      = %qc_ScriptName% - Schneller Verzeichniswechsel
		Description                   = Schneller Verzeichniswechsel durch Eingabe eines Teils des gesuchten Verzeichnisnamens. Für den Verzeichniswechsel muss die Adressleiste im Explorer sichtbar sein.
		QuickChangeDir_EnableMenu     = %qc_ScriptName% aktiviert
		lng_qc_Untersuche             = Untersuche Laufwerk
		lng_qc_Indiziere              = Erstelle Verzeichnisindex
		lng_qc_Wechseln               = &Verzeichnis wechseln
		lng_qc_ReIndizierung          = Verzeichnisindex &aktualisieren
		lng_qc_Suchen                 = &Suchen
		lng_qc_Aktualisieren          = 8
		lng_qc_AktualisierenEinzeln   = ###`taktualisieren
		lng_qc_AktualisierenAlle      = alle Verzeichnisse aktualisieren
		lng_qc_NeuesFenster           = &Neues Fenster
		lng_qc_VerzWechseln           = &OK, wechseln
		lng_qc_ÜberVerzHinzu          = Überverzeichnis hinzufügen
		lng_qc_AusIndexEntf           = Verzeichnis samt Unterverzeichnissen aus Index entfernen
		lng_qc_LaufwerkERR            = Laufwerk existiert nicht
		lng_qc_SucheERR               = Nichts gefunden
		lng_qc_SuchEingabe            = &Suchbegriff eingeben:
		lng_qc_DosBox                 = &DOS-Box
		lng_qc_AddToIndexList         = Laufwerke/Verzeichnisse, die indexiert werden:
		lng_qc_IndexPath              = Verzeichnis, wo die Indexdateien abgelegt werden (leer = im Hauptverzeichnis des jeweiligen Laufwerks):
		lng_qc_NoIndex                = Es wurde noch kein Verzeichnisindex angelegt, die Suche funktioniert, nachdem die Indexierung beendet wurde.

		lng_qc_Scheduler              = Indexierungs-Planer
		lng_qc_SchedulerInfo          = Die Indexierung kann automatisch unter folgenden Kriterien erfolgen ...
		lng_qc_AutoIndexing           = wenn sich der freie Speicher eines Laufwerks um folgenden Wert verändert hat:
		lng_qc_IndexingTime           = zu bestimmten Uhrzeiten (08:00,23:00,...):
		lng_qc_IndexingTimeFailure    = versäumte Indexierungen beim Starten von ac'tivAid nachholen
		lng_qc_IndexingInterval       = alle
		lng_qc_Hours                  = Stunden
		lng_qc_IndexOnShutDown        = beim Herunterfahren/Ausschalten (nur über AutoShutdown oder PowerControl)

		lng_qc_SucheNach              = Suche nach:
		lng_qc_FolderTree             = Explorer mit Verzeichnisbaum öffnen
		lng_qc_NoIndexer              = Zur Indexierung wird das Skript "extensions/ac'tivAid_QuickChangeDir Indexer.ahk" benötigt.

		lng_qc_Found                  = gefunden
		lng_qc_SearchDefault          = Suchbegriff-Vorgabe

		lng_qc_WindowDocking          = Fenster andocken
		lng_qc_VariableDriveLetter    = Pfad-Variablen im Index verwenden

		tooltip_a                     = Index für den ausgewählten Pfad aktualisieren
	}
	else        ; = andere Sprachen
	{
		MenuName                      = %qc_ScriptName% - fast folder-switching
		Description                   = Change the folder of the current window to a pre-indexed folder by typing a part of its name. The address bar has to be visible to change the directory.
		QuickChangeDir_EnableMenu     = %qc_ScriptName% active
		lng_qc_Untersuche             = scanning drive
		lng_qc_Indiziere              = creating directory-index
		lng_qc_Wechseln               = &change directory
		lng_qc_ReIndizierung          = &update directory-index
		lng_qc_Suchen                 = &Search
		lng_qc_Aktualisieren          = 8
		lng_qc_AktualisierenEinzeln   = update ###
		lng_qc_AktualisierenAlle      = update all directories
		lng_qc_NeuesFenster           = &new window
		lng_qc_VerzWechseln           = &OK, change
		lng_qc_ÜberVerzHinzu          = add upper directory
		lng_qc_AusIndexEntf           = remove folder and sub-folders from index
		lng_qc_LaufwerkERR            = drive does not exist
		lng_qc_SucheERR               = nothing found
		lng_qc_SuchEingabe            = &Enter search term:
		lng_qc_DosBox                 = &DOS-Box
		lng_qc_AddToIndexList         = Drives/Paths to index:
		lng_qc_IndexPath              = Directory to store the index-files (empty = at the root of every indexed drive):
		lng_qc_NoIndex                = No index-files found. You can use the search after the indexing has been finished.

		lng_qc_AutoIndexing           = Automatic indexing, if the drive-space changed about:
		lng_qc_Scheduler              = schedule indexing
		lng_qc_SchedulerInfo          = Automatic indexing can be controlled with the following rules ...
		lng_qc_AutoIndexing           = if the drive-space changed about:
		lng_qc_IndexingTime           = at a appointed time (08:00,23:00,...):
		lng_qc_IndexingTimeFailure    = retry missed indexing when ac'tivAid starts
		lng_qc_IndexingInterval       = every
		lng_qc_Hours                  = hours
		lng_qc_IndexOnShutDown        = at shutdown/poweroff (only with AutoShutdown or PowerControl)

		lng_qc_SucheNach              = search for:
		lng_qc_FolderTree             = open Explorer with folder-tree
		lng_qc_NoIndexer              = The script "extensions/ac'tivAid_QuickChangeDir Indexer.ahk" is missing.

		lng_qc_Found                  = found
		lng_qc_SearchDefault          = default search item

		lng_qc_WindowDocking          = attach windows
		lng_qc_VariableDriveLetter    = Use path variable in index

		tooltip_a                     = update index for the selected path
	}
	If CustomLanguage <>
		gosub, CustomLanguage

	qc_Points = ...................................................................

	IniRead, qc_PathsToIndex, %ConfigFile_QuickChangeDir%, Config, PathsToIndex
	If (qc_PathsToIndex = "ERROR" OR qc_PathsToIndex = "")
		qc_PathsToIndex = C:\

	IniRead, qc_IndexPathNoDeref, %ConfigFile_QuickChangeDir%, Config, IndexPath, settings\%qc_ScriptName%
	qc_IndexPath := func_Deref(qc_IndexPathNoDeref)

	IniRead, qc_History, %ConfigFile_QuickChangeDir%, History, SearchHistory
	If (qc_History = "ERROR")
		qc_History =

	IniRead, qc_SearchDefault, %ConfigFile_QuickChangeDir%, Config, SearchDefault
	If (qc_SearchDefault = "ERROR")
		qc_SearchDefault =

	;StringReplace, qc_History, qc_History, ||,|, A

	If qc_IndexPath <>
		IfNotExist, %qc_IndexPath%
			FileCreateDir, %qc_IndexPath%

	IniRead, qc_AutoIndexingSpace, %ConfigFile_QuickChangeDir%, Schedule, AutoIndexingSpace, 0
	IniRead, qc_IndexThreshold, %ConfigFile_QuickChangeDir%, Schedule, IndexThreshold, 10
	IniRead, qc_AutoIndexingTime, %ConfigFile_QuickChangeDir%, Schedule, AutoIndexingTime, 0
	IniRead, qc_AutoIndexingTimeFailure, %ConfigFile_QuickChangeDir%, Schedule, AutoIndexingTimeFailure, 0
	IniRead, qc_IndexTimeValues, %ConfigFile_QuickChangeDir%, Schedule, IndexTimeValues, %A_Space%
	IniRead, qc_AutoIndexingInterval, %ConfigFile_QuickChangeDir%, Schedule, AutoIndexingInterval, 0
	IniRead, qc_IndexInterval, %ConfigFile_QuickChangeDir%, Schedule, IndexInterval, %A_Space%
	IniRead, qc_IndexOnShutDown, %ConfigFile_QuickChangeDir%, Schedule, IndexOnShutDown, 0

	IniRead, qc_NoBalloonTips, %ConfigFile_QuickChangeDir%, Config, NoBalloonTips, 0
	IniRead, qc_LastTimeIndexed , %ConfigFile_QuickChangeDir%, Schedule, LastTimeIndexed, 00000000000000
	IniRead, qc_NextIndexing, %ConfigFile_QuickChangeDir%, Schedule, NextIndexing, 0
	IniRead, qc_WindowDocking, %ConfigFile_QuickChangeDir%, Window, WindowDocking, 1
	IniRead, qc_HistoryLength, %ConfigFile_QuickChangeDir%, History, HistoryLength, 20

	; Traymenü erweitern
	Menu, QuickChangeDir_Menu, Add, %QuickChangeDir_EnableMenu%, sub_MenuCall
	Menu, QuickChangeDir_Menu, Add

	; Untermenü für die Laufwerksaktualisierung erzeugen
	Loop, Parse, qc_PathsToIndex, `,
	{
		qc_LoopField := func_Deref(A_LoopField)
		qc_LoopField := qc_func_GetDrive(qc_LoopField,"RealPath")
		StringReplace, qc_SubMenuItem, lng_qc_AktualisierenEinzeln, ###, %qc_LoopField%
		Menu, QuickChangeDir_Menu, Add, %qc_SubMenuItem%, qc_submenu_IndexDrives
	}
	Menu, QuickChangeDir_Menu, Add, %lng_qc_AktualisierenAlle%, qc_submenu_IndexDrives

	IniRead, qc_FolderTree, %ConfigFile_QuickChangeDir%, Config, FolderTree, 0

	If activAid_HasChanged = 1
	{
		IfNotExist, extensions\ac'tivAid_QuickChangeDir Indexer.exe
		{
			func_UnpackSplash("extensions\ac'tivAid_QuickChangeDir Indexer.exe")
			FileInstall, extensions\ac'tivAid_QuickChangeDir Indexer.exe, extensions\ac'tivAid_QuickChangeDir Indexer.exe, 1
		}
	}

	qc_winYDistance := CaptionHeight+BorderHeight

	If AHKonUSB = 1
		RegisterAdditionalSetting("qc","VariableDriveLetter",1)
	Else
		RegisterAdditionalSetting("qc","VariableDriveLetter",0)

	IniRead, qc_IndexVersion, %ConfigFile_QuickChangeDir%, Config, IndexVersion, 1
	If (qc_IndexVersion < qc_RequiredIndexVersion)
		al_ReIndex = 1

	qc_SelectedDrives =
	If (qc_IndexVersion < qc_RequiredIndexVersion)
		SetTimer, qc_sub_IndexDrives, -2000
Return

SettingsGui_QuickChangeDir:
	Gui, Add, Text, xs+10 y+8 , %lng_qc_SearchDefault%:
	Gui, Add, Edit, gsub_CheckIfSettingsChanged x+5 yp-3 R1 w180 vqc_SearchDefault, %qc_SearchDefault%

	Gui, Add, Text, Y+5 XS+10, %lng_qc_AddToIndexList%
	StringReplace, qc_PathsToIndex_Box, qc_PathsToIndex , `, , | , a
	Gui, Add, ListBox, Y+5 vqc_PathsToIndex_Box_tmp W530 R9, %qc_PathsToIndex_Box%
	qc_PathsToIndex_Box_DontAllowSubfolders = 1
	Gui, Add, Button, -Wrap x+4 w21 vqc_Add_PathsToIndex_Box gqc_sub_ListBox_addFolder, +
	Gui, Add, Button, -Wrap y+4 w21 vqc_Remove_PathsToIndex_Box gsub_ListBox_remove, %MinusString%
	Gui, Font, S%FontSize10%, Marlett
	Gui, Add, Button, -Wrap y+49 w21 gqc_sub_ListBox_DoIndex, a
	Gosub, GuiDefaultFont

	Gui, Add, CheckBox, -Wrap xs+10 y+15 Checked%qc_NoBalloonTips% gsub_CheckIfSettingsChanged vqc_NoBalloonTips, %lng_NoBalloonTips%
	Gui, Add, CheckBox, -Wrap X+20 vqc_FolderTree gsub_CheckIfSettingsChanged Checked%qc_FolderTree%, %lng_qc_FolderTree%
	Gui, Add, CheckBox, -Wrap X+20 vqc_WindowDocking gsub_CheckIfSettingsChanged Checked%qc_WindowDocking%, %lng_qc_WindowDocking%

	Gui, Add, Text, xs+10 y+15 , %lng_qc_IndexPath%
	Gui, Add, Edit, gsub_CheckIfSettingsChanged R1 w320 vqc_IndexPathNoDeref, %qc_IndexPathNoDeref%
	Gui, Add, Button, -Wrap X+5 YP-1 W100 gqc_sub_Browse, %lng_Browse%
	Gui, Add, Button, -Wrap X+5 W120 gqc_sub_Scheduler, %lng_qc_Scheduler% ...
Return

ResetWindows_QuickChangeDir:
	IniDelete, %ConfigFile_QuickChangeDir%, Window, SearchWindowX
	IniDelete, %ConfigFile_QuickChangeDir%, Window, SearchWindowY
	IniDelete, %ConfigFile_QuickChangeDir%, Window, ResultWindowX
	IniDelete, %ConfigFile_QuickChangeDir%, Window, ResultWindowY
	IniDelete, %ConfigFile_QuickChangeDir%, Window, ResultWindowWidth
	IniDelete, %ConfigFile_QuickChangeDir%, Window, ResultWindowHeight
Return

qc_sub_ListBox_addFolder:
	If qc_VariableDriveLetter = 1
		ListBox_addFolder_VariableDriveLetter = 1
	Gosub, sub_ListBox_addFolder
	ListBox_addFolder_VariableDriveLetter =
Return

qc_sub_Scheduler:
	Gui, %GuiID_activAid%:+Disabled
	GuiDefault("QuickChangeDirSchedule", "+Owner" GuiID_activAid)
	Gosub, GuiDefaultFont
	Gui, Add, Text,, %lng_qc_SchedulerInfo%

	Gui, Add, GroupBox, x10 w520 h35
	Gui, Add, CheckBox, xp+10 yp+15 -Wrap Checked%qc_AutoIndexingSpace% gsub_CheckIfSettingsChanged vqc_AutoIndexingSpace, %lng_qc_AutoIndexing%
	Gui, Add, ComboBox, x+5 yp-4 w55 gsub_CheckIfSettingsChanged vqc_IndexThreshold, 2|5|10|15|20|30|50|75|100|250|500|1000
	GuiControl,Text, qc_IndexThreshold, %qc_IndexThreshold%
	Gui, Add, Text, yp+4 x+5, MB

	Gui, Add, GroupBox, x10 y+5 w520 h55
	Gui, Add, CheckBox, xp+10 yp+15 -Wrap Checked%qc_AutoIndexingTime% gsub_CheckIfSettingsChanged vqc_AutoIndexingTime, %lng_qc_IndexingTime%
	Gui, Add, Edit, x+5 yp-4 w280 gsub_CheckIfSettingsChanged vqc_IndexTimeValues, %qc_IndexTimeValues%
	Gui, Add, CheckBox, x40 y+3 -Wrap Checked%qc_AutoIndexingTimeFailure% gsub_CheckIfSettingsChanged vqc_AutoIndexingTimeFailure, %lng_qc_IndexingTimeFailure%

	Gui, Add, GroupBox, x10 y+5 w520 h35

	Gui, Add, CheckBox, xp+10 yp+15 -Wrap Checked%qc_AutoIndexingInterval% gsub_CheckIfSettingsChanged vqc_AutoIndexingInterval, %lng_qc_IndexingInterval%
	Gui, Add, ComboBox, x+5 yp-4 w55 gsub_CheckIfSettingsChanged vqc_IndexInterval, 00:05|00:15|00:30|01:00|02:00|03:00|04:00|06:00|12:00|24:00|48:00
	GuiControl,Text, qc_IndexInterval, %qc_IndexInterval%
	Gui, Add, Text, yp+4 x+5, %lng_qc_Hours%

	Gui, Add, GroupBox, x10 y+5 w520 h35
	Gui, Add, CheckBox, xp+10 yp+15 -Wrap Checked%qc_IndexOnShutDown% gsub_CheckIfSettingsChanged vqc_IndexOnShutDown, %lng_qc_IndexOnShutDown%

	Gui, Add, Button, -Wrap X180 W80 vMainGuiOK Default gqc_sub_SchedulerOK, %lng_OK%
	Gui, Add, Button, -Wrap X+5 W80 vMainGuiCancel gQuickChangeDirScheduleGuiClose, %lng_cancel%

	Gui, Show, w540, %qc_ScriptName% %lng_qc_Scheduler%
Return

QuickChangeDirScheduleGuiClose:
QuickChangeDirScheduleGuiEscape:
	Gui, %GuiID_activAid%:-Disabled
	Gui, Destroy
Return

qc_sub_SchedulerOK:
	func_SettingsChanged( "QuickChangeDir" )
	Gui, %GuiID_activAid%:-Disabled
	Gui, Submit
	Sort, qc_IndexTimeValues, D`,
	Gui, Destroy
Return

qc_sub_ListBox_DoIndex:
	GuiControlGet, qc_selectedDrives, , qc_PathsToIndex_Box_tmp
	qc_selectedDrives := func_Deref(qc_selectedDrives)
	qc_selectedDrives := qc_func_GetDrive( qc_selectedDrives, "RealPath" )
	gosub, qc_sub_IndexDrives
Return

qc_sub_Browse:
	Gui +OwnDialogs
	GuiControlGet,qc_IndexPathTmp,,qc_IndexPath
	Transform, qc_IndexPathTmp, Deref, %qc_IndexPathTmp%
	FileSelectFolder, qc_IndexPathTmp, *%qc_IndexPathTmp% , 3
	If qc_IndexPathTmp <>
		GuiControl,,qc_IndexPath,%qc_IndexPathTmp%
Return

SaveSettings_QuickChangeDir:
	qc_PathsToIndex_last := qc_PathsToIndex
	StringReplace, qc_PathsToIndex, qc_PathsToIndex_Box, |, `, ,a
	If (func_StrLeft(qc_PathsToIndex,1) = ",")
		StringTrimLeft, qc_PathsToIndex, qc_PathsToIndex, 1
	If (func_StrRight(qc_PathsToIndex,1) = ",")
		StringTrimRight, qc_PathsToIndex, qc_PathsToIndex, 1

	IniWrite, %qc_IndexPathNoDeref%, %ConfigFile_QuickChangeDir%, Config, IndexPath
	qc_IndexPath := func_Deref(qc_IndexPathNoDeref)
	IniWrite, %qc_PathsToIndex%, %ConfigFile_QuickChangeDir%, Config, PathsToIndex
	IniWrite, %qc_AutoIndexingSpace%, %ConfigFile_QuickChangeDir%, Schedule, AutoIndexingSpace
	IniWrite, %qc_IndexThreshold%, %ConfigFile_QuickChangeDir%, Schedule, IndexThreshold
	IniWrite, %qc_AutoIndexingTime%, %ConfigFile_QuickChangeDir%, Schedule, AutoIndexingTime
	IniWrite, %qc_AutoIndexingTimeFailure%, %ConfigFile_QuickChangeDir%, Schedule, AutoIndexingTimeFailure
	IniWrite, %qc_IndexTimeValues%, %ConfigFile_QuickChangeDir%, Schedule, IndexTimeValues
	IniWrite, %qc_AutoIndexingInterval%, %ConfigFile_QuickChangeDir%, Schedule, AutoIndexingInterval
	IniWrite, %qc_IndexInterval%, %ConfigFile_QuickChangeDir%, Schedule, IndexInterval
	IniWrite, %qc_IndexOnShutDown%, %ConfigFile_QuickChangeDir%, Schedule, IndexOnShutDown
	IniWrite, %qc_NoBalloonTips%, %ConfigFile_QuickChangeDir%, Config, NoBalloonTips
	IniWrite, %qc_FolderTree%, %ConfigFile_QuickChangeDir%, Config, FolderTree
	IniWrite, %qc_SearchDefault%, %ConfigFile_QuickChangeDir%, Config, SearchDefault
	IniWrite, %qc_WindowDocking%, %ConfigFile_QuickChangeDir%, Window, WindowDocking
	IniWrite, %qc_HistoryLength%, %ConfigFile_QuickChangeDir%, History, HistoryLength

	Menu, QuickChangeDir_Menu, DeleteAll

	Menu, QuickChangeDir_Menu, Add, %QuickChangeDir_EnableMenu%, sub_MenuCall
	Menu, QuickChangeDir_Menu, Add

	; Untermenü für die Laufwerksaktualisierung erzeugen
	Loop, Parse, qc_PathsToIndex, `,
	{
		qc_LoopField := func_Deref(A_LoopField)
		qc_LoopField := qc_func_GetDrive(qc_LoopField,"RealPath")
		StringReplace, qc_SubMenuItem, lng_qc_AktualisierenEinzeln, ###, %qc_LoopField%
		Menu, QuickChangeDir_Menu, Add, %qc_SubMenuItem%, qc_submenu_IndexDrives
	}
	Menu, QuickChangeDir_Menu, Add, %lng_qc_AktualisierenAlle%, qc_submenu_IndexDrives

	If (qc_PathsToIndex_last <> qc_PathsToIndex)
	{
		qc_selectedDrives =
		Loop, Parse, qc_PathsToIndex, `,
		{
			qc_NewIndexPath := func_Deref(A_LoopField)
			qc_NewIndexDir = 1
			Loop, Parse, qc_PathsToIndex_last, `,
			{
				qc_LoopField := func_Deref(A_LoopField)
				If qc_LoopField = %qc_NewIndexPath%
				{
					qc_NewIndexDir =
					Break
				}
			}
			If qc_NewIndexDir = 1
				qc_selectedDrives = %qc_selectedDrives%,%qc_NewIndexPath%

		}
		Loop, Parse, qc_PathsToIndex_last, `,
		{
			qc_NewIndexPath := func_Deref(A_LoopField)
			qc_NewIndexDir = 1
			Loop, Parse, qc_PathsToIndex, `,
			{
				qc_LoopField := func_Deref(A_LoopField)
				If qc_LoopField = %qc_NewIndexPath%
				{
					qc_NewIndexDir =
					Break
				}
			}
			If qc_NewIndexDir = 1
				qc_selectedDrives = %qc_selectedDrives%,%qc_NewIndexPath%

		}
		StringTrimLeft, qc_selectedDrives, qc_selectedDrives, 1
		If qc_selectedDrives <>
			Gosub, qc_sub_IndexDrives
	}
Return

CancelSettings_QuickChangeDir:
Return

DoEnable_QuickChangeDir:
	SetTimer, qc_tim_AutoIndexing, 6000
Return

DoDisable_QuickChangeDir:
	SetTimer, qc_tim_AutoIndexing, Off
	Gui, %GuiID_QuickChangeDir%:Destroy
	Gui, %GuiID_QuickChangeDirResults%:Destroy
	qc_GUI=
Return

DefaultSettings_QuickChangeDir:
Return

OnShutDown_QuickChangeDir:
	If qc_IndexOnShutDown = 1
		Gosub, qc_sub_IndexDrivesWait
Return

CheckShutDown_QuickChangeDir:
	Result = %qc_IndexOnShutDown%
Return

Update_QuickChangeDir:
	IniRead, qc_PathsToIndex, %ConfigFile%, %qc_ScriptName%, PathsToIndex
	IniRead, qc_IndexPathNoDeref, %ConfigFile%, %qc_ScriptName%, IndexPath
	qc_IndexPath := func_Deref(qc_IndexPathNoDeref)
	IniRead, qc_AutoIndexingSpace, %ConfigFile%, %qc_ScriptName%, AutoIndexingSpace
	IniRead, qc_IndexThreshold, %ConfigFile%, %qc_ScriptName%, IndexThreshold
	IniRead, qc_AutoIndexingTime, %ConfigFile%, %qc_ScriptName%, AutoIndexingTime
	IniRead, qc_AutoIndexingTimeFailure, %ConfigFile%, %qc_ScriptName%, AutoIndexingTimeFailure
	IniRead, qc_IndexTimeValues, %ConfigFile%, %qc_ScriptName%, IndexTimeValues
	IniRead, qc_AutoIndexingInterval, %ConfigFile%, %qc_ScriptName%, AutoIndexingInterval
	IniRead, qc_IndexInterval, %ConfigFile%, %qc_ScriptName%, IndexInterval
	IniRead, qc_NoBalloonTips, %ConfigFile%, %qc_ScriptName%, NoBalloonTips
	IniRead, qc_FolderTree, %ConfigFile%, %qc_ScriptName%, FolderTree

	If (qc_IndexPath <> "ERROR" AND qc_PathsToIndex <> "ERROR")
	{

		IniWrite, %qc_IndexPath%, %ConfigFile_QuickChangeDir%, Config, IndexPath
		IniWrite, %qc_PathsToIndex%, %ConfigFile_QuickChangeDir%, Config, PathsToIndex
		IniWrite, %qc_AutoIndexingSpace%, %ConfigFile_QuickChangeDir%, Schedule, AutoIndexingSpace
		IniWrite, %qc_IndexThreshold%, %ConfigFile_QuickChangeDir%, Schedule, IndexThreshold
		IniWrite, %qc_AutoIndexingTime%, %ConfigFile_QuickChangeDir%, Schedule, AutoIndexingTime
		IniWrite, %qc_AutoIndexingTimeFailure%, %ConfigFile_QuickChangeDir%, Schedule, AutoIndexingTimeFailure
		IniWrite, %qc_IndexTimeValues%, %ConfigFile_QuickChangeDir%, Schedule, IndexTimeValues
		IniWrite, %qc_AutoIndexingInterval%, %ConfigFile_QuickChangeDir%, Schedule, AutoIndexingInterval
		IniWrite, %qc_IndexInterval%, %ConfigFile_QuickChangeDir%, Schedule, IndexInterval
		IniWrite, %qc_NoBalloonTips%, %ConfigFile_QuickChangeDir%, Config, NoBalloonTips
		IniWrite, %qc_FolderTree%, %ConfigFile_QuickChangeDir%, Config, FolderTree

		IniRead, qc_WinX, %ConfigFile%, %qc_ScriptName%, SearchWindowX, %A_Space%
		IniRead, qc_WinY, %ConfigFile%, %qc_ScriptName%, SearchWindowY, %A_Space%
		IniWrite, %qc_WinX%, %ConfigFile_QuickChangeDir%, Window, SearchWindowX
		IniWrite, %qc_WinY%, %ConfigFile_QuickChangeDir%, Window, SearchWindowY

		IniRead, qc_WinW, %ConfigFile%, %qc_ScriptName%, ResultWindowWidth  ; Fensterbreite
		IniRead, qc_WinH, %ConfigFile%, %qc_ScriptName%, ResultWindowHeight ; Fensterhöhe
		If (qc_WinW = ERROR OR qc_WinW = "")
			qc_WinW = 620
		If (qc_WinH = ERROR OR qc_WinH = "")
			qc_WinH = 460
		IniRead, qc_WinX, %ConfigFile%, %qc_ScriptName%, ResultWindowX, %A_Space%  ; Fenster X
		IniRead, qc_WinY, %ConfigFile%, %qc_ScriptName%, ResultWindowY, %A_Space% ; Fenster Y
		IniWrite, %qc_WinW%, %ConfigFile_QuickChangeDir%, Window, ResultWindowWidth
		IniWrite, %qc_WinH%, %ConfigFile_QuickChangeDir%, Window, ResultWindowHeight
		IniWrite, x%qc_WinX%, %ConfigFile_QuickChangeDir%, Window, ResultWindowX
		IniWrite, y%qc_WinY%, %ConfigFile_QuickChangeDir%, Window, ResultWindowY

		IniDelete, %ConfigFile%, QuickChangeDir
	}
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

sub_Hotkey_QuickChangeDir:
	gosub, qc_main_QuickChangeDir
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

; ---------------------------------------------------------------------
qc_main_QuickChangeDir: ; Unterroutine für das Eingabefenster
	SetTimer, qc_tim_WatchWindows, Off

	If Enable_QuickChangeDir = 1
	{
		If qc_GUI <> 8 ; Fenster aufbauen, wenn es noch nicht existiert
		{
			If qc_GUI = 9
			{
				Gosub, QuickChangeDirResultsGuiClose
				Sleep, 100
			}
			Else
			{
				WinGet     , qc_TargetWindowID, ID, A             ; ID es aktiven Fensters
				WinGetClass, qc_class, ahk_id %qc_TargetWindowID%  ; Fensterklasse ermitteln
			}

			If qc_Class contains %ChangeDirClasses%
				qc_DoDocking = 1
			Else
				qc_DoDocking = 0

			qc_WinH   = 80   ; Fensterhöhe
			qc_WinW   = 300  ; Fensterbreite

			If (qc_WindowDocking = 0 OR qc_DoDocking = 0)
			{
				IniRead, qc_WinX, %ConfigFile_QuickChangeDir%, Window, SearchWindowX, %A_Space%
				IniRead, qc_WinY, %ConfigFile_QuickChangeDir%, Window, SearchWindowY, %A_Space%
				StringTrimLeft, qc_WinX, qc_WinX, 1
				StringTrimLeft, qc_WinY, qc_WinY, 1
			}
			Else
			{
				WinGetPos, qc_TargetWinX, qc_TargetWinY, qc_TargetWinW, qc_TargetWinH, ahk_id %qc_TargetWindowID%

				qc_WinX := qc_TargetWinX + (qc_TargetWinW-qc_WinW)/2
				qc_WinY := qc_TargetWinY + qc_WinYDistance
			}

			If qc_WinX <>
			{
				If (qc_WinX+qc_WinW > WorkAreaWidth)
					qc_WinX := WorkAreaWidth-qc_WinW
				If (qc_WinX < WorkAreaLeft)
					qc_WinX := WorkAreaLeft
				qc_WinX = x%qc_WinX%
			}
			If qc_WinY <>
			{
				If (qc_WinY+qc_WinH > WorkAreaHeight)
					qc_WinY := WorkAreaHeight-qc_WinH
				If (qc_WinY < WorkAreaTop)
					qc_WinY := WorkAreaTop
				qc_WinY = y%qc_WinY%
			}

			; Fenster aufbauen
			GuiDefault("QuickChangeDir", "-Maximize +Alwaysontop +Lastfound")
			Gosub, sub_BigIcon

			Gui, Add, Text    ,                                    , %lng_qc_SuchEingabe%
			Gui, Font, Ccc0000 ; Text Rot (#CC0000)
			Gui, Add, Text, vqc_StatusMsg x+5 w200, %qc_ErrorMsg%
			Gui, Add, ComboBox, vqc_FindString x10 w280, %qc_SearchDefault%||%qc_History%
			Gui, Font,,Marlett
			Gui, Add, Button  , -Wrap gqc_sub_IndexingMenu w20, %lng_qc_Aktualisieren%
			Gui, Font
			Gui, Add, Button  , -Wrap gQuickChangeDirGuiClose x+95 w80, %lng_Cancel%
			Gui, Add, Button  , -Wrap gqc_sub_SearchOK x+5 w80 Default, %lng_qc_Suchen%
			WinGet, qc_GuiWinID, ID
			qc_LastTempID = %qc_GuiWinID%
			Gui, Show, w%qc_WinW% %qc_WinX% %qc_WinY%, %qc_Titel%
			WinGetPos, qc_StartX, qc_StartY, qc_StartW, qc_StartH, ahk_id %qc_GuiWinID%

			SetTimer, qc_tim_WatchWindows, 10

			Send, {Right}
			qc_ErrorMsg =
			qc_GUI = 8

			qc_Errors = 0
			qc_SelectedDrives =
			Loop, Parse, qc_PathsToIndex, `,
			{
				If A_LoopField =
					continue
				qc_LoopField := func_Deref(A_LoopField)

				qc_ActDrive := qc_func_GetDrive( qc_LoopField ) ; Aktuelles Laufwerk
				if qc_IndexPath =
				{
					qc_IndexPathDrv := qc_func_GetDrive( qc_LoopField, "RealPath" )
					qc_IndexTemp = %qc_IndexPathDrv%%qc_IndexFileRoot%.dat ; Dateiname Verzeichnisindex
					IfExist, %qc_IndexPathDrv%%qc_IndexFile%%qc_ActDrive%.dat
						FileMove, %qc_IndexPathDrv%%qc_IndexFile%%qc_ActDrive%.dat, %qc_IndexTemp%, 1
				}
				Else
				{
					qc_IndexTemp = %qc_IndexPath%\%qc_IndexFile%%qc_ActDrive%.dat ; Dateiname Verzeichnisindex
				}
				IfNotExist, %qc_IndexTemp%
				{
					DriveGet, qc_DriveStatus, Status, %qc_ActDrive%:
					Debug("EXTENSION", A_LineNumber, A_LineFile, "No Index: " qc_IndexTemp " (" qc_DriveStatus ")" )
					If qc_DriveStatus not in Unknown,NotReady,Invalid
					{
						qc_Errors++
						IfInString, qc_LoopField, %A_Space%
							qc_LoopField = "%qc_LoopField%"
						qc_SelectedDrives = %qc_SelectedDrives%,%qc_LoopField%
					}
				}
			}
			If qc_Errors > 0
			{
				StringTrimLeft, qc_SelectedDrives, qc_SelectedDrives,1
				gosub, qc_sub_IndexDrives
				Gui, +OwnDialogs
				MsgBox, 64, %qc_Titel%, %lng_qc_NoIndex%`n%qc_SelectedDrives%
				qc_SelectedDrives =
			}
		}
		else ; ... wenn Fenster existiert ...
		{
			WinActivate, ahk_id %qc_GuiWinID% ; .. in den Vordergrund
		}
	}
Return

qc_tim_WatchWindows:
	If LoadingFinished <> 1
		Return

	DetectHiddenwindows, On
	IfWinNotExist, ahk_id %qc_TargetWindowID%
		Goto, QuickChangeDirGuiClose ; ###

	WinGet, qc_tempID, ID, A

	If (qc_tempID <> qc_GuiWinID AND qc_tempID <> qc_TargetWindowID)
	{
		qc_LastTempID = %qc_tempID%
		Return
	}

	WinGetPos, qc_tmpWinX, qc_tmpWinY, qc_tmpWinW, qc_tmpWinH, ahk_id %qc_GuiWinID%
	WinGetPos, qc_TargetWinX, qc_TargetWinY, qc_TargetWinW, qc_TargetWinH, ahk_id %qc_TargetWindowID%
	WinGet, qc_TargetMax, MinMax, ahk_id %qc_TargetWindowID%

	If (qc_TargetWinX = qc_TargetWinY AND qc_TargetWinX > WorkAreaRight AND qc_TargetWinY > WorkAreaBottom)
		Goto, QuickChangeDirGuiClose ; ###

	If (qc_tempID = qc_GuiWinID)
	{
		qc_WinX := qc_tmpWinX-(qc_TargetWinW-qc_tmpWinW) /2
		qc_WinY := qc_tmpWinY-qc_winYDistance

		If ((qc_tmpWinX <> qc_StartX OR qc_tmpWinY <> qc_StartY OR qc_tmpWinH <> qc_StartH OR qc_tmpWinW <> qc_StartW) AND qc_TargetMax = 0 AND qc_WindowDocking = 1 AND qc_DoDocking = 1)
		{
			WinMove, ahk_id %qc_TargetWindowID%,, %qc_WinX%, %qc_WinY%
		}
		If (qc_LastTempID <> qc_GuiWinID AND qc_LastTempID <> qc_TargetWindowID)
		{
			WinSet, AlwaysOnTop, Toggle, ahk_id %qc_TargetWindowID%
			WinSet, AlwaysOnTop, Toggle, ahk_id %qc_TargetWindowID%
			WinSet, AlwaysOnTop, On, ahk_id %qc_GuiWinID%
		}
	}
	If qc_tempID = %qc_TargetWindowID%
	{
		If (qc_TargetWinX = qc_TargetWinY AND qc_TargetWinX > WorkAreaRight AND qc_TargetWinY > WorkAreaBottom)
			Goto, QuickChangeDirGuiClose ; ###

		qc_WinX := qc_TargetWinX + (qc_TargetWinW-qc_tmpWinW)/2
		qc_WinY := qc_TargetWinY + qc_winYDistance

		If (qc_WinX+qc_WinW > WorkAreaWidth)
			qc_WinX := WorkAreaWidth-qc_WinW
		If (qc_WinY+qc_WinH > WorkAreaHeight)
			qc_WinY := WorkAreaHeight-qc_WinH
		If (qc_WinX < WorkAreaLeft)
			qc_WinX := WorkAreaLeft
		If (qc_WinY < WorkAreaTop)
			qc_WinY := WorkAreaTop
		If ((qc_WinX <> qc_LastWinX OR qc_WinY <> qc_lastWinY) AND qc_WindowDocking = 1 AND qc_DoDocking = 1)
			WinMove, ahk_id %qc_GuiWinID%,, %qc_WinX%, %qc_WinY%
		qc_LastWinX = %qc_WinX%
		qc_LastWinY = %qc_WinY%
	}
	qc_StartX = %qc_tmpWinX%
	qc_StartY = %qc_tmpWinY%
	qc_StartH = %qc_tmpWinH%
	qc_StartW = %qc_tmpWinW%
	qc_LastTempID = %qc_tempID%
Return

QuickChangeDirGuiEscape:
QuickChangeDirGuiClose:
	SetTimer, qc_tim_WatchWindows, Off
	qc_Break = 1
	wingetpos qc_newWinX,qc_newWinY,,, %qc_Titel% ; nochmals Fenstermaße ermitteln
	IniWrite, x%qc_newWinX%, %ConfigFile_QuickChangeDir%, Window, SearchWindowX
	IniWrite, y%qc_newWinY%, %ConfigFile_QuickChangeDir%, Window, SearchWindowY
	Gui,%GuiID_QuickChangeDir%:Destroy
	If qc_DoDocking = 1
		IfWinNotActive, ahk_id %qc_TargetWindowID%
			WinActivate, ahk_id %qc_TargetWindowID%
	qc_GUI =
Return

; ---------------------------------------------------------------------
qc_sub_SearchOK: ;    Suchen-Schaltfläche
	wingetpos qc_newWinX,qc_newWinY,,, %qc_Titel% ; nochmals Fenstermaße ermitteln
	IniWrite, x%qc_newWinX%, %ConfigFile_QuickChangeDir%, Window, SearchWindowX
	IniWrite, y%qc_newWinY%, %ConfigFile_QuickChangeDir%, Window, SearchWindowY

	GetKeyState, qc_ctrlState, Ctrl ; Status der Strg-Taste ermitteln
	if qc_ctrlState = U             ; wenn nicht gedruckt
		qc_ctrlState =               ; Statusvariable löschen, damit sie im Ergebnisfenster nochmals abgefragt wird
	Gosub, qc_sub_Result
Return


; ---------------------------------------------------------------------
; -- Ergebnisfenster der Suche ----------------------------------------
; ---------------------------------------------------------------------

; ---------------------------------------------------------------------
qc_sub_Result: ; Unterroutine für die Verzeichnissuche [Suchen-Schaltfläche]
	StringCaseSense, Locale

	SetTimer, qc_tim_WatchWindows, Off
	Gui, %GuiID_QuickChangeDir%:Submit, NoHide  ; Eingaben des Fenster in die Variablen übertragen

	qc_Break =

	GuiControl, %GuiID_QuickChangeDir%:+Disabled, qc_FindString
	;GuiControl, %GuiID_QuickChangeDir%:+Disabled, %lng_Cancel%
	GuiControl, %GuiID_QuickChangeDir%:+Disabled, %lng_qc_Suchen%

	Gui, %GuiID_QuickChangeDir%:Font, C000000 ; Text Rot (#CC0000)
	GuiControl, %GuiID_QuickChangeDir%:Font, qc_StatusMsg

	GuiControl, %GuiID_QuickChangeDir%:, qc_StatusMsg, 0 %lng_qc_Found%

	StringReplace, qc_History, qc_History, %qc_FindString%| ; Doppelter Eintrag in Historie entfernen
	qc_History = %qc_FindString%|%qc_History%               ; Suchbegriffhistorie erweitern
	StringReplace, qc_History, qc_History, ||,|, A
	StringGetPos, qc_HistoryPos, qc_History, |, L%qc_HistoryLength%
	If qc_HistoryPos > 1
		StringLeft, qc_History, qc_History, % qc_HistoryPos+1
	IniWrite, %qc_History%, %ConfigFile_QuickChangeDir%, History, SearchHistory

	; Wenn Suchbegriff länger als ein Zeichen
	if (!FileExist(qc_FindString) OR !(InStr(qc_FindString,"\") OR (InStr(qc_FindString,":") AND StrLen(qc_FindString) = 2)) OR InStr(qc_FindString,"*") )
	{
		qc_NumDirs  = 0      ; Anzahl der gefundenen Verzeichnisse auf 0 setzen

		IniRead, qc_WinW, %ConfigFile_QuickChangeDir%, Window, ResultWindowWidth, 620  ; Fensterbreite
		IniRead, qc_WinH, %ConfigFile_QuickChangeDir%, Window, ResultWindowHeight, 460 ; Fensterhöhe
		If (qc_WinW = "" OR qc_WinW < 10)
			qc_WinW = 620
		If (qc_WinH = "" OR qc_WinH < 10)
			qc_WinH = 460
		If (qc_WindowDocking = 0 OR qc_DoDocking = 0)
		{
			IniRead, qc_WinX, %ConfigFile_QuickChangeDir%, Window, ResultWindowX, %A_Space%  ; Fenster X
			IniRead, qc_WinY, %ConfigFile_QuickChangeDir%, Window, ResultWindowY, %A_Space% ; Fenster Y
		}
		Else
		{
			qc_WinX := qc_TargetWinX + (qc_TargetWinW-qc_WinW-BorderHeight*2)/2
			qc_WinY := qc_TargetWinY + qc_winYDistance

			If (qc_WinX+qc_WinW > WorkAreaWidth)
				qc_WinX := WorkAreaWidth-qc_WinW
			If (qc_WinY+qc_WinH > WorkAreaHeight)
				qc_WinY := WorkAreaHeight-qc_WinH
			If (qc_WinX < WorkAreaLeft)
				qc_WinX := WorkAreaLeft
			If (qc_WinY < WorkAreaTop)
				qc_WinY := WorkAreaTop
			qc_WinX = x%qc_WinX%
			qc_WinY = y%qc_WinY%
		}
		qc_Caption := CaptionHeight-19

		qc_MinW     = 520   ; minimale Fensterbreite
		qc_MinH     = 200   ; minimale Fensterhöhe
		qc_ListY    = 30    ; Y-Position der Ergebnisliste
		qc_ListW    := qc_WinW-20  ; Breite der Ergebnisliste
		qc_ListH    := qc_WinH-90-qc_Caption   ; Höhe der Ergebnisliste
		qc_EditY    := qc_WinH-60   ; Position der Statuszeile
		qc_ButtonY  := qc_WinH-30   ; Y-Position der Schaltflächen
		qc_Button2X := qc_WinW-415   ; X-Position von "Abbrechen"
		qc_Button5X := qc_WinW-305   ; X-Position von "DOS-Box"
		qc_Button3X := qc_WinW-215   ; X-Position von "gleiches Fenster"
		qc_Button4X := qc_WinW-110   ; X-Position von "neues Fenster"

		Gui, %GuiID_QuickChangeDirResults%:Add, Edit, w%qc_ListW% vqc_SearchTheList gqc_sub_SearchTheList

		Gui, %GuiID_QuickChangeDirResults%:Add, ListBox, x10 y%qc_ListY% h%qc_ListH% w%qc_ListW% +HScroll Choose1 vqc_varResults gqc_sub_ResultList ; Ergebnisliste
		qc_AllResults =

		IfInString, qc_FindString, *
		{
			qc_Wildcards = 1
			If (func_StrLeft(qc_FindString,1) <> "*" AND !InStr(func_StrLeft(qc_FindString,2),":") )
				qc_FindStringAdd = *\
		}
		Else
		{
			qc_Wildcards = 0
				qc_FindStringAdd =
		}

		If (InStr(func_StrLeft(qc_FindString,2),":"))
		{
			qc_OnlyOneDrive := func_StrLeft(qc_FindString,2)
			If qc_Wildcards = 0
				StringTrimLeft, qc_FindString, qc_FindString, 2

		}
		Else
			qc_OnlyOneDrive =

		Loop, Parse, qc_PathsToIndex, `, ; alle Laufwerke duchgehen
		{
			If A_LoopField =
				continue

			qc_LoopField := func_Deref(A_LoopField)

			GetKeyState, qc_ESC, Esc
			If (qc_ESC = "D" OR qc_Break = 1)
				break

			qc_ActDrive := qc_func_GetDrive( qc_LoopField ) ; Aktuelles Laufwerk

			If (qc_ActDrive ":" <> qc_OnlyOneDrive AND qc_OnlyOneDrive <> "")
				continue

			if qc_IndexPath =
			{
				qc_IndexPathDrv := qc_func_GetDrive( qc_LoopField, "RealPath" )
				qc_IndexTemp = %qc_IndexPathDrv%%qc_IndexFileRoot%.dat ; Dateiname Verzeichnisindex
			}
			Else
			{
				qc_IndexTemp = %qc_IndexPath%\%qc_IndexFile%%qc_ActDrive%.dat ; Dateiname Verzeichnisindex
			}

			Loop, Read, %qc_IndexTemp%                         ; Verzeichnisindex laden
			{
				qc_LoopReadLine := func_Deref(A_LoopReadLine)
				If (qc_IndexPath = "" AND qc_ActDrive ":" <> func_StrLeft(qc_LoopReadLine,2) )
					qc_LoopReadLine = %qc_ActDrive%:%A_LoopReadLine%
				Else
					qc_LoopReadLine = %qc_LoopReadLine%

				GetKeyState, qc_ESC, Esc
				If (qc_ESC = "D" OR qc_Break = 1)
					break

				SplitPath, qc_LoopReadLine, qc_CheckFile, qc_CheckDir ; Pfad aufteilen
				If qc_Wildcards = 1
				{
					If func_WildcardMatch(qc_LoopReadLine, qc_FindStringAdd qc_FindString)         ; Wenn Suchbegriff vorhanden
					{
						qc_AllResults = %qc_LoopReadLine%`n%qc_AllResults%
						qc_NumDirs++                               ; Anzahl gefundener Verz. erhöhen
					}
				}
				Else
				{
					If qc_CheckFile contains %qc_FindString%         ; Wenn Suchbegriff vorhanden
					{
						qc_AllResults = %qc_LoopReadLine%`n%qc_AllResults%
						qc_NumDirs++                               ; Anzahl gefundener Verz. erhöhen
					}
				}
				If (A_Tickcount > qc_Tickcount+100)
				{
					qc_Tickcount = %A_Tickcount%
					qc_Status++
					If qc_Status = 30
						qc_Status = 1
					StringLeft, qc_AddStatus, qc_Points, %qc_Status%
					GuiControl, %GuiID_QuickChangeDir%:, qc_StatusMsg, %qc_NumDirs% %lng_qc_Found% %qc_AddStatus%
				}
			}
			GuiControl, %GuiID_QuickChangeDirResults%:Choose, qc_varResults, 1             ; erstes Verz. auswählen
		}
		qc_AllResultsRevers = %qc_AllResults%
		qc_Break =
		Sort, qc_AllResults, U
		Sort, qc_AllResultsRevers, R

		StringReplace, qc_AllResultsBox, qc_AllResults, `n, |, A

		GuiControl,%GuiID_QuickChangeDirResults%:,qc_varResults,%qc_AllResultsBox% ; Pfad zum Fenster hinzufügen

		Gui, %GuiID_QuickChangeDir%:Destroy ; Eingabefenster beenden

		; Fenster zeigen, wenn mehr als ein Verz. gefunden
		if qc_NumDirs > 1
		{
			GuiDefault("QuickChangeDirResults", "+Resize +AlwaysOnTop +Lastfound +MinSize" qc_MinW "x" qc_MinH )
			Gosub, sub_BigIcon

			Gui, Add, Edit  ,                            x10             y%qc_EditY%   w%qc_ListW% vStatusBar ReadOnly
			Gui, Font,, Marlett
			Gui, Add, Button, -Wrap gqc_sub_IndexingMenu x10             y%qc_ButtonY% w20        , %lng_qc_Aktualisieren%
			Gui, Font
			Gui, Add, Button, -Wrap gQuickChangeDirResultsGuiClose             x%qc_Button2X% y%qc_ButtonY% w100        , %lng_Cancel%
			Gui, Add, Button, -Wrap gqc_sub_ResultOK2         x%qc_Button3X% y%qc_ButtonY% w100 , %lng_qc_NeuesFenster%
			Gui, Add, Button, -Wrap gqc_sub_ResultOK          x%qc_Button4X% y%qc_ButtonY% w100 Default, %lng_qc_VerzWechseln%
			Gui, Add, Button, -Wrap gqc_sub_ResultOK3         x%qc_Button5X% y%qc_ButtonY% w80 , %lng_qc_DosBox%
			Gui, Show, w%qc_WinW% h%qc_WinH% %qc_WinX% %qc_WinY%, %qc_Titel% - %lng_qc_SucheNach% %qc_FindString%
			qc_GUI = 9
			WinGet, qc_GuiWinID, ID
			qc_LastTempID = %qc_GuiWinID%
			WinGetPos, qc_StartX, qc_StartY, qc_StartW, qc_StartH, ahk_id %qc_GuiWinID%

			SetTimer, qc_tim_WatchWindows, 10

			func_AddMessage(0x100,"qc_sub_Edit1Keys")
			IniRead, qc_varResults, %ConfigFile_QuickChangeDir%, Favourites, % func_Hex(func_StrLower(qc_FindString))
			If qc_varResults <> ERROR
				GuiControl, %GuiID_QuickChangeDirResults%:ChooseString, qc_varResults, %qc_varResults%
		}

		; Wenn nur ein Verzeichnis gefunden, direkt dort hin wechseln
		if qc_NumDirs = 1
		{
			Gui,%GuiID_QuickChangeDirResults%:Destroy                    ; Fenster beenden
			StringTrimRight, qc_varResults, qc_AllResultsBox, 1
			qc_GUI =
			gosub, qc_sub_ResultOK
		}

		; Wenn kein Verzeichnis gefunden, dann Suchfenster wieder aufrufen
		if qc_NumDirs = 0
		{
			Gui,%GuiID_QuickChangeDirResults%:Destroy                    ; Fenster beenden
			WinActivate, ahk_id %qc_TargetWindowID%
			qc_GUI =
			qc_ErrorMsg = %lng_qc_SucheERR%   ; Fehlermeldung setzen
			Gosub, qc_main_QuickChangeDir     ; Suchfenster wieder aufrufen
		}

	}
	Else
	{
		Gui, %GuiID_QuickChangeDir%:Destroy  ; Eingabefenster beenden
		qc_path = %qc_FindString%            ; Pfad setzen
		gosub, qc_sub_ChangeDir              ; Unterroutine um Pfad zu öffnen oder zu wechseln
		qc_ctrlState =                       ; Status der Strg-Taste zurücksetzen
		qc_GUI =
	}
Return

; ---------------------------------------------------------------------
qc_sub_IndexingMenu:    ;    Indizierung von der Ergebnisliste aufrufen
	CoordMode, Menu, Relative
	Menu, QuickChangeDir_Menu, Show
Return

qc_sub_SearchTheList:
	GuiControlGet, qc_SearchTheList, %GuiID_QuickChangeDirResults%:
	GuiControl, %GuiID_QuickChangeDirResults%:+Altsubmit, qc_varResults
	GuiControlGet, qc_varResults, %GuiID_QuickChangeDirResults%:
	GuiControl, %GuiID_QuickChangeDirResults%:-Altsubmit, qc_varResults
	If (StrLen(qc_SearchTheList) < 2)
		qc_varResults = 0
	Loop, Parse, qc_AllResults, `n
	{
		If ( A_Index < qc_varResults)
			continue

		IfInString, A_LoopField, %qc_SearchTheList%
		{
			GuiControl, %GuiID_QuickChangeDirResults%:ChooseString, qc_varResults, %A_LoopField%
			Gosub, qc_sub_ResultList
			break
		}
	}
Return

qc_sub_SearchTheListNext:
	GuiControlGet, qc_SearchTheList, %GuiID_QuickChangeDirResults%:
	GuiControl, %GuiID_QuickChangeDirResults%:+Altsubmit, qc_varResults
	GuiControlGet, qc_varResults
	GuiControl, %GuiID_QuickChangeDirResults%:-Altsubmit, qc_varResults
	Loop, Parse, qc_AllResults, `n
	{
		If A_LoopField =
			continue

		If ( A_Index <= qc_varResults )
			continue

		IfInString, A_LoopField, %qc_SearchTheList%
		{
			GuiControl, %GuiID_QuickChangeDirResults%:ChooseString, qc_varResults, %A_LoopField%
			Gosub, qc_sub_ResultList
			break
		}
	}
Return

qc_sub_SearchTheListPrevious:
	GuiControlGet, qc_SearchTheList, %GuiID_QuickChangeDirResults%:
	GuiControl, %GuiID_QuickChangeDirResults%:+Altsubmit, qc_varResults
	GuiControlGet, qc_varResults
	GuiControl, %GuiID_QuickChangeDirResults%:-Altsubmit, qc_varResults
	test := qc_varResults - 1 "`n"
	Loop, Parse, qc_AllResultsRevers, `n
	{
		If A_LoopField =
			continue
		If ( qc_NumDirs - A_Index >= qc_varResults - 1)
			continue

		IfInString, A_LoopField, %qc_SearchTheList%
		{
			GuiControl, %GuiID_QuickChangeDirResults%:ChooseString, qc_varResults, %A_LoopField%
			Gosub, qc_sub_ResultList
			break
		}
	}
Return


qc_sub_Edit1Keys:
	qc_Key = %#wParam%
	If (A_GuiControl <> "qc_SearchTheList" AND A_GuiControl <> "qc_varResults")
		return

	GetKeyState, qc_CtrlStateTmp, Ctrl
	If qc_CtrlStateTmp = D
		qc_Key := qc_Key + 1000
	GetKeyState, qc_ShiftState, Shift
	If qc_ShiftState = D
		qc_Key := qc_Key + 2000
	GetKeyState, qc_AltState, Alt
	If qc_AltState = D
		qc_Key := qc_Key + 4000

	If A_GuiControl <> qc_SearchTheList
	{
		GuiControl, %GuiID_QuickChangeDirResults%:Focus, qc_SearchTheList
		SetFormat, integer, hex
		qc_KeyHex := qc_Key+0
		SetFormat, integer, d

		If (qc_Key < 1000)
			Send, {vk%qc_KeyHex%}
	}

	;tooltip, %qc_Key%

	If qc_Key = 33
	{
		ControlSend,ListBox1,{PgUp}, A
		#Return = 0
	}
	If qc_Key = 34
	{
		ControlSend,ListBox1,{PgDn}, A
		#Return = 0
	}
	If qc_Key = 1035
	{
		ControlSend,ListBox1,{End}, A
		#Return = 0
	}
	If qc_Key = 1036
	{
		ControlSend,ListBox1,{Home}, A
		#Return = 0
	}
	If qc_Key = 40
	{
		ControlSend,ListBox1,{Down}, A
		#Return = 0
	}
	If qc_Key = 38
	{
		ControlSend,ListBox1,{Up}, A
		#Return = 0
	}

	If qc_Key = 1040
	{
		Gosub, qc_sub_SearchTheListNext
		#Return = 0
	}
	If qc_Key = 1038
	{
		Gosub, qc_sub_SearchTheListPrevious
		#Return = 0
	}
	If qc_Key = 1008
	{
		Send,+^{Left}{Del}
		#Return = 0
	}
Return

; ---------------------------------------------------------------------
QuickChangeDirResultsGuiSize: ;    Fenstergrößen-Überwachung
; sorgt dafür, dass beim Vergrößern des Sucherergebnisfensters die Schaltflächen
; und die Ergebnisliste mit angepasst werden
	Critical

	wingetpos qc_newWinX,qc_newWinY,qc_newWinW,qc_newWinH, ahk_id %qc_GuiWinID% ; Fenstermaße ermitteln

	qc_TitleH := CaptionHeight+BorderHeight*2

	; Differenz des veränderten Fensters zu der Originalgröße errechnen
	qc_DiffH := qc_newWinH-qc_TitleH-qc_WinH

	qc_DiffW := qc_newWinW-BorderHeight*2-qc_WinW

	if (qc_DiffW = qc_lastDiffW AND qc_DiffH = qc_lastDiffH)
		return

	qc_lastDiffW = %qc_DiffW%
	qc_lastDiffH = %qc_DiffH%

	; Neue Positionen und Größen berechnen
	qc_newListW    :=  qc_ListW+qc_DiffW
	qc_newListH    :=  qc_ListH+qc_DiffH
	qc_newEditY    :=  qc_EditY+qc_DiffH
	qc_newButtonY  :=  qc_ButtonY+qc_DiffH
	qc_newButton2X :=  qc_Button2X+qc_DiffW
	qc_newButton3X :=  qc_Button3X+qc_DiffW
	qc_newButton4X :=  qc_Button4X+qc_DiffW
	qc_newButton5X :=  qc_Button5X+qc_DiffW

	; Fensterelemente anpassen
	Gui, %GuiID_QuickChangeDirResults%:Default
	GuiControl, move, Edit1,                                      w%qc_newListW%
	GuiControl, move, ListBox1,                  y%qc_ListY%      w%qc_newListW% h%qc_newListH%
	GuiControl, move, Edit2,                     y%qc_newEditY%   w%qc_newListW%
	GuiControl, move, Button1,                   y%qc_newButtonY%
	GuiControl, move, Button2, x%qc_newButton2X% y%qc_newButtonY%
	GuiControl, move, Button3, x%qc_newButton3X% y%qc_newButtonY%
	GuiControl, move, Button4, x%qc_newButton4X% y%qc_newButtonY%
	GuiControl, move, Button5, x%qc_newButton5X% y%qc_newButtonY%

	SetTimer, qc_tim_SizeSaveChanges, 5

	Gosub, qc_tim_WatchWindows
Return

qc_tim_SizeSaveChanges:
	SetTimer, qc_tim_SizeSaveChanges, Off
	IniWrite, %qc_newWinW%, %ConfigFile_QuickChangeDir%, Window, ResultWindowWidth
	IniWrite, %qc_newWinH%, %ConfigFile_QuickChangeDir%, Window, ResultWindowHeight
Return

; ---------------------------------------------------------------------
qc_sub_ResultOK: ;    Verzeichnis wechseln (OK-Schaltfläche)
	SetTimer, qc_tim_WatchWindows, Off
	if qc_NumDirs > 1
	{
		wingetpos qc_newWinX,qc_newWinY,,, %qc_Titel% ; nochmals Fenstermaße ermitteln
		IniWrite, x%qc_newWinX%, %ConfigFile_QuickChangeDir%, Window, ResultWindowX
		IniWrite, y%qc_newWinY%, %ConfigFile_QuickChangeDir%, Window, ResultWindowY
		SetTimer, qc_tim_WatchWindows, Off
		Gui, %GuiID_QuickChangeDirResults%:Submit
		Gui, %GuiID_QuickChangeDirResults%:Destroy
		WinActivate, ahk_id %qc_TargetWindowID%
	}

	func_RemoveMessage(0x100,"qc_sub_Edit1Keys")
	qc_GUI =

	IfExist,%qc_varResults% ; nur wechslen wenn Verzeichnis existiert
	{
		If qc_ctrlState =
			GetKeyState, qc_ctrlState, Ctrl ; Status der Strg-Taste ermitteln
		If qc_ctrlState = U
			qc_ctrlState =

		IniWrite, %qc_varResults%, %ConfigFile_QuickChangeDir%, Favourites, % func_Hex(func_StrLower(qc_FindString))
		qc_path = %qc_varResults%
		gosub, qc_sub_ChangeDir
		qc_ctrlState =
	}
	Else
		BalloonTip(qc_ScriptName " v" qc_ScriptVersion, lng_FolderDoesNotExist "`n" qc_varResults, "Info")
return

; ---------------------------------------------------------------------
qc_sub_ResultOK2: ;    neues Explorer-Fenster (Explorer-Schaltfläche)
	qc_GUI =
	qc_ctrlState = D   ; gedrückte Strg-Taste vortäuschen
	gosub, qc_sub_ResultOK
Return

; ---------------------------------------------------------------------
qc_sub_ResultOK3: ;    DOS-Fenster
	SetTimer, qc_tim_WatchWindows, Off
	wingetpos qc_newWinX,qc_newWinY,,, %qc_Titel% ; nochmals Fenstermaße ermitteln
	IniWrite, x%qc_newWinX%, %ConfigFile_QuickChangeDir%, Window, ResultWindowX
	IniWrite, y%qc_newWinY%, %ConfigFile_QuickChangeDir%, Window, ResultWindowY

	Gui, %GuiID_QuickChangeDirResults%:Submit
	Gui, %GuiID_QuickChangeDirResults%:Destroy
	WinActivate, ahk_id %qc_TargetWindowID%
	func_RemoveMessage(0x100,"qc_sub_Edit1Keys")
	qc_GUI =

	IfExist,%qc_varResults% ; nur wechseln wenn Verzeichnis existiert
	{
		StringSplit,qc_splittedpath,qc_varResults,:,,
		Run, %ComSpec% /K %qc_splittedpath1%: && cd "%qc_splittedpath2%",,UseErrorLevel
		If ErrorLevel = ERROR
			func_GetErrorMessage( A_LastError, qc_ScriptName, A_Quote qc_splittedpath1 ":\" qc_splittedpath2 A_Quote "`n`n" )
		qc_ctrlState =
	}
Return

; ---------------------------------------------------------------------
QuickChangeDirResultsGuiEscape: ;    Abbrechen/ESC beider Fenster (Eingabe und Ergebnisfenster)
QuickChangeDirResultsGuiClose:  ;    Abbrechen/ESC beider Fenster (Eingabe und Ergebnisfenster)
	SetTimer, qc_tim_WatchWindows, Off
	qc_GUI =
	wingetpos qc_newWinX,qc_newWinY,,, %qc_Titel% ; nochmals Fenstermaße ermitteln
	IniWrite, x%qc_newWinX%, %ConfigFile_QuickChangeDir%, Window, ResultWindowX
	IniWrite, y%qc_newWinY%, %ConfigFile_QuickChangeDir%, Window, ResultWindowY
	Gui, %GuiID_QuickChangeDirResults%:Destroy            ; Fenster schließen
	If qc_DoDocking = 1
		IfWinNotActive, ahk_id %qc_TargetWindowID%
			WinActivate, ahk_id %qc_TargetWindowID%
Return

; ---------------------------------------------------------------------
qc_sub_ResultList: ;    Klick auf Ergebnisliste

	; Statuszeile mit dem Namen ohne Pfad setzen
	GuiControlGet, qc_ListLine,%GuiID_QuickChangeDirResults%:,qc_varResults
	SplitPath,qc_ListLine,qc_FName,qc_FDir
	GuiControl, %GuiID_QuickChangeDirResults%:,StatusBar,%qc_FName%

	; Bei Doppelklick "neues Fenster" ausführen
	if A_GuiControlEvent = DoubleClick
		gosub, qc_sub_ResultOK
return

; Kontextmenü der Ergebnisliste
QuickChangeDirResultsGuiContextMenu: ; HotkeyDef
	IfWinActive, %qc_Titel%    ; nur wenn Fenster aktiv
	{
		MouseGetPos,,,,qc_MouseControl  ; Control unter Maus ermitteln
		if qc_MouseControl = ListBox1   ; Wenn Control Ergebnisliste ...
		{
			; ... dann Kontextmenü aufbauen
			Send, {LButton} ; An Mauspositoin einen Klick ausführen, damit die Zeile markiert wird
			Menu, context, add, %lng_qc_NeuesFenster%, qc_sub_ResultOK
			Menu, context, add, %lng_qc_VerzWechseln%, qc_sub_ResultOK2
			Menu, context, add, %lng_qc_DosBox%, qc_sub_ResultOK3
			Menu, context, add
			Menu, context, add, %lng_qc_AusIndexEntf%, qc_menu_DeleteEntry
			Menu, context, add, %lng_qc_ÜberVerzHinzu%, qc_sub_AddParent
			Menu, context, show
			Menu, context, DeleteAll
		}
	 }
Return

; ---------------------------------------------------------------------
qc_menu_DeleteEntry: ;    Menüpunkt Eintrag aus der Verzeichnisindex entfernen

	GuiControlGet, qc_ListLine,%GuiID_QuickChangeDirResults%:,qc_varResults ; aktuelle Zeile ermitteln
	gosub, qc_sub_DeleteEntry
Return

; ---------------------------------------------------------------------
qc_sub_AddParent: ;    Menüpunkt Überverzeichnis zur Liste hinzufügen

	GuiControlGet, qc_ListLine,%GuiID_QuickChangeDirResults%:,qc_varResults
	SplitPath, qc_ListLine,,qc_ListLine
	GuiControl, %GuiID_QuickChangeDirResults%:Choose, qc_varResults, 1
	GuiControl, %GuiID_QuickChangeDirResults%:ChooseString, qc_varResults, %qc_ListLine%
	GuiControlGet, SelLine,%GuiID_QuickChangeDirResults%:,qc_varResults
	if qc_ListLine  <> %SelLine%
		GuiControl,%GuiID_QuickChangeDirResults%:, qc_varResults, %qc_ListLine%
	GuiControl, %GuiID_QuickChangeDirResults%:ChooseString, qc_varResults, %qc_ListLine%
	WinActivate, %qc_Titel%
Return

; ---------------------------------------------------------------------
qc_sub_DeleteEntry: ;    Unterroutine für Eintrag aus der Verzeichnisindex entfernen

	; Schaltflächen deaktivieren
	GuiControl, %GuiID_QuickChangeDirResults%:Disable, Button1
	GuiControl, %GuiID_QuickChangeDirResults%:Disable, Button2
	GuiControl, %GuiID_QuickChangeDirResults%:Disable, Button3
	GuiControl, %GuiID_QuickChangeDirResults%:Disable, Button4
	GuiControl, %GuiID_QuickChangeDirResults%:Disable, ListBox1

	qc_ActDrive := qc_func_GetDrive( qc_ListLine ) ; Laufwerksbuchstabe des ausgewählten Pfads
	if qc_IndexPath =
	{
		qc_IndexPathDrv := qc_func_GetDrive( qc_ListLine, "RealPath" )
		qc_IndexTemp = %qc_IndexPathDrv%%qc_IndexFileRoot%_tmp.dat ; Temporärer Index
		qc_IndexDest = %qc_IndexPathDrv%%qc_IndexFileRoot%.dat ; Verzeichnisindex
	}
	Else
	{
		qc_IndexTemp = %qc_IndexPath%\%qc_IndexFile%%qc_ActDrive%_tmp.dat ; Temporärer Index
		qc_IndexDest = %qc_IndexPath%\%qc_IndexFile%%qc_ActDrive%.dat ; Verzeichnisindex
	}
	GuiControl,%GuiID_QuickChangeDirResults%:+AltSubmit,qc_varResults ; ... damit nicht der Name, sondern die ListenNr ermittelt wird

	Loop, Read, %qc_IndexDest%   ; Verzeichnisindex laden
	{
		StringLen,qc_Len,qc_ListLine                       ; Länge des ausgewählten Pfads
		StringLeft, qc_MatchLine, A_LoopReadLine, %qc_Len% ; geladener Eintrag aus Verzeichnisindex kürzen

		If qc_MatchLine <> %qc_ListLine%                   ; Wenn ausgewählter Pfad <> geladener Eintrag
		{
			FileAppend, %A_LoopReadLine%`n, %qc_IndexTemp%   ; ... wieder in Verzeichnisindex schreiben
		}
		else                                                 ; ... sonst nicht schreiben ...
		{
			GuiControl,%GuiID_QuickChangeDirResults%:ChooseString,qc_varResults, %A_LoopReadLine% ; Eintrag in Ergebnisliste auswählen
			GuiControlGet,qc_ListN,%GuiID_QuickChangeDirResults%:,qc_varResults                  ; ListenNr ermitteln
			Control, Delete, %qc_ListN%, ListBox1, %qc_Titel%      ; Eintrag löschen
		}
	}
	GuiControl,%GuiID_QuickChangeDirResults%:-AltSubmit,qc_varResults         ; ... damit wieder der Name von Listenelementen ermittelt wird
	FileMove, %qc_IndexTemp%, %qc_IndexDest%,1 ; Verzeichnisindex durch temporären Index ersetzen

	; Schaltfläche wieder aktivieren
	GuiControl, %GuiID_QuickChangeDirResults%:Enable, Button1
	GuiControl, %GuiID_QuickChangeDirResults%:Enable, Button2
	GuiControl, %GuiID_QuickChangeDirResults%:Enable, Button3
	GuiControl, %GuiID_QuickChangeDirResults%:Enable, Button4
	GuiControl, %GuiID_QuickChangeDirResults%:Enable, ListBox1
	GuiControl, %GuiID_QuickChangeDirResults%:Focus , ListBox1
Return


; ---------------------------------------------------------------------
; -- Laufwerke indizieren ---------------------------------------------
; ---------------------------------------------------------------------
qc_sub_IndexDrivesWait:
	qc_RunWait = 1
	Gosub, qc_sub_IndexDrives
Return

qc_sub_IndexDrives: ; Laufwerke indizieren
	DetectHiddenwindows,On
	SetTitleMatchMode, 2
	IfWinExist, ac'tivAid_QuickChangeDir Indexer.
		IfWinNotActive, MED -
			return

	IfInString, qc_selectedDrives, %A_Space%
		IfNotInString, qc_selectedDrives, "
		{
		; " ; end qoute for syntax highlighting
			qc_selectedDrives = "%qc_selectedDrives%"
		}

	If qc_selectedDrives =
		qc_selectedDrives = ""

	If A_IsCompiled = 1
	{
		IfExist %A_ScriptDir%\extensions\ac'tivAid_QuickChangeDir Indexer.exe
		{
			If qc_RunWait = 1
				RunWait, "%A_ScriptDir%\extensions\ac'tivAid_QuickChangeDir Indexer.exe" %qc_selectedDrives% %qc_VariableDriveLetter%%qc_tmpNoBallon%, %A_WorkingDir%,,UseErrorLevel
			Else
				Run, "%A_ScriptDir%\extensions\ac'tivAid_QuickChangeDir Indexer.exe" %qc_selectedDrives% %qc_VariableDriveLetter%%qc_tmpNoBallon%, %A_WorkingDir%,,UseErrorLevel
			If ErrorLevel = ERROR
				func_GetErrorMessage( A_LastError, qc_ScriptName, A_Quote qc_splittedpath1 ":\" qc_splittedpath2 A_Quote "`n`n" )
		}
		Else IfExist %A_AhkPath%
			IfExist %A_ScriptDir%\extensions\ac'tivAid_QuickChangeDir Indexer.ahk
			{
				If qc_RunWait = 1
					RunWait, %A_AhkPath% "%A_ScriptDir%\extensions\ac'tivAid_QuickChangeDir Indexer.ahk" %qc_selectedDrives% %qc_VariableDriveLetter%%qc_tmpNoBallon%, %A_WorkingDir%,,UseErrorLevel
				Else
					Run, %A_AhkPath% "%A_ScriptDir%\extensions\ac'tivAid_QuickChangeDir Indexer.ahk" %qc_selectedDrives% %qc_VariableDriveLetter%%qc_tmpNoBallon%, %A_WorkingDir%,,UseErrorLevel
				If ErrorLevel = ERROR
					func_GetErrorMessage( A_LastError, qc_ScriptName, A_Quote qc_splittedpath1 ":\" qc_splittedpath2 A_Quote "`n`n" )
			}
			Else
				BalloonTip(ScriptTitle " - " qc_ScriptName, lng_qc_NoIndexer ,"Error")
		Else
			BalloonTip(ScriptTitle " - " qc_ScriptName, lng_qc_NoIndexer ,"Error")
	}
	Else
	{
		IfExist %A_ScriptDir%\extensions\ac'tivAid_QuickChangeDir Indexer.ahk
		{
			If qc_RunWait = 1
				RunWait, %A_AhkPath% "%A_ScriptDir%\extensions\ac'tivAid_QuickChangeDir Indexer.ahk" %qc_selectedDrives% %qc_VariableDriveLetter%%qc_tmpNoBallon%, %A_WorkingDir%,,UseErrorLevel
			Else
				Run, %A_AhkPath% "%A_ScriptDir%\extensions\ac'tivAid_QuickChangeDir Indexer.ahk" %qc_selectedDrives% %qc_VariableDriveLetter%%qc_tmpNoBallon%, %A_WorkingDir%,,UseErrorLevel
			If ErrorLevel = ERROR
				func_GetErrorMessage( A_LastError, qc_ScriptName, A_Quote qc_splittedpath1 ":\" qc_splittedpath2 A_Quote "`n`n" )
		}
		Else
			BalloonTip(ScriptTitle " - " qc_ScriptName, lng_qc_NoIndexer ,"Error")
	}
	Sleep,100
	qc_LastTimeIndexed := A_Now
	IniWrite, %qc_LastTimeIndexed% , %ConfigFile_QuickChangeDir%, Schedule, LastTimeIndexed
	qc_tmpNoBallon =
	qc_RunWait =
Return

; ---------------------------------------------------------------------
qc_submenu_IndexDrives: ; Laufwerke indizieren:Aufruf vom Untermenü
	if A_ThisMenuItem = %lng_qc_AktualisierenAlle%
	{
		qc_selectedDrives =
	}
	else
	{
		StringReplace, qc_GetDriveLtr, lng_qc_AktualisierenEinzeln, ###,,
		StringReplace, qc_selectedDrives, A_ThisMenuItem, %qc_GetDriveLtr%,
		StringTrimRight, qc_selectedDrives, qc_selectedDrives, 1
	}
	gosub, qc_sub_IndexDrives
Return


; ---------------------------------------------------------------------
; -- Unterroutine für den Verzeichniswechsel --------------------------
; ---------------------------------------------------------------------
qc_sub_ChangeDir: ; Unterroutine für den Verzeichniswechsel
	Sleep,50

	If qc_ctrlState =
		qc_NewWindow = -1
	Else
		qc_NewWindow = 1

	func_ChangeDir(qc_Path,qc_NewWindow,qc_FolderTree)
Return

qc_tim_AutoIndexing:
	Critical
	DetectHiddenwindows,On
	SetTitleMatchMode, 2
	IfWinExist, ac'tivAid_QuickChangeDir Indexer
		return

	If qc_AutoIndexingSpace = 1
	{
		Loop, Parse, qc_PathsToIndex, `,
		{
			If A_LoopField =
				break
			qc_LoopFlied := func_Deref(A_LoopField)
			qc_ActDrive := qc_func_GetDrive( qc_LoopField ) ; Aktuelles Laufwerk
			IniRead, qc_DriveSpace, %ConfigFile_QuickChangeDir%, Drives, %qc_ActDrive%, -1
			DriveSpaceFree, qc_actSpace, % qc_func_GetDrive( qc_LoopField, "RealPath" )
			If (qc_actSpace <> qc_LastActSpace_%qc_ActDrive%)
			{
				qc_LastActSpace_%qc_ActDrive% := qc_actSpace
				continue
			}
			qc_LastActSpace_%qc_ActDrive% := qc_actSpace

			If (qc_actSpace > qc_DriveSpace)
				qc_Diff := qc_actSpace-qc_DriveSpace
			Else
				qc_Diff := qc_DriveSpace-qc_actSpace

			If (qc_Diff > qc_IndexThreshold OR qc_DriveSpace = "ERROR" )
			{
				qc_selectedDrives = % qc_func_GetDrive( qc_LoopField, "RealPath" )
				IniWrite, %qc_actSpace%, %ConfigFile_QuickChangeDir%, Drives, %qc_ActDrive%
				qc_tmpNoBallon := " NoBalloonTips"
				Gosub, qc_sub_IndexDrives
				break
			}
		}
	}
	qc_Next =
	If qc_AutoIndexingTime = 1
	{
		If (qc_NextIndexing < qc_LastTimeIndexed AND qc_AutoIndexingTimeFailure = 1)
		{
			qc_selectedDrives =
			Gosub, qc_sub_IndexDrives
			qc_Next = 2
		}
		StringSplit, qc_Time, qc_IndexTimeValues, `,
		Loop, %qc_Time0%
		{
			StringReplace, qc_Time, qc_Time%A_Index%, :,
			qc_Now := A_Hour A_Min A_Sec
			If (qc_Next = 2 AND qc_Now < qc_Time)
			{
				qc_NextIndexing := A_YYYY A_MM A_DD qc_Time
				IniWrite, %qc_NextIndexing%, %ConfigFile_QuickChangeDir%, Schedule, NextIndexing
				qc_Next =
				break
			}
			If (qc_Now = qc_Time)
			{
				qc_selectedDrives =
				Gosub, qc_sub_IndexDrives
				qc_Next = 1
			}
			If qc_Next = 1
			{
				qc_NextIndexing := A_YYYY A_MM A_DD qc_Time
				IniWrite, %qc_NextIndexing%, %ConfigFile_QuickChangeDir%, Schedule, NextIndexing
				qc_Next =
				break
			}
		}
		If qc_Next <>
		{
			qc_NextIndexing := A_YYYY A_MM A_DD qc_Time
			EnvAdd, qc_NextIndexing, 1, Days
			qc_NextIndexing := func_StrLeft(qc_NextIndexing, 12)
			IniWrite, %qc_NextIndexing%, %ConfigFile_QuickChangeDir%, Schedule, NextIndexing
			qc_Next =
		}
	}
	If qc_AutoIndexingInterval = 1
	{
		StringSplit, qc_Time, qc_IndexInterval, :,
		qc_Time := qc_Time1*60+qc_Time2
		qc_Diff := A_Now
		EnvSub, qc_Diff, qc_LastTimeIndexed , Min
		If ( qc_Diff >= qc_Time)
		{
			qc_selectedDrives =
			Gosub, qc_sub_IndexDrives
		}
	}

Return

qc_func_GetDrive( Path, RealPath = "" ) {
	StringLeft, Drive, Path, 1
	If Drive = \
	{
		StringSplit, Path, Path, \
		If RealPath = RealPath
			Drive = \\%Path3%\%Path4%\
		Else
			Drive := func_StrTranslate(Path3 "#" Path4, "-+ §!&()'", "______[]_")
	}
	Else If RealPath = RealPath
		Drive = %Drive%:\

	Return %Drive%
}
