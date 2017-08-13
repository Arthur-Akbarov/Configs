; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               VolumeSwitcher
; -----------------------------------------------------------------------------
; Prefix:             vs_
; Version:            0.4
; Date:               2008-05-23
; Author:             Jossekin Beilharz, Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; Schaltet die Lautstärke zwischen zwei Werten um. Es stehen dabei zwei
; unabhängige Kürzel zur Verfügung.

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------
#Include %A_ScriptDir%\Library\VA.ahk

init_VolumeSwitcher:
	Prefix = vs
	%Prefix%_ScriptName    = VolumeSwitcher
	%Prefix%_ScriptVersion = 0.4
	%Prefix%_Author        = Jossekin Beilharz, Wolfgang Reszel

	CustomHotkey_VolumeSwitcher =  1

	IconFile_On_VolumeSwitcher = %A_WinDir%\system32\shell32.dll
	IconPos_On_VolumeSwitcher = 169

	CreateGuiID("VolumeSwitcher")

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                       = %vs_ScriptName% - Wechselt die Lautstärke
		Description                    = Schaltet die Lautstärke zwischen zwei Werten um
		lng_vs_Swop                    = Lautstärke umschalten
		lng_vs_Vol                     = Lautstärke ###
		lng_vs_NoMasterVol             = Gerät und Regler:
		lng_vs_ResetVolumeOnStart      = Lautstärke beim Start von act'ivAid auf "Lautstärke 1" zurücksetzen
	}
	else        ; = other languages (english)
	{
		MenuName                       = %vs_ScriptName% - Switches the volume
		Description                    = Switches the volume between two values
		lng_vs_Swop                    = Switch volume
		lng_vs_Vol                     = Volume ###
		lng_vs_NoMasterVol             = Device and component:
		lng_vs_ResetVolumeOnStart      = Reset volume to "Volume 1" when ac'tivAid is launched
	}

	HideSettings = 0

	IniRead, vs_Vol1, %ConfigFile%, %vs_ScriptName%, Volume1, 30
	IniRead, vs_Vol2, %ConfigFile%, %vs_ScriptName%, Volume2, 10
	IniRead, vs_ResetVolumeOnStart1 , %ConfigFile%, %vs_ScriptName%, ResetVolumeOnStart1, 0
	IniRead, vs_ResetVolumeOnStart2 , %ConfigFile%, %vs_ScriptName%, ResetVolumeOnStart2, 0
	IniRead, vs_UseVol2, %ConfigFile%, %vs_ScriptName%, UseVolume2, 1
	IniRead, vs_Device, %ConfigFile%, %vs_ScriptName%, Device, 1
	If A_OSVersion = WIN_VISTA
		IniRead, vs_Component, %ConfigFile%, %vs_ScriptName%, Component, 1
	Else
		IniRead, vs_Component, %ConfigFile%, %vs_ScriptName%, Component, MASTER
	IniRead, vs_Vol3, %ConfigFile%, %vs_ScriptName%, Volume3, 30
	IniRead, vs_Vol4, %ConfigFile%, %vs_ScriptName%, Volume4, 10
	IniRead, vs_UseVol4, %ConfigFile%, %vs_ScriptName%, UseVolume4, 1
	IniRead, vs_Device2, %ConfigFile%, %vs_ScriptName%, Device2, 1
	If A_OSVersion = WIN_VISTA
		IniRead, vs_Component2, %ConfigFile%, %vs_ScriptName%, Component2, 1
	Else
		IniRead, vs_Component2, %ConfigFile%, %vs_ScriptName%, Component2, MASTER
	func_HotkeyRead( "vs_VolumeSwitcher2", ConfigFile, vs_ScriptName, "VolumeKey2","vs_sub_VolumeSwitcher2",   "", "$" )

	If LastExitReason =
	{
		If vs_ResetVolumeOnStart1 = 1
		{
			If A_OSVersion = WIN_VISTA
			{
				VA_SetMute(0,vs_Component-1,vs_Device)
				VA_SetVolume(vs_Vol1,vs_Component-1,"",vs_Device)
			}
			Else
			{
				SoundSet, 0, %vs_Component%, Mute, %vs_Device%
				SoundSet, %vs_Vol1%, %vs_Component%, , %vs_Device%
			}
		}
		If vs_ResetVolumeOnStart2 = 1
		{
			If A_OSVersion = WIN_VISTA
			{
				VA_SetMute(0,vs_Component2-1,vs_Device)
				VA_SetVolume(vs_Vol3,vs_Component2-1,"",vs_Device2)
			}
			Else
			{
				SoundSet, 0, %vs_Component2%, Mute, %vs_Device2%
				SoundSet, %vs_Vol3%, %vs_Component2%, , %vs_Device2%
			}
		}
	}
Return


SettingsGui_VolumeSwitcher:
	vs_Devices =
	If A_OSVersion = WIN_VISTA
	{
		vs_Devices := "|" VA_GetDeviceName(VA_GetDevice())
		Loop
		{
			vs_Temp := VA_GetDevice("playback:" A_Index)
			If vs_Temp = 0
			{
				COM_Release(vs_Temp)
				break
			}
			vs_TempName := VA_GetDeviceName(vs_Temp)
			If (vs_TempName = VA_GetDeviceName(VA_GetDevice()))
				continue
			vs_Devices = %vs_Devices%|%vs_TempName%
			COM_Release(vs_Temp)
		}
		If vs_Device = 1
			vs_Device := VA_GetDeviceName(VA_GetDevice())
		If vs_Device2 = 1
			vs_Device2 := VA_GetDeviceName(VA_GetDevice())
	}
	Else
	{
		Loop
		{
			SoundGet, vs_Temp,,, %A_Index%
			If ErrorLevel = Can't Open Specified Mixer
				break

			vs_Devices = %vs_Devices%|%A_Index%
		}
	}
	StringTrimLeft, vs_Devices, vs_Devices, 1

	Gui, Add, Text, xs+10 y+10 w80,  % #(lng_vs_Vol,"1") ":"
	Gui, Add, Slider, gsub_CheckIfSettingsChanged x+0 yp-5 vvs_Vol1 w190 TickInterval10 ToolTip, %vs_Vol1%
	Gui, Add, CheckBox, -Wrap gvs_sub_CheckIfSettingsChanged vvs_UseVol2 Checked%vs_UseVol2% x+10 yp-0 w80, % #(lng_vs_Vol,"2") ":"
	Gui, Add, Slider, gsub_CheckIfSettingsChanged x+0 yp-0 vvs_Vol2 w190 TickInterval10 ToolTip, %vs_Vol2%

	Gui, Add, CheckBox, xs+10 y+10 -Wrap gvs_sub_CheckIfSettingsChanged vvs_ResetVolumeOnStart1 Checked%vs_ResetVolumeOnStart1%, %lng_vs_ResetVolumeOnStart%

	Gui, Add, Text, xs+10 y+15, %lng_vs_NoMasterVol%
	If A_OSVersion = WIN_VISTA
		Gui, Add, DropDownList, -Wrap gvs_sub_CheckIfSettingsChanged vvs_Device x+10 yp-4 w290, %vs_Devices%
	Else
		Gui, Add, DropDownList, -Wrap gvs_sub_CheckIfSettingsChanged vvs_Device x+10 yp-4 w40, %vs_Devices%
	GuiControl, ChooseString, vs_Device, %vs_Device%

	If A_OSVersion = WIN_VISTA
		Gui, Add, DropDownList, -Wrap AltSubmit gvs_sub_CheckIfSettingsChanged vvs_Component x+10 w150, %vs_Component%
	Else
		Gui, Add, DropDownList, -Wrap gvs_sub_CheckIfSettingsChanged vvs_Component x+10 w110, %vs_Component%



	Gui, Add, Text, w545 h2 xs+10 y+20 +0x1000

	func_HotkeyAddGuiControl( lng_Hotkey " 2", "vs_VolumeSwitcher2", "xs+10 Y+20")
	Gui, Add, Text, xs+10 y+10 w80,  % #(lng_vs_Vol,"1") ":"
	Gui, Add, Slider, gsub_CheckIfSettingsChanged x+0 yp-5 vvs_Vol3 w190 TickInterval10 ToolTip, %vs_Vol3%
	Gui, Add, CheckBox, -Wrap gvs_sub_CheckIfSettingsChanged vvs_UseVol4 Checked%vs_UseVol4% x+10 yp+0 w80, % #(lng_vs_Vol,"2") ":"
	Gui, Add, Slider, gsub_CheckIfSettingsChanged x+0 yp-0 vvs_Vol4 w190 TickInterval10 ToolTip, %vs_Vol4%

	Gui, Add, CheckBox, xs+10 y+10 -Wrap gvs_sub_CheckIfSettingsChanged vvs_ResetVolumeOnStart2 Checked%vs_ResetVolumeOnStart2%, %lng_vs_ResetVolumeOnStart%

	Gui, Add, Text, xs+10 y+15, %lng_vs_NoMasterVol%
	If A_OSVersion = WIN_VISTA
		Gui, Add, DropDownList, -Wrap gvs_sub_CheckIfSettingsChanged vvs_Device2 x+10 yp-4 w290, %vs_Devices%
	Else
		Gui, Add, DropDownList, -Wrap gvs_sub_CheckIfSettingsChanged vvs_Device2 x+10 yp-4 w40, %vs_Devices%
	GuiControl, ChooseString, vs_Device2, %vs_Device2%

	If A_OSVersion = WIN_VISTA
		Gui, Add, DropDownList, -Wrap AltSubmit gvs_sub_CheckIfSettingsChanged vvs_Component2 x+10 w150, %vs_Component2%
	Else
		Gui, Add, DropDownList, -Wrap gvs_sub_CheckIfSettingsChanged vvs_Component2 x+10 w110, %vs_Component2%

	vs_Device_old =
	vs_Device2_old =
	Gosub, vs_sub_CheckIfSettingsChanged
Return

SaveSettings_VolumeSwitcher:
	IniWrite, %vs_Vol1%, %ConfigFile%, %vs_ScriptName%, Volume1
	IniWrite, %vs_Vol2%, %ConfigFile%, %vs_ScriptName%, Volume2
	IniWrite, %vs_ResetVolumeOnStart1%, %ConfigFile%, %vs_ScriptName%, ResetVolumeOnStart1
	IniWrite, %vs_ResetVolumeOnStart2%, %ConfigFile%, %vs_ScriptName%, ResetVolumeOnStart2
	IniWrite, %vs_UseVol2%, %ConfigFile%, %vs_ScriptName%, UseVolume2
	IniWrite, %vs_Device%, %ConfigFile%, %vs_ScriptName%, Device
	IniWrite, %vs_Component%, %ConfigFile%, %vs_ScriptName%, Component
	IniWrite, %vs_Vol3%, %ConfigFile%, %vs_ScriptName%, Volume3
	IniWrite, %vs_Vol4%, %ConfigFile%, %vs_ScriptName%, Volume4
	IniWrite, %vs_UseVol4%, %ConfigFile%, %vs_ScriptName%, UseVolume4
	IniWrite, %vs_Device2%, %ConfigFile%, %vs_ScriptName%, Device2
	IniWrite, %vs_Component2%, %ConfigFile%, %vs_ScriptName%, Component2
	func_HotkeyWrite("vs_VolumeSwitcher2", ConfigFile, vs_ScriptName, "VolumeKey2")
	vs_Device_old = %vs_Device%
	vs_Device2_old = %vs_Device2%
Return

vs_sub_CheckIfSettingsChanged:
	Gosub, sub_CheckIfSettingsChanged

	GuiControlGet, vs_Device_tmp,, vs_Device
	If vs_Device_tmp <> %vs_Device_old%
	{
		If A_OSVersion = WIN_VISTA
		{
			vs_pIPart := VA_GetSpeakersIPart(vs_Device_tmp)
			vs_Components := "MASTER|" VA_EnumerateSubParts_List(vs_pIPart)
			COM_Release(vs_pIPart)
			GuiControl,,vs_Component, |%vs_Components%
			GuiControl,Choose, vs_Component, %vs_Component%
		}
		Else
		{
		vs_TempComp = MASTER,HEADPHONES,DIGITAL,LINE,MICROPHONE,SYNTH,CD,TELEPHONE,PCSPEAKER,WAVE,AUX,ANALOG,HEADPHONES,N/A
			vs_Components =
			Loop, Parse, vs_TempComp, `,
			{
				SoundGet, vs_Tmp, %A_LoopField%,, %vs_Device_tmp%
				if ErrorLevel = Mixer Doesn't Support This Component Type
					continue
				vs_Components = %vs_Components%|%A_LoopField%
			}
			StringTrimLeft, vs_Components, vs_Components, 1
			GuiControl,,vs_Component, |%vs_Components%
			GuiControl,ChooseString, vs_Component, %vs_Component%
			GuiControlGet, vs_Component_tmp,, vs_Component
			If vs_Component_tmp =
				GuiControl,Choose, vs_Component, 1
		}
	}
	vs_Device_old = %vs_Device_tmp%

	GuiControlGet, vs_Device2_tmp,, vs_Device2
	If vs_Device2_tmp <> %vs_Device2_old%
	{
		IF A_OSVersion = WIN_VISTA
		{
			vs_pIPart := VA_GetSpeakersIPart(vs_Device2_tmp)
			vs_Components := "MASTER|" VA_EnumerateSubParts_List(vs_pIPart)
			COM_Release(vs_pIPart)
			GuiControl,,vs_Component2, |%vs_Components%
			GuiControl,Choose, vs_Component2, %vs_Component2%
			GuiControlGet, vs_Component2_tmp,, vs_Component2
			If vs_Component2_tmp =
				GuiControl,Choose, vs_Component2, 1
		}
		Else
		{
			vs_TempComp = MASTER,HEADPHONES,DIGITAL,LINE,MICROPHONE,SYNTH,CD,TELEPHONE,PCSPEAKER,WAVE,AUX,ANALOG,HEADPHONES,N/A
			vs_Components =
			Loop, Parse, vs_TempComp, `,
			{
				SoundGet, vs_Tmp, %A_LoopField%,, %vs_Device2_tmp%
				if ErrorLevel = Mixer Doesn't Support This Component Type
					continue
				vs_Components = %vs_Components%|%A_LoopField%
			}
			StringTrimLeft, vs_Components, vs_Components, 1
			GuiControl,,vs_Component2, |%vs_Components%
			GuiControl,ChooseString, vs_Component2, %vs_Component2%
		}
	}
	vs_Device2_old = %vs_Device2_tmp%

	GuiControlGet, vs_UseVol2_tmp,, vs_UseVol2
	If vs_UseVol2_tmp = 1
		GuiControl,Enable,vs_Vol2
	Else
		GuiControl,Disable,vs_Vol2
	GuiControlGet, vs_UseVol4_tmp,, vs_UseVol4
	If vs_UseVol4_tmp = 1
		GuiControl,Enable,vs_Vol4
	Else
		GuiControl,Disable,vs_Vol4
Return


CancelSettings_VolumeSwitcher:
Return

DoEnable_VolumeSwitcher:
	func_HotkeyEnable( "vs_VolumeSwitcher2" )
	If A_OSVersion = WIN_VISTA
		COM_Init()
Return

DoDisable_VolumeSwitcher:
	func_HotkeyDisable( "vs_VolumeSwitcher2" )
	If A_OSVersion = WIN_VISTA
		COM_Term()
Return

DefaultSettings_VolumeSwitcher:
Return

Update_VolumeSwitcher:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------
sub_Hotkey_VolumeSwitcher:
	If A_OSVersion = WIN_VISTA
	{
	  vs_CurrVol := VA_GetVolume(vs_Component-1,"",vs_Device)
	  vs_AvVol := (vs_Vol2 + vs_Vol1)/2
	  If ((vs_AvVol < vs_CurrVol AND vs_Vol2 < vs_Vol1)                        ;CurrVol ist eher
			OR (vs_AvVol > vs_CurrVol AND vs_Vol2 > vs_Vol1) AND vs_UseVol2 = 1) ;bei Vol1
	  {
		 VA_SetMute(0,vs_Component-1,vs_Device)
		 VA_SetVolume(vs_Vol2,vs_Component-1,"",vs_Device)
	  }
	  Else
	  {
		 VA_SetMute(0,vs_Component-1,vs_Device)
		 VA_SetVolume(vs_Vol1,vs_Component-1,"",vs_Device)
	  }
	}
	Else
	{
	  SoundGet, vs_CurrVol, %vs_Component%, , %vs_Device%
	  vs_AvVol := (vs_Vol2 + vs_Vol1)/2
	  If ((vs_AvVol < vs_CurrVol AND vs_Vol2 < vs_Vol1)                        ;CurrVol ist eher
			OR (vs_AvVol > vs_CurrVol AND vs_Vol2 > vs_Vol1) AND vs_UseVol2 = 1) ;bei Vol1
	  {
		 SoundSet, 0, %vs_Component%, Mute, %vs_Device%
		 SoundSet, %vs_Vol2%, %vs_Component%, , %vs_Device%
	  }
	  Else
	  {
		 SoundSet, 0, %vs_Component%, Mute, %vs_Device%
		 SoundSet, %vs_Vol1%, %vs_Component%, , %vs_Device%
	  }
	}
Return

vs_sub_VolumeSwitcher2:
	If A_OSVersion = WIN_VISTA
	{
	  vs_CurrVol := VA_GetVolume(vs_Component2-1,"",vs_Device2)
	  vs_AvVol := (vs_Vol4 + vs_Vol3)/2
	  If ((vs_AvVol < vs_CurrVol AND vs_Vol4 < vs_Vol3)                        ;CurrVol ist eher
			OR (vs_AvVol > vs_CurrVol AND vs_Vol4 > vs_Vol3) AND vs_UseVol4 = 1) ;bei Vol3
	  {
		 VA_SetMute(0,vs_Component2-1,vs_Device2)
		 VA_SetVolume(vs_Vol4,vs_Component2-1,"",vs_Device2)
	  }
	  Else
	  {
		 VA_SetMute(0,vs_Component2-1,vs_Device2)
		 VA_SetVolume(vs_Vol3,vs_Component2-1,"",vs_Device2)
	  }
	}
	Else
	{
	  SoundGet, vs_CurrVol, %vs_Component2%, , %vs_Device2%
	  vs_AvVol := (vs_Vol4 + vs_Vol3)/2
	  If ((vs_AvVol < vs_CurrVol AND vs_Vol4 < vs_Vol3)                        ;CurrVol ist eher
			OR (vs_AvVol > vs_CurrVol AND vs_Vol4 > vs_Vol3) AND vs_UseVol4 = 1) ;bei Vol3
	  {
		 SoundSet, 0, %vs_Component2%, Mute, %vs_Device2%
		 SoundSet, %vs_Vol4%, %vs_Component2%, , %vs_Device2%
	  }
	  Else
	  {
		 SoundSet, 0, %vs_Component2%, Mute, %vs_Device2%
		 SoundSet, %vs_Vol3%, %vs_Component2%, , %vs_Device2%
	  }
	}
Return
