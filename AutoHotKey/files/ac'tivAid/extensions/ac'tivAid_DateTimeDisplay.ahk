; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               DateTimeDisplay
; -----------------------------------------------------------------------------
; Prefix:             dtd_
; Version:            0.2
; Date:               2007-11-21
; Author:             Michael Telgkamp
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_DateTimeDisplay:
	Prefix = dtd
	%Prefix%_ScriptName    = DateTimeDisplay
	%Prefix%_ScriptVersion = 0.2
	%Prefix%_Author        = Michael Telgkamp

	CustomHotkey_DateTimeDisplay = 1
	Hotkey_DateTimeDisplay       = #!d
	HotkeyPrefix_DateTimeDisplay =

	IconFile_On_DateTimeDisplay = %A_WinDir%\system32\timedate.cpl
	IconPos_On_DateTimeDisplay  = 1

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %dtd_ScriptName% - Zeigt Datum und Uhrzeit an
		Description                   = Zeigt ein Fenster mit Datum und Uhrzeit an
		lng_dtd_DateFormat            = Datumsformat
		lng_dtd_TimeFormat            = Zeitformat
		lng_dtd_BackgroundColor       = Hintergrundfarbe:
		lng_dtd_FontColor             = Schriftfarbe:
		lng_dtd_Fontsize              = Schriftgröße:
		lng_dtd_Transparency          = Transparenz:
		lng_dtd_TimeOut               = Anzeigedauer (s):
		lng_dtd_CustomSize            = Benutzerdefinierte Größe (Breite x Höhe, Leer = automatisch)
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %dtd_ScriptName% - Displays date and time
		Description                   = Displays a window with date and time
		lng_dtd_DateFormat            = Date format
		lng_dtd_TimeFormat            = Time format
		lng_dtd_BackgroundColor       = Background color:
		lng_dtd_FontColor             = Font color:
		lng_dtd_Fontsize              = Font size:
		lng_dtd_Transparency          = Transparency:
		lng_dtd_TimeOut               = Duration (s):
		lng_dtd_CustomSize            = Custom size (width x height, empty = automatic)
	}

	IniRead, dtd_DateFormat, %ConfigFile%, %dtd_ScriptName%, DateFormat, yyyy-MM-dd
	IniRead, dtd_TimeFormat, %ConfigFile%, %dtd_ScriptName%, TimeFormat, HH:mm:ss
	IniRead, dtd_TimeOut, %ConfigFile%, %dtd_ScriptName%, TimeOut, 5
	IniRead, dtd_BackgroundColor, %ConfigFile%, %dtd_ScriptName%, BackgroundColor, $1
	IniRead, dtd_FontColor, %ConfigFile%, %dtd_ScriptName%, FontColor, 000000
	IniRead, dtd_Transparency, %ConfigFile%, %dtd_ScriptName%, Transparency, 255
	IniRead, dtd_FontSize, %ConfigFile%, %dtd_ScriptName%, FontSize, 20
	IniRead, dtd_Width, %ConfigFile%, %dtd_ScriptName%, Width, %A_Space%
	IniRead, dtd_Height, %ConfigFile%, %dtd_ScriptName%, Height, %A_Space%
Return

SettingsGui_DateTimeDisplay:
	Gui, Add, Text, -Wrap R1 xs+10 y+10, %lng_dtd_DateFormat%:
	Gui, Add, Edit, -Wrap R1 xs+100 yp-3 w100 gsub_CheckIfSettingsChanged vdtd_DateFormat, %dtd_DateFormat%
	Gui, Add, Text, -Wrap R1 xs+10 y+10, %lng_dtd_TimeFormat%:
	Gui, Add, Edit, -Wrap R1 xs+100 yp-3 w100 gsub_CheckIfSettingsChanged vdtd_TimeFormat, %dtd_TimeFormat%
	func_ChooseColorAddGuiControl("dtd_BackgroundColor",lng_dtd_BackgroundColor,"y+10 xs+10 w85")
	func_ChooseColorAddGuiControl("dtd_FontColor",lng_dtd_FontColor,"y+10 xs+10 w85")
	Gui, Add, Text, xs+10 y+10 w85, %lng_dtd_FontSize%
	Gui, Add, ComboBox, x+5 yp-3 w50 vdtd_FontSize gsub_CheckIfSettingsChanged, 8|9|10|11|12|14|16|18|20|24|36|48|96|120
	If (!InStr("8|9|10|11|12|14|16|18|20|24|36|48|96|120|",dtd_FontSize "|"))
		GuiControl,, dtd_FontSize, %dtd_FontSize%
	GuiControl,ChooseString, dtd_FontSize, %dtd_FontSize%
	Gui, Add, Text, xs+10 y+6 w85, %lng_dtd_Transparency%
	Gui, Add, Slider, x+0 yp-5 w256 h30 vdtd_Transparency Range0-255 AltSubmit TickInterval8 ToolTip Line8 gsub_CheckIfSettingsChanged, %dtd_Transparency%
	Gui, Add, Text, xs+10 y+6 w85, %lng_dtd_TimeOut%
	Gui, Add, Slider, x+0 yp-5 w200 h30 vdtd_TimeOut Range1-20 AltSubmit TickInterval1 ToolTip Line1 gsub_CheckIfSettingsChanged, %dtd_TimeOut%
	Gui, Add, Text, xs+10 y+6, %lng_dtd_CustomSize%:
	Gui, Add, Edit, -Wrap R1 x+5 yp-3 w60 gsub_CheckIfSettingsChanged vdtd_Width, %dtd_Width%
	Gui, Add, Text, x+5 yp+3, x
	Gui, Add, Edit, -Wrap R1 x+5 yp-3 w60 gsub_CheckIfSettingsChanged vdtd_Height, %dtd_Height%
; Timezone display
;   Gui, Add, Text, xs+10 y+6 w85, %lng_dtd_TimeZone1%
;   Loop, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones,2
;   {
;    RegRead, dta_TimeZoneDisplay, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\%A_LoopRegName%,Display
;    if ErrorLevel
;    {
;      Continue
;    }
;    RegRead, dta_TimeZoneName, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\%A_LoopRegName%,Std
;    if ErrorLevel
;    {
;      Continue
;    }
;    dtd_timeZoneList := dta_TimeZoneDisplay "|" dtd_timeZoneList
;   }
;   Sort dtd_timeZoneList, N P5 D|
;   Gui, Add, DDL, x+0 yp-5 w300 vdtd_TimeZone1 gsub_CheckIfSettingsChanged, %dtd_timeZoneList%
Return

SaveSettings_DateTimeDisplay:
	IniWrite, %dtd_DateFormat%, %ConfigFile%, %dtd_ScriptName%, DateFormat
	IniWrite, %dtd_TimeFormat%, %ConfigFile%, %dtd_ScriptName%, TimeFormat
	IniWrite, %dtd_FontColor%, %ConfigFile%, %dtd_ScriptName%, FontColor
	IniWrite, %dtd_FontSize%, %ConfigFile%, %dtd_ScriptName%, FontSize
	IniWrite, %dtd_BackgroundColor%, %ConfigFile%, %dtd_ScriptName%, BackgroundColor
	IniWrite, %dtd_Transparency%, %ConfigFile%, %dtd_ScriptName%, Transparency
	IniWrite, %dtd_TimeOut%, %ConfigFile%, %dtd_ScriptName%, TimeOut
Return

AddSettings_DateTimeDisplay:
Return
CancelSettings_DateTimeDisplay:
Return

DoEnable_DateTimeDisplay:
	; func_HotkeyEnable("dtd_HOTKEYNAME")
Return

DoDisable_DateTimeDisplay:
	; func_HotkeyDisable("dtd_HOTKEYNAME")
	Gosub, tim_InfoScreenOff
Return

DefaultSettings_DateTimeDisplay:
Return
OnExitAndReload_DateTimeDisplay:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_DateTimeDisplay:
	dtd_Factor := 96/SystemDPI*dtd_Fontsize
	FormatTime,dtd_Date,,%dtd_DateFormat%
	FormatTime,dtd_Time,,%dtd_TimeFormat%
	dtd_Len := StrLen(dtd_Date)
	If (StrLen(dtd_Time) > dtd_Len)
		dtd_Len := StrLen(dtd_Time)
	If dtd_Width < 1
		dtd_WidthTmp := dtd_Factor*(dtd_Len/1.2)+10
	Else
		dtd_WidthTmp = %dtd_Width%
	If dtd_Height < 1
		dtd_HeightTmp := dtd_Factor*3.4+10
	Else
		dtd_HeightTmp = %dtd_Height%

	IfWinExist, dtd_sub_GetTimeSplashImage
		Gosub, tim_InfoScreenOff
	Else
		InfoScreen( "dtd_sub_GetTime","",dtd_Transparency,dtd_TimeOut,dtd_BackgroundColor,dtd_FontColor,dtd_Fontsize,dtd_WidthTmp,dtd_HeightTmp,1000)
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

dtd_sub_GetTime:
	FormatTime,dtd_Display,,%dtd_DateFormat%`n%dtd_TimeFormat%
	#Return = %dtd_Display%
Return
