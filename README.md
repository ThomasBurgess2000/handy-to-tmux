# handy-to-tmux

Routes [Handy](https://github.com/cjpais/Handy) speech-to-text transcriptions to tmux sessions.

Handy is a local speech-to-text app that saves transcriptions to a SQLite database. This script watches that database and sends new transcriptions to a tmux session via `tmux send-keys`, so you can dictate into a terminal without switching focus.


https://github.com/user-attachments/assets/aab67034-1353-4c91-abfe-ce3354f9262c


## Dependencies

- [Handy](https://github.com/cjpais/Handy)
- tmux
- sqlite3
- xdotool (for the `target` command)

On Ubuntu/Kubuntu with PipeWire, you'll also need:
```bash
sudo apt install pipewire-alsa
```

## Install

```bash
git clone git@github.com:ThomasBurgess2000/handy-to-tmux.git
cd handy-to-tmux
./install.sh
```

This copies the script to `~/.local/bin/handy-to-tmux`.

## Usage

```bash
handy-to-tmux start            # start the watcher in the background
handy-to-tmux stop             # stop the watcher
handy-to-tmux status           # check if running
handy-to-tmux run              # run in foreground (for debugging)
handy-to-tmux target <session> # set target tmux session and start recording
```

Running `handy-to-tmux` with no arguments defaults to `start`.

### Basic setup

1. Create a tmux session:
   ```bash
   tmux new-session -d -s handy
   ```

2. Start the watcher:
   ```bash
   handy-to-tmux start
   ```

3. Press Ctrl+Space (Handy's shortcut) to record, speak, press Ctrl+Space again to stop. The transcription appears in the `handy` tmux session.

### Targeting different sessions

You can route transcriptions to different tmux sessions:

```bash
handy-to-tmux target code   # sets target to "code" and starts recording
handy-to-tmux target chat   # sets target to "chat" and starts recording
```

The target persists until changed. Defaults to `handy` if no target is set.

To use with KDE global shortcuts, bind different key combos to different targets:
- `Ctrl+Alt+1` → `handy-to-tmux target handy`
- `Ctrl+Alt+2` → `handy-to-tmux target code`

Each shortcut starts recording and routes the result to its session. Press Ctrl+Space to stop recording.

## Handy settings

For this to work well, configure Handy with:
- **Push to Talk**: disabled (toggle mode — push-to-talk has issues on KDE Wayland)
- **Paste output**: disabled (so Handy only saves to history, doesn't paste into the focused window)

Settings file: `~/.local/share/com.pais.handy/settings_store.json`

## How it works

Handy saves transcriptions to `~/.local/share/com.pais.handy/history.db`. The watcher polls this database every 300ms for new rows and immediately sends new transcriptions to the target tmux session.

State files:
- `~/.local/state/handy-to-tmux.pid` — pidfile (single-instance enforcement)
- `~/.local/state/handy-to-tmux.log` — log output
- `~/.local/state/handy-to-tmux.target` — current target session name
