; Created by Simucheck / undoLogic.com / Sacha Lewis Dmytruk
#SingleInstance
#InstallMouseHook
#Include SimuCheckToolSet_Lib.ahk
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.

; change to have it announce the name of this script
ComObjCreate("SAPI.SpVoice").Speak("1 6 6")

; gui head is required
#Include gui-head.ahk

Loop                                  
{
	Sleep, 50

    ; Horn
    PushHoldKeyTopOrBottom(5, "JoyY", "{Space down}", "{Space up}", "", "")

    ; AWSq
    PushKeyReleaseAnotherKey(5, 5, "{q down}", 125, "{q up}", "", 10, "")


    ; Throttle
    AxisToKey(6, "JoyZ", 13, "{a down}", 94, "{a up}", 100, "{d down}", 94, "{d up}", 100)
    
    ; Direction
    AxisToKey(3, "JoyY", 4, "{s down}", 550, "{s up}", 200, "{w down}", 550, "{w up}", 200)
    
    ;look left / right
    PushMouse(6, 14, -200, 0, 200, 0)
    PushMouse(6, 12, 200, 0, -200, 0)
    PushMouse(5, 2, -200, 0, 200, 0)
    PushMouse(5, 3, 200, 0, -200, 0)
    ;look down joystick
    PushMouse(5, 1, 0, 150, 0, -150)
    ; zoom in (look really hard)
    PushKeysReleaseOtherKeys(5, 4, "{WheelUp 30}{WheelUp 30}{WheelUp 30}", "{WheelDown 30}{WheelDown 30}{WheelDown 30}")

    ;look down
    PushMouse(6, 13, 0, 150, 0, -150)
    
    ; look at heads up display
    PushKeyReleaseAnotherKey(6, 1, "{F4 down}", 125, "{F4 up}", "{F4 down}", 125, "{F4 up}")
    
    ; load joystick top little button
    PushKeyReleaseAnotherKey(5, 2, "{t down}", 125, "{t up}", "", 0, "")
    PushKeyReleaseAnotherKey(3, 1, "{t down}", 125, "{t up}", "", 0, "")

    ;lights
    AxisToKey(3, "JoyX", 3, "{h down}", 190, "{h up}", 150, "{Shift down}{h down}", 190, "{h up}{Shift up}", 150)

    ; OUTSIDE 1
    PushKeysReleaseOtherKeys(6, 7, "{3 down}{Sleep 100}{3 up}", "{1 down}{Sleep 100}{1 up}")
    PushKeysReleaseOtherKeys(6, 9, "{2 down}{Sleep 100}{2 up}", "{1 down}{Sleep 100}{1 up}")

    ; out side while waiting throttle small right button - doesn't come back inside
    PushKeysReleaseOtherKeys(3, 5, "{2 down}{F4 down}{Sleep 100}{F4 up}{2 up}", "")
    PushKeysReleaseOtherKeys(3, 6, "{1 down}{F4 down}{Sleep 100}{F4 up}{1 up}", "")
    PushKeysReleaseOtherKeys(6, 5, "{1 down}{F4 down}{Sleep 100}{F4 up}{1 up}", "")

    ; passenger
    PushKeysReleaseOtherKeys(6, 4, "{5 down}{F4 down}{Sleep 100}{F4 up}{5 up}", "")


    ; outside train drives away t
    PushKeysReleaseOtherKeys(6, 2, "{2 down}{Sleep 60}{2 up}{Sleep 100}{8 down}{Sleep 60}{8 up}{Sleep 60}{F4 down}{Sleep 60}{F4 up}", "")
    PushKeysReleaseOtherKeys(6, 3, "{3 down}{Sleep 60}{3 up}{Sleep 100}{8 down}{Sleep 60}{8 up}{Sleep 60}{F4 down}{Sleep 60}{F4 up}", "")

    ; look down and hold
    PushMouse(3, 3, 0, 0, 150, -150)
    PushMouse(3, 4, -150, 150, 0, 0)
	
    ; Display the joystick values on the gui 
    JoyStickCheck(JoystickNumber)
}

; footer required
#Include gui-footer.ahk                 
return