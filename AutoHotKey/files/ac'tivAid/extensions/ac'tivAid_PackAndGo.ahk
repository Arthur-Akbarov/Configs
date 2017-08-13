; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               PackAndGo
; -----------------------------------------------------------------------------
; Prefix:             pgo_
; Version:            0.8
; Date:               2007-06-07
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_PackAndGo:
	Prefix = pgo
	%Prefix%_ScriptName    = PackAndGo
	%Prefix%_ScriptVersion = 0.8
	%Prefix%_Author        = Wolfgang Reszel

	HideSettings = 0                    ; Wenn 1, dann bekommt die Erweiterung keinen Eintrag im Konfigurationsdialog
	EnableTray_PackAndGo   = 0          ; Soll eine Erweiterung nicht im Tray-Menü aufgeführt werden, muss der Wert 0 betragen

	DisableIfCompiled_PackAndGo   = 1   ; Wenn 1, lässt sich die Erweiterung in kompilierter Form nicht de-/aktivieren
	OnlyForConfigDialog_PackAndGo = 1
	DontPackAndGo_PackAndGo       = 1

	IconFile_On_PackAndGo  = %A_WinDir%\system32\shell32.dll
	IconPos_On_PackAndGo = 69

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %pgo_ScriptName% - ac'tivAid für die Verteilung kompilieren
		Description                   = Mit PackAndGo kann man ac'tivAid auf Rechner verteilen, auf denen kein AutoHotkey installiert ist.
		lng_pgo_Introduction          = Beim Klicken auf die Schaltfläche wird im ac'tivAid-Verzeichnis die kompilierte Fassung von ac'tivAid abgelegt.`n`nAlle derzeit sichtbaren Erweiterungen und deren Einstellungen werden dabei eingeschlossen. Nach der Kompilierung kann HotStrings nicht mehr konfiguriert werden, somit sollt man vorher gut überlegen, welche HotStrings verfügbar sein sollen.`n`nEs reicht, die erstellte Exe-Datei weiterzugeben, da alle wichtigen Dateien beim ersten Starten angelegt werden.
		lng_pgo_PackAndGo             = Pack && Go ...
		lng_pgo_Compiling             = kompiliere
		lng_pgo_Finished              = Kompilierung beendet!
		lng_pgo_DeployDir             = Exe-Datei nach der Kompilierung in folgendes Zielverzeichnis verschieben (leer = bleibt im ac'tivAid-Verzeichnis)
		lng_pgo_Deployed              = Exe-Datei wurde in folgendes Verzeichnis verschoben:
		lng_pgo_NotDeployed           = Exe-Datei konnte nicht in das Zielverzeichnis verschoben werden!
		lng_pgo_Deploying             = Verschiebe nach
		lng_pgo_Execute               = Programm/Skript nach der Kompilierung und dem Verschieben ausführen (leer = keine Aktion)
		lng_pgo_Executed              = Programm/Skript wurde erfolgreich ausgeführt.
		lng_pgo_NotExecuted           = Programm/Skript wurde nicht gefunden oder meldet einen Fehler.
		lng_pgo_Executing             = ### wird ausgeführt
		lng_pgo_CreateUninstaller     = Deinstallation der Exe-Datei ermöglichen (über Systemsteuerung/Software)
		lng_pgo_CompilerNotFound      = PackAndGo benötigt den Compiler von AutoHotkey, um ein exe-Version von ac'tivAid zu erstellen.`nDer Compiler wird im folgenden Verzeichnis erwartet:
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %pgo_ScriptName% - compile ac'tivAid for distribution
		Description                   = With PackAndGo it's possible to distribute ac'tivAid to computers without installing AutoHotkey there.
		lng_pgo_Introduction          = After klicking the button, the compiled version will be created in the ac'tivAid-directory.`n`nAll currently visible extensions and their settings will be included. Remember, it's not possible to configure HotStrings after compiling.`n`nYou only have to distribute the exe-File, because everything necessary will be created at the first launch.
		lng_pgo_PackAndGo             = pack && go ...
		lng_pgo_Compiling             = compiling
		lng_pgo_Finished              = Compiling finished!
		lng_pgo_DeployDir             = Move the exe file after compilation into the following directory (empty = ac'tivAid's directory)
		lng_pgo_Deployed              = Exe file has been moved to:
		lng_pgo_NotDeployed           = Exe file could not be moved into the destination directory!
		lng_pgo_Deploying             = Moving to
		lng_pgo_Execute               = Program/script to execute after compilation (empty = no action)
		lng_pgo_Executed              = Program/script successfully executed.
		lng_pgo_NotExecuted           = Program/script not found or terminated with an error.
		lng_pgo_Executing             = Executing ###
		lng_pgo_CreateUninstaller     = Enable uninstall of the exe-file (via Control Panel/Software)
		lng_pgo_CompilerNotFound      = PackAndGo requires the AutoHotkey's Compiler to create an exe-version of ac'tivAid zu erstellen.`mThe compiler must be located at:
	}

	IniRead, pgo_DeployDir, %ConfigFile%, %pgo_ScriptName%, DeployDir, %A_Space%
	If pgo_DeployDir = ERROR
		pgo_DeployDir =
	IniRead, pgo_Execute, %ConfigFile%, %pgo_ScriptName%, Execute, %A_Space%
	If pgo_Execute = ERROR
		pgo_Execute =
Return

SettingsGui_PackAndGo:
	Gui, Add, Text, xs+10 y+5 w450, %lng_pgo_Introduction%
	Gui, Add, Text, xs+10 y+20 , %lng_pgo_DeployDir%:
	Gui, Add, Edit, R1 -wrap y+3 xs+10 w440 vpgo_DeployDir gsub_CheckIfSettingsChanged, %pgo_DeployDir%
	Gui, Add, Button, -Wrap X+5 YP-1 W100 gpgo_sub_BrowseDeploy, %lng_Browse%
	Gui, Add, Text, xs+10 y+5 , %lng_pgo_Execute%:
	Gui, Add, Edit, R1 -wrap y+3 xs+10 w440 vpgo_Execute gsub_CheckIfSettingsChanged, %pgo_Execute%
	Gui, Add, Button, -Wrap X+5 YP-1 W100 gpgo_sub_BrowseExecute, %lng_Browse%
	Gui, Add, Button, -wrap xs+10 y+15 w150 %DisabledIfNotAdmin% gpgo_main_PackAndGo, %lng_pgo_PackAndGo%
	Gui, Add, CheckBox, -wrap x+10 yp+5 vCreateUninstaller Checked%CreateUninstaller%, %lng_pgo_CreateUninstaller%
Return

pgo_sub_BrowseDeploy:
	Gui +OwnDialogs
	GuiControlGet, pgo_DeployDirTmp,,pgo_DeployDir
	pgo_DeployDirTmp := func_Deref(pgo_DeployDirTmp)
	FileSelectFolder, pgo_DeployDirTmp,*%pgo_DeployDirTmp%, 3
	If pgo_DeployDirTmp <>
		GuiControl,,pgo_DeployDir,%pgo_DeployDirTmp%
Return

pgo_sub_BrowseExecute:
	Gui +OwnDialogs
	GuiControlGet, pgo_ExecuteTmp,,pgo_Execute
	pgo_ExecuteTmp := func_Deref(pgo_ExecuteTmp)
	FileSelectFile, pgo_Execute,, %pgo_ExecuteTmp%
	If pgo_Execute <>
		GuiControl,,pgo_Execute,%pgo_Execute%
Return

SaveSettings_PackAndGo:
	IniWrite, %pgo_Execute%, %ConfigFile%, %pgo_ScriptName%, Execute
	IniWrite, %pgo_DeployDir%, %ConfigFile%, %pgo_ScriptName%, DeployDir
Return

AddSettings_PackAndGo:
Return

CancelSettings_PackAndGo:
Return

DoEnable_PackAndGo:
Return

DoDisable_PackAndGo:
Return

DefaultSettings_PackAndGo:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

pgo_main_PackAndGo:
	IfNotExist, %A_AutoHotkeyPath%\Compiler\Ahk2Exe.exe
	{
		MsgBox, 16, %pgo_ScriptName%, %lng_pgo_CompilerNotFound%`n%A_AutoHotkeyPath%\Compiler\Ahk2Exe.exe
		Return
	}
	IniDelete, %ConfigFile%, %ScriptName%, GUIselected
	GuiControlGet, CreateUninstaller
	GuiControlGet, pgo_Execute
	GuiControlGet, pgo_DeployDir
	Gui, %GuiID_activAid%:+Disabled
	Gui, %GuiID_activAid%:+OwnDialogs
	Gosub, sub_temporarySuspend
	SplashImage,,b1 FS9 H35 W400 CWeeeeee, %lng_pgo_Compiling% ...
	FileDelete, exe-distribution.ahk
	FileAppend, CreateUninstaller = %CreateUninstaller%`n, exe-distribution.ahk

	IfNotInString, ScriptIcon, icons\internals\ac'tivAid.ico
	{
		FileAppend, If activAid_HasChanged = 1`n, exe-distribution.ahk
		FileAppend, %A_Tab%%A_Tab%func_UnpackSplash("%ScriptIcon%")`n, exe-distribution.ahk
		FileAppend, %A_Tab%%A_Tab%FileInstall`, %ScriptIcon%`, icons\internals\ac'tivAid.ico`, 1`n, exe-distribution.ahk
	}

	IfNotInString, ScriptOnIcon, icons\internals\ac'tivAid_on.ico
	{
		FileAppend, If activAid_HasChanged = 1`n, exe-distribution.ahk
		FileAppend, %A_Tab%%A_Tab%func_UnpackSplash("%ScriptOnIcon%")`n, exe-distribution.ahk
		FileAppend, %A_Tab%%A_Tab%FileInstall`, %ScriptOnIcon%`, icons\internals\ac'tivAid_on.ico`, 1`n, exe-distribution.ahk
	}

	IfNotInString, ScriptOffIcon, icons\internals\ac'tivAid_off.ico
	{
		FileAppend, If activAid_HasChanged = 1`n, exe-distribution.ahk
		FileAppend, %A_Tab%%A_Tab%func_UnpackSplash("%ScriptOffIcon%")`n, exe-distribution.ahk
		FileAppend, %A_Tab%%A_Tab%FileInstall`, %ScriptOffIcon%`, icons\internals\ac'tivAid_off.ico`, 1`n, exe-distribution.ahk
	}

	Loop
	{
		pgo_Ext := Extension[%A_Index%]
		If pgo_Ext =
			break
		pgo_ExtExe := ExtensionExtraCompile[%pgo_Ext%]
		If pgo_ExtExe =
			continue
		StringReplace, pgo_ExtAhk, pgo_ExtExe, .exe, .ahk
		IfExist, %A_ScriptDir%\%pgo_ExtAhk%
		{
			SplashImage,,, %lng_pgo_Compiling%: %pgo_ExtAhk% ...
			RunWait, %A_AutoHotkeyPath%\Compiler\Ahk2Exe.exe /in "%A_ScriptDir%\%pgo_ExtAhk%" /out "%pgo_ExtExe%"
			FileAppend, If activAid_HasChanged = 1`n, exe-distribution.ahk
			FileAppend, %A_Tab%IfNotExist`, %pgo_ExtExe%`n, exe-distribution.ahk
			FileAppend, %A_Tab%{`n, exe-distribution.ahk
			FileAppend, %A_Tab%%A_Tab%func_UnpackSplash("%pgo_ExtExe%")`n, exe-distribution.ahk
			FileAppend, %A_Tab%%A_Tab%FileInstall`, %pgo_ExtExe%`, %pgo_ExtExe%`, 1`n, exe-distribution.ahk
			FileAppend, %A_Tab%}`n, exe-distribution.ahk
		}
	}
	If Extension[UserHotkeys] <>
	{
		FileAppend, FileCreateDir`, extensions\UserHotkeys-scripts`n, exe-distribution.ahk
		Loop, %A_ScriptDir%\extensions\UserHotkeys-scripts\*.ahk
		{
			SplashImage,,, %lng_pgo_Compiling%: %A_LoopFileName% ...
			StringReplace, pgo_LoopFileExe, A_LoopFileFullPath, .ahk, .exe
			StringReplace, pgo_LoopFileExeRel, pgo_LoopFileExe, %A_ScriptDir%\,
			test = %A_AutoHotkeyPath%\Compiler\Ahk2Exe.exe /in "%A_LoopFileFullPath%" /out "%pgo_LoopFileExeRel%"
			SplitPath, pgo_LoopFileExeRel,, pgo_LoopFileExeRelDir
			FileCreateDir, %pgo_LoopFileExeRelDir%
			RunWait, %A_AutoHotkeyPath%\Compiler\Ahk2Exe.exe /in "%A_LoopFileFullPath%" /out "%pgo_LoopFileExeRel%"
			FileAppend,    If activAid_HasChanged = 1`n, exe-distribution.ahk
			FileAppend, %A_Tab%IfNotExist`, %pgo_LoopFileExeRel%`n, exe-distribution.ahk
			FileAppend, %A_Tab%{`n, exe-distribution.ahk
			FileAppend, %A_Tab%%A_Tab%func_UnpackSplash("%pgo_LoopFileExeRel%")`n, exe-distribution.ahk
			FileAppend, %A_Tab%%A_Tab%FileInstall`, %pgo_LoopFileExeRel%`, %pgo_LoopFileExeRel%`, 1`n, exe-distribution.ahk
			FileAppend, %A_Tab%}`n, exe-distribution.ahk
		}
	}
	If Extension[WebSearch] <>
	{
		FileAppend, FileCreateDir`, settings\WebSearch`n, exe-distribution.ahk
		Loop, settings\WebSearch\*.ico
		{
			SplashImage,,, %lng_pgo_Compiling%: WebSearch (%A_LoopFileName%) ...
			FileAppend, %A_Tab%IfNotExist`, %A_LoopFileFullPath%`n, exe-distribution.ahk
			FileAppend, %A_Tab%{`n, exe-distribution.ahk
			FileAppend, %A_Tab%%A_Tab%func_UnpackSplash("%A_LoopFileFullPath%")`n, exe-distribution.ahk
			FileAppend, %A_Tab%%A_Tab%FileInstall`, %A_LoopFileFullPath%`, %A_LoopFileFullPath%`n, exe-distribution.ahk
			FileAppend, %A_Tab%}`n, exe-distribution.ahk
		}
	}
	If Extension[Eject] <>
	{
		IfExist, %A_ScriptDir%\Library\Tools\deveject.exe
		{
			FileAppend, %A_Tab%IfNotExist`, Library\Tools\deveject.exe`n, exe-distribution.ahk
			FileAppend, %A_Tab%{`n, exe-distribution.ahk
			FileAppend, %A_Tab%%A_Tab%func_UnpackSplash("deveject.exe")`n, exe-distribution.ahk
			FileAppend, %A_Tab%%A_Tab%FileInstall`, %A_ScriptDir%\Library\Tools\deveject.exe`, Library\Tools\deveject.exe`n, exe-distribution.ahk
			FileAppend, %A_Tab%}`n, exe-distribution.ahk
		}
	}
	If (Extension[Eject] <> "" OR Extension[RemoveDriveHotkey])
	{
		IfExist, %A_ScriptDir%\Library\Tools\RemoveDrive.exe
		{
			FileAppend, %A_Tab%IfNotExist`, Library\Tools\RemoveDrive.exe`n, exe-distribution.ahk
			FileAppend, %A_Tab%{`n, exe-distribution.ahk
			FileAppend, %A_Tab%%A_Tab%func_UnpackSplash("RemoveDrive.exe")`n, exe-distribution.ahk
			FileAppend, %A_Tab%%A_Tab%FileInstall`, %A_ScriptDir%\Library\Tools\RemoveDrive.exe`, Library\Tools\RemoveDrive.exe`n, exe-distribution.ahk
			FileAppend, %A_Tab%}`n, exe-distribution.ahk
		}
	}
	SplashImage,,, %lng_pgo_Compiling%: ac'tivAid.ahk ...

	pgo_mainAhk =
	pgo_mainAhktmp =
	Loop, Read, settings\extensions_main.ini
	{
		StringSplit, pgo_actExt, A_LoopReadLine, `;
		pgo_actExt2 := func_StrTrimChars(pgo_actExt2)
		pgo_mainAhk = %pgo_mainAhk%%A_LoopReadLine%`n
		If (func_StrLeft(pgo_actExt1,8)="#Include")
			If DontPackAndGo_%pgo_actExt2% = 1
				continue
		pgo_mainAhktmp = %pgo_mainAhktmp%%A_LoopReadLine%`n
	}
	;msgbox, %pgo_mainAhk%
	;msgbox, %pgo_mainAhktmp%
	FileDelete, settings\extensions_main.ini
	FileAppend, %pgo_mainAHKtmp%, settings\extensions_main.ini

	FileDelete, settings\extensions_header.ini
	FileAppend, CustomIncludes = %CustomIncludes%`n, settings\extensions_header.ini
	pgo_newIndex = 0
	Loop
	{
		pgo_actExt := Extension[%A_Index%]
		If pgo_actExt =
			break
		If DontPackAndGo_%pgo_actExt% = 1
			continue
		pgo_newIndex++
		FileAppend, % "Extension[" pgo_newIndex "] = " Extension[%A_Index%] "`n", settings\extensions_header.ini
	}
	pgo_TempFiles =
	pgo_TempDirs =
	If A_ScriptDir <> %A_Workingdir%
	{
		Loop, %A_ScriptDir%\*.*, 0, 1
		{
			pgo_CropLen := StrLen(A_ScriptDir) + 1
			StringTrimLeft, pgo_LoopRelPath, A_LoopFileFullPath, %pgo_CropLen%
			SplitPath, pgo_LoopRelPath,,pgo_LoopRelDir
			If pgo_LoopRelDir <>
			{
				IfNotExist, %pgo_LoopRelDir%
				{
					FileCreateDir, %pgo_LoopRelDir%
					If ErrorLevel = 0
						 pgo_TempDirs = %pgo_TempDirs%%pgo_LoopRelDir%`n
				}
			}
			IfNotExist, %pgo_LoopRelPath%
			{
				pgo_TempFiles = %pgo_TempFiles%%pgo_LoopRelPath%`n
				FileCopy, %A_LoopFileFullPath%, %pgo_LoopRelPath%
			}
		}
	}
	IfNotExist, settings\Hotstrings.ini
		pgo_NoHSini = 1
	Else
		pgo_NoHSini = 0
	If pgo_NoHSini = 1
		FileAppend,%A_Space%,settings\HotStrings.ini
	FileDelete, extensions\RunWithAdminRights.exe
	RunWait, %A_AutoHotkeyPath%\Compiler\Ahk2Exe.exe /in "extensions\RunWithAdminRights.ahk" /out "extensions\RunWithAdminRights.exe" /icon "%ScriptIcon%", %A_Workingdir%
	RunWait, %A_AutoHotkeyPath%\Compiler\Ahk2Exe.exe /in "ac'tivAid.ahk" /out "ac'tivAid_SIK.exe" /icon "%ScriptIcon%", %A_Workingdir%
	If pgo_NoHSini = 1
		FileDelete, settings\HotStrings.ini

	Sleep,300
	;msgbox, %pgo_TempFiles%
	;msgbox, %pgo_TempDirs%
	If A_ScriptDir <> %A_Workingdir%
	{
		Loop, Parse, pgo_TempFiles, `n
		{
			FileDelete, %A_LoopField%
		}
		Loop, Parse, pgo_TempDirs, `n
		{
			If A_LoopField =
				continue
			FileRemoveDir, %A_LoopField%
		}
	}
	FileMove, ac'tivAid_SIK.exe, ac'tivAid.exe, 1

	FileDelete, exe-distribution.ahk
	FileDelete, settings\extensions_main.ini
	FileAppend, %pgo_mainAHK%, settings\extensions_main.ini

	FileDelete, settings\extensions_header.ini
	FileAppend, CustomIncludes = %CustomIncludes%`n, settings\extensions_header.ini
	Loop
	{
		If Extension[%A_Index%] =
			break
		FileAppend, % "Extension[" A_Index "] = " Extension[%A_Index%] "`n", settings\extensions_header.ini
	}
	lng_pgo_Status = %lng_pgo_Finished%
	If pgo_DeployDir <>
	{
		SplashImage,,, % lng_pgo_Deploying " " func_Deref(pgo_DeployDir) " ..."
		IfNotExist, % func_Deref(pgo_DeployDir)
			FileCreateDir, % func_Deref(pgo_DeployDir)
		FileMove, ac'tivAid.exe, % func_Deref(pgo_DeployDir), 1
		If ErrorLevel = 0
			lng_pgo_Status := lng_pgo_Status "`n`n" lng_pgo_Deployed "`n" func_Deref(pgo_DeployDir)
		Else
			lng_pgo_Status = %lng_pgo_Status%`n`n%lng_pgo_NotDeployed%
	}
	If pgo_Execute <>
	{
		pgo_Tmp := func_Deref(pgo_Execute)
		SplitPath, pgo_Tmp,pgo_Tmp
		StringReplace, pgo_Tmp, lng_pgo_Executing, ###, %pgo_Tmp%
		SplashImage,,, %pgo_Tmp% ...
		RunWait, % func_Deref(pgo_Execute),,UseErrorLevel
		If ErrorLevel = 0
			lng_pgo_Status = %lng_pgo_Status%`n`n%lng_pgo_Executed%
		Else
			lng_pgo_Status = %lng_pgo_Status%`n`n%lng_pgo_NotExecuted%
	}
	SplashImage, Off
	MsgBox, 64,%ScriptTitle%,%lng_pgo_Status%
	Gosub, SaveSettings_PackAndGo
	Gosub, sub_temporarySuspend
	Gui, %GuiID_activAid%:-Disabled
	IniWrite, %ListBox_selected%, %ConfigFile%, %ScriptName%, GUIselected
Return
