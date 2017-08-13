; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               ScreenShots
; -----------------------------------------------------------------------------
; Prefix:             scr_
; Version:            0.7
; Date:               2008-05-23
; Author:             Michael Telgkamp, Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------
init_ScreenShots:
	Prefix = scr
	%Prefix%_ScriptName    = ScreenShots
	%Prefix%_ScriptVersion = 0.7
	%Prefix%_Author        = Michael Telgkamp, Wolfgang Reszel, Rico Niemand

	CustomHotkey_ScreenShots = 0
	ConfigFile_ScreenShots   = %SettingsDir%\screenshot_counter.ini
	IconFile_On_ScreenShots  = %A_WinDir%\system32\shell32.dll
	IconPos_On_ScreenShots   = 142

	CreateGuiID("ScreenShotsDim")
	CreateGuiID("ScreenShotsHidden")
	CreateGuiID("ScreenShotsFrame")
	CreateGuiID("ScreenShotsAutoEdit")
	CreateGuiID("ScreenShotsUpload")
	CreateGuiID("ScreenShotsToolBar")
	CreateGuiID("ScreenShotsHelper")

	scr_WinDelay = 0

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %scr_ScriptName% - Bildschirmfotos
		Description                   = Ermöglicht das Abfotografieren des Bildschirms mittels Tastaturkürzel oder Maus.
		lng_scr_ScreenShot            = Bildschirmfoto
		lng_scr_Hotkeydefinitions     = Hotkeys
		lng_scr_Monitor               = Kompletter Bildschirm
		lng_scr_Application           = Aktives Fenster
		lng_scr_Client                = Arbeitsbereich des aktuellen Fensters
		lng_scr_Element               = Fensterelement unter der Maus
		lng_scr_Interactive           = Interaktive Auswahl
		lng_scr_LastInteractive       = Sofort letzte interaktive Auswahl

		lng_scr_ButtonAllMonitors     = &Alle Bildschirme
		lng_scr_ButtonMonitor         = B&ildschirm
		lng_scr_ButtonActiveWindow    = Aktives &Fensters
		lng_scr_ButtonSelection       = Aus&schnitt

		lng_scr_captureCursor         = Mauszeiger erfassen

		lng_scr_ScreenshotMode        = Aufnahmemodus
		lng_scr_ToClipboard           = In Zwischenablage speichern
		lng_scr_ToFile                = In Datei speichern
		lng_scr_ToFileAndClipBoard    = In Datei und Zwischenablage speichern
		lng_scr_Counter               = Zähler (\n) beginnt bei
		tooltip_scr_Counter           = Diese Zahl wird für jede neue Datei um eins erhöht
		lng_scr_DateFormat            = Datumsformat (\d)
		tooltip_scr_DateFormat        = Datumsformat nach AutoHotkey (z.B. yyyyMMddHHmmss)
		lng_scr_Filesettings          = Dateieinstellungen
		lng_scr_FileNameFormat        = Dateinamenformat
		lng_scr_FileName              = Dateiname
		lng_scr_FormatInfo            = \t = Fenstertitel
		lng_scr_FileFormat            = Dateiformat
		lng_scr_ScreenShotFolder      = Zielordner
		lng_scr_PlaySound             = Akustisches Feedback
		lng_scr_Hightlight            = Visuelles Feedback
		lng_scr_Resize                = Verkleinern auf
		tooltip_scr_Resize            = Mögliche Eingaben:`n50`%`n1/2`n640*480`n640*?`n?*640
		lng_scr_Open                  = Öffnen
		lng_scr_Remember              = Merken

		lng_scr_DisableFontSmoothing0 = Schriftglättung übernehmen
		lng_scr_DisableFontSmoothing1 = Schriftglättung komplett ausschalten
		lng_scr_DisableFontSmoothing2 = Nur ClearType ausschalten
		lng_scr_FilenameToClipboard   = Dateiname nach Screenshot in die Zwischenablage kopieren
		lng_scr_DelayProgress         = ScreenShot Verzögerung
		tooltip_scr_Delay             = Sekunden Verzögerung, um die Maus noch positionieren zu können
		lng_scr_Delay                 = Sekunden Verzögerung bei "Interaktive Auswahl"
		lng_scr_OpenFolder            = Zielordner nach Screenshot öffnen
		lng_scr_sub_AutoEditConfig    = Bilddatei automatisch mit einem Programm öffnen
		lng_scr_RememberSelection     = Auswahl merken
		lng_scr_FileTypeEXE           = Programme (*.exe)
		lng_scr_SelectApplication     = Bitte ein Programm auswählen
		lng_scr_ShootAfterSelecting   = Bildschirmfoto direkt nach Loslassen der linken Maustaste erstellen
		lng_scr_NoOverlappingWindows  = Unterstützung für verdeckte Fenster ausschalten (falls die Bilder immer schwarz sind)
		lng_scr_CatchContextMenu      = 'Aktives Fenster' berücksichtigt sichtbare Kontextmenüs
		lng_scr_DisableTransparency1  = Interaktive Auswahl beschleunigen (Transparenzen teilweise deaktivieren)
		lng_scr_DisableTransparency2  = Interaktive Auswahl beschleunigen (Transparenzen komplett deaktivieren)

		lng_scr_Toolbar               = Werkzeug-Palette
		lng_scr_AutoShowToolbar       = Werkzeug-Palette bei der interaktiven Auswahl automatisch einblenden

		lng_scr_NoGdiPlus             = Um Bildschirmfotos in eine Datei speichern zu können, muss die DLL-Datei GdiPlus.dll verfügbar sein. Sollten Sie diese Datei auf ihrem System finden, kopieren Sie diese bitte in das folgende Verzeichnis:`n%A_ScriptDir%\library.`n`nFalls Sie die Datei nicht finden, erhalten Sie diese z. B. bei www.dll-files.com.

		lng_scr_Dimensions            = Maße
		lng_scr_Left                  = Links
		lng_scr_Top                   = Oben
		lng_scr_Width                 = Breite
		lng_scr_Height                = Höhe
		lng_scr_Options               = Optionen

		lng_scr_SelectFolder          = Ordner wählen...
		lng_scr_TakeScreenShotOnShutDown = Vor jedem Herunterfahren ein Bildschirmfoto schießen

		lng_scr_sub_UploadConfig      = Bilddatei automatisch auf einen FTP-Server laden
		lng_scr_uploadUrl             = FTP Url (Format: ftp://user:pass@host:port/path/)
		lng_scr_afterHttpEnabled      = HTTP Url danach in Zwischenablage (Format: http://host/path/)
		lng_scr_uploadComplete        = Bildschirmfoto fertig hochgeladen
		lng_scr_HTTPUpload            = Bilddatei automatisch zu Imageshack.us laden
		lng_scr_AbloadUpload          = Bilddatei automatisch zu abload.de laden
	}
	Else        ; = other languages (english)
	{
		MenuName                    = %scr_ScriptName% - screen shots
		Description                 = Allows to take shots from the screen with hotkeys or by using the mouse
		lng_scr_ScreenShot            = Screenshot
		lng_scr_Hotkeydefinitions     = Hotkeys
		lng_scr_Monitor               = Complete monitor
		lng_scr_Application           = Active window
		lng_scr_Client                = Client area of active window
		lng_scr_Element               = Window element under mouse cursor
		lng_scr_Interactive           = Interactive selection
		lng_scr_LastInteractive       = Directly last interactive selection

		lng_scr_ButtonAllMonitors     = &All Monitors
		lng_scr_ButtonMonitor         = &Monitor
		lng_scr_ButtonActiveWindow    = Active &window
		lng_scr_ButtonSelection       = &Selection

		lng_scr_captureCursor         = capture mouse cursor

		lng_scr_ScreenshotMode        = Capture mode
		lng_scr_ToClipboard           = Save to clipboard
		lng_scr_ToFile                = Save to file
		lng_scr_ToFileAndClipBoard    = Save to file and clipboard
		lng_scr_Counter               = Counter (\n) begins at
		tooltip_scr_Counter           = This number is increased by one for each new file
		lng_scr_DateFormat            = Date format (\d)
		tooltip_scr_DateFormat        = Date format according to AutoHotkey (e.g. yyyyMMddHHmmss)
		lng_scr_Filesettings          = File settings
		lng_scr_FileNameFormat        = Filename format
		lng_scr_FileName              = Filename
		lng_scr_FormatInfo            = \t = window title
		lng_scr_FileFormat            = File format
		lng_scr_ScreenShotFolder      = Destination folder
		lng_scr_PlaySound             = Acoustic feedback
		lng_scr_Hightlight            = Visual feedback
		lng_scr_Resize                = Size down to
		tooltip_scr_Resize            = Possible entries:`n50`%`n1/2`n640*480`n640*?`n?*640
		lng_scr_Open                  = Open
		lng_scr_Remember              = Remember

		lng_scr_DisableFontSmoothing1 = Turn off font smoothing
		lng_scr_DisableFontSmoothing2 = Only turn off ClearType
		lng_scr_FilenameToClipboard   = Filename of screenshot in clipboard
		lng_scr_DelayProgress         = ScreenShot Delay
		tooltip_scr_Delay             = second delay to let you position the mouse
		lng_scr_Delay                 = second delay
		lng_scr_OpenFolder            = Open destination folder after screenshot
		lng_scr_sub_AutoEditConfig    = Open files automatically with an editor
		lng_scr_RememberSelection     = Remember selection
		lng_scr_FileTypeEXE           = Programs (*.exe)
		lng_scr_SelectApplication     = Please select an application
		lng_scr_ShootAfterSelecting   = Take screenshot directly after releasing the left mouse button
		lng_scr_NoOverlappingWindows  = Disable support for partly hidden windows (if you get black images)
		lng_scr_CatchContextMenu      = 'Active window' includes visible context menus
		lng_scr_DisableTransparency1  = Improve performance of interactive selection (partly disable transparency)
		lng_scr_DisableTransparency2  = Improve performance of interactive selection (fully disable transparency)

		lng_scr_Toolbar               = Tool window
		lng_scr_AutoShowToolbar       = Show tool window automatically at the interactive selection

		lng_scr_NoGdiPlus             = The file GdiPlus.dll is necessary to save screenshots into a file. If you can find it on your system, just copy it to this directory:`n%A_ScriptDir%\library.`n`nIf you can't find such a file, you can download it from www.dll-files.com.

		lng_scr_Dimensions            = Dimensions
		lng_scr_Left                  = Left
		lng_scr_Top                   = Top
		lng_scr_Width                 = Width
		lng_scr_Height                = Height
		lng_scr_Options               = Options

		lng_scr_SelectFolder          = Choose a folder...
		lng_scr_TakeScreenShotOnShutDown = Take a screenshot before shutting down the computer

		lng_scr_sub_UploadConfig      = Upload files automatically to an FTP Server
		lng_scr_uploadUrl             = FTP Url (like ftp://user:pass@host:port/path/)
		lng_scr_afterHttpEnabled      = HTTP Url for clipboard (like http://host/path/)
		lng_scr_uploadComplete        = Screenshot upload complete
		lng_scr_HTTPUpload            = Upload Screenshot to Imageshack.us
		lng_scr_AbloadUpload          = Upload Screenshot to abload.de
	}
	If CustomLanguage <>
		gosub, CustomLanguage

	func_HotkeyRead( "scr_Hotkey_Monitor", ConfigFile , scr_ScriptName, "Hotkey_Monitor", "scr_sub_Hotkey_Monitor", "!PrintScreen", "$")
	func_HotkeyRead( "scr_Hotkey_Application", ConfigFile , scr_ScriptName, "Hotkey_Application", "scr_sub_Hotkey_Application", "+PrintScreen", "$")
	func_HotkeyRead( "scr_Hotkey_Client", ConfigFile , scr_ScriptName, "Hotkey_Client", "scr_sub_Hotkey_Client", "#PrintScreen", "$")
	func_HotkeyRead( "scr_Hotkey_Element", ConfigFile , scr_ScriptName, "Hotkey_Element", "scr_sub_Hotkey_Element", "^PrintScreen", "$")
	func_HotkeyRead( "scr_Hotkey_Interactive", ConfigFile , scr_ScriptName, "Hotkey_Interactive", "scr_sub_Hotkey_Interactive", "PrintScreen", "$")
	func_HotkeyRead( "scr_Hotkey_LastInteractive", ConfigFile , scr_ScriptName, "Hotkey_LastInteractive", "scr_sub_Hotkey_LastInteractive", "<^>!PrintScreen", "$")
	IniRead, scr_captureCursor, %ConfigFile%, %scr_ScriptName%, CaptureCursor, 0
	IniRead, scr_FileFormat, %ConfigFile%, %scr_ScriptName%, FileFormat, png
	If scr_FileFormat not in bmp,png,jpg,gif,tif
		scr_FileFormat = png
	scr_regex = (\||\/|\\|\?|`%|\*|:|"|<|>|`n|`r|`t)
	; " ; end qoute for syntax highlighting

	IniRead, scr_ToFile, %ConfigFile%, %scr_ScriptName%, ToFile, 1
	IniRead, scr_ScreenShotFolder, %ConfigFile%, %scr_ScriptName%, ScreenShotFolder, %A_MyDocuments%
	scr_ScreenShotFolder := RegExReplace(scr_ScreenShotFolder, "\\+$") "\"
	IniRead, scr_Counter, %ConfigFile_ScreenShots%, %scr_ScriptName%, Counter, 001
	IniRead, scr_DateFormat, %ConfigFile%, %scr_ScriptName%, DateFormat, yyyyMMddHHmmss
	IniRead, scr_SoundFile, %ConfigFile%, %scr_ScriptName%, SoundFile, %A_ScriptDir%\extensions\Media\ac'tivAid_Camera.wav
	IniRead, scr_PlaySound, %ConfigFile%, %scr_ScriptName%, PlaySound, 1
	IniRead, scr_Highlight, %ConfigFile%, %scr_ScriptName%, Highlight, 1
	IniRead, scr_Resize, %ConfigFile%, %scr_ScriptName%, Resize, 100`%
	IniRead, scr_AutoEdit, %ConfigFile%, %scr_ScriptName%, AutoEdit, 0
	IniRead, scr_EditApplication, %ConfigFile%, %scr_ScriptName%, EditApplication, %A_Space%
	IniRead, scr_JPGqualitiy, %ConfigFile%, %scr_ScriptName%, JPGquality, 80
	IniRead, scr_sub_ToolBarMinimized, %ConfigFile%, ScreenShots, ToolBarMinimized, 0
	IniRead, scr_DimTransparency, %ConfigFile%, %scr_ScriptName%, DimTransparency, 128
	IniRead, scr_FTPUpload, %ConfigFile%, %scr_ScriptName%, FTPUploadEnabled, 0
	IniRead, scr_uploadUrl, %ConfigFile%, %scr_ScriptName%, FTPUploadUrl, %A_Space%
	IniRead, scr_afterHttp, %ConfigFile%, %scr_ScriptName%, HTTPAfterUpload, %A_Space%
	IniRead, scr_Delay, %ConfigFile%, %scr_ScriptName%, Delay, 0
	if ( scr_Delay = "" )
		scr_Delay := 0

	If scr_Resize =
		scr_Resize = 100`%
	IniRead, scr_FilenameTemplate, %ConfigFile%, %scr_ScriptName%, FileNameTemplate, ScreenShot \n \t
	RegisterAdditionalSetting("scr", "DisableFontSmoothing1", 0)
	RegisterAdditionalSetting("scr", "DisableFontSmoothing2", 0)
	RegisterAdditionalSetting("scr", "DisableTransparency1",0)
	RegisterAdditionalSetting("scr", "DisableTransparency2",0)
	RegisterAdditionalSetting("scr", "FilenameToClipboard", 0)
	RegisterAdditionalSetting("scr", "DelayBeforeScreenShot", 0)
	RegisterAdditionalSetting("scr", "NoOverlappingWindows", 1)
	RegisterAdditionalSetting("scr", "CatchContextMenu", 1)
	RegisterAdditionalSetting("scr", "RememberSelection", 1)
	RegisterAdditionalSetting("scr", "ShootAfterSelecting", 0)
	RegisterAdditionalSetting("scr", "AutoShowToolbar", 1)
	RegisterAdditionalSetting("scr", "OpenFolder", 0)
	RegisterAdditionalSetting("scr", "sub_AutoEditConfig", 0, "Type:SubRoutine")
	RegisterAdditionalSetting("scr", "sub_UploadConfig", 0, "Type:SubRoutine")
	RegisterAdditionalSetting("scr", "HTTPUpload",0)
	RegisterAdditionalSetting("scr", "AbloadUpload",0)
	RegisterAdditionalSetting("scr", "TakeScreenShotOnShutDown",0)
Return

SettingsGui_ScreenShots:
	hGdiPlus := DllCall("LoadLibrary", "str", "gdiplus.dll")
	If (hGdiPlus = 0 AND FileExist(A_ScriptDir "\library\gdiplus.dll"))
		hGdiPlus := DllCall("LoadLibrary", "str", A_ScriptDir "\library\gdiplus.dll")

	Gui, Add, GroupBox, xs+10 ys+10 w370 h150, %lng_scr_Hotkeydefinitions%
	func_HotkeyAddGuiControl( lng_scr_Interactive, "scr_Hotkey_Interactive", "xs+20 yp+18 w180 -Wrap", "", "w165")
	func_HotkeyAddGuiControl( lng_scr_LastInteractive, "scr_Hotkey_LastInteractive", "xs+20 y+5 w180 -Wrap", "", "w165")
	func_HotkeyAddGuiControl( lng_scr_Monitor, "scr_Hotkey_Monitor", "xs+20 y+5 w180 -Wrap", "", "w165")
	func_HotkeyAddGuiControl( lng_scr_Application, "scr_Hotkey_Application", "xs+20 y+5 w180 -Wrap", "", "w165")
	func_HotkeyAddGuiControl( lng_scr_Client, "scr_Hotkey_Client", "xs+20 y+5 w180 -Wrap", "", "w165")
	func_HotkeyAddGuiControl( lng_scr_Element, "scr_Hotkey_Element", "xs+20 y+5 w180 -Wrap", "", "w165")

	Gui, Add, Text, xs+390 ys+28, %lng_scr_Resize%:
	Gui, Add, Edit, x+5 yp-3 R1 -Wrap w80 gsub_CheckIfSettingsChanged vscr_Resize, %scr_Resize%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+390 y+15 Checked%scr_captureCursor% vscr_captureCursor, %lng_scr_captureCursor%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+390 y+5 Checked%scr_PlaySound% vscr_PlaySound, %lng_scr_PlaySound%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs+390 y+5 Checked%scr_Highlight% vscr_Highlight, %lng_scr_Hightlight%
	Gui, Add, DropDownList, -Wrap gsub_CheckIfSettingsChanged xs+390 y+20 w40 lng_scr_Delay vscr_Delay, 0|1|2|4|6|10|15|30
	GuiControl, ChooseString, scr_Delay, %scr_Delay%
	Gui, Add, Text, x+3 yp-3 w130, %lng_scr_Delay%

	Gui, Add, GroupBox, xs+10 ys+160 w550 h110
	If hGdiPlus <> 0
	{
;		Gui, Add, CheckBox, -Wrap gscr_sub_CheckIfSettingsChanged xp+10 yp+0 Check3 Checked%scr_ToFile% vscr_ToFile, %lng_scr_ToFile%
		Gui, Add, DropDownList, -Wrap AltSubmit gscr_sub_CheckIfSettingsChanged xp+10 yp+13 w220 vscr_ToFile, %lng_scr_ToClipboard%|%lng_scr_ToFile%|%lng_scr_ToFileAndClipBoard%
		GuiControl, Choose, scr_ToFile, %scr_ToFile%

		Gui, Add, Text, xs+20 yp+30 vscr_ScreenShotFolder_tmp, %lng_scr_ScreenShotFolder%:
		Gui, Add, Edit, xs+120 yp-3 R1 -Wrap w245 gsub_CheckIfSettingsChanged vscr_ScreenShotFolder, %scr_ScreenShotFolder%
		Gui, Add, Button, x+5 yp+0 -Wrap vscr_ScreenShotFolderButton w130 h21 gscr_sub_SelectFolder, %lng_scr_SelectFolder%
		Gui, Add, Button, x+5 -Wrap h21 w50 gscr_sub_OpenGUIFolder, %lng_scr_Open%

		Gui, Add, Text, xs+20 yp+27 vlng_scr_FileNameFormatText, %lng_scr_FileNameFormat%:
		Gui, Add, Edit, xs+120 yp-3 R1 -Wrap w245 gsub_CheckIfSettingsChanged vscr_FilenameTemplate, %scr_FilenameTemplate%
		Gui, Add, Text, xs+370 yp+3 vscr_FileFormatNumberText, %lng_scr_FileFormat%:
		Gui, Add, DropDownList, gscr_sub_CheckIfSettingsChanged xs+450 yp-3 w50 vscr_FileFormat, bmp|png|jpg|gif|tif
		GuiControl, ChooseString, scr_FileFormat, %scr_FileFormat%
		Gui, Add, Text, x+3 yp+3 vscr_JPGqualitiy_txt, Q:
		Gui, Add, Edit, x+3 yp-3 w40 vscr_JPGqualitiy_1 gsub_CheckIfSettingsChanged
		Gui, Add, UpDown, gsub_CheckIfSettingsChanged w40 Range0-100 vscr_JPGqualitiy, %scr_JPGqualitiy%

		Gui, Add, Text, xs+20 yp+27 vscr_FormatInfo, %lng_scr_FormatInfo%
		Gui, Add, Text, xs+121 yp+0 vscr_CounterText, %lng_scr_Counter%:
		Gui, Add, Edit, x+5 yp-3 R1 -Wrap w50 Number gsub_CheckIfSettingsChanged vscr_Counter, %scr_Counter%
		Gui, Add, Text, x+15 yp+3 vscr_DateFormatText, %lng_scr_DateFormat%:
		Gui, Add, Edit, x+5 yp-3 R1 -Wrap w130 gsub_CheckIfSettingsChanged vscr_DateFormat, %scr_DateFormat%
	}
	Else
	{
		scr_ToFile = 1
		Gui, Add, CheckBox, -Wrap Disabled gscr_sub_CheckIfSettingsChanged xp+10 yp+0 Checked%scr_ToFile% vscr_ToFile, %lng_scr_ToFile%
		Gui, Add, Text, xs+20 yp+22 w520, %lng_scr_NoGdiPlus%
	}

	DllCall("FreeLibrary", "Uint", hGdiPlus)

	Gosub, scr_sub_CheckIfSettingsChanged
Return

Update_ScreenShots:
	IniRead, scr_LastUpdateNumber, %ConfigFile%, ScreenShots, UpdateNumber, 0
	IniRead, scr_ToFile, %ConfigFile%, ScreenShots, ToFile, 1

	If ( scr_LastUpdateNumber < 1 OR (scr_LastUpdateNumber < 2 AND scr_ToFile < 1))
	{
		scr_ToFile++
		If scr_ToFile = 0
			scr_ToFile = 3
		IniWrite, %scr_ToFile%, %ConfigFile%, ScreenShots, ToFile
	}

	IniWrite, 2, %ConfigFile%, ScreenShots, UpdateNumber
Return


; -----------------------------------------------------------------------------

scr_sub_AutoEditConfig:
	Gui, +Disabled
	GuiDefault("ScreenShotsAutoEdit", "+LastFound +Owner" GuiID_activAid)
	Gosub, GuiDefaultFont
	Gui, Add, CheckBox, -Wrap y+5 x10 vscr_AutoEdit Checked%scr_AutoEdit%, %lng_scr_sub_AutoEditConfig%
	Gui, Add, Edit, y+8 x8 w400 R1 -Multi vscr_EditApplication, % scr_EditApplication
	Gui, Add, Button, -Wrap yp+0 x+5 w100 gscr_sub_SelectApp, %lng_Browse%

	Gui, Add, Button, -Wrap x180 w80 Default gscr_sub_SetAutoEdit, %lng_OK%
	Gui, Add, Button, -Wrap yp+0 x+8 w80 gScreenShotsAutoEditGuiClose, %lng_Cancel%
	Gui, Show, AutoSize, %scr_ScriptName% - Editor
Return

scr_sub_UploadConfig:
	Gui, +Disabled
	GuiDefault("ScreenShotsUpload", "+LastFound +Owner" GuiID_activAid)
	Gosub, GuiDefaultFont
	Gui, Add, CheckBox, -Wrap y+5 x10 vscr_FTPUpload Checked%scr_FTPUpload%, %lng_scr_sub_UploadConfig%
	Gui, Add, Text, y+8 x8 w400, %lng_scr_uploadUrl%
	Gui, Add, Edit, y+8 x8 w400 R1 -Multi vscr_uploadUrl, % scr_uploadUrl

	Gui, Add, Text, y+8 x8 w400, %lng_scr_afterHttpEnabled%
	Gui, Add, Edit, y+8 x8 w400 R1 -Multi vscr_afterHttp, % scr_afterHttp

	Gui, Add, Button, -Wrap x180 w80 Default gscr_sub_SetUpload, %lng_OK%
	Gui, Add, Button, -Wrap yp+0 x+8 w80 gScreenShotsUploadGuiClose, %lng_Cancel%
	Gui, Show, AutoSize, %scr_ScriptName% - Editor
Return

scr_sub_SelectApp:
	Gui, +OwnDialogs
	scr_Suspended = %A_IsSuspended%
	If scr_Suspended = 0
		Suspend, On

	FileSelectFile, scr_EditApplication,, %A_Programfiles%, %lng_scr_SelectApplication%, %lng_scr_FileTypeEXE%
	ControlSetText, Edit1, %scr_EditApplication%, %scr_ScriptName% - Editor

	If scr_Suspended = 0
		Suspend, Off
Return

scr_sub_SetAutoEdit:
	Gui, %GuiID_activAid%:-Disabled
	Gui, %GuiID_ScreenShotsAutoEdit%:Submit
	Gosub, ScreenShotsAutoEditGuiClose
	func_SettingsChanged( "ScreenShots" )
Return

ScreenShotsAutoEditGuiEscape:
ScreenShotsAutoEditGuiClose:
	Gui, %GuiID_activAid%:-Disabled
	Gui, %GuiID_ScreenShotsAutoEdit%:Destroy
Return

scr_sub_SetUpload:
	Gui, %GuiID_activAid%:-Disabled
	Gui, %GuiID_ScreenShotsUpload%:Submit
	Gosub, ScreenShotsUploadGuiClose
	func_SettingsChanged( "ScreenShots" )
Return

ScreenShotsUploadGuiEscape:
ScreenShotsUploadGuiClose:
	Gui, %GuiID_activAid%:-Disabled
	Gui, %GuiID_ScreenShotsUpload%:Destroy
Return


; -----------------------------------------------------------------------------

scr_sub_SelectFolder:
	Gui %GuiID_activAid%:+OwnDialogs
	GuiControlGet, scr_ScreenShotFolder_tmp,,scr_ScreenShotFolder
	FileSelectFolder,scr_ScreenShotFolder_tmp,*%scr_ScreenShotFolder_tmp%,3
	scr_ScreenShotFolder_tmp := RegExReplace(scr_ScreenShotFolder_tmp, "\\$")
	scr_ScreenShotFolder_tmp := scr_ScreenShotFolder_tmp "\"
	If (scr_ScreenShotFolder_tmp != "\")
		GuiControl, , scr_ScreenShotFolder, %scr_ScreenShotFolder_tmp%
Return

scr_sub_SelectToolBarFolder:
	Gosub, scr_sub_DisableTimerAndButtons
	Gui %GuiID_ScreenShotsToolBar%:+OwnDialogs
	GuiControlGet, scr_ScreenShotFolder_tmp2,,scr_ScreenShotFolder_tmp
	FileSelectFolder,scr_ScreenShotFolder_tmp2,*%scr_ScreenShotFolder_tmp2%,3
	scr_ScreenShotFolder_tmp2 := RegExReplace(scr_ScreenShotFolder_tmp2, "\\$")
	scr_ScreenShotFolder_tmp2 := scr_ScreenShotFolder_tmp2 "\"
	If (scr_ScreenShotFolder_tmp2 != "\")
		GuiControl,%GuiID_ScreenShotsToolBar%: , scr_ScreenShotFolder_tmp, %scr_ScreenShotFolder_tmp2%
	Gosub, scr_sub_EnableTimerAndButtons
Return

scr_sub_OpenGUIFolder:
	GuiControlGet, scr_ScreenShotFolder_tmp, ,scr_ScreenShotFolder
	Run, %scr_ScreenShotFolder_tmp%,,UseErrorlevel
Return

SaveSettings_ScreenShots:
	func_HotkeyWrite( "scr_Hotkey_Monitor", ConfigFile , scr_ScriptName, "Hotkey_Monitor" )
	func_HotkeyWrite( "scr_Hotkey_Application", ConfigFile , scr_ScriptName, "Hotkey_Application" )
	func_HotkeyWrite( "scr_Hotkey_Client", ConfigFile , scr_ScriptName, "Hotkey_Client" )
	func_HotkeyWrite( "scr_Hotkey_Element", ConfigFile , scr_ScriptName, "Hotkey_Element" )
	func_HotkeyWrite( "scr_Hotkey_Interactive", ConfigFile , scr_ScriptName, "Hotkey_Interactive" )
	func_HotkeyWrite( "scr_Hotkey_LastInteractive", ConfigFile , scr_ScriptName, "Hotkey_LastInteractive" )
	Gosub, scr_SaveIniSettings
Return

scr_SaveIniSettings:
	SaveAdditionalSettings("scr")
	IniWrite, %scr_captureCursor%, %ConfigFile%, %scr_ScriptName%, CaptureCursor
	IniWrite, %scr_ToFile%, %ConfigFile%, %scr_ScriptName%, ToFile
	IniWrite, %scr_FileFormat%, %ConfigFile%, %scr_ScriptName%, FileFormat
	scr_ScreenShotFolder := RegExReplace(scr_ScreenShotFolder, "\\+$") "\"
	IniWrite, %scr_ScreenShotFolder%, %ConfigFile%, %scr_ScriptName%, ScreenShotFolder
	IniWrite, %scr_DateFormat%, %ConfigFile%, %scr_ScriptName%, DateFormat
	IniWrite, %scr_Counter%, %ConfigFile_ScreenShots%, %scr_ScriptName%, Counter
	IniWrite, %scr_SoundFile%, %ConfigFile%, %scr_ScriptName%, SoundFile
	IniWrite, %scr_PlaySound%, %ConfigFile%, %scr_ScriptName%, PlaySound
	IniWrite, %scr_Highlight%, %ConfigFile%, %scr_ScriptName%, Highlight
	IniWrite, %scr_Resize%, %ConfigFile%, %scr_ScriptName%, Resize
	IniWrite, %scr_FilenameTemplate%, %ConfigFile%, %scr_ScriptName%, FileNameTemplate
	IniWrite, %scr_Delay%, %ConfigFile%, %scr_ScriptName%, Delay
	IniWrite, %scr_AutoEdit%, %ConfigFile%, %scr_ScriptName%, AutoEdit
	IniWrite, %scr_EditApplication%, %ConfigFile%, %scr_ScriptName%, EditApplication
	IniWrite, %scr_DimTransparency%, %ConfigFile%, %scr_ScriptName%, DimTransparency
	IniWrite, %scr_JPGqualitiy%, %ConfigFile%, %scr_ScriptName%, JPGquality
	IniWrite, %scr_FTPUpload%, %ConfigFile%, %scr_ScriptName%, FTPUploadEnabled
	IniWrite, %scr_uploadUrl%, %ConfigFile%, %scr_ScriptName%, FTPUploadUrl
	IniWrite, %scr_afterHttp%, %ConfigFile%, %scr_ScriptName%, HTTPAfterUpload
Return

scr_sub_CheckIfSettingsChanged:
	Gosub, sub_CheckIfSettingsChanged
	GuiControlGet, scr_ToFile_tmp, , scr_ToFile
	GuiControlGet, scr_FileFormat_tmp, , scr_FileFormat
	If scr_FileFormat_tmp = jpg
	{
		GuiControl, Show, scr_JPGqualitiy
		GuiControl, Show, scr_JPGqualitiy_txt
		GuiControl, Show, scr_JPGqualitiy_1
	}
	Else
	{
		GuiControl, Hide, scr_JPGqualitiy
		GuiControl, Hide, scr_JPGqualitiy_txt
		GuiControl, Hide, scr_JPGqualitiy_1
	}
	scr_Group1 = lng_scr_FileNameFormatText,scr_FileFormatNumberText,scr_FileFormat,scr_ScreenShotFolder_tmp,scr_ScreenShotFolder,scr_CounterText,scr_Counter,scr_DateFormatText,scr_DateFormat,scr_FormatInfo,scr_FilenameTemplate,scr_ScreenShotFolderButton,scr_JPGqualitiy
	If scr_ToFile_tmp > 1
	{
		Loop, Parse, scr_Group1, `,
			GuiControl, Enable, %A_LoopField%
	}
	Else
	{
		Loop, Parse, scr_Group1, `,
			GuiControl, Disable, %A_LoopField%
	}
Return

CancelSettings_ScreenShots:
Return

DoEnable_ScreenShots:
	func_HotkeyEnable("scr_Hotkey_Monitor")
	func_HotkeyEnable("scr_Hotkey_Application")
	func_HotkeyEnable("scr_Hotkey_Client")
	func_HotkeyEnable("scr_Hotkey_Element")
	func_HotkeyEnable("scr_Hotkey_Interactive")
	func_HotkeyEnable("scr_Hotkey_LastInteractive")
	IfExist, %A_ScriptDir%\Extensions\Media\ac'tivAid_ScreenShots_Cross.cur
		scr_hCursorCrossIDC := DllCall("LoadCursorFromFile", Str, A_ScriptDir "\Extensions\Media\ac'tivAid_ScreenShots_Cross.cur")
	Else IfExist, %A_WinDir%\cursors\cross_rl.cur
		scr_hCursorCrossIDC := DllCall("LoadCursorFromFile", Str, A_WinDir "\cursors\cross_rl.cur")
	Else
		scr_hCursorCrossIDC := DllCall("LoadCursor","UInt",NULL, "Int", IDC_CROSS)
	scr_hCursorArrowIDC := DllCall("LoadCursor","UInt",NULL, "Int", IDC_ARROW)
	scr_hCursorSizeAllIDC := DllCall("LoadCursor","UInt",NULL, "Int", IDC_SIZEALL)
	scr_hCursorHandIDC := DllCall("LoadCursor","UInt",NULL, "Int", IDC_HAND)
	scr_hCursorCross := DllCall("CopyImage", "UInt", scr_hCursorCrossIDC, "uint",2, "int",0, "int",0, "uint",0)
	scr_hCursorArrow := DllCall("CopyImage", "UInt", scr_hCursorArrowIDC, "uint",2, "int",0, "int",0, "uint",0)
	scr_hCursorSizeAll := DllCall("CopyImage", "UInt", scr_hCursorSizeAllIDC, "uint",2, "int",0, "int",0, "uint",0)
	scr_hCursorHand := DllCall("CopyImage", "UInt", scr_hCursorHandIDC, "uint",2, "int",0, "int",0, "uint",0)

	RegisterAction("scr_HotkeyInteractive",lng_scr_Interactive,"scr_sub_Hotkey_Interactive")
	RegisterAction("scr_HotkeyLastInteractive",lng_scr_LastInteractive,"scr_sub_Hotkey_LastInteractive")
	RegisterAction("scr_HotkeyMonitor",lng_scr_Monitor,"scr_sub_Hotkey_Monitor")
	RegisterAction("scr_HotkeyApplication",lng_scr_Application,"scr_sub_Hotkey_Application")
	RegisterAction("scr_HotkeyClient",lng_scr_Client,"scr_sub_Hotkey_Client")
	RegisterAction("scr_HotkeyElement",lng_scr_Element,"scr_sub_Hotkey_Element")
	Return

	DoDisable_ScreenShots:
	func_Hotkeydisable("scr_Hotkey_Monitor")
	func_Hotkeydisable("scr_Hotkey_Application")
	func_Hotkeydisable("scr_Hotkey_Client")
	func_Hotkeydisable("scr_Hotkey_Element")
	func_Hotkeydisable("scr_Hotkey_Interactive")
	func_Hotkeydisable("scr_Hotkey_LastInteractive")
	DllCall("DestroyCursor","Uint",scr_hCursorCrossIDC)
	DllCall("DestroyCursor","Uint",scr_hCursorArrowIDC)
	DllCall("DestroyCursor","Uint",scr_hCursorHandIDC)
	DllCall("DestroyCursor","Uint",scr_hCursorSizeAllIDC)
	DllCall("DestroyCursor","Uint",scr_hCursorCross)
	DllCall("DestroyCursor","Uint",scr_hCursorArrow)
	DllCall("DestroyCursor","Uint",scr_hCursorHand)
	DllCall("DestroyCursor","Uint",scr_hCursorSizeAll)

	unRegisterAction("scr_HotkeyInteractive")
	unRegisterAction("scr_HotkeyLastInteractive")
	unRegisterAction("scr_HotkeyMonitor")
	unRegisterAction("scr_HotkeyApplication")
	unRegisterAction("scr_HotkeyClient")
	unRegisterAction("scr_HotkeyElement")
Return

DefaultSettings_ScreenShots:
Return

OnExitAndReload_ScreenShots:
	If GuiID_ScreenShotsHidden <>
		Gosub, ScreenShotsFrameGuiClose
Return

OnShutDown_ScreenShots:
	If (Enable_ScreenShots = 1 AND scr_TakeScreenShotOnShutDown = 1)
		Gosub, scr_sub_Hotkey_Monitor
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

sub_Hotkey_ScreenShots:

Return

scr_sub_Hotkey_Monitor:
	scr_CustomFileName =
	Gosub, scr_sub_SubmitToolbar
	Gui, %GuiID_ScreenShotsHidden%:+LastFoundExist
	IfWinExist
		Gosub, ScreenShotsDimGuiClose
	scr_func_setFilename()
	Gosub, scr_sub_DisableFontsmoothing
	scr_func_CaptureScreen(0,scr_captureCursor,scr_Resize,scr_filename,scr_Highlight, (scr_PlaySound) ? scr_SoundFile : "" )
	Gosub, scr_sub_ReEnableFontsmoothing
	Gosub, scr_sub_OpenFolder
	Gosub, scr_sub_AutoEdit
Return

scr_sub_Hotkey_ActualMonitor:
	scr_CustomFileName =
	Gosub, scr_sub_SubmitToolbar
	Gui, %GuiID_ScreenShotsHidden%:+LastFoundExist
	IfWinExist
		Gosub, ScreenShotsDimGuiClose
	scr_func_setFilename()
	Gosub, scr_sub_DisableFontsmoothing

	scr_Monitor := func_GetMonitorNumber()
	scr_func_CaptureScreen(WorkArea%scr_Monitor%Left "," WorkArea%scr_Monitor%Top "," WorkArea%scr_Monitor%Width "," WorkArea%scr_Monitor%Height ,scr_captureCursor,scr_Resize,scr_filename,scr_Highlight, (scr_PlaySound) ? scr_SoundFile : "" )
	Gosub, scr_sub_ReEnableFontsmoothing
	Gosub, scr_sub_OpenFolder
	Gosub, scr_sub_AutoEdit
Return

scr_sub_Hotkey_Application:
	scr_CustomFileName =
	Gosub, scr_sub_SubmitToolbar
	Gui, %GuiID_ScreenShotsHidden%:+LastFoundExist
	IfWinExist
		Gosub, ScreenShotsDimGuiClose
	scr_func_setFilename()
	Gosub, scr_sub_DisableFontsmoothing
	scr_func_CaptureScreen("A",scr_captureCursor,scr_Resize,scr_filename,scr_Highlight, (scr_PlaySound) ? scr_SoundFile : "" )
	Gosub, scr_sub_ReEnableFontsmoothing
	Gosub, scr_sub_RefreshWindows
	Gosub, scr_sub_OpenFolder
	Gosub, scr_sub_AutoEdit
Return

scr_sub_Hotkey_Client:
	scr_CustomFileName =
	Gosub, scr_sub_SubmitToolbar
	Gui, %GuiID_ScreenShotsHidden%:+LastFoundExist
	IfWinExist
		Gosub, ScreenShotsDimGuiClose
	scr_func_setFilename()
	Gosub, scr_sub_DisableFontsmoothing
	scr_func_CaptureScreen(2,scr_captureCursor,scr_Resize,scr_filename,scr_Highlight, (scr_PlaySound) ? scr_SoundFile : "" )
	Gosub, scr_sub_ReEnableFontsmoothing
	Gosub, scr_sub_OpenFolder
	Gosub, scr_sub_AutoEdit
Return

scr_sub_Hotkey_Element:
	Gui, %GuiID_ScreenShotsHidden%:+LastFoundExist
	Gosub, scr_sub_SubmitToolbar
	IfWinExist
		Gosub, ScreenShotsDimGuiClose
	MouseGetPos, , , scr_WhichWindow, scr_WhichControl
	WinGetPos,scr_xw, scr_yw, scr_w, scr_h, ahk_id %scr_WhichWindow%
	if(scr_WhichControl!="")
	{
		ControlGetPos, scr_xc, scr_yc, scr_w, scr_h, %scr_WhichControl%, ahk_id %scr_WhichWindow%
		scr_x := scr_xw + scr_xc
		scr_y := scr_yw + scr_yc

		WinGetTitle,scr_WindowTitle,ahk_id  %scr_WhichWindow%
		scr_func_setFilename(False)
		scr_coords := scr_x ", " scr_y ", " scr_w ", " scr_h
		Gosub, scr_sub_DisableFontsmoothing
		scr_func_CaptureScreen(scr_coords,scr_captureCursor, scr_Resize, scr_filename,scr_Highlight, (scr_PlaySound) ? scr_SoundFile : "" )
		Gosub, scr_sub_ReEnableFontsmoothing
		Gosub, scr_sub_OpenFolder
		Gosub, scr_sub_AutoEdit
	}
	else ; no element found
	{
		WinGetTitle,scr_WindowTitle,ahk_id  %scr_WhichWindow%
		scr_func_setFilename(scr_WindowTitle)
		Gosub, scr_sub_DisableFontsmoothing
		scr_func_CaptureScreen("ahk_id " scr_WhichWindow,scr_captureCursor,scr_Resize,scr_filename,scr_Highlight, (scr_PlaySound) ? scr_SoundFile : "" )
		Gosub, scr_sub_ReEnableFontsmoothing
		Gosub, scr_sub_OpenFolder
		Gosub, scr_sub_AutoEdit
;			scr_x := scr_xw
;			scr_y := scr_yw
	}
Return

scr_UploadFinished:
	if scr_afterHttp <>
	{
		Clipboard := scr_tmp_afterHttp
		BalloonTip(scr_ScriptName, lng_scr_uploadComplete ":`n" scr_tmp_afterHttp, "Info", 0, -1, 3)
	}
return

scr_HTTPUploadFinished:
	FileRead, scr_tmp_httpUploadBody, %SettingsDir%\imageshack_tmp.html
	FileDelete, %SettingsDir%\imageshack_tmp.html

	scr_needle := "<image_link>(.*)</image_link>"
	scr_FoundPos := RegExMatch(scr_tmp_httpUploadBody,scr_needle,scr_tmp_upResult)

	if scr_FoundPos
	{
		Clipboard := scr_tmp_upResult1
		BalloonTip(scr_ScriptName, lng_scr_uploadComplete ":`n" scr_tmp_upResult1, "Info", 0, -1, 3)
	}

return

scr_AbloadUploadFinished:
	FileRead, scr_tmp_AbloadUploadBody, %SettingsDir%\abload_tmp.html
	FileDelete, %SettingsDir%\abload_tmp.html

	Loop
	{
		scr_needle := "class=""xlinktext"".*value=""(.*)"""
		scr_FoundPos := RegExMatch(scr_tmp_AbloadUploadBody,scr_needle,scr_tmp_upResult)

		if scr_tmp_upResult =
			break

		scr_results%A_Index% = %scr_tmp_upResult1%
		scr_resultList = %scr_ResultList%%scr_tmp_upResult1%`n
		StringTrimLeft, scr_tmp_AbloadUploadBody, scr_tmp_AbloadUploadBody, %scr_foundPos%
	}

	if scr_results2 !=
	{
		Clipboard := scr_results2
		BalloonTip(scr_ScriptName, lng_scr_uploadComplete ":`n" scr_results2, "Info", 0, -1, 3)
	}
return


scr_sub_AutoEdit:
	If (scr_FTPUpload = 1 AND FileExist(scr_Filename) AND scr_ToFile > 1 AND scr_uploadUrl != "")
	{
		SplitPath, scr_Filename, scr_tmp_targetFilename

		;check scr_uploadUrl for slash at the end
		scr_tmp_uploadUrl = %scr_uploadUrl%%scr_tmp_targetFilename%
		scr_tmp_afterHttp = %scr_afterHttp%%scr_tmp_targetFilename%

		scr_tmp_upload := lc_addUpload(scr_tmp_uploadUrl,scr_Filename,ScriptTitle,"scr_UploadFinished")
		lc_addToQueue(scr_tmp_upload)
	}

	If (scr_HTTPUpload = 1 AND FileExist(scr_Filename) AND scr_ToFile > 1)
	{
		SplitPath, scr_Filename, scr_tmp_targetFilename

		;check scr_uploadUrl for slash at the end
		;scr_tmp_afterHttp = %scr_afterHttp%%scr_tmp_targetFilename%

		scr_tmp_HTTPuploadUrl = http://www.imageshack.us/index.php

		scr_tmp_HTTPupload := lc_addHTTPMultiPartPost(scr_tmp_HTTPuploadUrl,ScriptTitle,"scr_HTTPUploadFinished")
		lc_setHeaders(scr_tmp_HTTPupload,"Expect:")
		lc_setLong(scr_tmp_HTTPupload, "CURLOPT_NOBODY", 0)
		lc_download(scr_tmp_HTTPupload, SettingsDir "\imageshack_tmp.html")
		lc_addPostField(scr_tmp_HTTPupload,"fileupload",scr_Filename)
		lc_addPostField(scr_tmp_HTTPupload,"xml","yes")
		lc_sendPostFields(scr_tmp_HTTPupload)
		lc_addToQueue(scr_tmp_HTTPupload)
	}

	If (scr_AbloadUpload = 1 AND FileExist(scr_Filename) AND scr_ToFile > 1)
	{
		SplitPath, scr_Filename, scr_tmp_targetFilename

		;check scr_uploadUrl for slash at the end
		;scr_tmp_afterHttp = %scr_afterHttp%%scr_tmp_targetFilename%

		scr_tmp_AbloadUploadUrl = http://www.abload.de/xuploaded.php

		scr_tmp_AbloadUpload := lc_addHTTPMultiPartPost(scr_tmp_AbloadUploadUrl,ScriptTitle,"scr_AbloadUploadFinished")
		lc_setHeaders(scr_tmp_AbloadUpload,"Expect:")
		lc_setLong(scr_tmp_AbloadUpload, "CURLOPT_NOBODY", 0)
		lc_download(scr_tmp_AbloadUpload, SettingsDir "\abload_tmp.html")

		lc_addPostField(scr_tmp_AbloadUpload,"xupload1file",scr_Filename)
		lc_addPostField(scr_tmp_AbloadUpload,"resize","no-resize")
		lc_addPostField(scr_tmp_AbloadUpload,"gallery","none")
		lc_sendPostFields(scr_tmp_AbloadUpload)
		lc_addToQueue(scr_tmp_AbloadUpload)
	}

	If (scr_AutoEdit = 1 AND FileExist(scr_Filename) AND scr_ToFile > 1)
	{
		If scr_EditApplication =
			Run, %scr_Filename%,,UseErrorlevel
		Else
		{
			SplitPath, scr_EditApplication,,,scr_EditApplicationExtension

			if scr_EditApplicationExtension in ahk
				Run, %A_AhkPath% "%scr_EditApplication%" "%scr_Filename%",,UseErrorlevel

			if scr_EditApplicationExtension in exe,bat,com,cmd
				Run, % func_Deref(scr_EditApplication) " """ scr_Filename """",,UseErrorlevel
		}

		If ErrorLevel = ERROR
			func_GetErrorMessage( A_LastError, scr_ScriptName, func_Deref(scr_EditApplication) " """ scr_Filename """`n`n" )
	}
Return

scr_sub_OpenFolder:
	If (scr_FileName <> 0 AND scr_OpenFolder = 1 AND scr_ToFile > 1)
	{
		Loop, 20
		{
			IfExist, %scr_Filename%
				Break
			Sleep, 20
		}
		Run, %FileBrowserSelect% "%scr_Filename%",,UseErrorlevel
	}
Return

scr_sub_Hotkey_Interactive:
	If (scr_ProgressVisible = 1 OR LoadingFinished = "")
		Return
	Critical

	scr_CustomFileName =
	Gui, %GuiID_ScreenShotsHidden%:+LastFoundExist
	IfWinExist
		Goto, ScreenShotsFrameGuiClose

	If (scr_DisableTransparency1 = 1 OR scr_DisableTransparency2 = 1)
	{
		FileDelete, %A_Temp%\__aad_scr_tmpShot.bmp
		scr_func_CaptureScreen(0, scr_captureCursor, "", A_Temp "\__aad_scr_tmpShot.bmp", 0)
	}
	DetectHiddenWindows, Off
;	WinGet, scr_WindowList, List
;	scr_Index = 0
;	Loop, %scr_WindowList%
;	{
;		WinGet, scr_MinMax, MimMax, % "ahk_id " scr_WindowList%A_Index%
;		If scr_MinMax = -1
;			continue
;		scr_Index++
;		WinGetPos, scr_WindowX%A_Index%, scr_WindowY%A_Index%, scr_WindowW%A_Index%, scr_WindoH%A_Index%, % "ahk_id " scr_WindowList%A_Index%
;	}
	SetWinDelay, %scr_WinDelay%
	WinGet, scr_LastActiveApp, ID, A

	Gosub, scr_sub_DisableFontsmoothing

	If (scr_DisableTransparency2 = 0 AND scr_DisableTransparency1 = 0)
	{
		scr_HiddenID := GuiDefault("ScreenShotsHidden","+AlwaysOnTop -Caption -Border +ToolWindow -Resize +Disabled")
		Gui, Color, FFFFFF
;		Gui, Add, Picture, gscr_TakeScreenshot vscr_Pic w%MonitorAreaWidth% h%MonitorAreaHeight% x%MonitorAreaLeft% y%MonitorAreaTop% ; , %A_Temp%\__aad_scr_tmpShot.bmp
		Gui, Add, Button, gScreenShotsHiddenGuiOk x-20 y-20 w1 h1 Default, OK
		WinSet,Transparent,1
		Gui, Show, w%MonitorAreaWidth% h%MonitorAreaHeight% x%MonitorAreaLeft% y%MonitorAreaTop%,aadScreenShots
	}
	Else
	{
		scr_HiddenID := GuiDefault("ScreenShotsHidden","+AlwaysOnTop -Caption -Border +ToolWindow -Resize +Disabled")
		scr_DimID := scr_HiddenID
		Gui, Add, Picture, AltSubmit gscr_TakeScreenshot vscr_Pic w%MonitorAreaWidth% h%MonitorAreaHeight% x%MonitorAreaLeft% y%MonitorAreaTop%, %A_Temp%\__aad_scr_tmpShot.bmp
		Gui, Add, Button, gScreenShotsHiddenGuiOk x-20 y-20 w1 h1 Default, OK
		Gui, Show, w%MonitorAreaWidth% h%MonitorAreaHeight% x%MonitorAreaLeft% y%MonitorAreaTop%,aadScreenShots
	}

	If (scr_RememberSelection = 1 AND rr_Ruler <> "ON")
	{
		IniRead, scr_SelectionX1, %ConfigFile%, %scr_ScriptName%, SelectionX1, 0
		IniRead, scr_SelectionY1, %ConfigFile%, %scr_ScriptName%, SelectionY1, 0
		IniRead, scr_SelectionX2, %ConfigFile%, %scr_ScriptName%, SelectionX2, 0
		IniRead, scr_SelectionY2, %ConfigFile%, %scr_ScriptName%, SelectionY2, 0
		scr_SelectionRegionX1 := scr_SelectionX1+(0-MonitorAreaLeft)
		scr_SelectionRegionY1 := scr_SelectionY1+(0-MonitorAreaTop)
		scr_SelectionRegionX2 := scr_SelectionX2+(0-MonitorAreaLeft)
		scr_SelectionRegionY2 := scr_SelectionY2+(0-MonitorAreaTop)
	}
	Else
	{
		scr_SelectionX1 = 0
		scr_SelectionY1 = 0
		scr_SelectionX2 = 0
		scr_SelectionY2 = 0
	}

	If (rr_Ruler = "On")
	{
		If (rr_showStart = 1)
		{
			If (rr_StartX > rr_RulerX) {
				rr_upperLeftX := rr_RulerX
				rr_lowerRightX := rr_StartX
			} Else {
				rr_upperLeftX := rr_StartX
				rr_lowerRightX := rr_RulerX
			}
			If (rr_StartY > rr_RulerY) {
				rr_upperLeftY := rr_RulerY
				rr_lowerRightY := rr_StartY
			} Else {
				rr_upperLeftY := rr_StartY
				rr_lowerRightY := rr_RulerY
			}
			scr_SelectionX1 := rr_upperLeftX
			scr_SelectionY1 := rr_upperLeftY
			scr_SelectionX2 := rr_lowerRightX+1
			scr_SelectionY2 := rr_lowerRightY+1

			scr_SelectionRegionX1 := scr_SelectionX1+(0-MonitorAreaLeft)
			scr_SelectionRegionY1 := scr_SelectionY1+(0-MonitorAreaTop)
			scr_SelectionRegionX2 := scr_SelectionX2+(0-MonitorAreaLeft)
			scr_SelectionRegionY2 := scr_SelectionY2+(0-MonitorAreaTop)

;			ToolTip ,,,,4 ; Tooltip ausschalten, damit es nicht im Screenshot sichtbar ist

			WinHide, ScreenRulerX
			WinHide, ScreenRulerY
			WinHide, ScreenRulerSX
			WinHide, ScreenRulerSY
		}
		Gosub, sub_Hotkey_ReadingRuler%A_EmptyVar%
	}
	If scr_DisableTransparency2 = 0
	{
		scr_DimID := GuiDefault("ScreenShotsDim","+AlwaysOnTop -Caption -Border +ToolWindow -Resize +Disabled")
		Gui, Color, 000000
		Gui, Add, Button, gScreenShotsDimGuiOk x-20 y-20 w1 h1 Default, OK
		WinSet, Transparent, %scr_DimTransparency%
		WinSet, Region, 0-0 %MonitorAreaWidth%-0 %MonitorAreaWidth%-%MonitorAreaHeight% 0-%MonitorAreaHeight% 0-0 %scr_SelectionRegionX1%-%scr_SelectionRegionY1% %scr_SelectionRegionX2%-%scr_SelectionRegionY1% %scr_SelectionRegionX2%-%scr_SelectionRegionY2% %scr_SelectionRegionX1%-%scr_SelectionRegionY2% %scr_SelectionRegionX1%-%scr_SelectionRegionY1%, ahk_id %scr_DimID%
		Gui, Show, w%MonitorAreaWidth% h%MonitorAreaHeight% x%MonitorAreaLeft% y%MonitorAreaTop%, aadScreenShots
	}

	scr_SelectionW := Abs(scr_SelectionX2-scr_SelectionX1)
	scr_SelectionH := Abs(scr_SelectionY2-scr_SelectionY1)

	scr_FrameID := GuiDefault("ScreenShotsFrame","+AlwaysOnTop -Caption +Resize +ToolWindow -Border +MaxSize64000x64000 +Theme")
	Gui, Font, s14 c000000 bold, MS Sans Serif
	Gui, Add, CheckBox, x3 y3 +0x400 w%scr_SelectionW% R2 vscr_FrameInfo Checked0 Hidden
	Gosub, GuiDefaultFont
;	Gui, Add, Edit, % "x" scr_SelectionW-65 " y" scr_SelectionH-25 " w60 vscr_Resize", %scr_Resize%
	Gui, Add, Button, % "x" scr_SelectionW-105 " y" scr_SelectionH-25 " gscr_sub_Toolbar w100 vscr_ShowToolBar", %lng_scr_Toolbar%
	Gui, Color, f1f1f1
	WinSet, TransColor, f1f1f1
	Gui, Add, Button, vScreenShotsFrameGuiOk gScreenShotsFrameGuiOk x-20 y-20 w1 h1 Default, OK
	func_AddMessage(0x100,"scr_sub_MoveWithKeys")
	func_AddMessage(0x101,"GuiTooltipKey")
	func_AddMessage(0x200, "GuiTooltip")
	func_AddMessage(0x202, "GuiTooltipKey")
	func_AddMessage(0x6, "RemoveGuiTooltip")

	Gosub, scr_sub_EnableTimerAndButtons

	Gosub, scr_sub_GetFrameBounds

	If scr_AutoShowToolbar = 1
		Gosub, scr_sub_Toolbar

	scr_HelperID := GuiDefault("ScreenShotsHelper","+AlwaysOnTop -Caption -Border +ToolWindow -Resize -0x40000")
	Gui, Add, Button, gScreenShotsDimGuiOk x-20 y-20 w1 h1 Default, OK
	Gui, Show, w0 h0 x0 y0,aadScreenShots

Return

scr_sub_DisableTimerAndButtons:
	SetTimer, scr_tim_MouseWatch, Off
	Hotkey, IfWinExist, ahk_id %scr_FrameID%
	Hotkey, $~*LButton, scr_LButton, Off
	Hotkey, $~*LButton Up, scr_LButtonUp, Off
	Hotkey, IfWinExist, ahk_id %scr_DimID%
	Hotkey, $~*LButton, scr_LButton, Off
	Hotkey, $~*LButton Up, scr_LButtonUp, Off
	Hotkey, IfWinExist, ahk_id %scr_HiddenID%
	Hotkey, $~*LButton, scr_LButton, Off
	Hotkey, $~*LButton Up, scr_LButtonUp, Off
	Hotkey, IfWinExist, ahk_id %scr_HiddenID%
	Hotkey, F1, scr_sub_Toolbar, Off
	Hotkey, IfWinExist
	Hotkey, LButton & RButton, On, UseErrorLevel
	Hotkey, LButton & MButton, On, UseErrorLevel
Return


scr_sub_EnableTimerAndButtons:
	SetTimer, scr_tim_MouseWatch, 20
	Hotkey, IfWinExist, ahk_id %scr_FrameID%
	Hotkey, $~*LButton, scr_LButton
	Hotkey, $~*LButton Up, scr_LButtonUp
	Hotkey, IfWinExist, ahk_id %scr_DimID%
	Hotkey, $~*LButton, scr_LButton
	Hotkey, $~*LButton Up, scr_LButtonUp
	Hotkey, IfWinExist, ahk_id %scr_HiddenID%
	Hotkey, $~*LButton, scr_LButton
	Hotkey, $~*LButton Up, scr_LButtonUp
	Hotkey, IfWinExist, ahk_id %scr_HiddenID%
	Hotkey, F1, scr_sub_Toolbar
	Hotkey, IfWinExist
	Hotkey, LButton & RButton, Off, UseErrorLevel
	Hotkey, LButton & MButton, Off, UseErrorLevel
Return

scr_sub_Toolbar:
	If scr_ToolbarID <>
	{
		DetectHiddenWindows, Off
		IfWinExist, ahk_id %scr_ToolbarID%
			Gosub, ScreenShotsToolBarGuiClose
		Else
			Gui, %GuiID_ScreenShotsToolBar%:Show
		SetTimer, scr_tim_MouseWatch, On
		Return
	}
	scr_ToolbarID := GuiDefault("ScreenShotsToolBar","+AlwaysOnTop +ToolWindow -Resize")

	IniRead, scr_ToolBarX, %ConfigFile%, ScreenShots, ToolBarX
	IniRead, scr_ToolBarY, %ConfigFile%, ScreenShots, ToolBarY

	If scr_ToolBarX = ERROR
		scr_ToolBarX =
	Else
	{
		If (scr_ToolBarX < MonitorAreaLeft)
			scr_ToolBarX := MonitorAreaLeft
		If (scr_ToolBarX+480+BorderHeightToolWindow*2 > MonitorAreaRight)
			scr_ToolBarX := MonitorAreaRight-(480+BorderHeightToolWindow*2)
		scr_ToolBarX = x%scr_ToolBarX%
	}
	If scr_ToolBarY = ERROR
		scr_ToolBarY =
	Else
	{
		If (scr_ToolBarY < MonitorAreaTop)
			scr_ToolBarY := MonitorAreaTop
		If (scr_ToolBarY+60+BorderHeightToolWindow*2+SmallCaptionHeight > MonitorAreaBottom)
			scr_ToolBarY := MonitorAreaBottom-(60+BorderHeightToolWindow*2+SmallCaptionHeight)
		scr_ToolBarY = y%scr_ToolBarY%
	}

	Gosub, GuiDefaultFont

	Gui, Add, GroupBox, x10 Section y7 w200 h120 vscr_ToolBarGroup1, %lng_scr_Dimensions%

	Gui, Add, Text, xs10 ys20 w30 vscr_ToolBarText1, %lng_scr_Left%:
	Gui, Add, Edit, x+5 yp-3 w50 vscr_ToolBarEdit1 -Wrap gscr_sub_ManuelResize
	Gui, Add, UpDown, gscr_sub_ManuelResize Range-32767-32767 +0x80 vscr_SelectionX1, %scr_SelectionX1%
	Gui, Add, Text, x+10 yp+3 w30 vscr_ToolBarText2, %lng_scr_Top%:
	Gui, Add, Edit, x+5 yp-3 w50 vscr_ToolBarEdit2 -Wrap gscr_sub_ManuelResize
	Gui, Add, UpDown, gscr_sub_ManuelResize Range-32767-32767 +0x80 vscr_SelectionY1, %scr_SelectionY1%
	Gui, Add, Text, xs10 y+5 w30 vscr_ToolBarText3, %lng_scr_Width%:
	Gui, Add, Edit, x+5 yp-3 w50 vscr_ToolBarEdit3 -Wrap gscr_sub_ManuelResize
	Gui, Add, UpDown, gscr_sub_ManuelResize Range1-32767 +0x80 vscr_SelectionW, %scr_SelectionW%
	Gui, Add, Text, x+10 yp+3 w30 vscr_ToolBarText4, %lng_scr_Height%:
	Gui, Add, Edit, x+5 yp-3 w50 vscr_ToolBarEdit4 -Wrap gscr_sub_ManuelResize
	Gui, Add, UpDown, gscr_sub_ManuelResize Range1-32767 +0x80 vscr_SelectionH, %scr_SelectionH%

	Gui, Add, Text, xs10 y+15 vscr_ToolBarText5, %lng_scr_Resize%:
	Gui, Add, Edit, x+5 yp-3 R1 -Wrap w80 gsub_CheckIfSettingsChanged vscr_Resize_tmp, %scr_Resize%

	Gui, Add, GroupBox, x220 Section y7 w250 h120 vscr_ToolBarGroup2, %lng_scr_Options%
	Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs10 ys20 Checked%scr_captureCursor% vscr_captureCursor_tmp, %lng_scr_captureCursor%
	Gui, Add, DropDownList, vscr_Delay -Wrap x y w40 lng_scr_Delay, 0|1|2|4|6|10|15|30
	GuiControl, ChooseString, scr_Delay, %scr_Delay%
	Gui, Add, Text, x+3 yp-2 w190, %tooltip_scr_Delay%
	Gui, Add, Radio, -Wrap gsub_CheckIfSettingsChanged xp-42 y+4 Checked%scr_DisableFontSmoothing0% vscr_DisableFontSmoothing0_tmp, %lng_scr_DisableFontSmoothing0%
	Gui, Add, Radio, -Wrap gsub_CheckIfSettingsChanged y+4 Checked%scr_DisableFontSmoothing1% vscr_DisableFontSmoothing1_tmp, %lng_scr_DisableFontSmoothing1%
	Gui, Add, Radio, -Wrap gsub_CheckIfSettingsChanged y+4 Checked%scr_DisableFontSmoothing2% vscr_DisableFontSmoothing2_tmp, %lng_scr_DisableFontSmoothing2%

	Gui, Add, GroupBox, x10 y+10 section vscr_ToolBarGroup3 w460 h140, %lng_scr_ScreenshotMode%
	If hGdiPlus <> 0
	{
		Gui, Add, DropDownList, -Wrap AltSubmit gscr_sub_CheckIfSettingsChangedToolBar xs10 ys18 w220 vscr_ToFile_tmp, %lng_scr_ToClipboard%|%lng_scr_ToFile%|%lng_scr_ToFileAndClipBoard%
		GuiControl, Choose, scr_ToFile_tmp, %scr_ToFile%

		Gui, Add, Text, xs10 y+10 vlng_scr_FileName, %lng_scr_FileName%:
		scr_FileName_orig =
		scr_FileName_isCustom = 0
		Gui, Add, Edit, xs70 yp-3 R1 -Wrap w205 gscr_sub_CheckIfFileNameChangedToolBar vscr_Filename_tmp, %scr_Filename%
		Gui, Add, Text, x+5 yp+3 vscr_FileFormatNumberText, %lng_scr_FileFormat%:
		Gui, Add, DropDownList, gscr_sub_CheckIfSettingsChangedToolBar x+3 yp-3 w50 vscr_FileFormat_tmp, bmp|png|jpg|gif|tif
		Gui, Add, Text, x+8 yp+3 vscr_JPGqualitiy_txt, Q:
		Gui, Add, Edit, x+3 yp-3 w40 vscr_JPGqualitiy_1_tmp
		Gui, Add, UpDown, w40 Range0-100 vscr_JPGqualitiy_tmp, %scr_JPGqualitiy%
		GuiControl, ChooseString, scr_FileFormat_tmp, %scr_FileFormat%

		Gui, Add, Text, xs10 yp+27 vscr_ScreenShotFolder_tmp_tmp, %lng_scr_ScreenShotFolder%:
		Gui, Add, Edit, xs70 yp-3 R1 -Wrap w280 vscr_ScreenShotFolder_tmp, %scr_ScreenShotFolder%
		Gui, Add, Button, x+5 yp+0 -Wrap vscr_ScreenShotFolderButton w100 h21 gscr_sub_SelectToolBarFolder, %lng_scr_SelectFolder%

		Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs10 y+7 Checked%scr_AutoEdit% vscr_AutoEdit_tmp, %lng_scr_sub_AutoEditConfig%
		Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged x+5 Checked%scr_OpenFolder% vscr_OpenFolder_tmp, %lng_scr_OpenFolder%
		Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged xs10 y+7 Checked%scr_FilenameToClipboard% vscr_FilenameToClipboard_tmp, %lng_scr_FilenameToClipboard%
	}
	Else
	{
		scr_ToFile = 1
		Gui, Add, CheckBox, -Wrap Disabled gscr_sub_CheckIfSettingsChangedToolBar xp+10 yp+0 Checked%scr_ToFile% vscr_ToFile, %lng_scr_ToFile%
		Gui, Add, Text, xs+20 yp+22 w520, %lng_scr_NoGdiPlus%
	}

	Gui, Font,s%FontSize9%, Marlett
	Gui, Add, Text, Center x10 y275 h8 w460 vscr_ToolButton0 gscr_sub_MinimizeToolbar, 5

	Gosub, GuiDefaultFont

	Gui, Add, Button, x10 y287 h18 w75 vscr_ToolButton1 gscr_sub_ToolBarRemember, %lng_scr_Remember%
	Gui, Add, Button, y+1 h18 w75 vscr_ToolButton2 gScreenShotsToolBarGuiEscape, %lng_Cancel%
	Gui, Add, Button, x95 yp-19 h37 w90 vscr_ToolButton3 gscr_sub_Hotkey_Monitor, %lng_scr_ButtonAllMonitors%
	Gui, Add, Button, x+5 h37 w90 vscr_ToolButton4 gscr_sub_Hotkey_ActualMonitor, %lng_scr_ButtonMonitor%
	Gui, Add, Button, x+5 h37 w90 vscr_ToolButton5 gscr_sub_Hotkey_Application, %lng_scr_ButtonActiveWindow%
	Gui, Add, Button, Default x+5 h37 vscr_ToolButton6 w90 gScreenShotsFrameGuiOk, %lng_scr_ButtonSelection%

	Gui, Show, w480 h235 %scr_ToolBarX% %scr_ToolBarY%, %scr_ScriptName% %lng_scr_Toolbar%
	Gosub, scr_sub_CheckIfSettingsChangedToolBar
Return

scr_sub_SubmitToolbar:
	If scr_ToolbarID =
		Return
	Gui, %GuiID_ScreenShotsToolBar%:Submit,NoHide
	scr_Group1 = scr_Resize,scr_CaptureCursor,scr_DisableFontSmoothing1,scr_DisableFontSmoothing2,scr_ToFile,scr_FileFormat,scr_JPGqualitiy,scr_ScreenShotFolder,scr_AutoEdit,scr_OpenFolder,scr_FilenameToClipboard
	Loop, Parse, scr_Group1, `,
		%A_LoopField% := %A_LoopField%_tmp

	If scr_FileName_isCustom = 0
	{
		If(scr_WhichControl!="")
			scr_func_setFilename(false, 1)
		Else
			scr_func_setFilename(scr_WindowTitle, 1)
		scr_CustomFileName =
	}
	Else
		scr_CustomFileName := scr_FileName_tmp

	Gosub, scr_SaveIniSettings
Return

scr_sub_ToolBarRemember:
	Gosub, scr_sub_SubmitToolbar
	Gosub, ScreenShotsToolBarGuiEscape
Return

ScreenShotsToolBarGuiClose:
	If scr_ToolbarID =
		Return
	Gui, %GuiID_ScreenShotsToolBar%:+LastFound
	WinGetPos, scr_ToolBarX, scr_ToolBarY
	IniWrite, %scr_ToolBarX%, %ConfigFile%, ScreenShots, ToolBarX
	IniWrite, %scr_ToolBarY%, %ConfigFile%, ScreenShots, ToolBarY
	Gui, %GuiID_ScreenShotsHelper%:Show
	Gui, %GuiID_ScreenShotsToolBar%:Cancel
Return

scr_sub_CheckIfFileNameChangedToolBar:
	If scr_NoFileNameChange = 1
	{
		scr_NoFileNameChange =
		Return
	}
	Gui, %GuiID_ScreenShotsToolBar%:Submit,NoHide
	If (scr_FileName_tmp = "" OR scr_FileName_tmp = scr_FileName_orig OR scr_FileName_tmp = "0" )
		scr_FileName_isCustom = 0
	Else
		scr_FileName_isCustom = 1
Return

scr_sub_MinimizeToolbar:
	GuiControl, %GuiID_ScreenShotsToolBar%:Focus, scr_ToolButton6
	scr_sub_ToolBarMinimized := Not(scr_sub_ToolBarMinimized)
	IniWrite, %scr_sub_ToolBarMinimized%, %ConfigFile%, ScreenShots, ToolBarMinimized
	Gosub, scr_sub_CheckIfSettingsChangedToolBar
Return

scr_sub_CheckIfSettingsChangedToolBar:
	Gui, %GuiID_ScreenShotsToolBar%:Submit,NoHide

	If scr_FileName_isCustom = 0
	{
		If(scr_WhichControl!="")
			scr_func_setFilename(false, 1)
		Else
			scr_func_setFilename(scr_WindowTitle, 1)
		scr_NoFileNameChange = 1
		GuiControl, %GuiID_ScreenShotsToolBar%:,scr_Filename_tmp, %scr_Filename%
		If scr_FileName_orig =
			scr_FileName_orig := scr_FileName
	}

	If scr_FileFormat_tmp = jpg
	{
		GuiControl, Enable, scr_JPGqualitiy_tmp
		GuiControl, Enable, scr_JPGqualitiy_txt
		GuiControl, Enable, scr_JPGqualitiy_1_tmp
	}
	Else
	{
		GuiControl, Disable, scr_JPGqualitiy_tmp
		GuiControl, Disable, scr_JPGqualitiy_txt
		GuiControl, Disable, scr_JPGqualitiy_1_tmp
	}
	scr_Group1 = scr_AutoEdit_tmp,scr_OpenFolder_tmp,scr_FilenameToClipboard_tmp,scr_Filename_tmp,lng_scr_FileName,scr_FileFormatNumberText,scr_FileFormat_tmp,scr_JPGqualitiy_txt,scr_JPGqualitiy_1_tmp,scr_JPGqualitiy_tmp,scr_ScreenShotFolder_tmp_tmp,scr_ScreenShotFolder_tmp,scr_ScreenShotFolderButton
	scr_Group2 = scr_ToolBarGroup1,scr_ToolBarText1,scr_ToolBarEdit1,scr_SelectionX1,scr_ToolBarText2,scr_ToolBarEdit2,scr_SelectionY1,scr_ToolBarText3,scr_ToolBarEdit3,scr_SelectionW,scr_ToolBarText4,scr_ToolBarEdit4,scr_SelectionH,scr_ToolBarText5,scr_Resize_tmp,scr_ToolBarGroup2,scr_captureCursor_tmp,scr_DisableFontSmoothing0_tmp,scr_DisableFontSmoothing1_tmp,scr_DisableFontSmoothing2_tmp
	If scr_sub_ToolBarMinimized = 1
	{
		Loop, Parse, scr_Group2, `,
			GuiControl, Hide, %A_LoopField%
		GuiControl, , scr_ToolButton0, 6
		Loop, 6
			GuiControl, Move, scr_ToolButton%A_Index%, y15
		GuiControl, Move, scr_ToolButton2, y34
		GuiControl, Move, scr_ToolButton0, y3
		Gui, %GuiID_ScreenShotsToolBar%:Show, w480 h58
	}
	Else
	{
		Loop, Parse, scr_Group2, `,
			GuiControl, Show, %A_LoopField%
		GuiControl, , scr_ToolButton0, 5
		If scr_ToFile_tmp > 1
		{
			Loop, Parse, scr_Group1, `,
				GuiControl, Show, %A_LoopField%
			Loop, 6
				GuiControl, Move, scr_ToolButton%A_Index%, y287
			GuiControl, Move, scr_ToolButton2, y306
			GuiControl, Move, scr_ToolButton0, y275
			GuiControl, Move, scr_ToolBarGroup3, h140
			Gui, %GuiID_ScreenShotsToolBar%:Show, w480 h330
		}
		Else
		{
			Gui, %GuiID_ScreenShotsToolBar%:Show, w480 h235
			Loop, Parse, scr_Group1, `,
				GuiControl, Hide, %A_LoopField%
			Loop, 6
				GuiControl, Move, scr_ToolButton%A_Index%, y192
			GuiControl, Move, scr_ToolButton2, y211
			GuiControl, Move, scr_ToolButton0, y185
			GuiControl, Move, scr_ToolBarGroup3, h47
		}
	}
	If scr_ToFile_tmp = 3
	{
		GuiControl, , scr_FilenameToClipboard_tmp,0
		GuiControl, Disable, scr_FilenameToClipboard_tmp
	}
	Else
		GuiControl, Enable, scr_FilenameToClipboard_tmp
Return

scr_sub_ManuelResize:
	Thread, Priority, 1
	If scr_NoManualResize = 1
		Return
	Gui, %GuiID_ScreenShotsToolBar%:Submit,NoHide
	scr_SelectionX2 := scr_SelectionX1+scr_SelectionW
	scr_SelectionY2 := scr_SelectionY1+scr_SelectionH
	scr_SelectionRegionX1 := scr_SelectionX1+(0-MonitorAreaLeft)
	scr_SelectionRegionY1 := scr_SelectionY1+(0-MonitorAreaTop)
	scr_SelectionRegionX2 := scr_SelectionX2+(0-MonitorAreaLeft)
	scr_SelectionRegionY2 := scr_SelectionY2+(0-MonitorAreaTop)

	If (scr_SelectionX1 < scr_SelectionX2)
		scr_FrameX := scr_SelectionX1-BorderHeightToolWindow
	Else
		scr_FrameX := scr_SelectionX2-BorderHeightToolWindow
	If (scr_SelectionY1 < scr_SelectionY2)
		scr_FrameY := scr_SelectionY1-BorderHeightToolWindow
	Else
		scr_FrameY := scr_SelectionY2-BorderHeightToolWindow

	scr_SelectionRegionX1 := scr_SelectionX1+(0-MonitorAreaLeft)
	scr_SelectionRegionY1 := scr_SelectionY1+(0-MonitorAreaTop)
	scr_SelectionRegionX2 := scr_SelectionX2+(0-MonitorAreaLeft)
	scr_SelectionRegionY2 := scr_SelectionY2+(0-MonitorAreaTop)

	scr_NoGuiResize = 1

	WinMove, ahk_id %scr_FrameID%,, %scr_FrameX%, %scr_FrameY%, % scr_SelectionW+2*BorderHeightToolWindow, % scr_SelectionH+2*BorderHeightToolWindow

	If scr_DisableTransparency2 = 0
		WinSet, Region, 0-0 %MonitorAreaWidth%-0 %MonitorAreaWidth%-%MonitorAreaHeight% 0-%MonitorAreaHeight% 0-0 %scr_SelectionRegionX1%-%scr_SelectionRegionY1% %scr_SelectionRegionX2%-%scr_SelectionRegionY1% %scr_SelectionRegionX2%-%scr_SelectionRegionY2% %scr_SelectionRegionX1%-%scr_SelectionRegionY2% %scr_SelectionRegionX1%-%scr_SelectionRegionY1%, ahk_id %scr_DimID%

	Sleep,0
	SetTimer, scr_sub_NoGuiResize, -20
Return

scr_sub_NoGuiResize:
	scr_NoGuiResize =
Return

scr_sub_Hotkey_LastInteractive:
	scr_CustomFileName =
	If (rr_Ruler = "On" AND rr_showStart = 1)
	{
		If (rr_StartX > rr_RulerX) {
			rr_upperLeftX := rr_RulerX
			rr_lowerRightX := rr_StartX
		} Else {
			rr_upperLeftX := rr_StartX
			rr_lowerRightX := rr_RulerX
		}
		If (rr_StartY > rr_RulerY) {
			rr_upperLeftY := rr_RulerY
			rr_lowerRightY := rr_StartY
		} Else {
			rr_upperLeftY := rr_StartY
			rr_lowerRightY := rr_RulerY
		}
		scr_SelectionX1 := rr_upperLeftX
		scr_SelectionY1 := rr_upperLeftY
		scr_SelectionX2 := rr_lowerRightX+1
		scr_SelectionY2 := rr_lowerRightY+1

		scr_SelectionRegionX1 := scr_SelectionX1+(0-MonitorAreaLeft)
		scr_SelectionRegionY1 := scr_SelectionY1+(0-MonitorAreaTop)
		scr_SelectionRegionX2 := scr_SelectionX2+(0-MonitorAreaLeft)
		scr_SelectionRegionY2 := scr_SelectionY2+(0-MonitorAreaTop)

;		ToolTip ,,,,4 ; Tooltip ausschalten, damit es nicht im Screenshot sichtbar ist

		WinHide, ScreenRulerX
		WinHide, ScreenRulerY
		WinHide, ScreenRulerSX
		WinHide, ScreenRulerSY

		Gosub, sub_Hotkey_ReadingRuler%A_EmptyVar%
	}
	Else
	{
		IniRead, scr_SelectionX1, %ConfigFile%, %scr_ScriptName%, SelectionX1, 0
		IniRead, scr_SelectionY1, %ConfigFile%, %scr_ScriptName%, SelectionY1, 0
		IniRead, scr_SelectionX2, %ConfigFile%, %scr_ScriptName%, SelectionX2, 0
		IniRead, scr_SelectionY2, %ConfigFile%, %scr_ScriptName%, SelectionY2, 0
	}

	scr_SelectionW := Abs(scr_SelectionX2-scr_SelectionX1)
	scr_SelectionH := Abs(scr_SelectionY2-scr_SelectionY1)

	scr_func_setFilename(False)
	scr_coords := scr_SelectionX1 ", " scr_SelectionY1 ", " scr_SelectionW ", " scr_SelectionH
	Gosub, scr_sub_DisableFontsmoothing
	scr_func_CaptureScreen(scr_coords,scr_captureCursor, scr_Resize, scr_filename,scr_Highlight, (scr_PlaySound) ? scr_SoundFile : "" )
	Gosub, scr_sub_ReEnableFontsmoothing
	Gosub, scr_sub_OpenFolder
	Gosub, scr_sub_AutoEdit
Return

ScreenShotsHelperGuiClose:
ScreenShotsHelperGuiEscape:
ScreenShotsHiddenGuiClose:
ScreenShotsHiddenGuiEscape:
ScreenShotsDimGuiClose:
ScreenShotsDimGuiEscape:
ScreenShotsFrameGuiClose:
ScreenShotsFrameGuiEscape:
ScreenShotsToolBarGuiEscape:
	SetTimer, scr_tim_DrawSelection, Off
	SetTimer, scr_tim_DragSelection, Off
	SetTimer, scr_tim_MouseWatch, Off

	FileDelete, %A_Temp%\__aad_scr_tmpShot.bmp

	Gui, %GuiID_ScreenShotsHidden%:+LastFoundExist
	IfWinExist
	{
		func_RemoveMessage(0x100,"scr_sub_MoveWithKeys")
		If MainGuiVisible =
		{
			func_RemoveMessage(0x101,"GuiTooltipKey")
			func_RemoveMessage(0x200, "GuiTooltip")
			func_RemoveMessage(0x202, "GuiTooltipKey")
			func_RemoveMessage(0x6, "RemoveGuiTooltip")
		}
		IniWrite, %scr_Resize%, %ConfigFile%, %scr_ScriptName%, Resize

		Gui, %GuiID_ScreenShotsFrame%:Destroy
		Gui, %GuiID_ScreenShotsHidden%:Destroy
		Gosub, ScreenShotsToolBarGuiClose
		Gui, %GuiID_ScreenShotsToolBar%:Destroy
		Gui, %GuiID_ScreenShotsHelper%:Destroy

		If scr_DisableTransparency2 = 0
			Gui, %GuiID_ScreenShotsDim%:Destroy

		Gosub, scr_sub_DisableTimerAndButtons
	}

	If scr_DragCursor <>
	{
		scr_hCurs := DllCall("CopyImage", "UInt", scr_hCursorArrow, "uint",2, "int",0, "int",0, "uint",0)
		DllCall("SetSystemCursor", "Uint", scr_hCurs, "Int", IDC_ARROW)
		scr_DragCursor =
	}

	If scr_DontReEnableSmoothing =
		Gosub, scr_sub_ReEnableFontsmoothing
	scr_DontReEnableSmoothing =
	scr_Drawing =
	scr_ToolbarID =

	If (aa_osversionnumber >= aa_osversionnumber_vista)
		Sleep, 200

	Tooltip ,,,,2
Return

ScreenShotsHiddenGuiOk:
ScreenShotsFrameGuiOk:
ScreenShotsDimGuiOk:
	If (scr_Drawing = 1)
	{
		If (!GetKeyState("LButton"))
			scr_Drawing =
		Return
	}
	Gosub, scr_sub_SubmitToolbar
	Gosub, ScreenShotsToolBarGuiClose
	Gosub, scr_sub_GetFrameBounds
	Gui, %GuiID_ScreenShotsFrame%:Submit
	scr_DontReEnableSmoothing = 1
	Gosub, ScreenShotsFrameGuiClose
	IniWrite, %scr_SelectionX1%, %ConfigFile%, %scr_ScriptName%, SelectionX1
	IniWrite, %scr_SelectionY1%, %ConfigFile%, %scr_ScriptName%, SelectionY1
	IniWrite, %scr_SelectionX2%, %ConfigFile%, %scr_ScriptName%, SelectionX2
	IniWrite, %scr_SelectionY2%, %ConfigFile%, %scr_ScriptName%, SelectionY2

	If (a_osversionnum >= aa_osversionnumber_vista)
		Sleep, 200

	Critical, Off

	scr_ToFile_Backup := scr_ToFile
	If (GetKeyState("shift"))
		scr_ToFile := !scr_ToFile

	If scr_WhichWindow <>
	{
		WinGetPos, scr_WinX1, scr_WinY1, scr_WinX2, scr_WinY2, ahk_id %scr_WhichWindow%
		WinGetClass, scr_Class, ahk_id %scr_WhichWindow%
		scr_func_CorrectMaximizedScreenCoord("ahk_id " scr_WhichWindow, scr_WinX1, scr_WinY1, scr_WinX2, scr_WinY2)
	}
	If (scr_WhichWindow = "" OR scr_SelectionX1 <> scr_WinX1 OR scr_SelectionY1 <> scr_WinY1 OR scr_SelectionW <> scr_WinX2 OR scr_SelectionH <> scr_WinY2 OR scr_FrameInfo = 0)
	{
		scr_func_setFilename()
		scr_ShootArea = %scr_SelectionX1%, %scr_SelectionY1%, %scr_SelectionW%, %scr_SelectionH%
	}
	Else
	{
		WinGetTitle, scr_Title, ahk_id %scr_WhichWindow%
		scr_func_setFilename(scr_Title)
		scr_ShootArea = ahk_id %scr_WhichWindow%
	}
	If scr_Key = CtrlC
		scr_FileName = 0
	scr_func_CaptureScreen(scr_ShootArea, scr_CaptureCursor, scr_Resize, scr_Filename,scr_Highlight, (scr_PlaySound) ? scr_SoundFile : "", scr_Delay )
	scr_ToFile := scr_ToFile_Backup

	Gosub, scr_sub_ReEnableFontsmoothing

	If (InStr(scr_ShootArea, "ahk_id ") AND scr_Class = "Progman")
		Gosub, scr_sub_RefreshWindows

	Gosub, scr_sub_OpenFolder
	Gosub, scr_sub_AutoEdit
Return

ScreenShotsFrameGuiSize:
	If scr_NoGuiResize = 1
		Return
	SetWinDelay, %scr_WinDelay%
	WinGetPos, scr_SelectionX1_tmp, scr_SelectionY1_tmp,scr_SelectionW_tmp,scr_SelectionH_tmp,ahk_id %scr_FrameID%
	If (scr_SelectionW_tmp = 0 OR scr_SelectionH_tmp = 0)
		Return
	scr_SelectionW := scr_SelectionW_tmp-2*BorderHeightToolWindow
	scr_SelectionH := scr_SelectionH_tmp-2*BorderHeightToolWindow
	scr_SelectionX1 := scr_SelectionX1_tmp+BorderHeightToolWindow
	scr_SelectionY1 := scr_SelectionY1_tmp+BorderHeightToolWindow
	scr_SelectionX2 := scr_SelectionX1+scr_SelectionW
	scr_SelectionY2 := scr_SelectionY1+scr_SelectionH
	scr_SelectionRegionX1 := scr_SelectionX1+(0-MonitorAreaLeft)
	scr_SelectionRegionY1 := scr_SelectionY1+(0-MonitorAreaTop)
	scr_SelectionRegionX2 := scr_SelectionX2+(0-MonitorAreaLeft)
	scr_SelectionRegionY2 := scr_SelectionY2+(0-MonitorAreaTop)

	If scr_DisableTransparency2 = 0
		WinSet, Region, 0-0 %MonitorAreaWidth%-0 %MonitorAreaWidth%-%MonitorAreaHeight% 0-%MonitorAreaHeight% 0-0 %scr_SelectionRegionX1%-%scr_SelectionRegionY1% %scr_SelectionRegionX2%-%scr_SelectionRegionY1% %scr_SelectionRegionX2%-%scr_SelectionRegionY2% %scr_SelectionRegionX1%-%scr_SelectionRegionY2% %scr_SelectionRegionX1%-%scr_SelectionRegionY1%, ahk_id %scr_DimID%
	Gosub, scr_sub_SearchWindow

	CoordMode, Tooltip, Screen
;	If (scr_SelectionW > 0 OR scr_SelectionW > 0)
;		Tooltip, x%scr_SelectionX1% y%scr_SelectionY1% - %scr_SelectionW%x%scr_SelectionH%, % scr_SelectionX1+5, % scr_SelectionY2+8, 2
	Gosub, scr_RefreshToolBar
Return

scr_RefreshToolBar:
	scr_NoManualResize = 1
	SetTimer, scr_tim_NoManualResize, Off
	GuiControl, %GuiID_ScreenShotsToolBar%:, scr_SelectionX1, %scr_SelectionX1%
	GuiControl, %GuiID_ScreenShotsToolBar%:, scr_SelectionY1, %scr_SelectionY1%
	GuiControl, %GuiID_ScreenShotsToolBar%:, scr_SelectionW, %scr_SelectionW%
	GuiControl, %GuiID_ScreenShotsToolBar%:, scr_SelectionH, %scr_SelectionH%
	If scr_FileName_isCustom = 0
	{
		If(scr_WhichControl!="")
			scr_func_setFilename(false, 1)
		Else
			scr_func_setFilename(scr_WindowTitle, 1)
		scr_NoFileNameChange = 1
		GuiControl, %GuiID_ScreenShotsToolBar%:,scr_Filename_tmp, %scr_Filename%
	}
	SetTimer, scr_tim_NoManualResize, -150
Return

scr_tim_NoManualResize:
	scr_NoManualResize =
Return

scr_sub_GetFrameBounds:
;	Critical
	SetWinDelay, %scr_WinDelay%
	If (scr_SelectionX1 = "" OR scr_SelectionX2 = "" OR scr_SelectionY1 = "" OR scr_SelectionY2 = "")
	{
		scr_SelectionH = 0
		scr_SelectionW = 0
		scr_SelectionX1 = 0
		scr_SelectionY1 = 0
		scr_SelectionX2 = 0
		scr_SelectionY2 = 0
		scr_FrameX = 0
		scr_FrameY = 0
	}
	Else
	{
		scr_SelectionW := Abs(scr_SelectionX1-scr_SelectionX2)
		scr_SelectionH := Abs(scr_SelectionY1-scr_SelectionY2)
		If (scr_SelectionX1 < scr_SelectionX2)
			scr_FrameX := scr_SelectionX1-BorderHeightToolWindow
		Else
			scr_FrameX := scr_SelectionX2-BorderHeightToolWindow
		If (scr_SelectionY1 < scr_SelectionY2)
			scr_FrameY := scr_SelectionY1-BorderHeightToolWindow
		Else
			scr_FrameY := scr_SelectionY2-BorderHeightToolWindow

		scr_SelectionRegionX1 := scr_SelectionX1+(0-MonitorAreaLeft)
		scr_SelectionRegionY1 := scr_SelectionY1+(0-MonitorAreaTop)
		scr_SelectionRegionX2 := scr_SelectionX2+(0-MonitorAreaLeft)
		scr_SelectionRegionY2 := scr_SelectionY2+(0-MonitorAreaTop)
	}
	If scr_DisableTransparency2 = 1
		Gui, %GuiID_ScreenShotsFrame%:Show, w%scr_SelectionW% h%scr_SelectionH% x%scr_FrameX% y%scr_FrameY%,aadScreenShots
	Else
		Gui, %GuiID_ScreenShotsFrame%:Show, %scr_FrameParameter% w%scr_SelectionW% h%scr_SelectionH% x%scr_FrameX% y%scr_FrameY%,aadScreenShots

	If scr_DisableTransparency2 = 0
		WinSet, Region, 0-0 %MonitorAreaWidth%-0 %MonitorAreaWidth%-%MonitorAreaHeight% 0-%MonitorAreaHeight% 0-0 %scr_SelectionRegionX1%-%scr_SelectionRegionY1% %scr_SelectionRegionX2%-%scr_SelectionRegionY1% %scr_SelectionRegionX2%-%scr_SelectionRegionY2% %scr_SelectionRegionX1%-%scr_SelectionRegionY2% %scr_SelectionRegionX1%-%scr_SelectionRegionY1%, ahk_id %scr_DimID%
	scr_FrameVisible = 1

;	CoordMode, Tooltip, Screen
;	If (scr_SelectionW > 0 OR scr_SelectionW > 0)
;		Tooltip, x%scr_SelectionX1% y%scr_SelectionY1% - %scr_SelectionW%x%scr_SelectionH%, % scr_SelectionX1+5, % scr_SelectionY2+8, 2

	Gosub, scr_sub_SearchWindow
	Gosub, scr_RefreshToolBar
Return

scr_sub_MoveWithKeys:
	WinGet, scr_activeID, ID, A
	If scr_activeID <>
		If scr_activeID not in %scr_HiddenID%,%scr_DimID%,%scr_FrameID%,%scr_HelperID%
			Return

	scr_Key = %#wParam%
	scr_Key := scr_Key

	scr_KeyCtrl := GetKeyState("Ctrl")
	scr_KeyShift := GetKeyState("Shift")
	scr_KeyAlt := GetKeyState("Alt")

;	scr_FrameParameter = Hide

	If scr_Key = 38 ; Up
	{
		scr_SelectionY1 := scr_SelectionY1-(1+9*scr_KeyCtrl)*!scr_KeyShift
		scr_SelectionY2 := scr_SelectionY2-(1+9*scr_KeyCtrl)
		Gosub, scr_sub_GetFrameBounds
	}
	If scr_Key = 40 ; Down
	{
		scr_SelectionY1 := scr_SelectionY1+(1+9*scr_KeyCtrl)*!scr_KeyShift
		scr_SelectionY2 := scr_SelectionY2+(1+9*scr_KeyCtrl)
		Gosub, scr_sub_GetFrameBounds
	}
	If scr_Key = 37 ; Left
	{
		scr_SelectionX1 := scr_SelectionX1-(1+9*scr_KeyCtrl)*!scr_KeyShift
		scr_SelectionX2 := scr_SelectionX2-(1+9*scr_KeyCtrl)
		Gosub, scr_sub_GetFrameBounds
	}
	If scr_Key = 39 ; Right
	{
		scr_SelectionX1 := scr_SelectionX1+(1+9*scr_KeyCtrl)*!scr_KeyShift
		scr_SelectionX2 := scr_SelectionX2+(1+9*scr_KeyCtrl)
		Gosub, scr_sub_GetFrameBounds
	}
	If (scr_Key = 67 AND scr_KeyCtrl) ; Right
	{
		scr_Key = CtrlC
		Gosub, ScreenShotsFrameGuiOk
	}
	If (scr_Key = 46 or scr_Key = 8) ; Delete
	{
		scr_SelectionX1 =
		scr_SelectionY1 =
		scr_SelectionX2 =
		scr_SelectionY2 =
		Gosub, scr_sub_GetFrameBounds
		scr_LastMouseY =
		scr_LastMouseX =
		Gosub, scr_tim_MouseWatch
	}

	scr_FrameParameter =
	scr_FrameVisible = 0
Return

scr_TakeScreenshot:
	If A_GuiEvent = DoubleClick
		Gosub, ScreenShotsFrameGuiOk
Return

scr_tim_MouseWatch:
	If (GetKeyState("LButton"))
		Return
;	DetectHiddenWindows, Off
;	WinGet, scr_WindowList, List
;	WinGetClass, scr_WindowList1, A
;	tooltip, %scr_WindowList1%
;	scr_TopWindows = |%scr_WindowList1%|%scr_WindowList2%|%scr_WindowList3%|%scr_WindowList4%
;	If (!InStr(scr_TopWindows, "|" scr_HiddenID "|") OR !InStr(scr_TopWindows, "|" scr_DimID "|"))
;	{
;		If (!GetKeyState("Alt"))
;		{
;;			Gui, %GuiID_ScreenShotsHidden%:Show
;;			Gui, %GuiID_ScreenShotsDim%:Show
;;			Gui, %GuiID_ScreenShotsFrame%:Show
;;			Gui, %GuiID_ScreenShotsToolBar%:+LastFound
;;			IfWinExist
;;				Gui, %GuiID_ScreenShotsToolBar%:Show
;		}
;	}

	CoordMode, Mouse, Screen
	MouseGetPos, scr_MouseX, scr_MouseY, scr_MouseWin, scr_MouseControl
	If (scr_MouseX = scr_LastMouseX AND scr_MouseY = scr_LastMouseY AND scr_LastModifiers = GetKeyState("Ctrl") GetKeyState("Shift"))
		Return

	scr_LastModifiers := GetKeyState("Ctrl") GetKeyState("Shift")
	If (scr_MouseX >= scr_SelectionX1-1 AND scr_MouseX <= scr_SelectionX2+1 AND scr_MouseY >= scr_SelectionY1-1 AND scr_MouseY <= scr_SelectionY2+1 AND !GetKeyState("Ctrl") AND !GetKeyState("Shift"))
	{
		If (scr_DragCursor = 2 OR scr_DragCursor = 0)
		{
			scr_hCurs := DllCall("CopyImage", "UInt", scr_hCursorArrow, "uint",2, "int",0, "int",0, "uint",0)
			DllCall("SetSystemCursor", "Uint", scr_hCurs, "Int", IDC_ARROW)
			scr_DragCursor =
		}
		If (InStr("|" scr_HiddenID "|" scr_DimID "|" scr_FrameID "|" scr_HelperID "|", "|" scr_MouseWin "|") AND scr_MouseControl <> "Button2")
		{
			If scr_DragCursor =
			{
				scr_hCurs := DllCall("CopyImage", "UInt", scr_hCursorSizeAll, "uint",2, "int",0, "int",0, "uint",0)
				DllCall("SetSystemCursor", "Uint", scr_hCurs, "Int", IDC_ARROW)
				scr_DragCursor = 1
			}
		}
		Else If scr_DragCursor <>
		{
			scr_hCurs := DllCall("CopyImage", "UInt", scr_hCursorArrow, "uint",2, "int",0, "int",0, "uint",0)
			DllCall("SetSystemCursor", "Uint", scr_hCurs, "Int", IDC_ARROW)
			scr_DragCursor =
		}
	}
	Else If (GetKeyState("Shift"))
	{
		If (scr_DragCursor = 1 OR scr_DragCursor = 0)
		{
			scr_hCurs := DllCall("CopyImage", "UInt", scr_hCursorArrow, "uint",2, "int",0, "int",0, "uint",0)
			DllCall("SetSystemCursor", "Uint", scr_hCurs, "Int", IDC_ARROW)
			scr_DragCursor =
		}
		If (InStr("|" scr_HiddenID "|" scr_DimID "|" scr_FrameID "|" scr_HelperID "|", "|" scr_MouseWin "|") AND scr_MouseControl <> "Button2")
		{
			If scr_DragCursor =
			{
				scr_hCurs := DllCall("CopyImage", "UInt", scr_hCursorHand, "uint",2, "int",0, "int",0, "uint",0)
				DllCall("SetSystemCursor", "Uint", scr_hCurs, "Int", IDC_ARROW)
				scr_DragCursor = 2
			}
		}
		Else If scr_DragCursor <>
		{
			scr_hCurs := DllCall("CopyImage", "UInt", scr_hCursorArrow, "uint",2, "int",0, "int",0, "uint",0)
			DllCall("SetSystemCursor", "Uint", scr_hCurs, "Int", IDC_ARROW)
			scr_DragCursor =
		}
	}
	Else
	{
		If scr_DragCursor > 0
		{
			scr_hCurs := DllCall("CopyImage", "UInt", scr_hCursorArrow, "uint",2, "int",0, "int",0, "uint",0)
			DllCall("SetSystemCursor", "Uint", scr_hCurs, "Int", IDC_ARROW)
			scr_DragCursor =
		}
		If (InStr("|" scr_HiddenID "|" scr_DimID "|" scr_FrameID "|" scr_HelperID "|", "|" scr_MouseWin "|") AND scr_MouseControl <> "Button2")
		{
			If scr_DragCursor =
			{
				scr_hCurs := DllCall("CopyImage", "UInt", scr_hCursorCross, "uint",2, "int",0, "int",0, "uint",0)
				DllCall("SetSystemCursor", "Uint", scr_hCurs, "Int", IDC_ARROW)
				scr_DragCursor = 0
			}
		}
		Else If scr_DragCursor <>
		{
			scr_hCurs := DllCall("CopyImage", "UInt", scr_hCursorArrow, "uint",2, "int",0, "int",0, "uint",0)
			DllCall("SetSystemCursor", "Uint", scr_hCurs, "Int", IDC_ARROW)
			scr_DragCursor =
		}
		Tooltip ,,,,2
	}

	If (scr_MouseX >= scr_SelectionX1-BorderHeightToolWindow AND scr_MouseX <= scr_SelectionX2+BorderHeightToolWindow AND scr_MouseY >= scr_SelectionY1-BorderHeightToolWindow AND scr_MouseY <= scr_SelectionY2+BorderHeightToolWindow )
	{
		If scr_MouseWin in %scr_HiddenID%,%scr_DimID%,%scr_FrameID%,%scr_HelperID%
			If scr_FrameVisible <> 1
				Gosub, scr_sub_GetFrameBounds
;		Else
;			scr_FrameVisible = 0
	}
	Else
	{
		If (scr_FrameVisible = 1 AND scr_DisableTransparency2 = 0)
		{
			DetectHiddenWindows, Off
			IfWinNotExist ahk_id %scr_ToolbarID%
				Gui, %GuiID_ScreenShotsHelper%:Show
			Else
				Gui, %GuiID_ScreenShotsToolBar%:Show
			Gui, %GuiID_ScreenShotsFrame%:Hide
			scr_FrameVisible = 0
		}
	}
	scr_LastMouseX := scr_MouseX
	scr_LastMouseY := scr_MouseY

	If (scr_MouseX >= scr_SelectionX2-105 AND scr_MouseX <= scr_SelectionX2-5 AND scr_MouseY >= scr_SelectionY2-25 AND scr_MouseY <= scr_SelectionY2-5)
	{
;		GuiControl, %GuiID_ScreenShotsFrame%:Enable, scr_Resize
;		GuiControl, %GuiID_ScreenShotsFrame%:-Hidden, scr_Resize
		GuiControl, %GuiID_ScreenShotsFrame%:Enable, scr_ShowToolBar
		GuiControl, %GuiID_ScreenShotsFrame%:-Hidden, scr_ShowToolBar
	}
	Else
	{
;		GuiControl, %GuiID_ScreenShotsFrame%:Disable, scr_Resize
;		GuiControl, %GuiID_ScreenShotsFrame%:+Hidden, scr_Resize
		GuiControl, %GuiID_ScreenShotsFrame%:Disable, scr_ShowToolBar
		GuiControl, %GuiID_ScreenShotsFrame%:+Hidden, scr_ShowToolBar
	}
Return

scr_tim_DrawSelection:
	SetWinDelay, %scr_WinDelay%
	CoordMode, Mouse, Screen
	MouseGetPos, scr_MouseX, scr_MouseY, scr_MouseWin
	If (scr_MouseX = scr_StartX AND scr_MouseY = scr_StartY)
		Return
	If (scr_NewSelectionX1 <> "" OR scr_NewSelectionY1 <> "")
	{
		scr_SelectionX1 := scr_NewSelectionX1
		scr_SelectionY1 := scr_NewSelectionY1
		scr_NewSelectionX1 =
		scr_NewSelectionY1 =
	}
	If (GetKeyState("Space"))
	{
		If scr_AltMouseX =
		{
			scr_AltMouseX := scr_MouseX
			scr_AltMouseY := scr_MouseY
		}
		Else
		{
			scr_SelectionX1 := scr_SelectionX1 + scr_MouseX-scr_AltMouseX
			scr_SelectionX2 := scr_SelectionX2 + scr_MouseX-scr_AltMouseX
			scr_SelectionY1 := scr_SelectionY1 + scr_MouseY-scr_AltMouseY
			scr_SelectionY2 := scr_SelectionY2 + scr_MouseY-scr_AltMouseY
			scr_AltMouseX := scr_MouseX
			scr_AltMouseY := scr_MouseY
		}
	}
	Else
	{
		scr_AltMouseX =
		scr_AltMouseY =
		scr_SelectionX2 := scr_MouseX
		scr_SelectionY2 := scr_MouseY
	}

	scr_FrameParameter = Hide
	Gosub, scr_sub_GetFrameBounds
	scr_FrameParameter =
Return

scr_tim_DragSelection:
	SetWinDelay, %scr_WinDelay%
	CoordMode, Mouse, Screen
	MouseGetPos, scr_MouseX, scr_MouseY, scr_MouseWin
	If (scr_MouseX = scr_DragX AND scr_MouseY = scr_DragY)
		Return
	scr_SelectionX1 := scr_SelectionX1 + (scr_MouseX-scr_DragX)
	scr_SelectionY1 := scr_SelectionY1 + (scr_MouseY-scr_DragY)
	scr_SelectionX2 := scr_SelectionX2 + (scr_MouseX-scr_DragX)
	scr_SelectionY2 := scr_SelectionY2 + (scr_MouseY-scr_DragY)
	If scr_DisableTransparency2 = 0
		scr_FrameParameter = HIDE
	Gosub, scr_sub_GetFrameBounds
	scr_FrameParameter =
	scr_DragX := scr_MouseX
	scr_DragY := scr_MouseY
Return

scr_LButton:
	Critical
	CoordMode, Mouse, Screen

	MouseGetPos, scr_StartX, scr_StartY, scr_MouseWin, scr_MouseControl
	If scr_MouseWin not in %scr_HiddenID%,%scr_DimID%,%scr_FrameID%,%scr_HelperID%
	{
		scr_NoGuiResize = 1
		Return
	}


	If (scr_StartX > scr_SelectionX1 AND scr_StartX < scr_SelectionX2 AND scr_StartY > scr_SelectionY1 AND scr_StartY < scr_SelectionY2 AND !GetKeyState("Ctrl"))
	{
		If (scr_MouseControl <> "Edit1")
		{
			scr_DragX := scr_StartX
			scr_DragY := scr_StartY
			SetTimer, scr_tim_MouseWatch, Off
			SetTimer, scr_tim_DragSelection, 20
		}
	}
	Else
	{
		If A_Cursor in SizeNESW,SizeNS,SizeNWSE,SizeWE,SizeAll
		{
			Return
		}
		scr_NewSelectionX1 := scr_StartX
		scr_NewSelectionY1 := scr_StartY
		SetTimer, scr_tim_MouseWatch, Off
		SetTimer, scr_tim_DrawSelection, 20
		If scr_DisableTransparency2 = 0
			GuiControl, %GuiID_ScreenShotsDim%:Disable, Button1
		GuiControl, %GuiID_ScreenShotsHidden%:Disable, Button1
		GuiControl, %GuiID_ScreenShotsFrame%:Disable, Button1
		scr_Drawing = 1
	}

	; Double-Click
	If (A_Priorhotkey = "$~*LButton Up" AND A_Timesincepriorhotkey < 200 AND scr_StartX < scr_LastClickX+4 AND scr_StartX > scr_LastClickX-4 AND scr_StartY < scr_LastClickY+4 AND scr_StartY > scr_LastClickY-4)
	{
		scr_LastClickX =
		scr_LastClickY =
		Gosub, ScreenShotsFrameGuiOk
	}
	Else
	{
		scr_LastClickX := scr_StartX
		scr_LastClickY := scr_StartY
	}

	scr_NoGuiResize = 1
Return

scr_LButtonUp:
	Critical
	scr_NoGuiResize =
	SetTimer, scr_tim_DrawSelection, Off
	SetTimer, scr_tim_DragSelection, Off
	SetTimer, scr_tim_MouseWatch, Off

	CoordMode, Mouse, Screen
	MouseGetPos, scr_MouseX, scr_MouseY ; , scr_activeID

;	WinGet, scr_activeID, ID, A
	If scr_MouseWin not in %scr_HiddenID%,%scr_DimID%,%scr_FrameID%,%scr_HelperID%
	{
		SetTimer, scr_tim_MouseWatch, On
		Return
	}

	If scr_ShootAfterSelecting = 1
	{
		Critical, Off
		scr_Drawing = 0
		Gosub, ScreenShotsFrameGuiOk
		Return
	}

	scr_AltMouseX =
	scr_AltMouseY =
	If scr_DisableTransparency2 = 0
		GuiControl, %GuiID_ScreenShotsDim%:Enable, Button1
	GuiControl, %GuiID_ScreenShotsHidden%:Enable, Button1
	GuiControl, %GuiID_ScreenShotsFrame%:Enable, Button1

	If (scr_SelectionX2 < scr_SelectionX1)
		func_Swap(scr_SelectionX1,scr_SelectionX2)
	If (scr_SelectionY2 < scr_SelectionY1)
		func_Swap(scr_SelectionY1,scr_SelectionY2)

	If (scr_MouseX >= scr_SelectionX2-105 AND scr_MouseX <= scr_SelectionX2-5 AND scr_MouseY >= scr_SelectionY2-25 AND scr_MouseY <= scr_SelectionY2-5)
		Return

	If (scr_MouseX = scr_StartX AND scr_MouseY = scr_StartY AND (scr_MouseX < scr_SelectionX1 OR scr_MouseX > scr_SelectionX2 OR scr_MouseY < scr_SelectionY1 OR scr_MouseY > scr_SelectionY2 OR GetKeyState("Ctrl") OR GetKeyState("Shift")) )
	{
		DetectHiddenWindows, Off
		WinGet, scr_WindowList, List
		Loop, %scr_WindowList%
		{
			If scr_WindowList%A_Index% in %scr_HiddenID%,%scr_DimID%,%scr_FrameID%,%scr_ToolBarID%,%scr_HelperID%
				continue

			WinGetTitle, scr_WindowTitle, % "ahk_id " scr_WindowList%A_Index%
			If scr_WindowTitle in ComfortDragWhileDragging
				continue

			WinGetPos, scr_WindowX, scr_WindowY, scr_WindowW, scr_WindowH, % "ahk_id " scr_WindowList%A_Index%
			scr_func_CorrectMaximizedScreenCoord("ahk_id " scr_WindowList%A_Index%, scr_WindowX, scr_WindowY, scr_WindowW, scr_WindowH)
			If (scr_MouseX >= scr_WindowX AND scr_MouseX <= scr_WindowX+scr_WindowW AND scr_MouseY >= scr_WindowY AND scr_MouseY <= scr_WindowY+scr_WindowH)
			{
				WinHide, ahk_id %scr_FrameID%
				scr_SelectionX1 := scr_WindowX
				scr_SelectionY1 := scr_WindowY
				scr_SelectionH := scr_WindowW
				scr_SelectionW := scr_WindowH
				scr_SelectionX2 := scr_WindowX+scr_WindowW
				scr_SelectionY2 := scr_WindowY+scr_WindowH
				scr_WhichWindow := scr_WindowList%A_Index%
				WinGetClass, scr_Class, % "ahk_id " scr_WindowList%A_Index%
				WinGet, bExStyle, ExStyle, % "ahk_id " scr_WindowList%A_Index%
				If (scr_Class = "Progman" OR (bExStyle & 0x80000) OR InStr(scr_Class,"SunAwt") OR InStr(scr_Class,"javax.swing") OR scr_NoOverlappingWindows = 1 ) ; WS_EX_LAYERED
					GuiControl, %GuiID_ScreenShotsFrame%:,scr_FrameInfo, 0
				Else
					GuiControl, %GuiID_ScreenShotsFrame%:,scr_FrameInfo, 1
				break
			}
		}
		If (GetKeyState("Shift"))
		{
			If scr_DisableTransparency2 = 0
			{
				WinSet, ExStyle, +0x20, ahk_id %scr_DimID%
			}
			WinHide, ahk_id %scr_HiddenID%
			WinHide, ahk_id %scr_ToolBarID%
			CoordMode,Mouse,Screen
			MouseGetPos, scr_MouseX, scr_MouseY, scr_WhichWindow, scr_WhichControl
			If scr_DisableTransparency2 = 0
			{
				WinSet, ExStyle, -0x20, ahk_id %scr_DimID%
			}
			WinShow, ahk_id %scr_HiddenID%
			WinShow, ahk_id %scr_ToolBarID%
			WinGetPos, scr_SelectionX1, scr_SelectionY1, scr_SelectionX2, scr_SelectionY2, ahk_id %scr_WhichWindow%
			ControlGetPos, scr_ControlX, scr_ControlY, scr_SelectionX2, scr_SelectionY2, %scr_WhichControl%, ahk_id %scr_WhichWindow%

			scr_SelectionX1 := scr_SelectionX1+scr_ControlX
			scr_SelectionY1 := scr_SelectionY1+scr_ControlY
			scr_SelectionX2 := scr_SelectionX1+scr_SelectionX2
			scr_SelectionY2 := scr_SelectionY1+scr_SelectionY2
		}
	}
	Critical, Off
	SetTimer, scr_tim_MouseWatch, On
	Gosub, scr_sub_GetFrameBounds

;	Gui, %GuiID_ScreenShotsToolBar%:Show, NA
	If (scr_Drawing = 1 AND !GetKeyState("Space"))
		scr_Drawing =
Return

scr_sub_CorrectMaximized:
Return

scr_sub_SearchWindow:
	Critical
	DetectHiddenWindows, Off
	WinGet, scr_WindowList, List
	Loop, %scr_WindowList%
	{
		If scr_WindowList%A_Index% in %scr_HiddenID%,%scr_DimID%,%scr_FrameID%,%scr_ToolBarID%,%scr_HelperID%
			continue
		WinGetTitle, scr_WindowTitle, % "ahk_id " scr_WindowList%A_Index%
		If scr_WindowTitle in ComfortDragWhileDragging
			continue
		WinGetPos, scr_WindowX, scr_WindowY, scr_WindowW, scr_WindowH, % "ahk_id " scr_WindowList%A_Index%
		scr_func_CorrectMaximizedScreenCoord("ahk_id " scr_WindowList%A_Index%, scr_WindowX, scr_WindowY, scr_WindowW, scr_WindowH)

		If (scr_SelectionX1 = scr_WindowX AND scr_SelectionY1 = scr_WindowY AND scr_SelectionW = scr_WindowW AND scr_SelectionH = scr_WindowH)
		{
			scr_WhichWindow := scr_WindowList%A_Index%
			WinGetClass, scr_WindowClass, ahk_id %scr_WhichWindow%
			break
		}
		scr_WhichWindow =
		scr_WindowTitle =
	}
	GuiControl, %GuiID_ScreenShotsFrame%:Move, scr_FrameInfo, w%scr_WindowW%
;	GuiControl, %GuiID_ScreenShotsFrame%:Move, scr_Resize, % "x" scr_SelectionW-65 " y" scr_SelectionH-25
	GuiControl, %GuiID_ScreenShotsFrame%:Move, scr_ShowToolBar, % "x" scr_SelectionW-105 " y" scr_SelectionH-25
	GuiControl, %GuiID_ScreenShotsFrame%:Focus, ScreenShotsFrameGuiOk
	If (scr_WindowTitle = "" AND scr_WhichWindow <> "")
	{
		GuiControl, %GuiID_ScreenShotsFrame%:-Hidden, scr_FrameInfo
		GuiControl, %GuiID_ScreenShotsFrame%:,scr_FrameInfo, ahk_class %scr_WindowClass%
	}
	Else If scr_WindowTitle <>
	{
		GuiControl, %GuiID_ScreenShotsFrame%:-Hidden, scr_FrameInfo
		GuiControl, %GuiID_ScreenShotsFrame%:,scr_FrameInfo, %scr_WindowTitle%
	}
	Else
	{
		GuiControl, %GuiID_ScreenShotsFrame%:+Hidden, scr_FrameInfo
	}
Return

scr_sub_DisableFontsmoothing:
	If scr_DisableFontSmoothing1 = 1
	{
		; Aktuelle Schriftglättung zwischenspeichern
		VarSetCapacity(scr_Result, 1)
		DllCall("SystemParametersInfo", UInt, 74, UInt, 0, Char, &scr_Result, UInt,1 ) ; SPI_GETFONTSMOOTHING = 74
		scr_OriginalFontSmoothing := NumGet(scr_Result)
		; Schriftglättung ausschalten
		DllCall("SystemParametersInfo", UInt, 75, UInt, 0, Char, 0, UInt,1 ) ; SPI_SETFONTSMOOTHING = 75
		Gosub, scr_sub_RefreshWindows
	}
	If scr_DisableFontSmoothing2 = 1
	{
		; Aktuelle Schriftglättung-Art zwischenspeichern
		VarSetCapacity(scr_Result, 1)
		DllCall("SystemParametersInfo", UInt, 0x200A, UInt, 0, Char, &scr_Result, UInt,1 ) ; SPI_GETFONTSMOOTHINGTYPE = 0x200A
		scr_OriginalFontSmoothingType := NumGet(scr_Result)
		; ClearType ausschalten
		DllCall("SystemParametersInfo", UInt, 0x200B, UInt, 0, Char, 1, UInt,1 ) ; SPI_SETFONTSMOOTHINGTYPE = 0x200B
		Gosub, scr_sub_RefreshWindows
	}
Return

scr_sub_ReEnableFontsmoothing:
	If (scr_DisableFontSmoothing1 = 1 AND scr_OriginalFontSmoothing <> "")
	{
		DllCall("SystemParametersInfo", UInt, 75, UInt, scr_OriginalFontSmoothing, Char, 0, UInt,1 ) ; SPI_SETFONTSMOOTHING = 75
		Gosub, scr_sub_RefreshWindows
	}
	If (scr_DisableFontSmoothing2 = 1 AND scr_OriginalFontSmoothingType <> "")
	{
		DllCall("SystemParametersInfo", UInt, 0x200B, UInt, 0, Char, scr_OriginalFontSmoothingType, UInt,1 ) ; SPI_SETFONTSMOOTHINGTYPE = 0x200B
		Gosub, scr_sub_RefreshWindows
	}
Return

scr_sub_RefreshWindows:
	DetectHiddenWindows, Off
	WinGet, scr_List, List

	Loop, %scr_List%
	{
		DllCall("RedrawWindow","uint",scr_List%A_Index%,"uint",0,"uint",0,"uint",0x787)
		WinSet, Redraw,, % "ahk_id " scr_List%A_Index%
	}
;	SendMessage, 0x7E,,,,ahk_id 0xFFFF ; Refresh
Return

; -----------------------------------------------------------------------------
; === Functions ===============================================================
; -----------------------------------------------------------------------------

scr_func_setFilename(SetWindowTitle=true,OnlyFileName=0,CustomFileName="")
{
	global
	If CustomFileName =
		scr_filename := scr_FilenameTemplate
	Else
		scr_filename := CustomFileName

	If scr_CustomFileName <>
		scr_filename := scr_CustomFileName

	If (scr_ToFile>1 OR (OnlyFileName = 1 AND scr_ToFile_tmp>1))
	{
		IfInString, scr_FilenameTemplate, \n
		{
			StringReplace, scr_filename, scr_filename, \n, %scr_Counter%, A
			scr_Counterlength := StrLen(scr_Counter)
			If OnlyFileName = 0
				scr_Counter++
			scr_Counter := func_StrRight("000000000" scr_Counter, scr_Counterlength)
			scr_Counterlength =
			IniWrite, %scr_Counter%, %ConfigFile_ScreenShots%, %scr_ScriptName%, Counter
		}
		IfInString, scr_FilenameTemplate, \d
		{
			FormatTime, scr_ActualDate,, %scr_DateFormat%
			StringReplace, scr_filename, scr_filename, \d, %scr_ActualDate%, A
		}
		IfInString, scr_FilenameTemplate, \t
		{
			if (SetWindowTitle = true)
				WinGetActiveTitle, scr_WindowTitle
			Else if (SetWindowTitle <> false AND SetWindowTitle <> "")
				scr_WindowTitle := SetWindowTitle

			StringReplace, scr_filename, scr_filename, \t, %scr_WindowTitle%, A
		}
		if scr_filename =
			scr_filename := "screenshot"
		scr_filename := RegExReplace(scr_filename, scr_regex,"_")
		scr_FileNameAddNumber := ""
		If (!InStr(FileExist(func_Deref(scr_ScreenShotFolder)), "D"))
		{
			FileCreateDir, % func_Deref(scr_ScreenShotFolder)
		}
		Loop
		{
			If (!FileExist(func_Deref(scr_ScreenShotFolder) scr_filename scr_FileNameAddNumber "." scr_FileFormat))
			{
				scr_filename := func_Deref(scr_ScreenShotFolder) scr_filename scr_FileNameAddNumber "." scr_FileFormat
				if (scr_FilenameToClipboard AND OnlyFileName = 0 AND scr_ToFile = 2)
				{
					clipboard = %scr_filename%
				}
				break
			}
			else
			{
				if (scr_FileNameAddNumber == "")
					scr_FileNameAddNumber = 0
				else
					scr_FileNameAddNumber++
			}
		}

		If OnlyFileName = 1
			SplitPath, scr_FileName,,,, scr_FileName

		Return
	}
	else
		scr_filename := 0
}

/* CaptureScreen(aRect, bCursor, sFileTo)
1) If the optional parameter bCursor is True, captures the cursor too.
2) If the optional parameter sFileTo is 0, set the image to Clipboard.
	If it is omitted or "", saves to screen.bmp in the script folder,
	otherwise to sFileTo which can be BMP/JPG/PNG/GIF/TIF.
3) If aRect is 0/1/2, captures the screen/active window/client area of active window.
4) aRect can be comma delimited sequence of coordinates, e.g., "Left, Top, Right, Bottom" or "Left, Top, Width, Height(old -Right, Bottom-), Width_Zoomed, Height_Zoomed".
	In this case, only that portion of the rectangle will be captured. Additionally, in the latter case, zoomed to the new width/height, Width_Zoomed/Height_Zoomed.

Example:
CaptureScreen(0) Screen
CaptureScreen("ahk_id Name") Window with PrintScreen (also Windows in Background)
CaptureScreen(1) Area of actual window
CaptureScreen(2) Client
CaptureScreen("100, 100, 200, 200")
CaptureScreen("100, 100, 200, 200, 400, 400") ; Zoomed
*/

/* Convert(sFileFr, sFileTo)
Convert("C:\image.bmp", "C:\image.jpg")
Convert(0, "C:\clip.png") ; Save the bitmap in the clipboard to sFileTo if sFileFr is "" or 0.
*/

;scr_func_CaptureScreen()

scr_func_CaptureScreen(aRect = 0, bCursor = False, sZoom="", sFile = "", bHighlight = true, sSoundFile="", sDelay=0)
{
	global MonitorAreaLeft, MonitorAreaTop, MonitorAreaWidth, MonitorAreaHeight, MonitorAreaBottom, MonitorAreaRight,scr_ProgressVisible,scr_NoOverlappingWindows,scr_ToFile,scr_CatchContextMenu,lng_scr_DelayProgress
	If sDelay>0
	{
		Critical, Off
		SetBatchLines, -1
		scr_ProgressVisible = 1
		MaxProgress := sDelay*100
		if MaxProcess = 100
			MaxProcess = 60
		Progress, 5:H50 R0-%MaxProgress% B2 P%MaxProgress%,,%lng_scr_DelayProgress%
		SetBatchLines,2
		Loop %MaxProgress%
			Progress % "5:" MaxProgress-A_Index
		Progress, 5:Off
		SetBatchLines,-1
		Sleep,50
		scr_ProgressVisible = 0
	}
	sWinID =
	sNoOverlappingWindows := scr_NoOverlappingWindows
	If !aRect
	{
		; im Originalscript werden die Variablen ausgelesen, ich nehme die ac'tivAid Variablen
		nL := MonitorAreaLeft
		nT := MonitorAreaTop
		nW := MonitorAreaWidth
		nH := MonitorAreaHeight
	}
	Else If aRect = 1
	{
		WinGetPos, nL, nT, nW, nH, A
		scr_func_CorrectMaximizedScreenCoord( "A", nL, nT, nW, nH )
	}
	Else If aRect = 2
	{
		WinGet, hWnd, ID, A
		VarSetCapacity(rt, 16, 0)
		DllCall("GetClientRect" , "Uint", hWnd, "Uint", &rt)
		DllCall("ClientToScreen", "Uint", hWnd, "Uint", &rt)
		nL := NumGet(rt, 0, "int")
		nT := NumGet(rt, 4, "int")
		nW := NumGet(rt, 8)
		nH := NumGet(rt,12)
;		scr_func_CorrectMaximizedScreenCoord( "ahk_id " hWnd, nL, nT, nW, nH )
	}
	Else IfWinExist %aRect%
	{
		WinGet, sWinID, ID, %aRect%
		WinGetPos, nL, nT, nW, nH, %aRect%
		If (aRect = "A" and scr_CatchContextMenu = 1)
		{
			DetectHiddenWindows, Off
			WinGet, sWinList, List
;			a =
;			loop %sWinList%
;			{
;				WinGetClass, b, % "ahk_id " sWinList%A_Index%
;				a := a b "`n"
;			}
;			tooltip, %a%
			WinGetClass, sWinClass, ahk_id %sWinList1%
			If ((sWinClass = "#32768" or sWinClass = "MozillaDropShadowWindowClass") AND sWinList1 <> sWinID)
			{
				WinGetClass, sWinClass, ahk_id %sWinList2%
				If sWinClass = SysShadow
				sWinList1 := sWinList2
				WinGetPos, nLcontext, nTcontext, nWcontext, nHcontext, ahk_id %sWinList1%
				If (nLcontext < nL)
				{
					sNoOverlappingWindows = 1
					nL := nLcontext
				}
				If (nTcontext < nT)
				{
					sNoOverlappingWindows = 1
					nT := nTcontext
				}
				If (nLcontext - nL + nWcontext > nW)
				{
					sNoOverlappingWindows = 1
					nW := nLcontext - nL + nWcontext
				}
				If (nTcontext - nT + nHcontext > nH)
				{
					sNoOverlappingWindows = 1
					nH := nTcontext - nT + nHcontext
				}
			}
		}
;		If (sWinID AND !(bExStyle & 0x80000)) ; WS_EX_LAYERED
;			scr_func_CorrectMaximizedScreenCoord( aRect, nL, nT, nW, nH, 1 )
;		Else
;			scr_func_CorrectMaximizedScreenCoord( aRect, nL, nT, nW, nH )
	}
	Else
	{
		StringSplit, rt, aRect, `,, %A_Space%%A_Tab%
		nL := rt1
		nT := rt2
		nW := rt3 ; - rt1
		nH := rt4 ; - rt2
		znW := rt5
		znH := rt6
	}
	If (!sWinID)
	{
		If (nL < MonitorAreaLeft)
		nL := MonitorAreaLeft
		If (nT < MonitorAreaTop)
		nT := MonitorAreaTop
		If (nL+nW > MonitorAreaRight)
		nW := MonitorAreaRight-nL
		If (nT+nH > MonitorAreaBottom)
		nH := MonitorAreaBottom-nT
	}

	If (sZoom <> "" AND sZoom <> "100%" AND sZoom <> "1/1")
	{
		StringSplit, rt, sZoom, `,*x, %A_Space%%A_Tab%
		znW := rt1
		znH := rt2

		If znH = *
		znH := nH
		If znW = *
		znW := nW

		StringReplace, znW, znW, `:, /
		IfInString znW, /
		{
			StringSplit, znW, znW, /
			znH := Round(nH*znW1/znW2)
			znW := Round(nW*znW1/znW2)
		}
		Else IfInString znW, `%
		{
			StringReplace, znW, znW, `%
			znH := Round(nH*znW/100)
			znW := Round(nW*znW/100)
		}
		Else
		{
			If (znW = "" OR znW = "?")
				znW = 0
			If (znH = "" OR znH = "?")
				znH = 0
			If ((nW <= znW OR znW = 0) AND (nH <= znH OR znH = 0))
			{
				znW =
				znH =
			}
			Else
			{
				If znW = 0
				{
					zF := znH/nH
					znW := Round(nW * zF)
				}
				Else If znH = 0
				{
					zF := znW/nW
					znH := Round(nH * zF)
				}
				Else
				{
					zF := znW/nW
					If ((nH * zF) > znH)
					zF := znH/nH
					znH := Round(nH * zF)
					znW := Round(nW * zF)
				}
			}
		}

	}

	WinGet, bExStyle, ExStyle, ahk_id %sWinID%
	If (sWinID AND !(bExStyle & 0x80000) AND !InStr(scr_Class,"SunAwt") AND !InStr(scr_Class,"javax.swing") AND sNoOverlappingWindows = 0 ) ; WS_EX_LAYERED
	{
		ncL := nL
		ncT := nT
		ncW := nW
		ncH := nH

		hDC := DllCall("GetDC", "Uint", 0)
		mDC := DllCall("CreateCompatibleDC", "Uint", hDC)
		hBM := DllCall("CreateCompatibleBitmap", "Uint", hDC, "int", nW, "int", nH)
		oBM := DllCall("SelectObject", "Uint", mDC, "Uint", hBM)
		scr_func_CorrectMaximizedScreenCoord( aRect, ncL, ncT, ncW, ncH, 1 )
		DllCall("PrintWindow", "UInt",sWinID, "UInt",mDC, "UInt",0)
		If bCursor
		scr_func_CaptureCursor(mDC, nL, nT)
		DllCall("SelectObject", "Uint", mDC, "Uint", oBM)
		DllCall("DeleteDC", "Uint", mDC)
		hBM := scr_func_Clip(hDC, hBM, ncL, ncT, ncW, ncH)
	}
	Else
	{
		hDC := DllCall("GetDC", "Uint", 0)
		mDC := DllCall("CreateCompatibleDC", "Uint", hDC)
		hBM := DllCall("CreateCompatibleBitmap", "Uint", hDC, "int", nW, "int", nH)
		oBM := DllCall("SelectObject", "Uint", mDC, "Uint", hBM)
		DllCall("BitBlt", "Uint", mDC, "int", 0, "int", 0, "int", nW, "int", nH, "Uint", hDC, "int", nL, "int", nT, "Uint", 0x40000000 | 0x00CC0020)

		If bCursor
		scr_func_CaptureCursor(mDC, nL, nT)
		DllCall("SelectObject", "Uint", mDC, "Uint", oBM)
		DllCall("DeleteDC", "Uint", mDC)

	}

	If znW && znH
	hBM := scr_func_Zoomer(hDC, hBM, nW, nH, znW, znH)
	; Michaels highlight Funktion
	If bHighlight
	scr_func_highlight(nL,nT,nW,nH)
	If sSoundFile <>
	IfExist %sSoundFile%
	SoundPlay, %sSoundFile%

	If (scr_ToFile = 1 OR sFile = 0 OR scr_ToFile = 3)
	scr_func_SetClipboardData(hBM)
	If (scr_ToFile > 1 AND sFile <> 0)
	scr_func_Convert(hBM, sFile)
	DllCall("DeleteObject", "Uint", hBM)
	DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)
}

scr_func_CorrectMaximizedScreenCoord(Window, ByRef scr_MaxL, ByRef scr_MaxT, ByRef scr_MaxW, ByRef scr_MaxH, scr_NewBase=0)
{
	Global
	scr_Monitor := func_GetMonitorNumber( Window )

	WinGet, MinMax, MinMax, %Window%
	WinGet, Style, Style, %Window%
	If (MinMax = 1 AND (Style & 0x40000))
	{
		If (scr_MaxL < WorkArea%scr_Monitor%Left)
			scr_MaxL := ( (scr_NewBase=1) ? (scr_MaxW-WorkArea%scr_Monitor%Width)/2 : WorkArea%scr_Monitor%Left)
		If (scr_MaxT < WorkArea%scr_Monitor%Top)
			scr_MaxT := ( (scr_NewBase=1) ? (scr_MaxH-WorkArea%scr_Monitor%Height)/2 : WorkArea%scr_Monitor%Top)
		If (scr_MaxW > WorkArea%scr_Monitor%Width)
			scr_MaxW := ( (scr_NewBase=1) ? WorkArea%scr_Monitor%Width : WorkArea%scr_Monitor%Width)
		If (scr_MaxH > WorkArea%scr_Monitor%Height)
			scr_MaxH := ( (scr_NewBase=1) ? WorkArea%scr_Monitor%Height : WorkArea%scr_Monitor%Height)
	}
	Else If scr_NewBase = 1
	{
		scr_MaxL = 0
		scr_MaxT = 0
	}
}

scr_func_CorrectFullScreenScreenCoord(Window, ByRef nL, ByRef nT, ByRef nW, ByRef nH, NewBase=0)
{
	Global MonitorAreaLeft, MonitorAreaTop, MonitorAreaBottom, MonitorAreaRight, MonitorAreaHeight, MonitorAreaWidth
	WinGet, MinMax, MinMax, %Window%
	WinGet, Style, Style, %Window%
	If (MinMax = 1 AND (Style & 0x40000))
	{
		If (nL < MonitorAreaLeft)
			nL := ( (NewBase=1) ? MonitorAreaLeft-nL : MonitorAreaLeft)
		If (nT < MonitorAreaTop)
			nT := ( (NewBase=1) ? MonitorAreaTop-nT : MonitorAreaTop)
		If (nW > MonitorAreaWidth)
			nW := ( (NewBase=1) ? MonitorAreaWidth : MonitorAreaWidth)
		If (nH > MonitorAreaHeight)
			nH := ( (NewBase=1) ? MonitorAreaHeight : MonitorAreaHeight)
	}
	Else If NewBase = 1
	{
		nL = 0
		nT = 0
	}
}


; Michaels highlight Funktion
scr_func_highlight(left,top,width,height)
{
	Global scr_DisableTransparency2
	scr_DimID := GuiDefault("ScreenShotsDim","+AlwaysOnTop -Caption -Border +ToolWindow -Resize +Disabled")
	Gui, Color, FFFFFF
	If scr_DisableTransparency2 = 0
		WinSet,Transparent,196
	Gui, Show, X%left% Y%top% W%width% H%height% NA

	SetTimer, scr_CloseHighlight, 100
}
scr_CloseHighlight:
	SetTimer, scr_CloseHighlight, Off
	Gui, %GuiID_ScreenShotsDim%:Destroy
Return

scr_func_CaptureCursor(hDC, nL, nT)
{
	VarSetCapacity(mi, 20, 0)
	mi := Chr(20)
	DllCall("GetCursorInfo", "Uint", &mi)
	bShow := NumGet(mi, 4)
	hCursor := NumGet(mi, 8)
	xCursor := NumGet(mi,12)
	yCursor := NumGet(mi,16)

	VarSetCapacity(ni, 20, 0)
	DllCall("GetIconInfo", "Uint", hCursor, "Uint", &ni)
	xHotspot := NumGet(ni, 4)
	yHotspot := NumGet(ni, 8)
	hBMMask := NumGet(ni,12)
	hBMColor := NumGet(ni,16)

	If bShow
		DllCall("DrawIcon", "Uint", hDC, "int", xCursor - xHotspot - nL, "int", yCursor - yHotspot - nT, "Uint", hCursor)
	If hBMMask
		DllCall("DeleteObject", "Uint", hBMMask)
	If hBMColor
		DllCall("DeleteObject", "Uint", hBMColor)
}

scr_func_Zoomer(hDC, hBM, nW, nH, znW, znH)
{
	mDC1 := DllCall("CreateCompatibleDC", "Uint", hDC)
	mDC2 := DllCall("CreateCompatibleDC", "Uint", hDC)
	zhBM := DllCall("CreateCompatibleBitmap", "Uint", hDC, "int", znW, "int", znH)
	oBM1 := DllCall("SelectObject", "Uint", mDC1, "Uint", hBM)
	oBM2 := DllCall("SelectObject", "Uint", mDC2, "Uint", zhBM)
	DllCall("SetStretchBltMode", "Uint", mDC2, "int", 4)
	DllCall("StretchBlt", "Uint", mDC2, "int", 0, "int", 0, "int", znW, "int", znH, "Uint", mDC1, "int", 0, "int", 0, "int", nW, "int", nH, "Uint", 0x00CC0020)
	DllCall("SelectObject", "Uint", mDC1, "Uint", oBM1)
	DllCall("SelectObject", "Uint", mDC2, "Uint", oBM2)
	DllCall("DeleteDC", "Uint", mDC1)
	DllCall("DeleteDC", "Uint", mDC2)
	DllCall("DeleteObject", "Uint", hBM)
	Return zhBM
}

scr_func_Clip(hDC, hBM, nL, nT, nW, nH)
{
	mDC1 := DllCall("CreateCompatibleDC", "Uint", hDC)
	mDC2 := DllCall("CreateCompatibleDC", "Uint", hDC)
	zhBM := DllCall("CreateCompatibleBitmap", "Uint", hDC, "int", nW, "int", nH)
	oBM1 := DllCall("SelectObject", "Uint", mDC1, "Uint", hBM)
	oBM2 := DllCall("SelectObject", "Uint", mDC2, "Uint", zhBM)
	DllCall("BitBlt", "Uint", mDC2, "int", 0, "int", 0, "int", nW, "int", nH, "Uint", mDC1, "int", nL, "int", nT, "Uint", 0x40000000 | 0x00CC0020)
	DllCall("SelectObject", "Uint", mDC1, "Uint", oBM1)
	DllCall("SelectObject", "Uint", mDC2, "Uint", oBM2)
	DllCall("DeleteDC", "Uint", mDC1)
	DllCall("DeleteDC", "Uint", mDC2)
	DllCall("DeleteObject", "Uint", hBM)
	Return zhBM
}

scr_func_Convert(sFileFr = "", sFileTo = "")
{
	Global scr_JPGqualitiy
	If !sFileTo
		sFileTo := A_ScriptDir . "\screen.bmp"
	SplitPath, sFileTo, , , sExtTo

	hGdiPlus := DllCall("LoadLibrary", "str", "gdiplus.dll")
	If (hGdiPlus = 0 AND FileExist(A_ScriptDir "\library\gdiplus.dll"))
		hGdiPlus := DllCall("LoadLibrary", "str", A_ScriptDir "\library\gdiplus.dll")
	VarSetCapacity(si, 16, 0), si := Chr(1)
	DllCall("gdiplus\GdiplusStartup", "UintP", pToken, "Uint", &si, "Uint", 0)
	DllCall("gdiplus\GdipGetImageEncodersSize", "UintP", nCount, "UintP", nSize)
	VarSetCapacity(ci, nSize)
	DllCall("gdiplus\GdipGetImageEncoders", "Uint", nCount, "Uint", nSize, "Uint", &ci)

	Loop, %nCount%
	{
		If !InStr(scr_func_Ansi4Unicode(NumGet(ci, 76 * (A_Index - 1) + 44)), "." . sExtTo)
			Continue
		pCodec := &ci + 76 * (A_Index - 1)
		Break
	}

	If !sFileFr
	{
		DllCall("OpenClipboard", "Uint", 0)
		If DllCall("IsClipboardFormatAvailable", "Uint", 2) && (hBM:=DllCall("GetClipboardData", "Uint", 2))
			DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Uint", hBM, "Uint", 0, "UintP", pImage)
		DllCall("CloseClipboard")
	}
	Else If sFileFr Is Integer
		DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Uint", sFileFr, "Uint", 0, "UintP", pImage)
	Else
		DllCall("gdiplus\GdipLoadImageFromFile", "Uint", scr_func_Unicode4Ansi(wFileFr,sFileFr), "UintP", pImage)
	If pImage
	{
		If sExtTo = jpg
		{
			DllCall("gdiplus\GdipGetEncoderParameterListSize", "Uint", pImage, "Uint", pCodec, "UintP", xSize)
			VarSetCapacity(pi, xSize)
			DllCall("gdiplus\GdipGetEncoderParameterList", "Uint", pImage, "Uint", pCodec, "Uint", xSize, "Uint", &pi)

			VarSetCapacity(xParam, 4 + 28 + 4)

			xValue := scr_JPGqualitiy          ; JPEG Quality: 0 - 100
			NumPut(1, pi, 28)                  ; number of list
			;32 - 48                           ; 16 byte CLSID of Encoder
			NumPut(1, pi, 48)                  ; number of values
			NumPut(4, pi, 52)                  ; type of values
			NumPut(xValue, NumGet(pi,56))      ; address of the value
			xParam := &pi + 28
		}
		Else
			xParam = 0

		DllCall("gdiplus\GdipSaveImageToFile", "Uint", pImage, "Uint", scr_func_Unicode4Ansi(wFileTo,sFileTo), "Uint", pCodec, "Uint", xParam), DllCall("gdiplus\GdipDisposeImage", "Uint", pImage)
	}

	DllCall("gdiplus\GdiplusShutdown" , "Uint", pToken)
	DllCall("FreeLibrary", "Uint", hGdiPlus)
}

scr_func_SetClipboardData(hMem, nFormat = 2)
{
	Global NoOnClipboardChange
	DetectHiddenWindows, On
	Process, Exist
	WinGet, hAHK, ID, ahk_pid %ErrorLevel%
	NoOnClipboardChange = 1
	DllCall("OpenClipboard", "Uint", hAHK)
	DllCall("EmptyClipboard")
	DllCall("SetClipboardData", "Uint", nFormat, "Uint", hMem)
	NoOnClipboardChange = 0
	DllCall("CloseClipboard")
}

scr_func_Unicode4Ansi(ByRef wString, sString)
{
	nSize := DllCall("MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", 0, "int", 0)
	VarSetCapacity(wString, nSize * 2)
	DllCall("MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", &wString, "int", nSize)
	Return &wString
}

scr_func_Ansi4Unicode(pString)
{
	nSize := DllCall("WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "Uint", 0, "int", 0, "Uint", 0, "Uint", 0)
	VarSetCapacity(sString, nSize)
	DllCall("WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "str", sString, "int", nSize, "Uint", 0, "Uint", 0)
	Return sString
}
