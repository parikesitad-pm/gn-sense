import QtQuick
import QtQuick.Layouts

// The gn-sense controls: power profile, keyboard preview, effects, color, brightness, speed,
// direction, profile links. Panel.qml shows it in its own window; another Quickshell shell can load
// this file directly (see README, "Embed in your shell").
ColumnLayout {
    id: card
    // embedded: hosted inside another shell's panel (for example a top island), which draws its own
    // title, caution tape and frame, so the card leaves those out.
    property bool embedded: false
    // Animations run only while the card is on screen.
    property bool active: Sense.open
    spacing: 14

    RowLayout {
        Layout.fillWidth: true
        visible: !card.embedded
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
    HazardStripe { Layout.fillWidth: true; Layout.preferredHeight: 6; running: card.active; visible: !card.embedded }

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
    KeyboardPreview { Layout.fillWidth: true; running: card.active }
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
