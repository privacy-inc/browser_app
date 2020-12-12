import AppKit

final class Window: NSWindow, NSToolbarDelegate {
    private let search = NSToolbarItem.Identifier("search")
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: NSScreen.main!.frame.width / 2, height: NSScreen.main!.frame.height), styleMask:
            [.borderless, .closable, .miniaturizable, .resizable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView],
                   backing: .buffered, defer: false)
        minSize = .init(width: 400, height: 300)
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.delegate = self
        toolbar!.showsBaselineSeparator = false
        
        toolbar!.insertItem(withItemIdentifier: search, at: 0)
//        toolbar!.centeredItemIdentifier = search
//        toolbar!.validateVisibleItems()
        toolbar!.displayMode = .iconAndLabel
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        setFrameAutosaveName("Window")
    }
    
    override func close() {
        super.close()
        NSApp.terminate(nil)
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar: Bool) -> NSToolbarItem? {
        guard let item = toolbar.items.first(where: { $0.itemIdentifier == itemForItemIdentifier }) else {
            let item = NSToolbarItem(itemIdentifier: itemForItemIdentifier)
            
            item.isEnabled = true
            item.autovalidates = true
            item.visibilityPriority = .high
            item.validate()
            item.toolTip = "ssda"
            item.title = "sda"
            item.label = "fdsdasda"
            item.paletteLabel = "fdffgdfd"
            item.target = self
            item.action = #selector(some)
            item.image = NSImage(named: "ios")
            let search = NSSearchField(frame: .init(x: 0, y: 0, width: 100, height: 100))
            search.controlSize = .large
//            item.view = search
            item.minSize.height = 100
            item.minSize.width = 40
            item.maxSize.height = 1000
            item.maxSize.width = 9000
            return item
        }
        return item
    }
    
    func toolbarAllowedItemIdentifiers(_: NSToolbar) -> [NSToolbarItem.Identifier] {
        []
    }
    
    func toolbarDefaultItemIdentifiers(_: NSToolbar) -> [NSToolbarItem.Identifier] {
        []
    }
    
    @objc private func some() {
        
    }
}
