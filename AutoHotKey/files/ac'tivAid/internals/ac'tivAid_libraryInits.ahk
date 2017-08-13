; -----------------------------------------------------------------------------
; Hier wird libCurl initalisiert.
; -----------------------------------------------------------------------------
if lc_load()
{
	SetTimer, lc_tim_downloadQueue, 1000
}

; -----------------------------------------------------------------------------
; Hier wird GDI+ initalisiert.
; http://www.autohotkey.com/forum/viewtopic.php?t=32238
; -----------------------------------------------------------------------------
#include *i %A_ScriptDir%\Library\gdip.ahk

IniRead, _useGdiPlus, %ConfigFile%, %ScriptName%, useGdiPlus, 0
IniRead, _OSDTips, %ConfigFile%, %ScriptName%, OSDTips, 1
IniRead, _OSDIcons, %ConfigFile%, %ScriptName%, OSDIcons, 1
if _useGDIPlus = 1
{
	gdiPlus_Token := Gdip_Startup()
	If gdiPlus_Token != 0
	{
		IniRead, gdip_monitor, %ConfigFile%, %ScriptName%, OSDMonitor, 1
		IniRead, osd_xString, %ConfigFile%, %ScriptName%, OSDXPosition, 3
		IniRead, osd_yString, %ConfigFile%, %ScriptName%, OSDYPosition, 3

		IniRead, gdip_bgColor, %ConfigFile%, %ScriptName%, OSDBackgroundColor, 959595
		IniRead, gdip_bgbColor, %ConfigFile%, %ScriptName%, OSDBackground2Color, 3f3f3f
		IniRead, gdip_borderColor, %ConfigFile%, %ScriptName%, OSDBorderColor, 000000
		IniRead, gdip_startTrans, %ConfigFile%, %ScriptName%, OSDTransparency, 255
		IniRead, gdip_rounding, %ConfigFile%, %ScriptName%, OSDRounding, 5

		IniRead, gdip_fontSize, %ConfigFile%, %ScriptName%, OSDFontSize, 12
		IniRead, gdip_fontSizeTitle, %ConfigFile%, %ScriptName%, OSDFontSizeTitle, 16
		IniRead, gdip_fontSizeHeader, %ConfigFile%, %ScriptName%, OSDFontSizeHeader, 18

		IniRead, gdip_fontFamily, %ConfigFile%, %ScriptName%, OSDFontFamily, % func_bestAvailableOSFont()
		IniRead, gdip_fontFamilyTitle, %ConfigFile%, %ScriptName%, OSDFontFamilyTitle, % func_bestAvailableOSFont()
		IniRead, gdip_fontFamilyHeader, %ConfigFile%, %ScriptName%, OSDFontFamilyHeader, % func_bestAvailableOSFont()

		IniRead, gdip_fontColor, %ConfigFile%, %ScriptName%, OSDFontColor, FFFFFF
		IniRead, gdip_fontColorTitle, %ConfigFile%, %ScriptName%, OSDFontColorTitle, FFFFFF
		IniRead, gdip_fontColorHeader, %ConfigFile%, %ScriptName%, OSDFontColorHeader, FFFFFF
		IniRead, gdip_fontColorHeaderBorder, %ConfigFile%, %ScriptName%, OSDFontColorHeaderBorder, 000000
		gdiP_enabled := 1
	}
	else
	{
		gdiP_enabled := 0
		MsgBox, 4, %lng_GdiPnotFoundTitle%, %lng_GdiPnotFound%
		IfMsgBox yes
			Run, %gdiP_downloadLocation%
	}
}
