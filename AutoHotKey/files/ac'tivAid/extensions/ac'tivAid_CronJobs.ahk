; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               CronJobs
; -----------------------------------------------------------------------------
; Prefix:             cron_
; Version:            0.12
; Date:               2008-08-13
; Author:             David Hilberath
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------
; Basiert auf http://www.autohotkey.com/forum/topic22530.html
; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_CronJobs:
	Prefix = cron
	%Prefix%_ScriptName    = CronJobs
	%Prefix%_ScriptVersion = 0.12
	%Prefix%_Author        = David Hilberath

	CustomHotkey_CronJobs = 0
	IconFile_On_CronJobs  = %A_WinDir%\system32\shell32.dll
	IconPos_On_CronJobs   = 21

	gosub, LoadSettings_CronJobs
	gosub, LanguageCreation_CronJobs

	RegisterAdditionalSetting("cron", "enableTrayTip", 0)
	RegisterAdditionalSetting( "cron", "gui_Sounds", 0, "Type:SubRoutine")
	cron_guiDrawn := 0
	CreateGuiID("CronJobs")
	CreateGuiID("CronJobs_AddAlarm")
	CreateGuiID("CronJobs_SoundConfig")
Return

LanguageCreation_CronJobs:
	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %cron_ScriptName% - zeitliche Steuerung
		Description                   = Führt wiederkehrende Aufgaben (cronjobs) automatisch zu einer bestimmten Zeit aus.

		lng_cron_action               = Aktion
		lng_cron_nextCall             = Nächster Aufruf
		lng_cron_timetable            = Zeitplan
		lng_cron_Edit                 = Bearbeiten
		lng_cron_Add                  = Hinzufügen
		lng_cron_desc                 = Beschreibung
		lng_cron_action_para          = Parameter
		lng_cron_enabled              = Aktiviert
		lng_cron_all                  = Alle
		lng_cron_jobsStarted          = Aufgaben gestartet
		lng_cron_enableTrayTip        = Hinweis anzeigen, wenn Aktionen durchgeführt werden
		lng_cron_Minuten              = Minuten
		lng_cron_Stunden              = Stunden
		lng_cron_Tage                 = Tage
		lng_cron_Monate               = Monate
		lng_cron_daysList             = Sonntag|Montag|Dienstag|Mittwoch|Donnerstag|Freitag|Samstag
		lng_cron_monthList            = Januar|Februar|März|April|Mai|Juni|Juli|August|September|Oktober|November|Dezember
		lng_cron_once                 = Einmalig
		lng_cron_onceShort            = ?
		lng_cron_AlarmActionDesc      = Eieruhr
		lng_cron_weckerKlingelt       = Die Eieruhr klingelt!
		lng_cron_noAlarmMessage       = Keine Wecknachricht angegeben.
		lng_cron_newAlarm             = Eieruhr hinzufügen
		lng_cron_gui_Sounds           = Eieruhr Klingelton ändern...
		lng_cron_waveFile             = Ton
		lng_cron_selectSound          = %cron_ScriptName%: Klang auswählen
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %cron_ScriptName% - a time-based scheduling service
		Description                   = Executes repeating actions (cronjobs)

		lng_cron_action               = Action
		lng_cron_nextCall             = Next run
		lng_cron_timetable            = Timetable
		lng_cron_Edit                 = Edit
		lng_cron_Add                  = Add
		lng_cron_desc                 = Description
		lng_cron_action_para          = Parameter
		lng_cron_enabled              = Enabled
		lng_cron_all                  = All
		lng_cron_jobsStarted          = Cronjobs started
		lng_cron_enableTrayTip        = Show traytip when action is being performed
		lng_cron_Minuten              = Minutes
		lng_cron_Stunden              = Hours
		lng_cron_Tage                 = Days
		lng_cron_Monate               = Months
		lng_cron_daysList             = Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday
		lng_cron_monthList            = January|February|March|April|May|June|July|August|September|October|November|December
		lng_cron_onceShort            = ?
		lng_cron_once                 = Once
		lng_cron_AlarmActionDesc      = Alarm clock
		lng_cron_weckerKlingelt       = Alarm ringing!
		lng_cron_noAlarmMessage       = No alarm message specified.
		lng_cron_newAlarm             = Set new alarm
		lng_cron_gui_Sounds           = Change alarm tone...
		lng_cron_waveFile             = Tone
		lng_cron_selectSound           = %cron_ScriptName%: Select sound
	}

	Loop, parse, lng_cron_daysList, |
	{

		lng_cron_daysArray%A_Index% := A_LoopField
		lng_cron_daysArray%A_LoopField% := A_Index-1
	}

	Loop, parse, lng_cron_monthList, |
	{
		lng_cron_monthsArray%A_Index% := A_LoopField
		lng_cron_monthsArray%A_LoopField% := A_Index
	}
Return


LoadSettings_CronJobs:
	func_HotkeyRead("cron_NewAlarmHotkey", ConfigFile, cron_ScriptName, "NewAlarmHotkey", "cron_newAlarm", "!#Pause")

	IniRead, cron_NumJobs, %ConfigFile%, %cron_ScriptName%, NumJobs, 0
	IniRead, cron_WaveFile, %ConfigFile%, %cron_ScriptName%, AlarmSound, %A_ScriptDir%\Library\notify.wav

	Loop %cron_NumJobs%
	{
		IniRead,cron_enabled%A_Index%,%ConfigFile%,%cron_ScriptName%,CronEnabled%A_Index%
		IniRead,cron_table%A_Index%,%ConfigFile%,%cron_ScriptName%,CronTable%A_Index%
		IniRead,cron_desc%A_Index%,%ConfigFile%,%cron_ScriptName%,CronDesc%A_Index%
		IniRead,cron_action%A_Index%,%ConfigFile%,%cron_ScriptName%,CronAction%A_Index%
		IniRead,cron_actionPara%A_Index%,%ConfigFile%,%cron_ScriptName%,CronActionPara%A_Index%
		IniRead,cron_useWeekdays%A_Index%,%ConfigFile%,%cron_ScriptName%,CronUseWeekdays%A_Index%
		IniRead,cron_once%A_Index%,%ConfigFile%,%cron_ScriptName%,CronOnce%A_Index%
	}

	;cron_restart()
Return

SaveSettings_CronJobs:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, cron_ListView

	IniWrite, %cron_NumJobs%, %ConfigFile%, %cron_ScriptName%, NumJobs
	IniWrite, %cron_WaveFile%, %ConfigFile%, %cron_ScriptName%, AlarmSound

	Loop, %cron_NumJobs%
	{
		LV_GetText(cron_tmp_desc, A_Index, 1)
		LV_GetText(cron_tmp_enabled, A_Index, 2)
		LV_GetText(cron_tmp_action, A_Index, 4)
		LV_GetText(cron_tmp_actionPara, A_Index, 6)
		LV_GetText(cron_tmp_table, A_Index, 8)
		LV_GetText(cron_tmp_useWeekdays, A_Index, 9)
		LV_GetText(cron_tmp_once, A_Index, 10)

		cron_table%A_Index% := cron_tmp_table
		cron_action%A_Index% := cron_tmp_action
		cron_desc%A_Index% := cron_tmp_desc
		cron_actionPara%A_Index% := cron_tmp_actionPara
		cron_enabled%A_Index% := cron_tmp_enabled
		cron_useWeekdays%A_Index% := cron_tmp_useWeekdays
		cron_once%A_Index% := cron_tmp_once

		IniWrite, %cron_tmp_enabled%, %ConfigFile%, %cron_ScriptName%, CronEnabled%A_Index%
		IniWrite, %cron_tmp_table%, %ConfigFile%, %cron_ScriptName%, CronTable%A_Index%
		IniWrite, %cron_tmp_action%, %ConfigFile%, %cron_ScriptName%, CronAction%A_Index%
		IniWrite, %cron_tmp_actionPara%, %ConfigFile%, %cron_ScriptName%, CronActionPara%A_Index%
		IniWrite, %cron_tmp_desc%, %ConfigFile%, %cron_ScriptName%, CronDesc%A_Index%
		IniWrite, %cron_tmp_useWeekdays%,%ConfigFile%,%cron_ScriptName%,CronUseWeekdays%A_Index%
		IniWrite, %cron_tmp_once%,%ConfigFile%,%cron_ScriptName%,CronOnce%A_Index%

		LV_Modify( A_Index,"Col3", A_Index)
	}

	cron_restart()
Return

SettingsGui_CronJobs:
	cron_guiDrawn := 1
	; func_HotkeyAddGuiControl( lng_cj_TEXT, "cj_HOTKEYNAME", "xs+10 y+10 w160" )
	; Gui, Add, Edit, xs+10 y+5 gsub_CheckIfSettingsChanged vcj_var, %lng_cj_text%

	func_HotkeyAddGuiControl( lng_cron_newAlarm, "cron_NewAlarmHotkey", "xs+10 y+5 w160" )

	Gui, Add, ListView, xs+10 y+5 Hwndcron_LVHwnd Count%cron_NumActions% Checked AltSubmit -Multi -LV0x10 Grid h240 w550 vcron_ListView gcron_sub_ListView, %lng_cron_desc%|enabled|num|action|%lng_cron_action%|para|%lng_cron_nextCall%|timetable|useWeekdays|%lng_cron_onceShort%
	Gui, Add, Button, -Wrap xs+205 ys+290 w25 h16 gcron_sub_AddJob, +
	Gui, Add, Button, -Wrap x+5 h16 w25 gcron_sub_DelJob, %MinusString%
	Gui, Add, Button, -Wrap x+5 h16 w135 gcron_sub_EditJob, %lng_cron_Edit%

	LV_ModifyCol(1,160)
	LV_ModifyCol(2,0)
	LV_ModifyCol(3,0)
	LV_ModifyCol(4,0)
	LV_ModifyCol(5,170)
	LV_ModifyCol(6,0)
	LV_ModifyCol(7,170)
	LV_ModifyCol(8,0)
	LV_ModifyCol(9,0)
	LV_ModifyCol(10,0)

	GuiControl, -Redraw, cron_ListView

	Loop, %cron_NumJobs%
	{
		cron_tmp_table := cron_table%A_Index%
		cron_tmp_action := cron_action%A_Index%
		cron_tmp_desc := cron_desc%A_Index%
		cron_tmp_actionPara := cron_actionPara%A_Index%
		cron_tmp_enabled := cron_enabled%A_Index%
		cron_tmp_useWeekdays := cron_useWeekdays%A_Index%
		cron_tmp_once := cron_once%A_Index%

		StringSplit, cron_tmp_table_array, cron_tmp_table, |

		cron_1 := cron_parse(cron_tmp_table_array1,0,59)
		cron_2 := cron_parse(cron_tmp_table_array2,0,23)
		cron_3 := cron_parse(cron_tmp_table_array3,1,31)
		cron_4 := cron_parse(cron_tmp_table_array4,1,12)
		cron_5 := cron_parse(cron_tmp_table_array5,0,6)

		; find the firstcoming month (can be current) and the following month
		cron_findmonths(cron_4,firstmth,secondmth)

		; find two possible dates
		cron_finddates(cron_3,cron_5,firstmth,secondmth,firstdate,seconddate)

		; find the next time to run
		FormatTime, cron_ed_nextRun, % cron_findtime(cron_1,cron_2,firstdate,seconddate,time)

		cron_tmp_ActDesc := ActionDesc%cron_tmp_Action%

		if cron_tmp_enabled = 1
			cron_tmp_options = Check
		else
			cron_tmp_options =

		LV_Add("Select " cron_tmp_options, cron_tmp_desc,cron_tmp_enabled,A_Index,cron_tmp_action,cron_tmp_ActDesc,cron_tmp_actionPara,cron_ed_nextRun,cron_tmp_table,cron_tmp_useWeekdays,cron_tmp_once)
		;LV_Add("", cron_Command%A_Index%, cron_tmp_desc, cron_Action%A_Index%, A_Index, cron_Para%A_Index%, cron_DictateAfter%A_Index%)
	}
	GuiControl, +Redraw, cron_ListView

	cron_EditTitle = %lng_cron_Edit%
Return

AddSettings_CronJobs:
Return

CancelSettings_CronJobs:
Return

DoEnable_CronJobs:
	; func_HotkeyEnable("cj_HOTKEYNAME")
	cron_restart()


	func_HotkeyEnable("cron_newAlarmHotkey")
	RegisterAction("AlarmClock",lng_cron_AlarmActionDesc,"cron_alarm")
Return

DoDisable_CronJobs:
	; func_HotkeyDisable("cj_HOTKEYNAME")
	SetTimer, cron_timer, Off
	func_HotkeyDisable("cron_newAlarmHotkey")
	unRegisterAction("AlarmClock")
Return

DefaultSettings_CronJobs:
Return

OnExitAndReload_CronJobs:
Return


; -----------------------------------------------------------------------------
; === Edit+Add Job ============================================================
; -----------------------------------------------------------------------------
cron_sub_ListView:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, cron_ListView
	StringCaseSense, On
	If A_GuiEvent = s
		GuiControl, +Redraw, cron_ListView

	If A_GuiEvent = I
	{
		If InStr(ErrorLevel, "C", true)
		{
			LV_GetText(cron_tmp_num, A_EventInfo, 3)

			if cron_tmp_num !=
			{
				LV_Modify( A_EventInfo,"Col2", 1)
				cron_enabled%cron_tmp_num% := 1
				func_settingsChanged("CronJobs")
			}
		}

		If InStr(ErrorLevel, "c", true)
		{
			LV_GetText(cron_tmp_num, A_EventInfo, 3)

			if cron_tmp_num !=
			{
				LV_Modify( A_EventInfo,"Col2", 0)
				cron_enabled%cron_tmp_num% := 0
				func_settingsChanged("CronJobs")
			}
		}
	}

	If A_GuiEvent in I,E,F,f,M,S,s
		Return

	cron_lastRow := cron_LVrow
	cron_LVrow := LV_GetNext()

	If A_GuiEvent in Normal,D,d
	{
		GuiControlGet, cron_temp, FocusV
		if cron_temp <> cron_ListView
			GuiControl, Focus, cron_ListView
		Return
	}

	StringCaseSense, Off

	LV_GetText(cron_RowText, cron_LVrow, 1)

	cron_EventInfo =
	If A_GuiEvent = K
		cron_EventInfo = %A_EventInfo%

	If ( A_GuiEvent = "A" OR A_GuiEvent = "DoubleClick" OR uh_EventInfo = 32 )
		Goto, cron_sub_EditJob

	If cron_EventInfo = 46
		Goto, cron_sub_DelJob
	If cron_EventInfo = 45
		Goto, cron_sub_AddJob
return

cron_sub_DelJob:
	Critical

	If cron_NumJobs = 0
		Return

	Gui, %GuiID_activAid%:Default
	Gui, ListView, cron_ListView

	cron_LVrow := LV_GetNext()
	LV_GetText(cron_Num, cron_LVrow, 4)

	LV_Delete( cron_LVrow )
	LV_Modify( cron_LVrow, "Select")

	cron_delRows := cron_NumJobs - cron_Num

	GuiControl, -Redraw, cron_ListView
	Loop, %cron_delRows%
	{
		cron_nextRow := cron_Num + A_Index
		cron_thisRow := cron_nextRow - 1

		cron_table%cron_thisRow% := cron_table%cron_nextRow%
		cron_action%cron_thisRow% := cron_action%cron_nextRow%
		cron_desc%cron_thisRow% := cron_desc%cron_nextRow%
		cron_actionPara%cron_thisRow% := cron_actionPara%cron_nextRow%
		cron_enabled%cron_thisRow% := cron_enabled%cron_nextRow%
		cron_useWeekdays%cron_thisRow% := cron_useWeekdays%cron_nextRow%
		cron_once%cron_thisRow% := cron_once%cron_nextRow%

		LV_Modify( cron_LVrow+A_Index-1,"Col3", cron_thisRow)
	}
	GuiControl, +Redraw, cron_ListView
	cron_NumJobs--

	func_SettingsChanged( "CronJobs" )
return

cron_sub_EditJob:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, cron_ListView

	if (cron_LVrow = 0 OR cron_LVrow = "")
		Goto, cron_sub_AddJob

	If cron_GUI = 3
		Return

	cron_GUI = 3

	LV_GetText(cron_ed_desc, cron_LVrow, 1)
	LV_GetText(cron_ed_enabled, cron_LVrow, 2)
	LV_GetText(cron_ed_Num, cron_LVrow, 3)
	LV_GetText(cron_ed_action, cron_LVrow, 4)
	LV_GetText(cron_ed_ActDesc, cron_LVrow, 5)
	LV_GetText(cron_ed_actionPara, cron_LVrow, 6)
	LV_GetText(cron_ed_timeleft, cron_LVrow, 7)
	LV_GetText(cron_ed_table, cron_LVrow, 8)
	LV_GetText(cron_ed_useWeekdays, cron_LVrow, 9)
	LV_GetText(cron_ed_once, cron_LVrow, 10)

	if cron_ed_once =
		cron_ed_once = 0

	cron_actionList := ActionsDesc

	if cron_ed_actDesc !=
		StringReplace, cron_actionList, cron_actionList, %cron_ed_actDesc%, %cron_ed_actDesc%|

	Gui, %GuiID_activAid%:+Disabled
	GuiDefault("CronJobs", "-MaximizeBox +Owner" GuiID_activAid)^

	Gosub, GuiDefaultFont

	Gui, Add, Button, -Wrap y22 x330 w80 Default gcron_sub_OK, &OK
	Gui, Add, Button, -Wrap y+5 w80 gCronJobsGuiClose, %lng_Cancel%
	Gui, Add, Checkbox, y+8 xp+16 w60 Check3 checked%cron_ed_once% vcron_ed_once gcron_sub_onceCheckIfSettingsChanged, %lng_cron_once%

	Gui, Add, Groupbox, w420 h320 x5 y7
	Gui, Add, Checkbox, xp+10 yp-1 w60 checked%cron_ed_enabled% vcron_ed_enabled, %lng_cron_enabled%

	Gui, Add, Text, x15 y27 w90, %lng_cron_desc%:
	Gui, Add, Edit, x+5 R1 yp-3 W205  vcron_ed_desc, % cron_ed_desc

	Gui, Add, Text, x15 y+7 w90, %lng_cron_action%:
	Gui, Add, DropDownList, x+5 R6 yp-3 W205 vcron_ed_ActDesc, % cron_actionList

	Gui, Add, Text, x15 y+7 w90, %lng_cron_action_para%:
	Gui, Add, Edit, x+5 R1 yp-3 W205 vcron_ed_Para, % cron_ed_actionPara

	Gui, Add, Groupbox, w405 h220 x13 y+7, %lng_cron_timetable%

	;cron_ed_table := cron_ed_min "|" cron_ed_hrs "|" cron_ed_days "|" cron_ed_months "|" cron_ed_weekdays
	StringSplit, cron_tmp_table, cron_ed_table, |
	cron_ed_min := cron_tmp_table1
	cron_ed_hrs := cron_tmp_table2
	cron_ed_days := cron_tmp_table3
	cron_ed_months := cron_tmp_table4
	cron_ed_weekdays := cron_tmp_table5

	if cron_ed_min = *
		cron_ed_minWildCard := 1
	else
		cron_ed_minWildCard := 0

	if cron_ed_hrs = *
		cron_ed_hrsWildCard := 1
	else
		cron_ed_hrsWildCard := 0

	if (cron_ed_days = "*" && cron_ed_weekdays = "*")
		cron_ed_daysWildCard := 1
	else
		cron_ed_daysWildCard := 0

	if cron_ed_months = *
		cron_ed_monthsWildCard := 1
	else
		cron_ed_monthsWildCard := 0


	Gui, Add, Text, xp+5 yp+20, %lng_cron_Minuten%:
	Gui, Add, ListBox, y+5 w25 R12 Multi gcron_multiListbox vcron_ed_min1,% cron_createPreSelectList(cron_ed_min,0,11)
	Gui, Add, ListBox, x+1 w25 R12 Multi gcron_multiListbox vcron_ed_min2,% cron_createPreSelectList(cron_ed_min,12,23)
	Gui, Add, ListBox, x+1 w25 R12 Multi gcron_multiListbox vcron_ed_min3,% cron_createPreSelectList(cron_ed_min,24,35)
	Gui, Add, ListBox, x+1 w25 R12 Multi gcron_multiListbox vcron_ed_min4,% cron_createPreSelectList(cron_ed_min,36,47)
	Gui, Add, ListBox, x+1 w25 R12 Multi gcron_multiListbox vcron_ed_min5,% cron_createPreSelectList(cron_ed_min,48,59)

	Gui, Add, Text, x+18 yp-18, %lng_cron_Stunden%:
	Gui, Add, ListBox, y+5 w25 R12 Multi gcron_multiListbox vcron_ed_hrs1,% cron_createPreSelectList(cron_ed_hrs,0,11)
	Gui, Add, ListBox, x+1 w25 R12 Multi gcron_multiListbox vcron_ed_hrs2,% cron_createPreSelectList(cron_ed_hrs,12,23)

	Gui, Add, Text, x+18 yp-18 w40, %lng_cron_Tage%:
	Gui, Add, ListBox, y+5 w25 R12 Multi gcron_multiListbox vcron_ed_days1,% cron_createPreSelectList(cron_ed_days,1,12)
	Gui, Add, ListBox, x+1 w25 R12 Multi gcron_multiListbox vcron_ed_days2,% cron_createPreSelectList(cron_ed_days,13,24)
	Gui, Add, ListBox, x+1 w25 R12 Multi gcron_multiListbox vcron_ed_days3,% cron_createPreSelectList(cron_ed_days,25,31)

	Gui, Add, Text, x+18 yp-18, %lng_cron_Monate%:

	cron_preSelectMonthsList := cron_createPreSelectList(cron_ed_months,1,12)

	Loop, 12
	{
		cron_i := 13-A_Index
		cron_iTemp := lng_cron_monthsArray%cron_i%

		StringReplace,cron_preSelectMonthsList,cron_preSelectMonthsList,%cron_i%,%cron_iTemp%
	}

	Gui, Add, ListBox, y+5 w80 R12 Multi gcron_multiListbox vcron_ed_months1,%cron_preSelectMonthsList%

	Gui, Add, CheckBox, x18 y305 w45 gcron_sub_checkIfSettingsChanged vcron_ed_minWildCard Checked%cron_ed_minWildCard%, %lng_cron_all%
	Gui, Add, CheckBox, x+102         gcron_sub_checkIfSettingsChanged vcron_ed_hrsWildCard Checked%cron_ed_hrsWildCard%, %lng_cron_all%
	Gui, Add, CheckBox, x+36         gcron_sub_checkIfSettingsChanged vcron_ed_daysWildCard Checked%cron_ed_daysWildCard%, %lng_cron_all%
	Gui, Add, CheckBox, x+62         gcron_sub_checkIfSettingsChanged vcron_ed_monthsWildCard Checked%cron_ed_monthsWildCard%, %lng_cron_all%

	Gui, Add, Checkbox, x298 y122 gcron_sub_checkIfSettingsChanged vcron_ed_useWeekdays Checked%cron_ed_useWeekdays%,


	cron_preSelectWeekdaysList := cron_createPreSelectList(cron_ed_weekdays,0,6)
	Loop, 7
	{
		cron_i := A_Index-1
		cron_iTemp := lng_cron_daysArray%A_Index%

		StringReplace,cron_preSelectWeekdaysList,cron_preSelectWeekdaysList,%cron_i%,%cron_iTemp%
	}

	Gui, Add, ListBox, x234 y140 w77 R12 Multi gcron_multiListbox vcron_ed_weekdays1,%cron_preSelectWeekdaysList%


	gosub, cron_sub_checkIfSettingsChanged
	Gui, Show, w430 h335, %cron_EditTitle%
return

cron_sub_onceCheckIfSettingsChanged:
	GuiControlGet, cron_ed_once_tmp,, cron_ed_once
	If cron_ed_once_tmp = -1
		GuiControl,, cron_ed_once,0

return

cron_sub_checkIfSettingsChanged:
	GuiControlGet, cron_ed_useWeekdays_tmp,, cron_ed_useWeekdays
	GuiControl, Hide%cron_ed_useWeekdays_tmp%, cron_ed_days1
	GuiControl, Hide%cron_ed_useWeekdays_tmp%, cron_ed_days2
	GuiControl, Hide%cron_ed_useWeekdays_tmp%, cron_ed_days3
	GuiControl, Show%cron_ed_useWeekdays_tmp%, cron_ed_weekdays1

	GuiControlGet, cron_ed_minWildCard_tmp,, cron_ed_minWildCard
	Loop, 5
	{
		cron_tmp_mlbox := "cron_ed_min" A_Index
		GuiControl, Disable%cron_ed_minWildCard_tmp%, %cron_tmp_mlbox%
	}

	GuiControlGet, cron_ed_hrsWildCard_tmp,, cron_ed_hrsWildCard
	Loop, 2
	{
		cron_tmp_mlbox := "cron_ed_hrs" A_Index
		GuiControl, Disable%cron_ed_hrsWildCard_tmp%, %cron_tmp_mlbox%
	}


	GuiControlGet, cron_ed_daysWildCard_tmp,, cron_ed_daysWildCard
	Loop, 3
	{
		cron_tmp_mlbox := "cron_ed_days" A_Index
		GuiControl, Disable%cron_ed_daysWildCard_tmp%, %cron_tmp_mlbox%
	}

	cron_tmp_mlbox := "cron_ed_weekdays1"
	GuiControl, Disable%cron_ed_daysWildCard_tmp%, %cron_tmp_mlbox%

	GuiControlGet, cron_ed_monthsWildCard_tmp,, cron_ed_monthsWildCard
	cron_tmp_mlbox := "cron_ed_months1"
	GuiControl, Disable%cron_ed_monthsWildCard_tmp%, %cron_tmp_mlbox%
return

cron_sub_OK:
	Gui, %GuiID_activAid%:-Disabled
	Gui, Submit
	Gui, Destroy
	Gui, %GuiID_activAid%:Default
	Gui, ListView, cron_ListView

	cron_GUI =

	If cron_ed_desc =
		cron_ed_desc := cron_ed_actDesc

	If (cron_ed_months != "*" && cron_ed_months != "")
	{
		cron_tmp_months =
		Loop, parse, cron_ed_months, `,
		{
			cron_tmp_months := cron_tmp_months lng_cron_monthsArray%A_LoopField% ","
		}
		StringTrimRight, cron_ed_months, cron_tmp_months, 1
	}

	If (cron_ed_weekdays != "*" && cron_ed_weekdays != "")
	{
		cron_tmp_weekdays =

		Loop, parse, cron_ed_weekdays, `,
		{
			If (InStr(lng_cron_daysList,A_LoopField)>0)
				cron_tmp_weekdays := cron_tmp_weekdays lng_cron_daysArray%A_LoopField% ","
			else
				cron_tmp_weekdays := cron_tmp_weekdays A_LoopField ","
		}

		StringTrimRight, cron_ed_weekdays, cron_tmp_weekdays, 1
	}

	cron_ed_actDescArray := func_StrClean(cron_ed_ActDesc)
	cron_ed_action := ActionNameByDesc%cron_ed_actDescArray%

	if cron_ed_minWildCard
		cron_ed_min = *

	if cron_ed_hrsWildCard
		cron_ed_hrs = *

	if cron_ed_monthsWildCard
		cron_ed_months = *

	if cron_ed_daysWildCard
	{
		cron_ed_days = *
		cron_ed_weekdays = *
	}
	else
	{
		if cron_ed_useWeekdays = 1
			cron_ed_days = *
		else
			cron_ed_weekdays = *
	}

	cron_ed_table := cron_ed_min "|" cron_ed_hrs "|" cron_ed_days "|" cron_ed_months "|" cron_ed_weekdays

	cron_1 := cron_parse(cron_ed_min,0,59)
	cron_2 := cron_parse(cron_ed_hrs,0,23)
	cron_3 := cron_parse(cron_ed_days,1,31)
	cron_4 := cron_parse(cron_ed_months,1,12)
	cron_5 := cron_parse(cron_ed_weekdays,0,6)

	; find the firstcoming month (can be current) and the following month
	cron_findmonths(cron_4,firstmth,secondmth)

	; find two possible dates
	cron_finddates(cron_3,cron_5,firstmth,secondmth,firstdate,seconddate)

	; find the next time to run
	cron_ed_nextRun := cron_findtime(cron_1,cron_2,firstdate,seconddate,time)
	FormatTime, cron_ed_nextRun, %cron_ed_nextRun%

	LV_Modify( cron_LVrow,"Check" cron_ed_enabled, cron_ed_desc, cron_ed_enabled, cron_ed_Num,cron_ed_action,cron_ed_ActDesc,cron_ed_Para,cron_ed_nextRun,cron_ed_table,cron_ed_useWeekdays,cron_ed_once)

	cron_EditTitle = %lng_cron_Edit%
	func_SettingsChanged( "CronJobs" )

	LV_Modify( cron_LVrow, "Vis" )
return

cron_multiListbox:
	GetKeyState, cron_CtrlState, Ctrl, P
	GetKeyState, cron_ShiftState, Shift, P

	StringRight, cron_mlBoxClickedOn, A_GuiControl, 1
	StringTrimRight, cron_mlboxes, A_GuiControl, 1

	cron_deleteOthers := 1

	If cron_CtrlState = D
		cron_deleteOthers := 0

	If cron_ShiftState = D
		cron_deleteOthers := 0

	cron_content =
	Loop, 9
	{
		cron_tmp_mlbox := cron_mlboxes A_Index
		GuiControlGet, cron_tmp,Hwnd,%cron_tmp_mlbox%
		If ErrorLevel = 0
		{
			if cron_deleteOthers
			{
				if cron_tmp_mlbox != %A_GuiControl%
				{
					PostMessage, 0x185, 0, -1,, ahk_id %cron_tmp%
					Sleep, 10
				}
			}

			GuiControlGet, cron_contentTmp,,%cron_tmp_mlbox%

			if cron_contentTmp !=
				cron_content = %cron_content%%cron_contentTmp%|
		}
	}

	StringRight, cron_testPipe, cron_content, 1
	if cron_testPipe = |
		StringTrimRight, cron_content, cron_content, 1

	StringReplace, cron_content, cron_content, |, `,,A
	%cron_mlboxes% := cron_content
return

cron_sub_AddJob:
	Gui, %GuiID_activAid%:Default
	Gui, ListView, cron_ListView

	cron_NumJobs++

	LV_Add("Select Check0", "",0,cron_NumJobs,"","","","","",0,0)
	cron_LVrow := LV_GetNext()
	cron_EditTitle = %lng_cron_Add%

	Gosub, cron_sub_EditJob
return

CronJobsGuiEscape:
CronJobsGuiClose:
	Gui, %GuiID_activAid%:-Disabled
	Gui, Submit
	Gui, Destroy
	Gui, %GuiID_activAid%:Default
	Gui, ListView, cron_ListView

	cron_GUI =

	If cron_EditTitle = %lng_cron_Add%
	{
		LV_Delete( cron_LVrow )
		cron_NumJobs--
	}
	cron_EditTitle = %lng_cron_Edit%

	cron_SettingsChanged =
return


; -----------------------------------------------------------------------------
; === Alarmclock =============================================================
; -----------------------------------------------------------------------------
cron_alarm:
	SoundPlay, %cron_WaveFile%
	cron_msg := ActionParameter

	if cron_msg =
		cron_msg = %lng_cron_noAlarmMessage%

	BalloonTip(cron_ScriptName, lng_cron_weckerKlingelt "`n" cron_msg, "Info", 0, -1, 3)
return

cron_search_sound:
	GuiDefault("CronJobs_SoundConfig", "-MaximizeBox +Owner" GuiID_activAid)
	GuiControlGet,cron_oldLocation,,cron_WaveFile

	FileSelectFile, cron_newFile, 3,*%cron_oldLocation%,%lng_cron_selectSound%, Wave Audio (*.wav)

	if cron_newFile =
		cron_newFile = %cron_oldLocation%

	GuiControl,,cron_WaveFile,%cron_newFile%
return

cron_gui_Sounds:
	Gui, %GuiID_activAid%:+Disabled
	GuiDefault("CronJobs_SoundConfig", "-MaximizeBox +Owner" GuiID_activAid)
	Gosub, GuiDefaultFont

	Gui, Add, Text, x10 y+7 w90, %lng_cron_waveFile%:
	Gui, Add, Edit, x+5 R1 yp-3 W350  vcron_WaveFile, % cron_WaveFile
	Gui, Add, Button, x+5 w30 vcron_WaveFile_search gcron_search_sound, ...

	Gui, Add, Button, -Wrap y+10 x85 w100 Default gcron_snd_OK, &OK
	Gui, Add, Button, -Wrap x+10 w100 gCronJobs_SoundConfigGuiClose, %lng_Cancel%

	Gui, Show, w600 AutoSize, %lng_cron_gui_Sounds%
return

CronJobs_SoundConfigGuiEscape:
CronJobs_SoundConfigGuiClose:
	If GetKey = Escape
	{
		GetKey =
		Return
	}
	Gui, %GuiID_activAid%:-Disabled
	Gui, Submit
	Gui, Destroy
	Gui, %GuiID_activAid%:Default

	cron_SettingsChanged =
return

cron_snd_OK:
	Gui, %GuiID_activAid%:-Disabled
	Gui, Submit
	Gui, Destroy
	Gui, %GuiID_activAid%:Default

	func_SettingsChanged( "CronJobs" )
return

cron_newAlarm:
	GuiDefault("CronJobs_AddAlarm", "-MaximizeBox")
	Gui, Destroy

	Gui, Add, Edit, x5 y5 w140 vcron_addAlarm_desc,

	Gui, Add, Edit, y+5 w50 ReadOnly, 0
	Gui, Add, UpDown, Wrap vcron_addAlarm_h Range0-24 gcron_addAlarm_upDown, 0
	Gui, Add, Text, x+5 yp+2, h

	Gui, Add, Edit, x+10 yp-2 w50 ReadOnly, 0
	Gui, Add, UpDown, Wrap vcron_addAlarm_min Range0-59 gcron_addAlarm_upDown, 0
	Gui, Add, Text, x+5 yp+2, min

	Gui, Add, StatusBar,,
	Gui, Add, Button, Default x165 y18 h30 w40 gcron_addAlarm_Ok, Ok

	gosub, cron_addAlarm_upDown
	Gui, Show, w210 h80, %lng_cron_newAlarm%
return

CronJobs_AddAlarmGuiClose:
CronJobs_AddAlarmGuiEscape:
	GuiDefault("CronJobs_AddAlarm", "-MaximizeBox")
	Gui, Destroy
return

cron_addAlarm_Ok:
	GuiDefault("CronJobs_AddAlarm", "-MaximizeBox")
	GuiControlGet, cron_tmp_resultTime_add_h,, cron_addAlarm_h
	GuiControlGet, cron_tmp_resultTime_add_min,, cron_addAlarm_min
	GuiControlGet, cron_tmp_resultDesc,, cron_addAlarm_desc

	if cron_tmp_resultDesc =
		cron_tmp_resultDesc = %lng_cron_AlarmActionDesc%

	cron_tmp_resultTime =  ; Make it blank so that the below will use the current time instead.
	cron_tmp_resultTime += %cron_addAlarm_h%, h
	cron_tmp_resultTime += %cron_addAlarm_min%, m

	FormatTime, cron_tmp_humanTime, %cron_tmp_resultTime%
	FormatTime, cron_tmp_result, %cron_tmp_resultTime%, d-H-m

	StringSplit, cron_tmp_resultArray, cron_tmp_result, -

	cron_numJobs++

	cron_tmp_table := cron_tmp_resultArray3 "|" cron_tmp_resultArray2 "|" cron_tmp_resultArray1 "|*|*"

	cron_table%cron_numJobs% := cron_tmp_table
	cron_action%cron_numJobs% := "AlarmClock"
	cron_desc%cron_numJobs% := cron_tmp_resultDesc
	cron_actionPara%cron_numJobs% := cron_tmp_resultDesc
	cron_enabled%cron_numJobs% := 1
	cron_useWeekdays%cron_numJobs% := 0
	cron_once%cron_numJobs% := 1

	IniWrite, %cron_NumJobs%, %ConfigFile%, %cron_ScriptName%, NumJobs
	IniWrite, 1, %ConfigFile%, %cron_ScriptName%, CronEnabled%cron_numJobs%
	IniWrite, %cron_tmp_table%, %ConfigFile%, %cron_ScriptName%, CronTable%cron_numJobs%
	IniWrite, AlarmClock, %ConfigFile%, %cron_ScriptName%, CronAction%cron_numJobs%
	IniWrite, %cron_tmp_resultDesc%, %ConfigFile%, %cron_ScriptName%, CronActionPara%cron_numJobs%
	IniWrite, %cron_tmp_resultDesc%, %ConfigFile%, %cron_ScriptName%, CronDesc%cron_numJobs%
	IniWrite, 0,%ConfigFile%,%cron_ScriptName%,CronUseWeekdays%cron_numJobs%
	IniWrite, 1,%ConfigFile%,%cron_ScriptName%,CronOnce%cron_numJobs%

	cron_restart()

	GuiDefault("CronJobs_AddAlarm", "-MaximizeBox")
	Gui, Destroy

	if cron_guiDrawn = 1
	{
		Gui, %GuiID_activAid%:Default
		Gui, ListView, cron_ListView

		LV_Add("Select Check1", cron_tmp_resultDesc,1,cron_NumJobs,"AlarmClock",lng_cron_AlarmActionDesc,cron_tmp_resultDesc,cron_tmp_humanTime,cron_tmp_table,0,1)
	}
return

cron_addAlarm_upDown:
	GuiDefault("CronJobs_AddAlarm", "-MaximizeBox")
	GuiControlGet, cron_tmp_resultTime_add_h,, cron_addAlarm_h
	GuiControlGet, cron_tmp_resultTime_add_min,, cron_addAlarm_min

	cron_tmp_resultTime =  ; Make it blank so that the below will use the current time instead.
	cron_tmp_resultTime += %cron_addAlarm_h%, h
	cron_tmp_resultTime += %cron_addAlarm_min%, m

	FormatTime, cron_tmp_resultTime, %cron_tmp_resultTime%
	SB_SetText(cron_tmp_resultTime)
return



; -----------------------------------------------------------------------------
; === Cron-Routines =============================================================
; -----------------------------------------------------------------------------

cron_Timer:
	SetTimer,cron_Timer, off
	cron_tooltip =

	Loop,Parse,cron_nextid,|
	{
		If A_LoopField
		{
			cron_tmp_action     := cron_action%a_loopfield%
			cron_tmp_actionPara := cron_actionPara%a_loopfield%
			cron_tmp_ActDesc    := ActionDesc%cron_tmp_action%
			cron_tmp_once       := cron_once%A_LoopField%

			if cron_tmp_once = 1
			{
				performAction(cron_tmp_action, cron_tmp_actionPara)
				cron_once%A_LoopField% = -1

				Gui, %GuiID_activAid%:Default
				Gui, ListView, cron_ListView

				LV_Modify( A_LoopField,"Col10",-1)

				IniWrite, -1,%ConfigFile%,%cron_ScriptName%,CronOnce%A_LoopField%
				cron_tooltip   := cron_tooltip "`n" cron_tmp_ActDesc "(Once)"
			}

			if cron_tmp_once = 0
			{
				performAction(cron_tmp_action, cron_tmp_actionPara)
				cron_tooltip   := cron_tooltip "`n" cron_tmp_ActDesc
			}
		}
	}



	if cron_enableTrayTip = 1
	{
		If cron_tooltip !=
			BalloonTip(cron_ScriptName,lng_cron_jobsStarted "`n" cron_tooltip, "Info", 0, -1, 3)
	}
	cron_restart()
Return

cron_createPreSelectList(preSelect,min,max)
{
	i := min
	res =
	loop
	{
		str := i
		loop, parse, preSelect, `,
		{
			if i = %A_LoopField%
			{
				str = %str%|

			}
		}
		res := res . (res == "" ? "" : "|") str

		i++

		if (i > max)
			break
	}
	res := res . "|"

	;loop, parse, preSelect, `,
	;   StringReplace, res, res, |%A_LoopField%|, |%A_LoopField%||

	;StringTrimLeft, res, res, 2

	return res
}

cron_restart()
{
	global
	local firstmth,secondmth,firstdate,seconddate,time

	if Enable_CronJobs = 1
	{
		cron_next =
		cron_nextid =

		Loop %cron_numJobs%
		{
			if (cron_enabled%a_index% = 1 || (MainGuiVisible <> "" && ExtensionGuiDrawn[CronJobs] <> ""))
			{
				cron_ := cron_table%a_index%
				stringsplit,cron_,cron_,|

				cron_1 := cron_parse(cron_1,0,59)
				cron_2 := cron_parse(cron_2,0,23)
				cron_3 := cron_parse(cron_3,1,31)
				cron_4 := cron_parse(cron_4,1,12)
				cron_5 := cron_parse(cron_5,0,6)

				; find the firstcoming month (can be current) and the following month
				cron_findmonths(cron_4,firstmth,secondmth)

				; find two possible dates
				cron_finddates(cron_3,cron_5,firstmth,secondmth,firstdate,seconddate)

				; find the next time to run
				cron_time := cron_findtime(cron_1,cron_2,firstdate,seconddate,time)

				If ((cron_next = "" || cron_time <= cron_next) && cron_enabled%a_index% = 1)
				{
					If (cron_time = cron_next)
						cron_nextid = %cron_nextid%%A_Index%|
					Else
						cron_nextid = %A_Index%|

					cron_next := cron_time
				}

				If (MainGuiVisible <> "" && ExtensionGuiDrawn[CronJobs] <> "")
				{
					FormatTime, cron_humanTime, %cron_time%
					;msgbox, %A_Index% --> %cron_humanTime%

					Gui, %GuiID_activAid%:Default
					Gui, ListView, cron_ListView
					LV_Modify( A_Index,"Col7", cron_humanTime)
				}
			}
		}

		if cron_next !=
		{
			; calculate the waiting time i ms
			cron_wait = %cron_next%
			EnvSub,cron_wait,%a_now%,S
			cron_wait *= 1000

			SetTimer, cron_timer, %cron_wait%
		}
	}
}

cron_parse(cron,min,max)
{
	len   := StrLen(cron)
	start  =
	stop   =
	mode   = 0
	step   = 1
	result =

	; implemented as a state machine (starting in 0)
	Loop %len%
	{
		ch := SubStr(cron,A_Index,1)

		; collect digit in start,stop or step
		If ch is digit
		{
			If mode = 0
				start .= ch
			Else If mode = 1
				stop .= ch
			Else
				step .= ch
		}
		; switch to stop
		Else If ch = -
		{
			If Mode = 0
			{
				mode = 1
				stop =
			}
			Else
				MsgBox %ch% wasn't expected here
		}
		; * only allowed in start-mode
		Else If ch = *
		{
			If Mode = 0
			{
				start = %min%
				stop  = %max%
			}
			Else
				MsgBox %ch% wasn't expected here
		}
		; switch to step
		Else If ch = /
		{
			step =
			mode = 2
		}

	 ; cron contains multiple ranges
		Else If ch = `,
		{
			If ((cron and start < min) or stop > max)
			{
				MsgBox %cron% is out of range (%min% to %max%)
				Return
			}

			if !stop
				stop := start

			cron_expand(start,stop,step,result)

			; and reset
			mode  = 0
			start =
			stop  =
			step  = 1
		}
	}

	If ((cron and start < min) or stop > max)
	{
		MsgBox %cron% is out of range (%min% to %max%)
		Return
	}

	; expand the rest
	If (start <> "")
	{
		If !stop
			stop := start
		cron_expand(start,stop,step,result)
	}

	Sort,result,UND`,

	return result
}


cron_expand(min,max,step,byref result)
{
	val = %min%

	Loop
	{
		result .= (result <> "" ? "," : "") . val
		val += step

		If (val > max)
			Break
	}
}

cron_list(min,max)
{
	i := min
	res =
	loop
	{
		res := res . (res == "" ? "" : ",") i
		i++

		if (i > max)
			break
	}

	return res
}

cron_findmonths(months,byref firstmth,byref secondmth)
{
	; loop through 12 months from the current month
	month := A_MM+0
	firstmth =
	secondmth =

	loop 12
	{
		; is month active
		if month in %months%
		{
			; save in first or second
			if not firstmth
				firstmth = %month%
			else
			{
				secondmth = %month%
				break
			}
		}
		month++

		; wrap around
		if month>12
			month=1
	}
}

cron_finddates(days, dayofweek, firstmth, secondmth, byref firstdate, byref seconddate)
{
	month := A_MM+0
	firstdate =
	seconddate =

	; loop twice to find to days which could be in two months
	Loop 2
	{
		; establish starting point, differentiated because the date in the first month could be later this month
		If (A_Index = 1)
		{
			If (month = firstmth) ; later this month
				date = %A_YYYY%%A_MM%%A_DD%
			Else
				date := (firstmth<month ? A_YYYY+1 : A_YYYY) . (firstmth<10 ? "0" : "") . firstmth . "01"
		}
		Else
		{
			date := (secondmth<month ? A_YYYY+1 : A_YYYY) . (secondmth<10 ? "0" : "") . secondmth . "01"
		}

		; used to check when date is "overflowing" month
		FormatTime,startmth,%date%,M
		Loop
		{
			; get the day of the week, the day of the month and the month
			FormatTime,mth,%date%,M
			FormatTime,day,%date%,d
			FormatTime,wday,%date%,WDay
			wday-- ; must use 0 as sunday in cron format

			; check if day is allowed or weekday is allowed
			ok = 1
			if day not in %days%
				ok = 0
			if wday not in %dayofweek%
				ok = 0

			; msgbox %date% %mth% %day% %wday% %ok%
			if ok
			{
				if not firstdate
					firstdate := substr(date,1,8)
				else
				{
					seconddate := substr(date,1,8)
					break
				}
			}

			; advance to next date
			date += 1,days

			; chech if date is out of month
			if (mth != startmth)
				break
		}

		; both dates found in one month
		if seconddate
			break
	}
}

cron_findtime(mins,hours,firstdate,seconddate,byref time)
{
	;check today
	hour := A_Hour
	time =

	Loop % 24-hour
	{
		if hour in %hours%
		{
			if hour = %A_Hour%
			{
				min := A_min+1

				Loop % 60-min
				{
					if min in %mins%
					{
						time := (hour < 10 ? "0" : "") . hour . (min < 10 ? "0" : "") . min
						break
					}

					min++
				}

			}
			else
			{
				min := 0

				Loop % 60
				{
					if min in %mins%
					{
						time := (hour < 10 ? "0" : "") . hour . (min < 10 ? "0" : "") . min
						break
					}

					min++
				}
			}

			if time !=
				break
		}

		hour++
	}

	if time !=
		result := firstdate . time . 00
	else
	{
		hour = 0
		min = 0
		Loop % 24-hour
		{
			if hour in %hours%
			{
				if hour = A_Hour
				{
					Loop % 60-min
					{
						if min in %mins%
						{
							;minute in correct hour found
							time := (hour < 10 ? "0" : "") . hour . (min < 10 ? "0" : "") . min
							break
						}
						min++
					}
				}
				else
				{
					min := 0
					Loop % 60
					{
						if min in %mins%
						{
							;minute in correct hour found
							time := (hour < 10 ? "0" : "") . hour . (min < 10 ? "0" : "") . min
							break
						}
						min++
					}
				}
				if time !=
					break
			}
			hour++
		}
		result := (firstdate = A_YYYY . A_MM . A_DD ? seconddate : firstdate) . time . 00
	}

	return result
}
