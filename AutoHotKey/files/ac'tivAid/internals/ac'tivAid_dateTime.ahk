func_FormatTime( DateTime, Format="" ) {
	global lng_Day,lng_Days,lng_Hour,lng_Hours,lng_Minute,lng_Minutes,lng_Year,lng_Years,lng_Month,lng_Months,lng_Second,lng_Seconds
	If Format contains duration
	{
		If Format contains seconds
			WantSeconds = 60
		Else
			WantSeconds = 1
		AutoTrim, Off
;      Years := Floor( DateTime/(WantSeconds*60*24*365) )
;      Days := Floor( (DateTime-(Years*365))/(WantSeconds*60*24) )
;      Hours := Floor( (DateTime-(Years*365+Days*24*60*WantSeconds))/60 )
;      Minutes := Floor( DateTime-(Years*365+Days*24*60*WantSeconds+Hours*60*WantSeconds) )
;      Seconds := Floor( DateTime-(Years*365+Days*24*60*WantSeconds+Hours*60*WantSeconds+Minutes*60) )

		Years    := Floor( DateTime/WantSeconds/60/24/12/365 )
		Months   := Floor( DateTime/WantSeconds/60/24/12-(Years*365) )
		Days     := Floor( DateTime/WantSeconds/60/24-(Years*365*12+Months*12) )
		Hours   := Floor( DateTime/WantSeconds/60-(Years*365*12*24+Months*12*24+Days*24) )
		Minutes := Floor( DateTime/WantSeconds-(Years*365*12*24*60+Months*12*24*60+Days*24*60+Hours*60) )
		Seconds := Floor( DateTime-(Years*365*12*24*60*60+Months*12*24*60*60+Days*24*60*60+Hours*60*60+Minutes*60) )
		If (Seconds = 0 OR InStr(Format, "precise"))
			Seconds := Round( DateTime-(Years*365*12*24*60*60+Months*12*24*60*60+Days*24*60*60+Hours*60*60+Minutes*60),3 )


		If Years = 0
			Years =
		Else If Years = 1
			Years = 1 %lng_Year%,%A_Space%
		Else
			Years = %Years% %lng_Years%,%A_Space%

		If (Months = 0 AND Years = "")
			Months =
		Else If Months = 1
			Months = 1 %lng_Month%,%A_Space%
		Else
			Months = %Months% %lng_Months%,%A_Space%

		If (Days = 0 AND Months = "" AND Years = "")
			Days =
		Else If Days = 1
			Days = 1 %lng_Day%,%A_Space%
		Else
			Days = %Days% %lng_Days%,%A_Space%

		If (Hours = 0 AND Days = "" AND Months = "" AND Years = "")
			Hours =
		Else If Hours = 1
			Hours = 1 %lng_Hour%,%A_Space%
		Else
			Hours = %Hours% %lng_Hours%,%A_Space%

		If (Minutes = 0 AND Hours = "" AND Days = "" AND Months = "" AND Years = "" AND WantSeconds = 60)
			Minutes =
		Else If Minutes = 1
			Minutes = 1 %lng_Minute%
		Else
			Minutes = %Minutes% %lng_Minutes%

		If Seconds = 1
			Seconds = 1 %lng_Second%
		Else
			Seconds = %Seconds% %lng_Seconds%

		If WantSeconds = 60
		{
			If Minutes <>
				Minutes = %Minutes%,%A_Space%
			DateTime = %Years%%Months%%Days%%Hours%%Minutes%%Seconds%
		}
		Else
			DateTime = %Years%%Months%%Days%%Hours%%Minutes%
	}
	Else
	{
		FormatTime, DateTime, %DateTime% R, %Format%

	}
	Return %DateTime%
}

func_GetDateFromSeconds( Seconds )
{
	Year    := func_StrRight("0000" Floor( Seconds/60/60/24/12/365 ), 4)
	Month   := func_StrRight("00"   Floor( Seconds/60/60/24/12-(Year*365) ), 2)
	Day     := func_StrRight("00"   Floor( Seconds/60/60/24-(Year*365*12+Month*12) ), 2)
	Hours   := func_StrRight("00"   Floor( Seconds/60/60-(Year*365*12*24+Month*12*24+Day*24) ), 2)
	Minutes := func_StrRight("00"   Floor( Seconds/60-(Year*365*12*24*60+Month*12*24*60+Day*24*60+Hours*60) ), 2)
	Seconds := func_StrRight("00"   Floor( Seconds-(Year*365*12*24*60*60+Month*12*24*60*60+Day*24*60*60+Hours*60*60+Minutes*60) ), 2)
	Year    := func_StrRight("0000" Year+1753, 4)
	Month   := func_StrRight("00" Month+1, 2)
	Day     := func_StrRight("00" Day+1, 2)
	Result = %Year%%Month%%Day%%Hours%%Minutes%%Seconds%
	Return %Result%
}

func_GetSecondsFromDate( Date )
{
	Date2 = 17530101000000
	EnvSub, Date, %Date2%, Seconds
	Return %Date%
}
