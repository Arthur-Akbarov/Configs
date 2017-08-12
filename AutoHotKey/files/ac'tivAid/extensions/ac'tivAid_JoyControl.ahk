; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               JoyControl
; -----------------------------------------------------------------------------
; Prefix:             jc_
; Version:            0.4
; Date:               2008-03-18
; Author:             David Hilberath
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === ToDo ====================================================================
; -----------------------------------------------------------------------------
; - Joystick wechseln per Tastenkombination (Bsp: Joystick 4 drückt 11 und 12
;   gleichzeitig und wird damit zum Eingabejoystick).
; - Hilfe schreiben
; - leichter Bug beim entfernen von belegten Aktionen
; - Verschiedene Aktionen auf Analogsticks legen können
; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_JoyControl:
	Prefix = jc
	%Prefix%_ScriptName    = JoyControl
	%Prefix%_ScriptVersion = 0.4
	%Prefix%_Author        = David Hilberath

	CustomHotkey_JoyControl = 0
	Hotkey_JoyControl       =
	HotkeyPrefix_JoyControl =
	IconFile_On_JoyControl     = %A_WinDir%\system32\joy.cpl
	IconPos_On_JoyControl     = 1
	;IconFile_Off_JoyControl     = %A_WinDir%\system32\shell32.dll
	;IconPos_Off_JoyControl     = 32

	jc_ProfileDirectory = %SettingsDir%\JoyControl

	CreateGuiID("JoyControl_EditProfile")
	CreateGuiID("JoyControl_ButtonEdit")

	RegisterAdditionalSetting("jc","runFolder_useIcons",0)
	RegisterAdditionalSetting("jc","showInfoScreen1",0)
	RegisterAdditionalSetting("jc","showInfoScreen2",1)

	Gosub, Language_JoyControl
	Gosub, registerActions
	Gosub, LoadSettings_JoyControl
	Gosub, jc_getAllProfiles
Return

Language_JoyControl:
	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %jc_ScriptName% - Joystick als Maus benutzen
		Description                   = Windows mit einem Joystick kontrollieren

		lng_jc_ToggleGroup            = Impuls-Schalter
		lng_jc_SpeedMultiplier        = Schneller
		lng_jc_TurtleMultiplier       = Langsamer
		lng_jc_AllMultiplier          = Normal

		lng_jc_AnalogOneGroup         = Analog Eins
		lng_jc_AnalogTwoGroup         = Analog Zwei
		lng_jc_JoyMultiplierNormal    = Impuls
		lng_jc_JoyThreshold           = Toleranz

		lng_jc_pulseGroup             = Puls
		lng_jc_WheelDelay             = Mausrad
		lng_jc_ArrowKeysDelay         = Pfeiltasten
		lng_jc_PovPulse               = Pov

		lng_jc_optionsGroup           = Sonstiges
		lng_jc_JoystickNumber         = Joystick #
		lng_jc_InvertYAxis            = Y-Achse umkehren
		lng_jc_SwitchSticks           = Sticks tauschen

		lng_jc_ProfileGroup           = Profile

		lng_jc_povGroup               = POV Knöpfe
		lng_jc_buttonsGroup           = Knöpfe
		lng_jc_ButtonDefault          = Standard
		lng_jc_EditProfile_title      = Profil bearbeiten

		lng_jc_editButton_save        = Sichern
		lng_jc_editButton_hold        = Daueraktion (Halten)
		lng_jc_editButton_instant     = Sofortaktion
		lng_jc_editButton_primary     = Kurz
		lng_jc_editButton_secondary   = Lang
		lng_jc_editButton_description = Beschreibung
		lng_jc_editButton_title       = Bearbeite Button Nr.%A_Space%

		lng_jc_actions_leftClick      = Linksklick
		lng_jc_actions_rightClick     = Rechtsklick
		lng_jc_actions_highSense      = Schneller
		lng_jc_actions_lowSense       = Langsamer
		lng_jc_actions_shift          = Umschalt
		lng_jc_actions_ctrl           = Steuerung
		lng_jc_actions_alt            = Alt
		lng_jc_actions_arrowUp        = Pfeil Hoch
		lng_jc_actions_arrowDown      = Pfeil Runter
		lng_jc_actions_arrowLeft      = Pfeil Links
		lng_jc_actions_arrowRight     = Pfeil Rechts
		lng_jc_actions_scrollMode     = Mausrad Modus
		lng_jc_actions_centerWindow   = Fenster zentrieren
		lng_jc_actions_altTab         = Nächster Task
		lng_jc_actions_altTabMenu     = Taskmenü
		lng_jc_actions_runFolder      = Startmenü
		lng_jc_actions_key            = Tastendruck
		lng_jc_actions_nextProfile    = Nächstes Profil aktivieren
		lng_jc_actions_changeProfile  = Bestimmtes Profil aktivieren

		lng_jc_selectRunFolderRoot    = Neues RunFolder Verzeichnis auswählen
		lng_jc_runFolder_useIcons     = RunFolder: Icons verwenden
		lng_jc_autoloadProfiles       = Profile automatisch laden

		lng_jc_newProfileMenu_Scratch = Leer
		lng_jc_newProfileMenu_Copy    = Kopie der Auswahl
		lng_jc_newProfileName         = Name des Profils
		lng_jc_newProfileNamePrompt   = Bitten geben sie einen Namen für das neue Profil ein
		lng_jc_defaultProfile         = Standard
		lng_jc_activeProfile          = Aktiv

		lng_jc_noActiveDelete         = Das aktive Profil kann nicht gelöscht werden.
		lng_jc_noDefaultDelete        = Das Standardprofil kann nicht gelöscht werden.

		lng_jc_saveProfile            = Speichern
		lng_jc_activateProfile        = Aktivieren
		lng_jc_setDefaultProfile      = Als Standard
		lng_jc_editProfile            = Bearbeiten

		lng_jc_changedProfile         = Profil wurde gewechselt
		lng_jc_showInfoScreen1        = Profilwechsel Hinweis anzeigen
		lng_jc_showInfoScreen2        = Profilwechsel Sprechblase anzeigen
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %jc_ScriptName% - Use Joystick as mouse
		Description                   = Control Windows with a joystick

		lng_jc_ToggleGroup            = Speed-Toggle
		lng_jc_SpeedMultiplier        = Faster
		lng_jc_TurtleMultiplier       = Slower
		lng_jc_AllMultiplier          = Normal

		lng_jc_AnalogOneGroup         = AnalogOne
		lng_jc_AnalogTwoGroup         = AnalogTwo
		lng_jc_JoyMultiplierNormal    = Speed
		lng_jc_JoyThreshold           = Threshold

		lng_jc_pulseGroup             = Pulse
		lng_jc_WheelDelay             = Wheel
		lng_jc_ArrowKeysDelay         = ArrowKeys
		lng_jc_PovPulse               = Pov

		lng_jc_optionsGroup           = Options
		lng_jc_JoystickNumber         = Joystick #
		lng_jc_InvertYAxis            = Invert Y Axis
		lng_jc_SwitchSticks           = Switch sticks

		lng_jc_ProfileGroup           = Profiles

		lng_jc_povGroup               = POV Buttons
		lng_jc_buttonsGroup           = Buttons
		lng_jc_ButtonDefault          = Default
		lng_jc_EditProfile_title      = Edit Profile

		lng_jc_editButton_save        = Save
		lng_jc_editButton_hold        = Hold action
		lng_jc_editButton_instant     = Instant action
		lng_jc_editButton_primary     = Short
		lng_jc_editButton_secondary   = Long
		lng_jc_editButton_description = Description
		lng_jc_editButton_title       = Edit Button #

		lng_jc_actions_leftClick      = Left click
		lng_jc_actions_rightClick     = Right click
		lng_jc_actions_highSense      = High speed
		lng_jc_actions_lowSense       = Low speed
		lng_jc_actions_shift          = Shift
		lng_jc_actions_ctrl           = Control
		lng_jc_actions_alt            = Alt
		lng_jc_actions_arrowUp        = Arrow up
		lng_jc_actions_arrowDown      = Arrow down
		lng_jc_actions_arrowLeft      = Arrow left
		lng_jc_actions_arrowRight     = Arrow right
		lng_jc_actions_scrollMode     = Scrollmode
		lng_jc_actions_centerWindow   = Center window
		lng_jc_actions_altTab         = Next task
		lng_jc_actions_altTabMenu     = Taskmenu
		lng_jc_actions_runFolder      = Startmenu
		lng_jc_actions_key            = Push a key
		lng_jc_actions_nextProfile    = Activate next profile
		lng_jc_actions_changeProfile  = Activate other profile

		lng_jc_selectRunFolderRoot    = Choose RunFolder Directory
		lng_jc_runFolder_useIcons     = RunFolder: Use icons
		lng_jc_autoloadProfiles       = Load profiles automatically

		lng_jc_newProfileMenu_Scratch = From Scratch
		lng_jc_newProfileMenu_Copy    = From Selected
		lng_jc_newProfileName         = Profile Name
		lng_jc_newProfileNamePrompt   = Please enter a name for the new Profile
		lng_jc_defaultProfile         = Default
		lng_jc_activeProfile          = Active

		lng_jc_noActiveDelete         = The active profile can not be deleted.
		lng_jc_noDefaultDelete        = The default profile can not be deleted.

		lng_jc_saveProfile            = Save
		lng_jc_activateProfile        = Activate
		lng_jc_setDefaultProfile      = As Default
		lng_jc_editProfile            = Edit

		lng_jc_changedProfile         = Active profile has changed
		lng_jc_showInfoScreen1        = Show Infoscreen on profile change
		lng_jc_showInfoScreen2        = Show BallonTip on profile change

		lng_jc_fileSelectPrompt       = Select executable
		lng_jc_fileSelectFilter       = Executable (*.exe)
	}
return

jc_addProfileApp:
	FileSelectFile, jc_SelectedFile, 3,,%lng_jc_fileSelectPrompt%, %lng_jc_fileSelectFilter%
	if jc_SelectedFile =
		return

	SplitPath, jc_SelectedFile, jc_SelectedFile
	GuiControlGet,jc_editProfile,,jc_editProfile

	if jc_SelectedFile in %jc_autoLoadApps%
		return

	if jc_SelectedFile in %jc_tmp_toAdd%
		return

	if jc_editProfile =
		return

	Gui, ListView, jc_Listview
	LV_Add("",jc_SelectedFile,jc_editProfile)
	jc_tmp_toAdd = %jc_tmp_toAdd%%jc_SelectedFile%,

	func_SettingsChanged("JoyControl")
return

jc_deleteProfileApp:
	Gui, ListView, jc_Listview
	jc_RowNumber = 0  ; This causes the first loop iteration to start the search at the top of the list.
	Loop
	{
		 jc_RowNumber := LV_GetNext(jc_RowNumber)
		 if not jc_RowNumber
			  break

		 LV_GetText(jc_tmp_appToRem, jc_RowNumber, 1)
		 LV_Delete(jc_RowNumber)
	}

	func_SettingsChanged("JoyControl")
return

jc_sub_CheckIfSettingsChanged:
	Gosub, sub_CheckIfSettingsChanged
	GuiControlGet, jc_autoloadProfiles_tmp,, jc_autoloadProfiles
	GuiControl, Enable%jc_autoloadProfiles_tmp%, jc_Listview
	GuiControl, Enable%jc_autoloadProfiles_tmp%, jc_Listview_add
	GuiControl, Enable%jc_autoloadProfiles_tmp%, jc_Listview_del
return

SettingsGui_JoyControl:
	Gui, Add, GroupBox, w245 h177 xs+10 ys+13, %lng_jc_ProfileGroup%
	Gui, Add, ListBox, xs+15 yp+17 w150 h130 vjc_editProfile, %jc_AllProfiles%
	Gui, Add, Text, xs+15 y+5 w220 vjc_defaultText, %lng_jc_defaultProfile%:`t%jc_defaultProfile%
	Gui, Add, Text, xs+15 y+4 w220 vjc_activeText, %lng_jc_activeProfile%:`t%jc_activeProfile%

	Gui, Add, GroupBox, w244 h177 x+30 ys+13,
	Gui, Add, Listview, xp+7 yp+17 w230 h130 -Hdr vjc_Listview, App|Profile
	LV_ModifyCol(1,"100")
	LV_ModifyCol(2,"125")
	Gui, Add, Button, y+7 w37 h15 gjc_addProfileApp vjc_Listview_add, +
	Gui, Add, Button, x+5 w38 h15 gjc_deleteProfileApp vjc_Listview_del, %MinusString%

	Gui, Add, Checkbox, xs+275 ys+13 w140 checked%jc_autoloadProfiles% vjc_autoloadProfiles gjc_sub_CheckIfSettingsChanged, %lng_jc_autoloadProfiles%

	Gui, Add, Button, xs+170 ys+31 w80 gjc_setActiveProfile, %lng_jc_activateProfile%
	Gui, Add, Button, y+5 w80 gjc_setDefaultProfile, %lng_jc_setDefaultProfile%
	Gui, Add, Button, y+5 w80 gjc_editProfile, %lng_jc_editProfile%
	Gui, Add, Button, y+25 w37 h15 gjc_showNewProfileMenu, +
	Gui, Add, Button, x+5 w38 h15 gjc_deleteProfile, %MinusString%

	Gui, Add, GroupBox, w105 h90 xs+10 ys+192, %lng_jc_AnalogOneGroup%
	Gui, Add, Text, XS+15 YP+16, %lng_jc_JoyMultiplierNormal%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged XS+80 vjc_JoyMultiplierNormal w30, %jc_JoyMultiplierNormal%
	Gui, Add, Text, XS+15 y+7, %lng_jc_JoyThreshold%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged XS+80 vjc_JoyThreshold w30, %jc_JoyThreshold%
	Gui, Add, Text, XS+15 y+7, %lng_jc_pulseGroup%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged XS+80 vjc_AnalogOnePulse w30, %jc_AnalogOnePulse%

	Gui, Add, GroupBox, w105 h90 xs+120 ys+192, %lng_jc_AnalogTwoGroup%
	Gui, Add, Text, XS+125 YP+15, %lng_jc_JoyMultiplierNormal%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged XS+190 vjc_Joy2MultiplierNormal w30, %jc_Joy2MultiplierNormal%
	Gui, Add, Text, XS+125 y+7, %lng_jc_JoyThreshold%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged XS+190 vjc_Joy2Threshold w30, %jc_Joy2Threshold%
	Gui, Add, Text, XS+125 Y+7, %lng_jc_pulseGroup%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged XS+190 vjc_AnalogTwoPulse w30, %jc_AnalogTwoPulse%

	Gui, Add, GroupBox, w105 h90 xs+230 ys+192, %lng_jc_ToggleGroup%
	Gui, Add, Text, XS+235 YP+15, %lng_jc_AllMultiplier%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged XS+300 vjc_AllMultiplier w30, %jc_AllMultiplier%
	Gui, Add, Text, XS+235 Y+7, %lng_jc_SpeedMultiplier%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged XS+300 vjc_SpeedMultiplier w30, %jc_SpeedMultiplier%
	Gui, Add, Text, XS+235 y+7, %lng_jc_TurtleMultiplier%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged XS+300 vjc_TurtleMultiplier w30, %jc_TurtleMultiplier%

	Gui, Add, GroupBox, w105 h90 xs+340 ys+192, %lng_jc_pulseGroup%
	Gui, Add, Text, XS+345 YP+15, %lng_jc_WheelDelay%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged XS+410 vjc_WheelDelay w30, %jc_WheelDelay%
	Gui, Add, Text, XS+345 Y+7, %lng_jc_ArrowKeysDelay%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged XS+410 vjc_ArrowKeysDelay w30, %jc_ArrowKeysDelay%
	Gui, Add, Text, XS+345 Y+7, %lng_jc_PovPulse%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged XS+410 vjc_PovPulse w30, %jc_PovPulse%

	Gui, Add, GroupBox, w115 h90 xs+450 ys+192, %lng_jc_optionsGroup%
	Gui, Add, Text, XS+455 YP+16, %lng_jc_JoystickNumber%:
	Gui, Add, DropDownList, yp-3 h20 R5 gsub_CheckIfSettingsChanged XS+520 vjc_JoystickNumber w40, %jc_joysticks%
	Gui, Add, CheckBox, xs+455 y+8 vjc_InvertYAxis gsub_CheckIfSettingsChanged Checked%jc_InvertYAxis%, %lng_jc_InvertYAxis%
	Gui, Add, CheckBox, xs+455 y+13 vjc_switchSticks gsub_CheckIfSettingsChanged Checked%jc_switchSticks%, %lng_jc_switchSticks%

	Loop, parse, jc_autoLoadList, *
	{
		if A_LoopField !=
		{
			StringSplit, jc_tmp_autoLoadListEntry, A_LoopField, :
			LV_Add("",jc_tmp_autoLoadListEntry1,jc_tmp_autoLoadListEntry2)

		}
	}

	gosub, jc_sub_CheckIfSettingsChanged
Return

LoadSettings_JoyControl:
	IniRead, jc_JoystickNumber, %ConfigFile%, %jc_ScriptName%, JoystickNumber, 2
	IniRead, jc_switchSticks, %ConfigFile%, %jc_ScriptName%, SwitchSticks, 0
	IniRead, jc_InvertYAxis, %ConfigFile%, %jc_ScriptName%, InvertYAxis, 0
	IniRead, jc_SpeedMultiplier, %ConfigFile%, %jc_ScriptName%, SpeedMultiplier, 2
	IniRead, jc_TurtleMultiplier, %ConfigFile%, %jc_ScriptName%, TurtleMultiplier, 0.5
	IniRead, jc_AllMultiplier, %ConfigFile%, %jc_ScriptName%, AllMultiplier, 1
	IniRead, jc_JoyMultiplierNormal, %ConfigFile%, %jc_ScriptName%, JoyMultiplierNormal, 0.25
	IniRead, jc_Joy2MultiplierNormal, %ConfigFile%, %jc_ScriptName%, Joy2MultiplierNormal, 0.50
	IniRead, jc_JoyThreshold, %ConfigFile%, %jc_ScriptName%, JoyThreshold, 1.2
	IniRead, jc_Joy2Threshold, %ConfigFile%, %jc_ScriptName%, Joy2Threshold, 6
	IniRead, jc_WheelDelay, %ConfigFile%, %jc_ScriptName%, WheelDelay, 40
	IniRead, jc_ArrowKeysDelay, %ConfigFile%, %jc_ScriptName%, ArrowKeysDelay, 50
	IniRead, jc_AnalogOnePulse, %ConfigFile%, %jc_ScriptName%, AnalogOnePulse, 10
	IniRead, jc_AnalogTwoPulse, %ConfigFile%, %jc_ScriptName%, AnalogTwoPulse, 10
	IniRead, jc_PovPulse, %ConfigFile%, %jc_ScriptName%, PovPulse, 10
	IniRead, jc_runFolderRoot, %ConfigFile%, %jc_ScriptName%, RunFolderRoot, %A_StartMenu%
	IniRead, jc_defaultProfile, %ConfigFile%, %jc_ScriptName%, DefaultProfile, Standard
	IniRead, jc_autoLoadList, %ConfigFile%, %jc_ScriptName%, AutoLoadList, %A_Space%
	IniRead, jc_autoloadProfiles, %ConfigFile%, %jc_ScriptName%, AutoLoadProfiles, 0

	Loop, parse, jc_autoLoadList, *
	{
		if A_LoopField !=
		{
			StringSplit, jc_tmp_autoLoadListEntry, A_LoopField, :
			jc_appNameShort := func_StrClean(jc_tmp_autoLoadListEntry1)
			jc_appProfile[%jc_appNameShort%] := jc_tmp_autoLoadListEntry2
			jc_autoLoadApps = %jc_autoLoadApps%%jc_tmp_autoLoadListEntry1%,
		}
	}

	If jc_activeProfile =
		jc_activeProfile := jc_defaultProfile
	jc_profileToLoad := jc_activeProfile

	Gosub, jc_loadProfile
	Gosub, jc_calculateVars
Return

SaveSettings_JoyControl:
	; Syntax: HotkeyWrite ( Name des Tastaturkürzels, INI-Datei, Sektion, INI-Variable [, Subroutine des Tastaturkürzels] )
	; func_HotkeyWrite( "jc_HOTKEYNAME", ConfigFile , jc_ScriptName, "INI-Variable" )
	IniWrite, %jc_JoystickNumber%, %ConfigFile%, %jc_ScriptName%, JoystickNumber
	IniWrite, %jc_switchSticks%, %ConfigFile%, %jc_ScriptName%, SwitchSticks
	IniWrite, %jc_InvertYAxis%, %ConfigFile%, %jc_ScriptName%, InvertYAxis
	IniWrite, %jc_SpeedMultiplier%, %ConfigFile%, %jc_ScriptName%, SpeedMultiplier
	IniWrite, %jc_TurtleMultiplier%, %ConfigFile%, %jc_ScriptName%, TurtleMultiplier
	IniWrite, %jc_AllMultiplier%, %ConfigFile%, %jc_ScriptName%, AllMultiplier
	IniWrite, %jc_JoyMultiplierNormal%, %ConfigFile%, %jc_ScriptName%, JoyMultiplierNormal
	IniWrite, %jc_Joy2MultiplierNormal%, %ConfigFile%, %jc_ScriptName%, Joy2MultiplierNormal
	IniWrite, %jc_JoyThreshold%, %ConfigFile%, %jc_ScriptName%, JoyThreshold
	IniWrite, %jc_Joy2Threshold%, %ConfigFile%, %jc_ScriptName%, Joy2Threshold
	IniWrite, %jc_WheelDelay%, %ConfigFile%, %jc_ScriptName%, WheelDelay
	IniWrite, %jc_ArrowKeysDelay%, %ConfigFile%, %jc_ScriptName%, ArrowKeysDelay
	IniWrite, %jc_AnalogOnePulse%, %ConfigFile%, %jc_ScriptName%, AnalogOnePulse
	IniWrite, %jc_AnalogTwoPulse%, %ConfigFile%, %jc_ScriptName%, AnalogTwoPulse
	IniWrite, %jc_PovPulse%, %ConfigFile%, %jc_ScriptName%, PovPulse
	IniWrite, %jc_runFolderRoot%, %ConfigFile%, %jc_ScriptName%, RunFolderRoot
	IniWrite, %jc_defaultProfile%, %ConfigFile%, %jc_ScriptName%, DefaultProfile
	IniWrite, %jc_autoloadProfiles%, %ConfigFile%, %jc_ScriptName%, AutoLoadProfiles

	Gui, ListView, jc_Listview
	jc_tmp_toAdd =
	jc_autoLoadApps =
	jc_autoLoadList =
	jc_RowNumber := 0

	Loop % LV_GetCount()
	{
		LV_GetText(jc_tmp_app, A_Index, 1)
		LV_GetText(jc_tmp_prof, A_Index, 2)

		jc_tmp_app_short := func_StrClean(jc_tmp_app)

		jc_appProfile[%jc_tmp_app_short%] := jc_tmp_prof
		jc_autoLoadApps = %jc_autoLoadApps%%jc_tmp_app%,
		jc_autoLoadList = %jc_autoLoadList%%jc_tmp_app%:%jc_tmp_prof%*
	}

	IniWrite, %jc_autoLoadList%, %ConfigFile%, %jc_ScriptName%, AutoLoadList
	Gosub, jc_calculateVars
Return

jc_calculateVars:
	jc_joysticks := jc_findJoysticks(jc_JoystickNumber)

	if jc_InvertYAxis
		jc_YAxisMultiplier = -1
	else
		jc_YAxisMultiplier = 1

	jc_JoyMultiplier := jc_JoyMultiplierNormal * jc_AllMultiplier
	jc_Joy2Multiplier := jc_Joy2MultiplierNormal * jc_AllMultiplier

	; Calculate the axis displacements that are needed to start moving the cursor:
	jc_JoyThresholdUpper := 50 + jc_JoyThreshold
	jc_JoyThresholdLower := 50 - jc_JoyThreshold
	jc_Joy2ThresholdUpper := 50 + (jc_Joy2Threshold)
	jc_Joy2ThresholdLower := 50 - (jc_Joy2Threshold)

	jc_JoystickPrefix = %jc_JoystickNumber%Joy

	jc_prevPov = -1
Return

AddSettings_JoyControl:
Return

CancelSettings_JoyControl:
	jc_tmp_toAdd =
	Gosub, LoadSettings_JoyControl
Return

DoEnable_JoyControl:
	if jc_autoloadProfiles = 1
		registerEvent("activeWindow","jc_shellHook_loadProfile")

	Hotkey, %jc_JoystickPrefix%1 , jc_ButtonOne, On
	Hotkey, %jc_JoystickPrefix%2 , jc_ButtonTwo, On
	Hotkey, %jc_JoystickPrefix%3 , jc_ButtonThree, On
	Hotkey, %jc_JoystickPrefix%4 , jc_ButtonFour, On
	Hotkey, %jc_JoystickPrefix%5 , jc_ButtonFive, On
	Hotkey, %jc_JoystickPrefix%6 , jc_ButtonSix, On
	Hotkey, %jc_JoystickPrefix%7 , jc_ButtonSeven, On
	Hotkey, %jc_JoystickPrefix%8 , jc_ButtonEight, On
	Hotkey, %jc_JoystickPrefix%9 , jc_ButtonNine, On
	Hotkey, %jc_JoystickPrefix%10, jc_ButtonTen, On
	Hotkey, %jc_JoystickPrefix%11, jc_ButtonEleven, On
	Hotkey, %jc_JoystickPrefix%12, jc_ButtonTwelve, On

	SetTimer, jc_WatchAnalogOne, %jc_AnalogOnePulse%
	SetTimer, jc_WatchAnalogTwo, %jc_AnalogTwoPulse%
	SetTimer, jc_WatchPov, %jc_PovPulse%
Return

jc_shellHook_loadProfile:
	if event_ActiveWindow in %jc_autoLoadApps%
	{
		jc_event_short := func_StrClean(event_ActiveWindow)
		jc_profileToLoad := jc_appProfile[%jc_event_short%]

		Gosub, jc_loadProfile
	}
	else
	{
		If jc_profileToLoad != %jc_defaultProfile%
		{
			jc_profileToLoad := jc_defaultProfile
			Gosub, jc_loadProfile
		}
	}
return

DoDisable_JoyControl:
	if jc_autoloadProfiles = 1
		unRegisterEvent("activeWindow","jc_shellHook_loadProfile")

	gosub, jc_deactivate
Return

DefaultSettings_JoyControl:
	gosub, jc_setDefaultButtons
Return

OnExitAndReload_JoyControl:
	gosub, jc_deactivate
Return

jc_findJoysticks(selected)
{
	jc_joysticks =

	loop, 8
	{
		GetKeyState, jc_JoyName, %A_Index%JoyName

		if jc_JoyName
			jc_joysticks = %jc_joysticks%%A_Index%|

		if Selected = %A_Index%
			jc_joysticks = %jc_joysticks%|
	}

	return jc_joysticks
}

jc_calcButtonText(num)
{
	Global

	jc_Button%num%Text =

	if jc_Button%num%Hold
	{
		jc_Button%num%Text := jc_Button%num%Hold
		jc_Button%num%Text := descHoldActionsString(jc_Button%num%Text)

		if jc_Button%num%HoldPara
			jc_Button%num%Text := jc_Button%num%Text . " (" . jc_Button%num%HoldPara . ")"
	}
	else
	{
		if jc_Button%num%Short
		{
			jc_Button%num%Text := jc_Button%num%Short
			jc_Button%num%Text := descActionsString(jc_Button%num%Text)

			if jc_Button%num%ShortPara
				jc_Button%num%Text := jc_Button%num%Text . " (" . jc_Button%num%ShortPara . ")"
		}

		if jc_Button%num%Long
		{
			;msgbox % descActionsString(jc_Button%num%Long)
			jc_Button%num%Text := jc_Button%num%Text . " > " . descActionsString(jc_Button%num%Long)

			if jc_Button%num%LongPara
				jc_Button%num%Text := jc_Button%num%Text . " (" . jc_Button%num%LongPara . ")"
		}
	}

	StringReplace,jc_Button%num%Text,jc_Button%num%Text,|,%A_Space%+%A_Space%,1
}

jc_deactivate:
	Loop, 12
	{
		jc_deactivateTimer = jc_Button%A_Index%UpYet
		SetTimer, %jc_deactivateTimer%, off

		jc_deactivateHotkey = %jc_JoystickPrefix%%A_Index%

		;If IsLabel(jc_deactivateHotkey)
			Hotkey, %jc_deactivateHotkey%, , off
	}

	SetTimer, jc_WatchAnalogOne, off
	SetTimer, jc_WatchAnalogTwo, off
	SetTimer, jc_WatchPov, off
return

; -----------------------------------------------------------------------------
; === Profile Handling ========================================================
; -----------------------------------------------------------------------------
jc_getAllProfiles:
	GuiDefault("activAid")
	IfNotExist, %jc_ProfileDirectory%
		FileCreateDir, %jc_ProfileDirectory%

	IfNotExist, %jc_ProfileDirectory%\%jc_defaultProfile%.ini
	{
		gosub, jc_setDefaultButtons
		gosub, jc_saveProfile
	}

	jc_AllProfiles =
	Loop, %jc_ProfileDirectory%\*.ini,0,0
	{
		StringReplace, jc_foundProfile, A_LoopFileName, .%A_LoopFileExt%,

		if jc_foundProfile = %jc_defaultProfile%
			jc_status = D

		if jc_foundProfile = %jc_activeProfile%
		{
			jc_status = A
			jc_foundProfile = %jc_foundProfile%|
		}

		jc_AllProfiles = %jc_AllProfiles%%jc_foundProfile%|
	}

	GuiControl,,jc_editProfile,|%jc_AllProfiles%
return

jc_showNewProfileMenu:
	Menu, jc_newProfileMenu, add, %lng_jc_newProfileMenu_Scratch%, jc_CreateEmptyProfile
	Menu, jc_newProfileMenu, add, %lng_jc_newProfileMenu_Copy%, jc_CreateCopyProfile

	Menu, jc_newProfileMenu, show
return


jc_CreateEmptyProfile:
	InputBox, jc_newProfileName, %lng_jc_newProfileName%, %lng_jc_newProfileNamePrompt%

	jc_replace = <>\/:?*|"

	Loop, parse, jc_replace
		StringReplace,jc_newProfileName,jc_newProfileName,%A_LoopField%,,All

  if jc_newProfileName =
		return

	jc_profileToSave := jc_newProfileName
	gosub, jc_emptyProfile
	gosub, jc_createGuiEditProfile
return

jc_CreateCopyProfile:
	InputBox, jc_newProfileName, %lng_jc_newProfileName%, %lng_jc_newProfileNamePrompt%

	jc_replace = <>\/:?*|"

	Loop, parse, jc_replace
		StringReplace,jc_newProfileName,jc_newProfileName,%A_LoopField%,,All

  if jc_newProfileName =
		return

	GuiControlGet,jc_editProfile,,jc_editProfile
	jc_profileToLoad := jc_editProfile
	jc_profileToSave := jc_newProfileName
	gosub, jc_loadProfile
	gosub, jc_createGuiEditProfile
return

jc_setActiveProfile:
	GuiControlGet,jc_editProfile,,jc_editProfile
	jc_profileToLoad := jc_editProfile
	gosub, jc_loadProfile
return

jc_setDefaultProfile:
	GuiControlGet,jc_editProfile,,jc_editProfile
	jc_defaultProfile := jc_editProfile
	GuiControl,,jc_defaultText, %lng_jc_defaultProfile%:`t%jc_editProfile%
	func_SettingsChanged("JoyControl")
return

jc_deleteProfile:
	GuiControlGet,jc_editProfile,,jc_editProfile
	jc_profileToDelete := jc_editProfile

	if jc_profileToDelete = %jc_activeProfile%
	{
		msgbox, %lng_jc_noActiveDelete% (%jc_activeProfile%)
		return
	}

	if jc_profileToDelete = %jc_defaultProfile%
	{
		msgbox, %lng_jc_noDefaultDelete% (%jc_defaultProfile%)
		return
	}

	FileDelete, %jc_ProfileDirectory%\%jc_profileToDelete%.ini
	gosub, jc_getAllProfiles
return

jc_editProfile:
	GuiControlGet,jc_editProfile,,jc_editProfile
	jc_profileToLoad := jc_editProfile
	jc_profileToSave := jc_editProfile
	gosub, jc_loadProfile

	gosub, jc_createGuiEditProfile
return

jc_emptyProfile:
	GuiDefault("activAid")
	jc_activeProfile := jc_profileToSave
	GuiControl,,jc_activeText, %lng_jc_activeProfile%:`t%jc_profileToSave%

	Loop, 12
	{
		jc_clearButton(A_Index)
	}

	jc_clearButton("PU")
	jc_clearButton("PD")
	jc_clearButton("PL")
	jc_clearButton("PR")
return

jc_changeProfile:
	jc_profileToLoad := actionParameter
	gosub, jc_loadProfile
	gosub, jc_getAllProfiles
return

jc_changeHoldProfile:
	jc_profileToLoad := HoldActionParameter
	gosub, jc_loadProfile
	gosub, jc_getAllProfiles
return

jc_nextProfile:
	jc_nextProfile =
	gosub, jc_getAllProfiles

	RegExMatch(jc_allProfiles,"\|\|(.+?)\|",jc_nextProfile)

	if jc_nextProfile =
		RegExMatch(jc_allProfiles,"(.+?)\|",jc_nextProfile)

	StringReplace, jc_nextProfile, jc_nextProfile, |,,All

	jc_profileToLoad := jc_nextProfile
	gosub, jc_loadProfile
	gosub, jc_getAllProfiles
return

jc_changeToDefaultProfile:
	jc_profileToLoad := jc_defaultProfile
	gosub, jc_loadProfile
	gosub, jc_getAllProfiles
return

jc_loadProfile:
	GuiDefault("activAid")
	jc_activeProfile := jc_profileToLoad

	if (jc_showInfoScreen1 = 1 AND jc_activeProfile <> jc_lastProfile)
		InfoScreen(jc_activeProfile,lng_jc_changedProfile,rdh_DisplayTransparency,1)

	if (jc_showInfoScreen2 = 1 AND jc_activeProfile <> jc_lastProfile)
	{
		;BalloonTip(jc_scriptName, lng_jc_changedProfile . ": " . jc_activeProfile, IconFile_On_JoyControl "|" IconPos_On_JoyControl, 0, 0, 1)
		BalloonTip(jc_scriptName, lng_jc_changedProfile . ": " . jc_activeProfile, "Info", 0, 0, 1)
	}
	jc_lastProfile := jc_activeProfile

	GuiControl,,jc_activeText, %lng_jc_activeProfile%:`t%jc_profileToLoad%

	Loop, 12
	{
		jc_readButton(A_Index,jc_profileToLoad)
		jc_calcButtonText(A_Index)
	}

	jc_readButton("PU",jc_profileToLoad)
	jc_readButton("PD",jc_profileToLoad)
	jc_readButton("PL",jc_profileToLoad)
	jc_readButton("PR",jc_profileToLoad)
	jc_calcButtonText("PU")
	jc_calcButtonText("PD")
	jc_calcButtonText("PL")
	jc_calcButtonText("PR")
return

jc_saveProfile:
	Loop, 12
	{
		jc_writeButton(A_Index,jc_profileToSave)
	}

	jc_writeButton("PU",jc_profileToSave)
	jc_writeButton("PD",jc_profileToSave)
	jc_writeButton("PL",jc_profileToSave)
	jc_writeButton("PR",jc_profileToSave)

	gosub, JoyControl_EditProfileGuiClose
	gosub, jc_getAllProfiles
return

jc_writeButton(num,profile="")
{
	Global

	if profile =
		profile = %jc_defaultProfile%

	ProfileFile = %jc_ProfileDirectory%\%profile%.ini

	toWrite := jc_Button%num%Short
	whereToWrite = Button%num%Short
	IniWrite, %toWrite%, %ProfileFile%, %jc_ScriptName%, %whereToWrite%

	toWrite := jc_Button%num%ShortPara
	whereToWrite = Button%num%ShortPara
	IniWrite, %toWrite%, %ProfileFile%, %jc_ScriptName%, %whereToWrite%

	toWrite := jc_Button%num%Long
	whereToWrite = Button%num%Long
	IniWrite, %toWrite%, %ProfileFile%, %jc_ScriptName%, %whereToWrite%

	toWrite := jc_Button%num%LongPara
	whereToWrite = Button%num%LongPara
	IniWrite, %toWrite%, %ProfileFile%, %jc_ScriptName%, %whereToWrite%

	toWrite := jc_Button%num%Hold
	whereToWrite = Button%num%Hold
	IniWrite, %toWrite%, %ProfileFile%, %jc_ScriptName%, %whereToWrite%

	toWrite := jc_Button%num%HoldPara
	whereToWrite = Button%num%HoldPara
	IniWrite, %toWrite%, %ProfileFile%, %jc_ScriptName%, %whereToWrite%
}

jc_readButton(num,profile="")
{
	Global

	if profile =
		profile = %jc_defaultProfile%

	ProfileFile = %jc_ProfileDirectory%\%profile%.ini

	whereToRead = Button%num%Short
	IniRead, jc_Button%num%Short, %ProfileFile%, %jc_ScriptName%, %whereToRead%, %A_Space%
	IniRead, jc_Button%num%ShortPara, %ProfileFile%, %jc_ScriptName%, %whereToRead%Para, %A_Space%

	whereToRead = Button%num%Long
	IniRead, jc_Button%num%Long, %ProfileFile%, %jc_ScriptName%, %whereToRead%, %A_Space%
	IniRead, jc_Button%num%LongPara, %ProfileFile%, %jc_ScriptName%, %whereToRead%Para, %A_Space%

	whereToRead = Button%num%Hold
	IniRead, jc_Button%num%Hold, %ProfileFile%, %jc_ScriptName%, %whereToRead%, %A_Space%
	IniRead, jc_Button%num%HoldPara, %ProfileFile%, %jc_ScriptName%, %whereToRead%Para, %A_Space%

	;jc_calcButtonText(num)
}

jc_clearButton(num)
{
	Global

	jc_Button%num%Short =
	jc_Button%num%ShortPara =
	jc_Button%num%Long =
	jc_Button%num%LongPara =
	jc_Button%num%Hold =
	jc_Button%num%HoldPara =
	jc_Button%num%Text =
}

; -----------------------------------------------------------------------------
; === Button Overview =========================================================
; -----------------------------------------------------------------------------
jc_createGuiEditProfile:
	GuiDefault("JoyControl_EditProfile")
	Gui, Destroy
	GuiDefault("JoyControl_EditProfile")

	Gui, Add, GroupBox, w285 h340 x3 y3 Section, %lng_jc_buttonsGroup%

	Gui, Add, Button, XS+5 ys+17 gjc_changeButton h20 w20, 1
	Gui, Add, Edit, h20 gsub_CheckIfSettingsChanged X+5 vjc_Button1Text w250, %jc_Button1Text%

	Gui, Add, Button, XS+5 y+7 gjc_changeButton h20 w20, 2
	Gui, Add, Edit, h20 gsub_CheckIfSettingsChanged X+5 vjc_Button2Text w250, %jc_Button2Text%

	Gui, Add, Button, XS+5 y+7 gjc_changeButton h20 w20, 3
	Gui, Add, Edit, h20 gsub_CheckIfSettingsChanged X+5 vjc_Button3Text w250, %jc_Button3Text%

	Gui, Add, Button, XS+5 y+7 gjc_changeButton h20 w20, 4
	Gui, Add, Edit, h20 gsub_CheckIfSettingsChanged X+5 vjc_Button4Text w250, %jc_Button4Text%

	Gui, Add, Button, XS+5 y+7 gjc_changeButton h20 w20, 5
	Gui, Add, Edit, h20 gsub_CheckIfSettingsChanged X+5 vjc_Button5Text w250, %jc_Button5Text%

	Gui, Add, Button, XS+5 y+7 gjc_changeButton h20 w20, 6
	Gui, Add, Edit, h20 gsub_CheckIfSettingsChanged X+5 vjc_Button6Text w250, %jc_Button6Text%

	Gui, Add, Button, XS+5 y+7 gjc_changeButton h20 w20, 7
	Gui, Add, Edit, h20 gsub_CheckIfSettingsChanged X+5 vjc_Button7Text w250, %jc_Button7Text%

	Gui, Add, Button, XS+5 y+7 gjc_changeButton h20 w20, 8
	Gui, Add, Edit, h20 gsub_CheckIfSettingsChanged X+5 vjc_Button8Text w250, %jc_Button8Text%

	Gui, Add, Button, XS+5 y+7 gjc_changeButton h20 w20, 9
	Gui, Add, Edit, h20 gsub_CheckIfSettingsChanged X+5 vjc_Button9Text w250, %jc_Button9Text%

	Gui, Add, Button, XS+5 y+7 gjc_changeButton h20 w20, 10
	Gui, Add, Edit, h20 gsub_CheckIfSettingsChanged X+5 vjc_Button10Text w250, %jc_Button10Text%

	Gui, Add, Button, XS+5 y+7 gjc_changeButton h20 w20, 11
	Gui, Add, Edit, h20 gsub_CheckIfSettingsChanged X+5 vjc_Button11Text w250, %jc_Button11Text%

	Gui, Add, Button, XS+5 y+7 gjc_changeButton h20 w20, 12
	Gui, Add, Edit, h20 gsub_CheckIfSettingsChanged X+5 vjc_Button12Text w250, %jc_Button12Text%

	Gui, Add, GroupBox, w290 h125 x293 y3 Section, %lng_jc_povGroup%

	Gui, Add, Button, XS+5 ys+17 gjc_changeButton h20 w25, PU
	Gui, Add, Edit, h20 gsub_CheckIfSettingsChanged X+5 vjc_ButtonPUText w250, %jc_ButtonPUText%

	Gui, Add, Button, XS+5 y+7 gjc_changeButton h20 w25, PL
	Gui, Add, Edit, h20 gsub_CheckIfSettingsChanged X+5 vjc_ButtonPLText w250, %jc_ButtonPLText%

	Gui, Add, Button, XS+5 y+7 gjc_changeButton h20 w25, PD
	Gui, Add, Edit, h20 gsub_CheckIfSettingsChanged X+5 vjc_ButtonPDText w250, %jc_ButtonPDText%

	Gui, Add, Button, XS+5 y+7 gjc_changeButton h20 w25, PR
	Gui, Add, Edit, h20 gsub_CheckIfSettingsChanged X+5 vjc_ButtonPRText w250, %jc_ButtonPRText%

	Gui, Add, Button, XS+225 y315 gjc_saveProfile h20 w60, %lng_jc_saveProfile%
	Gui, Show, w590 h347, %lng_jc_EditProfile_title%: %jc_profileToSave%
return

JoyControl_EditProfileGuiEscape:
JoyControl_EditProfileGuiClose:
	GuiDefault("JoyControl_EditProfile")
	Gui, Destroy
	jc_profileToLoad := jc_defaultProfile
	gosub, jc_loadProfile
return

; -----------------------------------------------------------------------------
; === Button Edit =============================================================
; -----------------------------------------------------------------------------
jc_changeButton:
	jc_editButton := A_GuiControl
	gosub, jc_updateGui
return

jc_createGui:
	GuiDefault("JoyControl_ButtonEdit")
	Gui, Add, Groupbox, x5 y5 w405 h101, %lng_jc_editButton_hold%
	Gui, Add, ListBox, x10 yp+15 w190 h85 Multi AltSubmit vjc_ListboxHoldActions, %HoldActionsDesc%

	Gui, Add, Button, x210 yp w20 h20 gjc_editButton_addHold, >
	Gui, Add, ListBox, x+5 w165 h60 Multi AltSubmit vjc_ListboxCurrentHoldActions,%  descHoldActionsString(jc_Button%jc_editButton%Hold)
	Gui, Add, Edit, y+5 w165 h20 vjc_editButton_HoldParaEdit,% jc_Button%jc_editButton%HoldPara
	Gui, Add, Button, x210 y45 w20 h20 gjc_editButton_removeHold, <

	Gui, Add, Groupbox, x5 y105 w405 h194, %lng_jc_editButton_instant%
	Gui, Add, ListBox, x10 yp+15 w190 h175 Multi AltSubmit vjc_ListboxActions , %ActionsDesc%
	;Gui, Add, Text, y+5 w190, %lng_jc_editButton_description%
	;Gui, Add, Text, y+3 w190 vjc_ActionsDescription,

	Gui, Add, Groupbox, x205 y115 w200 h90, %lng_jc_editButton_primary%
	Gui, Add, Button, x210 yp+15 w20 h20 gjc_editButton_addShort, >
	Gui, Add, ListBox, x+5 w165 h50 Multi AltSubmit vjc_ListboxCurrentShortActions,% descActionsString(jc_Button%jc_editButton%Short)
	Gui, Add, Button, x210 yp+25 w20 h20 gjc_editButton_removeShort, <
	Gui, Add, Edit, y+5 x+5 w165 h20 vjc_editButton_ShortParaEdit,% jc_Button%jc_editButton%ShortPara

	Gui, Add, Groupbox, x205 y+5 w200 h90, %lng_jc_editButton_secondary%
	Gui, Add, Button, x210 yp+15 w20 h20 gjc_editButton_addLong, >
	Gui, Add, ListBox, x+5 w165 h50 Multi AltSubmit vjc_ListboxCurrentLongActions,% descActionsString(jc_Button%jc_editButton%Long)
	Gui, Add, Button, x210 yp+25 w20 h20 gjc_editButton_removeLong, <
	Gui, Add, Edit, y+5 x+5 w165 h20 vjc_editButton_LongParaEdit,% jc_Button%jc_editButton%LongPara

	Gui, Add, Button, x345 y+10 w60 h30 gjc_editButton_save, %lng_jc_editButton_save%
	Gui, Show, w415 h335, %lng_jc_editButton_title%%jc_editButton%
return

jc_updateDescription:
	GuiControlGet, jc_lastSelect,,%A_GuiControl%

	Loop, parse, jc_lastSelect, |
	{
		if A_GuiControl in jc_ListboxCurrentShortActions,jc_ListboxCurrentLongActions,jc_ListboxActions
			jc_lastDescription := ActionDesc%A_LoopField%
		else
			jc_lastDescription := HoldActionDesc%A_LoopField%

		break
	}
	GuiControl,,jc_ActionsDescription, %jc_lastDescription%

return

jc_updateGui:
	GuiDefault("JoyControl_ButtonEdit")
	Gui, Destroy

	jc_currentHoldActions := jc_Button%jc_editButton%Hold
	jc_currentShortActions := jc_Button%jc_editButton%Short
	jc_currentLongActions := jc_Button%jc_editButton%Long

	gosub, jc_createGui
return

JoyControl_ButtonEditGuiClose:
JoyControl_ButtonEditGuiEscape:
	Gui, Destroy
return

jc_editButton_save:
	GuiDefault("JoyControl_ButtonEdit")
	Gui, Submit

	jc_Button%jc_editButton%Hold := jc_removeLeadingPipe(jc_currentHoldActions)
	jc_Button%jc_editButton%Short := jc_removeLeadingPipe(jc_currentShortActions)
	jc_Button%jc_editButton%Long := jc_removeLeadingPipe(jc_currentLongActions)

	GuiControlGet, jc_Button%jc_editButton%LongPara,,jc_editButton_LongParaEdit
	GuiControlGet, jc_Button%jc_editButton%ShortPara,,jc_editButton_ShortParaEdit
	GuiControlGet, jc_Button%jc_editButton%HoldPara,,jc_editButton_HoldParaEdit

	Gui, Destroy
	GuiDefault("JoyControl_EditProfile")

	jc_finishButtonChange(jc_editButton)

	func_SettingsChanged("JoyControl")
return

jc_removeLeadingPipe(str)
{
	If InStr(str,"|") = 1
	{
		StringTrimLeft,str,str,1
	}

	return str
}

jc_editButton_addHold:
	GuiDefault("JoyControl_ButtonEdit")
	GuiControlGet, jc_HoldActionsToAdd,,jc_ListboxHoldActions

	Loop, parse, jc_HoldActionsToAdd, |
	{
		jc_AddHoldAction := A_LoopField

		Loop, parse, HoldActions, |
			if A_Index = %jc_AddHoldAction%
				jc_AddHoldName = %A_LoopField%

		Loop, parse, HoldActionsDesc, |
			if A_Index = %jc_AddHoldAction%
				jc_AddHoldDesc = %A_LoopField%

		IfNotInString, jc_currentHoldActions, %jc_AddHoldName%
		{
			jc_CurrentHoldActions = %jc_CurrentHoldActions%|%jc_AddHoldName%
			GuiControl,,jc_ListboxCurrentHoldActions,%jc_AddHoldDesc%
		}
	}
return

jc_editButton_addShort:
	GuiDefault("JoyControl_ButtonEdit")
	GuiControlGet, jc_ShortActionsToAdd,,jc_ListboxActions

	Loop, parse, jc_ShortActionsToAdd, |
	{
		jc_AddShortAction := A_LoopField

		Loop, parse, Actions, |
			if A_Index = %jc_AddShortAction%
				jc_AddShortName = %A_LoopField%

		Loop, parse, ActionsDesc, |
			if A_Index = %jc_AddShortAction%
				jc_AddShortDesc = %A_LoopField%

		IfNotInString, jc_currentShortActions, %jc_AddShortName%
		{
			jc_CurrentShortActions = %jc_CurrentShortActions%|%jc_AddShortName%
			GuiControl,,jc_ListboxCurrentShortActions,%jc_AddShortDesc%
		}
	}
return

jc_editButton_addLong:
	GuiDefault("JoyControl_ButtonEdit")
	GuiControlGet, jc_LongActionsToAdd,,jc_ListboxActions

	Loop, parse, jc_LongActionsToAdd, |
	{
		jc_AddLongAction := A_LoopField

		Loop, parse, Actions, |
			if A_Index = %jc_AddLongAction%
				jc_AddLongName = %A_LoopField%

		Loop, parse, ActionsDesc, |
			if A_Index = %jc_AddLongAction%
				jc_AddLongDesc = %A_LoopField%

		IfNotInString, jc_currentLongActions, %jc_AddLongName%
		{
			jc_CurrentLongActions = %jc_CurrentLongActions%|%jc_AddLongName%
			GuiControl,,jc_ListboxCurrentLongActions,%jc_AddLongDesc%
		}
	}
return


jc_editButton_removeHold:
	GuiDefault("JoyControl_ButtonEdit")
	jc_HoldActionsToRemove =
	GuiControlGet, jc_HoldActionsToRemove,,jc_ListboxCurrentHoldActions

	if jc_HoldActionsToRemove =
		jc_HoldActionsToRemove = 1
	else
		Sort jc_HoldActionsToRemove, N R d|
	jc_removeNo =
	Loop, parse, jc_HoldActionsToRemove, |
	{
		jc_removeNo := A_LoopField
		Loop, parse, jc_CurrentHoldActions,|
		{
			if A_Index = %jc_removeNo%
			{
				StringReplace,jc_CurrentHoldActions,jc_CurrentHoldActions,|%A_LoopField%
				If ErrorLevel
					StringReplace,jc_CurrentHoldActions,jc_CurrentHoldActions,%A_LoopField%|
					If ErrorLevel
						StringReplace,jc_CurrentHoldActions,jc_CurrentHoldActions,%A_LoopField%
			}
		}
	}

	StringReplace,jc_CurrentHoldActions,jc_CurrentHoldActions,||,|,1
	GuiControl,,jc_ListboxCurrentHoldActions,|
	GuiControl,,jc_ListboxCurrentHoldActions,% descHoldActionsString(jc_CurrentHoldActions)
return

jc_editButton_removeLong:
	GuiDefault("JoyControl_ButtonEdit")
	jc_LongActionsToRemove =
	GuiControlGet, jc_LongActionsToRemove,,jc_ListboxCurrentLongActions

	if jc_LongActionsToRemove =
		jc_LongActionsToRemove = 1
	else
		Sort jc_LongActionsToRemove, N R d|
	jc_removeNo =
	Loop, parse, jc_LongActionsToRemove, |
	{
		jc_removeNo := A_LoopField
		Loop, parse, jc_CurrentLongActions,|
		{
			if A_Index = %jc_removeNo%
			{
				StringReplace,jc_CurrentLongActions,jc_CurrentLongActions,|%A_LoopField%
				If ErrorLevel
					StringReplace,jc_CurrentLongActions,jc_CurrentLongActions,%A_LoopField%|
					If ErrorLevel
						StringReplace,jc_CurrentLongActions,jc_CurrentLongActions,%A_LoopField%
			}
		}
	}

	StringReplace,jc_CurrentLongActions,jc_CurrentLongActions,||,|,1
	GuiControl,,jc_ListboxCurrentLongActions,|
	GuiControl,,jc_ListboxCurrentLongActions,% descActionsString(jc_CurrentLongActions)
return

jc_editButton_removeShort:
	GuiDefault("JoyControl_ButtonEdit")
	jc_ShortActionsToRemove =
	GuiControlGet, jc_ShortActionsToRemove,,jc_ListboxCurrentShortActions

	if jc_ShortActionsToRemove =
		jc_ShortActionsToRemove = 1
	else
		Sort jc_ShortActionsToRemove, N R d|
	jc_removeNo =
	Loop, parse, jc_ShortActionsToRemove, |
	{
		jc_removeNo := A_LoopField
		Loop, parse, jc_CurrentShortActions,|
		{
			if A_Index = %jc_removeNo%
			{
				StringReplace,jc_CurrentShortActions,jc_CurrentShortActions,|%A_LoopField%
				If ErrorLevel
					StringReplace,jc_CurrentShortActions,jc_CurrentShortActions,%A_LoopField%|
					If ErrorLevel
						StringReplace,jc_CurrentShortActions,jc_CurrentShortActions,%A_LoopField%
			}
		}
	}

	StringReplace,jc_CurrentShortActions,jc_CurrentShortActions,||,|,1
	GuiControl,,jc_ListboxCurrentShortActions,|
	GuiControl,,jc_ListboxCurrentShortActions,% descActionsString(jc_CurrentShortActions)
return

jc_setDefaultButtons:
	jc_Button1Hold =LeftClick
	jc_Button2Hold =RightClick
	jc_Button3Hold =
	jc_Button3Short =Key
	jc_Button3ShortPara ={Space}
	jc_Button3Long =Key
	jc_Button3LongPara ={Enter}
	jc_Button4Hold =
	jc_Button4Short =CenterWindow
	jc_Button5Hold =HighSense|Shift
	jc_Button6Hold =
	jc_Button6Short =AltTab
	jc_Button6Long =AltTabMenu
	jc_Button7Hold =LowSense|Control
	jc_Button8Hold =ScrollMode
	jc_ButtonPUHold =ArrowUp
	jc_ButtonPRHold =ArrowRight
	jc_ButtonPLHold =ArrowLeft
	jc_ButtonPDHold =ArrowDown

	loop, 12
		jc_finishButtonChange(A_Index)

	jc_finishButtonChange("PU")
	jc_finishButtonChange("PD")
	jc_finishButtonChange("PL")
	jc_finishButtonChange("PR")
return

jc_finishButtonChange(num)
{
	jc_calcButtonText(num)
	jc_controlToUpdate = jc_Button%num%Text
	GuiControl,,%jc_controlToUpdate%,% jc_Button%num%Text
}

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_JoyControl:
	; Hier kommen die Befehle hin, welche bei Win+F5 ausgeführt werden
Return

; -----------------------------------------------------------------------------
; === Analog Sticks + POV Control =============================================
; -----------------------------------------------------------------------------
jc_WatchAnalogOne:
	jc_AnalogOneAction := false  ; Set default.
	jc_xDiff := 0
	jc_yDiff := 0
	SetFormat, float, 03
	GetKeyState, jc_AnalogOneX, %jc_JoystickNumber%JoyX
	GetKeyState, jc_AnalogOneY, %jc_JoystickNumber%JoyY

	if jc_AnalogOneX > %jc_JoyThresholdUpper%
	{
		jc_dX := jc_AnalogOneX - jc_JoyThresholdUpper
		jc_AnalogOneAction := true
	}
	else if jc_AnalogOneX < %jc_JoyThresholdLower%
	{
		jc_dX := jc_AnalogOneX - jc_JoyThresholdLower
		jc_AnalogOneAction := true
	}
	else
		jc_dX = 0

	if jc_AnalogOneY > %jc_JoyThresholdUpper%
	{
		jc_dY := jc_AnalogOneY - jc_JoyThresholdUpper
		jc_AnalogOneAction := true
	}
	else if jc_AnalogOneY < %jc_JoyThresholdLower%
	{
		jc_dY := jc_AnalogOneY - jc_JoyThresholdLower
		jc_AnalogOneAction := true
	}
	else
		jc_dY = 0

	if jc_AnalogOneAction
	{

		SetMouseDelay, -1  ; Makes movement smoother.
		jc_xDiff := jc_dX * jc_JoyMultiplier
		jc_yDiff := jc_dY * jc_JoyMultiplier * jc_YAxisMultiplier

		if jc_switchSticks = 1
			jc_moveWindow(jc_xDiff,jc_yDiff)
		else
			jc_moveMouse(jc_xDiff,jc_yDiff)
	}
return

jc_WatchAnalogTwo:
	jc_AnalogTwoAction := false  ; Set default.
	SetFormat, float, 03
	GetKeyState, jc_AnalogTwoX, %jc_JoystickNumber%JoyZ
	GetKeyState, jc_AnalogTwoY, %jc_JoystickNumber%JoyR
	if jc_AnalogTwoX > %jc_Joy2ThresholdUpper%
	{
		jc_dX := jc_AnalogTwoX - jc_Joy2ThresholdUpper
		jc_AnalogTwoAction := true
	}
	else if jc_AnalogTwoX < %jc_Joy2ThresholdLower%
	{
		jc_dX := jc_AnalogTwoX - jc_Joy2ThresholdLower
		jc_AnalogTwoAction := true
	}
	else
		jc_dX = 0

	if jc_AnalogTwoY > %jc_Joy2ThresholdUpper%
	{
		jc_dY := jc_AnalogTwoY - jc_Joy2ThresholdUpper
		jc_AnalogTwoAction := true
	}
	else if jc_AnalogTwoY < %jc_Joy2ThresholdLower%
	{
		jc_dY := jc_AnalogTwoY - jc_Joy2ThresholdLower
		jc_AnalogTwoAction := true
	}
	else
		jc_dY = 0

	if jc_AnalogTwoAction
	{
		SetMouseDelay, -1  ; Makes movement smoother.
		jc_xDiff := jc_dX * jc_Joy2Multiplier
		jc_yDiff := jc_dY * jc_Joy2Multiplier * jc_YAxisMultiplier

		if jc_switchSticks = 1
			jc_moveMouse(jc_xDiff,jc_yDiff)
		else
			jc_moveWindow(jc_xDiff,jc_yDiff)
	}
return

jc_WatchPov:
	GetKeyState, jc_JoyPOV, %jc_JoystickNumber%JoyPOV

	if (jc_JoyPov != jc_prevPov)
	{
		jc_reactToPov(jc_getPovDirection(jc_JoyPov))
		jc_prevPov := jc_JoyPOV
	}
return

jc_getPovDirection(angle)
{
	if angle = -1  ; No angle.
		return 0

	direction := angle // 4500 + 1
	return direction
}

jc_reactToPov(direction)
{
	Global jc_povPushString, jc_povReleaseString

	jc_getPovStrings(direction)
	jc_pushPovString(jc_povPushString)
	jc_releasePovString(jc_povReleaseString)
}

jc_getPovStrings(direction)
{
	Global jc_povPushString, jc_povReleaseString

	jc_povPushString =

	if direction in 8,1,2
		jc_povPushString = %jc_povPushString%U

	if direction in 2,3,4
		jc_povPushString = %jc_povPushString%R

	if direction in 6,5,4
		jc_povPushString = %jc_povPushString%D

	if direction in 8,7,6
		jc_povPushString = %jc_povPushString%L

	jc_povReleaseString = URDL
	Loop, Parse, jc_povPushString
		StringReplace, jc_povReleaseString, jc_povReleaseString, %A_LoopField%
}

jc_pushPovString(release)
{
	Global

	Loop, Parse, release
	{
		jc_povLoopDirection = %A_LoopField%

		if jc_ButtonP%jc_povLoopDirection%Hold =
		{
			loop, 15
			{
				Sleep, 1
				GetKeyState, jc_JoyPOV, %jc_JoystickNumber%JoyPOV
				jc_getPovStrings(jc_getPovDirection(jc_JoyPov))

				Loop, Parse, jc_povReleaseString
				{
					if A_LoopField = %jc_povLoopDirection%
					{
						performAction(jc_ButtonP%jc_povLoopDirection%Short,jc_ButtonP%jc_povLoopDirection%ShortPara)
						return
					}
				}
			}

			if jc_ButtonP%A_LoopField%Long =
				performAction(jc_ButtonP%jc_povLoopDirection%Short,jc_ButtonP%jc_povLoopDirection%ShortPara)
			else
				performAction(jc_ButtonP%jc_povLoopDirection%Long,jc_ButtonP%jc_povLoopDirection%LongPara)
			return
		}
		else
		{
			SetMouseDelay, -1
			performHoldAction(jc_ButtonP%jc_povLoopDirection%Hold,jc_ButtonP%jc_povLoopDirection%HoldPara)
		}
	}
}

jc_releasePovString(release)
{
	Global

	Loop, Parse, release
	{
		if jc_ButtonP%A_LoopField%Hold !=
		{
			finishHoldAction(jc_ButtonP%A_LoopField%Hold)
		}
	}
}

return

jc_moveMouse(jc_xDiff,jc_yDiff)
{
	Global jc_WheelMode

	if jc_WheelMode = 1
	{
		scroll := abs(floor(jc_yDiff//3)) + 1

		if jc_yDiff > 0
		{
			MouseClick, WheelDown, , , scroll
		}
		else if jc_yDiff < 0
		{
			MouseClick, WheelUp, , , scroll
		}
	}
	else
		If ((jc_xDiff <> 0 OR jc_yDiff <> 0) AND (jc_xDiff <> "" AND jc_yDiff <> "") )
			MouseMove(jc_xDiff, jc_yDiff, 0, "R")
;      MouseMove, %jc_xDiff%, %jc_yDiff%, 0, R
}

jc_moveWindow(jc_xDiff,jc_yDiff)
{
	If ((jc_xDiff = 0 AND jc_yDiff = 0) OR (jc_xDiff = "" AND jc_yDiff = "") )
		Return
	WinGetActiveTitle, Haystack
	WinGetPos, oldX, oldY,,, A
	WinMove, A,, oldX+jc_xDiff,oldY+jc_yDiff
}

; -----------------------------------------------------------------------------
; === Button Events + Handling ================================================
; -----------------------------------------------------------------------------
jc_ButtonOne:
	jc_pushButton(1)
return

jc_ButtonTwo:
	jc_pushButton(2)
return

jc_ButtonThree:
	jc_pushButton(3)
return

jc_ButtonFour:
	jc_pushButton(4)
return

jc_ButtonFive:
	jc_pushButton(5)
return

jc_ButtonSix:
	jc_pushButton(6)
return

jc_ButtonSeven:
	jc_pushButton(7)
return

jc_ButtonEight:
	jc_pushButton(8)
return

jc_ButtonNine:
	jc_pushButton(9)
return

jc_ButtonTen:
	jc_pushButton(10)
return

jc_ButtonEleven:
	jc_pushButton(11)
return

jc_ButtonTwelve:
	jc_pushButton(12)
return

jc_Button1UpYet:
	if GetKeyState(jc_JoystickPrefix . 1)
		return

	SetTimer, jc_Button1UpYet, off
	finishHoldAction(jc_Button1Hold)
return

jc_Button2UpYet:
	if GetKeyState(jc_JoystickPrefix . 2)
		return

	SetTimer, jc_Button2UpYet, off
	finishHoldAction(jc_Button2Hold)
return

jc_Button3UpYet:
	if GetKeyState(jc_JoystickPrefix . 3)
		return

	SetTimer, jc_Button3UpYet, off
	finishHoldAction(jc_Button3Hold)
return

jc_Button4UpYet:
	if GetKeyState(jc_JoystickPrefix . 4)
		return

	SetTimer, jc_Button4UpYet, off
	finishHoldAction(jc_Button4Hold)
return

jc_Button5UpYet:
	if GetKeyState(jc_JoystickPrefix . 5)
		return

	SetTimer, jc_Button5UpYet, off
	finishHoldAction(jc_Button5Hold)
return

jc_Button6UpYet:
	if GetKeyState(jc_JoystickPrefix . 6)
		return

	SetTimer, jc_Button6UpYet, off
	finishHoldAction(jc_Button6Hold)
return

jc_Button7UpYet:
	if GetKeyState(jc_JoystickPrefix . 7)
		return

	SetTimer, jc_Button7UpYet, off
	finishHoldAction(jc_Button7Hold)
return

jc_Button8UpYet:
	if GetKeyState(jc_JoystickPrefix . 8)
		return

	SetTimer, jc_Button8UpYet, off
	finishHoldAction(jc_Button8Hold)
return

jc_Button9UpYet:
	if GetKeyState(jc_JoystickPrefix . 9)
		return

	SetTimer, jc_Button9UpYet, off
	finishHoldAction(jc_Button9Hold)
return

jc_Button10UpYet:
	if GetKeyState(jc_JoystickPrefix . 10)
		return

	SetTimer, jc_Button10UpYet, off
	finishHoldAction(jc_Button10Hold)
return

jc_Button11UpYet:
	if GetKeyState(jc_JoystickPrefix . 11)
		return

	SetTimer, jc_Button11UpYet, off
	finishHoldAction(jc_Button11Hold)
return

jc_Button12UpYet:
	if GetKeyState(jc_JoystickPrefix . 12)
		return

	SetTimer, jc_Button12UpYet, off
	finishHoldAction(jc_Button12Hold)
return

jc_pushButton(num)
{
	Global jc_JoyStickPrefix

	if jc_Button%num%Hold =
	{
		loop, 15
		{
			Sleep, 1
			jc_buttonNo = %jc_JoystickPrefix%%num%
			GetKeyState, jc_state%num%, %jc_buttonNo%

			if jc_state%num% = U
			{
				performAction(jc_Button%num%Short,jc_Button%num%ShortPara)
				return
			}
		}

		if jc_Button%num%Long =
			performAction(jc_Button%num%Short,jc_Button%num%ShortPara)
		else
			performAction(jc_Button%num%Long,jc_Button%num%LongPara)
		return
	}
	else
	{
		SetMouseDelay, -1
		performHoldAction(jc_Button%num%Hold,jc_Button%num%HoldPara)
		SetTimer, jc_Button%num%UpYet, 10
	}
}


; -----------------------------------------------------------------------------
; === Actions =================================================================
; -----------------------------------------------------------------------------
registerActions:
	registerHoldAction("LeftClick",lng_jc_actions_leftClick,"jc_LeftClick","jc_LeftClickRelease")
	registerHoldAction("RightClick",lng_jc_actions_rightClick,"jc_RightClick","jc_RightClickRelease")
	registerHoldAction("HighSense",lng_jc_actions_highSense,"jc_HighSense","jc_NormalSense")
	registerHoldAction("LowSense",lng_jc_actions_lowSense,"jc_LowSense","jc_NormalSense")
	registerHoldAction("Shift",lng_jc_actions_shift,"jc_Shift","jc_ShiftRelease")
	registerHoldAction("Control",lng_jc_actions_ctrl,"jc_Ctrl","jc_CtrlRelease")
	registerHoldAction("Alt",lng_jc_actions_alt,"jc_Alt","jc_AltRelease")
	registerHoldAction("ArrowUp",lng_jc_actions_arrowUp,"jc_ArrowUp","jc_ArrowUpRelease")
	registerHoldAction("ArrowDown",lng_jc_actions_arrowDown,"jc_ArrowDown","jc_ArrowDownRelease")
	registerHoldAction("ArrowLeft",lng_jc_actions_arrowLeft,"jc_ArrowLeft","jc_ArrowLeftRelease")
	registerHoldAction("ArrowRight",lng_jc_actions_arrowRight,"jc_ArrowRight","jc_ArrowRightRelease")
	registerHoldAction("ScrollMode",lng_jc_actions_scrollMode,"jc_WheelToggleOn","jc_WheelToggleOff")
	registerHoldAction("ChangeProfile",lng_jc_actions_changeProfile,"jc_changeHoldProfile","jc_changeToDefaultProfile")
	registerAction("ChangeProfile",lng_jc_actions_changeProfile,"jc_changeProfile")
	registerAction("NextProfile",lng_jc_actions_nextProfile,"jc_nextProfile")
	registerAction("CenterWindow",lng_jc_actions_centerWindow,"jc_centerWindow")
	registerAction("AltTab",lng_jc_actions_altTab,"jc_AltTab")
	registerAction("AltTabMenu",lng_jc_actions_altTabMenu,"jc_AltTabMenu")
	registerAction("RunFolder",lng_jc_actions_runFolder,"jc_RunFolder")
	registerAction("Key",lng_jc_actions_key,"jc_SingleKey")
return

jc_testForExtension(name)
{
	Global ConfigFile

	jc_EnableString = Enable_%name%
	IniRead, jc_test, %ConfigFile%, activAid, %jc_EnableString%,%A_Space%

	return jc_test
}

jc_LeftClick:
	MouseClick, left,,, 1, 0, D  ; Hold down the left mouse button.
return

jc_LeftClickRelease:
	MouseClick, left,,, 1, 0, U  ; Release the mouse button.

	;Linksklick-Kompatibilität zu RealExpose
	if (IsLabel("init_TypeWith9Keys") && jc_testForExtension("TypeWith9Keys"))
	{
		do = rex_Window_Activate
		IfWinActive , »Expose«
			gosub, %do%
	}
return

jc_RightClick:
	MouseClick, right,,, 1, 0, D  ; Hold down the left mouse button.
return

jc_RightClickRelease:
	MouseClick, right,,, 1, 0, U  ; Release the mouse button.
return

jc_WheelToggleOn:
	jc_wheelMode := 1
return

jc_WheelToggleOff:
	jc_wheelMode := 0
return

jc_Ctrl:
	Send {Ctrl Down}
return

jc_CtrlRelease:
	Send {Ctrl Up}
return

jc_Shift:
	Send {Shift Down}
return

jc_ShiftRelease:
	Send {Shift Up}
return

jc_Alt:
	Send {Alt Down}
return

jc_AltRelease:
	Send {Alt Up}
return

jc_ArrowUp:
	SetTimer, jc_sendArrowUp, %jc_ArrowKeysDelay%
return

jc_ArrowUpRelease:
	SetTimer, jc_sendArrowUp, off
return

jc_sendArrowUp:
	IfWinNotActive, T9
		Send {Up}
return

jc_ArrowLeft:
	SetTimer, jc_sendArrowLeft, %jc_ArrowKeysDelay%
return

jc_ArrowLeftRelease:
	SetTimer, jc_sendArrowLeft, off
return

jc_sendArrowLeft:
	IfWinNotActive, T9
		Send {Left}
return

jc_ArrowDown:
	SetTimer, jc_sendArrowDown, %jc_ArrowKeysDelay%
return

jc_ArrowDownRelease:
	SetTimer, jc_sendArrowDown, off
return

jc_sendArrowDown:
	IfWinNotActive, T9
		Send {Down}
return

jc_ArrowRight:
	SetTimer, jc_sendArrowRight, %jc_ArrowKeysDelay%
return

jc_ArrowRightRelease:
	SetTimer, jc_sendArrowRight, off
return

jc_sendArrowRight:
	IfWinNotActive, T9
		Send {Right}
return

jc_NormalSense:
	jc_JoyMultiplier := jc_JoyMultiplierNormal
	jc_Joy2Multiplier := jc_Joy2MultiplierNormal
return

jc_LowSense:
	jc_JoyMultiplier *= jc_TurtleMultiplier
	jc_Joy2Multiplier *= jc_TurtleMultiplier
return

jc_HighSense:
	jc_JoyMultiplier *= jc_SpeedMultiplier
	jc_Joy2Multiplier *= jc_SpeedMultiplier
return

jc_SingleKey:
	Send %ActionParameter%
return

jc_AltTab:
	Send !+{Tab}
return

jc_AltTabMenu:
	Run, %A_AhkPath% "%A_ScriptDir%/Extensions/ac'tivAid_JoyControl_showTabs.ahk"
return

jc_RunFolder:
	Run, %A_AhkPath% "%A_ScriptDir%/Extensions/ac'tivAid_JoyControl_runFolder.ahk" "%ActionParameter%" %jc_runFolder_useIcons%
return

jc_CenterWindow:
	jc_MoveWindowToMousePosition()
return

jc_MoveWindowToMousePosition()
{
	WinGetPos,winX,winY,winWidth,winHeight,A
	CoordMode, Mouse, Screen
	MouseGetPos, mouseX, mouseY
	newPosX := mouseX-(winWidth//2)
	newPosY := mouseY-(winHeight//2)
	if newPosX < 0
	  newPosX := 0
	if newPosY < 0
	  newPosY := 0
	;msgbox, Window is %winWidth%x%winHeight%@%winX%.%winY%->%newPosX%.%newPosY%
	WinMove, A,, newPosX, newPosY
}
