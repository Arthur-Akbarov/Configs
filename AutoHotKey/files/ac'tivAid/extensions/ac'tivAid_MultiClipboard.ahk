; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               MultiClipboard
; -----------------------------------------------------------------------------
; Prefix:             mcb_
; Version:            0.8
; Date:               2008-05-23
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_MultiClipboard:
	Prefix                 = mcb
	%Prefix%_ScriptName    = MultiClipboard
	%Prefix%_ScriptVersion = 0.8
	%Prefix%_Author        = Wolfgang Reszel

	CustomHotkey_MultiClipboard  = 1          ; Benutzerdefiniertes Hotkey
	Hotkey_MultiClipboard        = ^+0        ; Standard-Hotkey
	HotkeyPrefix_MultiClipboard  = $          ; Präfix

	IconFile_On_MultiClipboard = %A_WinDir%\system32\shell32.dll
	IconPos_On_MultiClipboard = 55

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %mcb_ScriptName% - Mehrere Zwischenablagen
		Description                   = Stellt 9 oder 19 weitere Zwischenablagen zur Verfügung, welche über den Systemstart hinaus erhalten bleiben.
		lng_mcb_BalloonTips           = Sprechblasenhinweise anzeigen
		lng_mcb_Number                = Nr.
		lng_mcb_Copy                  = Tastaturkürzel für Kopieren
		lng_mcb_Paste                 = Tastaturkürzel für Einfügen
		lng_mcb_ClipboardCopied       = Zwischenablage ### wurde kopiert
		lng_mcb_ClipboardPasted       = Zwischenablage ### wurde eingefügt
		lng_mcb_ClipboardPasteError   = Zwischenablage ### ist leer
		lng_mcb_ClipboardNotCopied    = Die Auswahl wurde nicht von MultiClipboard gespeichert, da sie im Speicher mehr als ### MB belegt.
		lng_mcb_ClearClipboards       = Gespeicherte Zwischenablagen löschen
		lng_mcb_ClearOnReload         = beim Start von ac'tivAid löschen (nicht beim neu Laden)
		lng_mcb_MetaFile              = << Bilddatei oder Metafile >>
		lng_mcb_Empty                 = << leer >>
		lng_mcb_File                  = << Datei:
		lng_mcb_Folder                = << Verzeichnis:
		lng_mcb_MenuCopy              = Kopieren
		lng_mcb_MenuPaste             = Einfügen
		lng_mcb_MonitorCopy           = Strg+C und Strg+X überwachen
		lng_mcb_NoPlainClip           = Zwischenablage
		lng_mcb_Additional_Clip       = 10 weitere Zwischenablagen im Menü aufführen
		lng_mcb_DontRestoreClipboard  = Standard-Zwischenablage überschreiben
		lng_mcb_NoCopyMenu            = Das Menü zeigt nur Einträge zum Einfügen
		lng_mcb_PasteMovesToTop       = Die eingefügte Zwischenablage wird an den Anfang des Menüs geschoben
		lng_mcb_TrimNewLines          = Zeilenschaltungen am Anfang und Ende entfernen
		lng_mcb_TrimSpaceAndTab       = Leerzeichen und Tabs am Anfang und Ende entfernen
		lng_mcb_Pasting               = Einfügen ...
		lng_mcb_UsePlainText          = Zwischenablagen immer als reinen Text kopieren/einfügen (ähnlich PastePlain)

		tooltip_mcb_BalloonTips       = Aus = Es werden keine Sprechblasenhinweise angezeigt`nAktiviert = Es werden nur Fehler angezeigt`nGrau/Grün = Es werden Fehler und auch Kopieren oder Einfügen angezeigt
	}
	else        ; = other languages (english)
	{
		MenuName                      = %mcb_ScriptName% - multiple Clipboards
		Description                   = Gives 9 or 19 additional Clipboards which are preserved through system restarts
		lng_mcb_BalloonTips           = Show BalloonTips
		lng_mcb_Number                = No.
		lng_mcb_Copy                  = Hotkeys for copying
		lng_mcb_Paste                 = Hotkeys for pasting
		lng_mcb_ClipboardCopied       = Clipboard ### has been copied
		lng_mcb_ClipboardPasted       = Clipboard ### has been pasted
		lng_mcb_ClipboardPasteError   = Clipboard ### is empty
		lng_mcb_ClipboardNotCopied    = The selection has not been stored by MultiClipboard because its size in memory is bigger than ### MB.
		lng_mcb_ClearClipboards       = Clear stored clipboards
		lng_mcb_ClearOnReload         = Clear at every start of ac'tivAid (not reload)
		lng_mcb_MetaFile              = << image or metafile >>
		lng_mcb_Empty                 = << empty >>
		lng_mcb_File                  = << File:
		lng_mcb_Folder                = << Folder:
		lng_mcb_MenuCopy              = Copy
		lng_mcb_MenuPaste             = Paste
		lng_mcb_MonitorCopy           = Monitor Ctrl+C and Ctrl+X
		lng_mcb_NoPlainClip           = Clipboard
		lng_mcb_Additional_Clip       = 10 additional clipboards in menu
		lng_mcb_DontRestoreClipboard  = Don't restore standard clipboard
		lng_mcb_NoCopyMenu            = Show only the paste-entries in the menu
		lng_mcb_PasteMovesToTop       = Move the pasted clipboard to the top of the menu
		lng_mcb_TrimNewLines          = Remove newlines at the beginning and the end
		lng_mcb_TrimSpaceAndTab       = Remove Space and Tab characters at the beginning and the end
		lng_mcb_Pasting               = Pasting ...
		lng_mcb_UsePlainText          = Paste/copy always as plain text

		tooltip_mcb_BalloonTip        = Off = No BalloonTips`nActive = Show errors`nGrey/Green = Shows errors and copying or pasting
	}
	If CustomLanguage <>
		gosub, CustomLanguage

	lng_mcb_sub_ClearClipboards   = %lng_mcb_ClearClipboards%
	RegisterAdditionalSetting( "mcb", "sub_ClearClipboards", 0, "Type:SubRoutine")
	RegisterAdditionalSetting( "mcb", "Additional_Clip", 0 )
	RegisterAdditionalSetting( "mcb", "DontRestoreClipboard", 0 )
	RegisterAdditionalSetting( "mcb", "NoCopyMenu", 0 )
	RegisterAdditionalSetting( "mcb", "PasteMovesToTop", 0 )
	RegisterAdditionalSetting( "mcb", "TrimNewLines", 0 )
	RegisterAdditionalSetting( "mcb", "TrimSpaceAndTab", 0 )
	RegisterAdditionalSetting( "mcb", "UsePlainText", 0 )

	Loop, 9
	{
		mcb_Index := A_Index
		func_HotkeyRead( "mcb_Copy" A_Index, ConfigFile, mcb_ScriptName, "CopyHotkey" A_Index, "mcb_sub_Copy", "#!" mcb_Index , "$" )
		func_HotkeyRead( "mcb_Paste" A_Index, ConfigFile, mcb_ScriptName, "PasteHotkey" A_Index, "mcb_sub_Paste", "#+" mcb_Index , "$" )
		registerAction("MultiClipboard_Paste" A_Index, lng_mcb_MenuPaste " " mcb_Index, "mc_sub_Action_Paste", A_Index)
		registerAction("MultiClipboard_Copy" A_Index, lng_mcb_MenuCopy " " mcb_Index, "mc_sub_Action_Copy", A_Index)
	}
	IniRead, mcb_BalloonTips, %ConfigFile%, %mcb_ScriptName%, BalloonTips, 1
	IniRead, mcb_BalloonTimeout, %ConfigFile%, %mcb_ScriptName%, BalloonTimeout, 3
	IniRead, mcb_ClearOnReload, %ConfigFile%, %mcb_ScriptName%, ClearOnReload, 0
	IniRead, mcb_MonitorCopy, %ConfigFile%, %mcb_ScriptName%, MonitorCopy, 0
	IniRead, mcb_AdditionalClipboards, %ConfigFile%, %mcb_ScriptName%, AdditionalClipboards, 10
	IniRead, mcb_ClipSizeLimitMB, %ConfigFile%, %mcb_ScriptName%, ClipSizeLimit, 16
	IniRead, mcb_ExcludeApps, %ConfigFile%, %mcb_ScriptName%, ExcludeApps, %A_Space%
	mcb_ClipSizeLimit := mcb_ClipSizeLimitMB * 1024 * 1024

	StringReplace, lng_mcb_Additional_Clip, lng_mcb_Additional_Clip, 10, %mcb_AdditionalClipboards%
	mcb_AdditionalClipboards := 9 + mcb_AdditionalClipboards
	StringReplace, Description, Description, 19, %mcb_AdditionalClipboards%

	IfNotExist, settings/Clipboards
		FileCreateDir, settings/Clipboards

	If (mcb_ClearOnReload = 1 AND LastExitReason <> "Reload")
		Gosub, mcb_sub_ClearClipboards
Return

SettingsGui_MultiClipboard:
	Gui, Add, CheckBox, gsub_CheckIfSettingsChanged vmcb_MonitorCopy x+5 yp+4 -Wrap Checked%mcb_MonitorCopy%, %lng_mcb_MonitorCopy%

	Gui, Add, Text, xs+5 y+9 w25 Right, %lng_mcb_Number%
	Gui, Add, Text, x+5 w250, %lng_mcb_Copy%
	Gui, Add, Text, x+15 w250, %lng_mcb_Paste%
	Loop, 9
	{
		Gui, Add, Text, xs+10 y+5 Right w20, %A_Index%:
		func_HotkeyAddGuiControl( "", "mcb_Copy" A_Index, "x+5 yp-3 w260" )
		func_HotkeyAddGuiControl( "", "mcb_Paste" A_Index, "x+5 w260" )
	}
	Gui, Add, Button, -wrap xs+35 y+10 gmcb_sub_ClearClipboards, %lng_mcb_ClearClipboards%
	mcb_NumOfClipFiles = 0
	Loop, %mcb_AdditionalClipboards%
	{
		IfExist, settings/Clipboards/MCB_Clip%A_Index%.dat
			mcb_NumOfClipFiles++
	}
	Gui, Add, Text, x+5 yp+5 vmcb_NumOfClipFiles, %mcb_NumOfClipFiles%
	Gui, Add, CheckBox, gsub_CheckIfSettingsChanged vmcb_ClearOnReload x+20 -Wrap Checked%mcb_ClearOnReload%, %lng_mcb_ClearOnReload%

	Gui, Add, CheckBox, gsub_CheckIfSettingsChanged vmcb_BalloonTips Check3 xs+250 ys+290 -Wrap Checked%mcb_BalloonTips%, %lng_mcb_BalloonTips%
	If mcb_NumOfClipFiles = 0
		GuiControl, Disable, %lng_mcb_ClearClipboards%
Return

SaveSettings_MultiClipboard:
	Loop, 9
	{
		func_HotkeyWrite( "mcb_Copy" A_Index, ConfigFile, mcb_ScriptName, "CopyHotkey" A_Index )
		func_HotkeyWrite( "mcb_Paste" A_Index, ConfigFile, mcb_ScriptName, "PasteHotkey" A_Index )
	}
	IniWrite, %mcb_BalloonTips%, %ConfigFile%, %mcb_ScriptName%, BalloonTips
	IniWrite, %mcb_BalloonTimeout%, %ConfigFile%, %mcb_ScriptName%, BalloonTimeout
	IniWrite, %mcb_ClearOnReload%, %ConfigFile%, %mcb_ScriptName%, ClearOnReload
	IniWrite, %mcb_MonitorCopy%, %ConfigFile%, %mcb_ScriptName%, MonitorCopy
	mcb_AdditionalClipboards := mcb_AdditionalClipboards - 9
	IniWrite, %mcb_AdditionalClipboards%, %ConfigFile%, %mcb_ScriptName%, AdditionalClipboards
	mcb_AdditionalClipboards := mcb_AdditionalClipboards + 9
	IniWrite, %mcb_ClipSizeLimitMB%, %ConfigFile%, %mcb_ScriptName%, ClipSizeLimit
	IniWrite, %mcb_ExcludeApps%, %ConfigFile%, %mcb_ScriptName%, ExcludeApps



	If %mcb_Additional_Clip% = 0
	{
		Loop, %mcb_AdditionalClipboards%
		{
			if A_Index > 9
			{
				FileDelete, settings/Clipboards/MCB_Clip%A_Index%.dat
			}
		}
	}
Return

CancelSettings_MultiClipboard:
Return

DoEnable_MultiClipboard:
	Loop, 9
	{
		func_HotkeyEnable( "mcb_Copy" A_Index )
		func_HotkeyEnable( "mcb_Paste" A_Index )
	}
	If mcb_MonitorCopy = 1
	{
		RegisterHook( "OnClipboardChange", "MultiClipboard")
	}
Return

DoDisable_MultiClipboard:
	Loop, 9
	{
		func_HotkeyDisable( "mcb_Copy" A_Index )
		func_HotkeyDisable( "mcb_Paste" A_Index )
	}
	UnRegisterHook( "OnClipboardChange", "MultiClipboard")
Return

DefaultSettings_MultiClipboard:
Return

; ---------------------------------------------------------------------
; -- Tastaturkürzel ---------------------------------------------------
; ---------------------------------------------------------------------

sub_Hotkey_MultiClipboard:
	NoOnClipboardChange = 1
	mcb_DontStore = 1
	Menu, MultiClipboard, Add, MultiClipboard, mcb_sub_PasteFromMenu
	Menu, MultiClipboard, Disable, MultiClipboard
	Menu, MultiClipboard, Add
	If mcb_DontRestoreClipboard <> 1
		mcb_SavedClipboard := ClipboardAll
	If mcb_Additional_Clip = 1
		mcb_loopcount  = %mcb_AdditionalClipboards%
	Else
		mcb_loopcount  = 9

	Loop, %mcb_loopcount%
	{
		mcb_ClipFileName = settings/Clipboards/MCB_Clip%A_Index%.dat
		mcb_PlainClipFileName = settings/Clipboards/MCB_Clip%A_Index%.txt
		IfNotExist, %mcb_ClipFileName%
		{
			mcb_Temp2 := func_HotkeyDecompose( Hotkey_mcb_Paste%A_Index%, 1 )
			mcb_Temp2 := func_StrLeft(mcb_Temp2, StrLen(mcb_Temp2)-1) "&" func_StrRight(mcb_Temp2, 1)
			If (A_Index > 9 AND A_Index < 36)
				mcb_Temp2 := "&" Chr(64+A_Index-9)
			Else If A_Index > 35
				mcb_Temp2 =

			If mcb_NoCopyMenu = 1
			{
				Menu, MultiClipboard, Add, % A_Index ". " lng_mcb_Empty "`t" mcb_Temp2, mcb_sub_PasteFromMenu
				Menu, MultiClipboard, Disable, % A_Index ". " lng_mcb_Empty "`t" mcb_Temp2
			}
			Else
			{
				Menu, MultiClipboard, Add, % lng_mcb_Empty "`t" mcb_Temp2, mcb_sub_PasteFromMenu
				Menu, MultiClipboard, Disable, % lng_mcb_Empty "`t" mcb_Temp2
			}
		}
		Else
		{
			mcb_Temp =
			IfExist, %mcb_PlainClipFileName%
			{
				FileRead, mcb_Temp, *m60 %mcb_PlainClipFileName%
			} Else {
				FileRead, Clipboard, *c %mcb_ClipFileName%
				mcb_Temp = %Clipboard%
				mcb_Temp := func_StrLeft(mcb_Temp,60)
				FileDelete, %mcb_PlainClipFileName%
				FileAppend, %mcb_Temp%, %mcb_PlainClipFileName%
			}
			StringReplace, mcb_Temp, mcb_Temp, %A_Tab%, %A_Space%%A_Space%%A_Space%, A
			StringReplace, mcb_Temp, mcb_Temp, `r`n, `n, A
			StringReplace, mcb_Temp, mcb_Temp, `n, ¶, A
			StringReplace, mcb_Temp, mcb_Temp, `r, ¶, A
			StringReplace, mcb_Temp, mcb_Temp, ¶¶, ¶, A
			If mcb_Temp =
				mcb_Temp = %lng_mcb_MetaFile%

			mcb_Temp2 := func_HotkeyDecompose( Hotkey_mcb_Paste%A_Index%, 1 )
			mcb_Temp2 := func_StrLeft(mcb_Temp2, StrLen(mcb_Temp2)-1) "&" func_StrRight(mcb_Temp2, 1)
			If (A_Index > 9 AND A_Index < 36)
				mcb_Temp2 := "&" Chr(64+A_Index-9)
			Else If A_Index > 35
				mcb_Temp2 =
			If mcb_NoCopyMenu = 1
			{
				StringReplace, mcb_Temp, mcb_Temp, &, &&, All
				Menu, MultiClipboard, Add, % "&" A_Index ". " mcb_Temp "`t" mcb_Temp2, mcb_sub_PasteFromMenu
			}
			else
				Menu, MultiClipboard, Add, % lng_mcb_MenuPaste " " A_Index ": " mcb_Temp "`t" mcb_Temp2, mcb_sub_PasteFromMenu
		}
	}
	If mcb_NoCopyMenu = 0
	{
		Menu, MultiClipboard, Add
		Loop, %mcb_loopcount%
		{
			mcb_Temp2 := func_HotkeyDecompose( Hotkey_mcb_Copy%A_Index%, 1 )
			mcb_Temp2 := func_StrLeft(mcb_Temp2, StrLen(mcb_Temp2)-1) "&" func_StrRight(mcb_Temp2, 1)
			If (A_Index > 9 AND A_Index < 36)
				mcb_Temp2 := "&" Chr(64+A_Index-9)
			Else If A_Index > 35
				mcb_Temp2 =
			Menu, MultiClipboard, Add, % lng_mcb_MenuCopy " " A_Index "`t" mcb_Temp2, mcb_sub_CopyFromMenu
		}
	}
	Prefix = mcb
	mcb_Temp =
	mcb_AdditionalSettingsMenuExternal = 1
	Gosub, sub_CreateAdditionalSettingsMenu
	Menu, MultiClipboard, Add
	Menu, MultiClipboard, Add, %lng_AdditionalSettings%, :AdditionalSettingsMenu
	mcb_DontStore = 1
	NoOnClipboardChange = 1
	If mcb_DontRestoreClipboard <> 1
		Clipboard := mcb_SavedClipboard
	Menu, MultiClipboard, Show
	Menu, MultiClipboard, DeleteAll
	mcb_AdditionalSettingsMenuExternal =
	mcb_DontStore =
	NoOnClipboardChange =
Return

mcb_sub_PasteFromMenu:
	mcb_ClipNumber := A_Thismenuitempos-2
	mcb_ClipFileName = settings/Clipboards/MCB_Clip%mcb_ClipNumber%.dat
	mcb_ShiftKeyState := GetKeyState( "Shift" )
	mcb_CtrlKeyState := GetKeyState( "Ctrl" )

	Gosub, mcb_sub_DoPaste

	mcb_Temp := ClipboardAll
	If ( mcb_ShiftKeyState )
	{
		Loop
		{
			if mcb_ClipNumber = 1
				Break
			mcb_ClipNumber--
			mcb_ClipFileName = settings/Clipboards/MCB_Clip%mcb_ClipNumber%.dat
			mcb_AddToPaste = `n
			Gosub, mcb_sub_DoPaste
		}
	}
	mcb_ShiftKeyState =
Return

mc_sub_Action_Copy:
	mcb_ClipNumber := ActionPara%LastAction%
	mcb_ClipFileName = settings/Clipboards/MCB_Clip%mcb_ClipNumber%.dat
	mcb_PlainClipFileName = settings/Clipboards/MCB_Clip%mcb_ClipNumber%.txt
	Gosub, mcb_sub_DoCopy
Return

mcb_sub_CopyFromMenu:
	If mcb_Additional_Clip = 1
		mcb_SubNum  = 22
	Else
		mcb_SubNum  = 12
	mcb_ClipNumber := A_Thismenuitempos-mcb_SubNum
	mcb_ClipFileName = settings/Clipboards/MCB_Clip%mcb_ClipNumber%.dat
	mcb_PlainClipFileName = settings/Clipboards/MCB_Clip%mcb_ClipNumber%.txt
	Gosub, mcb_sub_DoCopy
Return

mcb_sub_Copy:
	mcb_ClipNumber := func_HotkeyGetNumber("mcb_Copy",9,"$")
	mcb_ClipFileName = settings/Clipboards/MCB_Clip%mcb_ClipNumber%.dat
	mcb_PlainClipFileName = settings/Clipboards/MCB_Clip%mcb_ClipNumber%.txt
	Gosub, mcb_sub_DoCopy
Return

mcb_sub_DoCopy:
	Selection := ""
	Selection := ClipboardAll

	If mcb_DontGetSel =
		func_GetSelection(0, 0, 1)
	Else If mcb_UsePlainText = 1
	{
		NoOnClipboardChange = 1
		Selection = %Clipboard%
		Clipboard = %Selection%
		Selection = %ClipboardAll%
		NoOnClipboardChange = 0
	}
	Else
		Selection = %ClipboardAll%

	If Selection =
		Return

	mcb_ClipSize := VarSetCapacity( Selection )

	If (mcb_ClipSize > mcb_ClipSizeLimit AND mcb_ClipSizeLimit > 0)
	{
		Selection := ""
		If mcb_BalloonTips = -1
		{
			StringReplace, mcb_Text, lng_mcb_ClipboardNotCopied, ###, %mcb_ClipSizeLimitMB%
			BalloonTip( mcb_ScriptName, mcb_Text " (" Round(mcb_ClipSize/1024/1024) " MB)", "Error" , 0, 0, mcb_BalloonTimeout*2)
		}
		mcb_ClipSize = 0
		Return
	}

	FileDelete, %mcb_ClipFileName%
	FileAppend, %Selection%, %mcb_ClipFileName%

	If mcb_ClipSize < 2048
	{
		Bin2Hex( SelectionAnsi, Selection )
		StringTrimLeft, SelectionAnsi, SelectionAnsi, 16
		Hex2Bin( SelectionBin, SelectionAnsi )
		Unicode2Ansi( SelectionBin, SelectionAnsi )
	}

	If mcb_DontGetSel =
		func_GetSelection(1, 0, 1)
	Else
		Selection = %Clipboard%

	FileDelete, %mcb_PlainClipFileName%

	If (FileExist( Selection ) AND Selection <> SelectionAnsi)
	{
		mcb_Current = %Selection%
		SplitPath, Selection, mcb_currentFileName, mcb_currentDir,,, mcb_currentDrive
		SplitPath, mcb_currentDir, mcb_currentParentDir
		StringSplit, mcb_dirs, mcb_currentDir, \

		StringLen, mcb_len, Selection

		If mcb_currentFileName =
			mcb_currentFileName = %mcb_currentDir%
		If mcb_len > 60
			mcb_current = %mcb_currentDrive%\%mcb_dirs2%\...\%mcb_currentParentDir%\%mcb_currentFileName%
		Else If mcb_current <>
			mcb_current = %mcb_currentDir%\%mcb_currentFileName%

		If ( InStr( FileExist( Selection ), "D" ) )
			FileAppend, % lng_mcb_Folder " " mcb_current " >>", %mcb_PlainClipFileName%
		Else
			FileAppend, % lng_mcb_File " " mcb_current " >>", %mcb_PlainClipFileName%
	}
	Else
		FileAppend, % func_StrLeft(Selection,60), %mcb_PlainClipFileName%

	If mcb_BalloonTips = -1
	{
		StringReplace, mcb_Text, lng_mcb_ClipboardCopied, ###, %mcb_ClipNumber%
		BalloonTip( mcb_ScriptName, mcb_Text, "Info" , 0, 0, mcb_BalloonTimeout)
	}

	If MainGuiVisible <>
	{
		GuiControl, Enable, %lng_mcb_ClearClipboards%
		mcb_NumOfClipFiles = 0
		Loop, %mcb_AdditionalClipboards%
		{
			IfExist, settings/Clipboards/MCB_Clip%A_Index%.dat
				mcb_NumOfClipFiles++
		}
		GuiControl,, mcb_NumOfClipFiles, %mcb_NumOfClipFiles%
	}
	SelectionBin := ""
	SelectionAnsi := ""
Return

mc_sub_Action_Paste:
	mcb_DontStore = 1
	mcb_Temp =
	mcb_ClipNumber := ActionPara%LastAction%
	mcb_ClipFileName = settings/Clipboards/MCB_Clip%mcb_ClipNumber%.dat

	Gosub, mcb_sub_DoPaste
	mcb_DontStore = 0
Return

mcb_sub_Paste:
	mcb_DontStore = 1
	mcb_Temp =
	mcb_ClipNumber := func_HotkeyGetNumber("mcb_Paste",9,"$")
	mcb_ClipFileName = settings/Clipboards/MCB_Clip%mcb_ClipNumber%.dat

	If A_ThisHotkey contains NumpadDel,NumpadIns,NumpadClear,NumpadUp,NumpadDown,NumpadLeft,NumpadRight,NumpadHome,NumpadEnd,NumpadPgUp,NumpadPgDn
		Send, {Shift Up}
	Gosub, mcb_sub_DoPaste
	mcb_DontStore = 0
Return

mcb_sub_DoPaste:
	Critical
	Thread, Priority, 10
	IfNotExist, %mcb_ClipFileName%
	{
		SplashImage, Off
		If mcb_BalloonTips <> 0
		{
			StringReplace, mcb_Text, lng_mcb_ClipboardPasteError, ###, %mcb_ClipNumber%
			BalloonTip( mcb_ScriptName, mcb_Text, "Info" , 0, 0, mcb_BalloonTimeout)
		}
		Return
	}

	If (mcb_temp = "" AND mcb_DontRestoreClipboard <> 1)
		mcb_temp = %ClipboardAll%
	Clipboard =

	FileRead, Clipboard, *c %mcb_ClipFileName%
	ClipWait, 2, 1

	If (Clipboard <> "" AND !InStr(A_Thismenuitem, lng_mcb_File) AND !InStr(A_Thismenuitem, lng_mcb_Folder) )
	{
		If mcb_TrimSpaceAndTab = 1
			Clipboard := func_StrTrimChars( Clipboard, " `t" )
		If mcb_TrimNewLines = 1
			Clipboard := func_StrTrimChars( Clipboard, "`r`n" )
		If mcb_TrimSpaceAndTab = 1
			Clipboard := func_StrTrimChars( Clipboard, " `t" )
	}

	If (mcb_CtrlKeyState =1 OR mcb_UsePlainText = 1)
	{
		mcb_temp2 := Clipboard
		Clipboard := mcb_temp2
	}

	SendEvent, %mcb_AddToPaste%^v
	Sleep, 100

	If mcb_DontRestoreClipboard <> 1
	{
		NoOnClipboardChange = 1
		Clipboard =
		Clipboard := mcb_Temp
		ClipWait, 2, 1
		NoOnClipboardChange =
	}

	If mcb_BalloonTips = -1
	{
		StringReplace, mcb_Text, lng_mcb_ClipboardPasted, ###, %mcb_ClipNumber%
		BalloonTip( mcb_ScriptName, mcb_Text, "Info" , 0, 0, mcb_BalloonTimeout)
	}

	mcb_AddToPaste =

	If (mcb_ShiftKeyState <> 1 AND mcb_ClipNumber > 1 AND mcb_PasteMovesToTop = 1)
	{
		FileMove, settings/Clipboards/MCB_Clip%mcb_ClipNumber%.dat, settings/Clipboards/MCB_Clip0.dat, 1
		FileMove, settings/Clipboards/MCB_Clip%mcb_ClipNumber%.txt, settings/Clipboards/MCB_Clip0.txt, 1
		Loop, % mcb_ClipNumber
		{
			mcb_FromIndex := mcb_ClipNumber-A_Index
			mcb_ToIndex :=  mcb_ClipNumber-A_Index + 1
			FileMove, settings/Clipboards/MCB_Clip%mcb_FromIndex%.dat, settings/Clipboards/MCB_Clip%mcb_ToIndex%.dat, 1
			FileMove, settings/Clipboards/MCB_Clip%mcb_FromIndex%.txt, settings/Clipboards/MCB_Clip%mcb_ToIndex%.txt, 1
		}
	}
Return

; ---------------------------------------------------------------------
mcb_sub_ClearClipboards:
	Loop, %mcb_AdditionalClipboards%
	{
		FileDelete, settings/Clipboards/MCB_Clip%A_Index%.dat
		FileDelete, settings/Clipboards/MCB_Clip%A_Index%.txt
	}
	GuiControl,, mcb_NumOfClipFiles, 0
	GuiControl, Disable, %lng_mcb_ClearClipboards%
Return

OnClipboardChange_MultiClipboard:
	If mcb_DontStore = 1
		Return

	WinGet, mcb_ProcName, ProcessName, A

	If mcb_ExcludeApps <>
		If mcb_ProcName in %mcb_ExcludeApps%
			Return

	If mcb_Additional_Clip = 1
	{
		mcb_loopcount  := mcb_AdditionalClipboards+1
		mcb_vor_index  := mcb_AdditionalClipboards+2
		mcb_vor_index2 := mcb_AdditionalClipboards+3
	}
	Else
	{
		mcb_loopcount  = 10
		mcb_vor_index  = 11
		mcb_vor_index2 = 12
	}
	Loop, %mcb_loopcount%
	{
		mcb_Index := mcb_vor_index - A_Index
		mcb_Index2 := mcb_vor_index2 - A_Index
		FileMove, settings/Clipboards/MCB_Clip%mcb_Index%.dat, settings/Clipboards/MCB_Clip%mcb_Index2%.dat, 1
		FileMove, settings/Clipboards/MCB_Clip%mcb_Index%.txt, settings/Clipboards/MCB_Clip%mcb_Index2%.txt, 1
	}
	mcb_ClipNumber := 1
	mcb_DontGetSel = 1
	mcb_ClipFileName = settings/Clipboards/MCB_Clip%mcb_ClipNumber%.dat
	mcb_PlainClipFileName = settings/Clipboards/MCB_Clip%mcb_ClipNumber%.txt
	Gosub, mcb_sub_DoCopy
	If mcb_ClipSize = 0
	{
		Loop, % mcb_loopcount-1
		{
			mcb_Index := A_Index+1
			mcb_Index2 := A_Index
			FileMove, settings/Clipboards/MCB_Clip%mcb_Index%.dat, settings/Clipboards/MCB_Clip%mcb_Index2%.dat, 1
			FileMove, settings/Clipboards/MCB_Clip%mcb_Index%.txt, settings/Clipboards/MCB_Clip%mcb_Index2%.txt, 1
		}
	}
	Selection := ""
	mcb_DontGetSel =
Return
