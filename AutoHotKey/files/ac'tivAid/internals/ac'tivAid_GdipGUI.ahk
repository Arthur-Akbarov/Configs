_sub_gdip_configGui:
	Gui, +Disabled

	if gdip_guiId =
		gdip_guiId := CreateGuiID("GDIPConfig")

	GuiDefault("GDIPConfig", "+LastFound +Owner" GuiID_activAid)
	Gosub, GuiDefaultFont

	Gui, Add, Groupbox, x5 y5 w500 h60, %lng_gdip_generalSettings%
	Gui, Add, Checkbox, x10 yp+18 w300 Checked%_OSDTips% v_OSDTips, %lng_OSDTips%
	Gui, Add, Text, x+30 yp+0 w30 vgdip_text17, %lng_gdip_position%
	Gui, Add, DDL, x+8 yp-5 w80 vosd_xString AltSubmit R3, %lng_gdip_posHorList%

	Gui, Add, Checkbox, x10 y+2 w300 Checked%_OSDTips% v_OSDIcons, %lng_OSDIcons%
	Gui, Add, DDL, x+75 yp-1 w80 vosd_yString AltSubmit R3, %lng_gdip_posVerList%

	Gui, Add, Groupbox, x5 y+10 w500 h98, %lng_gdip_osd%
	Gui, Add, Text, x10 yp+18 w120 vgdip_text3, %lng_gdip_backgroundColor%
	Gui, Add, ListView, xs+135 yp-3 H20 W30 ReadOnly +0x4000 +0x2000 +Background%gdip_bgColor% vgdip_bgColor_Box lv0x800000 0x4 -TabStop gChooseColorButton AltSubmit
	Gui, Add, Edit, ReadOnly w50 h20 x+10 vgdip_bgColor gChooseColorEdit, %gdip_bgColor%

	Gui, Add, Text, x10 y+10 w120 vgdip_text4, %lng_gdip_backgroundColor2%
	Gui, Add, ListView, xs+135 yp-3 H20 W30 ReadOnly +0x4000 +0x2000 +Background%gdip_bgbColor% vgdip_bgbColor_Box lv0x800000 0x4 -TabStop gChooseColorButton AltSubmit
	Gui, Add, Edit, ReadOnly w50 h20 x+10 vgdip_bgbColor gChooseColorEdit, %gdip_bgbColor%

	Gui, Add, Text, x10 y+10 w120 vgdip_text5, %lng_gdip_borderColor%
	Gui, Add, ListView, xs+135 yp-3 H20 W30 ReadOnly +0x4000 +0x2000 +Background%gdip_borderColor% vgdip_borderColor_Box lv0x800000 0x4 -TabStop gChooseColorButton AltSubmit
	Gui, Add, Edit, ReadOnly w50 h20 x+10 vgdip_borderColor gChooseColorEdit, %gdip_borderColor%

	Gui, Add, Text, x245 y90 w100 vgdip_text1, %lng_gdip_rounding% (%gdip_rounding%)
	Gui, Add, Slider, AltSubmit yp-3 h20 ggdip_sub_checkIfSettingsChanged x+5 vgdip_roundingSlider w150 Range0-20, %gdip_rounding%

	Gui, Add, Text, x245 y+10 w100 vgdip_text2, %lng_gdip_trans% (%gdip_startTrans%)
	Gui, Add, Slider, AltSubmit yp-3 h20 ggdip_sub_checkIfSettingsChanged x+5 vgdip_transSlider w150 Range20-255, %gdip_startTrans%

	Gui, Add, Text, x245 y+10 w100 vgdip_text16, %lng_gdip_monitor%
	Gui, Add, DDL, yp-3 h20 x+5 w150 vgdip_monitor AltSubmit R3, %lng_gdip_monitorList%

	gdip_fontList := func_GetFontList()
	StringReplace, gdip_fontListHeader, gdip_fontList, %gdip_fontFamilyHeader%|, %gdip_fontFamilyHeader%||
	StringReplace, gdip_fontListTitle, gdip_fontList, %gdip_fontFamilyTitle%|, %gdip_fontFamilyTitle%||
	StringReplace, gdip_fontList, gdip_fontList, %gdip_fontFamily%|, %gdip_fontFamily%||

	Gui, Add, Groupbox, x5 y165 w500 h100, Fonts
	Gui, Add, Text, x10 yp+18 w120 vgdip_text6, %lng_gdip_fontFamily%
	Gui, Add, DDL, yp-2 x85 h20 R15 vgdip_fontFamily, %gdip_fontList%
	Gui, Add, Text, yp+2 x+10 w30 vgdip_text7, %lng_gdip_fontSize%
	Gui, Add, Edit, yp-2 x+10 w50 vgdip_fontSize, %gdip_fontSize%
	Gui, Add, Text, x+10 yp+2 w30 vgdip_text8, %lng_gdip_fontColor%
	Gui, Add, ListView, x+10 yp-2 H20 W30 ReadOnly +0x4000 +0x2000 +Background%gdip_fontColor% vgdip_fontColor_Box lv0x800000 0x4 -TabStop gChooseColorButton AltSubmit
	Gui, Add, Edit, Hidden ReadOnly w0 h0 x+10 y+0 vgdip_fontColor gChooseColorEdit, %gdip_fontColor%

	Gui, Add, Text, x10 y+10 w120 vgdip_text9, %lng_gdip_fontFamilyTitle%
	Gui, Add, DDL, yp-2 x85 h20 R15 vgdip_fontFamilyTitle, %gdip_fontListTitle%
	Gui, Add, Text, yp+2 x+10 w30 vgdip_text10, %lng_gdip_fontSize%
	Gui, Add, Edit, yp-2 x+10 w50 vgdip_fontSizeTitle, %gdip_fontSizeTitle%
	Gui, Add, Text, x+10 yp+2 w30 vgdip_text11, %lng_gdip_fontColor%
	Gui, Add, ListView, x+10 yp-2 H20 W30 ReadOnly +0x4000 +0x2000 +Background%gdip_fontColorTitle% vgdip_fontColorTitle_Box lv0x800000 0x4 -TabStop gChooseColorButton AltSubmit
	Gui, Add, Edit, Hidden ReadOnly w0 h0 x+10 y+0 vgdip_fontColorTitle gChooseColorEdit, %gdip_fontColorTitle%


	Gui, Add, Text, x10 y+10 w120 vgdip_text12, %lng_gdip_fontFamilyHeader%
	Gui, Add, DDL, yp-2 x85 h20 R15 vgdip_fontFamilyHeader, %gdip_fontListHeader%
	Gui, Add, Text, yp+2 x+10 w30 vgdip_text13, %lng_gdip_fontSize%
	Gui, Add, Edit, yp-2 x+10 w50 vgdip_fontSizeHeader, %gdip_fontSizeHeader%
	Gui, Add, Text, x+10 yp+2 w30 vgdip_text14, %lng_gdip_fontColor%
	Gui, Add, ListView, x+10 yp-2 H20 W30 ReadOnly +0x4000 +0x2000 +Background%gdip_fontColorHeader% vgdip_fontColorHeader_Box lv0x800000 0x4 -TabStop gChooseColorButton AltSubmit
	Gui, Add, Edit, Hidden ReadOnly w0 h0 x+10 vgdip_fontColorHeader gChooseColorEdit, %gdip_fontColorHeader%
	Gui, Add, Text, x+10 yp+2 w40 vgdip_text15, %lng_gdip_fontColor% 2
	Gui, Add, ListView, x+10 yp-2 H20 W30 ReadOnly +0x4000 +0x2000 +Background%gdip_fontColorHeaderBorder% vgdip_fontColorHeaderBorder_Box lv0x800000 0x4 -TabStop gChooseColorButton AltSubmit
	Gui, Add, Edit, Hidden ReadOnly w0 h0 x+10 y+0 vgdip_fontColorHeaderBorder gChooseColorEdit, %gdip_fontColorHeaderBorder%

	Gui, Add, Checkbox, x10 y+20 w260 Checked%_useGdiPlus% v_useGdiPlus ggdip_GuiDisableEnable, %lng_useGdiPlus%

	Gui, Add, Button, x+10 w60 h30 ggdip_saveSettings -Wrap, %lng_OK%
	Gui, Add, Button, x+10 yp+0 w60 h30 gGDIPConfigGuiEscape -Wrap, %lng_cancel%
	Gui, Add, Button, x+10 yp+0 w80 h30 ggdip_DefaultSettings -Wrap, %lng_default%

	GuiControl, Choose, gdip_monitor, %gdip_monitor%
	GuiControl, Choose, osd_xString, %osd_xString%
	GuiControl, Choose, osd_yString, %osd_yString%

	gosub, gdip_GuiDisableEnable
	Gui, Show, w510 h320, %lng_sub_gdip_configGui%
return

gdip_GuiDisableEnable:
	GuiControlGet, _useGdiPlus,,_useGdiPlus


	GuiControl, Enable%_useGdiPlus%,gdip_monitor
	GuiControl, Enable%_useGdiPlus%,osd_xString
	GuiControl, Enable%_useGdiPlus%,osd_yString

	GuiControl, Enable%_useGdiPlus%,gdip_roundingSlider
	GuiControl, Enable%_useGdiPlus%,gdip_transSlider
	GuiControl, Enable%_useGdiPlus%,_OSDIcons
	GuiControl, Enable%_useGdiPlus%,_OSDTips
	GuiControl, Enable%_useGdiPlus%,gdip_text1
	GuiControl, Enable%_useGdiPlus%,gdip_text2
	GuiControl, Enable%_useGdiPlus%,gdip_text3
	GuiControl, Enable%_useGdiPlus%,gdip_text4
	GuiControl, Enable%_useGdiPlus%,gdip_text5
	GuiControl, Enable%_useGdiPlus%,gdip_text6
	GuiControl, Enable%_useGdiPlus%,gdip_text7
	GuiControl, Enable%_useGdiPlus%,gdip_text8
	GuiControl, Enable%_useGdiPlus%,gdip_text9
	GuiControl, Enable%_useGdiPlus%,gdip_text10
	GuiControl, Enable%_useGdiPlus%,gdip_text11
	GuiControl, Enable%_useGdiPlus%,gdip_text12
	GuiControl, Enable%_useGdiPlus%,gdip_text13
	GuiControl, Enable%_useGdiPlus%,gdip_text14
	GuiControl, Enable%_useGdiPlus%,gdip_text15
	GuiControl, Enable%_useGdiPlus%,gdip_text16
	GuiControl, Enable%_useGdiPlus%,gdip_text17

	GuiControl, Enable%_useGdiPlus%,gdip_fontSize
	GuiControl, Enable%_useGdiPlus%,gdip_fontSizeTitle
	GuiControl, Enable%_useGdiPlus%,gdip_fontSizeHeader

	GuiControl, Enable%_useGdiPlus%,gdip_fontFamily
	GuiControl, Enable%_useGdiPlus%,gdip_fontFamilyTitle
	GuiControl, Enable%_useGdiPlus%,gdip_fontFamilyHeader

	GuiControl, Enable%_useGdiPlus%,gdip_fontColor
	GuiControl, Enable%_useGdiPlus%,gdip_fontColorTitle
	GuiControl, Enable%_useGdiPlus%,gdip_fontColorHeader
	GuiControl, Enable%_useGdiPlus%,gdip_fontColorHeaderBorder
	GuiControl, Enable%_useGdiPlus%,gdip_bgColor
	GuiControl, Enable%_useGdiPlus%,gdip_bgbColor
	GuiControl, Enable%_useGdiPlus%,gdip_borderColor
	GuiControl, Enable%_useGdiPlus%,gdip_fontColor_Box
	GuiControl, Enable%_useGdiPlus%,gdip_fontColorTitle_Box
	GuiControl, Enable%_useGdiPlus%,gdip_fontColorHeader_Box
	GuiControl, Enable%_useGdiPlus%,gdip_fontColorHeaderBorder_Box
	GuiControl, Enable%_useGdiPlus%,gdip_bgColor_Box
	GuiControl, Enable%_useGdiPlus%,gdip_bgbColor_Box
	GuiControl, Enable%_useGdiPlus%,gdip_borderColor_Box
return

gdip_saveSettings:
	Gui, %GuiID_GDIPConfig%:Submit
	gdip_startTrans := gdip_transSlider
	gdip_rounding := gdip_roundingSlider

	IniWrite, %gdip_monitor%, %ConfigFile%, %ScriptName%, OSDMonitor

	IniWrite, %_OSDTips%, %ConfigFile%, %ScriptName%, OSDTips
	IniWrite, %_OSDIcons%, %ConfigFile%, %ScriptName%, OSDIcons
	IniWrite, %_useGdiPlus%, %ConfigFile%, %ScriptName%, useGdiPlus

	IniWrite, %gdip_bgColor%, %ConfigFile%, %ScriptName%, OSDBackgroundColor
	IniWrite, %gdip_bgbColor%, %ConfigFile%, %ScriptName%, OSDBackground2Color
	IniWrite, %gdip_borderColor%, %ConfigFile%, %ScriptName%, OSDBorderColor
	IniWrite, %gdip_transSlider%, %ConfigFile%, %ScriptName%, OSDTransparency
	IniWrite, %gdip_roundingSlider%, %ConfigFile%, %ScriptName%, OSDRounding

	IniWrite, %gdip_fontSize%, %ConfigFile%, %ScriptName%, OSDFontSize
	IniWrite, %gdip_fontSizeTitle%, %ConfigFile%, %ScriptName%, OSDFontSizeTitle
	IniWrite, %gdip_fontSizeHeader%, %ConfigFile%, %ScriptName%, OSDFontSizeHeader

	IniWrite, %gdip_fontFamily%, %ConfigFile%, %ScriptName%, OSDFontFamily
	IniWrite, %gdip_fontFamilyTitle%, %ConfigFile%, %ScriptName%, OSDFontFamilyTitle
	IniWrite, %gdip_fontFamilyHeader%, %ConfigFile%, %ScriptName%, OSDFontFamilyHeader

	IniWrite, %gdip_fontColor%, %ConfigFile%, %ScriptName%, OSDFontColor
	IniWrite, %gdip_fontColorTitle%, %ConfigFile%, %ScriptName%, OSDFontColorTitle
	IniWrite, %gdip_fontColorHeader%, %ConfigFile%, %ScriptName%, OSDFontColorHeader
	IniWrite, %gdip_fontColorHeaderBorder%, %ConfigFile%, %ScriptName%, OSDFontColorHeaderBorder

	IniWrite, %osd_xString%, %ConfigFile%, %ScriptName%, OSDXPosition
	IniWrite, %osd_yString%, %ConfigFile%, %ScriptName%, OSDYPosition


	Gui, %GuiID_activAid%:-Disabled

	Gui, %GuiID_GDIPConfig%:Destroy
return

GDIPConfigGuiClose:
GDIPConfigGuiEscape:
	Gui, %GuiID_activAid%:-Disabled
	Gui, %GuiID_GDIPConfig%:Destroy
return

gdip_sub_checkIfSettingsChanged:
	GuiControlGet, gdip_transSlider_tmp,,gdip_transSlider
	GuiControlGet, gdip_roundingSlider_tmp,,gdip_roundingSlider

	GuiControl,,gdip_text1, %lng_gdip_rounding% (%gdip_roundingSlider_tmp%)
	GuiControl,,gdip_text2, %lng_gdip_trans% (%gdip_transSlider_tmp%)
return

gdip_DefaultSettings:
	gdip_bgColor = 959595
	gdip_bgbColor = 3f3f3f
	gdip_borderColor = 000000
	gdip_startTrans = 255
	gdip_rounding = 5

	gdip_fontSize = 12
	gdip_fontSizeTitle = 16
	gdip_fontSizeHeader = 18

	gdip_fontFamily := func_bestAvailableOSFont()
	gdip_fontFamilyTitle := func_bestAvailableOSFont()
	gdip_fontFamilyHeader := func_bestAvailableOSFont()

	gdip_fontColor = FFFFFF
	gdip_fontColorTitle = FFFFFF
	gdip_fontColorHeader = FFFFFF
	gdip_fontColorHeaderBorder = 000000


	gdip_fontList := func_GetFontList()
	StringReplace, gdip_fontListHeader, gdip_fontList, %gdip_fontFamilyHeader%|, %gdip_fontFamilyHeader%||
	StringReplace, gdip_fontListTitle, gdip_fontList, %gdip_fontFamilyTitle%|, %gdip_fontFamilyTitle%||
	StringReplace, gdip_fontList, gdip_fontList, %gdip_fontFamily%|, %gdip_fontFamily%||

	GuiControl,,gdip_roundingSlider,%gdip_rounding%
	GuiControl,,gdip_transSlider,%gdip_startTrans%
	GuiControl,,gdip_text1, %lng_gdip_rounding% (%gdip_rounding%)
	GuiControl,,gdip_text2, %lng_gdip_trans% (%gdip_startTrans%)

	GuiControl,,gdip_fontSize,%gdip_fontSize%
	GuiControl,,gdip_fontSizeTitle,%gdip_fontSizeTitle%
	GuiControl,,gdip_fontSizeHeader,%gdip_fontSizeHeader%

	GuiControl,,gdip_fontFamily,%gdip_fontList%
	GuiControl,,gdip_fontFamilyTitle,%gdip_fontListTitle%
	GuiControl,,gdip_fontFamilyHeader,%gdip_fontListHeader%

	GuiControl,,gdip_fontColor,%gdip_fontColor%
	GuiControl,,gdip_fontColorTitle,%gdip_fontColorTitle%
	GuiControl,,gdip_fontColorHeader,%gdip_fontColorHeader%
	GuiControl,,gdip_fontColorHeaderBorder,%gdip_fontColorHeaderBorder%
	GuiControl,,gdip_bgColor,%gdip_bgColor%
	GuiControl,,gdip_bgbColor,%gdip_bgbColor%
	GuiControl,,gdip_borderColor,%gdip_borderColor%
	GuiControl,+Background%gdip_fontColor%,gdip_fontColor_Box,%gdip_fontColor%
	GuiControl,+Background%gdip_fontColorTitle%,gdip_fontColorTitle_Box,%gdip_fontColorTitle%
	GuiControl,+Background%gdip_fontColorHeader%,gdip_fontColorHeader_Box,%gdip_fontColorHeader%
	GuiControl,+Background%gdip_fontColorHeaderBorder%,gdip_fontColorHeaderBorder_Box,%gdip_fontColorHeaderBorder%
	GuiControl,+Background%gdip_bgColor%,gdip_bgColor_Box,%gdip_bgColor%
	GuiControl,+Background%gdip_bgbColor%,gdip_bgbColor_Box,%gdip_bgbColor%
	GuiControl,+Background%gdip_borderColor%,gdip_borderColor_Box,%gdip_borderColor%
Return
