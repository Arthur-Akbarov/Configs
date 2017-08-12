ReadIcon(name,defVal="",defPos="",defValOff="",defPosOff="")
{
	Global
	Local name_test, icon_test

	icon_test := name
	StringRight, name_test, name, 1
	if name_test is integer
		StringTrimRight, icon_test, name, 1

	If defVal !=
		IniRead, TrayIcon[%name%], %A_ScriptDir%\Settings\icons.ini, MainIcons, %name%, %defVal%

	If defPos !=
		IniRead, TrayIconPos[%name%], %A_ScriptDir%\Settings\icons.ini, MainIcons, %name%_Pos, %defPos%

	If defValOff !=
		IniRead, TrayIconOff[%name%], %A_ScriptDir%\Settings\icons.ini, MainIcons, %name%_Off, %defValOff%

	If defPosOff !=
		IniRead, TrayIconOffPos[%name%], %A_ScriptDir%\Settings\icons.ini, MainIcons, %name%_Off_Pos, %defPosOff%

	If TrayIconOff[%name%] =
		TrayIconOff[%name%] = %A_WinDir%\system32\shell32.dll
	If TrayIconOffPos[%name%] =
		TrayIconOffPos[%name%] = 110

	IconFile_On_%name% := TrayIcon[%name%]
	IconPos_On_%name% := TrayIconPos[%name%]

	IfExist %A_ScriptDir%\icons\%icon_test%.ico
	{
		TrayIcon[%name%] := A_ScriptDir "\icons\" icon_test ".ico"
		TrayIconPos[%name%] := 0
		return
	}

	IfNotExist, % TrayIcon[%name%]
	{
		TrayIcon[%name%] =
		TrayIconPos[%name%] =
	}
	IfNotExist, % TrayIconOff[%name%]
	{
		TrayIconOff[%name%] =
		TrayIconOffPos[%name%] =
	}

}

ExtractIcon(Filename, IconNumber, IconSize=0)
{
	 static SmallIconSize, LargeIconSize
	 if (!SmallIconSize) {
		  SysGet, SmallIconSize, 49  ; 49, 50  SM_CXSMICON, SM_CYSMICON
		  SysGet, LargeIconSize, 11  ; 11, 12  SM_CXICON, SM_CYICON
	 }


	 VarSetCapacity(phicon, 4, 0)
	 h_icon = 0

	 ; If possible, use PrivateExtractIcons, which supports any size of icon.
	 if (aa_osversionnumber >= aa_osversionnumber_2000)
	 {
		  VarSetCapacity(piconid, 4, 0)

		  ; MSDN: "... this function is deprecated ..." (oh well)
		  ret := DllCall("PrivateExtractIcons"
				, "str", Filename
				, "int", IconNumber-1   ; zero-based index of the first icon to extract
				, "int", IconSize
				, "int", IconSize
				, "str", phicon         ; pointer to an array of icon handles...
				, "str", piconid        ; piconid - won't be used
				, "uint", 1             ; nIcons - number of icons to extract
				, "uint", 0, "uint")    ; flags

		  if (ret && ret != 0xFFFFFFFF)
				h_icon := NumGet(phicon)
	 }
	 else
	 {   ; Use ExtractIconEx, which only returns 16x16 or 32x32 icons.
		  VarSetCapacity(phiconSmall, 4, 0)

		  ; Extract the icon from an executable, DLL or icon file.
		  if DllCall("shell32.dll\ExtractIconExA"
				, "str", Filename
				, "int", IconNumber-1   ; zero-based index of the first icon to extract
				, "str", phicon         ; pointer to an array of icon handles...
				, "str", phiconSmall
				, "uint", 1)
		  {
				; Use the best-fit size; clean up the other.
				if (IconSize <= SmallIconSize) {
					 DllCall("DestroyIcon", "uint", NumGet(phicon))
					 h_icon := NumGet(phiconSmall)
				} else {
					 DllCall("DestroyIcon", "uint", NumGet(phiconSmall))
					 h_icon := NumGet(phicon)
				}
		  }
	 }

	 return h_icon
}

ChangeTrayIcon(Window,hicon,TrayTip="")
{
	DetectHiddenWindows, On
	If Window =
	{
		Process, Exist
		wid := WinExist("ahk_class AutoHotkey ahk_pid " ErrorLevel)
	}
	Else
		wid := WinExist(Window)
	StringLeft, TrayTip, TrayTip, 127
	If TrayTip <>
		uFlags := 0x6 ; NIF_ICON + NIF_TIP
	Else
		uFlags := 0x2 ; NIF_ICON
	; Prepare the NOTIFYICONDATA struct.
	VarSetCapacity(nid,488,0), NumPut(488,nid)

	; Set nid.hWnd to the script's main window.
	NumPut(wid, nid,4)
	; Set nid.uID to AHK_NOTIFYICON. hWnd and uID identify the tray icon.
	NumPut(1028,nid,8)
	; Set nid.hIcon=hicon and nid.uFlags=NIF_ICON.
	NumPut(hicon,nid,20), NumPut(uFlags,nid,12)
	If(TrayTip)
		Loop, Parse, TrayTip
			NumPut(Asc(A_LoopField),nid,23+A_Index)
	; Set the new icon. (NIM_MODIFY=0x1)
	DllCall("shell32\Shell_NotifyIcon","uint",0x1,"uint",&nid)
}



GetBigIcon(Window,Text="")
{
	DetectHiddenWindows, On
	;WM_GETICON
	;   ICON_SMALL          0
	;   ICON_BIG            1
	;   ICON_SMALL2         2
	WinGet, wid, ID, %Window%, %Text%
	SendMessage, 0x7F, 1, 0,, ahk_id %wid%
	h_icon := ErrorLevel
	if ( ! h_icon )
	{
		SendMessage, 0x7F, 2, 0,, ahk_id %wid%
		h_icon := ErrorLevel
		if ( ! h_icon )
		{
			SendMessage, 0x7F, 0, 0,, ahk_id %wid%
			h_icon := ErrorLevel
			if ( ! h_icon )
			{
				; GCL_HICON           (-14)
				h_icon := DllCall( "GetClassLong", "uint", wid, "int", -14 )

				if ( ! h_icon )
				{
					; GCL_HICONSM         (-34)
					h_icon := DllCall( "GetClassLong", "uint", wid, "int", -34 )

					if ( ! h_icon )
					{
						; IDI_APPLICATION     32512
						h_icon := DllCall( "LoadIcon", "uint", 0, "uint", 32512 )
					}
				}
			}
		}
	}
	Return %h_icon%
}

GetSmallIcon(Window, Text="", percentage="")
{
	DetectHiddenWindows, On
	;WM_GETICON
	;   ICON_SMALL          0
	;   ICON_BIG            1
	;   ICON_SMALL2         2
	WinGet, wid, ID, %Window%,%Text%
	SendMessage, 0x7F, 2, 0,, ahk_id %wid%
	h_icon := ErrorLevel
	if ( ! h_icon and ! (percentage > 0 and percentage <= 100) )
	{
		SendMessage, 0x7F, 0, 0,, ahk_id %wid%
		h_icon := ErrorLevel
		if ( ! h_icon )
		{
			SendMessage, 0x7F, 1, 0,, ahk_id %wid%
			h_icon := ErrorLevel
			if ( ! h_icon )
			{
				; GCL_HICONSM        (-34)
				h_icon := DllCall( "GetClassLong", "uint", wid, "int", -34 )

				if ( ! h_icon )
				{
					; GCL_HICON          (-14)
					h_icon := DllCall( "GetClassLong", "uint", wid, "int", -14 )

					if ( ! h_icon )
					{
						; IDI_APPLICATION     32512
						h_icon := DllCall( "LoadIcon", "uint", 0, "uint", 32512 )
					}
				}
			}
		}
	}
	if (percentage > 0 and percentage <= 100)
	{
		if !(hdcScreen := DllCall("GetDC","uint",0))
			return

		VarSetCapacity(buf,40,0), NumPut(40,buf), NumPut(1,buf,12,"ushort")
		NumPut(16,buf,4), NumPut(16,buf,8), NumPut(32,buf,14,"ushort")

		; Note that a compatible bitmap's format depends on the current display settings.
		; Changing the display depth after creating the icon may cause colour loss.
		;if hbm := DllCall("CreateCompatibleBitmap","uint",hdcScreen,"int",width,"int",height)

		if hbm := DllCall("CreateDIBSection","uint",hdcScreen,"uint",&buf,"uint",0
								,"uint*",pBits,"uint",0,"uint",0)
		{
			if hdc := DllCall("CreateCompatibleDC","uint",hdcScreen)
			{
				; Select the bitmap into a device context to draw on it.
				; Note that the previous bitmap should always be reselected afterwards.
				if hbm_old := DllCall("SelectObject","uint",hdc,"uint",hbm)
				{
					; Draw the bar
					VarSetCapacity(rc,16), NumPut(10,NumPut(ceil(16*(percentage/100)),NumPut(6,NumPut(0,rc,0))))
																 ; Bar blue-green-red
					hbr := DllCall("CreateSolidBrush","uint","0xaa0000")
					DllCall("FillRect","uint",hdc,"uint",&rc,"uint",hbr)
					DllCall("DeleteObject","uint",hbr), hbr:=0
					DllCall("SelectObject","uint",hdc,"uint",hbm_old)
				}

				; Since GDI doesn't support alpha-blending, we must manually set the
				; pixels to our background colour. We must also set the alpha component
				; of each bar pixel to 255, otherwise bars become mostly invisible.
				offset = 0
				Loop, 16 { ;height
					Loop, 16 { ;width
						px := NumGet(pBits+offset)
										; Background alpha-red-green-blue
						NumPut(px ? 255<<24|px : "0x00000000", pBits+offset)
						offset += 4
					}
				}

				VarSetCapacity(mask,64,0)
				hbm_mask := DllCall("CreateBitmap","int",16,"int",16,"uint",1,"uint",1,"uint",&mask)

				DllCall("DeleteDC","uint",hdc)
			}
		}
		DllCall("ReleaseDC","uint",0,"uint",hdcScreen)

		VarSetCapacity(ii,20,0), NumPut(1,ii,0), NumPut(hbm,ii,16), NumPut(hbm_mask,ii,12)
		h_icon := DllCall("CreateIconIndirect","uint",&ii)
		; "The system copies the bitmaps in the ICONINFO structure before creating the icon or cursor."
		DllCall("DeleteObject","uint",hbm)
		DllCall("DeleteObject","uint",hbm_mask)

		; Prepare the NOTIFYICONDATA struct.
		VarSetCapacity(nid,444,0), NumPut(444,nid)
		; Set nid.uID to AHK_NOTIFYICON. hWnd and uID identify the tray icon.
		NumPut(1028,nid,8)
		; Set nid.h_icon=h_icon and nid.uFlags=NIF_ICON.
		NumPut(h_icon,nid,20), NumPut(0x2,nid,12)

	}
	Return %h_icon%
}

Tray_Add( hGui, routine, hIcon, txt="")
{
	Global
	static NIF_ICON=2, NIF_MESSAGE=1, NIF_TIP=4, MM_SHELLICON=0x500
	static nidSize=88, uid=100, init

	if !IsLabel(routine)
		return 0

	if !init
		func_addMessage(0x500, "Tray_onShellIcon" ),init := true

	flags := NIF_ICON | NIF_TIP | NIF_MESSAGE

	VarSetCapacity( NID, nidSize, 0)
	NumPut(nidSize, NID, 0)
	NumPut(hGui,   NID, 4)
	NumPut(++uid,  NID, 8)
	NumPut(flags,   NID, 12)
	NumPut(MM_SHELLICON,   NID, 16)
	NumPut(hIcon,   NID, 20)
	DllCall("lstrcpyn", "uint", &NID+24, "uint", &txt, "int", 64)

	if !DllCall("shell32.dll\Shell_NotifyIconA", "uint", 0, "uint", &NID)
		return 0

	Tray_%uid%_routine := routine
	if ico is not Integer            ;save icon handle allocated by Tray module so icon can be destroyed.
		Tray_%uid%_hIcon := hIcon
	return uid
}

Tray_Remove( hGui, hTray ) {
	local res, NID
	static NIM_DELETE=2, nidSize=88

	VarSetCapacity( NID, nidSize, 0)
	NumPut(nidSize, NID, 0),  NumPut(hGui, NID, 4),   NumPut(hTray,   NID, 8)

	res := DllCall("shell32.dll\Shell_NotifyIconA", "uint", NIM_DELETE, "uint", &NID)

	DllCall("DestroyIcon", "uint", Tray_%hTray%_hIcon)    ;function will just fail if hIcon is invalid
	return res
}

Tray_Modify( hGui, hTray, ico, txt="" ) {
	local hIcon, flags, res, NID
	static NIM_MODIFY=1
	static NIF_ICON=2, NIF_TIP=4

	VarSetCapacity( NID, 88, 0)
	NumPut(88, NID, 0)

	flags := 0
	flags |= ico != "" ? NIF_ICON : 0
	flags |= txt != "" ? NIF_TIP  : 0

	hIcon := ico


	if (txt != ""){
		IfEqual, txt, -, SetEnv, txt
		DllCall("lstrcpyn", "uint", &NID+24, "uint", &txt, "int", 64)
	}

	NumPut(hGui,   NID, 4)
	NumPut(hTray,  NID, 8)
	NumPut(flags,   NID, 12)
	NumPut(hIcon,   NID, 20)
	res := DllCall("shell32.dll\Shell_NotifyIconA", "uint", NIM_MODIFY, "uint", &NID)

	if ico
	{
		DllCall("DestroyIcon", "uint", Tray_%hTray%_hIcon)
		if ico is not Integer
			Tray_%hTray%_hIcon := hIcon
	}

	return res
}

Tray_loadIcon(pPath, pW=0, pH=0){
	 return  DllCall( "LoadImage", "uint", 0, "str", pPath, "uint", 2, "int", pW, "int", pH, "uint", 0x10 | 0x20)     ; LR_LOADFROMFILE | LR_TRANSPARENT
}

Tray_onShellIcon:
	Tray_HWND   := #wparam
	Tray_EVENT  := (#lparam & 0xFFFF)

	if(Tray_EVENT=512)
		Tray_EVENT = Move

	if(Tray_EVENT=513)
		Tray_EVENT = L

	if(Tray_EVENT=514)
		Tray_EVENT = Lu

	if(Tray_EVENT=515)
		Tray_EVENT = Ld

	if(Tray_EVENT=516)
		Tray_EVENT = R

	if(Tray_EVENT=517)
		Tray_EVENT = Ru

	if(Tray_EVENT=518)
		Tray_EVENT = Rd

	if(Tray_EVENT=519)
		Tray_EVENT = M

	if(Tray_EVENT=520)
		Tray_EVENT = Mu

	if(Tray_EVENT=521)
		Tray_EVENT = Md

	If (IsLabel(Tray_%Tray_HWND%_routine))
		GoSub % Tray_%Tray_HWND%_routine
return
