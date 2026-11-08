pragma Singleton
import QtQuick
import Quickshell

// GN look: dark cockpit glass, GN green, Celestial Being gold, Trans-Am red. No rainbow.
Singleton {
    readonly property color backdrop: Qt.rgba(0, 0, 0, 0.40)
    readonly property color card:     Qt.rgba(0.03, 0.05, 0.09, 0.94)
    readonly property color stroke:   Qt.rgba(1, 1, 1, 0.12)
    readonly property color tile:     Qt.rgba(1, 1, 1, 0.06)
    readonly property color tileHover: Qt.rgba(1, 1, 1, 0.12)
    readonly property color text:     "#f2f6ff"
    readonly property color subtext:  "#a7b3cc"
    readonly property color gn:       "#2ee6a8"
    readonly property color gold:     "#f2b705"
    readonly property color red:      "#ff2e63"
    readonly property color onTint:   "#04120d"

    readonly property string font: "JetBrainsMono Nerd Font"
    function g(cp) { return String.fromCodePoint(cp) }
}
