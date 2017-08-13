; RC4 by Laszlo/Rajat (http://www.autohotkey.com./forum/topic6804.html)
RC4txt2hex( Data, Pass )
{
	Format := A_FormatInteger
	SetFormat Integer, Hex
	b := 0
	j := 0
	VarSetCapacity(Result,StrLen(Data)*2)
	Loop 256
	{
		a := A_Index - 1
		c := SubStr(Pass, Mod(a,StrLen(Pass))+1, 1)
		Key%a% := Asc(c)
		sBox%a% := a
	}
	Loop 256
	{
		a := A_Index - 1
		b := b + sBox%a% + Key%a%  & 255
		T := sBox%a%
		sBox%a% := sBox%b%
		sBox%b% := T
	}
	Loop Parse, Data
	{
		i := A_Index & 255
		j := sBox%i% + j  & 255
		k := sBox%i% + sBox%j%  & 255
		Result .= SubStr(Asc(A_LoopField)^sBox%k%, -1, 2)
	}
	StringReplace Result, Result, x, 0, All
	SetFormat Integer, %Format%
	Return Result
}

RC4hex2txt( Data,Pass )
{
	b := 0
	j := 0
	x := "0x"
	VarSetCapacity(Result,StrLen(Data)//2)
	Loop 256
	{
		a := A_Index - 1
		c := SubStr(Pass, Mod(a,StrLen(Pass))+1, 1)
		Key%a% := Asc(c)
		sBox%a% := a
	}
	Loop 256
	{
		a := A_Index - 1
		b := b + sBox%a% + Key%a%  & 255
		T := sBox%a%
		sBox%a% := sBox%b%
		sBox%b% := T
	}
	Loop % StrLen(Data)//2
	{
		i := A_Index & 255
		j := sBox%i% + j  & 255
		k := sBox%i% + sBox%j%  & 255
		Result .= Chr((x . SubStr(Data,2*A_Index-1,2)) ^ sBox%k%)
	}
	Return Result
}
