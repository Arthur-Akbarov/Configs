; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               MusicPlayerControl
; -----------------------------------------------------------------------------
; Prefix:             mpc_
; Version:            0.3
; Date:               2008-08-13
; Author:             Michael Telgkamp, Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
;
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_MusicPlayerControl:
	Prefix = mpc
	%Prefix%_ScriptName    = MusicPlayerControl
	%Prefix%_ScriptVersion = 0.3
	%Prefix%_Author        = Wolfgang Reszel, Michael Telgkamp
	IconFile_On_MusicPlayerControl = %A_WinDir%\system32\shell32.dll
	IconPos_On_MusicPlayerControl = 41


	If Lng = 07
	{
		MenuName                   = %mpc_ScriptName% - Tastaturkürzel für Medien-Player
		Description                = Bietet Tastaturkürzel für Medien-Player
		lng_mpc_Prev               = Vorheriges Lied
		lng_mpc_Next               = Nächstes Lied
		lng_mpc_Pause              = Pause/Abspielen
		lng_mpc_Rwd                = Zurückspulen
		lng_mpc_FFwd               = Vorspulen
		lng_mpc_Shuffle            = Zufall
		lng_mpc_Repeat             = Wiederholen
		lng_mpc_Up                 = Lauter
		lng_mpc_Down               = Leiser
		lng_mpc_Stop               = Stopp
		lng_mpc_StopClose          = Stopp+Schließen
		lng_mpc_Play               = Abspielen
		lng_mpc_StartPlay          = Starten+Abspielen
		lng_mpc_Player             = Abspielprogramme
		lng_mpc_MediaKeys          = Medientasten
		lng_mpc_Controls           = allgemeine Kontrollen
		lng_mpc_specialControls    = spezielle Kontrollen
		lng_mpc_noSupportedPlayer  = kein unterstützes Programm gefunden
		lng_mpc_pathNotFound       = Folgende Pfade wurden nicht gefunden.`nBitte Pfad in ac'tivAid.ini eintragen oder Checkbox deaktivieren.
		lng_mpc_ShowOSD            = Grafische Anzeige (OSD)
		lng_mpc_Show               = Player anzeigen
	}
	else
	{
		MenuName                   = %mpc_ScriptName% - controlling media players
		Description                = Provides hotkeys for conrolling media players
		lng_mpc_Prev               = Previous song
		lng_mpc_Next               = Next song
		lng_mpc_Pause              = Pause/Play
		lng_mpc_Rwd                = Backwards
		lng_mpc_FFwd               = Fast forward
		lng_mpc_Shuffle            = Shuffle
		lng_mpc_Repeat             = Repeat
		lng_mpc_Up                 = Volume up
		lng_mpc_Down               = Volume down
		lng_mpc_Stop               = Stop
		lng_mpc_StopClose          = Stop+Close
		lng_mpc_Play               = Play
		lng_mpc_StartPlay          = Start+Play
		lng_mpc_Player             = Player
		lng_mpc_MediaKeys          = Media keys
		lng_mpc_Controls           = general Controls
		lng_mpc_specialControls    = special Controls
		lng_mpc_noSupportedPlayer  = no supported player found
		lng_mpc_pathNotFound       = Paths of these program(s) where not found.`nPlease add Path to ac'tivAid.ini or deactivate Checkbox.
		lng_mpc_ShowOSD            = Visual feedback (OSD)
		lng_mpc_Show               = Show player
	}


	func_HotkeyRead( "mpc_Play",      ConfigFile, mpc_ScriptName, "Play",      "mpc_Play",     "#Home" )
	func_HotkeyRead( "mpc_StartPlay", ConfigFile, mpc_ScriptName, "StartPlay", "mpc_StartPlay","#!Home" )
	func_HotkeyRead( "mpc_Stop",      ConfigFile, mpc_ScriptName, "Stop",      "mpc_Stop",     "#End" )
	func_HotkeyRead( "mpc_StopClose", ConfigFile, mpc_ScriptName, "StopClose", "mpc_StopClose","#!End" )

	func_HotkeyRead( "mpc_Prev",      ConfigFile, mpc_ScriptName, "Prev",      "mpc_Prev",     "#Left" )
	func_HotkeyRead( "mpc_Next",      ConfigFile, mpc_ScriptName, "Next",      "mpc_Next",     "#Right" )
	func_HotkeyRead( "mpc_Pause",     ConfigFile, mpc_ScriptName, "Pause",     "mpc_Pause",    "#Delete" )
	func_HotkeyRead( "mpc_Rwd",       ConfigFile, mpc_ScriptName, "Rwd",       "mpc_Rwd",      "#+Left" )
	func_HotkeyRead( "mpc_FFwd",      ConfigFile, mpc_ScriptName, "FFwd",      "mpc_FFwd",     "#+Right" )
	func_HotkeyRead( "mpc_Shuffle",   ConfigFile, mpc_ScriptName, "Shuffle",   "mpc_Shuffle",  "" )
	func_HotkeyRead( "mpc_Repeat",    ConfigFile, mpc_ScriptName, "Repeat",    "mpc_Repeat",   "" )
	func_HotkeyRead( "mpc_Up",        ConfigFile, mpc_ScriptName, "Up",        "mpc_Up",       "#+Up" )
	func_HotkeyRead( "mpc_Down",      ConfigFile, mpc_ScriptName, "Down",      "mpc_Down",     "#+Down" )
	func_HotkeyRead( "mpc_Show",      ConfigFile, mpc_ScriptName, "Show",      "mpc_Show",     "" )

	IniRead, mpc_UseWaveVolume, %ConfigFile%, %mpc_ScriptName%, UseWaveVolume, 0

	IniRead, mpc_EnableWinamp, %ConfigFile%, %mpc_ScriptName%, EnableWinamp, 0
	IniRead, mpc_EnableiTunes, %ConfigFile%, %mpc_ScriptName%, EnableiTunes, 0
	IniRead, mpc_EnableFoobar, %ConfigFile%, %mpc_ScriptName%, EnableFoobar, 0
	IniRead, mpc_EnableWMP,    %ConfigFile%, %mpc_ScriptName%, EnableWMP,    0
	RegisterAdditionalSetting( "mpc", "ShowOSD", 0 )

	IniRead, mpc_WinampPath,   %ConfigFile%, %mpc_ScriptName%, WinampPath, %A_Space%
	IniRead, mpc_iTunesPath,   %ConfigFile%, %mpc_ScriptName%, iTunesPath, %A_Space%
	IniRead, mpc_foobarPath,   %ConfigFile%, %mpc_ScriptName%, foobarPath, %A_Space%
	IniRead, mpc_WMPPath,      %ConfigFile%, %mpc_ScriptName%, WMPPath, %A_Space%

	mpc_enableOSD := 0
	if (mpc_showOSD = 1 && gdiP_enabled = 1)
		mpc_enableOSD := 1

	if (mpc_EnableWinamp = 1 and !FileExist(mpc_WinampPath))
	{
		RegRead, mpc_WinampPath, HKEY_CURRENT_USER,Software\Winamp
		mpc_WinampPath := mpc_WinampPath "\winamp.exe"
		if (!FileExist(mpc_WinampPath))
		{
			mpc_BalloonTipText := mpc_BalloonTipText "`nWinampPath"
			mpc_WinampPath =
		}
	}

	if (mpc_EnableiTunes = 1 and !FileExist(mpc_iTunesPath))
	{
		RegRead, mpc_iTunesPath, HKEY_LOCAL_MACHINE, SOFTWARE\Clients\Media\iTunes\shell\open\command
		if (!FileExist(mpc_iTunesPath))
		{
			mpc_BalloonTipText := mpc_BalloonTipText "`niTunesPath"
			mpc_iTunesPath =
		}
	}

	if(mpc_EnableFoobar = 1 and !FileExist(mpc_foobarPath))
	{
		RegRead, mpc_foobarPath, HKEY_LOCAL_MACHINE, SOFTWARE\foobar2000, InstallDir
		If mpc_foobarPath =
		{
			RegRead, mpc_foobarPath, HKEY_CURRENT_USER, SOFTWARE\foobar2000, InstallDir
		}
		mpc_foobarPath := mpc_foobarPath "\foobar2000.exe"
		if (!FileExist(mpc_foobarPath))
		{
			mpc_BalloonTipText := mpc_BalloonTipText "`nfoobarPath"
			mpc_foobarPath =
		}
	}

	if (mpc_EnableWMP = 1 and !FileExist(mpc_WMPPath))
	{
		RegRead, mpc_WMPPath, HKEY_LOCAL_MACHINE, SOFTWARE\Clients\Media\Windows Media Player\shell\open\command
		if (!FileExist(mpc_WMPPath))
		{
			mpc_BalloonTipText := mpc_BalloonTipText "`nWMPPath"
			mpc_WMPPath =
		}
	}

	if(mpc_BalloonTipText)
		InfoScreen(mpc_ScriptName,lng_mpc_pathNotFound " " mpc_BalloonTipText)

	IniRead, mpc_EnableMediaKeys, %ConfigFile%, %mpc_ScriptName%, EnableMediaKeys, 1


	mpc_FoobarClasses = ahk_class {97E27FAA-C0B3-4b8e-A693-ED7881E99FC1},ahk_class {E7076D1C-A7BF-4f39-B771-BCBE88F2A2A8}
Return

SettingsGui_MusicPlayerControl:
	Gui, Add, GroupBox, xs+10 yp+7 w550 h36, %lng_mpc_Player%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged vmpc_EnableWinamp xs+20 yp+17 Checked%mpc_EnableWinamp%, Winamp
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged vmpc_EnableiTunes x+10 Checked%mpc_EnableiTunes%, iTunes
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged vmpc_EnableFoobar x+10 Checked%mpc_EnableFoobar%, Foobar
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged vmpc_EnableWMP x+10 Checked%mpc_EnableWMP%, Windows Mediaplayer
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged vmpc_EnableMediaKeys x+10 Checked%mpc_EnableMediaKeys%, %lng_mpc_MediaKeys%

	Gui, Add, GroupBox, xs+10 y+7 w550 h100, %lng_mpc_Controls%
	func_HotkeyAddGuiControl( lng_mpc_Play, "mpc_Play", "xs+20 yp+16 w90 -Wrap", "", "w165")
	func_HotkeyAddGuiControl( lng_mpc_StartPlay, "mpc_StartPlay", "x+10  yp+3 w90 -Wrap", "", "w165")
	func_HotkeyAddGuiControl( lng_mpc_Stop, "mpc_Stop", "xs+20 yp+23 w90 -Wrap", "", "w165")
	func_HotkeyAddGuiControl( lng_mpc_StopClose, "mpc_StopClose", "x+10  yp+3 w90 -Wrap", "", "w165")
	func_HotkeyAddGuiControl( lng_mpc_Pause, "mpc_Pause", "xs+20 yp+23 w90 -Wrap", "", "w165")
	func_HotkeyAddGuiControl( lng_mpc_Show, "mpc_Show", "x+10  yp+3 w90 -Wrap", "", "w165")
	func_HotkeyAddGuiControl( lng_mpc_Prev, "mpc_Prev", "xs+20 yp+23 w90 -Wrap", "", "w165")
	func_HotkeyAddGuiControl( lng_mpc_Next, "mpc_Next", "x+10  yp+3 w90 -Wrap", "", "w165")

	Gui, Add, GroupBox, xs+10 y+7 w395 h137, %lng_mpc_specialControls%
	func_HotkeyAddGuiControl( lng_mpc_Rwd,     "mpc_Rwd",     "xs+20 yp+16 w90","","w200" )
	func_HotkeyAddGuiControl( lng_mpc_FFwd,    "mpc_FFwd",    "xs+20 y+2 w90","","w200" )
	func_HotkeyAddGuiControl( lng_mpc_Shuffle, "mpc_Shuffle", "xs+20 y+2 w90","","w200" )
	func_HotkeyAddGuiControl( lng_mpc_Repeat,  "mpc_Repeat",  "xs+20 y+2 w90","","w200" )
	func_HotkeyAddGuiControl( lng_mpc_Up,      "mpc_Up",      "xs+20 y+2 w90","","w200" )
	func_HotkeyAddGuiControl( lng_mpc_Down,    "mpc_Down",    "xs+20 y+2 w90","","w200" )

	Gui, Font, S%FontSize6% Bold, Symbol
	Gui, Add, Text, x+5 yp-16, ù
	Gosub, GuiDefaultFont
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged vmpc_UseWaveVolume y+0 Checked%mpc_UseWaveVolume%, WAVE/MIDI
	Gui, Font, S%FontSize7% Bold, Symbol
	Gui, Add, Text, y+0, û
	Gosub, GuiDefaultFont
Return

SaveSettings_MusicPlayerControl:
	func_HotkeyWrite( "mpc_Prev", ConfigFile, mpc_ScriptName, "Prev")
	func_HotkeyWrite( "mpc_Next", ConfigFile, mpc_ScriptName, "Next")
	func_HotkeyWrite( "mpc_Pause", ConfigFile, mpc_ScriptName, "Pause")
	func_HotkeyWrite( "mpc_Rwd", ConfigFile, mpc_ScriptName, "Rwd")
	func_HotkeyWrite( "mpc_FFwd", ConfigFile, mpc_ScriptName, "FFwd")
	func_HotkeyWrite( "mpc_Shuffle", ConfigFile, mpc_ScriptName, "Shuffle")
	func_HotkeyWrite( "mpc_Repeat", ConfigFile, mpc_ScriptName, "Repeat")
	func_HotkeyWrite( "mpc_Up", ConfigFile, mpc_ScriptName, "Up")
	func_HotkeyWrite( "mpc_Down", ConfigFile, mpc_ScriptName, "Down")
	func_HotkeyWrite( "mpc_Stop", ConfigFile, mpc_ScriptName, "Stop")
	func_HotkeyWrite( "mpc_StopClose", ConfigFile, mpc_ScriptName, "StopClose")
	func_HotkeyWrite( "mpc_Play", ConfigFile, mpc_ScriptName, "Play")
	func_HotkeyWrite( "mpc_StartPlay", ConfigFile, mpc_ScriptName, "StartPlay")
	func_HotkeyWrite( "mpc_Show", ConfigFile, mpc_ScriptName, "Show")
	IniWrite, %mpc_UseWaveVolume%, %ConfigFile%, %mpc_ScriptName%, UseWaveVolume

	IniWrite, %mpc_EnableWinamp%,    %ConfigFile%, %mpc_ScriptName%, EnableWinamp
	IniWrite, %mpc_EnableiTunes%,    %ConfigFile%, %mpc_ScriptName%, EnableiTunes
	IniWrite, %mpc_EnableFoobar%,    %ConfigFile%, %mpc_ScriptName%, EnableFoobar
	IniWrite, %mpc_EnableWMP%,       %ConfigFile%, %mpc_ScriptName%, EnableWMP
	IniWrite, %mpc_EnableMediaKeys%, %ConfigFile%, %mpc_ScriptName%, EnableMediaKeys

	IniWrite, %mpc_WinampPath%,    %ConfigFile%, %mpc_ScriptName%, WinampPath
	IniWrite, %mpc_iTunesPath%,    %ConfigFile%, %mpc_ScriptName%, iTunesPath
	IniWrite, %mpc_foobarPath%,    %ConfigFile%, %mpc_ScriptName%, foobarPath
	IniWrite, %mpc_WMPPath%,       %ConfigFile%, %mpc_ScriptName%, WMPPath
Return

CancelSettings_MusicPlayerControl:
Return

DoEnable_MusicPlayerControl:
	registerAction("mpc_Prev")
	registerAction("mpc_Next")
	registerAction("mpc_Pause")
	registerAction("mpc_Rwd")
	registerAction("mpc_FFwd")
	registerAction("mpc_Shuffle")
	registerAction("mpc_Repeat")
	registerAction("mpc_Up")
	registerAction("mpc_Down")
	registerAction("mpc_Stop")
	registerAction("mpc_StopClose")
	registerAction("mpc_Play")
	registerAction("mpc_StartPlay")
	registerAction("mpc_Show")

	func_HotkeyEnable( "mpc_Prev" )
	func_HotkeyEnable( "mpc_Next" )
	func_HotkeyEnable( "mpc_Pause" )
	func_HotkeyEnable( "mpc_Rwd" )
	func_HotkeyEnable( "mpc_FFwd" )
	func_HotkeyEnable( "mpc_Shuffle" )
	func_HotkeyEnable( "mpc_Repeat" )
	func_HotkeyEnable( "mpc_Up" )
	func_HotkeyEnable( "mpc_Down" )
	func_HotkeyEnable( "mpc_Stop" )
	func_HotkeyEnable( "mpc_StopClose" )
	func_HotkeyEnable( "mpc_Play" )
	func_HotkeyEnable( "mpc_StartPlay" )
	func_HotkeyEnable( "mpc_Show" )

	if mpc_enableOSD = 1
	{
		if osd_media_ID =
			osd_media_ID := osd_create()
	}
Return

DoDisable_MusicPlayerControl:
	unRegisterAction("mpc_Prev")
	unRegisterAction("mpc_Next")
	unRegisterAction("mpc_Pause")
	unRegisterAction("mpc_Rwd")
	unRegisterAction("mpc_FFwd")
	unRegisterAction("mpc_Shuffle")
	unRegisterAction("mpc_Repeat")
	unRegisterAction("mpc_Up")
	unRegisterAction("mpc_Down")
	unRegisterAction("mpc_Stop")
	unRegisterAction("mpc_StopClose")
	unRegisterAction("mpc_Play")
	unRegisterAction("mpc_StartPlay")
	unRegisterAction("mpc_Show")

	func_HotkeyDisable( "mpc_Prev" )
	func_HotkeyDisable( "mpc_Next" )
	func_HotkeyDisable( "mpc_Pause" )
	func_HotkeyDisable( "mpc_Rwd" )
	func_HotkeyDisable( "mpc_FFwd" )
	func_HotkeyDisable( "mpc_Shuffle" )
	func_HotkeyDisable( "mpc_Repeat" )
	func_HotkeyDisable( "mpc_Up" )
	func_HotkeyDisable( "mpc_Down" )
	func_HotkeyDisable( "mpc_Stop" )
	func_HotkeyDisable( "mpc_StopClose" )
	func_HotkeyDisable( "mpc_Play" )
	func_HotkeyDisable( "mpc_StartPlay" )
	func_HotkeyDisable( "mpc_Show" )
Return

DefaultSettings_MusicPlayerControl:
Return

OnExitAndReload_MusicPlayerControl:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------
mpc_showOSD(type)
{
	Global
	local text

	if mpc_enableOSD = 1
	{
		text := lng_mpc_%type%

		osd_prepare(osd_media_ID,185,185,-1,-1,1,235,gdip_bgColor,gdip_rounding,1)
		osd_borderText(osd_media_ID,text,"R0 Cff" gdip_fontColorHeader " S" gdip_fontSizeHeader " Center","R0 Caa" gdip_fontColorHeaderBorder " S" gdip_fontSizeHeader " Center",10,10,gdip_fontFamilyHeader,165)
		osd_pictureNoResize(osd_media_ID,A_ScriptDir "\extensions\Media\ac'tivAid_MusicPlayerControl_" type ".png",60,63)
		osd_show(osd_media_ID)
		osd_fade(osd_media_ID)
	}
}

mpc_Prev:                        ; Vorheriger Titel
	Detecthiddenwindows,On
	mpc_UsedPlayers := 0
	if (mpc_EnableWinamp and WinExist("ahk_class Winamp v1.x"))
		mpc_UsedPlayers := func_mpc_send_winamp("40044")
	if (mpc_EnableiTunes and !mpc_UsedPlayers and WinExist("ahk_class iTunes"))
	{
		mpc_UsedPlayers := func_mpc_send_iTunes("11")
		mpc_UsedPlayers := func_mpc_send_iTunes("14")
	}
	if (mpc_EnableFoobar and !mpc_UsedPlayers)
		mpc_UsedPlayers := func_mpc_send_foobar("prev")
	if (mpc_EnableWMP and !mpc_UsedPlayers)
		mpc_UsedPlayers := func_mpc_send_WMP("18810")
	if (mpc_EnableMediaKeys and !mpc_UsedPlayers)
		Send, {Media_Prev}

	mpc_showOSD("Prev")
return

mpc_Next:                       ; Nächster Titel
	Detecthiddenwindows,On
	mpc_UsedPlayers := 0
	If (mpc_EnableWinamp and WinExist("ahk_class Winamp v1.x"))
	{
		mpc_UsedPlayers := func_mpc_send_winamp("40048")
	}
	If (mpc_EnableiTunes and !mpc_UsedPlayers and WinExist("ahk_class iTunes"))
	{
		mpc_UsedPlayers := func_mpc_send_iTunes("11")
		mpc_UsedPlayers := func_mpc_send_iTunes("9")
	}
	If (mpc_EnableFoobar and !mpc_UsedPlayers)
		mpc_UsedPlayers := func_mpc_send_foobar("next")
	If (mpc_EnableWMP and !mpc_UsedPlayers)
		mpc_UsedPlayers := func_mpc_send_WMP("18811")
	If (mpc_EnableMediaKeys and !mpc_UsedPlayers)
		Send, {Media_Next}

	mpc_showOSD("Next")
return

mpc_Pause:
	Detecthiddenwindows,On
	mpc_UsedPlayers := 0
	If (mpc_EnableWinamp and WinExist("ahk_class Winamp v1.x"))
	{
		  SendMessage, 0x400,0,104,,ahk_class Winamp v1.x
		  if errorlevel = 0
		  {
				mpc_UsedPlayers := func_mpc_send_winamp("40045")
		  }
		  else
		  {
				mpc_UsedPlayers := func_mpc_send_winamp("40046")
		  }
	}
	If (mpc_EnableiTunes and !mpc_UsedPlayers and WinExist("ahk_class iTunes"))
		mpc_UsedPlayers := func_mpc_send_iTunes("13")
	If (mpc_EnableFoobar and !mpc_UsedPlayers)
		mpc_UsedPlayers := func_mpc_send_foobar("playpause")
	If (mpc_EnableWMP and !mpc_UsedPlayers)
		mpc_UsedPlayers := func_mpc_send_WMP("18808")
	If (mpc_EnableMediaKeys and !mpc_UsedPlayers)
		Send, {Media_Play_Pause}

	mpc_showOSD("Pause")
return

mpc_Rwd:                     ; Zurückspulen
	Detecthiddenwindows,On
	mpc_UsedPlayers := 0
	If (mpc_EnableWinamp)
		mpc_UsedPlayers := func_mpc_send_winamp("40144")
	If (mpc_EnableiTunes and !mpc_UsedPlayers and WinExist("ahk_class iTunes"))
	{
		CoInitialize()

		mpc_CLSID_iTunesApp := "{DC0C2640-1415-4644-875C-6F4D769839BA}"
		mpc_IID_IiTunes     := "{9DD6680B-3EDC-40DB-A771-E6FE4832E34A}"

		mpc_piT := CreateObject( mpc_CLSID_iTunesApp, mpc_IID_IiTunes )

		DllCall( VTable( mpc_piT, 40 ), "Uint", mpc_piT, "UintP", mpc_PlayerPos )   ; get_PlayerPosition
		mpc_PlayerPos := mpc_PlayerPos - 7
		DllCall( VTable( mpc_piT, 41 ), "Uint", mpc_piT, "Uint", mpc_PlayerPos )    ; set_PlayerPosition

		Release( mpc_piT )

		CoUninitialize()
	}
	If (mpc_EnableFoobar and !mpc_UsedPlayers)
		mpc_UsedPlayers := func_mpc_send_foobar("Command:""Seek back by 10 seconds""")
	If (mpc_EnableWMP and !mpc_UsedPlayers)
		mpc_UsedPlayers := func_mpc_send_WMP("18812")

	mpc_showOSD("Rwd")
return

mpc_FFwd:                     ; Vorspulen
	Detecthiddenwindows,On
	mpc_UsedPlayers := 0
	If (mpc_EnableWinamp)
		mpc_UsedPlayers := func_mpc_send_winamp("40148")
	If (mpc_EnableiTunes and !mpc_UsedPlayers and WinExist("ahk_class iTunes"))
	{
		CoInitialize()

		mpc_CLSID_iTunesApp := "{DC0C2640-1415-4644-875C-6F4D769839BA}"
		mpc_IID_IiTunes     := "{9DD6680B-3EDC-40DB-A771-E6FE4832E34A}"

		mpc_piT := CreateObject( mpc_CLSID_iTunesApp, mpc_IID_IiTunes )

		DllCall( VTable( mpc_piT, 40 ), "Uint", mpc_piT, "UintP", mpc_PlayerPos )   ; get_PlayerPosition
		mpc_PlayerPos := mpc_PlayerPos + 7
		DllCall( VTable( mpc_piT, 41 ), "Uint", mpc_piT, "Uint", mpc_PlayerPos )    ; set_PlayerPosition

		Release( mpc_piT )

		CoUninitialize()
	}
	If (mpc_EnableFoobar and !mpc_UsedPlayers)
		mpc_UsedPlayers := func_mpc_send_foobar("Command:""Seek ahead by 10 seconds""")

	If (mpc_EnableWMP and !mpc_UsedPlayers)
		mpc_UsedPlayers := func_mpc_send_WMP("18813")

	mpc_showOSD("FFwd")
return

mpc_Shuffle:
	Detecthiddenwindows,On
	mpc_UsedPlayers := 0
	If (mpc_EnableWinamp and WinExist("ahk_class Winamp v1.x"))
		mpc_UsedPlayers := func_mpc_send_winamp("40023")
;   If (mpc_EnableiTunes and !mpc_UsedPlayers and WinExist("ahk_class iTunes"))
;      mpc_UsedPlayers := func_mpc_send_iTunes("notKnownYet")
;   If (mpc_EnableFoobar and !mpc_UsedPlayers)
;      mpc_UsedPlayers := func_mpc_send_foobar("notKnownYet")
	If (mpc_EnableWMP and !mpc_UsedPlayers)
		mpc_UsedPlayers := func_mpc_send_WMP("18842")
	If (!mpc_UsedPlayers)
		BalloonTip(mpc_ScriptName,lng_mpc_Shuffle " " lng_mpc_noSupportedPlayer)
return

mpc_Repeat:
	Detecthiddenwindows,On
	mpc_UsedPlayers := 0
	If (mpc_EnableWinamp and WinExist("ahk_class Winamp v1.x"))
		mpc_UsedPlayers := func_mpc_send_winamp("40022")
;   If (mpc_EnableiTunes and !mpc_UsedPlayers and WinExist("ahk_class iTunes"))
;      mpc_UsedPlayers := func_mpc_send_iTunes("notKnownYet")
;   If (mpc_EnableFoobar and !mpc_UsedPlayers)
;      mpc_UsedPlayers := func_mpc_send_foobar("notKnownYet")
	If (mpc_EnableWMP and !mpc_UsedPlayers)
		mpc_UsedPlayers := func_mpc_send_WMP("18843")
	If (!mpc_UsedPlayers)
		BalloonTip(mpc_ScriptName,lng_mpc_Shuffle " " lng_mpc_noSupportedPlayer)
return

mpc_Up:
	Detecthiddenwindows,On
	mpc_UsedPlayers := 0
	If mpc_UseWaveVolume = 1
	{
		SoundSet, 0, WAVE, mute, %mpc_Device%
		SoundSet, +5, WAVE, , %mpc_Device%       ; Wave-Lautstärke Lauter
		SoundSet, +5, SYNTH, , %mpc_Device%      ; Midi-Lautstärke Lauter
		Return
	}
	If (mpc_EnableWinamp and WinExist("ahk_class Winamp v1.x"))
	{
		Loop, 5
			mpc_UsedPlayers := func_mpc_send_winamp("40058")
	}
	If (mpc_EnableiTunes and !mpc_UsedPlayers and WinExist("ahk_class iTunes"))
	{
		CoInitialize()

		mpc_CLSID_iTunesApp := "{DC0C2640-1415-4644-875C-6F4D769839BA}"
		mpc_IID_IiTunes     := "{9DD6680B-3EDC-40DB-A771-E6FE4832E34A}"

		mpc_piT := CreateObject( mpc_CLSID_iTunesApp, mpc_IID_IiTunes )

		DllCall( VTable( mpc_piT, 35 ), "Uint", mpc_piT, "UintP", mpc_PlayerVol )   ; get_SoundVolume
		mpc_PlayerVol := mpc_PlayerVol + 5
		DllCall( VTable( mpc_piT, 36 ), "Uint", mpc_piT, "Uint", mpc_PlayerVol )    ; set_SoundVolume

		Release( mpc_piT )

		CoUninitialize()
		mpc_UsedPlayers := 1
	}
	If (mpc_EnableFoobar and !mpc_UsedPlayers)
		mpc_UsedPlayers := func_mpc_send_foobar("Command:""Volume up""")
	If (mpc_EnableWMP and !mpc_UsedPlayers)
		mpc_UsedPlayers := func_mpc_send_WMP("18815")
	If (mpc_EnableMediaKeys and !mpc_UsedPlayers)
		Send, {Volume_Up}
return

mpc_Down:
	Detecthiddenwindows,On
	mpc_UsedPlayers := 0
	If mpc_UseWaveVolume = 1
	{
		SoundSet, 0, WAVE, mute, %mpc_Device%
		SoundSet, -5, WAVE, , %mpc_Device%       ; Wave-Lautstärke Leiser
		SoundSet, -5, SYNTH, , %mpc_Device%      ; Midi-Lautstärke Leiser
		Return
	}
	If (mpc_EnableWinamp and WinExist("ahk_class Winamp v1.x"))
	{
		Loop, 5
			mpc_UsedPlayers := func_mpc_send_winamp("40059")
	}
	If (mpc_EnableiTunes and !mpc_UsedPlayers and WinExist("ahk_class iTunes"))
	{
		CoInitialize()

		mpc_CLSID_iTunesApp := "{DC0C2640-1415-4644-875C-6F4D769839BA}"
		mpc_IID_IiTunes     := "{9DD6680B-3EDC-40DB-A771-E6FE4832E34A}"

		mpc_piT := CreateObject( mpc_CLSID_iTunesApp, mpc_IID_IiTunes )

		DllCall( VTable( mpc_piT, 35 ), "Uint", mpc_piT, "UintP", mpc_PlayerVol )   ; get_SoundVolume
		mpc_PlayerVol := mpc_PlayerVol - 5
		DllCall( VTable( mpc_piT, 36 ), "Uint", mpc_piT, "Uint", mpc_PlayerVol )    ; set_SoundVolume

		Release( mpc_piT )

		CoUninitialize()
		mpc_UsedPlayers++
	}
	If (mpc_EnableFoobar and !mpc_UsedPlayers)
		mpc_UsedPlayers := func_mpc_send_foobar("Command:""Volume down""")
	If (mpc_EnableWMP and !mpc_UsedPlayers)
		mpc_UsedPlayers := func_mpc_send_WMP("18816")
	If (mpc_EnableMediaKeys and !mpc_UsedPlayers)
		Send, {Volume_Down}
return

mpc_StopClose:
	GoSub,mpc_Stop
	mpc_ClosedPlayers := 0
	If (mpc_EnableWinamp = 1 and mpc_UsedPlayers and WinExist("ahk_class Winamp v1.x"))
	{
		WinClose, ahk_class Winamp v1.x
		mpc_ClosedPlayers = 1
	}
	If (mpc_EnableiTunes and mpc_UsedPlayers and WinExist("ahk_class iTunes"))
	{
		WinClose, ahk_class iTunes
		mpc_ClosedPlayers = 1
	}
	If (mpc_EnableFoobar and mpc_UsedPlayers)
		mpc_ClosedPlayers := func_mpc_send_foobar("exit")
	If (mpc_EnableWMP and !mpc_UsedPlayers)
	{
		if (WinExist("ahk_class WMPlayerApp"))
			WinClose, ahk_class WMPlayerApp
		else if (WinExist("ahk_class WMP Skin Host"))
			WinClose, ahk_class WMP Skin Host
		mpc_ClosedPlayers = 1
	}
	if (!mpc_ClosedPlayers)
		BalloonTip(mpc_ScriptName,lng_mpc_StopClose " " lng_mpc_noSupportedPlayer)

;   mpc_showOSD("Stop") ; wird hier nicht benötigt, da es schon oben von "GoSub,mpc_Stop" aufgerufen wurde
return

mpc_Stop:                     ; Stop
	Detecthiddenwindows,On
	mpc_UsedPlayers := 0
	If (mpc_EnableWinamp = 1 and WinExist("ahk_class Winamp v1.x"))
		mpc_UsedPlayers := func_mpc_send_winamp("40047")
	If (mpc_EnableiTunes and !mpc_UsedPlayers and WinExist("ahk_class iTunes"))
		mpc_UsedPlayers := func_mpc_send_iTunes("17")
	If (mpc_EnableFoobar and !mpc_UsedPlayers)
		mpc_UsedPlayers := func_mpc_send_foobar("stop")
	If (mpc_EnableWMP and !mpc_UsedPlayers)
		mpc_UsedPlayers := func_mpc_send_WMP("18809")
	If (mpc_EnableMediaKeys and !mpc_UsedPlayers)
		Send, {Media_Stop}

	mpc_showOSD("Stop")
return

mpc_StartPlay:

	mpc_LaunchPlayer = 1
	GoSub,mpc_Play
	mpc_LaunchPlayer =

;   mpc_showOSD("Play") ; wird hier nicht benötigt, da es schon von GoSub,mpcPlay aufgerufen wurde
return

mpc_Play:                     ; Play
	Detecthiddenwindows,On
	mpc_UsedPlayers := 0
	If (mpc_EnableWinamp)
	{
		IfWinNotExist, ahk_class Winamp v1.x
		{
			If (FileExist(mpc_WinampPath) and mpc_LaunchPlayer = 1)
			{
				Run, %mpc_WinampPath%
				WinWait, ahk_class Winamp v1.x
			}
		}
		IfWinExist, ahk_class Winamp v1.x
		{
			If (!WinActive("ahk_class Winamp v1.x") and mpc_LaunchPlayer = 1)
				WinActivate, ahk_class Winamp v1.x
			mpc_UsedPlayers := func_mpc_send_winamp("40045")
		}
	}
	If (mpc_EnableiTunes and !mpc_UsedPlayers)
	{
		IfWinNotExist, ahk_class iTunes
		{
			If (FileExist(mpc_iTunesPath) and mpc_LaunchPlayer = 1)
			{
				Run, %mpc_iTunesPath%,,UseErrorLevel
				If (ErrorLevel <> "ERROR")
					WinWait, ahk_class iTunes
			}
		}
		IfWinExist, ahk_class iTunes
		{
			If (!WinActive("ahk_class iTunes") and mpc_LaunchPlayer = 1)
				WinActivate, ahk_class iTunes
			mpc_UsedPlayers := func_mpc_send_iTunes("11")
		}
	}
	If (mpc_EnableFoobar and !mpc_UsedPlayers and FileExist(mpc_foobarPath))
	{
		mpc_UsedPlayers := func_mpc_send_foobar("play")

		if(!mpc_UsedPlayers and mpc_LaunchPlayer = 1)
		{
			Run, %mpc_foobarPath% /play,,UseErrorLevel
			If (ErrorLevel <> "ERROR")
				mpc_UsedPlayers := 1
		}
	}
	If (mpc_EnableWMP and !mpc_UsedPlayers and FileExist(mpc_WMPPath))
	{
		If (!WinExist("ahk_class WMPlayerApp") and !WinExist("ahk_class WMP Skin Host") and mpc_LaunchPlayer = 1)
		{
			Run, %mpc_WMPPath%,,UseErrorLevel
			If (ErrorLevel <> "ERROR")
				WinWait, ahk_class WMPlayerApp
		}
		If (!WinActive("ahk_class WMPlayerApp") and mpc_LaunchPlayer = 1)
			WinActivate, ahk_class WMPlayerApp
		If (!WinActive("ahk_class WMP Skin Host") and mpc_LaunchPlayer = 1)
			WinActivate, ahk_class WMP SkinHost
		mpc_UsedPlayers := func_mpc_send_WMP("18808")
	}
	If (mpc_EnableMediaKeys and !mpc_UsedPlayers)
	{
		If mpc_LaunchPlayer = 1
			Send, {Launch_Media}
		Send, {Media_Play_Pause}
	}

	mpc_showOSD("Play")
return

mpc_Show:
	Detecthiddenwindows,On
	mpc_UsedPlayers := 0
	If (mpc_EnableWinamp AND WinExist("ahk_class Winamp v1.x"))
	{
		WinActivate, ahk_class Winamp v1.x
		mpc_UsedPlayers := 1
	}
	If (mpc_EnableiTunes and !mpc_UsedPlayers AND WinExist("ahk_class iTunes"))
	{
		WinShow, ahk_class iTunes
		mpc_UsedPlayers := 1
	}
	If (mpc_EnableFoobar and !mpc_UsedPlayers)
	{
		mpc_UsedPlayers := func_mpc_send_foobar("show")
	}
	If (mpc_EnableWMP and !mpc_UsedPlayers)
	{
		WinShow, ahk_class WMPlayerApp
		mpc_UsedPlayers := 1
	}
return

; -----------------------------------------------------------------------------
; === Functions ===============================================================
; -----------------------------------------------------------------------------

func_mpc_send_winamp(command)
{
	PostMessage, 0x111, %command%,,,ahk_class Winamp v1.x
	return true
}

func_mpc_send_iTunes(command)
{
	CoInitialize()
	muc_CLSID_iTunesApp := "{DC0C2640-1415-4644-875C-6F4D769839BA}"
	muc_IID_IiTunes     := "{9DD6680B-3EDC-40DB-A771-E6FE4832E34A}"
	muc_piT := CreateObject( muc_CLSID_iTunesApp, muc_IID_IiTunes )
	DllCall( VTable( muc_piT, command ), "Uint", muc_piT )    ; Play
	Release( muc_piT )
	CoUninitialize()
	return true
}

func_mpc_send_foobar(command)
{
	global mpc_FoobarClasses, mpc_foobarPath
	if (!FileExist(mpc_foobarPath))
		return false
	command := mpc_foobarPath " /" command
	Loop, Parse, mpc_FoobarClasses, `,
	{
		IfWinExist, %A_LoopField%
		{
			Run, %command% ,,UseErrorLevel
			If (ErrorLevel <> "ERROR")
				return true
		}
	}
	return false
}
func_mpc_send_WMP(command)
{
	if (WinExist("ahk_class WMPlayerApp"))
		PostMessage, 0x111, %command%,,,ahk_class WMPlayerApp
	else if (WinExist("ahk_class WMP Skin Host"))
		PostMessage, 0x111, %command%,,,ahk_class WMP Skin Host   }
	else
		return false
	return true
}
