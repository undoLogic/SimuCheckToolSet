#SingleInstance
#InstallMouseHook
global NAME := "Template"
#Include SimuCheckToolSet_Lib.ahk
; Created by Simucheck / undoLogic.com / Sacha Lewis Dmytruk
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.

; change to have it announce the name of this script
ComObjCreate("SAPI.SpVoice").Speak(NAME)

; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetFormat, float, 03  ; Omit decimal point from axis position percentages.
DEBUG = FALSE

; empty the log file
deleteLog()

; load gui

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

Gui,Add,Button, x310 y120 w180 h20 gRestartScript,RELOAD
Gui, Show, w500 h170, SimuCheck - %NAME%

global JoystickNumber := 3

writeToLog("Starting 1 6 6", True)
Loop                                                                        
{
	Sleep, 50
	global ACTUAL

    ; Horn
    PushHoldKeyTopOrBottom(5, "JoyY", "{Space down}", "{Space up}", "", "")

    ; AWS
    PushKeyTopOrBottom(4, "JoyR", "q", "FALSE", 100)

    ; Throttle
    AxisToKey(6, "JoyZ", 13, "{a down}", 94, "{a up}",100, "{d down}", 94, "{d up}", 100)
    
    ; Direction
    AxisToKey(3, "JoyY", 4, "{s down}", 550, "{s up}", 200, "{w down}", 550, "{w up}", 200)
    
    ;look left / right
    PushMouse(6, 14, -200, 0, 200, 0)
    PushMouse(6, 12, 200, 0, -200, 0)
    
    ;look down
    PushMouse(6, 13, 0, 50, 0, -50)
    PushMouse(5, 6, 0, 150, 0, -150)

    ; look at heads up display
    PushKeyReleaseAnotherKey(6, 1, "{F4 down}", 125, "{F4 up}", "{F4 down}", 125, "{F4 up}")
    PushKeyReleaseAnotherKey(5, 5, "{F4 down}", 125, "{F4 up}", "{F4 down}", 125, "{F4 up}")

    ; load
    PushKeyReleaseAnotherKey(5, 2, "{t down}", 125, "{t up}", "", 0, "")

    ; Display the joystick values on the gui 
    JoyStickCheck(JoystickNumber)
}

; Buttons for the gui 
Up:
JoystickNumber+=1
return

Down:
JoystickNumber-=1
return

RestartScript:
Reload
return

GuiClose:
ExitApp 

Active:
    Gui, Submit, NoHide
    ;SB_SetText("Active Profile: " DDPort)
   
    GuiControl, +Backgroundgreen, Label

    if (%Active% = 0) {
        TurnOff()
        KeyboardActive = FALSE
    } else {
        TurnOn()
        KeyboardActive = TRUE
        ; activeProfile := newProfile
        ; MsgBox, % activeProfile
    }
return ; end

TurnOff() {
    ;uncheck active
    SB_SetText("Offline")
    GuiControl,, Active, 0
    ;LV_Delete()
}

; can't get variable to display
TurnOn() {
    SB_SetText("Profile Active")
    ;GuiControl,, Active, 1
}

; ButtonSubmit:
; Gui, Submit, NoHide
; ;MsgBox,% CurrProfile KeyboardActive
; if (CurrProfile = "Online") {
;     KeyboardActive = TRUE
; } else {
;     KeyboardActive = FALSE
; }
; SB_SetText("v:"VERSION " - " NAME ": " CurrProfile)
; return
                            
return