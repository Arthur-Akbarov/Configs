
#F2::
	hosd_prevMod = null
	SetTimer, hosd_showKeyboard, 100
return

hosd_showKeyboard:
	hosd_mod =

	If (GetKeyState("LWin") || GetKeyState("RWin"))
		hosd_mod = %hosd_mod%#

	If  GetKeyState("Ctrl")
		hosd_mod = %hosd_mod%^

	If  GetKeyState("Alt")
		hosd_mod = %hosd_mod%!

	If  GetKeyState("Shift")
		hosd_mod = %hosd_mod%+

	CoordMode, Mouse, Screen
	MouseGetPos, hosd_xPos, hosd_yPos

	hosd_xPos += -(hosd_x + 5)
	hosd_yPos += -(hosd_y + 5 + 15)


	;get MousePosition Row
	if (hosd_yPos > 0 && hosd_yPos < 40)
		hosd_MouseRow := 1
	else
	{
		if (hosd_yPos > 55)
		{
			hosd_yPos += -55
			hosd_MouseRow := floor(hosd_yPos / 40)+2
		}
	}
	;get MousePosition Block
	prevBlock := 0
	Loop, parse, Block_Width, |
	{
		If (hosd_xPos < A_LoopField && hosd_xPos > prevBlock)
		{
			hosd_MouseBlock := A_Index
			hosd_button := hosd_getButton("Block" A_Index "Row" hosd_MouseRow,prevBlock)
			break
		}
		prevBlock := A_LoopField
	}

	hosd_testFor := func_HotkeyToVar(hosd_mod hosd_button)
	if Hotkey_[%hosd_testFor%] !=
		hosd_ext := Hotkey_[%hosd_testFor%]

	if HotkeySub_[%hosd_testFor%] !=
	{
		hosd_sub := HotkeySub_[%hosd_testFor%]
		hosd_sub := lng_%hosd_sub%
	}


	CoordMode, Tooltip, Screen
	ToolTip % "Button: " hosd_mod hosd_button "`nExtension: " hosd_sub, hosd_x+15, hosd_y+hosd_h-5
	;Hotkey_ExtensionText[]

	if (hosd_prevMod = hosd_mod)
		return

	hosd_createKeyboard(hosd_mod)

	hosd_prevMod := hosd_mod
return

hosd_getButton(currentSection,x)
{
	Global hosd_source, hosd_xPos, standardHeight, standardWidth, innerPaddingX
	x += 10
	IniRead, Order, %hosd_source%, %currentSection%, Order, %A_Space%

	Loop, parse, Order, |
	{
		IniRead, Width[%A_LoopField%], %hosd_source%, Width, %A_LoopField%, 1.0
		IniRead, PadLeft[%A_LoopField%], %hosd_source%, PadLeft, %A_LoopField%, 0

		w := standardWidth*Width[%A_LoopField%] + (round(Width[%A_LoopField%],0)-1*innerPaddingX)
		x += PadLeft[%A_LoopField%]

		if A_LoopField != Empty
		{
			if (hosd_xPos > x && hosd_xPos < x+w)
			{
				return %A_LoopField%
			}
		}

		x += w + innerPaddingX
	}
}

hosd_createKeyboard(mod="#")
{
	Global

	SetTimer, hosd_tim_FadeOSD, Off
	hosd_w := 1060
	hosd_h := 280

	hosd_x := (A_ScreenWidth - hosd_w)//2
	hosd_y := A_ScreenHeight - hosd_h - 100

	if hosd_guiID =
		hosd_guiID := CreateGuiID("HOSDOverlay")
	else
	{
		Gdip_DeleteGraphics(hosd_G)
		SelectObject(hosd_hdc, hosd_obm)
		DeleteObject(hosd_hbm)
	}

	hosd_hwnd := GuiDefault("HOSDOverlay","-Caption +E0x80020 +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs")
	Gui, Show, NA

	hosd_fadeDelay := 8 * 1000

	hosd_hbm := CreateDIBSection(hosd_w, hosd_h)
	hosd_hdc := CreateCompatibleDC()
	hosd_obm := SelectObject(hosd_hdc, hosd_hbm)
	hosd_G := Gdip_GraphicsFromHDC(hosd_hdc)
	Gdip_SetSmoothingMode(hosd_G, 4)
	Gdip_SetInterpolationMode(hosd_G, 7)

	hosd_FadeSpeed = 5
	hosd_transparent := 255

	hosd_Brush := Gdip_BrushCreateSolid("0xee111111")
	Gdip_FillRoundedRectangle(hosd_G, hosd_Brush, 5, 5, hosd_w-10, hosd_h-10, 20)
	Gdip_DeleteBrush(hosd_Brush)

	hosd_createKeys(hosd_G,SettingsDir "\GerLayout.ini",mod)

	UpdateLayeredWindow(hosd_hwnd, hosd_hdc, hosd_x, hosd_y, hosd_w, hosd_h, hosd_transparent)

	hosd_fade()
}

hosd_placeIcon(ByRef G,file,x,y,w=16,h=16)
{
	pBitmap := Gdip_CreateBitmapFromFile(file)
	BitmapWidth := Gdip_GetImageWidth(pBitmap)
	BitmapHeight := Gdip_GetImageHeight(pBitmap)

	osd_newSize := aspectRatio(BitmapWidth, BitmapHeight, w, h)
	StringSplit, osd_newSize_tmp, osd_newSize, x

	Gdip_DrawImage(G, pBitmap, x, y, osd_newSize_tmp1, osd_newSize_tmp2, 0, 0, BitmapWidth, BitmapHeight)
	Gdip_DisposeImage(pBitmap)
}


hosd_createKeys(ByRef G,source,mod,srcX=15,srcY=15)
{
	Global Block_Width, hosd_source, standardWidth, standardHeight, innerPaddingX

	IniRead, Rows, %source%, General, Rows, 0
	IniRead, Blocks, %source%, General, Blocks, 0

	standardWidth := 45
	standardHeight := 40
	symbolSize := 24
	innerPaddingX := 2
	innerPaddingY := 5
	Block_Width =
	hosd_source := source
	Loop, %Blocks%
	{
		y := srcY
		currentBlock = Block%A_Index%

		Loop, %Rows%
		{
			x := srcX
			currentRow = Row%A_Index%
			currentSection = %currentBlock%%currentRow%
			IniRead, Order%A_Index%, %source%, %currentSection%, Order, %A_Space%

			Loop, parse, Order%A_Index%, |
			{
				IniRead, Width[%A_LoopField%], %source%, Width, %A_LoopField%, 1.0
				IniRead, PadLeft[%A_LoopField%], %source%, PadLeft, %A_LoopField%, 0
				IniRead, Height[%A_LoopField%], %source%, Height, %A_LoopField%, 1.0
				w := standardWidth*Width[%A_LoopField%] + (round(Width[%A_LoopField%],0)-1*innerPaddingX)
				h := standardHeight*Height[%A_LoopField%] + (round(Height[%A_LoopField%],0)-1*innerPaddingY)

				x += PadLeft[%A_LoopField%]


				if A_LoopField != Empty
				{
					color := "0xFF666666"
					if ((A_LoopField = "LWin" || A_LoopField = "RWin") && InStr(mod,"#")>0)
						color := "0xFF999999"
					if ((A_LoopField = "LCtrl" || A_LoopField = "RCtrl") && InStr(mod,"^")>0)
						color := "0xFF999999"
					if ((A_LoopField = "LAlt" || A_LoopField = "RAlt") && InStr(mod,"!")>0)
						color := "0xFF999999"
					if ((A_LoopField = "LShift" || A_LoopField = "RShift") && InStr(mod,"+")>0)
						color := "0xFF999999"
					if (A_LoopField = "AltGr" && InStr(mod,"!")>0 && InStr(mod,"^")>0)
						color := "0xFF999999"

					hosd_Brush := Gdip_BrushCreateSolid(color)
					Gdip_FillRoundedRectangle(G, hosd_Brush, x, y, w, h, 5)
					Gdip_DeleteBrush(hosd_Brush)

					testFor := func_HotkeyToVar(mod A_LoopField)
					if Hotkey_[%testFor%] !=
					{
						symbol := A_ScriptDir "\icons\png\" Hotkey_[%testFor%] ".png"
						hosd_placeIcon(G,Symbol,x+w-symbolSize-2,y+h-symbolSize-2,symbolSize,symbolSize)
					}

					text := hosd_text(A_LoopField,mod)

					Gdip_TextToGraphics(G, text, "R0 CffFFFFFF S12 Left x" x+2 " y" y+2 , "Verdana", w, h)
				}
				x += w + innerPaddingX

				if x > %previousLargest%
					previousLargest := x
			}

			y += standardHeight

			If A_Index = 1
				y += 15
		}

		srcX := previousLargest +10
		Block_Width := Block_Width previousLargest "|"
	}
}

hosd_text(text,mod)
{
	;if lng_Kb%text% !=
	;   text := lng_Kb%text%

	StringReplace, text, text, Numpad,,All

	if (InStr(mod,"+")>0 && Strlen(text)=1)
		StringUpper, text, text

	if text = Compare
		text = <

	if text = AppsKey
		text = Apps

	if text = Comma
		text = ,

	if text = Div
		text = \

	if text = Dot
		text = .

	if (text = "Minus" || text = "Sub")
		text = -

	if text = Mul
		text = +

	StringReplace, text, text, %A_Space%,`n, All

	return text
}

hosd_fade()
{
	Global

	Settimer, hosd_tim_FadeOSD, 5
	hosd_StartTicks = %A_TickCount%

	return
}

hosd_tim_FadeOSD:
	hosd_elapsedTicks := (A_TickCount-hosd_StartTicks) - hosd_fadeDelay

	if hosd_elapsedTicks < 0
		hosd_elapsedTicks = 0

	hosd_transparent := hosd_transparent - hosd_FadeSpeed * (hosd_elapsedTicks / 500)   ; Transparenz runterzählen

	if hosd_transparent < 1
	{
		ToolTip
		SetTimer, hosd_tim_FadeOSD, Off
		SetTimer, hosd_showKeyboard, Off
		hosd_destroy()
		return
	}

	hosd_hwnd := GuiDefault("HOSDOverlay","-Caption +E0x80020 +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs")
	UpdateLayeredWindow(hosd_hwnd, hosd_hdc, hosd_x, hosd_y, hosd_w, hosd_h, hosd_transparent)
Return


hosd_destroy()
{
	Global

	SelectObject(hosd_hdc, hosd_obm)
	DeleteObject(hosd_hbm)
	DeleteDC(hosd_hdc)
	Gdip_DeleteGraphics(hosd_G)

	GuiDefault("HOSDOverlay")
	Gui, Destroy
}
