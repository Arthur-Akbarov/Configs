; returns the index of a found item or 0 if not found
listIsIn(byref str, byref list, byref separator="|")
{
	StringSplit, array, list, %separator%
	loop, %array0%
		if (str == array%A_Index%)
			return %A_Index%
	
	return 0
}

; retrieves item Nr # from a string list
listGet(byref i, byref list, byref separator="|")
{
	StringSplit, array, list, %separator%
	return % array%i%
}

; basically just checks if the list contains anything at all
; to have either just "element" or "element1|element2"
; instead of "|element1" or "|element1|element2" or | at the end...
listAdd(str, byref list, separator="|")
{
	if (list == "")
		list := str
	else if (str != "")
		list := list separator str
}

; removes all occurrences of str in list
listRemove(byref str, byref list, byref separator="|")
{
	new :=
	StringSplit, array, list, %separator%
	loop, %array0%
		if (str != array%A_Index%)
			new := new separator array%A_Index%
	
	StringTrimLeft, list, new, 1
}

listLen(byref list, byref separator="|")
{
	StringSplit, array, list, %separator%
	return %array0%
}