; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               Language-File Creator
; -----------------------------------------------------------------------------
; Version:            0.2
; Date:               2006-01-14
; Author:             Wolfgang Reszel
; Copyright:          2006 Heise Zeitschriften Verlag GmbH & Co. KG
; -----------------------------------------------------------------------------

#SingleInstance force
SetBatchLines, -1
SetWorkingDir, ..

StringRight, Lng, A_Language, 2 ; Sprache ermitteln

ChangeGUI:

If Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
{
	ScriptName       = Sprachdatei erstellen
	lng_SelectSource = Welche Sprache als Ausgangssprache verwenden
	lng_Source1      = Originalsprache (Deutsch)
	lng_Source2      = Alternativsprache (Englisch)
	lng_Destination  = Zielsprache
	lng_OK           = &OK
	lng_Cancel       = A&bbrechen
	lng_OverwriteVars= vorhandene Datei überschreiben
	lng_UpdateVars   = Neue Variablen hinzufügen und vorhandene aktualisieren
	lng_OnlyNewVars  = Nur neue Variablen hinzufügen
	lng_finished     = Die Sprachdatei wurde im Verzeichnis settings/languages angelegt.
}
else        ; = other languages (english)
{
	ScriptName       = Language-file creator
	lng_SelectSource = which language should be used as source
	lng_Source1      = original language (german)
	lng_Source2      = alternative language (english)
	lng_Destination  = destination language
	lng_OK           = &OK
	lng_Cancel       = &Cancel
	lng_OverwriteVars= overwrite existing file
	lng_UpdateVars   = refresh variables and add new ones
	lng_OnlyNewVars  = only add new variables
	lng_finished     = The language-file has been created in the folder settings/languages.
}
Languages = English (English)|Deutsch (German)|Français (French)|Italiano (Italian)|Nederlands (Dutch)|Polski (Polish)|Svenska (Swedish)|Català (Catalan)|Ceská (Czech)|Dansk (Danish)|Eesti (Estonian)|Español (Spanish)|Esperanto|Hrvatski (Croatian)|Bahasa Indonesia (Indonesian)|Magyar (Hungarian)|Norsk bokmål (Norwegian)|Norsk nynorsk (Norwegian)|Português (Portuguese)|Româna (Romanian)|Slovencina (Slovak)|Slovenšcina (Slovenian)|Suomi (Finnish)|Bosanski (Bosnian)|Gaeilge (Irish)|Lëtzebuergesch (Luxembourgish)|Türkçe (Turkish)

Gui, Add, Text, , %lng_SelectSource%:
Gui, Add, DropDownlist, w300 AltSubmit gsub_ChangeGui vSource, %lng_Source1%|%lng_Source2%
If Lng = 07
	GuiControl, Choose, Source, 1
Else
	GuiControl, Choose, Source, 2

Gui, Add, Text, , %lng_Destination%:
Gui, Add, DropDownlist, w300 vDestination, %Languages%
GuiControl, Choose, Destination, %Destination%

Gui, Add, Radio, vOverwriteNew Checked, %lng_OverwriteVars%
Gui, Add, Radio, vUpdateNew, %lng_UpdateVars%
Gui, Add, Radio, vOnlyNew, %lng_OnlyNewVars%

Gui, Add, Button, y+5 xs+40 w100 gOK, %lng_OK%
Gui, Add, Button, x+10 w100 gCancel, %lng_Cancel%

Gui, Show, AutoSize, %ScriptName%

Return

sub_ChangeGui:
	GuiControlGet, Source
	GuiControlGet, Destination
	If Source = 1
		Lng = 07
	Else
		Lng =
	Gui, Destroy
	Goto, ChangeGUI
Return

OK:
	Gui, Submit, NoHide
	Gui, +Disabled
	GuiControl, Disable, %lng_OK%
	GuiControl, Disable, %lng_Cancel%

	StringSplit, Destination, Destination, (
	StringReplace, Destination2, Destination2, )

	FileCreateDir, settings\languages

	DestFile = settings\languages\language_%Destination2%.ini

	DestFileIntro =

	If OverwriteNew = 1
		FileDelete, %DestFile%

	IfExist, %DestFile%
	{
		Loop, Read, %DestFile%, %DestFile%.tmp
		{
			ReadLine = %A_LoopReadLine%
			If ( StrLeft(A_LoopReadLine, 3) = "`; [" )
				StringTrimLeft, ReadLine, ReadLine, 2
			FileAppend, %ReadLine%`r`n
		}
		FileMove, %DestFile%.tmp, %DestFile%, 1
	}
	Else
		DestFileIntro =
(
`; Language-file for ac'tivAid: %Destination%
`; ATTENTION: Care about the special characters
`;            `` - the back-tick is AutoHotkey's escape character
`;            ``t - tab
`;            ``n - linefeed
`;            ``r - carriage return
`;            ```; - semi colon (text following an unescaped ; is treated as a comment)
`;            ```% - percantage should always be escaped, text enclosed with `% is a variable
`;                  so don't translate text between two `% like %ext_Variable%
`;            ###, ##1, ##2 ... are placeholders and will be replaced with variable content
`;
`; As white spaces are alwayes trimmed at the beginning and end of a string you will
`; somtimes see := followed be text enclosed in quotation marks ("). Text outside these
`; quotation marks are handled as expressions. This notation is used to have spaces at
`; the beginning or end of strings, as := won't trim them. The following statements give
`; the same result:
`; lng_Var1 = The content of Variable ```%ext_Var```% is `%ext_Var`%
`; lng_Var1 := "The content of Variable %ext_Var% is " ext_Var
`; You'll see that you don't have to escape `% in the second notation

)

	Loop, *.ahk, 0 ,1
	{
		IfInString, A_LoopFilefullpath, backups\
			continue
		IfInString, A_LoopFilefullpath, development\
			continue
		IfInString, A_LoopFilefullpath, DEV\
			continue

		If A_LoopFileName = %A_ScriptName%
			continue
		If A_LoopFileName = ac'tivAid_AHK-Checker.ahk
			continue
		If A_LoopFileName = test.ahk
			continue
		If A_LoopFileName = dev_NEXTbuild.ahk
			continue
		IfInstring, A_LoopFileName, bench-
			continue
		If (StrLeft(A_LoopFileName,1) = "_" OR StrLeft(A_LoopFileName,1) = "#")
			continue

		FileName = %A_Loopfilename%

		FilePath = %A_Loopfilefullpath%
		Step =
		Prefix =
		Loop, Read, %FilePath%
		{
			If A_LoopReadLine =
				continue
			StringReplace, ReadLine, A_LoopReadLine, %A_Space%,,All

			If (StrLeft(ReadLine,1)=";")
				continue

			If Step =
			{
				IfInString, ReadLine, ScriptName=activAid
				{
					Step = 0.6
					Section = activAid
					continue
				}

				IfNotInString, ReadLine, Prefix=
					continue
				Step = 0.5
				StringSplit, ReadLine, ReadLine, =
				Prefix = %ReadLine2%
			}
			If Step = 0.5
			{
				IfNotInString, ReadLine, `%Prefix`%_ScriptName=
					continue
				Step = 0.6
				StringSplit, ReadLine, ReadLine, =
				Section = %ReadLine2%
			}
			If Step = 0.6
			{
				IfInString, ReadLine, IfLng=07
					Step = 1
				continue
			}

			If Step = 1
			{
				If Source = 1
					Step = 2
				Else
					Step = 3
				continue
			}

			If Step = 3
			{
				IfInString, A_LoopReadLine, Else
				{
					IfInString, A_LoopReadLine, If
						continue
					Step = 2
				}
				continue
			}

			If Step = 2
			{
				If ReadLine = {
					continue
				If ReadLine = }
				{
					Step =
					Prefix =
					continue
				}

				LoopReadLine = %A_LoopReadLine%

				ReadLinePosAdd = 2
				StringGetPos, ReadLinePos, LoopReadLine, =
				StringGetPos, ReadLinePosExpr, LoopReadLine, `:=
				If ErrorLevel = 0
				{
					ReadLinePos := ReadLinePosExpr
					ReadLinePosAdd = 3
				}

				StringLeft, Key, LoopReadLine, %ReadLinePos%
				StringMid, Value, LoopReadLine, % ReadLinePos + ReadLinePosAdd

				Key = %Key%

				If ReadLinePosAdd = 3
				{
					Key = %Key%`:
				}

				If ( (Key = "MenuName" OR Key = "Description") AND Prefix <> "" )
					Key = %Prefix%_%Key%

				Value = %Value%
				If OverwriteNew = 0
				{
					IniRead, DestValue, %DestFile%, %Section%, %Key%

					If DestValue = ERROR
						Value = %Value%  `; *NEW*
					Else If OnlyNew = 1
						Value = %DestValue%

				}
				IniWrite, %Value%, %DestFile%, %Section%, %Key%
			}
		}
	}
	Gui, Destroy
	Gosub, sub_BeautifyINI
	Msgbox, %lng_finished%
	ExitApp
Return

; INI-Datei verschönern
sub_BeautifyINI:
	FileDelete, %DestFile%.tmp
	DestFileNewContent = %DestFileIntro%
	FileRead, DestFileContent, %DestFile%
	Loop, Parse, DestFileContent, `n, `r
	{
		If A_LoopField =
			continue

		If A_LoopField = `;____________________________________________________________________________
			continue

		If A_LoopField = `;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
			continue

		If ( StrLeft(A_LoopField,1) = "[" )
		{
			DestFileNewContent = %DestFileNewContent%`r`n`;____________________________________________________________________________`r`n
			DestFileNewContent = %DestFileNewContent%`; %A_LoopField%`r`n
			DestFileNewContent = %DestFileNewContent%`;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯`r`n
			continue
		}

		IsEqualSign := "="
		StringGetPos, ReadLinePos, A_LoopField, =
		StringGetPos, ReadLinePosExpr, A_LoopField, `:=
		If ErrorLevel = 0
		{
			ReadLinePos := ReadLinePosExpr
			IsEqualSign := "`:="
		}
		StringLeft, Key, A_LoopField, % ReadLinePos
		Key = %Key%
		StringTrimLeft, Value, A_LoopField, % ReadLinePos+ StrLen(IsEqualSign)
		Value = %Value%

		StringLen, KeyLen, Key
		ReadLinePos := 32-KeyLen
		ReadLineIndent := "                                                      "
		StringRight, ReadLineIndent, ReadLineIndent, %ReadLinePos%
		ReadLine := Key ReadLineIndent IsEqualSign " " Value
		DestFileNewContent = %DestFileNewContent%%ReadLine%`r`n
	}
	FileAppend, %DestFileNewContent%, %DestFile%.tmp

	FileMove, %DestFile%.tmp, %DestFile%, 1
Return


GuiEscape:
GuiClose:
Cancel:
	ExitApp
Return

StrLeft(String,Len)
{
	StringLeft, Output, String, %Len%
	Return Output
}

