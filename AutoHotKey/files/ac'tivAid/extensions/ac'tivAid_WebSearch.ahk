; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               WebSearch
; -----------------------------------------------------------------------------
; Prefix:             ws_
; Version:            1.8
; Date:               2008-05-23
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_WebSearch:
	Prefix = ws
	%Prefix%_ScriptName    = WebSearch
	%Prefix%_ScriptVersion = 1.8
	%Prefix%_ScriptTitle   = %ws_ScriptName% v%ws_ScriptVersion%
	%Prefix%_Author        = Wolfgang Reszel

	CustomHotkey_WebSearch = 1
	Hotkey_WebSearch       = #w
	AddSettings_WebSearch  = 1

	HotkeyClasses_ws_Hotkey = ,

	ws_IconPath = settings\%ws_ScriptName%

	IconFile_On_WebSearch = %A_WinDir%\system32\shell32.dll
	IconPos_On_WebSearch = 14

	CreateGuiID("WebSearch")
	CreateGuiID("WebSearchBrowser")
	CreateGuiID("WebSearchCenter")

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %ws_ScriptName% - Internet-Recherche
		Description                   = Schnelle Internet-Recherche über frei definierbare Tastaturkürzel.
		lng_ws_WebRecherche           = Internet&-Recherche für:
		lng_ws_EntryName              = Menüname: (&& für Alt-Kürzel):
		lng_ws_EntryURL               = URL: (### = Platzhalter für gesamten Suchbegriff, ##n## = Platzhalter für Wort n)
		lng_ws_Encoding               = Umlaute und Sonderzeichen kodieren:
		lng_ws_URLencode              = URL (ö > `%F6)
		lng_ws_Unicode                = Unicode
		lng_ws_NoEncode               = nein
		lng_ws_MenuBrowser            = &Browser auswählen ...
		lng_ws_Browser                = Welcher Browser soll für die aktuell sichtbare Suchmaschine verwendet werden? (z.B. ob1.exe)`nWird hier nichts angegeben, wird der Standardbrowser verwendet.
		lng_ws_SelectBrowser          = Bitte einen Browser auswählen
		lng_ws_FileTypeEXE            = Programme (*.exe)
		lng_ws_Hotkey                 = Direktes Tastaturkürzel
		lng_ws_ConfigEntries          = Suchmaschinen
		lng_ws_CenterApps             = Fensterposition ...
		lng_ws_Apps                   = WebSearch am Cursor positionieren und bei folgenden Anwendungen zentrieren`n(Teil der Fensternamen, durch Komma getrennt angeben):
		lng_ws_CenterAll              = WebSearch immer zentrieren
		lng_ws_RememberPos            = WebSearch-Position merken
	  lng_ws_OnMouseCursor          = WebSearch an Mauszeiger platzieren
		lng_ws_GetIcon                = Icon ermitteln
		lng_ws_SearchAll              = Alle markierten Suchmaschinen durchsuchen
		lng_ws_NoIcon                 = Kein Favicon gefunden!
		lng_ws_New                    = (neu)
		lng_ws_BrowserForAll          = Browser für alle Suchmaschinen festlegen
		lng_ws_deactivate             = Deaktiviert
		lng_ws_ReplaceSpaces          = Leerzeichen ersetzen durch
		lng_ws_UseHistory             = Eingegebene Suchbegriffe im Verlauf speichern
		lng_ws_EmptyHistory           = Verlauf löschen
		lng_ws_AskEmptyHistory        = Soll der Verlauf wirklich gelöscht werden?
	}
	else        ; = other languages (english)
	{
		MenuName                      = %ws_ScriptName% - web-search
		Description                   = Fast web-search with hotkeys.
		lng_ws_WebRecherche           = Web&-search for:
		lng_ws_EntryName              = Menu name: (&& for Alt-shortcut):
		lng_ws_EntryURL               = URL: (### = whole search-term, ##n## = search-word no. n)
		lng_ws_Encoding               = Encode umlauts and special chars:
		lng_ws_URLencode              = URL (ö > `%F6)
		lng_ws_Unicode                = Unicode
		lng_ws_NoEncode               = No
		lng_ws_MenuBrowser            = &Choose Browser ...
		lng_ws_Browser                = Which browser should handle the search? (eg. ob1.exe)`nLeave empty to use the standard-browser.
		lng_ws_SelectBrowser          = Please select a Browser ...
		lng_ws_FileTypeEXE            = Programs (*.exe)
		lng_ws_Hotkey                 = Direct Hotkey
		lng_ws_ConfigEntries          = Search-engines
		lng_ws_CenterApps             = Window options ...
		lng_ws_Apps                   = Position WebSearch at the cursor and centre it in the following applications.`n(Use comma-separated substrings of the windows-tilte):
		lng_ws_CenterAll              = Always centre WebSearch
		lng_ws_RememberPos            = Remember position
	  lng_ws_OnMouseCursor          = Place at mouse cursor
		lng_ws_GetIcon                = Get Icon
		lng_ws_SearchAll              = Search all marked search-engines
		lng_ws_NoIcon                 = No favicon found!
		lng_ws_New                    = (new)
		lng_ws_BrowserForAll          = Set browser for all search-engines
		lng_ws_deactivate             = Deactivated
		lng_ws_ReplaceSpaces          = Replace spaces with
		lng_ws_UseHistory             = Store search entries in history
		lng_ws_EmptyHistory           = Empty history
		lng_ws_AskEmptyHistory        = Do you really want to empty the history?
	}
	If CustomLanguage <>
		gosub, CustomLanguage

	ws_SpaceReplacer = {Space},`%20,+

	ws_Name[1] =
	ws_ItemNr = 1
	ws_Items = 0

	Loop
	{
		IniRead, ws_Name[%A_Index%]   , %ConfigFile%, %ws_ScriptName%, Name%A_Index%
		If (ws_Name[%A_Index%] = "" OR ws_Name[%A_Index%] = "ERROR")
		{
			ws_Name[%A_Index%] =
			break
		}
		IniRead, ws_URL[%A_Index%]    , %ConfigFile%, %ws_ScriptName%, URL%A_Index%
		IniRead, ws_Encode[%A_Index%] , %ConfigFile%, %ws_ScriptName%, Encode%A_Index%
		IniRead, Hotkey_WebSearch[%A_Index%] , %ConfigFile%, %ws_ScriptName%, Hotkey%A_Index%
		IniRead, ws_Browser[%A_Index%], %ConfigFile%, %ws_ScriptName%, Browser%A_Index%
		IniRead, ws_Deactivate[%A_Index%], %ConfigFile%, %ws_ScriptName%, Deactivate%A_Index%, 0
		IniRead, ws_ReplaceSpaces[%A_Index%], %ConfigFile%, %ws_ScriptName%, ReplaceSpaces%A_Index%, `%20
		If ws_Deactivate[%A_Index%] =
			ws_Deactivate[%A_Index%] = 0
		ws_Items = %A_Index%
	}

	If ws_Items = 0
	{
		if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
		{
			ws_Items     = 7
			ws_Name[1]   = &LEO
			ws_URL[1]    = http://dict.leo.org/?lp=ende&lang=de&searchLoc=0&cmpType=relaxed&relink=on&sectHdr=on&spellToler=std&search=###
			ws_Encode[1] = URL
			Hotkey_WebSearch[1]=  #+L
			ws_Browser[1]=
			ws_Deactivate[1]=0
			ws_ReplaceSpaces[1]=`%20
			ws_Name[2]   = &Google
			ws_URL[2]    = http://www.google.com/search?rls=de-de&q=###&ie=UTF-8
			ws_Encode[2] = Unicode
			Hotkey_WebSearch[2] = #+G
			ws_Browser[2]=
			ws_Deactivate[2]=0
			ws_ReplaceSpaces[2]=`%20
			ws_Name[3]   = &Wikipedia
			ws_URL[3]    = http://de.wikipedia.org/wiki/Spezial:Search?search=###
			ws_Encode[3] =
			Hotkey_WebSearch[3] = #+W
			ws_Browser[3]=
			ws_Deactivate[3]=0
			ws_ReplaceSpaces[3]=`%20
			ws_Name[4]   = &Heise-Newsticker
			ws_URL[4]    = http://www.heise.de/newsticker/search.shtml?T=###
			ws_Encode[4] = URL
			Hotkey_WebSearch[4]=
			ws_Browser[4]=
			ws_Deactivate[4]=0
			ws_ReplaceSpaces[4]=`%20
			ws_Name[5]   = &AutoHotkey-Forum
			ws_URL[5]    = http://www.autoHotkey.com/forum/search.php?search_terms=all&search_keywords=###
			ws_Encode[5] = URL
			Hotkey_WebSearch[5]=
			ws_Browser[5]=
			ws_Deactivate[5]=0
			ws_ReplaceSpaces[5]=`%20
			ws_Name[6]   = &Deutsches Wörterbuch
			ws_URL[6]    = http://www.dwds.de/cgi-bin/portalL.pl?search=###
			ws_Encode[6] = URL
			Hotkey_WebSearch[6] =
			ws_Browser[6]=
			ws_Deactivate[6]=0
			ws_ReplaceSpaces[6]=`%20
			ws_Name[7]   = Wor&tschatz-Lexikon
			ws_URL[7]    = http://wortschatz.uni-leipzig.de/cgi-bin/wort_www?site=1&Wort=###&sprache=de&cs=1&x=0&y=0
			ws_Encode[7] = Unicode
			Hotkey_WebSearch[7] = #+T
			ws_Browser[7]=
			ws_Deactivate[7]=0
			ws_ReplaceSpaces[7]=`%20
		}
		else if Lng = 13  ; = Nederlands
		{
			ws_Items     = 6
			ws_Name[1]   = &Allwords Engels-Nederlands
			ws_URL[1]    = http://www.allwords.com/query.php?SearchType=0&Keyword=###&goquery=Find+it`%21&Language=ENG&NLD=1
			ws_Encode[1] = URL
			ws_Browser[1]=
			ws_Deactivate[1]=0
			ws_ReplaceSpaces[1]=`%20
			ws_Name[2]   = &Google
			ws_URL[2]    = http://www.google.com/search?hl=nl&q=###&ie=UTF-8
			ws_Encode[2] = Unicode
			ws_Browser[2]=
			ws_Deactivate[2]=0
			ws_ReplaceSpaces[2]=`%20
			ws_Name[3]   = &Wikipedia
			ws_URL[3]    = http://nl.wikipedia.org/wiki/Special:Search?search=###
			ws_Encode[3] =
			ws_Browser[3]=
			ws_Deactivate[3]=0
			ws_ReplaceSpaces[3]=`%20
			ws_Name[4]   = &FnL Nieuwsticker
			ws_URL[4]    = http://www.fnl.nl/search/search.cgi?q=###
			ws_Encode[4] = URL
			ws_Browser[4]=
			ws_Deactivate[4]=0
			ws_ReplaceSpaces[4]=`%20
			ws_Name[5]   = &AutoHotkey-Forum
			ws_URL[5]    = http://www.autoHotkey.com/forum/search.php?search_terms=all&search_keywords=###
			ws_Encode[5] = URL
			ws_Browser[5]=
			ws_Deactivate[5]=0
			ws_ReplaceSpaces[5]=`%20
			ws_Name[6]   = &IMDB
			ws_URL[6]    = http://www.imdb.com/find?q=###;tt=on;nm=on;mx=20
			ws_Encode[6] = URL
			ws_Browser[6]=
			ws_Deactivate[6]=0
			ws_ReplaceSpaces[6]=`%20
		}
		else        ; = other languages (english)
		{
			ws_Items     = 6
			ws_Name[1]   = &LEO
			ws_URL[1]    = http://dict.leo.org/?lp=ende&lang=en&searchLoc=0&cmpType=relaxed&relink=on&sectHdr=on&spellToler=std&search=###
			ws_Encode[1] = URL
			ws_Browser[1]=
			ws_Deactivate[1]=0
			ws_ReplaceSpaces[1]=`%20
			ws_Name[2]   = &Google
			ws_URL[2]    = http://www.google.com/search?q=###&ie=UTF-8
			ws_Encode[2] = Unicode
			ws_Browser[2]=
			ws_Deactivate[2]=0
			ws_ReplaceSpaces[2]=`%20
			ws_Name[3]   = &Wikipedia
			ws_URL[3]    = http://en.wikipedia.org/wiki/Special:Search?search=###
			ws_Encode[3] =
			ws_Browser[3]=
			ws_Deactivate[3]=0
			ws_ReplaceSpaces[3]=`%20
			ws_Name[4]   = &Techworld News
			ws_URL[4]    = http://www.techworld.com/search/index.cfm?thecriteria=###&fuseaction=dosearch&search_news=1
			ws_Encode[4] = URL
			ws_Browser[4]=
			ws_Deactivate[4]=0
			ws_ReplaceSpaces[4]=`%20
			ws_Name[5]   = &AutoHotkey-Forum
			ws_URL[5]    = http://www.autoHotkey.com/forum/search.php?search_terms=all&search_keywords=###
			ws_Encode[5] = URL
			ws_Browser[5]=
			ws_Deactivate[5]=0
			ws_ReplaceSpaces[5]=`%20
			ws_Name[6]   = &Dictionary
			ws_URL[6]    = http://dictionary.reference.com/search?q=###
			ws_Encode[6] = URL
			ws_Browser[6]=
			ws_Deactivate[6]=0
			ws_ReplaceSpaces[6]=`%20
		}
	}

	FileDelete, %ws_IconPath%\*.tmp

	Loop, %ws_Items%
	{

		ws_ICO := ws_IconPath "\" ws_func_CorrectIcoFilename( ws_Name[%A_Index%] ) ".ico"

		IfNotExist, %ws_ICO%
			ws_ICO =

		ws_ICO[%A_Index%] = %ws_ICO%
	}

	Loop, %ws_Items%
	{
		If ws_Deactivate[%A_Index%] = 1
			continue

		If Hotkey_WebSearch[%A_Index%] <>
		{
			Hotkey, % Hotkey_WebSearch[%A_Index%], ws_sub_HotkeySearch, On UseErrorLevel

			Hotkey_AllHotkeys := Hotkey_AllHotkeys "«<" Hotkey_WebSearch[%A_Index%] " >»"
			Hotkey_Extension[WebSearch$WebSearch[%A_Index%]] := Hotkey_WebSearch[%A_Index%]
			Hotkey_Extensions := Hotkey_Extensions "WebSearch$WebSearch[" A_Index "]|"
			Hotkey_ExtensionText[WebSearch[%A_Index%]] := ws_Name[%A_Index%]
		}
	}

	IniRead, ws_Check, %ConfigFile%, %ws_ScriptName%, Checkboxes
	Loop, Parse, ws_Check
	{
		If (A_LoopField <> 0 AND A_LoopField <> 1)
			ws_Check[%A_Index%] = 0
		Else
			ws_Check[%A_Index%] = %A_LoopField%
	}

	IniRead, ws_CenterApps, %ConfigFile%, %ws_ScriptName%, CenterApps, Opera,Microsoft Word,Adobe
	IniRead, ws_AlwaysCenter, %ConfigFile%, %ws_ScriptName%, AlwaysCenter, 1
	IniRead, ws_RememberPos, %ConfigFile%, %ws_ScriptName%, RememberPosition, 0
	IniRead, ws_RememberPosX, %ConfigFile%, %ws_ScriptName%, RememberPositionX, %A_Space%
	IniRead, ws_RememberPosY, %ConfigFile%, %ws_ScriptName%, RememberPositionY, %A_Space%
	IniRead, ws_OnMouseCursor, %ConfigFile%, %ws_ScriptName%, OnMouseCursor, %A_Space%
	IniRead, ws_DisableHistory, %ConfigFile%, %ws_ScriptName%, DisableHistory, 0
	IniRead, ws_MultipleOpenDelay, %ConfigFile%, %ws_ScriptName%, MultipleOpenDelay, 500

	If ws_DisableHistory = 0
		IniRead, ws_searchHistory, %ConfigFile%, %ws_ScriptName%, SearchHistory, %A_Space%

	StringReplace, ws_searchHistory, ws_searchHistory, ||, |, All

	RegRead, ws_DefaultBrowser,HKEY_CLASSES_ROOT,HTTP\shell\open\command
Return

SettingsGui_WebSearch:
	ws_List =
	Loop, %ws_Items%
	{
		ws_URL_new[%A_Index%]  := ws_URL[%A_Index%]
		ws_Name_new[%A_Index%] := ws_Name[%A_Index%]
		ws_ICO_new[%A_Index%]  := ws_ICO[%A_Index%]
		ws_Encode_new[%A_Index%]  := ws_Encode[%A_Index%]
		Hotkey_WebSearch[%A_Index%]_new  := Hotkey_WebSearch[%A_Index%]
		ws_Browser_new[%A_Index%]  := ws_Browser[%A_Index%]
		ws_Deactivate_new[%A_Index%]  := ws_Deactivate[%A_Index%]
		ws_ReplaceSpaces_new[%A_Index%]  := ws_ReplaceSpaces[%A_Index%]

		ws_List := ws_List ws_Name_new[%A_Index%] "|"

		IfExist, % ws_ICO_new[%A_Index%]
			FileCopy, % ws_ICO_new[%A_Index%], % ws_ICO_new[%A_Index%] ".tmp"

		If ws_Deactivate[%A_Index%] <> 1
			func_CreateListOfHotkeys( Hotkey_WebSearch[%A_Index%], ws_Name[%A_Index%], "WebSearch", "ws_sub_HotkeySearch" )
	}

	Gui, Add, ListBox, xs+10 yp+30 w150 R16 gws_sub_SelectConfig AltSubmit vws_Config AltSubmit, %ws_List%

	Gui, Add, Text, xs+170 yp+0, %lng_ws_EntryName%
	Gui, Add, Edit, y+3 w200 R1 -Multi vws_NAME gws_sub_Changed , %ws_NAME%
	Gui, Add, CheckBox, x+10 -Wrap yp+4 gws_sub_Changed vws_Deactivate, %lng_ws_deactivate%
	Gui, Add, Text, xs+170 y+8, %lng_ws_Hotkey%:
	func_HotkeyAddGuiControl( "","ws_Hotkey", "y+3 w300 gws_sub_HotkeyButton")
	Gui, Add, Text, xs+170 y+10, %lng_ws_EntryURL%
	Gui, Add, Picture, xs+170 y+51 w16 h16 vws_FavIcon,
	Gui, Add, Edit, xs+170 yp-51 w390 R3 -WantReturn vws_URL gws_sub_Changed ,
	Gui, Add, Button, -Wrap xs+190 y+3 w100 h18 gws_sub_getFavicon, %lng_ws_GetIcon%

	Gui, Add, Button, -Wrap xs+388 yp+0 h18 w150 gws_sub_Browser, %lng_ws_MenuBrowser%
	Gui, Add, Picture, x+5 yp+1 w16 h16 vws_BrowserIcon,

	Gui, Add, Text, xs+170 y+20, %lng_ws_Encoding%
	Gui, Add, Radio, -Wrap y+3 vws_EncodeR1 Checked gws_sub_Changed, %lng_ws_NoEncode%
	Gui, Add, Radio, -Wrap x+10 vws_EncodeR2 Checked gws_sub_Changed, %lng_ws_Unicode%
	Gui, Add, Radio, -Wrap x+10 vws_EncodeR3 Checked gws_sub_Changed, %lng_ws_URLencode%

	Gui, Add, Text, xs+420 ys+228, %lng_ws_ReplaceSpaces%:
	Gui, Add, ComboBox, y+2 w70 vws_ReplaceSpaces gws_sub_Changed

	Gui, Add, Button, -Wrap xs+10 ys+257 w25 h25 vws_Add gws_sub_Add, +
	Gui, Add, Button, -Wrap x+5 w25 h25 vws_Delete gws_sub_Delete, %MinusString%

	Gui, Font,s10, Wingdings
	Gui, Add, Button, -Wrap x+40 ys+257 w25 h25 vws_Up gws_sub_Up, ñ
	Gui, Add, Button, -Wrap x+5 w25 h25 vws_Down gws_sub_Down, ò
	Gosub, GuiDefaultFont

	Gui, Add, Button, -Wrap xs+400 ys+13 h17 w120 gws_sub_CenterApps, %lng_ws_CenterApps%

	GuiControl, Choose, ws_Config , 1

	ws_UseHistory := !(ws_DisableHistory)
	Gui, Add, CheckBox, -Wrap xs+230 ys+289 vws_UseHistory gws_sub_Changed Checked%ws_UseHistory%, %lng_ws_UseHistory%
	Gui, Add, Button, -Wrap x+5 yp-1 h18 gws_sub_EmptyHistory, %lng_ws_EmptyHistory%

	Gosub, ws_sub_SelectConfig
Return

ws_sub_SelectConfig:
	Critical
	SkipChecking = 1
	GuiControlGet, ws_Config,,,
	GuiControl,,ws_Name, % ws_Name_new[%ws_Config%]
	GuiControl,,ws_Deactivate, % ws_Deactivate_new[%ws_Config%]

	ws_Hotkey := Hotkey_WebSearch[%ws_Config%]_new

	GuiControl,,Hotkey_ws_Hotkey, % "  " func_HotkeyDecompose(ws_Hotkey,0)

	GuiControl,,ws_URL, % ws_URL_new[%ws_Config%]
	If ws_Encode_new[%ws_Config%] =
		GuiControl,,ws_EncodeR1, 1
	If ws_Encode_new[%ws_Config%] = Unicode
		GuiControl,,ws_EncodeR2, 1
	If ws_Encode_new[%ws_Config%] = URL
		GuiControl,,ws_EncodeR3, 1

	StringReplace, ws_SpaceReplacer_tmp, ws_SpaceReplacer, `,, |, All
	If ws_ReplaceSpaces_new[%ws_Config%] not in %ws_SpaceReplacer%
		ws_SpaceReplacer_tmp := ws_SpaceReplacer_tmp "|" ws_ReplaceSpaces_new[%ws_Config%]
	GuiControl, , ws_ReplaceSpaces, |%ws_SpaceReplacer_tmp%
	GuiControl, ChooseString, ws_ReplaceSpaces, % ws_ReplaceSpaces_new[%ws_Config%]

	If ws_ICO_new[%ws_Config%] =
		GuiControl,,ws_FavIcon, % "*h16 *w16 *Icon1 "
	Else
		GuiControl,,ws_FavIcon, % "*h16 *w16 *Icon1 " ws_ICO_new[%ws_Config%] ".tmp"
	GuiControl,,ws_BrowserIcon, % "*h16 *w16 *Icon1 " ws_Browser_new[%ws_Config%]

	ws_ICO := ws_IconPath "\" ws_func_CorrectIcoFilename( ws_Name[%ws_Config%] ) ".ico"

	Hotkey_ws_Hotkey_new := ws_Hotkey
	ws_Browser := ws_Browser_new[%ws_Config%]
	SkipChecking = 0
	Sleep,0
Return

ws_sub_HotkeyButton:
	Gosub, sub_HotkeyButton
	Gosub, ws_sub_Changed
	ws_HotkeyApplied[%ws_Config%] = 1
Return

ws_sub_Add:
	SkipChecking = 1
	ws_Items++
	ws_Config := ws_Items
	ws_URL_new[%ws_Config%]  =
	ws_Name_new[%ws_Config%] = %lng_ws_New%
	ws_ICO_new[%ws_Config%]  =
	Hotkey_WebSearch[%ws_Config%]_new  =
	ws_Browser_new[%ws_Config%]  =
	ws_Encode_new[%ws_Config%]  = URL
	ws_Deactivate_new[%ws_Config%] = 0
	ws_ReplaceSpaces_new[%ws_Config%] = `%20
	Hotkey_ws_Hotkey_new =

	ws_List = |
	Loop, %ws_Items%
	{
		If (ws_Name_new[%A_Index%] = "" OR ws_Name_new[%A_Index%] = " ")
			Break
		ws_List := ws_List ws_Name_new[%A_Index%] "|"
	}
	GuiControl,,ws_Config,%lng_ws_New%
	GuiControl,,ws_URL,
	GuiControl,,ws_Name, %lng_ws_New%
	GuiControl,,ws_EncodeR1,1
	GuiControl,,Hotkey_ws_Hotkey,
	GuiControl,,ws_FavIcon
	GuiControl,,ws_EncodeR3, 1
	GuiControl,ChooseString,ws_ReplaceSpaces, `%20
	GuiControl, focus, ws_Name
	Send, +{END}
Return

ws_sub_Changed:
	GuiControl,Choose,ws_Config,%ws_Config%
	If SkipChecking = 1
	{
		SkipChecking = 0
		return
	}

	Gosub, sub_CheckIfSettingsChanged

	GuiControlGet,ws_Config,1:,,
	GuiControlGet,ws_URL,1:,,
	GuiControlGet,ws_Name,1:,,
	GuiControlGet,ws_Deactivate,1:,,
	GuiControlGet,ws_Hotkey,1:,,
	GuiControlGet,ws_EncodeR1,1:,,
	GuiControlGet,ws_EncodeR2,1:,,
	GuiControlGet,ws_EncodeR3,1:,,
	GuiControlGet,ws_ReplaceSpaces,1:,,

	If A_GuiControl = ws_Add
	{
		ws_Config := ws_Items+1
	}

	If ws_URL contains `r,`n
	{
		StringReplace,ws_URL,ws_URL,`r,,All
		StringReplace,ws_URL,ws_URL,`n,,All
		GuiControl,%GuiID_activAid%:,ws_URL,%ws_URL%
	}

	ws_ICO := ws_IconPath "\" ws_func_CorrectIcoFilename( ws_Name ) ".ico"

	If ws_ICO_new[%ws_Config%] <>
		IfExist, % ws_ICO_new[%ws_Config%] ".tmp"
			FileMove, % ws_ICO_new[%ws_Config%] ".tmp", %ws_ICO%.tmp, 1

	ws_URL_new[%ws_Config%]  = %ws_URL%
	ws_Name_new[%ws_Config%] = %ws_Name%
	ws_ICO_new[%ws_Config%]  = %ws_ICO%
	ws_Deactivate_new[%ws_Config%]  = %ws_Deactivate%
	ws_ReplaceSpaces_new[%ws_Config%]  = %ws_ReplaceSpaces%

	ws_Hotkey = %Hotkey_ws_Hotkey_new%

	Hotkey_WebSearch[%ws_Config%]_new  = %ws_Hotkey%

	If ws_EncodeR1 = 1
		ws_Encode =
	If ws_EncodeR2 = 1
		ws_Encode = Unicode
	If ws_EncodeR3 = 1
		ws_Encode = URL

	ws_Encode_new[%ws_Config%] = %ws_Encode%

	ws_List = |
	Loop, %ws_Items%
	{
		ws_List := ws_List ws_Name_new[%A_Index%] "|"
	}

	GuiControl,,ws_Config,%ws_List%
	GuiControl,Choose,ws_Config, %ws_Config%

	ws_Browser := ws_Browser_new[%ws_Config%]
Return

ws_sub_Delete:
	If ws_Items = 0
		return
	GuiControlGet,ws_Config,,,

	FileDelete, % ws_ICO_new[%ws_Config%] ".tmp"
	ws_tempIndex = 1

	Loop
	{
		If (ws_Name[%ws_tempIndex%] = "" OR ws_Name[%ws_tempIndex%] = " ")
		{
			ws_URL_new[%A_Index%]  :=
			ws_Name_new[%A_Index%] :=
			ws_ICO_new[%A_Index%]  :=
			ws_Encode_new[%A_Index%]  :=
			Hotkey_WebSearch[%A_Index%]_new  :=
			ws_Browser_new[%A_Index%]  :=
			ws_Deactivate_new[%A_Index%]  :=
			ws_ReplaceSpaces_new[%A_Index%]  :=
			Break
		}

		If A_Index = %ws_Config%
			ws_tempIndex++

		ws_URL_new[%A_Index%]  := ws_URL_new[%ws_tempIndex%]
		ws_Name_new[%A_Index%] := ws_Name_new[%ws_tempIndex%]
		ws_ICO_new[%A_Index%]  := ws_ICO_new[%ws_tempIndex%]
		ws_Encode_new[%A_Index%]  := ws_Encode_new[%ws_tempIndex%]
		Hotkey_WebSearch[%A_Index%]_new  := Hotkey_WebSearch[%ws_tempIndex%]_new
		ws_Browser_new[%A_Index%]  := ws_Browser_new[%ws_tempIndex%]
		ws_Deactivate_new[%A_Index%]  := ws_Deactivate_new[%ws_tempIndex%]
		ws_ReplaceSpaces_new[%A_Index%]  := ws_ReplaceSpaces[%ws_tempIndex%]

		ws_tempIndex++
	}
	ws_Items--

	ws_List = |
	Loop, %ws_Items%
	{
		ws_List := ws_List ws_Name_new[%A_Index%] "|"
	}

	GuiControl,,ws_Config,%ws_List%

	If ws_Config > 1
		ws_Config--

	GuiControl,Choose,ws_Config,%ws_Config%

	Gosub, ws_sub_SelectConfig

	func_SettingsChanged("WebSearch")
Return

ws_sub_Up:
	If ws_Items = 0
		return
	GuiControlGet,ws_Config,,,

	If (ws_Config < 2)
		Return

	ws_Config2 := ws_Config-1

	Gosub, ws_sub_ExchangeItems
Return

ws_sub_Down:
	If ws_Items = 0
		return
	GuiControlGet,ws_Config,,,

	If (ws_Config >= ws_Items)
		Return

	ws_Config2 := ws_Config+1

	Gosub, ws_sub_ExchangeItems
Return

ws_sub_ExchangeItems:
	ws_URLTmp := ws_URL_new[%ws_Config%]
	ws_NameTmp := ws_Name_new[%ws_Config%]
	ws_ICOTmp := ws_ICO_new[%ws_Config%]
	ws_EncodeTmp := ws_Encode_new[%ws_Config%]
	ws_HotkeyTmp := Hotkey_WebSearch[%ws_Config%]_new
	ws_BrowserTmp := ws_Browser_new[%ws_Config%]
	ws_DeactivateTmp := ws_Deactivate_new[%ws_Config%]
	ws_ReplaceSpacesTmp := ws_ReplaceSpaces_new[%ws_Config%]

	ws_URL_new[%ws_Config%]  := ws_URL_new[%ws_Config2%]
	ws_Name_new[%ws_Config%] := ws_Name_new[%ws_Config2%]
	ws_ICO_new[%ws_Config%]  := ws_ICO_new[%ws_Config2%]
	ws_Encode_new[%ws_Config%]  := ws_Encode_new[%ws_Config2%]
	Hotkey_WebSearch[%ws_Config%]_new  := Hotkey_WebSearch[%ws_Config2%]_new
	ws_Browser_new[%ws_Config%]  := ws_Browser_new[%ws_Config2%]
	ws_Deactivate_new[%ws_Config%]  := ws_Deactivate_new[%ws_Config2%]
	ws_ReplaceSpaces_new[%ws_Config%]  := ws_ReplaceSpaces_new[%ws_Config2%]

	ws_URL_new[%ws_Config2%]  := ws_URLTmp
	ws_Name_new[%ws_Config2%] := ws_NameTmp
	ws_ICO_new[%ws_Config2%]  := ws_ICOTmp
	ws_Encode_new[%ws_Config2%]  := ws_EncodeTmp
	Hotkey_WebSearch[%ws_Config2%]_new  := ws_HotkeyTmp
	ws_Browser_new[%ws_Config2%]  := ws_BrowserTmp
	ws_Deactivate_new[%ws_Config2%]  := ws_DeactivateTmp
	ws_ReplaceSpaces_new[%ws_Config2%]  := ws_ReplaceSpacesTmp

	ws_List = |
	Loop, %ws_Items%
	{
		ws_List := ws_List ws_Name_new[%A_Index%] "|"
	}

	GuiControl,,ws_Config,%ws_List%

	GuiControl,Choose,ws_Config,%ws_Config2%

	Gosub, ws_sub_SelectConfig

	func_SettingsChanged("WebSearch")
Return

ws_sub_EmptyHistory:
	MsgBox, 36, %ws_ScriptTitle%, %lng_ws_AskEmptyHistory%
	IfMsgBox, yes
	{
		ws_searchHistory =
		IniWrite, %ws_searchHistory%, %ConfigFile%, %ws_ScriptName%, SearchHistory
	}
Return


SaveSettings_WebSearch:
	IniDelete, %ConfigFile%, %ws_ScriptName%
	IniWrite, %ws_CenterApps%, %ConfigFile%, %ws_ScriptName%, CenterApps
	IniWrite, %ws_AlwaysCenter%, %ConfigFile%, %ws_ScriptName%, AlwaysCenter
	IniWrite, %ws_RememberPos%, %ConfigFile%, %ws_ScriptName%, RememberPosition
	ws_DisableHistory := !(ws_UseHistory)
	IniWrite, %ws_OnMouseCursor%, %ConfigFile%, %ws_ScriptName%, OnMouseCursor
	IniWrite, %ws_DisableHistory%, %ConfigFile%, %ws_ScriptName%, DisableHistory
	IniWrite, %ws_MultipleOpenDelay%, %ConfigFile%, %ws_ScriptName%, MultipleOpenDelay

	func_HotkeyWrite( "WebSearch", ConfigFile, "WebSearch", "Hotkey_WebSearch" )

	FileDelete, %ws_IconPath%\*.ico

	FileDelete, %ws_IconPath%\URLs.cfg
	Loop, %ws_Items%
	{
		If (ws_Name_new[%A_Index%] = "" OR ws_Name_new[%A_Index%] = " ")
		{
			IniDelete, %ConfigFile%, %ws_ScriptName%, --------------------------%A_Index%---
			IniDelete, %ConfigFile%, %ws_ScriptName%, Name%A_Index%
			IniDelete, %ConfigFile%, %ws_ScriptName%, URL%A_Index%
			IniDelete, %ConfigFile%, %ws_ScriptName%, Encode%A_Index%
			IniDelete, %ConfigFile%, %ws_ScriptName%, Hotkey%A_Index%
			IniDelete, %ConfigFile%, %ws_ScriptName%, Browser%A_Index%
			IniDelete, %ConfigFile%, %ws_ScriptName%, Deactivate%A_Index%
			IniDelete, %ConfigFile%, %ws_ScriptName%, ReplaceSpaces%A_Index%
		}
		Else
		{
			ws_Name[%A_Index%] := ws_Name_new[%A_Index%]
			ws_URL[%A_Index%] := ws_URL_new[%A_Index%]
			ws_Encode[%A_Index%] := ws_Encode_new[%A_Index%]
			Hotkey_WebSearch[%A_Index%] := Hotkey_WebSearch[%A_Index%]_new
			ws_Browser[%A_Index%] := ws_Browser_new[%A_Index%]
			ws_ICO[%A_Index%] := ws_ICO_new[%A_Index%]
			ws_Deactivate[%A_Index%] := ws_Deactivate_new[%A_Index%]
			ws_ReplaceSpaces[%A_Index%] := ws_ReplaceSpaces_new[%A_Index%]

			IniWrite,------------------------------------, %ConfigFile%, %ws_ScriptName%, --------------------------%A_Index%---
			IniWrite,% ws_Name[%A_Index%]   , %ConfigFile%, %ws_ScriptName%, Name%A_Index%
			IniWrite,% ws_URL[%A_Index%]    , %ConfigFile%, %ws_ScriptName%, URL%A_Index%
			IniWrite,% ws_Encode[%A_Index%] , %ConfigFile%, %ws_ScriptName%, Encode%A_Index%
			IniWrite,% Hotkey_WebSearch[%A_Index%] , %ConfigFile%, %ws_ScriptName%, Hotkey%A_Index%
			IniWrite,% ws_Browser[%A_Index%], %ConfigFile%, %ws_ScriptName%, Browser%A_Index%
			IniWrite,% ws_Deactivate[%A_Index%], %ConfigFile%, %ws_ScriptName%, Deactivate%A_Index%
			IniWrite,% ws_ReplaceSpaces[%A_Index%], %ConfigFile%, %ws_ScriptName%, ReplaceSpaces%A_Index%
			ws_Items = %A_Index%
			IfExist, % ws_ICO[%A_Index%] ".tmp"
			{
				ws_CopyFrom := % ws_ICO[%A_Index%] ".tmp"
				ws_CopyTo := % ws_ICO[%A_Index%]
				FileCopy,%ws_CopyFrom%, %ws_CopyTo%, 1
			}
			Else
				ws_ICO[%Index%] =
		}
	}

	Loop, %ws_Items%
	{
		If ws_Deactivate[%A_Index%] = 1
			continue

		If Hotkey_WebSearch[%A_Index%] <>
		{
			ws_HotkeyApplied[%A_Index%] =
			Hotkey, % Hotkey_WebSearch[%A_Index%], ws_sub_HotkeySearch, On UseErrorLevel
		}
	}

	If A_GuiControl <> MainGUIapply
		FileDelete, %ws_IconPath%\*.tmp
Return

ResetWindows_WebSearch:
	IniDelete, %ConfigFile%, %ws_ScriptName%, RememberPositionX
	IniDelete, %ConfigFile%, %ws_ScriptName%, RememberPositionY
	ws_RememberPosX =
	ws_RememberPosY =
Return

AddSettings_WebSearch:
	If AddFreshSettings = 1
		ws_Items = 0

	If ws_Name_new[%ws_Items%] =
		ws_Items--
	Loop
	{
		IniRead, ws_NameTmp, %AddFile%, %ws_ScriptName%, Name%A_Index%
		If (ws_NameTmp = "" OR ws_NameTmp = "ERROR")
		{
			ws_NameTmp =
			ws_URL =
			break
		}
		IniRead, ws_URLTmp    , %AddFile%, %ws_ScriptName%, URL%A_Index%
		IniRead, ws_EncodeTmp , %AddFile%, %ws_ScriptName%, Encode%A_Index%
		IniRead, ws_HotkeyTmp , %AddFile%, %ws_ScriptName%, Hotkey%A_Index%
		IniRead, ws_BrowserTmp, %AddFile%, %ws_ScriptName%, Browser%A_Index%
		IniRead, ws_DeactivateTmp, %AddFile%, %ws_ScriptName%, Deactivate%A_Index%, 0
		IniRead, ws_ReplaceSpacesTmp, %AddFile%, %ws_ScriptName%, ReplaceSpaces%A_Index%, 0
		If ws_HotkeyTmp = ERROR
			ws_HotkeyTmp =
		ws_Duplicates = 0
		Loop, %ws_Items%
		{
			If (ws_Name_new[%A_Index%] = ws_NameTmp OR ws_URL_new[%A_Index%] = ws_URLTmp)
			{
				ws_Duplicates++
				break
			}
			If Hotkey_WebSearch[%A_Index%]_new = %ws_HotkeyTmp%
				ws_HotkeyTmp =
		}
		If ws_Duplicates = 0
		{
			ws_Items++
			ws_Name_new[%ws_Items%] = %ws_NameTmp%
			ws_Encode_new[%ws_Items%] = %ws_EncodeTmp%
			ws_URL_new[%ws_Items%] = %ws_URLTmp%
			Hotkey_WebSearch[%ws_Items%]_new = %ws_HotkeyTmp%
			ws_Browser_new[%ws_Items%] = %ws_BrowserTmp%
			ws_Deactivate_new[%ws_Items%] = %ws_DeactivateTmp%
			ws_ReplaceSpaces_new[%ws_Items%] = %ws_ReplaceSpacesTmp%
		}
	}
	ws_List =
	Loop, %ws_Items%
	{
		ws_List := ws_List ws_Name_new[%A_Index%] "|"
	}

	GuiControl,,ws_Config, |%ws_List%
	GuiControl,Choose,ws_Config,%ws_Config%
Return

CancelSettings_WebSearch:
	FileDelete, %ws_IconPath%\*.tmp
	Gosub, init_WebSearch
Return

DoEnable_WebSearch:
	Loop, %ws_Items%
	{
		If ws_Deactivate[%A_Index%] = 1
			continue

		If (Hotkey_WebSearch[%A_Index%] <> "" AND ws_HotkeyApplied[%A_Index%] = "")
		{
			Hotkey, % Hotkey_WebSearch[%A_Index%], ws_sub_HotkeySearch, On UseErrorLevel
		}
	}
Return

DoDisable_WebSearch:
	Loop, %ws_Items%
	{
		If (Hotkey_WebSearch[%A_Index%] <> "")
		{
			Hotkey, % Hotkey_WebSearch[%A_Index%], ws_sub_HotkeySearch, Off UseErrorLevel
		}
	}
Return

DefaultSettings_WebSearch:
Return

OnExitAndReload_WebSearch:
	If (ws_RememberPos = 1 AND ws_GuiActive <> "")
	{
		WinGetPos, ws_RememberPosX, ws_RememberPosY,,, ahk_id %ws_SearchDialogID%
		IniWrite, %ws_RememberPosX%, %ConfigFile%, %ws_ScriptName%, RememberPositionX
		IniWrite, %ws_RememberPosY%, %ConfigFile%, %ws_ScriptName%, RememberPositionY
	}
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

sub_Hotkey_Websearch:
	Gosub, ws_main_WebSearch
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
ws_main_WebSearch:
	GuiDefault("WebSearch")
	If ws_GuiActive = yes
	{
		GuiControlGet, ws_prevSearch,%GuiID_WebSearch%:, ws_searchFor
		Gosub, WebSearchGuiClose
	}

	ws_tempClip := ClipboardAll
	func_GetSelection("UTF-8")
	ws_searchFor := Selection

	IfExist, %ws_searchFor%
	{
		SplitPath, ws_searchFor, ws_searchFor
	}

	ws_GuiActive = yes

	Gosub, ws_sub_SearchDialog
Return

; -----------------------------------------------------------------------------
ws_sub_SearchDialog:
	CoordMode, Mouse, Screen
	CoordMode, Caret, Screen

	GuiDefault("WebSearch")
	Gosub, GuiDefaultFont
	Gui, -MaximizeBox -MinimizeBox +LastFound

	Gosub, sub_BigIcon

	ws_GuiX =
	ws_GuiY =

	if ws_AlwaysCenter <> 1
	{
		If ws_RememberPos = 1
		{
			If (ws_RememberPosY<>"" AND ws_RememberPosY<>" ")
				ws_GuiY = y%ws_RememberPosY%
			If (ws_RememberPosY<>"" AND ws_RememberPosY<>" ")
				ws_GuiX = x%ws_RememberPosX%
		}
	  Else If ws_OnMouseCursor = 1
	  {
		  ; new position with the cursor on the inputfield
			MouseGetPos, ws_GuiX, ws_GuiY
		 ws_GuiX := "x"(ws_GuiX - 50)
		 ws_GuiY := "y"(ws_GuiY - 35)
	  }
		Else
		{
			If A_ThisHotkey contains #
			{
				ws_GuiY = %A_CaretY%
				ws_GuiX = %A_CaretX%
				If (ws_GuiY = 0 AND ws_GuiX = 0 )
					MouseGetPos, ws_GuiX, ws_GuiY
			}
			Else
			{
				If ws_DontMove <> 1
					MouseGetPos, ws_GuiX, ws_GuiY
			}

			WinGetActiveTitle, ws_ActWin
			If ws_ActWin not contains %ws_CenterApps%
			{
				ws_GuiX = x%ws_GuiX%
				ws_GuiY = y%ws_GuiY%
			}
		}
	}
	if ws_prevSearch <>
		ws_searchFor = %ws_prevSearch%

	Gui, Add, ComboBox, y+5 x8 w200 -Multi vws_searchFor, %ws_searchHistory%

	ws_prevSearch =

	If ws_pressedButton < 1
		ws_XBegin = 27
	Else
		ws_XBegin = 8

	ws_Height = 120
	ws_Column = 0
	ws_Line = 1
	ws_MaxLines := Floor(ws_Items/(120+ws_Items*26)*WorkAreaHeight)
	ws_MaxLines := Ceil(ws_Items/Ceil(ws_Items/ws_MaxLines))
	ws_MaxY := ws_Items*26+16+30

	Loop, %ws_Items%
	{
		If ws_Deactivate[%A_Index%] = 1
			continue

		If (ws_pressedButton <> "" AND ws_pressedButton <> A_Index)
			continue

		ws_X := ws_XBegin+ws_Column*320
		ws_Y := (ws_Line-1)*26+36

		ws_ICO := ws_ICO[%A_Index%]
		Gui, Add, Pic,x%ws_X% y%ws_Y% w16 h16 vws_picv%A_Index%,%ws_ICO%
		ws_picv = ws_picv%A_Index%
		GuiControlGet, ws_PicPos[%A_Index%] , %GuiID_WebSearch%:Pos, %ws_picv%
		ws_Height := 120+ws_Line*26
		ws_Line++
		If ws_Line > %ws_MaxLines%
		{
			ws_Line = 1
			ws_Column++
			ws_MaxY := ws_PicPos[%A_Index%]Y+30
		}
	}

	If ws_pressedButton =
		ws_Default = Default Focus

	Loop, %ws_Items%
	{
		If ws_Deactivate[%A_Index%] = 1
			continue

		If ws_pressedButton = %A_Index%
			ws_Default = Default Focus

		If (ws_pressedButton <> "" AND ws_pressedButton <> A_Index)
			continue

		ws_X := ws_PicPos[%A_Index%]X + 20
		ws_Y := ws_PicPos[%A_Index%]Y - 3
		Gui, Add, Button, -Wrap x%ws_X% y%ws_Y% w180 h23 Left gws_sub_Search %ws_Default% vws_Button%A_Index%, % " " ws_Name[%A_Index%]

		ws_temp := ws_Name[%A_Index%]
		ws_temp = %ws_temp% ...

		ws_Default =
	}

	If ws_pressedButton < 1
	{
		ws_Checked = 0
		Loop, %ws_Items%
		{
			If ws_Deactivate[%A_Index%] = 1
				continue

			ws_Y := ws_PicPos[%A_Index%]Y + 1
			ws_X := ws_PicPos[%A_Index%]X - 18
			ws_Check := "0" ws_Check[%A_Index%]
			ws_Checked := ws_Checked + ws_Check
			Gui, Add, CheckBox, -Wrap x%ws_X% y%ws_Y% h15 w15 vws_Check[%A_Index%] Checked%ws_Check%,
			Gui, Font, S7, Small Fonts
			ws_X := ws_X+220
			Gui, Add, Text, x%ws_X% yp+2, % func_HotkeyDecompose(Hotkey_WebSearch[%A_Index%],2)
			Gui, Font
		}

		if (ws_searchFor <> "" AND ws_Checked > 0)
		{
			Gui, Add, Button, -Wrap +0x8000 y%ws_MaxY% x8 w250 gws_sub_Search Default vws_ButtonAll, %lng_ws_SearchAll%
			GuiControl, %GuiID_WebSearch%:Focus, ws_ButtonAll
		}
		Else if ws_Checked > 0
			Gui, Add, Button, -Wrap +0x8000 y%ws_MaxY% x8 w250 gws_sub_Search Default vws_ButtonAll, %lng_ws_SearchAll%
		Else if ws_searchFor <>
		{
			Gui, Add, Button, -Wrap +0x8000 y%ws_MaxY% x8 w250 gws_sub_Search vws_ButtonAll, %lng_ws_SearchAll%
			GuiControl, %GuiID_WebSearch%:Focus, ws_Button1
		}
		Else
			Gui, Add, Button, -Wrap +0x8000 y%ws_MaxY% x8 w250 gws_sub_Search vws_ButtonAll, %lng_ws_SearchAll%
	}
	Else if ws_searchFor <>
		GuiControl, Focus, ws_Button1

	If ws_ExecuteSearch =
		ws_pressedButton =

	Gui, Show, AutoSize %ws_GuiX% %ws_GuiY%, %ws_ScriptTitle%

	func_AddMessage( 0x100, "ws_OnMessage_Keys" )

	WinGet, ws_SearchDialogID, ID

	WinGetPos,,,ws_Width
	ws_Width -= 20
	GuiControl, Move, ws_searchFor, w%ws_Width%
	GuiControl, Move, ws_ButtonAll, w%ws_Width%
	GuiControl, %GuiID_WebSearch%:Text, ws_searchFor, %ws_searchFor%

	WinGetPos, ws_GuiX, ws_GuiY, ws_GuiW, ws_GuiH

	If (ws_GuiX + ws_GuiW > WorkAreaRight)
		ws_GuiX := WorkAreaRight - ws_GuiW
	If (ws_GuiY + ws_GuiH > WorkAreaBottom)
		ws_GuiY := WorkAreaBottom - ws_GuiH
	If (ws_GuiX < WorkAreaLeft)
		ws_GuiX := WorkAreaLeft
	If (ws_GuiY < WorkAreaTop)
		ws_GuiY := WorkAreaTop

	WinMove, %ws_GuiX%, %ws_GuiY%
	WinSet, AlwaysOnTop, On

	If ws_ExecuteSearch = 1
		Gosub, ws_sub_Search
Return

; -----------------------------------------------------------------------------
ws_func_CorrectIcoFilename( ws_ICO ) {
	StringReplace, ws_ICO, ws_ICO, &,,A
	StringReplace, ws_ICO, ws_ICO, :,,A
	StringReplace, ws_ICO, ws_ICO, *,,A
	StringReplace, ws_ICO, ws_ICO, ?,,A
	StringReplace, ws_ICO, ws_ICO, \,,A
	StringReplace, ws_ICO, ws_ICO, /,,A
	StringReplace, ws_ICO, ws_ICO, `",,A
	; " ; end qoute for syntax highlighting
	StringReplace, ws_ICO, ws_ICO, <,,A
	StringReplace, ws_ICO, ws_ICO, >,,A
	StringReplace, ws_ICO, ws_ICO, |,,A
	Return %ws_ICO%
}

; -----------------------------------------------------------------------------
ws_sub_Search:
	Gui, %GuiID_WebSearch%:Submit, NoHide

	If ws_pressedButton =
		StringReplace, ws_pressedButton, A_GuiControl, ws_Button,
	If ws_pressedButton =
		ws_pressedButton = 1

	If ws_DisableHistory = 0
	{
		StringReplace, ws_searchHistory, ws_searchHistory, |%ws_searchFor%|,|, All
		ws_searchHistory = |%ws_searchFor%|%ws_searchHistory%|
		StringReplace, ws_searchHistory, ws_searchHistory, ||, |, All
		StringGetPos, ws_searchHistoryPos, ws_searchHistory, |, L20
		If ws_searchHistoryPos > 1
			StringLeft, ws_searchHistory, ws_searchHistory, % ws_searchHistoryPos+1
		IniWrite, %ws_searchHistory%, %ConfigFile%, %ws_ScriptName%, SearchHistory
	}

	If ws_pressedButton = All
	{
		ws_searchForOrg = %ws_searchFor%
		Loop, %ws_Items%
		{
			If ws_Deactivate[%A_Index%] = 1
				continue

			ws_searchFor = %ws_searchForOrg%
			If ws_Check[%A_Index%] <> 1
				continue
			ws_URL := ws_URL[%A_Index%]
			ws_Browser := ws_Browser[%A_Index%]

			ws_ReplaceSpaces := ws_ReplaceSpaces[%A_Index%]
			If ws_ReplaceSpaces = {Space}
				ws_ReplaceSpaces := " "

			ws_searchForOld = %ws_searchFor%

			RegExMatch( ws_searchFor, "S)\s*(""[^""]*""|\S*)\s*(""[^""]*""|\S*)\s*(""[^""]*""|\S*)\s*(""[^""]*""|\S*)\s*(""[^""]*""|\S*)\s*(""[^""]*""|\S*)\s*(""[^""]*""|\S*)\s*(""[^""]*""|\S*)\s*(""[^""]*""|\S*)\s*", ws_searchForSub )
			Loop
			{
				ws_searchFor := ws_searchForSub%A_Index%
				If ws_searchFor =
				{
					StringReplace, ws_URL, ws_URL, ##%A_Index%##, %ws_searchFor%, All
					If ErrorLevel = 1
						Break
					Else
						continue
				}

				StringReplace, ws_searchFor, ws_searchFor, %A_Space%, #+SPACE+#, All

				If ws_Encode[%ws_pressedButton%] = URL
					ws_searchFor := func_UrlEncode(ws_searchFor)

				If ws_Encode[%ws_pressedButton%] = Unicode
				{
					If (Ansi2UTF8(UTF82Ansi(ws_searchFor)) = ws_searchFor OR Ansi2UTF8(UTF82Ansi(ws_searchFor)) = "")
					   ws_searchFor := Ansi2UTF8(ws_searchFor)
					ws_searchFor := func_UrlEncode(ws_searchFor)
				}

				StringReplace, ws_searchFor, ws_searchFor, #+SPACE+#, %ws_ReplaceSpaces%, All
				StringReplace, ws_URL, ws_URL, ##%A_Index%##, %ws_searchFor%, All
			}

			ws_searchFor = %ws_searchForOld%

			StringReplace, ws_searchFor, ws_searchFor, %A_Space%, #+SPACE+#, All

			if ws_Encode[%A_Index%] = URL
				ws_searchFor := func_UrlEncode(ws_searchFor)

			if ws_Encode[%A_Index%] = Unicode
			{
				ClipBoard = %ws_searchFor%
				Transform, ws_searchFor, Unicode
				ClipBoard = %ws_tempClip%
				ws_searchFor := func_UrlEncode(ws_searchFor)
			}

			StringReplace, ws_searchFor, ws_searchFor, #+SPACE+#, %ws_ReplaceSpaces%, All
			StringReplace, ws_URL, ws_URL, ###, %ws_searchFor%, All
			If ws_Browser =
			{
				SetTitleMatchMode, 2
				IfInString, ws_DefaultBrowser, Firefox
					IfWinNotExist, Firefox
					{
						Run, %ws_URL%,,UseErrorLevel
						If ErrorLevel = ERROR
							func_GetErrorMessage( A_LastError, ws_ScriptTitle, A_Quote ws_URL A_Quote "`n`n" )
						Else
							WinWaitActive, Firefox
					}
				Run, %ws_URL%,, UseErrorlevel
				If ErrorLevel = ERROR
					func_GetErrorMessage( A_LastError, ws_ScriptTitle, A_Quote ws_URL A_Quote "`n`n" )
			}
			Else
			{
				Run, % func_Deref(ws_Browser) """" ws_URL """",, UseErrorlevel
				If ErrorLevel = ERROR
					func_GetErrorMessage( A_LastError, ws_ScriptTitle, ws_Browser " " A_Quote ws_URL A_Quote "`n`n" )
				Else
					IfInString, ws_Browser, Firefox
						WinWaitActive, Firefox
			}
			Sleep, %ws_MultipleOpenDelay%
		}
	}
	Else
	{

		ws_URL := ws_URL[%ws_pressedButton%]
		ws_Browser := ws_Browser[%ws_pressedButton%]

		ws_ReplaceSpaces := ws_ReplaceSpaces[%ws_pressedButton%]
		If ws_ReplaceSpaces = {Space}
			ws_ReplaceSpaces := " "

		ws_searchForOld = %ws_searchFor%

		RegExMatch( ws_searchFor, "S)\s*(""[^""]*""|\S*)\s*(""[^""]*""|\S*)\s*(""[^""]*""|\S*)\s*(""[^""]*""|\S*)\s*(""[^""]*""|\S*)\s*(""[^""]*""|\S*)\s*(""[^""]*""|\S*)\s*(""[^""]*""|\S*)\s*(""[^""]*""|\S*)\s*", ws_searchForSub )
		Loop
		{
			ws_searchFor := ws_searchForSub%A_Index%
			If ws_searchFor =
			{
				StringReplace, ws_URL, ws_URL, ##%A_Index%##, %ws_searchFor%, All
				If ErrorLevel = 1
					Break
				Else
					continue
			}

			StringReplace, ws_searchFor, ws_searchFor, %A_Space%, #+SPACE+#, All

			If ws_Encode[%ws_pressedButton%] = URL
				ws_searchFor := func_UrlEncode(ws_searchFor)

			If ws_Encode[%ws_pressedButton%] = Unicode
			{
				If (Ansi2UTF8(UTF82Ansi(ws_searchFor)) = ws_searchFor OR Ansi2UTF8(UTF82Ansi(ws_searchFor)) = "")
				   ws_searchFor := Ansi2UTF8(ws_searchFor)
				ws_searchFor := func_UrlEncode(ws_searchFor)
			}

			StringReplace, ws_searchFor, ws_searchFor, #+SPACE+#, %ws_ReplaceSpaces%, All
			StringReplace, ws_URL, ws_URL, ##%A_Index%##, %ws_searchFor%, All
		}

		ws_searchFor = %ws_searchForOld%

		StringReplace, ws_searchFor, ws_searchFor, %A_Space%, #+SPACE+#, All

		if ws_Encode[%ws_pressedButton%] = URL
			ws_searchFor := func_UrlEncode(ws_searchFor)

		if ws_Encode[%ws_pressedButton%] = Unicode
		{
			If (Ansi2UTF8(UTF82Ansi(ws_searchFor)) = ws_searchFor OR Ansi2UTF8(UTF82Ansi(ws_searchFor)) = "")
			   ws_searchFor := Ansi2UTF8(ws_searchFor)
			ws_searchFor := func_UrlEncode(ws_searchFor)
		}

		StringReplace, ws_searchFor, ws_searchFor, #+SPACE+#, %ws_ReplaceSpaces%, All

		StringReplace, ws_URL, ws_URL, ###, %ws_searchFor%, All
		If ws_Browser =
			Run, %ws_URL%,, UseErrorlevel
		Else
			Run, % func_Deref(ws_Browser) " """ ws_URL """",, UseErrorlevel
		If ErrorLevel = ERROR
			func_GetErrorMessage( A_LastError, ws_ScriptTitle, ws_Browser " " A_Quote ws_URL A_Quote "`n`n" )
	}

	ws_Check =
	Loop, %ws_Items%
	{
		If ws_Deactivate[%A_Index%] = 1
			continue

		ws_Check := ws_Check ws_Check[%A_Index%]
	}
	IniWrite, %ws_Check%, %ConfigFile%, %ws_ScriptName%, Checkboxes

	If ws_RememberPos = 1
	{
		WinGetPos, ws_RememberPosX, ws_RememberPosY,,, ahk_id %ws_SearchDialogID%
		IniWrite, %ws_RememberPosX%, %ConfigFile%, %ws_ScriptName%, RememberPositionX
		IniWrite, %ws_RememberPosY%, %ConfigFile%, %ws_ScriptName%, RememberPositionY
	}

	Gui, %GuiID_WebSearch%:Destroy

	ws_pressedButton =
	ws_GuiActive =
Return

; -----------------------------------------------------------------------------
ws_sub_HotkeySearch:
	If ws_GuiActive = yes
	{
		GuiControlGet, ws_prevSearch,%GuiID_WebSearch%:, ws_searchFor
		Gosub, WebSearchGuiClose
	}
	ws_GuiActive = yes

	If activAid_ThisHotkey =
		ws_ThisHotkey = %A_ThisHotkey%
	Else
		ws_ThisHotkey = %activAid_ThisHotkey%

	func_GetSelection("UTF-8")

	ws_searchFor := Selection

	IfExist, %ws_searchFor%
	{
		SplitPath, ws_searchFor, ws_searchFor
	}

	Loop
	{
		If ws_Deactivate[%A_Index%] = 1
			continue

		ws_pressedButton = %A_Index%
		If Hotkey_WebSearch[%A_Index%] = %ws_ThisHotkey%
			Break
		If ws_Name[%A_Index%] =
			Return
	}

	If ws_searchFor <>
		ws_ExecuteSearch = 1

	Gosub, ws_sub_SearchDialog
	ws_ExecuteSearch =
Return

; -----------------------------------------------------------------------------
WebSearchGuiEscape:
WebSearchGuiClose:
	func_RemoveMessage( 0x100, "ws_OnMessage_Keys" )
	IniWrite, %ws_searchHistory%, %ConfigFile%, %ws_ScriptName%, SearchHistory

	If ws_RememberPos = 1
	{
		WinGetPos, ws_RememberPosX, ws_RememberPosY,,, A
		IniWrite, %ws_RememberPosX%, %ConfigFile%, %ws_ScriptName%, RememberPositionX
		IniWrite, %ws_RememberPosY%, %ConfigFile%, %ws_ScriptName%, RememberPositionY
	}
	Gui, %GuiID_activAid%:-Disabled
	Gui, %GuiID_WebSearch%:Destroy
	ws_GuiActive =
	ws_pressedButton =
Return

; -----------------------------------------------------------------------------

ws_sub_getFavicon:
	Gosub, sub_temporarySuspend
	Gui,%GuiID_activAid%:+Disabled
	SplashImage,,b1 FS9 W400, %lng_ws_GetIcon% %ws_ICO%
	Gosub, sub_CheckIfSettingsChanged
	GuiControlGet,ws_tempDomain,,ws_URL

	IfNotInString, ws_tempDomain, http://
	{
		IfNotInString, ws_tempDomain, https://
		{
			If ws_tempDomain = http:/
				ws_tempDomain =
			GuiControl,,ws_URL,http://%ws_tempDomain%
			Send,{End}
			Return

		}
	}

	StringGetPos, ws_Pos, ws_tempDomain, /, L3
	StringGetPos, ws_Pos2, ws_tempDomain, /, L4
	StringLeft, ws_tempDomain, ws_tempDomain, %ws_Pos%

	IfNotExist, %ws_IconPath%\
		FileCreateDir, %ws_IconPath%

	If ( ws_Pos > 6 and ws_Pos > 8 )
	{
		ws_ICO_new[%ws_Config%] = %ws_ICO%
		; Favicon von Root laden
		URLDownloadToFile,%ws_tempDomain%/favicon.ico, % ws_ICO_new[%ws_Config%] ".tmp"
		if ErrorLevel = 0
		{
			FileRead, ws_temp, % ws_ICO_new[%ws_Config%] ".tmp"

			IfInString, ws_temp, <html>
				FileDelete, % ws_ICO_new[%ws_Config%] ".tmp"
		}
		Else
		{
			FileDelete, % ws_ICO_new[%ws_Config%] ".tmp"
		}
		; Wenn kein Favicon auf Root, dann prüfe den Quelltext der Startseite
		; auf ein <link rel="SHORTCUT ICON" und extrahiere Url
		IfNotExist, % ws_ICO_new[%ws_Config%] ".tmp"
		{
			URLDownloadToFile,%ws_tempDomain%, %A_Temp%\ws_temp.htm
			if ErrorLevel = 0
			{
				Loop, Read, %A_Temp%\ws_temp.htm
				{
					IfInString, A_LoopReadLine, </head>
						Break
					IfInString, A_LoopReadLine, <body>
						Break

					IfInString, A_LoopReadLine, <link
					IfInString, A_LoopReadLine, SHORTCUT ICON
					{
						ws_FavURL = %A_LoopReadLine%
						StringGetPos, ws_Pos, ws_FavURL, href
						StringMid, ws_FavURL, ws_FavURL, % ws_Pos + 4
						StringGetPos, ws_Pos, ws_FavURL, "
						; " ; end qoute for syntax highlighting
						StringMid, ws_FavURL, ws_FavURL, % ws_Pos + 2
						StringGetPos, ws_Pos, ws_FavURL, "
						; " ; end qoute for syntax highlighting
						StringMid, ws_FavURL, ws_FavURL, 1, %ws_Pos%

						IfNotInstring, ws_FacURL, http
							ws_FavURL = %ws_tempDomain%/%ws_FavURL%

						StringReplace, ws_FavURL, ws_FavURL, //,/,A
						StringReplace, ws_FavURL, ws_FavURL, :/,://,A

						URLDownloadToFile,%ws_FavURL%, % ws_ICO_new[%ws_Config%] ".tmp"
						if ErrorLevel = 0
						{
							FileRead, ws_temp, % ws_ICO_new[%ws_Config%] ".tmp"

							IfInString, ws_temp, <html>
								FileDelete, % ws_ICO_new[%ws_Config%] ".tmp"
						}
						Else
						{
							FileDelete, % ws_ICO_new[%ws_Config%] ".tmp"
						}
					}
				}
				FileDelete, %A_Temp%\ws_temp.htm
			}
			Else
			{
				FileDelete, % ws_ICO_new[%ws_Config%] ".tmp"
			}
		}
		IfNotExist,  % ws_ICO_new[%ws_Config%] ".tmp"
		{
			StringGetPos, ws_tempPos, ws_tempDomain, ., R2
			StringSplit, ws_tempHttp, ws_tempDomain, /
			StringTrimLeft, ws_tempRight, ws_tempDomain, % ws_tempPos+1

			ws_tempDomain = %ws_tempHttp1%//%ws_tempRight%

			URLDownloadToFile,%ws_tempDomain%/favicon.ico, % ws_ICO_new[%ws_Config%] ".tmp"
			if ErrorLevel = 0
			{
				FileRead, ws_temp, % ws_ICO_new[%ws_Config%] ".tmp"

				IfInString, ws_temp, <html>
					FileDelete, % ws_ICO_new[%ws_Config%] ".tmp"
			}
			Else
			{
				FileDelete, % ws_ICO_new[%ws_Config%] ".tmp"
			}
		}

		Gui,%GuiID_activAid%:-Disabled
		SplashImage, Off
		IfNotExist,  % ws_ICO_new[%ws_Config%] ".tmp"
		{
			msgbox,16,, %lng_ws_NoIcon%
			GuiControl,,ws_FavIcon, % "*h16 *w16 *Icon1 "
			ws_ICO_new[%ws_Config%] =
		}
		Else
		{
			GuiControl,,ws_FavIcon, % "*h16 *w16 *Icon1 " ws_ICO_new[%ws_Config%] ".tmp"
		}
	}
	Gosub, sub_temporarySuspend
Return

; -----------------------------------------------------------------------------
ws_sub_Browser:
	ws_SetBrowserForAll = 1
	Loop, %ws_Items%
	{
		If ( ws_Browser_new[%A_Index%] <> ws_Browser_new[%ws_Config%] OR ws_Browser_new[%ws_Config%] ="")
		{
			ws_SetBrowserForAll = 0
			break
		}
	}

	Gui, +Disabled
	GuiDefault("WebSearchBrowser", "+LastFound +Owner" GuiID_activAid)
	Gosub, GuiDefaultFont
	Gui, Add, Text, y+10, %lng_ws_Browser%
	Gui, Add, Edit, y+8 x8 w400 R1 -Multi vws_Browser_new[%ws_Config%], % ws_Browser_new[%ws_Config%]
	Gui, Add, Button, -Wrap yp+0 x+5 w100 gws_sub_SelectBrowser, %lng_Browse%
	Gui, Add, CheckBox, -Wrap y+5 x10 vws_SetBrowserForAll Checked%ws_SetBrowserForAll%, %lng_ws_BrowserForAll%

	Gui, Add, Button, -Wrap x180 w80 Default gws_sub_SetBrowserOptions, %lng_OK%
	Gui, Add, Button, -Wrap yp+0 x+8 w80 gWebSearchBrowserGuiClose, %lng_Cancel%
	Gui, Show, AutoSize, %ws_ScriptTitle% - Browser
Return

ws_sub_SelectBrowser:
	Gui, +OwnDialogs
	ws_Suspended = %A_IsSuspended%
	If ws_Suspended = 0
		Suspend, On

	FileSelectFile, ws_Browser,, %A_Programfiles%, %lng_ws_SelectBrowser%, %lng_ws_FileTypeEXE%
	ControlSetText, Edit1, %ws_Browser%, %ws_ScriptTitle% - Browser

	If ws_Suspended = 0
		Suspend, Off
Return

ws_sub_SetBrowserOptions:
	Gui, %GuiID_activAid%:-Disabled
	Gui, %GuiID_WebSearchBrowser%:Submit
	Gosub, WebSearchBrowserGuiClose
	If ws_SetBrowserForAll = 1
	{
		Loop, %ws_Items%
		{
			ws_Browser_new[%A_Index%] := ws_Browser_new[%ws_Config%]
		}
	}
	WinActivate, %ws_ScriptTitle%
	GuiControl,%GuiID_activAid%:,ws_BrowserIcon, % "*h16 *w16 *Icon1 " ws_Browser_new[%ws_Config%]
	Gosub, ws_sub_Changed
	func_SettingsChanged( "WebSearch" )
Return
; -----------------------------------------------------------------------------
; Das Fenster für die Positionierungsoptionen
ws_sub_CenterApps:
	Gui, +Disabled
	GuiDefault("WebSearchCenter", "+LastFound +Owner" GuiID_activAid)
	Gosub, GuiDefaultFont
	if ( ws_AlwaysCenter = 0 AND ws_RememberPos = 0 AND ws_OnMouseCursor = 0)
		ws_Checked1 = 1
	Else
		ws_Checked1 = 0
	Gui, Add, Radio, -Wrap vws_RememberPos Checked%ws_RememberPos% y+10,%lng_ws_RememberPos%
	Gui, Add, Radio, -Wrap vws_AlwaysCenter Checked%ws_AlwaysCenter% y+10,%lng_ws_CenterAll%
	Gui, Add, Radio, -Wrap vws_OnMouseCursor Checked%ws_OnMouseCursor% y+10,%lng_ws_OnMouseCursor%
	Gui, Add, Radio, Checked%ws_Checked1% y+10,%lng_ws_Apps%
	Gui, Add, Edit, y+8 x28 w480 R1 -Multi vws_CenterApps, %ws_CenterApps%

	Gui, Add, Button, -Wrap x180 w80 Default gws_sub_SetCenterApps, %lng_OK%
	Gui, Add, Button, -Wrap yp+0 x+8 w80 gWebSearchCenterGuiClose, %lng_Cancel%
	Gui, Show, AutoSize, %ws_ScriptTitle% - %lng_ws_CenterApps%
Return

ws_sub_SetCenterApps:
	Gui, %GuiID_activAid%:-Disabled
	Gui, %GuiID_WebSearchCenter%:Submit
	Gosub, WebSearchCenterGuiClose
	if ws_AlwaysCenter = 2
		ws_AlwaysCenter = 0
	func_SettingsChanged( "WebSearch" )
Return

WebSearchBrowserGuiEscape:
WebSearchBrowserGuiClose:
	WinGetPos, ws_GuiX, ws_GuiY,,, A
	Gui, %GuiID_activAid%:-Disabled
	Gui, %GuiID_WebSearchBrowser%:Destroy
	ws_GuiActive =
	ws_pressedButton =
Return

WebSearchCenterGuiEscape:
WebSearchCenterGuiClose:
	WinGetPos, ws_GuiX, ws_GuiY,,, A
	Gui, %GuiID_activAid%:-Disabled
	Gui, %GuiID_WebSearchCenter%:Destroy
	ws_GuiActive =
	ws_pressedButton =
Return

ws_OnMessage_Keys:
	If (A_Gui <> 7 OR A_GuiControl <> "")
	{
		ws_DropDownVisible = 0
		Return
	}

	ws_Key = %#wParam%
	GetKeyState, ws_CtrlState, Ctrl
	If ws_CtrlState = D
		ws_Key := ws_Key + 1000
	GetKeyState, ws_ShiftState, Shift
	If ws_ShiftState = D
		ws_Key := ws_Key + 2000
	GetKeyState, ws_AltState, Alt
	If ws_AltState = D
		ws_Key := ws_Key + 4000

	;tooltip, %ws_Key%

	If ( (ws_Key = 38 OR ws_Key = 40) AND ws_DropDownVisible <> 1 )
	{
		Send, {F4}
		ws_DropDownVisible = 1
	}

	If (ws_Key = 13 AND ws_DropDownVisible = 1)
	{
		GuiControlGet, ws_searchFor,,,
		Send, {F4}
		GuiControl,Text, ws_searchFor, %ws_searchFor%
	}

	If (ws_Key = 9 OR ws_Key = 27 OR ws_Key = 13)
		ws_DropDownVisible = 0


	If (ws_Key = 46 AND ws_DropDownVisible = 1 AND ws_DisableHistory = 0)
	{
		GuiControlGet, ws_searchFor,,,
		StringReplace, ws_searchHistory, ws_searchHistory, %ws_searchFor%|,
		GuiControl,, ws_searchFor, |%ws_searchHistory%
	}
Return
