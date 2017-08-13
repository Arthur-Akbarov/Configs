; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               PopUpKiller
; -----------------------------------------------------------------------------
; Prefix:             puk_
; Version:            0.2
; Date:               2010-11-18
; Author:             Jack Tissen
; Copyright:          2010 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_PopUpKiller:
	Prefix = puk
	%Prefix%_ScriptName    = PopUpKiller
	%Prefix%_ScriptVersion = 0.2
	%Prefix%_Author        = Jack Tissen

	CustomHotkey_PopUpKiller = 0
	IconFile_On_PopUpKiller  = %A_WinDir%\system32\shell32.dll
	IconPos_On_PopUpKiller   = 110

	gosub, LanguageCreation_PopUpKiller
	gosub, LoadSettings_PopUpKiller

	RegisterAdditionalSetting("puk", "enableTrayTip", 0)
	RegisterAdditionalSetting( "puk", "gui_Sounds", 0, "Type:SubRoutine")
	puk_guiDrawn := 0
	CreateGuiID("PopUpKiller")
	CreateGuiID("PopUpKiller_SoundConfig")
Return

LanguageCreation_PopUpKiller:
	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %puk_ScriptName% - PopUp Killer
		Description                   = Erkennt Fenster anhand ihres Namens und schließt/minimiert/maximiert/etc. diese automatisch

		lng_puk_action                = Aktion
		lng_puk_Edit                  = Bearbeiten
		lng_puk_Add                   = Hinzufügen
		lng_puk_WinTitle              = Fenstername
		lng_puk_enabled               = Aktiviert
		lng_puk_actionList            = Schließen|Minimieren|Maximieren|Vordergrund
		lng_puk_EntrysStarted         = Fenster erkannt
		lng_puk_enableTrayTip         = Hinweis anzeigen, wenn Aktionen durchgeführt werden
		lng_puk_once                  = Einmalig
		lng_puk_gui_Sounds            = %puk_ScriptName%: Klang ändern...
		lng_puk_waveFile              = Ton
		lng_puk_selectSound           = %puk_ScriptName%: Klang auswählen
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %puk_ScriptName% - PopUp Killer
		Description                   = Recognizes windows by name and close/minimize/maximize/etc. them automaticly

		lng_puk_action                = Action
		lng_puk_Edit                  = Edit
		lng_puk_Add                   = Add
		lng_puk_WinTitle              = Window title
		lng_puk_enabled               = Enabled
		lng_puk_actionList            = Close|Minimize|Maximize|Foreground
		lng_puk_EntrysStarted         = Window recognized
		lng_puk_enableTrayTip         = Show traytip when action is being performed
		lng_puk_once                  = Once
		lng_puk_gui_Sounds            = %puk_ScriptName%: Change alarm tone...
		lng_puk_waveFile              = Tone
		lng_puk_selectSound           = %puk_ScriptName%: Select sound
	}
	
	Loop, parse, lng_puk_actionList, |
	{
		lng_puk_actionArray%A_Index% := A_LoopField
		lng_puk_actionArray%A_LoopField% := A_Index
	}	
Return


LoadSettings_PopUpKiller:
	IniRead, puk_NumEntries, %ConfigFile%, %puk_ScriptName%, NumEntries, 0
	IniRead, puk_WaveFile, %ConfigFile%, %puk_ScriptName%, AlarmSound, %A_ScriptDir%\Library\notify.wav

	Loop %puk_NumEntries%
	{
		IniRead,puk_enabled%A_Index%,%ConfigFile%,%puk_ScriptName%,pukEnabled%A_Index%
		IniRead,puk_WinTitle%A_Index%,%ConfigFile%,%puk_ScriptName%,pukWinTitle%A_Index%
		IniRead,puk_tmp_action,%ConfigFile%,%puk_ScriptName%,pukAction%A_Index%
		IniRead,puk_once%A_Index%,%ConfigFile%,%puk_ScriptName%,pukOnce%A_Index%
		puk_action%A_Index% := lng_puk_actionArray%puk_tmp_action%
	}
Return

SaveSettings_PopUpKiller:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, puk_ListView

	IniWrite, %puk_NumEntries%, %ConfigFile%, %puk_ScriptName%, NumEntries
	IniWrite, %puk_WaveFile%, %ConfigFile%, %puk_ScriptName%, AlarmSound

	Loop, %puk_NumEntries%
	{
		LV_GetText(puk_tmp_WinTitle, A_Index, 1)
		LV_GetText(puk_tmp_enabled, A_Index, 3)
		LV_GetText(puk_tmp_action, A_Index, 4)
		LV_GetText(puk_tmp_once, A_Index, 5)

		puk_WinTitle%A_Index% := puk_tmp_WinTitle
		puk_enabled%A_Index% := puk_tmp_enabled
		puk_action%A_Index% := puk_tmp_action
		puk_once%A_Index% := puk_tmp_once

		IniWrite, %puk_tmp_WinTitle%, %ConfigFile%, %puk_ScriptName%, pukWinTitle%A_Index%
		IniWrite, %puk_tmp_enabled%, %ConfigFile%, %puk_ScriptName%, pukEnabled%A_Index%
		IniWrite, % lng_puk_actionArray%puk_tmp_action%, %ConfigFile%, %puk_ScriptName%, pukAction%A_Index%
		IniWrite, %puk_tmp_once%,%ConfigFile%,%puk_ScriptName%,pukOnce%A_Index%

		LV_Modify( A_Index,"Col2", A_Index)
	}

	puk_restart()
Return

SettingsGui_PopUpKiller:
	puk_guiDrawn := 1

	Gui, Add, ListView, xs+10 y+5 Hwndpuk_LVHwnd Count%puk_NumActions% Checked AltSubmit -Multi -LV0x10 Grid h260 w550 vpuk_ListView gpuk_sub_ListView, %lng_puk_WinTitle%|#|enabled|%lng_puk_action%|%lng_puk_once%
	Gui, Add, Button, -Wrap xs+205 ys+290 w25 h16 gpuk_sub_AddEntry, +
	Gui, Add, Button, -Wrap x+5 h16 w25 gpuk_sub_DelEntry, %MinusString%
	Gui, Add, Button, -Wrap x+5 h16 w135 gpuk_sub_EditEntry, %lng_puk_Edit%

	LV_ModifyCol(1,300)
	LV_ModifyCol(2,0)
	LV_ModifyCol(3,0)
	LV_ModifyCol(4,150)
	LV_ModifyCol(5,70)

	GuiControl, -Redraw, puk_ListView

	Loop, %puk_NumEntries%
	{
		puk_tmp_WinTitle := puk_WinTitle%A_Index%
		puk_tmp_enabled := puk_enabled%A_Index%
		puk_tmp_action := puk_action%A_Index%
		puk_tmp_once := puk_once%A_Index%

		if puk_tmp_enabled = 1
			puk_tmp_options = Check
		else
			puk_tmp_options =

		LV_Add("Select " puk_tmp_options, puk_tmp_WinTitle,A_Index,puk_tmp_enabled,puk_tmp_action,puk_tmp_once)
	}
	GuiControl, +Redraw, puk_ListView

	puk_EditTitle = %lng_puk_Edit%
Return

AddSettings_PopUpKiller:
Return

CancelSettings_PopUpKiller:
Return

DoEnable_PopUpKiller:
	puk_restart()
Return

DoDisable_PopUpKiller:
	SetTimer, puk_Timer, Off
Return

DefaultSettings_PopUpKiller:
Return

OnExitAndReload_PopUpKiller:
Return

; -----------------------------------------------------------------------------
; === Edit+Add Entry ============================================================
; -----------------------------------------------------------------------------
puk_sub_ListView:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, puk_ListView
	StringCaseSense, On
	If A_GuiEvent = s
		GuiControl, +Redraw, puk_ListView

	If A_GuiEvent = I
	{
		LV_GetText(puk_tmp_num, A_EventInfo, 2)

		If InStr(ErrorLevel, "C", true)
		{
			if puk_tmp_num !=
			{
				LV_Modify( A_EventInfo,"Col3", 1)
				puk_enabled%puk_tmp_num% := 1
				func_settingsChanged("PopUpKiller")
			}
		}

		If InStr(ErrorLevel, "c", true)
		{
			if puk_tmp_num !=
			{
				LV_Modify( A_EventInfo,"Col3", 0)
				puk_enabled%puk_tmp_num% := 0
				func_settingsChanged("PopUpKiller")
			}
		}
	}

	If A_GuiEvent in I,E,F,f,M,S,s
		Return

	puk_lastRow := puk_LVrow
	puk_LVrow := LV_GetNext()

	If A_GuiEvent in Normal,D,d
	{
		GuiControlGet, puk_temp, FocusV
		if puk_temp <> puk_ListView
			GuiControl, Focus, puk_ListView
		Return
	}

	StringCaseSense, Off

	LV_GetText(puk_RowText, puk_LVrow, 1)

	puk_EventInfo =
	If A_GuiEvent = K
		puk_EventInfo = %A_EventInfo%

	If ( A_GuiEvent = "A" OR A_GuiEvent = "DoubleClick" OR uh_EventInfo = 32 )
		Goto, puk_sub_EditEntry

	If puk_EventInfo = 46
		Goto, puk_sub_DelEntry
	If puk_EventInfo = 45
		Goto, puk_sub_AddEntry
return

puk_sub_DelEntry:
	Critical

	If puk_NumEntries = 0
		Return

	Gui, %GuiID_activAid%:Default
	Gui, ListView, puk_ListView

	puk_LVrow := LV_GetNext()
	LV_GetText(puk_Num, puk_LVrow, 2)

	LV_Delete( puk_LVrow )
	LV_Modify( puk_LVrow, "Select")

	puk_delRows := puk_NumEntries - puk_Num

	GuiControl, -Redraw, puk_ListView
	Loop, %puk_delRows%
	{
		puk_nextRow := puk_Num + A_Index
		puk_thisRow := puk_nextRow - 1

		puk_WinTitle%puk_thisRow% := puk_WinTitle%puk_nextRow%
		puk_enabled%puk_thisRow% := puk_enabled%puk_nextRow%
		puk_action%puk_thisRow% := puk_action%puk_nextRow%
		puk_once%puk_thisRow% := puk_once%puk_nextRow%

		LV_Modify( puk_LVrow+A_Index-1,"Col2", puk_thisRow)
	}
	GuiControl, +Redraw, puk_ListView
	puk_NumEntries--

	func_SettingsChanged( "PopUpKiller" )
return

puk_sub_EditEntry:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, puk_ListView

	if (puk_LVrow = 0 OR puk_LVrow = "")
		Goto, puk_sub_AddEntry

	If puk_GUI = 3
		Return

	puk_GUI = 3

	LV_GetText(puk_ed_WinTitle, puk_LVrow, 1)
	LV_GetText(puk_ed_Num, puk_LVrow, 2)
	LV_GetText(puk_ed_enabled, puk_LVrow, 3)
	LV_GetText(puk_ed_action, puk_LVrow, 4)
	LV_GetText(puk_ed_once, puk_LVrow, 5)

	if puk_ed_once =
		puk_ed_once = 0
		
	if puk_ed_action =
		puk_ed_action := lng_puk_actionArray1

	Gui, %GuiID_activAid%:+Disabled
	GuiDefault("PopUpKiller", "-MaximizeBox +Owner" GuiID_activAid)^

	Gosub, GuiDefaultFont

	Gui, Add, Button, -Wrap y22 x430 w80 Default gpuk_sub_OK, &OK
	Gui, Add, Button, -Wrap y+5 w80 gPopUpKillerGuiClose, %lng_Cancel%

	Gui, Add, Groupbox, w520 h75 x5 y7
	Gui, Add, Checkbox, xp+10 yp-1 w60 checked%puk_ed_enabled% vpuk_ed_enabled, %lng_puk_enabled%
	Gui, Add, Checkbox, x+10 w60 Check3 checked%puk_ed_once% vpuk_ed_once gpuk_sub_onceCheckIfSettingsChanged, %lng_puk_once%

	Gui, Add, Text, x15 y27 w135, %lng_puk_WinTitle% (RegEx):
	Gui, Add, ComboBox, x+5 R15 yp-3 W255 vpuk_ed_WinTitle, % puk_ed_WinTitle

	;add Items to the WinTitle ComboBox
	WinGet, id, list,,, Program Manager
	Loop, %id%
	{
		this_id := id%A_Index%
		WinGetTitle, this_title, ahk_id %this_id%
		GuiControl, , puk_ed_WinTitle, % this_title . " (" . this_id . ")"
	}
	If (puk_ed_WinTitle != "")
		GuiControl, Choose, puk_ed_WinTitle, 1
	
	Gui, Add, Text, x15 y+7 w135, %lng_puk_action%:
	Gui, Add, DropDownList, x+5 R10 yp-3 W155 vpuk_ed_action, % lng_puk_actionList
	GuiControl, Choose, puk_ed_action, % lng_puk_actionArray%puk_ed_action%
	
	Gui, Show, w530 h95, %puk_EditTitle%
return

puk_sub_onceCheckIfSettingsChanged:
	GuiControlGet, puk_ed_once_tmp,, puk_ed_once
	If puk_ed_once_tmp = -1
		GuiControl,, puk_ed_once,0
return

puk_sub_OK:
	Gui, %GuiID_activAid%:-Disabled
	Gui, Submit
	Gui, Destroy
	Gui, %GuiID_activAid%:Default
	Gui, ListView, puk_ListView

	puk_GUI =
	LV_Modify( puk_LVrow,"Check" puk_ed_enabled, puk_ed_WinTitle,puk_ed_Num,puk_ed_enabled,puk_ed_action,puk_ed_once)

	puk_EditTitle = %lng_puk_Edit%
	func_SettingsChanged( "PopUpKiller" )

	LV_Modify( puk_LVrow, "Vis" )
return

puk_sub_AddEntry:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, puk_ListView

	puk_NumEntries++

	LV_Add("Select Check0", "",puk_NumEntries,0,"",0)
	puk_LVrow := LV_GetNext()
	puk_EditTitle = %lng_puk_Add%

	Gosub, puk_sub_EditEntry
return

PopUpKillerGuiEscape:
PopUpKillerGuiClose:
	Gui, %GuiID_activAid%:-Disabled
	Gui, Submit
	Gui, Destroy
	Gui, %GuiID_activAid%:Default
	Gui, ListView, puk_ListView

	puk_GUI =

	If puk_EditTitle = %lng_puk_Add%
	{
		LV_Delete( puk_LVrow )
		puk_NumEntries--
	}
	puk_EditTitle = %lng_puk_Edit%

	puk_SettingsChanged =
return

puk_search_sound:
	GuiDefault("PopUpKiller_SoundConfig", "-MaximizeBox +Owner" GuiID_activAid)
	GuiControlGet,puk_oldLocation,,puk_WaveFile

	FileSelectFile, puk_newFile, 3,*%puk_oldLocation%,%lng_puk_selectSound%, Wave Audio (*.wav)

	if puk_newFile =
		puk_newFile = %puk_oldLocation%

	GuiControl,,puk_WaveFile,%puk_newFile%
return

puk_gui_Sounds:
	Gui, %GuiID_activAid%:+Disabled
	GuiDefault("PopUpKiller_SoundConfig", "-MaximizeBox +Owner" GuiID_activAid)
	Gosub, GuiDefaultFont

	Gui, Add, Text, x10 y+7 w90, %lng_puk_waveFile%:
	Gui, Add, Edit, x+5 R1 yp-3 W350  vpuk_WaveFile, % puk_WaveFile
	Gui, Add, Button, x+5 w30 vpuk_WaveFile_search gpuk_search_sound, ...

	Gui, Add, Button, -Wrap y+10 x85 w100 Default gpuk_snd_OK, &OK
	Gui, Add, Button, -Wrap x+10 w100 gPopUpKiller_SoundConfigGuiClose, %lng_Cancel%

	Gui, Show, w600 AutoSize, %lng_puk_gui_Sounds%
return

PopUpKiller_SoundConfigGuiEscape:
PopUpKiller_SoundConfigGuiClose:
	If GetKey = Escape
	{
		GetKey =
		Return
	}
	Gui, %GuiID_activAid%:-Disabled
	Gui, Submit
	Gui, Destroy
	Gui, %GuiID_activAid%:Default

	puk_SettingsChanged =
return

puk_snd_OK:
	Gui, %GuiID_activAid%:-Disabled
	Gui, Submit
	Gui, Destroy
	Gui, %GuiID_activAid%:Default

	func_SettingsChanged( "PopUpKiller" )
return

; -----------------------------------------------------------------------------
; === puk-Routines =============================================================
; -----------------------------------------------------------------------------
puk_Timer:
	SetTimer ,puk_Timer, Off
	puk_tooltip =
	SetTitleMatchMode RegEx
	
	Loop %puk_NumEntries%
	{
		if ((puk_enabled%A_Index% = 1 && puk_once%A_Index% <> -1) || (MainGuiVisible <> "" && ExtensionGuiDrawn[PopUpKiller] <> ""))
			IfWinExist % puk_WinTitle%A_Index%
			{
				currActTtl := puk_action%A_Index%
				currActNum := lng_puk_actionArray%currActTtl%
				WinGetTitle, currWinTitle
				
				if currActNum = 1		;Close
				{
					WinClose
					
					puk_tooltip := currWinTitle ", " lng_puk_action ": " currActTtl
				
					if cron_WaveFile <>
						SoundPlay, %puk_WaveFile%
				}
				else if currActNum = 2	;Minimize
				{
					WinMinimize
				}
				else if currActNum = 3	;Maximize
				{
					WinMaximize
				}
				else if currActNum = 4	;Foreground
				{
					WinSet, AlwaysOnTop, On
				}
				
				if puk_once%A_Index% = 1
				{
					puk_once%A_Index% = -1

					Gui, %GuiID_activAid%:Default
					Gui, ListView, puk_ListView
					LV_Modify(A_Index,"Col5",-1)

					IniWrite,-1,%ConfigFile%,%puk_ScriptName%,pukOnce%A_Index%
					puk_tooltip := puk_tooltip "(" lng_puk_once ")"
				}
			}
	}
	if puk_enableTrayTip = 1
		If puk_tooltip !=
			BalloonTip(puk_ScriptName,lng_puk_EntrysStarted "`n" puk_tooltip, "Info", 0, -1, 3)

	puk_restart()
Return

puk_restart()
{
	global
	if Enable_PopUpKiller = 1
		SetTimer, puk_Timer, 1000
}

