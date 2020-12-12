import AppKit

final class Window: NSWindow, NSToolbarDelegate {
    private let search = NSToolbarItem.Identifier("search")
    private weak var s: NSView?
    
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
//        toolbar!.displayMode = .labelOnly
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        setFrameAutosaveName("Window")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.s!.heightAnchor.constraint(equalToConstant: 200).isActive = true
//            self.s!.layer!.backgroundColor = NSColor.green.cgColor
//            self.s!.superview!.heightAnchor.constraint(equalToConstant: 200).isActive = true
        }
    }
    
    override func close() {
        super.close()
        NSApp.terminate(nil)
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar: Bool) -> NSToolbarItem? {
        guard let item = toolbar.items.first(where: { $0.itemIdentifier == itemForItemIdentifier }) else {
            let item = NSToolbarItem(itemIdentifier: itemForItemIdentifier)
            
//            item.isEnabled = true
//            item.autovalidates = true
//            item.visibilityPriority = .high
//            item.validate()
//            item.toolTip = "ssda"
//            item.title = "sda"
//            item.label = "fdsdasda"
//            item.paletteLabel = "fdffgdfd"
//            item.target = self
//            item.action = #selector(some)
//            item.image = NSImage(named: "ios")
//            let search = NSSearchField(frame: .init(x: 0, y: 0, width: 100, height: 100))
//            search.controlSize = .large
            let search = NSView()
            item.view = search
            let inner = NSView()
            inner.translatesAutoresizingMaskIntoConstraints = false
            search.addSubview(inner)
            inner.topAnchor.constraint(equalTo: search.topAnchor).isActive = true
            inner.bottomAnchor.constraint(equalTo: search.bottomAnchor).isActive = true
            inner.leftAnchor.constraint(equalTo: search.leftAnchor).isActive = true
            inner.rightAnchor.constraint(equalTo: search.rightAnchor).isActive = true
            inner.heightAnchor.constraint(equalToConstant: 200).isActive = true
            self.s = search
            inner.wantsLayer = true
            inner.layer!.backgroundColor = NSColor.blue.cgColor
            search.translatesAutoresizingMaskIntoConstraints = false
            search.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
            search.setContentHuggingPriority(.defaultHigh, for: .vertical)
            search.heightAnchor.constraint(equalToConstant: 200).isActive = true
            search.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
//            search.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
            
//            item.minSize.height = 100
//            item.minSize.width = 40
//            item.maxSize.height = 1000
//            item.maxSize.width = 9000
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
