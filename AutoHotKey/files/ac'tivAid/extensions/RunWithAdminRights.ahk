; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               ac'tivAid RunWithAdminRights
; -----------------------------------------------------------------------------
; Version:            1.3.2 dev
; Date:               2008-06-09 13:00
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; AutoHotkey Version: 1.0.47.06
; -----------------------------------------------------------------------------

#Singleinstance force
#Notrayicon
#Noenv
#Persistent
Detecthiddenwindows, On

DebugLevel = ALL

ScriptName         = activAidRunAs
ScriptNameFull     = ac'tivAid
ScriptVersion      = 1.3.2 Entwickler

ScriptTitle        = %ScriptNameFull% v%ScriptVersion%

IfNotExist, %A_Temp%
	FileCreateDir, %A_Temp%

StringReplace, ScriptFullDir, A_ScriptDir, \extensions
StringReplace, WorkingDir, A_WorkingDir, \extensions
SetWorkingdir, %WorkingDir%

If A_IsCompiled = 1
	RegRead, A_RealOSVersion, HKEY_CURRENT_USER, Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %A_ScriptFullPath%
Else
	RegRead, A_RealOSVersion, HKEY_CURRENT_USER, Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %A_AhkPath%
If (A_RealOSVersion <> "" AND ErrorLevel = 0)
	A_RealOSVersion = WIN_VISTA
Else
	A_RealOSVersion = %A_OSVersion%

FileAppend, write, %A_ScriptDir%\_temp.tmp
MainDirNotWriteable = %ErrorLevel%
FileDelete, %A_ScriptDir%\_temp.tmp

SplitPath, A_AhkPath,,A_AutoHotkeyPath

SplitPath, A_AutoHotkeyPath,,,,, A_AutoHotkeyDrive
DriveGet, A_AutoHotkeyDriveType, Type, %A_AutoHotkeyDrive%

If ( InStr(A_AutoHotkeyPath, A_ScriptDir) )
{
	AHKonUSB = 1
	If A_AutoHotkeyDriveType <> Removable
		AHKonlyPortable = 1
}

If AHKonUSB = 1
	APPDATA = %A_ScriptDir%\ComputerSettings\%A_Computername%
Else
	APPDATA = %A_AppData%

If APPDATA =
	RegRead, APPDATA, HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders,AppData

If AHKonUSB = 1
{
	activAidData = %APPDATA%
	activAidGlobalData = %APPDATA%
}
Else
{
	activAidData = %APPDATA%\ac'tivAid
	If (MainDirNotWriteable = 1 OR aa_osversionnumber >= aa_osversionnumber_vista)
		activAidGlobalData = %A_AppDataCommon%\ac'tivAid
	Else
		activAidGlobalData = %A_ScriptDir%
	If (aa_osversionnumber >= aa_osversionnumber_vista AND A_WorkingDir <> activAidGlobalData AND A_WorkingDir = A_ScriptDir )
	{
		Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
		If A_IsCompiled = 1
			Run, %A_ScriptFullPath% %A_Args%, %activAidGlobalData%, UseErrorLevel
		Else
			Run, %A_AhkPath% /r "%A_ScriptFullPath%" %A_Args%, %activAidGlobalData%, UseErrorLevel
		ExitApp
	}
}

SettingsDir = settings
ConfigFile = %SettingsDir%\%ScriptNameFull%.ini

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
	If A_WorkingDir <> %WorkingDir%
		LastWorkingDir = %WorkingDir%
	Else If (FileExist(A_Appdatacommon "\ac'tivAid\" ConfigFile) AND AHKonUSB <> 1)
		LastWorkingDir = %A_Appdatacommon%\ac'tivAid
	Else
		LastWorkingDir = %WorkingDir%
}
A_Args = %A_Args% "LastWorkingDir:%LastWorkingDir%"

OnMessage(0x1ccc,"ExternalMessages")

If (A_WorkingDir = activAidData)
	UsingUserDir = 1
Else
	UsingUserDir = 0

If A_IsCompiled = 1
	ScriptFullPath = %ScriptFullDir%\ac'tivAid.exe
Else
	ScriptFullPath = %ScriptFullDir%\ac'tivAid.ahk

SetTimer, AutoExit, 3000

Gosub, sub_RunAsAdmin

Return

sub_RunAsAdmin:
	If A_IsCompiled = 1
		ShellExecResult := DllCall("shell32\ShellExecuteA", uint, 0, str, "RunAs", str, ScriptFullPath,str, "tempAdminMode " A_Args, str, A_WorkingDir, int, 1)  ; Last parameter: SW_SHOWNORMAL = 1
	Else
		ShellExecResult := DllCall("shell32\ShellExecuteA", uint, 0, str, "RunAs", str, A_AhkPath,str, "/r """ . ScriptFullPath . """ tempAdminMode " A_Args, str, A_WorkingDir, int, 1)  ; Last parameter: SW_SHOWNORMAL = 1

	If ShellExecResult < 33
	{
		If A_IsCompiled = 1
			Run, %ScriptFullPath%, %A_WorkingDir%, UseErrorLevel
		Else
			Run, %A_AhkPath% /r "%ScriptFullPath%" %A_Args%, %A_WorkingDir%, UseErrorLevel
	}
Return

func_GetErrorMessage( Error,MessageHeader="",MessageBody="" ) {
	bufferSize = 1024 ; Arbitrary, should be large enough for most uses
	VarSetCapacity(buffer, bufferSize)
	FORMAT_MESSAGE_FROM_SYSTEM = 0x1000
	LANG_SYSTEM_DEFAULT = 0x10000
	LANG_USER_DEFAULT = 0x20000
	DllCall("FormatMessage"
		, "UInt", FORMAT_MESSAGE_FROM_SYSTEM
		, "UInt", 0
		, "UInt", Error
		, "UInt", LANG_USER_DEFAULT
		, "Str", buffer
		, "UInt", bufferSize
		, "UInt", 0)

	If MessageHeader <>
		MsgBox, 48, %MessageHeader%, %MessageBody% %Buffer%

	Return %buffer%
}

ExternalMessages(wParam, lParam, msg, hwnd)
{
	global
	If (wParam = 99) ; LeaveAdmin
	{
		StringReplace, A_Args, A_Args, % "update "
		StringReplace, A_Args, A_Args, % "uninstall "
		Debug("RELOAD",A_LineNumber,A_LineFile,A_ThisFunc A_ThisLabel)
		If A_IsCompiled = 1
			Run, %ScriptFullPath% %A_Args%, %A_WorkingDir%
		Else
			Run, %A_AhkPath% /r "%ScriptFullPath%" %A_Args%, %A_WorkingDir%
		ExitApp
	}
	If (wParam = 1) ; Check if RunWithAdminRights.ahk is running
		Return 1
	If (wParam = 33) ; Exit
	{
		ExitApp
	}
}

CreateGuiID( VariableName ) {
	global
	LastGuiID++
	GuiID_%VariableName% = %LastGuiID%
	Return %LastGuiID%
}

GuiDefault( VariableName, Options="" ) {
	global
	Gui, % GuiID_%VariableName% ":Default"
	Gui, +Label%VariableName%Gui %Options%
	Gui, +LastFound
	WinGet, GuiID, ID
	Return GuiID
}

Debug( dbgClass,dbgLine,dbgFile,dbgMessage ) {
	Global
	If (DebugLevel = "" OR DebugLevel = 0 OR Debug = 0)
		Return
	If (!(DebugLevel = "ALL" OR InStr(DebugLevel, dbgClass)) AND dbgClass <> "INIT")
		Return
	SplitPath, dbgFile, dbgOutFileName
	dbgClass = [%dbgClass%]
	dbgLine := SubStr("      " dbgLine, -5)
	If dbgClass = [VAR]
	{
		dbgIndent := SubStr("                                                        ", 1, StrLen(dbgOutFileName " " dbgLine ": " dbgClass " "))
		dbgNewMessage =
		Loop, Parse, dbgMessage, `,
		{
			dbgNewMessage := dbgNewMessage dbgIndent A_LoopField " = " %A_LoopField% "`n"
		}
		dbgMessage = %dbgNewMessage%
	}
	OutputDebug, %dbgOutFileName% %dbgLine%: %dbgClass% %dbgMessage%
}

AutoExit:
	IfNotExist, %ScriptFullPath%
		ExitApp
Return
