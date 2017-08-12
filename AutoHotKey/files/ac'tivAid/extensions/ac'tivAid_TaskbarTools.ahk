; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               TaskbarTools
; -----------------------------------------------------------------------------
; Prefix:             tbt_
; Version:            0.1
; Date:               2008-07-01
; Author:             David Hilberath
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_TaskbarTools:
	Prefix = tbt
	%Prefix%_ScriptName    = TaskbarTools
	%Prefix%_ScriptVersion = 0.1
	%Prefix%_Author        = David Hilberath

	IconFile_On_TaskbarTools  = %A_WinDir%\system32\shell32.dll
	IconPos_On_TaskbarTools   = 40

	gosub, LoadSettings_TaskbarTools
	gosub, LanguageCreation_TaskbarTools
Return

LanguageCreation_TaskbarTools:
	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %tbt_ScriptName% - Taskbar Funktionen
		Description                   = Erlaubt das Verschieben von Taskbarbuttons mit Drag'n'Drop

		lng_tbt_closeTab              = Tab schließen
		lng_tbt_moveTab               = Tab verschieben
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %tbt_ScriptName% - Additional taskbar functionality
		Description                   = Enables rearranging of taskbar buttons via drag'n'drop

		lng_tbt_closeTab              = Close tab
		lng_tbt_moveTab               = Move tab
	}
Return

SettingsGui_TaskbarTools:
	; func_HotkeyAddGuiControl( lng_tbt_TEXT, "tbt_HOTKEYNAME", "xs+10 y+10 w160" )
	; Gui, Add, Edit, xs+10 y+5 gsub_CheckIfSettingsChanged vtbt_var, %lng_tbt_text%

	func_HotkeyAddGuiControl( lng_tbt_closeTab, "tbt_closeKey", "xs+10 y+10 w160" )

	if (Enable_MinimizeToTray)
	{
		func_HotkeyAddGuiControl( lng_mtt_MinimizeToIcon, "tbt_toIconKey", "xs+10 y+10 w160" )
		func_HotkeyAddGuiControl( lng_mtt_MinimizeToMenu, "tbt_toMenuKey", "xs+10 y+10 w160" )
	}
Return

LoadSettings_TaskbarTools:
	; IniRead, tbt_VARIABLE, %ConfigFile%, %tbt_ScriptName%, INI-Variable, DEFAULTWERT
	func_HotkeyRead( "tbt_closeKey", ConfigFile , tbt_ScriptName, "CloseKey", "sub_Hotkey_TaskbarTools", "+LBUTTON", "~" )
	if (Enable_MinimizeToTray)
	{
		func_HotkeyRead( "tbt_toIconKey", ConfigFile , tbt_ScriptName, "ToIconKey", "sub_Hotkey_TaskbarToolsToIcon", "!LBUTTON", "~" )
		func_HotkeyRead( "tbt_toMenuKey", ConfigFile , tbt_ScriptName, "ToMenuKey", "sub_Hotkey_TaskbarToolsToMenu", "^LBUTTON", "~" )
	}
Return

SaveSettings_TaskbarTools:
	; Syntax: HotkeyWrite ( Name des Tastaturkürzels, INI-Datei, Sektion, INI-Variable [, Subroutine des Tastaturkürzels] )
	; func_HotkeyWrite( "tbt_HOTKEYNAME", ConfigFile , tbt_ScriptName, "INI-Variable" )
	; IniWrite, %tbt_VARIABLE%, %ConfigFile%, INI-Sektion, INI-Variable
	func_HotkeyWrite( "tbt_closeKey", ConfigFile , tbt_ScriptName, "CloseKey")
	if (Enable_MinimizeToTray)
	{
		func_HotkeyWrite( "tbt_toIconKey", ConfigFile , tbt_ScriptName, "ToIconKey")
		func_HotkeyWrite( "tbt_toMenuKey", ConfigFile , tbt_ScriptName, "ToMenuKey")
	}
Return

AddSettings_TaskbarTools:
Return

CancelSettings_TaskbarTools:
Return

DoEnable_TaskbarTools:
	func_HotkeyEnable("tbt_closeKey")
	if (Enable_MinimizeToTray)
	{
		func_HotkeyEnable("tbt_toIconKey")
		func_HotkeyEnable("tbt_toMenuKey")
	}
	SetTimer, tbt_waitForLBUTTON, 200
Return

DoDisable_TaskbarTools:
	func_HotkeyDisable("tbt_closeKey")
	func_HotkeyDisable("tbt_toIconKey")
	func_HotkeyDisable("tbt_toMenuKey")
	SetTimer, tbt_waitForLBUTTON, Off
Return

DefaultSettings_TaskbarTools:
Return

OnExitAndReload_TaskbarTools:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_TaskbarTools:
	; Hier kommen die Befehle hin, welche bei Win+F5 ausgeführt werden
	If ((tbt_GetTaskbarHandle(tbt_hWindow) != 0 ) And (tbt_hWindow != 0))
		tbt_closeWindow(tbt_hWindow)
Return

sub_Hotkey_TaskbarToolsToMenu:
	; Hier kommen die Befehle hin, welche bei Win+F5 ausgeführt werden
	If ((tbt_GetTaskbarHandle(tbt_hWindow) != 0 ) And (tbt_hWindow != 0))
		tbt_toMenuWindow(tbt_hWindow)
Return

sub_Hotkey_TaskbarToolsToIcon:
	; Hier kommen die Befehle hin, welche bei Win+F5 ausgeführt werden
	If ((tbt_GetTaskbarHandle(tbt_hWindow) != 0 ) And (tbt_hWindow != 0))
		tbt_toIconWindow(tbt_hWindow)
Return

tbt_minAnimation(set="")
{
	VarSetCapacity(AnimationInfo, 8,0)
	cbSize := VarSetCapacity(AnimationInfo)
	NumPut(cbSize, AnimationInfo, 0, "UInt")

	if set =
	{
		DllCall("SystemParametersInfo", UInt, 0x48, UInt, cbSize, "UInt", &AnimationInfo, UInt, 1 )
		return NumGet(AnimationInfo,4)
	}

	if (set = 0 || set = 1)
	{
		NumPut(cbSize, AnimationInfo, 0, "UInt")
		NumPut(set, AnimationInfo, 4, "Int")

		DllCall("SystemParametersInfo", UInt, 0x49, UInt, cbSize, "UInt", &AnimationInfo, UInt, 1 )
		return 1
	}
	return 0
}

tbt_waitForLBUTTON:
	if GetKeyState("LBUTTON", "P")
	{
		MouseGetPos, , , id
		WinGetClass, tbt_Class, ahk_id %id%
		if(tbt_Class != "Shell_TrayWnd")
			return

		SetTimer, tbt_waitForLBUTTON, Off
		tbt_StartPos := tbt_GetHotItem()

		Loop
		{
			Sleep, 10
			GetKeyState, state, LBUTTON, P
			if state = U  ; The key has been released, so break out of the loop.
				break

			tbt_tmp := tbt_GetHotItem()
			if tbt_tmp > 0
			{
				tbt_MoveButton(tbt_StartPos, tbt_tmp)
				tbt_StartPos := tbt_GetHotItem()
			}
		}

		SetTimer, tbt_waitForLBUTTON, 200
	}
return

tbt_endMovement:
	MouseGetPos, , , id
	WinGetClass, tbt_Class, ahk_id %id%
	if(tbt_Class != "Shell_TrayWnd")
		return

return
; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------
tbt_closeWindow(ahk_id)
{
	tmp_ani := tbt_minAnimation()
	if tmp_ani=1
		tbt_minAnimation(0)

	WinActivate, ahk_id %ahk_id%
	Send !{F4}

	if tmp_ani=1
		tbt_minAnimation(1)

	return
}

tbt_toIconWindow(ahk_id)
{
	tmp_ani := tbt_minAnimation()
	if tmp_ani=1
		tbt_minAnimation(0)

	WinActivate, ahk_id %ahk_id%
	performAction("MinimizeToIcon")

	if tmp_ani=1
		tbt_minAnimation(1)

	return
}

tbt_toMenuWindow(ahk_id)
{
	tmp_ani := tbt_minAnimation()
	if tmp_ani=1
		tbt_minAnimation(0)

	WinActivate, ahk_id %ahk_id%
	performAction("MinimizeToTray")

	if tmp_ani=1
		tbt_minAnimation(1)

	return
}


tbt_GetTaskbarHandle( ByRef hWindow )
{
	 hWindow = 0
	 Return = 0
	 CoordMode, Mouse, Screen
	 MouseGetPos, MouseX, MouseY, idWindow, idClass, 2
	 WinGetClass, cWindow, ahk_id %idWindow%
	 If cWindow Not In Shell_TrayWnd,UltraMonDeskTaskBar
		  Return, Return
	 WinGetClass, cClass, ahk_id %idClass%
	 If ( cClass != "ToolbarWindow32" )
		  Return, Return
	 hParent := DllCall( "GetParent", "UInt", idClass )
	 WinGetClass, cParent, ahk_id %hParent%
	 If cParent Not In MSTaskSwWClass,TaskBand
		  Return, Return

	 WinGet, pidTaskbar, PID, ahk_id %idClass%

	 hProcess := DllCall( "OpenProcess", "UInt", (PROCESS_VM_OPERATION:=0x08)+(PROCESS_VM_READ:=0x10)+(PROCESS_VM_WRITE:=0x20), "UInt", 0, "UInt", pidTaskbar)
	 pButton := DllCall( "VirtualAllocEx", "UInt", hProcess, "UInt", 0, "UInt", 20, "UInt", (MEM_COMMIT:=0x1000), "UInt", (PAGE_READWRITE:=0x4) )

	 VarSetCapacity( Point, 8, 0 )
	 NumPut( MouseX, Point, 0, "UInt" )
	 NumPut( MouseY, Point, 4, "UInt" )

	 DllCall( "ScreenToClient", "UInt", idClass, "UInt", &Point )

	 DllCall( "WriteProcessMemory", "UInt", hProcess, "UInt", pButton+0, "UInt", &Point, "UInt", 8, "UInt", 0 )

	 SendMessage, (TB_HITTEST:=0x445), 0, pButton,, ahk_id %idClass%
	 nButton := ErrorLevel

	 If nButton > 0x7FFFFFFF
		  nButton := -(~nButton)-1

	 If ( nButton > -1 )
	 {
		  SendMessage, (TB_GETBUTTON:=0x417), nButton, pButton,, ahk_id %idClass%

		  VarSetCapacity(Button, 20)
		  DllCall( "ReadProcessMemory", "UInt", hProcess, "UInt", pButton, "UInt", &Button, "UInt", 20, "UInt", 0 )

		  If ( cWindow = "Shell_TrayWnd" )
		  {
				DllCall( "ReadProcessMemory", "UInt", hProcess, "UInt", NumGet( Button, 12, "UInt" ), "UInt*", hWindow, "UInt", 4, "UInt", 0 )
		  }
		  Else
		  {
				hWindow := NumGet( Button, 12, "UInt" )
		  }
		  Return := nButton+1
	 }

	 DllCall( "VirtualFreeEx", "UInt", hProcess, "UInt", pButton, "UInt", 0, "UInt", (MEM_RELEASE:=0x8000) )
	 DllCall( "CloseHandle", "UInt", hProcess )

	 Return, Return
}

tbt_GetHotItem()
{
	idxTB := tbt_GetTaskSwBar()
	SendMessage, 0x447, 0, 0, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd   ; TB_GETHOTITEM
	Return ErrorLevel << 32 >> 32
}

tbt_MoveButton(idxOld, idxNew)
{
	idxTB := tbt_GetTaskSwBar()
	SendMessage, 0x452, idxOld, idxNew, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd    ; TB_MOVEBUTTON
}

tbt_GetTaskSwBar()
{
	ControlGet, hParent, hWnd,, MSTaskSwWClass1 , ahk_class Shell_TrayWnd
	ControlGet, hChild , hWnd,, ToolbarWindow321, ahk_id %hParent%
	Loop
	{
		ControlGet, hWnd, hWnd,, ToolbarWindow32%A_Index%, ahk_class Shell_TrayWnd
		If  Not  hWnd
			Break
		Else If  hWnd = %hChild%
		{
			idxTB := A_Index
			Break
		}
	}
	Return   idxTB
}
