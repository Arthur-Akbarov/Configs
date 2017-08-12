; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               LeoToolTip
; -----------------------------------------------------------------------------
; Prefix:             leo_
; Version:            1.3.2
; Date:               2008-05-23
; Author:             Wolfgang Reszel, Michael Telgkamp
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; TODO:
; *	es gibt nun englische Begriffe auf den Deutsch<>Englisch-Seiten!
;	Bei allen anderen Sprachen ist es immernoch deutsch!
; * Trotz kein-Treffer Forumsartikel anzeigen!
; * seltener Bug bei pda.leo.org: Es wird ein Forumsmenü erstellt, aber nicht gefüllt
;	beim Löschen gibs dann nen Error



; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_LeoToolTip:
	Prefix = leo
	%Prefix%_ScriptName    = LeoToolTip
	%Prefix%_ScriptVersion = 1.3.2
	%Prefix%_Author        = Wolfgang Reszel, Michael Telgkamp, ëRiC
	RequireExtensions      =
	CustomHotkey_LeoToolTip = 0           ; automatisches benutzerdefinierbares Tastaturkürzel? (1 = ja)
	Hotkey_LeoToolTip       =             ; Standard-Hotkey
	HotkeyPrefix_LeoToolTip =             ; Präfix, welches vor immer vor dem Tastaturkürzel gesetzt wird
	IconFile_On_LeoToolTip  = %A_WinDir%\system32\shell32.dll
	IconPos_On_LeoToolTip   = 219

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %leo_ScriptName% - markiertes Wort übersetzen
		Description                   = Übersetzt mittels dict.leo.org das markierte Wort und zeigt das Ergebnis als Tooltip an.
		lng_leo_NothingFound          = Suchbegriff nicht gefunden
		lng_leo_Error                 = Fehler beim Zugriff auf LEO.`nVermutlich wurden zu viele Abfragen in Folge an den Server geschickt.`nLEO sperrt in diesem Fall ihre IP-Adresse für 2 Minuten.`n`nKlicken Sie mit der rechten Maustaste auf diese Meldung,`num die Fehlerseite aufzurufen.
		lng_leo_LeoOnMbutton          = Suche automatisch ausführen, wenn ein Wort mit der mittleren Maustaste markiert wird. (MouseClip)
		lng_leo_Searching             = Verbinde mit
		lng_leo_Server                = Server
		lng_leo_ServerTip             = pda.leo.org ist schneller, aber bei vielen Anfragen in kurzer Zeit gibt es eine 2-Minuten-Sperrung.
		lng_leo_ToolTipTimeout        = Sekunden, nach denen der Tooltip automatisch verschwindet
		lng_leo_UseMenu               = Menü statt eines Tooltips einblenden, womit die ausgewählte Übersetzung direkt eingefügt werden kann
		lng_leo_GotoURL               = Suchergebnisse mit dict.leo.org im Browser anzeigen
		lng_leo_GotoURLCompact        = im Browser anzeigen
		lng_leo_AutoCorrect           = Verwende ähnlichen Suchbegriff
		lng_leo_Lang1                 = Deutsch-Englisch
		lng_leo_Lang2                 = Deutsch-Französisch
		lng_leo_Lang3                 = Deutsch-Spanisch
		lng_leo_Lang4                 = Deutsch-Italienisch
		lng_leo_SearchFor             = Bitte Suchbegriff eingeben
		lng_leo_CheckProxy            = Bitte prüfen Sie auch Ihre Proxy-Einstellungen im Internet Explorer.`nLeoToolTip funktioniert nicht bei Proxies mit manueller Anmeldung.`nEvtl. hilft die Aktivierung von "HTTP 1.1 über Proxy-Verbindungen verwenden" in den Internetoptionen unter Erweitert.`nUnter Umständen könnte auch der Server nicht erreichbar sein.
		lng_leo_Browser               = Browser für Rechtsklick auf ToolTip
		lng_leo_BrowserError          = Der Browser kann evtl. nicht gestartet werden, Windows meldet:`n
		lng_leo_SelectBrowser         = Auswählen ...
		lng_leo_FileTypeEXE           = Programme (*.exe)
		lng_leo_TranslationToClipboard= Ausgewählte Übersetzung wird nicht eingefügt, sondern in die Zwischenablage gelegt
		lng_leo_CompactMenu           = Kompakteres Menü
		lng_leo_SelectWordAtCursor    = Wenn kein Text markiert ist, wird automatisch versucht, das Wort am Cursor zu markieren
		lng_leo_ParseError            = Die Rückmeldung von Leo.org konnte nicht ausgewertet werden.`nBitte testen Sie einen anderen Leo-Server.`nSollte das Problem dauerhaft bestehen, melden Sie den Fehler bitte im Bugtracker unter http://activaid.rumborak.de!
		lng_leo_ForumTopics           = Forums-Beiträge`, die den Suchbegriff enthalten:
		lng_leo_DisplayForumResults   = Das Menü um passende Foren-Beiträge ergänzen
		lng_leo_SubMenuForumResults   = Foren-Beiträge in Untermenü anzeigen
		lng_leo_SimilarWords          = Orthographisch ähnliche Wörter
		lng_leo_lngShort			  = de
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %leo_ScriptName% - translate selected word
		Description                   = Translates the selected word with dict.leo.org and shows the result as a tooltip.
		lng_leo_NothingFound          = search item not found
		lng_leo_Error                 = Error while accessing LEO.`nMaybe you've sent to many queries in a short time.`nIn that case, LEO locks your IP-address for 2 minutes.
		lng_leo_LeoOnMbutton          = Search automatically when selecting a word with the middle mouse-button. (MouseClip)
		lng_leo_Searching             = Connecting to
		lng_leo_Server                = Server
		lng_leo_ServerTip             = pda.leo.org is faster, but you will be locked for 2 minutes for to many queries in a short time.
		lng_leo_ToolTipTimeout        = Seconds, when the tooltip automatically disappears
		lng_leo_UseMenu               = Show a menu instead of a tooltip to make it possible to directly paste a translation
		lng_leo_GotoURL               = Show results with dict.leo.org in browser
		lng_leo_GotoURLCompact        = Show in browser
		lng_leo_AutoCorrect           = Using similar search item
		lng_leo_Lang1                 = German-English
		lng_leo_Lang2                 = German-French
		lng_leo_Lang3                 = German-Spanish
		lng_leo_Lang4                 = German-Italian
		lng_leo_SearchFor             = Please enter search item
		lng_leo_CheckProxy            = Please check also your proxy settings in Internet Explorer,`nLeoToolTip does not work at proxies with manual authentification.`nAlso the Leo-server could be down at the moment.
		lng_leo_Browser               = Browser for right-click on tooltip
		lng_leo_BrowserError          = Maybe the browser can't be launched, windows returns:`n
		lng_leo_SelectBrowser         = Choose...
		lng_leo_FileTypeEXE           = Programs (*.exe)
		lng_leo_TranslationToClipboard= Selected translation will be stored in the clipboard instead of pasting it
		lng_leo_CompactMenu           = More compact menu
		lng_leo_SelectWordAtCursor    = Try to select the word at the cursor position, if no text is selected
		lng_leo_ParseError            = The result from Leo.org could not be parsed.`nPlease test another Leo-Server.`nIf the problem does not disappear please report the bug athttp://activaid.rumborak.de!
		lng_leo_ForumTopics           = Topics of Forum containing search term:
		lng_leo_DisplayForumResults   = Add matching forum topics to the menu
		lng_leo_SubMenuForumResults   = show forum topics in submenu
		lng_leo_SimilarWords          = Orthographically similar words
		lng_leo_lngShort			  = en
	}

	func_HotkeyRead( "leo_Hotkey1", ConfigFile , leo_ScriptName, "Hotkey_LeoToolTip", "leo_sub_Hotkey1", "^+l", "$" )
	func_HotkeyRead( "leo_Hotkey2", ConfigFile , leo_ScriptName, "Hotkey2_LeoToolTip", "leo_sub_Hotkey2", "", "$" )
	func_HotkeyRead( "leo_Hotkey3", ConfigFile , leo_ScriptName, "Hotkey3_LeoToolTip", "leo_sub_Hotkey3", "", "$" )
	func_HotkeyRead( "leo_Hotkey4", ConfigFile , leo_ScriptName, "Hotkey4_LeoToolTip", "leo_sub_Hotkey4", "", "$" )

	RegisterAdditionalSetting( "leo", "CompactMenu", 0 )
	RegisterAdditionalSetting( "leo", "SelectWordAtCursor", 0 )
	RegisterAdditionalSetting( "leo", "DisplayForumResults", 1 )
	RegisterAdditionalSetting( "leo", "SubMenuForumResults", 1 )

	IniRead, leo_UseMenu , %ConfigFile%, LeoToolTip, UseMenu, 0
	IniRead, leo_NumOfResults, %ConfigFile%, LeoToolTip, NumOfResults, 5
	IniRead, leo_EnableMButton, %ConfigFile%, LeoToolTip, LeoOnMButton, 0
	IniRead, leo_TranslationToClipboard, %ConfigFile%, LeoToolTip, TranslationToClipboard, 0
	IniRead, leo_Server, %ConfigFile%, LeoToolTip, LeoServerURL, pda.leo.org
	IniRead, leo_ToolTipTimeout, %ConfigFile%, LeoToolTip, ToolTipTimeout, 10
	IniRead, leo_Browser, %ConfigFile%, LeoToolTip, Browser, %A_Space%
	leo_BrowserDeref := func_Deref(leo_Browser)
	IniRead, leo_HistoryFile, %ConfigFile%, LeoToolTip, HistoryFile, %A_Space%
	IniRead, leo_HistoryFileOnMenuCall, %ConfigFile%, LeoToolTip, HistoryFileOnMenuCall, 0
	IniRead, leo_DisplayForumResults, %ConfigFile%, LeoToolTip, DisplayForumResults, 1
	IniRead, leo_SubMenuForumResults, %ConfigFile%, LeoToolTip, SubMenuForumResults, 1
	IniRead, leo_MaxForumTextLen, %ConfigFile%, LeoToolTip, MaxForumTextLen, 80

	; Liste der Texte, die aus dem Ergebnis entfernt werden sollen. (Regulärer Ausdruck)
	leo_RemoveBeforeReplace := "i)\.{3}|j[mnd]{3}\.(/| |$)|etw\. |s(b|o)\.(/| |$)|sth\.(/| |$)|^to |^it |^the |^d(er|ie|as) | ad(j|v)\.| pl\.| also: .*| rarely: .*| auch: .*| selten: .*"

	leo_WebBrowsers = OpWindow,MozillaUIWindowClass,IEFrame,MozillaWindowClass

	leo_AlphaNums := "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	leo_CleanChars = `%|&\$|\$&|\$#|#|\$|&|\(|\)|\[|\]|\{|\}|^ +| +$|@

	leo_SearchCache = |
Return

SettingsGui_LeoToolTip:
	func_HotkeyAddGuiControl( lng_Hotkey " " lng_leo_Lang1, "leo_Hotkey1", "xs+10 y+6 w180" )
	func_HotkeyAddGuiControl( lng_Hotkey " " lng_leo_Lang2, "leo_Hotkey2", "xs+10 y+6 w180" )
	func_HotkeyAddGuiControl( lng_Hotkey " " lng_leo_Lang3, "leo_Hotkey3", "xs+10 y+6 w180" )
	func_HotkeyAddGuiControl( lng_Hotkey " " lng_leo_Lang4, "leo_Hotkey4", "xs+10 y+6 w180" )

	If Enable_MouseClip = 1
		Gui, Add, Checkbox, -Wrap xs+10 y+10 gleo_sub_MouseClip vleo_EnableMButton Checked%leo_EnableMButton%, %lng_leo_LeoOnMbutton%
	Gui, Add, Checkbox, -Wrap xs+10 y+5 gsub_CheckIfSettingsChanged vleo_UseMenu Checked%leo_UseMenu%, %lng_leo_UseMenu%
	Gui, Add, Checkbox, -Wrap xs+20 y+5 gsub_CheckIfSettingsChanged vleo_TranslationToClipboard Checked%leo_TranslationToClipboard%, %lng_leo_TranslationToClipboard%
	Gui, Add, Text, xs+10 y+20, %lng_leo_Server%:
	leo_Servers = odict.leo.org|dict.leo.org|pda.leo.org
	Gui, Add, DropDownList, x+5 yp-4 gsub_CheckIfSettingsChanged vleo_Server, %leo_Servers%
	GuiControl,Choose,leo_Server,%leo_Server%
	Gui, Add, Text, xs+10 y+3, %lng_leo_ServerTip%
	Gui, Add, Text, xs+10 y+11, %lng_leo_ToolTipTimeout%:
	Gui, Add, Edit, x+5 yp-3 -Wrap r1 Number w40 gsub_CheckIfSettingsChanged vleo_ToolTipTimeout, %leo_ToolTipTimeout%
	Gui, Add, UpDown, Range1-99, %leo_ToolTipTimeout%

	Gui, Add, Text, xs+10 y+20, %lng_leo_Browser%:
	Gui, Add, Edit, x+5 yp-3 R1 -Wrap w290 gsub_CheckIfSettingsChanged vleo_Browser, %leo_Browser%
	Gui, Add, Button, x+5 -Wrap w80 h21 gleo_sub_SelectBrowser, %lng_leo_SelectBrowser%
Return

leo_sub_SelectBrowser:
	Gui, +OwnDialogs
	leo_Suspended = %A_IsSuspended%
	If leo_Suspended = 0
		Suspend, On

	FileSelectFile, leo_Browser_tmp,, %A_Programfiles%, %lng_leo_Browser%, %lng_leo_FileTypeEXE%
	If ErrorLevel = 0
		GuiControl,, leo_Browser, %leo_Browser_tmp%

	If leo_Suspended = 0
		Suspend, Off
Return

leo_sub_MouseClip:
	Gosub, sub_CheckIfSettingsChanged
	GuiControlGet, leo_EnableMButton_tmp,,leo_EnableMButton
	If (leo_EnableMButton_tmp = 1 AND Enable_ThesauroToolTip <> "")
		GuiControl,,ttt_EnableMButton,0
Return

SaveSettings_LeoToolTip:
	IniWrite, %leo_UseMenu%, %ConfigFile%, LeoToolTip, UseMenu
	IniWrite, %leo_EnableMButton%, %ConfigFile%, LeoToolTip, LeoOnMButton
	IniWrite, %leo_Server%, %ConfigFile%, LeoToolTip, LeoServerURL
	IniWrite, %leo_ToolTipTimeout%, %ConfigFile%, LeoToolTip, ToolTipTimeout
	IniWrite, %leo_Browser%, %ConfigFile%, LeoToolTip, Browser
	leo_BrowserDeref := func_Deref(leo_Browser)
	IniWrite, %leo_TranslationToClipboard%, %ConfigFile%, LeoToolTip, TranslationToClipboard
	IniWrite, %leo_HistoryFile%, %ConfigFile%, LeoToolTip, HistoryFile
	IniWrite, %leo_HistoryFileOnMenuCall%, %ConfigFile%, LeoToolTip, HistoryFileOnMenuCall
	IniWrite, %leo_MaxForumTextLen%, %ConfigFile%, LeoToolTip, MaxForumTextLen

	func_HotkeyWrite( "leo_Hotkey1", ConfigFile , leo_ScriptName, "Hotkey_LeoToolTip" )
	func_HotkeyWrite( "leo_Hotkey2", ConfigFile , leo_ScriptName, "Hotkey2_LeoToolTip" )
	func_HotkeyWrite( "leo_Hotkey3", ConfigFile , leo_ScriptName, "Hotkey3_LeoToolTip" )
	func_HotkeyWrite( "leo_Hotkey4", ConfigFile , leo_ScriptName, "Hotkey4_LeoToolTip" )
Return

AddSettings_LeoToolTip:
Return

CancelSettings_LeoToolTip:
Return

DoEnable_LeoToolTip:
	If leo_EnableMButton
		RegisterHook( "MButton", "LeoToolTip" )
	EnableMButton_LeoToolTip = %leo_EnableMButton%
	func_HotkeyEnable("leo_Hotkey1")
	func_HotkeyEnable("leo_Hotkey2")
	func_HotkeyEnable("leo_Hotkey3")
	func_HotkeyEnable("leo_Hotkey4")

	RegisterAction("leo_Hotkey1",lng_leo_Lang1,"leo_sub_Hotkey1")
	RegisterAction("leo_Hotkey2",lng_leo_Lang2,"leo_sub_Hotkey2")
	RegisterAction("leo_Hotkey3",lng_leo_Lang3,"leo_sub_Hotkey3")
	RegisterAction("leo_Hotkey4",lng_leo_Lang4,"leo_sub_Hotkey4")
Return

DoDisable_LeoToolTip:
	leo_BreakLoop = 1
	If leo_EnableMButton
		UnRegisterHook( "MButton", "LeoToolTip" )
	EnableMButton_LeoToolTip = %leo_EnableMButton%
	func_HotkeyDisable("leo_Hotkey1")
	func_HotkeyDisable("leo_Hotkey2")
	func_HotkeyDisable("leo_Hotkey3")
	func_HotkeyDisable("leo_Hotkey4")

	unRegisterAction("leo_Hotkey1")
	unRegisterAction("leo_Hotkey2")
	unRegisterAction("leo_Hotkey3")
	unRegisterAction("leo_Hotkey4")
Return

DefaultSettings_LeoToolTip:
Return

OnExitAndReload_LeoToolTip:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

leo_sub_Hotkey1:
	leo_LangStr = ende
	Gosub, sub_Hotkey_LeoToolTip
Return

leo_sub_Hotkey2:
	leo_LangStr = frde
	Gosub, sub_Hotkey_LeoToolTip
Return

leo_sub_Hotkey3:
	leo_LangStr = esde
	Gosub, sub_Hotkey_LeoToolTip
Return

leo_sub_Hotkey4:
	leo_LangStr = itde
	Gosub, sub_Hotkey_LeoToolTip
Return

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_LeoToolTip:
	WinGetClass, leo_WinClass, A
	Coordmode, Caret, Screen

	If leo_WinClass Contains %leo_WebBrowsers%
	{
		leo_ttX =
		leo_ttY =
	}
	Else
	{
		leo_ttX := A_CaretX+10
		leo_ttY := A_CaretY+10
	}
	gosub, leo_sub_Search
	If ErrorLevel = 1
		Return
	SetTimer, leo_tim_ToolTipOff, % leo_ToolTipTimeout * 1000
	If ( leo_UseMenu <> 1 OR InStr(leo_FinalResult,lng_leo_NothingFound) )
	{
		Gosub, DoDisable_LeoToolTip
		leo_BreakLoop =
		Loop
		{
			Input, leo_SingleKey, L1 I V T0.5, {AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}
			If leo_BreakLoop = 1
				Break
			If ErrorLevel = TimeOut
				Continue
			Break
		}
		StringReplace, leo_SingleKey, ErrorLevel, Endkey:,,A
		Gosub, DoEnable_LeoToolTip
	}
	Gosub, leo_tim_ToolTipOff
	If ( leo_UseMenu <> 1 OR InStr(leo_FinalResult,lng_leo_NothingFound) )
	{
		If leo_SingleKey = %Hotkey_leo_Hotkey1%
			Gosub, leo_sub_Hotkey1
		If leo_SingleKey = %Hotkey_leo_Hotkey2%
			Gosub, leo_sub_Hotkey2
		If leo_SingleKey = %Hotkey_leo_Hotkey3%
			Gosub, leo_sub_Hotkey3
	}
Return

MButton_LeoToolTip:
	If (leo_EnableMButton = 1 AND Enable_MouseClip = 1)
	{
		mc_NoPaste = yes
		leo_ttX =
		leo_ttY =
		leo_LangStr = ende
		gosub, leo_sub_Search
		MButton_send =
	}
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

leo_sub_Search:
	AutoTrim, On
	Coordmode, ToolTip, Screen
	Coordmode, Menu, Screen

	If leo_NotFound =
	{
		func_GetSelection()
		leo_searchOrig :=  Selection
		If (leo_SelectWordAtCursor = 1 AND leo_searchOrig = "")
		{
			Send, ^{Left}^+{Right}
			func_GetSelection()
			leo_searchOrig :=  Selection
		}
	}
	Else
		leo_NotFound++

	If leo_searchOrig =
	{
		StringUpper, leo_Text, leo_LangStr
		leo_Text := lng_leo_SearchFor " (" SubStr(leo_Text,1,2) " <-> " SubStr(leo_Text,3,2) "):"
		InputBox, leo_searchOrig, %leo_ScriptName% (%ScriptTitle%), %leo_Text%,,,115,,,,,%leo_LastSearchOrig%
		If ErrorLevel = 1
			Return
	}

	leo_ServerOrg = %leo_Server%
	If leo_RetryWithServer <>
	{
		leo_Server = %leo_RetryWithServer%
		leo_RetryWithServer =
	}

	; Zeilenumbrüche entfernen
	leo_searchOrig := RegExReplace(leo_searchOrig, "\r\n|\r|\n"," ")

	; Variablenzeichen und Klammern entfernen (Aufgabe)
	leo_searchClean := RegExReplace(leo_searchOrig,leo_CleanChars,"")

	leo_searchFor := func_URLEncode(leo_searchClean)

	If leo_DisplayForumResults = 1
		leo_SearchCache = |

	leo_Temp := InStr(leo_SearchCache, "|" leo_LangStr " " leo_searchFor "|")
	If leo_Temp
	{
		leo_LastLangStr = %leo_LangStr%
		leo_lastSearch  = %leo_searchFor%
		leo_FinalResult := leo_ResultCache[%leo_Temp%]
	}

	If ( ( leo_LangStr leo_searchFor <> leo_LastLangStr leo_lastSearch AND leo_searchFor <> "" ) OR (leo_lastSearch = "" AND leo_searchFor ="") )
	{
		If leo_NotFound =
			tooltip, %lng_leo_Searching% %leo_Server% ..., %leo_ttX%, %leo_ttY%, 8
		Else
			tooltip, %lng_leo_AutoCorrect% %leo_searchOrig% ..., %leo_ttX%, %leo_ttY%, 8

		leo_Query :=
		leo_FinalResult :=
		; neue xml abfrage
		if (leo_Server == "dict.leo.org") {
			leo_Query := httpQUERY(URL:="http://" leo_Server "/dictQuery/m-vocab/" leo_langStr "/query.xml?lp=" leo_langStr "&lang=" lng_leo_lngShort "&search=" leo_searchFor)
			leo_cleanResult( leo_Query )
			leo_ParseTmp := 0
			leo_tmp := 0
			leo_resultCount := 0

			Loop, %leo_NumOfResults% {
				Loop, 2 {
					StringGetPos, leo_ParseTmp, leo_Query, <repr>,, %leo_tmp%
					if (ErrorLevel or leo_ParseTmp < 0)
						break
					leo_ParseTmp += 7
					StringGetPos, leo_tmp, leo_Query, </repr>,, %leo_ParseTmp%
					str := SubStr(leo_Query, leo_ParseTmp, leo_tmp - leo_ParseTmp + 1)
					leo_FinalResult := leo_FinalResult str
					if (A_Index == 1)
						leo_FinalResult := leo_FinalResult A_Tab
				}
				if (ErrorLevel or leo_ParseTmp < 0)
					if(leo_resultCount==0) {
						leo_NotFound = 1
					}
				leo_FinalResult := leo_FinalResult "`n"
				leo_resultCount++
			}
		}
		; fallback server handling
		else {
			leo_Query := httpQUERY(URL:="http://" leo_Server "/?lp=" leo_langStr "&relink=off&sectHdr=off&spellToler=on&search=" leo_searchFor)

			StringGetPos, leo_ParseTmp, leo_Query, Unmittelbare Treffer
			If leo_Parsetmp = -1
				StringGetPos, leo_Parsetmp, leo_Query, Weitere Treffer

			StringTrimLeft, leo_Result, leo_Query, %leo_Parsetmp%

			; erst alle " entfernen, da sie nicht benötigt werden
			StringReplace, leo_Result, leo_Result, ",, A ; " ; end qoute for syntax highlighting
			; verschiedene Tags entfernen
			leo_cleanResult( leo_Result )
			leo_Line = 0
			Loop, Parse, leo_Result, `n
			{
				If (A_Index/2 > leo_NumOfResults+1)
				{
					break
				}
				IfInstring, A_LoopField, Sie haben Ihr Zugriffslimit überschritten
				{
					leo_FinalResult = %lng_leo_Error%!
					leo_SearchFor =
					If leo_Server <> dict.leo.org
						leo_RetryWithServer = dict.leo.org
					Break
				}
				If leo_Line = 1
				{
					leo_Line = 2
					StringGetPos, leo_tmp, A_LoopField, <a
					StringLeft, leo_FromLang, A_LoopField, %leo_tmp%
					If leo_tmp < 1
						leo_FromLang = %A_LoopField%
					IfInstring, A_LoopField, </tr>
						Break

					If (InStr(A_LoopField,"<html>") OR InStr(A_LoopField," lieferte keine Treffer"))
					{
						If leo_NotFound = 1
							leo_FinalResult = %lng_leo_NothingFound%: %leo_searchOrig%!
						Else
							leo_NotFound = 1
						Break
					}
					If A_LoopField =
						Break
					IfInstring, A_LoopField, <head>
					{
						leo_NotFound = 1
						leo_FinalResult = %lng_leo_Error%!
						leo_SearchFor =
						If leo_Server <> dict.leo.org
							leo_RetryWithServer = dict.leo.org
						Break
					}
					StringGetPos, leo_tmp, A_LoopField, <img border="0" alt
					StringLeft, leo_FromLang, A_LoopField, %leo_tmp%
					If leo_tmp < 1
						leo_FromLang = %A_LoopField%
				}
				Else If leo_Line = 2
				{
					leo_Line = 1
					StringGetPos, leo_tmp, A_LoopField, </tr
					StringLeft, leo_ToLang, A_LoopField, %leo_tmp%
					leo_FinalResult = %leo_FinalResult%%leo_FromLang%%A_Tab%%leo_ToLang%`r`n
					IfInstring, A_LoopField, </table>
						Break
				}
				Else
				{
					leo_Line = 1
				}
			}
		}
		StringTrimRight, leo_FinalResult, leo_FinalResult, 2
		If leo_Query =
			If leo_Parsetmp = -1
				leo_FinalResult = %lng_leo_NothingFound%: %leo_searchOrig%!`r`n%lng_leo_ParseError%
			Else
				leo_FinalResult = %lng_leo_NothingFound%: %leo_searchOrig%!`r`n%lng_leo_CheckProxy%
	}
	Else
		leo_searchFor = %leo_lastSearch%

	leo_Server = %leo_ServerOrg%

	If leo_NotFound = 1
	{
		leo_Result := leo_createSimilarsMenu()
		if leo_Result
		{
			leo_NotFound =
			Return
		}

		leo_FinalResult = %lng_leo_NothingFound%: %leo_searchOrig%!
	}
	If leo_RetryWithServer <>
	{
		Gosub, leo_sub_Search
		Return
	}

	leo_Temp := StrLen(leo_SearchCache)
	If (!InStr(leo_FinalResult, lng_leo_NothingFound ":") AND !InStr(leo_FinalResult,lng_leo_Error) AND !InStr(leo_FinalResult,lng_leo_CheckProxy))
	{
		leo_SearchCache = %leo_SearchCache%%leo_LangStr% %leo_searchFor%|
		leo_ResultCache[%leo_Temp%] = %leo_FinalResult%
	}

	leo_FinalResultTip := RegExReplace(leo_FinalResult,"i)<B>|</B>", "")
	StringReplace, leo_FinalResultTip, leo_FinalResultTip, %A_Tab%, % "  =  ", All
	leo_NotFound =

	leo_lastSearch = ; %leo_searchFor%
	leo_lastSearchOrig = %leo_searchOrig%
	leo_LastLangStr = ; %leo_LangStr%
	MouseGetPos, leo_startX, leo_startY

	StringLeft, leo_Lang1, leo_LangStr, 2
	StringRight, leo_Lang2, leo_LangStr, 2
	StringUpper, leo_Lang1, leo_Lang1
	StringUpper, leo_Lang2, leo_Lang2

	If (leo_UseMenu = 1 AND !InStr(leo_FinalResult, lng_leo_NothingFound ": " leo_searchOrig) AND !InStr(leo_FinalResult, lng_leo_CheckProxy) AND !InStr(leo_FinalResult, lng_leo_Error))
	{
		leo_Index = 0
		Loop, Parse, leo_FinalResult, `n, `r
		{
			leo_Split = %A_LoopField%

			StringSplit, leo_Split, leo_Split, %A_Tab%

			IfInString, leo_Split1, <b>
			{
				leo_Index++
				leo_MenuString = %leo_Split2%
				leo_MenuStringB = %leo_Split1%
				leo_HistLang = %leo_Lang2%
				If leo_CompactMenu = 0
					leo_MenuStringB = «%leo_Lang2%-%leo_Lang1%»      %leo_MenuStringB%

				leo_MenuString := RegExReplace(leo_MenuString,"i)<B>|</B>", "")
				leo_MenuStringB := RegExReplace(leo_MenuStringB,"i)<B>|</B>", "")

				leo_MenuItem[%leo_Index%] = %leo_MenuString%

				If (StrLen(leo_MenuString) > 85)
					leo_MenuString := func_StrLeft(leo_MenuString, 85) "..."
				If (StrLen(leo_MenuStringB) > 85)
					leo_MenuStringB := func_StrLeft(leo_MenuStringB, 85) "..."

				If not leo_CompactMenu
				{
					StringMid, leo_Key, leo_AlphaNums, leo_Index, 1
					Menu, LeoToolTip, Add, &%leo_Key% - %leo_MenuString%%A_Tab%%leo_MenuStringB%, leo_sub_MenuCall
				}
				Else
					Menu, LeoToolTip, Add, %leo_MenuString% = %leo_MenuStringB%, leo_sub_MenuCall

			}
			IfInString, leo_Split2, <b>
			{
				leo_Index++
				leo_MenuString = %leo_Split1%
				leo_MenuStringB =%leo_Split2%
				leo_MenuString = %leo_MenuString%
				leo_HistLang = %leo_Lang1%
				If leo_CompactMenu = 0
					leo_MenuStringB = «%leo_Lang1%-%leo_Lang2%»      %leo_MenuStringB%

				leo_MenuString := RegExReplace(leo_MenuString,"i)<B>|</B>", "")
				leo_MenuStringB := RegExReplace(leo_MenuStringB,"i)<B>|</B>", "")

				leo_MenuItem[%leo_Index%] = %leo_MenuString%

				If (StrLen(leo_MenuString) > 85)
					leo_MenuString := func_StrLeft(leo_MenuString, 85) "..."
				If (StrLen(leo_MenuStringB) > 85)
					leo_MenuStringB := func_StrLeft(leo_MenuStringB, 85) "..."

				If not leo_CompactMenu
				{
					StringMid, leo_Key, leo_AlphaNums, leo_Index, 1
					Menu, LeoToolTip, Add, &%leo_Key% - %leo_MenuString%%A_Tab%%leo_MenuStringB%, leo_sub_MenuCall
				}
				Else
					Menu, LeoToolTip, Add, %leo_MenuString% = %leo_MenuStringB%, leo_sub_MenuCall
			}
		}

		If (leo_DisplayForumResults = 1)
		{	; Überschrift der Forumartikelliste finden, Wenns was gibt sind 3 &nbsp; davor:
			StringGetPos, leo_tmp, leo_Query, &nbsp;&nbsp;&nbsp;Forumsdiskussionen`, die den Suchbegriff enthalten
			if leo_tmp != -1
			{
				line_Index := leo_Index
				line_Index++
				Menu, LeoToolTip, Add
				
				; wenn untermenü: später erzeugen und menu-name für items anders:
				leo_MenuName = LeoToolTip
				if leo_SubMenuForumResults
				{
					leo_FirstForumMenuItem := leo_Index
					leo_MenuName = LeoToolTipForumSubMenu
				}
				else
				{
					Menu, LeoToolTip, Add, %lng_leo_ForumTopics%, leo_sub_MenuCall_Ex
					Menu, LeoToolTip, Disable, %lng_Leo_ForumTopics%
				}

				StringMid, leo_Result, leo_Query, %leo_tmp%
				StringGetPos, leo_tmp, leo_Result, </ul>
				If leo_tmp > 0
					StringMid, leo_Result, leo_Result, 1, %leo_tmp%
				StringGetPos, leo_tmp, leo_Result, </table>
				If leo_tmp > 0
					StringMid, leo_Result, leo_Result, 1, %leo_tmp%

				StringReplace, leo_Result, leo_Result, </A>, |, All
				StringReplace, leo_Result, leo_Result, <br>, |, All
				StringReplace, leo_Result, leo_Result, </b>, |, All
				StringReplace, leo_Result, leo_Result, </li>, |, All
				Loop, Parse, leo_Result, |
				{
					; sucht nach irgendwas, wenn gefunden: Stelle in found, und Fund in leo_Word und leo_Url !??! aha...
					found := RegExMatch(A_LoopField, "i)<A HREF='(?P<Url>[^>]+)'>(?P<Word>.+)$", leo_)

					If not found
						Continue

					If StrLen(leo_Word) > leo_MaxForumTextLen
						leo_Word := SubStr(leo_Word, 1, leo_MaxForumTextLen) "..."

					; Html-Link-Name lesbar machen
					leo_Word := UTF82Ansi(func_Html2Ansi(leo_Word))

					If not leo_CompactMenu
					{
						leo_Key := SubStr(leo_AlphaNums, leo_Index, 1)
						If leo_Key =
							leo_Key = %leo_Index%
						Else
							leo_Key = &%leo_Key%
						leo_Word = %leo_Key% - %leo_Word%
					}

					Menu, %leo_MenuName%, Add, %leo_Word%, leo_sub_MenuCall_Ex
					leo_MenuItem[%line_Index%] = http://dict.leo.org%leo_Url%

					leo_Index++
					line_Index++
				}
				
				if leo_SubMenuForumResults
					Menu, LeoToolTip, Add, %lng_leo_ForumTopics%, :%leo_MenuName%
			}
		}

		Gosub, leo_tim_ToolTipOff
		Menu, LeoToolTip, Add
		If leo_CompactMenu = 0
			Menu, LeoToolTip, Add, &# - %lng_leo_GotoURL%, leo_sub_GotoURL
		Else
			Menu, LeoToolTip, Add, %lng_leo_GotoURLCompact%, leo_sub_GotoURL
		If (leo_HistoryFile <> "" AND leo_HistoryFileOnMenuCall = 0)
			FileAppend, %leo_FinalResultTip%`r`n`r`n, %leo_HistoryFile%

		Menu, LeoToolTip, Show, %leo_ttX%, %leo_ttY%
		Loop
		{
			If !GetKeyState("LWin") AND !GetKeyState("RWin")
				Break
			Menu, LeoToolTip, Show, %leo_ttX%, %leo_ttY%
		}

		; cleanup:
		Menu, LeoToolTip, DeleteAll
		if leo_SubMenuForumResults
			Menu, LeoToolTipForumSubMenu, DeleteAll
	
		Return
	}
	Else
	{
		tooltip, %leo_FinalResultTip%, %leo_ttX%, %leo_ttY%, 8
		;Clipboard = %leo_FinalResult%
		SetTimer, leo_tim_WatchToolTip, 20
		If (leo_HistoryFile <> "" AND !InStr(leo_FinalResult, lng_leo_NothingFound) AND !InStr(leo_FinalResult, lng_leo_CheckProxy) AND !InStr(leo_FinalResult, lng_leo_Error))
			FileAppend, %leo_FinalResultTip%`r`n`r`n, %leo_HistoryFile%
	}
Return

leo_sub_MenuCall:
	leo_MenuString := leo_MenuItem[%A_ThisMenuItemPos%]
	; geschützte Leerzeichen entfernen
	leo_MenuString := RegExReplace(leo_MenuString, " ", "")
	; Eckige und runde Klammern mit Inhalt entfernen
	leo_MenuString := RegExReplace(leo_MenuString, "(\(|\[).*?(\)|\])", "")
	; Nach Minus, geschweifter Klammer, senkrechtem Strich oder Tabulator schneiden
	leo_MenuString := RegExReplace(leo_MenuString, "^(.*?)(- |\{|\||\t).*", "$1")
	; Sonderwörter entfernen
	leo_MenuString := RegExReplace(leo_MenuString, leo_RemoveBeforeReplace, "")
	; überflüssige Leerzeichen entfernen
	leo_MenuString := RegExReplace(leo_MenuString, "\s+", " ")
	leo_MenuString := RegExReplace(leo_MenuString, "^\s*", "")
	leo_MenuString := RegExReplace(leo_MenuString, "\s*$", "")
	; Variablenzeichen und Klammern wieder hinzufügen
	leo_MenuString := RegExReplace(leo_searchOrig, "^(" leo_CleanChars ")?.*?(" leo_CleanChars ")?$", "$1" leo_MenuString "$2")

	If leo_TranslationToClipboard = 1
		Clipboard = %leo_MenuString%
	Else
		SendRaw, %leo_MenuString%
	If (leo_HistoryFile <> "" AND leo_HistoryFileOnMenuCall = 1)
		FileAppend, %leo_FinalResultTip%`r`n`r`n, %leo_HistoryFile%
	If (leo_HistoryFile <> "" AND leo_HistoryFileOnMenuCall = 2)
		FileAppend, %leo_searchOrig% = %leo_MenuString%`r`n, %leo_HistoryFile%
	If (leo_HistoryFile <> "" AND leo_HistoryFileOnMenuCall = 3)
		FileAppend, % leo_HistFormat(A_ThisMenuItem, leo_CompactMenu, leo_HistLang), %leo_HistoryFile%
Return

; für wenn man ein item von den Forumsbeiträgen auswählt:
leo_sub_MenuCall_Ex:
	leo_tmp := A_ThisMenuItemPos - 2
	if leo_SubMenuForumResults
		leo_tmp := A_ThisMenuItemPos + leo_FirstForumMenuItem

	leo_MenuString := leo_MenuItem[%leo_tmp%]
	
		leo_searchFor := func_URLEncode(leo_searchClean)
		If leo_Browser =
			Run, %leo_MenuString%,, UseErrorLevel
		Else
			Run, %leo_BrowserDeref% %leo_MenuString%,, UseErrorLevel
		If ErrorLevel = ERROR
			func_GetErrorMessage( A_LastError, leo_ScriptName, lng_leo_BrowserError  )
Return

; zum weitersuchen des gewählten Begriffs bei orthographisch ähnlichen Wörtern:
leo_sub_MenuCall_Search:
	leo_searchOrig := A_ThisMenuItem
	leo_lastSearch =
	leo_lastLangStr =
	Gosub leo_sub_Search
Return

; Menüeintrag für die Ausgabe wunschgerecht aufbereiten
leo_HistFormat( Item , Compact , Lang ) {
	Global leo_Lang1
	myLang := leo_Lang1
	RetVal := ""
	If (Compact = 0) {
		If RegExMatch(Item, "&.*-\s*(.+)\s«([^-]+).+?»\s*(.+)", Match) {
			If (Match2 = myLang) {
				RetVal .= Match1 . " = " . Match3
			} Else {
				RetVal .= Match3 . " = " . Match1
			}
		}
	} Else {
		If RegExMatch(Item, "\s*(.+)\s+=\s*(.+)", Match) {
			If (Lang = myLang) {
				RetVal .= Match1 . " = " . Match2
			} Else {
				RetVal .= Match2 . " = " . Match1
			}
		}
	}
	; Chr(0xA0) durch Space ersetzen
	RetVal := RegExReplace(RetVal, Chr(0xA0) . "+", " ")
	; Mehrere Spaces auf eines reduzieren
	RetVal := RegExReplace(RetVal, "\s+", " ")
	Return RetVal . "`r`n"
}

leo_tim_ToolTipOff:
	RButton_tip =
	leo_BreakLoop = 1
	SetTimer, leo_tim_ToolTipOff, Off
	tooltip,,,, 8
	SetTimer, leo_tim_WatchToolTip, Off
Return

leo_sub_GotoURL:
	leo_searchFor := func_URLEncode(leo_searchClean)
	leo_searchURL := "http://dict.leo.org/" leo_langStr "/index_" lng_leo_lngShort ".html#/search=" leo_searchFor "&searchLoc=0&resultOrder=basic&multiwordShowSingle=on"
	If leo_Browser =
		IfInString, leo_FinalResult, %lng_leo_ParseError%
			Run, http://activaid.rumborak.de,, UseErrorLevel
		Else
			Run, %leo_searchURL%,, UseErrorLevel
	Else
		IfInString, leo_FinalResult, %lng_leo_ParseError%
			Run, %leo_BrowserDeref% http://activaid.rumborak.de,, UseErrorLevel
		Else
			Run, %leo_BrowserDeref% %leo_searchURL%,, UseErrorLevel
	If ErrorLevel = ERROR
		func_GetErrorMessage( A_LastError, leo_ScriptName, lng_leo_BrowserError )
Return

leo_tim_WatchToolTip:
	MouseGetPos, leo_X, leo_Y, leo_WinID
	If leo_startX <>
	{
		If (leo_X > leo_StartX+4 OR leo_Y > leo_StartY+4 OR leo_X < leo_StartX-4 OR leo_Y < leo_StartY-4)
		{
			leo_startX =
			SetTimer, leo_tim_ToolTipOff, 2000
		}
	}
	WinGetTitle, leo_TipText, ahk_id %leo_WinID%
	If leo_TipText = %leo_FinalResultTip%
	{
		GetKeyState, leo_LButton, LButton
		GetKeyState, leo_RButton, RButton
		If leo_LButton = D
			Gosub, leo_tim_ToolTipOff
		Else If (leo_RButton = "D" OR RButton_tip = "yes")
		{
			leo_searchFor := func_URLEncode(leo_searchClean)
			If leo_Browser =
				IfInString, leo_FinalResult, %lng_leo_ParseError%
					Run, http://activaid.rumborak.de,, UseErrorLevel
				Else
					Run, http://dict.leo.org/?lp=%leo_langStr%&relink=on&sectHdr=off&spellToler=on&search=%leo_searchFor%,, UseErrorLevel
			Else
				IfInString, leo_FinalResult, %lng_leo_ParseError%
					Run, %leo_BrowserDeref% http://activaid.rumborak.de",, UseErrorLevel
					; " ; end qoute for syntax highlighting
				Else
					Run, %leo_BrowserDeref% http://dict.leo.org/?lp=%leo_langStr%&relink=on&sectHdr=off&spellToler=on&search=%leo_searchFor%,, UseErrorLevel
			If ErrorLevel = ERROR
				func_GetErrorMessage( A_LastError, leo_ScriptName, lng_leo_BrowserError  )
			Gosub, leo_tim_ToolTipOff
		}
		Else
		{
			SetTimer, leo_tim_ToolTipOff, 1000
		}
	}
	GetKeyState, leo_ESC, ESC
	If leo_ESC = D
		SetTimer, leo_tim_ToolTipOff, 1
Return

; 
leo_createSimilarsMenu()
{
	global leo_Query, lng_leo_SimilarWords, lng_leo_NothingFound, leo_searchOrig

	; Stelle mit Überschrift finden:
	StringGetPos, orthoPos, leo_Query, Orthographisch &auml;hnliche W&ouml;rter
	; 2 mal nach Orthographisch ähnlichen Worten suchen :
	result := leo_getSimilar(orthoPos)
	listAdd(leo_getSimilar(orthoPos), result, "•")

	if result =
		Return 0

	; Menü-header:
	Menu, LeoToolTip_Similar, Add, %lng_leo_NothingFound%: %leo_searchOrig%!, leo_sub_MenuCall_Search
	Menu, LeoToolTip_Similar, Disable, %lng_leo_NothingFound%: %leo_searchOrig%!
	Menu, LeoToolTip_Similar, Add

	menus =
	loop, parse, result, •
	{	; spalten in Sprache(items1) und Begriffe(items2)
		StringSplit, items, A_LoopField, §
		; menü-Name ist loka-text+Sprache
		thisMenu := lng_leo_SimilarWords items1
		listAdd(thisMenu,menus)
		loop, parse, items2, |
			Menu, %thisMenu%, Add, %A_LoopField%, leo_sub_MenuCall_Search

		Menu, LeoToolTip_Similar, Add, %lng_leo_SimilarWords% - %items1%, :%thisMenu%
	}

	Menu, LeoToolTip_Similar, Show, %leo_ttX%, %leo_ttY%
	Menu, LeoToolTip_Similar, Delete
	loop, parse, menus, |
		Menu, %A_LoopField%, Delete

	Return 1
}

; sucht nach Orthographisch ähnlichen wörtern ab Position pos
leo_getSimilar(byref pos)
{
	global leo_Query
	
	orthoString = Orthographisch &auml;hnliche W&ouml;rter
	
	; Stelle mit Überschrift finden:
	StringGetPos, orthoPos, leo_Query, %orthoString%,, pos
	; wenn nix gefunden wird, wird nix ausgespuckt:
	if orthoPos = -1
		Return ""

	; nächsten Strich finden:
	StringGetPos, orthoPos, leo_Query, -,, %orthoPos%
	; Ende der Überschrift für Sprache finden
	StringGetPos, headEndPos, leo_Query, </td>,, %orthoPos%
	; HTML-Umlaute müssen leider 2mal umgewandelt werden:
	language := UTF82Ansi(func_Html2Ansi(func_StrMid(leo_Query, orthoPos + 3, headEndPos - orthoPos - 2)))
	
	; Ende des Blocks finden und extrahieren:
	headEndPos := headEndPos + 5
	StringGetPos, blockEndPos, leo_Query, </td>,, %headEndPos%
	block := UTF82Ansi(func_StrMid(leo_Query, headEndPos, blockEndPos - headEndPos))
	
	; Daten zwischen den <A>-tags holen:
	marker := "`"">" ;"
	StringReplace, block, block, %marker%, §, All
	StringReplace, block, block, </A>, §, All
	skip = 1 ; jede 2. Zeile nur
	words =
	Loop, parse, block, §
	{
		if skip
		{
			skip = 0
			continue
		}
		listAdd(A_Loopfield,words,"|")
		skip = 1
	}
	
	result = %language%§`n%words%
	pos := blockEndPos
	Return result
}

leo_cleanResult( byref leo_Result ) {
	leo_Result := RegExReplace(leo_Result,"i)<->.|<img.*?>|<td[^<>]*?nowrap[^<>]*?width=.`%[^<>]*?>.*?</td>||</td>|<i.*?>|</i>|<span.*?>|</span>|<small.*?>|</small>|<font size=-1>|</font>|`t|", "")
	; LineBreaks einfügen
	leo_Result := RegExReplace(leo_Result, "i)<!--`n|<td.*?>|<td valign=middle width=..`%>", "`n")
	; bestimmte Tags zu Klammern umwandeln
	leo_Result := RegExReplace(leo_Result,"i)<sup>(.*?)</sup>|<sub>(.*?)</sub>", " ($1)")
	; bestimmte Tags zu geschweiften Klammern umwandeln
	leo_Result := RegExReplace(leo_Result,"i)<I>(.*?)</I>", "{$1}")
	; zwei Klammern zu einer machen, z.B.: { [..]}
	leo_Result := RegExReplace(leo_Result,"\{ ?(\(|\[)(.*?)(\]|\))\}", "$1$2$3")
	leo_Result := RegExReplace(leo_Result,"\[ ?(\{|\(|\[)(.*?)(\]|\)|\})\]", "[$2]")
	; Sonderzeichen mit Ampersand ersetzen (z.B. whiteout)
	leo_Result := RegExReplace(leo_Result,"&reg;", "®")
	leo_Result := RegExReplace(leo_Result,"&copy;", "©")
	;alle anderen Ampersand-Semikolon Teile löschen
	leo_Result := RegExReplace(leo_Result,"&.*?;", "")
	; Ende des Eintragens der Übersetzung bestimmen |
	leo_Result := RegExReplace(leo_Result,"<br>", "|")
	; mehrfach und HTML Leerzeichen zu einem Leerzeichen machen
	leo_Result := RegExReplace(leo_Result,"i)&nbsp;|\t| {2,}", " ")

	leo_Result := UTF82Ansi(leo_Result)

	return leo_Result
}