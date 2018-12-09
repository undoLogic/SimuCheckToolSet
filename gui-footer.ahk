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

Detect:
    SB_SetText("Opening Keyboard detect in separate window")
    Run SimuCheck-Keyboard-detect.ahk
return

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
    SB_SetText("Profile Active: "NAME)
    ;GuiControl,, Active, 1
}