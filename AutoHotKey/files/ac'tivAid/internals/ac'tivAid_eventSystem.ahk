; ---------------------------------------
; Event-System (register, throw)
; ---------------------------------------
tim_WM_DISPLAYCHANGE:
	; Anzahl der Monitore und Arbeitsfl‰che ermitteln
	SysGet, NumOfMonitors, 80
	SysGet, WorkArea, MonitorWorkArea

	; Maﬂe vom Standardmonitor
	SysGet, Monitor, Monitor
	MonitorHeight := MonitorBottom-MonitorTop
	MonitorWidth := MonitorRight-MonitorLeft

	SysGet, WorkAreaPrimary, MonitorWorkArea
	WorkAreaPrimaryWidth := WorkAreaPrimaryRight - WorkAreaPrimaryLeft
	WorkAreaPrimaryHeight := WorkAreaPrimaryBottom - WorkAreaPrimaryTop

	If NumOfMonitors < 1
		NumOfMonitors = 1

	Loop, %NumOfMonitors%
	{
		SysGet, tempArea, MonitorWorkArea, %A_Index%
		SysGet, WorkArea%A_Index%, MonitorWorkArea, %A_Index%
		SysGet, Monitor%A_Index%, Monitor, %A_Index%
		WorkArea%A_Index%Width := WorkArea%A_Index%Right - WorkArea%A_Index%Left
		WorkArea%A_Index%Height := WorkArea%A_Index%Bottom - WorkArea%A_Index%Top
		Monitor%A_Index%Width := Monitor%A_Index%Right - Monitor%A_Index%Left
		Monitor%A_Index%Height := Monitor%A_Index%Bottom - Monitor%A_Index%Top

		If tempAreaLeft < %WorkAreaLeft%
			WorkAreaLeft := tempAreaLeft
		If tempAreaRight > %WorkAreaRight%
			WorkAreaRight := tempAreaRight
		If tempAreaTop < %WorkAreaTop%
			WorkAreaTop := tempAreaTop
		If tempAreaBottom > %WorkAreaBottom%
			WorkAreaBottom := tempAreaBottom

	}

	WorkAreaWidth  := WorkAreaRight-WorkAreaLeft
	WorkAreaHeight := WorkAreaBottom-WorkAreaTop
	SysGet, MonitorAreaWidth, 78
	SysGet, MonitorAreaHeight, 79
	SysGet, MonitorAreaLeft, 76
	SysGet, MonitorAreaTop, 77
	If MonitorAreaWidth = 0 ; Win95/NT
	{
		MonitorAreaWidth := MonitorWidth
		MonitorAreaHeight := MonitorHeight
		MonitorAreaLeft := MonitorLeft
		MonitorAreaTop := MonitorTop
	}
	MonitorAreaBottom := MonitorAreaTop+MonitorAreaHeight
	MonitorAreaRight := MonitorAreaLeft+MonitorAreaWidth

	SysGet, BorderHeight, 32 ;7
	SysGet, SM_CXBORDER, 5
	BorderHeightToolWindow := BorderHeight-SM_CXBORDER
	SysGet, CaptionHeight, 4
	SysGet, MenuBarHeight, 15
	SysGet, SmallCaptionHeight, 51
	SysGet, ScrollBarVWeight, 9
	SysGet, ScrollBarHWeight, 10

	If ((WorkAreaWidth <> LastWorkAreaWidth OR WorkAreaHeight <> LastWorkAreaHeight) AND LastWorkAreaHeight <> "")
	{
		Debug("STATUS", A_LineNumber, A_LineFile, "Display settings changed ...")
		Loop
		{
			If Extension[%A_Index%] =
				break
			Function := Extension[%A_Index%]
			If ( IsLabel("DisplayChange_" Function) )
				Gosub, DisplayChange_%Function%
		}
	}

	LastWorkAreaWidth = %WorkAreaWidth%
	LastWorkAreaHeight = %WorkAreaHeight%
	LastMonitorAreaWidth = %MonitorAreaWidth%
	LastMonitorAreaHeight = %MonitorAreaHeight%

	; ac'tivAid automatisch deaktiveren, wenn der Installer sichtbar ist.
	DetectHiddenWindows, On
	If (WinActive("License - ac'tivAid v") OR WinActive("Lizenzbestimmungen - ac'tivAid v") OR WinActive("ac'tivAid v","Installationsfortschritt") OR WinActive("ac'tivAid v","Installation progress") OR WinExist("##### NEXTBUILD.ahk"))
	{
		DetectHiddenWindows, Off
		If A_IsSuspended = 0
		{
			Gosub, sub_MenuSuspend
			InstallerVisible = 1
		}
	}
	Else If InstallerVisible = 1
	{
		DetectHiddenWindows, Off
		InstallerVisible =
		Gosub, sub_MenuSuspend
	}
Return

resolution_initTimer:
	if resolution_prev != %A_ScreenWidth%x%A_ScreenHeight%
		throwEvent("resolutionChange")

	resolution_prev = %A_ScreenWidth%x%A_ScreenHeight%
return

shellhook_initEvent:
	CreateGuiID("activAid_ShellHook")
	GuiDefault("activAid_ShellHook","+LastFound")
	Gui, Add, Text,,empty
	Gui,Show,x200 y200 w200 h200 Hide, activAid ShellHook

	shellhook_hWnd := WinExist()
	DllCall( "RegisterShellHookWindow", UInt,shellhook_hWnd )
	shellhook_msgNum := "0x" . FormatHexNumber(DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" ),4)
	func_AddMessage(shellhook_msgNum, "shellhook_label")
	shellhook_initialized = 1
return

shellhook_label:
	if (#wParam = 4 || #wParam = 32772)
	{
		event_activeWindow_ahkId := #lParam
		WinGet, event_activeWindow, ProcessName, ahk_id %#lParam%
		WinGetClass, event_activeWindow_Class, ahk_id %#lParam%
		throwEvent("activeWindow")
	}

	if (#wParam = 1)
	{
		event_createWindow_ahkId := #lParam
		WinGet, event_createWindow, ProcessName, ahk_id %#lParam%
		WinGetClass, event_createWindow_Class, ahk_id %#lParam%
		throwEvent("createWindow")
	}

	if (#wParam = 6)
	{
		event_redrawWindow_ahkId := #lParam
		WinGet, event_redrawWindow, ProcessName, ahk_id %#lParam%
		WinGetClass, event_redrawWindow_Class, ahk_id %#lParam%
		throwEvent("redrawWindow")
	}

	#wParam =
	#lParam =
return

registerEvent(eventName,label)
{
	Global

	eventLabels%eventName% := eventLabels%eventName% label "|"
}

unRegisterEvent(eventName,label)
{
	Global

	StringReplace, eventLabels%eventName%, eventLabels%eventName%, %label%|,,A
}

throwEvent(eventName)
{
	Global

	If eventLabels%eventName% !=
	{
		Loop, parse, eventLabels%eventName%, |
		{
			if A_LoopField !=
			{
				SetTimer, %A_LoopField%, -1
			}
		}
	}
}

getRegisteredEvents()
{
	Loop, parse, registeredEvents, |
	{
		ToolTip, %A_LoopField%
	}
	Tooltip
}
