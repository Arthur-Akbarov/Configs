; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               AutoDeactivate
; -----------------------------------------------------------------------------
; Prefix:             AD_
; Version:            0.4
; Date:               2008-05-07
; Author:             Wolfgang Reszel, David Hilberath
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; Diese Erweiterung ergänzt ac'tivAid um die Möglichkeit sich programmabhängig
; automatisch zu deaktivieren.

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_AutoDeactivate:
	Prefix = ad
	%Prefix%_ScriptName    = AutoDeactivate
	%Prefix%_ScriptVersion = 0.4
	%Prefix%_Author        = Wolfgang Reszel, David Hilbearth

	CustomHotkey_AutoDeactivate = 0
	Hotkey_AutoDeactivate       =
	HotkeyPrefix_AutoDeactivate =
	IconFile_On_AutoDeactivate  = %A_WinDir%\system32\shell32.dll
	IconPos_On_AutoDeactivate   = 132

	; Sprachabhngige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %ad_ScriptName% - ac'tivAid automatisch deaktivieren
		Description                   = ac'tivAid abhängig von der gerade aktiven Anwendung automatisch deaktivieren.
		lng_ad_ExcludeApps            = Bei einer der folgenden Anwendungen ac'tivAid automatisch deaktivieren
		lng_ad_DisableActivAid1       = ac'tivAid komplett deaktivieren
		lng_ad_DisableActivAid2       = Nur einzelne Erweiterungen deaktivieren:
		lng_ad_useShellHook           = Windows soll ac'tivAid über Fensterwechsel benachrichtigen
		lng_ad_fileSelectPrompt       = Select executables for %ad_ScriptName%
		lng_ad_fileSelectFilter       = Executables (*.exe; *.com; *.bat)
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %ad_ScriptName% - automatically deactivate ac'tivAid
		Description                   = Deactivate ac'tivAid utomatically depending on the active application.
		lng_ad_ExcludeApps            = ac'tivAid will be deactivated automatically when one of the following applications is active
		lng_ad_DisableActivAid1       = Deactivate ac'tivAid completely
		lng_ad_DisableActivAid2       = Just deactivate selected extensions:
		lng_ad_useShellHook           = Let Windows send a message on windowchange
		lng_ad_fileSelectPrompt       = Select executables for %ad_ScriptName%
		lng_ad_fileSelectFilter       = Executables (*.exe; *.com; *.bat)
	}

	IniRead, ad_ExcludeApps, %ConfigFile%, %ad_ScriptName%, ExcludeApps
	IniRead, ad_DisableExtensions, %ConfigFile%, %ad_ScriptName%, DisableExtensions, 1
	If (ad_ExcludeApps = "ERROR" OR ad_ExcludeApps = "|")
		ad_ExcludeApps =
	StringReplace, ad_ExcludeApps, ad_ExcludeApps, |, `,, All
	IniRead, ad_DisableExtensionsList, %ConfigFile%, %ad_ScriptName%, DisableExtensionsList, AppLauncher|FileRenamer

	RegisterAdditionalSetting("ad","useShellHook",0)
	ad_MultiSelect = 1
Return

SettingsGui_AutoDeactivate:
	Gui, Add, Text, XS+10 Y+8 W300 R2, %lng_ad_ExcludeApps%:
	StringReplace, ad_ExcludeApps_Box, ad_ExcludeApps , `, , | , a
	Gui, Add, ListBox, Y+10 vad_ExcludeApps_Box_tmp W300 R15, %ad_ExcludeApps_Box%
	Gui, Add, Button, -Wrap y+5 w25 vad_Add_ExcludeApps_Box gsub_ListBox_addApp, +
	Gui, Add, Button, -Wrap x+0 w25 vad_Remove_ExcludeApps_Box gsub_ListBox_remove, %MinusString%
	Gui, Add, Button, -Wrap x+160 w90 vad_Add_BrowseForApp_Box gsub_ListBox_addApp_Browse, %lng_Browse%
	Gui, Add, Radio, -Wrap xs+330 ys+22 gad_sub_CheckIfSettingsChanged vad_DisableExtensions, %lng_ad_DisableActivAid1%
	Gui, Add, Radio, -Wrap y+5 gad_sub_CheckIfSettingsChanged, %lng_ad_DisableActivAid2%
	GuiControl, , % lng_ad_DisableActivAid%ad_DisableExtensions%, 1
	If ad_DisableExtensions = 2
		Gui, Add, ListView, w200 h195 Checked AltSubmit gad_sub_ListBoxChanged ReadOnly NoSortHdr vad_ExtensionList, %lng_Extension%
	Else
		Gui, Add, ListView, w200 h195 Hidden Checked AltSubmit gad_sub_ListBoxChanged ReadOnly NoSortHdr vad_ExtensionList, %lng_Extension%

	If _ShowIconsInOptionsListBox = 1
		LV_SetImageList(InstalledExtension_ImageList,1)
	Loop
	{
		If Extension[%A_Index%] =
			break

		ad_Function := Extension[%A_Index%]
		If (InStr("|" ad_DisableExtensionsList "|", "|" ad_Function "|"))
			ad_LVOptions := "Check Icon" ImageList[%ad_Function%]
		Else
			ad_LVOptions := "Icon" ImageList[%ad_Function%]

		LV_Add(ad_LVOptions,ad_Function)
	}
	LV_Modifycol(1,179)
Return

sub_ListBox_addApp_Browse:
	if ad_MultiSelect = 1
	{
		FileSelectFile, ad_SelectedFiles, M3,,%lng_ad_fileSelectPrompt%, %lng_ad_fileSelectFilter%

		if ad_SelectedFiles =
			return

		Loop, parse, ad_SelectedFiles, `n
		{
			if A_Index = 1
			{
				ad_SelectedFilesDirectory := A_LoopField
				StringRight, ad_checkForSlash, ad_SelectedFilesDirectory, 1
				if ad_checkForSlash = \
					StringTrimRight, ad_SelectedFilesDirectory, ad_SelectedFilesDirectory, 1
			}
			else
			{
				/*
				SplitPath, A_LoopField,,,ad_SelectedFilesExtension

				if ad_SelectedFilesExtension = lnk
				{
					FileGetShortcut, %ad_SelectedFilesDirectory%\%A_LoopField%, ad_ShortCutTarget
					continue
				}
				*/

				ad_ExcludeApps_Box = %ad_ExcludeApps_Box%|%A_LoopField%
				GuiControl,,ad_ExcludeApps_Box_tmp,%A_LoopField%
			}
		}
	}
	else
	{
		FileSelectFile, ad_SelectedFile, 3,,%lng_ad_fileSelectPrompt%, %lng_ad_fileSelectFilter%
		if ad_SelectedFile =
			return

		SplitPath, ad_SelectedFile, ad_SelectedFile

		ad_ExcludeApps_Box = %ad_ExcludeApps_Box%|%ad_SelectedFile%
		GuiControl,,ad_ExcludeApps_Box_tmp,%ad_SelectedFile%
	}
	func_SettingsChanged("AutoDeactivate")
Return

ad_sub_CheckIfSettingsChanged:
	Gosub, sub_CheckIfSettingsChanged
	GuiControlGet, ad_DisableExtensions_tmp,, ad_DisableExtensions
	If ad_DisableExtensions_tmp = 1
		GuiControl, Hide, ad_ExtensionList
	Else
		GuiControl, Show, ad_ExtensionList
Return

ad_sub_ListBoxChanged:
	If A_GuiEvent = C
		Gosub, sub_CheckIfSettingsChanged
Return

SaveSettings_AutoDeactivate:
	If (func_StrLeft(ad_ExcludeApps_Box,1) = "|")
		StringTrimleft, ad_ExcludeApps_Box, ad_ExcludeApps_Box, 1
	StringReplace, ad_ExcludeApps, ad_ExcludeApps_Box, | , `, , a
	IniWrite, %ad_ExcludeApps%, %ConfigFile%, %ad_ScriptName%, ExcludeApps

	IniWrite, %ad_DisableExtensions%, %ConfigFile%, %ad_ScriptName%, DisableExtensions

	Gui, ListView, ad_ExtensionList
	ad_DisableExtensionsList =
	Loop
	{
		 ad_RowNumber := LV_GetNext(ad_RowNumber,"C")  ; Resume the search at the row after that found by the previous iteration.
		 if not ad_RowNumber  ; The above returned zero, so there are no more selected rows.
			  break
		 LV_GetText(ad_Text, ad_RowNumber)
		 ad_DisableExtensionsList = %ad_DisableExtensionsList%%ad_Text%|
	}
	StringTrimRight, ad_DisableExtensionsList, ad_DisableExtensionsList, 1
	IniWrite, %ad_DisableExtensionsList%, %ConfigFile%, %ad_ScriptName%, DisableExtensionsList
Return

AddSettings_AutoDeactivate:
Return
CancelSettings_AutoDeactivate:
Return

DoEnable_AutoDeactivate:
	If ad_ExcludeApps <>
	{
		if ad_useShellHook = 1
			registerEvent("activeWindow","ad_shellHook_Deactivator")
		else
			SetTimer, ad_tim_Deactivator, 50
	}
Return

DoDisable_AutoDeactivate:
	If (ad_useShellHook = 1 AND ad_MsgNum <> "")
		unRegisterEvent("activeWindow","ad_shellHook_Deactivator")
	else
		SetTimer, ad_tim_Deactivator, Off
Return

DefaultSettings_AutoDeactivate:
Return

OnExitAndReload_AutoDeactivate:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------
ad_shellHook_Deactivator:
	ad_ProcessName := event_activeWindow
	gosub, ad_deactivator
return

ad_tim_Deactivator:
	If (IsSuspended = 1 OR LoadingFinished <> 1)
		Return

	WinGet, ad_ProcessName, ProcessName, A

	gosub, ad_deactivator
Return

ad_deactivator:
	If ad_ProcessName in %ad_ExcludeApps%
	{
		If ad_LastProcess <> %ad_ProcessName%
		{
			If ad_DisableExtensions = 2
			{
				Loop, Parse, ad_DisableExtensionsList, |
				{
					If A_LoopField =
						Continue
					If Enable_%A_LoopField% = 1
					{
						If (IsLabel( "DoDisable_" A_LoopField))
							Gosub, DoDisable_%A_LoopField%
					}
				}
			}
			Else
			{
				Suspend, On
				CallHook("OnSuspend")
				If (NoTrayIcon <> 1 AND CustomIcon <> 1)
					Menu, Tray, Icon, %ScriptOffIcon%, %ScriptOffIcon#%, 1
			}
			ad_LastProcess = %ad_ProcessName%
		}
	} Else If (ad_LastProcess <> "") {
		If ad_DisableExtensions = 2
		{
			Loop, Parse, ad_DisableExtensionsList, |
			{
				If A_LoopField =
					Continue
				If Enable_%A_LoopField% = 1
				{
					If (IsLabel( "DoDisable_" A_LoopField))
						Gosub, DoEnable_%A_LoopField%
				}
			}
		}
		Else
		{
			Suspend, Off
			CallHook("OnResume")
			If (NoTrayIcon <> 1 AND CustomIcon <> 1)
				Menu, Tray, Icon, %ScriptOnIcon%, %ScriptOnIcon#%, 1
		}
		ad_LastProcess =
	}
return
