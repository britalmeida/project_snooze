# Snooze or Lose

*Game submission for the [PlayJam4](https://itch.io/jam/playjam-4)!*

Theme was: Your Time Is Up

## Running the Game
See intructions in the [project page](https://iralmeida.itch.io/snooze-or-lose) to run the game package in the simulator.

## Dev Setup
**Dowload the PlaydateSDK** to run the simulator and the compiler.  
https://play.date/dev/

**Set the environment variables** (e.g. on `~/.bashrc`):
```
# Playdate
export PLAYDATE_SDK_PATH="$HOME/stuff/PlaydateSDK"
export PATH="$PLAYDATE_SDK_PATH/bin:$PATH"
```

Either manually run the `pdc` compiler and the simulator, or, use VSCode as interface for git, code and launching the simulator.

Install **VSCode extensions**
- Playdate (`Orta.playdate`) - package the game and run in the simulator from the IDE.
- Lua (`sumneko.lua`) - syntax highlighting and language support for Lua.

Open the project folder in VSCode. Press F5.
 