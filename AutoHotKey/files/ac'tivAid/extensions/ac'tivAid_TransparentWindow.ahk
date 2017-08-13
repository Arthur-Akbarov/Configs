; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               TransparentWindow
; -----------------------------------------------------------------------------
; Prefix:             TRA_
; Version:            0.5
; Date:               2008-05-23
; Author:             Werner Piel, Wolfgang Reszel (Code from NiftyWindows)
; Copyright der Erw.: 2008 Heise Zeitschriften Verlag GmbH & Co. KG
/*
 * Copyright (c) 2004-2005 by Enovatic-Solutions. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * ----------------------------------------------------------------------
 * If you have any suggestions of new features or further questions
 * feel free to contact the author.
 *
 * Company:  Enovatic-Solutions (IT Service Provider)
 * Author:   Oliver Pfeiffer, Bremen (GERMANY)
 * Homepage: http://www.enovatic.org/
 * Email:    contact@enovatic.org
 */

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_TransparentWindow:

	Prefix = TRA
	%Prefix%_ScriptName    = TransparentWindow
	%Prefix%_ScriptVersion = 0.5
	%Prefix%_Author        = Werner Piel, Wolfgang Reszel, Oliver Pfeiffer
	EnableTray_TransparentWindow   = 1           ; Soll eine Erweiterung nicht im Tray-Menü aufgeführt werden, muss der Wert 0 betragen

	CreateGuiID("TransparentWindow")

	IconFile_On_TransparentWindow = %A_WinDir%\system32\shell32.dll
	IconPos_On_TransparentWindow = 99

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %TRA_ScriptName% - Fenster transparent machen
		Description                   = Macht Fenster mittels Win+Mausrad oder automatisch transparent

		lng_TRA_ResetTransparency     = Zurücksetzen aller Transparenz-Effekte
		lng_TRA_ResetWinTransparency  = Zurücksetzen der Transparenz-Effekte des Fensters
		lng_TRA_PixelTransparency     = Pixel-Transparenz
		lng_TRA_PixelTransAOT         = Pixel-Transparenz mit AlwaysOnTop
		lng_TRA_ShowTooltip           = Prozentsatz der Transparenz in Tooltip anzeigen
		lng_TRA_SetTrans              = Transparenz des aktiven Fensters schrittweise anpassen
		lng_TRA_Transparency          = Transparenz
		lng_TRA_All                   = Alles
		lng_TRA_Color                 = Farbe
		lng_TRA_AOT                   = Im im Vordergrund (AOT)
		lng_TRA_AOT_Transp            = zugleich mit Fenstertransparenz in `%
		lng_TRA_ManualTransparency    = Manuelle Transparenz
		lng_TRA_AutoTransparency      = Automatische Transparenz
		lng_TRA_AutoTransActiveWindow = Aktive Anwendung:
		lng_TRA_AutoTransSameProc     = Gleiche Anwendung:
		lng_TRA_AutoTransOver         = Unter Maus:
		lng_TRA_AutoTransInactive     = Inaktiv:
		lng_TRA_ExcludeWindows        = Fenster ausschließen oder feste Transparenzen zuweisen
		lng_TRA_DisableClasses        = Die automatische Transparenz bei folgenden Fensterklassen ignorieren (* = Platzhalter)
		lng_TRA_FixedTransClasses     = Folgende Fenster immer mit der angegebenen Transparenz darstellen (z. B. Notepad=30)
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %TRA_ScriptName% - Kurzbeschreibung
		Description                   = Provides window transparency with Win+Mouse wheel or automatically

		lng_TRA_ResetTransparency     = Reset all transparency effects
		lng_TRA_ResetWinTransparency  = Reset transparency effects of window
		lng_TRA_PixelTransparency     = Pixel transparency
		lng_TRA_PixelTransAOT         = Pixel transparency and always on top
		lng_TRA_ShowTooltip           = Show percentage of transparency in tooltip
		lng_TRA_SetTrans              = Set transparency of the active window
		lng_TRA_Transparency          = Transparency
		lng_TRA_All                   = All
		lng_TRA_Color                 = Color
		lng_TRA_AOT                   = Always On Top
		lng_TRA_AOT_Transp            = together with transparency in `%
		lng_TRA_ManualTransparency    = Manual transparency
		lng_TRA_AutoTransparency      = Automatic transparency
		lng_TRA_AutoTransActiveWindow = Active application:
		lng_TRA_AutoTransSameProc     = Same application:
		lng_TRA_AutoTransOver         = Under mouse:
		lng_TRA_AutoTransInactive     = Inactive:
		lng_TRA_ExcludeWindows        = Exclude/hide windows
		lng_TRA_DisableClasses        = Exclude the following window classes for the automatic transparency (* = wildcard)
		lng_TRA_FixedTransClasses     = Always set the following window classes to a specified transparency (e.g. Notepad=30)
	}
	TRA_enabled = 1   ; extension ist enabled
	TRA_showTip = 1   ; default for "show percentage in tooltip"

	func_HotkeyRead( "TRA_TransparencyAllOff_HK", ConfigFile , TRA_ScriptName, "TransparencyAllOff", "TRA_reset_TransparentAll", "^#t" )
	func_HotkeyRead( "TRA_TransparencyWinOff_HK", ConfigFile , TRA_ScriptName, "TransparencyWinOff", "TRA_reset_TransparentWin", "#+LButton" )
	func_HotkeyRead( "TRA_PixelTransparency_HK", ConfigFile , TRA_ScriptName, "PixelTransparency", "TRA_PixelTransparency", "^#LButton" )
	func_HotkeyRead( "TRA_PixelTransAOT_HK", ConfigFile , TRA_ScriptName, "PixelTransAOT", "TRA_PixelTrans_AOT", "^#!LButton" )
	IniRead, TRA_AOT_Transp, %ConfigFile%, %TRA_ScriptName%, AOT_Transp, 25
	IniRead, TRA_AutoTransparency, %ConfigFile%, %TRA_ScriptName%, AutoTransparency, 0
	IniRead, TRA_AutoTransActiveWindow, %ConfigFile%, %TRA_ScriptName%, AutoTransparencyActiveWindow, 100
	IniRead, TRA_AutoTransSameProc, %ConfigFile%, %TRA_ScriptName%, AutoTransparencySameProcess, 100
	IniRead, TRA_AutoTransOver, %ConfigFile%, %TRA_ScriptName%, AutoTransparencyMouseOver, 85
	IniRead, TRA_AutoTransInactive, %ConfigFile%, %TRA_ScriptName%, AutoTransparencyInactive, 20
	IniRead, TRA_DisableClasses, %ConfigFile%, %TRA_ScriptName%, DisableClasses, %A_Space%
	IniRead, TRA_FixedTransClasses, %ConfigFile%, %TRA_ScriptName%, FixedTransClasses, %A_Space%
	IniRead, TRA_EnableAutoTransOver, %ConfigFile%, %TRA_ScriptName%, AutoTransMouseOver, 1
	TRA_AOT_Transp := func_LimitValue( TRA_AOT_Transp, "0-100",25)
	TRA_AutoTransActiveWindow:= func_LimitValue( TRA_AutoTransActiveWindow, "0-100",100)
	TRA_AutoTransSameProc := func_LimitValue( TRA_AutoTransSameProc, "0-100",100)
	TRA_AutoTransOver:= func_LimitValue( TRA_AutoTransOver, "0-100",85)
	TRA_AutoTransInactive:= func_LimitValue( TRA_AutoTransInactive, "0-100",20)
	TRA_IgnoreClasses = Shell_TrayWnd,Progman,WorkerW,BaseBar,SysShadow,TaskSwitcherOverlayWnd,TaskSwitcherWnd,tooltips_class32,ThumbnailClass,AutoHotkey2,CiceroUIWndFrame,Button
Return

; Die folgende Routine enthält alle Befehle, welche dazu nötig sind den Konfigurationsdialog zu ergänzen
SettingsGui_TransparentWindow:
	StringReplace, TRA_DisableClasses_tmp, TRA_DisableClasses, `,,`n,A
	StringReplace, TRA_FixedTransClasses_tmp, TRA_FixedTransClasses, `,,`n,A

	; Schaltfläche für Abfrage eines Tastaturkürzels hinzufügen
	func_HotkeyAddGuiControl( lng_TRA_ResetTransparency, "TRA_TransparencyAllOff_HK", "xs+10 y+10 w240" )
	Gui, Add, GroupBox, h135 w555 xs+10 ys+45
	Gui, Add, GroupBox, h95 w555 xs+10 ys+185
	Gui, Add, Radio, xs+20 ys+185 gTRA_sub_CheckIfSettingsChanged vTRA_AutoTransparency, %lng_TRA_AutoTransparency%
	Gui, Add, Radio, xs+20 ys+45 gTRA_sub_CheckIfSettingsChanged vTRA_ManualTransparency, %lng_TRA_ManualTransparency%

	func_HotkeyAddGuiControl( lng_TRA_ResetWinTransparency, "TRA_TransparencyWinOff_HK", "xs+20 y+10 w250", "", "w280" )
	func_HotkeyAddGuiControl( lng_TRA_PixelTransparency, "TRA_PixelTransparency_HK", "xs+20 y+10 w250", "", "w280" )
	func_HotkeyAddGuiControl( lng_TRA_PixelTransAOT, "TRA_PixelTransAOT_HK", "xs+20 y+10 w250", "", "w280" )
	Gui, Add, Text, xs+20 y+10 vTRA_Text_AOT_Transp, %lng_TRA_AOT_Transp%
	Gui, Add, Slider, x+20 y+-18 vTRA_AOT_Transp gsub_CheckIfSettingsChanged  AltSubmit TickInterval5 ToolTip Page10 gTRA_SaveTransp
	GuiControl,,TRA_AOT_Transp, %TRA_AOT_Transp%
	Gui, Add, Checkbox, x+20 yp+3 w200 R2 gsub_CheckIfSettingsChanged vTRA_showTip checked%TRA_showTip%, %lng_TRA_ShowTooltip%

	Gui, Add, Text, xs+20 ys+210 w100 vTRA_Text_AutoTransActiveWindow, %lng_TRA_AutoTransActiveWindow%
	Gui, Add, Slider, x+0 yp-5 w160 vTRA_AutoTransActiveWindow gsub_CheckIfSettingsChanged AltSubmit TickInterval5 ToolTip Page10 ; gTRA_SaveTransp
	GuiControl,,TRA_AutoTransActiveWindow, %TRA_AutoTransActiveWindow%
	Gui, Add, Text, x+15 yp+5 w100 vTRA_Text_AutoTransSameProc, %lng_TRA_AutoTransSameProc%
	Gui, Add, Slider, x+0 yp-5 w160 vTRA_AutoTransSameProc gsub_CheckIfSettingsChanged AltSubmit TickInterval5 ToolTip Page10 ; gTRA_SaveTransp
	GuiControl,,TRA_AutoTransSameProc, %TRA_AutoTransSameProc%

	Gui, Add, CheckBox, xs+20 y+5 w100 gsub_CheckIfSettingsChanged vTRA_EnableAutoTransOver Checked%TRA_EnableAutoTransOver%, %lng_TRA_AutoTransOver%
	Gui, Add, Slider, x+0 yp-5 w160 vTRA_AutoTransOver gsub_CheckIfSettingsChanged AltSubmit TickInterval5 ToolTip Page10 ; gTRA_SaveTransp
	GuiControl,,TRA_AutoTransOver, %TRA_AutoTransOver%
	Gui, Add, Text, x+15 yp+5 w100 vTRA_Text_AutoTransInactive, %lng_TRA_AutoTransInactive%
	Gui, Add, Slider, x+0 yp-5 w160 vTRA_AutoTransInactive gsub_CheckIfSettingsChanged AltSubmit TickInterval5 ToolTip Page10 ; gTRA_SaveTransp
	GuiControl,,TRA_AutoTransInactive, %TRA_AutoTransInactive%

	If TRA_AutoTransparency = 1
		GuiControl,,TRA_AutoTransparency, 1
	Else
		GuiControl,,TRA_ManualTransparency, 1
	func_CreateListOfHotkeys( "#WheelUp", lng_TRA_SetTrans, "TransparentWindow", "#WheelUp"  )
	func_CreateListOfHotkeys( "#+WheelUp", lng_TRA_SetTrans, "TransparentWindow", "#+WheelUp"  )
	func_CreateListOfHotkeys( "#WheelDown", lng_TRA_SetTrans, "TransparentWindow", "#WheelDown"  )
	func_CreateListOfHotkeys( "#+WheelDown", lng_TRA_SetTrans, "TransparentWindow", "#+WheelDown"  )

	Gui, Add, Button, xs+270 w300 ys+290 h16 vTRA_sub_ExcludeWindows gTRA_sub_ExcludeWindows, %lng_TRA_ExcludeWindows% ...

	Gosub, TRA_sub_CheckIfSettingsChanged
Return

TRA_sub_CheckIfSettingsChanged:
	Gosub, sub_CheckIfSettingsChanged
	GuiControlGet, TRA_AutoTransparency_tmp, , TRA_AutoTransparency
	TRA_Group1 = Hotkey_TRA_TransparencyWinOff_HK,Hotkey_TRA_PixelTransparency_HK,Hotkey_TRA_PixelTransAOT_HK,HotkeyText_TRA_TransparencyWinOff_HK,HotkeyText_TRA_PixelTransparency_HK,HotkeyText_TRA_PixelTransAOT_HK,TRA_AOT_Transp,TRA_showTip,TRA_Text_AOT_Transp
	TRA_Group2 = TRA_AutoTransActiveWindow,TRA_AutoTransSameProc,TRA_AutoTransOver,TRA_AutoTransInactive,TRA_Text_AutoTransActiveWindow,TRA_Text_AutoTransSameProc,TRA_EnableAutoTransOver,TRA_Text_AutoTransInactive,TRA_sub_ExcludeWindows
	If TRA_AutoTransparency_tmp = 1
	{
		Loop, Parse, TRA_Group1, `,
			GuiControl, Disable, %A_LoopField%
		Loop, Parse, TRA_Group2, `,
			GuiControl, Enable, %A_LoopField%
	}
	Else
	{
		Loop, Parse, TRA_Group1, `,
			GuiControl, Enable, %A_LoopField%
		Loop, Parse, TRA_Group2, `,
			GuiControl, Disable, %A_LoopField%
	}
Return

TRA_sub_ExcludeWindows:
	Gui, %GuiID_activAid%:+Disabled
	GuiDefault("TransparentWindow", "+Owner" GuiID_activAid)
	Gosub, GuiDefaultFont

	Gui, Add, Text, w330, %lng_TRA_DisableClasses%:
	Gui, Add, Edit, y+8 W315 Section h180 vTRA_DisableClasses_tmp, %TRA_DisableClasses_tmp%
	Gui, Add, Button, xs+320 ys+0 W21 vTRA_Button_DisableClasses_tmp gTRA_sub_GetExcludeClass, +

	Gui, Add, Text, xs+0 ys+190 w330, %lng_TRA_FixedTransClasses%:
	Gui, Add, Edit, y+8 W315 Section h180 vTRA_FixedTransClasses_tmp, %TRA_FixedTransClasses_tmp%
	Gui, Add, Button, xs+320 ys+0 W21 vTRA_Button_FixedTransClasses_tmp gTRA_sub_GetExcludeClass, +

	Gui, Add, Button, -Wrap ys+190 x95 W80 Default gTRA_sub_ExcludeWindowsOK, %lng_OK%
	Gui, Add, Button, -Wrap X+1 W80 gTransparentWindowGuiClose, %lng_cancel%


	Gui, Show, w355 , %lng_TRA_ExcludeWindows%

	Send,^{End}{Space}{BS}
Return

TransparentWindowGuiClose:
TransparentWindowGuiEscape:
	Gui, %GuiID_activAid%:-Disabled
	Gui, Destroy
Return

TRA_sub_ExcludeWindowsOK:
	Gui, Submit, Nohide
	Gosub, TransparentWindowGuiClose
	func_SettingsChanged( TRA_ScriptName )
Return

TRA_sub_GetExcludeClass:
	StringReplace,TRA_GuiControl, A_GuiControl, _Button_, _
	Gui, %GuiID_activAid%:Cancel
	Gui, %GuiID_TransparentWindow%:Cancel
	SplashImage,,b1 cwFFFF80 FS9 WS700 w400, %lng_getWindowClassMsg%
	SetTimer, TRA_tim_GetClass, 10
	Input,TRA_GetKey,L1 *,{Enter}{ESC}
	SetTimer, TRA_tim_GetClass, Off
	SplashImage, Off
	ToolTip
	Gui, %GuiID_activAid%:Show
	Gui, %GuiID_TransparentWindow%:Show
	If ErrorLevel <> Endkey:Enter
		Return

	GuiControlGet, %TRA_GuiControl%, %GuiID_TransparentWindow%:, %TRA_GuiControl%
	StringReplace, %TRA_GuiControl%, %TRA_GuiControl%, `n, %A_Tab%, All
	%TRA_GuiControl% = % func_StrTrimChars(%TRA_GuiControl% A_Tab TRA_GetClass)
	StringReplace, %TRA_GuiControl%, %TRA_GuiControl%, %A_Tab%%A_Tab%, %A_Tab%, All
	StringReplace, %TRA_GuiControl%, %TRA_GuiControl%, %A_Tab%, `n, All
	GuiControl,%GuiID_TransparentWindow%:,%TRA_GuiControl%, % %TRA_GuiControl%
	GuiControl,%GuiID_TransparentWindow%:Focus,%TRA_GuiControl%
	;Send,^{End}{Space}{BS}
	TRA_ClassList =
Return

TRA_tim_GetClass:
	MouseGetPos,,,TRA_getId,TRA_getClass
	WinGetClass, TRA_getClass, ahk_id %TRA_getId%
	WinGetTitle, TRA_getTitle, ahk_id %TRA_getId%
	If TRA_getClass =
		WinGetClass,TRA_getClass,A
	ToolTip, %TRA_getClass%`n(%TRA_getTitle%)
Return

; wird aufgerufen, wenn im Konfigurationsdialog OK oder Übernehmen angeklickt wird
SaveSettings_TransparentWindow:
	; Syntax: HotkeyWrite ( Name des Tastaturkürzels, INI-Datei, Sektion, INI-Variable [, Subroutine des Tastaturkürzels] )
	func_HotkeyWrite( "TRA_TransparencyAllOff_HK", ConfigFile, TRA_ScriptName, "TransparencyAllOff" )
	func_HotkeyWrite( "TRA_TransparencyWinOff_HK", ConfigFile, TRA_ScriptName, "TransparencyWinOff" )
	func_HotkeyWrite( "TRA_PixelTransparency_HK", ConfigFile, TRA_ScriptName, "PixelTransparency" )
	func_HotkeyWrite( "TRA_PixelTransAOT_HK", ConfigFile, TRA_ScriptName, "PixelTransAOT" )

	IniWrite, %TRA_AutoTransparency%, %ConfigFile%, %TRA_ScriptName%, AutoTransparency
	IniWrite, %TRA_AOT_Transp%, %ConfigFile%, %TRA_ScriptName%, AOT_Transp
	IniWrite, %TRA_AutoTransSameProc%, %ConfigFile%, %TRA_ScriptName%, AutoTransparencySameProcess
	IniWrite, %TRA_AutoTransOver%, %ConfigFile%, %TRA_ScriptName%, AutoTransparencyMouseOver
	IniWrite, %TRA_AutoTransInactive%, %ConfigFile%, %TRA_ScriptName%, AutoTransparencyInactive
	IniWrite, %TRA_AutoTransActiveWindow%, %ConfigFile%, %TRA_ScriptName%, AutoTransparencyActiveWindow

	StringReplace, TRA_DisableClasses, TRA_DisableClasses_tmp, `n,`,,A
	StringReplace, TRA_FixedTransClasses, TRA_FixedTransClasses_tmp, `n,`,,A
	IniWrite, %TRA_DisableClasses%, %ConfigFile%, %TRA_ScriptName%, DisableClasses
	IniWrite, %TRA_FixedTransClasses%, %ConfigFile%, %TRA_ScriptName%, FixedTransClasses
	IniWrite, %TRA_EnableAutoTransOver%, %ConfigFile%, %TRA_ScriptName%, AutoTransMouseOver

	; Wenn es nötig ist, dass ac'tivAid nach dem Speichern der Einstellungen neu geladen werden muss, kann man Reload auf 1 setzen
	; Reload = 1
Return

; Wird aufgerufen, wenn Einstellungen über das 'Pfeil'-Menü hinzugefügt werden, ist nur notwendig wenn AddSettings_NAMEDERERWEITERUNG = 1
AddSettings_TransparentWindow:
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_TransparentWindow:
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_TransparentWindow:
	TRA_enabled = 1
	func_HotkeyEnable("TRA_TransparencyAllOff_HK")
	If TRA_AutoTransparency = 1
	{
		SetTimer, TRA_tim_AutoTransparency, 20
		TRA_tim_AutoTransparency = on
	}
	Else
	{
		func_HotkeyEnable("TRA_TransparencyWinOff_HK")
		func_HotkeyEnable("TRA_PixelTransparency_HK")
		func_HotkeyEnable("TRA_PixelTransAOT_HK")
		Hotkey, #WheelUp, On
		Hotkey, #+WheelUp, On
		Hotkey, #WheelDown, On
		Hotkey, #+WheelDown, On
	}
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern der Einstellungen aufgerufen
DoDisable_TransparentWindow:
	TRA_enabled = 0
	SetTimer, TRA_tim_AutoTransparency, Off
	TRA_tim_AutoTransparency = off
	func_HotkeyDisable("TRA_TransparencyAllOff_HK")
	func_HotkeyDisable("TRA_TransparencyWinOff_HK")
	func_HotkeyDisable("TRA_PixelTransparency_HK")
	func_HotkeyDisable("TRA_PixelTransAOT_HK")
	Gosub, TRA_TransparencyAllOff
	Hotkey, #WheelUp, Off
	Hotkey, #+WheelUp, Off
	Hotkey, #WheelDown, Off
	Hotkey, #+WheelDown, Off
	TRA_LastWinList =
	TRA_LastActWinID =
	TRA_LastOverWinID =
Return

; wird aufgerufen, wenn der Anwender die Erweiterung auf die Standard-Einstellungen zurücksetzt
DefaultSettings_TransparentWindow:
	Gosub, TRA_TransparencyAllOff
Return

; wird aufgerufen, wenn ac'tivAid beendet oder neu geladen wird.
OnExitAndReload_TransparentWindow:
	Gosub, TRA_TransparencyAllOff
Return

TRA_SaveTransp:
	func_SettingsChanged( "TransparentWindow" )
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

TRA_reset_TransparentAll:
	If TRA_AutoTransparency = 1
	{
		If TRA_tim_AutoTransparency = on
		{
			Gosub, TRA_TransparencyAllOff
			SetTimer, TRA_tim_AutoTransparency, off
			TRA_tim_AutoTransparency = off
			TRA_LastWinList =
			TRA_LastActWinID =
			TRA_LastOverWinID =
		}
		Else
		{
			SetTimer, TRA_tim_AutoTransparency, on
			TRA_tim_AutoTransparency = on
		}
	}
	Else
	{
		Gosub, TRA_TransparencyAllOff
		TRA_ToolTipText = %lng_TRA_Transparency%: %lng_TRA_All% %lng_Off%
		Gosub, TRA_ToolTipFeedbackShow
	}
Return

TRA_PixelTransparency:
	TRA_AOT = 0
	Gosub, TRA_PixelTransparency_AOT
Return

TRA_PixelTrans_AOT:
	TRA_AOT = 1
	Gosub, TRA_PixelTransparency_AOT
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

; [TRA] provides window transparency
/**
 * Adjusts the transparency of the active window in ten percent steps
 * (opaque = 100%) which allows the contents of the windows behind it to shine
 * through. If the window is completely transparent (0%) the window is still
 * there and clickable. If you loose a transparent window it will be extremly
 * complicated to find it again because it's invisible (see the first hotkey
 * in this list for emergency help in such situations).
 */
#WheelUp::
#+WheelUp::
#WheelDown::
#+WheelDown::
	if (TRA_enabled = 0)
		Return
	WinGetClass, TRA_WinClass, A
	If TRA_WinClass in %TRA_IgnoreClasses%
		Return
	Gosub, TRA_CheckWinIDs
	SetWinDelay, -1
	IfWinActive, A
	{
		WinGet, TRA_WinID, ID
		If ( !TRA_WinID )
			Return

		IfNotInString, TRA_WinIDs, |%TRA_WinID%
			TRA_WinIDs = %TRA_WinIDs%|%TRA_WinID%
		TRA_WinAlpha := TRA_WinAlpha%TRA_WinID%
		TRA_PixelColor := TRA_PixelColor%TRA_WinID%

		IfInString, A_ThisHotkey, +
			TRA_WinAlphaStep := 255 * 0.01 ; 1 percent steps
		Else
			TRA_WinAlphaStep := 255 * 0.1 ; 10 percent steps

		If ( TRA_WinAlpha = "" )
			TRA_WinAlpha = 255

		IfInString, A_ThisHotkey, WheelDown
			TRA_WinAlpha -= TRA_WinAlphaStep
		Else
			TRA_WinAlpha += TRA_WinAlphaStep

		If ( TRA_WinAlpha > 255 )
			TRA_WinAlpha = 255
		Else
			If ( TRA_WinAlpha < 0 )
				TRA_WinAlpha = 0

		If ( !TRA_PixelColor and (TRA_WinAlpha = 255) )
		{
			Gosub, TRA_TransparencyOff
			TRA_ToolTipText = %lng_TRA_Transparency%: %lng_Off%
		}
		Else
		{
			TRA_WinAlpha%TRA_WinID% = %TRA_WinAlpha%

			If ( TRA_PixelColor )
				WinSet, TransColor, %TRA_PixelColor% %TRA_WinAlpha%, ahk_id %TRA_WinID%
			Else
				WinSet, Transparent, %TRA_WinAlpha%, ahk_id %TRA_WinID%

			TRA_ToolTipAlpha := TRA_WinAlpha * 100 / 255
			Transform, TRA_ToolTipAlpha, Round, %TRA_ToolTipAlpha%
			TRA_ToolTipText = %lng_TRA_Transparency%: %TRA_ToolTipAlpha% `%
		}
		Gosub, TRA_ToolTipFeedbackShow
	}
Return

TRA_tim_AutoTransparency:
	If OptionsListBoxClick = 1
		Return
	DetectHiddenWindows, Off
	WinGet, TRA_WinList, List,,,ahk_class tooltips_class32
	WinGet, TRA_ActWinProc, ProcessName, A
	WinGet, TRA_ActWinID, ID, A
	MouseGetPos,,,TRA_OverWinID
	If ((TRA_WinList = TRA_LastWinList AND TRA_ActWinID = TRA_LastActWinID AND TRA_OverWinID = TRA_LastOverWinID) OR !TRA_ActWinID)
		Return
	WinGetClass, TRA_ActWinIDClass, A
	If TRA_ActWinClass in tooltips_class32
		Return

	TRA_FirstInActiveWin =
	a =
	Loop, %TRA_WinList%
	{
		TRA_WinID := TRA_WinList%A_Index%
		If ( !TRA_WinID )
			continue

		WinGetClass, TRA_WinClass, ahk_id %TRA_WinID%
		WinGet, TRA_WinProc, ProcessName, ahk_id %TRA_WinID%
		WinGetTitle, TRA_WinTitle, ahk_id %TRA_WinID%
		WinGet, TRA_MinMax, MinMax, ahk_id %TRA_WinID%
		If TRA_MinMax = -1
			continue
		If TRA_WinClass in %TRA_IgnoreClasses%
			continue
		If TRA_WinTitle in ComfortDragWhileDragging,aadScreenLoupe,aadScreenShots
			continue

		IfNotInString, TRA_WinIDs, |%TRA_WinID%
		{
			WinGet, TRA_ExStyle, ExStyle, ahk_id %TRA_WinID%
			If (TRA_ExStyle & 0x80000) ; WS_EX_LAYERED
				TRA_AutoIgnoreWindows = %TRA_AutoIgnoreWindows%`n%TRA_WinClass%`t%TRA_WinTitle%`n
		}

		IfInString, TRA_AutoIgnoreWindows, `n%TRA_WinClass%`t%TRA_WinTitle%`n
			continue

		TRA_Break =
		Loop, Parse, TRA_DisableClasses, `,
		{
			If (func_WildcardMatch( TRA_WinTitle, A_LoopField, 0) OR func_WildcardMatch( TRA_WinClass, A_LoopField, 0) )
			{
				TRA_Break = 1
				Break
			}
		}
		If TRA_Break = 1
			Continue

		TRA_LastWinAlpha := TRA_WinAlpha%TRA_WinID%

		Gosub, TRA_CheckWinIDs
		SetWinDelay, -1
		TRA_Break =
		Loop, Parse, TRA_FixedTransClasses, `,
		{
			StringSplit, TRA_LoopField, A_LoopField, =
			If (func_WildcardMatch( TRA_WinTitle, TRA_LoopField1, 0) OR func_WildcardMatch( TRA_WinClass, TRA_LoopField1, 0) )
			{
				TRA_Break = 1
				Break
			}
		}
		If TRA_Break = 1
		{
			IfNotInString, TRA_WinIDs, |%TRA_WinID%
				TRA_WinIDs = %TRA_WinIDs%|%TRA_WinID%
			TRA_WinAlpha := (TRA_LoopField2="") ? 0 : TRA_LoopField2 * 255 / 100

			If TRA_LastWinAlpha <> %TRA_WinAlpha%
			{
				WinSet, Transparent, %TRA_WinAlpha%, ahk_id %TRA_WinID%
				TRA_WinAlpha%TRA_WinID% = %TRA_WinAlpha%
			}
			Continue
		}

		IfWinActive, ahk_id %TRA_WinID%
		{
;         b = act!
			If TRA_FirstInActiveWin =
				TRA_FirstInActiveWin = 2
		}

		IfWinNotActive, ahk_id %TRA_WinID%
		{
			IfNotInString, TRA_WinIDs, |%TRA_WinID%
				TRA_WinIDs = %TRA_WinIDs%|%TRA_WinID%
			TRA_WinAlpha := TRA_WinAlpha%TRA_WinID%

			If (TRA_WinProc = TRA_ActWinProc AND TRA_FirstInActiveWin <> 1)
			{
;            b=act
				TRA_WinAlpha := TRA_AutoTransSameProc * 255 / 100
			}
			Else If TRA_OverWinID = %TRA_WinID%
			{
;            b=over
				If TRA_EnableAutoTransOver = 0
					continue
				TRA_WinAlpha := TRA_AutoTransOver * 255 / 100
				If TRA_FirstInActiveWin = 2
					TRA_FirstInActiveWin = 1
			}
			Else
			{
;            b=inact
				TRA_WinAlpha := TRA_AutoTransInactive * 255 / 100
				If TRA_FirstInActiveWin = 2
					TRA_FirstInActiveWin = 1
			}

			If (TRA_WinAlpha = 255 AND TRA_LastWinAlpha = "")
				continue

			If TRA_LastWinAlpha <> %TRA_WinAlpha%
			{
				If TRA_LastWinAlpha =
					TRW_WinAlpha = 255
				If TRA_LastWinAlpha = 255
				{
					WinSet, Transparent, 255, ahk_id %TRA_WinID%
					Sleep,1000
				}
				TRA_WinAlpha%TRA_WinID% = %TRA_WinAlpha%
				TRA_WinAlpha := (TRA_WinAlpha = 255) ? "Off" : TRA_WinAlpha
				WinSet, Transparent, %TRA_WinAlpha%, ahk_id %TRA_WinID%
			}
		}
		Else If (TRA_LastWinAlpha <> TRA_AutoTransActiveWindow * 255 / 100)
		{
			IfNotInString, TRA_WinIDs, |%TRA_WinID%
				TRA_WinIDs = %TRA_WinIDs%|%TRA_WinID%
			TRA_WinAlpha%TRA_WinID% := TRA_AutoTransActiveWindow * 255 / 100
			TRA_WinAlpha := (TRA_WinAlpha%TRA_WinID% = 255) ? "Off" : TRA_WinAlpha%TRA_WinID%
			WinSet, Transparent, %TRA_WinAlpha% , ahk_id %TRA_WinID%
		}
		Else
		{
			TRA_WinAlpha%TRA_WinID% =
		}
;      a = %a%%TRA_WinClass%`t%TRA_WinProc%  - %TRA_FirstInActiveWin% [%b%]`n
	}
	TRA_LastWinList = %TRA_WinList%
	TRA_LastActWinID = %TRA_ActWinID%
	TRA_LastOverWinID = %TRA_OverWinID%
	TRA_LastWinProc = %TRA_ActWinProc%
;   coordMode, ToolTip, screen
;   tooltip, %TRA_ActWinProc%`n%TRA_ActWinID%`n%a%,0,0
Return

TRA_PixelTransparency_AOT:
	if (TRA_enabled = 0)
		Return
	WinGetClass, TRA_WinClass, A
	If TRA_WinClass in %TRA_IgnoreClasses%
		Return
	Gosub, TRA_CheckWinIDs
	SetWinDelay, -1
	CoordMode, Mouse, Screen
	CoordMode, Pixel, Screen
	MouseGetPos, TRA_MouseX, TRA_MouseY, TRA_WinID
	If ( !TRA_WinID )
		Return

	IfWinNotActive, ahk_id %TRA_WinID%
		WinActivate, ahk_id %TRA_WinID%
	IfNotInString, TRA_WinIDs, |%TRA_WinID%
		TRA_WinIDs = %TRA_WinIDs%|%TRA_WinID%

	if (TRA_AOT = 1)
	{
		WinSet, AlwaysOnTop, On, A
		TRA_WinAlpha%TRA_WinID% := TRA_AOT_Transp * 255 / 100
	}

	TRA_WinAlpha := TRA_WinAlpha%TRA_WinID%

	; TODO : the transparency must be set off first,
	; this may be a bug of AutoHotkey
	WinSet, TransColor, OFF, ahk_id %TRA_WinID%
	PixelGetColor, TRA_PixelColor, %TRA_MouseX%, %TRA_MouseY%, RGB
	WinSet, TransColor, %TRA_PixelColor% %TRA_WinAlpha%, ahk_id %TRA_WinID%
	TRA_PixelColor%TRA_WinID% := TRA_PixelColor

	if (TRA_AOT = 1)
		TRA_ToolTipText = %lng_TRA_Transparency%: %TRA_AOT_Transp% `% + %TRA_PixelColor% %lng_TRA_Color% (RGB) + %lng_TRA_AOT%
	Else
		TRA_ToolTipText = %lng_TRA_Transparency%: %TRA_PixelColor% %lng_TRA_Color% (RGB)
	Gosub, TRA_ToolTipFeedbackShow
Return

TRA_reset_TransparentWin:
	if (TRA_enabled = 0)
		Return
	Gosub, TRA_CheckWinIDs
	SetWinDelay, -1
	MouseGetPos, , , TRA_WinID
	If ( !TRA_WinID )
		Return
	IfWinNotActive, ahk_id %TRA_WinID%
		WinActivate, ahk_id %TRA_WinID%
	IfNotInString, TRA_WinIDs, |%TRA_WinID%
		Return
	Gosub, TRA_TransparencyOff

	TRA_ToolTipText = %lng_TRA_Transparency%: %lng_Off%
	Gosub, TRA_ToolTipFeedbackShow
Return

TRA_TransparencyOff:
	Gosub, TRA_CheckWinIDs
	SetWinDelay, -1
	If ( !TRA_WinID )
		Return
	IfNotInString, TRA_WinIDs, |%TRA_WinID%
		Return
	StringReplace, TRA_WinIDs, TRA_WinIDs, |%TRA_WinID%, , All
	TRA_WinAlpha%TRA_WinID% =
	TRA_PixelColor%TRA_WinID% =
	; TODO : must be set to 255 first to avoid the black-colored-window problem
	WinSet, Transparent, 255, ahk_id %TRA_WinID%
	WinSet, TransColor, OFF, ahk_id %TRA_WinID%
	WinSet, Transparent, OFF, ahk_id %TRA_WinID%
	WinSet, Redraw, , ahk_id %TRA_WinID%
	; always reset AOT here, because we don't store information for which window we have set the flag
	WinSet, AlwaysOnTop, Off, ahk_id %TRA_WinID%
Return

TRA_TransparencyAllOff:
	Gosub, TRA_CheckWinIDs
	Loop, Parse, TRA_WinIDs, |
		If ( A_LoopField )
		{
			TRA_WinID = %A_LoopField%
			Gosub, TRA_TransparencyOff
		}
	TRA_WinIDs =
Return

TRA_CheckWinIDs:
	DetectHiddenWindows, On
	Loop, Parse, TRA_WinIDs, |
		If ( A_LoopField )
			IfWinNotExist, ahk_id %A_LoopField%
			{
				StringReplace, TRA_WinIDs, TRA_WinIDs, |%A_LoopField%, , All
				TRA_WinAlpha%A_LoopField% =
				TRA_PixelColor%A_LoopField% =
			}
Return

; -----------------------------------------------------------------------------

; handles tooltips
TRA_ToolTipShow:
	If ( TRA_ToolTipText )
	{
		If ( !TRA_ToolTipSeconds )
			TRA_ToolTipSeconds = 2
		TRA_ToolTipMillis := TRA_ToolTipSeconds * 1000
		CoordMode, Mouse, Screen
		CoordMode, ToolTip, Screen
		If ( !TRA_ToolTipX or !TRA_ToolTipY )
		{
			MouseGetPos, TRA_ToolTipX, TRA_ToolTipY
			TRA_ToolTipX += 16
			TRA_ToolTipY += 24
		}
		ToolTip, %TRA_ToolTipText%, %TRA_ToolTipX%, %TRA_ToolTipY%
		SetTimer, TRA_ToolTipHandler, %TRA_ToolTipMillis%
	}
	TRA_ToolTipText =
	TRA_ToolTipSeconds =
	TRA_ToolTipX =
	TRA_ToolTipY =
Return

TRA_ToolTipFeedbackShow:
	If ( TRA_showTip )
		Gosub, TRA_ToolTipShow
	TRA_ToolTipText =
	TRA_ToolTipSeconds =
	TRA_ToolTipX =
	TRA_ToolTipY =
Return

TRA_ToolTipHandler:
	SetTimer, TRA_ToolTipHandler, Off
	ToolTip
Return
