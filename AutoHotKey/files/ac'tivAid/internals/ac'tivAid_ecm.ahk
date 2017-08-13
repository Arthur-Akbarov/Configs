; KontextMenü Nachrichten Empfänger:
ecm_launch:
	ecm_execute(ecm_receiveMessage(#lParam))
return

ecm_execute(list)
{
	Global
	local numFiles, i, action

	StringSplit, ecm_entry, list, `n

	numFiles := ecm_entry0 - 2
	action := ecm_entry1

	Loop, %numFiles%
	{
		i := A_Index+1

		ActionParameter := ecm_entry%i%
		LastAction := action

		if IsLabel(action)
			gosub, %action%
	}
}


ecm_build:
	Menu, ecm_fileMenu, Add
	Menu, ecm_fileMenu, DeleteAll

	Menu, ecm_folderMenu, Add
	Menu, ecm_folderMenu, DeleteAll

	Loop, parse, ecm_list, |
	{
		if A_LoopField !=
		{
			ecm_tmp_type := ecm_type[%A_LoopField%]
			ecm_tmp_desc := ecm_desc[%A_LoopField%]
			ecm_tmp_action := ecm_action[%A_LoopField%]

			if (ecm_tmp_type = "FILE" || ecm_tmp_type = "BOTH")
			{
				Menu, ecm_fileMenu, Add, %ecm_tmp_desc%, ecm_performAction

			}

			if (ecm_tmp_type = "FOLDER" || ecm_tmp_type = "BOTH")
			{
				Menu, ecm_folderMenu, Add, %ecm_tmp_desc%, ecm_performAction
			}
		}
	}
return

ecm_performAction:
	ecm_tmp := func_StrLeft(func_StrClean(A_ThisMenuItem),128)
	ecm_pName := ecm_ByDesc[%ecm_tmp%]

	ActionParameter := ecm_file
	LastAction := ecm_pName

	ecm_pRoutine := ecm_Action[%ecm_pName%]

	if IsLabel(ecm_pRoutine)
		gosub, %ecm_pRoutine%
return

ecm_init()
{
	Global

	func_AddMessage( "0x4a", "ecm_launch")
	VarSetCapacity(SendToFolder, 256)
	DllCall( "shell32\SHGetFolderPathA", "uint", 0, "int", 0x0009, "uint", 0, "int", 0, "str", SendToFolder)

	SendToActiveAidFolder = %SendToFolder%\ac'tivAid
	ECM_Receiver = %A_ScriptDir%\internals\ac'tivAid_ecmReceiver.ahk

	ecm_clearMenu()
}


ecm_delMenu()
{
	VarSetCapacity(SendToFolder, 256)
	DllCall( "shell32\SHGetFolderPathA", "uint", 0, "int", 0x0009, "uint", 0, "int", 0, "str", SendToFolder)

	SendToActiveAidFolder = %SendToFolder%\ac'tivAid

	FileRemoveDir, %SendToActiveAidFolder%, 1
}

ecm_clearMenu()
{
	Global SendToActiveAidFolder

	IfNotExist %SendToActiveAidFolder%
	{
		FileCreateDir, %SendToActiveAidFolder%
		FileSetAttrib, +S, %SendToActiveAidFolder%, 1
		FileAppend, [.ShellClassInfo]`n, %SendToActiveAidFolder%\desktop.ini
		FileAppend, IconFile=%A_ScriptDir%\icons\internals\ac'tivAid.ico`n, %SendToActiveAidFolder%\desktop.ini
		FileAppend, IconIndex=0, %SendToActiveAidFolder%\desktop.ini
		FileSetAttrib, +RSH, %SendToActiveAidFolder%\desktop.ini
	}

	FileDelete, %SendToActiveAidFolder%\*.lnk
	return
}

registerECMenu(name,desc,routine,scriptName)
{
	Global
	local icon, iconPos, descArray

	if _ecmEnabled = 1
	{
		If routine =
			routine = ecm_%name%

		If desc =
		{
			StringReplace, desc, name, sub_, lng_
			IfNotInString, desc, lng_
				desc = lng_%desc%
			desc := %desc%
			If desc =
				desc = %name%
		}

		StringSplit, registerAction_prefix, routine, _
		If (registerAction_prefix0 > 0 AND registerAction_prefix1 <> "sub" AND StrLen(registerAction_prefix1) > 1 AND StrLen(registerAction_prefix1) < 5)
		{
			StringUpper, registerAction_prefix1, registerAction_prefix1
			desc := registerAction_prefix1 "- " desc
		}

		ecm_num++
		ecm_list = %ecm_list%%name%|
		ecm_desc[%name%] := desc
		ecm_action[%name%] := routine
		ecm_type[%name%] := type

		icon := TrayIcon[%scriptName%]
		iconPos := TrayIconPos[%scriptName%]+1

		descArray := func_StrLeft(func_StrClean(desc),128)
		ecm_ByDesc[%descArray%] := name

		FileCreateShortcut, %A_AHKPath%, %SendToActiveAidFolder%\%desc%.lnk,%A_ScriptDir%,%ECM_Receiver% %routine%,, %icon%,,%iconPos%
	}
}

ecm_receiveMessage(lParam)
{
	StringAddress := NumGet(lParam + 8)  ; lParam+8 is the address of CopyDataStruct's lpData member.
	StringLength := DllCall("lstrlen", UInt, StringAddress)
	if StringLength > 0
	{
	  VarSetCapacity(CopyOfData, StringLength)
	  DllCall("lstrcpy", "str", CopyOfData, "uint", StringAddress)  ; Copy the string out of the structure.
	}
	return %CopyOfData%
}
