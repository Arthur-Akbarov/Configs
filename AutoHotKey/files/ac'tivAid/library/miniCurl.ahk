lc_tim_Progress:
	lc_ProgressText =

	Loop, %lc_hCurlMaxTransfers%
	{
		if lc_easyHandles%A_Index% !=
		{
			lc_ProgressText := lc_ProgressText lc_url[%A_Index%] "`n" lc_KBNow[%A_Index%] " of " lc_KBTotal[%A_Index%] " KB (" lc_Percent[%A_Index%] "`%)"

			/*
			lc_hPosTmp := 0
			lc_hPosTmp := lc_history_pos[%A_Index%]
			if lc_hPosTmp > 0
				TooltipText := TooltipText "`nAverage Speed: " lc_history_speed[%lc_hPosTmp%] "bytes/s`nTotal Time: " lc_history_time[%lc_hPosTmp%] "sec"
			*/
			Progress, % lc_Percent[%A_Index%], % lc_ProgressText
		}
	}
return

lc_tim_downloadQueue:
	Loop, parse, lc_queueList, |
	{
		if A_LoopField !=
		{
			if lc_active%A_LoopField% = 0
			{
				lc_setError(A_LoopField,lc_easyPerform(A_LoopField))
				lc_finish(A_LoopField)
			}
		}
	}
return

lc_addDownload(ByRef url,targetfile="",progressbarTitle="",finishedLabel="",errorLabel="",progressbarLabel="lc_globalDownloadProgress", dontKill=0)
{
	Global

	hCurlEasyNum := lc_initEasy()
	lc_setUrl(hCurlEasyNum,url)
	lc_dontKill(hCurlEasyNum,dontKill)

	if finishedLabel <>
		lc_setFinishedLabel(hCurlEasyNum,finishedLabel)

	if errorLabel <>
		lc_setErrorLabel(hCurlEasyNum,errorLabel)

	if targetfile =
	{
		SplitPath, url, targetfile
	}


	FileDelete, %targetfile%

	if lc_useGlobalProxy = 1
	{
		lc_useProxy(hCurlEasyNum, lc_GlobalProxyURL)
		;lc_proxyType(hCurlEasyNum, lc_GlobalProxyType)
		;if (lc_GlobalProxyUser != "" || lc_GlobalProxyPass != "")
		;   lc_proxyLogin(hCurlEasyNum, lc_GlobalProxyUser, lc_GlobalProxyPass)
		;lc_proxyPort(hCurlEasyNum, lc_GlobalProxyPort)
	}

	lc_download(hCurlEasyNum,targetfile)

	lc_useProgressBar(hCurlEasyNum,1,progressbarLabel,progressbarTitle)

	return hCurlEasyNum
}

lc_addUpload(ByRef url,sourcefile="",progressbarTitle="",finishedLabel="",errorLabel="",progressbarLabel="lc_globalUploadProgress", dontKill=0)
{
	Global

	hCurlEasyNum := lc_initEasy()
	lc_setUrl(hCurlEasyNum,url)
	lc_dontKill(hCurlEasyNum,dontKill)

	if finishedLabel <>
		lc_setFinishedLabel(hCurlEasyNum,finishedLabel)

	if errorLabel <>
		lc_setErrorLabel(hCurlEasyNum,errorLabel)

	if sourcefile =
	{
		SplitPath, url, sourcefile
	}

	lc_upload(hCurlEasyNum,sourcefile)
	lc_useProgressBar(hCurlEasyNum,1,progressbarLabel,progressbarTitle)

	return hCurlEasyNum
}

lc_addHTTPPost(ByRef url, ByRef data="",finishedLabel="",errorLabel="",progressbarLabel="lc_globalUploadProgress", dontKill=0)
{
	Global

	if data !=
	{
		hCurlEasyNum := lc_initEasy()
		lc_setUrl(hCurlEasyNum,url)
		lc_dontKill(hCurlEasyNum,dontKill)

		if finishedLabel <>
			lc_setFinishedLabel(hCurlEasyNum,finishedLabel)

		if errorLabel <>
			lc_setErrorLabel(hCurlEasyNum,errorLabel)

		lc_setObject(hCurlEasyNum,"CURLOPT_POSTFIELDS", data)

		return hCurlEasyNum
	}
}

lc_addHTTPMultiPartPost(ByRef url, progressbarTitle="", finishedLabel="",errorLabel="",dontKill=0,progressbarLabel="lc_globalUploadProgress")
{
	Global

	hCurlEasyNum := lc_initEasy()
	lc_setUrl(hCurlEasyNum,url)
	lc_dontKill(hCurlEasyNum,dontKill)
	lc_curlPost[%hCurlEasyNum%] =
	lc_curlLast[%hCurlEasyNum%] =

	if finishedLabel <>
		lc_setFinishedLabel(hCurlEasyNum,finishedLabel)

	if errorLabel <>
		lc_setErrorLabel(hCurlEasyNum,errorLabel)

	lc_useProgressBar(hCurlEasyNum,1,progressbarLabel,progressbarTitle)

	return hCurlEasyNum
}

lc_addPostField(hCurlEasyNum,key,value)
{
	Global

	if key !=
	{
		lc_post[%hCurlEasyNum%] := lc_post[%hCurlEasyNum%] key "=" value "`n"

		IfExist, %value%
		{
			FileGetSize, lc_size[%hCurlEasyNum%], %value%
			DllCall("libcurl\curl_formadd", "UIntP", lc_curlPost[%hCurlEasyNum%], "UIntP", lc_curlLast[%hCurlEasyNum%],"Int", 1, "Str", key, "Int", 10, "Str", value, "Int", 17, "Cdecl")
		}
		else
			DllCall("libcurl\curl_formadd", "UIntP", lc_curlPost[%hCurlEasyNum%], "UIntP", lc_curlLast[%hCurlEasyNum%],"Int", 1, "Str", key, "Int", 4, "Str", value, "Int", 17, "Cdecl")
	}
}

lc_sendPostFields(hCurlEasyNum)
{
	Global

	DllCall("libcurl\curl_easy_setopt", "UInt", lc_easyHandles%hCurlEasyNum%, "UInt", 0x2728, "UInt", lc_curlPost[%hCurlEasyNum%], "Cdecl")
}


lc_setHeaders(hCurlEasyNum,headers)
{
	Global

	lc_slist_freeAll(lc_stringList[%hCurlEasyNum%])
	lc_stringList[%hCurlEasyNum%] =

	loop, parse, headers,`n
	{
		lc_stringList[%hCurlEasyNum%] := lc_slist_append(lc_stringList,A_LoopField)
	}

	lc_stringList := DllCall("libcurl\curl_easy_setopt", "UInt", lc_easyHandles%hCurlEasyNum%, "UInt", 0x2727, "UInt", lc_stringList[%hCurlEasyNum%], "Cdecl")
}


lc_slist_append(curl_slist,data)
{
	if data !=
	{
		curl_slist := DllCall("libcurl\curl_slist_append", "UInt", curl_slist, "Str", data)
	}

	return curl_slist
}

lc_slist_freeAll(curl_slist)
{
	DllCall("libcurl\curl_slist_free_all", "UInt", curl_slist)
}


lc_setUrl(hCurlEasyNum, ByRef url)
{
	Global
	lc_url[%hCurlEasyNum%] := url
	lc_setObject(hCurlEasyNum,"CURLOPT_URL",url)
}

lc_setErrorLabel(hCurlEasyNum, err)
{
	Global
	lc_errorLabel[%hCurlEasyNum%] := err
}

lc_setError(hCurlEasyNum, err)
{
	Global
	lc_error[%hCurlEasyNum%] := err
}

lc_dontKill(hCurlEasyNum,value=1)
{
	Global
	lc_reUse[%hCurlEasyNum%] = %value%
}

lc_useProxy(hCurlEasyNum, ByRef proxy)
{
	Global
	lc_proxy[%hCurlEasyNum%] := proxy
	lc_setObject(hCurlEasyNum, "CURLOPT_PROXY", proxy)
}

lc_proxyType(hCurlEasyNum, proxyType)
{
	Global

	lc_proxyType[%hCurlEasyNum%] := proxyType

	if proxyType = HTTP
		lc_setLong(hCurlEasyNum, "CURLOPT_PROXYTYPE", 0)

	if proxyType = SOCKS4
		lc_setLong(hCurlEasyNum, "CURLOPT_PROXYTYPE", 4)

	if proxyType = SOCKS5
		lc_setLong(hCurlEasyNum, "CURLOPT_PROXYTYPE", 5)
}

lc_proxyLogin(hCurlEasyNum, user, pass)
{
	Global

	lc_proxyLogin[%hCurlEasyNum%] := user ":" pass

	lc_setObject(hCurlEasyNum, "CURLOPT_PROXYUSERPWD", lc_proxyLogin[%hCurlEasyNum%])
}

lc_proxyPort(hCurlEasyNum, proxyPort)
{
	Global

	lc_proxyPort[%hCurlEasyNum%] := proxyPort

	lc_setLong(hCurlEasyNum, "CURLOPT_PROXYPORT", proxyPort)
}

lc_setCookie(hCurlEasyNum, ByRef cookie)
{
	Global
	lc_cookie[%hCurlEasyNum%] := cookie
	lc_setObject(hCurlEasyNum, "CURLOPT_COOKIE", cookie)
}

lc_readCookieFile(hCurlEasyNum, ByRef cookieFile)
{
	Global
	lc_inCookieFile[%hCurlEasyNum%] := cookieFile

	lc_setObject(hCurlEasyNum, "CURLOPT_COOKIEFILE", cookieFile)
}

lc_saveCookieFile(hCurlEasyNum, ByRef cookieFile)
{
	Global

	lc_outCookieFile[%hCurlEasyNum%] := cookieFile

	lc_setObject(hCurlEasyNum, "CURLOPT_COOKIEJAR", cookieFile)
}

lc_setFinishedLabel(hCurlEasyNum,ByRef finishedLabel)
{
	Global

	lc_label[%hCurlEasyNum%] := finishedLabel
}

lc_setPassword(hCurlEasyNum, userpassString)
{
	lc_setObject(hCurlEasyNum,"CURLOPT_USERPWD",userpassString)
}

lc_getInfoAfterTransfer(hCurlEasyNum, ByRef Speed, ByRef Time)
{
	Global

	lc_getInfo(hCurlEasyNum,CURLINFO_SPEED_DOWNLOAD%hCurlEasyNum%, 0x300000 + 9)
	lc_getInfo(hCurlEasyNum,CURLINFO_TOTAL_TIME%hCurlEasyNum%, 0x300000 + 3)

	Speed := Round(NumGet(CURLINFO_SPEED_DOWNLOAD%hCurlEasyNum%, 0, "Double"), 0)
	Time := Round(NumGet(CURLINFO_TOTAL_TIME%hCurlEasyNum%, 0, "Double"), 0)
}

lc_download(hCurlEasyNum,targetFile,callback="lc_WriteFunction",dontDelete=0)
{
	Global

	if dontDelete = 0
		FileDelete, %targetFile%

	hFile%hCurlEasyNum% := CreateFile(targetFile, 1)

	lc_type[%hCurlEasyNum%] := 1
	pCurl_WriteFunction := RegisterCallback(callback, "C F",4,hCurlEasyNum)
	lc_setFunction(lc_easyHandles%hCurlEasyNum%,"CURLOPT_WRITEFUNCTION",pCurl_WriteFunction)

	return
}

lc_upload(hCurlEasyNum,sourceFile,callback="lc_ReadFunction")
{
	Global

	IfExist, %sourceFile%
	{
		FileGetSize, lc_size[%hCurlEasyNum%], %sourceFile%

		hFile%hCurlEasyNum% := CreateFile(sourceFile, 3)
		lc_type[%hCurlEasyNum%] := 2

		lc_setLong(lc_easyHandles%hCurlEasyNum%,"CURLOPT_UPLOAD",1)
		pCurl_ReadFunction := RegisterCallback(callback, "C F",4,hCurlEasyNum)
		lc_setFunction(lc_easyHandles%hCurlEasyNum%,"CURLOPT_READFUNCTION",pCurl_ReadFunction)
	}
	return
}

lc_load(MaxParallelTransfers = 50)
{
	Global lc_moduleHandle, lc_easyHandlesNum, lc_hCurlMaxTransfers

	lc_hCurlEasyNums := 0
	lc_historySize := 0
	lc_hCurlMaxTransfers := MaxParallelTransfers

	lc_moduleHandle := DllCall("LoadLibrary", "str", "Library\libcurl.dll")

	If !lc_moduleHandle
		Return 0

	Return 1
}

lc_unload()
{
	Global lc_moduleHandle

	DllCall("FreeLibrary", "UInt", lc_moduleHandle)
}


lc_version()
{
  Return DllCall("MulDiv", "Int", DllCall("libcurl\curl_version"), "Int",1, "Int",1, "str")
}

; returns the first unused slot of lc_easyHandles
; see http://curl.haxx.se/libcurl/c/curl_easy_init.html
lc_initEasy()
{
	Global

	Loop, %lc_hCurlMaxTransfers%
	{
		if lc_easyHandles%A_Index% =
		{
			;space found
			lc_hCurlEasyNums++
			lc_easyHandles%A_Index%:= DllCall("libcurl\curl_easy_init")

			return A_Index
		}
	}
}

lc_getInfo(hCurlEasyNum, ByRef outputVar, Key)
{
	Global
	VarSetCapacity(outputVar, 8)
	DllCall("libcurl\curl_easy_getinfo", "UInt", lc_easyHandles%hCurlEasyNum%, "UInt", key, "UInt", &outputVar, "Cdecl")
}

lc_cleanUp(hCurlEasyNum)
{
	Global

	if lc_easyHandles%hCurlEasyNum% !=
	{
		DllCall("libcurl\curl_easy_cleanup", "UInt", lc_easyHandles%hCurlEasyNum%)
		lc_easyHandles%hCurlEasyNum% =
		lc_active%hCurlEasyNum% := 0
		lc_hCurlEasyNums--
	}
}

lc_addToHistory(hCurlEasyNum)
{
	Global

	lc_historySize++
	lc_history_pos[%hCurlEasyNum%] := lc_historySize
	lc_history_url[%lc_historySize%] := lc_url[%hCurlEasyNum%]
	lc_history_speed[%lc_historySize%] := lc_speed[%hCurlEasyNum%]
	lc_history_time[%lc_historySize%] := lc_time[%hCurlEasyNum%]
	lc_history_err[%lc_historySize%] := lc_error[%hCurlEasyNum%]
}

lc_globalDownloadProgress(clientp, dltotal_l, dltotal_h, dlnow_l, dlnow_h, ultotal_l, ultotal_h, ulnow_l, ulnow_h)
{
	Global

	VarSetCapacity(dltotal, 8, 0)
	NumPut(dltotal_l, dltotal, 0)
	NumPut(dltotal_h, dltotal, 4)

	VarSetCapacity(dlnow, 8, 0)
	NumPut(dlnow_l, dlnow, 0)
	NumPut(dlnow_h, dlnow, 4)

	lc_KBTotal[%A_EventInfo%] := Round((NumGet(dltotal, 0, "Double") / 1024), 2)
	lc_KBNow[%A_EventInfo%] := Round((NumGet(dlnow, 0, "Double") / 1024), 2)
	lc_Percent[%A_EventInfo%] := Round((NumGet(dlnow, 0, "Double") / NumGet(dltotal, 0, "Double") * 100), 2)

	gosub, lc_tim_Progress

	Return 0
}

lc_globalUploadProgress(clientp, dltotal_l, dltotal_h, dlnow_l, dlnow_h, ultotal_l, ultotal_h, ulnow_l, ulnow_h)
{
	Global

	ultotal := lc_size[%A_EventInfo%]

	VarSetCapacity(ulnow, 8, 0)
	NumPut(ulnow_l, ulnow, 0)
	NumPut(ulnow_h, ulnow, 4)

	lc_KBTotal[%A_EventInfo%] := Round((ultotal / 1024), 2)
	lc_KBNow[%A_EventInfo%] := Round((NumGet(ulnow, 0, "Double") / 1024), 2)
	lc_Percent[%A_EventInfo%] := Round((NumGet(ulnow, 0, "Double") / ultotal * 100), 2)

	gosub, lc_tim_Progress

	Return 0
}

lc_useProgressBar(hCurlEasyNum,value,function="Curl_ProgressFunction",ProgressTitle="")
{
	Global

	if value = 1
	{
		lc_setLong(lc_easyHandles%hCurlEasyNum%,"CURLOPT_NOPROGRESS",0)

		pCurl_ProgressFunction := RegisterCallback(function, "C F",9,hCurlEasyNum)
		lc_setFunction(lc_easyHandles%hCurlEasyNum%,"CURLOPT_PROGRESSFUNCTION",pCurl_ProgressFunction)
		lc_progressTitles[%hCurlEasyNum%] = %ProgressTitle%
	}
	else
	{
		lc_setLong(handle,"CURLOPT_NOPROGRESS",1)
		lc_progressTitles[%hCurlEasyNum%] =
	}
}

lc_addToQueue(hCurlEasyNum)
{
	Global

	lc_active%hCurlEasyNum% := 0
	lc_queueNum++
	lc_queueList = %lc_queueList%%hCurlEasyNum%|
}

lc_easyPerform(hCurlEasyNum)
{
	Global

	CURLOPT_ERRORBUFFER := 0x271A
	CURL_ERROR_SIZE := 0x100

	lc_active%hCurlEasyNum% := 1

	VarSetCapacity(CURL_ERROR, CURL_ERROR_SIZE + 1)
	DllCall("libcurl\curl_easy_setopt", "UInt", lc_easyHandles%hCurlEasyNum%, "UInt", CURLOPT_ERRORBUFFER, "UInt", &CURL_ERROR, "Cdecl")
	If lc_progressTitles[%hCurlEasyNum%] =
		Progress, T M2 FM10 FS8 C0 WM400 WS400 P0 w500 H65
	Else
		Progress, T M2 FM10 FS8 C0 WM400 WS400 P0 w500 H65,,,% lc_progressTitles[%hCurlEasyNum%]
	If DllCall("libcurl\curl_easy_perform", "UInt", lc_easyHandles%hCurlEasyNum%)
	  return CURL_ERROR
	Progress, Off
}

lc_closeFile(hCurlEasyNum)
{
	Global

	CloseHandle(hFile%hCurlEasyNum%)
}

lc_finish(hCurlEasyNum)
{
	Global

	lc_new_queueList =
	Loop, parse, lc_queueList, |
	{
		If A_LoopField != %hCurlEasyNum%
			lc_new_queueList = %lc_new_queueList%%A_LoopField%|
	}
	lc_queueNum--

	lc_queueList := lc_new_queueList
	lc_closeFile(hCurlEasyNum)
	Progress, Off
	lc_getInfoAfterTransfer(hCurlEasyNum,lc_speed[%hCurlEasyNum%],lc_time[%hCurlEasyNum%])
	lc_addToHistory(hCurlEasyNum)

	If lc_error[%hCurlEasyNum%] !=
	{
		if IsLabel(lc_errorLabel[%hCurlEasyNum%])
			SetTimer, % lc_errorLabel[%hCurlEasyNum%], -1
	}
	else
	{
		if IsLabel(lc_label[%hCurlEasyNum%])
			SetTimer, % lc_label[%hCurlEasyNum%], -1
	}

	if lc_reUse[%hCurlEasyNum%] != 1
	{
		lc_cleanUp(hCurlEasyNum)
	}
}



; ============================================================================
; ============ Private Functions ==============================================
; ============================================================================

lc_WriteFunction(pBuffer, size, nitems, pOutStream)
{
	Global

	return WriteFile(hFile%A_EventInfo%, pBuffer, size*nitems)
}

lc_ReadFunction(pBuffer, size, nitems, pOutStream)
{
	Global

	return ReadFile(hFile%A_EventInfo%, pBuffer, size*nitems)
}

lc_setObject(hCurlEasyNum,variable, ByRef value)
{
	Global

	;Objectpoint
	CURLOPT_WRITEDATA := 0x2711
	CURLOPT_URL := 0x2712            ; The full URL to get/put
	CURLOPT_PROXY := 0x2714          ; host of proxy to use.
	CURLOPT_USERPWD := 0x2715        ; "name:password" to use when fetching.
	CURLOPT_PROXYUSERPWD := 0x2716   ; "name:password" to use with proxy.
	CURLOPT_RANGE := 0x2717          ; Range to get, specified as an ASCII string.
	CURLOPT_ERRORBUFFER := 0x271A
	CURLOPT_POSTFIELDS := 0x271F     ; POST input fields.
	CURLOPT_REFERER := 0x2720        ; Set the referer page (needed by some CGIs)
	CURLOPT_FTPPORT := 0x2721        ; Set the FTP PORT string (interface name, named or numerical IP address)
												; Use i.e '-' to use default address.
	CURLOPT_USERAGENT := 0x2722      ; Set the User-Agent string (examined by some CGIs)
	CURLOPT_COOKIE := 0x2726         ; Set cookie in request
	CURLOPT_HTTPHEADER := 0x2727     ; This points to a linked list of headers, struct curl_slist kind
	CURLOPT_HTTPPOST := 0x2728       ; This points to a linked list of post entries, struct HttpPost
	CURLOPT_SSLCERT := 0x2729        ; name of the file keeping your private SSL-certificate
	CURLOPT_SSLKEYPASSWD := 0x272A   ; password for the SSL private key
	CURLOPT_QUOTE := 0x272C          ; send linked-list of QUOTE commands
	CURLOPT_COOKIEFILE := 0x272F     ; point to a file to read the initial cookies from,
												; also enables "cookie awareness"
	CURLOPT_POSTQUOTE := 0x2737      ; send linked-list of post-transfer QUOTE commands
	CURLOPT_INTERFACE := 0x274E      ;
	CURLOPT_KRBLEVEL := 0x274F       ;
	CURLOPT_CAINFO := 0x2751         ;
	CURLOPT_TELNETOPTIONS := 0x2756  ;
	CURLOPT_RANDOM_FILE := 0x275C    ;
	CURLOPT_COOKIEJAR := 0x2762      ;
	CURLOPT_SSL_CIPHER_LIST := 0x2763 ;
	CURLOPT_SSLCERTTYPE := 0x2766    ;
	CURLOPT_SSLKEY := 0x2767
	CURLOPT_SSLKEYTYPE := 0x2768
	CURLOPT_SSLENGINE := 0x2769
	CURLOPT_PREQUOTE := 0x276D
	CURLOPT_DEBUGDATA := 0x276F
	CURLOPT_CAPATH := 0x2771
	CURLOPT_SHARE := 0x2774
	CURLOPT_ENCODING := 0x2776
	CURLOPT_PRIVATE := 0x2777
	CURLOPT_HTTP200ALIASES := 0x2778
	CURLOPT_NETRC_FILE := 0x2786
	CURLOPT_IOCTLDATA := 0x2793
	CURLOPT_COOKIELIST := 0x2797
	CURLOPT_FTP_ALTERNATIVE_TO_USER := 0x27A3
	CURLOPT_SOCKOPTDATA := 0x27A5
	CURLOPT_SSH_PUBLIC_KEYFILE := 0x27A8
	CURLOPT_SSH_PRIVATE_KEYFILE := 0x27A9

	DllCall("libcurl\curl_easy_setopt", "UInt", lc_easyHandles%hCurlEasyNum%, "UInt", %variable%, "Str", value, "Cdecl")
}

lc_setLong(ByRef handle, variable, value)
{
	;Long
	CURLOPT_PORT := 0x3
	CURLOPT_TIMEOUT := 0xD           ; Time-out the read operation after this amount of seconds
	CURLOPT_LOW_SPEED_LIMIT := 0x13  ; Set the "low speed time"
	CURLOPT_LOW_SPEED_TIME := 0x14   ; Set the "low speed limit"
	CURLOPT_RESUME_FROM := 0x15      ; Set the continuation offset
	CURLOPT_CRLF := 0x1B             ; Send TYPE parameter?
	CURLOPT_SSLVERSION := 0x20       ; What version to specifly try to use. See CURL_SSLVERSION defines
	CURLOPT_TIMECONDITION := 0x21    ; What kind of HTTP time condition to use, see defines
	CURLOPT_TIMEVALUE := 0x22        ; Time to use with the above condition. Specified in UNIX Timestamp
	CURLOPT_VERBOSE := 0x29
	CURLOPT_HEADER := 0x2A
	CURLOPT_NOPROGRESS := 0x2B
	CURLOPT_NOBODY := 0x2C
	CURLOPT_FAILONERROR := 0x2D
	CURLOPT_UPLOAD := 0x2E           ; this is an upload
	CURLOPT_POST := 0x2F             ; HTTP POST method
	CURLOPT_FTPLISTONLY := 0x30      ; Use NLST when listing ftp dir
	CURLOPT_FTPAPPEND := 0x32        ; Append instead of overwrite on upload!
	CURLOPT_NETRC := 0x33
	CURLOPT_FOLLOWLOCATION := 0x34
	CURLOPT_TRANSFERTEXT := 0x35
	CURLOPT_PUT := 0x36              ; HTTP PUT
	CURLOPT_AUTOREFERER := 0x3A      ; We want the referer field set automatically when following locations
	CURLOPT_PROXYPORT := 0x3B
	CURLOPT_POSTFIELDSIZE := 0x3C
	CURLOPT_HTTPPROXYTUNNEL := 0x3D
	CURLOPT_SSL_VERIFYPEER := 0x40
	CURLOPT_MAXREDIRS := 0x44
	CURLOPT_MAXCONNECTS := 0x47
	CURLOPT_CLOSEPOLICY := 0x48
	CURLOPT_FRESH_CONNECT := 0x4A
	CURLOPT_FORBID_REUSE := 0x4B
	CURLOPT_HTTPGET := 0x50
	CURLOPT_SSL_VERIFYHOST := 0x51
	CURLOPT_HTTP_VERSION := 0x54
	CURLOPT_FTP_USE_EPSV := 0x55
	CURLOPT_SSLENGINE_DEFAULT := 0x5A
	CURLOPT_DNS_USE_GLOBAL_CACHE := 0x5B
	CURLOPT_DNS_CACHE_TIMEOUT := 0x5C
	CURLOPT_COOKIESESSION := 0x60
	CURLOPT_BUFFERSIZE := 0x62
	CURLOPT_NOSIGNAL := 0x63
	CURLOPT_PROXYTYPE := 0x65
	CURLOPT_UNRESTRICTED_AUTH := 0x69
	CURLOPT_FTP_USE_EPRT := 0x6A
	CURLOPT_HTTPAUTH := 0x6B
	CURLOPT_FTP_CREATE_MISSING_DIRS := 0x6E
	CURLOPT_PROXYAUTH := 0x6F
	CURLOPT_FTP_RESPONSE_TIMEOUT := 0x70
	CURLOPT_IPRESOLVE := 0x71
	CURLOPT_MAXFILESIZE := 0x72
	CURLOPT_FTP_SSL := 0x77
	CURLOPT_TCP_NODELAY := 0x79
	CURLOPT_FTPSSLAUTH := 0x81
	CURLOPT_IGNORE_CONTENT_LENGTH := 0x88
	CURLOPT_FTP_SKIP_PASV_IP := 0x89
	CURLOPT_FTP_FILEMETHOD := 0x8A
	CURLOPT_LOCALPORT := 0x8B
	CURLOPT_LOCALPORTRANGE := 0x8C
	CURLOPT_CONNECT_ONLY := 0x8D
	CURLOPT_SSL_SESSIONID_CACHE := 0x96
	CURLOPT_SSH_AUTH_TYPES := 0x97
	CURLOPT_FTP_SSL_CCC := 0x9A
	CURLOPT_TIMEOUT_MS := 0x9B
	CURLOPT_CONNECTTIMEOUT_MS := 0x9C
	CURLOPT_HTTP_TRANSFER_DECODING := 0x9D
	CURLOPT_HTTP_CONTENT_DECODING := 0x9E
	CURLOPT_NEW_FILE_PERMS := 0x9F
	CURLOPT_NEW_DIRECTORY_PERMS := 0xA0

	DllCall("libcurl\curl_easy_setopt", "UInt", handle, "UInt", %variable%, "Int", value, "Cdecl")
}

lc_setFunction(ByRef handle, variable, ByRef value)
{
	;Functionpoint
	CURLOPT_WRITEFUNCTION := 0x4E2B
	CURLOPT_READFUNCTION := 0x4E2C
	CURLOPT_PROGRESSFUNCTION := 0x4E58
	CURLOPT_HEADERFUNCTION := 0x4E6F
	CURLOPT_DEBUGFUNCTION := 0x4E7E
	CURLOPT_IOCTLFUNCTION := 0x4EA2
	CURLOPT_CONV_FROM_NETWORK_FUNCTION := 0x4EAE
	CURLOPT_CONV_TO_NETWORK_FUNCTION := 0x4EAF
	CURLOPT_CONV_FROM_UTF8_FUNCTION := 0x4EB0
	CURLOPT_SOCKOPTFUNCTION := 0x4EB4

	DllCall("libcurl\curl_easy_setopt", "UInt", handle, "UInt", %variable%, "UInt", value, "Cdecl")
}
