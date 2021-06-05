import AppKit
import Combine

final class Store: NSWindow {
    private var subscription: AnyCancellable?
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 400, height: 600),
                   styleMask: [.closable, .miniaturizable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        toolbar = .init()
        isReleasedWhenClosed = false
        setFrameAutosaveName("Store")
        title = NSLocalizedString("Privacy Plus", comment: "")
        titlebarAppearsTransparent = true
        center()
        
//        let bar = NSTitlebarAccessoryViewController()
//        bar.view = Title()
//        bar.layoutAttribute = .top
//        addTitlebarAccessoryViewController(bar)
        
    }
}
