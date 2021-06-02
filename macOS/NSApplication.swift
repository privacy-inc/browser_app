import AppKit

extension NSApplication {
    @objc func newTab() {
        let id = tabber.new()
        guard let current = self[id] else {
            guard let window = keyWindow as? Window ?? windows.compactMap({ $0 as? Window }).first else {
                window(id: tabber.new())
                return
            }
            let new = Window(id: tabber.new())
            window.addTabbedWindow(new, ordered: .above)
            window.tabGroup!.selectedWindow = new
            return
        }
        current.makeKeyAndOrderFront(nil)
    }
    
    @objc func newWindow() {
        self[tabber.new()]?.close()
        window(id: tabber.new())
    }
    
    func window(id: UUID) {
        Window(id: id).makeKeyAndOrderFront(nil)
    }
    
    func open(url: URL) {
        let id = tabber.new()
        newTab()
        cloud
            .navigate(url) { browse, _ in
                tabber.browse(id, browse)
            }
    }
    
    @objc func preferences() {
//        (windows.first { $0 is Preferences } ?? Preferences()).makeKeyAndOrderFront(nil)
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
