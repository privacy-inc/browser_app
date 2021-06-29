import AppKit

extension NSApplication {
    var dark: Bool {
        effectiveAppearance.name != .aqua
    }
    
    @objc func newTab() {
        newTab(id: tabber.new(), search: true, change: true)
    }
    
    @objc func newWindow() {
        closeNew()
        window(id: tabber.new())
    }
    
    func window(id: UUID) {
        Window(id: id).makeKeyAndOrderFront(nil)
    }
    
    func open(tab url: URL, change: Bool) {
        let id = tabber.new()
        cloud
            .navigate(url) { browse, _ in
                tabber.browse(id, browse)
                self.newTab(id: id, search: false, change: change)
            }
    }
    
    func open(window url: URL) {
        closeNew()
        let id = tabber.new()
        cloud
            .navigate(url) { browse, _ in
                tabber.browse(id, browse)
                self.window(id: id)
            }
    }
    
    func activity() {
        (window() ?? Activity())
            .makeKeyAndOrderFront(nil)
    }
    
    func trackers() {
        (window() ?? Trackers())
            .makeKeyAndOrderFront(nil)
    }
    
    func froob() {
        (window() ?? Info.Froob())
            .makeKeyAndOrderFront(nil)
    }
    
    func why() {
        (window() ?? Info.Why())
            .makeKeyAndOrderFront(nil)
    }
    
    func alternatives() {
        (window() ?? Info.Alternatives())
            .makeKeyAndOrderFront(nil)
    }
    
    func store() {
        (window() ?? Store())
            .makeKeyAndOrderFront(nil)
    }
    
    func clear() {
        windows
            .compactMap {
                $0 as? Window
            }
            .filter {
                tabber
                    .items
                    .value[state: $0.id]
                    .browse != nil
            }
            .forEach {
                $0.close()
            }
    }
    
    @objc func preferences() {
        (window() ?? Settings())
            .makeKeyAndOrderFront(nil)
    }
    
    private var active: Window? {
        keyWindow as? Window ?? window()
    }
    
    private func window<T>() -> T? {
        windows
            .compactMap {
                $0 as? T
            }
            .first
    }
    
    private func newTab(id: UUID, search: Bool, change: Bool) {
        guard let current = self[id] else {
            guard let window = active else {
                window(id: id)
                return
            }
            let new = Window(id: id)
            window.addTabbedWindow(new, ordered: .above)
            if change {
                window.tabGroup!.selectedWindow = new
            }
            return
        }
        if change {
            current.makeKeyAndOrderFront(nil)
            if search {
                current.makeFirstResponder(current.search.field)
            }
        }
    }
    
    private func closeNew() {
        self[tabber.new()]?
            .close()
    }
    
    private subscript(_ id: UUID) -> Window? {
        windows
            .compactMap {
                $0 as? Window
            }
            .first {
                $0.id == id
            }
    }
}
