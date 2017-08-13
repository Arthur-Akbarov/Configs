ScriptName         = activAid
ScriptNameFull     = ac'tivAid
neededAHKversion   = 1.0.48.05
aa_osversionnumber       := func_GetOSVersion()
aa_osversionnumber_2000  := "5.0"
aa_osversionnumber_xp    := "5.1"
aa_osversionnumber_vista := "6.0"
aa_osversionnumber_7     := "6.1"
aa_osversionnumber_8     := "6.2"
aa_osversionname := "Windows " ( aa_osversionnumber = aa_osversionnumber_2000 ? "2000" : ( aa_osversionnumber = aa_osversionnumber_xp ? "XP" : ( aa_osversionnumber = aa_osversionnumber_vista ? "Vista" : ( aa_osversionnumber = aa_osversionnumber_7 ? "7" : ( aa_osversionnumber = aa_osversionnumber_8 ? "8" : "(unknown version)" ) ) ) ) )

httpAgent := ScriptName "/" ScriptVersion

InputEscapeKeys =
( LTrim Join
	{PrintScreen}{ScrollLock}{Pause}{PgUp}{PgDn}{Home}{End}{Ins}{Del}{BackSpace}
	{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{F13}{F14}{F15}{F16}{F17}{F18}{F19}{F20}{F21}{F22}{F23}{F24}{F25}{F26}{F27}{F28}{F29}{F30}
	{Space}{Left}{Right}{Up}{Down}{NumLock}{NumPad1}{NumPad2}{NumPad3}{NumPad4}{NumPad5}{NumPad6}{NumPad7}{NumPad8}{NumPad9}{NumPad0}{NumPadAdd}{NumPadSub}{NumPadMult}{NumPadDiv}{NumPadDot}{NumPadEnter}{NumPadDot}
	{a}{b}{c}{d}{e}{f}{g}{h}{i}{j}{k}{l}{m}{n}{o}{p}{q}{r}{s}{t}{u}{v}{w}{x}{y}{z}{ö}{ä}{ü}{ß}{1}{2}{3}{4}{5}{6}{7}{8}{9}{0}{@}{!}{"}{§}{$}{`%}{&}{/}{(}{)}{=}{+}{#}{-}{.}{,}{*}{'}{_}{:}{;}{<}{>}{^}{°}{´}{``}{[}{]}{\}{?}{|}{~}{{}{}}
	{AppsKey}{Esc}{Tab}{Enter}{CtrlBreak}{Help}{Sleep}
	{Browser_Back}{Browser_Forward}{Browser_Refresh}{Browser_Stop}{Browser_Search}{Browser_Favorites}{Browser_Home}
	{Volume_Mute}{Volume_Down}{Volume_Up}{Media_Next}{Media_Prev}{Media_Stop}{Media_Play_Pause}{Launch_Mail}{Launch_Media}{Launch_App1}{Launch_App2}
	{NumpadDel}{NumpadIns}{NumpadClear}{NumpadUp}{NumpadDown}{NumpadLeft}{NumpadRight}{NumpadHome}{NumpadEnd}{NumpadPgUp}{NumpadPgDn}
	{SC101}{SC102}{SC103}{SC104}{SC105}{SC106}{SC107}{SC108}{SC10a}{SC10b}{SC10c}{SC10d}{SC10e}{SC10f}
	{SC111}{SC112}{SC113}{SC114}{SC115}{SC116}{SC117}{SC118}{SC11a}{SC11b}{SC11f}
	{SC121}{SC123}{SC125}{SC126}{SC127}{SC128}{SC129}{SC12a}{SC12b}{SC12c}{SC12d}{SC12f}
	{SC131}{SC133}{SC134}{SC139}{SC13a}{SC13b}{SC13c}{SC13d}{SC13e}{SC13f}{SC140}
	{SC141}{SC142}{SC143}{SC144}{SC14a}{SC14c}{SC14e}
	{SC155}{SC156}{SC157}{SC158}{SC159}{SC15a}{SC15e}{SC160}
	{SC161}{SC162}{SC163}{SC164}{SC16b}{SC16e}{SC16f}{SC170}
	{SC171}{SC172}{SC173}{SC174}{SC175}{SC176}{SC177}{SC178}{SC179}{SC17a}{SC17b}{SC17c}{SC17d}{SC17e}{SC17f}
)
InputFromDevices =
( LTrim Join
	{Joy1}{Joy2}{Joy3}{Joy4}{Joy5}{Joy6}{Joy7}{Joy8}{Joy9}{Joy10}{Joy11}{Joy12}{Joy13}{Joy14}{Joy15}{Joy16}{Joy17}{Joy18}{Joy19}{Joy20}{Joy21}{Joy22}{Joy23}{Joy24}{Joy25}{Joy26}{Joy27}{Joy28}{Joy29}{Joy30}{Joy31}{Joy32}
	{2Joy1}{2Joy2}{2Joy3}{2Joy4}{2Joy5}{2Joy6}{2Joy7}{2Joy8}{2Joy9}{2Joy10}{2Joy11}{2Joy12}{2Joy13}{2Joy14}{2Joy15}{2Joy16}{2Joy17}{2Joy18}{2Joy19}{2Joy20}{2Joy21}{2Joy22}{2Joy23}{2Joy24}{2Joy25}{2Joy26}{2Joy27}{2Joy28}{2Joy29}{2Joy30}{2Joy31}{2Joy32}
	{LButton}{MButton}{RButton}{WheelUp}{WheelDown}{XButton1}{XButton2}{XButton3}{XButton4}
)

ChangeDirClasses = #32770,ExploreWClass,CabinetWClass,Afx:400000:0,FileZilla Main Window,bosa_sdm,TTOTAL_CMD,SC13MainFrame,SC12MainFrame,SC11MainFrame,SC10MainFrame,WinRarWindow,bosa_sdm_Mso96,ATL:ExplorerFrame,bosa_sdm_Microsoft Office Word 11.0,bosa_sdm_XL9,dopus.lister,ConsoleWindowClass,powershell.exe,TTntFormUltraExplorer.UnicodeClass
ExplorerAndDialogs = ExploreWClass,CabinetWClass,Progman,WorkerW,bosa_sdm,bosa_sdm_XL9,bosa_sdm_Mso96,bosa_sdm_Microsoft Office Word 11.0

SpecialFolder1 = 208D2C60-3AEA-1069-A2D7-08002B30309D ; Netzwerkumgebung
SpecialFolder2 = 20D04FE0-3AEA-1069-A2D8-08002B30309D ; Arbeitsplatz
SpecialFolder3 = 21EC2O2O-3AEA-1O69-A2DD-08002b30309d ; Systemsteuerun / Control Panel
SpecialFolder4 = 2227A280-3AEA-1069-A2DE-08002B30309D ; Drucker
SpecialFolder5 = 2227A280-3AEA-1069-A2DE-08002B30309D ; Printers and Faxes
SpecialFolder6 = 645FF040-5081-101B-9F08-00AA002F954E ; Papierkorb
SpecialFolder7 = 7007ACC7-3202-11D1-AAD2-00805FC1270E ; Netzwerkverbindungen/Network Connections
SpecialFolder8 = 7BD29E00-76C1-11CF-9DD0-00A0C9034933 ; Temporary Internet Files
SpecialFolder9 = A4D92740-67CD-11CF-96F2-00AA00A11DD9 ; DFÜ-Netzwerk
SpecialFolder10= BDEADF00-C265-11d0-BCED-00A0C90AB50F ; Web Folders
SpecialFolder11= D20EA4E1-3957-11d2-A40B-0C5020524152 ; Fonts
SpecialFolder12= D20EA4E1-3957-11d2-A40B-0C5020524153 ; Verwaltung/Administrative Tools
SpecialFolder13= D6277990-4C6A-11CF-8D87-00AA0060F5BF ; Geplante Tasks/Scheduled Tasks
SpecialFolder14= E211B736-43FD-11D1-9EFB-0000F8757FCD ; Scanners and Cameras
SpecialFolder15= FF393560-C2A7-11CF-BFF4-444553540000 ; Verlauf
SpecialFolder16= 21EC2020-3AEA-1069-A2DD-08002B30309D ; Systemsteuerung
SpecialFolderRun1 = ::{208D2C60-3AEA-1069-A2D7-08002B30309D} ; Netzwerkumgebung
SpecialFolderRun2 = ::{20D04FE0-3AEA-1069-A2D8-08002B30309D} ; Arbeitsplatz
SpecialFolderRun3 = ::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{21EC2020-3AEA-1069-A2DD-08002B30309D} ; Systemsteuerung
SpecialFolderRun4 = ::{2227A280-3AEA-1069-A2DE-08002B30309D} ; Drucker
SpecialFolderRun5 = ::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{2227A280-3AEA-1069-A2DE-08002B30309D} ; Printers and Faxes
SpecialFolderRun6 = ::{645FF040-5081-101B-9F08-00AA002F954E} ; Papierkorb
SpecialFolderRun7 = ::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{7007ACC7-3202-11D1-AAD2-00805FC1270E} ; Netzwerkverbindungen/Network Connections
SpecialFolderRun8 = ::{7BD29E00-76C1-11CF-9DD0-00A0C9034933} ; Temporary Internet Files doppelpunkt
SpecialFolderRun9 = ::{A4D92740-67CD-11CF-96F2-00AA00A11DD9} ; DFÜ-Netzwerk
SpecialFolderRun10= ::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{BDEADF00-C265-11D0-BCED-00A0C90AB50F} ; Web Folders
SpecialFolderRun11= ::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{D20EA4E1-3957-11d2-A40B-0C5020524152} ; Fonts
SpecialFolderRun12= ::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{D20EA4E1-3957-11d2-A40B-0C5020524153} ; Verwaltung/Administrative Tools
SpecialFolderRun13= ::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{D6277990-4C6A-11CF-8D87-00AA0060F5BF} ; Geplante Tasks/Scheduled Tasks
SpecialFolderRun14= ::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{E211B736-43FD-11D1-9EFB-0000F8757FCD} ; Scanners and Cameras
SpecialFolderRun15= ::{FF393560-C2A7-11CF-BFF4-444553540000} ; Verlauf

; Mauspfeil-Konstanten
IDC_APPSTARTING := 32650
IDC_HAND := 32649
IDC_ARROW := 32512
IDC_CROSS := 32515
IDC_IBEAM := 32513
IDC_ICON := 32641
IDC_NO := 32648
IDC_SIZE := 32640
IDC_SIZEALL := 32646
IDC_SIZENESW := 32643
IDC_SIZENS := 32645
IDC_SIZENWSE := 32642
IDC_SIZEWE := 32644
IDC_UPARROW := 32516
IDC_WAIT := 32514
IDC_HELP := 32651

gdiP_downloadLocation = http://www.microsoft.com/downloads/details.aspx?FamilyId=6A63AB9C-DF12-4D41-933C-BE590FEAA05A
