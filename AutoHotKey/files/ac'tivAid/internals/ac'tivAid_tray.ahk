; Menüpunkt für jede eingebundenen Funktionen erstellen
Loop
{
	actFunct := Extension[%A_Index%]
	actEnable = Enable_%actFunct%
	actHideGui = HideInGui_%actFunct%
	actEnableTray = EnableTray_%actFunct%

	If actFunct =
		Break

	If ExtensionLoadingTime[%actFunct%] <>
	{
		ExtensionConflictDuplicates++
		ExtensionConflict++
	}

	ExtensionLoadingTime[%actFunct%] = %A_TickCount%

	IniRead, %actEnable%, %ConfigFile%, %ScriptName%, %actEnable%, 1
	If %actEnable% =
		%actEnable% = 1

	IniRead, %actHideGui%, %ConfigFile%, %ScriptName%, %actHideGui%, 0

	HideSettings = 0

	If IsLabel( "init_" actFunct )
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Initializing extension: " actFunct)
		Gosub, init_%actFunct%
	}
	Else
	{
		ifinstring, actFunct, QuickNote
			ExtensionMissingQuickNote++
		HideSettings = 1
		Enable_%actFunct% = 0
		EnableTray_%actFunct% = 0
		ExtensionConflict++
	}

	If HideSettings = 1
		EnableTray_%actFunct% = 0

	If (DisableIfCompiled_%actFunct% = 1 AND A_IsCompiled = 1)
		EnableTray_%actFunct% = 0

	If %actEnableTray% <> 0
	{
		IniRead, %actEnableTray%, %ConfigFile%, %ScriptName%, %actEnableTray%, 1
		If %actEnableTray% =
				%actEnableTray% = 1
	}

;   If HideInGui_%actFunct% = 1
;      %actEnableTray% = 0

	EnableTrayAll := EnableTrayAll %actEnableTray%

	EnableTray_%actFunct%_tmp := %actEnableTray%

	ExtensionCleanMenuName[%A_Index%] = %MenuName%

	If CustomHotkey_%actFunct% = 1
	{
		func_HotkeyRead( actFunct, ConfigFile, actFunct, "Hotkey_" actFunct, "sub_Hotkey_" actFunct, Hotkey_%actFunct%, HotkeyPrefix_%actFunct%, HotkeyClasses_%actFunct% )
		MenuName := MenuName "`t" func_HotkeyDecompose( Hotkey_%actFunct%, 1 )
	}

	If (CustomHotkey_%actFunct% <> 1 AND CustomHotkey_%actFunct% <> "")
	{
		CustomHotkeyVar := "Hotkey_" CustomHotkey_%actFunct%
		MenuName := MenuName "`t" func_HotkeyDecompose( %CustomHotkeyVar%, 1 )
	}

	ExtensionIndex[%actFunct%] = %A_Index%
	ExtensionPrefix[%A_Index%] = %Prefix%
	ExtensionPrefix[%actFunct%] = %Prefix%
	ExtensionMenuName[%A_Index%] = %MenuName%
	ExtensionMenuName[%actFunct%] = %MenuName%
	ExtensionHideSettings[%A_Index%] = %HideSettings%
	If HideInGui_%actFunct% = 1
		ExtensionHideSettings[%A_Index%] = 1
	Extension[%actFunct%] = 1
	ExtensionDescription[%actFunct%] = %Description%
	ExtensionVersion[%actFunct%] := %Prefix%_ScriptVersion

	If ExeDistribution = 1
		ExtensionsInExtDir = %ExtensionsInExtDir%%actFunct%|

;   registerAction( "EnableDisable_" actFunct, func_StrUpper(Prefix) ": " #(lng_EnableDisable2,actFunct), "sub_EnableDisable_Extension_action", actFunct)

	If IsLabel( "init_" actFunct )
	{
		ReadIcon(actFunct, IconFile_On_%actFunct%, IconPos_On_%actFunct%, IconFile_Off_%actFunct%, IconPos_Off_%actFunct%)
		If %actEnable% = 1
		{
			If CustomHotkey_%actFunct% = 1
				func_HotkeyEnable( actFunct )
			Gosub, DoEnable_%actFunct%
		}
		Else
		{
			If CustomHotkey_%actFunct% = 1
				func_HotkeyDisable( actFunct )
		}
		If HideInGui_%actFunct% = 1
		{
			HiddenInGui++
			Menu, RemovedExtensions, Add, %actFunct%, sub_RestoreExtToGUI
		}
		Gosub, sub_MenuCreate
		SubMenu =
	}
	NumFunctions = %A_Index%
	ExtensionLoadingTime[%actFunct%] := A_TickCount-ExtensionLoadingTime[%actFunct%]
}

If HiddenInGui =
{
	Menu, RemovedExtensions, Add, %lng_none%, sub_RestoreExtToGUI
	Menu, RemovedExtensions, Disable, %lng_none%
}

Menu, Tray, Delete, %lng_reload%
Menu, Tray, Delete, %lng_exit%

; Unterer Teil des Menüs mit 'deaktivieren' und 'beenden'.
If TrayExtensions <>
	Menu, Tray, Add
Else
	mi_trayNum--

Menu, Tray, Add, % lng_reload "`t" func_HotkeyDecompose( Hotkey_ReloadActivAid, 1 ), sub_MenuReload
Menu, Tray, Add, % lng_deactivate "`t" func_HotkeyDecompose( Hotkey_DisableEnable, 1 ), sub_MenuSuspend

if _useTrayMenuIcons = 1
{
	;mi_trayNum := mi_trayNum + 2
	MI_SetMenuItemIcon(hTM, mi_trayNum, TrayIcon[reload], TrayIconPos[reload], 16)
	MI_SetMenuItemIcon(hTM, mi_trayNum+1, TrayIcon[deactivate], TrayIconPos[deactivate], 16)
	mi_trayNum := mi_trayNum + 2
}

If _Debug = 1
{
	Menu, Tray, Add
	Menu, AHKMenu, Standard

	if _useTrayMenuIcons = 1
	{
		h_ahkTM := MI_GetMenuHandle("AHKMenu")

		MI_SetMenuStyle(h_ahkTM, 0x4000000)
		SplitPath, A_AhkPath,, SpyPath
		SpyPath = %SpyPath%\AU3_Spy.exe

		MI_SetMenuItemIcon(h_ahkTM, 1, A_AhkPath, 1, 16) ; open
		MI_SetMenuItemIcon(h_ahkTM, 2, A_WinDir "\hh.exe", 1, 16) ; help
		;-
		MI_SetMenuItemIcon(h_ahkTM, 4, SpyPath,   1, 16) ; spy
		MI_SetMenuItemIcon(h_ahkTM, 5, TrayIcon[reload], TrayIconPos[reload], 16)
		MI_SetMenuItemIcon(h_ahkTM, 6, A_AhkPath, 2, 16) ; edit
		;-
		MI_SetMenuItemIcon(h_ahkTM, 8, A_AhkPath, 3, 16) ; suspend
		MI_SetMenuItemIcon(h_ahkTM, 9, A_AhkPath, 4, 16) ; pause
		MI_SetMenuItemIcon(h_ahkTM, 10, TrayIcon[Exit], TrayIconPos[Exit], 16) ; exit

	}

	Menu, Tray, Add, AutoHotkey, :AHKMenu

	if _useTrayMenuIcons = 1
	{
		MI_SetMenuItemIcon(hTM, mi_trayNum+1, TrayIcon[Ahk], TrayIconPos[Ahk], 16)
		mi_trayNum := mi_trayNum + 2
	}
}
Menu, Tray, Add
Menu, Tray, Add, %lng_exit% , sub_MenuExit

if _useTrayMenuIcons = 1
{
	MI_SetMenuItemIcon(hTM, mi_trayNum+1, TrayIcon[Exit], TrayIconPos[Exit], 16)
	mi_trayNum := mi_trayNum + 1
}

; -----------------------------------------------------------------------------

If TrayClickOption = 1
	Menu, Tray, Default, % lng_Info "`t" func_HotkeyDecompose( Hotkey_MainGUI, 1 )
If TrayClickOption = 2
	Menu, Tray, Default, % lng_deactivate "`t" func_HotkeyDecompose( Hotkey_DisableEnable, 1 )
If TrayClickOption = 3
	Menu, Tray, Default, % lng_reload "`t" func_HotkeyDecompose( Hotkey_ReloadActivAid, 1 )
If TrayClickOption = 4
	Menu, Tray, Default, % lng_ShowHotkeyList "`t" func_HotkeyDecompose( Hotkey_ShowHotkeyList, 1 )
If TrayClickOption = 5
	Menu, Tray, Default, % lng_ShowMainContextMenu "`t" func_HotkeyDecompose( Hotkey_ShowMainContextMenu, 1 )
If (TrayClickOption >= 6 )
	Menu, Tray, Default, %TrayClickOptionText%

AutoTrim, Off


func_AutoVSplitMenu(MenuName)
{
	Global aa_osversionnumber, aa_osversionnumber_vista, MenuBarHeight, WorkAreaHeight, _useTrayMenuIcons, hTM
	TrayMenuHandle := GetMenuHandle(MenuName)

	TrayMenuItemCount := DllCall("GetMenuItemCount","uint",TrayMenuHandle)

	If (aa_osversionnumber >= aa_osversionnumber_vista)
		MenuItemHeight := MenuBarHeight+1
	Else
		MenuItemHeight := MenuBarHeight-2
	TrayMenuBreak := TrayMenuItemCount
	If MenuItemHeight*TrayMenuItemCount > WorkAreaHeight
	{
		if (_useTrayMenuIcons = 1 && A_OSVersion != "WIN_VISTA")
			MI_SetMenuStyle(hTM, 0x10000000)

		TrayMenuBreak := TrayMenuItemCount/2
		VarSetCapacity(mii,48,0)
		NumPut(48,mii)
		NumPut(0x10,mii,4) ; fMask = MIIM_TYPE
		NumPut(0x160,mii,8) ; fType = RGB_VERTICALBARBREAK
		mlp := DllCall("InsertMenuItem","uint",TrayMenuHandle,"uint",TrayMenuBreak,"uint",1,"uint",&mii)
	}
	Return TrayMenuBreak
}

sub_trayClick(wParam, lParam)
{
	 global ; hTM, M_IsPaused, TrayRClickOption, TrayMClickOption, hook_TrayClick, TrayRClickOptionText, TrayMClickOptionText

	 if (lParam = 0x202) ; WM_LBUTTONUP
	 {

		IfWinActive, »Expose«
			msgbox, doh
		 ;  gosub, rex_Window_Activate
		return 0
	 }

	 if (lParam = 0x205) ; WM_RBUTTONUP
	 {
		If TrayRClickOption = 1
			gosub, sub_MainGUI
		If TrayRClickOption = 2
			gosub, sub_MenuSuspend
		If TrayRClickOption = 3
			gosub, sub_MenuReload
		If TrayRClickOption = 4
			gosub, sub_ShowHotkeyList
		If TrayRClickOption = 5
			gosub, sub_ShowMainContextMenu
		If TrayRClickOption = 6
			gosub, sub_MainContextMenuListLines
		If TrayRClickOption = 7
			gosub, sub_MainContextMenuListVars
		If TrayRClickOption = 8
			gosub, sub_MainContextMenuListHotkeys
		If TrayRClickOption = 9
			gosub, sub_MainContextMenuKeyHistory
		If TrayRClickOption = 10
			gosub, sub_MainContextMenuWindowSpy
		If TrayRClickOption = 11
			gosub, sub_MainContextMenuMainContext

		return 0
	 }

	 if (lParam = 0x208) ; WM_MBUTTONUP
	 {
		If TrayMClickOption = 1
			gosub, sub_MainGUI
		If TrayMClickOption = 2
			gosub, sub_MenuSuspend
		If TrayMClickOption = 3
			gosub, sub_MenuReload
		If TrayMClickOption = 4
			gosub, sub_ShowHotkeyList
		If TrayMClickOption = 5
			gosub, sub_ShowMainContextMenu
		If TrayMClickOption = 6
			gosub, sub_MainContextMenuListLines
		If TrayMClickOption = 7
			gosub, sub_MainContextMenuListVars
		If TrayMClickOption = 8
			gosub, sub_MainContextMenuListHotkeys
		If TrayMClickOption = 9
			gosub, sub_MainContextMenuKeyHistory
		If TrayMClickOption = 10
			gosub, sub_MainContextMenuWindowSpy
		If TrayMClickOption = 11
			gosub, sub_MainContextMenuMainContext

		Loop, Parse, hook_TrayClick, |
		{
			If A_LoopField =
				continue

			If (TrayMClickOptionText = lng_TrayClick_%A_LoopField%)
				gosub, TrayClick_%A_LoopField%
		}

		return 0
	 }
}
