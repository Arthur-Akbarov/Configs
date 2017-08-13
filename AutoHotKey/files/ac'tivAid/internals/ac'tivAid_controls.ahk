sub_ExtendEdit1Controls:
	edit1_Key = %#wParam%

	GuiControlGet, edit1_Focus, focus
	If (func_StrLeft(edit1_Focus,4) <> "Edit")
		Return

	GuiControlGet, edit1_Focus, focusV

	GetKeyState, edit1_CtrlState, Ctrl
	If edit1_CtrlState = D
		edit1_Key := edit1_Key + 1000
	GetKeyState, edit1_ShiftState, Shift
	If edit1_ShiftState = D
		edit1_Key := edit1_Key + 2000
	GetKeyState, edit1_AltState, Alt
	If edit1_AltState = D
		edit1_Key := edit1_Key + 4000

;      tooltip %edit1_Key% %edit1_Focus% %edit1_searchTermTargetHwnd%

	If (edit1_Key = 1008) ; Strg+Löschen
	{
		If edit1_Focus in Readme,ChangeLog,HotkeyList,ContextHelp
			GuiControl, Focus, searchTerm%edit1_Focus%
		SetKeyDelay,0
		Send,^+{Left}{Del}
		#Return = 0
	}
Return

sub_ListBox_addApp:
	StringReplace, VarApp, A_GuiControl, Add_,
	WinSet,Bottom,, %ScriptTitle%
	SplashImage,,b1 cwFFFF80 FS9 WS700, %lng_AddApps%
	Gui,%GuiID_activAid%:+Disabled
	Input,GetKey,,{Enter}{ESC}
	StringReplace,GetKey,ErrorLevel,Endkey:
	SplashImage, Off
	Gui,%GuiID_activAid%:-Disabled
	WinGet, GetProcName, ProcessName, A
	If Getkey = Enter
	{
		IfNotInstring, %VarApp%, %GetProcName%
		{
			GuiControl,,%VarApp%_tmp,%GetProcName%
			%VarApp% := %VarApp% "|" GetProcName
			StringReplace,%VarApp%,%VarApp%,||,|,a
		}
	}
	Gui,%GuiID_activAid%:Show
	WinSet, Top, , %ScriptTitle%

	If (MainGuiVisible <> 2 OR GetKey = "ESCAPE")
		Return

	StringReplace, VarAppOrg, VarApp, _Box,
	If ( func_StrLeft(%VarApp%,1) = "|" )
	{
		StringTrimLeft, %VarApp%, %VarApp%, 1
	}
	If ( func_StrRight(%VarApp%,1) = "|" )
	{
		StringTrimRight, %VarApp%, %VarApp%, 1
	}
	GuiControlGet, activeTab,,DlgTabs
	StringReplace, ChangedSettings[%activeTab%], ChangedSettings[%activeTab%], %VarApp%|,,A
	If (%VarApp% <> ChangedSettings[%activeTab%])
		ChangedSettings[%activeTab%] := ChangedSettings[%activeTab%] %VarApp% "|"
	Gosub, sub_EnableDisable_ApplyButton
;   Tooltip, % activeTab " : " ChangedSettings[%activeTab%]
Return

sub_ListBox_addFolder:
	Gui %GuiID_activAid%:+OwnDialogs
	StringReplace, VarApp, A_GuiControl, Add_,
	FileSelectFolder,GetFolder, *%GetFolder%
	If GetFolder =
		Return
	If ListBox_addFolder_VariableDriveLetter = 1
	{
		GetFolder := func_ReplaceWithCommonPathVariables(GetFolder)
	}
	IfNotInstring, %VarApp%, %GetFolder%
	{
		If %VarApp%_DontAllowSubfolders = 1
		{
			Loop, Parse, %VarApp%, |
			{
				If A_LoopField =
					continue
				If ( func_StrLeft( GetFolder, StrLen(A_LoopField) ) = A_LoopField)
				{
					MsgBox, 16,%qc_ScriptName%, %lng_IsSubfolder% %A_LoopField%
					return
				}
			}
		}

		GuiControl,,%VarApp%_tmp,%GetFolder%
		%VarApp% := %VarApp% "|" GetFolder
		StringReplace,%VarApp%,%VarApp%,||,|,a
	}
	Else
	{
		If %VarApp%_DontAllowSubfolders = 1
			MsgBox, 16,%qc_ScriptName%, %lng_HasSubfolder%
		Else
			MsgBox, 16,%qc_ScriptName%, %lng_IsInList%
		return
	}

	If MainGuiVisible <> 2
		Return

	StringReplace, VarAppOrg, VarApp, _Box,
	If ( func_StrLeft(%VarApp%,1) = "|" )
	{
		StringTrimLeft, %VarApp%, %VarApp%, 1
	}
	If ( func_StrRight(%VarApp%,1) = "|" )
	{
		StringTrimRight, %VarApp%, %VarApp%, 1
	}
	GuiControlGet, activeTab,,DlgTabs
	StringReplace, ChangedSettings[%activeTab%], ChangedSettings[%activeTab%], %VarApp%|,,A

	If (%VarApp% <> ChangedSettings[%activeTab%])
		ChangedSettings[%activeTab%] := ChangedSettings[%activeTab%] %VarApp% "|"
	Gosub, sub_EnableDisable_ApplyButton
;   Tooltip, % activeTab " : " ChangedSettings[%activeTab%]
Return

sub_ListBox_remove:
	StringReplace, VarApp, A_GuiControl, Remove_,
	GuiControlGet, App_selected, , %VarApp%_tmp
	%VarApp% := "|" %VarApp% "|"
	StringReplace,%VarApp%,%VarApp%,|%App_selected%|,|,a
	StringReplace,%VarApp%,%VarApp%,||,|,a
	StringReplace,%VarApp%,%VarApp%,||,|,a
	GuiControl,,%VarApp%_tmp,% %VarApp%

	If MainGuiVisible <> 2
		Return

	StringReplace, VarAppOrg, VarApp, _Box,
	If ( func_StrLeft(%VarApp%,1) = "|" )
	{
		StringTrimLeft, %VarApp%, %VarApp%, 1
		StringTrimRight, %VarApp%, %VarApp%, 1
	}
	GuiControlGet, activeTab,,DlgTabs
	StringReplace, ChangedSettings[%activeTab%], ChangedSettings[%activeTab%], %VarApp%|,,A
	If (%VarAppOrg% <> %VarApp%)
		ChangedSettings[%activeTab%] := ChangedSettings[%activeTab%] VarApp "|"
	Gosub, sub_EnableDisable_ApplyButton
;   Tooltip, % activeTab " : " ChangedSettings[%activeTab%] "`n" %VarAppOrg%  "<>" %VarApp%
Return
