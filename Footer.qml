import QtQuick
import QtQuick.Layouts

// Credit lines. Links open in the browser and close the panel.
ColumnLayout {
    id: foot
    spacing: 4
    readonly property string link: "<a href=\"%1\" style=\"color:%2; text-decoration:none\">%3</a>"
    function a(url, label) { return link.arg(url).arg(Theme.text).arg(label) }
    function go(url) { Sense.open = false; Qt.openUrlExternally(url) }

    component Line: Text {
        Layout.fillWidth: true
        textFormat: Text.RichText
        font.family: Theme.font; font.pixelSize: 11
        color: Theme.subtext
        onLinkActivated: url => foot.go(url)
        HoverHandler { cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor }
    }

    RowLayout {
        Layout.fillWidth: true
        Line {
            text: "crafted by " + foot.a("https://d-ap.my.id", "dap_") + " · built with "
                  + foot.a("https://github.com/parikesitad-pm/celestial-being", "Celestial Being theme")
        }
        Line { Layout.fillWidth: false; text: "© " + new Date().getFullYear() }
    }
    Line { text: "tested on Arch · Nitro AN515-56 · " + foot.a("https://github.com/parikesitad-pm/gn-sense", "source") }
}
