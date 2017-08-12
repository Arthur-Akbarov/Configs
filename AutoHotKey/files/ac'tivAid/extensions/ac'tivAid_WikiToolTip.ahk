; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               WikiToolTip
; -----------------------------------------------------------------------------
; Prefix:             wtt_
; Version:            0.1
; Date:               2008-05-23
; Author:             Michael Telgkamp
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_WikiToolTip:
	Prefix = wtt
	%Prefix%_ScriptName    = WikiToolTip
	%Prefix%_ScriptVersion = 0.1
	%Prefix%_Author        = Michael Telgkamp
	CustomHotkey_WikiToolTip = 1 ; automatisches benutzerdefinierbares Tastaturkürzel? (1 = ja)
	Hotkey_WikiToolTip = ^+w ; Standard-Hotkey
	HotkeyPrefix_WikiToolTip = $ ; Präfix, welches vor immer vor dem Tastaturkürzel gesetzt wird
	IconFile_On_WikiToolTip = %A_WinDir%\system32\shell32.dll
	IconPos_On_WikiToolTip = 219

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName											= %wtt_ScriptName% - Wikipedia Suche (zeigt ersten Absatz als Tooltip)
		Description										= Zeigt die ersten Absätze von Wikipedia.
		lng_wtt_NothingFound					= Suchbegriff nicht gefunden
		lng_wtt_Error									= Fehler beim Zugriff auf openthesaurus.de.
		lng_wtt_LeoOnMbutton					= Suche automatisch ausführen, wenn ein Wort mit der mittleren Maustaste markiert wird. (MouseClip)
		lng_wtt_Searching							= Suche nach
		lng_wtt_SearchFor							= Bitte Suchbegriff eingeben
		lng_wtt_UseBasicForm					= Verwende Grundform von
		lng_wtt_BasicForm							= Grundform
		lng_wtt_UseDifferentSpelling	= Verwende andere Schreibweise von
		lng_wtt_DifferentSpelling			= Andere Schreibweise
		lng_wtt_ToolTipTimeout				= Sekunden, nach denen der Tooltip automatisch verschwindet
		lng_wtt_CheckProxy						= Prüfen Sie zudem Ihre Proxy-Einstellungen im Internet Explorer.`nWikiToolTip funktioniert nicht bei Proxies mit manueller Anmeldung.`nEvtl. hilft die Aktivierung von "HTTP 1.1 über Proxy-Verbindungen verwenden" in den Internetoptionen unter Erweitert.`nUnter Umständen könnte auch der Server nicht erreichbar sein.
		lng_wtt_Browser								= Browser für Rechtsklick auf ToolTip
		lng_wtt_BrowserError					= Der Browser kann evtl. nicht gestartet werden, Windows meldet:`n
		lng_wtt_SelectBrowser					= Auswählen ...
		lng_wtt_FileTypeEXE						= Programme (*.exe)
		lng_wtt_SelectWordAtCursor		= Wenn kein Text markiert ist, wird automatisch versucht, das Wort am Cursor zu markieren
		lng_wtt_url										= Wikipedia URL
		conf_wtt_url									= http://de.wikipedia.org/wiki/
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName											= %wtt_ScriptName% - synonyms of the selected word
		Description										= Shows synonyms of the selected word as an tooltip via the thesaurus of openthesaurus.de. This works only for the german language.
		lng_wtt_NothingFound					= search item not found
		lng_wtt_Error									= Error while accessing openthesaurus.de.
		lng_wtt_LeoOnMbutton					= Search automatically when selecting a word with the middle mouse-button. (MouseClip)
		lng_wtt_Searching							= Connecting to
		lng_wtt_SearchFor							= Please enter search item
		lng_wtt_UseBasicForm					= Using basic form of
		lng_wtt_BasicForm							= Basic form
		lng_wtt_UseDifferentSpelling	= Using different case of
		lng_wtt_DifferentSpelling			= Different case
		lng_wtt_ToolTipTimeout				= Seconds, when the tooltip automatically disappears
		lng_wtt_CheckProxy						= Check also your proxy settings in Internet Explorer,`nWikiToolTip does not work at proxies with manual authentification.`nAlso the server could be down at the moment.
		lng_wtt_Browser								= Browser for right-click on tooltip
		lng_wtt_BrowserError					= Maybe the browser can't be launched, windows returns:`n
		lng_wtt_SelectBrowser					= Choose...
		lng_wtt_FileTypeEXE						= Programs (*.exe)
		lng_wtt_SelectWordAtCursor		= Try to select the word at the cursor position, if no text is selected
		lng_wtt_URL										= Wikipedia URL
		conf_wtt_url									= http://en.wikipedia.org/wiki/
	}

	IniRead, wtt_EnableMButton, %ConfigFile%, WikiToolTip, LeoOnMButton, 0
	IniRead, wtt_ToolTipTimeout, %ConfigFile%, WikiToolTip, ToolTipTimeout, 10
	IniRead, wtt_Browser, %ConfigFile%, WikiToolTip, Browser, %A_Space%
	IniRead, wtt_url, %ConfigFile%, WikiToolTip, URL, %conf_wtt_url%

	RegisterAdditionalSetting( "wtt", "SelectWordAtCursor", 0 )

	wtt_WebBrowsers = OpWindow,MozillaUIWindowClass,IEFrame
	wtt_SearchCache = |
Return

SettingsGui_WikiToolTip:
	If Enable_MouseClip = 1
		Gui, Add, Checkbox, -Wrap xs+10 y+5 gwtt_sub_MouseClip vwtt_EnableMButton Checked%wtt_EnableMButton%, %lng_wtt_LeoOnMbutton%
	Gui, Add, Text, xs+10 y+20, %lng_wtt_URL%:
	Gui, Add, Edit, R1 x+5 yp-3 -Wrap w290 gsub_CheckIfSettingsChanged vwtt_URL, %wtt_URL%
	Gui, Add, Text, xs+10 y+16, %lng_wtt_ToolTipTimeout%:
	Gui, Add, Edit, x+5 yp-3 -Wrap r1 Number w40 gsub_CheckIfSettingsChanged vwtt_ToolTipTimeout, %wtt_ToolTipTimeout%
	Gui, Add, UpDown, Range1-99, %wtt_ToolTipTimeout%
	Gui, Add, Text, xs+10 y+20, %lng_wtt_Browser%:
	Gui, Add, Edit, R1 x+5 yp-3 -Wrap w290 gsub_CheckIfSettingsChanged vwtt_Browser, %wtt_Browser%
	Gui, Add, Button, x+5 -Wrap w80 h21 gwtt_sub_SelectBrowser, %lng_wtt_SelectBrowser%
Return

wtt_sub_SelectBrowser:
	Gui, +OwnDialogs
	wtt_Suspended = %A_IsSuspended%
	If wtt_Suspended = 0
		Suspend, On

	FileSelectFile, wtt_Browser_tmp,, %A_Programfiles%, %lng_wtt_Browser%, %lng_wtt_FileTypeEXE%
	If ErrorLevel = 0
		GuiControl,, wtt_Browser, %wtt_Browser_tmp%

	If wtt_Suspended = 0
		Suspend, Off
Return

wtt_sub_MouseClip:
	Gosub, sub_CheckIfSettingsChanged
	GuiControlGet, wtt_EnableMButton_tmp,,wtt_EnableMButton
	If (wtt_EnableMButton_tmp = 1 AND Enable_LeoToolTip <> "")
		GuiControl,,wtt_EnableMButton,0
Return

SaveSettings_WikiToolTip:
	IniWrite, %wtt_EnableMButton%, %ConfigFile%, WikiToolTip, LeoOnMButton
	IniWrite, %wtt_ToolTipTimeout%, %ConfigFile%, WikiToolTip, ToolTipTimeout
	IniWrite, %wtt_Browser%, %ConfigFile%, WikiToolTip, Browser
	IniWrite, %wtt_URL%, %ConfigFile%, WikiToolTip, URL
Return

AddSettings_WikiToolTip:
Return

CancelSettings_WikiToolTip:
Return

DoEnable_WikiToolTip:
	If wtt_EnableMButton
		RegisterHook( "MButton", "WikiToolTip" )
	EnableMButton_WikiToolTip = %wtt_EnableMButton%
Return

DoDisable_WikiToolTip:
	wtt_BreakLoop = 1
	If wtt_EnableMButton
		UnRegisterHook( "MButton", "WikiToolTip" )
	EnableMButton_WikiToolTip = %wtt_EnableMButton%
Return

DefaultSettings_WikiToolTip:
Return

OnExitAndReload_WikiToolTip:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_WikiToolTip:
	WinGetClass, wtt_WinClass, A
	CoordMode, Caret, Screen

	If wtt_WinClass Contains %wtt_WebBrowsers%
	{
		wtt_ttX =
		wtt_ttY =
	}
	Else
	{
		wtt_ttX := A_CaretX+10
		wtt_ttY := A_CaretY+10
	}
	gosub, wtt_sub_Search
	SetTimer, wtt_tim_ToolTipOff, % wtt_ToolTipTimeout * 1000
	wtt_BreakLoop =
	Loop
	{
		Input, wtt_SingleKey, L1 I V T0.5, {AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}
		If wtt_BreakLoop = 1
			Break
		If ErrorLevel = TimeOut
			Continue
		Break
	}
	Gosub, wtt_tim_ToolTipOff
Return

MButton_WikiToolTip:
	If (wtt_EnableMButton = 1 AND Enable_MouseClip = 1)
	{
		mc_NoPaste = yes
		wtt_ttX =
		wtt_ttY =
		gosub, wtt_sub_Search
	}
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------


wtt_sub_Search:
	AutoTrim, On
	Coordmode, ToolTip, Screen

	func_GetSelection()
	wtt_searchOrig := Selection
	If (wtt_SelectWordAtCursor = 1 AND wtt_searchOrig = "")
	{
		Send, ^{Left}^+{Right}
		func_GetSelection()
		wtt_searchOrig :=  Selection
	}

	If wtt_searchOrig =
	{
		InputBox, wtt_searchOrig, %wtt_ScriptName% (%ScriptTitle%), %lng_wtt_SearchFor%:,,,115,,,,,%wtt_LastSearchOrig%
		If ErrorLevel = 1
			Return
	}

	wtt_searchFor := func_URLEncode(Ansi2UTF8(wtt_searchOrig))

	tooltip, , , , 8

	wtt_Temp := InStr(wtt_SearchCache, "|" wtt_searchFor "|")
	If wtt_Temp
	{
		wtt_LastLangStr = %wtt_LangStr%
		wtt_lastSearch  = %wtt_searchFor%
		wtt_FinalResult := wtt_ResultCache[%wtt_Temp%]
	}

	StringCaseSense, On
	If ( ( wtt_searchFor <> wtt_lastSearch AND wtt_searchFor <> "" ) OR (wtt_lastSearch = "" AND wtt_searchFor ="") )
	{
		StringCaseSense, Off
		tooltip, %lng_wtt_Searching% %wtt_searchOrig% ..., %wtt_ttX%, %wtt_ttY%, 8
		sleep,100
		URLDownloadToFile, % wtt_url wtt_searchFor "?printable=yes", %A_Temp%\wttahk.tmp
		FileRead, wtt_Result, %A_Temp%\wttahk.tmp
		FileDelete, %A_Temp%\wttahk.tmp

		; // TODO: Test nach Begriffsklärung "Unterscheidung"

		; snip all paragraphs
		StringGetPos, wtt_begin, wtt_Result, <p>
		if ( wtt_paragraphAvailable := ( wtt_begin > 0 ) )
		{
			wtt_nextParagraph := wtt_begin
			while wtt_paragraphAvailable
			{
				if(wtt_nextParagraph>0)
				{
					wtt_currentParagraph := wtt_nextParagraph
				}
				StringGetPos, wtt_end, wtt_Result, </p>,,%wtt_currentParagraph%
				StringGetPos, wtt_nextParagraph, wtt_Result, <p>,,%wtt_end%
				wtt_paragraphAvailable := (wtt_nextParagraph >0 && (wtt_nextParagraph - wtt_end) < 10)
			}
		}
		wtt_length := ( wtt_end - wtt_begin ) + 1
		If (not (wtt_begin = -1 OR wtt_end = -1))
		{
			wtt_Result = %wtt_Result%
			wtt_Result := wtt_addLinebreaks(func_Html2Ansi(UTF82Ansi(substr(wtt_Result, wtt_begin, wtt_length ))))
		}
	}
; TODO remove unneeded stuff

	If wtt_Result =
		wtt_FinalResult = %lng_wtt_NothingFound%!`n%lng_wtt_CheckProxy%
	else
	{
		wtt_FinalResult := lng_wtt_Searching " " wtt_searchOrig ":`n" wtt_Result "`n© Wikipedia " wtt_url
	}

	wtt_FinalResult := RegExReplace(wtt_FinalResult, "\R\R+","`n`n")

	StringCaseSense, Off

	wtt_Temp := StrLen(wtt_SearchCache)
	wtt_SearchCache = %wtt_SearchCache%%wtt_searchFor%|
	wtt_ResultCache[%wtt_Temp%] = %wtt_FinalResult%

	wtt_lastSearch = %wtt_searchFor%
	wtt_lastSearchOrig = %wtt_searchOrig%
	MouseGetPos, wtt_startX, wtt_startY
	tooltip, %wtt_FinalResult%, %wtt_ttX%, %wtt_ttY%, 8
	SetTimer, wtt_tim_WatchToolTip, 20
Return

wtt_tim_ToolTipOff:
	RButton_tip =
	wtt_BreakLoop = 1
	SetTimer, wtt_tim_ToolTipOff, Off
	tooltip,,,, 8
	SetTimer, wtt_tim_WatchToolTip, Off
Return

wtt_tim_WatchToolTip:
	MouseGetPos, wtt_X, wtt_Y, wtt_WinID
	If wtt_startX <>
	{
		If (wtt_X > wtt_StartX+4 OR wtt_Y > wtt_StartY+4 OR wtt_X < wtt_StartX-4 OR wtt_Y < wtt_StartY-4)
		{
			wtt_startX =
			SetTimer, wtt_tim_ToolTipOff, 2000
		}
	}
	WinGetTitle, wtt_TipText, ahk_id %wtt_WinID%
	If wtt_TipText = %wtt_FinalResult%
	{
		GetKeyState, wtt_LButton, LButton
		GetKeyState, wtt_RButton, RButton
		If wtt_LButton = D
			Gosub, wtt_tim_ToolTipOff
		Else If (wtt_RButton = "D" OR OR RButton_tip = "yes")
		{
			If wtt_Browser =
				Run, % wtt_url wtt_searchFor, UseErrorLevel
			Else
				Run, % func_Deref(wtt_Browser) " " wtt_url wtt_searchFor ,, UseErrorLevel
			If ErrorLevel = ERROR
				func_GetErrorMessage( A_LastError, wtt_ScriptName, lng_wtt_BrowserError  )
			Gosub, wtt_tim_ToolTipOff
		}
		Else
			SetTimer, wtt_tim_ToolTipOff, 1000
	}
	GetKeyState, wtt_ESC, ESC
	If wtt_ESC = D
		SetTimer, wtt_tim_ToolTipOff, 1
Return

wtt_addLinebreaks( wtt_string, lineLength=90 ) {
	currentPosition := 1
	length := strlen(wtt_string)
	loop, 1000
	{
;		msgbox, % length " - " currentPosition "=" (length - currentPosition) " < " lineLength
		if ( length-currentPosition < lineLength )
		{
			break
		}
		StringGetPos, wtt_linebreak, wtt_string, `n, , currentPosition
		if ( wtt_linebreak > 0 && wtt_linebreak-currentPosition < lineLength)
		{
			currentPosition := wtt_linebreak+1
		}
		else
		{
			wtt_rightPos := length - (currentPosition + lineLength)
			
			StringGetPos, wtt_splitpos, wtt_string, % " ", R, %wtt_rightPos%
			if ( wtt_splitpos = -1 )
				wtt_splitpos := currentPosition+lineLength
			
			wtt_string := substr(wtt_string, 1, wtt_splitpos) "`n" substr(wtt_string, wtt_splitpos+2)
			currentPosition := wtt_splitpos+1
		}
	}
	return wtt_string
}
