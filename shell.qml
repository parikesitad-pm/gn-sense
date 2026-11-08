import Quickshell
import Quickshell.Io

ShellRoot {
    Panel {}

    // qs -c gn-sense ipc call sense toggle|open|close
    IpcHandler {
        target: "sense"
        function toggle(): void { Sense.open = !Sense.open }
        function open(): void { Sense.open = true }
        function close(): void { Sense.open = false }
    }
}
