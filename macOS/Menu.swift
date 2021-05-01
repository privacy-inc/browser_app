import AppKit
import Sleuth

final class Menu: NSMenu, NSMenuDelegate {
    private var url: URL {
        (NSApp.keyWindow as? Window)
            .flatMap(\.browser.entry.value)
            .flatMap(Synch.cloud.entry)
            .flatMap(\.access) ?? URL(string: "https://privacy-inc.github.io/about")!
    }
    
    required init(coder: NSCoder) { super.init(coder: coder) }
    init() {
        super.init(title: "")
        items = [app, file, edit, page, window, help]
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        switch menu.title {
        case "Share":
            menu.items = NSSharingService.sharingServices(forItems: [url]).map { service in
                .child(service.menuItemTitle, #selector(share)) {
                    $0.target = self
                    $0.image = service.image
                    $0.representedObject = service
                }
            } + [
                .separator(),
                .child("Copy Link", #selector(link), "C") {
                    $0.target = self
                }]
        case "Window":
            menu.items = [
                .child("Minimize", #selector(NSWindow.miniaturize), "m"),
                .child("Zoom", #selector(NSWindow.zoom), "p"),
                .separator(),
                .child("Bring All to Front", #selector(NSApplication.arrangeInFront)),
                .separator()] + (0 ..< NSApp.windows.count).compactMap {
                    if let window = NSApp.windows[$0] as? Window {
                        guard window.tabGroup == nil || window == window.tabGroup?.selectedWindow else { return nil }
                        return ($0, window.tab.title)
                    }
                    guard !NSApp.windows[$0].title.isEmpty else { return nil }
                    return ($0, NSApp.windows[$0].title)
                }.map { (index: Int, title: String) in
                    .child(title, #selector(focus)) {
                        $0.target = self
                        $0.tag = index
                        $0.state = NSApp.keyWindow == NSApp.windows[index] ? .on : .off
                    }
                }
        case "Page":
            let web = (NSApp.keyWindow as? Window)?.web
            menu.items = [
                .child("Stop", #selector(stop), ".") {
                    $0.target = self
                    $0.isEnabled = web != nil
                },
                .child("Reload", #selector(reload), "r") {
                    $0.target = self
                    $0.isEnabled = web != nil
                },
                .separator(),
                .child("Actual Size", #selector(actualSize), "0") {
                    $0.target = self
                    $0.isEnabled = web != nil && web!.pageZoom != 1
                },
                .child("Zoom In", #selector(zoomIn), "+") {
                    $0.target = self
                    $0.isEnabled = web != nil && web!.pageZoom < 15
                },
                .child("Zoom Out", #selector(zoomOut), "-") {
                    $0.target = self
                    $0.isEnabled = web != nil && web!.pageZoom > 0.05
                }]
        default: break
        }
    }

    private var app: NSMenuItem {
        .parent("Privacy", [
                    .child("About", #selector(NSApplication.orderFrontStandardAboutPanel(_:))),
                    .separator(),
                    .child("Preferences...", #selector(App.preferences), ","),
                    .separator(),
                    .child("Hide", #selector(NSApplication.hide), "h"),
                    .child("Hide Others", #selector(NSApplication.hideOtherApplications), "h") {
                        $0.keyEquivalentModifierMask = [.option, .command]
                    },
                    .child("Show all", #selector(NSApplication.unhideAllApplications)),
                    .separator(),
                    .child("Quit", #selector(NSApplication.terminate), "q")])
    }
    
    private var file: NSMenuItem {
        .parent("File", [
                    .child("New Window", #selector(App.newWindow), "n"),
                    .child("New Tab", #selector(App.newTab), "t"),
                    .child("Open Location", #selector(Window.location), "l"),
                    .separator(),
                    .child("Close Window", #selector(App.closeWindow), "W"),
                    .child("Close Tab", #selector(Window.close), "w"),
                    .separator(),
                    .parent("Share") {
                        $0.submenu!.delegate = self
                    }])
    }
    
    private var edit: NSMenuItem {
        .parent("Edit", [
                    .child("Undo", Selector(("undo:")), "z"),
                    .child("Redo", Selector(("redo:")), "Z"),
                    .separator(),
                    .child("Cut", #selector(NSText.cut), "x"),
                    .child("Copy", #selector(NSText.copy(_:)), "c"),
                    .child("Paste", #selector(NSText.paste), "v"),
                    .child("Delete", #selector(NSText.delete)),
                    .child("Select All", #selector(NSText.selectAll), "a")])
    }
    
    private var page: NSMenuItem {
        .parent("Page") {
            $0.submenu!.delegate = self
            $0.submenu!.autoenablesItems = false
        }
    }
    
    private var window: NSMenuItem {
        .parent("Window") {
            $0.submenu!.delegate = self
        }
    }
    
    private var help: NSMenuItem {
        .parent("Help")
    }
    
    @objc private func share(_ item: NSMenuItem) {
        (item.representedObject as? NSSharingService)?.perform(withItems: [url])
    }
    
    @objc private func focus(_ item: NSMenuItem) {
        NSApp.windows[item.tag].makeKeyAndOrderFront(nil)
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
    
    @objc private func link() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(url.absoluteString, forType: .string)
    }
}
