global NAME := "Template"
global JoystickNumber := 3
global ACTUAL

; empty the log file
deleteLog()

; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetFormat, float, 03  ; Omit decimal point from axis position percentages.
DEBUG = FALSE

Gui, Add, StatusBar,, Loading...
SB_SetText("Offline")
;Gui, Add, DropDownList, vCurrProfile, Offline|Online
Gui, Add, Checkbox, x10 y10 vActive gActive, Activate script
Gui, Add, GroupBox, r3 x10 y+10 w480 h50, Joystick Status
Gui,Add,Text,vJOYNAME xp+10 yp+20 r1 w1000,% "Loading... " 
Gui,Add,Text,vJOYAXIS xp+0 yp+20 r1 w1000,% "Loading... " 
Gui,Add,Text,vJOYBUTTONS xp+0 yp+20 r1 w1000,% "Loading... " 
Gui,Add,Button, x10 y120 w140 h20 gDown,Down
Gui,Add,Button, x+0 y120 w140 h20 gUp,Up
Gui,Add,Button, x300 y120 w80 h20 gDetect,DETECT
Gui,Add,Button, x390 y120 w100 h20 gRestartScript,RELOAD

Gui, Show, w500 h270, SimuCheck - %NAME%

writeToLog("Starting 1 6 6", True)