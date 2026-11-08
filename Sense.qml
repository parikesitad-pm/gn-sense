pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Everything the panel controls: power profile (power-profiles-daemon), keyboard lighting
// (facer module through scripts/rgb.sh), and the lighting linked to each profile.
Singleton {
    id: s
    property bool open: false

    readonly property var profiles: [
        { k: "power-saver", t: "Standby",  sub: "Quiet, longest battery", g: 0xF032A },
        { k: "balanced",    t: "Cruise",   sub: "Everyday balance",       g: 0xF0E8A },
        { k: "performance", t: "Trans-Am", sub: "Full CPU power",         g: 0xF0E7B }
    ]
    // color: "zones" = four zone colors, "one" = a single color, "" = the keyboard picks colors.
    readonly property var effects: [
        { k: "static", t: "Static",   g: 0xF030C, mode: 0, color: "zones", speed: false, dir: false },
        { k: "breath", t: "Breath",   g: 0xF059D, mode: 1, color: "one",   speed: true,  dir: false },
        { k: "shift",  t: "Shifting", g: 0xF078D, mode: 4, color: "one",   speed: true,  dir: true },
        { k: "zoom",   t: "Zoom",     g: 0xF0349, mode: 5, color: "one",   speed: true,  dir: false },
        { k: "wave",   t: "Wave",     g: 0xF0F2E, mode: 3, color: "",      speed: true,  dir: true },
        { k: "neon",   t: "Neon",     g: 0xF0335, mode: 2, color: "",      speed: true,  dir: false },
        { k: "off",    t: "Off",      g: 0xF0425, mode: -1, color: "",     speed: false, dir: false }
    ]
    // Suit colors, Trans-Am red, white.
    readonly property var swatches: ["3b82f6", "2ee6a8", "ff9f1c", "a855f7", "4fc3ff", "ff4d9d",
                                     "ff3b3b", "00e5ff", "ffd23f", "ff7a3d", "ff2e63", "ffffff"]

    // ───────── power profile ─────────
    property string profile: "balanced"
    readonly property var profileInfo: profiles.find(p => p.k === profile) || profiles[1]
    function setProfile(k) { profile = k; run(["powerprofilesctl", "set", k]) }
    Process {
        id: profileRead
        running: true
        command: ["powerprofilesctl", "get"]
        stdout: StdioCollector { onStreamFinished: s.profile = text.trim() || s.profile }
    }
    // Changes made anywhere else arrive as D-Bus property signals.
    Process {
        running: true
        command: ["dbus-monitor", "--system", "type='signal',interface='org.freedesktop.DBus.Properties',path='/net/hadess/PowerProfiles'"]
        stdout: SplitParser { onRead: line => { if (line.includes("ActiveProfile")) profileRead.running = true } }
    }
    onProfileChanged: {
        const link = links[profile]
        if (cfg.follow && link) load(link)
    }

    // ───────── keyboard lighting ─────────
    property bool ready: false   // the facer device is writable
    Process {
        running: true
        command: ["sh", "-c", "[ -w /dev/acer-gkbbl-0 ] && echo yes"]
        stdout: StdioCollector { onStreamFinished: { s.ready = text.trim() === "yes"; if (s.ready && store.loaded) sync.restart() } }
    }
    readonly property var effect: effects.find(e => e.k === cfg.effect) || effects[0]
    readonly property var zones: cfg.zones.split(",")
    readonly property var links: { try { return JSON.parse(cfg.links) } catch (e) { return {} } }

    function lighting() {
        return { effect: cfg.effect, zones: cfg.zones, color: cfg.color, brightness: cfg.brightness,
                 speed: cfg.speed, direction: cfg.direction }
    }
    function load(l) {
        for (const k of ["effect", "zones", "color", "brightness", "speed", "direction"])
            if (l[k] !== undefined) cfg[k] = l[k]
        sync.restart()
    }
    function set(key, value) { cfg[key] = value; sync.restart() }
    // zone -1 paints all four.
    function setZone(zone, hex) {
        const zs = zones.slice()
        if (zone < 0) zs.fill(hex); else zs[zone] = hex
        set("zones", zs.join(","))
    }
    function linkCurrent() {
        const l = Object.assign({}, links)
        l[profile] = lighting()
        cfg.links = JSON.stringify(l)
    }
    function unlinkCurrent() {
        const l = Object.assign({}, links)
        delete l[profile]
        cfg.links = JSON.stringify(l)
    }

    function apply() {
        if (!ready) return
        const e = effect, b = String(cfg.brightness)
        const args = e.k === "off" ? ["off"]
            : e.k === "static" ? ["zones"].concat(zones, [b])
            : ["effect", String(e.mode), String(cfg.speed), b, cfg.color, String(cfg.direction)]
        run([Quickshell.shellDir + "/scripts/rgb.sh"].concat(args))
    }
    Timer { id: sync; interval: 60; onTriggered: s.apply() }
    function run(cmd) { Quickshell.execDetached(cmd) }

    // ───────── settings ─────────
    // 0.2 and older saved to settings.json; move it once so existing lighting and links carry over.
    // The settings file is opened only after this ran, so defaults never overwrite the old file.
    property string storePath: ""
    Process {
        running: true
        command: ["sh", "-c", 'mkdir -p "$1" && cd "$1" && if [ ! -f gn-sense.json ] && [ -f settings.json ]; then mv settings.json gn-sense.json; fi', "sh", Quickshell.stateDir]
        onExited: s.storePath = Quickshell.stateDir + "/gn-sense.json"
    }
    FileView {
        id: store
        path: s.storePath
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        // First run: write the defaults. Every later start restores the saved lighting,
        // since the keyboard forgets its effect on boot.
        onLoaded: if (s.ready) sync.restart()
        onLoadFailed: error => { if (error === FileViewError.FileNotFound) writeAdapter(); if (s.ready) sync.restart() }
        JsonAdapter {
            id: cfg
            property string effect: "wave"
            property string zones: "3b82f6,2ee6a8,ff9f1c,a855f7"
            property string color: "2ee6a8"
            property int brightness: 100
            property int speed: 4
            property int direction: 1
            property bool follow: true
            // "center" (middle of the screen) or "top" (under a top bar or island, topGap px down).
            property string placement: "center"
            property int topGap: 10
            // Lighting per power profile, as JSON. Defaults: Cruise = Wave, Trans-Am = red Breath.
            property string links: '{"balanced":{"effect":"wave","speed":4,"brightness":100},"performance":{"effect":"breath","color":"ff2e63","speed":4,"brightness":100}}'
        }
    }
    readonly property alias settings: cfg
}
