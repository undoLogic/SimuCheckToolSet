#SingleInstance
#InstallMouseHook
#Include SimuCheckToolSet_Lib.ahk
; Created by Simucheck / undoLogic.com / Sacha Lewis Dmytruk
; If you are interested to white-label our product please contact us
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.

;ComObjCreate("SAPI.SpVoice").Speak("Simucheck.com")
ComObjCreate("SAPI.SpVoice").Speak("World U S")

; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetFormat, float, 03  ; Omit decimal point from axis position percentages.
DEBUG = FALSE

; empty the log file
deleteLog()

; load gui
Gui, Add, Link,, Choose profile to activate:
Gui, Add, StatusBar,, Loading...
SB_SetText("v:"VERSION " - " NAME ": Offline")
Gui, Add, DropDownList, vCurrProfile, Offline|Online
Gui, Add, Button, Default, Submit
Gui,Add,Text,vJOYNAME w1000,% "Loading... " 
Gui,Add,Text,vJOYAXIS w1000,% "Loading... " 
Gui,Add,Text,vJOYBUTTONS w1000,% "Loading... " 
Gui,Add,Button, gUp, Joy+
Gui,Add,Button, gDown, Joy-
Gui,Add,Button,gRestartScript,RELOAD
Gui, Show, w300 h270, SimuCheck - %NAME%

global JoystickNumber := 3

writeToLog("Starting us", True)
Loop                                                                        
{
	Sleep, 50
	global ACTUAL

    ; Horn
    PushHoldKeyTopOrBottom(5, "JoyY", "", "", "{Space down}", "{Space up}")

    ; Bell
    PushKeyReleaseAnotherKey(5,6,"{b down}", 200, "{b up}", "", 0, "")
    
    ; Throttle
    AxisToKey(6, "JoyZ", 9, "{a down}", 94, "{a up}", 100, "{d down}", 94, "{d up}", 100)
    
    ; Independant brake
    AxisToKey(3, "JoyY", 10, "{] down}", 200, "{] up}", 100, "{[ down}", 200, "{[ up}", 100)
    
    ; Train brake
    AxisToKey(3, "JoyZ", 11, "{VKDE down}", 175, "{VKDE up}", 100, "{VKBA down}", 175, "{VKBA up}", 100)
    
    ; Direction
    AxisToKey(5, "JoyZ", 3, "{s down}", 300, "{s up}", 200, "{w down}", 300, "{w up}", 200)
   
    ;look down
    PushMouseRightBeforeAndAfter(6, 13, -100, 175, 100, -175)

    ;look right
    PushMouseRightBeforeAndAfter(6, 12, 250, 0, -250, 0)

    ;look left
    PushMouseRightBeforeAndAfter(6, 14, -250, 0, 250, 0)

    ; if you want all the OSD to show
    ; PushKeysReleaseOtherKeys(6, 1, "{Ctrl down}{1 down}{2 down}{3 down}{5 down}{4 down}{Sleep 100}{4 up}{4 down}{Sleep 100}{4 up}{Sleep 100}{5 up}{3 up}{2 up}{1 up}{Ctrl up}", "{Ctrl down}{1 down}{2 down}{3 down}{5 down}{4 down}{Sleep 100}{4 up}{4 down}{Sleep 100}{4 up}{Sleep 100}{5 up}{3 up}{2 up}{1 up}{Ctrl up}")
   
    ; destination top right upcoming and speedometer
    PushKeysReleaseOtherKeys(6, 1, "{Ctrl down}{1 down}{5 down}{4 down}{Sleep 100}{4 up}{4 down}{Sleep 100}{4 up}{Sleep 100}{5 up}{1 up}{Ctrl up}", "{Ctrl down}{1 down}{5 down}{4 down}{Sleep 100}{4 up}{4 down}{Sleep 100}{4 up}{Sleep 100}{5 up}{1 up}{Ctrl up}")
   
   ; OUTSIDE 1
    PushKeysReleaseOtherKeys(6, 7, "{3 down}{Sleep 100}{3 up}", "{1 down}{Sleep 100}{1 up}")

    ;out window
    PushKeysReleaseOtherKeys(6, 9, "{Right down}{Sleep 100}{Right up}", "{Left down}{Sleep 100}{Left up}")

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

ButtonSubmit:
Gui, Submit, NoHide
;MsgBox,% CurrProfile KeyboardActive
if (CurrProfile = "Online") {
    KeyboardActive = TRUE
} else {
    KeyboardActive = FALSE
}
SB_SetText("Current Profile: " CurrProfile)
return
                            
return