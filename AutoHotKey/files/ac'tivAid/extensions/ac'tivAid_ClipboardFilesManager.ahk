; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               ClipboardFilesManager
; -----------------------------------------------------------------------------
; Prefix:             cfm_
; Version:            1.0
; Date:               2008-01-04
; Author:             Jack Tissen
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_ClipboardFilesManager:
	Prefix = cfm
	%Prefix%_ScriptName    = ClipboardFilesManager
	%Prefix%_ScriptVersion = 1.0
	%Prefix%_Author        = Jack Tissen

	CustomHotkey_ClipboardFilesManager = 0
	Hotkey_ClipboardFilesManager       =
	HotkeyPrefix_ClipboardFilesManager =

	IconFile_On_ClipboardFilesManager = %A_WinDir%\system32\shell32.dll
	IconPos_On_ClipboardFilesManager = 55

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %cfm_ScriptName% - Löschen/Sichern nach Backup
		Description                   = Tastaturkürzel um Dateien zu löschen, an einen vordefinierten Ort zu kopieren oder an einen Ort zu verschieben, dessen Pfad sich in der Zwischenablage befindet.

		lng_cfm_BackupDirLbl         = Backup-Verzeichnis
		lng_cfm_DelFileLbl           = Datei(en) löschen`t
		lng_cfm_MovFileLbl           = Datei(en) verschieben`t
		lng_cfm_CpyFileLbl           = Datei(en) kopieren`t
		lng_cfm_SendRecyclerLbl      = In Papierkorb
		lng_cfm_CreateSubDirLbl      = Unterverzeichniss(e) erstellen
		lng_cfm_DeleteLbl            = Gelöscht:
		lng_cfm_MoveLbl              = Verschoben:
		lng_cfm_CopyLbl              = Kopiert:
		lng_cfm_SkipLbl              = Übersprungen:
		lng_cfm_FolderCreateError    = Fehler beim erstellen der Unterverzeichnisse aufgetreten!
		lng_cfm_CommandsLbl          = <YYYY> - Jahr lang`t`t`t<YY> - Jahr kurz`t`t`tUnerlaubte zeichen: /:*?"<>|`n<MONTH> - Monatname`t`t`t<MON> - Monatname kurz`t<MM> - Monat als Zahl`n<DAYL> - Wochentag`t`t`t<DAY> - Wochentag kurz`t<DD> - Tag als Zahl`n<HH> - Stunde`t`t`t`t<12HH> - Stunde (12h)`t`t<XX> - AM/PM`n<MM> - Minute`t`t`t`t<SS> - Sekunde
		; " end qoute for syntax highlighting
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %cfm_ScriptName% - Delete/Backup to Backup
		Description                   = Hotkeys to delete or copy/move Files from Clipboard to predefined Backup Folder.

		lng_cfm_BackupDirLbl         = Backup Directory
		lng_cfm_DelFileLbl           = Delete File(s)`t
		lng_cfm_MovFileLbl           = Move File(s)`t
		lng_cfm_CpyFileLbl           = Copy File(s)`t
		lng_cfm_SendRecyclerLbl      = Send to Recycler
		lng_cfm_CreateSubDirLbl      = Create Subdirector(y/ies)
		lng_cfm_DeleteLbl            = Deleted:
		lng_cfm_MoveLbl              = Moved:
		lng_cfm_CopyLbl              = Copied:
		lng_cfm_SkipLbl              = Skipped:
		lng_cfm_FolderCreateError    = Error while creating the subfolders!
		lng_cfm_CommandsLbl          = <YYYY> - Year long`t`t`t<YY> - Year short`t`tForbidden chars: /:*?"<>|`n<MONTH> - Month as name`t`t<MON> - Month short name`t<MM> - Month as number`n<DAYL> - Weekday`t`t`t<DAY> - Weekday short`t`t<DD> - Day as Number`n<HH> - Hour`t`t`t`t<12HH> - Hour (12h)`t`t<XX> - AM/PM`n<MM> - Minute`t`t`t`t<SS> - Second
		; " end qoute for syntax highlighting
	}

	IniRead, cfm_BckFldr, %ConfigFile%, %cfm_ScriptName%, BackupFolder, %A_Space%
	IniRead, cfm_DoRecycle, %ConfigFile%, %cfm_ScriptName%, SendToRecycler, 0
	IniRead, cfm_DoSubDir, %ConfigFile%, %cfm_ScriptName%, CreateSubDir, 0
	IniRead, cfm_SubDirs, %ConfigFile%, %cfm_ScriptName%, SubDirectories, <YYYY> (<yy>)\<MM> - <MONTH> (<mon>)\<DD> - <DAYL> (<day>)\<HH> - <12HH><XX>\<MM>-<SS>
	func_HotkeyRead( "cfm_DelFile", ConfigFile, cfm_ScriptName, "Hotkey_Delete", "cfm_sub_HK_Delete", "" )
	func_HotkeyRead( "cfm_MovFile", ConfigFile, cfm_ScriptName, "Hotkey_Move", "cfm_sub_HK_Move", "" )
	func_HotkeyRead( "cfm_CpyFile", ConfigFile, cfm_ScriptName, "Hotkey_Copy", "cfm_sub_HK_Copy", "" )
Return

SettingsGui_ClipboardFilesManager:
	Gui, Add, Text, xs+10 y+5 , %lng_cfm_BackupDirLbl%
	Gui, Add, Edit, gsub_CheckIfSettingsChanged R1 w445 vcfm_BckFldr, %cfm_BckFldr%
	Gui, Add, Button, -Wrap X+5 YP-1 W100 gcfm_sub_Browse, %lng_Browse%
	func_HotkeyAddGuiControl(lng_cfm_DelFileLbl, "cfm_DelFile", "xs+10 y+30")
	Gui, Add, CheckBox, -Wrap x+5 yp+4 vcfm_DoRecycle gsub_CheckIfSettingsChanged Checked%cfm_DoRecycle%, %lng_cfm_SendRecyclerLbl%
	func_HotkeyAddGuiControl(lng_cfm_MovFileLbl, "cfm_MovFile", "xs+10 y+13")
	func_HotkeyAddGuiControl(lng_cfm_CpyFileLbl, "cfm_CpyFile", "xs+10 y+10")
	Gui, Add, CheckBox, -Wrap xs+10 yp+30 vcfm_DoSubDir gcfm_OnDoSubDir Checked%cfm_DoSubDir%, %lng_cfm_CreateSubDirLbl%
	Gui, Add, Edit, gsub_CheckIfSettingsChanged R1 w550 vcfm_SubDirs, %cfm_SubDirs%
	Gui, Add, Text, , %lng_cfm_CommandsLbl%

	GuiControl, Enable%cfm_DoSubDir%, cfm_SubDirs
Return

SaveSettings_ClipboardFilesManager:
	IniWrite, %cfm_BckFldr%, %ConfigFile%, %cfm_ScriptName%, BackupFolder
	IniWrite, %cfm_DoRecycle%, %ConfigFile%, %cfm_ScriptName%, SendToRecycler
	IniWrite, %cfm_DoSubDir%, %ConfigFile%, %cfm_ScriptName%, CreateSubDir
	IniWrite, %cfm_SubDirs%, %ConfigFile%, %cfm_ScriptName%, SubDirectories
	func_HotkeyWrite("cfm_DelFile", ConfigFile, cfm_ScriptName, "Hotkey_Delete")
	func_HotkeyWrite("cfm_MovFile", ConfigFile, cfm_ScriptName, "Hotkey_Move")
	func_HotkeyWrite("cfm_CpyFile", ConfigFile, cfm_ScriptName, "Hotkey_Copy")
Return

AddSettings_ClipboardFilesManager:
Return

CancelSettings_ClipboardFilesManager:
Return

DoEnable_ClipboardFilesManager:
	func_HotkeyEnable("cfm_DelFile")
	func_HotkeyEnable("cfm_MovFile")
	func_HotkeyEnable("cfm_CpyFile")
Return

DoDisable_ClipboardFilesManager:
	func_HotkeyDisable("cfm_DelFile")
	func_HotkeyDisable("cfm_MovFile")
	func_HotkeyDisable("cfm_CpyFile")
Return

DefaultSettings_ClipboardFilesManager:
Return
OnExitAndReload_ClipboardFilesManager:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_ClipboardFilesManager:
Return

;Hotkey Delete
cfm_sub_HK_Delete:
	StringSplit, FileList, Clipboard, `n, %A_Space%"`r`n"
	FilesChanged =
	FilesSkipped =
	Loop %Filelist0%
	{
		AktFile := Filelist%A_Index%

		;Skip Directories
		FileGetAttrib, FileAttrib, %AktFile%
		IfInString, FileAttrib, D
			Continue

		IfExist, %AktFile%
		{
			if cfm_DoRecycle
				FileRecycle, %AktFile%
			else
				FileDelete, %AktFile%

			if Errorlevel <> 0
			{
				FilesSkipped .= AktFile . "`n"
				SoundPlay, *16
			}
			else
				FilesChanged .= AktFile . "`n"
		}
	}
	MyMsg =
	MyIcon = Info
	if FilesChanged <>
		MyMsg .= lng_cfm_DeleteLbl . "`n" . FilesChanged
	if FilesSkipped <>
	{
		MyMsg .= lng_cfm_SkipLbl . "`n" . FilesSkipped
		if FilesChanged <>
			MyIcon = Warning
		else
			MyIcon = Error
	}

	if MyMsg <>
		BalloonTip(cfm_ScriptName, MyMsg, MyIcon, 0, 0, 5)
return

;Hotkey Move
cfm_sub_HK_Move:
	StringSplit, FileList, Clipboard, `n, %A_Space%"`r`n"
	GoSub cfm_CreateSubDirs
	if cfm_Error
		Return
	FilesChanged =
	FilesSkipped =
	Loop %Filelist0%
	{
		AktFile := Filelist%A_Index%

		;Skip Directories
		FileGetAttrib, FileAttrib, %AktFile%
		IfInString, FileAttrib, D
			Continue

		IfExist, %AktFile%
		{
			FileMove, %AktFile%, %cfm_NewPath%

			if Errorlevel <> 0
			{
				FilesSkipped .= AktFile . "`n"
				SoundPlay, *16
			}
			else
				FilesChanged .= AktFile . "`n"
		}
	}
	MyMsg =
	MyIcon = Info
	if FilesChanged <>
		MyMsg .= lng_cfm_MoveLbl . "`n" . FilesChanged
	if FilesSkipped <>
	{
		MyMsg .= lng_cfm_SkipLbl . "`n" . FilesSkipped
		if FilesChanged <>
			MyIcon = Warning
		else
			MyIcon = Error
	}

	if MyMsg <>
		BalloonTip(cfm_ScriptName, MyMsg, MyIcon, 0, 0, 5)
return

;Hotkey Copy
cfm_sub_HK_Copy:
	StringSplit, FileList, Clipboard, `n, %A_Space%"`r`n"
	GoSub cfm_CreateSubDirs
	if cfm_Error
		Return
	FilesChanged =
	FilesSkipped =
	Loop %Filelist0%
	{
		AktFile := Filelist%A_Index%

		;Skip Directories
		FileGetAttrib, FileAttrib, %AktFile%
		IfInString, FileAttrib, D
			Continue

		IfExist, %AktFile%
		{
			FileCopy, %AktFile%, %cfm_NewPath%

			if Errorlevel <> 0
			{
				FilesSkipped .= AktFile . "`n"
				SoundPlay, *16
			}
			else
				FilesChanged .= AktFile . "`n"
		}
	}
	MyMsg =
	MyIcon = Info
	if FilesChanged <>
		MyMsg .= lng_cfm_CopyLbl . "`n" . FilesChanged
	if FilesSkipped <>
	{
		MyMsg .= lng_cfm_SkipLbl . "`n" . FilesSkipped
		if FilesChanged <>
			MyIcon = Warning
		else
			MyIcon = Error
	}

	if MyMsg <>
		BalloonTip(cfm_ScriptName, MyMsg, MyIcon, 0, 0, 5)
return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------
; Backupauswahl
cfm_sub_Browse:
	Gui +OwnDialogs
	FileSelectFolder, cfm_BckFldr, *%cfm_BckFldr% , 3
	If cfm_BckFldr <>
		GuiControl,,cfm_BckFldr,%cfm_BckFldr%
Return

; EditFeld ein/ausschalten
cfm_OnDoSubDir:
	GuiControlGet, cfm_DoSubDir
	GuiControl, Enable%cfm_DoSubDir%, cfm_SubDirs
	Gosub sub_CheckIfSettingsChanged
Return

; Unterverzeichnisse erstellen und Kompletten Pfad anlegen
cfm_CreateSubDirs:
	cfm_Error =
	cfm_NewPath = %cfm_BckFldr%
	if cfm_DoSubDir
	{
		;Platzhalter ersetzen
		cfm_NewSubDirs = %cfm_SubDirs%
		FormatTime, cfm_Temp, , yyyy
		StringReplace, cfm_NewSubDirs, cfm_NewSubDirs, <YYYY>, %cfm_Temp%, All
		FormatTime, cfm_Temp, , yy
		StringReplace, cfm_NewSubDirs, cfm_NewSubDirs, <YY>, %cfm_Temp%, All
		FormatTime, cfm_Temp, , MMMM
		StringReplace, cfm_NewSubDirs, cfm_NewSubDirs, <MONTH>, %cfm_Temp%, All
		FormatTime, cfm_Temp, , MMM
		StringReplace, cfm_NewSubDirs, cfm_NewSubDirs, <MON>, %cfm_Temp%, All
		FormatTime, cfm_Temp, , MM
		StringReplace, cfm_NewSubDirs, cfm_NewSubDirs, <MM>, %cfm_Temp%, All
		FormatTime, cfm_Temp, , dddd
		StringReplace, cfm_NewSubDirs, cfm_NewSubDirs, <DAYL>, %cfm_Temp%, All
		FormatTime, cfm_Temp, , ddd
		StringReplace, cfm_NewSubDirs, cfm_NewSubDirs, <DAY>, %cfm_Temp%, All
		FormatTime, cfm_Temp, , dd
		StringReplace, cfm_NewSubDirs, cfm_NewSubDirs, <DD>, %cfm_Temp%, All
		FormatTime, cfm_Temp, , HH
		StringReplace, cfm_NewSubDirs, cfm_NewSubDirs, <HH>, %cfm_Temp%, All
		FormatTime, cfm_Temp, , hh
		StringReplace, cfm_NewSubDirs, cfm_NewSubDirs, <12HH>, %cfm_Temp%, All
		FormatTime, cfm_Temp, , tt
		StringReplace, cfm_NewSubDirs, cfm_NewSubDirs, <XX>, %cfm_Temp%, All
		FormatTime, cfm_Temp, , mm
		StringReplace, cfm_NewSubDirs, cfm_NewSubDirs, <MM>, %cfm_Temp%, All
		FormatTime, cfm_Temp, , ss
		StringReplace, cfm_NewSubDirs, cfm_NewSubDirs, <SS>, %cfm_Temp%, All
		;Zum vorhandenen Pfad hinzufügen
		cfm_NewPath .= "\\" . cfm_NewSubDirs
		;Die ersten 2 Zeichen überspringen, wegen C: oder \\
		cfm_Temp := SubStr(cfm_NewPath, 3)
		;Alle ungültigen Zeichen entfernen
		StringReplace, cfm_Temp, cfm_Temp, `r`n, , All
		StringReplace, cfm_Temp, cfm_Temp, \\, \, All
		StringReplace, cfm_Temp, cfm_Temp, /, , All
		StringReplace, cfm_Temp, cfm_Temp, :, , All
		StringReplace, cfm_Temp, cfm_Temp, *, , All
		StringReplace, cfm_Temp, cfm_Temp, ?, , All
		StringReplace, cfm_Temp, cfm_Temp, ", , All
		; " end qoute for syntax highlighting
		StringReplace, cfm_Temp, cfm_Temp, <, , All
		StringReplace, cfm_Temp, cfm_Temp, >, , All
		StringReplace, cfm_Temp, cfm_Temp, |, , All
		;Wieder zusammensetzen
		cfm_NewPath := SubStr(cfm_NewPath, 1, 2) . cfm_Temp
		;Interverzeichnisse erstellen
		FileCreateDir, %cfm_NewPath%
		if Errorlevel <> 0
		{
			cfm_Error = 1
			SoundPlay, *16
			BalloonTip(cfm_ScriptName, lng_cfm_FolderCreateError "\n" . cfm_NewPath, "Error", 0, 0)
		}
	}
Return
