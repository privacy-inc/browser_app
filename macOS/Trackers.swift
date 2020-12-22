import AppKit

final class Trackers: NSWindow {
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 300, height: 420),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: false)
        toolbar = .init()
        title = NSLocalizedString("Trackers blocked", comment: "")
        titlebarAppearsTransparent = true
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        center()
    }
}
