import QtQuick
import Quickshell.Io

// Empty Workspace — focuses the lowest-numbered workspace that has no windows.
//
// Hyprland destroys empty, non-persistent workspaces as soon as you leave
// them, so an "empty workspace" is usually a gap in the numbering (1, 2, 4 ->
// 3 is empty) rather than a listed workspace with zero windows. Both count.
// When workspaces 1..N are all occupied, N + 1 is focused, which Hyprland
// creates on demand. Special (scratchpad) and named workspaces have
// non-positive ids and are ignored.
Item {
  id: root

  property var shell: null

  function go() {
    if (!queryProc.running) queryProc.running = true
  }

  function firstEmpty(workspaces) {
    var windowsById = {}
    for (var i = 0; i < workspaces.length; i++) {
      var ws = workspaces[i]
      if (ws.id > 0) windowsById[ws.id] = ws.windows
    }
    var id = 1
    while (windowsById[id] > 0) id++
    return id
  }

  Process {
    id: queryProc
    command: ["hyprctl", "-j", "workspaces"]
    stdout: StdioCollector {
      onStreamFinished: {
        var workspaces
        try { workspaces = JSON.parse(text) } catch (e) { return }
        var id = root.firstEmpty(workspaces)
        focusProc.command = ["hyprctl", "dispatch",
          'hl.dsp.focus({ workspace = "' + id + '" })']
        focusProc.running = true
      }
    }
  }

  Process { id: focusProc }

  IpcHandler {
    target: "empty-workspace"

    function go(): void { root.go() }
  }
}
