sub_Statistics:
	Gui, %GuiID_Statistics%:+LastFoundExist
	IfWinExist
	{
		Gui, %GuiID_Statistics%:Show
		Return
	}

	GuiDefault("Statistics", "-Resize +LastFoundExist")

	statIndent = 150

	statTime = %A_Now%
	EnvSub, statTime, statTimeLaunched, Minutes
	statTotalTimeTmp := statTotalTime+statTime
	If statTime > %statLongestSession%
		statLongestSession = %statTime%

	Gui, Font, b s13
	Gui, Add, Text, x10, %lng_Statistics%
	Gosub, GuiDefaultFont

	If A_IsCompiled = 1
		statAdd = %statAdd%%lng_StatCompiled%
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatVersion%:
	Gui, Add, Text, x+5, %ScriptTitle%%statAdd%
	statAdd =

	If MainDirNotWriteable = 1
		statAdd = %statAdd%%lng_StatWriteLocked%
	Gui, Add, Text, y+0, %A_ScriptFullPath% %statAdd%
	statAdd =

	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatMode%:
	If AHKonUSB = 1
		Gui, Add, Text, x+5, %UserMode% (%A_AutoHotkeyDriveType%)
	Else
		Gui, Add, Text, x+5, %UserMode%

	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatAHKVersion%:
	Gui, Add, Text, x+5, %A_AHKversion%
	Gui, Add, Text, y+0, %A_AHKPath%
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatOS%:
	Gui, Add, Text, x+5, % aa_osversionname " (" aa_osversionnumber "." func_GetOSVersionBuild() ") " A_OSWordSize "-Bit"
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatCompOS%:
	Gui, Add, Text, x+5, % A_OSversion " (" A_OStype ")"
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatUser%:
	If main_IsAdmin = 1
		statAdd = (Admin)
	Gui, Add, Text, x+5, %A_Username% %statAdd%
	statAdd =
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatComputer%:
	Gui, Add, Text, x+5, %A_Computername%
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatIP%:
	Gui, Add, Text, x+5, %A_Ipaddress1%
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatSettingsDir%:
	Gui, Add, Text, x+5, %WorkingDir%\%SettingsDir%

	Gui, Add, Text, x10 y+15 w%statIndent%, %lng_StatFirstLaunch%:
	Gui, Add, Text, x+5, % func_FormatTime(statFirstLaunch)
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatLastLaunched%:
	Gui, Add, Text, x+5, % func_FormatTime(statLastLaunched)
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatLaunchCount%:
	Gui, Add, Text, x+5, % statLaunchCount
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatExitCount%:
	Gui, Add, Text, x+5, % statExitCount
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatReloadCount%:
	Gui, Add, Text, x+5, % statReloadCount
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatUpdateCount%:
	Gui, Add, Text, x+5, % statUpdateCount
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatTotalTime%:
	Gui, Add, Text, x+5 vstatTotalTime, % func_FormatTime(statTotalTimeTmp, "duration")
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatSessionTime%:
	Gui, Add, Text, x+5 vstatSessionTime, % func_FormatTime(statTime, "duration")
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatLongestSession%:
	Gui, Add, Text, x+5 vstatLongestSession, % func_FormatTime(statLongestSession, "duration")
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatLoadingTime%:
	Gui, Add, Text, x+5 , % func_FormatTime(LoadingTime/1000, "duration precise seconds")
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatMainGuiBuildTime%:
	Gui, Add, Text, x+5 , % func_FormatTime(MainGuiBuildTime/1000, "duration precise seconds")

	Gui, Add, Text, x10 y+15 w%statIndent%, %lng_StatNumOfExtensions%:
	Gui, Add, Text, x+5 , %NumOfExtensions%
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatExtendRButton%:
	Gui, Add, Text, x+5 , % func_StrReplace( Hook_RButton, "|", ", ", "A" )
	Gui, Add, Text, x10 y+3 w%statIndent%, %lng_StatExtendMButton%:
	Gui, Add, Text, x+5 , % func_StrReplace( Hook_MButton, "|", ", ", "A" )

	Gui, Add, Button, -Wrap -Default gStatisticsToClipboard, %lng_StatisticsToClipboard%

	Gui, Show,, %lng_Statistics%

	SetTimer, tim_RefreshStats, 60000
Return

StatisticsGuiClose:
StatisticsGuiEscape:
	SetTimer, tim_RefreshStats, Off
	Gui, %GuiID_Statistics%:Destroy
Return

StatisticsToClipboard:
	WinGetText, AllStatistics, A
	ExtendedStatistics := "Statistics:`r`n---------------------------------------------------------------------"
	Loop, Parse, AllStatistics, `n, `r
	{
		If (A_Index = 1 OR A_LoopField = lng_StatisticsToClipboard)
			continue
		If (func_StrRight(A_LoopField,1) = ":")
			ExtendedStatistics .= "`r`n" A_LoopField
		Else
			ExtendedStatistics .= "`t" A_LoopField
	}
	ExtendedStatistics .= "`r`n---------------------------------------------------------------------`r`n"
	ExtendedStatistics .= "`r`nScreenareas:`r`n---------------------------------------------------------------------"

	ExtendedStatistics .= "`r`nMonitor:`t" MonitorLeft ", " MonitorTop ", " MonitorRight ", " MonitorBottom " = " MonitorWidth " x " MonitorHeight
	ExtendedStatistics .= "`r`nMonitorArea:`t" MonitorAreaLeft ", " MonitorAreaTop ", " MonitorAreaRight ", " MonitorAreaBottom " = " MonitorAreaWidth " x " MonitorAreaHeight
	ExtendedStatistics .= "`r`nWorkArea:`t" WorkAreaLeft ", " WorkAreaTop ", " WorkAreaRight ", " WorkAreaBottom " = " WorkAreaWidth " x " WorkAreaHeight

	Loop, %NumOfMonitors%
	{
		ExtendedStatistics .= "`r`n`r`nMonitor" A_Index ":`t" Monitor%A_Index%Left ", " Monitor%A_Index%Top ", " Monitor%A_Index%Right ", " Monitor%A_Index%Bottom " = " Monitor%A_Index%Width " x " Monitor%A_Index%Height
		ExtendedStatistics .= "`r`nWorkArea" A_Index ":`t" WorkArea%A_Index%Left ", " WorkArea%A_Index%Top ", " WorkArea%A_Index%Right ", " WorkArea%A_Index%Bottom " = " WorkArea%A_Index%Width " x " WorkArea%A_Index%Height
	}

	ExtendedStatistics .= "`r`n`r`nBorderHeight:`t" BorderHeight
	ExtendedStatistics .= "`r`nBorderHeightToolWindow:`t" BorderHeightToolWindow
	ExtendedStatistics .= "`r`nCaptionHeight:`t" CaptionHeight
	ExtendedStatistics .= "`r`nSmallCaptionHeight:`t" SmallCaptionHeight
	ExtendedStatistics .= "`r`nMenuBarHeight:`t" MenuBarHeight
	ExtendedStatistics .= "`r`nScrollBarHWeight:`t" ScrollBarHWeight
	ExtendedStatistics .= "`r`nScrollBarVWeight:`t" ScrollBarVWeight

	Loop
	{
		actExtension := Extension[%A_Index%]
		If actExtension =
			Break

		ExtendedStatistics .= "`r`n---------------------------------------------------------------------`r`n"
		ExtendedStatistics .= "`r`n" actExtension ":`r`n---------------------------------------------------------------------"
		ExtendedStatistics .= "`r`nEnable_" actExtension ":`t" Enable_%actExtension%
		ExtendedStatistics .= "`r`nExtensionVersion:`t" ExtensionVersion[%actExtension%]
		ExtendedStatistics .= "`r`nExtensionPrefix:`t" ExtensionPrefix[%actExtension%]
		ExtendedStatistics .= "`r`nExtensionMenuName:`t" ExtensionMenuName[%actExtension%]
		ExtendedStatistics .= "`r`nExtensionHideSettings:`t" ExtensionHideSettings[%actExtension%]
		ExtendedStatistics .= "`r`nExtension:`t" Extension[%actExtension%]
		ExtendedStatistics .= "`r`nExtensionLoadingTime:`t" ExtensionLoadingTime[%actExtension%] " ms"
		ExtendedStatistics .= "`r`nExtensionGuiTime:`t" ExtensionGuiTime[%actExtension%] " ms"
		ExtendedStatistics .= "`r`nEnableTray_" actExtension ":`t" EnableTray_%actExtension%
		ExtendedStatistics .= "`r`n"

		If (IsLabel( "Statistics_" actExtension ))
			Gosub, Statistics_%actExtension%
	}

	Clipboard = %ExtendedStatistics%
	AllStatistics =
	Gosub, StatisticsGuiClose
Return

tim_RefreshStats:
	statTime = %A_Now%
	EnvSub, statTime, statTimeLaunched, Minutes
	statTotalTimeTmp := statTotalTime+statTime
	If statTime > %statLongestSession%
		statLongestSession = %statTime%
	Gui, %GuiID_Statistics%:Default
	GuiControl, , statTotalTime, % func_FormatTime(statTotalTimeTmp, "duration")
	GuiControl, , statSessionTime, % func_FormatTime(statTime, "duration")
	GuiControl, , statLongestSession, % func_FormatTime(statLongestSession, "duration")
Return
