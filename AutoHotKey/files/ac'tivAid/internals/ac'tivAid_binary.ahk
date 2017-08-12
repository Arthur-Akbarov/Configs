ExtractInteger( ByRef pSource, pOffset = 0, pIsSigned = false, pSize = 4 )
{
	; pSource is a string (buffer) whose memory area contains a raw/binary integer at pOffset.
	; The caller should pass true for pSigned to interpret the result as signed vs. unsigned.
	; pSize is the size of PSource's integer in bytes (e.g. 4 bytes for a DWORD or Int).
	; pSource must be ByRef to avoid corruption during the formal-to-actual copying process
	; (since pSource might contain valid data beyond its first binary zero).
	Loop %pSize%  ; Build the integer by adding up its bytes.
		result += *(&pSource + pOffset + A_Index-1) << 8*(A_Index-1)
	if (!pIsSigned OR pSize > 4 OR result < 0x80000000)
		return result  ; Signed vs. unsigned doesn't matter in these cases.
	; Otherwise, convert the value (now known to be 32-bit) to its signed counterpart:
	return -(0xFFFFFFFF - result + 1)
}

InsertInteger( pInteger, ByRef pDest, pOffset = 0, pSize = 4 )
{
	; The caller must ensure that pDest has sufficient capacity.  To preserve any existing contents in pDest,
	; only pSize number of bytes starting at pOffset are altered in it.
	Loop %pSize%  ; Copy each byte in the integer into the structure as raw binary data.
		DllCall("RtlFillMemory", "UInt", &pDest + pOffset + A_Index-1, "UInt", 1, "UChar", pInteger >> 8*(A_Index-1) & 0xFF)
}

StringGet( ByRef struct, Offset, Length=256)
{
	str =
	Loop, %Length%
	{
		char := NumGet(struct, A_Index + Offset, "UChar")
		If char = 0
			break
		str .= Chr(char) ; where 0 is your offset
	}
	Return str
}

/*
BinaryEncodingDecoding.ahk

Routines to encode and decode binary data to and from Ascii/Ansi data (source code).

// by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr
// File/Project history:
 1.02.000 -- 2007/01/03 (PL) -- Code rewritten for speed, using new AHK expression features and regexes.
 1.01.000 -- 2006/07/04 (PL) -- Finally, I put Pebwa in its own file, it has less generic use.
 1.00.000 -- 2006/03/29 (PL) -- Creation, taking Bin2Hex and Hex2Bin
			 (and Bin2Pebwa & Pebwa2Bin) from DllCallStruct.

Bin2Hex & Hex2Bin derivated from Laszlo's code.
*/
/* Copyright notice: See the PhiLhoSoftLicence.txt file for details.
This file is distributed under the zlib/libpng license.
Copyright (c) 2006-2007 Philippe Lhoste / PhiLhoSoft
*/

FormatHexNumber(_value, _digitNb)
{
	local hex, intFormat

	; Save original integer format
	intFormat := A_FormatInteger
	; For converting bytes to hex
	SetFormat Integer, Hex

	hex := _value + (1 << 4 * _digitNb)
	StringRight hex, hex, _digitNb
	; I prefer my hex numbers to be in upper case
	StringUpper hex, hex

	; Restore original integer format
	SetFormat Integer, %intFormat%

	SetFormat, integer, d

	Return hex
}

/*
// Convert raw bytes stored in a variable to a string of hexa digit pairs.
// Convert either _byteNb bytes or, if null, the whole content of the variable.
//
// Return the number of converted bytes, or -1 if error (memory allocation)
*/
Bin2Hex(ByRef @hexString, ByRef @bin, _byteNb=0)
{
	local dataSize, dataAddress, granted, f

	; Get size of data
	dataSize := _byteNb < 1 ? VarSetCapacity(@bin) : _byteNb
	dataAddress := &@bin
	; Make enough room (faster)
	granted := VarSetCapacity(@hexString, dataSize * 5)
	if (granted < dataSize * 5)
	{
		; Cannot allocate enough memory
		ErrorLevel = Mem=%granted%
		Return -1
	}
	f := A_FormatInteger
	SetFormat Integer, H
	Loop %dataSize%
	{
		@hexString .= *(dataAddress++) + 256
	}
	StringReplace @hexString, @hexString, 0x1, , All
	StringUpper @hexString, @hexString
	SetFormat Integer, %f%

	Return dataSize
}



/*
// Convert a string of hexa digit pairs to raw bytes stored in a variable.
// Convert either _byteNb bytes or, if null, the whole content of the variable.
//
// Return the number of converted bytes, or -1 if error (memory allocation)
*/
Hex2Bin(ByRef @bin, ByRef @hex, _byteNb=0)
{
	local l, data, granted, dataAddress

	If (_byteNb < 1 or _byteNb > dataSize)
	{
		; Get size of data
		l := StrLen(@hex)
		_byteNb := l // 2
		if (l = 0 or _byteNb * 2 != l)
		{
			; Invalid string, empty or odd number of digits
			ErrorLevel = Param
			Return -1
		}
	}
	; Make enough room
	granted := VarSetCapacity(@bin, _byteNb, 0)
	if (granted < _byteNb)
	{
		; Cannot allocate enough memory
		ErrorLevel = Mem=%granted%
		Return -1
	}
	data := RegExReplace(@hex, "..", "0x$0!")
	StringLeft data, data, _byteNb * 5
	dataAddress := &@bin

	Loop Parse, data, !
	{
		; Store integer in memory
		DllCall("RtlFillMemory"
				, "UInt", dataAddress++
				, "UInt", 1
				, "UChar", A_LoopField)
	}

	Return _byteNb
}

; Konvertiert Stings in Hex-Werte
func_Hex( String, Unicode = 0 )
{
	OldFormat = %A_FormatInteger%
	SetFormat, Integer, hex

	Loop, Parse, String
	{
		TransForm, Asc, Asc, %A_LoopField%
		Asc += 0
		StringTrimLeft, Hex, Asc, 2
		If Unicode = 0
			Result = %Result%%Hex%
		Else
			Result = %Result%%Hex%00
	}
	SetFormat, Integer, %OldFormat%
	StringUpper, Result, Result

	SetFormat, integer, d

	Return Result
}

FormatHex(MyHex)
{
	Global OptBGR
	MyHex := SubStr(MyHex, 3)
	If OptBGR
		MyHex := RegExReplace(MyHex, "(..)(..)(..)", "$3$2$1")
	Return MyHex
}
