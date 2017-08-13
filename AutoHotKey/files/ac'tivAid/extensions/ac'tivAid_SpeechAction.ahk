; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               SpeechAction
; -----------------------------------------------------------------------------
; Prefix:             spa_
; Version:            0.1
; Date:               2008-05-03
; Author:             David Hilberath
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Requirements ============================================================
; -----------------------------------------------------------------------------
; You need the MS Speech API 5.1 (or above, I guess), available at
; http://www.microsoft.com/downloads/details.aspx?FamilyID=5e86ec97-40a7-453f-b0ee-6583171b4530&displaylang=en
;
; Information on the Speech API is available here
; http://msdn.microsoft.com/en-us/library/ms723627.aspx
;
; This registry key should exist if the right API is installed:
; HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech\Recognizers\Tokens\SAPI5SampleEngine
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------
#include %A_ScriptDir%/Library/COM.ahk
init_SpeechAction:
	Prefix = spa
	%Prefix%_ScriptName    = SpeechAction
	%Prefix%_ScriptVersion = 0.1
	%Prefix%_Author        = David Hilberath

	CustomHotkey_SpeechAction = 0
	IconFile_On_SpeechAction  = %A_WinDir%\system32\shell32.dll
	IconPos_On_SpeechAction   = 160

	Gosub, LoadSettings_SpeechAction
	Gosub, LanguageCreation_SpeechAction

	RegRead, spa_SAPIAvailable, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Speech\Recognizers\Tokens\SAPI5SampleEngine
	if spa_SAPIAvailable = SAPI Developer Sample Engine
		spa_SAPIAvailable = 1
	else
		spa_SAPIAvailable = 0

	if spa_SAPIAvailable = 1
	{
		CreateGuiID("SpeechAction")
		RegisterAdditionalSetting("spa","UseBalloonTips",0)
		RegisterAdditionalSetting("spa","AudioNotify",1)
		
		;Sounds Konfiguration
		CreateGuiID("SpeechActionSounds")
		RegisterAdditionalSetting( "spa", "gui_Sounds", 0, "Type:SubRoutine")
	}
Return

spa_gui_Sounds:
	Gui, %GuiID_activAid%:+Disabled
	GuiDefault("SpeechActionSounds", "-MaximizeBox +Owner" GuiID_activAid)
	Gosub, GuiDefaultFont

	Gui, Add, Text, x10 y+7 w110, %lng_spa_snd_waveFile%:
	Gui, Add, Edit, x+5 R1 yp-3 W330  vspa_WaveFile, % spa_WaveFile
	Gui, Add, Button, x+5 w30 vspa_WaveFile_search gsub_search_sound, ...

	Gui, Add, Text, x10 y+7 w110, %lng_spa_snd_cmd%:
	Gui, Add, Edit, x+5 R1 yp-3 W330 vspa_snd_cmd, % spa_snd_cmd
	Gui, Add, Button, x+5 w30 vspa_snd_cmd_search gsub_search_sound, ...

	Gui, Add, Text, x10 y+7 w110, %lng_spa_snd_end%:
	Gui, Add, Edit, x+5 R1 yp-3 W330 vspa_snd_end, % spa_snd_end
	Gui, Add, Button, x+5 w30 vspa_snd_end_search gsub_search_sound, ...

	Gui, Add, Button, -Wrap y+10 x145 w100 Default gspa_snd_OK, &OK
	Gui, Add, Button, -Wrap x+10 w100 gSpeechActionSoundsGuiClose, %lng_Cancel%

	Gui, Show, w600 AutoSize, %lng_spa_snd_configTitle%
return

sub_search_sound:
	StringRight, spa_tmp_control, A_GuiControl, 7
	
	if spa_tmp_control = _search
	{
		StringTrimRight, spa_tmp_control, A_GuiControl, 7
		GuiControlGet,spa_oldLocation,,%spa_tmp_control%
		FileSelectFile, spa_newFile, 3,*%spa_oldLocation%,%lng_spa_selectSound%, Wave Audio (*.wav)
		
		if spa_newFile =
			spa_newFile = %spa_oldLocation%
		
		GuiControl,,%spa_tmp_control%,%spa_newFile%
	}
return

spa_snd_OK:
	Gui, %GuiID_activAid%:-Disabled
	Gui, Submit
	Gui, Destroy
	Gui, %GuiID_activAid%:Default

	func_SettingsChanged( "SpeechAction" )
return

SpeechActionSoundsGuiClose:
SpeechActionSoundsGuiEscape:
	If GetKey = Escape
	{
		GetKey =
		Return
	}
	Gui, %GuiID_activAid%:-Disabled
	Gui, Submit
	Gui, Destroy
	Gui, %GuiID_activAid%:Default

	spa_SettingsChanged =
Return


LanguageCreation_SpeechAction:
	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %spa_ScriptName% - den PC mit der Stimme steuern
		Description                   = Ermöglicht, den PC mit der Stimme zu steuern.`nBenötigt MS Speech SDK.

		lng_spa_KeyWord               = Schlüsselwort
		lng_spa_KeyLock               = Push to talk

		lng_spa_cmd                   = Sprachbefehl
		lng_spa_action                = Aktion
		lng_spa_Edit                  = Bearbeiten
		lng_spa_Add                   = Sprachbefehl hinzufügen
		lng_spa_action_para           = Parameter
		lng_spa_UseBalloonTips        = Traybenachrichtigung anzeigen
		lng_spa_AudioNotify           = Tonsignal nach Schlüsselwort
		lng_spa_recMess               = Erkannter Befehl
		lng_spa_SAPIRequired          = MS Speech API 5.1 wird für diese Erweiterung benötigt. Kostenloser Download (SpeechSDK51.exe):
		lng_spa_plzRestart            = Nach der Installation muss ac'tivAid neu gestartet werden.
		lng_spa_useDictation          = Danach gesprochenes als Parameter senden
		lng_spa_snd_configTitle       = %spa_ScriptName%: Individuelle Klänge
		lng_spa_snd_waveFile          = Schlüsselwort
		lng_spa_snd_cmd               = Befehl
		lng_spa_snd_end               = Ende der Erkennung
		lng_spa_gui_Sounds            = Individuelle Klänge konfigurieren
		lng_spa_selectSound           = %spa_ScriptName%: Klang auswählen
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %spa_ScriptName% - control your PC via Voice
		Description                   = Allows to control your pc via voice.`nRequires MS Speech SDK.
		lng_spa_KeyWord               = Keyword
		lng_spa_KeyLock               = Push to talk
		lng_spa_cmd                   = Speech command
		lng_spa_action                = Action
		lng_spa_Edit                  = Edit speech command
		lng_spa_Add                   = Add speech command
		lng_spa_action_para           = Parameter
		lng_spa_UseBalloonTips        = Show balloon tips in tray
		lng_spa_AudioNotify           = Give audio feedback on keyword
		lng_spa_recMess               = Recognized command
		lng_spa_SAPIRequired          = MS Speech API 5.1 is required to use this extension. Free Download (SpeechSDK51.exe):
		lng_spa_plzRestart            = Please restart ac'tivAid after the installation has finished.
		lng_spa_useDictation          = Send remaining phrase as parameter
		lng_spa_snd_configTitle       = %spa_ScriptName%: individual sounds
		lng_spa_snd_waveFile          = Keyword
		lng_spa_snd_cmd             = Command
		lng_spa_snd_end               = End of recognition
		lng_spa_gui_Sounds            = Configure individual sounds
		lng_spa_selectSound           = %spa_ScriptName%: Select sound
	}
Return

SettingsGui_SpeechAction:
	; func_HotkeyAddGuiControl( lng_spa_TEXT, "spa_HOTKEYNAME", "xs+10 y+10 w160" )
	; Gui, Add, Edit, xs+10 y+5 gsub_CheckIfSettingsChanged vspa_var, %lng_spa_text%

	if spa_SAPIAvailable = 1
	{
		Gui, Add, CheckBox,  xs+10 y+7 w23 vspa_requireKeyWord gspa_sub_CheckIfSettingsChanged Checked%spa_requireKeyWord%,
		Gui, Add, Text, x+0 w90, %lng_spa_KeyWord%:
		Gui, Add, Edit, R1 -Wrap w300 gsub_CheckIfSettingsChanged x+5 yp-3 vspa_KeyWord, %spa_KeyWord%

		Gui, Add, CheckBox,  xs+10 y+7 w23 vspa_requireKeyLock gspa_sub_CheckIfSettingsChanged Checked%spa_requireKeyLock%,
		func_HotkeyAddGuiControl( lng_spa_KeyLock, "spa_KeyLock", "x+0 w90" )
		GuiControl, Enable%spa_requireKeyLock%, Hotkey_spa_KeyLock

		Gui, Add, ListView, Hwndspa_LVHwnd Count%spa_NumActions% AltSubmit -Multi -LV0x10 Grid xs+10 y+5 h210 w550 vspa_ListView gspa_sub_ListView, %lng_spa_cmd%|%lng_spa_action%|action|num|%lng_spa_action_para%|dictateAfter
		Gui, Add, Button, -Wrap xs+205 ys+290 w25 h16 gspa_sub_AddCmd, +
		Gui, Add, Button, -Wrap x+5 h16 w25 gspa_sub_DelCmd, %MinusString%
		Gui, Add, Button, -Wrap x+5 h16 w135 gspa_sub_EditCmd, %lng_spa_Edit%

		LV_ModifyCol(1,200)
		LV_ModifyCol(2,180)
		LV_ModifyCol(3,0)
		LV_ModifyCol(4,0)
		LV_ModifyCol(5,150)
		LV_ModifyCol(6,0)

		GuiControl, -Redraw, spa_ListView

		Loop, %spa_NumActions%
		{
			spa_tmp_Action := spa_Action%A_Index%
			spa_tmp_desc := ActionDesc%spa_tmp_Action%
			LV_Add("", spa_Command%A_Index%, spa_tmp_desc, spa_Action%A_Index%, A_Index, spa_Para%A_Index%, spa_DictateAfter%A_Index%)
		}
		GuiControl, +Redraw, spa_ListView

		spa_EditTitle = %lng_spa_Edit%
	}
	else
	{
		Gui, Add, Text, xs+10 y+7, %lng_spa_SAPIRequired%
		Gui, Add, Text, y+7 gspa_downloadSAPI, %spa_downloadLink%
		Gui, Add, Text, y+27 gspa_downloadSAPI, %lng_spa_plzRestart%
	}
Return

spa_sub_CheckIfSettingsChanged:
	Gosub, sub_CheckIfSettingsChanged
	GuiControlGet, spa_requireKeyWord_tmp,, spa_requireKeyWord
	GuiControl, Enable%spa_requireKeyWord_tmp%, spa_KeyWord

	GuiControlGet, spa_requireKeyLock_tmp,, spa_requireKeyLock
	GuiControl, Enable%spa_requireKeyLock_tmp%, Hotkey_spa_KeyLock
Return


LoadSettings_SpeechAction:
	; func_HotkeyRead( "NDE!_HOTKEYNAME", ConfigFile , NDE!_ScriptName, "INI-Variable", "NDE!_sub_UNTERROUTINE", "DEFAULTWERT" )
	func_HotkeyRead("spa_KeyLock", ConfigFile, spa_ScriptName, "KeyLockHotkey", "spa_KeyLock", "")

	; IniRead, spa_VARIABLE, %ConfigFile%, %spa_ScriptName%, INI-Variable, DEFAULTWERT
	IniRead, spa_KeyWord, %ConfigFile%, %spa_ScriptName%, KeyWord, Computer
	IniRead, spa_NumActions, %ConfigFile%, %spa_ScriptName%, NumActions, 0
	IniRead, spa_CommandDelay, %ConfigFile%, %spa_ScriptName%, CommandDelay, 3000
	IniRead, spa_TimeForFollowUp, %ConfigFile%, %spa_ScriptName%, FollowUpTime, 3000
	IniRead, spa_requireKeyWord, %ConfigFile%, %spa_ScriptName%, RequireKeyWord, 1
	IniRead, spa_requireKeyLock, %ConfigFile%, %spa_ScriptName%, RequireKeyLock, 0
	IniRead, spa_WaveFile, %ConfigFile%, %spa_ScriptName%, SoundFile, %A_ScriptDir%\Library\notify.wav
	IniRead, spa_snd_cmd, %ConfigFile%, %spa_ScriptName%, SoundCommand, %spa_WaveFile%
	IniRead, spa_snd_end, %ConfigFile%, %spa_ScriptName%, SoundEnd, %spa_WaveFile%

	spa_KeyPushed = 0
	spa_KeyWordSaid = 0
	spa_downloadLink = http://www.microsoft.com/downloads/details.aspx?FamilyID=5e86ec97-40a7-453f-b0ee-6583171b4530
	Loop, %spa_NumActions%
	{
		IniRead, spa_Command%A_Index%, %ConfigFile%, %spa_ScriptName%, Command%A_Index%
		IniRead, spa_Action%A_Index%, %ConfigFile%, %spa_ScriptName%, Action%A_Index%
		IniRead, spa_Para%A_Index%, %ConfigFile%, %spa_ScriptName%, Para%A_Index%,%A_Space%
		IniRead, spa_DictateAfter%A_Index%, %ConfigFile%, %spa_ScriptName%, DictateAfter%A_Index%,0
	}
Return

SaveSettings_SpeechAction:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, spa_ListView

	func_HotkeyWrite( "spa_KeyLock", ConfigFile , spa_ScriptName, "KeyLockHotkey" )

	IniWrite, %spa_KeyWord%, %ConfigFile%, %spa_ScriptName%, KeyWord
	IniWrite, %spa_NumActions%, %ConfigFile%, %spa_ScriptName%, NumActions
	IniWrite, %spa_CommandDelay%, %ConfigFile%, %spa_ScriptName%, CommandDelay
	IniWrite, %spa_TimeForFollowUp%, %ConfigFile%, %spa_ScriptName%, FollowUpTime
	IniWrite, %spa_requireKeyWord%, %ConfigFile%, %spa_ScriptName%, RequireKeyWord
	IniWrite, %spa_requireKeyLock%, %ConfigFile%, %spa_ScriptName%, RequireKeyLock

	IniWrite, %spa_WaveFile%, %ConfigFile%, %spa_ScriptName%, SoundFile
	IniWrite, %spa_snd_cmd%, %ConfigFile%, %spa_ScriptName%, SoundCommand
	IniWrite, %spa_snd_end%, %ConfigFile%, %spa_ScriptName%, SoundEnd

	Loop, %spa_NumActions%
	{
		LV_GetText(spa_tmp_Command, A_Index, 1)
		LV_GetText(spa_tmp_Action, A_Index, 3)
		LV_GetText(spa_tmp_Para, A_Index, 5)
		LV_GetText(spa_tmp_Dict, A_Index, 6)
		spa_Command%A_Index% := spa_tmp_Command
		spa_Action%A_Index% := spa_tmp_Action
		spa_Para%A_Index% := spa_tmp_Para
		spa_Dict%A_Index% := spa_tmp_Dict

		IniWrite, %spa_tmp_Command%, %ConfigFile%, %spa_ScriptName%, Command%A_Index%
		IniWrite, %spa_tmp_Action%, %ConfigFile%, %spa_ScriptName%, Action%A_Index%
		IniWrite, %spa_tmp_Para%, %ConfigFile%, %spa_ScriptName%, Para%A_Index%
		if spa_Dict%A_Index% = 1
			IniWrite, 1, %ConfigFile%, %spa_ScriptName%, DictateAfter%A_Index%

		LV_Modify( A_Index,"Col4", A_Index)
	}

	gosub, spa_initDict
Return

AddSettings_SpeechAction:
Return

CancelSettings_SpeechAction:
Return

DoEnable_SpeechAction:
	If spa_SAPIAvailable = 1
		gosub, spa_initSAPI
Return

DoDisable_SpeechAction:
	If spa_SAPIAvailable = 1
	{
		if spa_requireKeyLock = 1
			func_HotkeyDisable("spa_KeyLock")
	}

	; instabil, stürzt ab
/*
	COM_Release(spa_pevent)
	COM_Release(spa_pstate)
	COM_Release(spa_prulec)
	COM_Release(spa_prules)
	COM_Release(spa_pgrammar)
	COM_Release(spa_pcontext)
	COM_Release(spa_plistener)
	COM_Term()
	*/
	;deswegen alternativ ein leeres Vokabular:

	gosub, spa_initEmptyDict
Return

DefaultSettings_SpeechAction:
Return

OnExitAndReload_SpeechAction:
/*
	COM_Release(spa_pevent)
	COM_Release(spa_pstate)
	COM_Release(spa_prulec)
	COM_Release(spa_prules)
	COM_Release(spa_pgrammar)
	COM_Release(spa_pcontext)
	COM_Release(spa_plistener)
	COM_Term()
*/
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

spa_KeyLock:
	spa_KeyPushed = 1
	SetTimer, spa_tim_keyPushed, %spa_CommandDelay%
Return

; -----------------------------------------------------------------------------
; === Command Config GUI ======================================================
; -----------------------------------------------------------------------------

spa_sub_EditCmd:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, spa_ListView

	if (spa_LVrow = 0 OR spa_LVrow = "")
		Goto, spa_sub_AddCmd

	If spa_GUI = 3
		Return

	spa_GUI = 3

	LV_GetText(spa_ed_Cmd, spa_LVrow, 1)
	LV_GetText(spa_ed_ActDesc, spa_LVrow, 2)
	LV_GetText(spa_ed_Act, spa_LVrow, 3)
	LV_GetText(spa_ed_Num, spa_LVrow, 4)
	LV_GetText(spa_ed_Para, spa_LVrow, 5)
	LV_GetText(spa_ed_Dict, spa_LVrow, 6)

	spa_actionList := ActionsDesc

	if spa_ed_ActDesc !=
		StringReplace, spa_actionList, spa_actionList, %spa_ed_ActDesc%, %spa_ed_ActDesc%|


	Gui, %GuiID_activAid%:+Disabled
	GuiDefault("SpeechAction", "-MaximizeBox +Owner" GuiID_activAid)
	Gosub, GuiDefaultFont

	Gui, Add, Text, x10 y+7 w90, %lng_spa_cmd%:
	Gui, Add, Edit, x+5 R1 yp-3 W200  vspa_ed_Cmd, % spa_ed_Cmd

	Gui, Add, Text, x10 y+7 w90, %lng_spa_action%:
	Gui, Add, DropDownList, x+5 R6 yp-3 W200 vspa_ed_ActDesc, % spa_actionList

	Gui, Add, Text, x10 y+7 w90, %lng_spa_action_para%:
	Gui, Add, Edit, x+5 R1 yp-3 W200 vspa_ed_Para, % spa_ed_Para

	Gui, Add, Checkbox, x10 y+7 w290 vspa_ed_Dict Checked%spa_ed_Dict%, %lng_spa_useDictation%

	Gui, Add, Button, -Wrap y+10 x85 w100 Default gspa_sub_OK, &OK
	Gui, Add, Button, -Wrap x+10 w100 gSpeechActionGuiClose, %lng_Cancel%

	Gui, Show, w600 AutoSize, %spa_EditTitle%
Return

SpeechActionGuiClose:
SpeechActionGuiEscape:
	If GetKey = Escape
	{
		GetKey =
		Return
	}
	Gui, %GuiID_activAid%:-Disabled
	Gui, Submit
	Gui, Destroy
	Gui, %GuiID_activAid%:Default
	Gui, ListView, spa_ListView

	spa_GUI =

	If spa_EditTitle = %lng_spa_Add%
	{
		LV_Delete( spa_LVrow )
		spa_NumActions--
	}
	spa_EditTitle = %lng_spa_Edit%

	spa_SettingsChanged =
Return

spa_sub_ListView:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, spa_ListView
	StringCaseSense, On
	If A_GuiEvent = s
		GuiControl, +Redraw, spa_ListView

	If A_GuiEvent in I,E,F,f,M,S,s
		Return

	spa_lastRow := spa_LVrow
	spa_LVrow := LV_GetNext()

	If A_GuiEvent in Normal,D,d
	{
		GuiControlGet, spa_temp, FocusV
		if spa_temp <> spa_ListView
			GuiControl, Focus, spa_ListView
		Return
	}

	StringCaseSense, Off

	LV_GetText(spa_RowText, spa_LVrow, 1)

	spa_EventInfo =
	If A_GuiEvent = K
		spa_EventInfo = %A_EventInfo%

	If ( A_GuiEvent = "A" OR A_GuiEvent = "DoubleClick" OR uh_EventInfo = 32 )
		Goto, spa_sub_EditCmd

	If spa_EventInfo = 46
		Goto, spa_sub_DelCmd
	If spa_EventInfo = 45
		Goto, spa_sub_AddCmd
Return

spa_sub_AddCmd:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, spa_ListView

	spa_NumActions++
	LV_Add("Select", "","","",spa_NumActions,"",0)
	spa_LVrow := LV_GetNext()
	spa_EditTitle = %lng_spa_Add%

	Gosub, spa_sub_EditCmd
Return

spa_sub_DelCmd:
	Critical

	If spa_NumActions = 0
		Return

	Gui, %GuiID_activAid%:Default
	Gui, ListView, spa_ListView

	spa_LVrow := LV_GetNext()
	LV_GetText(spa_Num, spa_LVrow, 4)

	LV_Delete( spa_LVrow )
	LV_Modify( spa_LVrow, "Select")

	spa_delRows := spa_NumActions - spa_Num

	GuiControl, -Redraw, spa_ListView
	Loop, %spa_delRows%
	{
		spa_nextRow := spa_Num + A_Index
		spa_thisRow := spa_nextRow - 1
		spa_Action%spa_thisRow% := spa_Action%spa_nextRow%
		spa_Command%spa_thisRow% := spa_Command%spa_nextRow%
		spa_Para%spa_thisRow% := spa_Para%spa_nextRow%
		spa_DictateAfter%spa_thisRow% := spa_DictateAfter%spa_nextRow%

		LV_Modify( spa_LVrow+A_Index-1,"Col4", spa_thisRow)
	}
	GuiControl, +Redraw, spa_ListView
	spa_NumActions--

	func_SettingsChanged( "SpeechAction" )
Return

spa_sub_OK:
	Gui, %GuiID_activAid%:-Disabled
	Gui, Submit
	Gui, Destroy
	Gui, %GuiID_activAid%:Default
	Gui, ListView, spa_ListView

	spa_GUI =

	If spa_ed_Cmd =
		spa_ed_Cmd := spa_ed_actDesc

	spa_ed_actDescArray := func_StrClean(spa_ed_actDesc)
	spa_ed_tmpAct := ActionNameByDesc%spa_ed_actDescArray%

	LV_Modify( spa_LVrow,"" , spa_ed_Cmd, spa_ed_actDesc, spa_ed_tmpAct,spa_ed_Num,spa_ed_Para,spa_ed_Dict )

	spa_EditTitle = %lng_spa_Edit%
	func_SettingsChanged( "SpeechAction" )

	LV_Modify( spa_LVrow, "Vis" )
return

spa_DownloadSAPI:
	Run, %spa_downloadLink%
Return


; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

spa_tim_keyPushed:
	SetTimer, spa_tim_keyPushed, Off
	
	if (spa_KeyPushed = 1 && spa_AudioNotify = 1)
		SoundPlay, %spa_snd_end%   
		
	spa_KeyPushed = 0      
Return

spa_tim_KeywordSaid:
	SetTimer, spa_tim_KeywordSaid, Off
		
	if (spa_KeyWordSaid = 1 && spa_AudioNotify = 1)
		SoundPlay, %spa_snd_end%
		
	spa_KeywordSaid = 0      
Return

spa_tim_FollowUp:
	SetTimer, spa_tim_FollowUp, Off
	spa_isFollowUp = 0
	gosub, spa_grammarByDictionary

	performAction(spa_act,spa_recognizedPhrase)
	spa_recognizedPhrase =
Return

spa_initSAPI:
	if spa_requireKeyLock = 1
		func_HotkeyEnable("spa_KeyLock")

	COM_Init()
	spa_plistener:= COM_CreateObject("SAPI.SpSharedRecognizer")
	spa_pcontext := COM_Invoke(spa_plistener, "CreateRecoContext")

	gosub, spa_grammarByDictionary
return

spa_grammarByDictionary:
	spa_pgrammar := COM_Invoke(spa_pcontext , "CreateGrammar")
	COM_Invoke(spa_pgrammar, "DictationSetState", 0)
	spa_prules := COM_Invoke(spa_pgrammar, "Rules")
	spa_prulec := COM_Invoke(spa_prules, "Add", "wordsRule", 0x1|0x20)

	;Load Rules
	gosub, spa_initDict

	COM_Invoke(spa_pgrammar, "CmdSetRuleState", "wordsRule", 1)
	COM_Invoke(spa_prules, "Commit")
	spa_pevent := COM_ConnectObject(spa_pcontext, "On")
return

spa_grammarByDictation:
	spa_pgrammar := COM_Invoke(spa_pcontext , "CreateGrammar")
	COM_Invoke(spa_pgrammar, "DictationSetState", 1)

	;Clear Rules
	spa_prules := COM_Invoke(spa_pgrammar, "Rules")
	COM_Invoke(spa_prulec, "Clear")
	spa_pstate := COM_Invoke(spa_prulec, "InitialState")

	;wordsRule already loaded, so no need to check for existance
	COM_Invoke(spa_pgrammar, "CmdSetRuleState", "wordsRule", 0)
	COM_Invoke(spa_prules, "Commit")

	spa_pevent := COM_ConnectObject(spa_pcontext, "On")
return

spa_initEmptyDict:
	COM_Invoke(spa_prulec, "Clear")
	spa_pstate := COM_Invoke(spa_prulec, "InitialState")
	COM_Invoke(spa_prules, "Commit")
return

spa_initDict:
	COM_Invoke(spa_prulec, "Clear")
	spa_pstate := COM_Invoke(spa_prulec, "InitialState")

	COM_Invoke(spa_pstate, "AddWordTransition", "+" . 0, spa_KeyWord)

	Loop, %spa_NumActions%
	{
		spa_cmd := spa_Command%A_Index%
		COM_Invoke(spa_pstate, "AddWordTransition", "+" . 0, spa_cmd)
	}

	COM_Invoke(spa_prules, "Commit")
return

OnRecognition(prms, this)
{
	Global
	Local presult,pphrase,sText
	Critical

	presult := COM_DispGetParam(prms, 3, 9)
	pphrase := COM_Invoke(presult, "PhraseInfo")
	sText   := COM_Invoke(pphrase, "GetText")
	COM_Release(pphrase)

	if Enable_SpeechAction = 1
	{
		if spa_isFollowUp = 1
		{
			IfNotInString, spa_recognizedPhrase, %sText%
			{
				if sText != %spa_cmd%
					spa_recognizedPhrase = %spa_recognizedPhrase% %sText%
			}
			return
		}

		if spa_KeyWord = %sText%
		{
			if spa_KeywordSaid
				return

			spa_KeywordSaid = 1
			if spa_AudioNotify
				SoundPlay, %spa_WaveFile%

			SetTimer, spa_tim_KeywordSaid, %spa_CommandDelay%
			return
		}

		if(spa_requireKeyLock=1 && spa_KeyPushed=0)
		  return
		if(spa_requireKeyWord=1 && spa_KeyWordSaid=0)
		  return

		Loop, %spa_NumActions%
		{
			spa_cmd := spa_Command%A_Index%
			spa_act := spa_Action%A_Index%
			spa_para := spa_Para%A_Index%
			spa_dict := spa_DictateAfter%A_Index%

			if spa_cmd = %sText%
			{
				if spa_UseBalloonTips
					BalloonTip(spa_ScriptName, lng_spa_recMess ":`n" spa_cmd, "Info", 0, -1, 3)

				if spa_dict = 1
				{
					spa_isFollowUp = 1
					gosub, spa_grammarByDictation
					if spa_AudioNotify
						SoundPlay, %spa_WaveFile%

					SetTimer, spa_tim_FollowUp, %spa_TimeForFollowUp%
				}

				performAction(spa_act,spa_para)

				if spa_AudioNotify
					SoundPlay, %spa_snd_cmd%
				
				spa_KeyPushed=0
				spa_KeyWordSaid=0
				break
			}
		}
	}
}
