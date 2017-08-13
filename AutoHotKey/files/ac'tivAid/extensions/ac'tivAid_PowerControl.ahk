; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               PowerControl
; -----------------------------------------------------------------------------
; Prefix:             pc_
; Version:            0.5
; Date:               2008-05-24
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_PowerControl:
	Prefix = pc
	%Prefix%_ScriptName    = PowerControl
	%Prefix%_ScriptVersion = 0.5
	%Prefix%_Author        = Wolfgang Reszel

	IconFile_On_PowerControl = %A_WinDir%\system32\powercfg.cpl
	IconPos_On_PowerControl = 4

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %pc_ScriptName% - Powermanagement-Funktionen
		Description                   = Bietet Tastaturkürzel für verschiedene Powermanagement-Funktion wie Computer ausschalten, Monitor in Standby versetzen, Bildschirmschoner starten und mehr.
		lng_pc_ShutDown               = Computer ausschalten
		lng_pc_Reboot                 = Computer neu starten
		lng_pc_Standby                = Computer in Standby schalten
		lng_pc_Hibernate              = Computer in den Ruhezustand schalten
		lng_pc_Screensaver            = Bildschirmschoner starten
		lng_pc_SecureScreensaver      = Kennwortgeschützter Bildschirmschoner
		lng_pc_DisplaySleep           = Bildschirm in Standby-Modus versetzen
		lng_pc_DisplayOff             = Bildschirm ausschalten (falls möglich)
		lng_pc_Logoff                 = Benutzer abmelden
		lng_pc_DoDisplaySleep         = Der Bildschirm wird in wenigen Augenblicken`nin den Standby-Modus geschaltet ...
		lng_pc_DoDisplayOff           = Falls der Bildschirm es unterstützt,`nwird er in wenigen Augenblicken ausgeschaltet ...
		lng_pc_DoShutdown             = Der Computer wird ausgeschaltet,`nsobald folgende Prozesse abgeschlossen wurden ...`n`n
		lng_pc_Times                  = Verzögerung (s)
		lng_pc_DisplaySleepTimeout    = Bildschirm in Standby-Modus
		lng_pc_DisplayOffTimeout      = Bildschirm ausschalten
		lng_pc_LockWorkStation        = Arbeitsstation sperren
		lng_pc_AlwaysExecuteOnShutDown= Herunterfahren-Aktion (z.B. <OnShutDown> in UserHotkeys) auch vor Standby/Ruhezustand ausführen
	}
	else        ; = other languages (english)
	{
		MenuName                      = %pc_ScriptName% - power-management
		Description                   = Provides hotkeys for power-management like shutdown computer, monitor stand-by, start Screensaver and more.
		lng_pc_ShutDown               = Shutdown
		lng_pc_Reboot                 = Reboot
		lng_pc_Standby                = Stand-by
		lng_pc_Hibernate              = Hibernate
		lng_pc_Screensaver            = Start Screensaver
		lng_pc_SecureScreensaver      = Password protected Screensaver
		lng_pc_DisplaySleep           = Set display to stand-by
		lng_pc_DisplayOff             = Turn off display (if possible)
		lng_pc_Logoff                 = Logoff
		lng_pc_DoDisplaySleep         = The display will set to stand-by`nwithin the next few seconds ...
		lng_pc_DoDisplayOff           = The display will be turned off (if supported)`nwithin the next few seconds ...
		lng_pc_DoShutdown             = The computer will be turned off`nafter finishing the following processes ...`n`n
		lng_pc_Times                  = Delay (s)
		lng_pc_DisplaySleepTimeout    = Display set to stand-by
		lng_pc_DisplayOffTimeout      = Display turned off
		lng_pc_LockWorkStation        = Lock workstation
		lng_pc_AlwaysExecuteOnShutDown= Execute shutdown-actions (eg. <OnShutDown> in UserHotkeys) also before Standby/Hibernate
	}
	If CustomLanguage <>
		gosub, CustomLanguage

	func_HotkeyRead( "pc_ShutDown",         ConfigFile, pc_ScriptName, "ShutDown",          "pc_sub_ShutDown",         "^#PgDn" )
	func_HotkeyRead( "pc_Reboot",           ConfigFile, pc_ScriptName, "Reboot",            "pc_sub_Reboot",           "^#PgUp" )
	func_HotkeyRead( "pc_Standby",          ConfigFile, pc_ScriptName, "Standby",           "pc_sub_Standby",          "#+Pause" )
	func_HotkeyRead( "pc_Hibernate",        ConfigFile, pc_ScriptName, "Hibernate",         "pc_sub_Hibernate",        "^#CtrlBreak" )
	func_HotkeyRead( "pc_Screensaver",      ConfigFile, pc_ScriptName, "Screensaver",       "pc_sub_Screensaver",      "+Pause" )
	func_HotkeyRead( "pc_SecureScreensaver",ConfigFile, pc_ScriptName, "SecureScreensaver", "pc_sub_SecureScreensaver","^!Pause" )
	func_HotkeyRead( "pc_DisplaySleep",     ConfigFile, pc_ScriptName, "DisplaySleep",      "pc_sub_DisplaySleep",     "#NumLock" )
	func_HotkeyRead( "pc_DisplayOff",       ConfigFile, pc_ScriptName, "DisplayOff",        "pc_sub_DisplayOff",       "#+NumLock" )
	func_HotkeyRead( "pc_Logoff",           ConfigFile, pc_ScriptName, "Logoff",            "pc_sub_Logoff",           "^#End" )
	func_HotkeyRead( "pc_LockWorkStation",  ConfigFile, pc_ScriptName, "LockWorkStation",   "pc_sub_LockWorkStation",  "" )
	IniRead, pc_SimWinHold, %ConfigFile%, %pc_ScriptName%, SimulateWinKeyOnHold, 1
	IniRead, pc_DisplaySleepTimeout, %ConfigFile%, %pc_ScriptName%, DisplaySleepTimeout, 2.5
	IniRead, pc_DisplayOffTimeout, %ConfigFile%, %pc_ScriptName%, DisplayOffTimeout, 2.5

	RegisterAdditionalSetting("pc","AlwaysExecuteOnShutDown",0)
Return

SettingsGui_PowerControl:
	func_HotkeyAddGuiControl( lng_pc_ShutDown, "pc_ShutDown",                   "xs+10 y+5 W200" )
	func_HotkeyAddGuiControl( lng_pc_Reboot, "pc_Reboot",                       "xs+10 y+5 W200" )
	func_HotkeyAddGuiControl( lng_pc_Standby, "pc_Standby",                     "xs+10 y+5 W200" )
	func_HotkeyAddGuiControl( lng_pc_Hibernate, "pc_Hibernate",                 "xs+10 y+5 W200" )
	func_HotkeyAddGuiControl( lng_pc_Logoff, "pc_Logoff",                       "xs+10 y+5 W200" )
	func_HotkeyAddGuiControl( lng_pc_Screensaver, "pc_Screensaver",             "xs+10 y+5 W200" )
	func_HotkeyAddGuiControl( lng_pc_SecureScreensaver, "pc_SecureScreensaver", "xs+10 y+5 W200" )
	func_HotkeyAddGuiControl( lng_pc_DisplaySleep, "pc_DisplaySleep",           "xs+10 y+5 W200" )
	func_HotkeyAddGuiControl( lng_pc_DisplayOff, "pc_DisplayOff",               "xs+10 y+5 W200" )
	func_HotkeyAddGuiControl( lng_pc_LockWorkStation, "pc_LockWorkStation",     "xs+10 y+5 W200" )
	Gui, Add, GroupBox, xp-205 yp+25 w550 h45, %lng_pc_Times%
	Gui, Add, Text, xp+10 yp+20, %lng_pc_DisplaySleepTimeout%:
	Gui, Add, Edit, x+5 yp-3 w32 R1 vpc_DisplaySleepTimeout gsub_CheckIfSettingsChanged, %pc_DisplaySleepTimeout%
	Gui, Add, Text, x+15 yp+3, %lng_pc_DisplayOffTimeout%:
	Gui, Add, Edit, x+5 yp-3 w32 R1 vpc_DisplayOffTimeout gsub_CheckIfSettingsChanged, %pc_DisplayOffTimeout%

Return

SaveSettings_PowerControl:
	func_HotkeyWrite( "pc_ShutDown", ConfigFile, pc_ScriptName, "ShutDown")
	func_HotkeyWrite( "pc_Reboot", ConfigFile, pc_ScriptName, "Reboot")
	func_HotkeyWrite( "pc_Standby", ConfigFile, pc_ScriptName, "Standby")
	func_HotkeyWrite( "pc_Hibernate", ConfigFile, pc_ScriptName, "Hibernate")
	func_HotkeyWrite( "pc_Screensaver", ConfigFile, pc_ScriptName, "Screensaver")
	func_HotkeyWrite( "pc_SecureScreensaver", ConfigFile, pc_ScriptName, "SecureScreensaver")
	func_HotkeyWrite( "pc_DisplaySleep", ConfigFile, pc_ScriptName, "DisplaySleep")
	func_HotkeyWrite( "pc_DisplayOff", ConfigFile, pc_ScriptName, "DisplayOff")
	func_HotkeyWrite( "pc_Logoff", ConfigFile, pc_ScriptName, "Logoff")
	func_HotkeyWrite( "pc_LockWorkStation", ConfigFile, pc_ScriptName, "LockWorkStation")
	IniWrite, %pc_DisplaySleepTimeout%, %ConfigFile%, %pc_ScriptName%, DisplaySleepTimeout
	IniWrite, %pc_DisplayOffTimeout%, %ConfigFile%, %pc_ScriptName%, DisplayOffTimeout
Return

CancelSettings_PowerControl:
Return

DoEnable_PowerControl:
	func_HotkeyEnable( "pc_ShutDown" )
	func_HotkeyEnable( "pc_Reboot" )
	func_HotkeyEnable( "pc_Standby" )
	func_HotkeyEnable( "pc_Hibernate" )
	func_HotkeyEnable( "pc_Screensaver" )
	func_HotkeyEnable( "pc_SecureScreensaver" )
	func_HotkeyEnable( "pc_DisplaySleep" )
	func_HotkeyEnable( "pc_DisplayOff" )
	func_HotkeyEnable( "pc_Logoff" )
	func_HotkeyEnable( "pc_LockWorkStation" )
Return

DoDisable_PowerControl:
	func_HotkeyDisable( "pc_ShutDown" )
	func_HotkeyDisable( "pc_Reboot" )
	func_HotkeyDisable( "pc_Standby" )
	func_HotkeyDisable( "pc_Hibernate" )
	func_HotkeyDisable( "pc_Screensaver" )
	func_HotkeyDisable( "pc_SecureScreensaver" )
	func_HotkeyDisable( "pc_DisplaySleep" )
	func_HotkeyDisable( "pc_DisplayOff" )
	func_HotkeyDisable( "pc_Logoff" )
	func_HotkeyDisable( "pc_LockWorkStation" )
Return

DefaultSettings_PowerControl:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

pc_sub_ShutDown:
	Gosub, pc_sub_CheckShutDown
	If pc_ShutDownProcesses <>
		SplashImage,,b1 cwFFFFc0 FS9 WS700 w400, %lng_pc_DoShutdown%%pc_ShutDownProcesses%
	Suspend, On
	Gosub, pc_sub_OnShutDown
	Suspend, Off
	SplashImage, Off
	Loop
	{
		ShutDown, 9
		Sleep, 3000
	}
Return

pc_sub_Reboot:
	Loop
	{
		ShutDown, 2
		Sleep, 3000
	}
Return

pc_sub_Logoff:
	Loop
	{
		ShutDown, 0
		Sleep, 3000
	}
Return

pc_sub_Standby:
	If pc_AlwaysExecuteOnShutDown = 1
	{
		Gosub, pc_sub_CheckShutDown
		If pc_ShutDownProcesses <>
			SplashImage,,b1 cwFFFFc0 FS9 WS700 w400, %lng_pc_DoShutdown%%pc_ShutDownProcesses%
		Suspend, On
		Gosub, pc_sub_OnShutDown
		Suspend, Off
		SplashImage, Off
	}
	DllCall("powrprof.dll\SetSuspendState","Int",0,"Int",0,"Int",0)
Return

pc_sub_Hibernate:
	If pc_AlwaysExecuteOnShutDown = 1
	{
		Gosub, pc_sub_CheckShutDown
		If pc_ShutDownProcesses <>
			SplashImage,,b1 cwFFFFc0 FS9 WS700 w400, %lng_pc_DoShutdown%%pc_ShutDownProcesses%
		Suspend, On
		Gosub, pc_sub_OnShutDown
		Suspend, Off
		SplashImage, Off
	}
	DllCall("powrprof.dll\SetSuspendState","Int",1,"Int",0,"Int",0)
Return

pc_sub_Screensaver:
	PostMessage, 0x0112, 0xF140, 0,, ahk_class Progman ; 0x0112 = WM_SYSCOMMAND -- 0xF140 = SC_SCREENSAVE
Return

pc_sub_SecureScreensaver:
	PostMessage, 0x0112, 0xF140, 0,, ahk_class Progman ; 0x0112 = WM_SYSCOMMAND -- 0xF140 = SC_SCREENSAVE
	Run, rundll32 user32`,LockWorkStation
Return

pc_sub_LockWorkStation:
	Run, rundll32 user32`,LockWorkStation
Return

pc_sub_DisplaySleep:
	If pc_DisplaySleepTimeout > 0
	{
		SplashImage,,b1 cwFFFFc0 FS9 WS700 w400, %lng_pc_DoDisplaySleep%
		pc_TickCount := A_TickCount
		Loop
		{
			Input, pc_GetKey, V M T%pc_DisplaySleepTimeout% I L1,, %InputEscapeKeys%
			If (pc_GetKey = Chr(27) OR ErrorLevel = "Timeout" )
				break
			If ( (A_TickCount - pc_TickCount)/1000 >= pc_DisplaySleepTimeout )
			{
				ErrorLevel = Timeout
				break
			}
		}
		SplashImage, Off
	}

	If (pc_GetKey <> Chr(27) OR ErrorLevel = "Timeout")
		PostMessage, 0x0112,  0xF170, 1,, ahk_class Progman ; 0x0112 = WM_SYSCOMMAND -- 0xF170 = SC_MONITORPOWER
Return

pc_sub_DisplayOff:
	If pc_DisplayOffTimeout > 0
	{
		SplashImage,,b1 cwFFFFc0 FS9 WS700 w400, %lng_pc_DoDisplayOff%
		Loop
		{
			Input, pc_GetKey, V M T%pc_DisplayOffTimeout% I L1,, %InputEscapeKeys%
			If (pc_GetKey = Chr(27) OR ErrorLevel = "Timeout" )
				break
			If ( (A_TickCount - pc_TickCount)/1000 >= pc_DisplayOffTimeout )
			{
				ErrorLevel = Timeout
				break
			}
		}
		SplashImage, Off
	}
	If (pc_GetKey <> Chr(27) OR ErrorLevel = "Timeout")
		PostMessage, 0x0112,  0xF170, 2,, ahk_class Progman ; 0x0112 = WM_SYSCOMMAND -- 0xF170 = SC_MONITORPOWER
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------


pc_sub_CheckShutDown:
	pc_ShutDownProcesses =
	Loop
	{
		If Extension[%A_Index%] =
			break
		Function := Extension[%A_Index%]
		If ( IsLabel("CheckShutDown_" Function) )
		{
			Gosub, CheckShutDown_%Function%
			If Result = 1
				pc_ShutDownProcesses = %pc_ShutDownProcesses%, %Function%
		}
	}
	StringTrimLeft, pc_ShutDownProcesses, pc_ShutDownProcesses, 2
Return

pc_sub_OnShutDown:
	Loop
	{
		If Extension[%A_Index%] =
			break
		Function := Extension[%A_Index%]
		If ( IsLabel("OnShutDown_" Function) )
			Gosub, OnShutDown_%Function%
	}
Return
