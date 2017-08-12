; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               Eject
; -----------------------------------------------------------------------------
; Prefix:             ej_
; Version:            1.4
; Date:               2008-01-04
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_Eject:
	Prefix                 = ej
	%Prefix%_ScriptName    = Eject
	%Prefix%_ScriptVersion = 1.4
	%Prefix%_Author        = Wolfgang Reszel

	CreateGuiID("Eject")
	CreateGuiID("EjectOSD")

	IconFile_On_Eject  = %A_WinDir%\system32\shell32.dll
	IconPos_On_Eject = 218

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %ej_ScriptName% - Medien auswerfen
		Description                   = CDs und andere Medien per Tastaturkürzel auswerfen.
		lng_ej_Drive                  = Laufwerk
		lng_ej_Hotkey                 = Tastaturkürzel
		lng_ej_ShowOSD                = Grafische Anzeige aktivieren (OSD)
		lng_ej_removedriveOn          = RemoveDrive.exe wurde gefunden
		lng_ej_CustomDevices          = Gerätenamen zuweisen (zur Problembehebung) ...
		lng_ej_CustomDevicesDesc      = Hier können Sie Laufwerksbuchstaben oder eigene Bezeichnungen internen Geräten zuweisen.`nDIE VERWENDUNG DIESES DIALOGS GESCHIEHT AUF EIGENE GEFAHR!
		lng_ej_AsignedName            = Name/Laufwerk
		lng_ej_SelectedDevice         = zugewiesenes Gerät (Geräte-ID [Klasse\Subklasse\ID 'Name'], Gerätename [NamederPlatte] oder Laufwerksbuchstabe [F:])
		lng_ej_CantEjectNetwork       = Das Netzlaufwerk kann nicht ausgeworfen werden,`nda möglicherweise Dateien in Verwendung oder Ordner geöffnet sind!
		lng_ej_CantEjectREMOVABLE     = Das Laufwerk oder Medium kann nicht ausgeworfen werden,`nda möglicherweise Dateien in Verwendung oder Ordner geöffnet sind!
		lng_ej_CantEjectCUSTOM        = Das Laufwerk oder Medium kann nicht mit DevEject.exe ausgeworfen werden.`nEntweder wird das Laufwerk nicht unterstützt oder Dateien/Verzeichnisse sind geöffnet!
		lng_ej_CantEjectCUSTOMRD      = Das Laufwerk oder Medium kann nicht mit RemoveDrive.exe ausgeworfen werden.`nEntweder wird das Laufwerk nicht unterstützt oder Dateien/Verzeichnisse sind geöffnet!
	}
	else        ; = other languages (english)
	{
		MenuName                      = %ej_ScriptName% - eject media
		Description                   = Ejects CDs or other media with hotkeys.
		lng_ej_Drive                  = Drive
		lng_ej_Hotkey                 = Hotkey
		lng_ej_ShowOSD                = enable on-screen-display
		lng_ej_removedriveOn          = RemoveDrive.exe has been found
		lng_ej_CustomDevices          = Custom devicenames (for external devices and to solve problems) ...
		lng_ej_CustomDevicesDesc      = You can assign internal devices to drive-letters or own names.`nUSE THIS DIALOG AT YOUR OWN RISK!
		lng_ej_AsignedName            = name/drive
		lng_ej_SelectedDevice         = assigned device (device id [class\subclass\id 'name'], device name [DriveName] or drive letter [F:])
		lng_ej_CantEjectNetwork       = Can't eject the network drive,`nbecause files are in use or folders or opened!
		lng_ej_CantEjectREMOVABLE     = Can't eject the drive or media,`nbecause files are in use or folders or opened!
		lng_ej_CantEjectCUSTOM        = Can't eject the drive or media with DevEject.exe,`nbecause files/folders are in use or DevEject does not support this drive!
		lng_ej_CantEjectCUSTOMRD      = Can't eject the drive or media with RemoveDrive.exe,`nbecause files/folders are in use or RemoveDrive does not support this drive!
	}
	If CustomLanguage <>
		gosub, CustomLanguage

	IfExist, %A_ScriptDir%\Library\Tools\RemoveDrive.exe
		Description = %Description%`n%lng_ej_removedriveOn%

	If activAid_HasChanged = 1
	{
		IfNotExist, extensions\Media\ac'tivAid_Eject_eject.gif
		{
			func_UnpackSplash("extensions\Media\ac'tivAid_Eject_eject.gif")
			FileInstall, extensions\Media\ac'tivAid_Eject_eject.gif, extensions\Media\ac'tivAid_Eject_eject.gif
		}
	}

	ej_FadeSpeed = 10 ; Ausblenden-Geschwindigkeit

	ej_Classes =  ,ahk_class ExploreWClass,ahk_class CabinetWClass,ahk_class Progman,ahk_class WorkerW

	Loop, 10
	{
		IniRead, ej_Drive%A_Index%, %ConfigFile%, %ej_ScriptName%, Drive%A_Index%
		If ej_Drive%A_Index% = ERROR
			ej_Drive%A_Index% =

		If (A_Index = 1 AND ej_Drive%A_Index% = "")
		{
			ej_Drive%A_Index% = *
			func_HotkeyRead( "ej_Hotkey" A_Index, ConfigFile, ej_ScriptName, "Hotkey" A_Index, "sub_Hotkey_Eject", "!+e", "$", ej_Classes )
			continue
		}

		If (A_Index = 2 AND ej_Drive%A_Index% = "")
		{
			DriveGet, ej_Drives, List, CDROM
			StringLeft, ej_Drives, ej_Drives, 1
			ej_Drive%A_Index% = %ej_Drives%
			func_HotkeyRead( "ej_Hotkey" A_Index, ConfigFile, ej_ScriptName, "Hotkey" A_Index, "sub_Hotkey_Eject", "ScrollLock", "$", ej_Classes )
			continue
		}

		func_HotkeyRead( "ej_Hotkey" A_Index, ConfigFile, ej_ScriptName, "Hotkey" A_Index, "sub_Hotkey_Eject", "", "$", ej_Classes )

		If ej_Drive%A_Index% =
			func_HotkeyDisable( "ej_Hotkey" A_Index )
	}

	Loop,10
	{
		IniRead, ej_Device%A_Index%, %ConfigFile%, %ej_ScriptName%, Device%A_Index%, %A_Space%
		IniRead, ej_DeviceID%A_Index%, %ConfigFile%, %ej_ScriptName%, DeviceID%A_Index%, %A_Space%
		AutoTrim, Off
		StringReplace, ej_Device%A_Index%,ej_Device%A_Index%, `%20, %A_Space%, A
		StringReplace, ej_DeviceID%A_Index%,ej_DeviceID%A_Index%, `%20, %A_Space%, A

		ej_Device%A_Index%_Undo := ej_Device%A_Index%
		ej_DeviceID%A_Index%_Undo := ej_DeviceID%A_Index%
		AutoTrim, On
		If ej_Device%A_Index% <>
			ej_CustomDevices := ej_CustomDevices "|" ej_Device%A_Index%
	}

	IniRead, ej_EnableOSD, %ConfigFile%, %ej_ScriptName%, OSD, 1
Return

SettingsGui_Eject:
	DriveGet, ej_Drives, List, CDROM
	DriveGet, ej_Drives2, List, REMOVABLE
	ej_Drives = %ej_Drives%%ej_Drives2%

	ej_AllDrives = |*
	Loop, Parse, ej_Drives,
	{
		ej_AllDrives = %ej_AllDrives%|%A_LoopField%
	}
	Sort, ej_AllDrives, D|

	ej_AllDrives = %ej_AllDrives%%ej_CustomDevices%

	Loop, 10
	{
		Gui, Add, Text, XS+10 y+7, %lng_ej_Drive%:
		Gui, Add, ComboBox, gsub_CheckIfSettingsChanged X+5 yp-4 W90 vej_Drive%A_Index%,%ej_AllDrives%
		func_HotkeyAddGuiControl( lng_ej_Hotkey, "ej_Hotkey" A_Index, "x+20 yp+4" )
		IfNotInstring, ej_AllDrives, % ej_Drive%A_Index%
			GuiControl, , ej_Drive%A_Index%, % ej_Drive%A_Index%
		GuiControl, Choosestring, ej_Drive%A_Index%, % ej_Drive%A_Index%
	}
	IfExist, %A_ScriptDir%\Library\Tools\deveject.exe
		Gui, Add, Button, -Wrap xs+10 y+5 gej_sub_CustomDevices, %lng_ej_CustomDevices%
	Gui, Add, CheckBox, gsub_CheckIfSettingsChanged vej_EnableOSD xs+310 ys+290 -Wrap Checked%ej_EnableOSD%, %lng_ej_ShowOSD%
Return

ej_sub_CustomDevices:
	Gui, %GuiID_activAid%:+Disabled
	GuiDefault("Eject", "+Owner" GuiID_activAid)
	Gosub, GuiDefaultFont
	Gui, Add, Text, , %lng_ej_CustomDevicesDesc%
	ej_Progress = 0
	Progress,B2 H30 R0-150
	RunWait, %ComSpec% /c ""%A_ScriptDir%\Library\Tools\deveject.exe" -v > "%A_Temp%\deveject.tmp"",,Hide
	ej_Progress++
	Progress, %ej_Progress%
	Sleep, 50
	ej_Progress++
	Progress, %ej_Progress%
	FileRead, ej_devejectOutput, %A_Temp%\deveject.tmp
	FileDelete, %A_Temp%\deveject.tmp
	ej_Devices =
	Loop, Parse, ej_devejectOutput, `n, `r
	{
		ej_Progress++
		Progress, %ej_Progress%
		If A_LoopField =
			continue
		If A_Index < 3
			continue
		ej_Devices = %ej_Devices%|%A_LoopField%
	}
	DriveGet, ej_RegularDrives, List
	ej_Devices = %ej_Devices%|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Loop, Parse, ej_RegularDrives
	{
		If A_LoopField =
			continue
		ej_Devices = %ej_Devices%|%A_LoopField%:
	}
	ej_Devices = %ej_Devices%|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Loop, Parse, ej_RegularDrives
	{
		DriveGet, ej_DriveLabel, Label, %A_LoopField%:
		If ej_DriveLabel =
			continue
		ej_Devices = %ej_Devices%|%ej_DriveLabel%
	}

	StringReplace, ej_Devices, ej_Devices, ||, |, All

	Gui, Add, Text, x10 y+15, %lng_ej_AsignedName%
	Gui, Add, Text, x100 yp, %lng_ej_SelectedDevice%
	Loop,10
	{
		ej_Progress := ej_Progress + 3
		Progress, %ej_Progress%
		Gui, Add, Edit, x10 y+5 w80 vej_Device%A_Index%_tmp, % ej_Device%A_Index%
		Gui, Add, Button, x+5 yp+3 h15 -Wrap vej_Test%A_Index% gej_sub_TestDevice, ->
		Gui, Font, S%FontSize7%, Arial
		Gui, Font, S%FontSize7%, Tahoma
		Gui, Add, ComboBox, x+5 yp-2 w680 vej_DeviceID%A_Index%_tmp, %ej_Devices%
		Gosub, GuiDefaultFont
		GuiControl, ChooseString, ej_DeviceID%A_Index%_tmp, % ej_DeviceID%A_Index%
		If ErrorLevel = 1
		{
			If ej_DeviceID%A_Index% =
			{
				GuiControl, Choose, ej_DeviceID%A_Index%_tmp, 0
			}
			Else
			{
				GuiControl, , ej_DeviceID%A_Index%_tmp, ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				GuiControl, , ej_DeviceID%A_Index%_tmp, % ej_DeviceID%A_Index%
				GuiControl, ChooseString, ej_DeviceID%A_Index%_tmp, % ej_DeviceID%A_Index%
			}
		}
	}
	Gui, Add, Button, -Wrap X320 W80 Default gej_sub_CustomDevicesOK, %lng_OK%
	Gui, Add, Button, -Wrap X+5 W80 gEjectGuiClose, %lng_cancel%

	Gui, Show, w810, %ej_ScriptName% - %lng_ej_CustomDevices%
	Progress, Off
Return

EjectGuiClose:
EjectGuiEscape:
	Gui, %GuiID_activAid%:-Disabled
	Gui, Destroy
Return

ej_sub_TestDevice:
	StringReplace, ej_Index, A_GuiControl, ej_Test,
	GuiControlGet, ej_TempDrv,,ej_Device%ej_Index%_tmp
	IfNotInstring, ej_TempDrv, `:
		ej_TempDrv = %ej_TempDrv%:
	If( StrLen(ej_TempDrv) <> 2)
		Return
	RunWait, %ComSpec% /c ""%A_ScriptDir%\Library\Tools\deveject.exe" -EjectDrive:%ej_TempDrv% > "%A_Temp%\deveject.tmp"",,Hide
	Sleep, 50
	FileRead, ej_devejectOutput, %A_Temp%\deveject.tmp
	FileDelete, %A_Temp%\deveject.tmp
	Loop, Parse, ej_devejectOutput, `n, `r
	{
		If A_Index < 3
			continue
		ej_Detect = %A_LoopField%
		Break
	}
	Tooltip, %ej_Detect%, %A_CaretX%, % A_CaretY+15
	SetTimer, ej_tim_ToolTipOff, 5000
	IfInString, ej_Detect, [
	{
		StringSplit, ej_Detect, ej_Detect, [
		StringSplit, ej_Detect, ej_Detect2, ]
		ej_Detect = %ej_Detect1%
	}
	Else
	{
		StringReplace, ej_Detect, ej_Detect, Error ejecting device%A_Space%
		StringSplit, ej_Detect, ej_Detect, `,
		ej_Detect = %ej_Detect1%
	}
	ej_Spaces =
	AutoTrim, Off
	Loop,20
	{
		ej_Spaces := ej_Spaces " "
		GuiControl, ChooseString, ej_DeviceID%ej_Index%_tmp, %ej_Spaces%%ej_Detect%
		If ErrorLevel = 0
			Break
	}
Return

ej_sub_CustomDevicesOK:
	AutoTrim, Off
	Gui, Submit, Nohide
	Gosub, EjectGuiClose

	ej_CustomDevices =
	Loop,10
	{
		ej_Device%A_Index% := ej_Device%A_Index%_tmp
		ej_DeviceID%A_Index% := ej_DeviceID%A_Index%_tmp

		StringReplace, ej_Device%A_Index%,ej_Device%A_Index%, %A_Space%, `%20, A
		StringReplace, ej_DeviceID%A_Index%,ej_DeviceID%A_Index%, %A_Space%, `%20, A

		StringReplace, ej_Device%A_Index%,ej_Device%A_Index%, `%20, %A_Space%, A
		StringReplace, ej_DeviceID%A_Index%,ej_DeviceID%A_Index%, `%20, %A_Space%, A

		If ej_Device%A_Index% <>
			ej_CustomDevices := ej_CustomDevices "|" ej_Device%A_Index%
	}

	ej_AllDrives = |*
	Loop, Parse, ej_Drives,
	{
		ej_AllDrives = %ej_AllDrives%|%A_LoopField%
	}
	Sort, ej_AllDrives, D|

	ej_AllDrives = %ej_AllDrives%%ej_CustomDevices%

	Loop,10
	{
		GuiControl, %GuiID_activAid%:,ej_Drive%A_Index%,%ej_AllDrives%
		IfNotInstring, ej_AllDrives, % ej_Drive%A_Index%
			GuiControl, %GuiID_activAid%:, ej_Drive%A_Index%, % ej_Drive%A_Index%
		GuiControl, %GuiID_activAid%:Choosestring, ej_Drive%A_Index%, % ej_Drive%A_Index%
	}
	func_SettingsChanged( ej_ScriptName )
Return

ej_tim_ToolTipOff:
	SetTimer, ej_tim_ToolTipOff, Off
	Tooltip
Return

SaveSettings_Eject:
	Loop, 10
	{
		func_HotkeyWrite( "ej_Hotkey" A_Index, ConfigFile, ej_ScriptName, "Hotkey" A_Index )
		IniWrite, % ej_Drive%A_Index%, %ConfigFile%, %ej_ScriptName%, Drive%A_Index%
	}
	ej_CustomDevices =
	Loop,10
	{
		StringReplace, ej_Device%A_Index%,ej_Device%A_Index%, %A_Space%, `%20, A
		StringReplace, ej_DeviceID%A_Index%,ej_DeviceID%A_Index%, %A_Space%, `%20, A

		IniWrite, % ej_Device%A_Index%, %ConfigFile%, %ej_ScriptName%, Device%A_Index%
		IniWrite, % ej_DeviceID%A_Index%, %ConfigFile%, %ej_ScriptName%, DeviceID%A_Index%

		StringReplace, ej_Device%A_Index%,ej_Device%A_Index%, `%20, %A_Space%, A
		StringReplace, ej_DeviceID%A_Index%,ej_DeviceID%A_Index%, `%20, %A_Space%, A

		ej_Device%A_Index%_Undo := ej_Device%A_Index%
		ej_DeviceID%A_Index%_Undo := ej_DeviceID%A_Index%

		If ej_Device%A_Index% <>
			ej_CustomDevices := ej_CustomDevices "|" ej_Device%A_Index%
	}

	IniWrite, %ej_EnableOSD%, %ConfigFile%, %ej_ScriptName%, OSD

	DriveGet, ej_Drives, List, CDROM
	DriveGet, ej_Drives2, List, REMOVABLE
	ej_Drives = %ej_Drives%%ej_Drives2%

	ej_AllDrives = |*
	Loop, Parse, ej_Drives,
	{
		ej_AllDrives = %ej_AllDrives%|%A_LoopField%
	}
	Sort, ej_AllDrives, D|

	ej_AllDrives = %ej_AllDrives%%ej_CustomDevices%

	If mainGUiVisible = 2
	{
		DriveGet, ej_Drives, List, CDROM
		IfExist, %A_ScriptDir%\Library\Tools\deveject.exe
			DriveGet, ej_Drives2, List, REMOVABLE
		ej_Drives = %ej_Drives%%ej_Drives2%

		ej_AllDrives = |*
		Loop, Parse, ej_Drives,
		{
			ej_AllDrives = %ej_AllDrives%|%A_LoopField%
		}
		Sort, ej_AllDrives, D|

		ej_AllDrives = %ej_AllDrives%%ej_CustomDevices%

		Loop, 10
		{
			GuiControl,,ej_Drive%A_Index%,|%ej_AllDrives%
			GuiControl, Choosestring, ej_Drive%A_Index%, % ej_Drive%A_Index%
		}
	}
Return

CancelSettings_Eject:
	Loop,10
	{
		ej_Device%A_Index% := ej_Device%A_Index%_Undo
		ej_DeviceID%A_Index% := ej_DeviceID%A_Index%_Undo
	}
	ej_CustomDevices =
	Loop,10
	{
		StringReplace, ej_Device%A_Index%,ej_Device%A_Index%, %A_Space%, `%20, A
		StringReplace, ej_DeviceID%A_Index%,ej_DeviceID%A_Index%, %A_Space%, `%20, A

		IniWrite, % ej_Device%A_Index%, %ConfigFile%, %ej_ScriptName%, Device%A_Index%
		IniWrite, % ej_DeviceID%A_Index%, %ConfigFile%, %ej_ScriptName%, DeviceID%A_Index%

		StringReplace, ej_Device%A_Index%,ej_Device%A_Index%, `%20, %A_Space%, A
		StringReplace, ej_DeviceID%A_Index%,ej_DeviceID%A_Index%, `%20, %A_Space%, A

		ej_Device%A_Index%_Undo := ej_Device%A_Index%
		ej_DeviceID%A_Index%_Undo := ej_DeviceID%A_Index%

		If ej_Device%A_Index% <>
			ej_CustomDevices := ej_CustomDevices "|" ej_Device%A_Index%
	}
Return

DoEnable_Eject:
	Loop, 10
	{
		func_HotkeyEnable( "ej_Hotkey" A_Index )
	}
Return

DoDisable_Eject:
	Loop, 10
	{
		func_HotkeyDisable( "ej_Hotkey" A_Index )
	}
Return

DefaultSettings_Eject:
Return

Statistics_Eject:
	ExtendedStatistics .=

	Loop,10
	{
		ExtendedStatistics .= "`nej_Drive" A_Index ":`t" ej_Drive%A_Index%
		ExtendedStatistics .= "`nej_Device" A_Index ":`t" ej_Device%A_Index%
		ExtendedStatistics .= "`nej_DeviceID" A_Index ":`t" ej_DeviceID%A_Index%
	}
Return

; ---------------------------------------------------------------------
; -- Tastaturkürzel ---------------------------------------------------
; ---------------------------------------------------------------------

sub_Hotkey_Eject:
	ej_DriveKey := func_HotkeyGetVar("ej_Hotkey",11,"ej_Drive",activAid_ThisHotkey,"$")
	ej_LastEject = %ej_Drive%

	If ej_DriveKey = AllCD
	{
		ej_DriveKey =
		DriveGet, ej_Drive, List, CDROM
		ej_Drive = %ej_Drive%
		Loop, Parse, ej_Drive
			ej_DriveKey = %ej_DriveKey%%A_LoopField%,
		StringTrimRight,ej_DriveKey,ej_DriveKey,1
	}
	Loop, Parse, ej_DriveKey, `,
	{
		ej_Drive = %A_LoopField%
		if ej_Drive = *
		{
			WinGet, ej_WinID, ID, A
			WinGetClass, ej_Class, ahk_id %ej_WinID%
			If ej_Class not contains ExploreWClass,CabinetWClass,Progman,WorkerW
			{
				StringTrimLeft, ej_Thishotkey, A_Thishotkey, 1
				StringLower, ej_Thishotkey, ej_Thishotkey
				Send, % func_prepareHotkeyForSend(ej_Thishotkey)
				Return
			}
			ej_actDir := func_GetDir(ej_WinID)

			If ej_actDir <>
			{
				If ej_actDir = %A_Desktop%
				{
					ControlGet, ej_Selected, List, Focused Col1, SysListView321, A
					FileGetShortcut, %ej_actDir%\%ej_Selected%.lnk, ej_TmpTarget,,ej_TmpArgs
					If ej_TmpTarget = %A_WinDir%\explorer.exe
						ej_TmpTarget = %ej_TmpArgs%
					Else
						ej_Drive =

					If (func_StrRight(ej_TmpTarget,2) = ":\")
					{
						StringRight, ej_Drive, ej_TmpTarget, 3
						StringLeft, ej_Drive, ej_Drive, 1
					}
					Else
						Return
				}
				Else IfInString, ej_actDir, \
				{
					;If (func_StrRight(ej_actDir,2) = ":\")
					IfInString, ej_actDir, `:\
					{
						ej_Drive := func_StrLeft(ej_actDir,1)
						WinClose, ahk_id %ej_WinID%
						WinWaitClose, ahk_id %ej_WinID%
						Sleep, 500
					}
					Else
						Return
				}
				Else If ej_actDir = ::{20D04FE0-3AEA-1069-A2D8-08002B30309D}
				{
					ControlGet, ej_Selected, List, Focused Col1, SysListView321, A
					IfInString, ej_Selected, `:)
					{
						StringGetPos, ej_Pos, ej_Selected, `:)
						StringLeft, ej_Drive, ej_Selected, %ej_Pos%
						StringRight, ej_Drive, ej_Drive, 1
					}
					Else
						Return
				}
				Else
					Return
			}
		}
		ej_InCustomDevices = 0
		Loop, 10
		{
			If ej_Device%A_Index% = %ej_Drive%
			{
				ej_InCustomDevices = %A_Index%
				IfInString, ej_DeviceID%A_Index%, RemoveDrive
				{
					StringReplace, ej_DevID, ej_DeviceID%A_Index%, RemoveDrive:
					StringReplace, ej_DevID, ej_DevID, RemoveDrive.exe
					StringReplace, ej_DevID, ej_DevID, RemoveDrive
				}
				Else
				{
					StringSplit, ej_DevID, ej_DeviceID%A_Index%, '
					AutoTrim, On
					ej_DevID = -EjectId:"%ej_DevID1%"
					If (ej_DevID2 = "" AND !InStr(ej_DevID1,"\"))
					{
						StringReplace, ej_DevID1, ej_DeviceID%A_Index%, ",,A
						; " end qoute for syntax highlighting
						StringReplace, ej_DevID1, ej_DevID1, ',,A
						ej_DevID = -EjectName:"%ej_DevID1%"
					}
					If (func_StrRight(ej_DeviceID%A_Index%,1) = ":" AND StrLen(ej_DeviceID%A_Index%) = 2)
					{
						ej_DevID1 := ej_DeviceID%A_Index%
						ej_DevID = -EjectDrive:%ej_DevID1%
					}
				}
				break
			}
		}

		If ej_InCustomDevices = 0
		{
			DriveGet, ej_Type, Type, %ej_Drive%:
		}
		Else
		{
			ej_Type = CUSTOMDEVICE
			IfNotExist, %A_ScriptDir%\Library\Tools\deveject.exe
				Return
		}

		gosub, ej_main_Eject
	}
Return

; ---------------------------------------------------------------------
ej_main_Eject: ; Medium auswerfen [ej_Drive]
	di_cantEject =
	ej_transparent = 150 ; Anfangstransparenz

	; Position berechnen
	ej_posY  := A_ScreenHeight - (A_ScreenHeight / 4) - 103

	ej_Close = 0
	ej_cantEject =

	Settimer, ej_tim_FadeOSD, Off
	Gui, %GuiID_EjectOSD%:Destroy

	; Auswefen-Symbol darstellen
	GuiDefault("EjectOSD")

	ej_TickCount = %A_TickCount%

	If ej_EnableOSD = 1
	ifExist, %A_ScriptDir%\extensions\Media\ac'tivAid_Eject_eject.gif ; nur wenn auch vorhanden
	{
		Gui, %GuiID_EjectOSD%:Default
		Gui, +Lastfound +Disabled +ToolWindow -Caption +AlwaysOnTop
		Gui, Add, pic, x0 y0 w205 h205, %A_ScriptDir%\extensions\Media\ac'tivAid_Eject_eject.gif  ; Bild laden
		Gui, Font, S16 bold C666666, Arial
		Gui, Add, Text, BackgroundTrans x8 y153 Center w200, %ej_Drive%
		Gui, Font, S16 bold C555555, Arial
		Gui, Add, Text, BackgroundTrans x7 y152 Center w200, %ej_Drive%
		Gui, Font, S16 bold C333333, Arial
		Gui, Add, Text, BackgroundTrans x6 y151 Center w200, %ej_Drive%
		Gui, Font, S16 bold Cffffff, Arial
		Gui, Add, Text, BackgroundTrans x5 y150 Center w200, %ej_Drive%
		WinGet, ej_OSDid, ID
		WinSet, TransColor ,0000FF %ej_transparent%    ; Transparenz setzen
		WinSet, AlwaysOnTop, On                        ; Immer im Vordergrund
		Gui, Show, w205 h205 y%ej_posY% NA             ; Symbol darstellen
	}
	If ej_Type = REMOVABLE
	{
		Critical, On
		ej_Error := func_EjectMedia(ej_Drive)
		Sleep, 500
		DriveGet, ej_Status, Status, %ej_Drive%:
		If (ej_Status <> "Invalid" AND ej_Status <> "NotReady" AND ej_Status <> "Unknown" AND ej_Error = 0)
		{
			IfExist, %A_ScriptDir%\Library\Tools\deveject.exe
			{
				RunWait, %A_ScriptDir%\Library\Tools\deveject.exe -EjectDrive:%ej_Drive%:,,Hide UseErrorlevel
			}
		}
		Critical, Off
		Sleep, 500
	}
	Else If ej_Type = CUSTOMDEVICE
	{
		IfInString, ej_DeviceID%ej_InCustomDevices%, RemoveDrive
		{
			RunWait, %A_ScriptDir%\Library\Tools\RemoveDrive.exe %ej_DevID%,,Hide UseErrorlevel
			If ErrorLevel <> 0
				ej_cantEject = CUSTOMRD
		}
		Else
		{
			RunWait, %A_ScriptDir%\Library\Tools\deveject.exe %ej_DevID%,,Hide UseErrorlevel
			If ErrorLevel <> 0
				ej_cantEject = CUSTOM
		}
	}
	Else If ej_Type = Network
	{
		Run, net use %ej_Drive%: /delete,, Hide UseErrorlevel, ej_NetID
		DetectHiddenWindows, On
		WinWait, ahk_pid %ej_NetID%,, 1
		WinWaitClose, ahk_pid %ej_NetID%,,3
		If ErrorLevel = 1
		{
			WinClose, ahk_pid %ej_NetID%
			ej_cantEject = Network
		}
		Else
			Sleep,1000
	}
	Else
	{
		Drive, Eject, %ej_Drive%:                         ; Medium auswerfen

		If (A_TickCount - ej_TickCount < 1000 AND ej_OnlyEject <> 1) ; Wenn Auswerfen sehr schnell ging
		{                                                 ; dann war das Laufwerk schon offen
			Drive, Eject, %ej_Drive%:, 1                   ; also wird es nun geschlossen
			ej_Close = 1
		}
	}
	If A_TickCount - ej_TickCount < 1000
		Sleep,500

	; Auswerfen-Symbol langsam ausblenden
	If ej_EnableOSD = 1
	{
		IfExist, %A_ScriptDir%\extensions\Media\ac'tivAid_Eject_eject.gif ; nur wenn auch vorhanden
		{
			ej_StartTicks = %A_TickCount%
			Settimer, ej_tim_FadeOSD, 5
		}
	}

	If ej_Close = 0
	{
		DriveGet, ej_Status, Status, %ej_Drive%:
		If (ej_Status <> "Invalid" AND ej_Status <> "NotReady" AND ej_Status <> "Unknown" AND ej_cantEject = "")
		{
			Sleep, 500
			DriveGet, ej_Status, Status, %ej_Drive%:
			If (ej_Status <> "Invalid" AND ej_Status <> "NotReady" AND ej_Status <> "Unknown")
				ej_cantEject = REMOVABLE
		}


		If ej_cantEject = CUSTOM
			BalloonTip( ej_ScriptName " " ej_Drive ":", lng_ej_CantEject%ej_cantEject% " (" ej_Status ")`n`n" ej_DevID, "Info")
		Else If ej_cantEject <>
			BalloonTip( ej_ScriptName " " ej_Drive ":", lng_ej_CantEject%ej_cantEject% " (" ej_Status ")", "Info")
	}
return

ej_tim_FadeOSD: ; Transparenz runterzählen
	ej_Ticks := (A_TickCount-ej_StartTicks) / 500
	ej_transparent := ej_transparent - ej_FadeSpeed * ej_Ticks   ; Transparenz runterzählen
	if ej_transparent < 1
	{
		Settimer, ej_tim_FadeOSD, Off
		Gui, %GuiID_EjectOSD%:Destroy
		Return
	}
	WinSet, TransColor,0000FF %ej_transparent%, ahk_id %ej_OSDid%  ; Transparenz setzen
Return

func_EjectMedia(ej_Drive)
{
	ej_DrivePath = \\.\%ej_Drive%:
	hVolume := DllCall("CreateFile"
			, str, ej_DrivePath
			, UInt, 0x80000000 | 0x40000000   ;GENERIC_READ | GENERIC_WRITE
			, UInt, 0x0      ;Tries to get exclusiv rights to the drive
			, UInt, Null
			, UInt, 0x3         ;OPEN_EXISTING
			, UInt, 0x0
			, UInt, NULL)

	if hVolume != -1      ;Drive is thrown out
	{
		DllCall("FlushFileBuffers", UInt, hVolume)

		DllCall("DeviceIoControl"
			, UInt, hVolume
			, UInt, 0x90018   ;FSCTL_LOCK_VOLUME
			, UInt, NULL
			, UInt, 0
			, UInt, NULL
			, UInt, 0
			, UInt, &dwBytesReturned   ;Not used
			, UInt,  NULL)

		DllCall("DeviceIoControl"
			, UInt, hVolume
			, UInt, 0x90020   ;FSCTL_DISMOUNT_VOLUME
			, UInt, NULL
			, UInt, 0
			, UInt, NULL
			, UInt, 0
			, UInt, &dwBytesReturned   ;Not used
			, UInt,  NULL)

		DllCall("DeviceIoControl"
			, UInt, hVolume
			, UInt, 0x2D4808   ;IOCTL_STORAGE_EJECT_MEDIA
			, UInt, NULL
			, UInt, 0
			, UInt, NULL
			, UInt, 0
			, UInt, &dwBytesReturned   ;Not used
			, UInt,  NULL)

		DllCall("CloseHandle", UInt, hVolume)
		Return 0
	}
	Else
		Return 1
}
