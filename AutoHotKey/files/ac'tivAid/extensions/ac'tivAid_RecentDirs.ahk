; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               RecentDirs
; -----------------------------------------------------------------------------
; Prefix:             rd_
; Version:            0.9
; Date:               2008-05-23
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_RecentDirs:
	Prefix = rd
	%Prefix%_ScriptName    = RecentDirs
	%Prefix%_ScriptVersion = 0.9
	%Prefix%_Author        = Wolfgang Reszel
	RequireExtensions =

	CustomHotkey_RecentDirs = 1           ; Benutzerdefiniertes Hotkey
	Hotkey_RecentDirs       = #Backspace  ; Standard-Hotkey
	HotkeyPrefix_RecentDirs =
	IconFile_On_RecentDirs  = %A_WinDir%\system32\shell32.dll
	IconPos_On_RecentDirs   = 21

	CreateGuiID("RecentDirs")

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %rd_ScriptName% - zuletzt besuchte Verzeichnisse
		Description                   = Ein spezielles Menü listet die zuletzt besuchten Verzeichnisse auf. Es werden dabei die Recent-Verzeichnisse von Windows und Office verwendet, welche automatisch aufgeräumt werden können.
		lng_rd_NumberOfItems          = Anzahl der anzuzeigenden Verzeichnisse (neuestes Verzeichnis oben)
		lng_rd_CleanRecentDir         = RecentDirs basiert auf den Recent-Verzeichnissen (zuletzt verwendete Dateien) von Windows und MS Office.`nDie Verzeichnisse können bei jedem Aufruf gesäubert werden, wodurch RecentDirs schneller wird
		lng_rd_CleanOption1           = nicht verändern
		lng_rd_CleanOption2           = nicht angezeigte Verzeichnis-Verknüpfungen entfernen
		lng_rd_CleanOption3           = nicht angezeigte Verzeichnis- und alle Datei-Verknüpfungen entfernen
		lng_rd_CleanOption4           = Verzeichnis- und Datei-Verknüpfungen entfernen die älter sind als
		lng_rd_CleanOption5           = periodische Säuberung im Hintergrund (alle 5 Minuten)
		lng_rd_CleanOption6           = ungültige Verknüpfungen immer entfernen (z.B. gelöschte Verzeichnisse oder entfernte Wechseldatenträger)
		lng_rd_CleanOption7           = "Zuletzt verwendet" von MS Office nicht aufräumen
		lng_rd_Days                   = Tage
		lng_rd_LikeDirkey             = Einträge von LikeDirkey anzeigen
		lng_rd_LikeDirkeyOption1      = nicht anzeigen
		lng_rd_LikeDirkeyOption2      = am Anfang des Menüs
		lng_rd_LikeDirkeyOption3      = am Ende des Menüs
		lng_rd_Tooltip                = RecentDirs ...
		lng_rd_AlternativePresentation= Alternative Darstellung
		lng_rd_FolderTree             = Explorer mit Verzeichnisbaum öffnen
		lng_rd_Filter                 = Verzeichnisfilter
		lng_rd_StandardFilter         = Temp-Verzeichnisse hinzufügen
		lng_rd_FilterInfo             = Bitte in jeder Zeile ein komplettes Verzeichnis oder einen Teil das Namens angeben. Alle Verzeichnisse, in denen der Text vorkommt, werden von RecentDirs ignoriert.
		lng_rd_DeleteFiltered         = Gefilterte Verzeichnisse aus dem Recent-Verzeichnis entfernen (säubern)
		lng_rd_NumberedMenuEntries    = Zahlen statt Buchstaben im Menü verwenden
		lng_rd_EnableSubmenus         = Verzeichnisinhalt in Untermenü anzeigen
		lng_rd_forceCleanAll          = Recent-Verzeichnis komplett leeren
		lng_rd_Open                   = Öffnen
		lng_rd_openMenu               = Menü zeigen
		lng_rd_OpenMostRecent         = Letztes Verzeichnis öffnen

		tooltip_rd_AlternativePresentation = Alternative Darstellung der Verzeichnisse`nAus`t`tOrdnername`t`t`tLaufwerk`:\Verzeichnisse\`nAktiviert`tLaufwerk`:\Verzeichnisse\`tOrdnername`nGrau/Grün`tLaufwerk`:\Verzeichnisse\Ordnername

	}
	else        ; = other languages (english)
	{
		MenuName                      = %rd_ScriptName% - last visited folders
		Description                   = A special menu lists all recently used folders to let you go to them. It uses windows own recent-directory, which also could be cleaned up.
		lng_rd_NumberOfItems          = number of folders to show (newest first)
		lng_rd_CleanRecentDir         = RecentDirs is based onto windows' recent-directory.`nIt could be cleaned every time you call RecentDirs to improves its performance
		lng_rd_CleanOption1           = don't change
		lng_rd_CleanOption2           = remove all folder-entries which are not shown by the menu
		lng_rd_CleanOption3           = remove all folder- and file-entries which are not shown
		lng_rd_CleanOption4           = remove the folder- and file-shortcuts older than
		lng_rd_CleanOption5           = periodical clean-up in background (every 5 minute)
		lng_rd_CleanOption6           = always delete invalid shortcuts (deleted directories or removed media)
		lng_rd_CleanOption7           = don't clean the recent-folder of MS Office
		lng_rd_Days                   = days
		lng_rd_LikeDirkey             = show entries from LikeDirkey
		lng_rd_LikeDirkeyOption1      = no
		lng_rd_LikeDirkeyOption2      = at the top of the menu
		lng_rd_LikeDirkeyOption3      = at the bottom of the menu
		lng_rd_Tooltip                = RecentDirs ...
		lng_rd_AlternativePresentation= alternative presentation
		lng_rd_FolderTree             = open Explorer with folder tree
		lng_rd_Filter                 = Filter directories
		lng_rd_StandardFilter         = Add temporary directories
		lng_rd_FilterInfo             = Add on every line a whole directory or a part of its name. All directories which contain one of these strings will be ignored by RecentDirs.
		lng_rd_DeleteFiltered         = Delete filtered directories from the recent-directory (clean)
		lng_rd_NumberedMenuEntries    = Use digits rather than letters in the menu
		lng_rd_EnableSubmenus         = Show directory contents in a submenu
		lng_rd_forceCleanAll          = Clear all recent documents
		lng_rd_Open                   = Open
		lng_rd_openMenu               = Open menu
		lng_rd_OpenMostRecent         = Open most recent

		tooltip_rd_AlternativePresentation = alternative folder presentation`noff`t`tfolder`t`t`tdrive`:\directories\`nactive`t`tdrive`:\directories\`tfolder`ngrey/green`tfolder`:\directories\folder
	}
	If CustomLanguage <>
		gosub, CustomLanguage

	rd_IndexSymbols := "ABCDEFGHIJKLMNOPQRSTUVWXYZ "

	IniRead, rd_NumberOfItems, %ConfigFile%, %rd_ScriptName%, NumberOfItems, 10
	IniRead, rd_CleanOption, %ConfigFile%, %rd_ScriptName%, CleanOption, 1
	IniRead, rd_CleanAfter, %ConfigFile%, %rd_ScriptName%, CleanAfter, 7
	IniRead, rd_LikeDirkeyOption, %ConfigFile%, %rd_ScriptName%, LikeDirkeyOption, 1
	IniRead, rd_PeriodicCleanUp, %ConfigFile%, %rd_ScriptName%, PeriodicCleanUp, 0
	IniRead, rd_CleanNonExist, %ConfigFile%, %rd_ScriptName%, CleanNonExist, 1
	IniRead, rd_DontCleanMSO, %ConfigFile%, %rd_ScriptName%, DontCleanOfficeRecent, 0
	IniRead, rd_AlternativePresentation, %ConfigFile%, %rd_ScriptName%, AlternativeFolderPresentation, 0
	IniRead, rd_FolderTree, %ConfigFile%, %rd_ScriptName%, FolderTree, 0
	IniRead, rd_Filter, %ConfigFile%, %rd_ScriptName%, Filter, %A_Space%
	IniRead, rd_DeleteFiltered, %ConfigFile%, %rd_ScriptName%, DeletedFiltered, 1
	RegisterAdditionalSetting( "rd", "forceCleanAll", 0, "Type: SubRoutine")
	RegisterAdditionalSetting( "rd", "NumberedMenuEntries", 0 )
	RegisterAdditionalSetting( "rd", "EnableSubmenus", 0 )

	Loop, 5
	{
		rd_temp := A_Index+8
		RegRead, rd_RecentPathMSO, HKEY_CURRENT_USER,Software\Microsoft\Office\%rd_temp%.0\Common\General, RecentFiles
		If ErrorLevel = 0
		{
			IfExist, %APPDATA%\Microsoft\Office\%rd_RecentPathMSO%
			{
				rd_RecentPathMSO = %APPDATA%\Microsoft\Office\%rd_RecentPathMSO%
				break
			}
		}
	}

	totalMenuNum = 1
Return

SettingsGui_RecentDirs:
	StringReplace, rd_Filter_tmp, rd_Filter, |, `n, All
	rd_DeleteFiltered_tmp = %rd_DeleteFiltered%
	Gui, Add, Text, xs+10 y+10, %lng_rd_NumberOfItems%:
	Gui, Add, ComboBox, x+10 yp-4 w40 gsub_CheckIfSettingsChanged vrd_NumberOfItems, 5|10|15|20|25|30|35
	Gui, Add, CheckBox, -Wrap x+10 yp+4 vrd_AlternativePresentation gsub_CheckIfSettingsChanged Check3 Checked%rd_AlternativePresentation%, %lng_rd_AlternativePresentation%
	Gui, Add, CheckBox, -Wrap y+5 xs+10 vrd_FolderTree Checked%rd_FolderTree% grd_sub_CheckIfSettingsChanged, %lng_rd_FolderTree%
	Gui, Add, GroupBox, xs+10 y+0 w550 h183
	Gui, Add, Text, xp+10 yp+10, %lng_rd_CleanRecentDir%:
	Gui, Add, Radio, -Wrap y+7 Checked grd_sub_CheckIfSettingsChanged vrd_CleanOption1, %lng_rd_CleanOption1%
	Gui, Add, Radio, -Wrap y+7 grd_sub_CheckIfSettingsChanged vrd_CleanOption2, %lng_rd_CleanOption2%
	Gui, Add, Radio, -Wrap y+7 grd_sub_CheckIfSettingsChanged vrd_CleanOption3, %lng_rd_CleanOption3%
	Gui, Add, Radio, -Wrap y+7 grd_sub_CheckIfSettingsChanged vrd_CleanOption4, %lng_rd_CleanOption4%
	Gui, Add, ComboBox, x+5 yp-4 w40 gsub_CheckIfSettingsChanged vrd_CleanAfter, 1|2|3|4|5|6|7|14|21|28|30|31
	Gui, Add, Text, x+5 yp+4, %lng_rd_Days%
	Gui, Add, CheckBox, -Wrap xs+20 y+7 vrd_CleanNonExist Checked%rd_CleanNonExist% grd_sub_CheckIfSettingsChanged, %lng_rd_CleanOption6%
	Gui, Add, CheckBox, -Wrap y+7 vrd_DontCleanMSO Checked%rd_DontCleanMSO% grd_sub_CheckIfSettingsChanged, %lng_rd_CleanOption7%
	Gui, Add, CheckBox, -Wrap y+7 vrd_PeriodicCleanUp Checked%rd_PeriodicCleanUp% gsub_CheckIfSettingsChanged, %lng_rd_CleanOption5%
	GuiControl, , rd_CleanOption%rd_CleanOption%, 1
	GuiControl, Text, rd_NumberOfItems, %rd_NumberOfItems%
	GuiControl, Text, rd_CleanAfter, %rd_CleanAfter%
	If Enable_LikeDirkey = 1
	{
		Gui, Add, Text, xs+10 y+13, %lng_rd_LikeDirkey%:
		Gui, Add, Radio, -Wrap gsub_CheckIfSettingsChanged x+5 Checked vrd_LikeDirkeyOption1, %lng_rd_LikeDirkeyOption1%
		Gui, Add, Radio, -Wrap gsub_CheckIfSettingsChanged x+10 vrd_LikeDirkeyOption2, %lng_rd_LikeDirkeyOption2%
		Gui, Add, Radio, -Wrap gsub_CheckIfSettingsChanged x+10 vrd_LikeDirkeyOption3, %lng_rd_LikeDirkeyOption3%
		GuiControl, , rd_LikeDirkeyOption%rd_LikeDirkeyOption%, 1
	}
	Gui, Add, Button, -Wrap xs+420 ys+230 h20 w130 grd_sub_Filter, %lng_rd_Filter% ...
Return

rd_sub_Filter:
	Gui, %GuiID_activAid%:+Disabled
	GuiDefault("RecentDirs", "+Owner" GuiID_activAid)
	Gosub, GuiDefaultFont
	Gui, Add, Text, W500, %lng_rd_FilterInfo%

	Gui, Add, Edit, -Wrap r8 w500 vrd_Filter_tmp, %rd_Filter_tmp%
	Gui, Add, CheckBox, -Wrap y+5 vrd_DeleteFiltered_tmp Checked%rd_DeleteFiltered%, %lng_rd_DeleteFiltered%

	Gui, Add, Button, -Wrap X345 W80 Default grd_sub_FilterOK, %lng_OK%
	Gui, Add, Button, -Wrap X+5 W80 gRecentDirsGuiClose, %lng_cancel%
	Gui, Add, Button, -Wrap X10 yp W180 grd_sub_StandardFilter, %lng_rd_StandardFilter%

	Gui, Show, , %rd_ScriptName% - %lng_rd_Filter%
	Send, {Home}
Return

RecentDirsGuiClose:
RecentDirsGuiEscape:
	Gui, %GuiID_activAid%:-Disabled
	Gui, Destroy
Return

rd_sub_FilterOK:
	Gui, Submit, Nohide
	Gosub, RecentDirsGuiClose
	func_SettingsChanged( rd_ScriptName )
Return

rd_sub_CheckIfSettingsChanged:
	GuiControlGet, rd_CleanOptionTmp,,rd_CleanOption
	GuiControlGet, rd_CleanNonExistTmp,,rd_CleanNonExist
	If (rd_CleanOptionTmp = 1 AND rd_CleanNonExistTmp <> 1)
	{
		GuiControl, Disable, rd_PeriodicCleanUp
		GuiControl, Disable, rd_DontCleanMSO
	}
	Else
	{
		GuiControl, Enable, rd_PeriodicCleanUp
		GuiControl, Enable, rd_DontCleanMSO
	}
	Gosub, sub_CheckIfSettingsChanged
Return

rd_sub_StandardFilter:
	Gui, Submit, Nohide
	IfNotInString, rd_Filter_tmp, %A_Temp%
		rd_Filter_tmp = %rd_Filter_tmp%%A_Temp%`n
	Regread, rd_Temp, HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders,Cache
	IfNotInString, rd_Filter_tmp, %rd_Temp%
		rd_Filter_tmp = %rd_Filter_tmp%%rd_Temp%`n
	Regread, rd_Temp, HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders,Cookies
	IfNotInString, rd_Filter_tmp, %rd_Temp%
		rd_Filter_tmp = %rd_Filter_tmp%%rd_Temp%`n
	Regread, rd_Temp, HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders,History
	IfNotInString, rd_Filter_tmp, %rd_Temp%
		rd_Filter_tmp = %rd_Filter_tmp%%rd_Temp%`n
	StringReplace, rd_Filter_tmp,rd_Filter_tmp,`n`n,`n, All
	GuiControl,,rd_Filter_tmp, %rd_Filter_tmp%
Return

SaveSettings_RecentDirs:
	IniWrite, %rd_NumberOfItems%, %ConfigFile%, %rd_ScriptName%, NumberOfItems

	rd_CleanOption = 0
	Loop, 4
		rd_CleanOption := rd_CleanOption + A_Index*rd_CleanOption%A_Index%
	rd_LikeDirkeyOption = 0
	Loop, 3
		rd_LikeDirkeyOption := rd_LikeDirkeyOption + A_Index*rd_LikeDirkeyOption%A_Index%

	IniWrite, %rd_CleanOption%, %ConfigFile%, %rd_ScriptName%, CleanOption
	IniWrite, %rd_CleanAfter%, %ConfigFile%, %rd_ScriptName%, CleanAfter
	IniWrite, %rd_PeriodicCleanUp%, %ConfigFile%, %rd_ScriptName%, PeriodicCleanUp
	IniWrite, %rd_LikeDirkeyOption%, %ConfigFile%, %rd_ScriptName%, LikeDirkeyOption
	IniWrite, %rd_CleanNonExist%, %ConfigFile%, %rd_ScriptName%, CleanNonExist
	IniWrite, %rd_DontCleanMSO%, %ConfigFile%, %rd_ScriptName%, DontCleanOfficeRecent
	IniWrite, %rd_AlternativePresentation%, %ConfigFile%, %rd_ScriptName%, AlternativeFolderPresentation
	IniWrite, %rd_FolderTree%, %ConfigFile%, %rd_ScriptName%, FolderTree

	StringReplace, rd_Filter_tmp, rd_Filter_tmp, `r, , All
	StringReplace, rd_Filter_tmp, rd_Filter_tmp, `n`n, `n, All
	StringReplace, rd_Filter, rd_Filter_tmp, `n, |, All
	IniWrite, %rd_Filter%, %ConfigFile%, %rd_ScriptName%, Filter
	rd_DeleteFiltered = %rd_DeleteFiltered_tmp%
	IniWrite, %rd_DeleteFiltered%, %ConfigFile%, %rd_ScriptName%, DeletedFiltered
Return

CancelSettings_RecentDirs:
Return

DoEnable_RecentDirs:
	registerAction("RecentDirs",lng_rd_openMenu,"rd_sub_Hotkey_RecentDirs")
	registerAction("RecentDirsMostRecent",lng_rd_OpenMostRecent,"rd_sub_Action_OpenMostRecent")

	If rd_PeriodicCleanUp = 1
		SetTimer, rd_tim_PeriodicCleanUp, 60000 ; 6000ms * 5
Return

DoDisable_RecentDirs:
	unRegisterAction("RecentDirs")
	unRegisterAction("RecentDirsMostRecent")
	SetTimer, rd_tim_PeriodicCleanUp, Off
Return

DefaultSettings_RecentDirs:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

rd_sub_Hotkey_RecentDirs:
sub_Hotkey_RecentDirs:
	If Enable_RecentDirs = 1
		Gosub, rd_main_RecentDirs
Return

rd_sub_Action_OpenMostRecent:
	rd_CleanUpOnly = 1
	gosub, rd_main_RecentDirs
	rd_Index = 1
	gosub, rd_sub_MainChangeDirRoutine
	rd_CleanUpOnly =
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

rd_forceCleanAll:
	;msgbox are u sure blabla

	Loop, %RecentPath%\*.*,0,0
	{
		FileDelete, %A_LoopFileFullPath%
		;msgbox, %A_LoopFileFullPath%
	}

	;Menu, RecentMenu, Hide
return

rd_main_RecentDirs:
	If rd_CleanUpOnly =
		 SetTimer, rd_tim_ToolTip, 200

	rd_MenuItemPos = 1

	If rd_CleanUpOnly =
	{
		If (rd_LikeDirkeyOption = 2 AND Enable_LikeDirkey = 1)
			Gosub, rd_AddLikeDirkeyMenu
		If rd_MenuItemPos <> 1
		{
			Menu, RecentMenu, Add
			rd_MenuItemPos++
		}
		Menu, RecentMenu, Add, %rd_ScriptName%, rd_sub_MenuItem
	}
	rd_MenuItemPos++
	If rd_CleanUpOnly =
	{
		Menu, RecentMenu, Disable, %rd_ScriptName%
		Menu, RecentMenu, Add
	}
	rd_MenuItemPos++
	rd_Index = 0
	rd_Paths =
	rd_AllPaths =
	rd_AllTargets =
	rd_RecentMenuBegin = %rd_MenuItemPos%
	rd_PathsToCrawl =
	Loop, %RecentPath%\*.*,0,0
	{
		rd_PathsToCrawl = %rd_PathsToCrawl%%A_LoopFileFullPath%`n
	}
	If rd_RecentPathMSO <>
	{
		Loop, %rd_RecentPathMSO%\*.*,0,0
		{
			rd_PathsToCrawl = %rd_PathsToCrawl%%A_LoopFileFullPath%`n
		}
	}

	Loop, Parse, rd_PathsToCrawl, `n
	{
		rd_LoopFileFullPath = %A_LoopField%
		SplitPath, A_LoopField, rd_LoopFileName, rd_LoopFileDir

		If rd_LoopFileName = desktop.ini
			continue
		StringTrimRight, rd_StripLNK, rd_LoopFileFullPath, 4
		SplitPath, rd_StripLNK, , , rd_Extension, rd_Name,
		If rd_CleanOption < 3
			If rd_Extension in .pdf,.doc,.ppt,.xls,.dot,.xlt,.indd,.indt,.eps,.tif,.jpg,.png,.gif,.ppd,.ai,.ps,.fh5,.fh7,.fh8,.fh9,.fh10,.exe,.bat,.ahk,.cmd,.txt,.ini,.site,.nri,.php,.html,.css,.js,.odt,.ott,.ods,.ots,.odp,.otp
				continue

		If (rd_LoopFileDir = rd_RecentPathMSO AND    rd_DontCleanMSO = 1)
			rd_DontDelete = 1
		Else
			rd_DontDelete = 0

		If A_OSversion = WIN_NT4
			FileGetShortcut, %rd_LoopFileFullPath%,, rd_ShortcutTarget
		Else
			FileGetShortcut, %rd_LoopFileFullPath%, rd_ShortcutTarget

		If rd_CleanNonExist = 1
		{
			IfNotExist, %rd_ShortcutTarget%
			{
				If rd_DontDelete = 0
					FileDelete, %rd_LoopFileFullPath%
				continue
			}
		}

		rd_AddPath = 1
		Loop, Parse, rd_Filter, |
		{
			If A_LoopField =
				continue
			IfInString, rd_ShortcutTarget, %A_LoopField%
			{
				rd_AddPath = 0
				Break
			}
		}
		If rd_AddPath = 0
		{
			If (rd_DontDelete = 0 AND rd_DeleteFiltered = 1)
				FileDelete, %rd_LoopFileFullPath%
			continue
		}

		FileGetTime, rd_ShortCutTime, %rd_LoopFileFullPath%
		If ((func_StrLeft(A_Now,8) - func_StrLeft(rd_ShortCutTime,8) >= rd_CleanAfter) AND rd_CleanOption = 4)
		{
			If rd_DontDelete = 0
				FileDelete, %rdLoopFileFullPath%
			continue
		}

		FileGetAttrib, rd_ShortcutAttrib, %rd_ShortcutTarget%
		IfInString, rd_ShortcutAttrib, D
		{
			IfNotInString, rd_AllTargets, /%rd_ShortcutTarget%`n
			{
				rd_AllTargets = %rd_AllTargets%/%rd_ShortcutTarget%`n
				rd_AllPaths = %rd_AllPaths%%rd_ShortCutTime%%rd_LoopFileFullPath%`n
			}
			Else
			{
				If rd_DontDelete = 0
					FileDelete, %rd_LoopFileFullPath%
			}
		}
		Else
		{
			If (rd_CleanOption = 3 AND rd_DontDelete = 0)
				FileDelete, %rd_LoopFileFullPath%
		}
	}
	Sort, rd_AllPaths, RU

	Loop, Parse, rd_AllPaths, `n
	{
		StringTrimLeft, rd_current, A_LoopField, 14   ; Datum entfernen
		If A_Index <= %rd_NumberOfItems%
		{
			If A_LoopField =
				break

			If A_OSversion = WIN_NT4
				FileGetShortcut, %rd_current%,, rd_current
			Else
				FileGetShortcut, %rd_current%, rd_current

			rd_RecentArray%A_Index% = %rd_current%

			StringReplace, rd_current, rd_current, &, &&, a

			SplitPath, rd_current, rd_currentFileName, rd_currentDir,,, rd_currentDrive
			SplitPath, rd_currentDir, rd_currentParentDir
			StringSplit, rd_dirs, rd_currentDir, \

			StringLen, rd_len, rd_current

			If rd_currentFileName =
				rd_currentFileName = %rd_currentDir%

			;most Recent Entry
			If A_Index = 1
			{
				;msgbox, %rd_current%

			}

			if rd_EnableSubmenus = 1
				rd_current_subMenuName := rd_buildMenu(rd_current,A_Index)

			If rd_AlternativePresentation = 1
			{
				If rd_len > 40
					rd_current = %rd_currentDrive%\%rd_dirs2%\...\%rd_currentParentDir%\`t%rd_currentFileName%
				Else If rd_current <>
					rd_current = %rd_currentDir%\`t%rd_currentFileName%
			}
			Else If rd_AlternativePresentation = -1
			{
				If rd_len > 40
					rd_current = %rd_currentDrive%\%rd_dirs2%\...\%rd_currentParentDir%\%rd_currentFileName%
				Else If rd_current <>
				{
					rd_currentFileName := RegExReplace(rd_currentFileName,"i)^\w:", "")
					rd_current = %rd_currentDir%\%rd_currentFileName%
				}
			}
			Else
			{
				If rd_len > 40
					rd_current = %rd_currentFileName%`t%rd_currentDrive%\%rd_dirs2%\...\%rd_currentParentDir%\
				Else If rd_current <>
					rd_current = %rd_currentFileName%`t%rd_currentDir%\
			}

			If rd_NumberedMenuEntries=1
			{

				rd_Symbol := func_StrRight("000000" A_Index, StrLen(rd_NumberOfItems))
				If rd_CleanUpOnly =
				{
					If rd_NumberOfItems < 10
					{

						if rd_EnableSubmenus = 1
							Menu, RecentMenu, Add, &%rd_Symbol% - %rd_current%, :%rd_current_subMenuName%
						else
							Menu, RecentMenu, Add, &%rd_Symbol% - %rd_current%, rd_sub_MenuItem
					}
					Else
					{
						if rd_EnableSubmenus = 1
							Menu, RecentMenu, Add, %rd_Symbol% - %rd_current%, :%rd_current_subMenuName%
						else
							Menu, RecentMenu, Add, %rd_Symbol% - %rd_current%, rd_sub_MenuItem
					}
				}
			}
			Else
			{

				StringMid, rd_Symbol, rd_IndexSymbols, A_Index, 1
				If rd_CleanUpOnly =
				{
					If (rd_Symbol <> "" AND rd_Symbol <> " ")
					{
						if rd_EnableSubmenus = 1
							Menu, RecentMenu, Add, &%rd_Symbol% - %rd_current%, :%rd_current_subMenuName%
						else
							Menu, RecentMenu, Add, &%rd_Symbol% - %rd_current%, rd_sub_MenuItem
					}
					Else
					{
						if rd_EnableSubmenus = 1
							Menu, RecentMenu, Add, %A_Space%  - %rd_current%, :%rd_current_subMenuName%
						else
							Menu, RecentMenu, Add, %A_Space%  - %rd_current%, rd_sub_MenuItem

					}
				}
			}

			rd_MenuItemPos++
		}
		Else
		{
			SplitPath, rd_current, rd_LoopFileName, rd_LoopFileDir
			If (rd_LoopFileDir = rd_RecentPathMSO AND rd_DontCleanMSO = 1)
				rd_DontDelete = 1
			Else
				rd_DontDelete = 0

			If ((rd_CleanOption = 2 OR rd_CleanOption = 3) AND rd_DontDelete = 0)
				FileDelete, %rd_current%
		}
	}

	If rd_CleanUpOnly =
	{
		Prefix = rd
		rd_Temp =

		rd_AdditionalSettingsMenuExternal = 1
		Gosub, sub_CreateAdditionalSettingsMenu

		Menu, RecentMenu, Add
		Menu, RecentMenu, Add, %lng_AdditionalSettings%, :AdditionalSettingsMenu

		If (rd_LikeDirkeyOption = 3 AND Enable_LikeDirkey = 1)
			Gosub, rd_AddLikeDirkeyMenu

		SetTimer, rd_tim_ToolTip, Off
		ToolTip

		WinGet, rd_WinID, ID, A

		Menu, RecentMenu, Show

		WinGetClass, rd_Class, ahk_id %rd_WinID%
			If rd_Class contains %ChangeDirClasses%
				IfWinNotActive, ahk_id %rd_WinID%
					WinActivate, ahk_id %rd_WinID%
		Menu, RecentMenu, DeleteAll
	}
Return

rd_buildMenu(path,num)
{
	Global
	local MenuName,MenuItemNum,OutNameNoExt,OutFileName

	MenuName = rd_Menu%num%
	MenuItemNum = 3
	text =
	Menu, %MenuName%, Add
	Menu, %MenuName%, DeleteAll
	Menu, %MenuName%, Add, %lng_rd_Open%, rd_sub_MenuItemWithEnabledSubMenus
	Menu, %MenuName%, Add

	Loop, %path%\*.*, 2, 0
	{
		if A_LoopFileName = %A_Space%
			continue

		rd_toBeFiltered = 0
		Loop, Parse, rd_Filter, |
		{
			If A_LoopField =
				continue

			IfInString, A_LoopFileFullPath, %A_LoopField%
			{
				rd_toBeFiltered = 1
				Break
			}
		}

		if rd_toBeFiltered = 0
		{
			SplitPath,A_LoopFileFullPath,OutFileName,,,OutNameNoExt

			if OutFileName !=
			{
				Menu,%MenuName%,add,%OutFileName%,rd_sub_go_Directory

				rd_link_%MenuName%_%MenuItemNum% := A_LoopFileFullPath
				MenuItemNum += 1
			}
		}
	}

	if MenuItemNum > 3
	{
		Menu, %MenuName%, Add
		MenuItemNum += 1
	}

	Loop, %path%\*.*, 0, 0
	{
		if A_LoopFileName = desktop.ini
			continue

		if A_LoopFileName = %A_Space%
			continue

		rd_toBeFiltered = 0
		Loop, Parse, rd_Filter, |
		{
			If A_LoopField =
				continue

			IfInString, A_LoopFileFullPath, %A_LoopField%
			{
				rd_toBeFiltered = 1
				Break
			}
		}

		if rd_toBeFiltered = 0
		{
			SplitPath,A_LoopFileFullPath,OutFileName,,,OutNameNoExt

			if OutFileName !=
			{
				Menu,%MenuName%,add,%OutFileName%,rd_sub_go

				rd_link_%MenuName%_%MenuItemNum% := A_LoopFileFullPath
				MenuItemNum += 1
			}
		}
	}
	return %MenuName%
}

rd_sub_go:
	rd_runThis := rd_link_%A_ThisMenu%_%A_ThisMenuItemPos%
	run %rd_runThis%
return

rd_sub_go_Directory:
	rd_runThis := rd_link_%A_ThisMenu%_%A_ThisMenuItemPos%
	StringReplace, rd_runThis, rd_runThis, \\, \, All
	GetKeyState, rd_State1, Shift, P
	GetKeyState, rd_State2, Ctrl, P
	GetKeyState, rd_State3, LWin, P
	GetKeyState, rd_State4, RWin, P
	If rd_CleanUpOnly =
	{
		WinActivate, ahk_id %rd_WinID%
		WinWaitActive, ahk_id %rd_WinID%
	}

	If (rd_State1 = "D" OR rd_State2 = "D" OR rd_State3 = "D" OR rd_State4 = "D")
		func_ChangeDir(rd_runThis,1,rd_FolderTree)
	Else
		func_ChangeDir(rd_runThis,-1,rd_FolderTree)

return

rd_tim_PeriodicCleanUp:
	If LoadingFinished <> 1
		Return

	rd_CleanUpOnly = 1
	Gosub, rd_main_RecentDirs
	rd_CleanUpOnly =
Return

rd_tim_ToolTip:
	ToolTip, %lng_rd_Tooltip%
	SetTimer, rd_tim_ToolTip, 20
Return

rd_sub_MenuItem:
	rd_Index := A_ThisMenuItemPos - rd_RecentMenuBegin + 1
	gosub, rd_sub_MainChangeDirRoutine
Return

rd_sub_MenuItemWithEnabledSubMenus:
	StringTrimLeft, rd_Index, A_ThisMenu, 7
	gosub, rd_sub_MainChangeDirRoutine
Return

rd_sub_MainChangeDirRoutine:
	GetKeyState, rd_State1, Shift, P
	GetKeyState, rd_State2, Ctrl, P
	GetKeyState, rd_State3, LWin, P
	GetKeyState, rd_State4, RWin, P

	if rd_CleanUpOnly =
	{
		WinActivate, ahk_id %rd_WinID%
		WinWaitActive, ahk_id %rd_WinID%
	}

	If (rd_State1 = "D" OR rd_State2 = "D" OR rd_State3 = "D" OR rd_State4 = "D")
		func_ChangeDir(rd_RecentArray%rd_Index%,1,rd_FolderTree)
	Else
		func_ChangeDir(rd_RecentArray%rd_Index%,-1,rd_FolderTree)
return

rd_AddLikeDirkeyMenu:
	If rd_MenuItemPos <> 1
	{
		Menu, RecentMenu, Add
		rd_MenuItemPos++
	}
	Menu, RecentMenu, Add, %ld_ScriptName%, rdld_sub_MenuItem
	rd_MenuItemPos++
	Menu, RecentMenu, Disable, %ld_ScriptName%
	Menu, RecentMenu, Add
	rd_MenuItemPos++
	rd_LikeDirkeyMenuBegin = %rd_MenuItemPos%
	Loop, 10
	{
		rdld_Index :=  A_Index-1
		rdld_current := ld_Folder[%rdld_Index%] ; Pfad auslesen

		StringLeft, rdld_check, rdld_current, 5

		If rdld_check = HKEY_
		{
			StringSplit, rdld_current, rdld_current, `,
			RegRead, rdld_current, %rdld_current1%,%rdld_current2%,%rdld_current3%
		}

		StringLeft, rdld_check, rdld_current, 1

		If rdld_check = `%
		{
			StringReplace, rdld_current, rdld_current, `% ,, A
			rdld_current := %rdld_current%
		}

		StringReplace, rdld_current, rdld_current, &, &&, a

		SplitPath, rdld_current, rdld_currentFileName, rdld_currentDir,,, rdld_currentDrive
		SplitPath, rdld_currentDir, rdld_currentParentDir
		StringSplit, rdld_dirs, rdld_currentDir, \

		StringLen, rdld_len, rdld_current

		If rdld_currentFileName =
			rdld_currentFileName = %rdld_currentDir%
		If rd_AlternativePresentation = 1
		{
			If rdld_len > 40
				rdld_current = %rdld_currentDrive%\%rdld_dirs2%\...\%rdld_currentParentDir%\`t%rdld_currentFileName%
			Else If rdld_current <>
				rdld_current = %rdld_currentDir%\`t%rdld_currentFileName%
		}
		Else If rd_AlternativePresentation = -1
		{
			If rdld_len > 40
				rdld_current = %rdld_currentDrive%\%rdld_dirs2%\...\%rdld_currentParentDir%\%rdld_currentFileName%
			Else If rdld_current <>
				rdld_current = %rdld_currentDir%\%rdld_currentFileName%
		}
		Else
		{
			If rdld_len > 40
				rdld_current = %rdld_currentFileName%`t%rdld_currentDrive%\%rdld_dirs2%\...\%rdld_currentParentDir%\
			Else If rdld_current <>
				rdld_current = %rdld_currentFileName%`t%rdld_currentDir%\
		}

		If rdld_current <> ; Wenn nicht leer
		{
			If rdld_Index = 0
			{
				If rd_NumberedMenuEntries = 1
					rdld_0 = %rdld_Index% - %rdld_current%
				Else
					rdld_0 = &%rdld_Index% - %rdld_current%
			}
			Else
			{
				If rd_NumberedMenuEntries = 1
					Menu, RecentMenu, Add, %rdld_Index% - %rdld_current%, rdld_sub_MenuItem
				Else
					Menu, RecentMenu, Add, &%rdld_Index% - %rdld_current%, rdld_sub_MenuItem
				rd_MenuItemPos++
			}
		}
	}
	If rdld_0 <>
	{
		Menu, RecentMenu, Add, %rdld_0% , rdld_sub_MenuItem
		rd_MenuItemPos++
	}
Return

rdld_sub_MenuItem:
	If rd_NumberedMenuEntries = 1
		StringMid, rdld_keyIndex, A_ThisMenuItem, 1, 1
	Else
		StringMid, rdld_keyIndex, A_ThisMenuItem, 2, 1

	rdld_path := ld_Folder[%rdld_keyIndex%] ; Pfad auslesen

	StringLeft, rdld_check, rdld_path, 5

	If rdld_check = HKEY_
	{
		StringSplit, rdld_path, rdld_path, `,
		RegRead, rdld_path, %rdld_path1%,%rdld_path2%,%rdld_path3%
	}

	StringLeft, rdld_check, rdld_path, 1

	If rdld_check = `%
	{
		StringReplace, rdld_path, rdld_path, `% ,, A
		rdld_path := %rdld_path%
	}

	GetKeyState, rd_State1, Shift, P
	GetKeyState, rd_State2, Ctrl, P
	GetKeyState, rd_State3, LWin, P
	GetKeyState, rd_State4, RWin, P
	If (rd_State1 = "D" OR rd_State2 = "D" OR rd_State3 = "D" OR rd_State4 = "D")
		func_ChangeDir(rdld_Path,1,rd_FolderTree)
	Else
		func_ChangeDir(rdld_Path,-1,rd_FolderTree)
Return
