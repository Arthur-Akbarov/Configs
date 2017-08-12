; VolumeControl + MusicPlayerControl ersetzen MusicControl
; --------------------------------------------------------------------------------------------------

IniRead, Enable_MusicControl, %ConfigFile%, activAid, Enable_MusicControl

If Enable_MusicControl = 1
{
	IniWrite,1, %ConfigFile%, activAid, Enable_MusicPlayerControl
	IniWrite,1, %ConfigFile%, activAid, EnableTray_MusicPlayerControl
	IniWrite,1, %ConfigFile%, activAid, Enable_VolumeControl
	IniWrite,1, %ConfigFile%, activAid, EnableTray_VolumeControl
}

If Enable_MusicControl <> ERROR
{
	func_RemoveExtension("MusicControl")
	func_AddExtension("MusicPlayerControl")
	func_AddExtension("VolumeControl")
}

IniDelete, %ConfigFile%, activAid, Enable_MusicControl
IniDelete, %ConfigFile%, activAid, EnableTray_MusicControl

IniRead, LastUpdateNumber, %ConfigFile%, MusicPlayerControl, UpdateNumber, 0

If LastUpdateNumber < 1
{
	; Update von MusciControl zu MusicPlayerControl
	mpc_oldMCparameters := "Prev Next Pause Rwd FFwd Up Down Stop Play"

	loop, parse, mpc_oldMCparameters, %A_Space%
		{
		IniRead, mpc_old_Component, %ConfigFile%, MusicControl, %A_LoopField%, DEFAULT
		if (mpc_old_Component!="DEFAULT")
			IniWrite, %mpc_old_Component%, %ConfigFile%, MusicPlayerControl, %A_LoopField%
		IniDelete, %ConfigFile%, MusicControl, %A_LoopField%
	}

	mpc_oldMCparameters := "Winamp Itunes Foobar WMP MediaKeys"
	loop, parse, mpc_oldMCparameters, %A_Space%
	{
		IniRead, mpc_old_Component, %ConfigFile%, MusicControl, Disable%A_LoopField%, DEFAULT
		if (mpc_old_Component!="DEFAULT")
			mpc_old_Component := 1-mpc_old_Component
			IniWrite, %mpc_old_Component%, %ConfigFile%, MusicPlayerControl, Enable%A_LoopField%
		IniDelete, %ConfigFile%, MusicControl, Disable%A_LoopField%
	}
	IniDelete, %ConfigFile%, MusicControl, LaunchPlayer
}

IniWrite, 2, %ConfigFile%, MusicPlayerControl, UpdateNumber

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

IniRead, LastUpdateNumber, %ConfigFile%, VolumeControl, UpdateNumber, 0

If LastUpdateNumber < 1
{
	IniDelete,%ConfigFile%, WinAmp

	IniRead, vc_old_Component, %ConfigFile%, MusicControl, NoMasterVolume, 0
	If vc_old_Component = 1
		IniWrite, WAVE, %ConfigFile%, %vc_ScriptName%, Component
	IniDelete, %ConfigFile%, MusicControl, NoMasterVolume

	; Update von MusciControl zu VolumeControl
	vc_oldMCparameters := "VolUp VolDown VolMute VolUp2 VolDown2 VolMute2 OSD Sound TempDisableSoundKey Device Component VolumeIncrement CheckCompatibility"
	loop, parse, vc_oldMCparameters, %A_Space%
	{
		IniRead, vc_old_Component, %ConfigFile%, MusicControl, %A_LoopField%, DEFAULT
		if (vc_old_Component!="DEFAULT")
			IniWrite, %vc_old_Component%, %ConfigFile%, VolumeControl, %A_LoopField%
		IniDelete, %ConfigFile%, MusicControl, %A_LoopField%
	}

	IniRead, mpc_old_Component, %ConfigFile%, MusicControl, Prev

	IniDelete, %ConfigFile%, MusicControl

	FileDelete, %A_ScriptDir%\extensions\Media\ac'tivAid_MusicControl_vol2.gif
	FileDelete, %A_ScriptDir%\extensions\Media\ac'tivAid_MusicControl_vol.wav
	FileDelete, %A_ScriptDir%\extensions\Media\ac'tivAid_MusicControl_vol.gif
	FileDelete, %A_ScriptDir%\extensions\Media\ac'tivAid_MusicControl_mute.gif
}

IfExist, %A_ScriptDir%\extensions\ac'tivAid_MusicControl.ahk
	FileDelete, %A_ScriptDir%\extensions\ac'tivAid_MusicControl.ahk

IniWrite, 2, %ConfigFile%, VolumeControl, UpdateNumber

; T9Keys -> TypeWith9Keys
; --------------------------------------------------------------------------------------------------

IniRead, LastUpdateNumber, %ConfigFile%, TypeWith9Keys, UpdateNumber, 0

If LastUpdateNumber < 1
{
	func_ReplaceExtension( "T9Keys", "TypeWith9Keys" )
	FileDelete, %A_ScriptDir%\Library\T9Keys-Dict.db
}

IniWrite, 1, %ConfigFile%, TypeWith9Keys, UpdateNumber


; LeoToolTip
; --------------------------------------------------------------------------------------------------

FileDelete, %A_ScriptDir%\extensions\ac'tivAid_LeoToolTip2.ahk
