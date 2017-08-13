; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               LikeDirkey
; -----------------------------------------------------------------------------
; Prefix:             ld_
; Version:            1.4
; Date:               2008-05-23
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_LikeDirkey:
	Prefix = ld
	%Prefix%_ScriptName    = LikeDirkey
	%Prefix%_ScriptVersion = 1.4
	%Prefix%_Author        = Wolfgang Reszel

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %ld_ScriptName% - Verzeichniskürzel`tStrg/Win 0-9
		Description                   = Verzeichniswechsel (Strg 0-9) oder neues Explorerfenster (Win 0-9) über Tastaturkürzel. Für den Verzeichniswechsel muss die Adressleiste im Explorer sichtbar sein.
		lng_ld_MenuNumPad             = Kürzel auf Ziffernblock
		lng_ld_MenuFolderTree         = Explorer mit Verzeichnisbaum öffnen
		lng_ld_NoDialog               = Das Setzen eines Verzeichnisses funktioniert nicht in Dialogen!
		lng_ld_SetDir                 = aktuelles Verzeichnis zuweisen
		lng_ld_Shortcut               = Kürzel
		lng_ld_Applied                = wurde neu belegt:
	}
	else        ; = other languages (english)
	{
		MenuName                      = %ld_ScriptName% - folder-hotkeys`tCtrl/Win 0-9
		Description                   = Change directory (Ctrl 0-9) or opens a new window (Win 0-9) with hotkeys. The addressbar has to be visible to change the directory.
		lng_ld_MenuNumPad             = use Numpad
		lng_ld_MenuFolderTree         = open Explorer with folder tree
		lng_ld_NoDialog               = assigning a folder doesn't work in dialogs!
		lng_ld_SetDir                 = set current directory
		lng_ld_Shortcut               = Shortcut
		lng_ld_Applied                = has a new destination:
	}
	If CustomLanguage <>
		gosub, CustomLanguage

	IniRead, ld_onNumPad, %ConfigFile%, %ld_ScriptName%, NumPad, 1

	If ld_onNumPad = 1
		ld_NumPadPrefix = Numpad

	IniRead, ld_FolderTree, %ConfigFile%, %ld_ScriptName%, FolderTree, 0

	IconFile_On_LikeDirkey = %A_WinDir%\system32\shell32.dll
	IconPos_On_LikeDirkey = 209

	; Belegung aus Datei einlesen
	Loop, 10
	{
		ld_Index := A_Index - 1
		IniRead, ld_Folder[%ld_Index%], %ConfigFile%, %ld_ScriptName%, Folder[%ld_Index%]
	}

	if (ld_Folder[0] = "ERROR" AND ld_Folder[1] = "ERROR") ; Wenn Definition nicht exisitert > Standardbelegung
	{
		ld_Folder[1] = C:\
		ld_Folder[2] = D:\
		ld_Folder[3] =
		ld_Folder[4] = `%A_Desktop`%
		ld_Folder[5] = HKEY_LOCAL_MACHINE,SOFTWARE\AutoHotkey,InstallDir
		ld_Folder[6] =
		ld_Folder[7] =
		ld_Folder[8] =
		ld_Folder[9] = `%A_Programfiles`%
		ld_Folder[0] = `%A_ScriptDir`%
	}

	; Alle 10 Strings aus Pseudo-Array mit Kürzeln belegen
	Loop, 10
	{
		ld_Index :=  A_Index -1
		ld_current := ld_Folder[%ld_Index%] ; Pfad auslesen

		ld_KeyName = %ld_NumPadPrefix%%ld_Index%

		func_HotkeyRead( "ld_HotkeyChange" ld_Index, ConfigFile, ld_ScriptName, "HotkeyChange" ld_Index, "ld_main_LikeDirkey_call", "^" ld_KeyName, "", ChangeDirClasses)
		func_HotkeyRead( "ld_HotkeyOpen" ld_Index, ConfigFile, ld_ScriptName, "HotkeyOpen" ld_Index, "ld_main_LikeDirkey_call", "#" ld_KeyName, "" )
		func_HotkeyRead( "ld_HotkeySet" ld_Index, ConfigFile, ld_ScriptName, "HotkeySet" ld_Index, "ld_main_LikeDirkey_set", "^#" ld_KeyName, "", ChangeDirClasses)
	}
Return

SettingsGui_LikeDirkey:
	Gui, Add, CheckBox, -Wrap XS+10 ys+15 vld_onNumPad gsub_FakeHotkeyButton Checked%ld_onNumPad%, %lng_ld_MenuNumPad%
	Gui, Add, CheckBox, -Wrap XS+10 y+5 vld_FolderTree gsub_CheckIfSettingsChanged Checked%ld_FolderTree%, %lng_ld_MenuFolderTree%

	Loop, 10
	{
		ld_Index :=  A_Index-1
		ld_current := ld_Folder[%ld_Index%] ; Pfad auslesen

		If ld_NumPadPrefix =
			ld_KeyName = Win+&%ld_Index%
		Else
			ld_KeyName = Win+Num&%ld_Index%

		If ld_Index = 0
		{
			ld_0 = %ld_current%
			ld_0key = %ld_KeyName%
		}
		Else
		{
			If A_Index = 2
				Gui, Add, Text, XS+10 YP+20 w60 vld_KeyNameLabel%ld_Index%, %ld_KeyName%:
			Else
				Gui, Add, Text, XS+10 YP+25 w60 vld_KeyNameLabel%ld_Index%, %ld_KeyName%:
			Gui, Add, Edit, gsub_CheckIfSettingsChanged X+5 YP-2 W443 R1 vld_Folder[%ld_Index%], %ld_current%
			Gui, Add, Button, x+4 h21 W24 vld_Folder_Browse[%ld_Index%] gld_sub_Browse, ...
		}

		func_HotkeyAddGuiControl( ld_Current, "ld_HotkeyOpen" ld_Index, "y+10", "", "", 1 )
		func_HotkeyAddGuiControl( ld_Current, "ld_HotkeyChange" ld_Index, "", "", "", 1 )
	}
	func_CreateListOfHotkeys( "", "<SEPARATOR>", "LikeDirkey", "<SEPARATOR>" )
	Loop, 10
	{
		func_HotkeyAddGuiControl( "", "ld_HotkeySet" A_Index-1, "", "", "", 1 )
	}

	Gui, Add, Text, XS+10 YP+25 w60 vld_KeyNameLabel0, %ld_0key%:
	Gui, Add, Edit, gsub_CheckIfSettingsChanged X+5 YP-2 W443 vld_Folder[0], %ld_0%
	Gui, Add, Button, -Wrap x+4 h21 W24 vld_Folder_Browse[0] gld_sub_Browse, ...
Return

ld_sub_Browse:
	Gui +OwnDialogs
	StringReplace, ld_Var, A_GuiControl, _Browse,
	GuiControlGet, ld_VarTmp,, %ld_Var%
	Transform, ld_VarTmp, Deref, %ld_VarTmp%
	FileselectFolder, ld_FileNew, *%ld_VarTmp%,0,%lng_ld_FileType%
	If ld_FileNew <>
		GuiControl,,%ld_Var%, %ld_FileNew%
Return

sub_FakeHotkeyButton:
	Gosub, sub_CheckIfSettingsChanged
	GuiControlGet, ld_onNumPad_tmp,,ld_onNumPad
	If ld_onNumPad_tmp = 1
		ld_NumPadPrefix_tmp = Numpad
	Else
		ld_NumPadPrefix_tmp =

	Loop, 10
	{
		ld_Index :=  A_Index-1
		ld_current := ld_Folder[%ld_Index%] ; Pfad auslesen

		ld_KeyName = %ld_NumPadPrefix_tmp%%ld_Index%

		VarHK = Hotkey_ld_HotkeyChange%ld_Index%
		GetKey = ^%ld_KeyName%
		Gosub, sub_HotkeyParseGetKey
		If HotkeyDup =
			GuiControl,, ld_onNumpad, % !(ld_onNumPad_tmp)
		VarHK = Hotkey_ld_HotkeyOpen%ld_Index%
		GetKey = #%ld_KeyName%
		Gosub, sub_HotkeyParseGetKey
		If HotkeyDup =
			GuiControl,, ld_onNumpad, % !(ld_onNumPad_tmp)
		VarHK = Hotkey_ld_HotkeySet%ld_Index%
		GetKey = ^#%ld_KeyName%
		Gosub, sub_HotkeyParseGetKey
		If HotkeyDup =
			GuiControl,, ld_onNumpad, % !(ld_onNumPad_tmp)
	}
Return

SaveSettings_LikeDirkey:
	Gosub, ld_sub_NumPad
	IniWrite, %ld_onNumPad%, %ConfigFile%, %ld_ScriptName%, NumPad
	IniWrite, %ld_FolderTree%, %ConfigFile%, %ld_ScriptName%, FolderTree

	Loop, 10
	{
		ld_Index :=  A_Index-1
		ld_current := ld_Folder[%ld_Index%] ; Pfad auslesen

		ld_KeyName = %ld_NumPadPrefix%%ld_Index%

;      VarHK = Hotkey_ld_HotkeyChange%ld_Index%
;      GetKey = ^%ld_KeyName%
;      Gosub, sub_HotkeyParseGetKey
;      VarHK = Hotkey_ld_HotkeyOpen%ld_Index%
;      GetKey = #%ld_KeyName%
;      Gosub, sub_HotkeyParseGetKey
;      VarHK = Hotkey_ld_HotkeySet%ld_Index%
;      GetKey = ^#%ld_KeyName%
;      Gosub, sub_HotkeyParseGetKey
;      Hotkey_ld_HotkeyChange%ld_Index%_new = ^%ld_KeyName%
;      Hotkey_ld_HotkeyOpen%ld_Index%_new = #%ld_KeyName%
;      Hotkey_ld_HotkeySet%ld_Index%_new = ^#%ld_KeyName%

		func_HotkeyWrite( "ld_HotkeyChange" ld_Index, ConfigFile, ld_ScriptName, "HotkeyChange" ld_Index, "ld_main_LikeDirkey_call", "", ChangeDirClasses )
		func_HotkeyWrite( "ld_HotkeyOpen" ld_Index, ConfigFile, ld_ScriptName, "HotkeyOpen" ld_Index, "ld_main_LikeDirkey_call", "" )
		func_HotkeyWrite( "ld_HotkeySet" ld_Index, ConfigFile, ld_ScriptName, "HotkeySet" ld_Index, "ld_main_LikeDirkey_set", "", ChangeDirClasses )

		IniWrite, % ld_Folder[%ld_Index%], %ConfigFile%, %ld_ScriptName%, Folder[%ld_Index%]

		If ld_NumPadPrefix =
			ld_KeyName = Win+&%ld_Index%
		Else
			ld_KeyName = Win+Num&%ld_Index%
		GuiControl,,ld_KeyNameLabel%ld_Index%, %ld_KeyName%:
	}
Return

CancelSettings_LikeDirkey:
Return

DoEnable_LikeDirkey:
	Loop, 10
	{
		ld_Index :=  A_Index-1
		ld_current := ld_Folder[%ld_Index%] ; Pfad auslesen

		ld_KeyName = %ld_NumPadPrefix%%ld_Index%

		If ld_current <> ; Wenn nicht leer
		{
			func_HotkeyEnable( "ld_HotkeyChange" ld_Index )
			func_HotkeyEnable( "ld_HotkeyOpen" ld_Index )
		}

		func_HotkeyEnable( "ld_HotkeySet" ld_Index )
	}
Return

DoDisable_LikeDirkey:
	Loop, 10
	{
		ld_Index :=  A_Index-1
		ld_current := ld_Folder[%ld_Index%] ; Pfad auslesen

		ld_KeyName = %ld_NumPadPrefix%%ld_Index%

		func_HotkeyDisable( "ld_HotkeySet" ld_Index )
		func_HotkeyDisable( "ld_HotkeyChange" ld_Index )
		func_HotkeyDisable( "ld_HotkeyOpen" ld_Index )

	}
Return

DefaultSettings_LikeDirkey:
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

; --- Unterroutine für Tastaturkürzel -----------------------------------------
ld_main_LikeDirkey_call:
	If Enable_LikeDirkey = 1
	{
		StringRight, ld_keyIndex, A_ThisHotkey, 1 ; Nur die Zahl des Kürzels
		If (Hotkey_ShowMainContextMenu = A_ThisHotkey OR CalledFrom = "sub_MainContextMenu")
			StringRight, ld_keyIndex, A_ThisMenuItem, 1 ; Nur die Zahl des Menüpunkts
		If CalledFrom = al_sub_SearchOK
		{
			ld_keyIndex := SubStr(al_FName,StrLen(al_FName)-1,1)
			;msgbox, %ld_keyIndex%`n%al_FName%
		}

		ld_path := ld_Folder[%ld_keyIndex%] ; Pfad auslesen

		If (func_StrLeft(ld_path,5) = "HKEY_" OR func_StrLeft(ld_path,6) = "#HKEY_")
		{
			StringSplit, ld_path, ld_path, `,
			StringReplace, ld_path1, ld_path1, #
			RegRead, ld_path, %ld_path1%,%ld_path2%,%ld_path3%
		}

		Transform, ld_Path, Deref, %ld_Path%

		GetKeyState, ld_ctrlState, Ctrl ; Status der Strg-Taste ermitteln

		Gosub, ld_sub_ChangeDir ; Verzeichniswechsel aufrufen
	}
Return

; --- Unterroutine für Tastaturkürzel-Belegung -------------------------------
ld_main_LikeDirkey_set:
	if Enable_LikeDirkey = 1
	{
		StringRight, ld_keyIndex, A_ThisHotkey, 1 ; Nur die Zahl des Kürzels
		If Hotkey_ShowMainContextMenu = %A_ThisHotkey%
			StringRight, ld_keyIndex, A_ThisMenuItem, 1 ; Nur die Zahl des Menüpunkts

		Gosub, ld_sub_SetDir ; Verzeichnis ermitteln

		If ld_path <>
		{
			Readme_Hotkeys =
			If (func_StrLeft(ld_Folder[%ld_keyIndex%],6) = "#HKEY_")
			{
				IfExist, %ld_path%
				{
					StringSplit, ld_Regpath, ld_Folder[%ld_keyIndex%], `,
					StringReplace, ld_Regpath1, ld_Regpath1, #
					RegWrite, REG_SZ, %ld_Regpath1%,%ld_Regpath2%,%ld_Regpath3%,%ld_path%
					ld_addToTip = `n%ld_Regpath1%\%ld_Regpath2%\%ld_Regpath3%
					SetTimer, ld_tim_ToolTip, 10
					Sleep,2500
					SetTimer, ld_tim_ToolTip, Off
					ToolTip
					ld_addToTip =
				}
			}
			Else IfExist, %ld_path%
			{
				ld_Folder[%ld_keyIndex%] = %ld_path%

				SetTimer, ld_tim_ToolTip, 10

				Loop, Parse, ChangeDirClasses, `,
				{
					Hotkey, IfWinActive, ahk_class %A_LoopField%
					Hotkey, ~^%ld_NumPadPrefix%%ld_keyIndex%, ld_main_LikeDirkey_call ; Strg+ Kürzel zuweisen
				}
				Hotkey, IfWinActive
				Hotkey, #%ld_NumPadPrefix%%ld_keyIndex% , ld_main_LikeDirkey_call ; Win+ Kürzel zuweisen


				Loop, 10
				{
					ld_Index := A_Index - 1
					IniWrite, % ld_Folder[%ld_Index%], %ConfigFile%, %ld_ScriptName%, Folder[%ld_Index%]
				}

				Sleep,2500

				SetTimer, ld_tim_ToolTip, Off

				ToolTip
			}
		}
	}
Return

; -----------------------------------------------------------------------------
ld_tim_ToolTip:
	ToolTip, %lng_ld_Shortcut% %ld_keyIndex% %lng_ld_Applied%`n%ld_path%%ld_addToTip%, 4,4
Return

; --- Unterroutine für den Verzeichniswechsel ---------------------------------
ld_sub_ChangeDir:
	If ld_ctrlState = D
		func_ChangeDir(ld_Path,0,ld_FolderTree)
	Else
		func_ChangeDir(ld_Path,1,ld_FolderTree)
Return

; --- Unterroutine zum Setzen eines neuen Verzeichnisses ----------------------
ld_sub_SetDir:
	ld_path =
	WinGet     , ld_activeWinID, ID, A             ; ID es aktiven Fensters
	WinGetClass, ld_activeClass, ahk_id %ld_activeWinID%  ; Fensterklasse ermitteln
	WinGetText, ld_activeWinText, ahk_id %ld_activeWinID%

	If ld_activeClass = #32770
	{
		MsgBox,16, %ld_ScriptName% %ld_ScriptVersion%, %lng_ld_NoDialog%
		Return
	}

	; Prüfen ob Fensterklasse unterstützt wird
	If ld_activeClass contains %ChangeDirClasses%
	{
		; Ermitteln ob ein Edit1-Control vorhanden ist (Eingabezeile)
		IfInString, ld_activeWinText, MSNTB_Window ; MSN-Toolbar?
			ld_EditClass = Edit2
		Else
			ld_EditClass = Edit1
		ControlGetPos, ld_Edit1Pos,,,, %ld_EditClass% , ahk_id %ld_activeWinID%
	}

	; Verzeichnis in Explorer-Fenstern wechseln
	If ld_activeClass in ExploreWClass,CabinetWClass,Progman
	{
		If ld_Edit1Pos <>
		{
			ld_CurrentExplorerDirectory := func_GetDir( ld_activeWinID, "ShowMessage", "Always", ld_ScriptName )

			Sleep,200

			If ld_CurrentExplorerDirectory =
				Return

			ld_path = %ld_CurrentExplorerDirectory%
			Return
		}
	}

	; Verzeichnis aus AcdSee auslesen
	Else if ld_activeClass = Afx:400000:0
	{
		If ld_Edit1Pos <>
		{
			ControlGetText, ld_path, Edit1, ahk_id %ld_activeWinID%
			Return
		}
	}
	; Verzeichnis aus FireFox auslesen
	Else if ld_activeClass = FileZilla Main Window
	{
		If ld_Edit1Pos <>
		{
			ControlGetText, ld_path, Edit1, ahk_id %ld_activeWinID%
			Return
		}
	}
Return

; --- Unterroutine für das NumPad-Menü ----------------------------------------
ld_sub_NumPad:
	Loop, 10
	{
		ld_Index :=  A_Index -1
		ld_current := ld_Folder[%ld_Index%] ; Pfad auslesen

		ld_KeyName = %ld_NumPadPrefix%%ld_Index%

		If ld_current <> ; Wenn nicht leer
		{
			Loop, Parse, ChangeDirClasses, `,
			{
				Hotkey, IfWinActive, ahk_class %A_LoopField%
				Hotkey, ~^%ld_KeyName%, ld_main_LikeDirkey_call, Off ; Strg+ Kürzel zuweisen
			}
			Hotkey, IfWinActive
			Hotkey, #%ld_KeyName% , ld_main_LikeDirkey_call, Off ; Win+ Kürzel zuweisen
			StringReplace, Hotkey_AllHotkeys, Hotkey_AllHotkeys, % "«<#" ld_KeyName " >»" ,, A
			StringReplace, Hotkey_AllHotkeys, Hotkey_AllHotkeys, % "«<^" ld_KeyName " ahk_class ExploreWClass>»" ,, A
		}
		Loop, Parse, ChangeDirClasses, `,
		{
			Hotkey, IfWinActive, ahk_class %A_LoopField%
			Hotkey, ~^#%ld_KeyName%, ld_main_LikeDirkey_set , Off ; Strg+Win+ Kürzel löschen
		}
		Hotkey, IfWinActive
		StringReplace, Hotkey_AllHotkeys, Hotkey_AllHotkeys, % "«<^#" ld_KeyName " ahk_class ExploreWClass>»" ,, A
	}


	If ld_onNumPad = 1
		ld_NumPadPrefix = Numpad
	Else
		ld_NumPadPrefix =

	Loop, 10
	{
		ld_Index :=  A_Index -1
		ld_current := ld_Folder[%ld_Index%] ; Pfad auslesen

		ld_KeyName = %ld_NumPadPrefix%%ld_Index%

		If ld_current <> ; Wenn nicht leer
		{
			Loop, Parse, ChangeDirClasses, `,
			{
				Hotkey, IfWinActive, ahk_class %A_LoopField%
				Hotkey, ~^%ld_KeyName%, ld_main_LikeDirkey_call, On ; Strg+ Kürzel zuweisen
			}
			Hotkey, IfWinActive
			Hotkey, #%ld_KeyName% , ld_main_LikeDirkey_call, On ; Win+ Kürzel zuweisen
			Hotkey_AllHotkeys := Hotkey_AllHotkeys "«<#" ld_KeyName " >»"
			Hotkey_Extension[LikeDirkey$1%ld_Index%] := "#" ld_KeyName
			Hotkey_Extensions := Hotkey_Extensions "LikeDirkey$1" ld_Index "|"
			Hotkey_AllHotkeys := Hotkey_AllHotkeys "«<^" ld_KeyName " ahk_class ExploreWClass>»"
			Hotkey_Extension[LikeDirkey$2%ld_Index%] := "^" ld_KeyName
			Hotkey_Extensions := Hotkey_Extensions "LikeDirkey$2" ld_Index "|"
		}
		Loop, Parse, ChangeDirClasses, `,
		{
			Hotkey, IfWinActive, ahk_class %A_LoopField%
			Hotkey, ~^#%ld_KeyName% , ld_main_LikeDirkey_set, On ; Strg+Win+ Kürzel zuweisen
		}
		Hotkey, IfWinActive
		Hotkey_AllHotkeys := Hotkey_AllHotkeys "«<^#" ld_KeyName " ahk_class ExploreWClass>»"
		Hotkey_Extension[LikeDirkey$3%ld_Index%] := "^#" ld_KeyName
		Hotkey_Extensions := Hotkey_Extensions "LikeDirkey$3" ld_Index "|"
	}
Return
