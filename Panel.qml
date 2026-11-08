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

        ColumnLayout {
            id: col
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 20 }
            spacing: 14

            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "GN SENSE"
                    font.family: Theme.font; font.pixelSize: 15; font.weight: Font.ExtraBold; font.letterSpacing: 2
                    color: Theme.gold
                }
                Text {
                    Layout.fillWidth: true
                    text: "// " + Sense.profileInfo.t.toUpperCase()
                    font.family: Theme.font; font.pixelSize: 12; font.weight: Font.Bold; font.letterSpacing: 1
                    color: Sense.profile === "performance" ? Theme.red : Theme.gn
                }
                Rectangle {
                    Layout.preferredWidth: 30; Layout.preferredHeight: 30; radius: 15
                    color: close.containsMouse ? Theme.tileHover : Theme.tile
                    Text { anchors.centerIn: parent; text: Theme.g(0xF0156); font.family: Theme.font; font.pixelSize: 15; color: Theme.text }
                    MouseArea { id: close; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: Sense.open = false }
                }
            }
            HazardStripe { Layout.fillWidth: true; Layout.preferredHeight: 6; running: Sense.open }

            SectionLabel { text: "POWER" }
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                Repeater {
                    model: Sense.profiles
                    delegate: Chip {
                        required property var modelData
                        Layout.fillWidth: true
                        glyph: modelData.g; label: modelData.t; sub: modelData.sub
                        selected: Sense.profile === modelData.k
                        tint: modelData.k === "performance" ? Theme.red : Theme.gn
                        onClicked: Sense.setProfile(modelData.k)
                    }
                }
            }

            SectionLabel { text: Sense.ready ? "KEYBOARD" : "KEYBOARD // DRIVER NOT LOADED" }
            KeyboardPreview { Layout.fillWidth: true; running: Sense.open }
            GridLayout {
                Layout.fillWidth: true
                columns: 7
                columnSpacing: 8
                enabled: Sense.ready
                opacity: Sense.ready ? 1 : 0.5
                Repeater {
                    model: Sense.effects
                    delegate: Chip {
                        required property var modelData
                        Layout.fillWidth: true
                        glyph: modelData.g; label: modelData.t
                        selected: Sense.settings.effect === modelData.k
                        onClicked: Sense.set("effect", modelData.k)
                    }
                }
            }
            // Settings for the chosen effect, grouped in one inset panel.
            Rectangle {
                Layout.fillWidth: true
                visible: Sense.ready && Sense.effect.k !== "off"
                implicitHeight: fx.implicitHeight + 28
                radius: 18
                color: Theme.tile
                ColumnLayout {
                    id: fx
                    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 14 }
                    spacing: 12
                    ColorPanel { Layout.fillWidth: true; visible: Sense.effect.color !== "" }
                    ValueSlider {
                        Layout.fillWidth: true
                        label: "Brightness"; from: 0; to: 100; suffix: "%"
                        value: Sense.settings.brightness
                        onMoved: v => Sense.set("brightness", v)
                    }
                    ValueSlider {
                        Layout.fillWidth: true
                        visible: Sense.effect.speed
                        label: "Speed"; from: 1; to: 9
                        value: Sense.settings.speed
                        onMoved: v => Sense.set("speed", v)
                    }
                    DirectionToggle { Layout.fillWidth: true; visible: Sense.effect.dir }
                }
            }
            ProfileLink { Layout.fillWidth: true; visible: Sense.ready }
            Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Theme.stroke }
            Footer { Layout.fillWidth: true }
        }
    }
}
