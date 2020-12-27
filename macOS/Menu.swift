import AppKit
import Combine

final class Menu: NSMenu, NSMenuDelegate {
    private var sub: AnyCancellable?
    
    required init(coder: NSCoder) { super.init(coder: coder) }
    init() {
        super.init(title: "")
        items = [app, file, edit, page, window, help]
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        switch menu.title {
        case "Share":
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
        case "Window":
            menu.items = [
                .init(title: "Minimize", action: #selector(NSWindow.miniaturize), keyEquivalent: "m"),
                .init(title: "Zoom", action: #selector(NSWindow.zoom), keyEquivalent: "p"),
                .separator(),
                .init(title: "Bring All to Front", action: #selector(NSApplication.arrangeInFront), keyEquivalent: ""),
                .separator()]
            NSApp.enumerateWindows { window, _ in
                guard window is Window, window.tabGroup == nil || window == window.tabGroup?.selectedWindow else { return }
                let item = NSMenuItem(title: window.tab.title, action: #selector(focus), keyEquivalent: "")
                item.target = self
                item.representedObject = window
                item.state = NSApp.keyWindow == window ? .on : .off
                menu.items.append(item)
            }
        case "Page":
            let web = (NSApp.keyWindow as? Window)?.web
            menu.items = [
                {
                    $0.target = self
                    $0.isEnabled = web != nil
                    return $0
                } (NSMenuItem(title: "Stop", action: #selector(stop), keyEquivalent: ".")),
                {
                    $0.target = self
                    $0.isEnabled = web != nil
                    return $0
                } (NSMenuItem(title: "Reload", action: #selector(reload), keyEquivalent: "r")),
                .separator(),
                {
                    $0.target = self
                    $0.isEnabled = web != nil && web!.pageZoom != 1
                    return $0
                } (NSMenuItem(title: "Actual Size", action: #selector(actualSize), keyEquivalent: "0")),
                {
                    $0.target = self
                    $0.isEnabled = web != nil && web!.pageZoom < 15
                    return $0
                } (NSMenuItem(title: "Zoom In", action: #selector(zoomIn), keyEquivalent: "+")),
                {
                    $0.target = self
                    $0.isEnabled = web != nil && web!.pageZoom > 0.05
                    return $0
                } (NSMenuItem(title: "Zoom Out", action: #selector(zoomOut), keyEquivalent: "-"))]
        default: break
        }
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
        .init(title: "Open Location", action: #selector(Window.location), keyEquivalent: "l"),
        .separator(),
        .init(title: "Close Window", action: #selector(App.closeWindow), keyEquivalent: "W"),
        .init(title: "Close Tab", action: #selector(Window.close), keyEquivalent: "w"),
        .separator(),
        {
            $0.submenu = .init(title: "Share")
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
    
    private var page: NSMenuItem {
        let page = NSMenuItem()
        page.submenu = .init(title: "Page")
        page.submenu!.delegate = self
        page.submenu!.autoenablesItems = false
        return page
    }
    
    private var window: NSMenuItem {
        let window = NSMenuItem()
        window.submenu = .init(title: "Window")
        window.submenu!.delegate = self
        return window
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
    
    @objc private func focus(_ item: NSMenuItem) {
        (item.representedObject as? Window)?.makeKeyAndOrderFront(nil)
    }
    
    @objc private func stop() {
        (NSApp.keyWindow as? Window)?.web?.stopLoading()
    }
    
    @objc private func reload() {
        (NSApp.keyWindow as? Window)?.web?.reload()
    }
    
    @objc private func actualSize() {
        (NSApp.keyWindow as? Window)?.web?.pageZoom = 1
    }
    
    @objc private func zoomIn() {
        (NSApp.keyWindow as? Window)?.web?.pageZoom *= 1.1
    }
    
    @objc private func zoomOut() {
        (NSApp.keyWindow as? Window)?.web?.pageZoom /= 1.1
    }
}
