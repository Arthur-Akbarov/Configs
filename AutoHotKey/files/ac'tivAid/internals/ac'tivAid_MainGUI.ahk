sub_MainGui()
{
	Global

	Critical
	Thread NoTimers

	MainGuiBuildTime = %A_TickCount%

	Readme_Hotkeys =

	Hotkey_AllDuplicates_Backup = %Hotkey_AllDuplicates%

	If (MainGuiVisible <> "")
	{
		If DontShowMainGUI <>
		{
			Gosub, activAidGuiClose
			DontShowMainGUI =
			Gosub, sub_MainGUI
			Return
		}
		Else
		{
			DetectHiddenWindows, On
			IfWinExist, ahk_id %mainGuiID%
			{
				IfWinNotActive, ahk_id %mainGuiID%
					WinActivate, ahk_id %mainGuiID%
				Return
			}
		}
	}

	If mainGuiID <>
		Return

	mainGuiID := GuiDefault("activAid")

	Critical, Off

	IniRead, MainGuiX, %ConfigFile%, %ScriptName%, MainGuiX
	IniRead, MainGuiY, %ConfigFile%, %ScriptName%, MainGuiY

	If MainGuiX = ERROR
		MainGuiX =
	Else
	{
		If (MainGuiX < MonitorAreaLeft)
			MainGuiX := MonitorAreaLeft
		If (MainGuiX+706+BorderHeight*2 > MonitorAreaRight)
			MainGuiX := MonitorAreaRight-(706+BorderHeight*2)
		MainGuiX = x%MainGuiX%
	}
	If MainGuiY = ERROR
		MainGuiY =
	Else
	{
		If (MainGuiY < MonitorAreaTop)
			MainGuiY := MonitorAreaTop
		If (MainGuiY+450+MenuBarHeight+BorderHeight*2+CaptionHeight > MonitorAreaBottom)
			MainGuiY := MonitorAreaBottom-(450+MenuBarHeight+BorderHeight*2+CaptionHeight)
		MainGuiY = y%MainGuiY%
	}

	CallHook("MainGui","Init")

	Debug("GUI", A_LineNumber, A_LineFile, "Creating main GUI (" mainGuiID ")" )

	Hotkey_AllNewHotkeys = %Hotkey_AllHotkeys%

	If SimpleMainGUI =
	{
		If ( FileExist( ReadMeFile ) contains "A" )
			Gosub, sub_GetReadme
		If ( FileExist( ChangeLogFile ) contains "A" )
			Gosub, sub_GetChangeLog

		If (updScriptVersion <> "ERROR" AND updScriptVersion <> "")
		{
			If (updScriptExtension <> "ERROR" AND updScriptExtension <> "")
				Changelog = =============================================================================`n  %lng_UpdateSuccess%`n`n  %lng_UpdateNewExtension%`n  %updScriptExtension%`n=============================================================================`n`n%Changelog%
			Else
				Changelog = =============================================================================`n  %lng_UpdateSuccess%`n=============================================================================`n`n%Changelog%
		}

		CreateHotKeyList_tmp = %CreateHotKeyList%
		CreateHotkeyList = 1
	}

	If DontShowMainGUI =
		Menu, Tray, ToggleEnable, % lng_Info "`t" func_HotkeyDecompose( Hotkey_MainGUI, 1 )

	Reload = 0
	IniWrite, 1, %ConfigFile%, %ScriptName%, ShowGUI

	If LoadingFinished <> 1
		Debug("GUI", A_LineNumber, A_LineFile, "waiting for loading finished ..." )
	Loop
	{
		If LoadingFinished = 1
			break
		Sleep, 100
	}

	If DontShowMainGUI <> 1
		MainGuiVisible = 1

	IniRead, AutoUpdate, %ConfigFile%, %ScriptName%, AutoUpdate

	Loop
	{
		Function := Extension[%A_Index%]
		If Function =
			Break

		If ExtensionGuiDrawn[%Function%] =
			ExtensionGuiDrawn[%Function%] = 0

		Debug("VAR", A_LineNumber, A_LineFile, "Function" )

		Prefix := ExtensionPrefix[%A_Index%]

		If (SimpleMainGUI <> "" AND Function <> SimpleMainGUI)
			Continue

		If (ExtensionHideSettings[%A_Index%] <> 1 OR SimpleMainGUI = Function)
		{
			If %Prefix%_AdditionalSettings
				RestoreAdditionalTmpSettings( Prefix )
		}
	}

	Debug("GUI", A_LineNumber, A_LineFile, "Creating GUI-Menu" )
	Gosub, sub_SettingsMenu

	Menu, MenuBar, Add, &%ScriptName%, :SettingsMenu_activAid
	Menu, MenuBar, Add, &%lng_Extension%, :SettingsMenu_Extension
	Menu, MenuBar, Add, &%lng_Help%, :SettingsMenu_Help
	If _Devel = 1
	{
		Menu, MenuBar, Add, &Devel, :Devel_Menu
	}
	Gui, Menu, MenuBar

	Gosub, sub_BigIcon

	Gui, %GuiID_activAid%:+Disabled
	If DontShowMainGUI =
	{
		; ImageList erstellen
		If _ShowIconsInOptionsListBox = 1
		{
			InstalledExtension_ImageList := IL_Create(NumFunctions)

			IL_Count := 0
			Loop, %NumFunctions%
			{
				actFunct := Extension[%A_Index%]
				IL_Count++
				ImageList[%actFunct%] := IL_Count
				If Enable_%actFunct% = 1
				{
					IfNotExist, % TrayIcon[%actFunct%]
					{
						ImageList[%actFunct%] := 0
						IL_Count--
						continue
					}
					hIcon := ExtractIcon(TrayIcon[%actFunct%], TrayIconPos[%actFunct%], 16)
				}
				Else
				{
					IfNotExist, % TrayIconOff[%actFunct%]
					{
						ImageList[%actFunct%] := 0
						IL_Count--
						continue
					}
					hIcon := ExtractIcon(TrayIconOff[%actFunct%], TrayIconOffPos[%actFunct%], 16)
				}

				DllCall("ImageList_ReplaceIcon", "uint", InstalledExtension_ImageList, "int", -1, "uint", hIcon)
				DllCall("DestroyIcon", "uint", hIcon)
			}
		}

		If _AlternativeTrayMenu <> 1
		{
			Loop, % TrayMenu - TrayMenuFirstExtension
			{
				Index := A_Index + TrayMenuFirstExtension
				If TrayMenuName[%Index%] =
					continue
				Menu, Tray, Disable, % TrayMenuName[%Index%]
			}
		}

		If SimpleMainGUI =
		{
			If (MainGuiX = "" OR MainGuiY = "")
				func_CenterCoordsOnActiveMonitor(MainGuiX,MainGuiY,726,450)
			Gui, Show, %MainGuiX% %MainGuiY% W726 H450, %ScriptTitle%
		}
		Else
		{
			If (MainGuiX = "" OR MainGuiY = "")
				func_CenterCoordsOnActiveMonitor(MainGuiX,MainGuiY,578,450)
			Gui, Show, %MainGuiX% %MainGuiY% W578 H450, %ScriptTitle%
		}
	}

	If SimpleMainGUI =
	{
		Debug("GUI", A_LineNumber, A_LineFile, "SimpleGUI setting copyright and status bar" )

		Gui, Add, Text, 0x1000 x0 y0 w726 h2
		Gui, Add, Picture, y12 x160 H32 W32 Icon%ScriptIcon#%, %ScriptIcon%
		Gui, Font, S%FontSize25% bold italic,Verdana
		Gui, Add, Text, x+10 yp-6 BackgroundTrans, ac'tivAid%A_Space%
		Gosub, GuiDefaultFont
		Gui, Font, italic, Verdana
		Gui, Add, Text, x+30 yp+6 , v%ScriptVersion% von der ac'tivAid Community für c't`n© 2008 Heise Zeitschriften Verlag GmbH && Co. KG
		Gosub, GuiDefaultFont
		Gui, Add, Text, 0x1000 BackgroundTrans x153 y7 w569 h42
		UserMode := lng_UserMode%main_IsAdmin%%UsingUserDir%%AHKonUSB%
		StringReplace, UserMode, UserMode, %lng_activate%,,
		Gui, Add, StatusBar, vStatusBar gsub_OpenActivaidDir
		If AHKonUSB = 1
			SB_SetParts(480)
		Else
			SB_SetParts(540)
		SB_SetText( " " A_WorkingDir, 1)
		SB_SetText( " " UserMode, 2)
	}
	Else
	{
		Debug("GUI", A_LineNumber, A_LineFile, "setting copyright and status bar" )
		Gui, Add, Text, 0x1000 x0 y0 w726 h2
		Gui, Add, Picture, y12 x12 H32 W32 Icon%ScriptIcon#%, %ScriptIcon%
		Gui, Font, S%FontSize25% bold italic,Arial
		Gui, Font, S%FontSize25% bold italic,Verdana
		Gui, Add, Text, x+10 yp-2 BackgroundTrans, ac'tivAid%A_Space%
		Gosub, GuiDefaultFont
		Gui, Font, italic, Verdana
		Gui, Add, Text, x+30 yp+6 , v%ScriptVersion% von der ac'tivAid Community für c't`n© 2008 Heise Zeitschriften Verlag GmbH && Co. KG
		Gui, Add, Text, 0x1000 BackgroundTrans x5 y7 w569 h42
		Gosub, GuiDefaultFont
		UserMode := lng_UserMode%main_IsAdmin%%UsingUserDir%%AHKonUSB%
		StringReplace, UserMode, UserMode, %lng_activate%,,
		Gui, Add, StatusBar, vStatusBar gsub_OpenActivaidDir
		If AHKonUSB = 1
			SB_SetParts(352)
		Else
			SB_SetParts(412)
		SB_SetText( " " A_WorkingDir, 1)
		SB_SetText( " " UserMode, 2)
	}

	WinGetPos, GuiSplashX, GuiSplashY, GuiSplashW, GuiSplashH, ahk_id %MainGuiID%

	GuiSplashX := GuiSplashX+(GuiSplashW-400)/2-BorderHeight*2
	GuiSplashW := 400
	GuiSplashY := GuiSplashY+225

	Function = %ScriptNameFull%

	Gosub, sub_temporarySuspend
	If Extension[1] <>
		IfExist extensions
			Exts = 1

	GuiTabs[%lng_Readme%]=1
	GuiTabs[1]=%lng_Readme%
	GuiTabs[%lng_Changelog%]=2
	GuiTabs[2]=%lng_Changelog%
	GuiTabs[%lng_Settings%]=4
	GuiTabs[4]=%lng_Settings%
	GuiTabs[%lng_Hotkeys%]=5
	GuiTabs[5]=%lng_Hotkeys%
	GuiTabs[%lng_ConnectionsTab%]=6
	GuiTabs[6]=%lng_ConnectionsTab%

	If A_IsCompiled = 1
	{
		OptionsListBox = %lng_Readme%||%lng_Changelog%|————————————————|%lng_Settings%|%lng_Hotkeys%|%lng_Connections%|——————————————
		GuiTabs = 8
	}
	Else
	{
		OptionsListBox = %lng_Readme%||%lng_Changelog%|————————————————|%lng_Settings%|%lng_Hotkeys%|%lng_Connections%|%lng_Extensions%|————————————————
		GuiTabs[%lng_Extensions%]=7
		GuiTabs[7]=%lng_Extensions%
		GuiTabs = 9
	}

	If A_OSversion = WIN_NT4
		StringReplace, OptionsListBox, OptionsListBox, —, --, All

	If SimpleMainGUI <>
	{
		Debug("GUI", A_LineNumber, A_LineFile, "SimpleGUI just create one tab" )

		GuiTabs = 1
		OptionsListBox = %SimpleMainGUI%
	}
	Else
	{
		Debug("GUI", A_LineNumber, A_LineFile, "creating tab-array" )
		Loop
		{
			Index := A_Index
			If Extension[%Index%] =
				break
			Function := Extension[%Index%]

			If (ExtensionHideSettings[%Index%] = 1 AND SimpleMainGUI <> Function)
				continue

			If (SimpleMainGUI <> "" AND Function <> SimpleMainGUI)
				continue

			OptionsListBox := OptionsListBox "|" Extension[%Index%]
			GuiTabs[%Function%] = %GuiTabs%
			GuiTabs[%GuiTabs%] = %Function%
			GuiTabs++
		}
	}

	If SimpleMainGUI =
	{
		Gui, Add, ListView, vOptionsListBox ReadOnly AltSubmit X3 Y7 h420 w144 gsub_OptionsListBoxClick -Multi -Hdr,Extensions
		LV_ModifyCol(1,"123")
		If _ShowIconsInOptionsListBox = 1
			LV_SetImageList(InstalledExtension_ImageList,1)

		Loop, Parse, OptionsListBox, |
		{
			If A_LoopField =
				continue

			LoopField := func_StrClean(A_Loopfield)

			If (ImageList[%LoopField%] = "" AND TrayIcon[%LoopField%] <> "" AND _ShowIconsInOptionsListBox = 1)
			{
				If (aa_osversionnumber < aa_osversionnumber_vista)
					IL_Count++
				ImageList[%LoopField%] := IL_Count
				hIcon := ExtractIcon(TrayIcon[%LoopField%], TrayIconPos[%LoopField%], 16)
				DllCall("ImageList_ReplaceIcon", "uint", InstalledExtension_ImageList, "int", -1, "uint", hIcon)
				DllCall("DestroyIcon", "uint", hIcon)
				If (aa_osversionnumber >= aa_osversionnumber_vista)
					IL_Count++
			}
			LV_Add("Icon" ImageList[%LoopField%], A_LoopField)
		}
		LV_Modify(ListBox_Selected, "Select Focus")

		Gui, Add, GroupBox, Section X153 Y88 H287 W570 Disabled Hidden

		Gui, Add, Tab2,vDlgTabs Y0 X-1000 gsub_OptionsListCtrlTab, %OptionsListBox%

		If (MainGuiX = "" OR MainGuiY = "")
			func_CenterCoordsOnActiveMonitor(MainGuiX,MainGuiY,726,450)

		If DontShowMainGUI =
			Gui, Show, W726 H450 %MainGuiX% %MainGuiY%, %ScriptTitle%

		Gui, %GuiID_activAid%:+Disabled

		Gui, Tab, % GuiTabs[%lng_Readme%]
		Gui, Add, Text, XS YS-23 gsub_DevCopyIndex, %lng_Chapter%
		Gui, Add, DropDownList, X+5 YP-4 W340 AltSubmit vReadmeChapter gsub_Chapter, %ReadmeDropDown%
		Gui, Add, Text, X+5 YP+4, %lng_Search%:
		Gui, Add, Edit, x+5 yp-4 w100 vsearchTermReadme gsub_ReadmeSearch
		Gui, Add, Button, -Wrap x+3 gsub_ReadmeSearch vsearchButtonReadme H21 W15, >
		Gui, Font, S%FontSize%, Courier New
		Gui, Font, S%FontSize%, Lucida Console
		Gui, Add, Edit, XS Y+5 Readonly 0x100 T100 H290 W570 -WantReturn vReadme gsub_CheckIfSettingsChanged, Readme
		Gosub, GuiDefaultFont
		Gui, Font, C00099 underline bold
		Gui, Add, Text, Y+5 gsub_CallFAQ center w570, %lng_FAQ%
		GuiControl, , Readme, %Readme%

		Gosub, GuiDefaultFont

		Gui, Tab, % GuiTabs[%lng_Changelog%]
		Gui, Add, Text, XS YS-23, %lng_Search%:
		Gui, Add, Edit, x+5 yp-4 w100 vsearchTermChangeLog gsub_ReadmeSearch
		Gui, Add, Button, -Wrap x+3 gsub_ReadmeSearch vsearchButtonChangelog H21 W15, >
		Gui, Font, S%FontSize%, Courier New
		Gui, Font, S%FontSize%, Lucida Console
		Gui, Add, Edit, XS Y+5 Readonly 0x100 T100 H290 W570 -WantReturn vChangelog gsub_CheckIfSettingsChanged, Changelog
		Gosub, GuiDefaultFont
		Gui, Font, C00099 underline bold
		Gui, Add, Text, Y+5 gsub_CallFAQ center w570, %lng_FAQ%
		GuiControl, , Changelog, %Changelog%

		Gosub, GuiDefaultFont

		Gui, Tab, % GuiTabs[%lng_Settings%]
		Gui, Add, GroupBox, X153 Y88 H287 W570 Disabled
		Gui, Add, Text, -Wrap XS+3 YS-17, %lng_SelectLanguage%:
		Gui, Add, DropDownList, -Wrap X+10 YP-3 w300 vselectedLanguage gsub_CheckIfSettingsChanged AltSubmit, %Languages%
		GuiControl, Choose, selectedLanguage, %actLanguage%

		IfExist %A_Startup%\%ScriptNameFull%.lnk
		{
			FileGetShortcut, %A_Startup%\%ScriptNameFull%.lnk,,,AutoStart
			IfInString, AutoStart, nosplash
				AutoStart = -1
			Else
				AutoStart = 1
		}
		Else
			AutoStart = 0

		If (AHKonUSB = "" OR AHKonlyPortable = 1)
			Gui, Add, CheckBox, XS+10 YS+11 vAutoStart gsub_CheckIfSettingsChanged -Wrap Check3 Checked%AutoStart%, %lng_Autostart%
		Else
			Gui, Add, CheckBox, XS+10 YS+11 Disabled vAutoStart -Wrap Checked%AutoStart%, %lng_Autostart%

		Gui, Add, CheckBox, XS+300 YP vShowFocusToolTips gsub_CheckIfSettingsChanged Checked%ShowFocusToolTips% -Wrap, %lng_ShowFocusToolTip%

		Gui, Add, GroupBox, XS+10 YS+29 W550 H103, Update
		if(lng_nightlyNoUpdate = "")
		{
			Gui, Add, Button, -Wrap XS+19 YP+18 W150 gsub_getUpdates, %lng_Update%
			Gui, Add, Button, -Wrap %DisabledIfNotAdmin% X+10 W130 gsub_getManualUpdates, %lng_ManualUpdate%
			If Betatester = 1
				Gui, Add, CheckBox, R1 XS+20 Y+5 vAutoUpdate w250 gsub_CheckIfSettingsChanged -Wrap Checked%AutoUpdate%, %lng_AutoCheckUpdtBeta%
			Else
				Gui, Add, CheckBox, R1 XS+20 Y+5 vAutoUpdate w250 gsub_CheckIfSettingsChanged -Wrap Checked%AutoUpdate%, %lng_AutoCheckUpdt%
			Gui, Add, CheckBox, -Wrap x+10 vDisableAutoUpdateOnSlowNetwork Checked%DisableAutoUpdateOnSlowNetwork% gsub_CheckIfSettingsChanged, %lng_DisableAutoUpdateOnSlowNetwork%
			Gui, Add, CheckBox, -Wrap XS+20 Y+5 vBetatester gsub_BetaMode Checked%Betatester%, %lng_Betatester%
			Gui, Add, CheckBox, -Wrap XS+20 y+5 vBackupOnUpdate Checked%BackupOnUpdate% gsub_CheckIfSettingsChanged, %lng_BackupOnUpdate%
			IfExist, %BackupDir%
				Gui, Add, Button, -Wrap X+5 h18 yp-2 w70 gsub_ShowBackupDir, %lng_Show%
		}
		else
			Gui, Add, Text, XS+20 YP+18, %lng_nightlyNoUpdate%

		Gui, Add, GroupBox, XS+10 YS+136 W550 H118, Tray
		Gui, Add, Text, XS+20 YP+18, %lng_TrayClick%:
		Gui, Add, DropDownList, xS+240 yp-3 w200 gsub_CheckIfSettingsChanged -Wrap AltSubmit vTrayClickOption, %lng_TrayClickOptions%
		GuiControl, Choose, TrayClickOption, %TrayClickOption%

		Gui, Add, Text, XS+20 Y+5, %lng_TrayRClick%:
		Gui, Add, DropDownList, xS+240 yp-3 w200 gsub_CheckIfSettingsChanged -Wrap AltSubmit vTrayRClickOption, %lng_TrayClickOptions%
		GuiControl, Choose, TrayRClickOption, %TrayRClickOption%

		Gui, Add, Text, XS+20 Y+5, %lng_TrayMClick%:
		Gui, Add, DropDownList, XS+240 yp-3 w200 gsub_CheckIfSettingsChanged -Wrap AltSubmit vTrayMClickOption, %lng_TrayClickOptions%
		GuiControl, Choose, TrayMClickOption, %TrayMClickOption%

		Gui, Add, CheckBox, XS+20 Y+5 w530 R2 vNoTrayIcon gsub_CheckIfSettingsChanged Checked%NoTrayIcon%, %lng_NoTrayIcon%

		CustomWorkingDirDisable =
		If MainDirNotWriteable <> 0
			CustomWorkingDirDisable = Disabled

		CustomWorkingDirTmp = %CustomWorkingDir%
		If CustomWorkingDirTmp =
			CustomWorkingDirTmp := A_WorkingDir
		CustomWorkingDirTmp := func_ReplaceWithCommonPathVariables(CustomWorkingDirTmp,"A_ScriptDir,")

		Gui, Add, Text, XS+10 Y+13 %CustomWorkingDirDisable%, %lng_CustomWorkingDir%:
		Gui, Add, Edit, X+5 YP-3 R1 W350 vCustomWorkingDirTmp gsub_CheckIfSettingsChanged %CustomWorkingDirDisable%, %CustomWorkingDirTmp%
		Gui, Add, Button, -Wrap X+5 YP-1 W100 %CustomWorkingDirDisable% gsub_CustomWorkingDirBrowse, %lng_Browse%

		If _AdditionalSettings
			Gui, Add, Button, -Wrap XS+445 YS+290 w124 h16 gsub_AdditionalSettingsMenu v_AdditionalSettingsMenu, %lng_AdditionalSettings% ...

		Gui, Add, Button, -Wrap XS+550 YS-25 h27 w18 vCH_activAid gsub_ContextHelp, ?

		Gui, Tab, % GuiTabs[%lng_Hotkeys%]
		Gui, Add, GroupBox, X153 Y88 H287 W570 Disabled
		Function = activAid

		func_HotkeyAddGuiControl( lng_MainGUI, "MainGUI", "xs+10 ys+20 W190")
		func_HotkeyAddGuiControl( lng_ProblemSolver, "ProblemSolver", "xs+10 y+4 W190")
		func_HotkeyAddGuiControl( lng_deactivate, "DisableEnable", "xs+10 y+4 W190")
		func_HotkeyAddGuiControl( lng_TempSuspend, "TempSuspend", "xs+10 y+4 W190")
		func_HotkeyAddGuiControl( lng_ShowHotkeyList, "ShowHotkeyList", "xs+10 y+4 W190")
		Gui, Add, CheckBox, xs+205 y+3 vHotkeyListAOT gsub_SettingsChangedForce -Wrap Checked%HotkeyListAOT%, %lng_HotkeyListAot%
		func_HotkeyAddGuiControl( lng_ShowMainContextMenu, "ShowMainContextMenu", "xs+10 y+10 W190")
		func_HotkeyAddGuiControl( lng_Reload, "ReloadActivAid", "xs+10 y+4 W190")

		Gui, Add, Button, -Wrap XS+550 YS-25 h27 w18 vCH_activAid2 gsub_ContextHelp, ?

		If A_IsCompiled <> 1
		{
			Gui, Tab, % GuiTabs[%lng_Extensions%]
			Gui, Add, GroupBox, X153 Y88 H287 W570 Disabled
			IfNotExist, settings\extensions_main_off.ini
			{
				Gui, Add, Button, -Wrap %DisabledIfNotAdmin% XS+10 YS-21 gsub_ExtensionsOff, %A_Space%%A_Space%%lng_ExtOff%%A_Space%%A_Space%
				Gosub, sub_ExtensionManager
			}
			Else IfExist, settings\extensions_main_off.ini
			{
				Gui, Add, Button, -Wrap %DisabledIfNotAdmin% XS+10 YS-21 gsub_ExtensionsOn, %A_Space%%A_Space%%lng_ExtOn%%A_Space%%A_Space%
			}
			Gui, Add, Picture, xs+536 ys-30 H32 W32 vExtensionGUIIcon_%Function% Icon91, %A_WinDir%\System32\shell32.dll
		}

		Gui, Tab, % GuiTabs[%lng_ConnectionsTab%]
		Gui, Add, GroupBox, X153 Y48 H327 W570 Disabled

		Gui, Add, GroupBox, xs+10 ys-30 w550 h100, %lng_GlobalProxySettings%


		; HTTP Proxy GUI
		Gui, Add, Text, xs+20 yp+42 w30, URL:
		Gui, Add, Edit, x+3 w380 yp-3 vlc_globalHttpProxyURL gsub_SettingsChangedForce, %lc_globalHttpProxyURL%

		Gui, Add, Text, x+25 yp+3 w30, Port:
		Gui, Add, Edit, x+3 yp-3 w50 vlc_globalHttpProxyPort gsub_SettingsChangedForce, %lc_globalHttpProxyPort%

		Gui, Add, Text, xs+20 y+10 w30, %lng_ProxyType%:

		lc_tmp_proxyHttpTypeChoices = HTTP|SOCKS4|SOCKS5|
		StringReplace, lc_tmp_proxyHttpTypeChoices, lc_tmp_proxyHttpTypeChoices, %lc_globalHttpProxyType%, %lc_globalHttpProxyType%|

		Gui, Add, DropDownList, x+3 yp-3 vlc_globalHttpProxyType w70 gsub_SettingsChangedForce, %lc_tmp_proxyHttpTypeChoices%

		Gui, Add, Text, x+25 yp+3 w50, %lng_Username%:
		Gui, Add, Edit, x+3 yp-3 w131 vlc_globalHttpProxyUser gsub_SettingsChangedForce, %lc_globalHttpProxyUser%

		Gui, Add, Text, x+25 yp+3 w50, %lng_Password%:
		Gui, Add, Edit, x+3 yp-3 w131 Password vlc_globalHttpProxyPass gsub_SettingsChangedForce, %lc_globalHttpProxyPass%

		; FTP Proxy GUI
		Gui, Add, Edit, xs+53 ys+9 w380 vlc_globalFtpProxyURL gsub_SettingsChangedForce, %lc_globalFtpProxyURL%
		Gui, Add, Edit, x+58 w50 vlc_globalFtpProxyPort gsub_SettingsChangedForce, %lc_globalFtpProxyPort%

		lc_tmp_proxyFtpTypeChoices = HTTP|SOCKS4|SOCKS5|
		StringReplace, lc_tmp_proxyFtpTypeChoices, lc_tmp_proxyFtpTypeChoices, %lc_globalFtpProxyType%, %lc_globalFtpProxyType%|
		Gui, Add, DropDownList, xs+53 y+7 vlc_globalFtpProxyType w70 gsub_SettingsChangedForce, %lc_tmp_proxyFtpTypeChoices%
		Gui, Add, Edit, x+78 w131 vlc_globalFtpProxyUser gsub_SettingsChangedForce, %lc_globalFtpProxyUser%
		Gui, Add, Edit, x+78 w131 Password vlc_globalFtpProxyPass gsub_SettingsChangedForce, %lc_globalFtpProxyPass%

		Gui, Add, GroupBox, xs+10 y+15 w550 h50, %lng_GlobalDownloadFolder%
		Gui, Add, Edit, xs+20 yp+20 w500 vlc_globalDownloadFolder gsub_SettingsChangedForce, %lc_globalDownloadFolder%
		Gui, Add, Button, x+5 yp-1 w30, ...

		Gui, Add, GroupBox, xs+10 y+10 w550 h150, %lng_ProxyHistory%

		Gui, Add, ListView, xs+20 yp+18 w535 h125, %lng_ProxyHistoryHeaders%
		LV_ModifyCol(1,205)
		LV_ModifyCol(2,205)
		LV_ModifyCol(3,50)
		LV_ModifyCol(4,50)

		Gui, Add, Radio, XS+20 YS-12 Group -Wrap vlc_gui_httpProxy w60 gsub_lc_proxyGui Checked, HTTP
		Gui, Add, Radio, x+0 -Wrap vlc_gui_ftpProxy gsub_lc_proxyGui, FTP

		Gui, Add, CheckBox, xs+135 ys-12 -Wrap vlc_useGlobalHttpProxy Checked%lc_useGlobalHttpProxy% gsub_lc_SettingsChangedForce, % #(lng_UseProxy,"HTTP")
		Gui, Add, CheckBox, xs+135 ys-12 -Wrap vlc_useGlobalFtpProxy Checked%lc_useGlobalFtpProxy% gsub_lc_SettingsChangedForce, % #(lng_UseProxy,"HTTP")
		gosub, sub_lc_proxyGui

		Function = activAid

		Gui, Add, Button, -Wrap XS+540 YS-22 h27 w18 vCH_activAid3 gsub_ContextHelp, ?

	}
	Else
	{
		Function = %SimpleMainGUI%
		GuiTabs[1] = %SimpleMainGUI%
		GuiTabs[%SimpleMainGUI%] = 1

;      Gosub, sub_OptionsListBox

		Gui, Add, GroupBox, Section X5 Y88 H287 W570 Hidden

		Gui, Add, Tab2,vDlgTabs Y0 X-1000, %OptionsListBox%

		If (MainGuiX = "" OR MainGuiY = "")
			func_CenterCoordsOnActiveMonitor(MainGuiX,MainGuiY,578,450)

		If DontShowMainGUI =
			Gui, Show, W578 H450 %MainGuiX% %MainGuiY%, %ScriptTitle%
	}

	Debug("GUI", A_LineNumber, A_LineFile, "Creating Tabs ..." )

	CreateHotKeyList = %CreateHotKeyList_tmp%

	NumOfExtensions = 0
	ProcessedExtensions =
	Loop
	{
		Function := Extension[%A_Index%]
		If Function =
			Break

		If (InStr(ProcessedExtensions, "|" Function "|") )
			Continue

		ExtensionGuiTime[%Function%] = %A_TickCount%

		NumOfExtensions++

		Prefix := ExtensionPrefix[%A_Index%]

		If (SimpleMainGUI <> "" AND Function <> SimpleMainGUI)
			Continue

		If (CreateHotKeyList = 1 OR Function = SimpleMainGUI)
			Gosub, sub_CreateExtensionConfigGui
	}
	GuiDefault("actvAid")

	If CreateHotKeyList = 1
		HotkeyListCreated = 1

	Gui, Tab
	Gosub, GuiDefaultFont

	If SimpleMainGUI =
	{
		Gui, Add, Button, -Wrap X280 Y400 W80 vMainGuiOK gsub_SettingsOK, %lng_OK%
		Gui, Add, Button, -Wrap X+5 W80 vMainGuiCancel gactivAidGuiClose, %lng_cancel%
		Gui, Add, Button, -Wrap X+20 Disabled W80 vMainGuiApply gsub_SettingsOK, %lng_Apply%
	}
	Else
	{
		Gui, Add, Button, -Wrap X168 Y400 W80 vMainGuiOK gsub_SettingsOK, %lng_OK%
		Gui, Add, Button, -Wrap X+5 W80 vMainGuiCancel gactivAidGuiClose, %lng_cancel%
		Gui, Add, Button, -Wrap X+20 Disabled W80 vMainGuiApply gsub_SettingsOK, %lng_Apply%
	}

;   Critical, Off

	If DontShowMainGUI = 1
	{
		DontShowMainGUI =
		MainGuiVisible =
		IniDelete, %ConfigFile%, %ScriptName%, ShowGUI
		Gui, Destroy
		mainGuiID =
	}
	Else
	{
		Debug("GUI", A_LineNumber, A_LineFile, "Registering GUI-Messages" )
		func_AddMessage(0x100,"sub_searchInReadme")
		func_AddMessage(0x101,"GuiTooltipKey")
		func_AddMessage(0x200, "GuiTooltip")
		func_AddMessage(0x202, "GuiTooltipKey")
		func_AddMessage(0x6, "RemoveGuiTooltip")
		Debug("GUI", A_LineNumber, A_LineFile, "Finished registering GUI-Messages" )
		SetTimer, tim_GuiFinished, -20
	}

	MainGuiBuildTime := A_TickCount-MainGuiBuildTime
	Debug("GUI", A_LineNumber, A_LineFile, "Finished creating GUI (" MainGuiBuildTime "ms)" )

	Critical, Off

	Gosub, sub_OptionsListBox
	Gui, %GuiID_activAid%:-Disabled

	GuiControl, Focus, OptionsListBox
	Send, {Right}

	If (updScriptVersion <> "ERROR" AND updScriptVersion <> "" AND Listbox_selected = 2 AND DontShowMainGUI = "")
	{
		GuiControl, Focus, ChangeLog
		Send, ^{Home}{Down}+{Down}
		updScriptVersion =
	}

	Gosub, sub_temporarySuspend

	Gosub, sub_ShowDuplicates

	IniRead, CustomWorkingDirTmp, %A_ScriptDir%\Settings\ac'tivAid.ini, activAid, CustomWorkingDir, %A_Space%
	If CustomWorkingDirTmp =
	{
		func_SettingsChanged("activAid")
		OnlyChangedWorkingDir = 1
	}

	If (ExtensionConflict <> "" AND SimpleMainGUI = "")
	{
		InstalledExtensionsBefore =
		func_SettingsChanged("activAid")
		If ExtensionConflictDuplicates <> ""
			MsgBox, 48, %ScriptTitle%, %lng_ExtensionConflictDuplicates%
		Else
			MsgBox, 48, %ScriptTitle%, %lng_ExtensionConflict%
		NoBackup = 1
		Gosub, sub_SettingsOK
	}

	GuiControl, MoveDraw, OptionsListBox, x3 y7

	MainGuiBuildTime := ""
}

sub_CreateExtensionConfigGui()
{
	Global

	Thread NoTimers
	If Function =
		Return

	GuiDefault("activAid")

	Debug("GUI", A_LineNumber, A_LineFile, "Creating Tab for: " Function )

	ExtensionIndex := ExtensionIndex[%Function%]

	Prefix := ExtensionPrefix[%ExtensionIndex%]

	If (SimpleMainGUI <> "" AND Function <> SimpleMainGUI)
		Return

	If ExtensionGuiDrawn[%Function%] = 1
		Return

	ExtensionGuiDrawn[%Function%] = 1

	Gui, %GuiID_activAid%:+Disabled

	BuildingGUI = %Prefix%_

	ProcessedExtensions = %ProcessedExtensions%|%Function%|

	If (ExtensionHideSettings[%ExtensionIndex%] <> 1 OR SimpleMainGUI=Function)
	{
		Gui, Tab, % GuiTabs[%Function%]

		If SimpleMainGUI =
			Gui, Add, GroupBox, X153 Y88 H287 W570 Disabled
		Else
			Gui, Add, GroupBox, X5 Y88 H287 W570 Disabled

		If (DisableIfCompiled_%Function% = 1 AND A_IsCompiled = 1)
			DisableIfCompiled = Disabled
		Else
			DisableIfCompiled =
		Enabled := Enable_%Function%
		EnableTray := EnableTray_%Function%
		Gui, Add, GroupBox, XS+0 YS-41 H43 W570
		IconIndent = 0
		If IconFile_On_%Function% <>
		{
			IconFile := TrayIcon[%Function%]
			IconPos := TrayIconPos[%Function%]
			IconIndent = 40
			Gui, Add, Picture, xp+512 yp+8 H32 W32 vExtensionGUIIcon_%Function% Icon%IconPos%, %IconFile%
		}
		Gui, Add, Button, -Wrap XS+550 YS-32 h31 w17 vCH_%Function% gsub_ContextHelp, ?
		If Enabled = 1
		{
			If OnlyForConfigDialog_%Function% <> 1
			{
				Gui, Add, Text, % "XS+" 30 " YP+2 W" 515-IconIndent " R2 vInfo_" Function, % Function " " ExtensionVersion[%Function%] " - " ExtensionDescription[%Function%]
				Gui, Add, Checkbox, % "XS+" 5 " YS-28 +E0x1 +0x8000 W20 H21 -Wrap vEnable_" Function " Checked" Enabled " gsub_ExtEnableDisable " DisableIfCompiled, %lng_activated%
			}
			Else
				Gui, Add, Text, % "XS+" 10 " YP+2 W" 515-IconIndent " R2 vInfo_" Function, % Function " " ExtensionVersion[%Function%] " - " ExtensionDescription[%Function%]
		}
		Else
		{
			If OnlyForConfigDialog_%Function% <> 1
			{
				Gui, Add, Text, % "XS+" 30 " YP+2 W" 515-IconIndent " R2 Disabled vInfo_" Function, % Function " " ExtensionVersion[%Function%] " - " ExtensionDescription[%Function%]
				Gui, Add, Checkbox, % "XS+" 5 " YS-28 +E0x1 +0x8000 W20 H21 -Wrap vEnable_" Function " Checked" Enabled " gsub_ExtEnableDisable " DisableIfCompiled, %lng_deactivated%
			}
			Else
				Gui, Add, Text, % "XS+" 10 " YP+2 W" 515-IconIndent " R2 Disabled vInfo_" Function, % Function " " ExtensionVersion[%Function%] " - " ExtensionDescription[%Function%]
		}
		tooltip_Enable_%Function% = %lng_EnableDisable%
		Gosub, GuiDefaultFont

		If OnlyForConfigDialog_%Function% <> 1
			Gui, Add, Checkbox, XS+10 YS+290 vEnableTray_%Function%_tmp gsub_CheckIfSettingsChanged_BackToList -Wrap Checked%EnableTray% %DisableIfCompiled%, %lng_ShowInTrayMenu%
		If %Prefix%_AdditionalSettings
			Gui, Add, Button, -Wrap XS+445 YS+290 w124 h16  gsub_AdditionalSettingsMenu v%Prefix%_AdditionalSettingsMenu, %lng_AdditionalSettings% ...

		Gui, Add, Picture, YS+1 h10

		If CustomHotkey_%Function% = 1
		{
			func_HotkeyAddGuiControl( lng_Hotkey, Function, "y+3 xs+10" )
		}
		If (IsLabel( "init_" Function ))
		{
			Gosub, SettingsGui_%Function%
		}
	}
	Else
	{
		RequireExtensions := FunctionRequireExt[%Function%]
		Loop, Parse, RequireExtensions, `,
		{
			If ((HideInGui_%A_LoopField% <> 1 AND RequireExtensions <> "") OR SimpleMainGUI = Function )
				If (IsLabel( "init_" Function ))
				{
					Gosub, SettingsGui_%Function%
				}
		}
	}

	Gosub, GuiDefaultFont
	ExtensionGuiTime[%Function%] := A_TickCount-ExtensionGuiTime[%Function%]
	Gui, -Disabled
	Sleep,0
	BuildingGUI =
}


activAidGuiClose()
{
	Global

	Critical
	Debug("GUI", A_LineNumber, A_LineFile, "Close/Escape GUI (" GetKey ", " InputMode ")" )

	GuiDefault("activAid")

	If (GetKey = "Escape" OR InputMode <> "")
	{
		GetKey =
		Return
	}

	If MainGUiVisible = 1
		Return

	MainGuiVisible =
	Hotkey_DupDuplicates =

	func_RemoveMessage(0x100,"sub_searchInReadme")

	Hotkey_AllNewHotkeys =
	IniWrite, %ListBox_selected%, %ConfigFile%, %ScriptName%, GUIselected

	If MainGuiX <> Reset
	{
		WinGet, MinMax, MinMax, ahk_id %MainGuiID%
		If MinMax <> -1
		{
			WinGetPos, MainGuiX, MainGuiY, MainGuiW, MainGuiH, ahk_id %MainGuiID%
			If (!func_CheckIfCoordsCentered(MainGuiX, MainGuiY, MainGuiW, MainGuiH))
			{
				IniWrite, %MainGuiX%, %ConfigFile%, %ScriptName%, MainGuiX
				IniWrite, %MainGuiY%, %ConfigFile%, %ScriptName%, MainGuiY
			}
		}
	}

	Gui, %GuiID_activAid%:Default

	Gui, Destroy
	mainGuiID =

	Loop
	{
		Function := Extension[%A_Index%]
		ExtensionGuiDrawn[%Function%] =
		If Function =
			Break

		If (SimpleMainGUI <> "" AND Function <> SimpleMainGUI)
			continue

		If (Enable_%Function% = 1 AND A_IsSuspended = 0)
		{
			Debug("EXTENSION", A_LineNumber, A_LineFile, "DoEnable_" Function "...")
			Gosub, DoEnable_%Function%
		}

		ChangedSettings[%Function%] =

		If IsLabel( "init_" Function )
		{
			Debug("GUI", A_LineNumber, A_LineFile, "CancelSettings_" Function )
			Gosub, CancelSettings_%Function%
		}
	}
	Menu, Tray, ToggleEnable, % lng_Info "`t" func_HotkeyDecompose( Hotkey_MainGUI, 1 )

	IniDelete, %ConfigFile%, %ScriptName%, ShowGUI

	Gosub, sub_ChangeIcon

	If A_IsSuspended = 1
		Gosub, sub_temporarySuspend

	SimpleMainGUI =

	Hotkey_AllDuplicates = %Hotkey_AllDuplicates_Backup%
	Gosub, DuplicatesGuiClose

	Loop, Parse, OptionsListBox, |
	{
		If A_LoopField =
			continue
		LoopField := func_StrClean(A_LoopField)
		ImageList[%LoopField%] =
	}

	Loop, Parse, hook_UnsetVarOnGuiClose, |
		%A_LoopField% := ""
	hook_UnsetVarOnGuiClose := ""

	func_RemoveMessage(0x200, "GuiTooltip")
	func_RemoveMessage(0x101, "GuiTooltipKey")
	func_RemoveMessage(0x202, "GuiTooltipKey")
	func_RemoveMessage(0x6, "RemoveGuiTooltip")

	Sleep, 0
}

sub_SettingsOK()
{
	Global

	Critical
	GuiDefault("activAid")

	Debug("GUI", A_LineNumber, A_LineFile, "Received OK or Apply button ..." )
	Gosub, sub_temporarySuspend
	Debug("GUI", A_LineNumber, A_LineFile, "Creating Backup of Config file ..." )
	If NoBackup =
		FileCopy, %ConfigFile%, %ConfigFile%.bak, 1

	func_RemoveMessage(0x100,"sub_searchInReadme")
	Debug("GUI", A_LineNumber, A_LineFile, "Message removed: 0x100,sub_searchInReadme" )

	DontReload = 1
	Loop
	{
		Function := Extension[%A_Index%]
		If Function =
			Break
		If ChangedSettings[%Function%] =
			continue
		Debug("EXTENSION", A_LineNumber, A_LineFile, "DoDisable_" Function "...")
		Gosub, DoDisable_%Function%
	}
	Debug("GUI", A_LineNumber, A_LineFile, "Reset Sound ..." )
	SoundPlay, Nonexistent.wav, wait
	DontReload = 0

	Hotkey_ProblemSolver_old2 = %Hotkey_ProblemSolver%
	Hotkey_MainGUI_old2 = %Hotkey_MainGUI%
	Hotkey_DisableEnable_old2 = %Hotkey_DisableEnable%
	Hotkey_TempSuspend_old2 = %Hotkey_TempSuspend%
	Hotkey_ShowHotkeyList_old2 = %Hotkey_ShowHotkeyList%
	Hotkey_ShowMainContextMenu_old2 = %Hotkey_ShowMainContextMenu%
	Hotkey_ReloadActivAid_old2 = %Hotkey_ReloadActivAid%

	Hotkey_ProblemSolver_old = %Hotkey_ProblemSolver%
	Hotkey_MainGUI_old = %Hotkey_MainGUI%
	Hotkey_DisableEnable_old = %Hotkey_DisableEnable%
	Hotkey_TempSuspend_old = %Hotkey_TempSuspend%
	Hotkey_ShowMainContextMenu_old = %Hotkey_ShowMainContextMenu%
	Hotkey_ReloadActivAid_old = %Hotkey_ReloadActivAid%

	_DebugLast = %_Debug%
	_DevelLast = %_Devel%

	If MainGuiX <> Reset
	{
		Debug("GUI", A_LineNumber, A_LineFile, "Reset Config window position" )
		WinGetPos, MainGuiX, MainGuiY, MainGuiW, , ahk_id %MainGuiID%
		IniWrite, %MainGuiX%, %ConfigFile%, %ScriptName%, MainGuiX
		IniWrite, %MainGuiY%, %ConfigFile%, %ScriptName%, MainGuiY

		GuiSplashX := MainGuiX+(MainGuiW-400)/2-BorderHeight*2
		GuiSplashY := MainGuiY+225
	}

	Debug("GUI", A_LineNumber, A_LineFile, "Submitting GUI fields to variables ..." )
	GuiDefault("activAid")
	Gui, Submit, NoHide

	IniWrite, %ListBox_selected%, %ConfigFile%, %ScriptName%, GUIselected

	Gui, %GuiID_activAid%:+Disabled

	Gosub, sub_EnableDisable_ApplyButton
	If SettingsChanged > 0
	{
		Readme_Hotkeys =
		HotkeyListCreated =
		Gui, %GuiID_HotkeyList%:+LastFoundExist
		IfWinExist
		{
			WinGetPos, ShowHotkeyListX , ShowHotkeyListY , ShowHotkeyListW, ShowHotkeyListH
			ShowHotkeyListW := ShowHotkeyListW - BorderHeight*2
			ShowHotkeyListH := ShowHotkeyListH - BorderHeight*2 - CaptionHeight
			Gui, %GuiID_HotkeyList%:Cancel
		}
	}

	ChangedSettings = 0

	If ChangedSettings[activAid] <>
	{
		Debug("SETTINGS", A_LineNumber, A_LineFile, "Writing Settings for: activAid ..." )

		SplashImage,,CWeeeeee b1 FS9 w%GuiSplashW% x%GuiSplashX% y%GuiSplashY%, %lng_WritingSettings%
		IniWrite, %lc_useGlobalHttpProxy%, %ConfigFile%, %ScriptName%, GlobalHttpProxyEnable
		IniWrite, %lc_globalHttpProxyType%, %ConfigFile%, %ScriptName%, GlobalHttpProxyType
		IniWrite, %lc_globalHttpProxyURL%, %ConfigFile%, %ScriptName%, GlobalHttpProxyURL
		IniWrite, %lc_globalHttpProxyPort%, %ConfigFile%, %ScriptName%, GlobalHttpProxyPort
		IniWrite, %lc_globalHttpProxyUser%, %ConfigFile%, %ScriptName%, GlobalHttpProxyUser
		IniWrite, %lc_globalHttpProxyPass%, %ConfigFile%, %ScriptName%, GlobalHttpProxyPass
		IniWrite, %lc_useGlobalFtpProxy%, %ConfigFile%, %ScriptName%, GlobalFtpProxyEnable
		IniWrite, %lc_globalFtpProxyType%, %ConfigFile%, %ScriptName%, GlobalFtpProxyType
		IniWrite, %lc_globalFtpProxyURL%, %ConfigFile%, %ScriptName%, GlobalFtpProxyURL
		IniWrite, %lc_globalFtpProxyPort%, %ConfigFile%, %ScriptName%, GlobalFtpProxyPort
		IniWrite, %lc_globalFtpProxyUser%, %ConfigFile%, %ScriptName%, GlobalFtpProxyUser
		IniWrite, %lc_globalFtpProxyPass%, %ConfigFile%, %ScriptName%, GlobalFtpProxyPass

		IniWrite, %TrayClickOption%, %ConfigFile%, %ScriptName%, TrayClickOption
		IniWrite, %TrayMClickOption%, %ConfigFile%, %ScriptName%, TrayMClickOption
		IniWrite, %TrayRClickOption%, %ConfigFile%, %ScriptName%, TrayRClickOption
		IniWrite, %_Debug%, %ConfigFile%, %ScriptName%, Debug
		IniWrite, %_Devel%, %ConfigFile%, %ScriptName%, Devel
		IniWrite, %AutoUpdate%, %ConfigFile%, %ScriptName%, AutoUpdate
		IniWrite, %DelayedUpdateCheck%, %ConfigFile%, %ScriptName%, DelayedUpdateCheck
		IniWrite, %NoTrayIcon%, %ConfigFile%, %ScriptName%, NoTrayIcon
		IniWrite, %Betatester%, %ConfigFile%, %ScriptName%, Betatester
		IniWrite, %BackupOnUpdate%, %ConfigFile%, %ScriptName%, BackupOnUpdate
		IniWrite, %DisableAutoUpdateOnSlowNetwork%, %ConfigFile%, %ScriptName%, DisableAutoUpdateOnSlowNetwork
		IniWrite, %ShowFocusToolTips%, %ConfigFile%, %ScriptName%, ShowFocusToolTips

		IniWrite, %_DebugLevel%, %ConfigFile%, %ScriptName%, DebugLevel
		IniWrite, %ReloadOnWakeUp%, %ConfigFile%, %ScriptName%, ReloadOnWakeUp
		IniWrite, %DisableAutoUpdateOnSlowNetwork%, %ConfigFile%, %ScriptName%, DisableAutoUpdateOnSlowNetwork
		IniWrite, %NoTrayIcon%, %ConfigFile%, %ScriptName%, NoTrayIcon
		If ScriptIcon <> %A_ScriptDir%\icons\internals\ac'tivAid.ico
			IniWrite, %ScriptIcon%, %ConfigFile%, %ScriptName%, Icon
		If ScriptOnIcon <> %A_ScriptDir%\icons\internals\ac'tivAid_on.ico
			IniWrite, %ScriptOnIcon%, %ConfigFile%, %ScriptName%, TrayIcon_On
		If ScriptOffIcon <> %A_ScriptDir%\icons\internals\ac'tivAid_off.ico
			IniWrite, %ScriptOffIcon%, %ConfigFile%, %ScriptName%, TrayIcon_Off
		IniWrite, %AllowMultipleInstances%, %ConfigFile%, %ScriptName%, AllowMultipleInstances
		IniWrite, %NetworkTimeout%, %ConfigFile%, %ScriptName%, NetworkTimeout
		IniWrite, %WinModifierFirst%, %ConfigFile%, %ScriptName%, WinModifierFirst
		IniWrite, %FileBrowser%, %ConfigFile%, %ScriptName%, FileBrowser
		IniWrite, %FileBrowserWithTree%, %ConfigFile%, %ScriptName%, FileBrowserWithTree
		IniWrite, %FileBrowserSelect%, %ConfigFile%, %ScriptName%, FileBrowserSelect
		IniWrite, %FullScreenApps%, %ConfigFile%, %ScriptName%, FullScreenApps
		IniWrite, %MaintainStats%, %ConfigFile%, %ScriptName%, MaintainStats
		IniWrite, %LastScriptversion%, %ConfigFile%, %ScriptName%, LastScriptVersion
		IniWrite, %activAid_LastFolder%, %ConfigFile%, %ScriptName%, LastFolder
		IniWrite, %HotkeyListAOT%, %ConfigFile%, %ScriptName%, HotkeyListAOT
		IniWrite, %CreateUninstaller%, %ConfigFile%, %ScriptName%, CreateUninstaller
		CustomWorkingDir := func_ReplaceWithCommonPathVariables(CustomWorkingDirTmp,"A_ScriptDir,")
		If CustomWorkingDir =
			CustomWorkingDir = `%A_ScriptDir`%
		If (CustomWorkingDir <> "" AND MainDirNotWriteable = 0 AND FileExist(func_Deref(CustomWorkingDir)))
		{
			IniWrite, %CustomWorkingDir%, %A_ScriptDir%\Settings\ac'tivAid.ini, activAid, CustomWorkingDir
			CustomWorkingDir := func_Deref(CustomWorkingDir)
			If (CustomWorkingDir <> A_WorkingDir)
			{
				If CustomWorkingDir = %A_AppData%\ac'tivAid
				{
					IniWrite, 1, %activAidGlobalData%\%ConfigFile%, %ScriptName%, MultiUser
					IniWrite, 1, %A_ScriptDir%\Settings\ac'tivAid.ini, %ScriptName%, MultiUser
				}
				Else
				{
					IniDelete, %activAidGlobalData%\%ConfigFile%, %ScriptName%, MultiUser
					IniDelete, %A_ScriptDir%\Settings\ac'tivAid.ini, %ScriptName%, MultiUser
				}
				NewWorkingDir = %CustomWorkingDir%
				A_Args = %A_Args% "LastWorkingDir:%NewWorkingDir%"
				Reload =1
			}
		}
		CustomWorkingDir := func_Deref(CustomWorkingDir)

		If NumOfDumpVars
			IniWrite, %NumOfDumpVars%, %ConfigFile%, %ScriptName%, NumOfDumpVars

		If ((selectedLanguage <> 4 AND actLanguage <> selectedLanguage OR CleanINI = 1))
		{
			IniDelete, %ConfigFile%, %ScriptName%, Language
			If selectedLanguage < 4
				FileDelete, settings\language.ini
			If selectedLanguage = 2
				IniWrite, 07, %ConfigFile%, %ScriptName%, Language
			If selectedLanguage = 3
				IniWrite, 09, %ConfigFile%, %ScriptName%, Language
			If selectedLanguage > 4
				FileCopy, % LanguagesFile[%selectedLanguage%], settings\language.ini, 1

			Reload = 1
		}

		If (_Devel <> _DevelLast OR _Debug <> _DebugLast OR A_IconHidden <> NoTrayIcon OR Betatester <> BetatesterLast OR TrayClickOption <> TrayClickOptionLast)
			Reload = 1

		func_HotkeyWrite( "ProblemSolver", ConfigFile, ScriptName, "Hotkey_ProblemSolver" )
		If Hotkey_ProblemSolver_old2 <> %Hotkey_ProblemSolver_old%
			Menu, Tray, Rename, % lng_ProblemSolver "`t" func_HotkeyDecompose( Hotkey_ProblemSolver_old2, 1 ),  % lng_ProblemSolver "`t" func_HotkeyDecompose( Hotkey_ProblemSolver, 1 )
		func_HotkeyWrite( "MainGUI", ConfigFile, ScriptName, "Hotkey_MainGUI" )
		If Hotkey_MainGUI_old2 <> %Hotkey_MainGUI_old%
			Menu, Tray, Rename, % lng_Info "`t" func_HotkeyDecompose( Hotkey_MainGUI_old2, 1 ), % lng_Info "`t" func_HotkeyDecompose( Hotkey_MainGUI, 1 )
		func_HotkeyWrite( "DisableEnable", ConfigFile, ScriptName, "Hotkey_DisableEnable" )
		If Hotkey_DisableEnable_old2 <> %Hotkey_DisableEnable_old%
			Menu, Tray, Rename, % lng_deactivate "`t" func_HotkeyDecompose( Hotkey_DisableEnable_old2, 1 ), % lng_deactivate "`t" func_HotkeyDecompose( Hotkey_DisableEnable, 1 )
		func_HotkeyWrite( "TempSuspend", ConfigFile, ScriptName, "Hotkey_TemporarySuspend" )
		func_HotkeyWrite( "ShowHotkeyList", ConfigFile, ScriptName, "Hotkey_ShowHotkeyList" )
		If Hotkey_ShowHotkeyList_old2 <> %Hotkey_ShowHotkeyList_old%
			Menu, Tray, Rename, % lng_ShowHotkeyList "`t" func_HotkeyDecompose( Hotkey_ShowHotkeyList_old2, 1 ), % lng_ShowHotkeyList "`t" func_HotkeyDecompose( Hotkey_ShowHotkeyList, 1 )
		func_HotkeyWrite( "ShowMainContextMenu", ConfigFile, ScriptName, "Hotkey_ShowMainContextMenu" )
		If Hotkey_ShowMainContextMenu_old2 <> %Hotkey_ShowMainContextMenu_old%
			If TrayClickOption = 5
				Menu, Tray, Rename, % lng_ShowMainContextMenu "`t" func_HotkeyDecompose( Hotkey_ShowMainContextMenu_old2, 1 ), % lng_ShowHotkeyList "`t" func_HotkeyDecompose( Hotkey_ShowMainContextMenu, 1 )
		func_HotkeyWrite( "ReloadActivAid", ConfigFile, ScriptName, "Hotkey_ReloadActivAid" )
		If Hotkey_ReloadActivAid_old2 <> %Hotkey_ReloadActivAid_old%
			Menu, Tray, Rename, % lng_Reload "`t" func_HotkeyDecompose( Hotkey_ReloadActivAid_old2, 1 ), % lng_Reload "`t" func_HotkeyDecompose( Hotkey_ReloadActivAid, 1 )

		If _AdditionalSettings
			SaveAdditionalSettings( "" )

		ChangedSettings[activAid] =
		ChangedSettings++
	}
	Gosub, sub_MenuAutostart

	EnableTray =
	Loop
	{
		Function := Extension[%A_Index%]

		If Function =
			Break

		If (SimpleMainGUI <> "" AND Function <> SimpleMainGUI)
			continue

		EnableTray := EnableTray EnableTray_%Function%_tmp
	}

	If ( (EnableTray <> EnableTrayAll AND SimpleMainGUI = "") OR Duplicate <> "")
		Reload = 1

	Loop
	{
		Function := Extension[%A_Index%]
		If Function =
			Break

		Prefix := ExtensionPrefix[%A_Index%]

		If (IsLabel( "SavePosition_" Function ))
		{
			Debug("FILE", A_LineNumber, A_LineFile, "Save Positions for " Function "...")
			Gosub, SavePosition_%Function%
		}

		If (ChangedSettings[%Function%] = "" OR Function = "" OR (HideInGui_%Function% = 1 AND SimpleMainGUI <> Function))
			continue

		If (SimpleMainGUI <> "" AND Function <> SimpleMainGUI)
			continue

		Debug("SETTINGS", A_LineNumber, A_LineFile, "Writing Settings for: " Function " ..." )

		ChangedSettings[%Function%] =
		ChangedSettings++
		If ChangedSettings = 1
			SplashImage,,CWeeeeee b1 FS9 w%GuiSplashW% x%GuiSplashX% y%GuiSplashY%, %lng_WritingSettings%
		Else
			SplashImage,,, %lng_WritingSettings%: %Function%

		IniWrite, % Enable_%Function%, %ConfigFile%, %ScriptName%, Enable_%Function%
		IniWrite, % EnableTray_%Function%_tmp, %ConfigFile%, %ScriptName%, EnableTray_%Function%

		If CustomHotkey_%Function% = 1
		{
			func_HotkeyDisable(Function)
			func_HotkeyWrite( Function, ConfigFile, Function, "Hotkey_" Function )
		}

		If ExtensionMenuName[%A_Index%] =
			continue

		If (IsLabel( "SaveSettings_" Function ))
		{
			Debug("FILE", A_LineNumber, A_LineFile, "Save Settings for " Function "...")
			Gosub, SaveSettings_%Function%
		}
		GuiDefault("activAid")
		Gui, ListView, OptionsListBox

		If %Prefix%_AdditionalSettings
			SaveAdditionalSettings( Prefix )

		If Enable_%Function% = 1
		{
			If CustomHotkey_%Function% =1
				func_HotkeyEnable( Function )

			Debug("EXTENSION", A_LineNumber, A_LineFile, "DoEnable_" Function "...")
			Gosub, DoEnable_%Function%
			If ((EnableTray_%Function% = 1 OR (EnableTray_%Function% = 1 AND EnableTray = EnableTrayAll)) AND Reload <> 1)
			{
				If (ImageList[%Function%] <> "" AND A_GuiControl = "MainGUIapply" AND _ShowIconsInOptionsListBox = 1)
				{
					hIcon := ExtractIcon(TrayIcon[%Function%], TrayIconPos[%Function%], 16)
					DllCall("ImageList_ReplaceIcon", "uint", InstalledExtension_ImageList, "int", ImageList[%Function%]-1, "uint", hIcon)
					DllCall("DestroyIcon", "uint", hIcon)
					LV_Modify(GuiTabs[%Function%],"Icon0")
					LV_Modify(GuiTabs[%Function%],"Icon" ImageList[%Function%])
				}

				If _useTrayMenuIcons = 1
					ReadIcon(Function,IconFile_On_%Function%, IconPos_On_%Function%, IconFile_Off_%Function%, IconPos_Off_%Function%)

				If (_useTrayMenuIcons = 1 && TrayIcon[%Function%]!="" && FileExist(TrayIcon[%Function%]))
				{
					htm_pos := TrayMenu[%Function%] + Floor((TrayMenu[%Function%]+1)/TrayMenuSplit)
					MI_SetMenuItemIcon(hTM, htm_pos, TrayIcon[%Function%], TrayIconPos[%Function%], 16)
				}
				Else
					Menu, Tray, Check, % ExtensionMenuName[%A_Index%]

			}
		}
		Else
		{
			If CustomHotkey_%Function% = 1
			{
				func_HotkeyDisable( Function )
			}
			If (IsLabel( "DoDisable_" Function ) )
				Gosub, DoDisable_%Function%
			If ((EnableTray_%Function% = 1 OR (EnableTray_%Function% = 1 AND EnableTray = EnableTrayAll)) AND Reload <> 1)
			{
				If (ImageList[%Function%] <> "" AND A_GuiControl = "MainGUIapply" AND _ShowIconsInOptionsListBox = 1)
				{
					hIcon := ExtractIcon(TrayIconOff[%Function%], TrayIconOffPos[%Function%], 16)
					DllCall("ImageList_ReplaceIcon", "uint", InstalledExtension_ImageList, "int", ImageList[%Function%]-1, "uint", hIcon)
					DllCall("DestroyIcon", "uint", hIcon)
					LV_Modify(GuiTabs[%Function%],"Icon0")
					LV_Modify(GuiTabs[%Function%],"Icon" ImageList[%Function%])
				}

				If _useTrayMenuIcons = 1
					ReadIcon(Function,IconFile_On_%Function%, IconPos_On_%Function%, IconFile_Off_%Function%, IconPos_Off_%Function%)

				If (_useTrayMenuIcons = 1 && TrayIconOff[%Function%]!="" && FileExist(TrayIconOff[%Function%]))
				{
					htm_pos := TrayMenu[%Function%] + Floor((TrayMenu[%Function%]+1)/TrayMenuSplit)
					MI_SetMenuItemIcon(hTM, htm_pos, TrayIconOff[%Function%], TrayIconOffPos[%Function%], 16)
				}
				Menu, Tray, UnCheck, % ExtensionMenuName[%A_Index%]
			}
		}

		If CustomHotkey_%Function% = 1
		{
			MenuName := ExtensionCleanMenuName[%A_Index%] "`t" func_HotkeyDecompose( Hotkey_%Function%, 1 )
			If (ExtensionMenuName[%A_Index%] <> MenuName AND Reload <> 1 AND EnableTray_%Function% = 1)
			{
				Menu, Tray, Rename, % ExtensionMenuName[%A_Index%], %MenuName%
				ExtensionMenuName[%A_Index%] = %MenuName%
				Index := TrayMenu[%Function%]
				TrayMenuName[%Index%] = %MenuName%
			}
		}

		If (CustomHotkey_%Function% <> 1 AND CustomHotkey_%Function% <> "")
		{
			CustomHotkeyVar := "Hotkey_" CustomHotkey_%Function%
			MenuName := ExtensionCleanMenuName[%A_Index%] "`t" func_HotkeyDecompose( %CustomHotkeyVar%, 1 )
			If (ExtensionMenuName[%A_Index%] <> MenuName AND Reload <> 1 AND EnableTray_%Function% = 1)
			{
				Menu, Tray, Rename, % ExtensionMenuName[%A_Index%], %MenuName%
				ExtensionMenuName[%A_Index%] = %MenuName%
				Index := TrayMenu[%Function%]
				TrayMenuName[%Index%] = %MenuName%
			}
		}
	}

	Gui, %GuiID_activAid%:Default

	Gosub, sub_ExtInstall

	Gosub, DoEnable_MButton
	Gosub, DoEnable_RButton

	If ChangedSettings > 0
	{
		func_HotkeyEnable("MainGUI")
		func_HotkeyEnable("DisableEnable")
		func_HotkeyEnable("TempSuspend")
		func_HotkeyEnable("ProblemSolver")
		func_HotkeyEnable("ShowHotkeyList")
		func_HotkeyEnable("ShowMainContextMenu")
		func_HotkeyEnable("ReloadActivAid")

		GuiControl, Disable, MainGuiApply

		If A_GuiControl <> MainGuiApply
			IniDelete, %ConfigFile%, %ScriptName%, ShowGUI

		gosub, sub_BeautifyINI

		If Reload = 1
		{
			Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
			Gosub, Reload
		}
	}

	SplashImage, Off

	Gosub, sub_temporarySuspend
	Gosub, sub_ChangeIcon

	If A_GuiControl = MainGUIapply
	{
		Gui, -Disabled
		If _AlternativeTrayMenu <> 1
		{
			Loop, % TrayMenu - TrayMenuFirstExtension
			{
				Index := A_Index + TrayMenuFirstExtension
				If TrayMenuName[%Index%] =
					continue
				Menu, Tray, Disable, % TrayMenuName[%Index%]
			}
		}
		If MainGuiVisible = 2
			Gui, %GuiID_activAid%:Show
	}
	Else
	{
		MainGuiVisible =
		Menu, Tray, ToggleEnable, % lng_Info "`t" func_HotkeyDecompose( Hotkey_MainGUI, 1 )

		Loop, Parse, hook_UnsetVarOnGuiClose, |
			%A_LoopField% := ""
		hook_UnsetVarOnGuiClose := ""

		func_RemoveMessage(0x200, "GuiTooltip")
		func_RemoveMessage(0x101, "GuiTooltipKey")
		func_RemoveMessage(0x202, "GuiTooltipKey")
		func_RemoveMessage(0x6, "RemoveGuiTooltip")

		Loop, Parse, OptionsListBox, |
		{
			If A_LoopField =
				continue
			LoopField := func_StrClean(A_LoopField)
			ImageList[%LoopField%] =
			ExtensionGuiDrawn[%LoopField%] =
		}
	}

	If A_GuiControl <> MainGUIapply
	{
		Gui, Destroy
		mainGuiID =
		Debug("GUI", A_LineNumber, A_LineFile, "Config windows closed." )
	}
	Else
		Debug("GUI", A_LineNumber, A_LineFile, "Window stays open because of 'Apply'" )

	If _SingleClickTrayAction = 1
		Menu, Tray, Click, 1
	Else
		Menu, Tray, Click, 2

	Readme_Hotkeys =
	HotkeyList =

	SimpleMainGUI =

	Hotkey_AllNewHotkeys = %Hotkey_AllHotkeys%

	Gosub, sub_ShowDuplicates
}
