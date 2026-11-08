import QtQuick
import QtQuick.Layouts

// Credit line. Links open in the browser and close the panel.
RowLayout {
    spacing: 8
    readonly property string link: "<a href=\"%1\" style=\"color:%2; text-decoration:none\">%3</a>"
    function a(url, label) { return link.arg(url).arg(Theme.text).arg(label) }
    function go(url) { Sense.open = false; Qt.openUrlExternally(url) }

    Text {
        Layout.fillWidth: true
        textFormat: Text.RichText
        text: "crafted by " + parent.a("https://d-ap.my.id", "dap_") + " · built with "
              + parent.a("https://github.com/parikesitad-pm/celestial-being", "Celestial Being theme") + " · © " + new Date().getFullYear()
        font.family: Theme.font; font.pixelSize: 11
        color: Theme.subtext
        onLinkActivated: url => parent.go(url)
        HoverHandler { cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor }
    }
    Text {
        textFormat: Text.RichText
        text: "tested on Arch · Nitro AN515-56 · " + parent.a("https://github.com/parikesitad-pm/gn-sense", "source")
        font.family: Theme.font; font.pixelSize: 11
        color: Theme.subtext
        onLinkActivated: url => parent.go(url)
        HoverHandler { cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor }
    }
}
