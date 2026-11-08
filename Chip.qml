import QtQuick
import QtQuick.Layouts

// Selectable tile: icon over a label, filled with `tint` when selected.
Rectangle {
    id: chip
    property int glyph: 0
    property string label: ""
    property string sub: ""
    property bool selected: false
    property color tint: Theme.gn
    signal clicked()

    implicitHeight: sub === "" ? 58 : 72
    radius: 16
    color: selected ? tint : (area.containsMouse ? Theme.tileHover : Theme.tile)
    border.width: selected ? 0 : 1
    border.color: Theme.stroke
    Behavior on color { ColorAnimation { duration: 180 } }
    scale: area.pressed ? 0.96 : 1
    Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 2
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Theme.g(chip.glyph)
            font.family: Theme.font; font.pixelSize: 18
            color: chip.selected ? Theme.onTint : Theme.text
        }
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: chip.label
            font.family: Theme.font; font.pixelSize: 12; font.weight: Font.Bold
            color: chip.selected ? Theme.onTint : Theme.text
        }
        Text {
            Layout.alignment: Qt.AlignHCenter
            visible: chip.sub !== ""
            text: chip.sub
            font.family: Theme.font; font.pixelSize: 10
            color: chip.selected ? Theme.onTint : Theme.subtext
        }
    }
    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: chip.clicked()
    }
}
