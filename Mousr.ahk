#SingleInstance force

; Global variables (from config.ini)
IniRead active, config.ini, SETTINGS_MISC, START
active := active = "false" ? false : true
IniRead speed_default, config.ini, SETTINGS_SPEED, DEFAULT
IniRead speed_slow, config.ini, SETTINGS_SPEED, SLOW
IniRead speed_accel, config.ini, SETTINGS_SPEED, ACCEL
IniRead speed_min, config.ini, SETTINGS_SPEED, MIN
IniRead speed_max, config.ini, SETTINGS_SPEED, MAX
IniRead speed_duration, config.ini, SETTINGS_SPEED, DURATION
IniRead spin_amount, config.ini, SETTINGS_SPIN, AMOUNT
IniRead spin_size, config.ini, SETTINGS_SPIN, SIZE
IniRead spin_duration, config.ini, SETTINGS_SPIN, DURATION
IniRead popup_enabled, config.ini, SETTINGS_POPUP, ENABLED
popup_enabled := popup_enabled = "false" ? false : true
IniRead popup_size, config.ini, SETTINGS_POPUP, SIZE
IniRead popup_duration, config.ini, SETTINGS_POPUP, DURATION
speed := speed_default
SetDefaultMouseSpeed speed_duration
RestoreDPI:=DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr") ; ????

; Map config hotkey names to functions (Do not change formatting)
keyMap := {"MISC.SPIN":        "Spin"
          ,"MISC.KILL":        "Kill"
          ,"MOUSE.UP":         "MouseUp"
          ,"MOUSE.LEFT":       "MouseLeft"
          ,"MOUSE.DOWN":       "MouseDown"
          ,"MOUSE.RIGHT":      "MouseRight"
          ,"MOUSE_SLOW.UP":    "MouseSlowUp"
          ,"MOUSE_SLOW.LEFT":  "MouseSlowLeft"
          ,"MOUSE_SLOW.DOWN":  "MouseSlowDown"
          ,"MOUSE_SLOW.RIGHT": "MouseSlowRight"
          ,"CLICK.LEFT":       "ClickLeft"
          ,"CLICK.HOLD":       "ClickHold"
          ,"CLICK.MIDDLE":     "ClickMiddle"
          ,"CLICK.RIGHT":      "ClickRight"
          ,"SCROLL.UP":        "ScrollUp"
          ,"SCROLL.LEFT":      "ScrollLeft"
          ,"SCROLL.DOWN":      "ScrollDown"
          ,"SCROLL.RIGHT":     "ScrollRight"
          ,"SPEED.DOWN":       "SpeedDown"
          ,"SPEED.MIN":        "SpeedMin"
          ,"SPEED.UP":         "SpeedUp"
          ,"SPEED.MAX":        "SpeedMax"
          ,"SPEED.RESET":      "SpeedReset" }

; Create one hotkey
CreateHotkey(section, name, function)
{
    IniRead key, config.ini, %section%, %name%
    if !key or key = "ERROR" {
        MsgBox Hotkey not defined [%section%] '%name%'
        Return
    }
    Hotkey %key%, %function%, On
}
; Remove one hotkey
RemoveHotkey(section, name)
{
    IniRead key, config.ini, %section%, %name%
    if !key or key = "ERROR" {
        MsgBox Hotkey not defined [%section%] '%name%'
        Return
    }
    try {
        Hotkey %key%, %function%, Off
    }
}

; Create or remove all hotkeys from config.ini
SetHotKeys()
{
    global active
    if active {
        CreateAllHotkeys()
    } else {
        RemoveAllHotkeys()
    }
}
; Create all hotkeys (from config file)
CreateAllHotkeys()
{
    global keyMap
    for k, v in keyMap {
        name := StrSplit(k, ".")
        CreateHotkey(name[1], name[2], v)
    }
}
; Remove all hotkeys (if deactivated)
RemoveAllHotkeys()
{
    global keyMap
    for k, v in keyMap {
        name := StrSplit(k, ".")
        RemoveHotkey(name[1], name[2])
    }
}

; Set icon to active or inactive
SetIcon()
{
    global active
    if active {
        Menu, Tray, Icon, %A_ScriptDir%\src\icon-active.ico
    } else {
        Menu, Tray, Icon, %A_ScriptDir%\src\icon-inactive.ico
    }
}

; Toggle program
Refresh(dontToggle = false)
{
    global active
    if !dontToggle {
        active := !active
    }
    SetIcon()
    SetHotKeys()
    Popup()
}

; Kill program
Kill()
{
    ExitApp
}

; Mouse move
MouseUp()
{
    global speed
    MouseMove 0, -speed, , R
}
MouseLeft()
{
    global speed
    MouseMove -speed, 0, , R
}
MouseDown()
{
    global speed
    MouseMove 0, +speed, , R
}
MouseRight()
{
    global speed
    MouseMove +speed, 0, , R
}

; Mouse move (slow)
MouseSlowUp()
{
    global speed, speed_slow
    MouseMove 0, -Max(1, speed * speed_slow), , R
}
MouseSlowLeft()
{
    global speed, speed_slow
    MouseMove - Max(1, speed * speed_slow), 0, , R
}
MouseSlowDown()
{
    global speed, speed_slow
    MouseMove 0, + Max(1, speed * speed_slow), , R
}
MouseSlowRight()
{
    global speed, speed_slow
    MouseMove + Max(1, speed * speed_slow), 0, , R
}

; Click mouse
ClickLeft()
{
    MouseClick Left
}
ClickMiddle()
{
    MouseClick Middle
}
ClickRight()
{
    MouseClick Right
}
ClickHold()
{
    if GetKeyState(LButton) {
        MouseClick Left, , , , , U
    } else {
        MouseClick Left, , , , , D
    }
}

; Scroll
ScrollUp()
{
    SendInput {WheelUp}
}
ScrollLeft()
{
    SendInput {WheelLeft}
}
ScrollDown()
{
    SendInput {WheelDown}
}
ScrollRight()
{
    SendInput {WheelRight}
}

; Speed
SpeedDown()
{
    global speed, speed_accel
    speed /= speed_accel
    speedNormalize()
}
SpeedMin()
{
    global speed, speed_min
    speed := speed_min
    speedNormalize()
}
SpeedUp()
{
    global speed, speed_accel
    speed *= speed_accel
    speedNormalize()
}
SpeedMax()
{
    global speed, speed_max
    speed := speed_max
    speedNormalize()
}
SpeedReset()
{
    global speed, speed_default
    speed := speed_default
    speedNormalize()
}
; Make sure speed is between bounds and integer
SpeedNormalize()
{
    global speed, speed_min, speed_max
    speed := Round(Max(speed_min, Min(speed_max, speed)))
}

; Do a little spin :)
Spin()
{
    global active, spin_amount, spin_size, spin_duration
    MouseGetPos x, y
    SetDefaultMouseSpeed spin_duration
    
    Loop %spin_amount% {
        i := A_Index
        MouseMove x - Sin(i / spin_amount * 3.14 * 2) * spin_size, y + (Cos(i / spin_amount * 3.14 * 2) - 1) * spin_size
        if !active {
            Return
        }
    }
    
    MouseMove x, y
    SetDefaultMouseSpeed duration
}

; Show popup for current mode
Popup()
{
    global active, popup_size, popup_duration, popup_enabled
    Gui Destroy
    
    if popup_enabled {
        Gui Color, 111111
        icon := active ? "\src\icon-active.ico" : "\src\icon-inactive.ico"
        static MyPicture
        Gui Add, Picture, w%popup_size% h%popup_size% vMyPicture, %A_ScriptDir%%icon%
        Gui +LastFound +AlwaysOnTop +ToolWindow
        WinSet TransColor, 111111
        Gui -Caption
        Gui Show, NoActivate
        
        Sleep %popup_duration%
        Gui Destroy
    }
}

CreateHotkey("MISC", "ACTIVATE", "Refresh")
Refresh(true) ; Refresh state without change active state
