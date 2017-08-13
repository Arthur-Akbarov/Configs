; -----------------------------------------------------------------------------
; #############################################################################
; -----------------------------------------------------------------------------
; Name:               ac'tivAid RunAsHelper
; -----------------------------------------------------------------------------
; Version:            0.1
; Date:               2008-01-09
; Author:             Wolfgang Reszel
; Copyright:          2008 Heise Zeitschriften Verlag GmbH & Co. KG
; AutoHotkey Version: 1.0.47.05
; -----------------------------------------------------------------------------

#Notrayicon
#Persistent
Detecthiddenwindows, On

Command = %1%

ShellExecResult := DllCall("shell32\ShellExecuteA", uint, 0, str, "RunAs", str, Command,str, "", str, A_WorkingDir, int, 1)  ; Last parameter: SW_SHOWNORMAL = 1
ExitApp, %ShellExecResult%
