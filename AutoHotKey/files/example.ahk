#NoEnv        ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn         ; Enable warnings to assist with detecting common errors.
SendMode Input              ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
^k::
              Send, My First Script
Return
::btw::
              MsgBox You typed "btw".
Return
^j::
              MsgBox Wow!
              MsgBox this is
              Run, Notepad.exe
              winactivate, Untitled - Notepad
              WinWaitActive, Untitled - Notepad
              send, 7 lines{!}{enter}
              sendinput, inside the ctrl{+}j hotkey
Return
#i::
              run, http://www.google.com/
Return
; spell check
:*:acheiv::achiev
::achievment::achievement
::acquaintence::acquaintance
:*:adquir::acquir

!a::
              Send, arthur.akbarov@yandex.ru
Return
^b::          ; Ctrl & b Hotkey
              ; Copies the selected text. ^c could be used as well, but this method is more secure.
              send, {ctrl down}c{ctrl up}
              ; Wraps the selected text in bbcode (forum) Bold tags.
              SendInput, [b]{ctrl down}v{ctrl up}[/b]
Return        ; This ends the hotkey. The code below this point will not get triggered.
