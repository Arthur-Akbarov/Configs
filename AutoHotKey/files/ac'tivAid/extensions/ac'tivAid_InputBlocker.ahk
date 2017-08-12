; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               InputBlocker
; -----------------------------------------------------------------------------
; Prefix:             ib_
; Version:            0.4
; Date:               2008-05-26
; Author:             Wolfgang Reszel, Michael Telgkamp
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_InputBlocker:
	Prefix = ib
	%Prefix%_ScriptName    = InputBlocker
	%Prefix%_ScriptVersion = 0.4
	%Prefix%_Author        = Wolfgang Reszel, Michael Telgkamp

	CustomHotkey_InputBlocker = 1
	Hotkey_InputBlocker       = #+b
	HotkeyPrefix_InputBlocker = $
	IconFile_On_InputBlocker  = %A_WinDir%\system32\user32.dll
	IconPos_On_InputBlocker   = 2
	IconFile_Off_InputBlocker =
	IconPos_Off_InputBlocker  =

	CreateGuiID("InputBlockerShade")

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %ib_ScriptName% - Blockiert die Maus und die Tastatur
		Description                   = Blockiert alle Eingaben bis ein blind Kennwort eingegeben wurde. Die Blockierung kann manuell oder nach einer gewissen Zeit der Inaktivität ausgelöst werden.
		lng_ib_Blocking               = Blockierung aktiviert
		lng_ib_UnBlocking             = Blockierung aufgehoben
		lng_ib_Password               = Kennwort
		lng_ib_AutoBlockTimer         = Automatisch Blockieren nach
		lng_ib_Inactivity             = Inaktivität
		lng_ib_RunBeforeBlocking      = Programm, welches vor der Blockierung ausgeführt werden soll
		lng_ib_RunBeforeBlockingParameters = Parameter
		lng_ib_KillAfterUnBlocking    = Programm nach Aufheben der Blockierung beenden
		lng_ib_RunParameterList       = normal starten|minimiert starten|maximiert starten|versteckt starten
		lng_ib_FileType               = Ausführbare Datei (*.exe)
		lng_ib_ShadeScreen            = Monitor abdunkeln
		lng_ib_AlternativeBlockMode   = Tastatur nicht blockieren, sondern nur Tastatureingaben abfangen
		lng_ib_AcceptImmediately      = Kennwort ohne Bestätigung mit Enter direkt erkennen
		lng_ib_StoreFaceRecAppRegistry= Kennwort in FaceRecognitionApp.exe übernehmen
		lng_ib_AutoBlockOnPhysicalIdle= Die Inaktivität für 'Automatisch Blockieren' wird nur anhand realer Maus- oder Tastatureingaben ermittelt
	}
	Else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %ib_ScriptName% - Blocks mouse and keyboard input
		Description                   = Blocks all input until a password has been entered bindly. The blocking can be started manually or after a certain time of inactivity.
		lng_ib_Blocking               = Keyboard and mouse input blocked
		lng_ib_UnBlocking             = Blocking released
		lng_ib_Password               = Password
		lng_ib_AutoBlockTimer         = Block automatically at
		lng_ib_Inactivity             = inactivity
		lng_ib_RunBeforeBlocking      = Program to start before blocking
		lng_ib_RunBeforeBlockingParameters = Parameters
		lng_ib_KillAfterUnBlocking    = Quit program after release blocking
		lng_ib_RunParameterList       = launch normally|launch minmized|launch maximized|launch hidden
		lng_ib_FileType               = Executable (*.exe)
		lng_ib_ShadeScreen            = Shade the screen
		lng_ib_AlternativeBlockMode   = Don't block keyboard, just catch the input
		lng_ib_AcceptImmediately      = Accept password immediately without pressing Enter
		lng_ib_StoreFaceRecAppRegistry= Adopt password to FaceRecognitionApp.exe
		lng_ib_AutoBlockOnPhysicalIdle= The inactivity time for 'Block automatically at' will only be determined on the basis of real mouse or keyboard input
	}

	ib_RunParameter1 =
	ib_RunParameter2 = Min
	ib_RunParameter3 = Max
	ib_RunParameter4 = Hide

	IniRead, ib_Password, %ConfigFile%, %ib_ScriptName%, Password, %A_Space%
	IniRead, ib_PasswordLen, %ConfigFile%, %ib_ScriptName%, PasswordLen, 0
	IniRead, ib_AutoBlockTimer, %ConfigFile%, %ib_ScriptName%, AutoBlockTimer, 0
	IniRead, ib_RunBeforeBlocking, %ConfigFile%, %ib_ScriptName%, RunBeforeBlocking, %A_Space%
	IniRead, ib_RunBeforeBlockingParameters, %ConfigFile%, %ib_ScriptName%, RunBeforeBlockingParameters, %A_Space%
	IniRead, ib_KillAfterUnBlocking, %ConfigFile%, %ib_ScriptName%, KillAfterUnBlocking, 0
	IniRead, ib_RunParameter, %ConfigFile%, %ib_ScriptName%, RunParameter, 1
	IniRead, ib_ShadeScreen, %ConfigFile%, %ib_ScriptName%, ShadeScreen, 0
	IniRead, ib_ShadeTransparency, %ConfigFile%, %ib_ScriptName%, ShadeTransparency, 230
	IniRead, ib_StoreFaceRecAppRegistry, %ConfigFile%, %ib_ScriptName%, StoreFaceRecAppRegistry, 1
	RegisterAdditionalSetting("ib","AlternativeBlockMode",0)
	RegisterAdditionalSetting("ib","AcceptImmediately",1)
	RegisterAdditionalSetting("ib","AutoBlockOnPhysicalIdle",0)

	RegRead, ib_TaskManager,HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe, Debugger
	ib_NoSpecialTaskManager := ErrorLevel
	RegDelete,HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableTaskMgr, 0
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation, 0
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Policies\Explorer, NoLogoff, 0
Return

SettingsGui_InputBlocker:
	ib_GuiPassword := func_StrLeft("**********************************************************",ib_PasswordLen)
	Gui, Add, Text, xs+10 y+10, %lng_ib_Password%:
	Gui, Add, Edit, Password w200 x+5 yp-3 gib_sub_CheckIfSettingsChanged vib_NewPassword,
	Gui, Add, Edit, Password w200 xp+0 yp+0 Disabled gib_sub_CheckIfSettingsChanged vib_NewPasswordHelper, %ib_GuiPassword%
	Gui, Add, CheckBox, x+5 yp+3 -Wrap Hidden gsub_CheckIfSettingsChanged vib_StoreFaceRecAppRegistry Checked%ib_StoreFaceRecAppRegistry%, %lng_ib_StoreFaceRecAppRegistry%
	Gui, Add, Text, xs+10 y+10, %lng_ib_AutoBlockTimer%:
	Gui, Add, Slider, AltSubmit yp-2 h20 gib_sub_CheckIfSettingsChanged X+2 vib_AutoBlockTimer_tmp w288 TickInterval12 Range0-152, %ib_AutoBlockTimer%
	Gui, Add, Text, x+5 yp+2 vib_AutoBlockTimer_text, 24:00 %lng_Minutes%  %lng_ib_Inactivity%

	Gui, Add, GroupBox, xs+10 y+28 w550 h95, %lng_ib_RunBeforeBlocking%:
	Gui, Add, Edit, xs+20 yp+20 r1 w375 gib_sub_CheckIfSettingsChanged vib_RunBeforeBlocking, %ib_RunBeforeBlocking%
	Gui, Add, Button, -Wrap x+5 yp-1 W25 gib_sub_Browse, ...
	Gui, Add, DropDownList, x+5 yp+1 -Wrap AltSubmit gsub_CheckIfSettingsChanged vib_RunParameter, %lng_ib_RunParameterList%
	Gui, Add, Text, xs+20 y+8, %lng_ib_RunBeforeBlockingParameters%:
	Gui, Add, Edit, x+5 yp-3 r1 w375 gsub_CheckIfSettingsChanged vib_RunBeforeBlockingParameters, %ib_RunBeforeBlockingParameters%

	Gui, Add, CheckBox, xs+20 y+5 -Wrap gsub_CheckIfSettingsChanged Checked%ib_KillAfterUnBlocking% vib_KillAfterUnBlocking, %lng_ib_KillAfterUnBlocking%
	GuiControl, Choose, ib_RunParameter, %ib_RunParameter%

	Gui, Add, CheckBox, xs+10 y+20 -Wrap gsub_CheckIfSettingsChanged Checked%ib_ShadeScreen% vib_ShadeScreen, %lng_ib_ShadeScreen%

	Gosub, ib_sub_CheckIfSettingsChanged
Return

ib_sub_Browse:
	Gui +OwnDialogs
	Fileselectfile, ib_RunBeforeBlockingTmp, 3,,,%lng_cl_FileType%
	If ib_RunBeforeBlockingTmp <>
	{
		ib_RunBeforeBlockingTmp := func_ReplaceWithCommonPathVariables(ib_RunBeforeBlockingTmp)
		GuiControl,,ib_RunBeforeBlocking, %ib_RunBeforeBlockingTmp%
	}
Return

ib_sub_CheckIfSettingsChanged:
	Gosub, sub_CheckIfSettingsChanged

	SetFormat, Float, .0
	GuiControlGet,ib_AutoBlockTimer_tmp
	If ib_AutoBlockTimer_tmp > 59
	{
			ib_AutoBlockTimer_tmp := ib_AutoBlockTimer_tmp*15-840
			If ib_AutoBlockTimer_tmp = 60
			ib_AutoBlockTimer_tmp := Floor(ib_AutoBlockTimer_tmp/60) ":" func_StrRight("0" (ib_AutoBlockTimer_tmp/60-Floor(ib_AutoBlockTimer_tmp/60))*60,2) " " lng_Hour " " lng_ib_Inactivity
		Else
			ib_AutoBlockTimer_tmp := Floor(ib_AutoBlockTimer_tmp/60) ":" func_StrRight("0" (ib_AutoBlockTimer_tmp/60-Floor(ib_AutoBlockTimer_tmp/60))*60,2) " " lng_Hours " " lng_ib_Inactivity
	}
	Else If ib_AutoBlockTimer_tmp = 0
		ib_AutoBlockTimer_tmp := lng_Off
	Else If ib_AutoBlockTimer_tmp = 1
		ib_AutoBlockTimer_tmp := ib_AutoBlockTimer_tmp " " lng_Minute " " lng_ib_Inactivity
	Else
		ib_AutoBlockTimer_tmp := ib_AutoBlockTimer_tmp " " lng_Minutes " " lng_ib_Inactivity

	GuiControl,, ib_AutoBlockTimer_text, %ib_AutoBlockTimer_tmp%

	GuiControlGet,ib_RunBeforeBlockingTmp,,ib_RunBeforeBlocking
	IfInString, ib_RunBeforeBlockingTmp, FaceRecognitionApp.exe
		GuiControl, Show, ib_StoreFaceRecAppRegistry
	Else
		GuiControl, Hide, ib_StoreFaceRecAppRegistry

	GuiControlGet,ib_NewPasswordTmp,,ib_NewPassword

	If (ib_NewPasswordTmp <> "")
	{
		GuiControl, Enable, ib_StoreFaceRecAppRegistry
		GuiControl, Hide, ib_NewPasswordHelper
	}
	Else
	{
		GuiControl, Disable, ib_StoreFaceRecAppRegistry
		GuiControl, Show, ib_NewPasswordHelper
	}

Return

SaveSettings_InputBlocker:
	If (ib_NewPassword <> "")
	{
		ib_PasswordLen := StrLen(ib_NewPassword)
		ib_Password := func_ib_Hash(ib_NewPassword)
		IfInString, ib_RunBeforeBlocking, FaceRecognitionApp.exe
			If ib_StoreFaceRecAppRegistry = 1
			{
				Process, Exist, FaceRecognitionApp.exe
				If ErrorLevel <> 0
				{
					DetectHiddenWindows, Off
					WinActivate, ahk_class QWidget
					ControlClick, QWidget24, ahk_class QWidget
					Sleep, 50
					SendRaw, %ib_NewPassword%~
					Send, {Enter}
				}
				RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\ct\FaceRecognitionApp\settings, password, %ib_NewPassword%~
			}
	}
	IniWrite, %ib_Password%, %ConfigFile%, %ib_ScriptName%, Password
	IniWrite, %ib_PasswordLen%, %ConfigFile%, %ib_ScriptName%, PasswordLen
	ib_AutoBlockTimer := ib_AutoBlockTimer_tmp
	IniWrite, %ib_AutoBlockTimer%, %ConfigFile%, %ib_ScriptName%, AutoBlockTimer
	IniWrite, %ib_RunBeforeBlocking%, %ConfigFile%, %ib_ScriptName%, RunBeforeBlocking
	IniWrite, %ib_RunBeforeBlockingParameters%, %ConfigFile%, %ib_ScriptName%, RunBeforeBlockingParameters
	IniWrite, %ib_KillAfterUnBlocking%, %ConfigFile%, %ib_ScriptName%, KillAfterUnBlocking
	IniWrite, %ib_RunParameter%, %ConfigFile%, %ib_ScriptName%, RunParameter
	IniWrite, %ib_ShadeScreen%, %ConfigFile%, %ib_ScriptName%, ShadeScreen
	IniWrite, %ib_ShadeTransparency%, %ConfigFile%, %ib_ScriptName%, ShadeTransparency
	IniWrite, %ib_StoreFaceRecAppRegistry%, %ConfigFile%, %ib_ScriptName%, StoreFaceRecAppRegistry
Return

AddSettings_InputBlocker:
Return
CancelSettings_InputBlocker:
Return

DoEnable_InputBlocker:
	If ib_AutoBlockTimer > 0
		SetTimer, tim_ib_IdleWatch, 10000
Return

DoDisable_InputBlocker:
	SetTimer, tim_ib_IdleWatch, Off
Return

DefaultSettings_InputBlocker:
Return
OnExitAndReload_InputBlocker:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

sub_Hotkey_InputBlocker:
	Thread, Priority, 1
	if (ib_ShadeScreen)
	{
		ib_ShadeID := GuiDefault("InputBlockerShade","+AlwaysOnTop -Caption -Border +ToolWindow -Resize +Disabled")
		Gui,Color,000000
		WinSet, Transparent, %ib_ShadeTransparency%
		Gui,Show, x%MonitorAreaLeft% y%MonitorAreaTop% w%MonitorAreaWidth% h%MonitorAreaHeight%,ShadeBlock
	}
	else
		InfoScreen(lng_ib_Blocking, "", 255,2,"$3")

	ib_RunBeforeBlocking_Deref := func_Deref(ib_RunBeforeBlocking)
	ib_RunBeforeBlockingParameters_Deref := func_Deref(ib_RunBeforeBlockingParameters)

	RegWrite, REG_SZ, HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe, Debugger, Hotkey Disabled
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableTaskMgr, 1
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation, 1
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Policies\Explorer, NoLogoff, 1
	Run, %A_Windir%\System32\RUNDLL32.EXE user32.dll`,UpdatePerUserSystemParameters

	SplitPath, ib_RunBeforeBlocking_Deref,ib_RunItem,ib_WorkingDir

	If ib_RunBeforeBlocking_Deref <>
	{
		ib_RunError = 0
		Process, Exist, %ib_RunItem%
		If ErrorLevel <> 0
		{
			IfWinNotActive, ahk_pid %ErrorLevel%
				WinActivate, ahk_pid %ErrorLevel%
		}
		Else
		{
			Run, %ib_RunBeforeBlocking_Deref% %ib_RunBeforeBlockingParameters_Deref%, %ib_WorkingDir%, % ib_RunParameter%ib_RunParameter% " UseErrorLevel", ib_RunPID
			ib_RunError := ErrorLevel
		}
	}
	WinGet, ib_ActiveWin, ID, A
	HotKey, IfWinExist, ahk_class Progman
	HotKey, $*LButton, ib_DoNothing, On
	HotKey, $*RButton, ib_DoNothing, On
	HotKey, $*MButton, ib_DoNothing, On
	HotKey, $*XButton1, ib_DoNothing, On
	HotKey, $*XButton2, ib_DoNothing, On
	HotKey, $*!Tab, ib_DoNothing, On
	HotKey, $*!+Tab, ib_DoNothing, On
	HotKey, $*!Space, ib_DoNothing, On
	HotKey, $^!Delete, ib_DoNothing, On
	HotKey, $*LWin, ib_DoNothing, On
	HotKey, $*RWin, ib_DoNothing, On
	Thread, NoTimers
	ib_Timeout_count = 0
	ib_Input =
	Loop
	{
		If A_Index = 4
			Gosub, tim_InfoScreenOff
		If AlternativeBlockMode = 0
			BlockInput, On
		Else
			BlockInput, MouseMove
		Process, Exist, taskmgr.exe
		If ErrorLevel <> 0
			WinKill ahk_pid %ErrorLevel%
		Input, ib_GetKey, T0.2 *, {Esc}{Enter}{Backspace}{Del}
		If ib_Getkey <>
		{
			ib_Input := ib_Input ib_Getkey
			ib_Timeout_count = 0
		}
		If ErrorLevel <> TimeOut
		{
			ib_Timeout_count = 0
			If ErrorLevel = Endkey:Backspace
				StringTrimRight, ib_Input, ib_Input, 1
			Else If (ErrorLevel = "Endkey:Delete")
				ib_Input =
			Else If (ErrorLevel = "EndKey:Enter")
			{
				If (func_ib_Hash(ib_Input) = ib_Password OR ib_Password = "")
					Break
				ib_Input =
				continue
			}
		}
		Else If ib_Getkey =
		{
			ib_Timeout_count++
			If ib_AcceptImmediately = 1
			{
				If (func_ib_Hash(ib_Input) = ib_Password)
					Break
			}
			If ib_Timeout_count > 3
				ib_Input =
		}
	}
	Critical, Off
	If AlternativeBlockMode = 0
		BlockInput, Off
	Else
		BlockInput, MouseMoveOff
	if(ib_NoSpecialTaskManager)
		RegDelete,HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe
	else
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe, Debugger, %ib_TaskManager%
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableTaskMgr, 0
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation, 0
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Policies\Explorer, NoLogoff, 0
	Run, %A_Windir%\System32\RUNDLL32.EXE user32.dll`,UpdatePerUserSystemParameters
	HotKey, IfWinExist, ahk_class Progman
	HotKey, $*LButton, ib_DoNothing, Off
	HotKey, $*RButton, ib_DoNothing, Off
	HotKey, $*MButton, ib_DoNothing, Off
	HotKey, $*XButton1, ib_DoNothing, Off
	HotKey, $*XButton2, ib_DoNothing, Off
	HotKey, $*!Tab, ib_DoNothing, Off
	HotKey, $*!+Tab, ib_DoNothing, Off
	HotKey, $*!Space, ib_DoNothing, Off
	HotKey, $^!Delete, ib_DoNothing, Off
	HotKey, $*LWin, ib_DoNothing, Off
	HotKey, $*RWin, ib_DoNothing, Off
	HotKey, IfWinExist
	Suspend, Off
	Gosub, sub_RestoreKeyStates
	if (ib_ShadeScreen)
		Gui, %GuiID_InputBlockerShade%:Destroy
	else
		InfoScreen(lng_ib_UnBlocking, "", 255,2,"$2")
	If ib_AutoBlockTimer > 0
		SetTimer, tim_ib_IdleWatch, 10000
	If (ib_KillAfterUnBlocking = 1 AND ib_RunError = 0 )
	{
		Process, Exist, %ib_RunItem%
		If ErrorLevel <> 0
		{
			WinKill, ahk_pid %ErrorLevel%
			WinClose, ahk_pid %ErrorLevel%
		}
	}
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

ib_DoNothing:
Return

tim_ib_IdleWatch:
	If ib_AutoBlockTimer > 0
	{
		ib_AutoBlockTimer_calc := ib_AutoBlockTimer
		If ib_AutoBlockTimer_calc > 59
		{
			ib_AutoBlockTimer_calc := ib_AutoBlockTimer_calc*15-840
		}
		If ((ib_AutoBlockOnPhysicalIdle = 1 AND A_TimeIdlePhysical > ib_AutoBlockTimer_calc*60000) OR (ib_AutoBlockOnPhysicalIdle = 0 AND A_TimeIdle > ib_AutoBlockTimer_calc*60000))
			Gosub, sub_Hotkey_InputBlocker
	}
Return

func_ib_Hash(sData, SID = 3)   ; SID: 3 for MD5, 4 for SHA
{
	nLen := StrLen(sData)
	DllCall("advapi32\CryptAcquireContextA", "UintP", hProv, "Uint", 0, "Uint", 0, "Uint", 1, "Uint", 0xF0000000)
	DllCall("advapi32\CryptCreateHash", "Uint", hProv, "Uint", 0x8000|0|SID , "Uint", 0, "Uint", 0, "UintP", hHash)

	DllCall("advapi32\CryptHashData", "Uint", hHash, "Uint", &sData, "Uint", nLen, "Uint", 0)

	DllCall("advapi32\CryptGetHashParam", "Uint", hHash, "Uint", 2, "Uint", 0, "UintP", nSize, "Uint", 0)
	VarSetCapacity(HashVal, nSize, 0)
	DllCall("advapi32\CryptGetHashParam", "Uint", hHash, "Uint", 2, "Uint", &HashVal, "UintP", nSize, "Uint", 0)

	DllCall("advapi32\CryptDestroyHash", "Uint", hHash)
	DllCall("advapi32\CryptReleaseContext", "Uint", hProv, "Uint", 0)

	SetFormat, Integer, H
	Loop, %nSize%
	{
		nValue := *(&HashVal + A_Index - 1)
		StringReplace, nValue, nValue, 0x, % (nValue < 16 ? 0 :)
		sHash .= nValue
	}
	SetFormat, Integer, d

	Return sHash
}
