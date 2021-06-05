import AppKit
import Combine

final class Settings: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 420, height: 380),
                   styleMask: [.closable, .miniaturizable, .titled], backing: .buffered, defer: true)
        toolbar = .init()
        titlebarAppearsTransparent = true
        isReleasedWhenClosed = false
        setFrameAutosaveName("Settings")
        title = NSLocalizedString("Settings", comment: "")
        center()
        
        let tab = NSTabView()
        tab.addTabViewItem(General())
        tab.addTabViewItem(General())
        contentView = tab
    }
}
