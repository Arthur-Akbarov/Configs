; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               AppLauncher
; -----------------------------------------------------------------------------
; Prefix:             al_
; Version:            1.0
; Date:               2008-05-07
; Author:             Patrick Eder (skydive241@gmx.de)
;                     Wolfgang Reszel
;                     Michael Telgkamp
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_AppLauncher:
	; Programmname und Version
	Prefix = al
	%Prefix%_ScriptName      = AppLauncher
	%Prefix%_ScriptVersion   = 1.0
	%Prefix%_Author          = Patrick Eder, Wolfgang Reszel, Michael Telgkamp
	%Prefix%_Titel           = %al_ScriptName% v%al_ScriptVersion%

	al_RequiredIndexVersion  = 0.9

	CustomHotkey_AppLauncher = 1
	Hotkey_AppLauncher       = ^!Space
	HotkeyPrefix_AppLauncher =
	ConfigFile_AppLauncher   = settings\AppLauncher.ini
	IconFile_On_AppLauncher  = %A_WinDir%\system32\shell32.dll
	IconPos_On_AppLauncher   = 25

	CreateGuiID("AppLauncherMain")
	CreateGuiID("AppLauncherAdditionals")

	al_sfi_size = 352  ; Structure size of SHFILEINFO.
	VarSetCapacity(al_sfi, al_sfi_size)

	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                        = %al_ScriptName% - Ausführen von Startmenü-Einträgen
		Description                     = Schnelles Ausführen von Startmenü-Einträgen durch Eingabe eines Teils des Programmnamens.
		lng_al_SuchEingabe              = Suchbegriff eingeben:
		lng_al_Open                     = &Ausführen
		lng_al_UpdateIndex              = 8
		lng_al_scanning                 = Verzeichnisse werden indexiert ...
		lng_al_IncludeHiddenFiles       = Auch versteckte Dateien indexieren
		lng_al_AddToIndexList           = Verzeichnisse, die indexiert werden:
		lng_al_AlwaysScan               = Verzeichnisse, die immer dynamisch indexiert werden:
		lng_al_IndexPath                = Verzeichnis, in dem die Indexdatei abgelegt wird (leer = %SettingsDir%\%al_ScriptName%):
		lng_al_ExcludeList              = Dateien, die diese Strings enthalten, aus dem Index ausschließen:
		lng_al_TypeList                 = Dateien mit diesen Erweiterungen in die Suche einbeziehen`n(bei Verknüpfungen wird das Verknüpfungsziel berücksichtigt):
		lng_al_NoIndex                  = Es wurde noch kein Verzeichnisindex angelegt, die Suche funktioniert, nachdem die Indexierung beendet wurde.
		lng_al_NoIndex1                 = Der Verzeichnisindex muss wegen einer Aktualisierung neu angelegt werden.`nDie Suche funktioniert, nachdem die Indexierung beendet wurde.
		lng_al_ShowActivaidCommands     = Befehle und Funktionen von ac'tivAid im AppLauncher anzeigen
		tooltip_al_ShowShowActivaidCommands= aus: keine Befehle und Funktionen, an: alle Befehle und Funktionen, gray/green: Nur Konfiguration
		lng_al_OpenIndexPath            = Öffnen
		lng_al_Name                     = Name
		lng_al_Ext                      = Erw
		lng_al_Folder                   = Verzeichnis
		lng_al_Date                     = Datum
		lng_al_ShowIcons                = Icons in der Liste anzeigen
		lng_al_ShowLinkTarget           = Ziel von Verknüpfungen anzeigen (ungenau)
		lng_al_NumberOfHistory          = Anzahl anzuzeigender Verlauf-Einträge
		lng_al_NumberMaxHits            = Anzahl anzuzeigender Treffer
		lng_al_MoreOptions              = Infobereich
		lng_al_SearchOptions            = Sucheinstellungen
		lng_al_SearchFromBeginning      = Nur am Wortanfang suchen
		lng_al_PhoneticSearch           = Immer auch ähnliche Begriffe suchen
		lng_al_FilterDuplicates         = Duplikate ausfiltern (Namensgleichheit)
		lng_al_MoreListOptions          = Listeneinstellungen
		lng_al_ListOnTop                = Ergebnisliste über dem Suchfeld anzeigen
		lng_al_HistWithCtrl             = Nur zum Verlauf hinzufügen, wenn STRG gedrückt gehalten wird
		lng_al_ModifyColumns            = Spaltenbreite automatisch anpassen
		lng_al_Header                   = Liste mit Spaltenköpfen
		lng_al_Grid                     = Liste mit Gitternetz
		lng_al_SortResult               = Suchergebnis sortieren
		lng_al_ShowDate                 = Änderungsdatum anzeigen
		lng_al_ShowBigIcons             = Icons neben der Sucheingabe anzeigen
		lng_al_IconsWithAPI             = Icons mit Win32-API ermitteln
		lng_al_IndexFolders             = Ordnerverknüpfungen mit einbeziehen
		lng_al_IndexFolderNames         = Ordnernamen mit indexieren
		lng_al_sub_IndexToHistory       = Gesamten Index in den Verlauf übertragen
		lng_al_IndexToHistoryDone       = Der komplette Index wurde nun in den Verlauf geladen.`nSoll die Anzahl der anzuzeigenden Verlauf-Einträge angepasst werden?
		lng_al_CloseNoFocus             = AppLauncher schließen, wenn ein anderes Fenster aktiviert wird
		lng_al_SimpleView               = Vereinfachte Darstellung
		lng_al_sub_Additionals          = Erweiterte Einstellungen
		lng_al_ClearHistory             = Verlauf löschen
		lng_al_CorruptRegistry          = Die Registry enthält ungewöhnliche Einträge für Verknüpfungen.`nEs ist sehr wahrscheinlich, dass AppLauncher keine Anwendungen starten kann.
		lng_al_sub_RepairRegistry       = Registry-Eintrag für Verknüpfungen reparieren
		lng_al_AskRepairRegistry        = Der Registry-Eintrag für Verknüpfungen (LNK-Dateien) wird nun mit Standardwerten repariert.`nDie Standardwerte wurden anhand einer frischen Installation von Windows XP ermittelt.`nDie Reparatur geschieht auf eigene Gefahr und erfordert Admin-Rechte!
		lng_al_RegistryRepaired         = Die Registry-Einträge wurden mit den Standardwerten repariert.`nAppLauncher sollte nun wieder in der Lage sein, Anwendungen auszuführen.
		lng_al_runningError             = Verknüpfung/Befehl kann nicht ausgeführt werden:
		lng_al_ReducedSimpleView        = Bei der vereinfachten Darstellung zu Beginn nur das Suchfeld zeigen
		tooltip_b                       = Index aktualisieren
		tooltip_al_ModifyColumns        = Aus = Die Spaltenbreiten werden nicht automatisch angepasst`nAktiviert = Die Spaltenbreiten passen sich den Inhalten an`nGrau/Grün = Die Spaltenbreiten passen sich der Fenstergröße an
		tooltip_al_Header               = Aus = Die Liste wird ohne Spaltenköpfe angezeigt`nAktiviert = Die Spaltenköpfe können zum Sortieren verwendet werden`nGrau/Grün = Die Spaltenköpfe werden angezeigt, aber nicht zum Sortieren verwendet
		tooltip_al_HistWithCtrl         = An = Das ausgeführte Programm wird der History-Liste nur zugefügt, wenn die STRG-Taste gedrückt war`nAus = Jedes ausgeführte Programm wird der History-Liste zugefügt
		lng_al_AutoIndexing             = Automatische Indexierung im Hintergrund
		lng_al_IndexWhenComputerChanges = wenn der Computer gewechselt wurde
		lng_al_Hours                    = Stunden
		lng_al_Settings                 = Konfiguration
		lng_al_RunAs                    = Ausführen als ...
		lng_al_CopyPath                 = Pfad kopieren
		lng_al_CopyLinkPath             = Zielpfad der Verknüpfung kopieren
		lng_al_OpenFolder               = Übergeordnetes Verzeichnis öffnen
		lng_al_OpenWith                 = Mit ### öffnen
		lng_al_Properties               = Eigenschaften ...
		lng_al_AddToUserHotkeys         = Tastaturkürzel in UserHotkeys zuweisen ...
		lng_al_ExcludedFilesExist       = Die Datei %al_ExcludedFilesFile% existiert, in welcher festgelegt wird, welche Pfade nicht indexiert werden sollen.
		lng_al_DelayMessage             = AppLauncher startet verzögert, da Sie Verzeichnisse mit hoher Tiefe dynamisch indexieren lassen. Sie können diesen Hinweis über "Weitere Optionen" abschalten oder Verzeichnisse mit geringerer Tiefe angeben (Erweiterte Einstellungen).
		lng_al_IgnoreDelayMessage       = Hinweis "AppLauncher startet verzögert ..." nicht mehr zeigen
		lng_al_VariableDriveLetter      = Pfad-Variablen im Index verwenden
		lng_al_UseRunAsHelper           = Alternative Methode für "Ausführen als ..." (bei Abstürzen)
		lng_al_ShowWindowAtMousePos     = AppLauncher-Fenster immer an der Mausposition einblenden
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %al_ScriptName% - Start Applications
		Description                   = Fast launch of start-menu entries by typing in a part of if its name.

		lng_al_SuchEingabe            = Search for:
		lng_al_Open                   = &Run
		lng_al_UpdateIndex            = 8
		lng_al_scanning               = Indexing directories ...
		lng_al_IncludeHiddenFiles     = Also index hidden Files

		lng_al_AddToIndexList         = Directories to be indexed:
		lng_al_AlwaysScan             = Directories to get dynamically indexed:
		lng_al_IndexPath              = Directory to store the index-files (empty = %SettingsDir%\%al_ScriptName%):
		lng_al_ExcludeList            = Don't index files with these strings:
		lng_al_TypeList               = Only index files with these file-extensions`n(This will respect the targets of shortcut files):
		lng_al_NoIndex                = No index-files found. You can use the search after the indexing has been finished.
		lng_al_ShowActivaidCommands   = Show ac'tivAid commands and functions in AppLauncher
		tooltip_al_ShowShowActivaidCommands  = off: no commands, on: all commands and functions, gray/green: only configuration
		lng_al_OpenIndexPath          = Open

		lng_al_Name                   = Name
		lng_al_Ext                    = Ext
		lng_al_Folder                 = Directory
		lng_al_Date                   = Date
		lng_al_ShowIcons              = Show icons in List
		lng_al_ShowLinkTarget         = Show target of shortcuts (not accurate)
		lng_al_NumberOfHistory        = Number of history entries
		lng_al_NumberMaxHits          = Number of hits

		lng_al_MoreOptions            = Info area
		lng_al_SearchOptions          = Search settings
		lng_al_SearchFromBeginning    = Only search at the beginning of words
		lng_al_PhoneticSearch         = Always use phonetic search
		lng_al_FilterDuplicates       = Filter duplicate names
		lng_al_MoreListOptions        = List view
		lng_al_ListOnTop              = Result list on top of the search-field
		lng_al_HistWithCtrl           = Add items only to history when CTRL is down while launching
		lng_al_ModifyColumns          = Automatically adjust column width
		lng_al_Header                 = Show table headers
		lng_al_Grid                   = Show table grid
		lng_al_SortResult             = Sort search result
		lng_al_ShowDate               = Show modification date
		lng_al_ShowBigIcons           = Show icon beside the search field
		lng_al_IconsWithAPI           = Detect icons with Win32-API
		lng_al_IndexFolders           = Index folder shortcuts
		lng_al_IndexFolderNames       = Index folders names
		lng_al_sub_IndexToHistory     = Fill history with all programs in index

		lng_al_CloseNoFocus           = Close window if it gets inactive
		lng_al_SimpleView             = Simple view

		lng_al_sub_Additionals        = More settings
		lng_al_ClearHistory           = Clear history

		lng_al_CorruptRegistry        = The registry entry for shortcuts seems to be corrupt.`nProbably AppLauncher will not be able to launch programs.
		lng_al_sub_RepairRegistry     = Repair registry entry for shortcus
		lng_al_AskRepairRegistry      = The registry entry for shortcuts (LNK files) will be repaired with default settings.`nThe default settings have been determined from a fresh install of a german Windows XP.`nConfirm repairing at your own risk. (admin rights needed)
		lng_al_RegistryRepaired       = The registry entry has been repaired.`nAppLauncher should now be able to launch programs.

		lng_al_runningError           = Shortcut/command could not be executed:

		lng_al_ReducedSimpleView      = Initially show only the search field at the simple view

		tooltip_b                     = Update index
		tooltip_al_ModifyColumns      = Off = don't adjust column width`nActive = adjust the column with to the content`nGrey/Green = adjust the column width to the window size
		tooltip_al_Header             = Off = doesn't show table headers`nActive = headers can be used to sort the list`nGrey/Green = show the headers but don't use them for sorting
		tooltip_al_HistWithCtrl       = Active = the launched application will only be added to the history while holding CTRL`nOff = every launched application will be added to the history

		lng_al_AutoIndexing           = Automatic indexing in background
		lng_al_IndexWhenComputerChanges= when the computer has changed
		lng_al_Hours                  = hours
		lng_al_Settings               = Settings

		lng_al_RunAs                  = Run as ...
		lng_al_CopyPath               = Copy path
		lng_al_CopyLinkPath           = Copy target path of the shortcut
		lng_al_OpenFolder             = Open containing Folder
		lng_al_OpenWith               = Open with ###
		lng_al_Properties             = Properties ...
		lng_al_AddToUserHotkeys       = Assign Hotkey with UserHotkeys ...

		lng_al_ExcludedFilesExist     = The File %al_ExcludedFilesFile% exists, which contains the paths not to be indexed.
		lng_al_DelayMessage           = AppLauncher opens delayed, because you let dynamically index deep directories. You can disable this message at "Additional settings" or configure less deep directories to be dynamically indexed (More settings).
		lng_al_IgnoreDelayMessage     = Disable message "AppLauncher opens delayed ..."
		lng_al_VariableDriveLetter    = Use path variable in index
		lng_al_UseRunAsHelper         = Alternative method for "Run as ..." (if it crashes)
		lng_al_ShowWindowAtMousePos   = Show AppLauncher window at mouse position
	}

	al_HiddenIndexing = 0

	If CustomLanguage <>
		gosub, CustomLanguage

	If AHKonUSB = 1
		al_IndexFileComputerName = _%A_ComputerName%

	; Namen der Index-Dateien
	al_IndexFile = %al_ScriptName%
	al_activAidIndexFile = activAidCommands.dat
	al_ExcludedFilesFile = ExcludedFiles.dat
	al_CustomNamesFile = CustomNames.dat

	If AHKonUSB = 1
		IniRead, al_VariableDriveLetter, %ConfigFile_AppLauncher%, Schedule, VariableDriveLetter, 1
	Else
		IniRead, al_VariableDriveLetter, %ConfigFile_AppLauncher%, Schedule, VariableDriveLetter, 0

	IniRead, al_PathsToIndexNoDeref,       %ConfigFile_AppLauncher%, Config,  PathsToIndex
	If (al_PathsToIndexNoDeref = "ERROR" OR al_PathsToIndexNoDeref = "")
	{
		al_PathsToIndex = %A_StartMenu%|%A_StartMenuCommon%|%A_Desktop%|%A_DesktopCommon%
		al_PathsToIndexNoDeref = %al_PathsToIndex%
		If al_VariableDriveLetter = 1
			al_PathsToIndexNoDeref = `%A_StartMenu`%|`%A_StartMenuCommon`%|`%A_Desktop`%|`%A_DesktopCommon`%
	}

	If al_VariableDriveLetter = 1
		If al_PathsToIndexNoDeref = %A_StartMenu%|%A_StartMenuCommon%|%A_Desktop%|%A_DesktopCommon%
			al_PathsToIndexNoDeref = `%A_StartMenu`%|`%A_StartMenuCommon`%|`%A_Desktop`%|`%A_DesktopCommon`%

	al_PathsToIndex := func_Deref(al_PathsToIndexNoDeref)

	IniRead, al_IndexPathNoDeref,          %ConfigFile_AppLauncher%, Config,  IndexPath, %SettingsDir%\%al_ScriptName%
	If (al_IndexPathNoDeref = "ERROR" OR al_IndexPathNoDeref = "")
		al_IndexPath = %SettingsDir%\%al_ScriptName%
	al_IndexPath := func_Deref(al_IndexPathNoDeref)

	If al_IndexPath <>
		IfNotExist, %al_IndexPath%
			FileCreateDir, %al_IndexPath%

	IniRead, al_TypeList,           %ConfigFile_AppLauncher%, Config,  TypeList
	If al_TypeList = ERROR
	{
		EnvGet, PATHEXT, PATHEXT
		If PATHEXT <>
		{
			StringReplace, al_TypeList, PATHEXT, ., , A
			StringReplace, al_TypeList, al_TypeList, `;, | , A
			al_TypeList = lnk|ahk|%al_TypeList%
			StringLower, al_TypeList, al_TypeList
			IfNotInString, al_TypeList, |cpl
				al_TypeList = %al_TypeList%|cpl|msc
			IfNotInString, al_TypeList, |msc
				al_TypeList = %al_TypeList%|msc
		}
		Else
			al_TypeList = lnk|ahk|exe|cpl|msc|url
	}
	al_TypeList_Box = %al_TypeList%

	IniRead, al_ExcludeList,        %ConfigFile_AppLauncher%, Config,  ExcludeList, remove|uninstall|guide|introduction|deinstall|entfernen
	al_ExcludeList_Box = %al_ExcludeList%

	IniRead, al_AlwaysScanNoDeref,         %ConfigFile_AppLauncher%, Config,  AlwaysScan
	If (al_AlwaysScanNoDeref = "ERROR")
		al_AlwaysScanNoDeref =
	al_AlwaysScan := func_Deref(al_AlwaysScanNoDeref)
	al_AlwaysScan_Box  = %al_AlwaysScanNoDeref%

	IniRead, al_MaxHits,            %ConfigFile_AppLauncher%, Config, MaxHits, 25
	IniRead, al_IncludeHiddenFiles, %ConfigFile_AppLauncher%, Config, IncludeHiddenFiles, 0
	IniRead, al_SearchFromBeginning,%ConfigFile_AppLauncher%, Config, SearchFromBeginning, 1
	IniRead, al_PhoneticSearch     ,%ConfigFile_AppLauncher%, Config, PhoneticSearch, 0

	IniRead, al_FilterDuplicates,   %ConfigFile_AppLauncher%, Config, FilterDuplicates, 1
	IniRead, al_ShowIcons,          %ConfigFile_AppLauncher%, Config, ShowIcons, 1
	IniRead, al_ShowLinkTarget,     %ConfigFile_AppLauncher%, Config, ShowLinkTarget, 1
	IniRead, al_ShowBigIcons,       %ConfigFile_AppLauncher%, Config, ShowBigIcons, 1
	IniRead, al_IconsWithAPI,       %ConfigFile_AppLauncher%, Config, IconsWithAPI, 1
	IniRead, al_ModifyColumns,      %ConfigFile_AppLauncher%, Config, ModifyColumns, 0
	IniRead, al_Grid,               %ConfigFile_AppLauncher%, Config, Grid, 0
	IniRead, al_SortResult,         %ConfigFile_AppLauncher%, Config, SortResult, 0
	IniRead, al_Header,             %ConfigFile_AppLauncher%, Config, ListHeader, 1
	IniRead, al_ShowDate,           %ConfigFile_AppLauncher%, Config, ShowDate, 0

	IniRead, al_HistWithCtrl,       %ConfigFile_AppLauncher%, History, HistoryWithCTRL, 0
	IniRead, al_MaxLastUsed,        %ConfigFile_AppLauncher%, History, MaxLastUsed, 20
	IniRead, al_History,            %ConfigFile_AppLauncher%, History, SearchHistory
	If (al_History = "ERROR")
		al_History =

	IniRead, al_IndexFolders,       %ConfigFile_AppLauncher%, Config, IndexFolders, 0
	IniRead, al_ShowActivaidCommands,%ConfigFile_AppLauncher%, Config, ShowActivAidCommands, 1
	IniRead, al_IndexFolderNames    ,%ConfigFile_AppLauncher%, Config, IndexFolderNames, 0

	IniRead, al_ProgressLastMax,       %ConfigFile_AppLauncher%, Config, LastFileCount, 0
	IniRead, al_ProgressLastPathCount, %ConfigFile_AppLauncher%, Config, LastPathCount, 0

	IniRead, al_IndexInterval, %ConfigFile_AppLauncher%, Schedule, IndexInterval, 1:00
	IniRead, al_IndexWhenComputerChanges, %ConfigFile_AppLauncher%, Schedule, IndexWhenComputerChanges, 0
	IniRead, al_AutoIndexing, %ConfigFile_AppLauncher%, Schedule, AutoIndexing, 0

	IniRead, al_DisableLocalizedNames, %ConfigFile_AppLauncher%, Config, DisableLocalizedNames, 0

	IniRead, al_ReIndex, %ConfigFile_AppLauncher%, Update, ReIndex, %A_Space%

	Loop
	{
		IniRead, al_OpenWithApp%A_Index%, %ConfigFile_AppLauncher%, OpenWithApplications, Application%A_Index%, %A_Space%
		If al_OpenWithApp%A_Index% =
			break
	}

	al_LastText = fadsfSDFDFasdFdfsadfsadFDSFDf

	RegisterAdditionalSetting("al", "ListOnTop", 0)
	RegisterAdditionalSetting("al", "SimpleView", 0)
	RegisterAdditionalSetting("al", "ReducedSimpleView", 0)
	RegisterAdditionalSetting("al", "ShowWindowAtMousePos", 0)
	RegisterAdditionalSetting("al", "CloseNoFocus", 0)
	RegisterAdditionalSetting("al", "HistWithCtrl", 0)
	RegisterAdditionalSetting("al", "IgnoreDelayMessage", 0)
	RegisterAdditionalSetting("al", "UseRunAsHelper", 0)
	RegisterAdditionalSetting("al", "sub_RepairRegistry", 0, "Type:SubRoutine")
	RegisterAdditionalSetting("al", "sub_IndexToHistory", 0, "Type:SubRoutine")
	RegisterAdditionalSetting("al", "sub_Additionals", 0, "Type:SubRoutine")

	FileRead, al_activAidCommands, %al_IndexPath%\%al_activAidIndexFile%
	FileRead, al_ExcludedFiles, %al_IndexPath%\%al_ExcludedFilesFile%
	al_ExcludedFiles := func_Deref(al_ExcludedFiles)

	FileRead, al_CustomNames, %al_IndexPath%\%al_CustomNamesFile%
	al_CustomNames := func_Deref(al_CustomNames)

	IniRead, al_LastComputerName, %ConfigFile_AppLauncher%, Config, LastComputerName, %A_Space%
	IniWrite, %A_ComputerName%, %ConfigFile_AppLauncher%, Config, LastComputerName

	IniRead, al_IndexVersion, %ConfigFile_AppLauncher%, Config, IndexVersion, 1
	If (al_IndexVersion < al_RequiredIndexVersion)
		al_ReIndex = 1

	If (al_IndexVersion < al_RequiredIndexVersion OR (A_ComputerName <> al_LastComputerName AND al_IndexWhenComputerChanges = 1))
	{
		SetTimer, al_sub_IndexDirectoriesTimer_Portable, -8000
		If al_IndexVersion = 1
			al_History =
	}
Return

SettingsGui_AppLauncher:
	Gui, Add, Text, xs+10 y+10, %lng_al_NumberOfHistory%:
	Gui, Add, ComboBox, x+10 yp-4 w50 gsub_CheckIfSettingsChanged val_MaxLastUsed, 5|10|15|20|25|30|35|40|50|80|100
	Gui, Add, Button, -Wrap X+10 gal_sub_ClearHistory, %lng_al_ClearHistory%
	Gui, Add, Text, x+10 yp+4, %lng_al_NumberMaxHits%:
	Gui, Add, ComboBox, x+10 yp-4 w50 gsub_CheckIfSettingsChanged val_MaxHits, 5|10|15|20|25|30|35|40|45|50|60|70|80|90|100|200|300

	Gui, Add, Text, Y+5 XS+10, %lng_al_AddToIndexList%
	al_PathsToIndex_Box = %al_PathsToIndexNoDeref%
	Gui, Add, ListBox, Y+5 val_PathsToIndex_Box_tmp W530 R8, %al_PathsToIndex_Box%
	Gui, Add, Button, -Wrap x+4 w21 val_Add_PathsToIndex_Box gal_sub_ListBox_addFolder, +
	Gui, Add, Button, -Wrap y+4 w21 val_Remove_PathsToIndex_Box gsub_ListBox_remove, %MinusString%
	Gui, Font,S%FontSize12%,Webdings
	Gui, Add, Button, -Wrap y+39 w21 h21 gal_sub_IndexDirectories, q
	Gosub, GuiDefaultFont

	Gui, Add, CheckBox, -Wrap xs+10 y+5 val_IncludeHiddenFiles gsub_CheckIfSettingsChanged Checked%al_IncludeHiddenFiles%, %lng_al_IncludeHiddenFiles%
	Gui, Add, CheckBox, -Wrap x+10 Checked%al_SearchFromBeginning% gal_sub_CheckIfSettingsChanged val_SearchFromBeginning, %lng_al_SearchFromBeginning%
	Gui, Add, CheckBox, -Wrap x+10 val_PhoneticSearch gsub_CheckIfSettingsChanged Checked%al_PhoneticSearch%, %lng_al_PhoneticSearch%

	Gui, Add, Text, xs+10 y+15 , %lng_al_IndexPath%
	Gui, Add, Edit, gsub_CheckIfSettingsChanged R1 w385 val_IndexPathNoDeref, %al_IndexPathNoDeref%
	Gui, Add, Button, -Wrap X+5 YP-1 W100 gal_sub_Browse, %lng_Browse%
	Gui, Add, Button, -Wrap X+5 W60 gal_sub_OpenIndexPath, %lng_al_OpenIndexPath%
	IfExist, %al_IndexPath%\%al_ExcludedFilesFile%
		Gui, Add, Text, XS+10 y+2 Disabled, %lng_al_ExcludedFilesExist%

	GuiControl, Text, al_MaxLastUsed, %al_MaxLastUsed%
	GuiControl, Text, al_MaxHits, %al_MaxHits%

	al_BorderHeight := BorderHeight-al_SimpleView
	Gosub, al_sub_CheckIfSettingsChanged
Return

al_sub_CheckIfSettingsChanged:
	Gosub, sub_CheckIfSettingsChanged
	GuiControlGet, al_SearchFromBeginning_tmp,, al_SearchFromBeginning
	If al_SearchFromBeginning_tmp = 1
		GuiControl, Enable, al_PhoneticSearch
	Else
		GuiControl, Disable, al_PhoneticSearch
Return

al_sub_ListBox_addFolder:
	If al_VariableDriveLetter = 1
		ListBox_addFolder_VariableDriveLetter = 1
	Gosub, sub_ListBox_addFolder
	ListBox_addFolder_VariableDriveLetter =
Return

al_sub_Additionals:
	GuiControlGet, al_SearchFromBeginning
	If al_SimpleView_tmp = 1
		al_SimpleViewDisable = Disabled
	Else
		al_SimpleViewDisable =

	Gui, %GuiID_activAid%:+Disabled
	GuiDefault("AppLauncherAdditionals", "+Owner" GuiID_activAid )
	Gosub, GuiDefaultFont

	Gui, Add, CheckBox, y+15 -Wrap Checked%al_AutoIndexing% gsub_CheckIfSettingsChanged val_AutoIndexing, %lng_al_AutoIndexing%
	Gui, Add, ComboBox, x+5 yp-4 w55 gsub_CheckIfSettingsChanged val_IndexInterval, 00:05|00:15|00:30|01:00|02:00|03:00|04:00|06:00|12:00|24:00|48:00
	GuiControl,Text, al_IndexInterval, %al_IndexInterval%
	Gui, Add, Text, yp+4 x+5, %lng_al_Hours%
	Gui, Add, CheckBox, -Wrap x+10 Checked%al_IndexWhenComputerChanges% gsub_CheckIfSettingsChanged val_IndexWhenComputerChanges, %lng_al_IndexWhenComputerChanges%

	Gui, Add, Text, XS y+15 W380, %lng_al_ExcludeList%
	Gui, Add, Edit, YP-4 XP+400 W100 Limit25 val_ExcludeList_Edit,
	Gui, Add, Button, -Wrap x+4 w21 val_Add_ExcludeList_Box gal_sub_ListBox_add, +
	al_ExcludeList_Box = %al_ExcludeList%
	Gui, Add, ListBox, Y+4 XS val_ExcludeList_Box_tmp W500 R4, %al_ExcludeList_Box%
	Gui, Add, Button, -Wrap x+4 w21 val_Remove_ExcludeList_Box gsub_ListBox_remove, %MinusString%

	Gui, Add, Text, Y+48 XS W440, %lng_al_TypeList%
	Gui, Add, Edit, YP-0 XP+460 W40 Limit5 val_TypeList_Edit,
	Gui, Add, Button, -Wrap x+4 w21 val_Add_TypeList_Box gal_sub_ListBox_add, +
	al_TypeList_Box = %al_TypeList%
	Gui, Add, ListBox, Y+8 XS val_TypeList_Box_tmp W500 R4, %al_TypeList_Box%
	Gui, Add, Button, -Wrap x+4 w21 val_Remove_TypeList_Box gsub_ListBox_remove, %MinusString%
	Gui, Add, CheckBox, -Wrap x10 yp+60 w200 Checked%al_IndexFolders% gsub_CheckIfSettingsChanged val_IndexFolders, %lng_al_IndexFolders%
	Gui, Add, CheckBox, -Wrap x+10 Checked%al_ShowActivaidCommands% gsub_CheckIfSettingsChanged val_ShowActivaidCommands Check3, %lng_al_ShowActivaidCommands%
	Gui, Add, CheckBox, -Wrap x10 y+3 w200 Checked%al_IndexFolderNames% gsub_CheckIfSettingsChanged val_IndexFolderNames, %lng_al_IndexFolderNames%
	Gui, Add, CheckBox, -Wrap x+10 Checked%al_VariableDriveLetter% gsub_CheckIfSettingsChanged val_VariableDriveLetter, %lng_al_VariableDriveLetter%

	Gui, Add, Text, Y+15 XS, %lng_al_AlwaysScan%
	al_AlwaysScan_Box = %al_AlwaysScanNoDeref%
	Gui, Add, ListBox, Y+5 XS val_AlwaysScan_Box_tmp W500 R4, %al_AlwaysScan_Box%
	Gui, Add, Button, -Wrap x+4 w21 val_Add_AlwaysScan_Box gal_sub_ListBox_addFolder, +
	Gui, Add, Button, -Wrap y+4 w21 val_Remove_AlwaysScan_Box gsub_ListBox_remove, %MinusString%

	al_GBHeight := 6 * 20 + 25    ; Anzahl Checkboxen * 20 + 25
	Gui, Add, GroupBox, xs y+10 w245 h%al_GBHeight%, %lng_al_MoreOptions%
	Gui, Add, CheckBox, -Wrap xp+10 yp+20 Checked%al_ShowLinkTarget% gsub_CheckIfSettingsChanged val_ShowLinkTarget, %lng_al_ShowLinkTarget%
	Gui, Add, CheckBox, -Wrap xp yp+20 Checked%al_ShowBigIcons% gsub_CheckIfSettingsChanged val_ShowBigIcons, %lng_al_ShowBigIcons%
	Gui, Add, CheckBox, -Wrap xp yp+20 Checked%al_IconsWithAPI% gsub_CheckIfSettingsChanged val_IconsWithAPI, %lng_al_IconsWithAPI%

	Gui, Add, GroupBox, xs+255 yp-60 w245 h%al_GBHeight%, %lng_al_MoreListOptions%
	Gui, Add, CheckBox, -Wrap xp+10 yp+20 Checked%al_ModifyColumns% %al_SimpleViewDisable% gsub_CheckIfSettingsChanged Check3 val_ModifyColumns, %lng_al_ModifyColumns%
	Gui, Add, CheckBox, -Wrap XP yp+20 val_ShowIcons gsub_CheckIfSettingsChanged Checked%al_ShowIcons%, %lng_al_ShowIcons%
	Gui, Add, CheckBox, -Wrap xp yp+20 Checked%al_Grid% %al_SimpleViewDisable% gsub_CheckIfSettingsChanged val_Grid, %lng_al_Grid%
	Gui, Add, CheckBox, -Wrap xp yp+20 Checked%al_Header% %al_SimpleViewDisable% gsub_CheckIfSettingsChanged Check3 val_Header, %lng_al_Header%
	Gui, Add, CheckBox, -Wrap xp yp+20 Checked%al_ShowDate% gsub_CheckIfSettingsChanged val_ShowDate, %lng_al_ShowDate%
	Gui, Add, CheckBox, -Wrap xp yp+20 Checked%al_SortResult% gsub_CheckIfSettingsChanged val_SortResult, %lng_al_SortResult%

	al_GBHeight := 2 * 20 + 25    ; Anzahl Checkboxen * 20 + 25
	Gui, Add, GroupBox, xs yp+30 w500 h%al_GBHeight%, %lng_al_SearchOptions%
	Gui, Add, CheckBox, -Wrap xp+10 yp+20 Checked%al_SearchFromBeginning% gsub_CheckIfSettingsChanged val_SearchFromBeginning, %lng_al_SearchFromBeginning%
	Gui, Add, CheckBox, -Wrap xp yp+20 Checked%al_FilterDuplicates% gsub_CheckIfSettingsChanged val_FilterDuplicates, %lng_al_FilterDuplicates%

	Gui, Add, Button, -Wrap X180 W80 vMainGuiOK Default gal_sub_AdditionalsOK, %lng_OK%
	Gui, Add, Button, -Wrap X+5 W80 vMainGuiCancel gAppLauncherAdditionalsGuiClose, %lng_cancel%

	Gui, Show, w550, %al_ScriptName% %lng_al_sub_Additionals%
Return

al_sub_ListBox_add:
	StringReplace, tmpControl, A_GuiControl, Add_,
	StringReplace, tmpEdit, tmpControl, Box, Edit
	GuiControlGet, %tmpEdit%
	StringReplace, %tmpEdit%, %tmpEdit%, |,,a
	if %tmpEdit% <>
	{
		GuiControl,,%tmpControl%_tmp, % %tmpEdit%
		StringReplace, %tmpControl%, %tmpControl%, % %tmpControl%, % %tmpControl% "|" %tmpEdit%, a
		StringReplace, %tmpControl%, %tmpControl%, ||, |, a
		StringReplace, %tmpEdit%, %tmpEdit%, % %tmpEdit%,,a
		GuiControl,, %tmpEdit%,
	}
;    if al_TypeList_Edit <>
;    {
;       GuiControl,,al_TypeList_Box_tmp, %al_TypeList_Edit%
;       al_TypeList_Box := al_TypeList_Box "|" al_TypeList_Edit
;       StringReplace, al_TypeList_Box, al_TypeList_Box, ||, |, a
;       al_TypeList_Edit =
;       GuiControl,, al_TypeList_Edit,
;    }
Return

al_sub_AdditionalsOK:
	func_SettingsChanged( "AppLauncher" )

	Gui, %GuiID_activAid%:-Disabled
	Gui, Submit
	Gui, Destroy
	GuiControl, %GuiID_activAid%: , al_SearchFromBeginning, %al_SearchFromBeginning%
Return

al_sub_Browse:
	Gui +OwnDialogs
	FileSelectFolder, al_IndexPath, *%al_IndexPath% , 3
	If al_IndexPath <>
		GuiControl,,al_IndexPath,%al_IndexPath%
Return

al_sub_OpenIndexPath:
	GuiControlGet,al_IndexPath_tmp,,al_IndexPathNoDeref
	Run, % func_Deref(al_IndexPath_tmp),, UseErrorLevel
	If ErrorLevel = ERROR
		func_GetErrorMessage( A_LastError, al_ScriptName )
Return

SaveSettings_AppLauncher:
	al_PathsToIndexNoDeref := al_PathsToIndex_Box

	If al_IndexPathNoDeref =
		al_IndexPathNoDeref = %SettingsDir%\%al_ScriptName%

	If (func_StrLeft(al_PathsToIndex,1) = "|")
		StringTrimLeft, al_PathsToIndex, al_PathsToIndex, 1
	If (func_StrRight(al_PathsToIndexNoDeref,1) = "|")
		StringTrimRight, al_PathsToIndexNoDeref, al_PathsToIndexNoDeref, 1

	al_PathsToIndex := func_Deref(al_PathsToIndexNoDeref)
	IniWrite, %al_PathsToIndexNoDeref%, %ConfigFile_AppLauncher%, Config, PathsToIndex

	al_IndexPath := func_Deref(al_IndexPathNoDeref)
	IniWrite, %al_IndexPathNoDeref%, %ConfigFile_AppLauncher%, Config, IndexPath

	al_TypeList := al_TypeList_Box
	If (func_StrLeft(al_TypeList,1) = "|")
		StringTrimLeft, al_TypeList, al_TypeList, 1
	If (func_StrRight(al_TypeList,1) = "|")
		StringTrimRight, al_TypeList, al_TypeList, 1
	IniWrite, %al_TypeList%, %ConfigFile_AppLauncher%, Config, TypeList

	al_ExcludeList := al_ExcludeList_Box
	If (func_StrLeft(al_ExcludeList,1) = "|")
		StringTrimLeft, al_ExcludeList, al_ExcludeList, 1
	If (func_StrRight(al_ExcludeList,1) = "|")
		StringTrimRight, al_ExcludeList, al_ExcludeList, 1
	IniWrite, %al_ExcludeList%, %ConfigFile_AppLauncher%, Config, ExcludeList

	al_AlwaysScanNoDeref := al_AlwaysScan_Box
	If (func_StrLeft(al_AlwaysScanNoDeref,1) = "|")
		StringTrimLeft, al_AlwaysScanNoDeref, al_AlwaysScanNoDeref, 1
	If (func_StrRight(al_AlwaysScanNoDeref,1) = "|")
		StringTrimRight, al_AlwaysScanNoDeref, al_AlwaysScanNoDeref, 1
	al_AlwaysScan := func_Deref(al_AlwaysScanNoDeref)
	IniWrite, %al_AlwaysScanNoDeref%, %ConfigFile_AppLauncher%, Config, AlwaysScan

	IniWrite, %al_MaxHits%,            %ConfigFile_AppLauncher%, Config, MaxHits
	IniWrite, %al_IncludeHiddenFiles%, %ConfigFile_AppLauncher%, Config, IncludeHiddenFiles
	IniWrite, %al_SearchFromBeginning%,%ConfigFile_AppLauncher%, Config, SearchFromBeginning
	IniWrite, %al_PhoneticSearch%     ,%ConfigFile_AppLauncher%, Config, PhoneticSearch

	IniWrite, %al_FilterDuplicates%,   %ConfigFile_AppLauncher%, Config, FilterDuplicates
	IniWrite, %al_ShowIcons%,          %ConfigFile_AppLauncher%, Config, ShowIcons
	IniWrite, %al_ShowLinkTarget%,     %ConfigFile_AppLauncher%, Config, ShowLinkTarget
	IniWrite, %al_ShowBigIcons%,       %ConfigFile_AppLauncher%, Config, ShowBigIcons
	IniWrite, %al_IconsWithAPI%,       %ConfigFile_AppLauncher%, Config, IconsWithAPI
	IniWrite, %al_ModifyColumns%,      %ConfigFile_AppLauncher%, Config, ModifyColumns
	IniWrite, %al_Grid%,               %ConfigFile_AppLauncher%, Config, Grid
	IniWrite, %al_SortResult%,         %ConfigFile_AppLauncher%, Config, SortResult
	IniWrite, %al_Header%,             %ConfigFile_AppLauncher%, Config, ListHeader
	IniWrite, %al_IndexFolders%,       %ConfigFile_AppLauncher%, Config, IndexFolders
	IniWrite, %al_ShowActivaidCommands%,%ConfigFile_AppLauncher%, Config, ShowActivAidCommands
	IniWrite, %al_ShowDate%,           %ConfigFile_AppLauncher%, Config, ShowDate
	IniWrite, %al_IndexFolderNames%,   %ConfigFile_AppLauncher%, Config, IndexFolderNames

	IniWrite, %al_MaxLastUsed%, %ConfigFile_AppLauncher%, History, MaxLastUsed
	IniWrite, %al_History%, %ConfigFile_AppLauncher%, History, SearchHistory
	IniWrite, %al_HistWithCtrl%,       %ConfigFile_AppLauncher%, History,  HistoryWithCTRL

	IniWrite, %al_ListOnTop%, %ConfigFile_AppLauncher%, Window,  ListOnTop

	IniWrite, %al_IndexInterval%, %ConfigFile_AppLauncher%, Schedule, IndexInterval
	IniWrite, %al_IndexWhenComputerChanges%, %ConfigFile_AppLauncher%, Schedule, IndexWhenComputerChanges
	IniWrite, %al_AutoIndexing%, %ConfigFile_AppLauncher%, Schedule, AutoIndexing
	IniWrite, %al_VariableDriveLetter%, %ConfigFile_AppLauncher%, Schedule, VariableDriveLetter

	IniWrite, %al_DisableLocalizedNames%, %ConfigFile_AppLauncher%, Config, DisableLocalizedNames

	If Enable_AppLauncher = 1
		SetTimer, al_sub_IndexDirectories, 50

	If (abs(al_ShowActivaidCommands) == 1)
	{
		FileDelete, %al_IndexPath%\%al_activAidIndexFile%
		FileAppend, %al_activAidCommands%, %al_IndexPath%\%al_activAidIndexFile%
	}
Return

ResetWindows_AppLauncher:
	IniDelete, %ConfigFile_AppLauncher%, Window, WindowX
	IniDelete, %ConfigFile_AppLauncher%, Window, WindowY
	IniDelete, %ConfigFile_AppLauncher%, Window, WindowWidth
	IniDelete, %ConfigFile_AppLauncher%, Window, WindowHeight
Return

AppLauncherAdditionalsGuiClose:
AppLauncherAdditionalsGuiEscape:
	Gui, %GuiID_activAid%:-Disabled
	Gui, Destroy
Return

CancelSettings_AppLauncher:
	If (abs(al_ShowActivaidCommands) == 1)
	{
		FileDelete, %al_IndexPath%\%al_activAidIndexFile%
		FileAppend, %al_activAidCommands%, %al_IndexPath%\%al_activAidIndexFile%
	}
Return

DoEnable_AppLauncher:
	func_HotkeyEnable("al_AppLauncher")
	If al_AutoIndexing = 1
	{
		StringSplit, al_Time, al_IndexInterval, :,
		al_Time := (al_Time1*60+al_Time2)*60 * 1000
		SetTimer, al_sub_IndexDirectoriesTimer, %al_Time%
	}
	al_lastDiffW =
	al_lastDiffH =
	al_lastText =
	If (abs(al_ShowActivaidCommands) == 1)
	{
		RegisterHook( "CreateListOfHotkeys", "AppLauncher" )
		RegisterHook( "MainGui", "AppLauncher" )
	}
	Else
		al_activAidCommands =

	al_DllModule := DllCall("LoadLibrary", "str", "shell32.dll")
Return

DoDisable_AppLauncher:
	func_HotkeyDisable("al_AppLauncher")
	Gui, %GuiID_AppLauncherMain%:Destroy
	Gui, %GuiID_AppLauncherAdditionals%:Destroy
	al_GuiWinID =
	SetTimer, al_sub_IndexDirectoriesTimer, Off
	If (abs(al_ShowActivaidCommands) == 1)
	{
		UnRegisterHook( "CreateListOfHotkeys", "AppLauncher" )
		UnRegisterHook( "MainGui", "AppLauncher" )
	}
	If al_DllModule <>
		DllCall("FreeLibrary", "UInt", al_DllModule)
	al_DllModule =
Return

DefaultSettings_AppLauncher:
	FileDelete, %ConfigFile_AppLauncher%
Return

Update_AppLauncher:
	IniRead, al_LastUpdateNumber, settings\AppLauncher.ini, Update, UpdateNumber, 0

	If ( al_LastUpdateNumber < 1 )
		IniWrite, 1, settings\AppLauncher.ini, Update, ReIndex

	IniWrite, 1, settings\AppLauncher.ini, Update, UpdateNumber
Return

CreateListOfHotkeys_AppLauncher:
	If SimpleMainGUI <>
		Return
	If (al_ShowActivaidCommands == 1)
	{
		If CreateListOfHotkeys_SubCategory
			CreateListOfHotkeys_SubCategory2 := " " CreateListOfHotkeys_SubCategory
		If CreateListOfHotkeys_Hotkey
			CreateListOfHotkeys_Hotkey2 := " [" func_HotkeyDecompose( CreateListOfHotkeys_Hotkey, 1) "]"
	}

	If (CreateListOfHotkeys_Extension <> al_LastSubroutine AND CreateListOfHotkeys_Extension <> "activAid")
		al_activAidCommands = %al_activAidCommands%al_sub_CallSimpleConfig\%CreateListOfHotkeys_Extension%-%lng_al_Settings%|

	If (al_ShowActivaidCommands == 1)
	{
		If (CreateListOfHotkeys_SubRoutine <> "" AND CreateListOfHotkeys_SubRoutine <> "<SEPARATOR>")
			al_activAidCommands = %al_activAidCommands%%CreateListOfHotkeys_SubRoutine%\%CreateListOfHotkeys_Extension%%CreateListOfHotkeys_SubCategory2% %CreateListOfHotkeys_Text%%CreateListOfHotkeys_Hotkey2%|
		al_LastSubroutine := CreateListOfHotkeys_Extension
	}
	CreateListOfHotkeys_Hotkey2 =
	CreateListOfHotkeys_SubCategory2 =
Return

al_sub_CallSimpleConfig:
	StringReplace,al_FName, al_FName, -%lng_al_Settings%
	If MainGuiVisible <>
		Gosub, activAidGuiClose
	If al_FName <> activAid
		SimpleMainGUI = %al_FName%
	Gosub, sub_MainGUI
Return


MainGuiInit_AppLauncher:
	If SimpleMainGUI =
		al_activAidCommands =
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

sub_Hotkey_AppLauncher: ; al
	Gosub, al_main_AppLauncher
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

; ---------------------------------------------------------------------
al_main_AppLauncher: ; Unterroutine für das Eingabefenster
	If Enable_AppLauncher = 1
	{
		If al_GuiWinID =  ; Fenster aufbauen, wenn es noch nicht existiert
		{
			al_BorderHeight := BorderHeight-al_SimpleView
			If al_SimpleView = 1
			{
				al_MinH   = 22  ; min. Fensterhöhe
				al_MinW   = 50  ; min. Fensterbreite
			}
			Else
			{
				al_MinH   = 175  ; min. Fensterhöhe
				al_MinW   = 245  ; min. Fensterbreite
			}
			al_SearchFieldH := 22
			al_WinFoldH := al_SearchFieldH+al_BorderHeight*2

			GuiDefault("AppLauncherMain", "+Resize +Alwaysontop +Lastfound +MinSize" al_MinW "x" al_MinH)
			Gosub, sub_BigIcon
			WinGet, al_GuiWinID, ID

			Gosub, al_build_ItemList

			If (al_ItemIndexList = "" AND al_PathsToIndex <> "")
			{
				msgbox, 64, %al_Titel%, % lng_al_NoIndex%al_ReIndex%, 8
				Gosub, al_sub_IndexDirectories
				Gosub, al_build_ItemList
			}

			al_RecentList =
			al_count_hits = 0
			al_TickCount := A_TickCount

			Loop, Parse, al_AlwaysScan, |
			{
				IfNotExist, %A_LoopField%, Continue

				Loop, %A_LoopField%\*.*, %al_IndexFolderNames%, 1
				{
					SplitPath, A_LoopFileFullPath, al_FName, , al_FExt
					If al_FExt = lnk
					{
						FileGetShortcut, %A_LoopFileFullPath%, al_FTargetName
						SplitPath, al_FTargetName,,,al_FExt
						If al_FExt = ico
							al_FExt = lnk
					}
					Else
						al_FTargetName =

					al_FAttrib := FileExist(A_LoopFileFullPath)

					IfInString, al_FTargetName, :\
						al_FTargetAttrib := FileExist(al_FTargetName)
					Else
						If al_FExt =
							al_FTargetAttrib = D

					If (( (!InStr("|" al_TypeList "|", "|" al_FExt "|") AND !(InStr( al_FTargetAttrib, "D" ) AND al_IndexFolders = 1 )) OR ( InStr( al_FTargetAttrib, "D" ) AND al_IndexFolders = 0 ) OR (al_FTargetAttrib = "" AND al_FTargetName <> "") ) AND !(InStr(al_FAttrib,"D") AND al_IndexFolderNames = 1) )
						Continue

					al_FNameLocalized =
					al_FExtLocalized =
					If al_DisableLocalizedNames = 0
						IfNotInString, al_CustomNames, %A_LoopFileFullPath%*
						{
							al_FNameLocalized := GetLocalizedFilename(A_LoopFileFullPath)
							If (al_FExt <> "" AND al_FNameLocalized <> "")
								al_FExtLocalized := "." al_FExt
						}

					If (InStr(al_FName,al_FNameLocalized) OR al_FNameLocalized = "")
						al_LoopFileFullPath := A_LoopFileFullPath
					Else
						al_LoopFileFullPath := A_LoopFileFullPath "*" al_FNameLocalized al_FExtLocalized

					al_Cont = 0
					Loop, Parse, al_ExcludeList, |
					{
						IfInString, al_FName, %A_LoopField%
						{
							 al_Cont = 1
							 Break
						}
					}
					IfEqual, al_Cont, 1
						Continue
					IfInString, al_ExcludedFiles, %al_LoopFileFullPath%
						Continue

					IfInString, al_CustomNames, %al_LoopFileFullPath%*
					{
						Loop, Parse, al_CustomNames, `n, `r
						{
							IfInString, A_LoopField, %al_LoopFileFullPath%*
							{
								StringReplace, al_LoopFileFullPath, A_LoopField, %al_LoopFileFullPath%*, %al_LoopFileFullPath%*
								Break
							}
						}
					}

					al_RecentList = %al_RecentList%|%al_LoopFileFullPath%
				}
			}

			al_ItemList = %al_activAidCommands%%al_RecentList%|%al_ItemIndexList%
			al_TickCount := (A_TickCount-al_TickCount)/1000

			If (al_TickCount > 1.5 AND al_IgnoreDelayMessage = 0)
				BalloonTip(al_ScriptName, lng_al_DelayMessage,"Info",0,0,20)

			IniRead, al_WinX, %ConfigFile_AppLauncher%, Window, WindowX, %A_Space%
			IniRead, al_WinY, %ConfigFile_AppLauncher%, Window, WindowY, %A_Space%
			IniRead, al_WinW, %ConfigFile_AppLauncher%, Window, WindowWidth  ; Fensterbreite
			IniRead, al_WinH, %ConfigFile_AppLauncher%, Window, WindowHeight ; Fensterhöhe
			If (al_WinW = "ERROR" OR al_WinW = "")
				al_WinW = 700
			If (al_WinH = "ERROR" OR al_WinH = "")
				al_WinH = 470

			al_WinH := al_WinH-(al_BorderHeight*2) ;+2*al_SimpleView
			al_WinW := al_WinW-(al_BorderHeight*2) ;+2*al_SimpleView

			If al_ShowWindowAtMousePos = 1
			{
				CoordMode, Mouse, Screen
				MouseGetPos, al_WinX, al_WinY
				al_WinX := al_WinX-5
				al_WinY := al_WinY-5
				func_MoveCoordsIntoViewArea(al_WinX, al_WinY, al_WinW, al_WinH, 1)
			}

			al_ListOptions =
			if al_Grid = 1
				al_ListOptions = Grid
			if al_Header = 1
				al_ListOptions = %al_ListOptions% +Hdr
			else if al_Header = -1
				al_ListOptions = %al_ListOptions% +Hdr NoSortHdr
			else
				al_ListOptions = %al_ListOptions% -Hdr

			al_Caption := CaptionHeight-19
			al_ListY    = 60    ; Y-Position der Ergebnisliste
			al_ListW    := al_WinW-20    ; Breite der Ergebnisliste
			al_ListH    := al_WinH-100-al_Caption   ; Höhe der Ergebnisliste
			al_TextW    := al_WinW-180   ; Breite für den Info-Text
			al_Button2X := al_WinW-180   ; X-Position von "Abbrechen"
			al_Button1X := al_WinW-90    ; X-Position von "Ausführen"
			if al_ListOnTop = 1
			{
				If al_SimpleView = 1
				{
					al_ListW    := al_WinW    ; Breite der Ergebnisliste
					al_ListH    := al_WinH-22   ; Höhe der Ergebnisliste
					Gui, Add, Button, x0 y0 gal_sub_SearchOK Hidden Default, %lng_al_Open%
					Gui, Add, ListView, x0 y0 w%al_ListW% h%al_ListH% val_SelItem -Multi -Hdr -ReadOnly NoSortHdr AltSubmit HScroll gal_sub_LV_Events, %lng_al_Name%|%lng_al_Ext%|%lng_al_Date%|%lng_al_Folder%|Date
;               Gui, Add, ListView, x0 y0 w%al_ListW% h%al_ListH% val_SelItem -Multi -ReadOnly NoSortHdr AltSubmit HScroll gal_sub_LV_Events, %lng_al_Name%|%lng_al_Ext%|%lng_al_Date%|%lng_al_Folder%|Date
					Gui, Add, Edit, val_FindString gal_sub_FindStringChanged h22 x0 y+0 w%al_ListW% h%al_SearchFieldH%, %al_Search%
				}
				Else
				{
					al_StaticY  := al_WinH-55    ; Y-Position von Text1
					al_Edit1Y   := al_StaticY+20    ; Y-Position des Eingabefelds
					al_Static2Y := al_StaticY+13    ; Y-Position des Icons
					al_Static3Y := al_StaticY+24    ; Y-Position vom Text2

					Gui, Add, Button, -Wrap gal_sub_SearchOK x%al_Button1X% y+10 w80 Default, %lng_al_Open%
					Gui, Add, Button, -Wrap gAppLauncherMainGuiClose x%al_Button2X% w80 yp, %lng_Cancel%
					Gui, Font,S%FontSize12%,Webdings
					Gui, Add, Button, -Wrap gal_sub_IndexDirectories2 w20 h20 x10 yp, q
					Gosub, GuiDefaultFont
					Gui, Add, ListView, x10 w%al_ListW% h%al_ListH% val_SelItem -Multi %al_ListOptions% -ReadOnly AltSubmit HScroll gal_sub_LV_Events, %lng_al_Name%|%lng_al_Ext%|%lng_al_Date%|%lng_al_Folder%|Date

					Gui, Add, Text, x10 y%al_StaticY% , %lng_al_SuchEingabe%
					Gui, Add, Edit, val_FindString gal_sub_FindStringChanged x10 y%al_Edit1Y% w110, %al_Search%
					Gui, Add, Picture, x+10 y%al_Static2Y% w32 h-1
					Gui, Add, Text, val_FirstHit xp+40 y%al_Static3Y% w%al_TextW% R1 -Wrap
				}
			}
			Else
			{
				If al_SimpleView = 1
				{
					al_ListW    := al_WinW    ; Breite der Ergebnisliste
					al_ListH    := al_WinH-22   ; Höhe der Ergebnisliste
					Gui, Add, Button, x0 y0 gal_sub_SearchOK Hidden Default, %lng_al_Open%
					Gui, Add, Edit, val_FindString gal_sub_FindStringChanged h22 x0 y0 w%al_ListW%, %al_Search%
					Gui, Add, ListView, y+0 w%al_ListW% h%al_ListH% val_SelItem -Multi -Hdr -ReadOnly NoSortHdr AltSubmit HScroll gal_sub_LV_Events, %lng_al_Name%|%lng_al_Ext%|%lng_al_Date%|%lng_al_Folder%|Date
				}
				Else
				{
					al_ButtonY  := al_WinH-30    ; Y-Position der Schaltflächen

					Gui, Add, Text, , %lng_al_SuchEingabe%
					Gui, Add, Edit, val_FindString gal_sub_FindStringChanged x10 w110, %al_Search%
					Gui, Add, Picture, x+10 yp-8 w32 h-1
					Gui, Add, Text, val_FirstHit xp+40 yp+12 w%al_TextW% R1 -Wrap
					Gui, Add, ListView, x10 w%al_ListW% h%al_ListH% y%al_ListY% val_SelItem -Multi %al_ListOptions% -ReadOnly HScroll AltSubmit gal_sub_LV_Events, %lng_al_Name%|%lng_al_Ext%|%lng_al_Date%|%lng_al_Folder%|Date
					Gui, Add, Button, -Wrap gal_sub_SearchOK x%al_Button1X% y%al_ButtonY% w80 Default, %lng_al_Open%
					Gui, Add, Button, -Wrap gAppLauncherMainGuiClose x%al_Button2X% w80 y%al_ButtonY%, %lng_Cancel%
					Gui, Font,S%FontSize12%,Webdings
					Gui, Add, Button, -Wrap gal_sub_IndexDirectories2 w20 h20 x10 y%al_ButtonY%, q
					Gosub, GuiDefaultFont
				}
			}
			GuiControl, Focus, al_FindString

			If al_SimpleView = 1
			{
				LV_ModifyCol(1, al_ListW-BorderHeight-ScrollBarVWeight )
				LV_ModifyCol(2, 0)
				LV_ModifyCol(3, 0)
				LV_ModifyCol(4, 0)
				LV_ModifyCol(5, 0)
				Gui, +Resize +AlwaysOnTop -Caption +ToolWindow
				Gui, Show, w%al_WinW% h%al_WinH% %al_WinX% %al_WinY% Hide, %al_Titel%
			}
			Else
			{
				If al_ShowDate = 1
				{
					IniRead, al_Col1, %ConfigFile_AppLauncher%, Window, Col1, % (al_ListW-108-ScrollBarHWeight)/3
					IniRead, al_Col2, %ConfigFile_AppLauncher%, Window, Col2, 36
					IniRead, al_Col4, %ConfigFile_AppLauncher%, Window, Col3, 68
					IniRead, al_Col4, %ConfigFile_AppLauncher%, Window, Col4, % (al_ListW-108-ScrollBarHWeight)/3*2
				}
				Else
				{
					IniRead, al_Col1, %ConfigFile_AppLauncher%, Window, Col1, % (al_ListW-40-ScrollBarHWeight)/3
					IniRead, al_Col2, %ConfigFile_AppLauncher%, Window, Col2, 36
					al_Col3 = 0
					IniRead, al_Col4, %ConfigFile_AppLauncher%, Window, Col4, % (al_ListW-40-ScrollBarHWeight)/3*2
				}
				If al_ModifyColumns = -1
				{

					If al_ShowDate = 1
					{
						al_Col1 := (al_newListW-108-ScrollBarHWeight)/3
						al_Col2 := 36
						al_Col3 := 68
						al_Col4 := (al_newListW-108-ScrollBarHWeight)/3*2
					}
					Else
					{
						al_Col1 := (al_newListW-40-ScrollBarHWeight)/3
						al_Col2 := 36
						al_Col3 := 0
						al_Col4 := (al_newListW-40-ScrollBarHWeight)/3*2
					}
				}

				LV_ModifyCol(1, al_Col1)
				LV_ModifyCol(2, al_Col2)
				LV_ModifyCol(3, al_Col3)
				LV_ModifyCol(4, al_Col4)
				LV_ModifyCol(5, 0)
				Gui, Show, w%al_WinW% h%al_WinH% %al_WinX% %al_WinY% Hide, %al_Titel%
			}
			Detecthiddenwindows, On
			WinGetPos, al_WinX, al_WinY, al_WinW, al_WinH, ahk_id %al_GuiWinID%

			al_lastDiffW =

			If (al_SimpleView = 1 AND al_ReducedSimpleView = 1)
			{
				al_Monitor := func_GetMonitorNumber( "ahk_id " al_GuiWinID )

				al_newWinY := al_WinY
				If al_ListOnTop = 1
					al_newWinY := al_newWinY + al_WinH - al_SearchFieldH - al_BorderHeight*2
				If (al_newWinY+al_WinFoldH > Monitor%al_Monitor%Bottom)
					al_newWinY := Monitor%al_Monitor%Bottom-al_WinFoldH
				If (al_newWinY < Monitor%al_Monitor%Top)
					al_newWinY := Monitor%al_Monitor%Top
				Gui, Show, % "y" al_newWinY " h" al_SearchFieldH
			}

			Gui, Show

			al_fullWinH := al_WinH
			al_fullWinW := al_WinW

			al_FirstTimeIcon =

			func_AddMessage(0x100,"al_sub_Edit1Keys")
			al_LastText = fadsfSDFDFasdFdfsadfsadFDSFDf

			SetTimer, al_sub_GetText, -10
			Control, Choose, 1, SysListView321, ahk_id %al_GuiWinID%

			If al_CloseNoFocus = 1
			{
				WinWaitNotActive, ahk_id %al_GuiWinID%
				If al_GuiWinID <>
					Gosub, AppLauncherMainGuiClose
			}
		}
		else ; ... wenn Fenster existiert ...
			WinActivate, ahk_id %al_GuiWinID% ; .. in den Vordergrund
	}
Return

al_sub_FindStringChanged:
	al_FinishedSearching = 0
	Gui, %GuiID_AppLauncherMain%:Default
	Gui, ListView, al_SelItem
	ControlGetText, al_CurrText, Edit1, ahk_id %al_GuiWinID%
	SetTimer, al_sub_GetText, -10
Return

AppLauncherMainGuiSize:
	;Critical
	Gui, %GuiID_AppLauncherMain%:Default
	Gui, ListView, al_SelItem

	wingetpos, al_newWinX,al_newWinY,al_newWinW,al_newWinH, ahk_id %al_GuiWinID% ; Fenstermaße ermitteln

	al_TitleH := CaptionHeight ;+BorderHeight*2

	; Differenz des veränderten Fensters zu der Originalgröße errechnen
	al_DiffH := al_newWinH-al_WinH

	al_DiffW := al_newWinW-al_WinW

	if (al_DiffW = al_lastDiffW AND al_DiffH = al_lastDiffH)
		return

	al_lastDiffW = %al_DiffW%
	al_lastDiffH = %al_DiffH%

	al_newListW    :=  al_ListW+al_DiffW

	al_newListH    :=  al_ListH+al_DiffH
	al_newTextW    :=  al_TextW+al_DiffW
	al_newButton2X :=  al_Button2X+al_DiffW
	al_newButton1X :=  al_Button1X+al_DiffW
	if al_ListOnTop = 1
	{
		If al_SimpleView = 1
		{
			al_newEdit1Y   :=  al_newListH
			GuiControl, move, SysListView321,                              w%al_newListW% h%al_newListH%
			GuiControl, move, Edit1,                     y%al_newEdit1Y%   w%al_newListW%
		}
		Else
		{
			; Neue Positionen und Größen berechnen
			al_newStaticY  :=  al_StaticY+al_DiffH
			al_newEdit1Y   :=  al_newStaticY+20
			al_newStatic2Y :=  al_newStaticY+13
			al_newStatic3Y :=  al_newStaticY+24

			; Fensterelemente anpassen
			Gui, %GuiID_AppLauncherMain%:Default
			GuiControl, move, SysListView321,                              w%al_newListW% h%al_newListH%
			GuiControl, move, Static3,                   y%al_newStatic3Y% w%al_newTextW%
			GuiControl, movedraw, Button1, x%al_newButton1X%
			GuiControl, movedraw, Button2, x%al_newButton2X%
			GuiControl, move, Static1,                   y%al_newStaticY%
			GuiControl, move, Static2,                   y%al_newStatic2Y%
			GuiControl, move, Edit1,                     y%al_newEdit1Y%
		}
	}
	Else
	{
		If al_SimpleView = 1
		{
			al_newEdit1Y   :=  al_newListH
			GuiControl, move, SysListView321,                              w%al_newListW% h%al_newListH%
			GuiControl, move, Edit1,                                       w%al_newListW%
		}
		Else
		{
			; Neue Positionen und Größen berechnen
			al_newButtonY  :=  al_ButtonY+al_DiffH

			; Fensterelemente anpassen
			Gui, %GuiID_AppLauncherMain%:Default
			GuiControl, move, SysListView321,            y%al_ListY%       w%al_newListW% h%al_newListH%
			GuiControl, move, Static3,                                     w%al_newTextW%
			GuiControl, movedraw, Button1, x%al_newButton1X% y%al_newButtonY%
			GuiControl, movedraw, Button2, x%al_newButton2X% y%al_newButtonY%
			GuiControl, move, Button3,                   y%al_newButtonY%
		}
	}
	If al_SimpleView = 1
	{
		LV_ModifyCol(1, al_newListW-BorderHeight-ScrollBarVWeight )
		LV_ModifyCol(2, 0)
		LV_ModifyCol(3, 0)
		LV_ModifyCol(4, 0)
		LV_ModifyCol(5, 0)
	}
	Else If al_Count >= 1
	{
		If al_ModifyColumns = 1
			LV_ModifyCol()
		Else If al_ModifyColumns = -1
		{

			If al_ShowDate = 1
			{
				al_Col1 := (al_newListW-108-ScrollBarHWeight)/3
				al_Col3 := 68
				al_Col4 := (al_newListW-108-ScrollBarHWeight)/3*2
			}
			Else
			{
				al_Col1 := (al_newListW-40-ScrollBarHWeight)/3
				al_Col3 := 0
				al_Col4 := (al_newListW-40-ScrollBarHWeight)/3*2
			}

			LV_ModifyCol(1, al_Col1)
			LV_ModifyCol(2, 36)
			LV_ModifyCol(3, al_Col3)
			LV_ModifyCol(4, al_Col4)
			LV_ModifyCol(5, 0)
		}
	}

	If (al_newWinH <> al_WinFoldH )
	{
		al_fullWinH := al_newWinH
		al_fullWinW := al_newWinW
	}

	SetTimer, al_tim_SizeSaveChanges, 80
Return

al_tim_SizeSaveChanges:
	SetTimer, al_tim_SizeSaveChanges, Off

	If al_SimpleView = 1
		al_newWinH := al_fullWinH ;-BorderHeight*2
	Else
		al_newWinH := al_fullWinH-al_TitleH
	al_newWinW := al_newWinW ;-BorderHeight*2

	If (al_newWinH <> al_WinFoldH)
	{
		IniWrite, %al_newWinH%, %ConfigFile_AppLauncher%, Window, WindowHeight
	}
	IniWrite, %al_newWinW%, %ConfigFile_AppLauncher%, Window, WindowWidth
Return

al_tim_SizeSaveChangesX:
	SetTimer, al_tim_SizeSaveChanges, Off

	If al_SimpleView = 1
		al_newWinH := al_newWinH ;-BorderHeight*2
	Else
		al_newWinH := al_newWinH-al_TitleH
	al_newWinW := al_newWinW ;-BorderHeight*2

	If (al_CurrText <> "" OR al_SimpleView = 0 OR al_newWinH <> al_WinFoldH)
	{
		IniWrite, %al_newWinH%, %ConfigFile_AppLauncher%, Window, WindowHeight
	}
	IniWrite, %al_newWinW%, %ConfigFile_AppLauncher%, Window, WindowWidth
Return


al_sub_LV_Events:
	Gui, %GuiID_AppLauncherMain%:Default
	Gui, ListView, al_SelItem
	StringCaseSense, On
	If A_GuiEvent = E
	{
		LV_GetText(al_OldCustomName, al_SelItem, 1)
		LV_GetText(al_OldCustomExt, al_SelItem, 2)
		AutoTrim, On
		al_OldCustomExt = %al_OldCustomExt%
		LV_GetText(al_OldCustomDate, al_SelItem, 3)
		LV_GetText(al_OldCustomPath, al_SelItem, 4)
		If al_OldCustomExt <>
			al_OldCustomFName := al_OldCustomName "." al_OldCustomExt
		Else
			al_OldCustomFName := al_OldCustomName
		IfNotInString, al_OldCustomPath, :\
		{
			func_AddMessage(0x100, "al_sub_Edit1Keys")
			GuiControl, +AltSubmit, al_SelItem
			al_OldCustomName =
			GuiControl, %GuiID_AppLauncherMain%:Focus, al_SelItem
			Return
		}
		Else
		{
			func_RemoveMessage(0x100, "al_sub_Edit1Keys")
		}
	}
	If A_GuiEvent = e ; Rename with F2
	{
		LV_GetText(al_EditCustomName, al_SelItem, 1)
		If (al_OldCustomName <> "" AND al_OldCustomName <> al_EditCustomName)
		{
			LV_GetText(al_EditCustomExt, al_SelItem, 2)
			AutoTrim, On
			al_EditCustomExt = %al_EditCustomExt%
			LV_GetText(al_EditCustomDate, al_SelItem, 3)
			LV_GetText(al_EditCustomPath, al_SelItem, 4)

			If al_EditCustomExt <>
				al_EditCustomFName := al_EditCustomName "." al_EditCustomExt
			Else
				al_EditCustomFName := al_EditCustomName

			If (InStr(al_CustomNames, al_OldCustomPath "*") OR InStr(al_ItemIndexList, al_OldCustomPath "*"))
			{
				If al_EditCustomName =
				{
					SplitPath, al_EditCustomPath, al_NewCustomFName, al_NewCustomPath, al_NewCustomExt,al_NewCustomName
					al_CustomAction = Restore
				}
				Else
				{
					al_NewCustomPath := al_EditCustomPath
					al_NewCustomFName := al_EditCustomFName
					al_NewCustomName := al_EditCustomName
					al_NewCustomExt := al_EditCustomExt
					al_CustomAction = Change
				}
			}
			Else
			{
				If al_EditCustomName =
				{
					al_NewCustomName := al_OldCustomName
					al_NewCustomPath := al_EditCustomPath
					al_CustomAction = Return
				}
				Else
				{
					al_NewCustomPath := al_EditCustomPath "\" al_OldCustomFName
					al_NewCustomFName := al_EditCustomFName
					al_NewCustomName := al_EditCustomName
					al_NewCustomExt := al_EditCustomExt
					al_CustomAction = New
				}
			}
			If al_ModifyColumns = 1
				LV_Modify(al_SelItem,2, al_NewCustomName, " " al_EditCustomExt "  ", al_EditCustomDate, al_NewCustomPath)
			Else
				LV_Modify(al_SelItem,2, al_NewCustomName, " " al_EditCustomExt, al_EditCustomDate, al_NewCustomPath)

			If al_CustomAction = Return
				Return

			al_NewCustomNames =
			al_CustomChanges = 0
			If (al_CustomAction = "Change" OR al_CustomAction = "Restore")
			{
				Loop, Parse, al_CustomNames, `n, `r
				{
					If A_LoopField =
						continue
					al_LoopField := A_LoopField

					IfInString, al_LoopField, %al_EditCustomPath%*
					{
						al_CustomChanges++
						If al_CustomAction = Restore
							Continue
						al_LoopField = %al_NewCustomPath%*%al_NewCustomFName%
					}
					StringReplace, al_LoopField, al_LoopField, `%, ```%, A
					If al_VariableDriveLetter = 1
						al_LoopField := func_ReplaceWithCommonPathVariables(al_LoopField)
					al_NewCustomNames = %al_NewCustomNames%%al_LoopField%`n
				}

				al_History = %al_History%|
				al_ItemIndexList = %al_ItemIndexList%|
				If al_CustomAction = Change
				{
					StringReplace, al_History, al_History, |%al_EditCustomPath%\%al_OldCustomFName%|, |%al_NewCustomPath%\%al_NewCustomFName%|
					StringReplace, al_ItemIndexList, al_ItemIndexList, |%al_EditCustomPath%*%al_OldCustomFName%|, |%al_NewCustomPath%*%al_NewCustomFName%|
				}
				Else
				{
					StringReplace, al_History, al_History, |%al_EditCustomPath%\%al_OldCustomFName%|, |%al_NewCustomPath%\%al_NewCustomFName%|
					StringReplace, al_ItemIndexList, al_ItemIndexList, |%al_EditCustomPath%*%al_OldCustomFName%|, |%al_NewCustomPath%\%al_NewCustomFName%|
				}
				StringTrimRight, al_History, al_History, 1
				StringTrimRight, al_ItemIndexList, al_ItemIndexList, 1
				If al_CustomChanges = 0
					al_CustomAction = New
			}
			If (al_CustomAction = "New")
			{
				al_NewCustomNames =
				al_LoopField = %al_NewCustomPath%*%al_NewCustomFName%
				StringReplace, al_LoopField, al_LoopField, `%, ```%, A
				If al_VariableDriveLetter = 1
					al_LoopField := func_ReplaceWithCommonPathVariables(al_LoopField)

				Loop, Parse, al_CustomNames, `n, `r
				{
					If A_LoopField =
						continue
					al_LoopField2 := A_LoopField
					StringReplace, al_LoopField2, al_LoopField2, `%, ```%, A
					If al_VariableDriveLetter = 1
						al_LoopField2 := func_ReplaceWithCommonPathVariables(al_LoopField2)
					al_NewCustomNames = %al_NewCustomNames%%al_LoopField2%`n
				}
				al_NewCustomNames = %al_NewCustomNames%%al_LoopField%`n

				al_History = %al_History%|
				al_ItemIndexList = %al_ItemIndexList%|
				StringReplace, al_History, al_History, |%al_NewCustomPath%|, |%al_NewCustomPath%\%al_NewCustomFName%|
				StringReplace, al_ItemIndexList, al_ItemIndexList, |%al_NewCustomPath%|, |%al_NewCustomPath%*%al_NewCustomFName%|
				StringTrimRight, al_History, al_History, 1
				StringTrimRight, al_ItemIndexList, al_ItemIndexList, 1
			}

			al_CustomNames := func_Deref(al_NewCustomNames)

			al_ItemList = %al_activAidCommands%%al_RecentList%|%al_ItemIndexList%
			al_LastText = sdfsdflsdfjsljdfljs
			SetTimer, al_sub_GetText,-10

			FileDelete, %al_IndexPath%\%al_IndexFile%_Portable.tmp
			FileDelete, %al_IndexPath%\%al_IndexFile%%al_IndexFileComputerName%.tmp
			Loop, Parse, al_ItemIndexList, |
			{
				If A_LoopField =
					continue
				al_LoopFileFullPath = %A_LoopField%

				StringReplace, al_LoopFileFullPath, al_LoopFileFullPath, `%, ```%, A

				If al_VariableDriveLetter = 1
					al_LoopFileFullPath := func_ReplaceWithCommonPathVariables(al_LoopFileFullPath)

				If (InStr(al_LoopFileFullPath, "%Drive%") AND AHKonUSB = 1)
					al_IndexFileSuffix = _Portable
				Else
					al_IndexFileSuffix = %al_IndexFileComputerName%

				FileAppend, %al_LoopFileFullPath%`n, %al_IndexPath%\%al_IndexFile%%al_IndexFileSuffix%.tmp
			}
			FileMove, %al_IndexPath%\%al_IndexFile%_Portable.tmp, %al_IndexPath%\%al_IndexFile%_Portable.dat, 1
			FileMove, %al_IndexPath%\%al_IndexFile%%al_IndexFileComputerName%.tmp, %al_IndexPath%\%al_IndexFile%%al_IndexFileComputerName%.dat, 1

			FileDelete, %al_IndexPath%\%al_CustomNamesFile%
			FileAppend, %al_NewCustomNames%, %al_IndexPath%\%al_CustomNamesFile%

			IniWrite, %al_History%, %ConfigFile_AppLauncher%, History, SearchHistory
		}
		func_AddMessage(0x100, "al_sub_Edit1Keys")
		Return
	}
	If (A_GuiEvent = "A" OR A_GuiEvent = "DoubleClick")
	{
		al_SelItem := LV_GetNext()
		IfNotEqual, al_SelItem, 0
			gosub, al_sub_SearchOK
	}
	Else if (A_GuiEvent = "Normal" or A_GuiEvent = "RightClick")
	{
		gosub, al_sub_FileName2TextField
	}
	If A_GuiEvent = RightClick
		al_NoContext = 1
Return

AppLauncherMainGuiContextMenu:
	If (GetKeyState("LButton") OR GetKeyState("RButton") OR (al_NoContext=1 AND hook_RButton <> ""))
	{
		al_NoContext=
		Return
	}
	Gosub, al_sub_FileName2TextField
	LV_GetText(al_FName, al_SelItem, 1)
	LV_GetText(al_FExt, al_SelItem, 2)
	AutoTrim, On
	al_FExt = %al_FExt%
	LV_GetText(al_FDir, al_SelItem, 4)
	If al_FDir =
	{
		If al_FExt =
			al_RunItem = %al_FName%
		Else
			al_RunItem = %al_FName%.%al_FExt%
	}
	Else
	{
		If al_FExt =
			al_RunItem = %al_FDir%\%al_FName%
		Else
			al_RunItem = %al_FDir%\%al_FName%.%al_FExt%
	}
	SplitPath, al_RunItem,, al_RunPath

	If (!FileExist( al_RunItem ) AND FileExist( al_RunPath ))
	{
		al_RunItem := al_RunPath
		SplitPath, al_RunItem,, al_RunPath
	}

	al_FCmd := func_StrLeft( al_RunItem, InStr(al_RunItem, "\")-1)
	al_FCmdName := SubStr( al_RunItem, InStr(al_RunItem, "\")+1)

	al_FinishedSearching = 1
	al_StartOfOpenWithContextMenuItem = 1

	Menu, AppLauncherContext, Add, %lng_al_Open%, al_sub_SearchOKMenu

	If ((!InStr(al_RunPath,"\") AND IsLabel(al_RunPath)) OR IsLabel(al_FCmd))
	{
		Menu, AppLauncherContext, Show
		Menu, AppLauncherContext, DeleteAll
		Return
	}

	al_StartOfOpenWithContextMenuItem = 5
	Menu, AppLauncherContext, Add, %lng_al_RunAs%`t(%lng_KbCtrl%+%lng_KbAlt%+OK), al_sub_SearchOKMenu
	Menu, AppLauncherContext, Add, %lng_al_OpenFolder%`t(%lng_KbShift%+OK), al_sub_SearchOKMenu
	Menu, AppLauncherContext, Add, %lng_al_CopyPath%`t(%lng_KbCtrl%+C),al_sub_CopyPath
	If al_FExt = lnk
	{
		al_StartOfOpenWithContextMenuItem = 6
		Menu, AppLauncherContext, Add, %lng_al_CopyLinkPath%`t(%lng_KbCtrl%+%lng_KbShift%+C),al_sub_CopyLinkPath
	}
	If al_OpenWithApp1 <>
	{
		Menu, AppLauncherContext, Add
		Loop
		{
			If al_OpenWithApp%A_Index% =
				Break
			SplitPath, al_OpenWithApp%A_Index%,,,, al_OpenWithApp
			If A_Index = 1
				Menu, AppLauncherContext, Add, % #(lng_al_OpenWith "`t(" lng_KbCtrl "+" lng_KbShift "+OK)", al_OpenWithApp), al_sub_SearchOKMenu
			Else
				Menu, AppLauncherContext, Add, % #(lng_al_OpenWith, al_OpenWithApp), al_sub_SearchOKMenu
		}
	}
	If IsLabel("init_UserHotkeys")
	{
		Menu, AppLauncherContext, Add, %lng_al_AddToUserHotkeys%,al_sub_AddToUserHotkeys
		al_StartOfOpenWithContextMenuItem++
	}
	Menu, AppLauncherContext, Add,
	Menu, AppLauncherContext, Add, %lng_al_Properties%,al_sub_Properties

	Menu, AppLauncherContext, Show
	Menu, AppLauncherContext, DeleteAll
Return

al_sub_SearchOKMenu:
	al_ThisMenu := A_ThisMenu
	Gosub, al_sub_SearchOK
	al_ThisMenu =
Return

al_sub_SearchOK:
	Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"Recieved OK" )
	If (al_FinishedSearching <> 1 AND !(A_GuiEvent = "A" OR A_GuiEvent = "DoubleClick"))
	{
		Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"Waiting if search is finished" )
		al_SelItem2 := LV_GetNext()
		al_LastText =
		Gosub, al_sub_GetText
		Loop
		{
			If al_FinishedSearching > 0
				break
			Sleep, 10
		}
		LV_Modify(al_SelItem2, "Select")
	}

	Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"Retrieving selected Row" )
	Gui, %GuiID_AppLauncherMain%:Default
	Gui, ListView, al_SelItem
	ControlFocus, SysListView321, ahk_id %al_GuiWinID%

	al_SelItem := LV_GetNext()
	Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"... getting name ..." )
	LV_GetText(al_FName, al_SelItem, 1)
	Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"... getting extension ..." )
	LV_GetText(al_FExt, al_SelItem, 2)
	AutoTrim, On
	al_FExt = %al_FExt%
	Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"... getting folder ..." )
	LV_GetText(al_FDir, al_SelItem, 4)
	If al_FDir =
	{
		If al_FExt =
			al_RunItem = %al_FName%
		Else
			al_RunItem = %al_FName%.%al_FExt%
		Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"No folder, RunItem: " al_RunItem )
	}
	Else
	{
		If al_FExt =
			al_RunItem = %al_FDir%\%al_FName%
		Else
			al_RunItem = %al_FDir%\%al_FName%.%al_FExt%
		Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"Folder: " al_FDir ", RunItem: " al_RunItem  )
	}
	al_IndexItem = %al_RunItem%

	Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"Closing GUI ..." )
	Gosub, AppLauncherMainGuiClose

	al_DllError =
	IfEqual, al_SelItem, 0
	{
		Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"No row selected, directly executing entry" )

		al_CurrText := func_Deref(al_CurrText)
		If (GetKeyState("Alt") OR (al_ThisMenu="AppLauncherContext" AND InStr(A_ThisMenuItem,lng_al_RunAs)))
		{
			Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"RunAs: " al_CurrText )
			If al_UseRunAsHelper = 0
			{
				al_DllError := DllCall("shell32\ShellExecuteA", uint, 0, str, "RunAs", str, al_CurrText,str, "", str, A_WorkingDir, int, 1)
				If al_DllError <= 32
					ErrorLevel = ERROR
			}
			Else
			{
				RunWait, %A_AhkPath% /r "%A_ScriptDir%\Library\RunAsHelper.ahk" "%al_RunItem%", %al_RunPath%, UseErrorLevel
				If (ErrorLevel = ERROR OR ErrorLevel < 0)
					al_DllError =
				Else
				{
					al_DllError = %ErrorLevel%
					If al_DllError <= 32
						ErrorLevel = ERROR
				}
			}
		}
		Else
		{
			Run, %al_CurrText%,, UseErrorLevel
			Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"Run: " al_CurrText )
		}
		If ErrorLevel = ERROR
		{
			func_GetErrorMessage( A_LastError, al_ScriptName, lng_al_runningError ":`n" al_CurrText "`n`n" )
			Return
		}
		al_IndexItem := al_CurrText
	}
	Else
	{
		Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"Preparing selected application ..." )
		Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"... initial path:" al_RunItem )
		SplitPath, al_RunItem,, al_RunPath

		; -------------------------------------------------------------------- ;
		; hier wurde al_RunItem auf das übergeordnete Verzeichnis gesetzt,     ;
		; wenn die Datei nicht existiert (deaktiviert wegen FS#1612)           ;
		; -------------------------------------------------------------------- ;
		;If (!FileExist( al_RunItem ) AND FileExist( al_RunPath ) AND NOT InStr(FileExist(al_RunPath), "D"))
		;{
		;   al_RunItem := al_RunPath
		;   SplitPath, al_RunItem,, al_RunPath
		;   Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"... " al_RunItem )
		;}
		If ((GetKeyState("Shift") AND !GetKeyState("Ctrl")) OR (al_ThisMenu="AppLauncherContext" AND InStr(A_ThisMenuItem,lng_al_OpenFolder)) )
		{
			SplitPath, al_RunItem,, al_RunItem
			Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"... Containing folder: " al_RunItem )
		}

		al_FCmd := func_StrLeft( al_RunItem, InStr(al_RunItem, "\")-1)
		al_FCmdName := SubStr( al_RunItem, InStr(al_RunItem, "\")+1)

		al_RunItem_tmp := al_RunItem

		If (!InStr(al_RunPath,"\") AND IsLabel(al_RunPath))
		{
			CalledFrom = %A_ThisLabel%
			Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"... Gosub from " CalledFrom ": " al_RunPath)
			Gosub, %al_RunPath%
			Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"... Returned")
			CalledFrom =
		}
		Else If (IsLabel(al_FCmd))
		{
			al_FName = %al_FCmdName%
			CalledFrom = %A_ThisLabel%
			Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"... Gosub from " CalledFrom ": " al_RunPath)
			Gosub, %al_FCmd%
			Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"... Returned")
			CalledFrom =
		}
		Else
		{
			If ((al_ThisMenu="AppLauncherContext" AND A_ThisMenuItemPos > al_StartOfOpenWithContextMenuItem) OR (GetKeyState("Shift") AND GetKeyState("Ctrl")))
			{
				Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"... " al_RunItem)
				If al_FExt = lnk
				{
					FileGetShortcut, %al_RunItem%, al_RunItem
					If al_RunItem =
						al_RunItem := al_RunItem_tmp
				}
				If (GetKeyState("Shift") AND GetKeyState("Ctrl"))
					al_StartOfOpenWithContextMenuItem = 1
				Else
					al_StartOfOpenWithContextMenuItem := A_ThisMenuItemPos-al_StartOfOpenWithContextMenuItem
				If (InStr(al_RunItem, " ") AND !InStr(al_RunItem, """"))
					al_RunItem := func_Deref(al_OpenWithApp%al_StartOfOpenWithContextMenuItem%) " """ al_RunItem """"
				Else
					al_RunItem := func_Deref(al_OpenWithApp%al_StartOfOpenWithContextMenuItem%) " " al_RunItem
				Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"... Called from Menu: " al_RunItem)
			}

			If (GetKeyState("Alt") OR (al_ThisMenu="AppLauncherContext" AND InStr(A_ThisMenuItem,lng_al_RunAs)))
			{
				Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"RunAs: " al_RunItem " ... in: " al_RunPath )

				If al_UseRunAsHelper = 0
				{
					al_DllError := DllCall("shell32\ShellExecuteA", uint, 0, str, "RunAs", str, al_RunItem,str, "" , str, al_RunPath, int, 1)
					If al_DllError <= 32
						ErrorLevel = ERROR
				}
				Else
				{
					RunWait, %A_AhkPath% /r "%A_ScriptDir%\Library\RunAsHelper.ahk" "%al_RunItem%", %al_RunPath%, UseErrorLevel
					If (ErrorLevel = ERROR OR ErrorLevel < 0)
						al_DllError =
					Else
					{
						al_DllError = %ErrorLevel%
						If al_DllError <= 32
							ErrorLevel = ERROR
					}
				}
			}
			Else
			{
				Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"Run: " al_RunItem " ... in: " al_RunPath )
				Run, %al_RunItem%, %al_RunPath%, UseErrorLevel
			}
			If ErrorLevel = ERROR
			{
				If (al_DllError = 5)
					Return
				If (al_DllError <> "" AND al_DllError < 33)
					func_GetErrorMessage( al_DllError, al_ScriptName, lng_al_runningError ":`n" al_RunItem "`n`n" )
				Else
					func_GetErrorMessage( A_LastError, al_ScriptName, lng_al_runningError ":`n" al_RunItem "`n`n" )
				StringReplace, al_History, al_History, |%al_IndexItem%|,|, A
				StringSplit, al_UsedItem, al_History, |
				al_History =
				if al_UsedItem0 > %al_MaxLastUsed%
					al_LoopVar = %al_MaxLastUsed%
				else
					al_LoopVar = %al_UsedItem0%
				Loop, %al_LoopVar%
				{
					al_CurrItem := al_UsedItem%A_Index%

					IfEqual, al_CurrItem,, Continue
					al_History = %al_History%|%al_CurrItem%|
				}
				StringReplace, al_History, al_History, ||,|, A
				IniWrite, %al_History%, %ConfigFile_AppLauncher%, History, SearchHistory
				Return
			}
		}
	}
	al_RunItem := al_RunItem_tmp

	If al_HistWithCtrl = 1
	{
		If (!GetKeyState("Ctrl") OR (GetKeyState("Alt") AND GetKeyState("Ctrl")))
			Return
	}
	StringReplace, al_History, al_History, |%al_IndexItem%|,|, A

	al_History = |%al_IndexItem%|%al_History%

	StringSplit, al_UsedItem, al_History, |
	al_History =
	if al_UsedItem0 > %al_MaxLastUsed%
		al_LoopVar = %al_MaxLastUsed%
	else
		al_LoopVar = %al_UsedItem0%
	Loop, %al_LoopVar%
	{
		al_CurrItem := al_UsedItem%A_Index%

		IfEqual, al_CurrItem,, Continue
		al_History = %al_History%|%al_CurrItem%|
	}
	StringReplace, al_History, al_History, ||,|, A
	IniWrite, %al_History%, %ConfigFile_AppLauncher%, History, SearchHistory

	If al_ReIndexOnClose = 1
		SetTimer, al_sub_IndexDirectories2, -50
Return

AppLauncherMainGuiEscape:
ApplauncherMainGuiClose:
	func_RemoveMessage(0x100, "al_sub_Edit1Keys")

	WinGet, al_MinMax, MinMax, ahk_id %al_GuiWinID%
	If al_MinMax <> -1
	{
		WinGetPos al_newWinX,al_newWinY,al_newWinW,al_newWinH, ahk_id %al_GuiWinID% ; nochmals Fenstermaße ermitteln

		If (al_ListOnTop = 1 AND al_newWinH <> al_fullWinH)
			al_newWinY := al_newWinY - al_fullWinH + al_WinFoldH
		If al_newWinY < %MonitorTop%
			al_newWinY := MonitorTop

		IniWrite, x%al_newWinX%, %ConfigFile_AppLauncher%, Window, WindowX
		IniWrite, y%al_newWinY%, %ConfigFile_AppLauncher%, Window, WindowY
	}

	Loop, 3
	{
		al_currCol := A_INDEX - 1
		SendMessage, 0x1000+29, al_currCol , 0, SysListView321, ahk_id %al_GuiWinID% ; LVM_GETCOLUMNWIDTH
		al_Col%A_Index% = %ErrorLevel%
		IniWrite, % al_Col%A_Index%, %ConfigFile_AppLauncher%, Window, Col%A_Index%
	}

	Gui,%GuiID_AppLauncherMain%:Destroy
	al_GuiWinID =
	If al_ReIndexOnClose = 1
		SetTimer, al_sub_IndexDirectories2, -50
Return

al_sub_IndexDirectories2:
	Debug("APPLAUNCHER",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
	If al_ReIndexOnClose =
		Gosub, ApplauncherMainGuiClose
	al_ReIndexOnClose =
	If al_HiddenIndexing > 0
	{
		al_Monitor := func_GetMonitorNumber( "A" )

		al_X := WorkArea%al_Monitor%Right-320-al_BorderHeight*2
		al_Y := WorkArea%al_Monitor%Bottom-58-CaptionHeight-al_BorderHeight*2
		If al_HiddenIndexing < 1
			Progress, P%al_Progress% R0-%al_ProgressMax% x%al_X% y%al_Y% W320 H58 M2 T,, %lng_al_scanning%,ac'tivAid - AppLauncher
		al_HiddenIndexing = 0
	}
	Else
		Gosub, al_sub_IndexDirectories
Return

al_sub_IndexDirectoriesTimer:
	Debug("APPLAUNCHER",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
	al_HiddenIndexing = 1
	Gosub, al_sub_IndexDirectories
	tooltip
	al_HiddenIndexing = 0
Return

al_sub_IndexDirectoriesTimer_Portable:
	Debug("APPLAUNCHER",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
	al_HiddenIndexing = 2
	Gosub, al_sub_IndexDirectories
	tooltip
	al_HiddenIndexing = 0
Return

; ---------------------------------------------------------------------
; -- Verzeichnisse indexieren -----------------------------------------
; ---------------------------------------------------------------------
al_sub_IndexDirectories: ; Verzeichnisse indexieren
	Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"Begin Indexing ... (Hidden=" al_HiddenIndexing ")")

	FileRead, al_ExcludedFiles, %al_IndexPath%\%al_ExcludedFilesFile%
	al_ExcludedFiles := func_Deref(al_ExcludedFiles)

	al_ExcludedFolders =
	Loop, Parse, al_ExcludedFiles, `n, `r
	{
		If (func_StrRight(A_LoopField,1)="\")
			al_ExcludedFolders := al_ExcludedFolders func_EscapeForRegEx(A_LoopField) "|"
	}
	If al_ExcludedFolders <>
		StringTrimRight, al_ExcludedFolders, al_ExcludedFolders, 1

	FileRead, al_CustomNames, %al_IndexPath%\%al_CustomNamesFile%
	al_CustomNames := func_Deref(al_CustomNames)

	StringCaseSense, Locale
	SetTimer, al_sub_IndexDirectories, Off
	;Process,Priority,,N
	al_BatchLines = %A_BatchLines%
	SetBatchLines, 10ms
	If al_HiddenIndexing > 0
		Thread, Priority, -5000000
	Else
		Thread, Priority, -5000

	FileRead, al_ExcludedFiles, %al_IndexPath%\%al_ExcludedFilesFile%
	al_ExcludedFiles := func_Deref(al_ExcludedFiles)

	FileRead, al_CustomNames, %al_IndexPath%\%al_CustomNamesFile%
	al_CustomNames := func_Deref(al_CustomNames)

	StringReplace, al_Temp, al_PathsToIndex, |,, A UseErrorLevel
	al_ProgressPathCount = %ErrorLevel%

	If (al_ProgressLastMax < 1 OR al_ProgressPathCount <> al_ProgressLastPathCount)
	{
		al_ProgressMax := al_ProgressPathCount * 250
		IfInString, al_PathsToIndex, %A_ProgramFiles%
			al_ProgressMax += 1000
	}
	Else
		al_ProgressMax := al_ProgressLastMax
	al_Progress = 0
	al_Monitor := func_GetMonitorNumber( "A" )
	al_X := WorkArea%al_Monitor%Right - 320 - al_BorderHeight * 2
	al_Y := WorkArea%al_Monitor%Bottom - 58 - CaptionHeight - al_BorderHeight * 2
	If al_HiddenIndexing < 1
		Progress, 4:R0-%al_ProgressMax% x%al_X% y%al_Y% W320 H58 M2 T,, %lng_al_scanning%,ac'tivAid - AppLauncher

	Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"Deleting Temp-File")
	FileDelete, %al_IndexPath%\%al_IndexFile%_Portable.tmp
	FileDelete, %al_IndexPath%\%al_IndexFile%%al_IndexFileComputerName%.tmp
	IfNotInString, al_PathsToIndexNoDeref, `%Drive`%
		FileDelete, %al_IndexPath%\%al_IndexFile%_Portable.dat

	Loop, parse, al_PathsToIndexNoDeref, |
	{
		Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"Try to create Index for " A_LoopField)
		al_LoopField := func_Deref(A_LoopField)
		IfNotExist, %al_LoopField%, Continue
		If (InStr(A_LoopField, "%Drive%") AND AHKonUSB = 1)
		{
			If al_HiddenIndexing = 2
				Continue
			al_IndexFileSuffix = _Portable
		}
		Else
			al_IndexFileSuffix = %al_IndexFileComputerName%

		If (func_StrRight(al_LoopField,1)="\")
			StringTrimRight, al_LoopField, al_LoopField, 1

		Debug("APPLAUNCHER",A_LineNumber,A_LineFile,al_LoopField " does exist, indexing ...")

		Loop, %al_LoopField%\*, %al_IndexFolderNames%, 1
		{
			SplitPath, A_LoopFileFullPath, al_FName, al_FDir , al_FExt, al_FNameNoExt
			If al_ExcludedFolders <>
				If (RegExMatch(A_LoopFileFullPath,al_ExcludedFolders))
					Continue

			al_FTargetName =
			If al_FExt = lnk
			{
				FileGetShortcut, %A_LoopFileFullPath%, al_FTargetName
				SplitPath, al_FTargetName,,,al_FExt
				If al_FExt = ico
					al_FExt = lnk
				If al_FTargetName =
				{
					al_FTargetName = %A_LoopFileFullPath%
					al_FExt = exe
				}
			}

			al_FAttrib := FileExist(A_LoopFileFullPath)
			al_FTargetAttrib =
			IfInString, al_FTargetName, :\
				al_FTargetAttrib := FileExist(al_FTargetName)
			Else If al_FTargetName =
				al_FTargetAttrib := FileExist(al_FName)
			Else
				If al_FExt =
					al_FTargetAttrib = D

;         test = %test%`n%al_Fname%`t%al_FTargetAttrib%
;         tooltip,%test% %al_Fname%`t%al_FTargetAttrib%

			Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"Examine: " A_LoopFileFullPath " -> " al_FTargetName)

			If (( (!InStr("|" al_TypeList "|", "|" al_FExt "|") AND !(InStr( al_FTargetAttrib, "D" ) AND al_IndexFolders = 1 )) OR ( InStr( al_FTargetAttrib, "D" ) AND al_IndexFolders = 0 ) OR (al_FTargetAttrib = "" AND al_FTargetName <> "") ) AND !(InStr(al_FAttrib,"D") AND al_IndexFolderNames = 1))
				Continue

			al_FNameLocalized =
			al_FExtLocalized =
			If al_DisableLocalizedNames = 0
				IfNotInString, al_CustomNames, %A_LoopFileFullPath%*
				{
					al_FNameLocalized := GetLocalizedFilename(A_LoopFileFullPath)
					If (al_FExt <> "" AND al_FNameLocalized <> "")
						al_FExtLocalized := "." al_FExt
				}

			If (InStr(al_FName,al_FNameLocalized) OR al_FNameLocalized = "")
				al_LoopFileFullPath := A_LoopFileFullPath
			Else
				al_LoopFileFullPath := A_LoopFileFullPath "*" al_FNameLocalized al_FextLocalized

			al_Cont = 0
			Loop, Parse, al_ExcludeList, |
			{
				IfInString, al_FName, %A_LoopField%
				{
					al_Cont = 1
					Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"Skip: " al_FName " is in ExludeList: " al_ExcludeList)
					Break
				}
			}
			If al_HiddenIndexing < 1
				IfWinExist, ac'tivAid - AppLauncher
					Progress, 4:%al_Progress%
				Else
					al_CancelIndexing = 1

			If al_CancelIndexing = 1
				Break

			al_Progress++

			IfEqual, al_Cont, 1
				Continue

			IfInstring, al_ExcludedFiles, %al_LoopFileFullPath%
				Continue

			IfInString, al_CustomNames, %al_LoopFileFullPath%*
			{
				Loop, Parse, al_CustomNames, `n, `r
				{
					IfInString, A_LoopField, %al_LoopFileFullPath%*
					{
						StringReplace, al_LoopFileFullPath, A_LoopField, %al_LoopFileFullPath%*, %al_LoopFileFullPath%*
						Break
					}
				}
			}

			If (InStr(al_CustomNames, "::"))
			{
				Loop, Parse, al_CustomNames, `n, `r
				{
					If (!InStr(A_LoopField, "::"))
						continue
					StringLeft, al_LoopField, A_LoopField, % InStr(A_LoopField, "::")-1
					If (InStr(al_LoopFileFullPath, al_LoopField))
					{
						StringTrimLeft, al_LoopFilePrefix, A_LoopField, % InStr(A_LoopField, "::")+1
						IfInString, al_LoopFilePrefix, ###
							StringReplace, al_LoopFilePrefix, al_LoopFilePrefix, ###, %al_FNameNoExt%, A
						Else
							al_LoopFilePrefix = %al_LoopFilePrefix% %al_FNameNoExt%
						al_LoopFileFullPath = %al_LoopFileFullPath%*%al_LoopFilePrefix%.%al_FExt%
						Break
					}
				}
			}

			StringReplace, al_LoopFileFullPath, al_LoopFileFullPath, `%, ```%, A

			If al_VariableDriveLetter = 1
				al_LoopFileFullPath := func_ReplaceWithCommonPathVariables(al_LoopFileFullPath)

			Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"### INDEXED: " al_LoopFileFullPath)

			If al_IncludeHiddenFiles = 1
				FileAppend, %al_LoopFileFullPath%`n, %al_IndexPath%\%al_IndexFile%%al_IndexFileSuffix%.tmp
			Else
			{
				FileGetAttrib, fileAttrib, %al_LoopFileFullPath%
				IfNotInString, fileAttrib, H ; EXCLUDE HIDDEN FILE
					FileAppend, %al_LoopFileFullPath%`n, %al_IndexPath%\%al_IndexFile%%al_IndexFileSuffix%.tmp
			}
			If al_CancelIndexing = 1
				Break
		}
	}
	If al_CancelIndexing = 1
	{
		FileDelete, %al_IndexPath%\%al_IndexFile%_Portable.tmp
		FileDelete, %al_IndexPath%\%al_IndexFile%%al_IndexFileComputerName%.tmp
		al_CancelIndexing =
		Return
	}
	FileMove, %al_IndexPath%\%al_IndexFile%_Portable.tmp, %al_IndexPath%\%al_IndexFile%_Portable.dat, 1
	FileMove, %al_IndexPath%\%al_IndexFile%%al_IndexFileComputerName%.tmp, %al_IndexPath%\%al_IndexFile%%al_IndexFileComputerName%.dat, 1
	Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"Created index file from temp file")
	If al_HiddenIndexing < 1
		Progress, 4:Off
	al_ProgressLastMax = %al_Progress%
	al_ProgressLastPathCount = %al_ProgressPathCount%
	IniWrite, %al_ProgressLastMax%,       %ConfigFile_AppLauncher%, Config, LastFileCount
	IniWrite, %al_ProgressLastPathCount%, %ConfigFile_AppLauncher%, Config, LastPathCount
;   Process,Priority,,%A_Priority%
	SetBatchLines, %al_BatchLines%
	IniWrite, %al_RequiredIndexVersion%, %ConfigFile_AppLauncher%, Config, IndexVersion
	Sleep,100
	Debug("APPLAUNCHER",A_LineNumber,A_LineFile,"Finished indexing")
	al_ReIndex =
	IniDelete, %ConfigFile_AppLauncher%, Update, ReIndex
Return

al_sub_GetText:
	StringCaseSense, Locale

	Gui, %GuiID_AppLauncherMain%:Default
	Gui, ListView, al_SelItem
	ControlGetText, al_CurrText, Edit1, ahk_id %al_GuiWinID%
	IfEqual, al_CurrText, %al_LastText%
	{
		al_FinishedSearching = 2
		Return
	}

	al_LastText = %al_CurrText%

	tmp_BatchLines2 = %A_BatchLines%
	SetBatchLines, -1
	tmp_KeyDelay = %A_KeyDelay%
	SetKeyDelay, 0

	IfEqual, al_CurrText,
	{
		IfEqual, al_ShowIcons, 1
		{
			IL_Destroy(ImageListID1)
			ImageListID1 := IL_Create(20, 50)
			LV_SetImageList(ImageListID1)
		}
		LV_Delete()

		al_Count =

		StringTrimLeft, al_History0, al_History, 1
		CoInitialize()
		al_History1 =
		Loop, Parse, al_History0, |
		{
			If A_LoopField =
				Continue

			IfNotEqual, al_CurrText, %al_LastText%
			{
				al_FinishedSearching = 2
				Return
			}

			al_LoopField := A_LoopField
			al_FNameLocalized =
			IfInString, al_LoopField, *
			{
				StringSplit, al_LoopField, al_LoopField, *
				al_LoopField := al_LoopField1
				al_FNameLocalized := al_LoopField2
			}
			al_LoopField := al_LoopField ; ,A_LineNumber A_LoopField)

			al_IconFile := al_LoopField
			SplitPath, al_LoopField, al_FName, al_FDir, al_FExt, al_FNameNoExt

			IfInString, al_FExt, %A_Space%
			{
				al_FName = %al_FNameNoExt%.%al_FExt%
				al_FExt =
				al_FNameNoExt = %al_FName%
			}

			al_Count ++
			If al_Count > %al_MaxLastUsed%
				break

			If al_ShowDate = 1
			{
				FileGetTime, al_FDate, %A_LoopField%
				FormatTime, al_FDateString, %al_FDate%, ShortDate
			}

			al_FCmd := func_StrLeft( al_LoopField, InStr(al_LoopField, "\")-1)
			al_FCmdName := SubStr( al_LoopField, InStr(al_LoopField, "\")+1)

			If (!InStr(al_FDir,"\") AND IsLabel(al_FDir))
			{
				al_IconFile := ScriptOnIcon ; small (in history list)
			}
			Else If (IsLabel(al_FCmd))
			{
				al_FDir := al_FCmd
				al_FNameNoExt := al_FCmdName
				al_IconFile := ScriptOnIcon ;unknown (small because of previous)
			}
			Else If (!FileExist( al_LoopField ) AND FileExist( al_FDir ))
			{
				al_IconFile = %al_FDir%
			}
			Else IfNotExist %al_LoopField%
			{
				al_IconFile = shell32.dll,24
				Loop, Parse, PATH, `;
				{
					IfExist, %A_LoopField%\%al_LoopField%
					{
						al_FDir := A_LoopField
						al_IconFile := A_LoopField "\" al_LoopField
						al_LoopField := al_IconFile
						Break
					}
				}
			}
			Else If (!InStr(al_FDir,"\") AND al_FName = "")
			{
				al_IconFile = %al_FDir%\
				al_FNameNoExt = %al_FDir%
				al_FDir =
			}

			If al_ShowIcons = 1
			{
				hIcon = 0
				al_IconFile2 = 0
				al_IconFileFull := al_IconFile
				RegexMatch(al_IconFile ",0", "^(.+?),([0-9]+?)(,[0-9]+?)?$", al_IconFile)
				If al_IconFile =
				{
					al_IconFile := al_IconFileFull
					al_IconFile1 := al_IconFileFull
				}
				If al_IconFile2 = 0
					if DllCall("Shell32\SHGetFileInfoA", "str", al_IconFile1, "uint", 0, "str", al_sfi, "uint", al_sfi_size, "uint", 0x101)  ; load small icon
					{
						Loop 4
							hIcon += *(&al_sfi + A_Index-1) << 8*(A_Index-1)
					}
				If hIcon = 0
					hIcon := DllCall("shell32\ExtractAssociatedIconA", "UInt", 0, "Str", al_IconFile1, "UShortP", al_IconFile2)

				DllCall("ImageList_ReplaceIcon", UInt, ImageListID1, Int, -1, UInt, hIcon)
				DllCall("DestroyIcon", Uint, hIcon)
			}
			If al_FNameLocalized <>
			{
				al_FDir = %al_FDir%\%al_FName%
				SplitPath, al_FNameLocalized, ,, , al_FNameNoExt
			}
			If al_ModifyColumns = 1
				LV_Add("Icon" al_Count, al_FNameNoExt, " " al_FExt "  ", al_FDateString, al_FDir, al_FDate )
			Else
				LV_Add("Icon" al_Count, al_FNameNoExt, " " al_FExt, al_FDateString, al_FDir, al_FDate )

			If A_Index = 1
			{
				ControlSend, SysListView321, {Down}, ahk_id %al_GuiWinID%
				ControlSetText, Edit2, %al_FNameNoExt%, ahk_id %al_GuiWinID%
			}
			IfNotInstring, al_History1, |%al_LoopField%|
				al_History1 = %al_History1%|%al_LoopField%|

			If (al_SimpleView = 0 AND al_ModifyColumns = 1)
			{
				LV_ModifyCol()
			}

		}
		al_FNameLen =
		StringReplace, al_History, al_History1, ||, |, A
		CoUnInitialize()
		If al_SortResult = 1
		{
			If al_ShowDate = 1
				LV_ModifyCol(5, "SortDesc")
			Else
				LV_ModifyCol(1, "Sort")
			ControlSend, SysListView321, {Home}, ahk_id %al_GuiWinID%
		}
	}

	IfNotEqual, al_CurrText,
	{
		al_count_hits = 0
		al_MatchPList =
		al_MatchFName  = |                                 ;<==
		al_Count =
		al_SearchList = %al_History%|%al_ItemList%|%al_PathsToIndex%
		al_CheckList =

		Loop, Parse, al_SearchList, |
		{
			If A_LoopField =
				continue
			ControlGetText, al_CurrText, Edit1, ahk_id %al_GuiWinID%
			IfNotEqual, al_CurrText, %al_LastText%
			{
				al_FinishedSearching = 2
				Return
			}
			al_CurrItem1 = %A_LoopField%
			al_CheckList = %al_MatchPList%|
			IfInString, al_CheckList, |%al_CurrItem1%|, Continue

			SplitPath, al_CurrItem1, al_FName,,,al_FNameNoExtDuplicates ;, al_FDir, al_FExt, al_FNameNoExt, FDrive ;<==

			If (func_WildcardMatch(" " func_RemovePunctuation(al_FName," ",0), " " func_RemovePunctuation(al_CurrText," ",1)))
			{
				If al_FilterDuplicates = 1
				{
					IfInString, al_MatchFName, |%al_FName%|, Continue ;<==
					al_MatchFName = %al_MatchFName%%al_FName%|
				}

				al_MatchPList = %al_MatchPList%|%al_CurrItem1%
				al_count_hits++
				if al_count_hits >= %al_MaxHits%
					break
				Continue
			}
		}

		If al_SearchFromBeginning = 0
		{
			If al_count_hits < %al_MaxHits%
			{
				Loop, Parse, al_SearchList, |
				{
					ControlGetText, al_CurrText, Edit1, ahk_id %al_GuiWinID%
					IfNotEqual, al_CurrText, %al_LastText%
					{
						al_FinishedSearching = 2
						Return
					}

					al_CurrItem = %A_LoopField%
					al_CheckList = %al_MatchPList%|
					IfInString, al_CheckList, |%al_CurrItem%|, Continue

					SplitPath, al_CurrItem, al_FName,,,al_FNameNoExtDuplicates ;, al_FDir, al_FExt, al_FNameNoExt, FDrive ;<==

					MatchFound = Y
					; Sucheingabenteile in Dateiname enthalten
					Loop, Parse, al_CurrText, %A_Space%
						IfNotInString, al_FName, %A_LoopField%
							MatchFound = N

					IfEqual, MatchFound, Y
					{
						if al_FilterDuplicates = 1
						{
							IfInString, al_MatchFName, |%al_FName%|, Continue
							al_MatchFName = %al_MatchFName%%al_FName%|
						}
						al_MatchPList = %al_MatchPList%|%al_CurrItem%
						al_count_hits++
						if al_count_hits >= %al_MaxHits%
							break
						Continue
					}
				}
			}
		}

		If ((al_PhoneticSearch = 1 ) OR al_count_hits = 0)
		{
			Loop, Parse, al_SearchList, |
			{
				If A_LoopField =
					continue
				ControlGetText, al_CurrText, Edit1, ahk_id %al_GuiWinID%
				IfNotEqual, al_CurrText, %al_LastText%
				{
					al_FinishedSearching = 2
					Return
				}
				al_CurrItem1 = %A_LoopField%
				al_CheckList = %al_MatchPList%|
				IfInString, al_CheckList, |%al_CurrItem1%|, Continue

				SplitPath, al_CurrItem1, al_FName,,,al_FNameNoExtDuplicates ;, al_FDir, al_FExt, al_FNameNoExt, FDrive ;<==

				al_phoneticCurrText := func_MetaSoundex(al_CurrText,"RemovePunctuation:space")
				al_phoneticFName := func_MetaSoundex(al_FName,"RemovePunctuation:space")

				If (InStr(" " al_phoneticFName, " " al_phoneticCurrText) OR InStr("-" al_FName, "-" al_CurrText))
				{
					If al_FilterDuplicates = 1
					{
						IfInString, al_MatchFName, |%al_FName%|, Continue ;<==
						al_MatchFName = %al_MatchFName%%al_FName%|
					}

					al_MatchPList = %al_MatchPList%|%al_CurrItem1%
					al_count_hits++
					if al_count_hits >= %al_MaxHits%
						break
					Continue
				}
			}
		}

		IfEqual, al_ShowIcons, 1
		{
			IL_Destroy(ImageListID1)
			ImageListID1 := IL_Create(al_count_hits, 50, 0)
			LV_SetImageList(ImageListID1,1)
		}
		LV_Delete()

		StringTrimLeft, al_MatchPList, al_MatchPList, 1

		al_Count =
		Loop, Parse, al_MatchPList, |
		{
			al_LoopField := A_LoopField
			al_FNameLocalized =
			IfInString, al_LoopField, *
			{
				StringSplit, al_LoopField, al_LoopField, *
				al_LoopField := al_LoopField1
				al_FNameLocalized := al_LoopField2
			}

			al_IconFile := al_LoopField
			ControlGetText, al_CurrText, Edit1, ahk_id %al_GuiWinID%
			IfNotEqual, al_CurrText, %al_LastText%
			{
				al_FinishedSearching = 2
				Return
			}

			al_Count ++
			SplitPath, al_LoopField, al_FName, al_FDir, al_FExt, al_FNameNoExt, al_FDrive

			IfInString, al_FExt, %A_Space%
			{
				al_FName = %al_FNameNoExt%.%al_FExt%
				al_FExt =
				al_FNameNoExt = %al_FName%
			}

			al_FCmd := func_StrLeft( al_LoopField, InStr(al_LoopField, "\")-1)
			al_FCmdName := SubStr( al_LoopField, InStr(al_LoopField, "\")+1)

			If (!InStr(al_FDir,"\") AND IsLabel(al_FDir))
			{
				al_IconFile := ScriptOnIcon ; small (in list after search)
			}
			Else If (IsLabel(al_FCmd))
			{
				al_FDir := al_FCmd
				al_FNameNoExt := al_FCmdName
				al_IconFile := ScriptOnIcon ; unknown switched because previous
			}
			Else If (!FileExist( al_LoopField ) AND FileExist( al_FDir ))
			{
				al_IconFile = %al_FDir%
			}
			Else IfNotExist %al_LoopField%
			{
				al_IconFile = shell32.dll,24
				Loop, Parse, PATH, `;
				{
					IfExist, %A_LoopField%\%al_LoopField%
					{
						al_FDir := A_LoopField
						al_IconFile := A_LoopField "\" al_LoopField
						al_LoopField := al_IconFile
						Break
					}
				}
			}
			Else If (!InStr(al_FDir,"\") AND al_FName = "")
			{
				al_IconFile = %al_FDir%\
				al_FNameNoExt = %al_FDir%
				al_FDir =
			}

			If al_ShowDate = 1
			{
				FileGetTime, al_FDate, %A_LoopField%
				FormatTime, al_FDateString, %al_FDate%, ShortDate
			}
			If (!FileExist( al_LoopField ) AND FileExist( al_FDir ))
			{
				al_IconFile := al_FDir
			}
			IfEqual, al_ShowIcons, 1
			{
				CoInitialize()
				hIcon = 0
				al_IconFile2 = 0
				al_IconFileFull := al_IconFile
				RegexMatch(al_IconFile ",0", "^(.+?),([0-9]+?)(,[0-9]+?)?$", al_IconFile)
				If al_IconFile =
				{
					al_IconFile := al_IconFileFull
					al_IconFile1 := al_IconFileFull
				}
				If al_IconFile2 = 0
					If DllCall("Shell32\SHGetFileInfoA", "str", al_IconFile1, "uint", 0, "str", al_sfi, "uint", al_sfi_size, "uint", 0x101)  ; load small icon
					{
						Loop 4
							hIcon += *(&al_sfi + A_Index-1) << 8*(A_Index-1)
					}
				If hIcon = 0
					hIcon := DllCall("shell32\ExtractAssociatedIconA", "UInt", 0, "Str", al_IconFile1, "UShortP", al_IconFile2)

				DllCall("ImageList_ReplaceIcon", UInt, ImageListID1, Int, -1, UInt, hIcon)
				DllCall("DestroyIcon", Uint, hIcon)
				CoUnInitialize()
			}
			If al_FNameLocalized <>
			{
				al_FDir = %al_FDir%\%al_FName%
				SplitPath, al_FNameLocalized, ,, , al_FNameNoExt
			}
			If al_ModifyColumns = 1
				LV_Add("Icon" al_Count, al_FNameNoExt, " " al_FExt "  ", al_FDateString, al_FDir, al_FDate )
			Else
				LV_Add("Icon" al_Count, al_FNameNoExt, " " al_FExt, al_FDateString, al_FDir, al_FDate )

			IfEqual, A_Index, 1
			{
				ControlSend, SysListView321, {Down}, ahk_id %al_GuiWinID%
				ControlSetText, Edit2, %al_FNameNoExt%, ahk_id %al_GuiWinID%
			}
		}
		If al_Count =
			LV_Delete()
		if al_SortResult = 1
		{
			If al_ShowDate = 1
				LV_ModifyCol(5, "SortDesc")
			Else
				LV_ModifyCol(1, "Sort")
			ControlSend, SysListView321, {Home}, ahk_id %al_GuiWinID%
		}
	}
	If al_Count <>
		gosub, al_sub_FileName2TextField
	Else
	{
		ControlSetText, Static3,, ahk_id %al_GuiWinID%
		GuiControl,Hide, Static2,
	}

	SetBatchLines, %tmp_BatchLines2%
	SetKeyDelay, %tmp_KeyDelay%

	If (al_Count >= 1 and al_ModifyColumns = 1 and al_SimpleView = 0)
		LV_ModifyCol()

	If al_CurrText =
		Gosub, al_sub_Fold
	Else
		Gosub, al_sub_UnFold

	al_FinishedSearching = 1
Return

al_sub_Fold:
	If (al_SimpleView <> 1 OR al_ReducedSimpleView <> 1)
		Return
	WinGetPos, al_newWinX, al_newWinY, al_newWinW, al_newWinH, ahk_id %al_GuiWinID%
	Gui, %GuiID_AppLauncherMain%:Default
	al_Monitor := func_GetMonitorNumber( "ahk_id " al_GuiWinID )

	If (al_ListOnTop = 1 AND al_newWinH <> al_WinFoldH)
		al_newWinY := al_newWinY + al_newWinH - al_WinFoldH
	If (al_newWinY+al_WinFoldH > Monitor%al_Monitor%Bottom)
		al_newWinY := Monitor%al_Monitor%Bottom-al_WinFoldH
	WinMove, ahk_id %al_GuiWinID%,,,%al_newWinY%,, %al_WinFoldH%
Return

al_sub_UnFold:
	If (al_SimpleView <> 1 OR al_ReducedSimpleView <> 1)
		Return
	WinGetPos, al_newWinX, al_newWinY, al_newWinW, al_newWinH, ahk_id %al_GuiWinID%
	Gui, %GuiID_AppLauncherMain%:Default
	al_Monitor := func_GetMonitorNumber( "ahk_id " al_GuiWinID )

	If (al_ListOnTop = 1 AND al_newWinH <> al_fullWinH)
		al_newWinY := al_newWinY - al_fullWinH + al_WinFoldH
	If ( al_newWinY < Monitor%al_Monitor%Top )
		al_newWinY := Monitor%al_Monitor%Top
	WinMove, ahk_id %al_GuiWinID%,,,%al_newWinY%, %al_fullWinW%, %al_fullWinH%
Return

al_build_ItemList:
	al_ItemIndexList =
	If al_ReIndex =
	{
		Loop, Read, %al_IndexPath%\%al_IndexFile%%al_IndexFileComputerName%.dat
		{
			IfEqual, A_LoopReadLine,, Continue
			IfInString, al_ExcludedFiles, %A_LoopReadLine%, Continue
			IfInString, A_LoopReadLine, `%
				al_ItemIndexList := al_ItemIndexList "|" func_Deref(A_LoopReadLine)
			Else
				al_ItemIndexList = %al_ItemIndexList%|%A_LoopReadLine%
		}
		Loop, Read, %al_IndexPath%\%al_IndexFile%_Portable.dat
		{
			IfEqual, A_LoopReadLine,, Continue
			IfInString, al_ExcludedFiles, %A_LoopReadLine%, Continue
			IfInString, A_LoopReadLine, `%
				al_ItemIndexList := al_ItemIndexList "|" func_Deref(A_LoopReadLine)
			Else
				al_ItemIndexList = %al_ItemIndexList%|%A_LoopReadLine%
		}
	}
Return

al_sub_Edit1Keys:
	Gui, %GuiID_AppLauncherMain%:Default
	Gui, ListView, al_SelItem

	al_Key = %#wParam%
	If (A_GuiControl <> "al_FindString" AND A_GuiControl <> "al_SelItem")
		return

	GetKeyState, al_CtrlStateTmp, Ctrl
	If al_CtrlStateTmp = D
		al_Key := al_Key + 1000
	GetKeyState, al_ShiftState, Shift
	If al_ShiftState = D
		al_Key := al_Key + 2000
	GetKeyState, al_AltState, Alt
	If al_AltState = D
		al_Key := al_Key + 4000

	; tooltip, %al_Key%`n%A_GuiControl%`n%A_GuiEvent%
	If al_Key = 113
	{
		func_RemoveMessage(0x100, "al_sub_Edit1Keys")
		If A_GuiControl = al_FindString
		{
			GuiControl, %GuiID_AppLauncherMain%:Focus, al_SelItem
			Send, {F2}
		}
		Return
	}

	If (A_GuiControl <> "al_FindString" AND al_Key <> 1017 AND al_Key <> 2016)
	{
		GuiControl, %GuiID_AppLauncherMain%:Focus, al_FindString
		SetFormat, integer, hex
		al_KeyHex := al_Key+0
		SetFormat, integer, d

		If (al_Key < 1000)
			Send, {vk%al_KeyHex%}
	}

	If al_Key = 33
	{
		gosub, al_sub_UnFold
		IfWinNotActive, ahk_id %al_GuiWinID%,
		{
			Send, {PgUp}
			Return
		}
		ControlGetFocus, CurrCtrl, ahk_id %al_GuiWinID%
		IfEqual, CurrCtrl, Edit1
			ControlSend, SysListView321, {PgUp}, ahk_id %al_GuiWinID%

		gosub, al_sub_FileName2TextField

		#Return = 0
	}
	If al_Key = 34
	{
		gosub, al_sub_UnFold
		sleep,20
		IfWinNotActive, ahk_id %al_GuiWinID%,
		{
			Send, {PgDn}
			Return
		}
		ControlGetFocus, CurrCtrl, ahk_id %al_GuiWinID%
		IfEqual, CurrCtrl, Edit1
			ControlSend, SysListView321, {PgDn}, ahk_id %al_GuiWinID%

		gosub, al_sub_FileName2TextField

		#Return = 0
	}
	If al_Key = 1035
	{
		gosub, al_sub_UnFold
		IfWinNotActive, ahk_id %al_GuiWinID%,
		{
			Send, {End}
			Return
		}
		ControlGetFocus, CurrCtrl, ahk_id %al_GuiWinID%
		IfEqual, CurrCtrl, Edit1
			ControlSend, SysListView321, {End}, ahk_id %al_GuiWinID%

		gosub, al_sub_FileName2TextField

		#Return = 0
	}
	If al_Key = 1036
	{
		gosub, al_sub_UnFold
		IfWinNotActive, ahk_id %al_GuiWinID%,
		{
			Send, {Home}
			Return
		}
		ControlGetFocus, CurrCtrl, ahk_id %al_GuiWinID%
		IfEqual, CurrCtrl, Edit1
			ControlSend, SysListView321, {Home}, ahk_id %al_GuiWinID%

		gosub, al_sub_FileName2TextField

		#Return = 0
	}
	If al_Key = 40
	{
		gosub, al_sub_UnFold
		If al_newWinH <> %al_WinFoldH%
		{
			IfWinNotActive, ahk_id %al_GuiWinID%,
			{
				Send, {Down}
				Return
			}
			ControlGetFocus, CurrCtrl, ahk_id %al_GuiWinID%
			IfEqual, CurrCtrl, Edit1
				ControlSend, SysListView321, {Down}, ahk_id %al_GuiWinID%

			gosub, al_sub_FileName2TextField
		}

		#Return = 0
	}
	If al_Key = 38
	{
		gosub, al_sub_UnFold
		If al_newWinH <> %al_WinFoldH%
		{
			IfWinNotActive, ahk_id %al_GuiWinID%,
			{
				Send, {Up}
				Return
			}
			ControlGetFocus, CurrCtrl, ahk_id %al_GuiWinID%
			IfEqual, CurrCtrl, Edit1
				ControlSend, SysListView321, {Up}, ahk_id %al_GuiWinID%

			gosub, al_sub_FileName2TextField
		}

		#Return = 0
	}
	If al_Key in 1082,116
	{
		Gosub, ApplauncherMainGuiClose
		Gosub, al_sub_IndexDirectories
		#Return = 0
	}
	If ((al_Key = 1067 AND A_GuiControl <> "al_FindString"))
	{
		Gosub, al_sub_CopyPath
		#Return = 0
	}
	If (al_Key = 3067)
	{
		Gosub, al_sub_CopyLinkPath
		#Return = 0
	}

	If al_Key = 1046 ; Delete
	{
		IfWinNotActive, ahk_id %al_GuiWinID%,, Return
		ControlGetText, al_CurrText, Edit1, ahk_id %al_GuiWinID%

		al_SelItem := LV_GetNext()
		LV_GetText(al_FName, al_SelItem, 1)
		LV_GetText(al_FExt, al_SelItem, 2)
		AutoTrim, On
		al_FExt = %al_FExt%
		LV_GetText(al_FDir, al_SelItem, 4)
		LV_Delete(al_SelItem)
		LV_Modify(al_SelItem,"Select")

		If al_FDir =
		{
			If al_FExt =
				al_Pth = %al_FName%
			Else
				al_Pth = %al_FName%.%al_FExt%
		}
		Else
		{
			If al_FExt =
				al_Pth = %al_FDir%\%al_FName%
			Else
				al_Pth = %al_FDir%\%al_FName%.%al_FExt%
		}
		If (StrLen(al_Pth) = 2 AND func_StrRight(al_Pth,1) = ":" AND !InStr(al_History,"|" al_pth "|"))
			al_Pth = %al_Pth%\

		al_PthDeref := al_Pth

		If al_VariableDriveLetter = 1
			al_Pth := func_ReplaceWithCommonPathVariables(al_Pth)

		StringReplace, al_History, al_History, |%al_PthDeref%|,|, A
		StringReplace, al_History, al_History, ||,|, A
		IniWrite, %al_History%, %ConfigFile_AppLauncher%, History, SearchHistory
		al_LastText = fadsfSDFDFasdFdfsadfsadFDSFDf

		If al_CurrText <>
		{
			StringReplace, al_ItemList, al_ItemList, |%al_PthDeref%|,|, A
			StringReplace, al_ItemList, al_ItemList, ||,|, A
			FileDelete, %al_IndexPath%\%al_IndexFile%%al_IndexFileComputerName%.tmp
			FileDelete, %al_IndexPath%\%al_IndexFile%_Portable.tmp
			Loop, Read, %al_IndexPath%\%al_IndexFile%%al_IndexFileComputerName%.dat, %al_IndexPath%\%al_IndexFile%%al_IndexFileComputerName%.tmp
			{
				IfEqual, A_LoopReadLine,, Continue
				If A_LoopReadLine <> %al_Pth%
					FileAppend, %A_LoopReadLine%`n
			}
			FileMove, %al_IndexPath%\%al_IndexFile%%al_IndexFileComputerName%.tmp, %al_IndexPath%\%al_IndexFile%%al_IndexFileComputerName%.dat, 1
			Loop, Read, %al_IndexPath%\%al_IndexFile%_Portable.dat, %al_IndexPath%\%al_IndexFile%_Portable.tmp
			{
				IfEqual, A_LoopReadLine,, Continue
				If A_LoopReadLine <> %al_Pth%
					FileAppend, %A_LoopReadLine%`n
			}
			FileMove, %al_IndexPath%\%al_IndexFile%_Portable.tmp, %al_IndexPath%\%al_IndexFile%_Portable.dat, 1
			IfNotInstring, al_ExcludedFiles, %al_Pth%
			{
				StringReplace, al_ExcludedFiles, al_ExcludedFiles,%al_Pth%`n,,A
				al_ExcludedFiles = %al_ExcludedFiles%%al_Pth%`n
				FileAppend, %al_Pth%`n, %al_IndexPath%\%al_ExcludedFilesFile%
				al_ExcludedFiles := func_Deref(al_ExcludedFiles)
			}
		}

		#Return = 0
	}
	al_SelItem := LV_GetNext()
Return

al_sub_CopyLinkPath:
	If al_Args =
		Clipboard = %al_FirstHit%
	Else
		Clipboard = %al_FirstHit% %al_Args%
Return

al_sub_Properties:
	Run, Properties %al_FirstHit%,,,UseErrorLevel
Return

al_sub_AddToUserHotkeys:
	Gui, %GuiID_AppLauncherMain%:Default
	Gui, %GuiID_AppLauncherMain%:ListView,al_SelItem

	ControlGetText, al_CurrText, Edit1, ahk_id %al_GuiWinID%

	al_SelItem := LV_GetNext()
	LV_GetText(al_FName, al_SelItem, 1)
	LV_GetText(al_FExt, al_SelItem, 2)
	AutoTrim, On
	al_FExt = %al_FExt%
	LV_GetText(al_FDir, al_SelItem, 4)

	If al_FDir =
	{
		If al_FExt =
			al_Pth = %al_FName%
		Else
			al_Pth = %al_FName%.%al_FExt%
	}
	Else
	{
		If al_FExt =
			al_Pth = %al_FDir%\%al_FName%
		Else
			al_Pth = %al_FDir%\%al_FName%.%al_FExt%
	}
	If (StrLen(al_Pth) = 2 AND func_StrRight(al_Pth,1) = ":" AND !InStr(al_History,"|" al_Pth "|"))
		al_Pth = %al_Pth%\

	If MainGuiVisible <>
	{
		GuiDefault("activAid")
		Gui, ListView, OptionsListBox
		LV_Modify( GuiTabs[UserHotkeys], "Select Focus")
		Gosub, sub_OptionsListBox
	}
	Else
	{
		SimpleMainGUI = UserHotkeys
		Gosub, sub_MainGUI
	}
	;msgbox, %al_FName%`n%al_Pth%

	Gui, %GuiID_activAid%:Default
	Gui, ListView, uh_ListView

	Hotkey_uh_Hotkey =
	uh_Description := al_FName
	uh_Category =
	uh_Path := al_Pth
	uh_Num =
	uh_App =

	uh_NumHotkeys_new++
	LV_Add("Select", "", "", uh_Description, uh_Category, uh_Path, uh_NumHotkeys_new, uh_App)
	uh_LVrow := LV_GetNext()
	uh_EditTitle = %lng_uh_Add%
	Hotkey_uh_Hotkey%uh_NumHotkeys_new%_Sub = sub_Hotkey_UserHotkey
	HotkeyClasses_uh_Hotkey%uh_NumHotkeys_new% = ,
	Gosub, uh_sub_EditHotkey%A_EmptyVar%
Return

al_sub_CopyPath:
	Gui, %GuiID_AppLauncherMain%:Default
	Gui, %GuiID_AppLauncherMain%:ListView,al_SelItem

	ControlGetText, al_CurrText, Edit1, ahk_id %al_GuiWinID%

	al_SelItem := LV_GetNext()
	LV_GetText(al_FName, al_SelItem, 1)
	LV_GetText(al_FExt, al_SelItem, 2)
	AutoTrim, On
	al_FExt = %al_FExt%
	LV_GetText(al_FDir, al_SelItem, 4)

	If al_FDir =
	{
		If al_FExt =
			al_Pth = %al_FName%
		Else
			al_Pth = %al_FName%.%al_FExt%
	}
	Else
	{
		If al_FExt =
			al_Pth = %al_FDir%\%al_FName%
		Else
			al_Pth = %al_FDir%\%al_FName%.%al_FExt%
	}
	If (StrLen(al_Pth) = 2 AND func_StrRight(al_Pth,1) = ":" AND !InStr(al_History,"|" al_Pth "|"))
		al_Pth = %al_Pth%\

	Clipboard = %al_Pth%
Return

al_sub_FileName2TextField:
	Gui, %GuiID_AppLauncherMain%:Default
	Gui, ListView, al_SelItem

	al_FDir =
	al_FName =
	al_FExt =
	al_FirstHit =
	al_Args =
	al_SelItem := LV_GetNext()
	If al_SelItem <> 0
	{
		LV_GetText(al_FName, al_SelItem, 1)
		LV_GetText(al_FExt, al_SelItem, 2)
		AutoTrim, On
		al_FExt = %al_FExt%
		LV_GetText(al_FDir, al_SelItem, 4)
		If al_FExt =
			al_FirstHit = %al_FDir%\%al_FName%
		Else
			al_FirstHit = %al_FDir%\%al_FName%.%al_FExt%
	}

	If (!InStr(al_FDir,"\") AND IsLabel(al_FDir))
	{
		al_FirstHit := ScriptIcon ; large (List after search)
	}
	If (!FileExist( al_FirstHit ) AND FileExist( al_FDir ))
	{
		al_FirstHit := al_FDir
	}

	IfNotExist, %al_FirstHit%
	{
		If al_SimpleView <> 1
		{
			ControlSetText, Static3,, ahk_id %al_GuiWinID%
			GuiControl,Hide, Static2,
		}
		return
	}

	al_OutIconNum =
	If al_FExt = lnk
	{
		al_FirstHitShortCut = %al_FirstHit%
		FileGetShortcut, %al_FirstHit%, al_FirstHit,,al_Args,, al_OutIcon, al_OutIconNum
		If al_FirstHit =
			al_FirstHit = %al_FirstHitShortCut%
		SplitPath, al_FirstHit,,,al_FExt
	}

	If al_SimpleView = 1
		Return

	If (al_ShowLinkTarget = 1 AND FileExist(al_FirstHit) AND al_FirstHit <> ScriptIcon)
	{
		ControlSetText, Static3, %al_FName% - %al_FirstHit% %al_Args%, ahk_id %al_GuiWinID%
	}
	Else
		ControlSetText, Static3, %al_FName%, ahk_id %al_GuiWinID%

	If al_ShowBigIcons = 1
	{
		CoInitialize()
		GuiControl,Show, Static2,
		If al_IconsWithAPI = 1
; ------------------------------------------------------------------------------
; ICON PER WIN32-API
; ------------------------------------------------------------------------------
		{
			IfExist, %al_FirstHit%
			{
				if al_FirstTimeIcon =
				{
					GuiControl,, Static2, *w32 *h-1 *icon0 %A_WinDir%\System32\shell32.dll
					al_FirstTimeIcon = 0
				}
				ControlGet, ControlHwnd, Hwnd,, Static2, ahk_id %al_GuiWinID%
				if (al_OutIconNum <= 0 or al_OutIconNum = "")
					al_OutIconNum = 0
				else
					al_OutIconNum--

				If al_FirstHit =
				{
					hIcon := DllCall("shell32\ExtractAssociatedIconA", "UInt", 0, "Str", A_WinDir "System32\shell32.dll", "UShortP", 3)
				}
				else
				{
					hIcon := DllCall("shell32\ExtractAssociatedIconA", "UInt", 0, "Str", al_FirstHit, "UShortP", 0)
				}
				If al_FirstHit contains gerä
					tooltip, %al_FirstHit% %hIcon% %al_FirstHitShortcut% %al_FExt%
				if hIcon not in 0,1
					SendMessage, 0x0172, 1, hIcon, , ahk_id %ControlHwnd%
				else
					GuiControl,, Static2, *w32 *h-1 *icon0 %A_WinDir%\System32\shell32.dll
				DllCall("DestroyIcon", Uint, hIcon)
			}
			else
				GuiControl,, Static2, *w32 *h-1 *icon0 %A_WinDir%\System32\shell32.dll
		}
		Else
; ------------------------------------------------------------------------------
; ICON SOZUSAGEN "MANUELL" ERMITTELN
; ------------------------------------------------------------------------------
		{
; Icon NICHT aus dem Shortcut ermittelt
			If al_OutIconNum =
			{
; Standard-Icon-Container: ...\System32\shell32.dll
				al_OutIcon = %A_WinDir%\System32\shell32.dll
; Icon für Ordner-Verknüpfungen, z.B. aus dem Recent-Ordner
				If al_FExt =
					al_OutIconNum = 4
; Icon für .exe bzw. .dll-Dateien
				Else If al_FExt in EXE,DLL
				{
					al_OutIconNum = 0
					hIcon := DllCall("Shell32\ExtractIconA", UInt, 0, Str, al_FirstHit, UInt, al_OutIconNum)
					If hIcon <> 0
					{
						al_OutIcon = %al_FirstHit%
						al_OutIconNum++
					}
					Else
					{
						al_OutIconNum = 72
						if al_FExt in EXE
							al_OutIconNum = 3
					}
					DllCall("DestroyIcon", Uint, hIcon)
				}
; Icon für Grafikdateien
				Else If al_FExt in ICO,CUR,ANI,CPL,SCR
				{
					al_OutIconNum = 1
					al_OutIcon = %al_FirstHit%
				}
; Icon für alle anderen aus der Registrierung ermitteln
				Else
				{
;       msgbox, %al_FirstHit%-%al_FExt% : %al_OutIcon%-%al_OutIconNum%
					al_OutIconNum = 0
					Gosub, al_ReadIconFromRegistry
				}
			}
; Icon aus dem Shortcut ermittelt
			Else
			{
				al_OutIconNum--
				hIcon := DllCall("Shell32\ExtractIconA", UInt, 0, Str, al_OutIcon, UInt, al_OutIconNum)
				al_OutIconNum++
				If hIcon = 0
				{
					al_OutIconNum = 0
					al_OutIcon = %A_WinDir%\System32\shell32.dll
					If al_FExt not in EXE
						Gosub, al_ReadIconFromRegistry
					Else
						al_OutIconNum = 3
				}
				DllCall("DestroyIcon", Uint, hIcon)
			}
			GuiControl,, Static2, *w32 *h-1 *icon%al_OutIconNum% %al_OutIcon%
		}
		CoUnInitialize()
	}
Return

al_sub_ClearHistory:
	al_History =
	IniWrite, %al_History%, %ConfigFile_AppLauncher%, History, SearchHistory
Return

al_ReadIconFromRegistry:
	RegRead, al_OutDefaultIcon, HKEY_CLASSES_ROOT, .%al_FExt%\DefaultIcon
	if ErrorLevel = 1
	{
		RegRead, al_OutDefaultIcon, HKEY_CLASSES_ROOT, .%al_FExt%
		RegRead, al_OutDefaultIcon, HKEY_CLASSES_ROOT, %al_OutDefaultIcon%\DefaultIcon
	}
	if ErrorLevel = 0
	{
		al_OutDefaultIcon2 = 0
		StringSplit, al_OutDefaultIcon, al_OutDefaultIcon, `,
		StringReplace, al_OutDefaultIcon1, al_OutDefaultIcon1, `",, a
		VarSetCapacity(al_OutIcon, 255)
		DllCall("kernel32\ExpandEnvironmentStrings", "Str", al_OutDefaultIcon1, "Str", al_OutIcon, "UInt", 255)
		al_OutIconNum := al_OutDefaultIcon2 + 1
	}
Return

al_sub_IndexToHistory:
	Gui, %GuiID_activAid%:+OwnDialogs
	Gui, %GuiID_activAid%:+Disabled
	al_History = |
	al_tmpIndex = 0
	Gosub, al_build_ItemList
	Loop, Parse, al_ItemIndexList, |
	{
		If A_LoopField =
			continue
		SplitPath, A_LoopField, al_tmpName
		If ( !InStr( al_History, "\" al_tmpName "|") )
		{
			al_History = %al_History%%A_LoopField%|
			al_tmpIndex++
		}
	}
	IniWrite, %al_History%, %ConfigFile_AppLauncher%, History, SearchHistory
	msgbox, 68, %al_Titel%, %lng_al_IndexToHistoryDone% (%al_tmpIndex%)
	Gui, %GuiID_activAid%:-Disabled
	IfMsgBox, Yes
	{
		GuiControl, %GuiID_activAid%:Text, al_MaxLastUsed, %al_tmpIndex%
		func_SettingsChanged( al_ScriptName )
	}
Return

AfterLoadingProcess_AppLauncher:
	IniRead, al_CheckRegistry, %ConfigFile_AppLauncher%, Config, DontCheckForCorruptRegistry, 0
	If al_CheckRegistry = 1
		Return
	RegRead, al_dotLnk, HKEY_CLASSES_ROOT, .lnk
	RegRead, al_lnkfile, HKEY_CLASSES_ROOT, lnkfile\CLSID
	If (al_dotLnk <> "lnkfile" OR al_lnkfile <> "{00021401-0000-0000-C000-000000000046}")
	{
		MsgBox, 49, %al_Titel%, %lng_al_CorruptRegistry%`n`n%lng_al_AskRepairRegistry%
		IfMsgBox, Ok
		{
			Gosub, al_sub_RepairRegistry
			;IniWrite, 1, %ConfigFile_AppLauncher%, Config, DontCheckForCorruptRegistry
		}
	}
Return

al_sub_RepairRegistry:
	If A_ThisMenuitem <>
	{
		MsgBox, 33, %al_Titel%, %lng_al_AskRepairRegistry%
		IfMsgBox, Cancel
			Return
	}
	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, .lnk,, lnkfile
	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, .lnk\ShellEx\{000214EE-0000-0000-C000-000000000046},, {00021401-0000-0000-C000-000000000046}
	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, .lnk\ShellEx\{000214F9-0000-0000-C000-000000000046},, {00021401-0000-0000-C000-000000000046}
	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, .lnk\ShellEx\{00021500-0000-0000-C000-000000000046},, {00021401-0000-0000-C000-000000000046}
	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, .lnk\ShellEx\{BB2E617C-0920-11d1-9A0B-00C04FC2D6C1},, {00021401-0000-0000-C000-000000000046}

	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, .lnk\ShellNew, command, rundll32.exe appwiz.cpl,NewLinkHere `%1

	RegRead, al_ShortCutName, HKEY_CLASSES_ROOT, CLSID\{00021401-0000-0000-C000-000000000046}
	If (al_ShortCutName = "" AND Lng = "07")
		al_ShortCutName = Verknüpfung
	Else If al_ShortCutName =
		al_ShortCutName = Shortcut

	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, lnkfile, , %al_ShortCutName%
	RegWrite, REG_DWORD, HKEY_CLASSES_ROOT, lnkfile, EditFlags , 00000001
	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, lnkfile, IsShortcut ,
	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, lnkfile, NeverShowExt ,

	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, lnkfile\CLSID, , {00021401-0000-0000-C000-000000000046}

	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, lnkfile\shellex\ContextMenuHandlers\Offline Files, , {750fdf0e-2a26-11d1-a3ea-080036587f03}

	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, lnkfile\shellex\ContextMenuHandlers\{00021401-0000-0000-C000-000000000046}

	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, lnkfile\shellex\DropHandler, , {00021401-0000-0000-C000-000000000046}
	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, lnkfile\shellex\IconHandler, , {00021401-0000-0000-C000-000000000046}

	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, lnkfile\shellex\PropertySheetHandlers\ShimLayer Property Page, , {513D916F-2A8E-4F51-AEAB-0CBC76FB1AF8}

	SetTimer, al_sub_IndexDirectories, 50
	MsgBox, 64, %al_Title%, %lng_al_RegistryRepaired%
Return
