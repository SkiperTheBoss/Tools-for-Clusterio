#SingleInstance force
#Persistent
#NoEnv

#Include lib\JSON.ahk
#Include lib\OrderedArray.ahk

; List for Servername and they Path
Server_Config_Files := Object()

; The Script also works with Parameters
for n, param in A_Args
{
	If (param == "-file") {
		File := A_Args[n+1]
		IfExist, %File%
		{
			SplitPath, File, FileName, FileDir
			; Add Custom server-setting.json to the List
			Server_Config_Files.Push(Server_Name(file), [FileDir, FileName, Mods, []])+
			IfExist, %FileDir%\config.json
			{
				Path := FileDir "\config.json"
				SplitPath, Path , FileName, FileDir
				Server_Config_Files[NI][5] := FileName
			}
			Mods := Server_Config_Files[2][1] "\instanceMods\*.zip" 
			Loop, %Mods%, 1, 0
			{
				Server_Config_Files[2][4].Push(A_LoopFileName)
			} 
		} else {
			MsgBox, 16, Warning, Couldn't Load the File.`n`n%File%
		}
	}
}

; Path to the Clusterio Folder
factorioClusterio := A_Desktop "\Clusterio\factorioClusterio\"

Server_SharedMods := Object()
Loop %factorioClusterio%\sharedMods\*.zip, 1, 0
{
	Server_SharedMods.Push(A_LoopFileName)
	Server_SharedMods[0] := A_Index
}

; Make a List of all Instance there a placed in Clusterio Folder
NI := 2
Loop %factorioClusterio%\instances\*server-settings.json, 0, 1
{
	SplitPath A_LoopFileLongPath, FileName, FileDir
	Server_Config_Files.Push(Server_Name(A_LoopFileLongPath), [FileDir, FileName, Mods, []])
	IfExist, %FileDir%\config.json
	{
		Path := FileDir "\config.json"
		SplitPath, Path , FileName, FileDir
		Server_Config_Files[NI][5] := FileName
	}
	
	mods_i := 0
	Loop %FileDir%\instanceMods\*.zip, 1, 0
	{
		Server_Config_Files[NI][4].Push(A_LoopFileName)
		mods_i := A_Index
	}
	Server_Config_Files[NI][4][0] := mods_i
	NI += 2
}

Split_List := % Server_Config_Files.Length() / 2
NI := 1

Loop % Floor(Split_List)
{
	DropDownList .= Server_Config_Files[NI] "|"
	NI += 2
}

; Serverselect
Gui, Add, Text, xp y+10 h13, Server:
Gui, Add, DropDownList, x+5 yp-2 w150 vSelectFile Choose1, %DropDownList%
Gui, Add, Button, x+5 yp-2 w50 h23 gLoad, Load
Gui, Add, Button, x+5 yp w50 h23 gDefault, Default
Gui, Add, Button, xm5 y370 w288 h30 gSave, Save

; Tabs
Gui, Add, Tab, xm+5 ym40 w288 h320 vTabs, General|Advanced|Whitelist|Banlist|Mods|Settings

; Tab General
Gui, Add, Text, xp10 y+5, Name:
Gui, Add, Edit, x+30 yp w200 h20 vGET_Name, 
Gui, Add, Text, xm14 y+10, Description:
Gui, Add, Edit, x+5 yp w200 h20 vGET_Description,
Gui, Add, Text, xm14 y+10, Game`nPassword:
Gui, Add, Edit, x+12 yp w200 h20 vGET_Game_Password,
Gui, Add, Text, xm+75 y+10, Tags:
Gui, Add, Edit, xp y+5 w100 h100 vGET_Tags_List,
Gui, Add, Text, x+5 yp-17, Admins:
Gui, Add, Edit, xp yp+17 w100 h100 vGET_Admins_List,
Gui, Add, Text, xm+19 yp+110, Slots:
Gui, Add, Slider, x+25 yp w174 Range1-100 vGET_Max_Players_Slider gSE TickInterval5 altsubmit, 5
Gui, Add, Edit, x+5 yp-2 w30 h20 vGET_Max_Players_Edit gES,

; Tab Advanced
Gui, Tab, 2
Gui, Add, Text, xm15 y+5 w50, Username:
Gui, Add, Edit, x+10 yp w200 h20 vGET_Username,
Gui, Add, Text, xm15 y+10 w50, Password:
Gui, Add, Edit, x+10 yp w200 h20 vGET_Password,
Gui, Add, Text, xm15 y+10 w50, Token:
Gui, Add, Edit, x+10 yp w200 h20 vGET_Token,
Gui, Add, Checkbox, xp y+10 vGET_Auto_Pause, Auto Pause
Gui, Add, Checkbox, x+5 yp vGET_Verify_User_Identity, Verified Players
Gui, Add, Checkbox, xp-83 y+10 vGET_Visibility_Public, Public
Gui, Add, Checkbox, x+5 yp vGET_Visibility_Lan, Lan
Gui, Add, Text, xm15 y+10, Allow Commands:
Gui, Add, Radio, x+5 yp vGET_Allow_Commands altsubmit hwndGAC1, Admins Only
Gui, Add, Radio, x+5 yp altsubmit hwndGAC2, Yes
Gui, Add, Radio, x+5 yp altsubmit hwndGAC3, No
Gui, Add, Text, xm15 y+10 w90, Auto Save Interval (Min):
Gui, Add, Slider, x+3 yp w140 Range0-60 vGET_Autosave_Interval_Slider gSE TickInterval5 altsubmit, 5
Gui, Add, Edit, x+5 yp w30 vGET_Autosave_Interval_Edit gES, 5
Gui, Add, Text, xm15 y+10 w90, Auto Save Slots:
Gui, Add, Slider, x+5 yp w140 Range0-10 vGET_Autosave_Slots_Slider gSE TickInterval1 altsubmit, 5
Gui, Add, Edit, x+5 yp w30 vGET_Autosave_Slots_Edit gES, 5
Gui, Add, Text, xm15 y+10 w90, AFK Autokick Interval (Min):
Gui, Add, Slider, x+5 yp w140 Range0-60 vGET_AFK_Autokick_Interval_Slider gSE TickInterval5 altsubmit,  0
Gui, Add, Edit, x+5 yp w30 vGET_AFK_Autokick_Interval_Edit gES, 0
; Options: true, false
; non-blocking-saving=false
; Options: true, false
; autosave-only-on-server=true
; Options: true, false
; only-admins-can-pause=true
; Options: true, false
; ignore-player-limit-when-returning=false
; game_password

; Tab Whitelist

; Tab Banlist

; Tab Mds
Gui, Tab, 5
Gui, Add, ListBox, w260 h250 +Redraw vMods ReadOnly,
Gui, Add, Button, gOpenModFolder, Open Mods Folder
Gui, Add, Button, x+30 yp gOpenSharedModsFolder, Open Share Mods Folder

; Tab Settings
Gui, Tab, 6
Gui, Add, Text, xm15 y91, Max Upload (kb/s):
Gui, Add, Slider, x+15 yp w120 Range0-60 TickInterval5 altsubmit vGET_Max_Upload_Slider gSE, 0
Gui, Add, Edit, x+5 yp w30 vGET_Max_Upload_Edit gES, 0
Gui, Add, Text, xm15 y+10, Min. Latency (Ticks):
Gui, Add, Slider, x+8 yp w120 Range0-60 TickInterval5 altsubmit vGET_Min_Latency_Slider gSE, 0
Gui, Add, Edit, x+5 yp w30 vGET_Min_Latency_Edit gES, 0
Gui, Add, Text, xm15 y+15, Client Port:
Gui, Add, Edit, x+32 yp w60 vGET_clientPort,
Gui, Add, Text, xm15 y+10, Client Password:
Gui, Add, Edit, x+5 yp w60 vGET_clientPassword,
Gui, Add, Text, xm15 y+10, Factorio Port:
Gui, Add, Edit, x+20 yp w60 vGET_factorioPort,

; Show the GUI
Gui, Show, AutoSize, Server Config Editor

If (File)
	GoSub, ReadJSON
else
	GoSub Load
return

; Open the Mods Folder
OpenModFolder:
NI := 2
Loop
{
	Current_Path := Server_Config_Files[NI][1] "\" Server_Config_Files[NI][2]
	If (Current_Path == File) {
		run % Server_Config_Files[NI][1] "\instanceMods"
		break
	}
	NI += 2
}
NI := 0
return

; Open the Share Mods Folder
OpenSharedModsFolder:
run %factorioClusterio%\sharedMods
return

; Sliders will Control the Edit
SE:
GuiControlGet, ASIS,, GET_Autosave_Interval_Slider
GuiControl, Text, GET_Autosave_Interval_Edit, %ASIS%
GuiControlGet, ASSS,, GET_Autosave_Slots_Slider
GuiControl, Text, GET_Autosave_Slots_Edit, %ASSS%
GuiControlGet, AAIS,, GET_AFK_Autokick_Interval_Slider
GuiControl, Text, GET_AFK_Autokick_Interval_Edit, %AAIS%
GuiControlGet, GSS,, GET_Max_Players_Slider
GuiControl, Text, GET_Max_Players_Edit, %GSS%
GuiControlGet, GMUS,, GET_Max_Upload_Slider
GuiControl, Text, GET_Max_Upload_Edit, %GMUS%
GuiControlGet, GMLS,, GET_Min_Latency_Slider
GuiControl, Text, GET_Min_Latency_Edit, %GMLS%
return

; Edit will Control the Sliders
ES:
GuiControlGet, ASIS,, GET_Autosave_Interval_Edit
GuiControl, Text, GET_Autosave_Interval_Slider, %ASIS%
GuiControlGet, ASSS,, GET_Autosave_Slots_Edit
GuiControl, Text, GET_Autosave_Slots_Slider, %ASSS%
GuiControlGet, AAIS,, GET_AFK_Autokick_Interval_Edit
GuiControl, Text, GET_AFK_Autokick_Interval_Slider, %AAIS%
GuiControlGet, GSS,, GET_Max_Players_Edit
GuiControl, Text, GET_Max_Player_Slider, %GSS%
GuiControlGet, GMUS,, GET_Max_Upload_Edit
GuiControl, Text, GET_Max_Upload_Slider, %GMUS%
GuiControlGet, GMLS,, GET_Min_Latency_Edit
GuiControl, Text, GET_Min_Latency_Slider, %GMLS%
return

; Load the Default Server Setting that you can Change.
Default:
File := A_WorkingDir "\default-server-settings.json"
GoSub ReadJSON
return

; Load the default-server-settings.json
Load:
GuiControlGet, GET_File,, SelectFile

If (GET_File) {
	NI := 1
	PI := 2
	
	Loop % Floor(Split_List)
	{	; Grab the right Path
		GET_Current_Server_Name := Server_Config_Files[NI]
		If (GET_File == GET_Current_Server_Name ) {
			File := Server_Config_Files[PI].1 "\" Server_Config_Files[PI].2
			Config_File := Server_Config_Files[PI].1 "\" Server_Config_Files[PI][5]
			break
		}
		NI += 2
		PI += 2
	}
	
	GoSub ReadJSON
} else
	MsgBox, 16, Error, Couldn't load the File!
return

; Change the Value of some Controls in the Gui
GuiControl:
GET_Keys := "name,description,game_password,username,password,token,autosave_interval?se,autosave_slots?se,afk_autokick_interval?se,visibility_public?tf,visibility_lan?tf,verify_user_identity?tf,auto_pause?tf,max_players?se,tags?l,admins?l,factorioPort,clientPort,clientPassword"
StringSplit, GET_Array, GET_Keys, `,
Loop %GET_Array0%
{
	str = % GET_Array%A_Index%
	IfInString, str, ?
	{
		StringSplit, str_split, str, ?
		If (str_split2 == "se") ; Slider controls Edit & Edit controls Slider
		{
			var := Read_%str_split1%
			GuiControl, Text, GET_%str_split1%_Slider, %var% ; Slider Control
			GuiControl, Text, GET_%str_split1%_Edit, %var% ; Edit Control
		} else If (str_split2 == "tf") { ; true or false
			If (Read_%str_split1% == 1 or Read_%str_split1% == true)
				GuiControl,, GET_%str_split1%, 1
			else If (Read_%str_split1% == 0 or Read_%str_split1% == false or !Read_%str_split1%)
				GuiControl,, GET_%str_split1%, 0
		} else If (str_split2 == "l") {
			GuiControl, Text, GET_%str_split1%_List, % %str_split1%_List
		}
	} else
		GuiControl, Text, GET_%str%, % Read_%str% ; Control
}

If (Read_Allow_Commands == "admins-only")
	GuiControl,, %GAC1%, 1
else If (Read_Allow_Commands == "true" or Read_Allow_Commands == 1)
	GuiControl,, %GAC2%, 1
else If (Read_Allow_Commands == "false" or Read_Allow_Commands == 0 or !Read_Allow_Commands)
	GuiControl,, %GAC3%, 1
return

; Load a JSON File correct (server-settings.json)
ReadJSON:
FileRead, jsonFile, %File%
ImportJSON := JSON.Load(jsonFile)

Read_Keys := "name,description,game_password,tags,max_players,username,password,token,game_password,verify_user_identity,admins,allow_commands,autosave_interval,autosave_slots,afk_autokick_interval,auto_pause,visibility.public,visibility.lan"
StringSplit, Read_Array, Read_Keys, `,
Loop %Read_Array0%
{
	str = % Read_Array%A_Index%
	IfInString, str, .
	{
		StringReplace, str_new, str, ., _, all
		StringSplit, str_array, str, .
		If (str_array0) {
			Read_%str_new% := ImportJSON[str_array1][str_array2]
		}
	} else
		Read_%str% := ImportJSON[str]
}

; Load a JSON File correct (config.json)
FileRead, Config_JSON_File, %Config_File%
Import_Config_JSON := JSON.Load(Config_JSON_File)

Read_Config_Keys := "factorioPort,clientPort,clientPassword"
StringSplit, Read_Config_Array, Read_Config_Keys, `,
Loop %Read_Config_Array0%
{
	str = % Read_Config_Array%A_Index%
	Read_%str% := Import_Config_JSON[str]
}

NI := 2
Loop
{
	Current_Path := Server_Config_Files[NI][1] "\" Server_Config_Files[NI][2]
	If (Current_Path == File) {
		GuiControl,, Mods, |
		Modlist :=
		Loop % Server_SharedMods[0]
		{
			Modlist .= Server_SharedMods[A_Index]
			If (Server_SharedMods[A_Index]) {
				Modlist .= "|"
			}
		}
		If (Server_Config_Files[NI][4][0])
			Modlist .= "|"
		Loop % Server_Config_Files[NI][4][0]
		{
			Modlist .= Server_Config_Files[NI][4][A_Index]
			If (Server_Config_Files[NI][4][A_Index+1]) {
				Modlist .= "|"
			}
		}
		GuiControl,, Mods, %Modlist%
		break
	}
	NI += 2
}
NI := 0

List_Keys := "tags,admins"
StringSplit, List_Array, List_Keys, `,
Loop %List_Array0%
{
	str := List_Array%A_Index%
	%str%_List :=
	;MsgBox %str%
	Loop
	{
		If ImportJSON[str][A_Index] {
			;Read_%str% := ImportJSON[str][A_Index]
			%str%_List .= ImportJSON[str][A_Index]
			if ImportJSON[str][A_Index+1]
				%str%_List .= "`n"
		} else {
			ImportJSON[str][0] := A_Index - 1
			break
		}
	}
}
GoSub, GuiControl
return

; Save as a JSON File (server-settings.json)
Save:
Gui, Submit, Nohide
GuiControlGet, GET_File,, SelectFile

NI := 1
PI := 2

; Check if current selected Server is loaded
Loop % Floor(Split_List)
{	; Grab the right Path
	Current_Server_Name := Server_Config_Files[NI]
	If (GET_File == Current_Server_Name)
	{
		Current_Server_Path := Server_Config_Files[PI][1] "\" Server_Config_Files[PI][2]
		If (File != Current_Server_Path) {
			MsgBox, 4132, Warning, You didn't Load the current selected Server`nCurrent selected Server: %Current_Server_Name%.`n`nDo you want to replace the current selected Server with the old Settings?`nOld Settings: %GET_Current_Server_Name%
			IfMsgBox, Yes
			{
				New_File := Server_Config_Files[PI][1] "\" Server_Config_Files[PI][2]
				New_Config_File := Server_Config_Files[PI][1] "\" Server_Config_Files[PI][5]
				GET_File := Current_Server_Name
			} else
				return
			break
		} else If (File == Current_Server_Path && GET_File == GET_Current_Server_Name) {
			New_File := Server_Config_Files[PI][1] "\" Server_Config_Files[PI][2]
			New_Config_File := Server_Config_Files[PI][1] "\" Server_Config_Files[PI][5]
			break
		}
	}
	NI += 2
	PI += 2
}

New_Keys := "name,description,game_password,max_players?e,username,password,token,auto_pause,verify_user_identity,autosave_interval?e,autosave_slots?e,afk_autokick_interval?e,visibility_lan,visibility_public"
StringSplit, New_Array, New_Keys, `,
Loop %New_Array0%
{
	str = % New_Array%A_Index%
	IfInString, str, ?
	{
		StringSplit, str_split, str, ?
		If (str_split2 == "e") 
			GuiControlGet, New_%str_split1%,, GET_%str_split1%_Edit
	} else
		GuiControlGet, New_%str%,, GET_%str%
}

New_Config_Keys := "factorioPort,clientPort,clientPassword"
StringSplit, New_Config_Array, New_Config_Keys, `,
Loop %New_Config_Array0%
{
	str = % New_Config_Array%A_Index%
	IfInString, str, ?
	{
		StringSplit, str_split, str, ?
		If (str_split2 == "e") 
			GuiControlGet, New_%str_split1%,, GET_%str_split1%_Edit
	} else
		GuiControlGet, New_%str%,, GET_%str%
}

GuiControlGet, Split_GET_Tags_List,, GET_Tags_List
GuiControlGet, Split_GET_Admins_List,, GET_Admins_List
If (GET_Allow_Commands == 1 or GET_Allow_Commands == "admins-only")
	New_Allow_Commands = admins-only
else If (GET_Allow_Commands == 2 or GET_Allow_Commands == "true")
	New_Allow_Commands := true
else If (GET_Allow_Commands == 3 or GET_Allow_Commands == "false")
	New_Allow_Commands := false
StringSplit, GET_Tag, Split_GET_Tags_List, `n
StringSplit, GET_Admin, Split_GET_Admins_List, `n

; to Order the Array
Array := OrderedArray(   "name", New_Name
				   , "description", New_Description
				   ,	"game_password", New_Game_Password
				   , "tags", []
				   , "max_players", New_Max_Players
				   , "visibility", { public: New_Visibility_Public, lan: New_Visibility_Lan }
				   , "username", New_Username
				   , "password", New_Password
				   , "token", New_Token
				   , "game_password", New_Game_Password
				   , "verify_user_identity", New_Verify_User_Identity
				   , "admins", []
				   , "allow_commands", New_Allow_Commands
				   , "autosave_interval", New_Autosave_Interval
				   , "autosave_slots", New_Autosave_Slots
				   , "afk_autokick_interval", New_AFK_Autokick_Interval
				   , "auto_pause", New_Auto_Pause )

Array_Config := OrderedArray(  	"factorioPort", New_factorioPort
						   , "clientPort", New_clientPort
						   ,	"clientPassword", New_clientPassword )

Loop %GET_Tag0%
{
	if GET_Tag%A_Index%
		Array.tags.Push(GET_Tag%A_Index%)
}
Loop %GET_Admin0%
{
	if GET_Admin%A_Index%
		Array.admins.Push(GET_Admin%A_Index%)
}

; Create a JSON Format
JSON_Create := JSON.Dump(Array,,4)
JSON_Config_Create := JSON.Dump(Array_Config,,4)

; Make sure it dosen't save true/false with quotes
StringSplit, JSON_Split, JSON_Create, `n
Replaced_JSON :=
Search_Var := "auto_pause?tf,verify_user_identity?tf,lan?tf,public?tf,allow_commands?tf,afk_autokick_interval,autosave_slots,autosave_interval"
StringSplit, Search_Word, Search_Var, `,

Loop %JSON_Split0% ; check evey line
{
	Current_Line := % JSON_Split%A_Index%
	Loop %Search_Word0% ; check all varriable who needs the replace
	{
		Current_Word := % Search_Word%A_Index%
		IfInString, Current_Word, ?tf 
		{
			StringSplit, Current_Output, Current_Word, ?
			IfInString, Current_Line, %Current_Output1%
			{
				StringReplace, Current_Line, Current_Line, "1", true, all
				StringReplace, Current_Line, Current_Line, "0", false, all
				StringReplace, Current_Line, Current_Line, 1, true, all
				StringReplace, Current_Line, Current_Line, 0, false, all
			}
		} else {
			IfInString, Current_Line, %Current_Word%
			{
				StringSplit, Current_Selected, Current_Line, :
				StringReplace, Current_Selected2, Current_Selected2, ",, all
				Current_Line := Current_Selected1 ":" Current_Selected2
			}
		}
	}
	
	Replaced_JSON .= Current_Line
	R := A_Index + 1
	I := % JSON_Split%R%
	If  (I)
		Replaced_JSON .=  "`n"
}

If (New_File) {
	FileDelete, %New_File%
	FileAppend, %Replaced_JSON%, %New_File%
	FileDelete, %New_Config_File%
	FileAppend, %JSON_Config_Create%, %New_Config_File%
	MsgBox, 0, Server Config Editor, Save server-settings.json for %GET_File%!
} else {
	MsgBox, 16, Warning, Couldn't save the File!
}
return

GuiClose:
ExitApp

Server_Name(file) {
	FileRead, file_str, %file%
	str := JSON.Load(file_str)
	return str.name
}