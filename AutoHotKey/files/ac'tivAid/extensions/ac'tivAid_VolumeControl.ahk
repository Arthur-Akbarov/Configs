; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               VolumeControl
; -----------------------------------------------------------------------------
; Prefix:             vc_
; Version:            0.3.1
; Date:               2008-08-13
; Author:             Wolfgang Reszel, Michael Telgkamp
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; Schaltet die Lautstärke zwischen zwei Werten um. Es stehen dabei zwei
; unabhängige Kürzel zur Verfügung.

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------
#Include %A_ScriptDir%\Library\VA.ahk

init_VolumeControl:
	Prefix = vc
	%Prefix%_ScriptName    = VolumeControl
	%Prefix%_ScriptVersion = 0.3.1
	%Prefix%_Author        = Wolfgang Reszel, Michael Telgkamp

	IconFile_On_VolumeControl = %A_WinDir%\system32\shell32.dll
	IconPos_On_VolumeControl = 169

	CreateGuiID("VolumeControl")

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %vc_ScriptName% - Tastaturkürzel für Lautstärke
		Description                   = Bietet Tastaturkürzel für die Systemlautstärke, welche ähnlich Mac OS X grafisch dargestellt wird.
		lng_vc_VolUp                  = Lauter
		lng_vc_VolDown                = Leiser
		lng_vc_VolMute                = Stumm an/aus
		lng_vc_ShowOSD                = Grafische Anzeige (OSD)
		lng_vc_PlaySound              = akustisches Signal
		lng_vc_DeviceAndComponent     = Gerät und Regler
		lng_vc_TempDisableSound       = Signal/OSD unterdrücken mit
		lng_vc_HotkeyError            = Die Zusatztaste, um das Signal zu unterdrücken,`nsteht im Konflikt mit anderen Tastaturkürzeln!`nBitte wählen Sie eine andere Zusatztaste.
		lng_vc_logVolChange           = Logarithmische Volumenänderung
		lng_vc_VolAddSub              = Schrittweite
		lng_vc_VistaCompatibility     = VolumeControl wurde nun vollständig an Vista angepasst. Der in vorherigen Versionen empfohlene Windows-XP-Kompatibilitäts-Modus (von AutoHotkey.exe) muss wieder rückgängig gemacht werden.`nDies erfordert Zugriff auf die Registry; Sie müssen ac'tivAid danach manuell neu starten.`nSoll ac'tivAid nun die Einstellung vornehmen und sich selbst beenden?
		lng_vc_sub_VistaCompatibility = Kompatibilität zu Vista herstellen
		lng_vc_watchVolumeChanges     = OSD anzeigen, wenn die Systemlautstärke sich ändert
	}
	else        ; = other languages (english)
	{
		MenuName                       = %vc_ScriptName% - controlling volume
		Description                    = Provides hotkeys for controlling the system volume. It provides visual feedback like in Mac OS X.
		lng_vc_MasterVolume           = master volume
		lng_vc_VolUp                  = Up
		lng_vc_VolDown                = Down
		lng_vc_VolMute                = Mute/On
		lng_vc_ShowOSD                = Visual feedback (OSD)
		lng_vc_PlaySound              = Enable acoustic feedback
		lng_vc_DeviceAndComponent     = Device and component:
		lng_vc_TempDisableSound       = Suspend feedback/OSD with:
		lng_vc_HotkeyError            = The key to suspend the feedback`nis in conflict with other hotkeys!`nPlease choose another key.
		lng_vc_logVolChange           = logarithmic change
		lng_vc_VolAddSub              = Increment
		lng_vc_VistaCompatibility     = VolumeControl now is fully adapted to Vista, ac'tivAid/AutoHotkeys doesn't need to be started in the XP compatibility mode anymore.`nShall a'ctivAid modify the Registry for you (you have to manually restart ac'tivAid)?
		lng_vc_sub_VistaCompatibility = Make VolumeControl Vista compatible
		lng_vc_watchVolumeChanges     = Show OSD when volume changes
	}

	If CustomLanguage <>
		gosub, CustomLanguage

	if(!gdiP_enabled)
	{
		If activAid_HasChanged = 1
		{
			IfNotExist, extensions\Media\ac'tivAid_VolumeControl_vol.wav
			{
				func_UnpackSplash("extensions\Media\ac'tivAid_VolumeControl_vol2.gif")
				FileInstall, extensions\Media\ac'tivAid_VolumeControl_vol2.gif, extensions\Media\ac'tivAid_VolumeControl_vol2.gif
				func_UnpackSplash("extensions\Media\ac'tivAid_VolumeControl_vol.wav")
				FileInstall, extensions\Media\ac'tivAid_VolumeControl_vol.wav, extensions\Media\ac'tivAid_VolumeControl_vol.wav
				func_UnpackSplash("extensions\Media\ac'tivAid_VolumeControl_vol.gif")
				FileInstall, extensions\Media\ac'tivAid_VolumeControl_vol.gif, extensions\Media\ac'tivAid_VolumeControl_vol.gif
				func_UnpackSplash("extensions\Media\ac'tivAid_VolumeControl_mute.gif")
				FileInstall, extensions\Media\ac'tivAid_VolumeControl_mute.gif, extensions\Media\ac'tivAid_VolumeControl_mute.gif
			}
		}
		vc_FadeSpeed = 5
	}

	Loop, 2
	{
		vc_Hotkey = %A_Index%
		If vc_Hotkey = 1
			vc_Hotkey =

		func_HotkeyRead( "vc_VolUp" vc_Hotkey,   ConfigFile, vc_ScriptName, "VolUp" vc_Hotkey,   "vc_VolUp" vc_Hotkey,   A_Index = 1 ? "#Up" : "" )
		func_HotkeyRead( "vc_VolDown" vc_Hotkey, ConfigFile, vc_ScriptName, "VolDown" vc_Hotkey, "vc_VolDown" vc_Hotkey, A_Index = 1 ? "#Down" : "" )
		func_HotkeyRead( "vc_VolMute" vc_Hotkey, ConfigFile, vc_ScriptName, "VolMute" vc_Hotkey, "vc_VolMute" vc_Hotkey, A_Index = 1 ? "Pause" : "" )

		IniRead, vc_EnableOSD%vc_Hotkey%, %ConfigFile%, %vc_ScriptName%, OSD%vc_Hotkey%, 1
		IniRead, vc_EnableSound%vc_Hotkey%, %ConfigFile%, %vc_ScriptName%, Sound%vc_Hotkey%, 1
		IniRead, vc_TempDisableSound%vc_Hotkey%, %ConfigFile%, %vc_ScriptName%, TempDisableSoundKey%vc_Hotkey%, %A_Space%
		IniRead, vc_Device%vc_Hotkey%, %ConfigFile%, %vc_ScriptName%, Device%vc_Hotkey%, 1
		If A_OSVersion = WIN_VISTA
			IniRead, vc_Component%vc_Hotkey%, %ConfigFile%, %vc_ScriptName%, Component%vc_Hotkey%, 1
		Else
			IniRead, vc_Component%vc_Hotkey%, %ConfigFile%, %vc_ScriptName%, Component%vc_Hotkey%, MASTER
		IniRead, vc_log_change%vc_Hotkey%, %ConfigFile%, %vc_ScriptName%, LogarithmicChange%vc_Hotkey%, 0
		IniRead, vc_VolAddSub%vc_Hotkey%, %ConfigFile%, %vc_ScriptName%, VolumeIncrement%vc_Hotkey%, 5
	}
	IniRead, vc_CheckCompatibility, %ConfigFile%, %vc_ScriptName%, CheckCompatibility

	RegisterAdditionalSetting("vc", "watchVolumeChanges", 1)

	If (aa_osversionnumber >= aa_osversionnumber_vista AND A_OSVersion <> "WIN_VISTA")
		RegisterAdditionalSetting("vc", "sub_VistaCompatibility", 0, "Type:SubRoutine " . ((A_OSVersion <> "WIN_VISTA") ? "" : "Disabled") )
Return

AfterLoadingProcess_VolumeControl:
	If (aa_osversionnumber >= aa_osversionnumber_vista AND A_OSVersion <> "WIN_VISTA")
	{
		If A_IsCompiled = 1
		{
			If vc_CheckCompatibility =
				Return
			RegRead, vc_VistaCompatibility, HKEY_CURRENT_USER, Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %A_ScriptFullPath%
		}
		Else
		{
			If vc_CheckCompatibility =
				Return
			RegRead, vc_VistaCompatibility, HKEY_CURRENT_USER, Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %A_AhkPath%
		}
		IniWrite, %A_Space%, %ConfigFile%, %vc_ScriptName%, CheckCompatibility
		MsgBox, 52, %vc_ScriptTitle%, %lng_vc_VistaCompatibility%
		IfMsgBox, Yes
		{
			If A_IsCompiled = 1
				RegDelete, HKEY_CURRENT_USER, Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %A_ScriptFullPath%
			Else
				RegDelete, HKEY_CURRENT_USER, Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %A_AhkPath%
			Reload = 2
			Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
			Run, %FileBrowserSelect%%A_ScriptFullPath%,,UseErrorLevel
			ExitApp
		}
	}
Return

SettingsGui_VolumeControl:
	Gosub, vc_sub_GetDevices

	Gui, Add, GroupBox, xs+0 yp-1 w570 h147
	Gui, Add, GroupBox, xs+0 ys+140 w570 h147

	func_HotkeyAddGuiControl( lng_vc_VolUp, "vc_VolUp",     "xs+10 yp-123 W85" )
	Gui, Add, Text, x+10 yp+3, %lng_vc_TempDisableSound%
	func_HotkeyAddGuiControl( lng_vc_VolDown, "vc_VolDown", "xs+10 y+10 W85" )
	Gui, Add, DropDownList, -Wrap x+10 w120 gvc_sub_CheckIfSettingsChanged vvc_TempDisableSound_tmp, %lng_None%|%lng_kbShift%|%lng_kbAlt%|%lng_kbCtrl%|%lng_kbWin%|%lng_Right% %lng_kbWin%
	func_HotkeyAddGuiControl( lng_vc_VolMute, "vc_VolMute", "xs+10 y+5 W85" )

	Gui, Add, Text, xs+10 y+10 w86, %lng_vc_DeviceAndComponent%:
	If A_OSVersion = WIN_VISTA
		Gui, Add, DropDownList, -Wrap gvc_sub_CheckIfSettingsChanged vvc_Device x+5 yp-4 w298, %vc_Devices%
	Else
		Gui, Add, DropDownList, -Wrap gvc_sub_CheckIfSettingsChanged vvc_Device x+5 yp-4 w40, %vc_Devices%
	GuiControl, ChooseString, vc_Device, %vc_Device%


	If A_OSVersion = WIN_VISTA
		Gui, Add, DropDownList, -Wrap AltSubmit gvc_sub_CheckIfSettingsChanged vvc_Component x+5 w150, %vc_Components%
	Else
		Gui, Add, DropDownList, -Wrap gvc_sub_CheckIfSettingsChanged vvc_Component x+5 w110, %vc_Components%

	Gui, Add, Checkbox, -wrap gvc_sub_CheckIfSettingsChanged vvc_log_change x+10 yp+5 checked%vc_log_change%, %lng_vc_logVolChange%

	Gui, Add, Text, xs+10 y+10 w85, %lng_vc_VolAddSub%:
	Gui, Add, Edit, x+5 yp-3 Number Limit3 w47 vvc_VolAddSub gsub_CheckIfSettingsChanged, %vc_VolAddSub%
	Gui, Add, UpDown, Range0-100, %vc_VolAddSub%

	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged vvc_EnableOSD x+20 yp+4 Checked%vc_EnableOSD%, %lng_vc_ShowOSD%
	Gui, Add, CheckBox, -Wrap gvc_sub_CheckIfSettingsChanged vvc_EnableSound x+20 Checked%vc_EnableSound%, %lng_vc_PlaySound%

	;------------------------------------------------------------------------;

	func_HotkeyAddGuiControl( lng_vc_VolUp, "vc_VolUp2",     "xs+10 y+28 W85" )
	Gui, Add, Text, x+10 yp+3, %lng_vc_TempDisableSound%
	func_HotkeyAddGuiControl( lng_vc_VolDown, "vc_VolDown2", "xs+10 y+10 W85" )
	Gui, Add, DropDownList, -Wrap x+10 w120 gvc_sub_CheckIfSettingsChanged vvc_TempDisableSound2_tmp, %lng_None%|%lng_kbShift%|%lng_kbAlt%|%lng_kbCtrl%|%lng_kbWin%|%lng_Right% %lng_kbWin%
	func_HotkeyAddGuiControl( lng_vc_VolMute, "vc_VolMute2", "xs+10 y+5 W85" )

	Gui, Add, Text, xs+10 y+10 w86, %lng_vc_DeviceAndComponent%:
	If A_OSVersion = WIN_VISTA
		Gui, Add, DropDownList, -Wrap gvc_sub_CheckIfSettingsChanged vvc_Device2 x+5 yp-4 w298, %vc_Devices%
	Else
		Gui, Add, DropDownList, -Wrap gvc_sub_CheckIfSettingsChanged vvc_Device2 x+5 yp-4 w40, %vc_Devices%
	GuiControl, ChooseString, vc_Device2, %vc_Device2%

	If A_OSVersion = WIN_VISTA
		Gui, Add, DropDownList, -Wrap AltSubmit gvc_sub_CheckIfSettingsChanged vvc_Component2 x+5 w150, %vc_Components%
	Else
		Gui, Add, DropDownList, -Wrap gvc_sub_CheckIfSettingsChanged vvc_Component2 x+5 w110, %vc_Components%

	Gui, Add, Checkbox, -wrap gvc_sub_CheckIfSettingsChanged vvc_log_change2 x+10 yp+5 checked%vc_log_change2%, %lng_vc_logVolChange%

	Gui, Add, Text, xs+10 y+10 w85, %lng_vc_VolAddSub%:
	Gui, Add, Edit, x+5 yp-3 Number Limit3 w47 vvc_VolAddSub2 gsub_CheckIfSettingsChanged, %vc_VolAddSub2%
	Gui, Add, UpDown, Range0-100, %vc_VolAddSub%

	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged vvc_EnableOSD2 x+20 yp+4 Checked%vc_EnableOSD2%, %lng_vc_ShowOSD%
	Gui, Add, CheckBox, -Wrap gvc_sub_CheckIfSettingsChanged vvc_EnableSound2 x+20 Checked%vc_EnableSound2%, %lng_vc_PlaySound%

	Loop, 2
	{
		vc_Hotkey = %A_Index%
		If vc_Hotkey = 1
			vc_Hotkey =

		If vc_TempDisableSound%vc_Hotkey% =
			GuiControl, Choose, vc_TempDisableSound%vc_Hotkey%_tmp, 1
		If vc_TempDisableSound%vc_Hotkey% = Shift
			GuiControl, ChooseString, vc_TempDisableSound%vc_Hotkey%_tmp, %lng_kbShift%
		If vc_TempDisableSound%vc_Hotkey% = Alt
			GuiControl, ChooseString, vc_TempDisableSound%vc_Hotkey%_tmp, %lng_kbAlt%
		If vc_TempDisableSound%vc_Hotkey% = Ctrl
			GuiControl, ChooseString, vc_TempDisableSound%vc_Hotkey%_tmp, %lng_kbCtrl%
		If vc_TempDisableSound%vc_Hotkey% = LWin
			GuiControl, ChooseString, vc_TempDisableSound%vc_Hotkey%_tmp, %lng_kbWin%
		If vc_TempDisableSound%vc_Hotkey% = RWin
			GuiControl, ChooseString, vc_TempDisableSound%vc_Hotkey%_tmp, %lng_Right% %lng_kbWin%

		GuiControlGet, vc_TempDisableSound%vc_Hotkey%_old,, vc_TempDisableSound%vc_Hotkey%_tmp

		vc_Device%vc_Hotkey%_old=
	}
	Gosub, vc_sub_CheckIfSettingsChanged
Return

SaveSettings_VolumeControl:
	Loop, 2
	{
		vc_Hotkey = %A_Index%
		If vc_Hotkey = 1
			vc_Hotkey =

		vc_Device%vc_Hotkey%_old := vc_Device%vc_Hotkey%
		If vc_EnableOSD%vc_Hotkey% = 1
		{
			If A_OSVersion = WIN_VISTA
			{
				vc_LastMaster%vc_Hotkey% := VA_GetVolume(vc_Component%vc_Hotkey%-1,"",vc_Device%vc_Hotkey%)
				vc_LastMute%vc_Hotkey% := VA_GetMute(vc_Component%vc_Hotkey%-1,vc_Device%vc_Hotkey%)
			}
			Else
			{
				SoundGet, vc_LastMaster%vc_Hotkey%, % vc_Component%vc_Hotkey%, , % vc_Device%vc_Hotkey%
				SoundGet, vc_LastMute%vc_Hotkey%, % vc_Component%vc_Hotkey%, Mute, % vc_Device%vc_Hotkey%
			}

			If (vc_LastMute%vc_Hotkey% = "On" OR vc_LastMute%vc_Hotkey% = 1)
				vc_LastMaster%vc_Hotkey% = 0

			vc_LastMaster%vc_Hotkey% := vc_LastMaster%vc_Hotkey%/4.9
		}
		vc_TempDisableSound%vc_Hotkey% := vc_TempDisableSound%vc_Hotkey%_tmp

		If vc_TempDisableSound%vc_Hotkey% = %lng_None%
			vc_TempDisableSound%vc_Hotkey% =
		If vc_TempDisableSound%vc_Hotkey% = %lng_kbAlt%
			vc_TempDisableSound%vc_Hotkey% = Alt
		If vc_TempDisableSound%vc_Hotkey% = %lng_kbShift%
			vc_TempDisableSound%vc_Hotkey% = Shift
		If vc_TempDisableSound%vc_Hotkey% = %lng_kbCtrl%
			vc_TempDisableSound%vc_Hotkey% = Ctrl
		If vc_TempDisableSound%vc_Hotkey% = %lng_kbWin%
			vc_TempDisableSound%vc_Hotkey% = LWin
		If vc_TempDisableSound%vc_Hotkey% = %lng_Right% %lng_kbWin%
			vc_TempDisableSound%vc_Hotkey% = RWin

		func_HotkeyWrite( "vc_VolUp" vc_Hotkey, ConfigFile, vc_ScriptName, "VolUp" vc_Hotkey)
		func_HotkeyWrite( "vc_VolDown" vc_Hotkey, ConfigFile, vc_ScriptName, "VolDown" vc_Hotkey)
		func_HotkeyWrite( "vc_VolMute" vc_Hotkey, ConfigFile, vc_ScriptName, "VolMute" vc_Hotkey)
		IniWrite, % vc_EnableOSD%vc_Hotkey%, %ConfigFile%, %vc_ScriptName%, OSD%vc_Hotkey%
		IniWrite, % vc_EnableSound%vc_Hotkey%, %ConfigFile%, %vc_ScriptName%, Sound%vc_Hotkey%
		IniWrite, % vc_TempDisableSound%vc_Hotkey%, %ConfigFile%, %vc_ScriptName%, TempDisableSoundKey%vc_Hotkey%
		IniWrite, % vc_Device%vc_Hotkey%, %ConfigFile%, %vc_ScriptName%, Device%vc_Hotkey%
		IniWrite, % vc_Component%vc_Hotkey%, %ConfigFile%, %vc_ScriptName%, Component%vc_Hotkey%
		IniWrite, % vc_log_change%vc_Hotkey%, %ConfigFile%, %vc_ScriptName%, LogarithmicChange%vc_Hotkey%
		IniWrite, % vc_VolAddSub%vc_Hotkey%, %ConfigFile%, %vc_ScriptName%, VolumeIncrement%vc_Hotkey%
	}
	IniWrite, %vc_CheckCompatibility%, %ConfigFile%, %vc_ScriptName%, CheckCompatibility
Return

CancelSettings_VolumeControl:
Return

DoEnable_VolumeControl:
	If (vc_Component = "" AND A_OSVersion <> "WIN_VISTA")
		vc_Component = MASTER

	Detecthiddenwindows, On

	IfWinNotExist, ahk_id %vc_GuiID%
		If vc_EnableOSD = 1
		{
			if(!gdiP_enabled)
			{
				vc_transparent = 150

				vc_GuiID := GuiDefault("VolumeControl")
				Gui, +Lastfound +Disabled +ToolWindow -Caption
				Gui, Add, pic, x0 y0 w205 h205 vvc_OSDvpic, %A_ScriptDir%\extensions\Media\ac'tivAid_VolumeControl_vol.gif  ; Bild laden
				Gui, Add, pic, x0 y0 w205 h205 Hidden vvc_OSDmpic, %A_ScriptDir%\extensions\Media\ac'tivAid_VolumeControl_mute.gif  ; Bild laden
				Gui, Color, 959595
				vc_X = 12
				Loop, 20
				{
					Gui, Add, Pic, x%vc_X% y167 w10 h14 vvc_Volume%A_Index%, %A_ScriptDir%\extensions\Media\ac'tivAid_VolumeControl_vol2.gif
					vc_X := vc_X+9
				}
				Gui, Font, c333333
				Gui, Add, Text, BackgroundTrans x11 y11 R3 w185 Center vvc_GuiDeviceInfo,
				Gui, Add, Text, BackgroundTrans x9 y11 R3 w185 Center vvc_GuiDeviceInfo2,
				Gui, Add, Text, BackgroundTrans x11 y9 R3 w185 Center vvc_GuiDeviceInfo3,
				Gui, Add, Text, BackgroundTrans x9 y9 R3 w185 Center vvc_GuiDeviceInfo4,
				Gui, Add, Text, BackgroundTrans x11 y10 R3 w185 Center vvc_GuiDeviceInfo6,
				Gui, Add, Text, BackgroundTrans x9 y10 R3 w185 Center vvc_GuiDeviceInfo7,
				Gui, Add, Text, BackgroundTrans x10 y9 R3 w185 Center vvc_GuiDeviceInfo8,
				Gui, Add, Text, BackgroundTrans x10 y11 R3 w185 Center vvc_GuiDeviceInfo9,
				Gui, Font, cffffff
				Gui, Add, Text, BackgroundTrans x10 y10 R3 w185 Center vvc_GuiDeviceInfo5,
				Gosub, GuiDefaultFont
				WinGet,vc_OSDid, ID
				WinSet, TransColor ,0000FF %vc_transparent% ; Transparenz setzen
				WinSet, ExStyle, +0x80020                    ; Click-Through
				WinSet, AlwaysOnTop, On                      ; Immer im Vordergrund
			}
			else
			{
				if osd_media_ID =
					osd_media_ID := osd_create()
			}
		}

	registerAction("vc_VolUp")
	registerAction("vc_VolDown")
	registerAction("vc_VolMute")
	registerAction("vc_VolUp2")
	registerAction("vc_VolDown2")
	registerAction("vc_VolMute2")

; FIXME: Hier ist noch ein Teil des Fehlers, dass die sekundären Hotkeys (kein OSD zeigen) nicht registriert werden.
	func_HotkeyEnable( "vc_VolUp" )
	func_HotkeyEnable( "vc_VolDown" )
	func_HotkeyEnable( "vc_VolMute" )
	func_HotkeyEnable( "vc_VolUp2" )
	func_HotkeyEnable( "vc_VolDown2" )
	func_HotkeyEnable( "vc_VolMute2" )

	if vc_watchVolumeChanges = 1
	{
		If (vc_EnableOSD = 1)
		{
			If (!gdiP_enabled)
				SetTimer, vc_tim_VolOSD, 100
			else
				SetTimer, vc_tim_GdiPVolOSD, 100
		}
	}
	Gosub, vc_sub_GetDevices

	If A_OSVersion = WIN_VISTA
		COM_Init()

	Loop, 2
	{
		vc_Hotkey = %A_Index%
		If vc_Hotkey = 1
			vc_Hotkey =
		If A_OSVersion = WIN_VISTA
		{
			vc_LastMaster%vc_Hotkey% := VA_GetVolume(vc_Component%vc_Hotkey%-1,"",vc_Device%vc_Hotkey%)
			vc_LastMute%vc_Hotkey% := VA_GetMute(vc_Component%vc_Hotkey%-1,vc_Device%vc_Hotkey%)
		}
		Else
		{
			SoundGet, vc_LastMaster%vc_Hotkey%, % vc_Component%vc_Hotkey%, , % vc_Device%vc_Hotkey%
			SoundGet, vc_LastMute%vc_Hotkey%, % vc_Component%vc_Hotkey%, Mute, % vc_Device%vc_Hotkey%
		}

		If (vc_LastMute%vc_Hotkey% = "On" OR vc_LastMute%vc_Hotkey% = 1)
			vc_LastMaster%vc_Hotkey% = 0

		if(!gdiP_enabled)
		{
			vc_LastMaster%vc_Hotkey% := vc_LastMaster%vc_Hotkey%/4.9
		}
	}
Return

DoDisable_VolumeControl:
	unRegisterAction("vc_VolUp")
	unRegisterAction("vc_VolDown")
	unRegisterAction("vc_VolMute")
	unRegisterAction("vc_VolUp2")
	unRegisterAction("vc_VolDown2")
	unRegisterAction("vc_VolMute2")

; FIXME: Hier ist noch ein Teil des Fehlers, dass die sekundären Hotkeys (kein OSD zeigen) nicht registriert werden. (Ja, man muss auch drauf achten, dass sie wieder freigegeben werde).
	func_HotkeyDisable( "vc_VolUp" )
	func_HotkeyDisable( "vc_VolDown" )
	func_HotkeyDisable( "vc_VolMute" )
	func_HotkeyDisable( "vc_VolUp2" )
	func_HotkeyDisable( "vc_VolDown2" )
	func_HotkeyDisable( "vc_VolMute2" )

	if(!gdiP_enabled)
		SetTimer, vc_tim_VolOSD, Off
	else
		SetTimer, vc_tim_GdiPVolOSD, Off

	If A_OSVersion = WIN_VISTA
		COM_Term()
Return

DefaultSettings_VolumeControl:
Return

; -----------------------------------------------------------------------------
; === SubRoutines =============================================================
; -----------------------------------------------------------------------------
vc_sub_GetDevices:
	vc_Devices =
	If A_OSVersion = WIN_VISTA
	{
		vc_Devices := "|" VA_GetDeviceName(VA_GetDevice())
		Loop
		{
			vc_Temp := VA_GetDevice("playback:" A_Index)
			If vc_Temp = 0
			{
				COM_Release(vc_Temp)
				break
			}
			vc_TempName := VA_GetDeviceName(vc_Temp)
			If (vc_TempName = VA_GetDeviceName(VA_GetDevice()))
				continue
			vc_Devices = %vc_Devices%|%vc_TempName%
			COM_Release(vc_Temp)
		}
		If vc_Device = 1
			vc_Device := VA_GetDeviceName(VA_GetDevice())
		If vc_Device2 = 1
			vc_Device2 := VA_GetDeviceName(VA_GetDevice())
	}
	Else
	{
		Loop
		{
			SoundGet, vc_Temp,,, %A_Index%
			If ErrorLevel = Can't Open Specified Mixer
				break

			vc_Devices = %vc_Devices%|%A_Index%
		}
	}
	StringTrimLeft, vc_Devices, vc_Devices, 1

	Loop, 2
	{
		vc_Hotkey = %A_Index%
		If vc_Hotkey = 1
			vc_Hotkey =
		IF A_OSVersion = WIN_VISTA
		{
			vc_pIPart := VA_GetSpeakersIPart(vc_Device%vc_Hotkey%)
			vc_Components := "MASTER|" VA_EnumerateSubParts_List(vc_pIPart)
			COM_Release(vc_pIPart)
			StringSplit, vc_Components, vc_Components, |
			vc_Component_tmp := vc_Component%vc_Hotkey%
			vc_ComponentName%vc_Hotkey%  := vc_Components%vc_Component_tmp%
		}
		Else
		{
			vc_ComponentName%vc_Hotkey% := vc_Component%vc_Hotkey%
		}
	}
Return

vc_sub_VistaCompatibility:
	SetTimer, sub_AfterLoadingProcesses, Off
	vc_CheckCompatibility = ERROR
	Gosub, AfterLoadingProcess_VolumeControl
Return

vc_sub_CheckIfSettingsChanged:
	Gosub, sub_CheckIfSettingsChanged

	Loop, 2
	{
		vc_Hotkey = %A_Index%
		If vc_Hotkey = 1
			vc_Hotkey =

		GuiControlGet, vc_TempDisableSound%vc_Hotkey%_tmp
		If vc_TempDisableSound%vc_Hotkey%_tmp <> %vc_TempDisableSound%vc_Hotkey%_old%
		{
			If vc_TempDisableSound%vc_Hotkey%_tmp = %lng_None%
				vc_TempDisableSymb =
			If vc_TempDisableSound%vc_Hotkey%_tmp = %lng_kbAlt%
				vc_TempDisableSymb = !
			If vc_TempDisableSound%vc_Hotkey%_tmp = %lng_kbShift%
				vc_TempDisableSymb = +
			If vc_TempDisableSound%vc_Hotkey%_tmp = %lng_kbCtrl%
				vc_TempDisableSymb = ^
			If vc_TempDisableSound%vc_Hotkey%_tmp = %lng_kbWin%
				vc_TempDisableSymb =  <#
			If vc_TempDisableSound%vc_Hotkey%_tmp = %lng_Right% %lng_kbWin%
				vc_TempDisableSymb =  >#

; FIXME: Hier ist noch ein Teil des Fehlers, dass die sekundären Hotkeys (kein OSD zeigen) nicht registriert werden.
			Loop, 3
			{
				If (A_Index = 1 AND Hotkey_vc_VolUp%vc_Hotkey%_new <> "")
				{
					VarHK = Hotkey_vc_VolUp%vc_Hotkey%X
					GetKey := func_SortHotkeyModifiers(vc_TempDisableSymb Hotkey_vc_VolUp%vc_Hotkey%_new)
					If (GetKey = Hotkey_vc_VolUp%vc_Hotkey%_new OR vc_TempDisableSymb = "")
					{
						GetKey =
						Hotkey_vc_VolUp%vc_Hotkey%X_del = 1
					}
				}
				If (A_Index = 2 AND Hotkey_vc_VolDown%vc_Hotkey%_new <> "")
				{
					VarHK = Hotkey_vc_VolDown%vc_Hotkey%X
					GetKey := func_SortHotkeyModifiers(vc_TempDisableSymb Hotkey_vc_VolDown%vc_Hotkey%_new)
					If (GetKey = Hotkey_vc_VolDown%vc_Hotkey%_new OR vc_TempDisableSymb = "")
					{
						GetKey =
						Hotkey_vc_VolDown%vc_Hotkey%X_del = 1
					}
				}
				If (A_Index = 3 AND Hotkey_vc_VolMute%vc_Hotkey%_new <> "")
				{
					VarHK = Hotkey_vc_VolMute%vc_Hotkey%X
					GetKey := func_SortHotkeyModifiers(vc_TempDisableSymb Hotkey_vc_VolMute%vc_Hotkey%_new)
					If (GetKey = Hotkey_vc_VolMute%vc_Hotkey%_new OR vc_TempDisableSymb = "")
					{
						GetKey =
						Hotkey_vc_VolMute%vc_Hotkey%X_del = 1
					}
				}

				vc_Error =
				If GetKey <>
				{
					Hotkey_AllHotkeys_tmp := Hotkey_AllNewHotkeys ; Hotkey_AllHotkeys
					IfNotInstring, Hotkey_AllHotkeys_tmp , % "«<" GetKey " >»"
					{
						StringReplace, Hotkey_AllNewHotkeys, Hotkey_AllNewHotkeys, % "«<" %VarHK%_new " >»" , , A
						%VarHK%_new = %GetKey%
						If %VarHK%_del <> 1
							Hotkey_AllNewHotkeys := Hotkey_AllNewHotkeys "«<" GetKey " >»"
					}
					Else
					{
						Loop, Parse, Hotkey_Extensions, |
						{
							FunctionTmp := A_LoopField
							If Hotkey_Extension[%FunctionTmp%] = %GetKey%
								break
							FunctionTmp =
							FunctionTmp1 =
						}
						StringSplit, FunctionTmp, FunctionTmp, $
						If FunctionTmp1 =
							vc_Error := 1
						Else
							vc_Error := 1
					}
				}
			}

			If vc_Error = 1
			{
				MsgBox, 48, %vc_ScriptName%, %lng_vc_HotkeyError%
				vc_Error =
				GuiControl, Choose, vc_TempDisableSound%vc_Hotkey%_tmp, 1
				;Gosub, vc_sub_CheckIfSettingsChanged
				Return
			}
		}
		vc_TempDisableSound%vc_Hotkey%_old = %vc_TempDisableSound%vc_Hotkey%_tmp%

		GuiControlGet, vc_Device%vc_Hotkey%_tmp,, vc_Device%vc_Hotkey%
		If (vc_Device%vc_Hotkey%_tmp <> vc_Device%vc_Hotkey%_old)
		{
			IF A_OSVersion = WIN_VISTA
			{
				vc_pIPart := VA_GetSpeakersIPart(vc_Device%vc_Hotkey%_tmp)
				vc_Components := "MASTER|" VA_EnumerateSubParts_List(vc_pIPart)
				COM_Release(vc_pIPart)
				GuiControl,,vc_Component%vc_Hotkey%, |%vc_Components%
				GuiControl,Choose, vc_Component%vc_Hotkey%, % vc_Component%vc_Hotkey%
				GuiControlGet, vc_Component%vc_Hotkey%_tmp,, vc_Component%vc_Hotkey%
				If vc_Component%vc_Hotkey%_tmp =
					GuiControl,Choose, vc_Component%vc_Hotkey%, 1
			}
			Else
			{
				vc_TempComp = MASTER,HEADPHONES,DIGITAL,LINE,MICROPHONE,SYNTH,CD,TELEPHONE,PCSPEAKER,WAVE,AUX,ANALOG,HEADPHONES,N/A
				vc_Components =
				Loop, Parse, vc_TempComp, `,
				{
					SoundGet, vc_Tmp, %A_LoopField%,, % vc_Device%vc_Hotkey%_tmp
					if ErrorLevel = Mixer Doesn't Support This Component Type
						continue
					vc_Components = %vc_Components%|%A_LoopField%
				}
				StringTrimLeft, vc_Components, vc_Components, 1
				GuiControl,,vc_Component%vc_Hotkey%, |%vc_Components%
				GuiControl,ChooseString, vc_Component%vc_Hotkey%, % vc_Component%vc_Hotkey%
			}
		}
		vc_Device%vc_Hotkey%_old := vc_Device%vc_Hotkey%_tmp
	}
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------
vc_showOSD(vc_OSDHotkey)
{
	Global
	
	If vc_OSDHotkey = 1
		vc_OSDHotkey =

	If (vc_EnableOSD%vc_OSDHotkey% = 1 AND GetKeyState(vc_TempDisableSound%vc_OSDHotkey%) <> 1)
	{
		SetControlDelay, -1
		SetWinDelay, -1

		If A_OSVersion = WIN_VISTA
		{
			vc_Master%vc_OSDHotkey% := VA_GetVolume(vc_Component%vc_OSDHotkey%-1,"",vc_Device%vc_OSDHotkey%)
			vc_Mute%vc_OSDHotkey% := VA_GetMute(vc_Component%vc_OSDHotkey%-1,vc_Device%vc_OSDHotkey%)
		}
		Else
		{
			SoundGet, vc_Master%vc_OSDHotkey%, % vc_Component%vc_OSDHotkey%, , % vc_Device%vc_OSDHotkey%
			SoundGet, vc_Mute%vc_OSDHotkey%, % vc_Component%vc_OSDHotkey%, Mute, % vc_Device%vc_OSDHotkey%
		}

		; check if volume changed more than 0.01 because of inaccurate volume
		; receivement on Vista systems
		if ((abs(vc_Master%vc_OSDHotkey% - vc_LastMaster%vc_OSDHotkey%) < 0.01 and vc_Mute%vc_OSDHotkey% = vc_LastMute%vc_OSDHotkey%) or (vc_Mute%vc_OSDHotkey% = "On" and vc_LastMute%vc_OSDHotkey% = "On") or (vc_Mute%vc_OSDHotkey% = 1 and vc_LastMute%vc_OSDHotkey% = 1) )
			return

		osd_prepare(osd_media_ID,185,185,-1,-1,1,235,gdip_bgColor,gdip_rounding,1)

		If (Hotkey_vc_VolUp%vc_OSDHotkey% = "" AND Hotkey_vc_VolDown%vc_OSDHotkey% = "")
			return

		If (vc_Mute%vc_OSDHotkey% = "On" OR vc_Mute%vc_OSDHotkey% = 1)
			vc_Master%vc_OSDHotkey% = 0

		vc_MasterTmp%vc_OSDHotkey% := round(vc_Master%vc_OSDHotkey%/5,0)
		vc_Symbol%vc_OSDHotkey% := round(vc_MasterTmp%vc_OSDHotkey%/5.9,0)

		if vc_Master%vc_OSDHotkey% = 0
			osd_pictureNoResize(osd_media_ID,A_ScriptDir "\extensions\Media\ac'tivAid_VolumeControl_mute.png",50,60)
		else
			osd_pictureNoResize(osd_media_ID,A_ScriptDir "\extensions\Media\ac'tivAid_VolumeControl_vol_" vc_Symbol%vc_OSDHotkey% ".png",50,60)

		vc_Device_tmp := RegExReplace(vc_Device%vc_OSDHotkey%,"^.*\( *(.*) *\)","$1")

		osd_borderText(osd_media_ID,vc_ComponentName%vc_OSDHotkey% "`n" vc_Device_tmp,"R0 Cff" gdip_fontColorHeader " S" gdip_fontSizeHeader " Center","R0 Caa" gdip_fontColorHeaderBorder " S" gdip_fontSizeHeader " Center",10,10,gdip_fontFamilyHeader,165)

		If (vc_EnableSound%vc_OSDHotkey% = 1 AND GetKeyState(vc_TempDisableSound%vc_OSDHotkey%) <> 1 AND vc_Master%vc_OSDHotkey% <> vc_LastMaster%vc_OSDHotkey%)
		{
			SoundPlay,%A_ScriptDir%\extensions\Media\ac'tivAid_VolumeControl_vol.wav
		}

		vc_LastMaster%vc_OSDHotkey% := vc_Master%vc_OSDHotkey%
		vc_LastMute%vc_OSDHotkey%   := vc_Mute%vc_OSDHotkey%

		;osd_bars(osd_media_ID,20,vc_MasterTmp%vc_OSDHotkey%,5,170,oTest_bgbColor)
		osd_pixelBar(osd_media_ID,155,12,vc_Master%vc_OSDHotkey%,15,160)
		osd_show(osd_media_ID)
		osd_fade(osd_media_ID)
	}
}


vc_VolUp:
vc_VolUp2:
	StringRight,vc_Hotkey, A_ThisLabel, 1
	vc_Hotkey := vc_Hotkey+0
	If A_OSVersion = WIN_VISTA
		vc_VolCurrent := VA_GetVolume(vc_Component%vc_Hotkey%-1,"",vc_Device%vc_Hotkey%)
	else
		SoundGet, vc_VolCurrent, % vc_Component%vc_Hotkey%, , % vc_Device%vc_Hotkey%
	if(vc_log_change%vc_Hotkey%)
	{
		vc_VolNew := vc_VolCurrent*1.445
		if (vc_VolNew < 0.1)
			vc_VolNew := 0.14
		if (vc_VolNew > 99)
			vc_VolNew := 100
	}
	else
	{
		vc_VolNew := vc_VolCurrent+vc_VolAddSub%vc_Hotkey%
	}
	if A_OSVersion = WIN_VISTA
	{
		VA_SetMute(0,vc_Component%vc_Hotkey%,vc_Device%vc_Hotkey%)
		VA_SetVolume(vc_VolNew,vc_Component%vc_Hotkey%-1,"",vc_Device%vc_Hotkey%)
	}
	else
	{
		SoundSet, 0, % vc_Component%vc_Hotkey%, mute, % vc_Device%vc_Hotkey%
		SoundSet, %vc_VolNew%, % vc_Component%vc_Hotkey%, , % vc_Device%vc_Hotkey%       ; Lautstärke Lauter
	}
	vc_ForceOSD%vc_Hotkey% = 1

	if(!gdiP_enabled)
		Gosub, vc_tim_VolOSD
	else
		vc_showOSD(vc_Hotkey)
Return

vc_VolDown:
vc_VolDown2:
	StringRight,vc_Hotkey, A_ThisLabel, 1
	vc_Hotkey := vc_Hotkey+0
	If A_OSVersion = WIN_VISTA
		vc_VolCurrent := VA_GetVolume(vc_Component%vc_Hotkey%-1,"",vc_Device%vc_Hotkey%)
	else
		SoundGet, vc_VolCurrent, % vc_Component%vc_Hotkey%, , % vc_Device%vc_Hotkey%
	if(vc_log_change%vc_Hotkey%)
	{
		vc_VolNew := vc_VolCurrent*0.694
		if (vc_VolNew < 0.1)
			vc_VolNew := 0
	}
	else
	{
		vc_VolNew := vc_VolCurrent-vc_VolAddSub%vc_Hotkey%
	}
	if A_OSVersion = WIN_VISTA
	{
		VA_SetMute(0,vc_Component%vc_Hotkey%,vc_Device%vc_Hotkey%)
		VA_SetVolume(vc_VolNew,vc_Component%vc_Hotkey%-1,"",vc_Device%vc_Hotkey%)
	}
	else
	{
		SoundSet, 0, % vc_Component%vc_Hotkey%, mute, % vc_Device%vc_Hotkey%
		SoundSet, %vc_VolNew%, % vc_Component%vc_Hotkey%, , % vc_Device%vc_Hotkey%       ; Lautstärke Lauter
	}
	vc_ForceOSD%vc_Hotkey% = 1

	if(!gdiP_enabled)
		Gosub, vc_tim_VolOSD
	else
		vc_showOSD(vc_Hotkey)

Return

vc_VolMute:
vc_VolMute2:
	StringRight,vc_Hotkey, A_ThisLabel, 1
	vc_Hotkey := vc_Hotkey+0
	If A_OSVersion = WIN_VISTA
	{
		VA_SetMute(!VA_GetMute(vc_Component%vc_Hotkey%-1,vc_Device%vc_Hotkey%),vc_Component%vc_Hotkey%-1,vc_Device%vc_Hotkey%)
	}
	Else
		SoundSet, +1, % vc_Component%vc_Hotkey%, mute, % vc_Device%vc_Hotkey%   ; Ton an/aus
	vc_ForceOSD%vc_Hotkey% = 1

	if(!gdiP_enabled)
		Gosub, vc_tim_VolOSD
	else
		vc_showOSD(vc_Hotkey)

Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------
vc_tim_GdiPVolOSD:
	If (NOT (Hotkey_vc_VolUp = "" AND Hotkey_vc_VolDown = ""))
		vc_showOSD(1)
	If (NOT (Hotkey_vc_VolUp2 = "" AND Hotkey_vc_VolDown2 = ""))
		vc_showOSD(2)
return


vc_tim_VolOSD:
	Critical
	If LoadingFinished <> 1
		Return

	SetControlDelay, -1
	SetWinDelay, -1

	Loop, 2
	{
		vc_OSDHotkey = %A_Index%
		If vc_OSDHotkey = 1
			vc_OSDHotkey =

		vc_Return =

		If (Hotkey_vc_VolUp%vc_OSDHotkey% = "" OR Hotkey_vc_VolDown%vc_OSDHotkey% = "")
		{
			vc_Return = 1
			continue
		}

		If A_OSVersion = WIN_VISTA
		{
			vc_Master%vc_OSDHotkey% := VA_GetVolume(vc_Component%vc_OSDHotkey%-1,"",vc_Device%vc_OSDHotkey%)
			vc_Mute%vc_OSDHotkey% := VA_GetMute(vc_Component%vc_OSDHotkey%-1,vc_Device%vc_OSDHotkey%)
		}
		Else
		{
			SoundGet, vc_Master%vc_OSDHotkey%, % vc_Component%vc_OSDHotkey%, , % vc_Device%vc_OSDHotkey%
			SoundGet, vc_Mute%vc_OSDHotkey%, % vc_Component%vc_OSDHotkey%, Mute, % vc_Device%vc_OSDHotkey%
		}

		If (vc_Mute%vc_OSDHotkey% = "On" OR vc_Mute%vc_OSDHotkey% = 1)
			vc_Master%vc_OSDHotkey% = 0

		vc_Master%vc_OSDHotkey% := vc_Master%vc_OSDHotkey%/4.9

		If (vc_Master%vc_OSDHotkey% = vc_LastMaster%vc_OSDHotkey% AND vc_Mute%vc_OSDHotkey% = vc_LastMute%vc_OSDHotkey% AND vc_ForceOSD%vc_OSDHotkey% <> 1)
		{
			vc_Return = 1
			continue
		}

		If (vc_EnableOSD%vc_OSDHotkey% = 1 AND GetKeyState(vc_TempDisableSound%vc_OSDHotkey%) <> 1)
		{

			If (vc_Mute%vc_OSDHotkey% <> vc_LastMute%vc_OSDHotkey%)
			{
				If (vc_Mute%vc_OSDHotkey% = "On" OR vc_Mute%vc_OSDHotkey% = 1)
				{
				  GuiControl,%GuiID_VolumeControl%:Show, vc_OSDmpic
				}
				Else
				{
				  GuiControl,%GuiID_VolumeControl%:Hide, vc_OSDmpic
				}
			}

			; Position berechnen
			vc_posY  := A_ScreenHeight - (A_ScreenHeight / 4) - 105
			vc_posX  := A_ScreenWidth - (A_ScreenWidth / 2) - 102

			vc_Device_tmp := RegExReplace(vc_Device%vc_OSDHotkey%,"^.*\( *(.*) *\)","$1")
			vc_ComponentName_tmp := vc_ComponentName%vc_OSDHotkey%

			If (vc_Device_tmp <> vc_Device_lasttmp OR vc_ComponentName_tmp <> vc_ComponentName_lasttmp)
			{
				GuiControl, %GuiID_VolumeControl%:,vc_GuiDeviceInfo, % vc_ComponentName_tmp "`n" vc_Device_tmp
				GuiControl, %GuiID_VolumeControl%:,vc_GuiDeviceInfo2, % vc_ComponentName_tmp "`n" vc_Device_tmp
				GuiControl, %GuiID_VolumeControl%:,vc_GuiDeviceInfo3, % vc_ComponentName_tmp "`n" vc_Device_tmp
				GuiControl, %GuiID_VolumeControl%:,vc_GuiDeviceInfo4, % vc_ComponentName_tmp "`n" vc_Device_tmp
				GuiControl, %GuiID_VolumeControl%:,vc_GuiDeviceInfo5, % vc_ComponentName_tmp "`n" vc_Device_tmp
				GuiControl, %GuiID_VolumeControl%:,vc_GuiDeviceInfo6, % vc_ComponentName_tmp "`n" vc_Device_tmp
				GuiControl, %GuiID_VolumeControl%:,vc_GuiDeviceInfo7, % vc_ComponentName_tmp "`n" vc_Device_tmp
				GuiControl, %GuiID_VolumeControl%:,vc_GuiDeviceInfo8, % vc_ComponentName_tmp "`n" vc_Device_tmp
				GuiControl, %GuiID_VolumeControl%:,vc_GuiDeviceInfo9, % vc_ComponentName_tmp "`n" vc_Device_tmp
			}
			vc_ComponentName_lasttmp := vc_ComponentName_tmp
			vc_Device_lasttmp := vc_Device_tmp

			If NOT func_isFullScreen()
				Gui, %GuiID_VolumeControl%:Show, w205 h205 y%vc_posY% x%vc_posX% NA            ; Symbol darstellen

			Loop, 20
			{
				If (A_Index < vc_Master%vc_OSDHotkey%)
				{
					If vc_VolumeG%A_Index% <> 1
						GuiControl, %GuiID_VolumeControl%:Show, vc_Volume%A_Index%
					vc_VolumeG%A_Index% = 1
				}
				Else
				{
					If vc_VolumeG%A_Index% <> 0
						GuiControl, %GuiID_VolumeControl%:Hide, vc_Volume%A_Index%
					vc_VolumeG%A_Index% = 0
				}
			}

			vc_transparent = 150 ; Anfangstransparenz
			WinSet, TransColor,0000FF %vc_transparent%, ahk_id %vc_OSDid%
		}

		If (vc_EnableSound%vc_OSDHotkey% = 1 AND GetKeyState(vc_TempDisableSound%vc_OSDHotkey%) <> 1 AND vc_Master%vc_OSDHotkey% <> vc_LastMaster%vc_OSDHotkey%)
		{
			SoundPlay,%A_ScriptDir%\extensions\Media\ac'tivAid_VolumeControl_vol.wav
		}

		vc_LastMaster%vc_OSDHotkey% := vc_Master%vc_OSDHotkey%
		vc_LastMute%vc_OSDHotkey%   := vc_Mute%vc_OSDHotkey%
		vc_ForceOSD%vc_OSDHotkey%   := 0

		break
	}
	If vc_Return = 1
		Return

	Critical, Off
	Settimer, vc_tim_FadeOSD, 1500
	vc_StartTicks = %A_TickCount%
Return

vc_tim_FadeOSD:
	Settimer, vc_tim_FadeOSD, 5
	vc_Ticks := (A_TickCount-1500-vc_StartTicks) / 500
	vc_transparent := vc_transparent - vc_FadeSpeed * vc_Ticks   ; Transparenz runterzählen

	if vc_transparent < 1
	{
		Settimer, vc_tim_FadeOSD, Off
		Gui, %GuiID_VolumeControl%:Hide
		Return
	}
	WinSet, TransColor,0000FF %vc_transparent%, ahk_id %vc_OSDid%  ; Transparenz setzen
Return
