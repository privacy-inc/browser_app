import AppKit

final class Window: NSWindow {
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: NSScreen.main!.frame.width / 2, height: NSScreen.main!.frame.height), styleMask:
                    [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView],
                   backing: .buffered, defer: false)
        minSize = .init(width: 400, height: 300)
        toolbar = .init()
        titlebarAppearsTransparent = true
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        setFrameAutosaveName("Window")
        
        let searchbar = NSTitlebarAccessoryViewController()
        searchbar.view = Searchbar()
        searchbar.layoutAttribute = .top
        addTitlebarAccessoryViewController(searchbar)
    }
    
    override func close() {
        super.close()
        NSApp.terminate(nil)
    }
}
