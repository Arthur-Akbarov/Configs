; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               FilePaste
; -----------------------------------------------------------------------------
; Prefix:             fp_
; Version:            1.2.1
; Date:               2007-06-07
; Author:             Bernd Schandl, Wolfgang Reszel, Michael Telgkamp
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_FilePaste:
	Prefix = fp
	%Prefix%_ScriptName    = FilePaste
	%Prefix%_ScriptVersion = 1.2.1
	%Prefix%_Author        = Bernd Schandl, Wolfgang Reszel, Michael Telgkamp

	RequireExtensions       =
	AddSettings_FilePaste   =
	ConfigFile_FilePaste    =
	IconFile_On_FilePaste  = %A_WinDir%\system32\shell32.dll
	IconPos_On_FilePaste   = 226

	CustomHotkey_FilePaste  = 1          ; Benutzerdefiniertes Hotkey
	Hotkey_FilePaste        = ^#v        ; Standard-Hotkey
	HotkeyPrefix_FilePaste  = $          ; Präfix

	HideSettings                = 0
	EnableTray_FilePaste        = 1
	DisableIfCompiled_FilePaste = 0

	CreateGuiID("FilePaste")
	CreateGuiID("FilePasteReplace")

	If Lng = 07  ; = Deutsch
	{
		MenuName              = %fp_ScriptName% - Dateinamen und Pfade aus Zwischenablage
		Description           = Fügt im Explorer kopierte Dateien in Textform als Dateinamen oder ganze Pfade ein.
		lng_fp_PasteLink      = Dateinamen einfügen
		lng_fp_BadInput       = Inhalt der Zwischenablage nicht analysierbar. Also wurde keine Laufwerkskonvertierung durchgeführt.
		lng_fp_DriveNotFound  = Laufwerk nicht vorhanden oder kein Netzwerklaufwerk. Also wurde keine Laufwerkskonvertierung durchgeführt.
		lng_fp_Unknown        = Unbekannter Fehler. Bitte Mail an den Autor.
		lng_fp_setPath        = Einfügen
		lng_fp_setPath1       = Dateiname mit UNC-Pfad
		lng_fp_setPath2       = Dateiname mit Windows-Pfad
		lng_fp_setPath3       = Nur Dateiname
		lng_fp_setPath4       = Benutzerdefiniert:
		lng_fp_setChangeText  = Text ersetzen
		lng_fp_setReplace     = Ersetze
		lng_fp_setBy          = Durch
		lng_fp_setCase        = Groß-/Kleinschreibung beachten
		lng_fp_setCaseShort   = Groß-/Kleinschreibung
		lng_fp_setAddText     = Text ergänzen
		lng_fp_setFront       = Davor
		lng_fp_setAfter       = Danach
		lng_fp_setCase1       = Keine Änderung der Schreibweise
		lng_fp_setCase2       = Großbuchstaben
		lng_fp_setCase3       = Kleinbuchstaben
		lng_fp_setSlash       = Schrägstriche
		lng_fp_setSlashes1    = Keine Änderung der Schrägstriche
		lng_fp_setSlashes2    = Umgekehrte Schrägstriche zu Schrägstriche \ » /
		lng_fp_setSlashes3    = Schrägstriche zu umgekehrte Schrägstriche  / » \
		lng_fp_setOther       = Weitere Einstellungen
		lng_fp_setCode        = URL-Kodierung
		lng_fp_setQuote       = In Anführungszeichen setzen
		lng_fp_ReplaceMore    = weitere ...
		lng_fp_ReplaceMoreTitle = weitere Textersetzungen ...
		lng_fp_pasting        = Zwischenablage wird aufbereitet ...
		lng_fp_noSlashes      = Schrägstriche nicht kodieren
		lng_fp_CalcFolderSize = Ordnergröße wird berechnet, bitte warten!
		lng_fp_Folder         = Dateiordner

		tooltip_fp_Path = Wandelt die Pfade von Dateien auf Netzlaufwerken in UNC-Pfade um.`nDateien, die nicht auf Netzlaufwerken liegen, werden als Windows-Pfade eingefügt.
		tooltip_Dateiname_mit_Windows_Pfad = Der Komplette Verzeichnispfad einer Datei wird eingefügt.
		tooltip_Nur_Dateiname = Es wird nur der Dateiname eingefügt.

		tooltip_fp_Cap        = Es wird die Schreibweise vom Datenträger verwendet.
		tooltip_Großbuchstaben = Einzufügender Text wird komplett in Großbuchstaben umgewandelt
		tooltip_Kleinbuchstaben = Einzufügender Text wird komplett in Kleinbuchstaben umgewandelt

		tooltip_fp_Slash      = Schrägstriche werden nicht umgewandelt
		tooltip_Umgekehrte_Schrägstriche_zu_Schrägstriche___»__ = Umgekehrte Schrägstriche (Windows) werden zu normalen Schrägstrichen (Unix, Internt) umgewandelt.
		tooltip_Schrägstriche_zu_umgekehrte_Schrägstriche____»__ = Normale Schrägstriche (Unix, Internt) werden zu umgekehrten Schrägstrichen (Windows) umgewandelt.

		tooltip_fp_Front      = Text, welcher vor jeder Zeile hinzugefügt wird.
		tooltip_fp_End        = Text, welcher hinter jeder Zeile angefügt wird.

		tooltip_fp_Replace    = Text, welcher ersetzt werden soll.
		tooltip_fp_By         = Text, welcher stattdessen verwendet werden soll.
		tooltip_fp_ReplaceCase= Groß-/Kleinschreibung bei der Ersetzung berücksichtigen.`nDer Text bei 'Ersetze' muss also exakt übereinstimmen, damit er ersetzt wird.
		tooltip_weitere____   = Weitere Ersetzungsregeln ...

		tooltip_fp_Encode     = Wandelt Sonderzeichen wie z.B. Umlaute und Leerzeichen`nin deren entsprechenden URL-Codes (z.B. `%20) um.
		tooltip_fp_DontEncodeSlashes = Schrägstriche (/ und \) werden nicht umgewandelt.
		tooltip_fp_Quote      = Alle Pfade werden in Anführungszeichen eingeschlossen.

		tooltip_fp_NoBalloonTips = Keine Hinweise bei Problemen mit der Konvertierung der Daten in der Zwischenablage anzeigen.

		tooltip_fp_customPath = \f`tDateiname`n\n`tName ohne Erweiterung`n\x`tErweiterung`n\p`tPfad`n\sz`tDateigröße`n\kb`tDateigröße in KB`n\mb`tDateigröße in MB`n\fs`tOrdnergröße berechnen`n\mt`tÄnderungszeit`n\md`tÄnderungsdatum`n\ct`tErstellungszeit`n\cd`tErstellungsdatum`n<t>`tTabulator`n<n>`tZeilenumbruch
	}
	else        ; = Alternativ-Sprache
	{
		MenuName              = %fp_ScriptName% - filenames and paths from clipboard
		Description           = Pastes copied files as plain text filenames or paths
		lng_fp_PasteLink      = Insert link
		lng_fp_BadInput       = Cannot analyse clipboard. So no drive conversion is done.
		lng_fp_DriveNotFound  = Drive not found or not a network drive. So no drive conversion is done.
		lng_fp_Unknown        = Unknown error. Please send mail to the author.
		lng_fp_setPath        = Insert
		lng_fp_setPath1       = File name with UNC path
		lng_fp_setPath2       = File name with Windows path
		lng_fp_setPath3       = Only file name
		lng_fp_setPath4       = Custom:
		lng_fp_setChangeText  = Change Text
		lng_fp_setReplace     = Replace
		lng_fp_setBy          = By
		lng_fp_setCase        = Case sensitive
		lng_fp_setCaseShort   = Case
		lng_fp_setAddText     = Add Text
		lng_fp_setFront       = Front
		lng_fp_setAfter       = End
		lng_fp_setCase1       = No change of capitalization
		lng_fp_setCase2       = Uppercase
		lng_fp_setCase3       = Lowercase
		lng_fp_setSlash       = Slashes
		lng_fp_setSlashes1    = No change of slashes
		lng_fp_setSlashes2    = Back slashes to forward slashes  \ » /
		lng_fp_setSlashes3    = Forward slashes to back slashes / » \
		lng_fp_setOther       = Further settings
		lng_fp_setCode        = URL Encoding
		lng_fp_setQuote       = Set in quotation marks
		lng_fp_ReplaceMore    = more ...
		lng_fp_ReplaceMoreTitle = more replacement ...
		lng_fp_pasting        = processing clipboard ...
		lng_fp_noSlashes      = Don't encode slashes
		lng_fp_CalcFolderSize = Calculating folder size, please wait!
		lng_fp_Folder         = Folder

		tooltip_fp_customPath = \f`tFilename`n\n`tName without extension\x`tExtension\p`tPath`n\sz`tFilesize`n\kb`tFilesize in KB`n\mb`tFilesize in MB`n\fs`tcalculate foldersize`n\mt`tModification time`n\md`tModification date\ct`tCreation time\cd`tCreation date<t>`tTabulator`n<n>`tNew line
	}

	; Ini-Datei lesen; wenn nichts drin steht, Textfelder auf leer setzen
	IniRead, fp_Path, %ConfigFile%, %fp_ScriptName%, Path, 3
	IniRead, fp_customPath, %ConfigFile%, %fp_ScriptName%, CustomPath, \f<t>\sz<t>\md - \mt
	fp_Path := func_LimitValue(fp_Path,"1-4")
	IniRead, fp_Replace, %ConfigFile%, %fp_ScriptName%, ReplaceThis, %A_Space%
	IniRead, fp_By, %ConfigFile%, %fp_ScriptName%, ReplaceBy, %A_Space%
	IniRead, fp_ReplaceCase, %ConfigFile%, %fp_ScriptName%, ReplaceCase, 0
	IniRead, fp_Front, %ConfigFile%, %fp_ScriptName%, AddFront, %A_Space%
	StringReplace, fp_Front,fp_Front, `%20, %A_Space%, A
	IniRead, fp_End, %ConfigFile%, %fp_ScriptName%, AddEnd, %A_Space%
	StringReplace, fp_End,fp_End, `%20, %A_Space%, A
	IniRead, fp_Cap, %ConfigFile%, %fp_ScriptName%, Capitalization, 1
	fp_Cap := func_LimitValue(fp_Cap,"1-3")
	IniRead, fp_Slash, %ConfigFile%, %fp_ScriptName%, Slashes, 1
	fp_Slash := func_LimitValue(fp_Slash,"1-3")
	IniRead, fp_Encode, %ConfigFile%, %fp_ScriptName%, InternetEncoding, 0
	IniRead, fp_Quote, %ConfigFile%, %fp_ScriptName%, PutInQuotes, 0
	IniRead, fp_NoBalloonTips, %ConfigFile%, %fp_ScriptName%, NoBalloonTips, 0
	IniRead, fp_DontEncodeSlashes, %ConfigFile%, %fp_ScriptName%, DontEncodeSlashes, 1
	Loop, 13
	{
		IniRead, fp_Replace%A_Index%, %ConfigFile%, %fp_ScriptName%, ReplaceThis%A_Index%, %A_Space%
		StringReplace, fp_Replace%A_Index%,fp_Replace%A_Index%, `%20, %A_Space%, A
		IniRead, fp_By%A_Index%, %ConfigFile%, %fp_ScriptName%, ReplaceBy%A_Index%, %A_Space%
		StringReplace, fp_By%A_Index%,fp_By%A_Index%, `%20, %A_Space%, A
		IniRead, fp_ReplaceCase%A_Index%, %ConfigFile%, %fp_ScriptName%, ReplaceCase%A_Index%, 0
	}
Return

SettingsGui_FilePaste:
	; Umfang der Einfügung
	Gui, Add, GroupBox, xs+10 ys+35 w270 h90, %lng_fp_setPath%
	Gui, Add, Radio, -wrap xp+10 yp+18 gfp_sub_CheckIfSettingsChanged vfp_Path1, %lng_fp_setPath1%
	Gui, Add, Radio, -wrap xp y+4 gfp_sub_CheckIfSettingsChanged vfp_Path2, %lng_fp_setPath2%
	Gui, Add, Radio, -wrap xp y+4 gfp_sub_CheckIfSettingsChanged vfp_Path3, %lng_fp_setPath3%
	Gui, Add, Radio, -wrap xp y+4 gfp_sub_CheckIfSettingsChanged vfp_Path4, %lng_fp_setPath4%
	Gui, Add, Edit, h20 x+5 R1 yp-3 w140 gsub_CheckIfSettingsChanged Disabled vfp_customPath, %fp_customPath%
	GuiControl,,fp_Path%fp_Path%, 1
	; Text ersetzen
	Gui, Add, GroupBox, xs+290 ys+35 w270 h90, %lng_fp_setChangeText%
	Gui, Add, Text, xp+10 yp+20 w40, %lng_fp_setReplace%:
	Gui, Add, Edit, x+10 yp-3 w200 gsub_CheckIfSettingsChanged vfp_Replace, %fp_Replace%
	Gui, Add, Text, x+-250 y+6 w40, %lng_fp_setBy%:
	Gui, Add, Edit, x+10 yp-3 w200 gsub_CheckIfSettingsChanged vfp_By, %fp_By%
	Gui, Add, CheckBox, -wrap x+-250 y+6 gsub_CheckIfSettingsChanged vfp_ReplaceCase Checked%fp_ReplaceCase%, %lng_fp_setCase%
	Gui, Add, Button, -wrap xs+480 yp-3 h20 w70 gfp_sub_ReplaceMore, %lng_fp_ReplaceMore%
	; Groß-/Kleinschreibung
	Gui, Add, GroupBox, xs+10 ys+130 w270 h80, %lng_fp_setCaseShort%
	Gui, Add, Radio, -wrap xp+10 yp+20 gsub_CheckIfSettingsChanged vfp_Cap, %lng_fp_setCase1%
	Gui, Add, Radio, -wrap xp yp+20 gsub_CheckIfSettingsChanged, %lng_fp_setCase2%
	Gui, Add, Radio, -wrap xp yp+20 gsub_CheckIfSettingsChanged, %lng_fp_setCase3%
	GuiControl,,% lng_fp_setCase%fp_Cap%, 1
	; Schrägstriche ändern
	Gui, Add, GroupBox, xs+290 ys+130 w270 h80, %lng_fp_setSlash%
	Gui, Add, Radio, -wrap xp+10 yp+20 gsub_CheckIfSettingsChanged vfp_Slash, %lng_fp_setSlashes1%
	Gui, Add, Radio, -wrap xp yp+20 gsub_CheckIfSettingsChanged, %lng_fp_setSlashes2%
	Gui, Add, Radio, -wrap xp yp+20 gsub_CheckIfSettingsChanged, %lng_fp_setSlashes3%
	GuiControl,,% lng_fp_setSlashes%fp_Slash%, 1
	; Text ergänzen
	Gui, Add, GroupBox, xs+10 ys+215 w270 h65, %lng_fp_setAddText%
	Gui, Add, Text, xp+10 yp+18 w40, %lng_fp_setFront%:
	Gui, Add, Edit, x+10 yp-3 w200 gsub_CheckIfSettingsChanged vfp_Front, %fp_Front%
	Gui, Add, Text, x+-250 y+5 w40, %lng_fp_setAfter%:
	Gui, Add, Edit, x+10 yp-3 w200 gsub_CheckIfSettingsChanged vfp_End, %fp_End%
	; Sonstiges
	Gui, Add, GroupBox, xs+290 ys+215 w270 h65, %lng_fp_setOther%
	Gui, Add, CheckBox, -wrap xp+10 yp+20 gfp_sub_CheckIfSettingsChanged vfp_Encode Checked%fp_Encode%, %lng_fp_setCode%
	Gui, Add, CheckBox, -wrap xp yp+20 gsub_CheckIfSettingsChanged vfp_Quote Checked%fp_Quote%, %lng_fp_setQuote%
	Gui, Add, CheckBox, -wrap xp+100 yp-20 gsub_CheckIfSettingsChanged vfp_DontEncodeSlashes Checked%fp_DontEncodeSlashes%, %lng_fp_noSlashes%

	Gui, Add, CheckBox, gsub_CheckIfSettingsChanged vfp_NoBalloonTips xs+370 ys+290 -Wrap Checked%fp_NoBalloonTips%, %lng_NoBalloonTips%
	Gosub, fp_sub_Changed
Return

fp_sub_CheckIfSettingsChanged:
	Gosub,sub_CheckIfSettingsChanged
fp_sub_Changed:
	GuiControlGet, fp_Encode_tmp,, fp_Encode
	If fp_Encode_tmp = 1
		GuiControl, Enable, fp_DontEncodeSlashes
	Else
		GuiControl, Disable, fp_DontEncodeSlashes
	GuiControlGet, fp_Path_tmp,, fp_Path4
	If fp_Path_tmp = 1
		GuiControl, Enable, fp_customPath
	Else
		GuiControl, Disable, fp_customPath
Return

SaveSettings_FilePaste:
	fp_Path := fp_Path1*1 + fp_Path2*2 + fp_Path3*3 + fp_Path4*4
	IniWrite, %fp_Path%, %ConfigFile%, %fp_ScriptName%, Path
	IniWrite, %fp_customPath%, %ConfigFile%, %fp_ScriptName%, CustomPath
	IniWrite, %fp_Replace%, %ConfigFile%, %fp_ScriptName%, ReplaceThis
	IniWrite, %fp_By%, %ConfigFile%, %fp_ScriptName%, ReplaceBy
	IniWrite, %fp_ReplaceCase%, %ConfigFile%, %fp_ScriptName%, ReplaceCase
	StringReplace, fp_Front,fp_Front, %A_Space%, `%20, A
	IniWrite, %fp_Front%, %ConfigFile%, %fp_ScriptName%, AddFront
	StringReplace, fp_End,fp_End, %A_Space%, `%20, A
	IniWrite, %fp_End%, %ConfigFile%, %fp_ScriptName%, AddEnd
	IniWrite, %fp_Cap%, %ConfigFile%, %fp_ScriptName%, Capitalization
	IniWrite, %fp_Slash%, %ConfigFile%, %fp_ScriptName%, Slashes
	IniWrite, %fp_Encode%, %ConfigFile%, %fp_ScriptName%, InternetEncoding
	IniWrite, %fp_Quote%, %ConfigFile%, %fp_ScriptName%, PutInQuotes
	IniWrite, %fp_NoBalloonTips%, %ConfigFile%, %fp_ScriptName%, NoBalloonTips
	IniWrite, %fp_DontEncodeSlashes%, %ConfigFile%, %fp_ScriptName%, DontEncodeSlashes
	Loop, 13
	{
		StringReplace, fp_Replace%A_Index%,fp_Replace%A_Index%, %A_Space%, `%20, A
		IniWrite, % fp_Replace%A_Index%, %ConfigFile%, %fp_ScriptName%, ReplaceThis%A_Index%
		StringReplace, fp_By%A_Index%,fp_By%A_Index%, %A_Space%, `%20, A
		IniWrite, % fp_By%A_Index%, %ConfigFile%, %fp_ScriptName%, ReplaceBy%A_Index%
		IniWrite, % fp_ReplaceCase%A_Index%, %ConfigFile%, %fp_ScriptName%, ReplaceCase%A_Index%
		StringReplace, fp_Replace%A_Index%,fp_Replace%A_Index%, `%20, %A_Space%, A
		StringReplace, fp_By%A_Index%,fp_By%A_Index%, `%20, %A_Space%, A
	}

	StringReplace, fp_Front,fp_Front, `%20, %A_Space%, A
	StringReplace, fp_End,fp_End, `%20, %A_Space%, A
Return

AddSettings_FilePaste:
Return

CancelSettings_FilePaste:
Return

DoEnable_FilePaste:
Return

DoDisable_FilePaste:
Return

DefaultSettings_FilePaste:
Return

Update_FilePaste:
	IniRead, fp_RemoveFromPaths, %ConfigFile%, FilePaste, RemoveFromPaths
	If fp_RemoveFromPaths <> ERROR
	{
		IniRead, fp_PastePaths, %ConfigFile%, FilePaste, PastePaths
		If fp_PastePaths = 1
			IniWrite, 2, %ConfigFile%, FilePaste, Path
		Else
			IniWrite, 3, %ConfigFile%, FilePaste, Path
		IniDelete, %ConfigFile%, FilePaste, PastePaths
		IniDelete, %ConfigFile%, FilePaste, RemoveFromPaths
		Loop, Parse, fp_RemoveFromPaths, |
		{
			If A_LoopField =
				continue
			If A_Index > 13
				break
			IniWrite, %A_LoopField%, %ConfigFile%, FilePaste, ReplaceThis%A_Index%
			IniWrite, % "", %ConfigFile%, FilePaste, ReplaceBy%A_Index%
			IniWrite, 0, %ConfigFile%, FilePaste, ReplaceCase%A_Index%
		}
	}
Return

; -----------------------------------------------------------------------------
; === Subroutine ==============================================================
; -----------------------------------------------------------------------------
fp_sub_ReplaceMore:
	Gui, %GuiID_activAid%:+Disabled
	GuiDefault("FilePaste", "+Owner" GuiID_activAid)
	Gosub, GuiDefaultFont
	Loop,13
	{
		Gui, Add, Text, x10 y+8, %lng_fp_setReplace%:
		Gui, Add, Edit, x+5 yp-3 w200 vfp_Replace%A_Index%_tmp, % fp_Replace%A_Index%
		Gui, Add, Text, x+5 yp+3, %lng_fp_setBy%:
		Gui, Add, Edit, x+10 yp-3 w200 vfp_By%A_Index%_tmp, % fp_By%A_Index%
		Gui, Add, CheckBox, % "-wrap x+5 yp+3 w200 vfp_ReplaceCase" A_Index "_tmp Checked" fp_ReplaceCase%A_Index%, %lng_fp_setCaseShort%
	}
	Gui, Add, Button, -Wrap X230 W80 Default gfp_sub_ReplacementeOK, %lng_OK%
	Gui, Add, Button, -Wrap X+5 W80 gFilePasteGuiClose, %lng_cancel%

	Gui, Show, w640, %fp_ScriptName% - %lng_fp_ReplaceMoreTitle%
Return

FilePasteGuiClose:
FilePasteGuiEscape:
	Gui, %GuiID_activAid%:-Disabled
	Gui, Destroy
Return

fp_sub_ReplacementeOK:
	Gui, Submit, Nohide
	Gosub, FilePasteGuiClose
	Loop,13
	{
		fp_Replace%A_Index% := fp_Replace%A_Index%_tmp
		fp_By%A_Index% := fp_By%A_Index%_tmp
		fp_ReplaceCase%A_Index% := fp_ReplaceCase%A_Index%_tmp
	}
	func_SettingsChanged( fp_ScriptName )
Return

sub_Hotkey_Filepaste:
	Thread, Priority, 10
	SetKeyDelay, 20,20
	fp_PathsToPaste := Clipboard

	fp_PasteText =
	if ( fp_Path = 1 )
	{
		fp_TempFile = %A_Temp%\UNCNames.txt
		FileDelete, %fp_TempFile%
		Sleep, 100
		RunWait, %ComSpec% /c net use > %fp_TempFile% ,, HIDE
		FileRead, fp_TempFileContent, %fp_TempFile%
	}

	If fp_Path = 4
		SplashImage,,b1 cwFFFFc0 FS10, %lng_fp_Pasting%

	Loop, Parse, fp_PathsToPaste, `n, `r
	{
		fp_return = 0
		IfExist, %A_LoopField%
		{
			if ( fp_Path = 1 )
			{
				If (A_Index = 10 OR A_Index = Round(A_Index/30)*30)
					Tooltip, %lng_fp_pasting%
				; UNC Konvertierung
				fp_return := fp_path2UNC(A_LoopField,fp_PathToPaste)
				if ( fp_return = 0 )
				{
					; alles ok, nichts zu tun
				}
				else if ( fp_return = 1 )
				{
					; kein Laufwerksbuchstabe erkannt, trotzdem weitermachen
					If fp_NoBalloonTips = 0
						BalloonTip( fp_ScriptName, lng_fp_BadInput, "Error",1,0,8)
				}
				else if ( fp_return = 2 )
				{
					; kein Netzwerklaufwerk, trotzdem weitermachen
					;If fp_NoBalloonTips = 0
					;BalloonTip( fp_ScriptName, lng_fp_DriveNotFound, "Info",1,0,8)
				}
				else
				{
					; unbekannter Fehler, Abbruch
					BalloonTip( fp_ScriptName, lng_fp_Unknown, "Error",1,0,8)
					Return
				}
			}
			else if ( fp_Path = 2 )
			{
				; Pfad beibehalten
				fp_PathToPaste := A_LoopField
			}
			else if ( fp_Path = 3 )
			{
				; Pfad entfernen
				SplitPath, A_LoopField, fp_PathToPaste
			}
			else if ( fp_Path = 4 )
			{
				; Benutzerdefiniert
				SplitPath, A_LoopField, fp_cFilename, fp_cPath, fp_cExt, fp_cNoExt
				FileGetTime, fp_cModification, %A_LoopField%, M
				FileGetTime, fp_cCreation, %A_LoopField%, C
				FileGetSize, fp_cSize, %A_LoopField%

				fp_cSizeMB := Round(fp_cSize/1024/1024)
				If fp_cSizeMB = 0
					fp_cSizeMB := Round(Ceil(fp_cSize*100/1024/1024)/100,2)
				fp_cSizeKB := Round(fp_cSize/1024)
				If fp_cSizeKB = 0
					fp_cSizeKB := Round(Ceil(fp_cSize*100/1024)/100,2)
				If fp_cSize < 1024
					fp_cSize = %fp_cSize% Byte
				Else If (fp_cSize < 1024*1024)
					fp_cSize := Round(fp_cSize/1024) " KB"
				Else If (fp_cSize < 1024*1024*10)
					fp_cSize := Round(fp_cSize/1024/1024,2) " MB"
				Else
					fp_cSize := Round(fp_cSize/1024/1024) " MB"
				FormatTime, fp_cModDate, %fp_cModification%, ShortDate
				FormatTime, fp_cModTime, %fp_cModification%, Time
				FormatTime, fp_cCreDate, %fp_cCreation%, ShortDate
				FormatTime, fp_cCreTime, %fp_cCreation%, Time
				fp_PathToPaste = %fp_customPath%
				FileGetAttrib, fp_cAttribs, %A_LoopField%
				IfInString, fp_cAttribs, D
				{
					IfInString, fp_PathToPaste, \fs
					{
						fp_cSize = 0
						SplashImage,,b1 cwFFFFc0 FS10, %lng_fp_CalcFolderSize%`n`n%fp_cFilename%
						Loop, %fp_cPath%\%fp_cFilename%\*.*, 0, 1
						{
							fp_cSize += %A_LoopFileSize%
						}
						fp_cSizeMB := Round(fp_cSize/1024/1024)
						If fp_cSizeMB = 0
							fp_cSizeMB := Round(Ceil(fp_cSize*100/1024/1024)/100,2)
						fp_cSizeKB := Round(fp_cSize/1024)
						If fp_cSizeKB = 0
							fp_cSizeKB := Round(Ceil(fp_cSize*100/1024)/100,2)
						If fp_cSize < 1024
							fp_cSize = %fp_cSize% Byte
						Else If (fp_cSize < 1024*1024)
							fp_cSize := Round(fp_cSize/1024) " KB"
						Else If (fp_cSize < 1024*1024*10)
							fp_cSize := Round(fp_cSize/1024/1024,2) " MB"
						Else
							fp_cSize := Round(fp_cSize/1024/1024) " MB"
						fp_cSize = (%fp_cSize%)
						fp_cSizeMB = (%fp_cSizeMB%)
						fp_cSizeKB = (%fp_cSizeKB%)
					}
					Else
					{
						fp_cSize = (%lng_fp_Folder%)
						fp_cSizeMB = %fp_cSize%
						fp_cSizeKB = %fp_cSize%
					}
				}
				StringReplace, fp_PathToPaste, fp_PathToPaste, \fs,, A
				StringReplace, fp_PathToPaste, fp_PathToPaste, \f, %fp_cFilename%, A
				StringReplace, fp_PathToPaste, fp_PathToPaste, \n, %fp_cNoExt%, A
				StringReplace, fp_PathToPaste, fp_PathToPaste, \x, %fp_cExt%, A
				StringReplace, fp_PathToPaste, fp_PathToPaste, \p, %fp_cPath%, A
				StringReplace, fp_PathToPaste, fp_PathToPaste, \md, %fp_cModDate%, A
				StringReplace, fp_PathToPaste, fp_PathToPaste, \mt, %fp_cModTime%, A
				StringReplace, fp_PathToPaste, fp_PathToPaste, \cd, %fp_cCreDate%, A
				StringReplace, fp_PathToPaste, fp_PathToPaste, \ct, %fp_cCreTime%, A
				StringReplace, fp_PathToPaste, fp_PathToPaste, \sz, %fp_cSize%, A
				StringReplace, fp_PathToPaste, fp_PathToPaste, \kb, %fp_cSizeKB%, A
				StringReplace, fp_PathToPaste, fp_PathToPaste, \mb, %fp_cSizeMB%, A
				StringReplace, fp_PathToPaste, fp_PathToPaste, <t>, %A_TAB%, A
				StringReplace, fp_PathToPaste, fp_PathToPaste, <n>, `r`n, A
			}
			If A_Index = 1
				fp_PasteText := fp_ConvertString(fp_PathToPaste)
			Else
				fp_PasteText := fp_PasteText "`r`n" fp_ConvertString(fp_PathToPaste)
		}
		Else
		{
			If A_Index = 1
				fp_PasteText := fp_ConvertString(A_LoopField)
			Else
				fp_PasteText := fp_PasteText "`r`n" fp_ConvertString(A_LoopField)
		}
	}
	SplashImage, Off

	; Zwischenablage speichern, verwenden und wieder freigeben
	ClipSaved := ClipboardAll
	Clipboard =
	Sleep,10
	Clipboard := fp_PasteText
	ClipWait, 2

	SendEvent, ^v

	Sleep, 200
	Clipboard := ClipSaved
	ClipSaved =

	FileDelete, %fp_TempFile%

	Tooltip
	;BalloonTip( fp_ScriptName, lng_fp_BadInput, "Error","Reset")
	;BalloonTip( fp_ScriptName, lng_fp_DriveNotFound, "Error","Reset")
	;BalloonTip( fp_ScriptName, lng_fp_Unknown, "Error","Reset")
Return

; -----------------------------------------------------------------------------
; === Gesamtpfad in UNC-Pfad umwandeln ========================================
; -----------------------------------------------------------------------------
; Input:  ORGpath Eingangspfad
;         UNCpath Pfad als UNC, wird von der Funktion gesetzt
; Output: 0 Ok
;         1 Eingangstext konnte nicht interpretiert werden
;         2 Laufwerksbuchstabe nicht gefunden
;;================
fp_path2UNC(ORGpath,ByRef UNCpath)
{
	SplitPath, ORGpath, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	StringReplace, OutDir, OutDir, %OutDrive%\, \,

	IfInString, OutDir, :
		OutDir =

	length := 1000
	VarSetCapacity(remoteName, length)
	result := DllCall("Mpr\WNetGetConnectionA"
			, "Str", OutDrive
			, "Str", remoteName
			, "UInt *", length)
	if (ErrorLevel <> 0 || result != 0)
	{
		UNCpath := ORGpath
		Return 2
	}
	UNCpath := remoteName OutDir "\" OutFileName
	Return 0
}

; -----------------------------------------------------------------------------
; === String entsprechend der Optionen konvertieren ===========================
; -----------------------------------------------------------------------------
; Input:  Ausgangsstring
; Output: Umgewandelter String
;;================
fp_ConvertString(fp_inString)
{
	; Variablen bekannt machen
	global
	AutoTrim, Off

	fp_Replaced = 0
	fp_outString = %fp_inString%
	; Text ersetzen
	if ( fp_Replace <> "" )
	{
		if ( fp_ReplaceCase = 0 )
			StringCaseSense, off
		else
			StringCaseSense, on
		StringReplace, fp_outString, fp_outString, %fp_Replace%, %fp_By%, All
		fp_Replaced = %ErrorLevel%
	}
	Loop, 13
	{
		if (fp_Replace%a_index% = "")
			break

		if ( fp_ReplaceCase%A_Index% = 0 )
			StringCaseSense, off
		else
			StringCaseSense, on
		StringReplace, fp_outString, fp_outString, % fp_Replace%A_Index%, % fp_By%A_Index%, All
		fp_Replaced = %ErrorLevel%
	}
	; Groß-/Kleinschreibung
	if ( fp_Cap = 2 )
		StringUpper, fp_outString, fp_outString
	else if ( fp_Cap = 3 )
		StringLower, fp_outString, fp_outString
	; Schrägstriche
	if ( fp_Slash = 2 )
		StringReplace, fp_outString, fp_outString, \, /, All
	else if ( fp_Slash = 3 )
		StringReplace, fp_outString, fp_outString, /, \, All
	; Vorne oder hinten anhängen
	fp_outString = %fp_Front%%fp_outString%%fp_End%
	; URL Kodierung
	if ( fp_Encode = 1 )
		fp_outString := fp_EncodeURL( fp_outString )
	; Anführungszeichen ergänzen
	if ( fp_Quote )
		fp_outString = "%fp_outString%"
	return fp_outString
}

; -----------------------------------------------------------------------------
; === URL Kodierung ===========================================================
; -----------------------------------------------------------------------------
; Input:  Ausgangsstring
; Output: Kodierter String
;;================
fp_EncodeURL( string )
{
	Global fp_DontEncodeSlashes
	SetFormat, Integer, hex
	; Nicht zu kodierende Zeichen
	;safeChar = !$&'()*+,-./0123456789:;=$@ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz
	safeChar = !$'()*+,-.0123456789:;=$@ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz
	If fp_DontEncodeSlashes = 1
		safeChar = %safeChar%/\

	code =
	loop, parse, string
	{
		if safeChar contains %A_LoopField%
		{
			; Nicht zu kodierende Zeichen einfach übernehmen
			code = %code%%A_LoopField%
		}
		else
		{
			; Zu kodierende Zeichen in Hex-Code umwandeln
			token := Asc( A_LoopField )
			StringTrimLeft, token, token, 2
			code = %code%`%%token%
		}
	}
	SetFormat, Integer, d

	return %code%
}
