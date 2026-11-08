import QtQuick
import QtQuick.Layouts

// Links the current lighting to the active power profile, so switching profiles switches lighting.
RowLayout {
    id: row
    readonly property bool linked: !!Sense.links[Sense.profile]
    spacing: 10

    Rectangle {
        Layout.preferredWidth: 40; Layout.preferredHeight: 22; radius: 11
        color: Sense.settings.follow ? Theme.gn : Theme.tile
        Behavior on color { ColorAnimation { duration: 160 } }
        Rectangle {
            width: 16; height: 16; radius: 8; y: 3
            x: Sense.settings.follow ? parent.width - width - 3 : 3
            color: Sense.settings.follow ? Theme.onTint : Theme.text
            Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutExpo } }
        }
        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: Sense.settings.follow = !Sense.settings.follow }
    }
    Text {
        Layout.fillWidth: true
        text: Sense.settings.follow ? "Lighting follows the power profile" : "Lighting stays when the profile changes"
        font.family: Theme.font; font.pixelSize: 12; color: Theme.text
        elide: Text.ElideRight
    }
    Rectangle {
        Layout.preferredHeight: 28
        Layout.preferredWidth: linkText.implicitWidth + 24
        radius: 14
        visible: Sense.settings.follow
        color: linkArea.containsMouse ? Theme.tileHover : Theme.tile
        Text {
            id: linkText
            anchors.centerIn: parent
            text: row.linked ? "Update " + Sense.profileInfo.t : "Save to " + Sense.profileInfo.t
            font.family: Theme.font; font.pixelSize: 11; font.weight: Font.DemiBold; color: Theme.text
        }
        MouseArea { id: linkArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: Sense.linkCurrent() }
    }
    Rectangle {
        Layout.preferredWidth: 28; Layout.preferredHeight: 28; radius: 14
        visible: Sense.settings.follow && row.linked
        color: unlinkArea.containsMouse ? Theme.tileHover : Theme.tile
        Text { anchors.centerIn: parent; text: Theme.g(0xF0156); font.family: Theme.font; font.pixelSize: 13; color: Theme.subtext }
        MouseArea { id: unlinkArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: Sense.unlinkCurrent() }
    }
}
