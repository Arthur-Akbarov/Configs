if WScript.Arguments.Count < 2 then
    WScript.Echo "Missing parameters"
end if

Set oWS = WScript.CreateObject("WScript.Shell")
sLinkFile = WScript.Arguments(0)
Set oLink = oWS.CreateShortcut(sLinkFile)

oLink.TargetPath = WScript.Arguments(1)

if WScript.Arguments.Count > 2 then
    oLink.HotKey = WScript.Arguments(2)
end if

if WScript.Arguments.Count > 3 then
    oLink.WindowStyle = WScript.Arguments(3)
end if

oLink.Save

'  oLink.Arguments = ""
'  oLink.Description = "MyProgram"
'  oLink.IconLocation = "C:\Program Files\MyApp\MyProgram.EXE, 2"
'  oLink.WindowStyle = "1"
'  oLink.Hotkey = "Ctrl+Shift+D"
'  oLink.WorkingDirectory = "C:\Program Files\MyApp"
