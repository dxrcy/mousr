#SingleInstance force
#NoEnv
SetWorkingDir %A_ScriptDir%

; Variables
active         := true ; Active on start
; Speed settings
speed_default  := 35   ; Default speed
speed_slow     := 0.2  ; Slow speed multiplier on shifmt key
speed_accel    := 1.5  ; Acceleration amount
speed_min      := 8    ; Minimum speed
speed_max      := 100  ; Maximum speed
speed_duration := 1.5  ; How fast the mouse moves each step
; Spin settings
spin_amount    := 20
spin_size      := 25
spin_duration  := 0.05
; Icon settings (active/inactive icon filepaths)
icon_active    := "image/icon-active.ico"
icon_inactive  := "image/icon-inactive.ico"

speed          := speed_default
SetDefaultMouseSpeed speed_duration
setIcon()

; Keyboard shortcut map
; Change letter after '$' to change hotkey, Do not remove '$'
; Change slow speed shift key by changing '+', Make sure any letter after '+' is capital
; Mouse click shortcuts might not work with shift key
!Insert::ToggleActive()
#If active = true
  ; Mouse move
  $i::MouseUp()
  $+I::MouseUp(true)
  $j::MouseLeft()
  $+J::MouseLeft(true)
  $k::MouseDown()
  $+K::MouseDown(true)
  $l::MouseRight()
  $+L::MouseRight(true)
  ; Mouse click
  $u::ClickLeft()
  $8::ClickMiddle()
  $o::ClickRight()
  ; Mouse click toggle
  $y::ToggleLeft()
  ; Scroll
  $w::ScrollUp()
  $a::ScrollLeft()
  $s::ScrollDown()
  $d::ScrollRight()
  ; Speed
  $v::SpeedDown()
  $+V::SpeedMin()
  $b::SpeedUp()
  $+B::SpeedMax()
  $g::SpeedReset()
  ; Other
  !+Insert::Kill()
  F5::Spin()
#If

; Set icon to active or inactive
SetIcon() {
  global
  If active {
    Menu, Tray, Icon, %icon_active%
  } Else {
    Menu, Tray, Icon, %icon_inactive%
  }
}

; Toggle program
ToggleActive() {
  global
  active := !active
  setIcon()
}
; Kill program
Kill() {
  ExitApp
}

; Mouse move
MouseLeft(isSlow = false) {
  global
  MouseGetPos x, y
  MouseMove x - getSpeed(isSlow), y
}
MouseRight(isSlow = false) {
  global
  MouseGetPos x, y
  MouseMove x + getSpeed(isSlow), y
}
MouseUp(isSlow = false) {
  global
  MouseGetPos x, y
  MouseMove x, y - getSpeed(isSlow)
}
MouseDown(isSlow = false) {
  global
  MouseGetPos x, y
  MouseMove x, y + getSpeed(isSlow)
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

; Toggle mouse click
ToggleLeft() {
  If GetKeyState(LButton) {
    MouseClick Left, , , , , U
  } Else {
    MouseClick Left, , , , , D
  }
}

; Scroll
ScrollLeft() {
  SendInput {WheelLeft}
}
ScrollRight() {
  SendInput {WheelRight}
}
ScrollUp() {
  SendInput {WheelUp}
}
ScrollDown() {
  SendInput {WheelDown}
}

; Speed
SpeedUp() {
  global
  speed *= speed_accel
  speedNormalize()
}
SpeedDown() {
  global
  speed /= speed_accel
  speedNormalize()
}
SpeedMin() {
  global
  speed := speed_min
  speedNormalize()
}
SpeedMax() {
  global
  speed := speed_max
  speedNormalize()
}
SpeedReset() {
  global
  speed := speed_default
  speedNormalize()
}
; Make sure speed is between bounds and integer
SpeedNormalize() {
  global
  speed := Round(Max(speed_min, Min(speed_max, speed)))
}
; Get speed from if shift is pressed
getSpeed(isSlow) {
  global
  If (isSlow) {
    Return Max(1, speed * speed_slow)
  }
  Return Max(1, speed)
}

; Do a little spin :)
Spin() {
  global
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
