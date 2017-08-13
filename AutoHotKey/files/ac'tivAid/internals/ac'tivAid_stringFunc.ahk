func_StrLeft(String,Len)
{
	StringLeft, Output, String, %Len%
	Return Output
}

func_StrRight( String, Len )
{
	StringRight, Output, String, %Len%
	Return Output
}

func_StrMid( byref String, Left, Len=1000000000)
{
	StringMid, Output, String, %Left%, %Len%
	Return Output
}

func_StrTranslate( String, TransFrom, TransTo )
{
	Loop, Parse, TransFrom
	{
		StringMid, TransToChar, TransTo, %A_Index%, 1
		StringReplace, String, String, %A_LoopField%, %TransToChar%, All
	}
	Return String
}

func_StrUpper(String)
{
	StringUpper, String, String
	Return String
}

func_HotkeyToVar(String)
{
	StringReplace, String, String, ~, Tilde, All
	StringReplace, String, String, #, Sqr, All
	StringReplace, String, String, !, Exc, All
	StringReplace, String, String, ^, Pow, All
	StringReplace, String, String, +, Plus, All
	StringReplace, String, String, -, Minus, All
	StringReplace, String, String, ., Per, All
	StringReplace, String, String, \, BaSl, All
	StringReplace, String, String, <, St, All
	StringReplace, String, String, >, Lt, All
	StringReplace, String, String, `,, Comma, All
	StringReplace, String, String, % " & ", Ampersand, All

	return String
}

func_VarToHotkey(String)
{
	StringReplace, String, String, Tilde, ~, All
	StringReplace, String, String, Sqr, #, All
	StringReplace, String, String, Exc, !, All
	StringReplace, String, String, Pow, ^, All
	StringReplace, String, String, Plus, +, All
	StringReplace, String, String, Minus, -, All
	StringReplace, String, String, Per, ., All
	StringReplace, String, String, BaSl, \, All
	StringReplace, String, String, St, <, All
	StringReplace, String, String, Lt, >, All
	StringReplace, String, String, Comma,`,, All
	StringReplace, String, String, Ampersand, % " & ", All

	return String
}

func_StrClean( String,AllowedChars="",OnlyOnce=0,ReplaceChar="" )
{
	ReturnString =
	If AllowedChars =
		AllowedChars = abcdefghijklmnopqrstuvwxyz1234567890öäüß#_@$?[]
	If OnlyOnce = 0
	{
		Loop, Parse, String
		{
			IfInString, AllowedChars, %A_LoopField%
				ReturnString := ReturnString A_LoopField
			Else If ReplaceChar <>
				ReturnString := ReturnString ReplaceChar
		}
	}
	Else
	{
		Loop, Parse, String
		{
			IfInString, AllowedChars, %A_LoopField%
			{
				IfNotInString, ReturnString, %A_LoopField%
					ReturnString := ReturnString A_LoopField
				Else If ReplaceChar <>
					ReturnString := ReturnString ReplaceChar
			}
			Else If ReplaceChar <>
				ReturnString := ReturnString ReplaceChar
		}
	}
	Return ReturnString
}

func_StrTrimChars(String,Left="",Right="")
{
	If Left =
		Left := " `t"
	If Right =
		Right := Left

	LeftPos =
	RightPos =
	Loop, Parse, String
	{
		StringMid, StrLeft, String, %A_Index%, 1
		StringMid, StrRight, String, % StrLen(String)-A_Index+1, 1

		If LeftPos =
			IfNotInString, Left, %StrLeft%
				LeftPos := A_Index-1
			Else If (A_Index = StrLen(String) AND RightPos = "")
				LeftPos := A_Index
		If RightPos =
			IfNotInString, Right, %StrRight%
				RightPos := A_Index-1
		If (RightPos > 0 AND LeftPos > 0)
			break
	}

	StringTrimLeft, String, String, %LeftPos%
	StringTrimRight, String, String, %RightPos%
	Return %String%
}

func_LimitValue( Variable, Range="-1-1", Default="" )
{
	StringSplit, Range, Range, -, %A_Space%
	If Range1 =
		From = -%Range2%
	Else
		From = %Range1%

	If Range2 =
		To = -%Range3%
	Else If From <>
		To = %Range2%

	If (Range3 = "" AND Range1="")
		To = -%Range4%
	Else If (To = Range2 AND Range3 <> "")
		To = %Range3%

	If Variable > %To%
		If Default =
			Variable = %To%
		Else
			Variable = %Default%
	If Variable < %From%
		If Default =
			Variable = %From%
		Else
			Variable = %Default%
	Return Variable
}

func_StrReplace( String,SearchText,ReplaceText="",Options="" )
{
	StringReplace, Options, Options, TrimRight, , All UseErrorLevel
	If ErrorLevel > 0
		String := func_StrTrimChars( String, "", SearchText )
	StringReplace, Options, Options, TrimLeft, , All UseErrorLevel
	If ErrorLevel > 0
		String := func_StrTrimChars( String, SearchText, "" )
	StringReplace, String, String, %SearchText%, %ReplaceText%, %Options%
	Return %String%
}

; Platzhalter in Sprachvariable ersetzen
#( String, var1="", var2="", var3="", var4="", var5="", var6="", var7="", var8="", var9="")
{
	a = %String%
	Loop
	{
		If var%A_Index% =
			Break
		StringReplace, String, String, ##%A_Index%, % var%A_Index%, A
		StringReplace, String, String, ###, % var%A_Index%
	}
	Return %String%
}

func_Html2Ansi( string ) {
	Loop
	{
		StringGetPos, begin, string, <
		StringGetPos, end, string, >,, %begin%
		If (begin = -1 OR end = -1)
			Break
		StringLeft, new1, string, %begin%
		StringTrimLeft, new2, string, % end+1
		string = %new1%%new2%
	}
	StringReplace, string, string, &auml`;, ä, A
	StringReplace, string, string, &uuml`;, ü, A
	StringReplace, string, string, &ouml`;, ö, A
	StringReplace, string, string, &Auml`;, Ä, A
	StringReplace, string, string, &Ouml`;, Ö, A
	StringReplace, string, string, &Uuml`;, Ü, A
	StringReplace, string, string, &szlig`;, ß, A
	StringReplace, string, string, &nbsp`;, %A_Space%, A
	StringReplace, string, string, &#160`;, %A_Space%, A
	StringReplace, string, string, &#8220`;, ", A
	StringReplace, string, string, &acute`;, ', A
	Return string
}