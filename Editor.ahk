#SingleInstance force
#Persistent
#NoEnv

#Include lib\JSON.ahk
#Include lib\OrderedArray.ahk

factorioClusterio := A_Desktop "\Clusterio\factorioClusterio\"

Loop %factorioClusterio%\instances\*, 2, 0
{
	DropDownList .= A_LoopFileName "|"
}

; Serverselect
Gui, Add, Text, xp y+10 h13, Server:
Gui, Add, DropDownList, x+5 yp-2 w150 vSelectFile Choose1, %DropDownList%
Gui, Add, Button, x+5 yp-2 w50 h23 gLoad, Load
Gui, Add, Button, x+5 yp w50 h23 gDefault, Default

; Tabs
Gui, Add, Tab, xm+5 y+10 w288 h270, General|Advanced|Whitelist|Settings

; Tab General
Gui, Add, Text, xp+10 y+5, Name:
Gui, Add, Edit, x+30 yp w200 h20 vGET_Name, 
Gui, Add, Text, xm14 y+10, Description:
Gui, Add, Edit, x+5 yp w200 h20 vGET_Description,
Gui, Add, Text, xm+75 y+10, Tags:
Gui, Add, Edit, xp y+5 w100 h100 vGET_Tags_List,
Gui, Add, Text, x+5 yp-17, Admins:
Gui, Add, Edit, xp yp+17 w100 h100 vGET_Admins_List,
Gui, Add, Text, xm+19 yp+110, Slots:
Gui, Add, Edit, xp+55 yp-2 w30 h20 vGET_Slots,
Gui, Add, Button, xm+75 y+5 w200 h20 gSave, Save
Gui, Show, AutoSize, Server Config Editor

; Tab Advanced
; username
; token
; allow command
; autosave_interval
; autosave_slots
; afk_autokick_interval
; auto_pause
; verify_user_identity

; Tab Whitelist

; Tab Banlist

; Tab Settings
; port
; factorioport
; etc. 

GoSub Load
return

Default:
File := A_WorkingDir "\default-server-settings.json"
GoSub ReadJSON
return

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

GuiControl:
GuiControl, Text, GET_Name, %Read_Name%
GuiControl, Text, GET_Description, %Read_Description%
GuiControl, Text, GET_Tags_List, %Tags_List%
GuiControl, Text, GET_Admins_List, %Admins_List%
GuiControl, Text, GET_Slots, %Read_MaxPlayers%
return

ReadJSON:
FileRead, jsonFile, %File%
ImportJSON := JSON.Load(jsonFile)

Read_Name := ImportJSON.name
Read_Description := ImportJSON.description
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
Read_Public := ImportJSON.visibility.public
Read_LAN := ImportJSON.visibility.lan
Read_Username := ImportJSON.username
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

Save:
GuiControlGet, Split_GET_Tags_List,, GET_Tags_List
GuiControlGet, Split_GET_Admins_List,, GET_Admins_List
GuiControlGet, New_Name,, GET_Name
GuiControlGet, New_Description,, GET_Description
GuiControlGet, New_Slots,, GET_Slots

StringSplit, GET_Tag, Split_GET_Tags_List, `n
StringSplit, GET_Admin, Split_GET_Admins_List, `n

Array := OrderedArray(        "name", New_Name
							, "description", New_Description
							, "tags", []
							, "max_players", New_Slots
							, "visibility", { public: Read_Visibility_Public, lan: Read_Visibility_Lan }
							, "username", Read_Username
							, "token", Read_Token
							, "game_password", Read_Game_Password
							, "verify_user_identity", Read_Verify_User_Identity
							, "admins", []
							, "allow_commands", Read_Allow_Commands
							, "autosave_interval", Read_Autosave_Interval
							, "autosave_slots", Read_Autosave_Slots
							, "afk_autokick_interval", Read_AFK_Autokick_Interval
							, "auto_pause", Read_Auto_Pause )

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

JSON_Create := JSON.Dump(Array,,4)

GuiControlGet, GET_File,, SelectFile
Loop %factorioClusterio%\instances\*, 2, 0
{
	If (GET_File == A_LoopFileName) {
		File := factorioClusterio "\instances\" A_LoopFileName "\server-settings.json"
		break
	}
}

StringSplit, JSON_Split, JSON_Create, `n
Replaced_JSON :=
Search_Var := "auto_pause,verify_user_identity,lan,public"
StringSplit, Search_Word, Search_Var, `,

Loop %JSON_Split0%
{
	Current_Line := % JSON_Split%A_Index%
	Loop %Search_Word0%
	{
		Current_Word := % Search_Word%A_Index%
		IfInString, Current_Line, %Current_Word%
		{
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
MsgBox, 0, Server Config Editor, Saved!
return

GuiClose:
ExitApp