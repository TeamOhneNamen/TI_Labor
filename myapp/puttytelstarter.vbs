' Starter for puttytel.
' Author:   H.H.Heitmann
' Date:     13.8.13
' Version:  1.01
' Script is based on "https://github.com/todbot/usbSearch/"
' 14.08.13: select statement improved.


'get full path of script
'needed to locate puttytel
set objRgx = CreateObject("vbScript.RegExp")
objRgx.Pattern = ".*\\"
set objRegMatches = objRgx.Execute(wscript.scriptfullname)
if objRegMatches.Count <> 1 then
  wscript.echo "Error in Path!"
  wscript.quit
end if
path=objRegMatches.Item(0)


'now get the list of COM ports
Set portList = GetComPorts()

'and check if there is one with VID=04D8 and PID=00DF
success = false
portnames = portList.Keys
for each pname in portnames
    Set portinfo = portList.item(pname)
    set objRgx = CreateObject("vbScript.RegExp")
    objRgx.Pattern = "VID_04D8&PID_00DF"
    set objRegMatches = objRgx.Execute(portinfo.PNPDeviceID)
    'wscript.echo portinfo.PNPDeviceID
    if objRegMatches.Count = 1 then
      'Port found, now start puttytel
      cmd=path & "puttytel.exe -serial " & pname & " -sercfg 8,1,115200,n,N"
      Dim sh: Set sh = CreateObject("WScript.Shell")
      Dim wsx: Set wsx = Sh.Exec(cmd)
      success=true
    end if
Next

if not success then
  wscript.echo "Keine passende serielle Schnittstelle gefunden!"
end if

'
' For all the keys in an entity, see
'http://msdn.microsoft.com/en-us/library/windows/desktop/aa394353(v=vs.85).aspx
'
Function GetComPorts()
    set portList = CreateObject("Scripting.Dictionary")

    strComputer = "."
    set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
    set colItems = objWMIService.ExecQuery _
        ("Select * from Win32_PnPEntity where caption like '%(COM%)%'")
    for each objItem in colItems
        set objRgx = CreateObject("vbScript.RegExp")
        strDevName = objItem.Name
        objRgx.Pattern = "COM[0-9]+"
        set objRegMatches = objRgx.Execute(strDevName)
        if objRegMatches.Count = 1 then
            portList.Add objRegMatches.Item(0).Value, objItem
        end if
    Next
    set GetComPorts = portList
End Function

