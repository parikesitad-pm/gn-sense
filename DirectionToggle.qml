import QtQuick
import QtQuick.Layouts

// Animation direction for Wave and Shifting. facer: 1 = right to left, 2 = left to right.
RowLayout {
    id: row
    spacing: 12

    Text {
        Layout.preferredWidth: 84
        text: "Direction"
        font.family: Theme.font; font.pixelSize: 12; color: Theme.subtext
    }
    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 32
        radius: 16
        color: Theme.tile

        // One highlight that slides to the chosen side.
        Rectangle {
            width: parent.width / 2 - 4; height: parent.height - 6; radius: height / 2
            y: 3
            x: Sense.settings.direction === 2 ? parent.width / 2 + 1 : 3
            color: Theme.gn
            Behavior on x { NumberAnimation { duration: 220; easing.type: Easing.OutExpo } }
        }
        Row {
            anchors.fill: parent
            Repeater {
                model: [{ v: 1, t: Theme.g(0xF004D) + "  Right to left" }, { v: 2, t: "Left to right  " + Theme.g(0xF0054) }]
                delegate: Item {
                    required property var modelData
                    width: parent.width / 2; height: parent.height
                    Text {
                        anchors.centerIn: parent
                        text: modelData.t
                        font.family: Theme.font; font.pixelSize: 12; font.weight: Font.DemiBold
                        color: Sense.settings.direction === modelData.v ? Theme.onTint : Theme.text
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Sense.set("direction", modelData.v)
                    }
                }
            }
        }
    }
}
