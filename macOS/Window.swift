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
        let a = NSTitlebarAccessoryViewController()
//        a.automaticallyAdjustsSize = false
        a.layoutAttribute = .top
        
        a.view = NSSearchField(frame: .init(x: 0, y: 0, width: 200, height: 30))
        
        addTitlebarAccessoryViewController(a)
        
//        let search = NSSearchField()
//        search.translatesAutoresizingMaskIntoConstraints = false
//
//        contentView!.addSubview(search)
        
//        search.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 20).isActive = true
//        search.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 100).isActive = true
//        search.rightAnchor.constraint(equalTo: contentView!.rightAnchor, constant: -20).isActive = true
    }
    
    override func close() {
        super.close()
        NSApp.terminate(nil)
    }
}
