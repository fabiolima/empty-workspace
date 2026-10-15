# Empty Workspace

Jumps to the first workspace with no windows. If every workspace from 1 up
is occupied, it opens the next one (Hyprland creates it on demand).

## Install

1. Enable it: `omarchy plugin enable empty-workspace`
2. Bind a key in `~/.config/hypr/bindings.lua`:

   ```lua
   o.bind("SUPER + N", "Go to empty workspace", "omarchy-shell empty-workspace go")
   ```
