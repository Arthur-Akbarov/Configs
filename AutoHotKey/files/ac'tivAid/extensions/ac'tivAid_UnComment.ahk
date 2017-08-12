; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               UnComment
; -----------------------------------------------------------------------------
; Prefix:             uc_
; Version:            0.4.1
; Date:               2008-05-23
; Author:             jla
;                     (mit freundlicher Unterstützung von denick
;                     aus dem deutschen Autohotkeyforum)
;                     kleine Änderungen : Eric Werner
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; === Initialisation ==========================================================
; -----------------------------------------------------------------------------

; Initialisierungsroutine, welche beim Start von ac'tivAid aufgerufen wird.
init_UnComment:
	Prefix = uc
	%Prefix%_ScriptName    = UnComment
	%Prefix%_ScriptVersion = 0.4.1
	%Prefix%_Author        = jla
	CreateGuiID("UnComment")  ; nächste freie GUI-ID in %GuiID_UnComment% ablegen und Close/Escape-Label

	IconFile_On_UnComment = %A_WinDir%\system32\shell32.dll
	IconPos_On_UnComment = 134

	; Sprachabhängige Variablen
	If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
	{
		MenuName                        = %uc_ScriptName% - markierten Bereich auskommentieren
		Description                     = Stellt einem markierten Bereich Kommentarzeichen voran oder entfernt diese wieder.
		lng_uc_Comment                  = Markierung auskommentieren
		lng_uc_Uncomment                = Kommentarzeichen entfernen
		lng_uc_toggleCommentCheck       = Kommentar an/ausschalten
		lng_uc_SelectAfterwards         = Markierung wiederherstellen
		lng_uc_CommentString            = Kommentarzeichen
		lng_uc_noSelChangeCommentString = nach Änderung fragen wenn nichts markiert ist
		lng_uc_changeCommentStringQuery = Kommentarzeichen ändern?
		lng_uc_changeCommentStringMessage = Es ist nichts markiert. Möchten sie das Kommentarzeichen ändern?
		lng_uc_useSendInput				= SendInput benutzen
	}
	else        ; = Alternativ-Sprache (wenn nicht Deutsch und keine language.ini vorhanden)
	{
		MenuName                        = %uc_ScriptName% - (un)comment selection
		Description                     = Adds or removes comment characters to the selected text.
		lng_uc_Comment                  = Comment selection
		lng_uc_Uncomment                = Uncomment selection
		lng_uc_toggleCommentCheck       = toggle comment on/off
		lng_uc_SelectAfterwards         = restore selection
		lng_uc_CommentString            = comment characters
		lng_uc_noSelChangeCommentString = ask for change if nothing selected
		lng_uc_changeCommentStringQuery = Change comment characters?
		lng_uc_changeCommentStringMessage = There was nothing selected. Do you want to enter different comment characters?
		lng_uc_useSendInput				= use SendInput
	}

	func_HotkeyRead( "uc_Comment", ConfigFile , uc_ScriptName, "Comment", "uc_sub_Comment", "^!C" )    ; Ctrl+Alt+C
	func_HotkeyRead( "uc_Uncomment", ConfigFile , uc_ScriptName, "Uncomment", "uc_sub_Uncomment", "" ) ; off by default

	IniRead, uc_CommentString, %ConfigFile%, %uc_ScriptName%, CommentString, //
	IniRead, uc_toggleCommentCheck, %ConfigFile%, %uc_ScriptName%, ToggleCommentCheck, 1
	IniRead, uc_SelectAfterwards, %ConfigFile%, %uc_ScriptName%, SelectAfterwards, 1
	IniRead, uc_useSendInput, %ConfigFile%, %uc_ScriptName%, useSendInput, 0
	IniRead, uc_noSelChangeCommentString, %ConfigFile%, %uc_ScriptName%, NoSelChangeCommentString, 1
Return

SettingsGui_UnComment:
	Gui, Add, Text, xs+20 y+15, %lng_uc_CommentString%:
	Gui, Add, Edit, R1 x+5 yp-4 vuc_CommentString w30 gsub_CheckIfSettingsChanged, %uc_CommentString%
		Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged x+37 yp+5 vuc_noSelChangeCommentString Checked%uc_noSelChangeCommentString%, %lng_uc_noSelChangeCommentString%

	func_HotkeyAddGuiControl( lng_uc_Comment, "uc_Comment", "xs+20 y+15 w160" )
	func_HotkeyAddGuiControl( lng_uc_Uncomment, "uc_Uncomment", "xs+20 y+5 w160" )
		Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged vuc_toggleCommentCheck Checked%uc_toggleCommentCheck%, %lng_uc_toggleCommentCheck%
		Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged vuc_SelectAfterwards Checked%uc_SelectAfterwards%, %lng_uc_SelectAfterwards%
		Gui, Add, CheckBox, -Wrap gsub_CheckIfSettingsChanged vuc_useSendInput Checked%uc_useSendInput%, %lng_uc_useSendInput%
Return

SaveSettings_UnComment:
	func_HotkeyWrite( "uc_Comment", ConfigFile , uc_ScriptName, "Comment" )
	func_HotkeyWrite( "uc_Uncomment", ConfigFile , uc_ScriptName, "Uncomment" )

	IniWrite, %uc_CommentString%, %ConfigFile%, %uc_ScriptName%, CommentString
	IniWrite, %uc_toggleCommentCheck%, %ConfigFile%, %uc_ScriptName%, ToggleCommentCheck
	IniWrite, %uc_SelectAfterwards%, %ConfigFile%, %uc_ScriptName%, SelectAfterwards
	IniWrite, %uc_useSendInput%, %ConfigFile%, %uc_ScriptName%, useSendInput
	IniWrite, %uc_noSelChangeCommentString%, %ConfigFile%, %uc_ScriptName%, NoSelChangeCommentString
Return

AddSettings_UnComment:
Return

CancelSettings_UnComment:
Return

DoEnable_UnComment:
	func_HotkeyEnable("uc_Comment")
	func_HotkeyEnable("uc_Uncomment")
Return

DoDisable_UnComment:
	func_HotkeyDisable("uc_Comment")
	func_HotkeyDisable("uc_Uncomment")
Return

DefaultSettings_UnComment:
Return

OnExitAndReload_UnComment:
Return

; -----------------------------------------------------------------------------
; === Subroutines =============================================================
; -----------------------------------------------------------------------------
; Blockkommentar einfuegen
uc_sub_Comment:
	uc_CommentStringTmp = %uc_CommentString%%A_Space%     ; Einzufuegender String

	func_GetSelection(1, 0, 0.5)

	; ist nix markiert: abbrechen oder nach anderem Kommentarzeichen fragen:
	If (Selection == "")
	{
		If (uc_noSelChangeCommentString)
		{
			CoordMode, Caret, Screen
			InputBox, uc_CommentStringTmp, %lng_uc_changeCommentStringQuery%, %lng_uc_changeCommentStringMessage%,,250,150,% A_CaretX + 10,% A_CaretY + 10,,, %uc_CommentString%
			If ErrorLevel ; Esc oder Cancel gedrückt: abbrechen
				Return
			Else ; ansonsten : aus temp in richtige var schreiben, in die INI damit, ggf. UI ändern (apply-button wird leider aktiv)
				uc_CommentString := uc_CommentStringTmp
				IniWrite, %uc_CommentString%, %ConfigFile%, %uc_ScriptName%, CommentString
				GuiControl,, uc_CommentString,%uc_CommentString%
		}
		Return
	}

	; Zwischenablage zeilenweise abarbeiten
	Loop, parse, Selection, `n
	{
		; nur Zeilen, in denen auch was steht
		If (A_LoopField != "")
		{
			; Zeilen umbauen: wenn am Anfang uc_CommentString steht, entfernen, sonst einfuegen
			If ((uc_toggleCommentCheck) && (Substr(A_LoopField, 1, StrLen(uc_CommentStringTmp)) == uc_CommentStringTmp))
			{
				uc_NewLines .= SubStr(A_LoopField, StrLen(uc_CommentStringTmp) + 1) "`n"
			}
			Else
				uc_NewLines .= uc_CommentStringTmp A_LoopField "`n"
		}
		Else
		{
			uc_NewLines .= "`n"      ; Newline anhaengen
		}
	}
	StringTrimRight, uc_NewLines, uc_NewLines, 1 ; Ueberzaehliges Newline entfernen

	if ( uc_NoClipboardForOutput ) {
		sendplay % "{raw}"uc_NewLines
	} else {
 		uc_ClipSaved := ClipboardAll ; Save the clipboard.
 		Clipboard := ;clipboard leeren
 		Clipboard := uc_NewLines ; < wird manchmal ignoriert.. hmmm
 		ClipWait, 1 ; auf Clipboard Befüllung warten
		;sleep,10
		If uc_useSendInput
			SendInput ^v
		Else If (aa_osversionnumber >= aa_osversionnumber_vista)
			Send ^v
		Else
			SendPlay ^v
		Clipboard := uc_ClipSaved ; Restore the original clipboard.
		uc_ClipSaved =
	}
	If (uc_SelectAfterwards)
	{
		; snaky stolen from textAid:
		StringReplace,uc_tmp,uc_NewLines,`n,,UseErrorLevel
		uc_breaklinecount := ErrorLevel
		uc_tmp =
		uc_Len := StrLen(uc_NewLines) - uc_breaklinecount
		If (aa_osversionnumber >= aa_osversionnumber_vista)
			Send {Left %uc_Len%}{Shift Down}{Right %uc_Len%}{Shift Up}
		Else
			SendPlay {Left %uc_Len%}{Shift Down}{Right %uc_Len%}{Shift Up}
	}
	uc_NewLines =                    ; Grundstellung fuer uc_NewLines
Return

; --------------------------------------------------------------------------------
; Blockkommentar entfernen
uc_sub_Uncomment:
	uc_CommentStringTmp = %uc_CommentString%%A_Space%     ; Einzufuegender String

	func_GetSelection(1, 0, 0.5)

	If (Selection == "")          ; kein Text !!!
		 Return                     ; und Tschuess

	; Zwischenablage zeilenweise abarbeiten
	Loop, parse, Selection, `n
	{
		If (A_LoopField != "") ; nur Zeilen, in denen auch was steht
		{
			; Zeilen umbauen: wenn am Anfang uc_CommentString steht, entfernen
			uc_newlines .= substr(a_loopfield, 1, strlen(uc_CommentStringTmp)) = uc_CommentStringTmp ? substr(a_loopfield, strlen(uc_CommentStringTmp)+1) : a_loopfield
			uc_newlines .= "`n"      ; newline anhaengen
		}
		Else
		{
			uc_NewLines .= "`n"      ; Newline anhaengen
		}
	}
	StringTrimRight, uc_NewLines, uc_NewLines, 1 ; Ueberzaehliges Newline entfernen

	uc_ClipSaved := ClipboardAll ; Save the clipboard.
	Clipboard := uc_NewLines
	If (aa_osversionnumber >= aa_osversionnumber_vista)
		Send ^v
	Else
		SendPlay ^v

	Clipboard := uc_ClipSaved ; Restore the original clipboard.
	uc_ClipSaved =

	If (uc_SelectAfterwards)
	{
		; snaky stolen from textAid:
		StringReplace,uc_tmp,uc_NewLines,`n,,UseErrorLevel
		uc_breaklinecount := ErrorLevel
		uc_tmp =
		uc_Len := StrLen(uc_NewLines) - uc_breaklinecount
		If (aa_osversionnumber >= aa_osversionnumber_vista)
			Send {Left %uc_Len%}{Shift Down}{Right %uc_Len%}{Shift Up}
		Else
			SendPlay {Left %uc_Len%}{Shift Down}{Right %uc_Len%}{Shift Up}
	}
	uc_NewLines =   ; Free memory.
Return
