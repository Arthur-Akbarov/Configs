; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               CharacterAid
; -----------------------------------------------------------------------------
; Prefix:             ca_
; Version:            0.8
; Date:               2008-05-07
; Author:             Michael Telgkamp, Eric Werner
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
;
; Idea for special character typing is taken from
; http://activaid.rumborak.de/task/785
; Additional Idea for implementation from Accents by Skrommel
; http://www.donationcoder.com/Software/Skrommel/
;
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_CharacterAid:
	Prefix = ca
	%Prefix%_ScriptName       = CharacterAid
	%Prefix%_ScriptVersion    = 0.8
	%Prefix%_Author           = Michael Telgkamp, Eric Werner

	IconFile_On_CharacterAid = %A_WinDir%\system32\charmap.exe
	IconPos_On_CharacterAid = 1

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		; Name des Menüeintrags im Tray-Menü
		MenuName                      = %ca_ScriptName% - Hilfe zum Tippen von Sonderbuchstaben
		; Beschreibung für den Erweiterungsmanager und den Konfigurationsdialog
		Description                   = Hilft, Sonderzeichen einfacher zu tippen.
		lng_ca_CharacterLists         = Zeichenlisten
		lng_ca_ListExplain            = Die Listen werden Zeichen für Zeichen durchgegangen.
		lng_ca_Timeout                = Zeit in Sekunden, nach der die Buchstabenliste wieder ausgeblendet wird:
		lng_ca_waitCount              = Anzahl der Tastendrücke ohne Aktivierung der Ersetzung:
		lng_ca_UseClipboardForOutput  = Fensterklassen für alternative`nAusgabe der Sonderzeichen:`n(Einfügen mit Strg+V)
		lng_ca_unsupportedCharacter   = Es wurde ein nicht unterstütztes Zeichen in einer Liste eingegeben.`n`nDie Liste des folgenden Buchstaben wurde nicht gespeichert:
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                      = %ca_ScriptName% - Helper to type special characters
		Description                   = Aids to type special characters more simple.
		lng_ca_CharacterLists         = Character lists
		lng_ca_ListExplain            = The lists are rotated character by character.
		lng_ca_Timeout                = Timeout in seconds for hiding the character list:
		lng_ca_waitCount              = Count of keypresses without activating replacement:
		lng_ca_UseClipboardForOutput  = Window classes for alternative`ncharacter output:`n(inserting with Ctrl+V)
		lng_ca_unsupportedCharacter   = There is an unsupported character in a list.`n`nThe list of the following character is not saved:
	}
	ca_CharacterList := ""
	Loop,30
	{
		if (a_index <= 20)
		{
			if (a_index = 1)
			{
				ca_This_Character = a
				ca_This_CharacterList = äâàáæå
			}
			if (a_index = 2)
			{
				ca_This_Character = e
				ca_This_CharacterList = ëêèé€
			}
			if (a_index = 3)
			{
				ca_This_Character = i
				ca_This_CharacterList = ïîìí|¦
			}
			if (a_index = 4)
			{
				ca_This_Character = o
				ca_This_CharacterList = öôòóøœ
			}
			if (a_index = 5)
			{
				ca_This_Character = u
				ca_This_CharacterList = üûùú
			}
			if (a_index = 6)
			{
				ca_This_Character = c
				ca_This_CharacterList = ç©¢
			}
			if (a_index = 7)
			{
				ca_This_Character = n
				ca_This_CharacterList = ñ
			}
			if (a_index = 8)
			{
				ca_This_Character = r
				ca_This_CharacterList = ®
			}
			if (a_index = 9)
			{
				ca_This_Character = s
				ca_This_CharacterList = ßš$
			}
			if (a_index = 10)
			{
				ca_This_Character = t
				ca_This_CharacterList = ™†‡
			}
			if (a_index = 11)
			{
				ca_This_Character = y
				ca_This_CharacterList = ýÿ¥
			}
			if (a_index = 12)
			{
				ca_This_Character = z
				ca_This_CharacterList = ž
			}
			if (a_index = 13)
			{
				ca_This_Character = 1
				ca_This_CharacterList = ¼½¾¹²³ª
			}
			if (a_index = 14)
			{
				ca_This_Character = ?
				ca_This_CharacterList = ¿
			}
			if (a_index = 15)
			{
				ca_This_Character = .
				ca_This_CharacterList = …•·
			}
			if (a_index = 16)
			{
				ca_This_Character = -
				ca_This_CharacterList = –—±¬¯
			}
			if (a_index = 17)
			{
				ca_This_Character = "
				; " end of qoute for syntax highlighting
				ca_This_CharacterList = „“”«»‹›
			}
			if (a_index = 18)
			{
				ca_This_Character = '
				ca_This_CharacterList = ‚‘’
			}
			if (a_index = 19)
			{
				ca_This_Character = !
				ca_This_CharacterList = ¡
			}
			if (a_index = 20)
			{
				ca_This_Character = L
				ca_This_CharacterList = £
			}
		}
		else
		{
				ca_This_Character =
				ca_This_CharacterList =
		}
		IniRead, ca_Character%a_index%, %ConfigFile%, %ca_ScriptName%, Character%a_index%, %ca_This_Character%
		if (ca_Character%a_index% = "" OR ca_Character%a_index% = "ERROR")
		{
			ca_NumOfCharacters := A_Index-1
			break
		}
		IniRead, ca_CharacterList%a_index%, %ConfigFile%, %ca_ScriptName%, CharacterList%a_index%, %ca_This_CharacterList%
		if ca_CharacterList%a_index% =
			ca_CharacterList%a_index% := ca_This_CharacterList
		IniRead, ca_Use%a_index%, %ConfigFile%, %ca_ScriptName%, Use%a_index%, 1
		ca_CharacterList := ca_CharacterList ca_Character%a_index%

	}
	IniRead, ca_timeout, %ConfigFile%, %ca_ScriptName%, Timeout, 2
	IniRead, ca_waitCount, %ConfigFile%, %ca_ScriptName%, waitCount, 2
	IniRead, ca_AlternativeOutputClasses, %ConfigFile%, %ca_ScriptName%, AlternativeOutputClasses, Emacs
	IniRead, ca_ExcludeApps, %ConfigFile%, %ca_ScriptName%, ExcludeApps, Calc.exe
Return

SettingsGui_CharacterAid:
	ca_GroupBoxHeight := Ceil(ca_NumOfCharacters/5)*22+30
	Gui, Add, GroupBox, xs+10 y+3 w550 h%ca_GroupBoxHeight%, %lng_ca_Characterlists% (%lng_ca_ListExplain%)

	Loop, %ca_NumOfCharacters%
	{
		ca_This_Character := ca_Character%a_index%
		ca_This_CharacterList := ca_CharacterList%a_index%
		ca_This_Use := ca_Use%a_index%
		if (ca_This_Use = "" OR ca_This_Character = "" OR ca_This_Character = "ERROR")
			Break
		ca_gui_position := mod((a_index-1),5)

		If(ca_gui_position = 0)
		{
			ca_gui_indent := "xs+25 yp+25"
		}
		else
		{
			ca_gui_indent := "xp+75 yp+3"
		}
		Gui, Add, Checkbox, %ca_gui_indent% -Wrap gsub_CheckIfSettingsChanged vca_Use%a_index% Checked%ca_This_Use%,%ca_This_Character%:
		Gui, Add, Edit,     xp+32  yp-3 -Wrap r1 w60 gsub_CheckIfSettingsChanged vca_CharacterList%a_index%, %ca_This_CharacterList%
	}
	Gui, Add, Text,       xs+10 y+25, %lng_ca_Timeout%
		Gui, Add, Edit,     x+10  yp-3 Number -Wrap r1 w40 gsub_CheckIfSettingsChanged vca_timeout, %ca_timeout%
	Gui, Add, Text,       xs+10 y+8, %lng_ca_waitCount%
		Gui, Add, Edit,     x+10  yp-3 Number -Wrap r1 w40 gsub_CheckIfSettingsChanged vca_waitCount, %ca_waitCount%
	Gui, Add, Text,       xs+10 y+8, %lng_ca_UseClipboardForOutput%

		ca_AlternativeOutputClasses_Tmp := ca_AlternativeOutputClasses
		Gui +Delimiter`,
		Gui, Add, ListBox, x+10 yp w250 R4 vca_AlternativeOutputClassesListBox,%ca_AlternativeOutputClasses_Tmp%
		Gui +Delimiter|

		Gui, Add, Button, x+5  yp+0 W21 gca_sub_addApp, +
		Gui, Add, Button, y+5 W21 gca_sub_subApp, -
Return

; wird aufgerufen, wenn im Konfigurationsdialog OK oder Übernehmen angeklickt wird
SaveSettings_CharacterAid:
	Loop,30
	{
		ca_This_Character := ca_Character%a_index%
		ca_This_CharacterList := ca_CharacterList%a_index%
		ca_This_Use := ca_Use%a_index%

		if (ca_This_Character = "" || ca_This_Character = "ERROR" || ca_This_CharacterList = "ERROR")
			break
		IfInString, ca_This_CharacterList,?
		{
			MsgBox, %lng_ca_unsupportedCharacter% %ca_This_Character%
			Reload = 1
		}
		else
		{
			IniWrite, %ca_This_Character%, %ConfigFile%, %ca_ScriptName%, Character%a_index%
			IniWrite, %ca_This_CharacterList%, %ConfigFile%, %ca_ScriptName%, CharacterList%a_index%
			IniWrite, %ca_This_Use%, %ConfigFile%, %ca_ScriptName%, Use%a_index%
		}
	}

	IniWrite, %ca_timeout%, %ConfigFile%, %ca_ScriptName%, Timeout
	IniWrite, %ca_waitCount%, %ConfigFile%, %ca_ScriptName%, waitCount
	IniWrite, %ca_UseClipboardForOutput%, %ConfigFile%, %ca_ScriptName%, UseClipboardForOutput

	; put all changes to the main AlternativeOutputClasses-list
	ca_AlternativeOutputClasses := ca_AlternativeOutputClasses_Tmp
	IniWrite, %ca_AlternativeOutputClasses%, %ConfigFile%, %ca_ScriptName%, AlternativeOutputClasses
	IniWrite, %ca_ExcludeApps%, %ConfigFile%, %ca_ScriptName%, ExcludeApps
Return

; wird beim Abbrechen des Konfigurationsdialogs aufgerufen
CancelSettings_CharacterAid:
Return

; wird beim Aktivieren der Erweiterung aufgerufen
DoEnable_CharacterAid:
	ca_CharacterAidEnabled := 1
	ca_timeoutMS := (ca_timeout * 1000)
	SetTimer, ca_Sub_InputLoop, 100
	GoSub,ca_tim_ChangeActiveOff
Return

; wird beim Deaktivieren der Erweiterung und auch vor dem Speichern der Einstellungen aufgerufen
DoDisable_CharacterAid:
	ca_CharacterAidEnabled := 0
Return

; wird aufgerufen, wenn der Anwender die Erweiterung auf die Standard-Einstellungen zurücksetzt
DefaultSettings_CharacterAid:
	IniDelete, %ConfigFile%, %ca_ScriptName%
Return

; wird aufgerufen, wenn ac'tivAid beendet oder neu geladen wird.
OnExitAndReload_CharacterAid:
Return

Update_CharacterAid:
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------
ca_sub_IsTyped:
	WinGetClass, ca_actClass, A
	If ca_actClass in Shell_TrayWnd,Progman,WorkerW,BaseBar,DV2ControlHost
	{
		Return
	}

	ca_UpperCase := ( ca_KeyAsc>=65 && ca_KeyAsc<=90 )
	ca_CCL := ca_CharacterList%ca_This_Character_index% ca_Key
	ca_CharacterCount := mod((ca_TypeCount-ca_waitCount+1),StrLen(ca_CCL))
	ca_CurrentCharacterList := SubStr(ca_CCL,ca_CharacterCount)SubStr(ca_CCL,1,ca_CharacterCount-1)
	if (ca_UpperCase)
	{
		StringUpper,ca_CurrentCharacterList,ca_CurrentCharacterList
	}
	if (ca_TypeCount >= ca_waitCount)
	{
		ca_char:=SubStr(ca_CurrentCharacterList,1,1)
		if (ca_TypeCount = ca_waitCount)
		{
			ca_tempSendCount := ca_waitCount + 1
			ca_Keys =
			Loop, %ca_tempSendCount%
				ca_Keys := ca_Keys ca_Key
		}
		else
		{
			ca_tempSendCount := 2
			ca_Keys := SubStr(ca_CurrentCharacterList,0) ca_Key
		}

		IfInString, ca_AlternativeOutputClasses, %ca_actClass%
		{
			If (aa_osversionnumber >= aa_osversionnumber_vista)
				Send +{Left  %ca_tempSendCount% }
			Else
				SendPlay +{Left  %ca_tempSendCount% }
			func_GetSelection()
			if(Selection = ca_Keys)
			{
				ca_ClipSaved := ClipboardAll   ; Save the clipboard.
				Clipboard = %ca_char%
				If (aa_osversionnumber >= aa_osversionnumber_vista)
					Send ^v
				Else
					SendPlay ^v
				Clipboard := ca_ClipSaved   ; Restore the original clipboard.
				ca_ClipSaved =   ; Free the memory.
			}
			else
			{
	 Tooltip,ca_Keys = %ca_Keys%
	 sleep,1000
				If (aa_osversionnumber >= aa_osversionnumber_vista)
					Send {Right}
				Else
					SendPlay {Right}
				GoSub,ca_tim_ChangeActiveOff
				Return
			}
		}
		else
		{
			If (aa_osversionnumber >= aa_osversionnumber_vista)
				Send {bs %ca_tempSendCount%}{Raw}%ca_char%
			Else
				SendPlay {bs %ca_tempSendCount%}{Raw}%ca_char%
		}
	}
	ca_CurrentCharacterList := SubStr(ca_CurrentCharacterList,2)
	ca_CurrentCharacterListDisp := RegExReplace(ca_CurrentCharacterList, "(.)", "$1 ")
	AutoTrim, On
	ca_CurrentCharacterListDisp = %ca_CurrentCharacterListDisp%
	if(ca_typeCount >= ca_waitCount-1)
		tooltip, %ca_CurrentCharacterListDisp%,% A_CaretX,% A_CaretY-20
Return

ca_Sub_InputLoop:
	If (LoadingFinished <> 1 OR MainGuiBuildTime <> "")
	{
		SetTimer, ca_Sub_InputLoop, 100
		Return
	}
	SetTimer, ca_Sub_InputLoop, Off
	Loop
	{
		If ca_CharacterAidEnabled = 0
		{
			Return
		}
		Input, ca_I_Key, L1 V I,{Home}{End}{PgUp}{PgDn}{Tab}{Left}{Right}{Backspace},

		WinGet, ca_ProcName, ProcessName, A

		If ca_ExcludeApps <>
			If ca_ProcName in %ca_ExcludeApps%
				 continue

		ca_KeyAsc := ASC(ca_I_Key)
		If (ca_KeyAsc = ca_PrevKeyAsc && (ca_KeyAsc>=32 && ca_KeyAsc<=126))
		{
			ca_This_Character_index := InStr(ca_CharacterList,ca_I_Key)
			If(ca_This_Character_index>0 && ca_Use%ca_This_Character_index%)
			{
				ca_TypeCount++
				ca_Key := ca_I_Key
				GoSub,ca_sub_IsTyped
			}
			else
			{
				GoSub,ca_tim_ChangeActiveOff
			}
		}
		else
		{
			GoSub,ca_tim_ChangeActiveOff
		}
		ca_PrevKeyAsc := ca_KeyAsc
		SetTimer, ca_tim_ChangeActiveOff, %ca_timeoutMS%
	}
Return

ca_tim_ChangeActiveOff:
	ca_TypeCount = 0
	ca_Key =
	ca_PrevKeyAsc =
	ca_UpperCase =
	ca_CurrentCharacterList =
	ca_This_Character_index =
	SetTimer, ca_tim_ChangeActiveOff, Off
	Tooltip
Return

ca_tim_GetClass:
	MouseGetPos,,,ca_getId,ca_getClass
	WinGetClass, ca_getClass, ahk_id %ca_getId%
	If ca_getClass =
		WinGetClass,ca_getClass,A
	ToolTip, %ca_getClass%
Return

; collects exclude window-classes
; waits for the user to select a window and hit enter
ca_sub_addApp:
	WinSet,Bottom,, %ScriptTitle%
	SplashImage,,b1 cwFFFF80 FS9 WS700, %lng_AddApps%
	Gui,+Disabled
	Input,ca_GetKey,,{Enter}{ESC}
	StringReplace,ca_GetKey,ErrorLevel,Endkey:
	SplashImage, Off
	Gui,-Disabled
	WinGetClass, ca_GetName, A

	If ca_Getkey = Enter
	{
		IfNotInstring, ca_AlternativeOutputClasses_Tmp, %ca_GetName%
		{
			If (ca_AlternativeOutputClasses_Tmp != "")
				ca_AlternativeOutputClasses_Tmp := ca_AlternativeOutputClasses_Tmp "," ca_GetName
			Else
				ca_AlternativeOutputClasses_Tmp := ca_GetName

			Gui +Delimiter`,
			GuiControl,, ca_AlternativeOutputClassesListBox,,%ca_AlternativeOutputClasses_Tmp%
			Gui +Delimiter|
		}
	}
	Gui,Show
	WinSet, Top, , %ScriptTitle%
	func_SettingsChanged("CharacterAid")
Return

; takes the selected item from the ignore list
ca_sub_subApp:
	GuiControlGet, ca_selItem,, ca_AlternativeOutputClassesListBox
	StringSplit, ca_AlternativeOutputClasses_List, ca_AlternativeOutputClasses_Tmp,`,
	ca_AlternativeOutputClasses_Tmp =
	Loop, %ca_AlternativeOutputClasses_List0%
	{
		ca_thisItem := ca_AlternativeOutputClasses_List%A_Index%
		If (ca_thisItem != ca_selItem)
		{
			If (ca_AlternativeOutputClasses_Tmp != "")
				ca_AlternativeOutputClasses_Tmp := ca_AlternativeOutputClasses_Tmp "," ca_thisItem
			Else
				ca_AlternativeOutputClasses_Tmp := ca_thisItem
		}
		Else
			func_SettingsChanged("CharacterAid")
	}
	Gui +Delimiter`,
	GuiControl,, ca_AlternativeOutputClassesListBox,,%ca_AlternativeOutputClasses_Tmp%
	Gui +Delimiter|
Return
