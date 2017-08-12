; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               EmptyRecycler
; -----------------------------------------------------------------------------
; Prefix:             ery_
; Version:            0.3
; Date:               2006-07-28
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_EmptyRecycler:

	Prefix = ery
	%Prefix%_ScriptName    = EmptyRecycler
	%Prefix%_ScriptVersion = 0.3
	%Prefix%_Author        = Wolfgang Reszel
	RequireExtensions      =
	AddSettings_EmptyRecycler =

	CustomHotkey_EmptyRecycler = 1
	Hotkey_EmptyRecycler       = ^#Del
	HotkeyPrefix_EmptyRecycler = ~

	IconFile_On_EmptyRecycler = %A_WinDir%\system32\shell32.dll
	IconPos_On_EmptyRecycler = 32

	HideSettings = 0

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                       = %ery_ScriptName% - Papierkorb leeren
		Description                    = Entleert den Papierkorb mittels eines Tastaturkürzels.
		lng_ery_Recycler               = Papierkorb
		lng_ery_EmptyRecyclerAsk       = Sollen alle Elemente im Papierkorb wirklich gelöscht werden?
		lng_ery_EmptyRecycler          = Papierkorb leeren ...
		lng_ery_EmptyRecyclerHotkey    = Papierkorb leeren (nur wenn Explorer, Desktop oder Taskleiste aktiv ist)
		lng_ery_OnlyExplorer           = Tastaturkürzel gilt nur, wenn der Explorer aktiv ist
		lng_ery_Confirmation           = Sicherheitsabfrage
		lng_ery_Error                  = Beim Entleeren des Papierkorbs ist ein Fehler aufgetreten, vermutlich konnten nicht alle Dateien und Ordner gelöscht werden.
		lng_ery_Empty                  = Der Papierkorbs ist bereits leer!
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhaeryn)
	{
		MenuName                       = %ery_ScriptName% - Empty recycle bin
		Description                    = Empty the recycle bin with a hotkey.
		lng_ery_Recycler               = Recycle Bin
		lng_ery_EmptyRecyclerAsk       = Delete all objects in the recycle bin?
		lng_ery_EmptyRecycler          = Empty recycle bin ...
		lng_ery_EmptyRecyclerHotkey    = Empty recycle bin (only if Explorer, Desktop or Taskbar is active)
		lng_ery_OnlyExplorer           = Hotkey only available in Explorer
		lng_ery_Confirmation           = Confirmation
		lng_ery_Error                  = An error occured whily emptying the recycle bin, maybe some files or folders can't be deleted.
		lng_ery_Empty                  = The recycle bin is empty already!
	}

	RegRead, ery_Recycler, HKEY_LOCAL_MACHINE,SOFTWARE\Classes\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}
	If ery_Recycler <>
		lng_ery_Recycler = %ery_Recycler%

	IniRead, ery_OnlyExplorer, %ConfigFile%, EmptyRecycler, OnlyExplorer, 1
	IniRead, ery_Confirmation, %ConfigFile%, EmptyRecycler, Confirmation, 1
Return

SettingsGui_EmptyRecycler:
	Gui, Add, CheckBox, -Wrap xs+10 y+5 gsub_CheckIfSettingsChanged very_OnlyExplorer Checked%ery_OnlyExplorer%, %lng_ery_OnlyExplorer%
	Gui, Add, CheckBox, -Wrap xs+10 y+5 gsub_CheckIfSettingsChanged very_Confirmation Checked%ery_Confirmation%, %lng_ery_Confirmation%
Return

SaveSettings_EmptyRecycler:
	IniWrite, %ery_OnlyExplorer%, %ConfigFile%, EmptyRecycler, OnlyExplorer
	IniWrite, %ery_Confirmation%, %ConfigFile%, EmptyRecycler, Confirmation
Return

; Wird aufgerufen, wenn Einstellungen über das 'Pfeil'-Menü hinzugefügt werden, ist nur notwendig wenn AddSettings_EmptyRecycler = 1
AddSettings_EmptyRecycler:
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_EmptyRecycler:
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_EmptyRecycler:
	; func_HotkeyEnable("ery_HOTKEYNAME")
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern der Einstellungen aufgerufen
DoDisable_EmptyRecycler:
	; func_HotkeyDisable("ery_HOTKEYNAME")
Return

; wird aufgerufen, wenn der Anweeryr die Erweiterung auf die Standard-Einstellungen zurücksetzt
DefaultSettings_EmptyRecycler:
Return

; wird aufgerufen, wenn ac'tivAid beeeryt oder neu geladen wird.
OnExitAndReload_EmptyRecycler:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

sub_Hotkey_EmptyRecycler:
	WinGetClass, ery_Class, A
	If ery_OnlyExplorer = 1
		If ery_Class not in ExploreWClass,CabinetWClass,Progman,Shell_TrayWnd
			Return
	Gosub, ery_sub_EmptyRecycler
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

ery_sub_EmptyRecycler:
	if not QueryRecycleBin()
	{
		BalloonTip(ery_ScriptName, lng_ery_Empty)
		return
	}

	if ery_Confirmation = 1
		MsgBox, 52, %lng_ery_Recycler%, %lng_ery_EmptyRecyclerAsk%
			IfMsgBox, No
				Return

	SplashImage,,FS9 A T M C00, %lng_ery_EmptyRecycler%,,%lng_ery_Recycler%
	FileRecycleEmpty
	If ErrorLevel =  1
		BalloonTip(ery_ScriptName, lng_ery_Error,"Error",0,0,20)
	Sleep,100
	SplashImage, Off
Return

; -----------------------------------------------------------------------------
; recycler query function from SKAN - THANKS!
; http://www.autohotkey.com/forum/viewtopic.php?p=452252&sid=9885b78b70702d3cc626d851335e3a67#452252
; -----------------------------------------------------------------------------
QueryRecycleBin( GetFileCount=1 ) {
	NumPut( VarSetCapacity( SHQUERYRBINFO,20,0 ), SHQUERYRBINFO )
	DllCall( "Shell32\SHQueryRecycleBinA", Int,0, UInt,&SHQUERYRBINFO )
	Return NumGet( SHQUERYRBINFO, GetFileCount ? 12 : 4,"Int64" )
}