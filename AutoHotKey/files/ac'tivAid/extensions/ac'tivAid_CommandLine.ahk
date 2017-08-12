; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               CommandLine
; -----------------------------------------------------------------------------
; Prefix:             cl_
; Version:            0.81
; Date:               2007-04-24
; Author:             Wolfgang Reszel
;                     Nach einem Skript von Rajat
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
;
; Changes:            2005-11-01, V0.5, dirk.schwarzmann@gmx.de
;                     - Option für Auswahl des Kommandoprozessors hinzugefügt
; Changes:            2005-11-08, V0.6, dirk.schwarzmann@gmx.de
;                     - Button für Standard-Kommandoprozessor hinzugefügt
;                     - Textfeld editierbar gemacht
; Changes:            2009-12-22, v0.81, eric@goodsoul.de
;					  - ahkClass cl_ClassesGroup eingefügt und Hotkey darauf
;						gemappt. globaler Hotkey raus
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_CommandLine:
	Prefix = cl
	%Prefix%_ScriptName    = CommandLine
	%Prefix%_ScriptVersion = 0.8
	%Prefix%_Author        = Wolfgang Reszel, Dirk Schwarzmann

	IconFile_On_CommandLine = %A_WinDir%\system32\cmd.exe
	IconPos_On_CommandLine = 1

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %cl_ScriptName% - Explorer Adressleiste als Kommandozeile`t<
		Description                   = Dos-Kommandos lassen sich direkt in der Adressleiste des Explorers eingeben (ein < muss vorangestellt werden).
		lng_cl_CommandProcessor       = Kommandoprozessor:
		lng_cl_CommandParameterC      = Parameter für << (versteckte Ausführung):
		lng_cl_CommandParameterK      = Parameter für < (sichtbare Ausführung):
		lng_cl_FileType               = Ausführbare Datei (*.exe)
		lng_cl_Default                = Standard
	}
	else        ; = other languages (english)
	{
		MenuName                   = %cl_ScriptName% - explorer address-bar as command-line`t<
		Description                = The address-bar of an explorer-window will act as a command-line if entries are prefixed by <.
		lng_cl_CommandProcessor    = Command processor:
		lng_cl_CommandParameterC   = Parameters for << (hidden execution):
		lng_cl_CommandParameterK   = Parameters for < (visible execution):
		lng_cl_FileType            = Executable (*.exe)
		lng_cl_Default             = Default
	}
	If CustomLanguage <>
		gosub, CustomLanguage

	IniRead, cl_CommandFile, %ConfigFile%, %cl_ScriptName%, CommandProcessor, %ComSpec%
	IniRead, cl_CommandParameterC, %ConfigFile%, %cl_ScriptName%, CommandParameterC, /c
	IniRead, cl_CommandParameterK, %ConfigFile%, %cl_ScriptName%, CommandParameterK, /k
	
	GroupAdd, cl_ClassesGroup, ahk_class CabinetWClass
	GroupAdd, cl_ClassesGroup, ahk_class ExploreWClass
Return

SettingsGui_CommandLine:
	Gui, Add, Text, xs+10 y+8, %lng_cl_CommandProcessor%
	Gui, Add, Edit, x+10 yp-3 r1 w260 gsub_CheckIfSettingsChanged vcl_CommandFile, %cl_CommandFile%
	Gui, Add, Button, -Wrap x+5 yp-1 W100 gcl_sub_Browse, %lng_Browse%
	Gui, Add, Button, -Wrap x+5 W70 gcl_sub_SetDefault, %lng_cl_default%
	Gui, Add, Text, xs+10 w200 y+15, %lng_cl_CommandParameterK%
	Gui, Add, Edit, x+10 yp-3 r1 w200 gsub_CheckIfSettingsChanged vcl_CommandParameterK, %cl_CommandParameterK%
	Gui, Add, Text, xs+10 w200 y+8, %lng_cl_CommandParameterC%
	Gui, Add, Edit, x+10 yp-3 r1 w200 gsub_CheckIfSettingsChanged vcl_CommandParameterC, %cl_CommandParameterC%
Return

SaveSettings_CommandLine:
	IniWrite, %cl_CommandFile%, %ConfigFile%, %cl_ScriptName%, CommandProcessor
	IniWrite, %cl_CommandParameterC%, %ConfigFile%, %cl_ScriptName%, CommandParameterC
	IniWrite, %cl_CommandParameterK%, %ConfigFile%, %cl_ScriptName%, CommandParameterK
Return

CancelSettings_CommandLine:
Return

; Hotkeys now embedded in the Enable/Diable subroutines:
DoEnable_CommandLine:
	Hotkey, IfWinActive, ahk_group cl_ClassesGroup
	Hotkey, ~$Enter, cl_main_CommandLine_invoke, On
Return

DoDisable_CommandLine:
	Hotkey, IfWinActive, ahk_group cl_ClassesGroup
	Hotkey, ~$Enter, cl_main_CommandLine_invoke, Off
Return

DefaultSettings_CommandLine:
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

cl_main_CommandLine_invoke:
	WinGetClass, cl_winClass, A
	WinGet, cl_winID, ID, A

	If cl_winClass in CabinetWClass,ExploreWClass
	{
		WinGetText, cl_activeWinText, ahk_id %cl_winID%

		IfInString, cl_activeWinText, MSNTB_Window ; MSN-Toolbar?
			cl_EditClass = Edit2
		Else
			cl_EditClass = Edit1

		ControlGetFocus, cl_Control, A
		If cl_Control = %cl_EditClass%
		{
			ControlGetText, cl_Command, %cl_EditClass%, A

			StringLeft, cl_CmdLeft, cl_Command, 1
			StringLeft, cl_CmdLeft2, cl_Command, 2

			If (cl_CmdLeft <> "<" AND cl_CmdLeft2 <> "<<")
				Return
			Send,{ESC}

			RegRead, cl_FullPath, HKCU,Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState,FullPath
			RegRead, cl_FullPathAddress, HKCU,Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState,FullPathAddress
			If (aa_osversionnumber >= aa_osversionnumber_vista AND cl_FullPathAddress = "")
				cl_FullPathAddress = 1

			If cl_FullPathAddress = 1
			{
				If cl_path =
				{
					Send,^z
					Sleep,100
					cl_path := func_GetDir( cl_winID )
					Send,^z{Right}
				}
			}
			Else If cl_FullPath = 1
			{
				cl_path := func_GetDir( cl_winID )
			}

			If cl_path =
			{
				BalloonTip(ScriptTitle " - " cl_ScriptName, lng_CheckYourFolderOptions "!", "Info")
				Return
			}

			StringLeft, cl_CmdLeft, cl_Command, 2

			If (cl_CmdLeft = "<<")
			{
				StringTrimLeft, cl_Command, cl_Command, 2
				run, % func_Deref(cl_CommandFile) " " cl_CommandParameterC " " cl_Command, %cl_path%, hide
			}
			Else
			{
				StringLeft, cl_CmdLeft, cl_Command, 1

				If (cl_CmdLeft = "<")
				{
					StringTrimLeft, cl_Command, cl_Command, 1
					run, % func_Deref(cl_CommandFile) " " cl_CommandParameterK " " cl_Command, %cl_path%
				}
			}
		}
	}

	cl_path =
Return

cl_sub_Browse:
	Gui +OwnDialogs
	Fileselectfile, cl_CommandFileTmp, 3,,,%lng_cl_FileType%
	If cl_CommandFileTmp <>
		GuiControl,,cl_CommandFile, %cl_CommandFileTmp%
Return

cl_sub_SetDefault:
	cl_CommandFile = %ComSpec%
	GuiControl,,cl_CommandFile, %ComSpec%
Return
