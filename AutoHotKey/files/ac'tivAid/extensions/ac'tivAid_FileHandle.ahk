; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               FileHandle
; -----------------------------------------------------------------------------
; Prefix:             fh_
; Version:            0.1.1
; Date:               2008-05-08
; Author:             David Hilberath
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_FileHandle:
	Prefix = fh
	%Prefix%_ScriptName    = FileHandle
	%Prefix%_ScriptVersion = 0.1.1
	%Prefix%_Author        = David Hilberath

	CustomHotkey_FileHandle = 0
	IconFile_On_FileHandle  = %A_WinDir%\System32\hotplug.dll
	IconPos_On_FileHandle   = 1

	EnableTray_FileHandle = 0

	Gosub, LanguageCreation_FileHandle
	Gosub, LoadSettings_FileHandle
	Gosub, CreateMenus_FileHandle
	Gosub, fh_checkHandleExe
	CreateGuiID("FileHandle_Handles")
Return

LanguageCreation_FileHandle:
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %fh_ScriptName% - Zeigt geöffnete Dateien
		Description                   = Zeigt alle geöffneten Dateien.`nErweitert RemoveDriveHotkey. Benötigt SysInternals Handle.

		fh_notFunctional              = Diese Erweiterung ist nicht funktionsfähig.`nhandle.exe nicht gefunden oder keine Administratorrechte verfügbar.
		lng_fh_listview_header        = Datei|Prozess|PID|Benutzer|HID
		lng_fh_handleWindow           = Geöffnete Dateien
		lng_fh_button_khandle         = Alle Handles beenden
		lng_fh_button_kprocess        = Alle Prozesse beenden
		lng_fh_button_kclose          = Alle Fenster schließen
		lng_fh_button_refresh         = Aktualisieren
		lng_fh_button_retry           = Erneut versuchen
		lng_fh_button_all             = Alle
		lng_fh_fileopen               = handle.exe auswählen
		lng_fh_fileopentype           = SysInternals handle.exe (*.exe)
		lng_fh_PathToHandleExe        = Pfad zur handle.exe
		lng_fh_addfeatures            = Zusätzliche Funktionalität
		lng_fh_AdditionalFunctions    = Bitte das Tool 'Handle' herunterladen (Link).
		lng_fh_switchtoApp            = Wechseln zu
		lng_fh_closeApp               = Schließen
		lng_fh_killproc               = Prozess beenden
		lng_fh_killhandle             = Handle schließen
		lng_fh_requireAdmin           = Administratorrechte benötigt
		lng_fh_installed              = Einsatzbereit.
		lng_fh_passive                = Dies ist eine passive Erweiterung, deren Hauptaufgabe es ist anderen Erweiterungen Dateifunktionen zu ermöglichen.
		lng_fh_ActionDesc             = Handles anzeigen
		lng_fh_EnableHandleHandling   = Blockierende Handles zeigen
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %fh_ScriptName% - Shows files with open handle
		Description                   = Shows all opened files.`nExtends RemoveDriveHotkey. Requires SysInternals Handle.

		fh_notFunctional              = This extension is not fuctional.`nhandle.exe not found, or no admin rights available.
		lng_fh_listview_header        = File|Process|PID|User|HID
		lng_fh_handleWindow           = Open Files
		lng_fh_button_khandle         = Close all handles
		lng_fh_button_kprocess        = Close all processes
		lng_fh_button_kclose          = Close all windows
		lng_fh_button_refresh         = Refresh
		lng_fh_button_retry           = Retry
		lng_fh_button_all             = all
		lng_fh_fileopen               = Select handle.exe
		lng_fh_fileopentype           = SysInternals handle.exe (*.exe)
		lng_fh_PathToHandleExe        = Path to handle.exe
		lng_fh_addfeatures            = Additional functionality
		lng_fh_AdditionalFunctions    = Please download "SysInternals Handle" (Link).
		lng_fh_switchtoApp            = Switch to
		lng_fh_closeApp               = Close
		lng_fh_killproc               = End process
		lng_fh_killhandle             = Close handle
		lng_fh_requireAdmin           = Requires administrative rights
		lng_fh_installed              = Ready.
		lng_fh_passive                = This is a passive extension, mainly to provide file handling functionality to other extensions.
		lng_fh_ActionDesc             = Show handles
		lng_fh_EnableHandleHandling   = Show blocking handles
	}


return

SettingsGui_FileHandle:
	; func_HotkeyAddGuiControl( lng_fh_TEXT, "fh_HOTKEYNAME", "xs+10 y+10 w160" )
	; Gui, Add, Edit, xs+10 y+5 gsub_CheckIfSettingsChanged vfh_var, %lng_fh_text%
	gosub, fh_checkHandleExe

	Gui, Add, Text, xs+10 ys+15, %lng_fh_passive%
	if (fh_HandleExeFound="")
	{
		Gui, Add, Text, y+8 gfh_goToSysInternals, Status: %lng_fh_AdditionalFunctions%

		Gui, Add, Text, y+15, %lng_fh_PathToHandleExe%
		Gui, Add, Edit, x+5 yp-2 R1 -Wrap w300 gsub_CheckIfSettingsChanged vfh_HandleExe, %fh_HandleExe%
		Gui, Add, Button, x+5 w30 h21 gfh_browseForHandleExe -Wrap, ...
		Return
	}

	if (A_IsAdmin != 1)
	{
		Gui, Add, Text, y+8, Status: %lng_fh_requireAdmin%
		Return
	}

	Gui, Add, Text, y+8, Status: %lng_fh_installed%
Return



CreateMenus_FileHandle:
	Menu, fh_context, Add, %lng_fh_switchtoApp%, fh_switchToApp
	Menu, fh_context, Add, %lng_fh_closeApp%, fh_closeApp
	Menu, fh_context, Add, %lng_fh_killproc%, fh_killProc
	Menu, fh_context, Add, %lng_fh_killhandle%, fh_killHndl

	Menu, fh_allMenu, Add, %lng_fh_button_khandle%, fh_killAllHandles
	Menu, fh_allMenu, Add, %lng_fh_button_kprocess%, fh_killAllProcesss
	Menu, fh_allMenu, Add, %lng_fh_button_kclose%, fh_closeAllProcesss
Return

LoadSettings_FileHandle:
	; Check if old RDH settings exist and delete them if they are set
	IniRead, fh_HandleExe, %ConfigFile%, RemoveDriveHotkey, HandleExePath
	if ( fh_HandleExe != "ERROR" )
	{
		IniWrite, %fh_HandleExe%, %ConfigFile%, %fh_ScriptName%, HandleExePath
		IniDelete, %ConfigFile%, RemoveDriveHotkey, HandleExePath
	}
	IniRead, fh_HandleExe, %ConfigFile%, %fh_ScriptName%, HandleExePath, %A_ScriptDir%\Library\Tools\handle.exe
	gosub, fh_checkHandleExe
Return

SaveSettings_FileHandle:
	IniWrite, %fh_HandleExe%, %ConfigFile%, %fh_ScriptName%, HandleExePath
Return

AddSettings_FileHandle:
Return

CancelSettings_FileHandle:
Return

DoEnable_FileHandle:
	gosub, fh_checkHandleExe

	if fh_functional
	{
		RegisterAction("ShowHandles",lng_fh_ActionDesc,"fh_showHandles")
		RegisterECMenu("ShowHandles",lng_fh_ActionDesc,"fh_showHandles",fh_ScriptName)
	}
Return

DoDisable_FileHandle:
	fh_functional = 0
	unRegisterAction("ShowHandles")
Return

DefaultSettings_FileHandle:
Return

OnExitAndReload_FileHandle:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_FileHandle:
	; Hier kommen die Befehle hin, welche bei Win+F5 ausgeführt werden
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

fh_browseForHandleExe:
	FileSelectFile, fh_input_HandleExe, 3,..\Library\Tools\handle.exe,%lng_fh_fileopen%,%lng_fh_fileopentype%
	if fh_input_HandleExe =
		 return

	fh_HandleExe := fh_input_HandleExe
	GuiControl,, fh_HandleExe,%fh_HandleExe%
	func_SettingsChanged( fh_ScriptName )
return

fh_goToSysInternals:
	Run http://technet.microsoft.com/en-us/sysinternals/bb896655.aspx
return

fh_checkHandleExe:
	fh_HandleExeFound := FileExist(fh_HandleExe)

	if (fh_HandleExeFound="A" and A_IsAdmin=1)
	{
		fh_functional = 1
	}
	else
	{
		BalloonTip(fh_ScriptName, fh_notFunctional,3)
		fh_functional = 0
	}
return

; -----------------------------------------------------------------------------
; === Handle GUI ==============================================================
; -----------------------------------------------------------------------------
FileHandle_HandlesGuiEscape:
FileHandle_HandlesGuiClose:
	Gui, Destroy
return

FileHandle_HandlesGuiContextMenu:
	GuiDefault("FileHandle_Handles")
	if A_GuiControl <> fh_HandlesLV
		 return

	if A_EventInfo = 0
		return

	LV_GetText(fh_pid, A_EventInfo,3)
	LV_GetText(fh_hid, A_EventInfo,5)

	Menu, fh_context, Show
return

fh_showAllMenu:
	Menu, fh_allMenu, Show
return

fh_showHandles:
	fh_actionParameter2 =
	fh_retryAction =

	StringSplit, fh_actionParameter, ActionParameter, |

	fh_Driveletter := fh_actionParameter1
	fh_retryAction := fh_actionParameter2

	GuiDefault("FileHandle_Handles")
	Gui, Destroy
	GuiDefault("FileHandle_Handles")
	Gui, Add, ListView, x5 r20 w490 h290 vfh_HandlesLV, %lng_fh_listview_header%
	Gui, Add, Button, x5 y+5 w50 gfh_showAllMenu -Wrap, %lng_fh_button_all%

	if fh_retryAction !=
	{
		Gui, Add, Button, x290 y300 w100 vfh_refreshButton gfh_refreshHandles -Wrap, %lng_fh_button_refresh%
		Gui, Add, Button, x+5  w100 vfh_retryButton gfh_retry -Wrap, %lng_fh_button_retry%
	}
	else
	{
		Gui, Add, Button, x395 y300 w100 vfh_refreshButton gfh_refreshHandles, %lng_fh_button_refresh%
	}
	LV_ModifyCol(1,177)
	LV_ModifyCol(2,110)
	LV_ModifyCol(3,40)
	LV_ModifyCol(3, "Integer")
	LV_ModifyCol(4,140)
	LV_ModifyCol(5,0)

	gosub, fh_refreshHandles

	Gui, Show, w500 h327 Center, %lng_fh_handleWindow%
	FileDelete, %A_Temp%\RemoveDriveHandles.tmp
return

fh_retry:
	Gui, Destroy
	PerformAction(fh_retryAction,ActionParameter)
return

fh_refreshHandles:
	LV_Delete()
	;TODO: Check for other partitions on same harddisk (!)
	;dafür am besten diskpart.exe nehmen (bei windows xp dabei, wie ists bei 2000 etc?)
	;diskpart > list drive > select drive 0 [0...n] > detail drive
	RunWait,  %ComSpec% /c ""%fh_HandleExe%" -u %fh_Driveletter% > "%A_Temp%\RemoveDriveHandles.tmp"",,Hide
	;RunWait,  %ComSpec% /c ""notepad" %A_Temp%\RemoveDriveHandles.tmp",,
	fh_needle = (.*)\s*pid:\s(\d*)\s*(.*)\s\s(.*):\s(.*)
	fh_handleCount = 0
	Loop, Read, %A_Temp%\RemoveDriveHandles.tmp
	{
		If (A_Index < 6)
			continue

		RegExMatch(A_LoopReadLine,fh_needle,fh_openHandles)
		LV_ADD("", fh_openHandles5, fh_openHandles1, fh_openHandles2, fh_openHandles3, fh_openHandles4)
		fh_handleCount +=1
	}
return

; -----------------------------------------------------------------------------
; === Handle Routines =========================================================
; -----------------------------------------------------------------------------

fh_findPartitions:
	fh_dpSkript = LIST DISK
	IfExist, %A_Temp%\dpSkript.txt
		FileDelete, %A_Temp%\dpSkript.txt

	FileAppend, %fh_dpSkript%, %A_Temp%\dpSkript.txt
	RunWait,  %ComSpec% /c "diskpart /s %A_Temp%\dpSkript.txt > "%A_Temp%\RemoveDriveOutput.tmp"",,Hide
return

fh_switchToApp:
	DetectHiddenWindows, On
	IfWinExist, ahk_pid %fh_pid%
		 WinActivate

	DetectHiddenWindows, Off
return

fh_closeApp:
	DetectHiddenWindows, On
	;msgbox, %fh_pid% %fh_hid%
	;fh_hWnd := WinExist("ahk_pid %fh_pid%")
	;msgbox, %fh_hWnd%
	PostMessage, 0x112, 0xF060,,,ahk_pid %fh_pid%

	IfWinExist, ahk_pid %fh_pid%
		 WinClose


	DetectHiddenWindows, Off

	gosub, fh_refreshHandles
return

fh_killProc:
	Process, Close, %fh_pid%
	Sleep, 500
	gosub, fh_refreshHandles
return

fh_killHndl:
	;msgbox, %ComSpec% /c ""%fh_HandleExe%" -c %fh_hid% -p %fh_pid% -y"
	RunWait,  %ComSpec% /c ""%fh_HandleExe%" -c %fh_hid% -p %fh_pid% -y",,Hide
	gosub, fh_refreshHandles
return

fh_killAllHandles:
	GuiDefault("FileHandle_Handles")

	Loop, %fh_handleCount%
	{
		fh_RowNumber := A_Index

		LV_GetText(fh_pid, fh_RowNumber,3)
		LV_GetText(fh_hid, fh_RowNumber,5)

		RunWait,  %ComSpec% /c ""%fh_HandleExe%" -c %fh_hid% -p %fh_pid% -y",,Hide
	}
	gosub, fh_refreshHandles
return

fh_killAllProcesss:
	GuiDefault("FileHandle_Handles")

	Loop, %fh_handleCount%
	{
		fh_RowNumber := A_Index

		 LV_GetText(fh_pid, fh_RowNumber,3)
		 Process, Close, %fh_pid%
	}
	gosub, fh_refreshHandles
return

fh_closeAllProcesss:
	GuiDefault("FileHandle_Handles")

	Loop, %fh_handleCount%
	{
		fh_RowNumber := A_Index

		LV_GetText(fh_pid, fh_RowNumber,3)

		if fh_pid !=
			WinClose, ahk_pid %fh_pid%
		;WinWaitClose, ahk_pid %fh_pid%,,0
	}
	gosub, fh_refreshHandles
return
