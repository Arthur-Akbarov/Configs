func_ChooseColorAddGuiControl( ColorVariable, GuiText="", GuiOptions="y+10 xs+10")
{
	Global

	if(%ColorVariable% = "$1")
		%ColorVariable% := "aaccff"
	if(%ColorVariable% = "$2")
		%ColorVariable% := "ccffaa"
	if(%ColorVariable% = "$3")
		%ColorVariable% := "ffccaa"

	ChoosColorValue := %ColorVariable%

	GuiEditOptions = y+10 xs+10 w55
	If GuiText <>
	{
		Gui, Add, Text, %GuiOptions%, %GuiText%
		GuiEditOptions = yp-3 x+5 w55
	}
	Gui, Font,, Courier New
	Gui, Add, Edit, %GuiEditOptions% v%ColorVariable% Limit6 gChooseColorEdit, %ChoosColorValue%
	Gosub, GuiDefaultFont

	Gui Add, ListView, x+5 H20 W20 ReadOnly +0x4000 +Background%ChoosColorValue% v%ColorVariable%_Box lv0x800000 0x4 -TabStop gChooseColorButton AltSubmit
}

ChooseColorButton:
	If A_GuiEvent <> DoubleClick
		Return
	StringReplace, ChooseColorControl, A_GuiControl, _Box,
	GuiControlGet, ChooseColorCurrentCol,, %ChooseColorControl%
	ChooseColorNewColor := ChooseColor(ChooseColorCurrentCol, WinActive("A"))
	If (ChooseColorNewColor != -1)
	{
		ChooseColorCurColor := "0x" . ChooseColorNewColor
		GuiControl +Background%ChooseColorCurColor%, %ChooseColorControl%_Box
		GuiControl, , %ChooseColorControl%, % FormatHex(ChooseColorCurColor)
		func_SettingsChanged( "A_GuiControl" )
	}
Return

ChooseColorEdit:
	GuiControlGet, ChooseColorCurColor,, %A_GuiControl%
	GuiControl +Background%ChooseColorCurColor%, %A_GuiControl%Box
	func_SettingsChanged( "A_GuiControl" )
Return

ChooseColor( Color=0x0, hPar=0x0, ccFile="")  { ;Thanks Skan
	Color := SubStr(Color,1,2)="0x" ? Color : "0x" Color      ; Check & Prefix Color with "0x"
	VarSetCapacity(CHOOSECOLOR, 36, 0) , mainPtr := (&CHOOSECOLOR)     ; Create Main structure
	DllCall( "RtlFillMemory", UInt,mainPtr+0, Int,1, UChar,36 ) ; Insert size of the Structure

	hPar := WinExist(ahk_id %hPar%) ; Validate the passed Parent window ID
	; Break Parent window ID into 4 bytes
	H1 := hPar>>0 & 255,   H2 := hPar>>8 & 255,   H3 := hPar>>16 & 255,   H4 := hPar>>24 & 255
	Loop 4                       ; Insert Parent window ID to CHOOSECOLOR structure @ Offset 4
	  DllCall( "RtlFillMemory", UInt,mainPtr+3+A_Index, Int,1, UChar,H%A_Index% )

	; Break Color into R,G and B values
	RGB1 := Color>>16 & 255,    RGB2 := Color>>8  & 255,    RGB3 := Color>>0  & 255
	Loop 3                      ; Insert R,G and B values to CHOOSECOLOR structure @ Offset 12
	  DllCall( "RtlFillMemory", UInt,mainPtr+11+A_Index, Int,1, UChar,RGB%A_Index% )

	; CustomColors ( CUS1 will be primary array and CUS2 will be a copy to detect any change )
	VarSetCapacity(CUS1, 64, 0),   aPtr := (&CUS1),   VarSetCapacity(CUS2, 64, 0)
	IfEqual,ccFile,, SetEnv,ccFile,%A_WinDir%\CUSTOMCOLOR.BIN ; Assign default save filename
	IfExist,%ccFile%,  FileRead,CUS1, *m64 %ccFile%           ; Array CUS1 will be overwritten
	Loop 64                                                   ; Copy data from CUS1 to CUS2
	 oS:=A_Index-1, DllCall( "RtlFillMemory", UInt,&CUS2+oS, Int,1, UChar,*(&CUS1+oS) )
	A1 := aPtr>>0 & 255,   A2 := aPtr>>8 & 255,   A3 := aPtr>>16 & 255,   A4 := aPtr>>24 & 255
	Loop 4        ; Insert pointer to Custom colors array to CHOOSECOLOR structure @ Offset 16
		DllCall( "RtlFillMemory", UInt,mainPtr+15+A_Index, Int,1, UChar,A%A_Index% )

	; Insert Integer 259 @ Offset 21 (259 is CC_RGBINIT + CC_FULLOPEN + CC_ANYCOLOR )
	DllCall( "RtlFillMemory", UInt,mainPtr+20, Int,1,UChar,3  ) ; CC_RGBINIT=1 + CC_FULLOPEN=2
	DllCall( "RtlFillMemory", UInt,mainPtr+21, Int,1,UChar,1  ) ; CC_ANYCOLOR=256

	If ! DllCall("comdlg32\ChooseColorA", str, CHOOSECOLOR) OR errorLevel   ; Call ChooseColor
		  Return -1            ; and return -1 in case of an error or if no color was selected.

	Loop 64 ; Compare data CUS2 and CUS1, if custom color changed, then save array to BIN file
		If ( *(&CUS1+A_Index-1) != *(&CUS2+A_Index-1) )   {       ; Check byte by byte
			 h := DllCall( "_lcreat", Str,ccFile, Int,0 )         ; Overwrite/create file
					DllCall( "_lwrite", UInt,h, Str,CUS1, Int,64 )  ; write the array,
					DllCall( "_lclose", UInt,h )                    ; close the file,
					Break                                           ; break the loop.
																		 }
	Hex := "123456789ABCDEF0",   RGB := mainPtr+11
	Loop 3 ; Extract nibbles directly from main structure and convert it into Hex (initd. abv)
	  HexColorCode .=  SubStr(Hex, (*++RGB >> 4), 1) . SubStr(Hex, (*RGB & 15), 1)
	Return HexColorCode ; finally ... phew!
}
