; Modified from https://autohotkey.com/board/topic/42056-how-do-i-make-a-log-window-in-my-gui/
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#InstallKeybdHook
#InstallMouseHook
#SingleInstance
CoordMode, Mouse, Screen

LastKey:="a"
StartTime:=A_TickCount

GetScancode(char) {
    return DllCall("MapVirtualKey","uint"
        ,DllCall("VkKeyScanA","char",asc(char))&0xFF,"uint",0) ; MAPVK_VK_TO_VSC=0
}

Gui, Add, Edit, w300 h100 vLogbox readonly,
;settimer, FakeActivity, 500
Gui, Show,, SimuCheck - Key Reader
WinGet Gui_ID, ID, A 
GuiControl Focus, logbox
ControlGetFocus logboxclass, ahk_id %Gui_ID% 

Loop
{
    KeyIsDown := GetKeyState(LastKey)
    if (KeyIsDown) {
        ; it is still pushed
    } else {
        Diff:= (A_TickCount - StartTime)

        ScanCode:=GetKeySC(LastKey)
        name := GetKeyName(LastKey)
        vk   := GetKeyVK(LastKey)
        sc   := GetKeySC(LastKey)
        log := Format("KEY:`t{} | VK:`t{:X} | SC:`t{:X}`tDurr:{} ms", name, vk, sc, Diff)
        updatelog(log)
        ; it is up, let's get the next one
        Input, LastKey, L1 V  
        StartTime:=A_TickCount
    }
    LastTime:=A_TickCount
	;message = %joy_name% (#%JoystickNumber%):`n%axis_info%`nButtons Down: %buttons_down%
	;FileAppend,%message%,%A_ScriptDir%\Detect.txt
    ;ToolTip, %message%
    Sleep, 10
}
return

updatelog(LogString)
{
 global logboxclass
 global Gui_ID
 GuiControlGet, logbox, , logbox
 guicontrol,,logbox, `n%logstring%
 ;ControlSend %logboxclass%, ^{End}, ahk_id %Gui_ID%
}

GuiClose:
ExitApp
