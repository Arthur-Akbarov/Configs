; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               MouseWheel
; -----------------------------------------------------------------------------
; Prefix:             mbt_
; Version:            0.3
; Date:               2008-05-23
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_MouseWheel:
	Prefix = mw
	%Prefix%_ScriptName    = MouseWheel
	%Prefix%_ScriptVersion = 0.3
	%Prefix%_Author        = Wolfgang Reszel
	IconFile_On_MouseWheel = %A_WinDir%\system32\main.cpl
	IconPos_On_MouseWheel = 1

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                    = %mw_ScriptName% - Mausrad auch in inaktiven Fenstern ermöglichen
		Description                 = Erlaubt es auch in inaktiven Fenstern mit dem Mausrad zu scrollen
		lng_mw_Window               = Fenster
		lng_mw_Control              = Element
		lng_mw_DisableClasses       = MouseWheel in folgenden Fenster- und Elementklassen (mit Tabulator getrennt) ignorieren`n(* = Platzhalter; Fenster/Elemente verhalten sich wie bei deaktiviertem MouseWheel)
		lng_mw_Infotext             = Falls bei aktivierter MouseWheel-Erweiterung das Scrollen langsam wird oder träge reagiert, sollte der Optimierte Bildlauf von Listenfeldern deaktiviert werden. Das geschieht in den Systemeigenschaften unter Erweitert über die Schalftläche Einstellungen unter Leistung (Leistungsoptionen). In Vista muss man zuvor auf der linken Seite auf "Erweiterte Systemeinstellungen" klicken. Gleiches gilt für Browser. Beim Internet Explorer findet man die Einstellung unter Extras/Internetoptionen>Erweitert (Optimierter Bildlauf). In Firefox nennt sich das "Sanfter Bildlauf" (Extras/Einstellungen>Erweitert>Allgemein) und in Opera "Fließendes, weiches Scrollen" (Extras/Einstellungen>Erweitert>Browser).

	}
	else        ; = other languages (english)
	{
		MenuName                    = %mw_ScriptName% - Enables the mouse wheel in inactive windows
		Description                 = Enables the mouse wheel to also scroll in inactive windows
		lng_mw_Window               = Window
		lng_mw_Control              = Control
		lng_mw_DisableClasses       = Disable MouseWheel in in the following window and control classes (separated with tabulator)`n(* = wild-card)
		lng_mw_Infotext             = If you have problems with delayed scrolling you should disalbe smooth scrolling for list boxes in the system control panel in performance settings. Remember that almoust every Browser (Firefox, Internet Explorer and Opera) have separate settings for smooth scrolling.
	}
	If CustomLanguage <>
		gosub, CustomLanguage
	IniRead, mw_Action, %ConfigFile%, %mw_ScriptName%, Action, 1
	IniRead, mw_DisableClasses, %ConfigFile%, %mw_ScriptName%, DisableClasses, %A_Space%
	mw_DisableClasses := func_StrTrimChars(mw_DisableClasses,"`,")

	mw_GuiThreadInfoSize = 48
	VarSetCapacity(mw_GuiThreadInfo, mw_GuiThreadInfoSize)
Return

SettingsGui_MouseWheel:
	StringReplace, mw_DisableClassesCR, mw_DisableClasses, `,, `n, a
	Gui, Add, Text, xs+10 ys+15 w550, %lng_mw_DisableClasses%:
	Gui, Add, Edit, xs+10 y+10 W530 T130 R9 WantTab gsub_CheckIfSettingsChanged vmw_DisableClasses_tmp,%mw_DisableClassesCR%
	Gui, Add, Button, xs+540 yp+0 W21 gmw_sub_GetDisableClass, +
	Gui, Add, Text, ys+180 xs+10 w550, %lng_mw_Infotext%

	func_CreateListOfHotkeys( "WheelUp", mw_Description, mw_ScriptName )
	func_CreateListOfHotkeys( "WheelDown", mw_Description, mw_ScriptName )
Return

SaveSettings_MouseWheel:
	mw_Action = 0
	Loop, 11
		mw_Action := mw_Action + A_Index*mw_Action%A_Index%

	StringReplace, mw_DisableClasses, mw_DisableClasses_tmp, `n, `,, a
	mw_DisableClasses := func_StrTrimChars(mw_DisableClasses,"`,")
	IniWrite, %mw_Action%, %ConfigFile%, %mw_ScriptName%, Action
	IniWrite, %mw_DisableClasses%, %ConfigFile%, %mw_ScriptName%, DisableClasses
Return

CancelSettings_MouseWheel:
Return

DoEnable_MouseWheel:
	Hotkey, $WheelUp, mw_sub_WheelUp, On, T2
	Hotkey, $WheelDown, mw_sub_WheelDown, On, T2
Return

DoDisable_MouseWheel:
	Hotkey, $WheelUp, mw_sub_WheelUp, Off
	Hotkey, $WheelDown, mw_sub_WheelDown, Off
Return

DefaultSettings_MouseWheel:
Return

Update_MouseWheel:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

mw_sub_GetDisableClass:
	Gui, %GuiID_activAid%:Cancel
	SplashImage,,b1 cwFFFF80 FS9 WS700 w400, %lng_getClassMsg%
	SetTimer, mw_tim_GetClass, 10
	Input,mw_GetKey,L1 *,{Enter}{ESC}
	SetTimer, mw_tim_GetClass, Off
	SplashImage, Off
	ToolTip
	Gui, %GuiID_activAid%:Show
	If ErrorLevel <> Endkey:Enter
		Return

	GuiControlGet, mw_DisableClasses_tmp
	StringReplace, mw_DisableClasses_tmp, mw_DisableClasses_tmp, `n%mw_GetClass%%A_Tab%%mw_getMouseClass%
	mw_DisableClasses_tmp = %mw_DisableClasses_tmp%`n%mw_GetClass%%A_Tab%%mw_getMouseClass%
	StringReplace, mw_DisableClasses_tmp, mw_DisableClasses_tmp, `n, `%A_Enter`%, All
	AutoTrim, On
	mw_DisableClasses_tmp = %mw_DisableClasses_tmp%
	AutoTrim, Off
	StringReplace, mw_DisableClasses_tmp, mw_DisableClasses_tmp, `%A_Enter`%, `n, All
	GuiControl,,mw_DisableClasses_tmp, %mw_DisableClasses_tmp%
	GuiControl,Focus,mw_DisableClasses_tmp

	Send,^{End}{Space}{BS}
Return

mw_tim_GetClass:
	MouseGetPos,mw_X,mw_Y,mw_getId,mw_getMouseClass
	mw_getMouseHWND := DllCall("WindowFromPoint", "int", mw_X, "int", mw_Y)
	WinGetClass, mw_getMouseClass, ahk_id %mw_getMouseHWND%

	WinGetClass, mw_getClass, ahk_id %mw_getId%
	If mw_getClass =
		WinGetClass,mw_getClass,A
	ToolTip, %lng_mw_Window%: %mw_getClass%`n%lng_mw_Control%: %mw_getMouseClass%
Return

mw_sub_WheelUp:
mw_sub_WheelDown:
	mw_Events += A_EventInfo
	If A_TimesincePriorHotkey < 10
	{
		SetTimer, mw_sub_WheelUp, -20
		Return
	}
	SetTimer, mw_sub_WheelUp, Off
	StringReplace, mw_ThisHotKey, A_ThisHotKey, $
	mw_Speed := mw_Events*(120<<16)*((mw_ThisHotKey="WheelUp")-.5)*2
	mw_Events = 0

	CoordMode, Mouse, Screen
	MouseGetPos, mw_X, mw_Y, mw_WheelWin, mw_WheelControl
	mw_WheelTarget := DllCall("WindowFromPoint", "int", mw_X, "int", mw_Y)
	WinGetClass, mw_WheelClass, ahk_id %mw_WheelWin%
	WinGetTitle, mw_WheelTitle, ahk_id %mw_WheelWin%

	WinGetClass, mw_ActClass, A
	NumPut(mw_GuiThreadInfoSize, mw_GuiThreadInfo, 0)
	If DllCall("GetGUIThreadInfo", uint, 0, str, mw_GuiThreadInfo)
		mw_FocusedHWND := NumGet(mw_GuiThreadInfo, 12)  ; Retrieve the hwndFocus field from the struct.
	Else
	{
		ControlGetFocus, mw_ActControl, A
		ControlGet, mw_FocusedHWND, HWND,, %mw_ActControl%, A
		mw_FocusedHWND := mw_FocusedHWND-0
	}

	mw_DisableClasses_tmp = %mw_DisableClasses%,tooltips_class32

	mw_UseAlternateScroll = 0
	Loop, Parse, mw_DisableClasses_tmp, `,
	{
		If A_LoopField =
			continue
		mw_LoopField2 =
		StringSplit, mw_LoopField, A_LoopField, %A_Tab%
		If (func_WildcardMatch( mw_WheelClass, mw_LoopField1, 0) AND ((func_WildcardMatch( mw_WheelControl, mw_LoopField2, 0) AND mw_LoopField2 <> "") OR mw_LoopField2 = ""))
		{
			mw_WheelTarget = %mw_FocusedHWND%
			Break
		}
		If (func_StrLeft(mw_LoopField1,2) = "==" AND A_LoopField2 = "")
		{
			StringTrimLeft, mw_LoopField1, mw_LoopField1, 2
			If mw_WheelClass = %mw_LoopField1%
			{
				mw_UseAlternateScroll = 1
				break
			}
		}
	}

	If (InStr(qn_QuickNoteWindows, "|" mw_WheelWin "|") OR mw_UseAlternateScroll = 1)
	{
		RegRead, mw_WheelScrollLines, HKEY_CURRENT_USER, Control Panel\Desktop, WheelScrollLines
		Loop, % mw_WheelScrollLines*A_EventInfo
			SendMessage, 0x115, % (mw_ThisHotKey="WheelDown"), 0, %mw_WheelControl%, ahk_id %mw_WheelWin%
	}
	Else
	{
		mw_tempvar := ((mw_Y & 0x0000FFFF) << 16) | (mw_X & 0x0000FFFF)
		IfInString, mw_WheelControl, vlist
			PostMessage 0x20A, %mw_Speed%, %mw_tempvar%, %mw_WheelControl%, ahk_id %mw_WheelWin%
		Else
			PostMessage 0x20A, %mw_Speed%, %mw_tempvar%,, ahk_id %mw_WheelTarget%
	}
	Sleep,0
Return
