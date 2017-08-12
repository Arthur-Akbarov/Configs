; Parses parameters inside the variable "Parameters"
; This file should only be included inside a function
; Parameter format: "Par1:false Par2:%Var% Par3:'string'"
ParseFunctionParameters_lastPos = 1
ParseFunctionParameters_lastMatch =
Loop
{
	ParseFunctionParameters_lastPos := RegExMatch(Parameters,"Smi)(?:^\s*|\s*)([a-z][a-z0-9_]*?):\s*([^'""]+?|['""][^'""]*['""])(?:\s+|\s*$)", ParseFunctionParameters_Match, ParseFunctionParameters_lastPos+StrLen(ParseFunctionParameters_lastMatch))
	;msgbox, %ParseFunctionParameters_Match1% == %ParseFunctionParameters_Match2%
	If !ParseFunctionParameters_lastPos
		break
	If !ParseFunctionParameters_Match1
		break
	If (RegExMatch(ParseFunctionParameters_Match2, "^[""'](.*)[""']$",ParseFunctionParameters_SubMatch))
		%ParseFunctionParameters_Match1% := ParseFunctionParameters_SubMatch1
	Else If ParseFunctionParameters_Match2 in true,false
		%ParseFunctionParameters_Match1% := %ParseFunctionParameters_Match2%
	Else
		Transform, %ParseFunctionParameters_Match1%, Deref, %ParseFunctionParameters_Match2%
	ParseFunctionParameters_lastMatch := ParseFunctionParameters_Match
}
