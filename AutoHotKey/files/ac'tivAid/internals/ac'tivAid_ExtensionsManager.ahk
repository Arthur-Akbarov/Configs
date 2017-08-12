sub_ExtensionsOff:
;   Critical
	Gui %GuiID_activAid%:+OwnDialogs
	GetKeyState, AppsState, RAlt
	If AppsState = D
	{
		FileMove, settings\extensions_main.ini, settings\extensions_main_switch1.ini, 1
		FileMove, settings\extensions_header.ini, settings\extensions_header_switch1.ini, 1
		FileMove, settings\extensions_main_switch.ini, settings\extensions_main.ini, 1
		FileMove, settings\extensions_header_switch.ini, settings\extensions_header.ini, 1
		FileMove, settings\extensions_main_switch1.ini, settings\extensions_main_switch.ini, 1
		FileMove, settings\extensions_header_switch1.ini, settings\extensions_header_switch.ini, 1
	}
	Else
	{
		FileMove, settings\extensions_main.ini, settings\extensions_main_off.ini, 1
		FileMove, settings\extensions_header.ini, settings\extensions_header_off.ini, 1
	}
	If ErrorLevel = 0
	{
		Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
		Gosub, Reload
	}
	Else
		MsgBox, 16, %ScriptTitle%, %lng_SwitchExtErr%
return

sub_ExtensionsOn:
;   Critical
	Gui %GuiID_activAid%:+OwnDialogs
	FileMove, settings\extensions_main_off.ini, settings\extensions_main.ini, 1
	FileMove, settings\extensions_header_off.ini, settings\extensions_header.ini, 1
	If ErrorLevel = 0
	{
		Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
		Gosub, Reload
	}
	Else
		MsgBox, 16, %ScriptTitle%, %lng_SwitchExtErr%
return


sub_ExtensionManager:
	AvailableExtensions =
	InstalledExtensions =
	ExtensionsInExtDir =
	AutoTrim, On
	ExtensionsToParse=
	Loop, %A_ScriptDir%\extensions\*.ahk, 0, 0
	{
		ExtensionsToParse=%ExtensionsToParse%%A_LoopFileFullPath%`n
	}
	Loop, %A_ScriptDir%\beta_extensions\*.ahk, 0, 0
	{
		ExtensionsToParse=%ExtensionsToParse%%A_LoopFileFullPath%`n
	}

	LoadedExtensions = |
	DuplicateExtensions =
	Loop, Parse, ExtensionsToParse, `n
	{
		LoopFileName = %A_LoopField%
		IfInString, LoopFileName, extensions\_
			continue
		If LoopFileName =
			continue

		EMExtName =
		EMReqExtName =
		Loop, Read, %LoopFileName%
		{
			IfInString, A_LoopReadLine, Prefix ; And
			IfNotInString, A_LoopReadLine, `%
			{
				StringSplit, ext_temp, A_LoopReadLine, =

				StringReplace, Prefix, ext_temp2, %A_Space%,, A
			}
			IfInString, A_LoopReadLine, `%Prefix`%_ScriptName
			{
				StringSplit, ext_temp, A_LoopReadLine, =

				StringReplace, EMExtName, ext_temp2, %A_Space%,, A

				If (InStr(LoadedExtensions, "|" EMExtName "|") AND !InStr)
				{
					SplitPath, LoopFileName, LoopFileName1
					SplitPath, ExtensionFile[%EMExtName%], LoopFileName2
					DuplicateExtensions := DuplicateExtensions LoopFileName1 ", " LoopFileName2 ", "
					Continue
				}

				LoadedExtensions = %LoadedExtensions%%EMExtName%|

				IfNotInString, LoopFileName, beta_extensions
					ExtensionsInExtDir = %ExtensionsInExtDir%%EMExtName%`,

				If Extension[%EMExtName%] <> 1
					AvailableExtensions = %AvailableExtensions%%EMExtName%|
				Else
					InstalledExtensions = %InstalledExtensions%%EMExtName%|

				ExtensionPrefix[%EMExtName%] = %Prefix%
			}
			IfInString, A_LoopReadLine, `%Prefix`%_ScriptVersion
			{
				StringSplit, ext_temp, A_LoopReadLine, =

				ExtensionVersion[%EMExtName%] = %ext_temp2%
			}
			IfInString, A_LoopReadLine, `%Prefix`%_Author
			{
				StringSplit, ext_temp, A_LoopReadLine, =

				%Prefix%_Author = %ext_temp2%
			}
			IfInString, A_LoopReadLine, IconFile_On_
			{
				StringSplit, ext_temp, A_LoopReadLine, =
				ext_temp2 = %ext_temp2%
				ext_temp2 := func_Deref(ext_temp2)
				IconFile_On_%EMExtName% = %ext_temp2%
				ReadIcon( EMExtName, ext_temp2, "")
			}
			IfInString, A_LoopReadLine, IconPos_On_
			{
				StringSplit, ext_temp, A_LoopReadLine, =
				ext_temp2 = %ext_temp2%
				ext_temp2 := func_Deref(ext_temp2)
				IconPos_On_%EMExtName% = %ext_temp2%
				ReadIcon( EMExtName, "", ext_temp2 )
			}
			IfInString, A_LoopReadLine, RequireExtensions
			{
				StringSplit, ext_temp, A_LoopReadLine, =

				StringReplace, EMReqExtName, ext_temp2, %A_Space%,, A

				FunctionRequireExt[%EMExtName%] = %EMReqExtName%

				Loop, Parse, EMReqExtName, `,
				{
					If FunctionRequiredFromExt[%A_LoopField%] =
						FunctionRequiredFromExt[%A_LoopField%] = %EmExtName%
					Else
						IfNotInstring, FunctionRequiredFromExt[%A_LoopField%], %EmExtName%
							FunctionRequiredFromExt[%A_LoopField%] := FunctionRequiredFromExt[%A_LoopField%] "," EmExtName
				}
			}
			IfInString, A_LoopReadLine, FileInstall
			{
				IfNotInstring, A_LoopReadLine, .exe
					continue
				StringSplit, ext_temp, A_LoopReadLine, `,
				ExtensionExtraCompile[%EMExtName%] = %ext_temp2%
			}
			IfInString, A_LoopReadLine, SettingsGui_
				break

			Continue
		}
		If EMExtName =
			continue
		ExtensionFile[%EMExtName%] = %LoopFileName%
		StringReplace, ExtensionFile[%EMExtName%], ExtensionFile[%EMExtName%], %A_ScriptDir%\,

		EMfound = 0
		Loop, Read, %LoopFileName%
		{
			StringReplace,EMline,A_LoopReadLine,%A_Space%,,A

			IfInString, EMline, IfLng=%Lng%
				EMfound = 1

			IfNotInString, EMline, Description=
				Continue

			StringSplit, ext_temp, A_LoopReadLine, =

			StringReplace, ext_temp2, ext_temp2, ``n, `n, A

			If ((ExtensionDescription[%EMExtName%] = "" OR EMfound = 0) AND Enable_%EMExtName% = "")
			{
				ext_temp2 = %ext_temp2%
				ExtensionDescription[%EMExtName%] := func_Deref(ext_temp2)
			}

			If EMfound = 1
				break
		}
		EMFound = 0
		If Extension[%EMExtName%] =
		{
			Prefix := ExtensionPrefix[%EMExtName%]
			tmpHelp =
			Loop, Read, %LoopFileName%
			{
				If EMFound = 0
					IfNotInString, A_LoopReadLine, Help_%EMExtName%`:
						Continue
					Else
						EMFound = 1

				If EMFound < 4
				{
					EMFound++
					continue
				}
				If A_LoopReadLine = )
					break

				tmpHelp := tmpHelp "`r`n" A_LoopReadLine
			}
			%Prefix%_Help = %tmpHelp%
		}
	}
	Sort, InstalledExtensions, D|
	Sort, AvailableExtensions, D|

	IniWrite, %ExtensionsInExtDir%, %ConfigFile%, %ScriptName%, AvailableExtensions
	GuiControl, -Redraw, InstalledExtensionsBox
	GuiControl, -Redraw, AvailableExtensionsBox
	Gui, Add, Text, XS+240 YS+13, %lng_installed% %lng_Extensions%:
	Gui, Add, ListBox, -0x1000 Multi h200 w200 vInstalledExtensionsBox gsub_ExtISelect , %InstalledExtensions%
	Gui, Add, Text, XS+10 YS+13, %lng_available% %lng_Extensions%:
	Gui, Add, ListBox, -0x1000 Multi h200 w200 vAvailableExtensionsBox gsub_ExtASelect , %AvailableExtensions%
	Gui, Add, Button, -Wrap XS+10 Y+3 h47 gsub_EMContextHelp, ?
	Gui, Font, Underline
	Gui, Add, Text, X+5 YP+3 w500 -Wrap vEMAuthor ReadOnly,
	Gosub, GuiDefaultFont
	Gui, Add, Text, XP+0 Y+3 w500 R2 vEMDescription ReadOnly,
	Gui, Add, Picture, x+0 yp-10 H32 W32 vExtensionManagerGUIIcon
	Gui, Add, Button, -Wrap XS+213 YS+70 gsub_AllExtAdd, >>
	Gui, Add, Button, -Wrap XS+216 Y+5 gsub_ExtAdd, >
	Gui, Add, Button, -Wrap Y+5 gsub_ExtRem, <
	Gui, Add, Button, -Wrap XS+213 Y+5 gsub_AllExtRem, <<
	Gui, Font, S%FontSize7%, Arial
	Gui, Add, Text, YS+32 XS+450 W110 R16, %lng_ExtensionManagerHelp%
	Gosub, GuiDefaultFont
	InstalledExtensionsBefore = %InstalledExtensions%
	GuiControl, +Redraw, InstalledExtensionsBox
	GuiControl, +Redraw, AvailableExtensionsBox
	If DuplicateExtensions <>
	{
		Gui, Font, Caa0000 Normal
		StringTrimRight, DuplicateExtensions, DuplicateExtensions, 2
		Gui, Add, Text, YS+290 XS+10 w550, %lng_DuplicateExtensions%:
		Gui, Font, C660000 Normal
		Gui, Add, Text, Y+1 w550, %DuplicateExtensions%
		Gosub, GuiDefaultFont
	}
Return

sub_ExtISelect:
	GuiDefault("activAid")
	PostMessage, 0x185, 0, -1, ListBox2 ; LB_SETSEL, Selektion aufheben

	GuiControlGet, ExtI_selection, , InstalledExtensionsBox
	If ExtI_selection =
	{
		GuiControl,, EMAuthor,
		GuiControl,, EMDescription,
		Return
	}
	ExtI_selected =
	Loop, Parse, ExtI_selection, |
	{
		IfNotInString, ExtI_LastSelection, |%A_LoopField%|
			ExtI_selected = %A_LoopField%
	}

	If ExtI_selected =
	{
		IfInString, ExtI_Selection, |
		{
			Loop, Parse, ExtI_selection, |
				StringReplace, ExtI_LastSelection, ExtI_LastSelection, |%A_LoopField%|, |
			StringReplace, ExtI_selected, ExtI_LastSelection, |,,A
		}
		Else
			ExtI_selected = %ExtI_Selection%
		IfNotInString, ExtI_Selection, %ExtI_selected%
		{
			ExtI_selected := func_StrLeft(ExtI_Selection,InStr(ExtI_Selection,"|")-1)
		}
	}
	ExtI_LastSelection = |%ExtI_selection%|

	ExtAppend =
	If FunctionRequireExt[%ExtI_selected%] <>
		ExtAppend := " (" lng_requires " " FunctionRequireExt[%ExtI_selected%] ")"
	Prefix := ExtensionPrefix[%ExtI_selected%]
	GuiControl,, EMAuthor, % ExtI_selected " v" ExtensionVersion[%ExtI_selected%] " " lng_by " " %Prefix%_Author
	GuiControl,, EMDescription, % ExtensionDescription[%ExtI_selected%] ExtAppend
	Context = %ExtI_selected%

	EMExtIconPos := TrayIconPos[%ExtI_selected%]
	EMExtIcon := TrayIcon[%ExtI_selected%]
	GuiControl,, ExtensionManagerGUIIcon, *icon%EMExtIconPos% %EMExtIcon%

	If (A_GuiControlEvent = "DoubleClick" AND ExtNoDoubleClick <> 1)
		Gosub, sub_ExtRem
Return

sub_ExtASelect:
	GuiDefault("activAid")
	PostMessage, 0x185, 0, -1, ListBox1 ; LB_SETSEL, Selektion aufheben

	GuiControlGet, ExtA_selection, , AvailableExtensionsBox
	If ExtA_selection =
	{
		GuiControl,, EMAuthor,
		GuiControl,, EMDescription,
		Return
	}
	ExtA_selected =
	Loop, Parse, ExtA_selection, |
	{
		IfNotInString, ExtA_LastSelection, |%A_LoopField%|
			ExtA_selected = %A_LoopField%
	}
	If ExtA_selected =
	{
		IfInString, ExtA_Selection, |
		{
			Loop, Parse, ExtA_selection, |
				StringReplace, ExtA_LastSelection, ExtA_LastSelection, |%A_LoopField%|, |
			StringReplace, ExtA_selected, ExtA_LastSelection, |,,A
		}
		Else
			ExtA_selected = %ExtA_Selection%
		IfNotInString, ExtA_Selection, %ExtA_selected%
		{
			ExtA_selected := func_StrLeft(ExtA_Selection,InStr(ExtA_Selection,"|")-1)
		}
  }
	ExtA_LastSelection = |%ExtA_selection%|

	ExtAppend =
	If FunctionRequireExt[%ExtA_selected%] <>
		ExtAppend := " (" lng_requires " " FunctionRequireExt[%ExtA_selected%] ")"
	Prefix := ExtensionPrefix[%ExtA_selected%]
	GuiControl,, EMAuthor, % ExtA_selected " v" ExtensionVersion[%ExtA_selected%] " " lng_by " " %Prefix%_Author
	GuiControl,, EMDescription, % ExtensionDescription[%ExtA_selected%] ExtAppend
	Context = %ExtA_selected%

	EMExtIconPos := TrayIconPos[%ExtA_selected%]
	EMExtIcon := TrayIcon[%ExtA_selected%]
	GuiControl,, ExtensionManagerGUIIcon, *icon%EMExtIconPos% %EMExtIcon%

	If (A_GuiControlEvent = "DoubleClick" AND ExtNoDoubleClick <> 1)
		Gosub, sub_ExtAdd
Return

sub_ExtAdd:
	GuiControlGet, ExtA_selection, , AvailableExtensionsBox
	Loop, Parse, ExtA_selection, |
	{
		ExtA_selected = %A_LoopField%
		If ExtA_selected <>
			Gosub, sub_ExtAdd2
	}
	ExtNoDoubleClick = 1
	Gosub, sub_ExtASelect
	ExtNoDoubleClick = 0
Return

sub_ExtAdd2:
	GuiControlGet,AvailableExtensionsBoxHwnd, Hwnd, AvailableExtensionsBox
	GetScrollInfo(AvailableExtensionsBoxHwnd, 1, AvailableExtensionsBoxPos, AvailableExtensionsBoxPage, AvailableExtensionsBoxMin, AvailableExtensionsBoxMax, AvailableExtensionsBoxTrackPos)    ; Gets scroll bar position and things
	If FunctionRequireExt[%ExtA_selected%] <>
	{
		Loop, Parse, FunctionRequireExt[%ExtA_selected%], `,
		{
			If A_LoopField =
				break
			IfNotInstring, InstalledExtensions, %A_LoopField%
			{
				Gui %GuiID_activAid%:+OwnDialogs
				ext_temp := lng_requiresAddMsg "`n" FunctionRequireExt[%ExtA_selected%]
				msgbox, 16,%ScriptTitle%, %ext_temp%
				return
			}
		}
	}

	If InstalledExtensions =
		InstalledExtensions = %ExtA_selected%|
	Else
		InstalledExtensions = %ExtA_selected%|%InstalledExtensions%
	Sort, InstalledExtensions, D|
	StringReplace, InstalledExtensions, InstalledExtensions, ||, |, A
	StringReplace, InstalledExtensions, InstalledExtensions, %ExtA_selected%|, %ExtA_selected%||, A
	GuiControl,,InstalledExtensionsBox, |%InstalledExtensions%
	StringReplace, InstalledExtensions, InstalledExtensions, ||, |, A
	AvailableExtensions := RegExReplace(AvailableExtensions, ExtA_selected "\|([^|]*\||$)", "$1|")
	StringLeft, EMfirst, AvailableExtensions, 1
	If EMfirst = |
		StringTrimLeft, AvailableExtensions, AvailableExtensions, 1
	GuiControl,,AvailableExtensionsBox, |%AvailableExtensions%
	StringReplace, AvailableExtensions, AvailableExtensions, ||, |, A
	SetScrollPos(AvailableExtensionsBoxHwnd, 1, AvailableExtensionsBoxPos)    ; Sets scroll bar position and things

	ChangedSettings[activAid]= |
	Gosub, sub_EnableDisable_ApplyButton
Return

sub_AllExtAdd:
	InstalledExtensions = %InstalledExtensions%|%AvailableExtensions%
	AvailableExtensions =
	Sort, InstalledExtensions, D|
	StringLeft, EMfirst, InstalledExtensions, 1
	If EMfirst = |
		StringTrimLeft, InstalledExtensions, InstalledExtensions, 1
	GuiControl,,InstalledExtensionsBox, |%InstalledExtensions%
	GuiControl,,AvailableExtensionsBox, |%AvailableExtensions%
	ChangedSettings[activAid]= |
	Gosub, sub_EnableDisable_ApplyButton
	Gosub, sub_ExtASelect
Return

sub_ExtRem:
	GuiControlGet, ExtI_selection, , InstalledExtensionsBox
	Loop, Parse, ExtI_selection, |
	{
		ExtI_selected = %A_LoopField%
		If ExtI_selected <>
			Gosub, sub_ExtRem2
	}
	ExtNoDoubleClick = 1
	Gosub, sub_ExtISelect
	ExtNoDoubleClick = 0
Return

sub_ExtRem2:
	GuiControlGet,InstalledExtensionsBoxHwnd, Hwnd, InstalledExtensionsBox
	GetScrollInfo(InstalledExtensionsBoxHwnd, 1, InstalledExtensionsBoxPos, InstalledExtensionsBoxPage, InstalledExtensionsBoxMin, InstalledExtensionsBoxMax, InstalledExtensionsBoxTrackPos)    ; Gets scroll bar position and things
	If FunctionRequiredFromExt[%ExtI_selected%] <>
	{
		Loop, Parse, FunctionRequiredFromExt[%ExtI_selected%], `,
		{
			If A_LoopField =
				break
			IfInstring, InstalledExtensions, %A_LoopField%
			{
				Gui %GuiID_activAid%:+OwnDialogs
				ext_temp := lng_requiresRemMsg "`n" FunctionRequiredFromExt[%ExtI_selected%]
				msgbox, 16,%ScriptTitle%,%ext_temp%
				return
			}
		}
	}

	If AvailableExtensions =
		AvailableExtensions = %ExtI_selected%|
	Else
		AvailableExtensions = %ExtI_selected%|%AvailableExtensions%
	Sort, AvailableExtensions, D|
	StringReplace, AvailableExtensions, AvailableExtensions, ||, |, A
	StringReplace, AvailableExtensions, AvailableExtensions, %ExtI_selected%|, %ExtI_selected%||, A
	GuiControl,,AvailableExtensionsBox, |%AvailableExtensions%
	StringReplace, AvailableExtensions, AvailableExtensions, ||, |, A
	InstalledExtensions := RegExReplace(InstalledExtensions, ExtI_selected "\|([^|]*\||$)", "$1|")
	StringLeft, EMfirst, InstalledExtensions, 1
	If EMfirst = |
		StringTrimLeft, InstalledExtensions, InstalledExtensions, 1
	GuiControl,,InstalledExtensionsBox, |%InstalledExtensions%
	StringReplace, InstalledExtensions, InstalledExtensions, ||, |, A

	SetScrollPos(InstalledExtensionsBoxHwnd, 1, InstalledExtensionsBoxPos)    ; Sets scroll bar position and things

	ChangedSettings[activAid]= |
	Gosub, sub_EnableDisable_ApplyButton
Return

sub_AllExtRem:
	AvailableExtensions = %AvailableExtensions%|%InstalledExtensions%
	InstalledExtensions =
	Sort, AvailableExtensions, D|
	StringLeft, EMfirst, AvailableExtensions, 1
	If EMfirst = |
		StringTrimLeft, AvailableExtensions, AvailableExtensions, 1
	GuiControl,,InstalledExtensionsBox, |%InstalledExtensions%
	GuiControl,,AvailableExtensionsBox, |%AvailableExtensions%

	ChangedSettings[activAid]= |
	Gosub, sub_EnableDisable_ApplyButton
	Gosub, sub_ExtISelect
Return

sub_ExtInstall:
	StringReplace, InstalledExtensions, InstalledExtensions, ||, |, A
	StringSplit, InstalledExtensions, InstalledExtensions, |

	If InstalledExtensions = %InstalledExtensionsBefore%
		Return

	Debug("GUI", A_LineNumber, A_LineFile, "(Un)Installing extensions ..." )

	ChangedSettings++

	FileDelete, settings\_temp.tmp

	Loop, Parse, InstalledExtensionsBefore, |
	{
		IfInString, InstalledExtensions, %A_LoopField%|
			continue

		If (IsLabel( "UnInstallExt_" A_LoopField ))
			Gosub, UnInstallExt_%A_LoopField%
	}

	Loop, Parse, InstalledExtensions, |
	{
		IfNotInString, InstalledExtensionsBefore, %A_LoopField%|
			IniWrite, 1, %ConfigFile%, activAid, Enable_%A_LoopField%
	}

	Loop, Read, settings\extensions_header.ini, settings\_temp.tmp
	{
		IfNotInString A_LoopReadLine, CustomIncludes
		{
			FileAppend, %A_LoopReadLine%`n
			continue
		}
		break
	}
	FileAppend, CustomIncludes = 1`n, settings\_temp.tmp
	Loop
	{
		If InstalledExtensions%A_Index% =
			break
		ext_temp := A_Index
		FileAppend, % "Extension[" ext_temp "] = " InstalledExtensions%A_Index% "`n", settings\_temp.tmp
	}

	Debug("GUI", A_LineNumber, A_LineFile, "Writing new extensions_header.ini" )
	FileMove, settings\_temp.tmp, settings\extensions_header.ini, 1
	FileDelete, settings\_temp.tmp

	Loop, Read, settings\extensions_main.ini, settings\_temp.tmp
	{
		IfNotInString, A_LoopReadLine, #Include *i
		{
			FileAppend, %A_LoopReadLine%`n
			continue
		}
		break
	}
	Loop
	{
		If InstalledExtensions%A_Index% =
			break
		ExtensionName := InstalledExtensions%A_Index%
		ExtensionFile := ExtensionFile[%ExtensionName%]
;      If A_WorkingDir <> %A_ScriptDir%
;         FileAppend, % "#Include *i " A_ScriptDir "\" ExtensionFile " `;" ExtensionName "`n", settings\_temp.tmp
;      Else
;         FileAppend, % "#Include *i " ExtensionFile " `;" ExtensionName "`n", settings\_temp.tmp
		FileAppend, % "#Include *i %A_ScriptDir%\" ExtensionFile " `;" ExtensionName "`n", settings\_temp.tmp

	}
	Debug("GUI", A_LineNumber, A_LineFile, "Writing new extensions_main.ini" )

	FileDelete, settings\extensions_main.ini
	FileMove, settings\_temp.tmp, settings\extensions_main.ini, 1
	FileDelete, settings\_temp.tmp

	Reload = 1
Return

func_ReplaceExtension( OldExt, NewExt )
{
	global

	IfNotExist, extensions\ac'tivAid_%OldExt%.ahk
		Return

	FileDelete, extensions\ac'tivAid_%OldExt%.ahk

	FileRead, ExtMain, settings\extensions_main.ini
	StringReplace, ExtMain, ExtMain, _%OldExt%.ahk, _%NewExt%.ahk, A
	StringReplace, ExtMain, ExtMain, `;%OldExt%, `;%NewExt%, A
	FileDelete, settings\extensions_main.ini
	FileAppend, %ExtMain%, settings\extensions_main.ini

	FileRead, ExtHeader, settings\extensions_header.ini
	StringReplace, ExtHeader, ExtHeader, = %OldExt%, = %NewExt%, A
	FileDelete, settings\extensions_header.ini
	FileAppend, %ExtHeader%, settings\extensions_header.ini

	FileRead, ExtSettings, %ConfigFile%
	StringReplace, ExtSettings, ExtSettings, [%OldExt%], [%NewExt%], A
	StringReplace, ExtSettings, ExtSettings, _%OldExt%, _%NewExt%, A
	StringReplace, ExtSettings, ExtSettings, %OldExt%_, %NewExt%_, A
	FileDelete, %ConfigFile%
	FileAppend, %ExtSettings%, %ConfigFile%
}

func_RemoveExtension(ExtName)
{
	FileRead, ExtMain, settings\extensions_main.ini
	Loop, Parse, ExtMain, `n, `r
	{
		IfNotInString, A_LoopField, _%ExtName%.ahk
			NewExtMain = %NewExtMain%%A_LoopField%`n
	}

	FileDelete, settings\extensions_main.ini
	FileAppend, %NewExtMain%, settings\extensions_main.ini

	FileRead, ExtHeader, settings\extensions_header.ini
	NewExtHeaderNumber = 1
	Loop, Parse, ExtHeader, `n, `r
	{
		IfInString, A_LoopField, = %ExtName%
			continue
		NewExtHeader = % NewExtHeader RegExReplace(A_LoopField,"\[\d+\] *=","[" NewExtHeaderNumber "] =") "`n"
		IfInString, A_LoopField, Extension[
			NewExtHeaderNumber++
	}
	FileDelete, settings\extensions_header.ini
	FileAppend, %NewExtHeader%, settings\extensions_header.ini
}

func_AddExtension(ExtName)
{
	FileRead, NewExtMain, settings\extensions_main.ini
	IfNotInString, NewExtMain, extensions\ac'tivAid_%ExtName%.ahk
		NewExtMain = %NewExtMain%#Include *i `%A_ScriptDir`%\extensions\ac'tivAid_%ExtName%.ahk `;%ExtName%`n
	FileDelete, settings\extensions_main.ini
	FileAppend, %NewExtMain%, settings\extensions_main.ini

	FileRead, ExtHeader, settings\extensions_header.ini
	NewExtHeaderNumber = 1
	Loop, Parse, ExtHeader, `n, `r
	{
		NewExtHeader = % NewExtHeader RegExReplace(A_LoopField,"\[\d+\] *=","[" NewExtHeaderNumber "] =") "`n"
		IfInString, A_LoopField, Extension[
			NewExtHeaderNumber++
	}
	NewExtHeader = %NewExtHeader%Extension[%NewExtHeaderNumber%] = %ExtName%`n
	FileDelete, settings\extensions_header.ini
	FileAppend, %NewExtHeader%, settings\extensions_header.ini
}
