import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

// The gn-sense window: a dimmed overlay with the control card in the middle.
// Opens from the keyboard's N key (bin/gn-sense); closes on Esc, the backdrop, or ×.
PanelWindow {
    id: win
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    // 0 = keep out of other panels' reserved space (bars, a top island), so the card centers on
    // the same axis as they do and does not cover them.
    exclusiveZone: 0
    visible: Sense.open || shown > 0.001
    WlrLayershell.namespace: "gn-sense"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: Sense.open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    // 0 closed, 1 open. Enter 260 ms expo-out, exit faster.
    property real shown: Sense.open ? 1 : 0
    Behavior on shown { NumberAnimation { duration: Sense.open ? 260 : 160; easing.type: Sense.open ? Easing.OutExpo : Easing.InCubic } }

    Rectangle {
        anchors.fill: parent
        color: Theme.backdrop
        opacity: win.shown
        MouseArea { anchors.fill: parent; onClicked: Sense.open = false }
    }

    Rectangle {
        id: card
        // placement "top": hangs just under a top bar or island and slides down out of it;
        // "center": middle of the screen.
        readonly property bool atTop: Sense.settings.placement === "top"
        anchors.horizontalCenter: parent.horizontalCenter
        y: atTop ? Sense.settings.topGap - 16 * (1 - win.shown) : (parent.height - height) / 2
        width: 620
        height: col.implicitHeight + 40
        radius: 28
        color: Theme.card
        border.width: 1
        border.color: Sense.profile === "performance" ? Theme.red : Theme.stroke
        Behavior on border.color { ColorAnimation { duration: 300 } }
        opacity: win.shown
        scale: atTop ? 1 : 0.96 + 0.04 * win.shown
        focus: Sense.open
        Keys.onEscapePressed: Sense.open = false
        MouseArea { anchors.fill: parent }   // clicks on the card don't reach the backdrop

        SenseCard {
            id: col
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 20 }
        }
    }
}
