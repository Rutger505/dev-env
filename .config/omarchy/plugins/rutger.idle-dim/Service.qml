import QtQuick
import Quickshell.Io
import Quickshell.Wayland

Item {
  id: root

  property var shell: null
  property bool dimmed: false

  IdleMonitor {
    respectInhibitors: true
    timeout: 270
    onIsIdleChanged: isIdle ? dim.running = true : root.restore()
  }

  function restore() {
    if (!root.dimmed) return
    root.dimmed = false
    undim.running = true
  }

  Process {
    id: dim
    command: ["bash", "-c", "[[ ! -f $HOME/.local/state/omarchy/indicators/stay-awake ]] && brightnessctl -q -d \"$(omarchy-hw-display)\" -s set 10%"]
    onExited: function(exitCode) { root.dimmed = exitCode === 0 }
  }

  Process {
    id: undim
    command: ["bash", "-c", "brightnessctl -q -d \"$(omarchy-hw-display)\" -r"]
  }
}
