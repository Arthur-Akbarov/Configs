; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               KeyState
; -----------------------------------------------------------------------------
; Prefix:             ks_
; Version:            0.9
; Date:               2008-05-23
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_KeyState:
	Prefix = ks
	%Prefix%_ScriptName    = KeyState
	%Prefix%_ScriptVersion = 0.9
	%Prefix%_Author        = Wolfgang Reszel

	HideSettings = 0                   ; Wenn 1, dann bekommt die Erweiterung keinen Eintrag im Konfigurationsdialog
	EnableTray_KeyState   =            ; Soll eine Erweiterung nicht im Tray-Menü aufgeführt werden, muss der Wert 0 betragen

	DisableIfCompiled_KeyState =       ; Wenn 1, lässt sich die Erweiterung in kompilierter Form nicht de-/aktivieren

	CreateGuiID("KeyStateOSD")
	CreateGuiID("KeyStateMiniOSD")

	IconFile_On_KeyState = %A_WinDir%\system32\main.cpl
	IconPos_On_KeyState  = 8

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %ks_ScriptName% - Statusanzeige für CapsLock, ScrollLock und NumLock
		Description                   = Zeigt den Status der Feststellen-, Rollen- und NumLock-Taste an.
		lng_ks_Caps                   = Fest`nstellen
		lng_ks_Scroll                 = Rollen
		lng_ks_Num                    = Num`nLock
		lng_ks_Ins                    = Einfg
		lng_ks_ShowOSD                = kurzfristig den Status anzeigen (OSD)
		lng_ks_ShowInTitleBar         = ständig in der Titelleiste des aktuellen Fensters anzeigen
		lng_ks_ShowTrayIcon           = als Tray-Icon in der Taskleiste anzeigen
		lng_ks_Sound                  = Akustisches Signal:
		lng_ks_SoundMode1             = Soundkarte
		lng_ks_SoundMode2             = PC-Speaker
		lng_ks_IgnoreClasses          = Fenster, bei dem kein Status in der Titelleiste angezeigt werden soll:
		lng_ks_IgnoreClassesCompletly = Fenster, bei denen KeyState generell deaktiviert ist:
		lng_ks_ShowTime               = Zusätzlich die Uhrzeit anzeigen
		lng_ks_SoundForInsert         = Zusätzliches Signal für die Einfg-Taste
		lng_ks_IgnoreSounds           = Akustisches Signal nicht ausgegeben, wenn diese Fenster aktiv sind
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %ks_ScriptName% - display status for CapsLock, ScrollLock and NumLock
		Description                   = Displays the status of CapsLock, ScrollLock and NumLock.
		lng_ks_Caps                   = Caps`nLock
		lng_ks_Scroll                 = Scroll`nLock
		lng_ks_Num                    = Num`nLock
		lng_ks_Ins                    = Ins
		lng_ks_ShowOSD                = Display for a short time (OSD)
		lng_ks_ShowInTitleBar         = Display in the title-bar of the active window
		lng_ks_ShowTrayIcon           = Display as a tray-icon
		lng_ks_Sound                  = Acoustic feedback:
		lng_ks_SoundMode1             = Soundcard
		lng_ks_SoundMode2             = PC-Speaker
		lng_ks_IgnoreClasses          = Don't show the status in the title-bar of these windows:
		lng_ks_IgnoreClassesCompletly = Deactivate KeyState completly for these windows:
		lng_ks_ShowTime               = Show time
		lng_ks_SoundForInsert         = Additional acoustic feedback for the Insert key
		lng_ks_IgnoreSounds           = No acoustic feedback, when these windows are active
	}

	IniRead, ks_ShowInTitleBar, %ConfigFile%, KeyState, ShowInTitleBar, 0
	IniRead, ks_ShowOSD, %ConfigFile%, KeyState, ShowOSD, 1
	IniRead, ks_ShowTrayIcon, %ConfigFile%, KeyState, ShowTrayIcon, 0
	IniRead, ks_SoundMode1, %ConfigFile%, KeyState, SoundMode1, 0
	IniRead, ks_SoundMode2, %ConfigFile%, KeyState, SoundMode2, 0
	IniRead, ks_SoundForInsert, %ConfigFile%, KeyState, SoundForInsert, 0

	IniRead, ks_CapsSoundMode1, %ConfigFile%, KeyState, CapsSoundMode1, %ks_SoundMode1%
	IniRead, ks_CapsSoundMode2, %ConfigFile%, KeyState, CapsSoundMode2, %ks_SoundMode2%
	IniRead, ks_ScrollSoundMode1, %ConfigFile%, KeyState, ScrollSoundMode1, %ks_SoundMode1%
	IniRead, ks_ScrollSoundMode2, %ConfigFile%, KeyState, ScrollSoundMode2, %ks_SoundMode2%
	IniRead, ks_NumSoundMode1, %ConfigFile%, KeyState, NumSoundMode1, %ks_SoundMode1%
	IniRead, ks_NumSoundMode2, %ConfigFile%, KeyState, NumSoundMode2, %ks_SoundMode2%
	IniRead, ks_InsSoundMode1, %ConfigFile%, KeyState, InsSoundMode1, % ks_SoundForInsert * ks_SoundMode1
	IniRead, ks_InsSoundMode2, %ConfigFile%, KeyState, InsSoundMode2, % ks_SoundForInsert * ks_SoundMode2

	IniRead, ks_ShowTime, %ConfigFile%, KeyState, ShowTime, 1
	IniRead, ks_IgnoreClasses, %ConfigFile%, KeyState, MiniOSDIgnore, tSkMainForm.UnicodeClass,TskUserInfoForm.UnicodeClass,TNotifForm,Winamp v1.x
	IniRead, ks_IgnoreClassesCompletly, %ConfigFile%, KeyState, IgnoreClasses, %A_Space%
	IniRead, ks_SoundFile, %ConfigFile%, KeyState, SoundFile, %A_Space%
	If (ks_SoundFile = "" OR NOT FileExist(ks_SoundFile))
		ks_WAV = %A_ScriptDir%\extensions\Media\ac'tivAid_KeyState.wav
	Else
		ks_WAV = %ks_SoundFile%

	IniRead, ks_IgnoreSounds, %ConfigFile%, KeyState, IgnoreSounds, 0

	IniRead, ks_IconFile, %ConfigFile%, KeyState, IconFile, %A_Space%
	If (ks_IconFile = "" OR NOT FileExist(ks_IconFile))
		ks_icons = %A_ScriptDir%\extensions\Media\ac'tivAid_KeyState.dll
	Else
		ks_icons = %ks_IconFile%

	If activAid_HasChanged = 1
	{
		IfNotExist, extensions\Media\ac'tivAid_KeyState.gif
		{
			func_UnpackSplash("extensions\Media\ac'tivAid_KeyState.gif")
			FileInstall, extensions\Media\ac'tivAid_KeyState.gif, extensions\Media\ac'tivAid_KeyState.gif
			func_UnpackSplash("extensions\Media\ac'tivAid_KeyState_CapsLock_On.gif")
			FileInstall, extensions\Media\ac'tivAid_KeyState_CapsLock_On.gif, extensions\Media\ac'tivAid_KeyState_CapsLock_On.gif
			func_UnpackSplash("extensions\Media\ac'tivAid_KeyState_Lock_On.gif")
			FileInstall, extensions\Media\ac'tivAid_KeyState_Lock_On.gif, extensions\Media\ac'tivAid_KeyState_Lock_On.gif
			func_UnpackSplash("extensions\Media\ac'tivAid_KeyState.wav")
			FileInstall, extensions\Media\ac'tivAid_KeyState.wav, extensions\Media\ac'tivAid_KeyState.wav
			func_UnpackSplash("extensions\Media\ac'tivAid_KeyState.dll")
			FileInstall, extensions\Media\ac'tivAid_KeyState.dll, extensions\Media\ac'tivAid_KeyState.dll
			func_UnpackSplash("extensions\Media\ac'tivAid_KeyState_miniCaps.gif")
			FileInstall, extensions\Media\ac'tivAid_KeyState_miniCaps.gif, extensions\Media\ac'tivAid_KeyState_miniCaps.gif
			func_UnpackSplash("extensions\Media\ac'tivAid_KeyState_miniScroll.gif")
			FileInstall, extensions\Media\ac'tivAid_KeyState_miniScroll.gif, extensions\Media\ac'tivAid_KeyState_miniScroll.gif
			func_UnpackSplash("extensions\Media\ac'tivAid_KeyState_miniNum.gif")
			FileInstall, extensions\Media\ac'tivAid_KeyState_miniNum.gif, extensions\Media\ac'tivAid_KeyState_miniNum.gif
			func_UnpackSplash("extensions\Media\ac'tivAid_KeyState_mini.gif")
			FileInstall, extensions\Media\ac'tivAid_KeyState_mini.gif, extensions\Media\ac'tivAid_KeyState_mini.gif
		}
	}

	GetKeyState, ks_prevCapsLock  , CapsLock  , T
	GetKeyState, ks_prevScrollLock, ScrollLock, T
	GetKeyState, ks_prevNumLock   , NumLock   , T
	If ks_SoundForInsert = 1
		GetKeyState, ks_prevInsert    , Insert    , T
	ks_prevSuspended := 0

	ks_FadeSpeed = 15

	ks_OSDid := GuiDefault("KeyStateOSD", "+Lastfound +Disabled +ToolWindow -Caption +AlwaysOnTop")
	Gui, Add, pic, x0 y0 w226 h85 vks_OSDvpic, %A_ScriptDir%\extensions\Media\ac'tivAid_KeyState.gif  ; Bild laden
	Gui, Add, pic, x14 y13 w86 h58 vks_OSDcaps, %A_ScriptDir%\extensions\Media\ac'tivAid_KeyState_CapsLock_On.gif
	Gui, Add, pic, x100 y13 w56 h58 vks_OSDscroll, %A_ScriptDir%\extensions\Media\ac'tivAid_KeyState_Lock_On.gif
	Gui, Add, pic, x156 y13 w56 h58 vks_OSDnum, %A_ScriptDir%\extensions\Media\ac'tivAid_KeyState_Lock_On.gif
	Gui, Font, S%FontSize% CFFFFFF Bold, MS Sans Serif
	Gui, Add, Text, vks_TXTcaps BackgroundTrans x50 y23, %lng_ks_Caps%
	Gui, Add, Text, vks_TXTscroll BackgroundTrans x109 y23, %lng_ks_Scroll%
	Gui, Add, Text, vks_TXTnum BackgroundTrans x165 y23, %lng_ks_Num%
	Gui, Color, BBBBBB

	WinSet, TransColor ,0000FF %ks_transparent%  ; Transparenz setzen
	WinSet, ExStyle, +0x80020                    ; Click-Through

	ks_miniOSDid := GuiDefault("KeyStateMiniOSD", "+Lastfound +ToolWindow -Caption +AlwaysOnTop")
	Gui, Color, BBBBBB
	Gui, Add, pic, x0 y0 w100 h16 vks_miniOSDvpic, %A_ScriptDir%\extensions\Media\ac'tivAid_KeyState_mini.gif  ; Bild laden
	Gui, Add, pic, x5 y0 w39 h14 vks_miniOSDcaps, %A_ScriptDir%\extensions\Media\ac'tivAid_KeyState_miniCaps.gif
	Gui, Add, pic, x44 y0 w26 h14 vks_miniOSDscroll, %A_ScriptDir%\extensions\Media\ac'tivAid_KeyState_miniScroll.gif
	Gui, Add, pic, x70 y0 w25 h14 vks_miniOSDnum, %A_ScriptDir%\extensions\Media\ac'tivAid_KeyState_miniNum.gif
	Gui, Font, CFFFFFF S5, Terminal
	Gui, Add, Text, x18 y7 BackgroundTrans vks_miniOSDtime, 09:88
	Gui, Show, x-2000, KeyStateMiniOSD
	Gui, Cancel

	WinSet, TransColor ,0000FF                   ; Transparenz setzen
	WinSet, ExStyle, +0x80020                    ; Click-Through

	If ks_prevCapsLock = D
	{
		GuiControl, %GuiID_KeyStateMiniOSD%:Show, ks_miniOSDcaps
		If ks_ShowTime = 1
		{
			Gui, %GuiID_KeyStateMiniOSD%:Font, S5 C959595, Terminal
			GuiControl, %GuiID_KeyStateMiniOSD%:Font, ks_miniOSDtime
			GuiControl, %GuiID_KeyStateMiniOSD%:Show, ks_miniOSDtime
		}
		Else
			GuiControl, %GuiID_KeyStateMiniOSD%:Hide, ks_miniOSDtime
	}
	Else
	{
		GuiControl, %GuiID_KeyStateMiniOSD%:Hide, ks_miniOSDcaps
		If ks_ShowTime = 1
		{
			Gui, %GuiID_KeyStateMiniOSD%:Font, S5 CFFFFFF, Terminal
			GuiControl, %GuiID_KeyStateMiniOSD%:Font, ks_miniOSDtime
			GuiControl, %GuiID_KeyStateMiniOSD%:Show, ks_miniOSDtime
		}
		Else
			GuiControl, %GuiID_KeyStateMiniOSD%:Hide, ks_miniOSDtime
	}
	If ks_prevScrollLock = D
		GuiControl, %GuiID_KeyStateMiniOSD%:Show, ks_miniOSDscroll
	Else
		GuiControl, %GuiID_KeyStateMiniOSD%:Hide, ks_miniOSDscroll
	If ks_prevNumLock = D
		GuiControl, %GuiID_KeyStateMiniOSD%:Show, ks_miniOSDnum
	Else
		GuiControl, %GuiID_KeyStateMiniOSD%:Hide, ks_miniOSDnum

	RegisterHook("OnSuspend","KeyState")
	RegisterHook("OnResume","KeyState")
Return

SettingsGui_KeyState:
	Gui, Add, CheckBox, -wrap xs+10 y+5 gks_sub_CheckIfSettingsChanged vks_ShowInTitleBar Checked%ks_ShowInTitleBar%, %lng_ks_ShowInTitleBar%
	Gui, Add, CheckBox, -wrap x+10 gks_sub_CheckIfSettingsChanged vks_ShowTime Checked%ks_ShowTime%, %lng_ks_ShowTime%
	Gui, Add, CheckBox, -wrap xs+10 y+5 gsub_CheckIfSettingsChanged vks_ShowOSD Checked%ks_ShowOSD%, %lng_ks_ShowOSD%
	Gui, Add, CheckBox, -wrap y+5 gsub_CheckIfSettingsChanged vks_ShowTrayIcon Checked%ks_ShowTrayIcon%, %lng_ks_ShowTrayIcon%
	Gui, Add, Text, ys+73 xs+10, %lng_ks_Sound%
	Gui, Add, Text, x+15 ys+73, % func_StrTranslate(lng_ks_Caps,"`n","")
	Gui, Add, CheckBox, -wrap xp y+3 vks_CapsSoundMode1 Checked%ks_CapsSoundMode1% gsub_CheckIfSettingsChanged, %lng_ks_SoundMode1%
	Gui, Add, CheckBox, -wrap xp y+3 vks_CapsSoundMode2 Checked%ks_CapsSoundMode2% gsub_CheckIfSettingsChanged, %lng_ks_SoundMode2%
	Gui, Add, Text, x+15 ys+73, % func_StrTranslate(lng_ks_Scroll,"`n","")
	Gui, Add, CheckBox, -wrap xp y+3 vks_ScrollSoundMode1 Checked%ks_ScrollSoundMode1% gsub_CheckIfSettingsChanged, %lng_ks_SoundMode1%
	Gui, Add, CheckBox, -wrap xp y+3 vks_ScrollSoundMode2 Checked%ks_ScrollSoundMode2% gsub_CheckIfSettingsChanged, %lng_ks_SoundMode2%
	Gui, Add, Text, x+15 ys+73, % func_StrTranslate(lng_ks_Num,"`n","")
	Gui, Add, CheckBox, -wrap xp y+3 vks_NumSoundMode1 Checked%ks_NumSoundMode1% gsub_CheckIfSettingsChanged, %lng_ks_SoundMode1%
	Gui, Add, CheckBox, -wrap xp y+3 vks_NumSoundMode2 Checked%ks_NumSoundMode2% gsub_CheckIfSettingsChanged, %lng_ks_SoundMode2%
	Gui, Add, Text, x+15 ys+73, % func_StrTranslate(lng_ks_Ins,"`n","")
	Gui, Add, CheckBox, -wrap xp y+3 vks_InsSoundMode1 Checked%ks_InsSoundMode1% gsub_CheckIfSettingsChanged, %lng_ks_SoundMode1%
	Gui, Add, CheckBox, -wrap xp y+3 vks_InsSoundMode2 Checked%ks_InsSoundMode2% gsub_CheckIfSettingsChanged, %lng_ks_SoundMode2%

;   Gui, Add, CheckBox, -wrap x+10 vks_SoundMode1 Checked%ks_SoundMode1% gsub_CheckIfSettingsChanged, %lng_ks_SoundMode1%
;   Gui, Add, CheckBox, -wrap x+10 vks_SoundMode2 Checked%ks_SoundMode2% gsub_CheckIfSettingsChanged, %lng_ks_SoundMode2%
;   Gui, Add, CheckBox, -wrap x+10 vks_SoundForInsert Checked%ks_SoundForInsert% gsub_CheckIfSettingsChanged, %lng_ks_SoundForInsert%

	StringReplace, ks_IgnoreClasses_tmp, ks_IgnoreClasses, `,, `n, A
	Gui, Add, Text, xs+10 ys+130 w250 r2, %lng_ks_IgnoreClasses%
	Gui, Add, Edit, y+5 w250 R7 vks_IgnoreClasses gsub_CheckIfSettingsChanged, %ks_IgnoreClasses_tmp%
	Gui, Add, Button, -Wrap x+5 w20 h21 vks_Add_IgnoreClasses gks_sub_addApp, +

	StringReplace, ks_IgnoreClassesCompletly_tmp, ks_IgnoreClassesCompletly, `,, `n, A
	Gui, Add, Text, xs+290 ys+130 w250 r2, %lng_ks_IgnoreClassesCompletly%
	Gui, Add, Edit, y+5 w250 R7 vks_IgnoreClassesCompletly gsub_CheckIfSettingsChanged, %ks_IgnoreClassesCompletly_tmp%
	Gui, Add, Button, -Wrap x+5 w20 h21 vks_Add_IgnoreClassesCompletly gks_sub_addApp, +

	Gui, Add, CheckBox, -wrap xs+10 ys+265 gks_sub_CheckIfSettingsChanged vks_IgnoreSounds Checked%ks_IgnoreSounds%, %lng_ks_IgnoreSounds%
	Gosub, ks_sub_CheckIfSettingsChanged
Return

ks_sub_CheckIfSettingsChanged:
	Gosub, sub_CheckIfSettingsChanged
	GuiControlGet, ks_ShowInTitleBar_tmp,, ks_ShowInTitleBar
	GuiControlGet, ks_IgnoreSounds_tmp,, ks_IgnoreSounds
	If (ks_ShowInTitleBar_tmp = 1 OR ks_IgnoreSounds_tmp = 1)
	{
		GuiControl,%GuiID_activAid%:Enable,ks_IgnoreClasses
		GuiControl,%GuiID_activAid%:Enable,ks_Add_IgnoreClasses
	}
	Else
	{
		GuiControl,%GuiID_activAid%:Disable,ks_IgnoreClasses
		GuiControl,%GuiID_activAid%:Disable,ks_Add_IgnoreClasses
	}
	If (ks_ShowInTitleBar_tmp = 1)
	{
		GuiControl,%GuiID_activAid%:Enable,ks_ShowTime
	}
	Else
	{
		GuiControl,%GuiID_activAid%:Disable,ks_ShowTime
	}
Return

SaveSettings_KeyState:
	StringReplace, ks_IgnoreClasses, ks_IgnoreClasses, `n, `,, A
	StringReplace, ks_IgnoreClassesCompletly, ks_IgnoreClassesCompletly, `n, `,, A
	IniWrite, %ks_ShowInTitleBar%, %ConfigFile%, KeyState, ShowInTitleBar
	IniWrite, %ks_ShowOSD%, %ConfigFile%, KeyState, ShowOSD
	IniWrite, %ks_ShowTrayIcon%, %ConfigFile%, KeyState, ShowTrayIcon
	IniWrite, %ks_IgnoreClasses%, %ConfigFile%, KeyState, MiniOSDIgnore
	IniWrite, %ks_IgnoreClassesCompletly%, %ConfigFile%, KeyState, IgnoreClasses
	IniWrite, %ks_ShowTime%, %ConfigFile%, KeyState, ShowTime
	If ks_ShowTime = 1
		GuiControl, %GuiID_KeyStateMiniOSD%:Show, ks_miniOSDtime
	Else
		GuiControl, %GuiID_KeyStateMiniOSD%:Hide, ks_miniOSDtime

	IniWrite, %ks_CapsSoundMode1%, %ConfigFile%, KeyState, CapsSoundMode1
	IniWrite, %ks_CapsSoundMode2%, %ConfigFile%, KeyState, CapsSoundMode2
	IniWrite, %ks_ScrollSoundMode1%, %ConfigFile%, KeyState, ScrollSoundMode1
	IniWrite, %ks_ScrollSoundMode2%, %ConfigFile%, KeyState, ScrollSoundMode2
	IniWrite, %ks_NumSoundMode1%, %ConfigFile%, KeyState, NumSoundMode1
	IniWrite, %ks_NumSoundMode2%, %ConfigFile%, KeyState, NumSoundMode2
	IniWrite, %ks_InsSoundMode1%, %ConfigFile%, KeyState, InsSoundMode1
	IniWrite, %ks_InsSoundMode2%, %ConfigFile%, KeyState, InsSoundMode2
	IniWrite, %ks_IgnoreSounds%, %ConfigFile%, KeyState, IgnoreSounds
	IniWrite, %ks_SoundFile%, %ConfigFile%, KeyState, SoundFile

	IniWrite, %ks_IconFile%, %ConfigFile%, KeyState, IconFile
Return

AddSettings_KeyState:
Return

CancelSettings_KeyState:
Return

DoEnable_KeyState:
	If ks_ShowTime = 1
		GuiControl, %GuiID_KeyStateMiniOSD%:Show, ks_miniOSDtime
	Else
		GuiControl, %GuiID_KeyStateMiniOSD%:Hide, ks_miniOSDtime
	SetTimer, ks_tim_OSD, 50
	If ks_ShowInTitleBar = 1
	{
		If ks_miniVisible = 1
			Gui, %GuiID_KeyStateMiniOSD%:Show, x%ks_X% y%ks_Y% w100 H16 NA NoActivate, KeyStateMiniOSD          ; inTitelleiste
		SetTimer, ks_tim_miniOSD, 5
	}
	If ks_ShowTrayIcon = 1
	{
		CustomIcon = 1
		ks_IconNr := (ks_actCapsLock="D")*4+(ks_actScrollLock="D")*2+(ks_actNumLock="D")*1+(A_IsSuspended<>1)*8+1
		Menu, Tray, Icon, %ks_icons%, %ks_IconNr%, 1
	}
Return

DoDisable_KeyState:
	SetTimer, ks_tim_OSD, Off
	SetTimer, ks_tim_miniOSD, Off
	Gui, %GuiID_KeyStateMiniOSD%:Cancel
	Gui, %GuiID_KeyStateOSD%:Cancel
	CustomIcon =
	If temporarySuspended =
		Gosub, sub_ChangeIcon
	CustomIcon =
Return

OnSuspend_KeyState:
	If ks_ShowTrayIcon = 1
	{
		CustomIcon = 1
		ks_IconNr := (ks_actCapsLock="D")*4+(ks_actScrollLock="D")*2+(ks_actNumLock="D")*1+(A_IsSuspended<>1)*8+1
		Menu, Tray, Icon, %ks_icons%, %ks_IconNr%, 1
	}
	Gosub, DoDisable_KeyState
Return

OnResume_KeyState:
	If ks_ShowTrayIcon = 1
	{
		CustomIcon = 1
		ks_IconNr := (ks_actCapsLock="D")*4+(ks_actScrollLock="D")*2+(ks_actNumLock="D")*1+(A_IsSuspended<>1)*8+1
		Menu, Tray, Icon, %ks_icons%, %ks_IconNr%, 1
	}
	Gosub, DoEnable_KeyState
Return

DefaultSettings_KeyState:
Return

Update_KeyState:
	IniRead, ks_SoundMode, %ConfigFile%, KeyState, SoundMode
	IniDelete, %ConfigFile%, KeyState, SoundMode
	If ks_SoundMode = 2
		IniWrite, 1, %ConfigFile%, KeyState, SoundMode1
	If ks_SoundMode = 3
		IniWrite, 1, %ConfigFile%, KeyState, SoundMode2
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

ks_tim_OSD:
	GetKeyState, ks_actCapsLock  , CapsLock  , T
	GetKeyState, ks_actScrollLock, ScrollLock, T
	GetKeyState, ks_actNumLock   , NumLock   , T
	If (ks_InsSoundMode1 = 1 OR ks_InsSoundMode2 = 1)
		GetKeyState, ks_actInsert    , Insert    , T

	ks_Mask = %ks_actCapsLock%%ks_actScrollLock%%ks_actNumLock%%ks_actInsert%
	ks_prevMask = %ks_prevCapsLock%%ks_prevScrollLock%%ks_prevNumLock%%ks_prevInsert%

	WinGetClass, ks_Class, A
	If ks_Class in %ks_IgnoreClassesCompletly%
		Return
	WinGetTitle, ks_Title, A
	If ks_Title contains %ks_IgnoreClassesCompletly%
		Return

	If (ks_actInsert <> ks_prevInsert AND ks_InsSoundMode1 = 1)
		SetTimer, ks_tim_Sound, 5
	If (ks_actInsert <> ks_prevInsert AND ks_InsSoundMode2 = 1)
		SetTimer, ks_tim_SoundBeep, 5

	ks_prevInsert := ks_actInsert

	If (ks_actCapsLock = ks_prevCapsLock AND ks_actScrollLock = ks_prevScrollLock AND ks_actNumLock = ks_prevNumLock AND A_IsSuspended = ks_prevSuspended)
		return

	Settimer, ks_tim_FadeOSD, Off
	Settimer, ks_tim_FadeOSDbegin, Off

	If ks_ShowTrayIcon = 1
	{
		ks_IconNr := (ks_actCapsLock="D")*4+(ks_actScrollLock="D")*2+(ks_actNumLock="D")*1+(A_IsSuspended<>1)*8+1
		Menu, Tray, Icon, %ks_icons%, %ks_IconNr%, 1
	}

	If (ks_actCapsLock = ks_prevCapsLock AND ks_actScrollLock = ks_prevScrollLock AND ks_actNumLock = ks_prevNumLock)
		Return

	If (ks_actCapsLock <> ks_prevCapsLock AND ks_CapsSoundMode1 = 1)
		SetTimer, ks_tim_Sound, 5
	If (ks_actCapsLock <> ks_prevCapsLock AND ks_CapsSoundMode2 = 1)
		SetTimer, ks_tim_SoundBeep, 5
	If (ks_actScrollLock <> ks_prevScrollLock AND ks_ScrollSoundMode1 = 1)
		SetTimer, ks_tim_Sound, 5
	If (ks_actScrollLock <> ks_prevScrollLock AND ks_ScrollSoundMode2 = 1)
		SetTimer, ks_tim_SoundBeep, 5
	If (ks_actNumLock <> ks_prevNumLock AND ks_NumSoundMode1 = 1)
		SetTimer, ks_tim_Sound, 5
	If (ks_actNumLock <> ks_prevNumLock AND ks_NumSoundMode2 = 1)
		SetTimer, ks_tim_SoundBeep, 5

	ks_prevCapsLock   := ks_actCapsLock
	ks_prevScrollLock := ks_actScrollLock
	ks_prevNumLock    := ks_actNumLock
	ks_prevSuspended  := A_IsSuspended

	ks_transparent = 200 ; Anfangstransparenz

	; Position berechnen
	ks_posY  := A_ScreenHeight - (A_ScreenHeight / 8) - 43

	If ks_actCapsLock = D
	{
		GuiControl, %GuiID_KeyStateOSD%:Show, ks_OSDcaps
		GuiControl, %GuiID_KeyStateMiniOSD%:Show, ks_miniOSDcaps
		Gui, %GuiID_KeyStateOSD%:Font, S%FontSize% C959595 Bold, MS Sans Serif
		GuiControl, %GuiID_KeyStateOSD%:Font, ks_TXTcaps
		If ks_ShowTime = 1
		{
			Gui, %GuiID_KeyStateMiniOSD%:Font, S5 C959595, Terminal
			GuiControl, %GuiID_KeyStateMiniOSD%:Font, ks_miniOSDtime
			GuiControl, %GuiID_KeyStateMiniOSD%:Show, ks_miniOSDtime
		}
		Else
			GuiControl, %GuiID_KeyStateMiniOSD%:Hide, ks_miniOSDtime
	}
	Else
	{
		GuiControl, %GuiID_KeyStateOSD%:Hide, ks_OSDcaps
		GuiControl, %GuiID_KeyStateMiniOSD%:Hide, ks_miniOSDcaps
		Gui, %GuiID_KeyStateOSD%:Font, S%FontSize% CFFFFFF Bold, MS Sans Serif
		GuiControl, %GuiID_KeyStateOSD%:Font, ks_TXTcaps
		If ks_ShowTime = 1
		{
			Gui, %GuiID_KeyStateMiniOSD%:Font, S5 CFFFFFF, Terminal
			GuiControl, %GuiID_KeyStateMiniOSD%:Font, ks_miniOSDtime
			GuiControl, %GuiID_KeyStateMiniOSD%:Show, ks_miniOSDtime
		}
		Else
			GuiControl, %GuiID_KeyStateMiniOSD%:Hide, ks_miniOSDtime
	}
	If ks_actScrollLock = D
	{
		GuiControl, %GuiID_KeyStateOSD%:Show, ks_OSDscroll
		GuiControl, %GuiID_KeyStateMiniOSD%:Show, ks_miniOSDscroll
		Gui, %GuiID_KeyStateOSD%:Font, S%FontSize% C959595 Bold, MS Sans Serif
		GuiControl, %GuiID_KeyStateOSD%:Font, ks_TXTscroll
	}
	Else
	{
		GuiControl, %GuiID_KeyStateOSD%:Hide, ks_OSDscroll
		GuiControl, %GuiID_KeyStateMiniOSD%:Hide, ks_miniOSDscroll
		Gui, %GuiID_KeyStateOSD%:Font, S%FontSize% CFFFFFF Bold, MS Sans Serif
		GuiControl, %GuiID_KeyStateOSD%:Font, ks_TXTscroll
	}
	If ks_actNumLock = D
	{
		GuiControl, %GuiID_KeyStateOSD%:Show, ks_OSDnum
		GuiControl, %GuiID_KeyStateMiniOSD%:Show, ks_miniOSDnum
		Gui, %GuiID_KeyStateOSD%:Font, S%FontSize% C959595 Bold, MS Sans Serif
		GuiControl, %GuiID_KeyStateOSD%:Font, ks_TXTnum
	}
	Else
	{
		GuiControl, %GuiID_KeyStateOSD%:Hide, ks_OSDnum
		GuiControl, %GuiID_KeyStateMiniOSD%:Hide, ks_miniOSDnum
		Gui, %GuiID_KeyStateOSD%:Font, S%FontSize% CFFFFFF Bold, MS Sans Serif
		GuiControl, %GuiID_KeyStateOSD%:Font, ks_TXTnum
	}

	If (ks_ShowOSD=1 AND !func_isFullScreen())
	{
		Gui, %GuiID_KeyStateOSD%:Show, w226 H85 y%ks_posY% NA NoActivate           ; Symbol darstellen
		WinSet, AlwaysOnTop, Off, ahk_id %ks_OSDid%
		WinSet, AlwaysOnTop, On, ahk_id %ks_OSDid%
		WinSet, TransColor,0000FF %ks_transparent%, ahk_id %ks_OSDid%
	}
	Settimer, ks_tim_FadeOSDbegin, 1500
Return

ks_tim_MiniOSD:
	If LoadingFinished <> 1
		Return

	If func_isFullScreen() = 1
	{
		Gui, %GuiID_KeyStateMiniOSD%:Cancel
		ks_Class =
		ks_WinX =
		Return
	}

	WinGetClass, ks_Class, A
	WinGetPos, ks_WinX, ks_WinY, ks_WinW, ks_WinH, A
	WinGetTitle, ks_Title, A

	FormatTime, ks_Time, %A_Now%, HH:mm
	If (ks_Time <> ks_LastTime)
		GuiControl, %GuiID_KeyStateMiniOSD%:, ks_miniOSDtime, %ks_Time%
	ks_LastTime = %ks_Time%

	If (ks_Title = "KeyStateMiniOSD")
	{
		Gui, %GuiID_KeyStateMiniOSD%:Cancel
		Sleep,100
		WinGetClass, ks_Class, A
		;WinGetPos, ks_WinX, ks_WinY, ks_WinW, ks_WinH, ahk_class %ks_Class%
		Gui, %GuiID_KeyStateMiniOSD%:Show, x%ks_X% y%ks_Y% w100 H16 NA NoActivate, KeyStateMiniOSD       ; inTitelleiste
	}

	If ks_Class in Shell_TrayWnd,Progman,WorkerW,BaseBar,SysListView321,#32770,DockCatcher,DockBackgroundClass,DockItemClass,DockItemPoof,AgentAnim,tooltips_class32,FreeDPSlideClass,PSFloatC,hh_popup
	{
		ks_WinX =
		ks_Class =
	}
	Else If ks_Class in %ks_IgnoreClasses%
	{
		ks_WinX =
		ks_Class =
	}
	Else If ks_Title contains %ks_IgnoreClasses%
	{
		ks_WinX =
		ks_Class =
	}
	Else If ks_Class in %ks_IgnoreClassesCompletly%
	{
		ks_WinX =
		ks_Class =
	}
	Else If ks_Title contains %ks_IgnoreClassesCompletly%
	{
		ks_WinX =
		ks_Class =
	}
	Else
	{
		WinGetPos, ks_WinX, ks_WinY, ks_WinW, ks_WinH, A
	}

	Winget, ks_MinMax, MinMax, ahk_class %ks_Class%

	If (ks_MinMax = -1 OR ks_MinMax = "")
	{
		ks_miniVisible =
		Gui, %GuiID_KeyStateMiniOSD%:Cancel
		ks_WinX = -2000
		ks_WinY = 0
	}

	If (((ks_WinX <> ks_LastX OR ks_WinY <> ks_LastY) OR ks_LastClass <> ks_Class) AND ks_Class <> "" )
	{
		ks_X := ks_WinX+ks_WinW-100-75
		ks_Y := ks_WinY+BorderHeight

		if (ks_X + 100 > WorkAreaRight)
			ks_X := WorkAreaRight - 100
		if (ks_X < WorkAreaLeft)
		{
			ks_X := WorkAreaLeft
		}
		if (ks_Y + 16 > WorkAreaBottom)
			ks_Y := WorkAreaBottom - 16
		if (ks_Y < WorkAreaTop)
		{
			ks_Y := WorkAreaTop
		}

		Gui, %GuiID_KeyStateMiniOSD%:Show, x%ks_X% y%ks_Y% w100 H16 NA NoActivate, KeyStateMiniOSD           ; inTitelleiste
		ks_miniVisible = 1

		ks_LastClass = %ks_Class%
		ks_LastX = %ks_WinX%
		ks_LastY = %ks_WinY%
	}
	Else If ks_Class =
	{
		Gui, %GuiID_KeyStateMiniOSD%:Cancel
		ks_LastClass =
	}
Return

ks_tim_FadeOSDbegin:
	ks_StartTicks = %A_TickCount%
	SetTimer, ks_tim_FadeOSD, 5
	SetTimer, ks_tim_FadeOSDbegin, Off
Return

ks_tim_FadeOSD: ; Transparenz runterzählen
	ks_Ticks := (A_TickCount-ks_StartTicks) / 500
	ks_transparent := ks_transparent - ks_FadeSpeed * ks_Ticks   ; Transparenz runterzählen
	if ks_transparent < 1
	{
		Settimer, ks_tim_FadeOSD, Off
		WinSet, TransColor,0000FF 0, ahk_id %ks_OSDid%  ; Transparenz setzen
		Gui, %GuiID_KeyStateOSD%:Cancel
	}
	Else
		WinSet, TransColor,0000FF %ks_transparent%, ahk_id %ks_OSDid%  ; Transparenz setzen
Return

ks_tim_Sound:
	Critical
	SetTimer, ks_tim_Sound, Off
	StringReplace, ks_Mask, ks_Mask, D, 1, A
	StringReplace, ks_Mask, ks_Mask, U, 0, A
	StringReplace, ks_prevMask, ks_prevMask, D, 1, A
	StringReplace, ks_prevMask, ks_prevMask, U, 0, A
	SetBatchlines, 1

	WinGetClass, ks_Class, A
	If ks_Class in %ks_IgnoreClasses%
		Return

	SoundPlay, %ks_WAV%, 1
	If ( (ks_Mask - ks_prevMask) < 0 )
		SoundPlay, %ks_WAV%
Return

ks_tim_SoundBeep:
	Critical
	SetTimer, ks_tim_SoundBeep, Off
	StringReplace, ks_Mask, ks_Mask, D, 1, A
	StringReplace, ks_Mask, ks_Mask, U, 0, A
	StringReplace, ks_prevMask, ks_prevMask, D, 1, A
	StringReplace, ks_prevMask, ks_prevMask, U, 0, A
	SetBatchlines, 1

	WinGetClass, ks_Class, A
	If ks_Class in %ks_IgnoreClasses%
		Return

	SoundBeep, 2000, 10
	Sleep, 60
	If ( (ks_Mask - ks_prevMask) < 0 )
		SoundBeep, 2000, 10
Return

ks_sub_addApp:
	StringReplace, ks_VarApp, A_GuiControl, Add_,
	GuiControlGet, %ks_VarApp%_Tmp,,%ks_VarApp%
	WinSet,Bottom,, %ScriptTitle%
	SplashImage,,b1 cwFFFF80 FS9 WS700, %lng_AddApps%
	Gui,+Disabled
	Input,ks_GetKey,,{Enter}{ESC}
	StringReplace,ks_GetKey,ErrorLevel,Endkey:
	SplashImage, Off
	Gui,-Disabled
	WinGetClass, ks_GetName, A
	If ks_Getkey = Enter
	{
		IfNotInstring, %ks_VarApp%_Tmp, %ks_GetName%
		{
			%ks_VarApp%_Tmp := %ks_VarApp%_Tmp "`n" ks_GetName
			StringReplace, %ks_VarApp%_Tmp, %ks_VarApp%_Tmp, `n`n, `n, A
			StringReplace, %ks_VarApp%_Tmp, %ks_VarApp%_Tmp, `n`n, `n, A
			If (func_StrLeft(%ks_VarApp%_Tmp,1) = "`n")
				StringTrimLeft, %ks_VarApp%_Tmp, %ks_VarApp%_Tmp, 1
			If (func_StrRight(%ks_VarApp%_Tmp,1) = "`n")
				StringTrimRight, %ks_VarApp%_Tmp, %ks_VarApp%_Tmp, 1
			GuiControl,,%ks_VarApp%, % %ks_VarApp%_Tmp
		}
	}
	Gui,Show
	WinSet, Top, , %ScriptTitle%
	func_SettingsChanged("KeyState")
Return
