; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               TypeWith9Keys
; -----------------------------------------------------------------------------
; Prefix:             t9k_
; Version:            0.2
; Date:               2008-02-09
; Author:             David Hilberath
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_TypeWith9Keys:
	#Include %A_ScriptDir%\Library\SQLite.ahk
;   #include %A_ScriptDir%\Library\CmnDlg.ahk

	Prefix = t9k
	%Prefix%_ScriptName    = TypeWith9Keys
	%Prefix%_ScriptVersion = 0.2
	%Prefix%_Author        = David Hilberath

	CustomHotkey_TypeWith9Keys = 1          ; automatisches benutzerdefinierbares Tastaturkürzel? (1 = ja)
	Hotkey_TypeWith9Keys       = #k         ; Standard-Hotkey
	EnableTray_TypeWith9Keys   = 1          ; Soll eine Erweiterung nicht im Tray-Menü aufgeführt werden, muss der Wert 0 betragen
	IconFile_On_TypeWith9Keys  = %A_WinDir%\system32\shell32.dll
	IconPos_On_TypeWith9Keys   = 174

	Gosub, LanguageCreation_TypeWith9Keys

	CreateGuiID("TypeWith9Keys_Keys")
	CreateGuiID("TypeWith9Keys_List")

	IniRead,t9k_sDBFileName,%ConfigFile%, %t9k_ScriptName%,Database,%SettingsDir%\TypeWith9Keys-Dict.db
	IniRead,t9k_clipboard,%ConfigFile%, %t9k_ScriptName%,UseClipboard,1
	IniRead,t9k_casehelp,%ConfigFile%, %t9k_ScriptName%,CaseHelp,1
	IniRead,t9k_enableSupport,%ConfigFile%, %t9k_ScriptName%,EnableSupport,1
	If t9k_sDBFileName = %SettingsDir%\TypeWith9Keys-Dict.db
		IfNotExist, %t9k_sDBFileName%
			FileCopy, %A_ScriptDir%\Library\TypeWith9Keys-Dict.db, %t9k_sDBFileName%

	t9k_sCSVFileName = %A_Temp%\dict.csv

	if (t9k_casehelp = 1)
		t9k_nextBig = 1
	else
		t9k_nextBig = 0

	gosub, t9k_adaptBigButton
	Gosub, t9k_createMenus           ;Menu Buttons erstellen
	gosub, t9k_initialize

Return

; wird aufgerufen, wenn im Konfigurationsdialog OK oder Übernehmen angeklickt wird
SaveSettings_TypeWith9Keys:
	iniWrite,%t9k_sDBFileName%, %ConfigFile%, %t9k_ScriptName%,Database
	iniWrite,%t9k_clipboard%, %ConfigFile%, %t9k_ScriptName%,UseClipboard
	iniWrite,%t9k_casehelp%, %ConfigFile%, %t9k_ScriptName%,CaseHelp

	if (t9k_casehelp = 1)
		t9k_nextBig = 1
	else
		t9k_nextBig = 0
	gosub, t9k_adaptBigButton
Return

; Wird aufgerufen, wenn Einstellungen über das 'Pfeil'-Menü hinzugefügt werden, ist nur notwendig wenn AddSettings_TypeWith9Keys = 1
AddSettings_TypeWith9Keys:
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_TypeWith9Keys:
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_TypeWith9Keys:
	registerAction("TypeWith9Keys",lng_t9k_openWindow,"sub_Hotkey_TypeWith9Keys")
	registerHoldAction("TypeWith9KeysSelect",lng_t9k_actions_SelectButton,"t9k_jc_HoldAction_SelectButton_Start","t9k_jc_HoldAction_SelectButton_End")
	gosub, t9k_initialize
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern der Einstellungen aufgerufen
DoDisable_TypeWith9Keys:
	unRegisterAction("TypeWith9Keys")
	_SQLite_CloseDB(-1)
	_SQLite_Shutdown()
Return

; wird aufgerufen, wenn der Anwender die Erweiterung auf die Standard-Einstellungen zurücksetzt
DefaultSettings_TypeWith9Keys:
Return

; wird aufgerufen, wenn ac'tivAid beendet oder neu geladen wird.
OnExitAndReload_TypeWith9Keys:
	_SQLite_CloseDB(-1)
	_SQLite_Shutdown()
Return

; -----------------------------------------------------------------------------
; === Language ================================================================
; -----------------------------------------------------------------------------
LanguageCreation_TypeWith9Keys:
	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		TypeWith9Keys_EnableMenu       = TypeWith9Keys aktiv
		MenuName                = %t9k_ScriptName% - T9 Onscreen Keyboard
		Description             = Öffnet eine Bildschirmtastatur mit T9 Texteingabe

		lng_t9k_sCSVFileName    = Temporäre CSV-Datei
		lng_t9k_sDBFileName     = Wörterbuch-Datei
		lng_t9k_createNewDB     = Neues Wörterbuch
		lng_t9k_createNewDBB    = Einlesen
		lng_t9k_impMenu_mass    = Priorität nach Masse (ICQ Log, Emails etc)
		lng_t9k_impMenu_order   = Priorität nach Reihenfolge (Wortliste)
		lng_t9k_clipboard       = Satz in Zwischenablage speichern
		lng_t9k_casehelp        = Großschreibhilfe
		lng_t9k_statusbar       = Tastenkombination:
		lng_t9k_delMenu_lastWord= Letztes Wort
		lng_t9k_delMenu_clearAll= Alles
		lng_t9k_fileselect      = Dateien zum Importieren auswählen
		lng_t9k_fileselectFilter= ANSI-Textdateien (*.*)
		lng_t9k_filesave        = Erstelle neue DB-Datei
		lng_t9k_fileopen        = Wähle neue DB-Datei
		lng_t9k_fileopentype    = SQLite Datenbank (*.db)
		lng_t9k_wait_a          = Lese Dateien
		lng_t9k_wait_b          = Sortiere Wörter
		lng_t9k_wait_c          = Zähle
		lng_t9k_wait_d          = Erstelle Tabelle
		lng_t9k_listwindow      = Inhalt des aktuellen Wörterbuchs
		lng_t9k_openWindow      = TypeWith9Keys öffnen
		lng_t9k_initError       = Wörterbuch konnte nicht geladen werden:
		lng_t9k_support0        = Texthilfe aus
		lng_t9k_support1        = Texthilfe ein

		lng_t9k_actions_SelectButton = Arrow Keys
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		TypeWith9Keys_EnableMenu       = TypeWith9Keys active
		MenuName                = %t9k_ScriptName% - T9 Onscreen Keyboard
		Description             = Onscreen Keyboard for text input with T9

		lng_t9k_sCSVFileName    = Temporary CSV file
		lng_t9k_sDBFileName     = Dictionary file
		lng_t9k_createNewDB     = New Dictionary
		lng_t9k_createNewDBB    = Importt
		lng_t9k_impMenu_mass    = Priority by mass (ICQ Log, Emails etc)
		lng_t9k_impMenu_order   = Priority by order (Wordlist)
		lng_t9k_clipboard       = Remember sentence in clipboard
		lng_t9k_casehelp        = Auto caps
		lng_t9k_statusbar       = Keys pressed:
		lng_t9k_delMenu_lastWord= Last word
		lng_t9k_delMenu_clearAll= Clear all
		lng_t9k_fileselect      = Select files for import
		lng_t9k_fileselectFilter= ANSI Text files (*.*)
		lng_t9k_filesave        = Create new DB file
		lng_t9k_fileopen        = Select new DB file
		lng_t9k_fileopentype    = SQLite Database (*.db)
		lng_t9k_wait_a          = Reading files
		lng_t9k_wait_b          = Sorting
		lng_t9k_wait_c          = Counting
		lng_t9k_wait_d          = Creating Table
		lng_t9k_listwindow      = Currently selected database content
		lng_t9k_openWindow      = Open TypeWith9Keys
		lng_t9k_initError       = Could not load wordlist:
		lng_t9k_support0        = Textaid off
		lng_t9k_support1        = Textaid on

		lng_t9k_actions_SelectButton  = Arrow Keys
	}
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------
sub_Hotkey_TypeWith9Keys:
	t9k_final =
	IfWinExist, T9 Keyboard
	{
		GuiDefault("TypeWith9Keys_Keys")
		Gui, Destroy
	}
	else
		gosub, t9k_createGui
 Return



; -----------------------------------------------------------------------------
; === GUI Routines ============================================================
; -----------------------------------------------------------------------------
SettingsGui_TypeWith9Keys:
	Gui, Add, Text, XS+10 Y+7, %lng_t9k_sDBFileName%:
	Gui, Add, Edit, yp-2 h20 gsub_CheckIfSettingsChanged XS+120 vt9k_sDBFileName w240, %t9k_sDBFileName%
	Gui, Add, Button, x+5 gt9k_changeDBFile h20 w30, ...
	Gui, Add, Button, x+5 gt9k_showDatabase h20 w40, Show

	Gui, Add, Text, XS+10 Y+7, %lng_t9k_createNewDB%:
	Gui, Add, Button, xs+120 yp-2 gt9k_ShowImportMenu h20 w70, %lng_t9k_createNewDBB%
	Gui, Add, Text, x+5 yp+2 w200 vt9k_waitLabel,

	Gui, Add, CheckBox,  xs+10 y+7 vt9k_clipboard gsub_CheckIfSettingsChanged Checked%t9k_clipboard%, %lng_t9k_clipboard%
	Gui, Add, CheckBox,  xs+10 y+5 vt9k_casehelp gsub_CheckIfSettingsChanged Checked%t9k_casehelp%, %lng_t9k_casehelp%
Return

t9k_createGui:
	t9k_GuiID := GuiDefault("TypeWith9Keys_Keys")

	Gui, Add, Edit, x6 y6 w140 h20 0x100 ReadOnly vt9k_MainEdit,
	Gui, Add, Button, x+5 w20 h20 gt9k_bD vt9k_buttSDel, <

	Gui, Add, Button, x10 y66  w45 h30 gt9k_b1 vt9k_butt1 -Tabstop, 1
	Gui, Add, Button, x+10     w45 h30 gt9k_b2 vt9k_butt2 -Tabstop -Wrap, 2 abc
	Gui, Add, Button, x+10     w45 h30 gt9k_b3 vt9k_butt3 -Tabstop -Wrap, 3 def
	Gui, Add, Button, x10 y+10 w45 h30 gt9k_b4 vt9k_butt4 -Tabstop -Wrap, 4 ghi
	Gui, Add, Button, x+10     w45 h30 gt9k_b5 vt9k_butt5 -Tabstop -Wrap, 5 jkl
	Gui, Add, Button, x+10     w45 h30 gt9k_b6 vt9k_butt6 -Tabstop -Wrap, 6 mno
	Gui, Add, Button, x10 y+10 w45 h30 gt9k_b7 vt9k_butt7 -Tabstop -Wrap, 7 pqrs
	Gui, Add, Button, x+10     w45 h30 gt9k_b8 vt9k_butt8 -Tabstop -Wrap, 8 tuv
	Gui, Add, Button, x+10     w45 h30 gt9k_b9 vt9k_butt9 -Tabstop -Wrap, 9 wxyz
	Gui, Add, Button, x10 y+10 w45 h30 gt9k_bS vt9k_buttExtra -Wrap, *+
	Gui, Add, Button, x+10     w45 h30 gt9k_b0 vt9k_buttSpace -Wrap, _
	Gui, Add, Button, x+10     w45 h30 gt9k_bB vt9k_buttBig -Wrap, Abc

	Gui, Add, Button, x176 y186 w45 h30 gt9k_bD2 vt9k_buttDel, <
	Gui, Add, Button, x+50 w45 h30 gt9k_bG vt9k_buttEnter -Wrap, Enter


	Gui, Add, Edit, x176 y6 w140 h170 ReadOnly vt9k_MainLabel -VScroll, %t9k_initError%


	Gui, Add, DropDownList, x6 y36 w140 h10 R6 vt9k_myDrop gt9k_SelectDrop,
	Gui, Add, Button, x+5 yp+1 w20 h20 gt9k_bM vt9k_buttChoice, ?

	Gui, Add, StatusBar, gt9k_statusClick,
	SB_SetParts(250)
	SB_SetText(lng_t9k_support%t9k_enableSupport%,2)

	Gui, Show, h241 w325, T9 Keyboard

	t9k_hwnd := WinExist()

	GroupAdd, t9keyboardGroup, ahk_id %t9k_hwnd%

	Send {Tab 2}
	GuiControl, Focus, t9k_butt5

	/*
	;Fenster am Mauscursor zentrieren
	Winget, t9k_guiID, ID, T9 Keyboard   ;get id for kb gui 1
	WinGetPos,,,t9k_wWin,t9k_hWin,ahk_id %t9k_guiID%
	CoordMode, Mouse, Screen
	MouseGetPos, t9k_mouseX, t9k_mouseY
	t9k_newPosX := t9k_mouseX-(t9k_wWin//2)
	t9k_newPosY := t9k_mouseY+50
	if t9k_newPosX < 0
	  t9k_newPosX := 0
	if t9k_newPosY < 0
	  t9k_newPosY := 0
	WinMove, ahk_id %t9k_guiID%,, t9k_newPosX, t9k_newPosY
	*/
return

TypeWith9Keys_KeysGuiContextMenu:
	if A_GuiControl = t9k_butt2
		Menu,t9k_two,show
	if A_GuiControl = t9k_butt3
		Menu,t9k_three,show
	if A_GuiControl = t9k_butt4
		Menu,t9k_four,show
	if A_GuiControl = t9k_butt5
		Menu,t9k_five,show
	if A_GuiControl = t9k_butt6
		Menu,t9k_six,show
	if A_GuiControl = t9k_butt7
		Menu,t9k_seven,show
	if A_GuiControl = t9k_butt8
		Menu,t9k_eight,show
	if A_GuiControl = t9k_butt9
		Menu,t9k_nine,show
	if A_GuiControl = t9k_buttDel
		Menu,t9k_del,show
return

t9k_createMenus:
	Menu,t9k_del,add,%lng_t9k_delMenu_lastWord%,t9k_backword
	Menu,t9k_del,add,%lng_t9k_delMenu_clearAll%,t9k_clearall

	Menu,t9k_Import,add,%lng_t9k_impMenu_mass%,t9k_importLog
	Menu,t9k_Import,add,%lng_t9k_impMenu_order%,t9k_importDictionary

	Menu,t9k_sonder,add,.,t9k_addSpec
	Menu,t9k_sonder,add,`,,t9k_addSpec
	Menu,t9k_sonder,add,!,t9k_addSpec
	Menu,t9k_sonder,add,?,t9k_addSpec
	Menu,t9k_sonder,add,`:,t9k_addSpec
	Menu,t9k_sonder,add,`;,t9k_addSpec
	Menu,t9k_sonder,add,(,t9k_addSpec
	Menu,t9k_sonder,add,),t9k_addSpec
	Menu,t9k_sonder,add,[,t9k_addSpec
	Menu,t9k_sonder,add,],t9k_addSpec
	Menu,t9k_sonder,add,=,t9k_addSpec
	Menu,t9k_sonder,add,$,t9k_addSpec

	Menu,t9k_digits,add,0,t9k_addSpec
	Menu,t9k_digits,add,1,t9k_addSpec
	Menu,t9k_digits,add,2,t9k_addSpec
	Menu,t9k_digits,add,3,t9k_addSpec
	Menu,t9k_digits,add,4,t9k_addSpec
	Menu,t9k_digits,add,5,t9k_addSpec
	Menu,t9k_digits,add,6,t9k_addSpec
	Menu,t9k_digits,add,7,t9k_addSpec
	Menu,t9k_digits,add,8,t9k_addSpec
	Menu,t9k_digits,add,9,t9k_addSpec

	Menu,t9k_two,add,2,t9k_addSpec
	Menu,t9k_two,add,a,t9k_addSpec
	Menu,t9k_two,add,b,t9k_addSpec
	Menu,t9k_two,add,c,t9k_addSpec

	Menu,t9k_three,add,3,t9k_addSpec
	Menu,t9k_three,add,d,t9k_addSpec
	Menu,t9k_three,add,e,t9k_addSpec
	Menu,t9k_three,add,f,t9k_addSpec

	Menu,t9k_four,add,4,t9k_addSpec
	Menu,t9k_four,add,g,t9k_addSpec
	Menu,t9k_four,add,h,t9k_addSpec
	Menu,t9k_four,add,i,t9k_addSpec

	Menu,t9k_five,add,5,t9k_addSpec
	Menu,t9k_five,add,j,t9k_addSpec
	Menu,t9k_five,add,k,t9k_addSpec
	Menu,t9k_five,add,l,t9k_addSpec

	Menu,t9k_six,add,6,t9k_addSpec
	Menu,t9k_six,add,m,t9k_addSpec
	Menu,t9k_six,add,n,t9k_addSpec
	Menu,t9k_six,add,o,t9k_addSpec

	Menu,t9k_seven,add,7,t9k_addSpec
	Menu,t9k_seven,add,p,t9k_addSpec
	Menu,t9k_seven,add,q,t9k_addSpec
	Menu,t9k_seven,add,r,t9k_addSpec
	Menu,t9k_seven,add,s,t9k_addSpec

	Menu,t9k_eight,add,8,t9k_addSpec
	Menu,t9k_eight,add,t,t9k_addSpec
	Menu,t9k_eight,add,u,t9k_addSpec
	Menu,t9k_eight,add,v,t9k_addSpec

	Menu,t9k_nine,add,9,t9k_addSpec
	Menu,t9k_nine,add,w,t9k_addSpec
	Menu,t9k_nine,add,x,t9k_addSpec
	Menu,t9k_nine,add,y,t9k_addSpec
	Menu,t9k_nine,add,z,t9k_addSpec
return

t9k_ShowImportMenu:
	Menu,t9k_Import,show
return

t9k_waitUpdate:
	GuiControl,,t9k_waitLabel, %t9k_waitTask%
return

t9k_updateMainLabel:
	GuiDefault("TypeWith9Keys_Keys")
	GuiControl,, t9k_MainLabel, %t9k_final%
	;GuiControl, Focus, t9k_MainLabel
	Send ^{End}
return

TypeWith9Keys_ListGuiClose:
TypeWith9Keys_ListGuiEscape:
TypeWith9Keys_KeysGuiEscape:
TypeWith9Keys_KeysGuiClose:
	t9k_final =
	t9k_combo =
	Gui, Destroy
return


; -----------------------------------------------------------------------------
; === Import + Dictionary Routines ============================================
; -----------------------------------------------------------------------------
t9k_initialize:
	t9k_initError =
	_SQLite_Shutdown()
	_SQLite_Startup()
	_SQLite_OpenDB(t9k_sDBFileName)
	If $SQLITE_s_ERROR <>
		t9k_initError = %lng_t9k_initError%`n%$SQLITE_s_ERROR%
return

t9k_changeDBFile:
	_SQLite_Shutdown()

	FileSelectFile, t9k_SourceDBFile, 3,,%lng_t9k_fileopen%,%lng_t9k_fileopentype%
	if t9k_SourceDBFile =
		 return
	else t9k_sDBFileName := t9k_SourceDBFile

	GuiControl,,t9k_sDBFileName,%t9k_sDBFileName%

	gosub, SaveSettings_TypeWith9Keys
	gosub, t9k_initialize
return

t9k_createNewDictionaryAndImportCSV:
	t9k_waitTask = %lng_t9k_wait_d%
	gosub, t9k_waitUpdate

	FileSelectFile, t9k_TargetFile, S26,, %lng_t9k_filesave%
	if t9k_TargetFile =
	{
		t9k_waitTask =
		SetTimer, t9k_waitUpdate, Off
		gosub, t9k_waitUpdate
		return
	}

	IfExist %t9k_TargetFile%
		FileDelete %t9k_TargetFile%

	t9k_sInput =
	(Ltrim
		CREATE TABLE Dict (Len int(11), Stroke, Word, Priority int(13));
		.separator \t
		.import '%t9k_sCSVFileName%' Dict
	)
	t9k_sOutput := ""

	t9k_sDBFileName := t9k_TargetFile

	_SQLite_SQLiteExe(t9k_sDBFileName, t9k_sInput, t9k_sOutput)
	t9k_waitTask =
	SetTimer, t9k_waitUpdate, Off
	GuiControl,,t9k_sDBFileName,%t9k_sDBFileName%
	gosub, SaveSettings_TypeWith9Keys
	gosub, t9k_initialize
return

t9k_importLog:
	t9k_myWordArray =

	IfExist %t9k_sCSVFileName%
		FileDelete %t9k_sCSVFileName%

	;Für sich alleine tut folgender Select-File-Dialog nicht für mehrere Dateien
	;Muss am ac'tivAid liegen, kanns mir nicht erklären. Stand-alone klappts einwandfrei
	;Ersetz durch CommonDialogs...
	FileSelectFile, t9k_SourceFiles, M2,,%lng_t9k_fileselect%,%lng_t9k_fileselectFilter%  ; M2 = Multiselect existing files.
	if t9k_SourceFiles =
		 return

;   Loop, parse, t9k_SourceFiles, `n
;   {
;      if A_Index = 1
;         t9k_pathToFiles := A_LoopField
;      else
;      {
;         t9k_SourceFile = %t9k_pathToFiles%\%A_LoopField%
;
;         Loop, Read, %t9k_SourceFile%
;         {
;            t9k_w2aPrev := A_LoopReadLine
;            t9k_wordArray :=
;            StringSplit, t9k_wordArray, t9k_w2aPrev, %A_Tab%%A_Space%`,`:`.`?`+`-
;
;            Loop, %t9k_wordArray0%
;            {
;               t9k_thisWord := t9k_wordArray%A_Index%
;               StringLower, t9k_thisWord, t9k_thisWord
;               StringReplace, t9k_thisWord, t9k_thisWord, %A_Space%, , All
;
;               if t9k_assertWord(t9k_thisWord)
;                  t9k_myWordArray = %t9k_myWordArray%|%t9k_thisWord%
;            }
;         }
;      }
;   }


;   t9k_SourceFiles := CmnDlg_Open("", lng_t9k_fileselect, lng_t9k_fileselectFilter, "", "C:\", "", "ALLOWMULTISELECT FILEMUSTEXIST HIDEREADONLY")
;   if t9k_SourceFiles =
;      return
;
	SetTimer, t9k_waitUpdate, 1000
	t9k_waitTask = %lng_t9k_wait_a%

	Loop, parse, t9k_SourceFiles, `n
	{
		t9k_SourceFile = %A_LoopField%

		Loop, Read, %t9k_SourceFile%
		{
			t9k_w2aPrev := A_LoopReadLine
			t9k_wordArray :=
			t9k_wordCount := 0
			StringSplit, t9k_wordArray, t9k_w2aPrev, %A_Tab%%A_Space%`,`:`.`?`+`-

			Loop, %t9k_wordArray0%
			{
				t9k_thisWord := t9k_wordArray%A_Index%
				StringLower, t9k_thisWord, t9k_thisWord
				StringReplace, t9k_thisWord, t9k_thisWord, %A_Space%, , All

				if t9k_assertWord(t9k_thisWord) {
					t9k_waitTask = %lng_t9k_wait_a%: %t9k_thisWord%
					t9k_myWordArray = %t9k_myWordArray%|%t9k_thisWord%
					t9k_wordCount += 1
				}
			}
		}
	}

	t9k_waitTask = %lng_t9k_wait_b%

	sort,t9k_myWordArray,d|
	t9k_myWordArray = %t9k_myWordArray%|

	t9k_waitTask = %lng_t9k_wait_c%
	t9k_cnt := 1
	Loop, parse, t9k_myWordArray, |
	{
		if A_Index = 1
			continue

		if A_Index = 2
		{
			t9k_prevWord := A_LoopField
			continue
		}

		t9k_waitTask = %lng_t9k_wait_c%: %t9k_prevWord% (%t9k_cnt%)

		if (A_LoopField = t9k_prevWord)
		{
			t9k_cnt += 1
			continue
		}

		t9k_w2aLen := StrLen(t9k_prevWord)
		t9k_strokes := t9k_word2strokes(t9k_prevWord)

		FileAppend,
		(
		  %t9k_w2aLen%%A_Tab%%t9k_strokes%%A_Tab%%t9k_prevWord%%A_Tab%%t9k_cnt%`n
		),%t9k_sCSVFileName%

		t9k_cnt := 1
		t9k_prevWord := A_LoopField
	}
	gosub, t9k_createNewDictionaryAndImportCSV
return

t9k_importDictionary:
	FileSelectFile, t9k_SourceFile, 3,, Pick a text file
	if t9k_SourceFile =
		return

	IfExist %t9k_sCSVFileName%
		FileDelete %t9k_sCSVFileName%

	SetTimer, t9k_waitUpdate, 1000
	t9k_waitTask = %lng_t9k_wait_a%

	Loop, Read, %t9k_SourceFile%
	{
			t9k_w2aPrev := A_LoopReadLine
			if t9k_assertWord(t9k_w2aPrev)
			{
				StringLower, t9k_w2aPrev, t9k_w2aPrev
				t9k_w2aLen := StrLen(t9k_w2aPrev)
				t9k_strokes := t9k_word2strokes(t9k_w2aPrev)

				t9k_waitTask = %lng_t9k_wait_a%: %t9k_w2aPrev% (%A_Index%)

				FileAppend,
				(
				  %t9k_w2aLen%%A_Tab%%t9k_strokes%%A_Tab%%t9k_w2aPrev%%A_Tab%%A_Index%`n
				),%t9k_sCSVFileName%
			}
	}

	gosub, t9k_createNewDictionaryAndImportCSV
return

t9k_assertWord(word)
{
	pos := RegExMatch(word,"[^a-zA-ZöäüÖÄÜß]")
	len := StrLen(word)

	if pos > 0
		return 0
	else
		if len > 0
			return 1
		else
			return 0
}

t9k_word2strokes(w2a)
{
	StringReplace, strokes, w2a, a, 2, All
	StringReplace, strokes, strokes, ä, 2, All
	StringReplace, strokes, strokes, b, 2, All
	StringReplace, strokes, strokes, c, 2, All
	StringReplace, strokes, strokes, d, 3, All
	StringReplace, strokes, strokes, e, 3, All
	StringReplace, strokes, strokes, f, 3, All
	StringReplace, strokes, strokes, g, 4, All
	StringReplace, strokes, strokes, h, 4, All
	StringReplace, strokes, strokes, i, 4, All
	StringReplace, strokes, strokes, p, 7, All
	StringReplace, strokes, strokes, q, 7, All
	StringReplace, strokes, strokes, r, 7, All
	StringReplace, strokes, strokes, j, 5, All
	StringReplace, strokes, strokes, k, 5, All
	StringReplace, strokes, strokes, l, 5, All
	StringReplace, strokes, strokes, m, 6, All
	StringReplace, strokes, strokes, n, 6, All
	StringReplace, strokes, strokes, o, 6, All
	StringReplace, strokes, strokes, ö, 6, All
	StringReplace, strokes, strokes, s, 7, All
	StringReplace, strokes, strokes, ß, 7, All
	StringReplace, strokes, strokes, t, 8, All
	StringReplace, strokes, strokes, u, 8, All
	StringReplace, strokes, strokes, ü, 8, All
	StringReplace, strokes, strokes, v, 8, All
	StringReplace, strokes, strokes, w, 9, All
	StringReplace, strokes, strokes, x, 9, All
	StringReplace, strokes, strokes, y, 9, All
	StringReplace, strokes, strokes, z, 9, All

	return strokes
}

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------
t9k_showDatabase:
	GuiDefault("TypeWith9Keys_List")
	t9k_listViewSQL := "SELECT * FROM Dict WHERE Len > 0 AND Priority > 2 ORDER BY Len ASC,Priority DESC;"

	_SQLite_GetTable($SQLITE_h_DB, t9k_listViewSQL, t9k_listViewResult, t9k_listViewRows, t9k_listViewCols)

	t9k_listView =
	t9k_listViewCnt := t9k_listViewRows + 1

	Loop, Parse, t9k_listViewResult, `n
	{
		If (A_Index = 1)
			Gui, Add, ListView, x5 r20 w440 h290 Grid Count%t9k_listViewCnt%, %A_LoopField%
		Else
		{
			StringSplit, t9k_listView, A_LoopField, |
			LV_ADD("", t9k_listView1, t9k_listView2, t9k_listView3, t9k_listView4)
		}
	}
	LV_ModifyCol(1, 30)
	LV_ModifyCol(1, "Integer")

	LV_ModifyCol(2, 150)
	LV_ModifyCol(3, 170)

	LV_ModifyCol(4, 50)
	LV_ModifyCol(4, "Integer")

	Gui, Show, w450 h300 Center, %lng_t9k_listwindow%
	GuiDefault("TypeWith9Keys_Keys")
Return

t9k_searchWord:
	t9k_choice := 2
	t9k_comLen := StrLen(t9k_combo)
	SB_SetText(lng_t9k_statusbar . " " . t9k_combo)
	t9k_sSQL := "SELECT * FROM Dict WHERE substr(Stroke,0," . t9k_comLen . ")='" . t9k_combo . "' AND Priority > 2 ORDER BY Len ASC,Priority DESC LIMIT 0,10;"
	_SQLite_GetTable($SQLITE_h_DB, t9k_sSQL, t9k_sResult, t9k_iRows, t9k_iCols)
	gosub, t9k_makeChoice
	;GuiControl, Focus, t9k_MainLabel
return


t9k_makeChoice:
	If (t9k_choice > t9k_iRows+1)
		t9k_choice := 2

	t9k_temp :=
	t9k_cnt := 0
	Loop, Parse, t9k_sResult, `n
	{
		if (A_Index > 1) {
			t9k_cnt += 1
			StringSplit, t9k_LV, A_LoopField, |

			if t9k_nextBig = 1
				StringUpper, t9k_LV3, t9k_LV3, T

			if t9k_nextBig = 2
				StringUpper, t9k_LV3, t9k_LV3

			If (A_Index = t9k_choice)
			{
				;t9k_withCursor := SubStr(t9k_LV3, 1, t9k_comLen). "." . SubStr(t9k_LV3, t9k_comLen+1)
				GuiControl,, t9k_MainEdit, %t9k_LV3%
				if SubStr(t9k_LV3, t9k_comLen+1) != ""
					SendMessage, 0xB1, t9k_comLen, StrLen(t9k_LV3), Edit1, ahk_id %t9k_GuiID% ; EM_SETSEL

				t9k_temp = %t9k_temp%|%t9k_LV3%|
			}
			else
				t9k_temp = %t9k_temp%|%t9k_LV3%
		}
	}
	if (cnt = 1)
		t9k_temp = %t9k_temp%|

	GuiControl, , t9k_myDrop, %t9k_temp%
return

t9k_clearInput:
	t9k_sResult =
	t9k_combo =
	t9k_choice = 2
	GuiControl,, t9k_MainEdit,
	GuiControl,, t9k_myDrop, |
	SB_SetText("")
	;GuiControl, Focus, t9k_MainLabel
return

t9k_putWord:
	t9k_LV3 =
	Loop, Parse, t9k_sResult, `n
	{
		If (A_Index = t9k_choice)
		{
			StringSplit, t9k_LV, A_LoopField, |
		}
	}

	if t9k_nextBig = 1
		StringUpper, t9k_LV3, t9k_LV3, T

	if t9k_nextBig = 2
		StringUpper, t9k_LV3, t9k_LV3

	t9k_final = %t9k_final%%t9k_LV3%
	gosub, t9k_updateMainLabel
return

t9k_addSpec:
	GuiDefault("TypeWith9Keys_Keys")
	gosub, t9k_putWord

	t9k_spec := A_ThisMenuItem

	if (t9k_casehelp = 1 && t9k_nextBig != 0)
		StringUpper, t9k_spec, t9k_spec

	t9k_final = %t9k_final%%t9k_spec%

	if (t9k_casehelp = 1 && t9k_nextBig != 2)
	{
		if (InStr(".!?",t9k_spec))
			t9k_nextBig = 1
		else
			t9k_nextBig = 0
		gosub, t9k_adaptBigButton
	}

	gosub, t9k_updateMainLabel
	gosub, t9k_clearInput
return

; -----------------------------------------------------------------------------
; === GUI Interaction ======================================================
; -----------------------------------------------------------------------------
t9k_SelectDrop:
	GuiDefault("TypeWith9Keys_Keys")
	GuiControlGet, t9k_mySelection, ,t9k_myDrop
	t9k_final = %t9k_final%%t9k_mySelection%
	gosub, t9k_updateMainLabel

	if (t9k_casehelp = 1 && t9k_nextBig = 1)
	{
		t9k_nextBig = 0
		gosub, t9k_adaptBigButton
	}

	gosub,t9k_clearInput
return

t9k_bS:
	WinActivate, ahk_class Shell_TrayWnd
	GuiDefault("TypeWith9Keys_Keys")
	Menu,t9k_sonder,show
	WinActivate, ahk_group t9keyboardGroup
return

t9k_bG:
	GuiDefault("TypeWith9Keys_Keys")
	if (StrLen(t9k_combo)>0)
		gosub, t9k_b0

	Gui, Destroy
	Sleep 10
	SendRaw %t9k_final%

	if t9k_clipboard = 1
		ClipBoard = %t9k_final%

	t9k_final =
	gosub, t9k_clearInput
return

t9k_bM:
	GuiDefault("TypeWith9Keys_Keys")
	t9k_choice += 1
	gosub, t9k_makeChoice
return

t9k_bB:
	GuiDefault("TypeWith9Keys_Keys")
;Groß Schreiben
	t9k_nextBig += 1
	if t9k_nextBig = 3
		t9k_nextBig := 0

	gosub, t9k_adaptBigButton
	gosub, t9k_makeChoice
return

t9k_adaptBigButton:
	GuiDefault("TypeWith9Keys_Keys")
	if t9k_nextBig = 0
		GuiControl,, t9k_buttBig, abc
	if t9k_nextBig = 1
		GuiControl,, t9k_buttBig, Abc
	if t9k_nextBig = 2
		GuiControl,, t9k_buttBig, ABC
return

t9k_bD:
	GuiDefault("TypeWith9Keys_Keys")
	t9k_comLen := StrLen(t9k_combo)
	if (t9k_comLen < 2)
	{
	  gosub, t9k_clearInput
	}
	else
	{
	  t9k_combo := SubStr(t9k_combo,1,t9k_comLen-1)
	  gosub, t9k_searchWord
	}
return

t9k_bD2:
	GuiDefault("TypeWith9Keys_Keys")
	gosub, t9k_backspace
return

t9k_backspace:
	StringTrimRight, t9k_final, t9k_final, 1

	gosub, t9k_updateMainLabel
return

t9k_backword:
	loop
	{
		t9k_lastWordPos := InStr(t9k_final, A_Space, false, 0)
		if (t9k_lastWordPos!=StrLen(t9k_final))
			break

		StringTrimRight, t9k_final, t9k_final, 1
	}
	StringLeft, t9k_final, t9k_final, t9k_lastWordPos

	gosub, t9k_updateMainLabel
return

t9k_clearall:
	GuiDefault("TypeWith9Keys_Keys")
	t9k_final =
	gosub, t9k_updateMainLabel
return

t9k_b0:
	GuiDefault("TypeWith9Keys_Keys")
	gosub, t9k_putWord

	if t9k_LV3 =
		t9k_final := t9k_final . " "
	else
		if (t9k_casehelp = 1 && t9k_nextBig = 1)
		{
			t9k_nextBig = 0
			gosub, t9k_adaptBigButton
		}

	gosub, t9k_updateMainLabel
	gosub, t9k_clearInput
return

t9k_jc_FocusButtonThread:
	GuiDefault("TypeWith9Keys_Keys")

	if jc_povPushString = U
	{
		if jc_wheelMode
			GuiControl, Focus, t9k_buttChoice
		else
			GuiControl, Focus, t9k_butt2
		return
	}
	else
	if jc_povPushString = UR
	{
		if jc_wheelMode
			GuiControl, Focus, t9k_buttSDel
		else
			GuiControl, Focus, t9k_butt3
		return
	}
	else
	if jc_povPushString = R
	{
		if jc_wheelMode
			GuiControl, Focus, t9k_buttEnter
		else
			GuiControl, Focus, t9k_butt6
		return
	}
	else
	if jc_povPushString = RD
	{
		if jc_wheelMode
			GuiControl, Focus, t9k_buttBig
		else
			GuiControl, Focus, t9k_butt9
		return
	}
	else
	if jc_povPushString = D
	{
		if jc_wheelMode
			GuiControl, Focus, t9k_buttSpace
		else
			GuiControl, Focus, t9k_butt8
		return
	}
	else
	if jc_povPushString = DL
	{
		;if jc_wheelMode
		;  GuiControl, Focus, t9k_buttExtra
		;else
			GuiControl, Focus, t9k_butt7
		;return
	}
	else
	if jc_povPushString = L
	{
		if jc_wheelMode
			GuiControl, Focus, t9k_buttDel
		else
			GuiControl, Focus, t9k_butt4
		return
	}
	else
	if jc_povPushString = UL
	{
		GuiControl, Focus, t9k_butt1

	}
	else
	if jc_povPushString =
		GuiControl, Focus, t9k_butt5
return

t9k_jc_HoldAction_SelectButton_Start:
	SetTimer, t9k_jc_FocusButtonThread, 20
return

t9k_jc_HoldAction_SelectButton_End:
	GuiDefault("TypeWith9Keys_Keys")
	if jc_povPushString =
	{
		GuiControl, Focus, t9k_butt5
		SetTimer, t9k_jc_FocusButtonThread, off
	}
return

t9k_b1:
	WinActivate, ahk_class Shell_TrayWnd
	GuiDefault("TypeWith9Keys_Keys")
	Menu,t9k_digits,show
	WinActivate, ahk_group t9keyboardGroup
return

t9k_b2:
	GuiDefault("TypeWith9Keys_Keys")
	t9k_combo := t9k_combo . 2
	gosub, t9k_searchWord
return

t9k_b3:
	GuiDefault("TypeWith9Keys_Keys")
	t9k_combo := t9k_combo . 3
	gosub, t9k_searchWord
return

t9k_b4:
	GuiDefault("TypeWith9Keys_Keys")
	t9k_combo := t9k_combo . 4
	gosub, t9k_searchWord
return

t9k_b5:
	GuiDefault("TypeWith9Keys_Keys")
	t9k_combo := t9k_combo . 5
	gosub, t9k_searchWord
return

t9k_b6:
	GuiDefault("TypeWith9Keys_Keys")
	t9k_combo := t9k_combo . 6
	gosub, t9k_searchWord
return

t9k_b7:
	GuiDefault("TypeWith9Keys_Keys")
	t9k_combo := t9k_combo . 7
	gosub, t9k_searchWord
return

t9k_b8:
	GuiDefault("TypeWith9Keys_Keys")
	t9k_combo := t9k_combo . 8
	gosub, t9k_searchWord
return

t9k_b9:
	GuiDefault("TypeWith9Keys_Keys")
	t9k_combo := t9k_combo . 9
	gosub, t9k_searchWord
return

t9k_statusClick:
	GuiDefault("TypeWith9Keys_Keys")
	If (A_GuiEvent = "Normal" && A_EventInfo = 2)
		gosub, t9k_toggleSupport
return

t9k_toggleSupport:
	GuiDefault("TypeWith9Keys_Keys")
	if t9k_enableSupport = 0
		t9k_enableSupport := 1
	else
		t9k_enableSupport = 0

	SB_SetText(lng_t9k_support%t9k_enableSupport%,2)
return

#IfWinActive ahk_group t9keyboardGroup
Numpad0::
NumpadIns::
		gosub, t9k_b0
return

Numpad1::
NumpadEnd::
	if t9k_enableSupport = 0
	{
		WinActivate, ahk_class Shell_TrayWnd
		GuiDefault("TypeWith9Keys_Keys")
		Menu,t9k_seven,show
		WinActivate, ahk_group t9keyboardGroup
	}
	else
		gosub, t9k_b7
return

Numpad2::
NumpadDown::
	if t9k_enableSupport = 0
	{
		WinActivate, ahk_class Shell_TrayWnd
		GuiDefault("TypeWith9Keys_Keys")
		Menu,t9k_eight,show
		WinActivate, ahk_group t9keyboardGroup
	}
	else
		gosub, t9k_b8
return

Numpad3::
NumpadPgDn::
	if t9k_enableSupport = 0
	{
		WinActivate, ahk_class Shell_TrayWnd
		GuiDefault("TypeWith9Keys_Keys")
		Menu,t9k_nine,show
		WinActivate, ahk_group t9keyboardGroup
	}
	else
		gosub, t9k_b9
return

Numpad4::
NumpadLeft::
	if t9k_enableSupport = 0
	{
		WinActivate, ahk_class Shell_TrayWnd
		GuiDefault("TypeWith9Keys_Keys")
		Menu,t9k_four,show
		WinActivate, ahk_group t9keyboardGroup
	}
	else
		gosub, t9k_b4
return

Numpad5::
NumpadClear::
	if t9k_enableSupport = 0
	{
		WinActivate, ahk_class Shell_TrayWnd
		GuiDefault("TypeWith9Keys_Keys")
		Menu,t9k_five,show
		WinActivate, ahk_group t9keyboardGroup
	}
	else
		gosub, t9k_b5
return

Numpad6::
NumpadRight::
	if t9k_enableSupport = 0
	{
		WinActivate, ahk_class Shell_TrayWnd
		GuiDefault("TypeWith9Keys_Keys")
		Menu,t9k_six,show
		WinActivate, ahk_group t9keyboardGroup
	}
	else
		gosub, t9k_b6
return

Numpad7::
NumpadHome::
	if t9k_enableSupport = 0
	{
		WinActivate, ahk_class Shell_TrayWnd
		GuiDefault("TypeWith9Keys_Keys")
		Menu,t9k_one,show
		WinActivate, ahk_group t9keyboardGroup
	}
	else
		gosub, t9k_b1
return

Numpad8::
NumpadUp::
	if t9k_enableSupport = 0
	{
		WinActivate, ahk_class Shell_TrayWnd
		GuiDefault("TypeWith9Keys_Keys")
		Menu,t9k_two,show
		WinActivate, ahk_group t9keyboardGroup
	}
	else
		gosub, t9k_b2
return

Numpad9::
NumpadPgUp::
	if t9k_enableSupport = 0
	{
		WinActivate, ahk_class Shell_TrayWnd
		GuiDefault("TypeWith9Keys_Keys")
		Menu,t9k_three,show
		WinActivate, ahk_group t9keyboardGroup
	}
	else
		gosub, t9k_b3
return

NumpadDot::
NumpadDel::
	gosub, t9k_bS
return

NumpadDiv::
	gosub, t9k_bD2
return

NumpadMult::
	gosub, t9k_bM
return

NumpadAdd::
	gosub, t9k_bB
return

NumpadSub::
	gosub, t9k_bD
return

NumpadSub & NumpadAdd::
NumpadAdd & NumpadSub::
	gosub, t9k_toggleSupport
return

NumpadEnter::
	gosub, t9k_bG
return

#IfWinActive
