sub_ShowHotkeyList:
	Gui, %GuiID_HotkeyList%:+LastFoundExist
	IfWinActive
	{
		WinGetPos, ShowHotkeyListX , ShowHotkeyListY , ShowHotkeyListW, ShowHotkeyListH
		func_RemoveMessage(0x100,"sub_searchInReadme")
		Gui, %GuiID_HotkeyList%:Cancel
		Return
	}

	If HotkeyListAOT = 1
		HotkeyListID := GuiDefault("HotkeyList", "+LastFound +Resize +AlwaysOnTop +0xF2C0")
	Else
		HotkeyListID := GuiDefault("HotkeyList", "+LastFound +Resize +0xF2C0")

	If (Readme_Hotkeys = "" OR HotkeyListCreated <> 1)
	{
		DontShowMainGUI = 1
		CreateHotKeyList = 1
		Gui, Add, Text, , %lng_CreatingHotkeyList%
		Gui, Show, x%ShowHotkeyListX% y%ShowHotkeyListY% w%ShowHotkeyListW% h%ShowHotkeyListH% , %ScriptNameFull%-%lng_Hotkeys%
		If (Readme_Hotkeys <> "" AND HotkeyListCreated = "")
		{
			GuiDefault("activAid")
			Loop
			{
				Function := Extension[%A_Index%]
				If Function =
					Break

				Prefix := ExtensionPrefix[%A_Index%]

				CreateHotKeyList = 1
				Gosub, sub_CreateExtensionConfigGui
				CreateHotKeyList =
			}
			HotkeyListCreated = 1
		}
		Else
			Gosub, sub_MainGUI
		GuiDefault("HotkeyList")
		Control, Hide,, Static1, ahk_id %HotkeyListID%
		CreateHotKeyList =
		DontShowMainGUI =
	}

	If HotkeyListAOT = 1
		HotkeyListID := GuiDefault("HotkeyList", "+LastFound +Resize +AlwaysOnTop +0xF2C0")
	Else
		HotkeyListID := GuiDefault("HotkeyList", "+LastFound +Resize +0xF2C0")

	Gosub, sub_BigIcon
	If HotkeyList =
	{
		IfWinExist
			Gui, Destroy
		If (ShowHotkeyListX+ShowHotkeyListW < WorkAreaLeft + 40 OR ShowHotkeyListX > WorkAreaRight -40 OR InStr(ShowHotkeyListX,"x") )
			ShowHotkeyListX =
		If (ShowHotkeyListY+ShowHotkeyListH < WorkAreaTop + 40 OR ShowHotkeyListY > WorkAreaBottom -40 OR InStr(ShowHotkeyListY,"y") )
			ShowHotkeyListY =
		If ShowHotkeyListX <>
			ShowHotkeyListX = x%ShowHotkeyListX%
		If ShowHotkeyListY <>
			ShowHotkeyListY = y%ShowHotkeyListY%
		ShowHotkeyContentH := ShowHotkeyListH - 22
		ShowHotkeySearchW := ShowHotkeyListW - 100
		ShowHotkeyListW = w%ShowHotkeyListW%
		ShowHotkeyListH = h%ShowHotkeyListH%
		ShowHotkeyContentH = h%ShowHotkeyContentH%

		If HotkeyListAOT = 1
			GuiDefault("HotkeyList", "+LastFound +AlwaysOnTop +Resize +0xF2C0")
		Else
			GuiDefault("HotkeyList", "+LastFound +Resize +0xF2C0")
		StringTrimLeft, HotkeyList, Readme_Hotkeys, 4
		Gui, Color , FFFFFF, FFFFFF
		Gosub, GuiDefaultFont
		Gui, Add, Text, X0 y4 Right w75, %lng_Search%:
		Gui, Add, Edit, x80 y0 Left w%ShowHotkeySearchW% h22 vsearchTermHotkeyList gsub_ReadmeSearch
		Gui, Add, Button, -Wrap x+1 yp+1 gsub_ReadmeSearch vsearchButtonHotkeyList H20 W18, >
		Gui, Font, , Courier New
		Gui, Font, , Lucida Console
		Gui, Add, Edit, Y23 X0 0x100 Readonly -Wrap HScroll -WantReturn %ShowHotkeyContentH% %ShowHotkeyListW% vHotkeyList, %HotkeyList%
		Gosub, GuiDefaultFont
		Gui, Show, %ShowHotkeyListX% %ShowHotkeyListY% %ShowHotkeyListW% %ShowHotkeyListH% , %ScriptNameFull%-%lng_Hotkeys%
		ControlSend, Edit2, ^{Home}
	}
	func_AddMessage(0x100,"sub_searchInReadme")
	Gui, Show
	GuiControl, Focus, searchTermHotkeyList
	ControlSend,Edit1, ^a
	Send,{F3}

	HotkeyListMainGuiWasVisible =
Return

HotkeyListGuiEscape:
HotkeyListGuiClose:
	Critical
	GuiDefault("HotkeyList", "+LastFound")
	WinGetPos, ShowHotkeyListX , ShowHotkeyListY , ShowHotkeyListW, ShowHotkeyListH
	Gui, Cancel
	If MainGuiVisible =
		func_RemoveMessage(0x100,"sub_searchInReadme")
Return

HotkeyListGuiSize:
	GuiDefault("HotkeyList", "+LastFound")
	WinGetPos, ShowHotkeyListX , ShowHotkeyListY , ShowHotkeyListW, ShowHotkeyListH
	GuiControl, Move, searchTermHotkeyList, % "w" A_GuiWidth-100
	GuiControl, Move, searchButtonHotkeyList, % "x" A_GuiWidth-20
	GuiControl, Move, HotkeyList, % "w" A_GuiWidth " h" A_GuiHeight-22
Return

func_HotkeyAddGuiControl( Text, Variable, Options, SingleKey="", ButtonOptions="", Hidden="" ) {
	global

	IfNotInString, ButtonOptions, h
		ButtonOptions = %ButtonOptions% H20
	IfNotInString, ButtonOptions, w
		ButtonOptions = %ButtonOptions% W300
	IfNotInString, ButtonOptions, x
		ButtonOptions = %ButtonOptions% X+5
	IfNotInString, ButtonOptions, y
		ButtonOptions = %ButtonOptions% YP-3

	gsub_Hotkey =
	IfNotInstring, Options, sub_
		gsub_Hotkey = gsub_HotkeyButton

	If SingleKey <>
		SingleHotkey_%Variable% = 1
	Else
		SingleHotkey_%Variable% =
	If SingleKey = 2
		SingleHotkey_%Variable% = 2

	If Text =
	{
		If Hidden =
			Gui, Add, Button, -Wrap +0x100 +0x8000 H20 %Options% vHotkey_%Variable% %gsub_Hotkey%, % "  " func_HotkeyDecompose(Hotkey_%Variable%, 0 )
		func_CreateListOfHotkeys( Hotkey_%Variable%, Function " (" Variable ")", Function, Hotkey_%Variable%_sub )
	}
	Else
	{
		If Hidden =
		{
			Gui, Add, Text, %Options% vHotkeyText_%Variable%, %Text%:
			Gui, Add, Button, -Wrap +0x100 +0x8000 %ButtonOptions% vHotkey_%Variable% %gsub_Hotkey%, % "  " func_HotkeyDecompose(Hotkey_%Variable%, 0 )
		}
		Hotkey_ExtensionText[%Variable%] := Text
		func_CreateListOfHotkeys( Hotkey_%Variable%, Text, Function, Hotkey_%Variable%_sub )
	}
	Debug("GUI", A_LineNumber, A_LineFile, "Hotkey control added: " Text ", " Variable ", " Options ", " SingleKey ", " ButtonOptions )
}

func_CreateListOfHotkeys( Hotkey, Text, Extension, SubRoutine="", SubCategory="" ) {
	Global
	CreateListOfHotkeys_Hotkey := Hotkey
	CreateListOfHotkeys_Text:= Text
	CreateListOfHotkeys_Extension  := Extension
	CreateListOfHotkeys_Subroutine := Subroutine
	CreateListOfHotkeys_SubCategory := SubCategory

	PlainHotkey = %Hotkey%

	IfInString, Hotkey, HOTSTRING`:
	{
		StringTrimLeft, Hotkey, Hotkey, 10
		StringSplit, Hotkey, Hotkey, :
		Hotkey = %Hotkey3%
		HotkeyIndent := func_StrLeft( " " Hotkey A_SpaceLine, 40 )
	}
	Else
		HotkeyIndent := func_StrLeft( " " func_HotkeyDecompose(Hotkey) A_SpaceLine, 40 )

	If (Readme_Hotkeys_LastExt <> Extension AND CreateHotKeyList = 1)
	{
		Readme_Hotkeys := Readme_Hotkeys "`r`n_______________________________________________________________________________________________________________________________`r`n " Extension "`r`n¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯"
		Readme_Hotkeys_LastExt := Extension
		Menu, SubContextMenu%Extension%#, Add
		Menu, SubContextMenu%Extension%#, DeleteAll
	}
	If Text = %lng_Hotkey%
	{
		Text := ExtensionMenuName[%Extension%]
		StringSplit, Text, Text, %A_Tab%
		Text := Text1
	}
	StringReplace, Text, Text, `n, %A_Space%, A

	Hotkey = %Hotkey%
	SubCategoryVar := func_StrClean(SubCategory,"",0,"_")
	MenuHotkey%Extension%#%SubCategoryVar%++
	MenuHotkey := MenuHotkey%Extension%#%SubCategoryVar%
	MenuHotkey%Extension%%MenuHotkey%#%SubCategoryVar% := PlainHotkey
	IfInString, PlainHotkey, HOTSTRING`:
		MenuSub%Extension%%MenuHotkey%#%SubCategoryVar% = %Text%
	Else
		MenuSub%Extension%%MenuHotkey%#%SubCategoryVar% = %SubRoutine%

	StringReplace, Text, Text, __NewLine__, % " ¶ ", A
	MenuText := func_StrLeft(Text,60)

	If (MenuSub%Extension%%MenuHotkey%#%SubCategoryVar% <> "" AND MenuText <> "")
	{
		If MenuSub%Extension%%MenuHotkey%#%SubCategoryVar% = <SEPARATOR>
		{
			Menu, SubContextMenu%Extension%#%SubCategoryVar%, Add
			If CreateHotKeyList = 1
				Readme_Hotkeys := Readme_Hotkeys "`r`n"
		}
		Else
			Menu, SubContextMenu%Extension%#%SubCategoryVar%, Add, % MenuText "`t" Hotkey, sub_MainContextMenu

		IfNotInString, Readme_Hotkeys_LastSubMenu, #%SubCategoryVar%#
		{
			If SubCategory <>
			{
				Menu, SubContextMenu%Extension%#, Add, %SubCategory%, :SubContextMenu%Extension%#%SubCategoryVar%
				MenuHotkey%Extension%#++
			}
		}
		If (Readme_Hotkeys_PrevLastExt <> Extension AND Extension <> "")
			Menu, MainContextMenu, Add, %Extension%, :SubContextMenu%Extension%#
	}
	Else
	{
		MenuHotkey%Extension%#%SubCategoryVar%--
		MenuHotkey := MenuHotkey%Extension%#%SubCategoryVar%
	}

	If SubCategory <>
		Text = {%SubCategory%}: %Text%
	If Hotkey  <>
	{
		If (StrLen(Text) > 84)
			Text := func_StrLeft(Text,42) "..." func_StrRight(Text,42)
		If CreateHotKeyList = 1
			Readme_Hotkeys := Readme_Hotkeys "`r`n" HotkeyIndent Text
	}

	If MenuSub%Extension%%MenuHotkey%#%SubCategoryVar% <>
	{
		Readme_Hotkeys_LastExt = %Extension%
		Readme_Hotkeys_PrevLastExt = %Extension%
		StringReplace, Readme_Hotkeys_LastSubMenu, Readme_Hotkeys_LastSubMenu, #%SubCategoryVar%#
		Readme_Hotkeys_LastSubMenu = %Readme_Hotkeys_LastSubMenu%#%SubCategoryVar%#
	}

	; Duplikate
	Hotkey_OldDupMessage := Extension "`t" func_HotkeyDecompose(PlainHotkey,1) "`t" SubRoutine "`n"
	Hotkey_NewDupMessage := Extension "`t" func_HotkeyDecompose(PlainHotkey,1) "`t" MenuText "`n"
	StringReplace, HotKey_AllDuplicates, HotKey_AllDuplicates, %Hotkey_OldDupMessage%, %Hotkey_NewDupMessage%`n
	Hotkey_OldDupMessage := Extension "`t*" func_HotkeyDecompose(PlainHotkey,1) "`t" SubRoutine "`n"
	Hotkey_NewDupMessage := Extension "`t*" func_HotkeyDecompose(PlainHotkey,1) "`t" MenuText "`n"
	StringReplace, HotKey_AllDuplicates, HotKey_AllDuplicates, %Hotkey_OldDupMessage%, %Hotkey_NewDupMessage%`n

	CallHook("CreateListOfHotkeys")
	CreateListOfHotkeys_Hotkey =
	CreateListOfHotkeys_SubCategory =

	Debug("GUI", A_LineNumber, A_LineFile, "added to Hotkeylist: " Hotkey ", " Text ", " Extension ", " SubRoutine ", " SubCategory )
}

func_HotkeyRead( OutputVar, Filename, Section, Key, SubRoutine, DefaultValue, Prefix="", Classes="", Options="" ) {
	global
	If Classes =
		Classes = ,

	If (func_StrLeft(Classes,7)="Hotkey_")
	{
		If %Classes% =
			Classes = ,
	}

	IniRead, Hotkey_%OutputVar%, %Filename%, %Section%, %Key%

	If (func_StrLeft(Hotkey_%OutputVar%,1) = "$")
		StringTrimLeft, Hotkey_%OutputVar%,Hotkey_%OutputVar%, 1

	if Hotkey_%OutputVar% = ERROR
		Hotkey_%OutputVar% = %DefaultValue%

	Hotkey_%OutputVar% := func_SortHotkeyModifiers( Hotkey_%OutputVar% )

	HotkeyClasses_%OutputVar% = %Classes%

	IfInString, Hotkey_%OutputVar%, % " & "
	{
		StringReplace, Prefix, Prefix, $,,
		StringReplace, Prefix, Prefix, ~,,
		IfNotInstring, Hotkey_%OutputVar%, ~
			Prefix = %Prefix%~
	}

	HotkeyPrefix_%OutputVar% = %Prefix%

	If SubRoutine in AltTab,ShiftAltTab,AltTabAndMenu,AltTabMenuDismiss
	{
		If (!InStr(Hotkey_%OutputVar%,"<") AND !InStr(Hotkey_%OutputVar%,">") )
		{
			StringReplace, Hotkey_%OutputVar%, Hotkey_%OutputVar%, !, <!
			StringReplace, Hotkey_%OutputVar%, Hotkey_%OutputVar%, ^, <^
			StringReplace, Hotkey_%OutputVar%, Hotkey_%OutputVar%, #, <#
			StringReplace, Hotkey_%OutputVar%, Hotkey_%OutputVar%, +, <+
		}
	}

	If Hotkey_%OutputVar% <>
	{
		Loop, Parse, HotkeyClasses_%OutputVar%, `,
		{
			LoopField = %A_LoopField%
			If (func_StrLeft(LoopField,7)="Hotkey_")
			{
				If %LoopField% =
					LoopField =
			}
			Else If (!InStr(LoopField, "ahk_") AND LoopField <> "")
				LoopField = ahk_class %LoopField%

			HotkeyDup = 0
			If (InStr(Hotkey_AllHotkeys, "«<" Hotkey_%OutputVar% " " LoopField ">»"))
				HotkeyDup=1

			If HotkeyDup = 1
			{
				Loop, Parse, Hotkey_Extensions, |
				{
					FunctionTmp := A_LoopField
					If (Hotkey_Extension[%FunctionTmp%] = Hotkey_%OutputVar%)
						break
					FunctionTmp =
					FunctionTmp1 =
					FunctionTmp2 =
				}
				StringSplit, FunctionTmp, FunctionTmp, $

				Hotkey_DupMessage := FunctionTmp1 "`t" func_HotkeyDecompose(Hotkey_%OutputVar%,1) "`t" FunctionTmp2
				IfNotInString, HotKey_AllDuplicates, %Hotkey_DupMessage%`n
					HotKey_AllDuplicates := HotKey_AllDuplicates Hotkey_DupMessage "`n"
				Hotkey_DupMessage := Section "`t*" func_HotkeyDecompose(Hotkey_%OutputVar%,1) "`t" Subroutine
				IfNotInString, HotKey_AllDuplicates, %Hotkey_DupMessage%`n
					HotKey_AllDuplicates := HotKey_AllDuplicates Hotkey_DupMessage "`n"
				Hotkey_DupMessage =

				HotkeyOutputVar := Hotkey_%OutputVar%
				Hotkey_AllHotkeys := Hotkey_AllHotkeys "«<" HotkeyOutputVar " " LoopField ">»"
				tmp := func_HotkeyToVar(HotkeyOutputVar)
				Hotkey_[%tmp%] := Section
				HotkeySub_[%tmp%] := SubRoutine
				Hotkey_Extension[%Section%$%OutputVar%] := Hotkey_%OutputVar%
				Hotkey_Extensions := Hotkey_Extensions Section "$" OutputVar "|"
				Hotkey_%OutputVar%_new := Hotkey_%OutputVar%
			}
			Else
			{
				Hotkey, IfWinActive, %LoopField%
				Hotkey, % HotkeyPrefix_%OutputVar% Hotkey_%OutputVar%, %SubRoutine%, Off UseErrorLevel

				If ErrorLevel = 0
				{
					HotkeyOutputVar := Hotkey_%OutputVar%
					Hotkey_AllHotkeys := Hotkey_AllHotkeys "«<" HotkeyOutputVar " " LoopField ">»"
					tmp := func_HotkeyToVar(HotkeyOutputVar)
					Hotkey_[%tmp%] := Section
					HotkeySub_[%tmp%] := SubRoutine
					Hotkey_Extension[%Section%$%OutputVar%] := Hotkey_%OutputVar%
					Hotkey_Extensions := Hotkey_Extensions Section "$" OutputVar "|"
					Hotkey_%OutputVar%_new := Hotkey_%OutputVar%
				}
				Else
					Hotkey_%OutputVar% =
			}

			If HotkeyClasses_%OutputVar% = ,
				Break
		}
		Hotkey, IfWinActive
	}

	Hotkey_%OutputVar%_Sub := SubRoutine
	Hotkey_%OutputVar%_old := Hotkey_%OutputVar%

	Debug("Settings", A_LineNumber, A_LineFile, "func_HotkeyRead: " Hotkey_%OutputVar% " -> " OutputVar ", " Filename ", " Section ", " Key ", " SubRoutine ", " DefaultValue ", " Prefix ", " Classes ", " Options )
}

func_HotkeyWrite( OutputVar, Filename, Section, Key, SubRoutine="", Prefix="", Classes="" ) {
	global

	If Prefix <>
		HotkeyPrefix_%OutputVar% = %Prefix%

	IfInString, Hotkey_%OutputVar%, % " & "
	{
		StringReplace, Prefix, Prefix, $,,
		StringReplace, Prefix, Prefix, ~,,
		IfNotInstring, Hotkey_%OutputVar%, ~
			Prefix = %Prefix%~
	}

	If SubRoutine in AltTab,ShiftAltTab,AltTabAndMenu,AltTabMenuDismiss
	{
		If (!InStr(Hotkey_%OutputVar%,"<") AND !InStr(Hotkey_%OutputVar%,">") )
		{
			StringReplace, Hotkey_%OutputVar%, Hotkey_%OutputVar%, !, <!
			StringReplace, Hotkey_%OutputVar%, Hotkey_%OutputVar%, ^, <^
			StringReplace, Hotkey_%OutputVar%, Hotkey_%OutputVar%, #, <#
			StringReplace, Hotkey_%OutputVar%, Hotkey_%OutputVar%, +, <+
		}
	}

	If Classes <>
	{
		If (func_StrLeft(Classes,7)="Hotkey_")
		{
			If %Classes% =
				Classes = ,
		}
		HotkeyClasses_%OutputVar% = %Classes%
	}

	Loop, Parse, HotkeyClasses_%OutputVar%, `,
	{
		LoopField = %A_LoopField%
		If (func_StrLeft(LoopField,7)="Hotkey_")
		{
			If %LoopField% =
				LoopField =
		}
		Else If (!InStr(LoopField, "ahk_") AND LoopField <> "")
			LoopField = ahk_class %LoopField%
		Hotkey, IfWinActive, %LoopField%

		If Hotkey_%OutputVar%_old <>
		{
			Hotkey, % HotkeyPrefix_%OutputVar% Hotkey_%OutputVar%_old, Off, UseErrorLevel
		}

		If ( Hotkey_%OutputVar%_new <> Hotkey_%OutputVar% OR Hotkey_%OutputVar%_del = 1)
		{
			If Hotkey_%OutputVar%_del = 1
				Hotkey_%OutputVar% =
			Else
				Hotkey_%OutputVar% := Hotkey_%OutputVar%_new
			Hotkey_%OutputVar%_del =
			HotkeyOutputVarOld := Hotkey_%OutputVar%_old
			StringReplace, Hotkey_AllHotkeys, Hotkey_AllHotkeys, % "«<" HotkeyOutputVarOld " " LoopField ">»", , A
			Hotkey_Extension[%Section%$%OutputVar%] := Hotkey_%OutputVar%
			StringReplace, Hotkey_Extensions, Hotkey_Extensions, % Section "$" OutputVar "|", , A
		}

		Hotkey_%OutputVar% := func_SortHotkeyModifiers( Hotkey_%OutputVar% )

		IniWrite, % Hotkey_%OutputVar%, %Filename%, %Section%, %Key%

		if Hotkey_%OutputVar% <>
		{
			If SubRoutine <>
				Hotkey_%OutputVar%_Sub = %SubRoutine%
			Hotkey, % HotkeyPrefix_%OutputVar% Hotkey_%OutputVar%, % Hotkey_%OutputVar%_Sub, UseErrorLevel
			HotkeyOutputVarOld := Hotkey_%OutputVar%_old
			HotkeyOutputVar := Hotkey_%OutputVar%
			StringReplace, Hotkey_AllHotkeys, Hotkey_AllHotkeys, % "«<" HotkeyOutputVarOld " " A_LoopField ">»", , A
			Hotkey_AllHotkeys := Hotkey_AllHotkeys "«<" HotkeyOutputVar " " LoopField ">»"
			Hotkey_Extension[%Section%$%OutputVar%] := Hotkey_%OutputVar%
			Hotkey_Extensions := Hotkey_Extensions Section "$" OutputVar "|"
		}

		Hotkey_%OutputVar%_old := Hotkey_%OutputVar%
	}
	Hotkey, IfWinActive
}

func_HotkeyEnable( Variable ) {
	global

	If Hotkey_%Variable% <>
	{
		Loop, Parse, HotkeyClasses_%Variable%, `,
		{
			LoopField = %A_LoopField%
			If (func_StrLeft(LoopField,7)="Hotkey_")
			{
				If %LoopField% =
					LoopField =
			}
			Else If (!InStr(LoopField, "ahk_") AND LoopField <> "")
				LoopField = ahk_class %LoopField%
			Hotkey, IfWinActive, %LoopField%
			Hotkey, % HotkeyPrefix_%Variable% Hotkey_%Variable%, On, UseErrorLevel
		}
		Hotkey, IfWinActive
	}
}

func_HotkeyDisable( Variable ) {
	global

	If Hotkey_%Variable% <>
	{
		Loop, Parse, HotkeyClasses_%Variable%, `,
		{
			LoopField = %A_LoopField%
			If (func_StrLeft(LoopField,7)="Hotkey_")
			{
				If %LoopField% =
					LoopField =
			}
			Else If (!InStr(LoopField, "ahk_") AND LoopField <> "")
				LoopField = ahk_class %LoopField%
			Hotkey, IfWinActive, %LoopField%
			Hotkey, % HotkeyPrefix_%Variable% Hotkey_%Variable%, Off, UseErrorLevel
		}
		Hotkey, IfWinActive
	}
}

func_HotkeyGetNumber( Array, Amount, Prefix="", Hotkey="" ) {
	global

	IfInString, Hotkey, % " & "
	{
		StringReplace, Prefix, Prefix, $,,
		StringReplace, Prefix, Prefix, ~,,
		IfNotInstring, Hotkey, ~
			Prefix = %Prefix%~
	}

	StringLen, PrefixLen, Prefix
	If Hotkey =
		StringTrimLeft, ThisHotkey, A_ThisHotkey, %PrefixLen%
	Else
		ThisHotkey = %Hotkey%

	Loop, %Amount%
	{
		If ( Hotkey_%Array%%A_Index% = ThisHotkey )
			Return %A_Index%
	}
}

func_HotkeyGetVar( HotkeyArray, Amount, GetArray, CustomHotkey="",PrefixArray="" ) {
	global

	Loop, %Amount%
	{
		Prefix = %PrefixArray%
		IfInString, Hotkey_%HotkeyArray%%A_Index%, % " & "
		{
			StringReplace, Prefix, Prefix, $,,
			StringReplace, Prefix, Prefix, ~,,
			IfNotInstring, Hotkey_%HotkeyArray%%A_Index%, ~
				Prefix = %Prefix%~
		}

		StringLen, PrefixLen, Prefix
		StringTrimLeft, ThisHotkey, A_ThisHotkey, %PrefixLen%

		If ( Hotkey_%HotkeyArray%%A_Index% = ThisHotkey AND CustomHotkey = "")
			Return % %GetArray%%A_Index%
		Else If ( Hotkey_%HotkeyArray%%A_Index% = CustomHotkey AND CustomHotkey <> "")
			Return % %GetArray%%A_Index%
	}
}

sub_HotkeyButton:
;   Critical
	Getkeystate,InputMode,Alt
	If InputMode = U
		Getkeystate,InputMode,Shift
	If InputMode = U
		Getkeystate,InputMode,Ctrl

	Gosub, sub_temporarySuspend

	If (PreWinStateD <> 2)
	{
		StringReplace, VarHK, A_GuiControl, Button,

		StringReplace, VarHKCL, A_GuiControl, Button,CapsLock
		StringReplace, VarHKW, A_GuiControl, Button,Win
		Gui,%GuiID_activAid%:+Disabled

		If A_OSversion = WIN_NT4
			StringReplace, Hotkey_DupMessage, Hotkey_DupMessage, —, --, All

		WinGetPos, MainGuiX, MainGuiY, MainGuiW, , ahk_id %MainGuiID%

		GuiSplashX := MainGuiX+(MainGuiW-400)/2-BorderHeight*2
		GuiSplashY := MainGuiY+225

		If InputMode = D
				SplashImage,,b1 x%GuiSplashX% y%GuiSplashY% cwFFFF80 FS9 WS700 w400, %Hotkey_DupMessage%%lng_GetInputDevice%
		Else
		{
			If Single%VarHK% = 1
				SplashImage,,b1 x%GuiSplashX% y%GuiSplashY% cwFFFF80 FS9 WS700 w400, % Hotkey_DupMessage lng_GetSingleKey lng_GetKeySuspendStatus%A_IsSuspended%
			Else If Single%VarHK% = 2
				SplashImage,,b1 x%GuiSplashX% y%GuiSplashY% cwFFFF80 FS9 WS700 w400, % Hotkey_DupMessage lng_GetSingleKey
			Else
				SplashImage,,b1 x%GuiSplashX% y%GuiSplashY% cwFFFF80 FS9 WS700 w400, % Hotkey_DupMessage lng_GetKey lng_GetKeySuspendStatus%A_IsSuspended%
		}
	}
	Hotkey_DupMessage =
	DeviceInput =
	GetKey =

	If InputMode = D
	{
		Loop
		{
			DeviceStates =
			Loop, Parse, InputFromDevices, {, }
			{
				If A_LoopField =
					continue
				GetKeyState, GetInput, %A_LoopField%
				DeviceStates = %DeviceStates%%GetInput%
				If (GetInput <> "U" AND GetInput <> "")
				{
					IfNotInString, DeviceInput, %A_LoopField%
					{
						If DeviceInput =
							DeviceInput = %DeviceInput%%A_LoopField%
						Else
							DeviceInput = %DeviceInput% & %A_LoopField%
					}
				}
				GetKeyState, GetInputESC, ESC
				GetKeyState, GetInputDel, Delete
				GetKeyState, GetInputBsp, Backspace
				GetKeyState, GetInputUp, Up
				GetKeyState, GetInputDown, Down
				If (GetInputUp = "D")
				{
					IfNotInString, DeviceInput, WheelUp
					{
						If DeviceInput =
							DeviceInput = %DeviceInput%WheelUp
						Else
							DeviceInput = %DeviceInput% & WheelUp
					}
				}
				If (GetInputDown = "D")
				{
					IfNotInString, DeviceInput, WheelDown
					{
						If DeviceInput =
							DeviceInput = %DeviceInput%WheelDown
						Else
							DeviceInput = %DeviceInput% & WheelDown
					}
				}
				If (GetInputDel = "D" OR GetInputBsp = "D")
				{
					DeviceInput =
					GetKey = Delete
					Break
				}
				If GetInputESC = D
				{
					DeviceInput =
					GetKey = Escape
					Break
				}
		  }
		  If (GetKey <> "" OR (DeviceInput <> "" AND !InStr(DeviceStates,"D")))
			  Break
		}
	}
	Else
	{
		SetTimer, tim_HotkeyWaitToggleSuspend, 10
		If Single%VarHK% = 2
			Input,GetKey, L1 * M, %InputEscapeKeys%{LCtrl}{RCtrl}{LShift}{RShift}{CapsLock}
		Else
			Input,GetKey, L1 * M, %InputEscapeKeys%
		SetTimer, tim_HotkeyWaitToggleSuspend, Off
	}
	SplashImage, Off
	Gui -Disabled

	Getkeystate,GetKeyCtrl,Ctrl
	Getkeystate,GetKeyAlt,Alt
	Getkeystate,GetKeyShift,Shift
	Getkeystate,GetKeyLWin,LWin,
	Getkeystate,GetKeyRWin,RWin,
	Getkeystate,GetKeyCapsLock,CapsLock
	Getkeystate,GetKeyLCtrl,LCtrl
	Getkeystate,GetKeyRAlt,RAlt

	tmpGetKey := GetKey
	tmpErrorLevel := ErrorLevel
	If A_IsSuspended = 1
		Gosub, sub_temporarySuspend
	Critical, Off
	GetKey := tmpGetKey
	ErrorLevel := tmpErrorLevel

	If Asc(GetKey) < 32
		GetKey := Chr(Asc(GetKey)+96)

	If ErrorLevel contains Endkey:
		StringReplace, GetKey, ErrorLevel, Endkey:,

	If (GetKey = Chr(34) And Lng = 07)
		GetKey = 2
	If (GetKey = "AKUT" OR GetKey = "ACUTE" OR GetKey = "ACCENT")
		GetKey = ´
	If (GetKey = "ZIRKUMFLEX" OR GetKey = "ZIRCUMFLEX" OR GetKey = "CIRCUMFLEX" OR GetKey = "CIRCUMFLEX ACCENT" OR)
		GetKey = ^

	If Lng=07
		GetKey := func_StrTranslate(Getkey,"!§$%&/()=?*':;","134567890ß+#.,")

	If GetKey in NumpadDel,NumpadIns,NumpadClear,NumpadUp,NumpadDown,NumpadLeft,NumpadRight,NumpadHome,NumpadEnd,NumpadPgUp,NumpadPgDn
		GetKeyShift = U

	If (InputMode = D AND InStr(Getkey,"Joy"))
	{
		GetKeyCtrl = U
		GetKeyLCtrl = U
		GetKeyShift = U
	}

	If (DeviceInput <> "" AND InputMode = "D")
	{
		StringTrimRight, GetKey, GetKey, 1
		GetKey = %GetKey%%DeviceInput%
	}

	InputMode =

	If Single%VarHK% <> 1
	{
		If GetKeyShift = D
			GetKey = +%GetKey%
		If (GetKeyLCtrl = "D" AND GetKeyRAlt = "D")
			GetKey = <^>!%GetKey%
		Else
		{
			If GetKeyAlt = D
				GetKey = !%GetKey%
			If GetKeyCtrl = D
				GetKey = ^%GetKey%
		}
		If (GetKeyLWin = "D" OR PreWinState = "D")
			GetKey = #%GetKey%
		If (GetKeyRWin = "D")
			GetKey = >#%GetKey%
		If GetKeyCapsLock = D
			GetKey = ~CapsLock & %GetKey%
	}

	If (PreWinStateD >= 1 AND GetKey = "#" Hotkey_rmp_SimWin)
	{
		PreWinStateD = 2
		goto, sub_HotkeyButton
	}

	If GetKey = LButton
		GetKey = Escape


	If (((GetKey = "#" Hotkey_rmp_SimWin AND Hotkey_rmp_SimWin <> "") OR GetKey = Hotkey_rmp_SimWin ) AND Enable_RemapKeys = 1)
	{
		PreWinState = D
		PreWinStateD = 1
		Hotkey_DupMessage = %lng_rmp_HotkeyButtonMsg%`n————————————————————————————————————————————————————`n
		goto, sub_HotkeyButton
	}
	Gosub, sub_HotkeyParseGetKey
Return

tim_HotkeyWaitToggleSuspend:
	If (GetKeyState("LCtrl") AND GetKeyState("RCtrl"))
	{
		Gosub, sub_temporarySuspend
		If Single%VarHK% = 1
			SplashImage,,b1 cwFFFF80 FS9 WS700 w400, % Hotkey_DupMessage lng_GetSingleKey lng_GetKeySuspendStatus%A_IsSuspended%
		Else
			SplashImage,,b1 cwFFFF80 FS9 WS700 w400, % Hotkey_DupMessage lng_GetKey lng_GetKeySuspendStatus%A_IsSuspended%
		Loop
		{
			If (GetKeyState("LCtrl") AND GetKeyState("RCtrl"))
				Continue
			Break
		}
		SetTimer, tim_HotkeyWaitToggleSuspend, 10
	}
Return

func_HotkeyDecompose( Hotkey, ShortName=0, MenusAndButtons=1 ) {
	global
	AutoTrim, Off

	Hotkey := func_SortHotkeyModifiers( Hotkey )

	StringUpper, Hotkey, Hotkey

	StringReplace, Hotkey, Hotkey, NumpadAdd, NumpadPlus
	StringReplace, Hotkey, Hotkey, NumpadDiv, Numpad÷
	StringReplace, Hotkey, Hotkey, NumpadSub, NumpadMinus
	StringReplace, Hotkey, Hotkey, NumpadMult, Numpad*
	StringReplace, Hotkey, Hotkey, NumpadDel, NumpadDel (sShiftNumDot)
	StringReplace, Hotkey, Hotkey, NumpadIns, NumpadIns (sShiftNum0)
	StringReplace, Hotkey, Hotkey, NumpadClear, NumpadClear (sShiftNum5)
	StringReplace, Hotkey, Hotkey, NumpadUp, NumpadUp (sShiftNum8)
	StringReplace, Hotkey, Hotkey, NumpadDown, NumpadDown (sShiftNum2)
	StringReplace, Hotkey, Hotkey, NumpadLeft, NumpadLeft (sShiftNum4)
	StringReplace, Hotkey, Hotkey, NumpadRight, NumpadRight (sShiftNum6)
	StringReplace, Hotkey, Hotkey, NumpadHome, NumpadHome (sShiftNum7)
	StringReplace, Hotkey, Hotkey, NumpadEnd, NumpadEnd (sShiftNum1)
	StringReplace, Hotkey, Hotkey, NumpadPgUp, NumpadPgUp (sShiftNum9)
	StringReplace, Hotkey, Hotkey, NumpadPgDn, NumpadPgDn (sShiftNum3)
	If (InStr(Hotkey,"*") AND func_StrRight(Hotkey,1) <> "*")
		StringReplace, Hotkey, Hotkey, *

	If ShortName > 0
	{
		StringReplace, Hotkey, Hotkey, Numpad, %lng_KbNumpadShort%
		StringReplace, Hotkey, Hotkey, Num, %lng_KbNumpadShort%
		Hotkey_Sep := "+"
		If MenusAndButtons = 1
			Hotkey_Sep2 := "&&"
		Else
			Hotkey_Sep2 := "&"
		Hotkey_Win = Win
		If ( func_StrLeft(Hotkey,1) = ">" OR func_StrLeft(Hotkey,2) = "$>" OR func_StrLeft(Hotkey,2) = "~>" OR func_StrLeft(Hotkey,3) = "$~>" )
		{
			StringReplace, Hotkey, Hotkey, >
			Hotkey_Win = RWin
		}
	}
	Else
	{
		StringReplace, Hotkey, Hotkey, Numpad, %lng_KbNumpad%
		StringReplace, Hotkey, Hotkey, Num, %lng_KbNumpadShort%
		Hotkey_Sep := " + "
		If MenusAndButtons = 1
			Hotkey_Sep2 := " && "
		Else
			Hotkey_Sep2 := " & "
		Hotkey_Win = %lng_KbWin%
		If ( func_StrLeft(Hotkey,1) = ">" OR func_StrLeft(Hotkey,2) = "$>" OR func_StrLeft(Hotkey,2) = "~>" OR func_StrLeft(Hotkey,3) = "$~>" )
		{
			StringReplace, Hotkey, Hotkey, >
			Hotkey_Win = %lng_Right% %lng_KbWin%
		}
	}

	If Hotkey contains <!,<+,<^,<#
		StringReplace, Hotkey, Hotkey, <, L

	If Hotkey contains >!,>+,>^,>#
		StringReplace, Hotkey, Hotkey, >, R

	StringReplace, Hotkey, Hotkey, End, %lng_KbEnd%
	StringReplace, Hotkey, Hotkey, DOT, %lng_KbDot%

	StringReplace, Hotkey, Hotkey, Help              , %lng_KbHelp%
	StringReplace, Hotkey, Hotkey, Sleep             , %lng_KbSleep%
	StringReplace, Hotkey, Hotkey, Browser_Back      , %lng_KbBrowser_Back%
	StringReplace, Hotkey, Hotkey, Browser_Forward   , %lng_KbBrowser_Forward%
	StringReplace, Hotkey, Hotkey, Browser_Refresh   , %lng_KbBrowser_Refresh%
	StringReplace, Hotkey, Hotkey, Browser_Stop      , %lng_KbBrowser_Stop%
	StringReplace, Hotkey, Hotkey, Browser_Search    , %lng_KbBrowser_Search%
	StringReplace, Hotkey, Hotkey, Browser_Favorites , %lng_KbBrowser_Favorites%
	StringReplace, Hotkey, Hotkey, Browser_Home      , %lng_KbBrowser_Home%
	StringReplace, Hotkey, Hotkey, Volume_Mute       , %lng_KbVolume_Mute%
	StringReplace, Hotkey, Hotkey, Volume_Down       , %lng_KbVolume_Down%
	StringReplace, Hotkey, Hotkey, Volume_Up         , %lng_KbVolume_Up%
	StringReplace, Hotkey, Hotkey, Media_Next        , %lng_KbMedia_Next%
	StringReplace, Hotkey, Hotkey, Media_Prev        , %lng_KbMedia_Prev%
	StringReplace, Hotkey, Hotkey, Media_Stop        , %lng_KbMedia_Stop%
	StringReplace, Hotkey, Hotkey, Media_Play_Pause  , %lng_KbMedia_Play_Pause%
	StringReplace, Hotkey, Hotkey, Launch_Mail       , %lng_KbLaunch_Mail%
	StringReplace, Hotkey, Hotkey, Launch_Media      , %lng_KbLaunch_Media%
	StringReplace, Hotkey, Hotkey, Launch_App1       , %lng_KbLaunch_App1%
	StringReplace, Hotkey, Hotkey, Launch_App2       , %lng_KbLaunch_App2%

	StringReplace, Hotkey, Hotkey, ScrollLock, %lng_KbScrollLock%
	StringReplace, Hotkey, Hotkey, PgUp, %lng_KbPgUp%
	StringReplace, Hotkey, Hotkey, PgDn, %lng_KbPgDn%
	StringReplace, Hotkey, Hotkey, Delete, %lng_KbDel%
	StringReplace, Hotkey, Hotkey, Del, %lng_KbDel%
	StringReplace, Hotkey, Hotkey, Home, %lng_KbHome%
	StringReplace, Hotkey, Hotkey, Insert, %lng_KbIns%
	StringReplace, Hotkey, Hotkey, PrintScreen, %lng_KbPrintScreen%
	StringReplace, Hotkey, Hotkey, Backspace, %lng_KbBackspace%
	StringReplace, Hotkey, Hotkey, Space, %lng_KbSpace%
	StringReplace, Hotkey, Hotkey, ENTER, %lng_KbEnter%
	StringReplace, Hotkey, Hotkey, Clear, %lng_KbClear%
	StringReplace, Hotkey, Hotkey, ESCAPE, ESC
	StringReplace, Hotkey, Hotkey, Tab, %lng_KbTab%
	StringReplace, Hotkey, Hotkey, Pause, %lng_KbPause%
	StringReplace, Hotkey, Hotkey, CtrlBreak, %lng_KbCtrlBreak%
	StringReplace, Hotkey, Hotkey, Left, %lng_KbCurLeft%
	StringReplace, Hotkey, Hotkey, Right, %lng_KbCurRight%
	StringReplace, Hotkey, Hotkey, %A_Space%Up, %A_Space%%lng_kbRelease%
	StringReplace, Hotkey, Hotkey, WheelUp, %lng_KbWheelUp%
	If ErrorLevel = 1
		StringReplace, Hotkey, Hotkey, Up, %lng_KbCurUp%
	StringReplace, Hotkey, Hotkey, WheelDown, %lng_KbWheelDown%
	If ErrorLevel = 1
		StringReplace, Hotkey, Hotkey, Down, %lng_KbCurDown%
	StringReplace, Hotkey, Hotkey, LButton, %lng_KbLButton%
	StringReplace, Hotkey, Hotkey, RButton, %lng_KbRButton%
	StringReplace, Hotkey, Hotkey, MButton, %lng_KbMButton%
	StringReplace, Hotkey, Hotkey, % "~CapsLock & ", %A_Space%
	StringReplace, Hotkey, Hotkey, NUMLOCK, NumLock
	StringReplace, Hotkey, Hotkey, AppsKey, %lng_KbAppsKey%
	StringReplace, Hotkey, Hotkey, % " & ", %Hotkey_Sep2%, A
	If Hotkey in CapsLock,AppsKey
	{
		StringReplace, Hotkey, Hotkey, CapsLock, %lng_kbCapsLock%
		StringReplace, Hotkey, Hotkey, AppsKey, %lng_kbAppsKey%
	}

	StringReplace, Hotkey, Hotkey, LShift, %lng_Left% %lng_kbShift%
	StringReplace, Hotkey, Hotkey, RShift, %lng_Right% %lng_kbShift%
	StringReplace, Hotkey, Hotkey, LAlt, %lng_Left% %lng_kbAlt%
	StringReplace, Hotkey, Hotkey, RAlt, %lng_Right% %lng_kbAlt%
	StringReplace, Hotkey, Hotkey, LWin, %lng_Left% %lng_kbWin%
	StringReplace, Hotkey, Hotkey, RWin, %lng_Right% %lng_kbWin%
	StringReplace, Hotkey, Hotkey, LControl, %lng_Left% %lng_kbCtrl%
	StringReplace, Hotkey, Hotkey, RControl, %lng_Right% %lng_kbCtrl%


	ReGexMatch(Hotkey,"i)(SC[0-9a-f]{3})$",HotkeySC)
	If HotkeySC1 <>
		StringReplace, Hotkey, Hotkey, %HotkeySC1%, % lng_Kb%HotkeySC1%, A

	If (func_StrLeft(Hotkey,2) = "$~" OR func_StrLeft(Hotkey,2) = "~$")
		StringTrimLeft, Hotkey, Hotkey, 2
	Else If (func_StrLeft(Hotkey,1) = "~" OR func_StrLeft(Hotkey,1) = "$")
		StringTrimLeft, Hotkey, Hotkey, 1

	If (func_StrRight(Hotkey,1) = "+")
		Hotkey := func_StrLeft( Hotkey, StrLen(Hotkey)-1 ) "Plus"
	If (func_StrRight(Hotkey,1) = "-")
		Hotkey := func_StrLeft( Hotkey, StrLen(Hotkey)-1 ) "Minus"

	Len := StrLen(Hotkey)
	HotkeyDecomposed =

	IfInString, Hotkey, <^>!
		StringReplace, Hotkey, Hotkey, <^>!, <<>>

	Loop, Parse, Hotkey
	{
		HotkeyDecomp =
		If (A_Index < Len)
		{
			If A_LoopField = #
				HotkeyDecomp := Hotkey_Win Hotkey_Sep
			If A_LoopField = ^
				HotkeyDecomp := lng_KbCtrl Hotkey_Sep
			If A_LoopField = !
				HotkeyDecomp := lng_KbAlt Hotkey_Sep
			If A_LoopField = +
				HotkeyDecomp := ((ShortName=2) ? lng_KbShiftShort : lng_KbShift) Hotkey_Sep
			If (A_LoopField = " " AND A_Index = 1)
				HotkeyDecomp := lng_KbCapsLock Hotkey_Sep
		}
		If HotkeyDecomp =
			HotkeyDecomp = %A_LoopField%
		HotkeyDecomposed = %HotkeyDecomposed%%HotkeyDecomp%
	}
	StringReplace, HotkeyDecomposed, HotkeyDecomposed, <<>>, AltGr%Hotkey_Sep%
	StringReplace, HotkeyDecomposed, HotkeyDecomposed, sShift, %lng_KbShiftShort%+

	Return %HotkeyDecomposed%
}

; Parameter: VarHK, Getkey
sub_HotkeyParseGetKey:
	PreWinState =
	PreWinStateD =

	If (GetKey = "Escape" OR GetKey = "Enter")
	{
		SplashImage, Off
		Gui,-Disabled
		Return
	}

	If (Getkey = "Backspace" OR Getkey = "Delete")
	{
		Getkey =
		%VarHK%_del = 1
	}
;   msgbox, %Hotkey_AllNewHotkeys%
	Hotkey_AllHotkeys_tmp := Hotkey_AllNewHotkeys ; Hotkey_AllHotkeys
	StringReplace, Hotkey_AllHotkeys_tmp, Hotkey_AllHotkeys_tmp, «<%Hotkey_TempSuspend% >»,
	StringReplace, OutputVar, VarHK, Hotkey_
	HotkeyDup = 0
;   msgbox, % HotkeyClasses_%OutputVar%

	GetKey := func_SortHotkeyModifiers(GetKey)

	If (InStr(Hotkey_WindowsHotkeys, "«<" Getkey " "))
		HotkeyDup = 2

	Loop, Parse, HotkeyClasses_%OutputVar%, `,
	{
		LoopField = %A_LoopField%
		If (func_StrLeft(LoopField,7)="Hotkey_")
		{
			If %LoopField% =
				LoopField =
		}
		Else If (!InStr(LoopField, "ahk_") AND LoopField <> "")
			LoopField = ahk_class %LoopField%
		IfInstring, Hotkey_AllHotkeys_tmp , % "«<" GetKey " " LoopField ">»"
			HotkeyDup = 1
	}

	If HotkeyDup > 0
	{
		Loop, Parse, Hotkey_Extensions, |
		{
			FunctionTmp := A_LoopField
			If Hotkey_Extension[%FunctionTmp%] = %GetKey%
				break
			FunctionTmp =
			FunctionTmp1 =
			FunctionTmp2 =
		}
		StringSplit, FunctionTmp, FunctionTmp, $

		If HotkeyDup = 2
		{
			StringGetPos, Hotkey_WinkeyPos1, Hotkey_WindowsHotkeys, % "«<" GetKey " "
			StringGetPos, Hotkey_WinkeyPos2, Hotkey_WindowsHotkeys, >», , %Hotkey_WinkeyPos1%
			FunctionTmp3 := SubStr(Hotkey_WindowsHotkeys, Hotkey_WinkeyPos1+StrLen(GetKey)+4, Hotkey_WinkeyPos2-(Hotkey_WinkeyPos1+StrLen(GetKey)+3))
			If lng_winHK_%FunctionTmp3% =
				FunctionTmp3 := RegExReplace(FunctionTmp3,"(.)([A-Z])","$1 $2")
			Else
				FunctionTmp3 := lng_winHK_%FunctionTmp3%
			; Windows Versionsname entfernt (da Vista auch bei Win7 angezeigt wird)
			FunctionTmp4 := aa_osversionname
		}

		If %VarHK%_new <> %GetKey%
		{
			If HotkeyDup = 2
				Hotkey_DupMessage := #(lng_DuplicateWinHotkey, func_HotkeyDecompose(Getkey,1), FunctionTmp4) " " FunctionTmp3 "`n`n" lng_OverwriteWinHotkey
			Else If FunctionTmp1 =
				Hotkey_DupMessage := #(lng_DuplicateTempHotkey, func_HotkeyDecompose(Getkey,1)) "`n`n" lng_OverwriteDupHotkey
			Else
			{
				FunctionTmp := Function
				ExtensionIndexTmp := ExtensionIndex
				PrefixTmp := Prefix

				Function := FunctionTmp1

				ExtensionIndex := ExtensionIndex[%Function%]
				Prefix := ExtensionPrefix[%ExtensionIndex%]

				GetKeyTmp := GetKey
				If ExtensionGuiDrawn[%Function%] = 0
					Gosub, sub_CreateExtensionConfigGui
				GetKey := GetKeyTmp

				Function := FunctionTmp
				ExtensionIndex := ExtensionIndexTmp
				Prefix := PrefixTmp
				Hotkey_DupMessage := #(lng_DuplicateHotkey, func_HotkeyDecompose(Getkey,1)) "`n" FunctionTmp1 ": " Hotkey_ExtensionText[%FunctionTmp2%] "`n`n" lng_OverwriteDupHotkey
			}
			Gui +OwnDialogs
			SplashImage, Off
			msgbox, 52, %ScriptTitle%, %Hotkey_DupMessage%
			Gui -Disabled
			Hotkey_DupMessage =
			IfMsgBox, Yes
			{
				HotkeyFunctionTmp2new := Hotkey_%FunctionTmp2%_new
				Loop, Parse, HotkeyClasses_%OutputVar%, `,
				{
					LoopField = %A_LoopField%
					If (func_StrLeft(LoopField,7)="Hotkey_")
					{
						If %LoopField% =
							LoopField =
					}
					Else If (!InStr(LoopField, "ahk_") AND LoopField <> "")
						LoopField = ahk_class %LoopField%
					StringReplace, Hotkey_AllNewHotkeys, Hotkey_AllNewHotkeys, % "«<" HotkeyFunctionTmp2new " " LoopField ">»" , , A
				}
				Hotkey_%FunctionTmp2%_new =
				Hotkey_%FunctionTmp2%_del = 1
				Hotkey_DupDuplicates++
				GuiControl,,Hotkey_%FunctionTmp2%,% "  " func_HotkeyDecompose("", 0)
				func_SettingsChanged(FunctionTmp1)
				If (IsLabel("SettingsChanged_" FunctionTmp1))
					Gosub, SettingsChanged_%FunctionTmp1%
			}
			Else
			{
				HotkeyDup =
				Return
			}
		}
	}
	Else
	{
		SplashImage, Off
		Gui -Disabled
	}

	GuiControlGet, activeTab,,DlgTabs

	If activeTab = %lng_Hotkeys%
		activeTab = activAid

	Hotkey_Extensions_tmp := Hotkey_Extensions_tmp activeTab "$" VarHK "|"
	Hotkey_Extension_tmp[%activeTab%$%VarHK%] = %GetKey%

	VarHKNew := %VarHK%_new
	Loop, Parse, HotkeyClasses_%OutputVar%, `,
	{
		LoopField = %A_LoopField%
		If (func_StrLeft(LoopField,7)="Hotkey_")
		{
			If %LoopField% =
				LoopField =
		}
		Else If (!InStr(LoopField, "ahk_") AND LoopField <> "")
			LoopField = ahk_class %LoopField%
		StringReplace, Hotkey_AllNewHotkeys, Hotkey_AllNewHotkeys, % "«<" VarHKNew " " LoopField ">»" , , A
	}
	%VarHK%_new = %GetKey%
	GuiControl,,%VarHK%,% "  " func_HotkeyDecompose(GetKey, 0)

	Loop, Parse, HotkeyClasses_%OutputVar%, `,
	{
		LoopField = %A_LoopField%
		If (func_StrLeft(LoopField,7)="Hotkey_")
		{
			If %LoopField% =
				LoopField =
		}
		Else If (!InStr(LoopField, "ahk_") AND LoopField <> "")
			LoopField = ahk_class %LoopField%
		If %VarHK%_del <> 1
			Hotkey_AllNewHotkeys := Hotkey_AllNewHotkeys "«<" GetKey " " LoopField ">»"
	}

	Debug("GUI", A_LineNumber, A_LineFile, "sub_HotkeyButton: " activeTab " : " ChangedSettings[%activeTab%] "---" %A_Guicontrol% "-" GetKey )

	If MainGuiVisible <> 2
		Return

	StringReplace, ChangedSettings[%activeTab%], ChangedSettings[%activeTab%], %A_GuiControl%|,,A
	If %A_GuiControl% <> %GetKey%
	{
		ChangedSettings[%activeTab%] := ChangedSettings[%activeTab%] A_GuiControl "|"
		Gosub, sub_EnableDisable_ApplyButton
		If Hotkey_AllDuplicates
		{
			Loop, Parse, Hotkey_AllDuplicates, `n
			{
				If (InStr("`n" A_LoopField, "`n" activeTab "`t" func_HotkeyDecompose(%A_GuiControl%,1) "`t") OR InStr("`n" A_LoopField, "`n" activeTab "`t*" func_HotkeyDecompose(%A_GuiControl%,1) "`t"))
				{
					StringReplace, Hotkey_AllDuplicates, Hotkey_AllDuplicates, %A_LoopField%`n
					Gosub, sub_ShowDuplicates
					Break
				}
			}
			RemainingDuplicates = 0
			StringReplace, tmpDup, Hotkey_AllDuplicates, % "`t" func_HotkeyDecompose(%A_GuiControl%,1) "`t",, A UseErrorLevel
			RemainingDuplicates := RemainingDuplicates + ErrorLevel
			StringReplace, tmpDup, Hotkey_AllDuplicates, % "`t*" func_HotkeyDecompose(%A_GuiControl%,1) "`t",, A UseErrorLevel
			RemainingDuplicates := RemainingDuplicates + ErrorLevel
			If RemainingDuplicates = 1
			{
				Loop, Parse, Hotkey_AllDuplicates, `n
				{
					If (InStr(A_LoopField, "`t" func_HotkeyDecompose(%A_GuiControl%,1) "`t") OR InStr(A_LoopField, "`t*" func_HotkeyDecompose(%A_GuiControl%,1) "`t"))
					{
						StringReplace, Hotkey_AllDuplicates, Hotkey_AllDuplicates, %A_LoopField%`n
						Gosub, sub_ShowDuplicates
						Break
					}
				}
			}
		}
	}
Return
