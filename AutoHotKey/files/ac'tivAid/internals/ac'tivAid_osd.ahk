osd_BalloonTip( Title, Text, Symbol="", OnlyOnce=0, AlwaysMessageBox=0, TimeOut="5" )
{
	Global
	local slot, id, padding, width, height, x, y, textSizeTmp, textSize, text_width, text_height, testPath, ext, file, icon1, icon2, icon0, hIcon, symbolTest, title_test, osd_monNum

	slot := osd_findSlot()
	id := osd_slot%slot%ID

	osd_idIsSlot%id% := slot

	padding := 15
	width := 300 + padding*2
	height := 40 + padding*2
	textPosX := padding

	if _OSDIcons = 1
	{
		width += 60
		textPosX += 45

		If Symbol = Error
			Symbol = dialog-error.png
		else
		{
			StringRight, title_test, title, 1
			if title_test is integer
				StringTrimRight, title, title, 1

			IfExist %A_ScriptDir%\icons\png\%title%.png
				Symbol := Title ".png"
			else
			{
				If (Symbol = "Info" || Symbol = "")
					Symbol = dialog-information.png
				else If Symbol = Warning
					Symbol = dialog-warning.png
				else If Symbol !=
				{
					StringSplit, icon, symbol, |

					if icon2 !=
					{
						SplitPath, icon1,file,,ext

						ifExist %file%
						{
							if ext in dll,cpl,exe
							{
								;no alpha!?!
								hIcon := ExtractIcon(file,icon2,32)
							}
						}
						else
							Symbol = dialog-information.png
					}
					else
					{
						StringRight, symbolText, symbol, 1

						if symbolTest = |
							StringTrimRight, symbol, symbol, 1

						symbol = .%symbol%
						IfNotExist, %symbol%
							Symbol = dialog-information.png
					}
				}
			}
		}
	}


	osd_prepare(id,width,height,0,0,TimeOut,255,959595,5)

	;Text schreiben
	textSizeTmp := osd_text(id,Text,"R0 Cff" gdip_fontColor " S" gdip_fontSize " Left",textPosX,30,gdip_fontFamily,width-70)

	;Falls Text zu hoch für die Standardgröße ist, osd mit passender Höhe erneut generieren
	StringSplit, textSize, textSizeTmp, |
	text_width := textSize3
	text_height := textSize4
	if (text_height > height - padding*2)
		height := height + text_height - padding*2

	;Positionsbestimmung
	if gdip_monitor = 1
		osd_monNum := 1
	else if gdip_monString = 2
		osd_monNum := func_GetMonitorNumber("Mouse")
	else if gdip_monString = 3
		osd_monNum := func_GetMonitorNumber("ActiveWindow")

	if osd_xString = 1
		x := WorkArea%osd_monNum%Left+5
	else if osd_xString = 2
		x := WorkArea%osd_monNum%Left + (WorkArea%osd_monNum%Right-WorkArea%osd_monNum%Left-width)//2
	else
		x := WorkArea%osd_monNum%Right-5-width

	if osd_yString = 1
		y := osd_bt_position(slot,height,WorkArea%osd_monNum%Top,"down")
	else if osd_yString = 2
		y := osd_bt_position(slot,height,WorkArea%osd_monNum%Top+((WorkArea%osd_monNum%Top+WorkArea%osd_monNum%Bottom)//2),"down")
	else
		y := osd_bt_position(slot,height,WorkArea%osd_monNum%Bottom,"up")


	;Mit richtiger Größe neu zeichnen
	osd_prepare(id,width,height,x,y,TimeOut,gdip_startTrans,gdip_bgColor,gdip_rounding)

	;Titel schreiben
	osd_text(id,Title,"R0 Cff" gdip_fontColor "S" gdip_fontSizeTitle " Bold",textPosX,8,gdip_fontFamily,width-70)

	if _OSDIcons = 1
	{
		;Icon einfügen
		if hIcon =
			osd_pictureNoResize(id,A_ScriptDir "\icons\png\" Symbol,6,10)
		else
		{
			hIconBitmap := Gdip_CreateBitmapFromHICON(hIcon)

			Gdip_DrawImage(osd_G%id%, hIconBitmap, 12, 12, 32, 32, 0, 0, 32, 32)
			Gdip_DisposeImage(hIconBitmap)
			DestroyIcon(hIcon)
		}
	}

	;Text schreiben
	osd_text(id,Text,"R0 Cff" gdip_fontColor " S" gdip_fontSize " Left",textPosX,30,gdip_fontFamily,width-70)


	;OSD anzeigen und faden
	osd_show(id)
	osd_fade(id)
}

osd_bt_position(slot,height,start,order="up")
{
	Global
	local y, pSlot

	pSlot := slot -1


	if order = up
	{
		osd_slot0Height := start
		osd_slot%slot%Height := osd_slot%pSlot%Height - 5 - height
	}
	else
	{
		osd_slot0Height := start - height
		osd_slot%slot%Height := osd_slot%pSlot%Height + 5 + height
	}
	return % osd_slot%slot%Height
}

osd_findSlot()
{
	Global
	local slot

	osd_maxSlots := 20

	Loop, %osd_maxSlots%
	{
		if osd_slot%A_Index%filled != 1
		{
			slot := osd_useSlot(A_Index)
			return slot
		}
	}
}

osd_useSlot(Slot)
{
	Global

	osd_slot%Slot%filled := 1

	if osd_slot%slot%ID =
		osd_slot%slot%ID := osd_create()

	return %Slot%
}

osd_freeSlot(Slot)
{
	Global

	osd_slot%Slot%filled := 0
	osd_slot%slot%Height := 0
	tmp_slot := slot

	Loop, % osd_maxSlots-Slot
	{
		tmp_slot++
		osd_slot%tmp_slot%Height := 0
	}

	return %Slot%
}

osd_create()
{
	Global

	osd_nums++
	CreateGuiID("OSDOverlay" osd_nums)

	Return % "OSDOverlay" osd_nums
}

osd_prepare(guiID,w,h,x="-1",y="-1",osd_timeOut=2,transparency="165",color="959595",rounding=20,noDestroy=0,border=1)
{
	Global

	if gdip_monitor = 1
		osd_monNum := 1
	else if gdip_monString = 2
		osd_monNum := func_GetMonitorNumber("Mouse")
	else if gdip_monString = 3
		osd_monNum := func_GetMonitorNumber("ActiveWindow")

	if x=-1
		x := WorkArea%osd_monNum%Left + (WorkArea%osd_monNum%Right-WorkArea%osd_monNum%Left-w)//2

	if y=-1
		y  := WorkArea%osd_monNum%Top+((WorkArea%osd_monNum%Top+WorkArea%osd_monNum%Bottom+h)//2)

	osd_x%guiID% := x
	osd_y%guiID% := y

	osd_Width%guiID% := w+1
	osd_Height%guiID% := h+1
	osd_fadeDelay%guiID% := osd_timeOut * 1000

	if noDestroy=0
		osd_destroy(guiID)

	osd_hwnd%guiID% := GuiDefault(guiID,"-Caption +E0x80020 +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs")
	Gui, Show, NA

	osd_hbm%guiID% := CreateDIBSection(osd_Width%guiID%, osd_Height%guiID%)
	osd_hdc%guiID% := CreateCompatibleDC()                          ; Get a device context compatible with the screen
	osd_obm%guiID% := SelectObject(osd_hdc%guiID%, osd_hbm%guiID%)                ; Select the bitmap into the device context
	osd_G%guiID% := Gdip_GraphicsFromHDC(osd_hdc%guiID%)                   ; Get a pointer to the graphics of the bitmap, for use with drawing functions
	Gdip_SetSmoothingMode(osd_G%guiID%, 4)                          ; Set the smoothing mode to antialias = 4 to make shapes appear smoother (only used for vector drawing and filling)
	Gdip_SetInterpolationMode(osd_G%guiID%, 7)

	osd_FadeSpeed%guiID% = 5
	osd_transparent%guiID% := transparency
	;osd_Pen := Gdip_CreatePen(osd_kante, 4)

	osd_Brush%guiID% := Gdip_BrushCreateSolid("0xFF" color)
	Gdip_FillRoundedRectangle(osd_G%guiID%, osd_Brush%guiID%, 0, 0, w, h, rounding)
	Gdip_DeleteBrush(osd_Brush%guiID%)

	if border=1
	{
		osd_pen%guiID% := Gdip_CreatePen("0xFF" gdip_borderColor,1)
		Gdip_DrawRoundedRectangle(osd_G%guiID%, osd_Pen%guiID%, 0, 0, w, h, rounding)
		Gdip_DeleteBrush(osd_pen%guiID%)
	}
}

osd_picture(guiId,file,x,y,w,h,padding=1)
{
	Global
	Local osd_newSize

	Critical
	osd_pBitmap%guiID% := Gdip_CreateBitmapFromFile(file)
	osd_BitmapWidth%guiID% := Gdip_GetImageWidth(osd_pBitmap%guiID%)
	osd_BitmapHeight%guiID% := Gdip_GetImageHeight(osd_pBitmap%guiID%)

	osd_newSize := aspectRatio(osd_BitmapWidth%guiID%, osd_BitmapHeight%guiID%, w, h)
	StringSplit, osd_newSize_tmp, osd_newSize, x

	if padding = 1
	{
		x += round(abs(w - osd_newSize_tmp1)/2,0)
		y += round(abs(h - osd_newSize_tmp2)/2,0)
	}

	Gdip_DrawImage(osd_G%guiID%, osd_pBitmap%guiID%, x, y, osd_newSize_tmp1, osd_newSize_tmp2, 0, 0, osd_BitmapWidth%guiID%, osd_BitmapHeight%guiID%)
	Gdip_DisposeImage(osd_pBitmap%guiID%)
	Critical Off
}

aspectRatio(inWidth,inHeight,outMaxWidth,outMaxHeight)
{
	objectar := inWidth/inHeight

	; -- calculate image dimensions to ensure preservation of aspect ratio --
	imageh := outMaxHeight
	imagew := imageh*objectar

	if ( imagew > outMaxWidth )
	{
		imagew := outMaxWidth
		imageh := imagew/objectar
	}

	return % Round(imagew,0) "x" Round(imageh,0)
}


osd_pictureNoResize(guiID,file,x,y)
{
	Global

	Critical
	osd_pBitmap%guiID% := Gdip_CreateBitmapFromFile(file)
	osd_BitmapWidth%guiID% := Gdip_GetImageWidth(osd_pBitmap%guiID%)
	osd_BitmapHeight%guiID% := Gdip_GetImageHeight(osd_pBitmap%guiID%)

	Gdip_DrawImage(osd_G%guiID%, osd_pBitmap%guiID%, x, y, osd_BitmapWidth%guiID%, osd_BitmapHeight%guiID%, 0, 0, osd_BitmapWidth%guiID%, osd_BitmapHeight%guiID%)
	Gdip_DisposeImage(osd_pBitmap%guiID%)
	Critical Off
}

osd_pixelBar(guiID,width,height,percent,x,y)
{
	Global

	osd_Brush%guiID% := Gdip_BrushCreateSolid("0xFF" gdip_bgbColor)
	osd_BrushFilled%guiID% := Gdip_BrushCreateSolid("0xFF" gdip_fontColor)

	Gdip_FillRectangle(osd_G%guiID%, osd_Brush%guiID%, x, y, width, height)
	Gdip_FillRectangle(osd_G%guiID%, osd_BrushFilled%guiID%, x, y, width*percent/100, height)

	Gdip_DeleteBrush(osd_Brush%guiID%)
	Gdip_DeleteBrush(osd_BrushFilled%guiID%)
	Gdip_DisposeImage(osd_pBitmap%guiID%)
}

osd_bars(guiID,num,filled,x,y,emptyColor="3f3f3f",filledImage="-1")
{
	Global

	if filledImage = -1
		filledImage = %A_ScriptDir%\extensions\Media\ac'tivAid_VolumeControl_vol_bar.png

	osd_Brush%guiID% := Gdip_BrushCreateSolid("0xFF" emptyColor)
	osd_pBitmap%guiID% := Gdip_CreateBitmapFromFile(filledImage)
	osd_BitmapWidth%guiID% := Gdip_GetImageWidth(osd_pBitmap%guiID%)
	osd_BitmapHeight%guiID% := Gdip_GetImageHeight(osd_pBitmap%guiID%)

	Loop, %num%
	{
		osd_thisX := x+(A_Index*9)

		Gdip_FillRectangle(osd_G%guiID%, osd_Brush%guiID%, osd_thisX, y, 7, 10)

		if A_Index <= %filled%
			Gdip_DrawImage(osd_G%guiID%, osd_pBitmap%guiID%, osd_thisX, y, osd_BitmapWidth%guiID%, osd_BitmapHeight%guiID%, 0, 0, osd_BitmapWidth%guiID%, osd_BitmapHeight%guiID%)

	}

	Gdip_DeleteBrush(osd_Brush%guiID%)
	Gdip_DisposeImage(osd_pBitmap%guiID%)
}

osd_text(guiID,text,options,x,y,font="Verdana",w="",h="")
{
	Global

	osd_options%guiID% = x%x% y%y% %options%
	return Gdip_TextToGraphics(osd_G%guiID%, text, osd_options%guiID%, font, w, h)
}

osd_borderText(guiID,text,optionsFront,options,x,y,font="Verdana",w="",h="")
{
	Global

	osd_text(guiID,text,options,x-1,y-1,font,w,h)
	osd_text(guiID,text,options,x+1,y+1,font,w,h)
	osd_text(guiID,text,options,x,y+1,font,w,h)
	osd_text(guiID,text,options,x+1,y,font,w,h)
	osd_text(guiID,text,options,x-1,y,font,w,h)
	osd_text(guiID,text,options,x,y-1,font,w,h)
	osd_text(guiID,text,options,x+1,x-1,font,w,h)
	osd_text(guiID,text,options,x-1,y+1,font,w,h)

	osd_text(guiID,text,optionsFront,x,y,font,w,h)
}

osd_show(guiID)
{
	Global

	osd_hwnd := GuiDefault(guiID,"-Caption +E0x80020 +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs")
	UpdateLayeredWindow(osd_hwnd%guiID%, osd_hdc%guiID%, osd_x%guiID%, osd_y%guiID%, osd_Width%guiID%, osd_Height%guiID%, osd_transparent%guiId%)
}

osd_fade(guiID)
{
	Global

	Settimer, osd_tim_FadeOSD, 5
	osd_StartTicks%guiID% = %A_TickCount%
	osd_fading = %osd_fading%%guiID%|

	return
}

osd_tim_FadeOSD:
	Loop, parse, osd_fading, |
	{
		If A_LoopField !=
		{
			osd_cnt := A_Index

			osd_elapsedTicks%A_LoopField% := (A_TickCount-osd_StartTicks%A_LoopField%) - osd_fadeDelay%A_LoopField%

			if osd_elapsedTicks%A_LoopField% < 0
				osd_elapsedTicks%A_LoopField% = 0

			osd_transparent%A_LoopField% := osd_transparent%A_LoopField% - osd_FadeSpeed%A_LoopField% * (osd_elapsedTicks%A_LoopField% / 500)   ; Transparenz runterzählen

			if osd_transparent%A_LoopField% < 1
			{
				if osd_idIsSlot%A_LoopField% > 0
				{
					osd_freeSlot(osd_idIsSlot%A_LoopField%)
				}

				osd_destroy(A_LoopField)
				StringReplace, osd_fading, osd_fading, %A_LoopField%|,,All
				continue
			}

			y := osd_bt_position(slot,height,WorkAreaBottom)
			UpdateLayeredWindow(osd_hwnd%A_LoopField%, osd_hdc%A_LoopField%, osd_x%guiID%, osd_y%guiID%, osd_Width%A_LoopField%, osd_Height%A_LoopField%, osd_transparent%A_LoopField%)
		}
	}

	if osd_cnt = 0
		SetTimer, osd_tim_FadeOSD, Off
Return

osd_rotate(guiID,angle)
 {
	 Global
	 return gdip_RotateWorldTransform(osd_G%guiID%, angle)
 }

osd_destroy(guiID)
{
	Global

	SelectObject(osd_hdc%guiID%, osd_obm%guiID%)
	DeleteObject(osd_hbm%guiID%)
	DeleteDC(osd_hdc%guiID%)
	Gdip_DeleteGraphics(osd_G%guiID%)

	GuiDefault(guiID)
	Gui, Destroy
}
