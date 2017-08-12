; Falls BalloonTips deaktiviert sind, normale Meldung ausgeben
BalloonTip( Title, Text, Symbol="", OnlyOnce=0, AlwaysMessageBox=0, TimeOut="" ) {
	Global
	if(_OSDTips = 1 && gdiP_enabled = 1)
	{
		if TimeOut =
			TimeOut = 5

		osd_BalloonTip( Title, Text, Symbol, OnlyOnce, AlwaysMessageBox, TimeOut )
		Return
	}
	If (OnlyOnce = 1 AND LoadingFinished = 1)
	{
		OnceVar =
		OnceVar := "OnceVar" func_StrLeft(func_Hex(Title),16) func_StrRight(func_Hex(Title) func_Hex(Text),16)
		If %OnceVar% = 1
			Return
	}

	If OnlyOnce = Reset
	{
		OnceVar =
		OnceVar := "OnceVar" func_StrLeft(func_Hex(Title),16) func_StrRight(func_Hex(Title) func_Hex(Text),16)
		%OnceVar% =
		Return
	}

	If (OnlyOnce <> "" AND OnlyOnce <> 1 AND OnlyOnce <> "Reset")
	{
		OnceVar =
		OnceVar := "OnceVar" func_StrLeft(func_Hex(OnlyOnce),16) func_StrRight(func_Hex(OnlyOnce),16)
		If %OnceVar% = 1
			Return
	}

	If (EnableBalloonTips = 0 OR AlwaysMessageBox = 1 OR _MessageBoxTips = 1 OR NoTrayIcon = 1)
	{
		If AlwaysMessageBox <> -1
		{
			Gui %GuiID_activAid%:+OwnDialogs
			If Symbol = Info
				MsgBox,64, %Title%, %Text%, %TimeOut%
			If Symbol = Warning
				MsgBox,48, %Title%, %Text%, %TimeOut%
			If Symbol = Error
				MsgBox,16, %Title%, %Text%, %TimeOut%
		}
	}
	Else
	{
		If Symbol = Info
			Symbol = 1
		If Symbol = Warning
			Symbol = 2
		If Symbol = Error
			Symbol = 3
		TrayTip, %Title%, %Text%,, %Symbol%
		If TimeOut <>
		{
			TimeOut := TimeOut * 1000
			SetTimer, tim_BalloonTipTimeout, %TimeOut%
		}
	}
	If (OnlyOnce <> "" AND OnlyOnce <> 0 AND LoadingFinished = 1)
		%OnceVar% = 1
}

InfoScreen(heading,text,transperency=255,timeout=0,color="$1",fontcolor="000000",fontsize="", width=350, height="",refresh=1000,SplashOptions="")
{
	global

	InfoScreenHeading = %heading%
	InfoScreenText = %text%

	If IsLabel(InfoScreenHeading)
	{
		Gosub %InfoScreenHeading%
		heading = %#Return%
		SetTimer, tim_InfoScreenRefresh, %refresh%, 2
	}
	If IsLabel(InfoScreenText)
	{
		Gosub %InfoScreenText%
		text = %#Return%
		SetTimer, tim_InfoScreenRefresh, %refresh%, 2
	}
	if(transperency>-1) {
		if(color = "$1")
			color := "aaccff"
		if(color = "$2")
			color := "ccffaa"
		if(color = "$3")
			color := "ffccaa"

		If width <>
			width = W%width%
		If height <>
			height = H%height%
		If fontsize <>
			fontsize = FM%fontsize%

		if(transperency<256 AND transperency>0)
			SplashImage, 9: ,C01 Hide CW%color% CT%fontcolor% b1 FS9 ZY6 %width% %height% %fontsize% %SplashOptions%, %text%, %heading%, InfoScreenSplashImage
		Else
			SplashImage, 9: ,C01 Hide CW%color% CT%fontcolor% b FS9 ZY6 %width% %height% %fontsize% %SplashOptions%, %text%, %heading%, InfoScreenSplashImage

		DetectHiddenWindows, On
		WinWait, InfoScreenSplashImage

		WinGetPos,,,Width,Height,InfoScreenSplashImage

		Monitor := func_GetMonitorNumber()
		InfoX := Round(Monitor%Monitor%Left+(Monitor%Monitor%Width-width)/2)
		InfoY := Round(Monitor%Monitor%Top+(Monitor%Monitor%Height-height)/2)
		WinMove, InfoScreenSplashImage,,%InfoX%, %InfoY%
		If InfoX <>
			InfoX = x%InfoX%
		If InfoY <>
			InfoY = y%InfoY%

		If(transperency<255 AND transperency>0)
		{
			WinSet, Transparent, %transperency%, InfoScreenSplashImage
			WinSet, ExStyle, +0x20, InfoScreenSplashImage ; ClickThrough
		}
		Else if(transperency>255 OR transperency<1)
		{
			WinSet, TransColor, %color%, InfoScreenSplashImage
			WinSet, ExStyle, +0x20, InfoScreenSplashImage ; ClickThrough
		}

		SplashImage, 9:Show, ,,,InfoScreenSplashImage
		Sleep,0 ; is required for always displaying the text!!

		if (timeout > 0)
		{
			timeout := timeout * 1000
			SetTimer,tim_InfoScreenOff,%timeout%,2
		}
		else
			SetTimer,tim_InfoScreenOff,10000,2
	}
	else
		GoSub,tim_InfoScreenOff
}

tim_InfoScreenOff:
	SetTimer,tim_InfoScreenOff,Off
	SetTimer,tim_InfoScreenRefresh,Off
	SplashImage, 9:Off
Return

tim_InfoScreenRefresh:
	If IsLabel(InfoScreenHeading)
	{
		Gosub %InfoScreenHeading%
		heading = %#Return%
	}
	If IsLabel(InfoScreenText)
	{
		Gosub %InfoScreenText%
		text = %#Return%
	}
	SplashImage, 9: , , %text%, %heading%, InfoScreenSplashImage
Return
