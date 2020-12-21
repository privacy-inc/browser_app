import AppKit
import Combine

final class Menu: NSMenu, NSMenuDelegate {
    private var sub: AnyCancellable?
    
    required init(coder: NSCoder) { super.init(coder: coder) }
    init() {
        super.init(title: "")
        items = [app, file, edit, window, help]
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.items = NSSharingService.sharingServices(forItems: [(NSApp.keyWindow as? Window)?.browser.page.value?.url ?? ""]).map {
            let item = NSMenuItem(title: $0.menuItemTitle, action: #selector(share), keyEquivalent: "")
            item.target = self
            item.image = $0.image
            item.representedObject = $0
            return item
        }
        menu.items.append(contentsOf: [
                            .separator(),
                            .init(title: "Copy Link", action: #selector(Window.copyLink), keyEquivalent: "C")])
    }

    private var app: NSMenuItem {
        menu("Privacy", items: [
        .init(title: "About", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: ""),
        .separator(),
        .init(title: "Preferences...", action: #selector(App.preferences), keyEquivalent: ","),
        .separator(),
        .init(title: "Hide", action: #selector(NSApplication.hide), keyEquivalent: "h"),
        {
            $0.keyEquivalentModifierMask = [.option, .command]
            return $0
        } (NSMenuItem(title: "Hide Others", action: #selector(NSApplication.hideOtherApplications), keyEquivalent: "h")),
        .init(title: "Show all", action: #selector(NSApplication.unhideAllApplications), keyEquivalent: ""),
        .separator(),
        .init(title: "Quit", action: #selector(NSApplication.terminate), keyEquivalent: "q")])
    }
    
    private var file: NSMenuItem {
        menu("File", items: [
        .init(title: "New Window", action: #selector(App.newWindow), keyEquivalent: "n"),
        .init(title: "New Tab", action: #selector(App.newTab), keyEquivalent: "t"),
        .init(title: "Open Location", action: #selector(Window.openLocation), keyEquivalent: "l"),
        .separator(),
        .init(title: "Close Window", action: #selector(App.closeWindow), keyEquivalent: "W"),
        .init(title: "Close Tab", action: #selector(Window.close), keyEquivalent: "w"),
        .separator(),
        {
            $0.submenu = .init()
            $0.submenu!.delegate = self
            return $0
        } (NSMenuItem(title: "Share", action: nil, keyEquivalent: ""))])
    }
    
    private var edit: NSMenuItem {
        menu("Edit", items: [
        .init(title: "Undo", action: Selector(("undo:")), keyEquivalent: "z"),
        .init(title: "Redo", action: Selector(("redo:")), keyEquivalent: "Z"),
        .separator(),
        .init(title: "Cut", action: #selector(NSText.cut), keyEquivalent: "x"),
        .init(title: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c"),
        .init(title: "Paste", action: #selector(NSText.paste), keyEquivalent: "v"),
        .init(title: "Delete", action: #selector(NSText.delete), keyEquivalent: ""),
        .init(title: "Select All", action: #selector(NSText.selectAll), keyEquivalent: "a")])
    }
    
    private var window: NSMenuItem {
        menu("Window", items: [
        .init(title: "Minimize", action: #selector(NSWindow.miniaturize), keyEquivalent: "m"),
        .init(title: "Zoom", action: #selector(NSWindow.zoom), keyEquivalent: "p"),
        .separator(),
        .init(title: "Bring All to Front", action: #selector(NSApplication.arrangeInFront), keyEquivalent: "")])
    }
    
    private var help: NSMenuItem {
        menu("Help", items: [])
    }
    
    private func menu(_ name: String, items: [NSMenuItem]) -> NSMenuItem {
        let menu = NSMenuItem()
        menu.submenu = .init(title: name)
        menu.submenu!.items = items
        return menu
    }
    
    @objc private func share(_ item: NSMenuItem) {
        guard let url = (NSApp.keyWindow as? Window)?.browser.page.value?.url else { return }
        (item.representedObject as? NSSharingService)?.perform(withItems: [url])
    }
}
