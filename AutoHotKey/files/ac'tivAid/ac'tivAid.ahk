; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               ac'tivAid
; -----------------------------------------------------------------------------
; Version:            1.3.2 nighly
; Date:               2008-12
; Author:             Wolfgang Reszel / Michael
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; AutoHotkey Version: 1.0.47.06
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Global Settings =========================================================
; -----------------------------------------------------------------------------

#singleinstance force
InitTime = %A_TickCount%
A_Priority = A
Process, Priority,, %A_Priority%
#HotkeyInterval 500
SetTitlematchMode, 2
SetBatchLines, 500
SetControlDelay, 0
SetWinDelay, 0
SetKeyDelay,0
#NoTrayIcon
#ClipboardTimeout 4000
A_SendMode = Input
SendMode, %A_SendMode%
#InstallMousehook
#NoEnv
#MaxMem 512
Hotkey, $LButton, Off

#Include *i syntaxcheck.tmp

DetectHiddenWindows, On
WinGet, activAidRunning, List, %A_Scriptfullpath% - AutoHotkey v%A_Ahkversion%
If activAidRunning > 1
	ExitApp
DetectHiddenWindows, Off

Process, Exist
activAidPID := ErrorLevel
RunWorkingDir := A_WorkingDir

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

Menu, Tray, NoStandard
Menu, Tray, DeleteAll

#include %A_ScriptDir%\internals\ac'tivAid_version.ahk
#include %A_ScriptDir%\internals\ac'tivAid_vars.ahk

ScriptTitle        = %ScriptNameFull% v%ScriptVersion%
_ScriptName        = %ScriptName%

A_Args = "%1%" "%2%" "%3%" "%4%" "%5%" "%6%" "%7%" "%8%" "%9%"
A_YY := func_StrRight(A_YYYY,2)

SplitPath, A_ScriptDir, activAidFolderName,,,, Drive

EnvGet, A_LocalAppData, LOCALAPPDATA
IfExist, %A_LocalAppData%\VirtualStore\Program Files\%activAidFolderName%\_temp.tmp
	FileDelete, %A_LocalAppData%\VirtualStore\Program Files\%activAidFolderName%\_temp.tmp
IfExist, %A_LocalAppData%\VirtualStore\Program Files (x86)\%activAidFolderName%\_temp.tmp
	FileDelete, %A_LocalAppData%\VirtualStore\Program Files (x86)\%activAidFolderName%\_temp.tmp

IfNotExist, %A_Temp%
	FileCreateDir, %A_Temp%

FileAppend, write, %A_ScriptDir%\_temp.tmp
MainDirNotWriteable = %ErrorLevel%

If (FileExist( A_LocalAppData "\VirtualStore\Program Files\" activAidFolderName "\_temp.tmp" ) OR FileExist( A_LocalAppData "\VirtualStore\Program Files (x86)\" activAidFolderName "\_temp.tmp" ))
	MainDirNotWriteable = 2

FileDelete, %A_ScriptDir%\_temp.tmp

If A_IsCompiled = 1
	RegRead, A_RealOSVersion, HKEY_CURRENT_USER, Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %A_ScriptFullPath%
Else
	RegRead, A_RealOSVersion, HKEY_CURRENT_USER, Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %A_AhkPath%
If (A_RealOSVersion <> "" AND ErrorLevel = 0)
	A_RealOSVersion = WIN_VISTA
Else
	A_RealOSVersion = %A_OSVersion%

ThisProcess := DllCall("GetCurrentProcess")
if !DllCall("IsWow64Process", "uint", ThisProcess, "int*", IsWow64Process)
	IsWow64Process := false
A_OSWordSize := IsWow64Process ? "64" : "32"

SplitPath, A_AhkPath,,A_AutoHotkeyPath

SplitPath, A_AutoHotkeyPath,,,,, A_AutoHotkeyDrive
DriveGet, A_AutoHotkeyDriveType, Type, %A_AutoHotkeyDrive%

If ( InStr(A_AutoHotkeyPath, A_ScriptDir) )
{
	AHKonUSB = 1
	If A_AutoHotkeyDriveType <> Removable
		AHKonlyPortable = 1
}

; Entwicklermodus?
if (InStr(A_ScriptDir, "ac'tivAid_dev") )
	AHKonlyPortable = 1

If AHKonUSB = 1
	APPDATA = %A_ScriptDir%\ComputerSettings\%A_Computername%
Else
	APPDATA = %A_AppData%

If APPDATA =
	RegRead, APPDATA, HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders,AppData

If (GetKeyState("Ctrl") = 1 AND GetKeyState(".") = 1)
	ExitApp
If AHKonUSB = 1
{
	activAidData = %APPDATA%
	activAidGlobalData = %A_ScriptDir%
}
Else
{
	activAidData = %APPDATA%\ac'tivAid
	If (MainDirNotWriteable > 0)
		activAidGlobalData = %A_AppDataCommon%\ac'tivAid
	Else
		activAidGlobalData = %A_ScriptDir%
	If (aa_osversionnumber >= aa_osversionnumber_vista AND A_WorkingDir <> activAidGlobalData AND A_WorkingDir = A_ScriptDir )
	{
		IfNotExist, %activAidGlobalData%
			FileCreateDir, %activAidGlobalData%
		Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
		If A_IsCompiled = 1
			Run, %A_ScriptFullPath% %A_Args%, %activAidGlobalData%, UseErrorLevel ; Reload
		Else
			Run, %A_AhkPath% /r "%A_ScriptFullPath%" %A_Args%, %activAidGlobalData%, UseErrorLevel ; Reload
		ExitApp
	}
	;   If (aa_osversionnumber >= aa_osversionnumber_vista AND A_WorkingDir = activAidGlobalData )
	;      activAidData = %activAidGlobalData%
}

A_Args =
Loop, %0%
{
	IfInString, %A_Index%, LastWorkingDir:
	{
		StringReplace, LastWorkingDir, %A_Index%, LastWorkingDir:
		continue
	}
	IfInString, %A_Index%, %A_Space%
		A_Args := A_Args " """ %A_Index% """"
	Else
		A_Args := A_Args " " %A_Index%
}
If LastWorkingDir =
{
	NoLastWorkingDirParam = 1
	If (A_WorkingDir <> A_ScriptDir OR MainDirNotWriteable = 0)
		LastWorkingDir = %A_WorkingDir%
	Else If (FileExist(A_Appdatacommon "\ac'tivAid\" ConfigFile) AND AHKonUSB <> 1)
		LastWorkingDir = %A_Appdatacommon%\ac'tivAid
	Else
		LastWorkingDir = %A_WorkingDir%
}
A_Args = %A_Args% "LastWorkingDir:%LastWorkingDir%"

If 1 = LeaveAdmin
	LeaveAdmin = 1

; #1011
If (InStr(A_Args, "update ") AND LastWorkingDir <> A_WorkingDir)
	LeaveAdmin = 1

SettingsDir = Settings
ConfigFile = %SettingsDir%\%ScriptNameFull%.ini

#Include %A_ScriptDir%\internals\ac'tivAid_language.ahk

FileSetAttrib, -R, %ConfigFile%
IniWrite, 1, %ConfigFile%, %ScriptName%, IniIsWriteable
IniRead, main_IniIsWriteable, %ConfigFile%, %ScriptName%, IniIsWriteable, 0
If (main_IniIsWriteable = 1)
{
	IniDelete, %ConfigFile%, %ScriptName%, IniIsWriteable
	main_IniIsWriteable =
}
else
{
	IniRead, thisMultiUser, %activAidGlobalData%\%ConfigFile%, %ScriptName%, MultiUser, %A_Space%
	if(not thisMultiUser) {
		MsgBox, 52, %lng_iniNotWritableTitle%, % lng_iniNotWritableText A_ScriptDir "\" ConfigFile 
		IfMsgBox No
			ExitApp
	}
}


If A_IsAdmin = 1
{
	DetectHiddenWindows, On
	If A_IsCompiled = 1
		SendMessage, 0x1ccc, 1, 1,,%A_ScriptDir%\extensions\RunWithAdminRights.exe
	Else
		SendMessage, 0x1ccc, 1, 1,,%A_ScriptDir%\extensions\RunWithAdminRights.ahk - AutoHotkey v%A_Ahkversion%
	If ErrorLevel = 1
		tempAdminMode = 1
	DetectHiddenWindows, Off

	IfInString, A_Args, tempAdminMode
		tempAdminMode = 1
}

IniRead, _Devel, %ConfigFile%, %ScriptName%, Devel, 0
IniRead, _Debug, %ConfigFile%, %ScriptName%, Debug, 0
IniRead, _DebugLevel, %ConfigFile%, %ScriptName%, DebugLevel, 0
IniRead, _DebugToFile, %ConfigFile%, %ScriptName%, DebugToFile, %A_Space%

RegisterAdditionalSetting( "", "MessageBoxTips", 0 )
RegisterAdditionalSetting( "", "NoSoundBeepInSearch", 0 )
RegisterAdditionalSetting( "", "SilentUpdate", 0 )
RegisterAdditionalSetting( "", "AlternativeTrayMenu", 0 )
RegisterAdditionalSetting( "", "SingleClickTrayAction", 0 )
RegisterAdditionalSetting( "", "useTrayMenuIcons", 0, "ReloadOnChange:true" )
RegisterAdditionalSetting( "", "sub_gdip_configGui", 0, "Type:SubRoutine")
RegisterAdditionalSetting( "", "ecmEnabled", 0)
RegisterAdditionalSetting( "", "ShowIconsInOptionsListBox", 0, "" )

If A_IsCompiled <> 1
{
	RegisterAdditionalSetting("","")
	RegisterAdditionalSetting( "", "Debug", 0 )
	RegisterAdditionalSetting( "", "Devel", 0 )
}

IfExist, %A_ScriptDir%\Dbgview.exe
{
	_Debug = 1
	_DebugLevel = All
	IfWinNotExist, DebugView
	{
		Run, %A_ScriptDir%\DbgView.exe ,, Min UseErrorLevel
		If ErrorLevel <> ERROR
			WinWait, DebugView
	}
}

Debug("INIT", A_LineNumber, A_LineFile, "-----------------------------------------------------------------")
Debug("INIT", A_LineNumber, A_LineFile, "Initializing " ScriptTitle " - " A_ScriptFullPath)

If MainDirNotWriteable > 0
	DisabledIfNotAdmin = Disabled

IniRead, CustomWorkingDir, %A_ScriptDir%\Settings\ac'tivAid.ini, activAid, CustomWorkingDir, %A_Space%
IniRead, MultiUser, %activAidGlobalData%\%ConfigFile%, %ScriptName%, MultiUser, %A_Space%
Debug("VAR", A_LineNumber, A_LineFile, "MainDirNotWriteable,A_WorkingDir,A_ScriptDir,MultiUser")

If MultiUser > 0
	CustomWorkingDir = %A_WorkingDir%

If (CustomWorkingDir <> "" AND NoLastWorkingDirParam = 1)
{
	CustomWorkingDir := func_Deref(CustomWorkingDir)
	If (A_WorkingDir <> CustomWorkingDir AND FileExist(CustomWorkingDir))
	{
		LastWorkingDir = %CustomWorkingDir%
		NewWorkingDir = %CustomWorkingDir%
		A_Args = %A_Args% "LastWorkingDir:%NewWorkingDir%"
		Gosub, Reload
	}
}

If ((MultiUser = 1 AND A_WorkingDir = A_ScriptDir) OR (A_WorkingDir = A_ScriptDir AND MainDirNotWriteable > 0) OR (MultiUser = 1 AND A_WorkingDir = A_ScriptDir))
{
	MultiUser=2
	Gosub, sub_MultiUser
}


main_IsAdmin = %A_IsAdmin%

Debug("VAR", A_LineNumber, A_LineFile, "A_IsAdmin,A_UserName,MainDirNotWriteable")

IfNotExist, %activAidGlobalData%
	FileCreateDir, %activAidGlobalData%

If activAidGlobalData <> %A_ScriptDir%
{
	tmpRights := CMDret_RunReturn( "CACLS """ activAidGlobalData """")
	StringReplace, tmpRights, tmpRights, (CI),,All
	StringReplace, tmpRights, tmpRights, (OI),,All
	StringReplace, tmpRights, tmpRights, (IO),,All
	cmpString := "\" Ansi2Oem(LookupAccountSid("S-1-5-32-545")) ":C"
	IfNotInstring, tmpRights, %cmpString%
		func_SetFileAccessRights( activAidGlobalData, "S-1-5-32-545", "C" )
	tmpRights =
}

IfNotExist, %activAidGlobalData%\%SettingsDir%
	FileCreateDir, %activAidGlobalData%\%SettingsDir%

A_Quote = "
;" end of quote for syntax highliting

If (A_WorkingDir = activAidData)
	UsingUserDir = 1
Else
	UsingUserDir = 0

RegRead, SystemDPI, HKEY_CURRENT_USER,Control Panel\Desktop\WindowMetrics,AppliedDPI

If SystemDPI =
	SystemDPI = 96

If SystemDPI > 112 ; Nicht zu groß vergrößern, wegen platz
	SystemDPI = 112
	
FontSize := SystemDPI/96 * 8
FontSize5 := SystemDPI/96 * 5
FontSize6 := SystemDPI/96 * 6
FontSize7 := SystemDPI/96 * 7
FontSize9 := SystemDPI/96 * 9
FontSize12 := SystemDPI/96 * 12
FontSize14 := SystemDPI/96 * 14
FontSize20 := SystemDPI/96 * 20
FontSize25 := SystemDPI/96 * 25

UnpackSplashStyle := "b1 FS" FontSize9 " W400 CWeeeeee Y" A_ScreenHeight/2+20

If (FileExist("update.cmd") AND FileExist("ac'tivAid-updater.exe"))
{
	Debug("RELOAD",A_LineNumber,A_LineFile,"Launching ac'tivAid-updater.exe")
	Run, ac'tivAid-updater.exe
	Sleep, 100
	ExitApp
}

If ( A_WorkingDir <> A_ScriptDir OR MainDirNotWriteable = 0 )
{
	IfNotExist, %SettingsDir%
		FileCreateDir, %SettingsDir%
}

IfExist, extensions\_main.ahk
{
	FileCopy, extensions\_main.ahk, settings\extensions_main.ini
	FileDelete, extensions\_main.ahk
	Reload = 1
}
IfExist, extensions\_header.ahk
{
	FileCopy, extensions\_header.ahk, settings\extensions_header.ini
	FileDelete, extensions\_header.ahk
	Reload = 1
}

If Reload = 1
	Gosub, Reload

RegRead, RecentPath, HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders, Recent

#Include %A_ScriptDir%\internals\ac'tivAid_libraryInits.ahk

; -----------------------------------------------------------------------------
; Hier werden alle verwendeten Funktionen eingetragen. Mit diesem Array
; wird automatisch das Tray-Menü erzeugt.
; -----------------------------------------------------------------------------

; eigene Funktionen/Erweiterungen laden (includes)
IfExist, settings\extensions_header.ini
	Debug("INIT", A_LineNumber, A_LineFile, "#including extensions_header.ini ..." )
#Include *i settings\extensions_header.ini
; -----------------------------------------------------------------------------


IniRead, activAid_LastDateTime, %ConfigFile%, %ScriptName%, activAid_DateTime
FileGetTime, activAid_CurrDateTime, %A_ScriptFullPath%, C
If (A_IsCompiled = 1 AND activAid_CurrDateTime <> activAid_LastDateTime)
	activAid_HasChanged = 1

IfExist, exe-distribution.ahk
	Debug("INIT", A_LineNumber, A_LineFile, "#including exe-distribution.ahk ..." )
#Include *i exe-distribution.ahk

If A_IsCompiled = 1
{
	IfNotExist, icons\internals\ac'tivAid.ico
	{
		func_UnpackSplash("icons\internals\ac'tivAid.ico")
		FileInstall, icons\internals\ac'tivAid.ico, icons\internals\ac'tivAid.ico
	}

	If ExeDistribution <> 1
	{
		IfNotExist, settings\ac'tivAid.ini
		{
			func_UnpackSplash("settings\ac'tivAid.ini")
			FileInstall, settings\ac'tivAid.ini, settings\ac'tivAid.ini
		}
		IfNotExist, icons\internals\ac'tivAid_on.ico
		{
			func_UnpackSplash("icons\internals\ac'tivAid_on.ico")
			FileInstall, icons\internals\ac'tivAid_on.ico, icons\internals\ac'tivAid_on.ico
		}
		IfNotExist, icons\internals\ac'tivAid_off.ico
		{
			func_UnpackSplash("icons\internals\ac'tivAid_off.ico")
			FileInstall, icons\internals\ac'tivAid_off.ico, icons\internals\ac'tivAid_off.ico
		}
		IfNotExist, ac'tivAid LiesMich.txt
		{
			func_UnpackSplash("ac'tivAid LiesMich.txt")
			FileInstall, ac'tivAid LiesMich.txt, ac'tivAid LiesMich.txt
		}
		IfNotExist, ac'tivAid ReadMe.txt
		{
			func_UnpackSplash("ac'tivAid ReadMe.txt")
			FileInstall, ac'tivAid ReadMe.txt, ac'tivAid ReadMe.txt
		}
		IfNotExist, ac'tivAid ChangeLog.txt
		{
			func_UnpackSplash("ac'tivAid ChangeLog.txt")
			FileInstall, ac'tivAid ChangeLog.txt, ac'tivAid ChangeLog.txt
		}
	}
	IfNotExist, extensions\RunWithAdminRights.exe
	{
		func_UnpackSplash("extensions\RunWithAdminRights.exe")
		FileInstall, extensions\RunWithAdminRights.exe, extensions\RunWithAdminRights.exe
	}
}

Suspend, On

ScriptIcon# = 1
ScriptOnIcon# = 1
ScriptOffIcon# = 1

IniRead, ReloadOnWakeUp, %ConfigFile%, %ScriptName%, ReloadOnWakeUp, 0
IniRead, DisableAutoUpdateOnSlowNetwork, %ConfigFile%, %ScriptName%, DisableAutoUpdateOnSlowNetwork, 1
IniRead, NoTrayIcon, %ConfigFile%, %ScriptName%, NoTrayIcon, 0
If (FileExist( activAidGlobalData "\icons\internals\ac'tivAid.ico" ) AND !FileExist( A_ScriptDir "\icons\internals\ac'tivAid.ico" ) )
{
	IniRead, ScriptIcon, %ConfigFile%, %ScriptName%, Icon, %activAidGlobalData%\icons\internals\ac'tivAid.ico
	IniRead, ScriptOnIcon, %ConfigFile%, %ScriptName%, TrayIcon_On, %activAidGlobalData%\icons\internals\ac'tivAid_on.ico
	IniRead, ScriptOffIcon, %ConfigFile%, %ScriptName%, TrayIcon_Off, %activAidGlobalData%\icons\internals\ac'tivAid_off.ico
}
Else
{
	IniRead, ScriptIcon, %ConfigFile%, %ScriptName%, Icon, %A_ScriptDir%\icons\internals\ac'tivAid.ico
	IniRead, ScriptOnIcon, %ConfigFile%, %ScriptName%, TrayIcon_On, %A_ScriptDir%\icons\internals\ac'tivAid_on.ico
	IniRead, ScriptOffIcon, %ConfigFile%, %ScriptName%, TrayIcon_Off, %A_ScriptDir%\icons\internals\ac'tivAid_off.ico
}
If (!InStr(ScriptIcon,"`:\") AND !InStr(ScriptIcon,"\\"))
	ScriptIcon = %A_WorkingDir%\%ScriptIcon%
If (!InStr(ScriptOnIcon,"`:\") AND !InStr(ScriptOnIcon,"\\"))
	ScriptOnIcon = %A_WorkingDir%\%ScriptOnIcon%
If (!InStr(ScriptOffIcon,"`:\") AND !InStr(ScriptOffIcon,"\\"))
	ScriptOffIcon = %A_WorkingDir%\%ScriptOffIcon%

; Falls das Skript als EXE-Datei vorliegt, verwendet es sich selber für die Icons
; das setzt voraus, dass die AutoHotkeySC.bin im Compilerverzeichnis modifiziert wurde
SplashIcon = %ScriptIcon%
If A_Iscompiled = 1
{
	ScriptIcon = %A_ScriptDir%\icons\internals\ac'tivAid.ico
	ScriptOnIcon = %A_ScriptDir%\icons\internals\ac'tivAid_on.ico
	ScriptOffIcon = %A_ScriptDir%\icons\internals\ac'tivAid_off.ico
	IfNotExist, %ScriptIcon%
	{
		ScriptIcon = %A_ScriptFullPath%
		ScriptIcon# = 1
		SplashIcon =
	}
	IfNotExist, %ScriptOnIcon%
	{
		ScriptOnIcon = %A_ScriptFullPath%
		ScriptOnIcon# = 1
	}
	IfNotExist, %ScriptOffIcon%
	{
		ScriptOffIcon = %A_ScriptFullPath%
		ScriptOffIcon# = 1
	}
	If ExeDistribution = 1
		ScriptTitle := ScriptTitle
	Else
		ScriptTitle := ScriptTitle " (exe)"
}
Else
{
	IfNotExist, %ScriptIcon%
	{
		ScriptIcon = %A_AhkPath%
		ScriptIcon# = 1
		SplashIcon =
	}
	IfNotExist, %ScriptOnIcon%
	{
		ScriptOnIcon = %A_AhkPath%
		ScriptOnIcon# = 6
	}
	IfNotExist, %ScriptOffIcon%
	{
		ScriptOffIcon = %A_AhkPath%
		ScriptOffIcon# = 7
	}
}

If (main_IsAdmin <> 1 AND A_WorkingDir = A_ScriptDir AND MainDirNotWriteable = 1)
{
	FileCreateDir, %activAidData%\settings
	If A_Iscompiled = 1
		FileCreateShortcut, %A_ScriptFullPath%, %activAidData%\%ScriptNameFull%.lnk,%activAidData%,,,
	Else
	{
		IfExist, %A_ScriptDir%\icons\internals\ac'tivAid.ico
			FileCreateShortcut,%A_AHKPath% /r "%A_ScriptFullPath%", %activAidData%\%ScriptNameFull%.lnk,%activAidData%,,,%ScriptIcon%
		Else
			FileCreateShortcut,%A_AHKPath% /r "%A_ScriptFullPath%", %activAidData%\%ScriptNameFull%.lnk,%activAidData%,,,
	}
	FileCopyDir, %A_ScriptDir%\settings\*.ini, %activAidData%\settings
	FileCopyDir, %A_ScriptDir%\settings\*.txt, %activAidData%\settings
	Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
	Run, %activAidData%\%ScriptNameFull%.lnk ; Reload
	ExitApp
}


IniRead, ListBox_selected, %ConfigFile%, %ScriptName%, GUIselected
IniRead, LastExitReason, %ConfigFile%, %ScriptName%, LastExitReason, %A_Space%

; Wenn ac'tivAid mit dem Parameter 'kill' aufgerufen wird, wird es direkt beendet.
; Wird für das Auto-Update der EXE-Datei benötigt
IfInString, A_Args, kill
	ExitApp

; Zeigt den Starbildschirm an, oder auch nicht.
If (!InStr( A_Args, "nosplash" ) OR LastExitReason <> "")
{
	If SplashIcon <>
	{
		SplashImage, 2:%SplashIcon%,b2 FS%FontSize5% C c00 ZY2 ZX2 w36, %A_Space%,,, Terminal
		SetTimer, tim_Loading, 50
	}
}

If ListBox_selected = ERROR
	ListBox_selected =


IniRead, Betatester, %ConfigFile%, %ScriptName%, Betatester, 0
If (A_IsCompiled = 1 AND ExeDistribution <> 1)
	Betatester = 0
BetatesterLast = %Betatester%

If ExeDistribution = 1
{
	UpdateArchive = update_activaid_exe.exe
	ScriptTitle := ScriptTitle "e"
	ScriptVersion := ScriptVersion "e"
	StringReplace, ScriptTitle, ScriptTitle, %A_Space%betae, e beta
	StringReplace, ScriptVersion, ScriptVersion, %A_Space%betae, e beta
	StringReplace, ScriptTitle, ScriptTitle, %A_Space%alphae, e alpha
	StringReplace, ScriptVersion, ScriptVersion, %A_Space%alphae, e alpha
}
Else
	UpdateArchive = update_activaid.exe

If AHKonUSB = 1
	ScriptTitle = Portable %ScriptTitle%

Debug("VAR", A_LineNumber, A_LineFile, "ReadMeFile,Lng")

If A_AHKversion < %neededAHKversion%
{
	SetTimer, tim_Loading, Off
	SplashImage, Off
	SplashImage, 2:Off
	MsgBox, 16, %ScriptTitle%, %lng_WrongAHKVersion%
	IfExist, DEV\Install\AHKinstall.exe
		Run, DEV\Install\AHKinstall.exe
	ExitApp
}

Gosub, CustomLanguage

; Benutzerdefinierte Variablen einfügen
IfExist, settings\custom-variables.ini
	Debug("INIT", A_LineNumber, A_LineFile, "#including custom-variables.ini ..." )
#Include *i settings\custom-variables.ini

If AHKonlyPortable = 1
{
	If A_AutoHotkeyDriveType = Network
		ScriptTitle = %ScriptTitle% (%lng_Network%)
	StringReplace, lng_UserMode001, lng_UserMode001, USB/,%USBreplace% ,A
	StringReplace, lng_UserMode101, lng_UserMode101, USB/,%USBreplace% ,A
	StringReplace, lng_UserMode011, lng_UserMode011, USB/,%USBreplace% ,A
	StringReplace, lng_UserMode111, lng_UserMode111, USB/,%USBreplace% ,A
	StringReplace, lng_CopyUSBSettingsToUser, lng_CopyUSBSettingsToUser, USB/,%USBreplace% ,A
	StringReplace, lng_CopyUSBSettingsToUserAsk, lng_CopyUSBSettingsToUserAsk, USB/,%USBreplace% ,A
	StringReplace, lng_CopyUSBSettingsFromUser, lng_CopyUSBSettingsFromUser, USB/,%USBreplace% ,A
	StringReplace, lng_CopyUSBSettingsFromUserAsk, lng_CopyUSBSettingsFromUserAsk, USB/,%USBreplace% ,A
	StringReplace, lng_CopyUSBSettingsToSingle, lng_CopyUSBSettingsToSingle, USB/,%USBreplace% ,A
	StringReplace, lng_CopyUSBSettingsToSingleAsk, lng_CopyUSBSettingsToSingleAsk, USB/,%USBreplace% ,A
}
Else If AHKonUSB = 1
	ScriptTitle = %ScriptTitle% (USB)

InputEscapeKeysAndDevices = %InputEscapeKeys%%InputFromDevices%

A_SpaceLine := "                                                                                                                                                                                                                                         "

lng_UpdateSuccess := lng_UpdateSuccess A_SpaceLine
StringLeft, lng_UpdateSuccess, lng_UpdateSuccess, 75

FileDelete, reload.cmd

Gosub, sub_GetAllEnv

If PATHEXT =
	PATHEXT = .COM;.EXE;.BAT;.CMD

IfInString, A_Args, uninstall
	Gosub, DoUninstall

OnExit, sub_OnExit

; Nützlichen Subroutinen als Aktion registrieren
registerAction("sub_VarDumpGUI", lng_VarDump)
registerAction("sub_Statistics")
registerAction("sub_OpenSettingsDir")
registerAction("sub_ShowDuplicates", lng_DuplicateTitle)
registerAction("EnableDisable", lng_EnableDisable, "sub_EnableDisable_Extension_action")
registerAction("Download", lng_Download, "sub_Download_Action")
registerAction("Upload", lng_Upload, "sub_Upload_Action")
registerAction("PlaySound",lng_playSound,"action_playSound")

If ScriptIcon <>
{
	ScriptIconFromDll := DllCall("LoadImage", uint, 0
		, str, ScriptIcon  ; Icon filename (this file may contain multiple icons).
		, uint, 1  ; Type of image: IMAGE_ICON
		, int, 32, int, 32  ; Desired width & height of image (helps LoadImage decide which icon is best).
		, uint, 0x10)  ; Flags: LR_LOADFROMFILE
}


; Prüfen ob NiftyWindows aktiv ist
DetectHiddenWindows, On
IfWinExist,NiftyWindows,,.zip
	niftyWindows = on
Else
	IfWinExist,,NiftyWindows.ahk,.zip,NiftyWindows.ini
		niftyWindows = on
DetectHiddenWindows, Off

Gosub, tim_WM_DISPLAYCHANGE

; Prüfen ob die Sprechblasen (BalloonTips) deaktiviert sind
RegRead, EnableBalloonTips, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, EnableBalloonTips


IniRead, ShowFocusToolTips, %ConfigFile%, %ScriptName%, ShowFocusToolTips, 1
IniRead, BackupOnUpdate, %ConfigFile%, %ScriptName%, BackupOnUpdate, 1
IniRead, TrayClickOption, %ConfigFile%, %ScriptName%, TrayClickOption, 1
IniRead, TrayMClickOption, %ConfigFile%, %ScriptName%, TrayMClickOption, 5
IniRead, TrayRClickOption, %ConfigFile%, %ScriptName%, TrayRClickOption, 11
TrayClickOptionLast = %TrayClickOption%
IniRead, ExtensionsInExtDir, %ConfigFile%, %ScriptName%, AvailableExtensions
IniRead, ShowHotkeyListX, %ConfigFile%, %ScriptName%, ShowHotkeyListX, %A_Space%
IniRead, ShowHotkeyListY, %ConfigFile%, %ScriptName%, ShowHotkeyListY, %A_Space%
IniRead, ShowHotkeyListH, %ConfigFile%, %ScriptName%, ShowHotkeyListH, 330
IniRead, ShowHotkeyListW, %ConfigFile%, %ScriptName%, ShowHotkeyListW, 580
ShowHotkeyListW := ShowHotkeyListW - BorderHeight*2
ShowHotkeyListH := ShowHotkeyListH - BorderHeight*2 - CaptionHeight
IniRead, FileBrowser, %ConfigFile%, %ScriptName%, FileBrowser, Explorer
IniRead, FileBrowserWithTree, %ConfigFile%, %ScriptName%, FileBrowserWithTree, Explorer /e`,
IniRead, FileBrowserSelect, %ConfigFile%, %ScriptName%, FileBrowserSelect, Explorer /select`,
IniRead, FullScreenApps, %ConfigFile%, %ScriptName%, FullScreenApps, %A_Space%
IniRead, NetworkTimeout, %ConfigFile%, %ScriptName%, NetworkTimeout, 15
IniRead, WinModifierFirst, %ConfigFile%, %ScriptName%, WinModifierFirst, 0
IniRead, AllowMultipleInstances, %ConfigFile%, %ScriptName%, AllowMultipleInstances, 0
IniRead, lc_useGlobalHttpProxy, %ConfigFile%, %ScriptName%, GlobalHttpProxyEnable, 0
IniRead, lc_globalHttpProxyType, %ConfigFile%, %ScriptName%, GlobalHttpProxyType, HTTP
IniRead, lc_globalHttpProxyURL, %ConfigFile%, %ScriptName%, GlobalHttpProxyURL, localhost
IniRead, lc_globalHttpProxyPort, %ConfigFile%, %ScriptName%, GlobalHttpProxyPort, 8080
IniRead, lc_globalHttpProxyUser, %ConfigFile%, %ScriptName%, GlobalHttpProxyUser, %A_SPACE%
IniRead, lc_globalHttpProxyPass, %ConfigFile%, %ScriptName%, GlobalHttpProxyPass, %A_SPACE%
IniRead, lc_useGlobalFtpProxy, %ConfigFile%, %ScriptName%, GlobalFtpProxyEnable, 0
IniRead, lc_globalFtpProxyType, %ConfigFile%, %ScriptName%, GlobalFtpProxyType, HTTP
IniRead, lc_globalFtpProxyURL, %ConfigFile%, %ScriptName%, GlobalFtpProxyURL, localhost
IniRead, lc_globalFtpProxyPort, %ConfigFile%, %ScriptName%, GlobalFtpProxyPort, 8080
IniRead, lc_globalFtpProxyUser, %ConfigFile%, %ScriptName%, GlobalFtpProxyUser, %A_SPACE%
IniRead, lc_globalFtpProxyPass, %ConfigFile%, %ScriptName%, GlobalFtpProxyPass, %A_SPACE%
IniRead, lc_globalDownloadFolder, %ConfigFile%, %ScriptName%, GlobalFtpProxyPass, %A_SPACE%


If ShowHotkeyListH < 100
	ShowHotkeyListH = 330
If ShowHotkeyListW < 150
	ShowHotkeyListW = 580

; Werte für Statistik initialisiern
IniRead, MaintainStats, %ConfigFile%, %ScriptName%, MaintainStats, 1
If MaintainStats = 1
{
	statTimeLaunched = %A_Now%
	IniRead, statFirstLaunch, %ConfigFile%, Statistics, FirstLaunch, %A_Now%
	If (statFirstLaunch = "" OR statFirstLaunch = 0 OR statFirstLaunch = "ERROR")
		statFirstLaunch = %A_Now%
	IniRead, statLastLaunched, %ConfigFile%, Statistics, LastLaunched
	If (statLastLaunched = 0 OR statLastLaunched = "ERROR" OR statLastLaunched = "")
		statLastLaunched = %A_Now%
	If LastExitReason <> Reload
		IniWrite, %A_Now%, %ConfigFile%, Statistics, LastLaunched
	IniRead, statLaunchCount, %ConfigFile%, Statistics, LaunchCount
	If (statLaunchCount = "" OR statLaunchCount ="ERROR")
		statLaunchCount = 0
	statLaunchCount++
	IniRead, statReloadCount, %ConfigFile%, Statistics, ReloadCount
	If (statReloadCount = "" OR statReloadCount = "ERROR")
		statReloadCount = 0
	IniRead, statUpdateCount, %ConfigFile%, Statistics, UpdateCount
	If (statUpdateCount = "" OR statUpdateCount = "ERROR")
		statUpdateCount = 0
	IniRead, statExitCount, %ConfigFile%, Statistics, ExitCount
	If (statExitCount = "" OR statExitCount = "ERROR")
		statExitCount = 0
	IniRead, statTotalTime, %ConfigFile%, Statistics, TotalTime
	If (statTotalTime = "" OR statTotalTime = "ERROR")
		statTotalTime = 0
	IniRead, statLongestSession, %ConfigFile%, Statistics, LongestSession
	If (statLongestSession = "" OR statLongestSession = "ERROR")
		statLongestSession = 0
}

IniRead, LastScriptversion, %ConfigFile%, %ScriptName%, LastScriptVersion, 0
IniRead, activAid_LastFolder, %ConfigFile%, %ScriptName%, LastFolder, 0
IniRead, HotkeyListAOT, %ConfigFile%, %ScriptName%, HotkeyListAOT, 1

If A_IsCompiled = 1
{
	IniWrite, %_Debug%, %ConfigFile%, %ScriptName%, Debug
	_Devel = 0
}

func_HotkeyRead( "ProblemSolver" , ConfigFile, ScriptName, "Hotkey_ProblemSolver", "sub_ProblemSolver", "#+#" )
func_HotkeyRead( "MainGUI" , ConfigFile, ScriptName, "Hotkey_MainGUI", "sub_MainGUI", "#a" )
func_HotkeyRead( "DisableEnable" , ConfigFile, ScriptName, "Hotkey_DisableEnable", "sub_MenuSuspend", "#+ESCAPE" )
tempsuspend = 0
func_HotkeyRead( "TempSuspend" , ConfigFile, ScriptName, "Hotkey_TemporarySuspend", "sub_TempSuspend", "", "$" )
func_HotkeyRead( "ShowHotkeyList" , ConfigFile, ScriptName, "Hotkey_ShowHotkeyList", "sub_ShowHotkeyList", "^#F1")
func_HotkeyRead( "ShowMainContextMenu" , ConfigFile, ScriptName, "Hotkey_ShowMainContextMenu", "sub_ShowMainContextMenu", "#<")
func_HotkeyRead( "ReloadActivAid" , ConfigFile, ScriptName, "Hotkey_ReloadActivAid", "sub_MenuReload", "#!a" )
func_HotkeyEnable("MainGUI")
func_HotkeyEnable("DisableEnable")
func_HotkeyEnable("TempSuspend")
func_HotkeyEnable("ProblemSolver")
func_HotkeyEnable("ShowHotkeyList")
func_HotkeyEnable("ShowMainContextMenu")
func_HotkeyEnable("ReloadActivAid")

;Explorer Context Menu
if _ecmEnabled = 1
	ecm_init()
else
	ecm_delMenu()     ;clean Up



; Skript-Überwachung, damit es bei Änderung neu geladen wird
If ( _Devel <> 0 AND A_IsCompiled <> 1 AND MainDirNotWriteable = 0)
	SetTimer, tim_UPDATEDSCRIPT, 1000

; Gelegentlich auf NiftyWindows prüfen
SetTimer, tim_CheckForNifty, 2000

SetTimer, tim_WM_DISPLAYCHANGE, 2000


; -----------------------------------------------------------------------------
; Tray-Menü und Icon erstellen
; -----------------------------------------------------------------------------
Menu, Tray, Tip, %ScriptTitle%
Menu, Tray, NoStandard

;Pre-Vista Iconmenü ermöglichen
if _useTrayMenuIcons = 1
{
	WS_EX_APPWINDOW = 0x40000
	WS_EX_TOOLWINDOW = 0x80

	GW_OWNER = 4

	hTM := MI_GetMenuHandle("Tray")
	if (aa_osversionnumber < aa_osversionnumber_vista)
	{
		OnMessage(0x404, "sub_trayClick")
		MI_SetMenuStyle(hTM, 0x04000000)

	}
}
ReadIcon(lng_Help, A_WinDir "\system32\shell32.dll", 24)
ReadIcon(lng_Extensions, A_WinDir "\system32\shell32.dll", 91)
ReadIcon(lng_Changelog, A_WinDir "\system32\shell32.dll", 214)
ReadIcon(lng_ConnectionsTab, A_WinDir "\system32\shell32.dll", 89)
ReadIcon(lng_Hotkeys, A_WinDir "\system32\shell32.dll", 212)
ReadIcon("activAid", ScriptOnIcon, 0)
ReadIcon("Info", ScriptOnIcon, 0)
ReadIcon("ShowHotkeyList", A_WinDir "\system32\shell32.dll", 172)
ReadIcon("ShowMainContextMenu", ScriptOnIcon, 0)
ReadIcon("MainContextMenuListLines", ScriptOnIcon, 0)
ReadIcon("MainContextMenuListVars", ScriptOnIcon, 0)
ReadIcon("MainContextMenuListHotkeys", ScriptOnIcon, 0)
ReadIcon("MainContextMenuKeyHistory", ScriptOnIcon, 0)
ReadIcon("MainContextMenuWindowSpy", ScriptOnIcon, 0)
ReadIcon("MainContextMenuMainContext", ScriptOnIcon, 0)
ReadIcon("Update", A_WinDir "\system32\shell32.dll", 89)
ReadIcon("ProblemSolver", A_WinDir "\system32\shell32.dll", 24)
ReadIcon("HideAllExtensions", A_WinDir "\system32\shell32.dll", 218)
ReadIcon("reload", A_WinDir "\system32\shell32.dll", 147)
ReadIcon("deactivate", A_WinDir "\system32\shell32.dll", 110)
ReadIcon("Ahk", A_AhkPath, 1)
ReadIcon("Exit", A_WinDir "\system32\shell32.dll", 28)

Menu, Tray, Add, % lng_Info "`t" func_HotkeyDecompose( Hotkey_MainGUI, 1 ) , sub_MainGUI
Menu, Tray, Add, % lng_ShowHotkeyList "`t" func_HotkeyDecompose( Hotkey_ShowHotkeyList, 1 ) , sub_ShowHotkeyList
Menu, Tray, ToggleEnable, % lng_Info "`t" func_HotkeyDecompose( Hotkey_MainGUI, 1 )

if _useTrayMenuIcons = 1
{
	MI_SetMenuItemIcon(hTM, 1, TrayIcon[Info], TrayIconPos[Info], 16)
	MI_SetMenuItemIcon(hTM, 2, TrayIcon[ShowHotkeyList], TrayIconPos[ShowHotkeyList], 16)
}

If TrayClickOption = 5
{
	Menu, Tray, Add, % lng_ShowMainContextMenu "`t" func_HotkeyDecompose( Hotkey_ShowMainContextMenu, 1 ), sub_ShowMainContextMenu
	if _useTrayMenuIcons = 1
		MI_SetMenuItemIcon(hTM, 3, TrayIcon[ShowMainContextMenu], TrayIconPos[ShowMainContextMenu], 16)
	mi_trayNum = 4
}
else
	mi_trayNum = 3

Loop
{
	actFunct := Extension[%A_Index%]
	If actFunct =
		Break

	If (IsLabel( "TrayClick_" actFunct ))
	{
		RegisterHook("TrayClick",actFunct)
		Gosub, TrayClick_lng_%actFunct%
		lng_TrayClickOptions := lng_TrayClickOptions "|" lng_TrayClick_%actFunct%
	}
}

Loop, Parse, lng_TrayClickOptions, |
{
	If A_Index = %TrayClickOption%
		TrayClickOptionText = %A_LoopField%

	If A_Index = %TrayMClickOption%
		TrayMClickOptionText = %A_LoopField%

	If A_Index = %TrayRClickOption%
		TrayRClickOptionText = %A_LoopField%
}

If TrayClickOption = 6
{
	Menu, Tray, Add, % TrayClickOptionText, sub_MainContextMenuListLines
	if _useTrayMenuIcons = 1
		MI_SetMenuItemIcon(hTM, mi_trayNum, TrayIcon[MainContextMenuListLines], TrayIconPos[MainContextMenuListLines], 16)
	mi_trayNum += 1
}
If TrayClickOption = 7
{
	Menu, Tray, Add, % TrayClickOptionText, sub_MainContextMenuListVars
	if _useTrayMenuIcons = 1
		MI_SetMenuItemIcon(hTM, mi_trayNum, TrayIcon[MainContextMenuListVars], TrayIconPos[MainContextMenuListVars], 16)
	mi_trayNum += 1
}
If TrayClickOption = 8
{
	Menu, Tray, Add, % TrayClickOptionText, sub_MainContextMenuListHotkeys
	if _useTrayMenuIcons = 1
		MI_SetMenuItemIcon(hTM, mi_trayNum, TrayIcon[MainContextMenuListHotkeys], TrayIconPos[MainContextMenuListHotkeys], 16)
	mi_trayNum += 1
}
If TrayClickOption = 9
{
	Menu, Tray, Add, % TrayClickOptionText, sub_MainContextMenuKeyHistory
	if _useTrayMenuIcons = 1
		MI_SetMenuItemIcon(hTM, mi_trayNum, TrayIcon[MainContextMenuKeyHistory], TrayIconPos[MainContextMenuKeyHistory], 16)
	mi_trayNum += 1
}
If TrayClickOption = 10
{
	Menu, Tray, Add, % TrayClickOptionText, sub_MainContextMenuWindowSpy
	if _useTrayMenuIcons = 1
		MI_SetMenuItemIcon(hTM, mi_trayNum, TrayIcon[MainContextMenuWindowSpy], TrayIconPos[MainContextMenuWindowSpy], 16)
	mi_trayNum += 1
}
If TrayClickOption = 11
{
	Menu, Tray, Add, % TrayClickOptionText, sub_MainContextMenuMainContext
	if _useTrayMenuIcons = 1
		MI_SetMenuItemIcon(hTM, mi_trayNum, TrayIcon[MainContextMenuMainContext], TrayIconPos[MainContextMenuMainContext], 16)
	mi_trayNum += 1
}

Loop, Parse, hook_TrayClick, |
{
	If A_LoopField =
		continue
	If (TrayClickOptionText = lng_TrayClick_%A_LoopField%)
	{
		Menu, Tray, Add, % TrayClickOptionText, TrayClick_%A_LoopField%
		if (_useTrayMenuIcons = 1 && IconFile_On_%A_LoopField%!="" && FileExist(IconFile_On_%A_LoopField%))
		{
			ReadIcon(%A_LoopField%, IconFile_On_%A_LoopField%, IconPos_On_%A_LoopField%)
			MI_SetMenuItemIcon(hTM, mi_trayNum, TrayIcon[%A_LoopField%], TrayIconPos[%A_LoopField%], 16)
		}
		mi_trayNum += 1
	}
}

Menu, Tray, Add, %lng_update%, sub_getUpdates
Menu, Tray, Add
Menu, Tray, Add, % lng_ProblemSolver "`t" func_HotkeyDecompose( Hotkey_ProblemSolver, 1 ) , sub_ProblemSolver

if _useTrayMenuIcons = 1
{
	MI_SetMenuItemIcon(hTM, mi_trayNum, TrayIcon[Update], TrayIconPos[Update], 16)
	MI_SetMenuItemIcon(hTM, mi_trayNum+2, TrayIcon[ProblemSolver], TrayIconPos[ProblemSolver], 16)
	mi_trayNum := mi_trayNum + 3
}

If (A_IsCompiled <> 1 AND Extension[1] <> "")
{
	IfExist, extensions
	{
		Menu, Tray, Add, %lng_ExtDeinst%, sub_HideAllExtensions
		if _useTrayMenuIcons = 1
		{
			MI_SetMenuItemIcon(hTM, mi_trayNum, TrayIcon[HideAllExtensions], TrayIconPos[HideAllExtensions], 16)
			mi_trayNum := mi_trayNum + 1
		}
	}
}

Menu, Tray, Add, %lng_reload%, sub_MenuReload
Menu, Tray, Add, %lng_exit% , sub_MenuExit
Menu, Tray, Add
mi_trayNum := mi_trayNum + 2
If (TrayClickOption >= 6 AND TrayClickOption <= 11)
	TrayMenu = 9
Else
	TrayMenu = 8

TrayMenuFirstExtension := TrayMenu - 1


; GuiIDs vordefinieren
CreateGuiID("activAid") ; 1
CreateGuiID("HelpWindow") ; 2
CreateGuiID("HotkeyList") ; 4
CreateGuiID("ManualUpdate") ; 5
CreateGuiID("GetPasswords") ; 5
CreateGuiID("Statistics") ; 12
CreateGuiID("Duplicates")
CreateGuiID("VarDump")
if(LastGuiID != 8)
	Debug("ERROR", A_LineNumber, A_LineFile, "GuiID 9 for About dialog seems to be already in use.")
CreateGuiID("About")

Gosub, sub_DefaultWindowsHotkeyList

#include %A_ScriptDir%\internals\ac'tivAid_update.ahk

If AllowMultipleInstances = 0
{
	Critical, On
	DetectHiddenWindows, On
	OnMessage(0x1ccc,"GetExternalActivAidProcessID")
	WinGet, activAidProcesses, List, ahk_class AutoHotkey
	Loop, %activAidProcesses%
	{
		SendMessage, 0x1ccc, 1,,, % "ahk_id " activAidProcesses%A_Index%
		If (ErrorLevel <> activAidPID AND ErrorLevel > 1)
		{
			SetTimer, tim_Loading, Off
			SplashImage, Off
			SplashImage, 2:Off
			MsgBox, 52, %ScriptTitle%, %lng_AnotherActivAidActive%
			IfMsgBox, No
				ExitApp
			Break
		}
	}
	If (!InStr( A_Args, "nosplash" ) OR LastExitReason <> "")
	{
		SplashImage, 2:%SplashIcon%,b2 FS%FontSize5% C c00 ZY2 ZX2 w36, %A_Space%,,, Terminal
		SetTimer, tim_Loading, 50
	}
	DetectHiddenWindows, Off
	Critical, Off
}

gosub, shellhook_initEvent
resolution_prev = %A_ScreenWidth%x%A_ScreenHeight%
SetTimer, resolution_initTimer, 1000

#Include %A_ScriptDir%\internals\ac'tivAid_tray.ahk

Gosub, DoEnable_MButton
Gosub, DoEnable_RButton

If tempAdminMode = 1
	lng_UpdateSuccess = %lng_UpdateSuccess%`n`n%lng_AdminAttention%

; Readme-Datei einlesen
gosub, sub_GetReadme

; Changelog-Datei einlesen
gosub, sub_GetChangeLog

AutoTrim, On

; Problembehebung erforderlich?
; Prüfe ob versteckte Fenster nicht wiederhergestellt wurden
IniRead, TempDeskWindowsToMaximize, %ConfigFile%, TemporaryDesktop, WindowsToMaximize
If TempDeskWindowsToMaximize = ERROR
	TempDeskWindowsToMaximize =
IniRead, HiddenWindows, %ConfigFile%, HiddenWindows, WindowList
If HiddenWindows = ERROR
	HiddenWindows =
If HiddenWindows <>
	HiddenWindows = %HiddenWindows%|
StringReplace, HiddenWindows, HiddenWindows, ||,, a

IniRead, TempDeskWindows, %ConfigFile%, TemporaryDesktop, Windows
If TempDeskWindows = ERROR
	TempDeskWindows =

Loop, Parse, TempDeskWindows, |
{
	If A_LoopField =
		continue
	IniRead, TempDeskWindowX[%A_LoopField%], %ConfigFile%, TemporaryDesktop, WindowPosX%A_LoopField%
	IniRead, TempDeskWindowY[%A_LoopField%], %ConfigFile%, TemporaryDesktop, WindowPosY%A_LoopField%
	IniRead, TempDeskWindowMax[%A_LoopField%], %ConfigFile%, TemporaryDesktop, WindowMax%A_LoopField%
}

If HiddenWindows = ERROR
	HiddenWindows =

If ( HiddenWindows <> "" OR TempDeskWindows <> "" )
{
	ProbSolvStartMessage = %lng_ProbSolvWhy%`n`n
	Gosub, sub_ProblemSolver
}
If ShowGUI =
	IniRead, ShowGUI, %ConfigFile%, %ScriptName%, ShowGUI, 0

; Skript aktualisiert?
WorkingDir = %A_WorkingDir%
SetWorkingDir, %A_ScriptDir%

IfExist, versions.ini
{
	IniRead, tmp_avail, %ConfigFile%, activAid, AvailableExtensions
	If tmp_avail = ERROR
	{
		FileDelete, versions.ini
	}
	Else
	{
		IniRead, newScriptVersion, versions.ini, activAid, version
		IniRead, newScriptExtension, versions.ini, activAid, Extensions
		FileMove, versions.ini, update.exe, 1
		IniWrite, %newScriptExtension%, %ConfigFile%, activAid, newext
		IniWrite, %newScriptVersion%, %ConfigFile%, activAid, newver
	}
}

IfExist, ac'tivAid-updater.exe
{
	FileDelete, ac'tivAid-updater.exe
	If A_IsCompiled = 1
	{
		IniRead, CreateUninstaller, %ConfigFile%, %ScriptName%, CreateUninstaller
		If CreateUninstaller = 1
			IniWrite, 2, %ConfigFile%, %ScriptName%, CreateUninstaller
		tempAdminMode = 1
	}
}

If (FileExist("update.exe") OR FileExist("update.zip"))
{
	FileSetAttrib,-A,%A_ScriptFullPath%
	FileSetAttrib,-R,update.exe
	FileSetAttrib,-R,update.zip
	FileSetAttrib,-R,update.cmd
	FileDelete, update.zip
	FileDelete, update.exe
	FileDelete, AutoHotkeyInstall.exe
	FileDelete, update_autohotkey.exe
	FileDelete, update.cmd
	IniRead, newext, %ConfigFile%, activAid, newext, %A_Space%
	IniRead, updScriptVersion, %ConfigFile%, activAid, newver
	newext = %newext%
	updScriptExtension =
	updScriptExtension_line := "  "
	Loop, Parse, newext, `,
	{
		IfNotInstring, ExtensionsInExtDir, %A_LoopField%`,
		{
			updScriptExtension_line := updScriptExtension_line A_LoopField "`, "
			If ( StrLen( updScriptExtension_line ) > 77)
			{
				updScriptExtension := updScriptExtension "`n  "
				updScriptExtension_line := "  " A_LoopField "`, "
			}
			updScriptExtension := updScriptExtension A_LoopField "`, "
		}
	}
	If ExtensionsInExtDir = ERROR
		updScriptExtension =
	StringTrimRight, updScriptExtension, updScriptExtension, 2
	IniDelete, %ConfigFile%, activAid, newver
	IniDelete, %ConfigFile%, activAid, newext
	ListBox_selected = 2
	ShowGui = 1

	Loop
	{
		IniRead, FileToDelete, %ConfigFile%, DeleteAfterUpdate, DeleteFile%A_Index%
		If FileToDelete = ERROR
			break
		StringReplace, FileToDelete, FileToDelete, /, \, A
		StringReplace, FileToDelete, FileToDelete, %A_WorkingDir%\,
		StringReplace, FileToDelete, FileToDelete, %A_ScriptDir%\,
		If (func_StrLeft(FileToDelete,1) = "\" OR InStr(FileToDelete, "\\") OR InStr(FileToDelete, ":\"))
			continue
		FileDelete, %FileToDelete%
		IfExist, %A_ScriptDir%\%FileToDelete%
			FileDelete, %A_ScriptDir%\%FileToDelete%
	}
}

SetWorkingDir, %WorkingDir%
SplitPath, A_WorkingDir,,BackupDir
BackupDir = %BackupDir%\ac'tivAid_backup

; Wöchentliches Update
IniRead, UpdateImmediatly, %ConfigFile%, %ScriptName%, CheckForUpdates, 0
IfInString, A_Args, SimulateUpdate
	SimulateUpdate = 1
IniDelete, %ConfigFile%, %ScriptName%, CheckForUpdates
IniRead, AutoUpdate, %ConfigFile%, %ScriptName%, AutoUpdate
IniRead, DelayedUpdateCheck, %ConfigFile%, %ScriptName%, DelayedUpdateCheck, %A_Space%
IniRead, LastUpdate, %ConfigFile%, %ScriptName%, LastUpdate
UpdateDiff := (A_YYYY A_YDay) - LastUpdate

; Update-URLs
IniRead, UpdateURLbeta, %ConfigFile%, %ScriptName%, UpdateURL

If (UpdateURLbeta = "ERROR" OR UpdateURLbeta = "")
	UpdateURLbeta = http://activaid.rumborak.de/ahk-versions.ini

UpdateURLrelease = http://www.heise.de/ct/activaid/versions.ini

If ((UpdateURL = "ERROR" OR UpdateURL = "") AND Betatester = 1)
	UpdateURL = %UpdateURLbeta%

If (UpdateURL = "ERROR" OR UpdateURL = "") ; OR ExeDistribution = 1)
	UpdateURL = %UpdateURLrelease%
Else
	LastUpdate = ERROR

;If LeaveAdmin = 1
;{
;   StringReplace, A_Args, A_Args, LeaveAdmin
;   Gosub, sub_LeaveAdmin
;}

If ( ( (AutoUpdate = "1" AND (LastUpdate = "" OR LastUpdate = "ERROR" OR UpdateDiff >6 )) AND func_CheckIfOnline() = 1 ) OR (UpdateImmediatly = 1 AND main_IsAdmin = 1) )
{
	If DelayedUpdateCheck =
		Gosub, sub_AutoUpdate
	If AutoUpdate = 1
		SetTimer, tim_AutoUpdate, 86400000  ; 24*60*60*1000 = Alle 24 Std. prüfen
	If DelayedUpdateCheck+0 > 0
		SetTimer, tim_AutoUpdate, % -(DelayedUpdateCheck*1000)
	If DelayedUpdateCheck = On
		SetTimer, tim_AutoUpdate, -30000 ; 30 Sekunden
}

; Sprachen ermitteln
IfExist, settings\language.ini
{
	FileReadLine, iniLanguage, settings\language.ini, 1
	StringTrimLeft, iniLanguage, iniLanguage, 31
}

Languages = [ automatisch ermitteln / autodetect ]|Deutsch (German)|English|––––––––––––––––––––––––––––––––––––––––––––language-files––––

LanguageNum = 4
Loop, %A_ScriptDir%\settings\languages\language_*.ini,0,1
{
	FileReadLine, tempLanguage, %A_LoopFileFullPath%, 1
	IfNotInString, tempLanguage, `; Language-file for ac'tivAid:
		continue
	LanguageNum++
	StringTrimLeft, tempLanguage, tempLanguage, 31
	Languages = %Languages%|%tempLanguage%
	LanguagesFile[%LanguageNum%] = %A_LoopFileFullPath%
	If tempLanguage = %iniLanguage%
		actLanguage = %LanguageNum%
}
IfNotExist, settings\language.ini
{
	If Lng = 07
		actLanguage = 2
	Else
		actLanguage = 3
}
Else If actLanguage =
{
	LanguageNum++
	actLanguage := LanguageNum
	Languages = %Languages%|%iniLanguage%
	LanguagesFile[%actLanguage%] = settings\language.ini
}
If LanguageNum < 5
	StringReplace, Languages, Languages, |––––––––––––––––––––––––––––––––––––––––––––language-files––––,,

MinusString = —
If A_OSversion = WIN_NT4
{
	StringReplace, Languages, Languages, –, --, All
	MinusString = --
}

SetTimer, tim_Loading, Off
SplashImage, 2:Off

If _SingleClickTrayAction = 1
	Menu, Tray, Click, 1
Else
	Menu, Tray, Click, 2

If NoTrayIcon <> 1
{
	Menu, Tray, Icon, %ScriptOnIcon%, %ScriptOnIcon#%, 1
	Menu, Tray, Icon
	Gui, 1:Destroy
	mainGuiID =
}

Gui, 1:+LastFound
activAidID := WinExist()

ToolTip
Suspend, Off

Loop
{
	If Extension[%A_Index%] =
		break
	Function := Extension[%A_Index%]
	If ( IsLabel("OnResume_" Function) )
	{
		Debug("STATUS", A_LineNumber, A_LineFile, "OnResume_" Function "...")
		Gosub, OnResume_%Function%
	}
}

Menu, Tray, ToggleEnable, % lng_Info "`t" func_HotkeyDecompose( Hotkey_MainGUI, 1 )

TrayMenuSplit := func_AutoVSplitMenu("Tray")


system_UpTime := A_TickCount // 1000         ; Elapsed seconds since start
system_StartTime += -system_UpTime, Seconds
system_reboot := 0

IniRead, system_StartTimeLast, %ConfigFile%, Statistics, LastReboot, %A_Space%

if system_StartTimeLast =
	system_reboot := 1
else
{
	EnvSub, system_StartTimeLast, %system_StartTime%, seconds

	if system_StartTimeLast > 0
		system_reboot := 1
}

if system_reboot = 1
{
	IniWrite, %system_StartTime%, %ConfigFile%, Statistics, LastReboot
	throwEvent("Reboot")
}

Debug("INIT", A_LineNumber, A_LineFile, "Init finisehd: " A_TickCount - InitTime " ms")

LoadingFinished = 1
LoadingTime := A_TickCount-InitTime
throwEvent("LoadingFinished")

Gosub, sub_RestoreKeyStates
SplashImage, Off
SplashImage, 2:Off

func_AddMessage(0x100,"sub_ExtendEdit1Controls")
func_AddMessage(0x218,"sub_OnWakeUp") ; WM_POWERBROADCAST

If (ShowGUI > 0 OR ExtensionConflict <> "")
{
	If ExtensionConflict <>
		ListBox_selected = 6
	IniDelete, %ConfigFile%, %ScriptName%, ShowGUI
	SetTimer, tim_LaunchGUI, -20
}

IniRead, ShowVarDump, %ConfigFile%, %ScriptName%, ShowVarDump, %A_Space%
IniDelete, %ConfigFile%, %ScriptName%, ShowVarDump
If ShowVarDump = 1
	SetTimer, sub_VarDumpGUI, -20

SetTimer, CreateUninstallFile, -20

SetTimer, sub_ShowDuplicates, -2000
If (AHKonUSB <> 1 AND LastExitReason <> "Reload")
	IfExist, Portable_ac'tivAid.exe
		BalloonTip(ScriptTitle, lng_PortableExe,"Info",0,0,20)

IfExist, %A_ScriptDir%\installer.exe
{
	IniRead, CreateUninstaller, %ConfigFile%, %ScriptName%, CreateUninstaller
	If CreateUninstaller = 1
		IniWrite, 2, %ConfigFile%, %ScriptName%, CreateUninstaller
	FileDelete, %A_ScriptDir%\installer.exe
	tempAdminMode = 1
}

DllCall("kernel32.dll\SetProcessShutdownParameters", UInt, 0x4FF, UInt, 0)


SetTimer, sub_AfterLoadingProcesses, -5000

; Benutzerdefinierte Funktionen einfügen
IfExist, settings\includescript.ahk
	Debug("INIT", A_LineNumber, A_LineFile, "#including includescript.ahk ..." )

#Include *i settings\includescript.ahk

Return

#include %A_ScriptDir%\internals\ac'tivAid_actionHandling.ahk
#include %A_ScriptDir%\internals\ac'tivAid_additionalSettings.ahk
#include %A_ScriptDir%\internals\ac'tivAid_binary.ahk
#include %A_ScriptDir%\internals\ac'tivAid_chooseColor.ahk
#include %A_ScriptDir%\internals\ac'tivAid_controls.ahk
#include %A_ScriptDir%\internals\ac'tivAid_dateTime.ahk
#include %A_ScriptDir%\internals\ac'tivAid_eventSystem.ahk
#include %A_ScriptDir%\internals\ac'tivAid_filesFolders.ahk
#include %A_ScriptDir%\internals\ac'tivAid_func.ahk
#include %A_ScriptDir%\internals\ac'tivAid_GdipGUI.ahk
#include %A_ScriptDir%\internals\ac'tivAid_hotkey.ahk
#include %A_ScriptDir%\internals\ac'tivAid_mainFunc.ahk
#include %A_ScriptDir%\internals\ac'tivAid_oldOsd.ahk
#include %A_ScriptDir%\internals\ac'tivAid_rc4.ahk
#include %A_ScriptDir%\internals\ac'tivAid_scroll.ahk
#include %A_ScriptDir%\internals\ac'tivAid_statistics.ahk
#include %A_ScriptDir%\internals\ac'tivAid_stringFunc.ahk
#include %A_ScriptDir%\internals\ac'tivAid_unicode.ahk
#include %A_ScriptDir%\internals\ac'tivAid_unsorted.ahk
#Include %A_ScriptDir%\internals\ac'tivAid_osd.ahk
#Include %A_ScriptDir%\internals\ac'tivAid_hotkeyOSD.ahk
#Include %A_ScriptDir%\internals\ac'tivAid_ecm.ahk
#Include %A_ScriptDir%\internals\ac'tivAid_list.ahk
#include %A_ScriptDir%\Library\TrayIcons.ahk

; Funktionsbibliotheken laden
#include %A_ScriptDir%\library\CmdRet.ahk
#include %A_ScriptDir%\library\CoHelper.ahk
#include %A_ScriptDir%\library\FileHelper.ahk
#include %A_ScriptDir%\library\MI.ahk
#include %A_ScriptDir%\library\minicurl.ahk
#include %A_ScriptDir%\library\httpQuery.ahk

sub_Download_Action:
	StringSplit, lc_tmp_actionArray, ActionParameter, `,

	SplitPath, lc_tmp_actionArray1, lc_tmp_filename

	lc_actionDownload := lc_addDownload(lc_tmp_actionArray1,lc_tmp_filename,ScriptTitle)
	lc_addToQueue(lc_actionDownload)
return

sub_Upload_Action:
	StringSplit, lc_tmp_actionArray, ActionParameter, `,
	SplitPath, lc_tmp_actionArray1, lc_tmp_filename

	lc_actionUpload := lc_addUpload(lc_tmp_actionArray1,lc_tmp_actionArray2,ScriptTitle)
	lc_addToQueue(lc_actionUpload)
return



sub_DefaultWindowsHotkeyList:
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<#e ShowExplorer>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^Escape ShowStartMenu>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<+F10 ShowContextMenu>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<AppsKey ShowContextMenu>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<#r ShowRunDialog>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<#m MinimizeAllWindows>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<#+m RestoreAllWindows>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<#d ToggleDesktop>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<#b SetFocusToSysTray>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<#l LockWorkstation>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<#f ShowExplorerFindDialog>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<F3 Find>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<#u OpenUtilityManager>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<#F1 OpenWindowsHelp>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<#Pause OpenSystemProperties>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<#Tab CycleTaskbarButtons>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<#+Tab CycleTaskbarButtons>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<!Tab TaskSwitcher>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<!+Tab TaskSwitcher>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<!Escape TopWindowToBottom>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<!+Escape BottomWindowToTop>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<!F4 CloseWindow>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^!Delete ShowTaskmanager>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^!NumpadDel ShowTaskmanager>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^+Escape ShowTaskmanager>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<PrintScreen ScreenShotToClipboard>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<!PrintScreen WindowShotToClipboard>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^c CopyToClipboard>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^x CutToClipboard>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^p PasteFromClipboard>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^n NewFile>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^s SaveFile>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^o OpenFile>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^p PrintFile>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^z Undo>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^a SelectAll>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^f Find>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^F4 CloseTabOrChildWindow>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<F1 OpenHelp>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<F10 SetFocusToMenuBar>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<!Space ShowSystemMenu>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<Escape DefocusOrClose>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<Tab InsertTabOrCycleControls>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<+Tab InsertTabOrCycleControls>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^Tab CycleTabsOrChildWindows>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^+Tab CycleTabsOrChildWindows>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<Enter Enter>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<Space Space>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^Left MoveCursor>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^Right MoveCursor>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^Up MoveCursor>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^Down MoveCursor>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<+Left MoveCursorAndSelect>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<+Right MoveCursorAndSelect>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<+Up MoveCursorAndSelect>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<+Down MoveCursorAndSelect>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^+Left MoveCursorAndSelect>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^+Right MoveCursorAndSelect>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^+Up MoveCursorAndSelect>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^+Down MoveCursorAndSelect>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<End MoveCursor>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<Home MoveCursor>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^End MoveCursor>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^Home MoveCursor>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<+End MoveCursorAndSelect>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<+Home MoveCursorAndSelect>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^+End MoveCursorAndSelect>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^+Home MoveCursorAndSelect>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<Backspace Backspace>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<Delete Delete>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^Backspace Backspace>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^Delete Delete>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<^d DeletFileInExplorer>»
	Hotkey_WindowsHotkeys = %Hotkey_WindowsHotkeys%«<+Delete DeleteFileOrSelection>»
Return

sub_AdminAttentionDialog:
	Gui %GuiID_activAid%:+OwnDialogs
	IfInString, Changelog, %lng_UpdateSuccess%
	{
		MsgBox, 52, %ScriptTitle%, %lng_AdminAttention%`n`n  %lng_AdminAttentionAsk%
		LeaveAdmin = 1
		IfMsgBox, Yes
			Gosub, Reload
	}
	Else
		MsgBox, 48, %ScriptTitle%, %lng_AdminAttention%
Return

sub_AfterLoadingProcesses:
	If tempAdminMode = 1
	{
		Gosub, sub_AdminAttentionDialog
	}

	IniRead, DisableToggleLayoutQuestion, %ConfigFile%, %ScriptName%, DisableToggleLayoutQuestion, 0
	RegRead, KeyBoardLayoutReg1, HKEY_CURRENT_USER, Keyboard Layout\Toggle, Hotkey
	RegRead, KeyBoardLayoutReg2, HKEY_CURRENT_USER, Keyboard Layout\Toggle, Language Hotkey
	RegRead, KeyBoardLayoutReg3, HKEY_CURRENT_USER, Keyboard Layout\Toggle, Layout Hotkey
	If (KeyBoardLayoutReg1 KeyBoardLayoutReg2 KeyBoardLayoutReg3 <> "333" AND DisableToggleLayoutQuestion = 0 AND AHKonUSB <> 1)
	{
		MsgBox, 52, %ScriptTitle%, %lng_DisableToggleLayout%
		IfMsgBox, Yes
		{
			RegWrite, REG_SZ, HKEY_CURRENT_USER, Keyboard Layout\Toggle, Hotkey, 3
			RegWrite, REG_SZ, HKEY_CURRENT_USER, Keyboard Layout\Toggle, Language Hotkey, 3
			RegWrite, REG_SZ, HKEY_CURRENT_USER, Keyboard Layout\Toggle, Layout Hotkey, 3
			DllCall("SystemParametersInfo", "Uint", 91, "Uint", 0, "str", 0, "Uint", 0)
		}
		IniWrite, 1, %ConfigFile%, %ScriptName%, DisableToggleLayoutQuestion
	}

	Loop
	{
		If Extension[%A_Index%] =
			break
		Function := Extension[%A_Index%]
		If ( IsLabel("AfterLoadingProcess_" Function) )
			Gosub, AfterLoadingProcess_%Function%
	}
Return

tim_LaunchGUI:
	If tim_LaunchGUI = 1
		Return
	tim_LaunchGUI = 1
	Gosub, sub_MainGUI
	If ShowGUI = 2
		Gosub, sub_CallFAQ
Return

GetExternalActivAidProcessID(wParam, lParam, msg, hwnd)
{
	global
	If (wParam = 1) ; Check if RunWithAdminRights.ahk is running
		Return %activAidPID%
	Return 0
}

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

sub_ShowDuplicates:
	Critical
	If (Hotkey_AllDuplicates = "" OR Hotkey_AllDuplicates = "`n")
	{
		Gosub, DuplicatesGuiClose
		Return
	}

	Gui, %GuiID_Duplicates%:+LastFoundExist
	IfWinExist
		Gosub, DuplicatesGuiClose

	IniRead, ShowDuplicatesGuiX, %ConfigFile%, %ScriptName%, ShowDuplicatesGuiX
	IniRead, ShowDuplicatesGuiY, %ConfigFile%, %ScriptName%, ShowDuplicatesGuiY

	If ShowDuplicatesGuiX = ERROR
		ShowDuplicatesGuiX =
	Else
	{
		If (ShowDuplicatesGuiX < MonitorAreaLeft)
			ShowDuplicatesGuiX := MonitorAreaLeft
		If (ShowDuplicatesGuiX+420+BorderHeight*2 > MonitorAreaRight)
			ShowDuplicatesGuiX := MonitorAreaRight-(420+BorderHeight*2)
		ShowDuplicatesGuiX = x%ShowDuplicatesGuiX%
	}
	If ShowDuplicatesGuiY = ERROR
		ShowDuplicatesGuiY =
	Else
	{
		If (ShowDuplicatesGuiY < MonitorAreaTop)
			ShowDuplicatesGuiY := MonitorAreaTop
		If (ShowDuplicatesGuiY+480+MenuBarHeight+BorderHeight*2+CaptionHeight > MonitorAreaBottom)
			ShowDuplicatesGuiY := MonitorAreaBottom-(480+MenuBarHeight+BorderHeight*2+CaptionHeight)
		ShowDuplicatesGuiY = y%ShowDuplicatesGuiY%
	}

	ShowDuplicatesID := GuiDefault("Duplicates","+ToolWindow +LastFoundExist +AlwaysOnTop")
	Gui, Add, Text, w400, %lng_DuplicateHotkeys%
	Gui, Add, ListView, h300 w400 gsub_DuplicatesSelect vDuplicatesList -wrap +VScroll +HScroll, %lng_DuplicateCol1%|%lng_DuplicateCol2%|%lng_DuplicateCol3%
	GuiControl, -Redraw, DuplicatesList
	DuplicatesVisible = 0
	Duplicate = 0
	LastLoopField2 =

	Loop, Parse, Hotkey_AllDuplicates, `n
	{
		If A_LoopField =
			continue
		StringSplit, LoopField, A_LoopField, %A_Tab%
		If (LoopField2 <> LastLoopField2 AND LoopField2 <> "*" LastLoopField2 AND "*" LoopField2 <> LastLoopField2)
		{
			Duplicate++
			DuplicatesVisible%Duplicate% = 0
		}

		If (Enable_%LoopField1% = 1 OR LoopField1 = "activAid")
		{
			DuplicatesVisible++
			DuplicatesVisible%Duplicate%++
			If DuplicatesVisible%Duplicate% = 1
			{
				Duplicate--
				If DuplicatesVisible%Duplicate% = 1
				{
					DuplicatesVisible--
					LV_Delete(DuplicatesVisible)
				}
				Duplicate++
			}
			LV_Add("", LoopField1, LoopField2, LoopField3)
			LastLoopField2 := LoopField2
		}
	}
	If DuplicatesVisible%Duplicate% = 1
	{
		LV_Delete(DuplicatesVisible)
		DuplicatesVisible--
	}
	LV_ModifyCol()
	GuiControl, +Redraw, DuplicatesList
	If DuplicatesVisible = 0
		Gui, Destroy
	Else
		Gui, Show, %ShowDuplicatesGuiX% %ShowDuplicatesGuiY%, %ScriptNameFull% - %lng_DuplicateTitle%
Return

DuplicatesGuiEscape:
DuplicatesGuiClose:
	Gui, %GuiID_Duplicates%:+LastFoundExist
	IfWinNotExist
		Return

	If ShowDuplicatesGuiX <> Reset
	{
		WinGetPos, ShowDuplicatesGuiX, ShowDuplicatesGuiY, , , ahk_id %ShowDuplicatesID%
		IniWrite, %ShowDuplicatesGuiX%, %ConfigFile%, %ScriptName%, ShowDuplicatesGuiX
		IniWrite, %ShowDuplicatesGuiY%, %ConfigFile%, %ScriptName%, ShowDuplicatesGuiY
	}
	Gui, %GuiID_Duplicates%:Destroy
Return

sub_DuplicatesSelect:
	GuiDefault("Duplicates")
	Gui, ListView, DuplicatesList
	LV_GetText(goToDuplicateExtension, A_EventInfo, 1)
	If goToDuplicateExtension = activAid
		goToDuplicateExtension := lng_Hotkeys
	Gosub, sub_MainGUI
	GuiDefault("activAid")
	Gui, ListView, OptionsListBox
	LV_Modify( GuiTabs[%goToDuplicateExtension%], "Select Focus")
	Gosub, sub_OptionsListBox
Return

sub_VarDumpGUI:
	Critical
	Gui, %GuiID_VarDump%:+LastFoundExist
	IfWinExist
		Gosub, VarDumpGuiClose

	DefaultDumpVar1 = A_OSVersion
	DefaultDumpVar2 = aa_osversionnumber
	DefaultDumpVar3 = A_OSType
	DefaultDumpVar4 = A_OSWordSize
	DefaultDumpVar5 = A_ThisHotkey
	DefaultDumpVar6 = RegionFormatID

	IniRead, NumOfDumpVars, %ConfigFile%, %ScriptName%, NumOfDumpVars, 6
	If NumOfDumpVars < 1
		NumOfDumpVars = 6

	IniRead, VarDumpGuiX, %ConfigFile%, %ScriptName%, VarDumpGuiX
	IniRead, VarDumpGuiY, %ConfigFile%, %ScriptName%, VarDumpGuiY

	Loop, %NumOfDumpVars%
		IniRead, VarDumpVar%A_Index%, %ConfigFile%, %ScriptName%, VarDumpVar%A_Index%,% DefaultDumpVar%A_Index%

	If VarDumpGuiX = ERROR
		VarDumpGuiX =
	Else
	{
		If (VarDumpGuiX < MonitorAreaLeft)
			VarDumpGuiX := MonitorAreaLeft
		If (VarDumpGuiX+334+BorderHeight*2 > MonitorAreaRight)
			VarDumpGuiX := MonitorAreaRight-(334+BorderHeight*2)
		VarDumpGuiX = x%VarDumpGuiX%
	}
	If VarDumpGuiY = ERROR
		VarDumpGuiY =
	Else
	{
		If (VarDumpGuiY < MonitorAreaTop)
			VarDumpGuiY := MonitorAreaTop
		If (VarDumpGuiY+5+NumOfDumpVars*21+MenuBarHeight+BorderHeight*2+CaptionHeight > MonitorAreaBottom)
			VarDumpGuiY := MonitorAreaBottom-(5+NumOfDumpVars*21+MenuBarHeight+BorderHeight*2+CaptionHeight)
		VarDumpGuiY = y%VarDumpGuiY%
	}

	VarDumpGuiWinID:= GuiDefault("VarDump","+ToolWindow +LastFoundExist +AlwaysOnTop")
	Loop, %NumOfDumpVars%
	{
		Gui, Add, Edit, w100 R1 x10 y+5 g tim_VarDumpRefresh vVarDumpVar%A_Index%, % VarDumpVar%A_Index%
		Gui, Add, Text, x+5, =
		Gui, Add, Edit, w400 x+5 ReadOnly vVarDumpVar%A_Index%Value,
	}

	Gui, Show, %VarDumpGuiX% %VarDumpGuiY%, %ScriptNameFull% - %lng_VarDump%
	SetTimer, tim_VarDumpRefresh, 100
Return

VarDumpGuiOK:
VarDumpGuiEscape:
VarDumpGuiClose:
	Gui, %GuiID_VarDump%:+LastFoundExist
	IfWinNotExist
		Return

	SetTimer, tim_VarDumpRefresh, Off
	If VarDumpGuiX <> Reset
	{
		WinGetPos, VarDumpGuiX, VarDumpGuiY, , , ahk_id %VarDumpGuiWinID%
		IniWrite, %VarDumpGuiX%, %ConfigFile%, %ScriptName%, VarDumpGuiX
		IniWrite, %VarDumpGuiY%, %ConfigFile%, %ScriptName%, VarDumpGuiY
	}
	Gui, %GuiID_VarDump%:Submit
	Loop, %NumOfDumpVars%
		IniWrite, % VarDumpVar%A_Index%, %ConfigFile%, %ScriptName%, VarDumpVar%A_Index%
	Gui, %GuiID_VarDump%:Destroy
Return

tim_VarDumpRefresh:
	SetWinDelay, -1
	Loop, %NumOfDumpVars%
	{
		GuiControlGet, VarDumpFocus, %GuiID_VarDump%:FocusV
		If VarDumpFocus = VarDumpVar%A_Index%Value
			continue
		GuiControlGet, VarDumpVar, %GuiID_VarDump%:, VarDumpVar%A_Index%
		VarDumpVar := func_StrClean(VarDumpVar)
		If VarDumpVar =
			VarDumpVar = A_EmptyVar
		VarDumpVar := %VarDumpVar%
		GuiControl,%GuiID_VarDump%: ,VarDumpVar%A_Index%Value, %VarDumpVar%
	}
Return



CreateUninstallFile:
	If AHKonUSB = 1
		Return

	IniRead, CreateUninstaller, %ConfigFile%, %ScriptName%, CreateUninstaller
	RegRead, InstallLocation, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid, InstallLocation
	If (InstallLocation <> A_ScriptDir AND CreateUninstaller = "ERROR" AND ErrorLevel = 0)
		CreateUninstaller = 1
	If ( ErrorLevel = 1 AND CreateUninstaller = 1 )
		CreateUninstaller = 0

	RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce, %ScriptName%

	If (CreateUninstaller = "ERROR" OR CreateUninstaller = "")
	{
		SetTimer, tim_Loading, Off
		SplashImage, 2:Off
		MsgBox, 36, %ScriptTitle%, %lng_CreateUninstaller%
		IfMsgBox, Yes
		{
			CreateUninstaller = 2
			Gosub, sub_MenuAutostart
			CreateUninstaller = 1
			SetTimer, tim_LaunchGUI, 50
		}
		IfMsgBox, No
			CreateUninstaller = 0
	}
	If CreateUninstaller = 2
	{
		Gosub, sub_MenuAutostart
		CreateUninstaller = 1
	}
	IniWrite, %CreateUninstaller%, %ConfigFile%, %ScriptName%, CreateUninstaller
	If CreateUninstaller = 1
	{
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid, DisplayName, %ScriptTitle%
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid, InstallLocation, %A_ScriptDir%
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid, DisplayVersion, %ScriptVersion%
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid, HelpLink, http://activaid.rumborak.de
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid, URLUpdateInfo, http://www.heise.de/ct/activaid/
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid, URLInfoAbout, http://www.heise.de/ct
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid, Publisher, Heise Zeitschriften Verlag GmbH & Co. KG
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid, Author, ac'tivAid Community
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid, Contact, ac'tivAid Community
		If A_IsCompiled = 1
			RegWrite, REG_SZ, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid, UninstallString, %A_ScriptFullPath% uninstall
		Else
			RegWrite, REG_SZ, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid, UninstallString, %A_AHKPath% "%A_ScriptFullPath%" uninstall
		RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid, NoModify, 1
		RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid, NoRepair, 1
		RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid, EstimatedSize, 800
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid, Size, 123
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid, Readme, %ReadMeFile%
		If ErrorLevel
			Error++
	}
Return

DoUninstall:
	RegRead, InstallLocation, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid, InstallLocation
	If ErrorLevel = 1
		Return

	RunWithAdminRightsPara = uninstall

	If main_IsAdmin <> 1
		Gosub, sub_RunAsAdmin

	SplitPath,UserProfile,,CrawlDir
	SplitPath,A_AppData,AppDataName
	RegRead, StartMenuName, HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders,Start Menu
	RegRead, AutoStartName, HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders,Startup
	RegRead, RegDesktop, HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders,Desktop
	StringReplace, RegDesktop, RegDesktop, `%USERPROFILE`%\
	SplitPath, StartMenuName, StartMenuName
	SplitPath, AutoStartName, AutoStartName

	UninstallPaths = %InstallLocation%

	Loop, %CrawlDir%\ac'tivAid.lnk,0,1
	{
		IfInString, A_LoopFileFullPath, \%AppDataName%
		{
			SplitPath, A_LoopFileFullPath, , LoopFilePath
			UninstallPaths = %UninstallPaths%`n%LoopFilePath%
		}
		IfInString, A_LoopFileFullPath, \%StartMenuName%\
		{
			IfInString, A_LoopFileFullPath, \%AutoStartName%
			{
				UninstallPaths = %UninstallPaths%`n%A_LoopFileFullPath%
			}
			IfInString, A_LoopFileFullPath, \ac'tivAid\
			{
				SplitPath, A_LoopFileFullPath,Prg,ProgramGroup
				UninstallPaths = %UninstallPaths%`n%ProgramGroup%
			}
		}
		IfInString, A_LoopFileFullPath, \%RegDesktop%\
			UninstallPaths = %UninstallPaths%`n%A_LoopFileFullPath%
	}

	SetTimer, tim_Loading, Off
	SplashImage, 2:Off
	MsgBox, 36, %ScriptTitle%, %lng_AskUninstall%%UninstallPaths%
	IfMsgBox, Yes
	{
		Loop, %CrawlDir%\ac'tivAid.lnk,0,1
		{
			IfInString, A_LoopFileFullPath, \%AppDataName%
			{
				SplitPath, A_LoopFileFullPath, , LoopFilePath
				Loop, %LoopFilePath%\*.*, 0, 1
				{
					FileDelete, %A_LoopFilefullpath%
				}
				Loop, %LoopFilePath%\*.*, 2, 1
				{
					FileRemoveDir, %A_LoopFilefullpath%, 1
				}
			}
			IfInString, A_LoopFileFullPath, \%StartMenuName%\
			{
				IfInString, A_LoopFileFullPath, \%AutoStartName%
				{
					FileDelete, %A_LoopFileFullPath%
				}
				IfInString, A_LoopFileFullPath, \ac'tivAid\
				{
					SplitPath, A_LoopFileFullPath,Prg,ProgramGroup
					FileRemoveDir, %ProgramGroup%, 1
				}
			}
			IfInString, A_LoopFileFullPath, \%RegDesktop%\
				FileDelete, %A_LoopFileFullPath%
		}
		RegDelete, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce, %ScriptName%, %ComSpec% /c del "%InstallLocation%\ac'tivAid.*" && rd /q "%InstallLocation%"
		FileDelete, %InstallLocation%\ac'tivAid*.*
		FileDelete, %InstallLocation%\Lizenz.txt
		FileDelete, %InstallLocation%\Library\tools\*.*
		Loop, %InstallLocation%\settings\*.*, 0, 1
		{
			FileDelete, %A_LoopFilefullpath%
		}
		Loop, %InstallLocation%\extensions\*.*, 0, 1
		{
			FileDelete, %A_LoopFilefullpath%
		}
		Loop, %InstallLocation%\library\*.*, 0, 1
		{
			FileDelete, %A_LoopFilefullpath%
		}
		FileRemoveDir, %A_Programs%\ac'tivAid, 1
		FileRemoveDir, %A_AppDataCommon%\ac'tivAid, 1
		FileRemoveDir, %InstallLocation%\settings, 1
		FileRemoveDir, %InstallLocation%\development, 1
		FileRemoveDir, %InstallLocation%\extensions, 1
		FileRemoveDir, %InstallLocation%, 0

		FileAppend, del "%InstallLocation%\ac'tivAid*.*"`r`n, %A_Temp%\uninst_aAd.cmd
		FileAppend, rd /q "%InstallLocation%"`r`n, %A_Temp%\uninst_aAd.cmd
		FileAppend, del "%A_Temp%\uninst_aAd.cmd"`r`n, %A_Temp%\uninst_aAd.cmd
		If A_IsCompiled = 1
			SendMessage, 0x1ccc, 33, 33,,%A_ScriptDir%\extensions\RunWithAdminRights.exe
		Else
			SendMessage, 0x1ccc, 33, 33,,%A_ScriptDir%\extensions\RunWithAdminRights.ahk - AutoHotkey v%A_Ahkversion%
		MsgBox, 32, %ScriptTitle%, %lng_UninstallFinished%
		Run, %A_Temp%\uninst_aAd.cmd,,Hide
	}
	ExitApp
Return

CustomLanguage:
	; Sprachdatei laden (lng-Variablen werden überschrieben)
	IfExist, settings\language.ini
		Debug("INIT", A_LineNumber, A_LineFile, "#including custom language-file ..." )
	#Include *i settings\language.ini
	Description := %Prefix%_Description
	MenuName := %Prefix%_MenuName
Return

; Erweiterungen laden (include)
#Include *i settings\extensions_main.ini

sub_GetReadme:
	ReadIndex = 1
	ReadmeGotoLine[1] = 1
	FileRead, Readme, %ReadMeFile%

	If tempAdminMode = 1
		Readme := "`n" lng_AdminAttention "`n`n" Readme

	If _Devel <> -1
		StringReplace, Readme, Readme, : ###), : %A_AHKversion%)

	ReadmeDropDown =
	ReadmeGotoLine =
	ReadmeEditIndex = 0
	Loop, Parse, Readme, `n, `r
	{
		ReadmeEditIndex := ReadmeEditIndex + StrLen( A_LoopField ) +2
		IfNotInstring, A_LoopField, % ". "
		{
			PrevReadmeEditIndex = %ReadmeEditIndex%
			continue
		}
		If (func_StrLeft(A_LoopField,1) <> " ")
			continue

		StringSplit, ReadLineSplit, A_LoopField, %A_Space%
		StringReplace, ReadLineTest1, ReadLineSplit2, ., , A
		ReadLineTest2 = %ReadLineTest1%
		ReadLineTest2++
		ReadLineTest2--
		If ((ReadLineTest1 = ReadLineTest2) AND ReadLineTest1 <> "")
		{
			ReadmeIndent = 0
			Loop, Parse, ReadLineSplit2
			{
				If A_LoopField = .
					ReadmeIndent++
			}
			ReadmeSpaces := "             "
			StringLeft, ReadmeSpaces, ReadmeSpaces, % ReadmeIndent * 3
			StringTrimLeft, ReadmeSpaces, ReadmeSpaces, 3
			StringTrimLeft, ReadLine, A_LoopField, 1
			ReadIndex++
			ReadmeDropDown = %ReadmeDropDown%|%ReadmeSpaces%%ReadLine%
			ReadmeGotoLine[%ReadIndex%] = %PrevReadmeEditIndex% ; %A_Index%
			ReadmeChapter[%ReadIndex%] = %A_LoopField%
		}
		PrevReadmeEditIndex = %ReadmeEditIndex%

		ReadLineSplit2 =
	}
	;FileSetAttrib,-A, %ReadMeFile%
	IfNotExist, settings\extensions_main.ini
		ReadMe = %lng_NoExtensionsInstalled%%ReadMe%
Return

sub_GetChangeLog:
	FileRead,ChangeLog, %ChangeLogFile%
	;FileSetAttrib,-A, %A_ScriptDir%\%ScriptNameFull% Changelog.txt
Return

tim_Loading:
	LoadingProgress++
	LoadingSymbols = ²±°° °°±²Û²±°° °°±²Û
	Loop, 8
	{
		StringMid, LoadingSymbol%A_Index%, LoadingSymbols, LoadingProgress+A_Index-1, 1
	}
	SplashImage, 2: , , %LoadingSymbol8%%LoadingSymbol7%%LoadingSymbol6%%LoadingSymbol5%%LoadingSymbol4%%LoadingSymbol3%%LoadingSymbol2%%LoadingSymbol1%
	If LoadingProgress > 10
		LoadingProgress = 0
Return

; Menüpunkt für Funktion erstellen und Haken setzen
sub_MenuCreate:
	If EnableTray_%actFunct% <> 1
		Return
	TrayExtensions++

	If SubMenu <>
	{
		Menu, Tray, add, %MenuName%, :%SubMenu%

		TrayMenu[%TrayMenu%] = %actFunct%
		TrayMenu[%actFunct%] = %TrayMenu%
		TrayMenuName[%TrayMenu%] = %MenuName%
		TrayMenuName[%SubMenu%] = %MenuName%
		TrayMenu++
		mi_trayNum++
		EnableMenu := %actFunct%_EnableMenu
		if Enable_%actFunct% = 1
		{
			If CustomHotkey_%actFunct% = 1
				func_HotkeyEnable( actFunct )

			If _useTrayMenuIcons = 1
				ReadIcon(actFunct, IconFile_On_%actFunct%, IconPos_On_%actFunct%)

			If (_useTrayMenuIcons = 1 && TrayIcon[%actFunct%]!="" && FileExist(TrayIcon[%actFunct%]))
				MI_SetMenuItemIcon(hTM, mi_trayNum, TrayIcon[%actFunct%], TrayIconPos[%actFunct%], 16)
			Else
				Menu, Tray, Check, %MenuName%

			Menu, %SubMenu%, Check, %EnableMenu%
		}
		Else
		{
			If CustomHotkey_%actFunct% = 1
			{
				func_HotkeyDisable( actFunct )
			}

			If _useTrayMenuIcons = 1
				ReadIcon(actFunct,IconFile_On_%actFunct%, IconPos_On_%actFunct%, IconFile_Off_%actFunct%, IconPos_Off_%actFunct%)

			If (_useTrayMenuIcons = 1 && TrayIconOff[%actFunct%]!="" && FileExist(TrayIconOff[%actFunct%]))
				MI_SetMenuItemIcon(hTM, mi_trayNum, TrayIconOff[%actFunct%], TrayIconOffPos[%actFunct%], 16)
			Else
				Menu, Tray, Uncheck, %MenuName%
			Menu, %SubMenu%, UnCheck, %EnableMenu%
		}
	}
	Else
	{
		Menu, Tray, add, %MenuName%, sub_MenuCall

		TrayMenu[%TrayMenu%] = %actFunct%
		TrayMenu[%actFunct%] = %TrayMenu%
		TrayMenuName[%TrayMenu%] = %MenuName%
		TrayMenu++
		mi_trayNum++
		If Enable_%actFunct% = 1
		{
			If CustomHotkey_%actFunct% = 1
				func_HotkeyEnable( actFunct )

			If _useTrayMenuIcons = 1
				ReadIcon(actFunct, IconFile_On_%actFunct%, IconPos_On_%actFunct%)

			If (_useTrayMenuIcons = 1 && TrayIcon[%actFunct%]!="" && FileExist(TrayIcon[%actFunct%]))
				MI_SetMenuItemIcon(hTM, mi_trayNum, TrayIcon[%actFunct%], TrayIconPos[%actFunct%], 16)
			Else
				Menu, Tray, Check, %MenuName%
		}
		Else
		{
			If CustomHotkey_%actFunct% = 1
			{
				func_HotkeyDisable( actFunct )
			}

			If _useTrayMenuIcons = 1
				ReadIcon(actFunct,IconFile_On_%actFunct%, IconPos_On_%actFunct%, IconFile_Off_%actFunct%, IconPos_Off_%actFunct%)

			If (_useTrayMenuIcons = 1 && TrayIconOff[%actFunct%]!="" && FileExist(TrayIconOff[%actFunct%]))
				MI_SetMenuItemIcon(hTM, mi_trayNum, TrayIconOff[%actFunct%], TrayIconOffPos[%actFunct%], 16)
			Else
				Menu, Tray, Uncheck, %MenuName%
		}
	}

	SubMenu =
Return

GuiDefaultFont:
	Gui, Font
	Gui, Font, S%FontSize% ; , Modern MS Sans Serif
Return

; Wird von den Menüpunkten aufgerufen.
sub_MenuCall:
	Thread, Priority, 1
	DoReload =
	Reload =

	If A_ThisMenu = Tray
	{
		RegExMatch(A_ThisMenuItem,"(.+) - ",MenuItem)
		MenuItem := MenuItem1
		If MenuItem =
			MenuItem := TrayMenu[%A_ThisMenuItemPos%]
	}
	Else
	{
		MenuID = 0
		StringSplit, MenuItem, A_ThisMenu, _
		MenuItem = %MenuItem1%
	}

	If _AlternativeTrayMenu = 1
	{
		If MainGuiVisible <>
			Gosub, activAidGuiClose
		SimpleMainGUI = %MenuItem%
		Gosub, sub_MainGUI
	}
	Else
	{
		Gosub, sub_EnableDisable_Extension
	}
Return

sub_EnableDisable_Extension_action:
	If ActionParameter =
		Gosub sub_MenuSuspend
	Else
	{
		MenuItem := ActionParameter
		Gosub, sub_EnableDisable_Extension
	}
Return

sub_EnableDisable_Extension:
	; Menupunkt de/aktivieren
	If Enable_%MenuItem% = 1
	{
		If _useTrayMenuIcons = 1
			ReadIcon(MenuItem,IconFile_On_%MenuItem%, IconPos_On_%MenuItem%, IconFile_Off_%MenuItem%, IconPos_Off_%MenuItem%)

		If (_useTrayMenuIcons = 1 && TrayIconOff[%MenuItem%]!="" && FileExist(TrayIconOff[%MenuItem%]))
		{
			htm_pos := TrayMenu[%MenuItem%] + Floor((TrayMenu[%MenuItem%]+1)/TrayMenuSplit)
			MI_SetMenuItemIcon(hTM, htm_pos, TrayIconOff[%MenuItem%], TrayIconOffPos[%MenuItem%], 16)
		}

		Menu, %A_ThisMenu%, UnCheck, %A_ThisMenuItem%

		If A_ThisMenu <> Tray
		{
			Menu, Tray, UnCheck, % TrayMenuName[%A_ThisMenu%]
		}

		Enable_%MenuItem% = 0

		If CustomHotkey_%MenuItem% = 1
			func_HotkeyDisable(MenuItem)

		Gosub, DoDisable_%MenuItem%
	}
	Else
	{
		If _useTrayMenuIcons = 1
			ReadIcon(MenuItem,IconFile_On_%MenuItem%, IconPos_On_%MenuItem%, IconFile_Off_%MenuItem%, IconPos_Off_%MenuItem%)

		If (_useTrayMenuIcons = 1 && TrayIcon[%MenuItem%]!="" && FileExist(TrayIcon[%MenuItem%]))
		{
			htm_pos := TrayMenu[%MenuItem%] + Floor((TrayMenu[%MenuItem%]+1)/TrayMenuSplit)
			MI_SetMenuItemIcon(hTM, htm_pos, TrayIcon[%MenuItem%], TrayIconPos[%MenuItem%], 16)
		}
		Else
			Menu, %A_ThisMenu%, Check, %A_ThisMenuItem%

		If A_ThisMenu <> Tray
			Menu, Tray, Check, % TrayMenuName[%A_ThisMenu%]

		Enable_%MenuItem% = 1

		If CustomHotkey_%MenuItem% = 1
			func_HotkeyEnable(MenuItem)

		Gosub, DoEnable_%MenuItem%
	}

	; Einstellung speichern
	actEnable = Enable_%MenuItem%

	IniWrite, % %actEnable% , %ConfigFile%, %ScriptName%, %actEnable%

	Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
	If (Reload = 1 OR DoReload = 1)
		Gosub, Reload
Return

; ProblemSolver versucht 'festhängende' Tasten und Maustasten zu lösen
sub_ProblemSolver:
	Gosub, sub_RestoreKeyStates  ; Korrigiert die Modifier-Tasten
	If (HiddenWindows <> "" OR TempDeskWindows <> "")
	{
		If IsLabel("cd_sub_RestoreTempDeskWindows")
			Gosub, cd_sub_RestoreTempDeskWindows%A_EmptyVar%
		If IsLabel("cd_sub_RestoreHiddenWindows")
			Gosub, cd_sub_RestoreHiddenWindows%A_EmptyVar%
		ProbSolvMessage = %ProbSolvMessage%%lng_ProbSolvHidden%
		ProbSolv=
		IniDelete,%ConfigFile%,TemporaryDesktop
		IniDelete,%ConfigFile%,HiddenWindows
	}
	If IsLabel("scr_sub_RefreshWindows")
		Gosub, scr_sub_RefreshWindows%A_EmptyVar%

	If IsLabel("OnExitAndReload_MinimizeToTray")
		Gosub, OnExitAndReload_MinimizeToTray%A_EmptyVar%

	If ProbSolvMessage =
		BalloonTip(ScriptTitle, ProbSolvStartMessage lng_ProbSolvNoRes,"Info",0,0,8)
	Else
		BalloonTip(ScriptTitle, ProbSolvStartMessage lng_ProbSolvResult "`n`n" ProbSolvMessage, "Info",0,0,8)
	ProbSolvStartMessage =
Return

sub_HideAllExtensions:
;   Critical
	MsgBox,36,%ScriptTitle%,%lng_ExtDeinstAsk%
	IfMsgBox, yes
	{
		FileMove, %ConfigFile%, %SettingsDir%\ac'tivAid_ProblemSolver.ini
		gosub, sub_ExtensionsOff
	}
Return

sub_MenuReload:
	Debug("RELOAD",A_LineNumber,A_LineFile,"Reload from menu")
	Gosub, Reload
return

Reload:
	Critical
	Suspend, On
	Process, Priority,, H
	If LeaveAdmin = 1
	{
		Gosub, sub_LeaveAdmin
	}
	Else
	{
		IfNotInString, A_Args, nosplash
		{
			If AutoStart = -1
				AutoStartNoSplash = nosplash
			Else
				AutoStartNoSplash =
		}
		Loop
		{
			Debug("RELOAD",A_LineNumber,A_LineFile,"Reload function")
			Sleep, 300

			If A_IsCompiled = 1
				Run, %A_ScriptFullPath% %A_Args%, , UseErrorLevel ; Reload
			Else
				If Reload = 2
					Run, %A_AhkPath% "%A_ScriptFullPath%" %A_Args% %AutoStartNoSplash%, %NewWorkingDir% , UseErrorLevel ; Reload
				Else
					Run, %A_AhkPath% /r "%A_ScriptFullPath%" %A_Args% %AutoStartNoSplash%, %NewWorkingDir% , UseErrorLevel ; Reload

			Reload =
			Sleep, 3000
			Suspend, Off
			MsgBox,21,%ScriptTitle%,%lng_ReloadFailed%
			Suspend, On
			Loop
			{
				IfWinExist, ac'tivAid.ahk, Error at line
					ControlClick,Button1, ac'tivAid.ahk, Error at line
				Else
					break
			}
			IfMsgBox, Cancel
				break
		}
	}
	Process, Priority,, %A_Priority%
	Suspend, Off
Return

sub_TempSuspend:
	Suspend, Toggle
	Debug("STATUS",A_LineNumber,A_LineFile,"Toggle Suspend")
	StringReplace, TempSuspendHK, A_ThisHotkey, $
	KeyWait, %TempSuspendHK%, T0.3
	If ErrorLevel = 1
	{
		SplashImage,,b1 cwFFFFc0 FS10, %lng_SuspendToolTip%
		susHold++
		KeyWait, %TempSuspendHK%
		susHold++
		SplashImage, Off
		Suspend, Off
	}
	Else If susHold =
	{
		SendEvent, % func_PrepareHotkeyForSend(A_ThisHotkey,"",1)
		Suspend, Off
		IfInString, A_ThisHotkey, numlock
			SendEvent, % func_PrepareHotkeyForSend(A_ThisHotkey,"",1)
	}
	Sleep,200
	susHold =
Return

; Alle Funktionen deaktivieren
sub_MenuSuspend:
	Suspend, Toggle
	Critical
	TemporaryMenuSuspend = 1
	Loop
	{
		If Extension[%A_Index%] =
			break
		Function := Extension[%A_Index%]
		If ( IsLabel("OnSuspend_" Function) )
		{
			Debug("STATUS", A_LineNumber, A_LineFile, "OnSuspend_" Function "...")
			Gosub, OnSuspend_%Function%
		}

		If A_IsSuspended = 1
		{
			If (IsLabel( "DoDisable_" Function))
			{
				Debug("EXTENSION", A_LineNumber, A_LineFile, "DoDisable_" Function "...")
				Gosub, DoDisable_%Function%
			}
		}
		Else If Enable_%Function% = 1
		{
			If (IsLabel( "DoEnable_" Function))
			{
				Debug("EXTENSION", A_LineNumber, A_LineFile, "DoEnable_" Function "...")
				Gosub, DoEnable_%Function%
			}
		}
	}
	TemporaryMenuSuspend = 0
	Gosub, sub_ChangeIcon
Return

sub_ChangeIcon:
	If LoadingFinished <> 1
		Return
	If A_IsSuspended <> 1
	{
		If (NoTrayIcon <> 1 AND CustomIcon <> 1)
			If A_IconFile <> %ScriptOnIcon%
				Menu, Tray, Icon, %ScriptOnIcon%, %ScriptOnIcon#%, 1
		Menu, Tray, UnCheck, % lng_deactivate "`t" func_HotkeyDecompose( Hotkey_DisableEnable, 1 )
		Loop, % TrayMenu - TrayMenuFirstExtension
		{
			Index := A_Index + TrayMenuFirstExtension
			If TrayMenuName[%Index%] =
				continue
			Menu, Tray, Enable, % TrayMenuName[%Index%]
		}
	}
	Else
	{
		If (NoTrayIcon <> 1 AND CustomIcon <> 1)
			If A_IconFile <> %ScriptOffIcon%
				Menu, Tray, Icon, %ScriptOffIcon%, %ScriptOffIcon#%, 1
		Menu, Tray, Check, % lng_deactivate "`t" func_HotkeyDecompose( Hotkey_DisableEnable, 1 )
		Loop, % TrayMenu - TrayMenuFirstExtension
		{
			Index := A_Index + TrayMenuFirstExtension
			If TrayMenuName[%Index%] =
				continue
			Menu, Tray, Disable, % TrayMenuName[%Index%]
		}
	}
Return

sub_temporarySuspend:
	If temporarySuspended = 1
	{
		If IsSuspended <> 1
		{
			Suspend, Off
			CallHook("OnResume")
			Debug("STATUS", A_LineNumber, A_LineFile, "Un-Suspended ac'tivAid" )
			If (NoTrayIcon <> 1 AND CustomIcon <> 1)
				Menu, Tray, Icon, %ScriptOnIcon%, %ScriptOnIcon#%, 1
		}
		temporarySuspended =
	}
	Else
	{
		IsSuspended = %A_IsSuspended%
		temporarySuspended = 1
		If IsSuspended <> 1
		{
			Suspend, On
			CallHook("OnSuspend")
			Debug("STATUS", A_LineNumber, A_LineFile, "Suspended ac'tivAid" )
			If (NoTrayIcon <> 1 AND CustomIcon <> 1)
				Menu, Tray, Icon, %ScriptOffIcon%, %ScriptOffIcon#%, 1
		}
	}
Return

activaidGuiContextMenu:
	If (GetKeyState("LButton") = 1 OR GuiContextMenu = "visible")
		Return
	Loop
	{
		If Extension[%A_Index%] =
			break
		Function := Extension[%A_Index%]
		If ( IsLabel("GuiContextMenu_" Function) )
		{
			GuiContextMenu = visible
			Gosub, GuiContextMenu_%Function%
			SetTimer, sub_GuiContextMenuUnVis, 20
			If GuiContextMenu = visible
			Return
		}
	}

	Prefix := ExtensionPrefix[%actFunct%]
	If %Prefix%_AdditionalSettings
	{
		GuiContextMenu = visible
		Gosub, sub_AdditionalSettingsMenu
		SetTimer, sub_GuiContextMenuUnVis, 20
	}
Return

sub_GuiContextMenuUnVis:
	SetTimer, sub_GuiContextMenuUnVis, Off
	GuiContextMenu =
Return

; Konfigurations-Dialog anzeigen
#include %A_ScriptDir%\internals\ac'tivAid_MainGUI.ahk

sub_MainGUI:
	sub_MainGUI()
return

sub_lc_SettingsChangedForce:
	gosub, sub_SettingsChangedForce
	gosub, sub_lc_proxyGUI
return

sub_lc_proxyGUI:
	GuiControlGet, lc_useGlobalHttpProxy_tmp,, lc_useGlobalHttpProxy
	GuiControl, Enable%lc_useGlobalHttpProxy_tmp%, lc_GlobalHttpProxyURL
	GuiControl, Enable%lc_useGlobalHttpProxy_tmp%, lc_GlobalHttpProxyType
	GuiControl, Enable%lc_useGlobalHttpProxy_tmp%, lc_GlobalHttpProxyUser
	GuiControl, Enable%lc_useGlobalHttpProxy_tmp%, lc_GlobalHttpProxyPass
	GuiControl, Enable%lc_useGlobalHttpProxy_tmp%, lc_GlobalHttpProxyPort

	GuiControlGet, lc_useGlobalFTPProxy_tmp,, lc_useGlobalFTPProxy
	GuiControl, Enable%lc_useGlobalFTPProxy_tmp%, lc_GlobalFTPProxyURL
	GuiControl, Enable%lc_useGlobalFTPProxy_tmp%, lc_GlobalFTPProxyType
	GuiControl, Enable%lc_useGlobalFTPProxy_tmp%, lc_GlobalFTPProxyUser
	GuiControl, Enable%lc_useGlobalFTPProxy_tmp%, lc_GlobalFTPProxyPass
	GuiControl, Enable%lc_useGlobalFTPProxy_tmp%, lc_GlobalFTPProxyPort

	GuiControlGet, lc_gui_httpProxy_tmp,, lc_gui_httpProxy
	GuiControl, Show%lc_gui_httpProxy_tmp%, lc_GlobalHttpProxyURL
	GuiControl, Show%lc_gui_httpProxy_tmp%, lc_GlobalHttpProxyType
	GuiControl, Show%lc_gui_httpProxy_tmp%, lc_GlobalHttpProxyUser
	GuiControl, Show%lc_gui_httpProxy_tmp%, lc_GlobalHttpProxyPass
	GuiControl, Show%lc_gui_httpProxy_tmp%, lc_GlobalHttpProxyPort
	GuiControl, Show%lc_gui_httpProxy_tmp%, lc_useGlobalHttpProxy
	GuiControl, Hide%lc_gui_httpProxy_tmp%, lc_GlobalFtpProxyURL
	GuiControl, Hide%lc_gui_httpProxy_tmp%, lc_GlobalFtpProxyType
	GuiControl, Hide%lc_gui_httpProxy_tmp%, lc_GlobalFtpProxyUser
	GuiControl, Hide%lc_gui_httpProxy_tmp%, lc_GlobalFtpProxyPass
	GuiControl, Hide%lc_gui_httpProxy_tmp%, lc_GlobalFtpProxyPort
	GuiControl, Hide%lc_gui_httpProxy_tmp%, lc_useGlobalFtpProxy

return

sub_CustomWorkingDirBrowse:
	Gui +OwnDialogs
	FileSelectFolder, CustomWorkingDirTmp, *%CustomWorkingDirTmp% , 3
	If CustomWorkingDirTmp <>
		GuiControl,,CustomWorkingDirTmp,% func_ReplaceWithCommonPathVariables(CustomWorkingDirTmp,"A_ScriptDir,")
Return

sub_CreateAllExtensionConfigs:
	Loop
	{
		Function := Extension[%A_Index%]
		If Function =
			Break

		If (InStr(ProcessedExtensions, "|" Function "|") )
			Return

		Prefix := ExtensionPrefix[%A_Index%]

		If (SimpleMainGUI <> "" AND Function <> SimpleMainGUI)
			Return

		CreateHotKeyList = 1
		Gosub, sub_CreateExtensionConfigGui
		CreateHotKeyList =
	}
Return

sub_CreateExtensionConfigGui:
	sub_CreateExtensionConfigGui()
return


sub_ReadmeSearchBack:
	IfInString, A_GuiControl, ContextHelp
	{
		GuiControlGet, searchTermContextHelp, %GuiID_HelpWindow%:
		func_SearchInControl( searchTermContextHelp, "Edit2", "A", 1)
	}
	IfInString, A_GuiControl, HotkeyList
	{
		GuiControlGet, searchTermHotkeyList, %GuiID_HotkeyList%:
		func_SearchInControl( searchTermHotkeyList, "Edit2", "A", 1)
	}
	Else IfInString, A_GuiControl, Readme
	{
		GuiControlGet, searchTermReadme
		func_SearchInControl( searchTermReadme, "Edit2", "A", 1)
	}
	IfInString, A_GuiControl, ChangeLog
	{
		GuiControlGet, searchTermChangeLog
		func_SearchInControl( searchTermChangeLog, "Edit4", "A", 1)
	}
Return

sub_ReadmeSearch:
	IfInString, A_GuiControl, ContextHelp
	{
		GuiControlGet, searchTermContextHelp, %GuiID_HelpWindow%:
		func_SearchInControl( searchTermContextHelp, "Edit2", "A", 0)
	}
	IfInString, A_GuiControl, HotkeyList
	{
		GuiControlGet, searchTermHotkeyList, %GuiID_HotkeyList%:
		func_SearchInControl( searchTermHotkeyList, "Edit2", "A", 0)
	}
	Else IfInString, A_GuiControl, Readme
	{
		GuiControlGet, searchTermReadme
		func_SearchInControl( searchTermReadme, "Edit2", "A", 0)
	}
	IfInString, A_GuiControl, ChangeLog
	{
		GuiControlGet, searchTermChangeLog
		func_SearchInControl( searchTermChangeLog, "Edit4", "A", 0)
	}
Return

sub_SearchInReadme:
	searchKey = %#wParam%
	searchSendAdd =

	searchTermTargetHwnd =

	GuiDefault("activAid")

	IfInString, A_GuiControl, searchTerm
	{
		StringReplace, searchTermTarget, A_GuiControl, searchTerm,,
		GuiControlGet, searchTermTargetHwnd, Hwnd, %searchTermTarget%
	}

	SetFormat, integer, hex
	searchKeyHex := searchKey+0
	SetFormat, integer, d

	GetKeyState, searchCtrlStateTmp, Ctrl
	If searchCtrlStateTmp = D
	{
		searchKey := searchKey + 1000
		searchSendAdd = %searchSendAdd%^
	}
	GetKeyState, searchShiftState, Shift
	If searchShiftState = D
	{
		searchKey := searchKey + 2000
		searchSendAdd = %searchSendAdd%+
		searchKeyChr := searchKeyChr - 32
	}
	GetKeyState, searchAltState, Alt
	If searchAltState = D
	{
		searchKey := searchKey + 4000
		searchSendAdd = %searchSendAdd%!
	}

;   tooltip, %A_EventInfo% %A_GuiControl%: %searchKey% %searchTermTargetHwnd%:%searchTermTarget%,,,2

	If (searchKey = 114 OR searchKey = 13)
		Gosub, sub_ReadmeSearch

	If (searchKey = 2114 OR searchKey = 2013)
		Gosub, sub_ReadmeSearchBack

	If (searchKey = 40 AND searchTermTargetHwnd <> "")
	{
		SendMessage, 0x115, 1, , , ahk_id %searchTermTargetHwnd% ; WM_VSCROLL (down)
		#Return = 0
	}
	If (searchKey = 38 AND searchTermTargetHwnd <> "")
	{
		SendMessage, 0x115, 0, , , ahk_id %searchTermTargetHwnd% ; WM_VSCROLL (up)
		#Return = 0
	}
	If (searchKey = 34 AND searchTermTargetHwnd <> "")
	{
		SendMessage, 0x115, 3, , , ahk_id %searchTermTargetHwnd% ; WM_VSCROLL (PgDown)
		#Return = 0
	}
	If (searchKey = 33 AND searchTermTargetHwnd <> "")
	{
		SendMessage, 0x115, 2, , , ahk_id %searchTermTargetHwnd% ; WM_VSCROLL (PgUp)
		#Return = 0
	}
	If (searchkey = 1067 AND A_GuiControl= "HotkeyList")
	{
		Clipboard = %HotkeyList%
		#Return = 0
	}
	If searchKey not in 33,34,35,36,37,38,39,40,1017,1065,2016,3016,3017,1033,1034,1035,1036,1037,1038,1039,1040,2033,2034,2035,2036,2037,2038,2039,2040,3033,3034,3035,3036,3037,3038,3039,3040
		If #Return <> 0
			If A_GuiControl in ContextHelp,HotkeyList,Readme,ChangeLog
			{
				GuiControl, Focus, searchTerm%A_GuiControl%
				If searchKey > 2000
					searchKey := searchkey-2000
				Else If searchKey > 64
					searchKey := searchkey+32
				Send, % Chr(searchKey)
				#Return = 0
			}

	If A_GuiControl = Readme
		Gosub, sub_DetectChapter

Return

tim_GuiFinished:
	MainGuiVisible = 2
Return

sub_BigIcon:
	Gui, +LastFound
	SendMessage, 0x80, 1, ScriptIconFromDll  ; 0x80 is WM_SETICON; and 1 means ICON_BIG (vs. 0 for ICON_SMALL).
Return

sub_BetaMode:
	Gosub, sub_CheckIfSettingsChanged
	GuiControlGet, BetatesterTmp,,Betatester
	If BetatesterTmp = 1
		GuiControl,,AutoUpdate,%lng_AutoCheckUpdtBeta%
	Else
		GuiControl,,AutoUpdate,%lng_AutoCheckUpdt%
Return

GuiTooltip:
	func_ShowGuiToolTip(A_GuiControl)
Return

GuiTooltipKey:
;   Gosub, RemoveGuiTooltip
	If ShowFocusToolTips = 0
		Return

	MouseGetPos,ttThisControlX,ttThisControlY,ttThisWin, ttThisControl
	GuiControlGet, ttFocusControlV, FocusV
	GuiControlGet, ttFocusControl, Focus
	ControlGetPos, ttFocusX, ttFocusY, ttFocusW, ttFocusH, %ttFocusControl%, A

	If ttFocusControl =
		Return

	ttFocusControlV := func_StrTranslate(ttFocusControlV, "=-+ §!&()'<>:,./\", "_______[]_[]_____")
	ttFocusControlV := func_StrClean(ttFocusControlV,"",0,"_")

	If (#wParam <> 0 AND #wParam <> 4 AND #wParam <> 8)
		If (func_StrLeft(ttFocusControlV,7)="Hotkey_" AND InStr(ttFocusControl,"Button"))
			ttFocusControlV = Hotkey_

	CoordMode, ToolTip, Relative

	If ( tooltip_%ttFocusControlV% = "")
	{
		Gosub, RemoveGuiTooltip
	}
	Else
	{
		SetTimer, tim_ShowGuiToolTip, Off
		thisTooltip := tooltip_%ttFocusControlV%
		tooltip, %thisTooltip%, % ttFocusX, % ttFocusY+ttFocusH, 9
		SetTimer, tim_ToolTipWatcher, 10
		SetTimer, tim_RemoveGuiToolTip, 20000
	}
	lastControl := ttFocusControl
	ttLastFocusControl := ttFocusControl
	ttLastControlX := ttThisControlX
	ttLastControlY := ttThisControlY
Return

RemoveGuiTooltip:
	SetTimer, tim_ShowGuiToolTip, Off
	SetTimer, tim_ToolTipWatcher, Off
	tooltip,,,,9
	lastControl =
	ttLastFocusControl =
	thisTooltip =
Return

func_ShowGuiToolTip(Control)
{
	global lastControl, thisTooltip, ttThisControl, ttLastControlX, ttLastControlY, ShowFocusToolTips, ttLastFocusControl

	MouseGetPos,ttThisControlX,ttThisControlY,ttThisWin, ttThisControl

	If (ttLastControlX = ttThisControlX AND ttLastControlY = ttThisControlY)
		Return

	control := func_StrTranslate(Control, "=-+ §!&()'<>:,./\", "_______[]_[]_____")
	control := func_StrClean(Control,"",0,"_")

	CoordMode, ToolTip, Screen
	If (func_StrLeft(Control,7)="Hotkey_" AND InStr(ttThisControl,"Button"))
		Control = Hotkey_

	If (tooltip_%Control% = "" )
	{
		Gosub, RemoveGuiTooltip
	}
	Else If (Control And ttThisControl)
	{
		If thisTooltip <>
			ToolTip,,,,9
		thisTooltip := tooltip_%Control%

		If ttThisControl <> %lastControl%
		{
			SetTimer, tim_ShowGuiToolTip, -600
			SetTimer, tim_RemoveGuiToolTip, 20000
			SetTimer, tim_ToolTipWatcher, 600
		}
		Else ; If ( ttLastControlX <> ttThisControlX OR ttLastControlY <> ttThisControlY )
		{
			Gosub, tim_RemoveGuiToolTip
		}
	}
	ttLastControlX := ttThisControlX
	ttLastControlY := ttThisControlY
}

tim_ShowGuiToolTip:
	tooltip, %thisTooltip% ,,,9
	lastControl := ttThisControl
Return

tim_RemoveGuiToolTip:
	Gosub, RemoveGuiTooltip
Return

tim_ToolTipWatcher:
	WinGetTitle, ttTitle, A
	If (ttTitle = "" OR !WinActive("ahk_class AutoHotkeyGUI") )
		Gosub, tim_RemoveGuiToolTip
Return

sub_CheckIfSettingsChanged_BackToList:
	Gosub, sub_CheckIfSettingsChanged
	GuiControl, Focus, OptionsListBox
Return

sub_SettingsChangedForce:
	If activeTab := lng_Hotkeys
		activeTab = activAid
	func_SettingsChanged(activeTab)
	Gosub, sub_EnableDisable_ApplyButton
Return

sub_CheckIfSettingsChanged:
	If (A_GuiControl = "" OR StrLen(A_GuiControl) < 3 OR MainGuiVisible <> 2 OR SkipChecking = 1 OR A_GuiControl="OptionsListBox" OR (BuildingGUI <> "" AND BuildingGUI = func_StrLeft(A_GuiControl,StrLen(BuildingGUI))))
		return

	Control := func_StrTranslate(A_GuiControl, "-+ §!&()'<>:,./\", "________________")

	If (activeTab = lng_Hotkeys)
		activeTab = activAid

	GuiControlGet, activeTab,,DlgTabs
	GuiControlGet, activeControlValue,,%A_GuiControl%
	StringReplace, ChangedSettings[%activeTab%], ChangedSettings[%activeTab%], %A_GuiControl%|,,A
	If Control <> %A_GuiControl%
	{
		If OnTab_%activeTab% =
			ChangedSettings[%activeTab%] := ChangedSettings[%activeTab%] A_GuiControl "|"
		Else
		{
			Loop, Parse, OnTab_%activeTab%, |
			{
				ChangedSettings[%A_LoopField%] := ChangedSettings[%A_LoopField%] A_GuiControl "|"
			}
			ChangedSettings[%activeTab%] := ChangedSettings[%activeTab%] A_GuiControl "|"
		}
		OnlyChangedWorkingDir =
	}
	Else If A_GuiControl <> %activeControlValue%
	{
		If OnTab_%activeTab% =
			ChangedSettings[%activeTab%] := ChangedSettings[%activeTab%] A_GuiControl "|"
		Else
		{
			Loop, Parse, OnTab_%activeTab%, |
			{
				ChangedSettings[%A_LoopField%] := ChangedSettings[%A_LoopField%] A_GuiControl "|"
			}
			ChangedSettings[%activeTab%] := ChangedSettings[%activeTab%] A_GuiControl "|"
		}
		OnlyChangedWorkingDir =
	}

	Gosub, sub_EnableDisable_ApplyButton
Return

func_SettingsChanged( Extension )
{
	Global
	If Extension = A_GuiControl
	{
		StringSplit, ExtensionPrefix, A_GuiControl, _
		Extension := %ExtensionPrefix1%_ScriptName
	}
	ChangedSettings[%Extension%] := ChangedSettings[%Extension%] Extension "|"
	Gosub, sub_EnableDisable_ApplyButton
	OnlyChangedWorkingDir =
}

sub_EnableDisable_ApplyButton:
	If OptionsListBoxClick = 1
		Return
	SettingsChanged = 0
	If ChangedSettings[activAid] <>
		SettingsChanged++
	Loop
	{
		tmpFunct := Extension[%A_Index%]
		If tmpFunct =
			break
		If ChangedSettings[%tmpFunct%] <>
		{
			SettingsChanged++
			Break
		}
	}

	If SettingsChanged > 0
	{
		GuiControl, %GuiID_activAid%:Enable, MainGuiApply
		Debug("GUI", A_LineNumber, A_LineFile, "Enabled Apply button" )
	}
	Else
	{
		GuiControl, %GuiID_activAid%:Disable, MainGuiApply
		Debug("GUI", A_LineNumber, A_LineFile, "Disabled Apply button" )
	}
Return

sub_Chapter:
;   tooltip, %A_GuiEvent% %A_EventInfo%
	Gui, %GuiID_activAid%:+LastFound
	GuiControlGet, ReadmeChapter
	SendMessage, 0x115, 6 , , Edit2 ; WM_VSCROLL (top)
	SendMessage, 0xB1, ReadmeGotoLine[%ReadmeChapter%], % ReadmeGotoLine[%ReadmeChapter%]+StrLen(ReadmeChapter[%ReadmeChapter%]), Edit2 ; EM_SETSEL
	SendMessage, 0xB7, , , Edit2 ; EM_SCROLLCARET
	SendMessage, 0xB6, , 24, Edit2 ; EM_LINESCROLL
Return

sub_DetectChapter:
	ReadmeChapter =
	ControlGet, searchCol, CurrentCol,,Edit2, A
	ControlGet, searchLine, CurrentLine,,Edit2, A
	searchCol--
	searchLine--
	SendMessage, 0xBB, searchLine, 0 , Edit2, A  ; EM_LINEINDEX
	searchEditIndex := Errorlevel + searchCol
	Loop
	{
		If ReadmeGotoLine[%A_Index%] =
			break
		ChapterIndex := A_Index + 1
		If (searchEditIndex >= ReadmeGotoLine[%A_Index%] AND searchEditIndex <= ReadmeGotoLine[%ChapterIndex%])
		{
			ReadmeChapter := A_Index
			break
		}
		ReadmeChapter := A_Index
		If searchEditIndex = 0
			break
	}
	GuiControl, Choose, ReadmeChapter, %ReadmeChapter%
Return

sub_DevCopyIndex:
	If (A_GuiControlEvent = "DoubleClick" AND _Debug = 1)
	{
		StringReplace, Clipboard, ReadmeDropDown, |, `r`n, A
	}
	tooltip, %A_GuiControlEvent%
Return


sub_ExtEnableDisable:
	GuiDefault("activAid")
	Gui, ListView, OptionsListBox
	StringReplace, Function, A_GuiControl, Enable_
	GuiControlGet, Enable_%Function%_tmp,,%A_GuiControl%
	If Enable_%Function%_tmp = 1
	{
		GuiControl,Enable, Info_%Function%

		If (ImageList[%Function%] <> "" AND _ShowIconsInOptionsListBox = 1)
		{
			hIcon := ExtractIcon(TrayIcon[%Function%], TrayIconPos[%Function%], 16)
			DllCall("ImageList_ReplaceIcon", "uint", InstalledExtension_ImageList, "int", ImageList[%Function%]-1, "uint", hIcon)
			DllCall("DestroyIcon", "uint", hIcon)
			LV_Modify(GuiTabs[%Function%],"Icon0")
			LV_Modify(GuiTabs[%Function%],"Icon" ImageList[%Function%])
		}
	}
	Else
	{
		GuiControl,Disable, Info_%Function%

		If (ImageList[%Function%] <> "" AND _ShowIconsInOptionsListBox = 1)
		{
			hIcon := ExtractIcon(TrayIconOff[%Function%], TrayIconOffPos[%Function%], 16)
			DllCall("ImageList_ReplaceIcon", "uint", InstalledExtension_ImageList, "int", ImageList[%Function%]-1, "uint", hIcon)
			DllCall("DestroyIcon", "uint", hIcon)
			LV_Modify(GuiTabs[%Function%],"Icon0")
			LV_Modify(GuiTabs[%Function%],"Icon" ImageList[%Function%])
		}
	}
	gosub, sub_CheckIfSettingsChanged
Return

sub_OptionsListCtrlTab:
	GuiDefault("activAid")
	GuiControl, +AltSubmit, DlgTabs
	GuiControlGet, DlgTab,,DlgTabs
	GuiControl, -AltSubmit, DlgTabs
	LV_Modify(DlgTab, "Select Focus")
	If GuiTabs[%DlgTab%] =
		Return
	Gosub, sub_OptionsListBox
Return

sub_OptionsListBoxClick:
	StringCaseSense, On
	GuiDefault("activAid")
	Gui, ListView, OptionsListBox
	OptionsListBoxClick =
;   If (A_GuiEvent = "K" OR (A_GuiEvent ="I" AND ErrorLevel = "f" AND GetKeyState("LButton","P")) OR A_GuiEvent = "Normal")
	If (A_EventInfo > 0 AND !(A_GuiEvent = "I" AND ErrorLevel = "f" AND !GetKeyState("LButton"))) ; OR (GetKeyState("LButton","P") AND A_EventInfo > 0) OR A_GuiEvent = "K")
	{
		OptionsListBoxClick = 1
		StringCaseSense, Off
		SetTimer, sub_OptionsListBox, -100, 1
	}
;   Else If ((A_GuiEvent ="D" AND !GetKeyState("LButton","P")) OR A_GuiEvent ="f" OR A_GuiEvent ="F")
	Else If (!GetKeyState("LButton") AND (A_EventInfo = 0 OR A_GuiEvent = "D" OR A_GuiEvent ="f" OR (A_GuiEvent="I" AND ErrorLevel="s")))
		LV_Modify(ListBox_Selected, "Select Focus")
	Else
		GuiControl, %GuiID_activAid%:Choose, DlgTabs, %ListBox_selected%

	If (A_GuiEvent = "K" AND A_EventInfo = 27 )
		SetTimer, activAidGuiEscape, -50

	OutputDebug, % A_GuiEvent ":" ErrorLevel ":LB" GetKeyState("LButton") ":" A_EventInfo
	Sleep,0
Return

sub_OptionsListBox:
	Thread,Priority,1
	GuiDefault("activAid")
	Gui, %GuiID_activAid%:+Disabled
	Gui, ListView, OptionsListBox
	If MainGuiVisible <>
	{
		ListBox_selected := LV_GetNext()
	}

	If SimpleMainGUI <>
		ListBox_selected = 1

	If GuiTabs[%ListBox_selected%] =
	{
		Gui, %GuiID_activAid%:-Disabled
		OptionsListBoxClick =
		Return
	}

	GuiControl, %GuiID_activAid%:Choose, DlgTabs, %ListBox_selected%

	Function := GuiTabs[%ListBox_selected%]
	ExtensionIndex := ExtensionIndex[%Function%]
	Prefix := ExtensionPrefix[%ExtensionIndex%]
	actFunct := Function

	If ExtensionGuiDrawn[%Function%] = 0
	{
		Gosub, sub_CreateExtensionConfigGui
	}

	GuiDefault("activAid")

	Gosub, sub_CreateAdditionalSettingsMenu

	SetTimer,tim_StoreSelection, -20

	If (ListBox_selected <> ListBox_selected_last OR OptionsListBoxClick = 1)
		GuiControl, %GuiID_activAid%:Focus, OptionsListBox

	ListBox_selected_last := ListBox_selected
	Sleep,0
	Gui, %GuiID_activAid%:-Disabled
Return

tim_StoreSelection:
	Debug("GUI", A_LineNumber, A_LineFile, "Updating GUI-Menu (" actFunct ")" )
	Gosub, sub_SettingsMenu
	IniWrite, %ListBox_selected%, %ConfigFile%, %ScriptName%, GUIselected
	BuildingGUI =
	OptionsListBoxClick =
Return

activAidGuiEscape:
activAidGuiClose:
	activAidGuiClose()
return

sub_SettingsOK:
	sub_SettingsOK()
return

sub_MenuExit:
	ExitApp
Return

ResetWindows_activAid:
	MainGuiX = RESET
	VarDumpGuiX = RESET
	ShowDuplicatesGuiX = RESET
	IniDelete, %ConfigFile%, %ScriptName%, MainGuiX
	IniDelete, %ConfigFile%, %ScriptName%, MainGuiY
	IniDelete, %ConfigFile%, %ScriptName%, VarDumpGuiX
	IniDelete, %ConfigFile%, %ScriptName%, VarDumpGuiY
	IniDelete, %ConfigFile%, %ScriptName%, ShowDuplicatesGuiX
	IniDelete, %ConfigFile%, %ScriptName%, ShowDuplicatesGuiY
Return

; INI-Datei verschönern
sub_BeautifyINI:
	func_BeautifyIniFile( ConfigFile )
Return

sub_CleanINI:
	MsgBox, 33, %lng_CleanINI%, %lng_CleanINIAsk%
	IfMsgBox, Cancel
		Return

	actLanguage =
	Loop
	{
		IniRead, FileToDelete%A_Index%, %ConfigFile%, DeleteAfterUpdate, DeleteFile%A_Index%
		If FileToDelete%A_Index% = ERROR
			break
	}
	FileMove, %ConfigFile%, %ConfigFile%.bak, 1
	func_SettingsChanged( "activAid" )
	IniWrite, %ExtensionsInExtDir%, %ConfigFile%, %ScriptName%, AvailableExtensions
	Loop
	{
		Function := Extension[%A_Index%]

		If Function =
			Break

		ExtensionIndex := ExtensionIndex[%Function%]
		Prefix := ExtensionPrefix[%ExtensionIndex%]

		If ExtensionGuiDrawn[%Function%] = 0
			Gosub, sub_CreateExtensionConfigGui

		IniRead, %Prefix%_LastUpdateNumber, %ConfigFile%.bak, %Function%, UpdateNumber
		If %Prefix%_LastUpdateNumber <> ERROR
			IniWrite, % %Prefix%_LastUpdateNumber, %ConfigFile%, %Function%, UpdateNumber
		func_SettingsChanged( Function )
	}
	Loop
	{
		If (FileToDelete%A_Index% = "ERROR" OR FileToDelete%A_Index% = "")
			break
		IniWrite, % FileToDelete%A_Index%, %ConfigFile%, DeleteAfterUpdate, DeleteFile%A_Index%
	}
	CleanINI = 1
	Gui, 1:Submit, NoHide
	Gosub, sub_SettingsOK
	CleanINI =
Return

sub_SettingsMenu:
	If AHKonUSB = 1
		AHKonUSBstr = USB

	If CreateUninstaller =
		Gosub, CreateUninstallFile

	If SettingsMenu <> 1
	{
		Menu, SettingsMenu_activAid, Add, %lng_SaveAllSettings%, sub_SaveAllSettings
		Menu, SettingsMenu_activAid, Add, %lng_LoadAllSettings%, sub_LoadAllSettings
		Menu, SettingsMenu_activAid, Add, %lng_RemoveUninstaller%, sub_AddRemoveUninstaller
		SettingsMenu_Uninstaller = %lng_RemoveUninstaller%

		Menu, SettingsMenu_activAid, Add
		Menu, SettingsMenu_activAid, Add, %lng_UserMode00%, sub_SingleOrMultiUser
		Menu, SettingsMenu_activAid, Add, %lng_OpenSettingsDir%, sub_OpenSettingsDir
		If (UsingUserDir = 1 AND MainDirNotWriteable <> 1 AND A_ScriptDir <> WorkingDir)
		{
			Menu, SettingsMenu_activAid, Add, % lng_Copy%AHKonUSBstr%SettingsToUser, sub_CopySettingsToUser
			Menu, SettingsMenu_activAid, Disable, % lng_Copy%AHKonUSBstr%SettingsToUser
			Menu, SettingsMenu_activAid, Add, % lng_Copy%AHKonUSBstr%SettingsToSingle, sub_CopySettingsToSingle
		}
		Else
		{
			Menu, SettingsMenu_activAid, Add, % lng_Copy%AHKonUSBstr%SettingsFromUser, sub_CopySettingsFromUser
			Menu, SettingsMenu_activAid, Disable, % lng_Copy%AHKonUSBstr%SettingsFromUser
		}

		Menu, SettingsMenu_activAid, Disable, %lng_UserMode00%
		SettingsMenu_UserMode = %lng_UserMode00%

		Menu, SettingsMenu_activAid, Add, %lng_CleanINI%, sub_CleanINI

		Menu, SettingsMenu_activAid, Add
		Menu, SettingsMenu_activAid, Add, %lng_RunAsAdmin%, sub_RunOrLeaveAdmin
		Menu, SettingsMenu_activAid, Disable, %lng_RunAsAdmin%
		SettingsMenu_Admin = %lng_RunAsAdmin%

		If _Debug = 1
		{
			Menu, SettingsMenu_activAid, Add
			Menu, AHKMenuBar, Standard
			Menu, SettingsMenu_activAid, Add, AutoHotkey, :AHKMenuBar
		}

		Menu, SettingsMenu_activAid, Add
		Menu, SettingsMenu_activAid, Add, %lng_Reload% , sub_MenuReload
		Menu, SettingsMenu_activAid, Add, %lng_exit% , sub_MenuExit

		Menu, AdditionalSettingsMenu, Add

		actFunct := " "
		Menu, SettingsMenu_Extension, Add, % #(lng_DefaultSettings,actFunct), sub_DefaultSettings
		Menu, SettingsMenu_Extension, Add, % #(lng_ResetWindows,actFunct), sub_ResetWindows
		If (!IsLabel("ResetWindows_" actFunct))
			Menu, SettingsMenu_Extension, Disable, % #(lng_ResetWindows,actFunct)
		Menu, SettingsMenu_Extension, Add
		Menu, SettingsMenu_Extension, Add, % #(lng_ExportSettings,actFunct), sub_ExportSettings
		Menu, SettingsMenu_Extension, Add, % #(lng_ImportSettings,actFunct), sub_ImportSettings
		Menu, SettingsMenu_Extension, Add
		Menu, SettingsMenu_Extension, Add, % #(lng_AddSettings,actFunct), sub_AddSettings
		Menu, SettingsMenu_Extension, Disable, % #(lng_AddSettings,actFunct)
		Menu, SettingsMenu_Extension, Add
		Menu, SettingsMenu_Extension, Add, %lng_EnableAll%, sub_EnableAll
		Menu, SettingsMenu_Extension, Add, %lng_DisableOthers%, sub_DisableOthers
		Menu, SettingsMenu_Extension, Add

		Menu, SettingsMenu_Extension, Add, % #(lng_RemoveFromGUI, actFunct), sub_RemoveExtFromGUI
		Menu, SettingsMenu_Extension, Add, %lng_RemovedExtensions%, :RemovedExtensions
		Menu, SettingsMenu_Extension, Add
		Menu, SettingsMenu_Extension, Add, %lng_AdditionalSettings%, :AdditionalSettingsMenu
		Menu, SettingsMenu_Extension, Disable, %lng_AdditionalSettings%

		Menu, AdditionalSettingsMenu, DeleteAll

		SettingsMenu_actFunct = %actFunct%

		Menu, SettingsMenu_Help, Add, % #(lng_ContextHelp,actFunct), sub_MenuContextHelp
		Menu, SettingsMenu_Help, Add,
		Menu, SettingsMenu_Help, Add, %lng_ShowHotkeyList%, sub_ShowHotkeyList
		Menu, SettingsMenu_Help, Add,
		Menu, SettingsMenu_Help, Add, FAQ (www.heise.de), sub_CallFAQ
		Menu, SettingsMenu_Help, Add, %lng_activAidHomepage%, sub_CallHomePage
		Menu, SettingsMenu_Help, Add, %lng_Bugtracker%, sub_CallBugtracker
		Menu, SettingsMenu_Help, Add, %lng_Contact%, sub_CallContact
		Menu, SettingsMenu_Help, Add,
		Menu, SettingsMenu_Help, Add, %lng_Statistics% ..., sub_Statistics
		Menu, SettingsMenu_Help, Add, %lng_VarDump% ..., sub_VarDumpGUI
		Menu, SettingsMenu_Help, Add,
		Menu, SettingsMenu_Help, Add, %lng_About%, sub_About

		If _Devel = 1
		{
			Menu, Devel_Menu, Add, Simulate Update, sub_SimulateUpdate
		}
	}
	Else
	{
		If (UsingUserDir = 1 AND MainDirNotWriteable <> 1)
		{
			Menu, SettingsMenu_activAid, Enable, %SettingsMenu_UserMode%

			If AHKonUSB = 1
			{
				If SettingsMenu_UserMode <> %lng_UserMode001%
					Menu, SettingsMenu_activAid, Rename, %SettingsMenu_UserMode%, %lng_UserMode001%
				SettingsMenu_UserMode = %lng_UserMode001%
			}
			Else
			{
				If SettingsMenu_UserMode <> %lng_UserMode00%
					Menu, SettingsMenu_activAid, Rename, %SettingsMenu_UserMode%, %lng_UserMode00%
				SettingsMenu_UserMode = %lng_UserMode00%
			}
		}
		Else
		{
			If (MainDirNotWriteable <> 1)
				Menu, SettingsMenu_activAid, Enable, %SettingsMenu_UserMode%
			Else
				Menu, SettingsMenu_activAid, Disable, %SettingsMenu_UserMode%

			If AHKonUSB = 1
			{
				If SettingsMenu_UserMode <> %lng_UserMode011%
					Menu, SettingsMenu_activAid, Rename, %SettingsMenu_UserMode%, %lng_UserMode011%
				SettingsMenu_UserMode = %lng_UserMode011%
			}
			Else
			{
				If SettingsMenu_UserMode <> %lng_UserMode01%
					Menu, SettingsMenu_activAid, Rename, %SettingsMenu_UserMode%, %lng_UserMode01%
				SettingsMenu_UserMode = %lng_UserMode01%
			}
		}
		If (UsingUserDir = 1 AND MainDirNotWriteable <> 1 AND A_ScriptDir <> WorkingDir)
		{
			Menu, SettingsMenu_activAid, Enable, % lng_Copy%AHKonUSBstr%SettingsToUser
		}
		Else
		{
			If MainDirNotWriteable <> 1
				Menu, SettingsMenu_activAid, Enable, % lng_Copy%AHKonUSBstr%SettingsFromUser
			Else
				Menu, SettingsMenu_activAid, Disable, % lng_Copy%AHKonUSBstr%SettingsFromUser
		}

		If A_IsAdmin <> 1
		{
			Menu, SettingsMenu_activAid, Enable, %SettingsMenu_Admin%
			If SettingsMenu_Admin <> %lng_RunAsAdmin%
				Menu, SettingsMenu_activAid, Rename, %SettingsMenu_Admin%, %lng_RunAsAdmin%
			SettingsMenu_Admin = %lng_RunAsAdmin%
		}
		Else
		{
			If ( tempAdminMode > 0 )
				Menu, SettingsMenu_activAid, Enable, %SettingsMenu_Admin%
			Else
				Menu, SettingsMenu_activAid, Disable, %SettingsMenu_Admin%

			If SettingsMenu_Admin <> %lng_LeaveAdmin%
				Menu, SettingsMenu_activAid, Rename, %SettingsMenu_Admin%, %lng_LeaveAdmin%
			SettingsMenu_Admin = %lng_LeaveAdmin%
		}

		actFunct := GuiTabs[%ListBox_selected%]
		If ListBox_selected = 5
			actFunct := GuiTabs[4]

		If actFunct <> %SettingsMenu_actFunct%
		{
			Menu, SettingsMenu_Extension, Rename, % #(lng_DefaultSettings,SettingsMenu_actFunct), % #(lng_DefaultSettings,actFunct)
			Menu, SettingsMenu_Extension, Rename, % #(lng_ResetWindows,SettingsMenu_actFunct), % #(lng_ResetWindows,actFunct)
			Menu, SettingsMenu_Extension, Rename, % #(lng_ExportSettings,SettingsMenu_actFunct), % #(lng_ExportSettings,actFunct)
			Menu, SettingsMenu_Extension, Rename, % #(lng_ImportSettings,SettingsMenu_actFunct), % #(lng_ImportSettings,actFunct)
			Menu, SettingsMenu_Extension, Rename, % #(lng_AddSettings,SettingsMenu_actFunct), % #(lng_AddSettings,actFunct)
			Menu, SettingsMenu_Extension, Rename, % #(lng_RemoveFromGUI,SettingsMenu_actFunct), % #(lng_RemoveFromGUI,actFunct)
			Menu, SettingsMenu_Help, Rename, % #(lng_ContextHelp,SettingsMenu_actFunct), % #(lng_ContextHelp,actFunct)
		}
		If AddSettings_%actFunct% = 1
			Menu, SettingsMenu_Extension, Enable, % #(lng_AddSettings,actFunct)
		Else
			Menu, SettingsMenu_Extension, Disable, % #(lng_AddSettings,actFunct)

		If (IsLabel("ResetWindows_" actFunct))
			Menu, SettingsMenu_Extension, Enable, % #(lng_ResetWindows,actFunct)
		Else
			Menu, SettingsMenu_Extension, Disable, % #(lng_ResetWindows,actFunct)

		If (Enable_%actFunct% <> "" OR actFunct = "activAid" )
		{
			Menu, SettingsMenu_Extension, Enable, % #(lng_DefaultSettings,actFunct)
			Menu, SettingsMenu_Extension, Enable, % #(lng_ExportSettings,actFunct)
			Menu, SettingsMenu_Extension, Enable, % #(lng_ImportSettings,actFunct)
			Menu, SettingsMenu_Extension, Enable, % #(lng_RemoveFromGUI,actFunct)
			;Menu, MenuBar, Enable, &%lng_Extension%
			Menu, SettingsMenu_Help, Enable, % #(lng_ContextHelp,actFunct)
		}
		Else
		{
			Menu, SettingsMenu_Extension, Disable, % #(lng_DefaultSettings,actFunct)
			Menu, SettingsMenu_Extension, Disable, % #(lng_ExportSettings,actFunct)
			Menu, SettingsMenu_Extension, Disable, % #(lng_ImportSettings,actFunct)
			Menu, SettingsMenu_Extension, Disable, % #(lng_AddSettings,actFunct)
			Menu, SettingsMenu_Extension, Disable, % #(lng_RemoveFromGUI,actFunct)
			;Menu, MenuBar, Disable, &%lng_Extension%
			Menu, SettingsMenu_Help, Disable, % #(lng_ContextHelp,actFunct)
		}

		SettingsMenu_actFunct = %actFunct%
		If (CreateUninstaller = 1 AND Settingsmenu_Uninstaller <> lng_RemoveUninstaller)
		{
			Menu, SettingsMenu_activAid, Rename, %Settingsmenu_Uninstaller%, %lng_RemoveUninstaller%
			Settingsmenu_Uninstaller = %lng_RemoveUninstaller%
		}
		Else If (CreateUninstaller <> 1 AND Settingsmenu_Uninstaller <> lng_AddUninstaller)
		{
			Menu, SettingsMenu_activAid, Rename, %Settingsmenu_Uninstaller%, %lng_AddUninstaller%
			Settingsmenu_Uninstaller = %lng_AddUninstaller%
		}
		If AHKonUSB = 1
			Menu, SettingsMenu_activAid, Disable, %Settingsmenu_Uninstaller%

		tmpPrefix := ExtensionPrefix[%actFunct%]
		If %tmpPrefix%_AdditionalSettings
		{
			SeparateMenuName =
			Gosub, sub_CreateAdditionalSettingsMenu
			Menu, SettingsMenu_Extension, Add, %lng_AdditionalSettings%, :AdditionalSettingsMenu
		}
		Else
		{
			Menu, SettingsMenu_Extension, Disable, %lng_AdditionalSettings%
		}
		NumEnabledExtensions = 0
		ExtensionsCount = 0
		Loop
		{
			Function := Extension[%A_Index%]
			If Function =
				Break
			If OnlyForConfigDialog_%Function% <> 1
			{
				ExtensionsCount++
				GuiControlGet, EnableFunction,, Enable_%Function%
				If ( EnableFunction OR ( EnableFunction = "" AND Enable_%Function% = 1) )
					NumEnabledExtensions++
			}
		}
		If (NumEnabledExtensions = 1 AND Enable_%actFunct% = 1)
			Menu, SettingsMenu_Extension, Disable, %lng_DisableOthers%
		Else
			Menu, SettingsMenu_Extension, Enable, %lng_DisableOthers%
		If (NumEnabledExtensions = ExtensionsCount)
			Menu, SettingsMenu_Extension, Disable, %lng_EnableAll%
		Else
			Menu, SettingsMenu_Extension, Enable, %lng_EnableAll%
	}
	SettingsMenu = 1
Return

sub_DisableOthers:
	GuiDefault("activAid")
	Loop
	{
		Function := Extension[%A_Index%]
		If Function =
			Break
		If Function = %actFunct%
			continue

		ExtensionIndex := ExtensionIndex[%Function%]
		Prefix := ExtensionPrefix[%ExtensionIndex%]

		If ExtensionGuiDrawn[%Function%] = 0
		{
			Gosub, sub_CreateExtensionConfigGui
			GuiControl, %GuiID_activAid%:Choose, DlgTabs, % GuiTabs[%Function%]
			Gui, ListView, OptionsListBox
			ListBox_selected := LV_GetNext()
		}

		GuiControl, , Enable_%Function%, 0
		GuiControl, Enable , Info_%Function%

		If (ImageList[%Function%] <> "" AND _ShowIconsInOptionsListBox = 1)
		{
			hIcon := ExtractIcon(TrayIconOff[%Function%], TrayIconOffPos[%Function%], 16)
			DllCall("ImageList_ReplaceIcon", "uint", InstalledExtension_ImageList, "int", ImageList[%Function%]-1, "uint", hIcon)
			DllCall("DestroyIcon", "uint", hIcon)
			LV_Modify(GuiTabs[%Function%],"Icon0")
			LV_Modify(GuiTabs[%Function%],"Icon" ImageList[%Function%])
		}

		func_SettingsChanged(Function)
	}
	GuiControl, , Enable_%actFunct%, 1
	GuiControl, Enable , Info_%actFunct%
	Menu, SettingsMenu_Extension, Disable, %lng_DisableOthers%
	Menu, SettingsMenu_Extension, Enable, %lng_EnableAll%
Return

sub_EnableAll:
	GuiDefault("activAid")
	Loop
	{
		Function := Extension[%A_Index%]
		If Function =
			Break

		ExtensionIndex := ExtensionIndex[%Function%]
		Prefix := ExtensionPrefix[%ExtensionIndex%]

		If ExtensionGuiDrawn[%Function%] <> 1
		{
			Gosub, sub_CreateExtensionConfigGui
			GuiControl, %GuiID_activAid%:Choose, DlgTabs, % GuiTabs[%Function%]
			Gui, ListView, OptionsListBox
			ListBox_selected := LV_GetNext()
		}

		GuiControl, Enable , Info_%Function%
		GuiControl, , Enable_%Function%, 1

		If (ImageList[%Function%] <> "" AND _ShowIconsInOptionsListBox = 1)
		{
			hIcon := ExtractIcon(TrayIcon[%Function%], TrayIconPos[%Function%], 16)
			DllCall("ImageList_ReplaceIcon", "uint", InstalledExtension_ImageList, "int", ImageList[%Function%]-1, "uint", hIcon)
			DllCall("DestroyIcon", "uint", hIcon)
			LV_Modify(GuiTabs[%Function%],"Icon0")
			LV_Modify(GuiTabs[%Function%],"Icon" ImageList[%Function%])
		}

		func_SettingsChanged(Function)
	}
	Menu, SettingsMenu_Extension, Disable, %lng_EnableAll%
	Menu, SettingsMenu_Extension, Enable, %lng_DisableOthers%
Return

sub_RemoveExtFromGUI:
	If SettingsChanged > 0
		Msgbox, 52, %ScriptTitle%, %lng_SettingsNotApplied%
			IfMsgBox, No
				Return
	IniWrite, 1, %ConfigFile%, %ScriptName%, HideInGui_%actFunct%
	Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
	Gosub, Reload
Return

sub_RestoreExtToGUI:
	If SettingsChanged > 0
		Msgbox, 52, %ScriptTitle%, %lng_SettingsNotApplied%
			IfMsgBox, No
				Return
	IniWrite, 0, %ConfigFile%, %ScriptName%, HideInGui_%A_ThisMenuItem%
	Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
	Gosub, Reload
Return

sub_AddRemoveUninstaller:
	Error = 0
	Gui %GuiID_activAid%:+Disabled
	Gui %GuiID_activAid%:+OwnDialogs
	If CreateUninstaller = 1
	{
		FileRemoveDir, %A_Programs%\ac'tivAid, 1
		IfExist,  %A_Programs%\ac'tivAid
			Error++
		RegDelete, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid
		If ErrorLevel
			Error++
		If Error = 0
		{
			CreateUninstaller = 0
			IniWrite, %CreateUninstaller%, %ConfigFile%, %ScriptName%, CreateUninstaller
			MsgBox, 64, %ScriptTitle%, %lng_RemoveUninstallerSuccess%
		}
		Else
			MsgBox, 48, %ScriptTitle%, %lng_RemoveUninstallerFailure%
	}
	Else
	{
		CreateUninstaller = 2
		Gosub, CreateUninstallFile
		IfNotExist,  %A_Programs%\ac'tivAid
			Error++
		If Error = 0
		{
			CreateUninstaller = 1
			IniWrite, %CreateUninstaller%, %ConfigFile%, %ScriptName%, CreateUninstaller
			MsgBox, 64, %ScriptTitle%, %lng_AddUninstallerSuccess%
		}
		Else
			MsgBox, 48, %ScriptTitle%, %lng_AddUninstallerFailure%
	}
	Debug("GUI", A_LineNumber, A_LineFile, "Updating GUI-Menu" )
	Gosub, sub_SettingsMenu
	Gui, %GuiID_activAid%:-Disabled
Return

sub_SingleOrMultiUser:
	If (UsingUserDir = 1 AND MainDirNotWriteable <> 1)
		Gosub, sub_SingleUser
	Else If (MainDirNotWriteable <> 1)
		Gosub, sub_MultiUser
Return

sub_RunOrLeaveAdmin:
	If main_IsAdmin <> 1
		Gosub, sub_RunAsAdmin
	Else If ( tempAdminMode = 1 )
		Gosub, sub_LeaveAdmin
Return

sub_CallHomePage:
	Run, http://www.heise.de/ct/activaid
Return

sub_CallFAQ:
	Run, http://www.heise.de/software/download/special/activaid_forte/10_11
;   GuiControl, Choose, DlgTabs, 1
;   GuiControl, Choose, OptionsListBox, 1
;   Gui, %GuiID_activAid%:+LastFound
;   SendMessage, 0x115, 6 , , Edit2 ; WM_VSCROLL (top)
;   SendMessage, 0xB1, ReadmeGotoLine[%ReadIndex%], % ReadmeGotoLine[%ReadIndex%]+StrLen(ReadmeChapter[%ReadIndex%]), Edit2 ; EM_SETSEL
;   SendMessage, 0xB7, , , Edit2 ; EM_SCROLLCARET
;   SendMessage, 0xB6, , 24, Edit2 ; EM_LINESCROLL
Return

sub_CallBugtracker:
	Run, http://activaid.rumborak.de
Return

sub_CallContact:
	Run, mailto:"ac'tivAid" <activaid@heise.de>
Return

sub_About:
	Gui %GuiID_About%:+LastFoundExist
	IfWinNotExist
	{
		gui, %GuiID_About%:+Owner%GuiID_activAid%
		gui, %GuiID_About%:+AlwaysOnTop +ToolWindow
		gui, %GuiID_About%:color, FFFFFF
		gui, %GuiID_About%:add, picture, icon, %ScriptIcon%
		gui, %GuiID_About%:font, bold
		gui, %GuiID_About%:add, text, x+5 yp+0, Version:
		gui, %GuiID_About%:font, norm
		gui, %GuiID_About%:add, text, xp+5 y+3,%ScriptNameFull% %ScriptVersion%
		gui, %GuiID_About%:font, bold
		gui, %GuiID_About%:add, text, xs+0, %lng_about_main_developer%
		gui, %GuiID_About%:font, norm
		gui, %GuiID_About%:add, text, xs+0, %lng_about_main_developer_list%
		gui, %GuiID_About%:font, bold
		gui, %GuiID_About%:add, text, xs+0, %lng_about_ext_developer%
		gui, %GuiID_About%:font, norm
		gui, %GuiID_About%:add, text, xs+0, %lng_about_ext_developer_list%
	}
	gui, %GuiID_About%:show, Center AutoSize, %lng_About%
Return
9guiescape:
9guiclose:
	gui, %GuiID_About%:destroy
Return

sub_OpenSettingsDir:
	Run, .\settings
Return

sub_OpenActivaidDir:
	If A_GuiControlEvent = DoubleClick
	{
		If A_EventInfo = 1
			Run, .
	}
Return

sub_RunAsAdmin:
	Critical
	Suspend, On
	Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
	If A_IsCompiled = 1
		Run, %A_ScriptDir%\extensions\RunWithAdminRights.exe %RunWithAdminRightsPara% %A_Args%
	Else
		Run, %A_AhkPath% /f "%A_ScriptDir%\extensions\RunWithAdminRights.ahk" %RunWithAdminRightsPara% %A_Args%
	ExitApp
Return

sub_LeaveAdmin:
	Critical
	DetectHiddenWindows, On
	StringReplace, A_Args, A_Args, LeaveAdmin
	If A_IsCompiled = 1
		SendMessage, 0x1ccc, 99, 99,,%A_ScriptDir%\extensions\RunWithAdminRights.exe
	Else
		SendMessage, 0x1ccc, 99, 99,,%A_ScriptDir%\extensions\RunWithAdminRights.ahk - AutoHotkey v%A_Ahkversion%
	If ErrorLevel
		MsgBox, 64, %ScriptName%, %lng_LeaveAdminCantReload%
	ExitApp
Return

sub_MultiUser:
	Critical
	UsingUserDir = 1
	Gosub, sub_MenuAutostart
	IfNotExist, %activAidData%
		FileCreateDir, %activAidData%
	If MultiUser <> 2
	{
		IniWrite, %ListBox_selected%, %activAidData%\%ConfigFile%, %ScriptName%, GUIselected
		IniWrite, 1, %activAidData%\%ConfigFile%, %ScriptName%, ShowGUI
	}
	IniWrite, 1, %activAidGlobalData%\%ConfigFile%, %ScriptName%, MultiUser
	Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
	Debug("VAR",A_LineNumber,A_LineFile,"activAidData,UsingUserDir")
	NewWorkingDir = %activAidData%
	CustomWorkingDir = %activAidData%
	Gosub, Reload
;   If A_IsCompiled = 1
;      Run, %A_ScriptFullPath% %A_Args%, %activAidData%
;   Else
;      Run, %A_AhkPath% /r "%A_ScriptFullPath%" %A_Args%, %activAidData%
Return

sub_MainContextMenuMainContext:
	MI_ShowMenu(hTM)
Return

sub_SingleUser:
	Critical
	UsingUserDir = 0
	Gosub, sub_MenuAutostart
	IniDelete, %activAidGlobalData%\%ConfigFile%, %ScriptName%, MultiUser
	IniWrite, %ListBox_selected%, %activAidGlobalData%\%ConfigFile%, %ScriptName%, GUIselected
	IniWrite, 1, %activAidGlobalData%\%ConfigFile%, %ScriptName%, ShowGUI
	Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
	Debug("VAR",A_LineNumber,A_LineFile,"LastWorkingDir,UsingUserDir")
	NewWorkingDir = %LastWorkingDir%
	CustomWorkingDir = %LastWorkingDir%
	Gosub, Reload
;   If A_IsCompiled = 1
;      Run, %A_ScriptFullPath% %A_Args%, %LastWorkingDir%
;   Else
;      Run, %A_AhkPath% /r "%A_ScriptFullPath%" %A_Args% ,%LastWorkingDir%
;   ExitApp
Return

sub_ShowMainContextMenu:
	DontShowMainGUI = 1
	CreateHotKeyList = 1
	If HotkeyListCreated <> 1
	{
		GuiDefault("activAid")
		Loop
		{
			Function := Extension[%A_Index%]
			If Function =
				Break

			Prefix := ExtensionPrefix[%A_Index%]

			CreateHotKeyList = 1
			Gosub, sub_CreateExtensionConfigGui
			CreateHotKeyList =
		}
		HotkeyListCreated = 1
		SkipChecking =
		If MainGuiVisible =
		{
			Gui, %GuiID_activAid%:Destroy
			Hotkey_DupDuplicates =
			Hotkey_AllNewHotkeys =
			mainGuiID =
			Loop
			{
				Function := Extension[%A_Index%]
				ExtensionGuiDrawn[%Function%] =
				If Function =
					Break
				ChangedSettings[%Function%] =
			}
		}
	}
	DontShowMainGUI =
	func_AutoVSplitMenu("MainContextMenu")
	WinGet, WinIDbeforeContextMenu, ID, A
	Menu, MainContextMenu, Show
	Gosub, sub_RestoreKeyStates
Return

sub_MainContextMenuKeyHistory:
	Keyhistory
Return

sub_MainContextMenuListHotkeys:
	Listhotkeys
Return

sub_MainContextMenuListLines:
	Listlines
Return

sub_MainContextMenuListVars:
	ListVars
Return

sub_MainContextMenuWindowSpy:
	Run, %A_AutoHotkeyPath%\AU3_Spy.exe,,UseErrorLevel
	If ErrorLevel = ERROR
		func_GetErrorMessage( A_LastError, ScriptTitle, A_Quote A_AutoHotkeyPath "\AU3_Spy.exe" A_Quote "`n`n" )
Return

#include %A_ScriptDir%\internals\ac'tivAid_settings.ahk
#include %A_ScriptDir%\internals\ac'tivAid_ExtensionsManager.ahk

; Prüfen, ob NiftyWindows läuft und dieses Skript ggf. mit doppeltem Suspend *vor* Nifty setzen
tim_CheckForNifty:
	DetectHiddenWindows, On
	IfWinExist,NiftyWindows,,.zip
	{
		if niftyWindows <> on
		{
			Suspend, Toggle
			Suspend, Toggle
			niftyWindows = on
		}
	}
	Else IfWinExist,NiftyWindows.ahk,,.zip,NiftyWindows.ini
	{
		if niftyWindows <> on
		{
			Suspend, Toggle
			Suspend, Toggle
			niftyWindows = on
		}
	}
	Else
		NiftyWindows =

	DetectHiddenWindows, Off

	IfWinExist,,NiftyWindows is resumed now.
	{
		WinGetClass, NiftyClass, A
		If ( NiftyClass = "tooltips_class32" AND NiftyTip <> "on" )
		{
			Suspend, Toggle
			Suspend, Toggle
			niftyWindows = on
			NiftyTip = on
		}
	}
	Else
		NiftyTip =
Return

; Unterroutine vom ProblemSolver, welche die Tasten prüft und zurücksetzt
sub_RestoreKeyStates:
	ProbSolvMessage =

	Suspend, Toggle
	Suspend, Toggle

	GetKeyState,stateL,LButton
	GetKeyState,stateP,LButton, P
	if (stateL <> stateP)
	{
		Send,{LButton Up}
		ProbSolvMessage = %ProbSolvMessage%%lng_Left% %lng_MouseButton%-%lng_Key%`n
	}

	GetKeyState,stateL,RButton
	GetKeyState,stateP,RButton, P
	if (stateL <> stateP)
	{
		Send,{RButton Up}
		ProbSolvMessage = %ProbSolvMessage%%lng_Right% %lng_MouseButton%-%lng_Key%`n
	}

	GetKeyState,stateL,MButton
	GetKeyState,stateP,MButton, P
	if (stateL <> stateP)
	{
		Send,{MButton Up}
		ProbSolvMessage = %ProbSolvMessage%%lng_Middle% %lng_MouseButton%-%lng_Key%`n
	}

	If LoadingFinished = 1
	{
		GetKeyState,stateL,LWin
		GetKeyState,stateP,LWin, P
		if (stateL <> stateP)
		{
			Send,{LWin Up}
			ProbSolvMessage = %ProbSolvMessage%%lng_Left% %lng_KbWin%-%lng_Key%`n
		}

		GetKeyState,stateL,RWin
		GetKeyState,stateP,RWin, P
		if (stateL <> stateP)
		{
			Send,{RWin Up}
			ProbSolvMessage = %ProbSolvMessage%%lng_Right% %lng_KbWin%-%lng_Key%`n
		}

		GetKeyState,stateL,LAlt
		GetKeyState,stateP,LAlt, P
		if (stateL <> stateP)
		{
			Send,{LAlt Up}
			ProbSolvMessage = %ProbSolvMessage%%lng_Left% %lng_KbAlt%-%lng_Key%`n
		}

		GetKeyState,stateL,RAlt
		GetKeyState,stateP,RAlt, P
		if (stateL <> stateP)
		{
			Send,{RAlt Up}
			ProbSolvMessage = %ProbSolvMessage%%lng_Right% %lng_KbAlt%-%lng_Key%`n
		}

		GetKeyState,stateL,LCtrl
		GetKeyState,stateP,LCtrl, P
		if (stateL <> stateP)
		{
			Send,{LCtrl Up}
			ProbSolvMessage = %ProbSolvMessage%%lng_Left% %lng_KbCtrl%-%lng_Key%`n
		}

		GetKeyState,stateL,RCtrl
		GetKeyState,stateP,RCtrl, P
		if (stateL <> stateP)
		{
			Send,{RCtrl Up}
			ProbSolvMessage = %ProbSolvMessage%%lng_Right% %lng_KbCtrl%-%lng_Key%`n
		}

		GetKeyState,stateL,LShift
		GetKeyState,stateP,LShift, P
		if (stateL <> stateP)
		{
			Send,{LShift Up}
			ProbSolvMessage = %ProbSolvMessage%%lng_Left% %lng_KbShift%-%lng_Key%`n
		}

		GetKeyState,stateL,RShift
		GetKeyState,stateP,RShift, P
		if (stateL <> stateP)
		{
			Send,{RShift Up}
			ProbSolvMessage = %ProbSolvMessage%%lng_Right% %lng_KbShift%-%lng_Key%`n
		}
	}
Return

; Nach Updates im Internet suchen
sub_getUpdates:
	If MainGUiVisible <>
	{
		Gosub, sub_EnableDisable_ApplyButton
		If (SettingsChanged > 0 AND OnlyChangedWorkingDir = "")
		{
			MsgBox, 48, %ScriptTitle%, %lng_PleaseApplySettings%
			SimulateUpdate = 0
			StringReplace, A_Args, A_Args, SimulateUpdate,
			Return
		}
	}

	Gosub, sub_temporarySuspend
	Sleep,100

	If ( AutoUpdate <> 1 AND _SilentUpdate <> 1 )
	{
		If MainGuiVisible <>
			Gui, %GuiID_activAid%:+OwnDialogs
		MsgBox, 36, %ScriptTitle% - %lng_update%, %lng_AskUpdate%
		IfMsgBox, No
		{
			Gosub, sub_temporarySuspend
			SimulateUpdate = 0
			StringReplace, A_Args, A_Args, SimulateUpdate,
			Return
		}
	}

	GuiControl, Disable, %lng_Update%
	If func_CheckIfOnline()
		URLDownloadToFile,%UpdateURL%?dl=%ScriptVersion%, versions.ini

	If ( ErrorLevel = 1 OR func_CheckIfOnline() = 0)
	{
		MsgBox, 16, %ScriptTitle% - %lng_update%, %lng_UpdateError%
		Gosub, sub_temporarySuspend
		GuiControl, Enable, %lng_Update%
		SimulateUpdate = 0
		StringReplace, A_Args, A_Args, SimulateUpdate,
		Return
	}

	IniRead, newScriptVersion, versions.ini, activAid, version

	If ExeDistribution = 1
	{
		IniRead, newScriptURL, versions.ini, activAid_NoUnzip, exeurl
		IniRead, newScriptSize, versions.ini, activAid_NoUnzip, exesize
		newAHKVersion = %A_AHKversion%
	}
	Else
	{
		IniRead, newScriptURL, versions.ini, activAid_NoUnzip, url
		IniRead, newScriptSize, versions.ini, activAid_NoUnzip, size
		IniRead, newAHKVersion, versions.ini, activAid, AHKversion, %A_AHKversion%
	}

	IniRead, newScriptExtension, versions.ini, activAid, Extensions
	IniRead, newScriptHideUpdate, versions.ini, activAid, hideupdate, 0
	FileDelete, versions.ini

	If newScriptVersion = ERROR
	{
		MsgBox, 16, %ScriptTitle% - %lng_Update%, %lng_UpdateError%
		Gosub, sub_temporarySuspend
		GuiControl, Enable, %lng_Update%
		SimulateUpdate = 0
		StringReplace, A_Args, A_Args, SimulateUpdate,
		Return
	}

	If ( (func_getNormalizedVersionNumber(newScriptVersion) > func_getNormalizedVersionNumber(ScriptVersion) OR SimulateUpdate = 1) AND newScriptHideUpdate = 0 )
	{
		Gosub, sub_NewVersion
	}
	Else
	{
		If newScriptHideUpdate = 1
			newScriptVersion = %ScriptVersion%

		MsgBox, 64, %ScriptTitle% - %lng_Update%, %lng_NeedNoUpdate% (Online: %newScriptVersion%)
		SimulateUpdate = 0
		StringReplace, A_Args, A_Args, SimulateUpdate,
	}
	GuiControl, Enable, %lng_Update%
	Gosub, sub_temporarySuspend
Return


sub_getManualUpdates:
	Gui, %GuiID_activAid%:+Disabled
	GuiDefault("ManualUpdate", "+Owner" GuiID_activAid)
	Gui, Add, Text, Wrap w380, %lng_ManualUpdateText%
	Gui, Font, C000066 Underline
	If Betatester = 1
		Gui, Add, Text, y+3 gsub_OpenDownloadBetaURL, http://activaid.rumborak.de/
	Else
		Gui, Add, Text, y+3 gsub_OpenDownloadURL, http://www.heise.de/ct/activaid
	Gui, Font
	Gui, Font, S%FontSize%
	Gui, Add, Button, -Wrap X55 Y+10 W210 Default gsub_ManualUpdate, %lng_OpenURLAndExit%

	Gui, Add, Button, -Wrap X+5 W80 vMainGuiCancel gManualUpdateGuiClose, %lng_Close%
	Gui, Show, w400, %ScriptTitle% %lng_ManualUpdate%
Return

sub_OpenDownloadAhk:
	Run, http://www.autohotkey.com/download/AutoHotkeyInstall.exe
Return
sub_OpenDownloadAhkUSB:
	Run, http://www.autohotkey.com/download/AutoHotkey.zip
Return
sub_OpenDownloadURL:
	Run, http://www.heise.de/ct/activaid/
Return
sub_OpenDownloadBetaURL:
	Run, http://activaid.rumborak.de/
Return

ManualUpdateGuiEscape:
ManualUpdateGuiClose:
	Gui,%GuiID_activAid%:-Disabled
	Gui,%GuiID_ManualUpdate%:Destroy
Return

sub_ManualUpdate:
	If Betatester = 1
		Gosub, sub_OpenDownloadBetaURL
	Else
		Gosub, sub_OpenDownloadURL
	ExitApp
Return

sub_ShowBackupDir:
	IfExist, %BackupDir%
		Run, %FileBrowserSelect% %BackupDir%
Return

tim_AutoUpdate:
	Gosub, sub_AutoUpdate
Return

sub_SimulateUpdate:
	IfExist, %A_ScriptDir%\ac'tivAid_AHK-Checker.ahk
	{
		SimulateUpdate = 1
		A_Args = %A_Args% SimulateUpdate
		Gosub, sub_getUpdates
	}
	Else
		MsgBox, %ScriptTitle%, Simulate Update not possible:`n%A_ScriptDir%\ac'tivAid_AHK-Checker.ahk is missing.
Return

sub_AutoUpdate:
	NetworkTickCount := A_TickCount
	URLDownloadToFile,%UpdateURL%?dl=%ScriptVersion%, versions.ini
	NetworkTickCount := A_TickCount - NetworkTickCount
	If ErrorLevel = 0
	{
		IniRead, newScriptVersion, versions.ini, activAid, version

		If ExeDistribution = 1
		{
			IniRead, newScriptURL, versions.ini, activAid_NoUnzip, exeurl
			IniRead, newScriptSize, versions.ini, activAid_NoUnzip, exesize
			newAHKVersion = %A_AHKversion%
		}
		Else
		{
			IniRead, newScriptURL, versions.ini, activAid_NoUnzip, url
			IniRead, newScriptSize, versions.ini, activAid_NoUnzip, size
			IniRead, newAHKVersion, versions.ini, activAid, AHKversion, %A_AHKversion%
		}
		IniRead, newScriptExtension, versions.ini, activAid, Extensions
		IniRead, newScriptHideUpdate, versions.ini, activAid, hideupdate, 0
		FileDelete, versions.ini

		if newScriptHideUpdate <> 1
		{
			If newScriptVersion <> ERROR
			{
				If ( func_getNormalizedVersionNumber(newScriptVersion) > func_getNormalizedVersionNumber(ScriptVersion) OR SimulateUpdate = 1)
				{
					SetTimer, tim_Loading, Off
					SplashImage, 2:Off
					Gosub, sub_NewVersion
				}
				IniWrite, % A_YYYY A_YDay, %ConfigFile%, %ScriptName%, LastUpdate
			}
		}
	}
	If (NetworkTickCount > NetworkTimeout*1000 AND DisableAutoUpdateOnSlowNetwork = 1)
	{
		If LoadingFinished <> 1
		{
			SetTimer, tim_Loading, Off
			SplashImage, Off
			SplashImage, 2:Off
			Critical
		}
		MsgBox,131092, %ScriptTitle%, %lng_SlowNetwork%
		If LoadingFinished <> 1
		{
			Critical, Off
			IfNotInstring, A_Args, nosplash
				SetTimer, tim_Loading, On
		}
		IfMsgBox, Yes
		{
			AutoUpdate = 0
			IniWrite, 0, %ConfigFile%, %ScriptName%, AutoUpdate
		}
		Else
		{
			DisableAutoUpdateOnSlowNetwork = 0
			IniWrite, %DisableAutoUpdateOnSlowNetwork%, %ConfigFile%, %ScriptName%, DisableAutoUpdateOnSlowNetwork
		}
	}
Return

sub_NewVersion:
	SetTimer, sub_NewVersionThread, -20
Return

sub_NewVersionThread:
	Gui %GuiID_activAid%:+OwnDialogs
	If newAHKVersion > %A_AHKversion%
		newScriptSize := newScriptSize + 1710
	msgbox = yes
	If ( UpdateImmediatly <> 1 AND _SilentUpdate <> 1 )
	{
		If MainGUiVisible =
			Gui, %GuiID_activAid%:Show, x-30000 y-30000, %ScriptTitle% - %lng_Update%
		func_AddMessage( 0x53, "sub_ShowExternalChangeLog" )
		SetTimer, tim_RenameViewChangelog, 1
		If SimulateUpdate = 1
			MsgBox, 16420, %test% %ScriptTitle% - %lng_Update%, %lng_NeedUpdate% %newScriptVersion% (ca. %newScriptSize% Kb)`n`nSIMULATE UPDATE!
		Else
			MsgBox, 16420, %test% %ScriptTitle% - %lng_Update%, %lng_NeedUpdate% %newScriptVersion% (ca. %newScriptSize% Kb)
		func_RemoveMessage( 0x53, "sub_ShowExternalChangeLog" )
		If MainGUiVisible =
		{
			Gui, %GuiID_activAid%:Destroy
			mainGuiID =
		}

		IfMsgBox, Yes
			msgbox = yes
		Else
			msgbox = no
	}

	If MsgBox = yes
	{
		If (A_IsCompiled = 1 AND ExeDistribution <> 1)
		{
			MsgBox, 16, %ScriptTitle% - %lng_Update%, %lng_NoUpdate%
			SimulateUpdate = 0
			StringReplace, A_Args, A_Args, SimulateUpdate,
			Return
		}

		NewWorkingDir := A_WorkingDir

		If ( MainDirNotWriteable > 0 )
		{
			IniWrite, 1, %ConfigFile%, %ScriptName%, CheckForUpdates
			Gosub, sub_RunAsAdmin
			Return
		}
		WorkingDir = %A_WorkingDir%
		SetWorkingDir, %A_ScriptDir%
		Settimer, tim_UPDATEDSCRIPT, Off
		IniWrite, %newScriptExtension%, %ConfigFile%, activAid, newext
		IniWrite, %newScriptVersion%, %ConfigFile%, activAid, newver

		IfNotExist, settings
			FileCreateDir, settings

		SoundPlay, Nonexistent.wav, wait

		URL2 =
		If newAHKVersion > %A_AHKversion%
		{
			StringReplace, AHKVersion_DL, newAHKversion, ., , A
			If AHKonUSB = 1
			{
				If Betatester = 1
					URL2 = http://activaid.rumborak.de/update_autohotkey.exe
				Else
					URL2 = http://www.heise.de/ct/activaid/download/update_autohotkey_v%AHKVersion_DL%.exe
				File2 = update_autohotkey.exe
			}
			Else
			{
				URL2 = http://www.autohotkey.net/programs/AutoHotkey%AHKVersion_DL%_Install.exe
				File2 = AutoHotkeyInstall.exe
			}
		}

		UpdateError = 0
		If URL2 <>
		{
			DownloadUpdateNum2 := lc_addDownload(URL2,File2, lng_downloadingActivAid, "sub_DownLoadUpdateFinished2","sub_DownLoadUpdateError2")
			lc_addToQueue(DownloadUpdateNum2)
		}
		newScriptURL = %newScriptURL%
		DownloadUpdateNum1 := lc_addDownload(newScriptURL,"update.exe", lng_downloadingActivAid, "sub_DownLoadUpdateFinished","sub_DownLoadUpdateError")
		lc_addToQueue(DownloadUpdateNum1)

		Return
; ##############################

		Errors := func_Download( newScriptURL, "update.exe", lng_downloadingActivAid , ScriptNameFull " Update", newScriptSize, URL2, File2, URL3, File3)

		If Errors = 0
		{
			If A_IsSuspended = 1
				Gosub, sub_MenuSuspend
			Gosub, sub_MenuSuspend
			If A_IsCompiled = 1
			{
				If MaintainStats = 1
				{
					statUpdateCount ++
					IniWrite, %statUpdateCount%, %ConfigFile%, Statistics, UpdateCount
				}
				FileAppend, %ScriptNameFull%.exe kill`n, update.cmd
				FileAppend, update.exe`n, update.cmd
				FileAppend, %ScriptNameFull%-updater.exe`n, update.cmd
				SoundPlay, Nonexistent.avi, wait
				RunWait, update.cmd,%A_ScriptDir%, Hide UseErrorLevel
				ExitApp
			}
			SoundPlay, Nonexistent.wav, wait
			Sleep, 300
			If SimulateUpdate = 1
			{
				FileMove, %A_ScriptDir%\ac'tivAid.ahk, %A_ScriptDir%\ac'tivAid_main.ahk
				FileCopy, %A_ScriptDir%\ac'tivAid_AHK-Checker.ahk, %A_ScriptDir%\ac'tivAid.ahk
			}
			Else
				RunWait, update.exe %A_Args%, %A_ScriptDir%, Hide UseErrorLevel
			Sleep, 300
		}

		If (ErrorLevel = 0 OR Errors > 0)
		{
			SetTimer, tim_Loading, Off
			SplashImage, 2:Off
			SimulateUpdate = 0
			StringReplace, A_Args, A_Args, SimulateUpdate,
			If _SilentUpdate <> 1
				MsgBox, 64, %ScriptTitle% - %lng_Update%, %lng_UpdateFinished%, 10
			If (A_IsAdmin = 1 AND tempAdminMode = 1)
				A_Args = LeaveAdmin %A_Args%
			LeaveAdmin =
		}
		Else
		{
			SetTimer, tim_Loading, Off
			SplashImage, 2:Off
			MsgBox, 16, %ScriptTitle% - %lng_Update%, %lng_UpdateFailed%
			FileDelete, update.exe
			FileDelete, update.cmd
			SetWorkingDir, %WorkingDir%

			FileCopyDir, %A_Temp%\activAidUpdateBackup.tmp, %A_ScriptDir%, 1
			FileRemoveDir, %A_Temp%\activAidUpdateBackup.tmp, 1

			Return
		}
		If MaintainStats = 1
			statUpdateCount ++

		FileRemoveDir, %A_Temp%\activAidUpdateBackup.tmp, 1

		SetWorkingDir, %WorkingDir%
		Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
		Gosub, Reload
	}
Return

sub_DownLoadUpdateFinished2:
Return

sub_DownLoadUpdateError2:
	UpdateError++
Return


sub_DownLoadUpdateFinished:
	If UpdateError > 0
		Gosub, sub_DownLoadUpdateError
	Else
	{
		If A_IsSuspended = 1
			Gosub, sub_MenuSuspend
		Gosub, sub_MenuSuspend

		Gosub, sub_UpdateProgress

		If BackupOnUpdate = 1
		{
			FileRemoveDir, %BackupDir%, 1
			FileCopyDir, %A_ScriptDir%, %BackupDir%, 1
		}

		FileRemoveDir, %A_Temp%\activAidUpdateBackup.tmp, 1
		FileCopyDir, %A_ScriptDir%, %A_Temp%\activAidUpdateBackup.tmp, 1

		DownloadUpdateTempBackup = 1

		If A_IsCompiled = 1
		{
			If MaintainStats = 1
			{
				statUpdateCount ++
				IniWrite, %statUpdateCount%, %ConfigFile%, Statistics, UpdateCount
			}
			FileAppend, %ScriptNameFull%.exe kill`n, update.cmd
			FileAppend, update.exe`n, update.cmd
			FileAppend, %ScriptNameFull%-updater.exe`n, update.cmd
			SoundPlay, Nonexistent.avi, wait
			RunWait, update.cmd,%A_ScriptDir%, Hide UseErrorLevel
			ExitApp
		}
		SoundPlay, Nonexistent.wav, wait
		Sleep, 300
		If SimulateUpdate = 1
		{
			FileMove, %A_ScriptDir%\ac'tivAid.ahk, %A_ScriptDir%\ac'tivAid_main.ahk
			FileCopy, %A_ScriptDir%\ac'tivAid_AHK-Checker.ahk, %A_ScriptDir%\ac'tivAid.ahk
		}
		Else
			RunWait, update.exe %A_Args%, %A_ScriptDir%, Hide UseErrorLevel
		Sleep, 300
		If (ErrorLevel = 0)
		{
			SetTimer, tim_Loading, Off
			SplashImage, 2:Off
			SimulateUpdate = 0
			StringReplace, A_Args, A_Args, SimulateUpdate,
			If _SilentUpdate <> 1
				MsgBox, 64, %ScriptTitle% - %lng_Update%, %lng_UpdateFinished%, 10
			If (A_IsAdmin = 1 AND tempAdminMode = 1)
				A_Args = LeaveAdmin %A_Args%
			LeaveAdmin =

			If MaintainStats = 1
				statUpdateCount ++

			FileRemoveDir, %A_Temp%\activAidUpdateBackup.tmp, 1

			SetWorkingDir, %WorkingDir%
			Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
			Gosub, Reload
		}
		Else
			Gosub, sub_DownLoadUpdateError
	}
Return

sub_DownLoadUpdateError:
	SetTimer, tim_Loading, Off
	SplashImage, 2:Off
	MsgBox, 16, %ScriptTitle% - %lng_Update%, %lng_UpdateFailed%
	FileDelete, update.exe
	FileDelete, update.cmd
	SetWorkingDir, %WorkingDir%
	If DownloadUpdateTempBackup = 1
	{
		FileCopyDir, %A_Temp%\activAidUpdateBackup.tmp, %A_ScriptDir%, 1
		FileRemoveDir, %A_Temp%\activAidUpdateBackup.tmp, 1
		DownloadUpdateTempBackup =
	}
	SimulateUpdate = 0
	StringReplace, A_Args, A_Args, SimulateUpdate,
Return

tim_RenameViewChangelog:
	ControlSetText, Button3, &%lng_ViewChangelog%, %ScriptTitle% - %lng_Update%,, ahk_id %activAidID%
	If ErrorLevel = 0
		SetTimer, tim_RenameViewChangelog, Off
Return

sub_ShowExternalChangeLog:
	If UpdateURL = %UpdateURLbeta%
		Run, http://activaid.rumborak.de/beta/aenderungen.htm
	Else
		Run, http://www.heise.de/ct/activaid/htm/changelog.htm
Return

; Skript bei Änderung automatisch neu laden
tim_UPDATEDSCRIPT:
;   Critical
	WinGetActiveTitle, act_Title
	IfNotInstring, act_Title, .ahk
		Return

	Loop, %A_ScriptDir%\*.ahk, 0, 1
	{
		If (func_StrLeft(A_LoopFileName,1) = "_" OR func_StrLeft(A_LoopFileName,1) = ".")
			continue
		If A_LoopFileAttrib contains A
		{
			IfNotInString, act_Title, %A_LoopFileName%
				continue

			Suspend, On

			FileSetAttrib,-A,%A_LoopFileFullpath%
			Debug("RELOAD",A_LineNumber,A_LineFile,"Script has been modified")
			Gosub, Reload
		}
	}
Return

tim_BalloonTipTimeout:
	SetTimer, tim_BalloonTipTimeout, Off
	TrayTip
Return

; ac'tivAid im Autostart-Ordner eintragen
sub_MenuAutostart:
	If AutoStart = -1
		AutoStartNoSplash = nosplash
	Else
		AutoStartNoSplash =

	If UsingUserDir = 1
		FileCreateShortcut,%A_ScriptFullPath%, %activAidData%\%ScriptNameFull%.lnk,%activAidData%,,,%ScriptIcon%

	If AutoStart = 0
		FileDelete, %A_Startup%\%ScriptNameFull%.lnk
	Else If AHKonUSB <> 1
	{
		If A_Iscompiled = 1
			FileCreateShortcut,%A_ScriptFullPath%,%A_Startup%\%ScriptNameFull%.lnk,%A_WorkingDir%,%AutoStartNoSplash%,,%A_ScriptFullPath%
		Else
		{
			If UsingUserDir = 1
				FileCreateShortcut,%A_ScriptFullPath%,%A_Startup%\%ScriptNameFull%.lnk,%activAidData%,%AutoStartNoSplash%,,%ScriptOnIcon%
			Else
				FileCreateShortcut,%A_ScriptFullPath%,%A_Startup%\%ScriptNameFull%.lnk,%A_WorkingDir%,%AutoStartNoSplash%,,%ScriptOnIcon%
		}
	}
	Else If AHKonlyPortable = 1
	{
		If A_Iscompiled = 1
			FileCreateShortcut,%A_ScriptDir%\Portable_ac'tivAid.exe,%A_Startup%\%ScriptNameFull%.lnk,%A_WorkingDir%,%AutoStartNoSplash%,,%A_ScriptFullPath%
		Else
		{
			If UsingUserDir = 1
				FileCreateShortcut,%A_ScriptDir%\Portable_ac'tivAid.exe,%A_Startup%\%ScriptNameFull%.lnk,%activAidData%,%AutoStartNoSplash%,,%ScriptOnIcon%
			Else
				FileCreateShortcut,%A_ScriptDir%\Portable_ac'tivAid.exe,%A_Startup%\%ScriptNameFull%.lnk,%A_WorkingDir%,%AutoStartNoSplash%,,%ScriptOnIcon%
		}
	}
	If ErrorLevel
		Error++

	If (CreateUninstaller = 2 AND AHKonUSB <> 1)
	{
		FileCreateDir, %A_Programs%\ac'tivAid
		SplitPath, ReadmeFile, ProgramsReadme
		If UsingUserDir = 1
			FileCreateShortcut,%A_ScriptFullPath%, %activAidData%\%ScriptNameFull%.lnk,%activAidData%,,,%ScriptIcon%
		If A_Iscompiled = 1
		{
			FileCreateShortcut,%A_ScriptFullPath%,%A_Programs%\ac'tivAid\%ScriptNameFull%.lnk,%A_ScriptDir%,,,%A_ScriptFullPath%
			FileCreateShortcut,%A_ScriptDir%\%ProgramsReadme%,%A_Programs%\ac'tivAid\%ProgramsReadme%.lnk,%A_ScriptDir%,,,%A_ScriptDir%\%ProgramsReadme%
		}
		Else
		{
			If UsingUserDir = 1
			{
				FileCreateShortcut,%activAidData%\%ScriptNameFull%.lnk, %A_Programs%\ac'tivAid\%ScriptNameFull%.lnk,%activAidData%,,,%ScriptOnIcon%
			}
			Else
			{
				FileCreateShortcut,%A_ScriptFullPath%,%A_Programs%\ac'tivAid\%ScriptNameFull%.lnk,%A_ScriptDir%,,,%ScriptOnIcon%
			}
			FileCreateShortcut,%A_ScriptDir%\%ProgramsReadme%,%A_Programs%\ac'tivAid\%ProgramsReadme%.lnk,%A_ScriptDir%,,,%A_ScriptDir%\%ProgramsReadme%
		}
		If ErrorLevel
			Error++
	}
Return

sub_MenuContextHelp:
	Context:= GuiTabs[%ListBox_selected%]
;   StringReplace, Context, A_ThisMenuItem, % lng_ContextHelp " ",
	Gosub, sub_ContextHelpMain
Return

sub_EMContextHelp:
sub_ContextHelp:
	IfInString, A_GuiControl, CH_
		StringReplace, Context, A_GuiControl, CH_,
	If Context =
		Return
	Gosub, sub_ContextHelpMain
Return

sub_ContextHelpMain:
	ContextBegin   = 0
	ContextContent =
	GuiDefault("HelpWindow")

	Context := func_StrTrimChars(Context, "", "1234567890" )

	Loop, Parse, ReadMe, `n, `r
	{
		If ContextBegin = 1
		{
			If ( InStr(A_LoopField, ". " Context) > 2 AND InStr(A_LoopField, ". " Context) < 8)
			{
				ContextBegin++
			}
			Continue
		}
		If ContextBegin = 2
		{
			ContextBegin++
			Continue
		}
		If ContextBegin = 3
		{
			If A_LoopField contains _________________________
				break
			ContextContent = %ContextContent%%A_LoopField%`n
		}

		If A_LoopField contains ________________________
		{
			ContextBegin++
			Continue
		}


	}
	Prefix := ExtensionPrefix[%Context%]
	If %Prefix%_Help <>
		ContextContent := %Prefix%_Help
	Gui, Destroy
	GuiDefault("HelpWindow", "-Maximize -Minimize +ToolWindow +AlwaysOnTop")
	Gui, Font, S%FontSize14% bold, Arial
	Gui, Add, Text,, %Context%
	Gosub, GuiDefaultFont
	If ExtensionVersion[%Context%] =
		Gui, Add, Text,x+5 yp+7, % " "
	Else
		Gui, Add, Text,x+5 yp+7, % "v" ExtensionVersion[%Context%] " " lng_by " " %Prefix%_Author

	Gui, Add, Text, X377 YP-2 W80 Right, %lng_Search%:
	Gui, Add, Edit, x+5 yp-4 w100 vsearchTermContextHelp gsub_ReadmeSearch
	Gui, Add, Button, -Wrap x+3 gsub_ReadmeSearch vsearchButtonContextHelp H21 W15, >

	Gui, Font, , Courier New
	Gui, Font, , Lucida Console
	Gui, Add, Edit,Readonly 0x100 -WantReturn x10 Y+5 T100 H330 W570 vContextHelp, %ContextContent%
	Gosub, GuiDefaultFont
	Gui, Add, Button, -Wrap w50 X270 gHelpWindowGuiClose, %lng_OK%
	Gui, Show, , %ScriptTitle% - %Context%
	Send,^{Home}
Return

HelpWindowGuiClose:
HelpWindowGuiEscape:
	Gui, %GuiID_HelpWindow%:Destroy
Return

sub_OnExit:
	Critical
	Debug("STATUS", A_LineNumber, A_LineFile, "ExitReason: " A_ExitReason )
	If IsLabel("cd_sub_RestoreTempDeskWindows")
		Gosub, cd_sub_RestoreTempDeskWindows%A_EmptyVar%
	If IsLabel("cd_sub_RestoreHiddenWindows")
		Gosub, cd_sub_RestoreHiddenWindows%A_EmptyVar%
	Loop
	{
		If Extension[%A_Index%] =
			break
		Function := Extension[%A_Index%]
		If ( IsLabel("OnExitAndReload_" Function) )
		{
			Debug("STATUS", A_LineNumber, A_LineFile, "OnExitAndReload_" Function "...")
			Gosub, OnExitAndReload_%Function%
		}
	}

	If HotkeyList <>
	{
		Gui, %GuiID_HotkeyList%:+LastFoundExist
		IfWinExist
			WinGetPos, ShowHotkeyListX , ShowHotkeyListY , ShowHotkeyListW, ShowHotkeyListH
		If ShowHotkeyListH <>
		{
			WinGet, MinMax, MinMax
			If MinMax <> -1
			{
				IniWrite, %ShowHotkeyListX%, %ConfigFile%, %ScriptName%, ShowHotkeyListX
				IniWrite, %ShowHotkeyListY%, %ConfigFile%, %ScriptName%, ShowHotkeyListY
				IniWrite, %ShowHotkeyListH%, %ConfigFile%, %ScriptName%, ShowHotkeyListH
				IniWrite, %ShowHotkeyListW%, %ConfigFile%, %ScriptName%, ShowHotkeyListW
			}
		}
	}

	If GuiID_VarDump <>
	{
		Gui, %GuiID_VarDump%:+LastFoundExist
		IfWinExist
		{
			IniWrite, 1, %ConfigFile%, %ScriptName%, ShowVarDump
			Gosub, VarDumpGuiOK
		}
	}

	If A_ExitReason <> Reload
	{
		IniDelete, %ConfigFile%, %ScriptName%, ShowGUI
		IniDelete, %ConfigFile%, %ScriptName%, LastExitReason
		If MaintainStats = 1
			IniWrite, %statLastLaunched%, %ConfigFile%, Statistics, LastLaunched

		If (tempAdminMode = 1 AND A_ExitReason = "Exit")
		{
			tempAdminMode = 0
			DetectHiddenWindows, On
			If A_IsCompiled = 1
				SendMessage, 0x1ccc, 33, 33,,%A_ScriptDir%\extensions\RunWithAdminRights.exe
			Else
				SendMessage, 0x1ccc, 33, 33,,%A_ScriptDir%\extensions\RunWithAdminRights.ahk - AutoHotkey v%A_Ahkversion%
		}
	}
	Else
	{
		IniWrite, Reload, %ConfigFile%, %ScriptName%, LastExitReason
		statReloadCount++
	}

	If A_ExitReason not in Reload,Single,Error,Logoff,Shutdown,Close
		statExitCount++

	CallHook( "On" A_ExitReason )

	If MaintainStats = 1
	{
		statTime = %A_Now%
		IniWrite, %statFirstLaunch%, %ConfigFile%, Statistics, FirstLaunch
		IniWrite, %statLaunchCount%, %ConfigFile%, Statistics, LaunchCount
		IniWrite, %statReloadCount%, %ConfigFile%, Statistics, ReloadCount
		IniWrite, %statUpdateCount%, %ConfigFile%, Statistics, UpdateCount
		IniWrite, %statExitCount%, %ConfigFile%, Statistics, ExitCount
		EnvSub, statTime, statTimeLaunched, Minutes
		statTotalTime := statTotalTime+statTime
		IniWrite, %statTotalTime%, %ConfigFile%, Statistics, TotalTime
		If statTime > %statLongestSession%
			IniWrite, %statTime%, %ConfigFile%, Statistics, LongestSession
	}
	IfWinExist, ahk_id %MainGuiID%
	{
		If MainGuiX <> Reset
		{
			WinGet, MinMax, MinMax, ahk_id %MainGuiID%
			If MinMax <> -1
			{
				WinGetPos, MainGuiX, MainGuiY, , , ahk_id %MainGuiID%
				IniWrite, %MainGuiX%, %ConfigFile%, %ScriptName%, MainGuiX
				IniWrite, %MainGuiY%, %ConfigFile%, %ScriptName%, MainGuiY
			}
		}
	}
	Gdip_Shutdown(gdiPlus_Token)
	ExitApp
Return



OnClipboardChange:
	Critical
	If (LoadingFinished = "" OR Hook_OnClipboardChange = "" OR NoOnClipboardChange = 1)
		Return
	Sleep, 400
	ThisClipboard = %Clipboard%
	If (A_EventInfo = 1 AND ThisClipboard = LastClipboard)
		Return
	CallHook("OnClipboardChange")
	LastClipboard = %ThisClipboard%
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------
#include %A_ScriptDir%\internals\ac'tivAid_MRButton.ahk


tim_DownloadProgress:
;   Critical
	FileGetSize, DownloadProgressFileSize, %DownloadProgressFile%, K
	DownloadProgressFileSize := DownloadProgressAddSize + DownloadProgressFileSize
	If DownloadProgressFileSize = %DownloadProgressFileSizeLast%
		return
	If DownloadProgressTotalSize > 5
	{
		DownloadProgressPercentage := Round(DownloadProgressFileSize / DownloadProgressTotalSize * 100,0)
		Progress, %DownloadProgressPercentage%
	}
	Else
	{
		SplashImage,,T M2 FS9 W400, %DownloadProgressSplashtext% (%DownloadProgressFileSize% Kb)
	}
	DownloadProgressFileSizeLast = %DownloadProgressFileSize%
Return

sub_UpdateProgress:
	SplashImage, 2:%SplashIcon%,b2 FS5 C c00 ZY2 ZX2 w36, %A_Space%,,, Terminal
	SetTimer, tim_Loading, 50
Return

sub_GetAllEnv:
	tmp_blockAddr := DllCall("GetEnvironmentStrings")
	tmp_pointer := tmp_blockAddr
	tmp_bGetVar := true
	Loop
	{
		tmp_lstrlen := DllCall("lstrlen", UInt, tmp_pointer)
		; Skip first value
		If (A_Index = 1)
		{
			tmp_pointer += tmp_lstrlen + 1
			Continue   ; Strange value...: "=::=::\"
		}
		VarSetCapacity(tmp_buffer, tmp_lstrlen+1, 0)
		DllCall("lstrcpy", "Str", tmp_buffer, "UInt", tmp_pointer)
		; Here, we have in buffer something like "var=value"
		StringSplit, tmp_EnvVar, tmp_buffer, =
		tmp_EnvVar1 := func_StrClean(tmp_EnvVar1,"",0,"_")
		; Avoid an error because these variables exist and are read-only
		If tmp_EnvVar1 <>
			If tmp_EnvVar1 not in ComSpec,ProgramFiles
				%tmp_EnvVar1% = %tmp_EnvVar2%%tmp_EnvVar3%%tmp_EnvVar4%%tmp_EnvVar5%%tmp_EnvVar6%%tmp_EnvVar7%%tmp_EnvVar8%%tmp_EnvVar9%
		Loop, 9
			tmp_EnvVar%A_Index% =
		tmp_pointer += tmp_lstrlen + 1
		If (*tmp_pointer = 0)
			Break
	}

	DllCall("FreeEnvironmentStrings", "UInt", tmp_blockAddr)
	FormatTime, DATE,,ShortDate
	FormatTime, Time,,Time
Return

sub_OnWakeUp:
	If #wparam not in 6,7,18
		Return
	If ReloadOnWakeUp = 1
	{
		Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
		Gosub, Reload
	}
Return



#IfWinActive ahk_class AutoHotkeyGUI

$WheelDown::
$WheelUp::
	If (Enable_MouseWheel = 1 AND IsLabel("mw_sub_WheelUp"))
		Gosub, mw_sub_WheelUp%A_EmptyVar%
	Else
	{
		StringReplace, ThisHotkey, A_ThisHotkey, $
		MouseGetPos,,,WheelWin, WheelControl
		WinGetClass, WheelClass, ahk_id %WheelWin%
		If WheelClass = AutoHotkeyGUI
		{
			RegRead, WheelScrollLines, HKEY_CURRENT_USER, Control Panel\Desktop, WheelScrollLines
			Loop, %WheelScrollLines%
				SendMessage, 0x115, % (ThisHotKey="WheelDown"), 0, %WheelControl%, ahk_id %WheelWin%
		}
		Else
		{
			Send, {%ThisHotkey%}
		}
	}
Return

#IfWinActive

