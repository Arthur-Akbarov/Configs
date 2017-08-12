; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               FreeSpace
; -----------------------------------------------------------------------------
; Prefix:             fs_
; Version:            1.1.1
; Date:               2008-05-23
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; --- Description -------------------------------------------------------------
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_FreeSpace:
	Prefix = fs
	%Prefix%_ScriptName    = FreeSpace
	%Prefix%_ScriptVersion = 1.1.1
	%Prefix%_Author        = Wolfgang Reszel

	IconFile_On_FreeSpace = %A_WinDir%\system32\shell32.dll
	IconPos_On_FreeSpace = 167

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %fs_ScriptName% - Zeigt den freien Speicherplatz
		Description                   = Zeigt in der Titelleiste aller Explorer-Fenster den freien Speicherplatz an.
		lng_fs_FreeSpace              = Freier Speicherplatz
		lng_fs_FreeSpaceShort         = frei
		lng_fs_of                     := " von "
		lng_fs_ShowDiskSize           = Gesamtkapazität anzeigen
		lng_fs_ShortDisplay           = verkürzte Darstellung
		lng_fs_DisplayGB              = Anzeige in Gigabyte
		lng_fs_DisplayTS              = Zahlen mit regionalen Einstellungen formatieren
		lng_fs_DisplayPercent         = Zusätzlich den Prozentwert anzeigen (`%)
		lng_fs_RefreshOnlyInExplorer  = Anzeige nur aktualisieren, wenn ein Explorer-Fenster aktiv ist (verhindert z.B. Mausruckler in Photoshop)
		lng_fs_UseStaturbar           = freien Speicherplatz in der Statusleiste statt der Titelleiste anzeigen
		lng_fs_NoBallooTips           = Sprechblasenhinweise "Adressleiste muss sichtbar sein" deaktivieren
		lng_fs_RefreshTimer           = Aktualisierungsintervall (in Sekunden)
		lng_fs_FirstRun               = Die Erweiterung FreeSpace wurde vorsichtshalber deaktiviert,`nda sie unter Windows Vista manchmal das System ausbremst.
	}
	else        ; = other languages (english)
	{
		MenuName                      = %fs_ScriptName% - shows free drive-space
		Description                   = Shows the free drive-space in the title-bar of explorer-windows.
		lng_fs_FreeSpace              = free space
		lng_fs_FreeSpaceShort         = free
		lng_fs_of                     := " of "
		lng_fs_ShowDiskSize           = Show disk size
		lng_fs_ShortDisplay           = Shortened display
		lng_fs_DisplayGB              = Show free space in gigabyte
		lng_fs_DisplayTS              = Format numbers with local user preferences
		lng_fs_DisplayPercent         = Also show free space as percent (`%)
		lng_fs_RefreshOnlyInExplorer  = Refresh value only if an explorer-window is active (eg. prevents mouse-lag in Photoshop)
		lng_fs_UseStaturbar           = Show free space in the status-bar instead of the title-bar
		lng_fs_NoBallooTips           = Disable BalloonTip messages "address bar must be visible"
		lng_fs_RefreshTimer           = Refresh timer (in seconds)
		lng_di_FirstRun               = The extension FreeSpace has been disabled as a precaution`nbecause it sometimes slows down Windows Vista.
	}
	If CustomLanguage <>
		gosub, CustomLanguage

	IniRead, fs_DisplayGB, %ConfigFile%, %fs_ScriptName%, DisplayGigaByte, 0
	IniRead, fs_DisplayTS, %ConfigFile%, %fs_ScriptName%, DisplayThousandSeparator, 1
	IniRead, fs_DisplayPercent, %ConfigFile%, %fs_ScriptName%, DisplayPercent, 0
	IniRead, fs_ShowDiskSize, %ConfigFile%, %fs_ScriptName%, ShowDiskSize, 0
	IniRead, fs_ShortDisplay, %ConfigFile%, %fs_ScriptName%, ShortDisplay, 0
	IniRead, fs_RefreshOnlyInExplorer, %ConfigFile%, %fs_ScriptName%, RefreshOnlyInExplorer, 0
	IniRead, fs_UseStatusBar, %ConfigFile%, %fs_ScriptName%, UseStatusBar, 0
	IniRead, fs_NoBalloonTips, %ConfigFile%, %fs_ScriptName%, NoBalloonTips, 0
	IniRead, fs_RefreshTimer, %ConfigFile%, %fs_ScriptName%, RefreshTimer, 1
	IniRead, fs_FirstRun, %ConfigFile%, FreeSpace, FirstRun, 0
Return

AfterLoadingProcess_FreeSpace:
	If ( fs_FirstRun = 0 AND (aa_osversionnumber >= aa_osversionnumber_vista))
	{
		Enable_FreeSpace = 0
		fs_FirstRun = 1
		BalloonTip(fs_ScriptName, lng_fs_FirstRun,"Warning",0,0,20)
		IniWrite, 1, %ConfigFile%, FreeSpace, FirstRun
	}
Return

SettingsGui_FreeSpace:
	Gui, Add, CheckBox, gsub_CheckIfSettingsChanged XS+10 y+5 vfs_DisplayGB -Wrap Checked%fs_DisplayGB%, %lng_fs_DisplayGB%
	Gui, Add, CheckBox, gsub_CheckIfSettingsChanged XS+10 y+5 vfs_DisplayTS -Wrap Checked%fs_DisplayTS%, %lng_fs_DisplayTS%
	Gui, Add, CheckBox, gsub_CheckIfSettingsChanged XS+10 y+5 vfs_DisplayPercent -Wrap Checked%fs_DisplayPercent%, %lng_fs_DisplayPercent%
	Gui, Add, Checkbox, gsub_CheckIfSettingsChanged XS+10 Y+5 vfs_ShortDisplay -Wrap Checked%fs_ShortDisplay%, %lng_fs_ShortDisplay%
	Gui, Add, Checkbox, gsub_CheckIfSettingsChanged XS+10 Y+5 vfs_RefreshOnlyInExplorer -Wrap Checked%fs_RefreshOnlyInExplorer%, %lng_fs_RefreshOnlyInExplorer%
	Gui, Add, Checkbox, gsub_CheckIfSettingsChanged XS+10 Y+5 vfs_UseStatusBar -Wrap Checked%fs_UseStatusBar%, %lng_fs_UseStaturbar%
	Gui, Add, Checkbox, gsub_CheckIfSettingsChanged XS+10 Y+5 vfs_ShowDiskSize -Wrap Checked%fs_ShowDiskSize%, %lng_fs_ShowDiskSize%
	Gui, Add, Text, XS+10 Y+7, %lng_fs_RefreshTimer%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged X+5 vfs_RefreshTimer w20, %fs_RefreshTimer%
	Gui, Add, Checkbox, gsub_CheckIfSettingsChanged XS+10 Y+15 vfs_NoBalloonTips -Wrap Checked%fs_NoBalloonTips%, %lng_fs_NoBallooTips%
Return

SaveSettings_FreeSpace:
	IniWrite, %fs_DisplayGB%, %ConfigFile%, %fs_ScriptName%, DisplayGigaByte
	IniWrite, %fs_DisplayTS%, %ConfigFile%, %fs_ScriptName%, DisplayThousandSeparator
	IniWrite, %fs_DisplayPercent%, %ConfigFile%, %fs_ScriptName%, DisplayPercent
	IniWrite, %fs_ShowDiskSize%, %ConfigFile%, %fs_ScriptName%, ShowDiskSize
	IniWrite, %fs_ShortDisplay%, %ConfigFile%, %fs_ScriptName%, ShortDisplay
	IniWrite, %fs_RefreshOnlyInExplorer%, %ConfigFile%, %fs_ScriptName%, RefreshOnlyInExplorer
	IniWrite, %fs_UseStatusBar%, %ConfigFile%, %fs_ScriptName%, UseStatusBar
	IniWrite, %fs_NoBalloonTips%, %ConfigFile%, %fs_ScriptName%, NoBalloonTips
	IniWrite, %fs_RefreshTimer%, %ConfigFile%, %fs_ScriptName%, RefreshTimer
	IniWrite, %fs_FirstRun%, %ConfigFile%, FreeSpace, FirstRun
Return

CancelSettings_FreeSpace:
Return

DoEnable_FreeSpace:
	SetTimer, fs_tim_FreeSpace, % fs_RefreshTimer * 1000
	fs_of := lng_fs_of
Return

DoDisable_FreeSpace:
	SetTimer, fs_tim_FreeSpace, Off
	fs_RestoreTitle = 1
	Gosub, fs_tim_FreeSpace
	fs_RestoreTitle =
Return

DefaultSettings_FreeSpace:
Return

OnExitAndReload_FreeSpace:
	Gosub, DoDisable_FreeSpace
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

fs_tim_FreeSpace:
	Thread, NoTimers
	If LoadingFinished <> 1
		Return

	WinGet, fs_WinIDs, List
	WinGetClass, fs_actClass, A
	If ( fs_RefreshOnlyInExplorer = 1 AND fs_RestoreTitle <> 1 AND ( fs_actClass <> "CabinetWClass" AND fs_actClass <> "ExploreWClass" AND fs_actClass <> "Progman" AND fs_actClass <> "Shell_TrayWnd" ) )
		Return

	Loop, %fs_WinIDs%
	{
		fs_WinID := fs_WinIDs%A_Index%
		WinGetClass, fs_WinClass, ahk_id %fs_WinID%
		WinGetTitle, fs_WinTitle, ahk_id %fs_WinID%

		If fs_WinClass in CabinetWClass,ExploreWClass
		{
			If fs_NoBalloonTips = 1
				fs_Path := func_GetDir( fs_WinID, "ShowBalloonTip", "Never", fs_ScriptName )
			Else
				fs_Path := func_GetDir( fs_WinID, "ShowBalloonTip", "Once", fs_ScriptName )

			IfNotExist, %fs_Path%
				continue

			If fs_UseStatusBar = 1
				StatusBarGetText, fs_Title, 1, ahk_id %fs_WinID%
			Else
				WinGetTitle, fs_Title, ahk_id %fs_WinID%
			fs_WinTitle := fs_Title
			fs_Path := fs_func_GetDrive(fs_Path, "RealPath")

			DriveGet, fs_Cap, Cap, %fs_Path%
			DriveSpaceFree, fs_FreeSpace, %fs_Path%

			StringReplace, fs_Path, fs_Path, :\,

			If fs_Path =
				fs_Path := fs_lastPath%fs_WinID%

			If fs_ShortDisplay = 1
			{
				StringGetPos, fs_Len, fs_WinTitle, %A_Space%(%fs_Path%:%A_Space%
				if fs_Len < 1
				{
					StringGetPos, fs_Len1, fs_WinTitle, %A_Space%(
					StringGetPos, fs_Len2, fs_WinTitle, :%A_Space%
					If (fs_Len1 = fs_Len2-3)
						fs_Len = %fs_Len1%
				}
			}
			Else
				StringGetPos, fs_Len, fs_WinTitle, %A_Space%(%lng_fs_FreeSpace%

			if fs_Len > 0
				StringLeft, fs_WinTitle, fs_WinTitle, %fs_Len%

			SetFormat, float, 0.2
			fs_FreeSpacePercent := Round(fs_FreeSpace/fs_Cap*100,2)

			if (fs_DisplayGB = 1 AND fs_FreeSpace > 1024)
			{
				fs_FreeSpace /= 1024.0
				fs_FreeSpaceDisplay := fs_func_FormatNumber(fs_FreeSpace,fs_DisplayTS)
				If fs_ShortDisplay = 1
					fs_NewTitle = %fs_WinTitle% (%fs_Path%: %fs_FreeSpaceDisplay% GB#FStotal# %lng_fs_FreeSpaceShort%)
				Else
					fs_NewTitle = %fs_WinTitle% (%lng_fs_FreeSpace% %fs_Path%: %fs_FreeSpaceDisplay% GB#FStotal#)
			}
			Else
			{
				fs_FreeSpaceDisplay := fs_func_FormatNumber(fs_FreeSpace,fs_DisplayTS)
				If fs_ShortDisplay = 1
					fs_NewTitle = %fs_WinTitle% (%fs_Path%: %fs_FreeSpaceDisplay% MB#FStotal# %lng_fs_FreeSpaceShort%)
				Else
					fs_NewTitle = %fs_WinTitle% (%lng_fs_FreeSpace% %fs_Path%: %fs_FreeSpaceDisplay% MB#FStotal#)
			}
			If fs_DisplayPercent = 1
			{
				fs_FreeSpacePercent := fs_func_FormatNumber(fs_FreeSpacePercent,fs_DisplayTS)
				fs_NewTitle = %fs_NewTitle% [%fs_FreeSpacePercent% `%]
			}

			If fs_ShowDiskSize = 1
			{
				SetFormat, float, 0.2
				if (fs_DisplayGB = 1 AND fs_Cap > 1024)
				{
					fs_Cap /= 1024.0
					fs_Total := fs_of fs_func_FormatNumber(fs_Cap,fs_DisplayTS) " GB"
				}
				Else
				{
					fs_Total := fs_of fs_func_FormatNumber(fs_Cap,fs_DisplayTS) " MB"
				}
				StringReplace, fs_NewTitle, fs_NewTitle, #FStotal#, %fs_Total%
			}
			Else
				StringReplace, fs_NewTitle, fs_NewTitle, #FStotal#

			If (fs_FreeSpace = fs_lastFreeSpace%fs_WinID% AND fs_Title = fs_LastTitle%fs_WinID% AND fs_RestoreTitle <> 1)
				continue

			fs_lastFreeSpace%fs_WinID% = %fs_FreeSpace%
			if fs_Path <>
				fs_lastPath%fs_WinID% = %fs_Path%

			if fs_RestoreTitle = 1
				fs_NewTitle = %fs_WinTitle%

			If fs_UseStatusBar = 1
				ControlSetText, msctls_statusbar321, %fs_NewTitle%, ahk_id %fs_WinID%
			Else
				WinSetTitle, ahk_id %fs_WinID%,,%fs_NewTitle%

			If fs_RestoreTitle <> 1
				fs_LastTitle%fs_WinID% = %fs_NewTitle%
		}
	}
Return

fs_func_GetDrive( Path, RealPath = "" ) {
	StringLeft, Drive, Path, 1
	If Drive = \
	{
		StringSplit, Path, Path, \
		If RealPath = RealPath
			Drive = \\%Path3%\%Path4%
		Else
			Drive := func_StrTranslate(Path3 "#" Path4, "-+ §!&()'", "______[]_")
	}
	Else If RealPath = RealPath
		Drive = %Drive%:\

	Return %Drive%
}

fs_func_FormatNumber( Number, displayTS ) {
	global fs_DisplayGB

	If Number is not number
		Return Number
	result = %Number%
	If displayTS = 1
	{
		result := func_FormatNumber( Number )
		If fs_DisplayGB <> 1
			StringTrimRight, result, result, 3
	}
	Return result
}
