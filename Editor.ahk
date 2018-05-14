#SingleInstance force
#Persistent
#NoEnv

#Include lib\JSON.ahk
#Include lib\OrderedArray.ahk

; Path to the Clusterio Folder
factorioClusterio := A_Desktop "\Clusterio\factorioClusterio\"

; Make a List of all Instance there a placed in Clusterio Folder
Loop %factorioClusterio%\instances\*, 2, 0
{
	DropDownList .= A_LoopFileName "|"
}

; Serverselect
Gui, Add, Text, xp y+10 h13, Server:
Gui, Add, DropDownList, x+5 yp-2 w150 vSelectFile Choose1, %DropDownList%
Gui, Add, Button, x+5 yp-2 w50 h23 gLoad, Load
Gui, Add, Button, x+5 yp w50 h23 gDefault, Default
Gui, Add, Button, xm5 y350 w288 h30 gSave, Save

; Tabs
Gui, Add, Tab, xm+5 ym40 w288 h300, General|Advanced|Whitelist|Banlist|Settings

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
Gui, Add, Slider, x+25 yp w174 Range1-100 vGET_Slots_Slider gSE TickInterval5 altsubmit, 5
Gui, Add, Edit, x+5 yp-2 w30 h20 vGET_Slots_Edit gES,

; Tab Advanced
Gui, Tab, 2
Gui, Add, Text, xm15 ym67 w50, Username:
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
Gui, Add, Slider, x+3 yp w140 Range0-60 vGET_Auto_Save_Interval_Slider gSE TickInterval5 altsubmit, 5
Gui, Add, Edit, x+5 yp w30 vGET_Auto_Save_Interval_Edit gES,
Gui, Add, Text, xm15 y+10 w90, Auto Save Slots:
Gui, Add, Slider, x+5 yp w140 Range0-10 vGET_Auto_Save_Slots_Slider gSE TickInterval1 altsubmit, 5
Gui, Add, Edit, x+5 yp w30 vGET_Auto_Save_Slots_Edit gES,
Gui, Add, Text, xm15 y+10 w90, AFK Autokick Interval (Min):
Gui, Add, Slider, x+5 yp w140 Range0-60 vGET_AFK_Autokick_Interval_Slider gSE TickInterval5 altsubmit,  0
Gui, Add, Edit, x+5 yp w30 vGET_AFK_Autokick_Interval_Edit gES,
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

; Tab Settings

; "max_upload_in_kilobytes_per_second": 0
; "minimum_latency_in_ticks": 0

; port
; factorioport
; etc. 

Gui, Show, AutoSize, Server Config Editor

GoSub Load
return

; Sliders will Control the Edit
SE:
GuiControlGet, ASIS,, GET_Auto_Save_Interval_Slider
GuiControl, Text, GET_Auto_Save_Interval_Edit, %ASIS%
GuiControlGet, ASSS,, GET_Auto_Save_Slots_Slider
GuiControl, Text, GET_Auto_Save_Slots_Edit, %ASSS%
GuiControlGet, AAIS,, GET_AFK_Autokick_Interval_Slider
GuiControl, Text, GET_AFK_Autokick_Interval_Edit, %AAIS%
GuiControlGet, GSS,, GET_Slots_Slider
GuiControl, Text, GET_Slots_Edit, %GSS%
return

; Edit will Control the Sliders
ES:
GuiControlGet, ASIS,, GET_Auto_Save_Interval_Edit
GuiControl, Text, GET_Auto_Save_Interval_Slider, %ASIS%
GuiControlGet, ASSS,, GET_Auto_Save_Slots_Edit
GuiControl, Text, GET_Auto_Save_Slots_Slider, %ASSS%
GuiControlGet, AAIS,, GET_AFK_Autokick_Interval_Edit
GuiControl, Text, GET_AFK_Autokick_Interval_Slider, %AAIS%
GuiControlGet, GSS,, GET_Slots_Edit
GuiControl, Text, GET_Slots_Slider, %GSS%
return

; Load the Default Server Setting that you can Change.
Default:
File := A_WorkingDir "\default-server-settings.json"
GoSub ReadJSON
return

; Load server-settings.json
Load:
GuiControlGet, GET_File,, SelectFile
Loop %factorioClusterio%\instances\*, 2, 0
{
	If (GET_File == A_LoopFileName) {
		File := factorioClusterio "\instances\" A_LoopFileName "\server-settings.json"
		break
	}
}
GoSub ReadJSON
return

; Change the Value of some Controls in the Gui
GuiControl:
GuiControl, Text, GET_Name, %Read_Name%
GuiControl, Text, GET_Description, %Read_Description%
GuiControl, Text, GET_Game_Password, %Read_Game_Password%
GuiControl, Text, GET_Tags_List, %Tags_List%
GuiControl, Text, GET_Admins_List, %Admins_List%
GuiControl, Text, GET_Slots_Edit, %Read_MaxPlayers%
GuiControl, Text, GET_Username, %Read_Username%
GuiControl, Text, GET_Password, %Read_Password%
GuiControl, Text, GET_Token, %Read_Token%
If (Read_Auto_Pause == "true" or Read_Auto_Pause == 1)
	GuiControl,, GET_Auto_Pause, 1
else
	GuiControl,, GET_Auto_Pause, 0
If (Read_Verify_User_Identity == "true" or Read_Verify_User_Identity == 1)
	GuiControl,, GET_Verify_User_Identity, 1
else
	GuiControl,, GET_Verify_User_Identity, 0
If (Read_Visibility_Public == "true" or Read_Visibility_Public == 1)
	GuiControl,, GET_Visibility_Public, 1
else
	GuiControl,, GET_Visibility_Public, 0
If (Read_Visibility_Lan = "true" or Read_Visibility_Lan == 1)
	GuiControl,, GET_Visibility_Lan, 1
else
	GuiControl,, GET_Visibility_Lan, 0
If (Read_Allow_Commands == "admins-only")
	GuiControl,, %GAC1%, 1
else If (Read_Allow_Commands == "true" or Read_Allow_Commands == 1)
	GuiControl,, %GAC2%, 1
else If (Read_Allow_Commands == "false" or Read_Allow_Commands == 0)
	GuiControl,, %GAC3%, 1
GuiControl, Text, GET_Auto_Save_Interval_Slider, %Read_Autosave_Interval%
GuiControl, Text, GET_Auto_Save_Interval_Edit, %Read_Autosave_Interval%
GuiControl, Text, GET_Auto_Save_Slots_Slider, %Read_Autosave_Slots%
GuiControl, Text, GET_Auto_Save_Slots_Edit, %Read_Autosave_Slots%
GuiControl, Text, GET_AFK_Autokick_Interval_Slider, %Read_AFK_Autokick_Interval%
GuiControl, Text, GET_AFK_Autokick_Interval_Edit, %Read_AFK_Autokick_Interval%
return

; Load a JSON File correct (server-settings.json)
ReadJSON:
FileRead, jsonFile, %File%
ImportJSON := JSON.Load(jsonFile)

Read_Name := ImportJSON.name
Read_Description := ImportJSON.description
Read_Game_Password := ImportJSON.game_password
Read_Tags := ImportJSON.tags
Tags_List :=
Loop
{
	if ImportJSON.tags[A_Index] {
		Read_Tags%A_Index% := ImportJSON.tags[A_Index]
		Tags_List .= ImportJSON.tags[A_Index]
		if ImportJSON.tags[A_Index+1]
			Tags_List .= "`n"
	} else {
		ImportJSON.tags.0 := A_Index - 1
		break
	}
}
Read_MaxPlayers := ImportJSON.max_players
Read_Visibility := ImportJSON.visibility
Read_Visibility_Public := ImportJSON.visibility.public
Read_Visibility_Lan := ImportJSON.visibility.lan
Read_Username := ImportJSON.username
Read_Password := ImportJSON.password
Read_Token := ImportJSON.token
Read_Game_Password := ImportJSON.game_password
Read_Verify_User_Identity := ImportJSON.verify_user_identity
Read_Admins := ImportJSON.admins
Admins_List :=
Loop
{
	if ImportJSON.admins[A_Index] {
		Read_Admin%A_Index% := ImportJSON.admins[A_Index]
		Admins_List .= ImportJSON.admins[A_Index]
		if ImportJSON.admins[A_Index+1]
			Admins_List .= "`n"
	} else {
		ImportJSON.admins.0 := A_Index - 1
		break
	}
}
Read_Allow_Commands := ImportJSON.allow_commands
Read_Autosave_Interval := ImportJSON.autosave_interval
Read_Autosave_Slots := ImportJSON.autosave_slots
Read_AFK_Autokick_Interval := ImportJSON.afk_autokick_interval
Read_Auto_Pause := ImportJSON.auto_pause
GoSub, GuiControl
return

; Save as a JSON File (server-settings.json)
Save:
Gui, Submit, Nohide
GuiControlGet, Split_GET_Tags_List,, GET_Tags_List
GuiControlGet, Split_GET_Admins_List,, GET_Admins_List
GuiControlGet, New_Name,, GET_Name
GuiControlGet, New_Description,, GET_Description
GuiControlGet, New_Game_Password,, GET_Game_Password
GuiControlGet, New_Slots,, GET_Slots_Edit
GuiControlGet, New_Username,, GET_Username
GuiControlGet, New_Password,, GET_Password
GuiControlGet, New_Token,, GET_Token
GuiControlGet, New_Auto_Pause,, GET_Auto_Pause
GuiControlGet, New_Verify_User_Identity,, GET_Verify_User_Identity
GuiControlGet, New_Auto_Save_Interval,, GET_Auto_Save_Interval_Edit
GuiControlGet, New_Auto_Save_Slots,, GET_Auto_Save_Slots_Edit
GuiControlGet, New_AFK_Autokick_Interval,, GET_AFK_Autokick_Interval_Edit
GuiControlGet, New_Visibility_Lan,, GET_Visibility_Lan
GuiControlGet, New_Visibility_Public,, GET_Visibility_Public
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
				   , "max_players", New_Slots
				   , "visibility", { public: New_Visibility_Public, lan: New_Visibility_Lan }
				   , "username", New_Username
				   , "password", New_Password
				   , "token", New_Token
				   , "game_password", New_Game_Password
				   , "verify_user_identity", New_Verify_User_Identity
				   , "admins", []
				   , "allow_commands", New_Allow_Commands
				   , "autosave_interval", New_Auto_Save_Interval
				   , "autosave_slots", New_Auto_Save_Slots
				   , "afk_autokick_interval", New_AFK_Autokick_Interval
				   , "auto_pause", New_Auto_Pause )

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

GuiControlGet, GET_File,, SelectFile
Loop %factorioClusterio%\instances\*, 2, 0
{
	If (GET_File == A_LoopFileName) {
		File := factorioClusterio "\instances\" A_LoopFileName "\server-settings.json"
		break
	}
}

; Make sure it dosen't save true/false with quotes
StringSplit, JSON_Split, JSON_Create, `n
Replaced_JSON :=
Search_Var := "auto_pause,verify_user_identity,lan,public,allow_commands"
StringSplit, Search_Word, Search_Var, `,

Loop %JSON_Split0% ; check evey line
{
	Current_Line := % JSON_Split%A_Index%
	Loop %Search_Word0% ; check all varriable who needs the replace
	{
		Current_Word := % Search_Word%A_Index%
		IfInString, Current_Line, %Current_Word%
		{
			StringReplace, Current_Line, Current_Line, "1", true, all
			StringReplace, Current_Line, Current_Line, "0", false, all
			StringReplace, Current_Line, Current_Line, 1, true, all
			StringReplace, Current_Line, Current_Line, 0, false, all
		}
	}
	
	Replaced_JSON .= Current_Line
	R := A_Index + 1
	I := % JSON_Split%R%
	If  (I)
		Replaced_JSON .=  "`n"
}

FileDelete, %File%
FileAppend, %Replaced_JSON%, %File%
MsgBox, 0, Server Config Editor, Save server-settings.json for %GET_File%!
return

GuiClose:
ExitApp