; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               DriveIcons
; -----------------------------------------------------------------------------
; Prefix:             di_
; Version:            1.0
; Date:               2008-05-05
; Author:             Wolfgang Reszel, Michael Telgkamp
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_DriveIcons:
	di_Debug = 0

	Prefix = di
	%Prefix%_ScriptName    = DriveIcons
	%Prefix%_ScriptVersion = 1.0.1
	%Prefix%_Author        = Wolfgang Reszel, Michael Telgkamp

	IconFile_On_DriveIcons = %A_WinDir%\system32\shell32.dll
	IconPos_On_DriveIcons  = 12

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                        = %di_ScriptName% - Automatische Laufwerks-Icons
		Description                     = Erstellt oder entfernt Laufwerks-Icons auf dem Desktop, wenn ein Laufwerk/USB-Stick angeschlossen bzw. entfernt wird.
		lng_di_Location                 = Wo sollen die Laufwerks-Icons angelegt werden?
		lng_di_LocationOpt1             = Desktop
		lng_di_LocationOpt2             = Schnellstartleiste
		lng_di_LocationOpt3             = Linkfavoriten
		lng_di_LocationOpt4             = Benutzerdefiniert:
		lng_di_MoveIcons                = Icons wie unter Mac OS anordnen
		lng_di_ReserveCDSpace           = Platz für CD/DVD-Laufwerke reservieren
		lng_di_DriveLetters             = Folgende Laufwerke berücksichtigen
		lng_di_FolderTree               = Laufwerks-Icons öffnen den Explorer mit Verzeichnisbaum
		lng_di_BurningApps              = Die Abfrage der CD/DVD-Laufwerke unterlassen, wenn folgende (Brenn-)Programme aktiv sind:
		lng_di_WatchDelete              = Laufwerke auswerfen, wenn deren Symbol manuell gelöscht wird
		lng_di_NoDeveject               = Deveject.exe wird für das Auswerfen dieses Laufwerks benötigt,`nkonnte aber nicht im ac'tivAid-Verzeichnis gefunden werden.
		lng_di_NoFixed                  = ohne Festplatten
		lng_di_NoCDROM                  = ohne CD/DVD-Laufwerke
		lng_di_NoRemovable              = ohne Wechseldatenträger
		lng_di_NoNetwork                = ohne Netzlaufwerke
		lng_di_NoRamdisk                = ohne Ramdisks
		lng_di_NoUnknown                = ohne unbekannte Laufwerke
		lng_di_NoFloppy                 = alle Laufwerke
		lng_di_LetterFirst              = Laufwerksbuchstabe vor dem Mediennamen
		lng_di_FirstRun                 = Die Erweiterung DriveIcons wurde deaktiviert,`ndamit vorab Inkompatibilitäten beseitigt werden können.`nBitte lesen Sie dazu folgenden Abschnitt in der FAQ bzw. Hilfe:`n"ac'tivAid sorgt für hohe Prozessorauslastung anderer Prozesse"
		lng_di_OpenDrive                = Laufwerk automatisch im Explorer öffnen

		tooltip_di_LocationOption1      = Zeigt die Icons auf dem Desktop an.
		tooltip_di_LocationOption2      = Zeigt die Icons in der Schnellstartleiste an,`nwelche über einen Rechtsklick auf der Taskleiste aktiviert werden kann.
		tooltip_di_LocationOption4      = Zeigt die Icons in einem benutzerdefinierten Verzeichnis an,`nwas z.B. sinnvoll ist, wenn man eine zusätzliche Symbolleiste`nstatt der Schnellstartleiste verwenden möchte.
		tooltip_di_FolderTree           = Beim Doppelklick auf ein Laufwerks-Icon öffnet sich`nder Explorer mit dem Verzeichnisbaum (Ordnerleiste).`nIst diese Option aktiviert, zeigen die Laufwerks-Icons`nnur noch die Standardsymbole.
		tooltip_di_DriveLetters         = Verhindert, dass die Icons der angegeben Laufwerke angezeigt werden.
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %di_ScriptName% - automatic drive icons
		Description                   = Creates or removes drive icons on the desktop when a drive/usb-stick is mounted or unmounted.
		lng_di_Location               = Where to create the drive icons?
		lng_di_LocationOpt1           = Desktop
		lng_di_LocationOpt2           = QuickLaunch bar
		lng_di_LocationOpt3           = Link favourites
		lng_di_LocationOpt4           = Custom:
		lng_di_MoveIcons              = arrange icons like Mac OS
		lng_di_ReserveCDSpace         = allocate space for CD/DVD-drives
		lng_di_DriveLetters           = Drives to watch
		lng_di_FolderTree             = open the explorer with the folder tree
		lng_di_BurningApps            = Ignore checking CD/DVD-drives, if the following (burning-)applications are active:
		lng_di_WatchDelete            = Eject drives when icons are deleted manually.
		lng_di_NoDeveject             = Deveject.exe is needed to eject this device,`nbut could not found in the ac'tivAid-directory.
		lng_di_NoFixed                = without fixed drives
		lng_di_NoCDROM                = without CD/DVD drives
		lng_di_NoRemovable            = without removable drives
		lng_di_NoNetwork              = without network drives
		lng_di_NoRamdisk              = without ramdisks
		lng_di_NoUnknown              = without unknown drives
		lng_di_NoFloppy               = all drives
		lng_di_LetterFirst            = drive letter in front of media name
		lng_di_FirstRun               = The extension DriveIcons has been disabled`nto avoid conflicts with other programs.`nIf you use Outpost firewall please enable NetBios communication for all ip-ranges (eg. 192.168.0.*).
		lng_di_OpenDrive              = open drive in explorer
	}

	di_Alphabet = CDEFGHIJKLMNOPQRSTUVWXYZ
	IniRead, di_LocationOption, %ConfigFile%, DriveIcons, LocationOption
	IniRead, di_CustomLocation, %ConfigFile%, DriveIcons, CustomLocation, C:
	IniRead, di_LocationOption1, %ConfigFile%, DriveIcons, LocationOption1, 1
	IniRead, di_LocationOption2, %ConfigFile%, DriveIcons, LocationOption2, 0
	IniRead, di_LocationOption3, %ConfigFile%, DriveIcons, LocationOption3, 0
	IniRead, di_LocationOption4, %ConfigFile%, DriveIcons, LocationOption4, 0
	IniRead, di_MoveIcons, %ConfigFile%, DriveIcons, MoveIcons, 1
	If A_OSWordSize = 64
		di_MoveIcons = 0
	IniRead, di_LetterFirst, %ConfigFile%, DriveIcons, LetterFirst, 0
	IniRead, di_ReserveCDSpace, %ConfigFile%, DriveIcons, ReserveCDSpace, 0
	IniRead, di_DriveLetters, %ConfigFile%, DriveIcons, DriveLetters, %di_Alphabet%
	IniRead, di_FolderTree, %ConfigFile%, DriveIcons, FolderTree, 0
	IniRead, di_BurningApps, %ConfigFile%, DriveIcons, BurningApps, ahk_class NERO_BURNING_ROM Class
	IniRead, di_WatchDelete, %ConfigFile%, DriveIcons, WatchDelete, 1
	IniRead, di_FirstRun, %ConfigFile%, DriveIcons, FirstRun, 0
	IniRead, di_OpenDrive, %ConfigFile%, DriveIcons, OpenDrive, 0
	IniRead, di_SkipIcons, %ConfigFile%, DriveIcons, SkipIcons, 0
	If Enable_Eject = 1
		di_WatchDelete = 0

	StringReplace, di_BurningApps, di_BurningApps, |, `n, A
	IfInString, di_BurningApps, NERO_BURNING_ROM
		IfNotInString, di_BurningApps, ahk_class
			StringReplace, di_BurningApps, di_BurningApps, NERO_BURNING_ROM, ahk_class NERO_BURNING_ROM, A

	if (di_LocationOption != "ERROR")
	{
		If di_LocationOption = 1
			di_LocationOption1 = 1
		If di_LocationOption = 2
			di_LocationOption2 = 1
		If di_LocationOption = 3
			di_LocationOption4 = 1
	}
	di_LocationOption =

	di_Location1 := A_Desktop
	di_Location2 := A_AppData "\Microsoft\Internet Explorer\Quick Launch"
	di_Location3 := USERPROFILE "\Links"
	di_Location4 := func_Deref(di_CustomLocation)

	StringSplit,FileBrowserWithTree,FileBrowserWithTree,%A_Space%
	If FileBrowserWithTree1 = Explorer
		FileBrowserWithTree1 = %A_WinDir%\Explorer.exe
Return

AfterLoadingProcess_DriveIcons:
	If di_FirstRun = 0
	{
		ShowGUI = 2
		Enable_DriveIcons = 0
		IniWrite, 1, %ConfigFile%, DriveIcons, FirstRun
		di_FirstRun = 1
		BalloonTip(di_ScriptName, lng_di_FirstRun,"Warning",0,0,20)
	}
Return

SettingsGui_DriveIcons:
	Gui, Add, GroupBox, xs+10 ys+10 w550 h110, %lng_di_Location%
	Gui, Add, CheckBox, -Wrap xs+20 ys+30 Checked gdi_sub_CheckIfSettingsChanged vdi_LocationOption1_tmp Checked%di_LocationOption1%, %lng_di_LocationOpt1%
	Gui, Add, CheckBox, -Wrap y+10 gdi_sub_CheckIfSettingsChanged vdi_LocationOption2_tmp Checked%di_LocationOption2%, %lng_di_LocationOpt2%
	If (aa_osversionnumber >= aa_osversionnumber_vista)
		Gui, Add, CheckBox, -Wrap x+20 gdi_sub_CheckIfSettingsChanged vdi_LocationOption3_tmp Checked%di_LocationOption3%, %lng_di_LocationOpt3%
	Gui, Add, CheckBox, -Wrap xs+20 y+10 gdi_sub_CheckIfSettingsChanged vdi_LocationOption4_tmp Checked%di_LocationOption4%, %lng_di_LocationOpt4%

	Gui, Add, Edit, -Wrap R1 x+10 yp-3 w310 gsub_CheckIfSettingsChanged vdi_CustomLocation_tmp, %di_CustomLocation%
	Gui, Add, Button, -Wrap x+5 yp-1 W100 gdi_sub_Browse vdi_Browse, %lng_Browse%

	If Enable_Eject = 1
		Gui, Add, CheckBox, -Wrap xs+20 y+5 Checked%di_WatchDelete% gsub_CheckIfSettingsChanged vdi_WatchDelete_tmp, %lng_di_WatchDelete%
	Else
		Gui, Add, CheckBox, -Wrap xs+20 y+5 Disabled Checked%di_WatchDelete% gsub_CheckIfSettingsChanged vdi_WatchDelete_tmp, %lng_di_WatchDelete%

	Gui, Add, CheckBox, -Wrap xs+10 y+10 Checked%di_FolderTree% gsub_CheckIfSettingsChanged vdi_FolderTree_tmp, %lng_di_FolderTree%
	Gui, Add, CheckBox, -Wrap x+10 Checked%di_LetterFirst% gsub_CheckIfSettingsChanged vdi_LetterFirst_tmp, %lng_di_LetterFirst%
	Gui, Add, CheckBox, -Wrap xs+10 y+5 Checked%di_OpenDrive% gsub_CheckIfSettingsChanged vdi_OpenDrive_tmp, %lng_di_OpenDrive%

	Gui, Add, CheckBox, -Wrap xs+120 ys+30 Disabled Checked%di_MoveIcons% gsub_CheckIfSettingsChanged vdi_MoveIcons_tmp, %lng_di_MoveIcons%

	Gui, Add, CheckBox, -Wrap x+20 Checked%di_ReserveCDSpace% gsub_CheckIfSettingsChanged vdi_ReserveCDSpace_tmp, %lng_di_ReserveCDSpace%

	di_Choose = 0
	di_ChooseIt =

	di_DriveLettersComboBox =

	IfNotInString, di_DriveLettersComboBox, CDEFGHIJKLMNOPQRSTUVWXYZ
	{
		di_DriveLettersComboBox = %di_DriveLettersComboBox%|%di_Alphabet% - %lng_di_NoFloppy%
		di_Choose++
		If di_DriveLetters = CDEFGHIJKLMNOPQRSTUVWXYZ
			di_ChooseIt := di_Choose
	}

	DriveGet, di_Drives, List, FIXED
	di_Drives := func_StrTranslate(di_Alphabet, di_Drives, "")
	IfNotInString, di_DriveLettersComboBox, %di_Drives%
	{
		di_DriveLettersComboBox = %di_DriveLettersComboBox%|%di_Drives% - %lng_di_NoFixed%
		di_Choose++
		If di_DriveLetters = %di_Drives%
			di_ChooseIt := di_Choose
	}

	DriveGet, di_Drives, List, NETWORK
	di_Drives := func_StrTranslate(di_Alphabet, di_Drives, "")
	IfNotInString, di_DriveLettersComboBox, %di_Drives%
	{
		di_DriveLettersComboBox = %di_DriveLettersComboBox%|%di_Drives% - %lng_di_NoNetwork%
		di_Choose++
		If di_DriveLetters = %di_Drives%
			di_ChooseIt := di_Choose
	}

	DriveGet, di_Drives, List, CDROM
	di_Drives := func_StrTranslate(di_Alphabet, di_Drives, "")
	IfNotInString, di_DriveLettersComboBox, %di_Drives%
	{
		di_DriveLettersComboBox = %di_DriveLettersComboBox%|%di_Drives% - %lng_di_NoCDROM%
		di_Choose++
		If di_DriveLetters = %di_Drives%
			di_ChooseIt := di_Choose
	}

	DriveGet, di_Drives, List, REMOVABLE
	di_Drives := func_StrTranslate(di_Alphabet, di_Drives, "")
	IfNotInString, di_DriveLettersComboBox, %di_Drives%
	{
		di_DriveLettersComboBox = %di_DriveLettersComboBox%|%di_Drives% - %lng_di_NoRemovable%
		di_Choose++
		If di_DriveLetters = %di_Drives%
			di_ChooseIt := di_Choose
	}

	DriveGet, di_Drives, List, RAMDISK
	di_Drives := func_StrTranslate(di_Alphabet, di_Drives, "")
	IfNotInString, di_DriveLettersComboBox, %di_Drives%
	{
		di_DriveLettersComboBox = %di_DriveLettersComboBox%|%di_Drives% - %lng_di_NoRamdisk%
		di_Choose++
		If di_DriveLetters = %di_Drives%
			di_ChooseIt := di_Choose
	}

	DriveGet, di_Drives, List, UNKNOWN
	di_Drives := func_StrTranslate(di_Alphabet, di_Drives, "")
	IfNotInString, di_DriveLettersComboBox, %di_Drives%
	{
		di_DriveLettersComboBox = %di_DriveLettersComboBox%|%lng_di_NoUnknown%: %di_Drives%
		di_Choose++
		If di_DriveLetters = %di_Drives%
			di_ChooseIt := 1
	}

	If di_ChooseIt =
	{
		di_DriveLettersComboBox = %di_DriveLetters%|%di_DriveLettersComboBox%
		di_ChooseIt := 1
	}
	di_DriveLettersComboBox := func_StrTrimChars(di_DriveLettersComboBox,"|")

	Gui, Add, Text, xs+10 ys+170, %lng_di_DriveLetters%:
	Gui, Add, ComboBox, x+5 yp-3 w350 vdi_DriveLettersComboBox_tmp gsub_CheckIfSettingsChanged, %di_DriveLettersComboBox%

	GuiControl, Choose, di_DriveLettersComboBox_tmp, %di_ChooseIt%

	Gui, Add, Text, xs+10 y+10, %lng_di_BurningApps%
	Gui, Add, Edit, y+5 w460 R4 vdi_BurningApps_tmp gsub_CheckIfSettingsChanged, %di_BurningApps%
	Gui, Add, Button, -Wrap x+5 w20 h21 vdi_Add_BurningApps gdi_sub_addApp, +

	Gosub, di_sub_CheckIfSettingsChanged
Return

di_sub_CheckIfSettingsChanged:
	Gosub, sub_CheckIfSettingsChanged

	Loop, 4
		GuiControlGet, di_LocationOption%A_Index%_tmp,,di_LocationOption%A_Index%_tmp

	If di_LocationOption1_tmp = 1
	{
		If A_OSWordSize = 32
			GuiControl, Enable, di_MoveIcons_tmp
		GuiControl, Enable, di_ReserveCDSpace_tmp
	}
	Else
	{
		GuiControl, Disable, di_MoveIcons_tmp
		GuiControl, Disable, di_ReserveCDSpace_tmp
	}

	If di_LocationOption4_tmp = 1
	{
		GuiControl, Enable, di_CustomLocation_tmp
		GuiControl, Enable, di_Browse_tmp
	}
	Else
	{
		GuiControl, Disable, di_CustomLocation_tmp
		GuiControl, Disable, di_Browse_tmp
	}
Return

di_sub_Browse:
	Gui +OwnDialogs
	GuiControlGet,di_CustomLocationTmp, , di_CustomLocation_tmp
	FileSelectFolder, di_CustomLocationTmp, *%di_CustomLocationTmp%\, 1
	If di_CustomLocationTmp<>
		GuiControl,,di_CustomLocation_tmp, %di_CustomLocationTmp%
Return

UnInstallExt_DriveIcons:
	Gosub, di_sub_RemoveIcons
	Gosub, DoDisable_DriveIcons
Return

di_sub_RemoveIcons:
	SetTimer, di_tim_WatchDrives, Off
	ej_BreakWatch = 1
	Loop, 4
	{
		If di_LocationOption%A_Index% = 0
			continue
		di_Location := di_Location%A_Index%
		Loop, %di_Location%\*.lnk
		{
			FileGetShortcut, %A_LoopFileFullPath%, di_TmpTarget,,di_TmpArgs, di_TmpDesc
			If di_TmpTarget = %FileBrowserWithTree1%
				StringRight, di_TmpTarget, di_TmpArgs, 3

			If (func_StrRight(di_TmpTarget,2) = "`:\")
			{
				StringLeft, di_Drive, di_TmpTarget, 1
				If( di_TmpDesc = di_Drive "`:\" )
				{
					FileDelete, %A_LoopFileFullPath%
					Debug("FILE", A_LineNumber, A_LineFile, "Deleted: " A_LoopFileFullpath )
				}
			}
		}
	}
	Loop, Parse, di_Alphabet
	{
		di_StatusDrv%A_LoopField% =
	}
	di_PrevDrives =
	Sleep, 300
Return

SaveSettings_DriveIcons:
	Debug("SETTINGS", A_LineNumber, A_LineFile, A_ThisLabel "..." )

	Gosub, di_sub_RemoveIcons

	di_DriveLetters := di_DriveLettersComboBox_tmp
	If InStr(di_DriveLetters," - ")
		StringLeft, di_DriveLetters, di_DriveLetters, % InStr(di_DriveLetters," - ")
	If InStr(di_DriveLetters,"- ")
		StringLeft, di_DriveLetters, di_DriveLetters, % InStr(di_DriveLetters,"- ")
	If InStr(di_DriveLetters," -")
		StringLeft, di_DriveLetters, di_DriveLetters, % InStr(di_DriveLetters," -")
	If InStr(di_DriveLetters,"-")
		StringLeft, di_DriveLetters, di_DriveLetters, % InStr(di_DriveLetters,"-")

	di_DriveLetters := func_StrClean(di_DriveLetters, "ABCDEFGHIJKLMNOPQRSTUVWXYZ",1)

	StringUpper, di_DriveLetters, di_DriveLetters

	Loop, Parse, di_DriveLetters
	{
		di_StatusDrv%A_LoopField% =
	}

	di_OldOptions = %di_LocationOption1%%di_LocationOption2%%di_LocationOption3%%di_LocationOption4%
	di_NewOptions = %di_LocationOption1_tmp%%di_LocationOption2_tmp%%di_LocationOption3_tmp%%di_LocationOption4_tmp%
	di_NewLocation4 := func_Deref(di_CustomLocation_tmp)

	If (di_NewLocation4 <> di_Location4 OR di_OldOptions <> di_NewOptions)
	{
		Loop, 4
		{
			If di_LocationOption%A_Index% = 0
				continue
			di_OldLocation := di_Location%A_Index%
			DriveGet, di_AllDrives, List
			Loop, %di_OldLocation%\*.lnk
			{
				FileGetShortcut, %A_LoopFileFullPath%, di_TmpTarget,,di_TmpArgs, di_TmpDesc
				If di_TmpTarget = %FileBrowserWithTree1%
					StringRight, di_TmpTarget, di_TmpArgs, 3

				If (func_StrRight(di_TmpTarget,2) = "`:\")
				{
					StringLeft, di_Drive, di_TmpTarget, 1
					If( InStr(di_AllDrives, di_Drive) AND di_TmpDesc = di_Drive "`:\" )
					{
						FileDelete, %A_LoopFileFullPath%
						Debug("FILE", A_LineNumber, A_LineFile, "Deleted: " A_LoopFileFullPath )
					}
				}
			}
		}
	}

	Loop, 4
	{
		di_LocationOption%A_Index% := di_LocationOption%A_Index%_tmp
		IniWrite, % di_LocationOption%A_Index%, %ConfigFile%, DriveIcons, LocationOption%A_Index%
	}
	di_Location4 := di_NewLocation4

	di_WatchDelete = %di_WatchDelete_tmp%
	di_LetterFirst = %di_LetterFirst_tmp%
	di_CustomLocation = %di_CustomLocation_tmp%
	di_MoveIcons = %di_MoveIcons_tmp%
	di_ReserveCDSpace = %di_ReserveCDSpace_tmp%
	di_WatchDelete = %di_WatchDelete_tmp%
	di_FolderTree = %di_FolderTree_tmp%
	di_BurningApps = %di_BurningApps_tmp%
	di_OpenDrive = %di_OpenDrive_tmp%
	IniWrite, %di_LetterFirst%, %ConfigFile%, DriveIcons, LetterFirst
	IniWrite, %di_CustomLocation%, %ConfigFile%, DriveIcons, CustomLocation
	If A_OSWordSize = 32
		IniWrite, %di_MoveIcons%, %ConfigFile%, DriveIcons, MoveIcons
	IniWrite, %di_ReserveCDSpace%, %ConfigFile%, DriveIcons, ReserveCDSpace
	IniWrite, %di_WatchDelete%, %ConfigFile%, DriveIcons, WatchDelete
	IniWrite, %di_DriveLetters%, %ConfigFile%, DriveIcons, DriveLetters
	IniWrite, %di_FolderTree%, %ConfigFile%, DriveIcons, FolderTree
	StringReplace, di_BurningApps, di_BurningApps, `n, |, A
	IniWrite, %di_BurningApps%, %ConfigFile%, DriveIcons, BurningApps
	IniWrite, %di_OpenDrive%, %ConfigFile%, DriveIcons, OpenDrive
	IniWrite, %di_SkipIcons%, %ConfigFile%, DriveIcons, SkipIcons
	IniWrite, %di_FirstRun%, %ConfigFile%, DriveIcons, FirstRun
Return

AddSettings_DriveIcons:
Return

CancelSettings_DriveIcons:
	di_PrevDrives =
Return

DoEnable_DriveIcons:
	SetTimer, di_tim_WatchDrives, Off
	ej_BreakWatch = 1
	DriveGet, di_AllDrives, List
	di_PrevDrives =
	Loop, 4
	{
		If di_LocationOption%A_Index% = 0
			continue
		di_Location := di_Location%A_Index%
		Loop, %di_Location%\*.lnk
		{
			FileGetShortcut, %A_LoopFileFullPath%, di_TmpTarget,,di_TmpArgs, di_TmpDesc
			If di_TmpTarget = %FileBrowserWithTree1%
				StringRight, di_TmpTarget, di_TmpArgs, 3
			If (func_StrRight(di_TmpTarget,2) = "`:\")
			{
				StringLeft, di_Drive, di_TmpTarget, 1
				If( InStr(di_AllDrives, di_Drive) AND di_TmpDesc = di_Drive "`:\" )
				{
					FileDelete, %A_LoopFileFullPath%
					Debug("FILE", A_LineNumber, A_LineFile, "Deleted: " A_LoopFileFullPath )
				}
			}
		}
	}
	Loop, Parse, di_AllDrives
	{
		di_StatusDrv%A_LoopField% =
	}

	If di_MoveIcons = 0
		di_InitialWatch = 1
	ej_BreakWatch =
	SetTimer, di_tim_WatchDrives, 1500
Return

DoDisable_DriveIcons:
	SetTimer, di_tim_WatchDrives, Off
	ej_BreakWatch = 1
	di_PrevDrives =
Return

DefaultSettings_DriveIcons:
Return

OnExitAndReload_DriveIcons:
	Gosub, di_sub_RemoveIcons
Return

DisplayChange_DriveIcons:
	di_PrevDrives =
	If di_MoveIcons = 1
		di_func_MoveIcons(1)
Return

Update_DriveIcons:
	IniRead, ReplaceRecycler, %ConfigFile%, DriveIcons, ReplaceRecycler
	FileDelete, %A_ScriptDir%\extensions\ac'tivAid_DriveIcons Recycler.*
	If ReplaceRecycler = 1
	{
		RegWrite, REG_DWORD, HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu,{645FF040-5081-101B-9F08-00AA002F954E}, 0
		RegWrite, REG_DWORD, HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel,{645FF040-5081-101B-9F08-00AA002F954E}, 0
		FileDelete, %A_DeskTop%\ Papierkorb.lnk
	}
	If ReplaceRecycler <> ERROR
		IniDelete, %ConfigFile%, DriveIcons, ReplaceRecycler

	IniRead, ExcludeDrives, %ConfigFile%, DriveIcons, ExcludeDrives
	If ExcludeDrives <> ERROR
	{
		DriveLetters := func_StrTranslate("CDEFGHIJKLMNOPQRSTUVWXYZ",ExcludeDrives,"")
		IniWrite, %DriveLetters%, %ConfigFile%, DriveIcons, DriveLetters
		IniDelete, %ConfigFile%, DriveIcons, ExcludeDrives
	}

	IniRead, DrivesLetters, %ConfigFile%, DriveIcons, DrivesLetters
	If DrivesLetters <> ERROR
	{
		IniWrite, %DrivesLetters%, %ConfigFile%, DriveIcons, DriveLetters
		IniDelete, %ConfigFile%, DriveIcons, DrivesLetters
	}
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

di_tim_WatchDrives:
;   Critical
	If LoadingFinished <> 1
		Return

	DriveGet, di_AllDrives, List
	DriveGet, di_AllCDDrives, List, CDROM

	di_AllOtherDrives := func_StrTranslate(di_DriveLetters, di_AllCDDrives, "")
;   di_AllCDDrives := func_StrTranslate(di_DriveLetters, di_AllOtherDrives, "")

	Loop, Parse, di_DriveLetters
	{
		If ej_BreakWatch = 1
			Break

		IfInString, di_AllCDDrives, %A_LoopField%
		{
			di_StatusCD =
			If di_BurningApps <>
			{
				DetectHiddenWindows, On

				Loop, Parse, di_BurningApps, `n
				{
					IfWinExist, %A_LoopField%
					{
						di_StatusCD = NotReady
						Debug("EXTENSION", A_LineNumber, A_LineFile, "Skipped because of " A_LoopField )
					}
				}

				If di_StatusCD =
				{
					DriveGet, di_StatusCD, Status, %A_LoopField%:
				}

				DetectHiddenWindows, Off
			}
			Else
			{
				DriveGet, di_StatusCD, Status, %A_LoopField%:
			}

			If (di_StatusDrv%A_LoopField% = di_StatusCD)
			{
				di_StatusDrv%A_LoopField% = %di_StatusCD%

				; Manuell gelöscht = Eject
				If (di_WatchDelete = 1)
				{
					If (di_LoopField = "A")
						di_DriveName =
					Else
						di_DriveName := di_func_DriveLabel(A_LoopField)

					If di_LetterFirst = 1
					{
						If di_DriveName <>
							di_DriveName := " (" di_DriveName ")"
						di_DriveFileName = %A_LoopField%%di_DriveName%
					}
					Else
					{
						If di_DriveName <>
							di_DriveName := di_DriveName " "
						di_DriveFileName = %di_DriveName%(%A_LoopField%)
					}

					If ( InStr(di_AllDrives,di_Letter) AND di_StatusDrv%A_LoopField% <> "NotReady" AND di_StatusDrv%A_LoopField% <> "Invalid" )
					{
						Loop, 4
						{
							If di_LocationOption%A_Index% = 0
								continue
							di_Location := di_Location%A_Index%
							If ( !FileExist( di_Location "\" di_DriveFileName ".lnk") )
							{
								di_Letter = %A_LoopField%
								di_Letters =
								Loop, %di_Location%\*.lnk
								{
									FileGetShortcut, %A_LoopFileFullPath%, di_TmpTarget,,di_TmpArgs, di_TmpDesc
									If di_TmpTarget = %FileBrowserWithTree1%
										StringRight, di_TmpTarget, di_TmpArgs, 3
									If (func_StrRight(di_TmpTarget,2) = "`:\")
									{
										StringLeft, di_Drive, di_TmpTarget, 1
										If( di_TmpDesc = di_Drive "`:\" )
										{
											di_Letters := di_Letters di_Drive
											di_LetterLnk%di_Drive% = %A_LoopFileFullPath%
										}
									}
								}

								If (di_StatusDrv%di_Letter% <> "NotReady" AND di_StatusDrv%di_Letter% <> "Unknown" AND !InStr(di_Letters,di_Letter) AND di_Letters <> "" AND InStr(di_AllCDDrives,di_Letter))
								{
									Debug("EXTENSION", A_LineNumber, A_LineFile, "Ejecting: " di_Letter "(CD:" di_StatusCD "-" di_StatusDrv%di_Letter% ")" )
									di_StatusDrv%di_Letter% = eject
									ej_Drive = %di_Letter%
									If Enable_Eject = 1
										Gosub, di_sub_Eject
								}
								Else
								{
									FileDelete, % di_LetterLnk%di_Letter%
									Gosub, di_EnvUpdate
									di_func_ShowIcon(di_Letter, di_Location)
								}
							}
						}
					}
				}

				continue
			}
			di_StatusDrv%A_LoopField% = %di_StatusCD%

			Debug("EXTENSION", A_LineNumber, A_LineFile, "Changed: " A_LoopField ": " di_StatusCD )

			Loop, 4
			{
				If di_LocationOption%A_Index% = 0
					continue
				di_Location := di_Location%A_Index%
				If di_StatusCD in open,NotReady
				{
					Debug("EXTENSION", A_LineNumber, A_LineFile, "RemoveIcon: " A_LoopField ": " di_Location )
					di_func_RemoveIcon(A_LoopField, di_Location)
					di_DontEject = 1
				}
				Else
				{
					Debug("EXTENSION", A_LineNumber, A_LineFile, "ShowIcon: " A_LoopField ": " di_Location )
					di_func_ShowIcon(A_LoopField, di_Location)
					If (di_OpenDrive = 1 AND di_PrevDrives <> "")
					{
						If di_FolderTree = 1
							Run, %FileBrowserWithTree%%A_LoopField%`:\
						Else
							Run, %A_LoopField%`:\
						Debug("EXTENSION", A_LineNumber, A_LineFile, "OpenExplorer: " A_LoopField )
					}
				}
			}
		}
		IfInString, di_AllOtherDrives, %A_LoopField%
		{
			If (A_LoopField = "A")
				di_Status = Ready
			Else
				DriveGet, di_Status, Status, %A_LoopField%:

			If (di_StatusDrv%A_LoopField% = di_Status)
			{
				; Manuell gelöscht = Eject
				If (di_WatchDelete = 1 AND di_DontEject = "")
				{
					If (di_LoopField = "A")
						di_DriveName =
					Else
						di_DriveName := di_func_DriveLabel(A_LoopField)

					If di_LetterFirst = 1
					{
						If di_DriveName <>
							di_DriveName := " (" di_DriveName ")"
						di_DriveFileName = %A_LoopField%%di_DriveName%
					}
					Else
					{
						If di_DriveName <>
							di_DriveName := di_DriveName " "
						di_DriveFileName = %di_DriveName%(%A_LoopField%)
					}

					If ( InStr(di_AllDrives,di_Letter) AND di_StatusDrv%A_LoopField% <> "NotReady" AND di_StatusDrv%A_LoopField% <> "Invalid" )
					{
						Loop, 4
						{
							If di_LocationOption%A_Index% = 0
								continue
							di_Location := di_Location%A_Index%
							If ( !FileExist( di_Location "\" di_DriveFileName ".lnk")  )
							{
								di_Letter = %A_LoopField%
								di_Letters =
								Loop, %di_Location%\*.lnk
								{
									FileGetShortcut, %A_LoopFileFullPath%, di_TmpTarget,,di_TmpArgs, di_TmpDesc
									If di_TmpTarget = %FileBrowserWithTree1%
										StringRight, di_TmpTarget, di_TmpArgs, 3
									If (func_StrRight(di_TmpTarget,2) = "`:\")
									{
										StringLeft, di_Drive, di_TmpTarget, 1
										If( di_TmpDesc = di_Drive "`:\" )
										{
											di_Letters := di_Letters di_Drive
											di_LetterLnk%di_Drive% = %A_LoopFileFullPath%
										}
									}
								}

								If (di_StatusDrv%di_Letter% <> "NotReady" AND di_StatusDrv%di_Letter% <> "Unknown" AND !InStr(di_Letters,di_Letter) AND di_Letters <> "" AND InStr(di_AllDrives,di_Letter))
								{
									Debug("EXTENSION", A_LineNumber, A_LineFile, "Ejecting: " di_Letter "(" di_Status "-" di_StatusDrv%di_Letter% ")" )
									di_StatusDrv%di_Letter% = eject
									ej_Drive = %di_Letter%
									If Enable_Eject = 1
										Gosub, di_sub_Eject
								}
								Else
								{
									FileDelete, % di_LetterLnk%di_Letter%
									Gosub, di_EnvUpdate
									di_func_ShowIcon(di_Letter, di_Location)
								}
							}
						}
					}
				}

				continue
			}
			di_StatusDrv%A_LoopField% = %di_Status%

			Loop, 4
			{
				If di_LocationOption%A_Index% = 0
					continue
				di_Location := di_Location%A_Index%
				Debug("EXTENSION", A_LineNumber, A_LineFile, "Changed: " A_LoopField ": " di_Location )

				if di_Status <> Ready
				{
					di_func_RemoveIcon(A_LoopField, di_Location)
					di_DontEject = 1
				}
				Else
				{
					di_func_ShowIcon(A_LoopField, di_Location)
					If (di_OpenDrive = 1 AND di_PrevDrives <> "")
					{
						If di_FolderTree = 1
							Run, %FileBrowserWithTree%%A_LoopField%`:\
						Else
							Run, %A_LoopField%`:\
						Debug("EXTENSION", A_LineNumber, A_LineFile, "OpenExplorer: " A_LoopField )
					}
				}
			}
		}
	}

	Loop, Parse, di_DriveLetters
	{
		If ej_BreakWatch = 1
			Break

		IfNotInstring, di_PrevDrives, %A_LoopField%
			IfNotInString, di_AllDrives, %A_LoopField%
				continue

		If (!InStr(di_AllDrives, A_LoopField) AND InStr(di_PrevDrives, A_LoopField))
		{
			If (A_LoopField = "A")
				di_Status = Ready
			Else
				DriveGet, di_Status, Status, %A_LoopField%:
			Loop, 4
			{
				If di_LocationOption%A_Index% = 0
					continue
				di_Location := di_Location%A_Index%
				di_func_RemoveIcon(A_LoopField, di_Location)
			}
			di_StatusDrv%A_LoopField% = %di_Status%
		}
	}

;   If (di_PrevDrives <> di_AllDrives)
;   {
;   }

	If (di_PrevDrives = "" AND di_MoveIcons = 1 AND ej_BreakWatch = "")
	{
		Gosub, di_EnvUpdate
;      Sleep, 300
;      PostMessage, 0x111, 28931,,, ahk_class Progman
		di_func_MoveIcons(1)
	}

	If ej_BreakWatch =
		di_PrevDrives = %di_AllDrives%

	di_DontEject =
	di_InitialWatch =
Return

di_func_ShowIcon( di_Drive, di_Location ) {
	;global di_PrevDrives,di_MoveIcons,di_FolderTree,di_InitialWatch,di_LetterFirst,FileBrowserWithTree,FileBrowserWithTree1,FileBrowserWithTree2
	global

	di_Found = 0
	Loop, %di_Location%\*.lnk
	{
		FileGetShortcut, %A_LoopFileFullPath%, di_TmpTarget,, di_TmpArgs, di_TmpDesc
		If (((di_TmpTarget = di_Drive "`:\" AND di_FolderTree <> 1) OR (di_TmpTarget = FileBrowserWithTree1 AND di_TmpArgs = FileBrowserWithTree2 di_Drive "`:\" AND di_FolderTree = 1)) AND di_TmpDesc = di_Drive "`:\")
		{
			di_Found = 1
			break
		}
	}

	If di_Found = 0
	{
		If (di_Drive = "A")
			di_DriveName =
		Else
			di_DriveName := di_func_DriveLabel(di_Drive)

		If di_LetterFirst = 1
		{
			If di_DriveName <>
				di_DriveName := " (" di_DriveName ")"
			di_DriveFileName = %di_Drive%%di_DriveName%
		}
		Else
		{
			If di_DriveName <>
				di_DriveName := di_DriveName " "
			di_DriveFileName = %di_DriveName%(%di_Drive%)
		}

		If di_FolderTree = 1
		{
			di_DrvIconFile = %A_Windir%\System32\shell32.dll
			If (di_Drive = "A")
				di_DrvType = Removable
			Else
				DriveGet, di_DrvType, Type, %di_Drive%:

			If di_DrvType = Removable
			{
				If (di_Drive = "A")
					di_DrvIcon = 7
				Else
					di_DrvIcon = 8
			}
			Else If di_DrvType = Fixed
				di_DrvIcon = 9
			Else If di_DrvType = Network
				di_DrvIcon = 10
			Else If di_DrvType = CDROM
				di_DrvIcon = 12
			Else If di_DrvType = RAMDisk
				di_DrvIcon = 13
			Else
				di_DrvIcon = 9

			IfExist, %di_drive%:\autorun.inf
			{
				IniRead, di_AutorunIcon, %di_drive%:\autorun.inf, autorun, icon
				If di_AutorunIcon <> ERROR
				{
					StringSplit, di_AutorunIcon, di_AutorunIcon, `,
					di_DrvIcon := di_AutorunIcon2+1
					di_DrvIconFile = %di_Drive%:\%di_AutorunIcon1%
				}
			}

			FileCreateShortCut, %FileBrowserWithTree1%, %di_Location%\%di_DriveFileName%.lnk,, %FileBrowserWithTree2%%di_Drive%`:\,%di_Drive%`:\,%di_DrvIconFile%,,%di_DrvIcon%
			Debug("EXTENSION", A_LineNumber, A_LineFile, "Created: " di_DriveName "(" di_Drive ")" )
		}
		Else
		{
			di_DrvIcon =
			di_DrvIconFile =
			IfExist, %di_drive%:\autorun.inf
			{
				IniRead, di_AutorunIcon, %di_drive%:\autorun.inf, autorun, icon
				If di_AutorunIcon <> ERROR
				{
					StringSplit, di_AutorunIcon, di_AutorunIcon, `,
					di_DrvIcon := di_AutorunIcon2+1
					di_DrvIconFile = %di_Drive%:\%di_AutorunIcon1%
				}
			}

			If di_LetterFirst = 1
			{
				di_dsi_filenames%di_Drive% = %di_Location%\%di_Drive%%di_DriveName%.lnk
				FileCreateShortCut, %di_Drive%`:\, %di_Location%\%di_Drive%%di_DriveName%.lnk,,,%di_Drive%`:\, %di_DrvIconFile%,,%di_DrvIcon%
			}
			Else
			{
				di_dsi_filenames%di_Drive% = %di_Location%\%di_DriveName%(%di_Drive%).lnk
				FileCreateShortCut, %di_Drive%`:\, %di_Location%\%di_DriveName%(%di_Drive%).lnk,,,%di_Drive%`:\, %di_DrvIconFile%,,%di_DrvIcon%
			}
		}

		Debug("EXTENSION", A_LineNumber, A_LineFile, "Created: " di_DriveName "(" di_Drive ")" )

		If (di_Location = A_Desktop AND di_PrevDrives <> "" AND di_MoveIcons = 1)
		{
			di_func_MoveIcons(1)
		}
		Else If di_InitialWatch = 1
		{
			Gosub di_EnvUpdate
		}
	}
}

di_func_RemoveIcon( di_Drive, di_Location ) {
	global di_MoveIcons,di_FolderTree,FileBrowserWithTree,FileBrowserWithTree1,FileBrowserWithTree2

	di_Found = 0
	Loop, %di_Location%\*.lnk
	{
		FileGetShortcut, %A_LoopFileFullPath%, di_TmpTarget,, di_TmpArgs, di_TmpDesc
		If (((di_TmpTarget = di_Drive "`:\" AND di_FolderTree <> 1) OR (di_TmpTarget = FileBrowserWithTree1 AND di_TmpArgs = FileBrowserWithTree2 di_Drive "`:\" AND di_FolderTree = 1)) AND di_TmpDesc = di_Drive "`:\")
		{
			di_Found = 1
			di_ShortcutName = %A_LoopFileFullPath%
			break
		}
	}

	If di_Found = 1
	{
		FileDelete, %di_ShortcutName%
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Deleted: " di_ShortcutName )

		If (di_Location = A_Desktop AND di_MoveIcons = 1)
		{
			di_func_MoveIcons(1)
		}
	}
}

di_func_MoveIcons( di_WaitForIcon=0 ) {
;   Critical
	global WorkAreaPrimaryLeft, WorkAreaPrimaryRight, WorkAreaPrimaryBottom, WorkAreaPrimaryTop, WorkAreaPrimaryWidth, di_ReserveCDSpace, di_FolderTree, di_DriveLetters, di_AllCDDrives, di_LetterFirst, di_SkipIcons

	Regread, di_IconSize, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, Shell Icon Size

	di_WorkAreaPrimaryWidth := WorkAreaPrimaryWidth

	; Am Raster ausrichten aktiviert?
	SendMessage, 4151, 0,0,SysListView321, Program Manager ahk_class Progman ; Align To Grid
	If (ErrorLevel & 0x80000)
		di_AlignToGrid = 1
	Else
		di_AlignToGrid = 0

	If di_AlignToGrid = 1
		SendMessage, 0x111, 28756,,, Program Manager ahk_class Progman ; Align To Grid

	; Vista SideBar berücksichtigen
	IfWinExist, ahk_class SideBar_AppBarWindow
	{
		WinGet, di_ExStyle, ExStyle, ahk_class SideBar_AppBarWindow
		If (!(di_ExStyle & 0x8))
		{
			WinGetPos, di_SBX, , di_SBWidth,, ahk_class SideBar_AppBarWindow
			If (di_SBX > WorkAreaPrimaryLeft AND di_SBX < WorkAreaPrimaryRight)
				di_WorkAreaPrimaryWidth := di_WorkAreaPrimaryWidth-di_SBWidth
		}
	}

	; Raster ermitteln
	SendMessage, 0x1000+51, di_IconIndex,, SysListView321, Program Manager ahk_class Progman
	di_YSpacing := ErrorLevel >> 16
	di_XSpacing := ErrorLevel & 0x0000FFFF
	di_XAdd := Round((di_XSpacing-di_IconSize)/2)
	di_XColumn := Round(di_WorkAreaPrimaryWidth/di_XSpacing)-1

	ControlGet, di_IconList, List, , SysListView321, Program Manager ahk_class Progman
	If di_WaitForIcon <>
	{
		Gosub, di_EnvUpdate
	}
	ControlGet, di_IconList, List, Col1, SysListView321, Program Manager ahk_class Progman
	di_ColIndex = 1
	di_ColSub = 0
	di_ArrangeRight := WorkAreaPrimaryLeft+di_XColumn*di_XSpacing + di_XAdd
	If (di_ArrangeRight+di_XSpacing > WorkAreaPrimaryLeft+di_WorkAreaPrimaryWidth)
	{
		di_ArrangeRight := WorkAreaPrimaryLeft+di_WorkAreaPrimaryWidth - di_XSpacing + di_XAdd
	}

	Loop, Parse, di_DriveLetters
	{
		di_Drive = %A_LoopField%

		If (di_Drive = "A")
			di_DriveName =
		Else
			di_DriveName := di_func_DriveLabel(di_Drive)

		If di_LetterFirst = 1
		{
			If di_DriveName <>
				di_DriveName := " (" di_DriveName ")"
			di_DriveFileName = %di_Drive%%di_DriveName%
		}
		Else
		{
			If di_DriveName <>
				di_DriveName := di_DriveName " "
			di_DriveFileName = %di_DriveName%(%di_Drive%)
		}

		Loop, Parse, di_IconList, `n
		{
			If ( A_LoopField = di_DriveFileName OR A_LoopField = "(" di_Drive ")" )
			{
				di_IconIndex := A_Index-1
				di_x := di_ArrangeRight-di_ColSub
				di_y := WorkAreaPrimaryTop+2+(InStr(di_DriveLetters,di_Drive)-di_ColIndex+di_SkipIcons)*di_YSpacing

				;test = %test%%di_Drive%: %di_x% * %di_y% %di_ColIndex%`n

				if (di_y > WorkAreaPrimaryBottom-di_YSpacing*2)
				{
					di_ColIndex := InStr(di_DriveLetters,di_Drive)
					di_ColSub := di_ColSub+di_XSpacing
					di_x := di_x-di_XSpacing
					di_y := WorkAreaPrimaryTop+(InStr(di_DriveLetters,di_Drive)-di_ColIndex+di_SkipIcons)*di_YSpacing
				}

				; LVM_SETITEMPOSITION
				SendMessage, 0x1000+15, di_IconIndex, ( di_y << 16 )|di_x, SysListView321, Program Manager ahk_class Progman
				Debug("EXTENSION", A_LineNumber, A_LineFile, "Icon moved: " A_LoopField )

				If (di_ReserveCDSpace = 0 OR !InStr(di_AllCDDrives, di_Drive) )
					di_ColIndex--
				break
			}
		}
		If (di_ReserveCDSpace = 0 OR !InStr(di_AllCDDrives, di_Drive) )
			di_ColIndex++
	}
	If di_AlignToGrid = 1
		SendMessage, 0x111, 28756,,, Program Manager ahk_class Progman ; Align To Grid
}

di_sub_addApp:
	GuiControlGet, di_BurningApps_Tmp,,di_BurningApps_tmp
	StringReplace, di_VarApp, A_GuiControl, Add_,
	WinSet,Bottom,, %ScriptTitle%
	SplashImage,,b1 cwFFFF80 FS9 WS700, %lng_AddApps%
	Gui,+Disabled
	Input,di_GetKey,,{Enter}{ESC}
	StringReplace,di_GetKey,ErrorLevel,Endkey:
	SplashImage, Off
	Gui,-Disabled
	WinGetClass, di_GetName, A
	di_GetName = ahk_class %di_GetName%
	If di_Getkey = Enter
	{
		IfNotInstring, di_BurningApps_Tmp, %di_GetName%
		{
			di_BurningApps_Tmp = %di_BurningApps_Tmp%`n%di_GetName%
			StringReplace, di_BurningApps_Tmp, di_BurningApps_Tmp, `n`n, `n, A
			StringReplace, di_BurningApps_Tmp, di_BurningApps_Tmp, `n`n, `n, A
			If (func_StrLeft(di_BurningApps_Tmp,1) = "`n")
				StringTrimLeft, di_BurningApps_Tmp, di_BurningApps_Tmp, 1
			If (func_StrRight(di_BurningApps_Tmp,1) = "`n")
				StringTrimRight, di_BurningApps_Tmp, di_BurningApps_Tmp, 1
			GuiControl,,%di_VarApp%_tmp, %di_BurningApps_Tmp%
		}
	}
	Gui,Show
	WinSet, Top, , %ScriptTitle%
	func_SettingsChanged("DriveIcons")
Return

di_sub_Eject:
	ej_InCustomDevices = 0
	Loop, 10
	{
		If ej_Device%A_Index% = %ej_Drive%
		{
			ej_InCustomDevices = %A_Index%
			StringSplit, ej_DevID, ej_DeviceID%A_Index%, '
			AutoTrim, On
			ej_DevID = %ej_DevID1%
			break
		}
	}

	If ej_InCustomDevices = 0
	{
		DriveGet, ej_Type, Type, %ej_Drive%:
	}
	Else
	{
		ej_Type = CUSTOMDEVICE
		IfNotExist, %A_ScriptDir%\Library\Tools\deveject.exe
		{
			MsgBox,64,%A_Scriptname%,%lng_di_NoDeveject%
			Return
		}
	}

	ej_OnlyEject = 1
	gosub, ej_main_Eject%A_NullVar%
	ej_OnlyEject =
Return

di_EnvUpdate:
	SetBatchLines, -1
	ControlGet, di_IconList, List, , SysListView321, Program Manager ahk_class Progman
	di_IndexDiff = 0
	di_IndexFound =
	Loop
	{
		di_tmpIconList = %di_IconList%
		ControlGet, di_IconList, List, , SysListView321, Program Manager ahk_class Progman
		If di_IconList <> %di_tmpIconList%
		{
			di_IndexDiff := A_Index
			di_IndexFound = 1
		}
		;tooltip, %A_Index% %di_IndexDiff%
		Sleep, 20
		If (A_Index-di_IndexDiff > 20 AND di_IndexFound = 1)
		{
			Sleep,100
			Break
		}
		If (A_Index-di_IndexDiff > 80)
			break
	}
Return

di_func_DriveLabel( di_drive ) {
	DriveGet, di_DriveType, Type, %di_drive%`:
	If di_DriveType = Network
	{
		RegRead, di_DrivePath, HKEY_CURRENT_USER, Network\%di_drive%, RemotePath
		if ErrorLevel
		{
			; We failed to get a network path.  Try to get the path from what I think
			; is the domain mapped-drive area.
			RegRead, di_DrivePath, HKEY_CURRENT_USER, Volatile Environment, HomeDrive
			if di_DrivePath = %di_drive%:
				RegRead, di_DrivePath, HKEY_CURRENT_USER, Volatile Environment, HomeShare
			else
				DrivePath = %di_DriveName%

		}
		SplitPath, di_DrivePath, di_DriveName
	}
	If di_DriveName =
		DriveGet, di_DriveName, Label, %di_drive%`:

	Return %di_DriveName%
}
