sub_MainContextMenu:
	StringReplace, Extension, A_ThisMenu, SubContextMenu,
	StringSplit, Extension, Extension, #
	Extension = %Extension1%
	SubCategory = %Extension2%
	WinWaitActive, ahk_id %WinIDbeforeContextMenu%,, 1
	If ErrorLevel
		WinActivate, ahk_id %WinIDbeforeContextMenu%
	Sleep,50

;   msgbox, % A_ThisMenu "`n" A_ThisMenuItemPos ":" A_ThisMenuItem "`n" MenuHotkey%Extension%%A_ThisMenuItemPos%#%SubCategory%  "`n" MenuSub%Extension%%A_ThisMenuItemPos%#%SubCategory%
	activAid_ThisHotkey := MenuHotkey%Extension%%A_ThisMenuItemPos%#%SubCategory%
	IfInString, MenuHotkey%Extension%%A_ThisMenuItemPos%#%SubCategory%, HOTSTRING`:
	{
		StringReplace, activAid_ThisHotkey,activAid_ThisHotkey,HOTSTRING`:,
		IfInString, MenuSub%Extension%%A_ThisMenuItemPos%#%SubCategory%, __NewLine__
			Gosub, %activAid_ThisHotkey%
		Else
		{
			StringSplit, HotStringOptions, activAid_ThisHotkey, :
			IfInString, HotStringOptions2, R
				SendRaw, % MenuSub%Extension%%A_ThisMenuItemPos%#%SubCategory%
			Else
			{
				StringReplace, HotStringText, MenuSub%Extension%%A_ThisMenuItemPos%#%SubCategory%, ``r, `r, All
				StringReplace, HotstringText, HotstringText, ``n, `n, All
				StringReplace, HotstringText, HotstringText, ``t, %A_Tab%, All
				StringReplace, HotstringText, HotstringText, ```;, `;, All
				StringReplace, HotstringText, HotstringText, ```:, `:, All
				Send, %HotStringText%
			}
		}

	}
	Else
	{
		CalledFrom = %A_ThisLabel%
		Gosub, % MenuSub%Extension%%A_ThisMenuItemPos%#%SubCategory%
		CalledFrom =
	}
	activAid_ThisHotkey =
Return

CreateGuiID( VariableName )
{
	global
	LastGuiID++
	GuiID_%VariableName% = %LastGuiID%
	GuiID%LastGuiID% := %Prefix%_ScriptName " " VariableName

	;ToolTip % LastGuiID

	Return %LastGuiID%
}

GuiDefault( VariableName, Options="" )
{
	global
	If GuiID_%VariableName% =
		Return
	Gui, % GuiID_%VariableName% ":Default"
	Gui, +Label%VariableName%Gui %Options%
	Gui, +LastFound
	Gosub, GuiDefaultFont
	WinGet, GuiID, ID
	Return GuiID
}

Debug( dbgClass,dbgLine,dbgFile,dbgMessage )
{
	Global

	dbgError =
	If ( ErrorLevel <> "" AND ErrorLevel <> 0 )
		dbgError := " {ErrorLevel:" ErrorLevel ", GetLastError:" A_LastError "}"

	AutoTrim, Off
	If (_DebugLevel = "" OR _DebugLevel = 0 OR _Debug = 0)
		Return
	If (!(_DebugLevel = "ALL" OR InStr(_DebugLevel, dbgClass)) AND dbgClass <> "INIT")
		Return

	SplitPath, dbgFile, dbgOutFileName
	dbgClass = [%dbgClass%]
	dbgLine := SubStr("      " dbgLine, -5)

	If dbgClass = [VAR]
	{
		dbgNewMessage =
		dbgIndentVar := SubStr(A_SpaceLine, 1, StrLen(dbgOutFileName " " dbgLine ": " dbgClass " "))
		Loop, Parse, dbgMessage, `,
		{
			dbgVar := %A_LoopField%
			If A_Index = 1
				dbgNewMessage := dbgNewMessage dbgNewLine dbgOutFileName " " dbgLine ": " dbgClass " " A_LoopField " = " dbgVar "`n"
			Else
				dbgNewMessage := dbgNewMessage dbgIndentVar A_LoopField " = " dbgVar "`n"

		}
		dbgMessage = %dbgNewMessage%

		If _DebugToFile <>
			FileAppend, %dbgMessage%`n, %_DebugToFile%
		Else
			OutputDebug, %dbgMessage%
	}
	Else
		If _DebugToFile <>
			FileAppend, %dbgNewLine%%dbgOutFileName% %dbgLine%: %dbgClass% %dbgMessage%%dbgError%`n, %_DebugToFile%
		Else
			OutputDebug, %dbgNewLine%%dbgOutFileName% %dbgLine%: %dbgClass% %dbgMessage%%dbgError%
}

RegisterHook( fhook_Hookname, fhook_ExtensionName, fhook_First=0 )
{
	Global
	fhook_Function = hook_%fhook_Hookname%
	%fhook_Function% := "|" %fhook_Function% "|"
	StringReplace, %fhook_Function%, %fhook_Function%, |%fhook_ExtensionName%|, |, All
	If fhook_First
		%fhook_Function% := fhook_ExtensionName "|" %fhook_Function%
	Else
		%fhook_Function% := %fhook_Function% "|" fhook_ExtensionName
	StringReplace, %fhook_Function%, %fhook_Function%, |||, |, All
	StringReplace, %fhook_Function%, %fhook_Function%, ||, |, All
	%fhook_Function% := func_StrTrimChars( %fhook_Function%, "|" )
	If %fhook_Function% = |
		%fhook_Function% =
	Debug("HOOK", A_LineNumber, A_LineFile, "RegisterHook: " fhook_Hookname "->" fhook_ExtensionName " (" fhook_Function ")")
}

UnRegisterHook( fhook_Hookname, fhook_ExtensionName )
{
	Global
	fhook_Function = hook_%fhook_Hookname%
	%fhook_Function% := "|" %fhook_Function% "|"
	StringReplace, %fhook_Function%, %fhook_Function%, |%fhook_ExtensionName%|, |, All
	StringReplace, %fhook_Function%, %fhook_Function%, |||, |, All
	StringReplace, %fhook_Function%, %fhook_Function%, ||, |, All
	%fhook_Function% := func_StrTrimChars( %fhook_Function%, "|" )
	If %fhook_Function% = |
		%fhook_Function% =
	Debug("HOOK", A_LineNumber, A_LineFile, "UnRegisterHook: " fhook_Hookname "->" fhook_ExtensionName " (" fhook_Function ")")
}

CallHook( fhook_Hookname, fhook_Section="" )
{
	Global
	fhook_Function = hook_%fhook_Hookname%
	Loop, Parse, %fhook_Function%, |
	{
		If A_LoopField =
			continue
		If (IsLabel(fhook_Hookname fhook_Section "_" A_LoopField) AND Enable_%A_LoopField% = 1 AND Enable%fhook_Hookname%_%A_LoopField% <> 0)
		{
			Gosub, %fhook_Hookname%%fhook_Section%_%A_LoopField%
			Debug("HOOK", A_LineNumber, A_LineFile, "CallHook: " fhook_Hookname fhook_Section "_" A_LoopField "... (" fhook_Function ")")
		}
	}
}
