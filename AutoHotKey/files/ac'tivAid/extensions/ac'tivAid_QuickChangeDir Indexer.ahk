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
	Process, Priority,, L
	SetBatchLines,0
	Thread,Interrupt,0,0
	StringCaseSense, Locale

	; Programmname und Version
	ScriptName    = QuickChangeDir
	ScriptVersion = 1.5
	qc_Titel = %ScriptName% v%ScriptVersion%
	ConfigFile_QuickChangeDir   = settings\QuickChangeDir.ini

	qc_RequiredIndexVersion = 1.5

	StringReplace,activAidDir,A_Workingdir,\extensions,
	SplitPath, A_ScriptDir, activAidFolderName,,,, Drive
	SplitPath, A_AhkPath,,A_AutoHotkeyPath

	; Welche Laufwerke sollen berücksichtigt werden?
	IniRead, qc_PathsToIndex, %activAidDir%\%ConfigFile_QuickChangeDir%, Config, PathsToIndex, C:\

	IniRead, Lng, %activAidDir%\settings\ac'tivAid.ini, activAid, Language
	If Lng = ERROR
		StringRight, Lng, A_Language, 2 ; Sprache ermitteln, wenn nicht in INI festgelegt

	; Wo werden die Verzeichnisindexe gespeichert
	IniRead, qc_IndexPathNoDeref, %activAidDir%\%ConfigFile_QuickChangeDir%, Config, IndexPath, %A_WorkingDir%\settings\%ScriptName%
	Transform, qc_IndexPath, Deref, %qc_IndexPathNoDeref%

	IniRead, qc_NoBalloonTips, %activAidDir%\%ConfigFile_QuickChangeDir%, Config, NoBalloonTips, 0
	IniRead, qc_HiddenOnUnix, %activAidDir%\%ConfigFile_QuickChangeDir%, Config, HiddenOnUnix, 0

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

	If 1 <>
	{
		Loop, Parse, qc_PathsToIndex, `,
		{
			qc_LoopField := func_Deref(A_LoopField)
			If qc_LoopField contains %1%
				qc_selectedDrives = %qc_selectedDrives%,%qc_LoopField%
		}
		StringTrimLeft, qc_selectedDrives,qc_selectedDrives,1
	}
	Else
		qc_selectedDrives := func_Deref(qc_PathsToIndex)

	qc_VariableDriveLetter = %2%

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		lng_qc_Untersuche             = Untersuche
		lng_qc_Indiziere              = Erstelle Verzeichnisindex
		lng_qc_ReIndizierungBreak     = &Aktualisierung abbrechen
		lng_qc_ReIndizierungPause     = Aktualisierung an&halten
		lng_qc_ReIndizierungFortsetzen= Aktualisierung &fortsetzen
		lng_qc_Paused                 = Angehalten
	}
	else        ; = andere Sprachen
	{
		lng_qc_Untersuche             = Looking at drive
		lng_qc_Indiziere              = Creating directorylist
		lng_qc_ReIndizierung          = &update directorylist
		lng_qc_ReIndizierungBreak     = &cancel updating
		lng_qc_ReIndizierungPause     = &pause updating
		lng_qc_ReIndizierungFortsetzen= co&ntinue updating
		lng_qc_Paused                 = Paused
	}

	Menu, Tray, NoStandard
	Menu, Tray, Add, %lng_qc_ReIndizierungPause%, qc_Pause
	Menu, Tray, Default, %lng_qc_ReIndizierungPause%
	Menu, Tray, Add, %lng_qc_ReIndizierungBreak%, qc_Exit

; ---------------------------------------------------------------------
; -- Laufwerke indizieren ---------------------------------------------
; ---------------------------------------------------------------------
	If qc_BreakIndexing = IndexingActiv ; Wenn Indizierung im Gange
	{
		qc_BreakIndexing = yes           ; Indizierung abbrechen (Aufruf kam also vom Traymenü)
		Return                            ; und nicht weiter machen
	}
	If qc_BreakIndexing =               ; Wenn Indizierung nicht im Gange
		qc_BreakIndexing = IndexingActiv ; Status setzen

	Menu,TRAY,Icon,%A_ScriptDir%\..\icons\internals\ac'tivAid_processing_1.ico

	; Sprechblase, dass die Indizierung beginnt
	If ( qc_NoBalloonTips <> 1 )
		TrayTip, %qc_Titel%, %lng_qc_Indiziere%`n%qc_selectedDrives% %qc_2%,10,1

	; Alle Laufwerksbuchstaben durchgehen
	Loop, Parse, qc_selectedDrives, `,
	{
		If A_LoopField =
			break

		qc_ActDrive := qc_func_GetDrive( A_LoopField ) ; Aktuelles Laufwerk
		qc_ActPath = %A_LoopField%
		StringRight, qc_RightChar, qc_ActPath, 1
		If qc_RightChar = \
			StringTrimRight, qc_ActPath, qc_ActPath, 1
		if qc_IndexPath =
		{
			qc_IndexPathDrv := qc_func_GetDrive( A_LoopField, "RealPath" )
			qc_IndexTemp  = %qc_IndexPathDrv%%qc_IndexFileRoot%_tmp.dat ; Temporärer Index
		}
		Else
		{
			qc_IndexTemp  = %qc_IndexPath%\%qc_IndexFile%%qc_ActDrive%_tmp.dat ; Temporärer Index
		}

		; Tooltip für das Trayicon ändern
		Menu,tray,Tip, %qc_Titel%`n%lng_qc_Untersuche% %qc_ActPath%

		; Laufwerk durchgehen und Verzeichnisse in Verzeichnisindex schreiben
		qc_AllPaths =
		Loop, %qc_ActPath%\*.* , 2, 1
		{
			StringReplace, qc_LoopFileFullPath, A_LoopFileFullPath, `%, ```%, A

			If qc_VariableDriveLetter = 1
				qc_LoopFileFullPath := func_ReplaceWithCommonPathVariables(qc_LoopFileFullPath)

			If qc_IndexPath =
			{
				StringTrimLeft, qc_LoopFileFullPath, qc_LoopFileFullPath, 2
				qc_AllPaths = %qc_AllPaths%%qc_LoopFileFullPath%`n ; Verzeichnisindex in Variable schreiben
			}
			Else
				qc_AllPaths = %qc_AllPaths%%qc_LoopFileFullPath%`n ; Verzeichnisindex in Variable schreiben

			qc_Files = %A_Index%

			if (Mod(A_Index,31) = 0)
			{
				Menu, TRAY, Tip, %qc_Titel%`n%lng_qc_Untersuche% %qc_ActPath% (%A_Index%)
				qc_IconDelay  = 150                ; Animation erzwingen
				gosub, qc_sub_Animate                  ; Trayicon animieren
			}
			gosub, qc_sub_Animate                     ; Trayicon animieren
			If qc_BreakIndexing = yes             ; Abbruch?
				break
		}

		;FileMove, %qc_IndexTemp%, %qc_IndexDest%,1 ; Verzeichnisindex durch temporären Index ersetzen
		If qc_BreakIndexing = yes                   ; Abbruch?
		  break

		Sort, qc_AllPaths, U

		FileAppend, %qc_AllPaths%, %qc_IndexTemp%
	}

	; Temporäre Index-Dateien aktivieren
	Loop, Parse, qc_selectedDrives, `,
	{
		If A_LoopField =
			continue

		qc_ActDrive := qc_func_GetDrive( A_LoopField ) ; Aktuelles Laufwerk
;      qc_ActPath = %A_LoopField%
;      StringRight, qc_RightChar, qc_ActPath, 1
;      If qc_RightChar = \
;         StringTrimRight, qc_ActPath, qc_ActPath, 1
		if qc_IndexPath =
		{
			qc_IndexPathDrv := qc_func_GetDrive( A_LoopField, "RealPath" )
			FileMove, %qc_IndexPathDrv%%qc_IndexFileRoot%_tmp.dat, %qc_IndexPathDrv%%qc_IndexFileRoot%.dat, 1
			FileSetAttrib, +H, %qc_IndexPathDrv%%qc_IndexFileRoot%.dat
		}
		Else
		{
			FileMove, %qc_IndexPath%\%qc_IndexFile%%qc_ActDrive%_tmp.dat, %qc_IndexPath%\%qc_IndexFile%%qc_ActDrive%.dat, 1
		}
		DriveSpaceFree, qc_actSpace, % qc_func_GetDrive( A_LoopField, "RealPath" )
		IniWrite, %qc_actSpace%, %activAidDir%\%ConfigFile_QuickChangeDir%, Drives, %qc_ActDrive%
	}

	IniWrite, %qc_RequiredIndexVersion%, %activAidDir%\%ConfigFile_QuickChangeDir%, Config, IndexVersion

	Suspend,Off
	TrayTip                      ; Sprechblase entfernen
	qc_BreakIndexing =          ; Indizierung beendet

	; Tooltip zurücksetzen
	Menu, TRAY, Tip, %ScriptTitle%
Return

; ---------------------------------------------------------------------
qc_sub_Animate: ;    Animiertes Trayicon und Fenstertitel

	FirstIcon = 1  ; erste IconNr
	LastIcon  = 12 ; letzte IconNr

	; Verzögerung, damit nich bei jedem Aufruf die Icondateien geladen werden
	; ansonsten würde das Skript stark gebremst
	qc_IconDelay++         ; Verzögerungswert
	if qc_IconDelay < 100  ; kleiner 100 ...
		return               ; ... dann Unterroutine verlassen

	qc_IconDelay = 0

	; IconNr hochzählen
	qc_TrayIcon++
	If qc_TrayIcon < %FirstIcon%
		qc_TrayIcon = %FirstIcon%
	If qc_TrayIcon > %LastIcon%
		qc_TrayIcon = %FirstIcon%

	; Icon ändern
	Menu,TRAY,Icon,%A_ScriptDir%\..\icons\internals\ac'tivAid_processing_%qc_TrayIcon%.ico
Return

qc_Exit:
	; Index-Dateien löschen
	Loop, Parse, qc_selectedDrives, `,
	{
		If A_LoopField =
			break

		qc_ActDrive := qc_func_GetDrive( A_LoopField ) ; Aktuelles Laufwerk
;      qc_ActPath = %A_LoopField%
;      StringRight, qc_RightChar, qc_ActPath, 1
;      If qc_RightChar = \
;         StringTrimRight, qc_ActPath, qc_ActPath, 1
		if qc_IndexPath =
		{
			qc_IndexPathDrv := qc_func_GetDrive( A_LoopField, "RealPath" )
			FileDelete, %qc_IndexPathDrv%%qc_IndexFileRoot%_tmp.dat
		}
		Else
		{
			FileDelete, %qc_IndexPath%\%qc_IndexFile%%qc_ActDrive%_tmp.dat
		}
	}

	ExitApp
Return

qc_Pause:
	If Pause =
	{
		Menu, Tray, Rename, %lng_qc_ReIndizierungPause%, %lng_qc_ReIndizierungFortsetzen%
		Menu, TRAY, Tip, %qc_Titel%`n%lng_qc_Paused% %qc_ActPath% (%qc_Files%)
		Pause = 1
		Pause, On
	}
	Else
	{
		Menu, Tray, Rename, %lng_qc_ReIndizierungFortsetzen%, %lng_qc_ReIndizierungPause%
		Pause =
		Pause, Off
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

func_StrTranslate(String,TransFrom,TransTo) {
	Loop, Parse, TransFrom
	{
		StringMid, TransToChar, TransTo, %A_Index%, 1
		StringReplace, String, String, %A_LoopField%, %TransToChar%, All
	}
	Return %String%
}

func_Deref(Var)
{
	Transform, Var, Deref, %Var%
	Return %Var%
}

func_ReplaceWithCommonPathVariables(Var,AdditionalVariables="")
{
	Global Drive,A_AutoHotkeyPath
	Variables = %AdditionalVariables%A_Desktop,A_DesktopCommon,A_Programs,A_ProgramsCommon,A_Startup,A_StartupCommon,A_StartMenu,A_StartMenuCommon,A_ProgramFiles,A_WinDir,A_AppData,A_AppDataCommon,A_MyDocuments,A_Temp,Drive,A_AutoHotkeyPath,A_ScriptDir
	Loop, Parse, Variables, `,
	{
		LoopField := %A_LoopField%
		If Var = %LoopField%
			Var = `%%A_LoopField%`%
		Else
			StringReplace, Var, Var, %LoopField%\, `%%A_LoopField%`%\
	}
	Return %Var%
}
