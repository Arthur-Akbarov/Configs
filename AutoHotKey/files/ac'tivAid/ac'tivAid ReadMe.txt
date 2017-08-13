==============================================================================

                     ##          ##                 ###       ##         ##
                    ##   ##                        ## ##                 ##
    #####    #####       ##     ###   ##     ##    ## ##     ###     ######
        ##  ##   ##    ######    ##   ##     ##   ##   ##     ##    ##   ##
    ######  ##           ##      ##    ##   ##    #######     ##    ##   ##
   ##   ##  ##   ##      ##      ##     ## ##    ##     ##    ##    ##   ##
    ######   #####        ###  ######    ###     ##     ##  ######   ######
                                                                  ac'tivAid
   by the ac'tivAid community for c't

   Version:     1.3.2 development built by Michael
   Copyright:   2008 Heise Zeitschriften Verlag GmbH & Co. KG
   Contact:     activaid@heise.de (ac'tivAid community)
   Translation: quelbs@gmail.com (Michael Telgkamp)
   Homepage:    http://www.heise.de/ct/activaid/default_en.shtml
   Bugtracker:  http://activaid.rumborak.de
   Developer:   http://activaid.telgkamp.de/

   FAQ (German):
   http://www.heise.de/software/download/special/activaid_forte/10_11

   requires AutoHotkey Version: 1.0.47.06 (active: ###)

=============================================================================
Contents
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
1. Introduction
   1.1. Terms of a license
2. System requirements and installation
   2.1. ac'tivAid and limited user rights
   2.2. ac'tivAid uninstall
   2.3. ac'tivAid on an USB-Stick (Portable ac'tivAid)
   2.4. Tolerance of own scripts
3. Usability
   3.1. The search function
   3.2. Note for ac'tivAid and Proxy servers
4. Details on the modules of ac'tivAid
5. activAid - Configuration and Updating
   5.1. activAid - Further configuration in settings file
6. The extensions
   6.1. ComfortDrag - Switching and hiding windows while drag & drop
        operations
   6.2. MouseClip - copy and paste with the middle mouse button
   6.3. WebSearch - Fast web-search with hotkeys
      6.3.1. WebSearchOnMButton
   6.4. LikeDirkey - Change directory using number pad
      6.4.1. LikeDirkeyMenu
   6.5. FilePaste - Pastes copied files as plain text filenames or paths
   6.6. NewFolder - Create new folders
   6.7. CommandLine - The address bar of explorer as a command-line
   6.8. UserHotkeys - User defined hotkeys
   6.9. HotStrings - Automatic HotStrings
      6.9.1. HotStringsHotkey - Create HotString from selection
   6.10. ReadingRuler - Attach a line or a cross hair to the mouse cursor
   6.11. QuickChangeDir - Quickly change the directory
   6.12. QuickNote - Simple note window with direct saving
   6.13. Eject - Ejects CDs or other media
   6.14. MusicPlayerControl - Hotkeys for Media-Player
   6.15. MiddleButton - Assign actions to the middle mouse button (wheel)
   6.16. FreeSpace - Shows the free disk space in the title bar of explorer
   6.17. WindowsControl - Minimizing, maximizing and closing windows
   6.18. RecentDirs - A menu with recently used folders
   6.19. PackAndGo - Compile ac'tivAid for distribution
   6.20. LeoToolTip - Translate selected word
   6.21. ThesauroToolTip - Synonyms for German words
   6.22. AutoShutdown - Dialog to shutdown or logoff the system
   6.23. ComfortResize - Change the size of all windows and move them
   6.24. DriveIcons - Create links to drives on mounting
   6.25. FileRenamer - Rename multiple files or folders
   6.26. KeyState - Displays the status of CapsLock, ScrollLock and NumLock
   6.27. MultiClipboard - Multiple clipboards
   6.28. NewFile - Create a new file
   6.29. PastePlain - Insert clipboard without meta information
   6.30. PowerControl - Power management options
   6.31. ExplorerShrinker - Scales the explorer window to optimal size
   6.32. AppLauncher - Fast launch of start menu entries
   6.33. EmptyRecycler - Empty the recycle bin
   6.34. RemapKeys - Remap CapsLock / simulate the windows key
   6.35. LookThrough - Punches a hole into application windows
   6.36. ExplorerHotkeys - Hotkeys for explorer
   6.37. ScreenLoupe - Magnify the screen at the mouse cursor position
   6.38. PasteSerial - Paste serials from clipboard without dashes
   6.39. Calendar - Quick overview for months and years
   6.40. TransparentWindow - Provides window transparency
   6.41. UnComment - Adds or removes comment characters to the selected text
   6.42. CharacterAid - Aids to type special characters more simple
   6.43. TextAid - Special operations on selected text
   6.44. RemoveDriveHotkey - Removes external drives with a two level hotkey
   6.45. DateTimeDisplay - Displays a window with date and time
   6.46. ScreenShots - Allows to take shots from the screen
   6.47. AutoDeactivate - Deactivate ac'tivAid automatically
   6.48. VolumeSwitcher - Switches the volume between two values
   6.49. CalculAid - Improves working with the windows calculator
   6.50. ClipboardFilesManager - Delete/Backup files in Clipboard
   6.51. MultiMonitor - Hotkey to move windows between different monitors
   6.52. LimitMouse - Limit mouse to windows or monitors
   6.53. MouseWheel - Enable Mouse wheel also for inactive windows
   6.54. EditWith - Edit selected file
   6.55. MinimizeToTray - Minimize windows to tray icons
   6.56. JoyControl - Control Windows using a Joystick
   6.57. VolumeControl - Hotkeys for changing the system volume
   6.58. SpeechAction - Control Windows by voice
   6.59. TypeWith9Keys - On screen Keyboard for text input with T9
   6.60. RealExpose - Exposé clone
   6.61. Surrounder - Inserts surrounding-characters context sensitive
   6.62. FileHandle - Shows open file handles
   6.63. InputBlocker - Blocks mouse and keyboard input
   6.64. CronJobs - A time-based scheduling service
   6.65. MouseGestures - Control Windows by drawing symbols
   6.66. DesktopIcons - Saves and restores desktop icons
   6.67. TaskbarTools - Enables rearranging of taskbar buttons via drag'n'drop
   6.68. ActiveGoto - Supports autohotkey programming
7. Integration of own extensions and functionalities
8. Support for multiple languages
9. Overview of shortcuts
10. Frequently asked questions (FAQ)


_____________________________________________________________________________
 1. Introduction
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
ac'tivAid (pronunciation: activate) is a small tool that enhances Windows,
giving useful functions known from other operating systems. ac'tivAid is
developed with the script language AutoHotkey (http://www.autohotkey.com) and
the source is available.
Thanks to the quite simple syntax of AutoHotkey and the articles of the German
computer magazine c't, ac'tivAid is extendable quite simple.

Because many additional functions were added since the first version, the
concept has changed. The single functions are no longer combined in one large
script, but have been split. Now every function has its own script file. These
Scripts extend the main script which only has two main functions, the tray
menu and the graphical interface for configuration.

If you have problems with ac'tivAid or found a bug, you can report it at
http://activaid.rumborak.de
Or you can write an e-mail to (activaid@heise.de)

If ac'tivAid does not start, make sure you have the appropriate version of
AutoHotkey installed. You can download the newest version from:
http://www.autohotkey.com/download/
_____________________________________________________________________________
 1.1. Terms of a license
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
ac'tivAid is subject to the copyright of the
Heise Zeitschriften Verlag GmbH & Co. KG.
AutoHotkey is OpenSource and is licensed under GNU General Public License
Version 2.

ac'tivAid and AutoHotkey are allowed to use without restrictions for private
and commercial issues. However it is not allowed to make commercial use of
an unchanged or modified ac'tivAid. Modification and propagation of ac'tivAid
is allowed as long as the copyright comment of the Heise Zeitschriften Verlag
is not removed or modified.

The compiled version of ac'tivAid (e.g. created with PackAndGo) is partly
licensed under GNU General Public License (AutoHotkey) and the copyright of
the Heise Zeitschriften Verlag.

GPL v2:
http://www.gnu.org/licenses/gpl2.html

Source code of AutoHotkey (self-extracting archive):
http://www.autohotkey.com/download/AutoHotkey_source.exe

ac'tivAid additionally uses the following useful tools:
- DevEject: http://www.heise.de/ct/03/16/links/208.shtml
   © 2003 Heise Zeitschriften Verlag GmbH
- RemoveDrive: http://www.uwe-sieber.de/usbstick_e.html
   © 2006 Uwe Sieber
- SQLite: http://www.sqlite.org/
   Public Domain
_____________________________________________________________________________
 2. System requirements and installation
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
ac'tivAid requires Windows Vista, Windows XP or Windows 2000. Older versions
of Windows have not been tested, because AutoHotkey does not provide the
complete scope of operations and partly behaves differently. Additional the
interpreter for the script language AutoHotkey is needed. It is provided
together with the installation files and can also be downloaded here:
http://www.autohotkey.com/download

Some extensions have known restrictions regarding to the operating system. In
these cases it is always stated at the top of the help text of the extension.
Example: "Vista restrictions: Only works with classic XP Design."

There are also some known problems with specific system settings. In this case
the extensions are deactivated when installed the first time, or ac'tivAid
provides a possible solution for the problem.

ac'tivAid can be installed in any directory (e.g. C:\Program Files\ac'tivAid\)
using the provided installers.

After the first installation, no extension is active. To be able to use the
functions of ac'tivAid, first some extensions have to be installed using the
configuration (see chapter 3).

There is also a (German) FAQ page containing the most frequently asked
questions. It can be opened using the help menu of the configuration.
_____________________________________________________________________________
 2.1. ac'tivAid and limited user rights
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
In general ac'tivAid works well with limited user rights. In this case it
automatically starts in the multi-user mode.

For user accounts with administrative rights, ac'tivAid can be toggled between
single-user mode (default) and multi-user mode using the activAid menu in the
configuration. In single-user mode the settings are stored in the subdirectory
settings of the ac'tivAid directory (for Vista this does not apply see below).
In multi-user mode ac'tivAid saves the setting in the directory
"%appdata%\ac'tivAid". Using a link there, lets ac'tivAid think it is located
there. In General the setting "Start in" inside links define where the
settings are located.
In single-user mode for Vista the settings are saved in the directory
C:\ProgramData\ac'tivAid\settings because saving inside the program files
directory is not permitted.

To copy the settings from one user to another, only the settings directory has
to be copied to the corresponding directory of this user. The corresponding
menu entry in the ac'tivAid menu can also be used.

When using Portable ac'tivAid on an USB device, the behavior changes, and the
multi-user mode switches to a multi-computer mode. The settings are stored
dependent on the computer in the subdirectory "UserSettings\Computername"
inside the ac'tivAid directory.

Using the setting "Working directory:" in the ac'tivAid configuration, the
location of the settings can explicitly be set. More information in chapter 5.

When ac'tivAid is started using a manually created link, the link has to be
modified for the multi user mode, so "Start in" has to contain the directory
the settings are stored in. The automatically created link in the Autoruns
folder in the start menu is created correctly.

The following paragraph does not apply to the portable version.
To allow updates, ac'tivAid has to be run with administrator rights. To be
able to update ac'tivAid with limited user rights, it can be started as
another user, using the entry in the ac'tivAid menu.
Remark: This does not always work correctly, especially when other users are
logged in using fast user switching. In this case only the current user should
be logged in. In some cases only a restart helps.

Please note, that ac'tivAid in admin-mode is running in the context of the
administrative user. It does not provide administrative rights to the current
user, like the c't-project MachMichAdmin does.
_____________________________________________________________________________
 2.2. ac'tivAid uninstall
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
At the first launch of ac'tivAid the user is asked whether an uninstallation
routine should be added to Control Panel/Software.

ac'tivAid does not change the registry without a remark, so ac'tivAid can be
uninstalled by simply deleting it manually, when no entry is available in the
Windows Software dialog.

The uninstaller entry is placed in :
HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ac'tivAid

By deleting the line CreateUninstaller=0 in the file settings\ac'tivAid.ini
ac'tivAid asks again to add the ac'tivAid uninstaller into the installed
software on the next reload.
_____________________________________________________________________________
 2.3. ac'tivAid on an USB-Stick (Portable ac'tivAid)
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
There are two possibilities to launch ac'tivAid on an USB-stick. One is to use
the extension PackAndGo (explained in extensions part) to create a independent
executable file of ac'tivAid that can be placed in any folder of the stick.

The recommended variant is to use the portable version of ac'tivAid that is
available at http://www.heise.de/ct/activaid/. This version is prepared for
external devices and can be installed directly on the USB-Stick. There it is
launched using "Portable_ac'tivAid.exe".

When ac'tivAid displays "Portable ac'tivAid" in the title bar, the portable
version was recognized correctly. In this case the multi-user mode is not
available. It is replaces by a multi-computer mode. In this mode the settings
are stored in a subdirectory "UserSetting\ComputerName". This allows to
configure ac'tivAid differently depending on which computer the USB stick is
plugged in.

To copy the settings from single-user mode into the multi-computer profiles,
the settings directory has to be copied to the corresponding directory.

Many extensions allow to use the drive letter of  ac'tivAid.ahk (%Drive%)
or AutoHotkey.exe (%A_AutoHotkeyDrive%), which is useful when absolute paths
should be provided, that depend on the drive ac'tivAid or AutoHotkey is
located on.

Examples:
%Drive%\PortableApps\Firefox\FirefoxPortable.exe
%A_AutoHotkeyDrive%\PortableApps\Firefox\FirefoxPortable.exe
____________________________________________________________________________
 2.4. Tolerance of own scripts
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
In general, ac'tivAid should not cause problems with other scripts.
The only problems can occur, when functions overlap, e.g. when two scripts use
the same hotkeys. It is recommended to check the "Overview of all hotkeys" to
find overlapping hotkeys. By deleting the hotkey or uninstallation of the
extension, most problems can be solved. Slightly more complex are mouse
capturing events. Possibly the extensions ComfortDrag, ComfortResize or
MiddleButton has to be uninstalled to solve eventual problems.
_____________________________________________________________________________
 3. Usability
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
To be able to use ac'tivAid, AutoHotkey has to be available. If AutoHotkey is
installed, ac'tivAid is run by starting "ac'tivAid.ahk". The portable version
of ac'tivAid is run by starting Portable_ac'tivAid.exe.
After the start, a red c't icon is displayed in the system tray. A right click
opens a context menu. By selecting the menu entry or by double click on the
icon, the configuration dialog can be opened, where extensions can be
installed, uninstalled and configured. Also own hotkeys can be assigned and
ac'tivAid can be added to the auto run applications.

When settings are modified manually in the file ac'tivAid.ini (inside the
settings directory), ac'tivAid has to be reloaded in order to apply the
modifications.

ac'tivAid can be updated via Internet, this should be done occasionally,
because new versions always correct some problems. Furthermore often new,
useful functions are integrated. When a permanent connection to the internet
is available, a weekly check for updates can be set in the configuration.
More on this option in chapter 5.

It is also possible to assign mouse buttons as hotkeys. Therefor the Alt key
or the Shift key has to be pressed while clicking the button. In this case
only mouse or joystick buttons and special keys like Alt, Ctrl, Win, ... are
captured. The mouse wheel cannot be captured directly, but it can be assigned
by cursor up or cursor down.
_____________________________________________________________________________
 3.1. The search function
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Since ac'tivAid 1.1.2 a search function is integrated for all important
information areas like the "Help" or the "Overview of all hotkeys". When
entering text there, it performs an incremental search. Using F3 or Shift-F3
the next or previous match can be found.
_____________________________________________________________________________
 3.2. Note for ac'tivAid and Proxy servers
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
There are some known restrictions when accessing URIs using a proxy server.
The download command of AutoHotkey uses the proxy settings of the Internet
Explorer when connecting to the internet, but automatic configuration scripts
are known to cause problems. The proxy server has to be set manually inside
the "Internet options" that ac'tivAid is able to connect to the internet.
(see screen shot at: http://activaid.rumborak.de/?getfile=36)

When a manual authentication is required, ac'tivAid cannot connect to the
internet as far as currently known.

Beneath the automatic update, the extensions LeoToolTip and ThesauroToolTip
use the download command of AutoHotkey and thereby are subject to the
limitations mentioned above.

Some users report, that connection problems of ac'tivAid can be solved by
activation of the option "Use HTTP 1.1 through proxy connections" in the
Internet Explorer settings.
(http://activaid.rumborak.de/task/1344?getfile=450)

Extensions like WebSearch, that only call a browser are not affected.
_____________________________________________________________________________
 4. Details on the modules of ac'tivAid
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
The modular layout has a lot of advantages. Not installed extensions are not
just deactivated, but not even loaded together with ac'tivAid. Beneath the
advantage that less space is used, also complications with other programs can
be avoided. When a problem occurred in early versions of ac'tivAid, it could
not be used at all, because an inactive function still was monitoring the
hotkey and just did not cause an action. When ac'tivAid is compiled to a
single exe file using the extension PackAndGo, only the installed extensions
are packed into the file.

The modular layout and some limitations of AutoHotkey limit the functionality
of the compiled version of ac'tivAid. If possible, the usage of ac'tivAid or
Portable ac'tivAid is recommended. Especially because the compilation does not
improve the performance, because AutoHotkey compiles every AHK-Script in front
of compilation inside the memory.
_____________________________________________________________________________
 5. activAid - Configuration and Updating
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Inside the configuration dialog there is the possibility to set basic settings
and to check for available updates on the page "activAid".

ac'tivAid can be updated via Internet, this should be done occasionally,
because new versions always correct some problems. Furthermore often new,
useful functions are integrated. When a permanent connection to the internet
is available, a weekly check for updates can be set in the configuration.

When updating ac'tivAid all settings and the own new extensions are kept.
Manual changes inside the ac'tivAid script or in the provided extensions will
be overwritten. When provided extensions are changed and the settings should
be kept, the file has to be renamed to prevent overwriting. Modifications on
these scripts should be reported to us, so we could adapt the original scripts
in order to give the profit to all users.

In cases where the automatic update does not work (e.g. because of a proxy
server or a firewall, see 3.2), the most recent version can be downloaded
and installed manually. The button "Manual update" opens the download page and
closes ac'tivAid (this is recommended for a correct installation). The
semiautomatic update of earlier versions had been removed because of various
problems.

- resolve keyboard and mouse-problems
   Tools based on AutoHotkey, carry all bugs of AutoHotkey itself. Because of
   this it can possibly happen, that the left mouse button looks like pressed
   for the system, although it is already released, e.g. after excessive use
   of ComfortDrag. This for example causes problems with double clicks. In
   that case this function of ac'tivAid tries to resolve the problems.

   Default-Hotkey:
   Win + Shift + #        - resolve keyboard and mouse-problems

- Temporary disable hotkeys
   For many hotkeys it may happen, that a hotkey is set, that is required
   inside a program. To be able to use it anyway, this function can be used to
   deactivate all hotkeys of ac'tivAid as long as the key set here is pressed.
   During the key is pressed, a hint is shown.

   The hotkey is implemented in a way that the original function is still
   available when pressing the key only a short time. Unfortunately on some
   systems there is a problem that does not allow the original function when
   pressing the key for a short time.

- Context menu with all functions
   Calls a menu at the current cursor position that lists all extensions with
   all containing functions. By choosing a menu entry, the function is
   executed. Some functions like HotStrings don't work correctly in all cases.

   Default-Hotkey:
   Win + <                - Context menu with all functions

- Working directory
   The working directory can only be changed by users that have write rights
   in the ac'tivAid directory. This setting applies to all users, but it can
   be configured using variables so every user can have its own settings.
   The following variables can be of interest:
   %A_ScriptDir%             - The settings are saved in the settings folder
                               inside the ac'tivAid directory.
   %A_AppData%\ac'tivAid     - The settings are saved in the ac'tivAid folder
                               inside the application data folder of the user
                               (this equals the multi-user mode).
   D:\ac'tivAid\%A_UserName% - The settings are saved in a folder with the
                               name of the user inside of D:\ac'tivAid.
   %A_MyDocuments%\ac'tivAid - The settings are saved in a subfolder ac'tivAid
                               inside the user specific "My documents" folder.
   More information on the working directory can be found in chapter 2.1.
   More variables can be found in the AutoHotkey help at
   http://www.autohotkey.com/docs/Variables.htm#BuiltIn
_____________________________________________________________________________
 5.1. activAid - Further configuration in settings file
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
There are some hidden options, that only can be modified by manually editing
the settings file ac'tivAid.ini in the settings folder.

The ini file is divided into different sections. Each extension has its own
section, that is started by the name of the extension in square brackets.
The main settings of ac'tivAid are below the row [activAid].

The following hidden settings are available for ac'tivAid:
DelayedUpdateCheck = 30 ; Delays the check for updates at the start of
                          ac'tivAid by 30 seconds. That is useful when no
                          connection to the internet is available at system
                          start, or if it always is available some time later.
ReloadOnWakeUp = 1      ; Automatically reloads ac'tivAid when the computer
                          wakes up after hibernation or standby. This option
                          helps, when ac'tivAid behaves in a strange way after
                          the system wakes up.
DebugToFile = file.txt ;  The debug information are stored in the logfile
                          given here, instead of being sent to DebugView.
                          (additionally DebugLevel = ALL and Debug = 1 has to
                          be set)
Silentupdate = 1        ; The automatic update is done without security check.
WinModifierFirst = 1    ; Defines that hotkeys are not displayed
                          Ctrl + Win + ... but instead Win + Ctrl + ...
_____________________________________________________________________________
 6. The extensions
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Extensions are small AutoHotkey scripts, that are located in the subdirectory
"extensions" inside the ac'tivAid installation. ac'tivAid scans this folder
for matching extensions and provides them for installation in the "Extensions"
section of the configuration dialog. ac'tivAid only loads installed
extensions. All extensions listed at "available Extensions" are ignored and
thereby only need little space on the hard disk.

There has to be a special format of the extension file that it is recognized
by ac'tivAid. Further information on this can be found in chapter 7.
_____________________________________________________________________________
 6.1. ComfortDrag - Switching and hiding windows while drag & drop operations
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
This is a main function of ac'tivAid that is somehow responsible for the name
ac'tivAid.

ComfortDrag simplifies the copying and moving of files, especially when there
are lots of windows opened. A short time after you drag a file with you mouse
over a window, it will be activated. Additionally windows can be minimized by
clicking with the right mouse button while keeping the left button pressed.
When the left mouse button is released, the windows are restored. Because of
compatibility reasons regarding to mouse Gestures, this only works on the
title bar for browser windows (configurable). Applications that have problems
working together with ComfortDrag can be excluded in the configuration dialog.
This exclusion only refers to the recognition of a Drag&Drop action. When
ComfortDrag is initiated in another window the excluded applications still
work fine.

Furthermore ComfortDrag gives access to other directories by showing the
folders bar when the mouse waits on the left side of an Explorer window.
By releasing the mouse button the bar is hidden again.

Similar to Exposé of Apple OS X it is possible to activate the function
"temporary desktop" where all visible windows are slided away and release the
view on the Desktop. This functionality is configurable for fast computers to
animate the sliding. Unfortunately on Windows machines it is not as elegant as
the OS X variant.

On some systems it is possible, that maximized windows cannot be adjusted by
ComfortDrag. In this case there is the option "resolve problems with maximized
windows" in the configuration. With the checkbox marked gray/green ComfortDrag
tries to avoid flickering of these windows, but the original size of the
restored (non maximized) window is not kept.

The following hotkeys are available while the left mouse button is pressed.

ESC                - Restores the windows and aborts the action.

right mouse button - Minimizes the window below the mouse cursor. Also works
page-up key          when clicking on window titles with left and right mouse
                     button. On release of the left mouse button the window is
                     restored.

CapsLock           - When holding the CapsLock key pressed while releasing the
                     mouse button, the window below the mouse cursor stays
                     activated. Doing this a window can be chosen.

middle mouse button- Restores windows that have been minimized by the right
page-down key        mouse button one by one. When no windows had been
                     minimized, the window below the mouse cursor is
                     activated if the window has already been active the
                     window below is activated. This makes it possible to
                     switch between two overlapping windows.

F10                - Shows the desktop by moving all visible windows to the
(configurable)       left and right screen edges, which also works during a
                     drag&drop action. By pressing the hotkey again, the
                     windows reappear. This also happens by clicking on the
                     left or right screen edge.

Space              - Immediately activates the window below the mouse cursor.
                     The timeout is skipped.
_____________________________________________________________________________
 6.2. MouseClip - copy and paste with the middle mouse button
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
MouseClip assigns three functions to the middle mouse button.

1. Marking text using the middle mouse button copies it to clipboard.
2. Clicking with middle mouse button while text is marked inserts this text
   on the position where the click took place.
3. Clicking with nothing marked inserts the content of the clipboard.

The option two and three can be deactivated separately. Especially option 3
should be deactivated when using a mouse with a wheel that can be clicked by
mistake. In this case the content of the clipboard would be unwillingly
inserted which can be bad because it is often not recognized.

By default MouseClip is not active if the standard mouse cursor (white arrow)
is shown. By this it is still possible to use the middle mouse button with
different software. In Firefox for example, the scroll function can still be
activated by using the middle mouse button as long as the pointer is not
located above text. Only with the text cursor visible, MouseClip catches the
middle mouse button. For the ability to mark text using the middle mouse
button it simulates the left mouse button pressed. That means the middle mouse
button equals the left mouse button during MouseClip is active.

In the configuration window- or element classes can be given where MouseClip
is also active although the white mouse cursor is displayed. An element class
is a part of a application window, for example the address bar in a browser or
the text field in a mail application.

The entry "MozillaWindowClass5" allows to select text in Thunderbird without
the need of the pointer positioned above text. As mentioned above MouseClip
only performs a click of the left mouse button, what cases a lack of the
option to open links in a new window or Tab using the middle button. In cases
where this option is preferred before marking text, the entry should be
removed from the list.

For class names also * is allowed as wild-card, whereby complete groups of
element classes can be defined (e.g. MozillaWindowClass*).
_____________________________________________________________________________
 6.3. WebSearch - Fast web-search with hotkeys
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
WebSearch allows quick access to often used search engines providing freely
assignable Hotkeys and a search dialog. The base of the search is the selected
text.

There is one Hotkey (default: Win+W) that calls a dialog where search engines
can be selected. Additionally hotkeys can be assigned to each single search
engine, to perform the search operation for the selected word immediately.
When no text is selected and the hotkey is pressed the dialog is displayed
where the search term can be entered.

In the configuration dialog any number of search engines can be added and
hotkeys can be assigned to them. Also for each search engine the browser that
is called can be defined. To be able to quickly identify the search engine the
corresponding favicon can be downloaded and displayed in the dialog. If a page
does not provide a favicon, ac'tivAid could pause for a while due to
limitations of AutoHotkey. After a short while ac'tivAid should work properly
again.

When the search dialog is used often, it is recommended to provide ALT
shortcuts by typing an ampersand (&) in front of the favored character. For
example G&oogle means that ALT+o performs the search action in the dialog. The
option to encode the search term is useful when problems occur during
submission of umlauts or other special characters.

The URL of the search engine has to include a placeholder (###), which is
replaced by the selected text when calling the search engine. It is possible
to provide multiple placeholders (##1##, ##2##, ...) where each one represents
one word. In this case terms containing spaces has to be surround by quotes.

Advice for Firefox: To be able to simultaneously look up a term in multiple
search engines, the option "current tab" for new pages should not be active.

Advice for Internet Explorer: To be able to simultaneously look up a term in
multiple search engines, the option "Reuse windows for launching shortcuts"
has to be disabled.

Beside the settings in the configuration dialog there is a hidden setting that
can be done in the file ac'tivAid.ini. They have to be provided below section
[WebSearch].

MultipleOpenDelay = 500 :  When multiple search engines are called at the same
                           time, this value defines the waiting time between
                           two requests in milliseconds. If Firefox or IE open
                           everything in the same window, increasing of this
                           value can help to solve the problem.

Default-Hotkeys:
Win+W           - Starts WebSearch dialog
Win+Shift+L     - Directly search with Leo
Win+Shift+G     - Directly search with Google
Win+Shift+W     - Directly search with Wikipedia
Win+Shift+T     - Directly search with Wortschatz-Lexikon
_____________________________________________________________________________
 6.3.1. WebSearchOnMButton
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
With MouseClip activated, the text selected with middle mouse button is looked
up using WebSearch immediately.
_____________________________________________________________________________
 6.4. LikeDirkey - Change directory using number pad
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
LikeDirkey owes his name to the small Freeware-Tool Dirkey
(http://www.protonfx.com/dirkey/). Using LikeDirkey one can assign keys Win+0
to Win+9 respectively Ctrl+0 to Ctrl+9 to directories. This allows to quickly
jump to the corresponding directory. Using the Win hotkey a new Explorer
window is opened always, Using the Ctrl hotkey LikeDirkey tries to change the
directory of the current window. To allow this, the address bar has to be
visible inside the Explorer window.

In order to work together with NiftyWindows, LikeDirkey has to use the numbers
of the numpad. This is the standard setting and can be set in the
configuration dialog.

Beside directories also system variables like %APPDATA% can be used. Even
Paths of the Registry can be opened. For these the Syntax looks like the
following: HKEY_CURRENT_USER,Keypath\...,Name

Prepending a hash character (#HKEY_CURRENT_USER,Keypath\...,Name) it is
possible to write the current directory to Registry using Ctrl+Win+0-9
instead of changing the Entry in LikeDirkey.

To be able to use special directories of Windows, their class ID has to be
provided. The most important IDs for Windows XP are:
::{20D04FE0-3AEA-1069-A2D8-08002B30309D} - My Computer
::{645FF040-5081-101B-9F08-00AA002F954E} - Recycle bin
::{208D2C60-3AEA-1069-A2D7-08002B30309D} - Network neighborhood
::{A4D92740-67CD-11CF-96F2-00AA00A11DD9} - Dial-up Network
::{2227A280-3AEA-1069-A2DE-08002B30309D} - Printers
::{FF393560-C2A7-11CF-BFF4-444553540000} - History
::{D6277990-4C6A-11CF-8D87-00AA0060F5BF} - Scheduled Tasks
Control                                  - Control Panel

System directories can be provided using the corresponding AutoHotkey variable
%A_WinDir%          - Windows directory
%A_ProgramFiles%    - Program Files directory (most times C:\Program Files)
%A_AppData%         - Current user's application-specific data
%A_AppDataCommon%   - All-users application-specific data
%A_Desktop%         - Current user's desktop files
%A_DesktopCommon%   - All user's desktop files
%A_StartMenu%       - Current user's Start Menu folder
%A_StartMenuCommon% - All user's Start Menu folder
%A_Startup%         - Startup folder in the current user's Start Menu
%A_StartupCommon%   - Startup folder in the all-users Start Menu
%A_MyDocuments%     - Current user's "My Documents" folder
%A_ScriptDir%       - Directory where ac'tivAid is located

More variables can be found in the help of AutoHotkey at
http://www.autohotkey.com/docs/Variables.htm#BuiltIn

Default-Hotkeys:
Win + 0-9       - Open Explorer with the directory saved in configuration.
Ctrl + 0-9      - Switch to saved directory in current Explorer window
Ctrl+Win + 0-9  - Save current directory to shortcut (only inside Explorer)
Win + NumPlus   - List all saved directories in a context menu.
                  (only together with the extension LikeDirkeyMenu, see below)
_____________________________________________________________________________
 6.4.1. LikeDirkeyMenu
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Expands LikeDirkey by providing a hotkey that displays a context menu showing
all directory shortcuts. This extension is integrated into the configuration
page of LikeDirkey.

The extension RecentDirs mentioned below also provides the option to display
the hotkeys in a menu.
_____________________________________________________________________________
 6.5. FilePaste - Pastes copied files as plain text filenames or paths
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
After copying a file in Explorer using Ctrl+C the filename can be pasted into
any application as text using the defined hotkey. There are multiple options
to define the format of the filename.
More precise descriptions can be found in the ToolTips when waiting with the
mouse cursor above the corresponding option.

Default-Hotkeys:
Ctrl+Win+V   - paste the textual content of the clipboard, e.g. file paths or
               filenames of files copied in Explorer
_____________________________________________________________________________
 6.6. NewFolder - Create new folders
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Vista restrictions: "Automatically type into the Search Box" must not be
                    enabled inside Folder Options!

Inside Explorer, file dialogs and on the Desktop it is possible to create
folders directly, using the configurable hotkey. The long way round the menu
can be skipped. Using the additional hotkeys it is also possible to create a
new folder that already contains predefined subfolders. It is also possible to
create complete directory structures like:

images
images\RGB
images\RGB\web
images\RGB\rawdata
images\CMYK

The creation of folders only works when the complete path is displayed in the
title bar or in the address bar of the Explorer window. In some cases the
address bar has to be visible too. In the folder options, the setting where to
display the path can be set.

The option "Ask for the folder name in a dialog" shows a dialog instead of
creating the folder and marking it for renaming. In the dialog the name is
asked and also subfolders can be created directly by providing the path
(new folder\subfolder\subsubfolder). The dialog is only available for explorer
windows and not in file dialogs.

Using the dialog it is also possible to change directly to the created folder.

Inside folder names also AutoHotkey variables are supported.
%A_YYYY%-%A_MM%-%A_DD% for example results in the current date in ISO format.
More information on the variables can be found here:
http://www.autohotkey.com/docs/Variables.htm#BuiltIn

Default-Hotkeys:
Ctrl+N             - Create new folder in Explorer
Ctrl+Shift+N       - Create new folder with subfolders in Explorer
Ctrl+Alt+Shift+N   - Directly create subfolders in Explorer
_____________________________________________________________________________
 6.7. CommandLine - The address bar of explorer as a command-line
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Typing < followed by a DOS-command, the command will be executed. When typing
it two times << the command is executed without console window.

<       - in the address bar of Explorer window: induces command line commands
_____________________________________________________________________________
 6.8. UserHotkeys - User defined hotkeys
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Vista restrictions: No restrictions are known, but because of the complexity,
                    it is possible that some restrictions are not observed.

UserHotkeys allows to assign as many hotkeys as available to any program,
function, URL or directory. That is especially useful for external AutoHotkey
scripts, which are not included in ac'tivAid. As an example the script 320Mph
by Rajat is included and the Hotkey Ctrl+Shift+Space is assigned. This script
allows a fast access to the start menu entries similar to the extension
AppLauncher which is included since ac'tivAid 1.1.

The hotkeys can be sorted in categories for a better overview. Above the list
of the hotkeys the display can be limited to one category. In addition a
hotkey can be assigned to a category, that displays a menu with all included
hotkeys. This is helpful to create quick start menus.

Using Alt+Up/Down and Alt+Home/End or dragging by mouse or using the context
menu the entries can be assorted manually.

Some special commands are supported. They have to be placed at the beginning
of the command line.

<PasteFile>             The content of a file is inserted at the cursor
                        position. Using the button "Save clipboard as file for
                        <PasteFile>" in the creation dialog the content of the
                        clipboard is stored in the subdirectory
                        settings/Clipboards.

<Send>                  The text following <Send> is written as simulated
                        keyboard input. Modifiers like the ones listed at
                        the HotStrings section.  (+, ^, etc.)
                        The complete list of modifiers can be found in the
                        AutoHotkey help for the Send command:
                        http://www.autohotkey.com/docs/commands/Send.htm
                        To write modifiers to the output they have to be put
                        into curly braces. {+}{^}
                        The character ` is a special case (escape character of
                        AutoHotkey) and has to be duplicated to be recognized
                        correctly. ``

<SendRaw>               Similar to <Send>, but modifiers are not considered.

<Send Delay:X>          Works for <Send> and <SendRaw> and causes a delay
                        between the output of two characters. The X stands for
                        the number of milliseconds between the output.

<ControlSend>           Similar to the ControlSend command of AutoHotkey. It
                        allows the sending of keyboard input to hidden and
                        minimized programs. It is possible to send input to a
                        specific GUI element using <ControlSend>Edit1,ABC or
                        to send input to ahk_parent using <ControlSend>ABC
                        where ahk_parent is the main window. For ControlSend
                        "Only for the following applications" needs to be set.

<ControlClick>          Similar to the ControlClick command of AutoHotkey.
                        Allows the sending of mouse clicks on buttons inside
                        hidden or minimized programs. It is possible to send a
                        click to a button directly <ControlClick>Button1 or to
                        send a click to coordinates relatively to the upper
                        left corner of the window using <ControlClick>X10 Y20
                        For ControlClick "Only for the following applications"
                        needs to be set. Additional parameters can be provided
                        after the following pattern:
                        <ControlSend>Control/Pos,WhichButton,ClickCnt,Options

                        Control/Pos = Control-Name or Position (Xn Yn)
                        WhichButton = LEFT, RIGHT, MIDDLE, X1 or X2
                        Options = See AutoHotkey documentation:
                      http://www.autohotkey.com/docs/commands/ControlClick.htm

<ChDir>                 Change of directory in current Explorer window
                        (like LikeDirkey)

<Reload>                Reload ac'tivAid.

<ListHotkeys>           Display a list of all hotkeys in a window.

<ListLines>             Display a list of recently executed script commands.

<ListVars>              Display a list of all variables.

<KeyHistory>            Display a list of recently pressed keys.

<ExitApp>               Exit ac'tivAid.

<getControl>            Write the name of the window element below the mouse
                        pointer to clipboard.

<getColour>             Write the color code of the pixel below the mouse
                        pointer to clipboard. When adding #<RGB> or 0x<RGB>
                        the color code is formatted like desired. On some
                        systems <RGB> leads to a inaccurate display.

<getControlText>        The content of the window element below the mouse
                        pointer is written to clipboard. This is a way to copy
                        the label of a button. For ListViews, ListBoxes or
                        DropDown lists, the selected text can be copied, too.
                        When the command is sent again, the complete text of
                        the list is copied. Also window titles are captured.

<SingleInstance>        When this command is written in front of a program
                        path, the program will be started only once. When
                        pressing the hotkey multiple times, the window of the
                        program is restored or minimized.
                        Limitations: This only works for programs that are
                        executed directly. A lot of Java software (like
                        FreeMind) and also some portable applications use a
                        special executable for loading purposes which is
                        terminated directly after execution.
                        If a document should be opened, the executable to open
                        this document has to be provided, because otherwise
                        ac'tivAid can not recognize the program that opened
                        the document.

<Single>                Similar to <SingleInstance>, but the window is not
                        minimized on pressing the hotkey again.
                        Limitations are the same as for <SingleInstance>.

<SingleInstanceClose>   Adding this command the program is opened once. When
                        pressing the hotkey again the program is closed.
                        Limitations are the same as for <SingleInstance>.


<SingleInstanceKill>    Similar to <SingleInstanceClose>, but the process is
                        killed after half a second if it does not terminate.
                        Please use careful because unsaved data can be lost!
                        Limitations are the same as for <SingleInstance>.

<AOT>                   This command opens the window in always on top mode.
                        <AOT> can be combined with <SingleInstance>.
                        When AOTModifyTitle=1 is set in ac'tivAid.ini in
                        section [UserHotkey], <AOT> modifies the window title
                        to make the mode visible.

<Min>,<Max>,<Hide>      The window of the program is opened minimized,
                        maximized or hidden.

<WheelUp>,<WheelDown>   Sends mouse wheel up/down command to the current
                        window. This allows to scroll using the keyboard.

<MouseMoveTo>x,y        Moves the mouse cursor to the specific position x,y
                        on the monitor. (The parameter s of previous versions
                        is not supported any longer.)

<MouseMoveBy>x,y,s      Moves the mouse cursor by the specific values x,y
                        on the monitor. Can be used to create a keyboard
                        mouse, together with "<send>{Click}" which performs
                        a mouse click. (The parameter s of previous versions
                        is not supported any longer.)

<CategoryMenu>          Display a category menu. This command is created
                        automatically, when a category shortcut is assigned.
                        To create separators an entry with neither shortcut
                        nor command but the corresponding category has to be
                        added. If the command does not provide a category, a
                        menu with all categories is shown. The commands are
                        displayed as submenus.

<CategoryLaunchAll>     Executes all commands of the category the hotkey is
                        created for. The category is not given as command,
                        but as category.

<AltTab>, <ShiftAltTab> These commands allow to assign the Alt-Tab menu
<AltTabAndMenu>         (Task-Switcher) to a hotkey like Shift+MouseWheel.
<AltTabMenuDismiss>

<WorkingDir:"...">      Defines the working directory. For example
                        %ComSpec%<WorkingDir:"C:\">
                        calls the command line interpreter (cmd.exe) in a way
                        that the starting directory is set to C:\.

<PostMessage>           Realization of the AutoHotkey command which uses the
                        following syntax:
                        <PostMessage>Msg, wParam, lParam, Control, WinTitle...
                        Example: Toggle shuffle for winamp
                        <PostMessage>0x111,40023,,,ahk_class Winamp v1.x

<activAid>              Calls the declared subroutine of the ac'tivAid source.
                        This function has to be used very careful, because it
                        can cause damages. The new option of AppLauncher to
                        display instructions of ac'tivAid can be used to
                        determine the correct subroutines.
                        Some interesting subroutines:
                        sub_Statistics - Statistic window
                        sub_VarDumpGUI - Check values of variables
                        sub_OpenSettingsDir - Open settings directory
                        sub_ShowDuplicates - Show window of duplicate hotkeys

<ShowExtensionMenu>     Directly calls the context menu of an extension, that
                        otherwise is displayed as submenu in the context menu
                        in the menu of all functions.
                        Example: <ShowExtensionMenu>HotStrings

<Config>                Calls the simple configuration of a single extension.
                        Example: <Config>HotStrings

<OnShutDown>            The provided command is executed automatically before
                        the shutdown of the machine using PowerControl or
                        AutoShutDown. This for example allows to execute a
                        backup script before shutting down the machine.
                        AutoShutDown and PowerControl look up all entries of
                        UserHotkeys and execute all where <OnShutDown> is
                        present. That means the entries can still be called
                        using a hotkey, if one is added.

Environment variables are supported as well as all variables provided by
AutoHotkey. Variables has to be enclosed by % characters (e.g. %USERNAME%).
If the % character has to be used itself, the ` sign has to be prepended.
Example: <send>100 `%

The available variables can be found in the documentation of AutoHotkey:
http://www.autohotkey.com/docs/Variables.htm#BuiltIn

UserHotkeys also provides a special variable named %Selection%. It is replaced
by the currently selected text when the hotkey is pressed. For the command
<Send> there is the special variable %SelectionPaste% which is only available
for <Send>. At the position the variable is placed it is replaced by Ctrl+V
and before the command is executed the selection is put into the clipboard.

To be able to use special directories of Windows, their class ID has to be
provided. The most important IDs for Windows XP are:
::{20D04FE0-3AEA-1069-A2D8-08002B30309D} - My Computer
::{645FF040-5081-101B-9F08-00AA002F954E} - Recycle bin
::{208D2C60-3AEA-1069-A2D7-08002B30309D} - Network neighborhood
::{A4D92740-67CD-11CF-96F2-00AA00A11DD9} - Dial-up Network
::{2227A280-3AEA-1069-A2DE-08002B30309D} - Printers
::{FF393560-C2A7-11CF-BFF4-444553540000} - History
::{D6277990-4C6A-11CF-8D87-00AA0060F5BF} - Scheduled Tasks
Control                                  - Control Panel
Control Appwiz.cpl                       - Control Panel/Software

System directories can be provided using the corresponding AutoHotkey variable
%A_WinDir%          - Windows directory
%A_ProgramFiles%    - Program Files directory (most times C:\Program Files)
%A_AppData%         - Current user's application-specific data
%A_AppDataCommon%   - All-users application-specific data
%A_Desktop%         - Current user's desktop files
%A_DesktopCommon%   - All user's desktop files
%A_StartMenu%       - Current user's Start Menu folder
%A_StartMenuCommon% - All user's Start Menu folder
%A_Startup%         - Startup folder in the current user's Start Menu
%A_StartupCommon%   - Startup folder in the all-users Start Menu
%A_MyDocuments%     - Current user's "My Documents" folder
%A_ScriptDir%       - Directory where ac'tivAid is located

Hotkeys can be limited to single programs. For indication a part of the window
title, the window class with prefix "ahk_class " or as special case the text
"ExplorerAndDialogs" can be given. ExplorerAndDialogs is valid for all
Explorer windows and file dialogs. This makes it possible to replace
LikeDirkey together with <ChDir>. To invert the behavior the statement has to
begin with [not]. This allows to exclude programs.
Multiple window names can be divided by comma but this is not possible for
multiple window classes (ahk_class).

For the special commands <ControlSend> or <ControlClick> ahk_class defines the
remotely controlled program which even does not have to be active.

When the file settings\custom-variables.ini is created it is possible to
define own variables that are available using %VARIABLE%. The file has to have
the following format:
VARIABLE = Value
(Characters allowed for variable names: A-Z 0-9 # _ @ $ ? [ ])
_____________________________________________________________________________
 6.9. HotStrings - Automatic HotStrings
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Often used text snippets can be called via abbreviations using "HotStings".

If ac'tivAid is compiled using the extension PackAndGo, HotStrings cannot be
changed any longer. If you need HotStrings in a compiled version, you have to
configure them before you use PackAndGo to create the executable.

It's best to explain the options on the basis of an example.
The abbreviation "Sy" is set to "Sincerely yours". The options have the
following results:

• default (no options)
  Sy is replaced after a space or a punctuation mark is typed before and after
  the abbreviation Sy.
  blah Sy blah = blah Sincerely yours blah
  blah sy blah = blah Sincerely yours blah
  blahsy blah  = blahsy blah
  blah syblah  = blah syblah
  "Sy"       = "Sincerely yours"
  sy,        = Sincerely yours,

• replace immediately (otherwise after Space, Enter ...)
  Sy is replaced directly after typing the letter y by the text module so it's
  not waited for space or punctuation mark. This option is useful to specify a
  chosen character for replacement. If all abbreviations and with < it is more
  unlikely to replace text unwillingly (for example "Sy<", "DSoM<", ...)

• ignore the character which causes the replacement
  This option causes the character that induces the replacement not to be
  typed. If you type a space after Sy it is not typed after "Sincerely yours".
  blah Sy blah = blah Sincerely yoursblah
  "Sy"         = "Sincerely yours
  Sy,          = Sincerely yours

• replace inside words
  The abbreviation is also replaced when typed inside a word.
  blasybla = blaSincerely yoursbla

• don't replace abbreviation but append the text
  sy = sySincerely yours

• case sensitivity
  • yes
    Sy = Sincerely yours
    sy = sy
    SY = SY

  • ignore case
    Sy = Sincerely yours
    sy = Sincerely yours
    SY = SINCERELY YOURS

  • ignore case and don't transpose case
    Sy = Sincerely yours
    sy = Sincerely yours
    SY = Sincerely yours

• output control-commands like {Enter}{Left} as plain text
  Normally control-commands like {Enter} are executed during replacement so
  {Enter} produces a new line. With this option active the text is typed as it
  is written.

• substitute !, +, ^, and # with Alt, Ctrl, Strg or Windows
  If checked, special single-character control-commands in the text are
  transformed to keyboard input that means ^a results in Ctrl+A, what results
  in the whole text marked in most applications.

Here you get a small overview of the available control-commands. A complete
list can be found in the documentation at:
http://www.autohotkey.com/docs/commands/Send.htm
Remark: ac'tivAid does not re-recognize controls it sends on its own!

{F1} - {F24}                function key
{!}                         !
{#}                         #
{+}                         +
{^}                         ^
{{}                         {
{}}                         }
{ENTER}                     Enter/Return
{ESCAPE}/{ESC}              Escape key
{SPACE}                     Space key
{TAB}                       Tabulator

{BACKSPACE}/{BS}            Backspace
{DELETE}/{DEL}              Delete
{INSERT}/{INS}              Insert
{UP}                        Cursor up
{DOWN}                      Cursor down
{LEFT}                      Cursor left
{RIGHT}                     Cursor right
{HOME}                      Home
{END}                       End
{PGUP}                      Page up
{PGDN}                      Page down

{CapsLock}                  Caps lock
{ScrollLock}                Scroll lock
{NumLock}                   Num

{CONTROL}/{CTRL}            Ctrl
{LCONTROL}/{LCTRL}          left Ctrl
{RCONTROL}/{RCTRL}          right Ctrl
{CONTROLDOWN}/{CtrlDown}    Presses Ctrl key, until released with {CtrlUp}

{ALT}                       Alt
{LALT}                      left Alt
{RALT}                      right Alt
{AltDown}                   Presses Alt key, until released with {AltUp}

{SHIFT}                     Shift
{LSHIFT}                    left Shift
{RSHIFT}                    right Shift
{ShiftDown}                 Presses Shift key, until released with {ShiftUp}

{LWIN}                      left Windows
{RWIN}                      right Windows
{LWinDown}                  Presses left  Win key,until released with {LWinUp}
{RWinDown}                  Presses right Win key,until released with {RWinUp}

{AppsKey}                   context menu
{SLEEP}                     Standby
{ASC nnnn}                  send ASCII code - Example: {ALT 0149} results in •

{PRINTSCREEN}               Print
{CTRLBREAK}                 Ctrl+Pause
{PAUSE}                     Pause

Examples:
- Dear Sir or Madam{Left 13}+{Right 13}
- first name{Tab}last name{Tab}street{Tab}location
- ^atext module replaces complete text selected by Ctrl{+}A

Since ac'tivAid 1.0.4 also small AutoHotkey scripts can be provided. The
option "AutoHotkey-commands" has to be activated. Because an error in these
scripts cause ac'tivAid not to start any longer the scripts has to undergo
a "syntax-check" before "Apply" can be pressed.
Later Errors can only be corrected by manually correcting them in the file
settings/Hotstrings.ini.

Since ac'tivAid 1.0.5 it is possible to limit HotStrings to single programs.
The limitation refers to parts of the title of the window. To limit a
HotString to OpenOffice, "- OpenOffice.org" has to be written as window title.
Important remark: The comparison is case sensitive!
With "Not for this Appl." checked, HotStrings can be excluded from programs.

When the file settings\custom-variables.ini is created it is possible to
define own variables that are available using %VARIABLE%. The file has to have
the following format:
VARIABLE = Value
(Characters allowed for variable names: A-Z 0-9 # _ @ $ ? [ ])

To insert formatted HotStrings there are two possibilities.
1. Shortcuts can be sent to the application to activate formatting.
   Example for OpenOffice ("substitute !, +, ^, and #..." has to be active):
   normal text ^+fbold text^+f nomal text
   Alternative: {Ctrl down}{Shift down}f{Ctrl up}{Shift up} instead of ^+f

2. This possibility takes usage of the button "Save clipboard as file" at the
   right bottom of the configuration. This option saves the current clipboard
   content to a file and the currently active HotString is filled with a small
   script that reads the file and paste it to the current application.

If the output of HotStrings does not work properly or behaves in an unwanted
way (e.g. with Google Desktop), the SendPlay mode can be activated for single
HotStrings. It is named SendPlay because it is adapted to work together with
games. SendPlay is slower than the normal mode and sends the keys directly to
the active program. This also means the start menu cannot be opened by sending
{LWin}. Also only Keys can be sent, that are available for the current active
keyboard layout.

It is possible to provide global HotStrings in a network. Therefor the
designated HotStrings should be created on one machine. Afterwards the file
HotStrings.ini has to be moved to a network drive. Now on every computer that
is supposed to share these HotStrings the HotStrings.ini has to be modified
by adding the following line at the top of it:
#Include *i N:\path\HotStrings.ini
Where N is the drive letter of the network drive.
It is important that there are no identical HotStrings on the local machine,
because otherwise ac'tivAid will stop with an error message. The *i is given
to disable a possible error message when the file is not available for some
reason. The external HotStrings are displayed in the configuration but cannot
be modified.

To avoid displaying comments of manually modified HotSting files inside the
configuration, the following comment combinations can be used:
;*   ;;    ;!   ;-   ;=   ; -   ; =

More information can be found here:
http://www.autohotkey.com/docs/commands/Send.htm
http://www.autohotkey.com/docs/commands/SendMode.htm
http://tinyurl.com/43vbda (German)
http://www.heise.de/software/download/special/activaid_forte/10_11 (German)
_____________________________________________________________________________
 6.9.1. HotStringsHotkey - Create HotString from selection
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

HotStringsHotkey is a simple extension that provides a hotkey for creating
HotStrings out of the currently selected Text. The new HotString is not saved
immediately, but the configuration window is displayed with the new HotString
to allow changing the options.
_____________________________________________________________________________
 6.10. ReadingRuler - Attach a line or a cross hair to the mouse cursor
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
This extension provides a line across the monitor that can be used as a ruler
to simplify reading. This line follows the mouse cursor and can be toggled by
pressing the hotkey. There is the possibility to display a vertical line or
both lines optionally.

The color, transparency and thickness is freely configurable. The additional
options to display the window class or the element class are mainly only
interesting for developers.

If the start position is displayed, ReadingRuler also works together with
ScreenShots and passes the spanned area to ScreenShots.

By pressing the Ctrl key twice with short time between, the start position can
be repositioned.

Default-Hotkeys:
Win + Plus                   Toggle reading ruler
_____________________________________________________________________________
 6.11. QuickChangeDir - Quickly change the directory
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Using QuickChangeDir it is possible to change to a directory, without knowing
exactly where it is located. After a part of the directory name is given,
QuickChangeDir lists all considerable directories.

To allow a quick search, there is a previously created index for the drives.
The folder is not looked up on the drives itself. Using the configuration
dialog the directories and drives that should be indexed can be defined. Less
folders make the list more simple and speed up the indexing process. So only
the required folders should be included. (see "schedule indexing ..." below)

For long result lists, the search results in the result window can be further
narrowed down. Using Ctrl+Up/Down entries that contain the input can be
selected directly.

Using the arrow menu in the search dialog or the check-button in the
configuration dialog single drives or directories can be re-indexed.

The address bar has to be visible in explorer windows to allow directory
changes.

In general typing the drive letter limits the search to this drive (Example:
C:search item) and thereby speeds up the process. This can be useful as a
"default search item". When putting "C:" there, the search dialog is
initialized with this value, so the search is limited to drive C by default.
To look up a folder in all drives, the "C:" can be deleted.

Using a wildcard (*) allows to omit substrings. Additionally not only the name
of the folder is looked up, but the complete path. When a wildcard is present,
the search operation slows down.

Examples for wildcards:
*Explorer            (the path has to end with "Explorer")
*Explorer*           (the path contains "Explorer" somewhere inside)
Explorer*            (the directory has to begin with "Explorer")
C:*Explorer          (like the first one, but limited to drive C)
Program*Explorer*    (finds "Explorer*" only as a subfolder of "Program*")

schedule indexing ...:
The scheduled indexing keeps the index of directories up to date. Because the
indexing slows down the system because of a lot of disk accesses, scheduled
indexing at special times or special events is recommended. A real time index
is not possible with AutoHotkey. That means newly created directories can only
be found after re-indexing.

There are multiple types of schedules for indexing that can be combined.

- Indexing if the drive-space changed
   This is only recommended, when few directories are indexed and the index
   has to be actualized quite often. When the free drive-space changes by the
   given amount, the indexing is directly done.

- Indexing at a appointed time
   This setting is useful for servers or other computers that are permanently
   working. It allows indexing at night time or at noon.

- Indexing every X hours
   Mostly suitable for servers to keep shared drives up to date.

- Indexing at shutdown/poweroff (only with AutoShutdown or PowerControl)
   This is recommended for single user computers. When the computer is shut
   down using AutoShutdown or PowerControl, the indexing is done before the
   computer shuts down. When shutting down using the start menu the indexing
   is not initiated.

Beside the settings in the configuration there is a hidden setting that can be
set in the file QuickChangeDir.ini:

[History]
HistoryLength = xxx ; Defines how many entries are recorded in the history


Default-Hotkeys:
Win + Minus                   Dialog for the directory change
_____________________________________________________________________________
 6.12. QuickNote - Simple note window with direct saving
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
QuickNote is a very simple, but quickly accessible note window. It can be
toggled by Hotkey and saves every change directly to hard disk, that means on
a crash no data is lost. QuickNote is especially useful for notices during a
phone call.

Below the note there is the possibility to activate a timer. The note is then
displayed at the specified date and time automatically and a sound is played.

Using the compact view hides the title bar and the timer options. In this view
the note is only movable and scalable using ComfortResize, but this view is
useful because all the space it uses is available for displaying the note.
Another option allows to hide the scroll bars to have more space for the note.

The acoustic signal of the timer can be changed in a hidden setting inside the
file ac'tivAid.ini in the settings directors. Below [QuichNoteX] the following
line has to be added: SoundFile = C:\pfad\datei.wav

QuickNote only supports one note. If more notes are required, the script can
be duplicated using the button "Duplicate QuickNote script". The duplicated
scripts work completely independent and can be configured freely. Duplicated
QuickNote scripts are numbered serially (QuickNote1, QuickNote2, ...).
The duplication of the script is not possible for the PackAndGo version.

If a wildcard (*) is set in front of the path, QuickNote first tries to find
the file in the folder of the currently active Explorer window. If it is not
found, the global file is opened. This setting is useful for notes in folders
of a project.

The colors of background and text can be changed by inserting the hexadecimal
value or by selecting it by mouse (double click on the color field).

In addition to the hidden setting SoundFile, there are these additional ones:
UndoFile = xxx      ; Defines the path of the undo file.
MaxUndos = 50       ; Defines the maximum number of stored UNDO steps
TimerMenu = xxx     ; Allows to manually modify the timer menu.
                      Default setting:
                      TimerMenu = 1m, 2m, 3m, 4m, 5m, 6m, 7m, 8m, 9m, 10m,
                                  12m, 15m, 20m, 25m, 30m, 40m, 45m, 50m, 55m,
                                  -, 1h, 1½h, 2h, 3h, 4h, 5h, 10h, -, 1d, 2d,
                                  3d, 4d, 5d, 6d, 7d
ShutdownDelaySeconds = xxx ; Number of seconds for
                              "Show note window for X seconds at shutdown"

The following shortcuts are available when editing a note:

Ctrl+Del:           Delete word behind cursor
Ctrl+Backspace:     Delete word before cursor
Ctrl+A:             Select all
Ctrl+D:             Insert date
Ctrl+L:             Insert line
Ctrl+R:             Execute selection (URL, path, ...)
Ctrl+Z:             Undo
Ctrl+Y:             Redo
Ctrl+S oder Escape: Close note
Ctrl+E:             Export selection
Ctrl+P:             Print note
Ctrl+K:             Toggle compact mode
Ctrl+F:             Search text
F3:                 Search next
Shift+F3:           Search previous
Drag&Drop:          Insert file path
Ctrl+Up/Down:       Scroll

Default-Hotkeys:
F12:                Toggle note window
_____________________________________________________________________________
 6.13. Eject - Ejects CDs or other media
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Eject can be used to define 11 hotkeys for opening and closing the CD trays.
Using DevEject (from c't 16/03) also memory cards can be ejected from multi
card readers. In combination with the tool RemoveDrive (by Uwe Sieber) it also
allows to perform a safe remove of USB sticks.
For all operations a transparent on screen display similar to the one of OS X
can be displayed.

Since version 0.6 the wildcard (*) can be used as a special drive symbol. This
allows to remove the currently selected drive. This option recognizes a
selected link on the Desktop as well as an active Explorer window or a
selected drive in "My Computer".

It is also possible to eject multiple drives by writing them in a comma
separated list. "AllCD" is a keyword to eject all CD drives.

To eject drives using DecEject, a drive name has to be created by using the
button "Custom devicenames". In the dialog a device can be connected with a
drive name. In the left column the name has to be given (e.g. USB-Stick). The
right column can be filled in multiple ways. If the name is a drive letter,
the device ID pressing the arrow button (->) tries to find the drive ID. In
the drop down list all device IDs are listed. Remark that in this list also
non drives like external WLAN-devices or keyboards are listed.

The selected device ID is used as parameter -EjectID for DevEject.
Alternatively this parameter for DevEject can be entered manually (no ' or \
is allowed in this name). Also the drive letter can be entered, if the device
ID does not work or if it looks to risky for you.

The tool RemoveDrive by Uwe Sieber can be called by typing "RemoveDrive X:" in
the field "assigned device", where X is the drive letter. This tool is always
able to remove external USB drives if no open handle is left. With the
additional option "RemoveDrive X: -l" (loop) RemoveDrive keeps trying to
remove the drive continuously. This improves the reliability, but can cause
the Eject display to stay on screen if RemoveDrive is not successful.

The user defines devices can be selected in the drive drop down list inside
the configuration of Eject.

Default-Hotkeys:
ScrollLock          Eject first optical device
Ctrl+Shift+E        Eject selected device (*)
_____________________________________________________________________________
 6.14. MusicPlayerControl - Hotkeys for Media-Player
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
This script allows to control WinAmp, iTunes, FooBar 2000 and Windows Media
Player with global hotkeys.

If MusicPlayerControl does not work together with iTunes, a re-installation of
iTunes most times can solve the problem.

MusicPlayerControl can also simulate the media keys of an extended keyboard.
This is only done if the option is active and none of the supported players
had been available. Because there are no media keys for the special Controls,
they do only work for the supported applications that are supported. When no
supported application is found, a BalloonTip with a message is displayed.

For support of programs that do not have an entry in the Registry, the file
ac'tivAid.ini has to be edited and the corresponding setting has to be
inserted below [MusicPlayerControl]. The corresponding name is shown in an
InfoScreen if the program is activated, but no executable is found.
<Programmname>Path = <Pfad>

Default-Hotkeys:
Win + Cursor left:             Previous title
Win + Cursor right:            Next title
Win + Del:                     Pause
Win + Shift + Cursor left:     Rewind (Not working for all player software)
Win + Shift + Cursor right:    fast-forward
Win + Shift + Cursor up:       WinAmp/iTunes volume up
Win + Shift + Cursor down:     WinAmp/iTunes volume down
Win + End:                     Stop
Win + Home:                    Play
_____________________________________________________________________________
 6.15. MiddleButton - Assign actions to the middle mouse button (wheel)
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Offers a selection of actions that can be assigned to the middle mouse button.

Single window- or element classes can be defined as exceptions, where the
middle mouse button keeps the original function. For class names also wildcard
(*) is allowed to allow groups of element classes to be caught.
Example: MozillaWindowClass*

When problems with menus of Firefox occur, the adding of element class
MozillaDropShadowWindowClass helps, which is added by default since ac'tivAid
version 1.1.7.32.
_____________________________________________________________________________
 6.16. FreeSpace - Shows the free disk space in the title bar of explorer
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Vista restrictions: Displaying of the free space in the title bar only works
                    with classic XP Design.

FreeSpace changes the title bar of all Explorer windows and displays the
amount of free space of the current drive.
_____________________________________________________________________________
 6.17. WindowsControl - Minimizing, maximizing and closing windows
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
WindowsControl allows to define hotkeys for essential window operations as
minimizing, maximizing, closing and changing the size to special formats.

Additionally there is an option to kill a program without waiting for a
response. This is useful for hanging applications.

The option "Window always on top" toggles the always on top mode for a window,
that means it cannot be covered by other windows.

Default-Hotkeys:
Win + Space:                Minimize window
Win + Alt + Ctrl + Space:   Maximize window
Win + Alt + Ctrl + c:       Center window
Win + Alt + Ctrl + left:    Maximize window on left half of the screen
Win + Alt + Ctrl + right:   Maximize window on right half of the screen
Win + Alt + Ctrl + up:      Maximize window on upper half of the screen
Win + Alt + Ctrl + down:    Maximize window on lower half of the screen
Win + H:                    Maximize window only in vertical range
Win + W:                    Maximize window only in horizontal range
Win + X:                    Close program/window
Win + Shift + Home:         Toggle always on top mode (AOT)
Win + Shift + Del:          Kill process (Remind: not saved data is lost)
_____________________________________________________________________________
 6.18. RecentDirs - A menu with recently used folders
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Vista restrictions: works fine, but not yet tested wit Office.

In most file dialogs Windows provides access to the recently used files and
folders. Most times the files listed here are not required and slow down the
process. RecentDirs provides a context menu that only reads the links to
directories listed in the "Recent" directory and sorts them chronological.
The last used directory is found at the top of the menu. Because Microsoft
Office has its own directory to store recent files, both directories are read
and the results are sorted chronological.

Selecting a directory activates this directory in the active dialog or
Explorer window. If no Dialog or Explorer window is active, a new Explorer is
opened. By pressing Ctrl, Shift or Windows during selection this behavior can
be forced.

Additionally RecentDirs allows to tidy up the "Recent" directories of Windows
and Microsoft Office. This speeds up RecentDirs as well as the internal
Windows function. The tidying up is done on every call of RecentDirs and can
additionally be scheduled every 5 minutes in background.

Using "alternative presentation" affects the layout of the menu. Further
details are shown in the ToolTip of the option.

Default-Hotkeys:
Win + Del:        List recently visited directories
_____________________________________________________________________________
 6.19. PackAndGo - Compile ac'tivAid for distribution
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
This extension allows the creation of a compiled EXE version of ac'tivAid. It
takes care of compiling the additional scripts like QuickChangeDir Indexer and
the UserHotkey scripts and creates a single EXE file where all scripts are
embedded. So only the EXE file has to be distributed. All required files, like
this ReadMe and the icon files are extracted during the first launch.

All settings that are set at compiling time are stored, too. For the extension
HotStrings remark that HotStrings cannot be modified in the compiled version.

After compilation the EXE file can be moved automatically or an application or
script can be called. This is useful for administrators that only pass the EXE
version and make them available in a commonly available directory. Using a
script would allow to automatically spread the new file via Mail.

The option "Enable uninstall of the exe-file" configures whether the EXE
version writes uninstall information to the registry on first launch. This
would allow users to uninstall ac'tivAid like other software.
_____________________________________________________________________________
 6.20. LeoToolTip - Translate selected word
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
LeoToolTip is able to look up the selected word on "http://dict.leo.org". The
translation is shown in a ToolTip or in a menu that can either be called by a
hotkey or by selecting text with the middle mouse button. The latter has to be
activated in the configuration and is only available when MouseClip is active.

To display the ToolTip for a longer time, the mouse cursor has to be moved on
the ToolTip. When the ToolTip is left, or it is clicked on the ToolTip it
disappears. Clicking with the right mouse button on the ToolTip opens the
corresponding page at leo.org in the default browser.

In the configuration, also the server that should be used for the requests can
be chosen. "dict.leo.org" and "pda.leo.org" are available. "dict.leo.org" is
the regular website that submits more data than "pda.leo.org" which is a page
optimized for PDAs and gives equal results more quickly especially for slow
internet connections. This advantage comes together with the disadvantage that
using it for many requests in a short time can cause a ban of 2 Minutes from
leo.org. In this case a ToolTip with this information is shown. Another
disadvantage is that new languages are added later. This is why German-Italian
is only available over dict.leo.org.

LeoToolTip only supports translations for languages that use ASCII letters,
because AutoHotkey presently does not support Unicode-Text, which would be
required for German-Chinese translation.

An alternative to the ToolTip is displaying the results in a menu, where a
translation can be chosen to directly replace the selected text with. As an
option the text can also be copied to the clipboard.

In general the display is limited to the first 5 hits. This limitation is the
result of an agreement with Leo.org, to have the permission to continue
offering LeoToolTip.

By default an input dialog is shown, when nothing is selected. At "Additional
settings..." it can be changed and ac'tivAid tries to select the word under
the cursor and look this one up.

Please note chapter 3.2., when problems with the internet connection appear.

Beside the settings in the configuration dialog there is a hidden setting that
can be done in the file ac'tivAid.ini. It has to be provided below section
[LeoToolTip].

HistoryFile = file.txt     ; all found and chosen selections are written to
                             the file provided
HistoryFileOnMenuCall = 1  ; Additional settings for the history file
                             1: only write to the file when the entry in the
                                context menu is selected
                             2: only "search item=translation" is added
                             3: the selected menu entry is added formatted and
                                always with the foreign language at first

Default-Hotkeys:
Ctrl + Shift + L    translate selected word using German-English dictionary
_____________________________________________________________________________
 6.21. ThesauroToolTip - Synonyms for German words
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
ThesauroToolTip looks up the selected word at http://www.openthesaurus.de. The
result is shown in a ToolTip or in a menu that can either be called by a
hotkey or by selecting text with the middle mouse button. The latter has to be
activated in the configuration and is only available when MouseClip is active.

To display the ToolTip for a longer time, the mouse cursor has to be moved on
the ToolTip. When the ToolTip is left, or it is clicked on the ToolTip it
disappears. Clicking with the right mouse button on the ToolTip opens the
corresponding page at openthesaurus.de in the default browser.

Older versions of ThesauroToolTip had used the more comprehensive "Wortschatz-
Projekt" of the University of Leipzig. Unfortunately the websites had been
modified in a way that AutoHotkey is not able to access them in the moment.

Please note chapter 3.2., when problems with the internet connection appear.

Default-Hotkeys:
Ctrl + Shift + T       show Synonyms for the selected German word
_____________________________________________________________________________
 6.22. AutoShutdown - Dialog to shutdown or logoff the system
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
AutoShutdown can be used to specifically shut down the computer. In difference
to PowerControl a security dialog is shown, that is automatically confirmed
after a configurable time. This allows to abort an accidental activation of
the shutdown.

Another option is to automatize the shutdown completely. Either a schedule can
be created (e.g.: every working day at 7 pm and on weekends at 10 pm) or the
shutdown can be initiated dependent on program windows.

The last option can be interesting for backup software or other time consuming
processes, that are not able to shut down the computer by themselves.

The dialog for "Program and window controlled shutdown" multiple rules can be
combined. Example: the disappearing window "Copy ..." only initiates the
shutdown, if a window "Backup" is present.

The + button can be used to capture the data of an currently active window and
inserts this information into the text fields of the dialog.

To have the ability to test the behavior without accidentally shutting down
the computer, there is a test mode which only displays what would happen.

To execute one or more commands before shutting down, there can be created
entries as UserHotkeys using the special command <OnShutDown>. More
information can be found at UserHotkeys.

Default-Hotkeys:
Win + Q:                Shutdown computer with security dialog
Win + Ctrl + Shift + Q: Shutdown computer directly
_____________________________________________________________________________
 6.23. ComfortResize - Change the size of all windows and move them
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
To resize or move windows more comfortable, ComfortResize allows to perform
these actions within the complete window. Therefor the window is virtually
divided into nine parts. When clicking in the eight parts at the border of the
window it can be resized, inside the one in the middle it can be moved.

Optionally it is possible to limit the resize and move operations by the
screen borders.

Additionally six hotkeys can be selected to scale the window to a user defined
size. This for example is useful for web developers in combination with
browser windows to simulate different screen resolutions.

Depending on the graphics card and the system artifacts may occur on the
screen, but the will disappear when the mouse button is released or the mouse
does not move. Optionally the speed of the movement can be slowed down, which
prevent or at least reduces the artifacts.

Beside the settings in the configuration dialog there is a hidden setting that
can be done in the file ac'tivAid.ini. It has to be provided below section
[ComfortResize].

If you use "Right and left mouse button" and the right mouse button does not
work correctly in other programs you could enable an alternative behavior in
the additional settings menu.

Default-Hotkeys:
Win + right mouse button:         Resize or move window
Win + Shift + right mouse button: Resize or move window using the grid
Win + Ctrl + right mouse button:  Resize or move window toggle limit on screen
Win + Alt + Numpad-6:             Resize window to 640x480
Win + Alt + Numpad-8:             Resize window to 800x600
Win + Alt + Numpad-1:             Resize window to 1024x768
Win + Alt + Numpad-2:             Resize window to 1280x1024
Win + Alt + Numpad-4:             User defined size
Win + Alt + Numpad-5:             User defined size
_____________________________________________________________________________
 6.24. DriveIcons - Create links to drives on mounting
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Vista restrictions:         Ejecting using the Recycle bin does not work yet.

64-bit systems restriction: It is not possible to arrange the icons on the
                            right side like OS X does it.

DriveIcons provides a handy function, known from Linux and MAC systems. When a
CD is inserted or an external media is plugged in, a link is created on the
desktop. It is even possible to arrange the icons on the right side of the
screen (this option is not available for 64-bit systems).

Instead of the desktop, the links can also be created in the Quick Launch area
or inside a user defined directory. Drives where no link should be created
can be excluded by name.

Manually created links are recognized by DriveIcons. If there is need for an
additional link to a drive the path of the link has to be like "C:". It is not
allowed to end with ":\". These links are handled by DriveIcons.

Like the original Mac version, it is also possible to eject drives by dropping
them on the Recycle bin. This is managed by monitoring the links (which can be
disabled). If a link is deleted manually, DriveIcons tries to eject the drive
using the extension Eject, which has to be installed.

Some CD/DVD burning programs like Nero Burning Rom continuously check the
status of CD/DVD drives like DriveIcons does. This causes both programs to
react with delay and causes problems with burning media. For this reason a
list of programs can be given to disable the status requests when these
programs are active.

To include a program in the list, it is recommended to disable DriveIcons (by
unchecking the checkbox left to the description and applying this setting).
After disabling DriveIcons start the program that should be disabled and call
the configuration of DriveIcons. Click on the + button, activate the program
that caused problems and press enter. Now the exception list should contain
the class of the program. To prevent other users having the same problem it
would be nice of you to inform us so we can extend the default list of
excluded applications.

Another problem in combination with DriveIcons can occur using the personal
firewall Outpost. In general it is recommended to activate the option "Allow
NetBios communication" when using AutoHotkey scripts.

Also some special drives (e.g. VPN) can slow down the system. In this case,
only excluding these drives in the configuration solves the problem.

The entry "SkipIcons = x" in ac'tivAid.ini below [DriveIcons] defines how many
spaces for icons are left blank atop, before the drive icons are displayed.
_____________________________________________________________________________
 6.25. FileRenamer - Rename multiple files or folders
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
FileRenamer provides multiple possibilities to rename files and folders
automated. It is called inside Explorer by the hotkey and uses the previously
selected files.

The dialog that is displayed provides multiple options to define the renaming
scheme. The following replacement characters are available for renaming.

\f - the original file name or folder name
\x - the original extension
\n - an automatic numbering
\d - the date (configured below)
\t - the time (configured below)
\c - content of clipboard or corresponding row of clipboard

The numbering can be configured as well as the date and the time. For date and
time different sources can be chosen. A manually entered time is possible as
well as the time of the last modification, the time of creation, the EXIF date
for images or the current time.

A combination of text and replacement characters is also possible.
"testimage.gif" using "Image \n.\x"     results in "Image 001.gif"
"Document.doc"  using "\f_Original.\x"  results in "Document_Original.doc".

The default setting for numbers automatically adds leading zeros. File number
5 would be numbered 005. To adjust the number of leading zeros, the starting
value has to be adjusted (e.g. 00001).

Replace can also be used with regular expressions, when the search value
starts with "RegEx:".
Example: Replace in filename (\f)     RegEx:(\w+)     with     '$1'
Result:  Every word is surrounded by a single quote

All filenames can be copied by clicking on the list and pressing Ctrl+C. These
can be pasted into a text editor and edited. After editing, all of them can be
copied to the clipboard again and assigned to the files by putting \c for "new
filename". This causes every row of the clipboard to be assigned as filename.
FileRenamer reloads the clipboard on changing the field "new filename" or on
pressing Ctrl+V

Using Alt+up/down and Alt+Home/End or using the context menu, entries can be
sorted manually.

Date format (case sensitive):
d     Day of the month without leading zero           (1 - 31)
dd    Day of the month with leading zero              (01 – 31)
ddd   Abbreviated name for the day of the week        (e.g. Mon)
dddd  Full name for the day of the week               (e.g. Monday)
M     Month without leading zero                      (1 – 12)
MM    Month with leading zero                         (01 – 12)
MMM   Abbreviated month name                          (e.g. Jan)
MMMM  Full month name                                 (e.g. January)
y     Year without century, without leading zero      (0 – 99)
yy    Year without century, with leading zero         (00 - 99)
yyyy  Year with century.                              (e.g. 2005)
gg    Period/era string for the current user's locale (blank if none)

Time format (case sensitive):
h     Hours without leading zero; 12-hour format      (1 - 12)
hh    Hours with leading zero; 12-hour format         (01 – 12)
H     Hours without leading zero; 24-hour format      (0 - 23)
HH    Hours with leading zero; 24-hour format         (00– 23)
m     Minutes without leading zero                    (0 – 59)
mm    Minutes with leading zero                       (00 – 59)
s     Seconds without leading zero                    (0 – 59)
ss    Seconds with leading zero                       (00 – 59)
t     Single character time marker, such as A or P    (depends on locale)
tt    Multi-character time marker, such as AM or PM   (depends on locale)

Because AutoHotkey currently does not support Unicode, it is not possible to
process unicode filenames in ac'tivAid. Files containing special characters
can not be handled by FileRenamer (Turkish, East-European languages, ...).

Default-Hotkeys:
Ctrl + U:           Rename files selected inside Explorer.
_____________________________________________________________________________
 6.26. KeyState - Displays the status of CapsLock, ScrollLock and NumLock
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Provides displaying the state of caps lock, scroll lock and num lock key, in
different ways.

There are two permanent display options: a system tray Icon or a display in
the title bar of the active window. Also one temporary display (an OSD) is
available. The OSD is shortly displayed time, when the keystate is changed.

Additionally an acoustical signal can be activated that helps to recognize
accidental pressing of caps lock while blind writing.

The windows where the title bar display or complete KeyState should not be
displayed can be configured by adding the window classes to the appropriate
field. To detect the window class the + button has to be pressed. Afterwards
the window of interest has to be active and has to be confirmed by pressing
enter. Also window titles are allowed to be entered.

The often mentioned desire for a display of the Insert key state cannot be
managed within ac'tivAid, because the state is not managed by the system, but
instead by the applications themselves, and there is no consistent way to
obtain this information. When the Insert key is not needed it can be
deactivated using RemapKeys.

Beside the settings in the configuration dialog there are hidden settings that
can be done in the file ac'tivAid.ini. They have to be provided below section
[KeyState].

IconFile = C:\pfad\icons.icl   ; User defined ICL file providing the icons for
                                 the status displayed in the tray.

SoundFile = C:\pfad\datei.wav  ; Audio file for the acoustic signal

Additionally inside the ini file below section [activAid] full screen
applications can be listed for which no OSD is displayed.
FullScreenApps = Parts of the window name or the class, comma separated
_____________________________________________________________________________
 6.27. MultiClipboard - Multiple clipboards
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
MultiClipboard provides a total of 9 clipboards accessible by hotkeys. Each
clipboard has its own hotkey for copy and paste. Because the clipboard
contents are stored on disk, all clipboard contents are available even after a
system restart. Optionally the clipboard contents can be deleted on restart.

The main hotkey displays a menu that displays the first 60 characters of each
clipboard. Pressing the Shift key while choosing an entry inserts the content
of the selected clipboard and also the content of all clipboards above.

The option "Monitor Ctrl+C and Ctrl+X" copies the selection on clipboard No. 1
and moves all other clipboards down by one.

The monitoring causes some problems in combination together with Excel, when
no printer is installed or the standard printer is not available. A workaround
is to install a simple Textprinter. That has to be defined as default printer.

Another problem in connection to Excel and the monitoring of the clipboard is
the fact that the monitoring causes Excel to put the copied part to clipboard
additionally as an image. Unfortunately Excel seems to run into problems and
does not copy any longer but causes a warning message instead. This can only
be avoided by excluding excel.exe from monitoring using the hidden setting
ExcludeApps (see below).

Beside the settings in the configuration dialog there are hidden settings that
can be done in the file ac'tivAid.ini. They have to be provided below section
[MultiClipboard].

AdditionalClipboards = X ; Number of additional clipboards for additional
                           setting "X additional clipboards in menu".
                           (default = 10)
ClipSizeLimit = X        ; Limitation of the monitoring of clipboard to X MB.
                           Default value is 16 (MB), 0 means no limit.
ExcludeApps = App1,App2… ; Inhibits monitoring Ctrl+C/X for some processes.
                           (e.g. Excel.exe)

Default-Hotkeys:
Ctrl + Alt + Shift + 1-9:   Stores the selected object on MultiClipboard X
Ctrl + Shift + 1-9:         Inserts the content of MultiClipboard X
Ctrl + Shift + 0:           Displays a menu with all clipboards
_____________________________________________________________________________
 6.28. NewFile - Create a new file
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Creates a new file inside the current directory. This file can be renamed and
edited. It is only useful for text files, not for binary files.

Default-Hotkeys:
Ctrl + Alt + N:           Creates a new file inside Explorer.
_____________________________________________________________________________
 6.29. PastePlain - Insert clipboard without meta information
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Inserts the content of the clipboard at the current cursor position, without
additional information like font family, font size or embedded images. An
additional hotkey allows to strip line breaks.

Both hotkeys can be switched to copy selected text unformatted to clipboard
instead of pasting the text. So Ctrl+V can be used as normal to paste
unformatted text.

Additionally there is an option to filter text before pasting. Each line is
handled extra. Regular expressions are also allowed. They have to look like
these:

/search/replace/       ("search" is replaced by "replace")
/ä/&auml;/             (replaces ä by &auml;)
/<[^<>]+>//            (removes HTML tags)

The important thing to be recognized as regular expressions is the "/" at the
beginning and end of each line. To use "/" as a character "\/" has to be used.
Further information on regular expressions can be found in the documentation
of AutoHotkey. http://www.autohotkey.com/docs/commands/RegExReplace.htm

The option "Restore Clipboard after paste" does not change the content of the
clipboard, so after inserting the plain text, the formatted text is still in
the clipboard. Sometimes this causes delays during insertion if the clipboard
contains a lot of information.
For this reason, this option is disabled for all Adobe applications, which
means after pasting, the clipboard only contains the plain text.

Default-Hotkeys:
Win + V:          Paste plain text from clipboard
Win + Shift + V:  Paste plain text without line breaks from clipboard
_____________________________________________________________________________
 6.30. PowerControl - Power management options
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Vista restrictions: The password protected screensaver does not work properly.

Provides hotkeys for shutting down the computer, logging off or saving power
otherwise. Most actions are performed immediately without security check.

If the shortcuts for the screensaver do not work, it has to be activated in
the system control. The timeout can be set to any value. To prevent unwanted
activation it should be set to a high value.
The password protection for password protected screensaver is not active
within the first 5 seconds. Within this time, the screensaver can be
deactivated without password.

Default-Hotkeys:
Win + Ctrl + Page down: Shut down computer
Win + Ctrl + Page up:   Restart computer
Win + Shift + Pause:    Standby
Win + Ctrl + Pause:     Hibernate
Win + Ctrl + End:       Log off
Shift + Pause:          Start screen saver
Shift + Alt + Pause:    Start password protected screen saver
Win + NumLock:          Set monitor to standby mode
Win + Shift + NumLock:  Power off monitor (if provided)
_____________________________________________________________________________
 6.31. ExplorerShrinker - Scales the explorer window to optimal size
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Minimizes Windows Explorer in a way that only the required space is used. In
the moment it only works reliable for Windows XP and Vista.

ExporerShrinker does not work if list view is active in Explorer. But it also
works together with WinRAR.

Options:
- "Also change height":
   Changes the height of the window to eliminate space below the last file.
   The window is never resized to be larger than the screen.

- "Minimum height":
   When no files exist in a directory the display area would be set to 0 pixel
   height. This option forces a minimum height that the area keeps visible.
   The default setting equals two rows (at normal font size).

- "Reposition window if necessary":
   When the window is getting larger than the screen border, the window will
   automatically be moved to be completely visible.

- "Automatically adjust column widths":
   The columns of the detail view are set to optimal width by pressing the
   hotkey Ctrl+Numpad-Plus. This allows to get the optimal window size even
   with detail view activated.

- "X-Mouse mode":
   This option has nothing to do with the resizing. It is a kind of Explorer
   limited "Focus follows mouse" function. If the folder view is visible, the
   active area follows the mouse cursor. This allows to scroll using the
   mouse wheel without the need of clicking into the area.

Default-Hotkeys:
Ctrl + Numpad-Minus:     Optimize window size
_____________________________________________________________________________
 6.32. AppLauncher - Fast launch of start menu entries
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
AppLauncher allows to look up applications from the start menu or from other
directories (like QuickLaunch directory or Desktop) by typing parts of their
name and launch them. By default AppLauncher only displays Applications and
filters uninstall programs. More on this is explained later.

Applications started by AppLauncher are entered in a history, which is shown
when starting AppLauncher before typing anything in the search field.

The idea for this extension, as well as some parts of it emanate from the
script "320MPH" by Rajat, which can be found in the directory
"extensions\UserHotkeys-scripts\".

In the configuration dialog the paths that should be indexed can be defined.
Also the number of history entries, the number of hits and some parameters
that define the appearance can be set.

Using the "More settings" dialog that can be found at "Additional settings"
various extended settings can be modified.

The indexing is restricted to extensions mentioned in the second list. But the
list corresponds to the extensions of the target of links. That means, when
lnk files that link documents should be indexed, doc has to be added instead
of lnk.

Because AutoHotkey cannot always determine the target of a shortcut (e.g. for
special shortcuts of current MS-Office-Versions) the extended configuration
allows to decide whether the target of the active entry should be shown
beneath the search field or not.

Another setting allows to set whether the script should automatically adjust
the column width regarding to the results or the width of the window, or if no
adjustment should take place.

When the AppLauncher window is visible, a rebuild of the index can be
initiated by pressing Ctrl+R or F5.

When pressing the Alt key while launching an application, RunAs is called and
asks for the user account the application should be started with.

When pressing the Shift key, the application is not started, but instead the
folder of the link is opened.

AppLauncher automatically indexes all available extensions of ac'tivAid. The
indexing is not connected to the AppLauncher-Indexer, but happens every time
the configuration window is created. This option can be switched at the "More
settings" dialog. When the option is set to gray/green, only the commands for
opening the simple configuration windows are included in the index.

Using Ctrl+Del single Applications can be deleted from the index. When the
history is shown, the Link is only deleted from history, otherwise the path is
entered into the file ExcludedFiles.dat and does not appear again even after
re-indexing. The file ExcludedFiles.dat can also be edited manually to exclude
complete paths. Therefor the path has to end with a backslash "\".

List entries can also be renamed using the F2 key. This can be used to rename
meaningless entries and does not rename the file, but adds an entry in the
file CustomNames.dat. This file is only considered during indexing. This is
why the index is rebuilt after closing the AppLauncher window.
The file CustomNames.dat can also be modified manually to add special entries
that automatically add a prefix or a suffix to every entry inside a specified
directory. This is done by the following type of entry:
%A_ProgramFiles%\Folder\::prefix ### suffix

The context menu can be extended by entries that launch applications with the
link as parameter. This is useful to use in combination with the MachMichAdmin
script of Johannes Endres (c't).
To extend the menu, add the following lines into AppLauncher.ini
[OpenWithApplications]
Application1=c:\windows\MachMichAdmin.cmd
Application2=<other runwith application paths can be added here>

For using AppLauncher on an USB-stick, it may happen, that ac'tivAid is run
from different drives with different names. Using the extended setting "Use
path variable in index" replaces the Drive ac'tivAid is running by %Drive%.
Additionally standard variables like A_Desktop, A_Programs, ... are replaced.
This option is not applied for existing paths inside the list. The paths has
to be removed and re-added. Afterwards the index is rebuilt. Eventually the
file ExcludedFiles.dat has to be modified by hand or deleted and built again
by pressing Ctrl+Delete inside the result window.

Default-Hotkeys:
Ctrl + Alt + Space or AltGr + Space: Launch AppLauncher

Shortcuts inside AppLauncher:
Ctrl + Alt + Ecexute/Double click:  Run as ...
Shift + Ecexute/Double click:       Open directory of entry in Explorer.
Ctrl + Ecexute/Double click:        If the option is active, entry is only
                                    saved to history with Ctrl key pressed.
Ctrl + C:                           The path of the selected entry (using tab
                                    or mouse click) is copied to clipboard.
Ctrl + Shift + C:                   Copies the real path (target of the link)
                                    to clipboard, also when the focus is at
                                    the search field.
Ctrl + R / F5:                      Start indexing.
Ctrl + Delete:                      If the command history is shown, remove
                                    the current entry from history otherwise
                                    remove it completely from the index.
_____________________________________________________________________________
 6.33. EmptyRecycler - Empty the recycle bin
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Allows to empty the recycle bin using a hotkey. Of course this only happens
after a security check.

Default-Hotkeys:
Windows + Ctrl + Delete:            Empty recycle bin
_____________________________________________________________________________
 6.34. RemapKeys - Remap CapsLock / simulate the windows key
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
This extension allows to remap the caps lock key. Many Users do not need this
key, why it often is useful to map the Shift key on it to prevent accidental
activation.

Additionally the Insert key, the Num lock key and the Scroll lock key can be
remapped and the comma key in the Num block of the German keyboard layout can
be said to send a dot.

The simulation of the Windows key is interesting for keyboards that lack this
key. For example also when using Remote-Desktop or Virtual PC on a Mac.

The option "only if held for a second" is useful if the default function of
the key is still needed. The default function is triggered when the key is
pressed shortly, the Windows key is triggered when the key is hold down for a
longer time. If this option is inactive, the key generally behaves like the
Windows key.

Another possibility to deactivate keys is using UserHotkeys and defining a
hotkey that is set to "<Send>".

The option "Reset CapsLock state" corresponds to the case where ac'tivAid is
deactivated or activated again. With this option active, the state of caps
lock is reset when another function is assigned to the CapsLock key. A similar
option is also available for NumLock which activates or deactivates the
numblock on every start or reactivation of ac'tivAid.

The option "Avoid unintentional enabling of CapsLock." deactivates the
remapping and makes sure that CapsLock is not activated, when the caps lock
key is used together with another key to make this upper case.

The option "Shift does not produce lower case letters in CapsLock mode" allows
to only write capital letters when CapsLock is active. Normal behavior would
cause lower case characters when Shift key is pressed.

Remark: RemapKey only works when ac'tivAid is active. That causes the keyboard
to react in the default way on the login screen or for other users.

To remap the keyboard for the complete system, the keyboard can be adjusted in
the registry. The tools "remapkey.exe" that is part of the "Windows Server
2003 Resource Kit Tools" by Microsoft or "SharpKeys" by RandyRants can give a
helping hand.

- http://tinyurl.com/3ae78y (Resource Kit Tools)
- http://www.randyrants.com/sharpkeys/
_____________________________________________________________________________
 6.35. LookThrough - Punches a hole into application windows
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
To be able to work this extension has to disable Aero temporaryly.

This extension is not suitable for slow computers. Using a hotkey, a hole is
punched into the windows below the mouse cursor to allow to look onto the
Desktop. This hole follows the mouse and Drag&Drop actions are possible with
Desktop elements.

There are two options for configuration:
1. The hole is active until the hotkey is released.
2. The hole is toggled using the hotkey.

Option one has the disadvantage, that only single keys are working and no
combinations like Ctrl+F9 are allowed.

Programs that refresh the complete window very often overpaint the hole. You
cannot look through windows of these programs.
_____________________________________________________________________________
 6.36. ExplorerHotkeys - Hotkeys for explorer
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Vista restrictions: Toggling between the views does not work yet.

This extension provides additional useful hotkeys for Explorer that for
example allow to toggle the folder view or duplicate files.

The "Filmstrip" view only works when "Show common tasks in folders", an option
inside the "Folder Options", is active.

At "Folder Options"->"View" you can decide whether system files should be
displayed when showing hidden files using the option "Hide protected operating
system files" (SuperHidden).

The format for duplicating files defines the name of the new file. \F is the
placeholder for the original filename, \N is a counter.

Default-Hotkeys:
Ctrl  + Shift + 1:           Thumbnails
Ctrl  + Shift + 2:           Tiles
Ctrl  + Shift + 3:           Icons
Ctrl  + Shift + 4:           List
Ctrl  + Shift + 5:           Details
Ctrl  + Shift + 6:           Filmstrip
Ctrl  + Shift + H:           Toggle display hidden files
Ctrl  + Shift + E:           Toggle display extensions
Ctrl  + O:                   Toggle display Folders bar
Alt   + Cursor up:           Directory up
Alt   + Cursor down:         Switch do folder/Open file
Ctrl  + D:                   Duplicate Explorer window
F3:                          Search file list
Ctrl  + Shift + D:           Duplicate file
Shift + Mousewheel:          History forward/back
_____________________________________________________________________________
 6.37. ScreenLoupe - Magnify the screen at the mouse cursor position
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
To be able to work this extension has to disable Aero temporaryly.

This extension magnifies the content of the screen around the mouse cursor.
The size of the 'loupe' can be defined freely. The size 1/1 (one whole) allows
to define a size of the complete screen width/height. Providing 1/1 for both,
width and height, enlarges the complete screen allowing an magnifying effect
similar to the one of Mac OS X.

The ScreenLoupe does not magnify everything. ToolTips and windows that are
always on top and located "above" ScreenLoupe like a later called QuickNote
are not magnified.

When in fixed mode, the height and width of ScreenLoupe can be adjusted.

Default-Hotkeys:
Ctrl + Shift + Numpad*        Toggle ScreenLoupe
Ctrl + Shift + NumpadPlus     Increase magnification
Ctrl + Shift + NumpadMinus    Decrease magnification
_____________________________________________________________________________
 6.38. PasteSerial - Paste serials from clipboard without dashes
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Some applications do not allow to paste the serial you obtained via e-mail
via clipboard, because the dashes in the e-mail text are not accepted in the
registry window. PasteSerial inserts the serial number without dashes at the
current position. Optionally the dashes can also be replaced by tabulator
presses to allow switching of input areas.
____________________________________________________________________________
 6.39. Calendar - Quick overview for months and years
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Calendar and day calculator

THIS IS NOT A SCHEDULER!

The calendar just serves for a quick overview to find a certain date.
It is not intended to save appointments, pop up a reminder window or else.
For these tasks, better use programs like Thunderbird, Outlook, Google
Calendar, ...

Functionality:
By pressing the button labeled with the currently selected date you can insert
it in the last active application (select a different format from the
drop-down-list below if desired.). The calendar view is closed automatically.
Without inserting a date string, you can close the view by pressing the escape
key, ALT-F4 or the small red cross in the upper right corner.

The day calculator

The calculator offers three different input fields: start date, end date and
day difference. One of them is always "read-only" and will show the
calculation result of the two other fields.

Negative day difference:
You may discover that the day difference is negative. This is because days are
ALWAYS computed beginning with the start date (that´s why it is called start
date). If your end date lies BEFORE the start date, you´ll end up with the
amount of days passed until the start date.

What is a Master-Hotkey?

This extension optionally makes use of the so called "multi-level hotkeys".

If you press the master hotkey, this does NOT instantly cause any action but
prompts you to press another key to execute the desired function (two levels
of activation).

This is useful in cases where your extension offers various, slightly
different services. You have to define (and to remember) only one hotkey
combination for all these services and have more hotkeys left for other
functions.

For example, you can open three different views of this calendar. Without
multi-level hotkeys, you would define three hotkey combinations.
Now, you simply define one single master-hotkey which introduces the selection
of three different single keystrokes - one for each view.
If you press the proper key within the (configurable) amount of time, you get
your view. Pressing any other key or no key at all, the system returns to its
normal behavior.

Please note:
If you decide not to define any master hotkey at all, you will automatically
use the common single-level hotkey activation method.
In this case, please define a hotkey combination for the different functions.
Instead, if you use multi-level hotkeys, you should define a key combination
ONLY FOR THE MASTER HOTKEY.
There is currently no way to use key combinations for the second stage - just
use single key strokes here!

Because of technical reasons, the definition of key combinations for the
second stage cannot be detected.
_____________________________________________________________________________
 6.40. TransparentWindow - Provides window transparency
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
XP restrictions:    The automatic transparency together with a lot of windows
                    causes a slow reaction of the system.

1. Window transparency
   Turning the mouse wheel + windows key renders the active window transparent
   by amounts of 10 percent.
   (by 1 percent if you additionally hold the shift key)

   This way the window behind the active window becomes visible.
   But even if its set transparent completely (0 percent), the window remains
   functional and clickable.

   Of course such a window can get lost very easily.
   Thats the case the "Reset all transparency effects"-hotkey is for.
   (default: "Windows + Ctrl + T") Press it and all transparencies set to any
   windows will be reset.

2. Pixel transparency
   Hitting the "Pixel transparency"-hotkey (default: "Windows + Ctrl + left
   mouse button") all pixels of the same color the mouse cursor currently
   points at will be rendered invisible. And anything behind will be visible.

   Contrary to the window transparency a click onto an invisible pixel will
   actually hit the window behind!

3. Pixel transparency and always on top - combination
   This hotkey (default: "Windows + Ctrl + Alt + left mouse button") will
   apply window transparency (default 25%), Pixel transparency and
   "Always on Top" to the window.

   This mode is meant for small dialogs like e.g. progress bars when copying
   files or doing downloads. This way the dialog can be kept in the view
   without distracting the user too much.

   To turn off this effect press the hotkey for "Reset transparency effects of
   window" (default: "Windows + Shift + left mouse button").
   Note that you have to press this hotkey at a spot of the window that is
   still visible, because as stated before otherwise the window in the
   background would receive the click.

4. Automatic transparency
   This mode adjusts the transparency of all visible windows.
   That might be a little troublesome on versions below Windows Vista because
   lots of transparent windows have high performance impact which might slow
   down your work flow considerably!
   But this applies to Vista as well if you turned off "Aero" like in VMware
   or classic theme of Windows.

   The transparency will be adjusted with the current state of the window and
   the settings from the configuration dialog.
   Active windows shall have no transparency (slider rightmost), otherwise
   working might appear a little sluggish.
   The slider "Same application" adjusts how windows of the same type are
   drawn. E.g. a couple of Explorer windows.
   Remark: This only applies to windows that are not covered (even partially)
   by another application. Is there a Notepad between two Explorer windows the
   bottom window will be rendered like an inactive one.

   Furthermore you still have the option to ignore certain windows in the
   automatic mode or draw them with a default transparency.
   TransparentWindow will also try to ignore windows with transparent skins or
   themes (but Vista Aero windows) automatically as they might appear black.
   So if that happens with an application just put it to the ignore list.
_____________________________________________________________________________
 6.41. UnComment - Adds or removes comment characters to the selected text
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Prepends the defined comment characters in front of every line of the selected
text or removes them, when present.

The default settings use hotkey Ctrl+Alt+C to prepend "//" to the selection.
When "//" is present at the beginning of the selected row, it is removed. The
setting "toggle comment on/off" allows to disable this behavior and to enter
a different hotkey with the function to uncomment the selection.

The option "ask for change if nothing selected" allows to change the comment
characters without the need of opening the configuration dialog but instead
calling the UnComment hotkey without anything selected.
_____________________________________________________________________________
 6.42. CharacterAid - Aids to type special characters more simple
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Allows to create special ASCII characters by multiple pressing of the related
key. Thereby a list of characters is switched. The first time a character is
replaced after the third key press (adjustable in configuration). For example
with default settings, pressing the key "a" seven times results in a "æ".

Atop the character lists in the configuration, additional hidden character
lists can be created inside the file ac'tivAid.ini. They have to be provided
below section [CharacterAid].

Character1      =a         ;defines the key of the keyboard
CharacterList1  =äâàáæå    ;defines the character list
Use1            =1         ;allows temporary deactivation

The number in the name (in the example the 1) has to be given continuously. In
default settings the numbers 1 to 20 are assigned. In total 30 lists are
supported. Remark: The default setting only is added to the ini file when
something is changed and saved in the configuration.

Beside these settings and the ones in the configuration dialog there is
another hidden setting that can be done in the file ac'tivAid.ini. It has
to be provided below section [CharacterAid].

ExcludeApps = App1,App2…  ; Applications where CharacterAid is deactivated.
                            By default ExcludeApps is set to Calc.exe to be
                            able to enter number that contain repetitions.
_____________________________________________________________________________
 6.43. TextAid - Special operations on selected text
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
The first part allows the conversion of upper and lower case inside selected
text. Available options can convert the complete text to lower case or to
upper case. Also an option is available to begin every word with a capital
letter or to toggle case, which means every upper case character is lower case
afterwards and every lower case character is upper case. Especially for Wiki
users the option CamelCase can be of interest, which removes all spaces of the
selection and converts the following character to upper case. The inverse of
this function adds a space in front of every upper case character inside a
word.

The second part allows to apply a regular expression onto the selected text.
The default setting removes all characters that are neither in the alphabet
nor a digit.

In the third part two hotkeys can be defined. The first one swaps the
character left of the cursor with the one to the right. The second hotkey
flips the direction of slashes. If a slash (/) is found in the selection, all
slashes are replaced by backslashes(\). Otherwise all backslashes are replaced
by slashes.

The "Reformat selection" selection provides three hotkeys that allow to
- add text to each line of the selection
- enclose the selection with a single character
- reformat text line (removes all line breaks and insert new ones after a
  specific number of characters, with respect to words)
  There are "More" options that can be modified by pressing the button. The
  options are self explaining.

The Option "Select text afterwards" that can be found at "Additional settings"
determines whether the text is reselected after transformation or not.

"Edit text with an external text editor" provides a hotkey to edit text of
text fields in an external editor.
When the text is saved inside the editor, TextAid automatically refreshes the
text in the text field. This function has the following restrictions:
- The editor has to be a discrete program which makes it possible for TextAid
  to check whether it is still running or not. JEdit for example does not work
  because the editor is started using javaw.exe which causes TextAid to assume
  that the program is closed, because javaw.exe does not create a window.
- Because AutoHotkey does not have direct access to forms inside a browser,
  the modified text is added in the active field. So moving the cursor to
  another field during editing causes the text of this field to be replaced.

Beside these settings and the ones in the configuration dialog there are other
hidden settings that can be done in the file ac'tivAid.ini. They have to be
provided below section [TextAid].

ControlSendApps =       Windows that contain one of the strings of this comma
                        separated list in the class name, are accessed in
                        background without the need to activate the main
                        window. The default browsers Firefox, InternetExplorer
                        and Safari are already in this list. Opera does not
                        supported background access.
AlternativePasteApps =  Windows that contain one of the strings of this comma
                        separated list in the class name, are not controlled
                        using Shift+Insert instead of Ctrl+V. Because Firefox
                        sometimes inserts the text twice on Ctrl+V.
TabWidth = 4            Sets the number of Spaces a tabulator is replaced with
                        during "Reformat text".

Additional setting "Edit text with an external text editor: Show info window":
Displays a BallonTip to inform what TextAid is doing during editing in an
external editor.
_____________________________________________________________________________
 6.44. RemoveDriveHotkey - Removes external drives with a two level hotkey
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
RemoveDriveHotkey is a hotkey extension for the program RemoveDrive.exe by
Uwe Sieber. It allows to control RemoveDrive using two level Hotkeys. The
first Hotkey activates an information window where the removable drives can
be displayed. During this window is displayed, the removing process is
initiated by pressing the drive letter. The success or any error is displayed
afterwards.

When the Truecrypt option is enabled, RemoveDriveHotkey tries to dismout the
drive using Truecrypt.

When pressing the DriveLetter together with the Ctrl key, the drive is not
removed, but instead an Explorer widow showing this drive is opened.

Many thanks to Uwe Siebers for allowing the use of RemoveDrive in this
context.

The required software is available on the website of Uwe Sieber
(http://www.uwe-sieber.de/usbstick_e.html at section "Download: RemoveDrive").
_____________________________________________________________________________
 6.45. DateTimeDisplay - Displays a window with date and time
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
This extension displays an InfoScreen containing date and time. The displaying
format can be defined inside the settings. The colors can be defined via
hexadecimal value or using a color chooser (double click on the color field).

If Windows is not used with default fonts or long date or time formats are
chosen, the information may be truncated. In this case the size has to be
adjusted manually by setting a "Custom size".

Date format (case sensitive):
      default: yyyy-MM-dd
d     Day of the month without leading zero           (1 - 31)
dd    Day of the month with leading zero              (01 – 31)
ddd   Abbreviated name for the day of the week        (e.g. Mon)
dddd  Full name for the day of the week               (e.g. Monday)
M     Month without leading zero                      (1 – 12)
MM    Month with leading zero                         (01 – 12)
MMM   Abbreviated month name                          (e.g. Jan)
MMMM  Full month name                                 (e.g. January)
y     Year without century, without leading zero      (0 – 99)
yy    Year without century, with leading zero         (00 - 99)
yyyy  Year with century.                              (e.g. 2005)
gg    Period/era string for the current user's locale (blank if none)

Time format (case sensitive):
      default: HH:mm
h     Hours without leading zero; 12-hour format      (1 - 12)
hh    Hours with leading zero; 12-hour format         (01 – 12)
H     Hours without leading zero; 24-hour format      (0 - 23)
HH    Hours with leading zero; 24-hour format         (00– 23)
m     Minutes without leading zero                    (0 – 59)
mm    Minutes with leading zero                       (00 – 59)
s     Seconds without leading zero                    (0 – 59)
ss    Seconds with leading zero                       (00 – 59)
t     Single character time marker, such as A or P    (depends on locale)
tt    Multi-character time marker, such as AM or PM   (depends on locale)

Default-hotkeys:
Win + Alt + D        Display the DateTimeDisplay InfoScreen
_____________________________________________________________________________
 6.46. ScreenShots - Allows to take shots from the screen
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Vista restrictions: Nearly completely operative, but depending on the system
                    sometimes problems with deactivation of font smoothing.
                    Additionally some windows are not captured completely
                    because AutoHotkey receives the wrong window size.

ScreenShots allow to take a screen shot of the complete screen, a single
window or an interactive selection using user defined hotkeys. The screen shot
can be put into clipboard or directly stored in a file in different formats.

The options:
- Size down to: directly resizes the screen shot.
  The following options are available:
  x%  : Scale to x percent. 100% means no change.
  a/b : Relational scaling. 1/2 equals 50%
  w*h : Resize screen shot proportional to fit inside the box given by the
        "w"idth and "h"eight in pixel (e.g. 640*480), no enlargements.
  w*? : Limits only the width  to "w" pixels, no enlargements.
  ?*h : Limits only the height to "h" pixels, no enlargements.
- capture mouse cursor: Defines whether the mouse cursor is visible in the
  screen shot or not.
- Acoustic feedback: The screen shot is confirmed by a camera sound.
- Visual feedback: The screen shot is confirmed by flashing the captured area.
- save to ...: There are three possible choices. The screen shot can be put
  into the clipboard like normal windows behavior. Otherwise a file in the
  chosen format is saved in the given folder. If the file already exists, it
  is not overwritten, but instead a number is appended to the filename. When
  providing leading zeros for the counter, the numbers are padded with leading
  zeros in the file name. The option "Save to file and clipboard" creates a
  file and puts the screen shot to clipboard.

The different areas:
- Interactive selection:
   More information below.
- Complete monitor:
   Screen shot of all monitors.
- Active window:
   Screen shot of the active window.
   By default covered windows are captured as they are. If the option "Disable
   support for partly hidden windows" is unchecked, also the hidden parts are
   visible in the screen shot. Some programs cause black screen shots with
   this option unchecked. The option "'Active window' includes visible context
   menus" only works fine when no Alt key is part of the hotkey.
- Client area of active window:
   Screen shot of the current window, but without title bar, menu bar and
   window border.
- Window element under mouse pointer:
   Screen shot of a single window element.
   Examples for window elements:  button, list, input area, tool bar, ...

The interactive selection:
The interactive selection can be used to define the exact area of the screen
that should be captured. The selection is done with pressed left mouse button.
Afterwards the selection can be moved or resized. Enter or double click inside
the selection takes the screen shot. Esc aborts the interactive selection.

Clicking on a window outside the selection adjusts the selection to this
window. Additionally at the top of the selection the name of the selected
window and a checkbox are shown. The checkbox defines whether the selected
window should be captured without other overlapping windows. With the checkbox
deactivated, the selected area is captured as seen. When the selected window
has transparent parts, it is always captured as seen, because otherwise the
screen shot would be black. The default transparency of Vista does not apply
to this restriction.

When the complete screen is selected by clicking on the desktop, there are
three possibilities to select a new area. The area can be moved to be able to
click outside of it, when pressing the Ctrl key, a new selection can be
started inside the active one or the selection can be deleted by pressing the
Delete key.

Moving the mouse cursor to the lower right edge of the selection displays an
input field where the resize options can be defined. The same rules like
explained above at "Size down to" apply here.

During interactive selection mode the following hotkeys are available:
Space:         Pressing it together with left mouse button while selection is
               done allows to move the selection during creation.
Ctrl:          Switches off the move mode to allow creating a new selection
               inside the old one instead of moving it.
Shift:         Switches to element selection mode (mouse cursor is a hand), to
               allow selecting window element like buttons.
Arrow keys:    The arrow keys allow to move the selection pixel by pixel. With
               Ctrl pressed it moves 10 pixels in a step. With Shift pressed,
               the height and width can be modified pixel by pixel or together
               with Ctrl key each time 10 pixels.
Shift+Enter:   Switches the configuration whether the screen shot is put to
               clipboard or saved in a file.
Ctrl+C         The selection is put directly to clipboard
Del            Deletes the selection.

Additional there are various settings at "Additional settings ...":
"Turn off font smoothing" and "Only turn off ClearType" are useful when the
screen shots are taken for printing afterwards, because especially ClearType
can be disturbing when printing them. However Vista has some areas, that
generally use font smoothing without a possibility to manipulate it.

In case an opend menu should be captured, there is an option to activate an
delay of some seconds (default: 4s) to be able to open the menu.

The option "'Active window' includes visible context menus" expands the area
to capture opened context menus. This option only works correctly when the Alt
key is not part of the hotkey, because the Alt key closes the context menu.

Unfortunately ScreenShots has a limitation regarding to ac'tivAid itself. It
is not possible to capture menus of ac'tivAid because AutoHotkey menus always
pause the scripts.

ScreenShots collaborates with the extension ReadingRuler. If the starting
position is displayed, the area between the starting position and the current
position is passed to ScreenShots. That is especially useful for users whose
computers have problems with the interactive selection (delayed response).
The collaboration only refers to the following hotkeys:
- Interactive selection:
   The selection of ReadingRuler is adopted for the interactive selection.
   It can be adjusted and other settings can be done, too.
- Directly last interactive selection:
   The ScreenShot is directly taken using the selection of ReadingRuler.

Beside the settings in the configuration dialog there is a hidden setting that
can be done in the file ac'tivAid.ini. It has to be provided below section
[ScreenShots].

DimTransparency = 50  ; The value between 0 and 255 defines the transparency
                        of the area outside of the selection. OFF completely
                        switches the transparency off, which might be useful
                        for slow graphic cards.
_____________________________________________________________________________
 6.47. AutoDeactivate - Deactivate ac'tivAid automatically
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
ac'tivAid can bother a lot when using software that provides a lot of hotkeys
itself, where ac'tivAid has negative effect on the handling. AutoDeactivate is
able to deactivate ac'tivAid when one of the given programs is active. It is
reactivated when another program, that is not listed, becomes active.

Programs can be added to the list using the "+" button. After pressing the
button, a window of the program has to be activated and afterwards the enter
key has to be pressed.

To add full screen applications, they has to be activated by the mouse. Either
a link has to be available to start it, or the program is already running and
the task can be activated from the task bar. After pressing on the "+" button,
the application has to be started or activated via mouse (the keyboard is
inactive). When it is active it can be added to the list by pressing enter.
Normally the ac'tivAid window is displayed in front of the full screen
application afterwards. If ac'tivAid does not appear, the application should
nevertheless be inside the AutoDeactivate list and the keyboard is functional
again.

It ac'tivAid should not be deactivated completely, but only single extensions,
the option "Just deactivate selected extensions:" allows to select extensions
in a list that should be deactivated.
_____________________________________________________________________________
 6.48. VolumeSwitcher - Switches the volume between two values
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
If you change from headphones to speakers every then and now you might have
favorite volume settings for each situation.
VolumeSwitcher allows to change between two of those settings using hotkeys.
_____________________________________________________________________________
 6.49. CalculAid - Improves working with the windows calculator
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Searching the windows calculator in the depths of the Start menu can be
bothersome (maybe less bothersome with AppLauncher but..). And if you setup a
key at the shortcut (right click on the link > settings > shortcut key):
you are not able to open more than one calculator!

With CalculAid you can open as many calculator as you want and do much more:
If you select a number and hit the CalculAid-Hotkey (Ctrl+Alt+R by default)
the number will be put into the calculator so that you can calculate with it
immediately.
If you took the number from an editable field you can insert your calculation
by just hitting Ctrl+Enter in the calculator (which will be closed doing so).
Additionally you can toggle from scientific to normal view by pressing the Tab
key. The current number will be kept. The calculation will be lost though.

Hotkeys added to calculator:

    Ctrl+Enter:         closes calculator, inserts result
    Tab:                toggles between scientific and normal view
    G:                  turns On/Off number grouping
    Ctrl + G:           turns On/Off switching number grouping characters
    Esc und Ctrl + W:   closes calculator (optionally)

The default hotkeys of the calculator remain (except for Esc) untouched.
You can view them by hitting F1 in the calculator.
But maybe interesting to know are the followings ones:

    Ctrl+C:             puts the current number into the clipboard
    Ctrl+V:             pastes a number from the clipboard into the calculator
                        (if you turned on to switching number grouping
                         characters this will apply as well)
    Backspace :         delete last digit
    F9:                 +/- switch positive/negative
    Delete:             delete number (or optionally delete calculation)

Furthermore you can insert a simple calculation into the calculator:
For instance if you selected 13+7= and press the hotkey: the calculator pops
up with 20.

The options:
- switch number grouping characters (from 1,000.00 to 1.000,0 or vice versa)
    With this enabled all commas and dots in a number sent to the calculator
    will be exchanged. Thats useful if you changed your decimal separator or
    work with a document that has a different decimal separator.
- Place new calculator at cursor position:
    Especially useful for multi monitors: So you don't have the calculator on
    the other side of you workspace but where you actually look at.
- Make new calculator Always On Top:
    A new calculator will be set to be "always on top" so you see it in front
    of all other windows. Other windows cannot occlude the calculator anymore
    unless they are "always on top" as well.
- Additional keys to close the calculator:
    Usually you can only close the calculator with the little x to the upper
    right, via Alt+F4 or with the Menu. If that takes to long for you, you can
    enable extra keys that usually close such windows here.
- Make "Del"-key delete the whole calculation (C)
    To delete the current number maybe was useful back at the times you had a
    calculator in your pocket. Now backspace delivers a much more elegant way
    to correct your input.
    So "Del" is free for another function such as delete all (C-button in the
    calculator). That is also useful if you use "Esc" to close the calculator.
_____________________________________________________________________________
 6.50. ClipboardFilesManager - Delete/Backup files in Clipboard
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
This extension provides a simple option to collect files in one folder.

The files copied to clipboard can be copied or moved to the folder or they can
be deleted. There is also an option to create a subfolder that also can
contain date variables. To copy/move the files to.

Default-Hotkeys:
Ctrl + Alt + 1:  Copy files
Ctrl + Alt + 2:  Move files
Ctrl + Alt + 3:  Delete files
_____________________________________________________________________________
 6.51. MultiMonitor - Hotkey to move windows between different monitors
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
When using multiple monitors on one PC, maximized windows cannot be directly
moved from one monitor to the other, but have instead to be resized, moved
and maximized again. This extension provides hotkeys to move an application
to the next monitor or to a specific one and preserves maximization.

Default-Hotkeys:
Win + Shift + 1-9:   Current window directly to monitor 1-9
Win + Shift + N  :   Current window to previous monitor
Win + Shift + M  :   Current window to next monitor
_____________________________________________________________________________
 6.52. LimitMouse - Limit mouse to windows or monitors
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
This extension provides hotkeys to limit the mouse cursor to a monitor, a
window or the client area of a window. This is helpful to protect areas of the
screen to be clicked.

By default, the hotkeys are used to toggle the options.

When problems occur, using the system Routine, an alternative mode can be used
instead of the system routine.

Temporary horizontal/vertical limiting the mouse should be assigned to a key
which does not produce output like Shift or Ctrl.
_____________________________________________________________________________
 6.53. MouseWheel - Enable Mouse wheel also for inactive windows
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Using this extension allows to use the mouse wheel also inside inactive window
classes (e.g. the tree view) and inactive windows. Window elements or complete
windows can be excluded, although it cannot be guaranteed that they work
correctly afterwards.

Additionally the exclusion list allows to set a different scrolling behaviour
for some windows. To do this, two equals signs (==) had to be set as first
characters and no wildcard (*) or tabulator is allowed in that row.
Example: ==ConsoleWindowClass

When the scrolling slows or reacts lazy down with MouseWheel active, the
"Smooth-scroll list boxes" option, should be deactivated. It can be found
in the "System Properties", tab "Advanced" at the "Performance" settings.
In Vista first "Extended system settings" has to be clicked.
The same applies to browsers:
InternetExplorer: Tools > Internet options > Advanced > Use smooth scrolling
Firefox:          Tools > Options > Advanced > Use smooth scrolling
Opera:            Tools > Preferences > Advanced > Browsing > Smooth scrolling
_____________________________________________________________________________
 6.54. EditWith - Edit selected file
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
This extension allows to open files selected in Explorer with an freely
selectable program. If no program is provided, each file is opened with the
default program for editing. This is the program displayed as "Edit" in the
Explorer context menu.

If an editor is given, the option "The specified editor can edit multiple
files at once" decides whether all files are passed together, or if they are
opened one by one.

When different editors are needed, no editor should be chosen in the ac'tivAid
configuration, but instead the options of the file types should be modified
by adding the corresponding "edit" action (in addition to the often existing
open and print actions). They can be modified in "Folder Options" > "File
Types". Selecting the file type and pressing the "Advanced" button afterwards
allows to add or modify the edit action. The name has to be edit. The program
can be given like this:
"C:\Program Files\EDITOR.EXE" "%1"
_____________________________________________________________________________
6.55. MinimizeToTray - Minimize windows to tray icons
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
This extension minimized a window to an icon in the system tray and adds it
to the menu of minimized windows. The window can be displayed again by using
the restore hotkey or by double click (optional single click) on the icon. The
menu is added to the tray menu of ac'tivAid, as a submenu of MinimizeToTray.
It is also possible to show this menu using the hotkey. In the configuration
in part activAid the menu can be selected as a tray click option.

Another hotkey minimizes the active window and does not create an icon. That
means it is completely hidden. To restore it, only the menu of hidden windows
or the restore hotkey can be used.

This extension is based on the Script
http://www.autohotkey.com/docs/scripts/MinimizeToTrayMenu.htm
and the library http://www.autohotkey.com/forum/topic21991.html

Default-Hotkeys:
Windows + T           Minimize window to system tray icon
Windows + U           Restore last minimized window
Windows + Alt + U     Restore all windows minimized by MinimizeToTray
Windows + Shift + U   Show menu of all windows minimized by MinimizeToTray
_____________________________________________________________________________
6.56. JoyControl - Control windows with your joystick
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
This extension allows the usage of any joystick or game pad as an input device
capable of controlling the mouse cursor and performing various ac'tivAid
actions. You can save different button configurations and switch them easily,
optionally being notified about it by an InfoScreen or BalloonTip.

If your game pad supports more than one analog sticks, you can use the second
one to move the active window. You can switch the functions of the sticks in
the configuration dialog. Additionally each stick has its own speed, threshold
and pulse (how often the movement will be performed (in ms)), which also can
be changed by holding a button (look for the 'JC: Slower' and 'JC: Faster'
actions). Doing this will multiply the speed value with the values configured
under 'Speed Toggle'.

The wheel, arrow-keys an pov-keys pulse is the time in ms between checks for
buttons assigned to those actions respectively. The lower the value the
faster and more precise the reaction will get.

Each button can either perform a single "Hold"-action or two distinct
"Instant"-Actions. "Hold"-actions react on the push and release of a button,
"Instant"-Actions are triggered by a short or long push. Some actions require
a parameter with further details on the action.

Some JoyControl actions in detail:
JC: Scroll mode         As long as the button is hold down the analo gstick
                        scrolls the mouse wheel instead of moving the cursor.
JC: Activate other p.   The profile given as parameter will be activated.
                        For a hold-action please remember to assign this
                        action to the same button in the 'target' profile.
JC: Center window       Centers the active window around the mouse cursor.
JC: Next Task           Activates the next windows task (like Alt+Shift+Tab)
JC: Push a Key          Expects the key to be pushed as parameter.
                        Check list in section HotStrings for details.

Tip 1:   If you can't calibrate your joystick correctly anymore, increase the
         threshold to avoid unwanted movements.

Tip 2:   As long as a "JC: Activate other profile"-"Hold"-action button is
         pushed, all other buttons will perform a different action. This way
         the arrow keys could be used as WinAMP control buttons instead of
         their default function while holding the button.

Known Problems:
- The AutoHotkey menu feature kills the functionality of ac'tivAid, most
  notable with JoyControl. This extension won't work if any menu created
  by ac'tivAid is shown.
- In some not reproducible cases the minimize/maximize/close buttons freeze
  ac'tivAid the same way. This behavior seems to be depended on the Windows
  theme choice (the windows classic theme is a safe way to go) and occurs
  mostly when clicking on the border of those buttons. A short mouse movement
  fixes this problem.
_____________________________________________________________________________
 6.57. VolumeControl - Hotkeys for changing the system volume
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
This extension allows to control the volume settings of the system. Similar to
OS X the volume can be displayed in an OSD that is faded in and out. The
device number and the component can be chosen freely. By choosing the WAVE
component, also the volume of SPDIF-output can be controlled (only XP).

When the acoustic signal is activated, an extra key can be defined to suppress
the signal (especially in situations where it would disturb).

VolumeControl (previous a part of MusicControl) has been adapted to Vista
completely. For this reason, the previously recommended compatibility mode of
AutoHotkey.exe should be reset. This option is suggested by VolumeControl
during the first start. It also can be done manually inside the settings of
AutoHotkey.exe (or ac'tivAid.exe).

Default-Hotkeys:
Win + Cursor up:               System volume up
Win + Cursor down:             System volume down
Pause key:                     Toggle mute
_____________________________________________________________________________
 6.58. SpeechAction - Control Windows by voice
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
With this extension it is possible to use the Windows Speech Recognition API
to control windows. This requires the Microsoft Speech API (short SAPI) to
be installed (you can find the download link in the configuration dialog).
The voice input can be activated in two way: with a certain key word (by
default 'computer') and/or with a push of a key. If both conditions are
required, both must me met. If the keyword has been recognized a audio signal
will notify you about entering the command mode. As long as your in this mode
(lasts about 3 seconds) only those words defined as voice commands will be
recognized. A good choice of words with different sound characteristics and
the training of the speech recognition engine (Control Panel > Speech >
Speech recognition) improves the accuracy of recognition noticeable.
Furthermore a speech command does not have to be a single word, but must
never contain one of the other commands (not "WinAMP" and "WinAMP Playlist").
It is possible to send the text spoken after the command as parameter to the
chosen action. Doing this you should know you won't be recognized very well,
because the dictionary is much larger listening to every possible word.
Nonetheless this allows for example "Computer! Google! Magazin für Computer
Technik" by using a UserHotkey linking to google with %ActionParameter% as
search term.
_____________________________________________________________________________
 6.59. TypeWith9Keys - On screen Keyboard for text input with T9
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
This extension allows very fast on screen text input, based on numbers. More
than one letter is assigned to a number key. The letter fitting best to the
whole word is chosen. Users sending often short messages, will get used to the
handling quite fast: you write by clicking the numbers (or if you are using
JoyControl by pushing arrow keys and space) and the shortest, most often
written and to the numbers matching word will be shown in the field at the top
left. Other more unlikely words also matching the numbers can be found in the
drop-down box below. If you've finished a word accept it by pushing the space
button (the zero-key). Typing errors can be fixed with either the big
"<"-button, erasing the last word, or with the small "<"-button, erasing the
last letter. If you want to delete the whole last sentence right click on the
big "<"-button. Digits and additional chars are accessible via the buttons "1"
and "*". "Abc" controls the automatic upper and lower case.

Its substantial to have a good dictionary for writing with TypeWith9Keys. With
ac'tivAid comes a list with the 10.000 most often used German words, but also
the possibility to create own dictionaries by reading through txt files. Most
suitable are ICQ-log-files or emails, basic text where every word counts and
can be prioritized this way. But you can also import word list, text files
where each line has only a single word, ordered descending by priority. But
be aware AutoHotkey does not support Unicode yet, so you may want to convert
your text files to ANSI first. If one of your applications does not support
key push simulations its also possible to save the entered text in the
clipboard. Especially for users of JoyControl this extension can be useful.
_____________________________________________________________________________
 6.60. RealExpose - Exposé clone
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
RealExpose is a remake of the Mac OS task chooser Exposé. Basically it shows
all open (and not minimized) windows tiled and scaled to thumbnails on the
whole screen, making each window completely visible (even if its to small to
read). A click on one of the thumbnails activates the corresponding window.
Because of the graphic effects (animation, scaling etc) this extension eats a
certain amount of you CPU on activation, but this can be adapted to your
situation in the configuration dialog.
_____________________________________________________________________________
 6.61. Surrounder - Inserts surrounding-characters context sensitive
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
With Surrounder you set typical surrounding characters around your selection
without learning extra hotkeys. If there is nothing selected it works like
without the extension. For instance: You have "a text" selected and press "("
you get "(a text)". With no selection it will just print "(".

This works with all types off brackets, single characters like apostrophe and
quotation marks as well. Now with the + at "single characters" you can even
add any character you like.

The back tick ` and percent sign % are handled separately as they are special
AutoHotkey characters. So this is rather useful for scripters and programmers.
If you check the back tick please note that there are some more changes made
to that key:
1. the key acts on the 1st keystroke
2. the back tick is already written without pressing shift!
3. you won't be able to write letters like é or á anymore (see CharacterAid)

Of course with Surrounder you loose the possibility to replace selected text
with the enabled keys! But if you once get into it its awesome handy!
Especially the round and square brackets can be hit a little better as they
are on 2 keys.

Remark: Unfortunately functions of other ac'tivAid-extensions that use the
same keys will be disabled! That for instance applies to the apostrophe of
CharacterAid or any HotString that contains a character thats enabled in
Surrounder.
_____________________________________________________________________________
 6.62. FileHandle - Shows open file handles
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
FileHandle is basically an extension to other extensions. It offers the
ability to check if a file has been opened by another program and still
blocks accessing it. Often this prevents deleting or renaming a file, but
also removing external storage devices. FileHandle can close the process,
kill the handle or switch to the blocking application.
Only RemoveDriveHotkey is currently using this feature.
"SysInternals Handle" is mandatory to FileHandle.
_____________________________________________________________________________
 6.63. InputBlocker - Blocks mouse and keyboard input
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
With InputBlocker your are able to block the mouse and keyboard input with
a hotkey or by a specific inactivity time. Programs are still running but
can't be controlled. You can release the blocking by blindly typing the
specified password. You'll only see reaction if the password is accepted.
If you don't have specified a password, you have to press Enter to realease
the blocking.

The blocking is realized by several tricks, which don't work in any
situation. The blocking of Ctrl+Alt+Del is done by banning the task
manager. This does not work in Vista and XP within a domain because there
the task manager does not launch directly. But the blocking is still active
if you returen to the last user account and you even can't use the task
manager to bypass the blocking. Only a regular reboot can turn of the
blocking. Therefore InputBlocker is not a reliable tool to protect your
Computer from unallowed access but only to avoid or make it difficult to
controll the actual user account.

Due to the ability to launch programs before blocking InputBlocker is a
perfect companion for face recognition from c't 13/08 (page 168). You just
have to choose FaceRecognitionApp.exe and to enter there the same password
like in InputBlocker. You should add an ~ to the password in InputBlocker as
this sends the Enter key after the password which improves reliability.
FaceRecognitionApp sends the password to InputBlocker through simulated
keyboard input as soon as the face is identified. If the recognition does
not work you could also enter the password manually.
_____________________________________________________________________________
 6.64. CronJobs - A time-based scheduling service
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
CronJobs can perform ac'tivAid functions on a regular basis. If you want to
use it to execute external programs, you have to create an entry in
UserHotkeys so you can select it in CronJobs. May be you have to close the
configuration window and reopen it to see new entries in CronJobs.
_____________________________________________________________________________
 6.65. MouseGestures - Control Windows with drawn symbols
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
With MouseGestures Windows can be controlled by drawing symbols on screen and
pushing a gesturekey at the same time. Each gesture is defined by a set of
absolute angles, meaning 0° is always East, 90° always North and so on.
Furthermore does it not matter how long a line is drawn, resulting in P and D
being the same symbols. Each following angle has to be delimited by a "-".

Some Examples:
0-90            0° -> 90°               Mouse to the east, then north
180-0-180       180° -> 0° -> 180°      Left, right, left
270             270°                    South
45-315-180      45° -> 315° -> 180°     Upper right, Lower right, Left
                                        -> a triangle
But be aware:
90-0-270-180                            P
90-0-270-180                            D

The first of two equal gestures will be executed.
_____________________________________________________________________________
 6.66. DesktopIcons - Positioniert Icons auf dem Desktop
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
DesktopIcons saves the positions of symbols on the desktop in a resolution
profile. When activated, the symbols get rearranged the way they been saved
in the profile before.
Icons which are created after your profile is set keep their position even
after rearrangement.
The saved profile for the current resolution can also be activated by a
HotKey. If DriveIcons are deactivated, their repositioning can be turned off
in the "Advanced settings".
_____________________________________________________________________________
 6.67. TaskbarTools - Verschieben von Taskbarbuttons mit Drag'n'Drop
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
TaskbarTools allows you not only to relocate taskbar buttons, but can also
close applications with a left mouse button / keyboard combination or (if
activated) minimize them under MinimizeToTray.

This requires at least Windows XP.
_____________________________________________________________________________
 6.68. ActiveGoto - Autohotkey Programmierunterstützung
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
ActiveGoto is analysing opened *.ahk-files in the favourite editor and offers
an overview of all found labels, functions and Hotkeys after using the
ActiveGoTo-Hotkey. With a double click on an entry, the editor directly jumps
to the according line.
Requirements are that the editor has an integrated key combination for
jumping to specific lines (GoTo) and that activeGoTo has been configured
accordingly.
_____________________________________________________________________________
 6.69. PopUpKiller -  Automatic close/minimize/maximize/ect. of windows
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
PopUpKiller looks every second for windows titles based on Regular
Expressions and then do the appropriate action. In contrast to the usual popup 
blockers it can not just act with browser windows and there are more actions.
The following actions are possible: close (then message is shown and and a 
tone is played, configurable), maximize, minimize, and keep in Foreground.
_____________________________________________________________________________
 7. Integration of own extensions and functionalities
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
The explanation of the integration of own extensions is only available in
German language in the file "Eigene Erweiterungen.txt" in the directory
"development". At the moment these explanations are only available in German.

To add own functions, includes, hotkeys or HotStrings, a file
settings\includescript.ahk can be created, that will be loaded to ac'tivAid
after the initialization of the extensions.
_____________________________________________________________________________
 8. Support for multiple languages
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
By default ac'tivAid supports German and English language. For all German
systems, the German language is active, for all others the English language is
active by default. Additionally the Language-File Creator.ahk in the directory
development allows to extract all language variables of ac'tivAid and all
extensions to create a special language file that can be translated.
Adding this file in the directory settings/languages, provides the additional
language in the selection.
_____________________________________________________________________________
 9. Overview of shortcuts
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
An overview of all used hotkeys can be displayed using the help menu (in the
menu bar of the configuration) The overview cal also be toggled using the
hotkey (default: Win+Ctrl+F1).

To print the list, it has to be copied and pasted to a text editor which then
can be used to print the list. When the cursor is inside the list, Ctrl+C
copies the complete text.
_____________________________________________________________________________
 10. Frequently asked questions (FAQ)
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
The German FAQ of ac'tivAid can be found at:
http://www.heise.de/software/download/special/activaid_forte/10_11

The website can be called using the menu entry in the help menu.
