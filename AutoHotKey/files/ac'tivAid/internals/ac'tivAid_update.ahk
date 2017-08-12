; Updates durchführen
If (LastScriptVersion <> ScriptVersion OR activAid_LastDateTime <> activAid_CurrDateTime OR activAid_LastFolder <> A_ScriptDir)
{
	Update_activAid()
	Loop
	{
		actFunct := Extension[%A_Index%]
		If actFunct =
			Break

		If (IsLabel( "update_" actFunct ))
		{
			Debug("INIT", A_LineNumber, A_LineFile, "DoUpdate_" Function "...")
			Gosub, update_%actFunct%
		}
	}
	#Include *i %A_ScriptDir%\Library\update-scripts.ahk

	IniWrite, %Scriptversion%, %ConfigFile%, %ScriptName%, LastScriptVersion
	IniWrite, %activAid_CurrDateTime%, %ConfigFile%, %ScriptName%, activAid_DateTime
	IniWrite, %A_ScriptDir%, %ConfigFile%, %ScriptName%, LastFolder

	Debug("RELOAD",A_LineNumber,A_LineFile,"do Updates")
	LeaveAdmin =
	Gosub, Reload
}


Update_activAid()
{
	Global

	; Änderungen an der Verzeichnisstruktur durchführen
	If ( (aa_osversionnumber >= aa_osversionnumber_vista) AND AHKonUSB <> 1 AND AHKonlyPortable <> 1)
	{
		IniRead, tmp_AvailableExtensions, %activAidData%\settings\ac'tivAid.ini, activAid, AvailableExtensions
		IniRead, tmp_AvailableExtensions2, settings\ac'tivAid.ini, activAid, AvailableExtensions
		If (tmp_AvailableExtensions = "ERROR" AND tmp_AvailableExtensions2 <> "ERROR")
		{
			SetTimer, tim_Loading, Off
			SplashImage, 2:Off
			MsgBox, 32, %ScriptTitle%, %lng_NewSettingsDirForVista%
			FileCopyDir, %A_ScriptDir%\settings, %activAidData%\settings, 1
			IfNotExist, %A_ScriptDir%\settings\ac'tivAid.ini
				FileRemoveDir, %A_ScriptDir%\settings
		}
	}
	If (FileExist( A_ScriptDir "\Settings\ac'tivAid.ico" ) AND !FileExist( A_ScriptDir "\icons\internals\ac'tivAid.ico") )
		FileMove, %A_ScriptDir%\Settings\*.ico, %A_ScriptDir%\icons\internals, 1
	If (FileExist( A_ScriptDir "\Library\ac'tivAid.ico" ) AND !FileExist( A_ScriptDir "\icons\internals\ac'tivAid.ico") )
		FileMove, %A_ScriptDir%\Library\*.ico, %A_ScriptDir%\icons\internals, 1
	If activAidData <> %A_ScriptDir%
	{
		FileRead, tmp_Main, %activAidData%\settings\extensions_main.ini
		IfInString, tmp_Main, #Include *i extensions\
		{
			StringReplace, tmp_Main, tmp_Main, #Include *i extensions\ , #Include *i %A_ScriptDir%\extensions\, All
			FileDelete, %activAidData%\settings\extensions_main.ini
			FileAppend, %tmp_Main%, %activAidData%\settings\extensions_main.ini
		}
	}
	IfExist, WebResearch
	{
		FileCreateDir, WebSearch
		FileMove, WebResearch\*.*, WebSearch\, 1
		FileRemoveDir, WebResearch, 1
		IfExist, WebSearch\URLs.cfg
		{
			MsgBox, 36, %ScriptTitle%, %lng_wr_UpdateCFG%
			IfMsgBox,yes
			{
				FileMove, WebSearch\URLs.cfg, WebSearch\URLs.bak
			}
		}
	}
	IfExist, WebSearch
	{
		FileMoveDir, WebSearch, settings\WebSearch
		FileRemoveDir, WebSearch, 1
		IfExist, settings\WebSearch\URLs.cfg
		{
			MsgBox, 36, %ScriptTitle%, %lng_wr_UpdateCFG%
			IfMsgBox,yes
			{
				FileMove, settings\WebSearch\URLs.cfg, settings\WebSearch\URLs.bak
			}
		}
	}
	IfExist, Portable ac'tivAid.exe
		IfNotExist, Portable_ac'tivAid.exe
			FileMove, Portable ac'tivAid.exe, Portable_ac'tivAid.exe
		Else
			FileDelete, Portable ac'tivAid.exe

	IfExist, ac'tivAid.ini
		FileMove, ac'tivAid.ini, settings\ac'tivAid.ini, 1
	IfExist, includes
		FileRemoveDir, includes, 1
	IfExist, extensions\Hotstrings.ahk
		FileMove, extensions\Hotstrings.ahk, settings\Hotstrings.ini
	FileDelete, extensions\Hotstrings.ahk
	IfExist, extensions\Hotstrings.ini
		FileMove, extensions\Hotstrings.ini, settings\Hotstrings.ini
	FileDelete, extensions\Hotstrings.ini
	FileDelete, extensions\unelevated.ahk
	FileDelete, extensions\ac'tivAid_MinimizeToTrayHelper.ahk

	FileDelete, extensions\Media\ac'tivAid_ReadingRuler.wav

	IfExist, extensions\_main.ahk
	{
		FileMove, extensions\_main.ahk, settings\extensions_main.ini
		FileDelete, extensions\_main.ahk
	}
	IfExist, extensions\_header.ahk
	{
		FileMove, extensions\_header.ahk, settings\extensions_header.ini
		FileDelete, extensions\_header.ahk
	}

	FileMoveDir, UserSettings, ComputerSettings, R

	FileDelete, ac'tivAid_ct.ico
	FileDelete, ac'tivAid.ico
	FileDelete, ac'tivAid_off.ico
	FileDelete, ac'tivAid_on.ico
	FileDelete, settings/ac'tivAid_icons.dll
	FileDelete, %A_ScriptDir%\extensions\Vol.gif
	FileDelete, %A_ScriptDir%\extensions\Vol2.gif
	FileDelete, %A_ScriptDir%\extensions\Vol.wav
	FileDelete, %A_ScriptDir%\extensions\mute.gif
	FileDelete, %A_ScriptDir%\extensions\Eject.gif

	FileDelete, %A_ScriptDir%\extensions\simwin.ahk
	FileDelete, %A_ScriptDir%\extensions\ac'tivAid_Winamp.ahk
	FileDelete, %A_ScriptDir%\extensions\ac'tivAid_Winamp_Vol.gif
	FileDelete, %A_ScriptDir%\extensions\ac'tivAid_Winamp_Vol2.gif
	FileDelete, %A_ScriptDir%\extensions\ac'tivAid_Winamp_Vol.wav
	FileDelete, betatester.ini

	FileDelete, %A_ScriptDir%\extensions\ac'tivAid_KeyState.dll

	FileDelete, %A_ScriptDir%\development\unzip.exe

	FileDelete, settings\unzip.exe

	FileDelete, %A_ScriptDir%\extensions\*.wav
	FileDelete, %A_ScriptDir%\extensions\*.gif
	FileDelete, %A_ScriptDir%\extensions\*.icl

	IfExist, backup\ac'tivAid_main.exe
	{
		FileDelete, ac'tivAid.exe
		FileMove, backup\ac'tivAid_main.exe, backup\ac'tivAid.exe
	}

	FileMove, language.ini, settings\language.ini
	FileDelete, language.ini

	func_ReplaceExtension( "WindowShrinker", "ExplorerShrinker" )

	IfNotInString, ScriptVersion, alpha
		IniDelete, %ConfigFile%, %ScriptNameClean%, UpdateURL

	IniRead, Hotkey_TempSuspend, %ConfigFile%, activAid, Hotkey_TempSuspend
	If (Hotkey_TempSuspend <> "ERROR" AND Hotkey_TempSuspend <> "Numlock")
		IniWrite, %Hotkey_TempSuspend%, %ConfigFile%, activAid, Hotkey_TemporarySuspend

	IniDelete, %ConfigFile%, activAid, Hotkey_TempSuspend

	IniRead, statFirstLaunch, %ConfigFile%, Statistics, FirstLaunch_%A_Computername%, 0
	IniRead, statLastLaunched, %ConfigFile%, Statistics, LastLaunched_%A_Computername%, 0
	IniRead, statLaunchCount, %ConfigFile%, Statistics, LaunchCount_%A_Computername%, 0
	IniRead, statReloadCount, %ConfigFile%, Statistics, ReloadCount_%A_Computername%, 0
	IniRead, statUpdateCount, %ConfigFile%, Statistics, UpdateCount_%A_Computername%, 0
	IniRead, statExitCount, %ConfigFile%, Statistics, ExitCount_%A_Computername%, 0
	IniRead, statTotalTime, %ConfigFile%, Statistics, TotalTime_%A_Computername%, 0
	IniRead, statLongestSession, %ConfigFile%, Statistics, LongestSession_%A_Computername%, 0
	If statFirstLaunch <> ERROR
	{
		IniWrite, %statFirstLaunch%, %ConfigFile%, Statistics, FirstLaunch
		IniWrite, %statLastLaunched%, %ConfigFile%, Statistics, LastLaunched
		IniWrite, %statLaunchCount%, %ConfigFile%, Statistics, LaunchCount
		IniWrite, %statReloadCount%, %ConfigFile%, Statistics, ReloadCount
		IniWrite, %statUpdateCount%, %ConfigFile%, Statistics, UpdateCount
		IniWrite, %statExitCount%, %ConfigFile%, Statistics, ExitCount
		IniWrite, %statTotalTime%, %ConfigFile%, Statistics, TotalTime
		IniWrite, %statLongestSession%, %ConfigFile%, Statistics, LongestSession
		IniDelete, %ConfigFile%, Statistics, FirstLaunch_%A_Computername%
		IniDelete, %ConfigFile%, Statistics, LastLaunched_%A_Computername%
		IniDelete, %ConfigFile%, Statistics, LaunchCount_%A_Computername%
		IniDelete, %ConfigFile%, Statistics, ReloadCount_%A_Computername%
		IniDelete, %ConfigFile%, Statistics, UpdateCount_%A_Computername%
		IniDelete, %ConfigFile%, Statistics, ExitCount_%A_Computername%
		IniDelete, %ConfigFile%, Statistics, TotalTime_%A_Computername%
		IniDelete, %ConfigFile%, Statistics, LongestSession_%A_Computername%
	}

	FileRead, ExtHeader, settings\extensions_header.ini

	FileMove, %A_ScriptDir%\deveject.exe, %A_ScriptDir%\Library\Tools\, 1
	FileMove, %A_ScriptDir%\RemoveDrive.exe, %A_ScriptDir%\Library\Tools\, 1

	IfInString, ExtHeader, Extension[1]
		Return

	FileDelete, settings\_temp.tmp

	Loop, Read, settings\extensions_header.ini, settings\_temp.tmp
	{
		IfNotInString A_LoopReadLine, Extension[3]
		{
			FileAppend, %A_LoopReadLine%`n
		}
		Else
			FileAppend, Extension[1] = ComfortDrag`nExtension[2] = MouseClip`n%A_LoopReadLine%`n
	}
	FileMove, settings\_temp.tmp, settings\extensions_header.ini, 1
	FileDelete, settings\_temp.tmp


	FileRead, ExtMain, settings\extensions_main.ini

	IfInString, ExtMain, %A_ScriptDir%
		UsingUserDir = 1
	If (UsingUserDir <> 1 OR AHKonUSB = 1)
	{
		FileAppend, % "#Include *i extensions\ac'tivAid_ComfortDrag.ahk `; ComfortDrag`n", settings\extensions_main.ini
		FileAppend, % "#Include *i extensions\ac'tivAid_MouseClip.ahk `; MouseClip`n", settings\extensions_main.ini
	}
	Else
	{
		FileAppend, % "#Include *i " A_ScriptDir "\extensions\ac'tivAid_ComfortDrag.ahk `; ComfortDrag`n", settings\extensions_main.ini
		FileAppend, % "#Include *i " A_ScriptDir "\extensions\ac'tivAid_MouseClip.ahk `; MouseClip`n", settings\extensions_main.ini
	}
}
