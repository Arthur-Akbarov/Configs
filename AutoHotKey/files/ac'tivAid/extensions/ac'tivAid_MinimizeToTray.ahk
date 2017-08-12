; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               Minimize To Tray
; -----------------------------------------------------------------------------
; Prefix:             mtt_
; Version:            0.9
; Date:               2008-05-23
; Author:             David Hilberath, Chris Mallett, Wolfgang Reszel,
;                     Michael Telgkamp
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_MinimizeToTray:
	mtt_showAllEmergencies()

	Prefix = mtt
	%Prefix%_ScriptName    = MinimizeToTray
	%Prefix%_ScriptVersion = 0.9
	%Prefix%_Author        = David Hilberath, Chris Mallett, Wolfgang Reszel, Michael Telgkamp

	CustomHotkey_MinimizeToTray =              ; automatisches benutzerdefinierbares Tastaturkürzel? (1 = ja)
	Hotkey_MinimizeToTray       =              ; Standard-Hotkey
	EnableTray_MinimizeToTray   = 1            ; Soll eine Erweiterung nicht im Tray-Menü aufgeführt werden, muss der Wert 0 betragen
	IconFile_On_MinimizeToTray  = %A_WinDir%\system32\shell32.dll
	IconPos_On_MinimizeToTray   = 40

	IniRead, mtt_oldhotkey, %ConfigFile%, %mtt_ScriptName%, Hotkey_MinimizeToTray
	if (mtt_oldhotkey!="ERROR")
	{
		IniDelete, %ConfigFile%, %mtt_ScriptName%, Hotkey_MinimizeToTray
		IniWrite, %mtt_oldhotkey%, %ConfigFile%, %mtt_ScriptName%, MinimizeToMenu
		mtt_oldhotkey =
	}

	func_HotkeyRead("mtt_MinimizeToIcon", ConfigFile, mtt_ScriptName, "MinimizeToIcon", "mtt_sub_MinimizeToIcon", "#t")
	func_HotkeyRead("mtt_MinimizeToMenu", ConfigFile, mtt_ScriptName, "MinimizeToMenu", "mtt_sub_MinimizeToMenu", "")
	func_HotkeyRead("mtt_UnHotkey", ConfigFile, mtt_ScriptName, "UnHotkeyKey", "mtt_sub_unhide", "#u")
	func_HotkeyRead("mtt_UnAllHotkey", ConfigFile, mtt_ScriptName, "UnAllHotkeyKey", "mtt_RestoreAll", "#!u")
	func_HotkeyRead("mtt_MenuHotkey", ConfigFile, mtt_ScriptName, "MenuHotkeyKey", "mtt_showMenu", "#+u")
	mtt_SeparateTrayIcons_tmp = mtt_SeparateTrayIcons
	IniRead, mtt_MaxWindows, %ConfigFile%, %mtt_ScriptName%, MaxWindows, 50
	IniRead, mtt_MaxLength, %ConfigFile%, %mtt_ScriptName%, MaxLength, 150

	IniRead, mtt_AutoHideEnabled, %ConfigFile%, %mtt_ScriptName%, AutoHideEnabled, 0
	IniRead, mtt_AHWApps, %ConfigFile%, %mtt_ScriptName%, AutoHideApps

	If (mtt_AHWApps = "ERROR" OR mtt_AHWApps = "|")
		mtt_AHWApps =
	StringReplace, mtt_AHWApps, mtt_AHWApps, |, `,, All

	;RegisterAdditionalSetting("mtt","SingleClickIcon",0)
	RegisterAdditionalSetting("mtt","asStatusBar",0)
	RegisterAdditionalSetting("mtt","SeparateTrayIcons",0)
	RegisterAdditionalSetting("mtt","showBalloonTips",1)

	WS_EX_APPWINDOW = 0x40000
	WS_EX_TOOLWINDOW = 0x80

	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MinimizeToTray_EnableMenu     = MinimizeToTray aktiv
		MenuName                      = %mtt_ScriptName% - Fenster im Tray verstecken
		Description                   = Versteckt mit einem Tastaturkürzel beliebige Fenster im Systray

		lng_mtt_maxWindows            = Max. Anzahl versteckbarer Fenster
		lng_mtt_maxLength             = Max. Länge eines Fenstertitels
		lng_mtt_UnhideButton          = Letztes wiederherstellen
		lng_mtt_Unhide                = Fenster wiederherstellen
		lng_mtt_MenuButton            = Menü anzeigen
		lng_mtt_UnhideAllButton       = Alle wiederherstellen
		lng_mtt_menuUnhideAll         = &Alle wiederherstellen
		lng_mtt_warning               = Es dürfen nicht mehr als %mtt_MaxWindows% Fenster gleichzeitig versteckt sein.
		lng_mtt_warningb              = Desktop, Taskleiste und ac'tivAid können nicht versteckt werden.
		lng_mtt_MinimizeToIcon        = Fenster als Tray-Icon minimieren
		lng_mtt_MinimizeToMenu        = Fenster in ac'tivAid Menü minimieren
		lng_mtt_SeparateTrayIcons     = Immer als separates Icon minimieren
		lng_mtt_SingleClickIcon       = Versteckte Fenster mit einem Einfachklick auf dessen Tray-Icon wiederherstellen
		lng_mtt_asStatusBar           = Icon von Fenstern, deren Titel eine Prozentangabe enthält, als Statusbar anzeigen
		lng_mtt_OwnerDrawnMenus       = Auch im Untermenü vom ac'tivAid-Tray-Menü Icons anzeigen (verursacht evtl. Fehler bei Verwendung von PastePlain etc.)
		lng_mtt_AutoHideEnabled       = Automatisches Verstecken von Fenstern aktivieren
		lng_mtt_showBalloonTips       = BalloonTips anzeigen
		lng_mtt_windowHidden          = Fenster minimiert
		lng_mtt_windowUnHidden        = Fenster wiederhergestellt
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MinimizeToTray_EnableMenu     = MinimizeToTray active
		MenuName                      = %mtt_ScriptName% - Hide windows in tray
		Description                   = Extension to hide any window in the system tray.

		lng_mtt_maxWindows            = Max. number of hidden windows
		lng_mtt_maxLength             = Max. length of window titles
		lng_mtt_UnhideButton          = Unhide Window
		lng_mtt_Unhide                = Unhide Window
		lng_mtt_MenuButton            = Show menu
		lng_mtt_UnhideAllButton       = Unhide All
		lng_mtt_menuUnhideAll         = &Unhide All Hidden Windows
		lng_mtt_warning               = No more than %mtt_MaxWindows% windows may be hidden simultaneously.
		lng_mtt_warningb              = The desktop, taskbar and ac'tivAid cannot be hidden.
		lng_mtt_MinimizeToIcon        = Minimize window to tray-icon
		lng_mtt_MinimizeToMenu        = Minimize window to ac'tivAid menu
		lng_mtt_SeparateTrayIcons     = Always minimize window to tray-icon
		lng_mtt_SingleClickIcon       = Restore windows with a single click on the tray-icons
		lng_mtt_asStatusBar           = Show icon of windows with percentage in title as Statusbar
		lng_mtt_OwnerDrawnMenus       = Also show icons in the submenu of the ac'tivAid tray menu (could cause errors while using PastePlain etc.)
		lng_mtt_AutoHideEnabled       = Automatically hide windows
		lng_mtt_showBalloonTips       = Show BalloonTips
		lng_mtt_windowHidden          = Minimized window
		lng_mtt_windowUnHidden        = Window restored
	}

	; Traymenü erweitern
	Menu, MinimizeToTray_Menu, Add, %MinimizeToTray_EnableMenu%, sub_MenuCall
	Menu, MinimizeToTray_Menu, Add, %lng_mtt_menuUnhideAll%, mtt_RestoreAll
	Menu, MinimizeToTray_Menu, Add,

	SubMenu = MinimizeToTray_Menu

	Menu, MinimizeToTray_Menu, UseErrorLevel
	mtt_hTM := MI_GetMenuHandle("MinimizeToTray_Menu")

	if _useTrayMenuIcons = 1
	{
		MI_SetMenuStyle(mtt_hTM, 0x4000000)
	}
Return

TrayClick_lng_MinimizeToTray:
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		lng_TrayClick_MinimizeToTray  = MinimizeToTray-Menü anzeigen
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		lng_TrayClick_MinimizeToTray  = Show MinimizeToTray menu
	}
Return

SettingsGui_MinimizeToTray:
	func_HotkeyAddGuiControl( lng_mtt_MinimizeToIcon, "mtt_MinimizeToIcon", "xs+10 y+8 w200" )
	func_HotkeyAddGuiControl( lng_mtt_MinimizeToMenu, "mtt_MinimizeToMenu", "xs+10 y+8 w200" )
	func_HotkeyAddGuiControl( lng_mtt_UnhideButton, "mtt_UnHotkey", "xs+10 y+8 w200" )
	func_HotkeyAddGuiControl( lng_mtt_UnhideAllButton, "mtt_UnAllHotkey", "xs+10 y+8 w200" )
	func_HotkeyAddGuiControl( lng_mtt_MenuButton, "mtt_MenuHotkey", "xs+10 y+8 w200" )

	Gui, Add, Text, w200 xs+10 y+10, %lng_mtt_maxWindows%:
	Gui, Add, Edit, yp-3 h20 gsub_CheckIfSettingsChanged X+5 vmtt_MaxWindows w40, %mtt_MaxWindows%
	Gui, Add, Text, w200 xs+10 y+8, %lng_mtt_maxLength%:
	Gui, Add, Edit, yp-3 h20 gsub_CheckIfSettingsChanged X+5 vmtt_MaxLength w40, %mtt_MaxLength%

	Gui, Add, Groupbox, w200 h130 xs+365 ys+153
	Gui, Add, Checkbox, xp+10 yp-5 w180 checked%mtt_AutoHideEnabled% vmtt_AutoHideEnabled gmtt_sub_CheckIfSettingsChanged, %lng_mtt_AutoHideEnabled%
	StringReplace, mtt_AHWApps_Box, mtt_AHWApps , `, , | , a
	Gui, Add, Listbox, w190 h90 xp-5 yp+28 vmtt_AHWApps_Box_tmp, %mtt_AHWApps_Box%
	Gui, Add, Button, y+5 w37 h15 vmtt_Add_AHWApps_Box gsub_ListBox_addApp, +
	Gui, Add, Button, x+5 w38 h15 vmtt_Remove_AHWApps_Box gsub_ListBox_remove, %MinusString%
	GoSub, mtt_sub_CheckIfSettingsChanged
Return

mtt_sub_CheckIfSettingsChanged:
	Gosub, sub_CheckIfSettingsChanged
	GuiControlGet, mtt_AutoHideEnabled_tmp,, mtt_AutoHideEnabled
	GuiControl, Enable%mtt_AutoHideEnabled_tmp%, mtt_AHWApps_Box_tmp
	GuiControl, Enable%mtt_AutoHideEnabled_tmp%, mtt_Add_AHWApps_Box
	GuiControl, Enable%mtt_AutoHideEnabled_tmp%, mtt_Remove_AHWApps_Box
Return


; wird aufgerufen, wenn im Konfigurationsdialog OK oder Übernehmen angeklickt wird
SaveSettings_MinimizeToTray:
	Gosub, mtt_RestoreAll

	if mtt_MaxWindows < 2
		mtt_MaxWindows = 2

	if mtt_MaxLength < 10
		mtt_MaxLength = 10

	func_HotkeyWrite("mtt_MinimizeToIcon", ConfigFile, mtt_ScriptName, "MinimizeToIcon" )
	func_HotkeyWrite("mtt_MinimizeToMenu", ConfigFile, mtt_ScriptName, "MinimizeToMenu" )
	func_HotkeyWrite("mtt_UnHotkey", ConfigFile, mtt_ScriptName, "UnHotkeyKey" )
	func_HotkeyWrite("mtt_MenuHotkey", ConfigFile, mtt_ScriptName, "MenuHotkeyKey" )
	func_HotkeyWrite("mtt_UnAllHotkey", ConfigFile, mtt_ScriptName, "UnAllHotkeyKey" )
	IniWrite, %mtt_MaxWindows%, %ConfigFile%, %mtt_ScriptName%, MaxWindows
	IniWrite, %mtt_MaxLength%, %ConfigFile%, %mtt_ScriptName%, MaxLength

	If (func_StrLeft(mtt_AHWApps_Box,1) = "|")
		StringTrimleft, mtt_AHWApps_Box, mtt_AHWApps_Box, 1
	StringReplace, mtt_AHWApps, mtt_AHWApps_Box, | , `, , a
	IniWrite, %mtt_AHWApps%, %ConfigFile%, %mtt_ScriptName%, AutoHideApps
	IniWrite, %mtt_AutoHideEnabled%, %ConfigFile%, %mtt_ScriptName%, AutoHideEnabled
Return

; Wird aufgerufen, wenn Einstellungen über das 'Pfeil'-Menü hinzugefügt werden, ist nur notwendig wenn AddSettings_MinimizeToTray = 1
AddSettings_MinimizeToTray:
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_MinimizeToTray:
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_MinimizeToTray:
	func_HotkeyEnable("mtt_MinimizeToIcon")
	func_HotkeyEnable("mtt_MinimizeToMenu")
	func_HotkeyEnable("mtt_UnHotkey")
	func_HotkeyEnable("mtt_MenuHotkey")
	func_HotkeyEnable("mtt_UnAllHotkey")

	If mtt_WindowCount > 0
		SetTimer, mtt_tim_WatchRestore, 50

	registerAction("MinimizeToTray",lng_mtt_Hide,"mtt_sub_MinimizeToTray")
	registerAction("MinimizeToIcon",lng_mtt_MinimizeToIcon,"mtt_sub_MinimizeToIcon")
	registerAction("MinimizeToTray_UnHide",lng_mtt_Unhide,"mtt_sub_unhide")
	registerEvent("CreateWindow","mtt_event_createWindow")

	mtt_hWnd := shellhook_hWnd

	if mtt_AutoHideEnabled = 1
		gosub, mtt_tim_ahw
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern der Einstellungen aufgerufen
DoDisable_MinimizeToTray:
	Gosub, mtt_RestoreAll
	func_HotkeyDisable("mtt_MinimizeToIcon")
	func_HotkeyDisable("mtt_MinimizeToMenu")
	func_HotkeyDisable("mtt_UnHotkey")
	func_HotkeyDisable("mtt_MenuHotkey")
	func_HotkeyDisable("mtt_UnAllHotkey")
	SetTimer, mtt_tim_WatchRestore, Off

	unRegisterAction("MinimizeToTray")
	unRegisterAction("MinimizeToIcon")
	unRegisterAction("MinimizeToTray_UnHide")
	mtt_showAllEmergencies()
Return

; wird aufgerufen, wenn der Anwender die Erweiterung auf die Standard-Einstellungen zurücksetzt
DefaultSettings_MinimizeToTray:
	Gosub, mtt_RestoreAll
	mtt_showAllEmergencies()
Return

; wird aufgerufen, wenn ac'tivAid beendet oder neu geladen wird.
OnExitAndReload_MinimizeToTray:
	Gosub, mtt_RestoreAll
	mtt_showAllEmergencies()
Return

Update_MinimizeToTray:
Return


; -----------------------------------------------------------------------------
; === AutoHideRoutines ========================================================
; -----------------------------------------------------------------------------

mtt_tim_ahw:
	SetTimer, mtt_tim_ahw, Off
	DetectHiddenWindows, Off
	WinGet, mtt_ids, list,,, Program Manager
	Loop, %mtt_ids%
	{
		 mtt_this_id := mtt_ids%A_Index%
		 WinGet, mtt_tim_procName, ProcessName, ahk_id %mtt_this_id%

		 IfInString,mtt_DontAHWApps,%mtt_tim_procName%
			continue

		 IfInString,mtt_AHWApps,%mtt_tim_procName%
		 {
			WinActivate, ahk_id %mtt_this_id%
			gosub, mtt_sub_MinimizeToTray
		 }
	}
return

mtt_event_createWindow:
	IfInString,mtt_DontAHWApps,%event_createWindow%
		return

	IfInString,mtt_AHWApps,%event_createWindow%
	{
		WinActivate, ahk_id %event_createWindow_ahkId%
		gosub, mtt_sub_MinimizeToTray
	}
return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

TrayClick_MinimizeToTray:
	Gosub, mtt_showMenu
Return

mtt_showMenu:
	mtt_Suspend = %A_IsSuspended%
	If mtt_Suspend = 0
		Suspend, On
	MI_ShowMenu(mtt_hTM)
	If mtt_Suspend = 0
		Suspend, Off
return

mtt_sub_MinimizeToIcon:
	mtt_SeparateTrayIcons_tmp = 1
	Gosub, mtt_sub_MinimizeToTray
	mtt_SeparateTrayIcons_tmp = mtt_SeparateTrayIcons
Return

mtt_sub_MinimizeToMenu:
	mtt_SeparateTrayIcons_tmp := mtt_SeparateTrayIcons
	Gosub, mtt_sub_MinimizeToTray
Return

mtt_sub_MinimizeToTray:
	Critical
	if mtt_WindowCount >= %mtt_MaxWindows%
	{
		Critical, Off
		BalloonTip( mtt_ScriptName, lng_mtt_warning, "Warning", 0, 0, 5 )
		return
	}

	; Set the "last found window" to simplify and help performance.
	; Since in certain cases it is possible for there to be no active window,
	; a timeout has been added:
	WinWait, A,, 2
	if ErrorLevel <> 0  ; It timed out, so do nothing.
		return

	; Otherwise, the "last found window" has been set and can now be used:
	WinGet, mtt_ActiveID, ID
	WinGet, mtt_pid, PID, ahk_id %mtt_ActiveID%
	WinGet, mtt_es, ExStyle, ahk_id %mtt_ActiveID%
	WinGetTitle, mtt_ActiveTitle
	WinGetClass, mtt_ActiveClass

	if mtt_ActiveClass in Shell_TrayWnd,Progman,AutoHotkeyGUI
	{
		Critical, Off
		BalloonTip( mtt_ScriptName, lng_mtt_warningb, "Warning", 0, 0, 5 )
		return
	}

	If ( ( ! DllCall( "GetWindow", "uint", wid, "uint", GW_OWNER ) and ! ( mtt_es & WS_EX_TOOLWINDOW ) )
			or ( mtt_es & WS_EX_APPWINDOW ) )
		mtt_name := GetModuleFileNameEx( mtt_pid )

	; If the title is blank, use the class instead.  This serves two purposes:
	; 1) A more meaningful name is used as the menu name.
	; 2) Allows the menu item to be created (otherwise, blank items wouldn't
	;    be handled correctly by the various routines below).
	if mtt_ActiveTitle =
		mtt_ActiveTitle = ahk_class %mtt_ActiveClass%
	; Ensure the title is short enough to fit. mtt_ActiveTitle also serves to
	; uniquely identify this particular menu item.
	StringLeft, mtt_ActiveTitle, mtt_ActiveTitle, %mtt_MaxLength%

	; First, ensure that this ID doesn't already exist in the list, which can
	; happen if a particular window was externally unhidden (or its app unhid
	; it) and now it's about to be re-hidden:
	mtt_AlreadyExists = n
	Loop, %mtt_MaxWindows%
	{
		if mtt_WindowID%a_index% = %mtt_ActiveID%
		{
			mtt_AlreadyExists = y
			break
		}
	}

	mtt_ActiveUniqueTitle := 0
	; Add the item to the array and to the menu:
	if mtt_AlreadyExists = n
	{
		; In addition to the tray menu requiring that each menu item name be
		; unique, it must also be unique so that we can reliably look it up in
		; the array when the window is later unhidden.  So make it unique if it
		; isn't already:
		Loop, %mtt_MaxWindows%
		{
			if mtt_WindowTitle%a_index% = %mtt_ActiveTitle%
			{
				mtt_ActiveTitle := mtt_buildUniqueTitle(mtt_ActiveTitle,mtt_ActiveID)
				mtt_ActiveUniqueTitle := 1
				break
			}
		}

		Menu, MinimizeToTray_Menu, add, %mtt_ActiveTitle%, mtt_RestoreFromTrayMenu

		mtt_WindowCount += 1
		Loop, %mtt_MaxWindows%  ; Search for a free slot.
		{
			; It should always find a free slot if things are designed right.
			if mtt_WindowID%a_index% =  ; An empty slot was found.
			{
				mtt_WindowID%a_index% = %mtt_ActiveID%
				mtt_WindowTitle%a_index% = %mtt_ActiveTitle%
				mtt_HasUniqueTitle%a_index% = %mtt_ActiveUniqueTitle%

				if mtt_name !=
				{
					mtt_pos := A_Index +3
					mtt_hicon := GetSmallIcon("ahk_id " mtt_ActiveID)

					if _useTrayMenuIcons = 1
					{
						MI_SetMenuItemIcon(mtt_hTM, mtt_pos, mtt_hicon, 0, 16)
					}

					If mtt_SeparateTrayIcons_tmp = 1
						mtt_hTrayIcon%a_index% := Tray_Add( mtt_hWnd, "mtt_sub_unhideSeperate", mtt_hicon, mtt_ActiveTitle)
				}
				mtt_lastHiddenWindowList = %mtt_lastHiddenWindowList%%a_index%|
				SetTimer, mtt_tim_WatchRestore, 50

				break
			}
		}
	}

	; Because hiding the window won't deactivate it, activate the window
	; beneath this one (if any). I tried other ways, but they wound up
	; activating the task bar.  This way sends the active window (which is
	; about to be hidden) to the back of the stack, which seems best:
	Send, !{esc}
	; Hide it only now that WinGetTitle/WinGetClass above have been run (since
	; by default, those commands cannot detect hidden windows):
	WinHide

	if mtt_showBalloonTips = 1
	{
		;BalloonTip( mtt_ScriptName, lng_mtt_windowHidden ":`n" mtt_ActiveTitle,IconFile_On_MinimizeToTray "|" IconPos_On_MinimizeToTray, 0, 0, 3 )
		BalloonTip( mtt_ScriptName, lng_mtt_windowHidden ":`n" mtt_ActiveTitle,"Info", 0, 0, 3 )
	}


	FileAppend, %mtt_ActiveID%|, %SettingsDir%/MinToTray.lst
Return

mtt_sub_unhide:
	Critical
	if (mtt_WindowCount > 0)
	{
		Loop, parse, mtt_lastHiddenWindowList, |
		{
			if A_LoopField !=
				mtt_lastWindow := A_LoopField
		}
		mtt_unhide(mtt_lastWindow)
	}
Return

mtt_sub_unhideSeperate:
	Critical
	if Tray_EVENT = L
	{
		Loop, %mtt_MaxWindows%
		{
			if mtt_hTrayIcon%a_index% = %Tray_HWND%
			{
				mtt_unhide(a_index)
				break
			}
		}
	}
	else
	if Tray_EVENT = R
	{
		gosub, mtt_showMenu
	}
return

mtt_RestoreAll:
	Critical
	Loop, %mtt_MaxWindows%
	{
		if mtt_WindowID%a_index% <>
			mtt_unhide(a_index)

		if mtt_WindowCount = 0
			break
	}
return

mtt_RestoreFromTrayMenu:
	Critical
	; Find window based on its unique title stored as the menu item name:
	Loop, %mtt_MaxWindows%
	{
		;msgbox % mtt_windowTitle%A_Index%
		if (mtt_WindowTitle%a_index% = A_ThisMenuItem)  ; Match found.
		{
			Menu, MinimizeToTray_Menu, delete, %A_ThisMenuItem%
			mtt_IDToRestore := mtt_WindowID%a_index%

			DetectHiddenWindows On
			WinGet, mtt_unh_procName, ProcessName, ahk_id %mtt_IDToRestore%

			IfInString,mtt_AHWApps,%mtt_unh_procName%
				mtt_DontAHWApps = %mtt_DontAHWApps%%mtt_unh_procName%|
			DetectHiddenWindows Off

			mtt_unhide(a_index)
			return
		}
	}
return

mtt_tim_WatchRestore:
	If mtt_WindowCount = 0
	{
		SetTimer, mtt_tim_WatchRestore, Off
		return
	}

	Loop, %mtt_MaxWindows%
	{
		mtt_ActiveID := mtt_WindowID%a_index%

		If mtt_ActiveID =
			Continue

		DetectHiddenWindows, On
		WinGetTitle, mtt_ActiveTitle, ahk_id %mtt_ActiveID%

		if mtt_HasUniqueTitle%a_index% = 1
			mtt_ActiveTitle := mtt_buildUniqueTitle(mtt_ActiveTitle,mtt_ActiveID)

		if (mtt_WindowTitle%a_index% != mtt_ActiveTitle)
		{
			mtt_toRename := mtt_WindowTitle%a_index%
			mtt_WindowTitle%a_index% = %mtt_ActiveTitle%
			Menu, MinimizeToTray_Menu, rename, %mtt_toRename%, %mtt_ActiveTitle%

			if mtt_hTrayIcon%a_index% !=
			{
				if(mtt_asStatusBar and inStr(mtt_ActiveTitle,"%"))
					mtt_percentage := RegExReplace(mtt_ActiveTitle, ".*?(\d{1,3}).{0,1}%.*", "$1")

				If mtt_percentage !=
				{
					hIcon := GetSmallIcon("ahk_id " %mtt_ActiveID%, "", mtt_percentage)
					Tray_Modify( mtt_hWnd, mtt_hTrayIcon%a_index%, hIcon, mtt_ActiveTitle)
				}
			}
		}

		DetectHiddenWindows, Off
		IfWinExist, % "ahk_id " mtt_WindowID%a_index%
		{
			Menu, MinimizeToTray_Menu, delete, % mtt_WindowTitle%a_index%

			if mtt_hTrayIcon%a_index% !=
				Tray_Remove( mtt_hWnd, mtt_hTrayIcon%a_index%)

			StringReplace, mtt_lastHiddenWindowList,mtt_lastHiddenWindowList,%a_index%|
			mtt_hTrayIcon%a_index% =
			mtt_WindowID%a_index% =  ; Make it blank to free up a slot.
			mtt_WindowTitle%a_index% =
			mtt_HasUniqueTitle%a_index% =
			mtt_WindowCount -= 1
			break
		}

		DetectHiddenWindows, On
		IfWinNotExist, % "ahk_id " mtt_WindowID%a_index%
		{
			Menu, MinimizeToTray_Menu, delete, % mtt_WindowTitle%a_index%

			if mtt_hTrayIcon%a_index% !=
				Tray_Remove( mtt_hWnd, mtt_hTrayIcon%a_index%)

			StringReplace, mtt_lastHiddenWindowList,mtt_lastHiddenWindowList,%a_index%|
			mtt_hTrayIcon%a_index% =
			mtt_WindowID%a_index% =  ; Make it blank to free up a slot.
			mtt_WindowTitle%a_index% =
			mtt_HasUniqueTitle%a_index% =
			mtt_WindowCount -= 1
			break
		}
	}
Return

mtt_unhide(num)
{
	Global
	Critical

	; Get the id of the last window minimized and unhide it
	mtt_IDToRestore := mtt_WindowID%num%

	IfInString,mtt_AHWApps,%mtt_unh_procName%
		mtt_DontAHWApps = %mtt_DontAHWApps%%mtt_unh_procName%|

	DetectHiddenWindows On
	WinShow, ahk_id %mtt_IDToRestore%
	WinActivate ahk_id %mtt_IDToRestore%

	WinGet, mtt_unh_procName, ProcessName, ahk_id %mtt_IDToRestore%
	DetectHiddenWindows Off
	; Get the menu name of the last window minimized and remove it
	MenuToRemove := mtt_WindowTitle%num%

	if mtt_showBalloonTips = 1
	{
		Critical Off
		;BalloonTip( mtt_ScriptName, lng_mtt_windowUnHidden ":`n" MenuToRemove,IconFile_On_MinimizeToTray "|" IconPos_On_MinimizeToTray, 0, 0, 3 )
		BalloonTip( mtt_ScriptName, lng_mtt_windowUnHidden ":`n" MenuToRemove,"Info", 0, 0, 3 )
	}
	Critical On

	if MenuToRemove !=
	{
		Menu, MinimizeToTray_Menu, delete, %MenuToRemove%
		StringReplace, mtt_lastHiddenWindowList,mtt_lastHiddenWindowList,%num%|

		if mtt_hTrayIcon%num% !=
			Tray_Remove( mtt_hWnd, mtt_hTrayIcon%num%)

		;; clean up our 'arrays' and decrement the window count
		mtt_hTrayIcon%num% =
		mtt_WindowID%num% =
		mtt_WindowTitle%num% =
		mtt_HasUniqueTitle%num% =
		mtt_WindowCount -= 1
	}
	mtt_busy := 0
}
mtt_buildUniqueTitle(mtt_ActiveTitle,mtt_ActiveID)
{
	Global mtt_MaxLength

	; Match found, so it's not unique.
	; First remove the 0x from the hex number to conserve menu space:
	StringTrimLeft, mtt_ActiveIDShort, mtt_ActiveID, 2
	StringLen, mtt_ActiveIDShortLength, mtt_ActiveIDShort
	StringLen, mtt_ActiveTitleLength, mtt_ActiveTitle
	mtt_ActiveTitleLength += %mtt_ActiveIDShortLength%
	mtt_ActiveTitleLength += 1 ; +1 the 1 space between title & ID.
	if mtt_ActiveTitleLength > %mtt_MaxLength%
	{
		; Since menu item names are limted in length, trim the title
		; down to allow just enough room for the Window's Short ID at
		; the end of its name:
		TrimCount = %mtt_ActiveTitleLength%
		TrimCount -= %mtt_MaxLength%
		StringTrimRight, mtt_ActiveTitle, mtt_ActiveTitle, %TrimCount%
	}
	; Build unique title:
	mtt_ActiveTitle = %mtt_ActiveTitle% %mtt_ActiveIDShort%
	return mtt_ActiveTitle
}

mtt_showAllEmergencies()
{
	Global SettingsDir

	FileRead, list, %SettingsDir%/MinToTray.lst

	DetectHiddenWindows On
	Loop, parse, list, |
	{
		If A_LoopField =
			continue

		WinShow, ahk_id %A_LoopField%
		WinActivate ahk_id %A_LoopField%
	}
	DetectHiddenWindows Off
	FileDelete, %SettingsDir%/MinToTray.lst
}


GetModuleFileNameEx( p_pid )
{
	if (aa_osversionnumber < aa_osversionnumber_2000)
	{
		Debug("MinimizeToTray",A_LineNumber,A_LineFile,"This Windows version (" A_OSVersion ") is not supported.")
		return
	}

	/*
		#define PROCESS_VM_OPERATION      (0x0008)
		#define PROCESS_VM_READ           (0x0010)
		#define PROCESS_QUERY_INFORMATION (0x0400)
	*/
	h_process := DllCall( "OpenProcess", "uint", 0x8|0x10|0x400, "int", false, "uint", p_pid )
	if ( ErrorLevel or h_process = 0 )
	{
		Debug("MinimizeToTray",A_LineNumber,A_LineFile,"[OpenProcess] failed")
		return
	}

	name_size = 255
	VarSetCapacity( name, name_size )

	result := DllCall( "psapi.dll\GetModuleFileNameExA", "uint", h_process, "uint", 0, "str", name, "uint", name_size )
	if ( ErrorLevel or result = 0 )
		Debug("MinimizeToTray",A_LineNumber,A_LineFile,"[GetModuleFileNameExA] failed")

	DllCall( "CloseHandle", h_process )

	return, name
}
