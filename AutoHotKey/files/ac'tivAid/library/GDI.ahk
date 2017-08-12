; --------------------------------------------------------------------------------------------------
; Library: no need to modify below

; Libary (could be put in extra file )
; #include <GDI.ahk>
; for documentation of commands see: http://msdn.microsoft.com/library/default.asp?url=/library/en-us/gdi/wingdistart_9ezp.asp

; -- highlevel not direct dllcall mapping , simplifiers
CreateDCBuffer(ByRef hdc_from, ByRef hdc_to, ByRef hbm_to, w ,h ) {
	; does not work, something wrong with ByRef and global
	hdc_to  := CreateCompatibleDC(hdc_from) ; buffer
	hbm_to  := CreateCompatibleBitmap(hdc_from,w,h)
	old     := SelectObject(hdc_to,hbm_to)
}

; -- mfc wrapper
;GetDC( hw ) {
;   return DLLCall("GetDC", UInt, hw )
;}

CreateDC( driver,device,output,mode  ) {
	return DLLCall("GetDC", UInt, driver, UInt, device, UInt, output, UInt, mode )
}

GDISetStretchBltMode( hdc , value ) {
	return DllCall("gdi32.dll\SetStretchBltMode", UInt,hdc, "int",value)
}

;CreateCompatibleDC( hdc ) {
;   return DllCall("gdi32.dll\CreateCompatibleDC", UInt,hdc)
;}

;is identically defined in gdip.ahk too
;CreateCompatibleBitmap( hdc , w, h ){
;	return DllCall("gdi32.dll\CreateCompatibleBitmap", UInt,hdc, Int,w, Int,h)
;}

;SelectObject( hdc , hbm ) {
;   return DllCall("gdi32.dll\SelectObject", UInt,hdc, UInt,hbm)
;}

;DeleteObject( hbm ) {
;   return DllCall("gdi32.dll\DeleteObject", UInt,hbm)
;}

;DeleteDC( hdc ) {
;   return DllCall("gdi32.dll\DeleteDC", UInt,hdc )
;}

;ReleaseDC( hwnd, hdc ) {
;   return DllCall("gdi32.dll\ReleaseDC", UInt,hwnd,UInt,hdc )
;}

;renamed from PrintWindow. is defined in gdip.ahk too
GDIPrintWindow( window_id , hdc , mode ) {
	return DllCall("PrintWindow", UInt, window_id , UInt,hdc, UInt, mode)
}

;StretchBlt( hdc_dest , x1, y1, w1, h1, hdc_source , x2, y2, w2, h2 , mode) {
;   return DllCall("gdi32.dll\StretchBlt"
;          , UInt,hdc_dest  , Int,x1, Int,y1, Int,w1, Int,h1
;             , UInt,hdc_source, Int,x2, Int,y2, Int,w2, Int,h2
;          , UInt,mode)
;}

;BitBlt( hdc_dest, x1, y1, w1, h1 , hdc_source, x2, y2 , mode ) {
;   return DllCall("gdi32.dll\BitBlt"
;          , UInt,hdc_dest  , Int, x1, Int, y1, Int, w1, Int, h1
;             , UInt,hdc_source   , Int, x2, Int, y2
;          , UInt, mode)
;}

;is identically defined in gdip.ahk too
;PaintDesktop(  hdc ) {
;	return DllCall("PaintDesktop", UInt, hdc )
;}

; constants
; see: http://www.adaptiveintelligence.net/Developers/Reference/Win32API/GDIConstants.aspx
; #SRCCOPY = 0xCC0020
