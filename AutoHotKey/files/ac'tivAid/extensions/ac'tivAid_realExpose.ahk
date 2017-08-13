; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               RealExpose
; -----------------------------------------------------------------------------
; Prefix:             rex_
; Version:            0.3
; Date:               2008-05-23
; Author:             Holomind, David Hilberath,
;                     http://www.autohotkey.com/wiki/index.php?title=Expose_Clone
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------
#include %A_ScriptDir%\Library\GDI.ahk

init_RealExpose:
	Prefix = rex
	%Prefix%_ScriptName    = RealExpose
	%Prefix%_ScriptVersion = 0.3
	%Prefix%_Author        = Holomind (AHK Forum), David Hilberath

	CustomHotkey_RealExpose = 1
	Hotkey_RealExpose       = #Tab
	HotkeyPrefix_RealExpose =

	IconFile_On_RealExpose = %A_WinDir%\system32\shell32.dll
	IconPos_On_RealExpose = 170

	CreateGuiID("RealExpose_GUI")

	Gosub, Language_RealExpose
	Gosub, LoadSettings_RealExpose

	SetWinDelay 0               ; larger values also fail under heavy load, changing windows
	;Process Priority,,Above Normal
	CoordMode Mouse, Relative

	RegisterAdditionalSetting("rex","watchResolution",1)
	RegisterAdditionalSetting("rex","ForceAllWindows",1)
	If Hotkey_RealExpose = #Tab
		RegisterAdditionalSetting("rex","AltTabReplacement",0)
	RegisterAdditionalSetting("rex","ShowWindowInfo",1)
	gosub, rex_main

	rex_enabled = 0
	rex_OSAnimation := rex_minAnimation()
Return

rex_resolutionChange:
	Gosub, rex_shutDownBuffers
	Gosub, rex_main
return

rex_main:
	Gosub, rex_Detect_Screensize
	Gosub, rex_Create_Gui
	Gosub, rex_Create_Buffers
return

Language_RealExpose:
	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %rex_ScriptName% - Exposé Clone
		Description                   = Alt-Tab Ersatz, ähnlich Exposé von Mac OS X

		lng_rex_min_w                 = Minimale Breite
		lng_rex_min_h                 = Minimale Höhe
		lng_rex_scale_thumb_space     = Vorschaubilder vergrößern
		lng_rex_live_redraw           = Vorschaubilder ständig aktualisieren
		lng_rex_time_gap              = Verzögerung (geringere CPU-Last)
		lng_rex_thumb_border          = Abstand halten
		lng_rex_animate_in_delay      = Animate-In-Verzögerung
		lng_rex_animate_in_steps      = Animate-In-Schritte
		lng_rex_animate_out_delay     = Animate-Out-Verzögerung
		lng_rex_animate_out_steps     = Animate-Out-Schritte
		lng_rex_show_taskbar          = Taskleiste anzeigen
		lng_rex_show_desktop_image    = Hintergrundbild anzeigen
		lng_rex_fast_redraw_mode      = Schnelle Aktualisierung
		lng_rex_quality_low           = Niedrige Qualität
		lng_rex_quality_high          = Hohe Qualität
		lng_rex_watchResolution       = Auflösungsänderungen beobachten
		lng_rex_ForceAllWindows       = Auch minimierte Fenster zeigen
		lng_rex_EnableAnimations      = Animationen
		lng_rex_AltTabReplacement     = Win+Tab verhält sich wie Alt+Tab
		lng_rex_AdvancedOptions       = Erweiterte Optionen
		lng_rex_cpuSlider             = Aktualisierungsrate
		lng_rex_aniSlider             = Animationsqualität
		lng_rex_lenSlider             = Animationsdauer
		lng_rex_imgSlider             = Bildqualität
		lng_rex_off                   = Aus
		lng_rex_Frames                = Frames
		lng_rex_Extrem                = Extrem
		lng_rex_Niedrig               = Niedrig
		lng_rex_Mittel                = Mittel
		lng_rex_Hoch                  = Hoch
		lng_rex_ShowWindowInfo        = Fensterinformationen anzeigen
		lng_rex_IgnoreAppsEnabled     = Folgende Anwendungen nicht anzeigen
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %rex_ScriptName% - Exposé Clone
		Description                   = Alt-Tab replacement

		lng_rex_min_w                 = Minimum Width
		lng_rex_min_h                 = Minimum Height
		lng_rex_scale_thumb_space     = Scale thumbs
		lng_rex_live_redraw           = Live redraw
		lng_rex_time_gap              = Time gap
		lng_rex_thumb_border          = Gap between thumbs
		lng_rex_animate_in_delay      = Animate-In Delay
		lng_rex_animate_in_steps      = Animate-In Steps
		lng_rex_animate_out_delay     = Animate-Out Delay
		lng_rex_animate_out_steps     = Animate-Out Steps
		lng_rex_show_taskbar          = Show taskbar
		lng_rex_show_desktop_image    = Show desktop image
		lng_rex_fast_redraw_mode      = Fast redraw mode
		lng_rex_quality_low           = Quality Low
		lng_rex_quality_high          = Quality High
		lng_rex_watchResolution       = Watch resolution changes
		lng_rex_ForceAllWindows       = Show minimized windows
		lng_rex_EnableAnimations      = Animations
		lng_rex_AltTabReplacement     = Win+Tab behaves like Alt+Tab
		lng_rex_AdvancedOptions       = Advanced Options
		lng_rex_cpuSlider             = Refresh rate
		lng_rex_aniSlider             = Animation quality
		lng_rex_lenSlider             = Animation duration
		lng_rex_imgSlider             = Image quality
		lng_rex_off                   = Off
		lng_rex_Frames                = Frames
		lng_rex_Extrem                = Extreme
		lng_rex_Niedrig               = Low
		lng_rex_Mittel                = Medium
		lng_rex_Hoch                  = High
		lng_rex_ShowWindowInfo        = Show window informatinos
		lng_rex_IgnoreAppsEnabled     = Don't show the following applications:
	}
return

SettingsGui_RealExpose:
	Gui, Add, CheckBox, YS+14 XS+395 w120 -Wrap grex_sub_CheckIfSettingsChanged vrex_AdvancedOptions Checked%rex_AdvancedOptions%, %lng_rex_AdvancedOptions%

	Gui, Add, Text, w170 XS+10 YS+50 vrex_Text5, %lng_rex_min_w%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged X+5 vrex_min_w w40, %rex_min_w%
	Gui, Add, Text, w170 XS+10 Y+7 vrex_Text6, %lng_rex_min_h%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged X+5 vrex_min_h w40, %rex_min_h%
	Gui, Add, Text, w170 XS+10 Y+7 vrex_Text7, %lng_rex_time_gap%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged X+5 vrex_time_gap w40, %rex_time_gap%
	Gui, Add, Text, w170 XS+10 Y+7 vrex_Text8, %lng_rex_quality_low%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged X+5 vrex_quality_low w40, %rex_quality_low%
	Gui, Add, Text, w170 XS+10 Y+7 vrex_Text9, %lng_rex_quality_high%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged X+5 vrex_quality_high w40, %rex_quality_high%

	Gui, Add, GroupBox, w210 ys+50 xs+250 h125 vrex_Groupbox
	Gui, Add, CheckBox, yp+0 xp+10 w30 BackgroundTrans -Wrap grex_sub_CheckIfSettingsChanged vrex_EnableAnimations Checked%rex_EnableAnimations%, %lng_rex_EnableAnimations%
	Gui, Add, Text, w140 y+12 xs+260 vrex_Text1, %lng_rex_animate_in_delay%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged X+5 vrex_animate_in_delay w40, %rex_animate_in_delay%
	Gui, Add, Text, w140 y+7 xs+260 vrex_Text2, %lng_rex_animate_in_steps%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged X+5 vrex_animate_in_steps w40, %rex_animate_in_steps%
	Gui, Add, Text, w140 y+7 xs+260 vrex_Text3, %lng_rex_animate_out_delay%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged X+5 vrex_animate_out_delay w40, %rex_animate_out_delay%
	Gui, Add, Text, w140 y+7 xs+260 vrex_Text4, %lng_rex_animate_out_steps%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged X+5 vrex_animate_out_steps w40, %rex_animate_out_steps%

	Gui, Add, CheckBox, xs+10 ys+190 vrex_live_redraw gsub_CheckIfSettingsChanged Checked%rex_live_redraw%, %lng_rex_live_redraw%
	Gui, Add, CheckBox, xs+30 y+7 vrex_fast_redraw_mode gsub_CheckIfSettingsChanged Checked%rex_fast_redraw_mode%, %lng_rex_fast_redraw_mode%
	Gui, Add, CheckBox, xs+10 y+7 vrex_scale_thumb_space gsub_CheckIfSettingsChanged Checked%rex_scale_thumb_space%, %lng_rex_scale_thumb_space%
	Gui, Add, CheckBox, xs+215 ys+190 vrex_thumb_border gsub_CheckIfSettingsChanged Checked%rex_thumb_border%, %lng_rex_thumb_border%
	Gui, Add, CheckBox, xs+215 y+7 vrex_show_desktop_image gsub_CheckIfSettingsChanged Checked%rex_show_desktop_image%, %lng_rex_show_desktop_image%
	Gui, Add, CheckBox, xs+215 y+7 vrex_show_taskbar gsub_CheckIfSettingsChanged Checked%rex_show_taskbar%, %lng_rex_show_taskbar%

	Gui, Add, Groupbox, w200 h90 xs+365 ys+190
	Gui, Add, Checkbox, xp+10 yp-5 w180 checked%rex_IgnoreAppsEnabled% vrex_IgnoreAppsEnabled grex_sub_CheckIfSettingsChanged, %lng_rex_IgnoreAppsEnabled%
	StringReplace, rex_IgnoreApps_Box, rex_IgnoreApps , `, , | , a
	Gui, Add, Listbox, w190 h50 xp-5 yp+28 vrex_IgnoreApps_Box_tmp, %rex_IgnoreApps_Box%
	Gui, Add, Button, y+5 w37 h15 vrex_Add_IgnoreApps_Box gsub_ListBox_addApp, +
	Gui, Add, Button, x+5 w38 h15 vrex_Remove_IgnoreApps_Box gsub_ListBox_remove, %MinusString%

	Gui, Add, Text, w140 XS+10 YS+50 vrex_Text10, %lng_rex_cpuSlider%:
	Gui, Add, Slider, AltSubmit yp-2 h20 grex_sub_CheckIfSettingsChanged X+5 vrex_cpuSlider w340 Range0-10 Invert, %rex_cpuSlider%
	Gui, Add, Text, w60 x+5 yp+2 vrex_cpuSlider_text,

	Gui, Add, Text, w140 Xs+10 Y+20 vrex_Text11, %lng_rex_imgSlider%:
	Gui, Add, Slider, AltSubmit yp-2 h20 grex_sub_CheckIfSettingsChanged X+5 vrex_imgSlider w340 Range1-10, %rex_imgSlider%
	Gui, Add, Text, w60 x+5 yp+2 vrex_imgSlider_text,

	Gui, Add, Text, w140 Xs+10 Y+20 vrex_Text12, %lng_rex_aniSlider%:
	Gui, Add, Slider, AltSubmit yp-2 h20 grex_sub_CheckIfSettingsChanged X+5 vrex_aniSlider w340 Range1-1000, %rex_aniSlider%
	Gui, Add, Text, w60 x+5 yp+2 vrex_aniSlider_text,

	Gui, Add, Text, w140 Xs+10 Y+20 vrex_Text13, %lng_rex_lenSlider%:
	Gui, Add, Slider, AltSubmit yp-2 h20 grex_sub_CheckIfSettingsChanged X+5 vrex_lenSlider w340 Range0-40, %rex_lenSlider%
	Gui, Add, Text, w60 x+5 yp+2 vrex_lenSlider_text,

	Gosub, rex_sub_CheckIfSettingsChanged
Return

rex_sub_CheckIfSettingsChanged:
	Gosub, sub_CheckIfSettingsChanged

	GuiControlGet, rex_IgnoreAppsEnabled_tmp,, rex_IgnoreAppsEnabled
	GuiControl, Enable%rex_IgnoreAppsEnabled_tmp%, rex_IgnoreApps_Box_tmp
	GuiControl, Enable%rex_IgnoreAppsEnabled_tmp%, rex_Add_IgnoreApps_Box
	GuiControl, Enable%rex_IgnoreAppsEnabled_tmp%, rex_Remove_IgnoreApps_Box

	GuiControlGet, rex_AdvancedOptions_tmp,,rex_AdvancedOptions
	rex_Group1 = rex_EnableAnimations,rex_Groupbox,rex_min_w,rex_min_h,rex_time_gap, rex_quality_low, rex_quality_high,rex_Text1,rex_Text2,rex_Text3,rex_Text4,rex_Text5,rex_Text6,rex_Text7,rex_Text8,rex_Text9,rex_animate_in_delay,rex_animate_in_steps,rex_animate_out_delay,rex_animate_out_steps,rex_quality_low,rex_quality_high
	rex_Group2 = rex_Text10,rex_Text11,rex_Text12,rex_Text13,rex_cpuSlider,rex_imgSlider,rex_aniSlider,rex_lenSlider,rex_cpuSlider_text,rex_aniSlider_text,rex_lenSlider_text,rex_imgSlider_text
	If rex_AdvancedOptions_tmp = 0
	{
		Loop, Parse, rex_Group1, `,
			GuiControl, Hide, %A_LoopField%

		Loop, Parse, rex_Group2, `,
			GuiControl, Show, %A_LoopField%
	}
	Else
	{
		Loop, Parse, rex_Group2, `,
			GuiControl, Hide, %A_LoopField%

		Loop, Parse, rex_Group1, `,
			GuiControl, Show, %A_LoopField%
	}

	if rex_AdvancedOptions_tmp = 0
	{
		;CPU-Slider
		rex_new_time_gap := rex_cpuSlider * 10
		rex_time_gap := rex_new_time_gap
		GuiControl,,rex_time_gap, %rex_time_gap%
		GuiControl,,rex_cpuSlider_text, %rex_time_gap%ms

		;Animation Length-Slider
		rex_new_animationTime := rex_lenSlider * 50
		rex_maxFrames := rex_lenSlider * 4

		if rex_new_animationTime = 0
		{
			GuiControl,+Range1-1,rex_aniSlider
			GuiControl,Disable,rex_aniSlider
			rex_aniSlider := 1
			GuiControl,,rex_aniSlider, 1
			GuiControl,,rex_lenSlider_text, %lng_rex_off%
			GuiControl,,rex_aniSlider_text, %lng_rex_off%
			rex_EnableAnimations := 0
			GuiControl,,rex_EnableAnimations, 0

			if rex_imgSlider = 10
				rex_imgSlider := 9

			GuiControl,+Range1-9,rex_imgSlider
			GuiControl,Move,rex_imgSlider,W304
		}
		else
		{
			GuiControl,+Range1-%rex_maxFrames%,rex_aniSlider
			GuiControl,Enable,rex_aniSlider
			GuiControl,,rex_lenSlider_text, %rex_new_animationTime%ms

			GuiControl,+Range1-10,rex_imgSlider
			GuiControl,Move,rex_imgSlider,W340
		}

		;Animation Quality-Slider
		rex_new_animateSteps := rex_aniSlider

		if rex_aniSlider = %rex_maxFrames%
			rex_new_animateDelay := 0
		else
			rex_new_animateDelay := Floor(rex_new_animationTime / rex_aniSlider)

		rex_animate_in_delay := rex_new_animateDelay
		rex_animate_in_steps := rex_new_animateSteps
		rex_animate_out_delay := rex_new_animateDelay
		rex_animate_out_steps := rex_new_animateSteps

		GuiControl,,rex_animate_in_delay, %rex_new_animateDelay%
		GuiControl,,rex_animate_in_steps, %rex_new_animateSteps%
		GuiControl,,rex_animate_out_delay, %rex_new_animateDelay%
		GuiControl,,rex_animate_out_Steps, %rex_new_animateSteps%

		if rex_new_animationTime != 0
			GuiControl,,rex_aniSlider_text, %rex_new_animateSteps% %lng_rex_Frames%

		;Image Quality-Slider
		rex_new_quality_low := 4
		rex_new_quality_high := 4
		rex_imgSlider_text = 10 - %lng_rex_Extrem%
		if rex_imgSlider < 5
		{
			rex_new_quality_low := 1
			rex_new_quality_high := rex_imgSlider
			rex_imgSlider_text = %rex_imgSlider% - %lng_rex_Niedrig%
		}
		if (rex_imgSlider < 8 && rex_imgSlider > 3)
		{
			rex_new_quality_low := 2
			rex_new_quality_high := rex_imgSlider - 3
			rex_imgSlider_text = %rex_imgSlider% - %lng_rex_Mittel%
		}
		if (rex_imgSlider < 10 && rex_imgSlider > 7)
		{
			rex_new_quality_low := 3
			rex_new_quality_high := rex_imgSlider - 5
			rex_imgSlider_text = %rex_imgSlider% - %lng_rex_Hoch%
		}


		rex_quality_low := rex_new_quality_low
		rex_quality_high := rex_new_quality_high

		GuiControl,,rex_quality_low, %rex_quality_low%
		GuiControl,,rex_quality_high, %rex_quality_high%
		GuiControl,,rex_imgSlider_text, %rex_imgSlider_text%

	}

	GuiControlGet, rex_EnableAnimations_tmp,,rex_EnableAnimations
	rex_Group1 = rex_Text1,rex_Text2,rex_Text3,rex_Text4,rex_animate_in_delay,rex_animate_in_steps,rex_animate_out_delay,rex_animate_out_steps
	If rex_EnableAnimations_tmp = 0
	{
		Loop, Parse, rex_Group1, `,
			GuiControl, Disable, %A_LoopField%
	}
	Else
	{
		Loop, Parse, rex_Group1, `,
			GuiControl, Enable, %A_LoopField%
	}
Return

SaveSettings_RealExpose:
	IniWrite, %rex_min_w%, %ConfigFile%, %rex_ScriptName%, MinW
	IniWrite, %rex_min_h%, %ConfigFile%, %rex_ScriptName%, MinH
	IniWrite, %rex_scale_thumb_space%, %ConfigFile%, %rex_ScriptName%, ScaleThumbSpace
	IniWrite, %rex_live_redraw%, %ConfigFile%, %rex_ScriptName%, LiveRedraw
	IniWrite, %rex_time_gap%, %ConfigFile%, %rex_ScriptName%, TimeGap
	IniWrite, %rex_thumb_border%, %ConfigFile%, %rex_ScriptName%, ThumbBorder
	IniWrite, %rex_animate_in_delay%, %ConfigFile%, %rex_ScriptName%, AnimateInDelay
	IniWrite, %rex_animate_in_steps%, %ConfigFile%, %rex_ScriptName%, AnimateInSteps
	IniWrite, %rex_animate_out_delay%, %ConfigFile%, %rex_ScriptName%, AnimateOutDelay
	IniWrite, %rex_animate_out_steps%, %ConfigFile%, %rex_ScriptName%, AnimateOutSteps
	IniWrite, %rex_show_taskbar%, %ConfigFile%, %rex_ScriptName%, ShowTaskbar
	IniWrite, %rex_show_desktop_image%, %ConfigFile%, %rex_ScriptName%, ShowDesktopImage
	IniWrite, %rex_fast_redraw_mode%, %ConfigFile%, %rex_ScriptName%, FastRedrawMode
	IniWrite, %rex_quality_low%, %ConfigFile%, %rex_ScriptName%, QualityLow
	IniWrite, %rex_quality_high%, %ConfigFile%, %rex_ScriptName%, QualityHigh
	IniWrite, %rex_EnableAnimations%, %ConfigFile%, %rex_ScriptName%, EnableAnimations
	IniWrite, %rex_AdvancedOptions%, %ConfigFile%, %rex_ScriptName%, AdvancedOptions
	IniWrite, %rex_imgSlider%, %ConfigFile%, %rex_ScriptName%, ImgSlider
	IniWrite, %rex_aniSlider%, %ConfigFile%, %rex_ScriptName%, AniSlider
	IniWrite, %rex_CpuSlider%, %ConfigFile%, %rex_ScriptName%, CpuSlider
	IniWrite, %rex_LenSlider%, %ConfigFile%, %rex_ScriptName%, LenSlider

	If (func_StrLeft(rex_IgnoreApps_Box,1) = "|")
		StringTrimleft, rex_IgnoreApps_Box, rex_IgnoreApps_Box, 1
	StringReplace, rex_IgnoreApps, rex_IgnoreApps_Box, | , `, , a
	IniWrite, %rex_IgnoreApps%, %ConfigFile%, %rex_ScriptName%, IgnoreApps
	IniWrite, %rex_ignoreAppsEnabled%, %ConfigFile%, %rex_ScriptName%, IgnoreAppsEnabled

	gosub, rex_handle_exit
	Gosub, rex_Create_Buffers
Return

AddSettings_RealExpose:
Return

CancelSettings_RealExpose:
Return

LoadSettings_RealExpose:
	;Hotkey, MButton ,  Window_Send_Click
	;Hotkey, +MButton , handle_exit ; panik-key

	IniRead, rex_min_w, %ConfigFile%, %rex_ScriptName%, MinW, 110
	IniRead, rex_min_h, %ConfigFile%, %rex_ScriptName%, MinH, 110                          ; min height of windows to be shown (hides taskbar etc)
	IniRead, rex_scale_thumb_space, %ConfigFile%, %rex_ScriptName%, ScaleThumbSpace, 1   ; scale thumbnails to best fit to box?
	IniRead, rex_live_redraw, %ConfigFile%, %rex_ScriptName%, LiveRedraw, 1                ; 1/0 = Yes/No
	IniRead, rex_time_gap, %ConfigFile%, %rex_ScriptName%, TimeGap, 10                     ; ms, time left for others after each thumbnail draw
	IniRead, rex_thumb_border, %ConfigFile%, %rex_ScriptName%, ThumbBorder, 1            ; 1 for gap between thumbnail  s
	IniRead, rex_animate_in_delay, %ConfigFile%, %rex_ScriptName%, AnimateInDelay, 0
	IniRead, rex_animate_in_steps, %ConfigFile%, %rex_ScriptName%, AnimateInSteps, 5
	IniRead, rex_animate_out_delay, %ConfigFile%, %rex_ScriptName%, AnimateOutDelay, 0
	IniRead, rex_animate_out_steps, %ConfigFile%, %rex_ScriptName%, AnimateOutSteps, 5
	IniRead, rex_show_taskbar, %ConfigFile%, %rex_ScriptName%, ShowTaskbar, 1
	IniRead, rex_show_desktop_image, %ConfigFile%, %rex_ScriptName%, ShowDesktopImage, 1
	IniRead, rex_fast_redraw_mode, %ConfigFile%, %rex_ScriptName%, FastRedrawMode, 0
	IniRead, rex_quality_low, %ConfigFile%, %rex_ScriptName%, QualityLow, 3                ; allowed: 1 (terrible) , 3 (accepatable) 4 (good = slow)
	IniRead, rex_quality_high, %ConfigFile%, %rex_ScriptName%, QualityHigh, 4            ; allowed: 1 (terrible) , 3 (accepatable) 4 (good = slow)
	IniRead, rex_EnableAnimations, %ConfigFile%, %rex_ScriptName%, EnableAnimations, 1
	IniRead, rex_AdvancedOptions, %ConfigFile%, %rex_ScriptName%, AdvancedOptions, 0
	IniRead, rex_imgSlider, %ConfigFile%, %rex_ScriptName%, ImgSlider,9
	IniRead, rex_aniSlider, %ConfigFile%, %rex_ScriptName%, AniSlider,8
	IniRead, rex_CpuSlider, %ConfigFile%, %rex_ScriptName%, CpuSlider,10
	IniRead, rex_LenSlider, %ConfigFile%, %rex_ScriptName%, LenSlider,4
	IniRead, rex_ignoreApps, %ConfigFile%, %rex_ScriptName%, IgnoreApps, %A_Space%
	IniRead, rex_ignoreAppsEnabled, %ConfigFile%, %rex_ScriptName%, IgnoreAppsEnabled, 0
Return

DoEnable_RealExpose:
	Hotkey, IfWinActive, »Expose«
	Hotkey, $%Hotkey_RealExpose%, rex_Window_Activate
	Hotkey, $LButton, rex_Window_Activate
	Hotkey, $Esc, rex_hide_gui
	Hotkey, $Space, rex_toggle_fast_mode
	Hotkey, $#D, rex_Window_Activate
	Hotkey, $#M, rex_Window_Activate
	Hotkey, $*Up, rex_UpKey
	Hotkey, $*Down, rex_DownKey
	Hotkey, $*Left, rex_LeftKey
	Hotkey, $*Right, rex_RightKey
	Hotkey, $+Tab, rex_LeftKey
	Hotkey, $Tab, rex_RightKey
	Hotkey, $Enter, rex_Window_Activate
	If Hotkey_RealExpose = #Tab
	{
		Hotkey, $#+Tab, rex_LeftKeyTab
		Hotkey, $#Tab, rex_RightKeyTab
		If rex_AltTabReplacement = 1
			Hotkey, $LWin Up, rex_Window_Activate_WinUp
		Else
			Hotkey, $LWin Up, rex_Window_Activate_WinUp, Off
	}
	Hotkey, IfWinActive

	If rex_watchResolution = 1
		registerEvent("resolutionChange","rex_resolutionChange")

	rex_enabled = 1
	registerAction("RealExpose",rex_ScriptName,"sub_Action_RealExpose")

	Gosub, rex_Detect_ScreenSize
	gosub, rex_Create_Gui
Return

DoDisable_RealExpose:
	Hotkey, IfWinActive, »Expose«
	Hotkey, $%Hotkey_RealExpose%,  rex_Window_Activate, Off
	Hotkey, $LButton,  rex_Window_Activate, Off
	Hotkey, $Esc,  rex_hide_gui, Off
	Hotkey, $Space,  rex_toggle_fast_mode, Off
	Hotkey, $#D, rex_Window_Activate, Off
	Hotkey, $#M, rex_Window_Activate, Off
	Hotkey, $*Up, rex_UpKey, Off
	Hotkey, $*Down, rex_DownKey, Off
	Hotkey, $*Left, rex_LeftKey, Off
	Hotkey, $*Right, rex_RightKey, Off
	Hotkey, $+Tab, rex_LeftKey, Off
	Hotkey, $Tab, rex_RightKey, Off
	Hotkey, $Enter, rex_Window_Activate, Off
	If Hotkey_RealExpose = #Tab
	{
		Hotkey, $#+Tab, rex_LeftKeyTab, Off
		Hotkey, $#Tab, rex_RightKeyTab, Off
		Hotkey, $LWin Up, rex_Window_Activate_WinUp, Off
	}
	Hotkey, IfWinActive

	rex_enabled = 0
	unRegisterAction("RealExpose")
	unRegisterEvent("resolutionChange","rex_resolutionChange")
	gosub, rex_handle_exit
	rex_prev =
Return

DefaultSettings_RealExpose:
Return

OnExitAndReload_RealExpose:
	gosub, rex_handle_exit
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_RealExpose:
	rex_ShowOnly =

	if rex_enabled
		gosub, rex_Window_Choose
Return

sub_Action_realExpose:
	rex_ShowOnly := ActionParameter

	if rex_enabled
		gosub, rex_Window_Choose
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

rex_toggle_fast_mode:
  rex_fast_redraw_mode := !rex_fast_redraw_mode ; toggle
return


rex_Window_Hidden() {
	global
	Return rex_w < rex_min_w or rex_h < rex_min_h or rex_title ="»Expose«" or rex_title =""
}

rex_IgnoreWindow() {
	global

	if rex_IgnoreAppsEnabled
	{
		IfInString,rex_IgnoreApps,%rex_procName%
			return 1
	}

	if rex_ShowOnly !=
	{
		rex_check := 0

		StringLeft, rex_check, rex_ShowOnly, 6

		if rex_check = Class|
		{
			StringTrimLeft, rex_ShowOnly_tmp, rex_ShowOnly, 6

			IfNotInString, rex_class, %rex_ShowOnly_tmp%
				return 1
		}
		else
		{
			IfNotInString, rex_title, %rex_ShowOnly%
				return 1
		}
	}

	return 0
}

rex_Detect_ScreenSize:
  rex_Th=0
  rex_Tw=0
  rex_Ty=0
  rex_Tx=0
  if rex_show_taskbar
	 WinGetPos,rex_Tx,rex_Ty,rex_Tw,rex_Th,ahk_class Shell_TrayWnd,,,
  rex_WorkArea_Top    := ( rex_Tw > rex_Th  and  rex_Tx = 0  and  rex_Ty = 0) * rex_Th
  rex_WorkArea_Left   := ( rex_Tw < rex_Th  and  rex_Tx = 0  and  rex_Ty = 0) * rex_Tw
  rex_WorkArea_Height := ( A_ScreenHeight - ( rex_Tw > rex_Th  ) * rex_Th )
  rex_WorkArea_Width  := ( A_ScreenWidth  - ( rex_Tw < rex_Th  ) * rex_Tw )
Return

rex_Create_Gui:
	rex_Expose_ID := GuiDefault("RealExpose_GUI","+AlwaysOnTop +Owner -Caption  +Toolwindow  +LastFound")
	;rex_Expose_ID := GuiDefault("RealExpose_GUI","+LastFound")

	Gui, Show, Hide w%rex_WorkArea_Width% h%rex_WorkArea_Height% x%rex_WorkArea_Left% y%rex_WorkArea_Top%, »Expose«

	DetectHiddenWindows ON
	WinGet rex_Desktop_ID, ID, Program Manager
	DetectHiddenWindows OFF
Return

rex_Create_Buffers:
	GuiDefault("RealExpose_GUI","+AlwaysOnTop +Owner -Caption  +Toolwindow  +LastFound")
	;GuiDefault("RealExpose_GUI","+LastFound")

	rex_hdc_frontbuffer  := GetDC( rex_Expose_ID )

	rex_hdc_printwindow := CreateCompatibleDC(    rex_hdc_frontbuffer)
	rex_hbm_printwindow := CreateCompatibleBitmap(rex_hdc_frontbuffer,rex_WorkArea_Width,rex_WorkArea_Height)
	rex_hbm_old         := SelectObject(          rex_hdc_printwindow,rex_hbm_printwindow)

	rex_hdc_thumbnails  := CreateCompatibleDC(    rex_hdc_frontbuffer)
	rex_hbm_thumbnails  := CreateCompatibleBitmap(rex_hdc_frontbuffer,rex_WorkArea_Width,rex_WorkArea_Height)
	rex_hbm_old         := SelectObject(          rex_hdc_thumbnails,rex_hbm_thumbnails)

	rex_hdc_backbuffer  := CreateCompatibleDC(    rex_hdc_frontbuffer)
	rex_hbm_backbuffer  := CreateCompatibleBitmap(rex_hdc_frontbuffer,rex_WorkArea_Width,rex_WorkArea_Height)
	rex_hbm_old         := SelectObject(          rex_hdc_backbuffer,rex_hbm_backbuffer)

	if rex_show_desktop_image
	{
		rex_hdc_desktop     := CreateCompatibleDC(    rex_hdc_frontbuffer)
		rex_hbm_desktop     := CreateCompatibleBitmap(rex_hdc_frontbuffer,rex_WorkArea_Width,rex_WorkArea_Height)
		rex_hbm_old         := SelectObject(          rex_hdc_desktop,rex_hbm_desktop)

		Gui Show
		PaintDesktop( rex_hdc_frontbuffer )
		BitBlt(rex_hdc_desktop     , 0, 0, rex_WorkArea_Width, rex_WorkArea_Height, rex_hdc_frontbuffer , 0, 0 ,0xCC0020) ; SRCCOPY
		BitBlt(rex_hdc_thumbnails  , 0, 0, rex_WorkArea_Width, rex_WorkArea_Height, rex_hdc_frontbuffer , 0, 0 ,0xCC0020) ; SRCCOPY
		Gui Hide
	}

Return

rex_minAnimation(set="")
{
	VarSetCapacity(AnimationInfo, 8,0)
	cbSize := VarSetCapacity(AnimationInfo)
	NumPut(cbSize, AnimationInfo, 0, "UInt")

	if set =
	{
		DllCall("SystemParametersInfo", UInt, 0x48, UInt, cbSize, "UInt", &AnimationInfo, UInt, 1 )
		return NumGet(AnimationInfo,4)
	}

	if (set = 0 || set = 1)
	{
		NumPut(cbSize, AnimationInfo, 0, "UInt")
		NumPut(set, AnimationInfo, 4, "Int")

		DllCall("SystemParametersInfo", UInt, 0x49, UInt, cbSize, "UInt", &AnimationInfo, UInt, 1 )
		return 1
	}
	return 0
}


rex_count_Windows:
	DetectHiddenWindows, Off
	WinGet, rex_ids, list,,,Program Manager      ; all active windows-tasks (processes)
	rex_num_win = 0
	rex_minAgain =

	Loop %rex_ids% {
		rex_task_id := rex_ids%A_Index%              ; id of this window
		WinGetClass rex_class, ahk_id %rex_task_id%
		WinGetTitle rex_title, ahk_id %rex_task_id%
		WinGet, rex_state, MinMax, ahk_id %rex_task_id%
		WinGet, rex_procName, ProcessName, ahk_id %rex_task_id%

		If (rex_IgnoreWindow())
			Continue

		If ((rex_state = -1) && rex_ForceAllWindows)
		{
			if (rex_minAnimation())
				rex_minAnimation(0)

			WinRestore, ahk_id %rex_task_id%
			WinGet, rex_state, MinMax, ahk_id %rex_task_id%
			If (rex_state = -1)
				PostMessage, 0x112, 0xF120,,, ahk_id %rex_task_id%

			rex_minAgain = %rex_minAgain%%rex_task_id%|
		}


		WinGetPos,,, rex_w, rex_h, ahk_id %rex_task_id%

		If (rex_Window_Hidden())                 ; small windows not shown (e.g. taskbar)
			Continue

		rex_num_win++

	}

	WinGet rex_tmp_ActiveID, ID, A
	If rex_tmp_ActiveID =
		WinActivate, ahk_id %rex_task_id%
return

rex_Window_Choose:
	gosub, rex_count_Windows
	if rex_num_win > 1
	{
		WinGet rex_ActiveID, ID, A
		SetTimer rex_Window_Choose_Thread, 0       ; new thread to make thumbnail draws interruptible
	}
Return


rex_Window_Choose_Thread:
	GuiDefault("RealExpose_GUI","+AlwaysOnTop +Owner -Caption  +Toolwindow  +LastFound")
	;GuiDefault("RealExpose_GUI","+LastFound")
	SetTimer rex_Window_Choose_Thread, OFF     ; run once
	rex_IsDrawing = 1
	rex_Stop_Drawing  =
	rex_yield         := rex_time_gap        ; yield time to other tasks after each thumbnail drawn
	GoSub rex_Window_Info           ; list window IDs, sizes, etc.

	CoordMode,Mouse,Screen
	MouseGetPos, rex_lastX, rex_lastY

	Gosub, rex_Animate_In
	If rex_AltTabReplacement = 1
	{
		rex_FirstAltTab := !rex_FirstAltTab
		If rex_FirstAltTab
			rex_pos--
		Else
			rex_pos++
		If rex_pos > %rex_num_win%
			rex_pos = 1
		If rex_pos < 1
			rex_pos = %rex_num_win%
	}
	Gosub, rex_ShowTaskInfo_fromPos

	GDISetStretchBltMode(rex_hdc_thumbnails,rex_quality_high) ; 3: Lower quality at 1st draw

	rex_fast_redraw = 0 ; force full refresh
	GoSub, rex_Draw_Thumbnails
	rex_IsDrawing = 0
Return

rex_Window_Activate_WinUp:
	SetTimer, rex_tim_Window_Activate_WinUp, 50
Return

rex_tim_Window_Activate_WinUp:
	SetTimer, rex_tim_Window_Activate_WinUp, off
	If (rex_IsDrawing = 0 AND rex_Stop_Drawing <> 1)
		Return
	Gosub, rex_Window_Activate
Return

rex_Window_Activate:
	GuiDefault("RealExpose_GUI","+AlwaysOnTop +Owner -Caption  +Toolwindow  +LastFound")
	;GuiDefault("RealExpose_GUI"," +LastFound")
	rex_Stop_Drawing = 1

	Loop, parse, rex_minAgain, |
	{
		WinMinimize, ahk_id %A_LoopField%
	}

	rex_minAgain =

;   MouseGetPos rex_X, rex_Y
;   rex_pos := 1 + rex_X*rex_cols//rex_WorkArea_Width + rex_Y*rex_rows//rex_WorkArea_Height * rex_cols
	rex_task_id := rex_task_ids_%rex_pos%
	If (rex_pos <= rex_num_win and rex_X >= 0 and rex_X <= rex_WorkArea_Width and rex_Y >= 0 and rex_Y <= rex_WorkArea_Height)
	{
		Gosub rex_Animate_Out
			rex_WinActivate(rex_task_id)                 ; activate selected window
		Gosub rex_fade_out
	}

	Sleep, 10
	rex_minAnimation(rex_OSAnimation)

	rex_Gui_Hide()
Return

rex_WatchMouse:
	CoordMode,Mouse,Screen
	MouseGetPos rex_X, rex_Y
	If (rex_x < rex_lastX+4 AND rex_x > rex_lastX-4 AND rex_y < rex_lastY+4 AND rex_y > rex_lastY-4)
		Return
	rex_pos := 1 + rex_X*rex_cols//rex_WorkArea_Width + rex_Y*rex_rows//rex_WorkArea_Height * rex_cols

	If rex_pos < 1
		rex_pos = 1
	If rex_pos > %rex_num_win%
		rex_pos = %rex_num_win%

	Gosub, rex_ShowTaskInfo_fromPos
	If (rex_lastPos <> rex_pos AND rex_lastPos <> "")
	{
		rex_pos_x := rex_thumb_w * Mod(rex_lastPos-1,rex_cols)
		rex_pos_y := rex_thumb_h * ((rex_lastPos-1)//rex_cols)
		if ( !rex_fast_redraw or ( rex_X_live > rex_pos_x and rex_X_live < rex_pos_x + rex_thumb_w and rex_Y_live > rex_pos_y and rex_Y_live < rex_pos_y + rex_thumb_h ) )
		  {
			 GDIPrintWindow( rex_task_ids_%rex_lastPos%, rex_hdc_printwindow, 0) ; 0=window, 1=Child(no toolbars)

			if rex_show_desktop_image
				 BitBlt( rex_hdc_thumbnails, rex_pos_x , rex_pos_y, rex_thumb_w, rex_thumb_h , rex_hdc_desktop   , rex_pos_x , rex_pos_y ,0xCC0020) ; Clear slot
			else
				 BitBlt( rex_hdc_thumbnails, rex_pos_x , rex_pos_y, rex_thumb_w, rex_thumb_h , rex_hdc_thumbnails , rex_pos_x , rex_pos_y ,0x00000042) ; Black

			  rex_hdc_target := rex_fast_redraw * rex_hdc_frontbuffer + (1-rex_fast_redraw) * rex_hdc_thumbnails

			StretchBlt( rex_hdc_target , rex_pos_x + ( rex_thumb_w - rex_thumb_w%rex_lastPos% ) // 2
									 , rex_pos_y + ( rex_thumb_h - rex_thumb_h%rex_lastPos% ) // 2
									 , rex_thumb_w%rex_lastPos%
								  , rex_thumb_h%rex_lastPos%
									,rex_hdc_printwindow, 0, 0, rex_w%rex_lastPos%, rex_h%rex_lastPos% ,0xCC0020) ; SRCCOPY
	  }

	  if !rex_fast_redraw
		  BitBlt( rex_hdc_frontbuffer, 0 , 0 , rex_WorkArea_Width, rex_WorkArea_Height ,rex_hdc_thumbnails,  0 , 0 , 0xCC0020) ; flip

	  rex_fast_redraw := rex_fast_redraw_mode
	  GDISetStretchBltMode(rex_hdc_frontbuffer, rex_quality_low) ; 3: Lower quality at 1st draw
	}

	rex_lastX := rex_x
	rex_lastY := rex_y
	rex_lastPos := rex_pos
Return

rex_UpKey:
	If Hotkey_RealExpose = #Tab
	{
		Hotkey, IfWinActive, »Expose«
		Hotkey, #Tab, rex_Window_Activate_WinUp, On
		Hotkey, IfWinActive
	}
	rex_pos := rex_pos-rex_cols
	If rex_pos < 1
		rex_pos := rex_num_win+rex_pos
	Gosub, rex_ShowTaskInfo_fromPos
Return

rex_DownKey:
	If Hotkey_RealExpose = #Tab
	{
		Hotkey, IfWinActive, »Expose«
		Hotkey, #Tab, rex_Window_Activate_WinUp, On
		Hotkey, IfWinActive
	}
	rex_pos := rex_pos+rex_cols
	If rex_pos > %rex_num_win%
		rex_pos := rex_pos-rex_num_win
	Gosub, rex_ShowTaskInfo_fromPos
Return

rex_LeftKeyTab:
	If Hotkey_RealExpose = #Tab
	{
		Hotkey, IfWinActive, »Expose«
		Hotkey, LWin Up, rex_Window_Activate_WinUp, On
		Hotkey, IfWinActive
	}
	rex_pos--
	If rex_pos < 1
		rex_pos = %rex_num_win%
	Gosub, rex_ShowTaskInfo_fromPos
Return

rex_LeftKey:
	If Hotkey_RealExpose = #Tab
	{
		Hotkey, IfWinActive, »Expose«
		Hotkey, #Tab, rex_Window_Activate_WinUp, On
		Hotkey, IfWinActive
	}
	rex_pos--
	If rex_pos < 1
		rex_pos = %rex_num_win%
	Gosub, rex_ShowTaskInfo_fromPos
Return

rex_RightKeyTab:
	If Hotkey_RealExpose = #Tab
	{
		Hotkey, IfWinActive, »Expose«
		Hotkey, LWin Up, rex_Window_Activate_WinUp, On
		Hotkey, IfWinActive
	}
	rex_pos++
	If rex_pos > %rex_num_win%
		rex_pos = 1
	Gosub, rex_ShowTaskInfo_fromPos
Return

rex_RightKey:
	If Hotkey_RealExpose = #Tab
	{
		Hotkey, IfWinActive, »Expose«
		Hotkey, #Tab, rex_Window_Activate_WinUp, On
		Hotkey, IfWinActive
	}
	rex_pos++
	If rex_pos > %rex_num_win%
		rex_pos = 1
	Gosub, rex_ShowTaskInfo_fromPos
Return

rex_ShowTaskInfo_fromPos:
	If rex_ShowWindowInfo = 0
		Return
	rex_task_id := rex_task_ids_%rex_pos%
	rex_Tx := (rex_pos-(Ceil(rex_pos/rex_cols)-1)*rex_cols-1)*rex_thumb_w
	rex_Ty := (Ceil(rex_pos/rex_cols)-1)*rex_thumb_h+rex_thumb_h/2-20
	WinGetTitle, rex_title, ahk_id %rex_task_id%
	If (rex_Tx <> rex_lastTX OR rex_Ty <> rex_lastTY)
	SplashImage,, B1 X%rex_Tx% Y%rex_Ty% W%rex_thumb_w%, %rex_title%
	rex_lastTX := rex_Tx
	rex_lastTY := rex_Ty
Return

rex_Window_Send_Click:
	rex_Stop_Drawing = 1
	CoordMode, Mouse, Screen
	MouseGetPos rex_X,rex_Y
	rex_pos := 1 + rex_X*rex_cols//rex_WorkArea_Width + rex_Y*rex_rows//rex_WorkArea_Height * rex_cols
	rex_task_id := rex_task_ids_%rex_pos%
	If (rex_pos <= rex_num_win and rex_X >= 0 and rex_X <= rex_WorkArea_Width and rex_Y >= 0 and rex_Y <= rex_WorkArea_Height)
	{
		rex_X_Relative := ( rex_X - ( rex_X*rex_cols//rex_WorkArea_Width  ) * rex_WorkArea_Width/rex_cols  ) * rex_cols
		rex_Y_Relative := ( rex_Y - ( rex_Y*rex_rows//rex_WorkArea_Height ) * rex_WorkArea_Height/rex_rows ) * rex_rows

		CoordMode, Mouse, Screen

		 rex_x1 := rex_X_Relative -5
		 rex_y1 := rex_Y_Relative -5
		 rex_x2 := rex_x1+10
		 rex_y2 := rex_y1+10
			WinSet, Region, 0-0 %A_ScreenWidth%-0 %A_ScreenWidth%-%A_ScreenHeight%  0-%A_ScreenHeight% 0-0  %rex_x1%-%rex_y1% %rex_x2%-%rex_y1% %rex_x2%-%rex_y2% %rex_x1%-%rex_y2% %rex_x1%-%rex_y1%
		sleep 5
		rex_WinActivate(rex_task_id)
		 MouseClick, Left, rex_X_Relative, rex_Y_Relative
		 sleep 5
		WinSet, Region

		; continue paint
		 MouseMove(rex_X+1, rex_Y)
		 MouseMove(rex_X, rex_Y)
		rex_Stop_Drawing =
		 rex_fast_redraw = 0
		rex_WinActivate(rex_Expose_ID)
		SetTimer,  rex_Draw_Thumbnails , 0
	}

Return

rex_WinActivate(ID) {
	WinGet ,rex_ActiveID2, ID, A
	if rex_ActiveID2 <> ID
		 WinActivate ahk_id %ID%
}

rex_Window_Info:
	DetectHiddenWindows, Off
	WinGet, rex_ids, list,,,Program Manager      ; all active windows-tasks (processes)
	rex_task_info =
	rex_num_win = 0
	;rex_minAgain =

	Loop %rex_ids% {
		rex_task_id := rex_ids%A_Index%              ; id of this window
		WinGetClass rex_class, ahk_id %rex_task_id%
		WinGetTitle rex_title, ahk_id %rex_task_id%
		WinGetPos,,, rex_w, rex_h, ahk_id %rex_task_id%
		WinGet, rex_state, MinMax, ahk_id %rex_task_id%
		WinGet, rex_procName, ProcessName, ahk_id %rex_task_id%

		If ((rex_state = -1) && rex_ForceAllWindows)
		{
			if (rex_minAnimation())
				rex_minAnimation(0)

			WinRestore, ahk_id %rex_task_id%
			rex_minAgain = %rex_minAgain%%rex_task_id%|
			WinGetPos,,, rex_w, rex_h, ahk_id %rex_task_id%
		}

		If (rex_Window_Hidden() || rex_IgnoreWindow())                 ; small windows not shown (e.g. taskbar)
			Continue

		rex_num_win++
		rex_task_info := rex_task_info rex_class "|" rex_ids%A_Index% "|" rex_w "|" rex_h ","
	}

	StringTrimRight rex_task_info, rex_task_info, 1
	Sort rex_task_info, D,                      ; keep positions of thumbnails
	rex_cols := ceil(sqrt(rex_num_win))
	rex_rows := ceil(sqrt(rex_num_win))

	rex_thumb_w := rex_WorkArea_Width  // rex_cols
	rex_thumb_h := rex_WorkArea_Height // rex_rows
	rex_ratio_of_screen := rex_WorkArea_Width / rex_WorkArea_Height * rex_rows / rex_cols
	Loop Parse, rex_task_info, `,               ; task_info has been set up in get_wins()
	{
		StringSplit rex_z, A_LoopField, |        ; separate ID, w, h
		rex_task_ids_%A_Index% := rex_z2             ; needed for activation
		if ( rex_z2 = rex_ActiveID )
		rex_pos = %A_Index%
		  rex_w%A_Index% := rex_z3                     ; w
		rex_h%A_Index% := rex_z4                     ; h
		rex_ratio_of_win := rex_z3 / rex_z4              ; w/h
		If ( rex_scale_thumb_space  )  {
			If (rex_ratio_of_win < rex_ratio_of_screen) { ; tall window
				rex_thumb_h%A_Index% := rex_thumb_h - (rex_thumb_border*5)
				rex_thumb_w%A_Index% := Floor(rex_thumb_w * rex_ratio_of_win / rex_ratio_of_screen) - (rex_thumb_border*5)
			} Else {                              ; wide window
				rex_thumb_w%A_Index% := rex_thumb_w - (rex_thumb_border*5)
				rex_thumb_h%A_Index% := Floor(rex_thumb_h * rex_ratio_of_screen / rex_ratio_of_win) - (rex_thumb_border*5)
			}
		} Else {
			rex_thumb_w%A_Index% := rex_z3//rex_cols - 10*rex_thumb_border
			rex_thumb_h%A_Index% := rex_z4//rex_cols - 10*rex_thumb_border  ; cols >= rows, keep aspect ratio of window
		}
	  if ( rex_thumb_w%A_Index% > rex_w%A_Index% or rex_thumb_h%A_Index% > rex_h%A_Index% )
	  {
			rex_thumb_w%A_Index% := rex_w%A_Index%
			rex_thumb_h%A_Index% := rex_h%A_Index%
		}
	}
Return

rex_Draw_Thumbnails:
	SetTimer, rex_Draw_Thumbnails, Off
	If rex_Stop_Drawing
		Return

	DetectHiddenWindows, Off
	WinGet, rex_ids_count, list,,,Program Manager      ; all active windows-tasks (processes)

	if ( rex_old_ids_count <> rex_ids_count )
		gosub rex_Window_Info   ; detect if windows were added in expose mode

	; layout changed full refresh (start with empty desktop)
	if ( rex_old_ids_count <> rex_ids_count and !rex_fast_redraw)
	{
		if rex_show_desktop_image
			BitBlt( rex_hdc_thumbnails, 0, 0, rex_WorkArea_Width, rex_WorkArea_Height , rex_hdc_desktop, 0, 0 , 0xCC0020) ; SRCCOPY
		else
			BitBlt( rex_hdc_thumbnails, 0, 0, rex_WorkArea_Width, rex_WorkArea_Height , rex_hdc_thumbnails, 0, 0 , 0x00000042) ; Black
	}
	rex_old_ids_count := rex_ids_count
	rex_old_rows := rex_rows
	rex_old_cols := rex_cols
	rex_old_num_win := rex_num_win
	MouseGetPos, rex_X_live, rex_Y_live

	Loop %rex_num_win%                           ; task_ids, dims have been set up in win_list
	{
		Critical Off
		if !rex_fast_redraw
			Sleep %rex_yield%                        ; CPU cycles to other tasks @ frequent redraw

		if !rex_fast_redraw
			Sleep %rex_yield%                        ; CPU cycles to other tasks @ frequent redraw

		Sleep %rex_yield%                        ; CPU cycles to other tasks @ frequent redraw

		If rex_Stop_Drawing
			Break

		Critical On
		rex_pos_x := rex_thumb_w * Mod(A_Index-1,rex_cols)
		rex_pos_y := rex_thumb_h * ((A_Index-1)//rex_cols)
		if ( !rex_fast_redraw or ( rex_X_live > rex_pos_x and rex_X_live < rex_pos_x + rex_thumb_w and rex_Y_live > rex_pos_y and rex_Y_live < rex_pos_y + rex_thumb_h ) )
		{
			GDIPrintWindow( rex_task_ids_%A_Index%, rex_hdc_printwindow, 0) ; 0=window, 1=Child(no toolbars)

			if rex_show_desktop_image
				BitBlt( rex_hdc_thumbnails, rex_pos_x , rex_pos_y, rex_thumb_w, rex_thumb_h , rex_hdc_desktop   , rex_pos_x , rex_pos_y ,0xCC0020) ; Clear slot
			else
				BitBlt( rex_hdc_thumbnails, rex_pos_x , rex_pos_y, rex_thumb_w, rex_thumb_h , rex_hdc_thumbnails , rex_pos_x , rex_pos_y ,0x00000042) ; Black

			rex_hdc_target := rex_fast_redraw * rex_hdc_frontbuffer + (1-rex_fast_redraw) * rex_hdc_thumbnails

			StretchBlt( rex_hdc_target , rex_pos_x + ( rex_thumb_w - rex_thumb_w%A_Index% ) // 2
												, rex_pos_y + ( rex_thumb_h - rex_thumb_h%A_Index% ) // 2
												, rex_thumb_w%A_Index%, rex_thumb_h%A_Index%
						  ,rex_hdc_printwindow, 0, 0, rex_w%A_Index%, rex_h%A_Index% ,0xCC0020) ; SRCCOPY
		}
	}

	if !rex_fast_redraw
		BitBlt( rex_hdc_frontbuffer, 0 , 0 , rex_WorkArea_Width, rex_WorkArea_Height ,rex_hdc_thumbnails,  0 , 0 , 0xCC0020) ; flip

	rex_fast_redraw := rex_fast_redraw_mode
	GDISetStretchBltMode(rex_hdc_frontbuffer, rex_quality_low) ; 3: Lower quality at 1st draw

	If rex_live_redraw           ; redraw thumbnails until Break is set
		Gosub rex_draw_thumbnails
Return

rex_Animate_In:
	rex_loopDelay := rex_animate_in_delay
	rex_loopCount := rex_animate_in_steps
	if (rex_EnableAnimations = 0 OR !rex_animate_in_steps)
	{
		rex_loopCount = 1
		rex_loopDelay = 0
	}

	GDISetStretchBltMode(rex_hdc_backbuffer, rex_quality_low) ; 3: Lower quality at 1st draw

	A_index2 := rex_pos
	rex_pos_x := rex_thumb_w * Mod(A_Index2-1,rex_cols)
	rex_pos_y := rex_thumb_h * ((A_Index2-1)//rex_cols)

	GDIPrintWindow(rex_task_ids_%A_Index2%,rex_hdc_printwindow,0)

	rex_task_id := rex_task_ids_%A_Index2%
	WinGetPos, rex_diff_x, rex_diff_y, rex_diff_w, rex_diff_h , ahk_id %rex_task_id%

	rex_diff_x := rex_diff_x - ( rex_pos_x + (rex_thumb_w - rex_thumb_w%A_Index2% ) // 2 ) - rex_WorkArea_Left
	rex_diff_y := rex_diff_y - ( rex_pos_y + (rex_thumb_h - rex_thumb_h%A_Index2% ) // 2 ) - rex_WorkArea_Top
	rex_diff_w := rex_diff_w - ( rex_thumb_w%A_Index2% )
	rex_diff_h := rex_diff_h - ( rex_thumb_h%A_Index2% )

	Loop %rex_loopCount%
	{
		sleep %rex_loopDelay%
		rex_zoom := 1 - ( A_Index / rex_loopCount )

		BitBlt( rex_hdc_backbuffer, 0, 0, rex_WorkArea_Width, rex_WorkArea_Height, rex_hdc_thumbnails, 0, 0 , 0xCC0020) ; SRCCOPY

		if ( rex_zoom = 0 )
			GDISetStretchBltMode(rex_hdc_backbuffer, rex_quality_high) ; 3: Lower quality at 1st draw

		StretchBlt(rex_hdc_backbuffer
									, rex_pos_x + (rex_thumb_w - rex_thumb_w%A_Index2% ) // 2 + rex_diff_x * rex_zoom
									, rex_pos_y + (rex_thumb_h - rex_thumb_h%A_Index2% ) // 2 + rex_diff_y * rex_zoom
									, rex_thumb_w%A_Index2% + rex_diff_w * rex_zoom
									, rex_thumb_h%A_Index2% + rex_diff_h * rex_zoom
									, rex_hdc_printwindow, 0, 0, rex_w%A_Index2%, rex_h%A_Index2% ,0xCC0020) ; SRCCOPY

		if ( rex_zoom = 0 )
			GDISetStretchBltMode(rex_hdc_backbuffer, rex_quality_low) ; 3: Lower quality at 1st draw

		rex_Gui_Show()
		BitBlt(rex_hdc_frontbuffer, 0, 0 ,rex_WorkArea_Width ,rex_WorkArea_Height
				,rex_hdc_backbuffer , 0, 0 ,0xCC0020) ; SRCCOPY
	}

	; prevent full refresh on next draw
	if !rex_old_cols
		rex_old_cols := rex_cols
	if !rex_old_rows
		rex_old_rows := rex_rows
Return

; should be reverse of animate in ? combine them ...
rex_Animate_Out:
	if !rex_animate_out_steps
			return

	if rex_EnableAnimations = 0
		  return

	A_index2 := rex_pos
	rex_pos_x := rex_thumb_w * Mod(A_Index2-1,rex_cols)
	rex_pos_y := rex_thumb_h * ((A_Index2-1)//rex_cols)

	 If (!(rex_pos <= rex_num_win and rex_X >= 0 and rex_X <= rex_WorkArea_Width and rex_Y >= 0 and rex_Y <= rex_WorkArea_Height))
		 return

	;GDISetStretchBltMode(hdc_frontbuffer,quality_low) ;
	 GDIPrintWindow( rex_task_ids_%A_Index2%, rex_hdc_printwindow ,0) ; get selected window

	; clear
	  BitBlt( rex_hdc_backbuffer, rex_pos_x, rex_pos_y, rex_thumb_w, rex_thumb_h
			 , rex_hdc_desktop, rex_pos_x, rex_pos_y, 0xCC0020) ; clear with desktopimage

	rex_task_id := rex_task_ids_%A_Index2%
	WinGetPos, rex_diff_x, rex_diff_y, rex_diff_w, rex_diff_h , ahk_id %rex_task_id%

	rex_diff_x := rex_diff_x - ( rex_pos_x + (rex_thumb_w - rex_thumb_w%A_Index2% ) // 2 ) - rex_WorkArea_Left
	rex_diff_y := rex_diff_y - ( rex_pos_y + (rex_thumb_h - rex_thumb_h%A_Index2% ) // 2 ) - rex_WorkArea_Top
	rex_diff_w := rex_diff_w - ( rex_thumb_w%A_Index2% )
	rex_diff_h := rex_diff_h - ( rex_thumb_h%A_Index2% )

	GDISetStretchBltMode(rex_hdc_backbuffer,rex_quality_low) ; 3: Lower quality at 1st draw

	rex_loopDelay := rex_animate_out_delay
	rex_loopCount := rex_animate_out_steps
	if rex_EnableAnimations = 0
	{
		rex_loopCount = 1
		rex_loopDelay = 0
	}

	Loop %rex_loopCount%
	{
		 sleep %rex_loopDelay%
			 rex_zoom := ( A_Index / rex_animate_out_steps )

		BitBlt( rex_hdc_backbuffer, 0, 0, rex_WorkArea_Width, rex_WorkArea_Height
				  , rex_hdc_thumbnails, 0, 0, 0xCC0020) ; SRCCOPY

		StretchBlt( rex_hdc_backbuffer, rex_pos_x + (rex_thumb_w - rex_thumb_w%A_Index2% ) // 2 + rex_diff_x * rex_zoom
									, rex_pos_y + (rex_thumb_h - rex_thumb_h%A_Index2% ) // 2 + rex_diff_y * rex_zoom
									, rex_thumb_w%A_Index2% + rex_diff_w * rex_zoom
									, rex_thumb_h%A_Index2% + rex_diff_h * rex_zoom
						 ,rex_hdc_printwindow, 0, 0, rex_w%A_Index2%, rex_h%A_Index2% ,0xCC0020) ; SRCCOPY

		 BitBlt(rex_hdc_frontbuffer, 0, 0, rex_WorkArea_Width, rex_WorkArea_Height
				 ,  rex_hdc_backbuffer, 0, 0 ,0xCC0020) ; SRCCOPY
	}

Return

rex_fade_in:
	; not used ?
Return

rex_fade_out:
	; fade last animate_out with real desktop
Return

rex_Gui_Show() {
	global
	if rex_Shown
		return
	Gui, %GuiID_RealExpose_GUI%:Show
	rex_Shown = 1
	SetTimer, rex_WatchMouse, 20
}

rex_Gui_Hide() {
	global
	if !rex_Shown
	  return

	rex_ShowOnly =

	Gui, %GuiID_RealExpose_GUI%:Hide
	rex_Shown =
	SetTimer, rex_WatchMouse, Off
	rex_lastPos =
	rex_lastTX =
	rex_lastTY =
	rex_lastX =
	rex_lastY =
	SplashImage, Off
	If Hotkey_RealExpose = #Tab
	{
		Hotkey, IfWinActive, »Expose«
		If rex_AltTabReplacement <> 1
			Hotkey, LWin Up, rex_Window_Activate_WinUp, Off
		Hotkey, #Tab, rex_RightKeyTab, On
	}
	Hotkey, IfWinActive
}

rex_hide_gui:
	rex_Stop_Drawing = 1

	Loop, parse, rex_minAgain, |
	{
		WinMinimize, ahk_id %A_LoopField%
	}

	Sleep, 10
	rex_minAnimation(rex_OSAnimation)
	rex_minAgain =

	rex_Gui_Hide()
	rex_WinActivate(rex_ActiveID)                   ; activate last active window
Return

rex_handle_exit:
	GuiDefault("RealExpose_GUI","+AlwaysOnTop +Owner -Caption  +Toolwindow  +LastFound")
	;GuiDefault("RealExpose_GUI","+LastFound")
	rex_Gui_Hide()
	;Gui, Destroy

	gosub, rex_shutDownBuffers
	if ( rex_show_desktop_image ) {
	  DeleteObject( rex_hbm_desktop)
	  DeleteDC(     rex_hdc_desktop)
	}
	GuiDefault("activAid")
Return

rex_shutDownBuffers:
	ReleaseDC(rex_Expose_ID,rex_hdc_frontbuffer) ; free lock?
	ReleaseDC(rex_Expose_ID,rex_hdc_copy) ; free lock?
	DeleteObject( rex_hbm_printwindow)
	DeleteDC(     rex_hdc_printwindow)
	DeleteObject( rex_hbm_window)
	DeleteDC(     rex_hdc_window)
	DeleteObject( rex_hbm_backbuffer)
	DeleteDC(     rex_hdc_backbuffer)
return
