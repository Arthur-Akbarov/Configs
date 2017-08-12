sub_CopySettingsToUser:
	MsgBox, 36, %ScriptTitle%, % lng_Copy%AHKonUSBstr%SettingsToUserAsk
	IfMsgBox, Yes
	{
		Gui, %GuiID_activAid%:+Disabled
		If A_ScriptDir <> %WorkingDir%
		{
			FileRemoveDir, settings_backup, 1
			FileMoveDir, settings,  settings_backup, 1
		}
		FileCreateDir, settings
		FileCopyDir, %A_ScriptDir%\settings, settings\, 1
		FileRead, tmp_Main, settings\extensions_main.ini
		IfNotInString, tmp_Main, %A_ScriptDir%\
		{
			StringReplace, tmp_Main, tmp_Main, #Include *i extensions\ , #Include *i %A_ScriptDir%\extensions\, All
			FileDelete, settings\extensions_main.ini
			FileAppend, %tmp_Main%, settings\extensions_main.ini
		}
		IniWrite, %ListBox_selected%, %ConfigFile%, %ScriptName%, GUIselected
		IniWrite, 1, %ConfigFile%, %ScriptName%, ShowGUI
		IniWrite, 1, %ConfigFile%, %ScriptName%, MultiUser
		Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
		Gosub, Reload
	}
Return

sub_CopySettingsToSingle:
	MsgBox, 36, %ScriptTitle%, % lng_Copy%AHKonUSBstr%SettingsToSingleAsk
	IfMsgBox, Yes
	{
		Gui, %GuiID_activAid%:+Disabled
		If A_ScriptDir <> %WorkingDir%
		{
			FileRemoveDir, %A_ScriptDir%\settings_backup, 1
			FileMoveDir, %A_ScriptDir%\settings,  %A_ScriptDir%\settings_backup, 1
		}
		FileCreateDir, %A_ScriptDir%\settings
		FileCopyDir, settings, %A_ScriptDir%\settings\, 1
		FileRead, tmp_Main, %A_ScriptDir%\settings\extensions_main.ini
		IfInString, tmp_Main, %A_ScriptDir%\
		{
			StringReplace, tmp_Main, tmp_Main, #Include *i %A_ScriptDir%\extensions\ , #Include *i extensions\, All
			FileDelete, %A_ScriptDir%\settings\extensions_main.ini
			FileAppend, %tmp_Main%, %A_ScriptDir%\settings\extensions_main.ini
		}
		IniWrite, 0, %activAidGlobalData%\%ConfigFile%, %ScriptName%, % "MultiUser" func_Hex(A_UserName)
		Gui, %GuiID_activAid%:-Disabled
	}
Return

sub_CopySettingsFromUser:
	MsgBox, 36, %ScriptTitle%, % lng_Copy%AHKonUSBstr%SettingsFromUserAsk
	IfMsgBox, Yes
	{
		Gui, %GuiID_activAid%:+Disabled
		If AHKonUSB = 1
		{
			If A_ScriptDir <> %A_ScriptDir%\ComputerSettings\%A_Computername%
			{
				FileRemoveDir, settings_backup, 1
				FileMoveDir, settings,  settings_backup, 1
			}
			FileCreateDir, %A_ScriptDir%\ComputerSettings\%A_Computername%\settings
			FileCopyDir, %A_ScriptDir%\ComputerSettings\%A_Computername%\settings, %A_ScriptDir%\settings\, 1
			FileRead, tmp_Main, %A_ScriptDir%\ComputerSettings\%A_Computername%\settings\extensions_main.ini
			IfInString, tmp_Main, %A_ScriptDir%\
			{
				StringReplace, tmp_Main, tmp_Main, #Include *i %A_ScriptDir%\extensions\ , #Include *i extensions\, All
				FileDelete, settings\extensions_main.ini
				FileAppend, %tmp_Main%, settings\extensions_main.ini
			}
			IniWrite, %ListBox_selected%, %ConfigFile%, %ScriptName%, GUIselected
			IniWrite, 1, %ConfigFile%, %ScriptName%, ShowGUI
			IniWrite, 0, %activAidGlobalData%\%ConfigFile%, %ScriptName%, % "MultiUser" func_Hex(A_UserName)
			Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
			Gosub, Reload
		}
		Else
		{
			If A_ScriptDir <> %A_AppData%\ac'tivAid\
			{
				FileRemoveDir, settings_backup, 1
				FileMoveDir, settings,  settings_backup, 1
			}
			FileCreateDir, %A_AppData%\ac'tivAid\settings
			FileCopyDir, %A_AppData%\ac'tivAid\settings, %A_ScriptDir%\settings\, 1
			FileRead, tmp_Main, %A_AppData%\ac'tivAid\settings\extensions_main.ini
			IfInString, tmp_Main, %A_ScriptDir%\
			{
				StringReplace, tmp_Main, tmp_Main, #Include *i %A_ScriptDir%\extensions\ , #Include *i extensions\, All
				FileDelete, settings\extensions_main.ini
				FileAppend, %tmp_Main%, settings\extensions_main.ini
			}
			IniWrite, %ListBox_selected%, %ConfigFile%, %ScriptName%, GUIselected
			IniWrite, 1, %ConfigFile%, %ScriptName%, ShowGUI
			IniWrite, 0, %activAidGlobalData%\%ConfigFile%, %ScriptName%, % "MultiUser" func_Hex(A_UserName)
			Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
			Gosub, Reload
		}
	}
Return

sub_DefaultSettings:
;   Critical
	Gui %GuiID_activAid%:+OwnDialogs
	MsgBox, 36, %actFunct%, %lng_DefaultMsg%
	IfMsgBox, Yes
	{
		If actFunct <> %ScriptName%
		{
			Gosub, DefaultSettings_%actFunct%
			IfExist, % ConfigFile_%actFunct%
				FileDelete, % ConfigFile_%actFunct%
		}
		IniDelete, %ConfigFile%, %actFunct%
		IniWrite, %ListBox_selected%, %ConfigFile%, %ScriptName%, GUIselected
		Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
		Gosub, Reload
	}
Return

sub_SaveAllSettings:
;   Critical
	Gui %GuiID_activAid%:+OwnDialogs
	IniRead, LastExportDir, %ConfigFile%, %ScriptName%, LastExportDir, %A_ScriptDir%

	FileSelectFolder, tempFile, *%LastExportDir%, 1, %lng_SaveAllAsk%

	If ErrorLevel <> 0
		Return

	IniWrite, %tempFile%, %ConfigFile%, %ScriptName%, LastExportDir

	tempFound = 0
	FileCopy, %ConfigFile%, %tempFile%\, 1
	Loop
	{
		Function := Extension[%A_Index%]
		If Function =
			Break
		If ConfigFile_%Function% <>
		{
			SplitPath, ConfigFile_%Function%, ConfigFileName
			FileRead, tempContent, % ConfigFile_%Function%
			FileDelete, %tempFile%\%ConfigFileName%
			IfNotInString, tempContent, `; [%Function%]`r`n
				FileAppend, `; [%Function%]`r`n, %tempFile%\%ConfigFileName%
			FileAppend, %tempContent%, %tempFile%\%ConfigFileName%
		}
;      If DataFile_%Function% <>
;      {
;         SplitPath, DataFile_%Function%, DataFileName
;         FileRead, tempContent, % DataFile_%Function%
;         FileDelete, %tempFile%\%DataFileName%
;         IfNotInString, tempContent, `; [%Function%]`r`n
;            FileAppend, `; [%Function%]`r`n, %tempFile%\%DataFileName%
;         FileAppend, %tempContent%, %tempFile%\%DataFileName%
;      }
	}
Return

sub_LoadAllSettings:
;   Critical
	Gui %GuiID_activAid%:+OwnDialogs
	IniRead, LastExportDir, %ConfigFile%, %ScriptName%, LastExportDir, %A_ScriptDir%

	FileSelectFolder, tempFile, *%LastExportDir%, 1, %lng_LoadAllAsk%

	If ErrorLevel <> 0
		Return

	IniWrite, %tempFile%, %ConfigFile%, %ScriptName%, LastExportDir

	FileRead, tempContent, %tempFile%\%ScriptNameFull%.ini
	IfNotInString, tempContent, [%ScriptName%]`r`n
	{
		Msgbox, 16, %ScriptNameFull%.ini, %lng_ImportImpossible%`n`n%ConfigFile%
		return
	}
	Loop
	{
		Function := Extension[%A_Index%]
		If Function =
			Break
		If ConfigFile_%Function% <>
		{
			SplitPath, ConfigFile_%Function%, ConfigFileName
			FileReadLine, tempContent, %tempFile%\%ConfigFileName%, 1
;         msgbox, %tempContent%
			IfNotInString, tempContent, `; [%Function%]
			{
				Msgbox, 16, %ConfigFileName%, % lng_ImportImpossible "`n`n" ConfigFile_%Function%
				return
			}
		}
;      If DataFile_%Function% <>
;      {
;         SplitPath, DataFile_%Function%, DataFileName
;         FileReadLine, tempContent, %tempFile%\%DataFileName%, 1
;         IfNotInString, tempContent, `; [%Function%]
;         {
;            Msgbox, 16, %DataFileName%, % lng_ImportImpossible "`n`n" DataFile_%Function%
;            return
;         }
;      }
	}

	FileCopy, %tempFile%\%ScriptNameFull%.ini, %SettingsDir%\, 1
	Loop
	{
		Function := Extension[%A_Index%]
		If Function =
			Break
		If ConfigFile_%Function% <>
		{
			SplitPath, ConfigFile_%Function%, ConfigFileName
			FileRead, tempContent, %tempFile%\%ConfigFileName%
			StringReplace, tempContent, tempContent, `; [%Function%]`r`n,
			FileDelete, % ConfigFile_%Function%
			FileAppend, %tempContent%, % ConfigFile_%Function%
		}
;      If DataFile_%Function% <>
;      {
;         SplitPath, DataFile_%Function%, DataFileName
;         FileRead, tempContent, %tempFile%\%DataFileName%
;         StringReplace, tempContent, tempContent, `; [%Function%]`r`n,
;         FileDelete, % DataFile_%Function%
;         FileAppend, %tempContent%, % DataFile_%Function%
;      }
	}
	IniWrite, %ListBox_selected%, %ConfigFile%, %ScriptName%, GUIselected
	Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
	Gosub, Reload
Return

sub_ResetWindows:
	MsgBox, 36, %ScriptTitle%, % #(lng_AskResetWindows,actFunct)
	IfMsgBox, Yes
	{
		Gosub, ResetWindows_%actFunct%
	}
Return

sub_ExportSettings:
	Gui %GuiID_activAid%:+OwnDialogs
	Msgbox, 36, %actFunct% ,%lng_ExportAsk%

	IfMsgBox, yes
	{
		Gui %GuiID_activAid%:+OwnDialogs

		FileSelectFile, tempFile, S 16, %actFunct%_exported.ini, %lng_ExportSettings%, *.ini

		If ErrorLevel <> 0
			Return

		tempFound = 0
		FileDelete, %tempFile%

		If ConfigFile_%actFunct% <>
		{
			FileAppend, `; [%actFunct%]`r`n, %tempFile%
			Loop, Read, % ConfigFile_%actFunct%, %tempFile%
			{
				FileAppend, %A_LoopReadLine%`r`n
			}
		}
		Else
		{
			Loop, Read, %ConfigFile%, %tempFile%
			{
				IfInString, A_LoopReadLine, [%actFunct%]
				{
					tempFound = 1
					FileAppend, %A_LoopReadLine%`r`n
					continue
				}

				If tempFound < 1
					continue

				If (func_StrLeft(A_LoopReadLine,1) = "[")
					break

				FileAppend, %A_LoopReadLine%`r`n
			}
		}
		Loop, Parse, AdditionalConfigFiles_%actFunct%, `,
		{
			If A_LoopField =
				Break
			IfExist, %A_LoopField%
			{
				FileRead, tempContent, %A_LoopField%
				FileAppend, % "`r`n`r`n" Chr(28) "### " A_LoopField "###`r`n" Chr(29) tempContent,%tempFile%
			}
		}
	}
Return

sub_ImportSettings:
	Critical
	Gui %GuiID_activAid%:+OwnDialogs

	FileSelectFile, tempFile, 1, %A_ScriptDir%, %lng_ImportSettings%, *.ini
	If ErrorLevel <> 0
		Return

	FileReadLine, tempContent, %tempFile%, 1
	IfNotInString, tempContent, [%actFunct%]
	{
		Msgbox, 16, %actFunct%, %lng_ImportImpossible%
		return
	}
	If AddSettings_%actFunct% = 1
		Msgbox, 36, %actFunct%, %lng_ImportAsk%
	Else
		Msgbox, 36, %actFunct%, %lng_ImportAsk2%

	IfMsgBox, yes
	{
		If ConfigFile_%actFunct% <>
		{
			If AddSettings_%actFunct% = 1
			{
				AddFreshSettings = 1
				AddFile = %tempFile%
				Gosub, AddSettings_%actFunct%
			}
			Else
			{
				FileCopy, %tempFile%, % ConfigFile_%actFunct%, 1
			}
		}
		Else
		{
			If AddSettings_%actFunct% = 1
			{
				AddFreshSettings = 1
				AddFile = %tempFile%
				Gosub, AddSettings_%actFunct%
			}
			FileRead, tempContent, %tempFile%
			IniDelete, %ConfigFile%, %actFunct%
			Loop, Parse, tempContent, % Chr(28)
			{
				If A_Index = 1
				{
					FileAppend, %A_LoopField%, %ConfigFile%
					Gosub, sub_BeautifyINI
				}
				Else
				{
					StringSplit, tempContent, A_LoopField, % Chr(29)
					StringTrimLeft, tempContent1, tempContent1, 4
					StringTrimRight, tempContent1, tempContent1, 5
					If tempContent1 =
						break
					FileDelete, %tempContent1%
					FileAppend, %tempContent2%, %tempContent1%
				}
			}
		}
		If AddSettings_%actFunct% <> 1
		{
			IniWrite, %ListBox_selected%, %ConfigFile%, %ScriptName%, GUIselected
			Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
			Gosub, Reload
		}
		AddFreshSettings = 0
	}
Return

sub_AddSettings:
	Gui %GuiID_activAid%:+OwnDialogs

	FileSelectFile, AddFile, 1, %A_ScriptDir%, %lng_AddSettings%, *.ini
	If ErrorLevel <> 0
		Return

	FileReadLine, tempContent, %AddFile%, 1
	IfNotInString, tempContent, [%actFunct%]
	{
		Msgbox, 16, %actFunct%, %lng_ImportImpossible%
		return
	}
	Msgbox, 36, %actFunct%, %lng_AddAsk%

	IfMsgBox, yes
	{
		Gosub, AddSettings_%actFunct%
	}
Return
