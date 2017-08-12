RegisterAdditionalSetting( Prefix, Name, DefaultValue=0, Parameters="" ) {
	Global
	Local Index,SeparateMenu,Type
	SeparateMenu =
	Type =
	#IncludeAgain %A_ScriptDir%\library\#ParseFunctionParameters.ahk

	%Prefix%_AdditionalSettings++
	Index := %Prefix%_AdditionalSettings
	%Prefix%_AdditionalSettings[%Index%] = %Name%
	%Prefix%_AdditionalSettingsType[%Index%] = %Type%
	%Prefix%_AdditionalSettingsParameters[%Index%] = %Parameters%
	%Prefix%_AdditionalSettingsSeparateMenu[%Index%] = %SeparateMenu%
	%Prefix%_AdditionalSettingsReloadOnChange[%Index%] = %ReloadOnChange%
	%Prefix%_%SeparateMenu%_AdditionalMenu = 1
	If Type <> SubRoutine
	{
		IniRead, %Prefix%_%Name%, %ConfigFile%, % %Prefix%_ScriptName, %Name%, %DefaultValue%
		%Prefix%_%Name%_tmp := %Prefix%_%Name%
	}
	Debug("Settings", A_LineNumber, A_LineFile, "RegisterAdditionalSetting: " Prefix ", " Name ", " DefaultValue ", " Type )
}

SaveAdditionalSettings( Prefix ) {
	Global
	local Index,Name
	Index := %Prefix%_AdditionalSettings
	Loop, %Index%
	{
		Name := %Prefix%_AdditionalSettings[%A_Index%]
		If (%Prefix%_AdditionalSettingsType[%A_Index%] <> "SubRoutine")
		{
			%Prefix%_%Name% := %Prefix%_%Name%_tmp
			IniWrite, % %Prefix%_%Name%, %ConfigFile%, % %Prefix%_ScriptName, %Name%
		}
	}
	Debug("Settings", A_LineNumber, A_LineFile, "SaveAdditionalSettings: " Prefix )
}

RestoreAdditionalTmpSettings( Prefix ) {
	Global
	local Index,Name
	Index := %Prefix%_AdditionalSettings
	Loop, %Index%
	{
		Name := %Prefix%_AdditionalSettings[%A_Index%]
		If (%Prefix%_AdditionalSettingsType[%A_Index%] <> "SubRoutine")
			%Prefix%_%Name%_tmp := %Prefix%_%Name%
	}
	Debug("Settings", A_LineNumber, A_LineFile, "RestoreAdditionalTmpSettings: " Prefix )
}

SeparateAdditionalSettingsButton(SeparateMenu,Options="X+5")
{
	Global
	StringSplit, Prefix, SeparateMenu, _
	Prefix = %Prefix1%
	SeparateMenu = %Prefix2%
	Gui, Add, Button, -Wrap w50 h21 %Options% gsub_AdditionalSettingsMenu vta_AdditionalSettingsMenu_%SeparateMenu%, %lng_More% ...
	SeparateMenuName = %Prefix%_%SeparateMenu%
	Gosub, sub_CreateAdditionalSettingsMenu
}

sub_CreateAdditionalSettingsMenu:
	If tmpPrefix =
		tmpPrefix = %Prefix%

	LastAdditionalSettingsPrefix = %tmpPrefix%

	LastAdditionalSettings := tmpPrefix %tmpPrefix%_AdditionalSettingsMenuExternal

	tmpIndex := %tmpPrefix%_AdditionalSettings

	Menu, AdditionalSettingsMenu%SeparateMenuName%, UseErrorLevel
	Menu, AdditionalSettingsMenu%SeparateMenuName%, Delete

	If %tmpPrefix%_AdditionalSettingsMenuExternal =
	{
		If(  SeparateMenuName = "" OR lng_%SeparateMenuName% = "")
		{
			Menu, AdditionalSettingsMenu%SeparateMenuName%, Add, % %tmpPrefix%_ScriptName, sub_AdditionalSettingsMenuCall
			Menu, AdditionalSettingsMenu%SeparateMenuName%, Disable, % %tmpPrefix%_ScriptName
		}
		Else
		{
			Menu, AdditionalSettingsMenu%SeparateMenuName%, Add, % lng_%SeparateMenuName%, sub_AdditionalSettingsMenuCall
			Menu, AdditionalSettingsMenu%SeparateMenuName%, Disable, % lng_%SeparateMenuName%
		}

		Menu, AdditionalSettingsMenu%SeparateMenuName%, Add
	}
	tmpLastType = null
	lastOptionGroup =
	Index = 0
	Loop, %tmpIndex%
	{
		If (%tmpPrefix%_AdditionalSettingsSeparateMenu[%A_Index%] <> SeparateMenuName)
			Continue
		Index++
		tmpName := %tmpPrefix%_AdditionalSettings[%A_Index%]
		StringRight, tmpOptionGroup, tmpName, 1
		tmpOptionGroup := tmpOptionGroup + 0 ; Wenn keine Zahl, dann leer

		If ((%tmpPrefix%_AdditionalSettingsType[%A_Index%] <> tmpLastType AND tmpLastType <> "null") OR tmpOptionGroup < lastOptionGroup OR (lastOptionGroup = "" AND tmpOptionGroup <> "" AND A_Index > 1) OR (lastOptionGroup <> "" AND tmpOptionGroup = "" AND A_Index > 1 ))
		{
			Menu, AdditionalSettingsMenu%SeparateMenuName%, Add
			tmpSeparators++
			Index++
		}
		%tmpPrefix%_AdditionalSettingsSeparators[%SeparateMenuName%_%Index%] := Index-A_Index

		lastOptionGroup := tmpOptionGroup

		If lng_%tmpPrefix%_%tmpName% =
		{
			If lng_%tmpName% =
			{
				If %tmpPrefix%_AdditionalSettingsType[%A_Index%] = SubRoutine
				{
					Menu, AdditionalSettingsMenu%SeparateMenuName%, Add, %tmpName% ..., %tmpPrefix%_%tmpName%
					IfInString, %tmpPrefix%_AdditionalSettingsParameters[%A_Index%], Disabled
						Menu, AdditionalSettingsMenu%SeparateMenuName%, Disable, %tmpName% ...
				}
				Else
				{
					Menu, AdditionalSettingsMenu%SeparateMenuName%, Add, %tmpName%, sub_AdditionalSettingsMenuCall
					If %tmpPrefix%_%tmpName%_tmp = 1
						Menu, AdditionalSettingsMenu%SeparateMenuName%, Check, %tmpName%
					IfInString, %tmpPrefix%_AdditionalSettingsParameters[%A_Index%], Disabled
						Menu, AdditionalSettingsMenu%SeparateMenuName%, Disable, %tmpName%
				}
			}
			Else
			{
				If %tmpPrefix%_AdditionalSettingsType[%A_Index%] = SubRoutine
				{
					Menu, AdditionalSettingsMenu%SeparateMenuName%, Add, % lng_%tmpName% " ...", %tmpPrefix%_%tmpName%
					IfInString, %tmpPrefix%_AdditionalSettingsParameters[%A_Index%], Disabled
						Menu, AdditionalSettingsMenu%SeparateMenuName%, Disable, % lng_%tmpName% " ..."
				}
				Else
				{
					Menu, AdditionalSettingsMenu%SeparateMenuName%, Add, % lng_%tmpName%, sub_AdditionalSettingsMenuCall
					If %tmpPrefix%_%tmpName%_tmp = 1
						Menu, AdditionalSettingsMenu%SeparateMenuName%, Check, % lng_%tmpName%
					IfInString, %tmpPrefix%_AdditionalSettingsParameters[%A_Index%], Disabled
						Menu, AdditionalSettingsMenu%SeparateMenuName%, Disable, % lng_%tmpName%

				}
			}
		}
		Else
		{
			If %tmpPrefix%_AdditionalSettingsType[%A_Index%] = SubRoutine
			{
				Menu, AdditionalSettingsMenu%SeparateMenuName%, Add, % lng_%tmpPrefix%_%tmpName% " ...", %tmpPrefix%_%tmpName%
				IfInString, %tmpPrefix%_AdditionalSettingsParameters[%A_Index%], Disabled
					Menu, AdditionalSettingsMenu%SeparateMenuName%, Disable, % lng_%tmpPrefix%_%tmpName% " ..."
			}
			Else
			{
				Menu, AdditionalSettingsMenu%SeparateMenuName%, Add, % lng_%tmpPrefix%_%tmpName%, sub_AdditionalSettingsMenuCall
				If %tmpPrefix%_%tmpName%_tmp = 1
					Menu, AdditionalSettingsMenu%SeparateMenuName%, Check, % lng_%tmpPrefix%_%tmpName%
				IfInString, %tmpPrefix%_AdditionalSettingsParameters[%A_Index%], Disabled
					Menu, AdditionalSettingsMenu%SeparateMenuName%, Disable, % lng_%tmpPrefix%_%tmpName%
			}
		}
		tmpLastType := %tmpPrefix%_AdditionalSettingsType[%A_Index%]
	}
	tmpPrefix =
Return

sub_AdditionalSettingsMenu:
	;StringReplace,Prefix, A_GuiControl, _AdditionalSettingsMenu
	Prefix3 =
	SeparateMenuName =
	If (InStr(A_GuiControl, "_"))
	{
		StringSplit, Prefix, A_GuiControl, _
		If %Prefix1%__AdditionalMenu = 1
		{
			Prefix = %Prefix1%
			If (Prefix3 <> "" AND %Prefix1%_%Prefix1%_%Prefix3%_AdditionalMenu = 1)
				SeparateMenuName = %Prefix1%_%Prefix3%
		}
	}

	If (LastAdditionalSettings <> Prefix %Prefix%_AdditionalSettingsMenuExternal)
		Gosub, sub_CreateAdditionalSettingsMenu
	Menu, AdditionalSettingsMenu%SeparateMenuName%, Show
Return

sub_AdditionalSettingsMenuCall:
	tmpPrefix := LastAdditionalSettingsPrefix
	If %tmpPrefix%_AdditionalSettingsMenuExternal =
		ThisMenuItemPos := A_ThisMenuItemPos-2
	Else
		ThisMenuItemPos := A_ThisMenuItemPos
	ThisMenuItemPos := ThisMenuItemPos-%tmpPrefix%_AdditionalSettingsSeparators[%SeparateMenuName%_%ThisMenuItemPos%]
	tmpName := %tmpPrefix%_AdditionalSettings[%ThisMenuItemPos%]

	If %Prefix%_AdditionalSettingsReloadOnChange[%ThisMenuItemPos%] = 1
		Reload = 1
	StringRight, tmpOptionGroup, tmpName, 1
	tmpOptionGroup := tmpOptionGroup + 0 ; Wenn keine Zahl, dann leer
	%tmpPrefix%_%tmpName%_tmp := Not(%tmpPrefix%_%tmpName%_tmp)
	If lng_%tmpPrefix%_%tmpName% =
	{
		If lng_%tmpName% =
			Menu, AdditionalSettingsMenu%SeparateMenuName%, ToggleCheck, %tmpName%
		Else
			Menu, AdditionalSettingsMenu%SeparateMenuName%, ToggleCheck, % lng_%tmpName%
	}
	Else
		Menu, AdditionalSettingsMenu%SeparateMenuName%, ToggleCheck, % lng_%tmpPrefix%_%tmpName%

	If %tmpPrefix%_AdditionalSettingsMenuExternal = 1
	{
		%tmpPrefix%_%tmpName% := %tmpPrefix%_%tmpName%_tmp
		IniWrite, % %tmpPrefix%_%tmpName%, %ConfigFile%, % %tmpPrefix%_ScriptName, %tmpName%
	}
	Else
		func_SettingsChanged( %tmpPrefix%_ScriptName )

	If (tmpOptionGroup > 0 AND tmpOptionGroup < 10 AND %tmpPrefix%_%tmpName%_tmp = 1)
	{
		StringTrimRight, tmpOptionGroupName, tmpName, 1
		Loop, 9
		{
			tmpName = %tmpOptionGroupName%%A_Index%
			If A_Index = %tmpOptionGroup%
				continue
			If (lng_%tmpPrefix%_%tmpName% = "" AND lng_%tmpName% = "")
				Break

			If lng_%tmpPrefix%_%tmpName% =
			{
				If lng_%tmpName% =
					Menu, AdditionalSettingsMenu%SeparateMenuName%, UnCheck, %tmpName%
				Else
					Menu, AdditionalSettingsMenu%SeparateMenuName%, UnCheck, % lng_%tmpName%
			}
			Else
				Menu, AdditionalSettingsMenu%SeparateMenuName%, UnCheck, % lng_%tmpPrefix%_%tmpName%

			%tmpPrefix%_%tmpName%_tmp := 0
			If %tmpPrefix%_AdditionalSettingsMenuExternal = 1
			{
				%tmpPrefix%_%tmpName% := %tmpPrefix%_%tmpName%_tmp
				IniWrite, % %tmpPrefix%_%tmpName%, %ConfigFile%, % %tmpPrefix%_ScriptName, %tmpName%
			}
		}
	}
Return
