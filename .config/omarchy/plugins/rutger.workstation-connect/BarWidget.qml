import QtQuick
import Quickshell.Io
import qs.Ui

BarWidget {
  id: root
  moduleName: "rutger.workstation-connect"

  property string status: "down"
  property string label: ""
  property string tooltip: ""

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  // `workstation-connect waybar` streams one JSON line per state change and keeps running.
  Process {
    id: feed
    command: ["workstation-connect", "waybar"]
    running: true
    stdout: SplitParser {
      onRead: function(line) {
        try {
          const s = JSON.parse(line)
          root.status = s.class
          root.label = s.text
          root.tooltip = s.tooltip
        } catch (e) {}
      }
    }
    onExited: restart.start()
  }

  Timer {
    id: restart
    interval: 5000
    onTriggered: feed.running = true
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.label
    tooltipText: root.tooltip
    active: root.status === "tethered" || root.status === "activating"
    dimmed: root.status === "paused" || root.status === "down" || root.status === "nophone"
    onPressed: function(mouseButton) {
      if (!root.bar) return
      root.bar.run(mouseButton === Qt.RightButton ? "workstation-connect menu" : "workstation-connect toggle")
    }
  }
}
