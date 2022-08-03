#SingleInstance force

; Global variables (from config.ini)
IniRead temp, config.ini, MISC, START
active := temp = "false" ? false : true
IniRead speed_default,  config.ini, SPEED, DEFAULT
IniRead speed_slow,     config.ini, SPEED, SLOW
IniRead speed_accel,    config.ini, SPEED, ACCEL
IniRead speed_min,      config.ini, SPEED, MIN
IniRead speed_max,      config.ini, SPEED, MAX
IniRead speed_duration, config.ini, SPEED, DURATION
IniRead spin_amount,    config.ini, SPIN, AMOUNT
IniRead spin_size,      config.ini, SPIN, SIZE
IniRead spin_duration,  config.ini, SPIN, DURATION
speed := speed_default
SetDefaultMouseSpeed speed_duration

; Map config hotkey names to functions (Do not change formatting)
keyMap := {"KEYS_MISC.SPIN":        "Spin"
          ,"KEYS_MISC.KILL":        "Kill"
          ,"KEYS_MOUSE.UP":         "MouseUp"
          ,"KEYS_MOUSE.LEFT":       "MouseLeft"
          ,"KEYS_MOUSE.DOWN":       "MouseDown"
          ,"KEYS_MOUSE.RIGHT":      "MouseRight"
          ,"KEYS_MOUSE_SLOW.UP":    "MouseSlowUp"
          ,"KEYS_MOUSE_SLOW.LEFT":  "MouseSlowLeft"
          ,"KEYS_MOUSE_SLOW.DOWN":  "MouseSlowDown"
          ,"KEYS_MOUSE_SLOW.RIGHT": "MouseSlowRight"
          ,"KEYS_CLICK.LEFT":       "ClickLeft"
          ,"KEYS_CLICK.HOLD":       "ClickHold"
          ,"KEYS_CLICK.MIDDLE":     "ClickMiddle"
          ,"KEYS_CLICK.RIGHT":      "ClickRight"
          ,"KEYS_SCROLL.UP":        "ScrollUp"
          ,"KEYS_SCROLL.LEFT":      "ScrollLeft"
          ,"KEYS_SCROLL.DOWN":      "ScrollDown"
          ,"KEYS_SCROLL.RIGHT":     "ScrollRight"
          ,"KEYS_SPEED.DOWN":       "SpeedDown"
          ,"KEYS_SPEED.MIN":        "SpeedMin"
          ,"KEYS_SPEED.UP":         "SpeedUp"
          ,"KEYS_SPEED.MAX":        "SpeedMax"
          ,"KEYS_SPEED.RESET":      "SpeedReset" }

init() { ; Start program (at end of file)
  CreateHotkey("KEYS_MISC", "ACTIVATE", "ToggleActive")
  SetIcon()
  SetHotKeys()
}

; Create one hotkey
CreateHotkey(section, name, function) {
  IniRead key, config.ini, %section%, %name%
  If !key or key = "ERROR" {
    MsgBox Hotkey not defined [%section%] '%name%'
    Return
  }
  Hotkey %key%, %function%, On
}
; Remove one hotkey
RemoveHotkey(section, name) {
  IniRead key, config.ini, %section%, %name%
  If !key or key = "ERROR" {
    MsgBox Hotkey not defined [%section%] '%name%'
    Return
  }
  Hotkey %key%, %function%, Off
}

; Create or remove all hotkeys from config.ini
SetHotKeys() {
  global active
  If active {
    CreateAllHotkeys()
  } else {
    RemoveAllHotkeys()
  }
}
; Create all hotkeys (from config file)
CreateAllHotkeys() {
  global keyMap
  For k, v in keyMap {
    name := StrSplit(k, ".")
    CreateHotkey(name[1], name[2], v)
  }
}
; Remove all hotkeys (if deactivated)
RemoveAllHotkeys() {
  global keyMap
  For k, v in keyMap {
    name := StrSplit(k, ".")
    RemoveHotkey(name[1], name[2])
  }
}

; Set icon to active or inactive
SetIcon() {
  global active
  If active {
    Menu, Tray, Icon, %A_ScriptDir%\src\icon-active.ico
  } Else {
    Menu, Tray, Icon, %A_ScriptDir%\src\icon-inactive.ico
  }
}

; Toggle program
ToggleActive() {
  global active
  active := !active
  SetIcon()
  SetHotKeys()
}

; Kill program
Kill() {
  ExitApp
}

; Mouse move
MouseUp() {
  global speed
  MouseGetPos x, y
  MouseMove x, y - speed
}
MouseLeft() {
  global speed
  MouseGetPos x, y
  MouseMove x - speed, y
}
MouseDown() {
  global speed
  MouseGetPos x, y
  MouseMove x, y + speed
}
MouseRight() {
  global speed
  MouseGetPos x, y
  MouseMove x + speed, y
}

; Mouse move (slow)
MouseSlowUp() {
  global speed, speed_slow
  MouseGetPos x, y
  MouseMove x, y - Max(1, speed * speed_slow)
}
MouseSlowLeft() {
  global speed, speed_slow
  MouseGetPos x, y
  MouseMove x - Max(1, speed * speed_slow), y
}
MouseSlowDown() {
  global speed, speed_slow
  MouseGetPos x, y
  MouseMove x, y + Max(1, speed * speed_slow)
}
MouseSlowRight() {
  global speed, speed_slow
  MouseGetPos x, y
  MouseMove x + Max(1, speed * speed_slow), y
}

; Click mouse
ClickLeft() {
  MouseClick Left
}
ClickMiddle() {
  MouseClick Middle
}
ClickRight() {
  MouseClick Right
}
ClickHold() {
  If GetKeyState(LButton) {
    MouseClick Left, , , , , U
  } Else {
    MouseClick Left, , , , , D
  }
}

; Scroll
ScrollUp() {
  SendInput {WheelUp}
}
ScrollLeft() {
  SendInput {WheelLeft}
}
ScrollDown() {
  SendInput {WheelDown}
}
ScrollRight() {
  SendInput {WheelRight}
}

; Speed
SpeedDown() {
  global speed, speed_accel
  speed /= speed_accel
  speedNormalize()
}
SpeedMin() {
  global speed, speed_min
  speed := speed_min
  speedNormalize()
}
SpeedUp() {
  global speed, speed_accel
  speed *= speed_accel
  speedNormalize()
}
SpeedMax() {
  global speed, speed_max
  speed := speed_max
  speedNormalize()
}
SpeedReset() {
  global speed, speed_default
  speed := speed_default
  speedNormalize()
}
; Make sure speed is between bounds and integer
SpeedNormalize() {
  global speed, speed_min, speed_max
  speed := Round(Max(speed_min, Min(speed_max, speed)))
}

; Do a little spin :)
Spin() {
  global active, spin_amount, spin_size, spin_duration
  MouseGetPos x, y
  SetDefaultMouseSpeed spin_duration

  Loop %spin_amount% {
    i := A_Index
    MouseMove x - Sin(i / spin_amount * 3.14 * 2) * spin_size, y + (Cos(i / spin_amount * 3.14 * 2) - 1) * spin_size
    If !active {
      Return
    }
  }

  MouseMove x, y
  SetDefaultMouseSpeed duration
}

init() ; Start program
