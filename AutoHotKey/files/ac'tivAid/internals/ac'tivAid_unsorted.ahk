GetLocalizedFilename( FullPath )
{
	sfi_size = 352  ; Structure size of SHFILEINFO.
	VarSetCapacity(sfi, sfi_size)
	VarSetCapacity(path,256,0)
	path := FullPath
	DllCall("Shell32\SHGetFileInfoA", "str", path, "uint", 0, "str", sfi, "uint", sfi_size, "uint", 0x200)  ; 0x200 is SHGFI_DISPLAYNAME
	Return % StringGet(sfi,11,256)
}

EditWordBreakProc(lpch, ichCurrent, cch, code) {
	static exp = "\W" ; treat any non alphanumeric character as a delimiter with this regex
	Loop, % cch * 2 ; build the string:
		str .= Chr(*(lpch - 1 + A_Index))
	If code = 0 ; WB_LEFT
		Return, RegExMatch(SubStr(str, 1, ichCurrent = cch
			? cch : ichCurrent - (ichCurrent > 1)), exp . "[^" . exp . "]*\Z")
	Else If code = 1 ; WB_RIGHT
		Return, ichCurrent = cch or !(z := RegExMatch(str, exp, "", ichCurrent + 1)) ? cch : z - 1
	Else If code = 2 ; WB_ISDELIMITER
		Return, RegExMatch(SubStr(str, ichCurrent + 1, 1), exp)
}

LookupAccountName( sName, sSystem = "" ) {
	DllCall("advapi32\LookupAccountNameA", "str", sSystem, "str", sName, "Uint", 0, "UintP", nSizeSID, "Uint", 0, "UintP", nSizeRDN, "UintP", eUser)
	VarSetCapacity(SID, nSizeSID, 0)
	VarSetCapacity(RDN, nSizeRDN, 0)
	DllCall("advapi32\LookupAccountNameA", "str", sSystem, "str", sName, "str", SID, "UintP", nSizeSID, "str", RDN, "UintP", nSizeRDN, "UintP", eUser)

	DllCall("advapi32\ConvertSidToStringSidA", "str", SID, "UintP", pString)
	VarSetCapacity(sSid, DllCall("lstrlen", "Uint", pString))
	DllCall("lstrcpy", "str", sSid, "Uint", pString)
	DllCall("LocalFree", "Uint", pString)
	Return sSid
}

LookupAccountSid( sSid, sSystem = "" ) {
	DllCall("advapi32\ConvertStringSidToSidA", "str", sSid, "UintP", pSid)

	DllCall("advapi32\LookupAccountSidA", "str", sSystem, "Uint", pSid, "Uint", 0, "UintP", nSizeNM, "Uint", 0, "UintP", nSizeRD, "UintP", eUser)
	VarSetCapacity(sName, nSizeNM, 0)
	VarSetCapacity(sRDmn, nSizeRD, 0)
	DllCall("advapi32\LookupAccountSidA", "str", sSystem, "Uint", pSid, "str", sName, "UintP", nSizeNM, "str", sRDmn, "UintP", nSizeRD, "UintP", eUser)

	DllCall("LocalFree", "Uint", pSid)
	Return sName
}

; Gets a menu handle from a menu name.
; Adapted from Shimanov's Menu_AssignBitmap()
;   http://www.autohotkey.com/forum/topic7526.html
GetMenuHandle(menu_name)
{
	 static   h_menuDummy
	 If h_menuDummy=
	 {
		  Menu, menuDummy, Add
		  Menu, menuDummy, DeleteAll

		  Gui, 99:Menu, menuDummy
		  Gui, 99:Show, Hide, guiDummy

		  old_DetectHiddenWindows := A_DetectHiddenWindows
		  DetectHiddenWindows, on

		  Process, Exist
		  h_menuDummy := DllCall( "GetMenu", "uint", WinExist( "guiDummy ahk_class AutoHotkeyGUI ahk_pid " ErrorLevel ) )
		  If ErrorLevel or h_menuDummy=0
				return 0

		  DetectHiddenWindows, %old_DetectHiddenWindows%

		  Gui, 99:Menu
		  Gui, 99:Destroy
	 }

	 Menu, menuDummy, Add, :%menu_name%
	 h_menu := DllCall( "GetSubMenu", "uint", h_menuDummy, "int", 0 )
	 DllCall( "RemoveMenu", "uint", h_menuDummy, "uint", 0, "uint", 0x400 )
	 Menu, menuDummy, Delete, :%menu_name%

	 return h_menu
}


;returns first thread for the <processID>
;sets optional <List> to pipe | separated thread list for the <processID>
GetProcessThreadOrList( processID, byRef list="" )
{
	;THREADENTRY32 {
	THREADENTRY32_dwSize=0 ; DWORD
	THREADENTRY32_cntUsage = 4   ;DWORD
	THREADENTRY32_th32ThreadID = 8   ;DWORD
	THREADENTRY32_th32OwnerProcessID = 12   ;DWORD
	THREADENTRY32_tpBasePri = 16   ;LONG
	THREADENTRY32_tpDeltaPri = 20   ;LONG
	THREADENTRY32_dwFlags = 24   ;DWORD
	THREADENTRY32_SIZEOF = 28

	TH32CS_SNAPTHREAD=4

	hProcessSnap := DllCall("CreateToolhelp32Snapshot","uint",TH32CS_SNAPTHREAD, "uint",0)
	ifEqual,hProcessSnap,-1, return

	VarSetCapacity( thE, THREADENTRY32_SIZEOF, 0 )
	NumPut( THREADENTRY32_SIZEOF, thE )

	ret=-1

	if( DllCall("Thread32First","uint",hProcessSnap, "uint",&thE ))
		loop
		{
			if( NumGet( thE ) >= THREADENTRY32_th32OwnerProcessID + 4)
				if( NumGet( thE, THREADENTRY32_th32OwnerProcessID ) = processID )
				{   th := NumGet( thE, THREADENTRY32_th32ThreadID )
					IfEqual,ret,-1
						ret:=th
					list .=  th "|"
				}
			NumPut( THREADENTRY32_SIZEOF, thE )
			if( DllCall("Thread32Next","uint",hProcessSnap, "uint",&thE )=0)
				break
		}

	DllCall("CloseHandle","uint",hProcessSnap)
	StringTrimRight,list,list,1
	return ret
}

; Returns thread owning specified window handle
; default = Active window
GetThreadOfWindow( hWnd=0 )
{
	IfEqual,hWnd,0
		hWnd:=WinExist("A")
	DllCall("GetWindowThreadProcessId", "uint",hWnd, "uintp",id)
	GetProcessThreadOrList(  id, threads )
	IfEqual,threads,
		return 0
	CB:=RegisterCallback("GetThreadOfWindowCallBack","Fast")
	lRet=0
	lParam:=hWnd
	loop,parse,threads,|
	{   NumPut( hWnd, lParam )
		DllCall("EnumThreadWindows", "uint",A_LoopField, "uint",CB, "uint",&lParam)
		if( NumGet( lParam )=true )
		{   lRet:=A_LoopField
			break
		}
	}
	DllCall("GlobalFree", "uint", CB)
	return lRet
}

GetThreadOfWindowCallBack( hWnd, lParam )
{
	IfNotEqual,hWnd,% NumGet( 0+lParam )
		return true
	NumPut( true, 0+lParam )
	return 0
}



MouseMove(x,y,speed=0,relative="")
{
	CoordMode, Mouse, Screen
	If (relative <> "" AND relative <> "0")
	{
		MouseGetPos, movetoX, movetoY
		movetoX := movetoX + X
		movetoY := movetoY + Y
	}
	Else
	{
		movetoX := X
		movetoY := Y
	}
	DllCall("SetCursorPos", int, movetoX, int, movetoY)
}
