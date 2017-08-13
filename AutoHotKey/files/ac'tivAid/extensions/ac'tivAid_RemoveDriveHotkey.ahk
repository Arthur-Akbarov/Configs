; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:					RemoveDriveHotkey
; -----------------------------------------------------------------------------
; Prefix:				rdh_
; Version:				0.6.1
; Date:					2008-05-08
; Author:				Michael Telgkamp
; Copyright:			2008 Heise Zeitschriften Verlag GmbH & Co. KG
; Vielen Dank für die Genehmigung der Nutzung von RemoveDrive durch Uwe Sieber
; "Die Nutzung meines RemoveDrive für Ihr Tool ist mir recht"
; -----------------------------------------------------------------------------

; David Todo:
; - Toggle ob Menü Disks und/oder Partitionen erhält
; - call rdh_updateDriveInformation for menu (every 60sec?)
; - SuddenDeath: killAll Processes, then retry
;		(- Handles zum Ignorieren im Konfigdialog hinzufügen)
; - Wechseldatenträger StandardIcons festlegen
; - Handles anderer Partitionen des gleichen Datenträgers ebenfalls bearbeiten
; - Bestätigungs-Dialoge beim Umgang mit Handles (Are u sure?) / Toggle
; - GUI Sprach-variablen
; - Fenster zu ausgewähltem Prozess anzeigen
; - Rechts-Klickmenü
; - Scan for Drives (devcon rescan)
; - cleanUp
; - Eject Features integrieren

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------
#include %A_ScriptDir%\Library\TrayIconController.ahk
init_RemoveDriveHotkey:

	Prefix = rdh
	%Prefix%_ScriptName					= RemoveDriveHotkey
	%Prefix%_ScriptVersion				= 0.6.1
	%Prefix%_Author						= Michael Telgkamp
	RequireExtensions						=
	AddSettings_RemoveDriveHotkey		=
	ConfigFile_RemoveDriveHotkey		=

	CustomHotkey_RemoveDriveHotkey	= 1
	Hotkey_RemoveDriveHotkey			= #^x
	HotkeyPrefix_RemoveDriveHotkey	=
	IconFile_On_RemoveDriveHotkey		= %A_WinDir%\System32\hotplug.dll
	IconPos_On_RemoveDriveHotkey		= 1

	HideSettings							=
	gosub, LanguageCreation_RemoveDriveHotkey

	rdh_RemoveDriveExe = %A_ScriptDir%\Library\Tools\RemoveDrive.exe
	IfNotExist, %rdh_RemoveDriveExe%
		Description%A_Empty% = %Description% - %lng_rdh_RemoveDriveExeNotFound%

	IniRead, rdh_useTrueCrypt, %ConfigFile%, %rdh_ScriptName%, DismoutTrueCryptVolumes, 0
	gosub, rdh_setTrueCryptPath

	IniRead, rdh_replaceSRH, %ConfigFile%, %rdh_ScriptName%, replaceSRH, 0
	IniRead, rdh_DriveLetterTimeout, %ConfigFile%, %rdh_ScriptName%, Timeout, 3
	IniRead, rdh_ShowExtendedInfo, %ConfigFile%, %rdh_ScriptName%, ShowExtendedInfo, 0
	IniRead, rdh_DisabledDrives, %ConfigFile%, %rdh_ScriptName%, DisabledDrives, ABC
	IniRead, rdh_ejectCD, %ConfigFile%, %rdh_ScriptName%, EjectCD,
	if (rdh_ejectCD = "ERROR")
		rdh_ejectCD =
	IniRead, rdh_DisplayTransparency, %ConfigFile%, %rdh_ScriptName%, DisplayTransparency, 255
	IniRead, rdh_enableHandleHandling, %ConfigFile%, %rdh_ScriptName%, UseHandleExe, 0

	gosub, rdh_stdIcons

	Menu, RemoveDriveHotkey_Menu, Add, %RemoveDriveHotkey_EnableMenu%, sub_MenuCall
	Menu, RemoveDriveHotkey_Menu, Add,

	if _useTrayMenuIcons = 1
	{
		rdh_hTM := MI_GetMenuHandle("RemoveDriveHotkey_Menu")
		MI_SetMenuStyle(rdh_hTM, 0x4000000)
	}
	SubMenu = RemoveDriveHotkey_Menu

	gosub, rdh_updateDriveInformation
	SetTimer, rdh_updateDriveInformation, 60000
Return

TrayClick_lng_RemoveDriveHotkey:
LanguageCreation_RemoveDriveHotkey:
	If Lng = 07		; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName									= %rdh_ScriptName% - Wirft externe Laufwerke aus
		Description								= Wirft externe Laufwerke mit einem zweistufigen Tastenkürzel unter Benutzung des Programms RemoveDrive von Uwe Sieber aus.
		lng_rdh_DisplaySettings				= Weitere Einstellungen
		lng_rdh_DisplayTransparency		= Transparenz der Anzeigefenster
		tooltip_rdh_TransparencySlider	= 0 = nicht sichtbar — 255 = voll sichtbar
		lng_rdh_ShowExtendedInfo			= Erweiterte Informationen zeigen
		tooltip_rdh_ShowExtendedInfo		= Zeigt die verfügbaren Laufwerke mit Laufwerktyp und Label an.
		lng_rdh_ExtendedInfoHeader			= Laufwerk`tTyp`t`t`tLabel
		lng_rdh_Timeout						= Wartezeit auf Laufwerksbuchstaben
		lng_rdh_DisabledDrives				= Diese Laufwerke vor dem Auswerfen schützen (z.B. ABC)
		lng_rdh_ejectCD						= Bei diesen CD/DVD-Laufwerken Schublade öffnen
		lng_rdh_SearchCDROM					= Laufwerke finden
		lng_rdh_WaitingForInput				= Bitte den Buchstaben des auszuwerfenden Laufwerks eingeben.
		lng_rdh_RemoveDriveExeNotFound	= RemoveDrive.exe wurde nicht gefunden.
		rdh_lng_InvlaidDriveLetter			= Keine gültiger Laufwerksbuchstabe.
		rdh_lng_InvlaidDrive					= Ungültiges Laufwerk zum Auswerfen mit RemoveDrive.`nWenn trennen mit TrueCrypt aktiv ist, wurde dies erfolglos versucht.
		lng_rdh_NoDrivesAvailable			= Keine Laufwerke zum Auswerfen verfügbar
		lng_rdh_TryToRemove					= RemoveDrive versucht das Laufwerk auszuwerfen.
		lng_rdh_NetTryToRemove				= Es wird versucht das Netzwerklaufwerk abzumelden.
		lng_rdh_SuccessfullyRemoved		= erfolgreich ausgeworfen.
		lng_rdh_TC_SuccessfullyRemoved	= erfolgreich getrennt (TrueCrypt Laufwerk).
		lng_rdh_IdentifiedButNotRemoved	= Laufwerk wurde identifiziert, konnte aber nicht ausgeworfen werden.
		lng_rdh_NetNotRemoved				= Netzwerklaufwerk konnte nicht abgemeldet werden.
		lng_rdh_NetSuccessfullyRemoved	= Netzwerklaufwerk wurde erfolgreich abgemeldet.
		lng_rdh_CopiedToRemove				= RemoveDrive ist auf dem auszuwerfenden Laufwerk.`n-> Temporäre Kopie wurde ausgeführt.`n-> Keine Aussage über Erfolg verfügbar.
		rdh_lng_InputAborted					= Eingabeabfrage abgebrochen.
		rdh_lng_DisabledDrives				= Laufwerk ist in der Liste der geschützten Laufwerke.
		lng_rdh_UnknownError					= Unbekannter Fehler.
		lng_rdh_NoLabel						= (Keine Beschriftung)
		lng_rdh_openCDTray					= Es wird versucht die CD/DVD-Schublade zu öffnen
		lng_rdh_closeCDTray					= Es wird versucht die CD/DVD-Schublade zu schließen
		RemoveDriveHotkey_EnableMenu		= RemoveDriveHotkey aktiv
		lng_rdh_useIcons						= Im Untermenü vom ac'tivAid-Tray-Menü Icons anzeigen (verursacht evtl. Fehler bei Verwendung von PastePlain etc.)
		lng_rdh_trayReplace					= Hardware sicher entfernen
		lng_rdh_replaceSRH					= "Hardware sicher entfernen" ersetzen
		lng_TrayClick_RemoveDriveHotkey	= RemoveDriveHotkey-Menü anzeigen
		lng_rdh_openExplorer					= Explorer Fenster wird geöffnet
		lng_rdh_useTrueCrypt					= TrueCrypt Volumes trennen
	}
	else			; = Alternativ-Sprache
	{
		MenuName									= %rdh_ScriptName% - Removes external drives
		Description								= Removes external drives with a two level hotkey using the software RemoveDrive from Uwe Sieber.
		lng_rdh_DisplaySettings				= Additional settings
		lng_rdh_DisplayTransparency		= Transparency of Splash Screen
		tooltip_rdh_TransparencySlider	= 0 = do not display — 255 = completely display
		lng_rdh_ShowExtendedInfo			= Display extended information
		tooltip_rdh_ShowExtendedInfo		= Displays the available drives together with type and label of drive.
		lng_rdh_ExtendedInfoHeader			= Drive`t`tType`t`t`tLabel
		lng_rdh_Timeout						= Timeout for drive letter key
		lng_rdh_DisabledDrives				= Protect these drives from being removed (e.g. ABC)
		lng_rdh_ejectCD						= Open tray of these CD/DVD drives
		lng_rdh_SearchCDROM					= refresh
		lng_rdh_WaitingForInput				= Please input the letter of the drive you want to remove.
		lng_rdh_RemoveDriveExeNotFound	= RemoveDrive.exe was not found.
		rdh_lng_InvlaidDriveLetter			= No valid drive letter.
		rdh_lng_InvlaidDrive					= Invalid Drive to remove with RemoveDrive.`nIf dismount using TrueCrypt is active, it has been tried without success.
		lng_rdh_NoDrivesAvailable			= No drives available.
		lng_rdh_TryToRemove					= RemoveDrive tries to remove the drive.
		lng_rdh_NetTryToRemove				= Trying to disassociate the network drive.
		lng_rdh_SuccessfullyRemoved		= successfully removed.
		lng_rdh_TC_SuccessfullyRemoved	= successfully dismounted (TrueCrypt Volume).
		lng_rdh_IdentifiedButNotRemoved	= Drive has been identified, but could not be removed.
		lng_rdh_NetNotRemoved				= The network drive could not be disassociated.
		lng_rdh_NetSuccessfullyRemoved	= The network drive is disassociated successfully.
		lng_rdh_CopiedToRemove				= RemoveDrive located on the drive to remove.`n-> Temporary copy created and executed.`n-> No success message available.
		rdh_lng_InputAborted					= Input request aborted.
		rdh_lng_DisabledDrives				= Drive is in the list of protected drives.
		lng_rdh_UnknownError					= Unknown Error.
		lng_rdh_NoLabel						= (No Label)
		lng_rdh_openCDTray					= Trying to open the CD/DVD tray
		lng_rdh_closeCDTray					= Trying to close the CD/DVD tray
		RemoveDriveHotkey_EnableMenu		= RemoveDriveHotkey active
		lng_rdh_useIcons						= Show icons in the submenu of the ac'tivAid tray menu (could cause errors while using PastePlain etc.)
		lng_rdh_trayReplace					= Safely Remove Hardware
		lng_rdh_replaceSRH					= Replace "Safely Remove Hardware"
		lng_TrayClick_RemoveDriveHotkey	= Show RemoveDriveHotkey menu
		lng_rdh_openExplorer					= Opening Explorer window
		lng_rdh_useTrueCrypt					= Dismount TrueCrypt Volumes
	}
return
; -----------------------------------------------------------------------------
; === Settings GUI ============================================================
; -----------------------------------------------------------------------------

SettingsGui_RemoveDriveHotkey:
	Gui, Add, Text, xs+10 y+20, %lng_rdh_Timeout%:
	Gui, Add, Edit, xs+300 yp-3 R1 -Wrap w20 gsub_CheckIfSettingsChanged vrdh_DriveLetterTimeout, %rdh_DriveLetterTimeout%
	Gui, Add, Text, xs+330 yp+3, s

	Gui, Add, Text, xs+10 y+10, %lng_rdh_ShowExtendedInfo%:
	Gui, Add, Checkbox, xs+300 yp+0 gsub_CheckIfSettingsChanged vrdh_ShowExtendedInfo checked%rdh_ShowExtendedInfo%
	Gui, Add, Text, xs+10 y+10, %lng_rdh_useTrueCrypt%:
	Gui, Add, Checkbox, xs+300 yp+0 gsub_CheckIfSettingsChanged vrdh_useTrueCrypt checked%rdh_useTrueCrypt%
	Gui, Add, Edit, xs+330 yp-3 w150 r1 -wrap gsub_CheckIfSettingsChanged vrdh_TrueCryptPath, %rdh_TrueCryptPath%
	Gui, Add, Button, xs+480 yp-1 v50 grdh_TC_select, ...

	Gui, Add, Text, xs+10 y+8, %lng_rdh_replaceSRH%:
	Gui, Add, Checkbox, xs+300 yp+0 gsub_CheckIfSettingsChanged vrdh_replaceSRH checked%rdh_replaceSRH%

	Gui, Add, Text, xs+10 y+10, %lng_rdh_DisabledDrives%:
	Gui, Add, Edit, xs+300 yp-3 R1 -Wrap w150 gsub_CheckIfSettingsChanged vrdh_DisabledDrives, %rdh_DisabledDrives%
	Gui, Add, Text, xs+10 y+8, %lng_rdh_ejectCD%:
	Gui, Add, Edit, xs+300 yp-3 R1 -Wrap w150 gsub_CheckIfSettingsChanged vrdh_ejectCD, %rdh_ejectCD%
	Gui, Add, Button, x+5 yp+0 -Wrap w90 h21 grdh_sub_SearchCDROM, %lng_rdh_SearchCDROM%

	Gui, Add, Text, xs+10 y+8, %lng_rdh_DisplayTransparency%:
	rdh_TransparencySlider := rdh_DisplayTransparency

	Gui, Add, Slider, xs+295 yp-5 w255 h30 vrdh_TransparencySlider Range0-255 AltSubmit TickInterval5 ToolTip Line5 grdh_sub_Color, %rdh_TransparencySlider%

	if (Enable_FileHandle)
	{
		Gui, Tab, RemoveDriveHotkey
		Gui, Add, Text, xs+10 y+10, %lng_fh_EnableHandleHandling%:
		Gui, Add, Checkbox, xs+300 yp+0 gsub_CheckIfSettingsChanged vrdh_enableHandleHandling checked%rdh_enableHandleHandling%
	}

Return

rdh_TC_select:
	Gui %GuiID_activAid%:+OwnDialogs
	GuiControlGet, rdh_TrueCryptPath_tmp,,rdh_TrueCryptPath
	FileSelectFile,rdh_TrueCryptPath_tmp,1,%rdh_TrueCryptPath_tmp%
	If fileexist(rdh_TrueCryptPath_tmp)
		GuiControl, , rdh_TrueCryptPath, %rdh_TrueCryptPath_tmp%
Return

rdh_setTrueCryptPath:
	IniRead, rdh_TrueCryptPath, %ConfigFile%, %rdh_ScriptName%, TrueCryptPath, %A_Space%
	if(!fileexist(rdh_TrueCryptPath))
		rdh_TrueCryptPath := a_programfiles "\TrueCrypt\TrueCrypt.exe"
	if(!fileexist(rdh_TrueCryptPath))
	{
		rdh_TrueCryptPath =
		if(rdh_TrueCryptPath = "")
		{
			RegRead , rdh_TC_Path , HKLM , SOFTWARE\Classes\Applications\TrueCrypt.exe\shell\open\command\
			If !Errorlevel
				rdh_TrueCryptPath := regexreplace(rdh_TC_Path, "^""(.*?)"".*", "$1")
		}
	}
Return

rdh_sub_Color:
	Critical
	GuiControlGet, rdh_DisplayTransparency_tmp,,rdh_TransparencySlider
	If A_IsSuspended <> 1
		func_SettingsChanged( rdh_ScriptName )
Return

rdh_sub_searchCDROM:
	DriveGet, rdh_ActiveDriveLetters, list
	rdh_NumberOfDrives := strlen(rdh_ActiveDriveLetters)
	Loop,%rdh_NumberOfDrives%
	{
		rdh_currentDrive := SubStr(rdh_ActiveDriveLetters,A_Index,1)
		DriveGet,rdh_Type_%rdh_currentDrive%,Type,%rdh_currentDrive%:
		IfInString,rdh_Type_%rdh_currentDrive%,CDROM
			rdh_ejectCD_tmp := rdh_ejectCD_tmp rdh_currentDrive
	}
	GuiControl, , rdh_ejectCD, %rdh_ejectCD_tmp%
	rdh_ejectCD_tmp =
Return

SaveSettings_RemoveDriveHotkey:
	gosub, rdh_setTrueCryptPath
	if(rdh_RemoveDriveExe_tmp <> "")
		rdh_RemoveDriveExe := rdh_RemoveDriveExe_tmp
	if(rdh_DisplayTransparency_tmp <> "")
		rdh_DisplayTransparency := rdh_DisplayTransparency_tmp
	IniWrite, %rdh_replaceSRH%, %ConfigFile%, %rdh_ScriptName%, replaceSRH
	IniWrite, %rdh_useTrueCrypt%, %ConfigFile%, %rdh_ScriptName%, DismoutTrueCryptVolumes
	IniWrite, %rdh_TrueCryptPath%, %ConfigFile%, %rdh_ScriptName%, TrueCryptPath
	IniWrite, %rdh_DriveLetterTimeout%, %ConfigFile%, %rdh_ScriptName%, Timeout
	IniWrite, %rdh_ShowExtendedInfo%, %ConfigFile%, %rdh_ScriptName%, ShowExtendedInfo
	IniWrite, %rdh_DisabledDrives%, %ConfigFile%, %rdh_ScriptName%, DisabledDrives
	IniWrite, %rdh_ejectCD%, %ConfigFile%, %rdh_ScriptName%, EjectCD
	IniWrite, %rdh_DisplayTransparency%, %ConfigFile%, %rdh_ScriptName%, DisplayTransparency
	IniWrite, %rdh_enableHandleHandling%, %ConfigFile%, %rdh_ScriptName%, UseHandleExe

	gosub, rdh_updateDriveInformation
Return

CancelSettings_RemoveDriveHotkey:
Return

DoEnable_RemoveDriveHotkey:
	if rdh_replaceSRH
	{
		/*
		;Erkennen und entfernen des System-Icons verursacht Probleme bei RealExpose.
		rdh_foundIcon = 0
		rdh_TrayList := TrayIcons()

		Loop, parse, rdh_TrayList, `n
		{
			IfInString, A_LoopField, explorer.exe
			{
					;eng
					IfInString, A_LoopField, Safely Remove Hardware
						rdh_foundIcon = 1

					;ger
					IfInString, A_LoopField, Hardware sicher entfernen
						rdh_foundIcon = 1



					if rdh_foundIcon = 1
					{
						rdh_needle := "idn: ([0-9]+)"
						rdh_idn =
						FoundPos := RegExMatch(A_LoopField,rdh_needle,rdh_idn)

						StringTrimLeft,rdh_idn,rdh_idn,5
						HideTrayIcon(rdh_idn,true)
						break
					}
			}
		}
		*/
		CreateGuiID("RemoveDriveHotkey_TrayHook")
		GuiDefault("RemoveDriveHotkey_TrayHook","+LastFound")
		Gui, Add, Text,,empty
		Gui,Show,x200 y200 w200 h200 Hide, RemoveDriveHotkey TrayHook

		rdh_hWnd := WinExist()
		rdh_hIcon = %A_WinDir%\System32\hotplug.dll
		rdh_hIcon := ExtractIcon(rdh_hIcon, 1)

		rdh_hTrayIcon := Tray_Add( rdh_hWnd, "rdh_onTrayMessage", rdh_hIcon, lng_rdh_trayReplace)
	}

	RegisterAction("RemoveDrive",rdh_ScriptName,"sub_Action_RemoveDriveHotkey")
	;RegisterECMenu("RemoveDrive",rdh_ScriptName,"sub_Action_RemoveDriveHotkey",rdh_ScriptName)

	gosub, rdh_updateDriveInformation
	SetTimer, rdh_updateDriveInformation, 60000
Return

DoDisable_RemoveDriveHotkey:
	if rdh_replaceSRH
	{
		if rdh_hTrayIcon !=
			Tray_Remove( rdh_hWnd, rdh_hTrayIcon)

		HideTrayIcon(rdh_idn,false)
		GuiDefault("RemoveDriveHotkey_TrayHook","+LastFound")
		Gui, Destroy
	}

	UnRegisterAction("RemoveDrive")
	SetTimer, rdh_updateDriveInformation, Off
Return

DefaultSettings_RemoveDriveHotkey:
	IniDelete, %ConfigFile%, %ta_ScriptName%
Return

OnExitAndReload_RemoveDriveHotkey:
	if rdh_replaceSRH
	{
		if rdh_hTrayIcon !=
			Tray_Remove( rdh_hWnd, rdh_hTrayIcon)

		GuiDefault("RemoveDriveHotkey_TrayHook","+LastFound")
		Gui, Destroy
	}

	SetTimer, rdh_updateDriveInformation, Off
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

sub_Hotkey_RemoveDriveHotkey:
	gosub, rdh_updateDriveInformation

	If (rdh_NumberOfDrives < 1)
	{
		InfoScreen(rdh_ScriptName,lng_rdh_NoDrivesAvailable,rdh_DisplayTransparency,3)
		Return
	}


	InfoScreen(rdh_ScriptName, lng_rdh_WaitingForInput rdh_ExtendedInfo,rdh_DisplayTransparency,rdh_DriveLetterTimeout)
	Input, rdh_Driveletter, L1 M T%rdh_DriveLetterTimeout%,{esc}

	If ErrorLevel = Timeout
		; no drive letter is given
		InfoScreen(rdh_ScriptName,rdh_lng_InputAborted,rdh_DisplayTransparency,0.5,"$3")
	else If ErrorLevel = Endkey:Escape
		; Esc pressed
		InfoScreen(rdh_ScriptName,rdh_lng_InputAborted,rdh_DisplayTransparency,0.2,"$3")
	else IfNotInString,rdh_ActiveDriveLetters,%rdh_Driveletter%
		InfoScreen(rdh_ScriptName,rdh_lng_InvlaidDriveLetter rdh_DriveLetter,rdh_DisplayTransparency,2,"$3")
	else IfInString,rdh_DisabledDrives,%rdh_Driveletter%
		InfoScreen(rdh_ScriptName,rdh_lng_DisabledDrives,rdh_DisplayTransparency,2,"$3")
	else if (asc(rdh_DriveLetter) < 26)
	{
		rdh_Driveletter := chr(asc(rdh_DriveLetter)+96)
		InfoScreen(rdh_ScriptName,lng_rdh_openExplorer,rdh_DisplayTransparency,2,"$2")
		Run, %FileBrowserWithTree% %rdh_Driveletter%:\
	}
	else
		gosub, rdh_removeDrive
Return

sub_Action_RemoveDriveHotkey:
	rdh_Driveletter := ActionParameter
	StringLeft, rdh_Driveletter, rdh_Driveletter, 1
	if rdh_Driveletter !=
	{
		IfNotInString,rdh_ActiveDriveLetters,%rdh_Driveletter%
			InfoScreen(rdh_ScriptName,rdh_lng_InvlaidDriveLetter,rdh_DisplayTransparency,2,"$3")
		else IfInString,rdh_DisabledDrives,%rdh_Driveletter%
			InfoScreen(rdh_ScriptName,rdh_lng_DisabledDrives,rdh_DisplayTransparency,2,"$3")
		else
			gosub, rdh_removeDrive
	}
Return

; -----------------------------------------------------------------------------
; === Traymenu Routines =======================================================
; -----------------------------------------------------------------------------

TrayClick_RemoveDriveHotkey:
	Gosub, rdh_showMenu
Return

rdh_showMenu:
	rdh_Suspend = %A_IsSuspended%
	If rdh_Suspend = 0
		Suspend, On
	MI_ShowMenu(rdh_hTM)
	If rdh_Suspend = 0
		Suspend, Off
return

rdh_onTrayMessage:
	if (Tray_EVENT = "L" || Tray_EVENT = "R")
		gosub, rdh_showMenu
return

rdh_stdIcons:
	;RegRead, rdh_driveIco, HKEY_CLASSES_ROOT, Drive\DefaultIcon
	rdh_hdIconFile = %A_WinDir%\system32\shell32.dll
	rdh_hdIconIndex = 8

	rdh_cdIconFile = %A_WinDir%\system32\shell32.dll
	rdh_cdIconIndex = 12

	rdh_netIconFile = %A_WinDir%\system32\shell32.dll
	rdh_netIconIndex = 10
return

rdh_clearMenu:
	Loop, parse, rdh_customMenuItems, `n,
		if A_LoopField !=
			Menu, RemoveDriveHotkey_Menu, Delete, %A_LoopField%
return

rdh_removeFromTrayMenu:
	StringLeft, rdh_Driveletter, A_ThisMenuItem,1
	gosub, rdh_removeDrive
return


; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

rdh_updateDriveInformation:
	if (StrLen(rdh_customMenuItems)>1)
		gosub, rdh_clearMenu
	rdh_customMenuItems =

	DriveGet, rdh_ActiveDriveLetters, list

	if rdh_DisabledDrives <>
		rdh_ActiveDriveLetters := RegExReplace(rdh_ActiveDriveLetters,"[" rdh_DisabledDrives "]")

	rdh_NumberOfDrives := strlen(rdh_ActiveDriveLetters)

	If (rdh_NumberOfDrives < 1)
		Return

	if (rdh_ShowExtendedInfo)
		rdh_ExtendedInfo := "`n`n" lng_rdh_ExtendedInfoHeader

	Loop,%rdh_NumberOfDrives%
	{
		rdh_currentDrive := SubStr(rdh_ActiveDriveLetters,A_Index,1)
		rdh_pos := A_Index+2
		DriveGet,rdh_Label_%rdh_currentDrive%,Label,%rdh_currentDrive%:
		if rdh_Label_%rdh_currentDrive% =
			rdh_Label_%rdh_currentDrive% = %lng_rdh_NoLabel%
		DriveGet,rdh_Type_%rdh_currentDrive%,Type,%rdh_currentDrive%:
		IfInString,rdh_Type_%rdh_currentDrive%,Fixed
			rdh_Type_%rdh_currentDrive% := rdh_Type_%rdh_currentDrive% " Drive"
		if (rdh_ShowExtendedInfo)
			rdh_ExtendedInfo := rdh_ExtendedInfo "`n" rdh_currentDrive "`t`t" rdh_Type_%rdh_currentDrive% "`t`t" rdh_Label_%rdh_currentDrive%

		rdh_TrayString := rdh_currentDrive . ": [" . rdh_Label_%rdh_currentDrive% . "]"
		rdh_customMenuItems = %rdh_customMenuItems%`n%rdh_TrayString%
		Menu, RemoveDriveHotkey_Menu, Add, %rdh_TrayString%, rdh_removeFromTrayMenu

		if _useTrayMenuIcons = 1
		{
			if rdh_Type_%rdh_currentDrive% = Fixed Drive
				MI_SetMenuItemIcon(rdh_hTM, rdh_pos, rdh_hdIconFile, rdh_hdIconIndex, 16)

			if rdh_Type_%rdh_currentDrive% = CDROM
				MI_SetMenuItemIcon(rdh_hTM, rdh_pos, rdh_cdIconFile, rdh_cdIconIndex, 16)

			if rdh_Type_%rdh_currentDrive% = Network
				MI_SetMenuItemIcon(rdh_hTM, rdh_pos, rdh_netIconFile, rdh_netIconIndex, 16)
		}
	}
return

rdh_removeDrive:
	if (rdh_Type_%rdh_Driveletter% == "CDROM" && InStr(rdh_ejectCD,rdh_Driveletter))
	{
		; if the drive letter is in the list of CD drives, RDH opens the tray
		; RemoveDrive is not started
		rdh_TickCount = %A_TickCount%
		StringUpper, rdh_RemoveDriveInfo, rdh_Driveletter
		rdh_RemoveDriveInfo := "'" rdh_RemoveDriveInfo ":' (CD-ROM) "
		InfoScreen(rdh_ScriptName,rdh_RemoveDriveInfo " " lng_rdh_openCDTray,rdh_DisplayTransparency,3,"$2")
		Drive, Eject, %rdh_Driveletter%:
		If (A_TickCount - rdh_TickCount < 1000 AND rdh_OnlyEject <> 1)
		{
			InfoScreen(rdh_ScriptName,rdh_RemoveDriveInfo " " lng_rdh_closeCDTray,rdh_DisplayTransparency,3,"$2")
			Drive, Eject, %rdh_Driveletter%:, 1
			rdh_Close = 1
		}
	}
	else if (rdh_Type_%rdh_Driveletter% == "Network")
	{
		InfoScreen(rdh_ScriptName,lng_rdh_NetTryToRemove,rdh_DisplayTransparency)
		Run, net use %rdh_Driveletter%: /delete,, Hide UseErrorlevel, rdh_netPID
		DetectHiddenWindows, On
		WinWait, ahk_pid %rdh_netPID%,, 1
		WinWaitClose, ahk_pid %rdh_netPID%,,3
		rdh_errorlevel := ErrorLevel
		rdh_netPID =
		If rdh_errorlevel = 1
		{
			InfoScreen(rdh_ScriptName,rdh_Driveletter ":\ " lng_rdh_NetNotRemoved,rdh_DisplayTransparency,5,"$3")
		}
		Else
			InfoScreen(rdh_ScriptName,rdh_Driveletter ":\ " lng_rdh_NetSuccessfullyRemoved,rdh_DisplayTransparency,3,"$2")
	}
	else
	{
		If (!FileExist(rdh_RemoveDriveExe))
		{
			InfoScreen(rdh_ScriptName,lng_rdh_RemoveDriveExeNotFound,rdh_DisplayTransparency,3)
			Return
		}
		InfoScreen(rdh_ScriptName,lng_rdh_TryToRemove,rdh_DisplayTransparency)
		RunWait, %ComSpec% /c ""%rdh_RemoveDriveExe%" %rdh_Driveletter%: > "%A_Temp%\RemoveDriveOutput.tmp"",,Hide
		rdh_errorlevel := ErrorLevel
		FileRead, rdh_RemoveDriveOutput, %A_Temp%\RemoveDriveOutput.tmp
		FileDelete, %A_Temp%\RemoveDriveOutput.tmp
			rdh_infoPosition := InStr(rdh_RemoveDriveOutput,"'")
			rdh_RemoveDriveInfo := SubStr(rdh_RemoveDriveOutput,rdh_infoPosition)
		if(rdh_errorlevel = 0)
		{
			rdh_RemoveDriveInfo := SubStr(rdh_RemoveDriveInfo,1,-13)
			InfoScreen(rdh_ScriptName,rdh_RemoveDriveInfo " " lng_rdh_SuccessfullyRemoved,rdh_DisplayTransparency,3,"$2")
			Return
		}
		else if(rdh_errorlevel = 1)
		{
			If(InStr(rdh_RemoveDriveOutput,"Invalid"))
			{
				if(rdh_useTrueCrypt and fileexist(rdh_TrueCryptPath))
				{
					runwait, %rdh_TrueCryptPath% /q /s /d %rdh_Driveletter%, , UseErrorLevel
					if(ErrorLevel=0)
					{
						InfoScreen(rdh_ScriptName, rdh_Driveletter ":\ " lng_rdh_TC_SuccessfullyRemoved, rdh_DisplayTransparency,3,"$2")
						Return
					}
					else
					{
						InfoScreen(rdh_ScriptName, rdh_Driveletter ":\ " lng_rdh_IdentifiedButNotRemoved, rdh_DisplayTransparency,5,"$3")
						Return
					}
				}
				else
				{
					InfoScreen(rdh_ScriptName,rdh_lng_InvlaidDrive,rdh_DisplayTransparency,5,"$3")
				}
			}
			else
			{
				rdh_RemoveDriveInfo := SubStr(rdh_RemoveDriveInfo,1,-12)
				InfoScreen(rdh_ScriptName,rdh_RemoveDriveInfo "`n" lng_rdh_IdentifiedButNotRemoved,rdh_DisplayTransparency,5,"$3")

				if (Enable_FileHandle && rdh_enableHandleHandling)
					performAction("ShowHandles",rdh_Driveletter ":\|RemoveDrive")
			}
		}
		else if(rdh_errorlevel = 4)
			InfoScreen(rdh_ScriptName,lng_rdh_CopiedToRemove,rdh_DisplayTransparency,5,"$1")
		else
			InfoScreen(rdh_ScriptName,lng_rdh_UnknownError "`n" rdh_RemoveDriveOutput,rdh_DisplayTransparency,5,"$3")
	}

	gosub, rdh_updateDriveInformation
return
