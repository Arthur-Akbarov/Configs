; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               DesktopIcons
; -----------------------------------------------------------------------------
; Prefix:             dsi_
; Version:            0.1
; Date:               2008-07-30
; Author:             David Hilberath
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_DesktopIcons:
	Prefix = dsi
	%Prefix%_ScriptName    = DesktopIcons
	%Prefix%_ScriptVersion = 0.1
	%Prefix%_Author        = David Hilberath

	CustomHotkey_DesktopIcons = 0
	HotkeyPrefix_DesktopIcons =
	IconFile_On_DesktopIcons  = %A_WinDir%\system32\shell32.dll
	IconPos_On_DesktopIcons   = 95

	gosub, LanguageCreation_DesktopIcons
	gosub, LoadSettings_DesktopIcons

	RegisterAdditionalSetting("dsi", "autoIgnoreDriveIcons", 1)
	RegisterAdditionalSetting("dsi", "useAutoLoading",0)
	RegisterAdditionalSetting("dsi", "showBalloonTips", 1)
Return

SettingsGui_DesktopIcons:
	; func_HotkeyAddGuiControl( lng_di_TEXT, "di_HOTKEYNAME", "xs+10 y+10 w160" )
	; Gui, Add, Edit, xs+10 y+5 gsub_CheckIfSettingsChanged vdi_var, %lng_di_text%

	func_HotkeyAddGuiControl( lng_dsi_lastUsed, "dsi_resolutionChange", "xs+10 y+5 w160" )

	Gui, Add, GroupBox, xs+10 ys+35 w120 h250, %lng_dsi_title_profile%
	Gui, Add, ListBox, xp+7 yp+17 w105 h200 T42 -Multi vdsi_lb_allProfiles gdsi_lb_selection AltSubmit, %dsi_allProfiles%
	Gui, Add, Button, -Wrap xp+0 y+5 w25 h16 gdsi_newProfile, +
	Gui, Add, Button, -Wrap x+5 h16 w25 gdsi_delProfile, %MinusString%
	Gui, Add, Button, -Wrap x+25 h16 w25 gdsi_useSelectedProfile, ~

	Gui, Add, GroupBox, xs+135 ys+35 w260 h250, %lng_dsi_title_details%
	Gui, Add, ListView, xp+7 yp+17 w245 h200 -Hdr vdsi_ListView, Name|x|y

	/*
	Gui, Add, GroupBox, xs+410 ys+35 w150 h250, %lng_dsi_title_ignore%
	Gui, Add, ListBox, xp+7 yp+17 w135 h215, %dsi_ignoreList%
*/
Return

dsi_delProfile:
	GuiControlGet,dsi_delProfile,,dsi_lb_allProfiles
	dsi_delProfile_Name := dsi_profile%dsi_delProfile%

	dsi_delRows := dsi_NumProfiles - dsi_delProfile
	Loop, %dsi_delRows%
	{
		dsi_nextRow := dsi_delProfile + A_Index
		dsi_thisRow := dsi_nextRow - 1

		dsi_Profile%dsi_thisRow% := dsi_Profile%dsi_nextRow%
		dsi_List%dsi_thisRow% := dsi_List%dsi_nextRow%
	}

	dsi_numProfiles--

	StringReplace, dsi_allProfiles, dsi_allProfiles, %dsi_delProfile_Name%|,,A
	GuiControl,,dsi_lb_allProfiles, |%dsi_allProfiles%
	gosub, dsi_lb_selection
	func_SettingsChanged("DesktopIcons")
return

dsi_lb_selection:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, dsi_ListView

	GuiControlGet, dsi_tmp_selected,,dsi_lb_allProfiles
	LV_Delete()

	dsi_tmp_list := dsi_list%dsi_tmp_selected%
	loop, parse, dsi_tmp_list, *
	{
		if A_LoopField !=
		{
			StringSplit, dsi_tmpArray, A_LoopField, |
			LV_Add("",dsi_tmpArray1,dsi_tmpArray2,dsi_tmpArray3)
		}
	}

	GuiControl,,dsi_cbox_resolution,% dsi_autoResolution%dsi_tmp_selected%

	LV_ModifyCol(1,150)
	LV_ModifyCol(2)
	LV_ModifyCol(3)
return

dsi_newProfile:
	dsi_newProfileName = %A_ScreenWidth%x%A_ScreenHeight%

	Loop, %dsi_numProfiles%
	{
		dsi_tmpLoopField := dsi_Profile%A_Index%

		if dsi_tmpLoopField = %dsi_newProfileName%
		{
			Msgbox, 4, %dsi_ScriptName%, %lng_dsi_overrideProfile%`n  %dsi_newProfileName%
			IfMsgBox Yes
			{
				dsi_list%A_Index% := dsi_desktopIcons()
				gosub, dsi_lb_selection
				func_SettingsChanged("DesktopIcons")
			}

			return
		}
	}

	dsi_numProfiles++
	dsi_profile%dsi_numProfiles% := dsi_newProfileName
	dsi_list%dsi_numProfiles% := dsi_desktopIcons()
	dsi_allProfiles = %dsi_allProfiles%%dsi_newProfileName%|
	GuiControl,,dsi_lb_allProfiles,|%dsi_allProfiles%
	gosub, dsi_lb_selection

	func_SettingsChanged("DesktopIcons")
return

dsi_useSelectedProfile:
	GuiControlGet, dsi_tmp_selected,,dsi_lb_allProfiles

	dsi_DesktopIcons(dsi_list%dsi_tmp_selected%)
return

LanguageCreation_DesktopIcons:
	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %dsi_ScriptName% - Speichert Desktopicons
		Description                   = Speichert die Positionen der Desktopicons und stellt sie wieder her

		lng_dsi_lastUsed               = Lade passendes Profil
		lng_dsi_title_profile          = Profile
		lng_dsi_title_details          = Details
		lng_dsi_title_ignore           = Zu ignorierende Symbole
		lng_dsi_combo_autoLoadAt       = Anwenden bei
		lng_dsi_useAutoLoading         = Profile bei Auflösungswechsel automatisch laden
		lng_dsi_autoIgnoreDriveIcons   = DriveIcons Symbole ignorieren
		lng_dsi_create                 = Aktuelle Positionen
		lng_dsi_use                    = Aktivieren
		lng_dsi_edit                   = Editieren
		lng_dsi_enterTitle             = Bitte einen Namen für das neue Profil angeben
		lng_dsi_overrideProfile        = Das Profil existiert bereits! Überschreiben?
		lng_dsi_iconsLoaded            = Iconpositionen wiederhergestellt
		lng_dsi_showBalloonTips        = BalloonTips anzeigen
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %dsi_ScriptName% - Save position of desktop icons
		Description                   = Saves and restores desktop icons

		lng_dsi_lastUsed               = Load fitting profile
		lng_dsi_title_profile          = Profiles
		lng_dsi_title_details          = Details
		lng_dsi_title_ignore           = Ignore these icons
		lng_dsi_combo_autoLoadAt       = Auto load at
		lng_dsi_useAutoLoading         = Automatically load profiles on resolution changes
		lng_dsi_autoIgnoreDriveIcons   = Ignore DriveIcons icons
		lng_dsi_create                 = Current positions
		lng_dsi_use                    = Activate
		lng_dsi_edit                   = Edit
		lng_dsi_enterTitle             = Please enter a name for the new profile
		lng_dsi_overrideProfile        = Profile already exists! Overwrite?
		lng_dsi_iconsLoaded            = Recovered icon positions
		lng_dsi_showBalloonTips        = BalloonTips anzeigen
	}
Return

LoadSettings_DesktopIcons:
	; IniRead, dsi_VARIABLE, %ConfigFile%, %dsi_ScriptName%, INI-Variable, DEFAULTWERT
	func_HotkeyRead("dsi_resolutionChange", ConfigFile, dsi_ScriptName, "ArrangeIcons", "dsi_resolutionChange", "")

	IniRead, dsi_numProfiles, %ConfigFile%, %dsi_ScriptName%, NumProfiles, 0
	IniRead, dsi_ignoreList, %ConfigFile%, %dsi_ScriptName%, IgnoreList, %A_Space%

	Loop, %dsi_numProfiles%
	{
		IniRead, dsi_profile%A_Index%, %ConfigFile%, %dsi_ScriptName%, Profile%A_index%, %A_Space%
		IniRead, dsi_list%A_Index%, %ConfigFile%, %dsi_ScriptName%, ProfileList%A_index%, %A_Space%

		dsi_allProfiles := dsi_allProfiles dsi_profile%A_Index% "|"
	}
Return

SaveSettings_DesktopIcons:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, dsi_ListView

	func_HotkeyWrite( "dsi_resolutionChange", ConfigFile , dsi_ScriptName, "ArrangeIcons" )

	IniWrite, %dsi_numProfiles%, %ConfigFile%, %dsi_ScriptName%, NumProfiles
	IniWrite, %dsi_ignoreList%, %ConfigFile%, %dsi_ScriptName%, IgnoreList

	Loop, %dsi_numProfiles%
	{
		dsi_tmp_list := dsi_list%A_Index%
		dsi_tmp_profile := dsi_profile%A_Index%

		IniWrite, %dsi_tmp_profile%, %ConfigFile%, %dsi_ScriptName%, Profile%A_index%
		IniWrite, %dsi_tmp_list%, %ConfigFile%, %dsi_ScriptName%, ProfileList%A_index%
	}
Return

AddSettings_DesktopIcons:
Return

CancelSettings_DesktopIcons:
Return

DoEnable_DesktopIcons:
	func_HotkeyEnable("dsi_resolutionChange")

	if dsi_useAutoloading = 1
	{
		registerEvent("resolutionChange","dsi_resolutionChange")
	}
Return

DoDisable_DesktopIcons:
	func_HotkeyDisable("dsi_resolutionChange")
Return

DefaultSettings_DesktopIcons:
Return

OnExitAndReload_DesktopIcons:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_DesktopIcons:
	; Hier kommen die Befehle hin, welche bei Win+F5 ausgeführt werden
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

dsi_resolutionChange:
	dsi_newResolution = %A_ScreenWidth%x%A_ScreenHeight%

	Loop, %dsi_numProfiles%
	{
		if dsi_Profile%A_Index% = %dsi_newResolution%
		{
			dsi_DesktopIcons(dsi_list%A_Index%)
			break
		}
	}
return

dsi_desktopIcons(list="")
{
	;Global Enable_DriveIcons, dsi_autoIgnoreDriveIcons, dsi_ignoreList
	Global

	dsi_diIgnoreList =
	if (dsi_autoIgnoreDriveIcons = 1 && Enable_DriveIcons = 1)
	{
		Loop, parse, di_DriveLetters
		{
			SplitPath, di_dsi_filenames%A_LoopField%, dsi_tmp_diIgnoreList
			dsi_diIgnoreList = %dsi_diIgnoreList%%dsi_tmp_diIgnoreList%|
		}
	}

	ControlGet, IconList, List, , SysListView321, Program Manager ahk_class Progman
	result =
	Loop, Parse, IconList, `n
	{
		StringSplit, itemName, A_LoopField, %A_Tab%
		itemNo := A_Index

		if list =
		{
			WinGet, pid_target, PID, Program Manager ahk_class Progman

			hp_explorer := DllCall( "OpenProcess", "uint", 0x18, "int", false, "uint", pid_target )
			remote_buffer := DllCall( "VirtualAllocEx", "uint", hp_explorer, "uint", 0, "uint", 0x1000, "uint", 0x1000, "uint", 0x4 )

			SendMessage, 0x1000+16,% A_Index -1, remote_buffer, SysListView321, Program Manager ahk_class Progman

			VarSetCapacity( rect, 16, 0 )
			DllCall("ReadProcessMemory","uint",hp_explorer,"uint",remote_buffer,"uint",&rect,"uint",16,"uint",0)

			x := ExtractInteger(rect,0,4)
			y := ExtractInteger(rect,4,4)

			DllCall( "VirtualFreeEx","uint",hp_explorer,"uint",remote_buffer,"uint",0,"uint",0x8000)
			DllCall( "CloseHandle", "uint", hp_explorer )

			IfNotInString, dsi_ignoreList, %itemName1%
			{
				IfNotInString, dsi_diIgnoreList, %itemName1%
					result = %result%%itemName1%|%x%|%y%*
			}
		}
		else
		{
			Loop, Parse, list, *
			{
				StringSplit, outArray, A_LoopField, |

				if outArray1 = %itemName1%
					dsi_setIconPos(itemNo -1,outArray2,outArray3)
			}
		}
	}


	If (dsi_showBalloonTips = 1 && list != "")
		BalloonTip( dsi_ScriptName, lng_dsi_iconsLoaded,"Info", 0, 0, 3 )

	return %result%
}

dsi_setIconPos(no=0,x=0,y=0)
{
	; LVM_SETITEMPOSITION
	SendMessage, 0x1000+15, no, ( y << 16 )|x, SysListView321, Program Manager ahk_class Progman
}
