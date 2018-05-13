#SingleInstance force
#Persistent
#NoEnv

factorioClusterio := A_Desktop "\Clusterio\factorioClusterio"

x := 5
y := 10

Gui, Add, Button, w200 h30 x%x% y%y% gStartMaster, Start Master
x += 210
Gui, Add, Button, w200 h30 x%x% y%y% gOpenSharedModFolder, Open SharedMods Folder
x -= 210
y += 45
Gui, Add, Button, w200 h30 x%x% y%y% gResetDatabase, Database reset

Loop, %factorioClusterio%\instances\*, 2, 0
{
	y += 45
	ServerName := A_LoopFileName
	Gui, Add, Button, w200 h30 x%x% y%y% gServerStart, %ServerName%
	x += 210
	Gui, Add, Button, w200 h30 x%x% y%y% gOpenModFolder, Open Mod Folder
	x -= 210
}
Gui, Show, AutoSize, Launcher
return

; Statet die Master.js
StartMaster:
run node "%factorioClusterio%\master.js", %factorioClusterio%
return

; Server starten
ServerStart:
run node "%factorioClusterio%\client.js" start %A_GuiControl%, %factorioClusterio%
return

; Mod Ordner für die jeweiligen Server öffnen
OpenModFolder:
run "%factorioClusterio%\%A_GuiControl%\instanceMods"
return

; Den geteilten Mod Ordner öffnen
OpenSharedModFolder:
run "%factorioClusterio%\sharedMods"
return

; Die Datenbank löschen!
ResetDatabase:
MsgBox, 4, Reset the Database, Do you really want do Reset the Database?
IfMsgBox, Yes
	Loop, %factorioClusterio%\database\*.json, 1, 0
		FileDelete, %A_LoopFileFullPath%
return

GuiClose:
ExitApp