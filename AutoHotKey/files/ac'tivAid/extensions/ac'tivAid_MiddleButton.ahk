; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               MiddleButton
; -----------------------------------------------------------------------------
; Prefix:             mbt_
; Version:            0.7
; Date:               2008-05-23
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_MiddleButton:
	Prefix = mbt
	%Prefix%_ScriptName    = MiddleButton
	%Prefix%_ScriptVersion = 0.7
	%Prefix%_Author        = Wolfgang Reszel

	IconFile_On_MiddleButton = %A_WinDir%\system32\main.cpl
	IconPos_On_MiddleButton = 1

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                     = %mbt_ScriptName% - Mittlere Maustaste (Mausrad)`tMButton
		Description                  = Bietet eine Auswahl an Aktionen, welche man auf die mittlere Maustaste (Mausrad) legen kann.
		lng_mbt_Action               = Mittlere Maustaste mit folgender Aktion belegen
		lng_mbt_Action1              = Klick auf die Titelleiste setzt ein Fenster in den Hintergrund
		lng_mbt_Action2              = Klick auf die Titelleiste minimiert ein Fenster
		lng_mbt_Action3              = Klick setzt ein Fenster in den Hintergrund
		lng_mbt_Action4              = Klick minimiert ein Fenster
		lng_mbt_Action5              = Führt einen Doppelklick aus
		lng_mbt_Action6              = Führt einen Dreifachklick aus
		lng_mbt_Action7              = ComfortResize
		lng_mbt_Action8              = Desktop anzeigen (Win+D)
		lng_mbt_Action9              = Desktop anzeigen (temporärer Desktop/ComfortDrag)
		lng_mbt_Action10             = Klick schließt ein Fenster
		lng_mbt_Action11             = Klick auf Titelleiste schließt ein Fenster
		lng_mbt_DisableClasses       = MiddleButton in folgenden Fenster-/Element- klassen ignorieren (* = Platzhalter; Programme verhalten sich wie bei deaktiviertem MiddleButton)

	}
	else        ; = other languages (english)
	{
		MenuName                     = %mbt_ScriptName% - middle mouse button`tMButton
		Description                  = Provides different actions to be assigned to the middle mouse button (wheel).
		lng_mbt_Action               = Assign the following action to the middle mouse button
		lng_mbt_Action1              = Set window to background when clicking on the title bar
		lng_mbt_Action2              = Minimize window when clicking on the title bar
		lng_mbt_Action3              = Set window to background
		lng_mbt_Action4              = Minimize window
		lng_mbt_Action5              = Double click
		lng_mbt_Action6              = Triple click
		lng_mbt_Action7              = ComfortResize
		lng_mbt_Action8              = Show desktop (Win+D)
		lng_mbt_Action9              = Show desktop (temporary Desktop/ComfortDrag)
		lng_mbt_Action10             = Close window
		lng_mbt_Action11             = Close window when clicking on the title bar
		lng_mbt_DisableClasses       = Disable MiddleButton in in the following controls or window classes (* = wild-card)
	}
	If CustomLanguage <>
		gosub, CustomLanguage
	IniRead, mbt_Action, %ConfigFile%, %mbt_ScriptName%, Action, 1
	IniRead, mbt_DisableClasses, %ConfigFile%, %mbt_ScriptName%, DisableClasses, MozillaDropShadowWindowClass
	mbt_DisableClasses := func_StrTrimChars(mbt_DisableClasses,"`,")
Return

SettingsGui_MiddleButton:
	StringReplace, mbt_DisableClassesCR, mbt_DisableClasses, `,, `n, a
	Gui, Add, Text, xs+10 ys+15, %lng_mbt_Action%
	Loop, 11
		Gui, Add, Radio, -wrap gsub_CheckIfSettingsChanged vmbt_Action%A_Index%, % lng_mbt_Action%A_Index%
	GuiControl,,mbt_Action%mbt_Action%, 1
	Gui, Add, Text, xs+335 ys+15 r5 w220, %lng_mbt_DisableClasses%:
	Gui, Add, Edit, xs+335 ys+70 W200 R10 gsub_CheckIfSettingsChanged vmbt_DisableClasses_tmp,%mbt_DisableClassesCR%
	Gui, Add, Button, xs+540 yp+0 W21 gmbt_sub_GetDisableClass, +

	func_CreateListOfHotkeys( "MButton", lng_mbt_Action%mbt_Action%, mbt_ScriptName )
Return

SaveSettings_MiddleButton:
	mbt_Action = 0
	Loop, 11
		mbt_Action := mbt_Action + A_Index*mbt_Action%A_Index%

	StringReplace, mbt_DisableClasses, mbt_DisableClasses_tmp, `n, `,, a
	mbt_DisableClasses := func_StrTrimChars(mbt_DisableClasses,"`,")
	IniWrite, %mbt_Action%, %ConfigFile%, %mbt_ScriptName%, Action
	IniWrite, %mbt_DisableClasses%, %ConfigFile%, %mbt_ScriptName%, DisableClasses
Return

CancelSettings_MiddleButton:
Return

DoEnable_MiddleButton:
	RegisterHook( "MButton", "MiddleButton" )
Return

DoDisable_MiddleButton:
	UnRegisterHook( "MButton", "MiddleButton" )
Return

DefaultSettings_MiddleButton:
Return

Update_MiddleButton:
	func_ReplaceExtension("WindowToBottom","MiddleButton")
	FileDelete, %A_Scriptdir%\extension\ac'tivAid_WindowToBottom.ahk
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

MButton_MiddleButton:
	MouseGetPos, mbt_MouseStartX, mbt_MouseStartY, mbt_MouseStartWinID, mbt_mouseStartClass
	WinGetClass, mbt_mouseStartClass2, ahk_id %mbt_mouseStartWinID%

	Loop, Parse, mbt_DisableClasses, `,
	{

		If (func_WildcardMatch( mbt_mouseStartClass, A_LoopField, 0) OR func_WildcardMatch( mbt_mouseStartClass2, A_LoopField, 0) )
		{
			MButton_send = yes
			Return
		}
	}

	If (mbt_Action = 1 OR mbt_Action = 2)
	{
		GetKeyState, mbt_LButton, LButton, P
		If mbt_LButton = D
			return
		Hook_MButton_Executed =
		If Enable_MiddleButton = 1
		{
			SysGet, mbt_CaptionHeight, 4 ; SM_CYCAPTION
			SysGet, mbt_BorderHeight, 7  ; SM_CXDLGFRAME

			CoordMode, Mouse, Screen
			MouseGetPos, mbt_MouseX , mbt_MouseY, mbt_WinID
			WinGetPos, mbt_WinX, mbt_WinY, mbt_WinW, mbt_WinH, ahk_id %mbt_WinID%

			mbt_WinX2 := mbt_WinX + mbt_WinW
			mbt_WinY2 := mbt_WinY + mbt_CaptionHeight + mbt_BorderHeight

			If ( mbt_MouseX >= mbt_WinX AND mbt_MouseX <= mbt_WinX2 AND mbt_MouseY >= mbt_WinY AND mbt_MouseY <= mbt_WinY2 )
			{
				WinSet, Bottom,, ahk_id %mbt_WinID%
				If mbt_Action = 2
					PostMessage,0x0112,0x0000f020,0x00f40390,,ahk_id %mbt_WinID%
					;WinMinimize, ahk_id %mbt_WinID%

;            IfWinActive, ahk_id %mbt_WinID%
;               Send,!{Tab}
				;Send,{LButton}!{ESC}
				MButton_send = no
			}
		}
	}
	Else If (mbt_Action = 3 OR mbt_Action = 4 OR mbt_Action = 10)
	{
		GetKeyState, mbt_LButton, LButton, P
		If mbt_LButton = D
			return
		Hook_MButton_Executed =
		If Enable_MiddleButton = 1
		{
			SysGet, mbt_CaptionHeight, 4 ; SM_CYCAPTION
			SysGet, mbt_BorderHeight, 7  ; SM_CXDLGFRAME

			CoordMode, Mouse, Screen
			MouseGetPos, mbt_MouseX , mbt_MouseY, mbt_WinID
			WinSet, Bottom,, ahk_id %mbt_WinID%
			If mbt_Action = 4
				PostMessage,0x0112,0x0000f020,0x00f40390,,ahk_id %mbt_WinID%
				;WinMinimize, ahk_id %mbt_WinID%
			If mbt_Action = 10
				WinClose, ahk_id %mbt_WinID%

			IfWinActive, ahk_id %mbt_WinID%
				Send,!{Tab}

			MButton_send = no
		}
	}
	Else If mbt_Action = 5
	{
		If mc_LButtonClick = yes
			Click
		Else
			Click 2
		MButton_send = no
	}
	Else If mbt_Action = 6
	{
		If Enable_MouseClip = 1
			Click 2
		Else
			Click 3
		MButton_send = no
	}
	Else If mbt_Action = 7
	{
		If Enable_ComfortResize = 1
		{
			MButton_send = no
			Gosub, MButton_ComfortResize%A_EmptyVar%
		}
	}
	Else If mbt_Action = 8
	{
		MButton_send = no
		Send, #d
	}
	Else If mbt_Action = 9
	{
		If Enable_ComfortDrag = 1
		{
			Gosub, cd_main_ComfortDrag_TempDesk%A_EmptyVar%
			MButton_send = no
		}
	}
	Else If mbt_Action = 11
	{
		GetKeyState, mbt_LButton, LButton, P
		If mbt_LButton = D
			return
		Hook_MButton_Executed =
		If Enable_MiddleButton = 1
		{
			SysGet, mbt_CaptionHeight, 4 ; SM_CYCAPTION
			SysGet, mbt_BorderHeight, 7  ; SM_CXDLGFRAME
			CoordMode, Mouse, Screen
			MouseGetPos, mbt_MouseX , mbt_MouseY, mbt_WinID
			WinGetPos, mbt_WinX, mbt_WinY, mbt_WinW, mbt_WinH, ahk_id %mbt_WinID%
			mbt_WinX2 := mbt_WinX + mbt_WinW
			mbt_WinY2 := mbt_WinY + mbt_CaptionHeight + mbt_BorderHeight
			If ( mbt_MouseX >= mbt_WinX AND mbt_MouseX <= mbt_WinX2 AND mbt_MouseY >= mbt_WinY AND mbt_MouseY <= mbt_WinY2 )
			{
				WinClose, ahk_id %mbt_WinID%
				MButton_send = no
			}
		}
	}
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

mbt_sub_GetDisableClass:
	Gui, %GuiID_activAid%:Cancel
	SplashImage,,b1 cwFFFF80 FS9 WS700 w400, %lng_getClassMsg%
	SetTimer, mbt_tim_GetClass, 10
	Input,mbt_GetKey,L1 *,{Enter}{ESC}
	SetTimer, mbt_tim_GetClass, Off
	SplashImage, Off
	ToolTip
	Gui, %GuiID_activAid%:Show
	If ErrorLevel <> Endkey:Enter
		Return

	GuiControlGet, mbt_DisableClasses_tmp
	mbt_DisableClasses_tmp = %mbt_DisableClasses_tmp%`n%mbt_GetClass%
	StringReplace, mbt_DisableClasses_tmp, mbt_DisableClasses_tmp, `n, %A_Tab%, All
	AutoTrim, On
	mbt_DisableClasses_tmp = %mbt_DisableClasses_tmp%
	AutoTrim, Off
	StringReplace, mbt_DisableClasses_tmp, mbt_DisableClasses_tmp, %A_Tab%, `n, All
	GuiControl,,mbt_DisableClasses_tmp, %mbt_DisableClasses_tmp%
	GuiControl,Focus,mbt_DisableClasses_tmp
	Send,^{End}{Space}{BS}
Return

mbt_tim_GetClass:
	MouseGetPos,,,mbt_getId,mbt_getClass
	WinGetClass, mbt_getClass, ahk_id %mbt_getId%
	If mbt_getClass =
		WinGetClass,mbt_getClass,A
	ToolTip, %mbt_getClass%
Return

