; -----------------------------------------------------------------------------
; === Action Handling =========================================================
; -----------------------------------------------------------------------------
performAction(name,para="")
{
	Global

	ActionParameter := para
	LastAction := name
	loop, parse, name, |
	{
		routine := Action%A_LoopField%

		If para =
			ActionParameter := ActionPara%A_LoopField%

		if IsLabel(routine)
			gosub, %routine%

		If para =
			ActionParameter =
	}
}

performHoldAction(name,para="")
{
	Global

	HoldActionParameter := para
	LastHoldAction := name
	loop, parse, name, |
	{
		routine := HoldActionStart%A_LoopField%

		if IsLabel(routine)
			gosub, %routine%
	}
}

finishHoldAction(name)
{
	Global

	loop, parse, name, |
	{
		routine := HoldActionEnd%A_LoopField%

		if IsLabel(routine)
			gosub, %routine%
	}
}

registerHoldAction(name,desc,start,end,para="")
{
	Global

	If desc =
	{
		StringReplace, desc, name, sub_, lng_
		IfNotInString, desc, lng_
			desc = lng_%desc%
		desc := %desc%
		If desc =
			desc = %name%
	}

	StringSplit, registerHoldAction_prefix, start, _
	If (registerHoldAction_prefix0 > 0 AND registerHoldAction_prefix1 <> "sub" AND StrLen(registerHoldAction_prefix1) > 1 AND StrLen(registerHoldAction_prefix1) < 5)
	{
		StringUpper, registerHoldAction_prefix1, registerHoldAction_prefix1
		desc := registerHoldAction_prefix1 ": " desc
	}

	HoldActions = %HoldActions%%name%|
	HoldActionsDesc = %HoldActionsDesc%%desc%|
	HoldActionStart%name% := start
	HoldActionEnd%name% := end
	HoldActionDesc%name% := desc
	HoldActionPara%name% := para
	descArray := func_StrLeft(func_StrClean(desc),128)
	HoldActionNameByDesc%descArray% := name
}

registerAction(name,desc="",routine="",para="")
{
	Global

	If routine =
		routine = %name%

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
		desc := registerAction_prefix1 ": " desc
	}

	Actions = %Actions%%name%|
	ActionsDesc = %ActionsDesc%%desc%|
	Action%name% := routine
	ActionDesc%name% := desc
	ActionPara%name% := para
	descArray := func_StrLeft(func_StrClean(desc),128)

	ActionNameByDesc%descArray% := name
}

unRegisterAction(name)
{
	Global

	StringReplace, Actions, Actions, %name%|,,A
	Action%name% =
	ActionDesc%name% =
	ActionPara%name% =
	}

	unRegisterHoldAction(name)
	{
	Global

	StringReplace, HoldActions, HoldActions, %name%|,,A
	HoldActionStart%name% =
	HoldActionEnd%name% =
	HoldActionDesc%name% =
	HoldActionPara%name% =
}

descHoldActionsString(str)
{
	Loop, parse, str, |
	{
		thisDesc := HoldActionDesc%A_LoopField%
		outStr = %outStr%%thisDesc%|
	}

	If (Substr(outStr,0,1) = "|")
		StringTrimRight,outStr,outStr,1

	if OutStr =
		OutStr := str

	return outStr
}

descActionsString(str)
{
	Loop, parse, str, |
	{
		thisDesc := ActionDesc%A_LoopField%
		outStr = %outStr%%thisDesc%|
	}

	If (Substr(outStr,0,1) = "|")
		StringTrimRight,outStr,outStr,1

	if OutStr =
		OutStr := str

	return outStr
}

action_playSound:
	SoundPlay, %ActionParameter%
return
