; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               QuickNote1
; -----------------------------------------------------------------------------
; Prefix:             qn1_
; Version:            1.6
; Date:               2008-05-23
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_QuickNote1:
	Prefix = qn1
	%Prefix%_ScriptName    = QuickNote1
	%Prefix%_ScriptVersion = 1.6
	%Prefix%_Author        = Wolfgang Reszel
	If (qn1_ScriptName = "QuickNote" 1)
	{
		qn1_FirstNote  = 1
;      qn1_ScriptName = QuickNote
		Hotkey_QuickNote1       = F12  ; Standard-Hotkey
		HotkeyPrefix_QuickNote1 =
	}
	Else
	{
		Hotkey_QuickNote1       =    ; Standard-Hotkey
		HotkeyPrefix_QuickNote1 =
	}

	CustomHotkey_QuickNote1 = 1    ; Benutzerdefiniertes Hotkey

	qn1_UndoSeparator := Chr(26)

	CreateGuiID("QuickNote1")
	CreateGuiID("QuickNote1Search")

	qn_FontStyle1 =
	qn_FontStyle2 = italic
	qn_FontStyle3 = bold
	qn_FontStyle4 = underline
	qn_FontStyle5 = bold italic
	qn_FontStyle6 = bold underline
	qn_FontStyle7 = italic underline
	qn_FontStyle8 = bold italic underline

	IconFile_On_QuickNote1 = %A_WinDir%\system32\shell32.dll
	IconPos_On_QuickNote1 = 208

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %qn1_ScriptName% - Kurznotiz auf Tastendruck
		Description                   = Per Tastendruck wird ein Notizfenster geöffnet bzw. geschlossen, welches sofort alle Eingaben im Hintergrund speichert, womit bei einem Absturz nichts verloren geht.
		lng_qn_NoteFile               = Notizdatei:
		lng_qn_FileType               = Text (*.txt)
		lng_qn_DateTime               = 'Timer:' dd.MM.yyyy ' - ' HH:mm:ss
		lng_qn_Font                   = Schriftart:
		lng_qn_FontSize               = Größe:
		lng_qn_FontStyle              = Stil:
		lng_qn_FontStyles             = Normal|Kursiv|Fett|Unterstrichen|Fett-Kursiv|Fett-Untersrichen|Kursiv-Unterstrichen|Fett-Kursiv-Unterstrichen
		lng_qn_Separator              = Folgende Trennlinie mit Strg+L
		lng_qn_InsertSepBefore        = in aktueller Zeile einfügen
		lng_qn_InsertSepAfter         = unter aktueller Zeile einfügen
		lng_qn_MsgPrint               = Soll die Notiz oder die Auswahl auf dem Standarddrucker ausgedruckt werden? `nWenn Textdateien (.txt) nicht anders konfiguriert sind, wird dazu Notepad verwendet.
		lng_qn_MsgDriveError          = Das Laufwerk mit der Notizdatei ist derzeit nicht verfügbar:
		lng_qn_MsgNotExist            = Die Notizdatei existiert nicht und wird nun angelegt.`nSollte die Notizdatei aus irgendwelchen Gründen verloren`ngegangen sein, kann der Inhalt unter Umständen durch`nmehrmaliges Strg+Z wiederhergestellt werden.
		lng_qn_Help                   = F1:`t`tDiese Hilfe`nStrg+Entf:`tWort nach Cursor löschen`nStrg+Löschen:`tWort vor Cursor löschen`nStrg+A:`t`tAlles auswählen`nStrg+D:`t`tDatum einfügen`nStrg+L:`t`tLinie einfügen`nStrg+R:`t`tAuswahl ausführen (URLs, Pfade ...)`nStrg+Z:`t`tUndo`nStrg+Y:`t`tRedo`nStrg+S:`t`tFenster schließen`nStrg+E`t`tAuswahl exportieren`nStrg+P:`t`tNotiz oder Auswahl drucken`nStrg+K:`t`tKompakte Darstellung umschalten`nStrg+F:`t`tText suchen`nF3:`t`tWeitersuchen`nDrag & Drop:`tDateipfad einfügen`nStrg+Hoch/Runter: Scrollen
		lng_qn_ExportSelection        = Ausgewählten Text exportieren
		lng_qn_SearchTerm             = Suchbegriff:
		lng_qn_Sound                  = Akustisches Signal für Timer
		lng_qn_SoundOption1           = Soundkarte
		lng_qn_SoundOption2           = PC-Speaker
		lng_qn_CompactView            = Kompakte Darstellung ohne Titelleiste und Timer (Fenster nur noch über ComfortResize verschiebbar/skalierbar)
		lng_qn_NoScrollBars           = Keine Scrollbalken (Scrollen nur noch über die Cursortasten möglich)
		lng_qn_DuplicateQuickNote     = QuickNote-Skript duplizieren (= zusätzliches Notizfenster)
		lng_qn1_RemoveQuickNote       = %qn1_ScriptName%-Skript löschen
		lng_qn1_AskRemoveQuickNote    = Durch das Löschen des %qn1_ScriptName%-Skripts gehen dessen Einstellungen verloren, die Notiz bleibt aber erhalten.`nZudem muss ac'tivAid direkt neu geladen werden, womit alle unbestätigten Einstellungen verloren gehen.`n`nMöchten Sie wirklich das %qn1_ScriptName%-Skript löschen?
		lng_qn_AllQuickNotes          = alle QuickNote-Fenster
		lng_qn_Colour                 = Farben
		lng_qn_FontColour             = Text
		lng_qn_BGColour               = Hintergrund
		lng_qn1_DontShowGUI           = Sichtbare Notizfenster beim Neustart nicht automatisch wieder anzeigen
		lng_qn1_NoPrintMessage        = Keine Sicherheitsabfrage beim Drucken der Auswahl/Notiz
		lng_qn1_ShowPrintButton       = Drucken-Schaltfläche [P] im Notizfenster anzeigen
		lng_qn1_AutoSeparator1        = Trennlinie bei jedem Aufruf automatisch am Anfang der Notiz einfügen
		lng_qn1_AutoSeparator2        = Trennlinie bei jedem Aufruf automatisch am Ende der Notiz einfügen
		lng_qn1_LookForFileModifications = Notiz-Datei auf Veränderung von anderen Programmen überwachen und automatisch aktualisieren
		lng_qn1_DelayShutdown         = Notizfenster beim Herunterfahren für ### Sekunden anzeigen lassen
		lng_qn1_ShowInTaskbar         = Notizfenster in der Taskleiste anzeigen
		lng_qn1_CloseOnlyIfActive     = Das Tastaturkürzel reaktiviert ein inaktives Notizfenster, statt es zu schließen
		lng_qn1_NoteIsAlwaysOnTop     = Notizfenster immer im Vordergrund halten
		lng_qn1_unmuteOnMute1         = Stummschaltung für akustischen Alarm deaktivieren
		lng_qn1_ShowFileName          = Dateinamen als Fenstertitel verwenden
		lng_qn1_AutoPasteSelection    = Ausgewählten Text automatisch an das Ende der Notiz einfügen
	}
	else        ; = other languages (english)
	{
		MenuName                      = %qn1_ScriptName% - quick notepad with a hotkey
		Description                   = Opens/closes a simple note-window which saves its changes directly to the configured file.
		lng_qn_NoteFile               = File:
		lng_qn_FileType               = Text (*.txt)
		lng_qn_DateTime               = 'Timer:' yyyy-MM-dd ' - ' HH:mm:ss
		lng_qn_Font                   = Font:
		lng_qn_FontSize               = Size:
		lng_qn_FontStyle              = Style:
		lng_qn_Separator              = Insert following separator with Ctrl+L
		lng_qn_InsertSepBefore        = in the same line
		lng_qn_InsertSepAfter         = one line below
		lng_qn_MsgPrint               = The note will directly be printed with the associated`nprogram (Notepad) to the standard-printer. Are you sure?
		lng_qn_MsgDriveError          = The drive containing the note file is currently not available:
		lng_qn_MsgNotExist            = The note file does not exist and will be created.
		lng_qn_Help                   = F1:`t`tthis help`nCtrl+Del:`tdelete word after cursor`nCtrl+Backspace:`tdelete word infront of cursor`nCtrl+A:`t`tselect all`nCtrl+D:`t`tinsert date`nCtrl+L:`t`tinsert separator`nCtrl+R:`t`texecute selection (URLs, paths ...)`nCtrl+Z:`t`tUndo`nCtrl+Y:`t`tRedo`nCtrl+S:`t`tclose window`nCtrl+P:`t`tprint note or selection`nCtrl+K:`t`tToggle compact view`nCtrl+F:`t`tFind`nF3:`t`tFind next`nDrag & Drop:`tinsert path of dropped file`nCtrl+Up/Down:`tScroll
		lng_qn_ExportSelection        = export selected text
		lng_qn_SearchTerm             = search term:
		lng_qn_Sound                  = acoustic timer-feedback
		lng_qn_SoundOption1           = Soundcard
		lng_qn_SoundOption2           = PC-Speaker
		lng_qn_CompactView            = compact view without title-bar and timer (window can only be move/resized with ComfortResize)
		lng_qn_NoScrollBars           = no scroll bars (scrolling is only possible with the cursor-keys)
		lng_qn_DuplicateQuickNote     = Duplicate QuickNote script (= additional note window)
		lng_qn1_RemoveQuickNote       = Remove QuickNote script (%qn1_ScriptName%)
		lng_qn1_AskRemoveQuickNote    = Removing the %qn1_ScriptName% script will delete its settings, but the notes-file won't be deleted.`nAs ac'tivAid would be directly reloaded, you'll loose all unconfirmed settings.`n`nDo you really want to remove the QuickNote script?
		lng_qn_AllQuickNotes          = all QuickNote windows
		lng_qn_Colour                 = Colors
		lng_qn_FontColour             = Text
		lng_qn_BGColour               = Background
		lng_qn1_DontShowGUI           = Don't show visible note windows after reloading
		lng_qn1_NoPrintMessage        = Don't message box when printing
		lng_qn1_ShowPrintButton       = Show print button [P] in the note window
		lng_qn1_AutoSeparator1        = Add separator to the top when opening the note window
		lng_qn1_AutoSeparator2        = Add separator to the end when opening the note window
		lng_qn1_LookForFileModifications = Look for modifications to the note file from other processes and update the note automatically
		lng_qn1_DelayShutdown         = Show note window for ### seconds at shutdown
		lng_qn1_ShowInTaskbar         = Show note window in the task bar
		lng_qn1_CloseOnlyIfActive     = The Hotkey will reactivate an inactive note window, instead of closing it
		lng_qn1_NoteIsAlwaysOnTop     = Show note window always on top
		lng_qn1_unmuteOnMute1         = Deactivate muting for alert signal
		lng_qn1_ShowFileName          = Use file name as window title
		lng_qn1_AutoPasteSelection    = Automatically paste the selected text at the end of the note
	}
	If CustomLanguage <>
		gosub, CustomLanguage

	IniRead, DataFile_QuickNote1, %ConfigFile%, QuickNote1, NotesFile, settings\QuickNote.txt
	If DataFile_QuickNote1 =
		DataFile_QuickNote1 = settings\QuickNote.txt
	IniRead, qn1_DateTime, %ConfigFile%, QuickNote1, Timer, None
	IniRead, qn1_Line, %ConfigFile%, QuickNote1, Line,1
	IniRead, qn1_Col, %ConfigFile%, QuickNote1, Col,1
	IniRead, qn1_Font, %ConfigFile%, QuickNote1, Font, Arial
	IniRead, qn1_FontSize, %ConfigFile%, QuickNote1, FontSize, 9
	IniRead, qn1_FontStyle, %ConfigFile%, QuickNote1, FontStyle, 1
	IniRead, qn1_BGColour, %ConfigFile%, QuickNote1, BackgroundColour, ffffcc
	IniRead, qn1_FontColour, %ConfigFile%, QuickNote1, FontColour, 000000
	IniRead, qn1_Separator, %ConfigFile%, QuickNote1, Separator, ------------------------------------------------------------
	IniRead, qn1_SeparatorMode, %ConfigFile%, QuickNote1, SeparatorMode, 2
	IniRead, qn1_SoundMode1, %ConfigFile%, QuickNote1, SoundMode1, 1
	IniRead, qn1_SoundMode2, %ConfigFile%, QuickNote1, SoundMode2, 0
	IniRead, qn1_CompactView, %ConfigFile%, QuickNote1, CompactView, 0
	IniRead, qn1_NoScrollBars, %ConfigFile%, QuickNote1, NoScrollBars, 0
	IniRead, qn1_SoundFile, %ConfigFile%, QuickNote1, SoundFile, %A_ScriptDir%\extensions\Media\ac'tivAid_QuickNote.wav
	IniRead, qn1_ShutdownDelaySeconds, %ConfigFile%, QuickNote1, ShutdownDelaySeconds, 10
	IniRead, qn1_MaxUndos, %ConfigFile%, QuickNote1, MaxUndos, 50

	IniRead, qn1_X, %ConfigFile%, QuickNote1, X, 100
	IniRead, qn1_Y, %ConfigFile%, QuickNote1, Y, 100
	IniRead, qn1_H, %ConfigFile%, QuickNote1, H, 200
	IniRead, qn1_W, %ConfigFile%, QuickNote1, W, 300

	lng_qn1_DelayShutdown := #(lng_qn1_DelayShutdown,qn1_ShutdownDelaySeconds)

	qn1_FontStyleParameter := qn_FontStyle%qn1_FontStyle%

	RegisterAdditionalSetting( "qn1", "ShowPrintButton", 0 )
	RegisterAdditionalSetting( "qn1", "NoPrintMessage", 0 )
	RegisterAdditionalSetting( "qn1", "DontShowGUI", 0 )
	RegisterAdditionalSetting( "qn1", "AutoSeparator1", 0 )
	RegisterAdditionalSetting( "qn1", "AutoSeparator2", 0 )
	RegisterAdditionalSetting( "qn1", "LookForFileModifications", 1 )
	RegisterAdditionalSetting( "qn1", "DelayShutdown", 0 )
	RegisterAdditionalSetting( "qn1", "ShowInTaskbar", 0 )
	RegisterAdditionalSetting( "qn1", "NoteIsAlwaysOnTop", 1 )
	RegisterAdditionalSetting( "qn1", "CloseOnlyIfActive", 0 )
	RegisterAdditionalSetting( "qn1", "unmuteOnMute1", 0 )
	RegisterAdditionalSetting( "qn1", "ShowFileName", 0 )
	RegisterAdditionalSetting( "qn1", "AutoPasteSelection", 0 )

	IniRead, qn1_TimerMenu, %ConfigFile%, QuickNote1, TimerMenu, 1m, 2m, 3m, 4m, 5m, 6m, 7m, 8m, 9m, 10m, 12m, 15m, 20m, 25m, 30m, 40m, 45m, 50m, 55m, -, 1h, 1½h, 2h, 3h, 4h, 5h, 10h, -, 1d, 2d, 3d, 4d, 5d, 6d, 7d

	qn1_TimerMenu := RegExReplace(" " qn1_TimerMenu ",", "i)([^1]1)\s*m\s*,", "$1 " lng_Minute "," )
	qn1_TimerMenu := RegExReplace(qn1_TimerMenu , "i)([^1]1)\s*h\s*,", "$1 " lng_Hour "," )
	qn1_TimerMenu := RegExReplace(qn1_TimerMenu , "i)([^1]1)\s*d\s*,", "$1 " lng_Day "," )
	qn1_TimerMenu := RegExReplace(qn1_TimerMenu , "i)([^a-z]+?)\s*m\s*,", "$1 " lng_Minutes "," )
	qn1_TimerMenu := RegExReplace(qn1_TimerMenu , "i)([^a-z]+?)\s*h\s*,", "$1 " lng_Hours "," )
	qn1_TimerMenu := RegExReplace(qn1_TimerMenu , "i)([^a-z]+?)\s*d\s*,", "$1 " lng_Days "," )
	StringTrimRight, qn1_TimerMenu, qn1_TimerMenu, 1

	IniRead, qn1_UndoBufferFileNoDeref, %ConfigFile%, QuickNote1, UndoFile, settings/QuickNote1_Undos.dat
	qn1_UndoBufferFile := func_Deref(qn1_UndoBufferFileNoDeref)

	If qn1_FirstNote = 1
		IniRead, qn_HotkeyForAll, %ConfigFile%, QuickNote1, HotkeyForAllWindows, 0

	If (!FileExist("settings\QuickNote.txt") AND DataFile_QuickNote1 = "settings\QuickNote.txt" )
	{
		FileAppend, %lng_qn_Help%, settings\QuickNote.txt
	}

	; verfügbare Schriften aus der Registry auslesen
	Loop, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts, 0 ,0
	{
		StringGetPos, qn1_tempPos, A_LoopRegname, (
		If qn1_tempPos > 2
			StringLeft, qn1_LoopRegname, A_LoopRegname, qn1_tempPos-1
		Else
			qn1_LoopRegname = %A_LoopRegname%
		qn1_AllFonts = %qn1_LoopRegname%|%qn1_AllFonts%
	}
	Sort, qn1_AllFonts, D|

	func_AddMessage(0x100, "qn1_OnMessage_EditKeys")

	; UndoBuffer zurückladen
	qn1_UndoCounter = 0
	qn1_RedoMax = 0
	qn1_ReadLine = 1
	FileRead, qn1_UndoBuffer, %qn1_UndoBufferFile%
	Loop, Parse, qn1_UndoBuffer, %qn1_UndoSeparator%
	{
		If A_LoopField =
			continue

		StringReplace, qn1_LoopField, A_LoopField, %qn1_UndoSeparator%,,All
		StringReplace, qn1_LoopField, qn1_LoopField, `r`n, `n, All

		If qn1_ReadLine = 1
		{
			qn1_ReadLine = 2
			qn1_UndoBuffer[%qn1_UndoCounter%] = %qn1_LoopField%
		}
		Else
		{
			qn1_ReadLine = 1
			qn1_UndoBufferIndex[%qn1_UndoCounter%] = %qn1_LoopField%
			qn1_UndoCounter++
			qn1_RedoMax++
		 }
	}
	qn1_UndoBuffer =

	If activAid_HasChanged = 1
	{
		IfNotExist, extensions\Media\ac'tivAid_QuickNote.wav
		{
			func_UnpackSplash("extensions\Media\ac'tivAid_QuickNote.wav")
			FileInstall, extensions\Media\ac'tivAid_QuickNote.wav, extensions\Media\ac'tivAid_QuickNote.wav
		}
	}
Return

SettingsGui_QuickNote1:
	AdditionalConfigFiles_QuickNote1 := func_Deref(DataFile_QuickNote1)
	If qn1_FirstNote = 1
		Gui, Add, CheckBox, -Wrap vqn_HotkeyForAll x+5 yp+4 Checked%qn_HotkeyForAll% gsub_CheckIfSettingsChanged, %lng_qn_AllQuickNotes%
	Gui, Add, Text, xs+10 ys+40, %lng_qn_NoteFile%
	qn1_FileOld := func_Deref(DataFile_QuickNote1)
	Gui, Add, Edit, R1 x+10 yp-3 w390 gsub_CheckIfSettingsChanged vDataFile_QuickNote1, %DataFile_QuickNote1%
	Gui, Add, Button, -Wrap x+5 W100 gqn1_sub_Browse, %lng_Browse%
	Gui, Add, Text, xs+10 y+10, %lng_qn_Separator%
	Gui, Add, Radio, -Wrap x+5 gsub_CheckIfSettingsChanged vqn1_SeparatorMode1_tmp, %lng_qn_InsertSepBefore%
	Gui, Add, Radio, -Wrap x+5 gsub_CheckIfSettingsChanged vqn1_SeparatorMode2_tmp, %lng_qn_InsertSepAfter%
	GuiControl, , qn1_SeparatorMode%qn1_SeparatorMode%_tmp, 1
	Gui, Font,s%qn1_FontSize% %qn1_FontStyleParameter%,%qn1_Font%
	Gui, Add, Edit, xs+10 y+5 w550 h22 gsub_CheckIfSettingsChanged vqn1_Separator, %qn1_Separator%
	Gui, Font
	Gui, Font, S%FontSize%

	Gui, Add, Text, xs+10 y+15, %lng_qn_Font%
	Gui, Add, ComboBox, x+5 yp-3 w250 vqn1_Font gqn1_sub_ChangeFont, %qn1_AllFonts%
	Gui, Add, Text, x+5 yp+3, %lng_qn_FontSize%
	Gui, Add, ComboBox, x+5 yp-3 w50 vqn1_FontSize gqn1_sub_ChangeFont, 8|9|10|11|12|14|16|18|20|24|36|48
	Gui, Add, Text, x+5 yp+3, %lng_qn_FontStyle%
	Gui, Add, ComboBox, x+5 yp-3 w135 vqn1_FontStyle Altsubmit gqn1_sub_ChangeFont, %lng_qn_FontStyles%
	GuiControl,ChooseString, qn1_Font, %qn1_Font%
	GuiControl,, qn1_FontSize, %qn1_FontSize%
	GuiControl,ChooseString, qn1_FontSize, %qn1_FontSize%
	GuiControl,Choose, qn1_FontStyle, %qn1_FontStyle%

	Gui, Font,s%qn1_FontSize% %qn1_FontStyleParameter%,%qn1_Font%
	Gui, Add, Edit, xs+10 y+5 w370 h60 vqn1_FontExample, abcdefghijklmnopqrstuvwxyzöäüß`nABCDEFGHIJKLMNOPQRSTUVWXYZÖÄÜ`n1234567890,.-_#'+*~!"§$`%&/()=?\{}[]
	; " ; end qoute for syntax highlighting

	Gosub, GuiDefaultFont
	Gui, Add, GroupBox, x+10 yp-5 w170 h65, %lng_qn_Colour%
	func_ChooseColorAddGuiControl("qn1_FontColour",lng_qn_FontColour ":","xs+400 yp+18 w60")
	func_ChooseColorAddGuiControl("qn1_BGColour",lng_qn_BGColour ":","xs+400 y+6 w60")

	Gosub, GuiDefaultFont
	Gui, Add, CheckBox, -Wrap xs+10 y+15 vqn1_CompactView Checked%qn1_CompactView% gsub_CheckIfSettingsChanged, %lng_qn_CompactView%
	Gui, Add, CheckBox, -Wrap vqn1_NoScrollBars Checked%qn1_NoScrollBars% gsub_CheckIfSettingsChanged, %lng_qn_NoScrollBars%
	Gui, Add, Text, y+10, %lng_qn_Sound%:
	Gui, Add, CheckBox, -Wrap x+5 vqn1_SoundMode1 Checked%qn1_SoundMode1% gsub_CheckIfSettingsChanged, %lng_qn_SoundOption1%
	Gui, Add, CheckBox, -Wrap x+5 vqn1_SoundMode2 Checked%qn1_SoundMode2% gsub_CheckIfSettingsChanged, %lng_qn_SoundOption2%

	If ((SimpleMainGUI = "" OR A_IsCompiled = 0) AND MainDirNotWriteable <> 1)
	{
		If qn1_FirstNote = 1
			Gui, Add, Button, Wrap xs+410 ys+245 h34 w150 gqn1_sub_DuplicateQuickNote, %lng_qn_DuplicateQuickNote%
		Else
			Gui, Add, Button, -Wrap xs+410 ys+257 h18 w150 gqn1_sub_RemoveQuickNote, %lng_qn1_RemoveQuickNote%
	}
Return

qn1_sub_ChangeFont:
	GuiControlGet, qn1_TmpFont,, qn1_Font
	GuiControlGet, qn1_TmpFontSize,, qn1_FontSize
	GuiControlGet, qn1_TmpFontStyle,, qn1_FontStyle
	qn1_TmpFontStyleParameter := qn_FontStyle%qn1_TmpFontStyle%
	Gui, Font
	Gui, %GuiID_QuickNote1%:Font
	Gui, Font,s%qn1_TmpFontSize% %qn1_TmpFontStyleParameter%,%qn1_TmpFont%
	Gui, %GuiID_QuickNote1%:Font,s%qn1_TmpFontSize% %qn1_TmpFontStyleParameter%,%qn1_TmpFont%
	GuiControl, Font, qn1_Separator
	GuiControl, Font, qn1_FontExample
	IfWinExist, ahk_id %qn1_GUIid%
		GuiControl, %GuiID_QuickNote1%:Font, qn1_NewContent

	Gosub, sub_CheckIfSettingsChanged
Return

qn1_sub_Browse:
	Gui +OwnDialogs
	Fileselectfile, qn1_FileNew, 10,,,%lng_qn_FileType%
	If qn1_FileNew <>
		GuiControl,,DataFile_QuickNote1, %qn1_FileNew%
Return

SaveSettings_QuickNote1:
	If qn1_SeparatorMode1_tmp = 1
		qn1_SeparatorMode = 1
	If qn1_SeparatorMode2_tmp = 1
		qn1_SeparatorMode = 2

	If DataFile_QuickNote1 =
		DataFile_QuickNote1 = settings\QuickNote.txt
	IniWrite, %DataFile_QuickNote1%, %ConfigFile%, QuickNote1, NotesFile
	If (func_Deref(DataFile_QuickNote1) = ChangeLogFile)
		FileRead, ChangeLog, func_Deref(DataFile_QuickNote1)
	If (func_Deref(DataFile_QuickNote1) = ReadMeFile)
		FileRead, Readme, % func_Deref(DataFile_QuickNote1)
	IniWrite, %qn1_Font%, %ConfigFile%, QuickNote1, Font
	IniWrite, %qn1_FontSize%, %ConfigFile%, QuickNote1, FontSize
	IniWrite, %qn1_FontStyle%, %ConfigFile%, QuickNote1, FontStyle
	IniWrite, %qn1_FontColour%, %ConfigFile%, QuickNote1, FontColour
	IniWrite, %qn1_BGColour%, %ConfigFile%, QuickNote1, BackgroundColour
	IniWrite, %qn1_Separator%, %ConfigFile%, QuickNote1, Separator
	IniWrite, %qn1_SeparatorMode%, %ConfigFile%, QuickNote1, SeparatorMode
	IniWrite, %qn1_SoundMode1%, %ConfigFile%, QuickNote1, SoundMode1
	IniWrite, %qn1_SoundMode2%, %ConfigFile%, QuickNote1, SoundMode2
	If qn1_FileOld <> %DataFile_QuickNote1%
		FileDelete, %qn1_UndoBufferFile%
	IniWrite, %qn1_CompactView%, %ConfigFile%, QuickNote1, CompactView
	IniWrite, %qn1_NoScrollBars%, %ConfigFile%, QuickNote1, NoScrollBars
	If qn1_FirstNote = 1
		IniWrite, %qn_HotkeyForAll%, %ConfigFile%, QuickNote1, HotkeyForAllWindows
	IniWrite, %qn1_SoundFile%, %ConfigFile%, QuickNote1, SoundFile
	IniWrite, %qn1_TimerMenu%, %ConfigFile%, QuickNote1, TimerMenu
	IniWrite, %qn1_UndoBufferFileNoDeref%, %ConfigFile%, QuickNote1, UndoFile
	IniWrite, %qn1_ShutdownDelaySeconds%, %ConfigFile%, QuickNote1, ShutdownDelaySeconds

	IniWrite, %qn1_X%, %ConfigFile%, QuickNote1, X
	IniWrite, %qn1_Y%, %ConfigFile%, QuickNote1, Y
	IniWrite, %qn1_H%, %ConfigFile%, QuickNote1, H
	IniWrite, %qn1_W%, %ConfigFile%, QuickNote1, W

	qn1_FontStyleParameter := qn_FontStyle%qn1_FontStyle%
Return

CancelSettings_QuickNote1:
	Gui, %GuiID_QuickNote1%:Font,s%qn1_FontSize% %qn1_FontStyleParameter%,%qn1_Font%
	IfWinExist, ahk_id %qn1_GUIid%
		GuiControl, %GuiID_QuickNote1%:Font, qn1_NewContent
Return

DoEnable_QuickNote1:
	SetTimer, qn1_Timer, 1000
	func_AddMessage(0x100, "qn1_OnMessage_EditKeys")

	qn1_ToolWindow =
	If qn1_ShowInTaskbar = 0
		qn1_ToolWindow := " +ToolWindow "

	qn1_AlwaysOnTop =
	If qn1_NoteIsAlwaysOnTop = 1
		qn1_AlwaysOnTop := " +AlwaysOnTop "

	If qn1_DontShowGUI != 1
		IniRead, qn1_GUI, %ConfigFile%, QuickNote1, ShowGUI, %qn1_GUI%
	If qn1_GUI = yes
	{
		IfWinNotExist, ahk_id %qn1_GUIid%
			If Enable_QuickNote1 = 1
			{
				Gosub, qn1_main_QuickNote1
				qn1_GUI =
			}
	}
Return

DoDisable_QuickNote1:
	func_RemoveMessage(0x100, "qn1_OnMessage_EditKeys")
	IfWinExist, ahk_id %qn1_GUIid%
	{
		Gosub, QuickNote1GuiClose
		IniWrite, yes, %ConfigFile%, QuickNote1, ShowGUI
		qn1_GUI = yes
	}
	SetTimer, qn1_Timer, Off
Return

DefaultSettings_QuickNote1:
Return

OnExitAndReload_QuickNote1:
	If (qn1_DelayShutdown = 1 AND Enable_QuickNote1 = 1 AND (A_ExitReason = "Shutdown" OR A_ExitReason = "Logoff"))
	{
		IfWinNotExist, ahk_id %qn1_GUIid%
			Gosub, qn1_main_QuickNote1
		WinGetTitle, qn1_tmpTitle, ahk_id %qn1_GUIid%
		Critical, Off
		Loop, % qn1_ShutdownDelaySeconds*10
		{
			WinSetTitle, ahk_id %qn1_GUIid%,, % "(" Ceil(qn1_ShutdownDelaySeconds-A_Index/10) ") " qn1_tmpTitle
			Sleep, 100
			IfWinNotExist, ahk_id %qn1_GUIid%
				Break
		}
		Critical, On
	}
	IfWinExist, ahk_id %qn1_GUIid%
	{
		IniWrite, yes, %ConfigFile%, QuickNote1, ShowGUI
		GuiControlGet, qn1_EditText,%GuiID_QuickNote1%:,qn1_NewContent
		If ( qn1_EditText <> qn1_UndoBuffer[%qn1_UndoCounter%] )
			Gosub, qn1_sub_UndoBuffer
		Gosub, QuickNote1GuiClose
		If qn1_DontShowGUI != 1
			IniWrite, yes, %ConfigFile%, QuickNote1, ShowGUI
	}
Return

Update_QuickNote1:
	IniRead, qn1_SoundMode, %ConfigFile%, QuickNote1, SoundMode
	If qn1_SoundMode <> ERROR
	{
		IniDelete, %ConfigFile%, QuickNote1, SoundMode
		If qn1_SoundMode = 2
			IniRead, qn1_SoundMode1, %ConfigFile%, QuickNote1, SoundMode1, 1
		If qn1_SoundMode = 3
			IniRead, qn1_SoundMode2, %ConfigFile%, QuickNote1, SoundMode2, 1
	}

	qn1_ScriptName = QuickNote1
	If (qn1_ScriptName <> "QuickNote" 1)
		Return
	IniRead, DataFile_QuickNote1, %ConfigFile%, QuickNote, NotesFile
	IniRead, qn1_DateTime, %ConfigFile%, QuickNote, Timer, None
	IniRead, qn1_Line, %ConfigFile%, QuickNote, Line,1
	IniRead, qn1_Col, %ConfigFile%, QuickNote, Col,1
	IniRead, qn1_Font, %ConfigFile%, QuickNote, Font, Arial
	IniRead, qn1_FontSize, %ConfigFile%, QuickNote, FontSize, 9
	IniRead, qn1_FontStyle, %ConfigFile%, QuickNote, FontStyle, 1
	IniRead, qn1_BGColour, %ConfigFile%, QuickNote, BackgroundColour, ffffcc
	IniRead, qn1_FontColour, %ConfigFile%, QuickNote, FontColour, 000000
	IniRead, qn1_Separator, %ConfigFile%, QuickNote, Separator, ------------------------------------------------------------
	IniRead, qn1_SoundMode, %ConfigFile%, QuickNote, SoundMode, 2
	IniRead, qn1_CompactView, %ConfigFile%, QuickNote, CompactView, 0
	IniRead, qn1_NoScrollBars, %ConfigFile%, QuickNote, NoScrollBars, 0
	IniRead, qn1_X, %ConfigFile%, QuickNote, X, 100
	IniRead, qn1_Y, %ConfigFile%, QuickNote, Y, 100
	IniRead, qn1_H, %ConfigFile%, QuickNote, H, 200
	IniRead, qn1_W, %ConfigFile%, QuickNote, W, 300
	IniRead, Hotkey_QuickNote1, %ConfigFile%, QuickNote, Hotkey_QuickNote, F12
	IniRead, qn1_EQ, %ConfigFile%, activAid, Enable_QuickNote
	IniRead, qn1_ETQ, %ConfigFile%, activAid, EnableTray_QuickNote

	qn1_FontStyleParameter := qn_FontStyle%qn1_FontStyle%

	If DataFile_QuickNote1 <> ERROR
	{
		IniWrite, %DataFile_QuickNote1%, %ConfigFile%, QuickNote1, NotesFile
		IniWrite, %qn1_DateTime%, %ConfigFile%, QuickNote1, Timer
		IniWrite, %qn1_Line%, %ConfigFile%, QuickNote1, Line
		IniWrite, %qn1_Col%, %ConfigFile%, QuickNote1, Col
		IniWrite, %qn1_Font%, %ConfigFile%, QuickNote1, Font
		IniWrite, %qn1_FontSize%, %ConfigFile%, QuickNote1, FontSize
		IniWrite, %qn1_FontStyle%, %ConfigFile%, QuickNote1, FontStyle
		IniWrite, %qn1_BGColour%, %ConfigFile%, QuickNote1, BackgroundColour
		IniWrite, %qn1_FontColour%, %ConfigFile%, QuickNote1, FontColour
		IniWrite, %qn1_Separator%, %ConfigFile%, QuickNote1, Separator
		If qn1_SoundMode = 2
			IniRead, qn1_SoundMode1, %ConfigFile%, QuickNote1, SoundMode1, 1
		If qn1_SoundMode = 3
			IniRead, qn1_SoundMode2, %ConfigFile%, QuickNote1, SoundMode2, 1
		IniWrite, %qn1_CompactView%, %ConfigFile%, QuickNote1, CompactView
		IniWrite, %qn1_NoScrollBars%, %ConfigFile%, QuickNote1, NoScrollBars
		IniWrite, %qn1_X%, %ConfigFile%, QuickNote1, X
		IniWrite, %qn1_Y%, %ConfigFile%, QuickNote1, Y
		IniWrite, %qn1_H%, %ConfigFile%, QuickNote1, H
		IniWrite, %qn1_W%, %ConfigFile%, QuickNote1, W
		IniWrite, %Hotkey_QuickNote1%, %ConfigFile%, QuickNote1, Hotkey_QuickNote1
		IniWrite, %qn1_EQ%, %ConfigFile%, activAid, Enable_QuickNote
		IniWrite, %qn1_ETQ%, %ConfigFile%, activAid, EnableTray_QuickNote

		IniDelete, %ConfigFile%, activAid, Enable_QuickNote
		IniDelete, %ConfigFile%, activAid, EnableTray_QuickNote

		IniDelete, %ConfigFile%, QuickNote

		FileRead, ExtHeader, settings\extensions_header.ini
		StringReplace, ExtHeader, ExtHeader, = QuickNote, = QuickNote1
		StringReplace, ExtHeader, ExtHeader, = QuickNote11, = QuickNote1
		FileDelete, settings\extensions_header.ini
		FileAppend, %ExtHeader%, settings\extensions_header.ini
	}
Return

ResetWindows_QuickNote1:
	IniDelete, %ConfigFile%, QuickNote1, X
	IniDelete, %ConfigFile%, QuickNote1, Y
	IniDelete, %ConfigFile%, QuickNote1, H
	IniDelete, %ConfigFile%, QuickNote1, W
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

sub_Hotkey_QuickNote1:
	If (qn1_FirstNote = 1 AND qn_HotkeyForAll = 1)
	{
		IfWinExist, ahk_id %qn1_GUIid%
			Loop, 30
			{
				If ( IsLabel("qn" A_Index "_main_QuickNote" A_Index) )
					IfWinExist, % "ahk_id " qn%A_Index%_GUIid
						Gosub, QuickNote%A_Index%GuiClose
			}
		Else
			Loop, 30
			{
				If ( IsLabel("qn" A_Index "_main_QuickNote" A_Index) )
					IfWinNotExist, % "ahk_id " qn%A_Index%_GUIid
						Gosub, qn%A_Index%_main_QuickNote%A_Index%
			}
	}
	Else
		Gosub, qn1_main_QuickNote1
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

qn1_main_QuickNote1:
	; Critical
	IfWinExist, ahk_id %qn1_GUIid%
	{
		If (qn1_CloseOnlyIfActive = 1 AND !WinActive("ahk_id " qn1_GUIid))
			WinActivate, ahk_id %qn1_GUIid%
		Else
			Gosub, QuickNote1GuiClose
		Return
	}

	If qn1_AutoPasteSelection
	{
		qn1_OldClipboard := ClipboardAll
		func_GetSelection(1,1)
	}

	If ( !InStr(func_Deref(DataFile_QuickNote1), ":\") AND !InStr(func_Deref(DataFile_QuickNote1), "\\") )
		qn1_DataFile := A_WorkingDir "\" func_Deref(DataFile_QuickNote1)
	Else
		qn1_DataFile := func_Deref(DataFile_QuickNote1)

	SplitPath, qn1_DataFile, qn1_DataFileName,qn1_DataFilePath,,,qn1_DataFileDrive
	IfNotExist, %qn1_DataFile%
	{
		DriveGet, qn1_DataFileStatus, Status, %qn1_DataFilePath%
		If qn1_DataFileStatus <> Ready
		{
			MsgBox,16,%ScriptName% - QuickNote1, %lng_qn_MsgDriveError% %qn1_DataFileDrive% (%qn1_DataFileStatus%)
			Return
		}
		Else
		{
			MsgBox,49,%ScriptName% - QuickNote1, %lng_qn_MsgNotExist%`n`n%qn1_DataFile%
			IfMsgBox, Cancel
				Return
		}
	}

	If qn1_CompactView <> 1
	{
		qn1_BorderHeight := BorderHeight
		If qn1_ShowInTaskbar = 1
			qn1_CaptionHeight :=  CaptionHeight + qn1_BorderHeight * 2
		Else
			qn1_CaptionHeight :=  SmallCaptionHeight + qn1_BorderHeight * 2
		qn1_TimerHeight = 21
	}
	Else
	{
		qn1_BorderHeight = 0
		qn1_CaptionHeight = 0
		qn1_TimerHeight = 0
	}

	IniWrite, yes, %ConfigFile%, QuickNote1, ShowGUI

	IniRead, qn1_X, %ConfigFile%, QuickNote1, X, 100
	IniRead, qn1_Y, %ConfigFile%, QuickNote1, Y, 100
	IniRead, qn1_H, %ConfigFile%, QuickNote1, H, 200
	IniRead, qn1_W, %ConfigFile%, QuickNote1, W, 300

	IniRead, qn1_ScrollPos, %ConfigFile%, QuickNote1, ScrollPos, 0

	If (qn1_W < 80)
		qn1_W = 80
	If (qn1_H < 50)
		qn1_H = 50
	If (qn1_X < WorkAreaLeft-qn1_W+20)
		qn1_X := WorkAreaLeft-qn1_W+20
	If (qn1_X > WorkAreaRight-20)
		qn1_X := WorkAreaRight-20
	If (qn1_Y < WorkAreaTop)
		qn1_Y := WorkAreaTop
	If (qn1_Y > WorkAreaBottom-20)
		qn1_Y := WorkAreaBottom-20
	IniRead, qn1_BGColour, %ConfigFile%, QuickNote1, BackgroundColour, ffffcc
	IniRead, qn1_FontColour, %ConfigFile%, QuickNote1, FontColour, 000000

	qn1_H := qn1_H
	qn1_W := qn1_W

	qn1_edH := qn1_H - qn1_TimerHeight
	qn1_edW := qn1_W

	If (func_StrLeft(DataFile_QuickNote1, 1) = "*")
	{
		StringTrimLeft, qn1_DataFile, DataFile_QuickNote1, 1
		qn1_DataFile := func_Deref(DataFile_QuickNote1)
		SplitPath, qn1_DataFile, qn1_DataFileName
		WinGet, qn1_WinID, ID, A
		qn1_DataFilePath := func_GetDir(qn1_WinID)
		if qn1_DataFilePath <>
		{
			SplitPath, qn1_DataFilePath, qn1_DataFileFolder, qn1_DataFileParent
			IfExist, %qn1_DataFilePath%\%qn1_DataFileName%
			{
				qn1_DataFile = %qn1_DataFilePath%\%qn1_DataFileName%
			}
			Else IfExist, %qn1_DataFileParent%\%qn1_DataFileName%
			{
				qn1_DataFile = %qn1_DataFileParent%\%qn1_DataFileName%
				SplitPath, qn1_DataFileParent, qn1_DataFileFolder
			}
		}
	}

	FileRead, qn1_newContent, %qn1_DataFile%

	If qn1_CompactView <> 1
		qn1_GUIid := GuiDefault("QuickNote1", "+Resize +LastFound" qn1_AlwaysOnTop qn1_ToolWindow " +MinSize100x50")
	Else
		qn1_GUIid := GuiDefault("QuickNote1", "-Resize +LastFound" qn1_AlwaysOnTop qn1_ToolWindow " -Caption -Border +MinSize50x50")

	qn_QuickNoteWindows = %qn_QuickNoteWindows%|%qn1_GUIid%|

	Gosub, sub_BigIcon

	If qn1_NoScrollBars = 1
		qn1_ScrollBars = -HScroll -VScroll
	Else
		qn1_ScrollBars =

	Gui, Color, %qn1_BGColour%, %qn1_BGColour%
	Gui, Font,s%qn1_FontSize% %qn1_FontStyleParameter% c%qn1_FontColour%,%qn1_Font%
	Gui, Add, Edit, Disabled WantTab T8 T16 T24 T32 T40 T48 0x100 Multi X0 Y0 H%qn1_edH% W%qn1_edW% %qn1_ScrollBars% vqn1_NewContent gqn1_SaveChanges, %qn1_newContent%
	Gui, Font
	If qn1_DateTime =
		qn1_DateTime = None

	If qn1_CompactView <> 1
	{
		qn1_DateTimeW := qn1_edW - 30 - (qn1_ShowPrintButton*15)
		Gui, Add, Button, -Wrap X0 Y%qn1_edH% vqn1_HelpButton gqn1_sub_Help w15 h20 -TabStop, ?

		Gui, Add, DateTime, Range%A_YYYY%%A_MM%%A_DD% Right 2 X+0 Y%qn1_edH% W%qn1_DateTimeW% Choose%qn1_DateTime% vqn1_DateTime gqn1_sub_DateTime, %lng_qn_DateTime%
		Gui, Add, Button, -Wrap X+0 Y%qn1_edH% vqn1_CountdownMenu gqn1_sub_CountdownMenu w15 h20 -TabStop, &T
		If qn1_ShowPrintButton = 1
			Gui, Add, Button, -Wrap X+0 Y%qn1_edH% vqn1_PrintButton gqn1_sub_Print w15 h20 -TabStop, P
		Gui, Add, Button, -Wrap x-100 y-100 gQuickNote1GuiClose Default -TabStop, &OK
	}
	If qn1_ShowFileName = 1
	{
		SplitPath, qn1_DataFileName,,,, qn1_DataFileNameNoExt
		Gui, Show, X%qn1_X% Y%qn1_Y% H%qn1_H% W%qn1_W% %qn1_NA%, %qn1_DataFileNameNoExt%
	}
	Else If (func_Deref(DataFile_QuickNote1) = "*" qn1_DataFile OR func_Deref(DataFile_QuickNote1) = qn1_DataFile OR qn1_DataFile = A_WorkingDir "\" func_Deref(DataFile_QuickNote1))
		Gui, Show, X%qn1_X% Y%qn1_Y% H%qn1_H% W%qn1_W% %qn1_NA%, %qn1_ScriptName%
	Else
		Gui, Show, X%qn1_X% Y%qn1_Y% H%qn1_H% W%qn1_W% %qn1_NA%, %qn1_ScriptName% - %qn1_DataFileFolder%\%qn1_DataFileName%
	wingetpos,qn1_newX,qn1_newY,qn1_newW,qn1_newH, ahk_id %qn1_GUIid% ; Fenstermaße ermitteln

	; Cursor setzen
	qn1_Line--
	qn1_Col--

	If qn1_ScrollBars =
	{
		SendMessage, 0xBB, qn1_Line, 0 , Edit1, ahk_id %qn1_GUIid%  ; EM_LINEINDEX
		qn1_EditIndex := Errorlevel + qn1_Col
		SendMessage, 0xB1, qn1_EditIndex, qn1_EditIndex, Edit1, ahk_id %qn1_GUIid% ; EM_SETSEL
		; Scrollbalken setzen
		ControlGet, qn1_NewContentHwnd, Hwnd,,Edit1, ahk_id %qn1_GUIid%
		SetScrollPos(qn1_NewContentHwnd, 1, qn1_ScrollPos)
	}
	Else
	{
		qn1_Edit1LineCount := qn1_newH/(qn1_FontSize*2)

		SendMessage, 0xBB, % qn1_Line+qn1_Edit1LineCount/2, 0 , Edit1, ahk_id %qn1_GUIid%  ; EM_LINEINDEX
		qn1_EditIndex := Errorlevel + qn1_Col
		SendMessage, 0xB1, qn1_EditIndex, qn1_EditIndex, Edit1, ahk_id %qn1_GUIid% ; EM_SETSEL
		SendMessage, 0xB7, , , Edit1, ahk_id %qn1_GUIid% ; EM_SCROLLCARET

		SendMessage, 0xBB, qn1_Line, 0 , Edit1, ahk_id %qn1_GUIid%  ; EM_LINEINDEX
		qn1_EditIndex := Errorlevel + qn1_Col
		SendMessage, 0xB1, qn1_EditIndex, qn1_EditIndex, Edit1, ahk_id %qn1_GUIid% ; EM_SETSEL
		SendMessage, 0xB7, , , Edit1, ahk_id %qn1_GUIid% ; EM_SCROLLCARET
	}

	GuiControl, Enable, qn1_NewContent
	GuiControl, Focus, qn1_NewContent


	Transform, qn1_SeparatorTmp, Deref, %qn1_Separator%

	SetKeyDelay,0
	If qn1_AutoSeparator1 = 1
		ControlSend, Edit1, ^{Home}`n%qn1_SeparatorTmp%`n^{Home}, ahk_id %qn1_GUIid%
	If qn1_AutoSeparator2 = 1
		ControlSend, Edit1, ^{End}`n%qn1_SeparatorTmp%`n, ahk_id %qn1_GUIid%
	If (qn1_AutoPasteSelection = 1 AND Clipboard <> "")
	{
		ControlSend, Edit1, ^{End}`n^v`n, ahk_id %qn1_GUIid%
		Sleep, 100
		Clipboard := qn1_OldClipboard
	}

	GuiControlGet, qn1_Undo,%GuiID_QuickNote1%:,qn1_NewContent
	qn1_UndoBuffer[%qn1_UndoCounter%] = %qn1_Undo%
	qn1_UndoBufferIndex[%qn1_UndoCounter%] = %qn1_EditIndex%

	If qn1_LookForFileModifications = 1
		SetTimer, qn1_tim_LookForFileModifications, 2000
Return

qn1_sub_DateTime:
	qn1_GuiDateTime = %A_now%
Return

qn1_Timer:
	If qn1_DateTime <>
	{
		If (A_Now > qn1_DateTime AND qn1_DateTime > qn1_GuiDateTime)
		{
			qn1_DateTime =
			If (qn1_SoundMode1 = 1 OR qn1_SoundMode2 = 1)
				SetTimer, qn1_tim_Sound, -10
			qn1_NA = NA NoActivate
			Gosub, qn1_main_QuickNote1
			qn1_NA =
		}
	}
Return

qn1_tim_LookForFileModifications:
	; QuickNote aktualisieren wenn die Datei von außen geändert wurde
	FileGetTime, qn1_DataFileTime, %qn1_DataFile%
	If (qn1_DataFileTime <> qn1_LastDataFileTime AND qn1_LastDataFileTime <> "")
	{
		Gosub, qn1_sub_UndoBuffer
		FileRead, qn1_newContent, %qn1_DataFile%
		GuiControl,%GuiID_QuickNote1%:,qn1_NewContent, %qn1_newContent%
	}
	qn1_LastDataFileTime = %qn1_DataFileTime%
Return

QuickNote1GuiSize: ;    Fenstergrößen-Überwachung
	; Critical
	SetTimer, qn1_tim_SizeSaveChanges, off
	SetTitleMatchmode, 3
	wingetpos,qn1_newX,qn1_newY,qn1_newW,qn1_newH, ahk_id %qn1_GUIid% ; Fenstermaße ermitteln
	;tooltip, %qn1_newW% %qn1_newH%

	qn1_newW := qn1_newW - qn1_BorderHeight * 2
	qn1_newH := qn1_newH - qn1_CaptionHeight

	; Differenz des veränderten Fensters zu der Originalgröße errechnen
	qn1_DiffH := qn1_newH - qn1_H
	qn1_DiffW := qn1_newW - qn1_W

	if qn1_DiffW = %qn1_lastDiffW%
	if qn1_DiffH = %qn1_lastDiffH%
		return

	qn1_lastDiffW = %qn1_DiffW%
	qn1_lastDiffH = %qn1_DiffH%

	; Neue Positionen und Größen berechnen
	qn1_newEdH  :=  qn1_EdH + qn1_DiffH
	qn1_newEdW  :=  qn1_EdW + qn1_DiffW

	qn1_DateTimeW := qn1_newEdW - 30 - (qn1_ShowPrintButton*15)

	; Fensterelemente anpassen
	GuiControl, %GuiID_QuickNote1%:move, Edit1, w%qn1_newEdW% h%qn1_newEdH%
	GuiControl, %GuiID_QuickNote1%:move, qn1_HelpButton, y%qn1_newEdH%
	GuiControl, %GuiID_QuickNote1%:move, SysDateTimePick321, y%qn1_newEdH% w%qn1_DateTimeW%
	If qn1_ShowPrintButton = 1
		GuiControl, %GuiID_QuickNote1%:movedraw, qn1_PrintButton, % "y"qn1_newEdH "x"qn1_DateTimeW+30
	GuiControl, %GuiID_QuickNote1%:movedraw, qn1_CountdownMenu, % "y"qn1_newEdH "x"qn1_DateTimeW+15
	Critical, Off

	SetTimer, qn1_tim_SizeSaveChanges, 50
Return

qn1_tim_SizeSaveChanges:
	SetTimer, qn1_tim_SizeSaveChanges, off
	IniWrite, %qn1_newX%, %ConfigFile%, QuickNote1, X
	IniWrite, %qn1_newY%, %ConfigFile%, QuickNote1, Y
	IniWrite, %qn1_newH%, %ConfigFile%, QuickNote1, H
	IniWrite, %qn1_newW%, %ConfigFile%, QuickNote1, W
Return

qn1_SaveChanges:
	SetTimer, qn1_tim_SaveChanges, 200
Return

qn1_tim_SaveChanges:
	Thread, Priority, 1
	SetTimer, qn1_tim_SaveChanges, Off
	SetTimer, qn1_tim_LookForFileModifications, Off
	;Critical
	GuiControlGet, qn1_EditText,%GuiID_QuickNote1%:,qn1_NewContent

	wingetpos,qn1_newX,qn1_newY,qn1_newW,qn1_newH, ahk_id %qn1_GUIid% ; Fenstermaße ermitteln
	qn1_newW := qn1_newW - qn1_BorderHeight * 2
	qn1_newH := qn1_newH - qn1_CaptionHeight

	ControlGet, qn1_Line, CurrentLine,,Edit1, ahk_id %qn1_GUIid%
	ControlGet, qn1_Col, CurrentCol,,Edit1, ahk_id %qn1_GUIid%

	IniWrite, %qn1_Line%, %ConfigFile%, QuickNote1, Line
	IniWrite, %qn1_Col%, %ConfigFile%, QuickNote1, Col

	GetScrollInfo(qn1_NewContentHwnd, 1, qn1_ScrollPos, qn1_ScrollPage, qn1_ScrollMin, qn1_ScrollMax, qn1_ScrollTrackPos)
	IniWrite, %qn1_ScrollPos%, %ConfigFile%, QuickNote1, ScrollPos

	IniWrite, %qn1_newX%, %ConfigFile%, QuickNote1, X
	IniWrite, %qn1_newY%, %ConfigFile%, QuickNote1, Y
	IniWrite, %qn1_newH%, %ConfigFile%, QuickNote1, H
	IniWrite, %qn1_newW%, %ConfigFile%, QuickNote1, W

	FileAppend, %qn1_EditText%, %A_Temp%\qn1_temp.tmp
	FileMove, %A_Temp%\qn1_temp.tmp, %qn1_DataFile%, 1
	FileGetTime, qn1_LastDataFileTime, %qn1_DataFile%

	qn1_UndosDone--

	If qn1_LookForFileModifications = 1
		SetTimer, qn1_tim_LookForFileModifications, 2000
Return

QuickNote1GuiClose:
QuickNote1GuiEscape:
	; Critical
	SetTimer, qn1_tim_SizeSaveChanges, off
	SetTimer, qn1_tim_SaveChanges, Off
	SetTimer, qn1_tim_LookForFileModifications, Off
	Gosub, qn1_tim_SaveChanges
	If qn1_HelpVisible = 1
		Gosub, qn1_sub_Help

	wingetpos,qn1_newX,qn1_newY,qn1_newW,qn1_newH, ahk_id %qn1_GUIid% ; Fenstermaße ermitteln
	qn1_newW := qn1_newW - qn1_BorderHeight * 2
	qn1_newH := qn1_newH - qn1_CaptionHeight

	ControlGet, qn1_Line, CurrentLine,,Edit1, ahk_id %qn1_GUIid%
	ControlGet, qn1_Col, CurrentCol,,Edit1, ahk_id %qn1_GUIid%
	Gui, %GuiID_QuickNote1%:Destroy

;   IniWrite, %A_Space%, %ConfigFile%, QuickNote1, ShowGUI
	IniDelete, %ConfigFile%, QuickNote1, ShowGUI
	IniWrite, %qn1_Line%, %ConfigFile%, QuickNote1, Line
	IniWrite, %qn1_Col%, %ConfigFile%, QuickNote1, Col
	IniWrite, %qn1_newX%, %ConfigFile%, QuickNote1, X
	IniWrite, %qn1_newY%, %ConfigFile%, QuickNote1, Y
	IniWrite, %qn1_newH%, %ConfigFile%, QuickNote1, H
	IniWrite, %qn1_newW%, %ConfigFile%, QuickNote1, W
	IniWrite, %qn1_DateTime%, %ConfigFile%, QuickNote1, Timer

	Gosub, qn1_sub_SaveUndoBuffer

	StringReplace, qn_QuickNoteWindows, qn_QuickNoteWindows, |%qn1_GUIid%|

	qn1_GUIid =
Return

qn1_OnMessage_EditKeys:
	qn1_Key = %#wParam%

	If A_GuiControl not in qn1_NewContent,qn1_DateTime
		Return

	GetKeyState, qn1_CtrlState, Ctrl
	If qn1_CtrlState = D
		qn1_Key := qn1_Key + 1000
	GetKeyState, qn1_ShiftState, Shift
	If qn1_ShiftState = D
		qn1_Key := qn1_Key + 2000
	GetKeyState, qn1_AltState, Alt
	If qn1_AltState = D
		qn1_Key := qn1_Key + 4000

	;tooltip, %qn1_Key%

	If A_GuiControl = qn1_DateTime
	{
		If qn1_Key = 9 ; Tab
		{
			Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
			If (qn1_DateTime = "None" OR qn1_DateTime = "")
				GuiControl, Focus, qn1_NewContent
			Else
				Send, {Right}
			#Return = 0
		}
		If qn1_Key = 2009 ; Shift+Tab
		{
			Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
			If (qn1_DateTime = "None" OR qn1_DateTime = "")
				GuiControl, Focus, qn1_NewContent
			Else
				Send, {Left}
			#Return = 0
		}
		Return
	}

	ControlGet, qn1_SelectedText, Selected,, Edit1, ahk_id %qn1_GUIid%
	If qn1_SelectedText <>
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Store Undobuffer")
		Gosub, qn1_sub_UndoBuffer
	}
	Else If qn1_Key in 8,9,13,32,46,188,190,2188,2190,189,2219,2056,2057,2049,5055,5056,5057,5058,5226,226,2226
		If qn1_Key <> %qn1_LastKey%
		{
			Debug("EXTENSION", A_LineNumber, A_LineFile, "Store Undobuffer")
			Gosub, qn1_sub_UndoBuffer
		}
		Else
			qn1_SameKey = %qn1_Key%

	If qn1_SameKey in 8,9,13,32,46,188,190,2188,2190,189,2219,2056,2057,2049,5055,5056,5057,5058,5226,226,2226
		If qn1_Key <> %qn1_LastKey%
		{
			Debug("EXTENSION", A_LineNumber, A_LineFile, "Store Undobuffer")
			Gosub, qn1_sub_UndoBuffer
		}

	qn1_LastKey = %qn1_Key%
	if qn1_SameKey <> %qn1_Key%
		qn1_SameKey =

	If (qn1_Key = 1009) ; Strg+Tab
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		StringRight, qn1_QuickNoteNumber, qn1_ScriptName, 1
		Loop,80
		{
			qn1_QuickNoteNumber++
			If qn%qn1_QuickNoteNumber%_ScriptName =
				qn1_QuickNoteNumber = 1
			IfWinExist, % "ahk_id " qn%qn1_QuickNoteNumber%_GUIid
			{
				WinActivate, % "ahk_id " qn%qn1_QuickNoteNumber%_GUIid
				Break
			}
		}
		#Return = 0
	}
	If (qn1_Key = 3009) ; Strg+Shift+Tab
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		StringRight, qn1_QuickNoteNumber, qn1_ScriptName, 1
		Loop,80
		{
			qn1_QuickNoteNumber--
			If qn1_QuickNoteNumber < 0
				qn1_QuickNoteNumber = 40
			If qn%qn1_QuickNoteNumber%_ScriptName =
				continue
			IfWinExist, % "ahk_id " qn%qn1_QuickNoteNumber%_GUIid
			{
				WinActivate, % "ahk_id " qn%qn1_QuickNoteNumber%_GUIid
				Break
			}
		}
		#Return = 0
	}

	If (qn1_Key = 1065) ; Strg+A
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		Send,^{Home}^+{End}
		#Return = 0
	}
	If (qn1_Key = 1008) ; Strg+Löschen
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		SetKeyDelay,0
		Send,^+{Left}{Del}
		#Return = 0
	}
	If (qn1_Key = 1046) ; Strg+Entf
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		SetKeyDelay,0
		Send,^+{Right}{Del}
		Gosub, qn1_sub_UndoBuffer
		#Return = 0
	}
	If (qn1_Key = 1090) ; Strg+Z
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		GuiControlGet, qn1_EditText,%GuiID_QuickNote1%:,qn1_NewContent
		If ( qn1_EditText <> qn1_UndoBuffer[%qn1_UndoCounter%] )
		{
			Gosub, qn1_sub_UndoBuffer
			qn1_UndoCounter--
		}
		If qn1_UndoCounter > 0
		{
			qn1_UndoCounter--
			GuiControl,%GuiID_QuickNote1%:,qn1_NewContent,% qn1_UndoBuffer[%qn1_UndoCounter%]
			SendMessage, 0xB1, qn1_UndoBufferIndex[%qn1_UndoCounter%], qn1_UndoBufferIndex[%qn1_UndoCounter%], Edit1, ahk_id %qn1_GUIid% ; EM_SETSEL
			SendMessage, 0xB7, , , Edit1, ahk_id %qn1_GUIid% ; EM_SCROLLCARET
		}
		Gosub,qn1_SaveChanges
		#Return = 0
	}
	If (qn1_Key = 1089 OR qn1_Key = 3090) ; Strg+Y oder Strg+Shift+Z
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		GuiControlGet, qn1_EditText,%GuiID_QuickNote1%:,qn1_NewContent
		If ( qn1_EditText <> qn1_UndoBuffer[%qn1_UndoCounter%] )
		{
			#Return = 0
			Return
		}
		If qn1_RedoMax > %qn1_UndoCounter%
		{
			qn1_UndoCounter++
			GuiControl,%GuiID_QuickNote1%:,qn1_NewContent,% qn1_UndoBuffer[%qn1_UndoCounter%]
			SendMessage, 0xB1, qn1_UndoBufferIndex[%qn1_UndoCounter%], qn1_UndoBufferIndex[%qn1_UndoCounter%], Edit1, ahk_id %qn1_GUIid% ; EM_SETSEL
			SendMessage, 0xB7, , , Edit1, ahk_id %qn1_GUIid% ; EM_SCROLLCARET
		}
		Gosub,qn1_SaveChanges
		#Return = 0
	}
	If (qn1_Key = 1068) ; Strg+D
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		SetKeyDelay,0
		FormatTime,qn1_date,,ShortDate
		FormatTime,qn1_time,,Time
		Send, %qn1_date% %qn1_time%
		qn1_date =
		qn1_time =
		Gosub, qn1_sub_UndoBuffer
		#Return = 0
	}
	If (qn1_Key = 1076) ; Strg+L
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		Transform, qn1_SeparatorTmp, Deref, %qn1_Separator%
		SetKeyDelay,0
		If qn1_SeparatorMode = 2
			Send, {End}`n%qn1_SeparatorTmp%`n
		Else
			Send, {Home}`n{Up}%qn1_SeparatorTmp%{Home}{Down}
		Gosub, qn1_sub_UndoBuffer
		#Return = 0
	}
	If (qn1_Key = 1082) ; Strg+R
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		func_GetSelection()
		If Selection =
		{
			Send, ^{Right}^+{Left}
			func_GetSelection()
		}
		Run, %Selection% ,,UseErrorLevel
		#Return = 0
	}
	If (qn1_Key = 112) ; F1
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		Gosub, qn1_sub_Help
		#Return = 0
	}
	If (qn1_Key = 1083) ; Strg+S
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		Gosub, qn1_main_QuickNote1
		#Return = 0
	}
	If (qn1_Key = 1080) ; Strg+P
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		Gosub, qn1_sub_Print
	}
	If (qn1_Key = 1069) ; Strg+E
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		qn1_tempClipPlain = %Clipboard%
		func_GetSelection()
		qn1_ExportContent := Selection
		If qn1_ExportContent =
			GuiControlGet, qn1_ExportContent,%GuiID_QuickNote1%:,qn1_NewContent

		Gui, %GuiID_QuickNote1%:+OwnDialogs
		FileSelectFile, qn1_ExportFileName, 16,QuickNote1.txt,%lng_qn_ExportSelection%,*.txt
		Gui, %GuiID_QuickNote1%:-OwnDialogs
		If qn1_ExportFileName <>
		{
			FileDelete, %qn1_ExportFileName%
			FileAppend, %qn1_ExportContent%, %qn1_ExportFileName%
		}
		#Return = 0
	}
	If (qn1_Key = 1070 OR (qn1_Key = 114 and qn1_SearchTerm ="") ) ; Strg+F
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		wingetpos,qn1_newX,qn1_newY,qn1_newW,qn1_newH, ahk_id %qn1_GUIid% ; Fenstermaße ermitteln
		qn1_editW := 300 - 27
		qn1_buttonX := (327 - 170) / 2
		GuiDefault("QuickNote1Search", "+Owner" GuiID_QuickNote1 " AlwaysOnTop +ToolWindow")
		Gui, %GuiID_QuickNote1%:+Disabled
		Gui, Add, Text,, %lng_qn_SearchTerm%
		Gui, Add, Edit, y+5 w%qn1_editW% R1 vqn1_SearchTerm, %qn1_SearchTerm%
		Gui, Add, Button, x%qn1_buttonX% y+5 w80 gQuickNote1SearchGuiClose, %lng_Cancel%
		Gui, Add, Button, Default x+10 w80 gqn1_sub_SearchOK, %lng_OK%
		Gui, Show, x%qn1_newX% y%qn1_newY%
		GuiDefault("QuickNote1")

		#Return = 0
		Return
	}
	If (qn1_Key = 1084) ; Strg+T
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		If qn1_CompactView = 1
		{
			qn1_CompactView = 0
			Gosub, qn1_main_QuickNote1
			Gosub, qn1_main_QuickNote1
		}
		GuiControl, %GuiID_QuickNote1%:Focus, qn1_DateTime
		Send, %A_Space%{Right}
		#Return = 0
		Return
	}
	If (qn1_Key = 114) ; F3
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		qn1_SearchBack = 0
		Gosub, qn1_sub_SearchOK
		#Return = 0
		Return
	}
	If (qn1_Key = 2114) ; Shift+F3
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		qn1_SearchBack = 1
		Gosub, qn1_sub_SearchOK
		#Return = 0
		Return
	}
	If (qn1_Key = 1075) ; Strg+K
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		If qn1_CompactView = 1
			qn1_CompactView = 0
		Else
			qn1_CompactView = 1
		Gosub, qn1_main_QuickNote1
		Gosub, qn1_main_QuickNote1
		#Return = 0
		Return
	}
	If (qn1_Key = 1038)
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		SendMessage, 0x115, 0, 0, Edit1, ahk_id %qn1_GUIid%
		#Return = 0
		Return
	}
	If (qn1_Key = 1040)
	{
		Debug("EXTENSION", A_LineNumber, A_LineFile, "Special Key: " qn1_Key)
		SendMessage, 0x115, 1, 0, Edit1, ahk_id %qn1_GUIid%
		#Return = 0
		Return
	}
Return

QuickNote1GuiDropFiles:
	WinActivate,ahk_id %qn1_GUIid%
	SetKeyDelay,0
	Send, %A_GuiControlEvent%{Enter}
Return

QuickNote1SearchGuiEscape:
QuickNote1SearchGuiClose:
	Gui, %GuiID_QuickNote1%:-Disabled
	Gui, %GuiID_QuickNote1Search%:Destroy
Return

qn1_sub_SearchOK:
	Gui, %GuiID_QuickNote1%:-Disabled
	Gui, %GuiID_QuickNote1Search%:Submit
	Gui, %GuiID_QuickNote1Search%:Destroy

	func_SearchInControl( qn1_searchTerm, "edit1", "ahk_id " qn1_GUIid, qn1_searchBack)
Return

qn1_sub_UndoBuffer:
	qn1_UndoCounter++
	qn1_RedoMax = %qn1_UndoCounter%
	GuiControlGet, qn1_EditText,%GuiID_QuickNote1%:,qn1_NewContent
	qn1_UndoBuffer[%qn1_UndoCounter%] = %qn1_EditText%

	ControlGet, qn1_Line, CurrentLine,,Edit1, ahk_id %qn1_GUIid%
	ControlGet, qn1_Col, CurrentCol,,Edit1, ahk_id %qn1_GUIid%
	qn1_Line--
	qn1_Col--

	SendMessage, 0xBB, qn1_Line, 0 , Edit1, ahk_id %qn1_GUIid%
	qn1_UndoBufferIndex[%qn1_UndoCounter%] := Errorlevel + qn1_Col
Return

qn1_sub_Print:
	ControlFocus, Edit1, ahk_id %qn1_GUIid%
	func_GetSelection()
	qn1_Selection = %Selection%
	FileDelete, %A_Temp%\%qn1_DataFileName%
	FileAppend, %qn1_Selection%, %A_Temp%\%qn1_DataFileName%
	qn1_MsgBox = yes
	If qn1_NoPrintMessage = 0
		MsgBox,36,%ScriptName% - QuickNote1, %lng_qn_MsgPrint%
	IfMsgBox, no
		qn1_MsgBox = no
	If qn1_Msgbox = yes
	{
		If qn1_Selection =
			Run, Print %qn1_DataFile%
		Else
		{
			RunWait, Print %A_Temp%\%qn1_DataFileName%
		}
	}
	FileDelete, %A_Temp%\%qn1_DataFileName%
	#Return = 0
Return

qn1_sub_Help:
	GuiControl, Focus, Edit1
	If qn1_HelpVisible =
	{
		wingetpos,qn1_newX,qn1_newY,qn1_newW,qn1_newH, ahk_id %qn1_GUIid% ; Fenstermaße ermitteln
		CoordMode, ToolTip, Screen
		tooltip, %lng_qn_Help%, % qn1_NewX, % qn1_NewY+qn1_NewH, 7
		qn1_HelpVisible = 1
		SetTimer, qn1_tim_MoveHelp, 10
	}
	Else
	{
		tooltip, ,,, 7
		qn1_HelpVisible =
		SetTimer, qn1_tim_MoveHelp, Off
	}

Return

qn1_tim_MoveHelp:
	Gui %GuiID_QuickNote1%:+LastFoundExist
	IfWinExist, ahk_id %qn1_GUIid%
	{
		If qn1_HelpVisible = 1
		{
			wingetpos,qn1_newX,qn1_newY,qn1_newW,qn1_newH, ahk_id %qn1_GUIid% ; Fenstermaße ermitteln
			if (qn1_newX <> qn1_lastX OR qn1_newY <> qn1_lastY OR qn1_newH <> qn1_lastH)
			{
				CoordMode, ToolTip, Screen
				tooltip, %lng_qn_Help%, % qn1_NewX, % qn1_NewY+qn1_NewH, 7
			}
			qn1_lastX := qn1_newX
			qn1_lastY := qn1_newY
			qn1_lastH := qn1_newH
		}
	}
Return

qn1_sub_DeleteAll:
	Gosub, qn1_sub_UndoBuffer
	ControlFocus, Edit1, ahk_id %qn1_GUIid%
	Send,^{Home}^+{End}{Del}
Return

qn1_sub_DrawLine:
  Gosub, qn1_sub_UndoBuffer
  ControlFocus, Edit1, ahk_id %qn1_GUIid%
  Send, {Home}{Down}`n{Up}%qn1_Separator%{Home}{Down}
Return

qn1_sub_CountdownMenu:
	CoordMode, Menu, Relative

	AutoTrim, On

	Loop, Parse, qn1_TimerMenu, `,
	{
		qn1_LoopField = %A_LoopField%
		If (qn1_LoopField = "-" OR qn1_LoopField = "")
			Menu, qn1_CountdownMenu, Add
		Else
			Menu, qn1_CountdownMenu, Add, %qn1_LoopField%, qn1_sub_SelectCountdown
	}
	Menu, qn1_CountdownMenu, Show, %qn1_NewW%, %qn1_NewH%
	Menu, qn1_CountdownMenu, DeleteAll
Return

qn1_sub_SelectCountdown:
	StringSplit, qn1_CountDownVal, A_Thismenuitem, %A_Space%
	StringReplace, qn1_CountDownVal1, qn1_CountDownVal1, ½, .5
	qn1_DateTime = %A_Now%
	If (qn1_CountDownVal2 = lng_Minute OR qn1_CountDownVal2 = lng_Minutes)
		EnvAdd, qn1_DateTime, qn1_CountDownVal1, Minutes
	If (qn1_CountDownVal2 = lng_Hour OR qn1_CountDownVal2 = lng_Hours)
		EnvAdd, qn1_DateTime, qn1_CountDownVal1, Hours
	If (qn1_CountDownVal2 = lng_Day OR qn1_CountDownVal2 = lng_Days)
		EnvAdd, qn1_DateTime, qn1_CountDownVal1, Days

	GuiControl, %GuiID_QuickNote1%:,qn1_DateTime, %qn1_DateTime%
	Gosub, QuickNote1GuiClose
Return

qn1_tim_Sound:
	; Critical
	SetBatchlines, 1

	If qn1_SoundMode2 = 1
	{
		SoundBeep, 2600, 60
		SoundBeep, 2000, 60
		SoundBeep, 2600, 60
		SoundBeep, 2000, 60
		SoundBeep, 2600, 60
		SoundBeep, 2000, 60
	}
	If qn1_SoundMode1 = 1
	{
		If(qn1_unmuteOnMute1)
		{
			If Enable_MusicControl = 1
			{
				qn1_Component := muc_Componentent
				qn1_Device := muc_Device
			}
			Else
			{
				qn1_Component = MASTER
				qn1_Device =
			}

			SoundGet, qn1_Mute, %qn1_Component%, mute, %qn1_Device%
			If qn1_Mute = On
				SoundSet, 0, %qn1_Component%, mute, %qn1_Device%
		}
		SoundPlay, %qn1_SoundFile%, 1
		If(qn1_unmuteOnMute1)
		{
			If qn1_Mute = On
				SoundSet, 1, %qn1_Component%, mute, %qn1_Device%
		}
	}
Return

qn1_sub_SaveUndoBuffer:
	FileDelete, %qn1_UndoBufferFile%.tmp
	If qn1_UndoCounter < 1
	{
		FileDelete, %qn1_UndoBufferFile%
		Return
	}
	qn1_Count := qn1_UndoCounter
	If qn1_Count > %qn1_MaxUndos%
		qn1_Count = %qn1_MaxUndos%

	qn1_BufferTmp =
	Loop, %qn1_Count%
	{
		qn1_tmp := qn1_UndoCounter-qn1_Count+A_Index-1
		If qn1_UndoBuffer[%qn1_tmp%] = %qn1_LastUndoBuffer%
			continue
		qn1_BufferTmp := qn1_BufferTmp qn1_UndoBuffer[%qn1_tmp%] qn1_UndoSeparator qn1_UndoBufferIndex[%qn1_tmp%] qn1_UndoSeparator
		qn1_LastUndoBuffer := qn1_UndoBuffer[%qn1_tmp%]
	}
	FileAppend, %qn1_BufferTmp%, %qn1_UndoBufferFile%.tmp
	qn1_BufferTmp =
	qn1_LastUndoBuffer =
	FileMove, %qn1_UndoBufferFile%.tmp, %qn1_UndoBufferFile%, 1
Return

qn1_sub_DuplicateQuickNote:
	Loop, 20
	{
		If A_Index = 1
			continue
		IfNotExist, %A_ScriptDir%\extensions\ac'tivAid_QuickNote%A_Index%.ahk
		{
			qn_NextQN = %A_Index%
			Break
		}
	}
	If qn_NextQN <>
	{
		FileRead, qn_NextQNContent, %A_ScriptDir%\extensions\ac'tivAid_QuickNote.ahk
		StringReplace, qn_NextQNContent, qn_NextQNContent, QuickNote1, QuickNote%qn_NextQN%, All
		StringReplace, qn_NextQNContent, qn_NextQNContent, qn1, qn%qn_NextQN%, All
		StringReplace, qn_NextQNContent, qn_NextQNContent, QuickNote.txt, QuickNote%qn_NextQN%.txt, All
		FileAppend, %qn_NextQNContent%, %A_ScriptDir%\extensions\ac'tivAid_QuickNote%qn_NextQN%.ahk

		AvailableExtensions = QuickNote%qn_NextQN%|%AvailableExtensions%
		Sort, AvailableExtensions, D|
		FunctionRequireExt[QuickNote%qn_NextQN%] := FunctionRequireExt[QuickNote1]
		ExtensionPrefix[QuickNote%qn_NextQN%] := ExtensionPrefix[QuickNote1]
		ExtensionVersion[QuickNote%qn_NextQN%] := ExtensionVersion[QuickNote1]
		ExtensionDescription[QuickNote%qn_NextQN%] := ExtensionDescription[QuickNote1]
		StringReplace, ExtensionFile[QuickNote%qn_NextQN%], ExtensionFile[QuickNote1], QuickNote.ahk, QuickNote%qn_NextQN%.ahk

		StringReplace, AvailableExtensions, AvailableExtensions, ||, |, A
		GuiControl,,AvailableExtensionsBox, |%AvailableExtensions%
		GuiControl,Focus,AvailableExtensionsBox
		GuiControl,ChooseString,AvailableExtensionsBox,QuickNote%qn_NextQN%
		ListBox_selected := GuiTabs[%lng_Extensions%]
		GuiControl, Choose, OptionsListBox, %ListBox_selected%
		GuiControl, Choose, DlgTabs, %ListBox_selected%
		Gosub, sub_ExtASelect
	}
Return

qn1_sub_RemoveQuickNote:
	MsgBox, 36, %qn1_ScriptName% v%qn1_ScriptVersion%, %lng_qn1_AskRemoveQuickNote%
	IfMsgBox, Yes
	{
		FileDelete, %A_ScriptDir%\extensions\ac'tivAid_%qn1_ScriptName%.ahk
		ExtI_selected = %qn1_ScriptName%
		Gosub, sub_ExtRem2
		Gosub, sub_ExtInstall
		IniDelete, %ConfigFile%, QuickNote1
		IniDelete, %ConfigFile%, activAid, Enable_QuickNote1
		IniDelete, %ConfigFile%, activAid, EnableTray_QuickNote1
		Reload
	}
Return
