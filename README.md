# Mousr

A compiled customizable AutoHotKey script to fully control the mouse cursor, clicks, and scrolling with the keyboard!

Releasing full version soon...

Issues, Bugs and Missing Features can be submitted [here](https://github.com/darccyy/mousr/issues/new/choose) 😊

Pronounced /maʊsɚ/

Now written in [AutoHotKey](https://autohotkey.com)!

# How to use

## Installation

1. Download the [latest version](https://github.com/darccyy/mousr/releases/tag/v0.1.2)
2. Extract the zip and move the folder somewhere safe (Do not separate executable from other files)
3. Run `Mousr.exe`
4. Press 'More info' and then 'Run anyway' (If you are worried that it's a virus, the full source code is available for each release)

.It should run automatically.

- [How to change controls](#changing-controls)

## Controls

Shortcuts are only work when the program is active (when tray icon is green), except for `Alt+Insert` (`MISC.ACTIVATE`)

Default controls, listed with config names:

- `F5` spins the cursor in a circle (to test if it is functioning). `MISC.SPIN`
- `Alt+Insert` activates and deactivates the program. `MISC.ACTIVATE`
- - `Shift+Alt+Insert` kills the program. `MISC.KILL`

- `IJKL` moves the cursor (Up, Left, Down, Right). `MOUSE.LEFT`, `MOUSE.UP`, ect.
- - Holding `Shift` slows the speed. `MOUSE_SLOW.LEFT`, `MOUSE_SLOW.UP`, ect.
 
- `U`, `8`, `O` map to the Left, Middle (scroll), and Right clicks respectively. `CLICK.LEFT`, `CLICK.MIDDLE`, `CLICK.RIGHT`, `CLICK.HOLD`

- `WASD` scrolls (Up, Left, Down, Right). `SCROLL.LEFT`, `SCROLL.UP`, ect.

- `V`, `B` increase or decrease speed of cursor. `SPEED.DOWN`, `SPEED.UP`
- - Holding `Shift` sets speed to minimum or maximum. `SPEED.MIN`, `SPEED.MAX`
- `G` resets speed `SPEED.RESET`

### Changing controls

To change hotkeys or settings, **make sure Mousr not running**, and edit `config.ini` in the app directory, then restart Mousr.

# Contributing

Make sure [AutoHotKey](https://www.autohotkey.com/) is installed.

```bash
# Copy repository
git clone https://github.com/darccyy/mousr.git

# Run file
start "C:\Program Files\AutoHotkey\autohotkey.exe" Mousr.ahk

# Compile binaries
powershell -ExecutionPolicy ByPass -File compile.ps1
```

> Created by [darcy](https://github.com/darccyy)

![Icon: Grey mouse graphic](./src/icon.png)

# TODO

- [ ] Create linux, mac binaries
- [ ] Test
- [ ] Survey
