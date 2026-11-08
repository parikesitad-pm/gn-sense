import QtQuick
import QtQuick.Layouts

// Labelled slider over an integer range; reports whole steps only.
RowLayout {
    id: sl
    property string label: ""
    property int from: 0
    property int to: 100
    property int value: 0
    property string suffix: ""
    signal moved(int v)
    spacing: 12

    Text {
        Layout.preferredWidth: 84
        text: sl.label
        font.family: Theme.font; font.pixelSize: 12; color: Theme.subtext
    }
    Item {
        id: track
        Layout.fillWidth: true
        implicitHeight: 24
        readonly property real t: (sl.value - sl.from) / Math.max(1, sl.to - sl.from)
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width; height: 6; radius: 3
            color: Theme.tile
        }
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: knob.x + knob.width / 2; height: 6; radius: 3
            color: Theme.gn
        }
        Rectangle {
            id: knob
            anchors.verticalCenter: parent.verticalCenter
            width: 18; height: 18; radius: 9
            x: track.t * (track.width - width)
            color: Theme.text
            scale: drag.pressed ? 1.15 : 1
            Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
            Behavior on x { enabled: !drag.pressed; NumberAnimation { duration: 200; easing.type: Easing.OutExpo } }
        }
        MouseArea {
            id: drag
            anchors.fill: parent
            anchors.margins: -6
            cursorShape: Qt.PointingHandCursor
            function set(mx) {
                const t = Math.max(0, Math.min(1, (mx - 6 - knob.width / 2) / (track.width - knob.width)))
                const v = Math.round(sl.from + t * (sl.to - sl.from))
                if (v !== sl.value) sl.moved(v)
            }
            onPressed: mouse => set(mouse.x)
            onPositionChanged: mouse => { if (pressed) set(mouse.x) }
        }
    }
    Text {
        Layout.preferredWidth: 44
        horizontalAlignment: Text.AlignRight
        text: sl.value + sl.suffix
        font.family: Theme.font; font.pixelSize: 12; font.weight: Font.DemiBold
        font.features: { "tnum": 1 }
        color: Theme.text
    }
}
