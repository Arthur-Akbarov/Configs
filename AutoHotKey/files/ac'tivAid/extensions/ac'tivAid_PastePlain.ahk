; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               PastePlain
; -----------------------------------------------------------------------------
; Prefix:             pp_
; Version:            0.7.1
; Date:               2008-05-23
; Author:             Wolfgang Reszel, Michael Telgkamp
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

init_PastePlain:
	Prefix = pp
	%Prefix%_ScriptName    = PastePlain
	%Prefix%_ScriptVersion = 0.7.1
	%Prefix%_Author        = Wolfgang Reszel, Michael Telgkamp

	CustomHotkey_PastePlain = 1    ; Benutzerdefiniertes Hotkey
	Hotkey_PastePlain       = #v   ; Standard-Hotkey
	HotkeyPrefix_PastePlain = $    ; Hook

	IconFile_On_PastePlain = %A_WinDir%\system32\shell32.dll
	IconPos_On_PastePlain  = 134

	if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                      = %pp_ScriptName% - Zwischenablage ohne Metainformationen einfügen
		Description                   = Fügt den Inhalt der Zwischenablage ohne Metainformationen wie z.B. Formatierungen (Fett, Kursiv) ein.
		lng_pp_RemoveStrings          = Zeichenfolgen, die vor dem Einfügen entfernt werden sollen (jede Zeile entspricht einer Zeichenfolge)
		lng_pp_CopyPlain              = Kopieren statt Einfügen
		lng_pp_NoCRLF                 = Ohne Zeilenumbrüche
		lng_pp_RemoveDoubleSpace      = Tabulatoren und Doppelte Leerzeichen durch einfache Leerzeichen ersetzen
		lng_pp_RestoreClipboard       = Alten Zwischenablageninhalt nach dem Einfügen wiederherstellen (gilt nicht für Adobe-Anwendungen)
		lng_pp_Pasting                = Einfügen ...
		lng_pp_PasteMultiLine         = Die Zwischenablage enthält Zeilenumbrüche.`nDas führt dazu, dass jede Zeile als eigenständiger Befehl ausgeführt wird.
		lng_pp_AutoTrim               = Leerzeichen am Zeilenanfang und -ende entfernen (AutoTrim)
		tooltip_pp_CopyPlain          = Aus`tDas angegebene Kürzel fügt den Inhalt der Zwischenablage ohne Metainformationen an der aktuellen Cursor-Position ein`nAn`tDas angegebene Kürzel kopiert den markierten Text ohne Metainformationen in die Zwischenablage (CopyPlain)
	}
	else        ; = other languages (english)
	{
		MenuName                      = %pp_ScriptName% - paste plain text
		Description                   = Pastes the content of the clipboard without meta-information (e.g. formattings like bold or italic)
		lng_pp_RemoveStrings          = Strings to remove before pasting (each line is a separate string)
		lng_pp_CopyPlain              = Copy instead of Paste
		lng_pp_NoCRLF                 = Without line breaks
		lng_pp_RemoveDoubleSpace      = Replace tabs and double whitespaces with single whitespaces
		lng_pp_RestoreClipboard       = Restore Clipboard after paste (in Adobe applications this is never the case)
		lng_pp_Pasting                = Pasting ...
		lng_pp_PasteMultiLine         = The Clipboard contains linebreaks, so every line will be executed as a separate command.
		lng_pp_AutoTrim               = Autotrim white spaces on every line beginning and end
		tooltip_pp_CopyPlain          = Off`tPastes the content of the clipboard without meta-information at the cursor position`nOn`tCopies the selected text without meta-information into the clipboard (CopyPlain)
	}
	pp_checkregex := "^/([^/]*[^\\/])/(.*)/$"
	If CustomLanguage <>
		gosub, CustomLanguage

	IniRead, pp_RemoveStrings, %ConfigFile%, %pp_ScriptName%, RemoveStrings
	If pp_RemoveStrings = ERROR
		pp_RemoveStrings =

	IniRead, pp_CopyPlain, %ConfigFile%, %pp_ScriptName%, CopyPlain, 0
	IniRead, pp_CopyPlainNoCRLF, %ConfigFile%, %pp_ScriptName%, CopyPlainNoCRLF, 0
	IniRead, pp_RemoveDoubleSpace, %ConfigFile%, %pp_ScriptName%, RemoveDoubleSpace, 0
	IniRead, pp_RestoreClipboard, %ConfigFile%, %pp_ScriptName%, RestoreClipboard, 1
	IniRead, pp_AutoTrim, %ConfigFile%, %pp_ScriptName%, AutoTrim, 1

	func_HotkeyRead( "pp_NoCRLF", ConfigFile, pp_ScriptName, "Hotkey_NoCRLF", "pp_sub_NoCRLF", "#+v" )
	If (!InStr(pp_RemoveStrings, "##AADCR##") AND !InStr(pp_RemoveStrings,"/") AND !InStr(pp_RemoveStrings,"\|"))
		StringReplace, pp_RemoveStrings, pp_RemoveStrings, |, `n, All
	StringReplace, pp_RemoveStrings, pp_RemoveStrings, ##AADCR##, `n, All
Return

SettingsGui_PastePlain:
	Gui, Add, CheckBox, -Wrap x+5 yp+4 vpp_CopyPlain gsub_CheckIfSettingsChanged Checked%pp_CopyPlain%, %lng_pp_CopyPlain%
	Gui, Add, CheckBox, -Wrap xs+10 y+5 vpp_AutoTrim gsub_CheckIfSettingsChanged Checked%pp_AutoTrim%, %lng_pp_AutoTrim%
	func_HotkeyAddGuiControl( lng_pp_NoCRLF, "pp_NoCRLF", "xs+10 y+20" )
	Gui, Add, CheckBox, -Wrap x+5 yp+4 vpp_CopyPlainNoCRLF gsub_CheckIfSettingsChanged Checked%pp_CopyPlainNoCRLF%, %lng_pp_CopyPlain%
	Gui, Add, CheckBox, -Wrap xs+10 y+5 vpp_RemoveDoubleSpace gsub_CheckIfSettingsChanged Checked%pp_RemoveDoubleSpace%, %lng_pp_RemoveDoubleSpace%
	Gui, Add, Text, xs+10 y+15, %lng_pp_RemoveStrings%:
	Gui, Add, Edit, y+5 R8 vpp_RemoveStrings w540 gsub_CheckIfSettingsChanged, %pp_RemoveStrings%
	Gui, Add, CheckBox, -Wrap xs+10 y+10 vpp_RestoreClipboard gsub_CheckIfSettingsChanged Checked%pp_RestoreClipboard%, %lng_pp_RestoreClipboard%
Return

SaveSettings_PastePlain:
	StringReplace, pp_RemoveStrings, pp_RemoveStrings, `n, ##AADCR##, All
	IniWrite, %pp_RemoveStrings%, %ConfigFile%, %pp_ScriptName%, RemoveStrings
	IniWrite, %pp_CopyPlain%, %ConfigFile%, %pp_ScriptName%, CopyPlain
	IniWrite, %pp_CopyPlainNoCRLF%, %ConfigFile%, %pp_ScriptName%, CopyPlainNoCRLF
	IniWrite, %pp_RemoveDoubleSpace%, %ConfigFile%, %pp_ScriptName%, RemoveDoubleSpace
	IniWrite, %pp_RestoreClipboard%, %ConfigFile%, %pp_ScriptName%, RestoreClipboard
	IniWrite, %pp_AutoTrim%, %ConfigFile%, %pp_ScriptName%, AutoTrim
	func_HotkeyWrite( "pp_NoCRLF", ConfigFile, pp_ScriptName, "Hotkey_NoCRLF")
	StringReplace, pp_RemoveStrings, pp_RemoveStrings, ##AADCR##, `n, All
Return

CancelSettings_PastePlain:
Return

DoEnable_PastePlain:
	func_HotkeyEnable("pp_NoCRLF")
Return

DoDisable_PastePlain:
	func_HotkeyDisable("pp_NoCRLF")
Return

DefaultSettings_PastePlain:
Return

; -----------------------------------------------------------------------------
; === Hotkeys =================================================================
; -----------------------------------------------------------------------------

sub_Hotkey_PastePlain:
	If Enable_PastePlain = 1
	{
		pp_CopyPlain_tmp = %pp_CopyPlain%
		pp_NoCRLF_tmp = 0
		Gosub, pp_main_PastePlain_paste
	}
	Else
		Send, % func_PrepareHotkeyForSend(pp_LastHotkey)
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------

; Textversion der Zwischenablage einfügen
pp_sub_NoCRLF:
	If Enable_PastePlain = 1
	{
		pp_CopyPlain_tmp = %pp_CopyPlainNoCRLF%
		pp_NoCRLF_tmp = 1
		Gosub, pp_main_PastePlain_paste
	}
	Else
		Send, % func_PrepareHotkeyForSend(pp_LastHotkey)
Return

pp_main_PastePlain_paste:
	;Critical
	NoOnClipboardChange = 1
	WinGetClass, pp_ActClass, A
	; Wenn ein Konsolenanwendung, dann die Zwischenablage Zeichen für Zeichen senden
	If pp_ActClass in PuTTY,ConsoleWindowClass,ytWindow
	{
		pp_text = %Clipboard%

		If pp_AutoTrim = 1
			pp_text := RegexReplace(pp_text,"sm`a)\s*$|^\s*","")

		Loop, Parse, pp_RemoveStrings, `n
		{
			If (RegexMatch(A_LoopField,pp_checkregex))
			{
				RegexMatch(A_LoopField,pp_checkregex,pp_RegMatch)
				pp_text := RegexReplace(pp_text, pp_RegMatch1, pp_RegMatch2)
			}
			Else
				StringReplace, pp_text, pp_text, %A_LoopField% ,,A
		}
		If pp_NoCRLF_tmp = 1
		{
			StringReplace, pp_text, pp_text, `r`n, `n, A
			StringReplace, pp_text, pp_text, %A_Space%`n, %A_Space%, A
			StringReplace, pp_text, pp_text, `n, %A_Space%, A
			If pp_RemoveDoubleSpace = 1
			{
				StringReplace, pp_text, pp_text, %A_Tab%, %A_Space%, A
				Loop
				{
					StringReplace, pp_text, pp_text, %A_Space%%A_Space%, %A_Space%, A
					If ErrorLevel = 1
						Break
				}
			}
		}

		pp_MsgBox = 1
		If pp_text contains `n,`r
		{
			pp_Code =
			Loop, Parse, pp_text, `n, `r
			{
				If A_Index > 5
					break
				AutoTrim, On
				pp_LoopField = %A_LoopField%
				pp_Code = %pp_Code%`n%A_Index%: %pp_LoopField%
			}
			pp_Code := pp_Code "`n..."

			MsgBox, 17, %pp_ScriptName%, %lng_pp_PasteMultiLine%`n%pp_Code%
			IfMsgBox, Cancel
				pp_MsgBox = 0
		}
		If pp_MsgBox = 1
		{
			; Code von Thomas Geißenhöner
			Loop, Parse, pp_text
			{
				TG_CT_char :=Asc(A_LoopField)
				If TG_CT_char in 123,125,94,33   ,43,35,13,10
				{
					If TG_CT_char in 10,13
					{
						If (TG_CT_13_10 = 2)
						{
							Continue
						}
						TG_CT_13_10 = 2
						Send, {enter}{HOME}
						Continue
					}
					TG_CT_13_10 = 1
					Send, {%A_LoopField%}
					Continue
				}
				Else
				{
					TG_CT_13_10 = 1
					Send, %A_LoopField%
					continue
				}
			}
		}
	}
	; Sonst die Zwischenablage normal senden (keine Konsolenanwendung)
	Else
	{
		SetKeyDelay, 30,30
		If pp_CopyPlain_tmp = 1
		{
			func_GetSelection(1,0,1)
			pp_text = %Selection%
			Sleep, 30

			If pp_AutoTrim = 1
				pp_text := RegexReplace(pp_text,"m)^[ \t]+|[ \t]+$","")

			Loop, Parse, pp_RemoveStrings, `n
			{
				If (RegexMatch(A_LoopField,pp_checkregex))
				{
					RegexMatch(A_LoopField,pp_checkregex,pp_RegMatch)
					pp_text := RegexReplace(pp_text, pp_RegMatch1, pp_RegMatch2)
				}
				Else
					StringReplace, pp_text, pp_text, %A_LoopField% ,,A
			}
			If pp_NoCRLF_tmp = 1
			{
				StringReplace, pp_text, pp_text, `r`n, `n, A
				StringReplace, pp_text, pp_text, %A_Space%`n, %A_Space%, A
				StringReplace, pp_text, pp_text, `n, %A_Space%, A
				If pp_RemoveDoubleSpace = 1
				{
					StringReplace, pp_text, pp_text, %A_Tab%, %A_Space%, A
					Loop
					{
						StringReplace, pp_text, pp_text, %A_Space%%A_Space%, %A_Space%, A
						If ErrorLevel = 1
							Break
					}
				}
			}
			Clipboard =
			Sleep, 10
			Clipboard = %pp_text%
		}
		Else
		{
			WinGet, pp_ID, ID, A
			WinGetTitle, pp_Title, A

			SplashImage,,b1 cwFFFFc0 FS10 w150, %lng_pp_Pasting%

			pp_Cursor = %A_Cursor%

			pp_hCurs := DllCall("LoadCursor","UInt",NULL, "Int", IDC_WAIT, "UInt")
			If pp_Cursor = Unknown
				DllCall("SetSystemCursor", "Uint", pp_hCurs, "Int", IDC_ARROW, "UInt")
			Else
				DllCall("SetSystemCursor", "Uint", pp_hCurs, "Int", IDC_%pp_Cursor%, "UInt")

			Sleep, 10

			If pp_RestoreClipboard = 1
				pp_ClipTemp := ClipboardAll

			Sleep, 10

	;      If pp_Title contains Adobe
	;      {
	;         Gui, 99:Show, x-1000 y-1000 w10 h10
	;         Sleep, 20
	;      }

			pp_text = %Clipboard%

			Clipboard =

			Loop, Parse, pp_RemoveStrings, `n
			{
				If (RegexMatch(A_LoopField,pp_checkregex))
				{
					RegexMatch(A_LoopField,pp_checkregex,pp_RegMatch)
					pp_text := RegexReplace(pp_text, pp_RegMatch1, pp_RegMatch2)
				}
				Else
					StringReplace, pp_text, pp_text, %A_LoopField% ,,A
			}
			If pp_NoCRLF_tmp = 1
			{
				StringReplace, pp_text, pp_text, `r`n, `n, A
				StringReplace, pp_text, pp_text, %A_Space%`n, %A_Space%, A
				StringReplace, pp_text, pp_text, `n, %A_Space%, A
				If pp_RemoveDoubleSpace = 1
				{
					StringReplace, pp_text, pp_text, %A_Tab%, %A_Space%, A
					Loop
					{
						StringReplace, pp_text, pp_text, %A_Space%%A_Space%, %A_Space%, A
						If ErrorLevel = 1
							Break
					}
				}
			}

			Sleep, 10

			If pp_AutoTrim = 1
			{
				pp_text := RegexReplace(pp_text,"m)^[ \t]+|[ \t]+$","")
			}

			Clipboard := pp_text
			ClipWait, 2

	;      If pp_Title contains tAdobe
	;      {
	;         Gui, 99:Destroy
	;         Sleep,20
	;         IfWinNotActive, ahk_id %pp_ID%
	;            WinActivate, ahk_id %pp_ID%
	;         WinWaitActive, ahk_id %pp_ID%,, 0.5
	;      }

			SendEvent, ^v

			If pp_Cursor = Unknown
				DllCall("SetSystemCursor", "Uint", pp_hCurs, "Int", IDC_ARROW, "UInt")
			Else
				DllCall("SetSystemCursor", "Uint", pp_hCurs, "Int", IDC_%pp_Cursor%, "UInt")
			DllCall("DestroyCursor","Uint",pp_hCurs)

			SplashImage, Off

			If pp_RestoreClipboard = 1
			{
				Sleep,300
				Clipboard = %pp_ClipTemp%
			}
		}
	}
	NoOnClipboardChange =
Return
