tri_bounceIcon(n)
{
	Global tri_count
	n += 1

	Loop
	{
		Loop
		{
			if (n+1 > tri_count)
				break

			tri_moveIconUp(n)
			n += 1
			sleep, 500
		}

		Loop
		{
			if n <= 1
				break

			tri_moveIconDown(n)
			n -= 1
			sleep, 500
		}
	}
}

tri_moveIconUp(idx)
{
	MoveTrayIcon(idx,idx+1)
}

tri_moveIconDown(idx)
{
	MoveTrayIcon(idx,idx-1)
}

/*
tri_getTrayIcons:
	tri_list := TrayIcons()
	tri_count = 0
	Loop,parse,tri_list,`n
	{
		if A_LoopField !=
		{
			tri_count += 1
			tri_temp_no := A_Index
			tri_temp_proc%A_Index% := A_LoopField

			Loop, parse, tri_temp_proc%A_Index%,|
			{
				tri_temp_entry := A_LoopField
				tri_temp_pos := InStr(tri_temp_entry,":")

				StringLeft,tri_temp_key,tri_temp_entry,% tri_temp_pos-1
				StringTrimLeft,tri_temp_key,tri_temp_key,1
				StringTrimLeft,tri_temp_value,tri_temp_entry,% tri_temp_pos+1

				tri_process_%tri_temp_no%_%tri_temp_key% := tri_temp_value
			}
		}
	}
return


WM_MOUSEMOVE    = 0x0200
WM_LBUTTONDOWN    = 0x0201
WM_LBUTTONUP    = 0x0202
WM_LBUTTONDBLCLK = 0x0203
WM_RBUTTONDOWN    = 0x0204
WM_RBUTTONUP    = 0x0205
WM_RBUTTONDBLCLK = 0x0206
WM_MBUTTONDOWN    = 0x0207
WM_MBUTTONUP    = 0x0208
WM_MBUTTONDBLCLK = 0x0209

PostMessage, nMsg, uID, WM_RBUTTONDOWN, , ahk_id %hWnd%
PostMessage, nMsg, uID, WM_RBUTTONUP  , , ahk_id %hWnd%
*/


TrayIcons(sExeName = "")
{
	DetectHiddenWindows, On
	idxTB := GetTrayBar()
	WinGet, pidTaskbar, PID, ahk_class Shell_TrayWnd

	hProc := DllCall("OpenProcess", "Uint", 0x38, "int", 0, "Uint", pidTaskbar)
	pRB := DllCall("VirtualAllocEx", "Uint", hProc, "Uint", 0, "Uint", 20, "Uint", 0x1000, "Uint", 0x4)

	VarSetCapacity(btn, 20)
	VarSetCapacity(nfo, 24)
	VarSetCapacity(sTooltip, 128)
	VarSetCapacity(wTooltip, 128 * 2)

	SendMessage, 0x418, 0, 0, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd   ; TB_BUTTONCOUNT

	Loop, %ErrorLevel%
	{
		SendMessage, 0x417, A_Index - 1, pRB, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd   ; TB_GETBUTTON

		DllCall("ReadProcessMemory", "Uint", hProc, "Uint", pRB, "Uint", &btn, "Uint", 20, "Uint", 0)

		iBitmap	:= NumGet(btn, 0)
		idn	:= NumGet(btn, 4)
		Statyle := NumGet(btn, 8)
		dwData	:= NumGet(btn,12)
		iString	:= NumGet(btn,16)

		DllCall("ReadProcessMemory", "Uint", hProc, "Uint", dwData, "Uint", &nfo, "Uint", 24, "Uint", 0)

		hWnd	:= NumGet(nfo, 0)
		uID	:= NumGet(nfo, 4)
		nMsg	:= NumGet(nfo, 8)
		hIcon	:= NumGet(nfo,20)

		WinGet, pid, PID,              ahk_id %hWnd%
		WinGet, sProcess, ProcessName, ahk_id %hWnd%
		WinGetClass, sClass,           ahk_id %hWnd%

		If !sExeName || (sExeName = sProcess) || (sExeName = pid)
		{
			DllCall("ReadProcessMemory", "Uint", hProc, "Uint", iString, "Uint", &wTooltip, "Uint", 128 * 2, "Uint", 0)
			DllCall("WideCharToMultiByte", "Uint", 0, "Uint", 0, "str", wTooltip, "int", -1, "str", sTooltip, "int", 128, "Uint", 0, "Uint", 0)
			sTrayIcons .= "idx: " . A_Index - 1 . " | idn: " . idn . " | Pid: " . pid . " | uID: " . uID . " | MessageID: " . nMsg . " | hWnd: " . hWnd . " | Class: " . sClass . " | Process: " . sProcess . " | Tooltip: " . sTooltip . "`n"
		}
	}

	DllCall("VirtualFreeEx", "Uint", hProc, "Uint", pRB, "Uint", 0, "Uint", 0x8000)
	DllCall("CloseHandle", "Uint", hProc)

	Return	sTrayIcons
}

RemoveTrayIcon(hWnd, uID, nMsg = 0, hIcon = 0, nRemove = 2)
{
	NumPut(VarSetCapacity(ni,444,0), ni)
	NumPut(hWnd , ni, 4)
	NumPut(uID  , ni, 8)
	NumPut(1|2|4, ni,12)
	NumPut(nMsg , ni,16)
	NumPut(hIcon, ni,20)
	Return	DllCall("shell32\Shell_NotifyIconA", "Uint", nRemove, "Uint", &ni)
}

HideTrayIcon(idn, bHide = True)
{
	idxTB := GetTrayBar()
	SendMessage, 0x404, idn, bHide, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd   ; TB_HIDEBUTTON
	SendMessage, 0x1A, 0, 0, , ahk_class Shell_TrayWnd
}

DeleteTrayIcon(idx)
{
	idxTB := GetTrayBar()
	SendMessage, 0x416, idx - 1, 0, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd   ; TB_DELETEBUTTON
	SendMessage, 0x1A, 0, 0, , ahk_class Shell_TrayWnd
}

MoveTrayIcon(idxOld, idxNew)
{
	idxTB := GetTrayBar()
	SendMessage, 0x452, idxOld - 1, idxNew - 1, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd ; TB_MOVEBUTTON
}

GetTrayBar()
{
	WinGet, ControlList, ControlList, ahk_class Shell_TrayWnd
	RegExMatch(ControlList, "(?<=ToolbarWindow32)\d+(?!.*ToolbarWindow32)", nTB)

	Loop, %nTB%
	{
		ControlGet, hWnd, hWnd,, ToolbarWindow32%A_Index%, ahk_class Shell_TrayWnd
		hParent := DllCall("GetParent", "Uint", hWnd)
		WinGetClass, sClass, ahk_id %hParent%
		If (sClass <> "SysPager")
			Continue
		idxTB := A_Index
			Break
	}

	Return	idxTB
}
