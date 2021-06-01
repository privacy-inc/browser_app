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
        let id = tabber.new()
        guard let current = self[id] else {
            window(id: id)
            return
        }
        current.makeKeyAndOrderFront(nil)
    }
    
    func window(id: UUID) {
        Window(id: id).makeKeyAndOrderFront(nil)
    }
    
    func open(tab url: URL) {
//        guard let key = keyWindow as? Window,
//              key.browser.entry.value == nil
//        else {
//            if let empty = windows
//                .compactMap({ $0 as? Window })
//                .first(where: { $0.browser.entry.value == nil }) {
//
//                Cloud.shared.navigate(url) {
//                    empty.browser.entry.value = $0
//                }
//            } else if let window = windows.compactMap({ $0 as? Window }).first {
//                window.newTab(url)
//            } else {
//                window(url)
//            }
//            return
//        }
//
//        Cloud.shared.navigate(url) {
//            key.browser.entry.value = $0
//        }
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
