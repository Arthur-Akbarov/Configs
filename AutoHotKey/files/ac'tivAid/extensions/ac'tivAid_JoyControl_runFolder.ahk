#NoTrayIcon
#SingleInstance force
#include %A_ScriptDir%\..\Library\MI.ahk

rootdir = %1%
UseIcons = %2%

If UseIcons =
	UseIcons = 0

if UseIcons = 1
{
	GW_OWNER = 4

	if ((aa_osversionnumber < aa_osversionnumber_vista) && UseIcons = 1)
		MI_EnableOwnerDrawnMenus()

}
totalMenuNum = 1

scanFolder(rootdir)
Menu,Menu1,show
return

scanFolder(path)
{
	Global
	local MenuName,stillToScan,nextMenuName,subMenuName,MenuItemNum,OutIcon,OutIconNum

	MenuName = Menu%totalMenuNum%
	MenuItemNum = 1

	Menu,%MenuName%,add, ,go

	Loop, %path%\*.*, 1, 0
	{
		IfInString, A_LoopFileAttrib, D
			stillToScan = %stillToScan%%A_LoopFileFullPath%|
		else
		{
			if A_LoopFileName = desktop.ini
				continue

			SplitPath,A_LoopFileFullPath,,,,OutNameNoExt

			Menu,%MenuName%,add,%OutNameNoExt%,go
			MenuItemNum += 1
			link_%MenuName%_%MenuItemNum% := A_LoopFileFullPath

			if UseIcons = 1
			{
				if A_LoopFileExt = lnk
				{
					OutIcon =
					;FileGetShortcut, %A_LoopFileFullPath%,OutTarget,,,, OutIcon,,
					OutIcon := getIconFile(A_LoopFileFullPath)
					;msgbox, %OutIcon%

					if OutIcon =
					{
						OutIcon := OutTarget
						OutIconNum = 1
					}

					Text = %Text%%MenuName% > %MenuItemNum% > %A_LoopFileFullPath% > %OutIcon%`n
					MI_SetMenuItemIcon(MenuName, MenuItemNum, OutIcon, 0, 16)
					MI_SetMenuStyle(MenuName, 0x4000000)
				}
			}

		}
	}

	OutIcon =
	OutIconNum = 0

	Loop, parse, stillToScan, |
	{
		if A_LoopField !=
		{
			totalMenuNum += 1
			nextMenuName = Menu%totalMenuNum%
			SplitPath, A_LoopField, subMenuName, directory

			scanFolder(A_LoopField)
			Menu,%MenuName%,add,%subMenuName%,:%nextMenuName%
			;msgbox, %A_LoopField%\Desktop.ini
			MenuItemNum += 1
			if UseIcons = 1
			{
				IfExist, %A_LoopField%\Desktop.ini
				{
					IniRead, OutIcon, %A_LoopField%\Desktop.ini, .ShellClassInfo,IconFile,%A_Space%
					IniRead, OutIconNum, %A_LoopField%\Desktop.ini, .ShellClassInfo,IconIndex,0

					StringReplace, OutIcon, OutIcon, `%SystemRoot`%, %A_WinDir%
					OutIconNum += 1
				}

				if OutIcon =
				{
					OutIcon := getIconFile(A_LoopFileFullPath)
					OutIconNum := 0
				}

				;Text = %Text%%MenuName% > %MenuItemNum% > %A_LoopFileFullPath% > %OutIcon%`n
				MI_SetMenuItemIcon(MenuName, MenuItemNum, OutIcon, OutIconNum, 16)
				MI_SetMenuStyle(MenuName, 0x4000000)
			}
		}
	}
}

getIconFile(al_IconFile)
{
  	al_sfi_size = 352  ; Structure size of SHFILEINFO.
	VarSetCapacity(al_sfi, al_sfi_size)

	hIcon = 0
	al_IconFile2 = 0
	al_IconFileFull := al_IconFile
	RegexMatch(al_IconFile ",0", "^(.+?),([0-9]+?)$", al_IconFile)
	If al_IconFile =
	{
		al_IconFile := al_IconFileFull
		al_IconFile1 := al_IconFileFull
	}
	If al_IconFile2 = 0
		if DllCall("Shell32\SHGetFileInfoA", "str", al_IconFile1, "uint", 0, "str", al_sfi, "uint", al_sfi_size, "uint", 0x101)  ; load small icon
		{
			Loop 4
				hIcon += *(&al_sfi + A_Index-1) << 8*(A_Index-1)
		}
	If hIcon = 0
		hIcon := DllCall("shell32\ExtractAssociatedIconA", "UInt", 0, "Str", al_IconFile1, "UShortP", al_IconFile2)

	return hIcon
}

go:
	runThis := link_%A_ThisMenu%_%A_ThisMenuItemPos%
	run %runThis%
return

ShowMenu:
Menu,DirMenu,show
return
