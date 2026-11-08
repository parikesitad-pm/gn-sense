import QtQuick
import QtQuick.Layouts

// Color for the current effect. Static edits one zone (or all four); Breath, Shifting and Zoom
// take one color. Swatches for the suit colors, a hex field for anything else.
ColumnLayout {
    id: panel
    property int zone: -1   // -1 = all zones
    readonly property bool zoned: Sense.effect.color === "zones"
    readonly property string current: zoned ? Sense.zones[Math.max(0, zone)] : Sense.settings.color
    spacing: 10

    function pick(hex) {
        hex = hex.replace("#", "").toLowerCase()
        if (zoned) Sense.setZone(zone, hex)
        else Sense.set("color", hex)
    }

    RowLayout {
        visible: panel.zoned
        Layout.fillWidth: true
        spacing: 6
        Repeater {
            model: 4
            delegate: Rectangle {
                required property int index
                readonly property bool selected: panel.zone === index || panel.zone === -1
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                radius: 9
                color: "#" + Sense.zones[index]
                border.width: selected ? 2 : 0
                border.color: Theme.text
                Behavior on color { ColorAnimation { duration: 200 } }
                Text {
                    anchors.centerIn: parent
                    text: "Zone " + (index + 1)
                    font.family: Theme.font; font.pixelSize: 10; font.weight: Font.Bold
                    color: "#101624"
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: panel.zone = panel.zone === index ? -1 : index
                }
            }
        }
        Rectangle {
            Layout.preferredWidth: 48
            Layout.preferredHeight: 30
            radius: 9
            color: panel.zone === -1 ? Theme.tileHover : Theme.tile
            Text { anchors.centerIn: parent; text: "All"; font.family: Theme.font; font.pixelSize: 11; color: Theme.text }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: panel.zone = -1 }
        }
    }

    // Swatches and the hex field share one row.
    RowLayout {
        Layout.fillWidth: true
        spacing: 6
        Repeater {
            model: Sense.swatches
            delegate: Rectangle {
                required property string modelData
                readonly property bool active: panel.current === modelData
                Layout.preferredWidth: 26
                Layout.preferredHeight: 26
                radius: 13
                color: "#" + modelData
                border.width: active ? 2 : 0
                border.color: Theme.text
                scale: sw.pressed ? 0.9 : (sw.containsMouse ? 1.12 : 1)
                Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
                MouseArea {
                    id: sw
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: panel.pick(modelData)
                }
            }
        }
        Item { Layout.fillWidth: true }
        Rectangle {
            Layout.preferredWidth: 96; Layout.preferredHeight: 28; radius: 8
            color: Theme.tile
            border.width: 1; border.color: hex.activeFocus ? Theme.gn : Theme.stroke
            Rectangle {
                id: chipColor
                anchors { left: parent.left; leftMargin: 6; verticalCenter: parent.verticalCenter }
                width: 16; height: 16; radius: 4
                color: "#" + panel.current
            }
            TextInput {
                id: hex
                anchors { left: chipColor.right; leftMargin: 6; right: parent.right; rightMargin: 6; top: parent.top; bottom: parent.bottom }
                verticalAlignment: TextInput.AlignVCenter
                text: "#" + panel.current
                font.family: Theme.font; font.pixelSize: 12
                color: Theme.text
                selectByMouse: true
                maximumLength: 7
                validator: RegularExpressionValidator { regularExpression: /#?[0-9a-fA-F]{0,6}/ }
                onAccepted: if (text.replace("#", "").length === 6) panel.pick(text)
            }
        }
    }
}
