ACTUAL := {} ; holds the state of the buttons / axis
ACTUALACTIVE := {} ; holds the state of the buttons that is clicked currently
WELCOME := "NO"

global KeyboardActive = FALSE
global logFile := "SimuCheck-Log.txt"
global logLife := 30000 ; how long the log will live for in milliseconds

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

assertsTrue(check, against) {
    if (check) == (against) {
        ;MsgBox it is true
    } else {
        MsgBox % "Fatal: the string does NOT match: " check " -> " against
    }
}

writeToLog(message, newLine) {
    Sleep, 10
	if (newLine = 1) {
        FileAppend,`n%message%,%logFile%
    } else {
        FileAppend,%message%,%logFile%
    }    
}

deleteLog() {
	FileDelete,%A_ScriptDir%\%logFile%
}

print(array) {
    if IsArray(array) {
        array := arrayToString(array)
    }
    MsgBox %array%
}
IsArray(obj) {
	return	!!obj.MaxIndex()
}

FireKeyCommandDown(SegData, INDEX, DIR) {
	KEY_DN := getArrayByKey("key_down", SegData)
}

FireKeyCommand(SegData, INDEX, DIR) {

    ;message := " Key(" INDEX "):"
    ;writeToLog(message, 0)

	if (DIR = "INCREASE") {
		KEY_DN := getArrayByKey("key_down", SegData)
    	KEY_MS := getArrayByKey("key_ms", SegData)
    	KEY_UP := getArrayByKey("key_up", SegData)
		KEY_MS_END := getArrayByKey("key_ms_end", SegData)
	} else {
		KEY_DN := getArrayByKey("key_down_de", SegData)
    	KEY_MS := getArrayByKey("key_ms_de", SegData)
    	KEY_UP := getArrayByKey("key_up_de", SegData)
		KEY_MS_END := getArrayByKey("key_ms_end_de", SegData)
	}
    
    if (ACTUALACTIVE = INDEX) {
        writeToLog("ALREADY ", 0)
    } else {
        ; do nothing we already pushed this
        ; message := "PUSH " %KEY_DN%
        ;MsgBox, key %KEY_DN%
        ;Send, % KEY_DN
		SendKey(KEY_DN)
        Sleep % KEY_MS
        ;Send, % KEY_UP
		SendKey(KEY_UP)
		Sleep % KEY_MS_END
    }

    ACTUALACTIVE := INDEX
    ;message := afterACT ACTUALACTIVE
    ;writeToLog(message, 0)
}

leadingZeros(Num) {
    Pack := "000"
    return (SubStr(Pack, 1, StrLen(Pack) - StrLen(Num)) . Num)
}

toNumber(String) {
   Number := ("0" . String) , Number += 0
    return Number
}

getTotalArrayElements(array) {
    count = 0
    For k, v in array {
        count++   
    }
    return count
}

getArrayByKey(keyToCheck, array) {
    For Key, Value in array
    {
        if (Key = keyToCheck) {
            return Value
        }
    }
    return false
}

ReloadScript(JOY, AXIS) {
	GetKeyState, state, %JOY%joy%AXIS%
	if (state = "D") {
		Reload
	}
}
		
PovPushMouseWithKey(JOY, DIR, X_to, Y_to, X_back, Y_back, KEY) {
	global ACTUAL
	; unique number to store the current state
	AXIS := "POV"
	; unique number to store the current state
	INDEX := JOY AXIS DIR

	GetKeyState, state, %JOY%Joy%AXIS%

	act := ACTUAL[INDEX]
	; ToolTip, state %state% actual %act% dir %DIR%

	MouseGetPos, xpos, ypos
	;MsgBox, cursor %xpos% %ypos%

	if (ACTUAL[INDEX] != state) {
		if (DIR = state) {
			; MsgBox, going X %X_to% Y %Y_to% %INDEX%
	
            ;Send, % "{" KEY " down}"
			SendKeyWithDir(KEY, "down")
			sleep 10
            MouseMove, %X_to%, %Y_to%, , R
            sleep 10
			;Send, % "{" KEY " up}"
			SendKeyWithDir(KEY, "up")

			;DllCall("SetCursorPos", int, 500, int, 500) ; place cursor
			
			; Different so let's make the change
			;DllCall("mouse_event", int, 8, int, 0, int, 0)
			;sleep 10
			;DllCall("mouse_event", int, 1, int, X_to, int, Y_to)
			;sleep 10
			;DllCall("mouse_event", int, 0x0010, int, 0, int, 0)
			ACTUAL[INDEX] := state
		} else if (state = -1) {
			; we let go

            ;Send, % "{" KEY " down}"
			SendKeyWithDir(KEY, "down")

            MouseMove, %X_back%, %Y_back%, , R
            ;Send, % "{" KEY " up}"
			SendKeyWithDir(KEY, "up")

			;DllCall("mouse_event", int, 0x0010, int, 0, int, 0)
			ACTUAL[INDEX] := state
		}
	} else {
		; MsgBox, is equal
	}
}

SendKeyWithDir(KEY, DIR) {
	;MsgBox, K is %KeyboardActive%
	if (%KeyboardActive% == TRUE) {
		if (DIR == "down") {
			Send, % "{" KEY " down}"
		} else {
			Send, % "{" KEY " up}"
		}
	} else {
		;MsgBox, % "not active"
	}
}

SendKey(KEY) {
	;MsgBox, K is %KeyboardActive%
	if (%KeyboardActive% == TRUE) {
		if (DIR == "down") {
			Send, % KEY
		} else {
			Send, % KEY
		}
	} else {
		;MsgBox, % KEY
	}
}

PushHoldBtn(JOY, AXIS, DNkey, UPkey) {
	
	GetKeyState, state, %JOY%joy%AXIS%

	;MsgBox, % state

    global ACTUAL
    INDEX := JOY AXIS

    ; ToolTip,Horn %HornJoy% %state%
    if (state == "D") {
			PUSHED := ACTUAL[INDEX]
            if (PUSHED == "PUSHED") {

            } else {
				;SendKeyWithDir(BOTTOM, "down")
				SendKey(DNkey)
             	;Send, % "{" BOTTOM " down}"    
            }
            ACTUAL[INDEX] := "PUSHED"     
    } else {
        ; nothing
        if (ACTUAL[INDEX] = "PUSHED") {
			SendKey(UPkey)
           	ACTUAL[INDEX] := "RELEASED"
        }
    } 
}

PushHoldKeyTopOrBottom(JOY, AXIS, TOP_DN, TOP_UP, BOTTOM_DN, BOTTOM_UP) {
    GetKeyState, state, %JOY%%AXIS%

    global ACTUAL
    INDEX := JOY AXIS

    ; ToolTip,Horn %HornJoy% %state%
    if (state > 65 && state <= 100) {
            if (BOTTOM = "FALSE") {

            } else {
				;SendKeyWithDir(BOTTOM, "down")
				SendKey(BOTTOM_DN)
             	;Send, % "{" BOTTOM " down}"    
            }
            ACTUAL[INDEX] := "LOW"     
    } else if (state >= 21 && state <= 65) {
        ; nothing
        if (ACTUAL[INDEX] = "LOW") {
            if (BOTTOM = "FALSE") {
            } else {
                ;SendKeyWithDir(BOTTOM, "up")
				SendKey(BOTTOM_UP)
				;Send, % "{" BOTTOM " up}"
            }
           ACTUAL[INDEX] := ""
        } else if (ACTUAL[INDEX] = "HIGH") {
            	;SendKeyWithDir(TOP, "up")
				SendKey(TOP_UP)
				;Send, % "{" TOP " up}"
            ACTUAL[INDEX] := ""
        }
    } else if (state >= 0 && state <= 20) {
        	; SendKeyWithDir(TOP, "down")
			SendKey(TOP_DN)
			;Send, % "{" TOP " down}"
        ACTUAL[INDEX] := "HIGH"
    } 
}


PushKeyTopOrBottom(JOY, AXIS, TOP, BOTTOM, MS) {
     GetKeyState, state, %JOY%%AXIS%

    global ACTUAL
    INDEX := JOY AXIS

    ; ToolTip,Horn %HornJoy% %state%
    if (state > 80 && state <= 100) {
            if (BOTTOM = "FALSE") {
                ; this dir is not active
            } else if (ACTUAL[INDEX] = "LOW") {
                ; already pushed it
            } else {
				SendKeyWithDir(BOTTOM, "down")
                ;Send, % "{" BOTTOM " down}"    
                Sleep %MS%
                SendKeyWithDir(BOTTOM, "up")
			    ;Send, % "{" BOTTOM " up}"
            }
            
            ACTUAL[INDEX] := "LOW"     
    } else if (state >= 20 && state <= 80) {
        ; nothing
        if (ACTUAL[INDEX] = "LOW") {
           
           ACTUAL[INDEX] := ""
        } else if (ACTUAL[INDEX] = "HIGH") {
            
            ACTUAL[INDEX] := ""
        }
    } else if (state >= 0 && state <= 29) {
        if (TOP = "FALSE") {
                ; this dir is not active
        } else if (ACTUAL[INDEX] = "HIGH") {
           ;already pushed it
       } else {
            ;Send, % "{" TOP " down}"
			SendKeyWithDir(TOP, "down")
            Sleep %MS%
            ;Send, % "{" TOP " up}"
            SendKeyWithDir(TOP, "up")
			ACTUAL[INDEX] := "HIGH"
       } 
    } 
}

PovPushHoldKey(JOY, DIR, KEYDOWN_START, KEYDOWN_END) {
	;good
	global ACTUAL

	AXIS := "POV"
	; unique number to store the current state
	INDEX := JOY AXIS DIR
	
	GetKeyState, state, %JOY%Joy%AXIS%

	;if a direction let's run the sequence and then erase the 
	;if actual different then state make the change
	if (ACTUAL[INDEX] != state) {

		if (DIR = state) {
			; Different so let's make the change
			;Send, % KEYDOWN_START
			SendKey(KEYDOWN_START)

			ACTUAL[INDEX] := state
		} else if (state = -1) {
			; we let go
			;Send, % KEYDOWN_END
			SendKey(KEYDOWN_END)

			ACTUAL[INDEX] := state
		}
		
	} else {
		; MsgBox, is equal
	}

	act := ACTUAL[INDEX]
	; ToolTip, POV Look %state% actual %act% keydown %KEYDOWN% keyup %KEYUP%
	
	; var := ACTUAL[INDEX]
	; var := ACTUAL[48]
	; MsgBox %var%
}

PovPushKeyReleaseAnotherKey(JOY, DIR, KEYDOWN_START, KEYDOWN_MS, KEYDOWN_END, KEY_UP_START, KEY_UP_MS, KEY_UP_END) {
	;good
	global ACTUAL

	AXIS := "POV"
	; unique number to store the current state
	INDEX := JOY AXIS DIR
	GetKeyState, state, %JOY%Joy%AXIS%

	;if a direction let's run the sequence and then erase the 
	;if actual different then state make the change
	if (ACTUAL[INDEX] != state) {

		if (DIR = state) {
			; Different so let's make the change
			;Send, % KEYDOWN_START
			SendKey(KEYDOWN_START)

			Sleep KEYDOWN_MS
			;Send, % KEYDOWN_END
			SendKey(KEYDOWN_END)

			ACTUAL[INDEX] := state
		} else if (state = -1) {
			; we let go
			;Send, % KEY_UP_START
			SendKey(KEY_UP_START)

			Sleep KEY_UP_MS
			;Send, % KEY_UP_END
			SendKey(KEY_UP_END)

			ACTUAL[INDEX] := state
		}
		
	} else {
		; MsgBox, is equal
	}

	act := ACTUAL[INDEX]
	; ToolTip, POV Look %state% actual %act% keydown %KEYDOWN% keyup %KEYUP%
	
	; var := ACTUAL[INDEX]
	; var := ACTUAL[48]
	; MsgBox %var%
}

PovPushMouseScroll(JOY, DIR, Scroll, ScrollBack) {

	global ACTUAL
	; unique number to store the current state
	AXIS := "POV"
	; unique number to store the current state
	INDEX := JOY AXIS DIR
	
	GetKeyState, state, %JOY%Joy%AXIS%

	act := ACTUAL[INDEX]
	; ToolTip, state %state% actual %act% dir %DIR%


	;MouseGetPos, xpos, ypos
	; MsgBox, cursor %xpos% %ypos%

	if (ACTUAL[INDEX] != state) {
		if (DIR = state) {
			; MsgBox, going X %X_to% Y %Y_to% %INDEX%
	
            Send, {WheelUp 5}

			ACTUAL[INDEX] := state
		} else if (state = -1) {
			; we let go

            Send, {WheelDown 5}

			;DllCall("mouse_event", int, 0x0010, int, 0, int, 0)
			ACTUAL[INDEX] := state
		} else {
            ;MsgBox, state %state%
        }
		
	} else {
		; MsgBox, is equal
	}

}

PovPushMouseWithRightBtn(JOY, DIR, X_to, Y_to, X_back, Y_back) {
	global ACTUAL
	; unique number to store the current state
	AXIS := "POV"
	; unique number to store the current state
	INDEX := JOY AXIS DIR

	GetKeyState, state, %JOY%Joy%AXIS%

	act := ACTUAL[INDEX]
	; ToolTip, state %state% actual %act% dir %DIR%

	

	MouseGetPos, xpos, ypos
	;MsgBox, cursor %xpos% %ypos%

	if (ACTUAL[INDEX] != state) {
		if (DIR = state) {
			; MsgBox, going X %X_to% Y %Y_to% %INDEX%
	
            Send, {RButton Down}
            MouseMove, %X_to%, %Y_to%, , R
            Send, {RButton Up}

			;DllCall("SetCursorPos", int, 500, int, 500) ; place cursor
			
			; Different so let's make the change
			;DllCall("mouse_event", int, 8, int, 0, int, 0)
			;sleep 10
			;DllCall("mouse_event", int, 1, int, X_to, int, Y_to)
			;sleep 10
			;DllCall("mouse_event", int, 0x0010, int, 0, int, 0)
			ACTUAL[INDEX] := state
		} else if (state = -1) {
			; we let go

            Send, {RButton Down}
            MouseMove, %X_back%, %Y_back%, , R
            Send, {RButton Up}

			;DllCall("mouse_event", int, 0x0010, int, 0, int, 0)
			ACTUAL[INDEX] := state
		}
		
	} else {
		; MsgBox, is equal
	}

}

PovPushMouse(JOY, DIR, X_to, Y_to, X_back, Y_back) {
	global ACTUAL
	; unique number to store the current state
	AXIS := "POV"
	; unique number to store the current state
	INDEX := JOY AXIS DIR

	GetKeyState, state, %JOY%Joy%AXIS%

	act := ACTUAL[INDEX]
	; ToolTip, state %state% actual %act% dir %DIR%

	if (ACTUAL[INDEX] != state) {
		if (DIR = state) {
			; Different so let's make the change
			DllCall("mouse_event", int, 1, int, X_to, int, Y_to)
			ACTUAL[INDEX] := state
		} else if (state = -1) {
			; we let go
			DllCall("mouse_event", int, 1, int, X_back, int, Y_back)
			ACTUAL[INDEX] := state
		}
		
	} else {
		; MsgBox, is equal
	}

}

moveMouse(X_to, Y_to) {
	;DllCall("SetCursorPos", int, 0, int, 0) ; place cursor
	;DllCall("mouse_event", int, 0x0001, int, X_to, int, Y_to)
	if (%KeyboardActive% == TRUE) {
		DllCall("mouse_event", int, 0x0001, int, X_to, int, Y_to)
		Sleep, 500
	} else {
		;MsgBox, % "not active"
	}	
}

PushMouse(JOY, AXIS, X_to, Y_to, X_back, Y_back) {
	global ACTUAL
	; unique number to store the current state
	INDEX := JOY AXIS
	act := ACTUAL[INDEX]

	GetKeyState, state, %JOY%joy%AXIS%
	; ToolTip, state %state% actual %ACTUAL% x %X_to% y %Y_to% backX %X_to% backy %Y_to%
	if (ACTUAL[INDEX] != state) {
		; Different so let's make the change
		if (state = "D") {
			; MsgBox, 
			Send, {RButton Down}
			Sleep, 100
			moveMouse(X_to, Y_to)
            ;MouseMove, %X_to%, %Y_to%, , R
			;DllCall("mouse_event", int, 0x0001, int, X_to, int, Y_to)
            Send, {RButton Up}

			message := "Button-Mouse index:" INDEX " PUSHED " 
            writeToLog(message, 1)

			ACTUAL[INDEX] := state
		} else if (state = "U") {
			; MsgBox, 
			Send, {RButton Down}
			Sleep, 100
			moveMouse(X_back, Y_back)
            ;MouseMove, %X_back%, %Y_back%, , R
			;.
			;DllCall("mouse_event", int, 0x0001, int, X_back, int, Y_back)
            Send, {RButton Up}

			message := "Button-Mouse index:" INDEX " RELEASED " 
            writeToLog(message, 1)
            
			ACTUAL[INDEX] := state
		}
		sleep 10
		
	} else {
		; MsgBox, is equal
	}
}



; how to call a push to activate a key and then when release anothe key
PushKeyReleaseAnotherKey(JOY, AXIS, KEYDOWN_START, KEYDOWN_MS, KEYDOWN_END, KEY_UP_START, KEY_UP_MS, KEY_UP_END) {
	;good
	global ACTUAL

	; unique number to store the current state
	INDEX := JOY AXIS

	GetKeyState, state, %JOY%joy%AXIS%
	
	; ToolTip, Look %state% actual %ACTUAL% keydown %KEYDOWN% keyup %KEYUP%

	;if a direction let's run the sequence and then erase the 
	;if actual different then state make the change
	if (ACTUAL[INDEX] != state) {
		; Different so let's make the change
		if (state = "D") {
			; MsgBox, Going forward
			;Send, % KEYDOWN_START
			SendKey(KEYDOWN_START)

			Sleep % KEYDOWN_MS
			;Send, % KEYDOWN_END
			SendKey(KEYDOWN_END)

			ACTUAL[INDEX] := state

			message := "Button-KeyWithAnother index:" INDEX " PUSHED " 
            writeToLog(message, 1)

		} else if (state = "U") {
			; MsgBox, Going neutral
			;Send, % KEY_UP_START
			SendKey(KEY_UP_START)

			Sleep % KEY_UP_MS
			;Send, % KEY_UP_END
			SendKey(KEY_UP_END)

			ACTUAL[INDEX] := state

			message := "Button-KeyWithAnother index:" INDEX " RELEASED " 
            writeToLog(message, 1)

		}
		
	} else {
		; MsgBox, is equal
	}
	; var := ACTUAL[INDEX]
	; var := ACTUAL[48]
	; MsgBox %var%
}

; how to call a push to activate a key and then when release anothe key
PushKey(JOY, AXIS, KEYDOWN_START, KEYDOWN_MS, KEYDOWN_END) {
	;good
	global ACTUAL

	; unique number to store the current state
	INDEX := JOY AXIS

	GetKeyState, state, %JOY%joy%AXIS%
	
	; ToolTip, Look %state% actual %ACTUAL% keydown %KEYDOWN% keyup %KEYUP%

	;if a direction let's run the sequence and then erase the 
	;if actual different then state make the change
	if (ACTUAL[INDEX] != state) {
		; Different so let's make the change
		if (state = "D") {
			; MsgBox, Going forward
			;Send, % KEYDOWN_START
			SendKey(KEYDOWN_START)

			Sleep % KEYDOWN_MS
			;Send, % KEYDOWN_END
			SendKey(KEYDOWN_END)

			ACTUAL[INDEX] := state
		} else if (state = "U") {
			; MsgBox, Going neutral
			ACTUAL[INDEX] := state
		}
		
	} else {
		; MsgBox, is equal
	}
}

AxisToKey(JOY, AXIS, NOTCHES, KEYUP_START, KEYUP_MS, KEYUP_END, KEYUP_SLEEP_AFTER, KEYDOWN_START, KEYDOWN_MS, KEYDOWN_END, KEYDOWN_SLEEP_AFTER, DEBUG = FALSE) {

	global ACTUAL

	;MsgBox, debug %DEBUG%

	act := ACTUAL[INDEX]

	INDEX := JOY AXIS

	EACH_NOTCH := Round(100 / NOTCHES, 2)
	; GetKeyState, state, %JOY%JoyZ
	GetKeyState, state, %JOY%%AXIS%

	CURR_NOTCH := 0
	Loop, %NOTCHES%
	{
		bottom := (A_Index - 1) * EACH_NOTCH

		top := (A_Index + 1) * EACH_NOTCH
		if ((state >= bottom) && (state <= top)) {
			CURR_NOTCH := (A_Index - 1)
		} else {	
			
		}

        if (DEBUG = "1") {
	        Tooltip, currently %state% notches %NOTCHES% currNotch %CURR_NOTCH% notch %EACH_NOTCH% %bottom% - %top%  act %act% curr %CURR_NOTCH%
            Sleep, 500
        }
	    
		

	}

	; first time assign default
	if (ACTUAL[INDEX] = "") {
		ACTUAL[INDEX] := "1"
		;act := ACTUAL[INDEX]
		;MsgBox, setting %act%
	} 
	; MsgBox state is in %CURR_NOTCH%

	; ; if a direction let's run the sequence and then erase the 
	; ; if actual different then state make the change
	if (ACTUAL[INDEX] != CURR_NOTCH) {

		; MsgBox, NOT equal

		if (ACTUAL[INDEX] < CURR_NOTCH) {
			COUNT := 0
			; MsgBox, Increase
			Loop { ; increase throttle
				
					;Send, % KEYUP_START
					SendKey(KEYUP_START)

					Sleep %KEYUP_MS%
					;Send, % KEYUP_END
					SendKey(KEYUP_END)

					Sleep %KEYUP_SLEEP_AFTER%
				
					act := ACTUAL[INDEX]
					; MsgBox, %act%
					ACTUAL[INDEX] := act + 1 ; increase a notch

					; MsgBox, Increase  act %act% curr %CURR_NOTCH%
				if (ACTUAL[INDEX] = CURR_NOTCH) {
					Break
				}
				COUNT := COUNT + 1
				if (COUNT > NOTCHES) {
					Break
				}

			}
		} else if (ACTUAL[INDEX] > CURR_NOTCH) {
			; decrease throttle
			COUNT := 0
			; MsgBox, Decrease
			Loop { ; increase throttle

					;Send, % KEYDOWN_START
					SendKey(KEYDOWN_START)

					Sleep %KEYDOWN_MS%
					;Send, % KEYDOWN_END
					SendKey(KEYDOWN_END)

					Sleep %KEYDOWN_SLEEP_AFTER%
				
				ACTUAL[INDEX] := ACTUAL[INDEX] - 1 ; increase a notch
				; MsgBox, Decrease A %ThrottleActual% S %ThrottleState%
				if (ACTUAL[INDEX] = CURR_NOTCH) {
					Break
				}

				COUNT := COUNT + 1
				if (COUNT > NOTCHES) {
					Break
				}
			}
		} else {
			
		}
	} else {
		; Else nothing
		; MsgBox, equal
	}

	act := ACTUAL[INDEX]
    ;ToolTip, currently %state% notches %NOTCHES% not %NOTCH% %bottom% - %top% ACTUAL %act%
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; content below is a separate library and the content above extends this content below
ReverseArray(oArray)
{
	oArray2 := oArray.Clone()
	oTemp := {}
	for vKey in oArray
		oTemp.Push(vKey)
	vIndex := oTemp.Length()
	for vKey in oArray
		oArray[vKey] := oArray2[oTemp[vIndex--]]
	oArray2 := oTemp := ""

    return oArray2
}
implode(sep, array) {
	str := ""
	For k, v in array {
		str = %str%%v%%sep%
	}
	trim := ""
	StringTrimRight, trim, str, 1
	return %trim%
}

explode(sep, input) {
    array := Object()
    loop, parse, input, %sep%
    {
    ;   echo $item;
    array.Push(A_LoopField)
        ;msgbox, %A_LoopField%
    }
    return %array%
}
arrayToString(theArray)
{   string := "{"
    for key, value in theArray
    {   if(A_index != 1)
        {   string .= ","
        }
        if key is number
        {   string .= key ":"
        } else if(IsObject(key))
        {   string .= arrayToString(key) ":"
        } else
        {   key := escapeSpecialChars(key)
            string .=  """" key """:" 
        }
        if value is number
        {   string .= value
        } else if (IsObject(value))
        {   string .= arrayToString(value)
        } else
        {   value := escapeSpecialChars(value)
            string .=  """" value """"
        }
    }
    return string "}"
}

escapeSpecialChars(theString, reverse := false)
{   unEscaped := ["""", "``", "`r", "`n", ",", "%", ";", "::", "`b", "`t", "`v", "`a", "`f"]
    escaped := ["""""", "````", "``r", "``n", "``,", "``%", "``;", "``::", "``b", "``t", "``v", "``a", "``f"]
    
    search := reverse ? escaped : unEscaped
    replace := reverse ? unEscaped : escaped
    
    for index, s in search
    {   StringReplace, theString, theString, % s, % replace[index], All
    }
    return theString
}

stringToArray(theString)
{   
    if(theString == "{}")
    {
        return {}
    }
    if(RegExMatch(theString, "\R") || instr(theString, "{") != 1 || instr(theString, "}", true, 0) != strlen(theString))
    {   return false
    }
    returnArray := object()
    start := 2
    Loop
    {   valueString := getNextValue(theString, start) 
        if(valueString == false)
        {   ;invalid value for key
            break
        }
        key := valueString[1]
        start := valueString[2]
        if(RegExMatch(theString, "\s*:", "", start) != start++)
        {   ;no ':' after key
            break
        }
        valueString := getNextValue(theString, start)
         if(valueString == false)
        {   ;invalid value for value
            break
        }
        value := valueString[1]
        start := valueString[2] 
        returnArray.insert(key, value)
        if(RegExMatch(theString, "\s*}", "", start) == start)
        {   ;closing brace indiacates end of the object
            return returnArray
        } else
        {   start := InStr(theString, ",", true, start)
            if(start == 0)
            {   ;no closing brace or comma before the next var
                break
            }
            start++
        }
    }
    return false
}

getNextValue(ByRef string, start)
{   if(RegExMatch(string, "\s*[+-]{0,1}[\d\.]", "", start) == start)
    {   ;it's a number
        start := RegExMatch(string, "[+-]{0,1}[\d\.]", "", start)
        end := regexmatch(string, "[^\d\.+-]", value, start)
        return [substr(string, start, end - start), end]
    }
    if(RegExMatch(string, "\s*""", "", start) == start)
    {   ;it is a string
        check := start := RegExMatch(string, """", "", start) + 1
        Loop
        {   ;find the next "
            end := InStr(string, """", true, check)
            ;check if the " found is actually an escaped " (ie "")
            if(end == instr(string, """""", true, check))
            {   ;indicates an escaped "
                check := end + 2
            } else
            {   break
            }
        }
        return [escapeSpecialChars(substr(string, start, end - start), reverse := true), end + 1]
    }
    if(RegExMatch(string, "\s*\{", "", start) == start)
    {   
        ;it is another object!
        if(RegExMatch(string, "}", "", start) == start +1)
        {
            ;the other object is an emtpy object
            return [{}, start + 2]
        }
        start := instr(string, "{", true, start)
        end := start + 1
        ;if we find an { then we need to find an additional }
        braceCount := 0
        ;braces within "'s are ignored
        ignoreBraces := false
        ;find the closing brace
        while(end := RegExMatch(string, "[""\{}]", found, end))
        {   if(found == """")
            {   ignoreBraces := ! ignoreBraces
            } else if(found == "{")
            {   braceCount++
            } else if(found == "}" && ignoreBraces == false)
            {   if(braceCount == 0)
                {   break
                }
                braceCount--
            }
            end++
        }
        if(end == 0)
        {   MsgBox end is 0
            return false
        }
        ;MsgBox % substr(string, start, end - start + 1)
        value := stringToArray(substr(string, start, end - start + 1))
        if(value)
        {   return [value , end + 1 ]
        }
    }
    MsgBox didn't start with a good value
    return false
}

JoyStickCheck(JoystickNumber) {
	
	GetKeyState, joy_buttons, %JoystickNumber%JoyButtons
	GetKeyState, joy_name, %JoystickNumber%JoyName
	GetKeyState, joy_info, %JoystickNumber%JoyInfo

	buttonStatus := ""

    Loop, 20 {
		buttons_down = 
    Loop, %joy_buttons%
    {
        ;Tooltip, %JoystickNumber%joy%A_Index%
		GetKeyState, joy%A_Index%, %JoystickNumber%joy%A_Index%
        if joy%A_Index% = D
			buttons_down = %buttons_down%%A_Space%%A_Index%
    }
    GetKeyState, JoyX, %JoystickNumber%JoyX
    axis_info = X%JoyX%
    GetKeyState, JoyY, %JoystickNumber%JoyY
    axis_info = %axis_info%%A_Space%%A_Space%Y%JoyY%
    IfInString, joy_info, Z
    {
        GetKeyState, JoyZ, %JoystickNumber%JoyZ
        axis_info = %axis_info%%A_Space%%A_Space%Z%JoyZ%
    }
    IfInString, joy_info, R
    {
        GetKeyState, JoyR, %JoystickNumber%JoyR
        axis_info = %axis_info%%A_Space%%A_Space%R%JoyR%
    }
    IfInString, joy_info, U
    {
        GetKeyState, JoyU, %JoystickNumber%JoyU
        axis_info = %axis_info%%A_Space%%A_Space%U%JoyU%
    }
    IfInString, joy_info, V
    {
        GetKeyState, JoyV, %JoystickNumber%JoyV
        axis_info = %axis_info%%A_Space%%A_Space%V%JoyV%
    }
    IfInString, joy_info, P
    {
        GetKeyState, joyp, %JoystickNumber%JoyPOV
        axis_info = %axis_info%%A_Space%%A_Space%POV%joyp%
    }

	message = %joy_name% (#%JoystickNumber%)
	messageAxis =  %axis_info%
	messageButtons =  %buttons_down%
	;MsgBox, %message%

	GuiControl,,JOYNAME,% "Joy " . message
	GuiControl,,JOYAXIS,% "Axis " . messageAxis
	GuiControl,,JOYBUTTONS,% "Buttons " . messageButtons

    }
}
