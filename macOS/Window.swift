import AppKit

final class Window: NSWindow, NSToolbarDelegate {
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: NSScreen.main!.frame.width / 2, height: NSScreen.main!.frame.height), styleMask:
            [.borderless, .closable, .miniaturizable, .resizable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView],
                   backing: .buffered, defer: false)
        minSize = .init(width: 400, height: 300)
        titlebarAppearsTransparent = true
        toolbar = .init()
        toolbar!.delegate = self
        toolbar!.insertItem(withItemIdentifier: .init(""), at: 0)
        toolbar!.displayMode = .iconAndLabel
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        setFrameAutosaveName("Window")
    }
    
    override func close() {
        super.close()
        NSApp.terminate(nil)
    }
    
    func toolbar(_: NSToolbar, itemForItemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar: Bool) -> NSToolbarItem? {
        let search = NSSearchField()
        search.translatesAutoresizingMaskIntoConstraints = false
        
        let view = NSView()
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        view.heightAnchor.constraint(equalToConstant: 44).isActive = true
        view.addSubview(search)
        
        search.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        search.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        search.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let item = NSToolbarItem(itemIdentifier: itemForItemIdentifier)
        item.view = view
        return item
    }
    
    func toolbarAllowedItemIdentifiers(_: NSToolbar) -> [NSToolbarItem.Identifier] { [] }
    func toolbarDefaultItemIdentifiers(_: NSToolbar) -> [NSToolbarItem.Identifier] { [] }
}
