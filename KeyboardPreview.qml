import QtQuick

// Four-zone keyboard drawn from keycaps, previewing the current effect, colors, speed and brightness.
// Wave and Neon use the keyboard's own color cycle, so the preview shows their motion in white.
Rectangle {
    id: kb
    property bool running: false
    readonly property var cfg: Sense.settings
    readonly property string fx: Sense.effect.k
    property real phase: 0

    implicitHeight: 112
    radius: 16
    color: Qt.rgba(0, 0, 0, 0.45)
    border.width: 1
    border.color: Theme.stroke

    NumberAnimation on phase {
        running: kb.running && kb.fx !== "static" && kb.fx !== "off"
        from: 0; to: 1
        loops: Animation.Infinite
        duration: Math.max(600, 3600 - kb.cfg.speed * 320)
    }

    function zoneColor(i) {
        if (fx === "static") return "#" + Sense.zones[i]
        if (Sense.effect.color === "one") return "#" + cfg.color
        return Theme.text
    }
    // 0..1 light level for zone i at the current phase.
    function level(i) {
        const p = cfg.direction === 1 ? 1 - phase : phase   // 1 = right to left, 2 = left to right
        switch (fx) {
        case "static": return 1
        case "off": return 0
        case "breath":
        case "neon": return 0.5 - 0.5 * Math.cos(2 * Math.PI * phase)
        case "zoom": return Math.max(0, 1 - Math.abs(Math.abs(i - 1.5) / 1.5 - phase) * 2.2)
        default: return Math.max(0, 1 - Math.abs(i + 0.5 - p * 5 + 0.5) / 1.3)   // shift, wave
        }
    }

    // Per frame only the four zone opacities change; the 64 keycaps are static.
    Row {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 6
        Repeater {
            model: 4
            delegate: Item {
                id: zone
                required property int index
                width: (parent.width - 18) / 4
                height: parent.height
                component Caps: Grid {
                    property color cap
                    anchors.fill: parent
                    columns: 4
                    spacing: 4
                    Repeater {
                        model: 16
                        delegate: Rectangle {
                            width: (zone.width - 12) / 4
                            height: (zone.height - 12) / 4
                            radius: 4
                            color: parent.cap
                        }
                    }
                }
                Caps { cap: Qt.rgba(1, 1, 1, 0.05) }
                Caps {
                    cap: kb.zoneColor(zone.index)
                    visible: kb.fx !== "off"
                    opacity: 0.12 + 0.88 * kb.level(zone.index) * kb.cfg.brightness / 100
                }
            }
        }
    }
}
