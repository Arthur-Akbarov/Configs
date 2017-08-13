func_ChangeDir( retPath,NewWindow=0,FolderTree=0 )
{
	Global lng_ChangeDirFailed, ScriptTitle, lng_FolderDoesNotExist, ChangeDirClasses, FileBrowser, FileBrowserSelect, FileBrowserWithTree, aa_osversionnumber, aa_osversionnumber_7
	SetKeyDelay,20,20

	If retPath = control
		retPath = ::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{21EC2020-3AEA-1069-A2DD-08002B30309D}

	WinGet, activeWinID, ID, A ; ID es aktiven Fensters
	WinGetClass, activeClass, ahk_id %activeWinID% ; Fensterklasse ermitteln
	WinGetText, activeWinText, ahk_id %activeWinID%

	Edit1Pos =

	; Prüfen ob Fensterklasse unterstützt wird
	If activeClass contains %ChangeDirClasses%
	{
		; Ermitteln ob ein Edit1-Control vorhanden ist (Eingabezeile)
		IfInString, activeWinText, MSNTB_Window ; MSN-Toolbar oder Visual Studio?
		{
			EditClass = Edit2
		}
		Else IfInString, activeClass, bosa_sdm_Mso96 ; VisualStudio
		{
			EditClass = Edit2
		}
		Else
		{
			EditClass = Edit1
		}

		ControlGetPos, Edit1Pos,,,, %EditClass%, ahk_id %activeWinID%
		;on win7 explorer won't show Edit1 until breadcrumb bar is focused:
		if (Edit1Pos == "" && (aa_osversionnumber == aa_osversionnumber_7))
		{
			ControlClick, ToolbarWindow322, ahk_id %activeWinID%
			sleep 10
			ControlGetPos, Edit1Pos,,,, %EditClass% , ahk_id %activeWinID%
		}
	}

	If Edit1Pos = ; Wenn kein Edit1-Control gefunden ...
	{
		; Ermitteln ob ein RichEdit-Control vorhanden ist (MS-Office)
		EditClass = RichEdit20W2
		ControlGetPos, Edit1Pos,,,, %EditClass%, ahk_id %activeWinID%
	}

	If activeClass = AfxMDIFrame80su
	{
		EditClass = ComboBox3
		ControlGetPos, Edit1Pos,,,, %EditClass%, ahk_id %activeWinID%
	}

	FileGetAttrib, isFolder, %retPath%
	If (func_StrLeft(retPath,3) = "`:`:{")
		isFolder = D

	If NewWindow < 1 ; Verzeichnis im aktuellen Fenster wechseln
	{
		IfNotInString, isFolder, D
			Return

		; Verzeichnis in Dateidialogen wechseln
		If activeClass contains #32770,bosa_sdm,bosa_sdm_Mso96
		{
			If Edit1Pos <>
			{
				WinActivate ahk_id %activeWinID%
				ControlGetText, text, %EditClass%, ahk_id %activeWinID%
				ControlFocus, %EditClass%, ahk_id %activeWinID%
				ControlSetText, %EditClass%, %retPath%, ahk_id %activeWinID%
				WinGet,Process, ProcessName, ahk_id %activeWinID%
				func_AddToRecentDir(retPath)
				If Process in WinRar.exe
					Return
				if Process in Acad.exe
				{
					ControlSend, %EditClass%, {SPACE}{BS}, ahk_id %activeWinID%
					Sleep, 200
				}
				If activeClass = bosa_sdm
					ControlSend, %EditClass%, {Tab}, ahk_id %activeWinID%
				Else
					ControlSend, %EditClass%, {Enter}, ahk_id %activeWinID%
				Sleep, 100
				ControlSetText, %EditClass%, %text%, ahk_id %activeWinID%
				Return
			}
		}
		; Verzeichnis in Explorer-Fenstern wechseln
		Else If activeClass in ExploreWClass,CabinetWClass,WinRarWindow,dopus.lister
		{
			If Edit1Pos <>
			{
				ControlSetText, %EditClass%, %retPath%, ahk_id %activeWinID%
				ControlSend, %EditClass%, {Right}{Enter}, ahk_id %activeWinID%
				Sleep,200
				Send, +{Tab}
				func_AddToRecentDir(retPath)
				Return
			}
		}
		; Verzeichnis im CubicExplorer wechseln
		Else If activeClass in TMainForm
		{
			ControlGetPos, Edit1Pos,,,, TComboEdit.UnicodeClass2, ahk_id %activeWinID%
			If Edit1Pos <>
			{
				ControlSetText, TComboEdit.UnicodeClass2, %retPath%, ahk_id %activeWinID%
				ControlSend, TComboEdit.UnicodeClass2, {Enter}{Tab}, ahk_id %activeWinID%
				func_AddToRecentDir(retPath)
				Return
			}
		}
		; UltraExplorer
		Else If activeClass in TTntFormUltraExplorer.UnicodeClass
		{
			ControlGetPos, Edit1Pos,,,, TComboEdit.UnicodeClass1, ahk_id %activeWinID%
			If Edit1Pos <>
			{
				ControlGetFocus, activeControl, ahk_id %activeWinID%
				ControlSetText, TComboEdit.UnicodeClass1, %retPath%, ahk_id %activeWinID%
				ControlSend, TComboEdit.UnicodeClass1, {Enter}, ahk_id %activeWinID%
				ControlFocus, %activeClass%, ahk_id %activeWinID%
				func_AddToRecentDir(retPath)
				Return
			}
		}
		; Verzeichnis in AcdSee, Filezilla, SpeedCommander wechseln
		Else If activeClass in Afx:400000:0,FileZilla Main Window,SC10MainFrame,SC11MainFrame,SC12MainFrame
		{
			If Edit1Pos <>
			{
				ControlSetText, %EditClass%, %retPath%, ahk_id %activeWinID%
				ControlSend, %EditClass%, {Enter}, ahk_id %activeWinID%
				func_AddToRecentDir(retPath)
				Return
			}
		}
		; Total Commander
		Else If activeClass = TTOTAL_CMD
		{
			PostMessage 1075, 2912,,, ahk_id %activeWinID% ; added by MayorA for TotalCommander (send cm_EditPath)
			Sleep,50
			ControlGetFocus, activeControl, ahk_id %activeWinID%
			ControlSetText, %activeControl%, %retPath%, ahk_id %activeWinID%
			ControlSend, %activeControl%, {Left}{Right}{Enter}, ahk_id %activeWinID%
			func_AddToRecentDir(retPath)
			Return
		}
		; xplorer²
		Else If activeClass = ATL:ExplorerFrame
		{
			If Edit1Pos <>
			{
				ControlSetText, %EditClass%, %retPath%, ahk_id %activeWinID%
				ControlFocus, %EditClass%, ahk_id %activeWinID%
				ControlSend, %EditClass%, {Enter}, ahk_id %activeWinID%
				func_AddToRecentDir(retPath)
				Return
			}
		}
		; Verzeichnis in der Eingabeaufforderung wechseln
		Else If activeClass = ConsoleWindowClass
		{
			WinGetActiveTitle, wTitle

			If wTitle contains cmd.exe,4NT
			{
				WinActivate, ahk_id %activeWinID%
				SetKeyDelay, 0

				IfInString, retPath, :
				{
					StringLeft, path_Drive, retPath, 1
					Send {ESC}%path_Drive%:{Enter}
				}

				Send, {ESC}
				SendRaw, cd "%retPath%"
				Send, {Enter}
				func_AddToRecentDir(retPath)
				Return
			}
			; Verzeichnis in Powershell.exe wechseln
			Else If wTitle contains powershell.exe
			{
				WinActivate, ahk_id %activeWinID%
				SetKeyDelay, 0

				Send, {ESC}
				SendRaw, Set-Location "%retPath%"
				Send, {Enter}
				func_AddToRecentDir(retPath)
				Return
			}
		}
	}
	If NewWindow <> 0
	{
		; Explorer-Fenster öffnen (führt auch Programme aus)
		If (FileExist(retPath) OR func_StrLeft(retPath,3) = "::{" OR func_StrLeft(retPath,7) = "control")
		{
			retPath = "%retPath%"

			If ( isFolder contains "D" AND FolderTree = "1")
				Run, %FileBrowserWithTree% %retPath%,,UseErrorLevel
			Else
				Run, %FileBrowser% %retPath%,,UseErrorLevel
			If ErrorLevel = ERROR
				func_GetErrorMessage( A_LastError, ScriptTitle, A_Quote retPath A_Quote "`n`n" )
			Else
				func_AddToRecentDir(retPath)
		}
		Else
			BalloonTip(ScriptTitle, lng_FolderDoesNotExist "`n" retPath, "Info")
	}
	Else
		BalloonTip(ScriptTitle, lng_ChangeDirFailed, "Info", 1)
}

func_AddToRecentDir( retPath )
{
	global RecentPath
	SplitPath, retPath, Name, parentDir,,,Drive
	If Name =
		StringReplace, Name, Drive, :, ,
	FileDelete, %RecentPath%\%Name%
	FileCreateShortcut, %retPath%, %RecentPath%\%Name%.lnk
}

func_GetDir( WindowID, Message="", Repeat="", AddToTitle="", NoDelay=0 )
{
	global Enable_Freespace,lng_fs_FreeSpace,lng_fs_FreeSpaceShort, lng_CheckYourFolderOptions, ScriptTitle, USERPROFILE, aa_osversionnumber, aa_osversionnumber_7

	; try to get Path from new controls
	if(aa_osversionnumber>=aa_osversionnumber_7)
	{
		ControlGetText, retPath, ShellTabWindowClass1, ahk_id %WindowID%
		If (!FileExist(retPath))
		{
			; if no full path is available in ShellTabWindowClass1 use path from ToolbarWindow322
			ControlGetText, retPath, ToolbarWindow322, ahk_id %WindowID%
			retPath := Substr( retPath, InStr( retPath, ": " )+2)
		}
		If (FileExist(retPath))
		{
			return retPath
		}
	}
	WinGetTitle, activeWinTitle, ahk_id %WindowID%
	WinGetText, activeWinText, ahk_id %WindowID%
	WinGetClass, activeWinClass, ahk_id %WindowID%

	IfInString, activeWinText, MSNTB_Window ; MSN-Toolbar?
		EditClass = Edit2
	Else
		EditClass = Edit1

	ControlGetText, retPath, %EditClass%, ahk_id %WindowID%
	retPathErrorLevel = %ErrorLevel%

	If activeWinTitle contains - Microsoft Internet Explorer
		Return

	If Repeat = Once
		Repeat = 1
	Else If Repeat <> Never
		Repeat =
	If AddToTitle <>
		AddToTitle := " - " AddToTitle

	If A_OSversion = WIN_NT4
	{
		RegRead, FullPath, HKCU,Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState,Settings
		StringMid, FullPath, FullPath,10,1
		If FullPath = B
			FullPath = 1
		Else
			FullPath = 0
	}
	Else
	{
		RegRead, FullPath, HKCU,Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState,FullPath
		RegRead, FullPathAddress, HKCU,Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState,FullPathAddress
		If FullPath =
			FullPath = 0
		If FullPathAddress =
			FullPathAddress = 1
	}

	RegRead, RegDesktop, HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders,Desktop
	StringReplace, RegDesktop, RegDesktop, `%USERPROFILE`%\

	RegRead, RegPersonal, HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders,Personal
	RegRead, MyDocs, HKEY_CURRENT_USER,Software\Microsoft\Office\11.0\Common\General,MyDocuments
	StringReplace, RegPersonal, RegPersonal, `%USERPROFILE`%, %USERPROFILE%
	StringReplace, RegPersonal, RegPersonal, `%USERNAME`%, %A_Username%
	SplitPath, RegPersonal, RegDir

	If (retPathErrorLevel = 1 AND WinExist("ahk_id " WindowID) AND WinActive("ahk_id " WindowID) AND NoDelay = 0)
	{
		WinWaitClose, ahk_id %WindowID%,,1
	}

	If activeWinClass in CabinetWClass,ExploreWClass
	{
		If (( (FullPath = 0 AND FullPathAddress = 0 ) OR (FullPathAddress = 1 AND retPathErrorLevel = 1) ) AND (WinExist("ahk_id " WindowID) AND WinActive("ahk_id " WindowID)) )
		{
			If Message = ShowBalloonTip
			{
				If Repeat = 1
					BalloonTip( ScriptTitle AddToTitle, lng_CheckYourFolderOptions,"Info",WindowID,0)
				Else If Repeat <> Never
					BalloonTip( ScriptTitle AddToTitle, lng_CheckYourFolderOptions,"Info",0,0)
			}
			Else If Message = ShowMessage
			{
				If Repeat = 1
					BalloonTip( ScriptTitle AddToTitle, lng_CheckYourFolderOptions,"Info",WindowID,1)
				Else If Repeat <> Never
					BalloonTip( ScriptTitle AddToTitle, lng_CheckYourFolderOptions,"Info",0,1)
			}
			Return
		}

		; Aktuellen Pfad anhand der Adress- oder Titelleiste ermitteln
		If FullPathAddress = 1
		{
			If retPathErrorLevel = 1
				return
		}
		Else If FullPath = 1
		{
			WinGetTitle, retPath, ahk_id %WindowID%
			If A_OSversion = WIN_NT4
				StringReplace, retPath, retPath, % "Explorer - "
			If Enable_FreeSpace = 1
			{
				IfInString, retPath, % " (" lng_fs_FreeSpace " "
				{
					StringGetPos, FSpos, retPath, % " (" lng_fs_FreeSpace " "
					StringLeft, retPath, retPath, %FSpos%
				}
				StringRight, retPathR, retPath, % StrLen(lng_fs_FreeSpaceShort)+2
				IfInString, retPathR, % " " lng_fs_FreeSpaceShort ")"
				{
					StringGetPos, FSpos, retPath, % " (", R1
					StringLeft, retPath, retPath, %FSpos%
				}
			}
		}

		; Prüfe, ob 'Desktop' im Explorer ausgewählt wurde
		If RegDesktop = %retPath%
			retPath = %A_Desktop%

		; Prüfe, ob 'Eigene Dateien' im Explorer ausgewählt wurde
		If retPath in Eigene Dateien,My Documents,mijn documenten,%MyDocs%,%RegDir%
			retPath = %RegPersonal%

		Loop
		{
			If SpecialFolder%A_Index% =
				break
			RegRead, SpecialFolder, HKCR, % "CLSID\{" SpecialFolder%A_Index% "}"
			If retPath = %SpecialFolder%
				retPath := SpecialFolderRun%A_Index%
		}

		If (retPathErrorLevel=1 And WinActive("ahk_id " WindowID) )
		{
			If Message = ShowBalloonTip
			{
				If Repeat = 1
					BalloonTip(ScriptTitle AddToTitle, lng_CheckYourFolderOptions,"Info",1,0)
				Else If Repeat <> Never
					BalloonTip(ScriptTitle AddToTitle, lng_CheckYourFolderOptions,"Info",0,0)
			}
			Else If Message = ShowMessage
			{
				If Repeat = 1
					BalloonTip(ScriptTitle AddToTitle, lng_CheckYourFolderOptions,"Info",1,1)
				Else If Repeat <> Never
					BalloonTip(ScriptTitle AddToTitle, lng_CheckYourFolderOptions,"Info",0,1)
			}
		}

		If (InStr(FileExist(retPath),"R"))
		{
			FileGetShortcut, %retPath%, retPathNew
			If retPathNew <>
				retPath := retPathNew
		}

		If (!FileExist(retPath) AND !InStr(retPath,"::{"))
			retPath =

		Return %retPath%
	}
	Else If activeWinClass in Progman,WorkerW
	{
		retPath = %A_Desktop%
		Return %retPath%
	}
}

; S-1-1-0 = Everyone
; S-1-5-32-545 = Users
func_SetFileAccessRights( Path, GroupSID="", Rights="" ) {
	If GroupSID =
		GroupSID = S-1-1-0
	Group := Ansi2Oem(LookupAccountSid( GroupSID ))

	If Rights =
		RunWait, CACLS "%Path%" /T /E /C /R %Group%,,Hide
	Else
		RunWait, CACLS "%Path%" /T /E /C /G %Group%:%Rights%,,Hide
	Return ErrorLevel
}
