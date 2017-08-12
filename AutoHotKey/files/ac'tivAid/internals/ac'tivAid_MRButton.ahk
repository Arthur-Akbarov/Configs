#IfWinactive

#MaxThreadsperhotkey 1

~#ESC::
	Sleep, 300
	Suspend, Toggle
	Suspend, Toggle
	niftyWindows = on
Return

$MButton::
;   Critical
	MButton_DownTick = %A_TickCount%
	StringReplace, MButton_LastHotkey, A_ThisHotkey, $,

	MButton_down =
	MButton_send =

	CallHook( "MButton" )

	If (MButton_send = "" OR MButton_send = "yes")
	{
		If (MButton_UpTick <> MButton_DownTick)
		{
			Click down middle
			MButton_down = yes
		}
		Else
			Click up middle
	}

	MButton_send =
Return

$MButton Up::
;   Critical
	MButton_UpTick = %MButton_DownTick%
	CallHook("MButton","Up")

	If MButton_down = yes
	{
		Click up middle
		MButton_down =
	}
Return

#IfWinNotActive, ac'tivAid v ahk_class AutoHotkeyGUI
$RButton::
	DetectHiddenWindows, On
	IfWinExist, StrokeIt
		StrokeIt = 1
	Else
		StrokeIt = 0

	RButton_down =
	RButton_send =

	Hotkey, IfWinNotActive
	If (GetKeyState("LButton","P") = 0)
		Hotkey, $LButton, On

	CallHook("RButton")

	RButton_DownTick = %A_TickCount%
	If (RButton_send = "" OR RButton_send = "yes")
	{
		If (RButton_UpTick <> RButton_DownTick OR StrokeIt = 1)
		{
			Click down right
			RButton_down = yes
		}
		Else
		{
			Click up right
		}
	}

	WinGetClass, tmpClass, A
	If tmpClass = AutoHotkeyGUI
		KeyWait, RButton, L
	Else
		KeyWait, RButton

	CallHook("RButton","Up")

	RButton_UpTick = %RButton_DownTick%
	If (RButton_down = "yes")
	{
		Click up right
		RButton_down =
	}
	RButton_send =

	RLButton_send =
	Hotkey, IfWinNotActive
	Hotkey, $LButton, Off
	SendMode, %A_SendMode%
Return
#IfWinNotActive

$LButton::
	Critical
	If (GetKeyState("RButton","P"))
	{
		RLButton_send = 1
		Click down right
	}
	Click left
	If (GetKeyState("RButton","P"))
		Click up right
	Sleep, 0
Return

DoEnable_MButton:
	Hotkey, IfWinActive
	Enable_MButton = 0
	Loop, Parse, Hook_MButton, |
	{
		If A_LoopField =
			continue
		If (Enable_%A_LoopField% = 1 AND EnableMButton_%A_LoopField% <> 0)
			Enable_MButton = 1
	}
	If Enable_MButton = 1
	{
		Hotkey, $MButton, On
		Hotkey, $MButton Up, On
	}
	Else
	{
		Hotkey, $MButton, Off
		Hotkey, $MButton Up, Off
	}
Return

DoDisable_MButton:
	Hotkey, IfWinActive
	Enable_MButton = 0
	Loop, Parse, Hook_MButton, |
	{
		If A_LoopField =
			continue
		If (Enable_%A_LoopField% = 1 AND EnableMButton_%A_LoopField% <> 0)
			Enable_MButton = 1
	}
	If Enable_MButton = 1
	{
		Hotkey, $MButton, Off
		Hotkey, $MButton Up, Off
	}
Return

DoEnable_RButton:
	Hotkey, IfWinNotActive, ac'tivAid v ahk_class AutoHotkeyGUI
	Enable_RButton = 0
	Loop, Parse, Hook_RButton, |
	{
		If A_LoopField =
			continue
		If (Enable_%A_LoopField% = 1 AND EnableRButton_%A_LoopField% <> 0)
			Enable_RButton = 1
	}

	If Enable_RButton = 1
	{
		Hotkey, $RButton, On
;      Hotkey, $RButton Up, On
	}
	Else
	{
		Hotkey, $RButton, Off
;      Hotkey, $RButton Up, Off
	}
	Hotkey, IfWinNotActive
Return

DoDisable_RButton:
	Hotkey, IfWinNotActive, ac'tivAid v ahk_class AutoHotkeyGUI
	Enable_RButton = 0
	Loop, Parse, Hook_RButton, |
	{
		If A_LoopField =
			continue
		If (Enable_%A_LoopField% = 1 AND EnableRButton_%A_LoopField% <> 0)
			Enable_RButton = 1
	}
	If Enable_RButton = 1
	{
		Hotkey, $RButton, Off
;      Hotkey, $RButton Up, Off
	}
	Hotkey, IfWinNotActive
Return

#MaxThreadsperhotkey
