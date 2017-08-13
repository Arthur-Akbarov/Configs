; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               LikeDirkey-Menu
; -----------------------------------------------------------------------------
; Prefix:             ldm_
; Version:            0.5
; Date:               2007-01-18
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_LikeDirkeyMenu:
	Prefix = ldm
	%Prefix%_ScriptName    = LikeDirkeyMenu
	%Prefix%_ScriptVersion = 0.5
	%Prefix%_Author        = Wolfgang Reszel
	RequireExtensions = LikeDirkey

	CustomHotkey_LikeDirkeyMenu = ldm_Hotkey    ; Benutzerdefiniertes Hotkey mit eigener GUI

	IconFile_On_LikeDirkeyMenu = %A_WinDir%\system32\shell32.dll
	IconPos_On_LikeDirkeyMenu = 209

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		Description                   = Erweitert LikeDirkey um ein Menü, welches über ein Tastaturkürzel zu erreichen ist.
	}
	else        ; = other languages (english)
	{
		Description                   = Extends LikeDirkey with a context-menu.
	}
	If CustomLanguage <>
		gosub, CustomLanguage

	tooltip_Enable_LikeDirkeyMenu = %lng_EnableDisable%

	HideSettings = 1
	OnTab_LikeDirkey = %OnTab_LikeDirkey%|LikeDirkeyMenu

	func_HotkeyRead( "ldm_Hotkey", ConfigFile , "LikeDirkey", "LikeDirkeyMenu_Hotkey", "ldm_sub_Hotkey", "#NumpadAdd" )

	IniRead, Enable_LikeDirkeyMenu, %ConfigFile%, LikeDirkey, LikeDirkeyMenu
Return

SettingsGui_LikeDirkeyMenu:
	Gui, Tab, LikeDirkey
	Gui, Add, Groupbox, XS+230 YS+3 W320 H47
	Gui, Add, Checkbox, -Wrap gsub_CheckIfSettingsChanged XS+235 YS+12 vEnable_LikeDirkeyMenu Checked%Enable_LikeDirkeyMenu%, %lng_Extension%: %ldm_ScriptName%
	func_HotkeyAddGuiControl( "", "ldm_Hotkey", "y+1 w300" )
Return

SaveSettings_LikeDirkeyMenu:
	func_HotkeyWrite( "ldm_Hotkey", ConfigFile , "LikeDirkey", "LikeDirkeyMenu_Hotkey" )
	IniWrite, %Enable_LikeDirkeyMenu%, %ConfigFile%, LikeDirkey, LikeDirkeyMenu
Return

CancelSettings_LikeDirkeyMenu:
Return

DoEnable_LikeDirkeyMenu:
	If Hotkey_ldm_Hotkey =
		return
	Hotkey, %Hotkey_ldm_Hotkey%, On
Return

DoDisable_LikeDirkeyMenu:
	If Hotkey_ldm_Hotkey =
		return
	Hotkey, %Hotkey_ldm_Hotkey%, Off
Return

DefaultSettings_LikeDirkeyMenu:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

ldm_sub_Hotkey:
	If Enable_LikeDirkeyMenu = 1
		Gosub, ldm_main_LikeDirkeyMenu
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

ldm_main_LikeDirkeyMenu:
	Menu, LikeDirkeyMenu, Add, %ld_ScriptName%, ldm_sub_MenuItem
	Menu, LikeDirkeyMenu, Disable, %ld_ScriptName%
	Menu, LikeDirkeyMenu, Add
	Loop, 10
	{
		ldm_Index :=  A_Index-1
		ldm_current := ld_Folder[%ldm_Index%] ; Pfad auslesen

		StringLeft, ldm_check, ldm_current, 5

		If ldm_check = HKEY_
		{
			StringSplit, ldm_current, ldm_current, `,
			RegRead, ldm_current, %ldm_current1%,%ldm_current2%,%ldm_current3%
		}

		StringLeft, ldm_check, ldm_current, 1

		If ldm_check = `%
		{
			StringReplace, ldm_current, ldm_current, `% ,, A
			ldm_current := %ldm_current%
		}

		StringReplace, ld_current, ld_current, &, &&, a

		SplitPath, ldm_current, ldm_currentFileName, ldm_currentDir,,, ldm_currentDrive
		SplitPath, ldm_currentDir, ldm_currentParentDir
		StringSplit, ldm_dirs, ldm_currentDir, \

		StringLen, ldm_len, ldm_current

		If ldm_len > 40
			ldm_current = %ldm_currentDrive%\%ldm_dirs2%\...\%ldm_currentParentDir%\%ldm_currentFileName%

		If ld_NumPadPrefix =
			ldm_KeyName = Win+%ldm_Index%
		Else
			ldm_KeyName = Win+%ld_NumPadPrefix%+&%ldm_Index%

		If ldm_current <> ; Wenn nicht leer
		{
			If ldm_Index = 0
			{
				ldm_0 = %ldm_current%`t%ldm_KeyName%
			}
			Else
				Menu, LikeDirkeyMenu, Add, %ldm_current%`t%ldm_KeyName% , ldm_sub_MenuItem
		}
	}
	If ldm_0 <>
		Menu, LikeDirkeyMenu, Add, %ldm_0% , ldm_sub_MenuItem

	WinGet, ldm_WinID, ID, A
	Menu, LikeDirkeyMenu, Show
	WinActivate, ahk_id %ldm_WinID%
	Menu, LikeDirkeyMenu, DeleteAll
Return

ldm_sub_MenuItem:
	StringRight,ldm_keyIndex,A_ThisMenuItem,1

	ld_path := ld_Folder[%ldm_keyIndex%] ; Pfad auslesen

	StringLeft, ldm_check, ld_path, 5

	If ldm_check = HKEY_
	{
		StringSplit, ld_path, ld_path, `,
		RegRead, ld_path, %ld_path1%,%ld_path2%,%ld_path3%
	}

	StringLeft, ldm_check, ld_path, 1

	If ldm_check = `%
	{
		StringReplace, ld_path, ld_path, `% ,, A
		ld_path := %ld_path%
	}

	Menu, LikeDirkeyMenu, DeleteAll

	WinActivate, ahk_id %ldm_WinID%
	WinWaitActive, ahk_id %ldm_WinID%
	; Verzeichniswechsel aufrufen
	func_ChangeDir(ld_Path,-1,ld_FolderTree)
Return
