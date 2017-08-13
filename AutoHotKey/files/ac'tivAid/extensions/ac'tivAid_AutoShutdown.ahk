; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               AutoShutdown
; -----------------------------------------------------------------------------
; Prefix:             as_
; Version:            0.7
; Date:               2008-05-07
; Author:             Patrick Eder (skydive241@gmx.de), Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_AutoShutdown:
	Prefix = as
	%Prefix%_ScriptName    = AutoShutdown
	%Prefix%_ScriptVersion = 0.7
	%Prefix%_Author        = Patrick Eder, Wolfgang Reszel

	CustomHotkey_AutoShutdown = 1         ; automatisches benutzerdefinierbares Tastaturkürzel? (1 = ja)
	Hotkey_AutoShutdown       = #Q        ; Standard-Hotkey (WIN-Q)
	HotkeyPrefix_AutoShutdown =           ; Präfix, welches immer vor dem Tastaturkürzel gesetzt wird
													  ; in diesem Fall sorgt es dafür, dass das Tastaturkürzel durchgeschleift wird.
	CreateGuiID("AutoShutdownSchedule")
	CreateGuiID("AutoShutdownMain")

	IconFile_On_AutoShutdown = %A_WinDir%\system32\shell32.dll
	IconPos_On_AutoShutdown  = 113

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                        = %as_ScriptName% - Computer herunterfahren
		Description                     = Dialog zum Abmelden und Herunterfahren
		lng_as_SuddenDeath              = Tastaturkürzel für sofortiges Herunterfahren

		lng_as_Options                  = Folgende Möglichkeiten zum Herunterfahren stehen zur Verfügung
		lng_as_GroupBox                 = Optionen fürs Herunterfahren
		lng_as_Option1                  = Computer herunterfahren
		lng_as_Option2                  = Computer herunterfahren und ausschalten
		lng_as_Option3                  = Computer neu starten
		lng_as_Option4                  = Benutzer `"%A_UserName%`" abmelden
		lng_as_Option5                  = Standby-Modus
		lng_as_Option6                  = Ruhezustand
		lng_as_QOption1                 = Soll der Computer heruntergefahren werden?
		lng_as_QOption2                 = Soll der Computer heruntergefahren und ausgeschaltet werden?
		lng_as_QOption3                 = Soll der Computer durchgestartet werden?
		lng_as_QOption4                 = Soll der Benutzer `"%A_UserName%`"%A_Space%abgemeldet werden?
		lng_as_QOption5                 = Soll der Computer in den Standby-Modus versetzt werden?
		lng_as_QOption6                 = Soll der Computer in den Ruhezustand versetzt werden?
		lng_as_TimeOut                  = Anzeigedauer Dialoge/Hinweise
		lng_as_Force                    = Aktion erzwingen (FORCE)
		lng_as_LogoffShutdown           = Herunterfahren/Abmelden
		lng_as_Silent                   = Keine zusätzliche Sicherheitsabfrage nach Ablaufen der Anzeigedauer
		lng_as_Test                     = Testmodus (gewählte Aktion wird nicht ausgeführt)
		lng_as_TestMessage              = Jetzt würde die folgende Aktion durchgeführt (Testmodus)
		lng_as_Title                    = Fenster (titel)
		lng_as_Text                     = mit dem Text
		lng_as_MoreOptions              = Programm- und fensterabhängiges Herunterfahren ...
		lng_as_MoreOptionsText          = Rechner automatisch herunterfahren, wenn ein ...
		lng_as_And_Or                   = Oder|Und|(Aus)||
		lng_as_Open_Close               = erscheint||verschwindet
		lng_as_Schedule                 = Zeitgesteuert herunterfahren:
		lng_as_ScheduleMonth            = Am
		lng_as_ScheduleMonthDay         = Tag des Monats (0 = letzter Tag, -1 = vorletzter Tag), um
		lng_as_Day1                     = So
		lng_as_Day2                     = Mo
		lng_as_Day3                     = Di
		lng_as_Day4                     = Mi
		lng_as_Day5                     = Do
		lng_as_Day6                     = Fr
		lng_as_Day7                     = Sa
		lng_as_DoShutdown               = Der Computer wird ausgeschaltet,`nsobald folgende Prozesse abgeschlossen wurden ...`n`n
		lng_as_Smooth                   = "Weicher" Fortschrittsbalken
		lng_as_OS                       = Betriebssystem beim nächsten Start
		lng_as_Once                     = Einmalig
		lng_as_TmpTimeout               = Aktion ausführen
		lng_as_CountDown                = Zähler:
		lng_as_ShutdownTime             = Zeitpunkt:
		lng_as_Cancel                   = Ab&brechen
		lng_as_Wait                     = W&arten
		lng_as_Automatic                = &Automatik
		lng_as_AlwaysExecuteOnShutDown  = Herunterfahren-Aktion (z.B. <OnShutDown> in UserHotkeys) auch beim Standby/Ruhezustand ausführen
		tooltip_as_Force                = Alle Programme werden zum Abbruch gezwungen.`nACHTUNG: Nicht gespeicherte Dateien und Einstellungen gehen verloren!
		tooltip_as_TimeOut              = Nach Ablauf der angegebenen Zeit werden Dialogfenster automatisch bestätigt.
		tooltip_as_Silent               = Nach Ablauf der Anzeigedauer wird keine zweite Sicherheitsabfrage mehr eingeblendet.
		tooltip_as_Test                 = Statt die gewünschte Aktion tatsächlich auszuführen, wird ein Hinweisfenster eingeblendet,`ndas Auskunft darüber gibt, welche Aktion ausgeführt würde.
	}
	Else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                        = %as_ScriptName% - Shutdown system
		Description                     = Dialog to shutdown or logoff the system
		lng_as_SuddenDeath              = Hotkey to shutdown system immediately

		lng_as_Options                  = The following options are available
		lng_as_GroupBox                 = Shutdown-options
		lng_as_Option1                  = Shutdown Computer
		lng_as_Option2                  = Shutdown and switchoff Computer
		lng_as_Option3                  = Restart Computer
		lng_as_Option4                  = Logoff%A_Space%`"%A_UserName%`"
		lng_as_Option5                  = Stand-by
		lng_as_Option6                  = Hibernate
		lng_as_QOption1                 = Should the Computer be shut down?
		lng_as_QOption2                 = Should the Computer be shut down and switched off?
		lng_as_QOption3                 = Should the Computer be restarted?
		lng_as_QOption4                 = Should `"%A_UserName%`"%A_Space%be logged off?
		lng_as_QOption5                 = Should the Computer be set to stand-by
		lng_as_QOption6                 = Should the Computer be set to hibernate-mode
		lng_as_TimeOut                  = Timeout Dialog/MessageBox
		lng_as_Force                    = FORCE action
		lng_as_Silent                   = No further messagebox after timeout
		lng_as_Test                     = Testmode (chosen action is not processed)
		lng_as_TestMessage              = The following action would be processed (Testmode)
		lng_as_LogoffShutdown           = Shutdown/Logoff
		lng_as_Silent                   = No additional safety queries after the countdown
		lng_as_Test                     = Testmode (selected action won't be executed)
		lng_as_TestMessage              = The following action would be executed (testmode)
		lng_as_Title                    = Window (title)
		lng_as_Text                     = contains
		lng_as_MoreOptions              = Program and window controlled shutdown ...
		lng_as_MoreOptionsText          = Automatically shutdown when a ...
		lng_as_And_Or                   = Or|And|(Off)||
		lng_as_Open_Close               = appears||disappears
		lng_as_Schedule                 = Scheduled shutdown:
		lng_as_ScheduleMonth            = At
		lng_as_ScheduleMonthDay         = Day of month (0 = last Day, -1 = day before last), at
		lng_as_Day1                     = Su
		lng_as_Day2                     = Mo
		lng_as_Day3                     = Tu
		lng_as_Day4                     = We
		lng_as_Day5                     = Th
		lng_as_Day6                     = Fr
		lng_as_Day7                     = Sa
		lng_as_DoShutdown               = The computer will be turned off`nafter finishing the following processes ...`n`n
		lng_as_Smooth                   = "Smooth" progress bar
		lng_as_Cancel                   = &Cancel
		lng_as_Wait                     = W&ait
		lng_as_Automatic                = &Automatic
		lng_as_OS                       = Operating system for the next restart
		lng_as_Once                     = Once
		lng_as_TmpTimeout               = Action
		lng_as_CountDown                = Countdown:
		lng_as_ShutdownTime             = Time:

		lng_as_AlwaysExecuteOnShutDown  = Execute shutdown-actions (eg. <OnShutDown> in UserHotkeys) also on Standby/Hibernate
	}

	IniRead, as_Default, %ConfigFile%, %as_ScriptName%, DefaultButton, 2
	as_Default := func_LimitValue(as_Default,"1-6")
	IniRead, as_TimeOut, %ConfigFile%, %as_ScriptName%, TimeOut, 30
	IniRead, as_Test, %ConfigFile%, %as_ScriptName%, Test, 0
	IniRead, as_Force, %ConfigFile%, %as_ScriptName%, Force, 0
	IniRead, as_Silent, %ConfigFile%, %as_ScriptName%, Silent, 0
	; zusätzliches Hotkey aus der INI-Datei einlesen
	func_HotkeyRead( "as_SuddenDeath", ConfigFile, as_ScriptName, "SuddenDeath", "as_sub_SuddenDeath", "^#+Q" )

	Loop,10
	{
		IniRead, as_Bool%A_Index%, %ConfigFile%, %as_ScriptName%, Bool%A_Index%, 3
		If A_Index = 1
			as_Bool%A_Index% =
		IniRead, as_Title%A_Index%, %ConfigFile%, %as_ScriptName%, Title%A_Index%, %A_Space%
		IniRead, as_Text%A_Index%, %ConfigFile%, %as_ScriptName%, Text%A_Index%, %A_Space%
		IniRead, as_Condition%A_Index%, %ConfigFile%, %as_ScriptName%, Condition%A_Index%, 1
		as_Bool%A_Index%_tmp := as_Bool%A_Index%
		as_Title%A_Index%_tmp := as_Title%A_Index%
		as_Text%A_Index%_tmp := as_Text%A_Index%
		as_Condition%A_Index%_tmp := as_Condition%A_Index%
	}

	Loop, 7
	{
		IniRead, as_Day%A_Index%, %ConfigFile%, %as_ScriptName%, ScheduleDay%A_Index%, 0
	}
	IniRead, as_ScheduleTime1, %ConfigFile%, %as_ScriptName%, ScheduleTime1, 200001010100
	IniRead, as_ScheduleTime2, %ConfigFile%, %as_ScriptName%, ScheduleTime2, 200001010200
	IniRead, as_Monthly, %ConfigFile%, %as_ScriptName%, Monthly, 0
	IniRead, as_MonthlyDay, %ConfigFile%, %as_ScriptName%, MonthlyDay, 1
	IniRead, as_ScheduleTime3, %ConfigFile%, %as_ScriptName%, ScheduleTime3, 200001010300
	IniRead, as_EnableMoreOptions, %ConfigFile%, %as_ScriptName%, EnableMoreOptions, 200001010300
	IniRead, as_Smooth, %ConfigFile%, %as_ScriptName%, SmoothProgressBar, 0
	IniRead, as_Once, %ConfigFile%, %as_ScriptName%, ScheduleOnce, 0
	RegisterAdditionalSetting("as","Test",0)
	RegisterAdditionalSetting("as","AlwaysExecuteOnShutDown",0)
	as_bToggleWait = 0
	as_Shutdown%as_Default% = 1
Return

SettingsGui_AutoShutdown:
	func_HotkeyAddGuiControl(lng_as_SuddenDeath, "as_SuddenDeath", "xs+10 y+10 w210")
	Gui, Add, GroupBox, xs+10 y+1 w550 h88
	Gui, Add, Text, xp+10 yp+10, %lng_as_Options%:
	Gui, Add, Radio, -Wrap xs+20 ys+90 gsub_CheckIfSettingsChanged vas_Shutdown1, %lng_as_Option1%
	Gui, Add, Radio, -Wrap y+5 gsub_CheckIfSettingsChanged vas_Shutdown2, %lng_as_Option2%
	Gui, Add, Radio, -Wrap y+5 gsub_CheckIfSettingsChanged vas_Shutdown3, %lng_as_Option3%
	Gui, Add, Radio, -Wrap xs+280 ys+90 gsub_CheckIfSettingsChanged vas_Shutdown4, %lng_as_Option4%
	Gui, Add, Radio, -Wrap y+5 gsub_CheckIfSettingsChanged vas_Shutdown5, %lng_as_Option5%
	Gui, Add, Radio, -Wrap y+5 gsub_CheckIfSettingsChanged vas_Shutdown6, %lng_as_Option6%
	GuiControl,,as_Shutdown%as_Default%, 1
	Gui, Add, Checkbox, gsub_CheckIfSettingsChanged XS+10 YP+26 vas_Force -Wrap Checked%as_Force%, %lng_as_Force%
	Gui, Add, Checkbox, gsub_CheckIfSettingsChanged XP Y+5 vas_Silent -Wrap Checked%as_Silent%, %lng_as_Silent%
	Gui, Add, Text, xp+300 yp-17 Right w170, %lng_as_TimeOut%
	Gui, Add, ComboBox, x+5 yp-3 w50 vas_TimeOut gsub_CheckIfSettingsChanged, 1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|30|60
	GuiControl, ChooseString, as_TimeOut, %as_TimeOut%
	If ErrorLevel = 1
	{
		GuiControl, , as_TimeOut, %as_TimeOut%
		GuiControl, ChooseString, as_TimeOut, %as_TimeOut%
	}
	Gui, Add, Text, xp+55 yp+3, s.

	Gui, Add, GroupBox, xs+10 y+25 w550 h62

	Gui, Add, Text, xs+20 yp+15, %lng_as_Schedule%
	Loop, 5
	{
		as_Index := A_Index+1
		Gui, Add, CheckBox, % "-Wrap x+5 vas_Day" as_Index "_tmp gas_sub_ScheduleChange Checked" as_Day%as_Index%, % lng_as_Day%as_Index%
	}
	Gui, Add, DateTime, 1 x+5 yp-4 w60 gsub_CheckIfSettingsChanged vas_ScheduleTime1_tmp Choose%as_ScheduleTime1%, HH:mm
	Gui, Add, CheckBox, -Wrap x+10 yp+4 vas_Day7_tmp gas_sub_ScheduleChange Checked%as_Day7%, %lng_as_Day7%
	Gui, Add, CheckBox, -Wrap x+5 vas_Day1_tmp gas_sub_ScheduleChange Checked%as_Day1%, %lng_as_Day1%
	Gui, Add, DateTime, 1 x+5 yp-4 w60 gsub_CheckIfSettingsChanged vas_ScheduleTime2_tmp Choose%as_ScheduleTime2%, HH:mm
	Gui, Add, CheckBox, -Wrap y+7 xs+20 vas_Monthly_tmp gas_sub_ScheduleChange Checked%as_Monthly%, %lng_as_ScheduleMonth%
	Gui, Add, Edit, x+5 yp-4 w40 vas_MonthlyDay_tmp gsub_CheckIfSettingsChanged, %as_MonthlyDay%
	Gui, Add, UpDown, Range-3-28, %as_MonthlyDay%
	Gui, Add, Text, x+2 yp+4, . %lng_as_ScheduleMonthDay%
	Gui, Add, DateTime, 1 x+5 yp-4 w60 gsub_CheckIfSettingsChanged vas_ScheduleTime3_tmp Choose%as_ScheduleTime3%, HH:mm
	Gui, Add, CheckBox, -Wrap x+50 yp+4 vas_Once Checked%as_Once% gsub_CheckIfSettingsChanged, %lng_as_Once%
	Gui, Add, Button, -Wrap xs+10 y+10 gas_sub_MoreOptions, %lng_as_MoreOptions%
	Gui, Add, Checkbox, gsub_CheckIfSettingsChanged X+5 yp+5 vas_EnableMoreOptions -Wrap Checked%as_EnableMoreOptions%, %lng_activated%
	Gui, Add, Checkbox, gsub_CheckIfSettingsChanged X+80 yp vas_Smooth -Wrap Checked%as_Smooth%, %lng_as_Smooth%
;   Gui, Add, Checkbox, gsub_CheckIfSettingsChanged xs+310 ys+290 vas_Test -Wrap Checked%as_Test%, %lng_as_Test%
	Gosub, as_sub_ScheduleChange
	Menu, AdditionalSettingsMenu, UseErrorLevel
Return

as_sub_ScheduleChange:
	Gosub, sub_CheckIfSettingsChanged
	Loop, 7
	{
		GuiControlGet, as_Tmp%A_Index%,,as_Day%A_Index%_tmp
	}
	If (as_Tmp2 = 0 AND as_Tmp3 = 0 AND as_Tmp4 = 0 AND as_Tmp5 = 0 AND as_Tmp6 = 0)
		GuiControl, Disable, as_ScheduleTime1_tmp
	Else
		GuiControl, Enable, as_ScheduleTime1_tmp

	If (as_Tmp1 = 0 AND as_Tmp7 = 0)
		GuiControl, Disable, as_ScheduleTime2_tmp
	Else
		GuiControl, Enable, as_ScheduleTime2_tmp

	GuiControlGet, as_Tmp,,as_Monthly_tmp
	If as_Tmp = 0
	{
		GuiControl, Disable, as_ScheduleTime3_tmp
		GuiControl, Disable, as_MonthlyDay_tmp
	}
	Else
	{
		GuiControl, Enable, as_ScheduleTime3_tmp
		GuiControl, Enable, as_MonthlyDay_tmp
	}


Return

as_sub_MoreOptions:
	Gui, %GuiID_activAid%:+Disabled
	GuiDefault("AutoShutdownSchedule", "+Owner" GuiID_activAid)
	Gosub, GuiDefaultFont
	Gui, Add, Text, , %lng_as_MoreOptionsText%
	Loop,10
	{
		as_Disabled =
		If A_Index > 1
		{
			Gui, Add, DropDownList, x10 y+4 w50 AltSubmit gas_sub_ChangeBool vas_Bool%A_Index%_tmp, %lng_as_And_Or%
			Gui, Add, Text, x70 yp+3, %lng_as_Title%
			GuiControl, Choose, as_Bool%A_Index%_tmp, % as_Bool%A_Index%
			if (as_Bool%A_Index% = 3 OR as_Bool%A_Index% = "")
				as_Disabled = Disabled
		}
		Else
			Gui, Add, Text, x70 y+15, %lng_as_Title%
		Gui, Add, Edit, R1 x+5 yp-3 %as_Disabled% w180 vas_Title%A_Index%_tmp, % as_Title%A_Index%
		Gui, Add, Text, x+5 yp+3, %lng_as_Text%
		Gui, Add, Edit, R1 x+10 yp-3 %as_Disabled% w180 vas_Text%A_Index%_tmp, % as_Text%A_Index%
		Gui, Add, Button, -Wrap x+5 %as_Disabled% h22 w22 vas_%A_Index%_tmp gas_sub_GetWindowTitle, +
		Gui, Add, DropDownList, x+5 %as_Disabled% w100 AltSubmit vas_Condition%A_Index%_tmp, %lng_as_Open_Close%
		GuiControl, Choose, as_Condition%A_Index%_tmp, % as_Condition%A_Index%
	}
	Gui, Add, Button, -Wrap X260 W80 Default gas_sub_ScheduleOK, %lng_OK%
	Gui, Add, Button, -Wrap X+5 W80 gAutoShutdownScheduleGuiClose, %lng_cancel%

	Gui, Show, w710, %as_ScriptName% - %lng_as_MoreOptions%
Return

as_sub_ChangeBool:
	StringReplace, as_Control, A_GuiControl, as_Bool
	GuiControlGet, as_Bool%as_Control%
	If as_Bool%as_Control% = 3
	{
		GuiControl, Disable, as_Text%as_Control%
		GuiControl, Disable, as_Title%as_Control%
		GuiControl, Disable, as_Condition%as_Control%
		GuiControl, Disable, as_%as_Control%
	}
	Else
	{
		GuiControl, Enable, as_Text%as_Control%
		GuiControl, Enable, as_Title%as_Control%
		GuiControl, Enable, as_Condition%as_Control%
		GuiControl, Enable, as_%as_Control%
	}
Return

AutoShutdownScheduleGuiClose:
AutoShutdownScheduleGuiEscape:
	Gui, %GuiID_activAid%:-Disabled
	Gui, %GuiID_AutoShutdownSchedule%:Destroy
Return

as_sub_ScheduleOK:
	Gui, Submit, Nohide
	Gosub, AutoShutdownScheduleGuiClose
	func_SettingsChanged( as_ScriptName )
Return

as_sub_GetWindowTitle:
	StringReplace, as_Control, A_Guicontrol, as_
	WinSet,Bottom,, %ScriptTitle%
	WinSet,Bottom,, %as_ScriptName% - %lng_as_MoreOptions%
	SplashImage,,b1 cwFFFF80 FS9 WS700, %lng_AddApps%
	Gui,%GuiID_AutoShutdownSchedule%:+Disabled
	Input,as_GetKey,,{Enter}{ESC}
	StringReplace,as_GetKey,ErrorLevel,Endkey:
	SplashImage, Off
	Gui,%GuiID_AutoShutdownSchedule%:-Disabled
	WinGetTitle, as_GetTitle, A
	WinGetText, as_GetText, A
	If as_Getkey = Enter
	{
		;StringLeft, as_GetTitle, as_GetTitle,35
		IfInString, as_GetText, `n
			StringLeft, as_GetText, as_GetText, % InStr(as_GetText,"`n")-1
		IfInString, as_GetText, `r
			StringLeft, as_GetText, as_GetText, % InStr(as_GetText,"`r")-1

		if as_GetText <>
			GuiControl, %GuiID_AutoShutdownSchedule%:,as_Text%as_Control%,%as_GetText%

		GuiControl %GuiID_AutoShutdownSchedule%:,as_Title%as_Control%,%as_GetTitle%
	}
	Gui,%GuiID_AutoShutdownSchedule%:Show
	WinSet, Top, , %ScriptTitle%
	WinSet, Top,, %as_ScriptName% - %lng_as_MoreOptions%
Return

SaveSettings_AutoShutdown:
	 if (as_Shutdown1 = 1)
		  as_Default = 1
	 else if (as_Shutdown2 = 1)
		  as_Default = 2
	 else if (as_Shutdown3 = 1)
		  as_Default = 3
	 else if (as_Shutdown4 = 1)
		  as_Default = 4
	 else if (as_Shutdown5 = 1)
		  as_Default = 5
	 else if (as_Shutdown6 = 1)
		  as_Default = 6
	 else
		  as_Default = 1

	 func_HotkeyWrite("as_SuddenDeath", ConfigFile, as_Scriptname, "SuddenDeath")
	 IniWrite, %as_Default%, %ConfigFile%, %as_ScriptName%, DefaultButton
	 IniWrite, %as_TimeOut%, %ConfigFile%, %as_ScriptName%, TimeOut
	 IniWrite, %as_Force%, %ConfigFile%, %as_ScriptName%, Force
	 IniWrite, %as_Test%, %ConfigFile%, %as_ScriptName%, Test
	 IniWrite, %as_Silent%, %ConfigFile%, %as_ScriptName%, Silent

	Loop,10
	{
		as_Bool%A_Index% := as_Bool%A_Index%_tmp
		as_Title%A_Index% := as_Title%A_Index%_tmp
		as_Text%A_Index% := as_Text%A_Index%_tmp
		as_Condition%A_Index% := as_Condition%A_Index%_tmp
		IniWrite, % as_Bool%A_Index%, %ConfigFile%, %as_ScriptName%, Bool%A_Index%
		IniWrite, % as_Title%A_Index%, %ConfigFile%, %as_ScriptName%, Title%A_Index%
		IniWrite, % as_Text%A_Index%, %ConfigFile%, %as_ScriptName%, Text%A_Index%
		IniWrite, % as_Condition%A_Index%, %ConfigFile%, %as_ScriptName%, Condition%A_Index%
	}

	Loop, 7
	{
		as_Day%A_Index% := as_Day%A_Index%_tmp
		IniWrite, % as_Day%A_Index%, %ConfigFile%, %as_ScriptName%, ScheduleDay%A_Index%
	}
	as_ScheduleTime1 = %as_ScheduleTime1_tmp%
	as_ScheduleTime2 = %as_ScheduleTime2_tmp%
	as_ScheduleTime3 = %as_ScheduleTime3_tmp%
	as_Monthly = %as_Monthly_tmp%
	as_MonthlyDay = %as_MonthlyDay_tmp%
	IniWrite, %as_ScheduleTime1%, %ConfigFile%, %as_ScriptName%, ScheduleTime1
	IniWrite, %as_ScheduleTime2%, %ConfigFile%, %as_ScriptName%, ScheduleTime2
	IniWrite, %as_Monthly%, %ConfigFile%, %as_ScriptName%, Monthly
	If as_MonthlyDay > 28
		as_MonthlyDay = 0
	IniWrite, %as_MonthlyDay%, %ConfigFile%, %as_ScriptName%, MonthlyDay
	IniWrite, %as_ScheduleTime3%, %ConfigFile%, %as_ScriptName%, ScheduleTime3
	IniWrite, %as_EnableMoreOptions%, %ConfigFile%, %as_ScriptName%, EnableMoreOptions
	IniWrite, %as_Smooth%, %ConfigFile%, %as_ScriptName%, SmoothProgressBar
	IniWrite, %as_Once%, %ConfigFile%, %as_ScriptName%, ScheduleOnce

;    Reload = 1
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_AutoShutdown:
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_AutoShutdown:
	func_HotkeyEnable("as_SuddenDeath")
	func_HotkeyEnable("as_AutoShutdown")
	SetTimer, as_tim_ConditionalShutdown, 500
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern der Einstellungen aufgerufen
DoDisable_AutoShutdown:
	func_HotkeyDisable("as_SuddenDeath")
	func_HotkeyDisable("as_AutoShutdown")
	SetTimer, as_tim_ConditionalShutdown, Off
Return

; wird aufgerufen, wenn der Anwender die Erweiterung auf die Standard-Einstellungen zurücksetzt
DefaultSettings_AutoShutdown:
Return

Update_AutoShutdown:
	IniRead, as_TakeScreenShot, %ConfigFile%, %as_ScriptName%, TakeScreenShot
	If as_TakeScreenShot <> ERROR
	{
		IniDelete, %ConfigFile%, %as_ScriptName%, TakeScreenShot
		scr_TakeScreenShotOnShutDown := as_TakeScreenShot
		If (IsLabel("OnShutDown_ScreenShots"))
			IniWrite, %as_TakeScreenShot%, %ConfigFile%, %scr_ScriptName%, TakeScreenShotOnShutDown
	}
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_AutoShutdown:
	Gosub, as_main_AutoShutdown
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

as_main_AutoShutdown:
	 if as_GuiVisible = 1
	 {
		 as_bToggleWait = 1
		 Gosub, as_sub_Auto
		 Return
	 }
	 as_GuiVisible = 1
	 as_nButton = 6
	 as_nHeight := as_nButton*20+20           ; pro Radio-Button 20 Pixel Platz reservieren
	 as_nInnerWidth = 280
	 IniRead, as_Force, %ConfigFile%, %as_ScriptName%, Force, 0

	 as_AutoShutdownMainID := GuiDefault("AutoShutdownMain")
	 Gosub, sub_BigIcon

	 as_OperatingSystems =
	 as_LoopCont = -1
	 IniRead, as_DefOperatingSystem, %SystemDrive%\boot.ini, boot loader, default
	 Loop, Read, %SystemDrive%\boot.ini
	 {
		If A_LoopReadline =
			continue
		If A_LoopReadline = [operating systems]
		{
			as_LoopCont = 0
			continue
		}
		If as_LoopCont > -1
		{
			as_LoopCont++
			StringSplit, as_LoopField, A_LoopReadline, =
			as_IniVar[%as_LoopCont%] = %as_LoopField1%
			as_OperatingSystems = %as_OperatingSystems%%as_LoopField2%|
			If as_DefOperatingSystem = %as_LoopField1%
				as_SelOperatingSystem = %as_LoopCont%
		}
	 }

	 If as_LoopCont = 1
	 {
		 Gui, Add, Groupbox, Section X10 W%as_nInnerWidth% H50, %lng_as_OS%
		 Gui, Add, DropDownList, xs+10 ys+20 w260 vas_SelOperatingSystem AltSubmit, %as_OperatingSystems%
		 GuiControl,Choose, as_SelOperatingSystem, %as_SelOperatingSystem%
	 }

	 Gui, Add, GroupBox, Section X10 W%as_nInnerWidth% H%as_nHeight%, %lng_as_GroupBox%
	 Gui, Add, Radio, -Wrap XS+10 YS+20 vas_Shutdown1 gas_Check_DblClk, %lng_as_Option1%
	 Gui, Add, Radio, -Wrap vas_Shutdown2 gas_Check_DblClk, %lng_as_Option2%
	 Gui, Add, Radio, -Wrap vas_Shutdown3 gas_Check_DblClk, %lng_as_Option3%
	 Gui, Add, Radio, -Wrap vas_Shutdown4 gas_Check_DblClk, %lng_as_Option4%
	 Gui, Add, Radio, -Wrap vas_Shutdown5 gas_Check_DblClk, %lng_as_Option5%
	 Gui, Add, Radio, -Wrap vas_Shutdown6 gas_Check_DblClk, %lng_as_Option6%

	 GuiControl,,as_Shutdown%as_Default%, 1
	 GuiControl,Focus, as_Shutdown%as_Default%

	 Gui, Add, Checkbox, XS+10 YP+30 vas_Force -Wrap Checked%as_Force%, %lng_as_Force%

	 as_ShutdownTime = %A_Now%
	 EnvAdd, as_ShutdownTime, %as_TimeOut%, Seconds
	 as_CountDown := func_GetDateFromSeconds(as_TimeOut-Round(as_elapsed_time/1000))
	 as_TmpTimeOut := as_TimeOut

	 Gui, Add, GroupBox, Section X10 y+10 W%as_nInnerWidth% H50, %lng_as_TmpTimeout%
	 Gui, Add, Text, XS+10 YS+24, %lng_as_CountDown%
	 Gui, Add, DateTime, X+5 yp-4 vas_CountDown gas_tim_RefreshTimeFields Disabled Choose%as_CountDown% w80, Time
	 Gui, Add, Text, X+10 yp+4, %lng_as_ShutdownTime%
	 Gui, Add, DateTime, X+5 yp-4 vas_ShutdownTime gas_tim_RefreshTimeFields Disabled Choose%as_ShutdownTime% w80, Time

	 If as_Smooth = 0
		Gui, Add, Progress, vas_Progress X10 YS+60 W%as_nInnerWidth% H20 c008000 -Smooth
	 Else
		Gui, Add, Progress, vas_Progress X10 YS+60 W%as_nInnerWidth% H20 c008000

	 Gui, Add, Button, Default X+-265 W80 YP+30 gas_sub_ButtonOK, &OK
	 Gui, Add, Button, XP+85 WP gAutoShutdownMainGuiClose, %lng_as_Cancel%
	 Gui, Add, Button, XP+85 WP vas_Auto gas_sub_Auto, %lng_as_Wait%

	 Gui, +AlwaysOnTop

	 Gui, Show, %as_DontActivate%, %lng_as_LogoffShutdown%

	 as_start_time := A_TickCount
	 as_bToggleWait = 0
	 SetTimer, as_ProgressTimer, 150
Return

as_Check_DblClk:
	if as_bToggleWait = 0
		Gosub, as_sub_Auto
	IfInString, A_GuiControlEvent, DoubleClick
		Gosub, as_sub_ButtonOK
Return

as_tim_RefreshTimeFields:
	GuiControlGet, as_TimeFieldFocus, %GuiID_AutoShutdownMain%:FocusV
	If as_TimeFieldFocus NOT IN as_CountDown,as_ShutdownTime
		as_TimeFieldFocus := as_LastTimeFieldFocus
	If (as_TimeFieldFocus = "as_CountDown")
	{
		GuiControlGet, as_CountDown, %GuiID_AutoShutdownMain%:
		as_CountDown := func_GetSecondsFromDate(as_CountDown)
		as_ShutdownTime = %A_Now%
		EnvAdd, as_ShutdownTime, %as_CountDown%, Seconds
		GuiControl, %GuiID_AutoShutdownMain%:, as_ShutdownTime, %as_ShutdownTime%
		as_LastTimeFieldFocus := as_TimeFieldFocus
	}
	Else If (as_TimeFieldFocus = "as_ShutdownTime")
	{
		GuiControlGet, as_ShutdownTime, %GuiID_AutoShutdownMain%:
		as_CountDown = %as_ShutdownTime%
		EnvSub, as_CountDown, %A_Now%, Seconds
		If as_CountDown < 0
			GuiControl, %GuiID_AutoShutdownMain%:, as_ShutdownTime, %A_Now%
		as_CountDown := func_GetDateFromSeconds( as_CountDown )
		GuiControl, %GuiID_AutoShutdownMain%:, as_CountDown, %as_CountDown%
		as_LastTimeFieldFocus := as_TimeFieldFocus
	}
Return

as_sub_Auto:
	 SetTimer, as_ProgressTimer, Off
	 as_bToggleWait := !as_bToggleWait
	 as_start_time := A_TickCount
	 if (as_bToggleWait = 0)
	 {
		  GuiControlGet, as_CountDown, %GuiID_AutoShutdownMain%:
		  as_TmpTimeOut := func_GetSecondsFromDate(as_CountDown)
		  GuiControl, %GuiID_AutoShutdownMain%:, as_Auto, %lng_as_Wait%
		  SetTimer, as_ProgressTimer, On
		  GuiControl,  %GuiID_AutoShutdownMain%:Disable,as_CountDown
		  GuiControl,  %GuiID_AutoShutdownMain%:Disable,as_ShutdownTime
		  SetTimer, as_tim_RefreshTimeFields, Off
	 }
	 else
	 {
		  GuiControl, %GuiID_AutoShutdownMain%:, as_Auto, %lng_as_Automatic%
		  Gosub, as_ProgressTimer
		  GuiControl,  %GuiID_AutoShutdownMain%:Enable,as_CountDown
		  GuiControl,  %GuiID_AutoShutdownMain%:Enable,as_ShutdownTime
		  as_LastTimeFieldFocus = as_CountDown
		  SetTimer, as_tim_RefreshTimeFields, 1000
	 }
Return

as_ProgressTimer:
	 as_elapsed_time := A_TickCount - as_start_time
	 as_prog := 100-as_elapsed_time/as_TmpTimeout/10
	 if (as_prog <= 0)
		  Gosub as_sub_OK
	 else if (as_prog < 33)
		  GuiControl, %GuiID_AutoShutdownMain%:+cff0000, as_Progress
	 else if (as_prog < 66)
		  GuiControl, %GuiID_AutoShutdownMain%:+cffff00, as_Progress
	 else
		  GuiControl, %GuiID_AutoShutdownMain%:+c008000, as_Progress

	 GuiControl, %GuiID_AutoShutdownMain%:, as_Progress, %as_prog%
	 as_CountDown := func_GetDateFromSeconds(as_TmpTimeOut-Round(as_elapsed_time/1000))

	 If (as_CountDown <> as_LastCountDown)
	 {
		  GuiControl, %GuiID_AutoShutdownMain%:, as_CountDown, %as_CountDown%
	 }

	 WinGet, as_MinMax, MinMax, ahk_id %as_AutoShutdownMainID%
	 If as_MinMax = -1
	 {
		  FormatTime, as_CountDownFormatted, %as_CountDown%, HH:mm:ss
		  WinSetTitle, ahk_id %as_AutoShutdownMainID%,, %as_CountDownFormatted% - %lng_as_LogoffShutdown%
	 }
	 Else If (as_MinMax <> as_LastMinMax)
		  WinSetTitle, ahk_id %as_AutoShutdownMainID%,, %lng_as_LogoffShutdown%

	 as_LastMinMax := as_MinMax

	 as_LastCountDown := as_CountDown
Return

as_sub_OK:
	 Gui, %GuiID_AutoShutdownMain%:Submit, NoHide
	 SetTimer, as_ProgressTimer, Off
	 GuiControl,%GuiID_AutoShutdownMain%:, as_Progress, 0

	 If (as_Test <> 1 AND as_SelOperatingSystem <> "")
		 IniWrite, % as_IniVar[%as_SelOperatingSystem%], %SystemDrive%\boot.ini, boot loader, default

	 as_Shutdown = 0
	 as_caption = Shutdown%A_Space%%A_ComputerName%
	 if (as_Shutdown1 = 1)
	 {
		  as_MBText = 1
		  as_text := lng_as_QOption1
		  as_Shutdown = 1
	 }
	 else if (as_Shutdown2 = 1)
	 {
		  as_MBText = 2
		  as_text := lng_as_QOption2
		  as_Shutdown = 9
	 }
	 else if (as_Shutdown3 = 1)
	 {
		  as_MBText = 3
		  StringReplace, as_caption, as_caption, Shutdown, Restart
		  as_text := lng_as_QOption3
		  as_Shutdown = 2
	 }
	 else if (as_Shutdown4 = 1)
	 {
		  as_MBText = 4
		  StringReplace, as_caption, as_caption, Shutdown, LogOff
		  StringReplace, as_caption, as_caption, %A_ComputerName%, %A_UserName%
		  as_text := lng_as_QOption4
	 }
	 else if (as_Shutdown5 = 1)
	 {
		  as_MBText = 5
		  StringReplace, as_caption, as_caption, Shutdown, LogOff
		  StringReplace, as_caption, as_caption, %A_ComputerName%, %A_UserName%
		  as_text := lng_as_QOption5
	 }
	 else if (as_Shutdown6 = 1)
	 {
		  as_MBText = 6
		  StringReplace, as_caption, as_caption, Shutdown, LogOff
		  StringReplace, as_caption, as_caption, %A_ComputerName%, %A_UserName%
		  as_text := lng_as_QOption6
	 }

	 If (as_Silent = 0)
	 {
		  Gui, %GuiID_AutoShutdownMain%:Destroy
		  MsgBox, 4132, %as_caption%, %as_text%, %as_Timeout%
		  IfMsgBox, No
		  Goto, AutoShutdownMainGuiClose
	 }
	 Gosub, as_sub_DoShutdown
Return

as_sub_ButtonOK:
	 as_Silent = 1
	 Gosub, as_sub_OK
Return

as_sub_SuddenDeath:
	 Gui, %GuiID_AutoShutdownMain%:SubMit
	 as_Shutdown%as_Default% = 1
	 Gosub, as_sub_OK
Return

as_sub_DoShutdown:
	 Gui, %GuiID_AutoShutdownMain%:SubMit
	 as_Text := lng_as_Option%as_MBText%
	 If (as_Force = 1)
	 {
		 as_Text = %as_Text%%A_Space%(FORCE)
		 as_Shutdown += 4
	 }
	 If (as_Test = 1)
	 {
		  MsgBox, 64, %as_ScriptName%, %lng_as_TestMessage% (%as_Shutdown%):`n`n%as_Text%, %as_Timeout%
	 }
	 else
	 {
		 if (as_Shutdown = 1 OR as_Shutdown = 9 OR as_Shutdown = 5 OR as_Shutdown = 14 OR as_AlwaysExecuteOnShutDown = 1)
		 {
			Gosub, as_sub_CheckShutDown
			If as_ShutDownProcesses <>
				SplashImage,,b1 cwFFFFc0 FS9 WS700 w400, %lng_as_DoShutdown%%as_ShutDownProcesses%
			Suspend, On
			Gosub, as_sub_OnShutDown
			Suspend, Off
			SplashImage, Off
		 }

		 If as_MBText < 5
			 Shutdown, as_Shutdown
		 Else if as_MBText = 5
			 DllCall("powrprof.dll\SetSuspendState","Int",0,"Int",0,"Int",0)
		 Else if as_MBText = 6
			 DllCall("powrprof.dll\SetSuspendState","Int",1,"Int",0,"Int",0)
	 }
	 Gosub AutoShutdownMainGuiClose
Return

AutoShutdownMainGuiClose:
AutoShutdownMainGuiEscape:
	 SetTimer, as_ProgressTimer, Off
	 Gui, %GuiID_AutoShutdownMain%:SubMit
	 Gui, %GuiID_AutoShutdownMain%:Destroy
	 as_GuiVisible =
	 as_DontActivate =
Return

as_tim_ConditionalShutdown:
	Loop, 7
	{
		If (A_WDay = A_Index AND as_Day%A_Index% = 1)
		{
			If (A_Index = 1 OR A_Index = 7)
			{
				If (func_StrMid(A_Now,9,4) = func_StrMid(as_ScheduleTime2,9,4) AND func_StrMid(A_Now,9,4) <> as_LastSchedule)
				{
					as_LastSchedule := func_StrMid(as_ScheduleTime2,9,4)
					as_DontActivate = NA NoActivate
					Gosub, as_main_AutoShutdown
					If as_Once = 1
					{
						as_Day%A_Index% = 0
						IniWrite, % as_Day%A_Index%, %ConfigFile%, %as_ScriptName%, ScheduleDay%A_Index%
					}
					Return
				}
			}
			Else
			{
				If (func_StrMid(A_Now,9,4) = func_StrMid(as_ScheduleTime1,9,4) AND func_StrMid(A_Now,9,4) <> as_LastSchedule)
				{
					as_LastSchedule := func_StrMid(as_ScheduleTime1,9,4)
					as_DontActivate = NA NoActivate
					Gosub, as_main_AutoShutdown
					If as_Once = 1
					{
						as_Day%A_Index% = 0
						IniWrite, % as_Day%A_Index%, %ConfigFile%, %as_ScriptName%, ScheduleDay%A_Index%
					}
					Return
				}
			}
		}
	}

	If (as_Monthly = 1)
	{
		as_ThisMonth = %A_Now%
		If as_MonthlyDay < 1
			as_ThisMonth += 31,days
		as_ThisMonth := func_StrLeft(as_ThisMonth,6) "01" func_StrRight(as_ThisMonth, 6)
		EnvAdd, as_ThisMonth, % as_MonthlyDay - 1, Days

		as_NextDay := func_StrMid(as_ThisMonth,7,2)

		If A_DD = %as_NextDay%
		{
			If (func_StrMid(A_Now,9,4) = func_StrMid(as_ScheduleTime3,9,4) AND func_StrMid(A_Now,9,4) <> as_LastSchedule)
			{
				as_LastSchedule := func_StrMid(as_ScheduleTime3,9,4)
				as_DontActivate = NA NoActivate
				Gosub, as_main_AutoShutdown
				If as_Once = 1
				{
					as_Monthly = 0
					IniWrite, %as_Monthly%, %ConfigFile%, %as_ScriptName%, Monthly
				}
				Return
			}
		}
	}

	If as_EnableMoreOptions = 1
	{
		DetectHiddenWindows, On
		SetTitlematchmode, 2
		as_Result = 0
		Loop,10
		{
			If (as_Bool%A_Index% = 3 OR (as_Title%A_Index% ="" AND as_Text%A_Index% =""))
				continue


			If (as_Bool%A_Index% = 2 AND as_Result = 0)
				continue

			If (as_Bool%A_Index% = 1 AND as_Result = 1)
				break

			If as_Condition%A_Index% = 1
			{
				IfWinExist, % as_Title%A_Index% , % as_Text%A_Index%
					as_Result = 1
				Else
					as_Result = 0
			}
			Else
			{
				as_WinWasVisible := "as_" func_StrLeft(func_Hex(as_Title%A_Index%),16) func_StrRight(func_Hex(as_Title%A_Index% as_Text%A_Index%),16)
				If %as_WinWasVisible% <> 1
					IfWinExist, % as_Title%A_Index% , % as_Text%A_Index%
						%as_WinWasVisible% = 1

				If %as_WinWasVisible% = 1
				{
					IfWinNotExist, % as_Title%A_Index% , % as_Text%A_Index%
					{
						as_Result = 1
						%as_WinWasVisible% =
					}
					Else
						as_Result = 0
				}
			}
		}
		If (as_Result = 1 AND func_StrMid(A_Now,9,4) <> as_LastSchedule)
		{
			as_LastSchedule := func_StrMid(A_Now,9,4)
			as_DontActivate = NA NoActivate
			Goto, as_main_AutoShutdown
		}
	}
Return

as_sub_CheckShutDown:
	as_ShutDownProcesses =
	Loop
	{
		If Extension[%A_Index%] =
			break
		Function := Extension[%A_Index%]
		If ( IsLabel("CheckShutDown_" Function) )
		{
			Result =
			Gosub, CheckShutDown_%Function%
			If Result = 1
				as_ShutDownProcesses = %as_ShutDownProcesses%, %Function%
		}
	}
	StringTrimLeft, as_ShutDownProcesses, as_ShutDownProcesses, 2
Return

as_sub_OnShutDown:
	Loop
	{
		If Extension[%A_Index%] =
			break
		Function := Extension[%A_Index%]
		If ( IsLabel("OnShutDown_" Function) )
			Gosub, OnShutDown_%Function%
	}
Return

