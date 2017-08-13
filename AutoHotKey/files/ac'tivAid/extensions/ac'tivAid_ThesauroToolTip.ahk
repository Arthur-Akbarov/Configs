; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               ThesauroToolTip
; -----------------------------------------------------------------------------
; Prefix:             ttt_
; Version:            0.9.3
; Date:               2008-05-23
; Author:             Michael Telgkamp, Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_ThesauroToolTip:
	Prefix = ttt
	%Prefix%_ScriptName    = ThesauroToolTip
	%Prefix%_ScriptVersion = 0.9.3
	%Prefix%_Author        = Michael Telgkamp, Wolfgang Reszel
	CustomHotkey_ThesauroToolTip = 1           ; automatisches benutzerdefinierbares Tastaturkürzel? (1 = ja)
	Hotkey_ThesauroToolTip       = ^+t         ; Standard-Hotkey
	HotkeyPrefix_ThesauroToolTip = $           ; Präfix, welches vor immer vor dem Tastaturkürzel gesetzt wird
	IconFile_On_ThesauroToolTip  = %A_WinDir%\system32\shell32.dll
	IconPos_On_ThesauroToolTip   = 219

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName											= %ttt_ScriptName% - Synonyme vom markierten Wort
		Description										= Zeigt mittels des Thesaurus von openthesaurus.de Synonyme für das markierte Wort als Tooltip an.
		lng_ttt_NothingFound					= Suchbegriff nicht gefunden
		lng_ttt_AlwaysShowSimilar			= Ähnliche Begriffe immer zeigen
		lng_ttt_Similar								= Ähnliche Begriffe
		lng_ttt_lineLength						= Zeilenlänge im ToolTip
		lng_ttt_Error									= Fehler beim Zugriff auf openthesaurus.de.
		lng_ttt_LeoOnMbutton					= Suche automatisch ausführen, wenn ein Wort mit der mittleren Maustaste markiert wird. (MouseClip)
		lng_ttt_Searching							= Verbinde mit
		lng_ttt_SearchFor							= Bitte Suchbegriff eingeben
		lng_ttt_UseBasicForm					= Verwende Grundform von
		lng_ttt_BasicForm							= Grundform
		lng_ttt_UseDifferentSpelling	= Verwende andere Schreibweise von
		lng_ttt_DifferentSpelling			= Andere Schreibweise
		lng_ttt_ToolTipTimeout				= Sekunden, nach denen der Tooltip automatisch verschwindet
		lng_ttt_CheckProxy						= Prüfen Sie zudem Ihre Proxy-Einstellungen im Internet Explorer.`nThesauroToolTip funktioniert nicht bei Proxies mit manueller Anmeldung.`nEvtl. hilft die Aktivierung von "HTTP 1.1 über Proxy-Verbindungen verwenden" in den Internetoptionen unter Erweitert.`nUnter Umständen könnte auch der Server nicht erreichbar sein.
		lng_ttt_Browser								= Browser für Rechtsklick auf ToolTip
		lng_ttt_BrowserError					= Der Browser kann evtl. nicht gestartet werden, Windows meldet:`n
		lng_ttt_SelectBrowser					= Auswählen ...
		lng_ttt_FileTypeEXE						= Programme (*.exe)
		lng_ttt_SelectWordAtCursor		= Wenn kein Text markiert ist, wird automatisch versucht, das Wort am Cursor zu markieren
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName											= %ttt_ScriptName% - synonyms of the selected word
		Description										= Shows synonyms of the selected word as an tooltip via the thesaurus of openthesaurus.de. This works only for the german language.
		lng_ttt_NothingFound					= search item not found
		lng_ttt_Similar 							= similar words
		lng_ttt_AlwaysShowSimilar			= Always show similar words
		lng_ttt_lineLength						= Row length in tooltip
		lng_ttt_Error									= Error while accessing openthesaurus.de.
		lng_ttt_LeoOnMbutton					= Search automatically when selecting a word with the middle mouse-button. (MouseClip)
		lng_ttt_Searching							= Connecting to
		lng_ttt_SearchFor							= Please enter search item
		lng_ttt_UseBasicForm					= Using basic form of
		lng_ttt_BasicForm							= Basic form
		lng_ttt_UseDifferentSpelling	= Using different case of
		lng_ttt_DifferentSpelling			= Different case
		lng_ttt_ToolTipTimeout				= Seconds, when the tooltip automatically disappears
		lng_ttt_CheckProxy						= Check also your proxy settings in Internet Explorer,`nThesauroToolTip does not work at proxies with manual authentification.`nAlso the server could be down at the moment.
		lng_ttt_Browser								= Browser for right-click on tooltip
		lng_ttt_BrowserError					= Maybe the browser can't be launched, windows returns:`n
		lng_ttt_SelectBrowser					= Choose...
		lng_ttt_FileTypeEXE						= Programs (*.exe)
		lng_ttt_SelectWordAtCursor		= Try to select the word at the cursor position, if no text is selected
	}

	IniRead, ttt_EnableMButton, %ConfigFile%, ThesauroToolTip, LeoOnMButton, 0
	IniRead, ttt_ToolTipTimeout, %ConfigFile%, ThesauroToolTip, ToolTipTimeout, 10
	IniRead, ttt_Browser, %ConfigFile%, ThesauroToolTip, Browser, %A_Space%
	IniRead, ttt_linelength, %ConfigFile%, ThesauroToolTip, LineLength, 100
	IniRead, ttt_alwaysShowSimilar, %ConfigFile%, ThesauroToolTip, AlwaysShowSimilar, 0

	RegisterAdditionalSetting( "ttt", "SelectWordAtCursor", 0 )

	ttt_WebBrowsers = OpWindow,MozillaUIWindowClass,IEFrame
	ttt_SearchCache = |
Return

SettingsGui_ThesauroToolTip:
	If Enable_MouseClip = 1
		Gui, Add, Checkbox, -Wrap xs+10 y+5 gttt_sub_MouseClip vttt_EnableMButton Checked%ttt_EnableMButton%, %lng_ttt_LeoOnMbutton%
	Gui, Add, Text, xs+10 y+16, %lng_ttt_ToolTipTimeout%:
	Gui, Add, Edit, x+5 yp-3 -Wrap r1 Number w40 gsub_CheckIfSettingsChanged vttt_ToolTipTimeout, %ttt_ToolTipTimeout%
	Gui, Add, UpDown, Range1-99, %ttt_ToolTipTimeout%
	Gui, Add, Text, xs+10 y+20 w175, %lng_ttt_Browser%:
	Gui, Add, Edit, R1 x+5 yp-3 -Wrap w290 gsub_CheckIfSettingsChanged vttt_Browser, %ttt_Browser%
	Gui, Add, Button, x+5 -Wrap w80 h21 gttt_sub_SelectBrowser, %lng_ttt_SelectBrowser%
	Gui, Add, Text, xs+10 y+20 w175, %lng_ttt_lineLength%:
	Gui, Add, Edit, R1 x+5 yp-3 -Wrap w50 gsub_CheckIfSettingsChanged vttt_linelength, %ttt_linelength%
	Gui, Add, Text, xs+10 y+20 w175, %lng_ttt_alwaysShowSimilar%:
	Gui, Add, Checkbox, -Wrap x+5  gsub_CheckIfSettingsChanged vttt_alwaysShowSimilar Checked%ttt_alwaysShowSimilar%,
Return

ttt_sub_SelectBrowser:
	Gui, +OwnDialogs
	ttt_Suspended = %A_IsSuspended%
	If ttt_Suspended = 0
		Suspend, On

	FileSelectFile, ttt_Browser_tmp,, %A_Programfiles%, %lng_ttt_Browser%, %lng_ttt_FileTypeEXE%
	If ErrorLevel = 0
		GuiControl,, ttt_Browser, %ttt_Browser_tmp%

	If ttt_Suspended = 0
		Suspend, Off
Return

ttt_sub_MouseClip:
	Gosub, sub_CheckIfSettingsChanged
	GuiControlGet, ttt_EnableMButton_tmp,,ttt_EnableMButton
	If (ttt_EnableMButton_tmp = 1 AND Enable_LeoToolTip <> "")
		GuiControl,,ttt_EnableMButton,0
Return

SaveSettings_ThesauroToolTip:
	IniWrite, %ttt_EnableMButton%, %ConfigFile%, ThesauroToolTip, LeoOnMButton
	IniWrite, %ttt_ToolTipTimeout%, %ConfigFile%, ThesauroToolTip, ToolTipTimeout
	IniWrite, %ttt_Browser%, %ConfigFile%, ThesauroToolTip, Browser
	IniWrite, %ttt_linelength%, %ConfigFile%, ThesauroToolTip, LineLength
	IniWrite, %ttt_alwaysShowSimilar%, %ConfigFile%, ThesauroToolTip, AlwaysShowSimilar
Return

AddSettings_ThesauroToolTip:
Return

CancelSettings_ThesauroToolTip:
Return

DoEnable_ThesauroToolTip:
	If ttt_EnableMButton
		RegisterHook( "MButton", "ThesauroToolTip" )
	EnableMButton_ThesauroToolTip = %ttt_EnableMButton%
Return

DoDisable_ThesauroToolTip:
	ttt_BreakLoop = 1
	If ttt_EnableMButton
		UnRegisterHook( "MButton", "ThesauroToolTip" )
	EnableMButton_ThesauroToolTip = %ttt_EnableMButton%
Return

DefaultSettings_ThesauroToolTip:
Return

OnExitAndReload_ThesauroToolTip:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_ThesauroToolTip:
	WinGetClass, ttt_WinClass, A
	CoordMode, Caret, Screen

	If ttt_WinClass Contains %ttt_WebBrowsers%
	{
		ttt_ttX =
		ttt_ttY =
	}
	Else
	{
		ttt_ttX := A_CaretX+10
		ttt_ttY := A_CaretY+10
	}
	gosub, ttt_sub_Search
	SetTimer, ttt_tim_ToolTipOff, % ttt_ToolTipTimeout * 1000
	ttt_BreakLoop =
	Loop
	{
		Input, ttt_SingleKey, L1 I V T0.5, {AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}
		If ttt_BreakLoop = 1
			Break
		If ErrorLevel = TimeOut
			Continue
		Break
	}
	Gosub, ttt_tim_ToolTipOff
Return

MButton_ThesauroToolTip:
	If (ttt_EnableMButton = 1 AND Enable_MouseClip = 1)
	{
		mc_NoPaste = yes
		ttt_ttX =
		ttt_ttY =
		gosub, ttt_sub_Search
	}
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------


ttt_sub_Search:
	AutoTrim, On
	Coordmode, ToolTip, Screen

	func_GetSelection()
	ttt_searchOrig := Selection
	If (ttt_SelectWordAtCursor = 1 AND ttt_searchOrig = "")
	{
		Send, ^{Left}^+{Right}
		func_GetSelection()
		ttt_searchOrig :=  Selection
	}

	If ttt_searchOrig =
	{
		InputBox, ttt_searchOrig, %ttt_ScriptName% (%ScriptTitle%), %lng_ttt_SearchFor%:,,,115,,,,,%ttt_LastSearchOrig%
		If ErrorLevel = 1
			Return
	}

	ttt_searchFor := func_URLEncode(Ansi2UTF8(ttt_searchOrig))

	tooltip, , , , 8

	ttt_Temp := InStr(ttt_SearchCache, "|" ttt_searchFor "|")
	If ttt_Temp
	{
		ttt_LastLangStr = %ttt_LangStr%
		ttt_lastSearch  = %ttt_searchFor%
		ttt_FinalResult := ttt_ResultCache[%ttt_Temp%]
	}

	StringCaseSense, On
	If ( ( ttt_searchFor <> ttt_lastSearch AND ttt_searchFor <> "" ) OR (ttt_lastSearch = "" AND ttt_searchFor ="") )
	{
		StringCaseSense, Off
		tooltip, %lng_ttt_Searching% openthesaurus.de ..., %ttt_ttX%, %ttt_ttY%, 8
		ttt_XML := httpQUERY(URL:="http://www.openthesaurus.de/synonyme/search?mode=all&q=" ttt_searchFor "&format=text/xml")

		StringReplace, ttt_XML, ttt_XML, &#xc4;, Ä, All
		StringReplace, ttt_XML, ttt_XML, &#xd4;, Ö, All
		StringReplace, ttt_XML, ttt_XML, &#xdc;, Ü, All
		StringReplace, ttt_XML, ttt_XML, &#xdf;, ß, All
		StringReplace, ttt_XML, ttt_XML, &#xe4;, ä, All
		StringReplace, ttt_XML, ttt_XML, &#xf6;, ö, All
		StringReplace, ttt_XML, ttt_XML, &#xfc;, ü, All

		ttt_FinalResult := ttt_searchOrig ":"
		ttt_FinalResult := ttt_FinalResult ttt_func_findTerms(ttt_XML,"synset")
		if(!ttt_resultcount) {
			ttt_FinalResult := ttt_FinalResult " " lng_ttt_NothingFound
		}
		if(!ttt_resultcount || ttt_alwaysShowSimilar) {
			ttt_FinalResult := ttt_FinalResult "`n`n" lng_ttt_Similar ":`n" ttt_func_findTerms(ttt_XML,"similarterms")
		}
		if (!ttt_resultcount) {
			ttt_FinalResult := lng_ttt_NothingFound
		}
	}
	Else
		ttt_searchFor = %ttt_lastSearch%

	StringCaseSense, Off

	ttt_Temp := StrLen(ttt_SearchCache)
	ttt_SearchCache = %ttt_SearchCache%%ttt_searchFor%|
	ttt_ResultCache[%ttt_Temp%] = %ttt_FinalResult%

	ttt_lastSearch = %ttt_searchFor%
	ttt_lastSearchOrig = %ttt_searchOrig%
	MouseGetPos, ttt_startX, ttt_startY
	tooltip, %ttt_FinalResult%, %ttt_ttX%, %ttt_ttY%, 8
	SetTimer, ttt_tim_WatchToolTip, 20
Return

ttt_tim_ToolTipOff:
	RButton_tip =
	ttt_BreakLoop = 1
	SetTimer, ttt_tim_ToolTipOff, Off
	tooltip,,,, 8
	SetTimer, ttt_tim_WatchToolTip, Off
Return

ttt_tim_WatchToolTip:
	MouseGetPos, ttt_X, ttt_Y, ttt_WinID
	If ttt_startX <>
	{
		If (ttt_X > ttt_StartX+4 OR ttt_Y > ttt_StartY+4 OR ttt_X < ttt_StartX-4 OR ttt_Y < ttt_StartY-4)
		{
			ttt_startX =
			SetTimer, ttt_tim_ToolTipOff, 2000
		}
	}
	WinGetTitle, ttt_TipText, ahk_id %ttt_WinID%
	If ttt_TipText = %ttt_FinalResult%
	{
		GetKeyState, ttt_LButton, LButton
		GetKeyState, ttt_RButton, RButton
		If ttt_LButton = D
			Gosub, ttt_tim_ToolTipOff
		Else If (ttt_RButton = "D" OR OR RButton_tip = "yes")
		{
			If ttt_Browser =
				Run, http://www.openthesaurus.de/synonyme/search?q=%ttt_searchFor%, UseErrorLevel
			Else
				Run, % func_Deref(ttt_Browser) " http://www.openthesaurus.de/synonyme/search?q=" ttt_searchFor ,, UseErrorLevel
			If ErrorLevel = ERROR
				func_GetErrorMessage( A_LastError, ttt_ScriptName, lng_ttt_BrowserError  )
			Gosub, ttt_tim_ToolTipOff
		}
		Else
			SetTimer, ttt_tim_ToolTipOff, 1000
	}
	GetKeyState, ttt_ESC, ESC
	If ttt_ESC = D
		SetTimer, ttt_tim_ToolTipOff, 1
Return

ttt_func_findTerms(ttt_content,ttt_category)
{
	global ttt_resultcount, ttt_linelength
	ttt_resultcount := 0
	ttt_returnValue=
	ttt_content := regexreplace(ttt_content, ".*?(<" ttt_category ".*)</" ttt_category ".*", "$1", ttt_replaceCount)
	if ( ttt_replaceCount == 0 )
	{
		return ""
	}
	StringReplace, ttt_content, ttt_content, <%ttt_category%, ¢, All
	loop,parse,ttt_content,¢
	{
		ttt_wordcount:=0
		StringReplace, ttt_contentpart, A_LoopField, <term, ¢, All
		loop,parse,ttt_contentpart,¢
		{
			if(instr(a_loopfield,"<categories>"))
			{
				ttt_separator := "`n - "
			} else if( instr(a_loopfield,"term=") ) {
				ttt_resultcount++
				ttt_wordcount++
				if(strlen(ttt_currentLine ttt_separator ttt_synonym) > ttt_linelength)
				{
					ttt_returnValue := ttt_returnValue ttt_currentLine
					ttt_currentLine := ""
					ttt_separator := "`n    "
				}
				ttt_synonym := regexreplace(a_loopfield,".*term='(.+?)'.*","$1")
				ttt_currentLine := ttt_currentLine ttt_separator ttt_synonym
				ttt_separator := " • "
			}
		}
		ttt_returnValue := ttt_returnValue ttt_currentLine
		ttt_currentLine := ""
	}
	return ttt_returnValue
}