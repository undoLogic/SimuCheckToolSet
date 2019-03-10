#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;global logFile := "../SimuCheckToolSetPro/SimuCheck.log"
global logFile := "SimuCheck.log"

Gui, Add, Edit, w700 h600 vLogbox readonly,
    settimer, GetActivity, 750
    Gui, Show,, SimuCheck - Log Reader
    WinGet Gui_ID, ID, A 
    GuiControl Focus, logbox
    ControlGetFocus logboxclass, ahk_id %Gui_ID% 
Return

GetActivity:
    FileRead, output, %logFile%
    rev := ""
    Loop, Read, %logFile% ; parse each line
    {
        rev = %A_LoopReadLine%`n%rev% ; reverse
    }
    updatelog(rev)
return

updatelog(LogString)
{
    global logboxclass
    global Gui_ID
    GuiControlGet, logbox, , logbox
    guicontrol,,logbox, `n%logstring%
}

GuiClose:
ExitApp
