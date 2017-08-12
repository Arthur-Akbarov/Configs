#NoTrayIcon
#SingleInstance Force

receiver = ac'tivAid.ahk ahk_class AutoHotkey

Loop
{
	parameter := %A_Index%

	if (parameter != "")
	{


		StringRight, tmp_testApo, parameter, 1
		if tmp_testApo = "
		{
			; " ; end qoute for syntax highlighting
			StringLeft, parameter, parameter, 1
			parameter = %parameter%:\
		}

		If(FileExist(parameter) || A_Index = 1)
			list = %list%%parameter%`n
	}
	else
		break
}
Send_WM_COPYDATA(list, receiver)
ExitApp


Send_WM_COPYDATA(ByRef StringToSend, ByRef TargetScriptTitle)  ; ByRef saves a little memory in this case.
; This function sends the specified string to the specified window and returns the reply.
; The reply is 1 if the target window processed the message, or 0 if it ignored it.
{
	 VarSetCapacity(CopyDataStruct, 12, 0)  ; Set up the structure's memory area.
	 ; First set the structure's cbData member to the size of the string, including its zero terminator:
	 NumPut(StrLen(StringToSend) + 1, CopyDataStruct, 4)  ; OS requires that this be done.
	 NumPut(&StringToSend, CopyDataStruct, 8)  ; Set lpData to point to the string itself.
	 Prev_DetectHiddenWindows := A_DetectHiddenWindows
	 Prev_TitleMatchMode := A_TitleMatchMode
	 DetectHiddenWindows On
	 SetTitleMatchMode 2
	 SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScriptTitle%  ; 0x4a is WM_COPYDATA. Must use Send not Post.
	 DetectHiddenWindows %Prev_DetectHiddenWindows%  ; Restore original setting for the caller.
	 SetTitleMatchMode %Prev_TitleMatchMode%         ; Same.

	 ;return ErrorLevel  ; Return SendMessage's reply back to our caller.
	 return
}
