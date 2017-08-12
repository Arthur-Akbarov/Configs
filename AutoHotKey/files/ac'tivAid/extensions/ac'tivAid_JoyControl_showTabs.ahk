#NoTrayIcon
#SingleInstance ignore
gosub, ShowMenu
return

ShowMenu:
Menu,kiu,add
Menu,kiu,deleteall

;get windows list
DetectHiddenWindows Off
Winget, ids, list, , , Program Manager
Loop, %ids%
{
	id:=ids%A_Index%
	Wingettitle, title, ahk_id %id%

	;exclude docks window and not needed ones
	If title not contains dock
	if(title!="")
	Menu,kiu,add, %title%,selTask
}
Menu,kiu,show
return

selTask:
WinActivate, %A_ThisMenuItem%
return
