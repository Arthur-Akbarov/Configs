func_GetOSVersion() {
    VarSetCapacity(v,148), NumPut(148,v)
    DllCall("GetVersionEx", "uint", &v)
    ; Return formatted version string similar to A_AhkVersion.
    return    NumGet(v,4) ; major
        . "." NumGet(v,8) ; minor
}
func_GetOSVersionBuild() {
    VarSetCapacity(v,148), NumPut(148,v)
    DllCall("GetVersionEx", "uint", &v)
    ; Assume build number will never be more than 4 characters.
		return SubStr("0000" NumGet(v,12), -3) ; build
}

func_GetFontList()
{
	Global FontList

	FontList =

	VarSetCapacity(lf, 60, 0)
	NumPut(1, lf, 23, "Uchar")   ; DEFAULT_CHARSET
	;DllCall("lstrcpy", "Uint", &lf+28, "str", sFaceName)

	hDC := DllCall("GetDC", "Uint", 0)
	DllCall("EnumFontFamiliesEx", "Uint", hDC, "Uint", &lf, "Uint", RegisterCallback("func_GetFontList_Callback", "Fast"), "Uint", 0, "Uint", 0)
	DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)

	Sort, FontList, UD|
	return %FontList%
}

func_bestAvailableOSFont()
{
	If (aa_osversionnumber < aa_osversionnumber_vista)
		return "Verdana"

	If (aa_osversionnumber >= aa_osversionnumber_vista)
		return "Calibri"

	return "Arial"
}

func_GetFontList_Callback(lpelfe, lpntme, nType, lParam)
{
	Global FontList

	Loop, % DllCall("lstrlen", "Uint", lpelfe+60)
		sFullName .= Chr(*(lpelfe+60+A_Index-1))
	Loop, % DllCall("lstrlen", "Uint", lpelfe+124)
		sStyle .= Chr(*(lpelfe+124+A_Index-1))
	;Loop, % DllCall("lstrlen", "Uint", lpelfe+156)
	;   sScript .= Chr(*(lpelfe+156+A_Index-1))
	;AllFontsList = % AllFontsList "Type: " . nType . "`tFullName: " . sFullName . "`tStyle: " . sStyle . "`tScript: " . sScript . "`n"

	FontList := FontList sFullName "|"

	Return   True
}


func_getNormalizedVersionNumber(ScriptVersion)
{
	ScriptVersion4 = 9999999
	ScriptVersionTmp = %ScriptVersion%
	StringReplace, ScriptVersionTmp, ScriptVersionTmp, %A_Space%Beta, .
	StringReplace, ScriptVersionTmp, ScriptVersionTmp, %A_Space%Alpha, .
	StringSplit, ScriptVersion, ScriptVersionTmp, .
	StringReplace, ScriptVersion3, ScriptVersion3, e,
	StringReplace, ScriptVersion4, ScriptVersion4, e,
	StringReplace, ScriptVersion5, ScriptVersion5, e,

	ScriptVersion3 := "0000000000" ScriptVersion3
	StringRight, ScriptVersion3,ScriptVersion3, 10
	ScriptVersion4 := "0000000000" ScriptVersion4
	StringRight, ScriptVersion4, ScriptVersion4, 10
	ScriptVersion5 := "0000000000" ScriptVersion5
	StringRight, ScriptVersion5, ScriptVersion5, 10
	ScriptVersionCon = %ScriptVersion1%.%ScriptVersion2%.%ScriptVersion3%.%ScriptVersion4%.%ScriptVersion5%
	Return %ScriptVersionCon%
}

func_DumpVars( dumpVarsVariables, Parameters="",LocalVar1="",LocalVar2="",LocalVar3="",LocalVar4="",LocalVar5="",LocalVar6="",LocalVar7="",LocalVar8="",LocalVar9="" )
{
	Global
	Local ShowVar:=true,Delimiter:="`n"
	#IncludeAgain %A_ScriptDir%\library\#ParseFunctionParameters.ahk

	AutoTrim, On
	dumpVarsResult =
	Loop, Parse, dumpVarsVariables, `,
	{
		dumpVarsVariable = %A_LoopField%
		dumpVarsVariable := %dumpVarsVariable%
		If (dumpVarsVariable = "" AND LocalVar%A_Index% <> "")
			dumpVarsVariable := LocalVar%A_Index%
		If ShowVar
			dumpVarsResult:= dumpVarsResult A_LoopField " = " dumpVarsVariable Delimiter
		Else
			dumpVarsResult:= dumpVarsResult dumpVarsVariable Delimiter
	}
	Return dumpVarsResult
}

func_Deref(Var,Debug="")
{
	If Debug <>
		OutputDebug, Deref: %A_ThisLabel% - %Debug%
	Transform, Var, Deref, %Var%
	Return %Var%
}

func_ReplaceWithCommonPathVariables(Var,AdditionalVariables="")
{
	Global Drive,A_AutoHotkeyPath
	Variables = %AdditionalVariables%A_Desktop,A_DesktopCommon,A_Programs,A_ProgramsCommon,A_Startup,A_StartupCommon,A_StartMenu,A_StartMenuCommon,A_ProgramFiles,A_WinDir,A_AppData,A_AppDataCommon,A_MyDocuments,A_Temp,Drive,A_AutoHotkeyPath,A_ScriptDir
	Loop, Parse, Variables, `,
	{
		LoopField := %A_LoopField%
		If Var = %LoopField%
			Var = `%%A_LoopField%`%
		Else
			StringReplace, Var, Var, %LoopField%\, `%%A_LoopField%`%\
	}
	Return %Var%
}

; MetaSoundex: Gibt einen phonetisch vereinfachten String zurück
func_MetaSoundex(String, Parameters="" )
{
	RemovePunctuation = space
	CaseSensitive := true

	#IncludeAgain %A_ScriptDir%\library\#ParseFunctionParameters.ahk

	StringCaseSense, Off
	; Doppelbuchstaben und Sonderzeichen vereinfachen
	StringReplace, String, String, bb, b, A
	StringReplace, String, String, cc, c, A
	StringReplace, String, String, dd, d, A
	StringReplace, String, String, ff, f, A
	StringReplace, String, String, gg, g, A
	StringReplace, String, String, hh, h, A
	StringReplace, String, String, jj, j, A
	StringReplace, String, String, kk, k, A
	StringReplace, String, String, ll, l, A
	StringReplace, String, String, mm, m, A
	StringReplace, String, String, nn, n, A
	StringReplace, String, String, pp, p, A
	StringReplace, String, String, rr, r, A
	StringReplace, String, String, ss, s, A
	StringReplace, String, String, tt, t, A
	StringReplace, String, String, vv, v, A
	StringReplace, String, String, ww, w, A
	StringReplace, String, String, xx, x, A
	StringReplace, String, String, zz, z, A
	StringReplace, String, String, ú, u, A
	StringReplace, String, String, ù, u, A
	StringReplace, String, String, û, u, A
	StringReplace, String, String, ü, u, A
	StringReplace, String, String, á, a, A
	StringReplace, String, String, à, a, A
	StringReplace, String, String, â, a, A
	StringReplace, String, String, å, a, A
	StringReplace, String, String, ã, a, A
	StringReplace, String, String, æ, a, A
	StringReplace, String, String, ä, a, A
	StringReplace, String, String, é, e, A
	StringReplace, String, String, è, e, A
	StringReplace, String, String, ê, e, A
	StringReplace, String, String, ë, e, A
	StringReplace, String, String, ó, o, A
	StringReplace, String, String, ò, o, A
	StringReplace, String, String, ô, o, A
	StringReplace, String, String, ø, o, A
	StringReplace, String, String, õ, o, A
	StringReplace, String, String, ö, o, A
	StringReplace, String, String, ý, y, A
	StringReplace, String, String, í, i, A
	StringReplace, String, String, ì, i, A
	StringReplace, String, String, î, i, A
	StringReplace, String, String, ï, i, A
	StringReplace, String, String, ç, c, A
	StringReplace, String, String, ÿ, y, A
	StringReplace, String, String, ñ, n, A
	StringReplace, String, String, ð, d, A
	StringReplace, String, String, %A_Space%%A_Space%, %A_Space%, A

	If RemovePunctuation
	{
		If RemovePunctuation = space
			RemovePunctuation = %A_Space%
		If RemovePunctuation = 1
			RemovePunctuation =
		String := func_RemovePunctuation(String,RemovePunctuation)
	}

	; Buchstabenkombinationen phonetish vereinfachen
	StringReplace, String, String, v, f, A
	StringReplace, String, String, w, f, A
	StringReplace, String, String, sch, s, A
	StringReplace, String, String, chs, s, A
	StringReplace, String, String, cks, s, A
	StringReplace, String, String, ch, k, A
	StringReplace, String, String, cz, s, A
	StringReplace, String, String, ks, s, A
	StringReplace, String, String, ts, s, A
	StringReplace, String, String, tz, s, A
	StringReplace, String, String, sz, s, A
	StringReplace, String, String, ck, k, A
	StringReplace, String, String, dt, t, A
	StringReplace, String, String, pf, f, A
	StringReplace, String, String, ph, f, A
	StringReplace, String, String, ch, o, A
	StringReplace, String, String, qu, kf, A
	StringReplace, String, String, ct, kt, A

	If CaseSensitive
	{
		; Schrägstriche mit Leerzeichen umschließen
		StringReplace, String, String, \, %A_Space%#\\\#%A_Space%, A
		StringReplace, String, String, /, %A_Space%#///#%A_Space%, A
		; Anfangsbuchstaben der Wörter groß
		StringUpper, String, String, T
		; Leerzeichen um Schrägstriche wieder entfernen
		StringReplace, String, String, %A_Space%#\\\#%A_Space%, \, A
		StringReplace, String, String, %A_Space%#///#%A_Space%, /, A
		; Leerzeichen um * wieder entfernen
		StringCaseSense, On
	}

	; Buchstaben phonetisch Zahlen zuordnen
	StringReplace, String, String, ie, 7, A
	StringReplace, String, String, ei, 7, A
	StringReplace, String, String, ai, 7, A
	StringReplace, String, String, ui, 7, A
	StringReplace, String, String, oi, 7, A
	StringReplace, String, String, a, , A
	StringReplace, String, String, e, , A
	StringReplace, String, String, i, , A
	StringReplace, String, String, o, , A
	StringReplace, String, String, u, , A
	StringReplace, String, String, h, , A
	StringReplace, String, String, w, , A
	StringReplace, String, String, y, , A
	StringReplace, String, String, b, 1, A
	StringReplace, String, String, f, 1, A
	StringReplace, String, String, p, 1, A
	StringReplace, String, String, v, 1, A
	StringReplace, String, String, c, 2, A
	StringReplace, String, String, g, 8, A
	StringReplace, String, String, j, 2, A
	StringReplace, String, String, k, 8, A
	StringReplace, String, String, q, 8, A
	StringReplace, String, String, ß, 2, A
	StringReplace, String, String, s, 2, A
	StringReplace, String, String, x, 2, A
	StringReplace, String, String, z, 2, A
	StringReplace, String, String, d, 3, A
	StringReplace, String, String, t, 3, A
	StringReplace, String, String, l, 4, A
	StringReplace, String, String, m, 5, A
	StringReplace, String, String, n, 5, A
	StringReplace, String, String, r, 6, A

	Return %String%
}

func_RemovePunctuation(String,RemovePunctuation="",DontRemoveWildcard=0)
{
	StringReplace, String, String, -, %RemovePunctuation% , A
	StringReplace, String, String, `,, %RemovePunctuation% , A
	StringReplace, String, String, ', %RemovePunctuation% , A
	StringReplace, String, String, ., %RemovePunctuation% , A
	StringReplace, String, String, `;, %RemovePunctuation% , A
	StringReplace, String, String, :, %RemovePunctuation% , A
	StringReplace, String, String, _, %RemovePunctuation% , A
	StringReplace, String, String, +, %RemovePunctuation% , A
	If DontRemoveWildcard = 0
		StringReplace, String, String, *, %RemovePunctuation% , A
	StringReplace, String, String, (, %RemovePunctuation% , A
	StringReplace, String, String, ), %RemovePunctuation% , A
	StringReplace, String, String, {, %RemovePunctuation% , A
	StringReplace, String, String, }, %RemovePunctuation% , A
	StringReplace, String, String, [, %RemovePunctuation% , A
	StringReplace, String, String, ], %RemovePunctuation% , A
	StringReplace, String, String, /, %RemovePunctuation% , A
	StringReplace, String, String, \, %RemovePunctuation% , A
	Return String
}

func_URLEncode( url ) {
	SetFormat, integer, hex
	StringReplace, url, url, `%, `%25, A
	StringReplace, url, url, %A_Space%, `%20, A
	StringReplace, url, url, `", `%22, A
	; " ; end qoute for syntax highlighting
	StringReplace, url, url, `&, `%26, A
	StringReplace, url, url, `?, `%3F, A
	Loop, 127
	{
		HexCode := A_Index+127
		Transform, HighChar, Chr, %HexCode%
		StringUpper, HexCode, HexCode
		StringReplace, HexCode, HexCode, 0x,`%
		StringReplace, url, url, %HighChar%, %HexCode%
	}
	SetFormat, integer, dec
	Return %url%
}

func_SelectInExplorer( FileName, Window="", Index="" )
{
	global Break
	If Window =
		Window = A

	RegRead, HideFileExt, HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt

	If HideFileExt = 1
		SplitPath, FileName, , , , FileName

	ControlFocus, SysListView321, %Window%

	Send, %FileName%

	Sleep, 40

	ControlGet, List, List, Col1, SysListView321, %Window%
	ControlGet, Focused, List, Focused Col1, SysListView321, %Window%

	If Focused = %FileName%
		Return

	StartIndex =
	Loop, Parse, List, `n, `r
	{
		If A_LoopField = %Focused%
		{
			StartIndex = %A_Index%
			Break
		}
	}

	If StartIndex =
	{
		StartIndex = 1
		ControlSend, SysListView321, {Home}, %Window%
	}

	If Index =
	{
		Loop, Parse, List, `n, `r
		{
			If A_LoopField = %FileName%
			{
				Index = %A_Index%
				Break
			}
			Index =
		}
	}

	If (Index = StartIndex OR Index = "")
		Return

	If (Index > StartIndex)
	{
		Move := Index - StartIndex
		If Move > 0
		{
			If Move > 1
			{
				Move --
				Send, {Ctrl down}{Down %Move%}{Ctrl up}{Down}
			}
			Else
				Send, {Down}
			Send, %FileName%
		}
	}
	Else
	{
		Move := StartIndex - Index
		If Move > 0
		{
			If Move > 1
			{
				Send, {Ctrl down}{Up %Move%}{Ctrl up}{Up}
			}
			Else
				Send, {Up}
			Send, %FileName%
		}
	}
}

func_EscapeForSend( String, WithEscape=1 )
{
	StringReplace, String, String, {, {#aad#{, a
	StringReplace, String, String, }, {}}, a
	StringReplace, String, String, {#aad#{, {{}, a
	StringReplace, String, String, ^, {ASC 094}, a
	StringReplace, String, String, !, {!}, a
	StringReplace, String, String, +, {+}, a
	StringReplace, String, String, #, {#}, a
	If WithEscape = 1
		StringReplace, String, String, ``, ````, a

	StringReplace, String, String, ``, {ASC 096}, a
	StringReplace, String, String, ´, {ASC 0180}, a

	Return %String%
}

func_EscapeForRegEx( String )
{
	String := RegExReplace(String,"([\\\.\*\?\+\[\{\|\(\)\^\$\}\]])","\$1")
	Return %String%
}

func_Swap(ByRef Var1, ByRef Var2)
{
	Var3 := Var1
	Var1 := Var2
	Var2 := Var3
}

func_FormatNumber( number, lngID="" )
{
	Global RegionFormatID
	SetFormat, Integer, Hex
	If lngID =
	{
		lngID := DllCall("GetKeyboardLayout", "uint",GetThreadOfWindow(), "uint")
		lngID := lngID & 0xFFFF
	}
	RegionFormatID = %lngID%
	SetFormat, Integer, Dec

	fmtSize = 100 ; Generous... I can also call GetNumberFormat to get needed size
	granted := VarSetCapacity(formatted, fmtSize, 0)

	If (granted < fmtSize)
	{
		; Cannot allocate enough memory
		ErrorLevel = Error: Memory (%granted%/%fmtSize%)
		Return
	}

	result := DllCall("GetNumberFormat"
			, "UInt", lngID      ; Locale
			, "UInt", 0      ; dwFlags (user format)
			, "Str", number   ; lpValue
			, "UInt", 0      ; lpFormat (NULL)
			, "Str", formatted      ; lpNumberStr
			, "UInt", fmtSize)   ; cchNumber
	If (result == 0 or ErrorLevel != 0)
	{
		ErrorLevel = Error - API %ErrorLevel%
		Return
	}
	Return formatted
}

func_SortHotkeyModifiers( Hotkey )
{
	global WinModifierFirst
	If StrLen(Hotkey) > 2
	{
		Hotkey := RegExReplace(Hotkey, "^([^ ]*)\+\^([^+\^]*)$", "$1^+$2")
		Hotkey := RegExReplace(Hotkey, "^([^ ]*)!#([^!#]+)$", "$1#!$2")
		Hotkey := RegExReplace(Hotkey, "^([^ ]*)\+#([^+#]+)$", "$1#+$2")
		If WinModifierFirst = 1
			Hotkey := RegExReplace(Hotkey, "^([^ ]*)\^#([^#^]+)$", "$1#^$2")
		Else
			Hotkey := RegExReplace(Hotkey, "^([^ ]*)#\^([^#^]+)$", "$1^#$2")
		Hotkey := RegExReplace(Hotkey, "^([^ ]*)!\^([^!^]+)$", "$1^!$2")
		Hotkey := RegExReplace(Hotkey, "^([^ ]*)\+!([^!+]+)$", "$1!+$2")
	}
	StringReplace, Hotkey, Hotkey, ^Pause, ^CtrlBreak

	Return %Hotkey%
}

func_isFullscreen( Window="A" )
{
	global FullScreenApps
	WinGetClass, tmpWinClass, %Window%
	If tmpWinClass contains %FullScreenApps%
		Return true
	WinGetTitle, tmpWinTitle, %Window%
	If tmpWinTitle contains %FullScreenApps%
		Return true

	Return false
}

func_SearchInControl( SearchTerm, Control, Window="", Backwards=0 )
{
	global SearchTermLast
	If Window = ""
		Window = "A"
	ControlGetFocus, ControlTmp, %Window%
	ControlFocus, %Control%, %Window%
	ControlGetText, searchEditText, %Control%, %Window%
	StringReplace, searchEditText, searchEditText, `r`n, `n, %Window%
	StringReplace, searchEditText, searchEditText, `n, `r`n, %Window%
	ControlGet, searchCol, CurrentCol,,%Control%, %Window%
	ControlGet, searchLine, CurrentLine,,%Control%, %Window%
	searchCol--
	searchLine--
	If SearchTerm <> %SearchTermLast%
		searchCol := searchCol-StrLen(SearchTerm)
	SendMessage, 0xBB, searchLine, 0 , %Control%, %Window%  ; EM_LINEINDEX
	searchEditIndex := Errorlevel + searchCol

	If Backwards = 1
	{
		StringLeft, searchEditTmp, searchEditText, %searchEditIndex%
		StringReplace, searchEditTmp, searchEditTmp, %SearchTerm%,,A UseErrorLevel
		searchBackPos := ErrorLevel
		StringGetPos, searchSearchPos, searchEditText, %SearchTerm%, L%searchBackPos%
	}
	Else
		StringGetPos, searchSearchPos, searchEditText, %SearchTerm%, L, % searchEditIndex+1

	If searchSearchPos = -1
	{
		If _NoSoundBeepInSearch = 0
			SoundBeep, 500, 20
		If Backwards = 1
		{
			searchSearchPos = -1
			Loop, 300
			{
				lastSearchPos = %searchSearchPos%
				StringGetPos, searchSearchPos, searchEditText, %SearchTerm%, L, % searchSearchPos+1
				If searchSearchPos = -1
				{
					searchSearchPos = %lastSearchPos%
					break
				}
			}
		}
		Else
		{
			searchEditIndex = 0
			SendMessage, 0x115, 6 , , %Control% ; WM_VSCROLL (top)
			StringGetPos, searchSearchPos, searchEditText, %SearchTerm%, L, % searchEditIndex+1
		}
	}

	If searchSearchPos <> -1
	{
		ControlGetPos,,,, ScrollHalfHeight, %Control%, %Window%
		ScrollHalfHeight := ScrollHalfHeight/24
		;SendMessage, 0x115, 6 , , %Control% ; WM_VSCROLL (top)
		SendMessage, 0xB1, searchSearchPos, searchSearchPos+StrLen(SearchTerm), %Control%, %Window% ; EM_SETSEL
		SendMessage, 0xB7, , , %Control%, %Window% ; EM_SCROLLCARET
		If Backwards = 1
			ControlSend, %Control%, {Up %ScrollHalfHeight%}{Down %ScrollHalfHeight%}, %Window%
		Else
			ControlSend, %Control%, {Down %ScrollHalfHeight%}{Up %ScrollHalfHeight%}, %Window%
		SendMessage, 0xB1, searchSearchPos, searchSearchPos+StrLen(SearchTerm), %Control%, %Window% ; EM_SETSEL
		;SendMessage, 0xB6, , %ScrollHalfHeight%, %Control% ; EM_LINESCROLL
		SendMessage, 0x114, 6 , , %Control% ; WM_VSCROLL (htop)
	}
	Else
		If _NoSoundBeepInSearch = 0
			SoundBeep, 500, 20

	SearchTermLast = %SearchTerm%
	ControlFocus, %ControlTmp%, %Window%
}

; Ermittelt die Höhe einer Zeile in der ListView des Windows Explorers.
;
; Für den Code vielen Dank an shimanov im englischen Forum unter:
; http://www.autohotkey.com/forum/viewtopic.php?p=53882
func_GetLVRowHeight( Window="", Class="" )
{
	If Window =
		Window = A
	WinGet, pid_target, PID, %Window%

	hp_explorer := DllCall( "OpenProcess"
								, "uint", 0x18                           ; PROCESS_VM_OPERATION|PROCESS_VM_READ
								, "int", false
								, "uint", pid_target )

	remote_buffer := DllCall( "VirtualAllocEx"
								, "uint", hp_explorer
								, "uint", 0
								, "uint", 0x1000
								, "uint", 0x1000                        ; MEM_COMMIT
								, "uint", 0x4 )                           ; PAGE_READWRITE

	; LVM_GETITEMRECT
	;   LVIR_BOUNDS
	SendMessage, 0x1000+14, 0, remote_buffer, %Class%, %Window%

	VarSetCapacity( rect, 16, 0 )
	result := DllCall( "ReadProcessMemory"
						, "uint", hp_explorer
						, "uint", remote_buffer
						, "uint", &rect
						, "uint", 16
						, "uint", 0 )

	result := DllCall( "VirtualFreeEx"
							, "uint", hp_explorer
							, "uint", remote_buffer
							, "uint", 0
							, "uint", 0x8000 )                           ; MEM_RELEASE

	result := DllCall( "CloseHandle", "uint", hp_explorer )

	y1 := 0
	y2 := 0
	loop, 4
	{
		y1 += *( &rect+3+A_Index )
		y2 += *( &rect+11+A_Index )
	}
	rowHeight := y2-y1

	Return rowHeight
}

func_GetErrorMessage( Error,MessageHeader="",MessageBody="" )
{
	bufferSize = 1024 ; Arbitrary, should be large enough for most uses
	VarSetCapacity(buffer, bufferSize)
	FORMAT_MESSAGE_FROM_SYSTEM = 0x1000
	LANG_SYSTEM_DEFAULT = 0x10000
	LANG_USER_DEFAULT = 0x20000
	DllCall("FormatMessage"
		, "UInt", FORMAT_MESSAGE_FROM_SYSTEM
		, "UInt", 0
		, "UInt", Error
		, "UInt", LANG_USER_DEFAULT
		, "Str", buffer
		, "UInt", bufferSize
		, "UInt", 0)

	If MessageHeader <>
		BalloonTip( MessageHeader, MessageBody Buffer, "Error" , 0, 0, 10)

	Debug("ERROR",A_LineNumber,A_LineFile, MessageHeader " " MessageBody " " Buffer )

	Return %buffer%
}

func_BeautifyIniFile( IniFile )
{
	Critical
	FileDelete, %IniFile%.tmp
	IniFileNewContent =
	FileRead, IniFileContent, %IniFile%
	Loop, Parse, IniFileContent, `n, `r
	{
		If A_LoopField =
			continue

		If A_LoopField = `;____________________________________________________________________________
			continue

		If A_LoopField = `;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
			continue

		If ( func_StrLeft(A_LoopField,1) = "[" )
		{
			IniFileNewContent = %IniFileNewContent%`r`n`;____________________________________________________________________________`r`n
			IniFileNewContent = %IniFileNewContent%%A_LoopField%`r`n
			IniFileNewContent = %IniFileNewContent%`;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯`r`n
			continue
		}

		StringGetPos, ReadLinePos, A_LoopField, =
		ReadLinePos := 32-ReadLinePos
		StringRight, ReadLineIndent, A_SpaceLine, %ReadLinePos%
		StringReplace, ReadLine, A_LoopField, =, % "" ReadLineIndent "="
		IniFileNewContent = %IniFileNewContent%%ReadLine%`r`n
	}
	FileAppend, %IniFileNewContent%, %IniFile%.tmp
	Sleep, 200
	If ErrorLevel = 0
	{
		FileDelete, %IniFile%
		Sleep, 200
		FileCopy, %IniFile%.tmp, %IniFile%, 1
		Sleep, 200
	}
	FileDelete, %IniFile%.tmp
}

func_GetMonitorNumber( Mode="" )
{
	global

	If Mode = Mouse
	{
		CoordMode, Mouse, Screen
		MouseGetPos, MouseX, MouseY

		Loop, %NumOfMonitors%
		{
			If (MouseX >= Monitor%A_Index%Left AND MouseX <= Monitor%A_Index%Right AND MouseY >= Monitor%A_Index%Top AND MouseY <= Monitor%A_Index%Bottom)
				Return %A_Index%
		}
	}
	Else
	{
		If (Mode = "" OR Mode = "ActiveWindow")
			Mode = A
		WinGetPos, WinX, WinY, WinW, WinH, %Mode%
		WinCenX := WinX + WinW/2
		WinCenY := WinY + WinH/2

		Loop, %NumOfMonitors%
		{
			If (WinCenX >= Monitor%A_Index%Left AND WinCenX <= Monitor%A_Index%Right AND WinCenY >= Monitor%A_Index%Top AND WinCenY <= Monitor%A_Index%Bottom)
				Return %A_Index%
		}

	}
	Return 1
}

func_CenterCoordsOnActiveMonitor(ByRef WinX, ByRef WinY, WinW=0, WinH=0, GuiShow=2,Mon="")
{
	Global BorderHeight, CaptionHeight, BorderHeightToolWindow, MenuBarHeight
	If Mon =
		Mon := func_GetMonitorNumber("Mouse")
	If GuiShow > 0
	{
		WinW := WinW + BorderHeight*2-2
		WinH := WinH + BorderHeight*2-2 + CaptionHeight
		If GuiShow = 2
			WinH := WinH + MenuBarHeight
	}
	WinX := Monitor%Mon%Left+Floor((Monitor%Mon%Width-WinW)/2)
	WinY := Monitor%Mon%Top+Floor((Monitor%Mon%Height-WinH)/2)
	If GuiShow > 0
	{
		WinX = x%WinX%
		WinY = y%WinY%
	}
}

func_CheckIfCoordsCentered(WinX, WinY, WinW=0, WinH=0)
{
	Global NumOfMonitors
	Loop %NumOfMonitors%
	{
		WinXtest := WinX
		WinYtest := WinY
		func_CenterCoordsOnActiveMonitor(WinXtest, WinYtest, WinW, WinH,0,A_Index)
		If (WinXtest = WinX AND WinYtest = WinY)
			Return true
	}
	Return false
}

func_MoveCoordsIntoViewArea(ByRef WinX, ByRef WinY, WinW=0, WinH=0, GuiShow=2,Mon="Area")
{
	Global BorderHeight, CaptionHeight, BorderHeightToolWindow, MenuBarHeight
	If Mon = Mouse
		Mon := func_GetMonitorNumber("Mouse")
	If GuiShow > 0
	{
		WinW := WinW + BorderHeight*2-2
		WinH := WinH + BorderHeight*2-2 + CaptionHeight
		If GuiShow = 2
			WinH := WinH + MenuBarHeight
	}
	If (WinX+WinW > Monitor%Mon%Right)
		WinX := Monitor%Mon%Right-WinW
	If (WinY+WinH > Monitor%Mon%Bottom)
		WinY := Monitor%Mon%Bottom-WinH
	If (WinX+WinW < Monitor%Mon%Left)
		WinX := Monitor%Mon%Left
	If (WinY+WinH < Monitor%Mon%Top)
		WinY := Monitor%Mon%Top
	If GuiShow > 0
	{
		WinX = x%WinX%
		WinY = y%WinY%
	}
}


func_WildcardMatch( Haystack, Needle, Case=0 )
{
	If (!InStr(Needle,"*"))
	{
		If (InStr(Haystack,Needle,Case))
			Return true
		Else
			Return false
	}
	If Case = 1
		StringCaseSense, On
	Else
		StringCaseSense, Off

	StringReplace, ext_temp, Needle, *, *, A UseErrorLevel
	NumOfParts := ErrorLevel+1

	notFound = 0
	Loop, Parse, Needle, *
	{
		If A_LoopField =
			continue

		StringLen, PartLen, A_LoopField

		If A_Index = 1
		{
			StringLeft, CompareString, Haystack, %PartLen%
			StringTrimLeft, Haystack, Haystack, %PartLen%
			StringTrimLeft, Needle, Needle, % PartLen+1
			If A_LoopField != %CompareString%
				notFound++
		}
		Else If A_Index = %NumOfParts%
		{
			StringRight, CompareString, Haystack, %PartLen%
			StringTrimRight, Haystack, Haystack, %PartLen%
			StringTrimRight, Needle, Needle, % PartLen+1
			If A_LoopField != %CompareString%
				notFound++
		}
	}
	If NumOfParts > 2
	{
		Loop, Parse, Needle, *
		{
			IfNotInstring, Haystack, %A_LoopField%
				notFound++
		}
	}
	If notFound > 0
		return false
	Else
		return true
}

func_GetSelection( copyAsText=1, copyOnly=0, clipWaitTime=0.5 )
{
	global Selection, SavedClipboard, NoOnClipboardChange
	NoOnClipboardChange = 1

	SavedClipboard := ClipboardAll
	Clipboard =
	Sleep,0

	; now watch for the process-executable instead of just window title:
	WinGetClass, Class, A
	WinGet, this_process, ProcessName, ahk_class %Class%

	if (this_process == "maya.exe")
	{
		ControlGetFocus, tmp, A
		if (SubStr(tmp,1,8) != "RichEdit")
		{
			Selection := ""
			Return
		}
	}

	;Send, {Blind}%resetModifiers%^c%restoreModifiers%
	if (this_process == "Photoshop.exe")
	{
		SetKeyDelay, 20, 20
		SendEvent, {Ctrl down}^c{Ctrl up}
	}
	Else If Class in PuTTY,ConsoleWindowClass,ytWindow
		Send, {ENTER}
	Else
		Send, {Ctrl down}^c{Ctrl up}

	if (this_process == "Photoshop.exe")
	{
		Gui, 99:+ToolWindow
		Gui, 99:Show, x-1000 y-1000 w10 h10
	}

	If clipWaitTime <>
	{
		If copyAsText = 0
			ClipWait, %clipWaitTime%, 1
		Else
			ClipWait, %clipWaitTime%
	}
	Sleep,0

	if (this_process == "Photoshop.exe")
	{
		Sleep,10
		Gui, 99:Destroy
	}

	If copyAsText = 1
		Selection := Clipboard
	Else If copyAsText in Unicode,UTF8,UTF-8
	{
		Transform, Selection, Unicode
		;msgbox, % Ansi2UTF8(UTF82Ansi(Selection)) "`n" Selection
		If (Ansi2UTF8(UTF82Ansi(Selection)) = Selection)
			Selection := Clipboard
	}
	Else
		Selection := ClipboardAll

	If copyOnly = 0
	{
		Sleep, 20
		Clipboard := SavedClipboard
	}
	Sleep,0

	NoOnClipboardChange =

	If copyAsText = 1
		Return Selection
}

func_UnpackSplash( file )
{
	global UnpackSplashStyle
	SplashImage,,%UnpackSplashStyle%, Dateien werden ausgepackt ... / Unpacking files ...`n%file%
	UnpackSplashStyle =
}

func_prepareHotkeyForSend( Hotkey,State="",Blind=1 ) {
	If State <>
		State := " " State

	If Blind = 1
		Prefix = {Blind}
	Else
		Prefix =

	StringLower, Hotkey, Hotkey
	If Hotkey not in $,*,~
	{
		StringReplace Hotkey,Hotkey,$
		StringReplace Hotkey,Hotkey,*
		StringReplace Hotkey,Hotkey,~
	}
	StringReplace Hotkey2,Hotkey,!
	StringReplace Hotkey2,Hotkey2,#
	StringReplace Hotkey2,Hotkey2,^
	StringReplace Hotkey2,Hotkey2,+
	StringLeft, Hotkey, Hotkey, StrLen(Hotkey)-StrLen(Hotkey2)

	If Hotkey2 =
	{
;      If (StrLen(Hotkey . State) = 1)
;         Return Prefix Hotkey State
;      Else
			Return Prefix "{" Hotkey State "}"
	}
	Else
	{
;      If (StrLen(Hotkey2 . State) = 1)
;         Return Prefix Hotkey . Hotkey2 . State
;      Else
			Return Prefix Hotkey "{" Hotkey2 State "}"
	}
}

func_StrLower( String )
{
	StringLower, String, String
	Return String
}

func_Download( URL, File, Splashtext, Title="", Size=0, URL2="", File2="", URL3="", File3="" )
{
	Suspend, On
	SetTimer, tim_Loading, Off
	ToolTip
	SetTimer, tim_UPDATEDSCRIPT, Off

	Setbatchlines, 15
	global DownloadProgressSplashtext,DownloadProgressFile,DownloadProgressFileSize,DownloadProgressTotalSize,DownloadProgressAddSize,DownloadProgressTitle
	DownloadProgressTotalSize = %Size%

	DownloadProgressAddSize = 0
	DownloadProgressSplashtext = %Splashtext%
	DownloadProgressTitle = %Title%
	DownloadProgressFile = %File%
	If Size > 5
		Progress, T M2 FM10 FS10 WM400 WS400 P0 w400, %File%, %DownloadProgressSplashtext%, %Title%
	Else
		SplashImage,, T M2 FS9 W400, %DownloadProgressSplashtext%
	SetTimer, tim_DownloadProgress, 10
	URLDownloadToFile, %URL%?dl=%ScriptVersion%, %File%
	ReturnVal = %ErrorLevel%
	FileRead, test, *m2048 %File%
	If (InStr(test,"<html>") AND InStr(test,"404"))
		ReturnVal++

	If (URL2 <> "" AND File2 <> "")
	{
		If Size > 5
		{
			Progress, T M2 P%DownloadProgressPercentage% FM10 FS10 WM400 WS400 w400, %File2%, %DownloadProgressSplashtext%, %Title%
		}
		DownloadProgressFile = %File2%
		DownloadProgressAddSize = %DownloadProgressFileSize%
		URLDownloadToFile, %URL2%?dl=%ScriptVersion%, %File2%
		ReturnVal := ReturnVal + ErrorLevel
		FileRead, test, *m2048 %File2%
		If (InStr(test,"<html>") AND InStr(test,"404"))
			ReturnVal++
	}
	If (URL3 <> "" AND File3 <> "")
	{
		If Size > 5
		{
			;Progress, Off
			Progress, T M2 P%DownloadProgressPercentage% FM10 FS10 WM400 WS400 w400, %File3%, %DownloadProgressSplashtext%, %Title%
		}
		DownloadProgressFile = %File3%
		DownloadProgressAddSize = %DownloadProgressFileSize%
		URLDownloadToFile, %URL3%?dl=%ScriptVersion%, %File3%
		ReturnVal := ReturnVal + ErrorLevel
		FileRead, test, *m2048 %File3%
		If (InStr(test,"<html>") AND InStr(test,"404"))
			ReturnVal++
	}
	Sleep,50
	SetTimer, tim_DownloadProgress, off
	SplashImage, Off
	Progress, Off
	Return %ReturnVal%
}



func_CheckIfOnline()
{
	Return 1
}

func_AddMessage( Message, SubRoutine )
{
	Global
	if(a_ahkversion >= "1.0.48.00")
		Message := Message+0
	StringReplace, Messages%Message%, Messages%Message%, %SubRoutine%|
	Messages%Message% := Messages%Message% SubRoutine "|"
	OnMessage( Message, "func_CallMessages" )
}

func_RemoveMessage( Message, SubRoutine )
{
	Global
	if(a_ahkversion >= "1.0.48.00")
		Message := Message+0
	StringReplace, Messages%Message%, Messages%Message%, %SubRoutine%|
	If Messages%Message% =
		OnMessage( Message, "" )
	Else
		OnMessage( Message, "func_CallMessages" )
}

func_CallMessages( wParam,lParam, msg, hwnd )
{
	Global
	Loop, Parse, Messages%msg%, |
	{
		If A_LoopField =
			continue
		#wParam = %wParam%
		#lParam = %lParam%
		#msg    = %msg%
		#hwnd   = %hwnd%
		#Return =
		Gosub,%A_LoopField%
		If #Return <>
		{
			Return %#Return%
		}
	}
}

func_IsWindowInIgnoreList?(Window="A")
{
	WinGetClass, Class, %Window%
	If Class in Shell_TrayWnd,Progman,WorkerW,BaseBar,aadScreenShots,DV2ControlHost,SideBar_AppBarWindow
		Return 1
	Else
		Return 0
}
