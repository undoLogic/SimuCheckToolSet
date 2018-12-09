; Created by Simucheck / undoLogic.com / Sacha Lewis Dmytruk
#SingleInstance
#InstallMouseHook
#Include SimuCheckToolSet_Lib.ahk
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.

; change to have it announce the name of this script
ComObjCreate("SAPI.SpVoice").Speak(NAME)

; gui head is required
#Include gui-head.ahk

Loop                                  
{
	Sleep, 50
	
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

; footer required
#Include gui-footer.ahk                 
return