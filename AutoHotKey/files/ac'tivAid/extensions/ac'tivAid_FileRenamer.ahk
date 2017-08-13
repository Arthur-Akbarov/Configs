; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               FileRenamer
; -----------------------------------------------------------------------------
; Prefix:             frn_
; Version:            1.9a1
; Date:               2008-05-23
; Author:             Wolfgang Reszel, Florian Schenk (Sonnenweg-Software.de)
;                     (Changes by Dirk Schwarzmann aka RobOtter), Michael
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_FileRenamer:
	Prefix = frn
	%Prefix%_ScriptName    = FileRenamer
	%Prefix%_ScriptVersion = 1.9a1
	%Prefix%_Author        = Wolfgang Reszel, Florian Schenk (Idee, Ursprungsversion), Michael

	CustomHotkey_FileRenamer = 1          ; automatisches benutzerdefinierbares Tastaturkürzel? (1 = ja)
	Hotkey_FileRenamer       = ^u         ; Standard-Hotkey
	HotkeyPrefix_FileRenamer = $          ; Präfix, welches vor immer vor dem Tastaturkürzel gesetzt wird
													  ; in diesem Fall sorgt es dafür, dass das Tastaturkürzel durchgeschleift wird.
	HideSettings             = 0                      ; Wenn 1, dann bekommt die Erweiterung keinen Eintrag im Konfigurationsdialog

	IconFile_On_FileRenamer = %A_WinDir%\system32\shell32.dll
	IconPos_On_FileRenamer = 68

	HotkeyClasses_FileRenamer=%ExplorerAndDialogs%

	CreateGuiID("FileRenamer")

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		; Name des Menüeintrags im Tray-Menü
		MenuName                          = %frn_ScriptName% - Dateien umbenennen
		; Beschreibung für den Erweiterungsmanager und den Konfigurationsdialog
		Description                       = Stapel-Umbenennung markierter Dateien und Ordner mit Nummerierung und/oder Datumsergänzung.

		lng_frn_Rename                    = Umbenennen
		lng_frn_Waiting                   = Warten
		lng_frn_Filelist                  = Datei&liste
		lng_frn_NewFilenameSingle         = Neuer Date&iname
		lng_frn_NewFilename               = Neuer Date&iname (\f = Dateiname, \x = Erweiterung, \n = Nummerierung, \d = Datum, \t = Zeit, \c = Zwischenablage):
		lng_frn_NumberingInchoateWith     = &Nummerierung (\n) beginnend mit:
		lng_frn_Date                      = &Datum (\d):
		lng_frn_Time                      = Zei&t (\t):
		lng_frn_Format                    = &Format:
		lng_frn_Name                      = Alter Name`aNeuer Name`a `a `a `a `a
		lng_frn_Files                     = Dateien
		lng_frn_StandardNumberingBegin    = Vorgegebener Nummerierungsbeginn:
		lng_frn_NumberCompletion          = führende Nullen (01, 02, 03 ...)
		lng_frn_StandardDateFormat        = Vorgegebenes Datumsformat:
		lng_frn_StandardTimeFormat        = Vorgegebenes Zeitformat:
		lng_frn_replaceStringFrom         = Ersetze im Dateinamen (\f)
		lng_frn_replaceStringTo           = durch
		lng_frn_Case                      = Groß-/Kleinschreibung
		lng_frn_CaseOptions               = keine Änderung`aalles klein`aAnfangsbuchstaben Groß`aALLES GROSS`aalles klein (mit Erw.)`aAnfangsbuchst. Groß (mit Erw.)`aALLES GROSS (mit Erw.)
		lng_frn_Websafe                   = Sonderzeichen und Leerzeichen ersetzen (Web-safe)
		lng_frn_ErrorNoPlaceholder        = Sie müssen einen Ersetzer platzieren, um den Dateien eindeutige Namen zu geben. (z.B. \n, \f oder \d)
		lng_frn_CropFileName              = Dateiname (\f) beschneiden:
		lng_frn_CropLeft                  = Am &Anfang:
		lng_frn_CropRight                 = Am &Ende:
		lng_frn_DateTime                  = Datum/Uhrzeit:
		lng_frn_UseFileDateTime1          = Manuelles Datum
		lng_frn_UseFileDateTime2          = Änderungsdatum
		lng_frn_UseFileDateTime3          = Erstellungsdatum
		lng_frn_UseFileDateTime4          = Exif-Datum
		lng_frn_UseFileDateTime5          = Jetzt
		lng_frn_NoDirs                    = Ordner können von FileRenamer nicht umbenannt werden!
		lng_frn_NoSelection               = Keine Datei ausgewählt!
		lng_frn_ErrorWhileRenaming        = Datei(en) konnten nicht umbenannt werden
		lng_frn_NoDialog                  = Letzte Umbenennungsoptionen direkt anwenden
		lng_frn_FileExist                 = Datei existiert bereits
		lng_frn_AutoExtension             = Datei-Erweiterung nicht veränderbar (.\x nicht mehr nötig)
		lng_frn_NoOneFileGUI              = Kein Umbenennen-Fenster zeigen (markiert Dateinamen ohne Erweiterung)
		lng_frn_AlwaysUseDialog           = Umbenennen immer mit Umbenennen-Fenster
		lng_frn_NoMultiFileGUI            = Generell keine Umbenennen-Fenster verwenden (verwendet die Standard-Umbenennung von Windows)
		lng_frn_Creating                  = Dateiliste wird erstellt ...
		lng_frn_Renaming                  = Dateien werden umbenannt ...
		lng_frn_GettingFiles              = Ermittle markierte Dateien ...
		lng_frn_Delete                    = &Aus der Liste entfernen`t(Entf)
		lng_frn_MoveTop                   = An den &Anfang der Liste schieben`t(Alt+Pos1)
		lng_frn_MoveBottom                = An das &Ende der Liste schieben`t(Alt+Ende)
		lng_frn_MoveUp                    = Eine Zeile nach &oben schieben`t(Alt+Cursor hoch)
		lng_frn_MoveDown                  = Eine Zeile nach u&nten schieben`t(Alt+Cursor runter)
		lng_frn_AllowSlashes              = Schrägstriche (/ oder \\) zulassen, um Unterordner erstellen zu können
		lng_frn_AlwaysOverwrite           = Bereits existierende Dateien überschreiben (AUF EIGENE GEFAHR)
		lng_frn_IncreaseBeginNum          = Nummerierungsbeginn nach der Umbenennung automatisch erhöhen
		lng_frn_SetCursorToEnd            = Dateinamen nicht markieren und Cursor an das Namensende setzen
		lng_frn_SingleFileGroupBox        = Wenn nur eine Datei ausgewählt ist
		lng_frn_AlwaysUseMultiFileGUI     = Auch für einzelne Dateien das große Umbenennen-Fenster verwenden
		lng_frn_SortCrea                  = Nach Erstellungsdatum sortieren
		lng_frn_SortMod                   = Nach Änderungsdatum sortieren
		lng_frn_SortAcc                   = Nach letztem Zugriff sortieren
		lng_frn_Properties                = Eigenschaften

		tooltip_frn_StandardDateForm    = d`tTag ohne führende Null (1 - 31)`ndd`tTag mit führender Null (01 - 31)`nddd`tAbgekürzter Wochentag (z.B. Mon)`ndddd`tWochentag (z.B. Montag)`nM`tMonat ohne führende Null (1 - 12)`nMM`tMonat mit führender Null (01 - 12)`nMMM`tAbgekürzter Monatsname (z.B. Jan)`nMMMM`tMonatsname (z.B. Januar)`ny`tJahr ohne führende Null (0 - 99)`nyy`tJahr mit führender Null (00 - 99)`nyyyy`tJahr mit Jahrtausend (z.B. 2006)
		tooltip_frn_DateForm            = %tooltip_frn_StandardDateForm%
		tooltip_frn_StandardTimeForm    = h`tStunde ohne führende Null; 12-Stunden-Format (1 - 12)`nhh`tStunde mit führender Null; 12-Stunden-Format (01 - 12) `nH`tStunde ohne führende Null; 24-Stunden-Format (0 - 23)`nHH`tStunde mit führender Null; 24-Stunden-Format (00- 23)`nm`tMinuten ohne führende Null (0 - 59)`nmm`tMinuten mit führender Null (00 - 59)`ns`tSekunden ohne führende Null (0 - 59)`nss`tSekunden mit führender Null (00 - 59)
		tooltip_frn_TimeForm            = %tooltip_frn_StandardTimeForm%
		tooltip_frn_NumberCompletion    = Durch Voranstellen von Nullen beim Nummerierungsbeginn`nkann man die Anzahl der Stellen vorgeben. (z.B. 00001)
		tooltip_frn_NumberBegin           = %tooltip_frn_NumberCompletion%
		tooltip_frn_BeginNum              = %tooltip_frn_NumberCompletion%

		lng_frn_RegEx  = RegEx-Beispiele
		lng_frn_RegEx1 = Jegliche Ziffer entfernen
		lng_frn_RegEx2 = Zifferngruppen entfernen (mit Punkten oder Bindestrichen)
		lng_frn_RegEx3 = Zifferngruppe nur am Ende entfernen (mit Punkten oder Bindestrichen)
		lng_frn_RegEx4 = Zifferngruppe nur am Anfang entfernen (mit Punkten oder Bindestrichen)
		lng_frn_RegEx5 = Bindestriche und Unterstriche entfernen
		lng_frn_RegEx6 = Länge des Namens auf 8 Zeichen begrenzen
	}
	else        ; = other languages (english)
	{
		MenuName                          = %frn_ScriptName% - rename files
		Description                       = Automatic file and folder renaming

		lng_frn_Rename                    = Rename
		lng_frn_Waiting                   = Wait
		lng_frn_Filelist                  = File&list:
		lng_frn_NewFilenameSingle         = New F&ilename
		lng_frn_NewFilename               = New F&ilename (\f = Filename, \x = Extension, \n = Numbering, \d = Date, \t = Time, \c = Clipboard):
		lng_frn_NumberingInchoateWith     = &Numbering (\n) starting with:
		lng_frn_NumberCompletion          = Add "0"s in front of smaller numbers?
		lng_frn_Date                      = &Date (\d):
		lng_frn_Time                      = &Time (\t):
		lng_frn_Format                    = &Format:
		lng_frn_Name                      = Old name`aNew name`a `a `a `a `a
		lng_frn_Files                     = Files
		lng_frn_StandardNumberingBegin    = Standard numbering starting with:
		lng_frn_StandardDateFormat        = Standard date format:
		lng_frn_StandardTimeFormat        = Standard time format:
		lng_frn_replaceStringFrom         = Replace in filename (\f) ; Added by RobOtter
		lng_frn_replaceStringTo           = with ; Added by RobOtter
		lng_frn_Case                      = Case
		lng_frn_CaseOptions               = no Change`alower case`aInitials In Upper Case`aUPPER CASE`alower case (with ext.)`aInitials In Upper Case (with ext.)`aUPPER CASE (with ext.)
		lng_frn_Websafe                   = Replace space and special characters (web safe)
		lng_frn_ErrorNoPlaceholder        = You must set a spacer (e.g. \n, \f or \d)
		lng_frn_CropFileName              = Crop filename (\f):
		lng_frn_CropLeft                  = From left:
		lng_frn_CropRight                 = From right:
		lng_frn_DateTime                  = Date/Time:
		lng_frn_UseFileDateTime1          = Manual
		lng_frn_UseFileDateTime2          = Modification
		lng_frn_UseFileDateTime3          = Creation
		lng_frn_UseFileDateTime4          = Exif date
		lng_frn_UseFileDateTime5          = Now
		lng_frn_NoDirs                    = FileRenamer could not rename folders!
		lng_frn_NoSelection               = No file selected!
		lng_frn_ErrorWhileRenaming        = file(s) couldn't be renamed
		lng_frn_NoDialog                  = Rename directly with the last used settings
		lng_frn_FileExist                 = File already exist
		lng_frn_AutoExtension             = Don't change file extension (.\x not necessary anymore)
		lng_frn_NoOneFileGUI              = Don't show rename window (selects filename without extension)
		lng_frn_AlwaysUseDialog           = Rename always with rename window
		lng_frn_NoMultiFileGUI            = Also don't use a dialog for multiple files (uses the windows standard renaming)
		lng_frn_Creating                  = Creating file list ...
		lng_frn_Renaming                  = Renaming files ...
		lng_frn_GettingFiles              = Getting selected files ...
		lng_frn_Delete                    = &Remove from list`t(Del)
		lng_frn_MoveTop                   = Move to the &top of the list`t(Alt+Home)
		lng_frn_MoveBottom                = Move to the &bottom of the list`t(Alt+End)
		lng_frn_MoveUp                    = Move one line &up`t(Alt+Cursor up)
		lng_frn_MoveDown                  = Move one line dow&n`t(Alt+Cursor down)
		lng_frn_AllowSlashes              = Allow slashes (/ or \\) to create subfolders
		lng_frn_AlwaysOverwrite           = Overwrite existing files (USE AT OWN RISK)
		lng_frn_IncreaseBeginNum          = Increase numbering starting after renaming
		lng_frn_SetCursorToEnd            = Don't select filename und set the cursor to the end of the name
		lng_frn_SingleFileGroupBox        = When only one file is selected
		lng_frn_AlwaysUseMultiFileGUI     = Also use the big rename window for single files
		lng_frn_SortCrea                  = Sort by creation date
		lng_frn_SortMod                   = Sort by modification date
		lng_frn_SortAcc                   = Sort by last access date
		lng_frn_Properties                = Properties
		lng_frn_RegEx  = RegEx examples
		lng_frn_RegEx1 = Remove any number
		lng_frn_RegEx2 = Remove number groups (with dots or hypen)
		lng_frn_RegEx3 = Remove number group only at the end (with dots or hypen)
		lng_frn_RegEx4 = Remove number group only at the beginning (with dots or hypen)
		lng_frn_RegEx5 = Remove hyphens and underscores
		lng_frn_RegEx6 = Limit name length to 8 characters
	}
	IniRead, frn_numberBegin, %ConfigFile%, %frn_ScriptName%, StandardNumberBegin, %A_Space%
	IniRead, frn_NumberCompletion, %ConfigFile%, %frn_ScriptName%, NumberCompletion , 1
	IniRead, frn_dateFormat, %ConfigFile%, %frn_ScriptName%, StandardDateFormat , %A_Space%
	IniRead, frn_timeFormat, %ConfigFile%, %frn_ScriptName%, StandardTimeFormat , %A_Space%
	AutoTrim, Off
	IniRead, frn_lastReplacement, %ConfigFile%, %frn_ScriptName%, LastReplacement , "\f.\x`a
	; " ; end qoute for syntax highlighting
	IniRead, frn_lastReplaceStringFrom, %ConfigFile%, %frn_ScriptName%, LastReplaceStringFrom , `a
	IniRead, frn_lastReplaceStringTo, %ConfigFile%, %frn_ScriptName%, LastReplaceStringTo , `a
	StringTrimLeft, frn_lastReplacement, frn_lastReplacement, 1
	StringTrimLeft, frn_lastReplaceStringFrom, frn_lastReplaceStringFrom, 1
	StringTrimLeft, frn_lastReplaceStringTo, frn_lastReplaceStringTo, 1
	AutoTrim, On
	IniRead, frn_CaseOption, %ConfigFile%, %frn_ScriptName%, CaseOption, 1
	IniRead, frn_Websave, %ConfigFile%, %frn_ScriptName%, Websave, 0
	IniRead, frn_AutoExtension, %ConfigFile%, %frn_ScriptName%, AutoExtension, 0
	IniRead, frn_NoOneFileGUI, %ConfigFile%, %frn_ScriptName%, NoGUIonOneFile, 1
	IniRead, frn_NoMultipleFileGUI, %ConfigFile%, %frn_ScriptName%, NoGUIonMultipleFiles, 0
	IniRead, frn_SetCursorToEnd, %ConfigFile%, %frn_ScriptName%, SetCursorToEnd, 0
	IniRead, frn_AlwaysUseMultiFileGUI, %ConfigFile%, %frn_ScriptName%, AlwaysUseMultiFileGUI, 0
	RegisterAdditionalSetting( "frn", "NoBalloonTips", 0 )
	RegisterAdditionalSetting( "frn", "AllowSlashes", 0 )
	RegisterAdditionalSetting( "frn", "AlwaysOverwrite", 0 )
	RegisterAdditionalSetting( "frn", "IncreaseBeginNum", 0 )

	frn_RegExSearch1  = RegEx:[0-9]
	frn_RegExReplace1 =
	frn_RegExSearch2  = RegEx:(^|_|\W)[0-9-\.]+($|_|\W)
	frn_RegExReplace2 =
	frn_RegExSearch3  = RegEx:(_|\W)[0-9-\.]+$
	frn_RegExReplace3 =
	frn_RegExSearch4  = RegEx:^[0-9-\.]+(_|\W)
	frn_RegExReplace4 =
	frn_RegExSearch5  = RegEx:[-_]
	frn_RegExReplace5 =
	frn_RegExSearch6  = RegEx:^(.{1,8})(.*)$
	frn_RegExReplace6 = $1

	Menu, frn_RegEx, Add, %lng_frn_RegEx%, frn_sub_RegExMenuCall
	Menu, frn_RegEx, Disable, %lng_frn_RegEx%
	Menu, frn_RegEx, Add

	Loop
	{
		If frn_RegExSearch%A_Index% =
			break
		Menu, frn_RegEx, Add, % lng_frn_RegEx%A_Index%, frn_sub_RegExMenuCall
	}

	func_HotkeyRead( "frn_NoDialog", ConfigFile, frn_ScriptName, "NoDialogHotKey", "frn_sub_NoDialog", "^+u", "$", ExplorerAndDialogs )
	func_HotkeyRead( "frn_AlwaysUseDialog", ConfigFile, frn_ScriptName, "AlwaysUseDialog", "frn_sub_AlwaysUseDialog", "^!u", "$", ExplorerAndDialogs )
Return

Update_FileRenamer:
	IniRead, frn_LastUpdateNumber, settings\ac'tivAid.ini, FileRenamer, UpdateNumber, 0

	If ( frn_LastUpdateNumber < 1 )
	{
		AutoTrim, Off
		IniRead, frn_lastReplacement, settings\ac'tivAid.ini, FileRenamer, LastReplacement , \f.\x|
		IniRead, frn_lastReplaceStringFrom, settings\ac'tivAid.ini, FileRenamer, LastReplaceStringFrom , |
		IniRead, frn_lastReplaceStringTo, settings\ac'tivAid.ini, FileRenamer, LastReplaceStringTo , |
		StringReplace, frn_lastReplacement, frn_lastReplacement, |, `a, A
		StringReplace, frn_lastReplaceStringFrom, frn_lastReplaceStringFrom, |, `a, A
		StringReplace, frn_lastReplaceStringTo, frn_lastReplaceStringTo, |, `a, A
		IniWrite, %frn_lastReplacement%, settings\ac'tivAid.ini, FileRenamer, LastReplacement
		IniWrite, %frn_lastReplaceStringFrom%, settings\ac'tivAid.ini, FileRenamer, LastReplaceStringFrom
		IniWrite, %frn_lastReplaceStringTo%, settings\ac'tivAid.ini, FileRenamer, LastReplaceStringTo
		AutoTrim, On
	}
	If ( frn_LastUpdateNumber < 1 )
	{
		AutoTrim, Off
		IniRead, frn_lastReplacement, settings\ac'tivAid.ini, FileRenamer, LastReplacement , \f.\x`a
		IniRead, frn_lastReplaceStringFrom, settings\ac'tivAid.ini, FileRenamer, LastReplaceStringFrom , `a
		IniRead, frn_lastReplaceStringTo, settings\ac'tivAid.ini, FileRenamer, LastReplaceStringTo , `a
		IniWrite, "%frn_lastReplacement%, settings\ac'tivAid.ini, FileRenamer, LastReplacement
		; " ; end qoute for syntax highlighting
		IniWrite, "%frn_lastReplaceStringFrom%, settings\ac'tivAid.ini, FileRenamer, LastReplaceStringFrom
		; " ; end qoute for syntax highlighting
		IniWrite, "%frn_lastReplaceStringTo%, settings\ac'tivAid.ini, FileRenamer, LastReplaceStringTo
		; " ; end qoute for syntax highlighting
		AutoTrim, On
	}

	IniWrite, 2, settings\ac'tivAid.ini, FileRenamer, UpdateNumber
Return

SettingsGui_FileRenamer:
	func_HotkeyAddGuiControl( lng_frn_NoDialog, "frn_NoDialog", "xs+10 y+5 W240" )
	func_HotkeyAddGuiControl( lng_frn_AlwaysUseDialog, "frn_AlwaysUseDialog", "xs+10 y+5 W240" )
	Gui, Add, Text,  xs+10 y+10 w200, %lng_frn_StandardNumberingBegin%
	Gui, Add, Edit,  x+5 yp-3 w120 h20 gsub_CheckIfSettingsChanged vfrn_NumberBegin, %frn_numberBegin%
	Gui, Add, Checkbox, -Wrap x+10 h20 gsub_CheckIfSettingsChanged vfrn_NumberCompletion checked%frn_NumberCompletion%, %lng_frn_NumberCompletion%
	Gui, Add, Text, xs+10 yp+27  w200, %lng_frn_StandardDateFormat%
	Gui, Add, Edit,  x+5 yp-3 w120 h20 gsub_CheckIfSettingsChanged vfrn_StandardDateForm, %frn_dateFormat%
	Gui, Add, Text, xs+10 yp+27  w200, %lng_frn_StandardTimeFormat%
	Gui, Add, Edit,  x+5 yp-3 w120 h20 gsub_CheckIfSettingsChanged vfrn_StandardTimeForm, %frn_timeFormat%
	Gui, Add, Checkbox, -Wrap xs+10 y+10 gsub_CheckIfSettingsChanged vfrn_AutoExtension checked%frn_AutoExtension%, %lng_frn_AutoExtension%
	Gui, Add, Groupbox, xs+10 y+10 w555 h95, %lng_frn_SingleFileGroupBox%
	Gui, Add, Checkbox, -Wrap xs+20 yp+20 gfrn_sub_CheckIfSettingsChanged vfrn_NoOneFileGUI checked%frn_NoOneFileGUI%, %lng_frn_NoOneFileGUI%
	Gui, Add, Checkbox, -Wrap xs+40 y+5 gsub_CheckIfSettingsChanged vfrn_NoMultipleFileGUI checked%frn_NoMultipleFileGUI%, %lng_frn_NoMultiFileGUI%
	Gui, Add, Checkbox, -Wrap xs+20 y+5 gsub_CheckIfSettingsChanged vfrn_AlwaysUseMultiFileGUI checked%frn_AlwaysUseMultiFileGUI%, %lng_frn_AlwaysUseMultiFileGUI%
	Gui, Add, Checkbox, -Wrap xs+20 y+5 gsub_CheckIfSettingsChanged vfrn_SetCursorToEnd checked%frn_SetCursorToEnd%, %lng_frn_SetCursorToEnd%
	Gosub, frn_sub_CheckIfSettingsChanged
Return

frn_sub_CheckIfSettingsChanged:
	Gosub,sub_CheckIfSettingsChanged
	GuiControlGet, frn_NoOneFileGUI_tmp,, frn_NoOneFileGUI
	If frn_NoOneFileGUI_tmp = 1
	{
		GuiControl, Enable, frn_NoMultipleFileGUI
		GuiControl, Disable, frn_AlwaysUseMultiFileGUI
	}
	Else
	{
		GuiControl, Disable, frn_NoMultipleFileGUI
		GuiControl, , frn_NoMultipleFileGUI, 0
		GuiControl, Enable, frn_AlwaysUseMultiFileGUI
	}
Return

; wird aufgerufen, wenn im Konfigurationsdialog OK oder Übernehmen angeklickt wird
SaveSettings_FileRenamer:
	StringReplace, frn_NumberBegin, frn_NumberBegin, ., , All
	IniWrite, % frn_NumberBegin, %ConfigFile%, %frn_ScriptName%, StandardNumberBegin
	IniWrite, %frn_NumberCompletion%, %ConfigFile%, %frn_ScriptName%, NumberCompletion
	IniWrite, %frn_StandardDateForm%, %ConfigFile%, %frn_ScriptName%, StandardDateFormat
	IniWrite, %frn_StandardTimeForm%, %ConfigFile%, %frn_ScriptName%, StandardTimeFormat
	IniWrite, %frn_CaseOption%, %ConfigFile%, %frn_ScriptName%, CaseOption
	IniWrite, %frn_Websave%, %ConfigFile%, %frn_ScriptName%, Websave
	IniWrite, %frn_AutoExtension%, %ConfigFile%, %frn_ScriptName%, AutoExtension
	IniWrite, %frn_NoOneFileGUI%, %ConfigFile%, %frn_ScriptName%, NoGUIonOneFile
	IniWrite, %frn_NoMultipleFileGUI%, %ConfigFile%, %frn_ScriptName%, NoGUIonMultipleFiles
	IniWrite, %frn_SetCursorToEnd%, %ConfigFile%, %frn_ScriptName%, SetCursorToEnd
	IniWrite, %frn_AlwaysUseMultiFileGUI%, %ConfigFile%, %frn_ScriptName%, AlwaysUseMultiFileGUI
	func_HotkeyWrite( "frn_NoDialog", ConfigFile, frn_ScriptName, "NoDialogHotKey")
	func_HotkeyWrite( "frn_AlwaysUseDialog", ConfigFile, frn_ScriptName, "AlwaysUseDialog")
Return

ResetWindows_FileRenamer:
	IniDelete, frn_PosX, %ConfigFile%, %frn_ScriptName%, PosX
	IniDelete, frn_PosY, %ConfigFile%, %frn_ScriptName%, PosY
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_FileRenamer:
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_FileRenamer:
	func_HotkeyEnable( "frn_NoDialog")
	func_HotkeyEnable( "frn_AlwaysUseDialog")
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern der Einstellungen aufgerufen
DoDisable_FileRenamer:
	func_HotkeyDisable( "frn_NoDialog")
	func_HotkeyDisable( "frn_AlwaysUseDialog")
Return

; wird aufgerufen, wenn der Anwender die Erweiterung auf die Standard-Einstellungen zurücksetzt
DefaultSettings_FileRenamer:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

; Unterroutine für das automatische Tastaturkürzel
sub_Hotkey_FileRenamer:
	Gosub, frn_main_FileRenamer
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

frn_sub_AlwaysUseDialog:
	frn_AlwaysGui = 1
	Gosub, frn_main_FileRenamer
	frn_AlwaysGui =
Return

frn_main_FileRenamer:
	; ID des aktiven Fensters
	WinGet, frn_ActiveID, ID, A
	; Klasse des aktiven Fensters
	WinGetClass, frn_ActiveClass, A

	ControlGetFocus, frn_Focus, ahk_id %frn_ActiveID%
	ControlGet, frn_Count, List, Count Selected, %frn_Focus%, ahk_id %frn_ActiveID%
	ControlGet, frn_CountAll, List, Count, %frn_Focus%, ahk_id %frn_ActiveID%
	
	; QUICKFIX für Windows 7 (Zwischenablage nutzen)
	if (aa_osversionnumber >= aa_osversionnumber_7)
	{
		frn_previousClipboard := clipboard
		clipboard =
		Send, ^c
		clipwait, 1
		frn_FileList := clipboard
		clipboard := frn_previousClipboard
		frn_previousClipboard =
		frn_Count = 0
		frn_CurrentExplorerDirectory = 
		loop,parse,frn_FileList, `n
		{
			frn_Count:=frn_Count+1
			if (frn_CurrentExplorerDirectory = "")
				frn_CurrentExplorerDirectory := substr(a_loopfield, 1,(InStr(a_loopfield, "\", false, 0)-1))
		}
	}

	IfInString, frn_Focus, SysTreeView32
	{
		Send,{F2}
		If frn_SetCursorToEnd = 1
			Send,{End}
		Return
	}

	if frn_Count < 1
	{
		If frn_NoBalloonTips = 0
			BalloonTip( frn_ScriptName " " frn_ScriptVersion, lng_frn_NoSelection, "Warning",0,0,7)
		Return
	}

	; Umbenennen ohne Dialog
	If ((frn_NoOneFileGUI = 1 OR (frn_NoMultipleFileGUI = 1 AND frn_NoOneFileGUI = 1)) AND frn_AlwaysGui = "")
	{
		If InStr(frn_Focus,"SysListView32") OR InStr(frn_Focus,"DirectUIHWND")
		{
			ControlGet, frn_Filename, List, Col1 Focused, %frn_Focus%, ahk_id %frn_ActiveID%
			If (frn_Count = 1 OR frn_NoMultipleFileGUI = 1)
			{
				frn_Dir := func_GetDir(frn_ActiveID,"","","",1)
				If (InStr(FileExist(frn_Dir "\" frn_Filename), "D") OR (aa_osversionnumber >= aa_osversionnumber_vista) )
				{
					Send, {F2}
					If frn_SetCursorToEnd = 1
						Send, {Left}{Right}
				}
				Else
				{
					SplitPath, frn_Filename, , , , frn_FilenameNoExt
					If frn_FilenameNoExt =
						frn_FilenameNoExt = %frn_Filename%
					frn_Len := StrLen(frn_Filename) - StrLen(frn_FilenameNoExt)
					If frn_SetCursorToEnd = 1
						Send, {F2}^{End}{LEFT %frn_Len%}
					Else
						Send, {F2}^{Home}^+{End}+{LEFT %frn_Len%}
				}
				Return
			}
		}
	}

	if(aa_osversionnumber < aa_osversionnumber_7 )
	{
		IfNotInString, frn_Focus, SysListView32
		{
			Send,{F2}
			Return
		}
	}

	if frn_Count>100
	{
		SplashImage,, b2 p0 w300 h26, , %lng_frn_GettingFiles%
		frn_faktor := 100/frn_RowNumber
	}

	If frn_ActiveClass in %ChangeDirClasses%,Progman,WorkerW
	{
		RegRead, frn_HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt
		frn_CurrentExplorerDirectory := func_GetDir( frn_ActiveID )
		ControlGet, frn_Selection, List, Selected Col1, %frn_Focus%, ahk_id %frn_ActiveID%
		frn_Selection := RegExReplace(frn_Selection, "\s|\r|\n", "") ; Alle Leerzeichen und Umbrüche entfernen, frn_Selection ist dann leer, wenn ControlGet fehl schlägt
		If (!FileExist(frn_CurrentExplorerDirectory) OR frn_HiddenFiles_Status = 1 OR frn_Selection = "")
		{
			func_GetSelection(1,0,frn_Count/30+1)
			tooltip
			SplashImage, Off
			frn_List = %Selection%`n
			frn_Selection = %Selection%
			StringLeft, frn_CurrentExplorerDirectory, frn_List, % InStr(frn_List,"`n")
			SplitPath, frn_CurrentExplorerDirectory,, frn_currentexplorerdirectory
			StringTrimRight, frn_List, frn_List, 1
		}
		Else
		{
			SplashImage, Off
			If frn_Count > 100
			{
				Progress, b2 p0 w300, , %lng_frn_Creating%
				Sleep, 10
			}
			frn_Selection =

			If frn_Count = %frn_CountAll%
			{
				Loop, %frn_CurrentExplorerDirectory%\*.*, 1, 0
					frn_Selection = %frn_Selection%%A_LoopFileFullPath%`n
				StringTrimRight, frn_Selection, frn_Selection, 1
			}
			Else
			{
				ControlGet, frn_Selection, List, Selected Col1, %frn_Focus%, ahk_id %frn_ActiveID%
				StringReplace, frn_Selection, frn_Selection, `n, `n%frn_CurrentExplorerDirectory%\, All
				frn_Selection = %frn_CurrentExplorerDirectory%\%frn_Selection%
			}
			frn_List = %frn_Selection%
		}
		; Dialogerstellung aufrufen
		Gosub, frn_createGui
	}
Return

frn_sub_NoDialog:
	frn_NoDialog = 1
	Gosub, frn_main_FileRenamer
	frn_NoDialog =
Return

;Erstellt Rahmen für das GUI und prüft ob keine, eine oder mehrere Dateien markiert sind
frn_createGui:
	SetTitleMatchMode,3
	DetectHiddenWindows, On

	Gui, %GuiID_FileRenamer%:+LastFoundExist
	IfWinExist
		Gui, %GuiID_FileRenamer%:Destroy

	;GUI erstellen
	Gui, %GuiID_FileRenamer%: -Resize -MaximizeBox -MinimizeBox
	Gui, %GuiID_FileRenamer%: default
	;Liste der markierten Dateien durchlaufen um Anzahl der markierten Dateien zu prüfen
	frn_RowNumber := 0

	StringReplace, frn_List, frn_List, `n,,All UseErrorLevel
	frn_RowNumber := ErrorLevel + 1

	if frn_RowNumber>100
	{
		Progress, b2 p0 w300, , %lng_frn_Creating%
		frn_faktor := 100/frn_RowNumber
	}

	;wenn keine Datei markiert ist Dialog nicht darstellen
	if frn_List =
	{
		If frn_NoBalloonTips = 0
			BalloonTip( frn_ScriptName " " frn_ScriptVersion, lng_frn_NoSelection, "Warning",0,0,7)
		return
	}
	IniRead, frn_BeginNum, %ConfigFile%, %frn_ScriptName%, NumberBegin , 001
	IniRead, frn_numberBegin, %ConfigFile%, %frn_ScriptName%, StandardNumberBegin , 001
	If (frn_numberBegin <> "" AND frn_NoDialog <> 1)
		frn_BeginNum := frn_numberBegin
	If frn_BeginNum =
		frn_BeginNum = 001

	IniRead, frn_NumberCompletion, %ConfigFile%, %frn_ScriptName%, NumberCompletion , 1

	IniRead, frn_dateForm, %ConfigFile%, %frn_ScriptName%, DateFormat , yyyy-MM-dd
	IniRead, frn_dateFormat, %ConfigFile%, %frn_ScriptName%, StandardDateFormat , yyyy-MM-dd
	If (frn_dateFormat <> "" AND frn_NoDialog <> 1)
		frn_dateForm := frn_dateFormat
	If frn_dateForm =
		frn_dateForm = yyyy-MM-dd

	IniRead, frn_timeForm, %ConfigFile%, %frn_ScriptName%, TimeFormat , HHmmss
	IniRead, frn_timeFormat, %ConfigFile%, %frn_ScriptName%, StandardTimeFormat , HHmmss
	If (frn_timeFormat <> "" AND frn_NoDialog <> 1)
		frn_timeForm := frn_timeFormat
	If frn_timeForm =
		frn_timeForm = yyyy-MM-dd

	IniRead, frn_UseFileDateTime , %ConfigFile%, %frn_ScriptName%, UseFileDateTime , 2
	IniRead, frn_Date, %ConfigFile%, %frn_ScriptName%, Date, %A_Now%
	IniRead, frn_Time, %ConfigFile%, %frn_ScriptName%, Time, %A_Now%
	If frn_UseFileDateTime = 5
	{
		frn_Date = %A_Now%
		frn_Time = %A_Now%
	}
	AutoTrim, Off
	IniRead, frn_lastReplacement, %ConfigFile%, %frn_ScriptName%, LastReplacement , "\f.\x`a
	; " ; end qoute for syntax highlighting
	IniRead, frn_lastReplaceStringFrom, %ConfigFile%, %frn_ScriptName%, LastReplaceStringFrom , `a
	IniRead, frn_lastReplaceStringTo, %ConfigFile%, %frn_ScriptName%, LastReplaceStringTo , `a
	StringTrimLeft, frn_lastReplacement, frn_lastReplacement, 1
	StringTrimLeft, frn_lastReplaceStringFrom, frn_lastReplaceStringFrom, 1
	StringTrimLeft, frn_lastReplaceStringTo, frn_lastReplaceStringTo, 1
	AutoTrim, On
	IniRead, frn_CaseOption, %ConfigFile%, %frn_ScriptName%, CaseOption, 1
	IniRead, frn_Websave, %ConfigFile%, %frn_ScriptName%, Websave, 0
	IniRead, frn_CropLeft, %ConfigFile%, %frn_ScriptName%, CropLeft, 0
	IniRead, frn_CropRight, %ConfigFile%, %frn_ScriptName%, CropRight, 0
	IniRead, frn_PosX, %ConfigFile%, %frn_ScriptName%, PosX, %A_Space%
	IniRead, frn_PosY, %ConfigFile%, %frn_ScriptName%, PosY, %A_Space%

	if (frn_RowNumber = 1 AND frn_NoDialog = "" AND frn_AlwaysUseMultiFileGUI = 0)
	{
		frn_W = 300
		frn_H = 255
	}
	else
	{
		frn_W = 588
		frn_H = 404
	}

	If frn_PosX = ERROR
		frn_PosX =
	Else
	{
		If (frn_PosX < MonitorAreaLeft)
			frn_PosX := MonitorAreaLeft
		If (frn_PosX+frn_W+BorderHeight*2 > MonitorAreaRight)
			frn_PosX := MonitorAreaRight-(frn_W+BorderHeight*2)
	}
	If frn_PosY = ERROR
		frn_PosY =
	Else
	{
		If (frn_PosY < MonitorAreaTop)
			frn_PosY := MonitorAreaTop
		If (frn_PosY+frn_H+MenuBarHeight+BorderHeight*2+CaptionHeight > MonitorAreaBottom)
			frn_PosY := MonitorAreaBottom-(frn_H+MenuBarHeight+BorderHeight*2+CaptionHeight)
	}

	If (frn_PosX <> "" AND frn_PosX <> " ")
		frn_PosX = x%frn_PosX%
	If (frn_PosY <> "" AND frn_PosY <> " ")
		frn_PosY = y%frn_PosY%

	;wenn eine Datei markiert ist
	if (frn_RowNumber = 1 AND frn_NoDialog = "" AND frn_AlwaysUseMultiFileGUI = 0)
	{
		Gosub, frn_createOneFileGui
		Gui, %GuiID_FileRenamer%: Add, Button,xs yp+30 x55 w80 Default vFileRenamerButtonRename gFileRenamerButtonRename, &%lng_frn_Rename%
		Gui, %GuiID_FileRenamer%: Add, Button,x+10 w80 vFileRenamerButtonCancel gFileRenamerButtonCancel, %lng_cancel%
		CoordMode, Caret, Screen
		Gui, %GuiID_FileRenamer%: Show, %frn_PosX% %frn_PosY% , %ScriptNameFull% - %frn_ScriptName%
		SplitPath, frn_datName,,, frn_datTextExt, frn_datTextName
		If frn_datTextName =
			frn_datTextName = frn_datName
		If frn_SetCursorToEnd = 1
			Send, % "^{Home}{Right " StrLen(frn_datTextName) "}"
		Else
			Send, % "^{Home}+{Right " StrLen(frn_datTextName) "}"
	}
	;wenn mehrere Dateien markiert sind
	Else
	{
		Gosub, frn_createManyFileGui
	}
	func_AddMessage(0x200, "GuiTooltip")
	func_AddMessage(0x6, "RemoveGuiTooltip")
	If frn_NoDialog = 1
	{
		Gosub, frn_tim_Changed
		Gosub, FileRenamerButtonRename
	}
return


;Erstellt Dialog wenn nur eine Datei gewählt ist
frn_createOneFileGui:
	;Liste der markierten Dateien
	frn_List = %frn_Selection%

	Loop, Parse, frn_List, `n  ; Rows are delimited by linefeeds (`n).
	{
		IfExist %A_LoopField%
			SplitPath, A_LoopField, frn_datName, frn_CurrentExplorerDirectory
	}
	frn_GuiWindowID := GuiDefault("FileRenamer","+Delimiter`a")
	Gosub, sub_BigIcon

	Gui, Add, Text, xs y5 w260, %lng_frn_NewFilenameSingle%
	Gui, Add, Edit, xs w260 h20 vfrn_NewName, %frn_datName%

	Gui, Add, Text, xs yp+27 w55 gfrn_sub_DateNow, %lng_frn_Date%
	Gui, Add, DateTime, x+5 yp-2  w80 h20 vfrn_Date
	Gui, Add, Text, x+5 yp+2 w30, %lng_frn_Format%
	Gui, Add, Edit, x+5 yp-2 w75 h20 vfrn_DateForm, %frn_dateFormat%
	Gui, Add, Text, xs w55 gfrn_sub_TimeNow, %lng_frn_Time%
	Gui, Add, DateTime, 1 x+5 w80 h20 yp-2 vfrn_Time, Time
	Gui, Add, Text, x+5 w30 yp+2, %lng_frn_Format%
	Gui, Add, Edit, x+5  w75 h20 yp-2 vfrn_TimeForm, %frn_timeFormat%

	AutoTrim, Off
	StringReplace, frn_lastReplaceStringTo_tmp, frn_lastReplaceStringTo, `%A_Empty`%,`a, All
	StringReplace, frn_lastReplaceStringFrom_tmp, frn_lastReplaceStringFrom, `%A_Empty`%,`a, All
	;StringTrimLeft, frn_lastReplaceStringTo_tmp, frn_lastReplaceStringTo_tmp, 1
	;StringTrimLeft, frn_lastReplaceStringFrom_tmp, frn_lastReplaceStringFrom_tmp, 1

	; Start - Added by RobOtter
	Gui, Add, Text,  xs y+20, %lng_frn_replaceStringFrom%:
	Gui, Add, ComboBox,  y+3 xs w93 vfrn_replaceStringFrom, %frn_lastReplaceStringFrom_tmp%
	Gui, Add, Text,  x+5 yp+3, %lng_frn_replaceStringTo%
	Gui, Add, ComboBox,  x+5 w90 yp-3 vfrn_replaceStringTo, %frn_lastReplaceStringTo_tmp%
	GuiControl, Choose, frn_replaceStringFrom, 1
	GuiControl, Choose, frn_replaceStringTo, 1
	AutoTrim, On

	Gui, Add, Text, xs y+12, %lng_frn_Case%:
	Gui, Add, DropDownList, x+5 yp-3 w160 vfrn_CaseOption AltSubmit checked%frn_CaseOption%, %lng_frn_CaseOptions%
	GuiControl, Choose, frn_CaseOption, %frn_CaseOption%

	Gui, Add, CheckBox, xs -Wrap vfrn_Websave checked%frn_Websave%, %lng_frn_Websafe%
	; End - Added by RobOtter

	frn_RealRowNumber = 1
return

frn_sub_DateNow:
	If A_GuiEvent = DoubleClick
		GuiControl,,frn_Date, %A_Now%
Return

frn_sub_TimeNow:
	If A_GuiEvent = DoubleClick
		GuiControl,,frn_Time, %A_Now%
Return


;Erstellt Dialog wenn mehrere Dateien gewählt sind
frn_createManyFileGui:
	frn_GuiWindowID := GuiDefault("FileRenamer","+Delimiter`a")
	If frn_NoDialog = 1
		frn_Disabled = Disabled
	Else
		frn_Disabled =

	Gosub, sub_BigIcon
	Gui, Add, Text, xs y5 w560 vfrn_NumOfFiles, %lng_frn_Filelist% ...
	Gui, Add, Progress, x570 y25 Hidden h147 w10 Vertical vfrn_Progress -Border R0-100
	Gui, Add, ListView, %frn_Disabled% xs y25 r9 w560 Hwndfrn_LVHwnd vfrn_Dateiliste Grid AltSubmit Count%frn_RowNumber% gFileRenamerDateiliste, %lng_frn_Name%

	Gui, Add, Text, xs w560, %lng_frn_NewFilename%
	Gui, Add, ComboBox, %frn_Disabled% xs w560 vfrn_NewName gfrn_sub_Changed, %frn_LastReplacement%
	GuiControl,Choose, frn_NewName, 1

	Gui, Add, Text, xs Section y+10, %lng_frn_CropFileName%
	Gui, Add, Text, xs , %lng_frn_CropLeft%
	Gui, Add, Edit, %frn_Disabled% x+3 w52 h20 yp-2 vfrn_CropLeft gfrn_sub_Changed, %frn_CropLeft%
	Gui, Add, UpDown, Range0-99, %frn_CropLeft%
	Gui, Add, Text,  x+10 yp+2 , %lng_frn_CropRight%
	Gui, Add, Edit, %frn_Disabled% x+3 w52 h20 yp-2 vfrn_CropRight gfrn_sub_Changed, %frn_CropRight%
	Gui, Add, UpDown, Range0-99, %frn_CropRight%

	Gui, Add, Text,  xs+280 w165 ys, %lng_frn_NumberingInchoateWith%
	Gui, Add, Edit, %frn_Disabled% xp y+5 w92 h20 vfrn_BeginNum gfrn_sub_Changed, %frn_BeginNum%
	Gui, Add, Checkbox, %frn_Disabled% -Wrap x+10 h20 vfrn_NumberCompletion gfrn_sub_Changed checked%frn_NumberCompletion%, %lng_frn_NumberCompletion%

	Gui, Add, Text, x10 y+15, %lng_frn_DateTime%
	Gui, Add, Radio, %frn_Disabled% -Wrap x+5 vfrn_UseFileDateTime gfrn_sub_Changed, %lng_frn_UseFileDateTime1%
	Gui, Add, Radio, %frn_Disabled% -Wrap x+5 gfrn_sub_Changed, %lng_frn_UseFileDateTime2%
	Gui, Add, Radio, %frn_Disabled% -Wrap x+5 gfrn_sub_Changed, %lng_frn_UseFileDateTime3%
	Gui, Add, Radio, %frn_Disabled% -Wrap x+5 gfrn_sub_Changed, %lng_frn_UseFileDateTime4%
	Gui, Add, Radio, %frn_Disabled% -Wrap x+5 gfrn_sub_Changed, %lng_frn_UseFileDateTime5%
	GuiControl,, % lng_frn_UseFileDateTime%frn_UseFileDateTime%, 1

	Gui, Add, Text, x10 w55 gfrn_sub_DateNow, %lng_frn_Date%
	Gui, Add, DateTime, %frn_Disabled% x+5 w80 h20 yp-2 vfrn_Date Choose%frn_Date% gfrn_sub_Changed
	Gui, Add, Text, x+5 w30 yp+2 vfrn_Format1, %lng_frn_Format%
	Gui, Add, Edit, %frn_Disabled% x+5  w75 h20 yp-2 vfrn_DateForm gfrn_sub_Changed, %frn_dateForm%
	Gui, Add, Text, x310 yp+2 w55 gfrn_sub_TimeNow, %lng_frn_Time%
	Gui, Add, DateTime, %frn_Disabled% 1 x+5 w80 h20 yp-2 vfrn_Time Choose%frn_Time% gfrn_sub_Changed, Time
	Gui, Add, Text, x+5 w30 yp+2 vfrn_Format2, %lng_frn_Format%
	Gui, Add, Edit, %frn_Disabled%  x+5  w75 h20 yp-2 vfrn_TimeForm gfrn_sub_Changed, %frn_timeForm%

	GuiControl, -Redraw, frn_Dateiliste

	AutoTrim, Off
	StringReplace, frn_lastReplaceStringTo_tmp, frn_lastReplaceStringTo, `%A_Empty`%, `a, All
	StringReplace, frn_lastReplaceStringFrom_tmp, frn_lastReplaceStringFrom, `%A_Empty`%, `a, All
	StringTrimLeft, frn_lastReplaceStringTo_tmp, frn_lastReplaceStringTo_tmp, 1
	StringTrimLeft, frn_lastReplaceStringFrom_tmp, frn_lastReplaceStringFrom_tmp, 1

	; Start - Added by RobOtter
	Gui, Add, Text,  xs y+20, %lng_frn_replaceStringFrom%
	Gui, Add, ComboBox, %frn_Disabled% x+5 w190 yp-4 vfrn_replaceStringFrom gfrn_sub_Changed, %frn_lastReplaceStringFrom_tmp%
	Gui, Add, Text,  x+5 yp+4, %lng_frn_replaceStringTo%
	Gui, Add, ComboBox, %frn_Disabled% x+5 w180 yp-4 vfrn_replaceStringTo gfrn_sub_Changed, %frn_lastReplaceStringTo_tmp%
	Gui, Add, Button, -Wrap x+5 w20 h20 gfrn_sub_ShowRegExMenu, ...
	GuiControl, Choose, frn_replaceStringFrom, 1
	GuiControl, Choose, frn_replaceStringTo, 1
	AutoTrim, On

	Gui, Add, Text, xs y+8, %lng_frn_Case%:
	Gui, Add, DropDownList, %frn_Disabled% x+5 yp-4 w160 vfrn_CaseOption AltSubmit gfrn_sub_Changed checked%frn_CaseOption%, %lng_frn_CaseOptions%
	GuiControl, Choose, frn_CaseOption, %frn_CaseOption%

	Gui, Add, CheckBox, %frn_Disabled% x+15 yp+4 -Wrap vfrn_Websave gfrn_sub_Changed checked%frn_Websave%, %lng_frn_Websafe%
	; End - Added by RobOtter

	Gui, +Disabled +Lastfound

	frn_List = %frn_Selection%

	frn_FilesWithErrors =

	frn_RealRowNumber = 0

	IL_Destroy(frn_ImageListID1)
	frn_ImageListID1 := IL_Create(20, 50, 0)
	LV_SetImageList(frn_ImageListID1)

	VarSetCapacity(frn_Filename, 260)
	frn_sfi_size = 352
	VarSetCapacity(frn_sfi, frn_sfi_size)

	frn_NewList =
	Loop, Parse, frn_List, `n, `r  ; Rows are delimited by linefeeds (`n).
	{
		SplitPath, A_LoopField, frn_datName, frn_CurrentExplorerDirectory, frn_datExt
		frn_Filename := A_LoopField
		If (!FileExist(frn_FileName))
		{
			IfExist, %frn_CurrentExplorerDirectory%\%frn_datName%.lnk
			{
				frn_Filename = %frn_CurrentExplorerDirectory%\%frn_datName%.lnk
				frn_datExt = lnk
				frn_datName = %frn_datName%.lnk
			}
		}
		If (!FileExist(frn_FileName) AND (frn_CurrentExplorerDirectory = A_Desktop OR frn_CurrentExplorerDirectory = A_DesktopCommon))
		{
			IfExist, %A_Desktop%\%frn_datName%.lnk
			{
				frn_Filename = %A_Desktop%\%frn_datName%.lnk
				frn_CurrentExplorerDirectory = %A_Desktop%
				frn_datExt = lnk
				frn_datName = %frn_datName%.lnk
			}
			Else IfExist, %A_DesktopCommon%\%frn_datName%.lnk
			{
				frn_Filename = %A_DesktopCommon%\%frn_datName%.lnk
				frn_CurrentExplorerDirectory = %A_DesktopCommon%
				frn_datExt = lnk
				frn_datName = %frn_datName%.lnk
			}
		}
		IfExist %frn_Filename%
		{
			if frn_datExt in EXE,ICO,ANI,CUR
			{
				frn_ExtID := frn_datExt  ; Special ID as a placeholder.
				frn_IconNumber = 0  ; Flag it as not found so that these types can each have a unique icon.
			}
			else if frn_datExt not in LNK ; Some other extension/file-type, so calculate its unique ID.
			{
				frn_ExtID = 0  ; Initialize to handle extensions that are shorter than others.
				Loop 7     ; Limit the extension to 7 characters so that it fits in a 64-bit value.
				{
					StringMid, frn_ExtChar, frn_datExt, A_Index, 1
					if not frn_ExtChar  ; No more characters.
						break
					; Derive a Unique ID by assigning a different bit position to each character:
					frn_ExtID := frn_ExtID | (Asc(frn_ExtChar) << (8 * (A_Index - 1)))
				}
				; Check if this file extension already has an icon in the ImageLists. If it does,
				; several calls can be avoided and loading performance is greatly improved,
				; especially for a folder containing hundreds of files:
				frn_IconNumber := frn_IconArray%frn_ExtID%
			}
			else
				frn_IconNumber =
			if not frn_IconNumber  ; There is not yet any icon for this extension, so load it.
			{
				; Get the high-quality small-icon associated with this file extension:
				if not DllCall("Shell32\SHGetFileInfoA", "str", frn_Filename, "uint", 0, "str", frn_sfi, "uint", frn_sfi_size, "uint", 0x101)  ; 0x100 is SHGFI_ICON.
					frn_IconNumber = 9999999  ; Set it out of bounds to display a blank icon.
				else ; Icon successfully loaded.
				{
					; Extract the hIcon member from the structure:
					hIcon = 0
					Loop 4
						hIcon += *(&frn_sfi + A_Index-1) << 8*(A_Index-1)
					; Add the HICON directly to the small-icon and large-icon lists.
					; Below uses +1 to convert the returned index from zero-based to one-based:
					frn_IconNumber := DllCall("ImageList_ReplaceIcon", "uint", frn_ImageListID1, "int", -1, "uint", hIcon) + 1
					; Now that it's been copied into the ImageLists, the original should be destroyed:
					DllCall("DestroyIcon", "uint", hIcon)
					; Cache the icon to save memory and improve loading performance:
					frn_IconArray%frn_ExtID% := frn_IconNumber
				}
			}
			FileGetTime, frn_CreaDate, %frn_FileName%, C
			FileGetTime, frn_ModDate, %frn_FileName%, M
			FileGetTime, frn_AccDate, %frn_FileName%, A
			LV_Add("Icon" . frn_IconNumber, frn_datName, frn_datName, frn_IconNumber ">" frn_CurrentExplorerDirectory, frn_CreaDate, frn_ModDate, frn_AccDate )
			frn_RealRowNumber++
			frn_NewList = %frn_NewList%%frn_Filename%`n
		}

		if frn_RowNumber>100
		{
			frn_perc := A_Index*frn_faktor
			Progress, %frn_perc%
		}
	}
	frn_List = %frn_NewList%

	Loop, Parse, frn_List, `n, `r  ; Rows are delimited by linefeeds (`n).
	{
		SplitPath, A_LoopField, frn_datName, frn_CurrentExplorerDirectory, frn_datExt
		frn_Filename := A_LoopField
		IfExist, %frn_FileName%
		{
			frn_ExtID = 0  ; Initialize to handle extensions that are shorter than others.
			Loop 7     ; Limit the extension to 7 characters so that it fits in a 64-bit value.
			{
				StringMid, frn_ExtChar, frn_datExt, A_Index, 1
				if not frn_ExtChar  ; No more characters.
					break
				; Derive a Unique ID by assigning a different bit position to each character:
				frn_ExtID := frn_ExtID | (Asc(frn_ExtChar) << (8 * (A_Index - 1)))
			}
			frn_IconArray%frn_ExtID% =
		}
	}

	LV_ModifyCol(1,"270 Logical")
	LV_ModifyCol(2,"269 Logical")
	LV_ModifyCol(3,0)
	LV_ModifyCol(4,0)
	LV_ModifyCol(5,0)
	LV_ModifyCol(6,0)

	SplitPath, frn_CurrentExplorerDirectory, frn_currentFileName, frn_currentDir,,, frn_currentDrive
	SplitPath, frn_currentDir, frn_currentParentDir
	StringSplit, frn_dirs, frn_currentDir, \

	StringLen, frn_len, frn_CurrentExplorerDirectory

	If frn_currentFileName =
		frn_currentFileName = %frn_currentDir%

	If frn_len > 80
		frn_current = %frn_currentDrive%\%frn_dirs2%\...\%frn_currentParentDir%\%frn_currentFileName%
	Else
		frn_current = %frn_CurrentExplorerDirectory%

	If frn_Error =
		GuiControl, , frn_NumOfFiles, %lng_frn_Filelist% (%frn_RealRowNumber% %lng_frn_Files%): %frn_Current%
	Else
	{
		Gui, Font, Ccc0000 Bold
		GuiControl, Font, frn_NumOfFiles
		GuiControl, , frn_NumOfFiles, %frn_RealRowNumber% %frn_Error%:
		frn_Error =
	}

	Gosub, GuiDefaultFont

	GuiControl, +Redraw, frn_Dateiliste

	Gui, Add, Button,xs yp+30 x210 w80 Default vFileRenamerButtonRename gFileRenamerButtonRename, &%lng_frn_Rename%
	Gui, Add, Button,x+10 w80 vFileRenamerButtonCancel gFileRenamerButtonCancel, %lng_cancel%

	Gui, -Disabled

	Gosub, frn_sub_Changed

	Gui, Show, %frn_PosX% %frn_PosY% , %ScriptNameFull% - %frn_ScriptName% ; Added by RobOtter

	if frn_RowNumber>100
		Progress, Off

	GuiControl,Focus,frn_NewName

;   If frn_RealRowNumber = 0
;   {
;      Gosub, FileRenamerButtonCancel
;      MsgBox, 16, %frn_ScriptName% v%frn_ScriptVersion%, %lng_frn_NoDirs%
;   }
return

frn_sub_Changed:
	frn_ChangedTimer = 0
	Gui, %GuiID_FileRenamer%:Default
	Gui, ListView, frn_Dateiliste

	Gui, Submit, NoHide
	frn_NewName_old = %frn_NewName%

	ControlGet, frn_NewName,Line,1,Edit1, %ScriptNameFull% - %frn_ScriptName%
	If frn_NewName =
		frn_NewName = %frn_NewName_old%

	If frn_NoDialog <> 1
	{
		IfInString, frn_NewName, \f
		{
			GuiControl, Enable, %lng_frn_CropFileName%
			GuiControl, Enable, %lng_frn_CropLeft%
			GuiControl, Enable, %lng_frn_CropRight%
			GuiControl, Enable, frn_CropLeft
			GuiControl, Enable, frn_CropRight
			; Start - Added by RobOtter
			GuiControl, Enable, %lng_frn_replaceStringFrom%
			GuiControl, Enable, frn_replaceStringFrom
			GuiControl, Enable, %lng_frn_replaceStringTo%
			GuiControl, Enable, frn_replaceStringTo
			;GuiControl, Enable, frn_CaseOption
			;GuiControl, Enable, frn_Websave
			; End - Added by RobOtter
		}
		Else
		{
			GuiControl, Disable, %lng_frn_CropFileName%
			GuiControl, Disable, %lng_frn_CropLeft%
			GuiControl, Disable, %lng_frn_CropRight%
			GuiControl, Disable, frn_CropLeft
			GuiControl, Disable, frn_CropRight
			; Start - Added by RobOtter
			GuiControl, Disable, %lng_frn_replaceStringFrom%
			GuiControl, Disable, frn_replaceStringFrom
			GuiControl, Disable, %lng_frn_replaceStringTo%
			GuiControl, Disable, frn_replaceStringTo
			;GuiControl, Disable, frn_CaseOption
			;GuiControl, Disable, frn_Websave
			; End - Added by RobOtter
		}

		If frn_NewName contains \d,\t
		{
			GuiControl, Enable, %lng_frn_UseFileDateTime1%
			GuiControl, Enable, %lng_frn_UseFileDateTime2%
			GuiControl, Enable, %lng_frn_UseFileDateTime3%
			GuiControl, Enable, %lng_frn_UseFileDateTime4%
			GuiControl, Enable, %lng_frn_UseFileDateTime5%
			GuiControl, Enable, %frn_dateFormat%
			GuiControl, Enable, %frn_timeFormat%
			GuiControl, Enable, frn_Format1
			GuiControl, Enable, frn_Format2
			GuiControl, Enable, frn_TimeForm
			GuiControl, Enable, frn_DateForm
			GuiControl, Enable, %lng_frn_Date%
			GuiControl, Enable, %lng_frn_Time%
			If frn_UseFileDateTime = 5
			{
				GuiControl, , frn_Time, %A_Now%
				GuiControl, , frn_Date, %A_Now%
			}
			If (frn_UseFileDateTime = 1)
			{
				GuiControl, Enable, frn_Time
				GuiControl, Enable, frn_Date
			}
			Else
			{
				GuiControl, Disable, frn_Time
				GuiControl, Disable, frn_Date
			}
		}
		Else
		{
			GuiControl, Disable, %lng_frn_UseFileDateTime1%
			GuiControl, Disable, %lng_frn_UseFileDateTime2%
			GuiControl, Disable, %lng_frn_UseFileDateTime3%
			GuiControl, Disable, %lng_frn_UseFileDateTime4%
			GuiControl, Disable, %lng_frn_UseFileDateTime5%
			GuiControl, Disable, %frn_dateFormat%
			GuiControl, Disable, %frn_timeFormat%
			GuiControl, Disable, %lng_frn_Date%
			GuiControl, Disable, %lng_frn_Time%
			GuiControl, Disable, frn_Format1
			GuiControl, Disable, frn_Format2
			GuiControl, Disable, frn_Time
			GuiControl, Disable, frn_Date
			GuiControl, Disable, frn_TimeForm
			GuiControl, Disable, frn_DateForm
		}

		IfInString, frn_NewName, \n
		{
			GuiControl, Enable, %lng_frn_NumberingInchoateWith%
			GuiControl, Enable, frn_BeginNum
			GuiControl, Enable, frn_NumberCompletion
			If (func_StrLeft(frn_BeginNum,1) = "0" AND frn_NumberCompletion = 0)
			{
				frn_BeginNum := frn_BeginNum + 0
				GuiControl,, frn_BeginNum, %frn_BeginNum%
			}
		}
		Else
		{
			GuiControl, Disable, %lng_frn_NumberingInchoateWith%
			GuiControl, Disable, frn_BeginNum
			GuiControl, Disable, frn_NumberCompletion
		}
	}

	frn_AllNewNames =

	IfInString, frn_NewName, \c
	{
		StringSplit, frn_Clip, Clipboard, `n, `r
	}

	SetTimer, frn_tim_Changed, 50
Return

frn_tim_Changed:
	If frn_ChangedTimer = 1
	{
		frn_ChangedTimer = 0
		Return
	}
	SetTimer, frn_tim_Changed, Off
	Gui, %GuiID_FileRenamer%:Default
	Gui, ListView, frn_Dateiliste

	GuiControl, Disable, FileRenamerButtonRename

	If frn_RowNumber > 100
		GuiControl, Show, frn_Progress

	frn_ChangedTimer = 1
	Loop % LV_GetCount()
	{
		If (frn_ChangedTimer = 0)
		{
			frn_ChangedTimer =
			Break
		}

		frn_ProgressIndex := 100-A_Index/frn_RowNumber*100
		If (frn_RowNumber > 100 AND frn_ProgressIndex <> frn_ProgressLastIndex)
		{
			GuiControl, , frn_Progress, %frn_ProgressIndex%
			frn_ProgressLastIndex := Round(frn_ProgressIndex)
			frn_ButtonWait++
			If frn_ButtonWait = 1
				GuiControl, , FileRenamerButtonRename, % lng_frn_Waiting "    "
			If frn_ButtonWait = 300
				GuiControl, , FileRenamerButtonRename, % lng_frn_Waiting " .  "
			If frn_ButtonWait = 600
				GuiControl, , FileRenamerButtonRename, % lng_frn_Waiting " .. "
			If frn_ButtonWait = 900
				GuiControl, , FileRenamerButtonRename, % lng_frn_Waiting " ..."
			If frn_ButtonWait = 1199
				frn_ButtonWait =
		}

		LV_GetText(frn_datText, A_Index,1)
		LV_GetText(frn_Col3, A_Index,3)
		StringSplit, frn_Temp, frn_Col3, >
		frn_CurrentExplorerDirectory := frn_Temp2
		frn_CurrentIconNumber := frn_Temp1
		StringReplace, frn_BeginNum, frn_BeginNum, ., , All
		frn_index := frn_BeginNum + A_Index -1
		if frn_NumberCompletion = 1
		{
			frn_rowLength := frn_RealRowNumber+frn_BeginNum-1
			StringLen, frn_rowLength , frn_rowLength
			StringLen, frn_indexLength, frn_index
			StringLen, frn_BeginLength, frn_BeginNum

			frn_length := frn_rowLength-frn_indexLength

			If (frn_BeginLength > frn_indexLength) ; AND frn_length < 0 )
				frn_length := frn_BeginLength-frn_indexLength

			frn_Index = 0000000000%frn_Index%
			StringRight, frn_Index, frn_Index, % frn_length + frn_indexLength

;         msgbox, %frn_Index%`n%frn_BeginLength%-%frn_indexLength%-%frn_length%

		}
		StringReplace, frn_repName, frn_NewName, \n, %frn_index%, All

;      tooltip, %frn_RepName%`n%frn_NewName%

		frn_retDate := frn_Date
		frn_retTime := frn_Time
		If (frn_UseFileDateTime > 1 AND frn_UseFileDateTime < 5)
		{
			If frn_UseFileDateTime = 2
				FileGetTime, frn_retDate, %frn_CurrentExplorerDirectory%\%frn_datText%, M
			If frn_UseFileDateTime = 3
				FileGetTime, frn_retDate, %frn_CurrentExplorerDirectory%\%frn_datText%, C
			If frn_UseFileDateTime = 4
				frn_retDate := frn_func_getExifDate(frn_CurrentExplorerDirectory "\" frn_datText)

			frn_retTime := frn_retDate
		}
		FormatTime, frn_retDate, %frn_retDate%, %frn_DateForm%
		StringReplace, frn_repName, frn_repName, \d, %frn_retDate%, All
		FormatTime, frn_retTime, %frn_retTime%, %frn_TimeForm%
		StringReplace, frn_repName, frn_repName, \t, %frn_retTime%, All

		IfInString, frn_repName, \c
		{
			If (frn_Clip0 <= 1 OR (frn_Clip0 = 2 AND frn_Clip2 = ""))
				StringReplace, frn_repName, frn_repName, \c, %frn_Clip1%, All
			Else
			{
				If (A_Index <= frn_Clip0)
				StringReplace, frn_repName, frn_repName, \c, % frn_Clip%A_Index%, All
			}
			IfInString, frn_repName, \c
			{
				If frn_AutoExtension = 1
					StringReplace, frn_repName, frn_repName, \c, \f, All
				Else
					StringReplace, frn_repName, frn_repName, \c, \f.\x, All
			}
			Else
			{
				IfInString, frn_repName, :\
					SplitPath, frn_repName, frn_repName
			}
		}

		SplitPath, frn_datText,,, frn_datTextExt, frn_datTextName
		If frn_datTextExt contains %A_Space%,_,-,(,[,{
		{
			frn_datTextName = %frn_datText%
			frn_datTextExt =
		}
		If frn_datTextName =
		{
			frn_datTextName = %frn_datText%
			frn_datTextExt =
		}

		IfInString, frn_repName, \f
		{
			StringTrimLeft, frn_datTextName, frn_datTextName, %frn_CropLeft%
			StringTrimRight, frn_datTextName, frn_datTextName, %frn_CropRight%

			If StrLen(frn_replaceStringFrom) > 0
			{
				If (func_StrLeft(frn_replaceStringFrom,6) = "RegEx:")
					frn_datTextName := RegExReplace( frn_datTextName, func_StrRight(frn_replaceStringFrom,StrLen(frn_replaceStringFrom)-6),frn_replaceStringTo)
				Else
					StringReplace, frn_datTextName, frn_datTextName, %frn_replaceStringFrom%, %frn_replaceStringTo%, All
			}

			StringReplace, frn_repName, frn_repName, \f, %frn_datTextName%, All
		}

		If (frn_CaseOption = 2 OR frn_CaseOption = 5)
			StringLower, frn_repName, frn_repName
		Else If (frn_CaseOption = 3 OR frn_CaseOption = 6)
			StringUpper, frn_repName, frn_repName, T
		Else If (frn_CaseOption = 4 OR frn_CaseOption = 7)
			StringUpper, frn_repName, frn_repName
		If frn_CaseOption = 5
			StringLower, frn_datTextExt, frn_datTextExt
		Else If frn_CaseOption = 6
			StringUpper, frn_datTextExt, frn_datTextExt, T
		Else If frn_CaseOption = 7
			StringUpper, frn_datTextExt, frn_datTextExt

		If frn_AutoExtension = 1
			If (func_StrRight(frn_repName,3) <> ".\x")
				frn_repName = %frn_repName%.\x

		IfInString, frn_repName, \x
		{
			If (InStr(frn_newName,"\X",1))
				StringUpper, frn_datTextExt, frn_datTextExt
			StringReplace, frn_repName, frn_repName, \x, %frn_datTextExt%, All
		}

		If frn_Websave = 1
		{
			StringCaseSense, On
			StringReplace, frn_repName, frn_repName, ä, ae, A
			StringReplace, frn_repName, frn_repName, ü, ue, A
			StringReplace, frn_repName, frn_repName, ö, oe, A
			StringReplace, frn_repName, frn_repName, Ä, Ue, A
			StringReplace, frn_repName, frn_repName, Ü, Ae, A
			StringReplace, frn_repName, frn_repName, Ö, Oe, A
			StringReplace, frn_repName, frn_repName, ß, ss, A
			StringReplace, frn_repName, frn_repName, %A_Space%, _, A
			StringCaseSense, Off
			frn_datTextName := func_StrClean( frn_repName, "abcdefghijklmnopqrstuvwxyz1234567890_-.")
			StringReplace, frn_repName, frn_repName, __, _, A
			StringReplace, frn_repName, frn_repName, __, _, A
		}

		StringReplace, frn_repName, frn_repName, \`%, |#|, All
		StringReplace, frn_repName, frn_repName, `%, /#/, All
		StringReplace, frn_repName, frn_repName, |#|, `%, All
		Transform, frn_repName, Deref, %frn_repName%
		StringReplace, frn_repName, frn_repName, /#/, `%, All

		If frn_AllowSlashes = 1
		{
			StringReplace, frn_repName, frn_repName, \\, /, All
			StringReplace, frn_repName, frn_repName, \/, /, All
			frn_repName := func_StrTranslate(frn_repName, "\?<>:*|", "")
			StringReplace, frn_repName, frn_repName, /, \, All
		}
		Else
			frn_repName := func_StrTranslate(frn_repName, "\/?<>:*|", "")

		StringReplace, frn_repName, frn_repName, ", , All
		; " ; end qoute for syntax highlighting

		frn_AllNewNames = %frn_AllNewNames%`n%frn_CurrentExplorerDirectory%\%frn_repName%`n

		StringReplace, frn_Temp, frn_AllNewNames, `n%frn_CurrentExplorerDirectory%\%frn_repName%`n, , All UseErrorLevel
		frn_Occurrence = %ErrorLevel%
		If frn_Occurrence > 1
		{
			SplitPath, frn_repName,,, frn_datTextExt
			If frn_datTextExt =
				frn_datTextName =%frn_repName%
			Else
				StringTrimRight, frn_datTextName, frn_repName, % StrLen(frn_datTextExt)+1
			frn_repName = %frn_datTextName% (%frn_Occurrence%)
			If frn_datTextExt <>
				frn_repName = %frn_datTextName% (%frn_Occurrence%).%frn_datTextExt%
		}

		frn_repName := func_StrTrimChars(frn_repName,"",". `t")

		If (frn_FirstRow AND A_Index < frn_FirstRow-1)
			continue

		LV_Modify(A_Index, "Col2", frn_repName)
	}
	If (frn_ChangedTimer <> "" OR frn_StopAtRow <> "")
	{
		frn_FirstRow =
		frn_StopAtRow =
		GuiControl, Hide, frn_Progress
		GuiControl, , FileRenamerButtonRename, &%lng_frn_Rename%
		GuiControl, Enable, FileRenamerButtonRename
	}
	frn_ChangedTimer =
Return

FileRenamerGuiContextMenu:
	If (GetKeyState("LButton") = 1 OR A_Thislabel = A_LastLabel)
	{
		A_LastLabel =
		Return
	}
	If A_GuiControl = frn_Dateiliste
		Gosub, frn_sub_ContextMenu
	A_LastLabel = %A_Thislabel%
	SetTimer, frn_sub_RButtonOn, -10
Return

frn_sub_RButtonOn:
	A_LastLabel =
Return

frn_sub_ShowRegExMenu:
	Menu, frn_RegEx, Show
Return

frn_sub_RegExMenuCall:
	GuiDefault("FileRenamer")
	frn_SelectedRegEx := A_ThisMenuItemPos-2
	GuiControl, , frn_replaceStringFrom, % "`a" frn_RegExSearch%frn_SelectedRegEx% "`a" frn_lastReplaceStringFrom_tmp
	GuiControl, , frn_replaceStringTo, % "`a" frn_RegExReplace%frn_SelectedRegEx% "`a" frn_lastReplaceStringTo_tmp
	GuiControl, ChooseString, frn_replaceStringFrom, % frn_RegExSearch%frn_SelectedRegEx%
	GuiControl, ChooseString, frn_replaceStringTo, % frn_RegExReplace%frn_SelectedRegEx%
	Gosub, frn_sub_Changed
Return

;Dateiliste Reaktionen
FileRenamerDateiliste:
	Gui, ListView, frn_Dateiliste
	If A_GuiEvent = DoubleClick  ; There are many other possible values the script can check.
	{
		LV_GetText(frn_datName, LV_GetNext(), 1) ; Get the text of the first field.
		GuiControl, Text, frn_NewName, %frn_datName%
	}
	If A_GuiEvent = ColClick
	{
		frn_func_SortCol(A_EventInfo)
;
;      If frn_SortCol%A_EventInfo% <> Sort
;         frn_SortCol%A_EventInfo% = Sort
;      Else
;         frn_SortCol%A_EventInfo% = SortDesc
;
;      LV_ModifyCol(A_EventInfo, frn_SortCol%A_EventInfo% " Logical")
;
;      Gosub, frn_sub_Changed
	}
	MouseGetPos,, frn_MouseY
	If (frn_DragY AND frn_MouseY > frn_DragY+2 AND A_GuiEvent = "D")
	{
		frn_StartDragY = %frn_DragY%
		frn_StartRow := LV_GetNext(0)
		SetTimer, frn_tim_Dragging,20
	}
	If (frn_DragY AND frn_MouseY < frn_DragY-2 AND A_GuiEvent = "D")
	{
		frn_StartDragY = %frn_DragY%
		frn_StartRow := LV_GetNext(0)
		SetTimer, frn_tim_Dragging,20
	}

	frn_DragY =
	If A_GuiEvent = C
		frn_DragY = %frn_MouseY%

	If ( A_GuiEvent = "K" AND A_EventInfo = 46 )
		Gosub, frn_sub_DelRow
	If ( A_GuiEvent = "K" AND A_EventInfo = 86 AND GetKeyState("Ctrl"))
		Gosub, frn_sub_Paste
	If ( A_GuiEvent = "K" AND A_EventInfo = 82 AND GetKeyState("Ctrl"))
		Gosub, frn_sub_Changed
	If ( A_GuiEvent = "K" AND A_EventInfo = 116)
		Gosub, frn_sub_Changed
	If ( A_GuiEvent = "K" AND A_EventInfo = 67 AND GetKeyState("Ctrl"))
		Gosub, frn_sub_Copy

	If ( A_GuiEvent = "K" AND A_EventInfo = 38 AND GetKeyState("Alt")) ; Up
		Gosub, frn_sub_MoveUp
	If ( A_GuiEvent = "K" AND A_EventInfo = 40 AND GetKeyState("Alt")) ; Down
		Gosub, frn_sub_MoveDown
	If ( A_GuiEvent = "K" AND A_EventInfo = 36 AND GetKeyState("Alt")) ; Home
		Gosub, frn_sub_MoveTop
	If ( A_GuiEvent = "K" AND A_EventInfo = 35 AND GetKeyState("Alt")) ; End
		Gosub, frn_sub_MoveBottom

	LV_GetText(frn_CurrentExplorerTmpDir, A_EventInfo, 3)
	StringTrimLeft, frn_CurrentExplorerTmpDir, frn_CurrentExplorerTmpDir, 2
	SplitPath, frn_CurrentExplorerTmpDir, frn_currentFileName, frn_currentDir,,, frn_currentDrive
	SplitPath, frn_currentDir, frn_currentParentDir
	StringSplit, frn_dirs, frn_currentDir, \

	StringLen, frn_len, frn_CurrentExplorerTmpDir

	If frn_currentFileName =
		frn_currentFileName = %frn_currentDir%

	If frn_len > 80
		frn_current = %frn_currentDrive%\%frn_dirs2%\...\%frn_currentParentDir%\%frn_currentFileName%
	Else
		frn_current = %frn_CurrentExplorerTmpDir%

	If frn_current <>
		GuiControl, , frn_NumOfFiles, %lng_frn_Filelist% (%frn_RealRowNumber% %lng_frn_Files%): %frn_Current%
Return

frn_tim_Dragging:
	If (!GetKeyState("LButton"))
	{
		SetTimer, frn_tim_Dragging, Off
;      ToolTip
		Return
	}
	Critical
	Gui, %GuiID_FileRenamer%:Default
	Gui, ListView, frn_Dateiliste
	uh_RowHeight := func_GetLVRowHeight("ahk_id " frn_LVHwnd,"")
	MouseGetPos,, frn_MouseY
	frn_DragRow := Round(frn_StartRow-(frn_StartDragY-frn_MouseY)/uh_RowHeight)
	frn_FirstRow := LV_GetNext(0)
	frn_MoveCount := Abs(frn_DragRow-frn_FirstRow)

	frn_DontVis = 1
	If (frn_DragRow-frn_FirstRow < 0 AND frn_FirstRow > 1)
		Loop, %frn_MoveCount%
			Gosub, frn_sub_MoveUp
	If (frn_DragRow-frn_FirstRow > 0 AND frn_FirstRow+LV_GetCount("Selected")-1 < LV_GetCount())
		Loop, %frn_MoveCount%
			Gosub, frn_sub_MoveDown
	frn_DontVis =

;   ToolTip, %frn_StartRow%:%frn_FirstRow% -> %frn_DragRow% = %frn_MoveCount%
Return

frn_sub_ContextMenu:
	Gui, %GuiID_FileRenamer%:Default
	Gui, ListView, frn_Dateiliste

	frn_NumRows := LV_GetCount("Selected")

	If GuiContextMenu_FileRenamer =
	{
		GuiContextMenu_FileRenamer = visible
		If frn_NumRows > 0
		{
			Menu, frn_Context, Add, %lng_frn_Delete%, frn_sub_DelRow
			Menu, frn_Context, Add
			Menu, frn_Context, Add, %lng_frn_MoveTop%, frn_sub_MoveTop
			Menu, frn_Context, Add, %lng_frn_MoveUp%, frn_sub_MoveUp
			Menu, frn_Context, Add, %lng_frn_MoveDown%, frn_sub_MoveDown
			Menu, frn_Context, Add, %lng_frn_MoveBottom%, frn_sub_MoveBottom
			Menu, frn_Context, Add
		}
		Menu, frn_Context, Add, %lng_frn_SortCrea%, frn_sub_SortCrea
		Menu, frn_Context, Add, %lng_frn_SortMod%, frn_sub_SortMod
		Menu, frn_Context, Add, %lng_frn_SortAcc%, frn_sub_SortAcc
		If frn_NumRows > 0
		{
			Menu, frn_Context, Add
			Menu, frn_Context, Add, %lng_frn_Properties%, frn_sub_Properties
		}
	}
	Menu, frn_Context, Show
	Menu, frn_Context, DeleteAll
	GuiContextMenu_FileRenamer =
Return

frn_sub_Properties:
	Gui, %GuiID_FileRenamer%:Default
	Gui, ListView, frn_Dateiliste
	GuiControl, -Redraw, frn_Dateiliste

	frn_PropFiles =
	frn_propRowNumber = 0
	Loop
	{
		frn_propRowNumber := LV_GetNext(frn_propRowNumber)
		If NOT frn_propRowNumber  ; The above returned zero, so there are no more selected rows.
			break
		LV_GetText(frn_propName, frn_propRowNumber, 1)
		LV_GetText(frn_propPath, frn_propRowNumber, 3)
		StringSplit, frn_propPath, frn_propPath, >
		Run, properties "%frn_propPath2%\%frn_propName%",, UseErrorLevel
	}
	If ErrorLevel = ERROR
		func_GetErrorMessage( A_LastError, frn_ScriptTitle, frn_propPath2 "\" frn_propName "`n`n" )
	GuiControl, +Redraw, frn_Dateiliste
	Gosub, frn_sub_Changed
Return

frn_sub_SortCrea:
	frn_func_SortCol(4)
Return

frn_sub_SortMod:
	frn_func_SortCol(5)
Return

frn_sub_SortAcc:
	frn_func_SortCol(6)
Return

frn_func_SortCol(Col)
{
	Global
	Gui, %GuiID_FileRenamer%:Default
	Gui, ListView, frn_Dateiliste
	GuiControl, -Redraw, frn_Dateiliste
	If frn_SortCol%Col% <> Sort
		frn_SortCol%Col% = Sort
	Else
		frn_SortCol%Col% = SortDesc

	LV_ModifyCol(Col, frn_SortCol%Col% " Logical")

	GuiControl, +Redraw, frn_Dateiliste
	Gosub, frn_sub_Changed
}

frn_sub_MoveUp:
	Gui, %GuiID_FileRenamer%:Default
	Gui, ListView, frn_Dateiliste
	GuiControl, -Redraw, frn_Dateiliste

	frn_FirstRow := LV_GetNext(0)
	frn_NumRows := LV_GetCount("Selected")
	Loop
	{
		frn_Index := A_Index
		frn_actRowNumber := LV_GetNext(0)  ; Resume the search at the row after that found by the previous iteration.

		If NOT frn_actRowNumber  ; The above returned zero, so there are no more selected rows.
			break

		If A_Index = 1
			frn_MoveToRow := frn_actRowNumber

		Loop, 6
			LV_GetText(frn_Col%A_Index%[%frn_Index%], frn_actRowNumber, A_Index)

		LV_Delete(frn_actRowNumber)
	}

	If frn_MoveToRow > 1
		frn_MoveToRow--

	Loop, %frn_NumRows%
	{
		frn_Index := frn_NumRows+1-A_Index
		StringSplit, frn_Temp, frn_Col3[%frn_Index%], >

		LV_Insert(frn_MoveToRow, "Select Icon" frn_Temp1, frn_Col1[%frn_Index%], frn_Col2[%frn_Index%], frn_Col3[%frn_Index%], frn_Col4[%frn_Index%], frn_Col5[%frn_Index%], frn_Col6[%frn_Index%])
	}

	If frn_DontVis = 1
		LV_Modify(frn_MoveToRow, "Focus")
	Else
		LV_Modify(frn_MoveToRow, "Vis Focus")

	GuiControl, +Redraw, frn_Dateiliste
	Gosub, frn_sub_Changed
Return

frn_sub_MoveDown:
	Gui, %GuiID_FileRenamer%:Default
	Gui, ListView, frn_Dateiliste
	GuiControl, -Redraw, frn_Dateiliste

	frn_FirstRow := LV_GetNext(0)

	LV_Add()

	frn_NumRows := LV_GetCount("Selected")
	Loop
	{
		frn_Index := A_Index
		frn_actRowNumber := LV_GetNext(0)  ; Resume the search at the row after that found by the previous iteration.

		If NOT frn_actRowNumber  ; The above returned zero, so there are no more selected rows.
			break

		If A_Index = 1
			frn_MoveToRow := frn_actRowNumber

		Loop, 6
			LV_GetText(frn_Col%A_Index%[%frn_Index%], frn_actRowNumber, A_Index)

		LV_Delete(frn_actRowNumber)
	}

	If (frn_MoveToRow <= LV_GetCount()-1 )
		frn_MoveToRow := frn_MoveToRow+1

	Loop, %frn_NumRows%
	{
		frn_Index := frn_NumRows+1-A_Index
		StringSplit, frn_Temp, frn_Col3[%frn_Index%], >

		LV_Insert(frn_MoveToRow, "Select Icon" frn_Temp1, frn_Col1[%frn_Index%], frn_Col2[%frn_Index%], frn_Col3[%frn_Index%], frn_Col4[%frn_Index%], frn_Col5[%frn_Index%], frn_Col6[%frn_Index%])
	}

	If frn_DontVis = 1
		LV_Modify(frn_MoveToRow+frn_NumRows-1, "Focus")
	Else
		LV_Modify(frn_MoveToRow+frn_NumRows-1, "Vis Focus")

	LV_Delete(LV_GetCount())

	GuiControl, +Redraw, frn_Dateiliste
	Gosub, frn_sub_Changed
Return

frn_sub_MoveTop:
	Gui, %GuiID_FileRenamer%:Default
	Gui, ListView, frn_Dateiliste
	GuiControl, -Redraw, frn_Dateiliste

	frn_NumRows := LV_GetCount("Selected")
	Loop
	{
		frn_Index := A_Index
		frn_actRowNumber := LV_GetNext(0)  ; Resume the search at the row after that found by the previous iteration.

		If NOT frn_actRowNumber  ; The above returned zero, so there are no more selected rows.
			break

		If A_Index = 1
			frn_MoveToRow := frn_actRowNumber

		Loop, 6
			LV_GetText(frn_Col%A_Index%[%frn_Index%], frn_actRowNumber, A_Index)

		LV_Delete(frn_actRowNumber)
	}

	If (frn_MoveToRow <= LV_GetCount()-1 )
		frn_MoveToRow := frn_MoveToRow+1

	Loop, %frn_NumRows%
	{
		frn_Index := frn_NumRows+1-A_Index
		StringSplit, frn_Temp, frn_Col3[%frn_Index%], >

		LV_Insert(1, "Select Icon" frn_Temp1, frn_Col1[%frn_Index%], frn_Col2[%frn_Index%], frn_Col3[%frn_Index%], frn_Col3[%frn_Index%], frn_Col4[%frn_Index%], frn_Col5[%frn_Index%], frn_Col6[%frn_Index%])
	}

	LV_Modify(1, "Vis Focus")

	GuiControl, +Redraw, frn_Dateiliste
	Gosub, frn_sub_Changed
Return

frn_sub_MoveBottom:
	Gui, %GuiID_FileRenamer%:Default
	Gui, ListView, frn_Dateiliste
	GuiControl, -Redraw, frn_Dateiliste

	frn_FirstRow := LV_GetNext(0)

	LV_Add()

	frn_NumRows := LV_GetCount("Selected")
	Loop
	{
		frn_Index := A_Index
		frn_actRowNumber := LV_GetNext(0)  ; Resume the search at the row after that found by the previous iteration.

		If NOT frn_actRowNumber  ; The above returned zero, so there are no more selected rows.
			break

		If A_Index = 1
			frn_MoveToRow := frn_actRowNumber

		Loop, 6
			LV_GetText(frn_Col%A_Index%[%frn_Index%], frn_actRowNumber, A_Index)

		LV_Delete(frn_actRowNumber)
	}

	Loop, %frn_NumRows%
	{
		frn_Index := A_Index
		StringSplit, frn_Temp, frn_Col3[%frn_Index%], >

		LV_Insert(LV_GetCount(), "Select Icon" frn_Temp1, frn_Col1[%frn_Index%], frn_Col2[%frn_Index%], frn_Col3[%frn_Index%], frn_Col3[%frn_Index%], frn_Col4[%frn_Index%], frn_Col5[%frn_Index%], frn_Col6[%frn_Index%])
	}

	LV_Modify(LV_GetCount(), "Vis Focus")

	LV_Delete(LV_GetCount())

	GuiControl, +Redraw, frn_Dateiliste
	Gosub, frn_sub_Changed
Return

frn_sub_Copy:
	Critical

	Gui, %GuiID_FileRenamer%:Default
	Gui, ListView, frn_Dateiliste
	GuiControl, -Redraw, frn_Dateiliste

	frn_newClip =
	Loop % LV_GetCount()
	{
		LV_GetText(frn_datText, A_Index,1)
		If frn_AutoExtension = 1
			SplitPath, frn_datText,,,,frn_datText
		frn_newClip := frn_newClip frn_datText "`r`n"
	}
	ClipBoard = %frn_newClip%
	Gosub, frn_sub_Changed
Return

frn_sub_Paste:
	Critical

	Gui, %GuiID_FileRenamer%:Default
	Gui, ListView, frn_Dateiliste
	GuiControl, -Redraw, frn_Dateiliste

	Gui, Submit, NoHide
	Sleep,30
	IfNotInString, frn_newName, \c
	{
		GuiControl,Text,frn_newName, \c
		Sleep,30
	}
	Gosub, frn_sub_Changed
Return

;Button Reaktionen
FileRenamerButtonRename:
	GuiControl, Disable, FileRenamerButtonRename
	GuiControl, Disable, FileRenamerButtonCancel

	if frn_RowNumber>100
	{
		Progress, b2 p0 w300 FS9, ... , %lng_frn_Renaming%
		frn_faktor := 100/(frn_RowNumber*2)
	}

	Gui, %GuiID_FileRenamer%: Submit, NoHide
	frn_FilesWithErrors =

	If (frn_RealRowNumber = 1 AND frn_NoDialog = "" AND frn_AlwaysUseMultiFileGUI = 0)
	{
		SplitPath, frn_Name,,, frn_datTextExt, frn_datTextName
		frn_repName = %frn_newName%

		StringReplace, frn_repName, frn_repName, \f, %frn_datTextName%, All
		If (InStr(frn_repName,"\X",1))
			StringUpper, frn_datTextExt, frn_datTextExt
		StringReplace, frn_repName, frn_repName, \x, %frn_datTextExt%, All

		;SplitPath, frn_repName,,, frn_repExt, frn_repName

		FormatTime, frn_retDate, %frn_Date%, %frn_DateForm%
		StringReplace, frn_repName, frn_repName, \d, %frn_retDate%, All
		FormatTime, frn_retTime, %frn_Time%, %frn_TimeForm%
		StringReplace, frn_repName, frn_repName, \t, %frn_retTime%, All

		If StrLen(frn_replaceStringFrom) > 0
		{
			StringReplace, frn_repName, frn_repName, %frn_replaceStringFrom%, %frn_replaceStringTo%, All
		}

		If frn_Websave = 1
		{
			StringCaseSense, On
			StringReplace, frn_repName, frn_repName, ä, ae, A
			StringReplace, frn_repName, frn_repName, ü, ue, A
			StringReplace, frn_repName, frn_repName, ö, oe, A
			StringReplace, frn_repName, frn_repName, Ä, Ue, A
			StringReplace, frn_repName, frn_repName, Ü, Ae, A
			StringReplace, frn_repName, frn_repName, Ö, Oe, A
			StringReplace, frn_repName, frn_repName, ß, ss, A
			StringReplace, frn_repName, frn_repName, %A_Space%, _, A
			StringCaseSense, Off
			frn_repName := func_StrClean( frn_repName, "abcdefghijklmnopqrstuvwxyz1234567890_-.")
			StringReplace, frn_repName, frn_repName, __, _, A
			StringReplace, frn_repName, frn_repName, __, _, A
		}
		If (frn_CaseOption = 2 OR frn_CaseOption = 5)
			StringLower, frn_repName, frn_repName
		Else If (frn_CaseOption = 3 OR frn_CaseOption = 6)
			StringUpper, frn_repName, frn_repName, T
		Else If (frn_CaseOption = 4 OR frn_CaseOption = 7)
			StringUpper, frn_repName, frn_repName
		If frn_CaseOption = 5
			StringLower, frn_datTextExt, frn_datTextExt
		Else If frn_CaseOption = 6
			StringUpper, frn_datTextExt, frn_datTextExt, T
		Else If frn_CaseOption = 7
			StringUpper, frn_datTextExt, frn_datTextExt

		If frn_repExt <>
			frn_repName = %frn_repName%.%frn_repExt%

		If frn_AllowSlashes = 1
		{
			StringReplace, frn_repName, frn_repName, \\, /, All
			StringReplace, frn_repName, frn_repName, \/, /, All
			frn_repName := func_StrTranslate(frn_repName, "\?<>:*|", "")
			StringReplace, frn_repName, frn_repName, /, \, All
		}
		Else
			frn_repName := func_StrTranslate(frn_repName, "\/?<>:*|", "")

		StringReplace, frn_repName, frn_repName, ", , All ;"

		FileGetAttrib, frn_Attributes, %frn_CurrentExplorerDirectory%\%frn_datName%
		IfInString, frn_Attributes, D
			If frn_AlwaysOverwrite = 1
				FileMoveDir, %frn_CurrentExplorerDirectory%\%frn_datName%, %frn_CurrentExplorerDirectory%\%frn_repName%, 2
			Else
				FileMoveDir, %frn_CurrentExplorerDirectory%\%frn_datName%, %frn_CurrentExplorerDirectory%\%frn_repName%, R
		Else
			FileMove, %frn_CurrentExplorerDirectory%\%frn_datName%, %frn_CurrentExplorerDirectory%\%frn_repName%, %frn_AlwaysOverwrite%
	}
	else
	{
		frn_AllNewNames =
		Loop % LV_GetCount()
		{
			LV_GetText(frn_datText, A_Index,1)
			LV_GetText(frn_repName, A_Index,2)
			LV_GetText(frn_CurrentExplorerDirectory, A_Index,3)
			LV_GetText(frn_Col3, A_Index,3)
			StringSplit, frn_Temp, frn_Col3, >
			frn_CurrentExplorerDirectory := frn_Temp2
			frn_CurrentIconNumber := frn_Temp1

			FileGetAttrib, frn_Attributes, %frn_CurrentExplorerDirectory%\%frn_datText%
			IfInString, frn_Attributes, D
				If frn_AlwaysOverwrite = 1
					FileMoveDir, %frn_CurrentExplorerDirectory%\%frn_datText%, %frn_CurrentExplorerDirectory%\aadFileRenamerTmp_%A_Index%_%frn_datText%, 2
				Else
					FileMoveDir, %frn_CurrentExplorerDirectory%\%frn_datText%, %frn_CurrentExplorerDirectory%\aadFileRenamerTmp_%A_Index%_%frn_datText%, R
			Else
				FileMove, %frn_CurrentExplorerDirectory%\%frn_datText%, %frn_CurrentExplorerDirectory%\aadFileRenamerTmp_%A_Index%_%frn_datText%, %frn_AlwaysOverwrite%
;         If ErrorLevel = 1
;            frn_FilesWithErrors = %frn_FilesWithErrors%%frn_datText%`n
			if (frn_RowNumber>100 AND A_Index/20 = Round(A_Index/20))
			{
				frn_perc := A_Index*frn_faktor
				Progress, %frn_perc%, %frn_datText%
			}
		}

		Loop % LV_GetCount()
		{
			LV_GetText(frn_datText, A_Index,1)
			LV_GetText(frn_repName, A_Index,2)
			LV_GetText(frn_Col3, A_Index,3)
			StringSplit, frn_Temp, frn_Col3, >
			frn_CurrentExplorerDirectory := frn_Temp2
			frn_CurrentIconNumber := frn_Temp1
			IfNotExist, %frn_CurrentExplorerDirectory%\aadFileRenamerTmp_%A_Index%_%frn_datText%
			{
				frn_FilesWithErrors = %frn_FilesWithErrors%`n%frn_datText%`n
				continue
			}
			FileGetAttrib, frn_Attributes, %frn_CurrentExplorerDirectory%\aadFileRenamerTmp_%A_Index%_%frn_datText%

			If frn_AllowSlashes = 1
			{
				frn_SubFolder = %frn_CurrentExplorerDirectory%\%frn_repName%
				SplitPath, frn_SubFolder ,,frn_SubFolder
				IfNotExist, %frn_SubFolder%
					FileCreateDir, %frn_SubFolder%
			}

			IfInString, frn_Attributes, D
				If frn_AlwaysOverwrite = 1
					FileMoveDir, %frn_CurrentExplorerDirectory%\aadFileRenamerTmp_%A_Index%_%frn_datText%, %frn_CurrentExplorerDirectory%\%frn_repName%, 2
				Else
					FileMoveDir, %frn_CurrentExplorerDirectory%\aadFileRenamerTmp_%A_Index%_%frn_datText%, %frn_CurrentExplorerDirectory%\%frn_repName%, R
			Else
				FileMove, %frn_CurrentExplorerDirectory%\aadFileRenamerTmp_%A_Index%_%frn_datText%, %frn_CurrentExplorerDirectory%\%frn_repName%, %frn_AlwaysOverwrite%
			If ErrorLevel = 1
			{
				IfInString, frn_Attributes, D
					If frn_AlwaysOverwrite = 1
						FileMoveDir, %frn_CurrentExplorerDirectory%\aadFileRenamerTmp_%A_Index%_%frn_datText%, %frn_CurrentExplorerDirectory%\%frn_datText%, 2
					Else
						FileMoveDir, %frn_CurrentExplorerDirectory%\aadFileRenamerTmp_%A_Index%_%frn_datText%, %frn_CurrentExplorerDirectory%\%frn_datText%, R
				Else
					FileMove, %frn_CurrentExplorerDirectory%\aadFileRenamerTmp_%A_Index%_%frn_datText%, %frn_CurrentExplorerDirectory%\%frn_datText%, %frn_AlwaysOverwrite%
				frn_FilesWithErrors = %frn_FilesWithErrors%`n%frn_datText%`n
				If frn_AllowSlashes = 1
					FileRemoveDir, %frn_SubFolder%, 0
			}
			if (frn_RowNumber>100 AND A_Index/20 = Round(A_Index/20))
			{
				frn_perc := (A_Index+frn_RowNumber)*frn_faktor
				Progress, %frn_perc%, %frn_repName%
			}
		}

		Loop
		{
			LV_GetText(frn_datText, A_Index,1)
			If frn_datText =
				break
			Loop
			{
				IfInString, frn_FilesWithErrors, `n%frn_datText%`n
					LV_Delete(A_Index)
				Else
					break
				LV_GetText(frn_datText, A_Index,1)
				If frn_datText =
					break
			}
		}

		StringReplace, frn_LastReplacement, frn_LastReplacement, %frn_NewName%`a,
		frn_LastReplacement = %frn_NewName%`a%frn_LastReplacement%
		StringGetPos, frn_LastReplacementPos, frn_LastReplacement, `a, L20
		If frn_LastReplacementPos > 1
			StringLeft, frn_LastReplacement, frn_LastReplacement, % frn_LastReplacementPos+1

		IniWrite, "%frn_LastReplacement%, %ConfigFile%, %frn_ScriptName%, LastReplacement
		; " ; end qoute for syntax highlighting
	}
	If frn_NumberCompletion = 1
	{
		frn_Index := frn_RealRowNumber+frn_BeginNum
		StringLen, frn_length , frn_Index
		StringLen, frn_BeginLength, frn_BeginNum

		If (frn_BeginLength > frn_length) ; AND frn_length < 0 )
			frn_length := frn_BeginLength-frn_length

		frn_Index = 0000000000%frn_Index%
		StringRight, frn_Index, frn_Index, %frn_length%
	}
	If frn_IncreaseBeginNum = 1
		IniWrite, %frn_Index%, %ConfigFile%, %frn_ScriptName%, NumberBegin
	Else
		IniWrite, %frn_BeginNum%, %ConfigFile%, %frn_ScriptName%, NumberBegin

	IniWrite, %frn_numberBegin%, %ConfigFile%, %frn_ScriptName%, StandardNumberBegin
	IniWrite, %frn_NumberCompletion%, %ConfigFile%, %frn_ScriptName%, NumberCompletion
	IniWrite, %frn_dateForm%, %ConfigFile%, %frn_ScriptName%, DateFormat
	IniWrite, %frn_timeForm%, %ConfigFile%, %frn_ScriptName%, TimeFormat
	IniWrite, %frn_dateFormat%, %ConfigFile%, %frn_ScriptName%, StandardDateFormat
	IniWrite, %frn_timeFormat%, %ConfigFile%, %frn_ScriptName%, StandardTimeFormat
	IniWrite, %frn_UseFileDateTime% , %ConfigFile%, %frn_ScriptName%, UseFileDateTime
	IniWrite, %frn_Date%, %ConfigFile%, %frn_ScriptName%, Date
	IniWrite, %frn_Time%, %ConfigFile%, %frn_ScriptName%, Time
	IniWrite, %frn_CaseOption%, %ConfigFile%, %frn_ScriptName%, CaseOption
	IniWrite, %frn_CropLeft%, %ConfigFile%, %frn_ScriptName%, CropLeft
	IniWrite, %frn_CropRight%, %ConfigFile%, %frn_ScriptName%, CropRight
	IniWrite, %frn_Websave%, %ConfigFile%, %frn_ScriptName%, Websave

	AutoTrim, Off
	If frn_replaceStringFrom =
		frn_replaceStringFrom = `%A_Empty`%
	StringReplace, frn_lastReplaceStringFrom, frn_lastReplaceStringFrom, `a%frn_replaceStringFrom%`a,`a,A
	StringReplace, frn_lastReplaceStringFrom, frn_lastReplaceStringFrom, `a`a, `a, A
	frn_lastReplaceStringFrom = `a%frn_replaceStringFrom%`a%frn_lastReplaceStringFrom%`a
	StringReplace, frn_lastReplaceStringFrom, frn_lastReplaceStringFrom, `a`a, `a, A
	StringTrimRight, frn_lastReplaceStringFrom, frn_lastReplaceStringFrom, 1
	IniWrite, "%frn_lastReplaceStringFrom%, %ConfigFile%, %frn_ScriptName%, LastReplaceStringFrom
	; " ; end qoute for syntax highlighting

	If frn_replaceStringTo =
		frn_replaceStringTo = `%A_Empty`%
	StringReplace, frn_lastReplaceStringTo, frn_lastReplaceStringTo, `a%frn_replaceStringTo%`a,`a, A
	StringReplace, frn_lastReplaceStringTo, frn_lastReplaceStringTo, `a`a, `a, A
	frn_lastReplaceStringTo = `a%frn_replaceStringTo%`a%frn_lastReplaceStringTo%`a
	StringReplace, frn_lastReplaceStringTo, frn_lastReplaceStringTo, `a`a, `a, A
	StringTrimRight, frn_lastReplaceStringTo, frn_lastReplaceStringTo, 1
	IniWrite, "%frn_lastReplaceStringTo%, %ConfigFile%, %frn_ScriptName%, LastReplaceStringTo
	; " ; end qoute for syntax highlighting
	AutoTrim, On

	; End - Added by RobOtter
	WinGetPos, frn_PosX, frn_PosY,,,ahk_id %frn_GuiWindowID%
	IniWrite, %frn_PosX%, %ConfigFile%, %frn_ScriptName%, PosX
	IniWrite, %frn_PosY%, %ConfigFile%, %frn_ScriptName%, PosY
	frn_PosX = x%frn_PosX%
	frn_PosY = y%frn_PosY%

	IL_Destroy(frn_ImageListID1)
	Gui, %GuiID_FileRenamer%: Cancel
	Gui, %GuiID_FileRenamer%: Destroy
	If frn_FilesWithErrors <>
	{
		frn_Error = %lng_frn_ErrorWhileRenaming%
		frn_NoDialog =
		Goto, frn_createManyFileGui
	}
	Else
	{
		Sleep,100
		IfWinNotActive, ahk_id %frn_ActiveID%
			WinActivate, ahk_id %frn_ActiveID%
		SendMessage, 0x111, 41504,,, ahk_id %frn_ActiveID% ; Aktualisieren
		if (frn_RealRowNumber = 1 AND frn_NoDialog = "")
			func_SelectInExplorer(frn_repName)
	}
	Progress, Off
return

FileRenamerGuiClose:
FileRenamerGuiEscape:
FileRenamerButtonCancel:
	frn_ChangedTimer = 0
	If MainGuiVisible =
	{
		func_RemoveMessage(0x200, "GuiTooltip")
		func_RemoveMessage(0x6, "RemoveGuiTooltip")
	}
	IL_Destroy(frn_ImageListID1)
	WinGetPos, frn_PosX, frn_PosY,,,ahk_id %frn_GuiWindowID%
	IniWrite, %frn_PosX%, %ConfigFile%, %frn_ScriptName%, PosX
	IniWrite, %frn_PosY%, %ConfigFile%, %frn_ScriptName%, PosY
	frn_PosX = x%frn_PosX%
	frn_PosY = y%frn_PosY%

	Gui, %GuiID_FileRenamer%: Cancel
	Gui, %GuiID_FileRenamer%: Destroy
	frn_CurrentExplorerDirectory =
return

frn_sub_DelRow:
	Critical
	Gui, %GuiID_FileRenamer%:Default
	Gui, ListView, frn_Dateiliste
	GuiControl, -Redraw, frn_Dateiliste
	Loop
	{
		frn_LVrow := LV_GetNext()
		if frn_LVrow = 0
			break
		LV_Delete( frn_LVrow )
		frn_Sel := frn_LVrow
		frn_RealRowNumber--
	}
	GuiControl, %GuiID_FileRenamer%:+Redraw, frn_Dateiliste

	if frn_RealRowNumber < 0
		frn_RealRowNumber = 0

	LV_Modify( frn_Sel, "Select")

	Gosub, frn_sub_Changed
Return

frn_func_getExifDate( file="", ReturnDateNumber=1 ) {
	FileRead, binData, *m1024 %file%
	P := &binData

	Loop, 1024
	{
	  Char := NumGet(P+(A_Index-1),0,"UChar")
	  If ( Char < 32 )
		  Char := 32
	  binData2 .= Chr(Char)
	}

	IfNotInString, binData2, Exif
	{
		FileGetTime, date, %file%, C
		Return %date%
	}
	pos = 1
	Loop
	{
		pos := RegExMatch(binData2, "\d{4}:\d{2}:\d{2} \d{2}:\d{2}:\d{2}", date%A_Index%, pos+1)
		If pos = 0
			Break
		date%A_Index% := RegExReplace(date%A_Index%, " |:", "")
		pos++
	}
	return % date%ReturnDateNumber%
}