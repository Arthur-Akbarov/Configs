; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               MouseClip
; -----------------------------------------------------------------------------
; Prefix:             mc_
; Version:            1.0
; Date:               2007-10-25
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_MouseClip:
	Prefix = mc
	%Prefix%_ScriptName    = MouseClip
	%Prefix%_ScriptVersion = 1.0
	%Prefix%_Author        = Wolfgang Reszel
	IconFile_On_MouseClip = %A_WinDir%\system32\main.cpl
	IconPos_On_MouseClip = 2

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName  = %mc_ScriptName% - Kopieren/Einfügen mit der Maus
		Description = Kopieren und Einfügen mit der mittleren Maustaste
		lng_mc_copied               = kopiert
		lng_mc_PasteOnSingleClick   = Zwischenablage an Mausposition einfügen, wenn die mittlere Maustaste kurz gedrückt wird.
		lng_mc_PasteOnSingleClick1  = nein
		lng_mc_PasteOnSingleClick2  = ja
		lng_mc_PasteOnSingleClick3  = nur, wenn Text markiert ist
		lng_mc_AlwaysAllowClasses   = MouseClip in folgenden Fenster-/Element- klassen auch bei nicht sichtbaren Einfüge-Cursor erlauben (* = Platzhalter; Die programmeigene Unterstützung der mittleren Maustaste wird dabei größtenteils außer Kraft gesetzt!)
		lng_mc_DisableClasses       = `n`nMouseClip in folgenden Fenster-/Element- klassen ignorieren (* = Platzhalter; Programme verhalten sich wie bei deaktiviertem MouseClip)
	}
	else        ; = other languages (english)
	{
		MenuName  = %mc_ScriptName% - Copy/Paste with Mouse
		Description = copy and paste with the middle mousebutton
		lng_mc_copied = copied
		lng_mc_PasteOnSingleClick   = Paste clipboard to cursor-position wit the middle mouse-button.
		lng_mc_PasteOnSingleClick1  = no
		lng_mc_PasteOnSingleClick2  = yes
		lng_mc_PasteOnSingleClick3  = only if text is selected
		lng_mc_AlwaysAllowClasses   = `n`nAllow MouseClip also in the following controls or window classes, even if there is no text-cursor visible (* = wild-card)
		lng_mc_DisableClasses       = `n`n`nDisable MouseClip in the following controls or window classes (* = wild-card)
	}

	IniRead, mc_PasteOnSingleClick, %ConfigFile%, %mc_ScriptName%, PasteOnSingleClick, 2
	mc_PasteOnSingleClick := func_LimitValue(mc_PasteOnSingleClick,"1-3")
	IniRead, mc_AllowClasses, %ConfigFile%, %mc_ScriptName%, AlwaysAllowClasses, MozillaWindowClass1,MozillaWindowClass2,MozillaWindowClass11,MozillaWindowClass9
	IniRead, mc_DisableClasses, %ConfigFile%, %mc_ScriptName%, DisableClasses, PuTTY,ConsoleWindowClass,ytWindow
Return

SettingsGui_MouseClip:
	StringReplace, mc_AllowClassesCR, mc_AllowClasses, `,, `n, a
	StringReplace, mc_DisableClassesCR, mc_DisableClasses, `,, `n, a

	Gui, Add, Text, xs+10 y+10, %lng_mc_PasteOnSingleClick%
	Gui, Add, Radio, xs+10 y+5 -Wrap gsub_CheckIfSettingsChanged vmc_PasteOnSingleClick1,%lng_mc_PasteOnSingleClick1%
	Gui, Add, Radio, x+5 -Wrap gsub_CheckIfSettingsChanged vmc_PasteOnSingleClick2,%lng_mc_PasteOnSingleClick2%
	Gui, Add, Radio, x+5 -Wrap gsub_CheckIfSettingsChanged vmc_PasteOnSingleClick3,%lng_mc_PasteOnSingleClick3%
	GuiControl,,mc_PasteOnSingleClick%mc_PasteOnSingleClick%, 1
	Gui, Add, Text, xs+10 ys+63 r5 w230, %lng_mc_AlwaysAllowClasses%:
	Gui, Add, Edit, xs+10 ys+135 W200 R10 gsub_CheckIfSettingsChanged vmc_AllowClasses,%mc_AllowClassesCR%
	Gui, Add, Button, xs+215 yp+0 W21 gmc_sub_GetClass, +
	Gui, Add, Text, xs+270 ys+63 r5 w230, %lng_mc_DisableClasses%:
	Gui, Add, Edit, xs+270 ys+135 W200 R10 gsub_CheckIfSettingsChanged vmc_DisableClasses,%mc_DisableClassesCR%
	Gui, Add, Button, xs+475 yp+0 W21 gmc_sub_GetDisableClass, +

	func_CreateListOfHotkeys( "MButton", ExtensionDescription[MouseClip], mc_ScriptName )
Return

SaveSettings_MouseClip:
	If mc_PasteOnSingleClick1 = 1
		mc_PasteOnSingleClick = 1
	If mc_PasteOnSingleClick2 = 1
		mc_PasteOnSingleClick = 2
	If mc_PasteOnSingleClick3 = 1
		mc_PasteOnSingleClick = 3
	IniWrite, %mc_PasteOnSingleClick%, %ConfigFile%, %mc_ScriptName%, PasteOnSingleClick
	StringReplace, mc_AllowClasses, mc_AllowClasses, `n, `,, a
	StringReplace, mc_DisableClasses, mc_DisableClasses, `n, `,, a
	IniWrite, %mc_AllowClasses%, %ConfigFile%, %mc_ScriptName%, AlwaysAllowClasses
	IniWrite, %mc_DisableClasses%, %ConfigFile%, %mc_ScriptName%, DisableClasses
Return

CancelSettings_MouseClip:
Return

DoEnable_MouseClip:
	RegisterHook( "MButton", "MouseClip", 1 )
	mc_LButtonClick =
Return

DoDisable_MouseClip:
	UnRegisterHook( "MButton", "MouseClip" )
	mc_LButtonClick =
Return

DefaultSettings_MouseClip:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =============================================================mc==
; -----------------------------------------------------------------------------

MButton_MouseClip:
	mc_LButtonClick =
	SetKeyDelay,0,0
	SetMouseDelay,-1

	CoordMode,Mouse,Screen

	MouseGetPos, mc_MouseStartX, mc_MouseStartY, mc_MouseStartWinID, mc_mouseStartClass
	WinGetTitle, mc_mouseStartTitle, ahk_id %mc_mouseStartWinID%
	WinGetClass, mc_mouseStartClass2, ahk_id %mc_mouseStartWinID%

	Loop, Parse, mc_DisableClasses, `,
	{
		If (func_WildcardMatch( mc_mouseStartClass, A_LoopField, 0) OR mc_mouseStartClass2 = A_LoopField )
		{
			MButton_send = yes
			Return
		}
	}

	; Adobe-Anwendung erkennen
	StringLeft, mc_mouseStartTitle, mc_mouseStartTitle, 6
	If (mc_mouseStartTitle = "Adobe ")
		mc_mouseStartTitle = Adobe

	mc_doit =
	; wenn mittlere Maustaste gedrückt und der Textmauspfeil (IBeam) sichtbar ist
	If (A_Cursor = "IBeam" OR (A_Cursor = "Unknown" AND mc_mouseStartClass="_WwG1") OR (A_Cursor = "Arrow" AND mc_mouseStartClass="_WwG1") OR (A_Cursor = "Unknown" AND mc_mouseStartTitle = "Adobe") )
		mc_doit = 1

	If mc_mouseStartClass in %mc_AllowClasses%
		mc_doit = 1

	If mc_doit = 1
	{
		Blockinput, MouseMove
		func_GetSelection(0, 1, 0.5)
		mc_cliptemp_text := Clipboard
		Blockinput, MouseMoveOff
		Click down

		Critical
		mc_TimeTillRelease := A_Tickcount
		KeyWait,MButton
		mc_TimeTillRelease := A_Tickcount - mc_TimeTillRelease
		Critical, Off

		Blockinput, MouseMove

		MouseGetPos, mc_MouseEndX, mc_MouseEndY
		mc_diffX := abs(mc_MouseStartX - mc_MouseEndX)
		mc_diffY := abs(mc_MouseStartY - mc_MouseEndY)

		Click up
		mc_LButtonClick = yes

		If mc_mouseStartTitle contains Adobe
			SetKeyDelay,20,10

		If ( mc_TimeTillRelease > 100 AND ( mc_diffX > 4 OR mc_diffY > 4 ) )
		{
			func_GetSelection(0,1)
			ToolTip, %lng_mc_copied%

			If mc_mouseStartTitle contains Adobe
			{
				Gui, 99:+ToolWindow
				Gui, 99:Show, x-1000 y-1000 w10 h10
				ClipWait,1
				Gui, 99:Destroy
			}

			Blockinput, MouseMoveOff
			Sleep,400
			ToolTip
		}
		Else
		{
			If mc_TimeTillRelease < 900
			{
				If (mc_cliptemp_text <> "" AND mc_PasteOnSingleClick > 1)
				{
					SavedClipboard := mc_cliptemp_text
					tooltip, %lng_mc_copied%
				}

				MouseGetPos,,,mc_actID
				IfWinNotActive, ahk_id %mc_actID%
				{
					WinActivate, ahk_id %mc_actID%
					WinWaitActive, ahk_id %mc_actID%
				}

				If mc_mouseStartTitle contains Adobe,Microsoft Word
				{
					Gui, 99:+ToolWindow
					Gui, 99:Show, x-1000 y-1000 w10 h10
					Sleep, 10
					Gui, 99:Destroy
				}

				If ( mc_PasteOnSingleClick = 2 OR ( mc_cliptemp_text <> "" AND mc_PasteOnSingleClick = 3 ) )
				{
					Clipboard := SavedClipboard
					If mc_NoPaste =
						SendEvent,^v
					ToolTip
				}
			}
		}
		Blockinput, MouseMoveOff
		MButton_send = no
	}
	Else
	{
		If Enable_WebSearchOnMButton = 1
			MButton_send = no2
		Else
			MButton_send =
	}
	mc_NoPaste =
Return

; -----------------------------------------------------------------------------
; === Subroutines =========================================================mc==
; -----------------------------------------------------------------------------


mc_sub_GetDisableClass:
	mc_ClassList = 1
	Gosub, mc_sub_GetClass
Return

mc_sub_GetClass:
	Gui, %GuiID_activAid%:Cancel
	SplashImage,,b1 cwFFFF80 FS9 WS700 w400, %lng_getClassMsg%
	SetTimer, mc_tim_GetClass, 10
	Input,mc_GetKey,L1 *,{Enter}{ESC}
	SetTimer, mc_tim_GetClass, Off
	SplashImage, Off
	ToolTip
	Gui, %GuiID_activAid%:Show
	If ErrorLevel <> Endkey:Enter
		Return
	If mc_ClassList =
	{
		GuiControlGet, mc_AllowClasses_tmp,, mc_AllowClasses
		mc_AllowClasses_tmp = %mc_AllowClasses_tmp%`n%mc_GetClass%
		StringReplace, mc_AllowClasses_tmp, mc_AllowClasses_tmp, `n, %A_Tab%, All
		AutoTrim, On
		mc_AllowClasses_tmp = %mc_AllowClasses_tmp%%A_Tab%%mc_GetClass%
		AutoTrim, Off
		StringReplace, mc_AllowClasses_tmp, mc_AllowClasses_tmp, %A_Tab%%A_Tab%, %A_Tab%, All
		StringReplace, mc_AllowClasses_tmp, mc_AllowClasses_tmp, %A_Tab%, `n, All
		GuiControl,,mc_AllowClasses, %mc_AllowClasses_tmp%
		GuiControl,Focus,mc_AllowClasses
	}
	Else
	{
		GuiControlGet, mc_DisableClasses_tmp,, mc_DisableClasses
		mc_DisableClasses_tmp = %mc_DisableClasses_tmp%
		StringReplace, mc_DisableClasses_tmp, mc_DisableClasses_tmp, `n, %A_Tab%, All
		AutoTrim, On
		mc_DisableClasses_tmp = %mc_DisableClasses_tmp%%A_Tab%%mc_GetClass%
		AutoTrim, Off
		StringReplace, mc_DisableClasses_tmp, mc_DisableClasses_tmp, %A_Tab%%A_Tab%, %A_Tab%, All
		StringReplace, mc_DisableClasses_tmp, mc_DisableClasses_tmp, %A_Tab%, `n, All
		GuiControl,,mc_DisableClasses, %mc_DisableClasses_tmp%
		GuiControl,Focus,mc_DisableClasses
	}
	Send,^{End}{Space}{BS}
	mc_ClassList =
Return

mc_tim_GetClass:
	MouseGetPos,,,mc_getId,mc_getClass
	WinGetClass, mc_getClass, ahk_id %mc_getId%
	If mc_getClass =
		WinGetClass,mc_getClass,A
	ToolTip, %mc_getClass%
Return
