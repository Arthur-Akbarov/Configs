; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               EditWith
; -----------------------------------------------------------------------------
; Prefix:             ew_
; Version:            0.2
; Date:               2008-02-05
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_EditWith:
	Prefix = ew
	%Prefix%_ScriptName    = EditWith
	%Prefix%_ScriptVersion = 0.2
	%Prefix%_Author        = Wolfgang Reszel

	CustomHotkey_EditWith = 1
	HotkeyPrefix_EditWith = $
	HideSettings          = 0

	HotkeyClasses_EditWith=%ExplorerAndDialogs%

	IconFile_On_EditWith = %A_WinDir%\system32\shell32.dll
	IconPos_On_EditWith = 208

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		; Name des Menüeintrags im Tray-Menü
		MenuName                   = %ew_ScriptName% - Markierte Dateien bearbeiten
		; Beschreibung für den Erweiterungsmanager und den Konfigurationsdialog
		Description                = Im Explorer und Dateidialogen markierte Dateien werden per Tastaturkürzel in einem Texteditor geöffnet
		lng_ew_Editor              = Editor:
		lng_ew_FileType            = Ausführbare Datei (*.exe)
		lng_ew_Default             = Standard
		lng_ew_Creating            = Dateiliste wird erstellt ...
		lng_ew_GettingFiles        = Ermittle markierte Dateien ...
		lng_ew_NoSelection         = Keine Datei ausgewählt!
		lng_ew_NoSelection2        = Es konnte keine Datei zum Bearbeiten geöffnet werden, evtl. haben Sie nur Ordner markiert!
		lng_ew_MultiFileEditor     = Der angegebene Editor kann mehrere Dateien auf einmal bearbeiten
		lng_ew_Warning             = Sie haben mehr als 20 Dateien auf einmal markiert.`nWollen Sie wirklich so viele Dateien auf einmal bearbeiten?
		lng_ew_ActivateEditor      = Versuchen, den Editor in den Vordergrund zu holen`n(Prozessname muss identisch zum Dateinamen des Editors sein)
	}
	else        ; = other languages (english)
	{
		MenuName                   = %ew_ScriptName% - Edit selected files
		Description                = Edit selected files in explorer or file dialogs with a specified text editor
		lng_ew_Editor              = Editor:
		lng_ew_FileType            = Executable (*.exe)
		lng_ew_Default             = Default
		lng_ew_Creating            = Creating file list ...
		lng_ew_GettingFiles        = Getting selected files ...
		lng_ew_NoSelection         = No file selected!
		lng_ew_NoSelection2        = Could not edit any of the selected files, maybe you have only selected folders!
		lng_ew_MultiFileEditor     = The specified editor can edit multiple files at once
		lng_ew_Warning             = You have selected more than 20 files.`nDo you really want to edit so many files?
		lng_ew_ActivateEditor      = Try to activate the editor`n(process name must be the same as the editor filename)
	}
	ew_ScriptTitle := ew_ScriptName " " ew_ScriptVersion
	IniRead, ew_Editor, %ConfigFile%, %ew_ScriptName%, Editor, %A_Space%
	IniRead, ew_MultiFileEditor, %ConfigFile%, %ew_ScriptName%, MultiFileEditor, 0
	IniRead, ew_ActivateEditor, %ConfigFile%, %ew_ScriptName%, ActivateEditor, 0
Return

SettingsGui_EditWith:
	Gui, Add, Text, xs+10 y+18, %lng_ew_Editor%
	Gui, Add, Edit, x+10 yp-3 r1 w320 gsub_CheckIfSettingsChanged vew_Editor, %ew_Editor%
	Gui, Add, Button, -Wrap x+5 yp-1 W100 gew_sub_Browse, %lng_Browse%
	Gui, Add, Button, -Wrap x+5 W80 gew_sub_SetDefault, %lng_ew_default%
	Gui, Add, Checkbox, -Wrap y+5 xs+10 vew_MultiFileEditor Checked%ew_MultiFileEditor% gsub_CheckIfSettingsChanged, %lng_ew_MultiFileEditor%
	Gui, Add, Checkbox, y+10 xs+10 vew_ActivateEditor Checked%ew_ActivateEditor% gsub_CheckIfSettingsChanged, %lng_ew_ActivateEditor%
Return

; wird aufgerufen, wenn im Konfigurationsdialog OK oder Übernehmen angeklickt wird
SaveSettings_EditWith:
	IniWrite, %ew_Editor%, %ConfigFile%, %ew_ScriptName%, Editor
	IniWrite, %ew_MultiFileEditor%, %ConfigFile%, %ew_ScriptName%, MultiFileEditor
	IniWrite, %ew_ActivateEditor%, %ConfigFile%, %ew_ScriptName%, ActivateEditor
Return

ResetWindows_EditWith:
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_EditWith:
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_EditWith:
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern der Einstellungen aufgerufen
DoDisable_EditWith:
Return

; wird aufgerufen, wenn der Anwender die Erweiterung auf die Standard-Einstellungen zurücksetzt
DefaultSettings_EditWith:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_EditWith:
	Gosub, ew_main_EditWith
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

ew_main_EditWith:
	WinGet, ew_ActiveID, ID, A                        ; ID des aktiven Fensters
	WinGetClass, ew_ActiveClass, A                    ; Klasse des aktiven Fensters

	ControlGetFocus, ew_Focus, ahk_id %ew_ActiveID%
	ControlGet, ew_Count, List, Count Selected, %ew_Focus%, ahk_id %ew_ActiveID%
	ControlGet, ew_CountAll, List, Count, %ew_Focus%, ahk_id %ew_ActiveID%

	; QUICKFIX für Windows 7 (Zwischenablage nutzen)
	if (aa_osversionnumber >= aa_osversionnumber_7)
	{
		ew_previousClipboard := clipboard
		clipboard =
		Send, ^c
		clipwait, 1
		ew_list := clipboard
		clipboard := ew_previousClipboard
		ew_previousClipboard =
		ew_Count = 0
		ew_CurrentExplorerDirectory = 
		loop,parse,ew_list, `n
		{
			ew_Count:=ew_Count+1
			if (ew_CurrentExplorerDirectory = "")
				ew_CurrentExplorerDirectory := substr(a_loopfield, 1,(InStr(a_loopfield, "\", false, 0)-1))
		}
	}
	
	IfInString, ew_Focus, SysTreeView32
	{
		Return
	}

	If ew_Count < 1
	{
		 BalloonTip( ew_ScriptTitle, lng_ew_NoSelection, "Warning",0,0,7)
	}

	IfNotInString, ew_Focus, SysListView32
		Return

	if ew_Count>20
	{
		MsgBox, 52, %ew_ScriptTitle%, %lng_ew_Warning%
		IfMsgBox, No
			Return
	}

	if ew_Count>100
	{
		SplashImage,, b2 p0 w300 h26, , %lng_ew_GettingFiles%
		ew_faktor := 100/ew_RowNumber
	}

	if (aa_osversionnumber >= aa_osversionnumber_7)
	{
		Gosub, ew_sub_EditWith
		Return
	}

	If ew_ActiveClass in %ChangeDirClasses%,Progman,WorkerW
	{
		RegRead, ew_HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt
		ew_CurrentExplorerDirectory := func_GetDir( ew_ActiveID )
		ControlGet, ew_Selection, List, Selected Col1, %ew_Focus%, ahk_id %ew_ActiveID%
		ew_Selection := RegExReplace(ew_Selection, "\s|\r|\n", "") ; Alle Leerzeichen und Umbrüche entfernen, ew_Selection ist dann leer, wenn ControlGet fehl schlägt
		If (!FileExist(ew_CurrentExplorerDirectory) OR ew_HiddenFiles_Status = 1 OR ew_Selection = "")
		{
			func_GetSelection(1,0,ew_Count/30+1)
			tooltip
			SplashImage, Off
			ew_List = %Selection%`n
			ew_Selection = %Selection%
			StringLeft, ew_CurrentExplorerDirectory, ew_List, % InStr(ew_List,"`n")
			SplitPath, ew_CurrentExplorerDirectory,, ew_currentexplorerdirectory
			StringTrimRight, ew_List, ew_List, 1
		}
		Else
		{
			SplashImage, Off
			If ew_Count > 100
			{
				Progress, b2 p0 w300, , %lng_ew_Creating%
				Sleep, 10
			}
			ew_Selection =

			If ew_Count = %ew_CountAll%
			{
				Loop, %ew_CurrentExplorerDirectory%\*.*, 1, 0
					ew_Selection = %ew_Selection%%A_LoopFileFullPath%`n
				StringTrimRight, ew_Selection, ew_Selection, 1
			}
			Else
			{
				ControlGet, ew_Selection, List, Selected Col1, %ew_Focus%, ahk_id %ew_ActiveID%
				StringReplace, ew_Selection, ew_Selection, `n, `n%ew_CurrentExplorerDirectory%\, All
				ew_Selection = %ew_CurrentExplorerDirectory%\%ew_Selection%
			}
			ew_List = %ew_Selection%
		}
		Gosub, ew_sub_EditWith
	}
Return

ew_sub_EditWith:
	SetTitleMatchMode,3
	DetectHiddenWindows, On
	If ew_List =
	{
		BalloonTip( ew_ScriptTitle, lng_ew_NoSelection, "Warning",0,0,7)
		Return
	}

	SplitPath, ew_Editor, ew_EditorName

	ew_OpenFiles =
	ew_EditorPID =
	Loop, Parse, ew_List, `n, `r  ; Rows are delimited by linefeeds (`n).
	{
		SplitPath, A_LoopField, ew_datName, ew_CurrentExplorerDirectory, ew_datExt
		ew_Filename := A_LoopField
		If (!FileExist(ew_FileName))
		{
			IfExist, %ew_CurrentExplorerDirectory%\%ew_datName%.lnk
			{
				ew_Filename = %ew_CurrentExplorerDirectory%\%ew_datName%.lnk
				ew_datExt = lnk
				ew_datName = %ew_datName%.lnk
			}
		}
		If (!FileExist(ew_FileName) AND (ew_CurrentExplorerDirectory = A_Desktop OR ew_CurrentExplorerDirectory = A_DesktopCommon))
		{
			IfExist, %A_Desktop%\%ew_datName%.lnk
			{
				ew_Filename = %A_Desktop%\%ew_datName%.lnk
				ew_CurrentExplorerDirectory = %A_Desktop%
				ew_datExt = lnk
				ew_datName = %ew_datName%.lnk
			}
			Else IfExist, %A_DesktopCommon%\%ew_datName%.lnk
			{
				ew_Filename = %A_DesktopCommon%\%ew_datName%.lnk
				ew_CurrentExplorerDirectory = %A_DesktopCommon%
				ew_datExt = lnk
				ew_datName = %ew_datName%.lnk
			}
		}
		If (FileExist(ew_Filename) AND !InStr(FileExist(ew_Filename),"D"))
		{
			If ew_Editor =
			{
				Run, Edit %ew_Filename%,,UseErrorLevel, ew_EditorPID
				If ErrorLevel = ERROR
					func_GetErrorMessage( A_LastError, ew_ScriptTitle, A_Quote ew_DatName A_Quote "`n`n" )
			}
			Else If ew_MultiFileEditor = 0
			{
				Run, % func_Deref(ew_Editor) " """ ew_Filename """",,UseErrorLevel, ew_EditorPID
				If ErrorLevel = ERROR
					func_GetErrorMessage( A_LastError, ew_ScriptTitle, ew_EditorName " " A_Quote ew_DatName A_Quote "`n`n" )
			}
			Else
				ew_OpenFiles = %ew_OpenFiles% "%ew_Filename%"
		}
	}
	If (ew_Editor <> "" AND ew_MultiFileEditor = 1)
	{
		If ew_OpenFiles =
			BalloonTip( ew_ScriptTitle, lng_ew_NoSelection2, "Warning",0,0,7)
		Else
		{
			Run, % func_Deref(ew_Editor) " " ew_OpenFiles,,UseErrorLevel, ew_EditorPID
			If ErrorLevel = ERROR
				func_GetErrorMessage( A_LastError, ew_ScriptTitle, ew_EditorName "`n`n" )
		}
	}
	If (ErrorLevel <> "ERROR" AND ew_ActivateEditor = 1)
	{
		Sleep, 800
		DetectHiddenWindows, Off
		WinGet, ew_ProcList, List
		Loop, %ew_ProcList%
		{
			WinGet, ew_ProcName, ProcessName, % "ahk_id " ew_ProcList%A_Index%
			If ew_ProcName = %ew_EditorName%
			{
				IfWinNotActive, % "ahk_id " ew_ProcList%A_Index%
				{
					WinGetClass, ew_EditorClass, % "ahk_id " ew_ProcList%A_Index%
					If ew_EditorClass <>
					{
						IfWinNotActive, ahk_class %ew_EditorClass%
						{
							WinGetPos, ,,ew_EditorW, ew_EditorH, ahk_class %ew_EditorClass%
							If (ew_EditorW < 1 AND ew_EditorH < 1)
								Continue
							WinWaitActive, ahk_class %ew_EditorClass%,,0.5
							If ErrorLevel
							{
								WinActivate, ahk_class %ew_EditorClass%
								WinWaitActive, ahk_class %ew_EditorClass%,,0.5
							}
						}
					}
				}
			}
		}
	}
Return

ew_sub_Browse:
	Gui +OwnDialogs
	Fileselectfile, ew_EditorTmp, 3,,,%lng_ew_FileType%
	If ew_EditorTmp <>
		GuiControl,,ew_Editor, %ew_EditorTmp%
Return

ew_sub_SetDefault:
	ew_EditorTmp =
	GuiControl,,ew_Editor, %ew_EditorTmp%
Return
