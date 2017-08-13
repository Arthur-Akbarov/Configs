GetScrollInfo(hwnd, nBar, ByRef nPos, ByRef nPage, ByRef nMin, ByRef nMax, ByRef nTrackPos)    ; Gets scroll bar position and things
{
	;Win32 API:   BOOL GetScrollInfo( HWND hwnd, int fnBar, LPSCROLLINFO lpsi )

	VarSetCapacity(SCROLLBAR_INFO, 28, 0)   ;Allocate SCROLLBAR_INFO structure and zero it
	NumPut(28, &SCROLLBAR_INFO)         ;Initialize its count-bytes parameter
	NumPut(0x17, &SCROLLBAR_INFO + 4)      ;Initialize the mask for what properties to get or set, SIF_ALL = 0x17

	bSuccess := DllCall("GetScrollInfo", UInt, hwnd, Int, nBar, UInt, &SCROLLBAR_INFO)
	if (!bSuccess)
		return false

	nMin := NumGet(&SCROLLBAR_INFO, 8)
	nMax := NumGet(&SCROLLBAR_INFO, 12)
	nPage := NumGet(&SCROLLBAR_INFO, 16)
	nPos := NumGet(&SCROLLBAR_INFO, 20)
	nTrackPos := NumGet(&SCROLLBAR_INFO, 24)

	return true
}

SetScrollInfo(hwnd, nBar, nPos, nPage, nMin, nMax)  ; Guess this changes the scroll bar's position and what not
{
	;Win32 API:   int SetScrollInfo( HWND hwnd, int fnBar, LPCSCROLLINFO lpsi, BOOL fRedraw )

	global SCROLLBAR_INFO
	If (nMin) NumPut(nMin, &SCROLLBAR_INFO + 8)      ;Min
	If (nMax) NumPut(nMax, &SCROLLBAR_INFO + 12)      ;Max
	If (nPage) NumPut(nPage, &SCROLLBAR_INFO + 16)      ;Page
	NumPut(nPos, &SCROLLBAR_INFO + 20)      ;Pos
	iReturnPos := DllCall("SetScrollInfo", UInt, hwnd, Int, 1, UInt, &SCROLLBAR_INFO, Int, true)   ;SB_VERT = 1

	return (iReturnPos == nPos)
}

SetScrollPos(hwnd, nBar, nPos)
{
	; WM_HSCROLL or WM_VSCROLL must be sent for the window to update it's contents.
	msg := (nBar=0) ? 0x114 : 0x115
	wParam := 4 ; SB_THUMBPOSITION
		 | ((nPos&0xFFFF)<<16)
	SendMessage, msg, wParam,,, ahk_id %hwnd%
}
