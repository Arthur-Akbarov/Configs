; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               NewFolder
; -----------------------------------------------------------------------------
; Prefix:             nf_
; Version:            1.8
; Date:               2008-05-23
; Author:             Wolfgang Reszel, Michael Telgkamp
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_NewFolder:
	Prefix = nf
	%Prefix%_ScriptName    = NewFolder
	%Prefix%_ScriptVersion = 1.8
	%Prefix%_Author        = Wolfgang Reszel, Michael Telgkamp

	CustomHotkey_NewFolder = 1          ; automatisches benutzerdefinierbares Tastaturkürzel? (1 = ja)
	Hotkey_NewFolder       = ^n         ; Standard-Hotkey
	HotkeyPrefix_NewFolder = $
	HideSettings = 0                    ; Wenn 1, dann bekommt die Erweiterung keinen Eintrag im Konfigurationsdialog
	HotkeyClasses_NewFolder= ahk_class #32770,ahk_class ExploreWClass,ahk_class CabinetWClass,ahk_class bosa_sdm,ahk_class Progman,ahk_class WorkerW

	IconFile_On_NewFolder = %A_WinDir%\system32\shell32.dll
	IconPos_On_NewFolder = 206

	CreateGuiID("NewFolder")

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		; Name des Menüeintrags im Tray-Menü
		MenuName                      = %nf_ScriptName% - Neuer Ordner per Tastaturkürzel
		; Beschreibung für den Erweiterungsmanager und den Konfigurationsdialog
		Description                   = Im Explorer lassen sich direkt mit einem definierten Tastaturkürzel neue Ordner anlegen. Über ein weiteres Kürzel kann man einen neuen Ordner anlegen, in dem automatisch Unterordner erstellt werden.
		lng_nf_DefFolderName          = Neuer Ordner
		lng_nf_NameOfFolder           = Name des neuen Ordners
		lng_nf_ErrorCreating          = Neuer Ordner kann nicht erstellt werden!
		lng_nf_SpecialCreate          = Tastaturkürzel für neuen Ordner`nmit vordefinierten Unterordnern
		lng_nf_SpecialCreateOnly      = Tastaturkürzel für die direkte`nErstellung der Unterordner
		lng_nf_SpecialFolders         = Vordefinierte Unterordner`n(ein Ordner je Zeile)
		lng_nf_DefaultFolders         = Bilder|Entwürfe
		lng_nf_CantCreateFolder       = Es konnte kein neuer Ordner angelegt werden.`nEntweder Sie haben nicht genügend Schreibrechte oder das Verzeichnis ist schreibgeschützt.
		lng_nf_ShowDialog             = Ordnernamen über einen Dialog abfragen (nur im Explorer`; Direkte Angabe von Unterordnern möglich)
		lng_nf_CreateFolder           = &Name des neuen Ordners (Unterordner mit \ möglich):
		lng_nf_ChangeDir              = &In den neu angelegten Ordner wechseln
		lng_nf_DontSelect             = Neuen Ordner nicht automatisch markieren (Markierung bleibt erhalten, neuer Ordner erscheint aber verzögert)
		lng_nf_MoveFiles              = &Markierte Dateien in den neuen Ordner verschieben
		lng_nf_MoveError              = Es konnten nicht alle markierten Dateien in den neuen Ordner verschoben werden.
		lng_nf_RememberSettings       = Einstellungen im Dialog werden gespeichert
	}
	else        ; = other languages (english)
	{
		MenuName                      = %nf_ScriptName% - new folder with hotkey
		Description                   = Extends the windows explorer with a hotkey for creating a new folder. A second hotkey can be used to create a folder with predefined subfolders.
		lng_nf_DefFolderName          = new folder
		lng_nf_NameOfFolder           = Name of new folder
		lng_nf_ErrorCreating          = Can't create new folder!
		lng_nf_SpecialCreate          = Hotkey for a new folder with`npredefined sub-folders
		lng_nf_SpecialCreateOnly      = Hotkey for directly creating`nthe sub-folders
		lng_nf_SpecialFolders         = predefined folders`n(one folder per line)
		lng_nf_DefaultFolders         = images|draft
		lng_nf_CantCreateFolder       = Can't create new Folder!`nEither you've not enough access rights or the folder is write-protected.
		lng_nf_ShowDialog             = Ask for the folder name in a dialog (only in explorer`; sub-folders are possible)
		lng_nf_CreateFolder           = &folder name (sub-folders with \ are possible):
		lng_nf_ChangeDir              = &enter the created folder
		lng_nf_DontSelect             = Dont select new folder (selection won't be changed but the new folder appears delayed)
		lng_nf_MoveFiles              = &Move selected files into the new folder
		lng_nf_MoveError              = Some selected files could not be moved into the new folder.
		lng_nf_RememberSettings       = Remember settings in the dialog
	}

	; zusätzliches Hotkey aus der INI-Datei einlesen
	; Syntax: HotkeyRead ( Name des Tastaturkürzels, INI-Datei, Sektion, INI-Variable, Subroutine des Tastaturkürzels, Standard-Kürzel)
	func_HotkeyRead( "nf_SpecialCreate", ConfigFile , nf_ScriptName, "SpecialHotkey", "nf_main_SpecialNewFolder", "^+n", "$", HotkeyClasses_NewFolder )
	func_HotkeyRead( "nf_SpecialCreateOnly", ConfigFile , nf_ScriptName, "SpecialOnlyHotkey", "nf_main_SpecialFolders", "^!+n", "$", HotkeyClasses_NewFolder )

	; Die zusätzlichen Unterordner aus der INI-Datei auslesen
	IniRead, nf_SpecialFolders, %ConfigFile%, NewFolder, SpecialFolders, %lng_nf_DefaultFolders%
	IniRead, nf_ShowDialog, %ConfigFile%, NewFolder, ShowDialog, 0
	IniRead, nf_ChangeDir, %ConfigFile%, NewFolder, ChangeDir, 0
	IniRead, nf_MoveFiles, %ConfigFile%, NewFolder, MoveFiles, 0
	IniRead, nf_DontSelect, %ConfigFile%, NewFolder, DontSelect, 0
	IniRead, nf_DefFolderName, %ConfigFile%, NewFolder, DefFolderName, %lng_nf_DefFolderName%
	IniRead, nf_FolderNameHistory, %ConfigFile%, NewFolder, History, |
	IniRead, nf_RememberSettings, %ConfigFile%, NewFolder, RememberSettings, 0
	If nf_FolderNameHistory =
		nf_FolderNameHistory = |
Return

; Die folgende Routine enthält alle Befehle, welche dazu nötig sind den Konfigurationsdialog zu ergänzen
; Das erste GUI-Element sollte immer mit "XS+10 Y+5" positioniert werden, wobei der Y-Wert ggf.
; auch angepasster werden kann.
SettingsGui_NewFolder:
	Gui, Add, Text, xs+10 y+7, %lng_nf_NameOfFolder%:
	Gui, Add, Edit, R1 -Wrap w300 gnf_sub_CheckIfSettingsChanged x+5 yp-3 vnf_DefFolderName, %nf_DefFolderName%
	Gui, Add, CheckBox, -Wrap gnf_sub_CheckIfSettingsChanged xs+10 y+5 vnf_ShowDialog Checked%nf_ShowDialog%, %lng_nf_ShowDialog%
	Gui, Add, CheckBox, -Wrap gnf_sub_CheckIfSettingsChanged xs+20 y+4 vnf_ChangeDir Checked%nf_ChangeDir%, %lng_nf_ChangeDir%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+20 y+4 vnf_DontSelect Checked%nf_DontSelect%, %lng_nf_DontSelect%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+20 y+4 vnf_MoveFiles Checked%nf_MoveFiles%, %lng_nf_MoveFiles%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+20 y+4 vnf_RememberSettings Checked%nf_RememberSettings%, %lng_nf_RememberSettings%
	func_HotkeyAddGuiControl( lng_nf_SpecialCreate, "nf_SpecialCreate", "xs+10 y+15 w160" )
	func_HotkeyAddGuiControl( lng_nf_SpecialCreateOnly, "nf_SpecialCreateOnly", "xs+10 y+18 w160" )
	Gui, Add, Text, xs+10 y+15 w155, %lng_nf_SpecialFolders%:
	StringReplace, nf_SpecialFolders, nf_SpecialFolders, |, `n, a
	Gui, Add, Edit, gsub_CheckIfSettingsChanged x+10 h58 W300 vnf_SpecialFolders, %nf_SpecialFolders%
	Gosub, nf_sub_CheckIfSettingsChanged
Return

nf_sub_CheckIfSettingsChanged:
	Gosub, sub_CheckIfSettingsChanged
	GuiControlGet, nf_ShowDialog_tmp,,nf_ShowDialog
	GuiControlGet, nf_ChangeDir_tmp,,nf_ChangeDir
	If nf_ShowDialog_tmp = 1
	{
		GuiControl, Enable, nf_ChangeDir
		If nf_ChangeDir_tmp = 0
		{
			GuiControl, Enable, nf_DontSelect
		}
		Else
		{
			GuiControl, Disable, nf_DontSelect
		}
		GuiControl, Enable, nf_MoveFiles
	}
	Else
	{
		GuiControl, Disable, nf_ChangeDir
		GuiControl, Disable, nf_DontSelect
		GuiControl, Disable, nf_MoveFiles
	}
Return

; wird aufgerufen, wenn im Konfigurationsdialog OK oder Übernehmen angeklickt wird
SaveSettings_NewFolder:
	; Syntax: HotkeyWrite ( Name des Tastaturkürzels, INI-Datei, Sektion, INI-Variable [, Subroutine des Tastaturkürzels] )
	func_HotkeyWrite( "nf_SpecialCreate", ConfigFile , nf_ScriptName, "SpecialHotkey" )
	func_HotkeyWrite( "nf_SpecialCreateOnly", ConfigFile , nf_ScriptName, "SpecialOnlyHotkey" )
	StringReplace, nf_SpecialFolders, nf_SpecialFolders, `n, |, a
	StringReplace, nf_SpecialFolders, nf_SpecialFolders, ||, |, a
	IniWrite, %nf_SpecialFolders%, %ConfigFile%, NewFolder, SpecialFolders
	IniWrite, %nf_ShowDialog%, %ConfigFile%, NewFolder, ShowDialog
	IniWrite, %nf_DontSelect%, %ConfigFile%, NewFolder, DontSelect
	IniWrite, %nf_ChangeDir%, %ConfigFile%, NewFolder, ChangeDir
	IniWrite, %nf_MoveFiles%, %ConfigFile%, NewFolder, MoveFiles
	IniWrite, %nf_DefFolderName%, %ConfigFile%, NewFolder, DefFolderName
	IniWrite, %nf_RememberSettings%, %ConfigFile%, NewFolder, RememberSettings
Return

ResetWindows_NewFolder:
	IniDelete, %ConfigFile%, %nf_ScriptName%, PosX
	IniDelete, %ConfigFile%, %nf_ScriptName%, PosY
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_NewFolder:
	StringReplace, nf_SpecialFolders, nf_SpecialFolders, `n, |, a
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_NewFolder:
	func_HotkeyEnable("nf_SpecialCreate")
	func_HotkeyEnable("nf_SpecialCreateOnly")
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern der Einstellungen aufgerufen
DoDisable_NewFolder:
	func_HotkeyDisable("nf_SpecialCreate")
	func_HotkeyDisable("nf_SpecialCreateOnly")
Return

; wird aufgerufen, wenn der Anwender die Erweiterung auf die Standard-Einstellungen zurücksetzt
DefaultSettings_NewFolder:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_Newfolder: ; nf
	nf_InputBoxErr = 0
	If GuiNewFolder = 1
	{
		WinActivate, ahk_id %nf_ActiveID%
		Gui, %GuiID_NewFolder%:Show
	}
	Else
		Gosub, nf_main_NewFolder
Return

; -----------------------------------------------------------------------------
; === Subroutines =========================================================nf==
; -----------------------------------------------------------------------------

; Neuer Ordner mit vordefinierten Unterordnern
nf_main_SpecialNewFolder:
	nf_FolderName = %nf_DefFolderName%
	Gosub, nf_main_NewFolder
	If nf_SpecialFolders =
		Return
	IfNotExist, %nf_CurrentExplorerDirectory%\%nf_FolderName%%nf_FolderNameAdd%
		Return

	Loop, Parse, nf_SpecialFolders, |
	{
		If A_LoopField <>
		{
			FileCreateDir, %nf_CurrentExplorerDirectory%\%nf_FolderName%%nf_FolderNameAdd%\%A_LoopField%
			If ErrorLevel
				Break
		}
	}
	If ErrorLevel
		MsgBox, 16, %lng_nf_ErrorCreating%, %lng_nf_CantCreateFolder%
Return

; Vordefinierten Unterordner direkt anlegen
nf_main_SpecialFolders:
	nf_FolderName = %nf_DefFolderName%
	WinGet, nf_ActiveID, ID, A                        ; ID des aktiven Fensters
	WinGetClass, nf_ActiveClass, A                    ; Klasse des aktiven Fensters

	nf_FolderNameAdd =
	If nf_ActiveClass in ExploreWClass,CabinetWClass,Progman,WorkerW  ; Wenn Explorer-Fenster ...
	{
		nf_CurrentExplorerDirectory := func_GetDir( nf_ActiveID, "ShowMessage", "Always", nf_ScriptName, 1 )
		Sleep,200
	}

	If nf_SpecialFolders =
		Return
	IfNotExist, %nf_CurrentExplorerDirectory%
		Return

	Loop, Parse, nf_SpecialFolders, |
	{
		Transform, nf_LoopField, Deref, %A_LoopField%
		If A_LoopField <>
		{
			FileCreateDir, %nf_CurrentExplorerDirectory%\%nf_LoopField%
			If ErrorLevel
				Break
		}
	}
	If ErrorLevel
		MsgBox, 16, %lng_nf_ErrorCreating%, %lng_nf_CantCreateFolder%
Return

; Neuer Ordner in einem Explorer-Fenster
nf_main_NewFolder:
	nf_FolderName = %nf_DefFolderName%
	WinGet, nf_ActiveID, ID, A                        ; ID des aktiven Fensters
	WinGetClass, nf_ActiveClass, A                    ; Klasse des aktiven Fensters

	nf_FolderNameAdd =
	If nf_ActiveClass in ExploreWClass,CabinetWClass,Progman,WorkerW  ; Wenn Explorer-Fenster ...
	{
		nf_CurrentExplorerDirectory := func_GetDir( nf_ActiveID, "ShowMessage", "Always", nf_ScriptName, 1) "\"
		Sleep,200

		If ( func_StrRight(nf_CurrentExplorerDirectory,2) = "\\" )
			StringTrimRight, nf_CurrentExplorerDirectory, nf_CurrentExplorerDirectory, 1

		If nf_CurrentExplorerDirectory = \
			Return

		ifNotExist, %nf_CurrentExplorerDirectory%
			Return

		If nf_ShowDialog = 1
		{
			IfExist, %nf_CurrentExplorerDirectory%%nf_FolderName%%nf_SubFolderAdd%%nf_FolderNameAdd%
			{
				Loop
				{
					nf_FolderNameAdd := " " A_Index+1
					IfNotExist, %nf_CurrentExplorerDirectory%%nf_FolderName%%nf_SubFolderAdd%%nf_FolderNameAdd%
						break
				}
				nf_FolderName = %nf_FolderName%%nf_FolderNameAdd%
				nf_FolderNameAdd =
			}
			nf_GuiWindowID := GuiDefault("NewFolder")
			Gosub, sub_BigIcon
			GuiNewFolder = 1
			IniRead, nf_PosX, %ConfigFile%, %nf_ScriptName%, PosX, %A_Space%
			IniRead, nf_PosY, %ConfigFile%, %nf_ScriptName%, PosY, %A_Space%
			If (nf_PosX <> "" AND nf_PosX <> " ")
				nf_PosX = x%nf_PosX%
			If (nf_PosY <> "" AND nf_PosY <> " ")
				nf_PosY = y%nf_PosY%

			Gui, Add, Text, , %lng_nf_CreateFolder%
			Gui, Add, ComboBox, w340 vnf_FolderName, %nf_FolderName%|%nf_FolderNameHistory%
			Gui, Add, CheckBox, -Wrap gnf_sub_FocusFolderName vnf_ChangeDirTmp Checked%nf_ChangeDir%, %lng_nf_ChangeDir%
			ControlGet, nf_Selected, List, Count Selected, SysListView321, ahk_id %nf_ActiveID%
			If nf_Selected > 0
				Gui, Add, CheckBox, -Wrap gnf_sub_FocusFolderName vnf_MoveFilesTmp Checked%nf_MoveFiles%, %lng_nf_MoveFiles%
			Gui, Add, Button, -Wrap X95 W80 Default gNewFolderGuiOK, %lng_OK%
			Gui, Add, Button, -Wrap X+5 W80 gNewFolderGuiClose, %lng_cancel%
			Gui, -Resize +LastFound
			Gui, Show, %nf_PosX% %nf_PosY% w360, %nf_ScriptName% v%nf_ScriptVersion%
			Loop
			{
				If GuiNewFolder <> 1
					Break
				Sleep, 50
			}
			nf_SubFolderAdd =
			StringReplace, nf_FolderName, nf_FolderName, /, \, All

			If (InStr(nf_FolderName,":\") = 2)
				nf_CurrentExplorerDirectory =

			If (InStr(nf_FolderName,"\") = 1)
				StringLeft, nf_CurrentExplorerDirectory, nf_CurrentExplorerDirectory, 2

			StringLen, nf_NameAddLen, nf_FolderNameAdd
			If ( func_StrRight(nf_FolderName,nf_NameAddLen) = nf_FolderNameAdd )
			{
				StringTrimRight, nf_FolderName, nf_FolderName, %nf_NameAddLen%
			}
			Else
				nf_FolderNameAdd =

			StringGetPos,nf_SubpathPos, nf_FolderName, \
			If ErrorLevel = 0
			{
				StringTrimLeft, nf_SubFolderAdd, nf_FolderName, %nf_SubpathPos%
				StringLeft, nf_FolderName, nf_FolderName, %nf_SubpathPos%
			}

			If nf_RememberSettings = 1
			{
				nf_ChangeDir = %nf_ChangeDirTmp%
				If nf_Selected > 0
					nf_MoveFiles = %nf_MoveFilesTmp%
				IniWrite, %nf_ChangeDir%, %ConfigFile%, NewFolder, ChangeDir
				IniWrite, %nf_MoveFiles%, %ConfigFile%, NewFolder, MoveFiles
			}

			If nf_InputBoxErr = 1
				Return

			IfWinNotActive, ahk_id %nf_ActiveID%
				WinActivate, ahk_id %nf_ActiveID%
		}
		Transform, nf_FolderName, Deref, %nf_FolderName%
		IfExist, %nf_CurrentExplorerDirectory%%nf_FolderName%%nf_SubFolderAdd%%nf_FolderNameAdd%
		{
			Loop
			{
				nf_FolderNameAdd := " " A_Index+1
				IfNotExist, %nf_CurrentExplorerDirectory%%nf_FolderName%%nf_SubFolderAdd%%nf_FolderNameAdd%
					break
			}
		}

		ControlGet, nf_LastCount, List, Count, SysListView321, A
		; Neuen Ordner anlegen
		FileCreateDir, %nf_CurrentExplorerDirectory%%nf_FolderName%%nf_SubFolderAdd%%nf_FolderNameAdd%

		; Wenn kein Fehler
		If ErrorLevel = 0
		{
			If (!(nf_ShowDialog = 1 AND nf_DontSelect = 1 AND nf_ChangeDirTmp = 0 AND nf_Selected > 0) OR nf_MoveFilesTmp = 1)
			{
				WinGetClass, nf_Class, A

				; Wenn Ordnerleiste aktiv, zum Ordnerinhalt wechseln
				ControlGetFocus, nf_Control, A
				If nf_Control = SysTreeView321
					ControlFocus, SysListView321, A

				nf_Clipboard = %ClipboardAll%

				If nf_MoveFilesTmp = 1
				{
					func_GetSelection(1,1,1)
					nf_Selection = %Selection%
				}
				; 20 mal prüfen, ob Ordner exisitert (dauert bei Netzlaufwerken etwas)
				Loop,20
				{
					IfExist, %nf_CurrentExplorerDirectory%%nf_FolderName%%nf_SubFolderAdd%%nf_FolderNameAdd%   ; Prüfen ob existiert
					{
						If nf_MoveFilesTmp = 1
						{
							nf_MoveErrors =
							Loop, Parse, nf_Selection, `n, `r
							{
								If A_LoopField =
									continue
								SplitPath, A_LoopField, LoopFieldFName
								If (InStr( FileExist( A_LoopField ), "D"))
									FileMoveDir, %A_LoopField%, %nf_CurrentExplorerDirectory%%nf_FolderName%%nf_SubFolderAdd%%nf_FolderNameAdd%\%LoopFieldFName%, R
								Else
									FileMove, %A_LoopField%, %nf_CurrentExplorerDirectory%%nf_FolderName%%nf_SubFolderAdd%%nf_FolderNameAdd%, R
								If ErrorLevel
									nf_MoveErrors = %nf_MoveErrors%`n%LoopFieldFName%
							}
							If nf_MoveErrors <>
								MsgBox, 48, %nf_ScriptTitle%, %lng_nf_MoveError%`n%nf_MoveErrors%
						}
						If (!(nf_ShowDialog = 1 AND nf_DontSelect = 1 AND nf_ChangeDirTmp = 0 AND nf_Selected > 0) OR nf_MoveFilesTmp = 1)
						{
							IfWinNotActive, ahk_id %nf_ActiveID%
								WinActivate, ahk_id %nf_ActiveID%
							SendMessage, 0x111, 41504,,, ahk_id %nf_ActiveID% ; Aktualisieren
							Sleep, 50
		;               PostMessage, 0x111, 28931,,, A
							If nf_Class = WorkerW
								Send, {ESC}{F5}
		;               Send,{ESC}{F5}                                         ; Explorer-Ansicht aktualisieren
							func_SelectInExplorer(nf_FolderName nf_FolderNameAdd)   ; Ordner auswählen (durch Eingabe des Namens)
							If nf_ShowDialog = 0
								Send,{F2}
							Else If nf_ChangeDirTmp = 1
							{
								;WinWaitClose
								func_ChangeDir( nf_CurrentExplorerDirectory nf_FolderName nf_SubFolderAdd nf_FolderNameAdd, -1 )
		;                  Send, {F5}
								SendMessage, 0x111, 41504,,, ahk_id %nf_ActiveID% ; Aktualisieren
							}
						}
						Break                                             ; Schleife verlassen
					}
					Sleep,100                                            ; kleine Pause
				}
				Clipboard = %nf_Clipboard%
			}
		}
		Else
			MsgBox, 16, %lng_nf_ErrorCreating%, %lng_nf_CantCreateFolder%
	}
	Else If nf_ActiveClass = #32770                            ; Ist Dateidialog?
	{
		PostMessage, 0x111, 40962,,,A                      ; Direkten Befehl für neuer Ordner senden
	}
	Else If nf_ActiveClass contains bosa_sdm_                  ; Ist Office-Dateidialog?
	{
		Send, !5                                           ; Kürzel für neuer Ordner senden
	}
	Else
		Send, % func_prepareHotkeyForSend(A_ThisHotkey)
	nf_Selected = 0
Return

nf_sub_FocusFolderName:
	If (GetKeyState("Alt"))
		GuiControl, focus, nf_FolderName
Return

NewFolderGuiClose:
NewFolderGuiEscape:
	WinGetPos, nf_PosX, nf_PosY,,,ahk_id %nf_GuiWindowID%
	IniWrite, %nf_PosX%, %ConfigFile%, %nf_ScriptName%, PosX
	IniWrite, %nf_PosY%, %ConfigFile%, %nf_ScriptName%, PosY
	nf_PosX = x%nf_PosX%
	nf_PosY = y%nf_PosY%
	Gui, %GuiID_NewFolder%:Destroy
	GuiNewFolder = 0
	nf_InputBoxErr = 1
Return

NewFolderGuiOk:
	WinGetPos, nf_PosX, nf_PosY,,,ahk_id %nf_GuiWindowID%
	IniWrite, %nf_PosX%, %ConfigFile%, %nf_ScriptName%, PosX
	IniWrite, %nf_PosY%, %ConfigFile%, %nf_ScriptName%, PosY
	nf_PosX = x%nf_PosX%
	nf_PosY = y%nf_PosY%
	Gui, %GuiID_NewFolder%:Submit
	Gui, %GuiID_NewFolder%:Destroy
;   IniWrite, %nf_ChangeDir%, %ConfigFile%, NewFolder, ChangeDir
	If (nf_FolderName <> nf_DefFolderName)
	{
		StringReplace, nf_FolderNameHistory, nf_FolderNameHistory, |%nf_FolderName%|,|, A
		nf_FolderNameHistory = |%nf_FolderName%|%nf_FolderNameHistory%
		StringReplace, nf_FolderNameHistory, nf_FolderNameHistory, ||, |, A
		StringGetPos, nf_HistPos, nf_FolderNameHistory, |, L21
		If nf_HistPos > 0
			StringLeft, nf_FolderNameHistory, nf_FolderNameHistory, % nf_HistPos+1
	}
	IniWrite, %nf_FolderNameHistory%, %ConfigFile%, NewFolder, History
	GuiNewFolder = 0
	nf_InputBoxErr = 0
Return
