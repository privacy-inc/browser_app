import AppKit

extension NSMenuItem {
    class func parent(_ title: String, _ items: [NSMenuItem]? = nil, transform: ((NSMenuItem) -> Void)? = nil) -> NSMenuItem {
        let menu = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        menu.submenu = .init(title: title)
        items.map {
            menu.submenu!.items = $0
        }
        transform?(menu)
        return menu
    }
    
    class func child(_ title: String, _ action: Selector? = nil, _ key: String = "", transform: ((NSMenuItem) -> Void)? = nil) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: key)
        transform?(item)
        return item
    }
    
    func synth() {
        (representedObject as? NSMenuItem).map {
            guard let action = $0.action else { return }
            NSApp.sendAction(action, to: $0.target, from: $0)
        }
    }
}
