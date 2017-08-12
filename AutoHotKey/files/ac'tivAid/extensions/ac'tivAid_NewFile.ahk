; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               NewFile
; -----------------------------------------------------------------------------
; Prefix:             nd_
; Version:            0.7
; Date:               2008-05-23
; Author:             Dirk Schwarzmann, dirk.schwarzmann@gmx.de
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_NewFile:
	Prefix = nd
	%Prefix%_ScriptName    = NewFile
	%Prefix%_ScriptVersion = 0.7
	%Prefix%_Author        = Dirk Schwarzmann

	CustomHotkey_NewFile = 1          ; automatisches benutzerdefinierbares Tastaturkürzel? (1 = ja)
	Hotkey_NewFile       = ^!n        ; Standard-Hotkey
	HotkeyPrefix_NewFile = $
	HideSettings = 0                    ; Wenn 1, dann bekommt die Erweiterung keinen Eintrag im Konfigurationsdialog
	HotkeyClasses_NewFile = ahk_class #32770,ahk_class ExploreWClass,ahk_class CabinetWClass,ahk_class bosa_sdm,ahk_class Progman,ahk_class WorkerW

	CreateGuiID("NewFile")

	IconFile_On_NewFile = %A_WinDir%\system32\shell32.dll
	IconPos_On_NewFile = 71

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		; Name des Menüeintrags im Tray-Menü
		MenuName                      = %nd_ScriptName% - Neue Datei per Tastaturkürzel
		; Beschreibung für den Erweiterungsmanager und den Konfigurationsdialog
		Description                   = Im Explorer lassen sich direkt mit einem definierten Tastaturkürzel neue Dateien anlegen.
		nd_DefFileName                = Neue Datei
		lng_nd_ErrorCreating          = Neue Datei kann nicht erstellt werden!
		lng_nd_ErrorCreatingDetail    = Es konnte keine neue Datei angelegt werden.`nEntweder Sie haben nicht genügend Schreibrechte oder das Verzeichnis ist schreibgeschützt.
		lng_nd_Extension              = Vorgegebene Datei-Erweiterung
		lng_nd_ShowDialog             = Dateinamen über einen Dialog abfragen (Direkte Angabe von Unterordnern möglich)
		lng_nd_CreateFile             = &Name des neuen Datei (Unterordner mit \ möglich):
		lng_nd_OpenFile               = &Datei direkt zur Bearbeitung öffnen
	}
	else        ; = other languages (english)
	{
		MenuName                      = %nd_ScriptName% - new file with hotkey
		Description                   = Extends the windows explorer with a hotkey for creating a new file.
		nd_DefFileName                = new file
		lng_nd_ErrorCreating          = Can't create new file!
		lng_nd_ErrorCreatingDetail    = Can't create new file!`nEither you've not enough access rights or the folder is write-protected.
		lng_nd_Extension              = Default file-extension
		lng_nd_ShowDialog             = Ask for the file name in a dialog (sub-folders are possible)
		lng_nd_CreateFile             = &file name (sub-folders with \ are possible):
		lng_nd_OpenFile               = &open file in associated program
	}
	IniRead, nd_DefExtension, %ConfigFile%, NewFile, Extension, txt
	IniRead, nd_ShowDialog, %ConfigFile%, NewFile, ShowDialog, 0
	IniRead, nd_OpenFile, %ConfigFile%, NewFile, OpenFile, 0
	IniRead, nd_FileNameHistory, %ConfigFile%, NewFile, History, |
	If nd_FileNameHistory =
		nd_FileNameHistory = |
Return

; Die folgende Routine enthält alle Befehle, welche dazu nötig sind den Konfigurationsdialog zu ergänzen
; Das erste GUI-Element sollte immer mit "XS+10 Y+5" positioniert werden, wobei der Y-Wert ggf.
; auch angepasster werden kann.
SettingsGui_NewFile:
	Gui, Add, Text, xs+10 y+8, %lng_nd_Extension%:
	Gui, Add, Edit, r1 x+5 yp-4 vnd_DefExtension w30 gsub_CheckIfSettingsChanged, %nd_DefExtension%
	Gui, Add, CheckBox, -Wrap gnd_sub_CheckIfSettingsChanged xs+10 y+5 vnd_ShowDialog Checked%nd_ShowDialog%, %lng_nd_ShowDialog%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+25 y+5 vnd_OpenFile Checked%nd_OpenFile%, %lng_nd_OpenFile%
	Gosub, nd_sub_CheckIfSettingsChanged
Return

nd_sub_CheckIfSettingsChanged:
	Gosub, sub_CheckIfSettingsChanged
	GuiControlGet, nd_ShowDialog_tmp,,nd_ShowDialog
	If nd_ShowDialog_tmp = 1
	{
		GuiControl, Enable, nd_OpenFile
	}
	Else
	{
		GuiControl, Disable, nd_OpenFile
	}
Return

; wird aufgerufen, wenn im Konfigurationsdialog OK oder Übernehmen angeklickt wird
SaveSettings_NewFile:
	IniWrite, %nd_DefExtension%, %ConfigFile%, NewFile, Extension
	IniWrite, %nd_ShowDialog%, %ConfigFile%, NewFile, ShowDialog
	IniWrite, %nd_OpenFile%, %ConfigFile%, NewFile, OpenFile
Return

ResetWindows_NewFile:
	IniDelete, %ConfigFile%, %nd_ScriptName%, PosX
	IniDelete, %ConfigFile%, %nd_ScriptName%, PosY
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_NewFile:
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_NewFile:
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern der Einstellungen aufgerufen
DoDisable_NewFile:
Return

; wird aufgerufen, wenn der Anwender die Erweiterung auf die Standard-Einstellungen zurücksetzt
DefaultSettings_NewFile:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_NewFile:
	If GuiNewFile = 1
		Gosub, NewFileGuiClose
	Gosub, nd_main_NewFile
Return

; -----------------------------------------------------------------------------
; === Subroutines =========================================================nf==
; -----------------------------------------------------------------------------

; Neue Datei in einem Explorer-Fenster
nd_main_NewFile:
	WinGet, nd_ActiveID, ID, A                        ; ID des aktiven Fensters
	WinGetClass, nd_ActiveClass, A                    ; Klasse des aktiven Fensters

	nd_Extension = %nd_DefExtension%
	nd_FileName = %nd_DefFileName%

	If (!InStr(nd_Extension,".") AND nd_Extension <> "")
		nd_Extension = .%nd_Extension%

	nd_FileNameAdd =
	nd_SubFolderAdd =

	If nd_ActiveClass in ExploreWClass,CabinetWClass,Progman,WorkerW  ; Wenn Explorer-Fenster ...
	{
		nd_CurrentExplorerDirectory := func_GetDir( nd_ActiveID,"ShowMessage", "Always", nd_ScriptName )
		Sleep,200

		If ( func_StrRight(nd_CurrentExplorerDirectory,2) = "\\" )
			StringTrimRight, nd_CurrentExplorerDirectory, nd_CurrentExplorerDirectory, 1

		If nd_CurrentExplorerDirectory =
			Return

		ifNotExist, %nd_CurrentExplorerDirectory%
			Return

		If nd_ShowDialog = 1
		{
			IfExist, %nd_CurrentExplorerDirectory%\%nd_FileName%%nd_FileNameAdd%%nd_Extension%
			{
				Loop
				{
					nd_FileNameAdd := " " A_Index+1
					IfNotExist, %nd_CurrentExplorerDirectory%\%nd_FileName%%nd_FileNameAdd%%nd_Extension%
						break
				}
				nd_FileName = %nd_FileName%%nd_FileNameAdd%
				nd_FileNameAdd =
			}

			nd_GuiWindowID := GuiDefault("NewFile")
			Gosub, sub_BigIcon
			GuiNewFile = 1
			IniRead, nd_PosX, %ConfigFile%, %nd_ScriptName%, PosX, %A_Space%
			IniRead, nd_PosY, %ConfigFile%, %nd_ScriptName%, PosY, %A_Space%
			If (nd_PosX <> "" AND nd_PosX <> " ")
				nd_PosX = x%nd_PosX%
			If (nd_PosY <> "" AND nd_PosY <> " ")
				nd_PosY = y%nd_PosY%

			Gui, Add, Text, , %lng_nd_CreateFile%
			Gui, Add, ComboBox, w340 vnd_FileName_tmp, %nd_FileName%%nd_Extension%|%nd_FileNameHistory%
			Gui, Add, CheckBox, -Wrap vnd_OpenFile Checked%nd_OpenFile%, %lng_nd_OpenFile%
			Gui, Add, Button, -Wrap X95 W80 Default gNewFileGuiOK, %lng_OK%
			Gui, Add, Button, -Wrap X+5 W80 gNewFileGuiClose, %lng_cancel%
			Gui, -Resize +LastFound
			Gui, Show, %nd_PosX% %nd_PosY% w360, %nd_ScriptName% v%nd_ScriptVersion%

			StringLen, nd_GoLeft, nd_Extension
			Send, {Home}{Shift down}{End}{Left %nd_GoLeft%}{Shift up}                ; Dateiname ohne Erweiterung markieren

			Loop
			{
				If GuiNewFile <> 1
					Break
				Sleep, 50
			}

			StringReplace, nd_FileName_tmp, nd_FileName_tmp, /, \, All

			SplitPath, nd_FileName_tmp, , nd_SubFolderAdd, nd_Extension, nd_FileName, nd_Drive
			nd_Extension = .%nd_Extension%

			If (InStr(nd_FileName_tmp,":\") = 2)
				nd_CurrentExplorerDirectory =

			If (InStr(nd_FileName_tmp,"\") = 1)
				StringLeft, nd_CurrentExplorerDirectory, nd_CurrentExplorerDirectory, 2

			If (func_StrLeft(nd_SubFolderAdd,1) <> "\" AND nd_SubFolderAdd <> "" AND nd_SubFolderAdd <> nd_Drive AND !InStr(nd_SubFolderAdd,nd_Drive))
				nd_SubFolderAdd = \%nd_SubFolderAdd%

			If nd_InputBoxErr = 1
				Return
		}

		IfNotExist, %nd_CurrentExplorerDirectory%%nd_SubFolderAdd%\
			FileCreateDir, %nd_CurrentExplorerDirectory%%nd_SubFolderAdd%\

		IfExist, %nd_CurrentExplorerDirectory%%nd_SubFolderAdd%\%nd_FileName%%nd_FileNameAdd%%nd_Extension%
		{
			Loop
			{
				nd_FileNameAdd := " " A_Index+1
				IfNotExist, %nd_CurrentExplorerDirectory%%nd_SubFolderAdd%\%nd_FileName%%nd_FileNameAdd%%nd_Extension%
					break
			}
		}

		; Neue Datei anlegen
		FileAppend, , %nd_CurrentExplorerDirectory%%nd_SubFolderAdd%\%nd_FileName%%nd_FileNameAdd%%nd_Extension%

		; Wenn kein Fehler
		If ErrorLevel = 0
		{
			; Wenn Ordnerleiste aktiv, zum Ordnerinhalt wechseln
			ControlGetFocus, nd_Control, A
			If nd_Control = SysTreeView321
				ControlFocus, SysListView321, A

			nd_Clipboard = %ClipboardAll%

			; 20 mal prüfen, ob Datei existiert (dauert bei Netzlaufwerken etwas)
			Loop,20
			{
				IfExist, %nd_CurrentExplorerDirectory%%nd_SubFolderAdd%\%nd_FileName%%nd_FileNameAdd%%nd_Extension%   ; Prüfen ob existiert
				{
					IfWinNotActive, ahk_id %nd_ActiveID%
						WinActivate, ahk_id %nd_ActiveID%

					If (nd_ShowDialog = 1 AND nd_SubFolderAdd <> "")
					{
						func_ChangeDir( nd_CurrentExplorerDirectory nd_SubFolderAdd "\" )
					}

					If (nd_Extension = "" OR nd_Extension = ".")
					{
						Send,{ESC}{F5}                                     ; Explorer-Ansicht aktualisieren
						Sleep, 30
						func_SelectInExplorer( nd_FileName nd_FileNameAdd, "ahk_id " nd_ActiveID) ; Datei auswählen (durch Eingabe des Namens)
						Sleep, 30
						If (nd_ShowDialog = 0 AND nd_OpenFile = 0)
							Send, {F2}
						If nd_OpenFile = 1
						{
							Run, edit %nd_CurrentExplorerDirectory%%nd_SubFolderAdd%\%nd_FileName%%nd_FileNameAdd%,,UseErrorLevel
							If ErrorLevel = ERROR
								func_GetErrorMessage( A_LastError, nd_ScriptTitle, A_Quote nd_FileName nd_FileNameAdd nd_Extension A_Quote "`n`n" )
						}
						Break ; Schleife verlassen
					}
					Else
					{
						StringLen, nd_GoLeft, nd_Extension
						Send,{ESC}{F5} ; Explorer-Ansicht aktualisieren
						Sleep, 30
						func_SelectInExplorer(nd_FileName nd_FileNameAdd nd_Extension, "ahk_id " nd_ActiveID) ; Datei auswählen (durch Eingabe des Namens)
						Sleep, 30
						If nd_ShowDialog = 0
						{
							Send, {F2}
							RegRead, nd_HideExt, HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced,HideFileExt
							If nd_HideExt = 0
								 Send, {Home}{Shift down}{End}{Left %nd_GoLeft%}{Shift up} ; Dateiname ohne Erweiterung markieren

							;   Send, {Left %nd_GoLeft%}+{Home}                ; Dateiname ohne Erweiterung markieren
						}
						Else If nd_OpenFile = 1
						{
							Run, edit %nd_CurrentExplorerDirectory%%nd_SubFolderAdd%\%nd_FileName%%nd_FileNameAdd%%nd_Extension%,,UseErrorLevel
							If ErrorLevel = ERROR
								func_GetErrorMessage( A_LastError, nd_ScriptName, A_Quote nd_FileName nd_FileNameAdd nd_Extension A_Quote "`n`n" )
						}
						Break                                             ; Schleife verlassen
					}
				}
				Sleep,100                                            ; kleine Pause
			}

			ClipBoard = %nd_Clipboard%
		}
		Else
			MsgBox, 16, %lng_nd_ErrorCreating%, %lng_nd_ErrorCreatingDetail%

	}
	Else
		Send, % func_prepareHotkeyForSend(A_ThisHotkey)
Return

NewFileGuiClose:
NewFileGuiEscape:
	WinGetPos, nd_PosX, nd_PosY,,,ahk_id %nd_GuiWindowID%
	IniWrite, %nd_PosX%, %ConfigFile%, %nd_ScriptName%, PosX
	IniWrite, %nd_PosY%, %ConfigFile%, %nd_ScriptName%, PosY
	nd_PosX = x%nd_PosX%
	nd_PosY = y%nd_PosY%
	Gui, %GuiID_NewFile%:Destroy
	GuiNewFile = 0
	nd_InputBoxErr = 1
Return

NewFileGuiOk:
	WinGetPos, nd_PosX, nd_PosY,,,ahk_id %nd_GuiWindowID%
	IniWrite, %nd_PosX%, %ConfigFile%, %nd_ScriptName%, PosX
	IniWrite, %nd_PosY%, %ConfigFile%, %nd_ScriptName%, PosY
	nd_PosX = x%nd_PosX%
	nd_PosY = y%nd_PosY%
	Gui, %GuiID_NewFile%:Submit
	Gui, %GuiID_NewFile%:Destroy
	IniWrite, %nd_OpenFile%, %ConfigFile%, NewFile, OpenFile
	If (nd_FileName_tmp <> nd_DefFileName nd_DefExtension)
	{
		StringReplace, nd_FileNameHistory, nd_FileNameHistory, |%nd_FileName_tmp%|,|, A
		nd_FileNameHistory = |%nd_FileName_tmp%|%nd_FileNameHistory%
		StringReplace, nd_FileNameHistory, nd_FileNameHistory, ||, |, A
		StringGetPos, nd_HistPos, nd_FileNameHistory, |, L21
		If nd_HistPos > 0
			StringLeft, nd_FileNameHistory, nd_FileNameHistory, % nd_HistPos+1
	}
	IniWrite, %nd_FileNameHistory%, %ConfigFile%, NewFile, History
	GuiNewFile = 0
	nd_InputBoxErr = 0
Return
